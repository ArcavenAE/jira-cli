# F5 Scoped Adversarial — Pass 8

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-008`/PR #901 merged)
- **Scope:** `git diff 204b1fb5..b9ae0862` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891, `FIX-P5-002` PR #894,
  `FIX-P5-003` PR #895, `FIX-P5-004` PR #896, `FIX-P5-005` PR #897, `FIX-P5-006` PR #898,
  `FIX-P5-007` PR #899, `FIX-P5-008` PR #901), re-reviewed from fresh context.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-02
- **Convergence counter:** **0 of 3** (NOT CLEAN — counter does not advance). 8 of 15 passes used
  (cap raised from 10 to 15 by `D-403`).
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT** (adversary: 3 LOW + 6 NIT). Code-reviewer and
  security-reviewer both returned APPROVE.
- **Novelty assessment:** LOW. Adversary's note: "code and tests in the delta have converged;
  findings are doc/spec anchoring".

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | `P8-001`..`P8-003` LOW; 6 NITs |
| **code-reviewer** | APPROVE | `CR8-001`..`CR8-003` NIT (all DEFERRED) |
| **security-reviewer** | APPROVE | `SEC8-001` LOW |

## Findings and Dispositions

### adversary findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P8-001` | LOW | `BC-X.16.001`/`BC-X.16.002` and `BC-X.7.002` still say "to be implemented"; `BC-X.16.002` Postcondition 1 has line anchors ~87 lines off. | `FIX-P5-009` (`D-403`) |
| `P8-002` | LOW | Canonical Sink Inventory residual `(b)11` omitted `map_issue_not_found`'s issue-key echo and `field_not_available_for_type_msg`'s `project_key` echo. | `FIX-P5-009` |
| `P8-003` | LOW | The `cargo-mutants-policy` `field.rs` rationale is stale. | `FIX-P5-009` |
| NIT | NIT | CHANGELOG says "Both" where there are three. | `FIX-P5-009` |
| NIT | NIT | CHANGELOG Cf-stripping claim is overstated. | `FIX-P5-009` |
| NIT | NIT | `field_options.rs` module doc is stale. | `FIX-P5-009` |
| NIT | NIT | An order-dependent JSON test. | `FIX-P5-009` |
| NIT | NIT | The color-gate's home is misnamed in prose. | `FIX-P5-009` |
| NIT | NIT | README `field options` row is missing system IDs. | `FIX-P5-009` |

### code-reviewer findings (pass 8) — APPROVE, all DEFERRED

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR8-001` | NIT | `user.rs` Active column is identified by header-string match; suggests a const index. | DEFERRED -> `OPEN-STANDING-ITEMS.md` |
| `CR8-002` | NIT | `print_output_with_styles` duplicates `print_output`'s dispatch, and `force_styling` is a test-only parameter in a production signature. | DEFERRED -> `OPEN-STANDING-ITEMS.md` |
| `CR8-003` | NIT | `CF_RANGES`/`SPEC_CF_RANGES` are not an independent oracle; suggests a dev-dependency-generated fixture. | DEFERRED -> `OPEN-STANDING-ITEMS.md` |

Deferred because they do not affect the strict clean-pass verdict and new code churn adds review surface.

### security-reviewer findings (pass 8) — APPROVE

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `SEC8-001` | LOW | `(b)11` called `project_key` "user-typed", but it can come from repo `.jr.toml`/profile config. | `FIX-P5-009` |

## Orchestrator escalation (per `D-402`)

Per `D-402`, a non-clean Pass 8 meant F5 could not converge within the 10-pass cap, so the
orchestrator stopped and escalated to the human. Observation: since Pass 4 there has been no code
or security finding; every finding is doc/spec drift in a ~7.5k-line, 25-file delta.

## Human decision `D-403` (2026-10-02)

- The 10-pass cap was REACHED WITHOUT CONVERGENCE; the human chose to EXTEND it.
- F5 pass cap RAISED from 10 to **15**. STRICT clean-pass rule KEPT: 3 consecutive clean
  adversarial passes required.
- `FIX-P5-009` fixes ALL Pass 8 adversary/security findings and NITs.
- Orchestrator additions to `FIX-P5-009`:
  - a complete spec audit of every cycle-014 BC (~30 spec/code mismatches fixed; Canonical Sink
    Inventory made complete for all delta `src` files, residuals `(b)17`-`(b)24` added);
  - a whole-section product-prose audit;
  - a small code fix: `disambiguate_user`'s echoed `name` is sanitized for echo only (matching
    stays on the raw value), moving it from residual `(b)12` to covered `(a)4`. Spec `EC-25` is
    pre-staged.
- Delivery: worktree `.worktrees/FIX-P5-009`, branch `fix/fix-p5-009-pass8-findings`, base
  `b9ae0862`. Then PR -> human merge -> post-merge spec conversion (`EC-25`/`(a)4` live) -> Pass 9.

## Product-owner spec work (uncommitted, committed with this burst)

`specs/prd/cross-cutting.md`; `specs/prd/bc-7-output-render.md` (`BC-7.1.006` v1.7.4,
`EC-19`/`EC-21`/`EC-22`/`EC-23` pin-scope notes, `EC-25`, inventory `(a)`/`(b)` changes);
`specs/prd/BC-INDEX.md`; `specs/prd/edge-case-catalog.md`; `specs/prd/error-taxonomy.md`;
`spec-changelog.md` `[2.8.4]`; `cycles/cycle-014/phase-f5-adversarial/FIX-P5-009-spec-delta.md`;
plus hook-stamped files.

## Pass Budget

Cap 15; 8 used; 7 remain (9-15). 3 consecutive clean are needed, so at most 4 more non-clean
passes can occur before convergence becomes impossible; escalate to the human at that point.

## Status

Pass 8 is **NOT CLEAN**. Clean-pass counter **0/3** (cap 15; 8 used).
