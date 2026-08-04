# S-626-1 Demo Evidence

Story: Fix rust-toolchain SHA pins + MSRV false-green + comfy-table pin + CLAUDE.md gotcha (closes #626)
Branch: `ci/fix-toolchain-sha-msrv`
Head: `e49230a7`
Last full regeneration: 2026-08-04

## Full Suite

| File | Command | Result |
|------|---------|--------|
| `full-suite.txt` | `cargo test` (aggregate) | 2345 passed / 0 failed / 100 ignored |
| `full-suite.txt` | `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features --locked` | Compiling jr → Finished, exit 0 |
| `full-suite.txt` | `cargo clippy --all-targets -- -D warnings` | clean (exit 0) |
| `full-suite.txt` | `cargo fmt --all -- --check` | clean (exit 0) |
| `full-suite.txt` | Floor guard (POL-11, ci.yml :: test / "Run tests (zero-test floor, POL-11)") | Check passed: 2345 tests executed across 103 test binaries |

Baseline per story v1.3 scope note was 2341 passed / 100 ignored. This run shows 2345 (+4) because
delivery commits added four new tests: two AC-9 regression-guard tests (`test_board_view_omits_team_column_when_field_unconfigured`
and `test_issue_list_omits_team_column_when_field_unconfigured`), `test_board_view_falls_back_to_uuid_when_team_not_cached`
(BC-5.3.003 pin, commit 6d73b3ef), and `test_verify_test_job_has_zero_test_floor` (POL-11 floor guard, commit 9312f11f).
See `full-suite.txt` for full discrepancy note.

## Regeneration Log

All 11 artifacts verified at head `e49230a7` (2026-08-04). Each artifact carries its own
per-file `# Head:` stamp. Status per artifact:

| Artifact | Head | Captured | Status | Reason |
|----------|------|----------|--------|--------|
| `AC-001.txt` | e49230a7 | 2026-08-04 | re-stamped (Round 13) | Head-only; delta-analysis.md unchanged by e49230a7 (ci.yml comment-only + ci_gate_completeness.rs docstrings-only) |
| `AC-002.txt` | e49230a7 | 2026-08-04 | re-stamped (Round 13) | Head-only; e49230a7 NO line-count change in ci.yml; ci.yml line numbers confirmed unchanged (:167, :209) |
| `AC-003.txt` | e49230a7 | 2026-08-04 | re-stamped (Round 13) | Head-only; e49230a7 NO line-count change in ci.yml; sed range '156,183p' remains valid (183−156+1=28 ✓) |
| `AC-004.txt` | e49230a7 | 2026-08-04 | re-stamped (Round 13) | Head-only; e49230a7 NO line-count change in ci.yml; all grep output line numbers confirmed unchanged |
| `AC-005.txt` | e49230a7 | 2026-08-04 | re-stamped (Round 13) | Head-only; sign-and-publish.yml/backfill-release.yml/release.yml unchanged by e49230a7 |
| `AC-006.txt` | e49230a7 | 2026-08-04 | re-stamped (Round 13) | Head-only; CLAUDE.md unchanged by e49230a7 |
| `AC-007.txt` | e49230a7 | 2026-08-04 | re-stamped (Round 13) | Head-only; c93f4f9c still absent; e49230a7 changed ci.yml comment text + ci_gate_completeness.rs docstrings |
| `AC-008.txt` | e49230a7 | 2026-08-04 | re-stamped (Round 13) | Head-only; Cargo.toml/Cargo.lock unchanged by e49230a7 |
| `AC-009.txt` | e49230a7 | 2026-08-04 | re-stamped (Round 13) | Head-only; board.rs/list.rs unchanged; team_column_parity.rs unchanged |
| `full-suite.txt` | e49230a7 | 2026-08-04 | re-captured (Round 13) | cargo test re-run: 2345/0/100 (unchanged — no new test functions; only docstrings changed); clippy (0.17s)+fmt re-run; ci_gate_completeness re-run (8 tests unchanged); floor guard re-run (same output — ci.yml operative logic and line numbers unchanged) |

**Completeness: 11/11 artifacts verified and stamped. No artifact left with only the global INDEX head stamp.**

## Round-13 Re-stamp (2026-08-04): head 14416fd9 → e49230a7

Commit `e49230a7` (`docs(ci): fix stale examine_globs count and convert live ci.yml line citations to structural form`) made two changes:

1. `.github/workflows/ci.yml` — one comment line shortened: a false `17-entry` numeral removed from the examine_globs count comment in the `ci.yml :: mutants` job (actual count is 16). **One-for-one edit: NO line-count change.** All ci.yml line numbers remain identical to `14416fd9`.

2. `tests/ci_gate_completeness.rs` — four live `ci.yml:~NN` citations in docstrings/comments converted to structural form (e.g. `ci.yml:~415-426` → `ci.yml :: mutants / "Check kill rate" else branch`). **+3 lines total (docstring/comment text only; no new test functions, no assertion changes).** Test count remains 2345.

**No line-count change in ci.yml:** Verified by running `grep -n "msrv:\|name: MSRV\|dtolnay\|toolchain: \"1.85.0\"\|RUSTUP_TOOLCHAIN: \"1.85.0\""` — all six markers confirmed at :156/:157/:167/:169/:183/:209 (same as 14416fd9). AC-002, AC-003, and AC-004 content is unchanged.

**17-entry count-claim sweep:** `grep -rn "17-entry\|17 entry\|examine_globs"` across all 11 demo artifacts returned zero hits. No artifact reproduces the retracted false count.

**Re-verification performed:**
- `cargo test` aggregate re-run at e49230a7 → `2345 passed / 0 failed / 100 ignored`
- `cargo test --test ci_gate_completeness` → `running 8 tests` (unchanged — no new test functions; only docstring text changed)
- `cargo clippy --all-targets -- -D warnings` re-run at e49230a7 → exit 0 (warm cache, 0.17s)
- `cargo fmt --all -- --check` re-run at e49230a7 → exit 0 (no output)
- Floor guard positive path re-run → `Check passed: 2345 tests executed across 103 test binaries`

**Artifact disposition:**
- AC-001 through AC-009: head-stamp only. None of these artifacts' evidence sources (delta-analysis.md, six workflow files, CLAUDE.md, Cargo.toml/lock, src/cli/board.rs, team_column_parity.rs) were changed by e49230a7.
- full-suite.txt: re-captured — cargo test count confirmed 2345; clippy (0.17s)+fmt re-run; ci_gate_completeness confirmed 8 tests; floor guard command updated to `/tmp/cargo_test_out_e49230a7.txt` and re-run (same output); MSRV "NOT re-run" note extended to include e49230a7.

**Round-13 sed range re-check:**
All `sed -n 'A,Bp'` commands in the pack verified to display exactly B−A+1 lines at head e49230a7:
- AC-003: sed '156,183p' → 28 lines ✓ (183−156+1=28; unchanged from Round 12 — no ci.yml line shift)
- AC-005: sed '57,68p' → 12 lines ✓ (unchanged); sed '72,83p' → 12 lines ✓ (unchanged); sed '38,52p' → 15 lines ✓ (unchanged)
- AC-009 BEFORE: sed '228,244p' → 17 lines ✓ (unchanged); AFTER: sed '228,248p' → 21 lines ✓ (unchanged)

**All three floor-guard captures (positive + both negatives) confirmed intact:** The GATESCRIPT blocks contain only operative commands (no comments), and ci.yml's operative logic is unchanged by e49230a7's one-for-one comment edit. The negative-path GATESCRIPT blocks are verbatim matches to the gate logic.

## Round-12 Re-stamp (2026-08-04): head 7798b1bf → 14416fd9

Commit `14416fd9` (`ci: fix stale self-citation in test job wc -l comment (F-01)`) replaced one
comment line in `ci.yml :: test / "Run tests (zero-test floor, POL-11)"` with two lines:

The old comment cited `ci.yml:~415-426` as the location of the mutants job F5 fix. That citation
was a stale line-number anchor pointing at the F2 fix (jq empty/malformed-JSON guard), not the F5
fix (grep -c exits 1 on empty match). The corrected comment uses structural form per CLAUDE.md #408
convention: `ci.yml :: mutants / "Check kill rate" else branch — "grep -c '' exits 1 on empty match"`.

Files changed: `.github/workflows/ci.yml` only (+1 line; one comment line → two lines). The change
is at old ci.yml:93, which shifts everything from old line 94 onward by +1 (new line 95 onward).

**ci.yml :: msrv line number shift (+1 from 7798b1bf):**
- `msrv:` job id line: :155 → :156
- `name: MSRV (1.85.0)`: :156 → :157
- dtolnay/rust-toolchain SHA (msrv): :166 → :167
- `toolchain: "1.85.0"`: :168 → :169
- comment line 1 of wiremock-scope block: :172 → :173
- comment line 2 of wiremock-scope block: :178 → :179
- `RUSTUP_TOOLCHAIN: "1.85.0"`: :182 → :183
- dtolnay/rust-toolchain SHA (coverage): :208 → :209
(Independently verified by running `grep -n "1\.85\.0\|RUSTUP_TOOLCHAIN" ci.yml` and `grep -n fa04a145 ci.yml`.)

**Floor-guard scripts NOT re-captured:** The GATESCRIPT blocks embedded in the positive and both
negative paths contain only operative commands (set -euo pipefail, tee, set +o pipefail, total=...,
binaries=..., set -o pipefail, if/echo/exit blocks). The changed comment appears between the
`binaries=$(grep -E ...)` line and the `# Restore pipefail` comment — it is NOT part of any
GATESCRIPT block. The operative gate logic is byte-for-byte unchanged by 14416fd9.

**Re-verification performed:**
- `cargo test` aggregate re-run at 14416fd9 → `2345 passed / 0 failed / 100 ignored`
- `cargo test --test ci_gate_completeness` → `running 8 tests` (unchanged — no new test functions)
- `cargo clippy --all-targets -- -D warnings` re-run at 14416fd9 → exit 0 (warm cache, 0.20s)
- `cargo fmt --all -- --check` re-run at 14416fd9 → exit 0 (no output)
- Floor guard positive path re-run → `Check passed: 2345 tests executed across 103 test binaries`

**Artifact disposition:**
- AC-001, AC-005, AC-006, AC-007, AC-008, AC-009: head-stamp only. None of these artifacts'
  evidence sources (delta-analysis.md, three release workflow files, CLAUDE.md, Cargo.toml/lock,
  src/cli/board.rs) were changed by 14416fd9.
- AC-002, AC-003, AC-004: re-captured with correct ci.yml line numbers (+1 shift).
- full-suite.txt: re-captured — cargo test count confirmed 2345 (no new test functions);
  clippy (0.20s)+fmt re-run; ci_gate_completeness confirmed 8 tests; floor guard re-run (same output);
  negative-path GATESCRIPT blocks preserved intact (operative logic unchanged by 14416fd9).

**Round-12 sed range re-check:**
All `sed -n 'A,Bp'` commands in the pack verified to display exactly B−A+1 lines at head 14416fd9:
- AC-003: sed '156,183p' → 28 lines ✓ (updated from '155,182p'; 183−156+1=28)
- AC-005: sed '57,68p' → 12 lines ✓ (unchanged); sed '72,83p' → 12 lines ✓ (unchanged); sed '38,52p' → 15 lines ✓ (unchanged)
- AC-009 BEFORE: sed '228,244p' → 17 lines ✓ (unchanged); AFTER: sed '228,248p' → 21 lines ✓ (unchanged)

## Round-11 Re-stamp (2026-08-04): head 84ab32ac → 7798b1bf

Commit `7798b1bf` (`test(ci-gate): close false-green in POL-11 pin where comment satisfies canary assertion`)
tightened two assertions within the existing `test_verify_test_job_has_zero_test_floor` function in
`tests/ci_gate_completeness.rs`:

1. **Canary assertion tightened:** The canary check now asserts the command form `grep -q "ci_gate_completeness"` —
   previously a looser assertion that a comment containing the word could satisfy.
2. **Floor threshold tightened:** The floor check now asserts `"${binaries}" -lt 90` — previously a looser
   form that a comment could satisfy.

Files changed: `tests/ci_gate_completeness.rs` only (two assertions tightened within
`test_verify_test_job_has_zero_test_floor`; NO new test functions added). `ci.yml` was NOT changed.

**No new test functions added:** 7798b1bf tightened assertions within the existing
`test_verify_test_job_has_zero_test_floor` function only. Test count remains 2345 (confirmed by
re-run). ci_gate_completeness count remains 8 (confirmed).

**Re-verification performed:**
- `cargo test` aggregate re-run at 7798b1bf → `2345 passed / 0 failed / 100 ignored`
- `cargo test --test ci_gate_completeness` → `running 8 tests` (unchanged — no new test functions)
- `cargo clippy --all-targets -- -D warnings` re-run at 7798b1bf → exit 0 (warm cache, 0.21s)
- `cargo fmt --all -- --check` re-run at 7798b1bf → exit 0 (no output)
- Floor guard: ci.yml unchanged by 7798b1bf; output remains `Check passed: 2345 tests executed across 103 test binaries`

**Artifact disposition:**
- AC-001 through AC-009: head-stamp only. None of these artifacts' evidence sources (delta-analysis.md,
  ci.yml, CLAUDE.md, Cargo.toml/lock, src/cli/board.rs, three release workflow files) were changed
  by 7798b1bf.
- full-suite.txt: re-captured — cargo test count confirmed 2345 (no new test functions);
  ci_gate_completeness confirmed 8 tests; clippy (0.21s)+fmt re-run (tests/ci_gate_completeness.rs
  changed, so --all-targets/--all covers it); floor guard captures preserved intact (ci.yml
  unchanged by 7798b1bf).

**Floor guard captures preserved intact:** All three floor-guard captures in full-suite.txt
(positive path, negative-path 1 — binary-count floor failure, negative-path 2 — named canary
failure) are unchanged. ci.yml was not modified by 7798b1bf.

**Defects corrected this round:**
- **(a) Stale Round-9 residue at INDEX.md:~26:** The Regeneration Log intro still read "All 11 artifacts
  verified at head `a247a343` (2026-08-03)" — contradicting the INDEX head (`84ab32ac`), all 11 table
  rows, the "11/11" line, and all 11 per-file `# Head:` stamps. Fixed to `7798b1bf` (2026-08-04).
- **(b) Stale Round-9 residue at INDEX.md:~441 (Per-AC Evidence table):** AC-003's recorded command was
  `sed -n '152,179p' ci.yml` — the pre-84ab32ac range. The Round-10 correction propagated to the
  narrative (:~33, :~101) and to AC-003.txt, but not to this table. Fixed to `sed -n '155,182p' ci.yml`
  (182−155+1=28 ✓).

**Round-11 sed range re-check:**
All `sed -n 'A,Bp'` commands in the pack verified to display exactly B−A+1 lines at head 7798b1bf:
- AC-003: sed '155,182p' → 28 lines ✓ (182−155+1=28)
- AC-005: sed '57,68p' → 12 lines ✓ (unchanged); sed '72,83p' → 12 lines ✓ (unchanged); sed '38,52p' → 15 lines ✓ (unchanged)
- AC-009 BEFORE: sed '228,244p' → 17 lines ✓ (unchanged); AFTER: sed '228,248p' → 21 lines ✓ (unchanged)

## Round-10 Re-stamp (2026-08-04): head a247a343 → 84ab32ac

Commit `84ab32ac` (`ci: fix false threshold justification and close pipefail coverage gap (POL-11)`)
corrected two defects in the `ci.yml :: test / "Run tests (zero-test floor, POL-11)"` step and its
Rust regression pin:

1. **False threshold justification (comment only, ci.yml +3 lines):** The POL-11 binary-count floor
   comment at `ci.yml :: test` read `~103 binaries (1 lib + ~54 integration + ~1 doc)`, which sums
   to approximately 56 — arithmetically broken by a factor of ~2. The corrected comment reads
   `1 lib + 1 bin + ~100 integration + ~1 doc; 100 = the 104 files in tests/**/*.rs minus the 4
   tests/common/ module files that are not cargo targets`. The comment grew from 6 to 9 lines,
   shifting all subsequent ci.yml line numbers by +3.

2. **Pipefail coverage gap (tests/ci_gate_completeness.rs, two new assertions):** The docstring
   for `test_verify_test_job_has_zero_test_floor` claimed to pin "all operative parts" of the step,
   but no assertion covered the `set +o pipefail` / `set -o pipefail` bracket. Two assertions were
   added asserting the bracket exists as standalone lines in the step body.

Files changed: `.github/workflows/ci.yml` (+3 comment lines in test job, shifting subsequent job
line numbers by +3) and `tests/ci_gate_completeness.rs` (+2 assertions within
`test_verify_test_job_has_zero_test_floor`; NO new test functions added).

**No new test functions added:** 84ab32ac added only assertions within the existing
`test_verify_test_job_has_zero_test_floor` function. Test count remains 2345 (confirmed by re-run).
Binary count remains 103.

**ci.yml :: msrv line number shift (+3 from a247a343):**
All subsequent job line numbers shifted +3 from the comment growth in the test job:
- `msrv:` job id line: :152 → :155
- `name: MSRV (1.85.0)`: :153 → :156
- dtolnay/rust-toolchain SHA (msrv): :163 → :166
- `toolchain: "1.85.0"`: :165 → :168
- comment line 1 of wiremock-scope block: :169 → :172
- comment line 2 of wiremock-scope block: :175 → :178
- `RUSTUP_TOOLCHAIN: "1.85.0"`: :179 → :182
- dtolnay/rust-toolchain SHA (coverage): :205 → :208
(Independently verified by running `grep -n "1\.85\.0\|RUSTUP_TOOLCHAIN" ci.yml` and `grep -n fa04a145 ci.yml`.)

**Re-verification performed:**
- `cargo test` aggregate re-run at 84ab32ac → `2345 passed / 0 failed / 100 ignored`
- `cargo test --test ci_gate_completeness` → `running 8 tests` (unchanged — no new test functions)
- `cargo clippy --all-targets -- -D warnings` re-run at 84ab32ac → exit 0 (warm cache, 0.21s)
- `cargo fmt --all -- --check` re-run at 84ab32ac → exit 0 (no output)
- Floor guard script re-run → `Check passed: 2345 tests executed across 103 test binaries`

**Artifact disposition:**
- AC-001, AC-005, AC-006, AC-007, AC-008, AC-009: head-stamp only. None of these artifacts'
  evidence sources (delta-analysis.md, three release workflow files, CLAUDE.md, Cargo.toml/lock,
  src/cli/board.rs) were changed by 84ab32ac.
- AC-002, AC-003, AC-004: re-captured with correct ci.yml line numbers (+3 shift).
- full-suite.txt: re-captured — cargo test count confirmed 2345 (no new test functions);
  clippy timing updated (0.28s→0.21s); fmt re-run; floor guard script re-run (same output;
  script logic unchanged, only comment text corrected in ci.yml). Negative-path captures
  from Round 9 preserved intact (their logic is unchanged by 84ab32ac).

**Round-10 sed range re-check:**
All `sed -n 'A,Bp'` commands in the pack verified to display exactly B−A+1 lines at head 84ab32ac:
- AC-003: sed '155,182p' → 28 lines ✓ (updated from '152,179p'; 182−155+1=28)
- AC-005: sed '57,68p' → 12 lines ✓ (unchanged); sed '72,83p' → 12 lines ✓ (unchanged); sed '38,52p' → 15 lines ✓ (unchanged)
- AC-009 BEFORE: sed '228,244p' → 17 lines ✓ (unchanged); AFTER: sed '228,248p' → 21 lines ✓ (unchanged)

## Round-9 Addition (2026-08-04): negative-path evidence for POL-11 zero-test floor

Added two new sections to `full-suite.txt` covering the negative paths for both POL-11
instruments. No artifact was re-run or re-stamped; all 11 files remain at head `a247a343`.

**Gap closed:** The pack previously recorded only the positive path for the floor guard
(`Check passed: 2345 tests executed across 103 test binaries`). A reviewer flagged the
missing negative-path evidence as significant: the defective version of the guard (pre-a247a343)
had unreachable `FAIL (POL-11)` diagnostics, and the omission of negative-path evidence meant
that defect went unnoticed through multiple review passes.

**Approach:** The gate logic from `ci.yml :: test / "Run tests (zero-test floor, POL-11)"` was
driven against synthetic captured logs (explicitly permitted by the task, which states "drive the
guard logic against synthetic captured logs"). The cargo test line was replaced by pre-populating
the capture file; all gate logic (set -euo pipefail, set +o pipefail, wc -l pipeline, set -o
pipefail, if-blocks, echo, exit 1) is verbatim from ci.yml lines 69-151. RUNNER_TEMP substituted
with /tmp for local execution.

**Negative-path 1 — binary-count floor failure:**
- Synthetic log: 5 "test result:" lines, 220 passed each → total=1100, binaries=5
- total=1100 (> 0) proves the old "> 0" predicate would have passed this silently
- binaries=5 (< 90) fires the new floor check
- Diagnostic confirmed printed: `FAIL (POL-11): only 5 test binaries reported results (floor: 90).`
- Exit code: 1

**Negative-path 2 — named canary failure:**
- Synthetic log: 95 "test result:" lines, 22 passed each → total=2090, binaries=95, no ci_gate_completeness
- binaries=95 (>= 90) passes the floor check
- ci_gate_completeness absent → canary fires
- Diagnostic confirmed printed: `FAIL (POL-11): tests/ci_gate_completeness did not run.`
- Exit code: 1

**Reachability proof:** Both diagnostics printed before exit 1 under set -euo pipefail. This
directly demonstrates the corrected step's set +o pipefail + wc -l design: under the old
set -euo pipefail + grep -c, grep exited 1 on no-match and aborted the step before any echo
could run — the diagnostic was permanently unreachable. The corrected step is not.

**Worktree status:** `git status --short` in .worktrees/S-626-1 returns empty (no output) —
no source, test, Cargo, or workflow file was modified.

**Files changed in this round:** `full-suite.txt` only (two new sections added after the
existing positive-path floor guard section; Summary table extended with two negative-path rows).

**Round-9 sed range re-check:**
All `sed -n 'A,Bp'` commands in the pack verified to display exactly B−A+1 lines at head a247a343:
- AC-003: sed '152,179p' → 28 lines ✓ (unchanged; 179−152+1=28)
- AC-005: sed '57,68p' → 12 lines ✓ (unchanged); sed '72,83p' → 12 lines ✓ (unchanged); sed '38,52p' → 15 lines ✓ (unchanged)
- AC-009 BEFORE: sed '228,244p' → 17 lines ✓ (unchanged); AFTER: sed '228,248p' → 21 lines ✓ (unchanged)

## Round-8 Re-stamp (2026-08-03): head 9312f11f → a247a343

Commit `a247a343` (`ci: fix inert floor, unreachable diagnostic, colour fragility, under-specified pin (POL-11)`)
corrected four defects in the `ci.yml :: test / "Run tests (zero-test floor, POL-11)"` step
that commit `9312f11f` had shipped defective:

1. **Inert floor predicate (`> 0` → binary-count floor `-lt 90` + canary):** The prior `> 0`
   predicate could not detect integration-test orphaning because `cargo test --all-features`
   also runs src/ inline `#[cfg(test)]` modules (~1,100 tests), keeping total > 0 even when
   all of `tests/` is orphaned. The corrected step uses TWO instruments: a binary-count floor
   (`binaries -lt 90`) that catches mass orphaning of `tests/` files, and a named canary
   (`grep -q "ci_gate_completeness"`) that catches the self-orphaning case where the guard
   binary itself stops running.

2. **Unreachable diagnostics (`set -euo pipefail` blocking `echo` before `exit 1`):** Under
   `set -o pipefail`, `grep -c` exits 1 on no-match; that exit propagated through the pipeline
   and, combined with `set -e`, aborted the step before any `echo "FAIL..."` could print. The
   corrected step uses `set +o pipefail` scoped to the count-computation section and `wc -l`
   instead of `grep -c` (which avoids the no-match exit-1 trap). `set -o pipefail` is restored
   before the gate checks so real I/O errors are still not swallowed.

3. **Colour fragility (`CARGO_TERM_COLOR: never` override added):** The file-level
   `CARGO_TERM_COLOR: always` caused ANSI escape codes in `"test result:"` lines to silently
   zero the anchored `grep -E "^test result: "`, making the diagnostic branches unreachable
   and the step permanently mis-diagnose. The corrected step adds a step-level
   `env: CARGO_TERM_COLOR: never` override.

4. **Under-specified regression pin:** The prior pin in `test_verify_test_job_has_zero_test_floor`
   asserted only the `FAIL (POL-11)` message literal. The corrected pin also asserts the
   binary-count floor (`-lt 90`), the named canary (`ci_gate_completeness`), `exit 1`, the
   `Check passed:` positive-coverage line, and `CARGO_TERM_COLOR: never`.

Files changed: `.github/workflows/ci.yml` (+54 lines vs 9312f11f head, shifting all subsequent
job line numbers by +54) and `tests/ci_gate_completeness.rs` (docstring + 5 new assert blocks
within `test_verify_test_job_has_zero_test_floor`; NO new test functions added).

**No new test functions added:** a247a343 expanded assertions within the existing
`test_verify_test_job_has_zero_test_floor` function. Test count remains 2345 (confirmed by
re-run). Binary count remains 103.

**Prose citations migrated to anchor form:** All bare `ci.yml :NNN` references in this INDEX
and in AC-002/003/004 narrative sections have been migrated to `ci.yml :: <job-id>` form
(e.g. `ci.yml :: msrv`, `ci.yml :: coverage`, `ci.yml :: test`) to prevent future staling
from ci.yml line-number shifts. Transcripts retain real line numbers.

**Re-verification performed:**
- `cargo test` aggregate re-run at a247a343 → `2345 passed / 0 failed / 100 ignored`
- `cargo clippy --all-targets -- -D warnings` re-run at a247a343 → exit 0 (warm cache, 0.28s)
- `cargo fmt --all -- --check` re-run at a247a343 → exit 0 (no output)
- Floor guard script updated and re-run → `Check passed: 2345 tests executed across 103 test binaries`
- `cargo test --test team_column_parity` → still `running 10 tests`, all ok (unchanged)
- Filtered team_column_parity → still `running 2 tests`, 8 filtered out (unchanged)
- False-green reproduction → still `running 0 tests`, 10 filtered out (unchanged)

**Artifact disposition:**
- AC-001, AC-005, AC-006, AC-007, AC-008, AC-009: head-stamp only. None of these artifacts'
  evidence sources (delta-analysis.md, three release workflow files, CLAUDE.md, Cargo.toml/lock,
  src/cli/board.rs) were changed by a247a343.
- AC-002, AC-003, AC-004: re-captured with correct ci.yml line numbers; prose citations
  migrated to anchor form in assertions sections.
- full-suite.txt: re-captured — floor guard script updated to match new ci.yml :: test step
  (CARGO_TERM_COLOR: never, wc -l, -lt 90 binary floor, ci_gate_completeness canary);
  clippy timing updated (0.15s→0.28s); cargo test count confirmed 2345 (no new test functions).

**Round-8 sed range re-check:**
All `sed -n 'A,Bp'` commands in the pack verified to display exactly B−A+1 lines at head a247a343:
- AC-003: sed '152,179p' → 28 lines ✓ (updated from '98,125p'; 179−152+1=28)
- AC-005: sed '57,68p' → 12 lines ✓ (unchanged); sed '72,83p' → 12 lines ✓ (unchanged); sed '38,52p' → 15 lines ✓ (unchanged)
- AC-009 BEFORE: sed '228,244p' → 17 lines ✓ (unchanged); AFTER: sed '228,248p' → 21 lines ✓ (unchanged)

## Round-7 Re-stamp (2026-08-03): head 6d73b3ef → 9312f11f

Commit `9312f11f` (`ci: add zero-test floor + positive-coverage assertion to test job (POL-11)`)
replaced the bare `- run: cargo test --all-features` in the ci.yml `test` job with a multi-line
named step ("Run tests (zero-test floor, POL-11)") that computes the total tests executed at
runtime and fails if zero. It also added `test_verify_test_job_has_zero_test_floor` to
`tests/ci_gate_completeness.rs` to pin that the guard is present.

Files changed: `.github/workflows/ci.yml` (+39 lines in the test job block, shifting all
subsequent job line numbers by +39) and `tests/ci_gate_completeness.rs` (+1 test function).

**Defects corrected this round:**

**F-05 (HIGH) — false "no src/ changes" justification for skipping clippy/fmt:**
Prior artifact header and INDEX Regeneration Log stated "MSRV/clippy/fmt not re-run — delta
was test-only, no src/ changes". This is incorrect: `--all-targets` (clippy) and `--all`
(fmt) both cover `tests/` files, not just `src/`. Since 9312f11f changed
`tests/ci_gate_completeness.rs`, both needed re-running. Both were re-run; warm cache results
(no Compiling line) confirm all targets are clean. The false justification has been deleted.
Corrected reasoning: MSRV (`cargo check --all-features`) is NOT re-run because it omits
`--all-targets` — test-file changes are genuinely outside its scope.

**AC-002/003/004 (MEDIUM) — stale ci.yml line numbers (+39 shift):**
The `test` job grew by 39 lines, shifting the start of the `msrv:` job from :59→:98 and all
subsequent line references. All three artifacts re-captured with correct line numbers.
- AC-002: ci.yml dtolnay pins updated (:70→:109, :112→:151)
- AC-003: sed range updated (sed -n '59,86p' → sed -n '98,125p'); B-A+1=28 preserved
- AC-004: grep output line numbers updated (60→99, 70→109, 72→111, 76→115, 82→121, 86→125)

**DEFECT 3 — count update:**
Full suite grew from 2344 → 2345 (+1 test: `test_verify_test_job_has_zero_test_floor`).
Baseline attribution (2341 from story v1.3 scope note) unchanged.

**DEFECT 4 — floor guard positive-path evidence:**
Floor guard positive path captured: `Check passed: 2345 tests executed across 103 test binaries`.
Script replicated locally from ci.yml `:58-96` test job step.

**Re-verification performed:**
- `cargo test` aggregate re-run at 9312f11f → `2345 passed / 0 failed / 100 ignored`
- `cargo clippy --all-targets -- -D warnings` re-run at 9312f11f → exit 0 (warm cache, 0.15s)
- `cargo fmt --all -- --check` re-run at 9312f11f → exit 0 (no output)
- Floor guard script re-run → `Check passed: 2345 tests executed across 103 test binaries`
- `cargo test --test team_column_parity` → still `running 10 tests`, all ok (unchanged)
- Filtered team_column_parity → still `running 2 tests`, 8 filtered out (unchanged)
- False-green reproduction → still `running 0 tests`, 10 filtered out (unchanged)

**Artifact disposition:**
- AC-001, AC-005, AC-006, AC-007, AC-008, AC-009: head-stamp only. None of these artifacts'
  evidence sources (delta-analysis.md, three release workflow files, CLAUDE.md, Cargo.toml/lock,
  src/cli/board.rs) were changed by 9312f11f.
- AC-002, AC-003, AC-004: re-captured with correct ci.yml line numbers.
- full-suite.txt: re-captured — cargo test count updated (2344→2345), clippy+fmt re-run
  and false justification corrected, floor guard evidence added.

**Round-7 sed range re-check:**
All `sed -n 'A,Bp'` commands in the pack verified to display exactly B−A+1 lines at head 9312f11f:
- AC-003: sed '98,125p' → 28 lines ✓ (updated from '59,86p'; 125−98+1=28)
- AC-005: sed '57,68p' → 12 lines ✓ (unchanged); sed '72,83p' → 12 lines ✓ (unchanged); sed '38,52p' → 15 lines ✓ (unchanged)
- AC-009 BEFORE: sed '228,244p' → 17 lines ✓ (unchanged); AFTER: sed '228,248p' → 21 lines ✓ (unchanged)

## Round-6 Re-stamp (2026-08-03): head c88374b4 → 6d73b3ef

Commit `6d73b3ef` (`test: pin board-view UUID fallback render site (BC-5.3.003)`) added one new
test to `tests/team_column_parity.rs`:
- `test_board_view_falls_back_to_uuid_when_team_not_cached` — exercises the board-view cache-miss
  path and asserts positive anchors (Team column, raw UUID) then `.stdout(predicate::str::contains("name not cached").not())`.
  Also rewrote a comment that had overclaimed which render sites the earlier assertions covered.

No `src/` file changed. Delta: test file only. The suite grew from 9 to 10 tests in `team_column_parity.rs`;
full suite grew from 2343 to 2344.

**Re-verification performed:**
- `cargo test` aggregate re-run at 6d73b3ef → `2344 passed / 0 failed / 100 ignored`
- `cargo test --test team_column_parity` → `running 10 tests`, all ok
- `cargo test --test team_column_parity -- test_board_view_omits_team_column_when_field_unconfigured test_issue_list_omits_team_column_when_field_unconfigured` → `running 2 tests`, **8 filtered out** (was 7 — suite grew 9→10)
- False-green reproduction (wrong filter substrings) → `running 0 tests`, **10 filtered out** (was 9 — suite grew 9→10)

**Artifact disposition:**
- AC-001 through AC-008: head-stamp-only re-stamp. None of these artifacts' evidence sources (delta-analysis.md, .github/workflows/, ci.yml, CLAUDE.md, Cargo.toml/lock, src/cli/board.rs) were touched by 6d73b3ef.
- AC-009: head-stamp + both filtered-out figures updated (false-green: 9→10; correct filter: 7→8). Running-2-tests result unchanged. BEFORE/AFTER board.rs transcripts unchanged.
- full-suite.txt: head-stamp + aggregate count updated (2343→2344) + narrative updated to describe three new tests (2341→2344 via the two AC-9 guards plus the new BC-5.3.003 pin).

**Round-5 fidelity fixes confirmed intact:**
All `sed -n 'A,Bp'` commands in the pack verified to display exactly B−A+1 lines:
- AC-003: sed '59,86p' → 28 lines ✓
- AC-005: sed '57,68p' → 12 lines ✓; sed '72,83p' → 12 lines ✓; sed '38,52p' → 15 lines ✓
- AC-009 BEFORE: sed '228,244p' → 17 lines ✓; AFTER: sed '228,248p' → 21 lines ✓

## Round-5 Re-stamp (2026-08-03): head 64e2a4bc → c88374b4

Commit `c88374b4` (`test: pin BC-5.3.003 no-suffix postcondition on bare-UUID fallback`) added
`.stdout(predicate::str::contains("name not cached").not())` assertions to two existing tests:
- `tests/team_column_parity.rs::sprint_current_falls_back_to_uuid_when_team_not_cached`
- `tests/cli_handler.rs::test_list_team_column_falls_back_to_uuid_when_cache_missing`

No new test functions were added. No `src/` file changed. Delta: +12/−2, test files only.

**Re-verification performed:**
- `cargo test` aggregate re-run at c88374b4 → `2343 passed / 0 failed / 100 ignored` (unchanged)
- `cargo test --test team_column_parity -- test_board_view_omits_team_column_when_field_unconfigured test_issue_list_omits_team_column_when_field_unconfigured` re-run → `running 2 tests`, both ok (unchanged)

**Artifact disposition:**
- AC-001 through AC-008: head-stamp-only re-stamp. None of these artifacts' evidence sources (delta-analysis.md, .github/workflows/, ci.yml, CLAUDE.md, Cargo.toml/lock, src/cli/board.rs) were touched by c88374b4.
- AC-009: head-stamp + filtered test transcript re-captured (timing changed from 14.92s cold to 0.12s warm cache; running 2 tests result unchanged).
- full-suite.txt: head-stamp + cargo test section note updated; MSRV/clippy/fmt sections not re-run (test-only delta, no src/ changes; outputs remain valid from 64e2a4bc run).

**Round-4 fidelity fixes confirmed intact:**
All `sed -n 'A,Bp'` commands in the pack verified to display exactly B−A+1 lines:
- AC-003: sed '59,86p' → 28 lines ✓
- AC-005: sed '57,68p' → 12 lines ✓; sed '72,83p' → 12 lines ✓; sed '38,52p' → 15 lines ✓
- AC-009 BEFORE: sed '228,244p' → 17 lines ✓; AFTER: sed '228,248p' → 21 lines ✓

## Defects Corrected (Cumulative — All Rounds)

**Round 1 (Jul-30 → Jul-31) — F-03 and F-04:**

**F-03 (HIGH) — AC-009.txt false-green test filter (Round 1):**
The Jul-30 artifact recorded filter substrings `board_view_kanban_omits_team_col_when_field_unconfigured`
and `issue_list_omits_team_col_when_field_unconfigured`, neither of which is a substring of any
real test name. Re-running the recorded command produced `running 0 tests; test result: ok` —
exit 0 with zero tests exercised. The correct names (with `test_` prefix) are
`test_board_view_omits_team_column_when_field_unconfigured` and
`test_issue_list_omits_team_column_when_field_unconfigured`. The corrected artifact shows
`running 2 tests` with both passing.

**F-04 (MEDIUM) — AC-003.txt MSRV capture indistinguishable from warm-cache no-op (Round 1):**
The Jul-30 artifact captured only `Finished 'dev' profile … in 0.19s` — no toolchain identity,
no `Checking` line. The corrected artifact adds `rustc --version` output (`rustc 1.85.0
(4d91de4e4 2025-02-17)`), `rustup show active-toolchain` output (`1.85.0-aarch64-apple-darwin
(overridden by environment variable RUSTUP_TOOLCHAIN)`), and a cold `Compiling jr …` line.

**Additional Round-1 staleness corrected:**
- `Head:` updated from `b51fc26a` to `64e2a4bc` (three docs commits landed after Jul-30)
- AC-003: `--locked` added to command; ci.yml comment scope updated (:74-83, 10 lines); env
  line reference updated (:85-86)
- AC-002: second dtolnay use in ci.yml corrected from line :106 to line :112 (coverage job)
- full-suite.txt: test name references corrected; MSRV command updated with `--locked` and
  toolchain identity

**Round 2 (Jul-31 → Aug-03) — Five artifacts corrected:**

**AC-004 (HIGH) — Stale comment text and line numbers:**
Prior captured `77: # the 1.85.0 MSRV toolchain. --all-features is intentional.` — this
comment was rewritten to the 10-line wiremock-scope block in a docs commit. RUSTUP_TOOLCHAIN
was recorded at :80; actual is :86. Regenerated with 6-line grep output matching head.

**AC-006 (HIGH) — Factually wrong gotcha title and precedence claim:**
Prior captured stale title claiming `rust-toolchain.toml` overrides `rustup override` and the
`dtolnay/rust-toolchain` action's `toolchain` input. The delivered CLAUDE.md documents a
corrected, narrower claim: toml outranks `rustup default` only. Prior also claimed
`RUSTUP_TOOLCHAIN` is "the highest-precedence override" — incorrect; `+toolchain` ranks above
it. Line number shifted from 218 to 219. Regenerated with actual delivered text.

**AC-008 (HIGH) — Inverted acceptance criterion (internal path CONFIRMED as present):**
Prior recorded `Cargo.toml:23` as `# Ref: .factory/research/msrv-let-chains-comfy-table-2026-07-30.md`
and stamped CONFIRMED. AC-8 requires that path NOT appear (ruling ADV-P1-LOW-001 — internal
paths must not appear in a manifest published to crates.io). The delivered file correctly uses
`# See: issue #626.` at the end of a 5-line comment block. Prior also omitted `--locked` and
captured a warm 0.19s no-op without toolchain identity. Regenerated with correct content,
`--locked`, real Compiling line, and toolchain identity.

**AC-009 (MEDIUM) — False coverage claim about outer Table gate:**
Prior claimed "A regression that removed the outer OutputFormat::Table check would produce a
non-empty team_displays Vec even without a field_id." This is false: both tests use
write_config_without_team_field (team_field_id = None), so removing the outer Table check
leaves the inner else { Vec::new() } firing — team_displays stays empty regardless.
The tests pin the INNER if let Some(field_id) guard only. Corrected with detailed
before/after analysis of the actual control-flow structure.

**AC-003 (LOW) — Transcript fidelity: sed range vs. displayed output:**
Prior used `sed -n '58,87p'` but displayed 28 lines corresponding to lines 59-86. Line 58
is a blank separator and line 87 is a blank separator; both were omitted. Command corrected
to `sed -n '59,86p'` so command and transcript agree exactly.

**Round 4 (Aug-03) — Mechanical fidelity sweep: five defects corrected across four artifacts:**

**AC-005 (MEDIUM) — sed '57,68p' and '72,83p' both omitted blank separator lines:**
`sign-and-publish.yml:57` and `backfill-release.yml:72` are blank separator lines. Both sed commands
produce 12 lines (range size = B−A+1), but the round-3 artifact showed 11 lines for each — the
initial blank was silently dropped in transcription. Blank lines restored as line 1 of each output.

**AC-005 (HIGH) — release.yml third rustup target add site missing; INDEX.md said "both files":**
AC-5 (`S-626-1.md:~308-316`) mandates three sites: `sign-and-publish.yml`, `backfill-release.yml`,
and `release.yml`. The prior artifact covered only the first two and declared P71-003 satisfied.
`release.yml` at :43/:46 has a bare `rustup target add` step with no E0463 comment (as documented
in the story's AC-5 table). Evidence added: `grep -n` output + `sed -n '38,52p'` transcript.
`INDEX.md` command column corrected from "both files" to "all three files".

**AC-008 (MEDIUM) — Unicode ≥ (U+2265) transcribed as ASCII >= in Cargo.toml transcript:**
`Cargo.toml:19` contains `requires Rust ≥1.88` (U+2265). The round-3 transcript recorded `>=`
(two ASCII characters). `AC-003.txt:25` correctly preserves `≥` from `ci.yml:77` in the same
pack — confirming this is an intra-pack transcription inconsistency. Character restored.

**AC-009 (HIGH) — BEFORE sed '228,244p' (17 lines) showed only 10; AFTER sed '228,248p' (21 lines) showed 22:**
BEFORE: `git show origin/develop:src/cli/board.rs | sed -n '228,244p'` produces 17 lines.
Artifact showed only 10, stopping at `.collect();` — lines 238-244 (the `if uuids.iter().any` block
through `.unwrap_or_default();`) were absent. Seven lines restored.
AFTER: `sed -n '228,248p' src/cli/board.rs` produces 21 lines. Artifact showed 22, ending at
`None => "-".to_string(),` (board.rs:249, outside the 228-248 range). Extra line removed.

**full-suite.txt (LOW) — "Task 7d states the baseline as 2341" was false after Task 7d was updated to 2343:**
Round 3 updated Task 7d to 2343. `full-suite.txt:13` still said "The story spec Task 7d states the
baseline as 2341 passed" — now false. `INDEX.md:17` correctly attributes 2341 to the v1.3 scope note.
`full-suite.txt` corrected to match: "The story v1.3 scope note (commit cc7f6da5) states the baseline as 2341".

## Per-AC Evidence

This story has no user-visible behaviour change by design — it is regression evidence proving
nothing broke. AC-9 (the in-tree let-chain rewrites) is the highest-risk element because it
touched output-formatting code paths (`board.rs` and `list.rs`). The AC-9 evidence is the
sharpest proof: tests mount issues carrying team UUIDs, then confirm the rewritten branch
correctly suppresses the Team column when the field is unconfigured.

| AC | What Changed | Demo File | Command / Check | Result |
|----|-------------|-----------|----------------|--------|
| AC-001 | SHA verification (blocking gate) | `AC-001.txt` | Read delta-analysis.md §5e | PASS |
| AC-002 | 7 new-SHA occurrences across 6 files | `AC-002.txt` | `grep -n fa04a145` across 6 files | PASS |
| AC-003 | msrv job: toolchain input + RUSTUP_TOOLCHAIN env | `AC-003.txt` | `sed -n '156,183p' ci.yml` + MSRV check with toolchain identity proof | PASS |
| AC-004 | msrv comment accuracy: # 1.85.0 | `AC-004.txt` | `grep -n 1.85.0 ci.yml` | PASS |
| AC-005 | rustup target add steps preserved | `AC-005.txt` | `grep E0463`/`rustup target add` all three files | PASS |
| AC-006 | CLAUDE.md gotcha added | `AC-006.txt` | `grep -n rust-toolchain.toml.*outranks CLAUDE.md` | PASS |
| AC-007 | Old SHA c93f4f9c absent | `AC-007.txt` | `grep -rc c93f4f9c .github/workflows/` → all 0 | PASS |
| AC-008 | comfy-table pinned to 7.2.1 | `AC-008.txt` | `grep comfy-table Cargo.toml/lock` + MSRV check with Compiling line | PASS |
| AC-009 | 3 in-tree let-chains rewritten + 2 new tests | `AC-009.txt` | before/after diff + `cargo test --test team_column_parity` (running 2 tests) | PASS |

**Total: 9/9 ACs covered. All checks green.**

## Key Implementation Notes

- The story has no user-visible behaviour change by design. All evidence is regression proof.
- AC-3 and AC-8 share the same acceptance check (`RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features --locked`).
  Both are jointly load-bearing: the comfy-table pin ensures the dep tree compiles at 1.85.0;
  the in-tree let-chain rewrites (AC-9) ensure jr's own source also compiles at 1.85.0.
- The 7 SHA occurrences across 6 files reflect ci.yml having two dtolnay/rust-toolchain uses:
  `ci.yml :: msrv` (toolchain "1.85.0") and `ci.yml :: coverage` (toolchain "stable").
  `ci.yml :: test` uses NO dtolnay/rust-toolchain action.
- AC-9 test non-vacuousness: `running 2 tests` with correct function names
  `test_board_view_omits_team_column_when_field_unconfigured` and
  `test_issue_list_omits_team_column_when_field_unconfigured`. Each test mounts issues with
  team UUID data present so the rewritten `else { Vec::new() }` branch must actively suppress
  the column — passing on data, not on an empty response. Positive anchors on Assignee/Summary
  confirm the table rendered.
- AC-9 test coverage scope: the two tests pin the INNER `if let Some(field_id) = team_field_id`
  guard (the new else { Vec::new() } branch). They do NOT independently pin the outer
  `matches!(output_format, OutputFormat::Table)` gate — because with team_field_id = None,
  removing the outer Table check has no effect on the test result. See AC-009.txt corrected
  coverage claim section for full analysis.
- The `--all-targets` flag in clippy is intentional and matches project CLAUDE.md convention.
  Note: `cargo check --all-features --locked` in the MSRV check deliberately omits `--all-targets`
  because wiremock (a dev-dependency) requires Rust >=1.88.0; that is documented in the CI
  comment block at `ci.yml :: msrv` and is correct, not an oversight.
- rustup toolchain list confirms 1.85.0 available: `1.85.0-aarch64-apple-darwin` listed.
  All MSRV captures show `RUSTUP_TOOLCHAIN=1.85.0 rustup show active-toolchain` →
  `1.85.0-aarch64-apple-darwin (overridden by environment variable RUSTUP_TOOLCHAIN)`.
