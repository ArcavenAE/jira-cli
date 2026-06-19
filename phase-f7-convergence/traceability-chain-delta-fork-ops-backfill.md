---
document_type: f7-traceability-chain-delta
feature: fork-ops-backfill-parity
bundle: S-FORK-OPS-BACKFILL
spec_version: "1.3.24"
stories:
  - S-FORK-OPS-BACKFILL-1
  - S-FORK-OPS-GITLEAKS-DOC-1
prs:
  - "#539 → 2756050"
  - "#538 → f85647b"
  - "#540 → 83a141ad (FIX-F5-001)"
date: 2026-06-19
producer: orchestrator
traces_to:
  - ".factory/phase-f7-convergence/delta-convergence-report-fork-ops-backfill.md"
  - ".factory/phase-f2-spec-evolution/spec-delta-fork-ops-backfill.md"
  - ".factory/stories/S-FORK-OPS-BACKFILL-1-backfill-release-windows-parity-and-upsert.md"
  - ".factory/stories/S-FORK-OPS-GITLEAKS-DOC-1-gitleaks-disabled-doc.md"
---

# Traceability Chain — S-FORK-OPS-BACKFILL Delta

This document records the end-to-end traceability for the S-FORK-OPS-BACKFILL bundle,
linking drift items through implementation artifacts to test coverage, adversarial
verification, and merged commits.

**Note on BC/VP absence:** This is a CI infrastructure + documentation delta. Zero new
behavioral contracts (BCs), verification properties (VPs), or NFRs were required
(per F1 delta analysis). The traceability chain therefore runs:

```
Drift Item → F2 Spec Contract → Story AC → Implementation File → Test → Commit
```

rather than the standard `BC → VP → test → src` chain for product features.

---

## Story 1: S-FORK-OPS-BACKFILL-1

### Drift Item FORK-OPS-BACKFILL-WIN-TARGET

**Root cause:** `backfill-release.yml` build matrix missing `x86_64-pc-windows-msvc`.
Backfilled releases lacked Windows binaries.

| Link | Artifact |
|------|----------|
| **Drift item** | `FORK-OPS-BACKFILL-WIN-TARGET` (STATE.md Drift Items) |
| **F2 spec contract** | `.factory/phase-f2-spec-evolution/spec-delta-fork-ops-backfill.md` §"Drift Item WIN-TARGET" |
| **Story** | `S-FORK-OPS-BACKFILL-1` AC-001 / AC-004 |
| **Implementation — matrix entry** | `.github/workflows/backfill-release.yml` `jobs.build.strategy.matrix.include` — fifth entry `target: x86_64-pc-windows-msvc / os: windows-latest` |
| **Implementation — Windows steps** | `Package (Windows)` (PowerShell; `$ErrorActionPreference = 'Stop'`), `Checksum (Windows)`, `Smoke test (Windows)`, `Embedded OAuth verification (Windows)` |
| **Implementation — Unix Package condition** | `if: runner.os != 'Windows'` added to existing `Package` step |
| **Implementation — Upload artifact** | `jr-*.zip` added to Upload artifact path |
| **Test — matrix parity guard** | `tests/backfill_matrix_parity.rs::test_backfill_matrix_parity_matches_release_yml` — set-equality of build targets vs `release.yml` |
| **Test — Windows matrix entry** | `tests/backfill_matrix_parity.rs::test_backfill_build_matrix_contains_windows_target` |
| **Test — zip in upload artifact** | `tests/backfill_matrix_parity.rs::test_backfill_upload_artifact_includes_zip` |
| **Test — shell: bash on Build** | `tests/backfill_matrix_parity.rs::test_backfill_build_step_declares_shell_bash` (AC-005; added post DEC-124 local review) |
| **Test — shell: bash on Unix Package** | `tests/backfill_matrix_parity.rs::test_backfill_unix_package_step_declares_shell_bash` (AC-005) |
| **Adversarial verification** | F5 Pass 1: confirmed non-vacuous at basis; CWE-77 env-binding confirmed; F5 Pass 2: WIN-TARGET byte-faithful verified |
| **Merged commit** | PR #539 → `2756050` (2026-06-18; develop) |

---

### Drift Item FORK-OPS-BACKFILL-DESTRUCTIVE

**Root cause:** `backfill-release.yml` used `gh release delete` + `gh release create` to
handle existing releases, which could silently clobber curated release notes.

| Link | Artifact |
|------|----------|
| **Drift item** | `FORK-OPS-BACKFILL-DESTRUCTIVE` (STATE.md Drift Items) |
| **F2 spec contract** | `.factory/phase-f2-spec-evolution/spec-delta-fork-ops-backfill.md` §"Drift Item DESTRUCTIVE" |
| **Story** | `S-FORK-OPS-BACKFILL-1` AC-002 |
| **Implementation — check-then-upsert** | `.github/workflows/backfill-release.yml` `jobs.release` — `gh release view` check replaces `gh release delete`; two-branch `if/else/fi`: upload branch (existing release) and create branch (new release) |
| **Implementation — isDraft detection** | `gh release view $RELEASE_TAG --json isDraft --jq '.isDraft'` → `::warning::` emission on draft (CWE-74 safe: structured query) |
| **Implementation — no silencer** | `|| true` removed; all `gh release` calls fail loudly |
| **Implementation — prerelease flag** | `--prerelease` NOT passed to upload branch (idempotent behavior for existing release) |
| **Test — no delete command** | `tests/backfill_matrix_parity.rs::test_backfill_release_job_has_no_delete_command` |
| **Test — no `\|\| true` silencer** | `tests/backfill_matrix_parity.rs::test_backfill_release_job_has_no_or_true_silencer` |
| **Test — upsert view check** | `tests/backfill_matrix_parity.rs::test_backfill_release_job_has_upsert_view_check` |
| **Test — upsert upload branch** | `tests/backfill_matrix_parity.rs::test_backfill_release_job_has_upsert_upload_branch` |
| **Test — zip in BOTH branches (branch-anchored)** | `tests/backfill_matrix_parity.rs::test_backfill_release_job_zip_in_both_upsert_branches` (FIX-F5-001: M4 vacuousness fix; now anchors `jr-*.zip` to DISTINCT upload and create branches via `else` boundary split) |
| **Test — isDraft detection** | `tests/backfill_matrix_parity.rs::test_backfill_release_job_has_draft_detection` |
| **Adversarial verification** | F5 Pass 1: draft/prerelease invariants confirmed correct; F5 Pass 2: draft/prerelease invariants re-confirmed; M4 (zip vacuousness) fixed via FIX-F5-001 |
| **FIX-F5-001** | PR #540 → `83a141ad` (2026-06-19; anchored zip test to distinct branches) |
| **Merged commit** | PR #539 → `2756050` (2026-06-18); PR #540 → `83a141ad` (FIX-F5-001) |

---

### CWE-77 Compliance Cross-Cut (applies to both drift items)

| Requirement | Evidence |
|-------------|---------|
| `inputs.tag` env-bound as `RELEASE_TAG` | All new `run:` blocks in `backfill-release.yml` |
| `${{ matrix.target }}` inline exemption | Author-controlled; exempt per CWE-77 default-deny rule |
| `${{ github.repository }}` inline exemption | Format-safe allowlist |
| Injection guard script passes | `scripts/check-signing-workflow-injection.sh` 0 violations |
| F5 Pass 1 verification | CWE-77 env-binding confirmed by adversary |
| F5 Pass 2 verification | CWE-77 re-confirmed by independent re-derivation |

---

## Story 2: S-FORK-OPS-GITLEAKS-DOC-1

### Drift Item FORK-OPS-GITLEAKS-DOC

**Root cause:** The `GITLEAKS_DISABLED` GitHub Actions repository variable used to opt
forks out of secret scanning was not documented in `docs/specs/fork-friendly-release-ops.md`
or `CLAUDE.md`.

| Link | Artifact |
|------|----------|
| **Drift item** | `FORK-OPS-GITLEAKS-DOC` (STATE.md Drift Items) |
| **F2 spec contract** | `.factory/phase-f2-spec-evolution/spec-delta-fork-ops-backfill.md` §"Story 2 — GITLEAKS-DOC" |
| **Story** | `S-FORK-OPS-GITLEAKS-DOC-1` AC-001 / AC-002 |
| **Implementation — fork-friendly-release-ops.md** | `docs/specs/fork-friendly-release-ops.md` repository variables table — `GITLEAKS_DISABLED` row added as 5th entry; full `if:` condition documented: `github.event_name == 'pull_request' && vars.GITLEAKS_DISABLED != 'true'`; "NOT a GitHub Actions environment variable" note included |
| **Implementation — CLAUDE.md** | `CLAUDE.md` AI Agent Notes section — bullet added adjacent to `JR_E2E_ENABLED`; full `if:` condition; "NOT a Rust env var; never read by `src/` code" statement |
| **Test** | Doc story — no test file required (AC coverage is content-presence checks fulfilled by F5 adversarial review of commit content) |
| **Adversarial verification** | F5 Pass 2: GITLEAKS_DISABLED doc confirmed exact-match; O3 (if: literal corrected to full condition in F2) confirmed accurate |
| **Merged commit** | PR #538 → `f85647b` (2026-06-18; develop) |

---

## F5 Adversarial Verification Summary

| Pass | Date | develop HEAD | Novelty | Actionable MEDIUM+ | Outcome |
|------|------|--------------|---------|--------------------|---------|
| Pass 1 | 2026-06-19 | f85647b | 0.35 | M2, M4 | M4 → FIX-F5-001; M2 accepted |
| Pass 2 | 2026-06-19 | 83a141ad | 0.08 | 0 | CLEAN (O-1 recurrence of M2 only) |
| Pass 3 | 2026-06-19 | 83a141ad | LOW | 0 | CLEAN, CONVERGED; L-NEW-1 tracked |

**Convergence source:** `.factory/phase-f5-adversarial/S-FORK-OPS-BACKFILL/convergence-summary.md`

---

## Commit → Branch Map

| Commit | PR | Author | Date | Content |
|--------|-----|--------|------|---------|
| `2756050` | #539 | Zious | 2026-06-18 | S-FORK-OPS-BACKFILL-1: `backfill-release.yml` Windows parity + safe release upsert; `tests/backfill_matrix_parity.rs` (9 tests at merge) |
| `f85647b` | #538 | Zious | 2026-06-18 | S-FORK-OPS-GITLEAKS-DOC-1: `GITLEAKS_DISABLED` documented in `fork-friendly-release-ops.md` + `CLAUDE.md` |
| `83a141ad` | #540 | Zious | 2026-06-19 | FIX-F5-001: anchor zip-asset guard to distinct upsert branches (M4 fix; +2 tests → 11 total) |

All three commits are present on `develop` branch as of 2026-06-19.

---

## Link to Main Traceability Chain

The S-FORK-OPS-BACKFILL bundle does not extend the product BC traceability matrix
(no BCs were added or modified). The authoritative product BC traceability corpus
is in `.factory/specs/prd/` + `BC-INDEX.md`.

Per the append convention established by `traceability-chain-delta.md` (S-388):
if a project-level traceability matrix is maintained, append the S-FORK-OPS-BACKFILL
entries with merge key:
`bundle: S-FORK-OPS-BACKFILL`, `stories: [S-FORK-OPS-BACKFILL-1, S-FORK-OPS-GITLEAKS-DOC-1]`,
`prs: [#539, #538, #540]`, `develop_head: 83a141ad`, `spec_version: 1.3.24`.

For prior delta traceability chains in `.factory/phase-f7-convergence/`, this document
joins the existing set as a sibling file (same directory, distinct feature slug).
The existing `traceability-chain-delta.md` (S-388 delta) is unmodified.
