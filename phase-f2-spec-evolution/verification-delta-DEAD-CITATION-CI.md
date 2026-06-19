---
document_type: verification-delta
bundle: DEAD-CITATION-CI
title: "Verification properties for CLAUDE.md dead-citation CI guard"
date: "2026-06-19"
phase: F2
new_vps:
  - VP-CITE-001
  - VP-CITE-002
related_bcs:
  - BC-X.13.001
  - BC-X.13.002
  - BC-X.13.003
---

# Verification Delta — DEAD-CITATION-CI: Citation Guard Verification Properties

## New Verification Properties

### VP-CITE-001: `extract_path_citations` grammar — in-scope detection and all normalization/exclusion rules (glob-skip, symbol-form, line-ref, trailing-punct, dir-prefix, extension), no false positives

**Description**: The `extract_path_citations(doc: &str) -> Vec<String>` function in
`tests/claude_md_citations.rs` must correctly identify path tokens from arbitrary
document strings and correctly reject all non-path tokens (symbols, URLs, BC IDs,
ADR shorthands, glob patterns, type names, env-var names, bare words, `.factory/`
paths). This VP covers the pure-function grammar, which is independently testable
without any filesystem access.

**Applies to**:
- BC-X.13.001: in-scope token identification (directory prefix + extension filter)
- BC-X.13.002: canonical normalization/skip pipeline (steps a–e, merged-fixpoint revision F2-Iter5)

**Purity boundary**: `extract_path_citations` MUST be a standalone pure function
(no `Path::exists()` calls inside). This is a design constraint from
`arch-delta-DEAD-CITATION-CI.md` §2 — the pure/effectful split is load-bearing for
proptest coverage. If the grammar logic is inlined into the integration test body,
VP-CITE-001 tests cannot be written without filesystem mocking. F4 must extract this
function before writing tests.

**Test placement**: Inline `#[cfg(test)] mod tests` block inside
`tests/claude_md_citations.rs`, following the project convention for pure helpers
in test files (mirrors `src/partial_match.rs` and `src/jql.rs` inline test blocks).

**Test strategy — in-scope detection (BC-X.13.001 positive cases)**:

1. Call `extract_path_citations` with a doc string containing several in-scope tokens.
2. Assert each of the following token types IS extracted (develop-tracked prefixes only):
   - Plain file reference: `` `src/adf.rs` ``
   - Nested path: `` `tests/auth_profiles.rs` ``
   - Docs path: `` `docs/adr/0016-windows-build-target.md` ``
   - Scripts path: `` `scripts/check-spec-counts.sh` ``
   - GitHub workflow path: `` `.github/workflows/ci.yml` ``

   NOTE: `.factory/` paths are EXCLUDED by dir-prefix filter — they are NOT in-scope
   positive cases. `` `.factory/research/S-3.03-wave3-verification.md` `` MUST NOT
   appear in the extracted list (see exclusion table row below).

**Test strategy — exclusion rules (BC-X.13.002 negative cases)**:

For each exclusion/normalization rule in the canonical pipeline, assert the token is
NOT present in the extracted list (or is normalized to the base path, as appropriate):

| Step | Input token | Expected behavior |
|------|-------------|------------------|
| (a) Glob skip — `*` | `` `src/cli/bc-*.md` `` | Skipped entirely — NOT in output |
| (a) Glob skip — `{` `}` | `` `adf-{block,task}-list.md` `` | Skipped entirely — NOT in output |
| (b) fixpoint sub-step (1) symbol-form strip | `` `src/adf.rs::push_text` `` | Normalized to `src/adf.rs` — IS in output as `src/adf.rs` |
| (b) fixpoint sub-step (1) symbol-form strip — no dir prefix | `` `adf::tests::test_bare_url_split` `` | Has `::` but no known dir prefix before `::` — NOT in output (excluded by dir-prefix filter at step c) |
| (b) fixpoint sub-step (2) line-ref strip tilde | `` `src/config.rs:~42` `` | Normalized to `src/config.rs` — IS in output as `src/config.rs` |
| (b) fixpoint sub-step (2) line-ref strip bare | `` `src/config.rs:100` `` | Normalized to `src/config.rs` — IS in output as `src/config.rs` |
| (b) fixpoint sub-step (4) trailing-punct trim | `` `src/adf.rs,` `` | Trailing comma trimmed → `src/adf.rs` — IS in output |
| (b) fixpoint sub-steps (3)+(5) leading/trailing paren | `` `(src/adf.rs)` `` | Leading `(` stripped; trailing `)` unbalanced → trimmed → `src/adf.rs` — IS in output |
| (b) fixpoint sub-steps (3)+(6) leading/trailing bracket (LOW-1) | `` `[docs/x.md]` `` | Leading `[` stripped; trailing `]` unbalanced → trimmed → `docs/x.md` — CHECKED (IS in output) |
| (b) fixpoint multi-pass (LOW-2) | `` `(src/adf.rs).` `` | Outer `(…)` pair stripped iteratively, trailing `.` trimmed → `src/adf.rs` — IS in output |
| (b) fixpoint multi-pass (LOW-3) | `` `((src/x.rs))` `` | Two nested `(…)` pairs stripped iteratively → `src/x.rs` — IS in output |
| (b) fixpoint multi-pass paren+line-ref (F-PASS6-01) | `` `(src/config.rs:~42)` `` | Pass 1: sub-steps (3)+(5) strip parens → `src/config.rs:~42`; pass 2: sub-step (2) strips `:~42` → `src/config.rs` — IS in output (NEW) |
| (b) fixpoint multi-pass line-ref+comma (EC-CITE-027) | `` `src/api/client.rs:195,` `` | Pass 1: sub-step (4) strips `,` → `src/api/client.rs:195`; pass 2: sub-step (2) strips `:195` → `src/api/client.rs` — IS in output (NEW) |
| (b) fixpoint sub-step (1) symbol+punct combo (EC-CITE-028) | `` `src/foo.rs::bar().` `` | Sub-step (1) strips `::bar().` → `src/foo.rs` in one pass — IS in output (NEW) |
| (c) dir-prefix filter — section ref | `` `docs/specs/e2e-live-jira-testing.md §9` `` | `§9` excluded by dir-prefix filter (no known prefix); `docs/specs/e2e-live-jira-testing.md` IS in output |
| (d) extension filter | `` `src/cli/issue` `` | No recognized extension — NOT in output |
| (c) dir-prefix filter — URL | `` `http://127.0.0.1:53682/callback` `` | Not starting with known dir prefix — NOT in output |
| (c) dir-prefix filter — home path | `` `~/.config/jr/config.toml` `` | Not starting with known dir prefix — NOT in output |
| (c) dir-prefix filter — no slash | `` `JR_BASE_URL` `` | No `/` — NOT in output |
| (c) dir-prefix filter — type name | `` `std::sync::Mutex` `` | Has `::` but no known dir prefix — NOT in output |
| (c) dir-prefix filter — `.factory/` | `` `.factory/research/S-3.03-wave3-verification.md` `` | `.factory/` NOT in develop-tracked prefix set — NOT in output |

**Proptest strategy (BC-X.13.002 — no false positives)**:

Property: For any string `s` that does NOT start with a known directory prefix
(`src/`, `tests/`, `docs/`, `.github/`, `scripts/`), wrapping it in backticks and
passing it to `extract_path_citations` returns an empty vec (or a vec whose entries
all start with a known develop-tracked prefix). The alphabet deliberately includes
`*`, `{`, `}`, trailing-punct chars (`,`, `.`, `;`, `:`, `)`), and leading-punct
chars `(`, `[`, and `]` so that the glob-skip branch (step a), trailing-punct-trim
branch (step e), leading-punct-strip branch (step e), and `]` balance-trim branch
(step e) are all exercised by random inputs — not merely by hand-crafted unit vectors
— which reduces mutation survival risk in F6.

```rust
proptest! {
    #[test]
    fn test_non_prefix_tokens_are_never_extracted(
        s in "[A-Za-z0-9_:~./\\*\\{\\}\\.,;:\\)\\(\\[\\]]{1,50}"
    ) {
        let non_prefix = format!("`{}`", s);
        let result = extract_path_citations(&non_prefix);
        // Either empty, or any returned path starts with a known develop-tracked prefix
        for path in &result {
            prop_assert!(
                path.starts_with("src/")
                    || path.starts_with("tests/")
                    || path.starts_with("docs/")
                    || path.starts_with(".github/")
                    || path.starts_with("scripts/"),
                "Non-prefix token leaked into output: {}",
                path
            );
        }
    }

    #[test]
    fn test_extract_never_panics(doc in "\\PC{0,500}") {
        let _ = extract_path_citations(&doc);
    }
}
```

Note: `.factory/` is intentionally ABSENT from the `starts_with` allowlist in the
prop_assert — a token starting with `.factory/` MUST NOT appear in the output (it is
excluded by dir-prefix filter at step f). If the proptest engine generates an `s`
that starts with `.factory/`, the assertion correctly catches any regression where
`.factory/` leaks into the output.

**Suggested test names** (unit):
- `test_in_scope_src_path_extracted`
- `test_in_scope_tests_path_extracted`
- `test_in_scope_docs_path_extracted`
- `test_in_scope_scripts_path_extracted`
- `test_in_scope_github_workflow_path_extracted`
- `test_glob_star_pattern_skipped`
- `test_glob_brace_pattern_skipped`
- `test_symbol_form_stripped_to_file`
- `test_symbol_form_no_dir_prefix_excluded`
- `test_line_ref_tilde_stripped_to_file`
- `test_line_ref_bare_stripped_to_file`
- `test_trailing_punct_comma_trimmed`
- `test_section_ref_doc_path_extracted_section_excluded`
- `test_no_extension_excluded`
- `test_url_in_backticks_excluded`
- `test_home_path_excluded`
- `test_env_var_excluded`
- `test_type_name_excluded`
- `test_factory_prefix_excluded_by_dir_filter`

**Suggested test names** (proptest, in `mod proptests` block):
- `test_non_prefix_tokens_are_never_extracted`
- `test_extract_never_panics`

---

### VP-CITE-002: Integration self-verification — guard is green on develop HEAD; fails deterministically on dead citation with canonical CI-CITE-001 message

**Description**: The `test_claude_md_citations_resolve_to_real_files` integration
test in `tests/claude_md_citations.rs` must:
1. Pass green (`exit 0`) on the current `develop` HEAD (zero dead citations)
2. Fail deterministically (`panics` with the dead path listed) when a known-dead
   citation is present in the CLAUDE.md text being checked
3. Emit the CANONICAL failure message from error-taxonomy CI-CITE-001 (verbatim —
   byte-for-byte match required; no divergent wording)

This VP has a self-verifying structure: because CLAUDE.md currently has zero dead
citations, the integration test is green from the moment it is written. The test
will only ever fail if a new citation is added to CLAUDE.md that references a
non-existent file.

**Applies to**:
- BC-X.13.001: the integration test IS the behavioral contract — passing green on
  develop HEAD is the primary postcondition; canonical failure message is authoritative
- BC-X.13.003: ALL `.factory/` paths excluded by dir-prefix filter (no allowlist
  function needed; `.factory/` exclusion is entirely inside `extract_path_citations`)

**Test placement**: The integration test function itself (`test_claude_md_citations_resolve_to_real_files`)
IS the primary VP-CITE-002 artifact. An additional fixture-based test confirms the
deterministic failure path without touching CLAUDE.md.

**Test strategy — self-verification (always-green invariant)**:

The test as written IS the verification. The failure message MUST match CI-CITE-001
verbatim — the lead line, the per-path indented lines, the fix instruction, and the
auto-exclusion note are all load-bearing:

```rust
#[test]
fn test_claude_md_citations_resolve_to_real_files() {
    let doc = include_str!("../CLAUDE.md");
    let root = env!("CARGO_MANIFEST_DIR");
    let citations = extract_path_citations(doc);
    // No is_off_working_branch_allowlisted call — .factory/ is excluded by
    // extract_path_citations dir-prefix filter (step f); no allowlist needed.
    let dead: Vec<String> = citations
        .into_iter()
        .filter(|p| !Path::new(root).join(p).exists())
        .collect();
    assert!(
        dead.is_empty(),
        // CANONICAL failure message — CI-CITE-001 (error-taxonomy §8) — VERBATIM:
        "CLAUDE.md cites file paths that do not exist on disk:\n  {}\nFix the citation or restore the file.\nNote: .factory/, glob, and symbol-form tokens are auto-excluded.",
        dead.iter().map(|p| format!("{} (line N)", p)).collect::<Vec<_>>().join("\n  ")
    );
}
```

The test passes green if and only if every in-scope citation in CLAUDE.md exists on
disk. The guard is self-verifying: if any future PR removes a file that CLAUDE.md
cites, this test will fail on CI.

**IMPORTANT — failure message discipline:** The lead line MUST be
`CLAUDE.md cites file paths that do not exist on disk:` (NOT `Dead CLAUDE.md
citations:` or any other wording). The closing lines MUST be `Fix the citation or
restore the file.` followed by `Note: .factory/, glob, and symbol-form tokens are
auto-excluded.` These strings are load-bearing — they are the CI-CITE-001 canonical
message from error-taxonomy.md §8 and pinned by BC-X.13.001.

**Test strategy — deterministic failure (fixture-based)**:

To confirm the guard fails when fed a dead citation, add a second test that
passes a fixture doc string (not `include_str!("../CLAUDE.md")`) containing a
known-nonexistent path and asserts the detection logic finds it. No
`is_off_working_branch_allowlisted` call — `.factory/` exclusion happens inside
`extract_path_citations` at the dir-prefix step:

```rust
#[test]
fn test_dead_citation_detected_in_fixture() {
    // Construct a doc string with a known-dead path. We use a path
    // that is guaranteed not to exist (no real jr file is at this path).
    let fixture_doc = r#"
Some documentation text.
Detail: `src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs`
"#;
    let root = env!("CARGO_MANIFEST_DIR");
    let citations = extract_path_citations(fixture_doc);
    // No allowlist filter — .factory/ paths never reach this check (dir-prefix excluded).
    let dead: Vec<String> = citations
        .into_iter()
        .filter(|p| !Path::new(root).join(p).exists())
        .collect();
    assert!(
        dead.contains(&"src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs".to_string()),
        "Expected dead citation to be detected but was not in: {:?}",
        dead
    );
}
```

**Dir-prefix exclusion verification** (BC-X.13.003 — no allowlist; all `.factory/`
excluded by `extract_path_citations` dir-prefix filter):

```rust
#[test]
fn test_factory_specs_path_excluded_by_dir_prefix() {
    // .factory/ is not in the develop-tracked prefix set — never extracted
    let doc = "See `.factory/specs/prd/bc-3-issue-write.md` for details.";
    let citations = extract_path_citations(doc);
    assert!(
        citations.is_empty(),
        "Expected .factory/ path to be excluded but got: {:?}",
        citations
    );
}

#[test]
fn test_factory_holdout_path_excluded_by_dir_prefix() {
    let doc = "See `.factory/holdout-scenarios/H-001.md` for details.";
    let citations = extract_path_citations(doc);
    assert!(citations.is_empty());
}

#[test]
fn test_factory_research_path_excluded_by_dir_prefix() {
    // .factory/research/ is also excluded — no sub-path partition within .factory/
    let doc = "See `.factory/research/S-3.03-wave3-verification.md` for details.";
    let citations = extract_path_citations(doc);
    assert!(citations.is_empty());
}

#[test]
fn test_docs_path_is_in_scope() {
    let doc = "See `docs/adr/0016-windows-build-target.md` for details.";
    let citations = extract_path_citations(doc);
    assert!(citations.contains(&"docs/adr/0016-windows-build-target.md".to_string()));
}
```

**Suggested test names**:
- `test_claude_md_citations_resolve_to_real_files` (the guard itself — always green)
- `test_dead_citation_detected_in_fixture`
- `test_factory_specs_path_excluded_by_dir_prefix`
- `test_factory_holdout_path_excluded_by_dir_prefix`
- `test_factory_research_path_excluded_by_dir_prefix`
- `test_docs_path_is_in_scope`
- `test_src_path_is_in_scope`

---

## VP to BC Mapping Summary

| VP ID | BC(s) Covered | Key Invariant |
|-------|---------------|---------------|
| VP-CITE-001 | BC-X.13.001, BC-X.13.002 | `extract_path_citations` correctly identifies in-scope tokens and applies the canonical (a)–(e) pipeline (step a: glob-skip; step b: merged fixpoint — symbol-form strip sub-step 1, line-ref strip sub-step 2, leading-bracket strip sub-step 3, plain-punct trim sub-step 4, unbalanced `)` trim sub-step 5, unbalanced `]` trim sub-step 6; step c: dir-prefix filter including `.factory/` exclusion; step d: extension filter; step e: Path::exists()) — no false positives; no panics on arbitrary input; proptest alphabet includes `*`, `{`, `}`, `:`, `~`, trailing-punct chars, and leading-punct chars `(`, `[`, `]` to exercise all branches including merged-fixpoint multi-pass vectors |
| VP-CITE-002 | BC-X.13.001, BC-X.13.003 | Integration guard is green on develop HEAD (zero dead citations); fails deterministically when a fixture with a known-dead path is fed; canonical CI-CITE-001 failure message emitted verbatim; `.factory/` exclusion via dir-prefix filter at step (c) (no allowlist function) |

## Project Convention Note

This project inlines Verification Properties directly in BC body files rather than
maintaining separate VP-INDEX, verification-architecture.md, or
verification-coverage-matrix.md files (those files do not exist in this repository).

**VP permanence decision (F-2, 2026-06-19)**: The `### VP-CITE-NNN` headings with full
test strategy detail that appear in this `verification-delta-DEAD-CITATION-CI.md` file
are intentionally a **transient F2/F3 working artifact** consumed by the test-writer in
F4. They are NOT the permanent spec record. The permanent spec record for each VP is the
one-line VP citation in the corresponding BC body's `**Verification Properties**` section
in `cross-cutting.md`. The test-writer uses the detailed strategies here to author tests;
once tests exist, the delta detail is superseded by the test file itself.

VP-CITE-001 and VP-CITE-002 are recorded as **Verification Properties subsections
within the BC bodies** in `.factory/specs/prd/cross-cutting.md`:
- VP-CITE-001: present in BC-X.13.001 §Verification Properties and BC-X.13.002 §Verification Properties.
- VP-CITE-002: present in BC-X.13.001 §Verification Properties and BC-X.13.003 §Verification Properties.

No separate index propagation is required. Both VPs are verification artifacts only —
they do not affect BC count surfaces (total_bcs, definitional_count, BC-INDEX, CANONICAL-COUNTS).

## DTU Assessment

**DTU_REQUIRED: false**

No new external service dependency is introduced. The guard is a pure test-time
structural check against the local filesystem. See `arch-delta-DEAD-CITATION-CI.md` §5
for full DTU rationale.

## Gene Transfusion Assessment

**No gene transfusion candidates identified.**

The implementation scope (backtick tokenizer, string normalization, `Path::exists`
check) is trivial and has no reference implementation worth translating. See
`arch-delta-DEAD-CITATION-CI.md` §6.

## F4 Handoff Checklist

Before F4 (TDD Implementation) can begin:

- [ ] `extract_path_citations` is implemented as a **standalone pure function** (no
      `Path::exists()` calls inside) — required for VP-CITE-001 proptest coverage
- [ ] **NO `is_off_working_branch_allowlisted` function** — `.factory/` exclusion is
      handled entirely inside `extract_path_citations` by the dir-prefix filter (step f).
      Do not implement or call this function.
- [ ] `extract_path_citations` has an inline `#[cfg(test)] mod tests` block in
      `tests/claude_md_citations.rs`
- [ ] `test_claude_md_citations_resolve_to_real_files` passes green on develop HEAD
      at the time of implementation (zero dead citations on develop as of 2026-06-19)
- [ ] The integration test failure message matches CI-CITE-001 VERBATIM:
      lead line `CLAUDE.md cites file paths that do not exist on disk:`, then
      `  <path> (line N)` per dead path, then `Fix the citation or restore the file.`,
      then `Note: .factory/, glob, and symbol-form tokens are auto-excluded.`
      Do NOT use `Dead CLAUDE.md citations:` or any other wording.
- [ ] CLAUDE.md doc-fallout note added in "AI Agent Notes" section (per F1 delta §4
      Files MODIFIED; follows the `*_release_gate.rs` guard documentation pattern)

## F6 Handoff Checklist

Before F6 (Targeted Hardening) can sign off:

- [ ] Both proptest properties from VP-CITE-001 (`test_non_prefix_tokens_are_never_extracted`,
      `test_extract_never_panics`) are in tree and pass
- [ ] The proptest alphabet for `test_non_prefix_tokens_are_never_extracted` includes
      `*`, `{`, `}`, `:`, `~`, trailing-punct chars (`,`, `.`, `;`), and leading/trailing
      bracket chars `(`, `)`, `[`, `]` so that all six sub-steps of the merged fixpoint
      at step (b) are exercised by random inputs — reducing mutation-survival risk. Note:
      the former "step (e)" references in checklists now correspond to step (b) sub-steps
      (3)–(6) in the (a)–(e) pipeline.
- [ ] Multi-pass merged-fixpoint vectors (EC-CITE-026: `(src/config.rs:~42)`;
      EC-CITE-027: `src/api/client.rs:195,`; EC-CITE-028: `src/foo.rs::bar().`) each
      have a dedicated unit test asserting the correct extracted path
- [ ] `cargo mutants --in-diff` on the PR diff does not flag uncovered branches in
      `extract_path_citations` (the exclusion rules are each independently exercisable
      by the unit tests above)
- [ ] `cargo clippy -- -D warnings` and `cargo fmt --all -- --check` remain green
