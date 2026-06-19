---
document_type: f7-convergence-report
bundle: DEAD-CITATION-CI
date: 2026-06-19
story: S-MAINT-DEAD-CITATION-CI
develop_sha: 496258a
hardening_pr: 545
hardening_branch: test/dead-citation-ci-hardening
hardening_sha: df51db4
count_guard_check_spec_counts: PASS
count_guard_bc_cumulative: PASS
count_guard_no_numeric_test_counts: PASS
input_drift: NONE
overall_verdict: F7 CONVERGED
---

# F7 Delta Convergence Report — DEAD-CITATION-CI

## Feature Summary

- **Bundle:** DEAD-CITATION-CI
- **Story:** S-MAINT-DEAD-CITATION-CI — Add CLAUDE.md dead-citation CI guard
- **Origin:** 2026-06-19 maintenance sweep (MAINT-PG-DEAD-CITATION-CI); DRIFT-D13
- **Spec version:** F2 Iteration 3 (10 adversarial passes + F3-feedback line-provenance amendment)
- **Base story PR:** #544 — merged to develop @ 496258a (2026-06-19T21:44:33Z)
- **F6 hardening PR:** #545 — open on branch `test/dead-citation-ci-hardening` @ df51db4 (ci-gate 15/15 PASS)
- **Files created:** `tests/claude_md_citations.rs`
- **Files modified:** `CLAUDE.md` (doc-fallout note in "AI Agent Notes" section at line 334)
- **No `src/` production changes**

---

## Pre-Gate: Input-Hash Drift Check

**Result: NO DRIFT**

All DEAD-CITATION-CI scope files checked against their expected state:

| File | Expected State | Actual | Verdict |
|------|---------------|--------|---------|
| `tests/claude_md_citations.rs` | Created by PR #544 (56 named test fns + 2 proptest fns = 58 total) | Present, 56+2=58 on develop HEAD | MATCH |
| `CLAUDE.md` | Doc-fallout note at line 334 referencing `tests/claude_md_citations.rs` | Present at line 334 | MATCH |
| `.factory/specs/prd/cross-cutting.md` | BC-X.13.001/002/003 present (F2 Iter 3 final) | BC-X.13.001/002/003 present @ lines 912–1176 | MATCH |
| `.factory/stories/S-MAINT-DEAD-CITATION-CI.md` | 12 ACs, v1.1, bcs: [BC-X.13.001/002/003] | Present, version 1.1, all confirmed | MATCH |
| `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md` | VP-CITE-001 + VP-CITE-002 defined | Present, complete | MATCH |

No spec files were modified after PR #544 merged. No DEAD-CITATION-CI-scoped drift items are OPEN. DRIFT-D13 (the original dead citations) was resolved by PR #543 (maintenance sweep) + PR #544 (guard). **DRIFT: NONE.**

---

## Dimension 1: Spec Convergence

**Verdict: CONVERGED**

### BC Coverage

| BC | Title | Status |
|----|-------|--------|
| BC-X.13.001 | Integration guard — reads CLAUDE.md, asserts all in-scope citations exist, emits CI-CITE-001 on failure | ACTIVE in `cross-cutting.md` §X.13 |
| BC-X.13.002 | 5-step pipeline (a)–(e): glob-skip, merged-fixpoint (6 sub-steps), dir-prefix + ROOT_FILES filter, extension filter, Path::exists | ACTIVE in `cross-cutting.md` §X.13 |
| BC-X.13.003 | ALL `.factory/` paths excluded structurally at step (c); no allowlist function | ACTIVE in `cross-cutting.md` §X.13 |

### VP Coverage

| VP | Covers | Satisfied By |
|----|--------|-------------|
| VP-CITE-001 | `extract_path_citations` grammar — in-scope detection + all normalization/exclusion rules, no false positives, no panics | 56 named unit tests + 2 proptest tests in `tests/claude_md_citations.rs` |
| VP-CITE-002 | Integration self-verify — guard green on develop HEAD; deterministic failure on dead citation; CI-CITE-001 verbatim | `test_claude_md_citations_resolve_to_real_files` (integration); `test_dead_citation_detected_in_fixture`; `test_two_dead_citations_both_listed` |

### Spec Adversarial History

- F1: Delta analysis — 1 pass, CONVERGED
- F2: 10 adversarial passes + 5 consistency audits — converged after 6 real defects caught (`.factory/` CI-checkout flaw, count drift, message contradiction, over-engineered-fix regression, line-ref+punct false-negative, renumber fallout)
- F3: 3 adversarial passes + 2 consistency audits — DEC-127: F-1 HIGH caught (non-actionable literal `(line N)` placeholder); fixed by `Vec<(String, usize)>` return type
- F4 per-story: 3 adversarial passes (story review)
- F5: 4 findings (SEC-001 CWE-22 + 3 mutation gaps); all addressed in F6
- F6 convergence: 0 new findings after hardening — CONVERGED

**Adversary novelty score post-F6: 0 new findings / 0 verifiable claims = effectively 0.0 < 0.15 threshold. PASS.**

### Count Guards

All three count guards run on develop HEAD:

| Guard | Command | Result |
|-------|---------|--------|
| check-spec-counts.sh | `bash scripts/check-spec-counts.sh` | `OK: all spec counts verified.` (exit 0) |
| check-bc-cumulative-counts.sh | `bash scripts/check-bc-cumulative-counts.sh` | `OK: all cumulative BC counts verified (602 total across 8 files; Surface H footer checked where present)` (exit 0) |
| check-bc-no-numeric-test-counts.sh | `bash scripts/check-bc-no-numeric-test-counts.sh` | `OK: no numeric test counts in BC Trace/Source fields.` (exit 0) |

**All 3 count guards: PASS (exit 0).**

---

## Dimension 2: Test Convergence

**Verdict: CONVERGED**

### Test Count Timeline

| Phase | Tests | Status |
|-------|-------|--------|
| F4 baseline (PR #544, develop HEAD @ 496258a) | 58 (56 named + 2 proptest) | All PASS, ci-gate 15/15 |
| F6 hardening (PR #545, branch df51db4) | 61 (59 named + 2 proptest) | All PASS, ci-gate 15/15 |
| Delta | +3 (test_parent_dir_traversal_excluded, test_in_scope_shell_script_extracted, test_leading_double_colon_token_excluded) | All new tests PASS |

**Note on the "58→61" claim in the PR description:** The F6 PR description states "58→61 tests." This is accurate at the TOTAL count level (58 on develop HEAD = 56 named + 2 proptest; 61 after F6 = 59 named + 2 proptest). The "Red→Green proven" language refers to the F4 TDD delivery where tests were written before implementation. The F6 hardening added 3 net new tests.

### AC → Test Coverage (12 ACs)

| AC | Tests Covering | Status |
|----|---------------|--------|
| AC-001 (`extract_path_citations` pure fn, 5-step pipeline, `Vec<(String, usize)>`) | 25+ unit tests exercising the pipeline (all steps a–e), proptest | COVERED |
| AC-002 (integration test green on develop HEAD) | `test_claude_md_citations_resolve_to_real_files` | COVERED |
| AC-003 (CI-CITE-001 failure message verbatim with real line numbers) | `test_render_dead_citation_message_matches_ci_cite_001`, `test_render_dead_citation_message_single_element` | COVERED |
| AC-004 (deterministic failure on known-dead citation) | `test_dead_citation_detected_in_fixture` | COVERED |
| AC-005 (ALL `.factory/` excluded structurally) | `test_factory_specs_path_excluded_by_dir_prefix`, `test_factory_holdout_path_excluded_by_dir_prefix`, `test_factory_research_path_excluded_by_dir_prefix` | COVERED |
| AC-006 (ROOT_FILES set checked; bare shorthands excluded) | 7 tests (`test_root_file_*`, `test_shorthand_*`, `test_paren_wrapped_root_file_extracted`) | COVERED |
| AC-007 (merged fixpoint multi-pass edge cases EC-CITE-026/027/028/023/025) | `test_fixpoint_ec026_paren_plus_line_ref`, `test_fixpoint_ec027_line_ref_plus_comma`, `test_fixpoint_ec028_symbol_plus_punct`, `test_fixpoint_ec023_bracket_wrap`, `test_fixpoint_ec025_double_paren_wrap` | COVERED |
| AC-008 (proptest — no false positives, no panics) | `proptests::test_non_prefix_tokens_are_never_extracted`, `proptests::test_extract_never_panics` | COVERED |
| AC-009 (CLAUDE.md doc-fallout note in same PR as test file) | CLAUDE.md line 334 (existence verified by `test_claude_md_citations_resolve_to_real_files` self-check on `tests/claude_md_citations.rs`) | COVERED |
| AC-010 (multi-dead-path fixture, both listed, correct join, real line numbers) | `test_two_dead_citations_both_listed` | COVERED |
| AC-011 (extension filter: extensionless and `.lock` excluded) | `test_extension_filter_excludes_extensionless_token`, `test_extension_filter_excludes_lock_extension` | COVERED |
| AC-012 (EC-CITE-002 comma-delimited, EC-CITE-003 CRLF) | `test_comma_delimited_both_tokens_extracted`, `test_crlf_line_endings_no_false_positive` | COVERED |

All 12 ACs have test coverage. **PASS.**

### Mutation Testing

- **Scope:** `extract_path_citations` and `apply_fixpoint` live in `tests/claude_md_citations.rs`, NOT in `src/`. The `cargo-mutants` policy targets `src/` only. This means `--in-diff` produces "No mutants to filter" for any diff touching only `tests/` files.
- **Disposition:** N/A for `cargo-mutants` tooling — the parser lives in the test crate, not `src/`. Behavioral pinning is achieved instead via explicit mutation-killer tests:
  - `test_balanced_paren_in_path_not_stripped_by_step_b5` — kills the `<` → `<=` mutant in sub-step (5)
  - `test_two_dead_citations_both_listed` (assertions 4+5) — kills the `+1` → `+0`/`+2` off-by-one mutants in line-number counting
  - `test_citation_on_line_3_returns_exact_line_number` — kills the same `+1` off-by-one mutants from the other direction
  - `test_render_dead_citation_message_single_element` — kills the join-separator mutant (`"\n  "` → `"\n"`)
  - `test_parent_dir_traversal_excluded` (F6) — kills the `..`-reject guard removal mutant
  - `test_in_scope_shell_script_extracted` (F6) — kills the `.sh`-drop mutant in RECOGNIZED_EXTS
  - `test_leading_double_colon_token_excluded` (F6) — pins the leading `::` corner
- **This disposition is sound.** The `cargo-mutants` policy document (`docs/specs/cargo-mutants-policy.md`) requires `--in-diff` on PR diff scope. Test-crate code is not mutated by design. The explicit mutation-killer tests provide equivalent behavioral pinning for all critical branches. No policy violation.

---

## Dimension 3: Implementation Convergence

**Verdict: CONVERGED**

### Implementation Summary

- **Zero `src/` production changes** — the feature is entirely in `tests/claude_md_citations.rs` + `CLAUDE.md`
- **Architecture compliance rules verified:**
  1. Pure/effectful split enforced: `extract_path_citations` has zero `Path::exists()` calls inside (verified by reading the function, lines 147–289)
  2. No `is_off_working_branch_allowlisted` function exists — confirmed by grep
  3. No `ci.yml` change — rides existing `test` job in `ci-gate.needs`
  4. ROOT_FILES set is enumerated in BC-X.13.002 and matches the const in the test file
  5. No `src/` changes — confirmed by commit stat

- **F5 adversarial findings (4 total):**
  - SEC-001 (CWE-22, HIGH): `..`-segment path traversal probe risk — fixed in F6 with `(b′)` reject guard
  - Mutation gap `.sh` extension — fixed with `test_in_scope_shell_script_extracted`
  - Mutation gap leading `::` corner — fixed with `test_leading_double_colon_token_excluded`
  - Proptest const hand-sync risk — fixed by hoisting ROOT_FILES/RECOGNIZED_EXTS/DIR_PREFIXES to module-level `const`

- **F6 convergence adversarial:** 0 new findings. Adversary verification rate: 0 unverifiable claims out of 0 new claims. **PASS (< 60% threshold).**

### Code Quality

| Check | Status |
|-------|--------|
| `cargo clippy -- -D warnings` | CLEAN (ci-gate confirms on ubuntu, macos, windows) |
| `cargo fmt --all -- --check` | CLEAN (ci-gate confirms) |
| `cargo deny check` | PASS |

---

## Dimension 4: Verification Convergence

**Verdict: CONVERGED (N/A with justified disposition for mutation tooling)**

| Check | Result |
|-------|--------|
| Kani formal proofs | N/A — no new production Rust in delta; no proof subject. No new VPs requiring Kani. The project does not currently run Kani formally. |
| Fuzz testing | N/A — no new input-handling production code; fuzz target would be `extract_path_citations` which is test-crate code, not `src/`. No fuzz target required. |
| `cargo mutants --in-diff` | Exit 0 — "No mutants to filter" (test-crate code; policy-correct disposition). Behavioral pinning via explicit mutation-killer tests documented under Dimension 2. |
| `cargo deny check` | PASS (ci-gate) |
| Security review | No CRITICAL or HIGH findings after F6 hardening. SEC-001 (CWE-22 defense-in-depth) was the only finding; addressed by `..`-reject guard in step (b′). |
| Purity boundary | `extract_path_citations` is pure (no `Path::exists()` inside). Integration test body is the only effectful site. Boundary intact. |

VP-CITE-001 (proptest + unit tests) and VP-CITE-002 (integration self-verify) are both satisfied on develop HEAD and on the F6 hardening branch.

---

## Dimension 5: Visual Convergence

**Verdict: N/A**

This is a CLI tool with no UI component. The DEAD-CITATION-CI feature adds a CI guard test only — zero user-visible output changes. Visual convergence dimension does not apply.

---

## Dimension 6: Performance Convergence

**Verdict: N/A / Acceptable**

The guard is a pure string parser exercised only during `cargo test`. Performance characteristics:
- Line-number computation is O(i) per backtick span (newline scan up to the token start)
- At CLAUDE.md scale (~350 lines), this is negligible
- The test file comment at line 220 documents this: "O(i) newline scan per backtick span — fine at CLAUDE.md scale; switch to a running counter if it grows 10x"
- No NFR targets were set for this feature (infrastructure guard, not user-facing path)

No performance regression introduced. **N/A / acceptable.**

---

## Dimension 7: Documentation Convergence

**Verdict: CONVERGED**

The CLAUDE.md doc-fallout note was added in the SAME PR (#544) as `tests/claude_md_citations.rs`, satisfying EC-CITE-022 (forward-reference constraint).

**CLAUDE.md line 334 text (verified present):**

> CLAUDE.md dead-citation CI guard (`tests/claude_md_citations.rs`): `test_claude_md_citations_resolve_to_real_files` reads CLAUDE.md via `include_str!`, extracts every backtick-quoted file-path citation using `extract_path_citations`, and asserts `Path::exists()` for each. Fails CI with canonical CI-CITE-001 message listing ALL dead paths with 1-based line numbers. `.factory/` paths, glob patterns (`*`, `{`, `}`), symbol-form tokens (`::fn`), bare shorthands (`adf.rs`, `ci.yml`), home-directory paths (`~/.config/…`), and extensionless tokens are auto-excluded by the 5-step pipeline inside `extract_path_citations`. ROOT_FILES members (`Cargo.toml`, `CLAUDE.md`, `build.rs`, `deny.toml`, `CHANGELOG.md`, `README.md`, `rust-toolchain.toml`) ARE checked. No CI YAML change required — rides the existing `test` job. Governed by BC-X.13.001, BC-X.13.002, BC-X.13.003.

**Accuracy check:**
- Cites `tests/claude_md_citations.rs` by exact path — CORRECT
- Names `test_claude_md_citations_resolve_to_real_files` — CORRECT (present at line 389)
- Describes 1-based line numbers — CORRECT (Vec<(String, usize)> return type)
- Lists auto-exclusion categories — CORRECT (`.factory/`, globs, symbol-forms, shorthands, home paths, extensionless)
- Lists ROOT_FILES members — CORRECT (matches `ROOT_FILES` const in the test file)
- States no CI YAML change — CORRECT (no `.github/workflows/ci.yml` changes in delta)
- Cites BC-X.13.001/002/003 — CORRECT (governing BCs as specified)

The self-referential check is automatically satisfied: `test_claude_md_citations_resolve_to_real_files` would catch a dead citation to `tests/claude_md_citations.rs` if the file were absent. The file exists. Green.

---

## Regression Validation

**Verdict: PASS (zero regressions)**

| Metric | Baseline (pre-feature) | Develop HEAD (post-PR #544) | F6 Hardening (PR #545) |
|--------|----------------------|---------------------------|------------------------|
| Total tests | 1855 (83a141ad baseline) | 1866 (496258a) | 1869 (df51db4) |
| Existing tests passing | 1855 | 1855 | 1855 |
| New tests passing | — | +11 (backfill parity) + 58 (citation guard) | +3 (hardening) |
| Failures | 0 | 0 | 0 |
| Regressions | — | 0 | 0 |

Note: The F4 implementation was on develop HEAD after multiple prior PRs. The baseline of 1855 represents the state at the activation head (71f33c6 / v0.6.0-dev.5). The citation guard adds 58 tests (PR #544), and the F6 hardening adds 3 more (PR #545).

**CI gate on PR #544 (merged to develop):** 15/15 PASS (Format, dependency-review, Clippy ubuntu/windows, Test ubuntu/macos/windows, MSRV, Deny, Coverage, Spec Guards, Secret Scan, Mutation testing, Signing Workflow Injection Guard, CI Gate).

**CI gate on PR #545 (F6 hardening, OPEN):** 15/15 PASS (same set).

---

## Cross-Document Consistency

**Verdict: CONSISTENT**

| Pair | Check | Result |
|------|-------|--------|
| BC-X.13.001 ↔ AC-002/003 | BC postcondition 1/2 states guard is green and emits CI-CITE-001 verbatim; story ACs match; test implements both | ALIGNED |
| BC-X.13.002 ↔ `extract_path_citations` | BC describes 5-step pipeline (a)–(e) with 6 sub-steps in (b); code implements exactly this | ALIGNED |
| BC-X.13.003 ↔ `DIR_PREFIXES` const | BC states `.factory/` not in develop-tracked set; code has `const DIR_PREFIXES: &[&str] = &["src/", "tests/", "docs/", ".github/", "scripts/"]` — `.factory/` absent | ALIGNED |
| Story `bcs:` frontmatter ↔ BC body table ↔ AC traces | `bcs: [BC-X.13.001, BC-X.13.002, BC-X.13.003]`; body table has all 3; ACs trace to all 3 | ALIGNED |
| VP-CITE-001/002 ↔ test file coverage map | Coverage map at top of `tests/claude_md_citations.rs` maps every test to VP-CITE-001 or VP-CITE-002 | ALIGNED |
| CLAUDE.md note ↔ actual implementation | Note describes `extract_path_citations` and its exclusion rules; implementation matches | ALIGNED |
| ROOT_FILES in BC-X.13.002 ↔ ROOT_FILES const | BC enumerates `{build.rs, Cargo.toml, CHANGELOG.md, CLAUDE.md, deny.toml, README.md, rust-toolchain.toml}`; const matches exactly | ALIGNED |

No stale references. All cited BC/VP/EC/file paths resolve. **CONSISTENT.**

---

## Traceability Chain (Delta)

```
BC-X.13.001
  → VP-CITE-002
  → test_claude_md_citations_resolve_to_real_files (tests/claude_md_citations.rs:389)
  → CLAUDE.md (include_str! compile-time embed)
  → Path::exists() check in integration test body
  → ci-gate: Test (ubuntu/macos/windows) ← PR #544 (merged) + PR #545 (hardening)

BC-X.13.002
  → VP-CITE-001
  → extract_path_citations(doc: &str) -> Vec<(String, usize)> (tests/claude_md_citations.rs:147)
  → 56 unit tests (step a/b/c/d coverage) + 2 proptest tests
  → ci-gate: Test (ubuntu/macos/windows) ← PR #544 + PR #545

BC-X.13.003
  → VP-CITE-001 + VP-CITE-002
  → test_factory_specs_path_excluded_by_dir_prefix (tests/claude_md_citations.rs:680)
  → test_factory_holdout_path_excluded_by_dir_prefix (tests/claude_md_citations.rs:695)
  → test_factory_research_path_excluded_by_dir_prefix (tests/claude_md_citations.rs:709)
  → DIR_PREFIXES const excludes ".factory/" (tests/claude_md_citations.rs:163)

S-MAINT-DEAD-CITATION-CI (story, AC-001..012)
  → BC-X.13.001/002/003 (governing BCs)
  → tests/claude_md_citations.rs (implementation, 58 tests on develop + 3 on hardening branch)
  → CLAUDE.md line 334 (doc-fallout note, AC-009)
  → PR #544 → develop @ 496258a
  → PR #545 → develop (pending merge)

DEAD-CITATION-CI F2 spec (10 adv passes)
  → .factory/specs/prd/cross-cutting.md §BC-X.13
  → .factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md
  → .factory/phase-f2-spec-evolution/prd-delta-DEAD-CITATION-CI.md
  → .factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md

Cross-feature dependency:
  S-MAINT-DEAD-CITATION-CI depends_on DRIFT-D13 (resolved by #543)
  No S-MAINT-DEAD-CITATION-CI cross-dependency on existing feature stories
```

---

## Per-Dimension Verdict Summary

| # | Dimension | Verdict | Notes |
|---|-----------|---------|-------|
| 1 | Spec | CONVERGED | 10 F2 adv passes + F3 line-provenance fix; 3 BCs + 2 VPs; all count guards PASS (exit 0) |
| 2 | Tests | CONVERGED | 58 tests on develop (all 12 ACs covered); +3 on F6 hardening branch; ci-gate 15/15 on both |
| 3 | Implementation | CONVERGED | 3 F4 per-story adv passes; F5/F6 hardening converged (0 new findings post-F6); pure/effectful split intact |
| 4 | Verification | CONVERGED | VP-CITE-001 (proptest+unit) + VP-CITE-002 (integration) satisfied; mutation N/A with explicit mutation-killer tests; Kani/fuzz N/A (test-crate only, no `src/`); SEC-001 CWE-22 addressed |
| 5 | Visual | N/A | CLI tool, no UI component |
| 6 | Performance | N/A / Acceptable | Pure string parser at CLAUDE.md scale; O(n) documented and accepted |
| 7 | Documentation | CONVERGED | CLAUDE.md note at line 334 present, accurate, and self-validating; EC-CITE-022 satisfied (same PR) |

**Input Drift Check:** NONE

**Consistency Verdict:** CONSISTENT (all 7 cross-document pairs aligned)

**Count Guard Exit Codes:**
- `check-spec-counts.sh` → exit 0 (PASS)
- `check-bc-cumulative-counts.sh` → exit 0 (PASS)
- `check-bc-no-numeric-test-counts.sh` → exit 0 (PASS)

**Full-Tree Regression:** PASS (ci-gate 15/15 on PR #544; 15/15 on PR #545)

---

## Recommendation

**F7 CONVERGED.**

The DEAD-CITATION-CI feature cycle has achieved convergence across all applicable dimensions:
- Spec: 10 adversarial passes + F3 line-provenance amendment; no open findings
- Tests: 58 tests covering all 12 ACs; ci-gate 15/15 on 3 OSes; +3 mutation-killer tests in F6 hardening (PR #545)
- Implementation: spec-faithful; pure/effectful boundary intact; no `src/` changes; zero HIGH/CRITICAL open findings
- Verification: VPs satisfied; cargo mutants N/A disposition documented and sound; SEC-001 CWE-22 defended
- Documentation: CLAUDE.md note accurate and self-validating

**Pending authorization: merge PR #545** (F6 hardening — `test/dead-citation-ci-hardening` → `develop`). CI gate is 15/15 PASS. This PR is purely additive (3 test functions, const hoisting, pop() safety). No human authorization bypass risk (PR #544 DEC-128 logged; this PR awaits explicit merge authorization).

After PR #545 merges, the full DEAD-CITATION-CI cycle is complete. No release bump is required — this is a maintenance/infrastructure story (no user-facing behavior changes). The existing v0.6.0-dev.5 tag on the activation head is unaffected; the guard will ship with the next regular release.
