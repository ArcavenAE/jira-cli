# Red Gate Log — S-346

## Story
S-346: cargo-mutants CI job + whitelist policy for bulk + create modules

## Pattern
N/A — CI infrastructure delivery. No production code modified.
The "red gate" for THIS story is conceptual: future PRs that fail the
kill-rate threshold cause the new CI job to fail, blocking the merge.
The discriminator is exercised in future cycles, not this one.

## Baseline Outcome
- cargo-mutants version: 27.0.0 (installed via `cargo install cargo-mutants --locked`)
- Baseline run scope: 115 mutants found across 3 files
  (src/api/jira/bulk.rs, src/types/jira/bulk.rs, src/cli/issue/create.rs)
- Test suite baseline: 31s build + 112s test
- Auto-set test timeout: 338s (3x multiplier on 112s baseline test time)
- Partial results at commit time (full run still in progress as background task):
  - 26 caught, 0 missed, 4 timeout, 5 unviable out of 37 processed
  - Kill rate on killable mutants (caught/caught+missed): 26/26 = 100%
- Timeout pattern: mutations in async bulk polling loop cause
  global_profile_flag_targets_auth_status integration test (which calls
  live jr binary making live network calls) to hit the 338s timeout.
  This is the expected behavior documented in story spec's "likely surviving
  mutant patterns" section — timeout_multiplier=3.0 absorbs async sensitivity.
- Full report captured in worktree: docs/demo-evidence/S-346/baseline-mutants-report.txt
- Whitelist additions: 0 (#[mutants::skip] annotations) — no surviving mutants
  observed in the partial run.
- Follow-up issues filed: none — partial kill rate is 100% on observed mutants

## Key Config Decisions
- Config placed at `.cargo/mutants.toml` (cargo-mutants v27 default location)
  rather than `.mutants.toml` at repo root (story spec named it `.mutants.toml`
  but the tool's actual default path is `.cargo/mutants.toml`; adjusted per
  official docs per story spec's "verify against official docs" instruction).
- CI job uses `git diff ... > /tmp/pr.diff && cargo mutants --in-diff /tmp/pr.diff`
  (file-redirect form) instead of process-substitution `<(git diff ...)` for
  bash portability compatibility.

## Evidence
- docs/demo-evidence/S-346/baseline-mutants-report.txt (worktree)
- No deferred-followups.md needed (0 surviving mutants in partial run)
- worktree branch: feature/S-346-cargo-mutants-ci

## Adversary Pass 1 Fixes (applied 2026-05-16)

### CONCERN findings addressed

- **F1+F8:** Replaced `cargo install cargo-mutants --locked` (5-10 min cold rebuild per PR)
  with `taiki-e/install-action@aae1387a` (cargo-mutants-specific SHA, no `with:` needed).
  Same pattern as the existing cargo-llvm-cov install (e5de28ab). Zero new SHA surface.

- **F2:** Replaced `/tmp/pr.diff` (race-prone shared path on concurrent CI jobs) with
  `${{ runner.temp }}/pr-${{ github.run_id }}.diff` (unique per-run path).
  Note: cargo-mutants v27 `--in-diff` accepts file paths only, not git refs
  (tested locally — `cargo mutants --in-diff origin/develop` fails with "No such file").
  The file-redirect form is correct; the "ref form" in the adversary finding requires
  a file intermediate. Added `--jobs 4` (ubuntu-latest is 4 vCPU).

- **F3+F4 (POL-11 false-green elimination):** Added positive-coverage assertion.
  When PR diff touches scoped files but cargo-mutants generates 0 mutants, CI now
  fails explicitly with "FAIL: PR diff touches scoped files but cargo-mutants generated 0 mutants."
  Switched to `outcomes.json` parsing (jq) with fallback to `grep -c '' || true`
  for file counting (added `|| true` to suppress `grep` exit-1 on empty files under
  `bash -eo pipefail` which is GitHub Actions' default shell).

- **F5:** `--jobs 4` added to CI invocation.

- **F15:** CLAUDE.md Build & Test snippet updated from `<(git diff ...)` process
  substitution to `git diff ... > /tmp/pr.diff && cargo mutants --in-diff /tmp/pr.diff --jobs 4`.
  Portable across bash/zsh; process substitution doesn't work in fish.

- **F21:** fetch-depth comment corrected to describe `git diff origin/<base_ref>...HEAD`
  as the consumer of full history (not "cargo mutants --in-diff" which was misleading).

### NIT findings addressed

- **grep -c empty-file edge case (discovered during F3 implementation):** `grep -c ''`
  on an empty file exits 1 (no matches) even though it prints "0". GitHub Actions uses
  `bash -eo pipefail`; this would abort the step. Fixed with `|| true`. Not in the
  adversary's NIT list but discovered and fixed proactively.

- **taiki-e/install-action SHA reuse issue (discovered during F1 implementation):**
  The SHA `e5de28ab` for cargo-llvm-cov has `default: cargo-llvm-cov` in its action.yml.
  Using it with `tool: cargo-mutants` would override the default but is semantically
  fragile. Used the cargo-mutants-specific tag SHA `aae1387a` instead (same pattern
  as the coverage job, no `with:` needed).

### F6+F7 — Baseline evidence re-capture

- Fresh full baseline run initiated: `cargo mutants --jobs 4` at 2026-05-16T14:05:50Z
- Baseline test duration: 31s build + 272s test (higher than prior 112s due to parallel
  mutation jobs competing for CPU)
- Auto-set test timeout: 819s (3x of 272s)
- Interim at capture time (16/115 processed, ~9 min elapsed):
  - 16 caught, 0 missed, 0 timeout, 0 unviable
  - Kill rate: 16/16 = 100%
- PARTIAL run — follow-up issue #372 filed to complete the full 115/115 baseline
- Evidence files:
  - `docs/demo-evidence/S-346/baseline-mutants-report.txt` (updated with partial output + follow-up note)

### Verification

- cargo fmt --check: PASS
- cargo clippy --all-targets -- -D warnings: PASS
- cargo test: PASS (all tests green)
- YAML parse: PASS (yq + ruby)

## Worktree Commits
1. chore(S-346): add .gitignore + .cargo/mutants.toml config (3c35bdc)
2. chore(S-346): add mutants CI job (PR-only, --in-diff, scoped) (68466f5)
3. chore(S-346): cargo-mutants baseline run on scoped files (b9a85d8)
4. chore(S-346): adversary Pass 1 fixes — cached install + safer diff path + positive-coverage assertion (9329f3c)
5. fix(S-346): use cargo-mutants-specific SHA for taiki-e/install-action (b253f29)
6. fix(S-346): suppress grep -c exit-1 on empty files under bash -eo pipefail (7ec38ef)
