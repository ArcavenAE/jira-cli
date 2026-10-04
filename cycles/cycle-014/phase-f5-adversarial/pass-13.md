# F5 Scoped Adversarial — Pass 13

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-014`/PR #909 merged)
- **Scope:** `git diff 204b1fb5..0a579ad5` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891 through `FIX-P5-014` PR #909),
  re-reviewed from fresh context.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-04
- **Convergence counter:** **2 of 3** (CLEAN — counter advances 1 -> 2). 13 of 15 passes used
  (cap raised from 10 to 15 by `D-403`).
- **Pass verdict:** **CLEAN** (adversary CLEAN-with-nits, novelty LOW, "the delta has converged";
  code-reviewer APPROVE, CONVERGENCE_REACHED; security-reviewer APPROVE, zero findings). NIT-only
  findings count as CLEAN under the strict rule per `D-407(a)`.

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | CLEAN-with-nits (novelty LOW) | `P13-001` NIT (plus a secondary) |
| **code-reviewer** | APPROVE, CONVERGENCE_REACHED | `CR13-001` NIT |
| **security-reviewer** | APPROVE | none |

## Findings and Dispositions

### adversary findings — CLEAN-with-nits

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P13-001` | NIT | The `src/cli/field.rs::handle` rustdoc says mode HTTP runs in every mode that gets past field resolution. But for M2/M3, `resolve_m2_project(...).ok_or_else(...)?` runs first and can exit 64 with zero mode HTTP. This is pinned by `test_bc_x_14_004_m2_no_resolvable_project_exits_64_widened_message` and `test_bc_x_14_004_m3_no_resolvable_project_exits_64` (expect_zero_http). | `FIX-P5-015` (`D-407(b)`), comment/rustdoc only |
| `P13-001` (secondary) | NIT | "M3 request-type calls" omits `require_service_desk`'s project-meta/service-desk HTTP on a cache miss. | `FIX-P5-015` (`D-407(b)`), comment/rustdoc only |

### code-reviewer findings — APPROVE (CONVERGENCE_REACHED)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR13-001` | NIT | The same rustdoc says `GET /field` fires when the cache is "missing or unreadable". But `cache::read_cache` returns Ok(None) only for NotFound, unparseable, or stale. Other I/O errors (e.g. EACCES) propagate as Err with no refetch. The orchestrator verified this in `src/cache.rs`. | `FIX-P5-015` (`D-407(b)`), comment/rustdoc only |

Note: the code-reviewer's `cargo` run timed out while compiling. Its review was static plus the
repo guard scripts (all pass).

### security-reviewer findings — APPROVE, zero findings

- `CF_RANGES` was mechanically verified against Python `unicodedata` (no Cf missing, no non-Cf
  included).
- The completeness claim held: no unlisted server/config echo.

## Disposition: `FIX-P5-015` (`D-407(b)`, fix NITs now)

Comment-only fix to the `handle` rustdoc covering `P13-001` and `CR13-001`.

**Approach: SIMPLIFY** the rustdoc to a high-level effects summary that defers details to
`resolve_field_id` and each mode arm. **Rationale:** the exhaustive effects list has drifted three
passes in a row (`P12-001`, PR #909 `NB-1`, `P13-001`/`CR13-001`); enumerating a callee's full effect
matrix in a caller's rustdoc is the drift source, so remove the enumeration rather than correct it a
fourth time. Lesson recorded in `sidecar-learning.md`: "Don't enumerate a function's full effect
matrix in a caller's rustdoc; summarize and defer to the callee's own docs".

## Pass Budget

Cap 15; 13 used; 2 remain (14-15). Counter 2/3: **ZERO slips left.** Pass 14 must be clean to
converge (12, 13, 14); Pass 15 is then unused. A non-clean Pass 14 makes 3 consecutive clean
passes impossible within the cap (escalate to the human for `D-408`). Rehearsals (`D-406(c)`) are
uncounted and precede each counted pass.

## Status

Pass 13 is **CLEAN**. Clean-pass counter **2/3** (cap 15; 13 used). `FIX-P5-015` (comment/rustdoc
only) in delivery; next: PR, CI, human merge, then counted Pass 14 over the post-fix develop tip.
If Pass 14 is clean, F5 CONVERGES (3/3: passes 12, 13, 14) and the cycle moves to F6.
