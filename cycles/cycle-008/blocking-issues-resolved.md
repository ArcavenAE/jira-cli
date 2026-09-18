---
document_type: blocking-issues-resolved
level: ops
version: "1.0"
status: archive
producer: state-manager
timestamp: 2026-09-18T21:20:00Z
cycle: "cycle-008"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Blocking Issues Resolved — cycle-008 (oauth-surface-correctness)

<!-- Closed Blocking Issues are moved here from STATE.md's Blocking Issues table when resolved.
     Append-only; maintain chronological order by resolution burst. -->

## Resolved at standing-item disposition burst (2026-09-18, post-F7-close) — operator-confirmed

This disposition is a standing-item resolution, not a pipeline ruling — no new DEC was minted.
It references `DEC-371` (the cycle-008 F7 close itself, which left this item as the cycle's sole
open pre-release blocker).

| ID | Issue | Severity | Blocking Phase | Owner | Resolution |
|----|-------|----------|-----------------|-------|------------|
| `CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` | ALL 8 of the finalized `DEFAULT_OAUTH_SCOPES` additions (`manage:jira-project` + 7 granular `jira-software` Agile scopes) had to be added to the embedded `jr` OAuth app's permissions in the Atlassian Developer Console + a CHANGELOG re-consent note, BEFORE any release ships cycle-008's content. | RELEASE-GATE (hard blocker; did not block F1-F7 pipeline work, blocked only shipping a release) | pre-release (any release carrying cycle-008 content) | human | **RESOLVED 2026-09-18, operator-confirmed.** (1) The operator confirmed on 2026-09-18 that all 8 new cycle-008 OAuth scopes — `manage:jira-project`, `read:board-scope:jira-software`, `read:board-scope.admin:jira-software`, `read:sprint:jira-software`, `write:board-scope:jira-software`, `read:project:jira`, `read:issue-details:jira`, `read:jql:jira` — were added to the embedded `jr` OAuth app's permissions in the Atlassian Developer Console (`DEFAULT_OAUTH_SCOPES` now 16 total). This is the Console-registration half of the gate. (2) The re-consent CHANGELOG note (the second half) is delivered via PR on branch `docs/cycle8-oauth-reconsent-changelog` → `develop` `[Unreleased]` — merge-ready, not yet merged as of this record. Both halves of the CLAUDE.md-documented `DEFAULT_OAUTH_SCOPES`-change procedure are now satisfied (delivered, or in a merge-ready PR). cycle-008 carries **ZERO** open pre-release blockers as of this resolution. **Recommended pre-release verification (NOT a blocker):** run a definitive `jr auth login` on an OAuth profile and confirm all 16 scopes appear on the consent screen / login succeeds without `invalid_scope` — this is the authoritative confirmation the Console registration actually took (a typo, e.g. a stray `.admin` in `read:board-scope.admin:jira-software`, would only surface at that live-login step). |

**Cross-references:** full original item text + this resolution record also archived verbatim to
`cycles/RESOLVED-DRIFT-ITEMS.md` (§"RESOLVED — CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE"); short
pointer left in `cycles/OPEN-STANDING-ITEMS.md`; `STATE.md`'s `## Blocking Issues` table cleared
of this row and its header text updated to reflect zero open blockers.
