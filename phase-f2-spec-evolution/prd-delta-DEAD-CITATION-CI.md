---
document_type: prd-delta
bundle: DEAD-CITATION-CI
phase: F2
iteration: 2
date: 2026-06-19
status: complete
---

# PRD Delta — DEAD-CITATION-CI (F2 Iteration 2)

## Summary

Added 3 new behavioral contracts to `cross-cutting.md` under new subsystem **X.13 CI Guards**.
Added error taxonomy entry for the guard's failure output to `error-taxonomy.md`.

**Iteration 2 (F2 Iter 2) applied the following major re-scope and spec improvements
(all human-approved):**

### Major Re-scope (C-2 / consistency finding)

**BC-X.13.003 REWRITTEN** from "off-branch allowlist" to "ALL `.factory/` paths excluded
via dir-prefix filter." Rationale: `.factory/` is git-ignored and lives in a separate
orphan-branch worktree; it is ABSENT from any CI checkout of `develop`. There is no
sub-path partition — the old design that checked `.factory/research/` but allowlisted
`.factory/specs/` was based on an incorrect premise. The `is_off_working_branch_allowlisted`
function concept is DROPPED. The dir-prefix filter's exclusion of `.factory/` is the sole
and sufficient mechanism.

In-scope directory prefixes = `src/`, `tests/`, `docs/`, `.github/`, `scripts/` (develop-tracked).

### Canonical Failure Message (C-2)

The CI-CITE-001 error taxonomy entry now defines the AUTHORITATIVE failure message:
```
CLAUDE.md cites file paths that do not exist on disk:
  <path> (line N)
  <path> (line N)
Fix the citation or restore the file.
Note: .factory/, glob, and symbol-form tokens are auto-excluded.
```

BC-X.13.001 postconditions require this EXACT message format. The old "add to allowlist"
hint sentence is REMOVED (no allowlist exists in the re-scoped design).

### Normalization Pipeline Improvements (HIGH + MEDIUM + SPEC-REVIEWER)

BC-X.13.002 revised to specify:
- Canonical pipeline order (SR-004): steps (a)–(h) in exact sequence
- Two-step extraction stated explicitly (SR-001): extract inline backtick spans, then split on whitespace
- Brace-glob extension (SR-002): `{` and `}` added to glob-skip set alongside `*`
- Trailing-punctuation trim (H-1/H-2): `.`, `,`, `;`, `:` always trimmed; `)` trimmed only if unbalanced
- Cardinality (F3-MINOR): 5 normalization/skip rules named; dir-prefix+extension exclusions are corollaries
- M-1 fenced-block edge case: triple-backtick blocks OUT OF SCOPE (inline single-backtick only)
- M-2 case-sensitivity limitation: documented as v1 accepted limitation
- M-3 directory-path disambiguation: EC-CITE-004 revised to clarify extension filter runs before existence check

## New BCs

| BC ID | Title | Priority | File |
|-------|-------|----------|------|
| BC-X.13.001 | Every in-scope backtick-quoted path citation in CLAUDE.md (develop-tracked dirs only) resolves to a real on-disk file; ALL `.factory/` excluded; guard fails with canonical message listing ALL dead references | P0 | cross-cutting.md §X.13 |
| BC-X.13.002 | Canonical normalization pipeline (glob/brace-glob skip, symbol-form strip, line-ref strip, trailing-punct trim, dir-prefix filter, extension filter) — no false positives on any of these forms | P0 | cross-cutting.md §X.13 |
| BC-X.13.003 | ALL `.factory/` paths excluded by dir-prefix filter — absent from CI checkout; no allowlist function; maintenance doc-drift sweep handles `.factory/` citation health | P0 | cross-cutting.md §X.13 |

## Count Impact

- Iter 1 total: **602** (BC-X.13.001..003 added)
- Iter 2 total: **602** (no new BCs added; existing BCs revised in-place)
- CANONICAL-COUNTS.md per-file row: cross-cutting.md `76 | 76` → `79 | 79` (Iter 2 correction)
- CANONICAL-COUNTS.md "Total individually-bodied": `367` → `370` (Iter 2 correction)
- CANONICAL-COUNTS.md Breakdown prose: stale `total_bcs: 142` → `145`, `599 sum` → `602` (Iter 2 correction)

## Files Modified (Iter 1 + Iter 2 combined)

- `.factory/specs/prd/cross-cutting.md` — new X.13 section (Iter 1); BC-X.13.001/002/003 rewritten for re-scope (Iter 2); frontmatter updated (total_bcs 142→145, definitional_count 76→79)
- `.factory/specs/prd/BC-INDEX.md` — X.13 index rows updated for re-scope (Iter 2); Section X header, frontmatter total_bcs, Coverage Statistics table, grand-total note (Iter 1)
- `.factory/specs/prd/CANONICAL-COUNTS.md` — per-file row `76|76`→`79|79`; Total individually-bodied `367`→`370`; Breakdown prose stale values corrected (Iter 2); Sum row, grand-total prose (Iter 1)
- `.factory/specs/prd/error-taxonomy.md` — CI-CITE-001 canonical failure message and actionability updated for re-scope (Iter 2); new Section 8 CI Guard Failure Taxonomy (Iter 1)

## Architecture Delta

None. No new modules in `src/`. No CI workflow changes. The guard is auto-collected by
the existing `test` job (`cargo test --all-features`) which is already in `ci-gate.needs`.

## Verification Delta

VPs for the new BCs (for architect to register):
- VP-CITE-001: Unit tests for `extract_path_citations` — proptest over the canonical pipeline
  (glob/brace-glob skip, symbol-form strip, line-ref strip, trailing-punct trim, dir-prefix filter,
  extension filter)
- VP-CITE-002: Integration test `test_claude_md_citations_resolve_to_real_files` —
  always green on develop HEAD; fails deterministically on dead citation insertion in
  develop-tracked dirs; `.factory/` citations never trigger failure

See F1 Delta Analysis `.factory/phase-f1-delta-analysis/DEAD-CITATION-CI-delta-analysis.md` §7 for VP details.
Note: `verification-delta-DEAD-CITATION-CI.md` VP descriptions should be updated by architect to reflect
the re-scoped BC-X.13.003 (no allowlist function; dir-prefix filter only).

## Stories Affected by BC Changes

No existing stories touch the CI guard surface. New story S-MAINT-DEAD-CITATION-CI will
be created in F3. Story-writer must reference BC-X.13.001, BC-X.13.002, BC-X.13.003 in
the new story's BC table during F3 (bc_array_changes_propagate_to_body_and_acs policy).

## VP Citations Changed

VP-CITE-001 and VP-CITE-002 are new VPs (not modifications to existing VPs). Architect
must register them in VP-INDEX and verification-architecture.md under
`vp_index_is_vp_catalog_source_of_truth` policy after F2 completes. VP-CITE-002's
scope has changed (re-scope): it no longer exercises `test_factory_research_path_is_not_allowlisted`
or `is_off_working_branch_allowlisted` (those test names are dropped); it exercises
the dir-prefix filter's exclusion of `.factory/` paths instead.
