---
document_type: maintenance-finding
scope: doc-drift
date: 2026-06-17
commit: 53f6d98
branch: develop
severity_summary: {HIGH: 4, MED: 4, LOW: 4}
---

# Documentation Drift — Scan 2026-06-17

Surfaces checked: `CLAUDE.md`, `README.md`, `docs/adr/`, `docs/specs/` (spot-check), module-level rustdoc presence. Read-only scan; no code or documentation was modified.

---

## FINDINGS

### HIGH

---

**DRIFT-D1** — CLAUDE.md Architecture tree: `cli/auth.rs` describes a flat file that no longer exists

- **Location:** `CLAUDE.md` Architecture tree, line `│   ├── auth.rs …`
- **Stale claim:** The tree lists `cli/auth.rs` as a single file with description "auth login/switch/list/status/refresh/logout/remove. Multi-profile aware via --profile."
- **Reality:** `src/cli/auth.rs` does not exist. The auth subsystem was split into a module directory: `src/cli/auth/{mod.rs, keychain.rs, list.rs, login.rs, logout.rs, refresh.rs, remove.rs, status.rs, switch.rs, tests/}`.
- **Fix type:** Manual — update the architecture tree to show `auth/` as a module directory listing its shards.

---

**DRIFT-D2** — CLAUDE.md Architecture tree: `cli/assets.rs` describes a flat file that no longer exists; Gotcha uses stale citation

- **Location:** `CLAUDE.md` Architecture tree line `│   ├── assets.rs …`; Gotcha entry "cli/assets.rs::filter_tickets".
- **Stale claim:** The tree lists `cli/assets.rs` as a single file. The Gotcha cites `cli/assets.rs::filter_tickets`.
- **Reality:** `src/cli/assets.rs` does not exist. The assets CLI module is now a directory: `src/cli/assets/{mod.rs, search.rs, view.rs, tickets.rs, schemas.rs}`. `filter_tickets` lives at `cli/assets/tickets.rs::filter_tickets` (scoped `pub(super)`).
- **Fix type:** Manual — update tree to `assets/` module directory; update Gotcha citation to `cli/assets/tickets.rs::filter_tickets`.

---

**DRIFT-D3** — CLAUDE.md Architecture tree: twelve src/ files exist with no tree entry

The following production files have been added since the architecture tree was written and appear nowhere in the tree or Known Size Deviations section. They represent substantial functionality (1,500+ LOC across API and CLI layers):

| File | LOC | Description gap |
|---|---|---|
| `src/api/jira/bulk.rs` | 881 | Bulk issue operations (transition, field edit, label edit) |
| `src/api/jira/resolutions.rs` | 55 | Resolution list endpoint |
| `src/api/refresh_coordinator.rs` | 165 | Per-profile single-flight OAuth refresh (mentioned in Gotchas but absent from tree) |
| `src/api/jsm/request_types.rs` | 75 | JSM request-type discovery |
| `src/api/jsm/requests.rs` | 337 | JSM request creation (`handle_jsm_create` path) |
| `src/cli/api.rs` | 355 | API passthrough command (`jr api`) |
| `src/cli/issue/changelog.rs` | 847 | Issue changelog handler (`jr issue changelog`) |
| `src/cli/issue/field_resolve.rs` | 877 | Field resolution helpers for `issue edit --field` |
| `src/cli/issue/json_output.rs` | 182 | JSON output helpers for issue commands |
| `src/types/jira/bulk.rs` | 746 | Serde structs for bulk operations |
| `src/types/jira/changelog.rs` | 126 | Serde structs for changelog API |
| `src/types/jira/editmeta.rs` | 73 | Serde structs for editmeta |

Additionally the JSM module tree (`api/jsm/`) only lists `servicedesks.rs` and `queues.rs` but `request_types.rs` and `requests.rs` are also present.

- **Fix type:** Manual — add missing entries to Architecture tree; expand JSM subsection.

---

**DRIFT-D4** — CLAUDE.md OQ-5 / NFR-O-N: "auth status --output json covers single-profile JSON" — NOT implemented

- **Location:** `CLAUDE.md` Conventions section: "`auth status --output json` covers single-profile JSON; multi-profile listing has no JSON path (NFR-O-N: deferred…)."
- **Stale claim:** Implies `jr auth status --output json` produces JSON for a single profile.
- **Reality:** `src/cli/auth/status.rs::status()` takes `profile_arg: Option<&str>` only; no `OutputFormat` parameter, no JSON output path, `main.rs::AuthCommand::Status` dispatch passes only `effective_profile.as_deref()`. The function always writes human text to stdout (`println!`). There is zero JSON code path in the status handler. Both the single-profile JSON claim and the "multi-profile deferred" framing are inaccurate — neither is implemented.
- **Severity note:** This is OQ-5 from STATE.md, already tracked as open. Documenting here for completeness and accurate severity assessment; the misleading "single-profile JSON is implemented" framing is the HIGH-severity element.
- **Fix type:** Manual — correct CLAUDE.md to state that `auth status` has no `--output json` support at all (both single-profile and multi-profile are unimplemented); retain the NFR-O-N deferred status label.

---

### MED

---

**DRIFT-D5** — CLAUDE.md Architecture tree: `cli/issue/list.rs` description is stale post-split

- **Location:** `CLAUDE.md` Architecture tree line `│   │   ├── list.rs  # list + view + comments (read operations, unified JQL composition)`
- **Stale claim:** The description says list.rs contains "list + view + comments." The `view` and `comments` handlers were already extracted to separate files (as noted in Known Size Deviations).
- **Reality:** `list.rs` now contains only `handle_list` (1 public function, 1,256 LOC). `handle_view` is in `view.rs`; comment formatting is in `comments.rs`.
- **Known Size Deviation note:** The LOC count in Known Size Deviations (`1,083`) is also stale — actual count is 1,256.
- **Fix type:** Manual — update description to "list only (JQL composition, filter application)" and update the LOC in Known Size Deviations from 1,083 to 1,256.

---

**DRIFT-D6** — README.md Exit Codes table missing code 124 (DeadlineExceeded)

- **Location:** `README.md` § Exit Codes table.
- **Stale claim:** Table lists codes 0, 1, 2, 64, 78, 130. CLAUDE.md Architecture tree lists `error.rs` as defining "exit codes (0/1/2/64/78/124/130)".
- **Reality:** `src/error.rs::JrError::DeadlineExceeded` maps to exit code 124 (POSIX `timeout(1)` convention, added in fix(bulk) for issue #333). It is present in CLAUDE.md's architecture tree description of `error.rs` but absent from README.md's user-facing Exit Codes table.
- **Fix type:** Automated-possible — add `| 124 | Timeout / deadline exceeded |` row to README table.

---

**DRIFT-D7** — README.md missing `jr api` (API passthrough) and `jr issue changelog` commands

- **Location:** `README.md` § Commands table.
- **Stale claim:** The Commands table has no entries for `jr api` or `jr issue changelog`.
- **Reality:** Both commands are fully implemented and dispatched in `main.rs`. `cli::Command::Api` at `src/cli/api.rs` (355 LOC) is the API passthrough. `IssueCommand::Changelog` at `src/cli/issue/changelog.rs` (847 LOC) shows issue audit history. Neither has a README entry.
- **Fix type:** Manual — add rows to the Commands table.

---

**DRIFT-D8** — README.md `--verbose` description implies body output; SD-003 changed this

- **Location:** `README.md` § Global Flags table: `| --verbose | Show HTTP request/response details |`
- **Stale claim:** "request/response details" implies both request and response bodies are shown.
- **Reality:** Per SD-003 (breaking change, v0.6), `--verbose` shows method + URL only; request bodies are suppressed with a hint ("use --verbose-bodies to inspect, will print PII"); response bodies also suppressed. A separate `--verbose-bodies` flag exists for body inspection but is not documented in the README Global Flags table at all.
- **Fix type:** Manual — update `--verbose` description to "Show HTTP method + URL (headers only)"; add `--verbose-bodies` row noting it adds PII-containing body inspection.

---

### LOW

---

**DRIFT-D9** — docs/adr/ missing ADR-0014 (JSM request creation dispatch fork)

- **Location:** `docs/adr/` directory; `CLAUDE.md` Gotcha "Detail: ADR-0014"; `docs/adr/0015-proactive-resolution-enforcement.md` "See Also: ADR-0014"; `docs/specs/jsm-e2e-coverage.md:903` "ADR-0014: JSM create dispatch fork: `docs/adr/0014-jsm-request-creation.md`".
- **Stale claim:** Multiple files reference ADR-0014 as if it exists.
- **Reality:** `docs/adr/0014-jsm-request-creation.md` does not exist. ADR numbers jump from 0006 to 0015.
- **Fix type:** Manual — either create the missing ADR-0014 file, or annotate the references with "(ADR not yet written)" to prevent reader confusion.

---

**DRIFT-D10** — .factory/specs/prd/README.md Document Map grand total is stale (known open item PG-A)

- **Location:** `.factory/specs/prd/README.md` § Document Map, line `**Total BCs in PRD:** 573 …` and the BC-INDEX.md table entry `573`.
- **Stale claim:** The Document Map claims 573 BCs and various per-file counts.
- **Reality:** `BC-INDEX.md` frontmatter `total_bcs: 598` (canonical count). The Document Map row for bc-3 shows 93 but the actual count is higher; bc-7 shows 84; cross-cutting shows 140. This is the known open process gap PG-A / DRIFT-README already tracked in STATE.md.
- **Severity:** LOW (no runtime, no CI, advisory doc only; already tracked; `check-bc-cumulative-counts.sh` does not guard this surface).
- **Fix type:** Manual — update README.md Document Map table rows and "Total BCs in PRD" prose to match canonical 598.

---

**DRIFT-D11** — CLAUDE.md `--verbose` Gotcha says "method + URL + status" but code only logs method + URL

- **Location:** `CLAUDE.md` Gotcha "`--verbose` is header-only (SD-003 breaking change): As of v0.6, `--verbose` shows method + URL + status only."
- **Stale claim:** "method + URL + status" implies response HTTP status is logged.
- **Reality:** `src/api/client.rs::collect_response_body` logs body suppression notice under `--verbose`, but there is no `eprintln!("[verbose] status: {}", ...)` or equivalent anywhere in the codebase. The response HTTP status code is not emitted in verbose output. Only request method + URL are logged.
- **Fix type:** Manual — remove "status" from the CLAUDE.md Gotcha description; change to "method + URL only."

---

**DRIFT-D12** — README.md missing `jr requesttype` commands

- **Location:** `README.md` § Commands table.
- **Stale claim:** The Commands table has no entry for `jr requesttype list` or `jr requesttype fields`.
- **Reality:** `src/cli/requesttype.rs` and `cli::Command::RequestType` are fully implemented and dispatched. `jr requesttype list` and `jr requesttype fields <NAME|ID>` are JSM request-type discovery commands with 7-day cache. Both are documented in CLAUDE.md Gotchas and AI Agent Notes but absent from the README Commands table.
- **Fix type:** Manual — add two rows to the README Commands table.

---

## SUMMARY

| Severity | Count | Items |
|---|---|---|
| HIGH | 4 | DRIFT-D1, D2, D3, D4 |
| MED | 4 | DRIFT-D5, D6, D7, D8 |
| LOW | 4 | DRIFT-D9, D10, D11, D12 |

**Top 5 by impact:**

1. **DRIFT-D3 (HIGH)** — Architecture tree missing 12 production source files totaling ~3,500 LOC across bulk ops, refresh coordinator, JSM requests, API passthrough, issue changelog, field resolution, and JSON output helpers. Any developer reading the architecture tree gets an incomplete map of the codebase.

2. **DRIFT-D4 (HIGH)** — OQ-5: CLAUDE.md's claim that `auth status --output json` is implemented for single-profile is false. The implementation has zero JSON output support for `auth status`. AI agents relying on this claim will misuse the command.

3. **DRIFT-D1 / DRIFT-D2 (HIGH, combined)** — Both `cli/auth.rs` and `cli/assets.rs` are listed as flat files in the architecture tree but have been split into module directories. The `filter_tickets` Gotcha citation is wrong. Any developer navigating by the tree gets the wrong file paths.

4. **DRIFT-D8 (MED)** — README `--verbose` description says "request/response details" which contradicts the SD-003 behavioral change (header-only). `--verbose-bodies` is completely undocumented in README. Operators and agents using the README as reference will have wrong expectations about what `--verbose` outputs.

5. **DRIFT-D7 (MED)** — `jr api` (API passthrough) and `jr issue changelog` are fully shipped commands absent from the README Commands table. Users have no discoverable path to these features from the README.
