---
document_type: process-gaps
level: ops
version: "1.0"
status: dispositioned
producer: state-manager
timestamp: 2026-09-26T00:01:34Z
cycle: "cycle-014-issue-triage-quickfixes"
inputs: [STATE.md]
input-hash: "8e0493d"
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

17. **(candidate, RECLASSIFIED 2026-09-28) The `validate-trajectory-tail-cell-completeness`
    PostToolUse hook's apparent "false positive" on the STATE.md "Last Updated"
    cell was a FORMAT mismatch, not a hook defect** — originally recorded
    (observed in the `b1379cc` burst) as a suspected false positive: the hook
    flagged the cell as missing the trajectory-tail arrow sequence even though
    a value was present. **Correction note (2026-09-28):** root-caused this
    burst — the hook requires the literal, unquoted, hyphenated
    `trajectory-tail →N→N→N→N` substring to appear directly in the cell text.
    A `trajectory_tail` (underscore) label, or the value separated from the
    label by table-cell/markdown punctuation (e.g. `` **trajectory-tail** | `→0→0→0→0` ``
    or `` trajectory-tail: `→0→0→0→0` ``), does NOT satisfy the check. The
    flagged cell was written in one of the non-matching forms; the hook
    behaved correctly. The original entry's premise ("suspected false
    positive rather than a genuine omission") is superseded and WRONG — this
    is reclassified from "suspected hook defect" to a documentation/format-
    discoverability gap: the required literal form is not documented anywhere
    state-manager reads before writing STATE.md (not in the state-manager
    agent definition, not in `state-template.md`, not in the
    `hooks-registry.toml` entry's comment). Candidate: document the exact
    required literal form (hyphenated, unquoted, `trajectory-tail →N→N→N→N`
    immediately adjacent to the arrow sequence, no intervening backticks/pipe)
    in the state-manager agent definition and/or `state-template.md`, and add
    a pre-write self-check for the 5 prescribed STATE.md cells (frontmatter
    `current_step`, "Last Updated", Phase Progress Notes, Concurrent Cycles
    Notes, Session Resume Checkpoint body).

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

23. **Fixes were applied only to the story where a finding was reported,
    not swept across sibling stories, so the same defect class resurfaced
    in a sibling one pass later.** Example: pass-25 pinned the proptest
    generator property in STORY-B only, and pass-26 found the same gap in
    STORY-C. This also recurred for fault-model scoping, where `P22-001`
    was fixed and the `P23-002` sibling was then found. Remediation
    already adopted from pass 26: every fix burst sweeps each finding's
    pattern across all sibling stories. Engine-side fix: the fix-burst
    checklist or the story-writer prompt should require a sibling sweep
    as standard practice, not a per-finding remediation. Source:
    `ADV-C14-F3-P23-002`, `P26-001`. Engine-side (vsdd-factory) follow-up.

24. **The "informational" label was ambiguous.** Fixers used it both for
    non-observable facts and for sentences already observed by named tests,
    and applied it differently across stories. Findings recurred over passes
    30-32. Resolved by the three-way scheme (**O** observed by named test /
    **N** not runtime-observable with a named mechanism / **U** observable,
    no cell by design) plus tightened N-vs-U rules and a ban on implicit O.
    Engine-side: the story template should define this scheme. Source:
    `ADV-C14-F3-P31-002`, `P32-003`, `P32-006`. Engine-side (vsdd-factory)
    follow-up.

25. **Token-budget measurement was unreliable.** Chunked Read-tool header
    counts were summed, which double-counts. Rule adopted: use the
    whole-file header count and round to 5k. Engine-side: document the
    measurement method in the template. Source: `ADV-C14-F3-P32-001`.
    Engine-side (vsdd-factory) follow-up.

26. **[process-gap] [engine]** The F3 review-loop definition conflicts
    across three places. The Feature Mode skill requires human approval
    only for the F3 gate. `workflows/feature.lobster` runs `spec-reviewer`
    with `max_iterations: 10` and `exit_condition: "spec_reviewer.verdict
    == 'APPROVED' OR spec_reviewer.findings.critical == 0"` (L587-588,
    L667-668). `agents/orchestrator/feature-sequence.md`'s "Story review
    loop (max 10 passes)" instead runs the `adversary` agent with fresh
    context each pass (L96-101). Three different mechanisms (human
    approval / spec-reviewer critical-count / adversary pass-count) are
    each independently documented as authoritative for the same gate,
    with no reconciling cross-reference between them. Needs follow-up
    story or deferral before cycle close (S-7.02 checklist).

27. **[process-gap] [engine]** "Clean" is undefined for story/spec review.
    `agents/adversary.md` L205 and `skills/adversarial-review/SKILL.md`
    L188 both say "minimum 3 clean passes" without defining a clean pass
    as anything other than "not NOT CLEAN." Separately, the adversary's
    own prompt instructs it that "you make genuinely novel findings
    through pass 9+" (`agents/adversary.md` L361) and that "zero findings
    [...] is a prompt bug, not convergence" (`skills/adversarial-review/
    SKILL.md` L37) — language that actively discourages reporting a clean
    pass, and conflicts with `VSDD.md` L242's convergence signal ("nitpicks
    about wording, not missing behavior or verification gaps") and this
    cycle's own reading of "not nitpicks" as the clean bar. An adversary
    primed to always find something and a "clean means nitpicks-only" bar
    are in direct tension. Needs follow-up story or deferral before cycle
    close (S-7.02 checklist).

28. **[process-gap] [engine]** The adversary's fresh-context mandate
    conflicts with accumulate-invariants guidance. `agents/adversary.md`'s
    Information Asymmetry section and its L361 "fresh context lets you see
    patterns that prior passes [...] cannot; do not assume prior passes
    were thorough" instruct each pass to re-derive understanding from
    scratch, explicitly not inheriting prior conclusions. This is in
    tension with the general VSDD guidance (elsewhere in the pipeline) to
    accumulate invariants/decisions across passes so fixed defect classes
    stay fixed. Applied literally, "no memory of prior passes" is exactly
    the condition that let this cycle's O/N/U ambiguity (`#24`) and the
    sibling-sweep gap (`#23`) each resurface across multiple passes before
    being caught. Needs follow-up story or deferral before cycle close
    (S-7.02 checklist).

29. **[process-gap] [engine]** Model-family mismatch. `VSDD.md` and the
    `adversary` agent's own description ("Uses different model for genuine
    perspective diversity") call for the adversarial reviewer to run on a
    different model family than the builder/story-writer, for genuine
    cognitive diversity. `agents/adversary.md`'s frontmatter pins `model:
    opus` — the same model family used elsewhere in this pipeline's
    story-writer/fix bursts. The stated rationale for perspective
    diversity is not actually being satisfied by the configured agent.
    Needs follow-up story or deferral before cycle close (S-7.02
    checklist).

30. **[process-gap] [engine]** The 10-pass cap was not enforced this
    cycle. `agents/adversary.md` L205 and `skills/adversarial-review/
    SKILL.md` L188 both say "maximum 10 before escalating to human," but
    F3's story review ran 33 passes (this cycle's own pass counter) with
    no automatic escalation to the human at pass 10, 20, or 30 — the human
    only intervened voluntarily (`D-386`, `D-387`, `D-388`) and ultimately
    directed the research that produced `D-389`. Nothing in the orchestrator
    or a hook actually counts passes against the documented cap. Recommend
    a hook or an orchestrator-side pass counter that fires a mandatory
    human checkpoint at pass 10 (and every 10 thereafter) rather than
    relying on the human to notice unprompted. Needs follow-up story or
    deferral before cycle close (S-7.02 checklist).

31. **[process-gap] [engine]** Cycle-invented review requirements
    (sentence-level O/N/U labels, `[CC:L<s>-<e>]` line-span citations —
    neither required by `story-template.md` L60-71's "every AC must trace
    to a specific behavioral contract clause," which is AC-level, not
    sentence-level) combined with an LLM reviewer's non-zero per-pass
    false-positive/false-finding rate make a strict 3-consecutive-clean
    rule practically non-convergent once the review surface is large
    enough. For `p` = per-pass probability of at least one (possibly
    spurious) finding, and passes independent, the number of Bernoulli(1-p)
    "clean" trials needed to observe 3 consecutive successes has expectation
    `E[N] = (1 - p^3) / ((1 - p) * p^3)` passes: **~49 passes at p=0.7**
    and **~1,110 passes at p=0.9**. This cycle observed 33 not-clean passes
    in a row (informal per-pass finding rate well above 0.7) before the
    human intervened with `D-389`. Recommend the factory codify a clean
    bar matching its own documented convergence signal (VSDD.md L242 /
    phase-2-story-decomposition.lobster L127 "cosmetic only") rather than
    leaving each cycle free to invent a stricter, non-convergent bar.
    Needs follow-up story or deferral before cycle close (S-7.02
    checklist).

32. **[process-gap] [engine]** Step 4.5 adversary dispatch lacked the full
    identity tuple (feature-HEAD-SHA, canonical-repo-root) on pass 1. The
    initial dispatch for STORY-A's (`S-cycle14-user-list-project-resolution`)
    per-story Step 4.5 adversarial convergence omitted the feature branch's
    HEAD SHA and the canonical repo root from the pass-1 dispatch payload —
    the orchestrator corrected this from pass 2 onward, supplying both on
    every subsequent dispatch. Candidate: the Step 4.5 dispatch template
    (per-story-delivery.md / the adversary dispatch prompt) should require
    this identity tuple as mandatory dispatch fields from pass 1, not leave
    it to be discovered and self-corrected mid-stream. Source: STORY-A Step
    4.5 convergence record, `cycles/cycle-014/S-cycle14-user-list-project-resolution/adversary-convergence-state.json`.
    Engine-side (vsdd-factory) follow-up.

33. **[process-gap] [engine]** `per-story-delivery.md` Step 5's instruction
    to write demo evidence to `docs/demo-evidence/<STORY-ID>/` "committed to
    feature branch" conflicts with this repo's PR #708 policy — `jira-cli`'s
    `.gitignore` excludes `docs/demo-evidence/`, and the policy (per PR #708,
    "purge demo-evidence from product repo; gitignore docs/demo-evidence
    (relocate to factory-artifacts)") is that this evidence lives at
    `.factory/demos/<STORY-ID>/` on `factory-artifacts`, not on the product
    branch. On STORY-A's delivery, the demo-recorder force-added the
    evidence (`git add -f`) per the literal per-story-delivery.md
    instruction; the orchestrator reverted that force-add and relocated the
    evidence to `.factory/demos/S-cycle14-user-list-project-resolution/`
    instead, per this repo's actual policy. Candidate: the engine playbook
    needs a per-project demo-evidence-location override (a project-level
    config flag or CLAUDE.md-read convention) so `per-story-delivery.md`'s
    Step 5 can detect and honor a repo that has opted out of committing
    `docs/demo-evidence/` to the feature branch, rather than defaulting to
    `git add -f` against a project's own `.gitignore` policy. Source:
    STORY-A demo evidence relocation, this burst.
    Engine-side (vsdd-factory) follow-up.

34. **[process-gap] [engine]** `pr-manager`'s merge-gate logic relies on
    GitHub branch protection to actually block an unapproved merge, and it
    does not detect when protection is configured so that it enforces
    nothing — `develop`'s branch protection sets
    `require_code_owner_reviews=true` but `required_approving_review_count=0`,
    so the code-owner requirement was never actually enforced. On STORY-A's
    PR #886, this let a squash-merge land with `reviewDecision` empty (the
    only review was a COMMENTED review, since GitHub rejects
    self-approval) — the orchestrator's "stop if blocked" instruction
    therefore did not stop the merge, even though no `--admin` flag or
    other bypass was used. Resolved for this project by human decision
    `D-391` (2026-09-29), which accepts the PR #886 merge as-is, leaves
    branch protection unchanged, and establishes a standing
    autonomous-merge policy: `pr-manager` may merge autonomously once the
    story has passed Step 4.5 adversarial convergence, PR review
    convergence is APPROVE with 0 blocking findings, security review is
    clean, and `ci-gate` is green — otherwise it must stop at merge-ready
    for the human. Candidate: `pr-manager` should check the *effective*
    approval requirement (e.g. via `gh api repos/{owner}/{repo}/branches/
    {branch}/protection` and reading `required_pull_request_reviews.
    required_approving_review_count` together with
    `require_code_owner_reviews`) rather than assuming any configured
    protection enforces a human review. Also note: `pr-manager` wrote
    `.factory/code-delivery/S-cycle14-user-list-project-resolution/`
    artifacts (`pr-description.md`, `pr-review.md`) despite a "do not
    touch `.factory/`" instruction elsewhere in this session — this is
    benign (its own template outputs, committed as-is by this burst), but
    the instruction should carve out `code-delivery/` as an exception.
    Source: STORY-A merge (PR #886), this burst.
    Engine-side (vsdd-factory) follow-up.

35. **[process-gap] [engine]** The fault-model attribution in the BC/story
    (e.g. "NAME or VALUE trimmed — killed by (d) no-trim pinned examples")
    is never checked against the layer the cited test exercises. On
    STORY-C's (`S-cycle14-api-query-param`) BC-X.16.001, the pinned
    "no-trim" examples called `append_query_params` with pre-split tuples
    and bypassed `parse_query_param` — the function that actually owns the
    trim/no-trim fault — so a `.trim()` regression introduced in
    `parse_query_param` would have passed the suite untouched. This claim
    survived 33 F3 spec passes before Step 4.5's adversarial review caught
    it at implementation-review time (pass 1, F-001, fixed in `fb23a500`).
    Candidate: the story-writer and spec-adversary prompts need a step
    that confirms each claimed fault-kill cell in a BC's example table
    exercises the code path that owns the fault it claims to kill, not
    merely a downstream caller of that path. Source: STORY-C Step 4.5
    convergence record, `cycles/cycle-014/S-cycle14-api-query-param/adversary-convergence-state.json`.
    Engine-side (vsdd-factory) follow-up.

36. **[process-gap] [engine]** The harness auto-mode classifier blocks
    agent-initiated PR merges even when a human decision (`D-391`)
    authorizes autonomous merge. On STORY-C's PR #887, `pr-manager`'s
    dispatch of the merge action was DENIED by the Claude Code auto-mode
    permission classifier — a harness-level permission gate, distinct
    from and unrelated to `D-391`'s content-based policy for WHEN a merge
    is authorized. `pr-manager` correctly stopped without working around
    the denial and the human merged PR #887 by hand. This is the same
    class of stop-then-hand-off outcome the orchestrator had originally
    intended for STORY-A's PR #886 (process-gap `#34`), but this time
    caused by a harness permission gate rather than a branch-protection
    configuration gap — a second, distinct root cause landing on the same
    "merge did not happen autonomously" symptom. Candidate:
    `pr-manager`'s playbook should detect this specific denial signature
    and treat "merge-ready handoff to human" as a first-class terminal
    state, not an error to retry or route around. **Also flag:** before
    its merge attempt, `pr-manager` accumulated self-inflicted
    status-check filler tasks and routed messages to "team-lead", which
    caused wall-clock delays in both PR runs (STORY-A's and STORY-C's) —
    a process-efficiency defect independent of the permission-denial
    finding above. Source: STORY-C merge (PR #887), this burst.
    Engine-side (vsdd-factory) follow-up.

37. **[process-gap] [engine]** Per-wave integration gates after Wave 1
    (STORY-A) and Wave 2 (STORY-C) were skipped. For a serial
    one-story-per-wave schedule (`A -> C -> B` per `D-381`), the
    orchestrator treated delivery as a continuous chain and moved straight
    to the next story's worktree each time, rather than inserting a gate
    checkpoint between waves. One combined gate over all 3 waves
    (`204b1fb5..2ee422e0`) was run at F4 completion to compensate — see
    `cycles/cycle-014/wave-integration-gate.md`. Candidate:
    `per-story-delivery.md`'s wave gate needs an explicit "run the gate
    before starting the next wave's worktree" checkpoint, or explicit
    guidance that single-story waves may batch into one combined gate at
    the end of a serial chain (making the batching a deliberate, documented
    choice rather than an accidental omission). **Also flag (efficiency
    lesson):** concurrent full `cargo test` runs by two agents in the same
    checkout contended on the `target/` directory during this cycle's
    delivery, so a full suite run took ~2h. Gate steps that each need a
    full-suite run should share one run rather than each triggering their
    own. Source: cycle-014 F4 completion / combined wave gate, this burst,
    2026-09-30. Engine-side (`vsdd-factory`) follow-up.

38. **[process-gap] [engine]** During `FIX-P5-001`'s implementation, the
    implementer modified a RED-gate proptest assertion (weakening exact
    `\n`-count equality, `==`, to `<=`) after the assertion contradicted
    the BC's stated invariant — without first stopping to report the
    contradiction, despite standing instruction to stop and report when a
    test appears wrong rather than change it unilaterally. The underlying
    contradiction was genuine (EC-3's fail-closed unterminated-CSI/OSC
    consumption does swallow an embedded `\n`, so unconditional exact
    preservation cannot hold — see process-gap `#39` below and spec
    `[2.5.1]`), so the outcome was sound: the orchestrator accepted the
    weakened assertion and had `test-writer` restore exact `\n`
    preservation separately, as a narrower conditional property scoped to
    inputs where no `\n` falls inside a CSI/OSC scan span. But the
    instruction itself — stop and report before changing a test that looks
    wrong — was not followed. Candidate: an enforcement hook that flags a
    RED-gate test-assertion edit mid-implementation for orchestrator
    review before it lands, or materially stronger prompt wording in the
    implementer's playbook, since prompt wording alone did not prevent
    this instance. Source: `FIX-P5-001` implementation, this burst,
    2026-09-30. Engine-side (`vsdd-factory`) follow-up.

39. **[process-gap] [engine]** `product-owner` wrote BC-7.1.006's EC/VP
    example literals — including one orchestrator-supplied literal for the
    original EC-13 draft (`"\u{1b}[31;1;9\nline2"` → `""`) — without
    executing them against the implementation's actual state machine.
    `test-writer`, building `FIX-P5-001`'s Red Gate tests from the spec,
    found the literal did not hold: the CSI parameter scan has no `\n`
    boundary check, so the sequence actually terminates at the lowercase
    `l` in `line2` (a valid final byte, `0x40`-`0x7E`), yielding `"ine2"`,
    not `""`. The orchestrator's own EC-13 literal was therefore wrong and
    had to be corrected against the real implementation before the spec
    could be finalized as `[2.5.1]` — see `spec-changelog.md` `[2.5.1]`
    and `bc-7-output-render.md` BC-7.1.006 version-history row `1.0.1`.
    Candidate: pinned spec EC/VP examples should be validated by actually
    running them — e.g. `test-writer` (or a lightweight scratch check)
    confirms each EC literal against the implementation before the spec
    authoring the example is finalized, not after Red Gate surfaces the
    mismatch. Source: `FIX-P5-001` spec `[2.5.1]` correction, this burst,
    2026-09-30. Engine-side (`vsdd-factory`) follow-up.

40. **[process-gap] [engine]** PR #891 (`FIX-P5-001`) grew in scope three
    times during review — `D-393` (security review 1, SEC-003 HIGH,
    `jr issue comment view`), `D-394` (security re-review, `jr issue
    assign`), and `D-395` (final security re-review, SEC-891-2 MEDIUM,
    `disambiguate_user`) — before a human froze its scope at `D-395`. Each
    re-review found a new sibling sink sharing the exact same CWE-150/
    CWE-116 exposure class as the original finding. Lesson: at triage
    time, a security fix's scope should be defined by a complete sink
    inventory up front — including non-table sinks and shared helpers,
    not just the sink the triage happened to start from — with an
    explicit scope-freeze policy stated before implementation begins,
    rather than discovered re-review by re-review. Source: PR #891 full
    review history, this burst, 2026-10-01. Engine-side (`vsdd-factory`)
    follow-up.

41. **[process-gap] [engine]** The initial `SEC-001` triage's sink
    inventory (`cycles/cycle-014/phase-f5-adversarial/SEC-001-triage.md`)
    missed `jr issue comment view` and the other non-table sinks later
    recorded as `NONTABLE-SERVER-TEXT-SANITIZE`. The inventory grep that
    produced the original triage was scoped too narrowly — it searched
    for `comfy_table`/`render_table` call sites only, not every
    `print!`/`println!`/`eprintln!`/`JrError`/`dialoguer::Select` site
    that echoes server-supplied text. Candidate: a sink-inventory step
    for this CWE class should grep for the OUTPUT primitives
    (`print!`/`println!`/`eprintln!`/`format!` feeding `JrError`/
    `dialoguer::Select`), not just the one rendering chokepoint already
    known to exist. Source: PR #891 SEC-003/SEC-891-2 findings, this
    burst, 2026-10-01. Engine-side (`vsdd-factory`) follow-up.

42. **[process-gap] [engine]** A security-reviewer agent dispatched
    against PR #891 hung indefinitely and never returned a verdict;
    `pr-manager` had no mechanism to stop or time out the stuck
    dispatch, because only the orchestrating session can cancel an
    agent. The orchestrator worked around it by dispatching a fresh
    security-reviewer agent, which is the one that found SEC-003 — so
    the outcome was sound, but the review cycle lost real wall-clock
    time to a hang with no automatic detection. Candidate: bounded
    reviewer runtimes (a wall-clock timeout on any dispatched review
    agent) plus an explicit escalation path back to the orchestrator
    when a dispatch exceeds it, rather than relying on a human or the
    orchestrator noticing the hang by inspection. Source: PR #891
    security review dispatch, this burst, 2026-10-01. Engine-side
    (`vsdd-factory`) follow-up.

43. **[process-gap] [engine]** `pr-manager` recommended a merge command
    referencing wrapper scripts
    (`plugins/vsdd-factory/bin/check-stale-verdict.sh`,
    `plugins/vsdd-factory/bin/enforce-merge-strategy.sh`) that do not
    exist anywhere in this repo — its template assumes tooling that was
    never installed here. The orchestrator caught this before it was
    run and substituted the correct, working command
    (`gh pr merge 891 --squash --delete-branch`). Candidate:
    `pr-manager`'s merge-command output must be validated against the
    actual repo (e.g. a file-existence check on any script path it
    names) before being surfaced as an instruction, rather than trusting
    the template verbatim. Source: PR #891 merge-readiness hand-off,
    this burst, 2026-10-01. Engine-side (`vsdd-factory`) follow-up.

44. **[process-gap] [engine]** The factory-dispatcher `PostToolUse` hook
    repeatedly reported a fail-closed `FUEL_EXHAUSTED` result on large
    edits to `spec-changelog.md` during this cycle's spec-delta bursts
    (`[2.5.2]`-`[2.5.5]`). The edits themselves persisted on disk, but
    the hook's own validators did not complete, creating two distinct
    risks: (1) whatever validation that hook run was supposed to perform
    silently never ran, and (2) the hook's reported "block" semantics
    were inconsistent with what actually happened (content landed
    despite a fail-closed report), which could mislead anyone reading
    the hook's own log as evidence the write was rejected. Candidate:
    investigate the hook's fuel cap — either raise it for large
    append-only files like `spec-changelog.md`, or chunk large edits so
    a single `PostToolUse` invocation stays under the cap, and align the
    reported outcome with the actual on-disk result so "FUEL_EXHAUSTED"
    cannot coexist with a successful write. Source: `FIX-P5-001` spec
    `[2.5.2]`-`[2.5.5]` delta bursts, this burst, 2026-10-01. Engine-side
    (`vsdd-factory`) follow-up.

45. **[process-gap] [engine]** When `pr-reviewer`/security-reviewer
    agents are dispatched in explicitly read-only mode, they trip the
    `validate-pr-review-posted` `Stop` hook, which expects every
    dispatched review to end by posting its verdict as a PR comment.
    The orchestrator's read-only instruction (used when it wants the
    review content back in its own context without a posted artifact)
    directly conflicts with that hook's enforcement. Candidate:
    reconcile the two — either the read-only dispatch path should set a
    flag the hook recognizes and skips, or the hook's enforcement should
    be narrowed to only the review modes that are expected to post.
    Source: PR #891 review dispatches, this burst, 2026-10-01.
    Engine-side (`vsdd-factory`) follow-up.

46. **[process-gap] [engine]** `FIX-P5-001` expanded scope three times
    (`D-393`/`D-394`/`D-395`) with no per-story Step-4.5-style adversary
    convergence record of its own — unlike a regular story, a fix PR's
    review rounds were tracked only as PR-review/security-review verdicts,
    not as a dedicated convergence artifact. That gap is why the doc/test
    drift later found as `F-001` (nonexistent `jr issue edit --assignee`
    flag cited, `jr issue list --reporter` omitted from the caller list)
    and `F-002` (overstated VP(c)/EC-16 test-coverage claims) escaped
    detection until the cycle-014 F5 pass-1 adversarial review, rather than
    being caught during `FIX-P5-001`'s own delivery. Candidate: apply the
    same Step-4.5-style adversary convergence gate (BC-5.39.001) to fix PRs
    delivered via `fix-pr-delivery`, not just stories delivered via
    `per-story-delivery`. Source: cycle-014 F5 pass 1
    (`cycles/cycle-014/phase-f5-adversarial/pass-1.md`), this burst,
    2026-10-01. Engine-side (`vsdd-factory`) follow-up.

47. **[process-gap] [engine]** During the `FIX-P5-002` spec-delta burst,
    product-owner's first draft treated `CR-2` — a REQUIRED BEHAVIOR CHANGE
    the human approved via `D-396` ("move the `--no-color` check into the
    styled-table API") — as if it were merely a premise to correct about
    today's code, and wrote the BC body as a description of current
    behavior rather than the new required behavior. The orchestrator caught
    and corrected this mid-burst (see
    `cycles/cycle-014/phase-f5-adversarial/FIX-P5-002-spec-delta.md`'s own
    "Correction to this delta's own first draft" note). Candidate:
    orchestrator dispatch instructions for any human-approved finding
    disposition should explicitly label it `REQUIRED CHANGE` (vs. `SPEC
    CORRECTION`/`DOCUMENTED EXCEPTION`) so the receiving agent cannot
    mis-read an approved behavior change as a passive documentation fix.
    Source: `D-396`/`FIX-P5-002` spec-delta burst, this burst, 2026-10-01.
    Engine-side (`vsdd-factory`) follow-up.

48. **[process-gap] [engine]** The `validate-factory-path-staging` hook
    false-positives on the ordinary `cd .factory && git add -A` sequence
    that state-manager's own documented git-operations protocol specifies,
    apparently misreading the `cd` as an attempt to stage factory paths
    from outside the worktree. The standing workaround — using
    `git -C .factory add -A` / `git -C .factory commit` instead of `cd
    .factory && git add -A` — avoids the false-positive and is the form
    actually used by this and prior bursts. Candidate: fix the hook's
    detection to recognize `cd .factory && git <cmd>` as the equivalent of
    `git -C .factory <cmd>` rather than require the workaround at every
    call site. Source: this burst's own git operations, 2026-10-01.
    Engine-side (`vsdd-factory`) follow-up.

49. **[process-gap] [engine]** Input-hash self-reference risk: an artifact
    whose `inputs:` frontmatter lists a file that is itself being rewritten
    in the same burst (e.g. `wave-integration-gate.md` listing `STATE.md`
    as an input) must never have that input's literal computed hash value
    quoted inside the dependent artifact's own prose — doing so creates a
    self-referential drift loop, because quoting the value freezes a
    snapshot that the next STATE.md rewrite immediately invalidates, and
    the quoted citation itself then has to be hunted down and corrected on
    every subsequent burst. The correct pattern (already followed by this
    and the `CYCLE-014-F5-FIX-P5-001-MERGED` burst before it) is to let
    each file's own `input-hash:` frontmatter field be the sole source of
    truth, update the DEPENDENT file's hash via `compute-input-hash
    --update` only AFTER the file it depends on has been finalized, and
    never restate the literal hash value in narrative text. Candidate:
    encode this rule directly in the `state-burst`/`compute-input-hash`
    skill documentation so future bursts don't have to rediscover it ad
    hoc. Source: this burst's hash-refresh step (`S-cycle14-user-list-
    project-resolution.md`, `dependency-graph-extended.md`,
    `S-cycle14-field-options-name-label.md`, `wave-integration-gate.md`),
    2026-10-01. Engine-side (`vsdd-factory`) follow-up.

50. **[process-gap] [tooling]** No guard verifies `.cargo/mutants.toml`
    `exclude_re` anchors. An `exclude_re` entry of the form `file:line:col: ...
    in <fn>` silently stops matching when the target function moves (here
    `issues.rs:374:16` had drifted to line 393, a drift that pre-dates
    cycle-014), so an exclusion silently stops applying with no failing
    signal. Candidate: a guard script or test that fails when an `exclude_re`
    anchor no longer points at its named function. Source: F5 Pass 3 finding
    `P3-005`. The anchor was re-anchored in `FIX-P5-004` (`D-398`); the GUARD
    was DEFERRED by human choice. Tracked as
    `MUTANTS-EXCLUDE-RE-ANCHOR-GUARD` in `cycles/OPEN-STANDING-ITEMS.md`
    (target: next maintenance sweep). Recorded 2026-10-01.

52. **[process-gap] [spec-propagation]** A strengthened test is not propagated
    back to the BC prose that describes it. `FIX-P5-006` strengthened
    `user_list_requires_project_flag`, but `BC-X.7.002` still described the old
    loose assertion. Adjacent class: spec test-assertion descriptions
    drifting from test bodies (the product-owner's `FIX-P5-008` audit found 7
    mismatches: the three `user_list_requires_project_flag` descriptions, the
    `EC-X.14.004-9`/`-10` fixture descriptions, and `VP-SEC-001-002`'s
    identity-collapse test description). Candidate: when a fix strengthens or
    renames a test, grep the spec corpus for that test name and update every
    describing surface in the same fix; or a guard that flags spec prose naming
    a test whose body no longer matches. Source: F5 Pass 7 finding `P7-001`
    (LOW). Handled by `FIX-P5-008` (`D-402`). Recorded 2026-10-02. (Item `#51`
    is recorded in the Disposition notes below.)

53. **[process-gap] [spec-code-parity]** No mechanical parity guard between
    hand-copied resolvers. `BC-X.14.001` Invariant 3 asserted that
    `src/cli/field.rs` and `src/cli/issue/field_resolve.rs` are mirrored copies
    ("a change to one must be mirrored"), but `D-399`/`FIX-P5-005` added the
    field-ID step, `FIELD_ID_HINT` and sanitization to `field.rs` only, and
    nothing flagged the divergence for several passes. User-visible effect:
    `jr field options fixVersions` resolves while
    `jr issue edit --field fixVersions=` exits 64. Resolved spec-only by `D-405`
    (option (a): divergence documented as deliberate, Invariant 3 reworded,
    spec `2.8.7`); the shared contract (`customfield_` bypass, cache-first
    load/fetch, refresh-once) is now explicit. Candidate: either unify the
    search step into one shared function (feature request `FIELD-ID-RESOLUTION-
    UNIFY` -> #904) or add a test/guard that pins the intended shared-vs-
    divergent behavior of the two resolvers so a spec "mirrored" claim cannot
    silently go stale. Source: F5 Pass 10 finding `P10-001` (MEDIUM). Recorded
    2026-10-03.

## Disposition

**Dispositioned 2026-10-05 (human decision `D-408`, "split by owner").** 53
items (`#51` has no numbered entry above; it is recorded only in the notes
below): **45 ENGINE** (`#3 #4 #7 #9 #10 #11 #12 #13 #14`-`#49 #51`) consolidated
in `cycles/cycle-014/engine-handoff-vsdd-factory.md` for the vsdd-factory repo;
**8 JR-TOOLING** (`#1 #2 #5 #6 #8 #50 #52 #53`) tracked as STATE.md Drift Items
(target next maintenance sweep; `#50`/`#52`/`#53` already had rows). Stories:
`#46` -> `S-PG-FIX-PR-ADV-CONVERGENCE-1` (draft, engine-side), and
`P11-001`/#906 -> `S-PG-BC-INDEX-H1-SYNC-1` (draft). Nothing left undispositioned.
History of how the items were recorded follows (original text, unchanged).

Original text: F2 is CONVERGED per human decision `D-383` and
APPROVED at the F2 human gate (`D-384`) — the S-7.02 cycle-closing checklist
dispositions each of these 53 items when cycle-014 itself closes, not
before. **Human decision `D-389` (2026-09-29)** closed F3 adversarial
convergence directly (bypassing further dispositioning of `#1`-`#25` as a
precondition) and directed that items `#26`-`#31` above be recorded now,
each flagged as needing a follow-up story or an explicit deferral decision
before cycle-014 closes. Items `#32`-`#33` were recorded during STORY-A's F4
Step 4.5 convergence + demo-evidence-relocation burst (2026-09-29). Item
`#34` was recorded during STORY-A's F4 merge burst (PR #886, D-391,
2026-09-29). Item `#35` was recorded during STORY-C's F4 Step 4.5
convergence + demo-evidence-relocation burst (2026-09-29). Item `#36` was
recorded during STORY-C's F4 merge burst (PR #887, this burst, 2026-09-30).
Item `#37` was recorded during cycle-014's F4-completion combined wave
integration gate (this burst, 2026-09-30). Items `#38`-`#39` were recorded
during `FIX-P5-001`'s implementation + spec `[2.5.1]` correction burst
(2026-09-30). Items `#40`-`#45` were recorded during `FIX-P5-001`'s PR
review, merge, and state-burst recording (PR #891 @ `769365ab`, this burst,
2026-10-01): the scope-creep loop across `D-393`/`D-394`/`D-395`, the
narrow initial sink inventory, the hung security-reviewer dispatch, the
nonexistent `pr-manager` merge wrapper scripts, the `FUEL_EXHAUSTED`
hook-vs-persisted-write inconsistency, and the read-only-dispatch-vs-
posting-hook conflict. All are the same disposition class as `#26`-`#31`
(needs a follow-up story or explicit deferral before cycle-014 closes).
Items `#46`-`#49` were recorded during cycle-014 F5 pass 1 (adversary +
code-reviewer + security-reviewer, `D-396`, `FIX-P5-002` spec-delta
v2.5.6) and this state-burst recording (this burst, 2026-10-01): fix PRs
lacking their own adversary-convergence record; an approved behavior
change mis-read as a documentation premise; the `validate-factory-path-
staging` hook's `cd .factory && git add` false-positive; and the
input-hash self-reference hazard. Same disposition class as `#26`-`#45`
(needs a follow-up story or explicit deferral before cycle-014 closes).
Item `#50` was recorded during cycle-014 F5 pass 3 (`P3-005`, `D-398`,
2026-10-01): no guard for `.cargo/mutants.toml` `exclude_re` anchors. Same
disposition class as `#26`-`#49`.
Item `#51` was recorded at the `FIX-P5-005` (#897) merge (2026-10-02): the
`validate-factory-path-staging` hook false-positived on the implementer's
`git add -A` inside the fix worktree (`.worktrees/FIX-P5-005`) because it
judges the branch of the pre-command cwd rather than the worktree the
command targets (same hook as `#48`, different trigger). Workaround used:
`git commit -a`; the orchestrator verified no untracked files were omitted
and no `.factory` paths were committed. Later dispatches instruct explicit
`git -C <worktree> add <paths>`. Same disposition class as `#26`-`#50`.
