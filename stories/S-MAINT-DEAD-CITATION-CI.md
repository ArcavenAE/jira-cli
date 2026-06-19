---
document_type: story
story_id: "S-MAINT-DEAD-CITATION-CI"
title: "Add CLAUDE.md dead-citation CI guard (tests/claude_md_citations.rs + doc-fallout note)"
wave: feature-followup
status: draft
intent: feature
feature_type: infrastructure
mode: feature
scope: standard
severity: LOW
trivial_scope: false
points: 3
priority: P2
tdd_mode: strict
estimated_effort: small
estimated_days: 1.0
target_module: tests
subsystems: []
depends_on: []
blocks: []
behavioral_contracts:
  - BC-X.13.001
  - BC-X.13.002
  - BC-X.13.003
bcs:
  - BC-X.13.001
  - BC-X.13.002
  - BC-X.13.003
verification_properties:
  - VP-CITE-001
  - VP-CITE-002
holdout_anchors:
  - H-CITE-001
  - H-CITE-002
  - H-CITE-003
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/cross-cutting.md §BC-X.13"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 9
assumption_validations: []
risk_mitigations: []
created: "2026-06-19"
version: "1.0"
last_updated: "2026-06-19"
changelog:
  - "1.0 (2026-06-19): Initial draft — originated from 2026-06-19 maintenance sweep MAINT-PG-DEAD-CITATION-CI; BC-X.13.001/002/003 authored in F2 cross-cutting.md."
breaking_change: false
lineage: []
drift_items:
  - DRIFT-D13
files_created:
  - tests/claude_md_citations.rs   # NEW — citation guard + inline unit tests + proptest
files_modified:
  - CLAUDE.md                      # MODIFY — add doc-fallout note in "AI Agent Notes" section
---

# S-MAINT-DEAD-CITATION-CI — Add CLAUDE.md dead-citation CI guard

**Origin:** 2026-06-19 maintenance sweep (MAINT-PG-DEAD-CITATION-CI). Root cause: 4 dead
`.factory/research/issue-361-*.md` citations were manually removed from CLAUDE.md (DRIFT-D13);
no automated check existed to catch dead citations at CI time.

**Governing spec:** `.factory/specs/prd/cross-cutting.md §BC-X.13` (BC-X.13.001, BC-X.13.002,
BC-X.13.003). **Architecture delta:** `.factory/phase-f2-spec-evolution/arch-delta-DEAD-CITATION-CI.md`.
**Verification delta:** `.factory/phase-f2-spec-evolution/verification-delta-DEAD-CITATION-CI.md`.

---

## Narrative

As a contributor to the `jr` CLI, I want every backtick-quoted file-path citation in
CLAUDE.md to be automatically validated against the working tree on every CI run, so that
a deleted or renamed file causes an immediate CI failure rather than silently leaving a
stale reference that misleads future contributors.

---

## Behavioral Contracts

| BC | Statement |
|----|-----------|
| BC-X.13.001 | `test_claude_md_citations_resolve_to_real_files` in `tests/claude_md_citations.rs` reads CLAUDE.md via `include_str!`, extracts every in-scope backtick-quoted path token per BC-X.13.002, asserts `Path::exists()` for each, and on failure lists ALL dead paths with the canonical CI-CITE-001 message. Passes green on develop HEAD (zero dead citations). |
| BC-X.13.002 | `extract_path_citations(doc: &str) -> Vec<String>` applies the 5-step pipeline (a)–(e): (a) glob-skip; (b) merged-fixpoint normalization (6 sub-steps); (c) dir-prefix filter + ROOT_FILES curated exact-match; (d) extension filter (`.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`); (e) Path::exists() check. No false positives on any documented edge case. |
| BC-X.13.003 | ALL `.factory/` prefix paths are excluded by dir-prefix filter at step (c). `.factory/` is NOT a develop-tracked directory prefix. No allowlist function exists — exclusion is structural within `extract_path_citations`. |

---

## Acceptance Criteria

### AC-001 — `extract_path_citations` is a standalone pure function with the 5-step pipeline (traces to BC-X.13.002 postcondition: all-in-one extraction/normalization function)

`tests/claude_md_citations.rs` defines `extract_path_citations(doc: &str) -> Vec<String>` as a
standalone pure function (no `Path::exists()` calls inside). The function:

1. Extracts all inline single-backtick spans (`` `…` ``). Fenced triple-backtick blocks are
   OUT OF SCOPE (M-1, EC-CITE-016).
2. Splits each span interior on ASCII whitespace; each token is a candidate citation.
3. Applies steps (a)–(e) of BC-X.13.002 in order:
   - (a) Glob skip: skip token if it contains `*`, `{`, or `}`.
   - (b) Merged normalization fixpoint: repeat all 6 sub-steps as one unit until a complete
     pass produces no change: (1) strip trailing `::…` symbol suffix; (2) strip trailing
     `:~[0-9]+` or `:[0-9]+` line-ref suffix; (3) strip one leading `(` or `[`; (4) greedily
     trim trailing `.`, `,`, `;`, `:`; (5) trim one trailing `)` iff `count('(') < count(')')`;
     (6) trim one trailing `]` iff `count('[') < count(']')`.
   - (c) Dir-prefix filter + ROOT_FILES: keep token if it starts with a develop-tracked prefix
     (`src/`, `tests/`, `docs/`, `.github/`, `scripts/`) OR exactly equals a ROOT_FILES member
     (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`,
     `rust-toolchain.toml`). ALL `.factory/` prefixes fail this filter.
   - (d) Extension filter: token must end with `.md`, `.rs`, `.sh`, `.toml`, `.yml`, or `.yaml`.
   - (e) Path::exists(): only tokens surviving (a)–(d) are returned (step (e) is effectful and
     lives in the integration test, not inside this function).

No `is_off_working_branch_allowlisted` function exists. BC-X.13.002 step (c) is the sole
exclusion mechanism for `.factory/` and bare-shorthand tokens.

**Traceability:** BC-X.13.002 postcondition — correct (a)–(e) pipeline with no false positives.
VP-CITE-001 targets this function via unit and proptest tests.

---

### AC-002 — Integration test `test_claude_md_citations_resolve_to_real_files` passes green on develop HEAD (traces to BC-X.13.001 postcondition 1: guard is green on develop HEAD with zero dead citations)

The test:
```rust
let doc = include_str!("../CLAUDE.md");
let root = env!("CARGO_MANIFEST_DIR");
let citations = extract_path_citations(doc);
let dead: Vec<String> = citations
    .into_iter()
    .filter(|p| !Path::new(root).join(p).exists())
    .collect();
assert!(dead.is_empty(), "<canonical CI-CITE-001 message>");
```

- `include_str!("../CLAUDE.md")` embeds CLAUDE.md at compile time (no runtime file I/O for load).
- `Path::new(root).join(p)` is the only runtime I/O; Windows path-separator handling is automatic via `Path::join`.
- Passes green at the moment it is written (develop HEAD has zero dead citations as of 2026-06-19).
- The test has no `#[ignore]` gate, no env-var requirement, and makes no network calls.
- Rides the existing `test` job in `ci-gate.needs` via `cargo test --all-features` (3-OS matrix: ubuntu, macos, windows). No `ci.yml` change needed.

**Traceability:** BC-X.13.001 postcondition 1 — guard passes green on develop HEAD.
VP-CITE-002 is the self-verification property for this test.

---

### AC-003 — Failure message is CI-CITE-001 verbatim (traces to BC-X.13.001 postcondition 2: canonical failure message emitted byte-for-byte)

When the integration test fails, the `assert!` failure message MUST match the CI-CITE-001
format from `error-taxonomy.md §8` verbatim:

```
CLAUDE.md cites file paths that do not exist on disk:
  <path> (line N)
Fix the citation or restore the file.
Note: .factory/, glob, and symbol-form tokens are auto-excluded. Root-level files (Cargo.toml, CLAUDE.md, etc.) are checked.
```

- Lead line: `CLAUDE.md cites file paths that do not exist on disk:` (NOT `Dead CLAUDE.md citations:`)
- Per dead path: `  <path> (line N)` (two-space indent, then path, then ` (line N)`)
- Fix line: `Fix the citation or restore the file.`
- Note line: `Note: .factory/, glob, and symbol-form tokens are auto-excluded. Root-level files (Cargo.toml, CLAUDE.md, etc.) are checked.`

ALL dead paths are listed (not just the first).

**Traceability:** BC-X.13.001 postcondition 2 — canonical CI-CITE-001 message emitted verbatim.

---

### AC-004 — Fixture-based test confirms deterministic failure detection (traces to BC-X.13.001 postcondition 3: guard fails deterministically on a known-dead citation)

`test_dead_citation_detected_in_fixture` feeds a doc string (NOT `include_str!("../CLAUDE.md")`)
containing `src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs` and asserts:
```rust
let dead: Vec<String> = citations.into_iter().filter(|p| !Path::new(root).join(p).exists()).collect();
assert!(dead.contains(&"src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs".to_string()), ...);
```

This test verifies the guard catches dead develop-tracked citations without depending on CLAUDE.md
content. No allowlist call is made — `.factory/` exclusion is structural inside `extract_path_citations`.

**Traceability:** BC-X.13.001 postcondition 3 — deterministic failure on known-dead citation.

---

### AC-005 — ALL `.factory/` citations excluded by dir-prefix filter at step (c); no allowlist function (traces to BC-X.13.003 invariant: all `.factory/` excluded structurally, not via allowlist)

Three isolation tests confirm BC-X.13.003 holds for three distinct `.factory/` sub-paths:
- `test_factory_specs_path_excluded_by_dir_prefix`: doc `"See \`.factory/specs/prd/bc-3-issue-write.md\`."` → `extract_path_citations` returns `[]`.
- `test_factory_holdout_path_excluded_by_dir_prefix`: doc `"See \`.factory/holdout-scenarios/H-001.md\`."` → returns `[]`.
- `test_factory_research_path_excluded_by_dir_prefix`: doc `"See \`.factory/research/S-3.03-wave3-verification.md\`."` → returns `[]`.

The absence of `is_off_working_branch_allowlisted` in the final implementation is verified by
`grep` at review time: `grep -r "is_off_working_branch_allowlisted" tests/` must return zero matches.

**Traceability:** BC-X.13.003 invariant — `.factory/` excluded structurally, no allowlist.

---

### AC-006 — ROOT_FILES curated set is checked; bare-shorthand tokens are excluded (traces to BC-X.13.002 step (c) — ROOT_FILES inclusion and shorthand exclusion)

Unit tests cover the full ROOT_FILES behavior per EC-CITE-029/030/031/032:
- `test_root_file_cargo_toml_extracted`: `` `Cargo.toml` `` → IS in output.
- `test_root_file_claude_md_extracted`: `` `CLAUDE.md` `` → IS in output.
- `test_root_file_build_rs_extracted`: `` `build.rs` `` → IS in output.
- `test_root_file_deny_toml_extracted`: `` `deny.toml` `` → IS in output.
- `test_shorthand_ci_yml_excluded`: `` `ci.yml` `` → NOT in output (not a ROOT_FILES member).
- `test_shorthand_adf_rs_excluded`: `` `adf.rs` `` → NOT in output (shorthand for `src/adf.rs`).
- `test_shorthand_fields_json_excluded`: `` `fields.json` `` → NOT in output.
- `test_paren_wrapped_root_file_extracted`: `` `(Cargo.toml)` `` → fixpoint pass 1 strips parens → `Cargo.toml` → ROOT_FILES match → IS in output (EC-CITE-032). Confirms paren-unwrap (step b) runs BEFORE ROOT_FILES exact-match (step c).

**Traceability:** BC-X.13.002 step (c) condition 2 — ROOT_FILES exact-match; shorthand exclusion.
VP-CITE-001 unit test coverage.

---

### AC-007 — Merged fixpoint (step b) produces correct normalized tokens for all documented multi-pass cases (traces to BC-X.13.002 step (b) — merged fixpoint with 6 sub-steps handles paren+line-ref, line-ref+comma, and symbol+punct combos)

Unit tests for each multi-pass edge case:
- EC-CITE-026 (`(src/config.rs:~42)`): fixpoint pass 1 strips `(` and `)` around `src/config.rs:~42`; pass 2 strips `:~42` → `src/config.rs` → IS in output.
- EC-CITE-027 (`src/api/client.rs:195,`): pass 1 strips trailing `,` → `src/api/client.rs:195`; pass 2 strips `:195` → `src/api/client.rs` → IS in output.
- EC-CITE-028 (`src/foo.rs::bar().`): sub-step (1) strips `::bar().` in one pass → `src/foo.rs` → IS in output.
- EC-CITE-023 (`[docs/x.md]`): sub-step (3) strips `[`; sub-step (6) strips unbalanced `]` → `docs/x.md` → IS in output.
- EC-CITE-025 (`((src/x.rs))`): two fixpoint passes each strip one paren layer → `src/x.rs` → IS in output.

These cases confirm the "single-fixpoint" design (`F2-Iter5 merged-fixpoint`) eliminates
ordering-class false-negatives from the former separated pipeline (F-PASS6-01 fix).

**Traceability:** BC-X.13.002 step (b) — merged fixpoint handles multi-pass normalization correctly.
VP-CITE-001 unit test coverage.

---

### AC-008 — Proptest coverage of `extract_path_citations` grammar prevents false positives and panics (traces to BC-X.13.002 invariant: no false positives on arbitrary input; no panics)

A `mod proptests` block inside `tests/claude_md_citations.rs` contains:

1. `test_non_prefix_tokens_are_never_extracted`: for any string `s` matching
   `[A-Za-z0-9_:~./\*\{\}\.,;:\)\(\[\]]{1,50}`, wrapping it in backticks and calling
   `extract_path_citations` returns only paths that are either dir-prefix paths OR ROOT_FILES
   members — never `.factory/` paths or other non-develop-tracked tokens.
   The alphabet includes `*`, `{`, `}`, `:`, `~`, `,`, `.`, `;`, `(`, `)`, `[`, `]` to
   exercise all 6 sub-steps of the merged fixpoint and the glob-skip branch by random input.

2. `test_extract_never_panics`: for any string `doc` of up to 500 arbitrary Unicode chars,
   `extract_path_citations(&doc)` does not panic.

The proptest `prop_assert` must allow both dir-prefix paths AND ROOT_FILES members in output
(a randomly generated exact `Cargo.toml` string is correctly in output, not a false positive).

**Traceability:** BC-X.13.002 invariant — no false positives; no panics on arbitrary input.
VP-CITE-001 proptest coverage.

---

### AC-009 — CLAUDE.md doc-fallout note added in "AI Agent Notes" section in the SAME PR as the test file (traces to BC-X.13.001 precondition: EC-CITE-022 forward-reference constraint satisfied)

`CLAUDE.md` is modified in the SAME commit or PR as `tests/claude_md_citations.rs` to add a
doc-fallout note in the "AI Agent Notes" section. The note follows the pattern established
for `*_release_gate.rs` guards (e.g., `tests/base_url_release_gate.rs`). Format:
- References `tests/claude_md_citations.rs` by its exact develop-tracked path.
- Explains what the guard checks (backtick-quoted path citations in CLAUDE.md must resolve
  to real files on the develop branch).
- Notes that `.factory/` paths, glob patterns, and bare shorthands are auto-excluded.
- Notes that ROOT_FILES members (`Cargo.toml`, `CLAUDE.md`, etc.) ARE checked.

The forward-reference constraint (EC-CITE-022) requires: a CLAUDE.md citation of
`tests/claude_md_citations.rs` must NOT be committed before the file exists, because the
guard will catch it as a dead citation in the SAME CI run. Landing both in the same PR/commit
satisfies EC-CITE-022. Splitting them across PRs is a process error that will fail CI.

**Traceability:** BC-X.13.001 precondition — in-scope citations must reference files present
in the SAME working tree at test time. EC-CITE-022 forward-reference constraint.

---

## Holdout Scenarios

Three new holdout scenarios are authored below for Phase 4 evaluation. They are registered as
H-CITE-001, H-CITE-002, and H-CITE-003 and should be appended to `.factory/specs/prd/holdout-scenarios.md`
(incrementing `total_holdouts` from 57 to 60) in the same burst as this story.

### H-CITE-001: Citation guard catches a dead `src/` citation and emits CI-CITE-001 message (MUST-PASS)

**BC refs:** BC-X.13.001, BC-X.13.002
**Setup:** The fixture doc string `"See \`src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs\` for details."` is
passed to `extract_path_citations`. The resulting vec is filtered with `Path::new(CARGO_MANIFEST_DIR).join(p).exists()`.
**Action:** Assert the dead vec contains `"src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs"`.
**Expected:** The path IS in the dead list. The integration test would fail with the CI-CITE-001
message: `CLAUDE.md cites file paths that do not exist on disk:` / `  src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs (line N)`.
**Why hidden:** Confirms the guard correctly detects dead develop-tracked `src/` citations without
relying on CLAUDE.md's actual content; a regression in the dir-prefix filter at step (c) would make
this path invisible.

---

### H-CITE-002: Citation guard correctly ignores a `.factory/` citation (no false positive) (MUST-PASS)

**BC refs:** BC-X.13.003
**Setup:** The fixture doc string `"See \`.factory/specs/prd/cross-cutting.md\` for details."` is
passed to `extract_path_citations`.
**Action:** Assert the result is empty.
**Expected:** `extract_path_citations` returns `[]`. No false positive. The `.factory/specs/prd/`
prefix is NOT a develop-tracked directory prefix and NOT a ROOT_FILES member; step (c) excludes it.
**Why hidden:** This is the most critical false-positive vector. If `.factory/` citations were ever
flagged, every CI run on a checkout without the `factory-artifacts` branch worktree would fail.
A regression in the dir-prefix filter adding `.factory/` to the tracked set would be caught here.

---

### H-CITE-003: Citation guard correctly ignores a bare shorthand like `ci.yml` (no false positive) (MUST-PASS)

**BC refs:** BC-X.13.002 step (c) — ROOT_FILES exclusion (EC-CITE-030)
**Setup:** The fixture doc string `"See \`ci.yml\` for details."` is passed to `extract_path_citations`.
**Action:** Assert the result is empty.
**Expected:** `extract_path_citations` returns `[]`. `ci.yml` has no develop-tracked directory prefix
and does NOT exactly match any ROOT_FILES member. Step (c) excludes it. The full path
`.github/workflows/ci.yml` would be the correct citation form.
**Why hidden:** Bare-shorthand tokens like `ci.yml`, `adf.rs`, `fields.json`, `release.yml` appear
frequently in CLAUDE.md prose but are not root-level repo files. A regression that used a structural
"any .yml file" rule instead of the curated ROOT_FILES exact-match would generate spurious failures
on these shorthands.

---

## AC to BC to VP Traceability Table

| AC | BC(s) | VP | Clause |
|----|-------|-----|--------|
| AC-001 | BC-X.13.002 | VP-CITE-001 | postcondition: (a)–(e) pipeline correctly applied; no false positives |
| AC-002 | BC-X.13.001 | VP-CITE-002 | postcondition 1: guard green on develop HEAD |
| AC-003 | BC-X.13.001 | VP-CITE-002 | postcondition 2: CI-CITE-001 failure message verbatim |
| AC-004 | BC-X.13.001 | VP-CITE-002 | postcondition 3: deterministic failure on known-dead citation |
| AC-005 | BC-X.13.003 | VP-CITE-002 | invariant: ALL `.factory/` excluded structurally; no allowlist |
| AC-006 | BC-X.13.002 | VP-CITE-001 | step (c) condition 2: ROOT_FILES exact-match; shorthand exclusion |
| AC-007 | BC-X.13.002 | VP-CITE-001 | step (b): merged fixpoint multi-pass cases (EC-CITE-026/027/028) |
| AC-008 | BC-X.13.002 | VP-CITE-001 | invariant: no false positives; no panics (proptest) |
| AC-009 | BC-X.13.001 | VP-CITE-002 | precondition: EC-CITE-022 forward-reference constraint satisfied |

---

## Tasks

### T-1: Stub phase — create `tests/claude_md_citations.rs` with `todo!()` function bodies

Create `tests/claude_md_citations.rs` with:
```rust
// Stub — all function bodies are todo!()
fn extract_path_citations(doc: &str) -> Vec<String> { todo!() }

#[cfg(test)]
mod tests {
    use super::*;
    // ... test stubs with #[test] attrs but todo!() assertion bodies
}
```
Verify `cargo test tests/claude_md_citations.rs` compiles and all tests fail (Red Gate).

### T-2: Write failing unit tests for `extract_path_citations` (VP-CITE-001)

Add all unit tests listed in `verification-delta-DEAD-CITATION-CI.md §VP-CITE-001`:
- In-scope tests (develop-tracked prefixes + ROOT_FILES): AC-001 + AC-006
- Exclusion tests (glob, symbol-form, line-ref, `.factory/`, shorthand, URL, home-path, no-extension): AC-001
- Multi-pass fixpoint edge cases (EC-CITE-026/027/028/023/025): AC-007

Confirm all tests fail (Red Gate requirement; ≥0.5 density before Step 4 per TDD policy).

### T-3: Write failing integration tests (VP-CITE-002)

Add:
- `test_claude_md_citations_resolve_to_real_files` (AC-002 + AC-003): uses `include_str!("../CLAUDE.md")`.
- `test_dead_citation_detected_in_fixture` (AC-004): uses fixture doc string.
- `.factory/` exclusion tests `test_factory_*` (AC-005): three isolation tests.

### T-4: Write failing proptest block (VP-CITE-001)

Add a `mod proptests` block with `test_non_prefix_tokens_are_never_extracted` and
`test_extract_never_panics`. Add `proptest` to dev-dependencies in `Cargo.toml`
if not already present (check with `grep -A3 '\[dev-dependencies\]' Cargo.toml` first —
proptest is already a dev-dep in this repo per `src/adf.rs` usage).

### T-5: Implement `extract_path_citations` (step by step, making one test green at a time)

Implement the function in order of the (a)–(e) pipeline steps:
1. Backtick extraction (regex or manual parse — inline single-backtick only).
2. Whitespace tokenization.
3. Step (a): glob-skip.
4. Step (b): merged fixpoint (6 sub-steps in a loop until stable).
5. Step (c): dir-prefix filter + ROOT_FILES curated exact-match.
6. Step (d): extension filter.

No `Path::exists()` calls inside this function.

### T-6: Add CLAUDE.md doc-fallout note (AC-009, EC-CITE-022)

Add the doc-fallout note to the "AI Agent Notes" section of `CLAUDE.md` IN THE SAME
commit as `tests/claude_md_citations.rs`. The note must cite `tests/claude_md_citations.rs`
by its exact path so the guard validates itself. Verify the integration test still passes
after the note is added (self-referential check).

### T-7: Verify clean build

```bash
cargo build
cargo test
cargo clippy -- -D warnings
cargo fmt --all -- --check
```

All must be green. Confirm `test_claude_md_citations_resolve_to_real_files` passes (AC-002).
Confirm no new snapshot updates are needed (this story adds no snapshot tests).

---

## Previous Story Intelligence

N/A — first story in the DEAD-CITATION-CI arc. Predecessor context:

- The 2026-06-19 maintenance sweep manually removed 4 dead citations (DRIFT-D13) — that
  removal confirmed the grammar design: those citations had `.factory/research/` prefixes
  and were correctly identified by a human reviewer as requiring exclusion from the guard.
- `tests/ci_gate_completeness.rs` and `tests/backfill_matrix_parity.rs` are sister tests in
  the `*_release_gate.rs` family — use them as style reference for the test file structure,
  import organization, and assertion message formatting.
- `src/partial_match.rs` is the canonical example of a pure function with inline
  `#[cfg(test)] mod tests` — use as the model for how `extract_path_citations` is
  structured in a test file.

---

## Architecture Compliance Rules

From `arch-delta-DEAD-CITATION-CI.md`:

1. **Pure/effectful split is load-bearing (BC-8.30.001 strict TDD):**
   `extract_path_citations` MUST be a standalone pure function with zero `Path::exists()`
   calls inside. If path-extraction logic is merged into the integration test body, proptest
   cannot exercise the grammar without filesystem mocking. This split is the design constraint.

2. **No allowlist function:** There is no `is_off_working_branch_allowlisted` function.
   `.factory/` exclusion is achieved entirely by the dir-prefix filter inside
   `extract_path_citations` at step (c). Any implementation introducing an allowlist
   function contradicts BC-X.13.003 and must be rejected in review.

3. **No `ci.yml` change required:** The guard rides the existing `test` job in `ci-gate.needs`
   via `cargo test --all-features`. Adding a new entry to `ci-gate.needs` or `ci.yml` is
   explicitly prohibited for this story. Violation of this rule breaks the CLAUDE.md CI Gate
   convention.

4. **ROOT_FILES set is immutable:** The curated set `{ build.rs, Cargo.toml, CHANGELOG.md,
   CLAUDE.md, deny.toml, README.md, rust-toolchain.toml }` is enumerated in BC-X.13.002
   step (c). Adding or removing a root file requires a BC update in the SAME commit. Do NOT
   expand by structural rule.

5. **No `src/` changes:** This story makes zero changes to any `src/` module. If an
   implementation is proposed that modifies `src/`, it is out of scope.

6. **EC-CITE-022 forward-reference constraint:** CLAUDE.md note and `tests/claude_md_citations.rs`
   MUST land in the SAME PR. Split delivery will fail CI on the PR that adds only the CLAUDE.md
   note (the guard will catch its own forward-reference as a dead citation).

---

## Library & Framework Requirements

| Crate | Version source | Usage |
|-------|----------------|-------|
| `proptest` | existing dev-dep (already used by `src/adf.rs`, `src/partial_match.rs`) | `test_non_prefix_tokens_are_never_extracted`, `test_extract_never_panics` |
| `std::path::Path` | stdlib | `Path::new(root).join(p).exists()` in integration test only |

Verify proptest is already a dev-dependency:
```bash
grep -A3 '\[dev-dependencies\]' Cargo.toml | grep proptest
```

Do NOT add any new `Cargo.toml` dependencies. If proptest is confirmed absent (unlikely),
add it at the version already used in the codebase. No other new dependencies.

---

## File Structure Requirements

### Files to CREATE

| File | Purpose |
|------|---------|
| `tests/claude_md_citations.rs` | Citation guard: `extract_path_citations` pure fn + inline unit tests + proptest block + integration tests |

### Files to MODIFY

| File | Change |
|------|--------|
| `CLAUDE.md` | Add doc-fallout note in "AI Agent Notes" section documenting `tests/claude_md_citations.rs`; must land in SAME commit as test file (EC-CITE-022) |

### Files explicitly NOT modified

- Any `src/` file — zero production code changes
- `.github/workflows/ci.yml` — no CI YAML changes needed
- Any other `tests/*.rs` file — no modifications
- Any `docs/` file — no documentation changes except the CLAUDE.md note
- Any `scripts/` file — no new bash scripts

---

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-CITE-001 | BC-X.13.001 | CLAUDE.md has zero in-scope citations | Test passes (empty `dead` vec); empty `assert` vacuously passes |
| EC-CITE-016 (M-1) | BC-X.13.001 | Token inside a fenced triple-backtick code block (e.g., the architecture tree) | NOT extracted; only inline single-backtick spans are processed |
| EC-CITE-017 | BC-X.13.003 | `.factory/research/S-3.03-wave3-verification.md` | `.factory/` prefix → excluded at step (c) → no failure |
| EC-CITE-022 | BC-X.13.001 | CLAUDE.md cites `tests/claude_md_citations.rs` before the file exists | Guard fails CI with dead-citation error; fix: land both in same PR |
| EC-CITE-026 | BC-X.13.002 | `(src/config.rs:~42)` — paren-wrap + line-ref | Fixpoint: pass 1 strips `(` and `)`, pass 2 strips `:~42` → `src/config.rs` → IS in output |
| EC-CITE-027 | BC-X.13.002 | `src/api/client.rs:195,` — line-ref + comma | Fixpoint: pass 1 strips `,`, pass 2 strips `:195` → `src/api/client.rs` → IS in output |
| EC-CITE-028 | BC-X.13.002 | `src/foo.rs::bar().` — symbol+punct combo | Sub-step (1) strips `::bar().` in one pass → `src/foo.rs` → IS in output |
| EC-CITE-029 | BC-X.13.002 | `Cargo.toml` | No dir prefix; exactly matches ROOT_FILES → IS in output; `.toml` passes extension filter |
| EC-CITE-030 | BC-X.13.002 | `ci.yml` | No dir prefix; NOT in ROOT_FILES → EXCLUDED; no false positive |
| EC-CITE-031 | BC-X.13.002 | `adf.rs` | No dir prefix; NOT in ROOT_FILES (shorthand for `src/adf.rs`) → EXCLUDED |
| EC-CITE-032 | BC-X.13.002 | `(Cargo.toml)` — paren-wrap + ROOT_FILES | Fixpoint strips parens → `Cargo.toml` → ROOT_FILES match → IS in output |

---

## Estimated Complexity

**3 story points.** The implementation is a single new test file (`tests/claude_md_citations.rs`)
plus a CLAUDE.md doc-fallout note. The primary complexity is the merged-fixpoint normalization
logic in `extract_path_citations` (6 sub-steps in a loop), which must handle all edge cases
without false positives. The implementation is pure Rust string manipulation with no FFI,
no async, no new modules in `src/`. Proptest setup is straightforward (crate already in dev-deps).
The guard is self-validating from day 1 (green on develop HEAD) so no fixture scaffolding is
needed beyond the fixture-based deterministic-failure test.

**Token budget estimate:**

| Component | Estimated tokens |
|-----------|----------------|
| Story spec (this file) | ~5,500 |
| `tests/claude_md_citations.rs` (write) | ~3,000 |
| `CLAUDE.md` (read for "AI Agent Notes" insertion point) | ~8,000 |
| `arch-delta-DEAD-CITATION-CI.md` (reference during implementation) | ~3,000 |
| `verification-delta-DEAD-CITATION-CI.md` (reference for test strategy) | ~4,000 |
| Cargo.toml (dev-dep check) | ~500 |
| `tests/ci_gate_completeness.rs` (style reference, read) | ~1,000 |
| cargo test / clippy output | ~1,000 |
| **Total estimate** | **~26,000** |

Well within a single agent context window. No story split required.

---

## Out of Scope

- Any `src/` changes — zero production code changes
- Any `.github/workflows/ci.yml` changes — guard rides existing `test` job
- An `is_off_working_branch_allowlisted` function — `.factory/` exclusion is structural
- Expansion of ROOT_FILES by structural rule — curated exact-match only
- Checking `.factory/` citations against the `factory-artifacts` branch worktree — handled by maintenance doc-drift sweep
- Proptest alphabet extensions beyond what is needed for F4 (F6 may extend per `verification-delta-DEAD-CITATION-CI.md §F6 Handoff Checklist`)
- Mutation testing (`cargo mutants`) — F6 (Targeted Hardening) scope
