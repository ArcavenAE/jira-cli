---
document_type: phase-f2-spec-delta
story_bundle: S-FORK-OPS-BACKFILL
stories:
  - S-FORK-OPS-BACKFILL-1
  - S-FORK-OPS-GITLEAKS-DOC-1
feature: fork-ops-backfill-parity
created: 2026-06-18
revised: 2026-06-18
revision_reason: "Pass 1 adversarial review — H1 (draft-release edge case), H2 (prerelease-flag asymmetry), M1 (citation form), M2 (rustup target add no-op note), M3 (build job CWE-77 in-scope), M4 (concurrent dispatch note), M5 (softprops over-claim softened). F5 checklist updated with H1 draft-detection item. Pass 2 adversarial review — O1 (Unix step-name parity claim softened), O2 (Unix embedded-OAuth parity gap scoped as pre-existing out-of-scope), O3 (GITLEAKS_DISABLED if: literal corrected to full condition)."
f1_outcome: APPROVED
drift_items_resolved:
  - FORK-OPS-BACKFILL-WIN-TARGET
  - FORK-OPS-BACKFILL-DESTRUCTIVE
  - FORK-OPS-GITLEAKS-DOC
traces_to:
  - ".factory/phase-f1-delta-analysis/delta-analysis-fork-ops-backfill-1.md"
  - ".factory/phase-f2-spec-evolution/adversarial-spec-delta-review-pass1.md"
  - ".factory/phase-f2-spec-evolution/adversarial-spec-delta-review-pass2.md"
---

# Phase F2 Spec Delta: Fork-Ops Backfill Parity (S-FORK-OPS-BACKFILL)

## Summary

F1 delta analysis (APPROVED) determined that zero new BCs, NFRs, or VPs are needed
for this infrastructure bundle. The changes are confined to:

1. `.github/workflows/backfill-release.yml` — Story 1 (S-FORK-OPS-BACKFILL-1)
2. `docs/specs/fork-friendly-release-ops.md` — Story 2 (S-FORK-OPS-GITLEAKS-DOC-1)
3. `CLAUDE.md` — Story 2 (S-FORK-OPS-GITLEAKS-DOC-1)

This document is the normative implementation contract for F4. It specifies the
exact changes required in each file, the invariants those changes must satisfy,
and the security constraints that govern the implementation.

---

## Story 1 — S-FORK-OPS-BACKFILL-1: `backfill-release.yml` Fixes

### Drift Item WIN-TARGET: Add `x86_64-pc-windows-msvc` Build Target

**File:** `.github/workflows/backfill-release.yml`

**Root cause:** `jobs.build.strategy.matrix.include` contains four targets; the
fifth entry present in `release.yml` (`jobs.build.strategy.matrix.include`,
`target: x86_64-pc-windows-msvc`) is missing.

**Required matrix change:** Add the following as the fifth `include` row, after
the four existing entries:

```yaml
- target: x86_64-pc-windows-msvc
  os: windows-latest
```

#### Unix Package Step — make conditional

The existing `Package` step (`jobs.build.steps[name=Package]`) currently has no
`if:` condition. It must become Unix-only:

```yaml
# BEFORE
- name: Package

# AFTER
- name: Package
  if: runner.os != 'Windows'
```

The step body is unchanged. The existing `env: RELEASE_TAG: ${{ inputs.tag }}`
binding on this step already satisfies CWE-77 — do not alter it.

#### Add Package (Windows) Step

The step body mirrors `release.yml` `jobs.build.steps[name="Package (Windows)"]`
with one change: bind `inputs.tag` via `env:` per the CWE-77 default-deny rule
(see CWE-77 note in "Unix Package Step" above).

**Step naming note:** `release.yml` names its Unix packaging step `Package (Unix)`.
`backfill-release.yml`'s existing Unix step is named `Package` and MUST retain that
name — do NOT rename it to match `release.yml`. Only the step bodies are mirrored;
step names in `backfill-release.yml` follow the existing file's convention.

```yaml
- name: Package (Windows)
  if: runner.os == 'Windows'
  shell: pwsh
  env:
    RELEASE_TAG: ${{ inputs.tag }}
  run: Compress-Archive -Path "target/${{ matrix.target }}/release/jr.exe" -DestinationPath "jr-${env:RELEASE_TAG}-${{ matrix.target }}.zip"
```

Note: `${{ matrix.target }}` is permitted inline — `matrix.*` values are
author-controlled static literals, explicitly excluded from the env-binding
requirement per `fork-friendly-release-ops.md` §"No inline context data in shell
run-blocks" (`matrix.*` and `runner.*` are NOT subject to this rule).

#### Add Checksum (Windows) Step

Mirror `release.yml` `jobs.build.steps[name="Checksum (Windows)"]`, substituting
`inputs.tag` binding for `github.ref_name`:

```yaml
- name: Checksum (Windows)
  if: runner.os == 'Windows'
  shell: bash
  env:
    RELEASE_TAG: ${{ inputs.tag }}
  run: sha256sum "jr-${RELEASE_TAG}-${{ matrix.target }}.zip" > "jr-${RELEASE_TAG}-${{ matrix.target }}.zip.sha256"
```

#### Add Smoke Test (Windows) Step

Mirror `release.yml` `jobs.build.steps[name="Smoke test (Windows)"]` verbatim.
The smoke test does not reference `inputs.tag`, so no env-binding change is needed:

```yaml
- name: Smoke test (Windows)
  if: runner.os == 'Windows'
  shell: pwsh
  run: |
    $ErrorActionPreference = 'Stop'   # Catches Set-Location failure (directory missing)
    Set-Location "target/${{ matrix.target }}/release"
    # Use `.\jr.exe` (explicit current-directory prefix) — PowerShell does NOT
    # search CWD for executables without it, unlike cmd.exe.
    # NOTE: $ErrorActionPreference does NOT catch non-zero exit from native
    # executables in PS7; the explicit LASTEXITCODE check below is load-bearing.
    .\jr.exe --version
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
```

#### Add Embedded OAuth Verification (Windows) Step

Mirror `release.yml` `jobs.build.steps[name="Embedded OAuth verification (Windows)"]`
verbatim. The step uses only `matrix.target` and `secrets.*` (bound via `env:`),
no `inputs.*`:

```yaml
- name: Embedded OAuth verification (Windows)
  if: runner.os == 'Windows'
  shell: pwsh
  env:
    # Pass the secret-presence flag in via env so the PowerShell check below
    # can short-circuit cleanly. Forks (where Actions secrets aren't
    # available) get OAUTH_CLIENT_ID == '' here, so we skip the smoke.
    HAS_EMBED_SECRETS: ${{ (secrets.OAUTH_CLIENT_ID != '' && secrets.OAUTH_CLIENT_SECRET != '') && 'yes' || 'no' }}
  run: |
    $ErrorActionPreference = 'Stop'
    if ($env:HAS_EMBED_SECRETS -ne 'yes') {
      Write-Host "Skipping embedded-creds smoke: OAUTH_CLIENT_ID/_SECRET not configured."
      Write-Host "(Fork build, or upstream secrets are missing — release will ship the unbranded BYO binary.)"
      exit 0
    }
    $f = Get-ChildItem -Path "target/${{ matrix.target }}/release/build" `
          -Filter 'embedded_oauth.rs' -Recurse | Select-Object -First 1
    if (-not $f) { Write-Error 'embedded_oauth.rs not found at expected build output path'; exit 1 }
    $content = Get-Content $f.FullName -Raw
    if ($content -match 'EMBEDDED_ID\s*:\s*Option.*=\s*None') {
      Write-Error 'embedded_oauth.rs has EMBEDDED_ID = None — build.rs did not see JR_BUILD_OAUTH_CLIENT_ID'
      exit 1
    }
    if ($content -match 'EMBEDDED_SECRET_XOR\s*:\s*Option.*=\s*None') {
      Write-Error 'embedded_oauth.rs has EMBEDDED_SECRET_XOR = None — build.rs did not see JR_BUILD_OAUTH_CLIENT_SECRET'
      exit 1
    }
    Write-Host "embedded_oauth.rs at $($f.FullName) has populated constants"
```

#### Scope note: Unix embedded-OAuth verification

`release.yml` also has a Unix embedded-OAuth verification step
(`jobs.build.steps[name="Verify embedded OAuth app present"]`). The current
`backfill-release.yml` has no Unix equivalent, nor does WIN-TARGET add one.
This is a **pre-existing parity gap that is OUT OF SCOPE for WIN-TARGET**. F4
must not add a Unix embedded-OAuth step under this story; F5 must not flag its
absence as an omission introduced by this change.

#### Note: Defensive `rustup target add` — do NOT optimize away

`jobs.build.steps[name="Ensure target installed (defensive)"]` (the
`rustup target add ${{ matrix.target }}` step, conditioned on `!matrix.use_cross`)
runs a harmless no-op for `x86_64-pc-windows-msvc` on a `windows-latest` runner,
because that triple is the runner's native target and is already installed.
F4 MUST NOT remove this step from the Windows matrix row. It is required for parity
with `release.yml` and exists because `rust-toolchain.toml` (which pins
`channel = "stable"`) overrides the toolchain installed by `dtolnay/rust-toolchain`,
leaving non-cross native targets potentially without the target component — the
defensive `rustup target add` is the safeguard. Removing it would be a latent
failure risk whenever `rust-toolchain.toml` channel/component configuration changes.

#### Update Upload Artifact Step

`jobs.build.steps[name="Upload artifact"]` currently uploads only `jr-*.tar.gz`
and `jr-*.sha256`. Add `jr-*.zip`:

```yaml
# BEFORE
          path: |
            jr-*.tar.gz
            jr-*.sha256

# AFTER
          path: |
            jr-*.tar.gz
            jr-*.zip
            jr-*.sha256
```

#### Step Ordering in the `build` Job

The complete ordering of new steps relative to existing steps MUST be:

1. `Harden the runner` (existing)
2. `actions/checkout` (existing, with `ref: ${{ inputs.tag }}`)
3. `Install Rust` (existing)
4. `Ensure target installed (defensive)` (existing, `if: !matrix.use_cross`)
5. `Install cross` (existing, `if: matrix.use_cross`)
6. `Build` (existing)
7. `Package` (existing, now with `if: runner.os != 'Windows'`)
8. `Package (Windows)` (NEW, `if: runner.os == 'Windows'`)
9. `Checksum (Windows)` (NEW, `if: runner.os == 'Windows'`)
10. `Smoke test (Windows)` (NEW, `if: runner.os == 'Windows'`)
11. `Embedded OAuth verification (Windows)` (NEW, `if: runner.os == 'Windows'`)
12. `Upload artifact` (existing, with `jr-*.zip` added to path)

This ordering mirrors the step sequence in `release.yml` and is load-bearing for
reviewers cross-checking parity.

---

### Drift Item DESTRUCTIVE: Replace delete+create with check-then-upsert

**File:** `.github/workflows/backfill-release.yml`
**Job:** `jobs.release`
**Step:** `jobs.release.steps[name="Create or update GitHub Release"]`

**Current delete+create block (REMOVE):**

```yaml
          # Delete existing release if present (keeps the tag)
          gh release delete "$TAG" --yes --repo "${{ github.repository }}" 2>/dev/null || true

          gh release create "$TAG" \
            --repo "${{ github.repository }}" \
            --title "$TAG" \
            --generate-notes \
            $PRERELEASE \
            jr-*.tar.gz \
            jr-*.sha256
```

**Replacement (AFTER WIN-TARGET addition, so `jr-*.zip` must appear in both branches):**

```bash
          if gh release view "$TAG" --repo "${{ github.repository }}" >/dev/null 2>&1; then
            # Release already exists — upload/replace assets without touching notes or flags
            DRAFT_STATUS=$(gh release view "$TAG" \
              --repo "${{ github.repository }}" \
              --json isDraft --jq '.isDraft')
            if [ "$DRAFT_STATUS" = "true" ]; then
              echo "::warning::Release $TAG is a draft. Uploading assets but NOT publishing — curator must manually publish."
            fi
            gh release upload "$TAG" \
              --repo "${{ github.repository }}" \
              --clobber \
              jr-*.tar.gz \
              jr-*.zip \
              jr-*.sha256
          else
            # No release yet — safe to create with auto-generated notes
            gh release create "$TAG" \
              --repo "${{ github.repository }}" \
              --title "$TAG" \
              --generate-notes \
              $PRERELEASE \
              jr-*.tar.gz \
              jr-*.zip \
              jr-*.sha256
          fi
```

**Invariants this replacement enforces:**

1. **Notes preservation:** `--generate-notes` is applied ONLY on initial release
   creation (the `else` branch). If a release already exists — including one with
   curator-edited notes — those notes are never overwritten.
2. **Silencer removed:** The `|| true` on the old `gh release delete` line is
   removed entirely. Errors in the upsert path surface and fail the step cleanly.
3. **Asset completeness:** `jr-*.zip` appears in BOTH the upload branch and the
   create branch. Adding it to only one branch introduces an asset-completeness bug
   on the other path.
4. **CWE-77 allowlist:** `${{ github.repository }}` is on the CWE-77 format-safe
   allowlist (`fork-friendly-release-ops.md` §"Allowlist") — its existing inline
   usage in this step requires no env-binding remediation.
5. **Tag env-binding:** `$TAG` is already bound from `RELEASE_TAG` via the
   step-level `env:` block in `jobs.release.steps[name="Create or update GitHub Release"].env`.
   Do not inline `${{ inputs.tag }}` directly in the `run:` body.
6. **Draft-release handling:** `gh release view` returns exit 0 for both published
   and draft releases. When an existing release is a draft, the upload branch
   uploads assets via `--clobber` but does NOT set `--draft false`. The draft→
   published flip is curator intent — the workflow must not override it. A
   `::warning::` annotation is emitted so the operator is notified that the release
   remains unpublished after the run.
7. **Prerelease-flag asymmetry (intentional):** The `upload --clobber` branch does
   NOT pass `$PRERELEASE`. This is intentional: a re-run must not silently flip a
   curator-set stable release to prerelease or vice versa. Only the `create` branch
   sets the prerelease flag from the `*-*` tag-name heuristic, which applies only
   when no prior release exists.
8. **Concurrent-dispatch behavior:** With the `|| true` silencer removed, two
   concurrent `workflow_dispatch` runs for the same tag may both see no existing
   release and both attempt `gh release create`. The loser fails loudly (non-zero
   exit, visible in Actions UI). This is intended — a re-run will then find the
   release exists and take the upload path. The `release-gap-fill.yml` dispatcher
   throttle (`max` input, default 5/run, sequential dispatch) makes same-tag
   concurrent runs rare in the scheduled path; `workflow_dispatch` remains subject
   to operator error.

**Behavioral analogy with `release.yml`:** `release.yml` uses
`softprops/action-gh-release` with `generate_release_notes: true`. The observable
outcome is behaviorally analogous — notes are generated only when no release
already exists — but the internal mechanism of the action is not asserted to be
identical to the explicit `view`-then-branch bash idiom above. The bash idiom
stands on its own correctness.

**Edge case — release exists but has no assets (partial prior run):** the `exists`
branch correctly handles this: `gh release upload --clobber` on a release with no
assets uploads the assets and exits 0. This path also covers a re-run after a
partial failure in the build job.

---

### CWE-77 Compliance Summary for Story 1

All new `run:` blocks that reference `inputs.tag` bind it via `env: RELEASE_TAG:
${{ inputs.tag }}` and reference it as `"${RELEASE_TAG}"` (bash) or
`"${env:RELEASE_TAG}"` (PowerShell). This is consistent with the existing Unix
Package step (`jobs.build.steps[name=Package].env`) and is required by
`fork-friendly-release-ops.md` §"No inline context data in shell run-blocks".

The `build` job is itself in-scope for `scripts/check-signing-workflow-injection.sh`
via criterion (a): it references `secrets.OAUTH_CLIENT_ID` and
`secrets.OAUTH_CLIENT_SECRET` in `jobs.build.steps[name=Build].env`. All new
Windows `run:` blocks in the build job are compliant: they reference only
`matrix.target` inline (author-controlled, explicitly exempt per the spec) and
bind `RELEASE_TAG` via `env:`. No new violations are introduced by the WIN-TARGET
changes.

The F5 adversarial pass MUST verify that `scripts/check-signing-workflow-injection.sh
--self-test` passes with the new Windows steps present.

---

## Story 2 — S-FORK-OPS-GITLEAKS-DOC-1: Documentation-Only Fixes

### Drift Item GITLEAKS-DOC: `fork-friendly-release-ops.md` Variables Table

**File:** `docs/specs/fork-friendly-release-ops.md`
**Location:** Repository variables table (`## Repository variables` section)

**Current table (four rows):**

```markdown
| Variable | Effect when set | Canonical repo |
|---|---|---|
| `SIGNING_ENABLED` | `'true'` enables the sign/notarize jobs | unset |
| `HOMEBREW_TAP_REPO` | `owner/homebrew-name` tap repo to publish formulas to; also enables the homebrew jobs | unset |
| `RELEASE_GAP_FILL_ENABLED` | `'true'` enables the daily gap-fill schedule | unset |
| `SYNC_UPSTREAM_REPO` | `owner/repo` to merge from on a schedule (forks only) | unset |
```

**Required addition — append as fifth row:**

```markdown
| `GITLEAKS_DISABLED` | `'true'` disables the gitleaks secret-scan job in `ci.yml`; for forks that cannot obtain a gitleaks org/commercial license or prefer an alternative scanner | unset |
```

No other changes to this file. The table's explanatory prose immediately below it
(`This is the same fail-safe pattern as vars.JR_E2E_ENABLED...`) is unchanged.

---

### Drift Item GITLEAKS-DOC: `CLAUDE.md` AI Agent Notes Entry

**File:** `CLAUDE.md`
**Section:** AI Agent Notes
**Placement:** Alongside the `JR_E2E_ENABLED` entry (same repo-variable-gate doc
pattern established by S-E2E-FORK-1).

**Required addition:**

```markdown
- **`GITLEAKS_DISABLED`** — GitHub Actions **repository variable**
  (`vars.GITLEAKS_DISABLED`). Skips the gitleaks secret-scan job on
  pull-request events when set to `'true'` (`ci.yml` `jobs.security.if:
  github.event_name == 'pull_request' && vars.GITLEAKS_DISABLED != 'true'`).
  Provided for forks that cannot obtain a gitleaks org/commercial license or
  prefer an alternative secret scanner. NOT a Rust env var; never read by `src/`
  code. Follows the `vars.JR_E2E_ENABLED` repo-variable-gate doc pattern
  (`docs/specs/e2e-fork-safe-ci-enablement.md`). See
  `docs/specs/fork-friendly-release-ops.md`.
```

**Placement constraint:** The new bullet MUST appear in the AI Agent Notes section,
adjacent to (before or after) the existing `JR_E2E_ENABLED` bullet. It MUST NOT
be placed in a product-feature section, a Gotchas section, or anywhere that implies
the variable affects `jr` binary behavior.

**Precedent:** S-E2E-FORK-1 established the doc pattern cited here. The wording
mirrors that bullet's structure: repo variable → guards a CI job → not a Rust env
var → cross-reference to the relevant spec.

---

## Files Changed Summary

| File | Change | Story | Drift Item |
|------|--------|-------|------------|
| `.github/workflows/backfill-release.yml` | Add `x86_64-pc-windows-msvc` matrix entry; add Windows Package/Checksum/Smoke/OAuth steps; make existing Package step Unix-conditional; update Upload Artifact path; replace delete+create with check-then-upsert (with draft detection + prerelease-flag invariant) in `jobs.release` | S-FORK-OPS-BACKFILL-1 | WIN-TARGET, DESTRUCTIVE |
| `docs/specs/fork-friendly-release-ops.md` | Add `GITLEAKS_DISABLED` row to repository variables table | S-FORK-OPS-GITLEAKS-DOC-1 | GITLEAKS-DOC |
| `CLAUDE.md` | Add `GITLEAKS_DISABLED` AI Agent Notes bullet | S-FORK-OPS-GITLEAKS-DOC-1 | GITLEAKS-DOC |

## Files NOT Changed (Regression Baseline)

All Rust source (`src/`), all Rust tests (`tests/`), `ci.yml`, `release.yml`,
`sign-and-publish.yml`, `release-gap-fill.yml`, `e2e.yml`, all BC files, NFR
catalog, ADRs, and `.factory/architecture/` files are unchanged. No new BC-S.SS.NNN
or VP-NNN identifiers are introduced by this bundle.

## F5 Checklist (for adversarial reviewer)

- [ ] Every new `run:` block in `backfill-release.yml` referencing `inputs.tag`
  binds it via `env: RELEASE_TAG: ${{ inputs.tag }}` and references `"${RELEASE_TAG}"`.
- [ ] `${{ matrix.target }}` and `${{ github.repository }}` inline usages are compliant
  (`matrix.*` = author-controlled; `github.repository` = format-safe allowlist).
- [ ] `scripts/check-signing-workflow-injection.sh --self-test` passes with new
  Windows steps present (build job is in-scope via criterion (a) — secrets referenced).
- [ ] `jr-*.zip` appears in ALL upload paths: Upload artifact step, the `exists`
  branch of the upsert, and the `create` branch of the upsert.
- [ ] Windows Smoke test uses `$ErrorActionPreference = 'Stop'` + explicit
  `$LASTEXITCODE` check — matches `release.yml` `jobs.build.steps[name="Smoke test (Windows)"]`.
- [ ] Windows Embedded OAuth verification uses `$ErrorActionPreference = 'Stop'`
  with `HAS_EMBED_SECRETS` bound via `env:` — matches `release.yml`
  `jobs.build.steps[name="Embedded OAuth verification (Windows)"]`.
- [ ] The old `gh release delete "$TAG" --yes ... 2>/dev/null || true` line is
  completely removed (no trace remaining in the release step).
- [ ] The upsert `exists` branch checks `isDraft` via `gh release view --json isDraft
  --jq '.isDraft'` and emits `::warning::` if true; it does NOT set `--draft false`.
- [ ] The upsert `exists` branch does NOT pass `$PRERELEASE` to `gh release upload`
  (prerelease flag preserved from prior curator intent).
- [ ] The upsert handles the "release exists, no assets" edge case (upload --clobber
  is idempotent on an asset-less release).
- [ ] `docs/specs/fork-friendly-release-ops.md` variables table has exactly five rows
  after the change (four existing + `GITLEAKS_DISABLED`).
- [ ] `CLAUDE.md` `GITLEAKS_DISABLED` bullet is in AI Agent Notes, adjacent to
  `JR_E2E_ENABLED`, and states "NOT a Rust env var."
