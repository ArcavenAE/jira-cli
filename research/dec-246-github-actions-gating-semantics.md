---
document_type: research
date: 2026-08-09
decision_id: DEC-246
story_id: S-626-1
topic: >-
  GitHub Actions gating semantics the `ci-gate` required-check design rests on —
  the `needs` context contract, `always()` vs `!cancelled()`, the skipped-required-check
  false-green mechanism S-CIGATE-2 fixed, matrix jobs in `needs`, required-check name
  matching, merge queue / Required Workflows availability, and re-run semantics.
  Reconstruction and independent re-validation of the 2026-08-08 research pass
  recorded as DEC-246, for which no artifact file was ever written.
status: partially_conclusive
confidence: mixed
verification_method: >-
  Primary sources only — official GitHub documentation pages fetched verbatim,
  github.blog changelog entries, and the `actions/runner` / `orgs/community`
  repositories. Local `.github/workflows/ci.yml` and `tests/ci_gate_completeness.rs`
  inspection (including `git show 9d34f354`) used to ground each claim against
  what this repository actually does. No claim in this document rests on model
  training data; every factual assertion carries a URL and an access date.
  Nothing was executed against live GitHub Actions infrastructure.
reconstruction: true
reconstructed_on: 2026-08-09
original_pass_date: 2026-08-08
sources:
  - https://docs.github.com/en/actions/reference/workflows-and-actions/contexts
  - https://docs.github.com/en/actions/reference/workflows-and-actions/expressions
  - https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax
  - https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-jobs
  - https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/run-job-variations
  - https://docs.github.com/en/actions/how-tos/manage-workflow-runs/re-run-workflows-and-jobs
  - https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
  - https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/troubleshooting-required-status-checks
  - https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue
  - https://github.blog/changelog/2023-07-12-pull-request-merge-queue-is-now-generally-available/
  - https://github.blog/changelog/2023-08-02-github-actions-required-workflows-will-move-to-repository-rules/
  - https://github.blog/changelog/2023-10-11-requiring-workflows-with-repository-rules-is-generally-available/
  - https://github.com/actions/runner/issues/1961
  - https://github.com/actions/runner/issues/2598
  - https://github.com/orgs/community/discussions/27096
  - https://github.com/orgs/community/discussions/52505
  - https://github.com/orgs/community/discussions/179993
---

# DEC-246 — GitHub Actions gating semantics for `ci-gate`

## Provenance note — READ FIRST

**This artifact was reconstructed on 2026-08-09. It is not the original research
pass.** The original pass ran on 2026-08-08, answered eight questions about GitHub
Actions gating semantics against primary sources, returned CONFIRM on all eight,
and surfaced the finding labelled **U1**, which became commit `9d34f354`. It was
recorded as decision **DEC-246** and it drove a real code change. **No research
artifact file was ever written for it.** Nothing in `.factory/research/` postdates
2026-07-30 and `RESEARCH-INDEX.md` was last touched 2026-07-24.

The only surviving record of the original pass is narrative prose in
`.factory/cycles/cycle-001/burst-log.md` (section `### Burst Summary:
RESEARCH-VALIDATION+U1 (2026-08-08)`, approx. lines 8968–9002), corroborated by
`.factory/STATE.md` (the DEC-246 Decisions Log row) and
`.factory/cycles/cycle-001/session-checkpoints.md` (line ~2104). That prose
itemizes **six** of the eight confirmations. **Two confirmations, and the specific
reasoning that retired the planned "sibling-workflow exposure" inspection frontier,
were not written down anywhere and are not recoverable.**

What this document does:

1. **Recovers** the six recorded confirmations verbatim from `burst-log.md` and
   labels them `RECORDED`.
2. **Reconstructs** the two missing questions, labelled `INFERRED`, with the
   evidence trail that supports each inference stated explicitly. The inference
   is a reconstruction, not a recovered fact, and is marked as such at every
   point of use.
3. **Independently re-validates** every question against primary sources on
   2026-08-09, labelled `NEWLY-RESEARCHED`. The 2026-08-09 verdicts are the
   operative ones. Where a 2026-08-09 verdict differs from what the 2026-08-08
   pass recorded, the difference is called out in full.
4. Adds **Q8 (re-run semantics)**, which has no trace in any surviving record and
   was almost certainly *not* among the original eight — it is included because it
   is a real question about the gate's behavior that nothing in this repository
   had answered.

**What could not be recovered:**

- The exact wording of the two unitemized questions, and their exact verdicts.
- The reasoning that retired the "sibling-workflow exposure" frontier. `burst-log.md`
  states only that the frontier "has been substantially answered by research"; the
  substance of that answer is gone. **See §"Sibling-workflow frontier" below — on
  the 2026-08-09 evidence the retirement is NOT supported.**
- Whether the original pass distinguished merge queue and Required Workflows as
  two questions or one (they are bundled into a single bullet in the record).
- The verbatim source URLs and access dates the original pass used. Every URL in
  this document was fetched on 2026-08-09 by this reconstruction, not carried over.

**Set mismatch, stated plainly.** The eight questions this document answers are
*not* the same set as the original eight. Two of the six recorded confirmations —
the `re-actors/alls-green` convergent-evidence item and the `continue-on-error`
item — are outside the eight-question frame used here, and are preserved verbatim
in §"Recorded confirmations outside this document's eight questions" rather than
being dropped.

---

## Repository state this document is grounded against

| Fact | Value | How verified (2026-08-09) |
|---|---|---|
| `develop` HEAD | `df203233` | `git log --oneline -1` |
| `ci-gate` job `needs` | `[fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]` | `.github/workflows/ci.yml` |
| `ci-gate` job `if:` | `${{ always() }}` | `.github/workflows/ci.yml` |
| `ci-gate` gate step | `env: NEEDS_JSON: ${{ toJSON(needs) }}` → `run: echo "${NEEDS_JSON}" \| bash scripts/check-ci-gate.sh` | `.github/workflows/ci.yml` |
| All `ci.yml` job ids | `fmt, clippy, test, msrv, deny, coverage, spec-guard, security, mutants, check-signing-workflow-injection, ci-gate` | `grep -nE '^  [a-zA-Z0-9_-]+:'` |
| Jobs excluded from `needs` | `security`, `coverage` | `PINNED_GATE_EXCLUDED_JOBS` at `tests/ci_gate_completeness.rs:708` **on `9d34f354`** |
| `NEEDS_CONTEXT_JOB_KEYS` | `&["outputs", "result"]` | `tests/ci_gate_completeness.rs:4543` on `9d34f354` |
| `mutants` job `if:` | `github.event_name == 'pull_request'` | `.github/workflows/ci.yml` |
| `clippy` matrix | `os: [ubuntu-latest, windows-latest]` — **static literal** | `.github/workflows/ci.yml` |
| `test` matrix | `os: [ubuntu-latest, macos-latest, windows-latest]` — **static literal** | `.github/workflows/ci.yml` |

**Note on `9d34f354`:** the U1 fix is on branch `ci/fix-toolchain-sha-msrv` (PR #667,
HELD per DEC-202) and is **not** on `develop`. `PINNED_GATE_EXCLUDED_JOBS` does not
exist in the `develop` working tree; it was read via `git show
9d34f354:tests/ci_gate_completeness.rs`. Any future reader checking `develop` and
finding the constant absent is looking at the right thing in the wrong place.

---

## Q1 — `needs` context: exposed properties and `result` domain

**Label:** `RECORDED` (partially — the record itemizes the `result` domain and the
stability-guarantee observation, not the property-set completeness question) +
`NEWLY-RESEARCHED`.

**What the project believes:** `needs.<job_id>` exposes exactly two properties,
`result` and `outputs`; `NEEDS_CONTEXT_JOB_KEYS` pins that set. `result`'s domain
is `success | failure | cancelled | skipped`, and that domain carries no published
stability guarantee — which is the stated rationale for `check-ci-gate.sh`'s
default-fail arm.

**What the 2026-08-08 pass recorded** (verbatim from `burst-log.md`):

> (3) `needs.<job>.result`'s documented domain (`success | failure | cancelled |
> skipped`) carries no published stability guarantee, strengthening the rationale
> for the script's default-fail arm.

**2026-08-09 primary source.** GitHub Docs, "Contexts",
https://docs.github.com/en/actions/reference/workflows-and-actions/contexts
(accessed 2026-08-09). The `needs` context property table is, in full:

| Property name | Type | Description |
|---|---|---|
| `needs` | `object` | Contains the outputs of all jobs that are defined as a dependency of the current job. |
| `needs.<job_id>.result` | `string` | The result of a job that the current job depends on. |
| `needs.<job_id>.outputs` | `object` | The set of outputs of a job that the current job depends on. |
| `needs.<job_id>.outputs.<output_name>` | `string` | The value of a specific output for a job that the current job depends on. |

The page states `result` can be `success`, `failure`, `cancelled`, or `skipped`.

**Verdict: CONFIRM.** The per-job property set is exactly `{result, outputs}` —
`NEEDS_CONTEXT_JOB_KEYS = &["outputs", "result"]` is **complete and current as of
2026-08-09**. The `result` domain is confirmed as the four documented values. The
round-8 removal of a phantom `outcome` field (which belongs to the `steps` context,
not `needs`) is re-confirmed correct: `outcome` does not appear in the `needs` table.

**Caveat, stated rather than smoothed over.** "No published stability guarantee" is
an argument from absence: the docs publish no versioning or stability commitment
for this enum, and no page found on 2026-08-09 promises the domain will not grow.
That absence is real and it does support the default-fail arm, but it is weaker
evidence than a positive documented statement would be, and the record's phrasing
("carries no published stability guarantee") should be read that way.

---

## Q2 — Job-level `if:` × `needs`; skipped upstream; `always()`

**Label:** `RECORDED` + `NEWLY-RESEARCHED`.

**What the project believes:** `if: ${{ always() }}` on `ci-gate` is the only correct
condition. Without it, `ci-gate` would itself be skipped whenever any needed job is
skipped or fails — and a skipped required check reports Success (Q3), which is the
very false-green the gate exists to prevent.

**What the 2026-08-08 pass recorded** (verbatim):

> (2) `always()` is the ONLY correct choice among three plausible conditions:
> `!cancelled()` -- GitHub's own recommendation for "regardless of success or
> failure" -- is WRONG here, because on a cancelled run the gate would not execute
> and the resulting skipped status still counts as success; `success() || failure()`
> fails to cover a pure upstream skip. Recorded as a live trap for any future
> maintainer who finds `always()` inelegant.

**2026-08-09 primary sources.**

1. GitHub Docs, "Using jobs in a workflow",
   https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-jobs
   (accessed 2026-08-09), verbatim:

   > If a job fails or is skipped, all jobs that need it are skipped unless the
   > jobs use a conditional expression that causes the job to continue.

   and, for the override:

   > use the `always()` conditional expression in `jobs.<job_id>.if`

2. GitHub Docs, "Expressions",
   https://docs.github.com/en/actions/reference/workflows-and-actions/expressions
   (accessed 2026-08-09), verbatim:

   - `always()` — "Causes the step to always execute, and returns true, even when
     canceled."
   - Warning: "Avoid using `always` for any task that could suffer from a critical
     failure, for example: getting sources, otherwise the workflow may hang until
     it times out."
   - "If you want to run a job or step regardless of its success or failure, use
     the recommended alternative: `if: ${{ !cancelled() }}`"

**Verdict: CONFIRM**, with the sub-claims separated by strength.

- *Default skip propagation:* CONFIRM, directly documented. A needed job that is
  skipped or fails skips its dependents unless a conditional says otherwise.
- *`always()` is the documented override:* CONFIRM, directly documented — GitHub's
  own jobs page names `always()` in `jobs.<job_id>.if` for exactly this purpose.
- *`!cancelled()` is wrong for this gate:* **CONFIRM (derived, not directly
  documented).** GitHub does recommend `!cancelled()` generally [primary, Expressions
  page]. A `skipped` required check satisfies branch protection [primary, Q3 below].
  It follows that on a cancelled run `!cancelled()` evaluates false, `ci-gate` is
  skipped, and the skipped check satisfies the required-check rule — merge-eligible.
  **That last step is a deduction from two primary facts; GitHub nowhere states it.**
  The deduction is sound but it is reasoning, not citation, and no artifact should
  present it as a documented GitHub statement.
- *`success() || failure()` misses a pure upstream skip:* CONFIRM (derived, same
  class). `failure()` is documented as returning true when a previous step fails
  or an ancestor job fails; neither `success()` nor `failure()` is documented to
  return true for a pure upstream *skip*, so the disjunction leaves that case
  uncovered.

**New material this reconstruction adds — a trap in the opposite direction.** The
Expressions page carries an explicit WARNING against `always()`. A future maintainer
reading that warning in isolation has documented-looking grounds to "fix" `ci-gate`'s
`if:`. The warning's stated rationale is workflow hang risk on tasks that can suffer
a critical failure ("for example: getting sources"). `ci-gate`'s only work is a
checkout plus a single-second bash invocation of `scripts/check-ci-gate.sh`, so the
rationale does not apply here. This is now guarded in code — `PINNED_GATE_IF_EXPR`
pins `${{ always() }}` byte-for-byte (M2-m) — but the *reason* the general
recommendation is inapplicable was not written down anywhere before this document.

---

## Q3 — Does a required check that never runs report pending, absent, or success?

**Label:** `RECORDED` + `NEWLY-RESEARCHED`. This is the founding question of S-CIGATE-2.

**What the project believes:** a job skipped by a job-level conditional reports
**Success** to branch protection and does not block merge. That is the false-green
mechanism S-CIGATE-2 exists to close.

**What the 2026-08-08 pass recorded** (verbatim):

> (1) A skipped required check reports "Success" and does not block merge --
> confirms the original false-green diagnosis and the fail-closed inversion.

**2026-08-09 primary sources.**

1. GitHub Docs, "About protected branches",
   https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
   (accessed 2026-08-09), verbatim:

   > Required status checks must have a `successful`, `skipped`, or `neutral`
   > status before collaborators can make changes to a protected branch.

2. GitHub Docs, "Troubleshooting required status checks",
   https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/troubleshooting-required-status-checks
   (accessed 2026-08-09), "Handling skipped but required checks" — three distinct
   scenarios:

   | Cause of skip | Reported status | Blocks merge? |
   |---|---|---|
   | Path filtering / branch filtering / commit message skip | **Pending** | **Yes** |
   | Job skipped by a job-level conditional (`if:`) | **Success** | **No** |
   | Job skipped because a needed job failed | skipped | may not block |

   The same page also documents the never-runs case: a check whose workflow is
   path-filtered away and never triggers leaves the PR "Waiting for status to be
   reported" and blocked.

**Verdict: CONFIRM — and it is the strongest-sourced item in this document.** The
`about-protected-branches` sentence is decisive: `skipped` is enumerated alongside
`successful` and `neutral` as a status that *satisfies* a required check. The
conditional-skip → Success → no-block path is documented explicitly on the
troubleshooting page.

**Answering the question as posed** ("pending / absent / success"): all three
outcomes are real and the distinction is which mechanism caused the check to not
run. **A check that never *starts* (never triggered, e.g. path-filtered) blocks
forever — fail-safe. A check that starts and is *skipped by a job-level `if:`*
reports Success — fail-open.** That asymmetry is the entire bug class. Anything
that turns `ci-gate` from the first kind into the second is a live false-green,
which is why round 11's `PINNED_GATE_IF_EXPR` (`ci-gate`'s own `if:`) matters as
much as any pin on its `needs` members.

---

## Q4 — Matrix jobs in `needs`; the zero-leg case

**Label:** `INFERRED` that this was one of the original eight + `NEWLY-RESEARCHED`.

**Basis for the inference (reconstruction, not a recovered fact).** `burst-log.md`
lists `ZERO-LEG-MATRIX-RESULT-UNDOCUMENTED` (MEDIUM) among the six drift items it
attributes to this research pass, describing it as: "`clippy`/`test` are matrix jobs
in `ci-gate.needs`; `jobs.<id>.if` evaluates before `strategy.matrix` is applied and
what `needs.result` yields for a zero-leg matrix is undocumented, with community
reports split between `skipped` (safe) and `success` (silent false green)". A drift
item that specific is the residue of a question that was asked. **This is the
strongest available inference and it is still an inference — the original question's
wording and verdict are lost.**

**Note the tension the reconstruction must not paper over:** the record says the pass
returned CONFIRM on all eight, yet this item is recorded as UNDOCUMENTED. The most
coherent reading is that the question's *general* half (matrix parents do participate
in `needs`, and legs aggregate into one `result`) confirmed, while the *zero-leg*
sub-case did not and was spun out as the drift item. That reading is a reconstruction.

**2026-08-09 primary sources.** GitHub Docs, "Running variations of jobs in a
workflow",
https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/run-job-variations
(accessed 2026-08-09): "A job will run for each possible combination of the
variables." The page does **not** state how a matrix job's overall status is
determined, does **not** address whether an empty matrix is permitted, and does
**not** document any zero-leg error. The workflow-syntax and contexts pages are
likewise silent on matrix-parent → `needs.result` aggregation.

**Community (secondary, labelled as such).**
- https://github.com/orgs/community/discussions/27096 (accessed 2026-08-09) — a
  *dynamic* matrix (`fromJSON`) evaluating to zero elements produces a hard error,
  "Error when evaluating 'strategy' for job … does not contain any values". An
  errored job would report `failure` — fail-closed.
- https://github.com/orgs/community/discussions/179993 (accessed 2026-08-09) — a
  matrix whose combinations are all removed by `exclude` runs the job **once** with
  empty matrix variables rather than skipping.
- https://github.com/orgs/community/discussions/37883 and
  https://github.com/actions/runner/issues/1985 (accessed 2026-08-09) — the `matrix`
  context is not available in `jobs.<job_id>.if`, consistent with the drift item's
  premise that the job-level `if:` is evaluated before the matrix is expanded.

**Verdict: INCONCLUSIVE. Not softened to CONFIRM.** No primary source documents
matrix-parent aggregation into `needs.<job>.result`, and no primary source documents
the zero-leg case at all. The two community reports describe *different mechanisms*
(dynamic-empty vs. fully-excluded) with *different outcomes* (hard error vs. one
degenerate run), so they do not even converge on a single community answer, let
alone a documented one. `ZERO-LEG-MATRIX-RESULT-UNDOCUMENTED` stands as an open item
and the burst-log's instruction — "resolvable empirically in one ~20-minute throwaway
PR; do not resolve by inference" — remains the correct disposition.

**New material this reconstruction adds — a reachability finding that changes the
item's priority.** `ci.yml`'s two matrix jobs both use **static literal** matrices:
`clippy` has `os: [ubuntu-latest, windows-latest]` and `test` has
`os: [ubuntu-latest, macos-latest, windows-latest]`. A static literal list cannot
evaluate to zero legs. **The zero-leg case is therefore not reachable in `ci.yml`
as it stands today** — it becomes reachable only if someone converts one of these to
a dynamic `fromJSON()` matrix. That does not close the item (the conversion is an
ordinary maintenance action, exactly the class of change U1 was about), but it
does mean the risk is latent rather than live, and it suggests the cheaper guard
may be a test asserting these matrices stay static rather than a live empirical
probe. Recommend recording this on the drift item.

---

## Q5 — Required-check name matching across workflow files

**Label:** `INFERRED` that this was one of the original eight + `NEWLY-RESEARCHED`.

**Basis for the inference (reconstruction, not a recovered fact).** `burst-log.md`
attributes the drift item `DUPLICATE-CHECK-NAME-BEHAVIOR-UNDOCUMENTED` (LOW) to this
pass: "required-check matching is by the job's `name:` string (`CI Gate`) and ignores
the workflow file; whether two same-named check runs are all-must-pass or any-passes
is undocumented; research explicitly declined to claim a working bypass; every
existing guard is anchored to `ci.yml`, this vector never touches it." Same reasoning
as Q4: that is the residue of a question. Same caveat: it is an inference.

**2026-08-09 primary sources.**

1. GitHub Docs, "About protected branches" (URL above, accessed 2026-08-09),
   verbatim:

   > If you use branch protection rules that require specific status checks, make
   > sure that job names are unique across all workflows. Using the same job name
   > in multiple workflows can cause ambiguous status check results.

2. GitHub Docs, "Troubleshooting required status checks" (URL above, accessed
   2026-08-09), verbatim:

   > If a check and a commit status have the same name, both must pass when that
   > name is required.

**Verdict: split.**

- *Matching is by the job's `name:` string, and the declaring workflow file is not
  part of the check's identity:* **CONFIRM.** GitHub's warning is only coherent if
  name is the identity and the workflow file is not — otherwise same-named jobs in
  different workflows could not be ambiguous. The second quote confirms name
  collision across *different producers* (a check run and a commit status) is
  resolved by requiring both.
- *What happens with two same-named check runs from two workflows:* **INCONCLUSIVE.**
  GitHub does not document the resolution. Note the precise wording: GitHub does not
  merely omit this — it calls the result **"ambiguous"** in its own documentation and
  tells you not to do it. That is stronger than "undocumented"; it is a
  documented warning that the behavior is not well-defined.

**Consequence for the branch-protection string.** The required check is the job
`name:` value `CI Gate`, not the job id `ci-gate`. Nothing in the repository pins
that string, because branch-protection configuration is not in the repository —
`REQUIRED-CHECK-NAME-UNPINNED` (LOW) is confirmed as a real gap. Its drift direction
is fail-safe: if `name:` is edited, the required check `CI Gate` never arrives and,
per Q3's never-runs path, every PR blocks on "Waiting for status to be reported"
rather than silently passing. Undetectable until a PR wedges, but not a false-green.

---

## Q6 — Merge queue availability (`merge_group`)

**Label:** `RECORDED` (bundled with Q7 in a single record bullet) + `NEWLY-RESEARCHED`.

**What the project believes:** merge queue is not an available alternative to this
gate design, because the repository is personal-account-owned.

**What the 2026-08-08 pass recorded** (verbatim, bundled):

> (5) The pattern is not obsolete: no first-party successor removes this bug class;
> merge queue is unavailable to a personal-account repo (GHEC/org-owned public repos
> only per the 2023-07-12 GA note); org-level Required Workflows was retired
> 2023-10-18.

**2026-08-09 primary source.** GitHub Changelog, "Pull request merge queue is now
generally available!", published **2023-07-12**,
https://github.blog/changelog/2023-07-12-pull-request-merge-queue-is-now-generally-available/
(accessed 2026-08-09), verbatim:

> Merge queue is available on private and public repos on the GitHub Enterprise
> Cloud plan and all public repos owned by organizations.

**Verdict: CONFIRM, with an explicit recency caveat that must not be dropped.**

The 2023-07-12 GA statement is unambiguous and it excludes a public repository owned
by a **personal account**, which is what this repository is. On that statement,
merge queue is unavailable here.

**The caveat:** the current docs page,
https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue
(accessed 2026-08-09), **contains no availability or eligibility statement at all**.
It documents that "You **must** use the `merge_group` event to trigger your GitHub
Actions workflow when a pull request is added to a merge queue" and that "A merge
queue will wait for required checks to be reported before it can proceed with
merging", but says nothing about which plans or account types can use the feature.
So the load-bearing citation for the constraint is a **three-year-old changelog
entry**, and this reconstruction **could not re-verify from any dated 2026 primary
source that the constraint still holds**. Confidence: HIGH that the statement was
true on 2023-07-12; MEDIUM that it is still true on 2026-08-09. If the availability
question ever becomes decision-relevant again, re-verify it rather than citing this
document.

---

## Q7 — Org-level Required Workflows retirement

**Label:** `RECORDED` (bundled with Q6) + `NEWLY-RESEARCHED`.

**2026-08-09 primary sources.**

1. GitHub Changelog, "GitHub Actions: Required Workflows will move to Repository
   Rules", published **2023-08-02**,
   https://github.blog/changelog/2023-08-02-github-actions-required-workflows-will-move-to-repository-rules/
   (accessed 2026-08-09), verbatim:

   > On October 18th, users will no longer be able to access Actions Required
   > Workflows and must use rulesets in its place.

   Transition opened 2023-09-20; existing private-beta users retained access until
   2023-10-18.

2. GitHub Changelog, "Requiring workflows with Repository Rules is generally
   available", published **2023-10-11**,
   https://github.blog/changelog/2023-10-11-requiring-workflows-with-repository-rules-is-generally-available/
   (accessed 2026-08-09) — the successor mechanism, GA.

**Verdict: CONFIRM.** Required Workflows was retired **2023-10-18**; the recorded
date is exactly right.

**One precision this reconstruction adds to the record's framing.** The record says
"no first-party successor removes this bug class". A first-party **successor
mechanism does exist** — requiring workflows via repository rulesets, GA since
2023-10-11. The record's claim is nonetheless correct on its own terms, and for a
reason worth stating rather than leaving implicit: rulesets require a *workflow to
pass*, and a workflow's jobs are still subject to the identical skipped-status
semantics established in Q3. Switching to rulesets would relocate this bug class,
not remove it. The claim should be phrased that way in future artifacts —
"a successor exists and inherits the same bug class" is both more accurate and a
stronger argument than "no successor exists".

---

## Q8 — Re-run semantics: `needs.<job>.result` on attempt ≥ 2

**Label:** `NEWLY-RESEARCHED`. **Not one of the original eight.** No trace of this
question exists in `burst-log.md`, `STATE.md`, `session-checkpoints.md`, or any drift
item. It is included because it is a real question about the gate's behavior that
nothing in this repository had answered.

**2026-08-09 primary source.** GitHub Docs, "Re-running workflows and jobs",
https://docs.github.com/en/actions/how-tos/manage-workflow-runs/re-run-workflows-and-jobs
(accessed 2026-08-09). On re-runs generally it states only:

> The workflow will also use the same `GITHUB_SHA` (commit SHA) and `GITHUB_REF`
> (git ref) of the original event that triggered the workflow run.

The page is **silent** on: what happens to jobs that are not re-run, whether their
results carry into the new attempt's `needs` context, and whether downstream
dependents are re-executed.

**Repository-hosted issue reports (secondary — filed by users in GitHub-owned
repositories, not documentation; labelled as such).**
- https://github.com/actions/runner/issues/1961, "Runner does not re-run dependent
  jobs for 'Re-run failed jobs'" (accessed 2026-08-09) — reports that dependents are
  not actually re-executed and that outputs from the previous attempt are spliced in.
- https://github.com/actions/runner/issues/2598, "Failed job outputs from previous
  attempts re-used on 'Re-run failed jobs'" (accessed 2026-08-09) — same class.
- https://github.com/orgs/community/discussions/52505 (accessed 2026-08-09) — in
  matrixed reusable workflows, only the failed jobs re-run, not their dependents.

**Verdict: INCONCLUSIVE on primary sources.** Community evidence consistently
indicates that on "Re-run failed jobs" the results and outputs of jobs that are not
re-executed are carried forward from the previous attempt into the new attempt's
`needs` context. That is a coherent and repeatedly-reported picture, but it is not
documented, and this document does not upgrade it to CONFIRM.

**Assessment for `ci-gate` (reasoning, not a tested claim — flagged as such).**
`ci-gate` carries `if: ${{ always() }}` and depends on every needs member, so it is
a downstream dependent of any failed job and is re-run on a partial re-run. It will
then read a `needs` payload that may mix freshly-computed results with
carried-forward ones. Because `check-ci-gate.sh` is fail-closed — any result that
is not `success`, and not an allowlisted `skipped`, fails the gate — a carried-forward
`failure` keeps the gate red (safe). The theoretical false-green direction would be
a carried-forward `success` masking a job that would now fail; but a job that is not
re-executed has no new outcome to mask. **No false-green path was identified here.
This was not tested against a real runner and should not be cited as verified.**

---

## The U1 finding, and how `9d34f354` closed it

**Label:** `RECORDED` (this part of the original pass survives in full).

**U1 as recorded** (verbatim from `burst-log.md`):

> `test_ci_gate_needs_exactly_the_required_jobs` pinned `needs` against a hardcoded
> 8-name literal and the exclusion test denied exactly two names -- nothing asserted
> the partition. A ninth job added to `ci.yml` with `ci-gate` untouched left both
> tests green while the job went entirely unenforced. Same defect shape as the
> original false-green, one level up: an allowlist with no default-deny over its
> universe, fixed at the result-value layer (`ALLOWED_SKIPS` + default-fail arm) and
> never applied at the needs-set layer.

**The fix, verified 2026-08-09 via `git show 9d34f354`:**

- New constant `PINNED_GATE_EXCLUDED_JOBS: &[&str] = &["security", "coverage"]`
  (`tests/ci_gate_completeness.rs:708` on `9d34f354`).
- New test `test_ci_gate_needs_partitions_all_ci_yml_jobs` — asserts the partition
  in **both** directions: a job in neither `ci-gate.needs` nor
  `PINNED_GATE_EXCLUDED_JOBS` fails, and a job in **both** also fails as incoherent.
  The diagnostic forces an explicit maintainer choice with no default path.
- New test `test_skip_tolerant_needs_members_matches_pinned_if_expressions` — binds
  `PINNED_GATE_EXCLUDED_JOBS` membership to the pinned `if:` expressions so the
  allowlist and its justifying conditions cannot drift apart.
- `list_all_ci_yml_job_names` made fully portable; the "always-run" job literals in
  two sibling tests re-derived from the live needs set instead of a hand-maintained
  list.
- Commit `9d34f354`, `tests/ci_gate_completeness.rs` only, +284/−33. Head
  `7f8723a5` → `9d34f354`. CI FINAL 15/15 PASS, `mergeStateStatus: CLEAN`.
  `#[test]` count 22 → 24.

**Why the internal passes could not find it** (the record's own framing, preserved
because it is the point of the decision): every one of the 50 adversarial passes
reasoned *within* the project's model of GitHub's semantics; none questioned whether
the model was right. Validating the model against primary sources found the gap the
model could not see from inside.

**Independent assessment, 2026-08-09.** U1's diagnosis holds and the fix is
correctly shaped. It is the same default-deny discipline applied one layer up: the
result-value layer had `ALLOWED_SKIPS` plus a default-fail arm, and the needs-set
layer had an enumeration with no universe to close over. The partition assertion
supplies the missing universe (`list_all_ci_yml_job_names`). One residual worth
naming: the partition is only as complete as `list_all_ci_yml_job_names`'s
extraction, which is line-based — and per the round-16 record in `CLAUDE.md`, YAML
node properties (`&anchor` / `!!tag`) defeat line-based key extraction in this file
generally. A job declared as `&x ninth-job:` would be invisible to the partition
test for the same reason it is invisible to every other set-equality pin. That is
the already-documented, already-accepted round-16 residual, not a new finding — but
U1's fix inherits it rather than escaping it, and no surviving record says so.

---

## Recorded confirmations outside this document's eight questions

Preserved verbatim from `burst-log.md` so they are not lost by the reframing. These
were part of the original six itemized confirmations.

**(4) Convergent evidence on the design's shape:**

> `check-ci-gate.sh` is an independent reimplementation of `re-actors/alls-green`,
> the canonical community solution, matching its contract (`toJSON(needs)` in,
> allowlist, always-run) -- convergent evidence the shape is right.

*2026-08-09 note:* not re-validated by this reconstruction. It is an argument from
convergence with a community action, not a primary-source claim, and it was recorded
as such.

**(6) `continue-on-error` semantics:**

> `continue-on-error` step-level semantics are officially documented; the job-level
> → `needs.result` mapping is community-sourced only (`actions/runner#1251`) --
> recorded so no artifact overstates it.

*2026-08-09 note:* not re-validated by this reconstruction. The record's own
discipline here is worth preserving — it explicitly flags the job-level mapping as
community-sourced. This matters because round 10's M2-j rejects the literal substring
`continue-on-error` anywhere in the `ci-gate` job block, and the *reason* that
matters at job level rests on the weaker half of this item.

---

## Sibling-workflow frontier — retirement is NOT supported by the evidence

`burst-log.md` states:

> The previously-proposed pass-56 frontier (sibling-workflow exposure) has been
> substantially answered by research and should be replaced before any window is
> dispatched.

**The reasoning behind "substantially answered" was never written down and is not
recoverable.** The only surviving trace is the `DUPLICATE-CHECK-NAME-BEHAVIOR-UNDOCUMENTED`
drift item, which records that "research explicitly declined to claim a working
bypass; every existing guard is anchored to `ci.yml`, this vector never touches it."

**On the 2026-08-09 evidence, that does not support retiring the frontier.**

1. Declining to claim a working bypass is not evidence that no bypass exists. The
   drift item records an *absence of demonstration*, which the burst summary then
   reported as an *answer*.
2. The primary source is worse for the retirement than the drift item suggests.
   GitHub does not merely leave duplicate-name behavior undocumented — it states
   that "Using the same job name in multiple workflows can cause **ambiguous** status
   check results" and instructs maintainers to keep job names unique across all
   workflows. A frontier retired on the grounds that behavior is undocumented is
   weak; a frontier retired on behavior GitHub itself labels ambiguous and warns
   against is weaker still.
3. The drift item's own second clause is the strongest argument *for* keeping the
   frontier open, not closing it: "every existing guard is anchored to `ci.yml`,
   this vector never touches it." Every pin in `tests/ci_gate_completeness.rs` reads
   `ci.yml`. A sibling workflow file declaring a job with `name: CI Gate` is outside
   every one of those pins by construction — structurally the same blind spot as
   the workflow-level `defaults:` vector found in round 11, which was found precisely
   because someone looked outside the anchored scope.

**Recommendation:** treat the sibling-workflow-exposure frontier as **still open and
unevidenced**, not retired. If it is to be closed, close it on one of two grounds —
an empirical determination of duplicate-name resolution (the same ~20-minute
throwaway-PR method proposed for the zero-leg matrix question), or a guard that
enumerates `.github/workflows/*.yml` rather than `ci.yml` alone and asserts no other
workflow declares a job named `CI Gate`. The second is cheap, is decidable from the
repository, and needs no live experiment.

---

## Verdict summary

| # | Question | Recovery label | Verdict (2026-08-09) | Confidence |
|---|---|---|---|---|
| Q1 | `needs` context properties + `result` domain | RECORDED (partial) + NEWLY-RESEARCHED | **CONFIRM** — `{result, outputs}` complete; domain is the 4 documented values | HIGH (stability-guarantee sub-claim is an argument from absence) |
| Q2 | Job `if:` × `needs`; skipped upstream; `always()` | RECORDED + NEWLY-RESEARCHED | **CONFIRM** — skip propagation and the `always()` override are documented; `!cancelled()`/`success()\|\|failure()` rejections are sound derivations, not citations | HIGH (documented halves) / MEDIUM (derived halves) |
| Q3 | Required check that never runs: pending / absent / success | RECORDED + NEWLY-RESEARCHED | **CONFIRM** — conditional-skip → Success → no block; never-triggered → Pending → blocks | HIGH — best-sourced item here |
| Q4 | Matrix jobs in `needs`; zero-leg case | INFERRED + NEWLY-RESEARCHED | **INCONCLUSIVE** — no primary source; community reports describe different mechanisms with different outcomes | LOW — do not act on inference |
| Q5 | Required-check name matching across workflows | INFERRED + NEWLY-RESEARCHED | **CONFIRM** (name is the identity; workflow file is not) / **INCONCLUSIVE** (duplicate-name resolution — GitHub calls it "ambiguous") | HIGH / LOW respectively |
| Q6 | Merge queue availability | RECORDED (bundled) + NEWLY-RESEARCHED | **CONFIRM** per the 2023-07-12 GA note — personal-account repos excluded | HIGH as of 2023-07-12; **MEDIUM currency** — no 2026 primary source restates it |
| Q7 | Org-level Required Workflows retirement | RECORDED (bundled) + NEWLY-RESEARCHED | **CONFIRM** — retired 2023-10-18 | HIGH (with a framing precision: a ruleset successor exists and inherits the bug class) |
| Q8 | Re-run semantics on attempt ≥ 2 | NEWLY-RESEARCHED (not among the original eight) | **INCONCLUSIVE** — docs silent; community evidence consistent but not documented | LOW |

**Nothing was REFUTED.** No assumption the `ci-gate` design rests on was invalidated
by this re-validation. Two questions are INCONCLUSIVE (Q4, Q8) and one is half
INCONCLUSIVE (Q5's duplicate-name resolution); none of the three has been softened
into a confirm, and none of them is load-bearing for the gate's current pass/fail
decision path.

---

## New material this reconstruction contributes

Items below are not in any surviving record of the 2026-08-08 pass. They are
findings of the 2026-08-09 re-validation.

1. **Zero-leg matrix is currently unreachable in `ci.yml`.** Both matrix jobs use
   static literal `os:` lists. `ZERO-LEG-MATRIX-RESULT-UNDOCUMENTED` is latent, not
   live; it becomes live only on conversion to a dynamic `fromJSON()` matrix. A test
   asserting these matrices stay static may be a cheaper guard than a live probe.
   Recommend recording on the drift item.
2. **The `always()` warning is a trap in the opposite direction.** GitHub's
   Expressions page carries an explicit WARNING against `always()` and recommends
   `!cancelled()`. Its stated rationale (workflow hang risk on tasks that can suffer
   a critical failure) does not apply to a one-second bash invocation. That reason
   was nowhere recorded, leaving a future maintainer with documented-looking grounds
   to break the gate.
3. **"No first-party successor" is imprecise and understates the argument.**
   Requiring workflows via rulesets is a GA successor (2023-10-11); it inherits the
   same skipped-status semantics. "A successor exists and inherits the bug class" is
   both more accurate and stronger.
4. **Duplicate check names are documented as "ambiguous", not merely undocumented.**
   Materially stronger than what `DUPLICATE-CHECK-NAME-BEHAVIOR-UNDOCUMENTED` records,
   and it argues against the sibling-workflow frontier retirement.
5. **U1's partition test inherits the round-16 node-property residual.**
   `list_all_ci_yml_job_names` is line-based; a job key prefixed by a YAML anchor or
   tag is invisible to it, so the partition assertion has the same blind spot as
   every other set-equality pin in that file. Already-accepted class, but no record
   said the partition guard is inside it.
6. **Merge queue availability could not be re-verified from a 2026 source.** The
   current docs page states no eligibility criteria at all; the constraint rests on
   a 2023 changelog entry.

---

## Research methods

| Tool | Calls | Purpose |
|---|---|---|
| WebFetch | 11 | Direct retrieval of GitHub docs pages and github.blog changelog entries |
| WebSearch | 5 | Locating primary pages and `actions/runner` / `orgs/community` issue threads |
| Bash / git | 6 | Grounding every claim against `ci.yml`, `tests/ci_gate_completeness.rs`, and `git show 9d34f354` |
| Perplexity / Context7 | 0 | Not used — all questions concern GitHub's own documented behavior |
| Training data | 0 assertions | Every factual claim carries a URL and a 2026-08-09 access date |

**Not done, and not claimed:** nothing in this document was executed against live
GitHub Actions infrastructure. Q4 and Q8 are the two questions where that matters —
both are marked INCONCLUSIVE for exactly that reason, and both have a proposed
empirical resolution rather than an inferred answer.

**`grep` hazard, recorded for the next reader:**
`.factory/cycles/cycle-001/burst-log.md` (~9,000 lines) contains bytes that make
plain `grep` treat it as a binary file and return **silent false negatives** — it
reports "no match" for text that is present. Always use `grep -a` on that file.
