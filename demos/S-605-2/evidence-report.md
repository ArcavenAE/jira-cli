# Demo Evidence — S-605-2 (`jr issue edit --component`, multi-key/`--jql` bulk path)

**Worktree:** `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-605-2`
**Feature branch:** `feat/issue-component-bulk-edit`
**Feature HEAD SHA:** `f0e823c622d72b66eff84684297e623c3b8477eb`
**Story:** `.factory/stories/S-605-2-issue-component-bulk-edit.md` (BC-3.4.023, AC-001–AC-010)

## Recording method

All recordings are VHS terminal captures of the real `jr` binary built from
this worktree (`target/debug/jr`, prepended onto `PATH` inside each tape so
the demo never falls back to a globally-installed `jr`).

**No live Jira was contacted.** Every demo points `JR_BASE_URL` at a
purpose-built, local, stateless dummy HTTP server
(`mock_jira_605_2.py`, loopback-only, `127.0.0.1:9999`, scratchpad-only —
not committed to the product repo or the factory-artifacts branch) serving
hand-crafted fixture data with dummy project keys (`FOO`, `BAR`), dummy
issue keys (`FOO-1`, `FOO-2`, `FOO-9`, `BAR-1`), and dummy component names
(`Backend`, `Frontend`, `Docs`). Auth is a dummy `Basic dGVzdDp0ZXN0` header
(base64 of `test:test`). No real Jira keys, org IDs, instance URLs, or
credentials appear anywhere in these recordings, their source `.tape`
files, or the mock server script.

The mock server also writes a terse `METHOD PATH` line per incoming
request to `/tmp/mock_jira_605_2_requests.log`; several tapes `grep`/`cat`/
`wc -l` that log after running a `jr` command to make the exact set of
HTTP calls (or absence thereof) part of the visible recording — this is
how AC-002's "two sequential POSTs", AC-004's "zero bulk POSTs", AC-005's
"zero HTTP calls", and AC-006's "single-key PUT, not bulk POST" claims are
made directly observable in-band, rather than asserted only in prose.

## Artifacts

All paths below are under
`/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-605-2/`.

| File (base name) | Format(s) | ACs covered |
|---|---|---|
| `AC-001-002-bulk-add-and-mixed-add-remove` | `.tape` `.gif` `.webm` | AC-001, AC-002 |
| `AC-004-unknown-component-zero-mutation` | `.tape` `.gif` `.webm` | AC-004 |
| `AC-005-cross-project-guard` | `.tape` `.gif` `.webm` | AC-005 |
| `AC-006-jql-single-match-single-key-path` | `.tape` `.gif` `.webm` | AC-006 |
| `AC-DRYRUN-multi-key-preview-zero-mutation` | `.tape` `.gif` `.webm` | `--dry-run` preview (traces to BC-3.4.023 Postcondition 4 / mirrors AC-010's zero-mutation intent, but is not itself a numbered AC — see coverage table) |
| `AC-JSON-output-operations-shape` | `.tape` `.gif` `.webm` | `--output json` `{"operations":[...]}` shape (Architecture Mapping / render invariant #526) |
| `evidence-report.md` | this file | — |

6 `.tape` scripts, 6 `.gif`, 6 `.webm` — 12 rendered recordings total.

## AC-by-AC coverage

| AC | Trace | Coverage | Detail |
|---|---|---|---|
| AC-001 | BC-3.4.023 Postcondition 1/2 (wire shape: single-object `multiselectComponents`, ADD) | **Demo** | `AC-001-002-bulk-add-and-mixed-add-remove` (first half) — `jr issue edit FOO-1 FOO-2 --component add:Backend` against the dummy mock; exit 0, both keys updated. The exact JSON wire-shape assertion (single object, not array; no `sendBulkNotification` key) is a body-content check not visible in a terminal recording — covered by `test_bc_3_4_023_issue_edit_bulk_component_add_wire_shape` in `tests/issue_commands.rs`. |
| AC-002 | BC-3.4.023 Postcondition 3 (TWO sequential POSTs for mixed add:/remove:) | **Demo** | `AC-001-002-bulk-add-and-mixed-add-remove` (second half) — `--component add:Backend --component remove:Docs` on the same 2 keys, followed by `grep 'POST /rest/api/3/bulk/issues/fields' /tmp/mock_jira_605_2_requests.log \| cat -n` showing exactly two logged POSTs to the bulk endpoint (never one coalesced POST). |
| AC-003 | BC-3.4.023 Invariant 2 (componentId is a JSON integer, explicit `String`→`u64` parse) | **Test-only** | A wire-body-content assertion (`components[].componentId` typed as JSON integer vs. string), not a visually distinct terminal output — see `test_bc_3_4_023_issue_edit_bulk_component_id_is_json_integer_not_string` in `tests/issue_commands.rs`. AC-001's demo exercises this code path end-to-end (the mock only accepts the POST because the id resolves and parses), but the type-level distinction itself isn't observable in a GIF. |
| AC-004 | BC-3.4.023 Postcondition 4 (unknown name → exit 64, zero bulk POST) | **Demo** | `AC-004-unknown-component-zero-mutation` — `--component add:NoSuchComponent` on `FOO-1 FOO-2` → `Error: Component 'NoSuchComponent' not found in project FOO. Available: Backend, Docs, Frontend.`, exit 64, then `grep -c 'POST /rest/api/3/bulk/issues/fields' …` prints `0`. |
| AC-005 | BC-3.4.023 Edge Case EC-3.4.023-1 (cross-project guard, exit 64 before any HTTP) | **Demo** | `AC-005-cross-project-guard` — `FOO-1 BAR-1 --component add:Backend` → exit 64 with the cross-project error message, then `wc -l` on the request log prints `0` (the guard is pure client-side string parsing on the issue-key prefixes — no HTTP call is even attempted). |
| AC-006 | BC-3.4.023 Edge Case EC-3.4.023-3 (single-`--jql`-match fallthrough to the single-key path) | **Demo** | `AC-006-jql-single-match-single-key-path` — `--jql "key = FOO-9" --component add:Backend` (mock resolves the JQL to exactly one issue, `FOO-9`) → exit 0, `components → add:Backend` echo (the single-key native-PUT echo format, not the bulk table format); the request log then shows `POST /rest/api/3/search/jql`, `GET .../project/FOO/components`, `GET /rest/api/3/issue/FOO-9/editmeta`, `PUT /rest/api/3/issue/FOO-9` — no `POST /bulk/issues/fields` at all. |
| AC-007 | BC-3.4.023 Postcondition 6 (1000-issue chunking, two sequential POSTs of 1000+500) | **Test-only** | A 1500-issue fan-out is a call-count/chunk-size assertion at a scale unsuited to a legible ~15s terminal recording — see `test_bc_3_4_023_issue_edit_bulk_component_1000_issue_chunking` in `tests/issue_commands.rs`. AC-001's demo shows the SAME single-chunk code path at N=2; the chunking boundary itself is not separately demoable without an unreadably long issue list on screen. |
| AC-008 | BC-3.4.023 Postcondition 6 (chunk-major/action-minor ordering with mixed ops, 4 POSTs) | **Test-only** | Same scale rationale as AC-007, plus mixed add:/remove: — see `test_bc_3_4_023_issue_edit_bulk_component_chunking_and_mixed_ops_four_posts` in `tests/issue_commands.rs`. AC-002's demo shows the 2-POST add:/remove: ordering at N=2 (no chunking); AC-007/AC-008 add the orthogonal 1000-issue-chunk dimension on top, which is a call-count property, not a new visual shape. |
| AC-009 | BC-3.4.023 Edge Case EC-3.4.023-4 (chunk-failure aborts remaining sequence, no rollback) | **Test-only** | Requires a fabricated chunk-2 `FAILED` poll response mid-sequence — a wiremock-only scenario (the local mock server always succeeds; teaching it to fail on the Nth call for one specific demo would add mock-server complexity disproportionate to the visual payoff, since the resulting terminal output is simply "same error surface as any other bulk failure," already implied by AC-004's error rendering). See `test_bc_3_4_023_issue_edit_bulk_component_chunk_failure_aborts_remaining` in `tests/issue_commands.rs`. |
| AC-010 | BC-3.4.023 Delivery note / DEC-280 (LIVE-JIRA smoke test, release gate) | **Release gate — explicitly out of scope for this evidence set** | Per this story's LIVE-JIRA GATE and DEC-280, AC-010 requires one real `add:` POST and one real `remove:` POST against ≥2 real issues in one real Jira Cloud project with ≥1 component already defined, gated behind `JR_RUN_E2E=1` (mirrors `tests/e2e_live.rs` conventions) — NOT part of `cargo test`, and NOT something this mock-based demo pass attempts or substitutes for. This MUST be run separately, with the human's explicit approval, against a real Jira instance before this path ships to release; a wire-shape mismatch there requires correcting BC-3.4.023 itself (per the `FIX-BULK-TRANSITION-001`/#446 precedent cited in the story), not silently patching around it. No recording exists for AC-010 and none should be manufactured to imply live verification occurred. |

**5 of 10 ACs have a recorded VHS demo** (AC-001, AC-002, AC-004, AC-005,
AC-006); **4 (AC-003, AC-007, AC-008, AC-009) are covered by cited
integration tests** because they assert internal wire-body-typing or
call-count/scale invariants rather than a distinct observable CLI output;
**1 (AC-010) is an explicit release-gate, out of scope by design.**
(5 + 4 + 1 = 10.)

Two additional recordings go beyond the numbered ACs, both requested
explicitly in the S-605-2 demo-recording task and directly relevant to
BC-3.4.023's Architecture Mapping / Postcondition 4:

- `AC-DRYRUN-multi-key-preview-zero-mutation` — `--dry-run` on a mixed
  add:/remove: multi-key edit: table-mode preview (`DRY RUN — no changes
  will be made.` / `Planned changes: components → add:Backend,
  remove:Docs`), followed by `grep -cE 'PUT |POST /rest/api/3/bulk' …`
  printing `0` — proving zero mutating requests reached the mock server.
- `AC-JSON-output-operations-shape` — `--output json` on the same AC-001
  scenario, rendering the exact `{"operations":[{"taskId":...,
  "action":"ADD","results":[{"key":"FOO-1","status":"success"},
  {"key":"FOO-2","status":"success"}]}]}` shape produced by
  `render_bulk_component_results`.

## Mock server fixture reference

`mock_jira_605_2.py` (scratchpad-only, not committed to the product repo
or the factory-artifacts branch; source retained in this session's
scratchpad directory for reproducibility) served:

- `GET /rest/api/3/project/FOO/components` → 3 dummy components:
  `Backend` (id `10001`), `Frontend` (id `10002`), `Docs` (id `10003`).
  Any other project key → empty list.
- `POST /rest/api/3/search/jql` → if the submitted `jql` string contains
  `FOO-9`, returns exactly one dummy issue (`FOO-9`); otherwise returns two
  (`FOO-1`, `FOO-2`).
- `GET /rest/api/3/issue/{key}/editmeta` → dummy `components` field
  metadata with `operations: ["add","remove"]` (selects the single-key
  path's native `update`-verb wire shape, per S-605-1/BC-3.4.022).
- `PUT /rest/api/3/issue/{key}` → `204` (single-key path's native PUT).
- `POST /rest/api/3/bulk/issues/fields` → `200` with a freshly-minted
  dummy `taskId` (`task-demo-NNN`), `status: "ENQUEUED"`; the server
  remembers which issue keys were submitted under that `taskId`.
- `GET /rest/api/3/bulk/queue/{taskId}` → `200`, `status: "COMPLETE"`,
  `processedAccessibleIssues` echoing back the keys recorded for that
  `taskId` at POST time (immediate single-poll completion — no
  ENQUEUED/RUNNING intermediate state needed for these demos, since none
  of the demoed ACs exercise the polling-loop retry path itself).

Every incoming request is additionally appended as a `METHOD PATH` line to
`/tmp/mock_jira_605_2_requests.log`, which several tapes inspect directly
(via `grep`/`cat`/`wc -l`) as part of the recorded terminal output — this
is what makes claims like "zero bulk POSTs" or "exactly two POSTs"
directly visible evidence rather than narrated assertions.

No field in any fixture resembles a real Jira Cloud project, component,
issue, or account.

## Placeholder-data verification

Before committing, all six `.tape` files and the mock server script were
grepped for real-looking identifiers (`atlassian.net` hostnames, email-like
strings, long numeric-suffixed keys) — none found. Every issue/project key
used across the recordings is one of the intentionally short, obviously
synthetic set: `FOO`, `FOO-1`, `FOO-2`, `FOO-9`, `BAR`, `BAR-1`. Every
`JR_BASE_URL` in every tape points at `http://127.0.0.1:9999` (loopback
only). Auth is the fixed dummy `Basic dGVzdDp0ZXN0` (base64 `test:test`)
header used across prior stories' demo evidence (e.g. S-608-1).
