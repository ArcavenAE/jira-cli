Thanks @arcaven — this is a well-constructed contribution: both action SHAs check out against the upstream tags (we verified `a2bbfa2…` == `attest-build-provenance` v4.1.0 and the harden-runner pin matches our existing v2.19.4 pin exactly), the permissions are correctly job-scoped, and the fork-transparency intent is appreciated. We researched the placement question against GitHub's docs, SLSA guidance, and real-world pipelines before writing this up, and it points to a design change rather than a polish pass — details below.

### Required

**1. Move attestation into the build workflow, before upload — not download-and-attest after publish.**

GitHub's canonical pattern places `attest-build-provenance` in the workflow that *produced* the bytes, before distribution ([docs](https://docs.github.com/actions/security-for-github-actions/using-artifact-attestations/using-artifact-attestations-to-establish-provenance-for-builds), [blog](https://github.blog/security/supply-chain-security/configure-github-artifact-attestations-for-secure-cloud-native-delivery/)); jdx/mise's own releases attest in-workflow before upload too. Two concrete reasons this matters here:

- **The "attest the exact bytes users download" rationale is moot**: `gh attestation verify` (and mise's verifier) match on sha256 digest, not storage location. An attestation created from workspace artifacts verifies identically against the release-page download — softprops/action-gh-release uploads bytes verbatim, and GitHub now exposes `assets[].digest` as an independent cross-check. So the post-publish download buys nothing…
- **…and costs a real window (TOCTOU, CWE-362)**: the job attests whatever is on the release page at download time. On a signing-enabled fork this race is deterministic — `sign-and-publish.yml` fires on the same workflow completion and `--clobber`s re-signed darwin assets, so the job can attest bytes users never receive. It also downgrades the claim from builder provenance to consumer re-attestation (weaker SLSA Build L2 semantics — the attesting workflow didn't build the subjects).

Suggested shape: a fan-in job with `actions/download-artifact` (SHA-pinned, `merge-multiple: true`) that attests, sitting between the build matrix and the `release` upload job — or attest per-matrix-job on the built files. Either eliminates the window, drops the `GH_TOKEN`/`contents: read` need in that step, and makes the provenance claim exact.

**2. Add a fork opt-in gate, matching this repo's release-ops convention.**

Every other release-ops job here is gated on a repository variable so forks carry the file verbatim as a no-op (`vars.SIGNING_ENABLED`, `HOMEBREW_TAP_REPO`, `RELEASE_GAP_FILL_ENABLED`, `SYNC_UPSTREAM_REPO` — see `docs/specs/fork-friendly-release-ops.md`). As written, the attest job runs unconditionally on any fork's `v*` tag: it fails hard where attestations aren't available (private forks need GitHub Enterprise Cloud; GHES doesn't support attestations at all; org policies can withhold `id-token: write`) and publishes fork commit SHAs to the public Rekor transparency log without opt-in. Please gate it (e.g. `vars.ATTESTATIONS_ENABLED == 'true'`) and add the row to the spec's variables table.

**3. Bind `github.repository` through `env:` rather than inline `${{ }}` in the `run:` block.**

Not exploitable here (`github.repository` is platform-constrained), but this repo enforces the env-binding rule for expressions in shell (see the `CWE-77 rule` comments in `sign-and-publish.yml`), and CI review will keep flagging it. One-line change — and it disappears entirely if you adopt the download-artifact design from item 1.

### Recommended

**4.** Exclude `.sha256` files from `subject-path` — the archive attestations already cover integrity; attesting checksum files is circular noise. (`release-assets/*.tar.gz` + `*.zip`, or a files list.)

**5.** Bump to v4.1.1 (current latest, 2026-06-26) while you're in here — SHA-pin it the same way; we'll verify the pin on re-review.

**6.** Add an inline comment marking the coverage boundary for signed macOS assets: the darwin bare binaries and `.pkg`/`.dmg` that `sign-and-publish.yml` uploads have *different digests* post-signing, so they need their own attest step in that workflow (after codesign/notarize, before upload). Keeping that out of this PR is a fine scope call — but the boundary should be visible in the code, not just the PR description. A follow-up PR gated on the same variable would complete the story.

**7.** A short CHANGELOG entry under `[Unreleased] > Added` — provenance verification is a user-facing capability (`gh attestation verify`, mise's native verification).

### Small notes

- `set -euo pipefail` in any remaining download script so an empty asset dir fails loudly (moot under item 1).
- The `!cancelled() && needs.release.result == 'success'` guard is fine; the inline comment slightly overstates what it covers (a cancel mid-attest can still interrupt submission) — no change needed.

The mechanics of what you wrote are solid, and with the placement moved in-workflow plus the fork gate this is a clear improvement to the release pipeline. Happy to re-review quickly. This also pairs with #573 — once this lands, the README's attestation paragraph there becomes accurate with a small rewording (commented separately on that PR).
