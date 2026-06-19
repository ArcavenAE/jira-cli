---
document_type: prd-delta
bundle: DEAD-CITATION-CI
phase: F2
date: 2026-06-19
status: complete
---

# PRD Delta — DEAD-CITATION-CI

## Summary

Added 3 new behavioral contracts to `cross-cutting.md` under new subsystem **X.13 CI Guards**.
Added error taxonomy entry for the guard's failure output to `error-taxonomy.md`.

No existing BCs modified. No architecture changes. No UX changes (infrastructure feature).

## New BCs

| BC ID | Title | Priority | File |
|-------|-------|----------|------|
| BC-X.13.001 | Every in-scope backtick-quoted path citation in CLAUDE.md resolves to a real on-disk file; guard fails listing ALL dead references | P0 | cross-cutting.md §X.13 |
| BC-X.13.002 | Glob wildcards, symbol-form suffixes (`::fn`), line-ref suffixes (`:~NN`/`:NN`), section refs (` §N`) excluded/normalized — no false positives | P0 | cross-cutting.md §X.13 |
| BC-X.13.003 | Off-working-branch prefixes (`.factory/specs/`, `.factory/holdout-scenarios/`, `.factory/cycles/`) allowlisted; `.factory/research/` NOT allowlisted — checked | P0 | cross-cutting.md §X.13 |

## Count Impact

- Previous total: **599**
- New total: **602** (+3)
- All 8 count surfaces updated (A-G + Coverage Statistics table)

## Files Modified

- `.factory/specs/prd/cross-cutting.md` — new X.13 section, frontmatter updated (total_bcs 142->145, definitional_count 76->79)
- `.factory/specs/prd/BC-INDEX.md` — X.13 index rows, Section X header (142->145), frontmatter total_bcs (599->602), Coverage Statistics table, grand-total note
- `.factory/specs/prd/CANONICAL-COUNTS.md` — per-file table row cross-cutting (142->145), Sum row (599->602), grand-total prose (599->602)
- `.factory/specs/prd/error-taxonomy.md` — new Section 8 CI Guard Failure Taxonomy (CI-CITE-001)

## Architecture Delta

None. No new modules in `src/`. No CI workflow changes. The guard is auto-collected by
the existing `test` job (`cargo test --all-features`) which is already in `ci-gate.needs`.

## Verification Delta

VPs for the new BCs (for architect to register):
- VP-CITE-001: Unit tests for `extract_path_citations` — proptest over grammar variants
  (glob skip, suffix strip, dir-prefix filter, extension filter)
- VP-CITE-002: Integration test `test_claude_md_citations_resolve_to_real_files` —
  always green on develop HEAD; fails deterministically on dead citation insertion

See F1 Delta Analysis `.factory/phase-f1-delta-analysis/DEAD-CITATION-CI-delta-analysis.md` §7 for VP details.

## Stories Affected by BC Changes

No existing stories touch the CI guard surface. New story S-MAINT-DEAD-CITATION-CI will
be created in F3. Story-writer must reference BC-X.13.001, BC-X.13.002, BC-X.13.003 in
the new story's BC table during F3 (bc_array_changes_propagate_to_body_and_acs policy).

## VP Citations Changed

VP-CITE-001 and VP-CITE-002 are new VPs (not modifications to existing VPs). Architect
must register them in VP-INDEX and verification-architecture.md under
`vp_index_is_vp_catalog_source_of_truth` policy after F2 completes.
