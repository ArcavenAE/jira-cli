# PR #804 Review — S-cycle7-readme-migration-note

- **PR:** https://github.com/Zious11/jira-cli/pull/804
- **Title:** docs: add per-profile-credential migration note to README (issue #783)
- **Base:** develop
- **covered_sha:** 6ac0568ea50a2c93cd6a4efddb661bf9a3faba9d
- **Verdict:** APPROVE (0 blocking findings)
- **Scope:** Doc-only (README.md + CHANGELOG.md); no `src/` changes.

## Acceptance Criteria

| AC | Requirement | Status | Evidence |
|----|-------------|--------|----------|
| AC-001 | README migration bullet: api-token profiles created pre-cycle-003 must run `jr auth login --profile=<name>` once after upgrading | PASS | README.md migration section, new block |
| AC-002 | Uses equals form `--profile=<name>` (not positional) | PASS | Matches shipped remediation hint `src/api/auth.rs:806-813` |
| AC-003 | OAuth-vs-api-token asymmetry documented explicitly (OAuth lazy-migrates; api-token does NOT, BC-1.4.032) | PASS | "not lazy-migrated ... the way OAuth tokens are"; paired with adjacent existing OAuth paragraph |
| AC-004 | CHANGELOG `[Unreleased] > Changed` entry added | PASS | Under `### Changed` (lines 54-102) |

## Factual verification against shipped code

- Exit code **2** for missing api-token credentials: confirmed `src/error.rs:109` (`NotAuthenticated => 2`), produced by `load_api_token` (`src/api/auth.rs:810`). Not 64, not 1.
- Equals form required for leading-hyphen profile names — matches shipped hint verbatim.
- No legacy fallback for api-token (incl. `default` profile) — BC-1.4.032; consistent with `load_api_token_default_profile_has_no_legacy_fallback`.
- Stays in scope; does NOT restate the remediated shared-credential-model claim.

## Findings

1. **NON-BLOCKING (verification):** README block confirmed to satisfy all four ACs; posted as inline comment on README.md. No corrections required.

No BLOCKING findings. No NITPICKS worth raising. Clean doc-only PR, ready to merge.

## Verdict posting note

`gh pr review --approve` is rejected by GitHub because the `gh` account (`Zious11`) is also the PR author ("Can not approve your own pull request"). The verdict was submitted via `gh pr review --comment` (formal review event, COMMENTED state) — NOT `gh pr comment`. A green Approved review-state, if required for merge gating, must come from a reviewer account other than the PR author.
