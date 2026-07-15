---
review_type: security
pr: 574
author: ArcavenAE (external contributor, untrusted)
reviewer: security-reviewer
date: 2026-07-15
reviewed_head_sha: 3c379486
prior_review: security-review.md (2026-07-08, verdict MERGE-WITH-CHANGES)
total_findings: 6
critical: 0
high: 0
medium: 0
low: 0
info: 1
prior_findings_resolved: 6
new_findings: 0
files_reviewed: 4
verdict: APPROVE
---

# Security Review 2 — PR #574 (head 3c379486)

**PR title:** ci(release): attest build provenance for release artifacts
**Author:** ArcavenAE (external contributor — all content treated as UNTRUSTED)
**Reviewed head SHA:** `3c379486` (updated 2026-07-15)
**Prior review:** 2026-07-08, verdict MERGE-WITH-CHANGES (6 findings: SEC-001 LOW, SEC-002 MEDIUM, SEC-003 INFO, SEC-004 INFO, SEC-005 INFO, SEC-006 INFO)
**Diff surface:** `.github/workflows/release.yml` (+57 lines, new `attest` job), `CHANGELOG.md`, `CLAUDE.md`, `docs/specs/fork-friendly-release-ops.md`

---

## Verified Facts Used in This Review

- `actions/attest-build-provenance@0f67c3f4856b2e3261c31976d6725780e5e4c373` == v4.1.1 — confirmed via `gh api repos/actions/attest-build-provenance/git/ref/tags/v4.1.1`: `"object":{"sha":"0f67c3f4856b2e3261c31976d6725780e5e4c373","type":"commit"}`.
- `step-security/harden-runner@9af89fc71515a100421586dfdb3dc9c984fbf411 # v2.19.4` and `actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c # v8` are existing pins already present in the repo's `release.yml` — no SHA drift introduced.
- `release.yml` trigger remains `push: tags: ["v*"]` only (lines 3–5). No `workflow_dispatch`, `pull_request_target`, `pull_request`, or other attacker-reachable trigger path added.
- Workflow-level `permissions: contents: write` (line 7–8) still applies. The new `attest` job declares its own `permissions:` block, which fully replaces the workflow-level block for that job (GitHub Actions behavior).
- The `attest` job declares `needs: build` (parallel with `release`, same as `release`'s `needs: build`). Neither depends on the other — both fan in from the same immutable build artifacts.

---

## Prior Findings Resolution Table

| ID | Severity | Prior Summary | Status at 3c379486 | Resolution Detail |
|----|----------|---------------|---------------------|-------------------|
| SEC-001 | LOW | `${{ github.repository }}` interpolated inline in shell `run:` block | **RESOLVED** | The `gh release download` shell step is gone entirely. The `attest` job has no `run:` blocks — only action steps. No `${{ ... }}` expressions appear in any shell context. |
| SEC-002 | MEDIUM (CWE-362) | TOCTOU: attest downloaded from published release, not in-workflow artifacts | **RESOLVED** | The download step is replaced by `actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c` (same SHA-pinned action as `release` job). Artifacts are pulled from the same workflow run's internal artifact store — no external fetch, no publish-then-attest window. The inline comment documents this design choice explicitly. |
| SEC-003 | INFO | `.sha256` sidecar files attested via `*` glob (circular provenance) | **RESOLVED** | `subject-path` is now `release-assets/*.tar.gz` + `release-assets/*.zip`. `.sha256` files are explicitly excluded. Inline comment documents the rationale. |
| SEC-004 | INFO (CWE-284) | No fork opt-in gate | **RESOLVED** | `if: vars.ATTESTATIONS_ENABLED == 'true'` with correct fail-safe direction (opt-in, empty string → skip). `docs/specs/fork-friendly-release-ops.md` and `CLAUDE.md` both updated to register `ATTESTATIONS_ENABLED`. Detailed inline comment explains GHES / private-fork constraints. |
| SEC-005 | INFO (CWE-923) | `egress-policy: audit` vs `block` (repo-consistent, no regression) | **N/A — No Change Required** | Consistent with existing repo posture across all jobs. New job includes `step-security/harden-runner` at the same pin and `egress-policy: audit`. |
| SEC-006 | INFO (CWE-390) | Download script lacks `set -euo pipefail` | **RESOLVED BY DESIGN** | The shell download script is gone. The `actions/download-artifact` action handles its own error semantics — if artifact download fails, the action step fails the job with a non-zero exit code. No shell script to harden. |

---

## Fresh Adversarial Pass

### FA-1: Workflow-Injection Surface Scan

The new `attest` job contains three steps: `step-security/harden-runner`, `actions/download-artifact`, and `actions/attest-build-provenance`. None of these steps have `run:` blocks. The only YAML expression in the `attest` job is in the outer `if:` condition:

```yaml
if: vars.ATTESTATIONS_ENABLED == 'true'
```

`vars.*` context (repository variables) is not attacker-controlled in any reachable trigger path — it requires repository admin access to set. The `subject-path:` value is a literal YAML multiline string with no `${{ }}` expressions.

**Finding:** No workflow injection surface in the new job. Clean.

---

### FA-2: Permissions Least-Privilege Verification

```yaml
permissions:
  id-token: write
  attestations: write
  contents: read
```

This job-level block fully replaces the workflow-level `permissions: contents: write` for the `attest` job. Effective grants for `attest`:

- `id-token: write` — required for OIDC token issuance to GitHub's attestation endpoint (Sigstore/Fulcio). Cannot be narrowed further.
- `attestations: write` — required to write attestation records. Scoped to the current repository only; cannot write attestations for other repositories.
- `contents: read` — not strictly required by `actions/download-artifact` (artifacts use the Actions internal API, not the Contents API) but is the established minimum and harmless. No write access to repository contents from this job.

The `build` and `release` jobs are unaffected; they continue to use the workflow-level `contents: write` via inheritance (no job-level override). The `attest` job's `contents: write` is strictly removed. **No permission escalation path. Correctly minimized.**

---

### FA-3: SHA-Pin Integrity

| Action | SHA in Diff | Claimed Version | Verification |
|--------|------------|-----------------|--------------|
| `actions/attest-build-provenance` | `0f67c3f4856b2e3261c31976d6725780e5e4c373` | v4.1.1 | **VERIFIED** via `gh api repos/actions/attest-build-provenance/git/ref/tags/v4.1.1` → `sha: 0f67c3f4856b2e3261c31976d6725780e5e4c373` |
| `step-security/harden-runner` | `9af89fc71515a100421586dfdb3dc9c984fbf411` | v2.19.4 | Pre-existing repo pin — matches all existing jobs. No new drift. |
| `actions/download-artifact` | `3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c` | v8 | Pre-existing repo pin — same SHA as `release` job (line 225). No new drift. |

No floating mutable tags (`:latest`, `@v2`, etc.). No unverified third-party actions. Supply chain hygiene passes.

---

### FA-4: Artifact-Poisoning Risk in the Download-Artifact Fan-In

The `attest` job fans in via `actions/download-artifact` with `needs: build` — identical to the `release` job's fan-in on line 225. GitHub Actions artifact storage is scoped to a specific workflow run by `GITHUB_RUN_ID`. Key isolation properties:

- **Cross-run isolation:** Artifacts from one workflow run cannot be accessed or poisoned by a concurrent run. Each run has its own isolated artifact store.
- **Cross-fork isolation:** A fork pushing a `v*` tag triggers its own independent workflow run. Fork artifacts are isolated to that fork's run ID. No cross-fork artifact substitution is possible.
- **Partial-build protection:** The `attest` job depends on `needs: build`, which requires all matrix build jobs to succeed before the fan-in. A partial artifact set (some build jobs failed) would cause the `attest` job to not run at all.
- **`merge-multiple: true`:** Merges all artifacts from the `build` matrix into `release-assets/`. This is the same option used in the `release` job — behavior is identical and well-understood.

**Finding:** No artifact-poisoning surface. The design is equivalent to the pre-existing `release` job fan-in and inherits the same isolation guarantees.

---

### FA-5: Trigger Context and `pull_request_target` Risk

The `release.yml` workflow trigger:

```yaml
on:
  push:
    tags: ["v*"]
```

No `pull_request_target`, `workflow_dispatch`, `schedule`, or `workflow_run` added by this PR. The `attest` job inherits the same trigger and has no independent trigger mechanism. Only repository collaborators with `contents: write` can push `v*` tags (protected by GitHub's tag protection rules, though that's outside workflow scope). **No `pull_request_target` or fork-trigger escalation surface.**

---

### FA-6: ATTESTATIONS_ENABLED Fail-Safe Direction

```yaml
if: vars.ATTESTATIONS_ENABLED == 'true'
```

This is an opt-in gate. When `ATTESTATIONS_ENABLED` is unset (the default for all forks and for the canonical repo before opting in), the comparison evaluates as `'' == 'true'` → false → job is skipped. Consequences:

- No `id-token: write` OIDC calls on forks that have not opted in.
- No Rekor transparency log entries for fork commit SHAs without operator consent.
- No failure in GHES or private-fork environments where `id-token: write` is unavailable.
- Releases proceed normally via the `release` job (not gated on `attest`).

This matches the `SIGNING_ENABLED`, `HOMEBREW_TAP_REPO`, `RELEASE_GAP_FILL_ENABLED`, `SYNC_UPSTREAM_REPO`, and `GITLEAKS_DISABLED` pattern established in `docs/specs/fork-friendly-release-ops.md`. **Fail-safe direction is correct.**

---

### FA-7: Parallel Execution Model — No `attest`-Skipped-Cascades `release`

The PR author correctly chose `needs: build` (parallel with `release`) rather than making `attest` a prerequisite of `release` or vice versa. The inline comment explains the reasoning: if `attest` needed `release` and `attest` were skipped (gated out), GitHub Actions would cascade-skip the `release` job unless `if: always()` was used. With both depending only on `build`, a skipped `attest` leaves `release` unaffected.

One nuance: both jobs download the same artifacts from the same run. There is a brief window where both jobs are simultaneously reading from the artifact store. GitHub's artifact API supports concurrent reads without contention — this is not a race condition. **Parallel model is correct and safe.**

---

### FA-8: Documentation Changes — No Security Regression

The `CHANGELOG.md`, `CLAUDE.md`, and `docs/specs/fork-friendly-release-ops.md` changes are documentation-only:

- `CLAUDE.md` adds `ATTESTATIONS_ENABLED` to the release-ops repo-variable inventory paragraph. Accurate.
- `docs/specs/fork-friendly-release-ops.md` adds a table row for `ATTESTATIONS_ENABLED` with correct disclosure of the Rekor transparency log implication.
- `CHANGELOG.md` adds a factual description of the new behavior. No misleading claims.

No application code changes. No configuration changes to `src/`. **No security regression in documentation changes.**

---

## New Findings

None. The fresh adversarial pass identified no new security concerns.

---

## Summary

| ID | Severity | CWE | Summary | Status |
|----|----------|-----|---------|--------|
| SEC-001 | LOW | CWE-77 | Shell injection via `${{ github.repository }}` | **RESOLVED** — step removed entirely |
| SEC-002 | MEDIUM | CWE-362 | TOCTOU: attest covered downloaded bytes, not built bytes | **RESOLVED** — uses `actions/download-artifact` |
| SEC-003 | INFO | — | `.sha256` files attested via `*` glob | **RESOLVED** — explicit `*.tar.gz` / `*.zip` glob |
| SEC-004 | INFO | CWE-284 | No fork opt-in gate | **RESOLVED** — `vars.ATTESTATIONS_ENABLED == 'true'` gate |
| SEC-005 | INFO | CWE-923 | `egress-policy: audit` (repo-consistent) | **N/A** — no change required; consistent |
| SEC-006 | INFO | CWE-390 | Download script lacks `set -euo pipefail` | **RESOLVED BY DESIGN** — shell script removed |

---

## Verdict: APPROVE

All prior findings are resolved at head SHA `3c379486`. The fresh adversarial pass identified no new security concerns. The implementation is correct:

- No workflow-injection surface (no `run:` blocks, no untrusted context expansions).
- Permissions correctly minimized to `id-token: write`, `attestations: write`, `contents: read`.
- SHA pin `0f67c3f4856b2e3261c31976d6725780e5e4c373` verified as `actions/attest-build-provenance@v4.1.1`.
- Artifact fan-in uses the same isolated in-run download mechanism as the existing `release` job — no TOCTOU window, no artifact-poisoning surface.
- Fork fail-safe gate is correct opt-in direction and matches repo convention.
- No `pull_request_target` or attacker-reachable trigger introduced.
- Documentation changes (CHANGELOG, CLAUDE.md, fork-friendly-release-ops.md) are accurate and complete.

The PR is ready to merge.
