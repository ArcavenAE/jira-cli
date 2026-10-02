# F5 Scoped Adversarial — Pass 5

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-005`/PR #897 merged)
- **Scope:** `git diff 204b1fb5..0a4dc062` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891, `FIX-P5-002` PR #894,
  `FIX-P5-003` PR #895, `FIX-P5-004` PR #896, `FIX-P5-005` PR #897), re-reviewed from fresh context.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-02
- **Convergence counter:** **0 of 3** (NOT CLEAN — counter does not advance). 5 of 10 passes used.
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT** (adversary). Code-reviewer and
  security-reviewer both returned APPROVE.
- **Novelty assessment:** LOW. Adversary's note: "code in this delta has effectively converged;
  residuals are help/doc wording". Finding severity has decayed to LOW/NIT-only for passes 3-5.

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | `P5-001` LOW, `P5-002`..`P5-005` NIT |
| **code-reviewer** | APPROVE | `CR5-001`..`CR5-003` NIT |
| **security-reviewer** | APPROVE | `SEC5-001` LOW (CWE-451), `SEC5-002` INFO (CWE-116) |

## Findings and Dispositions

### adversary findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P5-001` | LOW | The `jr field options <FIELD>` help text omits system field IDs (functional support landed in `FIX-P5-005`, help not updated). | `FIX-P5-006` (help text + pin test) |
| `P5-002` | NIT | Stale rustdoc cross-references ("EC-1..EC-13", "both callers"). | `FIX-P5-006` |
| `P5-003` | NIT | The mutants rationale for `output.rs` predates this cycle. | `FIX-P5-006` (merged with `CR5-003`) |
| `P5-004` | NIT | Drifted line refs in `EC-X.14.001-15`. | `FIX-P5-006` (spec symbol-form citations; spec delta already authored) |
| `P5-005` | NIT | `user_list_requires_project_flag` is redundant. | `FIX-P5-006` |

### code-reviewer findings (pass 5)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR5-001` | NIT | Run-on rustdoc parentheticals. | `FIX-P5-006` |
| `CR5-002` | NIT | `SPEC_CF_RANGES` is a transcription pin, not an independent oracle. | `FIX-P5-006` (document as a transcription pin) |
| `CR5-003` | NIT | Same as `P5-003`. | `FIX-P5-006` (merged with `P5-003`) |

### security-reviewer findings (pass 5)

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `SEC5-001` | LOW (CWE-451) | Blank-rendering non-`Cf` characters kept (U+2800, U+17B4/U+17B5, U+FFFC, `Zs`). | ACCEPTED RESIDUAL (`D-400`, `BC-7.1.006` `EC-24`). Policy stays category-based; the character list is not extended per pass. |
| `SEC5-002` | INFO (CWE-116) | `search_field_list` ambiguity errors echo raw server name/id into `UserError` (stderr + JSON). | `FIX-P5-006` (sanitize candidates via `sanitize_terminal_line`) |

Provenance note: the security-reviewer checked `CF_RANGES` from memory only, while offline; the
product-owner had verified it against the UCD 17.0.0 files.

## `FIX-P5-006` Scope (DECIDED 2026-10-02, `D-400`)

Human decision `D-400`:

- **(a) Scope is ALL Pass 5 findings:** `P5-001` (help text + pin test), `SEC5-002`
  (sanitize field ambiguity candidates via `sanitize_terminal_line`), and all NITs
  including `P5-004` (spec symbol-form citations).
- **(b) `SEC5-001` is an ACCEPTED RESIDUAL** (`BC-7.1.006` `EC-24`). The policy stays
  category-based (`Cf` + named extras); the human chose to stop extending the character
  list per pass.

Spec delta (committed with this burst): `FIX-P5-006-spec-delta.md`, `BC-7.1.006` v1.6.2
(`EC-24`), `cross-cutting.md` (`EC-X.14.004-9`, `EC-X.14.001-22`, `EC-X.14.001-15`
symbol-form citation), spec-changelog `[2.7.2]`. Delivery: worktree `.worktrees/FIX-P5-006`,
branch `fix/fix-p5-006-pass5-findings`, base `0a4dc062`. After merge: post-merge spec
conversion, then Pass 6.

## Status

Pass 5 is **NOT CLEAN**. Clean-pass counter **0/3** (10-pass cap; 5 used).
