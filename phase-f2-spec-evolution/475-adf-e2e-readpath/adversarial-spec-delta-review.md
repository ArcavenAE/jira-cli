---
document_type: adversarial-spec-delta-review
issue: 475
feature: "ADF E2E read-path coverage"
pass: 1
reviewer_model: fable (adversary — fresh context, information-asymmetric)
created: 2026-06-11
resolution_status: all-findings-resolved-pass2
spec_version_after_resolution: "1.3.8"
---

# Adversarial Spec Delta Review — Issue #475 (Pass 1)

## Pass 1 Findings and Resolutions

| ID | Severity | Confidence | Finding | Resolution |
|----|----------|------------|---------|------------|
| F1 | HIGH | MEDIUM | Teardown vacuous: test design steps never add a label flag for the CI sweeper | FIXED in e2e-coverage-spec.md: Setup step 2 requires `--label <E2E_TEST_LABEL>` on create; Teardown section updated. |
| F2 | HIGH | HIGH | AC-2 can pass vacuously: absence-only assertion cannot distinguish "normalized" from "content dropped" | FIXED: added positive poll gate (listItem nodes present) and `adf_contains_text` sanity check; framing softened from "proves unwrap-not-drop" to "sanity check" per F1-M2. |
| F3 | HIGH | MEDIUM | New test's CLI invocations not registered in SURFACE guard | FIXED: all three CLI paths confirmed already registered (`e2e_cli_surface_guard.rs` lines 73/118-119/122); resolved as hard fact — no F4 action needed. |
| F4 | MEDIUM | HIGH | AC-2 inspection channel unspecified | FIXED: uses `poll_view(&key, &harness)` (existing, `e2e_live.rs:~474`). |
| F5 | MEDIUM | MEDIUM | Eventual-consistency hazard: absence assertion on stale read | FIXED: positive poll gate precedes absence assertion. |
| F6 | MEDIUM | HIGH | AC-1 assertions incomplete: code block unasserted | FIXED: `stdout.contains("code snippet")` added. |
| F7 | MEDIUM | HIGH | AC-3 assertions vacuous: positive-only substring passes on raw passthrough | FIXED (pass 2 — see F1-C1 below). |
| F8 | LOW | MEDIUM | SURFACE table keys are command paths, not test names | FIXED: AC-4 section corrected. |
| F9 | LOW | HIGH | Unstated AC ordering dependency | FIXED: ordering and skip-logic documented. |

## Pass 2 Findings (orchestrator-dispatched, reviewing pass-1 resolution)

| ID | Severity | Finding | Resolution |
|----|----------|---------|------------|
| F1-C1 | CRITICAL | AC-3 assertions were live-failing: `adf_to_text` is a markdown re-emitter (`strong` → `**x**`, `em` → `*x*`), so `assert!(!stdout_comments.contains("**body**"))` would always fail, and `_emphasis_` negative was vacuous (em re-emits as `*`, never `_`). | FIXED in e2e-coverage-spec.md: positive assertions now check re-emitted forms (`**body**` ✓, `*emphasis*` ✓); negative assertion checks `_emphasis_` absent (raw passthrough would leave underscores; live round-trip produces `*emphasis*` with asterisks — genuine differentiator). |
| F1-H1 | HIGH | Rename propagation gap: `docs/specs/e2e-live-jira-testing.md:~123` missing from AC-4 touch-point list. | FIXED in e2e-coverage-spec.md and prd-delta.md: file and line added to touch-point list. |
| F1-M1 | MEDIUM | Spec cited non-existent helper names as "existing" (`jr_cmd_with_env`, `poll_view_json`, `adf_contains_node_type`). | FIXED: corrected to actual names (`harness.cmd().args([...]).output()`, `poll_view`, `adf_has_node_type`); `adf_has_blockquote_in_list_item` explicitly marked NEW with line references for existing analogues. |
| F1-M2 | MEDIUM | "proves unwrap-not-drop" overstated: `normalize_list_item_content` has no drop path for blockquote content; sanity check cannot distinguish unwrap from other preservation paths. | FIXED: framing changed to "sanity check"; comment corrected to remove "unwrap-not-drop" claim. |
| F1-L1 | LOW | SURFACE registration questions left as open F4 risks rather than resolved facts. | FIXED: all three CLI paths verified registered at F2 time with line references; stated as resolved, no F4 action needed. |
| F1-L2 | LOW | Incoherent verb decomposition in test naming convention note. | FIXED: decomposition corrected to `e2e` (scope) + `markdown_description` (subject) + `produces` (verb) + `heading_node` (outcome). |

## Pass 2 Outcome

All 6 pass-2 findings resolved (1 CRITICAL, 1 HIGH, 2 MEDIUM, 2 LOW). Spec
version bumped to 1.3.8. All prior pass-1 findings also resolved. No open
findings of any severity.

## Remaining Notes (cosmetic only)

- The markdown fixture `- > nested blockquote text` parses to blockquote-in-listItem
  in pulldown-cmark — confirmed by existing unit tests for `normalize_list_item_content`.
- The test name `test_e2e_adf_read_path_human_output` is a reasonable fit for the
  convention. The decomposition is non-standard (no clean verb/subject/outcome split),
  but matches the style of nearby tests and is acceptable per project norms.

## Overall Assessment

Spec delta CONVERGED. All CRITICAL/HIGH/MEDIUM/LOW findings across both passes are
resolved. F3 story-writer and F4 implementer have unambiguous acceptance criteria.
