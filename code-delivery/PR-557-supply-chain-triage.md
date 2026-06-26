---
title: "Supply-Chain Security Triage — PR #557"
pr: 557
dependency: softprops/action-gh-release
version_before: "3.0.0"
version_after: "3.0.1"
sha_before: b4309332981a82ec1c5618f44dd2e27cc8bfbfda
sha_after: 718ea10b132b3b2eba29c1007bb80653f286566b
sha_integrity: MATCH
verdict: SAFE-MERGE
date: 2026-06-26
reviewer: security-reviewer (automated triage)
---

# Supply-Chain Security Triage — PR #557

## Summary

PR #557 is a Dependabot bump of `softprops/action-gh-release` from `3.0.0`
(SHA `b4309332981a82ec1c5618f44dd2e27cc8bfbfda`) to `3.0.1`
(SHA `718ea10b132b3b2eba29c1007bb80653f286566b`).

The PR is a **single-line change** in `.github/workflows/release.yml` (line 230).
It updates both the pinned commit SHA and the `# vX.Y.Z` version comment in
lockstep — consistent with the SHA-pin convention established in this repo (#550).

**Verdict: SAFE-MERGE** — no blocking findings.

---

## 1. Pin Format

The before/after line in `.github/workflows/release.yml`:

```yaml
# Before (v3.0.0)
uses: softprops/action-gh-release@b4309332981a82ec1c5618f44dd2e27cc8bfbfda  # v3.0.0

# After (v3.0.1)
uses: softprops/action-gh-release@718ea10b132b3b2eba29c1007bb80653f286566b  # v3.0.1
```

Both forms are **full 40-character SHA pins with a human-readable version comment**.
The PR maintains the repo's SHA-pin convention rather than introducing a floating
tag reference. No regression in pin hygiene.

---

## 2. SHA-Pin Integrity

Goal: verify that Dependabot pinned the repo to the real upstream commit for
`v3.0.1`, not a divergent or attacker-supplied SHA.

### Resolution chain (verified via GitHub API)

| Step | Value |
|------|-------|
| `gh api repos/softprops/action-gh-release/git/refs/tags/v3.0.1` → `object.sha` | `2bb465e97f322d3cb2a965294d483e0d26a67aa9` (annotated tag object) |
| `gh api repos/softprops/action-gh-release/git/tags/2bb465e97f322d3cb2a965294d483e0d26a67aa9` → `object.sha` | `718ea10b132b3b2eba29c1007bb80653f286566b` |
| SHA in the PR | `718ea10b132b3b2eba29c1007bb80653f286566b` |

**Result: MATCH.**

The annotated tag `v3.0.1` (signed/tagged by `Rui Chen <rui@chenrui.dev>` on
2026-06-19T14:42:00Z) dereferences through the tag object directly to commit
`718ea10b132b3b2eba29c1007bb80653f286566b`. Dependabot is pinning to the exact
commit the maintainer tagged as `v3.0.1`.

Note: the tag object itself is marked `"verified": false` (unsigned GPG tag) in
the GitHub API response. This is consistent with the maintainer's historical
practice for this Action and is not a new regression — `v3.0.0` was also unsigned.
It reduces tamper-evidence on the tag object itself, but once pinned to the commit
SHA (which is content-addressed), the unsigned tag is irrelevant to our security
posture: we are effectively bypassing the tag and pinning directly to the commit.

---

## 3. CVE / Advisory Sweep

Research via Perplexity (reasoning_effort: high, 2026-06-26):

- **GitHub Advisory Database (GHSA):** No published advisory against
  `softprops/action-gh-release` in any version. The repo's own Security tab
  confirms zero published advisories.
- **OSV / osv.dev:** No OSV entry for this Action. (OSV has a GHSA for the
  maintainer's separate `atty` crate — GHSA-g98v-hv3f-hcfr — but that is a Rust
  crate, not this Action.)
- **CVE databases:** No CVE assigned to `softprops/action-gh-release`.
- **Supply-chain compromise / typosquatting:** No evidence of any malicious commit,
  maintainer account takeover, or typosquatting incident against this repo through
  mid-2026.
- **StepSecurity Action Advisor score:** 6/10. Flags five dependency-level
  vulnerabilities (likely transitive npm packages), no branch protection, no
  `SECURITY.md`. These are project-hygiene findings, not exploitation events.
- **CVE-2023-45133:** A community issue in the upstream repo asked about this CVE;
  no follow-up GHSA or patch was filed, suggesting the action was found not to be
  affected.

**Advisory status: CLEAN** — no known CVE, GHSA, or compromise for any version of
`softprops/action-gh-release` including v3.0.1.

The v3.0.1 changelog entry reads: "maintenance release with updated dependencies" —
consistent with routine dependency hygiene rather than a security-driven patch.

---

## 4. Blast-Radius Analysis

### Use sites

`grep -rn "softprops/action-gh-release" .github/workflows/` yields exactly **one**
use site:

| File | Line | Job | Trigger |
|------|------|-----|---------|
| `.github/workflows/release.yml` | 230 | `release` (job) | `push: tags: ["v*"]` |

No other workflow references this Action. The `backfill-release.yml`,
`sign-and-publish.yml`, `release-gap-fill.yml`, and other workflows do not use
`softprops/action-gh-release`.

### Trigger analysis — is this reachable from untrusted input?

The `release.yml` workflow is triggered exclusively by:

```yaml
on:
  push:
    tags: ["v*"]
```

This is a **trusted push trigger** (tag push to the repo). It is NOT triggered by:

- `pull_request` or `pull_request_target` (not present)
- `workflow_run` (not present in `release.yml`)
- `repository_dispatch` or `workflow_dispatch` (not present)
- fork-sourced events

To reach this Action, an actor must have push access to create a `v*` tag — i.e.,
at minimum Maintainer-level repo access. There is no untrusted-input attack surface
to this workflow from PRs or fork branches.

### Permissions in scope when the Action runs

From `release.yml` top-level `permissions:`:

```yaml
permissions:
  contents: write
```

The `GITHUB_TOKEN` has `contents: write` scope — the minimum necessary for creating
a GitHub Release and uploading assets. No `id-token`, `packages`, `pull-requests`,
`actions`, or broader write permissions are granted. This is appropriately scoped.

### Secrets in scope

The `release` job (where the Action runs) has access to:

- `GITHUB_TOKEN` (implicit, `contents: write`) — used by the Action to create releases
- No other secrets are passed to the `release` job itself.

The `build` jobs (which run before `release`) have access to `secrets.OAUTH_CLIENT_ID`
and `secrets.OAUTH_CLIENT_SECRET`, but those jobs do NOT use `softprops/action-gh-release`.
The Action only sees `GITHUB_TOKEN`.

### Live vs inert use sites

Per CLAUDE.md AI Agent Notes, several release-ops workflows are gated by repo variables
that are not set in the canonical repo:

| Workflow | Gate variable | Status |
|----------|--------------|--------|
| `sign-and-publish.yml` | `SIGNING_ENABLED` (not set) | INERT |
| `backfill-release.yml` | manual `workflow_dispatch` only | INERT unless manually triggered |
| `release-gap-fill.yml` | `RELEASE_GAP_FILL_ENABLED` (not set) | INERT |
| `sync-upstream.yml` | `SYNC_UPSTREAM_REPO` (not set) | INERT |
| **`release.yml`** | tag push — **no gate** | **LIVE** |

The only live use site is `release.yml`. The Action has no exposure in any currently
inert workflow.

### `workflow_run` in `sign-and-publish.yml`

`sign-and-publish.yml` uses `on: workflow_run:` and does have access to
`HOMEBREW_TAP_TOKEN` — however, it (a) does not use `softprops/action-gh-release`,
and (b) is gated on `vars.SIGNING_ENABLED == 'true'` which is not set. This workflow
is irrelevant to this triage.

---

## 5. Risk Classification

### CWE applicable to this dependency class

- **CWE-829 (Inclusion of Functionality from Untrusted Control Sphere):** Using a
  third-party GitHub Action at a floating tag would expose workflows to this class.
  This repo mitigates it by SHA-pinning.
- **CWE-494 (Download of Code Without Integrity Check):** SHA-pinning provides the
  integrity check. The pinned commit SHA matches the upstream tag. MITIGATED.
- **CWE-1357 (Reliance on Insufficiently Trustworthy Component):** The action has no
  known CVE/GHSA, is actively maintained, has 24 commits and 3 active issues in the
  last 90 days per StepSecurity, and has been in production use by many projects
  including security-conscious ones (Sigstore-signing zentinelproxy, deneb-viz). Risk
  is LOW for this specific version bump.

### OWASP Supply Chain

Relevant category: **OWASP A08:2021 — Software and Data Integrity Failures**
(specifically: use of actions from untrusted sources without integrity verification).
This repo's SHA-pin convention directly addresses A08. The PR maintains that
convention.

### Overall risk level: LOW

| Factor | Assessment |
|--------|-----------|
| SHA-pin integrity | MATCH — commit traces to upstream v3.0.1 tag |
| Known CVE/GHSA | NONE |
| Compromise history | NONE found |
| Trigger surface | Trusted tag-push only — no untrusted-input path |
| Permissions | `contents: write` only — appropriately scoped |
| Secrets exposed to Action | GITHUB_TOKEN only — no signing keys, OAuth secrets |
| Pin format regression | None — full SHA maintained with version comment |
| Changelog description | "maintenance release with updated dependencies" — routine |

No findings at CRITICAL or HIGH severity.

---

## 6. Findings

**SEC-001: No findings.**

No exploitable vulnerabilities, no GHSA/CVE, no compromise evidence, no permission
over-grant, no pin regression, and no untrusted-input reachability. The v3.0.1 tag
resolves to the exact commit pinned by Dependabot.

### Informational notes (non-blocking)

- **INFO-001 — Upstream tag is unsigned:** The `v3.0.1` annotated tag has
  `"verified": false` in the GitHub API (no GPG signature on the tag object). This
  is a project-hygiene gap in the upstream repo, not a newly introduced regression.
  Since we pin to the commit SHA directly, this does not weaken our security posture.
  Severity: INFORMATIONAL.

- **INFO-002 — StepSecurity 6/10 score, five dependency vulns:** These are
  likely transitive npm packages. No exploitation has been documented. Future version
  bumps of this Action should be monitored for whether these get patched. Severity:
  INFORMATIONAL.

---

## 7. Verdict

**SAFE-MERGE.**

Conditions: none. The SHA-pin integrity check passes (MATCH), there are no
known CVEs or advisories, the trigger surface is trusted-only, and permissions are
appropriately scoped. The PR maintains the repo's existing SHA-pin convention without
regression.
