---
document_type: story
story_id: "S-WIN-4"
title: "release.yml: x86_64-pc-windows-msvc matrix row, .zip packaging, smoke-step gate, artifact glob"
wave: feature-followup
status: ready
intent: feature
feature_type: ci
mode: feature
scope: medium
severity: MEDIUM
trivial_scope: false
points: 5
priority: P0
tdd_mode: strict
estimated_effort: small
estimated_days: 1
target_module: ci
subsystems: []
depends_on: ["S-WIN-3"]
blocks: []
bc_anchors: []
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors:
  - NFR-P-W1
adr_refs:
  - ADR-0016
  - ADR-0006
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-001/windows-build/architecture-delta.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 6
assumption_validations: []
risk_mitigations: ["R-W4"]
created: "2026-06-12"
last_updated: "2026-06-13"
breaking_change: false
files_modified:
  - .github/workflows/release.yml   # matrix addition, Package (Unix) if-gate, Package (Windows) pwsh/Compress-Archive new step, Checksum (Windows) bash/sha256sum new step, smoke-step if-gate, upload-artifact glob, release-job files glob
---

# S-WIN-4 — release.yml: Windows Build Matrix Row and .zip Packaging

## Source of Truth

Architecture delta: `.factory/cycles/cycle-001/windows-build/architecture-delta.md §3`
ADR-0016: `.factory/architecture/adr/0016-windows-build-target.md §Decision 1, 2, 5c`
NFR-P-W1: `.factory/specs/prd/nfr-catalog.md §NFR-P-W1`

## Behavioral Contracts

No new BC is produced by this story. The release pipeline changes are infrastructure.
NFR-P-W1 is the governing NFR: a pre-built `.zip` artifact for `x86_64-pc-windows-msvc`
must be produced on every release tag.

## Story Narrative

As a Windows user of `jr`,
I want a pre-built `jr-<version>-x86_64-pc-windows-msvc.zip` artifact available
on the GitHub Releases page with a `.sha256` checksum,
so that I can download and install `jr` without needing to build from source.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~1,200 |
| .github/workflows/release.yml (full current file) | ~1,500 |
| architecture-delta.md §3 (release design) | ~800 |
| ADR-0016 §Decision 1/2/5c | ~600 |
| **Total** | **~4,100** |

Small. No splitting required.

## Previous Story Intelligence

**Depends on S-WIN-3** (keyring `windows-native` feature must be in Cargo.toml before the
Windows release build will produce a functionally correct binary). The release.yml
change can be authored independently, but the release build MUST NOT be green until
S-WIN-3 has merged.

**Existing release.yml structure:**
The `build` job has a matrix with four rows (x86_64/aarch64 × apple-darwin/linux-gnu).
Each row has fields: `target`, `os`, optionally `use_cross`. All `run:` steps in the
build job are bash with no `shell:` override — they work on `windows-latest` via
Git Bash, but only if `shell: bash` is explicitly specified.

**`softprops/action-gh-release` step is in the `release` job on `ubuntu-latest`.**
No runner-compat issue for the release job itself.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| New matrix row format | architecture-delta.md §3.1 | `{ target: x86_64-pc-windows-msvc, os: windows-latest }`. No `use_cross` field. |
| `shell: bash` on all `run:` steps | architecture-delta.md §3.2 | Add `shell: bash` to ALL `run:` steps in the `build` job. Git Bash is pre-installed on `windows-latest`. This is a no-op for existing Unix rows. |
| No `cross` for Windows | architecture-delta.md §3.1 | The existing `Install cross` step is gated `if: matrix.use_cross`. The Windows row has no `use_cross`, so cross is correctly skipped. |
| Windows package step: `.zip` | architecture-delta.md §3.3; ADR-0016 §Decision 2 (re-amended per C-V3) | Artifact: `jr-<version>-x86_64-pc-windows-msvc.zip` containing `jr.exe`. TWO steps: (1) archive creation via PowerShell `Compress-Archive` (`shell: pwsh`) — this is built into PowerShell 5.1+ and is always present on `windows-latest`, immune to the `zip`-not-on-PATH constraint (C-V3 BLOCKER); (2) checksum via `sha256sum` in a separate `shell: bash` step — sha256sum is confirmed present via Git coreutils on `windows-latest`. Do NOT use the Unix `zip` command: it is not in the Git Bash bundle shipped on `windows-latest` runners and will cause the packaging step to fail. |
| Unix package step: `if: runner.os != 'Windows'` | architecture-delta.md §3.3 | Add the existing `Package` step's condition: `if: runner.os != 'Windows'`. Rename step to `Package (Unix)` for clarity. |
| Smoke-step gate | architecture-delta.md §3.4; ADR-0016 §Decision 5c | Add `if: runner.os != 'Windows'` to the "Verify embedded OAuth app present" step. No other change to the step body. |
| Upload-artifact glob | architecture-delta.md §3.5 | Add `jr-*.zip` to the `path:` block. The `.sha256` suffix is shared. |
| Release job files glob | architecture-delta.md §3.6 | Add `jr-*.zip` to the `files:` block in the `softprops/action-gh-release` step. |
| Binary name on Windows | architecture-delta.md §3.3 | Binary is `jr.exe` (not `jr`) on Windows. The Windows Package step must reference `jr.exe`. The Unix Package step must continue to reference `jr` (not `jr.exe`). |

## Library and Framework Requirements

| Tool | Source | Constraint |
|------|--------|-----------|
| `Compress-Archive` (PowerShell cmdlet) | Built into PowerShell 5.1+ (always present on `windows-latest`) | Use in `shell: pwsh` step to create the `.zip` archive. Command: `Compress-Archive -Path "target/${{ matrix.target }}/release/jr.exe" -DestinationPath "jr-${{ github.ref_name }}-${{ matrix.target }}.zip"`. No install step required. Research citation: C-V3 (`.factory/research/windows-build-f4-preflight-verification.md`). |
| `sha256sum` | Git coreutils bundled with Git for Windows (`C:\Program Files\Git\usr\bin\sha256sum.exe`) | Available on PATH in `shell: bash` steps. Use in a SEPARATE bash step after the PowerShell archive step. Confirmed present on `windows-latest` runners (C-V3 CONFIRMED). |
| ~~`zip`~~ | ~~Git Bash on `windows-latest`~~ | **DO NOT USE.** `zip` (Unix Info-ZIP) is NOT bundled with Git for Windows and is NOT on the PATH of `windows-latest` runners. Using `zip` in a bash step will fail with `command not found`. This was a BLOCKER (C-V3 REFUTED) — the prior spec's risk-acceptance is superseded. |
| `softprops/action-gh-release` | existing (pinned SHA in release.yml) | Accepts arbitrary file types including `.zip`. No version change needed. |

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `.github/workflows/release.yml` | MODIFY | See exact changes below |

**Changes to `.github/workflows/release.yml`:**

1. In the `build` job's `strategy.matrix.include` array, add:
   ```yaml
   - target: x86_64-pc-windows-msvc
     os: windows-latest
   ```

2. On ALL `run:` steps in the `build` job, add `shell: bash` where the shell is bash. The complete inventory of `run:` steps in the `build` job is:
   - **"Ensure cross-target installed (defensive)"** (`rustup target add ${{ matrix.target }}`) — present on all rows including Windows; add `shell: bash`.
   - **"Install cross"** (gated `if: matrix.use_cross`) — Windows row has no `use_cross`, so this step is skipped on Windows; add `shell: bash` regardless (no-op on Windows due to the gate).
   - **"Build"** (`cargo build ...`) — add `shell: bash`.
   - **"Package (Unix)"** (renamed from "Package"; gated `if: runner.os != 'Windows'`) — add `shell: bash`.
   - **"Package (Windows)"** (new step; gated `if: runner.os == 'Windows'`) — uses `shell: pwsh` (see item 4a below).
   - **"Checksum (Windows)"** (new step; gated `if: runner.os == 'Windows'`) — uses `shell: bash` (see item 4b below).
   - **"Verify embedded OAuth app present"** (smoke step; gated `if: runner.os != 'Windows'` per item 5) — add `shell: bash`.

3. Rename existing `Package` step to `Package (Unix)` and add `if: runner.os != 'Windows'`.

4. After the Unix Package step, add TWO steps (replacing the former single bash zip step):

   **Step 4a — Package (Windows)** — PowerShell Compress-Archive (C-V3 fix):
   ```yaml
   - name: Package (Windows)
     if: runner.os == 'Windows'
     shell: pwsh
     run: Compress-Archive -Path "target/${{ matrix.target }}/release/jr.exe" -DestinationPath "jr-${{ github.ref_name }}-${{ matrix.target }}.zip"
   ```

   **Step 4b — Checksum (Windows)** — sha256sum in bash (confirmed available):
   ```yaml
   - name: Checksum (Windows)
     if: runner.os == 'Windows'
     shell: bash
     run: sha256sum jr-${{ github.ref_name }}-${{ matrix.target }}.zip > jr-${{ github.ref_name }}-${{ matrix.target }}.zip.sha256
   ```

   Rationale: `Compress-Archive` is built into PowerShell 5.1+ and is always present on
   `windows-latest` (no install step required). `zip` (Unix Info-ZIP) is NOT available on
   `windows-latest` PATH — using it would fail with `command not found` (C-V3 BLOCKER).
   `sha256sum` remains in a separate `shell: bash` step because it is confirmed present via
   Git coreutils (C-V3 CONFIRMED) and the bash invocation form is consistent with the Unix steps.

5. Add `if: runner.os != 'Windows'` to the "Verify embedded OAuth app present" step.

6. In the `Upload artifact` step's `path:` block, add `jr-*.zip`.

7. In the `release` job's `softprops/action-gh-release` step's `files:` block, add `jr-*.zip`.

## Acceptance Criteria

### AC-001 — Windows matrix row is present in release.yml
(traces to NFR-P-W1 — Windows artifact produced on every release tag; ADR-0016 §Decision 1)

`.github/workflows/release.yml` build-job matrix includes a row for
`target: x86_64-pc-windows-msvc` on `os: windows-latest`.
No `use_cross` field in the Windows row.

Pinned by: `tests/release_yml_windows_matrix.rs::test_release_yml_has_windows_matrix_row`
(source-text grep of the workflow file)

---

### AC-002 — Package (Windows) and Checksum (Windows) steps use Compress-Archive + sha256sum
(traces to NFR-P-W1; ADR-0016 §Decision 2 re-amended per C-V3 BLOCKER)

`release.yml` contains TWO Windows-packaging steps (both gated `if: runner.os == 'Windows'`):

1. `Package (Windows)`: uses `shell: pwsh` and runs `Compress-Archive -Path "target/.../jr.exe" -DestinationPath "jr-...-x86_64-pc-windows-msvc.zip"`.
2. `Checksum (Windows)`: uses `shell: bash` and runs `sha256sum jr-...-x86_64-pc-windows-msvc.zip > jr-...-x86_64-pc-windows-msvc.zip.sha256`.

The `Package (Windows)` step MUST use `shell: pwsh` with `Compress-Archive`.
It MUST NOT use `shell: bash` with `zip` (Unix Info-ZIP is NOT on `windows-latest` PATH — C-V3 BLOCKER).

No tool-install step is needed: `Compress-Archive` is built into PowerShell 5.1+ which
is pre-installed on all `windows-latest` runners.

Pinned by: `test_release_yml_windows_package_step_produces_zip` (source-text grep — verifies `Compress-Archive` and `shell: pwsh` are present in the Package (Windows) step; NOT `zip` or `shell: bash`)

---

### AC-003 — Smoke step is gated off on Windows
(traces to ADR-0016 §Decision 5c — smoke step deferred for Windows v1)

The "Verify embedded OAuth app present" step in `release.yml` has
`if: runner.os != 'Windows'`. The step body is unchanged.

Pinned by: `test_release_yml_smoke_step_skipped_on_windows` (source-text grep)

---

### AC-004 — Upload-artifact glob includes `.zip`
(traces to NFR-P-W1 — Windows artifact uploaded to Actions artifacts)

The `Upload artifact` step's `path:` block contains `jr-*.zip` in addition to
the existing `jr-*.tar.gz` and `jr-*.sha256`.

Pinned by: `test_release_yml_upload_artifact_includes_zip` (source-text grep)

---

### AC-005 — Release job files glob includes `.zip`
(traces to NFR-P-W1 — Windows artifact included in GitHub Release)

The `softprops/action-gh-release` step's `files:` block contains `jr-*.zip`.

Pinned by: `test_release_yml_release_job_files_includes_zip` (source-text grep)

---

### AC-006 — Existing Unix matrix rows are unmodified
(traces to NFR-P-W1 invariant — existing 4 platform builds must remain green)

The four existing matrix rows (`x86_64-apple-darwin`, `aarch64-apple-darwin`,
`x86_64-unknown-linux-gnu`, `aarch64-unknown-linux-gnu`) are unchanged in their
target/os/use_cross fields. Their `Package (Unix)` step executes as before
(gated `if: runner.os != 'Windows'`). Adding `shell: bash` to `run:` steps is
a no-op on Unix runners.

Pinned by: integration: existing release CI green on next run (macOS/Linux artifact shape unchanged).

---

## Out of Scope (explicit)

- **ci.yml Windows job**: implemented in S-WIN-5.
- **Keyring feature**: implemented in S-WIN-3.
- **Path resolution**: implemented in S-WIN-1/S-WIN-2.
- **PowerShell-native smoke step for Windows**: deferred per ADR-0016 §Decision 5c.
- **`aarch64-pc-windows-msvc` target**: deferred per ADR-0016 §Decision 1.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `release.yml` Windows matrix row | `.github/workflows/` | N/A (CI config) | Instructs GitHub Actions to run the build job on `windows-latest` |
| `Package (Windows)` step | `.github/workflows/` | N/A (CI step) | Produces `.zip` and `.sha256` artifacts |
| Smoke step gate | `.github/workflows/` | N/A (CI step condition) | `if: runner.os != 'Windows'` skips step on Windows |

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC / BC |
|----|--------|-------------|-------------------|---------|
| EC-001 | architecture-delta.md §3.2 | `shell: bash` on an existing Unix `run:` step | No-op; bash is already the effective shell on ubuntu-latest and macos-latest | AC-006 |
| EC-002 | C-V3 BLOCKER — `.factory/research/windows-build-f4-preflight-verification.md` | `zip` (Unix Info-ZIP) is NOT available on `windows-latest` PATH. The runner ships Git for Windows 2.54 which bundles GNU coreutils (sha256sum confirmed) but does NOT bundle the separate `zip` package. Using `zip` in `shell: bash` fails with `command not found`. | **Handled by construction**: the `Package (Windows)` step uses PowerShell `Compress-Archive` (`shell: pwsh`), which is built into PowerShell 5.1+ and is always present on `windows-latest`. No fallback or install step is needed. `sha256sum` availability is confirmed via Git coreutils (C-V3 CONFIRMED) — the separate `Checksum (Windows)` bash step is reliable. The prior risk-acceptance language ("accepted LOW risk") is superseded; this is now resolved by design, not accepted risk. | AC-002 |
| EC-003 | ADR-0016 §Decision 5c | Smoke step skipped on Windows | BCryptGenRandom path verified implicitly by the build succeeding (build.rs panics if entropy unavailable) | AC-003 |
| EC-004 | architecture-delta.md §3.5 | `.sha256` glob already in upload path | `jr-*.sha256` covers both `jr-<ver>-<target>.tar.gz.sha256` and `jr-<ver>-<target>.zip.sha256` — no change needed to the sha256 glob | AC-004 |

---

## Test Coverage Summary

All tests in this story are source-text grep tests of `.github/workflows/release.yml`.
They are lightweight, always-run tests that catch accidental removal of the Windows
matrix row, package step, smoke gate, or artifact glob.

**Presence-only caveat:** AC-001 through AC-005 are YAML source-text assertions. They
verify that the required configuration text is present in `release.yml` but do NOT verify
that the resulting workflow executes correctly or that the `.zip` artifact is actually
produced. A misconfigured step (e.g., wrong path in Compress-Archive, wrong binary name)
would pass all five ACs while still producing an absent archive. The SOLE correctness gate
for the actual Windows release artifact is **H-WIN-6** — a human inspects the GitHub
Release page after a live version tag to confirm
`jr-<version>-x86_64-pc-windows-msvc.zip` and its `.sha256` are present as release
assets. (This mirrors the limitation explicitly codified in S-WIN-5 AC-004.)

**C-V3 correction note:** `test_release_yml_windows_package_step_produces_zip` must grep
for `Compress-Archive` and `shell: pwsh` in the `Package (Windows)` step — NOT for `zip`
or `shell: bash`. A test that greps for `zip` would incorrectly pass on the old (broken)
spec and fail to detect a regression to the unsafe `zip` invocation.

| Test name | File | AC |
|-----------|------|-----|
| `test_release_yml_has_windows_matrix_row` | `tests/release_yml_windows_matrix.rs` (new) | AC-001 |
| `test_release_yml_windows_package_step_produces_zip` | same file | AC-002 |
| `test_release_yml_smoke_step_skipped_on_windows` | same file | AC-003 |
| `test_release_yml_upload_artifact_includes_zip` | same file | AC-004 |
| `test_release_yml_release_job_files_includes_zip` | same file | AC-005 |

---

## Holdout Scenarios

**H-WIN-6: Release pipeline produces Windows `.zip` artifact on a version tag**
After merging S-WIN-1/2/3/4, triggering a release tag on GitHub Actions produces
`jr-<version>-x86_64-pc-windows-msvc.zip` and `jr-<version>-x86_64-pc-windows-msvc.zip.sha256`
as GitHub Release assets.
_Validation: GitHub Release page for the tag shows the `.zip` artifact alongside the
four existing `.tar.gz` artifacts._

**H-WIN-7: macOS and Linux release artifacts are unchanged**
The release run produces the four existing `.tar.gz` + `.sha256` artifacts unmodified.
No artifact names or checksums change for existing platforms.
_Validation: existing artifact name patterns match; checksum files are present._

---

## Dependency Analysis

**depends_on: ["S-WIN-3"]** — The Windows release build requires `windows-native` in
Cargo.toml (S-WIN-3) for credentials to work. The release.yml change can be authored
and merged before S-WIN-3, but the Windows CI run will not produce a fully functional
binary until S-WIN-3 is merged.

**blocks: []** — No other story directly depends on this.

No cycle.

---

## Tasks

1. Read `.github/workflows/release.yml` to understand current structure.
2. Read architecture-delta.md §3 for exact step shapes.
3. Add Windows matrix row to `build` job.
4. Add `shell: bash` to all `run:` steps in the `build` job.
5. Split existing `Package` step into three parts: `Package (Unix)` (gated `if: runner.os != 'Windows'`, `shell: bash`, unchanged tarball logic), `Package (Windows)` (gated `if: runner.os == 'Windows'`, `shell: pwsh`, uses `Compress-Archive` — NOT `zip`), and `Checksum (Windows)` (gated `if: runner.os == 'Windows'`, `shell: bash`, uses `sha256sum`). See File Structure Requirements item 4 for exact YAML.
6. Add `if: runner.os != 'Windows'` to smoke step.
7. Add `jr-*.zip` to upload-artifact path block and release-job files block.
8. Create `tests/release_yml_windows_matrix.rs` with 5 source-text assertions.
9. Run `cargo test --test release_yml_windows_matrix` — passes.
10. Run `cargo clippy -- -D warnings` — zero warnings.

## Story Points and Effort

**5 story points.** Medium — YAML surgery on a live CI file with 5 distinct change sites
and 5 corresponding source-text tests.

Breakdown:
- F4 implementation (YAML edits + 5 source-text tests): 3 SP
- F5/F7 adversarial review + live CI verification: 2 SP
