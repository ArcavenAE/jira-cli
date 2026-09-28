---
document_type: process-gaps
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-26T00:01:34Z
cycle: "cycle-014-issue-triage-quickfixes"
inputs: [STATE.md]
input-hash: "1103087"
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

14. **Stories invent their own Red Gate density exclusion rules instead of
    mapping cells to `per-story-delivery.md`'s categories** — F3 adversarial
    review passes 4 and 5 found stories using ad hoc phrasing like "exclude
    from numerator" and applying `GREEN-BY-DESIGN` to what is actually
    `PRE-EXISTING-BEHAVIOR` (a rationale label only, non-exempt, per
    `per-story-delivery.md`'s categories: `GREEN-BY-DESIGN`/`WIRING-EXEMPT`
    are exempt; `PRE-EXISTING-BEHAVIOR` is not). Candidate: the story-writer
    prompt/template should require an explicit per-test RED/exempt/
    denominator enumeration and tally, rather than free-text density
    exclusion prose. Source: `ADV-C14-F3-P4-001`/`002`,
    `ADV-C14-F3-P5-001`/`002`. Engine-side (vsdd-factory) follow-up.

15. **`per-story-delivery.md` L35 (also `deliver-story` `SKILL.md` L78,
    `step-c-failing-tests.md` L25) requires Step-3 failure messages to be
    "not 'not yet implemented'"** — this conflicts with strict-mode
    `todo!()` stubs (`BC-5.38.001`) for direct-call tests, and risks a
    test-writer re-dispatch loop when a story's stub-generated failure
    message legitimately reads that way. Engine-side reconciliation is
    needed; in the meantime, cycle-014's stories carry explicit
    no-redispatch notes to avoid the loop. Source: `ADV-C14-F3-P5-004`.
    Engine-side (vsdd-factory) follow-up.

16. **The story template has no VP-cell ownership matrix and no stub-task
    guidance** — flagged from pass 2 onward. Holdout scenarios repeatedly
    omitted prerequisite HTTP mock chains and hermetic preconditions
    (fixed ad hoc in passes 4/5, see the mock-chain enumerations added to
    `wave-holdout-scenarios.md` this burst), because the template gives no
    structured place to declare which VP cell each test/scenario owns, nor
    what stub scaffolding a story's implementation tasks need before
    TDD starts. Source: `ADV-C14-F3-P2-002`, `P4-008`, `P5-003`.
    Engine-side (vsdd-factory) follow-up.

17. **(candidate) The `validate-trajectory-tail-cell-completeness` PostToolUse
    hook repeatedly reported the STATE.md "Last Updated" cell as missing the
    `trajectory_tail` arrow sequence even when the sequence was present** —
    observed in the `b1379cc` burst. Suspected false positive rather than a
    genuine omission; the cell in question did carry the `→0→0→0→0` sequence
    at the time the hook fired. Candidate: engine-side follow-up to verify
    the hook's cell-match logic against a "Last Updated" cell that embeds the
    sequence inside a longer sentence (as opposed to as a standalone token).

18. **Story-writing paraphrased VP clauses into AC Test lines and
    self-attested completeness checklists, and the paraphrases repeatedly
    dropped clauses** — recurring across F3 passes 3 through 7 (7 total
    passes, 0/3 clean streak reached), the dominant defect class was a story
    restating a VP sub-clause in its own words rather than citing it, and the
    restatement silently narrowing or omitting part of the clause. Resolved
    for cycle-014 by human decision `D-386` (2026-09-28): stories now BIND to
    VP clauses by reference — AC Test lines cite exact VP sub-clauses plus a
    normative "cited clause is binding, not narrowed" sentence, pin
    checklists are replaced by clause-level maps, and the story keeps only
    test placement, function grouping, and RED/GREEN classification in its
    own prose. Engine-side fix: the story template/story-writer prompt should
    require bind-by-reference (the `D-386` pattern) as standard practice, not
    a per-cycle remediation. Source: `ADV-C14-F3-P3-003`, `P4-003`,
    `P6-003`/`004`, `P7-001`..`004`. Engine-side (vsdd-factory) follow-up.

19. **Story-to-spec coverage was hand-verified.** Manual clause maps
    drifted, and adversary passes kept finding uncovered or mis-owned
    clauses (passes 8-10). Engine-side fix: adopt the `D-387` pattern as a
    standard story-template section plus a bundled coverage-check tool
    (based on citation tags and the git-diff changed-line set) run before
    each story adversarial pass. Source: `ADV-C14-F3-P8-004`,
    `P9-003`/`004`/`007`/`008`, `P10-001`..`007`. Engine-side (vsdd-factory)
    follow-up.

20. **The story template's Library & Framework Requirements and Previous
    Story Intelligence sections are MANDATORY tables, but story-writers
    wrote prose** (`P8-008`, `P9-013`). Add a template-compliance check for
    the table shape. Engine-side (vsdd-factory) follow-up.

21. **ACs claimed a VP/spec clause was covered "in full" when none of the
    AC's own owned cells actually verified it** — recurring across F3
    passes 11-13: an AC's `[CC:L<s>-<e>]` citation pointed at a clause
    span, but the Test line's enumerated cells left part of that span
    unverified (verbatim restatement of the citation was treated as proof
    of coverage, the same underlying failure class as `#18`/`#19` one
    layer down — this time inside a single AC rather than across the whole
    story). Engine-side fix: the story template needs a per-citation
    verifiability rule — every `[CC:]` citation must be either (a)
    verified by an AC's own owned cell, or (b) explicitly labelled
    informational and paired with a named enforcement mechanism (a test,
    a script, a compiler guarantee) instead of an owned cell. Source: F3
    passes 11-13 citation-verifiability sweep findings. Engine-side
    (vsdd-factory) follow-up.

22. **In-body Revision Note sections accumulate over successive
    adversarial passes and eventually contradict the current story body**
    — each pass's fix left a dated `## Revision Note` paragraph in place,
    and by pass 13 these historical notes were long enough, and stale
    enough relative to later rewrites, to themselves become a source of
    adversarial findings (a reviewer citing an old Revision Note's
    now-superseded wording as if it were current). Resolved for cycle-014
    this burst by an orchestrator structural decision: every Revision Note
    section is moved verbatim out of the story body into a non-normative
    sibling `*.revision-history.md` file per story (stories bumped to
    v4.0: A 704 lines, C 907, B 539; token budget ~11-20% of context).
    Engine-side fix: the story template should keep revision history in a
    sibling non-normative file from the start, rather than accumulating
    it in-body. Source: F3 pass 11-13 review findings plus the orchestrator
    revision-history-split decision. Engine-side (vsdd-factory) follow-up.

## Disposition

Not yet dispositioned. F2 is CONVERGED per human decision `D-383` and
APPROVED at the F2 human gate (`D-384`) — the S-7.02 cycle-closing checklist
dispositions each of these 22 items when cycle-014 itself closes, not
before.
