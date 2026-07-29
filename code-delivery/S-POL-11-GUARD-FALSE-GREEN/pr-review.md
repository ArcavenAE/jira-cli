# PR Review — #661

**PR:** fix(guard): close false-green gaps in check-spec-counts and claude_md_citations (POL-11)
**Branch:** `fix/guard-false-green` → `develop`
**Verdict:** APPROVE — no blocking findings
**Reviewed:** 2026-07-28
**Scope:** 2 files, +34/-1. Both changed files reviewed in full.

---

## Summary

The core fix is correct. I verified the zero-files guard empirically by running the
PR-branch script against seven constructed trees rather than relying on the PR body's
claims:

| Scenario | Result |
|---|---|
| `.factory/specs/prd` exists but empty | exit **2**, correct ERROR |
| `.factory/specs/prd` absent entirely | exit **2** |
| `bc-fake.md` is a *directory* (glob matches, `[ -f ]` skips) | exit **2** |
| Valid bc file, nfr + holdout absent | `Check passed: 1 bc files validated`, exit 0 |
| nfr count mismatch | `FAIL: 1 spec count mismatch(es)`, exit 1 (unchanged) |
| Real tree | `Check passed: 7 bc files validated`, exit 0 |
| **Pre-change** script, empty dir | `OK: all spec counts verified.`, exit 0 — RED reproduced exactly as claimed |

`CITATION_FLOOR = 74` is arithmetically correct: floor(0.75 × 99) = 74.
`cargo test --test claude_md_citations` → 61 passed, 0 failed, matching the PR body.
Only one test uses `include_str!("../CLAUDE.md")`, so the floor covers the sole
vacuous-pass site. The counter increment is `set -e`-safe (`x=$((x+1))` is an
assignment with exit status 0, not `((x++))`). Nothing in code, CI, docs, or tests
greps the retired `OK: all spec counts verified.` literal, so the message change
breaks no consumer.

---

## Findings

### 1. suggestion / coverage — residual false-green on the optional-file branches

**File:** `scripts/check-spec-counts.sh` (~44-66)

Verified: one valid bc file with both `nfr-catalog.md` and `holdout-scenarios.md`
absent → two WARNINGs and `Check passed: 1 bc files validated`, exit 0.

Both files exist in the canonical `factory-artifacts` tree (29 KB / 219 KB), and
`CLAUDE.md:367-369` documents this script as validating them — so the PR body's
"those files may not always exist" rationale does not hold for the CI path. Renaming
or relocating either file reproduces precisely the POL-11 defect this PR closes for
bc files.

**Suggestion:** fail closed (exit 2) when either file is missing, or gate the skip
behind an explicit opt-in flag so the CI path is always strict.

### 2. suggestion / test-coverage — the new exit-2 guard has no automated regression test

**File:** `scripts/check-spec-counts.sh` (~33-40)

Correctness rests solely on manual RED/GREEN evidence in the PR body. Deleting the
`BC_FILES_PROCESSED=$((BC_FILES_PROCESSED+1))` line, or flipping `-eq 0`, would go
undetected by CI.

The repo has three precedents for self-testing guards:
`check-bc-citation-symbols.sh --self-test`,
`check-cargo-mutants-policy-citations.sh --self-test`, and
`tests/spec-count-fixtures/run-tests.sh` (CI-wired, but scoped only to
`check-bc-cumulative-counts.sh`).

A guard against false-greens that is itself unguarded is the same meta-gap POL-11
targets.

**Suggestion:** add a `--self-test` mode, or extend `tests/spec-count-fixtures/`
to cover this script.

### 3. suggestion / correctness — silent exit 1 defeats the new positive-coverage message

**File:** `scripts/check-spec-counts.sh` (~25)

```sh
declared=$(grep '^definitional_count:' "$f" | awk '{print $2}')
```

Under `set -euo pipefail`, grep exits 1 on no match, pipefail propagates it, and
`set -e` aborts the assignment. Verified: a bc file lacking `definitional_count:`
→ **exit 1 with zero output**.

Directly relevant to this PR: the loop aborts mid-iteration, remaining bc files are
never validated, and the new `Check passed: N bc files validated` line never prints —
so the count cannot be relied on as the coverage signal it is meant to be. Not a
false-green (nonzero exit), but the same defect family, and pre-existing.

**Suggestion:** append `|| true` and emit an explicit
`ERROR: $f: missing definitional_count frontmatter` so the failure is diagnosable
and the loop completes.

### 4. suggestion / coverage — the 25-citation tolerance band exceeds whole extractor arms

**File:** `tests/claude_md_citations.rs:414`

Measured CLAUDE.md citation distribution: `src/` ~44, `tests/` ~27, `docs/` ~24,
root-files ~10, `scripts/` ~5, `.cargo/` ~4, `.github/` ~1.

With N=99 and floor 74, a regression that killed the entire `docs/` arm (~24), or all
four small arms at once (~20), would still clear 74 and pass the floor.

**Mitigating context:** `test_in_scope_{src,tests,docs,scripts,github_workflow}_path_extracted`
and `test_root_file_*` already pin each arm with fixtures, so the global floor is a
*backstop*, not the sole defense.

**Suggestion:** add a one-line comment noting the per-arm fixture tests are the primary
defense, or add per-prefix minima, so a future maintainer does not over-trust the single
number.

### 5. suggestion / description — CLAUDE.md and script-header doc-fallout not in the same commit

`CLAUDE.md:367-369` states the contract as "Exits 0 … Exits 1 with specific mismatch
details"; the script's own `# Exit codes:` block (~10-12) likewise lists only 0 and 1.
Exit 2 is now a third outcome documented nowhere.

The repo has a codified same-commit doc-fallout convention (CLAUDE.md: "When adding a
new `JR_*` test-seam env var … add a parallel line in the SAME commit"). Note the
CLAUDE.md dead-citation guard will not catch this — the path still resolves, only the
prose is stale.

### 6. nit / coherence — missing directory and empty directory emit the identical diagnostic

An unmounted worktree (`.factory/specs/prd` absent) and renamed files (present but
empty) both produce `ERROR: no bc-*.md files found in …`. The mirrored sibling
distinguishes them: `check-bc-no-numeric-test-counts.sh:17` has
`ERROR: BC directory not found: $BC_DIR`, separate from the glob check at line 25.
Adding the `[ ! -d ]` arm would complete the mirror the new comment claims.

### 7. nit / coherence — stream and prefix inconsistency

The new ERROR goes to stderr (`>&2`) while every pre-existing `ERROR:`/`FAIL:`/`WARNING:`
in the same script goes to stdout, and the header comment still reads "details printed
to stdout". Separately, `Check passed:` introduces a fourth prefix style alongside the
retired `OK:`.

### 8. nit / coherence — pluralization

`Check passed: 1 bc files validated` on a single-file tree (verified output).

### 9. nit / description — `N=99` is unpinned

The constant's comment is the only record of the calibration; if the measurement were
wrong, nothing would surface it. Same property as the sibling `FLOOR=231`, so this is
consistency-preserving rather than a regression — but having the assertion message echo
the calibration basis would help the next recalibrator.

---

## Explicitly checked, not findings

- **Commit subject length (88 chars)** — consistent with repo practice; recent merges to
  develop run 101 and 182 chars. Not a violation here.
- **Demo evidence** — `docs/demo-evidence/` holds per-story dirs (`S-576-*`); this is a
  CI-guard change with no user-visible behavior and no story ID. N/A, consistent with
  #652 / #654.
- **CHANGELOG** — `[Unreleased]` is empty and guard-only changes have no entry precedent.
- **Diff coherence** — both changes serve POL-11; no unrelated changes, no production
  code touched.
- **Diff size** — 34 additions, 1 deletion, well under the 500-line threshold.
- **Dependency status** — branch is 0 commits behind `develop`; no upstream PR dependency.
- **CI** — green across Clippy, Format, MSRV, Coverage, Deny, Mutation, Secret Scan,
  Spec Guards, and Test on macOS/Ubuntu. Test (windows-latest) was pending at review
  time — merge should wait for it.
- **Description accuracy** — verified the CI-mounting claim against
  `.github/workflows/ci.yml:121-126`, the RED/GREEN evidence, and the 61-test count.
  All accurate. PR body and commit message are unusually thorough: root cause, fix,
  evidence, and an explicit out-of-delta scope note relative to SOH-DX-1.

## Verdict

**APPROVE.** No blocking findings. The two guards do what they claim, verified by direct
execution rather than by trusting the PR body. The nine findings above are all
improvements to a change that is already a net reduction in false-green surface — the
highest-value follow-ups are #1 (same defect class still live on the optional-file
branches) and #2 (the guard is itself unguarded).
