---
bundle: CITATION-GUARDS
date: 2026-07-02
intent: feature
feature_type: infrastructure
scope: standard
quick_dev_eligible: false
stories_recommended: 2
wave_order: guards-2-3-first
analyst: vsdd-factory:architect
origin: >
  Recurring Seam-extraction citation-drift class (DEC-147/148/149);
  DEC-150 process-gap dispositions; open gaps #492-PG-TRACE-TESTS,
  CITATION-FORM-DISCIPLINE
---

# F1 Delta Analysis — CITATION-GUARDS Feature Bundle

**Bundle:** CITATION-GUARDS (three related CI guards)
**Date:** 2026-07-02
**Feature type:** `infrastructure` (CI quality gates, no product behavior change)
**Intent:** `feature` (new guards that do not currently exist)

---

## 1. Classification

**Intent:** `feature`
**Feature type:** `infrastructure`
**Quick-dev eligible:** No — see §7 for full assessment.
**Scope:** Standard for Guard 1 (BC-CITATION-CI-GUARD); Guards 2+3 are simpler but combined still touch multiple files.

---

## 2. Background and Motivation

Three related CI gaps were identified as process-gap dispositions in DEC-150 and as
open drift items from the ADR-0012 Seam A/B extraction cycles (DEC-147/148/149):

### Guard 1 — BC-CITATION-CI-GUARD

Root cause: BC bodies in `.factory/specs/prd/*.md` contain `Trace:` and `Source:`
fields that cite `src/` product files and symbols (e.g.,
`src/cli/issue/edit.rs::handle_edit`). When a Seam extraction moves a symbol to a
different file, the BC citations silently become stale. DEC-147/148/149 spent ~30
adversarial passes hand-fixing this drift after ADR-0012 Seam A/B; the citation-debt
cycle (2026-06-30) identified 14 relocation-stale citations in bc-2 and bc-3 alone.
No CI guard existed. This guard closes the gap.

Related open gaps: `#492-PG-TRACE-TESTS` (BC-cited test symbols don't resolve),
`CITATION-FORM-DISCIPLINE` (mix of `:~NN`, `::symbol`, and bare-line forms).

### Guard 2 — MUTANTS-POLICY-CITATION-GUARD

Root cause: `docs/specs/cargo-mutants-policy.md` §Scope has a function-location table
that claims which functions live in which files. After ADR-0012 Seam B, the table
cited `handle_edit_bulk_labels`, `handle_edit_bulk_fields`, `handle_jsm_create` as
living in `create.rs` when they had moved to `edit.rs`/`jsm_create.rs`. This was a
false coverage claim in the governance document (discovered and fixed in DEC-149 /
`mutants-examine-globs-2026-07-02-delta.md`). No CI guard existed to catch it.

### Guard 3 — MUTANTS-GLOB-EXISTENCE-GUARD

Root cause: `.cargo/mutants.toml` `examine_globs` entries are exact file paths. If a
refactor moves or renames a file that is listed in `examine_globs`, the entry silently
produces zero mutants on any PR. The 0-mutant legitimate path (`--in-diff` produces
nothing) means the guard exits green even though coverage has silently dropped. No CI
guard existed to catch dead globs.

---

## 3. CI Checkout Topology Verification (F1-CI-TOPOLOGY-CHECK)

This is the most important architectural question for Guard 1. The following analysis
supersedes any topology assumption — it is verified against the live CI workflow.

### Current spec-guard CI job structure (`.github/workflows/ci.yml`, lines 110–132)

```yaml
spec-guard:
  name: Spec Guards (BC counts + no numeric test counts)
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@...         # Checks out DEVELOP (triggering branch)
    - name: Fetch factory-artifacts branch (.factory/specs/prd/)
      run: |
        git fetch origin factory-artifacts
        git worktree add .factory origin/factory-artifacts
    - name: check-spec-counts (DRIFT-001)
      run: bash scripts/check-spec-counts.sh
    - name: check-bc-no-numeric-test-counts (PG-365-1)
      run: bash scripts/check-bc-no-numeric-test-counts.sh
    - name: check-bc-cumulative-counts self-test (fixture suite)
      run: bash tests/spec-count-fixtures/run-tests.sh
    - name: check-bc-cumulative-counts (DRIFT-002)
      run: bash scripts/check-bc-cumulative-counts.sh
```

After the worktree step, the CI runner's filesystem layout is:

```
<checkout-root>/           ← DEVELOP contents (src/, tests/, docs/, scripts/, .cargo/, .github/)
  .factory/                ← FACTORY-ARTIFACTS content (specs/prd/bc-*.md, etc.)
    specs/
      prd/
        bc-3-issue-write.md  ← BC files containing Trace:/Source: citations
        ...
  src/
    cli/
      issue/
        edit.rs              ← The files being CITED in those BC Trace:/Source: fields
        ...
```

**CONCLUSION:** The cross-branch problem for Guard 1 is ALREADY SOLVED by the
existing `spec-guard` job design. The job simultaneously has develop's `src/` tree
(for checking cited file existence) and factory-artifacts' BC files (containing the
citations to check). Guard 1 MUST be a bash script added as a new step in the
`spec-guard` job — immediately after the `git worktree add` step.

**The DEAD-CITATION-CI precedent (DEC-129):** That cycle's F2 caught that a Rust
test running in the `test` job would NOT have factory-artifacts access. The spec-guard
job was already designed to mount both branches. Guard 1 must follow this pattern —
a shell script, not a Rust integration test.

### Guard 2 and Guard 3 topology

Guards 2 and 3 operate entirely within develop's checkout:
- Guard 2: `docs/specs/cargo-mutants-policy.md` lives on develop; cited `src/` files
  live on develop. No factory-artifacts access needed.
- Guard 3: `.cargo/mutants.toml` lives on develop; `src/` files it cites live on
  develop. No factory-artifacts access needed.

Guards 2 and 3 can live in either the `spec-guard` job (shell scripts) or the `test`
job (Rust integration tests). Given that Guard 3 is a simple file-existence check
that follows the exact pattern of `tests/claude_md_citations.rs`, a Rust integration
test is viable. Guard 2 is better as a shell script (it parses a structured markdown
table — bash `awk`/`grep` is simpler than writing a TOML+markdown parser in Rust).

### Reverse-direction question

The task also asks about the reverse direction: a guard on factory-artifacts validating
citations AGAINST develop's src/. This direction is IDENTICAL to what Guard 1 already
does — the spec-guard job runs on develop CI, mounts factory-artifacts as a worktree,
and validates BC citations against develop's src/. There is no separate
factory-artifacts CI that needs its own guard. The spec-guard job handles both
directions by construction.

---

## 4. Impact Boundary

### Guard 1: BC-CITATION-CI-GUARD

**Files NEW:**
| File | Type | Notes |
|------|------|-------|
| `scripts/check-bc-citation-symbols.sh` | NEW | Bash extractor for Trace:/Source: lines in BC bodies |

**Files MODIFIED:**
| File | Change | Notes |
|------|--------|-------|
| `.github/workflows/ci.yml` | MODIFIED | Add 1 step to `spec-guard` job (after worktree mount) |
| `CLAUDE.md` | MODIFIED | Doc-fallout note in "AI Agent Notes" section |

**Files NOT CHANGED (regression baseline):**
All `src/` files, all other `tests/*.rs` files, all other `scripts/*.sh` files,
`.cargo/mutants.toml`, `docs/specs/cargo-mutants-policy.md`.

**New BCs expected in F2:** ~3 BCs in `cross-cutting.md` (extending the BC-X.13
citation-guard subsystem established by DEAD-CITATION-CI). Provisional IDs:
BC-X.13.004/005/006. Will trigger `check-bc-cumulative-counts.sh` update.

### Guard 2: MUTANTS-POLICY-CITATION-GUARD

**Files NEW:**
| File | Type | Notes |
|------|------|-------|
| `scripts/check-cargo-mutants-policy-citations.sh` | NEW | Grep-based function-location check |

**Files MODIFIED:**
| File | Change | Notes |
|------|--------|-------|
| `.github/workflows/ci.yml` | MODIFIED | Add 1 step to `spec-guard` job |
| `CLAUDE.md` | MODIFIED | Doc-fallout note |

**Files NOT CHANGED:** All `src/` files, `.cargo/mutants.toml`,
`docs/specs/cargo-mutants-policy.md` (the checked-but-not-changed artifact).

**New BCs expected in F2:** 0 — governance stays in `docs/specs/cargo-mutants-policy.md`
as the sole anchor, per the existing "policy-doc-only" decision from the MUTATION-CI-TIMEOUT
cycle (F1 §8, Q3 resolution). No BC, same as the mutation gate itself.

### Guard 3: MUTANTS-GLOB-EXISTENCE-GUARD

**Files NEW:**
| File | Type | Notes |
|------|------|-------|
| `tests/mutants_glob_existence.rs` | NEW | Rust integration test (rides `test` job) |

**Files MODIFIED:**
| File | Change | Notes |
|------|--------|-------|
| `CLAUDE.md` | MODIFIED | Doc-fallout note (CLAUDE.md AI Agent Notes) |

**Why a Rust integration test for Guard 3:** `.cargo/mutants.toml` and `src/`
both live on develop. A Rust test reading `include_str!("../.cargo/mutants.toml")`
and asserting `Path::exists()` for each `examine_globs` entry is a direct parallel
to `tests/claude_md_citations.rs`'s `Path::new(root).join(p).exists()` check.
It rides the `test` job (already in `ci-gate.needs`), requires no `.github/workflows/ci.yml`
change, and uses no shell-parsing complexity.

**No `.github/workflows/ci.yml` edit required for Guard 3** — the test job already
runs all `tests/*.rs` files under `cargo test --all-features`.

**New BCs expected in F2:** 0 — policy-doc-only governance (same as Guard 2).

---

## 5. Perimeter Scan (F1-SWEEP-INCLUDES-CI-YML-COMMENTS + PERIMETER-SCAN-MUST-INCLUDE-INDEX-AND-TRACEABILITY)

### `.github/workflows/ci.yml` scope-summary comments

The `spec-guard` job's `name:` field currently reads:
`"Spec Guards (BC counts + no numeric test counts)"`

Adding Guards 1 and 2 (two new steps) requires updating this name to reflect the
expanded mandate. Proposed: `"Spec Guards (BC counts, citation checks, mutants scope)"`.

The `ci-gate.needs` line (line 428) currently reads:
```yaml
needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]
```

Guards 1 and 2 (added as steps to `spec-guard`) require NO change to `ci-gate.needs` —
`spec-guard` is already in the list. Guard 3 (Rust test added to `tests/`) requires
NO change — the `test` job is already in `ci-gate.needs`. **Per DEC-096/097: all three
guards ride existing required jobs without any branch-protection modifications.**

### BC-INDEX.md and CANONICAL-COUNTS.md

Guard 1 will add ~3 new BCs to `cross-cutting.md`. This will require updates to:
- `.factory/specs/prd/cross-cutting.md` frontmatter (`total_bcs:`)
- `.factory/specs/prd/BC-INDEX.md` frontmatter and section headers
- `.factory/specs/prd/CANONICAL-COUNTS.md` per-file table and grand total

These updates are part of F2 (spec evolution), not F1. The existing scripts
`check-bc-cumulative-counts.sh` and `check-spec-counts.sh` will catch any drift
once F2 completes. The `check-bc-no-numeric-test-counts.sh` must also run after
any new BCs are added to verify no numeric test counts in new Trace:/Source: fields.

Guards 2 and 3 produce no new BCs → no BC-INDEX or CANONICAL-COUNTS changes.

### Traceability tables that reference Guard 1's artifacts

`cross-cutting.md` currently houses BC-X.13.001/002/003 (DEAD-CITATION-CI guard).
Guard 1's new BCs (BC-X.13.004+) extend the same subsystem. The CLAUDE.md line
that documents `tests/claude_md_citations.rs` (AI Agent Notes, line ~334) is the
prior art doc-fallout pattern; Guard 1's script will add a parallel line.

### Existing related artifacts (prior art inventory)

| Artifact | Relationship | Notes |
|----------|-------------|-------|
| `tests/claude_md_citations.rs` | Prior art: same pattern as Guard 3; different from Guard 1 (CLAUDE.md citations vs. BC citations) | 60 tests, pure `extract_path_citations` function |
| `scripts/check-bc-no-numeric-test-counts.sh` | Prior art for Guard 1: already parses `**Trace**:` / `**Source**:` lines via `grep -nE '^\*\*(Trace\|Source)\*\*:'` | Direct reuse candidate |
| `scripts/check-spec-counts.sh` | Prior art for Guard 1: bash script operating on `.factory/specs/prd/bc-*.md` glob | Same file-set pattern |
| `scripts/check-bc-cumulative-counts.sh` | Prior art: spec-guard step structure | Same job context |
| `.cargo/mutants.toml` | Guard 3 input: `examine_globs` list | 11 entries, all exact file paths |
| `docs/specs/cargo-mutants-policy.md §Scope` | Guard 2 input: function-location table | 10 scoped files with named functions |
| `.factory/phase-f1-delta-analysis/DEAD-CITATION-CI-delta-analysis.md` | Precedent: full F1-F7 for CLAUDE.md citation guard | Topology analysis in §4-6 is canonical |
| `.factory/phase-f7-convergence/DEAD-CITATION-CI-session-review.md` | Topology lesson: DEC-129, CI-checkout flaw as a class defect | "Class" conclusion: guard accessing .factory/ must be in spec-guard job |
| `.factory/phase-f1-delta-analysis/citation-debt-filewide-2026-06-30-delta.md` | Motivation: 14 relocation-stale citations in bc-2/bc-3 after ADR-0012 | Establishes the drift class Guard 1 would prevent |

---

## 6. Symbol-Resolution Feasibility for Guard 1

BC bodies follow the #408 citation convention. The citation forms that appear in
`Trace:` and `Source:` lines in the BC files are:

| Form | Example | Guard 1 check |
|------|---------|--------------|
| `file::symbol` | `src/cli/issue/edit.rs::handle_edit` | Strip `::symbol` → check `src/cli/issue/edit.rs` exists; OPTIONALLY grep for `handle_edit` in file |
| `file § "comment"` | `src/cli/issue/jsm_create.rs § "map_err auth-rewrite"` | Strip ` §...` → check file exists (no section check) |
| `file:~NN` | `src/cache.rs:~120` | Strip `:~NN` → check file exists (no line check) |
| `file:NN-MM` | `tests/issue_commands.rs:1646-1703` | Strip `:NN-MM` → check file exists (NOTE: tests/ line refs drift but files don't die) |
| `file` (bare) | `src/cli/issue/edit.rs` | Check file exists directly |

**Honest scope for Guard 1 v1 (recommended):**

Check **file existence only** for `src/` citations in `Trace:` and `Source:` lines.
This catches the exact drift class from DEC-147/148/149: after Seam A/B, `handle_jsm_create`
moved to `jsm_create.rs` — a guard would have caught the STALE CITATION TO `create.rs`
at file-existence level (the function was no longer in `create.rs`, but the FILE still
exists, so a file-existence check would NOT catch this specific case).

**Correction to the above — re-analysis:** File-existence checking alone does NOT
catch the "function moved to a different file" drift class. The SPECIFIC class from
DEC-147/148/149 is:
- Old citation: `src/cli/issue/create.rs::handle_jsm_create`
- `create.rs` still exists → file-existence check PASSES
- But `handle_jsm_create` is no longer in `create.rs` → SYMBOL check would FAIL

This means:

**Guard 1 v1 MUST check symbol existence, not just file existence**, to catch the
target drift class. File-existence checking would be too weak to justify the feature.

**Symbol-existence check via grep:**
```bash
# For a citation src/cli/issue/create.rs::handle_jsm_create:
file="src/cli/issue/create.rs"
symbol="handle_jsm_create"
[ -f "$file" ] || { echo "DEAD FILE: $file"; continue; }
grep -q "fn $symbol\b" "$file" || { echo "DEAD SYMBOL: $symbol not in $file"; continue; }
```

**What grep CAN check:**
- File existence: `[ -f "$file" ]` — binary, exact
- Symbol string appears in file: `grep -q "fn ${symbol}"` or `grep -q "${symbol}"` — catches function definitions and declarations; may produce false positives on comments

**What grep CANNOT check:**
- Whether the cited function actually implements the described BC behavior
- Whether an approximate line ref (`:~NN`) points to the right area
- Whether a `§ "comment"` section accurately describes what follows
- Whether a non-function symbol (e.g., a constant `CROSS_HIERARCHY_HINT`) is at the right logical location

**Scope limitation — `:~NN` approximate cites and `§ "..."` section cites:**
These forms carry only the file path information, not a verifiable symbol. Guard 1
should check FILE existence for these forms and skip the symbol check — consistent
with the `apply_fixpoint` normalization in `tests/claude_md_citations.rs` (step b1:
strip `::symbol` suffix before existence check). A `§` cite or `:~NN` cite that
has a dead file will still be caught; a live file with wrong section/line is NOT caught
(accepted limitation — these forms are intentionally approximate per the #408 convention).

**Scope limitation — `tests/` citations:**
`tests/` line-ref citations in Trace:/Source: fields (`tests/issue_commands.rs:1646-1703`)
are bare line refs that drift as tests are added but the FILE never dies. Including these
in file-existence check adds noise without value. Recommend scoping Guard 1 to
`src/` citations only for the initial pass. `tests/` citation hygiene is the separate
gap `#492-PG-TRACE-TESTS`.

**False-positive risk assessment (parallel to DEAD-CITATION-CI §6):**

| Risk | Level | Mitigation |
|------|-------|-----------|
| Symbol renamed but file kept (e.g., function rename) | MEDIUM — would false-FAIL | Symbol check via `grep -q "fn ${symbol}"` is load-bearing; a rename produces a true positive (citation IS stale) |
| Symbol is a constant/type, not a function | LOW — `grep -q "${symbol}"` catches any definition | Search for raw symbol string without `fn` prefix; constants and types will appear |
| Symbol appears only in tests or imports, not in the cited file | LOW | Only a false positive if the symbol is in another file; typically citations point to definitions |
| `§ "..."` section text has no matching grep string | N/A | Guard 1 skips symbol check for `§` form; file-existence-only for those |
| Glob patterns or multi-token backtick spans | LOW | Same `*` exclusion as `extract_path_citations` |
| `.factory/` paths in BC frontmatter (semport source lines) | LOW — not in Trace:/Source: body | BC frontmatter `source broad:` fields cite `.factory/semport/` — Guard 1 operates on body Trace:/Source: lines only, not frontmatter |

**Overall false-positive risk with mitigations applied: LOW** — same confidence level
as the DEAD-CITATION-CI guard achieved at the end of its F2 pass.

---

## 7. Scope, Regression Risk, and Story Shaping

### Quick-dev eligibility assessment

Guard 1 (BC-CITATION-CI-GUARD): NOT quick-dev eligible.
- Requires a parser/extractor for Trace:/Source: lines (bash string manipulation)
- Must handle symbol-form vs. section-ref vs. line-ref citation forms differently
- False-positive surface warrants BCs (same reasoning as DEAD-CITATION-CI: "parser grammar requires BCs to prevent future regressions to the guard itself")
- Needs CI topology documentation in the new script (why it runs in spec-guard, not test job)
- Scope: 2+ files modified (new script + ci.yml)

Guard 2 (MUTANTS-POLICY-CITATION-GUARD): Not quick-dev eligible by strict definition.
- Touches 2 files (new script + ci.yml step)
- Simple bash: parse the markdown table, extract file/function pairs, grep each
- No new BCs needed
- Regression risk: LOW

Guard 3 (MUTANTS-GLOB-EXISTENCE-GUARD): Near-trivial.
- Single new file (`tests/mutants_glob_existence.rs`)
- Follows `tests/claude_md_citations.rs` pattern exactly
- No ci.yml change needed
- Would qualify as near-quick-dev but the multi-file CLAUDE.md doc-fallout makes it formally non-trivial

### Regression risk

| File / Area | Risk | Reason |
|-------------|------|--------|
| `tests/mutants_glob_existence.rs` (Guard 3) | LOW | New test file; no existing code to break |
| `scripts/check-bc-citation-symbols.sh` (Guard 1) | LOW | New bash script; no existing code to break |
| `scripts/check-cargo-mutants-policy-citations.sh` (Guard 2) | LOW | New bash script; no existing code to break |
| `.github/workflows/ci.yml` | LOW-MEDIUM | Additive steps; risk is false-positive causing CI regression. Mitigated by test-self assertions in scripts (per `check-bc-no-numeric-test-counts.sh` pattern) |
| `src/` files | NONE | Zero production code changes across all three guards |
| `ci-gate.needs` | NONE | No changes needed; all three guards ride existing required jobs |

**Key regression guard:** Each new script MUST include a `--self-test` or fixture-based
self-test mode (following `check-bc-no-numeric-test-counts.sh` and
`check-bc-cumulative-counts.sh` patterns) so a future regression to the script's own
logic fails loudly, not silently.

### examine_globs watch-item: MUTANTS-FIRST-SCOPED-PR-CALIBRATION

None of the three guards touch `src/` code files. Their implementation files
(`scripts/*.sh`, `tests/mutants_glob_existence.rs`) are NOT in `examine_globs`.
Therefore none of these guards will generate mutations on their own delivery PRs.
The `--in-diff` gate will exit 0 via the "0 mutants — non-empty diff with no
mutable lines in examine_globs" path. This is correct and expected behavior.

### Story shaping recommendation

**Recommended: 2 stories, wave ordering guards-2-3 first.**

**Story A: S-MUTANTS-SCOPE-GUARDS** (Guards 2+3 together)
- Scope: 3 files (new `scripts/check-cargo-mutants-policy-citations.sh`,
  new `tests/mutants_glob_existence.rs`, CLAUDE.md doc-fallout note; `ci.yml` +1 step for Guard 2)
- No new BCs
- Governance: `docs/specs/cargo-mutants-policy.md` (policy-doc-only, consistent with existing mutation gate governance)
- Wave: Wave 1 — deliver first; simpler, immediate value, unblocked

**Story B: S-BC-CITATION-GUARD** (Guard 1)
- Scope: 3 files (new `scripts/check-bc-citation-symbols.sh`, CLAUDE.md doc-fallout,
  `ci.yml` +1 spec-guard step; new BCs in `cross-cutting.md`)
- New BCs in F2: ~3 (extending BC-X.13 subsystem)
- VSDD pipeline: full F2-F7 (parser grammar + false-positive surface warrant BCs;
  DEAD-CITATION-CI precedent confirms this class of guard benefits from full pipeline)
- Wave: Wave 2 — deliver after Story A

**Rationale for wave ordering:**
Story A (Guards 2+3) is unconditionally simple and closes a concrete governance gap
in the cargo-mutants scope table. It requires no new BCs and can ship quickly.
Story B (Guard 1) requires full F2-F7 and benefits from Story A's delivery (the
cargo-mutants policy guard will be a clean, stable reference when BC-CITATION-GUARD
is being designed). Ordering also respects increasing complexity.

**Why not 3 separate stories:**
Guards 2 and 3 share the cargo-mutants domain, share the same governance document,
and are each trivially small. Splitting them would create unnecessary process overhead.
They are cohesive as a "cargo-mutants scope consistency" pair.

---

## 8. New BCs and VPs Recommended

### Story A (Guards 2+3): No new BCs

Policy-doc-only governance per the MUTATION-CI-TIMEOUT precedent. The cargo-mutants
mutation gate has no BC (explicitly decided: "policy spec provides sufficient governance
for a CI-only behavior"). Extending that pattern to Guards 2+3 is consistent.

Verification: existing `docs/specs/cargo-mutants-policy.md` serves as the governing
spec. No formal VP needed for Guard 2 (the policy table is the spec) or Guard 3 (a
trivial file-existence check with no grammar complexity). If proptest is desired for
Guard 3's TOML parser, it can be added as inline tests in `tests/mutants_glob_existence.rs`.

### Story B (Guard 1): New BCs in cross-cutting.md

Provisional BC IDs (to be formalized in F2):

| Provisional ID | Contract | Notes |
|----------------|----------|-------|
| BC-X.13.004 | Every `src/` file path cited in a `**Trace**:` or `**Source**:` line in any `bc-*.md` body resolves to a real on-disk file in the develop checkout | Core existence contract |
| BC-X.13.005 | Every `file::symbol` form citation in Trace:/Source: lines must have the symbol string appear in the cited file (grepped via `fn symbol` or bare `symbol` occurrence) | Symbol-location contract |
| BC-X.13.006 | The guard is GREEN on develop HEAD; it fails deterministically when a stale `src/file.rs::symbol` citation is introduced (file exists but symbol absent) | Self-verifying integration contract |

VPs (provisional):

| Provisional VP | Property | Method |
|----------------|----------|--------|
| VP-BCGUARD-001 | `extract_bc_src_citations(doc)` correctly extracts `src/` path tokens from Trace:/Source: lines and strips `::symbol`, `:~NN`, `§ "..."` suffixes | Inline unit tests in script (or proptest in a Rust companion test) |
| VP-BCGUARD-002 | Guard passes GREEN on develop HEAD with factory-artifacts mounted | Integration test: spec-guard job on current develop |

---

## 9. Impact Assessment Table

| Artifact | Impact | Details |
|----------|--------|---------|
| PRD / BCs | NEW (Story B only) | ~3 new BCs in `cross-cutting.md` (BC-X.13.004+) |
| Architecture | NONE | No `src/` module changes; all changes are in scripts and CI config |
| UX | NONE | Infrastructure/CI only |
| Stories | NEW | 2 stories: S-MUTANTS-SCOPE-GUARDS + S-BC-CITATION-GUARD |
| Tests | NEW | `tests/mutants_glob_existence.rs` (Guard 3) |
| Verification | NEW (Story B only) | ~2 VPs (VP-BCGUARD-001/002) |
| CI / Workflow | MODIFIED | `spec-guard` job +2 steps (Guards 1+2); `test` job auto-picks up Guard 3 |
| CLAUDE.md | MODIFIED | Doc-fallout note for each guard (3 additions, follow the AI Agent Notes pattern) |
| BC-INDEX.md | MODIFIED (F2, Story B only) | Updated after new BCs added in cross-cutting.md |
| CANONICAL-COUNTS.md | MODIFIED (F2, Story B only) | Updated after new BCs added |
| `docs/specs/cargo-mutants-policy.md` | UNCHANGED (CHECKED) | Guard 2 validates it; does not modify it |
| `.cargo/mutants.toml` | UNCHANGED (CHECKED) | Guard 3 validates it; does not modify it |

---

## 10. Files Summary

### New files (Story A: Guards 2+3)
```
scripts/check-cargo-mutants-policy-citations.sh   NEW — Guard 2: policy function-location check
tests/mutants_glob_existence.rs                   NEW — Guard 3: examine_globs file-existence check
```

### New files (Story B: Guard 1)
```
scripts/check-bc-citation-symbols.sh              NEW — Guard 1: BC Trace/Source citation check
```

### Modified files (both stories)
```
.github/workflows/ci.yml         MODIFIED — spec-guard job +2 steps (Guards 1+2); Guard 3 needs no change
CLAUDE.md                        MODIFIED — doc-fallout notes (3 additions in AI Agent Notes)
```

### Modified files (Story B only, F2)
```
.factory/specs/prd/cross-cutting.md    MODIFIED — new BCs BC-X.13.004/005/006
.factory/specs/prd/BC-INDEX.md         MODIFIED — updated counts
.factory/specs/prd/CANONICAL-COUNTS.md MODIFIED — updated counts
```

### Regression baseline (unchanged)
All `src/` files, all other `tests/*.rs` files, `.cargo/mutants.toml`,
`docs/specs/cargo-mutants-policy.md`, all `docs/adr/` files, all `scripts/*.sh`
files other than the two new ones.

---

## 11. Recommended Scope for Subsequent Phases

### Story A: S-MUTANTS-SCOPE-GUARDS (Guards 2+3)

**F2 (spec):** No new BCs. Spec is `docs/specs/cargo-mutants-policy.md` (already exists).
Produce a lightweight spec addendum documenting guard behavior.

**F3 (story):** Single story S-MUTANTS-SCOPE-GUARDS.
- AC-001: `scripts/check-cargo-mutants-policy-citations.sh` passes on develop HEAD
- AC-002: Guard fails deterministically when a function is cited in the wrong file
- AC-003: `tests/mutants_glob_existence.rs` passes on develop HEAD (all 11 globs resolve)
- AC-004: Guard fails when a glob entry is added for a nonexistent file (self-test via fixture)
- AC-005: CI step added to spec-guard job for Guard 2; no ci.yml change for Guard 3
- AC-006: CLAUDE.md doc-fallout notes added

**F4 (implementation):** TDD delivery. Two files written in worktree.
**F5 (adversarial):** One pass (simple scripts, low complexity).
**F6 (hardening):** Inline fixture self-tests; no formal proofs needed.
**F7 (convergence):** PATCH release.

### Story B: S-BC-CITATION-GUARD (Guard 1)

**F2 (spec):** Full spec crystallization. Define BC-X.13.004/005/006 with precise
citation-form grammar (handling `::symbol`, `§ "..."`, `:~NN` forms). Critical
adversarial focus: false-positive surface for real CLAUDE.md-style citations in BC bodies.

**F3 (story):** Single story S-BC-CITATION-GUARD.
- ACs covering: parser extraction, symbol-grep behavior, file-existence behavior,
  §-form skip, `:~NN`-form skip, guard GREEN on develop HEAD.

**F4 (implementation):** TDD delivery. Guard runs in spec-guard job context.
**F5 (adversarial):** Multiple passes (parser grammar, false-positive surface).
**F6 (hardening):** Proptest on bash extractor or companion Rust test.
**F7 (convergence):** PATCH release.

---

## Sign-off Checklist

- [x] All affected components identified with change type (NEW/MODIFIED/DEPENDENT)
- [x] Regression risk assessed per affected module
- [x] Existing tests in the risk zone enumerated (none — additive only)
- [x] Files NOT changed explicitly listed as regression baseline
- [x] Feature type classified: `infrastructure`
- [x] Intent classified: `feature`
- [x] Trivial scope assessed: standard (guards touch multiple files; Guard 1 has BCs)
- [x] CI checkout topology verified against live `.github/workflows/ci.yml` (not assumed)
- [x] DEAD-CITATION-CI precedent and DEC-129 lesson applied
- [x] DEC-096/097 convention respected: no direct branch-protection changes needed
- [x] Symbol-resolution feasibility assessed: file existence + symbol grep confirmed viable
- [x] False-positive risk analyzed per citation form (`:~NN`, `§ "..."`, `::symbol`)
- [x] Prior art inventoried (all scripts, claude_md_citations.rs, DEAD-CITATION-CI delta)
- [x] BC-INDEX.md and CANONICAL-COUNTS.md included in perimeter scan
- [x] CI workflow scope-summary comments included in perimeter scan
- [x] examine_globs regression watch-item confirmed (none of these guards are in examine_globs)
- [x] Story shaping recommendation: 2 stories, wave ordering guards-2-3 first
- [x] Single-repo (no affected-repos.txt needed)

_Awaiting human approval of scope._
