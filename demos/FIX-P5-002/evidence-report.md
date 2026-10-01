# Demo Evidence — FIX-P5-002: single-line sanitization + structural color gate (BC-7.1.006 v2.5.6, EC-17, CR-1/CR-2, D-396)

Fix: `FIX-P5-002` (branch `fix/FIX-P5-002`, HEAD `3ef98c15`), follow-up to the cycle-014 F5
pass-1 adversarial review of PR #891 (FIX-P5-001). Two changes:

- **CR-1 — single-line sanitizer (`output::sanitize_terminal_line`).** `sanitize_table_cell`/
  `sanitize_terminal_text` deliberately PRESERVE an embedded `\n` (correct for a genuinely
  multi-line sink such as a table cell). That left a gap: a sink that renders exactly ONE line
  of text (a success message, an error line, a picker label) could have a hostile `\n`
  fabricate what looks like an extra labeled field/picker row (EC-17, CWE-116). The new sibling
  function neutralizes `\n` to a single space instead (consecutive `\n` → the same number of
  consecutive spaces). Rewired call sites: `jr issue comment view`'s six labeled fields
  (`src/cli/issue/interactions.rs::handle_comment_view` — the ADF-derived body block stays on
  `sanitize_terminal_text`, since it is genuinely multi-line), `jr issue assign`'s two success
  messages (`src/cli/issue/workflow.rs::handle_assign`), and `disambiguate_user`'s
  non-interactive messages + `disambiguation_labels`'s interactive picker labels
  (`src/cli/issue/helpers.rs`).
- **CR-2 — structural color gate.** `output::render_table_with_styles` now applies a
  `StyledCell`'s `fg` only when `colored::control::SHOULD_COLORIZE.should_colorize()` is `true`
  — `--no-color`/`NO_COLOR` suppression becomes a structural guarantee of the renderer itself,
  not a per-caller responsibility. `jr user list`/`jr user view`'s Active-column glyph coloring
  (`active_cell`, `src/cli/user.rs`) is the only caller today; its own pre-existing
  `SHOULD_COLORIZE` check is now redundant but harmless.

This is a behavior change (BC-7.1.006 v2.5.6 is new), so the fix-pr-delivery flow requires demo
evidence.

Relevant commits on this branch: `2e1f5d20` (stub seam), `df79e4e9` (failing tests, RED),
`8f206627` (implementation), `3ef98c15` (coverage-doc correction).

## Where this evidence lives

Generated here — untracked, inside this fix worktree at `docs/demo-evidence/FIX-P5-002/`
(confirmed gitignored: `git status --ignored --short` shows `!! docs/demo-evidence/`) — and
**not** committed to the `fix/FIX-P5-002` branch. Per the fix-pr-delivery convention, this
evidence set is relocated to the `factory-artifacts` branch at **`.factory/demos/FIX-P5-002/`**,
where it lives permanently. **If you are reading this file inside the `fix/FIX-P5-002` worktree,
it is a working copy only — the durable, canonical copy is at
`.factory/demos/FIX-P5-002/` on `factory-artifacts`.**

## Tool used

**VHS** (terminal recording), version 0.11.0 (`/opt/homebrew/bin/vhs`). Every recording produces
a matched `.gif` (PR-embed) + `.webm` (archival) pair plus its `.tape` source. `FontFamily
"Menlo"` (macOS default monospace, matching the FIX-P5-001 precedent — `fc-list` is unavailable
in this environment so the JetBrains Mono / FiraCode Nerd Font Mono priority tiers could not be
probed).

Following the FIX-P5-001 precedent's documented VHS workarounds: `Wait+Screen /pattern/` is used
throughout (never `Wait+Line`). Nested quotes / literal `\n` sequences in a `Type` command use
backtick delimiters (e.g. `` Type `jr issue assign FOO-9 --to $'Mallory\nEve' --no-input` ``) so
Go's double-quoted-string escape processing never touches the keystrokes — the backslash-n is
sent to bash literally, and bash's own `$'...'` ANSI-C quoting turns it into a real newline
byte in the argument. `Set WaitTimeout 15s` is set on every tape as a safety margin.

## No real Jira data or network used — confirmation

- Every recording runs the actual worktree debug binary (`cargo build`, `target/debug/jr`,
  `jr 0.8.0-dev.1`). `setup.sh` prepends `$PWD/target/debug` onto `PATH` for every AFTER
  recording, so any separately-installed `~/.local/bin/jr` is never exercised.
- `JR_BASE_URL` points at `http://127.0.0.1:8794`, a local Python stdlib `http.server`-based
  mock (`mock_server.py`) that serves hand-authored fixture JSON for exactly the five endpoints
  the demo scenarios call (verified against `src/api/jira/issues.rs`, `src/api/jira/users.rs`,
  `src/cli/issue/{interactions,workflow,helpers}.rs`, `src/cli/user.rs`), plus logs one line per
  request to a file. **No real Jira instance, cloud ID, or org is ever contacted.** The request
  log (`/tmp/jr-demo-fixp5-002.log`) after the full recording run shows only
  `GET /rest/api/3/user/assignable/multiProjectSearch?query=&projectKeys=FOO` (×4, from AC-4's
  four `jr user list` invocations — each `setup.sh` call truncates the log, so only the final
  tape's requests remain, which is expected and fine for this confirmation).
- `JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'` (base64 `fake:fake`) bypasses keychain credential loading
  entirely — no OS keychain entry is read or written.
- `JR_CONFIG_DIR`/`JR_CACHE_DIR` point at fresh `mktemp -d` / per-recording throwaway
  directories — the real `~/.config/jr` and `~/.cache/jr` are never touched.
- Every ambient `JR_*`-prefixed environment variable is scrubbed (via a `for`/`unset` loop in
  `setup.sh`) before any seam is set.
- The fake instance URL in the config fixture is `https://example.atlassian.net` (never used for
  actual requests — `JR_BASE_URL` overrides it for every outbound call). All identifiers are
  synthetic placeholders: project key `FOO`, issue keys `FOO-1`/`FOO-9`, account IDs
  `acc-mallory`/`acc-mallory-1`/`acc-mallory-2`/`acc-1`/`acc-2`/`acc-3`, names
  `Eve`/`Mallory`/`Alice Normal`/`Bob Inactive`/`Carol Unknown`, emails `*@example.invalid`. None
  resolve to any real Jira Cloud tenant or person.
- The BEFORE-fix binary was built from `develop` tip `769365ab` in a **separate temporary git
  worktree** under the session scratchpad
  (`/private/tmp/claude-501/.../scratchpad/before-develop`), never inside the main checkout or
  this fix worktree. That temporary worktree was removed (`git worktree remove`) after recording
  — confirmed via `git worktree list` (no longer present). All temp cache/log/scratch dirs used
  during recording (`/tmp/jr-demo-fixp5-002*`) were deleted.

## Mock fixture design (`mock_server.py`)

Every hostile payload is a synthetic newline-injection probe (EC-17) authored for this demo, not
data from any real system.

| Endpoint | Purpose |
|---|---|
| `GET /rest/api/3/issue/FOO-1` | `jr issue assign`'s idempotency pre-check (unassigned) |
| `GET /rest/api/3/issue/FOO-1/comment/9001` | `jr issue comment view` |
| `GET /rest/api/3/user/assignable/search` (issueKey=FOO-1 vs FOO-9) | `jr issue assign --to` resolution — single match vs. duplicate ExactMultiple |
| `PUT /rest/api/3/issue/FOO-1/assignee` | `jr issue assign --to` write |
| `GET /rest/api/3/user/assignable/multiProjectSearch` | `jr user list --project FOO` |

**Hostile payload composition:**

- `COMMENT_9001`: `author.displayName = "Eve\nRestricted: None"`, no `visibility` key (so the
  real Restricted field renders `"Restricted: None"` on its own line further down).
- `ASSIGNABLE_FOO_1`: one user, `displayName = "Mallory\nEve"` — single-match short-circuit in
  `disambiguate_user` (no partial-match logic engaged at all).
- `ASSIGNABLE_FOO_9`: two users, both `displayName = "Mallory\nEve"` (identical hostile
  duplicate), different emails/account IDs — triggers `MatchResult::ExactMultiple` when queried
  with the exact literal string `"Mallory\nEve"`.
- `USERS_PROJECT_FOO`: three ordinary (non-hostile) users with `active` `true`/`false`/`null`,
  exercising all three Active-column glyphs (`✓`/`✗`/`—`) for the CR-2 color-gate demo.

## Recordings

| Recording | Command(s) demonstrated | What it shows |
|---|---|---|
| `AC-1-comment-view-newline` | `jr issue comment view FOO-1 --id 9001` on BOTH the BEFORE binary (develop tip `769365ab`) and the AFTER binary (this fix) | BEFORE: `Author: Eve` / fake `Restricted: None` line / then `Created:`.../`Updated:`.../`JSM internal:`.../real `Restricted: None`. AFTER: `Author: Eve Restricted: None` on one line; the real `Restricted: None` line two lines later is byte-for-byte unaffected |
| `AC-2-assign-newline` | `jr issue assign FOO-1 --to Mallory --no-input` on BEFORE and AFTER | BEFORE: `Assigned FOO-1 to Mallory` / `Eve` (two lines). AFTER: `Assigned FOO-1 to Mallory Eve` (one line) |
| `AC-3-assign-ambiguous-newline` | `` jr issue assign FOO-9 --to $'Mallory\nEve' --no-input `` on BEFORE and AFTER | BEFORE: each duplicate's own line splits in two (`Mallory` / `Eve (email1,...)` then `Mallory` / `Eve (email2,...)`), the two candidates visually indistinguishable. AFTER: each duplicate stays on exactly one line — `Mallory Eve (mallory1@example.invalid, account: acc-mallory-1)` and `Mallory Eve (mallory2@example.invalid, account: acc-mallory-2)`, distinguishable by email/account |
| `AC-4-user-list-color-gate` | `jr user list --project FOO`; `NO_COLOR=1 jr user list --project FOO`; same two piped through `grep Bob \| cat -v` | Real pty (VHS): Active column ✓/✗ render in color by default. `NO_COLOR=1` suppresses it. `cat -v` on Bob's row shows raw `^[[38;5;9m`/`^[[39m`-class escape markers around the ✗ glyph with color, and zero escape markers with `NO_COLOR=1` — confirmed by `grep -c $'\x1b'` during manual verification (2 vs 0) |

## EC/item → demo → verdict

| EC / item (BC-7.1.006 v2.5.6) | Demo | What it shows | Verdict |
|---|---|---|---|
| EC-17a (comment-view Author field, single-line sanitize) | AC-1 | fake `Restricted: None` line before the fix; single `Author: Eve Restricted: None` line, real Restricted field unaffected, after | PASS |
| EC-17b (assign success message, single-match, single-line sanitize) | AC-2 | two-line split before; one line `Assigned FOO-1 to Mallory Eve` after | PASS |
| EC-17 (disambiguate_user ExactMultiple, each candidate stays on one line) | AC-3 | candidates visually merge before; each candidate its own, email/account-distinguishable line after | PASS |
| CR-2 (structural color gate, `render_table_with_styles`) | AC-4 | color present under real pty by default, suppressed under `NO_COLOR=1`, proven via raw escape-byte presence/absence through `cat -v` | PASS |
| Body block stays multi-line (`sanitize_terminal_text`, not rewired) | AC-1 (implicit — body block prints normally on both sides) | comment body block renders identically before/after; only the six labeled fields changed sanitizer | PASS (not separately isolated — covered by `src/output.rs`'s own unit/property tests pinning `sanitize_terminal_text` vs `sanitize_terminal_line`'s divergent `\n` handling) |

## Before vs. after — explicit comparison

All three single-line scenarios (AC-1, AC-2, AC-3) record the SAME command against the SAME mock
fixture twice: first against `develop` tip `769365ab` (pre-`FIX-P5-002`, built in a separate
temporary worktree), then against this fix's binary — an explicit, recorded BEFORE/AFTER pair
per scenario, not a described fallback. AC-4 (CR-2) records only the AFTER binary — CR-2 is a new
gate inside `render_table_with_styles` itself, and `active_cell`'s pre-existing caller-side
`SHOULD_COLORIZE` check already produced the identical end-user-visible behavior before this fix
(confirmed in `CHANGELOG.md`'s "End-user-visible behavior for `active_cell` ... is unchanged by
this gate" note) — there is no observable BEFORE/AFTER delta to record for the one caller that
exists today; the gate's value is structural (future `StyledCell` callers get the guarantee
automatically).

## Reproduction

```bash
cd .worktrees/FIX-P5-002
cargo build
python3 docs/demo-evidence/FIX-P5-002/mock_server.py 8794 /tmp/jr-demo-fixp5-002.log &
source docs/demo-evidence/FIX-P5-002/setup.sh /tmp/jr-demo-fixp5-002-cache /tmp/jr-demo-fixp5-002.log
jr issue comment view FOO-1 --id 9001
jr issue assign FOO-1 --to Mallory --no-input
jr issue assign FOO-9 --to $'Mallory\nEve' --no-input
jr user list --project FOO
NO_COLOR=1 jr user list --project FOO
kill %1  # stop the mock server
```

To reproduce the BEFORE/AFTER comparison: build `develop` tip `769365ab` in a separate worktree
(`git worktree add <path> 769365ab && cd <path> && cargo build`), point `PATH` at that binary's
`target/debug` instead (pass `before` as `setup.sh`'s third argument), and re-run the
`comment view`/`assign` commands above against the same mock server.

## VHS quirks encountered (for future demo-recorder reference)

- A literal `\n` that must survive into the shell as an ANSI-C-quoted `$'...'` argument (AC-3)
  requires backtick-delimited `Type` — a double-quoted `Type "..."` would have Go's own string
  escape processing interpret `\n` before it ever reaches bash, corrupting the keystroke stream.
  Confirmed by inspecting the VHS-echoed command in the recording: it shows the literal
  characters `$'Mallory\nEve'`, which bash then expands into a real newline at parse time — not
  VHS/Go injecting one directly.
- `Wait+Screen` (not `Wait+Line`) used throughout, matching the FIX-P5-001 precedent.
- Piping through `grep <name> | cat -v` (grep BEFORE cat -v) rather than the reverse order
  avoids the wide-table/three-stage-pipe `cat -v` reliability issue the FIX-P5-001 precedent
  documented.

## Cleanup performed

- Mock server process killed (`pkill -f "mock_server.py 8794"`; confirmed via `ps aux` no longer
  listing it).
- Temporary `before-develop` worktree removed via `git worktree remove` (confirmed absent from
  `git worktree list`).
- All `/tmp/jr-demo-fixp5-002*` cache/log/scratch files deleted.
- Confirmed via `git status --short` (clean) and `git status --ignored --short`
  (`!! docs/demo-evidence/`) that nothing under `docs/demo-evidence/` is tracked or staged, in
  this worktree or the main checkout.
