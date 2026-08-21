# S-579-1 Demo Evidence

Story: `jr issue list --updated-recent <duration>` — filter issues by their
`updated` timestamp, mirroring the existing `--recent` filter on `created`
(GitHub issue #579, bundle `list-read-ergonomics`).

Branch: `feat/issue-updated-recent-filter`
Head: `b1d31d57`
Captured: 2026-08-21

Behavioral contracts: BC-2.1.023 (`--updated-recent` clause + validation),
BC-2.1.006 (AMENDED: filter-source enumeration 14 -> 15), BC-2.1.007
(AMENDED: stable clause order).

This is a read-only, pre-HTTP-validation-heavy CLI filter feature (no
state-changing/write path involved). The point of every recording below is
the **outgoing JQL clause** and the CLI's **exit-code/error-message
behavior**, not the (intentionally empty) mock search response.

## Recording method — REAL rendered output against a local mock, ADAPTED per policy

No live Jira credentials are used and no real Jira org, instance URL,
account ID, or issue key appears anywhere in these recordings — per standing
factory policy, this run never hits live Jira. A throwaway local mock Jira
HTTP server was stood up (`mock_server.py` — Python stdlib `http.server`,
~55 LOC, no external dependencies, source kept alongside this evidence set)
serving two fixed, fake-data endpoints:

- `GET /rest/api/3/project/DEMO` → a minimal fake `ProjectSummary` (key
  `DEMO`, name "Demo Project") so the CLI's pre-search project-existence
  check succeeds.
- `POST /rest/api/3/search/jql` → an empty result set (`{"issues": [],
  "nextPageToken": null}`). The response body is irrelevant to what these
  recordings demonstrate — what matters is the **request** body Jira would
  have received.

Every recording runs the **actual debug binary** (`./target/debug/jr`, built
from `b1d31d57`) via the documented, `#[cfg(debug_assertions)]`-gated test
seams (CLAUDE.md "AI Agent Notes" — inert in release builds; the same
mechanism `tests/issue_commands.rs`'s wiremock-based integration tests use):

- `JR_CONFIG_DIR` / `JR_CACHE_DIR` → scratch dirs, isolated from any real
  `~/.config/jr` / `~/.cache/jr`.
- `JR_BASE_URL=http://127.0.0.1:8935` → the local mock server above.
- `JR_AUTH_HEADER=Basic ZmFrZTpmYWtl` → dummy fake credential (base64 of
  `fake:fake`).

For the two HTTP-reaching scenarios (AC-001/008 and AC-004/005), the
commands additionally pass `--verbose --verbose-bodies` (documented,
non-default flag combination — CLAUDE.md "`--verbose` is header-only") so
the **real outgoing HTTP request body** — the composed JQL — is printed to
stderr as `[verbose] body: {"jql": "...", ...}` and captured directly in the
recording. `RUST_LOG=warn` is also set to suppress the `tracing`
crate's own DEBUG/TRACE transport-layer noise (connection pool, hyper
internals) that `--verbose-bodies` otherwise elevates to TRACE globally —
this does **not** affect the CLI's own `[verbose]` lines, which are plain
`eprintln!` calls gated directly on the CLI flags, not on the tracing level
(see `src/api/client.rs`).

The two zero-HTTP scenarios (AC-003, AC-006/007) fail before any network
call — clap's `conflicts_with` validation and the "no filters specified"
guard both fire pre-HTTP — so those two recordings do not talk to the mock
server at all, demonstrating the pre-HTTP-validation postcondition itself.

So: **this is real code executing (or correctly declining to execute) a
real HTTP round-trip and rendering real output** — not a canned screenshot —
against a local mock instead of a live Jira Cloud instance.

`mock_server.py` is kept alongside this evidence set for regeneration.

## Evidence

| AC | BC Anchor | Video | Command | Result |
|----|-----------|-------|---------|--------|
| AC-001, AC-008 | BC-2.1.023 postcondition 1 (clause composition, field-swap fidelity) | `AC-001-008-updated-recent-clause-composition.{gif,webm}` | `jr --no-input --verbose --verbose-bodies --output json issue list --project DEMO --updated-recent 60d` | Outgoing JQL body: `"jql":"project = \"DEMO\" AND updated >= -60d ORDER BY updated DESC"` — confirms the `updated >= -60d` clause, correctly field-swapped from `--recent`'s `created >= -{d}` template (NOT `created >= -60d`). Exit 0. |
| AC-004, AC-005 | BC-2.1.023 postcondition 3 (free composition) + BC-2.1.007 amendment (stable-order position) | `AC-004-005-recent-and-updated-recent-ordering.{gif,webm}` | `jr --no-input --verbose --verbose-bodies issue list --project DEMO --recent 30d --updated-recent 60d` | Outgoing JQL body: `"jql":"project = \"DEMO\" AND created >= -30d AND updated >= -60d ORDER BY updated DESC"` — both clauses compose, AND-joined, no error; `created >= -30d` (from `--recent`) is positioned immediately BEFORE `updated >= -60d` (from `--updated-recent`), matching BC-2.1.007's amended stable-order slot. Exit 0. |
| AC-003 | BC-2.1.023 Edge Case EC-2.1.023-2 (asymmetric `conflicts_with`, DEC-298) | `AC-003-updated-recent-conflicts-with-updated-after.{gif,webm}` | `jr issue list --updated-recent 60d --updated-after 2026-01-01` | clap rejects the combination pre-HTTP: `error: the argument '--updated-recent <UPDATED_RECENT>' cannot be used with '--updated-after <UPDATED_AFTER>'`. Exit 2. (`--updated-recent` + `--updated-before` is NOT covered by `conflicts_with` — deliberate asymmetry per DEC-298, not separately recorded as a positive-composition case since AC-004/005 already demonstrates `--updated-recent` composing freely with another filter.) |
| AC-006, AC-007 | BC-2.1.006 amendment (filter-source enumeration 14->15) + BC-2.1.023 Edge Case EC-2.1.023-4 (counts as a filter source, does not bypass project scoping) | `AC-006-007-no-filters-guard-15-sources.{gif,webm}` | `jr --no-input issue list --updated-recent 60d` (no `--project`, no configured project, no other filter) | Falls through to the amended "no filters specified" guard: `Error: No project or filters specified. Use --project, --assignee, --reporter, --status, --open, --team, --recent, --created-after, --created-before, --updated-after, --updated-before, --asset, --component, --updated-recent, or --jql. ...` — 15 enumerated sources, `--updated-recent` appended immediately before `or --jql`. Confirms `--updated-recent` alone does not satisfy the filter requirement / bypass project scoping. Exit 64, zero HTTP calls made. |

## AC → coverage mapping (full set)

All 8 ACs trace to BC-2.1.023 / BC-2.1.006 / BC-2.1.007. Four are covered by
the live-mock recordings above; the remaining four are pure/unit-level
(pre-HTTP JQL-string composition and validator-error-shape checks with no
distinct runtime-observable behavior beyond what AC-001/008 and AC-003
already show) and are covered by the story's automated test suite:

| AC | Covered by | Test |
|----|-----------|------|
| AC-001 | Live recording (table above) | `test_bc_2_1_023_issue_list_updated_recent_composes_clause()` |
| AC-002 | Automated test (`tests/issue_commands.rs`) — pre-HTTP rejection of combined-unit durations (`4w2d`) via the same `jql::validate_duration` shared with `--recent`; same validation class as AC-003's zero-HTTP recording, no additional runtime-observable distinction | `test_bc_2_1_023_issue_list_updated_recent_rejects_combined_units_pre_http()` |
| AC-003 | Live recording (table above) | `test_bc_2_1_023_issue_list_updated_recent_conflicts_with_updated_after_only()` |
| AC-004 | Live recording (table above) | `test_bc_2_1_023_issue_list_updated_recent_composes_freely_with_recent()` |
| AC-005 | Live recording (table above) | `test_bc_2_1_007_issue_list_updated_recent_clause_ordering_after_recent_before_asset()` |
| AC-006 | Live recording (table above) | `test_bc_2_1_006_issue_list_no_filters_stderr_enumerates_15_sources()` |
| AC-007 | Live recording (table above) | `test_bc_2_1_023_issue_list_updated_recent_alone_still_requires_project_scope()` |
| AC-008 | Live recording (table above) | `test_bc_2_1_023_issue_list_updated_recent_uses_updated_field_not_created()` |

Full automated suite for this story: `tests/issue_commands.rs`,
`tests/all_flag_behavior.rs`, `tests/issue_list_errors.rs`, plus the
`Vec<String>`-positional-equality unit test in `src/cli/issue/list.rs`
(`test_bc_2_1_007_build_filter_clauses_updated_recent_immediately_after_recent_before_asset`).
Verified green on `b1d31d57` at recording time (`cargo build` clean, no
warnings).

## Regeneration

```bash
cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-579-1
cargo build
python3 /Users/zious/Documents/GITHUB/jira-cli/.factory/demos/S-579-1/mock_server.py &
export JR_CONFIG_DIR=/tmp/jr-demo-config-579 JR_CACHE_DIR=/tmp/jr-demo-cache-579 \
       JR_BASE_URL=http://127.0.0.1:8935 JR_AUTH_HEADER='Basic ZmFrZTpmYWtl' RUST_LOG=warn
./target/debug/jr --no-input --verbose --verbose-bodies --output json \
  issue list --project DEMO --updated-recent 60d
```

Then, from the product repo root (`/Users/zious/Documents/GITHUB/jira-cli`),
re-run `vhs .factory/demos/S-579-1/<name>.tape` for any of the four tapes in
this directory to regenerate the `.gif`/`.webm` pair.
