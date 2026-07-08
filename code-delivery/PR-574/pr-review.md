# PR #574 Review — ci(release): attest build provenance for release artifacts

**Reviewer:** fresh-context PR reviewer (Opus, no factory-artifact visibility)
**Base:** develop @ current tip (unchanged since PR's merge base — orchestrator verified)
**Author:** external contributor `arcaven` (treated as untrusted)
**Diff surface:** `.github/workflows/release.yml` — +43 lines, append-only, single new job `attest`.

## Verdict: **COMMENT**

Well-scoped, competently written contribution. The mechanics of the added job are correct and the pinning/hardening posture matches repo convention. The two "MAJOR" items below are not defects in what the PR did — they are gaps in what the PR *chose to leave undone*, and both are already flagged in the PR description ("out of scope" for the darwin re-sign, and unstated for the fork opt-in gate). Whether they block merge is a project-policy call, not a correctness call. I'm returning COMMENT rather than REQUEST_CHANGES because:
- the delivered code works as designed;
- the honest scope statement in the PR body is respectable;
- fixing MAJOR-1 changes design (attest sits in `sign-and-publish.yml` too or downstream), which is a follow-up conversation.

If project policy is "every new release-workflow job must respect the `vars.*_ENABLED` gate convention documented in `docs/specs/fork-friendly-release-ops.md`," then MAJOR-2 becomes REQUEST_CHANGES.

---

## Findings

### MAJOR-1 — macOS signed binaries and installers ship UNATTESTED (design gap, honestly declared but load-bearing)

**File:** `.github/workflows/release.yml` (new `attest` job); interaction with `.github/workflows/sign-and-publish.yml` `stable-sign` (existing).

**What happens on a canonical stable release today, with this PR merged:**

1. `release.yml` builds all targets, `release` job uploads `jr-<tag>-<target>.tar.gz` (+ `.zip`, `.sha256`) to the GitHub Release.
2. New `attest` job downloads every asset from the release and attests it. Provenance is now attached to the `.tar.gz` files (unsigned darwin binaries inside).
3. Because `attest` is part of the `Release` workflow, the workflow only enters "completed" state after `attest` finishes.
4. `sign-and-publish.yml`'s `stable-sign` fires on `workflow_run: workflows: ["Release"], types: [completed]`. It:
   - downloads the darwin `.tar.gz` from the release,
   - extracts, re-signs, notarizes, staples,
   - uploads **new** assets to the same release (`jr-darwin-arm64`, `jr-darwin-amd64`, `jr-{arm64,amd64}.{pkg,dmg}`, and their `.sha256`s) via `gh release upload ... --clobber` (see `sign-and-publish.yml:655-663`).
5. None of the files added in step 4 have a build-provenance attestation.

**Why this matters:** `sign-and-publish.yml`'s Homebrew tap job (`stable-homebrew`) publishes formulas that install the **signed bare binaries** `jr-darwin-arm64` / `jr-darwin-amd64` (see `sign-and-publish.yml:736-737` for download, `:764-765` for SHA256 pinning in the formula). That is the primary macOS distribution path for `jr`. `.pkg`/`.dmg` installers are the second. Both are unattested with this PR alone; a user who runs `gh attestation verify jr-darwin-arm64 -R <repo>` will get "no attestations found."

**Failure scenario:** end user installs `jr` via `brew install <tap>/jr`, then runs `gh attestation verify $(brew --prefix jr)/bin/jr -R arcaven/jira-cli` — verification fails, even though provenance was claimed by this PR. The Linux/Windows `.tar.gz`/`.zip` paths verify correctly.

**Suggestion (non-blocking, follow-up scope is fine):** either
- (a) mirror the `attest` step at the end of `sign-and-publish.yml` `stable-sign` (and `alpha-sign`) after `Upload signed artifacts to release`, or
- (b) add a repo-side follow-up issue and reference it in an inline comment in this PR's new job so future readers know the coverage boundary is intentional, e.g. `# NOTE: signed darwin binaries and .pkg/.dmg installers added by sign-and-publish.yml are attested separately in that workflow (see issue #NNN) — this job covers the .tar.gz/.zip payloads uploaded by release.yml.`

The PR description says the darwin re-sign is "deliberately out of scope"; that is a defensible scope decision, but the resulting hole should be visible from the code, not just from the PR narrative that scrolls off after merge.

---

### MAJOR-2 — no fork opt-in gate; departs from the codified `docs/specs/fork-friendly-release-ops.md` convention

**File:** `.github/workflows/release.yml:240-241` (the new job's `if:` block).

**Convention this PR does not follow:** `docs/specs/fork-friendly-release-ops.md` §Components + §Repository variables tabulates all release-ops jobs and their `vars.*_ENABLED` (or presence-of-variable) gates: `SIGNING_ENABLED`, `HOMEBREW_TAP_REPO`, `RELEASE_GAP_FILL_ENABLED`, `SYNC_UPSTREAM_REPO`, `GITLEAKS_DISABLED`. The stated design goal is "no-ops by default" so a fork can carry the file verbatim and opt in via a variable. See `sign-and-publish.yml:33` `if: github.event_name == 'push' && vars.SIGNING_ENABLED == 'true'` for the canonical shape.

**What this PR adds instead:** `if: !cancelled() && needs.release.result == 'success'` — no fork opt-in gate. On any fork that pushes a `v*` tag, the attest job will run and publish an entry to public Sigstore/Rekor tied to the fork's repository slug.

**Failure scenarios / friction on forks:**
1. A private fork with GitHub's Artifact Attestations feature disabled at the org level → attest job fails, breaks the release workflow, downstream `stable-sign` never fires.
2. A fork owner who does not want their release commit SHAs enumerated in a public transparency log (Rekor) → cannot suppress the behavior short of editing the workflow (defeats the purpose of the "identical files in fork and upstream" design in `fork-friendly-release-ops.md`).
3. A fork whose default `GITHUB_TOKEN` permissions are restricted by org policy such that `id-token: write` or `attestations: write` cannot be granted → same as (1).

The PR description notes it was tested on the author's personal fork with `gh attestation verify` + `mise`. That is one data point of fork compatibility, not a proof of universal fork-safety across GitHub's permission-policy matrix.

**Suggestion:** gate the job on a new repo variable (e.g. `vars.PROVENANCE_ATTESTATION_ENABLED == 'true'`) and update `docs/specs/fork-friendly-release-ops.md` §Components + §Repository variables to list it. Canonical repo sets the variable → provenance is attached; unset forks skip cleanly, matching the existing four gates. Alternative: `vars.PROVENANCE_ATTESTATION_ENABLED != 'false'` (default-on with an opt-out) if the maintainer prefers coverage over strict parity with the four opt-in gates — but the direction should be a deliberate choice and documented in the spec.

---

### MINOR-1 — `v4.1.0` pin is one patch behind current `v4.1.1` (2026-06-26)

**File:** `.github/workflows/release.yml:277` (the `actions/attest-build-provenance@a2bbfa2… # v4.1.0` step).

Not a defect — the SHA is a correct match to the upstream v4.1.0 tag (orchestrator verified). But since this PR is landing new machinery, picking up the latest patch of the action at the same time avoids an immediate follow-up bump. Suggest updating to `v4.1.1` before merge (verify the SHA the same way).

---

### MINOR-2 — `GITHUB_REF_NAME` env var vs `${{ github.ref_name }}` — style inconsistency with the rest of the workflow

**File:** `.github/workflows/release.yml:270` (the `Download release assets` step).

The rest of `release.yml` uses `${{ github.ref_name }}` (workflow context expression), e.g. line 71 `jr-${{ github.ref_name }}-${{ matrix.target }}.tar.gz`. The new step uses `"${GITHUB_REF_NAME}"` (shell env var — GitHub auto-exports it). Both are correct; both produce the tag name because the workflow's only trigger is `push: tags: ["v*"]` (release.yml:4-5). Mixed styling in a single workflow is a nit — align to `${{ github.ref_name }}` for consistency, or (defensibly) argue that the shell-env form is better because it survives an `env-bind-then-run` refactor without expression re-parsing. Either way, one style per workflow.

---

### MINOR-3 — `!cancelled() && needs.release.result == 'success'` is defensible but slightly redundant

**File:** `.github/workflows/release.yml:243-245`.

`needs.<job>.result == 'success'` already implies the workflow was not cancelled at the moment the dependency evaluated (a cancelled workflow's job result is `cancelled`, not `success`). `!cancelled()` here adds belt-and-braces protection against a mid-run cancel between `release` finishing and `attest` starting — that window is small but non-zero. Acceptable as written; not worth a change. Flagging only because the comment claims `!cancelled()` "skips a partial attestation if the workflow is cancelled mid-run," which is technically true for the *scheduling* moment but overstates the coverage — once the attest step's `actions/attest-build-provenance` starts running, a workflow cancel will interrupt it and may leave an incomplete attestation submission open at Rekor. Not fixable via the `if:` clause; note only.

---

### MINOR-4 — behavior on re-run of `attest` job alone is undocumented but benign

**File:** `.github/workflows/release.yml` (whole new job).

If an operator re-runs the failed `attest` job after `sign-and-publish.yml` has already added signed darwin binaries + .pkg/.dmg installers to the release, `gh release download` will pick up ALL current release assets (including the signed ones) and attest them. This is actually a valid workaround for MAJOR-1 — but it's undocumented and requires the operator to know about the workflow-run ordering interaction. Would be worth a one-line runbook note in `docs/specs/fork-friendly-release-ops.md` (e.g. "to cover signed macOS assets, re-run the Release workflow's attest job after Sign & Publish completes").

Duplicate attestations: benign. `attest-build-provenance` publishes immutable entries to Rekor; multiple attestations for the same subject digest coexist and all verify successfully. Not a concern.

---

### MINOR-5 — partial prior-run assets on the release are attested transparently

**File:** `.github/workflows/release.yml` (whole new job).

`gh release download` (without `--pattern`) pulls every asset currently on the release. If a previous partial run of the Release workflow left stale assets and the current run's `release` job re-uploaded on top, `gh release download` will fetch both stale and current — and attest both. The attestations are honest (each is a valid statement about the bytes at that digest), but a downstream verifier cannot tell "this asset was intended for release v0.6.0" from "this asset was left over from a partial run of a prior workflow." Softprops's `action-gh-release` handles this by allowing files to be added; it doesn't purge unlisted assets from a prior run.

Not blocking. Softprops behavior + the `stable-sign` workflow_run interaction mean this class already exists for the wider release process; the attest job faithfully mirrors reality.

---

### NIT-1 — `contents: read` comment is technically imprecise on private forks

**File:** `.github/workflows/release.yml:255-256`.

Comment says "`contents: read` is enough for `gh release download`." True on public repos. On private repos (some forks), `gh release download` may require higher scope depending on release visibility settings. The default `GITHUB_TOKEN` in Actions on a private repo does have `contents: read` sufficient for private-release download, so this is fine in practice — flagging only as a precision note. Same class of assumption as the rest of the workflow, which is public-repo-first.

---

### NIT-2 — `# 'attestations: write' is NEVER inherited — must be declared on the job` — phrasing

**File:** `.github/workflows/release.yml:257-259`.

Accurate but oddly-emphatic. GitHub's rule is simpler: any job that declares its own `permissions:` block **fully replaces** the workflow-level block (not just for `attestations`). So the `contents: read` here also replaces the workflow's `contents: write`. Suggest neutral phrasing: `# Job-level 'permissions:' fully replaces the workflow-level 'contents: write'; all needed scopes must be re-declared here.` — but subjective.

---

### NIT-3 — no CHANGELOG entry

Neither `CHANGELOG.md` nor any docs mention that stable release artifacts now carry build provenance attestations. A user-facing capability that supports third-party verification via `gh attestation verify` / `mise` / Sigstore is worth an `Unreleased` entry under `Added` or a short paragraph in `README.md` under an installation-verification section. Not a blocker; commonly added in the same PR that introduces the capability.

---

## Assessment of PR description accuracy

| Claim in PR body | Verdict |
|---|---|
| Separate-job design attests exact downloaded bytes | Accurate. |
| `!cancelled()` guard | Accurate; see MINOR-3 for a small over-claim about coverage. |
| Job-scoped permissions (`contents: read`, `id-token: write`, `attestations: write`) | Accurate. |
| Fork-transparent (no hardcoded owner) | Accurate for `${{ github.repository }}` usage; misleading in the sense that "fork-transparent" also implies "no-op or safely opt-out on forks," which this job does not achieve — see MAJOR-2. |
| `sign-and-publish.yml` re-signed darwin assets deliberately out of scope | Accurate as a scope statement; understates the coverage gap for macOS end users — see MAJOR-1. |
| Tested on personal fork with `gh attestation verify` + `mise` | Not independently verified; accepted at face value. Confirms the happy path on at least one fork. |

---

## Verified facts used in this review

- Trigger: `on: push: tags: ["v*"]` — `GITHUB_REF_NAME` is always the pushed tag; no `workflow_dispatch` path to break the assumption.
- `needs: release` matches the job id at `release.yml:214`.
- Release is created with `softprops/action-gh-release@v3.0.1` and `draft` is unset → default `draft: false` → `gh release download` finds it.
- `harden-runner@9af89fc… # v2.19.4` SHA and `attest-build-provenance@a2bbfa2… # v4.1.0` SHA match upstream tags (orchestrator pre-verified).
- Job-level `permissions:` fully replaces workflow-level `permissions: contents: write`; the new job correctly re-declares `contents: read` alongside the write scopes it needs.
- `sign-and-publish.yml stable-sign` fires on `workflow_run: workflows: ["Release"], types: [completed]` and uploads signed darwin bare-binaries + .pkg/.dmg + .sha256 with `--clobber` after the Release workflow completes (so after `attest`). Those assets are not covered by this PR.
- `docs/specs/fork-friendly-release-ops.md` establishes a repo-variable opt-in gate convention for release-ops workflows; this PR does not follow that convention.
