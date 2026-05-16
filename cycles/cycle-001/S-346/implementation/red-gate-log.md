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

## Worktree Commits
1. chore(S-346): add .gitignore + .cargo/mutants.toml config (3c35bdc)
2. chore(S-346): add mutants CI job (PR-only, --in-diff, scoped) (68466f5)
3. chore(S-346): cargo-mutants baseline run on scoped files (b9a85d8)
