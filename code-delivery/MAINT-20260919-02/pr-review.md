# PR #849 — Fresh-Eyes PR Review

**PR:** chore(maint-20260919-02): drop stale deny.toml license allowances + unnecessary skips
**Branch:** `chore/maint-20260919-deny-housekeeping` → `develop`
**Size:** 13 deletions, 1 file (`deny.toml`)
**Mergeable:** clean (`cargo deny check` exits 0 on the branch)
**Author:** Zious11 (self-authored — formal `gh pr review --approve` is blocked by GitHub)
**Reviewer:** pr-reviewer (fresh-eyes, diff + `cargo deny` verification)

## Verdict: APPROVE

Mechanical, non-behavioral, non-security `deny.toml` housekeeping. Merge-ready pending explicit human go-ahead.

> Note: The PR is self-authored (author == the operator's GitHub account), so
> `gh pr review --approve` cannot be posted — GitHub blocks self-approval, and the
> team-lead brief explicitly directed posting the verdict as a review COMMENT via
> `gh pr review 849 --comment --body-file` (NOT `gh pr comment`), which was done.
> This artifact records the verdict; the human retains manual control of the
> GitHub approve/merge action. (Same abstention pattern as
> `MAINT-20260919-01/pr-review.md`.)

## Findings

None. No BLOCKING, no WARNING, no NIT.

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| — | — | No issues found | — |

## What was verified (no rubber-stamping)

### 1. Scope — deny.toml only, exactly the 5 expected removals
- `gh pr diff 849` and the PR file list (`gh pr view 849 --json files`) both show `deny.toml` as the only changed file.
- Authoritative `git diff origin/develop...HEAD --stat` = `deny.toml | 13 deletions`.
- (An initial `git diff develop...HEAD --stat` showed 58 files — this was a **stale local `develop` ref**, local `3d9ca35` vs `origin/develop` `7a57ed5`. Re-diffing against `origin/develop` confirmed deny.toml-only. Noted so a future reviewer does not re-trip on it.)
- The 5 removals:
  - `[licenses] allow`: removed `BSD-2-Clause`, `Unicode-DFS-2016`, `OpenSSL` (no crate in the tree carries these licenses).
  - `[[bans.skip]]`: removed `windows_i686_gnullvm = "^0.53"` (unnecessary-skip — single reachable version now) and `cpufeatures = "^0.2"` (unmatched-skip — sha1 0.11 + chacha20 both resolve to cpufeatures 0.3.0).

### 2. `syn` 2/3 dual-version skip pair untouched
- Both `[[bans.skip]]` entries for `syn` (v2 @ line 84, v3 @ line 89) remain present with removal-trigger rationale intact.
- Still correct: pear_codegen / proc-macro2-diagnostics (via figment's `pear` feature) and tracing-attributes (via tracing) hold syn-2 back, so the dual skip is genuinely required.

### 3. `cargo deny check` passes clean on the PR branch
```
advisories ok, bans ok, licenses ok, sources ok
```
Exit 0 — no `unnecessary-skip` / `unmatched-skip` / license warnings introduced or left behind.

## Posting record
- Verdict posted to PR #849 via `gh pr review 849 --comment --body-file <tempfile>` (review-comment event, per team-lead brief).
- `gh pr review --approve` intentionally NOT attempted (self-authored PR — structurally blocked).
- `gh pr comment` intentionally NOT used.
