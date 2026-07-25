# PR Review — FIX-E2E-EGRESS (PR #654)

**Branch:** `ci/e2e-egress-cdn-allowlist` → `develop`
**Scope:** CI-only. Single file (`.github/workflows/e2e.yml`), single job (`e2e:`). Commit `779bc3ab`, +21/-4.
**Verdict:** PASS — no blocking findings. (No `gh pr review --approve` posted; DEC-173 prohibits agent approval — verdict returned to orchestrator for the merge decision.)

## What changed

Two entries appended to the harden-runner `egress-policy: block` allowlist in the live E2E job, plus an expanded inline RCA comment:

- `api.media.atlassian.com:443`
- `*.amazonaws.com:443`

Root cause: `GET /rest/api/3/attachment/content/{id}` returns a 302/303 redirect to a pre-signed media URL on a different host; harden-runner blocked the cross-host hop, failing `test_e2e_attachment_platform_roundtrip` on 3 of 4 runs.

## Checklist assessment

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — all changes relate to the stated fix; nothing unrelated. |
| 2 | Description accuracy | PASS — commit message and inline comment match the diff exactly. |
| 3 | Test coverage | N/A — CI config; no Rust code touched. Validation is the live E2E run itself. |
| 4 | Demo evidence | N/A — infra/CI change. |
| 5 | Commit quality | PASS — Conventional `ci(e2e):` prefix, task ID `FIX-E2E-EGRESS`, clear body with RCA + run IDs. |
| 6 | Diff size | PASS — +21/-4. |
| 7 | Missing changes | PASS — fix is self-contained. |
| 8 | Dependency status | N/A. |

## Findings

### PASS observations (verified)

1. **`api.media.atlassian.com:443` is net-new, not a duplicate.** Existing `*.atlassian.net:443` does not cover it (`.atlassian.com` ≠ `.atlassian.net`), so the entry is genuinely required. Correctly preferred over a broad `*.atlassian.com` wildcard (least-privilege).
2. **`egress-policy: block` unchanged (line 37).** The diff appends to `allowed-endpoints` only; it does not switch to `audit` or otherwise weaken the policy. Fail-closed property preserved — an incomplete list fails the (non-blocking) job rather than leaking credentials.
3. **YAML valid.** Both entries sit inside the `allowed-endpoints: >` folded block scalar at consistent 12-space indentation; the RCA text is `#` comments above the value, not folded into it.
4. **No cross-job side effects.** Workflow contains only the `e2e:` job.
5. **Inline comment self-consistent.** 3 failing runs (30043437491, 30132346956, 30164583719) + 1 passing (30150068145) = the stated "3/4"; matches the commit message. GHSA-9857-6MW7-FQ2M note (Authorization stripped on cross-host hop is correct behavior) aligns with the documented S-576-2 redirect contract.

### NIT (non-blocking)

| Field | Value |
|-------|-------|
| Severity | nit |
| Category | coherence |
| Finding | `api.media.atlassian.com` is a single concrete host guess. If the real attachment-content redirect targets a different media subdomain (e.g. a media-CDN or tenant-scoped media host) rather than this exact host, only the S3 path would be covered by `*.amazonaws.com`, and the Atlassian-direct redirect variant could still fail. |
| Suggestion | Confirm the observed redirect host on the next green run via the step-security dashboard and tighten/correct if it differs. Low risk: the job fail-closes safely (no credential leak), and the comment already commits to dashboard-based tuning. |

## Out of scope

Egress-surface breadth of `*.amazonaws.com` is deferred to security-reviewer per the review directive (credential/egress tradeoff handled separately).
