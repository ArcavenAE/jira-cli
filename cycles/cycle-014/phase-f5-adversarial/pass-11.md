# F5 Scoped Adversarial — Pass 11

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-011`/PR #905 merged)
- **Scope:** `git diff 204b1fb5..c33f5d44` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891 through `FIX-P5-011` PR #905),
  re-reviewed from fresh context.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-04
- **Convergence counter:** **0 of 3** (NOT CLEAN — counter does not advance). 11 of 15 passes used
  (cap raised from 10 to 15 by `D-403`).
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT** (adversary: 1 MEDIUM + 1 LOW + 1 NIT).
  Security-reviewer returned APPROVE (1 LOW + 1 INFO); code-reviewer returned APPROVE (3 NIT; late
  report, delivered after a full test run).

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | `P11-001` MEDIUM [process-gap]; `P11-002` LOW; `P11-003` NIT |
| **code-reviewer** | APPROVE | `CR11-001`, `CR11-002`, `CR11-003` NIT |
| **security-reviewer** | APPROVE | `SEC11-001` LOW; `SEC11-002` INFO |

## Findings and Dispositions

### adversary findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P11-001` | MEDIUM | **[process-gap]** The BC-INDEX rows for `BC-X.14.002` and `BC-X.14.004` did not mirror their H1s, and nothing guards H1↔index sync. | Instances fixed in `FIX-P5-012` (spec `2.8.8`). The guard script was DEFERRED by `D-406(b)` (240 pre-existing mismatches outside the touched set; CI wiring would touch the CI-gate review-scope files); filed as GitHub #906, standing item `BC-INDEX-H1-SYNC-GUARD`. |
| `P11-002` | LOW | `get_issue_types_for_project` rustdoc said "only" one caller; there are three. | `FIX-P5-012` (product-repo rustdoc) |
| `P11-003` | NIT | `resolve_m2_project` rustdoc said "M2-only"; M3 also calls it. | `FIX-P5-012` (product-repo rustdoc) |

### code-reviewer findings (pass 11) — APPROVE (late report, after a full test run)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR11-001` | NIT | The user-table glyph test used the non-production path. | `FIX-P5-012` (`D-406(a)`) |
| `CR11-002` | NIT | Stale TDD-phase narrative. | `FIX-P5-012` (`D-406(a)`) |
| `CR11-003` | NIT | `force_styling` test seam. | Deferred; already documented. |

### security-reviewer findings (pass 11) — APPROVE

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `SEC11-001` | LOW | Bulk-move results echoes missing from the Canonical Sink Inventory. The product-owner found the premise partly wrong: only `err_msg` is server text; `key` is user input; `status` is a literal. | `FIX-P5-012` spec side (inventory item `(b)` entries, `BC-7.1.006` v1.7.7) |
| `SEC11-002` | INFO | `(b)17` quote text. | `FIX-P5-012` spec side |

## Human decision `D-406` (2026-10-04)

- **(a)** `FIX-P5-012` fixes all Pass 11 items plus the code-review NITs.
- **(b)** The H1↔BC-INDEX guard script is DEFERRED (240 pre-existing mismatches; CI wiring touches
  CI-gate review-scope files). Filed as GitHub issue #906
  (https://github.com/Zious11/jira-cli/issues/906); standing item `BC-INDEX-H1-SYNC-GUARD` -> #906.
- **(c)** NEW PROCESS, human-approved: before each counted pass, run an UNCOUNTED fresh-adversary
  "rehearsal" over the fix branch plus current specs and fix whatever it finds. Three rehearsals
  ran for `FIX-P5-012`:
  - **R12:** 1 LOW + 2 NIT — `(b)9` request-type IDs; `(b)33` errors-value escaping;
    U+2066..206F class names.
  - **R12B:** 1 MEDIUM + 1 LOW + 1 NIT — ADR-0019 never amended for the #861 label fallback, and a
    full ADR-0019 audit found 3 more stale claims plus ADR-0023 drift; ApiError messages are
    control-escaped by `sanitize_for_stderr`, not raw; CHANGELOG residual examples.
  - **R12C:** CLEAN-with-nits, 2 spec nits (fixed) — the BC-X.16.002 `§` anchor quote and the
    EC-21/EC-24 test attributions.
  Lesson recorded in `sidecar-learning.md`.
- **(d)** New standing item `STALE-SECTION-ANCHORS-OUT-OF-SCOPE` (LOW): 5 `§ "..."` comment-anchor
  citations outside cycle-014's touched set whose quoted text does not exist verbatim (ADR-0024 ->
  `edit.rs`; `bc-3-issue-write.md` -> `edit.rs` / `jsm_create.rs` x2; `cross-cutting.md` ->
  `src/file.rs` generic example). Probably descriptive labels, not quotes.

`FIX-P5-012`: PR #907 (https://github.com/Zious11/jira-cli/pull/907), branch
`fix/fix-p5-012-pass11-findings`, head `e296c34a`, review in progress. Spec `2.8.8`
(`BC-7.1.006` v1.7.7: inventory `(b)1-7/9/16/17/24/29/33-36`, `EC-21`/`EC-24`; ADR-0019/ADR-0023
reconciled). Record: `FIX-P5-012-spec-delta.md`, `FIX-P5-012-h1-sync-baseline.txt`.

## Pass Budget

Cap 15; 11 used; 4 remain (12-15). 3 consecutive clean are needed, so at most 1 more non-clean
pass can occur before convergence becomes impossible; escalate to the human at that point.
Rehearsals (`D-406(c)`) are uncounted and precede each counted pass.

## Status

Pass 11 is **NOT CLEAN**. Clean-pass counter **0/3** (cap 15; 11 used).
