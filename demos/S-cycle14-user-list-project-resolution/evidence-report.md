# Demo Evidence — S-cycle14-user-list-project-resolution: `jr user list --project` resolution order (#862)

Story: `S-cycle14-user-list-project-resolution` (cycle-014, STORY-A) — `jr user list --project`
resolution order: local > global > configured default > exit 64 (issue #862). BC: BC-X.7.002
(amended, cycle-014 F2). 11 acceptance criteria; Step 4.5 adversarial convergence complete
(passes 3-5 CLEAN_NITPICK_ONLY at HEAD `8b113241`).

## Tool used

**VHS** (terminal recording), version 0.11.0 (`/opt/homebrew/bin/vhs`, installed via
`brew install vhs` — already present in this environment). Every recording produces a matched
`.gif` (PR-embed) + `.webm` (archival) pair plus its `.tape` source, per the CLI recording
convention.

## No real Jira data or network used — confirmation

- Every recording runs the actual worktree debug binary (`cargo build`, `target/debug/jr`,
  version `0.8.0-dev.1`) — **not** the machine's separately-installed `~/.local/bin/jr`
  (`0.7.0-dev.6`, which still has the pre-fix bug; verified explicitly, see "Gotcha avoided"
  below). `setup.sh` prepends `$PWD/target/debug` onto `PATH`.
- `JR_BASE_URL` points at `http://127.0.0.1:8791`, a local Python stdlib
  `http.server`-based mock (`mock_user_search_server.py`) serving only
  `GET /rest/api/3/user/assignable/multiProjectSearch` with synthetic data. **No real Jira
  instance, cloud ID, or org is ever contacted.**
- `JR_AUTH_HEADER='Basic ZmFrZTpmYWtl'` (base64 `fake:fake`) bypasses keychain credential
  loading entirely — no OS keychain/Credential Manager entry is read or written.
- `JR_CONFIG_DIR`/`JR_CACHE_DIR` point at fresh `mktemp -d` directories per recording — the
  real `~/.config/jr` and `~/.cache/jr` are never touched.
- Every ambient `JR_*`-prefixed environment variable is scrubbed (via a `for`/`unset` loop in
  `setup.sh`) before any seam is set, so a stray developer/CI `JR_*` value cannot leak into a
  recording.
- All account IDs (`fake-acct-...`) and display names ("Alice Example", "Bob Example") are
  synthetic. All project keys used (`FOO`, `BAR`, `BAZ`, `GLOBAL`, `LOCAL`, `PAG`, and the
  empty string) are placeholders, matching this story's own test-fixture convention
  (`tests/user_list_project_resolution.rs`).
- The fake instance URL in every config fixture is `https://example.atlassian.net` (never used
  for actual requests — `JR_BASE_URL` overrides it for every outbound call, per the
  `JR_BASE_URL` debug-seam documented in CLAUDE.md's AI Agent Notes table).

**Gotcha avoided:** this machine has a real, separately-installed `jr` at `~/.local/bin/jr`
(`0.7.0-dev.6`) which still exhibits the pre-fix bug (`jr --project FOO user list` exits 2,
verified directly before recording). `setup.sh` prepending `$PWD/target/debug` (this worktree's
freshly built binary) onto `PATH` is load-bearing — without it, several of these recordings
would have silently exercised the wrong binary.

## Scope note

All 11 ACs are covered below. AC-001/AC-005/AC-006's argv-level clap-propagation assertions are
authoritatively proven by the story's own inline unit test
(`src/cli/mod.rs::tests::test_bc_x_7_002_user_list_project_clap_propagation`) and the
`proptest!` block on `resolve_user_list_project` (`src/cli/user.rs`); the recordings below are
the end-to-end, real-binary corroboration against a live (mocked) HTTP round-trip — not a
substitute for those unit/property tests, which remain the primary evidence per the story's own
Red Gate classification. AC-010 (README wording) and AC-011 (mutants policy/examine_globs
bookkeeping) are doc/config-only per the story itself ("Test: N/A") — no recording applies to
either; see `AC-010.md`/`AC-011.md`.

## Recordings

| Recording | Command demonstrated | Result |
|---|---|---|
| `AC-001-local-project.{gif,webm}` | `jr user list --project FOO --no-input` | exit 0; table shows `[project=FOO]` — local flag alone resolves |
| `AC-002-global-project.{gif,webm}` | `jr --project FOO user list --no-input` | exit 0; table shows `[project=FOO]` — the #862 bug itself, previously clap exit 2 |
| `AC-003-jrtoml-default.{gif,webm}` | `cat .jr.toml` then `jr user list --no-input` | exit 0; table shows `[project=BAR]` — `.jr.toml` configured-default fallback |
| `AC-003-AC-009-profile-default.{gif,webm}` | `jr --profile alt user list --no-input` | exit 0; table shows `[project=BAZ]` — non-default profile's own configured default, no reload |
| `AC-004-exit64-table.{gif,webm}` | `jr user list --no-input` + `echo EXIT_CODE=$?` | stderr pinned message, `EXIT_CODE=64`, table mode |
| `AC-004-exit64-json.{gif,webm}` | `jr --output json user list --no-input` + `echo EXIT_CODE=$?` | stdout pinned `{"code":64,"error":"..."}` envelope, `EXIT_CODE=64` |
| `AC-005-local-wins-over-global.{gif,webm}` | `jr --project GLOBAL user list --project LOCAL --no-input` | exit 0; table shows `[project=LOCAL]` — local wins over global |
| `AC-006-empty-string-passthrough.{gif,webm}` | `jr user list --project "" --no-input` | exit 0; table shows `[project=]` — empty string passes through, ignores configured default `PAG` |
| `AC-007-all-pagination.{gif,webm}` | `jr user list --all --no-input` | exit 0; table shows `[project=PAG page1]` — configured default applied to `--all` pagination |
| `AC-008-help-text.{gif,webm}` | `jr user list --help` | exit 0; pinned help substrings visible for `--project` |

Supporting files in this directory:
- `*.tape` — VHS scripts (source of truth for each recording; re-run with `vhs <file>.tape`
  from the worktree root — see "Reproducing" below)
- `setup.sh` — shared hidden setup (ambient `JR_*` scrub, fresh fake profile + cache + cwd,
  `JR_AUTH_HEADER`, `JR_BASE_URL`, `PATH`) sourced inside each tape's `Hide` block
- `fixtures/config-no-project.toml` — single `default` profile, no configured project
- `fixtures/config-alt-profile.toml` — two profiles: `default` (no project), `alt` (`project = "BAZ"`)
- `fixtures/config-default-project.toml` — single `default` profile, `project = "PAG"`
- `mock_user_search_server.py` — minimal GET-only mock serving
  `GET /rest/api/3/user/assignable/multiProjectSearch`, echoing the resolved `projectKeys`
  value into each fake user's display name, and supporting the two-page `--all` pagination
  fixture (empty page at `startAt>=100`)

### Reproducing the recordings

This evidence now lives on `factory-artifacts` at
`.factory/demos/S-cycle14-user-list-project-resolution/` (see the Note below), not inside a
product-repo worktree — but every `.tape` file's internal `Output`/`Hide`/`Type` lines still
hardcode the original relative path
(`docs/demo-evidence/S-cycle14-user-list-project-resolution/...`), because `vhs` resolves those
paths relative to the shell's cwd at recording time. To reproduce, stage this directory back
under that same relative path inside a fresh checkout of the feature branch (`fix/user-list-
project-resolution` at `8b113241`) before invoking `vhs`:

```bash
git worktree add /tmp/jr-demo-repro fix/user-list-project-resolution
cd /tmp/jr-demo-repro
cargo build
mkdir -p docs/demo-evidence
cp -R /path/to/.factory/demos/S-cycle14-user-list-project-resolution docs/demo-evidence/
python3 docs/demo-evidence/S-cycle14-user-list-project-resolution/mock_user_search_server.py 8791 &
for t in docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-*.tape; do
  vhs "$t"
done
kill %1
```

## AC -> Evidence mapping

| AC | Summary | Evidence | Verdict |
|---|---|---|---|
| AC-001 | Local `--project` alone resolves (type change `String` -> `Option<String>`) | `AC-001.md`; recording `AC-001-local-project.{gif,webm}`; unit test `src/cli/mod.rs::tests::test_bc_x_7_002_user_list_project_clap_propagation` | PASS |
| AC-002 | Global `--project` only resolves (issue #862 itself) | `AC-002.md`; recording `AC-002-global-project.{gif,webm}`; hermetic test `tests/user_list_project_resolution.rs::test_bc_x_7_002_ec2_global_project_only_resolves` | PASS |
| AC-003 | Configured default fallback (`.jr.toml` + profile) via `resolve_user_list_project` | `AC-003.md`; recordings `AC-003-jrtoml-default.{gif,webm}`, `AC-003-AC-009-profile-default.{gif,webm}`; `proptest!` in `src/cli/user.rs`; hermetic tests in `tests/user_list_project_resolution.rs` | PASS |
| AC-004 | No project resolvable -> exit 64, pinned message, zero HTTP | `AC-004.md`; recordings `AC-004-exit64-table.{gif,webm}`, `AC-004-exit64-json.{gif,webm}`; `tests/user_commands.rs::user_list_requires_project_flag` + new EC-4 hermetic cell | PASS |
| AC-005 | Local wins over global when both supplied | `AC-005.md`; recording `AC-005-local-wins-over-global.{gif,webm}`; argv cell in the AC-001 inline test; hermetic cell in `tests/user_list_project_resolution.rs` | PASS |
| AC-006 | Empty string `--project ""` passes through, ignores configured default (D-380) | `AC-006.md`; recording `AC-006-empty-string-passthrough.{gif,webm}`; argv cells in the AC-001 inline test; `proptest!` cell; hermetic cell in `tests/user_list_project_resolution.rs` | PASS |
| AC-007 | Resolved key applied to every `--all` page | `AC-007.md`; recording `AC-007-all-pagination.{gif,webm}`; two `#[tokio::test]` functions in `tests/user_pagination.rs` | PASS |
| AC-008 | Pinned `--help` text | `AC-008.md`; recording `AC-008-help-text.{gif,webm}`; `--help` test in `tests/user_list_project_resolution.rs` | PASS |
| AC-009 | `&Config` threaded without reload; non-default `--profile` resolves correctly | `AC-009.md`; shares recording `AC-003-AC-009-profile-default.{gif,webm}` with AC-003; same hermetic `#[tokio::test]` in `tests/user_list_project_resolution.rs` | PASS |
| AC-010 | `README.md` wording update (`--project` now optional) | `AC-010.md` — doc artifact, no recording; verified at PR review | N/A (doc) |
| AC-011 | `.cargo/mutants.toml` / `docs/specs/cargo-mutants-policy.md` bookkeeping | `AC-011.md` — config/doc artifact, no recording; verified by `tests/mutants_glob_existence.rs` + `scripts/check-cargo-mutants-policy-citations.sh` | N/A (config/doc) |

## Cleanup performed

- Mock server process (`mock_user_search_server.py`, port 8791) killed after all recordings
  completed.
- All `mktemp -d` scratch directories created by `setup.sh` during recording, plus the
  scratchpad smoke-test directories used to validate each scenario before recording, were
  temporary and are not part of this commit.
- No files were written outside `docs/demo-evidence/S-cycle14-user-list-project-resolution/`
  in this worktree.

## Note on `docs/demo-evidence/` and `.gitignore`

`docs/demo-evidence/` is listed in this repo's `.gitignore` (added by PR #708, "purge
demo-evidence from product repo; gitignore docs/demo-evidence (relocate to factory-artifacts)").
Per PR #708's policy, this evidence was **not** committed to the product branch — it was
generated untracked inside the feature worktree and has since been relocated to the
`factory-artifacts` branch at
`.factory/demos/S-cycle14-user-list-project-resolution/`, where it now lives permanently
(this copy). The product-branch worktree copy remains gitignored and untracked, exactly as
PR #708 intends.
