---
document_type: demo-evidence-notes
product: "jr — Jira CLI"
pipeline_run: "2026-09-02"
demo_type: "cli"
recording_tool: "vhs"
status: recorded
---

# Demo Evidence Report — S-cycle3-env-tag

## Product: jr — Jira CLI
## Pipeline Run: 2026-09-02
## Demo Type: cli

`ProfileConfig.env` tag surfaced in `auth list` (table + JSON) and `auth
status`. BCs: BC-6.1.015, BC-1.6.046, BC-1.6.047.

All recordings were captured with [VHS](https://github.com/charmbracelet/vhs)
v0.11.0 against the `feat/cycle3-env-tag` branch build (`cargo build`,
worktree `.worktrees/S-cycle3-env-tag`). No live Jira instance, network call,
or real developer credentials are involved — every command reads a
throwaway `config.toml` under a temp `JR_CONFIG_DIR`, with `JR_SERVICE_NAME`
set to an isolated value so no probe touches the real OS keychain. All
profile URLs in the fixtures are fake (`acme-corp*.atlassian.net`).

---

## Per-AC Demo Recordings

| AC | Story | Description | Recording | Format | Duration | Size | Status |
|----|-------|-------------|-----------|--------|----------|------|--------|
| AC-001/002/003 | S-cycle3-env-tag | `ProfileConfig.env` schema deserialization (`None` for absent key, `Some("")` distinct from `None`, round-trip proptest VP-AUTHDX-009) | *(not CLI-observable — see Notes)* | n/a | n/a | n/a | covered by `cargo test`, not demoed |
| AC-004 | S-cycle3-env-tag | `jr auth list` (table) prints headers `NAME, URL, ENV, AUTH, STATUS` — `ENV` is the new 5th column between `URL` and `AUTH` | [AC-004-005-auth-list-table-env-column.gif](./AC-004-005-auth-list-table-env-column.gif) | gif+webm | 5.9s | 84.5KB / 59.5KB | recorded |
| AC-005 | S-cycle3-env-tag | `ENV` cell: blank for `env = Some("")` (`staging`), `-` for `env = None` (`legacy`), value shown for `env = Some("prod")` (`prod`) | same recording as AC-004 (one table render exercises both) | gif+webm | 5.9s | (shared) | recorded |
| AC-006 | S-cycle3-env-tag | `ENV` cell strips ANSI CSI escapes (`\x1b[31m...\x1b[0m`) + raw CR/LF control bytes, and caps an over-length value (55 chars) with a `…` truncation marker at the 40-char cap | [AC-006-auth-list-table-hostile-env-sanitized.gif](./AC-006-auth-list-table-hostile-env-sanitized.gif) | gif+webm | 8.1s | 112.8KB / 75.7KB | recorded |
| AC-007 | S-cycle3-env-tag | `jr auth list --output json` includes `"env"` verbatim/lossless for every profile — raw escape/CR-LF bytes survive unmodified in JSON where the table (AC-006) strips them | [AC-007-auth-list-json-env-verbatim.gif](./AC-007-auth-list-json-env-verbatim.gif) | gif+webm | 7.2s | 112.3KB / 73.7KB | recorded |
| AC-008 | S-cycle3-env-tag | `jr auth status` prints an `Env:` line in human-text output, same sanitize + `-`/blank convention as AC-005/AC-006 | [AC-008-auth-status-env-line.gif](./AC-008-auth-status-env-line.gif) | gif+webm | 7.3s | 49.4KB / 33.6KB | recorded |

Each `.gif` has a matching `.webm` at the same base filename (see the
`demos/` directory listing), plus the `.tape` source script used to produce
it.

---

## Full User Journey Demo

N/A for this story. `S-cycle3-env-tag` is a narrow, additive display-layer
change (one new config field + two existing command outputs gaining a
column/line) with no new end-to-end user workflow to demo beyond the
per-AC recordings above — there is no "login → configure → use" journey
this story introduces.

---

## Holdout Scenario Demos

N/A. No holdout scenarios are anchored to this story (`holdout_anchors: []`
in the story frontmatter).

---

## Visual Review Summary

| Demo | AC | Visual Satisfaction | Findings | Regression? |
|------|-----|-------------------|----------|-------------|
| AC-004-005-auth-list-table-env-column | AC-004, AC-005 | Pass | 5-column header order and blank/`-` cell rendering confirmed via mid-gif frame extraction (`ffmpeg -ss ... -frames:v 1`) and manual visual review | No — additive column, existing 4 columns unchanged |
| AC-006-auth-list-table-hostile-env-sanitized | AC-006 | Pass | `cat -v` frame confirms real ESC/CR bytes on disk; table-render frame confirms `prodDANGERinjected` (stripped) and `xxxx…` (40-char cap + marker) — no raw control bytes, no literal `[31m` text | N/A (new behavior) |
| AC-007-auth-list-json-env-verbatim | AC-007 | Pass | JSON frame confirms `"env": "prod[31mDANGER[0m\r\ninjected"` verbatim, and the error-path frame confirms the JSON error envelope (`{"code":1,"error":"..."}`) is used consistently | N/A (new behavior) |
| AC-008-auth-status-env-line | AC-008 | Pass | Success frame confirms `Env:         prod` between `Instance:` and `Auth method:`; error frame confirms unknown-profile guard fires before any `Env:` line prints | No — existing status fields unchanged |

All four recordings were visually verified by extracting frames at multiple
timestamps with `ffmpeg` and inspecting them directly (not just trusting the
tape completed without a VHS error).

---

## Regression Comparison (Feature Mode)

N/A. This is the first `demo-recorder` pass for this story (no prior demo
evidence exists to diff against). The 5-column `auth list` table is a
documented breaking change to the existing insta-snapshot (see the story's
CHANGELOG task and BC-1.6.046 AMENDED status) but there is no prior *demo
recording* of the 4-column table in this repo to compare frame-by-frame.

---

## Success / Error Path Coverage

| Recording | Success path | Error / edge path |
|-----------|--------------|--------------------|
| AC-004-005 | 5-column table, `prod`/`staging`/`legacy` fixture (tagged/blank/absent `env`) | `env` set to a non-string TOML type (`env = 123`) fails deserialization loudly (`Error: invalid type: found signed int ...`), exit 1 — exercises the schema's tolerant-reader contract (AC-001) failing closed on a genuinely malformed value, rather than silently coercing |
| AC-006 | `hostile` (ANSI+CR/LF) and `longenv` (55-char) profiles both render sanitized in the table | *(no error path — BC-6.1.015 explicitly forbids a validator/allowlist on `env`; there is no rejection case for this AC, only the display-layer transform demonstrated in the success path)* |
| AC-007 | Same hostile fixture, `--output json` shows `env` byte-for-byte, including the raw escape/CR-LF sequences | Same malformed-TOML-type fixture as AC-004-005 error path, now under `--output json` — confirms the JSON error envelope is used consistently, per CLAUDE.md's JSON-for-errors-too convention |
| AC-008 | `jr auth status --profile prod` → `Env:         prod` line between `Instance:` and `Auth method:` | `jr auth status --profile nope` → exit 64, `Error: unknown profile: nope; known: legacy, prod, staging` (pre-existing strict-profile-lookup guard; no `Env:` line printed) |

## Note on AC-001/AC-002/AC-003

These three ACs describe `ProfileConfig`'s Rust-level deserialization behavior
(`env: None` for a pre-existing config with no `env` key; `env = ""`
deserializing distinctly from an absent key; a `proptest` round-trip
property). They are not independently observable as a *distinct* terminal
behavior beyond what AC-004's `legacy`/`staging`/`prod` fixture already
demonstrates externally (a profile with no `env` key renders `-`; a profile
with `env = ""` renders blank) — the schema-level guarantee itself (serde
derive behavior, proptest over arbitrary field combinations) is unit-test
territory, not CLI-demo territory. Flagged explicitly rather than silently
skipped: AC-001/002/003 are covered by `cargo test` (unit tests +
`proptest`), not by a VHS recording. AC-004's and AC-005's recordings are
the closest CLI-visible evidence of the same underlying schema behavior.

## Fixture Configs (not committed — throwaway, regenerable)

Three temp `config.toml` fixtures were used, all under `/tmp/jr-demo-envtag/`
(outside the repo, never touching `~/.config/jr/`):

- `fixture-normal/config.toml` — `prod` (`env = "prod"`), `staging`
  (`env = ""`), `legacy` (no `env` key). Used by AC-004-005 and AC-008's
  success path.
- `fixture-hostile/config.toml` — `hostile` (`env` containing an ANSI CSI
  sequence + raw CR/LF), `longenv` (`env` = 55 `x` chars, over the 40-char
  cap). Used by AC-006 and AC-007.
- `fixture-badtype/config.toml` — `bad` (`env = 123`, wrong TOML type). Used
  as the error path for AC-004-005 and AC-007.

Regenerate via the `Hide`-block `export JR_CONFIG_DIR=...` lines in each
`.tape` file — the fixture contents are also inlined as comments/`cat -v`
output inside the AC-006 recording itself.

---

## Toolchain

| Tool | Version | Status |
|------|---------|--------|
| VHS | 0.11.0 | installed (`/opt/homebrew/bin/vhs`), used for all 4 recordings |
| ffmpeg | (system) | used only for local screenshot-based tape verification, not part of the deliverable |
| Playwright | n/a | not applicable — CLI product |

VHS was available and used for every recording — no text/asciinema fallback
was needed.

---

## PR Embedding Snippet

```markdown
### Demo Evidence — S-cycle3-env-tag

| AC | Behavior | Demo |
|----|----------|------|
| AC-004/005 | `auth list` table gains `ENV` column (blank/`-`/value) | ![auth list env column](.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-004-005-auth-list-table-env-column.gif) |
| AC-006 | `ENV` cell sanitizes ANSI/control chars + caps length | ![hostile env sanitized](.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-006-auth-list-table-hostile-env-sanitized.gif) |
| AC-007 | `auth list --output json` echoes `env` verbatim | ![json env verbatim](.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-007-auth-list-json-env-verbatim.gif) |
| AC-008 | `auth status` prints `Env:` line | ![auth status env line](.factory/cycles/cycle-003/code-delivery/S-cycle3-env-tag/demos/AC-008-auth-status-env-line.gif) |
```

---

## Notes

- Each tape uses a fixed `Sleep` (1.2–1.5s) after each command instead of
  `Wait+Line /pattern/`. This is a deliberate, verified deviation from the
  usual "wait for actual completion" guidance: `Wait+Line` matches against
  VHS's *last rendered terminal line*, and for every command here that line
  is a fresh, empty shell prompt immediately following the real output
  (there is no spinner or async completion signal to wait on — `auth
  list`/`auth status` are synchronous local-file reads with no network
  I/O). In this VHS 0.11.0 / `bash` combination, `Wait+Line` against the
  command's actual output text timed out reliably (reproduced across
  `AC-004`, `AC-006`, `AC-007`, `AC-008` before the fix). Each tape's
  `Sleep` duration was verified sufficient by extracting mid-gif frames
  with `ffmpeg -ss ... -frames:v 1` and visually confirming the command had
  fully completed and rendered before the `Sleep` elapsed.
- WebM is the archival format; GIF is the PR-embeddable format. Both are
  produced for every recording.
- No file under `src/`, `tests/`, or any existing spec/story file was
  modified by this recording pass — only new files were added under this
  `demos/` directory (4 `.tape` scripts, 4 `.gif`, 4 `.webm`, this
  `README.md`).
