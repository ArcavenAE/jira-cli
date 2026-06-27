# E2E Edge-Case Coverage Audit — Part 1: READ-path + Cross-cutting INFRA

- **Date:** 2026-06-27
- **Scope (this part):** read/query commands + cross-cutting infra edges. Write-path commands (create/edit/move/comment/worklog/link/assign/sprint add-remove) are deferred to Part 2.
- **Type:** STATIC coverage audit. No live suite run; no live mutations proposed. Gaps and proposals only.
- **Ground truth read:** `tests/e2e_live.rs` (9,735 LOC, ~40 live fns), `tests/e2e_cli_surface_guard.rs` (offline SURFACE table), `tests/rate_limit_cap_tests.rs`, `tests/search_issue_keys.rs`, `tests/user_pagination.rs`, `docs/specs/e2e-live-jira-testing.md`, `docs/specs/e2e-fork-safe-ci-enablement.md`, `.factory/STATE.md` (Drift Items), and `src/cli` / CLAUDE.md Gotchas.

> **KEY FRAMING:** The live E2E suite is, by spec design (`e2e-live-jira-testing.md §2 Non-Goals`), a *smoke-level happy-path* suite, not an exhaustive edge-case suite. Many infra edge cases are **unobservable** against a free Jira Cloud site (you cannot force a 429, you cannot force a scope-mismatch 401, you cannot force a repeated-`nextPageToken` drift). Those edges live — and ALREADY largely live — at the **wiremock-integration tier**. This audit therefore distinguishes "live-E2E gap" from "correctly-not-in-E2E (lives at wiremock/holdout)". A large fraction of the cross-cutting matrix is GREEN at the wiremock tier even though it is absent from `e2e_live.rs`.

---

## 1. Command enumeration (this slice)

Read/query commands in scope, with current live-E2E coverage status:

| # | Command | Live-E2E test fn | Status |
|---|---------|------------------|--------|
| R1 | `issue list` (`--jql`, `--output json`) | `test_e2e_issue_list_by_project_returns_array`, `test_e2e_issue_list_with_summary_filter_returns_array`, `test_e2e_issue_list_bad_jql_exits_nonzero`, `test_e2e_no_secret_in_output` | COVERED (happy + bad-JQL + secret-leak) |
| R2 | `issue view` (`--output json`) | `test_e2e_issue_view_returns_key_field`, `test_e2e_issue_view_404_exits_nonzero` | COVERED (happy + 404) |
| R3 | `issue changelog` | `test_e2e_issue_changelog_returns_object` | COVERED (object shape) |
| R4 | `issue comments` | `test_e2e_issue_comments_returns_array` | COVERED (array shape) |
| R5 | `issue transitions` | `test_e2e_issue_transitions_returns_array` | COVERED (array + `to.statusCategory.key`) |
| R6 | `issue link-types` | `test_e2e_issue_link_types_returns_array` | COVERED (array + `name`) |
| R7 | `board list` | `test_e2e_board_list_returns_array` | COVERED |
| R8 | `board view` (`--board`) | `test_e2e_board_view_returns_array` | COVERED (bare array; `--all` NOT exercised) |
| R9 | `sprint list` (`--board`) | `test_e2e_sprint_list_returns_array` | COVERED (scrum-skip path) |
| R10 | `sprint current` (`--board`) | `test_e2e_sprint_current_returns_json` | COVERED (object + no-active-sprint skip) |
| R11 | `user search` | `test_e2e_user_search_returns_array` | COVERED |
| R12 | `user list` (`--project`) | `test_e2e_user_list_assignable_returns_array` | COVERED |
| R13 | `user view` | `test_e2e_user_view_returns_object` | COVERED |
| R14 | `project list` | `test_e2e_project_list_returns_array` | COVERED |
| R15 | `project fields` (`--project`) | `test_e2e_project_fields_returns_object` | COVERED (5-key presence) |
| R16 | `queue list` (`--project`, JSM) | `test_e2e_jsm_queue_list_shape` | COVERED (JSM-gated) |
| R17 | `queue view` (`--project`, `--id`, JSM) | `test_e2e_jsm_queue_view` | COVERED (JSM-gated) |
| R18 | `requesttype list` (`--project`, JSM) | `test_e2e_jsm_requesttype_list_shape` | COVERED (JSM-gated) |
| R19 | `requesttype fields` (JSM) | `test_e2e_jsm_requesttype_fields` | COVERED (JSM-gated) |
| R20 | `worklog list` | `test_e2e_worklog_list_returns_array` | COVERED |
| R21 | `team list` | `test_e2e_team_list_returns_array_or_skips` | PARTIAL (harness-limited; clean-skips on "no URL configured") |
| R22 | `auth status` | — | NOT COVERED (deliberate; emits no JSON, no API call — spec §4 / NFR-O-N) |
| R23 | `auth list` | — | NOT COVERED |
| R24 | `assets search` (AQL) | — | NOT COVERED (deliberate; Assets is paid-plan-only — spec §2 Non-Goals) |
| R25 | `assets view` | — | NOT COVERED (Assets paid-plan; wiremock tier) |
| R26 | `assets tickets` | — | NOT COVERED (Assets paid-plan; wiremock tier) |
| R27 | `assets schemas` / `types` / `schema` | — | NOT COVERED (Assets paid-plan; wiremock tier) |

---

## 2. Edge-case dimension matrix

Cross-cutting dimensions (a)–(i) from the brief, assessed across read commands. Cell legend:
**LIVE** = covered in `e2e_live.rs`; **WM** = covered at wiremock tier (correct tier, NOT a live gap); **GAP** = uncovered at any tier; **N/A** = dimension not applicable; **DOC** = deliberately out-of-scope-documented.

| Command | (a) pagination | (b) 429/cap | (c) 401/scope | (d) JSON err shape | (e) ambiguous partial_match | (f) empty/zero | (g) `--no-input`/non-TTY | (h) truncation hint | (i) corrupt cache/config |
|---------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| issue list | LIVE (dedup) + WM | WM | WM | LIVE (bad-JQL) | GAP* | LIVE (empty array OK) | implicit | **GAP** | WM-partial |
| issue view | N/A | WM | WM | LIVE (404) | N/A | N/A | implicit | N/A | WM-partial |
| issue changelog | **GAP** | WM | WM | **GAP** | N/A | LIVE (entries:[] OK) | implicit | N/A | N/A |
| issue comments | **GAP** | WM | WM | **GAP** | N/A | **GAP** (empty list) | implicit | N/A | N/A |
| issue transitions | N/A | WM | WM | **GAP** | N/A | N/A | implicit | N/A | N/A |
| issue link-types | N/A | WM | WM | **GAP** | N/A | LIVE (empty OK) | implicit | N/A | N/A |
| board list | WM | WM | WM | **GAP** | N/A | LIVE (empty OK) | implicit | N/A | N/A |
| board view | **GAP** | WM | WM | **GAP** | GAP (`--board` name match) | LIVE (empty OK) | implicit | **GAP** (`--all`) | N/A |
| sprint list/current | WM | WM | WM | **GAP** | GAP (`--board` resolve) | LIVE (no-sprint skip) | implicit | **GAP** (sprint current trunc) | N/A |
| user search/list | WM (fixed-window) | WM | WM | **GAP** | N/A | LIVE (empty OK) | implicit | **GAP** | WM |
| user view | N/A | WM | WM | **GAP** | N/A | N/A | implicit | N/A | N/A |
| project list/fields | WM | WM | WM | **GAP** | N/A | LIVE (presence-only) | implicit | N/A | WM (cmdb_fields) |
| queue list/view (JSM) | **GAP** | WM | LIVE-partial (scope hint) | **GAP** | GAP (queue `--id` vs name) | LIVE (empty OK) | implicit | N/A | WM (request_types) |
| requesttype list/fields | **GAP** | WM | LIVE-partial | **GAP** | DOC (numeric-bypass edge) | LIVE (empty OK) | implicit | WM (rt caches) | WM |
| team list | WM | WM | WM | **GAP** | N/A | LIVE (No teams found) | implicit | N/A | WM (teams cache) |
| auth status/list | N/A | N/A | N/A | DOC (NFR-O-N: no JSON) | N/A | **GAP** | **GAP** | N/A | **GAP** (corrupt config) |
| assets * | WM | WM | WM (scope hint) | WM | WM (asset key/schema) | WM | implicit | WM | WM |

\* `issue list --status` is not a flag — status filtering goes through JQL or the `--open` flag, and partial-match disambiguation primarily lives on write paths (`issue move <status>`, `assign --to`, asset key/schema-type resolution). See dimension (e) discussion below.

### Reading the matrix
- **(b) 429/cap, (c) 401/scope:** uniformly **WM**, never LIVE. This is **correct and unavoidable**: you cannot force a 429 or a scope-mismatch 401 against a real Jira site without (i) hammering it (anti-social, flaky) or (ii) provisioning a deliberately scope-restricted token (out of scope for the free CI account). These edges are **UNOBSERVABLE in live E2E by construction** and rightly live at wiremock. Existing coverage: `tests/rate_limit_cap_tests.rs::ac_001_retry_after_exceeds_cap_aborts_retry` / `ac_002_retry_after_within_cap_retries` (MAX_RETRY_AFTER_SECS=60 cap), `tests/rate_limit_holdouts.rs`.
- **(a) pagination — JRACLOUD-95368 + fixed-window:** **WM-COVERED, do not re-create live.** `tests/search_issue_keys.rs` (10 fns incl. `test_search_issue_keys_repeated_cursor_aborts_with_warning`, `_dedupes`) and `tests/rate_limit_cap_tests.rs::ac_008_..._cursor_loop_terminates` cover the repeated-`nextPageToken` anti-loop + dedup. `tests/user_pagination.rs` (10 fns) covers JRACLOUD-71293 advance-by-page-size fixed-window. The single LIVE pagination test (`test_e2e_pagination_dedup`) is a *superset/no-duplicate smoke check* — it cannot force the drift condition, which is the whole point of the wiremock fixtures.
- **(d) JSON ERROR shape `{error, code}`:** This is the single largest LIVE gap pattern. `issue view` 404 and `issue list` bad-JQL assert exit-code + empty-stdout + non-empty-stderr, but per the JSON-render invariant (#526) and `docs/specs/json-output-shapes.md`, error JSON shape on the `--output json` path is asserted nowhere live for the read commands. NOTE: the 404/bad-JQL tests deliberately assert **stdout empty** on error (H-2), meaning `jr` does NOT emit a `{error, code}` envelope to stdout on these read-error paths — so the "JSON error envelope" assumption needs verification against actual behavior before proposing (see Gap G-1 caveat).

---

## 3. Prioritized gap list

### HIGH

- **G-H1 — JSON error-shape contract is unasserted across read commands (live + holdout).**
  The 404 (`test_e2e_issue_view_404_exits_nonzero`) and bad-JQL (`test_e2e_issue_list_bad_jql_exits_nonzero`) tests assert *stdout is empty* on error. This is a deliberate H-2 design choice but it is **only pinned for two commands**. The JSON-render invariant (#526) is a file-wide contract; whether each read command's `--output json` error path emits to stdout vs stderr, and whether `{error, code}` ever appears, is unverified for changelog/comments/transitions/link-types/board/sprint/user/project/queue/requesttype/team. Regression likelihood is HIGH because the invariant is enforced only by code review, not by per-command tests.
  - **Risk:** a refactor that routes one command's error through `serde_json::to_string_pretty` to stdout would violate #526 silently.

- **G-H2 — Ambiguous `partial_match` short-circuit BEFORE network is unobserved at any tier for read-path resolvers.**
  CLAUDE.md documents `partial_match` disambiguation (e.g. `requesttype fields <NAME|ID>` numeric-bypass, `board view --board <name>`, queue `--id` vs name). The invariant is that an ambiguous query exits 64 with a candidate list **before** any HTTP call. There is no live or wiremock test confirming the *no-HTTP-on-ambiguous* property for read commands. (Write-path `issue move <status>` ambiguity is partially exercised but is Part-2 scope.)
  - **Risk:** medium-high; a resolver regression that fires a network call on ambiguous input would only surface as a latency/cost change, not a failure.

### MEDIUM

- **G-M1 — `board view --all` truncation-bypass + the 30-column truncation hint to stderr is untested live.**
  CLAUDE.md: "board view truncation hint emits to stderr ... use --all to see everything". `test_e2e_board_view_returns_array` runs default (truncating) mode only; `--all` is not in the SURFACE table for board view and never exercised. The stderr-channel discipline (hint MUST be on stderr, MUST NOT pollute `--output json` stdout) is a documented output-channel invariant (profile 2 "Read-only").
  - **Risk:** medium — a regression dumping the hint to stdout would corrupt `jq` pipelines.

- **G-M2 — `issue comments` empty-list (zero comments) path is unasserted.**
  `test_e2e_issue_comments_returns_array` seeds a comment and asserts ≥1 element. The zero-comment shape (`[]` vs empty table, and the human-text "No comments" path) is not pinned. Same for `worklog list` empty (the test tolerates empty but does not assert the empty-render shape).

- **G-M3 — `auth status` / `auth list` non-TTY + corrupt-config resilience is untested.**
  `auth status` has no JSON path (NFR-O-N, deliberate) but its *non-fatal handling of a corrupt/missing config* and its non-TTY behavior are unasserted at any tier visible here. Corrupt-config non-fatal handling (dimension i) is a stated resilience property (config auto-migration in `config.rs`) but has no read-command test.

- **G-M4 — `issue changelog` / `transitions` / `link-types` / `queue` / `requesttype` JSON error path (e.g. 404 on a non-existent key/project) untested.**
  Only `issue view` and `issue list` have error-path coverage. A 404 on `issue changelog E2E-99999999` or a non-existent `--project` for `queue list` is observable live and cheap, and would extend the error-exit-code contract across more commands.

### LOW

- **G-L1 — `sprint current` truncation hint (stderr) untested.** Mirrors G-M1 for the sprint surface; lower frequency of use.
- **G-L2 — `requesttype fields "100"` numeric-bypass edge (named RT unreachable by name).** DOC'd as tracked behavior, not a bug. A holdout/wiremock characterization pin would prevent accidental "fix". Low risk; documented intentional.
- **G-L3 — `team list` harness limitation ("no URL configured" clean-skip).** Already DOC'd in the test rustdoc with a candidate src/ follow-up (fall back to `JR_BASE_URL` for hostname discovery). Tracked; restating as a known partial.
- **G-L4 — Assets read commands (search/view/tickets/schemas/types/schema) have zero live coverage.** Deliberate per spec §2 (paid-plan-only). Confirm wiremock coverage exists (`assets-*` specs present: `assets-schema-discovery.md`, `assets-search-attribute-names.md`, `assets-tickets-status-filter.md`, `assets-view-default-attributes.md`). NOT a live gap; flag only that wiremock-tier edge coverage (ambiguous asset key, empty AQL result, AQL syntax error) should be confirmed complete in Part-2 / a dedicated assets audit.

---

## 4. Overlaps with existing tracked drift items (de-duplicated)

| This audit's gap | Existing STATE.md item | Relationship |
|---|---|---|
| (none for remote-link — write path) | **E2E-PG-4** (remote-link round-back, LOW, OPEN) | Out of THIS slice (write path); noted to avoid double-count in Part 2. |
| G-L4 (assets read live gap) | spec §2 Non-Goals | Not a drift item — deliberate design. Do not file. |
| G-M3 (corrupt-config resilience) | `CACHE-COVERAGE-GAPS-2026-06-27` (D5 write-error / D2 warm-hit) | Adjacent but distinct: cache audit covers cache families; G-M3 is *config* corruption + auth-status non-TTY. New. |
| G-H2 (no-HTTP-on-ambiguous partial_match) | `CACHE-COVERAGE-GAPS-2026-06-27` notes "cache-hit-no-HTTP requires BC sub-clause" | Same *no-HTTP-assertion-needs-BC-anchor* class. G-H2 needs a partial_match BC sub-clause; likely no current BC asserts pre-network short-circuit. |
| (a)/(b)/(c) wiremock coverage | `rate_limit_*`, `search_issue_keys`, `user_pagination` test files | Already GREEN at wiremock — explicitly NOT new gaps. |

No new drift item duplicates an existing one. **G-H1, G-H2, G-M1, G-M2, G-M3, G-M4 are net-new.**

---

## 5. Proposals (tier-classified)

> Per the brief: each proposal is classified live-E2E / wiremock-integration / holdout, and UNOBSERVABLE-in-live edges are flagged.

### P1 → G-H1 — JSON error-shape contract (HIGH)
- **Tier: holdout + wiremock-integration.** PARTIALLY live-observable (a live 404 is observable) but the *exact channel + shape* assertion is better pinned deterministically.
- **Proposal:** (a) a wiremock-integration test per read command asserting that an injected 4xx produces exit ∈ {1,64}, empty stdout, non-empty stderr (extends the existing `issue view`/`issue list` live pattern to changelog/comments/transitions/link-types/board/sprint/user/project/queue/requesttype/team); (b) a holdout characterization scenario pinning the documented H-2 behavior ("error paths emit to stderr, NOT a JSON envelope on stdout").
- **BC anchor:** needs a BC asserting the read-command error-output channel. **Likely missing** — the JSON-render invariant (#526) is documented in CLAUDE.md but I did not confirm a BC formalizing "read-command `--output json` error path → stderr, empty stdout". A new BC sub-clause (e.g. under the BC-7.3.x error-handling family that `transitions`/bad-JQL already trace to) would be the anchor. **VERIFY before authoring the holdout.**
- **Caveat:** confirm actual behavior first — the 404/bad-JQL tests assert *empty stdout*, which contradicts a naive "`{error,code}` JSON envelope on stdout" assumption. The contract to pin is the *observed* one (stderr-only), not an assumed envelope.

### P2 → G-H2 — partial_match no-HTTP-on-ambiguous (HIGH)
- **Tier: wiremock-integration. UNOBSERVABLE in live E2E** — the whole assertion is "no HTTP request was made", which requires a wiremock server with a request counter / unmatched-request assertion. Live Jira cannot prove a negative (no call made).
- **Proposal:** wiremock test feeding an ambiguous query (e.g. `board view --board <prefix-matching-2>` or a contrived ambiguous resolver input) and asserting (i) exit 64, (ii) stderr lists candidates, (iii) the mock recorded **zero** requests to the resolution endpoint. Mirror for queue `--id`-vs-name and any read-path resolver using `partial_match`.
- **BC anchor:** needs a BC asserting "ambiguous partial_match short-circuits before network". **Likely missing.** Same prerequisite class flagged in `CACHE-COVERAGE-GAPS-2026-06-27` (no-HTTP assertions need a BC sub-clause). File a partial_match BC before holdout-izing; wiremock test can land first as a regression pin.

### P3 → G-M1 — board view `--all` + truncation-hint-to-stderr (MEDIUM)
- **Tier: live-E2E (additive) + holdout.** Observable live: run `board view --board <id>` (default) and assert any truncation hint is on **stderr** and absent from `--output json` stdout; run `board view --board <id> --all` and assert no truncation. Add `--all` to the board-view SURFACE row (`tests/e2e_cli_surface_guard.rs`) when the test lands.
- **BC anchor:** the output-channel "Read-only profile 2" discipline + the CLAUDE.md board-view-stderr gotcha. Check for an existing BC on board view truncation; if absent, a holdout can anchor to the output-channel NFR.

### P4 → G-M2 — empty-list render shapes (`issue comments` zero, `worklog list` zero) (MEDIUM)
- **Tier: live-E2E (additive).** Observable: seed an issue with no comments, run `issue comments <key> --output json`, assert `[]` (not error, not object). Same for a fresh issue's `worklog list`. Cheap, no extra mutation beyond the seed already used by the write-flow.
- **BC anchor:** none strictly required (shape pin). If holdout-ized, anchor to the relevant read-command BC (comments → AC-002 family; worklog → worklog list BC).

### P5 → G-M3 — auth status / auth list non-TTY + corrupt-config resilience (MEDIUM)
- **Tier: wiremock-integration / unit (NOT live).** `auth status` makes no API call (spec §4), so live E2E adds nothing. Corrupt-config non-fatal handling is best tested by writing a deliberately malformed `config.toml` into a temp `JR_CONFIG_DIR` and asserting graceful behavior (exit code + stderr hint, no panic). Non-TTY behavior is already implicitly `--no-input`-driven; assert `auth status` under a piped (non-TTY) stdin.
- **BC anchor:** config auto-migration / resilience BC (config.rs migration is documented; confirm a BC exists under the BC-6.2.x config family). **VERIFY.**

### P6 → G-M4 — extend error-exit-code contract to changelog/transitions/queue/requesttype (MEDIUM)
- **Tier: live-E2E (additive, cheap).** Observable: `issue changelog E2E-99999999 --output json` → exit ∈ {1,64}, empty stdout, non-empty stderr; `queue list --project NONEXISTENT --output json` likewise. Extends the proven 404 pattern. Overlaps P1's wiremock approach but is the *live* complement.
- **BC anchor:** same BC-7.3.x error family as the existing bad-JQL/404 tests trace to.

### P7 → G-L1/G-L2/G-L3/G-L4 (LOW)
- **G-L1 (sprint current trunc):** live-E2E additive, same pattern as P3. Low priority.
- **G-L2 (`requesttype fields "100"` numeric-bypass):** holdout/wiremock characterization pin of the documented intentional behavior (named RT unreachable by name). Anchor to the requesttype numeric-bypass gotcha; **flag as intentional** so it is a characterization pin, not a "bug to fix".
- **G-L3 (team list harness limit):** already DOC'd; the proposed src/ follow-up (team list `JR_BASE_URL` hostname fallback) would unblock a real live assertion. Track, don't duplicate.
- **G-L4 (assets read):** confirm wiremock-tier edge coverage (ambiguous asset key, empty AQL result `[]`, AQL syntax error → exit code) is complete; **explicitly NOT a live gap** (paid-plan, spec §2). Defer to a dedicated assets audit.

---

## 6. UNOBSERVABLE-in-live-E2E edges (must live at wiremock/holdout) — explicit flags

These cannot be exercised against a live free Jira site and must NOT be proposed as live tests:

1. **Forced 429 + Retry-After cap (MAX_RETRY_AFTER_SECS=60)** — wiremock. Already covered (`rate_limit_cap_tests.rs`).
2. **JRACLOUD-95368 repeated-`nextPageToken` drift + anti-loop + dedup** — wiremock. Already covered (`search_issue_keys.rs`, `rate_limit_cap_tests.rs::ac_008`).
3. **JRACLOUD-71293 user fixed-window advance-by-page-size** — wiremock. Already covered (`user_pagination.rs`).
4. **Scope-mismatch 401 / InsufficientScope hint** — wiremock (provisioning a scope-restricted token in CI is out of scope). **GAP at wiremock tier — VERIFY:** confirm a wiremock test injects a 401 with the JSM `write:servicedesk-request` / OAuth scope hint and asserts the hint text. If absent, this is a wiremock gap worth filing.
5. **Blanket-401 auto-refresh trigger (S-3.03, gh-CLI pattern)** — wiremock/unit (OAuth refresh coordinator). Out of live scope (spec §2: OAuth not tested live).
6. **No-HTTP-on-ambiguous partial_match (G-H2)** — wiremock (proving a negative). UNOBSERVABLE live.
7. **No-HTTP-on-cache-warm-hit (dimension i adjacent)** — wiremock. Tracked in `CACHE-COVERAGE-GAPS-2026-06-27`.
8. **Corrupt-cache / corrupt-config non-fatal handling** — wiremock/unit + temp dir injection (`JR_CACHE_DIR` / `JR_CONFIG_DIR` debug seams). Partial coverage at cache tier; config-corruption GAP (P5).

---

## 7. Summary of findings

- **Read-path happy-path live coverage is strong** — 21 of 27 read commands have a live happy-path test; the 6 uncovered (auth status/list, assets ×4) are **deliberately out-of-scope per spec** (no JSON / paid-plan), not defects.
- **Cross-cutting infra edges (pagination drift, 429 cap, fixed-window) are GREEN at the wiremock tier** and correctly absent from `e2e_live.rs`. Do not re-create them live.
- **Net-new gaps:** G-H1 (JSON error-shape contract, HIGH), G-H2 (no-HTTP-on-ambiguous partial_match, HIGH), plus 4 MEDIUM and 4 LOW. The two HIGH gaps both need a **BC anchor that likely does not yet exist** (read-command error-channel BC; partial_match pre-network BC) — flagged for verification before holdout authoring.
- **Top recommendation:** verify the missing BC anchors for P1/P2, land the cheap live-additive error-path extensions (P6), and confirm the wiremock scope-mismatch-401 hint test exists (item 6.4) — that is the one cross-cutting infra edge that may be a genuine *wiremock-tier* gap rather than already-covered.

**Report path:** `/Users/zious/Documents/GITHUB/jira-cli/.factory/research/e2e-edge-case-audit-2026-06-27-read.md`
