# PR Review — FIX-F6-001 (mutation-test scope gap: `field.rs` + `field_resolve.rs`)

**PR:** #749 — https://github.com/Zious11/jira-cli/pull/749
**Branch:** fix/F6-001-mutants-scope → develop
**Reviewer:** pr-reviewer (fresh-eyes final pre-merge gate, cycle 1)
**Verdict:** APPROVE — ready to merge
**Date:** 2026-08-31

## Scope reviewed
Config: `.cargo/mutants.toml` (examine_globs +2 entries)
Docs: `docs/specs/cargo-mutants-policy.md` (§Scope bullets + count line + changelog table row), `CHANGELOG.md` (### Changed entry)
Production `src/`: none touched (config/doc-only PR)

Diff obtained via `git diff origin/develop...HEAD` from the FIX-F6-001 worktree. No local cargo build/test/mutants run (per instruction — heavy cargo-mutants job active on host; this PR needs no compilation).

## Independently verified
- **examine_globs glob strings correct.** Both new entries (`src/cli/field.rs`, `src/cli/issue/field_resolve.rs`) are literal paths; both files exist (confirmed via ls) and match the existing literal-path convention used by every other entry. Block now has exactly 20 entries (awk-counted the `examine_globs = [ ... ]` block), up from 18 = +2, matching the diff.
- **§Scope citations accurate — all 17 cited function names exist:**
  - `field.rs`: `handle` (L107), `resolve_field_id` (L434), `resolve_field_context` (L587), `resolve_m2_project` (L613), `normalize_from_allowed_values` (L626), `normalize_from_valid_values` (L662), `filter_options` (L709), `render_option_rows` (L777).
  - `field_resolve.rs`: `detect_flag_field_overlap` (L250), `resolve_edit_fields` (L376), `resolve_against_createmeta` (L602), `resolve_against_editmeta` (L696), `dispatch_field_value` (L771), `compose_option_hint` (L1116), `compose_id_hint` (L1269), `compose_name_hint` (L1281), `compose_asset_hint` (L1312).
- **CI citation guard passes.** Ran `scripts/check-cargo-mutants-policy-citations.sh` (the exact script in the spec-guard CI job): exit 0, "20 bullets parsed, 69 (file, fn) pairs validated". CI spec-guard will pass.
- **Internal consistency clean.** Mutant counts (~91 field.rs / ~45 field_resolve.rs) agree across all four touched spots: mutants.toml comments, CHANGELOG entry, policy §Scope bullets, policy changelog table row. The "20 entries" count line, the CHANGELOG "18 → 20", and the policy table row all agree. Story refs (S-580-1; #578 parts 1-5; S-578-2/S-578-4) match the real recent commits (74221bbc `feat(field): jr field options ... (S-580-1)`, 993de833 `feat(issue): --field NAME:kind=VALUE ... (S-578-1, #578 part 1)`).
- **CHANGELOG placement correct.** New entry lands under `### Changed` within `## [Unreleased]` (before `## [0.7.0-dev.2]`).

## Findings
None. No correctness, consistency, or prose issues. No inline comments posted (nothing to flag).

## Verdict
**APPROVE.** Config/doc-only scope gap fix; both previously-omitted production files now covered by the `mutants` CI gate. All citations resolve to real symbols, all counts internally consistent, and the CI guard script passes locally.
