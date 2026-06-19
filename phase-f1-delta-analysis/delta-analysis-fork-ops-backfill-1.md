---
document_type: phase-f1-delta-analysis
feature: fork-ops-backfill-1
bundle: S-FORK-OPS-BACKFILL-1
intent: bug-fix
severity: MED
feature_type: infrastructure
scope: standard
trivial: false
created: 2026-06-18
drift_items:
  - FORK-OPS-BACKFILL-DESTRUCTIVE
  - FORK-OPS-BACKFILL-WIN-TARGET
  - FORK-OPS-GITLEAKS-DOC
related_stories:
  - S-FORK-OPS-SIGN-1
  - S-WIN-4
  - S-E2E-FORK-1
---

# Phase F1 Delta Analysis: Fork-Ops Backfill Parity (S-FORK-OPS-BACKFILL-1)

## Feature Summary

Resolve three MED-severity drift items confined to two GitHub Actions workflow
files and two documentation files:

- `.github/workflows/backfill-release.yml` — missing Windows build target
  (WIN-TARGET) and destructive release-notes clobber (DESTRUCTIVE)
- `docs/specs/fork-friendly-release-ops.md` — `GITLEAKS_DISABLED` variable
  undocumented (GITLEAKS-DOC)
- `CLAUDE.md` — same documentation gap (GITLEAKS-DOC)

`backfill-release.yml` is always inert in the canonical repo's scheduled path
(`RELEASE_GAP_FILL_ENABLED` unset), but is reachable via manual
`workflow_dispatch` without any repo variable. WIN-TARGET and DESTRUCTIVE are
therefore reachable. GITLEAKS-DOC is doc-gap severity only: `ci.yml` already
has the correct guard — the variable simply is not surfaced in the spec or
CLAUDE.md for operators configuring forks.

---

## Classification

| Field | Value |
|-------|-------|
| Intent | `bug-fix` (WIN-TARGET: parity gap; DESTRUCTIVE: data-loss risk; GITLEAKS-DOC: doc gap) |
| Feature type | `infrastructure` (CI/CD workflows + documentation) |
| Scope | `standard` (not trivial — requires careful WIN-TARGET integration mirroring S-WIN-4 packaging pattern and a behavioral change to the release-upsert logic in DESTRUCTIVE) |
| Severity | MED (HIGH potential impact for DESTRUCTIVE if triggered on a curated-notes release; inert in canonical scheduled path) |
| Trivial | No — per DEC-120/121, FULL F1–F7 recommended |
| Expedited | No — no production `jr` binary risk; canonical `RELEASE_GAP_FILL_ENABLED` is unset |
| Blocking | None |

---

## Drift Items Detail

### MED-1: FORK-OPS-BACKFILL-WIN-TARGET

**File:** `.github/workflows/backfill-release.yml`
**Job:** `build` (lines 38–113)

`backfill-release.yml` build matrix contains four targets (lines 43–52):

```yaml
- target: x86_64-apple-darwin
- target: aarch64-apple-darwin
- target: x86_64-unknown-linux-gnu
- target: aarch64-unknown-linux-gnu (use_cross: true)
```

The canonical `release.yml` build matrix (lines 17–28) has a fifth entry:

```yaml
- target: x86_64-pc-windows-msvc
  os: windows-latest
```

`release.yml` also has Windows-specific steps that `backfill-release.yml`
entirely lacks:

- `Package (Windows)` (lines 79–82) — PowerShell `Compress-Archive` → `.zip`
- `Checksum (Windows)` (lines 84–87) — `sha256sum` on the `.zip`
- `Smoke test (Windows)` (lines 89–100) — `.\jr.exe --version`
- `Embedded OAuth verification (Windows)` (lines 102–129) — PowerShell
  credential check

The release job's asset upload in `release.yml` includes `jr-*.zip`. The
backfill release job currently uploads only `jr-*.tar.gz` and `jr-*.sha256`,
meaning any tag backfilled via this workflow ships no Windows binary.

**NFR link:** `NFR-P-W1` governs Windows binary availability. This is a parity
gap against it.

**Fix shape:**
1. Add `x86_64-pc-windows-msvc` matrix entry (`os: windows-latest`) to `build` job,
   matching `release.yml` line 27–28.
2. Make existing `Package` step Unix-conditional: `if: runner.os != 'Windows'`.
3. Add `Package (Windows)` step using PowerShell `Compress-Archive`, mirroring
   `release.yml` lines 79–82. Bind `RELEASE_TAG: ${{ inputs.tag }}` via `env:`
   (CWE-77 consistency; `inputs.*` must not appear inline in `run:` blocks per
   `fork-friendly-release-ops.md` security constraints section).
4. Add `Checksum (Windows)` step mirroring `release.yml` lines 84–87.
5. Add Windows smoke test and embedded OAuth verification steps for full parity
   (optional but recommended for correctness confidence in backfilled releases).
6. Update release job asset upload glob to include `jr-*.zip`.

**Precedent:** S-WIN-4 (MERGED) established the exact PowerShell
Compress-Archive / `.zip` packaging pattern in `release.yml`. The implementation
MUST replicate that pattern verbatim, not invent a new shape.

---

### MED-2: FORK-OPS-BACKFILL-DESTRUCTIVE

**File:** `.github/workflows/backfill-release.yml`
**Job:** `release` (lines 118–154), specifically lines 145–154

The "Create or update GitHub Release" step unconditionally deletes any existing
release before recreating it with auto-generated notes:

```yaml
# Line 146
gh release delete "$TAG" --yes --repo "${{ github.repository }}" 2>/dev/null || true

gh release create "$TAG" \
  --title "$TAG" \
  --generate-notes \
  ...
```

If a curator had previously written or edited the release notes by hand (common
for stable `.0` releases), those notes are silently clobbered by the
auto-generated replacement. The `|| true` silencer additionally masks delete
errors, meaning the workflow proceeds even if the delete partially failed.

**Fix shape:** Replace the delete+create pattern with a check-then-upsert:

```bash
if gh release view "$TAG" --repo "${{ github.repository }}" >/dev/null 2>&1; then
  # Release exists — upload assets without touching notes
  gh release upload "$TAG" jr-*.tar.gz jr-*.sha256 \
    --repo "${{ github.repository }}" --clobber
else
  # No release yet — safe to create with auto-generated notes
  gh release create "$TAG" \
    --repo "${{ github.repository }}" \
    --title "$TAG" \
    --generate-notes \
    $PRERELEASE \
    jr-*.tar.gz \
    jr-*.sha256
fi
```

Key invariant: `--generate-notes` is applied only on initial creation (when
no curated notes exist). If the release already exists, assets are uploaded via
`--clobber` without touching notes. This mirrors `softprops/action-gh-release`
in `release.yml`, which only generates notes on first creation.

After adding the Windows target (MED-1), the release job must also include
`jr-*.zip` in both the upload and create glob patterns.

Note: `${{ github.repository }}` is on the CWE-77 allowlist (format-constrained
to `[A-Za-z0-9._-]/<same>` — no metacharacters possible). Its existing inline
usage in the release and homebrew jobs requires no remediation.

---

### LOW-1: FORK-OPS-GITLEAKS-DOC

**Files:** `docs/specs/fork-friendly-release-ops.md`, `CLAUDE.md`

`ci.yml` line 145 gates the `security` job on `vars.GITLEAKS_DISABLED != 'true'`.
The inline job comment (lines 139–144) explains the opt-out rationale correctly.
However:

1. `GITLEAKS_DISABLED` does not appear in `docs/specs/fork-friendly-release-ops.md`
   repository variables table (lines 38–49). That table lists only
   `SIGNING_ENABLED`, `HOMEBREW_TAP_REPO`, `RELEASE_GAP_FILL_ENABLED`,
   `SYNC_UPSTREAM_REPO`.
2. `GITLEAKS_DISABLED` does not appear in `CLAUDE.md` anywhere — not in the AI
   Agent Notes section, not in the release-ops section.

A fork operator configuring release-ops from the spec would not discover this
escape hatch without reading `ci.yml` directly.

**Fix shape (documentation-only; zero workflow logic changes):**

In `docs/specs/fork-friendly-release-ops.md`, add to the repository variables
table:

```markdown
| `GITLEAKS_DISABLED` | `'true'` disables the gitleaks secret scan job in CI; for forks that cannot obtain a gitleaks org/commercial license or prefer an alternative scanner | unset |
```

In `CLAUDE.md` AI Agent Notes section, add alongside the `JR_E2E_ENABLED` entry
(same repo-variable-gate pattern):

```markdown
- **`GITLEAKS_DISABLED`** — GitHub Actions **repository variable**
  (`vars.GITLEAKS_DISABLED`). When set to `'true'`, skips the `security:`
  (gitleaks) job in `ci.yml`. Provided for forks that cannot obtain a gitleaks
  org/commercial license or prefer an alternative secret scanner. NOT a Rust
  env var; never read by `src/` code. See `docs/specs/fork-friendly-release-ops.md`.
```

**Precedent:** S-E2E-FORK-1 (MERGED) established the `JR_E2E_ENABLED`
repo-variable-gate doc pattern that GITLEAKS-DOC extends.

---

## Impact Assessment Table

| Artifact | Status | Notes |
|----------|--------|-------|
| PRD (BC-S.SS.NNN) | UNCHANGED | No existing BCs cover fork-ops CI/CD workflow correctness. Same pattern as S-FORK-OPS-SIGN-1 (`# No product BCs` frontmatter). No new BCs needed. |
| Architecture (`.factory/architecture/`) | UNCHANGED | No `src/` changes. All architecture documents are unaffected. |
| NFR catalog | UNCHANGED | `NFR-P-W1` (Windows binary availability) is already present; WIN-TARGET closes the gap against it. No new NFR needed. |
| UX / design | N/A | Infrastructure-only change. |
| Stories | NEW (2 stories, see decomposition) | One for both workflow fixes, one for doc-only. |
| Tests (Rust — `tests/`, `src/`) | UNCHANGED | No Rust test files are touched. |
| New test (backfill matrix parity guard) | NEW CANDIDATE | `tests/ci_yml_windows_matrix.rs` guards `ci.yml` only; a backfill-matrix-parity guard is a new-test candidate for Story 1 if low-cost. |
| Verification properties (VP-NNN) | UNCHANGED | No VPs cover CI/CD workflow files. |
| `docs/specs/fork-friendly-release-ops.md` | MODIFIED | Add `GITLEAKS_DISABLED` to variables table. |
| `CLAUDE.md` | MODIFIED | Add `GITLEAKS_DISABLED` AI Agent Notes entry. |

---

## Files Changed Table

| File | Change Type | Items |
|------|-------------|-------|
| `.github/workflows/backfill-release.yml` | MODIFIED | MED-1 (WIN-TARGET: matrix entry + Windows steps + asset glob), MED-2 (DESTRUCTIVE: upsert replace delete+create) |
| `docs/specs/fork-friendly-release-ops.md` | MODIFIED | LOW-1 (GITLEAKS-DOC: add variable to table) |
| `CLAUDE.md` | MODIFIED | LOW-1 (GITLEAKS-DOC: add AI Agent Notes entry) |

---

## Files NOT Changed (Regression Baseline)

**All Rust source (`src/`):** No changes. The `jr` binary behavior, API calls,
output rendering, authentication, and all product features are completely
unchanged.

**All Rust tests (`tests/`):** No changes to existing test files. The full
cargo test suite (unit, integration, property-based, snapshot, E2E) is
unaffected.

**`tests/ci_gate_completeness.rs`** (`test_ci_gate_needs_contains_all_required_jobs`):
No new CI jobs are added to `ci.yml` by this bundle; the ci-gate completeness
guard is not impacted.

**`tests/ci_yml_windows_matrix.rs`:** This test guards `ci.yml`'s Windows
matrix, not `backfill-release.yml`. It will remain passing with no changes. A
new companion test guarding `backfill-release.yml`'s Windows matrix is a
NEW-TEST candidate (see Story 1 scope).

**`scripts/check-signing-workflow-injection.sh` (`--self-test`):** This script
scans `backfill-release.yml` for CWE-77 violations. Any new `run:` blocks added
by MED-1 that reference `inputs.tag` MUST bind it via `env:` (already the
pattern used by the existing `Package` step at lines 96–97). The injection guard
must continue to pass.

**`release.yml`:** Reference-only. No changes. WIN-TARGET fix replicates its
matrix entry and step patterns verbatim.

**`release-gap-fill.yml`:** Dispatcher only; no changes needed. It dispatches
`backfill-release.yml` but does not need modification.

**`ci.yml`:** No changes. The `vars.GITLEAKS_DISABLED` guard (line 145) already
exists and is correct; GITLEAKS-DOC is purely additive documentation.

**All other workflows** (`sign-and-publish.yml`, `e2e.yml`, `e2e-sweeper.yml`,
`dependency-review.yml`, `scorecards.yml`, `sync-upstream.yml`): UNCHANGED.

**All BC files, NFR catalog, holdout scenarios, ADRs, `.factory/architecture/`
files:** UNCHANGED.

---

## Regression Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Product regression (`jr` binary) | NONE | No `src/` changes. |
| CI regression (canonical repo) | NEAR-ZERO | `ci.yml`, `ci-gate`, and all other workflows unchanged. `backfill-release.yml` is inert in canonical scheduled path (`RELEASE_GAP_FILL_ENABLED` unset). |
| CWE-77 injection guard (`check-signing-workflow-injection.sh`) | MUST VERIFY | Any new `run:` blocks referencing `inputs.tag` must bind via `env:`. Existing Package step already uses this pattern; new Windows steps must replicate it. The injection guard CI job must pass cleanly. |
| Signing pipeline regression (S-FORK-OPS-SIGN-1 interaction) | LOW | S-FORK-OPS-SIGN-1 (MERGED) modified `backfill-release.yml`'s `sign` job's env-binding. The `build` and `release` job edits in this bundle do not touch the `sign` job. Verify no cross-job `needs:` chain is disrupted. |
| Windows packaging regression (S-WIN-4 interaction) | LOW | S-WIN-4 established the `.zip` packaging pattern in `release.yml`. MED-1 replicates it verbatim in `backfill-release.yml`. Deviation from that exact pattern would be a regression. |
| Data-loss prevention (DESTRUCTIVE) | IMPROVED | After MED-2, curated release notes are preserved on re-runs. |
| Release asset completeness | IMPROVED | After MED-1, backfilled releases include Windows `.zip` assets matching the `release.yml` artifact set. |

---

## Security Validation

### CWE-77 Compliance (MED-1 Windows steps)

The `backfill-release.yml` security constraints section in
`fork-friendly-release-ops.md` requires that `inputs.*` values MUST NOT appear
inline in `run:` script bodies — they must be bound via a step-level `env:`
block and referenced as double-quoted shell variables. The existing `Package`
step (lines 96–97) already demonstrates the correct pattern:

```yaml
env:
  RELEASE_TAG: ${{ inputs.tag }}
run: |
  cd target/${{ matrix.target }}/release
  tar czf "../../../jr-${RELEASE_TAG}-${{ matrix.target }}.tar.gz" jr
```

All new Windows `run:` steps added by MED-1 MUST follow this same `env:`-binding
pattern. `${{ github.repository }}` in the release job is on the CWE-77 format-safe
allowlist and requires no change.

During F5, verify that `scripts/check-signing-workflow-injection.sh --self-test`
continues to pass after the Windows steps are added.

---

## Existing Spec Coverage

No existing BC-S.SS.NNN identifiers cover backfill workflow behavior. The
fork-ops infrastructure is documented in:
- `docs/specs/fork-friendly-release-ops.md` (authoritative spec for this subsystem)
- `.factory/STATE.md` Drift Items: FORK-OPS-BACKFILL-DESTRUCTIVE,
  FORK-OPS-BACKFILL-WIN-TARGET, FORK-OPS-GITLEAKS-DOC

No new BC-S.SS.NNN identifiers are appropriate for CI/CD workflow behavior.
Do NOT invent FR-NNN identifiers.

---

## Recommended Story Decomposition

### Recommended: Two Stories (group by file to avoid worktree conflicts)

Both MED-1 (WIN-TARGET) and MED-2 (DESTRUCTIVE) edit `backfill-release.yml` —
specifically, both touch the `release` job's asset upload/create step. Splitting
them across stories would require concurrent edits to the same file, introducing
worktree merge risk.

**Story 1 — S-FORK-OPS-BACKFILL-1** (file: `backfill-release.yml`)
- Fix MED-1: Add `x86_64-pc-windows-msvc` matrix entry, Windows Package and
  Checksum steps, Windows smoke/OAuth verification steps; update asset upload
  globs to include `jr-*.zip`.
- Fix MED-2: Replace delete+create in the `release` job with check-then-upsert;
  preserve curated release notes on re-runs.
- Optional: Add backfill-matrix-parity test (analog to `tests/ci_yml_windows_matrix.rs`
  for `backfill-release.yml`) if low-cost.
- Single PR; single diff; no interaction with doc-only Story 2.

**Story 2 — S-FORK-OPS-GITLEAKS-DOC-1** (files: `docs/`, `CLAUDE.md`)
- Fix LOW-1: Add `GITLEAKS_DISABLED` to `fork-friendly-release-ops.md` variables
  table; add AI Agent Notes entry to `CLAUDE.md`.
- Documentation-only; no workflow logic; zero regression risk.
- Can be merged ahead of or after Story 1 independently.

### Alternative: Single Story (S-FORK-OPS-BACKFILL-1-COMBINED)

All three drift items in one PR covering `backfill-release.yml`,
`docs/specs/fork-friendly-release-ops.md`, and `CLAUDE.md`. Acceptable if the
team prefers minimal story overhead. The review burden is still low — all changes
are YAML + Markdown with no Rust. Risk is slightly higher because a doc-only
blocker (typo, CLAUDE.md conflict) could hold up the workflow fix.

**Recommendation:** Two stories. The doc fix is genuinely independent and should
not block the more operationally important workflow fix.

---

## Recommended Scope for F2–F7

### F2 (Spec Evolution)

Minimal. Update `docs/specs/fork-friendly-release-ops.md`:
1. Add `GITLEAKS_DISABLED` to repository variables table (Story 2).
2. Add a note to the "Known limitations" section or the `backfill-release.yml`
   component row clarifying that `update_homebrew=false` is dispatched and that
   the release job preserves existing release notes (Story 1 behavioral intent).
No BC, NFR, or architecture document changes.

### F3 (Stories)

Two stories as decomposed above. Each story's ACs trace to Drift Item IDs
(FORK-OPS-BACKFILL-WIN-TARGET, FORK-OPS-BACKFILL-DESTRUCTIVE,
FORK-OPS-GITLEAKS-DOC). STATE.md Drift Item status updated in F7.

### F4 (Delta Implementation)

**Story 1** is a YAML edit — two jobs in one file:
- `build` job: matrix addition + platform-conditional step additions.
- `release` job: delete+create → check-then-upsert + glob update.

Pattern for Windows packaging is a verbatim copy from `release.yml` S-WIN-4
precedent. No invention needed.

**Story 2** is a Markdown edit to two files. No YAML changes.

### F5 (Adversarial Refinement)

1 round max. Focus on Story 1:
- (a) Confirm every new `run:` block in `backfill-release.yml` that references
  `inputs.tag` uses `env:` binding (CWE-77 compliance).
- (b) Confirm `scripts/check-signing-workflow-injection.sh --self-test` passes
  with the new Windows steps present.
- (c) Confirm the check-then-upsert logic correctly handles the case where the
  release exists but has no assets yet (edge case: prior partial run).
- (d) Verify that `jr-*.zip` glob is present in ALL upload paths (both the
  `exists → upload` branch and the `create` branch).
- (e) Confirm the Windows steps replicate S-WIN-4's PowerShell pattern without
  deviation (PowerShell `$ErrorActionPreference`, `LASTEXITCODE` guard, etc.).

### F6 (Formal Hardening)

Minimal. No Rust code, no property proofs, no mutation testing. `cargo deny check`
is unaffected. The injection guard script (`check-signing-workflow-injection.sh`)
is the primary verification mechanism for Story 1's security surface.

### F7 (Convergence)

Standard: STATE.md Drift Items for all three items marked RESOLVED; spec
changelog entry; no VP or BC count changes.
