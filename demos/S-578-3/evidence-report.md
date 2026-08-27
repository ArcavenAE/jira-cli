---
document_type: demo-evidence-report
product: "jr — Jira CLI"
pipeline_run: "2026-08-26"
demo_type: "cli"
recording_tool: "vhs"
status: recorded
---

# Demo Evidence Report

## Product: jr — Jira CLI
## Story: S-578-3 — JSM `issue create --field` hint-kind uniformity (`JsmRequestBuilder::build()` kind-aware `requestFieldValues` dispatch)
## Pipeline Run: 2026-08-26
## Demo Type: CLI (VHS terminal recordings)

---

## Coverage approach

`jr issue create --project HELP --request-type "Password Reset" ...` was recorded against
a lightweight stdlib-Python mock server (`--port 186NN`, per tape) that mirrors the exact
wiremock fixture chain used by `tests/issue_create_jsm.rs`:
`GET /rest/api/3/project/HELP` → service_desk project meta → `GET /rest/servicedeskapi/servicedesk`
→ desk id `10` → `GET /rest/servicedeskapi/servicedesk/10/requesttype` → "Password Reset" (id `11002`)
→ `GET /rest/servicedeskapi/assets/workspace` (configurable per scenario) → `POST
/rest/servicedeskapi/request` → `201` (`HELP-42`). `JR_BASE_URL`/`JR_AUTH_HEADER` (debug-only
seams, see CLAUDE.md) point the freshly-built worktree binary (`target/debug/jr`, prepended to
`PATH` ahead of the stale globally-installed `jr 0.5.0-dev.10`) at the mock. All error-message
strings and exit codes shown below were independently smoke-tested against the same mock
server before recording (transcript included in this session), then captured on video.

Several ACs (type-level changes, byte-identity regression pins, wire-shape-only assertions not
observable from `jr`'s stdout) have no distinct terminal-visible behavior — `jr`'s success output
is always `{"key": "HELP-42"}` regardless of which `requestFieldValues` shape was sent under the
hood. Those are marked **test-referenced** below per the recording brief's own allowance ("AC
maps to a demo OR an explicit covered-by-test note").

---

## Per-AC Demo Recordings

| AC | Story | Description | Recording | Format | Duration | Size | Status |
|----|-------|-------------|-----------|--------|----------|------|--------|
| AC-001 | S-578-3 | `extra_fields` type change `&HashMap<String,String>` → `&HashMap<String,FieldValueSpec>` | — | — | — | — | test-referenced (see below) |
| AC-002 | S-578-3 | `build()` kind-aware dispatch: bare/`:id`/`:name` → `{"key":"HELP-42"}` success for each hint | [AC-002-kind-aware-dispatch.gif](AC-002-kind-aware-dispatch.gif) / [.webm](AC-002-kind-aware-dispatch.webm) | gif+webm | 26.7s | 226K/240K | recorded |
| AC-003 | S-578-3 | Cascading `Parent>Child` on `:option` sent as opaque literal (no `>`-split) | [AC-003-cascading-option-opaque-literal.gif](AC-003-cascading-option-opaque-literal.gif) / [.webm](AC-003-cascading-option-opaque-literal.webm) | gif+webm | 11.8s | 90K/72K | recorded |
| AC-004 | S-578-3 | `--field cf:option` (no `=`) → pre-existing "missing '=' " exit-64 error | [AC-004-missing-equals-error.gif](AC-004-missing-equals-error.gif) / [.webm](AC-004-missing-equals-error.webm) | gif+webm | 9.4s | 83K/49K | recorded |
| AC-005 | S-578-3 | `:asset` malformed-value catalog: empty / empty-workspace-segment / extra-colon / non-numeric — 4 exit-64 cases, zero HTTP each | [AC-005-asset-malformed-catalog.gif](AC-005-asset-malformed-catalog.gif) / [.webm](AC-005-asset-malformed-catalog.webm) | gif+webm | 30.7s | 303K/368K | recorded |
| AC-006 | S-578-3 | `:asset` L2 resolution: explicit `WORKSPACE:OBJECTID` (no cache lookup) vs bare `OBJECTID` (resolves first) — both succeed | [AC-006-asset-l2-workspace-resolution.gif](AC-006-asset-l2-workspace-resolution.gif) / [.webm](AC-006-asset-l2-workspace-resolution.webm) | gif+webm | 20.1s | 173K/132K | recorded |
| AC-007 | S-578-3 | `:asset` cold-cache taxonomy: 403→"Assets not available", empty-workspace→"No Assets workspace found", 401→standard NotAuthenticated | [AC-007-asset-cold-cache-taxonomy.gif](AC-007-asset-cold-cache-taxonomy.gif) / [.webm](AC-007-asset-cold-cache-taxonomy.webm) | gif+webm | 24.8s | 223K/120K | recorded |
| AC-008 | S-578-3 | Bare-form byte-identity regression pin (VP-578-015) | — | — | — | — | test-referenced (see below) |
| AC-009 | S-578-3 | `:id`/`:name`/`:asset` JSM wire shapes by analogy, flagged parity-PENDING (VP-578-016) | — | — | — | — | test-referenced (see below) |
| AC-010 | S-578-3 | Full existing 59-test `issue_create_jsm.rs` suite + `jsm_request_api.rs` regression | — | — | — | — | test-referenced (see below) |

---

## Test-referenced ACs (no distinct terminal-visible behavior)

| AC | Reason not rendered | Covering test(s) |
|----|----------------------|-------------------|
| AC-001 | Pure Rust type-signature change (`&'a HashMap<String, String>` → `&'a HashMap<String, FieldValueSpec>`); nothing to demo on a terminal | `test_bc_3_8_008_extra_fields_type_is_field_value_spec_map` |
| AC-008 | Byte-identity regression pin on internal `requestFieldValues` JSON — `jr`'s stdout (`{"key":"HELP-42"}`) is identical before/after this story for a bare field, so no visual distinction exists; AC-002's demo shows the bare-form success path but the wire-shape assertion itself is HTTP-body-level, not stdout-level | `test_vp_578_015_bare_field_byte_identical_pre_post_amendment` |
| AC-009 | `:id`/`:name`/`:asset` wire-shape assertions inspect the JSON POST body captured by wiremock, not anything printed to the terminal — AC-002 and AC-006's demos exercise these code paths end-to-end (both succeed with `{"key":"HELP-42"}`), but the specific `{"id":...}`/`{"name":...}`/array-wrap shapes are only checkable at the HTTP-body level | `test_vp_578_016_id_name_asset_jsm_wire_shapes_by_analogy_flagged_unverified` (module doc comment explicitly flags VP-578-016 as parity-PENDING, per story's Architecture Compliance Rule 4) |
| AC-010 | A full-suite regression run (`cargo test --test issue_create_jsm` / `--test jsm_request_api`) is not a per-AC demo — it is exercised by CI, not a terminal walkthrough | `cargo test --test issue_create_jsm` (59 pre-existing + 19 new), `cargo test --test jsm_request_api` |

---

## Recording apparatus (not committed — gitignored per repo policy #708)

| File | Purpose |
|------|---------|
| `mock_jsm_server.py` | Stdlib-only HTTP mock mirroring the JSM dispatch chain (project meta → service desk list → request-type list → asset workspace → JSM POST), configurable per-scenario via CLI flags |
| `setup_ac00{2..6}.sh`, `setup_ac007_base.sh`, `switch_ac007.sh` | Per-tape hidden setup scripts (config.toml write, mock server start, env export, migration-message priming) sourced/invoked from each `.tape`'s `Hide` block |

All apparatus lives under the session scratchpad (`/private/tmp/.../scratchpad/s578-3-demo/`),
outside the repo tree — the `.tape` files reference it by absolute path since these scripts are
recording-session infrastructure, not reusable product artifacts.

---

## Toolchain

| Tool | Version | Status |
|------|---------|--------|
| VHS | 0.11.0 | installed |
| ffmpeg | (Homebrew, present) | installed |
| Python | 3.14.3 (stdlib `http.server` mock, no third-party deps) | installed |
| jr (worktree debug build) | 0.7.0-dev.2 | built via `cargo build`, `target/debug/jr` prepended to `PATH` ahead of the stale global `jr 0.5.0-dev.10` |

---

## Notes

- WebM is the primary format; GIF is the PR-embeddable fallback. Both produced for every recorded AC.
- Every recorded tape single-quotes every `--field NAME:kind=VALUE` argument (verified by
  `grep -n -- "--field [^']" *.tape` returning zero command matches — only comment-line false
  positives) so `>` (AC-003's cascading `Parent>Child` value) and `:` are never shell-interpreted.
- `git status --short` from the worktree root shows **zero** stray files after all six renders —
  `docs/demo-evidence/` does not appear in `git status` output at all (repo-policy #708 gitignore
  confirmed active); no `git add -f` was used at any point.
- The evidence directory was **not committed** — it is left uncommitted on disk per the task
  instructions; the orchestrator is responsible for relocating it to the `factory-artifacts`
  branch.
