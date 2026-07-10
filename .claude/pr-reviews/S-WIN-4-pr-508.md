# PR #508 Review — ci(S-WIN-4): Windows build matrix + .zip packaging

**Branch:** feat/win-4-release-yml-windows → develop
**Verdict:** APPROVE

## Scope verified
Diff touches exactly two files (`.github/workflows/release.yml`, `tests/release_yml_windows_matrix.rs`), 401 insertions / 1 deletion. No stray `.claude/` artifacts. Commits use conventional format with story ID. CI 11/11 green. All 5 tests pass locally.

## AC coverage (6/6)

| AC | Status | Evidence |
|----|--------|----------|
| AC-001 matrix row | PASS | release.yml:27-28 — `x86_64-pc-windows-msvc` / `windows-latest`, no `use_cross` |
| AC-002 Compress-Archive + sha256sum | PASS | Package (Windows) pwsh/Compress-Archive (82), Checksum (Windows) bash/sha256sum (87) |
| AC-003 smoke gate | PASS | `if: runner.os != 'Windows'` on smoke step (90) |
| AC-004 upload glob | PASS | `jr-*.zip` in upload path block (169) |
| AC-005 release glob | PASS | `jr-*.zip` in release files block (194) |
| AC-006 Unix rows unmodified | PASS | rows 18-26 unchanged; `shell: bash` additions are no-ops on Unix |

## Correctness checks
- Binary name: Windows step references `jr.exe` (82), Unix step references `jr` (71). Correct.
- Glob `jr-*.sha256` covers both `.tar.gz.sha256` and `.zip.sha256` — no separate zip-checksum glob needed.
- `shell: bash` added to all build-job run: steps (44, 49, 53, 68, 86, 91). No-op on Unix via Git Bash.
- Negative assertion `!pkg_block.contains("zip ")` is sound — verified no `zip `+space token in the Package (Windows) block (the `.zip"` suffix has no trailing space).

## Test quality
All 5 tests use the `step_block()` helper to anchor assertions to the owning step's YAML block (start-name → next `\n      - name:`). This makes AC-004 and AC-005 fail independently (both globs are `jr-*.zip` but live in different steps), and prevents the adjacent Checksum bash step from satisfying AC-002's `shell: pwsh` positive assertion. AC-002 greps for `Compress-Archive`/`shell: pwsh` and explicitly NOT `zip`/`shell: bash`, correctly discriminating against the superseded C-V3 broken spec.

## Findings
None blocking. Two nits below.

### NIT-1 (coverage) — presence-only tests
The 5 tests are source-text greps; they cannot verify the Compress-Archive `-Path` resolves to a real artifact or that the resulting workflow executes. This is explicitly acknowledged in the test module docstring and routed to holdout H-WIN-6 (human inspection of the Release page after a live tag). ACCEPTED — correctly scoped; no action.

### NIT-2 (correctness) — redundant rustup target add on Windows
`Ensure cross-target installed (defensive)` (gated `if: ${{ !matrix.use_cross }}`) runs on Windows and re-adds a target already installed by the `Install Rust` step's `targets:` field. Harmless and intentional ("defensive" per step name); consistent with existing Unix rows. ACCEPTED — no action.

## Verdict: APPROVE
