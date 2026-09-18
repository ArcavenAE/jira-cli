# PR Review — #846

- **Repo:** Zious11/jira-cli
- **URL:** https://github.com/Zious11/jira-cli/pull/846
- **Reviewer:** pr-reviewer (fallback light review pass)
- **Type:** Docs-only, self-authored
- **Scope:** CHANGELOG.md only, +4 lines
- **Verdict:** APPROVE (posted as COMMENTED — self-authored PR; GitHub rejects self-approval, and a self-approval classifier blocks automated merge regardless; human merges manually)

## Change summary

Augments the existing `[Unreleased]` `DEFAULT_OAUTH_SCOPES` 8→16 entry
(S-cycle8-agile-oauth-scope-gap, #834) with a four-line "Re-consent behavior"
clarification inserted between the existing re-consent explanation and the
RELEASE GATE line:

> **Re-consent behavior:** existing access tokens keep working with their
> previously-granted scopes until expiry — the re-consent prompt above fires on
> the next `jr auth login` or token refresh on an OAuth profile, not immediately
> on upgrade. API-token profiles are unaffected.

## Findings

None (blocking or non-blocking). Accuracy verified against source of truth:

1. **"existing access tokens keep working until expiry"** — matches CLAUDE.md's
   "When changing DEFAULT_OAUTH_SCOPES" gotcha verbatim: *"Existing access tokens
   continue working with old scopes until expiry; new logins and refresh-token
   mints trigger re-consent."*
2. **"prompt above fires on next login or token refresh"** — consistent with the
   entry directly above it (existing text: "re-consent prompt on their next login
   or token refresh"). The back-reference "above" resolves correctly; the added
   "on an OAuth profile" qualifier is a valid refinement, not a contradiction.
3. **"API-token profiles are unaffected"** — correct: API-token auth does not use
   OAuth scopes, so a scope-set change cannot trigger re-consent for those profiles.

Wording is clear, correct, and non-contradictory with the #834 entry or elsewhere
in CHANGELOG.md.

## Decision rationale

Advisory review only. No code, no tests, no behavior change. Documentation prose
accurately describes existing, already-documented OAuth re-consent behavior.
