# Demo Evidence — S-575-1 (`--fields <CSV>` on `jr issue list` / `jr issue view`)

**Worktree:** `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-575-1`
**Feature branch / HEAD SHA:** `feat/issue-fields-projection` @ `69a76cdf`
**Story:** `.factory/stories/S-575-1-fields-csv-list-view.md` (BC-2.2.033, BC-2.3.041,
BC-2.6.052; 12 ACs)

## Recording method

All recordings are VHS terminal captures of the real `jr` binary built from this
worktree (`cargo build` -> `target/debug/jr`, prepended onto `PATH` inside each tape
so the demo never falls back to a stale globally-installed `jr`).

**No live Jira was contacted.** Every demo points `JR_BASE_URL` at a purpose-built,
local, stateless dummy HTTP server (`mock_jira.py`, loopback-only, `127.0.0.1:9977`,
Python stdlib `http.server` only — no external deps) serving hand-crafted fixture
data with a dummy project/issue key (`DEMO-101`/`DEMO-102`) and a dummy `Basic`
auth header (`Basic ZGVtbzpkZW1v`, base64 of a placeholder, not a real credential).
`JR_CONFIG_DIR` also points at a scratch directory with a dummy `[profiles.default]`
config, so no real `~/.config/jr` state is read or written. No real Jira keys, org
IDs, instance URLs, or credentials appear anywhere in these recordings, their source
`.tape` files, or the mock server script.

The mock server is not a static fixture returner: it parses the **actual outgoing
request** from `jr` (the `fields` array in the `POST /rest/api/3/search/jql` body
for `issue list`, and the `fields` query parameter on `GET /rest/api/3/issue/{key}`
for `issue view`) and returns only the requested field keys populated. This means
every recording demonstrates real, request-driven REPLACE/null behavior — not a
canned response that merely *looks* like the feature working.

`mock_jira.py` is scratchpad-only (not committed to the product repo or the
factory-artifacts branch), matching the S-608-1 precedent for local dummy mocks.

## Artifacts

All paths below are under `/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-575-1/`.

| File (base name) | Format(s) | ACs covered |
|---|---|---|
| `AC-001-007-list-fields-replace-key-present` | `.tape` `.gif` `.webm` | AC-001, AC-007 |
| `AC-002-003-012-view-fields-replace-null-placeholders` | `.tape` `.gif` `.webm` | AC-002, AC-003 (partial), AC-012 |
| `AC-003-omitted-summary-null-EC7-fix` | `.tape` `.gif` `.webm` | AC-003 (EC-2.2.033-7 regression fix) |
| `AC-004-table-mode-rejection-list-and-view` | `.tape` `.gif` `.webm` | AC-004 |
| `AC-005-011-empty-malformed-csv-rejection` | `.tape` `.gif` `.webm` | AC-005, AC-011 |
| `evidence-report.md` | this file | — |

5 `.tape` scripts, 5 `.gif`, 5 `.webm` — 10 rendered recordings total.

## AC-by-AC coverage

| AC | Trace | Coverage | Detail |
|---|---|---|---|
| AC-001 | BC-2.2.033 Postcondition 1 (REPLACE, not UNION) | **Demo** | `AC-001-007-list-fields-replace-key-present` — `jr issue list --jql 'project = DEMO' --fields summary,status,comment --output json`; mock echoes back exactly the 3 requested fields (`summary`, `status`, `comment`) populated, everything else in `IssueFields` absent from the wire response and rendered `null` by the typed struct |
| AC-002 | BC-2.3.041 Postcondition 1 (REPLACE, view) | **Demo** | `AC-002-003-012-view-fields-replace-null-placeholders` — `jr issue view DEMO-102 --fields summary,comment --output json`; GET `fields=summary,comment` query param drives the same request-filtered mock response |
| AC-003 | BC-2.2.033 Postcondition 2 (typed null / extra flatten) | **Demo** (both recordings) | View recording shows named fields not requested (`description`, `status`, `priority`, `assignee`, …) as JSON `null`, and the unnamed `comment` field flowing through `IssueFields.extra` verbatim; `AC-003-omitted-summary-null-EC7-fix` isolates the specific regression this story's Adversary-Pass-5 fix (`2981294c fix(issue): make IssueFields.summary Option<String>`) addresses — omitting `summary` from `--fields` used to be a hard deserialization failure, now correctly serializes `summary: null` |
| AC-004 | BC-2.2.033 Precondition 2 / EC-2.2.033-3, BC-2.3.041 EC-2.3.041-2 (table-mode rejection) | **Demo** | `AC-004-table-mode-rejection-list-and-view` — `--fields summary` (no `--output json`) on both `issue list` and `issue view` → exit 64, stderr `--fields requires --output json.`, zero HTTP calls (nothing reaches the mock) |
| AC-005 | BC-2.2.033 EC-2.2.033-4/EC-2.2.033-5 (empty/malformed CSV) | **Demo** | `AC-005-011-empty-malformed-csv-rejection` — `--fields ''` and `--fields 'summary,,status'` on `issue list` → exit 64 pre-HTTP, `--fields must be a comma-separated list of non-empty field names.` |
| AC-006 | BC-2.2.033 EC-2.2.033-6 (`--points` silent no-op) | **Test-only** | Not independently visible in a JSON diff without inspecting the raw request body (the demos above already show request-vs-response for the base REPLACE case); see `tests/all_flag_behavior.rs::issue_list_fields_points_flag_becomes_silent_noop` (`~L695`) |
| AC-007 | BC-2.2.033 Postcondition 3 (`key` always present) | **Demo** | `AC-001-007-list-fields-replace-key-present` — `"key": "DEMO-101"` present at the top of the output even though `key` never appears in the `--fields` CSV |
| AC-008 | BC-2.2.033 EC-2.2.033-2 (CSV whitespace trimming) | **Test-only** | Trimmed vs. untrimmed CSV produce byte-identical output — no distinct visual to record; see `tests/issue_commands.rs::test_bc_2_2_033_issue_list_fields_csv_segments_are_trimmed` (`~L11023`) |
| AC-009 | BC-2.6.052 Postcondition 1 (10 existing call sites unaffected) | **Test-only** (per story: "no new test — verified via full regression suite") | `cargo test` full suite green on this worktree (see Test Suite Verification below) |
| AC-010 | BC-2.6.052 Postcondition 2 / EC-2.6.052-1 (thin verbatim pass-through) | **Test-only** | Client-layer wire-format assertion, not a CLI-observable behavior; see `tests/issue_commands.rs::test_bc_2_6_052_field_override_methods_send_verbatim_field_list` (`~L11096`) and `test_bc_2_6_052_field_override_methods_empty_slice_is_not_a_client_error` (`~L11163`) |
| AC-011 | BC-2.3.041 EC-2.3.041-3 (empty CSV, view) | **Demo** | `AC-005-011-empty-malformed-csv-rejection` — `jr issue view DEMO-102 --fields '' --output json` → exit 64 pre-HTTP, same guard independently enforced on the view path |
| AC-012 | BC-2.3.041 Postcondition 3 (`key` always present, view) | **Demo** | `AC-002-003-012-view-fields-replace-null-placeholders` — `"key": "DEMO-102"` present despite `key` not appearing in the `--fields` CSV |

**8 of 12 ACs have a recorded VHS demo; 4 (AC-006, AC-008, AC-009, AC-010) are
covered by cited automated tests** because they assert request-body wire shape,
byte-identical output, or full-regression-suite invariants rather than a distinct
observable CLI output — recording a demo for any of them would either require
inspecting a raw HTTP request body inline (not something the CLI itself surfaces)
or would just re-show the same JSON shape already captured elsewhere. This mirrors
the accepted S-608-1 precedent for test-only citation of non-visually-distinct ACs.

## Test suite verification (AC-009)

Ran the full test suite on the worktree to confirm the 10 existing
`get_issue`/`search_issues` call sites outside `list.rs`/`view.rs` are unaffected:

```
cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-575-1
cargo test
```

All tests passed, including the 12 new `--fields`-specific tests across
`tests/issue_commands.rs`, `tests/all_flag_behavior.rs`, `tests/issue_list_errors.rs`,
`tests/issue_view_errors.rs`, and `tests/cli_smoke.rs`, plus the full pre-existing
regression suite (no changes required to any test outside the S-575-1 additions).

## Mock server fixture reference

`mock_jira.py` (scratchpad-only, not committed) served:

- `POST /rest/api/3/search/jql` → parses the request body's `fields` array and
  returns one dummy issue (`DEMO-101`) with only those keys populated from a
  canned per-field value map (`summary`, `status`, `comment`, `assignee`,
  `priority`, `issuetype`, `project`); unnamed/custom fields not in the map
  render as `demo-value-for-<name>` placeholders.
- `GET /rest/api/3/issue/{key}` → parses the `fields` query parameter and applies
  the same request-filtered response logic for a single dummy issue
  (`DEMO-102`), preserving the caller-supplied key.

No field in any fixture resembles a real Jira Cloud project, issue, or account.

## Path taken

**Live recording** (VHS against a local mock server), not the test-citation
fallback — recording proved fully feasible in this environment. The 4 test-only
ACs above are cited alongside the demos per the accepted DOCUMENT-AS-IS precedent
for internal/wire-level invariants that have no distinct CLI-observable shape.
