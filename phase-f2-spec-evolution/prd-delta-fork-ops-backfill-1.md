---
document_type: phase-f2-prd-delta
story_bundle: S-FORK-OPS-BACKFILL
stories:
  - S-FORK-OPS-BACKFILL-1
  - S-FORK-OPS-GITLEAKS-DOC-1
feature: fork-ops-backfill-parity
feature_type: infrastructure
created: 2026-06-18
f1_outcome: APPROVED
f1_source: .factory/phase-f1-delta-analysis/delta-analysis-fork-ops-backfill-1.md
drift_items:
  - FORK-OPS-BACKFILL-WIN-TARGET
  - FORK-OPS-BACKFILL-DESTRUCTIVE
  - FORK-OPS-GITLEAKS-DOC
spec_version_bump: PATCH
spec_version_old: "1.3.23"
spec_version_new: "1.3.24"
---

# Phase F2 PRD Delta: Fork-Ops Backfill Parity (S-FORK-OPS-BACKFILL Bundle)

## Summary

F1 delta analysis (APPROVED) determined that **zero new BCs, zero BC
modifications, zero new NFRs, and zero Edge Case Catalog additions** are
required for this bundle. This document records that determination as the
authoritative F2 spec delta artifact.

This follows the precedent set by S-FORK-OPS-SIGN-1, whose spec-delta carried:

> No existing BC-S.SS.NNN identifiers cover signing workflow behavior. No new
> BCs are appropriate for CI/CD workflow implementation details. No existing
> BCs are modified.

The three drift items in this bundle are structurally identical: CI/CD workflow
correctness and documentation hygiene sit outside the `jr` product BC catalog.

---

## PRD / BC Delta

**NONE.**

No existing BC-S.SS.NNN identifiers cover `backfill-release.yml` workflow
behavior. The drift items being fixed are:

- **FORK-OPS-BACKFILL-WIN-TARGET** — a parity gap in the `build` job matrix
  (missing `x86_64-pc-windows-msvc` target). This closes against the existing
  `NFR-P-W1` ("Windows binary must be produced for releases"). NFR-P-W1 is
  already present in the NFR catalog; no new NFR is created. WIN-TARGET does
  not alter any product behavioral contract — the `jr` binary behavior,
  command surface, API calls, output rendering, authentication, and all product
  features are completely unchanged.

- **FORK-OPS-BACKFILL-DESTRUCTIVE** — the `release` job unconditionally
  deletes any existing GitHub Release before recreating it with auto-generated
  notes, clobbering curated release notes. The fix replaces delete+create with
  a check-then-upsert (create only when no release exists; otherwise upload
  assets with `--clobber`). This is a CI/CD workflow correctness fix — it
  affects the release publication step of `backfill-release.yml`, not any
  behavior of the `jr` binary itself. No product BC governs GitHub Release
  creation strategy.

- **FORK-OPS-GITLEAKS-DOC** — `GITLEAKS_DISABLED` (a GitHub Actions repository
  variable that gates the `security:` job in `ci.yml`) is undocumented in
  `docs/specs/fork-friendly-release-ops.md` and `CLAUDE.md`. This is a
  documentation gap only; the runtime behavior (`ci.yml` line 145) is already
  correct and is not changed. No product BC governs CI job skip variables.

No new BC-S.SS.NNN identifiers are appropriate for any of the above. The
implementation contract for this bundle lives in the architect's
`spec-delta-fork-ops-backfill-1.md` (engineering-spec delta), not in product
behavioral contracts.

**No product BCs are added or modified by this bundle.**

---

## NFR Delta

**NONE.**

`NFR-P-W1` ("Windows binary must be produced for releases") already exists in
the NFR catalog and already governs the WIN-TARGET parity intent.
FORK-OPS-BACKFILL-WIN-TARGET closes the implementation gap against NFR-P-W1
in `backfill-release.yml`; it does not create a new non-functional requirement.

No other NFR candidates were identified in the F1 delta analysis. The NFR
catalog is unchanged.

---

## Edge Case Catalog Delta

**NONE.**

The edge-case catalog (`edge-case-catalog.md`) covers cross-cutting `jr` binary
behavioral edge cases. CI/CD workflow edge cases (partial runs, concurrent
runs, curated vs. auto-generated release notes) are not product edge cases and
are not entered into the catalog.

---

## Architecture / Engineering-Spec Delta

The implementation contract lives in the engineering spec
`docs/specs/fork-friendly-release-ops.md` (modified by both stories). The
two spec changes are:

**Story 1 — S-FORK-OPS-BACKFILL-1** (file: `.github/workflows/backfill-release.yml`):
- Add `x86_64-pc-windows-msvc` matrix entry + Windows-specific build, package,
  checksum, smoke-test, and embedded-OAuth-verification steps mirroring the
  S-WIN-4 precedent from `release.yml`.
- Replace delete+create in the `release` job with check-then-upsert; preserve
  curated release notes on re-runs.
- Update asset upload globs to include `jr-*.zip`.
- **REQUIRED: add `tests/backfill_matrix_parity.rs`** — a Story-1 acceptance
  criterion (not optional). This guard verifies that `backfill-release.yml`'s
  build matrix includes `x86_64-pc-windows-msvc`, analogous to
  `tests/ci_yml_windows_matrix.rs` for `ci.yml`. Story 1 is not complete
  without this test. Authoritative source: `verification-delta-fork-ops-backfill.md`.

**Story 2 — S-FORK-OPS-GITLEAKS-DOC-1** (files: `docs/`, `CLAUDE.md`):
- Add `GITLEAKS_DISABLED` to the repository variables table in
  `docs/specs/fork-friendly-release-ops.md`.
- Add `GITLEAKS_DISABLED` AI Agent Notes entry to `CLAUDE.md`.

These are F4 repo-file edits. F2 does not touch repo files (LESSON-F2-WORKTREE-FIRST).

---

## Verification Delta

**New VPs: NONE.**

No VPs cover CI/CD workflow files. Verification for this bundle is:

- **F5 adversarial scan**: verify all new `run:` blocks in `backfill-release.yml`
  that reference `inputs.tag` bind it via `env:` (CWE-77 compliance matching the
  S-FORK-OPS-SIGN-1 pattern); confirm `scripts/check-signing-workflow-injection.sh
  --self-test` passes; confirm check-then-upsert correctly handles the edge case
  where the release exists but has no assets yet; confirm `jr-*.zip` glob is
  present in both upload branches; confirm Windows steps replicate S-WIN-4's
  PowerShell pattern (`$ErrorActionPreference`, `LASTEXITCODE` guard, etc.).

---

## Drift Item to Story Mapping

| Drift Item | Story | Files Touched |
|-----------|-------|---------------|
| FORK-OPS-BACKFILL-WIN-TARGET (MED) | S-FORK-OPS-BACKFILL-1 | `.github/workflows/backfill-release.yml` |
| FORK-OPS-BACKFILL-DESTRUCTIVE (MED) | S-FORK-OPS-BACKFILL-1 | `.github/workflows/backfill-release.yml` |
| FORK-OPS-GITLEAKS-DOC (LOW) | S-FORK-OPS-GITLEAKS-DOC-1 | `docs/specs/fork-friendly-release-ops.md`, `CLAUDE.md` |

---

## Spec Version Bump Recommendation

**PATCH** — infrastructure/doc hygiene with no behavioral change to the `jr`
binary; the workflow-publication behavior change (DESTRUCTIVE: delete+create →
check-then-upsert) is confined to the opt-in/inert `backfill-release.yml`
workflow and does not affect the `jr` binary, any product BC, any NFR, or any
public API surface. No new product BCs, no new NFRs, no API surface change.
The S-FORK-OPS-SIGN-1 precedent also used a PATCH bump for the same class of
infrastructure-only spec delta.

**Version: 1.3.23 → 1.3.24**

---

## Files NOT Changed (Spec Artifacts)

All of the following are confirmed unchanged by this bundle:

- All BC files (`bc-1-auth-identity.md` through `bc-7-output-render.md`,
  `cross-cutting.md`) — no contract additions, modifications, or retirements
- `BC-INDEX.md` — `total_bcs` remains 599; no new rows
- `CANONICAL-COUNTS.md` — no count changes
- `nfr-catalog.md` — no new NFR rows; NFR-P-W1 already present
- `error-taxonomy.md` — unchanged
- `edge-case-catalog.md` — unchanged
- `holdout-scenarios.md` — unchanged
- All `.factory/architecture/` files — no `src/` changes, no module
  decomposition, no dependency edges, no VP assignments
- VP-INDEX.md, ARCH-INDEX.md — unchanged
- All story body files — no BC table changes triggered; no `bc_array_changes_propagate_to_body_and_acs` dispatch needed
- All Rust source (`src/`) and test files (`tests/`) — unchanged

---

## Dependency Graph Impact

**NONE.** No architecture component graph changes. The `jr` binary's module
structure, API call patterns, and test coverage are unaffected.
