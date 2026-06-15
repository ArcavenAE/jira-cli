---
document_type: research-brief
title: Fork-Friendly Release Ops Integration (PR #520 / PR #503)
date: 2026-06-15
status: AWAITING-USER-DECISION
author: state-manager
---

# Fork-Friendly Release Ops Integration — Resume Brief

## A. Integration Summary

**PR #520** (`ci: opt-in release ops — Apple signing, backfill, gap-fill, fork sync (integrates #503)`)
squash-merged → `develop` @ **`2cb219b`** (full: 2cb219bd35931a469b342578445cafe54f32360e).
All 14 CI checks GREEN including the required **CI Gate**.

This integrates external **PR #503** by @ArcavenAE (Michael Pursifull <mike@arcaven.com>), which we
could NOT push to (fork 403; `maintainerCanModify` ≠ git push access). The conflict was resolved in
our repo by merging from a local `ci/fork-friendly-release-ops` branch (now deleted). The squash
commit carries `Co-authored-by: Michael Pursifull <mike@arcaven.com>`. **PR #503 is CLOSED with a
credit comment.**

**Scope:** 17 files, +1589/-1:
- 4 new workflows: `sign-and-publish.yml`, `backfill-release.yml`, `release-gap-fill.yml`, `sync-upstream.yml`
- 5 `Formula/jr*.rb` Homebrew formula stubs
- 3 `scripts/create-{app,dmg,pkg}.sh` macOS packaging scripts
- `packaging/Info.plist`
- `docs/specs/fork-friendly-release-ops.md`
- `.github/local-workflows.txt`
- Edits to `ci.yml`: harden-runner on spec-guard+mutants; `security` job gains `&& vars.GITLEAKS_DISABLED != 'true'`
- `CLAUDE.md` Release-ops repo-variable-gates bullet

**Conflict resolution VERIFIED:** merged `ci.yml` preserves Windows matrix (test+clippy) +
`ci-gate` (`needs:[fmt,clippy,test,msrv,deny,spec-guard]`) + gitleaks `# v3.0.0` pin.
`tests/ci_gate_completeness.rs` + `tests/ci_yml_windows_matrix.rs` green.

**The machinery is INERT by default** — every new job is gated on a repo variable that is UNSET.
Nothing privileged runs on push. HOWEVER: new `schedule:`/`push:`/`workflow_run:` TRIGGERS now
create empty/skipped workflow RUNS on canonical (~7/day) — cosmetic Actions-tab noise. The
"nothing runs" claim is true for jobs; it is not true for runs.

---

## B. Per-Piece Enablement Plan

Each piece requires specific fixes BEFORE going live. The user has NOT yet chosen which to enable.

| Piece | Enable trigger | Prereq fixes before enabling | For canonical? |
|---|---|---|---|
| `backfill-release.yml` (manual, unsigned) | workflow_dispatch (no var needed) | Add `x86_64-pc-windows-msvc` target row — currently omits Windows; backfilled v0.6.0+ releases would lack Windows binary | Yes — low risk |
| `release-gap-fill.yml` (daily auto) | `vars.RELEASE_GAP_FILL_ENABLED=true` | Fix destructive-backfill blast radius: `gh release delete`+recreate can clobber curated notes; add "existing release?" guard + `github.repository ==` canonical belt | Optional |
| `sign-and-publish.yml` (Apple sign + Homebrew) | `vars.SIGNING_ENABLED` + `APPLE_*` secrets + `vars.HOMEBREW_TAP_REPO` | Fix HIGH-1 (`workflow_run.head_branch` tag injection — validate `^v…` before shell use) + HIGH-2 (alpha-tag read-then-create race — use `git rev-parse --short HEAD`); parameterize hardcoded `com.arcavenae.jr` bundle id | Only if user has Apple Developer account |
| `sync-upstream.yml` (fork→upstream) | `vars.SYNC_UPSTREAM_REPO` | n/a | **NEVER on canonical** (this IS upstream) |

---

## C. Full Review Findings (4-Lens VSDD Review of #503)

Review scope: security / code / consistency / adversary. First adversary pass was confabulated
(model hallucinated specific line numbers) and was discarded; a fresh-context re-run was performed.

### HIGH

| ID | Finding | Affected piece | Action required before enabling |
|----|---------|----------------|--------------------------------|
| SEC-001 / CR-001 | `sign-and-publish.yml`: `workflow_run.head_branch` written unsanitized into shell with `$APPLE_ID` etc. present (CWE-77). A tag push from a branch named e.g. `$(curl …|sh)` could inject. | sign-and-publish | Validate `github.event.workflow_run.head_branch` matches `^v[0-9]+\.[0-9]+\.[0-9]+` before any shell step. |
| CR-002 | Alpha-tag race in `sign-and-publish.yml`: reads current alpha tag then tries to create it — non-atomic; concurrent runs create duplicate tags. | sign-and-publish | Use `git rev-parse --short HEAD` as unique suffix; no read-before-create. |
| SEC-007 (adversary) | Destructive backfill blast radius: `release-gap-fill.yml` calls `gh release delete` + recreate — if `RELEASE_GAP_FILL_ENABLED` is set on the wrong repo or for a wrong tag, curated release notes are silently clobbered. | release-gap-fill | Add `github.repository == 'owner/jira-cli'` guard + "existing release?" check before delete. |
| ADV HIGH-1 | "Inert by default" overstated in PR description — phantom workflow runs do occur (~7/day) on canonical. Not a security issue; a correctness claim issue. | all new workflows | Acknowledged; decide whether to suppress triggers. |

### MEDIUM

| ID | Finding | Severity | Notes |
|----|---------|----------|-------|
| GITLEAKS-DOC | `GITLEAKS_DISABLED` var undocumented in CLAUDE.md + spec | MED | Secret-scan opt-out; should be documented like other repo-variable gates |
| BACKFILL-WIN | `backfill-release.yml` missing `x86_64-pc-windows-msvc` target | MED | Backfilled releases would lack Windows binary |
| BUNDLE-ID | `com.arcavenae.jr` hardcoded bundle id (not a placeholder) | MED | Should be `com.zious.jr` or parameterized before canonical use |
| SYNC-MAIN | `sync-upstream.yml` auto-syncs to `main` + unconditional tag push | MED | Nonsensical on canonical; gated by `SYNC_UPSTREAM_REPO` var but the logic is inverted |
| CROSS-UNPIN | `cross` installed via `cargo install cross --git` (unpinned); pre-existing from `release.yml` | MED | Pin to a tag or SHA |
| BACKFILL-REF | `backfill-release.yml` + `sign-and-publish.yml` use `ref: develop` for packaging | MED | Non-reproducible; packaging artifacts diverge if develop advances during job |

### LOW / NITPICK

- Empty-password keychain creation (self-hosted macOS caveat; not relevant to GitHub-hosted)
- PAT in clone URL (logs-visible; use `GH_TOKEN` with `gh auth setup-git`)
- `Info.plist CFBundlePackageType` value (cosmetic)
- Raw `hdiutil create` DMG (no UDIF compression; minor size)
- Missing trailing newline in `sync-upstream.yml`
- `dry_run != true` condition clarity (should be `dry_run == false`)

### Safe / No Action Required

- All action pins are SHA-pinned (HIGH compliance)
- All scripts use `set -euo pipefail`
- Default-path behavior is inert and safe per all reviewers

---

## D. Phantom-Runs Note

New triggers create approximately 7 empty/skipped workflow runs per day on canonical:
- `release-gap-fill.yml` — daily `schedule:`
- `sync-upstream.yml` — every 4 hours `schedule:`
- `sign-and-publish.yml` — per `develop` push + on Release completion (`workflow_run:`)

Options:
1. **Accept** as cosmetic Actions-tab noise (no cost; jobs do not run; only run records are created)
2. **Suppress** by guarding `schedule:` + `push:` triggers with `if: vars.SIGNING_ENABLED == 'true'`
   etc. at the workflow level — requires `workflow_run` workaround since GitHub doesn't allow
   `if:` at the workflow level for `on:` blocks directly; use `jobs.<id>.if:` instead.

---

## E. Open Decision — Awaiting User

The user asked to enable "some of it" but has NOT yet specified which pieces.

**Decision needed:** which of the following to proceed with (each independently)?

1. **Backfill (`backfill-release.yml`)** — manual, low risk; fix: add Windows target row before using
2. **Gap-fill (`release-gap-fill.yml`)** — daily auto; fix: add delete guard + canonical repo check
3. **Apple signing (`sign-and-publish.yml`)** — requires Apple Developer account + secrets; fix: HIGH-1 injection + HIGH-2 race + bundle id before enabling
4. **Suppress phantom runs** — guard schedule/push triggers; purely cosmetic

`sync-upstream.yml` should NOT be enabled on canonical under any circumstance — it is a tool for
forks to sync back to upstream, which is this repo.

---

## F. Reference

- PR #520 merged @ develop `2cb219b`
- PR #503 closed (external contribution by @ArcavenAE, credited)
- Branch `ci/fork-friendly-release-ops` deleted post-merge
- Review findings archived above (no separate review file was created — findings are here)
- Spec: `docs/specs/fork-friendly-release-ops.md`
