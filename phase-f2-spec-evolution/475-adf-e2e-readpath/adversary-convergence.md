---
document_type: adversary-convergence-report
issue: 475
feature: "ADF E2E read-path coverage"
created: 2026-06-11
verdict: CONVERGED
spec_version_final: "1.3.9"
round_1_passes: 2
round_2_passes: 3
gate_approved: 2026-06-11
---

# Adversary Convergence Report — Issue #475 (Phase F2)

## Verdict: CONVERGED

Two independent adversarial rounds. Three consecutive clean passes in Round 2.
All findings resolved. Gate APPROVED 2026-06-11.

## Round 1 — Recorded in `adversarial-spec-delta-review.md`

### Pass 1 (9 findings)

| Severity | Count | All resolved? |
|----------|-------|---------------|
| HIGH     | 3     | YES           |
| MEDIUM   | 4     | YES           |
| LOW      | 2     | YES           |

**Trajectory:** 9 → 0 (all fixed before Pass 2).

Key fixes: teardown label requirement (F1), positive poll gate + `adf_contains_text`
sanity check preventing vacuous absence assertion (F2), SURFACE registration hard-fact
resolution (F3), inspection channel specified as `poll_view` (F4), code block assertion
added (F6), test name decomposition corrected (F8), ordering dependency documented (F9).

Spec bumped from 1.3.6 → 1.3.7.

### Pass 2 (6 findings)

| Severity | Count | All resolved? |
|----------|-------|---------------|
| CRITICAL | 1     | YES — F1-C1   |
| HIGH     | 1     | YES — F1-H1   |
| MEDIUM   | 2     | YES           |
| LOW      | 2     | YES           |

**Trajectory:** 6 → 0 (all fixed).

Key fix — F1-C1 (CRITICAL): AC-3 assertions were guaranteed live-failures.
`adf_to_text` is a markdown re-emitter: `strong` → `**x**`, `em` → `*x*` (single
asterisk). The prior spec asserted `!stdout_comments.contains("**body**")` (would
always fail) and used `_emphasis_` negative as vacuous differentiator (`em` re-emits
as `*`, never `_`). Resolution: positive assertions now check the re-emitted forms
(`**body**` present, `*emphasis*` present); negative assertion checks `_emphasis_`
absent (raw passthrough would leave underscores — genuine differentiator).

Independent verification: `src/adf.rs:2255-2256` — `em` arm renders `*{inner}*`,
`strong` arm renders `**{inner}**`.

Key fix — F1-H1 (HIGH): rename touch-point list was missing
`docs/specs/e2e-live-jira-testing.md:~123`. Added to both `e2e-coverage-spec.md`
and `prd-delta.md`. Verified by repo-wide grep: exactly 2 hits for
`test_e2e_issue_markdown_description_roundtrip` — `tests/e2e_live.rs:4591` (function
name) and `docs/specs/e2e-live-jira-testing.md:~123` (bullet). Both in touch-point
list.

Spec bumped 1.3.7 → 1.3.8.

## Round 2 — Fresh-Context (Zero-History) Adversary

Three consecutive clean passes (Pass A, Pass B, Pass C). Zero new findings.

| Pass | Findings | Notes |
|------|----------|-------|
| A    | 0        | No findings of any severity |
| B    | 0        | No findings of any severity |
| C    | 0        | No findings of any severity |

Combined trajectory: **0 → 0 → 0** (convergence criterion satisfied).

## Post-Convergence Additive Edit (v1.3.9)

After Round 2 convergence, the research-validated Server-Side ADF Mutation Guardrail
section was added to `e2e-coverage-spec.md`. This was a **purely additive** edit:

- No AC assertion logic changed.
- No AC acceptance conditions tightened or relaxed.
- BC/NFR counts unchanged (594/41).
- Adds five confirmed facts from `.factory/research/issue-475-adf-e2e-external-validation.md`:
  (1) Jira Cloud silently normalizes stored ADF; (2) mandatory constraint — all ACs
  must assert structural invariants or rendered text, never exact-tree snapshots;
  (3) read paths confirmed to return raw ADF (code-verified at
  `src/api/jira/issues.rs:~426,~654`); (4) no `@mentions` in fixtures (GDPR
  non-determinism); (5) no breaking v3/ADF change in 12 months.

Convergence verdict stands. The additive edit strengthens implementer guidance
without altering the acceptance bar.

Spec bumped 1.3.8 → 1.3.9.

## Independent Verification Summary

All cited helpers and line references independently verified:

| Reference | Verified |
|-----------|---------|
| `src/adf.rs:2255-2256` — `em` → `*x*`, `strong` → `**x**` | YES |
| `poll_view` (e2e_live.rs:~474) — exists | YES |
| `adf_has_node_type` (e2e_live.rs:~8950) — exists | YES |
| `adf_contains_text` (e2e_live.rs:~8932) — exists | YES |
| `adf_has_task_item` (e2e_live.rs:~8912) — exists | YES |
| `("issue", "view")` SURFACE row (e2e_cli_surface_guard.rs:73) — exists | YES |
| `("issue", "comment")` SURFACE row (e2e_cli_surface_guard.rs:118) — exists | YES |
| `("issue", "comments")` SURFACE row (e2e_cli_surface_guard.rs:122) — exists | YES |
| Rename grep: exactly 2 hits for old name | YES |
| BC 594 / NFR 41 / bc-7 total_bcs 89 invariant | YES |

## Non-Blocking Observations (No Spec Change Required)

**OBS-1 — comfy-table cell-wrap robustness (pre-existing class):** The human-mode
table rendered by `jr issue view` uses comfy-table. Very long unbroken tokens (URLs,
code identifiers) may wrap or truncate at column width. The AC-1 fixture uses short
content words ("Section Header", "link text", "code snippet", "nested blockquote text")
— all well within typical terminal widths. Risk: LOW. The existing `adf_to_text`
unit tests already cover whitespace handling; this is a display-layer concern, not
an ADF-logic concern. No spec change warranted.

**OBS-2 — `--description-stdin` preferred channel for leading-dash fixtures:** AC-1
uses a `--description-stdin` channel to pass the markdown fixture. This is correct
per the `allow_hyphen_values` gotcha documented in CLAUDE.md: for programmatic/agent
usage where the value may start with a dash (e.g. `- > nested blockquote text`),
`--description-stdin` is the safe channel. No spec change needed — the spec already
specifies `--description-stdin --markdown`.

## Convergence Criterion

Per VSDD F2 protocol: convergence requires three consecutive clean passes (0 findings)
from a fresh-context adversary with no prior Round 1 knowledge. Round 2 achieved this
in Passes A, B, C.

Gate decision: APPROVED 2026-06-11.
Next phase: F3 Story Decomposition.
