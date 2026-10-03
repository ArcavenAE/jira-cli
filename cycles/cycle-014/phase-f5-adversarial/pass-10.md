# F5 Scoped Adversarial — Pass 10

- **Cycle:** cycle-014 (`issue-triage-quickfixes`)
- **Phase:** F5 scoped adversarial review (delta loop resumed after `FIX-P5-010`/PR #903 merged)
- **Scope:** `git diff 204b1fb5..b2b8ee3b` — the combined cycle-014 delta (STORY-A PR #886,
  STORY-C PR #887, STORY-B PR #888, `FIX-P5-001` PR #891 through `FIX-P5-010` PR #903),
  re-reviewed from fresh context.
- **Reviewers dispatched (3, fresh context):** adversary, code-reviewer, security-reviewer.
- **Date:** 2026-10-03
- **Convergence counter:** **0 of 3** (NOT CLEAN — counter does not advance). 10 of 15 passes used
  (cap raised from 10 to 15 by `D-403`).
- **Pass verdict:** **NOT CLEAN — FINDINGS_PRESENT** (adversary: 1 MEDIUM + 2 NIT). Code-reviewer
  returned APPROVE (2 NIT); security-reviewer returned APPROVE with ZERO findings.

## Reviewer Verdicts

| Reviewer | Verdict | Findings |
|---|---|---|
| **adversary** | FINDINGS_PRESENT | `P10-001` MEDIUM; `N1` NIT; `N2` NIT |
| **code-reviewer** | APPROVE | `CR10-001`, `CR10-002` NIT |
| **security-reviewer** | APPROVE | ZERO findings |

## Findings and Dispositions

### adversary findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `P10-001` | MEDIUM | Spec-to-code contradiction. `BC-X.14.001` Invariant 3 claimed `src/cli/field.rs` and `src/cli/issue/field_resolve.rs` are mirrored copies ("a change to one must be mirrored"), but `D-399` added the field-ID step, `FIELD_ID_HINT` and sanitization to `field.rs` only. User-visible effect: `jr field options fixVersions` resolves while `jr issue edit --field fixVersions=` exits 64. **[process-gap]** (item `#53`): no mechanical parity guard between the hand-copied resolvers. | Sent to research at the human's request (`research/P10-001-field-resolution-divergence.md`); resolved by `D-405` option (a) (below) |
| `N1` | NIT | CHANGELOG `Cf` entry omits the `EC-24` kept set. | `FIX-P5-011` (product-repo docs) |
| `N2` | NIT | CLAUDE.md tree says `component.rs` ~1066 LOC vs ~1,800 in the size-deviation entry. | `FIX-P5-011` (product-repo docs) |

### code-reviewer findings (pass 10) — APPROVE

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| `CR10-001` | NIT | Stale CLAUDE.md tree comments for `user.rs` / `api.rs`. | `FIX-P5-011` (product-repo docs) |
| `CR10-002` | NIT | `field.rs` builder rustdoc should say only `field_id` is sanitized. | `FIX-P5-011` (product-repo rustdoc) |

### security-reviewer findings (pass 10) — APPROVE, ZERO findings

The security-reviewer independently confirmed the `D-404` split completeness claim: server/config
echoes are complete for the changed files.

## Research and human decision `D-405` (2026-10-03)

The human asked for `P10-001` to go to research. Report:
`.factory/research/P10-001-field-resolution-divergence.md`. Recommendation **(a)**, spec-only:

- Mirroring (option b) barely helps: the `--field` type dispatch rejects array/system-typed fields
  (`D-379`), so the finding's own example (`fixVersions`) still fails after mirroring.
- Write-path silent-retarget risk: a field-ID/substring step on `--field` could silently retarget a
  write at a different field.
- "Mirrored" was never a human decision (it was a spec description of then-current code).
- Convergence cost: `field_resolve.rs` has ~26 unsanitized echoes and would enter the changed-file
  set, putting the `D-404` completeness claim back in play.

The orchestrator verified there are no GitHub issues requesting the feature.

**`D-405` (human):** option (a). `BC-X.14.001` Invariant 3 is reworded: the `customfield_` bypass,
cache-first load/fetch and refresh-once contract are shared semantics that must be applied to both
resolvers; the search step deliberately diverges (`jr field options`: field-ID step +
`FIELD_ID_HINT` + sanitization; `--field`: name-only), rationale recorded, and a change to the
search step need not be mirrored. At the human's request GitHub issue **#904**
(https://github.com/Zious11/jira-cli/issues/904, label `enhancement`) was filed for option (c): a
unified shared field-search function with collision-safe write-path behavior, paired with `D-379`.
Recorded as standing item `FIELD-ID-RESOLUTION-UNIFY` -> #904 in `OPEN-STANDING-ITEMS.md`.

`FIX-P5-011`: worktree `.worktrees/FIX-P5-011`, branch `fix/fix-p5-011-pass10-findings`, base
`b2b8ee3b`. The product side is docs only (`N1`, `N2`, `CR10-001`, `CR10-002`). Spec `2.8.7`
(`BC-X.14.001` Invariant 3 and surrounding prose; COUNT-NEUTRAL). Then PR -> human merge -> Pass 11.

## Product-owner spec work (uncommitted, committed with this burst)

`specs/prd/cross-cutting.md` (Invariant 3, the Behavior paragraph, the Source line, the SUPERSEDED
marker on the dated F2 trace); `specs/prd/BC-INDEX.md`; `spec-changelog.md` `[2.8.7]`;
`cycles/cycle-014/phase-f5-adversarial/FIX-P5-011-spec-delta.md`; plus hook-stamped files.

## Pass Budget

Cap 15; 10 used; 5 remain (11-15). 3 consecutive clean are needed, so at most 2 more non-clean
passes can occur before convergence becomes impossible; escalate to the human at that point.

## Status

Pass 10 is **NOT CLEAN**. Clean-pass counter **0/3** (cap 15; 10 used).
