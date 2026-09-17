# PR Review — #824

- **PR**: #824 (Zious11/jira-cli)
- **Branch**: `ci/mutants-nightly-opt-in-landed` → `develop`
- **Head commit**: `29409bf6` (git author preserved as Michael Pursifull <mike@arcaven.com>, Co-authored-by trailer; supersedes external PR #817)
- **Reviewer**: pr-reviewer-824 (fresh-context)
- **Date**: 2026-09-16
- **Verdict**: **APPROVE** — no blocking findings

## Scope

Docs + CI-gate change, exactly 4 files (verified via `gh pr diff 824 --name-only`):
`.github/workflows/mutants-nightly.yml`, `CHANGELOG.md`, `CLAUDE.md`,
`docs/specs/fork-friendly-release-ops.md`. Maintainer-owned re-application of external PR
#817 (org-owned fork blocked maintainer-edit pushes), with the CHANGELOG entry manually
relocated to `[Unreleased]`. Closes #816.

## Verification — against the actual diff, not the author's claims

Confirmed independently via `gh pr diff 824` / `gh pr view 824`:

1. **Exactly 4 files changed** — confirmed. No `src/`, no test, no other workflow touched.

2. **Workflow gate** — the ONLY functional change in `mutants-nightly.yml` is the `if:` line:
   `if: github.event_name != 'pull_request' && vars.MUTANTS_NIGHTLY_ENABLED == 'true'`
   (plus an explanatory comment block). An unset repository variable evaluates falsy, so the
   job is **skipped** — fail-safe opt-in, matching `JR_E2E_ENABLED` / `SIGNING_ENABLED`. No new
   `uses:`, `run:`, `secrets`, `permissions`, jobs, or steps anywhere in the diff. `mutants-nightly`
   is advisory (`timeout-minutes: 300`, never gates a merge), so gating it off by default is safe.

3. **CHANGELOG placement** — the new `### Changed` entry sits directly under `## [Unreleased]`,
   immediately before `## [0.7.0-dev.7] - 2026-09-16`. The dev.7 and dev.6 released sections are
   NOT touched by any hunk (byte-unchanged). No misfile into a released heading — this was the
   specific hazard called out in the PR body (a plain merge of #817 would have landed it under
   `[0.7.0-dev.6]`); the relocation is correct here.

4. **CLAUDE.md merge** — single full-bullet replacement of the repo-variable enumeration bullet.
   The entire pre-existing list (`JR_E2E_ENABLED`, `GITLEAKS_DISABLED`, `SIGNING_ENABLED`,
   `HOMEBREW_TAP_REPO`, `RELEASE_GAP_FILL_ENABLED`, `SYNC_UPSTREAM_REPO`) is preserved verbatim,
   with the new `MUTANTS_NIGHTLY_ENABLED` clause appended. No cycle-013 content lost. The clause
   correctly documents the asymmetry (canonical repo sets it `'true'`; forks leave it unset).

5. **fork-friendly-release-ops.md** — two consistent additions: a workflow-registry table row and
   a variable-table row for `MUTANTS_NIGHTLY_ENABLED`, default annotated `'true'` (canonical repo).
   No conflict markers anywhere in the diff.

## Findings

None (no blocking, no non-blocking). Mechanical, low-risk, consistent with the established
fail-safe opt-in pattern.

## Recommendation

APPROVE and merge.

## Post-merge action (from PR body, noted for the merger)

This defaults to OFF. After merge, set repository variable `MUTANTS_NIGHTLY_ENABLED=true`
(Settings → Secrets and variables → Actions → Variables) or the nightly advisory mutation run
stops firing on the canonical repo.

## Posting status

Formal `gh pr review --approve` could NOT be posted to GitHub: the authenticated `gh` account
(`Zious11`) is the PR author, and GitHub structurally forbids approving your own PR. Recording
the approval on GitHub requires a non-author reviewer/account running:

    gh pr review 824 --repo Zious11/jira-cli --approve --body-file .factory/code-delivery/PR-824/pr-review.md

or an admin merge treating this artifact as the recorded review evidence. `gh pr comment` and a
downgraded `--comment`/`--request-changes` verdict were deliberately NOT used — the verdict is
APPROVE and must not be misrepresented.
