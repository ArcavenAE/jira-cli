# Demo Evidence — S-608-1 (`jr component rename`)

**Worktree:** `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-608-1`
**Feature HEAD SHA:** `8f12f274`
**Story:** `.factory/stories/S-608-1-component-rename.md` (BC-8.3.001 – BC-8.3.007, 18 ACs)

## Recording method

All recordings are VHS terminal captures of the real `jr` binary built from this
worktree (`target/debug/jr`, prepended onto `PATH` inside each tape so the demo
never falls back to the stale globally-installed `jr` at `~/.local/bin/jr`,
which is v0.5.0-dev.10 and predates `component rename` entirely).

**No live Jira was contacted.** Every demo points `JR_BASE_URL` at a purpose-built,
local, stateless dummy HTTP server (`mock_jira.py`, loopback-only,
`127.0.0.1:9999`) serving hand-crafted fixture data with dummy project keys
(`DEMOA`/`DEMOB`/`DEMOC`/`DEMOD`) and dummy component names (`ExactBack`,
`SharedFail`, `CaseOnly`, `DupDemo`, ...). Auth is a dummy `Basic dGVzdDp0ZXN0`
header (base64 of `test:test`). No real Jira keys, org IDs, instance URLs, or
credentials appear anywhere in these recordings or their source `.tape` files.
Guard-only demos (scope-selection guards, numeric-`OLD` `--all-projects`
rejection) fire pre-flight with zero HTTP and would behave identically even if
the mock server were down — the mock server was up for all of them regardless,
for consistency across the batch.

The dummy mock server DOES accept mutating `PUT` requests (it is not real
Jira, so this carries none of the live-mutation risk the story's guardrails are
about) — this let several ACs that would otherwise need a live Jira instance
(single-project rename success, case-only rename, name collision, partial
fan-out failure, PUT-race 404) be demonstrated end-to-end against a safe local
double instead of falling back to test-only citation.

## Artifacts

All paths below are under `/Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-608-1/`.

| File (base name) | Format(s) | ACs covered |
|---|---|---|
| `AC-HELP-rename-cli-surface` | `.tape` `.gif` `.webm` | CLI surface (`--help`) |
| `AC-013-scope-selection-guards` | `.tape` `.gif` `.webm` | AC-013 |
| `AC-001-002-single-project-rename-success` | `.tape` `.gif` `.webm` | AC-001, AC-002 |
| `AC-003-004-numeric-old-project-mismatch-notfound` | `.tape` `.gif` `.webm` | AC-003, AC-004 |
| `AC-005-006-007-all-projects-discovery` | `.tape` `.gif` `.webm` | AC-005, AC-006, AC-007 |
| `AC-010-012-dry-run-all-projects-preview` | `.tape` `.gif` `.webm` | AC-010, AC-012 |
| `AC-014-015-case-only-rename-not-skipped` | `.tape` `.gif` `.webm` | AC-014, AC-015 |
| `AC-016-017-collision-and-put-race-404` | `.tape` `.gif` `.webm` | AC-016, AC-017 |
| `AC-008-009-partial-failure-no-rollback` | `.tape` `.gif` `.webm` | AC-008, AC-009 |
| `evidence-report.md` | this file | — |

9 `.tape` scripts, 9 `.gif`, 9 `.webm` — 18 rendered recordings total.

## AC-by-AC coverage

| AC | Trace | Coverage | Detail |
|---|---|---|---|
| AC-001 | BC-8.3.001 Postcondition 1 (single-project PUT body) | **Demo** | `AC-001-002-single-project-rename-success` — `rename ExactBack Renamed --project DEMOA` against the dummy mock, `--output json` |
| AC-002 | BC-8.3.001 Postcondition 2 (JSON success shape) | **Demo** | same recording — JSON `{"renamed":{"id":...,"from":"ExactBack","to":"Renamed","project":"DEMOA"}}` |
| AC-003 | BC-8.3.001 M1 (numeric project mismatch) | **Demo** | `AC-003-004-numeric-old-project-mismatch-notfound` — dummy component `10042` belongs to `DEMOB`; run with `--project DEMOA` → exit 64, `"Component 10042 belongs to project DEMOB, not DEMOA."` |
| AC-004 | BC-8.3.001 EC-8.3.001-2 (numeric not-found, project-qualified) | **Demo** | same recording — `rename 999999999 NewName --project DEMOA` → exit 64, project-qualified not-found message |
| AC-005 | BC-8.3.002 (exact-equality vs. substring) | **Demo** | `AC-005-006-007-all-projects-discovery` — dummy `DEMOA` has exact `"ExactBack"`, dummy `DEMOB` has superset `"ExactBackend"` (not equal) → `DEMOA` renames, `DEMOB` silently skipped |
| AC-006 | BC-8.3.002 EC-8.3.002-1 (zero matches) | **Demo** | same recording — `rename ZeroMatchXYZ Renamed --all-projects` → exit 0, "0 renamed" |
| AC-007 | BC-8.3.002 Precondition 2 (numeric OLD rejected, zero HTTP) | **Demo** | same recording — `rename 10042 Renamed --all-projects` → exit 64 pre-flight |
| AC-008 | BC-8.3.003 (per-project atomicity, no rollback) | **Demo** | `AC-008-009-partial-failure-no-rollback` — dummy `DEMOA`/`DEMOB` both have `"SharedFail"`; `DEMOA`'s PUT succeeds, `DEMOB`'s PUT is mocked to 400; `DEMOA`'s commit is not rolled back |
| AC-009 | BC-8.3.003 Postcondition 2 (exit code reflects any failure) | **Demo** | same recording — exit 1 on partial failure, JSON `failed: []` would be empty only on full success |
| AC-010 | BC-8.3.004 (dry-run JSON/table, zero mutation) | **Demo** | `AC-010-012-dry-run-all-projects-preview` — `--dry-run --all-projects`, `dryRun:true`/`targets`/`wouldFail` JSON shape + table `DRY RUN — no changes will be made.` header; zero `PUT`s (a mutating call to the dummy server would show up as a distinct failure mode, and none occurred) |
| AC-011 | BC-8.3.004 Invariant 1 (discovery-scope parity, dry-run vs. live) | **Test-only** | Internal parity invariant between two code paths, not a directly observable CLI output — see `tests/component_commands.rs::test_bc_8_3_004_component_rename_dry_run_discovery_scope_matches_live` (`~L7599`) |
| AC-012 | BC-8.3.004 EC-8.3.004-2 (numeric rejection precedes dry-run) | **Demo** | same recording as AC-010 — `rename 10042 Renamed --all-projects --dry-run` → exit 64 pre-flight, no preview emitted |
| AC-013 | BC-8.3.005 (clap conflict + app-level neither-guard) | **Demo** | `AC-013-scope-selection-guards` — three sub-cases: neither flag (exit 64, app guard), local `--project`+`--all-projects` (clap exit 2), global `--project`+local `--all-projects` (exit 64, app guard covering clap's blind spot) |
| AC-014 | BC-8.3.006 EC-8.3.006-1 (case-only, single-project) | **Demo** | `AC-014-015-case-only-rename-not-skipped` — `rename CaseOnly caseonly --project DEMOA` → PUT fires, exit 0 |
| AC-015 | BC-8.3.006 EC-8.3.006-2 (case-only, all-projects) | **Demo** | same recording — dummy `DEMOA`+`DEMOB` both have `"CaseOnly"` → both PUT, 2 total renames |
| AC-016 | BC-8.3.007 (collision surfaced verbatim) | **Demo** | `AC-016-017-collision-and-put-race-404` — dummy mock returns 400 for the target component's PUT → `ApiError(400,...)` surfaced verbatim, exit 1 |
| AC-017 | BC-8.3.001 Idempotency (PUT-race 404 distinct from resolver 404) | **Demo** | same recording — resolver's GET succeeds (component found in list), but the PUT is mocked to 404 → `ApiError(404)`, exit 1, distinct message/exit-code from AC-004's exit-64 resolver not-found |
| AC-018 | BC-8.3.002 Behavior (O(N) scale, no new rate-limit logic) | **Test-only** | A 20-project fan-out is a call-count assertion, not a visually distinct demo — see `tests/component_commands.rs::test_bc_8_3_002_component_rename_all_projects_scale_no_new_rate_limit_logic` (`~L8294`) |

**16 of 18 ACs have a recorded VHS demo; 2 (AC-011, AC-018) are covered by
cited integration tests** because they assert internal invariants (discovery-scope
parity, HTTP call counts at N=20) rather than a distinct observable CLI
output — recording a demo for either would just re-show the same JSON/table
shape already captured elsewhere without adding new visual evidence.

## Mock server fixture reference

`mock_jira.py` (scratchpad-only, not committed to the product repo or the
factory-artifacts branch) served:

- `GET /rest/api/3/project/search` → 4 dummy projects: `DEMOA`, `DEMOB`, `DEMOC`, `DEMOD`
- `GET /rest/api/3/project/{KEY}/components` → per-project dummy component lists (`ExactBack`, `ExactBackend`, `SharedFail`, `CaseOnly`, `Frontend`, `RaceComp`, `DupDemo`/`DUPDEMO`, ...)
- `GET /rest/api/3/component/10042` → dummy component belonging to `DEMOB` (numeric-OLD confirming-GET fixture)
- `GET /rest/api/3/component/999999999` → 404 (not-found fixture)
- `PUT /rest/api/3/component/{id}` → 200 echo by default; `id=20002` and `id=10005` mocked to 400 (name-collision fixtures); `id=10006` mocked to 404 (PUT-race fixture)

No field in any fixture resembles a real Jira Cloud project, component, or
account.
