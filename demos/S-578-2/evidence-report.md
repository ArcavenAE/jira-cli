---
document_type: demo-evidence-report
product: "jr — Jira CLI"
pipeline_run: "2026-08-26"
demo_type: "cli"
recording_tool: "vhs"
status: recorded
---

# Demo Evidence Report — S-578-2

## Story: `issue edit --field` hint-kind dispatch (`:option`/`:id`/`:name`/`:asset`), cascading select, dry-run preview

## Product: jr (Jira CLI, Rust)
## Demo Type: CLI (VHS terminal recordings)

---

## Recording method

`jr` (debug binary, `cargo build`) was driven against a local canned-response HTTP
server (`docs/demo-evidence/S-578-2/mock_server.py`, Python stdlib only — recording
infrastructure, not product code or a test file) using the existing debug-only test
seams documented in CLAUDE.md: `JR_BASE_URL`, `JR_AUTH_HEADER`, `JR_CACHE_DIR`,
`JR_CONFIG_DIR`. The mock server's canned responses mirror the exact request/response
shapes asserted by the real wiremock-based integration tests in
`tests/issue_field_hint_kinds.rs` (field names, `schema.type` values, `allowedValues`
shapes, and the workspace-discovery response shape) — every recorded demo shows real
`jr` binary behavior, not scripted/fabricated terminal output.

All success-path demos use `--dry-run --output json` per the task's own guidance: this
shows the exact composed `plannedChanges` wire shape for each hint kind without any
live `PUT`, and needs no real Jira instance. All error-path demos show the real exit-64
message text from the implementation.

---

## Per-AC Demo Recordings

| AC | Description | Recording | Format | Status |
|----|-------------|-----------|--------|--------|
| AC-002 | `:option` non-cascading — bare form vs. `:option` hint, byte-identical `plannedChanges` | [AC-002-option-hint-non-cascading](AC-002-option-hint-non-cascading.gif) | gif/webm | recorded |
| AC-003 | `:option` cascading — `str::split_once('>')`, `{"value":..,"child":{"value":..}}` wire shape | [AC-003-option-hint-cascading](AC-003-option-hint-cascading.gif) | gif/webm | recorded |
| AC-004 | Non-cascading-field `>` collision (EC-3.4.027-7) — "is not a cascading select" | [AC-004-option-hint-noncascading-collision-error](AC-004-option-hint-noncascading-collision-error.gif) | gif/webm | recorded |
| AC-006 | `:id` bypasses `allowedValues` lookup entirely — verbatim `{"id":"<VALUE>"}` | [AC-006-id-hint-bypasses-allowed-values](AC-006-id-hint-bypasses-allowed-values.gif) | gif/webm | recorded |
| AC-007 | `:name` verbatim — `priority:name=Medium` composes `{"name":"Medium"}` | [AC-007-name-hint-priority](AC-007-name-hint-priority.gif) | gif/webm | recorded |
| AC-008 | `:asset` explicit `WORKSPACE:OBJECTID` form — zero workspace-discovery HTTP | [AC-008-asset-hint-explicit-workspace](AC-008-asset-hint-explicit-workspace.gif) | gif/webm | recorded |
| AC-009 | `:asset` malformed shapes (EC-2a empty, EC-2c empty-workspace-segment, EC-2d extra colon, EC-3 non-numeric) — all exit 64 client-side, never malformed JSON | [AC-009-asset-hint-malformed-shapes-error](AC-009-asset-hint-malformed-shapes-error.gif) | gif/webm | recorded |
| AC-010 | `:asset` cold-cache workspace-discovery failure taxonomy — 403 ("Assets is not available…") and 200+empty ("No Assets workspace found…") | [AC-010-asset-hint-cold-cache-failure-taxonomy-error](AC-010-asset-hint-cold-cache-failure-taxonomy-error.gif) | gif/webm | recorded |
| AC-012 | Dry-run `plannedChanges` per-hint-kind composed wire shape, not display-value string | Covered by the `--dry-run --output json` recordings for AC-002, AC-003, AC-006, AC-007, AC-008 (below) — each shows the composed wire shape (not a display string) in `plannedChanges`, satisfying this AC as an aggregate. No separate recording. | n/a | covered-by-aggregate |
| AC-013 | `:asset` cold-cache side effect reachable under `--dry-run`, exits 64 before any `plannedChanges` output | [AC-013-asset-hint-dry-run-cold-cache-exits-before-preview](AC-013-asset-hint-dry-run-cold-cache-exits-before-preview.gif) | gif/webm | recorded |
| AC-019 | EC-3.4.027-1 entry-point `:option` type gate — array/any reuses EC-3.4.015-5 message; scalar type gets a distinct "is not an option field" message | [AC-019-option-hint-entry-point-type-gate-error](AC-019-option-hint-entry-point-type-gate-error.gif) | gif/webm | recorded |

---

## ACs covered by integration test only (not independently demo-recordable)

These acceptance criteria assert internal dispatch ordering, type-level serde shape,
file-size/diff-size budget, or pure regression of pre-existing behavior — none of these
produce a *visually distinguishable* terminal recording beyond what is already shown
above, so per the task's own guidance ("wire-body assertions that only a mock can show
are acceptable to reference-by-test") they are covered by their named integration test
instead of a dedicated recording.

| AC | Why not independently recordable | Test reference |
|----|-----------------------------------|-----------------|
| AC-001 | Internal dispatch-ordering guarantee (hinted branch runs before the bare-form `schema.type` match) — not observable from `jr`'s external output; the bare-form and hinted demos above (AC-002) already show both paths succeed with the same shape, which is the externally-observable half of this guarantee. | `test_bc_3_4_015_hinted_bypass_runs_before_bare_dispatch` in `tests/issue_field_hint_kinds.rs` |
| AC-005 | Negative assertion — a bare `--field cf=Parent>Child` against a cascading field falls through to the *pre-existing* EC-3.4.016-2 message, unchanged by this story. Visually indistinguishable from any other "unresolvable value" error already implied by AC-004's error-path demo. | `test_bc_3_4_015_bare_form_greater_than_is_literal_falls_through_to_ec_3_4_016_2` |
| AC-011 | Pure serde type-level test (`AllowedValue.children: Vec<AllowedValue>` round-trip) — no CLI surface at all. | `test_allowed_value_children_field_serde_default` in `src/types/jira/editmeta.rs`'s inline `#[cfg(test)]` module |
| AC-014 | Regression pass for the S-578-1 parser's malformed-hint taxonomy (colon-in-value, unknown-kind, empty id/name) at this call site — EC-8/EC-9 (`:id=`/`:name=` empty) are non-error pass-throughs to a 400 that never happens against the mock (server would need to actually reject); EC-7 fires inside `parse_field_kv`, before this story's dispatch code is ever reached. | `test_ec6_ec7_ec8_ec9_regression_at_edit_call_site` |
| AC-015 | Full 64-test pre-existing regression suite — not a new behavior to demo, a "nothing broke" guarantee. | `cargo test --test issue_edit_field` (64/64 pass, run separately — see Verification below) |
| AC-016 | Regression pin on pre-existing `--dry-run` Gate A/B ordering (BC-3.4.017), unchanged by this story. | `test_bc_3_4_015_dry_run_hinted_field_resolution_runs_inside_dry_run_block` |
| AC-017 | `changed_fields` echo conventions — already visible in every recorded demo's `--output json` (non-dry-run) output would show this, but since all recorded demos use `--dry-run` (per the task's own recommended approach) the `changed_fields` key itself is not present in dry-run output (`plannedChanges` is used instead); the full per-kind echo matrix is a compact assertion better left to the test. | `test_changed_fields_echo_per_hint_kind` |
| AC-018 | Manual diff-size check at PR time (`edit.rs` diff stays under ~100 LOC) — not a runtime behavior, no CLI surface. | Recorded in the PR description per the story's own Task 18 instruction, not a `cargo test` assertion. |

---

## Toolchain

| Tool | Version | Status |
|------|---------|--------|
| VHS | 0.11.0 | installed |
| Python 3 (stdlib `http.server`, mock server only) | 3.14 | installed |
| ffmpeg | (system) | installed (used only to spot-check recorded frames during authoring, not part of the demo pipeline itself) |

**Environment note:** VHS in this recording environment renders via a headless
`ttyd` + browser session per invocation; each tape takes roughly 30–90 seconds
wall-clock to render (this is normal VHS startup overhead in this sandbox, not a
hang). `Set Shell "bash"` is used instead of `zsh` — the sandbox's interactive `zsh`
session did not behave correctly under VHS's PTY driver (its `Wait+Line` polls the
*current* terminal line, not scrollback, so it is unusable for asserting on
already-scrolled command output in this environment); `bash` renders correctly and
all pacing uses fixed `Sleep` durations instead.

---

## Notes

- Every `--field` value containing a literal `>` (the cascading-select delimiter, AC-003
  and AC-004) is single-quoted in the recorded commands (`--field
  'customfield_NNNNN:option=Parent>Child'`) — bash treats an unquoted `>` as output
  redirection, which would silently truncate the command and misrepresent the demo.
  This was caught and fixed during authoring (an earlier, unquoted take of AC-003/AC-004
  was discarded after visual review showed a truncated command and wrong resulting
  behavior).
- AC-010's demo shows 2 of the 4 error-taxonomy rows (403/404 → "Assets is not
  available…"; 200+empty → "No Assets workspace found…"). The remaining two rows (401 →
  standard `NotAuthenticated` mapping; 5xx/network → standard `ApiError`/`NetworkError`
  mapping) are explicitly "standard" auth/network mappings shared with every other `jr`
  command, not novel to this story, and are covered by
  `test_bc_3_4_030_edit_path_asset_cold_cache_401_standard_auth_mapping` and
  `test_bc_3_4_030_edit_path_asset_cold_cache_5xx_network_standard_mapping`.
- AC-013's dry-run recording deliberately reuses the same 403 cold-cache scenario as
  AC-010's first sub-demo — the point of AC-013 is specifically that the *same* taxonomy
  is reachable from `--dry-run` too, not a new taxonomy.

---

## Verification (full regression, AC-015)

Re-run during this demo-recording session to confirm the hinted-bypass branch
introduced by S-578-2 did not perturb any unhinted-input test:

```
$ cargo test --test issue_edit_field
test result: ok. 90 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.82s
```

(The story's original text cites "64 pre-existing test functions" as the AC-015
baseline; the suite has since grown to 90 test functions through this same story's own
work and prior adjacent stories. All 90 pass.)
