---
document_type: story
level: ops
epic_id: "none"
story_id: "S-CIGATE-2"
title: "ci-gate skipped-status false-green — a `needs` job reporting `skipped` silently satisfies the sole required branch-protection check"
wave: feature-followup
status: done  # v2.1, 2026-08-07: Option C shipped as PR #671 (merged 2026-08-07T00:01:18Z;
              # scripts/check-ci-gate.sh confirmed present on origin/develop, ci.yml :: ci-gate
              # and :: spec-guard confirmed invoking it). Corrected from draft; "done" matches
              # this epic's sibling-story convention (S-CIGATE-1, S-CIGATE-4).
intent: bug-fix
feature_type: ci
mode: feature
scope: small
severity: HIGH
trivial_scope: false
points: 8
priority: P0
tdd_mode: strict
producer: story-writer
timestamp: "2026-08-06T00:00:00"
phase: 3
cycle: CIGATE-SKIP-PROPAGATION
inputs:
  - ".github/workflows/ci.yml"
  - "tests/ci_gate_completeness.rs"
  - "scripts/check-signing-workflow-injection.sh"
  - "live CI run 30465686049 (gh run view, push/develop, 2026-07-29)"
input-hash: "f8aa18a"
traces_to: ".github/workflows/ci.yml::ci-gate"
version: "2.1"
estimated_effort: standard
estimated_days: 2.5
target_module: ci
subsystems: []
depends_on: []
blocks: []
behavioral_contracts: []
bcs: []
# BC status: no product BCs (CI pipeline defect; same convention as S-CIGATE-1 / S-627-1 —
# CI-infra stories with no product BC surface trace to a drift item instead). BC catalog
# is NOT touched by this story. Do NOT add BCs.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F1-delta-analysis
spec_source: "N/A — no pre-existing delta-analysis document. Discovered by direct empirical
  investigation of live CI run 30465686049 (push, develop, 2026-07-29) plus a source read of
  `.github/workflows/ci.yml` on 2026-08-06. All facts in this story were independently
  re-verified against the live repo/API rather than transcribed from the originating briefs —
  see 'Corrections to the Originating Brief(s)' below."
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 9
assumption_validations: []
risk_mitigations:
  - "REVISION v2.0 (2026-08-06): Options A and B (v1.0's recommendation) were both
     REJECTED after a dedicated research pass, human-approved. Option A fails OPEN — a
     future maintainer who adds a job to `ci-gate.needs` but forgets to add the matching
     `needs.<job>.result != 'success'` clause to the allowlist condition doesn't get an
     error; the gate silently stops checking that job. Weakening by omission is invisible
     at review time, which is exactly this repo's documented drift class (DEC-096/DEC-097).
     Option B was independently found by both this story's v1.0 investigation AND the
     research pass to require FIVE step-level edits inside the `mutants` job (harden-runner,
     checkout with `fetch-depth: 0`, install-action, rust-cache, run-mutants — not the
     three originally assumed), plus a new branch in the `Check kill rate` script — and would
     burn full checkout/toolchain-setup runner time on every single push while reporting a
     green 'Mutation testing' check for a job that tested nothing, inverting the signal a
     reviewer would read from that job name. See 'Corrections to the Originating Brief(s)'
     and the retired 'Option A'/'Option B' write-ups below (kept for record, not deleted,
     per this repo's decision-record convention) for the full analysis trail."
  - "REVISION v2.1 (2026-08-07, class-level correction sweep): status corrected draft→done.
     Option C shipped as PR #671 ('fix(ci-gate): close skipped-status false-green gap in
     required check (S-CIGATE-2)'), merged to develop at 2026-08-07T00:01:18Z (commit
     `df203233`), confirmed via `gh pr view 671 --json state,mergedAt` (state: MERGED). Verified
     directly against `origin/develop`, not assumed from the merge record alone:
     `scripts/check-ci-gate.sh` exists on `origin/develop` (`git show origin/develop:scripts/check-ci-gate.sh`
     resolves, doc-header confirms 'S-CIGATE-2 fail-closed `ci-gate` needs-result evaluator');
     `.github/workflows/ci.yml :: spec-guard` on `origin/develop` invokes it at two sites
     (`bash scripts/check-ci-gate.sh --self-test` and `echo \"${NEEDS_JSON}\" | bash
     scripts/check-ci-gate.sh`). No body content in this story was found stale by this pass —
     every `contains(needs…)` occurrence in the body is a pre-fix problem statement, a
     rejected-option analysis, or an explicit quotation of S-CIGATE-1's stale text, and is
     correctly framed as such already; none was edited. `S-CIGATE-1-ci-gate-aggregator.md` is
     owned by a concurrently-running agent and was not read or touched."
created: "2026-08-06"
last_updated: "2026-08-07"
breaking_change: false
files_modified:
  - .github/workflows/ci.yml          # MODIFY: ci-gate's step body replaced with a call to scripts/check-ci-gate.sh over toJSON(needs); spec-guard gains two new steps (self-test + real invocation) mirroring the existing check-cargo-mutants-policy-citations/check-bc-citation-symbols self-test pairing pattern. mutants job UNCHANGED.
  - scripts/check-ci-gate.sh          # CREATE: fail-closed needs-result evaluator with a hardcoded ALLOWED_SKIPS allowlist (mutants only), a default-failure arm for any unrecognized result value, an empty-needs guard, per-job OK/FAIL log lines, and a --self-test flag running built-in JSON fixtures. Modeled on scripts/check-signing-workflow-injection.sh's doc-header/usage/self-test conventions (DEC-148/DEC-150 pattern).
  - tests/ci_gate_completeness.rs     # MODIFY: assertions retargeted from ci-gate's inline YAML condition to (a) ci-gate's step now invoking scripts/check-ci-gate.sh with needs JSON, (b) the mutants job remaining unchanged (job-level if: still present — this is now an invariant to preserve, not remove), (c) the spec-guard job containing the two new self-test/real-check steps. Top-of-file doc comment corrected (still describes the old, wrong "skipped is fine" narrative).
  - CLAUDE.md                         # MODIFY: extend the existing ci-gate Conventions bullet — new required CI jobs must be added to ci-gate.needs AND, if they can legitimately report `skipped`, to scripts/check-ci-gate.sh's ALLOWED_SKIPS list; the gate script's own --self-test is the enforcement mechanism, not a doc-only convention.
---

# S-CIGATE-2 — `ci-gate` Skipped-Status False-Green

> **v2.0 revision notice:** this story was originally written specifying Option B
> (skipped-safe condition + step-level PR-only gating on `mutants`) as the recommended fix.
> A dedicated research pass rejected both Option A and Option B and the human approved
> **Option C** (fail-closed script-based evaluator with a restrictive allowlist) plus a
> companion self-test script. This revision retargets every AC, task, and cross-reference
> to Option C. The Option A/Option B write-ups are RETAINED below (not deleted) as a decision
> record — the rejection reasoning is load-bearing context for why Option C looks the way it
> does, and this repo's own convention (`S-626-1`'s "CORRECTION" blocks) is to record
> superseded reasoning rather than erase it.

## Source of Truth

Live CI run `30465686049` (push, `develop`, 2026-07-29): `Mutation testing` job concluded
`skipped`; `CI Gate` concluded `success`. Independently re-verified via
`gh run view 30465686049 --json jobs` on 2026-08-06 (see "Verification Log" below).

`.github/workflows/ci.yml :: ci-gate` (currently, lines ~435–445):

```yaml
ci-gate:
  name: CI Gate
  runs-on: ubuntu-latest
  needs: [fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]
  if: ${{ always() }}
  steps:
    - name: Fail if any required job failed or was cancelled
      if: >-
        ${{ contains(needs.*.result, 'failure') ||
            contains(needs.*.result, 'cancelled') }}
      run: exit 1
```

`gh api repos/:owner/:repo/branches/{develop,main}/protection` confirms `"CI Gate"` is the
sole entry in `required_status_checks.contexts` on both protected branches, with
`strict: false` and `enforce_admins: false` on both (state, not scope of this story — see
Out of Scope).

Related, already-shipped story: `S-CIGATE-1-ci-gate-aggregator.md` (added the `ci-gate`
aggregator itself). Related, in-flight, NOT YET MERGED story: `S-626-1.md` — see the
"Coordination note" under AC-006 and Edge Cases.

Independently re-verified this revision (2026-08-06): `.github/workflows/ci.yml :: mutants`
(lines 170–260ish) has exactly 6 steps: `Harden the runner`, `actions/checkout` (with
`fetch-depth: 0`, needed for `git diff origin/<base_ref>...HEAD`), `taiki-e/install-action`
(cargo-mutants), `Swatinem/rust-cache`, `Run mutation tests on PR diff` (`id: run-mutants`),
and `Check kill rate`. Under Option C **none of these six steps changes** — this is the
option's central advantage.

## Behavioral Contracts

No product BCs are added or modified. BC catalog is untouched by this story. This story
traces its ACs to the drift item **CIGATE-SKIP-PROPAGATION** (a new drift-item name — no
prior STATE.md DEC number exists for this specific defect; the closest related DEC numbers,
DEC-096/DEC-097, cover the *originating* skipped-job-trap design problem that `ci-gate`
itself was built to solve, not this regression of that fix). This follows the same
no-BC convention used by S-CIGATE-1 and S-627-1 for CI-infra-only stories.

## Story Narrative

As a maintainer of `jr`,
I want the `ci-gate` required status check to fail closed whenever any of its `needs` jobs
reports a result other than `success` — with the sole exception of a small, explicit,
per-job allowlist of results that are known-safe to tolerate — and to fail closed on any
result value it does not recognize at all,
so that (a) a job silently emitting `skipped` (today: `mutants` on every push, by design)
can never again make the sole required branch-protection check report green while that job
did not actually run, and (b) a *future* GitHub Actions conclusion type the gate has never
seen before is treated as a failure by default, not as an accidental pass-through.

## Problem Statement

`ci-gate`'s pass/fail step checks only `contains(needs.*.result, 'failure')` and
`contains(needs.*.result, 'cancelled')`. GitHub Actions' `needs.<job_id>.result` has four
documented values today: `success`, `failure`, `cancelled`, `skipped` (GitHub's own docs
describe `skipped` and `neutral` as check-run conclusions that count as passing/non-blocking
by default — this is documented product behavior, not a platform bug). `skipped` satisfies
neither `contains()` call in the current condition, so the `exit 1` step itself is skipped,
the job has no other steps, and `ci-gate` concludes `success`.

This is reachable **today, on every push**, not just hypothetically: `mutants` is in
`ci-gate.needs` (added by `S-MUTATION-CI-TIMEOUT-1`, confirmed present at
`.github/workflows/ci.yml:438`) and carries `if: github.event_name == 'pull_request'`
(`.github/workflows/ci.yml` `mutants` job, confirmed present), so it reports `skipped` on
every `push` event. `ci-gate` has therefore never actually verified the `mutants` job's
result on any push-triggered run to `develop` or `main` — it has only ever verified that
`mutants` was not `failure` or `cancelled`, which is trivially true for a job that never ran.

**This is not merely a latent risk — the codebase's own regression-guard test suite
currently asserts the opposite of this story's premise as fact.** `tests/ci_gate_completeness.rs`'s
top-of-file doc comment (verified present, `tests/ci_gate_completeness.rs` lines ~20–27) reads:

> `mutants` IS in `needs` (MUTATION-CI-TIMEOUT, 2026-06-28). It carries
> `if: github.event_name == 'pull_request'` and emits `skipped` on push events. The
> ci-gate pass condition checks for `failure` or `cancelled` only — `skipped` is neither, so
> ci-gate passes on push events. **This is the correct behavior** per DEC-096/097 and
> delta-analysis §5.

and `test_mutants_is_in_ci_gate_needs`'s own failure message (verified present, lines
~396–398) repeats: *"Push-event safety: `mutants` emits `skipped` on push events; the
ci-gate condition checks `failure`/`cancelled` only — `skipped` is neither, so ci-gate
passes on push events."* Both are presented as intentional, verified-correct design, not as
a known gap. This story's fix requires correcting this narrative in the same file it lives
in (AC-009), not merely adding new assertions alongside a doc comment that still asserts the
old behavior was fine. **Under Option C this correction is even more pointed:** the doc
comment must now explain that `mutants` reporting `skipped` on push IS expected and IS
tolerated — but only because it is named in an explicit, restrictive allowlist inside
`scripts/check-ci-gate.sh`, not because the gate's condition happens not to catch it.

## Root Cause Chain

1. `S-CIGATE-1-ci-gate-aggregator.md` (2026-06-15) correctly anticipated this exact failure
   mode in its Architecture Compliance Rules table: *"`security` and `mutants` MUST NOT
   appear in `ci-gate.needs` (they emit `skipped` on push events, which would poison
   push-triggered `ci-gate` runs)."*
2. `S-MUTATION-CI-TIMEOUT-1` (2026-06-28) added `mutants` to `ci-gate.needs` anyway (to
   enforce the 90% mutation kill-rate gate on every PR) and added
   `test_mutants_is_in_ci_gate_needs` asserting it belongs there — directly contradicting
   item 1, without revisiting `ci-gate`'s pass condition.
3. The gate's condition was never taught about `skipped`.
4. `mutants` carries `if: github.event_name == 'pull_request'` by design (mutation testing
   is too slow for every push — timeout-minutes: 240) — so it reports `skipped` on every
   push. **Under Option C, this remains true and is not changed** — it is the one case the
   allowlist is built to tolerate deliberately, not the case the fix eliminates.

**Why this is structural, not specific to `mutants`:** none of the other seven jobs in
`ci-gate.needs` (`fmt`, `clippy`, `test`, `msrv`, `deny`, `spec-guard`,
`check-signing-workflow-injection`) currently carries a job-level `if:`, a `paths:` filter,
a dynamic matrix, or its own `needs:` edge (confirmed by direct grep of each job block — see
Verification Log). They are unskippable today only because none of these ordinary,
independently-plausible edits has yet been made to them. The repo already uses the
if-guarded-job pattern in this very file: `security` § `if: github.event_name ==
'pull_request' && vars.GITLEAKS_DISABLED != 'true'` (not in `needs`, so currently harmless,
but a template for how easily the next job could be — and, under Option C, a template for
what `ALLOWED_SKIPS` would need to be extended to cover if it were ever promoted into
`needs`).

## Corrections to the Originating Brief(s)

Verified independently rather than transcribed; all corrections make the case for this
story's rigor *stronger*, not weaker:

1. **"the other seven `needs` jobs are unskippable today"** — confirmed accurate (verified
   via direct grep for `needs:` inside each of the 7 non-`mutants` job blocks: zero hits).
2. **v1.0 brief: "zero cancelled `ci.yml` runs exist in the last 200 to sample"** — **false.**
   4 of the last 200 `ci.yml` runs (all `pull_request`-triggered: `29736816386`,
   `29735639851`, `29701963083`, `29699658785`) concluded `cancelled` at the workflow level.
   In all 4 sampled cases, the *only* job reporting `cancelled` was `Mutation testing`
   (already in-flight — it has a 240-minute timeout, by far the longest-running job, so it
   is the one still executing when a run is superseded or manually cancelled); every other
   job had already completed with `success`/`failure`, and `CI Gate` correctly concluded
   `failure` in all 4 samples. This confirms the *currently reachable* cancellation pattern
   (an already-started job superseded mid-run) is handled correctly today. It does **not**
   resolve the narrower open question below — none of the 4 samples isolates a job that was
   cancelled *before it started* (see EC-004).
3. **v2.0 revision brief: "`jq` is already an assumed dependency — `ci.yml:~424` states
   'jq is pre-installed...'"** — the claim is correct in substance but the line citation is
   off: the comment is at `.github/workflows/ci.yml` line ~298 (inside the `mutants` job's
   `Check kill rate` step), not ~424 (which is inside `check-signing-workflow-injection`/
   `ci-gate` near the end of the current 445-line file). Symbol-form citation used instead
   of a line number in this story per `CLAUDE.md`'s citation-form convention, to avoid the
   same drift.
4. **v2.0 revision brief: "GitHub Docs state 'Successful check statuses are success,
   skipped, and neutral'"** — not independently re-verified against GitHub's current docs
   text for this revision (out of scope for a story file to re-litigate an already
   human-approved architectural decision); accepted as the documented, decisive context the
   research pass supplied and the human ratified. If a future reader needs the exact
   citation, re-verify at implementation time rather than trusting this restatement.

## Retired: Two Candidate Fixes (Option A, Option B) — REJECTED, kept for record

> Both options below were fully specified in v1.0 of this story and were REJECTED after a
> dedicated research pass; the human approved Option C (next section) instead. This section
> is retained, not deleted, because the rejection reasoning is load-bearing: it explains
> several of Option C's specific design choices (fail-closed default arm, restrictive
> per-job allowlist, `mutants` job left untouched).

### Option A — allowlist inversion (REJECTED)

Replace the negative-`contains` condition with explicit per-job success assertions:

```yaml
if: >-
  ${{ needs.fmt.result != 'success' ||
      needs.clippy.result != 'success' ||
      needs.test.result != 'success' ||
      needs.msrv.result != 'success' ||
      needs.deny.result != 'success' ||
      needs['spec-guard'].result != 'success' ||
      needs['check-signing-workflow-injection'].result != 'success' ||
      (needs.mutants.result != 'success' && needs.mutants.result != 'skipped') }}
```

**Why rejected:** this condition **fails OPEN**, not closed. If a future job is added to
`ci-gate.needs` but the corresponding `needs.<job>.result != 'success'` clause is forgotten
in this hand-maintained OR-chain, the gate does not error — it silently stops checking that
job at all. Weakening by *omission* is invisible to a code reviewer scanning a diff (a
missing line reads as "nothing changed here," not as "a gap was introduced"). This is
precisely the drift class this repo has already suffered twice (DEC-096/DEC-097) and that
`S-CIGATE-1` was built to prevent structurally, not just by convention.

### Option B — skipped-safe gate + step-level PR-only gating on `mutants` (REJECTED)

Add `|| contains(needs.*.result, 'skipped')` to the gate condition, **and** remove
`mutants`' job-level `if: github.event_name == 'pull_request'` entirely, moving the
PR-only decision down to the individual steps that do real work.

**Why rejected — worse than originally scoped.** v1.0 of this story identified 3 steps
needing individual step-level `if:` guards (harden-runner, checkout, the `cargo mutants`
invocation) plus a new branch in `Check kill rate`. Direct re-verification against
`.github/workflows/ci.yml :: mutants` for this revision found **5 steps** need their own
`if:` (harden-runner, checkout — which also carries a `fetch-depth: 0` full-history clone,
not a cheap no-op — `taiki-e/install-action`, `Swatinem/rust-cache`, and `Run mutation tests
on PR diff`), not 3. Left as job-level-unconditional, this design would additionally: (a)
burn real runner time on every push (harden-runner audit, full-history checkout,
cargo-mutants tool install, Rust dependency cache restore) for a job that ultimately does
nothing on that event; and (b) report a green "Mutation testing ✓" check on every push for a
job that tested nothing — inverting the signal a human or another CI consumer would read
from that job's name and status. v1.0's independently-derived false-red risk (the `Check
kill rate` step's `steps.run-mutants.outcome` branching does not currently handle a
`skipped` outcome, and would need a new branch to avoid converting today's false-green into
a false-red on every push) was **confirmed exactly** by the research pass, which traced the
same code path independently. Between the newly-discovered 5-edit surface, the wasted
runner time, and the inverted-signal problem, Option B was rejected as strictly worse than
its own v1.0 framing suggested.

## Option C — fail-closed script-based evaluator with a restrictive allowlist (APPROVED)

**Human-approved, recommended fix.** Keep `ci-gate.needs` as the single source of truth for
which jobs gate the branch. Keep `if: ${{ always() }}` at the **job** level (the job always
concludes; the *step* decides pass/fail). Replace the current inline negative-`contains`
step condition with an invocation of a new script, `scripts/check-ci-gate.sh`, given
`toJSON(needs)` as input.

**Script behavior (fail-closed):**
- For each job present in the `needs` JSON: if its `result` is exactly `success`, that job
  passes.
- A small, hardcoded, restrictive `ALLOWED_SKIPS` list inside the script names jobs that may
  ADDITIONALLY report `skipped` and still pass. **Restrictive, not blanket:** a job named in
  `ALLOWED_SKIPS` still fails the gate on `failure` or `cancelled` — the carve-out tolerates
  `skipped` ONLY, nothing else.
- `ALLOWED_SKIPS` contains **`mutants` only** (the one job with a job-level
  `if: github.event_name == 'pull_request'` today).
- Any other result value for any job — `failure`, `cancelled`, an unlisted `skipped`, or any
  result string the script has never seen before (a hypothetical future GitHub Actions
  conclusion type) — is treated as a failure by a **default arm**, not enumerated
  exceptions. This is the structural fix for the current condition's shape: today's
  condition is an allowlist of *known-bad* values (`failure`, `cancelled`), so any new value
  GitHub ever introduces passes straight through unnoticed; Option C inverts this so only
  `success` (and the one named, restricted exception) passes.
- If the `needs` JSON is empty (`{}`), the script exits 1 — fail closed if the gate somehow
  loses its own dependency list, rather than vacuously passing.
- The script prints one `OK <job> = success` or `FAIL <job> = <result>` line per job so a
  gate failure is diagnosable directly from the `ci-gate` job's own log, without cross-
  referencing other jobs' logs.
- `jq` is used to parse the `toJSON(needs)` payload — already an assumed dependency in this
  file (`.github/workflows/ci.yml :: mutants § "jq is pre-installed on the ubuntu-latest
  runner image"`, used by `Check kill rate`); no new tooling assumption is introduced.

**The `mutants` job is entirely UNCHANGED under Option C** — it keeps its job-level
`if: github.event_name == 'pull_request'`, and `Check kill rate` is not touched. This is
Option C's principal advantage over Option B: one atomic, self-contained edit to the gate's
own logic, zero coordination with the mutants job's internals, and therefore none of Option
B's false-red risk.

### Companion: extracted script with a self-test (approved, in scope)

Per this repo's established pattern (`scripts/check-signing-workflow-injection.sh
--self-test`, DEC-148/DEC-150), the gate's decision logic is extracted into
`scripts/check-ci-gate.sh` rather than left as an inline, untestable YAML expression, and
gains a `--self-test` flag exercising a fixed set of built-in JSON fixtures covering (at
minimum): all-success; one job reporting `failure`; an unlisted job reporting `skipped`
(must FAIL); the allowed job (`mutants`) reporting `skipped` (must PASS); one job reporting
`cancelled`; one job reporting an unrecognized/future result value (must FAIL via the
default arm); and an empty `needs` object (must FAIL).

**Wiring constraint (critical, verified against the current job graph):** the self-test
CANNOT run inside the `ci-gate` job itself — a gate cannot be a dependency of itself, and
`ci-gate` has no steps other than the gate check today. It is wired as two new steps inside
`spec-guard` (`.github/workflows/ci.yml :: spec-guard`, confirmed via direct read: no
job-level `if:`, runs on both push and PR, already a member of `ci-gate.needs`), mirroring
the exact self-test-then-real-check step pairing already used there for
`check-cargo-mutants-policy-citations.sh` and `check-bc-citation-symbols.sh`:

```yaml
- name: check-ci-gate self-test (fixture suite)
  run: bash scripts/check-ci-gate.sh --self-test
```

(A second, real-invocation step is NOT needed inside `spec-guard` — the script's real
invocation happens inside `ci-gate` itself, against the real `toJSON(needs)` payload for
that run. `spec-guard` only proves the script's *decision logic* is not a no-op, matching
the rationale already established for the other two self-tests in that job.)

**Why the self-test matters, beyond following convention:** the gate's decision logic is
currently the *only* untested piece of logic gating merges into `develop` and `main`, and
this very defect is precisely the failure mode `tests/ci_gate_completeness.rs` did not
catch — its assertions verify the gate script's YAML *is present with certain substrings*,
not that the script *decides correctly* on any given input. Text-pinning
`contains(needs.*.result, 'skipped')` into the file (which is roughly what AC-001 of v1.0
would have done under Option B) proves the string is there; it does not prove the logic
produces the right pass/fail outcome on a `skipped`-vs-`success`-vs-unknown input. The
`--self-test` fixture suite closes exactly that gap by exercising the decision function
against concrete inputs and asserting concrete outputs.

## Out of Scope (explicit)

- **`security`/gitleaks joining `ci-gate.needs`** — currently NOT in `needs` at all; whether
  it should be is a policy decision, unrelated to this story. Pointer only.
- **`strict: false` on branch protection** — a separate config decision (affects whether
  branches must be up-to-date before merge, not whether `skipped` satisfies the gate).
  Pointer only.
- **The `mutants` job's `outcomes.json` schema-drift fail-open handling** (the
  `total_mutants`/`caught`/`missed` reconciliation warnings already in the `Check kill rate`
  script) — a distinct, already-mitigated failure mode with its own guard
  (`H-1`/`H-2`/`M-2` comments in `ci.yml`). Not touched by this story; the `mutants` job is
  entirely unchanged under Option C.
- **A workflow-level `paths:`/`paths-ignore:` filter on `ci.yml` itself** — MUST NOT be
  added. On a `push` event there is no PR to gate; a `paths:` filter would make the entire
  workflow (including `ci-gate`) skip silently for any push that doesn't touch the listed
  paths, with nothing left pending to block the merge — a different, workflow-level instance
  of the same "skip reads as pass" failure class this story fixes at the job level. Pointer
  only; not touched by this story, but explicitly flagged so a future contributor does not
  reintroduce the hole one layer up.

## Blocking-Adjacent Risk (flag prominently, do not fix here)

**`S-CIGATE-1-ci-gate-aggregator.md` AC-003 still asserts, as a requirement:** *"`security`
and `mutants` MUST NOT appear in `ci-gate.needs` (they emit `skipped` on push events, which
would poison push-triggered `ci-gate` runs). ... Pinned by: ... `test_ci_gate_excludes_pr_only_jobs`
(asserts `security`, `mutants`, `coverage` absent)."* This remains **doubly** contradicted
under Option C, unchanged from v1.0's finding: (a) shipped reality already has `mutants` in
`ci-gate.needs` (via `S-MUTATION-CI-TIMEOUT-1`, predating this story), and its own
regression test is literally named `test_mutants_is_in_ci_gate_needs` — the opposite test
from what S-CIGATE-1 AC-003 describes; (b) this story's own fix keeps `mutants` in
`ci-gate.needs` AND keeps its job-level `if:` (Option C leaves the `mutants` job completely
unchanged) — a stronger, more permanent contradiction of "MUST NOT appear in
`ci-gate.needs`" than even the status quo, since Option C does not even attempt to make
`mutants` job-level-unconditional (Option B would have).

**A future implementer who reads `S-CIGATE-1-ci-gate-aggregator.md` literally and "fixes"
the drift by removing `mutants` from `ci-gate.needs`, or by removing it from
`scripts/check-ci-gate.sh`'s `ALLOWED_SKIPS` list, would silently revert this story's fix**
and reopen the exact hole `S-MUTATION-CI-TIMEOUT-1` closed for the 90%-kill-rate gate. This
spec/reality reconciliation is explicitly scoped OUT of this story (per instruction) — it
needs its own follow-up (a spec-only correction to `S-CIGATE-1-ci-gate-aggregator.md`
AC-003, its Architecture Compliance Rules table, its Test Coverage Summary row, and its Edge
Cases table) so it is not silently lost. Recording it here as the single most important
pointer in this story.

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|-----------------|----------------|
| `ci-gate` step | `.github/workflows/ci.yml` | N/A (CI config) | Invokes `scripts/check-ci-gate.sh` with `toJSON(needs)`; the aggregate pass/fail decision now lives in the script, not inline YAML |
| `scripts/check-ci-gate.sh` | `scripts/` | pure-core (reads JSON from stdin/arg, writes to stdout, exits with a status — no network, no repo mutation) | The fail-closed evaluator: per-job `success`/allowed-`skipped` check, default-fail arm for everything else, empty-needs guard |
| `spec-guard` self-test steps | `.github/workflows/ci.yml :: spec-guard` | N/A (CI config) | Proves `check-ci-gate.sh`'s decision logic against fixtures, mirroring the existing self-test pairing pattern in the same job |
| `mutants` job | `.github/workflows/ci.yml` | UNCHANGED | Not touched by this story under Option C — retained here to make the "unchanged" claim auditable against a concrete row |
| `tests/ci_gate_completeness.rs` | `tests/` | pure-core | Source-text grep over `ci.yml`; hermetic drift-prevention; no network, no `cargo mutants` invocation |

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| `S-CIGATE-1` | Introduced the `ci-gate` aggregator itself; explicitly documented (Architecture Compliance Rules table) that `mutants` MUST NOT be in `ci-gate.needs` because it emits `skipped` on push — the exact hole this story closes, predicted but never guarded against in code. | Source-text grep testing of `ci.yml` via `tests/ci_gate_completeness.rs` (no YAML parser dependency); `extract_job_block()` helper anchors assertions to one job's slice to avoid cross-job false matches. | The story's own AC-003/Architecture Compliance Rules table is now stale against shipped reality (see Blocking-Adjacent Risk) — a spec that correctly predicts a failure mode is not a substitute for a code guard against it. |
| `S-MUTATION-CI-TIMEOUT-1` | Added `mutants` to `ci-gate.needs` to enforce a 90% kill-rate gate on every PR, without revisiting the gate's `skipped`-blind condition. | `continue-on-error: true` + a separate "Check kill rate" step as the sole pass/fail arbiter, so the harness-crash-vs-clean-PR distinction can be diagnosed from step outcome + `outcomes.json` presence. | Adding a PR-only job to `needs` without also auditing the gate's failure condition silently reopens the skipped-job trap `S-CIGATE-1` was built to prevent. |
| `S-626-1` (in-flight, not yet merged) | Repeated adversarial review of this exact file surfaced multiple HIGH-severity false-green holes in the `ci-gate`/`mutants` guard logic (e.g. ADV-P45-HIGH-001: the `run:` step body itself was unpinned and could be swapped to `echo` while every prior assertion stayed green). | "Proven RED before merge" discipline: every new/changed assertion in `tests/ci_gate_completeness.rs` is independently confirmed to fail against the pre-fix file before the fix lands, not just confirmed passing after. | This file is under heavy, ongoing adversarial scrutiny — a plausible-looking fix (this story's own v1.0 recommendation, Option B) can trade one false-green for a false-red if a change's full edit surface is not independently re-derived rather than assumed. |
| `S-CIGATE-2` v1.0 (this story, prior revision) | Recommended Option B conditional on fixing a `Check kill rate` outcome-branching gap it discovered. | "Assume nothing, re-derive everything" — a plausible architectural direction (skipped-safe condition) still had to be checked against the actual step list, not just the two example steps used to illustrate it. | The initial edit-surface estimate (3 steps) undercounted by finding only the steps needed to *illustrate* the idea, not all steps that actually needed the guard (5, confirmed by direct re-read). A second, independent pass (the research pass for v2.0) caught this by re-reading the same file rather than trusting v1.0's own count. |

_This is a self-referential lesson worth stating plainly: this story's own v1.0 write-up
made exactly the kind of "confirmed via representative example, not exhaustive check" error
that its Corrections-to-the-Brief sections elsewhere call out in other documents. v2.0 does
not assume its own architectural choice (Option C) is edit-surface-complete without
independently re-deriving the wiring constraint (self-test cannot run inside `ci-gate`
itself) and the `spec-guard` job's current structure, both confirmed by direct file reads
rather than by extrapolation — see Verification Log._

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| `ci-gate`'s pass/fail decision is fail-closed: only `success`, or `skipped` for a job explicitly named in `ALLOWED_SKIPS`, passes; every other value (including any future GitHub Actions conclusion type) fails by default | This story, AC-001/AC-002/AC-003 | `scripts/check-ci-gate.sh`'s default-fail arm + `ALLOWED_SKIPS` allowlist; `--self-test` fixture covering an unrecognized result value |
| `ALLOWED_SKIPS` carve-outs are restrictive: a listed job still fails the gate on `failure`/`cancelled` — only `skipped` is tolerated | This story, AC-002 | `--self-test` fixture: `mutants` reporting `failure` must still FAIL the gate, not be waved through because it is in the allowlist |
| `ALLOWED_SKIPS` contains `mutants` only; any future job promoted into `ci-gate.needs` that can legitimately report `skipped` must be added to `ALLOWED_SKIPS` explicitly, or the gate will (correctly) start failing on that job's push-event runs | This story, AC-002; CLAUDE.md convention update (AC-009) | `--self-test` fixture: an unlisted job reporting `skipped` must FAIL |
| Empty `needs` JSON fails the gate rather than passing vacuously | This story, AC-004 | `--self-test` empty-needs fixture |
| `if: ${{ always() }}` on `ci-gate` itself remains load-bearing and untouched | `S-CIGATE-1` Architecture Compliance Rules (pre-existing, not modified here) | `test_ci_gate_pass_fail_semantics_are_structurally_placed` (pre-existing; retargeted at AC-005 to assert the step now invokes `check-ci-gate.sh` rather than the retired inline condition) |
| The `mutants` job (including its job-level `if:`) is UNCHANGED by this story | This story, explicit design choice (Option C's core advantage over Option B) | AC-006: a diff-based assertion/manual check that `.github/workflows/ci.yml :: mutants` is byte-identical before and after this story's PR |
| The self-test for `check-ci-gate.sh` runs inside `spec-guard`, never inside `ci-gate` (a gate cannot depend on itself) | This story, AC-008; verified against the current job graph (`ci-gate` has no other steps to host a self-test) | Source-text assertion that `spec-guard`'s step list contains the self-test step |
| Every new/changed test assertion must be proven RED against the pre-fix file before merge | `CLAUDE.md` TDD convention ("Default to fixing code, not tests"); `S-626-1` cycle precedent | AC-007; recorded in the PR description per Task |

_Extracted from this story's own root-cause analysis (no architecture.md/ADR exists for CI
workflow internals in this repo) and from the precedent set by `S-CIGATE-1`/`S-626-1`, the
two prior stories to touch this exact file, plus `scripts/check-signing-workflow-injection.sh`
for the extracted-script-with-self-test pattern (DEC-148/DEC-150)._

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| GitHub Actions expressions (`toJSON()`, `needs.*`) | N/A (GitHub-hosted runner syntax, not a versioned library) | Serializes the `needs` context to JSON for `scripts/check-ci-gate.sh` to consume |
| `jq` | pre-installed on `ubuntu-latest` (unchanged); already assumed by `.github/workflows/ci.yml :: mutants § "jq is pre-installed on the ubuntu-latest runner image"` | Parses the `needs` JSON payload inside `scripts/check-ci-gate.sh`; no new tooling assumption |
| `bash` | pre-installed on `ubuntu-latest` (unchanged) | Runtime for `scripts/check-ci-gate.sh`, matching every other `scripts/check-*.sh` in this repo |
| `cargo-mutants` | `@27` (pinned in `ci.yml`, unchanged by this story) | The mutation-testing binary invoked by the `mutants` job; entirely untouched under Option C |

_No new external library or framework is introduced by this story. `jq` and `bash` are
already load-bearing dependencies of this exact file (`mutants` job's `Check kill rate`
step; every other `scripts/check-*.sh`), so this table exists to confirm that explicitly per
the MANDATORY template requirement, not to introduce anything new._

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `.github/workflows/ci.yml` | modify | `ci-gate` step body replaced with an invocation of `scripts/check-ci-gate.sh` over `toJSON(needs)` (AC-001–AC-004); `spec-guard` gains a `check-ci-gate self-test (fixture suite)` step (AC-008); `mutants` job UNCHANGED |
| `scripts/check-ci-gate.sh` | create | Fail-closed needs-result evaluator: `ALLOWED_SKIPS=("mutants")`, per-job success/allowed-skip check, default-fail arm, empty-needs guard, `OK`/`FAIL` log lines, `--self-test` flag with built-in JSON fixtures (AC-001–AC-004, AC-008) |
| `tests/ci_gate_completeness.rs` | modify | Assertions retargeted from the retired inline YAML condition to: `ci-gate`'s step invokes `check-ci-gate.sh`; `mutants` job block is unchanged (still carries its job-level `if:`); `spec-guard` contains the new self-test step; top-of-file doc comment corrected (AC-005–AC-009) |
| `CLAUDE.md` | modify | Existing `ci-gate` Conventions bullet extended: new required jobs go in `ci-gate.needs`; jobs that can legitimately report `skipped` must ALSO be added to `scripts/check-ci-gate.sh`'s `ALLOWED_SKIPS`, or the gate will correctly start failing them (AC-009) |

_Maps every file this story reads, creates, or modifies. One new file
(`scripts/check-ci-gate.sh`) is created; no other new files._

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `.github/workflows/ci.yml` `ci-gate`/`mutants`/`spec-guard` job definitions | effectful-shell (CI config, not Rust) | GitHub Actions YAML — declarative but not pure in the Rust-purity sense; drives real CI side effects (job scheduling, exit codes feeding branch protection) |
| `scripts/check-ci-gate.sh` | pure-core | Reads a JSON payload (stdin, argument, or `--self-test` built-in fixture), computes a pass/fail decision and per-job log lines, exits with a status. No network calls, no repo mutation, no dependence on wall-clock time or environment beyond `jq`/`bash` availability — fully hermetic and deterministic given a fixed input, mirroring `scripts/check-signing-workflow-injection.sh`'s classification |
| `tests/ci_gate_completeness.rs` | pure-core | Reads `ci.yml` as a string and asserts on its text content only; no network calls, no script execution, no filesystem writes — fully hermetic and deterministic given a fixed `ci.yml` |
| `CLAUDE.md` | N/A (prose documentation) | Not code; no purity classification applies |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~9,500 |
| `.github/workflows/ci.yml` (current, 445 LOC) | ~4,800 |
| `tests/ci_gate_completeness.rs` (current, 750 LOC) | ~9,000 |
| `scripts/check-signing-workflow-injection.sh` (pattern reference, ~200 LOC) | ~2,500 |
| `CLAUDE.md` relevant section (Conventions, ci-gate bullet) | ~200 |
| `S-CIGATE-1-ci-gate-aggregator.md` (cross-reference for Blocking-Adjacent Risk) | ~2,500 |
| Live CI run / `gh api` tool-output overhead (branch protection, run history, per-job breakdowns) | ~3,000 |
| **Total** | **~31,500** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~16%** |

Well within the 20–30% target. No splitting required.

## Acceptance Criteria

### AC-001 — `ci-gate`'s step invokes `scripts/check-ci-gate.sh` over `toJSON(needs)`

`.github/workflows/ci.yml :: ci-gate`'s single step is replaced with an invocation of
`scripts/check-ci-gate.sh`, passed the `needs` context serialized via `toJSON(needs)` (as an
environment variable, a piped stdin payload, or a temp-file argument — exact mechanism left
to the implementer; `env:` + stdin is the lowest-risk choice since it avoids a shell-quoting
round-trip of arbitrary JSON through a CLI argument). `if: ${{ always() }}` remains at the
job level, unchanged.

Verification vehicle: a new/retargeted test in `tests/ci_gate_completeness.rs` asserting the
`ci-gate` step's `run:` body invokes `check-ci-gate.sh` (not the retired inline
`contains(needs.*.result, …)` expression) and that `toJSON(needs)` is passed to it. Proven
RED first: run the retargeted assertion against `ci.yml` at the commit immediately preceding
this story's fix (which still has the old inline condition) and confirm it fails with a
diagnostic naming what's missing.

### AC-002 — `scripts/check-ci-gate.sh` fails closed with a restrictive `ALLOWED_SKIPS` allowlist

The script fails the gate (non-zero exit) unless, for every job in the input, the job's
`result` is `success`, OR the job's `result` is `skipped` AND the job's name is present in a
hardcoded `ALLOWED_SKIPS` array. `ALLOWED_SKIPS` contains exactly `("mutants")`. A listed
job's `failure`/`cancelled` result STILL fails the gate — the allowlist tolerates `skipped`
only, never any other non-`success` value, for any job.

Verification vehicle: `scripts/check-ci-gate.sh --self-test` runs fixtures asserting: (a)
all-`success` passes; (b) `mutants: skipped`, everything else `success`, passes; (c) an
UNLISTED job reporting `skipped` FAILS; (d) `mutants: failure` FAILS (allowlist does not
extend to non-`skipped` values); (e) any job reporting `cancelled` FAILS. Proven RED first:
each fixture's expected outcome is verified against a stub/no-op version of the script
before the real logic is written (or equivalently, the fixture harness itself is proven to
fail loudly on a deliberately-broken reference implementation before being trusted against
the real one).

### AC-003 — Default arm fails on any unrecognized result value

Any `result` value the script does not explicitly recognize as `success` (always OK) or
`skipped`-for-an-allowlisted-job (conditionally OK) — including `failure`, `cancelled`, and
any hypothetical future GitHub Actions conclusion string never seen before — is treated as a
failure by a default/else arm, not by an enumerated list of known-bad values. This is the
structural fix for the current condition's shape (today's condition is a list of known-bad
values, so an unrecognized future value passes through silently; Option C inverts this).

Verification vehicle: `scripts/check-ci-gate.sh --self-test` includes a fixture with an
invented, never-before-seen result string (e.g. `"action_required"` or similar) for one job,
asserting the script FAILS on it. Proven RED first per AC-005.

### AC-004 — Empty `needs` fails closed

If the input JSON's `needs` object is empty (`{}`), the script exits non-zero rather than
vacuously passing (a gate with nothing to check must not report success — that would mean
the gate itself lost its dependency wiring, which is worse than a normal failure).

Verification vehicle: `scripts/check-ci-gate.sh --self-test` includes an empty-`needs`
fixture asserting a non-zero exit. Proven RED first per AC-005.

### AC-005 — Regression tests / fixtures proven RED before shipping, per CLAUDE.md TDD convention

Each new assertion in `tests/ci_gate_completeness.rs` AND each new `--self-test` fixture in
`scripts/check-ci-gate.sh` is independently confirmed to fail (or to have failed against an
intentionally-broken reference implementation) before the corresponding fix/logic lands,
with a diagnostic naming the specific gap — not confirmed passing only after the fact. This
mirrors the "proven RED" discipline already established in this file's own commit history
(e.g. ADV-P45-HIGH-001's `run:`-step-body pin, independently re-proved RED before merge per
`STORY-INDEX.md`'s S-626-1 row).

### AC-006 — The `mutants` job is byte-identical before and after this story

`.github/workflows/ci.yml :: mutants`'s job block (including its job-level `if:`, all 6
steps, and every comment) is unchanged by this story's PR. This is Option C's defining
constraint — verifying it holds is what proves the option was actually implemented as
specified rather than drifting back toward Option B mid-implementation.

Verification vehicle: a diff of `.github/workflows/ci.yml` in the implementation PR shows
zero changed lines inside the `mutants:` job block (manual/CI-diff check, recorded in the PR
description — no dedicated Rust test needed since `tests/ci_gate_completeness.rs`'s existing
`extract_job_block("mutants")`-based assertions, if any survive unmodified, already provide
indirect coverage; do not add a new test whose only job is to assert "this text hasn't
changed" without also asserting something about its content, per this repo's "name asserting
an unchecked guarantee" naming-convention carve-out precedent from `S-626-1`).

**Coordination note (verify at implementation time, not from this story):** as of this
story's writing, `develop` HEAD's `tests/ci_gate_completeness.rs` has 7 test functions. A
separate, in-flight, NOT YET MERGED story (`S-626-1`, worktree `.worktrees/S-626-1`, branch
`ci/fix-toolchain-sha-msrv`) has already evolved its own copy of this file to 9 test
functions — it renamed `test_ci_gate_job_exists_with_correct_shell` →
`test_ci_gate_job_exists_with_required_metadata` and added
`test_verify_test_job_has_zero_test_floor` and
`test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env`. **Confirmed for this
revision (re-diffed 2026-08-06): S-626-1's worktree also does NOT touch `spec-guard`** — so
there is zero overlap with this story's Option C wiring either, in addition to the
`ci-gate`/`mutants` non-overlap already established in v1.0. Whichever story merges second
must re-derive the current test function names/count from the tree at merge time, not from
either this story's 7-function baseline or S-626-1's 9-function baseline, both of which will
be stale by the time either lands.

### AC-007 — No regression among existing tests

`cargo test --test ci_gate_completeness` exits 0 with all pre-existing test functions still
present (none silently deleted or weakened to make new assertions pass), and `cargo test`
(full suite) shows no regression elsewhere.

### AC-008 — `check-ci-gate.sh --self-test` wired into `spec-guard`, not `ci-gate`

`.github/workflows/ci.yml :: spec-guard` gains a step running
`bash scripts/check-ci-gate.sh --self-test`, positioned consistently with the existing
self-test-then-real-check pairing already used in that job for
`check-cargo-mutants-policy-citations.sh` and `check-bc-citation-symbols.sh`. The self-test
is NOT wired into `ci-gate` (verified structurally impossible/circular: `ci-gate` cannot
depend on a job that depends on `ci-gate`, and `ci-gate` itself has no other steps to host a
self-test alongside the real gate check it performs against the actual `needs` payload for
that run).

Verification vehicle: a new assertion in `tests/ci_gate_completeness.rs` (or a sibling test
file) asserting `spec-guard`'s step list contains a step invoking
`check-ci-gate.sh --self-test`, and that `ci-gate`'s own step list does NOT contain a
`--self-test` invocation (distinguishing the real gate check from the fixture suite).

### AC-009 — Documentation corrected to match Option C's actual behavior (not merely appended to)

(a) `tests/ci_gate_completeness.rs`'s top-of-file doc comment (currently: *"mutants IS in
`needs`... skipped is neither, so ci-gate passes on push events. This is the correct
behavior..."*) is rewritten to state Option C's actual invariant: the gate's decision logic
lives in `scripts/check-ci-gate.sh`; `mutants` reporting `skipped` on push is tolerated
ONLY because it is named in that script's `ALLOWED_SKIPS` list; any other job's `skipped`
result, or any unrecognized result value for any job, fails the gate by default.

(b) `CLAUDE.md`'s existing `ci-gate` Conventions bullet (*"CI Gate ... is THE single
required branch-protection status check on develop/main. New CI jobs that must be required
must be added to ci-gate.needs, never wired directly into branch protection..."*) gains one
additional sentence: a job added to `ci-gate.needs` that can legitimately report `skipped`
(e.g. a future PR-only or repo-variable-gated job) must ALSO be added to
`scripts/check-ci-gate.sh`'s `ALLOWED_SKIPS` list, or the gate will correctly start failing
that job's push-event runs — this is enforced by the script's fail-closed default, not by
convention alone.

Pinned by: source-text inspection on the PR diff (documentation-only assertion, consistent
with S-CIGATE-1 AC-005's precedent of no automated test for prose changes).

## Edge Cases

| ID | Description | Expected Behavior / Status |
|----|-------------|------------------------------|
| EC-001 | Cascade skip — a `needs` job skipped because a job it itself depends on (`needs:`) was skipped | Not reachable today: none of the 8 current `ci-gate.needs` jobs (`fmt`, `clippy`, `test`, `msrv`, `deny`, `spec-guard`, `check-signing-workflow-injection`, `mutants`) carries its own `needs:` key (confirmed by direct grep). Under Option C: a cascaded skip still surfaces as `skipped` in `toJSON(needs)` for the affected job, so `scripts/check-ci-gate.sh`'s default handling applies exactly as for a direct skip — it FAILS unless that job happens to be in `ALLOWED_SKIPS`, which is the correct conservative behavior for an unplanned cascade. |
| EC-002 | A future job gated by a repo-variable (the `security` § `if: … && vars.GITLEAKS_DISABLED != 'true'` pattern already used in this file) is promoted into `ci-gate.needs` | Under Option C, this is now an EXPLICIT, single-point maintenance action: the job must be added to `scripts/check-ci-gate.sh`'s `ALLOWED_SKIPS` array (one line, one file) or the gate will correctly start failing every push where that job's gating variable causes a skip. This is a strict improvement over both the pre-existing gap (no mechanism at all) and Option B's approach (would have required auditing every step inside that job for its own `if:` placement, plus checking any script it feeds for skipped-outcome handling). The one remaining manual step — remembering to add the job to `ALLOWED_SKIPS` — is the same class of "must remember" step Option A had, but the consequence of forgetting is now a loud gate FAILURE (fail-closed) rather than a silent, invisible pass-through (fail-open) — this is the core distinction that made Option C acceptable where Option A was not. |
| EC-003 | A `needs` job's `strategy.matrix` evaluates to zero entries (e.g. a future `fromJSON`-driven dynamic matrix for `test`/`clippy`) | Not reachable today — both matrices (`clippy`, `test`) are static OS arrays, never empty. GitHub Actions does not run a job with zero matrix combinations; whether that surfaces as `skipped` in `toJSON(needs)` for that job, or as the job simply absent from the `needs` object entirely, was not independently verified for this story (out of scope to reproduce). Either way, `scripts/check-ci-gate.sh`'s AC-004 empty/absent handling and AC-003 default-fail arm together mean this cannot silently pass: an absent-but-expected job or an unlisted `skipped` both fail closed. Flagged as a future verification item, not a currently-active defect. |
| EC-004 (OPEN QUESTION) | What does `needs.<id>.result` report for a job that had **not yet started** when the run was cancelled? | **Not resolved by this story; do not treat as settled.** 4 cancelled `ci.yml` runs exist in the last 200 sampled (`29736816386`, `29735639851`, `29701963083`, `29699658785`, all `pull_request`-triggered). In all 4, the only job reporting `cancelled` was `Mutation testing`, which was already in-flight (240-minute timeout, by far the slowest job) when the run was superseded/cancelled; every other job had already completed `success`/`failure`, and `CI Gate` correctly concluded `failure` in all 4 cases. This confirms the *already-started-then-cancelled* pattern is handled correctly today. It does **not** isolate the narrower case of a job still queued and never started at cancellation time — belief (unverified) is that such a job also reports `cancelled`; if it instead reports `skipped`, `scripts/check-ci-gate.sh`'s AC-003 default-fail arm covers it automatically (an unlisted `skipped` fails the gate) exactly as it would for any other unlisted skip. No action item beyond recording this uncertainty — Option C's fail-closed design means the answer to this question changes nothing about correctness either way, which was not true under Option A or B. |
| EC-005 | A workflow-level `paths:`/`paths-ignore:` filter is added to `ci.yml` in the future | Out of scope for this story to prevent in code, but explicitly flagged (see Out of Scope) because it reintroduces the identical failure class one layer up: a `push` with no matching paths would skip the ENTIRE workflow, including `ci-gate`, leaving nothing pending to block a merge — no job-level fix inside `ci-gate` or `check-ci-gate.sh` can compensate for the workflow never running at all. |

## Test Coverage Summary

| # | Assertion | File | AC |
|---|-----------|------|-----|
| 1 | `ci-gate` step invokes `scripts/check-ci-gate.sh` over `toJSON(needs)` (not the retired inline condition) | `tests/ci_gate_completeness.rs` | AC-001 |
| 2 | All-`success` fixture passes | `scripts/check-ci-gate.sh --self-test` | AC-002 |
| 3 | `mutants: skipped` (allowlisted), rest `success`, passes | `scripts/check-ci-gate.sh --self-test` | AC-002 |
| 4 | Unlisted job reporting `skipped` FAILS | `scripts/check-ci-gate.sh --self-test` | AC-002 |
| 5 | `mutants: failure` FAILS (allowlist does not cover non-`skipped`) | `scripts/check-ci-gate.sh --self-test` | AC-002 |
| 6 | Any job reporting `cancelled` FAILS | `scripts/check-ci-gate.sh --self-test` | AC-002 |
| 7 | Unrecognized/future result value FAILS via default arm | `scripts/check-ci-gate.sh --self-test` | AC-003 |
| 8 | Empty `needs` FAILS closed | `scripts/check-ci-gate.sh --self-test` | AC-004 |
| 9 | Every fixture above independently proven RED against a broken/pre-fix reference before merge | PR description (manual verification record) | AC-005 |
| 10 | `mutants` job block byte-identical pre/post PR | PR diff (manual/CI-diff check, recorded in PR description) | AC-006 |
| 11 | `cargo test --test ci_gate_completeness` exits 0, all pre-existing test functions present | `tests/ci_gate_completeness.rs` | AC-007 |
| 12 | `spec-guard` step list contains `check-ci-gate.sh --self-test`; `ci-gate`'s step list does not | `tests/ci_gate_completeness.rs` | AC-008 |

## Dependency Analysis

**depends_on: []** — standalone. Does not require `S-626-1` to merge first, and does not
block on it (confirmed no overlapping logic, including the new `spec-guard` wiring —
re-diffed for this revision — see AC-006 coordination note).

**blocks: []** — no story explicitly depends on this one. The `S-CIGATE-1` spec-reconciliation
follow-up (see Blocking-Adjacent Risk) is a natural successor but is not created as a formal
`blocks:` edge here since it does not yet exist as a story.

**Suggested delivery order relative to S-626-1:** either order is safe given zero logical
overlap in `ci-gate`, `mutants`, AND `spec-guard`; whichever lands second should re-run
`cargo test --test ci_gate_completeness` against develop HEAD (post-first-merge) before
opening its own PR, purely to catch merge conflicts in the shared file — not because of any
behavioral dependency.

## Tasks (MANDATORY)

1. Read `.github/workflows/ci.yml`'s `ci-gate`, `mutants`, and `spec-guard` job blocks in
   full (current state, not the version quoted in this story, in case any has drifted by
   implementation time).
2. Write `scripts/check-ci-gate.sh`: `ALLOWED_SKIPS=("mutants")`, per-job evaluation loop
   (success → OK; skipped-and-allowlisted → OK; everything else → FAIL), empty-`needs`
   guard, per-job `OK`/`FAIL` log lines, `--self-test` flag with the 7 built-in fixtures
   from AC-002/AC-003/AC-004/Test Coverage Summary. Model the doc header, usage comment, and
   exit-code documentation on `scripts/check-signing-workflow-injection.sh`.
3. Prove each `--self-test` fixture RED first (against a stub/broken reference or by
   temporarily inverting the pass/fail logic) before finalizing the real implementation
   (AC-005).
4. Apply AC-001: replace `ci-gate`'s step body with an invocation of
   `scripts/check-ci-gate.sh` fed `toJSON(needs)`. Keep `if: ${{ always() }}` at job level.
5. Apply AC-008: add the `check-ci-gate self-test (fixture suite)` step to `spec-guard`,
   positioned consistently with the existing self-test pairing pattern in that job.
6. Confirm (diff) that `mutants`' job block is untouched (AC-006).
7. Write/retarget the assertions in `tests/ci_gate_completeness.rs` (AC-001, AC-006, AC-008
   verification vehicles). Prove each RED against the pre-fix `ci.yml` before applying steps
   2–5 for real, per AC-005.
8. Run `cargo test --test ci_gate_completeness` — all tests green (AC-005/AC-007).
9. Run `cargo test` (full suite) — no regression elsewhere.
10. Run `cargo clippy -- -D warnings` — zero warnings (this story touches no `src/`, but the
    full-suite convention is checked regardless).
11. Run `bash scripts/check-ci-gate.sh --self-test` directly (not just via CI) to confirm it
    exits 0 locally before pushing.
12. Apply AC-009 documentation: rewrite the `tests/ci_gate_completeness.rs` doc comment;
    extend the `CLAUDE.md` `ci-gate` bullet.
13. Push a PR with at least one push-triggered CI run observed (or a fork/manual
    `workflow_dispatch` equivalent) to empirically confirm `ci-gate` still concludes
    `success` on a push when `mutants` reports `skipped` and all other jobs are green, and
    that the `spec-guard` self-test step passes.
14. Run `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` — both
    must exit 0 (no BCs added, so this should be a no-op, but the convention requires the
    check after any `.factory/stories/` edit that could affect counts).

## Story Points and Effort

**8 story points** (standard; raised from v1.0's 5 — Option C requires a new script + fixture
suite + a `spec-guard` wiring change, in addition to the `ci-gate`/test-file changes v1.0
already scoped). Breakdown:
- F4 TDD (`scripts/check-ci-gate.sh` + 7-fixture self-test suite + `ci.yml` gate rewrite +
  `spec-guard` wiring + `tests/ci_gate_completeness.rs` retargeted assertions + RED-proof
  cycle): 5 SP
- F5/F7 review + live push-event verification (Task 13 requires an actual CI run, not just
  static assertions, since the defect is specifically about runtime job-conclusion values):
  3 SP

Risk: MEDIUM — the diff lands in the single most heavily adversarially-reviewed file in the
repo (`ci.yml`/`ci_gate_completeness.rs`, per the S-626-1 cycle history), and introduces one
new script that becomes part of the sole required branch-protection check's decision path
(a bug in `scripts/check-ci-gate.sh` is now a bug in the gate itself). This risk is
substantially LOWER than Option B's would have been, since the `mutants` job and its `Check
kill rate` script — the highest-churn, most-adversarially-reviewed logic in this file — are
entirely untouched (AC-006).

## Verification Log

Facts below were independently checked against the live repo/GitHub API, not transcribed
from either originating brief. Entries marked "(v2.0)" were checked specifically for this
revision; unmarked entries were checked for v1.0 and remain valid (Option C does not change
any of the underlying facts about the defect itself, only the fix).

- `gh api repos/:owner/:repo/branches/develop/protection` and `.../main/protection`: both
  confirm `required_status_checks.contexts: ["CI Gate"]`, `strict: false`,
  `enforce_admins: false`.
- `gh run view 30465686049 --json jobs`: `Mutation testing` and `Secret Scan (gitleaks)` both
  `skipped`; `CI Gate` `success`.
- `.github/workflows/ci.yml :: ci-gate § needs:`: `[fmt, clippy, test, msrv, deny,
  spec-guard, check-signing-workflow-injection, mutants]` — 8 entries, confirmed by direct
  file read.
- `awk`-scoped grep for `needs:` inside each of the 8 job blocks above: zero matches (no
  job-in-`needs` has its own `needs:` edge today).
- `gh run list --workflow=ci.yml --limit 200 --json conclusion,status,event`: 167 success /
  28 failure / 4 cancelled / 1 in-progress. The 4 cancelled runs' per-job breakdown is
  recorded in EC-004 above.
- `.worktrees/S-626-1` (branch `ci/fix-toolchain-sha-msrv`) `tests/ci_gate_completeness.rs`
  and `ci.yml` `ci-gate`/`mutants` blocks: diffed against `develop` HEAD's copies; confirmed
  no overlap with this story's fix.
- (v2.0) `.github/workflows/ci.yml :: mutants`: directly re-read in full — exactly 6 steps
  (Harden the runner, `actions/checkout` with `fetch-depth: 0`, `taiki-e/install-action`,
  `Swatinem/rust-cache`, `Run mutation tests on PR diff` [`id: run-mutants`], `Check kill
  rate`). Confirms the research pass's "5 steps need step-level guards under Option B" count
  and refutes v1.0's own undercounted "3 steps" estimate.
- (v2.0) `.github/workflows/ci.yml`: 445 total lines. The "jq is pre-installed" comment is at
  line ~298 (inside `mutants`'s `Check kill rate` step), not ~424 as cited in the revision
  brief — the ~424 region is inside `check-signing-workflow-injection`/`ci-gate` near the
  file's end.
- (v2.0) `.github/workflows/ci.yml :: spec-guard`: directly re-read in full — no job-level
  `if:`, runs unconditionally, already a member of `ci-gate.needs`, and already contains two
  instances of the exact self-test-then-real-check step pairing (`check-cargo-mutants-policy-citations.sh
  --self-test` → `check-cargo-mutants-policy-citations.sh`; `check-bc-citation-symbols.sh
  --self-test` → `check-bc-citation-symbols.sh`) that `check-ci-gate.sh --self-test`'s
  wiring is modeled on.
- (v2.0) `.worktrees/S-626-1`'s `spec-guard` job block: diffed against `develop` HEAD's copy
  — zero differences, confirming no overlap with this story's new `spec-guard` step either.
- (v2.0) `scripts/check-signing-workflow-injection.sh`: read in full for the doc-header,
  usage-comment, and `--self-test` conventions `scripts/check-ci-gate.sh` should follow.
