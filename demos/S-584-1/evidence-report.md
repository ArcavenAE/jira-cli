# Demo Evidence — S-584-1 (Preserve raw ADF for `--fields comment`)

**Worktree:** `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-584-1`
**Feature branch / HEAD SHA:** `feat/issue-comment-raw-adf` @ `c3a5114e`
**Story:** `.factory/stories/S-584-1-raw-adf-comment-fields.md` (BC-2.2.034, BC-2.3.042;
5 ACs; `list-read-ergonomics` bundle, third of three Wave-2 stories after S-575-1)

## Story shape — CONFIRMATORY, not implementation-heavy

Unlike most stories in this bundle, S-584-1 adds **zero `src/` logic**. The raw-ADF
passthrough behavior demonstrated below already exists via `IssueFields.extra`'s
`#[serde(flatten)]` catch-all — S-575-1's `--fields` REPLACE-semantics mechanism.
`comment` is not a named field on `IssueFields`, so requesting it via `--fields`
routes Jira's wire response through `extra` untouched: no `adf_to_text` call, no
transformation of any kind. The only file changes on this branch are defensive code
comments at the `--fields` wiring sites in `list.rs`/`view.rs` (AC-005, warning future
maintainers not to "helpfully" post-process `extra` for consistency with `issue
comments`'s flattened rendering) plus the new confirmatory/negative-regression test
suite in `tests/issue_commands.rs`. These recordings exist to make that guarantee
*visible*, not to prove a new code path works.

## Recording method

All recordings are VHS terminal captures of the real `jr` binary built from this
worktree (`cargo build` → `target/debug/jr`, prepended onto `PATH` inside each tape
so the demo never falls back to a stale globally-installed `jr`).

**No live Jira was contacted.** Every demo points `JR_BASE_URL` at a purpose-built,
local, stateless dummy HTTP server (`mock_jira_s584.py`, loopback-only,
`127.0.0.1:9584`, Python stdlib `http.server` only — no external deps) serving
hand-crafted fixture data with dummy project/issue keys (`PROJ-584`/`PROJ-585`) and
a dummy `Basic` auth header (`Basic ZGVtbzpkZW1v`, base64 of a placeholder, not a
real credential). `JR_CONFIG_DIR` also points at a scratch directory, so no real
`~/.config/jr` state is read or written. **No real Jira keys, org IDs, instance
URLs, or credentials appear anywhere in these recordings, their source `.tape`
files, or the mock server script.**

The mock server serves the exact SAME non-trivial ADF fixture used by the S-584-1
wiremock tests in `tests/issue_commands.rs::s584_1_fixture_comment_adf()` — a
paragraph containing a `strong`-marked text run ("STRONGWORD"), followed by a
two-item bullet list ("AlphaItem" / "BetaItem") — across all three of its endpoints
(`POST /rest/api/3/search/jql`, `GET /rest/api/3/issue/PROJ-584`,
`GET /rest/api/3/issue/PROJ-584/comment`), so every recording below demonstrates the
raw-ADF-vs-flattened contrast against **identical underlying content**, matching the
story's own design intent ("so the raw-ADF deep-equality assertions … and the
flattened-plain-text assertion … are checking the SAME underlying content through
the two independent code paths").

`mock_jira_s584.py` is scratchpad-only (not committed to the product repo or the
factory-artifacts branch), matching the S-575-1/S-608-1 precedent for local dummy
mocks.

## Artifacts

All paths below are under `/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-584-1/`.

| File (base name) | Format(s) | AC(s) covered |
|---|---|---|
| `AC-001-issue-list-fields-comment-raw-adf` | `.tape` `.gif` `.webm` | AC-001 |
| `AC-002-issue-view-fields-comment-raw-adf` | `.tape` `.gif` `.webm` | AC-002 |
| `AC-003-issue-comments-flattened-contrast` | `.tape` `.gif` `.webm` | AC-003 |
| `AC-004-view-table-mode-unaffected` | `.tape` `.gif` `.webm` | AC-004 |
| `evidence-report.md` | this file | — |

4 `.tape` scripts, 4 `.gif`, 4 `.webm` — 12 rendered/source files total.

## AC-by-AC coverage

| AC | Trace | Coverage | Detail |
|---|---|---|---|
| AC-001 | BC-2.2.034 Postcondition 1 (raw ADF, `issue list`) | **Demo** | `AC-001-issue-list-fields-comment-raw-adf` — `jr issue list --jql 'project = PROJ' --fields summary,comment --output json`; the mock echoes back the fixture issue with the non-trivial ADF comment body. First command shows the full JSON (`"type": "doc"`, `"version": 1`, `"content": [...]`, the `strong`-marked "STRONGWORD" text node, the two-item bullet list) — never a flattened string. A follow-up `jq` drill-down isolates `body.type` (`"doc"`) and the `strong`-marked text node object to make the raw-ADF shape unambiguous on camera. |
| AC-002 | BC-2.3.042 Postcondition 1 (raw ADF, `issue view`) | **Demo** | `AC-002-issue-view-fields-comment-raw-adf` — `jr issue view PROJ-584 --fields summary,comment --output json`; the `issue view` twin of AC-001, same fixture, same `jq` drill-down, confirming the identical guarantee holds via `GET /rest/api/3/issue/{key}?fields=...` as well as the search path. |
| AC-003 | BC-2.2.034 Postcondition 2 (`issue comments` unaffected — negative regression) | **Demo** | `AC-003-issue-comments-flattened-contrast` — `jr issue comments PROJ-584` run against the SAME `PROJ-584` fixture (identical ADF body) renders FLATTENED plain text via `adf::adf_to_text` (`Testing **STRONGWORD** marker.` / `- AlphaItem` / `- BetaItem` in a table), confirming the new `--fields comment` raw-ADF path (AC-001/AC-002) and this pre-existing flattening path remain fully independent. A follow-up `grep -c type` over the rendered output returns `0` (no raw ADF JSON leaking into `issue comments`'s output), reinforced by the fallback `no-raw-adf-json-in-issue-comments-output` echo. |
| AC-004 | BC-2.3.042 Edge Case EC-2.3.042-2 (view table-mode unaffected — error + control path) | **Demo** | `AC-004-view-table-mode-unaffected` — two-part recording. **Error path:** `jr issue view PROJ-584 --fields summary,comment` (no `--output json`) exits 64 pre-HTTP with `Error: --fields requires --output json.` — `--fields` is JSON-only (BC-2.3.041 Precondition 2), so the table-mode description-row `adf_to_text` call site is never reached in this combination. **Control path:** a plain `jr issue view PROJ-585` (no `--fields`, different fixture issue) confirms the table-mode description-row `adf_to_text` call site itself is still intact — the "PLAINDESC" description renders correctly in the table. |
| AC-005 | BC-2.2.034 Edge Case EC-2.2.034-3 (defensive comment obligation) | **Test-only / structural** | Per the story itself: "structural/code-review check (grep for the comment at the wiring site); no dedicated test function — verified via `git grep` in CI review, not `cargo test`." Not independently visible as a CLI-observable recording — the comment is source-level documentation, not runtime behavior. Verified present at commit `c3a5114e` ("docs: cite both BC-2.2.034 postconditions in defensive comments (S-584-1, ADV-P3-LOW-001)") in `src/cli/issue/list.rs` and `src/cli/issue/view.rs`. |

**4 of 5 ACs have a recorded VHS demo; AC-005 is a structural/code-review check with
no distinct CLI-observable output to record** — recording a demo for it would just
show a source-code diff, not runtime behavior. This mirrors the accepted S-575-1/
S-608-1 precedent for test-only citation of non-visually-distinct ACs.

## Test suite verification

Ran the S-584-1-specific confirmatory test suite on the worktree:

```
cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-584-1
cargo test --test issue_commands -- bc_2_2_034 bc_2_3_042
```

```
running 4 tests
test test_bc_2_2_034_issue_list_fields_comment_returns_raw_adf ... ok
test test_bc_2_2_034_issue_comments_command_unaffected_by_fields_comment_path ... ok
test test_bc_2_3_042_issue_view_fields_comment_returns_raw_adf ... ok
test test_bc_2_3_042_view_table_mode_description_render_unaffected ... ok

test result: ok. 4 passed; 0 failed; 0 ignored; 0 measured; 233 filtered out
```

All 4 tests (AC-001 through AC-004) pass GREEN — as the story itself predicts for a
purely confirmatory story with no fail-first Red Gate: "These 4 tests are expected
to pass GREEN immediately with zero `src/` changes … If any of these 4 tests were to
go RED, that would mean a real behavioral gap exists and the story is no longer
purely confirmatory."

## Mock server fixture reference

`mock_jira_s584.py` (scratchpad-only, not committed) served:

- `POST /rest/api/3/search/jql` → one dummy issue (`PROJ-584`) with `summary` +
  `comment.comments[0].body` populated from the shared fixture ADF.
- `GET /rest/api/3/issue/PROJ-584` → the same fixture issue, for the `issue view`
  and `issue comments` (comment sub-resource) demos.
- `GET /rest/api/3/issue/PROJ-584/comment` → the comments collection wrapping the
  same fixture ADF body, for `jr issue comments`.
- `GET /rest/api/3/issue/PROJ-585` → a second dummy issue (AC-004 control case only)
  with a `description` ADF ("PLAINDESC") and no `comment` field, confirming the
  table-mode description render is unaffected by this story.

The fixture ADF is byte-identical to `tests/issue_commands.rs::s584_1_fixture_comment_adf()`:
a paragraph with a `strong`-marked "STRONGWORD" text run, followed by a two-item
bullet list ("AlphaItem" / "BetaItem"). No field in any fixture resembles a real
Jira Cloud project, issue, or account.

## Path taken

**Live recording** (VHS against a local mock server), not the test-citation
fallback — recording proved fully feasible in this environment. AC-005 (the one
non-demoed AC) is cited alongside the demos per the accepted DOCUMENT-AS-IS
precedent for structural/source-level invariants that have no distinct
CLI-observable shape.
