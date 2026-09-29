# Demo Evidence — S-cycle14-api-query-param: `jr api --query-param`/`-q NAME=VALUE` (#583)

Story: `S-cycle14-api-query-param` (cycle-014, STORY-C) — percent-encoded query-string assembly
and its malformed-value error taxonomy for `jr api`. BCs: BC-X.16.001 (assembly/merge algorithm),
BC-X.16.002 (error taxonomy). 11 acceptance criteria; Step 4.5 adversarial convergence complete
(passes 2, 3, 4 CLEAN_NITPICK_ONLY at HEAD `bae338fe`).

## Tool used

**VHS** (terminal recording), version 0.11.0 (`/opt/homebrew/bin/vhs`, already present in this
environment). Every recording produces a matched `.gif` (PR-embed) + `.webm` (archival) pair plus
its `.tape` source, per the CLI recording convention.

## Gotcha found and fixed during this recording session

Every tape initially used `Wait+Line /pattern/` to detect command completion (the documented VHS
best practice: "prefer `Wait+Line` over `Sleep`"). All 20 tapes timed out identically —
`Wait+Line` restricts matching to the terminal's CURRENT LAST LINE only. Because every command in
this story (a local `jr` binary hitting a local mock server) completes and returns to a fresh
prompt in well under a video frame's worth of time, the output line has already scrolled off the
"last line" position by the time VHS's polling loop samples it — the last line sampled is always
the just-returned empty prompt, never the command's own output line. Root-caused by extracting a
mid-recording frame from a diagnostic tape (`ffmpeg` frame-grab) and visually confirming the
command's output WAS present on screen, just not on the last line at sample time. Fix: every
`Wait+Line` was replaced with `Wait+Screen` (matches anywhere in the currently-visible terminal
screen, not just the last line) — verified with a standalone diagnostic tape before re-running the
full batch. All 20 `.tape` files in this directory use `Wait+Screen`, not `Wait+Line`.

## No real Jira data or network used — confirmation

- Every recording runs the actual worktree debug binary (`cargo build`, `target/debug/jr`,
  version `0.8.0-dev.1`). `setup.sh` prepends `$PWD/target/debug` onto `PATH` before every
  recording, so the machine's separately-installed `~/.local/bin/jr` is never exercised.
- `JR_BASE_URL` points at `http://127.0.0.1:8792`, a local Python stdlib `http.server`-based mock
  (`mock_query_echo_server.py`) that echoes back the exact path/query/method/body it received as
  pretty JSON, plus logs one line per request to a file so a recording can prove a pre-flight
  error made ZERO HTTP calls. **No real Jira instance, cloud ID, or org is ever contacted.**
- `JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'` (base64 `fake:fake`) bypasses keychain credential loading
  entirely — no OS keychain/Credential Manager entry is read or written.
- `JR_CONFIG_DIR`/`JR_CACHE_DIR` point at fresh `mktemp -d` directories per recording — the real
  `~/.config/jr` and `~/.cache/jr` are never touched.
- Every ambient `JR_*`-prefixed environment variable is scrubbed (via a `for`/`unset` loop in
  `setup.sh`) before any seam is set, so a stray developer/CI `JR_*` value cannot leak into a
  recording.
- The fake instance URL in the config fixture is `https://example.atlassian.net` (never used for
  actual requests — `JR_BASE_URL` overrides it for every outbound call, per the `JR_BASE_URL`
  debug-seam documented in CLAUDE.md's AI Agent Notes table). No real project keys, account IDs,
  or emails appear anywhere — every path/query/body value used is a synthetic placeholder (`FOO`,
  `demo@example.invalid`, `Alice`/`café` as ordinary ASCII/Unicode test strings, not real data).

## Scope note

This story's `cwd` is deliberately left at the repo root (unlike the sibling
`S-cycle14-user-list-project-resolution` story's `setup.sh`, which `cd`s into a fresh throwaway
directory for its own `.jr.toml`-resolution concern) — this story is about query-string assembly,
not project-default resolution, and every `Type` command below references a helper script
(`show_query_raw.py`) by its repo-relative `docs/demo-evidence/...` path, which must keep
resolving after `source`-ing `setup.sh`.

## Recordings

| Recording | Command demonstrated | Result |
|---|---|---|
| `AC-001-fresh-query` | `jr api ... -q jql='project = FOO ORDER BY created' -q maxResults=5` | percent-encoded query visible (space→%20, `=`→%3D) |
| `AC-001-merge-existing-query` | `jr api '/x?a=1' -q b=2` | `?a=1&b=2` |
| `AC-001-bare-terminators` | `?`-terminated and `&`-terminated paths | no extra separator inserted |
| `AC-001-fragment` | `jr api '/s#f' -q k=v` | query inserted before `#f`; fragment never reaches the server |
| `AC-001-literal-qmark-in-value` | `/s?jql=why?` + `-q k=v` | `&`-joined, not mistaken for empty-query |
| `AC-001-no-dedup-collision` | `/s?fields=summary` + `-q fields=status` | both sent, no dedup/override |
| `AC-002-repeated-names-and-comma` | `-q fields=summary -q fields=status`; `-q 'fields=summary,status'` | repeated names both sent; comma never splits |
| `AC-003-special-chars` | `-q 'glob=*' -q 'pct=%' -q 'plus=+' -q 'summary=café'` | `%2A`/`%25`/`%2B`/`%C3%A9` |
| `AC-003-no-trim-whitespace` | `-q ' =v' -q 'k= v '` | whitespace-only NAME allowed; VALUE whitespace preserved |
| `AC-003-help-text` | `jr api --help \| grep -i pre-encode` | pinned substring present |
| `AC-004-post-with-body-and-query` | `-X POST -d '{...}' -q notifyUsers=false` | query and body both independently present |
| `AC-004-zero-flag-unchanged` | `jr api /rest/api/3/myself` (no `-q`) | `query_raw` empty, unchanged behavior |
| `AC-005-m1-error-table-and-json` | `-q novalue` table + `--output json`, `echo $?` | exit 64 both modes; mock log stays 0 lines |
| `AC-005-empty-value-allowed` | `-q k=` | exit 0, `k=` sent as-is (contrast with M1) |
| `AC-006-m2-error` | `-q '=v'` | exit 64, distinct M2 message, zero HTTP |
| `AC-007-all-or-nothing` | `-q good=1 -q bad` | exit 64, zero HTTP (the well-formed pair never sent) |
| `AC-008-preflight-before-blocking-stdin` | `-d @- -q bad` with a held-open stdin FIFO | returns instantly, exit 64 — never blocks on stdin |
| `AC-009-attached-equals-forms` | `-q=v`, `-q==v`, `--query-param==v` | M1/M2/M2 per clap's attached-value stripping |
| `AC-009-clap-level-errors` | `-q -x=1`, `-q` (last token) | clap exit 2, never reaching `parse_query_param` |
| `AC-009-empty-raw-value-forms` | `-q ''`, `-q=`, `--query-param=` | all M1 (raw="", not missing) |

## AC → Evidence mapping

| AC | Summary | Evidence | Verdict |
|---|---|---|---|
| AC-001 | Query-string detection/merge algorithm (Behavior 1, Postcondition 2) | `AC-001.md`; 6 recordings `AC-001-*.{gif,webm}`; inline unit/property tests in `src/cli/api.rs` | PASS |
| AC-002 | Repeated same-name params; comma-in-VALUE never splits (Behavior 2, Postcondition 4) | `AC-002.md`; recording `AC-002-repeated-names-and-comma.{gif,webm}` | PASS |
| AC-003 | Encode-exactly-once; no-trim design default; pinned `--help` text (Behavior 3) | `AC-003.md`; recordings `AC-003-special-chars`, `AC-003-no-trim-whitespace`, `AC-003-help-text` | PASS |
| AC-004 | Method-orthogonal; zero-effect when absent (Behavior 4/5, Postconditions 1/5) | `AC-004.md`; recordings `AC-004-post-with-body-and-query`, `AC-004-zero-flag-unchanged` | PASS |
| AC-005 | `parse_query_param` M1 (no `=`); contrast with allowed empty-VALUE | `AC-005.md`; recordings `AC-005-m1-error-table-and-json`, `AC-005-empty-value-allowed` | PASS |
| AC-006 | `parse_query_param` M2 (empty NAME), distinct message | `AC-006.md`; recording `AC-006-m2-error` | PASS |
| AC-007 | All-or-nothing; first-malformed-in-flag-order reported | `AC-007.md`; recording `AC-007-all-or-nothing` | PASS |
| AC-008 | Pre-flight ordering before blocking `-d @-` stdin read | `AC-008.md`; recording `AC-008-preflight-before-blocking-stdin` | PASS |
| AC-009 | clap attached-value parsing / argument-level edge cases | `AC-009.md`; recordings `AC-009-attached-equals-forms`, `AC-009-clap-level-errors`, `AC-009-empty-raw-value-forms` | PASS |
| AC-010 | README/CHANGELOG doc trace obligation | `AC-010.md` — doc artifact, no recording; verified at PR review | N/A (doc) |
| AC-011 | `.cargo/mutants.toml` / `docs/specs/cargo-mutants-policy.md` bookkeeping | `AC-011.md` — config/doc artifact, no recording; verified by `tests/mutants_glob_existence.rs` + `scripts/check-cargo-mutants-policy-citations.sh` | N/A (config/doc) |

## Cleanup performed

- Mock server process (`mock_query_echo_server.py`, port 8792) killed after all recordings
  completed.
- All `mktemp -d` scratch directories created by `setup.sh` during recording, plus diagnostic
  tapes/GIFs used to root-cause the `Wait+Line`/`Wait+Screen` issue, were temporary and removed;
  none are part of this evidence set.
- No files were written outside `docs/demo-evidence/S-cycle14-api-query-param/` in this worktree.

## Reproducing the recordings

This evidence now lives on `factory-artifacts` at `.factory/demos/S-cycle14-api-query-param/`
(see the Note below), not inside a product-repo worktree. Every `.tape` file's `Type` lines
reference paths relative to the repo root (e.g.
`docs/demo-evidence/S-cycle14-api-query-param/show_query_raw.py`), and `setup.sh` deliberately
does NOT `cd` away from the repo root, so `vhs` must be invoked from the repo root:

```bash
git worktree add /tmp/jr-demo-repro feat/api-query-param
cd /tmp/jr-demo-repro
cargo build
mkdir -p docs/demo-evidence
cp -R /path/to/.factory/demos/S-cycle14-api-query-param docs/demo-evidence/
python3 docs/demo-evidence/S-cycle14-api-query-param/mock_query_echo_server.py 8792 /tmp/mock-requests.log &
for t in docs/demo-evidence/S-cycle14-api-query-param/*.tape; do
  vhs "$t"
done
kill %1
```

## Note on `docs/demo-evidence/` and `.gitignore`

`docs/demo-evidence/` is listed in this repo's `.gitignore` (added by PR #708, "purge
demo-evidence from product repo; gitignore docs/demo-evidence (relocate to factory-artifacts)").
Per PR #708's policy, this evidence was **not** committed to the product branch — it was
generated untracked inside the feature worktree and will be relocated to the `factory-artifacts`
branch at `.factory/demos/S-cycle14-api-query-param/`, where it will live permanently. The
product-branch worktree copy remains gitignored and untracked, exactly as PR #708 intends.
