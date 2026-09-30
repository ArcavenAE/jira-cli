# Demo Evidence — S-cycle14-field-options-name-label: `jr field options` system-field label fallback (#861)

Story: `S-cycle14-field-options-name-label` (cycle-014, STORY-B) — `jr field options` now
resolves a system-typed field's option label via a `value.or(name)` fallback, so fields like
`Priority`/`Components` (whose `allowedValues` entries carry only `name`, no `value`) render a
real label instead of `"(unnamed)"`/`null`. BCs: BC-X.14.001 (PRIMARY), BC-X.14.003/BC-X.14.004
(CROSS-REF, both COUNT-NEUTRAL). 9 acceptance criteria; Step 4.5 adversarial convergence
COMPLETE (passes 2, 3, 4 CLEAN_NITPICK_ONLY at HEAD `02bf041f`; one further CHANGELOG-only
commit landed afterward, `7e5d0dc6`, before this recording session — confirmed by `git diff` to
touch only `CHANGELOG.md`, no functional file).

## Note on where this evidence lives

Per the per-story-delivery convention, this evidence set will be relocated to the
`factory-artifacts` branch at **`.factory/demos/S-cycle14-field-options-name-label/`**, where it
lives permanently (mirroring `S-cycle14-api-query-param`'s own precedent). It was generated here
— untracked, inside this feature worktree at
`docs/demo-evidence/S-cycle14-field-options-name-label/` — and is **not** committed to the
product branch (see "Note on `docs/demo-evidence/` and `.gitignore`" below).

## Tool used

**VHS** (terminal recording), version 0.11.0 (`/opt/homebrew/bin/vhs`, already present in this
environment). Every recording produces a matched `.gif` (PR-embed) + `.webm` (archival) pair
plus its `.tape` source, per the CLI recording convention. `FontFamily "Menlo"` (macOS default
monospace; no JetBrains Mono / FiraCode Nerd Font Mono installed in this environment — `Menlo`
is next on the documented priority list and matches the `S-cycle14-api-query-param` precedent).

Following the `S-cycle14-api-query-param` precedent's documented VHS workaround: every tape uses
`Wait+Screen /pattern/` (matches anywhere in the currently-visible terminal screen), never
`Wait+Line` (which restricts matching to the terminal's current LAST line only and times out for
fast-completing local commands). Nested quotes in a `Type` command use backtick delimiters
(e.g. `` Type `jr field options "Severity Probe" --issue FOO-1` ``) so the inner double quotes
pass through to the shell unescaped.

## No real Jira data or network used — confirmation

- Every recording runs the actual worktree debug binary (`cargo build`, `target/debug/jr`,
  version `0.8.0-dev.1`). `setup.sh` prepends `$PWD/target/debug` onto `PATH` before every
  recording, so any separately-installed `~/.local/bin/jr` is never exercised.
- `JR_BASE_URL` points at `http://127.0.0.1:8793`, a local Python stdlib `http.server`-based
  mock (`mock_field_options_server.py`) that serves hand-authored fixture JSON for exactly the
  seven endpoint shapes `jr field options` calls (verified against `src/cli/field.rs`,
  `src/api/jira/issues.rs`, `src/api/jira/fields.rs`, `src/api/jsm/servicedesks.rs`,
  `src/api/jsm/request_types.rs`), plus logs one line per request to a file so a recording can
  prove a pre-flight guard made ZERO HTTP calls. **No real Jira instance, cloud ID, or org is
  ever contacted.**
- `JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'` (base64 `fake:fake`) bypasses keychain credential
  loading entirely — no OS keychain/Credential Manager entry is read or written.
- `JR_CONFIG_DIR`/`JR_CACHE_DIR` point at fresh `mktemp -d` directories per recording — the real
  `~/.config/jr` and `~/.cache/jr` are never touched.
- Every ambient `JR_*`-prefixed environment variable is scrubbed (via a `for`/`unset` loop in
  `setup.sh`) before any seam is set, so a stray developer/CI `JR_*` value cannot leak into a
  recording.
- The fake instance URL in the config fixture is `https://example.atlassian.net` (never used
  for actual requests — `JR_BASE_URL` overrides it for every outbound call). No real project
  keys, account IDs, or emails appear anywhere: every identifier used is a synthetic placeholder
  (`FOO`/`FOO-1`, `EJ`, numeric ids `1`/`10`/`10001`/`100`-`301`) — none of these resolve to any
  real Jira Cloud tenant.

## Mock fixture design

One issue (`FOO-1`, editmeta / M1) and one project pair (`FOO` platform / `EJ` JSM) cover every
demo:

| Field (id) | Shape | Purpose |
|---|---|---|
| `Priority` (`priority`) | system, `{id, name, iconUrl}` — **no `value` key** | the exact #861 defect shape (AC-001) |
| `Components` (`components`) | system, `{id, name}`, exposed via M2 createmeta only | AC-001 via the M2 path |
| `Fix versions` (`fixVersions`) | system, listed in `/rest/api/3/field` only | completeness (per the task checklist); no dedicated demo calls it |
| `Environment` (`customfield_10100`) | custom select, ordinary `{id, value}` | cross-reference: custom-field labels unaffected |
| `Category` (`customfield_10200`) | custom CASCADING select; child 1 `{id, value}`, child 2 `{id, name}` only | AC-001 EC-X.14.001-11 (fallback recurses into children) |
| `Severity Probe` (`customfield_10300`) | custom select; `{value:"", name:"Blank But Named"}` + `{value:null, name:"Falls Through"}` | AC-002 EC-X.14.001-12 (presence, not emptiness) |
| `Legacy Probe` (`customfield_10400`) | custom select; `{id:"99"}` — neither `value` nor `name` | AC-001/AC-005 degenerate "neither present" case |

M3 (`--request-type 10 --project EJ`) reuses `Priority`/`Components` against a JSM
requesttype-fields fixture whose own wire shape (`{"value": "1", "label": "Highest"}`) is
independent of the M1/M2 fixtures above.

## Recordings

| Recording | Command demonstrated | Result |
|---|---|---|
| `AC-001-priority-name-fallback` | `jr field options Priority --issue FOO-1` (+ `--output json`) | table shows `Highest`/`High`/`Medium`; JSON `label` is the name string, never `null` |
| `AC-001-m2-createmeta` | `jr field options Components --type Task --project FOO` | `Backend`/`Frontend`; error path: `--project BADPROJ` exits 64, unchanged message |
| `AC-001-cascading-and-custom-value` | `jr field options Category --issue FOO-1`; `jr field options Environment --issue FOO-1` | cascading child `Storage Only` resolves via fallback; `Environment`'s `value`-based labels unaffected |
| `AC-001-neither-present-unnamed` | `jr field options "Legacy Probe" --issue FOO-1` (+ `--output json`) | entry survives (never dropped); `(unnamed)` / `null` |
| `AC-002-presence-semantics` | `jr field options "Severity Probe" --issue FOO-1` (+ `--output json`) | id 300 → blank label (value wins over name even though empty); id 301 → `Falls Through` (null falls through) |
| `AC-003-value-filter` | `jr field options Priority --issue FOO-1 --value high`; `--value zzz` | 2 matches via fallback label; 0 matches, exit 0 |
| `AC-004-m3-unchanged` | `jr field options Priority --request-type 10 --project EJ` | `Highest`/`High` via M3's own `.value`/`.label`; error path: `Components` not on RT 10 exits 64, unchanged message |
| `AC-006-help-wording` | `jr field --help \| grep -i "custom or system"`; `jr field options --help \| grep -i "custom or system"` | both greps match the corrected about-text |
| `AC-009-empty-field-guard` | `jr field options "" --issue FOO-1; echo "exit=$?"`; `wc -l` on the mock request log | exit 64, canonical message; log stays at 0 lines (zero HTTP) |

## AC → Evidence mapping

| AC | Summary | Evidence | Verdict |
|---|---|---|---|
| AC-001 | M1/M2 label-resolution fallback (`value.or(name)`, presence-based, cascading, never-drop) | `AC-001.md`; 4 recordings `AC-001-*.{gif,webm}`; inline unit/proptest cells in `src/cli/field.rs` | PASS |
| AC-002 | Presence-based, not emptiness-based (EC-X.14.001-12) | `AC-002.md`; recording `AC-002-presence-semantics.{gif,webm}` | PASS |
| AC-003 | `--value` filter matches via the fallback label (downstream consequence, not a new rule) | `AC-003.md`; recording `AC-003-value-filter.{gif,webm}` | PASS |
| AC-004 | M3 (JSM requesttype-fields) UNCHANGED; WRITE-side `field_resolve.rs` untouched [D-378] | `AC-004.md`; recording `AC-004-m3-unchanged.{gif,webm}`; `git diff` confirms zero changes to `src/cli/issue/field_resolve.rs` | PASS |
| AC-005 | Rendering contract for a `None` label byte-for-byte UNCHANGED (COUNT-NEUTRAL cross-ref) | `AC-005.md`; shares `AC-001-neither-present-unnamed` recording | PASS |
| AC-006 | Stale "custom field"/"`partial_match`" wording corrected (9 sites, 3 `--help`-visible) | `AC-006.md`; recording `AC-006-help-wording.{gif,webm}`; `grep` verification for the other 6 sites | PASS |
| AC-007 | Test rename to reflect `search_field_list` (doc-only, no behavior change) | `AC-007.md` — doc/test-naming artifact, no recording; verified by code read + full `cargo test` | N/A (doc/test-naming) |
| AC-008 | System-typed field NAME resolution unaffected (pre-existing `search_field_list`) | `AC-008.md` — no dedicated recording; implicitly exercised by every other recording (every command resolves a human field name first) | N/A (no dedicated demo; pre-existing, unaffected) |
| AC-009 | Empty `<field>` guard unaffected (EC-X.14.001-15) | `AC-009.md`; recording `AC-009-empty-field-guard.{gif,webm}` | PASS |

## Cleanup performed

- Mock server process (`mock_field_options_server.py`, port 8793) killed after all recordings
  completed (confirmed via `ps aux | grep mock_field_options` returning no rows).
- Every `mktemp -d` scratch directory created by `setup.sh` during this recording session (both
  the `/tmp/jr-demo-cache-ac00*` cache dirs and each invocation's own `$TMPDIR/tmp.XXXXXXXXXX`
  fake `JR_CONFIG_DIR` parent) was removed, along with the shared mock-request log file
  (`/tmp/jr-demo-field-options-requests.log`) and the ad hoc manual-verification config/cache
  dirs used before recording (`/tmp/jr-demo-manual-config`, `/tmp/jr-demo-manual-cache*`).
- No files were written outside `docs/demo-evidence/S-cycle14-field-options-name-label/` in
  this worktree.

## Reproducing the recordings

Every `.tape` file's `Type` lines reference paths relative to the repo root (e.g.
`docs/demo-evidence/S-cycle14-field-options-name-label/setup.sh`), and `setup.sh` does not `cd`
away from the repo root, so `vhs` must be invoked from the repo root:

```bash
git worktree add /tmp/jr-demo-repro fix/field-options-name-label
cd /tmp/jr-demo-repro
cargo build
mkdir -p docs/demo-evidence
cp -R /path/to/.factory/demos/S-cycle14-field-options-name-label docs/demo-evidence/
python3 docs/demo-evidence/S-cycle14-field-options-name-label/mock_field_options_server.py \
  8793 /tmp/jr-demo-field-options-requests.log &
for t in docs/demo-evidence/S-cycle14-field-options-name-label/*.tape; do
  vhs "$t"
done
kill %1
```

## Note on `docs/demo-evidence/` and `.gitignore`

`docs/demo-evidence/` is listed in this repo's `.gitignore` (added by PR #708, "purge
demo-evidence from product repo; gitignore docs/demo-evidence (relocate to factory-artifacts)").
Per PR #708's policy, this evidence was **not** committed to the product branch — it was
generated untracked inside this feature worktree and will be relocated to the
`factory-artifacts` branch at `.factory/demos/S-cycle14-field-options-name-label/`, where it
will live permanently. The product-branch worktree copy remains gitignored and untracked, exactly
as PR #708 intends (`git ls-files docs/demo-evidence` returns empty; `git status --short` shows
no untracked entries for this directory).
