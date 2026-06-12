# Fork-Friendly Release Ops — opt-in signing, backfill, and fork sync

## Problem

`jr` is developed in this repo and republished by downstream forks that add
platform packaging — today, a fork that codesigns/notarizes macOS builds with
an Apple Developer ID and publishes them through a Homebrew tap. Carrying
those pipelines only in the fork created two recurring costs:

1. **Sync churn.** Every fork-local edit to shared files risks merge
   conflicts on the next upstream sync, requiring manual intervention and
   risking the fork's additions being erased.
2. **Drift.** The fork's copies of release machinery silently fall behind
   upstream conventions (action pins, runner hardening, comment style).

## Approach

Host the release-ops workflows in the canonical repo, gated on repository
variables so they are **no-ops by default**. The canonical repo never needs
an Apple Developer Program account, signing secrets, or a tap repo — with no
variables set, nothing runs and CI is byte-for-byte unaffected. A fork opts
in by setting variables/secrets; the workflow files themselves stay identical
in both repos, so syncs are conflict-free.

## Components

| File | Purpose | Inert unless |
|---|---|---|
| `.github/workflows/sign-and-publish.yml` | Sign + notarize macOS binaries on five channels (alpha/dev/beta/rc/stable), publish to a Homebrew tap | `vars.SIGNING_ENABLED == 'true'` |
| `.github/workflows/backfill-release.yml` | Build + release an existing tag that has no GitHub Release (manual dispatch); optionally sign/publish | always manual; sign job needs `SIGNING_ENABLED`, homebrew job needs `HOMEBREW_TAP_REPO` |
| `.github/workflows/release-gap-fill.yml` | Daily tag-vs-release reconciliation; dispatches backfill for missing releases | `vars.RELEASE_GAP_FILL_ENABLED == 'true'` (manual dispatch always works) |
| `.github/workflows/sync-upstream.yml` | Scheduled fork→upstream merge with protected-file auto-resolution | `vars.SYNC_UPSTREAM_REPO` set |
| `.github/local-workflows.txt` | Registry of fork-local files that survive a sync ("ours" on conflict) | n/a (empty template here) |
| `Formula/*.rb` | Homebrew formula templates (placeholders sed'd at publish time) | only read by the jobs above |
| `packaging/Info.plist`, `scripts/create-{app,dmg,pkg}.sh` | macOS .app/.dmg/.pkg packaging helpers | only invoked by sign jobs |

## Repository variables (Actions → Variables)

| Variable | Effect when set | Canonical repo |
|---|---|---|
| `SIGNING_ENABLED` | `'true'` enables the sign/notarize jobs | unset |
| `HOMEBREW_TAP_REPO` | `owner/homebrew-name` tap repo to publish formulas to; also enables the homebrew jobs | unset |
| `RELEASE_GAP_FILL_ENABLED` | `'true'` enables the daily gap-fill schedule | unset |
| `SYNC_UPSTREAM_REPO` | `owner/repo` to merge from on a schedule (forks only) | unset |

This is the same fail-safe pattern as `vars.JR_E2E_ENABLED`
(`docs/specs/e2e-fork-safe-ci-enablement.md`): scheduling-time gates on
repository variables, with unset evaluating falsy so forks and the canonical
repo skip cleanly.

## Secrets (only needed by repos that opt in)

| Secret | Used by |
|---|---|
| `APPLE_CERTIFICATE_P12` / `APPLE_CERTIFICATE_PASSWORD` | Developer ID Application cert (codesign) |
| `APPLE_INSTALLER_CERTIFICATE_P12` / `APPLE_INSTALLER_CERTIFICATE_PASSWORD` | Developer ID Installer cert (pkg) |
| `APPLE_SIGNING_IDENTITY` / `APPLE_INSTALLER_IDENTITY` | Identity strings passed to codesign/productsign |
| `APPLE_NOTARIZATION_APPLE_ID` / `APPLE_NOTARIZATION_PASSWORD` / `APPLE_NOTARIZATION_TEAM_ID` | notarytool |
| `HOMEBREW_TAP_TOKEN` | Push access to the tap repo |
| `SYNC_UPSTREAM_SSH_KEY` | Deploy key used by sync-upstream to push merged branches |

Signing jobs additionally run in the `release` environment so a fork can put
approval rules around them.

## Formula templates

`Formula/*.rb` carry `REPO_PLACEHOLDER`, `TAP_PLACEHOLDER`,
`VERSION_PLACEHOLDER`, `TAG_PLACEHOLDER`, and `SHA256_*_PLACEHOLDER`. The
publish jobs substitute them from `github.repository`,
`vars.HOMEBREW_TAP_REPO`, and the release metadata, so the templates are
repo-neutral. The macOS bundle identifier in `packaging/Info.plist` and
`scripts/create-pkg.sh` (`com.arcavenae.jr`) reflects the first signing fork;
a different signing fork should override it to match its own Apple team.

## Known limitations

- `sync-upstream.yml` hardcodes the branch matrix
  (`main`, `develop`, `factory-artifacts`) to this repo's branch layout.
- Bulk-gap backfills are throttled (`max` input, default 5/run); remaining
  tags are picked up on subsequent scheduled runs.
- The alpha channel builds from source on every `develop` push (only when
  `SIGNING_ENABLED` is set), independent of tagged releases.
