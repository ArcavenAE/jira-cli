---
document_type: f5-convergence-record
issue: "#492"
bc: "BC-7.2.011"
bc_version: "v1.9.6"
frozen_sha: "8062b78"
factory_artifacts_sha: "87e3c53"
date: 2026-06-16
passes: 15
fix_rounds: 6
clean_passes: 3
status: CONVERGED
---

# F5 Scoped Adversarial Convergence Record — Issue #492

## Summary

**Issue #492:** fix(adf): block-HTML interior newlines should map to ADF `hardBreak`
nodes (Algorithm B), not be preserved as literal raw-`\n` chars (which violate the
adf.rs file-wide newline-free invariant).

**Result:** CONVERGED — 15 fresh-context adversarial passes, 6 fix rounds, final 3
consecutive CLEAN passes on frozen artifact `8062b78` + BC-7.2.011 v1.9.6 @ `87e3c53`.
ZERO production-code defects found. Every finding was doc/spec precision
(severity decayed M→L→0 across the cycle).

## Frozen Artifacts

| Artifact | Identity |
|----------|----------|
| Worktree branch | `fix/adf-block-html-hardbreak-492` |
| Frozen SHA (code + tests) | `8062b78` (pushed to origin; PR #521 OPEN, base: develop) |
| BC-7.2.011 | v1.9.6 @ factory-artifacts `87e3c53` |
| BC-7.2.011 spec path | `.factory/specs/behavioral-contracts/bc-7.2.011-adf-block-html.md` |
| Spec doc | `docs/specs/adf-block-html.md` |
| PR | #521 (OPEN — base: develop, CI running) |

## BC Version Trail (this cycle)

| Version | Event |
|---------|-------|
| v1.9.1 | F2 spec evolution CONVERGED (frozen at factory-artifacts `634cb88`) |
| v1.9.2 | F4 TDD implementation: Step-4.5 fix — added Algorithm B step 5b label clarification |
| v1.9.3 | F5 Pass 2 fix: BC line-number citations → symbol-form citations (F-P2-002) |
| v1.9.4 | F5 Pass 3 fix: Source/Trace extended to cover 2 additional block-HTML tests (F-P3-001) |
| v1.9.5 | F5 Pass 8 fix: resolved self-contradicting forward/reverse loss grouping in BC body + spec doc; fixed stale BC-INDEX line citation (F-P8-001/002) |
| v1.9.6 | F5 Pass 10 fix: added EC-6 defense-in-depth note for parity; corrected rustdoc attribution #492→#489 (F-P10-001/002) |

## Pass Log

### Pass 1 — [FINDINGS: 3]

| Finding | Severity | Description | Resolution |
|---------|----------|-------------|------------|
| F-P1-001 | LOW | Spec step-5b label inconsistency between body and summary | Fixed in F4 Step-4.5 (pre-Pass 1; carried into frozen artifact) |
| F-P1-002 | LOW | Interior-line URL autolink test missing in test suite | Added test `test_block_html_interior_url_gets_hardbreak_not_autolinked` |
| F-P1-003 | PROCESS-GAP | Handler-level block-HTML tests couple to `push_text` accumulation shape (EC-6/7/8/9/10 use AdfBuilder directly) | No code change — tracked as drift item `#492-TEST-HARNESS-COUPLING` for cycle-close codification |

### Pass 2 — [FINDINGS: 2]

| Finding | Severity | Description | Resolution |
|---------|----------|-------------|------------|
| F-P2-001 | LOW | Spec step/step-5b label drift from pass-1 fix not propagated to spec doc | Fixed — spec doc updated to match BC |
| F-P2-002 | MED | BC citations used line numbers (fragile) instead of symbol-form | Fixed in BC v1.9.3 — all citations converted to `<file>::<fn>` symbol form |

### Pass 3 — [FINDINGS: 1]

| Finding | Severity | Description | Resolution |
|---------|----------|-------------|------------|
| F-P3-001 | MED | BC Source/Trace omitted 2 block-HTML tests that exercise the hardBreak split path | Fixed in BC v1.9.4 — Trace extended to cover `test_block_html_url_hardbreak_path` + `test_block_html_interior_url_gets_hardbreak_not_autolinked` |

### Passes 4–5 — [CLEAN]

No actionable findings. Adversary noted residual LOW wording items accepted as-is.

### Pass 6 — [FINDINGS: 1]

| Finding | Severity | Description | Resolution |
|---------|----------|-------------|------------|
| F-P6-001 | LOW | Spec doc contained full GitHub URLs instead of short-form `#NNN` references | Fixed — all GitHub URLs converted to `#NNN` citation form |

### Passes 7 — [CLEAN]

No actionable findings.

### Pass 8 — [FINDINGS: 2]

| Finding | Severity | Description | Resolution |
|---------|----------|-------------|------------|
| F-P8-001 | MED | BC body and spec doc contained self-contradicting forward/reverse loss grouping (forward said "lossless" then listed lossy paths; reverse grouping inverted) | Fixed in BC v1.9.5 + spec doc — loss/lossless groupings reconciled and made consistent throughout |
| F-P8-002 | LOW | BC-INDEX cited stale line numbers for BC-7.2.011 entry | Fixed in BC v1.9.5 — BC-INDEX line citation updated to symbol-form anchor |

### Passes 9 — [CLEAN]

No actionable findings.

### Pass 10 — [FINDINGS: 3]

| Finding | Severity | Description | Resolution |
|---------|----------|-------------|------------|
| F-P10-001 | LOW | Rustdoc in `adf.rs` mis-attributed the block-HTML asymmetry closure to issue #492 instead of #489 | Fixed — attribution corrected to `#489` (block-HTML was already preserved via `Event::InlineHtml`; #492 closes the block/inline asymmetry) |
| F-P10-002 | LOW | BC EC-6 lacked a defense-in-depth note explaining the handler-level test coupling (parity with other EC entries) | Fixed in BC v1.9.6 — EC-6 entry extended with defense-in-depth note |
| F-P10-003 | LOW | Spec doc referred to "7-step algorithm" but the Algorithm B section header said "canonical step order" — terminology mismatch | Fixed — spec doc unified on "canonical step order" phrasing |

### Passes 11–12 — [CLEAN]

No actionable findings.

### Pass 13 — DEEP CROSS-CONSISTENCY [CLEAN]

Full cross-consistency pass: BC-7.2.011 vs spec doc vs CLAUDE.md vs tests vs rustdoc.
One non-actionable observation recorded:

| Observation | Adversary verdict |
|-------------|-------------------|
| F-P13-001: CLAUDE.md "block-HTML" gotcha condenses steps 5/5b — appeared to omit step 5b | "Faithful condensation — CLAUDE.md is a quick-reference, not an executable spec. No change required." |

### Pass 14 — HOLISTIC + TRACEABILITY + COUNTS [CLEAN]

Holistic pass covering: full BC body, EC coverage, Source/Trace completeness,
count consistency (BC 598 / bc-7 90/44 / Stories 75), PR #521 diff scope.
Zero actionable findings.

### Pass 15 — ROBUSTNESS + COMPLETENESS [CLEAN] (CONVERGENCE DECLARED)

Robustness and completeness pass: edge cases, Algorithm B corner cases, reverse-path
integrity, REQUIRES_CONTENT cross-ref, test suite completeness.
One non-actionable observation:

| Observation | Adversary verdict |
|-------------|-------------------|
| F-P15-001: REQUIRES_CONTENT cross-reference completeness | "Confirmed consistent with BC body and implementation. No change required." |

**CONVERGENCE DECLARED** — 3 consecutive CLEAN passes (13 deep cross-consistency,
14 holistic+traceability+counts, 15 robustness+completeness) on frozen `8062b78` /
BC-7.2.011 v1.9.6 @ `87e3c53`.

## Findings Burndown

| Pass | Open | Delta | Notes |
|------|------|-------|-------|
| 0 (start) | 0 | — | Frozen BC v1.9.1 entering F5 |
| 1 | 3 | +3 | F-P1-001, F-P1-002, F-P1-003 |
| 2 | 2 | -1 +2 | Closed P1-001; opened P2-001, P2-002 |
| 3 | 1 | -2 +1 | Closed P2-001/002; opened P3-001 |
| 4 | 0 | -1 | Closed P3-001; CLEAN |
| 5 | 0 | 0 | CLEAN |
| 6 | 1 | +1 | F-P6-001 |
| 7 | 0 | -1 | Closed P6-001; CLEAN |
| 8 | 2 | +2 | F-P8-001, F-P8-002 |
| 9 | 0 | -2 | Closed P8-001/002; CLEAN |
| 10 | 3 | +3 | F-P10-001, F-P10-002, F-P10-003 |
| 11 | 0 | -3 | Closed all; CLEAN |
| 12 | 0 | 0 | CLEAN |
| 13 | 0 | 0 | CLEAN (cross-consistency; F-P13-001 non-actionable) |
| 14 | 0 | 0 | CLEAN (holistic+traceability+counts) |
| 15 | 0 | 0 | CLEAN — CONVERGED (F-P15-001 non-actionable) |

## Counts (unchanged by F5)

| Metric | Value |
|--------|-------|
| Total BCs | 598 |
| BC section 7 total | 90 |
| BC section 7.2 | 44 |
| Stories | 75 |

No count changes in F5 — all changes were doc/spec precision within existing BC-7.2.011.

## Next Step

**F6 Targeted Hardening** — review PR #521 diff for any hardening opportunities
(property tests, additional edge-case coverage, mutation kill confirmation).
