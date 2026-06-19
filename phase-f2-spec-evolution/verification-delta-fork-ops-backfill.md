---
document_type: verification-delta
feature: fork-ops-backfill-parity
bundle: S-FORK-OPS-BACKFILL
created: 2026-06-18
new_vps: []
modified_vps: []
phase: F2
traces_to:
  - ".factory/phase-f1-delta-analysis/delta-analysis-fork-ops-backfill-1.md"
  - ".factory/phase-f2-spec-evolution/adversarial-spec-delta-review-pass1.md"
revised: 2026-06-18
revision_reason: "Pass 1 adversarial review — H3 (promote backfill matrix parity guard from CANDIDATE/SHOULD to REQUIRED Story-1 acceptance criterion), L1/process-gap (remove F4-discretion escape hatch)."
---

# Verification Delta — S-FORK-OPS-BACKFILL (Fork-Ops Backfill Parity)

## Finding: No New Verification Properties

This bundle introduces **zero new VP-NNN verification properties**.

VPs cover behavioral contracts of the `jr` binary (CLI surface, output shapes,
state mutations, authentication flows, API integration). The three drift items
resolved by this bundle affect only GitHub Actions workflow YAML and documentation
— none of which is in scope for formal property verification.

## Existing Verification Coverage Unchanged

The full VP catalog and its coverage matrix in `.factory/specs/verification/` are
unaffected. No VP is withdrawn, modified, or reclassified.

## Verification Mechanisms That Apply to This Bundle

Although no new VPs are required, the bundle's correctness surface is covered by
two existing mechanisms and one new-test candidate:

### Existing: `scripts/check-signing-workflow-injection.sh` (+ `--self-test`)

This script scans `backfill-release.yml` (and `sign-and-publish.yml`) for CWE-77
violations — inline `${{ }}` expansions of non-allowlisted context expressions
inside `run:` blocks. It is wired into the CI gate.

**Obligation for Story 1 (F4 implementer + F5 reviewer):** After adding the Windows
steps to `backfill-release.yml`, the script MUST continue to pass. Any new
`run:` block that references `inputs.tag` must use `env: RELEASE_TAG: ${{
inputs.tag }}` and reference `"${RELEASE_TAG}"` or `"${env:RELEASE_TAG}"`. If
the script fails after the edit, the injection pattern was introduced — fix before
merge.

The `--self-test` flag exercises the guard's own detection logic against a
known-bad fixture. Run it as part of F5 adversarial validation:

```bash
scripts/check-signing-workflow-injection.sh --self-test
```

Exit 0 = guard operative. Exit non-zero = guard broken or new violation detected.

### Existing: `tests/ci_gate_completeness.rs`

The test `test_ci_gate_needs_contains_all_required_jobs` validates that `ci.yml`'s
`ci-gate.needs` contains all expected jobs. This bundle adds no new CI jobs to
`ci.yml`, so this test continues to pass without change.

### Required New Test: `backfill-release.yml` Matrix Parity Guard

**Status: REQUIRED. This is a Story 1 (S-FORK-OPS-BACKFILL-1) acceptance criterion.**
Story 1 is not complete without this test.

**Rationale:** `tests/ci_yml_windows_matrix.rs` was made a REQUIRED guard (not
a recommendation) after S-WIN-5 introduced the Windows matrix entry to `ci.yml`.
The drift class is identical: a future refactor of `backfill-release.yml`'s build
matrix could silently drop the Windows entry, producing a backfilled release with
no Windows binary — exactly the problem WIN-TARGET fixes. `tests/ci_yml_windows_matrix.rs`
established the precedent that guards of this class are mandatory, not optional.
The parsing cost is trivial (two YAML file reads, no network, pattern already
established).

**Test file:** `tests/backfill_matrix_parity.rs` (or a new test function in an
existing CI-guard test file if that is the project's current convention).

**Required assertion:** Parse `backfill-release.yml` and assert that its
`jobs.build.strategy.matrix.include` list contains exactly the same five target
strings as `release.yml`'s `jobs.build.strategy.matrix.include`:

- `x86_64-apple-darwin`
- `aarch64-apple-darwin`
- `x86_64-unknown-linux-gnu`
- `aarch64-unknown-linux-gnu`
- `x86_64-pc-windows-msvc`

Assert set-equality (order-independent) of the `target` fields. Follow
`tests/ci_yml_windows_matrix.rs` for implementation shape.

## Summary Table

| Mechanism | Type | Status after bundle |
|-----------|------|---------------------|
| `scripts/check-signing-workflow-injection.sh` | Script (injection guard) | Must continue to pass — F5 REQUIRED |
| `tests/ci_gate_completeness.rs` | Existing Rust test | Unaffected — no new CI jobs |
| `tests/backfill_matrix_parity.rs` (new) | Required Rust test | REQUIRED Story-1 acceptance criterion |
| VP catalog (all VP-NNN) | Formal verification | UNCHANGED — no new VPs |
