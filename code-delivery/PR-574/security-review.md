---
review_type: security
pr: 574
author: arcaven (external contributor, untrusted)
reviewer: security-reviewer
date: 2026-07-08
total_findings: 6
critical: 0
high: 0
medium: 1
low: 1
info: 4
files_reviewed: 2
verdict: MERGE-WITH-CHANGES
---

# Security Review — PR #574

**PR title:** ci(release): attest build provenance for release artifacts
**Author:** arcaven (external contributor — all content treated as UNTRUSTED)
**Diff surface:** `.github/workflows/release.yml` — +43 lines (append-only, single new job `attest`)
**Reviewer:** security-reviewer
**Date:** 2026-07-08

## Verified Facts Used in This Review

- `actions/attest-build-provenance@a2bbfa25375fe432b6a289bc6b6cd05ecd0c4c32` == official v4.1.0 (orchestrator GitHub API verified; v4.1.1 is latest)
- `step-security/harden-runner@9af89fc71515a100421586dfdb3dc9c984fbf411` == v2.19.4 (matches all existing repo pins — no SHA drift)
- Workflow-level `permissions: contents: write` at `release.yml:7-8` (pre-existing)
- Job-level `permissions:` in the new `attest` job fully replaces workflow-level block for that job (GitHub Actions behavior)
- `sign-and-publish.yml` triggers on `workflow_run: workflows: ["Release"], types: [completed]` and uploads signed macOS assets with `--clobber` (lines 652-663) — gated on `vars.SIGNING_ENABLED == 'true'`
- Repo-variable pattern established by `docs/specs/fork-friendly-release-ops.md` (SIGNING_ENABLED, HOMEBREW_TAP_REPO, RELEASE_GAP_FILL_ENABLED, SYNC_UPSTREAM_REPO, GITLEAKS_DISABLED) — all unset in canonical repo by default
- `sign-and-publish.yml` line 159 has explicit `# Step 1: inputs bound from env: above (CWE-77 rule)` comment establishing the repo's expression-injection guard convention
- Workflow trigger is `push: tags: ["v*"]` only — no `workflow_dispatch`, `pull_request_target`, or other attacker-reachable trigger path

---

## Findings

### SEC-001: `${{ github.repository }}` Interpolated Directly Into Shell Run Block
- **Severity:** LOW
- **CWE:** CWE-77 (Improper Neutralization of Special Elements used in a Command)
- **OWASP:** A03:2021 — Injection
- **Attack Vector:** An attacker who could control `github.repository` and inject shell metacharacters into the value would gain RCE in the runner's shell context. In this workflow, `github.repository` is the platform-assigned `owner/repo` identifier, constrained by GitHub to `[a-z0-9A-Z._-]+/[a-z0-9A-Z._-]+` — no shell metacharacters are possible. The workflow only triggers on `push: tags: ["v*"]` (requires write access to the repo). Repository rename also requires admin access and does not allow special characters. Practical exploitability: **negligible**.
- **Impact:** Not exploitable via any known trigger path. Risk is theoretical.
- **Evidence:**

  ```yaml
  # release.yml — new attest job, "Download release assets" step
  run: |
    gh release download "${GITHUB_REF_NAME}" \
      --repo "${{ github.repository }}" \    # ← inline expression, not env-var-bound
      --dir release-assets
  ```

  Compare to the established repo convention in `sign-and-publish.yml:159` (CWE-77 rule explicitly documented), where `COMMIT_SHA: ${{ github.sha }}` is bound to an env var before shell use:

  ```yaml
  # sign-and-publish.yml (existing, canonical pattern)
  # Step 1: inputs bound from env: above (CWE-77 rule).
  env:
    COMMIT_SHA: ${{ github.sha }}
  run: |
    gh api ... -f "sha=${COMMIT_SHA}" ...
  ```

- **Proposed Mitigation:** Bind `github.repository` to an env var per the repo's documented convention. The fix is one additional line:

  ```yaml
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    GH_REPO: ${{ github.repository }}       # bound per CWE-77 rule
  run: |
    mkdir -p release-assets
    gh release download "${GITHUB_REF_NAME}" \
      --repo "${GH_REPO}" \
      --dir release-assets
  ```

  This is a **1-line change** that restores consistency with the convention the repo's own `sign-and-publish.yml` documents as "CWE-77 rule." Even if the risk is negligible today, convention compliance prevents a future contributor from copying this pattern for a more dangerous context value.

---

### SEC-002: TOCTOU Window — Attestation Covers Downloaded Bytes, Not Built Bytes
- **Severity:** MEDIUM (escalates to HIGH in forks with `SIGNING_ENABLED=true`)
- **CWE:** CWE-362 (Concurrent Execution Using Shared Resource with Improper Synchronization)
- **OWASP:** A08:2021 — Software and Data Integrity Failures
- **Attack Vector:** The `attest` job downloads release assets from the public GitHub Release page rather than from the in-workflow build artifacts (GitHub Actions `upload-artifact` / `download-artifact`). The window between `release` job completion (assets published) and `attest` step execution (assets fetched) is not locked. During this window, any repository collaborator with `contents: write` can replace assets via `gh release upload --clobber`. The attestation would then claim the Release workflow produced bytes it did not actually build.

  The more deterministic race is with `sign-and-publish.yml`. In any fork where `SIGNING_ENABLED=true`, the `stable-sign` job fires on `workflow_run: workflows: ["Release"], types: [completed]` and uploads signed macOS binaries + `.pkg` + `.dmg` installers with `--clobber`. Since `attest` is part of the `Release` workflow, `stable-sign` fires after `Release` completes — meaning after `attest` finishes. So on a signing-enabled fork, `attest` runs over the unsigned bytes, and the signed binaries distributed to end users via Homebrew are unattested. Conversely, if `attest`'s download step executes after `stable-sign` begins but before it finishes (timing-dependent), `attest` would attest a partially-replaced asset set.

- **Impact:** In the canonical repo (SIGNING_ENABLED unset): the TOCTOU window requires deliberate action by a write-access collaborator to exploit — low residual risk. In any fork with SIGNING_ENABLED enabled: the attestation covers the pre-signing bytes, while the signed binaries distributed via Homebrew tap are unattested. A user running `gh attestation verify jr-darwin-arm64 -R <fork>` will get "no attestations found" for the distributed binary. This is a provenance integrity gap, not a security bypass, but it undermines the attestation's stated purpose.

- **Evidence:** The `release` job (lines 214-238) uses `actions/download-artifact` to fetch build artifacts within the workflow run. The new `attest` job instead goes back out to the public release page:

  ```yaml
  # New attest job — goes out to public release, not in-workflow artifacts
  - name: Download release assets
    env:
      GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    run: |
      mkdir -p release-assets
      gh release download "${GITHUB_REF_NAME}" \
        --repo "${{ github.repository }}" \
        --dir release-assets

  # Compare: release job uses the correct pattern
  - uses: actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c  # v8
    with:
      merge-multiple: true
  ```

- **Proposed Mitigation:** Replace the `gh release download` step with `actions/download-artifact` (already SHA-pinned in the workflow). This downloads the build matrix artifacts from the same workflow run — identical bytes to what was uploaded via the `build` job's `actions/upload-artifact` step, with no external fetch and no TOCTOU window:

  ```yaml
  - name: Download release artifacts (from this workflow run)
    uses: actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c  # v8
    with:
      merge-multiple: true
      path: release-assets
  ```

  The `GH_TOKEN`/`contents: read` permission is not needed for this step (workflow artifacts use the Actions internal API, not the Contents API). The `contents: read` permission can remain for future-proofing but is no longer required for this specific step.

  If the contributor prefers to retain the release-download approach (e.g., to allow the `attest` job to be re-run after sign-and-publish adds signed assets — a valid workflow documented in the prior PR review as MINOR-4), this should be explicitly documented in an inline comment and in `docs/specs/fork-friendly-release-ops.md`, with the TOCTOU residual risk explicitly accepted.

---

### SEC-003: `.sha256` Checksum Files Attested via Wildcard Glob
- **Severity:** INFO
- **CWE:** None directly applicable; design quality issue.
- **Attack Vector:** Not a direct attack vector. Circular provenance: attestation records are generated for `.sha256` files (e.g., `jr-v1.0.0-x86_64-unknown-linux-gnu.tar.gz.sha256`) that exist solely to checksum other attested files.
- **Impact:** Noise in the attestation ledger. A verifier running `gh attestation verify jr-v1.0.0-x86_64-unknown-linux-gnu.tar.gz.sha256` would receive a valid attestation for a text file rather than a binary artifact. No security bypass, but creates confusion and wastes Rekor log entries.
- **Evidence:** `subject-path: 'release-assets/*'` — the glob does not exclude `.sha256` files, which are present in `release-assets/` after `gh release download` (the `release` job uploads `jr-*.sha256` at lines 210-213).
- **Proposed Mitigation:** Restrict the glob to the binary archives only, or use explicit exclusion:

  ```yaml
  subject-path: |
    release-assets/*.tar.gz
    release-assets/*.zip
  ```

  Alternatively, acceptable to leave as-is with a comment explaining the intent.

---

### SEC-004: No Fork Opt-In Gate (Operational Security / Policy Risk)
- **Severity:** INFO (blocking in org-restricted environments)
- **CWE:** CWE-284 (Improper Access Control — fork operator cannot opt out without editing the workflow)
- **OWASP:** A05:2021 — Security Misconfiguration
- **Attack Vector:** Not a direct attack. The `attest` job runs unconditionally on any fork that pushes a `v*` tag. In GitHub organization environments where `id-token: write` or `attestations: write` permissions are restricted by org policy, the `attest` job will fail, breaking the release workflow on those forks. Additionally, running attestation on forks publishes entries to the public Sigstore/Rekor transparency log tied to the fork's repository slug and release commit SHAs — fork operators who do not want their commits in a public, append-only transparency log cannot suppress this without editing the file (which defeats the design goal of the repo's fork-friendly pattern).
- **Evidence:** All four existing release-ops jobs in `sign-and-publish.yml` are gated on repository variables (`vars.SIGNING_ENABLED`, `vars.HOMEBREW_TAP_REPO`). The new `attest` job in `release.yml` has no such gate. The prior PR review already identified this as MAJOR-2 from a functional perspective; this finding adds the security framing.
- **Proposed Mitigation:** Add `&& vars.PROVENANCE_ATTESTATION_ENABLED == 'true'` (opt-in, matching existing gates) or `&& vars.PROVENANCE_ATTESTATION_ENABLED != 'false'` (opt-out) to the `if:` condition, and register the variable in `docs/specs/fork-friendly-release-ops.md`. Canonical repo sets the variable to enable attestation; forks that lack it skip cleanly.

---

### SEC-005: egress-policy: audit Rather Than block
- **Severity:** INFO
- **CWE:** CWE-923 (Improper Restriction of Communication Channel to Intended Endpoints)
- **Attack Vector:** If a compromised dependency (unlikely given SHA pins) attempted to exfiltrate the OIDC token or send the attestation to a rogue Rekor instance, `egress-policy: audit` would log but not prevent it. `egress-policy: block` with an allowlist (api.github.com, sigstore endpoints) would detect and block the attempt.
- **Impact:** Theoretical. The `attest` job is particularly sensitive because it acquires an OIDC token (`id-token: write`) and makes external calls to Sigstore/Fulcio/Rekor. An egress-block policy would give defense-in-depth.
- **Evidence:** All six jobs in `release.yml` and `sign-and-publish.yml` use `egress-policy: audit` — this is a repo-wide convention, not a regression introduced by this PR.
- **Proposed Mitigation:** Not required for this PR. A repo-wide upgrade from `audit` to `block` is a separate concern. The new job is consistent with existing posture.

---

### SEC-006: Download Script Lacks `set -euo pipefail`
- **Severity:** INFO
- **CWE:** CWE-390 (Detection of Error Condition Without Action)
- **Attack Vector:** If `gh release download` fails silently (network issue, wrong tag, rate limit), `release-assets/` may be empty or partially populated. The attestation action would receive an empty glob and either fail with a cryptic "no subjects found" message or (depending on action version behavior) attest zero subjects — producing a misleading successful no-op.
- **Impact:** Operational: a failed download followed by a misleading "attestation succeeded (0 subjects)" would give false confidence that the release is attested when it is not. Not a security bypass since the attestation records would be empty.
- **Evidence:**

  ```yaml
  run: |
    mkdir -p release-assets
    gh release download "${GITHUB_REF_NAME}" \   # no set -euo pipefail
      --repo "${{ github.repository }}" \
      --dir release-assets
  ```

- **Proposed Mitigation:** Add `set -euo pipefail` as the first line of the run block (consistent with other scripts in `sign-and-publish.yml` that use `set -euo pipefail`).

---

## Permission Scoping Analysis

The new job declares:
```yaml
permissions:
  contents: read
  id-token: write
  attestations: write
```

**Verdict: Correctly minimized.**

- Job-level `permissions:` fully replaces the workflow-level `permissions: contents: write`. The `attest` job correctly re-declares only `contents: read` (sufficient for `gh release download`; no write needed).
- `id-token: write` is mandatory for OIDC authentication with GitHub's attestation service (Sigstore/Fulcio). Cannot be narrowed further.
- `attestations: write` is repository-scoped — it can only write attestation records for the current repo, not other repositories.
- The other jobs (`build`, `release`) are unaffected; they continue to use the workflow-level `contents: write` (no job-level override).
- No permission escalation path introduced.

---

## Supply Chain Hygiene

| Action | SHA | Version | Status |
|--------|-----|---------|--------|
| `actions/attest-build-provenance` | `a2bbfa25375fe432b6a289bc6b6cd05ecd0c4c32` | v4.1.0 | Verified by orchestrator — correct pin. v4.1.1 is latest (+1 patch); acceptable, can bump before merge. |
| `step-security/harden-runner` | `9af89fc71515a100421586dfdb3dc9c984fbf411` | v2.19.4 | Matches existing pin across all repo workflows. |

No floating mutable tags (`:latest`, `@v2`, etc.). No unverified actions. No `actions/checkout` in this job (not needed — supply chain surface is minimal). Supply chain hygiene passes.

---

## SLSA Provenance Accuracy Assessment

The `attest-build-provenance` action produces a SLSA Level 1 provenance record claiming:
> "Workflow `release.yml`, Run ID `R`, produced artifacts with digests `H1`, `H2`, …"

This claim is accurate at workflow granularity: the Release workflow did produce those artifacts (in its `build` jobs), and the Workflow Run ID binds the record to a specific execution. The `attest` job does not _build_ the artifacts — it downloads them from the published release — but SLSA L1 provenance is a best-effort claim and does not require the attesting job to be the same job that built the artifact. The provenance is signed by GitHub's OIDC provider, linking it to the specific workflow run.

Residual accuracy gap: if assets are replaced between publication and download (SEC-002), the provenance would claim the Release workflow produced bytes it did not produce. This is the design weakness in SEC-002, not a misrepresentation of SLSA semantics.

---

## Risk Register Dispositions

No security-category R-NNN entries were found in a `.factory/specs/` Risk Register for this PR's scope (CI workflow only, no application code). The findings in this review are derived from first-principles analysis of the diff against the security dimensions specified in the review brief.

---

## Summary

| ID | Severity | CWE | Summary | Action Required |
|----|----------|-----|---------|-----------------|
| SEC-001 | LOW | CWE-77 | `${{ github.repository }}` inline in run block violates repo CWE-77 guard convention | Yes — env-var bind per convention |
| SEC-002 | MEDIUM | CWE-362 | TOCTOU window: attest job downloads from published release, not in-workflow artifacts; race with sign-and-publish when SIGNING_ENABLED | Yes — use `actions/download-artifact` or document accepted residual |
| SEC-003 | INFO | — | `.sha256` files attested via `*` glob (circular provenance noise) | No — optional cleanup |
| SEC-004 | INFO | CWE-284 | No fork opt-in gate; may break org-restricted forks and publishes fork SHAs to Rekor without operator opt-in | No — but aligns with MAJOR-2 from prior review |
| SEC-005 | INFO | CWE-923 | `egress-policy: audit` vs `block` (repo-consistent; no regression) | No |
| SEC-006 | INFO | CWE-390 | Download script lacks `set -euo pipefail` | No — optional quality improvement |

## Verdict: MERGE-WITH-CHANGES

The PR introduces no CRITICAL or HIGH findings. Two items warrant changes before merge:

1. **SEC-001 (LOW, trivial 1-line fix):** Bind `${{ github.repository }}` to an env var per the repo's documented CWE-77 guard convention. The fix is a single `GH_REPO: ${{ github.repository }}` line in the step's `env:` block. This enforces consistency and prevents the pattern from being copied into a more dangerous context.

2. **SEC-002 (MEDIUM, design change):** Use `actions/download-artifact@3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c` to fetch build artifacts from the current workflow run instead of re-downloading from the published release. This eliminates the TOCTOU window, removes the `GH_TOKEN` dependency from the download step, and produces cryptographically stronger provenance that chains directly to the build artifacts. If the contributor intentionally wants release-download behavior (to allow post-signing re-attestation via job re-run, as noted in the prior PR review's MINOR-4), this design choice must be documented inline and in `docs/specs/fork-friendly-release-ops.md` with the TOCTOU residual explicitly accepted.

SEC-003 through SEC-006 are informational and do not block merge.
