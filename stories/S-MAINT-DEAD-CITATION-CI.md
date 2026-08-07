---
document_type: story
story_id: "S-MAINT-DEAD-CITATION-CI"
title: "Add CLAUDE.md dead-citation CI guard (tests/claude_md_citations.rs + doc-fallout note)"
wave: feature-followup
status: delivered
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
acceptance_criteria_count: 12
assumption_validations: []
risk_mitigations: []
created: "2026-06-19"
version: "1.2"
last_updated: "2026-08-07"
changelog:
  - "1.0 (2026-06-19): Initial draft — originated from 2026-06-19 maintenance sweep MAINT-PG-DEAD-CITATION-CI; BC-X.13.001/002/003 authored in F2 cross-cutting.md."
  - "1.1 (2026-06-19): F3 adversarial + consistency pass — AC-010 (multi-dead-path fixture, F-2 HIGH), AC-011 (extension-filter negatives, F-3 MED), AC-012 (EC-CITE-002 comma + EC-CITE-003 CRLF, F-4 MED); AC-005 grep-as-test replaced by behavioral isolation tests only (F-5 MED); OBS-001 holdout prose 57→60."
  - "1.2 (2026-08-07, class-level correction sweep): status corrected draft→delivered.
     `tests/claude_md_citations.rs` ships at develop HEAD (introduced by PR #544, hardened
     by PR #545 and PR #661) and CLAUDE.md's 'AI Agent Notes' section carries the
     `tests/claude_md_citations.rs` doc-fallout note per AC-009 — verified directly
     (`git log --oneline -- tests/claude_md_citations.rs` on `origin/develop` shows all
     three commits; the file is present in the working tree). Status convention matched to
     this repo's closest sibling story, `S-BC-CITATION-GUARD-1.md` (another shipped
     CI-citation-guard story), which uses `status: delivered`. **Flagged, not fixed (out of
     scope for this correction pass):** this story predates the current story template and
     is missing several now-mandatory frontmatter keys (`cycle`, `epic_id`, `input-hash`,
     `inputs`, `level`, `phase`, `producer`, `timestamp`, `traces_to`) and sections
     (Architecture Mapping, Purity Classification, Token Budget Estimate is present but the
     validator additionally expects the other two) — a `validate-template-compliance` guard
     flagged this on save. This is pre-existing template drift unrelated to the stale-status
     defect this pass was scoped to fix; a full `/vsdd-factory:conform-to-template` pass is
     a separate, larger task and was not attempted here."
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
| BC-X.13.002 | `extract_path_citations(doc: &str) -> Vec<(String, usize)>` applies the 5-step pipeline (a)–(e): (a) glob-skip; (b) merged-fixpoint normalization (6 sub-steps); (c) dir-prefix filter + ROOT_FILES curated exact-match; (d) extension filter (`.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`); (e) Path::exists() check. Each entry is `(normalized_path, 1-based-line-number)`. No false positives on any documented edge case. |
| BC-X.13.003 | ALL `.factory/` prefix paths are excluded by dir-prefix filter at step (c). `.factory/` is NOT a develop-tracked directory prefix. No allowlist function exists — exclusion is structural within `extract_path_citations`. |

---

## Acceptance Criteria

### AC-001 — `extract_path_citations` is a standalone pure function with the 5-step pipeline returning `(path, line)` pairs (traces to BC-X.13.002 postcondition: all-in-one extraction/normalization function with line provenance)

`tests/claude_md_citations.rs` defines `extract_path_citations(doc: &str) -> Vec<(String, usize)>` as a
standalone pure function (no `Path::exists()` calls inside). Each returned entry is a
`(normalized_path, 1-based-line-number)` pair where `line_number` is the 1-based line in
`doc` where the backtick citation token appears — computed by counting newlines up to the
token start. Line tracking is deterministic and requires no I/O. The function:

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

Unit tests that assert over the returned vec MUST destructure the tuples: `for (path, line) in &result { … }`.
Tests asserting on path values compare against the `String` component; tests asserting line numbers
compare against the `usize` component.

**Traceability:** BC-X.13.002 postcondition — correct (a)–(e) pipeline, `Vec<(String, usize)>` return type, no false positives.
VP-CITE-001 targets this function via unit and proptest tests.

---

### AC-002 — Integration test `test_claude_md_citations_resolve_to_real_files` passes green on develop HEAD (traces to BC-X.13.001 postcondition 1: guard is green on develop HEAD with zero dead citations)

The test:
```rust
let doc = include_str!("../CLAUDE.md");
let root = env!("CARGO_MANIFEST_DIR");
// extract_path_citations returns Vec<(String, usize)> — (normalized_path, 1-based line)
let citations = extract_path_citations(doc);
let dead: Vec<(String, usize)> = citations
    .into_iter()
    .filter(|(p, _)| !Path::new(root).join(p).exists())
    .collect();
assert!(dead.is_empty(), "<canonical CI-CITE-001 message with real line numbers>");
```

- `include_str!("../CLAUDE.md")` embeds CLAUDE.md at compile time (no runtime file I/O for load).
- `Path::new(root).join(p)` is the only runtime I/O; Windows path-separator handling is automatic via `Path::join`.
- Passes green at the moment it is written (develop HEAD has zero dead citations as of 2026-06-19).
- The test has no `#[ignore]` gate, no env-var requirement, and makes no network calls.
- Rides the existing `test` job in `ci-gate.needs` via `cargo test --all-features` (3-OS matrix: ubuntu, macos, windows). No `ci.yml` change needed.

**Traceability:** BC-X.13.001 postcondition 1 — guard passes green on develop HEAD.
VP-CITE-002 is the self-verification property for this test.

---

### AC-003 — Failure message is CI-CITE-001 verbatim with real line numbers (traces to BC-X.13.001 postcondition 2: canonical failure message emitted byte-for-byte)

When the integration test fails, the `assert!` failure message MUST match the CI-CITE-001
format from `error-taxonomy.md §8` verbatim. The per-path lines use the REAL 1-based line
number from the `(path, line)` tuples returned by `extract_path_citations`. Example output:

```
CLAUDE.md cites file paths that do not exist on disk:
  src/foo.rs (line 142)
  tests/bar.rs (line 287)
Fix the citation or restore the file.
Note: .factory/, glob, and symbol-form tokens are auto-excluded. Root-level files (Cargo.toml, CLAUDE.md, etc.) are checked.
```

The implementation format string (within `assert!`):
```rust
dead.iter().map(|(p, n)| format!("{} (line {})", p, n)).collect::<Vec<_>>().join("\n  ")
```

- Lead line: `CLAUDE.md cites file paths that do not exist on disk:` (NOT `Dead CLAUDE.md citations:`)
- Per dead path: `  <path> (line {n})` (two-space indent, then path, then ` (line {n})` where `{n}` is the actual integer from the `usize` component of the tuple — e.g. `  src/foo.rs (line 142)`)
- Fix line: `Fix the citation or restore the file.`
- Note line: `Note: .factory/, glob, and symbol-form tokens are auto-excluded. Root-level files (Cargo.toml, CLAUDE.md, etc.) are checked.`

The literal text `(line N)` MUST NOT appear in actual test output — `N` is a placeholder only
in this spec document. The running test emits an integer (e.g. `142`).

ALL dead paths are listed (not just the first).

**Traceability:** BC-X.13.001 postcondition 2 — canonical CI-CITE-001 message emitted verbatim with real line numbers.
AC-001 (signature) is a prerequisite: line numbers are only available because `extract_path_citations` returns `Vec<(String, usize)>`.

---

### AC-004 — Fixture-based test confirms deterministic failure detection (traces to BC-X.13.001 postcondition 3: guard fails deterministically on a known-dead citation)

`test_dead_citation_detected_in_fixture` feeds a doc string (NOT `include_str!("../CLAUDE.md")`)
containing `src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs` and asserts:
```rust
// citations: Vec<(String, usize)>
let dead: Vec<(String, usize)> = citations.into_iter().filter(|(p, _)| !Path::new(root).join(p).exists()).collect();
assert!(dead.iter().any(|(p, _)| p == "src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs"), ...);
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

These three tests ARE the AC — they verify the observable behavioral contract that `.factory/`
citations produce empty output from `extract_path_citations`. The structural absence of
`is_off_working_branch_allowlisted` is an architecture compliance rule (see § Architecture
Compliance Rules rule 2), not an acceptance criterion. Reviewers may verify the structural
rule via grep, but that verification is out-of-scope for TDD test coverage.

**Traceability:** BC-X.13.003 invariant — `.factory/` excluded structurally, no allowlist.
VP-CITE-001 unit test coverage (three isolation tests).

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

### AC-010 — Multi-dead-path fixture with TWO distinct dead citations asserts both appear in document order with correct line numbers and indentation (traces to BC-X.13.001 postcondition 2: ALL dead paths listed; `.join("\n  ")` structure correct)

`test_two_dead_citations_both_listed` feeds a fixture doc string (NOT `include_str!("../CLAUDE.md")`)
that contains exactly two dead citations on different lines. Example fixture:

```rust
let doc = "See `src/DOES_NOT_EXIST_ONE.rs` for details.\nAnd also `src/DOES_NOT_EXIST_TWO.rs`.\n";
```

The test asserts ALL of the following:
1. `extract_path_citations(doc)` returns exactly two entries — one per dead citation.
2. The entries are in document order: the citation on line 1 appears before the citation
   on line 2 in the returned vec.
3. After filtering by `!Path::new(root).join(p).exists()`, both paths are dead.
4. The rendered message (built via
   `dead.iter().map(|(p, n)| format!("{} (line {})", p, n)).collect::<Vec<_>>().join("\n  ")`)
   produces a string of the form:
   ```
   src/DOES_NOT_EXIST_ONE.rs (line 1)\n  src/DOES_NOT_EXIST_TWO.rs (line 2)
   ```
   i.e., the two entries are joined by `"\n  "` (newline + two spaces), not `"\n"` alone.
5. Each `(line N)` component is the actual integer from the `usize` component of the tuple —
   e.g. `"(line 1)"` for a citation on line 1 of the fixture, not the literal `"(line N)"`.

This pins the `.join("\n  ")` join structure and the "ALL dead paths listed" postcondition
(not just first), and confirms line provenance is tracked independently per citation token.

**Traceability:** BC-X.13.001 postcondition 2 — ALL dead paths listed with correct indentation
and real line numbers. AC-001 (signature) and AC-003 (format string) are prerequisites.
VP-CITE-002 integration test coverage.

---

### AC-011 — Extensionless in-scope tokens and `.lock`-extension tokens are excluded by the extension filter at step (d) (traces to BC-X.13.002 step (d): extension filter is the operative guard)

Two negative-filter unit tests:
- `test_extension_filter_excludes_extensionless_token`: doc `"See \`src/cli/issue\`."` →
  `extract_path_citations` returns `[]`. Token `src/cli/issue` passes steps (a)–(c) (has
  `src/` prefix; no glob; normalization stable) but has no file extension → EXCLUDED at
  step (d). This confirms the extension filter is active even for otherwise valid dir-prefix tokens.
- `test_extension_filter_excludes_lock_extension`: doc `"See \`Cargo.lock\`."` →
  `extract_path_citations` returns `[]`. Token `Cargo.lock` has `.lock` extension which is NOT
  in the recognized set (`.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`). Even if `Cargo.lock`
  were in ROOT_FILES (it is not), `.lock` would be excluded at step (d). Confirmed excluded.

Both tests assert the returned vec is empty (`assert!(result.is_empty(), …)`).

**Traceability:** BC-X.13.002 step (d) — extension filter (`.md`, `.rs`, `.sh`, `.toml`, `.yml`,
`.yaml`); extensionless and `.lock` tokens excluded even when dir-prefix passes step (c).
VP-CITE-001 unit test coverage.

---

### AC-012 — EC-CITE-002 comma-delimited form and EC-CITE-003 CRLF line endings are handled without false positives (traces to BC-X.13.002 step (b) sub-step (4): trailing comma trimmed; BC-X.13.001 postcondition: no false positive on Windows matrix)

Two unit tests covering platform and delimiter edge cases:

**EC-CITE-002 (comma-delimited `Detail:` form):**
`test_comma_delimited_both_tokens_extracted`: doc
`"Detail: \`src/adf.rs, src/partial_match.rs\`."` → `extract_path_citations` returns
both `"src/adf.rs"` (trailing comma stripped by sub-step (4)) and `"src/partial_match.rs"`
(trailing period from outer sentence also stripped). The interior comma is treated as a
whitespace-tokenization boundary after backtick-span extraction; each resulting token then
goes through the (a)–(e) pipeline independently. Both tokens survive to step (e) (they
exist on disk) and are returned. The test asserts
`result.iter().any(|(p, _)| p == "src/adf.rs") && result.iter().any(|(p, _)| p == "src/partial_match.rs")`.

**EC-CITE-003 (CRLF line endings, Windows matrix):**
`test_crlf_line_endings_no_false_positive`: doc with a CRLF-terminated citation line:
`"See \`src/adf.rs\`.\r\nAnd next line.\r\n"` → `extract_path_citations` returns an entry
for `"src/adf.rs"` (which exists on disk). The `\r` from the CRLF ending is stripped before
or during tokenization (`trim_end_matches('\r')` or equivalent — consistent with `lines()`
splitting on `\n` leaving a trailing `\r` on Windows-format input). No false positive:
the returned path is `"src/adf.rs"`, NOT `"src/adf.rs\r"` (which would fail `Path::exists()`
on any OS). Test asserts `result.iter().any(|(p, _)| p == "src/adf.rs")` and that no returned
path string contains a `\r` character.

This AC is load-bearing for the Windows CI matrix leg (AC-002 runs on the windows runner);
CRLF normalization must be verified so `\r`-contaminated tokens do not cause spurious failures
on Windows checkouts.

**Traceability:** BC-X.13.002 step (b) sub-step (4) — trailing-punct trim (comma); BC-X.13.001
postcondition — no false positive on any CI matrix leg. EC-CITE-002 + EC-CITE-003.
VP-CITE-001 unit test coverage.

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
message: `CLAUDE.md cites file paths that do not exist on disk:` / `  src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs (line {n})`
where `{n}` is the actual 1-based line number in the fixture doc string where the citation appears
(not a literal `N`). The holdout evaluator may use `assert!(msg.contains("src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs (line "))` to verify the real-number format without pinning the exact line.
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
| AC-001 | BC-X.13.002 | VP-CITE-001 | postcondition: (a)–(e) pipeline correctly applied; returns `Vec<(String, usize)>`; no false positives |
| AC-002 | BC-X.13.001 | VP-CITE-002 | postcondition 1: guard green on develop HEAD |
| AC-003 | BC-X.13.001 | VP-CITE-002 | postcondition 2: CI-CITE-001 failure message verbatim with real 1-based line numbers |
| AC-004 | BC-X.13.001 | VP-CITE-002 | postcondition 3: deterministic failure on known-dead citation |
| AC-005 | BC-X.13.003 | VP-CITE-001 | invariant: ALL `.factory/` excluded structurally; no allowlist (three behavioral isolation tests) |
| AC-006 | BC-X.13.002 | VP-CITE-001 | step (c) condition 2: ROOT_FILES exact-match; shorthand exclusion |
| AC-007 | BC-X.13.002 | VP-CITE-001 | step (b): merged fixpoint multi-pass cases (EC-CITE-026/027/028) |
| AC-008 | BC-X.13.002 | VP-CITE-001 | invariant: no false positives; no panics (proptest) |
| AC-009 | BC-X.13.001 | VP-CITE-002 | precondition: EC-CITE-022 forward-reference constraint satisfied |
| AC-010 | BC-X.13.001 | VP-CITE-002 | postcondition 2: TWO dead paths both listed in document order with correct `\n  ` join and real line numbers (F-2 HIGH) |
| AC-011 | BC-X.13.002 | VP-CITE-001 | step (d): extension filter — extensionless `src/cli/issue` and `.lock`-extension `Cargo.lock` both excluded (F-3 MED) |
| AC-012 | BC-X.13.002, BC-X.13.001 | VP-CITE-001 | step (b) sub-step (4): comma-delimited form (EC-CITE-002); step (b) CRLF normalization (EC-CITE-003) — no false positive on Windows matrix (F-4 MED) |

---

## Tasks

### T-1: Stub phase — create `tests/claude_md_citations.rs` with `todo!()` function bodies

Create `tests/claude_md_citations.rs` with:
```rust
// Stub — all function bodies are todo!()
// Returns (normalized_path, 1-based-line-number) pairs
fn extract_path_citations(doc: &str) -> Vec<(String, usize)> { todo!() }

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
- Exclusion tests (glob, symbol-form, line-ref, `.factory/`, shorthand, URL, home-path, no-extension): AC-001 + AC-005
- Multi-pass fixpoint edge cases (EC-CITE-026/027/028/023/025): AC-007
- Extension filter negatives — extensionless and `.lock` extension: AC-011
- Comma-delimited form (EC-CITE-002) and CRLF normalization (EC-CITE-003): AC-012

Confirm all tests fail (Red Gate requirement; ≥0.5 density before Step 4 per TDD policy).

### T-3: Write failing integration tests (VP-CITE-002)

Add:
- `test_claude_md_citations_resolve_to_real_files` (AC-002 + AC-003): uses `include_str!("../CLAUDE.md")`.
- `test_dead_citation_detected_in_fixture` (AC-004): uses fixture doc string.
- `test_two_dead_citations_both_listed` (AC-010): fixture doc with TWO distinct dead citations on different lines; asserts both listed, document order, correct `\n  ` join, real line numbers.
- `.factory/` exclusion tests `test_factory_*` (AC-005): three isolation tests.

### T-4: Write failing proptest block (VP-CITE-001)

Add a `mod proptests` block with `test_non_prefix_tokens_are_never_extracted` and
`test_extract_never_panics`. Add `proptest` to dev-dependencies in `Cargo.toml`
if not already present (check with `grep -A3 '\[dev-dependencies\]' Cargo.toml` first —
proptest is already a dev-dep in this repo per `src/adf.rs` usage).

### T-5: Implement `extract_path_citations` (step by step, making one test green at a time)

Implement the function `extract_path_citations(doc: &str) -> Vec<(String, usize)>` in
order of the (a)–(e) pipeline steps:
1. Backtick extraction (regex or manual parse — inline single-backtick only).
   Record the 1-based line number of each token start by counting newlines up to the
   token's byte offset in `doc`. This is the line provenance carried in the `usize`
   component of the returned tuples.
2. Whitespace tokenization (each token inherits the line number of the backtick span
   it came from — if a span spans multiple lines, tokens after the first newline take
   the line of the token start within the span, not the span start; simplest correct
   implementation: record line of the backtick-open character).
3. Step (a): glob-skip.
4. Step (b): merged fixpoint (6 sub-steps in a loop until stable).
5. Step (c): dir-prefix filter + ROOT_FILES curated exact-match.
6. Step (d): extension filter.
7. Return surviving `(normalized_path, line_number)` pairs.

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
| EC-CITE-002 | BC-X.13.002 | `Detail: path1, path2` comma-delimited form | Both tokens extracted; trailing comma stripped by sub-step (4); both checked independently (AC-012) |
| EC-CITE-003 | BC-X.13.002 | CRLF `\r\n` line endings (Windows checkout) | `\r` stripped before/during tokenization; no `\r`-contaminated path; no false positive (AC-012) |
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
| EC-CITE-033 | BC-X.13.002 | `src/cli/issue` — extensionless dir-prefix token | Has `src/` prefix (passes step c) but no recognized extension → EXCLUDED at step (d) (AC-011) |
| EC-CITE-034 | BC-X.13.002 | `Cargo.lock` — `.lock` extension not in recognized set | Not a ROOT_FILES member; `.lock` not in extension set → EXCLUDED at step (d) (AC-011) |

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
| Story spec (this file) | ~8,000 |
| `tests/claude_md_citations.rs` (write) | ~4,000 |
| `CLAUDE.md` (read for "AI Agent Notes" insertion point) | ~8,000 |
| `arch-delta-DEAD-CITATION-CI.md` (reference during implementation) | ~3,000 |
| `verification-delta-DEAD-CITATION-CI.md` (reference for test strategy) | ~4,000 |
| Cargo.toml (dev-dep check) | ~500 |
| `tests/ci_gate_completeness.rs` (style reference, read) | ~1,000 |
| cargo test / clippy output | ~1,000 |
| **Total estimate** | **~29,500** |

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
