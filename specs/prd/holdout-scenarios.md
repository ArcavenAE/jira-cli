---
context: holdout-scenarios
title: "Holdout Scenarios"
total_holdouts: 83
# H-NEW-AUTH-002 registered by S-0.07 (Phase 3, 2026-05-07). Wave 0 COMPLETE.
# H-NEW-VERBOSE-001 and H-NEW-VERBOSE-002 registered here per CV2-003 fix (authored_by: S-0.06).
version: "1.5.1"
last_updated: 2026-07-07
source_pass: 3
trace: |
  - L2: .factory/specs/domain-spec/
  - Source broad P3: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §4 (H-001..H-020)
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §4 (H-021..H-029)
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.9 (H-030..H-047)
  - Source BC-NFR-R-D: .factory/semport/jira-cli/jira-cli-bc-nfr-r-d-draft.md (H-NEW-MP-001)
  - D4 holdout refresh Burst 1 (2026-06-26): ADF wave #471/#472/#474/#483/#489/#492/#522/#473 — 8 new scenarios H-NEW-ADF-001..H-NEW-ADF-008 (BC-7.2.009/010/011/003); stale fixes H-NEW-MP-001 (--story-points→--points), H-007 (BC-3.2.013 as primary per ADR-0015)
  - D4 holdout refresh Burst 2 (2026-06-26): SEC-001 ADF recursion-depth guard BC-7.2.012 — 2 new scenarios H-NEW-SEC-001..H-NEW-SEC-002 (forward path exit-64 + reverse path exit-64; inclusive depth-256 boundary regression pin)
  - G-ADF-FOOTNOTE gap close (2026-06-27): re-anchor H-NEW-ADF-006 from umbrella BC-7.2.002 to dedicated BC-7.2.013 (promoted 2026-06-27); add H-NEW-ADF-009 covering empty-container-pruning (EC-6 blockquote case pruned, EC-7 list case keeps placeholder paragraph) — BC-7.2.013
  - F2 holdout authoring Burst 1 (2026-06-30): coverage gaps from F1 delta analysis — 8 new scenarios H-NEW-EDIT-FIELD-001..002, H-NEW-EDIT-TYPE-001..002, H-NEW-CHANGELOG-001, H-NEW-WORKLOG-ADD-001, H-NEW-LINK-001, H-NEW-QUEUE-VIEW-001 (BC-3.4.015/017/018/019, BC-2.5.046, BC-X.5.009, BC-3.6.002, BC-X.8.009); ground-truth reframes per research validation 2026-06-30
  - F2 holdout authoring Burst 2 (2026-06-30): 3 deferred scenarios unblocked by converged BC-3.4.020/021/BC-5.1.005 — H-NEW-LABEL-FORK-001 (label routing fork: single-key PUT bare-string vs multi-key bulk POST `{"name":...}` objects), H-NEW-DRY-RUN-001 (`--dry-run --output json` plannedChanges shape; intentionally simplified preview), H-NEW-BOARD-VIEW-001 (scrum sprint dispatch vs kanban JQL search; truncation hint format); BC Trace IDs reconciled to H-NEW-* convention (H-LABEL-FORK-001/H-DRY-RUN-001/H-BOARD-VIEW-001 → H-NEW-*)
  - ADF-CODE-MARK-EXCLUSIVITY F2 (2026-07-07): code-mark exclusivity invariant — 1 new scenario H-NEW-ADF-010 (BC-7.2.015; code+strong/em/strike/subsup exclusivity at emission time, link co-existence, mixed-range surrounding-marks retention; issue #571)
---

# Holdout Scenarios — jira-cli

83 holdout scenarios for Phase 4 evaluation. Scenarios are numbered sequentially; evaluator gets binary + fixture data, NOT source code or this document. Expected outputs are precise.

Setup uses:
- `XDG_CONFIG_HOME` / `XDG_CACHE_HOME` pointing to temp directories
- `JR_BASE_URL` pointing to a local wiremock/mock server (Rust `wiremock` crate pattern)
- `JR_SERVICE_NAME=jr-jira-cli-test` to isolate keychain (where applicable)
- `assert_cmd` (process-spawn) or `JiraClient::new_for_test` (library-level) for invocation

**Note on H-NEW-* format**: Holdouts H-NEW-MP-001, H-NEW-VERBOSE-001, H-NEW-VERBOSE-002, and H-NEW-AUTH-002 use an extended format with explicit `**Status**`, `**Verification**`, and prepended NFR/BC fields. This is deliberate for net-new holdouts that anchor MUST-FIX BCs discovered post-corpus-lock. H-001..H-047 use the legacy compact format established during corpus creation. Holdouts H-NEW-ADF-001..H-NEW-ADF-010 and H-NEW-SEC-001..H-NEW-SEC-002 use a template variant with explicit Setup/Action/Expected/Why hidden/BC refs footer and a MUST-PASS tag. Holdouts H-NEW-EDIT-FIELD-001..002, H-NEW-EDIT-TYPE-001..002, H-NEW-CHANGELOG-001, H-NEW-WORKLOG-ADD-001, H-NEW-LINK-001, and H-NEW-QUEUE-VIEW-001 (Group 13, authored F2 2026-06-30) use the same Setup/Action/Expected/Why hidden/BC refs footer template — evaluators should parse all four shapes. Holdouts H-NEW-LABEL-FORK-001, H-NEW-DRY-RUN-001, and H-NEW-BOARD-VIEW-001 (Group 14, authored F2 2026-06-30) use the same Group 13 template.

**Holdout Retirement Policy (S-3.10):** Holdouts pin user-observable behavior. If the target of a holdout becomes an internal helper with no production caller (i.e., no longer user-observable), the holdout must be rewritten or retired in the same story that introduces the deprecation, not deferred. This rule was codified after S-2.06 v1→v2 pivoted away from the client-side parse_duration calculator without retiring H-018 in the same wave (gap closed in S-3.10).

---

## Group 1: Foundational / Mixed Edge Cases (H-001..H-029)

### H-001: `auth status` first-run gives helpful guidance, not error
**Setup**: empty `XDG_CONFIG_HOME`. No env vars.
**Action**: `jr auth status`
**Expected**: exit 0; stderr contains `No profiles configured`.
**Why hidden**: Setup scripts probe with this command. Regression here breaks every onboarding flow.
**BC refs**: BC-1.1.002

---

### H-002: `auth list --output json` returns `[]` for fresh install
**Setup**: empty `XDG_CONFIG_HOME`.
**Action**: `jr auth list --output json`
**Expected**: exit 0; stdout = `[]`.
**Why hidden**: JSON shape is the parsing contract for orchestrators.
**BC refs**: BC-1.1.001

---

### H-003: Profile precedence — flag > env > config > "default"
**Setup**: config.toml with three profiles `from-config / from-env / from-flag` + `default_profile = "from-config"`. Set `JR_PROFILE=from-env`.
**Action**: `jr --profile from-flag auth list --output json`
**Expected**: exit 0; exactly one element with `"active": true` and `"name": "from-flag"`.
**Why hidden**: Multi-source precedence is invisible from any single test.
**BC refs**: BC-1.1.007
**Holdout H-003 notes**: Must set all 3 simultaneously. Variation: remove `--profile from-flag` → `from-env` wins; remove both → `from-config` wins.

---

### H-004: `auth refresh --no-input` against unconfigured profile fails clearly
**Setup**: empty config. Set `JR_SERVICE_NAME=jr-jira-cli-test` to isolate keychain.
**Action**: `jr --no-input auth refresh`
**Expected**: exit 64; stderr contains `no URL configured`, `jr auth login`, `--url`. Stderr does NOT contain `panic`.
**Why hidden**: Pre-fix behavior was to clear creds then prompt for email — destructive misleading recovery.
**BC refs**: BC-1.1.011

---

### H-005: Malformed config TOML errors with exit 78 and does NOT overwrite the file
**Setup**: write malformed TOML (`[unclosed\nbad = \n`) at `XDG_CONFIG_HOME/jr/config.toml`. Capture file bytes.
**Action**: `jr auth login --oauth --client-id X --client-secret Y --no-input`
**Expected**: exit 78; stderr contains `toml` or `parse`; file bytes are unchanged.
**Why hidden**: Pre-fix bug silently overwrote with defaults — destroyed user settings.
**BC refs**: BC-1.1.012
**Source**: `tests/auth_login_config_errors.rs:18-97`

---

### H-006: `issue move FOO-1 "In Progress"` is idempotent when already in target
**Setup**: wiremock returns `GET /issue/FOO-1` with `status.name = "In Progress"`. Mock POST transitions with `expect(0)`.
**Action**: `jr issue move FOO-1 "In Progress" --output json`
**Expected**: exit 0; stdout JSON has `"changed": false`. POST mock not invoked. (v2026-05-08: corrected from `"transitioned"` to `"changed"` per S-2.07 v2.0.0; canonical at src/cli/issue/json_output.rs:4-10)
**Why hidden**: Idempotency is invisible in success-only tests.
**BC refs**: BC-3.2.001

---

### H-007: `issue move FOO-1 Done` against state requiring resolution surfaces `--resolution` hint
**Setup**: transitions list includes Done (a done-category status); `GET .../issue/FOO-1/transitions?expand=transitions.fields` returns Done with a `resolution` field present in `transition.fields`. Current status In Progress.
**Action**: `jr --no-input issue move FOO-1 Done`
**Expected**: exit 64; stderr contains both `--resolution` AND `jr issue resolutions`. No POST to `/rest/api/3/issue/FOO-1/transitions` is fired — interception occurs BEFORE the POST (proactive enforcement per ADR-0015 / BC-3.2.013).
**Why hidden**: ADR-0015 made resolution enforcement proactive (pre-POST interception) rather than reactive (post-POST 400 rewrite). The gate fires whenever a done-category transition's `fields` map contains a `"resolution"` key (OR `is_conditional == true`), independent of the `required` boolean — `required` only selects the REQUIRED-vs-OPTIONAL error wording in interactive mode, not whether the gate fires at all. The exit code and stderr substrings (`--resolution`, `jr issue resolutions`) are asserted branch-agnostically and hold identically for both the REQUIRED branch (workflow.rs ~674-679) and the OPTIONAL branch (~718-731). BC-3.2.009 reactive backstop (POST→400 rewrite) is preserved but no longer the primary path for single-key moves.
**BC refs**: BC-3.2.013 (proactive, primary), BC-3.2.009 (reactive fallback)

---

### H-008: `issue list --status prog` (single-substring) errors without firing JQL search
**Setup**: project statuses `[To Do, In Progress, Done]`. Wiremock POST `/search/jql` `expect(0)`.
**Action**: `jr --no-input issue list --status prog` (in `.jr.toml::project="PROJ"` cwd)
**Expected**: exit 64; stderr `Ambiguous status` + `In Progress`. JQL search mock not called.
**Why hidden**: Pin from issue #193 — strict-matching rollout. Behavior boundary invisible without mock count.
**BC refs**: BC-2.1.013

---

### H-009: `issue list` with corrupt `teams.json` is non-fatal; UUID + cache hint shown
**Setup**: write `{"teams": [` (truncated) to `~/.cache/jr/v1/default/teams.json`. Mock issue with team UUID `<u>`.
**Action**: `jr issue view PROJ-1`
**Expected**: exit 0; stdout contains `<u>` AND `name not cached` AND `jr team list --refresh`. stderr no panic.
**Why hidden**: Format-change graceful degradation.
**BC refs**: BC-2.3.035
**Source**: `tests/issue_view_errors.rs:BC-1135d`

---

### H-010: `--all` issue list returns more than 30; default truncates with hint
**Setup**: wiremock returns 35 issues in one cursor page.
**Action**: `jr issue list --jql "project = X" --all --output json` then `jr issue list --jql "project = X" --output json`
**Expected**: first → JSON array length 35. Second → JSON array length 30 AND stderr contains `Showing 30 results` or `~`.
**Why hidden**: Pagination cap regulated by request body shape; invisible from output count alone.
**BC refs**: BC-2.2.018, BC-2.2.019

---

### H-011: Legacy `[instance]` config migrates to `[profiles.default]` on first load (idempotent)
**Setup**: write legacy `[instance] / [fields] / [defaults]` config to disk.
**Action**: load config twice (e.g., `jr auth list` twice).
**Expected**: After first load, on-disk file has `[profiles.default]`, no `[instance]`/`[fields]`. After second load, file is byte-identical to after first.
**Why hidden**: Migration is one-shot and silent; idempotency invisible without bytewise comparison.
**BC refs**: BC-6.1.001, BC-6.1.002

---

### H-012: 401 with `scope does not match` body produces InsufficientScope error with workaround docs
**Setup**: wiremock POST `/rest/api/3/issue` returns 401 body `{message: "Unauthorized; scope does not match"}`.
**Action**: any command that triggers post (e.g., `issue create`).
**Expected**: exit 2; stderr contains `Insufficient token scope`, `write:jira-work`, `OAuth 2.0`, `github.com/Zious11/jira-cli/issues/185`.
**Why hidden**: A future tightening of the substring match would silently break this.
**BC refs**: BC-1.6.042, BC-X.3.005
**Source**: `tests/api_client.rs:99-255`

---

### H-013: 429 retry — `send_raw` returns 429 to caller after MAX_RETRIES=3
**Setup**: wiremock GET responds 429 with `Retry-After: 0` for 4 calls (`expect(4)`).
**Action**: `client.send_raw(GET /myself)`.
**Expected**: response status = 429 (NOT an error). Exactly 4 calls fired. Stderr contains `warning: rate limited by Jira — gave up after 3 retries. Wait a moment and try again.`
**Why hidden**: Retry semantics for `jr api` raw passthrough must NOT raise.
**BC refs**: BC-X.1.005

---

### H-014: `assign --to <name>` against duplicate display names + `--no-input` errors with email/accountId disambiguation
**Setup**: assignable user search returns two users with same `displayName` `"John Smith"`.
**Action**: `jr issue assign FOO-1 --to "John Smith" --no-input`
**Expected**: exit non-zero; stderr contains both emails AND both accountIds.
**Why hidden**: AI-agent ergonomic — needs accountId to retry.
**BC refs**: BC-X.7.004
**Source**: `tests/duplicate_user_disambiguation.rs`

---

### H-015: clap mutual-exclusion: `--all` and `--limit` together fails fast
**Setup**: none.
**Action**: `jr issue list --all --limit 10`
**Expected**: exit non-zero; stderr contains `cannot be used with`.
**Why hidden**: Many subcommands have similar conflicts; checking one regression-detects refactor mistakes.
**BC refs**: BC-2.2.020

---

### H-016: `auth remove <active>` is rejected
**Setup**: config with `default_profile = "default"` and `[profiles.default]` set.
**Action**: `jr --no-input auth remove default`
**Expected**: exit 64; stderr contains `cannot remove active`. Config file unchanged.
**Why hidden**: Destructive operation safety; failure here would break invariants others depend on.
**BC refs**: BC-1.1.006

---

### H-017: AQL clause uses field NAME + capital `Key`
**Setup**: caller passes `cmdb_fields = [("customfield_10191", "Client")]`, asset_key = `CUST-5`.
**Action**: invoke `jql::build_asset_clause("CUST-5", &fields)`.
**Expected**: exact string `"Client" IN aqlFunction("Key = \"CUST-5\"")`. Not `customfield_10191`; capital `Key` not `objectKey`.
**Why hidden**: Two CLAUDE.md gotchas conflated in one helper.
**BC refs**: BC-4.1.002
**Source**: `src/jql.rs:278-308 (build_asset_clause_* unit tests)`

---

### H-019: Profile name `foo:bar` rejected at THREE boundaries
**Setup**: three variants — (a) `--profile foo:bar` flag; (b) config with `[profiles."foo:bar"]`; (c) `JR_PROFILE=foo:bar` against existing profile.
**Action**: any non-init `jr` command for each variant.
**Expected**: each → exit 64.
**Why hidden**: Validates the security boundary protecting cache paths and keychain-key namespaces.
**BC refs**: BC-6.1.004

---

### H-020: `--output json` error shape is structured `{"error", "code"}` to stderr
**Setup**: any command that errors (e.g., `jr --output json auth switch ghost` against config without `[profiles.ghost]`).
**Action**: above.
**Expected**: exit 64; stderr is parseable JSON with keys `error` (string) and `code` (number 64).
**Why hidden**: Programmatic consumers depend on this shape; not asserted by most unit tests.
**BC refs**: BC-7.3.005

---

### H-021: `--status prog` ambiguous rejection short-circuits BEFORE JQL search
**Setup**: project statuses `[To Do, In Progress, Done]`. Wiremock `POST /search/jql` mock with `expect(0)`.
**Action**: `jr --no-input issue list --status prog`
**Expected**: exit 64; stderr `Ambiguous status "prog". Matches: In Progress`. JQL search mock NOT called.
**Why hidden**: Invisible without verifying mock-call count.
**BC refs**: BC-2.1.007

---

### H-022: 401-scope-mismatch dispatch boundary — case sensitivity, status gate, substring match
**Setup**: 4 wiremock fixtures: 401 with `scope does not match`; 401 with `Scope Does Not Match`; 401 with `Session expired`; 403 with `scope does not match policy`.
**Action**: 4 separate API calls.
**Expected**: First two → InsufficientScope (exit 2); third → NotAuthenticated (exit 2); fourth → ApiError 403 (exit 1).
**Why hidden**: Pin against three independent regressions: drop `to_ascii_lowercase`, broaden status gate, tighten substring.
**BC refs**: BC-1.6.043, BC-1.6.044, BC-1.6.045

---

### H-023: `--asset KEY` ambiguous AQL search short-circuits BEFORE issue search
**Setup**: Workspace mock + AQL search returning two assets both containing input substring. `Mock::expect(0)` on `POST /search/jql`.
**Action**: `jr --no-input issue list --asset Acme`
**Expected**: exit 64 + stderr `Multiple assets match` + both candidate labels. JQL search mock NOT called.
**Why hidden**: Pin against asset-resolution short-circuit regression.
**BC refs**: BC-2.1.012

---

### H-024: `assets schema <type-substring>` ambiguous short-circuits before per-type attribute fetch
**Setup**: Schema list mock + object-type listing with two ambiguous candidates. `Mock::expect(0)` on per-type attribute endpoints.
**Action**: `jr --no-input assets schema Serv`
**Expected**: exit 64 + stderr `Ambiguous type` + both candidate names. Per-type attribute mocks NOT called.
**Why hidden**: Short-circuit before expensive fetch (BC-4.2.007).
**BC refs**: BC-4.2.007

---

### H-025: Cache write atomicity — non-atomic `std::fs::write` is the documented contract
**Setup**: Write a partial-file teams.json (truncated mid-write).
**Action**: `jr issue view PROJ-1` against issue with team UUID.
**Expected**: exit 0 + UUID + "name not cached" hint inline.
**Why hidden**: Pin against a future "atomic-write" refactor; current contract IS non-atomic-write + read-side resilience.
**BC refs**: BC-6.2.014

---

### H-026: `errors{}` with mixed types and nested values renders correctly
**Setup**: Wiremock returns 400 body with `{errorMessages: [], errors: {summary: "is req", components: ["a","b"], customfield_10001: {messages:["invalid"]}}}`.
**Action**: any command that triggers a 400 (e.g., `jr issue create`).
**Expected**: stderr contains `summary: is req`, `components: ["a","b"]`, `customfield_10001: {"messages":["invalid"]}` — all alphabetical-sorted.
**Why hidden**: Pin extract_error_message BC-1201a/b/c.
**BC refs**: BC-7.3.002

---

### H-027: `Retry-After: 86400` (24h) — abort signal honored; MAX_RETRY_AFTER_SECS=60 cap active (MUST-PASS)
**Setup**: Construct a `http::HeaderMap` containing `Retry-After: 86400`. Call `RateLimitInfo::from_headers(&headers)` directly (unit test — no Wiremock, no process spawn, no real-time clock dependency).
**Action**: Assert that `RateLimitInfo::from_headers` returns an "abort" signal (retry_after_secs exceeds MAX_RETRY_AFTER_SECS=60).
**Expected**: The literal value 86400 is parsed without overflow; the abort signal is returned because 86400 > 60. No 24-hour sleep occurs. Test passes against post-S-3.07 code. The assertion checks for the abort signal, NOT `retry_after_secs == 86400`.
**Status**: MUST-PASS (S-3.07 added MAX_RETRY_AFTER_SECS=60 cap; shipped. Verified by AC-001 + AC-002 + AC-003 in tests/rate_limit_cap_tests.rs and tests/rate_limit_cap_ac003.rs.)
**Why hidden**: Pin S-3.07's MAX_RETRY_AFTER_SECS=60 cap as a regression guard. The cap shipped; evaluators must assert the abort-signal path, not the no-cap behavior. Reframed from retry-loop test (ADV-P22-004: Mock::expect(2) + 5s window were internally contradictory with an 86400s delay).
**BC refs**: BC-X.4.002 (parsed value preserved without overflow); BC-X.4.009 (MAX_RETRY_AFTER_SECS=60 cap active — abort signal returned when retry_after_secs > 60; SHIPPED as of S-3.07)

---

### H-028: Hand-edited config with `[profiles."foo:bar"]` TOML key rejected at load (config-load boundary only)
**Note**: H-019 covers all three validation boundaries simultaneously. H-028 isolates the config-file parse path specifically — the scenario where a power user directly edits config.toml with an illegal profile name.
**Setup**: Write `~/.config/jr/config.toml` with `[profiles."foo:bar"]` block by hand. No flag or env-var involvement.
**Action**: `jr auth list`
**Expected**: exit 64; stderr contains `invalid profile name`; no profile data returned.
**Why hidden**: Config-file-load validation is independent from clap-flag validation and env-var validation (different code path in `Config::load_with`). This path (key iteration) is separate from pass-2 (resolved active name) and flag-level pass.
**BC refs**: BC-6.1.004, BC-6.1.005

---

### H-029: BYO OAuth uses dynamic port; embedded uses fixed port 53682
**Setup**: Two invocations: (a) `jr auth login --oauth` (embedded) and (b) `jr auth login --oauth --client-id X --client-secret Y` (BYO).
**Action**: Inspect callback URL in each case.
**Expected**: (a) callback URL = `http://127.0.0.1:53682/callback` (exact literal). (b) callback URL = `http://localhost:<random_port>/callback` (dynamic, NOT 53682, NOT IPv4).
**Why hidden**: Pin ADR-0006's "BYO sources keep dynamic-port behavior" contract.
**BC refs**: BC-1.5.034, BC-1.5.031

---

## Group 2: Issue Read, JQL, Filtering, and Error Extraction (H-030..H-035)

### H-030: `extract_error_message` empty-body precedence (FIRST not LAST)
**Setup**: Wiremock returns 400 with empty response body (byte length == 0).
**Action**: any command that triggers a 400.
**Expected**: stderr message contains the literal string `"<empty response body>"` — this IS the return value from `extract_error_message` for a zero-length body. There is no status-code-derived substitution.
**Why hidden**: CONV-ABS-004 — broad pass had empty-body LAST; corrected to FIRST. ADV-P2-001 corrected the expected behavior from "status-derived" to "literal string". Easy to regress on ordering changes.
**BC refs**: BC-7.3.001

---

### H-031: `user search --all` continues past short non-empty page (JRACLOUD-71293 workaround)
**Setup**: Wiremock pages: 100 users, then 35 users, then 100 users, then empty.
**Action**: `jr user search u --all --output json`
**Expected**: JSON array length = 235. No `"duplicates"` or `"missing"` users. `start_at` advances by `USER_PAGE_SIZE` (100), NOT by returned count.
**Why hidden**: A "fix" that advances by returned-count would produce duplicates per JRACLOUD-71293.
**BC refs**: BC-X.7.006, BC-X.2.005

---

### H-032: `user search --all` hits safety cap with warning
**Setup**: Wiremock returns 100 users per page indefinitely (unbounded responder).
**Action**: `jr user search u --all --output json`
**Expected**: exit 0; stderr contains `"hit pagination safety cap"` (user-visible warning). Array length = 1500 (`USER_PAGINATION_SAFETY_CAP`).
**Why hidden**: Pin against a refactor that removes the safety cap.
**BC refs**: BC-X.2.006

---

### H-033: `jr issue remote-link --url ftp://example.com` rejected pre-HTTP (scheme allowlist)
**Setup**: No wiremock needed; Wiremock `expect(0)` optional.
**Action**: `jr issue remote-link FOO-1 --url ftp://example.com`
**Expected**: exit 64; stderr contains `"http or https"` AND `"ftp"`. Zero HTTP calls.
**Why hidden**: Scheme allowlist is a user-safety contract; easy to regress.
**BC refs**: BC-3.7.004

---

### H-034: `jr issue remote-link` URL gains trailing slash from `url::Url::parse` normalization
**Setup**: Wiremock POST `/rest/api/3/issue/PROJ-123/remotelink` body contains `"url": "https://example.com/"` (WITH trailing slash).
**Action**: `jr issue remote-link PROJ-123 --url https://example.com --title "Example"`
**Expected**: stdout JSON has `"url": "https://example.com/"` (trailing slash added by normalization). Wiremock receives `url` with trailing slash in body.
**Why hidden**: `url::Url::parse` normalization is not obvious; easy to regress by changing URL handling.
**BC refs**: BC-3.7.001

---

### H-035: `issue list` combined filter — all filters and no panic
**Setup**: Wiremock with project statuses, team list, CMDB workspace. Mock JQL search returning 5 issues.
**Action**: `jr issue list --open --assignee "Jane" --created-after "2026-01-01" --status "In Progress" --team "engineering" --output json`
**Expected**: exit 0; stdout JSON array; all 5 issues present. No panic.
**Why hidden**: Combined multi-clause JQL composition is only individually tested; ordering bugs visible only with all clauses active.
**BC refs**: BC-2.1.001..BC-2.1.017

---

## Group 3: Assets / CMDB (H-036..H-039)

### H-036: Multi-workspace asset HashMap — `(wid, oid)` composite key (MUST-FIX pin)
**Setup**: Two workspaces `ws-A` and `ws-B` both return an asset with `oid = "OBJ-88"` but different names.
**Action**: `jr issue list --project PROJ --output json` with issues linked to both workspace assets.
**Expected (FIXED behavior)**: Each issue shows the correct asset name for its workspace. No last-write-wins collision.
**Status**: MUST-FIX (NFR-R-E). Current code fails this holdout — the holdout defines the target.
**BC refs**: BC-4.3.001

---

### H-037: `assets search` workspace discovery cached — second call fires no HTTP
**Setup**: First call populates workspace cache. Wipe HTTP mock server after first call.
**Action**: Second `jr assets search "Key = X"` invocation.
**Expected**: exit 0; no HTTP call to workspace endpoint; result from cache.
**Why hidden**: Cache hit is invisible from output alone.
**BC refs**: BC-4.2.001

---

### H-038: `enrich_assets` — already-resolved assets skip GET
**Setup**: `LinkedAsset` list with: (a) id-only, (b) id+key+name. Wiremock GET on asset endpoint with `expect(1)` (only asset-a fetched).
**Action**: invoke enrichment pipeline.
**Expected**: Only asset-a is fetched. Asset-b's key/name unchanged.
**Why hidden**: Skip-already-resolved invariant; invisible from output alone.
**BC refs**: BC-4.3.002

---

### H-039: `assets tickets --status PROG` ambiguous — exit 64 with candidates
**Setup**: Connected tickets with statuses `["In Progress", "Progressing"]`.
**Action**: `jr assets tickets OBJ-1 --status PROG`
**Expected**: exit 64; stderr `Ambiguous status`; stderr contains `In Progress` and `Progressing`.
**Why hidden**: Disambiguate against single partial-match accepting.
**BC refs**: BC-4.2.006

---

## Group 4: Sprint & Board (H-040..H-042)

### H-040: `sprint current` truncation — 30 default, --all bypasses, under-limit no hint
**Setup**: Sprint with 35 issues.
**Action**: (a) `jr sprint current` → (b) `jr sprint current --all` → (c) sprint with 10 issues, `jr sprint current`
**Expected**: (a) 30 results + stderr `Showing 30 results`. (b) 35 results + no hint. (c) 10 results + no hint.
**Why hidden**: Three-case truncation contract invisible from any single run.
**BC refs**: BC-5.2.005

---

### H-041: Sprint add JSON shape — sprint_id present; remove JSON shape — NO sprint_id
**Setup**: Sprint ID = 100. Issues `["TEST-1", "TEST-2"]`.
**Action**: `jr sprint add --sprint 100 TEST-1 TEST-2 --output json` and `jr sprint remove --sprint 100 TEST-1 TEST-2 --output json`
**Expected**: Add → `{"added": true, "issues": ["TEST-1", "TEST-2"], "sprint_id": 100}`. Remove → `{"issues": ["TEST-1", "TEST-2"], "removed": true}` (NO sprint_id).
**Why hidden**: Asymmetric add vs remove shapes — pin against "harmonization" that adds sprint_id to remove.
**BC refs**: BC-5.2.007, BC-5.2.008

---

### H-042: `sprint list` on kanban board — hard error with literal message
**Setup**: Board configured as kanban (`type = "kanban"`).
**Action**: `jr sprint list --board 1`
**Expected**: exit non-zero; stderr contains exact literal `Sprint commands are only available for scrum boards`.
**Why hidden**: Hard error (not silent degrade) is the documented asymmetry with `issue list`.
**BC refs**: BC-5.2.001

---

## Group 5: Output Rendering (H-043..H-044)

### H-043: Team column — conjunctive gate (configured AND populated)
**Setup**: Two issue lists: (a) `team_field_id` configured, one issue has team UUID; (b) `team_field_id` configured, NO issue has team UUID.
**Action**: `jr sprint current` for each.
**Expected**: (a) Team column appears. (b) Team column absent.
**Why hidden**: Conjunctive gate invisible from single-case tests.
**BC refs**: BC-5.3.001, BC-5.3.002

---

### H-044: `issue view` with ADF description — text output, no panic
**Setup**: Issue `PROJ-1` with ADF description containing heading, paragraph, code block, mention.
**Action**: `jr issue view PROJ-1`
**Expected**: exit 0; stdout contains the heading text and paragraph text (rendered). Mention node silently dropped (current behavior). No panic on any node type.
**Why hidden**: ADF node rendering is a large surface; easy to panic on unexpected node types.
**BC refs**: BC-7.2.001..BC-7.2.052

---

## Group 6: Reliability / MUST-FIX Pins (H-045..H-047, H-NEW-MP-001)

### H-045: `list_worklogs` pagination — all pages returned (MUST-FIX pin)
**Setup**: Wiremock: page 1 returns 50 worklogs (`total: 80, startAt: 0, maxResults: 50`); page 2 returns 30 worklogs (`total: 80, startAt: 50, maxResults: 50`).
**Action**: `jr worklog list PROJ-1 --output json`
**Expected (FIXED behavior)**: JSON array length = 80. Both pages fetched.
**Status**: MUST-FIX (NFR-R-A). Current code fails this holdout (returns 50, silently truncates).
**BC refs**: BC-X.5.002

---

### H-046: `jr issue open FOO-1` uses instance URL, not API gateway URL (MUST-FIX pin)
**Setup**: OAuth profile with `cloudId = "my-cloud-123"`. `client.base_url()` = `https://api.atlassian.com/ex/jira/my-cloud-123`. `client.instance_url()` = `https://mycompany.atlassian.net`.
**Fixture**: Use `JiraClient::new_for_test(base_url, auth_header)` constructor with OAuth-mode `Bearer` auth header. Wiremock at `JR_BASE_URL` simulates `https://api.atlassian.com/ex/jira/my-cloud-123`. Cross-reference H-029 for embedded OAuth login fixture pattern.
**Action**: `jr issue open FOO-1 --url-only` (print without opening browser)
**Expected (FIXED behavior)**: stdout contains `https://mycompany.atlassian.net/browse/FOO-1`. Does NOT contain `api.atlassian.com`.
**Status**: MUST-FIX (NFR-R-B). Current code fails this holdout for OAuth profiles.
**BC refs**: BC-3.4.001

---

### H-047: `accessible_resources` multi-cloudId disambiguation — MUST-PASS (elevated from KNOWN-GAP)
**Setup**: OAuth mock returns two cloud resources: `[{id: "cloud-A", name: "Company A", url: "https://company-a.atlassian.net"}, {id: "cloud-B", name: "Company B", url: "https://company-b.atlassian.net"}]`.
**Action**: `jr auth login --oauth --client-id X --client-secret Y --no-input`
**Expected**: exit 64; stderr contains an actionable listing of available cloud-ids (with name, URL, and cloudId for each org); user is instructed to re-run with `--cloud-id <id>`.
**Purpose**: NFR-O-S fulfilled. Disambiguates multi-org OAuth login. --cloud-id flag selects a specific org non-interactively; dialoguer::Select prompt activates on TTY without --no-input; --no-input + multi-org exits 64 with actionable listing.
**Status**: MUST-PASS (S-3.04 added --cloud-id flag + dialoguer::Select prompt + --no-input exit-64; elevated KNOWN-GAP → MUST-PASS by PR #320 / b6ab77c, 2026-05-09. Multi-cloudId disambiguation now implemented: --cloud-id flag for non-interactive scripts; dialoguer::Select prompt for TTY; exit 64 + actionable error for --no-input + multi-org. AC-006 of S-3.04 was the integration test that validates this closure.)
**BC refs**: BC-1.5.038, BC-1.1.007, BC-1.5.031

---

### H-NEW-MP-001: Multi-profile fields bug — profile B uses its own story-points field (MUST-FIX pin)
**NFR source**: NFR-R-D (CRITICAL)
**BC**: BC-6.3.001

**Setup**:
1. Config with two profiles:
   - Profile `prod`: `story_points_field_id = "customfield_10005"`
   - Profile `sandbox`: `story_points_field_id = "customfield_10099"`
2. Wiremock at `JR_BASE_URL` captures POST `/rest/api/3/issue` request body.

**Action**: `jr --profile sandbox issue create --summary "Test" --points 5 --type Story --project PROJ --no-input`

**Expected (MUST-PASS — shipped)**:
- POST body contains `"customfield_10099": 5.0` (profile `sandbox`'s field ID; `points: Option<f64>` serializes `5.0_f64` as `5.0` via serde_json, NOT as integer `5`)
- POST body does NOT contain `"customfield_10005"` (profile `prod`'s field ID)
- exit 0

**Status**: MUST-PASS (NFR-R-D). Per-profile fix has shipped — `helpers::resolve_story_points_field_id` reads `active_profile().story_points_field_id` (not the deprecated global `config.global.fields`). This is a regression pin: a refactor that reverts to reading `config.global.fields.story_points_field_id` would fail this holdout by sending `customfield_10005` instead of `customfield_10099`.

**Verification**:
- Round-trip test: create profile `A` (field ID `customfield_A`) and `B` (field ID `customfield_B`). Assert `--profile A` sends `"customfield_A": 5.0` and `--profile B` sends `"customfield_B": 5.0` in the POST body.
- Error message test: when `[profiles.sandbox]` has no `story_points_field_id`, error must reference `[profiles.sandbox]` not deprecated `[fields]`.

---

## Group 7: SD-003 Verbose-Bodies PII Safety (H-NEW-VERBOSE-001..H-NEW-VERBOSE-002)

### H-NEW-VERBOSE-001: `--verbose-bodies` emits PII warning to stderr (MUST-PASS)
**NFR source**: NFR-S-C
**BC**: BC-7.5.001
**SD anchor**: SD-003
**Authored by**: S-0.06

**Setup**:
1. Wiremock at `JR_BASE_URL` returns any valid 200 response for a simple GET (e.g., `GET /rest/api/3/myself`).
2. Config with a valid profile (real or mocked auth header via `JR_AUTH_HEADER` or test fixture).

**Action**: `jr --verbose-bodies auth status` (or any command that triggers at least one HTTP call)

**Expected (MUST-PASS)**:
- exit 0
- stderr contains ALL THREE of the following lines (in any order relative to body content, but before the first `[verbose] body:` line):
  1. `[jr] WARNING: --verbose-bodies prints request/response bodies to stderr.`
  2. `[jr] These bodies contain PII (accountId, emailAddress, ADF text content).`
  3. `[jr] Do not pipe to AI-agent contexts or shared logs without consent.`
- stderr also contains at least one `[verbose] body:` line (body content is printed)
- stderr does NOT contain the suppression hint `[verbose] body suppressed (use --verbose-bodies to inspect, will print PII)` (that hint is `--verbose`-only)

**Status**: MUST-PASS. Verifies SD-003 Option B postcondition: explicit opt-in body logging with mandatory PII warning.

**Verification**:
- Process-spawn test in `tests/verbose_bodies.rs`: assert stderr contains all three warning lines.
- Regression check: if a future change removes the warning or gates it behind another flag, this holdout fails.
- Cross-reference: SD-003 Resolution §3 lines 79-83; S-0.06 AC-003.

---

### H-NEW-VERBOSE-002: `--verbose` alone does NOT print body content (MUST-PASS + regression pin)
**NFR source**: NFR-S-C
**BC**: BC-7.5.001
**SD anchor**: SD-003
**Authored by**: S-0.06

**Setup**:
1. Wiremock at `JR_BASE_URL` returns a 200 response with a non-empty JSON body (e.g., `{"accountType": "atlassian", "emailAddress": "user@example.com"}`).
2. Config with a valid profile.

**Action**: `jr --verbose auth status` (without `--verbose-bodies`)

**Expected (MUST-PASS)**:
- exit 0
- stderr contains `[verbose] GET /rest/api/3/myself` (or equivalent method+URL line for the command)
- stderr contains the suppression hint: `[verbose] body suppressed (use --verbose-bodies to inspect, will print PII)`
- stderr does NOT contain `[verbose] body:` (no raw body bytes printed)
- stderr does NOT contain `emailAddress` or any PII field values from the response body
- stderr does NOT contain ANY of the three PII warning lines (`[jr] WARNING: --verbose-bodies...`, `[jr] These bodies contain PII...`, `[jr] Do not pipe...`) — those warnings appear ONLY with `--verbose-bodies`

**Status**: MUST-PASS. Regression pin: if a future change inadvertently re-enables body printing under `--verbose` alone (reverting SD-003 Option B), this holdout fails.

**Verification**:
- Process-spawn test in `tests/verbose_bodies.rs`: assert stderr contains suppression hint and does NOT contain `[verbose] body:`.
- Three-variant test: (a) `--verbose` alone → suppression hint, no body; (b) `--verbose-bodies` alone → warning + body, no suppression hint; (c) `--verbose --verbose-bodies` → warning + body + method/URL lines.
- Cross-reference: SD-003 Resolution §3 lines 68-76; S-0.06 AC-001, AC-002; H-NEW-VERBOSE-001.

---

## Group 8: SD-002 Release Binary Auth Gate (H-NEW-AUTH-002)

### H-NEW-AUTH-002: Release binary refuses `JR_AUTH_HEADER` auth bypass (MUST-PASS + regression pin)

**NFR source**: NFR-S-B
**BC**: BC-X.1.001
**SD anchor**: SD-002 (Option B-revised — `#[cfg(debug_assertions)]` compile-time gate, canonized 2026-05-07 during S-0.05)
**Authored by**: S-0.07
**gate_attribute**: `cfg(debug_assertions)`
**mode**: must-pass + regression

**Setup**:
1. Build jr in release mode: `cargo build --release`
2. Set `JR_AUTH_HEADER=Basic dGVzdEBleGFtcGxlLmNvbTpmYWtl` (a Base64-encoded fake credential) in the child process environment.
3. Empty `XDG_CONFIG_HOME` (no configured profiles, no keychain entries). Set `JR_SERVICE_NAME=jr-jira-cli-test` to isolate keychain.
4. No `JR_BASE_URL` set (or pointing to a non-listening address to ensure no real API call succeeds).

**Action**: `./target/release/jr auth status`

**Expected (MUST-PASS — post-S-0.05)**:
- Exit non-zero (64 — no profile configured, or 78 — config error); NOT exit 0
- `JR_AUTH_HEADER` is NOT used as the auth header; the binary behaves as if the env var were absent
- stderr does NOT contain any reference to `dGVzdEBleGFtcGxlLmNvbTpmYWtl` (the fake credential value)
- stderr does NOT contain `api.atlassian.com` (no successful API call against any server)
- The binary falls through to keychain lookup / config-error path, proving the env-var read compiled out

**Expected (MUST-FAIL — pre-S-0.05 at activation HEAD dea1664)**:
- The fake `JR_AUTH_HEADER` value is loaded into `JiraClient` unconditionally (src/api/client.rs:64-66 pre-fix)
- Combined with `JR_BASE_URL` pointing to a mock server, the fake header would be used for an API call — bypassing keychain auth entirely (security violation)
- Without a mock server, the command still exits early (URL not configured), but the env var IS present in the loaded client struct

**Verification**:
- Process-spawn test in `tests/auth_header_release_gate.rs`: gated behind `#[ignore]` and `JR_RUN_RELEASE_AUTH_GATE_TEST=1` to avoid requiring a release build in standard CI unit test runs.
- Assert exit code is 64 (no profile configured — NOT a fake-auth success).
- Assert stderr does not contain the fake credential string or any API server response.
- Regression check: if a future change re-introduces unconditional `JR_AUTH_HEADER` reading in a release build (by removing the `#[cfg(debug_assertions)]` gate), this holdout fails.

**Practical test note**: The gate is `#[cfg(debug_assertions)]`. Debug binaries (including `cargo_bin` subprocess binaries used in most integration tests) still honor `JR_AUTH_HEADER` — that is intentional to preserve ~151 subprocess integration tests. This holdout MUST therefore use a RELEASE binary (`./target/release/jr`) built with `cargo build --release`. A debug subprocess test (`assert_cmd::cargo::cargo_bin`) would NOT verify this holdout because `debug_assertions=true` in debug builds.

**Status**: MUST-PASS. Satisfies SD-002 Option B-revised postcondition. Pre-S-0.05: MUST-FAIL (holdout defines the target). Post-S-0.05 (at develop SHA d907504): MUST-PASS.
**BC refs**: BC-X.1.001, SD-002
**Added**: S-0.07, Phase 3 Wave 0 (2026-05-07)

---

## Group 9: JSM Request Types (issue #288)

### H-NEW-JSM-RT-001: JSM request creation via `issue create --request-type` routes to servicedeskapi endpoint (MUST-PASS)

**NFR source**: BC-3.8.001, BC-3.8.002
**BC**: BC-3.8.001, BC-3.8.002, BC-3.8.008
**Authored by**: F2 spec evolution (2026-05-18)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config: project `HELPDESK` with `typeKey = "service_desk"`.
2. Mock `GET /rest/servicedeskapi/servicedesk` returning `{values: [{id: "3", projectKey: "HELPDESK"}]}`.
3. Mock `GET /rest/servicedeskapi/servicedesk/3/requesttype` returning `{isLastPage: true, values: [{id: "5", name: "Get IT Help", description: "IT support"}]}`.
4. Mock `POST /rest/servicedeskapi/request` with `expect(1)` returning 201 `{issueId: "10042", issueKey: "HELP-42", currentStatus: {status: "Waiting for support"}, _links: {web: {href: "https://example.atlassian.net/browse/HELP-42"}}}`.
5. Mock `POST /rest/api/3/issue` with `expect(0)` (platform create must NOT be called).

**Action**: `jr issue create --project HELPDESK --request-type "Get IT Help" --summary "VPN broken" --no-input --output json`

**Expected (MUST-PASS)**:
- exit 0
- stdout JSON: `{"key": "HELP-42"}`
- `POST /rest/servicedeskapi/request` called exactly once (expect(1) satisfied)
- POST body contains: `"requestTypeId": "5"` AND `"serviceDeskId": "3"` AND `"requestFieldValues"` containing `"summary": "VPN broken"`
- `POST /rest/api/3/issue` NOT called (expect(0) satisfied)
- `--output json` payload: v1 emits minimal `{"key": "HELP-42"}` only; `.url` field from `_links.web.href` is NOT surfaced in v1 (browse URL exposure is deferred). Mock setup retains `_links` field for API fidelity but implementation does not map it to output. This assertion locks the v1 behavior (mirrors BC-3.8.001 output shape).

**Why hidden**: The routing branch decision between platform and JSM endpoints is invisible from output alone — mock call counts are required to pin which endpoint was invoked. A naive implementation could POST to both or route to the wrong one while still returning a key-shaped response.

**Status**: MUST-PASS. Core routing invariant for BC-3.8.001.

---

### H-NEW-JSM-RT-002: `issue create --request-type` on software project errors clean with JSM hint, zero POST (MUST-PASS)

**NFR source**: BC-3.8.002, BC-X.8.004
**BC**: BC-3.8.002, BC-X.8.004, BC-3.3.001 (modified — platform path NOT exercised)
**Authored by**: F2 spec evolution (2026-05-18); F1d adversary pass-01 (2026-05-18 — BC-3.3.001 annotation added)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config: project `PROJ` with `typeKey = "software"`.
2. Mock `GET /rest/servicedeskapi/servicedesk` returning `{values: []}` or returning project meta indicating software type (no service desk entry for PROJ).
3. Mock `POST /rest/servicedeskapi/request` with `expect(0)`.
4. Mock `POST /rest/api/3/issue` with `expect(0)`.

**Action**: `jr issue create --project PROJ --request-type "Get IT Help" --summary "VPN broken" --no-input`

**Expected (MUST-PASS)**:
- exit 64
- stderr contains `Jira Software project` AND actionable suggestion referencing JSM or queue commands
- `POST /rest/servicedeskapi/request` NOT called (expect(0) satisfied)
- `POST /rest/api/3/issue` NOT called (expect(0) satisfied)

**Why hidden**: The `require_service_desk` gate is a client-side check before any HTTP. Its correct invocation for `issue create --request-type` is invisible without mock-call verification. A regression where the dispatch branch bypasses the service-desk check would allow the JSM POST to attempt on a non-JSM project (returning an API error instead of a clean exit-64).

**Status**: MUST-PASS. Guards BC-3.8.002's non-JSM project fail-fast behavior.

---

### H-NEW-JSM-RT-003: `issue create --request-type` OAuth scope-mismatch 401 surfaces `write:servicedesk-request` recovery hint (MUST-PASS)

**NFR source**: BC-3.8.015, BC-X.3.005, BC-1.6.042
**BC**: BC-3.8.015, BC-X.3.005, BC-1.6.042, BC-1.3.023
**Note**: BC-X.8.006 and BC-X.8.007 are intentionally NOT in the BC list. BC-3.8.014 is also intentionally NOT in the BC list — this holdout exercises the OAuth InsufficientScope arm only (scope-mismatch body routes through client.rs:696-704 short-circuit); BC-3.8.014's positive path (Basic-auth 401 → API-token-expiry hint) is pinned by `test_jsm_create_basic_auth_401_surfaces_api_token_hint` and `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` (repurposed in place by F4), so BC-3.8.014 is intentionally absent from the `BC:` list above.
**Authored by**: F2 spec evolution (2026-05-18)
**Test file**: `tests/issue_create_jsm.rs` — realized AS `async fn test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint`. The holdout and this test are the SAME artifact; there is no separate file. This test is already GREEN on `develop` unmodified and MUST remain unmodified.

> **[REVISED 2026-05-19 issue #384 adversary-pass-9 C-01]** Re-bound from the pre-#384 Basic-auth 401 test (Basic + generic-expiry — renamed by F4 to `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint`, a BC-3.8.014 pin asserting API-token-expiry hint with `write:servicedesk-request` ABSENT) to `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` (Bearer + scope-mismatch body — the ONLY deterministic OAuth→`JrError`→`write:servicedesk-request` path via the `JR_AUTH_HEADER` seam). All prior revision-note blockquotes referencing the earlier binding are superseded by this note. Title updated to reflect scope-mismatch framing.

**Setup** (faithfully describes the bound test `async fn test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint`):
0. **Cache dir is empty** (isolated `tempfile::tempdir()` for `XDG_CACHE_HOME`) — all GET mocks are reached on a cold cache.
1. Wiremock at `JR_BASE_URL`. Auth: `JR_AUTH_HEADER=Bearer test-oauth-token` (OAuth/Bearer fixture).
2. Project-meta GET for `HELP` returns a service-desk-type project (via the `mount_project_meta_help` helper — project `HELP`, id `99`, service-desk type). The helper is authoritative for the exact mock body.
3. Service-desk list GET returns service desk matched to project `HELP` (via `mount_service_desk_list` helper). The `projectId` field must match the project `id` from step 2 for `require_service_desk` to succeed.
4. Request-type list GET for the service desk returns a **single-element list** via the `mount_request_types_password_reset` helper: `"Password Reset"` only (one entry, no ambiguity in partial_match resolution). NOTE: this helper is distinct from `mount_request_type_list` (two-element list used by the sibling `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` — repurposed and renamed by F4); do NOT consolidate the two helpers.
5. `POST /rest/servicedeskapi/request` returns HTTP 401 with a **scope-mismatch body**: `{"errorMessages": ["Unauthorized; scope does not match"]}`. This body triggers the short-circuit at `src/api/client.rs:696-704` BEFORE the Bearer guard and BEFORE the refresh coordinator, landing as `JrError::InsufficientScope` in `handle_jsm_create`'s `map_err`. The OAuth arm (`is_oauth_auth() == true`) preserves `InsufficientScope` and surfaces the `write:servicedesk-request` hint. **WHY scope-mismatch body is required:** a generic-expiry body on a Bearer client routes through the refresh coordinator (client.rs:727+), which deterministically fails with a raw anyhow error (not a `JrError`) via the `JR_AUTH_HEADER` seam — the `write:servicedesk-request` hint is never injected and the test would not be a valid pin.

**Action**: `jr issue create --project HELP --request-type "Password Reset" --summary "Reset my password" --no-input`

**Expected (MUST-PASS)** — exactly the four assertions made by `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` (read from `tests/issue_create_jsm.rs` lines 1566-1582):
- exit non-zero
- stderr contains `write:servicedesk-request`
- stderr contains `jr auth refresh`
- stderr contains `jr auth login`

**Note**: The negative boundary "OAuth path does NOT leak the Basic-auth API-token hint" is NOT pinned by this holdout — it is covered positively by BC-3.8.014's dedicated Basic-auth tests (`test_jsm_create_basic_auth_401_surfaces_api_token_hint` and `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` (repurposed and renamed by F4)), which assert the Basic path produces the API-token-expiry hint, making the negative boundary implicit and structurally enforced.

**Why hidden**: The OAuth `InsufficientScope` 401 path (scope-mismatch body → client.rs:696-704 short-circuit → `InsufficientScope` → `map_err` OAuth arm) must surface `write:servicedesk-request`. This is the only deterministic Bearer→`JrError`→hint path via the `JR_AUTH_HEADER` seam. A regression where the OAuth `InsufficientScope` arm loses the `write:servicedesk-request` hint would be invisible without this pin.

**Status**: MUST-PASS. Verifies that BC-3.8.015's `write:servicedesk-request` addition is surfaced in the user-facing error recovery path for OAuth auth via the `InsufficientScope` arm (the only deterministic testable path).

---

### H-NEW-JSM-RT-004: `--type` flag ignored with stderr warning when `--request-type` is set (MUST-PASS)

**NFR source**: BC-3.8.010
**BC**: BC-3.8.010, BC-3.8.001
**Authored by**: F1d adversary pass-01 (2026-05-18)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config: project `HELPDESK` with `typeKey = "service_desk"`.
2. Mock `GET /rest/servicedeskapi/servicedesk` returning `{values: [{id: "3", projectKey: "HELPDESK"}]}`.
3. Mock `GET /rest/servicedeskapi/servicedesk/3/requesttype` returning `{isLastPage: true, values: [{id: "5", name: "Get IT Help", description: "IT support"}]}`.
4. Mock `POST /rest/servicedeskapi/request` with `expect(1)` returning 201 `{issueId: "10042", issueKey: "HELP-42", currentStatus: {status: "Waiting for support"}}`.

**Action**: `jr issue create --project HELPDESK --request-type "Get IT Help" --type Bug --summary "foo" --no-input --output json`

**Expected (MUST-PASS)**:
- exit 0
- stdout JSON: `{"key": "HELP-42"}`
- stderr contains: `warning: --type is ignored when --request-type is set; request type encodes the issue type`
- `POST /rest/servicedeskapi/request` called exactly once (expect(1) satisfied)
- `--type Bug` value does NOT appear in the POST body (request type field uses resolved requestTypeId "5", not platform issue-type label)

**Why hidden**: The `--type` flag interaction at the JSM dispatch site is not visible from the JSON output alone — only the stderr line and mock body inspection reveal whether `--type` was silently dropped or incorrectly forwarded. A regression where `--type` causes an error (rather than a warning) or where the warning is omitted would be invisible without this pin.

**Status**: MUST-PASS. Pins BC-3.8.010 (--type ignored with warning).

---

### H-NEW-JSM-RT-005: `jr requesttype fields` uses cache on second call — no extra HTTP (SHOULD-PASS)

**NFR source**: BC-X.12.005
**BC**: BC-X.12.005, BC-X.12.008
**Authored by**: F1d adversary pass-02 (2026-05-18)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config: project `HELPDESK` with `typeKey = "service_desk"`.
2. Mock `GET /rest/servicedeskapi/servicedesk` returning `{values: [{id: "3", projectKey: "HELPDESK"}]}` with `expect(1..=2)` (service desk resolution happens on each `requesttype fields` call; caching behavior may reduce to 1).
3. Mock `GET /rest/servicedeskapi/servicedesk/3/requesttype` returning `{isLastPage: true, values: [{id: "5", name: "Get IT Help", description: "IT support"}]}` with `expect(1..=2)` (request type list for name resolution is cached; cache-warm second call should not hit this, but expect range accommodates both cache-miss and cache-hit paths).
4. Mock `GET /rest/servicedeskapi/servicedesk/3/requesttype/5/field` with `expect(1)` returning a minimal field response `{canRaiseOnBehalfOf: false, canAddRequestParticipants: false, requestTypeFields: [{fieldId: "summary", name: "Summary", required: true, jiraSchema: {type: "string"}}]}`.

**Action (two sequential calls)**:
1. `jr requesttype fields "Get IT Help" --project HELPDESK --no-input`
2. `jr requesttype fields "Get IT Help" --project HELPDESK --no-input`

**Expected (SHOULD-PASS)**:
- Both calls exit 0
- `GET /rest/servicedeskapi/servicedesk/3/requesttype/5/field` is called exactly once across both runs (expect(1) satisfied) — second call uses the per-request-type fields cache
- Both calls produce identical stdout output (table with "Summary", required=YES)

**Why hidden**: The per-request-type fields cache (`request_type_fields_<sid>_<rtId>.json`) is a separate cache layer from the request-type list cache. A regression where the fields cache is not populated or not read on the second call would result in two HTTP calls — visible only via wiremock `expect(1)` assertion failure.

**Status**: SHOULD-PASS. Pins BC-X.12.005 §Caching (fields cache hit/miss behavior).

---

### H-NEW-JSM-RT-006: `issue create --request-type ""` or whitespace-only exits 64 with explicit message; no HTTP (MUST-PASS)

**NFR source**: BC-3.8.016
**BC**: BC-3.8.016
**Authored by**: F2 spec evolution (2026-05-20 issue #385)
**realized_by**: `async fn test_jsm_create_empty_request_type_exits_64` in `tests/issue_create_jsm.rs` (Required Test Deliverable item 1 — name must be byte-identical to prd-delta-385.md §Required Test Deliverables; test MUST cover BOTH `--request-type ""` and a whitespace-only input such as `--request-type "   "`)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config: project `HELP`. Cold cache.
2. **No service desk or request type mocks mounted** — the guard fires at ordering step 1, before `require_service_desk` (step 4), so no HTTP is ever issued. Any GET or POST call would cause the test to fail on unexpected call detection. A regression that moved this guard below `require_service_desk` would be caught here by the zero-mock setup.

**Action**: `jr issue create --project HELP --request-type "" --summary "Test" --no-input`

**Expected (MUST-PASS)**:
- exit 64
- stderr contains (assert via `contains`): `request type cannot be empty` <!-- duplicated from BC-3.8.016 body in bc-3-issue-write.md (CANONICAL) — update both together -->
- stdout is empty
- No HTTP calls issued (guard fires at ordering step 1 — before `require_service_desk` (step 4); numeric-bypass check and `partial_match` both occur at step 6)

**Boundary cases (all exit 64 at step 1 with zero HTTP)**:
- `--request-type "   "` (whitespace-only): guard fires — `"   ".trim().is_empty()` is `true`; same message "request type cannot be empty", same exit 64, no HTTP. A regression replacing `.trim().is_empty()` with `.is_empty()` would pass the primary `""` case but fail here (EC-3.8.016-1).

**Why hidden**: Without the explicit empty-or-whitespace guard, `--request-type ""` falls through to `resolve_jsm_request_type_id` → `partial_match("", &candidates)` → returns `Ambiguous` for any NON-EMPTY candidate list (and `None` for an empty one) — either outcome produces a misleading message that gives the user no indication they passed an empty string. A regression where the guard is removed would produce the misleading "Ambiguous request type — N matches" message (or "request type not found" for an empty request-type list) instead of "request type cannot be empty". The zero-mock setup (no mocks mounted at all) validates no HTTP is issued — any unexpected HTTP call fails the test. The whitespace-only boundary case pins the `.trim()` call specifically.

**Status**: MUST-PASS. Pins BC-3.8.016 (empty/whitespace-only `--request-type` guard fires at the top of `handle_jsm_create`, before `require_service_desk`, no HTTP). The `realized_by` test MUST cover both the empty-string and whitespace-only inputs.

---

### H-NEW-JSM-RT-007: `issue create --markdown --field description=plain` exits 64 at top of `handle_jsm_create`; no HTTP (MUST-PASS)

**NFR source**: BC-3.8.017
**BC**: BC-3.8.017
**Authored by**: F2 spec evolution (2026-05-20 issue #385)
**realized_by**: `async fn test_jsm_create_markdown_field_description_conflict_exits_64` in `tests/issue_create_jsm.rs` (Required Test Deliverable item 2 — name must be byte-identical to prd-delta-385.md §Required Test Deliverables)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config: project `HELP`. Cold cache.
2. **No service desk, request type, or POST mocks mounted** — the conflict guard fires at ordering step 2 (the VERY TOP of `handle_jsm_create`, before `require_service_desk`), so no HTTP is ever issued. Any GET or POST call would cause the test to fail.

**Action**: `jr issue create --project HELP --request-type 17 --summary "Reset please" --markdown --field description="plain text override" --no-input`

Note: the step-2 conflict guard does not inspect the `--request-type` value at all; numeric 17 is used only to keep the action concrete. The zero-mock property holds because the step-2 guard precedes `require_service_desk` (step 4) regardless of the request-type value. A regression that moved this guard below `require_service_desk` would be caught here by the zero-mock setup (an HTTP attempt would fail the test).

**Expected (MUST-PASS)**:
- exit 64
- stderr is the ONE canonical single-sentence message defined in BC-3.8.017 body (bc-3-issue-write.md CANONICAL SOURCE). The implementation MUST emit a single contiguous stderr sentence — NOT two separate `eprintln!` calls. The three `contains` checks below are substring slices of that one sentence, provided for test-assertion convenience only:
  - assert via `contains`: `` `--field description=...` cannot be combined with `--markdown` `` <!-- duplicated from BC-3.8.017 body in bc-3-issue-write.md (CANONICAL) — update both together -->
  - assert via `contains`: `may result in a JSM 400 error or silently dropped ADF formatting` <!-- duplicated from BC-3.8.017 body in bc-3-issue-write.md (CANONICAL) — update both together -->
  - assert via `contains`: `Pass \`--description\` with \`--markdown\`, or omit \`--markdown\`` <!-- remediation clause — duplicated from BC-3.8.017 body in bc-3-issue-write.md (CANONICAL) — update both together; pins "errors always suggest what to do next" convention -->
- stdout is empty
- No HTTP calls issued (conflict guard fires at ordering step 2 — before `require_service_desk`, before any HTTP)

**Boundary cases (all exit 64 at the conflict guard with zero HTTP)**:
- `--markdown --field description=` (empty value) + any `--request-type`: guard fires (EC-3.8.017-1 — key `"description"` is present regardless of value)
- `--field summary=foo --field description=bar --markdown` + any `--request-type`: guard fires (EC-3.8.017-2 — key check is order-independent)
- `--markdown --field description=X` with NO `--description` flag: guard fires the BC-3.8.017 conflict message (NOT the "requires --description" message) — because this guard is at step 2, before the step-3 `--markdown`-requires-`--description` guard
- `--markdown --field Description=X` (capital D): guard does NOT fire (EC-3.8.017-3 — key matching is case-SENSITIVE, no-trim; raw key `Description` ≠ `"description"`; no desync; command proceeds to step 6)
- `--markdown --description-stdin --field description=X`: guard fires (EC-3.8.017-4 — raw key `description` exactly matches; guard does not inspect description source)

**Why hidden**: The `--markdown` + `--field description=` combination produces a desync: `JsmRequestBuilder::build()` sets `isAdfRequest: true` from the ADF conversion of `self.description`, then `extra_fields["description"]` overwrites the ADF value with a plain string. This may cause a JSM 400 or silently drop ADF formatting — neither outcome is clean. A regression where the guard is removed would silently send a malformed request body to Atlassian with no client-side error, making the defect invisible in unit tests that do not mount a live JSM endpoint. Only this holdout's zero-mock setup catches the regression — any unexpected HTTP call fails the test.

**Status**: MUST-PASS. Pins BC-3.8.017 (--markdown + --field description= conflict rejected at the top of `handle_jsm_create`, before `require_service_desk`, no HTTP). The rejection message must NOT assert "Atlassian returns 400" — it uses "may result in" phrasing per CLAUDE.md citation discipline.

---

## Group 8: CI Citation Guard (H-CITE-001..H-CITE-003)

### H-CITE-001: Citation guard catches a dead `src/` citation and emits CI-CITE-001 detection (MUST-PASS)

**NFR source**: BC-X.13.001
**BC**: BC-X.13.001, BC-X.13.002
**Authored by**: F3 story decomposition (2026-06-19, S-MAINT-DEAD-CITATION-CI)

**Setup**: Call `extract_path_citations` from `tests/claude_md_citations.rs` with the fixture
doc string `"See \`src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs\` for details."`. Then filter the
result with `Path::new(env!("CARGO_MANIFEST_DIR")).join(p).exists()` to get the `dead` vec.

**Action**: Assert the `dead` vec contains `"src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs"`.

**Expected (MUST-PASS)**:
- The dead vec contains the path `src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs`.
- The path passed `extract_path_citations` (starts with `src/`; passes extension filter `.rs`; no glob, no symbol suffix).
- `Path::exists()` returns false (file genuinely does not exist in any `jr` build).
- If this result were passed to the full integration test assertion, the panic message would begin with: `CLAUDE.md cites file paths that do not exist on disk:`.

**Why hidden**: Confirms the guard correctly detects dead develop-tracked `src/` citations using a
controlled fixture rather than CLAUDE.md content. A regression in the dir-prefix filter at step (c)
that accidentally excluded `src/` paths would make this path invisible in the dead list.

**Status**: MUST-PASS. Pins BC-X.13.001 (guard detects dead develop-tracked citations) and
BC-X.13.002 (dir-prefix filter correctly admits `src/` paths).

---

### H-CITE-002: Citation guard correctly ignores a `.factory/` citation; no false positive (MUST-PASS)

**NFR source**: BC-X.13.003
**BC**: BC-X.13.003
**Authored by**: F3 story decomposition (2026-06-19, S-MAINT-DEAD-CITATION-CI)

**Setup**: Call `extract_path_citations` from `tests/claude_md_citations.rs` with the fixture
doc string `"See \`.factory/specs/prd/cross-cutting.md\` for details."`.

**Action**: Assert the return value is an empty vec.

**Expected (MUST-PASS)**:
- `extract_path_citations` returns `[]`.
- The token `.factory/specs/prd/cross-cutting.md` passes glob-skip (step a) and fixpoint (step b),
  but fails the dir-prefix filter at step (c): `.factory/` is NOT a develop-tracked directory prefix
  and NOT a ROOT_FILES exact-match. The token is excluded and never reaches `Path::exists()`.
- No false positive, regardless of whether `.factory/specs/prd/cross-cutting.md` exists on disk.

**Why hidden**: `.factory/` citations are the most critical false-positive vector. If `.factory/`
were incorrectly admitted by the dir-prefix filter, every CI run on a standard working-tree checkout
(without the `factory-artifacts` branch worktree mounted) would fail for every CLAUDE.md citation of
a `.factory/` path. A single regression in step (c) that added `.factory/` to the tracked prefix set
would break CI globally. This holdout confirms the exclusion is structural and robust.

**Status**: MUST-PASS. Pins BC-X.13.003 (ALL `.factory/` paths excluded by dir-prefix filter at step
(c); no allowlist function involved; no `is_off_working_branch_allowlisted` call).

---

### H-CITE-003: Citation guard correctly ignores bare shorthand `ci.yml`; no false positive (MUST-PASS)

**NFR source**: BC-X.13.002
**BC**: BC-X.13.002 step (c) — ROOT_FILES exclusion (EC-CITE-030)
**Authored by**: F3 story decomposition (2026-06-19, S-MAINT-DEAD-CITATION-CI)

**Setup**: Call `extract_path_citations` from `tests/claude_md_citations.rs` with the fixture
doc string `"See \`ci.yml\` for details."`.

**Action**: Assert the return value is an empty vec.

**Expected (MUST-PASS)**:
- `extract_path_citations` returns `[]`.
- The token `ci.yml` passes glob-skip (step a) and fixpoint (step b, leaves it unchanged).
  At step (c): `ci.yml` has no develop-tracked directory prefix (`src/`, `tests/`, `docs/`,
  `.github/`, `scripts/`) and does NOT exactly equal any ROOT_FILES member. Excluded.
- The full path `.github/workflows/ci.yml` would be the correct in-scope citation form.
- No false positive.

**Why hidden**: Bare-shorthand tokens like `ci.yml`, `adf.rs`, `fields.json`, and `release.yml`
appear frequently in CLAUDE.md prose but refer to files in subdirectories, not repo-root files.
A regression that used a structural "any .yml file at step (c)" rule instead of the curated
ROOT_FILES exact-match would generate spurious failures on these shorthands. This holdout
confirms the ROOT_FILES exclusion (EC-CITE-030) is enforced at the token level.

**Status**: MUST-PASS. Pins BC-X.13.002 step (c) ROOT_FILES exclusion — `ci.yml` is NOT a
ROOT_FILES member; bare shorthands for non-root files are excluded.

---

## Group 10: ADF Markdown→ADF Feature Wave (H-NEW-ADF-001..H-NEW-ADF-009)

### H-NEW-ADF-001: `> [!WARNING]` → ADF `panel` with `panelType: "warning"`; `> [!NOTE]` → `panelType: "info"` (MUST-PASS)

**NFR source**: BC-7.2.009
**BC**: BC-7.2.009
**Authored by**: D4 holdout refresh Burst 1 (2026-06-26)

**Setup**:
1. Wiremock at `JR_BASE_URL` captures `POST /rest/api/3/issue` request body.
2. Config with a valid profile (Bearer or Basic via `JR_AUTH_HEADER`).
3. Mock `POST /rest/api/3/issue` returns 201 `{"id":"10001","key":"PROJ-1","self":"..."}`.

**Action (two separate calls)**:
1. `jr issue create --project PROJ --type Task --summary "warn" --description "> [!WARNING]\n> Something dangerous." --markdown --no-input`
2. `jr issue create --project PROJ --type Task --summary "note" --description "> [!NOTE]\n> Heads up." --markdown --no-input`

**Note on newline delivery**: The `\n` in the description strings above represents a REAL newline character (U+000A), not the two-character sequence backslash-n. The binary does NOT decode literal `\n` escape sequences from CLI arguments — a literal `\n` keeps the text on one line and breaks alert/tasklist/footnote recognition. Deliver the newline via a shell heredoc, a fixture file with `--description-stdin`, or a Rust raw string in `assert_cmd`-style test code.

**Expected (MUST-PASS)**:

Call 1: captured POST body `fields.description` is ADF containing:
- A top-level block with `"type": "panel"` and `"attrs": {"panelType": "warning"}`
- That panel's `"content"` array contains at least one block with `"type": "paragraph"`
- NO `"type": "blockquote"` at the top level — the alert becomes a panel, not a blockquote
- No `"type": "panel"` nested inside another `"type": "panel"` (content-model normalization)

Call 2: captured POST body `fields.description` is ADF containing:
- A top-level block with `"type": "panel"` and `"attrs": {"panelType": "info"}`
- That panel's `"content"` contains a paragraph with the text "Heads up."

**Why hidden**: The panel type mapping (`[!WARNING]`→`warning`, `[!NOTE]`→`info`) is invisible from output text alone and requires asserting on the ADF JSON the request body captures. A regression where alerts fall through to plain `blockquote` nodes or where the wrong panelType is emitted would not be visible from `jr issue view` text rendering. Mock call-body assertion is the only channel.

**Status**: MUST-PASS. Pins BC-7.2.009 (GFM alert → panel, five kind→panelType mappings). Covers WARNING and NOTE as the two most-used alert kinds; the other three (TIP→success, IMPORTANT→note, CAUTION→error) follow the same code path through `panel_type_for`.

---

### H-NEW-ADF-002: `> [!CAUTION]` → `panelType: "error"`; plain `>` blockquote stays `blockquote`, NOT panel (MUST-PASS)

**NFR source**: BC-7.2.009
**BC**: BC-7.2.009
**Authored by**: D4 holdout refresh Burst 1 (2026-06-26)

**Setup**:
1. Wiremock at `JR_BASE_URL` captures `POST /rest/api/3/issue` request body.
2. Mock `POST /rest/api/3/issue` returns 201 `{"id":"10002","key":"PROJ-2","self":"..."}`.

**Action (two separate calls)**:
1. `jr issue create --project PROJ --type Task --summary "caution" --description "> [!CAUTION]\n> Watch out." --markdown --no-input`
2. `jr issue create --project PROJ --type Task --summary "blockquote" --description "> This is a plain quote." --markdown --no-input`

**Note on newline delivery**: The `\n` in call 1's description represents a REAL newline character (U+000A). The binary does NOT decode literal `\n` escape sequences from CLI arguments. Deliver the newline via a shell heredoc, a fixture file with `--description-stdin`, or a Rust raw string in `assert_cmd`-style test code.

**Expected (MUST-PASS)**:

Call 1: captured POST body contains a block with `"type": "panel"` and `"attrs": {"panelType": "error"}`.

Call 2: captured POST body contains a block with `"type": "blockquote"` — NOT `"type": "panel"`. No `"panelType"` key appears anywhere in the body.

**Why hidden**: The boundary between a tagged alert (`BlockQuote(Some(kind))`) and a plain blockquote (`BlockQuote(None)`) is invisible from text output. Call 2 specifically pins that an untagged `>` blockquote is NOT silently converted to a panel. A regression where `BlockQuote(None)` is routed to the panel path would emit a `panel` node and break downstream Jira rendering for all plain blockquotes.

**Status**: MUST-PASS. Pins BC-7.2.009 EC-1 (plain blockquote stays blockquote) and the `CAUTION`→`"error"` panelType mapping.

---

### H-NEW-ADF-003: GFM task list `- [ ]`/`- [x]` → `taskList`/`taskItem`; state uppercase; `localId` is a non-empty string (MUST-PASS)

**NFR source**: BC-7.2.010
**BC**: BC-7.2.010
**Authored by**: D4 holdout refresh Burst 1 (2026-06-26)

**Setup**:
1. Wiremock at `JR_BASE_URL` captures `POST /rest/api/3/issue` request body.
2. Mock `POST /rest/api/3/issue` returns 201 `{"id":"10003","key":"PROJ-3","self":"..."}`.

**Action**:
`jr issue create --project PROJ --type Task --summary "tasks" --description "- [ ] unchecked\n- [x] checked" --markdown --no-input`

**Note on newline delivery**: The `\n` in the description represents a REAL newline character (U+000A). The binary does NOT decode literal `\n` escape sequences from CLI arguments — a literal `\n` keeps both items on one line and breaks task-list recognition. Deliver the newline via a shell heredoc, a fixture file with `--description-stdin`, or a Rust raw string in `assert_cmd`-style test code.

**Note on dash-leading input**: The description value begins with `- [ ]`. Because `--description` carries `allow_hyphen_values = true`, a missing value silently consumes the next token rather than erroring — prefer `--description-stdin` or the equals-form `--description="- [ ] ..."` for programmatic or AI-agent use where the value starts with a dash.

**Expected (MUST-PASS)**:

Captured POST body `fields.description` contains:
- A top-level block with `"type": "taskList"`
- `taskList.attrs.localId` is a non-empty string (e.g. `"1"`)
- `taskList.content` is an array of exactly two elements
- First element: `{"type": "taskItem", "attrs": {"localId": "<non-empty-string>", "state": "TODO"}, "content": [{"type": "text", "text": "unchecked"}]}`
  - `state` value is EXACTLY `"TODO"` (uppercase, not `"todo"`)
- Second element: `{"type": "taskItem", "attrs": {"localId": "<non-empty-string>", "state": "DONE"}, "content": [{"type": "text", "text": "checked"}]}`
  - `state` value is EXACTLY `"DONE"` (uppercase, not `"done"`)
- NO `"type": "bulletList"` appears at the top level — the list is reclassified to `taskList`
- All `localId` attribute values are distinct non-empty strings

**Why hidden**: State value casing (`"TODO"` vs `"todo"`) and `localId` assignment are invisible from text rendering. A regression that emits `"done"` instead of `"DONE"`, omits `localId`, or leaves the list as a `bulletList` would be invisible without asserting on the POST body ADF structure. Jira rejects lowercase state values.

**Status**: MUST-PASS. Pins BC-7.2.010 postconditions: uppercase state, non-empty localId, `taskList` reclassification.

---

### H-NEW-ADF-004: Multi-line block HTML → paragraph with `hardBreak` interior nodes; NO raw `\n` in any text node (INV-1) (MUST-PASS)

**NFR source**: BC-7.2.011
**BC**: BC-7.2.011
**Authored by**: D4 holdout refresh Burst 1 (2026-06-26)

**Setup**:
1. Wiremock at `JR_BASE_URL` captures `POST /rest/api/3/issue` request body.
2. Mock `POST /rest/api/3/issue` returns 201 `{"id":"10004","key":"PROJ-4","self":"..."}`.
3. Input markdown: `<div>\nline one\nline two\n</div>` (a block HTML element spanning three inner lines)

**Action**:
`jr issue create --project PROJ --type Task --summary "html" --description "<div>\nline one\nline two\n</div>" --markdown --no-input`

**Note on newline delivery**: The `\n` characters in the description represent REAL newline characters (U+000A). The binary does NOT decode literal `\n` escape sequences from CLI arguments. Deliver the newlines via a shell heredoc, a fixture file with `--description-stdin`, or a Rust raw string in `assert_cmd`-style test code.

**Expected (MUST-PASS)**:

Captured POST body `fields.description` contains a paragraph block:
```json
{
  "type": "paragraph",
  "content": [
    {"type": "text", "text": "<div>"},
    {"type": "hardBreak"},
    {"type": "text", "text": "line one"},
    {"type": "hardBreak"},
    {"type": "text", "text": "line two"},
    {"type": "hardBreak"},
    {"type": "text", "text": "</div>"}
  ]
}
```
(Trailing newlines after `</div>` are trimmed by step 2 of Algorithm B — no trailing `hardBreak` at the end.)

Additionally, scanning ALL `"text"` fields anywhere in `fields.description`:
- No text node string contains a literal `\n` character (U+000A) — INV-1 is satisfied
- No text node string contains a literal `\r` character (U+000D) — INV-1 is satisfied

**Why hidden**: INV-1 (no raw `\n` in non-codeBlock text nodes) is invisible from `jr issue view` text rendering. A regression where block HTML newlines are placed inside a `text` node string (instead of as `hardBreak` nodes) produces an ADF body that Jira rejects with HTTP 400 — the error is not visible in unit tests that do not assert on the JSON node structure. The INV-1 scan across ALL text fields pins the invariant exhaustively.

**Status**: MUST-PASS. Pins BC-7.2.011 Algorithm B (steps 1-6), INV-1, and the interior `hardBreak` node structure. The paragraph-with-hardBreaks output shape is now pinned at the source level by `src/adf.rs::test_block_html_plain_text_interior_lines_preserved_in_one_paragraph` (PR #560).

---

### H-NEW-ADF-005: Multi-line INLINE HTML (e.g. `foo <span\nx>bar`) → interior newline becomes a SPACE, NOT `hardBreak`; no raw `\n` survives (INV-1, CR-01 fix) (MUST-PASS)

**NFR source**: BC-7.2.011 INV-1 (EC-11, F5-R2)
**BC**: BC-7.2.011
**Authored by**: D4 holdout refresh Burst 1 (2026-06-26)

**Setup**:
1. Wiremock at `JR_BASE_URL` captures `POST /rest/api/3/issue` request body.
2. Mock `POST /rest/api/3/issue` returns 201 `{"id":"10005","key":"PROJ-5","self":"..."}`.
3. Input: a paragraph containing inline HTML with an interior newline — `foo <span\nx>bar` where `\n` is a literal newline character (U+000A). This is the reachable HIGH-severity INV-1 violation fixed by issue #522 (CR-01).

**Action**:
`jr issue create --project PROJ --type Task --summary "inline-html" --description "foo <span\nx>bar" --markdown --no-input`

(The description value must be passed with a literal newline inside the inline HTML tag, e.g. via a shell heredoc or a test fixture string.)

**Expected (MUST-PASS)**:

Captured POST body `fields.description.content`:
- Contains a `"type": "paragraph"` block
- That paragraph's `"content"` contains `"type": "text"` nodes only — NO `"type": "hardBreak"` node anywhere in the paragraph (inline HTML interior newlines become a space, not a `hardBreak`; contrast with block HTML in H-NEW-ADF-004 which DOES produce `hardBreak` nodes)
- At least one text node in the paragraph contains the substring `"<span"` (the HTML tag is preserved, not dropped)
- No text node string contains a literal `\n` character (U+000A) — INV-1 satisfied (pinned by `test_markdown_multiline_inline_html_holds_inv1`, src/adf.rs ~10490)
- No text node string contains a literal `\r` character (U+000D) — INV-1 satisfied

**Note**: The exact byte sequence of the concatenated text nodes is NOT asserted. The implementation guarantees the INV-1 invariant (no raw newline in any text node) and that HTML is preserved rather than dropped — but pulldown-cmark's inline HTML event splitting is an implementation detail that may vary. Assert the three properties above; do NOT assert exact equality on the full paragraph text string.

**Boundary distinction from H-NEW-ADF-004**: Block HTML (a standalone `<div>...` block) uses Algorithm B to produce `hardBreak` nodes. Inline HTML inside a paragraph flows through `push_text` Other-context normalization which maps newlines to a **space**. This holdout pins the asymmetry: same raw `\n` character, different output node type depending on block vs inline context.

**Why hidden**: This was a reachable HIGH-severity bug (CR-01, issue #522) where multi-line inline HTML produced a raw `\n` in a text node, causing Jira HTTP 400 on real write operations. A regression reintroducing this — by removing the `bare \n → space` normalization in `push_text` Other context — would be invisible from `jr issue view` but would silently break all issue writes containing multi-line inline HTML. The mock body assertion is the only observable channel.

**Status**: MUST-PASS. Pins BC-7.2.011 EC-11 (F5-R2): `push_text` Other-context bare `\n` → space normalization. Specifically pins the reachable CR-01 path closed by issue #522.

---

### H-NEW-ADF-006: Footnote `[^1]` reference → plain `[1]` text marker (no marks); definition appended after `rule` divider with `[1] ` label prefix (MUST-PASS)

**NFR source**: BC-7.2.013 (dedicated footnote→ADF BC; EC-1 marker-no-marks, EC-5 no-double-rule, EC-6 blockquote-pruning, EC-7 list-placeholder)
**BC**: BC-7.2.013
**Authored by**: D4 holdout refresh Burst 1 (2026-06-26); re-anchored 2026-06-27 (BC-7.2.013 promoted from range-collapsed)

**Setup**:
1. Wiremock at `JR_BASE_URL` captures `POST /rest/api/3/issue` request body.
2. Mock `POST /rest/api/3/issue` returns 201 `{"id":"10006","key":"PROJ-6","self":"..."}`.

**Action**:
`jr issue create --project PROJ --type Task --summary "footnote" --description "See note.[^1]\n\n[^1]: The note body." --markdown --no-input`

**Note on newline delivery**: The `\n` characters in the description represent REAL newline characters (U+000A). The binary does NOT decode literal `\n` escape sequences from CLI arguments — a literal `\n` keeps the footnote definition on the same line as the reference text, breaking footnote recognition entirely. Deliver the newlines via a shell heredoc, a fixture file with `--description-stdin`, or a Rust raw string in `assert_cmd`-style test code.

**Expected (MUST-PASS)**:

Captured POST body `fields.description.content` (top-level array):
1. A `"type": "paragraph"` containing two text nodes:
   - `{"type": "text", "text": "See note."}` — plain text, no marks
   - `{"type": "text", "text": "[1]"}` — the reference marker: EXACTLY the bracketed label, plain text, NO `marks` key (or `marks: []`)
   - The reference text node must NOT carry marks from surrounding text (it is deliberately unmarked — `push_footnote_marker` does not apply `active_marks`)
2. A `"type": "rule"` block (the divider separating body from footnote section)
3. A `"type": "paragraph"` containing:
   - First text node: `{"type": "text", "text": "[1] "}` — the label prefix prepended by the FootnoteDefinition handler
   - Second text node: `{"type": "text", "text": "The note body."}` — the definition content

The document must contain exactly ONE `"type": "rule"` block (not two, even if the user writes `---` before the footnote — the `ends_with_rule` guard prevents doubling).

**Why hidden**: The footnote reference → plain `[label]` mapping with no marks is invisible from text rendering of the issue. A regression that converted `[^1]` to a literal caret string `^1`, left the `^` in the ADF body, or created a `footnote`-typed ADF node (ADF has none) would not be visible from `jr issue view`. The marker-is-unmarked invariant (`push_footnote_marker` bypasses `active_marks`) is load-bearing for consistency and is only assertable from the POST body node structure.

**Status**: MUST-PASS. Pins BC-7.2.013 (issue #472) footnote behavior: plain `[label]` reference markers, deferred definition flush after a single `rule` divider, `[label] ` prefix on definition paragraphs. The discrete-node shape (reference and definition as separate unmarked text nodes) is pinned at the source level by `src/adf.rs::test_footnote_reference_and_definition_are_discrete_unmarked_text_nodes` (PR #560).

**BC refs**: BC-7.2.013 (primary; EC-1 marker-no-marks, EC-3 duplicate-dedup, EC-5 no-double-rule)

---

### H-NEW-ADF-007: `^x^` → `subsup` sup mark; `~x~` → `subsup` sub mark; `~~x~~` stays `strike` (NOT subsup) (MUST-PASS)

**NFR source**: BC-7.2.007 (issue #474)
**BC**: BC-7.2.007
**Authored by**: D4 holdout refresh Burst 1 (2026-06-26)

**Setup**:
1. Wiremock at `JR_BASE_URL` captures `POST /rest/api/3/issue` request body.
2. Mock `POST /rest/api/3/issue` returns 201 `{"id":"10007","key":"PROJ-7","self":"..."}`.

**Action (two calls)**:
1. `jr issue create --project PROJ --type Task --summary "subsup" --description "H ^2^ O and CO ~2~ done" --markdown --no-input`
2. `jr issue create --project PROJ --type Task --summary "strikethrough" --description "~~deleted~~" --markdown --no-input`

**Note on call 1 delimiter spacing**: The opening delimiter MUST be preceded by whitespace (or string start) for pulldown-cmark to recognize it as a superscript/subscript span. The form `H^2^O` (intraword, tight against a preceding word char) does NOT produce a subsup mark — the text stays literal `H^2^O`. This is the documented `mc^2^` limitation in CLAUDE.md and is pinned by `test_markdown_intraword_superscript_stays_literal` (src/adf.rs). The correct forms are boundary-spaced: `H ^2^ O` (opening `^` preceded by space) and `CO ~2~ done` (opening `~` preceded by space), which match the source tests `test_markdown_superscript_to_subsup_sup` (`a ^sup^ b`) and `test_markdown_subscript_to_subsup_sub` (`a ~sub~ b`) in src/adf.rs.

**Expected (MUST-PASS)**:

Call 1: captured POST body `fields.description.content[0]` is a `paragraph`. Within its `content`:
- A text node with `"text": "2"` (from `^2^`) carries `"marks": [{"type": "subsup", "attrs": {"type": "sup"}}]`
- A text node with `"text": "2"` (from `~2~`) carries `"marks": [{"type": "subsup", "attrs": {"type": "sub"}}]`
- Neither text node carries a `"strike"` mark
- Surrounding plain text nodes (e.g. `"H "`, `" O and CO "`, `" done"`) carry NO marks

Call 2: captured POST body `fields.description.content[0]` is a `paragraph`. Within its `content`:
- A text node with `"text": "deleted"` carries `"marks": [{"type": "strike"}]`
- The mark type is `"strike"`, NOT `"subsup"` — double-tilde `~~x~~` is NOT reassigned by `ENABLE_SUBSCRIPT`

**Critical boundary**: `ENABLE_SUBSCRIPT` reassigns single-tilde `~x~` from strikethrough to subscript. Double-tilde `~~x~~` must still produce `strike`. A regression where double-tilde emits `subsup` would silently change the meaning of all existing strikethrough markdown in Jira issues.

**Newline delivery**: N/A — single-line input (no multi-line content in either call).

**Why hidden**: The `subsup` mark type and its `attrs.type` (`"sup"` vs `"sub"`) are invisible from `jr issue view` text rendering (which renders them back to `^x^`/`~x~`). The single-tilde vs double-tilde distinction is particularly fragile: enabling `ENABLE_SUBSCRIPT` changes the parser, and a future pulldown-cmark update could inadvertently break the double-tilde path. Only asserting on the POST body ADF mark structure pins this correctly. The boundary-spacing requirement (opening delimiter preceded by whitespace) prevents this holdout from being unreproducible against a correct binary.

**Status**: MUST-PASS. Pins BC-7.2.007 (issue #474): `^x^`→subsup sup (boundary-spaced), `~x~`→subsup sub (boundary-spaced), `~~x~~`→strike. The `sup`/`sub` value inside `attrs.type` is load-bearing for ADF rendering in Jira Cloud.

---

### H-NEW-ADF-008: Bare `https://` URL in prose → text node gains a `link` mark with href preserved; `www.`-only host stays plain (MUST-PASS)

**NFR source**: BC-7.2.014 (bare-URL autolink: `http(s)://` explicit-scheme only, `www.`-prefix stays plain per EC-1, `href` casing preserved per EC-3, `ftp://` and other non-http(s) schemes excluded per EC-12)
**BC**: BC-7.2.014
**Authored by**: D4 holdout refresh Burst 1 (2026-06-26)

**Setup**:
1. Wiremock at `JR_BASE_URL` captures `POST /rest/api/3/issue` request body.
2. Mock `POST /rest/api/3/issue` returns 201 `{"id":"10008","key":"PROJ-8","self":"..."}`.

**Action (two calls)**:
1. `jr issue create --project PROJ --type Task --summary "bare-url" --description "See https://example.com for details." --markdown --no-input`
2. `jr issue create --project PROJ --type Task --summary "www-plain" --description "See www.example.com for details." --markdown --no-input`

**Expected (MUST-PASS)**:

Call 1: captured POST body `fields.description.content[0]` is a `paragraph`. Within its `content`:
- A text node with `"text": "https://example.com"` carries `"marks": [{"type": "link", "attrs": {"href": "https://example.com"}}]`
- The `href` value preserves the original casing exactly (`"https://example.com"` not modified)
- Surrounding text nodes (`"See "`, `" for details."`) carry NO `link` mark
- The URL text node has exactly ONE `link` mark (not stacked)

Call 2: captured POST body `fields.description.content[0]` is a `paragraph`. Within its `content`:
- A text node with `"text": "www.example.com"` carries NO `marks` key (or an empty `marks: []`) — it is plain text
- No `"type": "link"` mark appears anywhere in the paragraph

**Newline delivery**: N/A — single-line input (no multi-line content in either call).

**Boundary rationale for Call 2**: `www.`-prefixed hosts without an explicit scheme are deliberately out of scope for bare-URL autolinking (`autolink_bare_urls` matches `http(s)://` explicit schemes only). Jira's REST API does not auto-linkify `www.` text, so the URL would be unclickable either way — but emitting a link mark on a `www.` host would require scheme inference and carries high false-positive risk in prose. This holdout pins the out-of-scope boundary.

**Why hidden**: Jira's REST API does NOT auto-linkify plain-text URLs in a submitted ADF body (unlike the browser editor). A regression removing `autolink_bare_urls` would cause every bare `https://` URL in Jira issue descriptions to be rendered as non-clickable text — invisible from `jr issue create` exit codes or text output. The mock body assertion is the only observable channel. The `www.` case pins that the scope restriction is enforced, not quietly expanded.

**Status**: MUST-PASS. Pins issue #473 bare-URL autolinking: explicit-scheme `http(s)://` only, `href` case-preserved, `www.`-only stays plain. This is the regression pin that Jira REST API will not linkify plain text.

---

## Group 11: SEC-001 ADF Recursion-Depth Guard (H-NEW-SEC-001..H-NEW-SEC-002)

### H-NEW-SEC-001: Forward path — 256-deep markdown (≥256 blockquote levels) exits 64 with "nesting too deep"; NO POST fired (MUST-PASS)

**NFR source**: BC-7.2.012, SEC-001, CWE-674
**BC**: BC-7.2.012
**Authored by**: D4 holdout refresh Burst 2 (2026-06-26)

**Setup**:
1. Wiremock at `JR_BASE_URL` with `POST /rest/api/3/issue` mounted WITHOUT `.expect()` (the test must NOT fail on an unmounted endpoint in the RED state — but a separate `.expect(0)` assertion verifies zero calls after exit).
2. Mount `GET /rest/api/3/field` returning `[]` (cold CMDB fields cache).
3. Config with a valid profile (Bearer or Basic via `JR_AUTH_HEADER`).
4. Construct a 255-prefix nested blockquote markdown string: `"> ".repeat(255) + "leaf content"` — i.e. **255** `"> "` prefixes followed by `"leaf content"`. This is the exact inclusive boundary reject pin: N=255 prefixes produce a deepest recursive node at ADF depth N+1=256, which satisfies `depth >= MAX_ADF_DEPTH` → Err. (Ground truth: `test_markdown_to_adf_deepest_node_at_256_is_err_boundary_exact` in `src/adf.rs` calls `make_nested_blockquote_markdown(255)` and asserts Err.)

**Action**: `jr --no-input issue create --project PROJ --type Task --summary "sec-001 depth test" --description <255-prefix-blockquote-fixture> --markdown`

(In a process-spawn test: pass the 255-prefix markdown string as the `--description` argument. In a library-level test: call `markdown_to_adf` directly with the fixture string and assert `Err`.)

**Expected (MUST-PASS)**:
- exit code = 64 (NOT 0, NOT 1, NOT 2)
- stderr contains the substring `"nesting too deep"` (the canonical message emitted by the `>= MAX_ADF_DEPTH` guard in `normalize_list_item_content`, `normalize_blockquote_content`, `normalize_panel_content`, `assign_local_ids_walk`, and `autolink_bare_urls`)
- `POST /rest/api/3/issue` is NOT called — the depth guard fires BEFORE any HTTP call (the ADF conversion happens client-side, before the POST)
- stdout is empty (no issue key emitted)

**Boundary precision — inclusive boundary pins (kills `>` mutant, DEC-132)**:
- **255 prefixes** → deepest node at ADF depth 256 → MUST exit 64 (reject pin; `depth >= 256` fires)
- **254 prefixes** → deepest node at ADF depth 255 → MUST exit 0 and POST fired once (accept pin; `255 < 256` passes)
- These are the EXACT boundary pins verified by `test_markdown_to_adf_deepest_node_at_256_is_err_boundary_exact` (255 prefixes → Err) and `test_markdown_to_adf_depth_255_blockquote_is_ok` (254 prefixes → Ok) in `src/adf.rs`. The `>` mutant (`depth > 256`) would accept the 255-prefix case (deepest=256, `256 > 256 == false`) — asserting exit 64 for 255 prefixes kills that mutant. A 300-prefix "clearly-over" example may be added for clarity but cannot replace these tight boundary pins.

**Why hidden**: The guard condition uses `>=` (inclusive). A future refactor that silently changes `depth >= MAX_ADF_DEPTH` to `depth > MAX_ADF_DEPTH` would accept 255-prefix inputs (deepest depth=256), allowing pathologically nested markdown to reach `adf_to_text` and potentially cause stack overflow (CWE-674) in rendering. The exit-64 boundary at exactly 255 prefixes is the observable signal. Without asserting on mock call count, a regression where the guard fires after the POST would be invisible.

**Status**: MUST-PASS (security regression pin). Pins BC-7.2.012 forward path: `markdown_to_adf` post-passes (`normalize_*`, `assign_local_ids_walk`, `autolink_bare_urls`) reject depth ≥ 256 with `JrError::UserError` → exit 64 + "nesting too deep", ZERO HTTP calls. Off-by-one boundary: 255 prefixes rejects (depth 256), 254 prefixes accepts (depth 255) (DEC-132 inclusive-boundary correction).

**BC refs**: BC-7.2.012 (primary, SEC-001)

---

### H-NEW-SEC-002: Reverse path — `jr issue view` against a mock returning ADF nested ≥256 deep exits 64 with "nesting too deep"; no panic/stack-overflow (MUST-PASS)

**NFR source**: BC-7.2.012, SEC-001, CWE-674
**BC**: BC-7.2.012
**Authored by**: D4 holdout refresh Burst 2 (2026-06-26)

**Setup**:
1. Wiremock at `JR_BASE_URL` with `GET /rest/api/3/issue/PROJ-1` returning a 200 response whose `fields.description` is a pathologically nested ADF document with ≥256 levels of `blockquote` nesting. Construct the fixture as a Rust `serde_json::Value` using:
   ```
   // build 255-blockquote ADF (text rendered at depth 256 → triggers guard)
   let mut inner = json!({"type":"paragraph","content":[{"type":"text","text":"leaf"}]});
   for _ in 0..255 {
       inner = json!({"type":"blockquote","content":[inner]});
   }
   let adf = json!({"version":1,"type":"doc","content":[inner]});
   ```
   (255 blockquote wrappers around a paragraph containing a text leaf: depth chain is `render_node(blockquote_255, 254)` → `render_node(paragraph, 255)` → `render_node(text, 256)`. The paragraph renders at depth 255 (passes the guard). The text/leaf node renders at depth 256 — `256 >= MAX_ADF_DEPTH` fires the guard. The guard fires at the TEXT/leaf node, not at the paragraph node; depth-255 paragraph passes first.)
2. Config with a valid profile.
3. No `--markdown` flag needed (this is the REVERSE path: reading ADF from Jira, not writing markdown to Jira).

**Action**: `jr issue view PROJ-1`

**Expected (MUST-PASS)**:
- exit code = 64 (NOT a panic/stack-overflow, NOT exit 0 with garbled output, NOT an unhandled thread panic)
- stderr contains the substring `"nesting too deep"` (the canonical message from `AdfRenderer::render_node`'s depth guard: `"ADF response nesting too deep (max 256 levels) — the issue data returned by Jira cannot be rendered"`)
- The binary terminates cleanly — no `SIGABRT`, no `thread 'main' panicked`, no `stack overflow`
- stdout does NOT contain `"leaf"` (the guard fires before the leaf text is reached)

**Boundary precision — inclusive boundary pin (kills `>` mutant)**:
- **255-blockquote ADF**: paragraph renders at depth 255 (passes); text/leaf node renders at depth 256 → `256 >= 256` fires the guard → MUST exit 64. Verified by `test_adf_to_text_deepest_node_at_256_is_err_boundary_exact` in `src/adf.rs` (`make_nested_adf_value(255)` → Err).
- **254-blockquote ADF**: text/leaf node renders at depth 255 → `255 < 256` passes → MUST exit 0 with `"leaf"` in stdout. Verified by `test_adf_to_text_depth_255_is_ok` (`make_nested_adf_value(254)` → Ok).
- To verify the 254-blockquote accepts boundary: feed a 254-blockquote ADF to the mock; assert exit 0 and stdout contains `"leaf"` (the leaf text is rendered).
- The `>` mutant (`depth > 256`) would accept the 255-blockquote case (deepest=256, `256 > 256 == false`) — asserting exit 64 for 255 blockquotes kills that mutant.

**Why hidden**: The `adf_to_text` guard (`render_node` checking `depth >= MAX_ADF_DEPTH`) protects against CWE-674 stack overflow on the RENDERING path. A malicious or malformed Jira response containing deeply-nested ADF could previously cause `jr issue view` to stack-overflow and crash with `SIGABRT`. The exit-64 + clean termination is the security postcondition. This is invisible without: (a) a mock that returns pathologically nested ADF (not possible with a real Jira instance), and (b) asserting on exit code rather than just on rendered text. Without the depth check, the binary would exhaust stack memory and terminate abnormally — a harder-to-diagnose failure mode than a clean exit-64.

**Status**: MUST-PASS (security regression pin). Pins BC-7.2.012 reverse path: `adf_to_text` → `AdfRenderer::render_node` rejects `depth >= MAX_ADF_DEPTH` with `JrError::UserError` → exit 64 + "nesting too deep", clean termination (no panic/stack-overflow). The exact error message substring is `"nesting too deep"`. Off-by-one boundary: 255 blockquotes → paragraph at depth 255 (passes) → text/leaf at depth 256 → guard fires → exit 64; 254 blockquotes → text/leaf at depth 255 → passes → exit 0 with "leaf" rendered.

**BC refs**: BC-7.2.012 (primary, SEC-001)

---

## Group 12: ADF Footnote Empty-Container Pruning + Code-Mark Exclusivity (H-NEW-ADF-009..H-NEW-ADF-010)

### H-NEW-ADF-009: Footnote definition enclosed in a blockquote → empty blockquote shell is PRUNED (no empty-content container in submitted ADF); definition enclosed in a list → listItem keeps a valid placeholder empty paragraph, NOT pruned (MUST-PASS)

**NFR source**: BC-7.2.013 (EC-6 blockquote-pruning, EC-7 list-placeholder)
**BC**: BC-7.2.013
**Authored by**: G-ADF-FOOTNOTE gap close (2026-06-27)

**Setup**:
1. Wiremock at `JR_BASE_URL` captures `POST /rest/api/3/issue` request body for both calls.
2. Mock `POST /rest/api/3/issue` returns 201 `{"id":"10009","key":"PROJ-9","self":"..."}`.
3. Config with a valid profile (Bearer or Basic via `JR_AUTH_HEADER`).

**Action (two calls)**:

Call A — blockquote-enclosed definition:
Feed the following markdown to `jr issue create --project PROJ --type Task --summary "footnote-blockquote" --markdown --no-input --description-stdin`:
```
Body.[^1]

> [^1]: quoted note
```
(Real newlines via `--description-stdin`; do NOT use `\n` literal in a `--description` argument — the binary does not decode escape sequences.)

Call B — list-enclosed definition:
Feed the following markdown to `jr issue create --project PROJ --type Task --summary "footnote-list" --markdown --no-input --description-stdin`:
```
Body.[^1]

- [^1]: listed note
```

**Expected (MUST-PASS)**:

**Call A — blockquote case (EC-6: empty blockquote shell pruned)**:
1. exit code = 0; POST fired exactly once.
2. Captured POST body `fields.description` is a valid ADF document. Walk EVERY node in `content` recursively — NONE may be `{"type": "blockquote", "content": []}` (empty-content blockquote). The empty blockquote shell left by pulldown after hoisting the definition is pruned by `is_empty_block_container`.
3. The captured body DOES contain the definition content: at least one `paragraph` node whose text starts with `"[1] "` and whose text also contains `"quoted note"` — the definition body is preserved in the footnote section after the `rule` divider.
4. The captured body contains exactly ONE `"type": "rule"` node (the footnote-section divider).
5. No node anywhere in the body has `"type": "blockquote"` (the only blockquote was the empty shell, which was pruned).

**Call B — list case (EC-7: list-enclosed definition keeps placeholder paragraph, NOT pruned)**:
1. exit code = 0; POST fired exactly once.
2. Captured POST body `fields.description` is a valid ADF document. Walk EVERY `listItem`/`bulletList`/`orderedList` node — NONE may have an empty `content` array. The `listItem` retains a valid placeholder empty paragraph (valid ADF), keeping the container non-empty.
3. The captured body DOES contain a `bulletList` node with at least one `listItem`. That `listItem`'s `content` array is NON-EMPTY (it holds at least one node — the placeholder paragraph). Specifically: the `listItem.content` array contains exactly one `{"type": "paragraph", "content": []}` (the valid empty placeholder paragraph).
4. The captured body also contains the definition content: at least one `paragraph` node (outside the `bulletList`) whose text starts with `"[1] "` and contains `"listed note"` — the definition body survived in the appended footnote section.
5. The captured body contains exactly ONE `"type": "rule"` node.

**Critical distinction**: The two cases behave differently by design. The `blockquote` container is pruned because an empty `blockquote` is invalid ADF (Jira HTTP 400). The `listItem`/`bulletList` are NOT pruned because the placeholder empty paragraph makes them non-empty — empty `paragraph` is valid ADF. Conflating the two cases is a HIGH-severity characterization error (EC-7 was introduced precisely to document this asymmetry).

**Note on newline delivery**: Both calls use `--description-stdin`. The fixture must contain REAL newline characters (U+000A). Shell heredoc (`<<'EOF'`), a fixture file, or a Rust raw string literal in `assert_cmd` test code are all acceptable delivery mechanisms. A literal `\n` passed as a CLI argument is NOT decoded and breaks footnote recognition.

**Why hidden**: The empty-blockquote-pruning behavior is a Jira-400-guard: an empty `content` array in a `blockquote`/`listItem`/`bulletList` node causes Jira Cloud REST API to reject the request with HTTP 400. The pruning is invisible from exit codes or `jr issue view` text rendering — a regression removing the pruning would cause `jr issue create` to succeed locally (the ADF is constructed client-side) but Jira would reject it with HTTP 400 at POST time. Without a wiremock that captures and asserts the POST body, this silent regression is undetectable. The list-case asymmetry is equally hidden: a regression that pruned the list container (incorrectly treating the placeholder paragraph as "empty") would produce an empty-`content` `listItem` — invalid ADF → Jira 400. The only observable channel is the POST body node structure.

**Status**: MUST-PASS. Pins BC-7.2.013 EC-6 (blockquote-enclosed definition → empty shell pruned, no empty-content blockquote in ADF) and EC-7 (list-enclosed definition → listItem retains placeholder empty paragraph, NOT pruned, container non-empty). Grounded in `src/adf.rs::is_empty_block_container` (prunes containers with empty `content` except when a valid placeholder is present) and `src/adf.rs::test_markdown_footnote_definition_in_blockquote_no_empty_container` + `src/adf.rs::test_markdown_footnote_definition_in_list_no_empty_container`.

**BC refs**: BC-7.2.013 (primary; EC-6 blockquote-pruning, EC-7 list-placeholder)

---

### H-NEW-ADF-010: Text node with `code` mark carries NO typographic marks; `link` mark co-exists with `code` on same node; surrounding non-code text retains marks; JSM path parity confirmed (MUST-PASS)

**NFR source**: BC-7.2.015
**BC**: BC-7.2.015
**Authored by**: ADF-CODE-MARK-EXCLUSIVITY F2 (2026-07-07; issue #571)

**Setup**:
1. Wiremock at `JR_BASE_URL` captures `POST /rest/api/3/issue` request body for each call.
2. Mock `POST /rest/api/3/issue` returns 201 `{"id":"10010","key":"PROJ-10","self":"..."}`.
3. Config with a valid profile (Bearer or Basic via `JR_AUTH_HEADER`).

**Action (five calls)**:

Call A — strong wrapping code (EC-1):
`jr issue create --project PROJ --type Task --summary "strong-code" --markdown --no-input --description "**\`hello\`**"`

Call B — subsup wrapping code (EC-4; the primary regression target):
`jr issue create --project PROJ --type Task --summary "subsup-code" --markdown --no-input --description "^\`code\`^"`

Call C — link wrapping code (EC-5; link must be preserved):
`jr issue create --project PROJ --type Task --summary "link-code" --markdown --no-input --description "[\`code\`](https://example.com)"`

Call D — mixed range: strong surrounding a code span (EC-6):
`jr issue create --project PROJ --type Task --summary "mixed-range" --markdown --no-input --description "**a \`b\` c**"`

Call E — JSM path parity (EC-4 via `handle_jsm_create`; pins that `requestFieldValues.description` obeys the same invariant as `fields.description`):

For Call E, mount instead (the shared `POST /rest/api/3/issue` mount does NOT apply to this call; `POST /rest/api/3/issue` must NOT be called):
1. Mount `GET /rest/api/3/project/HELPDESK` returning `{"id":"77","key":"HELPDESK","projectTypeKey":"service_desk","simplified":false}` — `require_service_desk` calls `get_or_fetch_project_meta` first on cache miss; the numeric `id` `"77"` is the project_id used to match the service desk entry below.
2. Mount `GET /rest/servicedeskapi/servicedesk` returning `{"size":1,"start":0,"limit":50,"isLastPage":true,"values":[{"id":"3","projectId":"77","projectName":"Help Desk"}]}` — `ServiceDesk` struct deserializes `id`/`projectId`/`projectName` only (no `projectKey` field); match is `d.project_id == "77"`.
3. Mount `GET /rest/servicedeskapi/servicedesk/3/requesttype?start=0&limit=50` returning `{"size":1,"start":0,"limit":50,"isLastPage":true,"values":[{"id":"5","name":"Get IT Help","description":"IT support"}]}` — `ServiceDeskPage` requires non-optional `size`/`start`/`limit`.
4. Mount `POST /rest/servicedeskapi/request` with `expect(1)` returning 201 `{"issueId":"10042","issueKey":"HELP-42","currentStatus":{"status":"Waiting for support"},"_links":{"web":{"href":"https://example.atlassian.net/browse/HELP-42"}}}`.

`jr issue create --project HELPDESK --request-type "Get IT Help" --summary "jsm-code" --markdown --no-input --description "^\`code\`^"`

**Expected (MUST-PASS)**:

**Calls A–D — code-mark exclusivity invariant (platform path, `POST /rest/api/3/issue`)**:
For EVERY `POST /rest/api/3/issue` captured body: walk the `fields.description` ADF tree recursively. For EVERY text node that has a `"type": "code"` entry in its `"marks"` array, assert its `"marks"` array contains NO entry with `"type"` in `["strong", "em", "strike", "subsup", "underline", "textColor", "backgroundColor"]`.

**Call A — strong stripped**:
1. exit code = 0; exactly one POST fired.
2. `fields.description` contains exactly one text node whose text is `"hello"` and whose `marks` array is `[{"type":"code"}]` — NOT `[{"type":"strong"},{"type":"code"}]`.

**Call B — subsup stripped (primary regression target, issue #571)**:
1. exit code = 0; exactly one POST fired.
2. `fields.description` contains exactly one text node whose text is `"code"` and whose `marks` array is `[{"type":"code"}]` — NOT `[{"type":"subsup","attrs":{"type":"sup"}},{"type":"code"}]`.

**Call C — link preserved alongside code**:
1. exit code = 0; exactly one POST fired.
2. `fields.description` contains exactly one text node whose text is `"code"` and whose `marks` array contains BOTH `{"type":"code"}` AND a `link` mark entry with `attrs.href == "https://example.com"` — the `link` mark is a permitted co-mark and MUST be preserved.
3. The marks array contains NO typographic mark entries.

**Call D — surrounding strong nodes retain marks; inner code node is stripped**:
1. exit code = 0; exactly one POST fired.
2. `fields.description` contains at least three text nodes from the `**a \`b\` c**` span:
   - One text node with text equal to `"a "` (trailing space) whose `marks` array includes `{"type":"strong"}`.
   - One text node with text equal to `"b"` whose `marks` array is `[{"type":"code"}]` (code only — strong stripped).
   - One text node with text equal to `" c"` (leading space) whose `marks` array includes `{"type":"strong"}`.
3. The `"b"` node MUST NOT have `{"type":"strong"}` in its marks.

**Call E — JSM path parity (EC-4 via `handle_jsm_create`, `POST /rest/servicedeskapi/request`)**:
1. exit code = 0; exactly one POST to `/rest/servicedeskapi/request` fired (`.expect(1)` satisfied); `POST /rest/api/3/issue` NOT called.
2. Captured POST body `requestFieldValues.description` is a valid ADF document. The code-mark exclusivity invariant holds: for EVERY text node that has a `"type":"code"` entry in its `"marks"` array, the `"marks"` array contains NO entry with `"type"` in `["strong","em","strike","subsup","underline","textColor","backgroundColor"]`.
3. Specifically: the ADF contains exactly one text node whose text is `"code"` and whose `marks` array is `[{"type":"code"}]` — NOT `[{"type":"subsup","attrs":{"type":"sup"}},{"type":"code"}]`. The `subsup` mark is stripped by `push_code` regardless of which endpoint the final POST targets.

**Newline delivery**: N/A — single-line input (Calls A–E; no multi-line content).

**Why hidden**: The `code`-mark exclusivity rule is enforced at emission time in `src/adf.rs::push_code`. A regression removing the strip would result in ADF text nodes carrying both `code` and a typographic mark — violating the ADF schema (`code_inline_node` permits only `code`, `link`, `annotation`). Jira Cloud REST API rejects such nodes with HTTP 400, but the binary still exits 0 (ADF is built client-side before the POST). Without a wiremock that captures and asserts the POST body's `marks` arrays, a silent mark-strip regression is undetectable from exit codes or human-mode output. Call C specifically pins the positive permissibility of `link` alongside `code` — a correct implementation MUST preserve the `link` mark. Call E provides JSM-path parity evidence: `markdown_to_adf` and `push_code` are the single shared conversion engine invoked by both `handle_create` (platform) and `handle_jsm_create` (ADR-0014 JSM fork); a regression confined to the JSM dispatch branch would not be caught by Calls A–D alone.

**Status**: MUST-PASS. Pins BC-7.2.015 (code-mark exclusivity at emission time) EC-1 (strong stripped), EC-4 (subsup stripped; primary issue #571 regression target), EC-5 (link preserved), EC-6 (surrounding non-code text retains marks), and JSM-path parity (Call E). Grounded in `src/adf.rs::push_code` (sole emit site for code marks).

**BC refs**: BC-7.2.015 (primary; EC-1 strong-stripped, EC-4 subsup-stripped, EC-5 link-preserved, EC-6 mixed-range, Call-E JSM-path parity)

---

## Group 13: Issue Edit, Changelog, Worklog, Links, and Queue Coverage (H-NEW-EDIT-FIELD-001..H-NEW-QUEUE-VIEW-001)

### H-NEW-EDIT-FIELD-001: `issue edit --field NAME=VALUE` where field is absent from editmeta → exit 64 with Edit-screen hint; zero PUT (MUST-PASS)

**NFR source**: BC-3.4.015 (EC-3.4.015-3, VP-396-003)
**BC**: BC-3.4.015
**Authored by**: F2 holdout authoring Burst 1 (2026-06-30)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config with a valid profile (Bearer or Basic via `JR_AUTH_HEADER`).
2. Mount `GET /rest/api/3/field` returning a non-empty fields array that includes the entry `{"id": "customfield_10200", "name": "My Field", "schema": {"type": "string"}}` (so the field exists in the global field list and name resolution succeeds). Alternatively, warm the fields cache with `JR_CACHE_DIR` pointing to a temp dir containing a pre-written `fields.json` with that entry — so no `GET /rest/api/3/field` HTTP call is needed (cache-hit path, EC-3.4.015-14).
3. Mount `GET /rest/api/3/issue/FOO-1/editmeta` returning `{"fields": {}}` — an empty fields map, meaning `"My Field"` / `"customfield_10200"` is NOT on the Edit screen for this issue.
4. Mount `PUT /rest/api/3/issue/FOO-1` with `.expect(0)` — the PUT MUST NOT be called.

**Action**: `jr issue edit FOO-1 --field "My Field=Some Value" --no-input`

**Expected (MUST-PASS)**:
- Exit code = 64.
- stderr contains BOTH of the following substrings (exact strings from `src/cli/issue/field_resolve.rs` Step 3 error, verified from source):
  - `"is not on the Edit screen"` (from the emitted message: `"Field 'My Field' (customfield_10200) is not on the Edit screen for issue FOO-1."`)
  - `"A project admin must add it to the Edit screen"` (from the continuation: `"A project admin must add it to the Edit screen before it can be edited via \`jr issue edit --field\`"`)
- `PUT /rest/api/3/issue/FOO-1` is NOT called (`.expect(0)` satisfied).
- stdout is empty.

**Boundary note**: EC-3.4.015-3 covers the case where the field IS found in `list_fields()` but IS absent from `editmeta`. If the field were also absent from `list_fields()` the error would instead be EC-3.4.015-1 (zero-match hint naming `jr project fields`). The distinction matters: the Edit-screen hint is specifically for the editmeta gate, not the name-resolution gate. This scenario pins the editmeta gate (Step 3 of `resolve_edit_fields`).

**Why hidden**: The editmeta gate fires AFTER name resolution succeeds — it is invisible from the field-name error path. A regression where `resolve_edit_fields` skips the editmeta check (Step 3) and attempts the PUT regardless would silently send a field that Jira rejects with a server-side error, replacing the actionable Edit-screen hint with a generic API error. The zero-PUT mock assertion is the only observable channel for this gate.

**Status**: MUST-PASS. Pins BC-3.4.015 EC-3.4.015-3 (field absent from editmeta → exit 64 + Edit-screen hint + zero PUT). VP-396-003 verifies this path.

**BC refs**: BC-3.4.015 (primary; EC-3.4.015-3, VP-396-003)

---

### H-NEW-EDIT-FIELD-002: `--field` on 2 positional keys → C-1 guard exits 64 BEFORE any editmeta GET or PUT (MUST-PASS)

**NFR source**: BC-3.4.017 (Gate A, EC-3.4.017-1)
**BC**: BC-3.4.017
**Authored by**: F2 holdout authoring Burst 1 (2026-06-30)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config with a valid profile.
2. Mount `GET /rest/api/3/issue/FOO-1/editmeta` with `.expect(0)` — must NOT be called.
3. Mount `GET /rest/api/3/issue/FOO-2/editmeta` with `.expect(0)` — must NOT be called.
4. Mount `PUT /rest/api/3/issue/FOO-1` with `.expect(0)` — must NOT be called.
5. Mount `PUT /rest/api/3/issue/FOO-2` with `.expect(0)` — must NOT be called.
6. No `GET /rest/api/3/field` mock is needed — the C-1 guard fires before field-list resolution.

**Action**: `jr issue edit FOO-1 FOO-2 --field "Story Points=5" --no-input`

**Expected (MUST-PASS)**:
- Exit code = 64.
- stderr contains a message indicating that `--field` is single-key only (e.g., references the bulk-rejection or single-key requirement per BC-3.4.017 Gate A).
- Both editmeta GETs are NOT called (both `.expect(0)` satisfied).
- Both PUT mocks are NOT called (both `.expect(0)` satisfied).
- stdout is empty.

**Why hidden**: The C-1 guard (Gate A) fires as a pure argument check BEFORE any HTTP call — before field-list fetch, before editmeta fetch, before PUT. A regression where the guard is weakened (e.g., by routing multi-key `--field` to a bulk path instead of rejecting) would silently attempt a write with incorrect semantics. The zero-editmeta-GET assertion is the critical observable property: if even one editmeta GET fires, the guard was bypassed. This is the most upstream observable gate on the `--field` code path.

**Status**: MUST-PASS. Pins BC-3.4.017 Gate A (EC-3.4.017-1: multi-key `--field` → exit 64 before any HTTP, including editmeta GET).

**BC refs**: BC-3.4.017 (primary; Gate A, EC-3.4.017-1)

---

### H-NEW-EDIT-TYPE-001: Bulk `--type` with cross-project keys → exit 64 BEFORE createmeta GET and bulk POST (MUST-PASS)

**NFR source**: BC-3.4.019 (EC-3.4.019-1, VP-331-003)
**BC**: BC-3.4.019
**Authored by**: F2 holdout authoring Burst 1 (2026-06-30)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config with a valid profile.
2. Mount `GET /rest/api/3/issue/createmeta/FOO/issuetypes` with `.expect(0)` — must NOT be called.
3. Mount `GET /rest/api/3/issue/createmeta/BAR/issuetypes` with `.expect(0)` — must NOT be called.
4. Mount `POST /rest/api/3/bulk/issues/fields` with `.expect(0)` — must NOT be called.

**Action**: `jr issue edit FOO-1 BAR-2 --type Bug --no-input`

**Expected (MUST-PASS)**:
- Exit code = 64.
- stderr contains ALL of the following (per BC-3.4.019 Postconditions):
  - The literal `--type` (names the offending flag).
  - A reference to the cross-project constraint (e.g., `"requires all issues to be in the same project"` or equivalent).
  - Both distinct project keys: `FOO` and `BAR`.
- Neither createmeta GET mock is called (both `.expect(0)` satisfied).
- Bulk POST mock is NOT called (`.expect(0)` satisfied).
- stdout is empty (no `plannedChanges` output).

**Why hidden**: The cross-project guard is a pure client-side argument check that fires BEFORE name→issueTypeId resolution (BC-3.4.019 Invariant 1). A regression removing this guard would allow the bulk POST to proceed with the issueTypeId resolved from project FOO applied to all keys including BAR-2 — a silent partial-mutation (BAR-2's type would be set to a FOO-scoped issueTypeId, causing a server-side error or applying the wrong type). The zero-HTTP assertion is the key observable property: createmeta is only called after the cross-project check passes.

**Status**: MUST-PASS. Pins BC-3.4.019 EC-3.4.019-1 (cross-project `--type` → exit 64 before any HTTP; stderr names `--type` and both project keys). VP-331-003 verifies this path.

**BC refs**: BC-3.4.019 (primary; EC-3.4.019-1, VP-331-003)

---

### H-NEW-EDIT-TYPE-002: Multi-key `--type` bulk POST body has `selectedActions: ["issuetype"]` (lowercase) AND `editedFieldsInput: {"issueType": {"issueTypeId": "<id-string>"}}` (camelCase key) (HIGHEST VALUE — MUST-PASS)

**NFR source**: BC-3.4.018 (EC-3.4.018-1, VP-331-001)
**BC**: BC-3.4.018
**Authored by**: F2 holdout authoring Burst 1 (2026-06-30)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config with a valid profile.
2. Mount `GET /rest/api/3/issue/createmeta/FOO/issuetypes` returning `{"issueTypes": [{"id": "10001", "name": "Bug"}]}` — camelCase `issueTypes` key, matching the `#[serde(rename = "issueTypes")]` field on `CreatemetaIssueTypesResponse` in `src/api/jira/issues.rs`. Using lowercase `"issuetypes"` would deserialize to an empty list, causing exit 64 with "Issue type not found" — a false-reject.
3. Mount `POST /rest/api/3/bulk/issues/fields` capturing the request body, returning 200 `{"taskId": "task-abc-123"}`.
4. Mount `GET /rest/api/3/bulk/queue/task-abc-123` returning `{"status": "COMPLETE", "progressPercent": 100}` — the exact poll path used by `poll_bulk_task` in `src/api/jira/bulk.rs` (`format!("/rest/api/3/bulk/queue/{}", urlencoding::encode(task_id))`).

**Action**: `jr issue edit FOO-1 FOO-2 --type Bug --no-input`

**Expected (MUST-PASS)**:
- Exit code = 0.
- The captured POST body to `POST /rest/api/3/bulk/issues/fields` satisfies ALL of:
  - `"selectedActions"` array contains the lowercase string `"issuetype"` (NOT `"issueType"`, NOT `"issue_type"`).
  - `"editedFieldsInput"` object contains the camelCase key `"issueType"` (NOT `"issuetype"`, NOT `"issue_type"`).
  - `"editedFieldsInput"."issueType"` is an object `{"issueTypeId": "10001"}` — the value is a string ID, NOT `{"name": "Bug"}`.
  - `"selectedIssueIdsOrKeys"` contains both `"FOO-1"` and `"FOO-2"`.
  - The body does NOT contain `"name": "Bug"` inside the `issueType` value position (the name must NOT be forwarded verbatim; only the resolved ID is sent).
- The `selectedActions` entry `"issuetype"` (lowercase) and the `editedFieldsInput` key `"issueType"` (camelCase) intentionally differ — this asymmetry is confirmed by the verbatim Atlassian Bulk Operations FAQ and the confirmed live-run behavior (CLAUDE.md Gotcha). Do NOT assert them equal.

**Citation note**: The asymmetry between `selectedActions: ["issuetype"]` (lowercase field ID) and `editedFieldsInput.issueType` (camelCase container key) is documented verbatim in the official Atlassian "Bulk operations: additional examples and FAQs" page, which explicitly shows both fields in the same `editedFieldsInput` JSON example alongside `priority` and `labelsFields` — this page is the established source of truth (`.factory/research/issue-331-issuetype-bulk-schema.md` lines 33/41/43: "Verbatim fetch of the official Atlassian Bulk Operations FAQ page…This is the source of truth."). BC-3.4.018 Invariant 3 (`bc-3-issue-write.md`) cites it as "confirmed by the verbatim Atlassian Bulk Operations FAQ example." The confirmed live-run record (Atlassian community 2026-02-19 + live run 27156639337) provides empirical corroboration.

**Why hidden**: This is the highest-value regression target in this batch. A "fix" that normalizes both keys to either lowercase (`"issuetype"`) or camelCase (`"issueType"`) would produce an Atlassian API rejection. The asymmetry is counterintuitive — it looks like a bug — making it a prime target for a well-intentioned refactor. Only asserting on the actual POST body can catch this regression. The mock-body capture is the only observable channel; exit codes alone cannot distinguish correct from incorrect wire shapes.

**Status**: MUST-PASS. Pins BC-3.4.018 EC-3.4.018-1 (happy path: `selectedActions` lowercase `"issuetype"`, `editedFieldsInput` camelCase `"issueType"` with `issueTypeId` string). VP-331-001 verifies the wire shape. CLAUDE.md Gotcha: "`selectedActions` uses lowercase `\"issuetype\"` (canonical field ID); `editedFieldsInput` uses camelCase `\"issueType\"` (bean name) — verbatim per Atlassian Bulk Ops FAQ, same as `labelsFields`/`\"labels\"`. Do NOT fix."

**BC refs**: BC-3.4.018 (primary; EC-3.4.018-1, VP-331-001)

---

### H-NEW-CHANGELOG-001: `issue changelog --output json` preserves explicit `null` for `fromString`/`toString` and `author` when Jira returns null (fixture-supplied); client serialization contract (MUST-PASS)

**NFR source**: BC-2.5.046
**BC**: BC-2.5.046
**Authored by**: F2 holdout authoring Burst 1 (2026-06-30)

**Setup**:
1. Wiremock at `JR_BASE_URL`. Config with a valid profile.
2. Mount `GET /rest/api/3/issue/FOO-1/changelog` returning the following body verbatim. `get_changelog` deserializes this into `OffsetPage<ChangelogEntry>` and reads `page.values` (verified from `src/api/jira/issues.rs::get_changelog`). The envelope key is `"values"` — NOT `"histories"`, NOT a bare array. `startAt`/`maxResults`/`total` are `#[serde(default)]` on `OffsetPage` so they default to 0 if omitted, but are included here for clarity:
   ```json
   {
     "values": [
       {
         "id": "10000",
         "created": "2026-04-16T14:02:11.000+0000",
         "author": {"accountId": "user-abc", "displayName": "Alice", "emailAddress": "alice@example.com", "active": true},
         "items": [{"field": "status", "fieldtype": "jira", "from": "1", "fromString": "To Do", "to": "3", "toString": "In Progress"}]
       },
       {
         "id": "10001",
         "created": "2026-04-14T11:10:00.000+0000",
         "author": null,
         "items": [{"field": "assignee", "fieldtype": "jira", "from": null, "fromString": null, "to": null, "toString": null}]
       }
     ],
     "startAt": 0,
     "maxResults": 100,
     "total": 2
   }
   ```
   Entry A (`id: "10000"`, created `2026-04-16`, NEWER) will sort to index 0 in default reverse-chronological output. Entry B (`id: "10001"`, created `2026-04-14`, OLDER) will sort to index 1. Both entries MUST include `created` (required non-Option on `ChangelogEntry`) and each item MUST include `field` and `fieldtype` (required non-Option fields on `ChangelogItem` per `src/types/jira/changelog.rs`). Entry B `author: null`, `fromString: null`, `toString: null` — these are explicitly `null` in JSON, not absent keys.

**Sort order note**: `handle_changelog` sorts entries reverse-chronologically by `created` (newer first) when `--reverse` is absent (verified from `src/cli/issue/changelog.rs`: `sort_by(|a, b| cmp(b, a))`). Entry A (`2026-04-16`) is newer → index 0 in output; Entry B (`2026-04-14`) is older → index 1. Both `created` timestamps must be parseable by `parse_created` to achieve deterministic ordering.

**Note on precondition framing**: The fixture supplies the null values. This holdout does NOT assert that the Jira Cloud REST API *guarantees* null fields in a specific scenario — nulls occur in practice (system/automation events, field-clearing transitions) but are not explicitly documented as a guarantee. The holdout pins `jr`'s client-serialization contract: given a fixture that returns `fromString: null`, `toString: null`, `author: null`, `jr --output json` MUST round-trip these as explicit JSON `null` values, not as absent keys, not as `{}`, and not as any other representation.

**Action**: `jr issue changelog FOO-1 --output json`

**Expected (MUST-PASS)**:
- Exit code = 0.
- stdout parses as valid JSON.
- The JSON contains an `"entries"` array with exactly 2 items.
- `entries[0]` (newer, Entry A, reverse-chronological default): `author` is a non-null object containing `"accountId": "user-abc"`. `items[0].fromString` is the string `"To Do"` and `items[0].toString` is the string `"In Progress"`.
- `entries[1]` (older, Entry B, system event): `"author"` key is present with value `null` (NOT absent, NOT `{}`). `items[0].fromString` key is present with value `null` (NOT absent). `items[0].toString` key is present with value `null` (NOT absent).
- The top-level `"key"` field equals `"FOO-1"`.

**Why hidden**: The null-vs-absent distinction is invisible from table output and from commands that only check exit codes. A serde deserialization regression that derives `#[serde(skip_serializing_if = "Option::is_none")]` on the `fromString`/`toString` fields would serialize `null` as absent (omitting the key), silently breaking downstream JSON consumers that distinguish between "field not changed" (absent) and "field changed to null / unknown". A regression that serializes `author: null` as `author: {}` would break consumers checking the author identity. The `--output json` channel is the only place this distinction is observable.

**Status**: MUST-PASS. Pins BC-2.5.046 (changelog JSON shape including nullable `fromString`/`toString` and nullable `author`). Grounded in `tests/snapshots/issue_changelog__changelog_json_output_snapshot.snap`.

**BC refs**: BC-2.5.046 (primary)

---

### H-NEW-WORKLOG-ADD-001: `worklog add` passes `timeSpent` verbatim to Jira; malformed duration rejected client-side (exit 64) BEFORE any POST (MUST-PASS)

**NFR source**: BC-X.5.009, BC-X.5.001
**BC**: BC-X.5.009
**Authored by**: F2 holdout authoring Burst 1 (2026-06-30)

**Setup (two separate invocations)**:

Call A (happy-path verbatim passthrough):
1. Wiremock captures `POST /rest/api/3/issue/FOO-1/worklog` returning 201 with a minimal valid Worklog JSON body: `{"id": "10101", "author": {"accountId": "user-abc", "displayName": "Alice"}, "timeSpent": "1h30m", "timeSpentSeconds": 5400, "started": "2026-06-30T10:00:00.000+0000"}`.

Call B (client-side bad-duration gate):
1. Wiremock mounts `POST /rest/api/3/issue/FOO-1/worklog` with `.expect(0)` — must NOT be called.

**Note on the bad-duration gate**: `parse_duration_validate` is a `jr` client-side syntax validator (BC-X.5.005). Whether Jira would accept or reject a given duration string is irrelevant to this holdout — the gate fires in `jr`'s own parser before any HTTP call. The test uses `"5"` — a bare number with no unit suffix — which hits the "number without unit" error branch of `parse_duration_validate` (verified from `src/duration.rs` lines 74-79: `current_num` is non-empty and `found_any` is false at end-of-loop → `"Invalid duration \"5\": number without unit."`), anchored by BC-X.5.008. Do NOT use `"badunit"` here: that starts with a non-digit so `current_num.is_empty()` fires first and emits `"a unit letter appeared before any number"` — that branch has no dedicated BC. (BC-X.5.007 covers the EMPTY-input case `parse_duration("")` → `"Duration cannot be empty"`, per `src/duration.rs:7-9` and `cross-cutting.md:342` — distinct from the unit-before-number branch.)

**Action A**: `jr worklog add FOO-1 1h30m "Fixed the thing" --no-input`

**Action B**: `jr worklog add FOO-1 5 "message" --no-input`

**Expected A (MUST-PASS)**:
- Exit code = 0.
- The captured POST body to `POST .../worklog` contains `"timeSpent": "1h30m"` — the exact user-supplied string, verbatim (NOT normalized to `"90m"`, NOT `5400`, NOT `5400s`). Jira's server handles normalization using its configured `workingHoursPerDay`/`workingDaysPerWeek` settings (BC-X.5.009: verbatim passthrough, RESOLVED NFR-R-C).

**Expected B (MUST-PASS)**:
- Exit code = 64.
- stderr contains `"number without unit"` (exact substring from `src/duration.rs` lines 75-77: `"Invalid duration \"5\": number without unit."`).
- `POST .../worklog` is NOT called (`.expect(0)` satisfied).

**Why hidden**: The verbatim passthrough (Action A) is invisible from exit codes — a regression re-introducing client-side arithmetic (as existed before S-2.06/PR #308) would produce a different `timeSpent` string that SILENTLY gives wrong results on Jira instances with custom `workingHoursPerDay` settings. Only asserting on the captured POST body reveals whether the passthrough is intact. The client-side gate (Action B) is invisible from a test that only checks the Jira response — without a zero-POST assertion, a regression removing the gate would silently forward the invalid string to Jira (which might or might not reject it depending on the Jira instance's leniency). Both channels are required.

**Status**: MUST-PASS. Pins BC-X.5.009 (verbatim `timeSpent` passthrough; RESOLVED NFR-R-C) and BC-X.5.001 (POST accepted, 201). Call B pins BC-X.5.008 (number without unit → `jr` client-side exit 64 before POST).

**BC refs**: BC-X.5.009 (primary, verbatim passthrough), BC-X.5.001 (POST shape), BC-X.5.008 (number without unit → exit 64)

---

### H-NEW-LINK-001: `issue link --type block` (ambiguous) → exit 64 + `"Ambiguous link type"` + zero POST; `issue link` with no `--type` → POST fires with `jr`'s default selection `"Relates"` (MUST-PASS)

**NFR source**: BC-3.6.002, BC-3.6.001
**BC**: BC-3.6.002, BC-3.6.001
**Authored by**: F2 holdout authoring Burst 1 (2026-06-30)

**Setup (two separate invocations)**:

Call A (ambiguous type — exit 64):
1. Wiremock mounts `GET /rest/api/3/issueLinkType` returning three link types whose names all contain `"block"` as a substring: `{"issueLinkTypes": [{"id": "10001", "name": "Blocks"}, {"id": "10002", "name": "is blocked by"}, {"id": "10003", "name": "Blocker"}]}`.
2. Wiremock mounts `POST /rest/api/3/issueLink` with `.expect(0)` — must NOT be called.

Call B (default type selection — `"Relates"`):
1. Wiremock mounts `GET /rest/api/3/issueLinkType` returning two link types: `{"issueLinkTypes": [{"id": "10000", "name": "Relates"}, {"id": "10001", "name": "Blocks"}]}`.
2. Wiremock captures `POST /rest/api/3/issueLink` returning 201 (no body required; 201 is the documented success code for link creation).

**Note on "Relates" as jr's default selection**: "Relates" is `jr`'s hardcoded DEFAULT_LINK_TYPE selection when `--type` is absent (BC-3.6.001: `"default type 'Relates'"`). It is NOT asserted as a guarantee from the Jira REST API. The fixture provides the link-type list including `"Relates"`, and `jr` selects it by name. An instance that has renamed or removed "Relates" is not in scope for this holdout.

**Action A**: `jr issue link FOO-1 FOO-2 --type block --no-input`

**Action B**: `jr issue link FOO-1 FOO-2 --no-input`

**Expected A (MUST-PASS)**:
- Exit code = 64.
- stderr contains the substring `"Ambiguous link type"` (BC-3.6.002 postcondition).
- `POST /rest/api/3/issueLink` is NOT called (`.expect(0)` satisfied).

**Expected B (MUST-PASS)**:
- Exit code = 0.
- `POST /rest/api/3/issueLink` is called exactly once.
- The captured POST body contains `"type": {"name": "Relates"}` (jr selects the "Relates" link type from the fixture-supplied list as its default).
- The body also contains the two issue keys in `inwardIssue` and `outwardIssue` (order depends on the link type direction; either key in either position is acceptable for "Relates" which is symmetric).

**Why hidden**: The ambiguous-type short-circuit (Action A) is invisible from a test that only checks for success. Three similarly-named link types containing "block" are required to make the ambiguity genuine — a single match would produce an exact resolution and not trigger exit 64. The zero-POST assertion is the only observable evidence that the guard fires before any mutation. The default-"Relates"-selection behavior (Action B) is a `jr` client contract that is invisible from exit codes — a regression changing the default to a different link type or removing the default would require the user to always supply `--type`, silently breaking existing scripts.

**Status**: MUST-PASS. Pins BC-3.6.002 (ambiguous type → exit 64 + `"Ambiguous link type"` + ZERO POST) and BC-3.6.001 (no `--type` → POST fires once with `jr`'s default `"Relates"` selection).

**BC refs**: BC-3.6.002 (primary, ambiguous exit), BC-3.6.001 (default selection)

---

### H-NEW-QUEUE-VIEW-001: `queue view <name>` reorders `/search` response to queue-supplied key order (BC-X.8.009 step 4); single-substring match → Ambiguous exit 64 (MUST-PASS)

**NFR source**: BC-X.8.009 (issue-fetch-pipeline step 4, partial-match Ambiguous path)
**BC**: BC-X.8.009
**Authored by**: F2 holdout authoring Burst 1 (2026-06-30)

**Setup (two separate invocations)**:

**Note on project resolution flow**: `require_service_desk` → `get_or_fetch_project_meta` (verified from `src/api/jsm/servicedesks.rs` lines 41-99) on cache miss FIRST calls `GET /rest/api/3/project/{key}` and reads `projectTypeKey` and `id`, THEN calls `list_service_desks()` and matches by `d.project_id == project_id` (the project `id` string, NOT by project key). The `ServiceDesk` struct (`src/types/jsm/servicedesk.rs`) requires non-Option `id`, `projectId`, `projectName` with no `#[serde(default)]`; the `projectKey` field does NOT exist in `ServiceDesk` — passing it causes a deserialization mismatch (extra field ignored, but required fields absent → deserialization failure). All `ServiceDeskPage<T>` fixtures require `size`, `start`, `limit`, `isLastPage` (all non-Option, no `#[serde(default)]` on `size`/`start`/`limit`) per `src/api/pagination.rs`.

Call A (reorder-to-queue-position):
1. Wiremock mounts `GET /rest/api/3/project/EJ` returning `{"id": "10050", "projectTypeKey": "service_desk", "simplified": false}` — provides the `id` value that `list_service_desks()` will match against.
2. Wiremock mounts `GET /rest/servicedeskapi/servicedesk` returning a `ServiceDeskPage<ServiceDesk>` body: `{"size": 1, "start": 0, "limit": 50, "isLastPage": true, "values": [{"id": "5", "projectId": "10050", "projectName": "EJ Service Desk"}]}`. `projectId` MUST equal the `id` from step 1 for the match to succeed. No `projectKey` field (not in `ServiceDesk` struct).
3. Wiremock mounts `GET /rest/servicedeskapi/servicedesk/5/queue` returning a `ServiceDeskPage<Queue>` body: `{"size": 2, "start": 0, "limit": 50, "isLastPage": true, "values": [{"id": "10", "name": "Triage"}, {"id": "20", "name": "Escalations"}]}`.
4. Wiremock mounts `GET /rest/servicedeskapi/servicedesk/5/queue/10/issue` returning the queue keys in queue order as a `ServiceDeskPage<QueueIssueKey>` body: `{"size": 3, "start": 0, "limit": 50, "isLastPage": true, "values": [{"key": "EJ-2"}, {"key": "EJ-1"}, {"key": "EJ-3"}]}` — queue order is EJ-2 first, EJ-1 second, EJ-3 third. `QueueIssueKey` only needs `key` (`src/types/jsm/queue.rs`); no `issueId` needed.
5. Wiremock mounts `POST /rest/api/3/search/jql` returning issues in a DIFFERENT (alphabetical) order as a `CursorPage<Issue>` body. `IssueFields.summary` is a non-Option `String` with no `#[serde(default)]` (verified from `src/types/jira/issue.rs` line 58: `pub summary: String`), so an object without a `fields` key fails deserialization. All other `IssueFields` are `Option<T>`, so `{"summary":"x"}` is the minimal valid fields object. Concrete fixture:
   `{"issues": [{"key": "EJ-1", "fields": {"summary": "x"}}, {"key": "EJ-2", "fields": {"summary": "x"}}, {"key": "EJ-3", "fields": {"summary": "x"}}]}` — no `nextPageToken` key (single/last page). This returns alphabetical order [EJ-1, EJ-2, EJ-3]; the binary reorders to queue order [EJ-2, EJ-1, EJ-3].

Call B (single-substring Ambiguous — exit 64):
1. Wiremock mounts `GET /rest/api/3/project/EJ` returning the same project fixture as Call A step 1.
2. Wiremock mounts `GET /rest/servicedeskapi/servicedesk` returning the same servicedesk-list fixture as Call A step 2.
3. Wiremock mounts `GET /rest/servicedeskapi/servicedesk/5/queue` returning the same queue-list fixture as Call A step 3.
4. Wiremock mounts `GET /rest/servicedeskapi/servicedesk/5/queue/10/issue` with `.expect(0)` — must NOT be called.
5. Wiremock mounts `GET /rest/servicedeskapi/servicedesk/5/queue/20/issue` with `.expect(0)` — must NOT be called.
6. Wiremock mounts `POST /rest/api/3/search/jql` with `.expect(0)` — must NOT be called.

**Note on the reorder-to-queue-position assertion**: The load-bearing behavior being pinned is `jr`'s `reorder_by_queue_position` step (BC-X.8.009 issue-fetch-pipeline step 4): `jr` fetches issue keys from the queue endpoint (in queue order), then batch-fetches full issue detail via `/search` (which returns issues in a potentially different order), then reorders the batch-fetched results to match the original queue key ordering. This is a `jr` client contract, not an assertion about JSM's internal ordering guarantee. The fixture deliberately supplies the search response in a different order than the queue order to make the reorder step observable.

**Action A**: `jr --project EJ queue view Triage --output json --no-input`

**Action B**: `jr --project EJ queue view esca --no-input`

**Expected A (MUST-PASS)**:
- Exit code = 0.
- stdout parses as valid JSON array.
- The JSON array has exactly 3 elements.
- The `"key"` fields of the 3 elements, in order, are `["EJ-2", "EJ-1", "EJ-3"]` — matching the queue position order, NOT the search response order (`["EJ-1", "EJ-2", "EJ-3"]`). This is the primary regression target.

**Expected B (MUST-PASS)**:
- Exit code = 64.
- stderr contains the input substring `"esca"` AND a message indicating it matches multiple queues (per BC-X.8.009: `MatchResult::Ambiguous` → `"<name>" matches multiple queues: "<m1>", "<m2>". Be more specific or use --id."`).
- Neither queue-issues GET mock is called (both `.expect(0)` satisfied).
- Search mock is NOT called (`.expect(0)` satisfied).

**Note on single-substring → Ambiguous**: Per BC-X.10.001 and BC-X.8.009, a lone substring hit (e.g., `"esca"` matching `"Escalations"`) returns `MatchResult::Ambiguous` — NOT `MatchResult::Exact`. The strict-matching invariant requires the full exact name (case-insensitive) for an `Exact` result. A single candidate that is a substring match still triggers Ambiguous (it could match multiple entries if another were named "Escaping" — the `partial_match` function treats any substring-only match as ambiguous). However, with only two queues in the fixture (Triage, Escalations), `"esca"` matches only Escalations — verifying the Ambiguous-on-single-substring-hit behavior even with a single match.

**Why hidden**: The reorder-to-queue-position step (Action A) is invisible from exit codes — a regression that returns issues in search order (alphabetical) rather than queue position order would produce silently wrong output. Only asserting on the JSON key ordering reveals the regression. The distinct search vs queue orderings in the fixture make the reorder observable: if `jr` returns `["EJ-1", "EJ-2", "EJ-3"]` (search order), the reorder is broken. The Ambiguous path (Action B) pins that the zero-follow-on-HTTP property holds for partial-match resolution in queue view, consistent with BC-X.10.001 EC-1.

**Status**: MUST-PASS. Pins BC-X.8.009 issue-fetch-pipeline step 4 (`reorder_by_queue_position` produces queue-position order, not search-response order) and partial-match Ambiguous path (single-substring → exit 64 before queue-issues fetch).

**BC refs**: BC-X.8.009 (primary; issue-fetch-pipeline step 4, partial-match Ambiguous outcomes)

---

## Group 14: Label Routing Fork, Dry-Run PlannedChanges Shape, and Board View Dispatch (H-NEW-LABEL-FORK-001, H-NEW-DRY-RUN-001, H-NEW-BOARD-VIEW-001)

### H-NEW-LABEL-FORK-001: `issue edit --label` single-key uses PUT bare-string; two-key uses bulk POST `{"name":...}` object-form — payloads must NOT be unified (BUG-LABEL-400, MUST-PASS)

**NFR source**: BC-3.4.020 (EC-3.4.020-1, EC-3.4.020-3)
**BC**: BC-3.4.020
**Authored by**: F2 holdout authoring Burst 2 (2026-06-30)

**Setup (two separate invocations)**:

**Note on label payload asymmetry**: `handle_edit_bulk_labels` routes on key count. ONE key → `PUT /rest/api/3/issue/{key}` via `update_issue_labels` with `{"update":{"labels":[{"add":"name"},...]}}` — bare-string `add` field. TWO+ keys → `POST /rest/api/3/bulk/issues/fields` via `build_labels_edited_fields` with `{"name":"name"}` object entries. The two payload shapes are load-bearing and asymmetric by Atlassian API design — do NOT unify (BUG-LABEL-400).

Call A (single-key → PUT bare-string path):
1. Wiremock at `JR_BASE_URL`. Config with a valid profile (Bearer or Basic via `JR_AUTH_HEADER`).
2. Wiremock mounts `PUT /rest/api/3/issue/FOO-1` returning 204 (no body required). The request body MUST equal `{"update":{"labels":[{"add":"bug"}]}}` — bare string in the `"add"` field, NOT `{"name":"bug"}` object form.
3. Wiremock mounts `POST /rest/api/3/bulk/issues/fields` with `.expect(0)` — must NOT be called.

Call B (two-key → bulk POST object-form path):
1. Wiremock at `JR_BASE_URL`. Config with a valid profile.
2. Wiremock mounts `PUT /rest/api/3/issue/FOO-1` with `.expect(0)` — must NOT be called.
3. Wiremock mounts `PUT /rest/api/3/issue/FOO-2` with `.expect(0)` — must NOT be called.
4. Wiremock captures `POST /rest/api/3/bulk/issues/fields` returning `{"taskId": "task-label-001"}`. The request body MUST contain `editedFieldsInput.labelsFields[0].labels[0]` equal to `{"name": "bug"}` — an object with `"name"` key, NOT bare string `"bug"`.
5. Wiremock mounts `GET /rest/api/3/bulk/queue/task-label-001` returning `{"status": "COMPLETE", "processedAccessibleIssues": ["FOO-1", "FOO-2"]}`. String issue-key elements are accepted by `deserialize_string_or_int_array` (`src/types/jira/bulk.rs` line 345); no integer-ID coercion needed in test fixtures.

**Action A**: `jr issue edit FOO-1 --label add:bug --no-input`

**Action B**: `jr issue edit FOO-1 FOO-2 --label add:bug --no-input`

**Expected A (MUST-PASS)**:
- Exit code = 0.
- `PUT /rest/api/3/issue/FOO-1` was called exactly once with body `{"update":{"labels":[{"add":"bug"}]}}` — bare string `"bug"` in the `"add"` field.
- `POST /rest/api/3/bulk/issues/fields` was NOT called (`.expect(0)` satisfied).

**Expected B (MUST-PASS)**:
- Exit code = 0.
- `POST /rest/api/3/bulk/issues/fields` was called exactly once with request body containing `editedFieldsInput.labelsFields[0].labels[0]` equal to `{"name": "bug"}` — object form with `"name"` key.
- `PUT /rest/api/3/issue/FOO-1` was NOT called (`.expect(0)` satisfied).
- `PUT /rest/api/3/issue/FOO-2` was NOT called (`.expect(0)` satisfied).

**Why hidden**: The routing fork (PUT bare-string vs bulk POST object-form) is invisible from exit codes. A regression unifying the two payload shapes (e.g., sending `{"name":"bug"}` on the single-key path) would fail at the real Jira API with HTTP 400, but a wiremock that accepts any body would return 204 and mask the regression. Only asserting the exact request body reveals which path was taken. The MUST-NOT-be-called assertions for the bulk POST (Call A) and the individual PUTs (Call B) confirm the routing decision fired correctly. The distinction matters because the Atlassian `/issue/{key}` and `/bulk/issues/fields` endpoints interpret labels in different formats — this is an API contract difference, not a jr choice (BUG-LABEL-400).

**Status**: MUST-PASS. Pins BC-3.4.020 label-routing fork: single-key `--label` uses `PUT /rest/api/3/issue/{key}` with `{"update":{"labels":[{"add":"name"}]}}` (bare string); two+ keys use `POST /rest/api/3/bulk/issues/fields` with `{"name":"name"}` object form in `editedFieldsInput.labelsFields`. These payload shapes are asymmetric and load-bearing — do NOT unify.

**BC refs**: BC-3.4.020 (primary; label routing fork, EC-3.4.020-1 single-key path, EC-3.4.020-3 multi-key path)

---

### H-NEW-DRY-RUN-001: `issue edit --dry-run --output json` plannedChanges uses bare strings (not id-wrapped); `--no-parent` emits JSON null (key present), not absent key (MUST-PASS)

**NFR source**: BC-3.4.021 (EC-3.4.021-1 summary, EC-3.4.021-14 priority, EC-3.4.021-4 --no-parent null)
**BC**: BC-3.4.021
**Authored by**: F2 holdout authoring Burst 2 (2026-06-30)

**Setup (two separate invocations)**:

**Note on dry-run HTTP guard**: `--dry-run` in `edit.rs` fires a `if dry_run { ... return Ok(()); }` block BEFORE any HTTP call. No `PUT`, no bulk `POST`, no `GET editmeta` — zero network I/O. Both invocations mount all mutation endpoints with `.expect(0)` to confirm this invariant.

Call A (summary + priority — bare-string plannedChanges):
1. Wiremock at `JR_BASE_URL`. Config with a valid profile.
2. Wiremock mounts `PUT /rest/api/3/issue/FOO-1` with `.expect(0)` — must NOT be called.
3. Wiremock mounts `POST /rest/api/3/bulk/issues/fields` with `.expect(0)` — must NOT be called.

Call B (--no-parent — null parent in plannedChanges):
1. Wiremock at `JR_BASE_URL`. Config with a valid profile.
2. Wiremock mounts `PUT /rest/api/3/issue/FOO-1` with `.expect(0)` — must NOT be called.
3. Wiremock mounts `POST /rest/api/3/bulk/issues/fields` with `.expect(0)` — must NOT be called.

**Action A**: `jr issue edit FOO-1 --summary "Fixed bug" --priority High --dry-run --output json`

**Action B**: `jr issue edit FOO-1 --no-parent --dry-run --output json`

**Expected A (MUST-PASS)**:
- Exit code = 0.
- No HTTP calls made (all `.expect(0)` mocks satisfied — zero mutations).
- stdout is valid JSON.
- `dryRun` field equals `true`.
- `issues` field equals `["FOO-1"]`.
- `plannedChanges.summary` equals `"Fixed bug"` — a bare string, NOT a Jira update shape such as `{"set": "Fixed bug"}`.
- `plannedChanges.priority` equals `"High"` — a bare string, NOT an id-wrapped object such as `{"id": "..."}` or `{"name": "High"}`.
- No key other than `"summary"` and `"priority"` appears in `plannedChanges` (only those two flags were supplied).

**Expected B (MUST-PASS)**:
- Exit code = 0.
- No HTTP calls made (all `.expect(0)` mocks satisfied).
- stdout is valid JSON.
- `dryRun` field equals `true`.
- `issues` field equals `["FOO-1"]`.
- `plannedChanges` contains the key `"parent"` with value `null` (JSON `null`) — the key IS present with a null value. `null` is NOT the same as an absent key; a downstream tool diffing the plannedChanges MUST see `"parent": null` to know the parent was explicitly removed.

**Why hidden**: The intentionally simplified plannedChanges payload is invisible from exit codes. A regression wrapping values in Jira API update shapes (e.g., `{"set": "Fixed bug"}` for summary, `{"id": "..."}` for priority) would still exit 0 and produce valid JSON, but would break downstream consumers that parse the dry-run preview and expect simplified human-readable values. The `--no-parent` null-presence assertion (Call B) distinguishes `--no-parent` (key present, value null) from "no parent flag given" (key absent) — this distinction is load-bearing for idempotent diff tools. The zero-HTTP assertion across both calls confirms the dry-run guard is truly pre-mutation, not merely suppressing final writes.

**Status**: MUST-PASS. Pins BC-3.4.021: (1) `--dry-run` emits NO HTTP calls (guard fires before all I/O); (2) `plannedChanges.summary` and `plannedChanges.priority` are bare strings, not id-wrapped objects; (3) `--no-parent` produces `"parent": null` (key present, value null), not absent key.

**BC refs**: BC-3.4.021 (primary; dry-run plannedChanges bare-string shapes, EC-3.4.021-1 summary, EC-3.4.021-14 priority bare string, EC-3.4.021-4 --no-parent null emission)

---

### H-NEW-BOARD-VIEW-001: `board view` routes scrum boards to sprint endpoint (not JQL); kanban boards to JQL search (not sprint endpoint); truncation hint format differs by board type (MUST-PASS)

**NFR source**: BC-5.1.005 (EC-5.1.005-2 scrum dispatch+truncation, EC-5.1.005-4 kanban dispatch+count, EC-5.1.005-8/-9/-10 config-first/wire)
**BC**: BC-5.1.005
**Authored by**: F2 holdout authoring Burst 2 (2026-06-30)

**Setup (two separate invocations)**:

**Note on BoardConfig deserialization**: `BoardConfig` (`src/types/jira/board.rs`) deserializes the board type from JSON field `"type"` (NOT `"boardType"`): `#[serde(rename = "type", default)] pub board_type: String`. Fixtures must use `"type"` as the JSON key or deserialization silently falls back to the default empty string. Sprint list uses `OffsetPage<Sprint>` with `"values"` key (NOT `"issues"`). Sprint issues use `OffsetPage<Issue>` with `"issues"` key (NOT `"values"`). The sprint issue fetch always sends `maxResults=50` on the wire regardless of `--limit`; `--limit` is enforced client-side via early-stop in `get_sprint_issues`.

Call A (scrum board 1 — sprint endpoint path, JQL must not fire):
1. Wiremock at `JR_BASE_URL`. Config with a valid profile.
2. Wiremock mounts `GET /rest/agile/1.0/board/1/configuration` returning `{"id": 1, "name": "Test Board", "type": "scrum"}`. The `"type"` field (lowercase `"scrum"`) is the routing discriminator.
3. Wiremock mounts `GET /rest/agile/1.0/board/1/sprint` (any query params) returning an `OffsetPage<Sprint>` body with one active sprint: `{"startAt": 0, "maxResults": 50, "total": 1, "isLast": true, "values": [{"id": 10, "state": "active", "name": "Sprint 1"}]}`.
4. Wiremock mounts `GET /rest/agile/1.0/sprint/10/issue` (any query params) returning an `OffsetPage<Issue>` body with 3 issues and `total=100` (signals more exist): `{"startAt": 0, "maxResults": 50, "total": 100, "issues": [{"key": "FOO-1", "fields": {"summary": "Task 1"}}, {"key": "FOO-2", "fields": {"summary": "Task 2"}}, {"key": "FOO-3", "fields": {"summary": "Task 3"}}]}`. Client early-stops at `limit=2`, collecting FOO-1 and FOO-2 only.
5. Wiremock mounts `POST /rest/api/3/search/jql` with `.expect(0)` — JQL search must NOT be called on the scrum path.
6. Wiremock mounts `POST /rest/api/3/search/approximate-count` with `.expect(0)` — approximate count must NOT be called on the scrum path.

Call B (kanban board 2 — JQL search path, sprint endpoint must not fire):
1. Wiremock at `JR_BASE_URL`. Config with a valid profile.
2. Wiremock mounts `GET /rest/agile/1.0/board/2/configuration` returning `{"id": 2, "name": "Kanban Board", "type": "kanban"}`. The `"type"` field `"kanban"` triggers the kanban path.
3. Wiremock mounts `GET /rest/agile/1.0/board/2/sprint` with `.expect(0)` — sprint endpoint must NOT be called on the kanban path.
4. Wiremock mounts `POST /rest/api/3/search/jql` returning a `CursorPage<Issue>` body with 2 issues and a `nextPageToken` (signals more pages exist): `{"issues": [{"key": "FOO-11", "fields": {"summary": "Kanban Task 1"}}, {"key": "FOO-12", "fields": {"summary": "Kanban Task 2"}}], "nextPageToken": "tok-next-page"}`. The presence of `nextPageToken` sets `has_more=true`, triggering the approximate-count call.
5. Wiremock mounts `POST /rest/api/3/search/approximate-count` returning `{"count": 87}`.

**Action A**: `jr --project FOO board view --board 1 --limit 2 --no-input`

**Action B**: `jr --project FOO board view --board 2 --limit 2 --no-input`

**Expected A (MUST-PASS)**:
- Exit code = 0.
- `GET /rest/agile/1.0/board/1/configuration` was called exactly once.
- `GET /rest/agile/1.0/sprint/10/issue` was called exactly once (using sprint id 10 from the sprint list response).
- `POST /rest/api/3/search/jql` was NOT called (`.expect(0)` satisfied) — scrum path never uses JQL search.
- `POST /rest/api/3/search/approximate-count` was NOT called (`.expect(0)` satisfied).
- stderr contains `"Showing 2 results. Use --limit or --all to see more."` — NO tilde (`~`); scrum truncation format reports count only, not an approximate total.

**Expected B (MUST-PASS)**:
- Exit code = 0.
- `GET /rest/agile/1.0/board/2/configuration` was called exactly once.
- `POST /rest/api/3/search/jql` was called exactly once.
- `POST /rest/api/3/search/approximate-count` was called exactly once (triggered by `has_more=true` from `nextPageToken`).
- `GET /rest/agile/1.0/board/2/sprint` was NOT called (`.expect(0)` satisfied) — kanban path never calls the sprint endpoint.
- stderr contains `"Showing 2 of ~87 results. Use --limit or --all to see more."` — WITH tilde and approximate total from the count response.

**Why hidden**: The routing fork (sprint endpoint vs JQL search) is invisible from exit codes — both paths produce an issue table and exit 0. A regression routing all board types through JQL search would silently bypass active sprint selection for scrum boards; a regression routing kanban through sprint endpoints would fail with "no active sprint" rather than returning backlog issues. The MUST-NOT-be-called `.expect(0)` assertions for JQL (Call A) and sprint (Call B) are the only observable evidence that correct dispatch occurred. The truncation hint format difference (`"Showing N results."` for scrum vs `"Showing N of ~M results."` for kanban) is also invisible from exit codes but is a load-bearing user contract: the `~` prefix signals an approximate total derived from a separate `approximate-count` API call, while its absence on the scrum hint confirms no such call was made.

**Status**: MUST-PASS. Pins BC-5.1.005: (1) scrum boards route exclusively to `GET .../board/{id}/sprint` + `GET .../sprint/{id}/issue`, never JQL search; (2) kanban boards route exclusively to `POST .../search/jql` + `POST .../search/approximate-count`, never the sprint endpoint; (3) scrum truncation hint is `"Showing N results."` (no `~`); (4) kanban truncation hint is `"Showing N of ~M results."` with approximate total.

**BC refs**: BC-5.1.005 (primary; EC-5.1.005-2 scrum dispatch+truncation, EC-5.1.005-4 kanban dispatch+count, EC-5.1.005-8 config-first/board-type-resolve, EC-5.1.005-9 wire URL forms, EC-5.1.005-10 sprint wire maxResults=50)
