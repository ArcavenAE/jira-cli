---
document_type: story
story_id: "S-FORK-OPS-BACKFILL-1"
title: "backfill-release.yml: Windows matrix parity + check-then-upsert (non-destructive release)"
wave: feature-followup
status: draft
intent: bug-fix
feature_type: infrastructure
mode: feature
scope: standard
severity: MED
trivial_scope: false
points: 5
priority: P2
tdd_mode: strict
estimated_effort: small
estimated_days: 1.5
target_module: ci
subsystems: []
depends_on: []
blocks: []
bc_anchors: []
bcs: []
# BC status: pending PO authorship
# No product BCs are added or modified by this story. The BC catalog count is unchanged.
# All items are CI/CD workflow changes with zero src/ runtime impact.
# These parity and upsert requirements are engineering-implementation constraints on
# workflow files, not product behavioral contracts. No existing BCs are modified.
# Do NOT add BCs to this story.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/phase-f2-spec-evolution/spec-delta-fork-ops-backfill.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-06-18"
version: "1.0"
last_updated: "2026-06-18"
changelog:
  - "1.0 (2026-06-18): Initial story decomposition — Phase F3."
breaking_change: false
lineage:
  - S-WIN-4          # established the PowerShell Compress-Archive / .zip packaging pattern in release.yml
  - S-FORK-OPS-SIGN-1  # hardened backfill-release.yml sign job CWE-77 + pipefail; build/release jobs unchanged
drift_items:
  - FORK-OPS-BACKFILL-WIN-TARGET
  - FORK-OPS-BACKFILL-DESTRUCTIVE
files_modified:
  - .github/workflows/backfill-release.yml  # MODIFY — add Windows matrix entry + 4 platform-conditional steps + upsert logic
  - tests/backfill_matrix_parity.rs         # NEW — required matrix-parity guard (REQUIRED, not optional)
---

# S-FORK-OPS-BACKFILL-1 — `backfill-release.yml`: Windows matrix parity + check-then-upsert

## Source of Truth

F1 Delta Analysis: `.factory/phase-f1-delta-analysis/delta-analysis-fork-ops-backfill-1.md`
F2 Spec Delta: `.factory/phase-f2-spec-evolution/spec-delta-fork-ops-backfill.md`
Verification Delta: `.factory/phase-f2-spec-evolution/verification-delta-fork-ops-backfill.md`
Precedent: S-WIN-4 (PowerShell packaging in `release.yml`), S-FORK-OPS-SIGN-1 (CWE-77 env-binding in `backfill-release.yml` sign job)

## Behavioral Contracts

No product BCs are added or modified by this story. The BC catalog count is unchanged.

**Why no BC anchor:** Both drift items (FORK-OPS-BACKFILL-WIN-TARGET and
FORK-OPS-BACKFILL-DESTRUCTIVE) are CI/CD workflow changes. They do not modify
`src/` production runtime behavior, nor do they change any externally observable
postcondition, precondition, or invariant of any `jr` domain entity.
`backfill-release.yml` is always INERT in the canonical repo's scheduled path
(`RELEASE_GAP_FILL_ENABLED` is unset) and is only reachable via manual
`workflow_dispatch`.

This story traces its ACs to the named drift items, following the convention used
by S-FORK-OPS-SIGN-1 and S-CIGATE-1 (CI-infra stories with no product BC surface).

## Story Narrative

As a fork maintainer using `backfill-release.yml` to fill release gaps,
I want the backfill workflow to produce Windows binaries alongside the existing
Unix artifacts and to preserve curator-edited release notes on re-runs,
so that backfilled releases are complete (matching `release.yml` artifact set)
and safe to re-run without destroying manually curated release notes.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~6,000 |
| `.github/workflows/backfill-release.yml` (~200 LOC as of S-FORK-OPS-SIGN-1 merge) | ~2,600 |
| `.github/workflows/release.yml` (reference for Windows step bodies, ~130 LOC of Windows steps) | ~1,700 |
| `tests/ci_yml_windows_matrix.rs` (implementation shape reference, ~120 LOC) | ~1,600 |
| F2 spec delta (spec-delta-fork-ops-backfill.md, normative contract) | ~3,500 |
| Verification delta (verification-delta-fork-ops-backfill.md) | ~1,200 |
| Tool outputs (grep / cargo test verification) | ~500 |
| **Total** | **~17,100** |

Well within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**S-WIN-4** established the exact PowerShell `Compress-Archive` / `.zip` packaging
pattern in `release.yml`. Step bodies for `Package (Windows)`, `Checksum (Windows)`,
`Smoke test (Windows)`, and `Embedded OAuth verification (Windows)` MUST be copied
verbatim from that file — not invented. The `$ErrorActionPreference = 'Stop'` +
explicit `$LASTEXITCODE` check in the smoke test is load-bearing and must not be
omitted.

**S-FORK-OPS-SIGN-1** (MERGED PR #535) hardened `backfill-release.yml`'s `sign`
job: CWE-77 env-binding for `${{ inputs.tag }}` in run-blocks, `mktemp`+`trap`,
`pipefail`. That story did NOT touch the `build` or `release` jobs. This story
touches `build` (new matrix entry + Windows steps) and `release` (upsert logic).
There is no edit overlap — but verify that the `needs:` chain among `build`,
`sign`, and `release` jobs is undisturbed after the edits.

**S-CIGATE-1** (MERGED): the ci-gate aggregator is already wired. This story adds
NO new CI jobs to `ci.yml`, so `ci-gate.needs` requires no change.

The `tests/backfill_matrix_parity.rs` test follows the anchoring technique from
`tests/ci_yml_windows_matrix.rs`: extract a named YAML block, then assert within
it — not over the full file.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| CWE-77 env-binding for `inputs.*` in run-blocks | `docs/specs/fork-friendly-release-ops.md` § "No inline context data in shell run-blocks" | `inputs.tag` MUST be bound via step-level `env: RELEASE_TAG: ${{ inputs.tag }}` and referenced as `"${RELEASE_TAG}"` (bash) or `"${env:RELEASE_TAG}"` (PowerShell) in every new `run:` block. `${{ matrix.target }}` is author-controlled static literal — explicitly exempt. `${{ github.repository }}` is on the format-safe allowlist — no binding needed. |
| Unix Package step name unchanged | F2 spec delta § "Step naming note" | The existing `Package` step MUST retain its name `Package`. Do NOT rename it to `Package (Unix)` to match `release.yml`. Only the `if:` condition is added; the step name, body, and `env:` block are untouched. |
| Windows step bodies verbatim from release.yml | F2 spec delta § "Add Package (Windows) Step" et seq. | The four new Windows steps MUST mirror their counterparts in `release.yml` (S-WIN-4 precedent) with only the `inputs.tag`→`env: RELEASE_TAG` substitution in `Package (Windows)` and `Checksum (Windows)`. Smoke test and embedded-OAuth verification are verbatim copies. |
| Upsert invariants | F2 spec delta § "Invariants this replacement enforces" (Invariants 1–8) | Eight behavioral invariants listed in the spec; all must hold. Key: `--generate-notes` only on initial creation; `|| true` silencer removed; `jr-*.zip` in BOTH upsert branches; draft-release emits `::warning::` but does NOT auto-publish; prerelease flag NOT passed to `gh release upload`. |
| SIGNING_ENABLED and other repo vars unchanged | S-FORK-OPS-SIGN-1 precedent | This story MUST NOT set or change `SIGNING_ENABLED`, `RELEASE_GAP_FILL_ENABLED`, or any other repo variable. The workflow remains INERT in the canonical repo. |
| No src/ changes | F1 delta analysis § "Impact Assessment" | `src/` files are read-only for this story. |
| CWE-77 injection guard must pass | Verification delta § "Existing: scripts/check-signing-workflow-injection.sh" | After adding Windows steps, `bash scripts/check-signing-workflow-injection.sh` MUST exit 0. The `build` job is in-scope for the guard (it references `secrets.OAUTH_CLIENT_ID`/`OAUTH_CLIENT_SECRET`). New Windows run-blocks reference only `matrix.target` (exempt) and `RELEASE_TAG` (env-bound). |

## Library and Framework Requirements

No new library or framework dependencies. All changes are YAML workflow edits
and a new Rust test file using only `std::fs` (already used in
`tests/ci_yml_windows_matrix.rs`).

| Item | Version / Constraint |
|------|---------------------|
| `gh` CLI | Already available on GitHub Actions runners — no version pin needed |
| PowerShell (`pwsh`) | Available on `windows-latest` GitHub Actions runners — no install step |
| `sha256sum` (bash on Windows) | Available in Git Bash shipped with `windows-latest` runners |
| `std::fs` (Rust test) | Already in std; no new crate dependency |

Do not add any new entries to `Cargo.toml` or `deny.toml`.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `.github/workflows/backfill-release.yml` | MODIFY | See Tasks for complete edit list. Summary: (1) add `x86_64-pc-windows-msvc` matrix row; (2) add `if: runner.os != 'Windows'` to `Package` step; (3) add `Package (Windows)`, `Checksum (Windows)`, `Smoke test (Windows)`, `Embedded OAuth verification (Windows)` steps in that order; (4) add `jr-*.zip` to `Upload artifact` path; (5) replace delete+create in `release` job with check-then-upsert. |
| `tests/backfill_matrix_parity.rs` | CREATE | Required matrix-parity guard. Assert that `backfill-release.yml` and `release.yml` build matrices contain exactly the same five target strings (order-independent set equality). Follow `tests/ci_yml_windows_matrix.rs` implementation shape. |

**Files NOT to create:** No new Rust source files, no new spec files, no new BC
documents, no new ADR.

**Files NOT to touch:** `src/` (all production source), `.factory/specs/`,
`Cargo.toml`, `deny.toml`, all BC count surfaces (`bc-*.md` frontmatter,
`BC-INDEX.md`, `CANONICAL-COUNTS.md`), `.github/workflows/ci.yml`,
`.github/workflows/release.yml`, `.github/workflows/sign-and-publish.yml`.

## Acceptance Criteria

### AC-001 (FORK-OPS-BACKFILL-WIN-TARGET) — Windows matrix entry present in `backfill-release.yml`

`backfill-release.yml` `jobs.build.strategy.matrix.include` contains a fifth entry
with `target: x86_64-pc-windows-msvc` and `os: windows-latest`, following the four
existing entries (x86_64-apple-darwin, aarch64-apple-darwin, x86_64-unknown-linux-gnu,
aarch64-unknown-linux-gnu).

The existing `Package` step carries `if: runner.os != 'Windows'`.

The four Windows-only steps appear in order after the (now Unix-conditional) `Package`
step and before `Upload artifact`:
1. `Package (Windows)` — `if: runner.os == 'Windows'`, PowerShell `Compress-Archive`;
   `RELEASE_TAG` env-bound
2. `Checksum (Windows)` — `if: runner.os == 'Windows'`, bash `sha256sum`; `RELEASE_TAG`
   env-bound
3. `Smoke test (Windows)` — `if: runner.os == 'Windows'`, PowerShell `.\jr.exe --version`
   with `$ErrorActionPreference = 'Stop'` and explicit `$LASTEXITCODE` check
4. `Embedded OAuth verification (Windows)` — `if: runner.os == 'Windows'`, PowerShell
   with `HAS_EMBED_SECRETS` bound via `env:`

`Upload artifact` path includes `jr-*.zip` alongside `jr-*.tar.gz` and `jr-*.sha256`.

**Verifiable by:**
```bash
# Windows matrix entry present
grep 'x86_64-pc-windows-msvc' .github/workflows/backfill-release.yml
# Expected: matches (in matrix.include)

# Unix Package step is conditional
grep -A1 'name: Package$' .github/workflows/backfill-release.yml | grep "runner.os != 'Windows'"
# Expected: matches

# Package (Windows) step present
grep "name: Package (Windows)" .github/workflows/backfill-release.yml
# Expected: matches

# Upload artifact includes .zip
grep 'jr-\*\.zip' .github/workflows/backfill-release.yml
# Expected: matches (≥2 hits: Upload artifact + upsert branches)
```

(traces to drift item FORK-OPS-BACKFILL-WIN-TARGET — missing Windows build target in backfill-release.yml)

---

### AC-002 (FORK-OPS-BACKFILL-DESTRUCTIVE) — check-then-upsert replaces delete+create

In `backfill-release.yml` `jobs.release.steps[name="Create or update GitHub Release"]`,
the old `gh release delete ... || true` + `gh release create --generate-notes` pattern
is REPLACED by the check-then-upsert block:

1. `if gh release view "$TAG" ... >/dev/null 2>&1; then` — check for existing release
2. In the exists-branch: check `isDraft` via `--json isDraft --jq '.isDraft'`; emit
   `::warning::` if draft; call `gh release upload "$TAG" --clobber jr-*.tar.gz jr-*.zip
   jr-*.sha256`; do NOT set `--draft false`; do NOT pass `$PRERELEASE`
3. In the else-branch: `gh release create "$TAG" --generate-notes $PRERELEASE jr-*.tar.gz
   jr-*.zip jr-*.sha256`

The `|| true` silencer from the old `gh release delete` line is ABSENT. The
`gh release delete` line itself is ABSENT.

`jr-*.zip` appears in BOTH the upload branch AND the create branch (asset-completeness
invariant).

**Verifiable by:**
```bash
# Old delete pattern must be gone
grep 'release delete' .github/workflows/backfill-release.yml
# Expected: empty

# || true silencer on a gh command must be gone
grep '|| true' .github/workflows/backfill-release.yml
# Expected: empty (or only in unrelated context — confirm manually)

# upsert logic present
grep 'gh release view' .github/workflows/backfill-release.yml
# Expected: matches

# isDraft check present
grep 'isDraft' .github/workflows/backfill-release.yml
# Expected: matches

# jr-*.zip in upload branch
grep 'jr-\*\.zip' .github/workflows/backfill-release.yml
# Expected: ≥2 matches (upload and create branches both include it)
```

(traces to drift item FORK-OPS-BACKFILL-DESTRUCTIVE — destructive delete+create clobbers curated release notes)

---

### AC-003 (CWE-77 compliance) — All new `run:` blocks comply with env-binding rule

Every new `run:` block in `backfill-release.yml` that references `inputs.tag`
binds it via `env: RELEASE_TAG: ${{ inputs.tag }}` and references it as
`"${RELEASE_TAG}"` (bash) or `"${env:RELEASE_TAG}"` (PowerShell). No inline
`${{ inputs.tag }}` appears in any `run:` block body in the Windows steps or the
upsert block.

`scripts/check-signing-workflow-injection.sh` exits 0 against the modified file
(`build` job is in-scope via secrets reference; `release` job is in-scope via
`contents: write` permission).

**Verifiable by:**
```bash
# No inline inputs.tag in run-blocks (allowlisted values and env:/if:/with: keys ignored)
bash scripts/check-signing-workflow-injection.sh
# Expected: exit 0 with summary "K flagged: 0"

# Confirm RELEASE_TAG env-binding in new Windows steps
grep -B2 'env:RELEASE_TAG\|env:.*RELEASE_TAG' .github/workflows/backfill-release.yml | grep -c 'RELEASE_TAG'
# Expected: ≥2 (Package (Windows) and Checksum (Windows) each bind it)
```

(traces to drift item FORK-OPS-BACKFILL-WIN-TARGET CWE-77 note in spec delta §"CWE-77 Compliance Summary")

---

### AC-004 (REQUIRED test) — `tests/backfill_matrix_parity.rs` asserts 5-target set equality

`tests/backfill_matrix_parity.rs` exists and contains a test that:

1. Reads both `backfill-release.yml` and `release.yml` (relative to `CARGO_MANIFEST_DIR`)
2. Parses `jobs.build.strategy.matrix.include` from each file to extract the `target:`
   string values
3. Asserts set equality — the five targets present in `release.yml` must ALL be
   present in `backfill-release.yml`, and no unexpected targets added:
   - `x86_64-apple-darwin`
   - `aarch64-apple-darwin`
   - `x86_64-unknown-linux-gnu`
   - `aarch64-unknown-linux-gnu`
   - `x86_64-pc-windows-msvc`
4. Test passes only when both files have exactly these five targets (order-independent)
5. Follows `tests/ci_yml_windows_matrix.rs` implementation shape (extract named YAML
   block by anchoring, then match within it)

`cargo test --test backfill_matrix_parity` exits 0 after Story 1 implementation.

**Verifiable by:**
```bash
# Test file exists
ls tests/backfill_matrix_parity.rs
# Expected: exists

# Test passes
cargo test --test backfill_matrix_parity
# Expected: exit 0, test function green
```

(traces to verification delta § "Required New Test: backfill-release.yml Matrix Parity Guard")

---

### AC-005 (Integration) — cargo test, clippy, fmt, and spec-count checks all pass

1. `cargo test` exits 0 (no Rust source touched beyond the new test file; no regressions)
2. `cargo clippy -- -D warnings` exits 0
3. `cargo fmt --all -- --check` exits 0
4. `bash scripts/check-spec-counts.sh` exits 0 (no BC files touched; counts unchanged)
5. `bash scripts/check-bc-cumulative-counts.sh` exits 0 (no cumulative count drift)
6. `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 (no BC files touched)
7. `bash scripts/check-signing-workflow-injection.sh` exits 0 (new Windows steps are
   CWE-77 compliant; guard must not flag them)
8. The `needs:` chain in `backfill-release.yml` (build → sign → release) is intact —
   no job references a non-existent predecessor job name

(traces to drift items collectively — end-to-end integration gate)

---

## Tasks

### Item 1: Read current `backfill-release.yml` and `release.yml` in full

- [ ] Read `.github/workflows/backfill-release.yml` — understand current `build` job
  matrix, step names, `sign` job structure (do NOT modify), `release` job upsert target
- [ ] Read `.github/workflows/release.yml` — copy exact step bodies for `Package (Windows)`,
  `Checksum (Windows)`, `Smoke test (Windows)`, `Embedded OAuth verification (Windows)`

### Item 2: Add Windows matrix entry and Platform-conditional Package step

- [ ] In `jobs.build.strategy.matrix.include`, append the fifth entry after the four
  existing entries:
  ```yaml
  - target: x86_64-pc-windows-msvc
    os: windows-latest
  ```
- [ ] Add `if: runner.os != 'Windows'` to the existing `Package` step (add `if:` key
  only; do NOT rename the step or change its body or env block)

### Item 3: Add Windows steps (in spec-delta step-ordering order)

Insert steps 8–11 from the spec's "Step Ordering" list, after the (now conditional)
`Package` step and before `Upload artifact`:

- [ ] `Package (Windows)` — mirror `release.yml` step body; substitute
  `env: RELEASE_TAG: ${{ inputs.tag }}` (already done in release.yml for
  `github.ref_name`; adapt the env key name)
- [ ] `Checksum (Windows)` — mirror `release.yml` step body; substitute
  `env: RELEASE_TAG: ${{ inputs.tag }}`
- [ ] `Smoke test (Windows)` — verbatim copy from `release.yml`
  (no `inputs.tag` reference; `matrix.target` exempt)
- [ ] `Embedded OAuth verification (Windows)` — verbatim copy from `release.yml`
  (`HAS_EMBED_SECRETS` bound via `env:` already; no `inputs.tag` reference)

### Item 4: Update `Upload artifact` path

- [ ] In `jobs.build.steps[name="Upload artifact"]`, add `jr-*.zip` to the `path:` block
  between `jr-*.tar.gz` and `jr-*.sha256` (mirrors spec-delta "Update Upload Artifact Step")

### Item 5: Replace delete+create with check-then-upsert in `release` job

- [ ] Read `jobs.release.steps[name="Create or update GitHub Release"]` current block
- [ ] Remove the `gh release delete "$TAG" --yes ... 2>/dev/null || true` line entirely
- [ ] Remove the existing `gh release create ... --generate-notes ...` block
- [ ] Insert the check-then-upsert block from spec-delta § "Replacement" exactly:
  - `if gh release view "$TAG" ...` exists branch with `isDraft` check + `::warning::` +
    `gh release upload --clobber jr-*.tar.gz jr-*.zip jr-*.sha256`
  - else branch with `gh release create --generate-notes $PRERELEASE jr-*.tar.gz jr-*.zip
    jr-*.sha256`
- [ ] Confirm `jr-*.zip` is in BOTH branches
- [ ] Confirm `$PRERELEASE` is NOT passed to `gh release upload` (exists branch)

### Item 6: Create `tests/backfill_matrix_parity.rs`

- [ ] Read `tests/ci_yml_windows_matrix.rs` in full for implementation shape reference
- [ ] Create `tests/backfill_matrix_parity.rs` with:
  - Helper: `read_yaml_file(filename)` — reads file relative to `CARGO_MANIFEST_DIR`,
    normalizes CRLF to LF
  - Helper: `extract_build_matrix_targets(yaml_content)` — parses
    `jobs.build.strategy.matrix.include` and extracts `target:` strings
    (text-pattern extraction, not full YAML parse — match `target:` lines within the
    matrix block)
  - Test `test_backfill_matrix_parity_matches_release_yml`:
    - Load both files
    - Extract target sets from each
    - Assert `backfill_targets == release_targets` (set equality, order-independent)
    - Assert both contain exactly the five expected targets
- [ ] Run `cargo test --test backfill_matrix_parity` — must pass
- [ ] Verify the test would FAIL if `x86_64-pc-windows-msvc` were absent from
  `backfill-release.yml` (regression guard property)

### Item 7: CWE-77 guard verification

- [ ] Run `bash scripts/check-signing-workflow-injection.sh` — must exit 0
- [ ] Confirm no `${{ inputs.tag }}` appears in any `run:` block body in the modified file

### Integration checks (all must pass before PR)

- [ ] `cargo test` exits 0
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0
- [ ] `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0
- [ ] `bash scripts/check-signing-workflow-injection.sh` exits 0

## Out of Scope

**Unix embedded-OAuth verification step parity:** `release.yml` has a
`Verify embedded OAuth app present` step for Unix builds. `backfill-release.yml`
currently has no Unix equivalent, and WIN-TARGET does NOT add one. This is a
pre-existing parity gap that is OUT OF SCOPE for this story. F5 must not flag its
absence as an omission introduced by this change.

**Defensive `rustup target add` removal:** The existing
`Ensure target installed (defensive)` step (`if: !matrix.use_cross`) runs a harmless
no-op for the new `x86_64-pc-windows-msvc` entry. Do NOT remove it. It is required
for parity with `release.yml` and protects against future `rust-toolchain.toml`
component changes.

**Enabling `RELEASE_GAP_FILL_ENABLED` in the canonical repo:** Out of scope.
The workflow remains INERT in the canonical scheduled path.

**Any change to Cargo.toml, deny.toml, or src/:** No Rust source or dependency changes
beyond the new test file.

**New BCs, new VPs, new NFRs, new ADRs:** Not applicable to CI/CD workflow changes.

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `backfill-release.yml` | `.github/workflows/` | Effectful (GitHub Actions runner, GitHub API, Apple codesign) | Windows matrix entry and upsert logic edits live here |
| `tests/backfill_matrix_parity.rs` | `tests/` | Pure (reads YAML files, asserts text patterns, no side effects) | Required matrix-parity regression guard |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | F2 spec delta §DESTRUCTIVE Invariant 6 | Release exists and is a draft when backfill runs | Upload branch uses `gh release upload --clobber`; emits `::warning::Release $TAG is a draft. Uploading assets but NOT publishing — curator must manually publish.`; does NOT set `--draft false`. The draft→published flip is curator intent. |
| EC-002 | F2 spec delta §DESTRUCTIVE Invariant 7 | Release exists and was previously marked as prerelease | Upload branch passes NO `$PRERELEASE` flag to `gh release upload`. The prerelease flag from prior curator/creation intent is preserved. Only the initial `create` branch sets the flag from the `*-*` tag-name heuristic. |
| EC-003 | F2 spec delta §"Edge case — release exists but has no assets (partial prior run)" | A prior `workflow_dispatch` created the GitHub release but the build job failed before uploading artifacts | `gh release view` returns exit 0 (release exists); upload branch runs `gh release upload --clobber` against a release with no assets. `--clobber` is idempotent on an asset-less release — exits 0, uploads artifacts cleanly. |
| EC-004 | F2 spec delta §DESTRUCTIVE Invariant 8 | Two concurrent `workflow_dispatch` runs for the same tag both arrive at the `view` check simultaneously, both see no existing release, and both attempt `gh release create` | First runner to `create` wins (HTTP 201). Second runner fails loudly (non-zero exit, visible in Actions UI — no `|| true` silencer). A subsequent re-run finds the release exists and takes the upload path. This is intended behavior. |
| EC-005 | F2 spec delta §"Note: Defensive rustup target add" | `rust-toolchain.toml` pins a channel that changes available components | The `Ensure target installed (defensive)` step (`rustup target add ${{ matrix.target }}`) runs as a harmless no-op for `x86_64-pc-windows-msvc` on `windows-latest` (native triple already present). It MUST NOT be removed — it guards against future toolchain component changes. |
| EC-006 | CWE-77 §"Scope note" | Injection guard scans `build` job (in-scope via secrets) | All new `run:` blocks in the `build` job reference only `matrix.target` (author-controlled exempt) and `RELEASE_TAG` (env-bound). Guard exits 0. |

## Dependency Analysis

**depends_on: []** — No story dependencies. This is a standalone infrastructure story.
S-WIN-4 and S-FORK-OPS-SIGN-1 are lineage ancestors (patterns followed) but are already
MERGED; there is no runtime dependency. Topological order: leaf node.

**blocks: []** — No story depends on this story within the current story graph.
S-FORK-OPS-GITLEAKS-DOC-1 modifies different files (docs/CLAUDE.md) and is fully
independent.

**Conflict check:** S-FORK-OPS-GITLEAKS-DOC-1 touches `docs/specs/fork-friendly-release-ops.md`
and `CLAUDE.md`. This story touches `.github/workflows/backfill-release.yml` and
`tests/backfill_matrix_parity.rs`. No file overlap — both stories can be implemented
and merged in any order without conflict.

---

## Story Points and Effort

**5 story points** (small/medium). Breakdown:
- Item 2 (Windows matrix entry + Unix Package conditional): 0.5 SP
- Item 3 (Add 4 Windows steps — mostly verbatim copy from release.yml): 0.5 SP
- Item 4 (Upload artifact glob update): 0.25 SP
- Item 5 (Upsert replace delete+create — behavioral change with invariants): 1.5 SP
- Item 6 (Create `tests/backfill_matrix_parity.rs`): 1.5 SP
- Item 7 (CWE-77 guard verification): 0.5 SP
- Integration checks: 0.25 SP

Risk: LOW for Items 2–4 (verbatim copies from release.yml). MEDIUM for Item 5
(upsert logic must satisfy 8 invariants; draft-detection and prerelease-flag
asymmetry are easy to get wrong). LOW for Item 6 (text-pattern YAML parsing is
well-precedented in `tests/ci_yml_windows_matrix.rs`).

**Critical path for this bundle:** This story (S-FORK-OPS-BACKFILL-1) is the
critical path. S-FORK-OPS-GITLEAKS-DOC-1 is a trivial doc change (1 SP).
