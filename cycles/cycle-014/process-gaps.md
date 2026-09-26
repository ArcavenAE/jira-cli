---
document_type: process-gaps
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-26T00:01:34Z
cycle: "cycle-014-issue-triage-quickfixes"
inputs: [STATE.md]
input-hash: "15d9bce"
traces_to: STATE.md
---

# Process-Gap Candidates — cycle-014 (issue-triage-quickfixes)

Candidates for the S-7.02 cycle-closing checklist, recorded during the F2
CYCLE-014-F2-CHECKPOINT burst (2026-09-25/26, F2 IN PROGRESS, not yet
dispositioned — dispositioning happens at cycle close per S-7.02).

1. **`scripts/check-bc-citation-symbols.sh` does not scan `cross-cutting.md`** —
   the guard's glob is `bc-*.md` only; every new/amended citation added to
   `cross-cutting.md` this cycle was written to resolve against real `src/`
   symbols by hand, with no mechanical check backing that claim. Candidate:
   extend the guard's glob, or add a sibling guard scoped to `cross-cutting.md`.

2. **Partial-fix propagation** — corrections made during the F2 adversarial
   spec-delta review repeatedly reached the BC body but not its sibling
   summary surfaces (index rows, changelog entries, canonical-counts blocks),
   requiring later passes to re-discover and re-fix the same drift on a
   different surface. Candidate: a per-fix propagation checklist (BC body →
   INDEX row → CANONICAL-COUNTS → changelog) enforced before a pass is
   declared clean.

3. **The vsdd-factory hook fails closed with `FUEL_EXHAUSTED` on edits** — this
   is a resource cap (fuel budget exhaustion), not a content-validation
   failure, yet it surfaces identically to a real block (`block_intent=true`,
   exit code 2) from `validate-factory-path-root`/`validate-input-hash`/
   `validate-template-compliance`. Observed live during this F2 checkpoint
   burst on plain `Edit` calls. Candidate: raise the fuel cap for known-large
   payload files, or distinguish resource-exhaustion blocks from
   content-validation blocks in the hook's reported reason string.

4. **A whole-file Python rewrite by an agent duplicated `cross-cutting.md`** —
   detected only via a heading-count check (`grep -c '^#### BC-'`), not by any
   structural guard. Candidate: a guard that rejects a rewrite producing a
   duplicate `#### BC-` heading, or a policy steering agents away from
   whole-file rewrites of `cross-cutting.md` in favor of targeted edits.

5. **`JR_AUTH_HEADER` is missing from `CLAUDE.md`'s `JR_*` seam table** — it is
   documented in `docs/specs/e2e-live-jira-testing.md` but not in the
   top-level table alongside the other `JR_*` seams. Candidate: add a row (or
   a cross-reference note) to the `JR_*` table for E2E-only env vars that live
   outside the debug-build test-seam family.

6. **No guard for the `BC-INDEX.md` Coverage Statistics table or the
   `CANONICAL-COUNTS.md` Breakdown block** — `scripts/check-bc-cumulative-counts.sh`
   checks the 8 documented surfaces but not these two supplementary blocks,
   which can drift silently. Candidate: extend the cumulative-counts guard to
   cover both blocks, or document them as explicitly out of guard scope.

7. **No story owned `README.md` doc-delta obligations** — cycle-014's three
   stories (#862/#583/#861) changed CLI behavior but none was assigned
   responsibility for a corresponding `README.md` update, and the
   pre-existing `README-JR-API-BODY-FLAG` drift item (registered this burst)
   went unnoticed until an ad hoc pass-30 finding. Candidate: add a
   README-delta checklist item to the story template for any story that
   changes CLI-visible behavior.

8. **No CI check compares `docs/specs/cargo-mutants-policy.md`'s "Current
   examine_globs count" line with `.cargo/mutants.toml`** — the count is
   maintained by hand and can drift from the actual file. Candidate: a small
   guard script (mirroring `tests/mutants_glob_existence.rs`'s existence
   check) that also asserts the documented count matches
   `len(examine_globs)`.

9. **Agent stalls (600s no-progress) on large-file tasks** — observed on
   tasks touching the now-large `cross-cutting.md`/`edge-case-catalog.md`
   files during this cycle; mitigated in-session by giving agents narrow,
   pre-located briefs (exact section/line targets) rather than open-ended
   "find and fix" instructions. Candidate: codify the narrow-brief mitigation
   as standing guidance for any future task touching these files, and
   consider whether the files themselves are due for a size-reduction pass.

10. **The `validate-dispatch-advance` hook's `D-\d+` regex lacks a left word
    boundary** — it misreads phase-row names like
    `...-APPROVED-2026-09-24` as decision `D-2026` (the digits immediately
    following the literal `D` at the end of "APPROVED", "PARKED",
    "CLOSED", "CONVERGED", etc.), then flags `STATE.md`'s `current_step`
    D-chain cite as stale because the file's real max decision (`D-383`)
    is smaller than the spurious `D-2026` match. Observed live during this
    burst on both the `validate-state-structure`-triggered rewrite and a
    follow-up `Edit`. Candidate: anchor the regex with a left word
    boundary (e.g. `(?<![A-Za-z0-9])D-\d+`) so it only matches a genuine
    `D-NNN` decision-ID token, not a dated phase-row-name suffix.

11. **The `validate-factory-path-staging` hook resolves the branch from the
    outer checkout, not the command cwd** — `cd .factory && git add` is
    blocked while `git -C .factory add` works for the identical operation,
    because the hook inspects the shell's outer working directory (the
    target-project checkout on `develop`) rather than the branch actually
    active inside `.factory/` when `-C` is used. This is why every
    state-manager burst protocol mandates `git -C .factory <cmd>` forms.
    Candidate: have the hook resolve the branch via the effective `git`
    invocation's target directory (honoring `-C`), not the process cwd.

12. **Input-hash on delivered/historical artifacts whose `inputs:` include
    living specs is structurally always stale after any later cycle** — a
    scan at the cycle-014 F2 gate found 265 of 298 tracked artifacts STALE,
    because their `inputs:` frontmatter cites files like
    `cross-cutting.md`/`STATE.md` that keep evolving after the artifact
    itself was delivered and closed. Refreshing all of them on every burst
    is neither meaningful (the artifact's own content isn't wrong) nor
    scalable. Candidate: either freeze historical hashes once an artifact's
    owning cycle/phase closes, or exclude closed-cycle/delivered artifacts
    from drift scans entirely, refreshing only artifacts still under active
    review (as this burst did for the 3 cycle-014 F2 artifacts still in
    play).

13. **The "3 consecutive clean adversarial passes" convergence rule did not
    converge in practice on this cycle's large spec delta.** Fresh-context
    passes kept finding new LOW/COSMETIC items even on text two prior
    fresh-context passes had already cleared (`PASS-34`/`PASS-35` CLEAN,
    then `PASS-36` re-reviewing the same unchanged text found 2 LOW + 2
    COSMETIC) — this reads as reviewer variance rather than a genuine
    residual defect, but it means the literal rule never actually fires at
    this delta's scale. Human decision `D-383` accepted convergence on a
    substantive basis (36 total passes, zero CRITICAL/HIGH in the last 17)
    as a one-time exception for cycle-014 F2 only. Candidate: adjust the
    rule itself — e.g. a severity-trend-based convergence criterion (no
    CRITICAL/HIGH/MEDIUM in N passes, LOW/COSMETIC-only tolerated), or a
    narrower adversarial perimeter for summary/index surfaces that are
    especially prone to this kind of low-severity churn.

## Disposition

Not yet dispositioned. F2 is CONVERGED per human decision `D-383` and
AWAITING the F2 human approval gate — the S-7.02 cycle-closing checklist
dispositions each of these 13 items when cycle-014 itself closes, not
before.
