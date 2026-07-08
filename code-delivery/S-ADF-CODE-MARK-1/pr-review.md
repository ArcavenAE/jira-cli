# PR #593 Review — fix(adf): enforce code-mark exclusivity in push_code (BC-7.2.015, closes #571)

**Cycle:** 1
**Reviewer:** pr-reviewer (fresh-eyes, different model family)
**Verdict:** APPROVE (posted as `--comment` review — self-approval blocked by GitHub since branch author == authenticated user)

## Summary

Independent fresh-eyes review of the diff (`origin/develop...fix/571-adf-code-mark-exclusivity`). Reviewed against BC-7.2.015 spec fidelity, test quality, code quality, MUST-STAY-GREEN preservation, and architectural invariants. No blocking findings. No non-blocking findings.

The change is a minimally-scoped, surgically-correct fix. The `push_code` allowlist filter enforces the ADF `code_inline_node` schema (only `link` and `annotation` marks permitted alongside `code`) at the sole production emit site. Test coverage is thorough — 8 RED→GREEN anchors, 2 GREEN retention anchors, VP-571-003 node-scoped stripping pinned by two mixed-range tests, and a 256-case universal-quantifier proptest.

## Checklist Assessment

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence — all changes relate to BC-7.2.015 / #571 | PASS |
| 2 | Description accuracy — body matches actual diff (8 commits, 992+16 tests) | PASS |
| 3 | Test coverage — new `push_code` filter path fully covered; delta positive | PASS |
| 4 | Demo evidence — `docs/demo-evidence/S-ADF-CODE-MARK-1/` has `.gif`+`.webm`+`.tape` per AC group and `evidence-report.md` | PASS |
| 5 | Commit quality — 8 conventional commits, all scoped `S-ADF-CODE-MARK-1` | PASS |
| 6 | Diff size — 1,626 additions / 19 deletions; largest chunks are tests + proptest generator (justified) | PASS |
| 7 | Missing changes — none; CLAUDE.md clause-(b) splice verified in situ | PASS |
| 8 | Dependencies — none; `depends_on: []`, `blocks: []` | PASS |

## Detailed Verification

### 1. Spec fidelity — BC-7.2.015 + BC-7.2.007 EC-2 closure — VERIFIED

`src/adf.rs::push_code` (worktree lines 1304–1318) constructs a new `Vec<Value>` via `self.active_marks.iter().filter(...).cloned().collect()` where the filter matches only `Some("link") | Some("annotation")` on the mark type field. `{"type":"code"}` is then appended, and the result flows through `dedup_marks_by_type`. Behavior exactly matches ADF `code_inline_node` schema. BC-7.2.007 EC-2 write-strict clause is closed via the CLAUDE.md #474 gotcha clause-(b) splice.

### 2. Test quality — VERIFIED

Anchors traced against `src/adf.rs::tests`:
- **8 RED→GREEN anchors** are genuine: `test_bc_7_2_015_{strong,em,strike,subsup}_stripped_from_code_node`, `..._mixed_range_surrounding_marks_retained`, `..._multi_mark_wrapper_only_code_node_stripped`, `..._alert_wrapper_strong_code_stripped`, plus the rewritten `test_markdown_inline_code_mark_and_composition`.
- **2 GREEN retention anchors** are correct: `test_bc_7_2_015_plain_code_baseline` (control) and `test_bc_7_2_015_link_preserved_on_code_node` (EC-5, two-part assertion: mark set + `attrs.href` verbatim check).
- **VP-571-003 node-scoped stripping** pinned twice: `..._mixed_range_surrounding_marks_retained` asserts `"a "` and `" c"` retain `strong`; `..._multi_mark_wrapper_only_code_node_stripped` asserts `"a "`/`"b "`/`" d"`/`" e"` retain outer marks while only `"c"` is stripped. A shared-stack mutation would fail these immediately.
- **Proptest** `prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks`: 256 cases, 11 inline templates × 9 inner containers × 10 outer containers (Alert outermost-only per Footnote A), depth ≤ 3, well within `MAX_ADF_DEPTH = 256`.

### 3. Code quality — clone-based filter + dedup preserved — VERIFIED

The filter chain `iter().filter(...).cloned().collect()` produces a fresh `Vec<Value>` — `self.active_marks` is never mutated. The trailing `dedup_marks_by_type(&marks)` call remains on the emit path (line 1322).

### 4. MUST-STAY-GREEN write-strict/read-lenient asymmetry — VERIFIED

All four regression-pinned tests (`test_render_marks_code_and_strong`, `test_render_strong_with_code_applies_code_innermost`, `test_push_code_normalizes_lone_cr_in_inline_code`, `test_push_code_normalizes_bare_lf_to_space`) are untouched. The `apply_marks` docstring and the two reverse-path test comments were refreshed to explicitly frame read-tolerance as intentional for externally-produced/legacy ADF — a documentation-only change that preserves reverse-path behavior.

### 5. Architecture — sole production emit site — VERIFIED

`grep '"type": "code"' src/adf.rs` shows exactly one occurrence outside `#[cfg(test)]`: line 1318 (`marks.push(json!({ "type": "code" }))` inside `push_code`). All other matches (lines 3663, 6229, 6472, 6484, 6574, 6672) are inside the `mod tests` block.

## Additional Observations (non-blocking, informational)

- **Duplicated helpers in Call E** (`tests/issue_create_jsm.rs`): `collect_text_nodes_local`, `has_mark_local`, `assert_code_mark_exclusivity_local` mirror the non-`_local` helpers in `tests/adf_code_mark_exclusivity.rs`. Deliberate trade-off (avoiding a shared `tests/common/` import), called out inline. Acceptable.
- **Platform mock `.expect(0)`** in Call E is the correct dispatch-fork regression guard for ADR-0014 — verifies the JSM path does NOT accidentally hit `/rest/api/3/issue`.
- **CI status:** All 15 required checks pass (CI Gate, Clippy ubuntu+windows, Coverage, Deny, Format, MSRV, Mutation testing, Gitleaks, Signing guard, Spec Guards, Test macos/ubuntu/windows, dependency-review).

## Findings

- **BLOCKING:** none
- **NON-BLOCKING:** none

## Verdict

**APPROVE.** The change is spec-correct, minimally scoped, thoroughly tested, and preserves all invariants. Note: `gh pr review --approve` was rejected by GitHub because the authenticated user is the PR author (self-approval blocked). Fallback path used: `gh pr review --comment --body-file` posts the same body in the review timeline. Explicit APPROVE verdict is stated in the body. Code owner approval still required by branch protection.
