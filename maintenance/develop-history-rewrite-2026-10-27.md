# develop history rewrite -- co-author trailer strip (2026-10-27, D-414)

**Cause.** The jira-cli repo-local `.git/config` carried `user.name=x` / `user.email=x@x` (origin unconfirmed; first x-authored commit 2026-10-15 08:50 -0500). Agent-made branch commits were authored `x <x@x>`, and GitHub squash-merges added `Co-authored-by: x <x@x>` to 7 develop commits (#919 #920 #921 #922 #929 #935 #936).

**Actions (human-executed after the vsdd destructive-command-guard hook blocked the agent).** Local identity unset (now resolves to global `Zious`). Local-only backup ref `refs/backup/develop-pre-rewrite-2026-10-27` = `c72f8131` in the main checkout. Trailers stripped with a msg-filter history rewrite in a scratch clone; verified per-commit trees and author/committer idents/dates identical, only the 7 trailer lines removed. Force-pushed with `--force-with-lease` (force-push temporarily enabled, then disabled again and verified).

**Consequence.** The 22 rewritten commits lost GitHub Verified signatures; all SHAs in `fb9d015c..c72f8131` changed. **Any `.factory` reference to an old SHA in the table below is a PRE-REWRITE SHA** (historical text is not rewritten).

**Residuals.** Original x-authored commits remain visible on the merged PRs' Commits tabs (GitHub-retained refs; only GitHub Support can purge). factory-artifacts history keeps its x-authored commits (human chose develop-only). Merged sweep branches were already auto-deleted.

## Old -> new SHA mapping (22 commits)

| Old | New |
|-----|-----|
| eaaea80c | 6706434a |
| 52a41d29 | 17cb6d04 |
| be51d922 | b6a1ceb0 |
| c35e7479 | 2f20f128 |
| fc12df13 | 34badba3 |
| 7d999628 | 8a2fa25d |
| fb48fa5a | 88fdc484 |
| 1ec0caf2 | fabddff6 |
| 6b71cae3 | 22323a01 |
| bee2801b | 986c5c3a |
| cd360205 | e2fc1243 |
| d41a7b78 | 23394be4 |
| a64749c8 | d16608c7 |
| 3a068d4d | fae377c5 |
| 6fb556f9 | a8b3a6ba |
| 7b011fa0 | e530c8eb |
| 49e92539 | c41e9365 |
| 9e9dd9c4 | c0b105ea |
| 5976633d | 2869872c |
| 684eaeb5 | d5590175 |
| 14430890 | 214305cd |
| c72f8131 | 39ea4120 |

`fb9d015c` (the v0.8.0-dev.2 release commit, PR #911) is the unchanged base of the rewrite; the tag `v0.8.0-dev.2` is unaffected.

**[process-gap] `AGENT-GIT-IDENTITY-PREFLIGHT`:** agent sessions committed under a non-human placeholder identity for about 12 days unnoticed. Follow-up: a pre-commit / agent-preflight check that the git identity resolves to the human's identity (not `x`); consider handing to vsdd-factory as an engine item.
