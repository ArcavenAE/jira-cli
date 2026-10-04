# F5 Scoped Adversarial — Pass 12

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-013`/PR #908 merged)
- **Scope:** `git diff 204b1fb5..eb52643b` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891 through `FIX-P5-013` PR #908),
  re-reviewed from fresh context.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-04
- **Convergence counter:** **1 of 3** (CLEAN — counter advances 0 -> 1; the first clean counted
  pass). 12 of 15 passes used (cap raised from 10 to 15 by `D-403`).
- **Pass verdict:** **CLEAN** (adversary CLEAN-with-nits, novelty LOW, "the delta has converged";
  code-reviewer APPROVE; security-reviewer APPROVE). NIT-only findings count as CLEAN under the
  strict rule per `D-407(a)`.

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | CLEAN-with-nits (novelty LOW) | `P12-001` NIT; `P12-002` NIT |
| **code-reviewer** | APPROVE | `CR12-001` NIT; `CR12-002` NIT |
| **security-reviewer** | APPROVE | `SEC12-001` LOW/INFO (test coverage only); `SEC12-002` INFO (rejected, false positive) |

## Findings and Dispositions

### adversary findings — CLEAN-with-nits

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P12-001` | NIT | The `src/cli/field.rs::handle` rustdoc misstates where HTTP and cache access happen. The M1 arm does HTTP too, and every mode reads and writes the `fields.json` cache via `resolve_field_id`. | `FIX-P5-014` (`D-407(b)`), comment/rustdoc only |
| `P12-002` | NIT | The `tests/field_options.rs::test_bc_x_14_004_m3_no_resolvable_project_exits_64` comment says "M2 M1" where it should say "M2". | `FIX-P5-014` (`D-407(b)`), comment only |

### code-reviewer findings — APPROVE

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR12-001` | NIT | Three over-long `///` lines in `field.rs` (the `field_not_available_*` / `field_not_on_edit_screen_msg` docs). | `FIX-P5-014` (`D-407(b)`) |
| `CR12-002` | NIT | The `field_not_found_msg` hint points at `jr project fields`. This is the already-tracked `FIELD-OPTIONS-NOTFOUND-HINT` drift. | Stays a tracked drift (`D-407(c)`); not fixed |

### security-reviewer findings — APPROVE

The security-reviewer independently re-swept the server/config echo completeness claim and found
no unlisted site.

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `SEC12-001` | LOW/INFO (CWE-451, test coverage only) | `tests/table_output_sanitization.rs::assert_no_esc_or_c1` checks only ESC/C1 at the integration level, not Cf/bidi. | Standing item `INTEGRATION-SANITIZE-ASSERT-CF-BIDI` (`D-407(c)`) |
| `SEC12-002` | INFO | REJECTED as a false positive. The reviewer cited a stale CLAUDE.md ("ends at line 741" / "627 LOC"). The orchestrator grepped the on-disk CLAUDE.md and neither string is present. | None — false positive |

## Human decision `D-407` (2026-10-04)

- **(a)** A NIT-only pass counts as CLEAN under the strict rule. This is the first NIT-only counted
  pass, so `D-407` defines it: the strict rule means no BLOCKING/MEDIUM/LOW findings, and NITs
  alone do not break a clean pass.
- **(b)** Fix the NITs NOW in a tiny comment/rustdoc-only PR, `FIX-P5-014`, covering `P12-001`,
  `P12-002` and `CR12-001`. Passes 13 and 14 then review the post-fix develop tip.
- **(c)** `CR12-002` stays a tracked drift (`FIELD-OPTIONS-NOTFOUND-HINT`). `SEC12-001` is added to
  `cycles/OPEN-STANDING-ITEMS.md` as standing item `INTEGRATION-SANITIZE-ASSERT-CF-BIDI` (extend
  `assert_no_esc_or_c1` to reject Cf/bidi/tag chars, or add one end-to-end bidi fixture per covered
  sink family).

## Pass Budget

Cap 15; 12 used; 3 remain (13-15). Counter 1/3: Passes 13 and 14 must also be clean, with Pass 15
the only spare. Still at most 1 slip; escalate to the human if a non-clean pass occurs.
Rehearsals (`D-406(c)`) are uncounted and precede each counted pass.

## Status

Pass 12 is **CLEAN**. Clean-pass counter **1/3** (cap 15; 12 used). `FIX-P5-014` (comment/rustdoc
only) in delivery; next: PR, CI, human merge, then counted Pass 13 over the post-fix develop tip.
