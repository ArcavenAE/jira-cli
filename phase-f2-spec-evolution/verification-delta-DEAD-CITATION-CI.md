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

### VP-CITE-001: `extract_path_citations` grammar — in-scope detection and all 9 exclusion rules, no false positives

**Description**: The `extract_path_citations(doc: &str) -> Vec<String>` function in
`tests/claude_md_citations.rs` must correctly identify path tokens from arbitrary
document strings and correctly reject all non-path tokens (symbols, URLs, BC IDs,
ADR shorthands, glob patterns, type names, env-var names, bare words). This VP
covers the pure-function grammar, which is independently testable without any
filesystem access.

**Applies to**:
- BC-X.13.001: in-scope token identification (directory prefix + extension filter)
- BC-X.13.002: all 9 exclusion/normalization rules

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
2. Assert each of the following token types IS extracted:
   - Plain file reference: `` `src/adf.rs` ``
   - Nested path: `` `tests/auth_profiles.rs` ``
   - Docs path: `` `docs/adr/0016-windows-build-target.md` ``
   - Factory research path: `` `.factory/research/S-3.03-wave3-verification.md` ``
   - Scripts path: `` `scripts/check-spec-counts.sh` ``
   - GitHub workflow path: `` `.github/workflows/ci.yml` ``

**Test strategy — exclusion rules (BC-X.13.002 negative cases)**:

For each of the 9 exclusion rules, assert the token is NOT present in the
extracted list (or is normalized, as appropriate):

| Rule # | Input token | Expected behavior |
|--------|-------------|------------------|
| 1 (Glob skip) | `` `.factory/specs/prd/bc-*.md` `` | Skipped entirely — NOT in output |
| 2 (Symbol-form strip) | `` `src/adf.rs::push_text` `` | Normalized to `src/adf.rs` — IS in output as `src/adf.rs` |
| 2 (Symbol-form strip — no dir prefix) | `` `adf::tests::test_bare_url_split` `` | Has `::` but no known dir prefix before `::` — NOT in output (excluded by dir-prefix filter) |
| 3 (Line-ref strip) | `` `src/config.rs:~42` `` | Normalized to `src/config.rs` — IS in output as `src/config.rs` |
| 3 (Line-ref strip bare) | `` `src/config.rs:100` `` | Normalized to `src/config.rs` — IS in output as `src/config.rs` |
| 4 (Section-ref — whitespace) | `` `docs/specs/e2e-live-jira-testing.md §9` `` | `§9` excluded by dir-prefix filter; `docs/specs/e2e-live-jira-testing.md` IS in output |
| 5 (Extension filter) | `` `src/cli/issue` `` | No recognized extension — NOT in output |
| 6 (No dir prefix — URLs) | `` `http://127.0.0.1:53682/callback` `` | Not starting with known dir prefix — NOT in output |
| 7 (No dir prefix — home paths) | `` `~/.config/jr/config.toml` `` | Not starting with known dir prefix — NOT in output |
| 8 (No slash) | `` `JR_BASE_URL` `` | No `/` — NOT in output |
| 9 (Type names) | `` `std::sync::Mutex` `` | Has `::` but no known dir prefix — NOT in output |

**Proptest strategy (BC-X.13.002 — no false positives)**:

Property: For any string `s` that does NOT start with a known directory prefix
(`src/`, `tests/`, `docs/`, `.factory/`, `.github/`, `scripts/`), wrapping it
in backticks and passing it to `extract_path_citations` returns an empty vec (or
a vec without `s` in it).

```rust
proptest! {
    #[test]
    fn test_non_prefix_tokens_are_never_extracted(
        s in "[A-Za-z0-9_:~./]{1,50}"
    ) {
        let non_prefix = format!("`{}`", s);
        let result = extract_path_citations(&non_prefix);
        // Either empty, or any returned path starts with a known prefix
        for path in &result {
            prop_assert!(
                path.starts_with("src/")
                    || path.starts_with("tests/")
                    || path.starts_with("docs/")
                    || path.starts_with(".factory/")
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

**Suggested test names** (unit):
- `test_in_scope_src_path_extracted`
- `test_in_scope_tests_path_extracted`
- `test_in_scope_docs_path_extracted`
- `test_in_scope_factory_research_path_extracted`
- `test_in_scope_scripts_path_extracted`
- `test_glob_pattern_skipped`
- `test_symbol_form_stripped_to_file`
- `test_symbol_form_no_dir_prefix_excluded`
- `test_line_ref_tilde_stripped_to_file`
- `test_line_ref_bare_stripped_to_file`
- `test_section_ref_doc_path_extracted_section_excluded`
- `test_no_extension_excluded`
- `test_url_in_backticks_excluded`
- `test_home_path_excluded`
- `test_env_var_excluded`
- `test_type_name_excluded`

**Suggested test names** (proptest, in `mod proptests` block):
- `test_non_prefix_tokens_are_never_extracted`
- `test_extract_never_panics`

---

### VP-CITE-002: Integration self-verification — guard is green on develop HEAD; fails deterministically on dead citation

**Description**: The `test_claude_md_citations_resolve_to_real_files` integration
test in `tests/claude_md_citations.rs` must:
1. Pass green (`exit 0`) on the current `develop` HEAD (zero dead citations)
2. Fail deterministically (`panics` with the dead path listed) when a known-dead
   citation is present in the CLAUDE.md text being checked

This VP has a self-verifying structure: because CLAUDE.md currently has zero dead
citations, the integration test is green from the moment it is written. The test
will only ever fail if a new citation is added to CLAUDE.md that references a
non-existent file.

**Applies to**:
- BC-X.13.001: the integration test IS the behavioral contract — passing green on
  develop HEAD is the primary postcondition
- BC-X.13.003: off-working-branch allowlist prevents false positives from factory
  spec paths

**Test placement**: The integration test function itself (`test_claude_md_citations_resolve_to_real_files`)
IS the primary VP-CITE-002 artifact. An additional fixture-based test confirms the
deterministic failure path without touching CLAUDE.md.

**Test strategy — self-verification (always-green invariant)**:

The test as written IS the verification:

```rust
#[test]
fn test_claude_md_citations_resolve_to_real_files() {
    let doc = include_str!("../CLAUDE.md");
    let root = env!("CARGO_MANIFEST_DIR");
    let citations = extract_path_citations(doc);
    let dead: Vec<String> = citations
        .into_iter()
        .filter(|p| !is_off_working_branch_allowlisted(p))
        .filter(|p| !Path::new(root).join(p).exists())
        .collect();
    assert!(
        dead.is_empty(),
        "Dead CLAUDE.md citations:\n  {}\nFix the citation or restore the file.",
        dead.join("\n  ")
    );
}
```

The test passes green if and only if every in-scope citation in CLAUDE.md
exists on disk. The guard is self-verifying: if any future PR removes a file
that CLAUDE.md cites, this test will fail on CI.

**Test strategy — deterministic failure (fixture-based)**:

To confirm the guard fails when fed a dead citation, add a second test that
passes a fixture doc string (not `include_str!("../CLAUDE.md")`) containing a
known-nonexistent path and asserts the detection logic finds it:

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
    let dead: Vec<String> = citations
        .into_iter()
        .filter(|p| !is_off_working_branch_allowlisted(p))
        .filter(|p| !Path::new(root).join(p).exists())
        .collect();
    assert!(
        dead.contains(&"src/DOES_NOT_EXIST_IN_ANY_JR_BUILD.rs".to_string()),
        "Expected dead citation to be detected but was not in: {:?}",
        dead
    );
}
```

**Off-working-branch allowlist verification** (BC-X.13.003 positive test):

```rust
#[test]
fn test_factory_specs_path_is_allowlisted() {
    assert!(is_off_working_branch_allowlisted(".factory/specs/prd/bc-3-issue-write.md"));
}

#[test]
fn test_factory_holdout_path_is_allowlisted() {
    assert!(is_off_working_branch_allowlisted(".factory/holdout-scenarios/H-001.md"));
}

#[test]
fn test_factory_research_path_is_not_allowlisted() {
    // .factory/research/ files live on develop; must be checked
    assert!(!is_off_working_branch_allowlisted(".factory/research/S-3.03-wave3-verification.md"));
}

#[test]
fn test_docs_path_is_not_allowlisted() {
    assert!(!is_off_working_branch_allowlisted("docs/adr/0016-windows-build-target.md"));
}
```

**Suggested test names**:
- `test_claude_md_citations_resolve_to_real_files` (the guard itself — always green)
- `test_dead_citation_detected_in_fixture`
- `test_factory_specs_path_is_allowlisted`
- `test_factory_holdout_path_is_allowlisted`
- `test_factory_cycles_path_is_allowlisted`
- `test_factory_research_path_is_not_allowlisted`
- `test_docs_path_is_not_allowlisted`
- `test_src_path_is_not_allowlisted`

---

## VP to BC Mapping Summary

| VP ID | BC(s) Covered | Key Invariant |
|-------|---------------|---------------|
| VP-CITE-001 | BC-X.13.001, BC-X.13.002 | `extract_path_citations` correctly identifies in-scope tokens and applies all 9 exclusion/normalization rules — no false positives; no panics on arbitrary input |
| VP-CITE-002 | BC-X.13.001, BC-X.13.003 | Integration guard is green on develop HEAD (zero dead citations); fails deterministically when a fixture with a known-dead path is fed; off-branch allowlist prevents false positives |

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
- [ ] `is_off_working_branch_allowlisted` is implemented as a standalone pure function
      returning `true` for `.factory/specs/`, `.factory/holdout-scenarios/`,
      `.factory/cycles/` prefixes; returning `false` for all others
- [ ] Both helper functions have inline `#[cfg(test)] mod tests` blocks in
      `tests/claude_md_citations.rs`
- [ ] `test_claude_md_citations_resolve_to_real_files` passes green on develop HEAD
      at the time of implementation (zero dead citations on develop as of 2026-06-19)
- [ ] CLAUDE.md doc-fallout note added in "AI Agent Notes" section (per F1 delta §4
      Files MODIFIED; follows the `*_release_gate.rs` guard documentation pattern)

## F6 Handoff Checklist

Before F6 (Targeted Hardening) can sign off:

- [ ] Both proptest properties from VP-CITE-001 (`test_non_prefix_tokens_are_never_extracted`,
      `test_extract_never_panics`) are in tree and pass
- [ ] `cargo mutants --in-diff` on the PR diff does not flag uncovered branches in
      `extract_path_citations` (the exclusion rules are each independently exercisable
      by the unit tests above)
- [ ] `cargo clippy -- -D warnings` and `cargo fmt --all -- --check` remain green
