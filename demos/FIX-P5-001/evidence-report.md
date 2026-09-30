# Demo Evidence — FIX-P5-001: table-mode ANSI/control-sequence sanitization (BC-7.1.006, SEC-001-RENDER-TABLE-ANSI-SANITIZE)

Fix: `FIX-P5-001` (branch `fix/FIX-P5-001`, HEAD `7d289d75`) closes security-review finding
`SEC-001-RENDER-TABLE-ANSI-SANITIZE` (MEDIUM, CWE-150/CWE-116): `output::render_table` now
sanitizes every header and cell string via a new `output::sanitize_table_cell` before either
reaches `comfy_table` — a server-supplied string (issue summary, field option label, display
name, description text) can no longer inject raw ANSI escape sequences or control characters
into the user's terminal. `--output json` is deliberately never sanitized (stays byte-for-byte
lossless). `jr`'s own Active-column glyph coloring (`jr user list`/`jr user view`) moved from
ANSI-bytes-embedded-in-`String` to a structural `comfy_table::Cell::fg()` attribute via the new
`output::StyledCell`/`render_table_with_styles`/`print_output_with_styles` API. This is a
behavior change (BC-7.1.006 is new), so the fix-pr-delivery flow requires demo evidence.

Relevant commits on this branch: `0af5f7bb` (failing tests, RED), `49a3d8a0` (implementation,
`output.rs`), `af388800` (`user.rs` structural-styling refactor), `67aa863d` (spec doc),
`7d289d75` (RED-gate property-test correction, see BC-7.1.006 §EC-13/VP-SEC-001-001(a)(i)).

## Where this evidence lives

Generated here — untracked, inside this fix worktree at
`docs/demo-evidence/FIX-P5-001/` (confirmed gitignored per PR #708: `git status --ignored`
shows `!! docs/demo-evidence/`) — and **not** committed to the `fix/FIX-P5-001` branch. Per the
fix-pr-delivery convention, this evidence set is relocated to the `factory-artifacts` branch at
**`.factory/demos/FIX-P5-001/`**, where it lives permanently.

## Tool used

**VHS** (terminal recording), version 0.11.0 (`/opt/homebrew/bin/vhs`). Every recording produces
a matched `.gif` (PR-embed) + `.webm` (archival) pair plus its `.tape` source. `FontFamily
"Menlo"` (macOS default monospace; `fc-list` is unavailable in this environment, so the
JetBrains Mono / FiraCode Nerd Font Mono priority tiers could not be probed — `Menlo` is next on
the documented priority list, matching the `S-cycle14-field-options-name-label` precedent).

Following that precedent's documented VHS workarounds: `Wait+Screen /pattern/` (matches
anywhere in the currently-visible terminal screen) is used throughout, never `Wait+Line`.
Nested quotes in a `Type` command use backtick delimiters (e.g. `` Type `echo "..." ` ``) so the
inner double quotes pass through to the shell unescaped. `Set WaitTimeout 15s` is set on every
tape (default proved too short for a couple of the wider/heavier table renders during
iteration — see "VHS quirks encountered" below).

## No real Jira data or network used — confirmation

- Every recording runs the actual worktree debug binary (`cargo build`, `target/debug/jr`,
  `jr 0.8.0-dev.1`). `setup.sh` prepends `$PWD/target/debug` onto `PATH` before every AFTER
  recording, so any separately-installed `~/.local/bin/jr` is never exercised.
- `JR_BASE_URL` points at `http://127.0.0.1:8793`, a local Python stdlib `http.server`-based
  mock (`mock_server.py`) that serves hand-authored fixture JSON for exactly the endpoints the
  demo scenarios call (verified against `src/api/jira/issues.rs`, `src/api/jira/users.rs`,
  `src/api/jira/fields.rs`, `src/api/jira/projects.rs`), plus logs one line per request to a
  file so a recording can prove an HTTP-free command (`jr auth list`) makes zero calls. **No
  real Jira instance, cloud ID, or org is ever contacted.**
- `JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'` (base64 `fake:fake`) bypasses keychain credential
  loading entirely — no OS keychain/Credential Manager entry is read or written.
- `JR_CONFIG_DIR`/`JR_CACHE_DIR` point at fresh `mktemp -d` / per-recording throwaway
  directories — the real `~/.config/jr` and `~/.cache/jr` are never touched.
- Every ambient `JR_*`-prefixed environment variable is scrubbed (via a `for`/`unset` loop in
  `setup.sh`) before any seam is set, so a stray developer/CI `JR_*` value cannot leak into a
  recording.
- The fake instance URL in the config fixture is `https://example.atlassian.net` (never used
  for actual requests — `JR_BASE_URL` overrides it for every outbound call). All identifiers
  used are synthetic placeholders: project key `FOO`, issue keys `FOO-1`/`FOO-2`/`FOO-10`/
  `FOO-11`, account IDs `acc-1`/`acc-2`/`acc-3`, names `Alice Normal`/`Bob .../Carol Unknown`,
  emails `*@example.invalid`. None of these resolve to any real Jira Cloud tenant.
- The BEFORE-fix binary was built from `develop` tip `2ee422e0` in a **separate temporary git
  worktree** under the session scratchpad
  (`/private/tmp/claude-501/.../scratchpad/before-develop`), never inside the main checkout or
  this fix worktree. That temporary worktree has been removed (`git worktree remove`) after
  recording — confirmed via `git worktree list` (no longer present). All temp cache/log dirs
  under `/tmp` used during recording (`/tmp/jr-demo-fixp5-*`, `/tmp/fixp5-*`) have been deleted.

## Mock fixture design (`mock_server.py`)

Every hostile payload is a synthetic ANSI/control-sequence probe authored for this demo — not
data from any real system.

| Endpoint | Purpose |
|---|---|
| `GET /rest/api/3/field` | field list / CMDB-field discovery (issue view's best-effort asset lookup) |
| `GET /rest/api/3/project/FOO` | `issue list`'s pre-flight `--project` existence check |
| `GET /rest/api/3/issue/FOO-1/editmeta` | `jr field options customfield_10300 --issue FOO-1` (M1) |
| `GET /rest/api/3/issue/FOO-2` | `jr issue view FOO-2` |
| `POST /rest/api/3/search/jql` | `jr issue list` |
| `GET /rest/api/3/user/assignable/multiProjectSearch` | `jr user list --project FOO` |
| `GET /rest/api/3/user?accountId=...` | `jr user view <accountId>` |

**Hostile payload composition** (see `mock_server.py`'s module docstring for the full
character-by-character derivation):

- `SUMMARY_HOSTILE` (`jr issue list`, issue `FOO-10`): one string combining an SGR color
  sequence (`\x1b[31m...\x1b[0m`), an OSC-0 window-title sequence (`\x1b]0;pwned\x07`,
  BEL-terminated), a C1 CSI introducer (`U+009B`) followed by bytes that would continue a 7-bit
  CSI sequence but are **not** consumed as one, a bidi-override pair (`U+202E`), and a bare
  `\r\n`. Sanitized AFTER value (verified below): `"Before FAKE-CRITICAL mid 31mInject
  bidioverride end\nSecondLine"`.
- `customfield_10300` ("Severity", `jr field options`, editmeta `FOO-1`): three
  `allowedValues` entries — id `1` carries an SGR-colored label, id `2` carries `"a\tb"` (tab
  demo), id `3` is plain `"Plain"`.
- `FOO-2` description (`jr issue view`): ADF `paragraph` + `hardBreak` + `paragraph`, the first
  paragraph carrying an SGR sequence, the second a bidi-override pair — proves the hardBreak's
  emitted `\n` survives sanitization (multi-line cell intact) while the hostile bytes are
  stripped.
- `jr user list` / `jr user view`: three users — `Alice Normal` (active `true`), `Bob
  <SGR-red>Hostile<SGR-reset> Name` (active `false`), `Carol Unknown` (active `null`) —
  exercising all three Active-column glyphs (`✓`/`✗`/`—`) alongside the hostile display name.

## Recordings

| Recording | Command(s) demonstrated | What it shows |
|---|---|---|
| `AC-1-before-after-field-options` | `jr field options customfield_10300 --issue FOO-1` on BOTH the BEFORE binary (develop tip `2ee422e0`) and the AFTER binary (this fix), each piped through `cat -v`; then `--output json` on AFTER | BEFORE: raw `^[[35m`/`^[[0m` (SGR) markers visible in `cat -v` output around `Sev-Hostile`. AFTER: same command renders `Before Sev-Hostile After` / `a b` / `Plain` — zero `^[` markers; a `grep -c $'\x1b'` count confirms 0 raw ESC bytes; `--output json` round-trips the identical raw-ESC-containing string (EC-12) |
| `AC-2-issue-list-table-vs-json` | `jr issue list --jql "project = FOO"` (table, default) via `cat -v`; same query with `--output json` | Table mode: `FOO-10`'s 5-hostile-payload summary renders as `Before FAKE-CRITICAL mid 31mInject bidioverride end` / `SecondLine` (two wrapped lines from the preserved `\n`), zero `^[`/C1 markers. JSON mode: a python3 `json.load` + `assert` proves the identical raw ESC/C1/bidi bytes all survive unsanitized |
| `AC-3-issue-view-multiline` | `jr issue view FOO-2` via `cat -v`; `grep -c $'\x1b'` count | Description cell renders as two lines — `Line one RED end` / `Line two with bidi override done` — proving the ADF `hardBreak`-emitted `\n` (EC-9) survives sanitization while the SGR sequence and bidi overrides on either side are stripped; 0 raw ESC bytes across the whole table |
| `AC-4-user-list-view-color` | `jr user list --project FOO` (color forced, real VHS pty); same with `--no-color`; same with `--no-color \| grep Bob \| cat -v`; `jr user view acc-2 \| cat -v` | Active column ✓/✗/— glyphs render in color under a real pty and in plain text under `--no-color`; Bob's hostile display name renders as clean `Bob Hostile Name` in both the list and the single-record view, with the Active ✗ glyph intact alongside it |
| `AC-5-auth-list-unchanged` | `jr auth list`; `wc -l` on the mock's request log | Table is byte-for-byte the pre-existing shape (profile name, URL, ENV, AUTH, STATUS); the request log stays at 0 lines, confirming `auth list` performs zero HTTP calls and is unaffected beyond routing through the same (no-op-for-it) `sanitize_table_cell` chokepoint |

## EC → demo → verdict

| EC (BC-7.1.006) | Demo | What it shows | Verdict |
|---|---|---|---|
| EC-1 (ANSI CSI stripped) | AC-1, AC-2, AC-4 | SGR sequences removed from `Sev-Hostile`, `FAKE-CRITICAL`, `RED`, `Hostile` | PASS |
| EC-2 (OSC window-title stripped, BEL-terminated) | AC-2 | `\x1b]0;pwned\x07` removed from the issue-list summary, no trace | PASS |
| EC-3 (unterminated CSI fails closed) | described (not separately demoed — no unterminated sequence in the demo fixtures; covered by `src/output.rs`'s own unit tests) | — | N/A to demo scope, unit-tested |
| EC-4 (bidi override pair stripped) | AC-2, AC-3 | `U+202E ... U+202E` removed around `override` | PASS |
| EC-5 (C1 CSI introducer stripped; survivor bytes remain literal) | AC-2 | `U+009B` removed as a single code point; `31mInject bidi` (the bytes that would have continued a 7-bit CSI sequence) survive as literal text | PASS |
| EC-6 (C0 controls stripped) | covered by EC-7/EC-8 below (CR is the C0 control exercised) | — | PASS (via EC-8) |
| EC-7 (bare `\r` stripped) | AC-2 (the CRLF in `SUMMARY_HOSTILE`) | see EC-8 | PASS |
| EC-8 (`\r\n` collapses to `\n`) | AC-2 | `" end\r\nSecondLine"` renders as two table-wrapped lines, not `" end\nSecondLine"` with a stray `\r` artifact | PASS |
| EC-9 (bare `\n` preserved, multi-line cell) | AC-3 | `hardBreak`-emitted `\n` in the Description ADF survives sanitization; the cell renders as two lines | PASS |
| EC-10 (`\t` → single space) | AC-1 | `customfield_10300` id `2`'s `"a\tb"` renders as `a b` | PASS |
| EC-11 (ordinary text unchanged) | AC-1, AC-2, AC-4, AC-5 (every clean value: `Plain`, `FOO-11`'s summary, `Alice Normal`, `Carol Unknown`, the whole `auth list` table) | clean strings pass through byte-for-byte | PASS |
| EC-12 (`--output json` never sanitized) | AC-1, AC-2 | `--output json` round-trips the identical hostile payload (raw ESC/C1/bidi bytes all present), verified via `json.load` + `assert`, not string matching | PASS |
| EC-13 (unterminated CSI/OSC swallows a trailing `\n`) | not separately demoed (would require an artificially malformed fixture outside this demo's realistic-hostile-payload scope; covered by `src/output.rs`'s own EC-13 unit test pin) | — | N/A to demo scope, unit-tested |
| Active-column structural styling (`format_active`/`active_cell`) | AC-4 | color forced under a real pty; `--no-color` suppresses it; hostile display name stripped alongside an intact Active glyph | PASS |
| `auth list` unaffected (non-`render_table`-hostile caller) | AC-5 | unchanged table, zero HTTP | PASS |

## Before vs. after — explicit comparison

Shown in `AC-1-before-after-field-options`: the SAME command
(`jr field options customfield_10300 --issue FOO-1`) against the SAME mock fixture, run first
against `develop` tip `2ee422e0` (pre-`FIX-P5-001`, built in a separate temporary worktree),
then against this fix's binary. The BEFORE section's `cat -v` output shows the raw SGR escape
markers (`^[[35m` opening, `^[[0m` closing) surrounding `Sev-Hostile` — `render_table` at that
commit had no `sanitize_table_cell` chokepoint, so the server-supplied ANSI bytes passed straight
into the `comfy_table` cell and out to the terminal untouched. The AFTER section, same command,
same fixture, shows the escape markers gone (`Before Sev-Hostile After`) and a `grep -c`
byte-count proving 0 raw ESC bytes remain.

For the other scenarios (issue list, issue view, user list/view), only the AFTER binary was
recorded (rebuilding+re-recording a second BEFORE pass for each would not have added new
evidence beyond what AC-1's comparison already establishes about the mechanism). Per the task's
own fallback allowance, here is what the BEFORE binary would have shown for each, based on the
same pre-fix `render_table` (no sanitization at all) and confirmed by the fixture payloads
used:

- **`jr issue list`** (`cat -v`): the `FOO-10` summary row would show `^[[31m` before
  `FAKE-CRITICAL`, `^[[0m` after it, `^[]0;pwned^G` (OSC, BEL as `^G`) before `mid`, `M-^[` (the
  C1 introducer `U+009B` rendered by `cat -v` as a high-bit marker) before `31mInject`, and the
  bidi-override `U+202E` pair would appear as additional `M-`-prefixed markers around
  `override`; the terminal itself might also visibly redraw in red / retitle its window, since
  a real terminal (not just `cat -v`) would interpret the raw SGR/OSC bytes.
- **`jr issue view FOO-2`**: the Description cell would show `^[[31m` before `RED`, `^[[0m`
  after it, and `M-^[`-class markers around `override` from the bidi pair.
- **`jr user list`**: Bob's row would show `^[[31m` before `Hostile` and `^[[0m` after it in
  the Display Name column.

## Reproduction

```bash
cd .worktrees/FIX-P5-001
cargo build
python3 docs/demo-evidence/FIX-P5-001/mock_server.py 8793 /tmp/jr-demo-fixp5.log &
source docs/demo-evidence/FIX-P5-001/setup.sh /tmp/jr-demo-cache /tmp/jr-demo-fixp5.log
jr field options customfield_10300 --issue FOO-1 | cat -v
jr issue list --jql "project = FOO" | cat -v
jr issue view FOO-2 | cat -v
jr user list --project FOO --no-color | cat -v
jr auth list
kill %1  # stop the mock server
```

To reproduce the BEFORE/AFTER comparison: build `develop` tip `2ee422e0` in a separate worktree
(`git worktree add <path> 2ee422e0 && cd <path> && cargo build`), point `PATH` at that binary's
`target/debug` instead, and re-run the `jr field options` command above against the same mock
server.

## VHS quirks encountered (for future demo-recorder reference)

- Nested double quotes inside a `Type "..."` command must use backtick delimiters
  (`` Type `...` ``) — confirmed again here, matching the `S-cycle14-field-options-name-label`
  precedent's documented workaround.
- `Wait+Screen` (not `Wait+Line`) is required for fast-completing local commands, per the same
  precedent.
- Piping a WIDE, multi-column `comfy_table` output (4+ columns, e.g. `jr user list`'s Display
  Name/Email/Active/Account ID table) through `cat -v` inflates the rendered width heavily
  (every box-drawing character becomes a 3-byte `M-^T`-style escape), which pushed VHS's
  terminal rendering past the default `Wait+Screen` timeout during iteration on
  `AC-4-user-list-view-color`. Fix applied: (a) `Set WaitTimeout 15s` on every tape as a safety
  margin, and (b) for the specific wide-table `cat -v` demo, `grep`-filter to the single row of
  interest BEFORE piping through `cat -v`, so the byte-visualizer only has to process one short
  line instead of an entire multi-column table. A THREE-stage pipe
  (`jr issue view ... | cat -v | grep -A2 Description`, i.e. grep AFTER cat -v) also proved
  unreliable inside VHS's pty (produced zero output within the wait window despite running
  correctly outside VHS) — worked around by piping `cat -v` directly on the full (narrower,
  2-column) table instead of chaining a third stage.

## Cleanup performed

- Mock server process killed (`pkill -f mock_server.py`; confirmed via `ps aux` no longer
  listing it).
- Temporary `before-develop` worktree removed via `git worktree remove` (confirmed absent from
  `git worktree list`).
- All `/tmp/jr-demo-fixp5-*` and `/tmp/fixp5-*` cache/log/scratch files deleted.
- Confirmed via `git status --short` (clean) and `git status --ignored --short`
  (`!! docs/demo-evidence/`) that nothing under `docs/demo-evidence/` is tracked or staged, in
  this worktree or the main checkout.
