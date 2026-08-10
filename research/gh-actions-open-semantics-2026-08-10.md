---
document_type: research
date: 2026-08-10
decision_id: DEC-246-FOLLOWUP
story_id: S-626-1
topic: >-
  Six GitHub Actions behavioural questions left INCONCLUSIVE or carried as inferred
  premises by DEC-246, each underpinning a shipped `ci-gate` guard: zero-leg matrix
  → `needs.<job>.result`; `matrix.exclude` reaching zero; re-run / attempt-≥2
  semantics; duplicate required-check-name resolution; flow-style `jobs:` mapping
  acceptance by the real workflow parser; `$GITHUB_PATH` binary resolution and
  step-`env:` vs `$GITHUB_ENV` precedence.
status: partially_conclusive
confidence: mixed
verification_method: >-
  Primary sources only — official GitHub documentation pages fetched verbatim,
  github.blog changelog entries, the `actions/runner` repository source at `main`,
  and GitHub-hosted community discussions / issues where they are the only record
  (labelled SECONDARY at every point of use). Local `.github/workflows/ci.yml` and
  `git show a17939e2:tests/ci_gate_completeness.rs` inspection used to ground each
  claim against what this repository actually does. Every factual assertion carries
  a URL and a 2026-08-10 access date. Nothing was executed against live GitHub
  Actions infrastructure.
supersedes_partially: dec-246-github-actions-gating-semantics.md (Q4, Q8)
sources:
  - https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax
  - https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/run-job-variations
  - https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands
  - https://docs.github.com/en/actions/reference/workflows-and-actions/variables
  - https://docs.github.com/en/actions/how-tos/manage-workflow-runs/re-run-workflows-and-jobs
  - https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
  - https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/troubleshooting-required-status-checks
  - https://docs.github.com/en/rest/checks/runs
  - https://github.blog/changelog/2025-09-18-actions-yaml-anchors-and-non-public-workflow-templates/
  - https://github.com/actions/runner/blob/main/src/Sdk/DTPipelines/Pipelines/ObjectTemplating/YamlObjectReader.cs
  - https://github.com/actions/runner/blob/main/src/Runner.Worker/StepsRunner.cs
  - https://github.com/actions/runner/issues/952
  - https://github.com/actions/runner/issues/1182
  - https://github.com/actions/runner/issues/1961
  - https://github.com/actions/runner/issues/2598
  - https://github.com/orgs/community/discussions/9141
  - https://github.com/orgs/community/discussions/27096
  - https://github.com/orgs/community/discussions/36680
  - https://github.com/orgs/community/discussions/60792
  - https://github.com/orgs/community/discussions/161714
  - https://github.com/orgs/community/discussions/179993
---

# GitHub Actions open semantics — six questions DEC-246 left unresolved

## Provenance note — READ FIRST

This is a **follow-up external-research pass**, not a reconstruction. It is scoped
to six questions that
`.factory/research/dec-246-github-actions-gating-semantics.md` (2026-08-09) either
recorded as **INCONCLUSIVE** or carried as an **inferred premise** that a shipped
guard then rested on.

Read the DEC-246 artifact first. This document does not restate its confirmed
findings; it only advances the unresolved ones. Where a question is already
answered there, this document says so and does not duplicate it.

Every verdict here is labelled with a recovery label in the same vocabulary the
DEC-246 artifact used:

- `RECORDED` — the finding pre-exists in a project artifact.
- `NEWLY-RESEARCHED` — established on 2026-08-10 against a cited primary source.
- `INFERRED` — a deduction from primary facts, not a documented statement.

**No verdict in this document was softened from INCONCLUSIVE to CONFIRM.** Where
the honest answer is "only a live run settles this," §"Minimal empirical
experiments" specifies the exact experiment rather than substituting an inference.

**Source-tier discipline.** GitHub-hosted community discussions and
`actions/runner` issues are user-authored, not documentation. They are labelled
**SECONDARY** at every point of use, and a SECONDARY source is never the sole
basis for a CONFIRM. One source used below — Ken Muse's blog — is by a GitHub
staff member but is **a personal blog, not documentation**; it is labelled
SEMI-AUTHORITATIVE SECONDARY and treated as evidence, never as a citation.

---

## Lead finding — one REFUTE, flagged as instructed

**REFUTE — Q-A's evidence characterization.** The open drift item
`ZERO-LEG-MATRIX-RESULT-UNDOCUMENTED` states that "community reports [are] split
between `skipped` (safe) and `success` (silent false green)". **On the
2026-08-10 evidence that characterization is not supported.** No community report
was found claiming a zero-leg matrix yields `success` in `needs`, and none was
found claiming it yields `skipped` either. The two reports that exist describe
**different mechanisms with different outcomes, neither of which is a zero-leg
job** (§Q-A). The apparent "success" half of the split traces to
`orgs/community#9141`, which — read verbatim — is about a **per-step `if:`
workaround**, not about a zero-leg matrix at all (§Q-A, "The misreading").

**What this does and does not invalidate.** It invalidates a *description of the
evidence* recorded on a drift item. **It does not invalidate any shipped guard —
but it does split Guard B's justification in two, and the two halves now move in
opposite directions.** `test_matrix_os_lists_remain_static_literals` (Guard B,
`a17939e2`) pins two independent source properties:

| Guard B pins | Justification after this pass |
|---|---|
| (1) `os:` contains no `${{ }}` / `fromJSON` | **Weakened.** The only documented outcome of that path is a hard error at strategy evaluation — fail-*closed*, not a false green. See §Q-A. |
| (2) `strategy.matrix` declares no `exclude:` | **Strengthened.** New 2025-11 evidence says this path is *not* rejected and yields a job that **runs once and can conclude `success`** having done nothing. See §Q-B. |

**Guard B must not be retired.** Half of it is now better-evidenced than when it
shipped. §Q-A "Bearing on Guard B" states precisely what to re-justify and why
property (1) should nonetheless be kept.

**Correction to this document, made after Guard B's source was read in full.** An
earlier revision of this artifact recommended "widen Guard B to assert no
`exclude:` key". **That recommendation was wrong — Guard B already asserts
exactly that**, via `collect_mapping_key_set` anchored on the `matrix:` key at
6-space indent (`git show a17939e2:tests/ci_gate_completeness.rs`, the
`ADV-P56-INFO-001 (b)` block). The recommendation has been removed. What Guard B
actually needs is not a new assertion but a **docstring update**: it currently
states the `exclude:` question is "UNVERIFIED", and §Q-B now supplies the
evidence it was missing.

No other question in this pass produced a REFUTE.

---

## Repository state this document is grounded against

| Fact | Value | How verified (2026-08-10) |
|---|---|---|
| `develop` HEAD | `df203233` | `git log --oneline -1` |
| `ci-gate` job `needs` | `[fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]` | `.github/workflows/ci.yml:441` |
| `ci-gate` `if:` | `${{ always() }}` | `.github/workflows/ci.yml:442` |
| `ci-gate` job `name:` | `CI Gate` | `.github/workflows/ci.yml:439` |
| `ci-gate` gate step | `env: NEEDS_JSON: ${{ toJSON(needs) }}` → `run: echo "${NEEDS_JSON}" \| bash scripts/check-ci-gate.sh` | `.github/workflows/ci.yml` |
| `ci-gate` `uses:` steps | `step-security/harden-runner`, `actions/checkout` — both run **before** the gate step | `.github/workflows/ci.yml` |
| `clippy` matrix | `os: [ubuntu-latest, windows-latest]` — static literal, **flow sequence** | `.github/workflows/ci.yml:31` |
| `test` matrix | `os: [ubuntu-latest, macos-latest, windows-latest]` — static literal, **flow sequence** | `.github/workflows/ci.yml:48` |
| Guard A (sibling workflows) | `test_no_sibling_workflow_declares_a_job_named_ci_gate` | `git show a17939e2:tests/ci_gate_completeness.rs:6577` |
| Guard B (static matrices) | `test_matrix_os_lists_remain_static_literals`, `matrix_needs_members` | `git show a17939e2:tests/ci_gate_completeness.rs:6693`, `:451` |
| Sibling workflow files | 9 besides `ci.yml` (`release.yml`, `e2e.yml`, `scorecards.yml`, …) | `ls .github/workflows/` |

**Note on `a17939e2`:** Guards A and B are on the S-626-1 branch, **not** on
`develop`. A reader checking the `develop` working tree will not find them.

---

## Q-A — Zero-leg matrix: what does `needs.<job>.result` report?

**Label:** `NEWLY-RESEARCHED`. Supersedes DEC-246 Q4's evidence discussion.

**Verdict: INCONCLUSIVE (undocumented) — with the recorded evidence
characterization REFUTED and the question itself materially reframed.**

### Primary sources: silent, re-verified

- GitHub Docs, "Workflow syntax for GitHub Actions",
  https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax
  (accessed 2026-08-10). Contains **no** section on `strategy.matrix`, `exclude`,
  empty matrices, or how matrix leg results aggregate into a job status.
- GitHub Docs, "Running variations of jobs in a workflow",
  https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/run-job-variations
  (accessed 2026-08-10). States only: "A job will run for each possible
  combination of the variables." It **does not** specify what happens if all
  combinations are excluded, whether an empty matrix is permitted, any minimum
  job count, or how a matrix job's status is reported to `needs`.

This re-verifies DEC-246 Q4's finding one day later against the same pages. The
documentation gap is real and stable.

### The two mechanisms that actually exist — and neither is a zero-leg job

**(1) Dynamic `fromJSON()` matrix evaluating to an empty list → hard error.**
SECONDARY: https://github.com/orgs/community/discussions/27096 (opened
2021-06-10, accessed 2026-08-10). Verbatim error:

> Error when evaluating 'strategy' for job 'Job-2'. (Line: 52, Col: 11): Matrix
> vector 'cfg' does not contain any values

The job crashes during strategy evaluation, **before any step executes**. An
errored job is not a zero-leg job — it is a failed job, and a failed job in
`needs` is fail-closed for `check-ci-gate.sh`.

**(2) `exclude:` removing every combination → the job runs ONCE.** SECONDARY:
https://github.com/orgs/community/discussions/179993 (2025-11-19, accessed
2026-08-10), titled "Matrix exclude produces an empty matrix.entry instead of
skipping the job". The reporter observes the job executing once with matrix
variables empty (`matrix.service=`). Again not a zero-leg job — a one-leg job
with unset variables. See Q-B.

### The misreading — why "success" appeared in the split

SECONDARY: https://github.com/orgs/community/discussions/9141 (opened by
@billyvg 2021-12-20, accessed 2026-08-10) and its `actions/runner` twin
https://github.com/actions/runner/issues/952 (opened 2021-01-30, closed;
accessed 2026-08-10), both titled "Skipping a matrix job hangs the Pull Request
when inner-matrix jobs are required status checks". The sentence that reads like
zero-leg evidence is, verbatim:

> The current dirty fix for this is copying the top level if conditional, for
> each and every step inside the job, which results in a lot of duplicated code,
> as well as still having to create and run each inner-matrix job, even though
> every step is skipped. Additionally, this has the downside of setting the job
> result to success, instead of skipped.

**Read in context, this describes a workaround, not a platform behaviour for
zero legs.** The job *does* expand, *does* run every leg, and every *step* is
skipped by a per-step `if:` — so the job legitimately concludes `success`. That
is ordinary documented semantics (a job whose steps all skip succeeds), not a
zero-leg case. It is not evidence for Q-A in either direction.

The genuine complaint in #952/#9141 is a **different** and already-known
fail-safe: a matrix job skipped at the top level never expands, its inner-matrix
check names never arrive, and a PR requiring those names hangs on "Waiting for
status to be reported" — DEC-246 Q3's never-triggered → Pending → blocks path.

### Reframing the question

Because both known routes to "zero" avoid producing a job with zero legs, **it is
not established that a zero-leg job state is reachable at all**. The honest form
of the open question is therefore narrower and more useful:

> Is there any `strategy.matrix` construction that yields a job with zero legs
> whose `needs.<job>.result` is `skipped` or `success`? Or do all such
> constructions resolve to either a hard error (`failure`) or a single degenerate
> leg?

That is decidable only empirically (§"Minimal empirical experiments", E1).

### Bearing on Guard B — is property (1) protecting against nothing?

Reachability is unchanged from DEC-246: both `ci.yml` matrices are static literal
`os:` lists, and Guard B keeps them that way.

**The honest answer to "is it protecting against nothing?" is: on current
evidence, property (1) is protecting against a condition that appears to fail
CLOSED, not open.** The dynamic-matrix-to-empty path is the one path with a
documented outcome, and that outcome is a hard error before any step runs. A job
that errors reports `failure`, which `check-ci-gate.sh` already rejects. So the
specific fear property (1) was written against — "a zero-leg matrix might report
`success`" — is not supported by anything found.

**It should still be kept, for two reasons that are weaker than the original
justification and should be recorded as such:**

1. **The failure-mapping step is itself INFERRED.** No source documents what
   `needs.<job>.result` reports for a job that errors during *strategy
   evaluation* — as opposed to failing during a step. That is a different
   lifecycle stage, and it is exactly the kind of edge GitHub does not document.
   "Errored job → `failure`" is a reasonable inference, not a citation.
2. **The evidence is a single 2021 community thread.** `community#27096` predates
   several matrix-engine changes and has no staff confirmation. Retiring a guard
   on the strength of one five-year-old forum post would repeat, in the opposite
   direction, the mistake this whole cluster exists to correct.

**Recommended disposition:** keep property (1), and rewrite its docstring from
"a zero-leg matrix might report `success`" to "the one documented zero-evaluation
path hard-errors before any step runs; whether that maps to `failure` in `needs`
is UNVERIFIED, and whether other zero-leg constructions exist is unknown."
That is defense-in-depth against an unmapped lifecycle edge — a real if modest
justification — rather than a false-green claim the evidence does not support.
Experiment E1 would settle it outright and permit a clean retire-or-keep decision.

---

## Q-B — Does `matrix.exclude` reaching zero get rejected at parse time?

**Label:** `NEWLY-RESEARCHED`. Answers `ADV-P56-INFO-001`, previously UNCERTAIN.

**Verdict: INCONCLUSIVE on primary sources — but the leading hypothesis is now
specific, sourced, and materially different from what was assumed.**

**Primary:** nothing. Neither the workflow-syntax reference nor the
run-job-variations how-to (both accessed 2026-08-10, URLs above) states whether
an all-excluding `exclude:` is permitted, rejected, or what it produces. The
`exclude` documentation covers only the arithmetic of the normal case ("the
workflow will run nine jobs: one job for each of the 12 configurations, minus …").

**SECONDARY, single report, no staff confirmation:**
https://github.com/orgs/community/discussions/179993 (2025-11-19, accessed
2026-08-10) reports that an all-excluding matrix is **NOT rejected at parse
time**. The job runs **once**, with matrix variables empty. The thread's only
reply is an automated GitHub Actions bot acknowledging feedback — no staff
technical answer, and no statement about `needs` or required checks.

**Why this matters more than the zero-leg question it was filed alongside.**
If #179993 is accurate, the `exclude:`-to-zero path does **not** fail closed the
way the `fromJSON`-empty path does. It produces a job that **runs and can conclude
`success`** having done nothing meaningful. For a job in `ci-gate.needs`, that is
exactly the shape of a false green — and unlike Q-A's zero-leg question, this one
now has a concrete mechanism behind it rather than an absence of evidence.

**This is already guarded, and correctly.** Guard B's second assertion
(`ADV-P56-INFO-001 (b)`, `git show a17939e2:tests/ci_gate_completeness.rs`) pins
that neither `ci-gate.needs` matrix job declares an `exclude:` key, scoped to the
`matrix:` mapping at 6-space indent via `collect_mapping_key_set` — deliberately
not a bare `job_block.contains("exclude:")`, so an `exclude:` under some step's
`with:` block cannot be mistaken for this one. **No new assertion is needed.**

**What is needed is a docstring correction.** Guard B currently records:

> Whether GitHub permits a fully-excluded matrix at all (rejects it at
> parse/schedule time) or lets it through to produce zero legs is **UNVERIFIED**
> here

That was the correct posture when written. This pass supplies the missing
evidence, and it points one specific way: **not rejected at parse time; produces
one degenerate run, not zero legs.** The docstring should be updated to cite
`community#179993` (2025-11-19, single report, bot-only reply, no staff
confirmation) and to state that the failure mode is a *degenerate run that can
report `success`*, which is a stronger reason to keep the assertion than
"unverified" was.

**One secondary mitigation exists but is not asserted anywhere.** `clippy` and
`test` both use `runs-on: ${{ matrix.os }}`; with matrix variables empty,
`runs-on` evaluates to the empty string, and a job that cannot resolve a runner
label plausibly does not silently succeed. **What it actually does — queue
forever, or error — is not established here** and is part of experiment E2. Do
not treat it as a safety property.

---

## Q-C — Re-run and attempt-≥2 semantics

**Label:** `NEWLY-RESEARCHED` (re-verification) + `RECORDED` (DEC-246 Q8).

**Verdict: INCONCLUSIVE on primary sources — unchanged from DEC-246 Q8, and
re-verified 2026-08-10 rather than carried forward on trust.** One genuinely new
primary fact is added below.

**Primary, re-fetched 2026-08-10.** GitHub Docs, "Re-running workflows and jobs",
https://docs.github.com/en/actions/how-tos/manage-workflow-runs/re-run-workflows-and-jobs
— and its GitHub Enterprise Cloud mirror,
https://docs.github.com/en/enterprise-cloud@latest/actions/how-tos/manage-workflow-runs/re-run-workflows-and-jobs.
Both were checked specifically for: whether dependent jobs are re-run, the phrase
"and their dependents", `GITHUB_RUN_ATTEMPT`, attempt numbering, and status-check
re-reporting. **Neither page contains any of them.** The only reference to
attempts anywhere on the page is UI navigation: "To the right of the run name,
select the **Latest** dropdown menu and click a previous run attempt."

The single substantive statement, carried from DEC-246 Q8:

> The workflow will also use the same `GITHUB_SHA` (commit SHA) and `GITHUB_REF`
> (git ref) of the original event that triggered the workflow run.

**New primary fact this pass adds — and it is the load-bearing one.** GitHub Docs,
"About protected branches",
https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
(accessed 2026-08-10): required checks must pass **on the latest commit SHA**;
checks from earlier commits do not satisfy the requirement. Combined with the
re-run page's SHA-preservation statement, this yields a documented chain:

> A re-run preserves `GITHUB_SHA` [primary] → required checks are evaluated per
> commit SHA [primary] → **a re-run's results are evaluated against the same
> required-check slot as the original attempt.** `INFERRED` — the conjunction is
> a deduction; GitHub does not state it in one place.

That answers the "against which attempt does the check post" half at the level of
*which SHA*, which is what branch protection actually keys on. It does **not**
answer whether a check run is re-created, updated in place, or superseded — see
Q-D, where same-name check-run resolution turns out to be the same mechanism.

**SECONDARY, consistent, undocumented** (all accessed 2026-08-10):

- https://github.com/actions/runner/issues/1961, "Runner does not re-run
  dependent jobs for 'Re-run failed jobs'" (opened 2022-06-22, **closed**, no
  visible staff reply) — reports dependents not re-executing and that "the
  outputs from the previous runs of the dependent jobs are spliced in". A UUID
  generated in an upstream `prep` job stayed identical across attempts.
- https://github.com/actions/runner/issues/2598, "Failed job outputs from
  previous attempts re-used on 'Re-run failed jobs'" (opened 2023-05-12, **closed
  as not planned**, no visible staff reply) — a job that produced an output on
  attempt 1 and no output on attempt 3 still had the attempt-1 value visible
  downstream.

Two issues, both closed without a documented behavioural statement, one
explicitly "not planned". That is a consistent picture and it remains
**undocumented**; it is not upgraded.

**Assessment for `ci-gate` — unchanged, and still not tested.** `ci-gate` carries
`if: ${{ always() }}` and depends on every needs member, so it is a dependent of
any failed job. On a partial re-run it may read a `needs` payload mixing fresh
and carried-forward results. `check-ci-gate.sh` is fail-closed, so a
carried-forward `failure` keeps the gate red. The theoretical false-green
direction — a carried-forward `success` masking a job that would now fail —
requires a job that is not re-executed, which by definition has no new outcome to
mask. **No false-green path identified. `INFERRED`, not verified against a real
runner.** See E3.

---

## Q-D — Duplicate required-check names: what actually happens?

**Label:** `NEWLY-RESEARCHED`. This is the question the brief flagged as
load-bearing for Guard A.

**Verdict: split.**

- *Branch protection matches by check-run **name**, and the declaring workflow
  file is not part of the identity:* **CONFIRM** (already established in DEC-246
  Q5; not re-litigated here). New corroboration below.
- *What happens when two workflows each produce a check named `CI Gate` and that
  name is required — all / any / most-recent / nondeterministic:* **INCONCLUSIVE
  on primary sources.** The leading hypothesis is **last-writer-wins
  (most-recently-updated check run)**, supported by one semi-authoritative
  secondary source and one primary API affordance, and by no primary
  documentation statement.

**The inferred premise, stated precisely.** DEC-246 carried, and Guard A rests
on, the claim that a duplicate `CI Gate` name yields a false green. **That claim
is still INFERRED. This pass did not verify it — and did not refute it either.**
What this pass adds is that the leading hypothesis now *supports* the premise's
direction rather than being neutral to it, and that the premise's negation is not
supported by anything found.

### Primary sources

1. "About protected branches" (URL above, accessed 2026-08-10), verbatim:

   > If you use branch protection rules that require specific status checks, make
   > sure that job names are unique across all workflows. Using the same job name
   > in multiple workflows can cause ambiguous status check results.

   As DEC-246 Q5 noted, this is stronger than "undocumented": GitHub calls the
   result **ambiguous** and instructs you not to create it.

2. "Troubleshooting required status checks" (URL above, accessed 2026-08-10),
   verbatim:

   > If a check and a commit status have the same name, both must pass when that
   > name is required.

   **Precision that must not be lost:** this sentence is about a *check run* vs a
   *commit status* — two different API objects. It is **not** a statement about
   two check runs sharing a name. DEC-246 used it correctly; it must not be
   re-used as evidence that two same-named check runs are both required.

3. REST API, "Check Runs", https://docs.github.com/en/rest/checks/runs (accessed
   2026-08-10). Two relevant primary affordances:

   > In a check suite, GitHub limits the number of check runs with the same name
   > to 1000. Once these check runs exceed 1000, GitHub will start to
   > automatically delete older check runs.

   and, on "List check runs for a Git reference", the `filter` parameter:

   > Filters check runs by their completed_at timestamp. `latest` returns the
   > most recent check runs.

   **What this establishes:** multiple check runs sharing one name within a
   single check suite is a *supported, first-class state* — not an error
   condition — and GitHub's own API has a built-in notion of resolving a
   same-name set down to "the most recent". `INFERRED`: an API that ships a
   `latest` filter as the way to disambiguate same-named runs is consistent with
   the platform resolving them by recency elsewhere. That is an inference from an
   API affordance, not a documented statement about branch protection.

### Secondary sources

- SEMI-AUTHORITATIVE SECONDARY: Ken Muse (Staff DevOps Architect at GitHub),
  "Creating GitHub Checks", https://www.kenmuse.com/blog/creating-github-checks/
  (published 2023-07-06, updated 2025-12-07, accessed 2026-08-10), verbatim:

  > If multiple Checks share the same name, only the most recent one and its
  > status will be shown in the UI.

  > If multiple Checks exist with the same name, only the most recently updated
  > one will be used for the Status.

  > The older versions – up to 1,000 – are still available via the API.

  **This is a personal blog, not GitHub documentation.** The author's employment
  raises its weight; it does not make it a citation. It is the single most
  specific statement found in any source on Q-D.

- SECONDARY: https://github.com/orgs/community/discussions/161714, "required
  status checks: not possible to select two jobs with same name in different
  workflows" (2025-06-05, accessed 2026-08-10). The reporter finds the branch
  protection UI **cannot distinguish** two same-named jobs from different
  workflow files and asks for `a / build-results` / `b / build-results`
  disambiguation. Only an automated bot reply; **no staff answer, no statement of
  merge-time behaviour.** This corroborates that name is the identity and that
  the collision is unresolvable from the configuration UI — it does **not**
  establish what happens at merge time.

- SECONDARY: https://github.com/orgs/community/discussions/36680, "What are the
  criteria for multiple workflows to be used for the same check?" (answered
  2022-10-21 by a community member, accessed 2026-08-10). Finding: two workflows
  are treated as producing the same check only if they **both** call reusable
  workflows or **both** do not — a reusable-workflow call renders the name as
  `Outer / Inner`. No staff answer; no merge-time resolution stated.

### What this means for Guard A

If last-writer-wins is correct, a sibling workflow declaring `name: CI Gate` with
a trivially-passing job completing **after** the real gate satisfies the required
check — a false green, and one that touches no file any `ci.yml`-anchored pin
reads. Guard A
(`test_no_sibling_workflow_declares_a_job_named_ci_gate`) closes it from the
repository side at zero cost and needs no live experiment.

**Guard A should be kept.** Its justification does not depend on resolving Q-D:
the guard is cheap, decidable, and prevents a state GitHub's own documentation
tells maintainers not to create. What must change is the *record* — the premise
should be labelled INFERRED with last-writer-wins as the leading hypothesis, not
carried as an established fact. DEC-246's recommendation to treat the
sibling-workflow frontier as **still open** is re-endorsed on this evidence.

---

## Q-E — Does the real workflow parser accept flow-style `jobs:` mappings?

**Label:** `NEWLY-RESEARCHED`. Answers `ADV-P55-MED-002` (REQUIRES-EXECUTION).

**Verdict: split.**

- *YAML flow style is accepted by GitHub Actions in general:* **CONFIRM**, on
  primary evidence including this repository's own production runs.
- *A `jobs:` block written as a flow **mapping** (`gate: {name: CI Gate, …}`) is
  accepted end-to-end by the real workflow parser:* **INCONCLUSIVE —
  REQUIRES-EXECUTION.** Not softened. The prior is high, the evidence is
  indirect, and the one place the reference implementation is publicly readable
  is demonstrably **out of sync with the deployed parser** (see below).

### Flow style is accepted — proven, not inferred

`ci.yml` uses YAML **flow sequences** throughout:
`needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]`,
`os: [ubuntu-latest, windows-latest]`, `os: [ubuntu-latest, macos-latest, windows-latest]`.
These are flow collections, not block collections. They run in production —
`CLAUDE.md` records real run `31128902318` with 13 of 14 jobs succeeding on this
exact file. **Flow collections are therefore empirically confirmed accepted by
live GitHub Actions infrastructure, in this repository, on this workflow.**
GitHub's own documentation uses the same form (`runs-on: [self-hosted, linux]`).

That disposes of any claim that GitHub restricts workflows to block style. It
does **not** dispose of the specific `jobs:`-level flow-mapping form.

### The reference implementation does not inspect collection style

PRIMARY (source): `actions/runner`,
`src/Sdk/DTPipelines/Pipelines/ObjectTemplating/YamlObjectReader.cs` at `main`,
https://github.com/actions/runner/blob/main/src/Sdk/DTPipelines/Pipelines/ObjectTemplating/YamlObjectReader.cs
(accessed 2026-08-10). The reader is built on YamlDotNet's event-based parser and
handles `Scalar`, `SequenceStart`/`SequenceEnd`, `MappingStart`/`MappingEnd`,
`DocumentStart`/`DocumentEnd`, `StreamStart`/`StreamEnd`.

**It inspects `ScalarStyle` — and only for tagged scalars:**

```
if (scalar.Style != ScalarStyle.Plain) { throw new NotSupportedException(...) }
```

**There is no inspection of `MappingStart.Style` or `SequenceStart.Style`
anywhere.** Because YamlDotNet emits `MappingStart`/`MappingEnd` identically for
block and flow mappings, a flow-mapping `jobs:` block produces a byte-identical
token stream to its block-mapping equivalent as far as this reader is concerned.
`INFERRED` from the source: flow mappings are structurally invisible to this
layer.

### Why that is not sufficient — and a finding worth recording on its own

**Workflow files are parsed server-side by GitHub's Actions service, whose source
is not public.** The runner's copy of the templating library parses `action.yml`
for composite actions locally. The two are widely assumed to be the same library.
**They are demonstrably not the same deployed version**, and this pass can show
it:

The same `YamlObjectReader.cs` at `main` **rejects anchors outright**:

```
if (scalar.Anchor != null) { throw new InvalidOperationException($"Anchors are not currently supported...
```

— on `Scalar`, `MappingStart`, and `SequenceStart`. Yet GitHub shipped YAML
anchor support for workflows in production on **2025-09-18**: GitHub Changelog,
"Actions: YAML anchors and non-public workflow templates",
https://github.blog/changelog/2025-09-18-actions-yaml-anchors-and-non-public-workflow-templates/
(accessed 2026-08-10), verbatim: "GitHub Actions now supports YAML anchors, a top
request from the GitHub community. With YAML anchors, you can reuse configuration
across your workflows and ensure better conformance with the YAML spec,"
"automatically enabled for all GitHub Actions users and repositories." The
changelog does **not** name the parser implementation, the targeted spec version,
what was replaced, or whether merge keys (`<<`) are supported —
https://github.com/actions/runner/issues/1182 (accessed 2026-08-10) likewise
carries no staff technical explanation, only that support landed in 2025.

**Consequence, and it is broader than Q-E.** `actions/runner`'s public source is
**not a reliable oracle for server-side workflow parsing.** It lags the deployed
parser by at least one shipped feature. Any future finding of the form "the
runner source shows X, therefore workflows behave X" inherits this gap. That
includes the round-16 node-property residual recorded in `CLAUDE.md` — the
production anchor support that makes `&x shell: cat {0}` live is confirmed by the
changelog, **not** by the runner source, which would reject it.

### Bearing on the guard

`ADV-P55-MED-002` stays **REQUIRES-EXECUTION** (E4). Independently of the answer:
every set-equality pin in `tests/ci_gate_completeness.rs` is line-based, so a
flow-mapping `jobs:` block defeats them for the same reason node properties do —
this is a **new member of the already-documented "lexer disagrees with a real YAML
parser" class**, not a new class. The durable fix is the one `CLAUDE.md` already
tracks: parse `ci.yml` with a real YAML parser and assert over the tree.

---

## Q-F — `$GITHUB_PATH` and step-level `env:` precedence

**Label:** `NEWLY-RESEARCHED`. Both sub-questions underpin `ADV-P59-LOW-001`.

### Q-F(1) — Does `$GITHUB_PATH` affect binary resolution for later steps?

**Verdict: CONFIRM.** Directly documented.

PRIMARY: GitHub Docs, "Workflow commands for GitHub Actions",
https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands
(accessed 2026-08-10), §"Adding a system path", verbatim:

> Prepends a directory to the system `PATH` variable and automatically makes it
> available to all subsequent actions in the current job; the currently running
> action cannot access the updated path variable.

PRIMARY, corroborating: "Variables reference",
https://docs.github.com/en/actions/reference/workflows-and-actions/variables
(accessed 2026-08-10):

> The path on the runner to the file that sets system `PATH` variables from
> workflow commands. The path to this file is unique to the current step and
> changes for each step in a job.

Three things follow, and the first two are documented rather than inferred:

1. The modification applies to **subsequent steps in the same job** — documented.
2. It **prepends** — documented. A shim directory therefore takes priority over
   the system location of the same binary name.
3. `command -v jq` in a later `run:` step resolves through `PATH` and so resolves
   to the shim. `INFERRED` — from documented `PATH` semantics plus standard POSIX
   shell lookup, not from a GitHub statement. The inference is about how shells
   work, not about GitHub, and is not seriously in doubt.

**The `ADV-P59-LOW-001` `PATH`→`jq` shim vector is REAL, and the judgement that
it is real was correct.** Concretely for `ci-gate`: the job runs two `uses:`
steps (`harden-runner`, `checkout`) **before** the gate step. Either could write
`$GITHUB_PATH`. Those two `uses:` values are on the decision path and are
knowingly unpinned — exactly the residual `CLAUDE.md`'s round-13 IMPORTANT 2
records for `$GITHUB_ENV`. **`$GITHUB_PATH` is a second, equivalent mechanism at
the same seam, and no record currently names it.** Recommend adding it alongside
`$GITHUB_ENV` wherever that residual is documented.

### Q-F(2) — Does a step's own `env:` outrank a variable an earlier step set via `$GITHUB_ENV`?

**Verdict: CONFIRM**, on runner source — which is the authoritative layer for
this question, unlike Q-E.

PRIMARY (source): `actions/runner`, `src/Runner.Worker/StepsRunner.cs` at `main`,
https://github.com/actions/runner/blob/main/src/Runner.Worker/StepsRunner.cs
(accessed 2026-08-10). Global/job environment — which is where `$GITHUB_ENV`
writes accumulate — is applied **first**:

```
foreach (var pair in step.ExecutionContext.Global.EnvironmentVariables)
{
    envContext[pair.Key] = new StringContextData(pair.Value ?? string.Empty);
}
```

The step's own `env:` block is evaluated and applied **second, into the same
dictionary**:

```
var actionEnvironment = templateEvaluator.EvaluateStepEnvironment(
    actionStep.Action.Environment, step.ExecutionContext.ExpressionValues,
    step.ExecutionContext.ExpressionFunctions,
    VarUtil.EnvironmentVariableKeyComparer);
foreach (var env in actionEnvironment)
{
    envContext[env.Key] = new StringContextData(env.Value ?? string.Empty);
    step.ExecutionContext.StepEnvironmentOverrides.Add(env.Key);
}
```

Last write wins on key collision, so **step-level `env:` overrides a
`$GITHUB_ENV` value set by an earlier step**. The runner even tracks the
displaced keys explicitly in `StepEnvironmentOverrides` — the override is a
designed behaviour, not an ordering accident.

**Why this source is authoritative here and not in Q-E:** step execution and
environment assembly happen **on the runner**. This is the code that actually
runs. Q-E's problem was that workflow *parsing* happens server-side; that problem
does not apply to this question.

**Documentation gap worth recording — a citation is being misapplied in the
wild.** The "Variables reference" page (accessed 2026-08-10) **does not state
workflow/job/step `env:` precedence at all.** Its sentence

> If a variable with the same name exists at multiple levels, the variable at the
> lowest level takes precedence.

is about **configuration variables** (organization / repository / environment
scopes) — its own worked examples are org-vs-repo and org-vs-repo-vs-environment.
It is **not** a statement about `env:` at workflow/job/step level, and it should
not be cited as one. Several third-party guides make exactly that conflation.
The `env:`-scoping precedence is stated only on the older "Store information in
variables" how-to, whose current-IA URL 404s (verified 2026-08-10); it survives on
the GHES-versioned mirrors.

**Consequence for the gate:** the round-11 M2-n / round-12 M2-o judgement that
`NEEDS_JSON` substitution is closed **holds**. A prior step writing
`NEEDS_JSON` via `$GITHUB_ENV` cannot displace the gate step's own pinned
`env: NEEDS_JSON:` value. **`$GITHUB_PATH` is not covered by this argument** —
it is a different mechanism and Q-F(1) shows it is live.

---

## Verdict summary

| # | Question | Label | Verdict (2026-08-10) | Confidence |
|---|---|---|---|---|
| Q-A | Zero-leg matrix → `needs.<job>.result` | NEWLY-RESEARCHED | **INCONCLUSIVE** — undocumented; **evidence characterization REFUTED** (no community "split" exists; the "success" half is a misread of a per-step-`if:` workaround); question reframed — a zero-leg state may not be reachable at all | LOW on the answer; HIGH on the refutation |
| Q-B | `matrix.exclude` reaching zero | NEWLY-RESEARCHED | **INCONCLUSIVE** on primary — not rejected at parse time; single 2025-11 community report says the job runs **once** with empty matrix vars, i.e. a degenerate run that can report `success`. Already guarded (Guard B property 2); that guard's justification is **strengthened**, and its "UNVERIFIED" docstring is now out of date | LOW-MEDIUM (one report, no staff confirmation) |
| Q-C | Re-run / attempt ≥ 2 | NEWLY-RESEARCHED + RECORDED | **INCONCLUSIVE** — docs re-verified silent 2026-08-10; two `actions/runner` issues consistent, both closed, one "not planned". New primary chain: re-run preserves SHA + required checks key on latest SHA → same required-check slot (INFERRED conjunction) | LOW on the mechanism; MEDIUM on the SHA chain |
| Q-D | Duplicate required-check names | NEWLY-RESEARCHED | **CONFIRM** name is the identity / **INCONCLUSIVE** on resolution. Leading hypothesis **last-writer-wins**, from a GitHub staff member's blog (SECONDARY) + the REST API's `filter=latest` affordance. Premise behind Guard A remains **INFERRED — not verified, not refuted** | HIGH / LOW respectively |
| Q-E | Flow-style `jobs:` mapping | NEWLY-RESEARCHED | **CONFIRM** flow style generally (flow sequences proven in this repo's production runs; reference reader inspects no collection style) / **INCONCLUSIVE — REQUIRES-EXECUTION** for the `jobs:` flow-mapping form specifically | HIGH / LOW respectively |
| Q-F(1) | `$GITHUB_PATH` → later-step binary resolution | NEWLY-RESEARCHED | **CONFIRM** — documented verbatim ("Prepends … available to all subsequent actions in the current job"). The `PATH`→`jq` shim vector is REAL | HIGH |
| Q-F(2) | Step `env:` vs earlier `$GITHUB_ENV` | NEWLY-RESEARCHED | **CONFIRM** — `StepsRunner.cs`: global env applied first, step `env:` second into the same dict; displaced keys tracked in `StepEnvironmentOverrides`. `NEEDS_JSON` substitution stays closed | HIGH |

**One REFUTE: Q-A's recorded evidence characterization. No shipped guard is
invalidated.** Q-D's premise is neither confirmed nor refuted and must stay
labelled INFERRED.

---

## Minimal empirical experiments

Each is a throwaway PR against a scratch repository. None requires touching this
repository's `ci.yml`.

**E1 — zero-leg matrix (settles Q-A).** One workflow, two jobs. `producer`
outputs `[]`; `child` uses `strategy: matrix: v: ${{ fromJSON(needs.producer.outputs.v) }}`;
`gate` has `needs: [child]`, `if: ${{ always() }}`, one step echoing
`${{ toJSON(needs) }}`. Read `needs.child.result` from the gate's log. **Also run
the literal-empty variant** (`matrix: v: []`) — the `does not contain any values`
error is reported for `fromJSON`-empty, and the literal form has not been
separately confirmed. ~20 minutes.

**E2 — `exclude:`-to-zero (settles Q-B).** Same shape. `child` declares
`matrix: {os: [ubuntu-latest], arch: [x64]}` with an `exclude:` removing that one
combination, and `runs-on: ${{ matrix.os }}`. Record three things: (a) whether the
workflow is accepted at parse time; (b) whether `child` runs, and how many times;
(c) `needs.child.result` as seen by the gate. Variant with a literal
`runs-on: ubuntu-latest` isolates the empty-`runs-on` effect from the exclude
effect. ~20 minutes.

**E3 — re-run semantics (settles Q-C).** A workflow whose `flaky` job fails on
attempt 1 (fail on `github.run_attempt == '1'`), with an upstream `prep` job
emitting a fresh UUID output and a `gate` job with `if: ${{ always() }}` echoing
`${{ toJSON(needs) }}`. Run once, then use **"Re-run failed jobs"**. Compare the
gate's `needs` payload across attempts: does `prep`'s UUID change, and does
`prep.result` appear at all? Then check the PR's required-check panel to see
which attempt's `CI Gate` conclusion is being honoured. ~30 minutes.

**E4 — flow-mapping `jobs:` (settles Q-E / `ADV-P55-MED-002`).** Commit a
workflow whose entire `jobs:` value is a flow mapping —
`jobs: {gate: {name: CI Gate, runs-on: ubuntu-latest, steps: [{run: echo hi}]}}` —
and observe whether it is accepted, runs, and reports a check named `CI Gate`.
Binary outcome, ~10 minutes. **Worth pairing with an anchor-form control** so the
runner-source-vs-server divergence recorded in Q-E is measured rather than
asserted.

**E5 — duplicate check names (settles Q-D).** Requires a repo with branch
protection. Two workflows on the same trigger, each with a job named `CI Gate`:
one sleeps 60s then exits 0, the other exits 1 immediately. Require `CI Gate`.
Observe whether the PR is mergeable, and repeat with the order inverted (fast
success, slow failure). Inverting the order is the whole experiment — it
distinguishes last-writer-wins from all-must-pass. **~30 minutes, and this is the
highest-value of the five**, because it is the only one whose current premise is
both load-bearing for a shipped guard and entirely inferred.

E1/E2/E3/E4 need no branch protection and can share one scratch repository.

---

## Recommendations

1. **Correct the `ZERO-LEG-MATRIX-RESULT-UNDOCUMENTED` drift item's evidence
   line.** The "community reports split between `skipped` and `success`"
   characterization is unsupported. Replace with the two actual mechanisms (§Q-A)
   and the reframed question. The same sentence is quoted verbatim in Guard B's
   docstring and must be corrected in both places. Priority remains MEDIUM-latent.
2. **Do NOT add an `exclude:` assertion to Guard B — it already has one.**
   Instead: (a) rewrite property (1)'s docstring away from the false-green claim
   the evidence does not support, per §Q-A "Bearing on Guard B"; (b) update
   property (2)'s "UNVERIFIED" note with the §Q-B evidence, which strengthens it.
   No code change to either assertion.
3. **Keep Guard A. Relabel its premise.** Record the duplicate-name false-green as
   INFERRED with last-writer-wins as the leading hypothesis and Ken Muse's blog +
   the REST `filter=latest` affordance as the evidence. Re-endorse DEC-246's
   recommendation that the sibling-workflow frontier stays **open**.
4. **Add `$GITHUB_PATH` beside `$GITHUB_ENV`** wherever the unpinned-`uses:`
   residual is recorded (`CLAUDE.md` round-13 IMPORTANT 2). Q-F(1) confirms it is
   a live, documented, equivalent mechanism at the same seam, and no record names
   it.
5. **Record that `actions/runner`'s public source is not an oracle for
   server-side workflow parsing** — it rejects anchors that production has
   accepted since 2025-09-18. Any argument of the form "the runner source shows
   X" needs this caveat. The runner source *is* authoritative for step execution
   (Q-F(2) relies on exactly that distinction).
6. **Do not cite the "Variables reference" precedence sentence for `env:`
   scoping.** It is about configuration variables. Q-F(2)'s correct citation is
   `StepsRunner.cs`.
7. **Run E5 first** if any empirical budget exists. It is the only experiment
   whose result could change a shipped guard's justification.

---

## Research methods

| Tool | Calls | Purpose |
|---|---|---|
| WebFetch | 15 | GitHub docs pages, github.blog changelog, `actions/runner` source at `main`, GitHub-hosted issues/discussions |
| WebSearch | 8 | Locating primary pages and the relevant `actions/runner` / `orgs/community` threads |
| Bash / git | 5 | Grounding claims against `ci.yml` and `git show a17939e2:tests/ci_gate_completeness.rs` |
| Perplexity / Context7 | 0 | Not used — every question concerns GitHub's own behaviour |
| Training data | 0 assertions | Every factual claim carries a URL and a 2026-08-10 access date |

**Not done, and not claimed:** nothing in this document was executed against live
GitHub Actions infrastructure. Q-A, Q-B, Q-C and Q-E are marked INCONCLUSIVE or
REQUIRES-EXECUTION for exactly that reason, and each has a specified experiment
rather than an inferred answer.

**Reading hazard carried forward from DEC-246:**
`.factory/cycles/cycle-001/burst-log.md` contains bytes that make plain `grep`
treat it as binary and return **silent false negatives**. Always use `grep -a`.
