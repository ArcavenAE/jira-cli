---
document_type: story
story_id: "S-BC-CITATION-GUARD-1"
title: "CITATION-GUARDS Story B: BC-body Trace/Source file::symbol citation guard (DEC-148)"
wave: feature-followup
status: draft
intent: ci-hardening
feature_type: infrastructure
mode: feature
scope: standard
severity: LOW
trivial_scope: false
points: 8
priority: P1
tdd_mode: strict
estimated_effort: medium
estimated_days: 2.0
target_module: ci-infrastructure
subsystems: []
depends_on: ["S-MUTANTS-SCOPE-GUARDS-1"]
blocks: []
behavioral_contracts: []
# BC status: pending PO authorship (F2). Provisional IDs: BC-X.13.004, BC-X.13.005, BC-X.13.006
# (extending the BC-X.13 citation-guard subsystem established by DEAD-CITATION-CI in
# .factory/specs/prd/cross-cutting.md). Unlike Story A (policy-doc-only governance, bcs: []
# per MUTATION-CI-TIMEOUT/S-TESTTOOL-1 precedent), Story B warrants formal BCs because the
# citation-extraction grammar (::symbol, §, :~NN forms; definition-anchored grep) has enough
# complexity to benefit from contracts preventing future regressions to the guard itself —
# same reasoning that drove BCs for tests/claude_md_citations.rs (DEAD-CITATION-CI, DEC-129).
# Status must remain draft until F2 PO authors and anchors the BCs (S-7.01 Spec-First Gate).
# Pattern deviation from policy-doc-only: BC-X.13.004/005/006 will be authored in F2, not here.
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 7
assumption_validations: []
risk_mitigations: []
created: "2026-07-04"
version: "1.0"
last_updated: "2026-07-04"
breaking_change: false
retroactive: false
origin: >
  DEC-148 citation-debt-filewide cycle (2026-06-30): 12 stale file::symbol citations in
  .factory/specs/prd/bc-3-issue-write.md — 9 citing handle_jsm_create in create.rs after
  it moved to jsm_create.rs (ADR-0012 Seam A/B), 2 citing edit.rs functions in create.rs,
  1 citing field_resolve.rs functions in helpers.rs. Consumed ~30 adversarial passes to
  hand-fix (DEC-147/148/149). No CI guard existed to catch Trace/Source field staleness.
  F1 delta analysis citation-guards-2026-07-02-delta.md §2 (BC-CITATION-CI-GUARD / Guard 1).
  Stories recommended: 2 (wave_order: guards-2-3-first per F1 §7). This is Story B.
changelog:
  - "1.0 (2026-07-04): Initial F3 story draft — S-BC-CITATION-GUARD-1 (CITATION-GUARDS
    Story B, Guard 1). BC body Trace/Source file::symbol citation guard. Bash script +
    spec-guard CI steps. 7 ACs. 4-file set (new script + ci.yml + CHANGELOG + CLAUDE.md;
    cross-cutting.md/BC-INDEX/CANONICAL-COUNTS are F2 artifacts). F1 delta analysis:
    citation-guards-2026-07-02-delta.md §2 (Guard 1)."
lineage:
  - S-MUTANTS-SCOPE-GUARDS-1     # Story A (Guards 2+3), wave 1 of CITATION-GUARDS bundle; wave 2 is this story
  - S-MAINT-DEAD-CITATION-CI     # prior art: established BC-X.13 subsystem (tests/claude_md_citations.rs); Guard 1 extends to BC-X.13.004+
  - S-408-stale-citation-anchors  # DEC-129 codified CI-checkout topology lesson applied here
drift_items:
  - BC-CITATION-CI-GUARD
  - "#492-PG-TRACE-TESTS"
  - CITATION-FORM-DISCIPLINE
  - PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY
files_modified:
  - scripts/check-bc-citation-symbols.sh   # NEW — Guard 1: extract Trace/Source src/ citations from bc-*.md bodies; validate file::symbol against develop's src/ tree
  - .github/workflows/ci.yml               # MODIFY — spec-guard job: +2 steps (--self-test + canonical run); update job name to include "citation checks"
  - CHANGELOG.md                           # MODIFY — [Unreleased] entry per CHANGELOG-per-PR hygiene
  - CLAUDE.md                              # MODIFY — doc-fallout note in AI Agent Notes (parallel to check-cargo-mutants-policy-citations.sh line)
  # NOT in this F4 delivery (F2 artifacts authored separately):
  #   .factory/specs/prd/cross-cutting.md    MODIFY — new BCs BC-X.13.004/005/006
  #   .factory/specs/prd/BC-INDEX.md         MODIFY — updated counts
  #   .factory/specs/prd/CANONICAL-COUNTS.md MODIFY — updated counts
---

# S-BC-CITATION-GUARD-1 — CITATION-GUARDS Story B: BC-body Trace/Source file::symbol Citation Guard

**Status:** DRAFT — F3 initial decomposition (2026-07-04); BCs pending F2 PO authorship.

**Origin:** DEC-148 citation-debt-filewide cycle. After ADR-0012 Seam A/B extracted
`handle_jsm_create` to `src/cli/issue/jsm_create.rs` and `handle_edit` to
`src/cli/issue/edit.rs`, the `.factory/specs/prd/bc-3-issue-write.md` `**Trace**:`
and `**Source**:` fields still cited the old file paths. 12 stale citations, ~30 adversarial
passes to hand-fix. No CI guard detected the drift.

**F1 delta analysis:** `.factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md`
**Story A (wave 1):** `S-MUTANTS-SCOPE-GUARDS-1` (delivered PR #572, develop @ ab78a2d)
**CI topology analysis:** F1 §3 (verified against live ci.yml) — option (a) chosen.

---

## Governance Note

**Formal BCs warranted; pending F2 PO authorship.** Unlike Story A (policy-doc-only
governance under the MUTATION-CI-TIMEOUT / S-TESTTOOL-1 / S-MUTANTS-EXAMINE-GLOBS-1 pattern),
this story warrants formal behavioral contracts because the citation-extraction grammar —
handling `::symbol`, `§ "..."`, `:~NN`, and bare file forms — has enough combinatorial
complexity that future regressions to the guard itself are plausible without machine-checkable
contracts. This is the same reasoning that drove BCs for `tests/claude_md_citations.rs` in the
DEAD-CITATION-CI cycle (DEC-129, F1-F7 pipeline, BC-X.13.001/002/003).

Provisional BC IDs (to be authored and anchored in F2):
- **BC-X.13.004:** Every `src/` file path in a `**Trace**:` or `**Source**:` line in any
  `bc-*.md` body resolves to a real on-disk file in the develop checkout.
- **BC-X.13.005:** Every `file::symbol` citation in Trace/Source lines has the symbol string
  present as a definition (not merely an import) in the cited file.
- **BC-X.13.006:** The guard runs GREEN on develop HEAD and fails deterministically when a
  stale `src/file.rs::symbol` citation is introduced (file exists but symbol absent).

The `bcs: []` field is intentional during F3. A frontmatter comment signals this is
pending-authorship, not policy-doc-only. Per S-7.01 Spec-First Gate: status remains `draft`
until BCs are authored and this story is re-evaluated for `ready` transition.

**F4 delivery scope:** `scripts/check-bc-citation-symbols.sh` + CI wiring + CHANGELOG +
CLAUDE.md. The new BCs in `cross-cutting.md` and related `BC-INDEX.md` /
`CANONICAL-COUNTS.md` updates are F2 artifacts authored separately.

**CI topology — option (a) confirmed:** F1 §3 verified against live `.github/workflows/ci.yml`
(lines 110–132). The existing `spec-guard` job:
1. Checks out develop (`src/` tree available).
2. Runs `git worktree add .factory origin/factory-artifacts` (`.factory/specs/prd/bc-*.md`
   available).

Guard 1's script runs as a step in this job — both the cited `src/` files AND the citing
BC bodies are simultaneously on-disk. Options (b) (pre-commit only) and (c) (dual-checkout
new job) are REJECTED. Option (a) matches the DEAD-CITATION-CI pattern (DEC-129 lesson).

---

## Narrative

As a contributor to the `jr` CLI,
I want a CI guard that validates every `src/` file path (and its cited symbol, where applicable)
referenced in a `**Trace**:` or `**Source**:` field of a BC body in `.factory/specs/prd/bc-*.md`,
so that a module refactor (file move, function rename, or Seam extraction) cannot silently leave
stale citations in the behavioral contracts without immediate CI detection.

---

## Traceability

| Source | Link |
|--------|------|
| Root-cause cycle | DEC-148 (CITATION-DEBT-FILEWIDE, 2026-06-30) — 12 stale citations in bc-3; ~30 adversarial passes to hand-fix |
| Motivation quantification | `.factory/phase-f1-delta-analysis/citation-debt-filewide-2026-06-30-delta.md` — 14 relocation-stale citations in bc-2 and bc-3 alone |
| F1 delta analysis (scope) | `.factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md §2` (BC-CITATION-CI-GUARD / Guard 1) |
| CI topology analysis | F1 §3 — option (a) confirmed; spec-guard job already dual-mounts develop + factory-artifacts |
| Symbol-resolution feasibility | F1 §6 — file-existence alone too weak; must check symbol definition |
| Preceding delivery | S-MUTANTS-SCOPE-GUARDS-1 PR #572 (Guards 2+3); develop @ ab78a2d |
| Prior art: citation guard pattern | `tests/claude_md_citations.rs` (DEAD-CITATION-CI, BC-X.13.001-003; Guard 1 extends same subsystem) |
| Prior art: bash guard with self-test | `scripts/check-cargo-mutants-policy-citations.sh` (S-MUTANTS-SCOPE-GUARDS-1 PR #572) |
| Prior art: Trace/Source line scanning | `scripts/check-bc-no-numeric-test-counts.sh` (PG-365-1) — same `^\*\*(Trace|Source)\*\*:` grep anchor |
| Open gap addressed | STATE.md BC-CITATION-CI-GUARD drift item |
| Open gap NOT addressed | STATE.md #492-PG-TRACE-TESTS (tests/ citation hygiene — see Out of Scope) |

---

## Behavioral Contracts

Formal BCs pending F2 PO authorship. Provisional IDs: BC-X.13.004, BC-X.13.005, BC-X.13.006
(extending the BC-X.13 citation-guard subsystem in `.factory/specs/prd/cross-cutting.md`).

| Provisional ID | Contract topic | Notes |
|----------------|---------------|-------|
| BC-X.13.004 | File-existence: every `src/` path in Trace/Source lines resolves to a real file | Core contract |
| BC-X.13.005 | Symbol-location: every `::symbol` form citation has its symbol present as a definition in the cited file | Distinguishes from import-only occurrences |
| BC-X.13.006 | Guard self-verifiability: GREEN on develop HEAD; deterministically RED on stale citation introduction | Integration contract |

---

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~12,000 (v1.0; expected to grow through adversarial passes) |
| F1 delta analysis §2/§3/§6/§7 (Guard 1 scope) | ~4,000 |
| `scripts/check-bc-no-numeric-test-counts.sh` (prior art — Trace/Source scanning pattern) | ~800 |
| `scripts/check-cargo-mutants-policy-citations.sh` (prior art — bash guard pattern, self-test design) | ~2,500 |
| `tests/claude_md_citations.rs` (prior art — BC-X.13 subsystem, same guard family) | ~3,000 |
| `.github/workflows/ci.yml` spec-guard job section (lines 110–140) | ~700 |
| Representative `bc-*.md` file (e.g. `bc-3-issue-write.md` — to understand Trace/Source field format) | ~10,000 |
| `CHANGELOG.md` [Unreleased] section | ~300 |
| **Total** | **~33,000** |

~17% of a 200k context window. Well within 20% threshold; no story splitting required.

---

## Tasks

**RED-gate staging (`tdd_mode: strict`):** Under strict TDD, the bash self-test fixture suite
(Task 2 `--self-test` block) is written first against a stub `run_check() { return 0; }` that
emits no output. Under the no-output stub ALL seven fixtures fail RED:
- Fixtures A, B, C, D, E, G (all expecting `rc=1`) fail their `[ "$rc" -eq 1 ]` assertions.
- Fixture F (expecting `rc=0`) passes the rc check BUT fails its content assertion
  (`^Check passed:` regex against empty output).
- Fixture G passes rc assertion (stub returns 0, but CANONICAL_MODE=1 means the stub does not
  fire the floor guard — so rc=0 but the floor check is also absent → actually rc=0 fails
  the `[ "$rc" -eq 1 ]` floor assertion → RED).

An output-emitting stub is NOT sanctioned (same rationale as Story A): it could incidentally
satisfy Fixture F's content assertion while leaving others RED, corrupting the RED-gate
observation. The no-output stub mandates all fixtures to be RED before implementation begins.

1. **Read the target format.** Read at least one `bc-*.md` file (e.g.,
   `.factory/specs/prd/bc-3-issue-write.md`) to understand the `**Trace**:` and `**Source**:`
   field format. Key observations:
   - Citations appear as backtick-quoted tokens on Trace/Source lines:
     `` **Trace**: `src/cli/issue/edit.rs::handle_edit` (handle_edit function) ``
   - Forms: `file::symbol` (most common), `file § "comment"` (section ref),
     `file:~NN` (approximate line), `file` (bare file-existence).
   - The backtick token extraction regex `grep -oE '`[^` ]+`'` extracts everything up to the
     first space within backticks — so `` `src/file.rs § "text"` `` yields `` `src/file.rs` ``
     (stops at space before `§`). This means `§` form citations are naturally reduced to bare
     file paths by the extraction step; no explicit `§` handler is needed.
   - `tests/` citations (e.g., `tests/issue_commands.rs:1646-1703`) on Trace/Source lines are
     NOT in scope — Guard 1 validates `src/` paths only (see Out of Scope).
   - `check-bc-no-numeric-test-counts.sh` uses `grep -nE '^\*\*(Trace|Source)\*\*:'` as the
     Trace/Source line anchor — reuse this exact pattern.

2. **Write `scripts/check-bc-citation-symbols.sh` (Guard 1).**

   **Script error ID:** `BC-CITE-001` (analogous to `CI-MUTANTS-CITE-001` in Story A).
   Embed this literal in the script header comment for a static pin (same mechanism as
   `check-cargo-mutants-policy-citations.sh`).

   **Flags:**
   - Default (no flag): canonical CI run. `CANONICAL_MODE=1` when neither `--self-test` nor
     `--bc-dir` supplied. Initialize `self_test=0` and `CANONICAL_MODE=0` before the parse
     loop (prior art: `check-cargo-mutants-policy-citations.sh:202-203`):
     ```bash
     self_test=0
     CANONICAL_MODE=0
     # ... argument parsing ...
     if [ "$self_test" = "0" ] && [ -z "${BC_DIR+x}" ]; then CANONICAL_MODE=1; fi
     ```
   - `--bc-dir <path>`: override the BC directory (default: `.factory/specs/prd`). Designed to
     support self-test fixture isolation via in-process `BC_DIR=` assignment; the CLI flag
     itself is designed-to-support (analogous to `--policy-doc` in Story A).
   - `--src-root <dir>`: override the source root for file-existence and symbol grep. Without
     `--self-test`, this is a usage error (exit 64) to prevent accidental redirect of a real
     guard run to a temp directory.
   - `--self-test`: run all seven self-test fixtures; exit 0 if all pass, 1 if any fail.

   **Repo-root resolution:** Use SCRIPT_DIR convention:
   ```bash
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
   ```

   **Top-of-file syntax self-check (unconditional, before arg parsing):**
   ```bash
   bash -n "${BASH_SOURCE[0]}"
   ```

   **`run_check` function algorithm:**

   Default variable initialization (at top of `run_check`):
   ```bash
   local bc_dir="${BC_DIR:-.factory/specs/prd}"
   local src_root="${SRC_ROOT:-${REPO_ROOT}}"
   local canonical="${CANONICAL_MODE:-0}"
   local FLOOR=30
   ```

   **Step 1: Enumerate bc-*.md files. Fail-closed if none found** (mirrors
   `check-bc-no-numeric-test-counts.sh:23-27`):
   ```bash
   bc_files=("$bc_dir"/bc-*.md)
   if [ ! -f "${bc_files[0]}" ]; then
       echo "BC-CITE-001: no bc-*.md files found in $bc_dir — nothing to scan"
       return 1
   fi
   ```

   **Step 2: For each bc-*.md file, find all Trace/Source lines:**
   ```bash
   grep -nEh '^\*\*(Trace|Source)\*\*:' "${bc_files[@]}" || true
   ```
   The `|| true` guard prevents `set -euo pipefail` abort when no Trace/Source lines exist.

   **Step 3: Extract backtick-quoted `src/` citation tokens from each line:**
   ```bash
   grep -oE '`src/[^` ]+`' | tr -d '`'
   ```
   This is the **canonical extraction regex** — single source of truth. It extracts backtick-
   delimited tokens starting with `src/`. The `[^` ]+` pattern stops at the first space or
   backtick, so:
   - `` `src/file.rs::symbol` `` → `src/file.rs::symbol`
   - `` `src/file.rs § "text"` `` → `src/file.rs` (stops at space before `§`)
   - `` `src/file.rs:~120` `` → `src/file.rs:~120`
   - `` `src/file.rs` `` → `src/file.rs`

   **Step 4: For each extracted token, determine citation form and check:**

   a. Strip citation suffixes to get the file path:
      - `::symbol` form: `file="${token%%::*}"` + `symbol="${token##*::}"` (last `::` strip,
        analogous to Story A's `::strip transform`). If `file == symbol` (no `::` found),
        there is no symbol component — treat as bare file form.
      - `:~NN` or `:NN-MM` form: `file="${token%%:*}"` (strip at first `:`).
      - `§ ...` form: never reaches here — the space-stop extraction already stripped the `§`.
      - Bare file: `file="$token"`.

   b. **File-path shape guard:** Validate `file` against `^src/[a-zA-Z0-9_/.-]+\.rs$` and
      reject path-traversal (`..`). Malformed → emit `DEAD: malformed citation skipped: $token`
      and continue.

   c. **File-existence check:** `[ -f "$src_root/$file" ]` → if fails, emit
      `DEAD: $file not found` and continue.

   d. **Symbol check (only for `::symbol` form):** Use definition-anchored grep (NOT plain
      `grep -q symbol` — that false-greens on import-only occurrences, the exact DEC-148 class):
      ```bash
      grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?((unsafe|const|async|extern[[:space:]]+\"[^\"]*\")[[:space:]]+)*fn[[:space:]]+${symbol}([^[:alnum:]_]|$)" \
          "$src_root/$file"
      ```
      → if fails, emit `DEAD: $symbol not found in $file` (symbol absent or import-only).
      **Fall-back for non-function symbols (constants, types):** If the definition-anchored `fn`
      grep fails, also try `grep -q "${symbol}" "$src_root/$file"` as a secondary check — if
      the bare symbol string appears at all, it may be a constant or type definition. If the
      secondary check also fails, the citation is DEAD. If either check passes, the citation is
      alive. Note: the primary `fn`-anchored check is the standard path; the secondary check is
      a permissive fallback for non-function symbol citations.

   e. **Count all checked citations** for the coverage-floor guard.

   **Step 5: Coverage-floor guard (CANONICAL_MODE only):**
   ```bash
   if [ "$canonical" = "1" ] && [ "$total_citations" -lt "$FLOOR" ]; then
       echo "BC-CITE-COVERAGE-FLOOR: expected >= ${FLOOR} src/ citations, got ${total_citations}. Update FLOOR when citations are intentionally removed."
       return 1
   fi
   ```
   `FLOOR=30` is a conservative lower bound verified against develop HEAD at delivery time (the
   implementer MUST run the script in canonical mode on develop HEAD to confirm the actual count
   exceeds 30 before setting this value). The FLOOR is a LOWER BOUND — additions never fire it.

   **Step 6: Report offenders or success:**
   - Non-empty offenders list: print each `DEAD:` line, then summary
     `$K stale citation(s) found in bc-*.md Trace/Source fields`; `return 1`.
   - Empty offenders: print `Check passed: $N citations checked`; `return 0`.

   **Post-run preamble checks (in `--self-test` block, before any fixture):**
   - `bash -n "${BASH_SOURCE[0]}"` (top-of-file; unconditional)
   - `grep -Eq '^#.*BC-CITE-001' "${BASH_SOURCE[0]}"` (literal pin in script header)

3. **Write `--self-test` fixture suite (7 fixtures, embedded in script).**

   Self-test follows the Story A fixture idiom exactly:
   - All variable assertions use `[ <cond> ] || { echo "Fixture X FAIL: …"; exit 1; }` — no
     `&&`-style positive assertions (not safe under `set -e`).
   - Each fixture uses `set +e; output=$(run_check 2>&1); rc=$?; set -e`.
   - Fixtures use hermetic temp dirs: `BC_DIR`, `SRC_ROOT` set to temp paths.
   - `fixtures_run` counter (initialized to 0; incremented once per fixture; checked after all
     fixtures against `readonly EXPECTED_FIXTURES=7`).
   - Cleanup trap: `trap 'rm -rf "${tmp_A:-}" ... "${tmp_G:-}"' EXIT`.

   See AC-002 for the full fixture specification including printf skeletons, assertions, and
   kill-traces.

4. **Modify `.github/workflows/ci.yml`:** Add two steps to the `spec-guard` job (after the
   existing `check-bc-cumulative-counts` step, at the end of the steps list):
   ```yaml
   - name: check-bc-citation-symbols self-test (BC-CITE-001)
     run: bash scripts/check-bc-citation-symbols.sh --self-test

   - name: check-bc-citation-symbols (BC-CITE-001)
     run: bash scripts/check-bc-citation-symbols.sh
   ```
   Also update the job `name:` field from its current value (set by Story A PR #572) to
   include citation checks. Story A left it as `"Spec Guards (BC counts, mutants policy scope)"`.
   Update to: `"Spec Guards (BC counts, citation checks, mutants scope)"` — matching the F1 §5
   proposed wording. No changes to `ci-gate.needs` (per DEC-096/097: `spec-guard` is already a
   required job).

5. **Modify `CHANGELOG.md`:** Under `## [Unreleased]`, add under `### Added`:
   ```
   - **CI: BC-body Trace/Source citation guard (Guard 1) (DEC-148):** adds
     `scripts/check-bc-citation-symbols.sh` (BC-CITE-001; validates `src/` file and symbol
     citations in `**Trace**:`/`**Source**:` fields of all `bc-*.md` bodies; definition-anchored
     symbol grep; self-test fixtures; coverage-floor guard) as a step in the `spec-guard` CI job.
     Prevents the Seam-extraction citation-drift class (DEC-147/148/149).
   ```

6. **Modify `CLAUDE.md`:** Add one doc-fallout bullet in "AI Agent Notes" (following the
   `scripts/check-cargo-mutants-policy-citations.sh` bullet added by Story A PR #572):
   - `scripts/check-bc-citation-symbols.sh` — runs in spec-guard CI job; validates `src/` file
     and symbol citations in `**Trace**:`/`**Source**:` fields of `.factory/specs/prd/bc-*.md`
     bodies; exits 1 with `BC-CITE-001` offender list if any citation is stale. `--bc-dir` +
     `--src-root` (self-test only) + `--self-test` flags for offline verification.
     (DEC-148 Guard 1)

7. **Self-verify:** Read back all modified files. Confirm:
   - `scripts/check-bc-citation-symbols.sh --self-test` exits 0 (all 7 fixtures pass; preamble
     checks pass; `fixtures_run = "7"`).
   - `scripts/check-bc-citation-symbols.sh` (canonical run) exits 0 on develop HEAD with
     `.factory/specs/prd/` mounted (spec-guard job context). If run locally: set
     `BC_DIR=.factory/specs/prd` and run from repo root.
   - Guard emits `Check passed: N citations checked` where N ≥ 30 (verifying FLOOR is valid).
   - ci.yml spec-guard job `name:` updated; two new steps present in correct position.
   - CHANGELOG `### Added` entry contains `BC-CITE-001`, `Trace`, `Source`, `bc-*.md`,
     `definition-anchored`, `DEC-148` keywords.
   - CLAUDE.md notes reference `scripts/check-bc-citation-symbols.sh` with correct description.
   - Grep for `&& (echo|printf|:|true|\{)` in the script — must emit zero lines (Story A
     VP-1-P25 idiom applied here: no `&&`-style positive assertions).

---

## Acceptance Criteria

ACs trace to provisional BC-X.13.004/005/006 (pending F2 authorship). During draft/F4 phase,
ACs trace to F1 §2/§6 and `check-bc-no-numeric-test-counts.sh` prior-art pattern.

---

### AC-001 — Guard passes GREEN on develop HEAD

`scripts/check-bc-citation-symbols.sh` exits 0 when run with `.factory/specs/prd/` mounted
(spec-guard job context, after Story A PR #572 develop @ ab78a2d). This confirms no stale
`src/` citations exist in bc-*.md Trace/Source fields on current develop HEAD.

(traces to provisional BC-X.13.006: guard GREEN on develop HEAD)

**Sequencing note:** Guard 1 verifies citations that were already cleaned by DEC-148. If any
NEW stale citations have been introduced since the DEC-148 cleanup, the guard will report them
as new findings — and Task 7 self-verify step will catch this before the PR is opened.

---

### AC-002 — Self-test fixture table

`scripts/check-bc-citation-symbols.sh --self-test` exits 0. The `--self-test` block runs
all seven fixtures and four post-fixture self-assertions using hermetic temp directories.

**Fixture assertion idiom (VP-1-P25 from Story A — apply here):**
All fixture assertions MUST use the form `[ <cond> ] || { echo "Fixture X FAIL: …"; exit 1; }`.
No `&&`-style positive-action forms. Verify with:
```bash
grep -E '&& (echo|printf|:|true|\{)' scripts/check-bc-citation-symbols.sh
```
must output zero lines.

| Fixture | Description | Expected behavior | Kill-trace |
|---------|-------------|-------------------|------------|
| A | Dead-symbol: `src/adf.rs::nonexistent_fn_selftest` — file exists (touch), symbol NOT defined | `rc=1`; output contains `DEAD: nonexistent_fn_selftest not found in src/adf.rs` | (a) Omit definition-anchored grep → fn-check never runs → `rc=0` → RED |
| B | Dead-file: `src/nonexistent_file_selftest.rs::some_fn` — file NOT created | `rc=1`; output contains `DEAD: src/nonexistent_file_selftest.rs not found` | (a) Omit file-existence check → script tries symbol grep on missing file → error → RED differently; (b) correct: file-existence check fires first → clean DEAD message |
| C | Import-only false-green: `src/cli/issue/create.rs::handle_jsm_create` — mock `create.rs` has only `use super::jsm_create::{JsmCreateArgs, handle_jsm_create};` (import) | `rc=1`; `handle_jsm_create` DEAD (import not a definition) | (a) Plain `grep -q "handle_jsm_create"` → matches import → `rc=0` → RED; proves definition-anchored grep is required |
| D | Source-field extraction: `**Source**: `src/nonexistent_source_selftest.rs::source_fn`` (Source field, not Trace) — file NOT created | `rc=1`; output contains dead citation | (a) Scan only `**Trace**:` lines, skip `**Source**:` → `rc=0` → RED; proves both field types are scanned |
| E | Section-ref form: `**Trace**: `src/mock_e.rs § "some section"`` — mock `mock_e.rs` exists (touch, empty — no fns) | `rc=0` (§ form → file path extracted via space-stop; file exists; no symbol check) | (a) Apply symbol grep to all tokens including § form → grepping empty file fails → `rc=1` → RED; proves § form is file-existence-only |
| F | Success path: `**Trace**: `src/mock_f.rs::mock_f_fn_selftest`` + `**Source**: `src/mock_f.rs`` — mock `mock_f.rs` defines `fn mock_f_fn_selftest() {}` | `rc=0`; output matches `^Check passed: [0-9]+ citations checked$` | (a) Inverted polarity (return 1 on success) → `rc=1` → RED; (b) Omit success summary line → content assertion fails → RED |
| G | Coverage-floor RED probe: bc dir with ONE citation total (well below FLOOR=30); CANONICAL_MODE=1 | `rc=1`; output contains `BC-CITE-COVERAGE-FLOOR:`; output contains `expected >= 30` | (a) Omit CANONICAL_MODE gate → floor never fires → `rc=0` → RED; (b) FLOOR value mutation (30→0) → floor never fires → `rc=0` → RED |

**Post-fixture self-assertions (NOT fixtures; do NOT increment `fixtures_run`):**
- `[ "$(grep -cF 'BC-CITE-001' "${BASH_SOURCE[0]}")" = "3" ]` — exact count pin (header comment
  + preamble check + own assertion line = 3; addition raises to 4 → RED, deletion drops to 2 → RED).
  Wording constraint: the three echo diagnostics in the script that contain `FAIL:` MUST NOT
  include the literal `BC-CITE-001` (else they inflate this count).
- `[ "$(grep -cF 'bash -n' "${BASH_SOURCE[0]}")" = "2" ]` — top-of-file check + own assertion = 2.
- `[ "$(grep -cF "grep -oE" "${BASH_SOURCE[0]}")" = "3" ]` — canonical extraction regex
  occurrence pin (extraction definition + any usage occurrences + own assertion line).
  Adjust count to match actual occurrences verified at delivery time; document the exact count.
- `[ "$fixtures_run" = "$EXPECTED_FIXTURES" ]` — fixture-count integrity pin (string equality;
  prevents silent fixture omission via drop-a-fixture mutation; `EXPECTED_FIXTURES=7` declared
  `readonly` before first fixture).

(traces to provisional BC-X.13.004/005/006 — all three contracts exercised across the fixture suite)

---

### AC-003 — Error output formats

When citations fail, the script emits lines in the following formats:
- `DEAD: $file not found` — file does not exist on disk
- `DEAD: $symbol not found in $file` — file exists but symbol definition absent
- `DEAD: malformed citation skipped: $token` — extracted token fails path shape guard
- `BC-CITE-COVERAGE-FLOOR: expected >= ${FLOOR} src/ citations, got ${N}. Update FLOOR when
  citations are intentionally removed (the floor is a lower bound; additions never fire it).`
  (CANONICAL_MODE=1 only)

All `DEAD:` lines are accumulated into an offenders list before reporting (collect-ALL semantics,
analogous to Story A's definition-anchored grep). The script does NOT exit early on first DEAD
citation — all citations in all bc-*.md files are checked before reporting. Summary line:
`$K stale citation(s) found in bc-*.md Trace/Source fields` (where K = offender count).

(traces to provisional BC-X.13.004/005)

---

### AC-004 — Scope restriction: Trace/Source lines only; src/ paths only

The guard extracts citations ONLY from lines matching `^\*\*(Trace|Source)\*\*:` (anchored at
line start, exact markup). It does NOT extract from:
- BC frontmatter (YAML block before `---` delimiter)
- BC body prose, Description, Preconditions, Postconditions, Invariants, Examples sections
- Lines that mention `src/` paths incidentally (not in a Trace/Source field)
- `tests/` citation paths (OUT OF SCOPE — see Out of Scope §1)
- BC-INDEX.md (OUT OF SCOPE — see Out of Scope §2)

Fixture F exercises the positive Trace + Source extraction path. Fixture D specifically
proves `**Source**:` lines are scanned (not just `**Trace**:`).

(traces to provisional BC-X.13.004 precondition: scope of checked lines is narrowly defined)

---

### AC-005 — Coverage floor: fail-closed guard on empty-extraction

When run in CANONICAL_MODE (canonical CI invocation, no `--bc-dir` or `--self-test` flag),
the script MUST fail if the total count of `src/` citations extracted across all bc-*.md
files is below `FLOOR=30`.

The FLOOR guards against the fail-open scenario where the extraction logic silently skips all
citations (e.g., due to a bc_dir misconfiguration or a future bc-*.md glob expansion change)
and exits 0 vacuously. The value `FLOOR=30` is a conservative lower bound; the implementer
MUST verify the actual count on develop HEAD exceeds 30 before final delivery.

The `FLOOR` symbol MUST be used in BOTH the comparison (`[ "$total_citations" -lt "$FLOOR" ]`)
AND the message interpolation (`expected >= ${FLOOR}`). A mutation that weakens only the
comparison value (e.g., 30→5) while leaving the message literal `"expected >= 30"` unchanged
would be caught by Fixture G's `grep -qF 'expected >= 30'` assertion.

(traces to provisional BC-X.13.006 invariant: guard cannot pass vacuously with zero citations)

---

### AC-006 — CI wiring, job name, CLAUDE.md

**(a) CI steps:** The `spec-guard` job in `.github/workflows/ci.yml` contains two new steps
(in this order, after the `check-bc-cumulative-counts` step):
1. `check-bc-citation-symbols self-test (BC-CITE-001)` — runs `--self-test` flag
2. `check-bc-citation-symbols (BC-CITE-001)` — runs canonical guard

**(b) Job name:** `spec-guard` job `name:` field reads
`"Spec Guards (BC counts, citation checks, mutants scope)"` (updated from the Story A value
`"Spec Guards (BC counts, mutants policy scope)"` per F1 §5 proposed wording; "citation
checks" was reserved for Story B's domain).

**(c) `ci-gate.needs` unchanged:** `spec-guard` is already in `ci-gate.needs` (verified via
F1 §5). No `ci-gate.needs` modification required. Per DEC-096/097: no direct branch-protection
changes for new guards.

**(d) CLAUDE.md:** "AI Agent Notes" section contains one new bullet for
`scripts/check-bc-citation-symbols.sh` with a description including `BC-CITE-001`,
`**Trace**:`/`**Source**:`, `bc-*.md`, and `DEC-148 Guard 1`.

(traces to provisional BC-X.13.006 postcondition: guard runs in CI on every PR)

---

### AC-007 — CHANGELOG entry

`CHANGELOG.md` `## [Unreleased]` → `### Added` contains an entry with these keywords
(exact line-wrapping may differ):
- Topic prefix: `**CI: BC-body Trace/Source citation guard (Guard 1) (DEC-148):**`
- Script path: `scripts/check-bc-citation-symbols.sh`
- Error code: `BC-CITE-001`
- Field types: `**Trace**:`/`**Source**:`
- Files targeted: `bc-*.md`
- Capability keywords: `definition-anchored symbol grep`, `coverage-floor guard`
- Origin: `DEC-148`

(traces to CHANGELOG-per-PR hygiene convention)

---

## Previous Story Intelligence

**S-MUTANTS-SCOPE-GUARDS-1 (Story A, PR #572, delivered 2026-07-04 @ ab78a2d):**

Story A delivered Guards 2 and 3. Key lessons that apply to Guard 1:

1. **Definition-anchored grep is required.** The `fn`-anchored grep regex from Story A
   is directly applicable here:
   ```bash
   grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?((unsafe|const|async|extern[[:space:]]+\"[^\"]*\")[[:space:]]+)*fn[[:space:]]+${symbol}([^[:alnum:]_]|$)"
   ```
   Plain `grep -q "$symbol"` false-greens on import-only occurrences — exactly the DEC-148
   class (Fixture C proves this). Story A Fixture B (import-only false-green proof) is the
   direct precedent.

2. **`||true` on all may-match-zero grep calls.** Under `set -euo pipefail`, grep exit 1
   (zero matches) aborts the script. Every grep returning "no matches = success" MUST be
   guarded. Pattern: `grep ... || true`. (Story A pass-2 C-4 FIX.)

3. **FLOOR symbol binding in BOTH comparison AND message.** `local FLOOR=30` used in both
   `[ "$total_citations" -lt "$FLOOR" ]` AND `"expected >= ${FLOOR}"`. A mutation weakening
   only the comparison (30→5) while leaving the message literal would survive without this
   binding. (Story A MED-1-P22 FIX — apply here.)

4. **Canonical extraction regex is a single source of truth.** From Story A (F-VA-33-3):
   the backtick-token regex `` grep -oE '`[^` ]+`' `` must appear in the script exactly once
   as the authoritative pattern; any downstream transformation derives from this single call.

5. **Fixture-count integrity pin with `readonly EXPECTED_FIXTURES`.** Use string `=` (not
   `-eq`) for the comparison per Story A FIND-VA-35-2/F-VA-28-3. Initialize `fixtures_run=0`
   before first fixture; increment ONCE per fixture (multi-probe fixtures still count once);
   post-fixture self-assertions do NOT increment.

6. **`run_check` must return, not exit.** `run_check` calls `return 1` (not `exit 1`) so that
   self-test fixtures can capture both output and return code via
   `set +e; output=$(run_check 2>&1); rc=$?; set -e`. (Story A F-M-3 FIX.)

7. **FALSE-POSITIVE RISK IS LOW.** F1 §6 analyzed the false-positive surface for Guard 1.
   The primary risk (symbol renamed but file kept) is actually a TRUE POSITIVE (citation IS
   stale). The symbol-boundary anchor `([^[:alnum:]_]|$)` in the grep prevents substring
   matches (e.g., `handle_foo` not falsely matched by `handle_foobar`). Guard the boundary.

**DEAD-CITATION-CI cycle (DEC-125-130):**
The DEAD-CITATION-CI cycle established `tests/claude_md_citations.rs` and the BC-X.13
subsystem. Key lesson from DEC-129: a Rust test in the `test` job does NOT have
factory-artifacts access — which is why Guard 1 MUST be a bash script in the `spec-guard`
job (not a Rust integration test). This is option (a) confirmed by F1 §3.

---

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Guard 1 in spec-guard job ONLY | F1 §3 (CI topology, DEC-129 lesson) | `scripts/check-bc-citation-symbols.sh` runs as spec-guard steps. Do NOT add to `test` job (Rust). Do NOT create a new CI job. `spec-guard` already mounts factory-artifacts — dual-access is built-in. |
| ci-gate.needs unchanged | DEC-096/097 | `spec-guard` is already in `ci-gate.needs`. No branch-protection changes. |
| `--self-test` step BEFORE canonical step | MUTANTS-ARBITER-OFFLINE-SELFTEST precedent | The offline fixture run (`--self-test`) MUST be a separate CI step that executes BEFORE the canonical guard run. If the fixture suite regresses, it fails visibly rather than silently corrupting the canonical run. |
| Definition-anchored grep REQUIRED | F1 §6, DEC-148 (root cause) | Plain `grep -q "$symbol"` false-greens on import-only occurrences. The definition-anchored regex from Story A is the canonical form. A PR using plain grep-q MUST NOT merge. |
| `src/` citations ONLY | F1 §6 (scope recommendation) | Extract only tokens starting with `src/`. The `tests/` citation class is OUT OF SCOPE (tracked as #492-PG-TRACE-TESTS). |
| Zero `src/` changes | F1 §7 regression baseline | No production Rust source files are modified. Script + CI + docs changes only. |
| Mutation gate passes via 0-mutant path | DEC-144 precedent | Guard script and CI config are not in `examine_globs`. No killable mutants in PR diff. Expected ~30-35s on `--in-diff` run. |

---

## Library and Framework Requirements

| Tool | Version | Constraint |
|------|---------|-----------|
| `bash` | `/usr/bin/env bash` | Script uses `set -euo pipefail`. Compatible with ubuntu-latest (GitHub Actions). |
| `grep` | POSIX ERE (`-E`) | Use `-E` (POSIX extended RE) not `-P` (PCRE/GNU-only). Use `[[:space:]]`, `[[:alnum:]]` not `\s`, `\w`. Use `([^[:alnum:]_]\|$)` not `\b` for word boundary (portability to BSD grep / macOS). |
| `awk`, `sed`, `tr` | POSIX | All text processing must use POSIX-portable forms. |
| No new Rust crates | — | Guard 1 is a bash script. No `Cargo.toml` changes. No dev-dependencies added. |
| No new Rust integration test | — | Guard 1 does NOT produce a `tests/*.rs` file. It's a bash script in `spec-guard` (factory-artifacts access needed). |

---

## File Structure Requirements

| File | Create / Modify | Description |
|------|-----------------|-------------|
| `scripts/check-bc-citation-symbols.sh` | CREATE | Guard 1: scan `**Trace**:`/`**Source**:` lines in bc-*.md bodies; extract backtick-quoted `src/` citation tokens; check file existence + symbol definition (for `::symbol` form); SCOPE-EMPTY guard (fail-closed on no bc-*.md files); BC-CITE-COVERAGE-FLOOR guard (CANONICAL_MODE only); seven self-test fixtures (A–G) embedded in `--self-test` block; four post-fixture self-assertions; `BC-CITE-001` error class literal pinned in header comment. |
| `.github/workflows/ci.yml` | MODIFY | spec-guard job: update `name:` to `"Spec Guards (BC counts, citation checks, mutants scope)"`; add `--self-test` step + canonical step for Guard 1. No other job changes. No `ci-gate.needs` change. |
| `CHANGELOG.md` | MODIFY | Add `[Unreleased] → ### Added` entry per CHANGELOG-per-PR hygiene. |
| `CLAUDE.md` | MODIFY | Add doc-fallout bullet in AI Agent Notes for `scripts/check-bc-citation-symbols.sh`. |

4-file delivery. Cross-cutting.md / BC-INDEX.md / CANONICAL-COUNTS.md are F2 artifacts (authored
when PO anchors BC-X.13.004/005/006); NOT part of this F4 delivery.

---

## Edge Cases

| ID | Description | Expected behavior |
|----|-------------|-------------------|
| EC-001 | Import-only occurrence: citation `src/file.rs::fn` where `fn` appears only in a `use`/`pub use` statement, not as a definition | DEAD: symbol not found in file (Fixture C) |
| EC-002 | File exists, symbol is a constant or type (not a function) | The secondary `grep -q "$symbol"` fallback catches it (constant/type name appears in file) → citation is ALIVE |
| EC-003 | `§` form citation: `` `src/file.rs § "section"` `` — extraction stops at space before § | Token extracted as `src/file.rs` (bare path); file-existence check only; no symbol check |
| EC-004 | `:~NN` form citation: `` `src/file.rs:~120` `` | Token `src/file.rs:~120` extracted; `:~120` stripped → `src/file.rs`; file-existence check only |
| EC-005 | Coverage floor: total `src/` citations < FLOOR=30 in CANONICAL_MODE | Exit 1, `BC-CITE-COVERAGE-FLOOR:` (Fixture G) |
| EC-006 | No bc-*.md files found in BC_DIR | Exit 1 immediately with `BC-CITE-001: no bc-*.md files found`; fail-closed (no false-green) |
| EC-007 | Trace/Source line with multiple citations (comma-separated backtick tokens) | Each backtick token extracted independently; all checked; all offenders reported |
| EC-008 | Citation on a non-Trace/Source body line | NOT extracted (Fixture F covers the non-extraction of ordinary body lines) |
| EC-009 | Path-traversal in citation: `` `src/../etc/passwd.rs::fn` `` | Shape guard rejects `..` → `DEAD: malformed citation skipped:` |
| EC-010 | `tests/` citation on Trace/Source line | NOT extracted; `src/`-only scope; `tests/` path does not start with `src/` |

---

## Out of Scope

### 1. `tests/` citation hygiene (`#492-PG-TRACE-TESTS`)

BC Trace/Source lines sometimes cite test files:
```
**Trace**: tests/issue_commands.rs:1646-1703
```

Guard 1 does NOT validate `tests/` citations. Reasons:
- F1 §6 explicitly recommends scoping to `src/` for the initial pass
- `tests/` citations use bare line-range form (`:NN-MM`), which drifts as tests are added
  but the FILE never dies — file-existence checks add noise without value
- Symbol-level checks for test function names are the separate gap `#492-PG-TRACE-TESTS`

The `#492-PG-TRACE-TESTS` drift item remains OPEN after Guard 1 delivery.

### 2. BC-INDEX.md scope exclusion (`PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY`)

`BC-INDEX.md` is NOT scanned by Guard 1. Rationale:
- BC-INDEX.md is a derived/generated index, not the primary authorship surface
- The authoritative Trace/Source citations live in `bc-*.md` body files; BC-INDEX.md
  cross-references the same citations in a different format (section headers, not
  `**Trace**:`/`**Source**:` fields)
- Scanning BC-INDEX.md would produce duplicate reports for the same stale citation
  (once from bc-*.md, once from BC-INDEX.md)
- BC-INDEX.md line format differs from the `^\*\*(Trace|Source)\*\*:` anchor pattern

The `PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY` process-gap is PARTIALLY addressed:
Guard 1 mechanically enforces citation integrity in bc-*.md files. BC-INDEX.md coverage
remains a manual review concern and OPEN drift item.

### 3. CITATION-FORM-DISCIPLINE

Guard 1 validates that cited `src/` paths and symbols are ALIVE, but does NOT enforce which
citation FORM is used (e.g., whether `:~NN` forms should be migrated to `::symbol` forms per
the #408 convention). The `CITATION-FORM-DISCIPLINE` drift item (enforcing the canonical
symbol-form convention) remains OPEN after Guard 1 delivery.

### 4. EXTRACTION-SET-PIN

Guard 1 validates citation EXISTENCE (file/symbol alive) but not the full SET of expected
citations. A deletion of an entire citation (removing the `**Trace**:` line entirely rather
than leaving a stale one) is not caught. This mirrors the Story A EXTRACTION-SET-PIN
residual. Mitigated by fresh-context adversarial review; accepted terminal residual.

### 5. SCOPE-EXAMINE-GLOBS-CROSS-SET-EDGE, BACKTICK-RESERVATION-CONVENTION

These are Story A F4 residuals (process gaps from the delivered Guard 2 script). They are
unrelated to Guard 1 and remain OPEN under their existing tracking. Guard 1 is OUT OF SCOPE
for addressing them.

### 6. Symbol checks for constants, types, and macros

Guard 1's primary check uses a `fn`-anchored grep. The secondary `grep -q "$symbol"` fallback
catches most constants and types (their name appears in the definition). However, macros
(`macro_rules! $symbol`) and derive-attribute-generated impls may not match either check.
This is a LOW residual: BC Trace/Source fields primarily cite functions, not macros. Accepted
as a known approximation in v1.

### 7. Non-backtick-quoted citations

Guard 1 extracts only BACKTICK-QUOTED `src/` tokens (`` grep -oE '`src/[^` ]+`' ``). A
Trace/Source field containing an unquoted `src/file.rs:~120` (without surrounding backticks)
is NOT extracted and therefore NOT validated. Per the #408 convention, new citations should
always be backtick-quoted; unquoted forms are legacy. Recommend a separate sweep to
backtick-quote any remaining unquoted forms, but NOT in this story.

---

## Maintenance Touchpoints

- **When a Seam extraction moves a function:** Guard 1 will catch the stale BC citation on the
  next PR that touches bc-*.md OR on any PR where Guard 1 runs (all PRs via spec-guard).
  Action: update the `**Trace**:` / `**Source**:` field in the affected BC body.
- **When FLOOR=30 becomes too conservative:** If BCs are refactored and citation count drops
  legitimately below 30, update `local FLOOR=N` in `run_check` to the new validated baseline.
  The floor message includes `"Update FLOOR when citations are intentionally removed"` as a
  reminder. Update in the SAME commit as the BC edit.
- **BC-INDEX.md stale citations (out-of-scope residual):** Run manual `grep -r
  'src/cli/issue/create.rs\|src/cli/issue/helpers.rs' .factory/specs/prd/BC-INDEX.md`
  after any Seam extraction to catch BC-INDEX.md drift not covered by Guard 1.
- **Job name drift:** The spec-guard job `name:` field must be updated when new guards are
  added. The proposed pattern `"Spec Guards (BC counts, citation checks, mutants scope)"`
  is the current target state after Guard 1 delivery. Future guards should follow F1 §5's
  pattern of updating the name in the same PR as the new step.
- **FLOOR calibration at delivery:** The implementer MUST measure the actual citation count on
  develop HEAD before submitting the PR (run `scripts/check-bc-citation-symbols.sh` in
  canonical mode locally) and verify the count exceeds 30. Document the measured count in the
  `--self-test` success message or in the CHANGELOG entry.
