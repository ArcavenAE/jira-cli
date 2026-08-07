---
document_type: story
level: ops
story_id: "S-CIGATE-4"
epic_id: "none"
title: "Reconcile S-CIGATE-1 AC-003's obsolete 'mutants MUST NOT appear in ci-gate.needs' prohibition (spec-only)"
version: "1.0"
producer: story-writer
timestamp: "2026-08-06T00:00:00"
phase: 3
cycle: CIGATE-SPEC-RECONCILIATION
inputs:
  - ".factory/stories/S-CIGATE-1-ci-gate-aggregator.md"
  - ".factory/stories/S-CIGATE-2-skipped-status-false-green.md"
  - "tests/ci_gate_completeness.rs"
  - ".github/workflows/ci.yml"
input-hash: "fedd6d4"
traces_to: ".factory/stories/S-CIGATE-1-ci-gate-aggregator.md::AC-003"
wave: feature-followup
status: done
intent: bug-fix
feature_type: ci
mode: feature
scope: xsmall
severity: MEDIUM
trivial_scope: true
points: 1
priority: P1
tdd_mode: facade
estimated_effort: xsmall
estimated_days: 0.25
target_module: ci
subsystems: []
depends_on: []
blocks: []
behavioral_contracts: []
bc_anchors: []
bcs: []
# BC status: no product BCs (spec-only reconciliation of a stale governance document; no
# src/tests/.github changes). BC catalog untouched. Do NOT add BCs.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F1-delta-analysis
spec_source: "No pre-existing delta-analysis document. Written from a direct read of
  S-CIGATE-1-ci-gate-aggregator.md, S-CIGATE-2-skipped-status-false-green.md,
  tests/ci_gate_completeness.rs, and .github/workflows/ci.yml on 2026-08-06, per an explicit
  request to reconcile a contradiction S-CIGATE-2 itself flagged (its 'Blocking-Adjacent
  Risk' section) but declined to fix in-place, deferring it to 'its own follow-up.'"
implementation_strategy: docs-only
module_criticality: LOW
acceptance_criteria_count: 4
assumption_validations: []
risk_mitigations:
  - "This story's corrections are applied directly to S-CIGATE-1-ci-gate-aggregator.md as
     part of authoring this story, not deferred to a future F4 dispatch — the risk being
     mitigated (a future implementer reading S-CIGATE-1 literally and reverting
     S-CIGATE-2/PR #671's fix) is live for as long as the stale prohibition stands
     uncorrected in an open (status: draft) story file. Sizing this as an xsmall,
     immediately-actioned correction rather than a queued backlog item is the mitigation."
created: "2026-08-06"
last_updated: "2026-08-06"
breaking_change: false
files_modified:
  - .factory/stories/S-CIGATE-1-ci-gate-aggregator.md   # MODIFY: correction blockquotes on AC-003, its Architecture Compliance Rules row, its Out-of-Scope bullet, its Test Coverage Summary citation row, and its "all six needs jobs" counts — corrected in place per this repo's decision-record convention (not deleted), recording WHY the prohibition is obsolete
---

# S-CIGATE-4 — Reconcile S-CIGATE-1 AC-003's Obsolete Prohibition (Spec-Only)

## Source of Truth

`.factory/stories/S-CIGATE-1-ci-gate-aggregator.md` (status: `draft`, i.e. still open) AC-003
states, as a requirement: *"`security` and `mutants` MUST NOT appear in `ci-gate.needs` (they
emit `skipped` on push events, which would poison push-triggered `ci-gate` runs)."* Its
Architecture Compliance Rules table (row: "PR-only jobs excluded from `needs`") and its
Out-of-Scope section ("`security` and `mutants` joining `ci-gate.needs`: these are PR-only
jobs. If they are ever promoted to required, that is a separate story") both restate the same
prohibition.

**Independently re-verified for this story, not transcribed from the originating brief:**

- `.github/workflows/ci.yml :: ci-gate § needs:` (develop HEAD): `[fmt, clippy, test, msrv,
  deny, spec-guard, check-signing-workflow-injection, mutants]` — `mutants` **is** present,
  confirmed by direct file read.
- `tests/ci_gate_completeness.rs` (develop HEAD) contains `test_mutants_is_in_ci_gate_needs`
  (line 374) asserting `mutants` belongs in `ci-gate.needs` — the literal opposite of what
  S-CIGATE-1 AC-003 requires. This test was added by `S-MUTATION-CI-TIMEOUT-1` (PR #567,
  2026-06-28), which predates S-CIGATE-2 and post-dates S-CIGATE-1.
- `S-CIGATE-2-skipped-status-false-green.md`'s approved fix (Option C, in-flight on the frozen
  `fix/ci-gate-skipped-false-green` branch, not touched by this story) **requires** `mutants`
  to remain in `ci-gate.needs` AND to keep its job-level `if: github.event_name ==
  'pull_request'` guard completely unchanged — Option C's `ALLOWED_SKIPS` allowlist in the new
  `scripts/check-ci-gate.sh` names `mutants` as its sole entry specifically because it stays in
  `needs` and can legitimately report `skipped`. S-CIGATE-2 itself calls this out under its own
  "Blocking-Adjacent Risk" section, verbatim: *"a future implementer who reads
  `S-CIGATE-1-ci-gate-aggregator.md` literally and 'fixes' the drift by removing `mutants`
  from `ci-gate.needs`, or by removing it from `scripts/check-ci-gate.sh`'s `ALLOWED_SKIPS`
  list, would silently revert this story's fix"* — and explicitly scopes that reconciliation
  OUT of S-CIGATE-2 itself, deferring it to "its own follow-up." This story is that follow-up.
- **The dead citation**, verified present at three live sites in `S-CIGATE-1-ci-gate-aggregator.md`
  (not "at least two" as a cautious lower bound — three, confirmed by direct grep): AC-003's
  "Pinned by" line, AC-004's numbered test list item 3, and the Test Coverage Summary table row
  4, all cite `test_ci_gate_excludes_pr_only_jobs`. That function does not exist in
  `tests/ci_gate_completeness.rs` today — it was renamed to
  `test_ci_gate_excludes_advisory_and_secret_scan_jobs` by `S-MUTATION-CI-TIMEOUT-1` (PR #567,
  commit `3b122a8f`, confirmed via `git log -S`), the same PR that added `mutants` to `needs`.
- **The stale counts**, verified: S-CIGATE-1's Architecture Compliance Rules table
  ("`if: always()` is load-bearing" row) states *"all six `needs` jobs run unconditionally on
  both push and PR events"*, and AC-002's title states "passes when all six succeed." Both are
  now inaccurate — `ci-gate.needs` has **eight** entries today (confirmed above), not six, and
  two of those eight (`check-signing-workflow-injection`, added by `S-FORK-OPS-SIGN-1`, and
  `mutants`, added by `S-MUTATION-CI-TIMEOUT-1`) post-date S-CIGATE-1's authoring. (S-CIGATE-1's
  separate "six test functions" language in AC-004/Test Coverage Summary refers to the
  original *test-file* function count, a different "six" from the *job-list* count — that
  usage is not corrected by this story, since it was accurate as a design target at the time
  S-CIGATE-1 was authored and is not the contradiction this story exists to fix; it is left
  as-is, consistent with "correct what's wrong, not everything that has since drifted.")

## Behavioral Contracts

No product BCs are added or modified. This story traces to
`S-CIGATE-1-ci-gate-aggregator.md::AC-003` (the corrected clause) and to
`S-CIGATE-2-skipped-status-false-green.md`'s own "Blocking-Adjacent Risk" section (the pointer
that named this exact follow-up). No BCs are touched — this is a spec-only correction to a
story file, not a code or test change.

## Story Narrative

As a maintainer of `jr`,
I want `S-CIGATE-1-ci-gate-aggregator.md`'s AC-003 (and its restating Architecture Compliance
Rules row and Out-of-Scope bullet) corrected to reflect that `mutants` belonging in
`ci-gate.needs` is now the shipped, intended, and required design — not silently deleted, but
corrected in place with the reasoning recorded — along with its three dead test-name citations
and two stale job-count claims,
so that a future contributor who reads the only currently-open story governing `ci-gate`
cannot be misled into reverting `S-MUTATION-CI-TIMEOUT-1`'s mutation-gate promotion or
`S-CIGATE-2`/PR #671's fail-closed fix by "fixing" a drift that no longer exists.

## Problem Statement

`S-CIGATE-1` is the only currently *open* (`status: draft`) story governing `ci-gate`. Its
AC-003 instructs, as a requirement, an action that would actively undo two already-shipped
pieces of work if followed literally today: removing `mutants` from `ci-gate.needs` would
revert `S-MUTATION-CI-TIMEOUT-1`'s 90%-kill-rate enforcement gate, and removing it from the
in-flight `scripts/check-ci-gate.sh`'s `ALLOWED_SKIPS` list (once that PR merges) would reopen
the exact skipped-status false-green hole `S-CIGATE-2` was written to close. The prohibition's
*original reasoning was correct at the time it was written* — `mutants` reporting `skipped` on
push genuinely would have "poisoned" a push-triggered `ci-gate` run under the pre-S-CIGATE-2
inline `contains(needs.*.result, 'failure'/'cancelled')` condition, which could not distinguish
an intentionally-tolerated skip from an untrusted one. What changed is not the reasoning but
the underlying hazard: `S-CIGATE-2`'s fail-closed evaluator with a restrictive, explicit
allowlist makes `mutants`-in-`needs`-reporting-`skipped` a deliberately safe, named exception
rather than an accidental gap. The prohibition is obsolete because its premise (no mechanism
exists to safely tolerate a skip) was closed, not because the premise was ever wrong.

## Approach

Correct `S-CIGATE-1-ci-gate-aggregator.md` in place, per this repo's established
decision-record convention (the same blockquote-callout pattern `S-CIGATE-2` itself uses for
its own "v2.0 revision notice"): add a `> **CORRECTION (2026-08-06, S-CIGATE-4):**` blockquote
immediately after AC-003's heading, and matching shorter pointers at the Architecture
Compliance Rules row and the Out-of-Scope bullet, that (a) state plainly that the "MUST NOT
appear in `ci-gate.needs`" clause is superseded by shipped reality, (b) name the two
superseding stories (`S-MUTATION-CI-TIMEOUT-1`, `S-CIGATE-2`) and record why (the hazard being
guarded against was closed by `S-CIGATE-2`'s allowlist mechanism, not by the prohibition being
wrong), and (c) do NOT delete or rewrite the original AC-003 text — it remains, struck through
in spirit but not in fact, as the historical record of what was believed true at authoring
time. The three dead `test_ci_gate_excludes_pr_only_jobs` citations are corrected to the
current name with a parenthetical rename note (mirroring the rename-note convention already
used elsewhere in this same file, e.g. `test_ci_gate_job_exists_with_required_metadata
(formerly test_ci_gate_job_exists_with_correct_shell...)`). The two stale "six `needs` jobs"
job-count claims are corrected to "eight" with a parenthetical noting the two jobs added since
authoring (`check-signing-workflow-injection`, `mutants`) and the stories that added them.

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| `S-CIGATE-1` | Authored the original, then-correct prohibition on `mutants`/`security` in `ci-gate.needs`, based on the inline condition's inability to distinguish a trusted from an untrusted `skipped` result. | Rename-note citation convention (`test_X (formerly test_Y through PR #NNN; renamed <story> round N, commit <sha>)`) — reused by this story's own citation corrections. | A spec that correctly predicts a future failure mode is not a substitute for a code guard against it, and can itself become a stale trap once the code guard ships and supersedes the spec's original recommendation. |
| `S-MUTATION-CI-TIMEOUT-1` | Added `mutants` to `ci-gate.needs` anyway (to enforce the 90% kill-rate gate on every PR), directly contradicting `S-CIGATE-1` AC-003 without revisiting or correcting it. Also renamed `test_ci_gate_excludes_pr_only_jobs` → `test_ci_gate_excludes_advisory_and_secret_scan_jobs` as a side effect of its own test-file changes (PR #567, commit `3b122a8f`). | — | Shipping code that contradicts an open spec's explicit prohibition, without a corresponding spec correction, is exactly how a stale-but-still-open story becomes a live trap for a future reader — this is the second instance of that pattern in this file's own history (the first being S-CIGATE-1 vs. this same PR). |
| `S-CIGATE-2` | Identified this exact contradiction in its own "Blocking-Adjacent Risk" section, named the precise two-part revert risk (removing `mutants` from `needs`, or from `ALLOWED_SKIPS`), and explicitly deferred the fix to "its own follow-up" rather than fixing it in-place, since S-CIGATE-2's own scope was the runtime evaluator, not `S-CIGATE-1`'s spec text. | The blockquote-callout "revision notice" pattern for recording a superseded decision without deleting it (`> **v2.0 revision notice:** ...`) — directly reused by this story for its own `S-CIGATE-1` corrections. | Flagging a spec/reality contradiction prominently in a *different* story's file (rather than fixing it at the source) keeps the fixing story's own scope clean, but only works if the flagged follow-up is actually filed promptly — this story is that follow-up, filed the same day it was flagged is not the case here (2026-08-06 for both), avoiding the drift-compounding risk called out in the Problem Statement. |

_Populated from a direct read of `S-CIGATE-1`, `S-MUTATION-CI-TIMEOUT-1`'s STORY-INDEX.md
manifest row (story file recorded as "TBD" per STATE.md — its PR #567 and commit `3b122a8f`
were read directly via `git log` instead), and `S-CIGATE-2`'s "Blocking-Adjacent Risk" section
and "Previous Story Intelligence" table, which independently documents the same contradiction
from the other side._

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| Corrections are additive blockquote callouts, never silent deletions or rewrites of the original text | This repo's decision-record convention, per `S-CIGATE-2`'s own "v2.0 revision notice" precedent and per this story's explicit brief instruction | Manual review of the diff to `S-CIGATE-1-ci-gate-aggregator.md`: the original AC-003 text, Architecture Compliance Rules row, and Out-of-Scope bullet must all still be present verbatim, with a correction appended/prepended, not replaced |
| Dead citations are corrected to the current name with a rename note, not silently swapped | Existing convention already used elsewhere in the same file (`test_ci_gate_job_exists_with_required_metadata` rename note) | Manual review: all three `test_ci_gate_excludes_pr_only_jobs` occurrences carry a `(renamed to test_ci_gate_excludes_advisory_and_secret_scan_jobs by PR #567)`-style note |
| No `src/`, `tests/`, `.github/`, or `.factory/specs/` files are touched | Explicit scope boundary for this story (spec-only) | Manual review of `git diff --stat`: only `.factory/stories/S-CIGATE-1-ci-gate-aggregator.md` and this story's own new file appear |

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| N/A | N/A | This is a documentation-only correction to a Markdown story file; no library, framework, or dependency is introduced, upgraded, or removed |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `.factory/stories/S-CIGATE-1-ci-gate-aggregator.md` | modify | Add correction blockquotes to AC-003, its Architecture Compliance Rules row, and its Out-of-Scope bullet; correct the three dead `test_ci_gate_excludes_pr_only_jobs` citations; correct the two stale "six `needs` jobs" job-count claims |
| `.factory/stories/S-CIGATE-4-reconcile-ac003-mutants-prohibition.md` | create | This story file itself — the decision record for the correction |
| `.factory/stories/STORY-INDEX.md` | modify | Register this story (and its sibling `S-CIGATE-3`) per the standard registration convention |

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|-----------------|----------------|
| Correction blockquotes | `.factory/stories/S-CIGATE-1-ci-gate-aggregator.md` | N/A (prose documentation) | Not code; a governance/decision-record edit to a spec file |
| This story's own record | `.factory/stories/S-CIGATE-4-reconcile-ac003-mutants-prohibition.md` | N/A (prose documentation) | Not code; the decision record itself |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `.factory/stories/S-CIGATE-1-ci-gate-aggregator.md` | N/A (prose documentation) | Not code; no purity classification applies |
| `.factory/stories/S-CIGATE-4-reconcile-ac003-mutants-prohibition.md` | N/A (prose documentation) | Not code; no purity classification applies |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~2,800 |
| `S-CIGATE-1-ci-gate-aggregator.md` (full read + edit) | ~3,500 |
| `S-CIGATE-2-skipped-status-false-green.md` (cross-reference read) | ~9,000 |
| `tests/ci_gate_completeness.rs` (targeted grep, not full read) | ~500 |
| **Total** | **~15,800** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~8%** |

Well within budget. No splitting required — this is an xsmall, single-file correction.

## Acceptance Criteria

### AC-001 — AC-003's obsolete prohibition is corrected in place with a decision-record blockquote, not deleted

`S-CIGATE-1-ci-gate-aggregator.md`'s AC-003 gains a blockquote callout, positioned immediately
after its heading, stating: the "`security` and `mutants` MUST NOT appear in `ci-gate.needs`"
clause is superseded — `mutants` is required to remain in `ci-gate.needs` per
`S-MUTATION-CI-TIMEOUT-1` (PR #567) and `S-CIGATE-2`'s Option C fix (PR #671, in-flight) — and
recording WHY: the original reasoning (an untrusted `skipped` result would poison the gate) was
correct at authoring time, and became obsolete when `S-CIGATE-2`'s fail-closed evaluator with a
restrictive, named `ALLOWED_SKIPS` allowlist made a `mutants`-reports-`skipped` result a
deliberate, safe exception rather than an accidental gap. The original AC-003 text is
preserved verbatim below or above the callout — not rewritten, not deleted.

### AC-002 — The Architecture Compliance Rules row and Out-of-Scope bullet receive matching, shorter correction pointers

The "PR-only jobs excluded from `needs`" row in `S-CIGATE-1`'s Architecture Compliance Rules
table, and the "`security` and `mutants` joining `ci-gate.needs`" bullet in its Out-of-Scope
section, each gain a short correction note pointing to AC-003's full blockquote (avoiding
triplicated long-form explanations) rather than being left silently contradicting shipped
reality.

### AC-003 — Three dead `test_ci_gate_excludes_pr_only_jobs` citations are corrected with a rename note

All three occurrences of `test_ci_gate_excludes_pr_only_jobs` in `S-CIGATE-1-ci-gate-aggregator.md`
(AC-003's "Pinned by" line, AC-004's numbered list item 3, and the Test Coverage Summary table
row 4) are corrected to name the current function, `test_ci_gate_excludes_advisory_and_secret_scan_jobs`,
with a parenthetical rename note citing PR #567, mirroring this file's own existing rename-note
convention for `test_ci_gate_job_exists_with_required_metadata`.

### AC-004 — The two stale "six `needs` jobs" job-count claims are corrected to eight

The Architecture Compliance Rules table's "all six `needs` jobs run unconditionally" claim and
AC-002's "passes when all six succeed" title are corrected to state "eight," with a
parenthetical noting the two jobs added since S-CIGATE-1's authoring
(`check-signing-workflow-injection` per `S-FORK-OPS-SIGN-1`; `mutants` per
`S-MUTATION-CI-TIMEOUT-1`). The unrelated "six test functions" language in AC-004/Test
Coverage Summary (referring to the test-file's originally-specified function count, not the
job list) is left uncorrected, since it was accurate at authoring time and is not part of the
contradiction this story exists to fix.

## Out of Scope (explicit)

- **Any change to `src/`, `tests/`, `.github/workflows/ci.yml`, or `.factory/specs/`** — this
  story is strictly a correction to one story file's prose (plus its own new file and the
  STORY-INDEX.md registration). No code, test, or CI-workflow change is made or implied.
- **Merging or otherwise acting on the frozen `fix/ci-gate-skipped-false-green` branch /
  `.worktrees/S-CIGATE-2`** — that branch and worktree are explicitly out of scope for this
  story and are not touched.
- **Updating `S-CIGATE-2-skipped-status-false-green.md` itself** — its own "Blocking-Adjacent
  Risk" section already correctly describes the contradiction from its side and does not need
  correction; only `S-CIGATE-1`'s stale prohibition needed fixing.
- **Marking `S-CIGATE-1`'s overall `status:` field as anything other than what it already is**
  — this story corrects specific stale clauses within the file; it does not re-adjudicate
  `S-CIGATE-1`'s broader lifecycle status, which is a separate decision outside this story's
  narrow scope.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A future reader skims only AC-003's original text and misses the correction blockquote | Mitigated by positioning the blockquote immediately after the AC-003 heading (before the original text), matching `S-CIGATE-2`'s own "v2.0 revision notice" placement, which is the first thing a reader of that AC encounters. |
| EC-002 | The `S-CIGATE-2`/PR #671 fix is later reverted or its `ALLOWED_SKIPS` design changes | Out of scope for this story to anticipate — if that happens, a further correction to both `S-CIGATE-1` and this story's own record would be warranted at that time, following the same additive-correction convention rather than deleting this story's record. |

## Test Coverage Summary

| # | Assertion | File | AC |
|---|-----------|------|-----|
| 1 | AC-003 blockquote present, original text preserved | `.factory/stories/S-CIGATE-1-ci-gate-aggregator.md` (manual review) | AC-001 |
| 2 | Architecture Compliance Rules row + Out-of-Scope bullet carry correction pointers | `.factory/stories/S-CIGATE-1-ci-gate-aggregator.md` (manual review) | AC-002 |
| 3 | Zero remaining occurrences of the bare dead citation `test_ci_gate_excludes_pr_only_jobs` without a rename note | `.factory/stories/S-CIGATE-1-ci-gate-aggregator.md` (grep) | AC-003 |
| 4 | Zero remaining unqualified "six `needs` jobs" job-count claims | `.factory/stories/S-CIGATE-1-ci-gate-aggregator.md` (grep) | AC-004 |

No automated test exists or is added for this story — consistent with `S-CIGATE-1` AC-005's
own precedent of "source-text inspection on the PR diff (no automated test — documentation-only
assertion)" for prose-only changes.

## Dependency Analysis

**depends_on: []** — standalone; does not require `S-CIGATE-2`'s PR #671 to merge first, since
this story only corrects prose describing what PR #671 will do, not the code itself.

**blocks: []** — no story depends on this one, though `S-CIGATE-3` (the real-YAML-parser
follow-up) references this same file family and benefits from `S-CIGATE-1` no longer carrying
a live contradiction.

## Tasks

1. Read `S-CIGATE-1-ci-gate-aggregator.md` in full (already done for this story's authoring;
   re-confirm no further drift at execution time if this story is dispatched separately from
   its authoring).
2. Add the AC-003 correction blockquote (AC-001).
3. Add the shorter correction pointers to the Architecture Compliance Rules row and
   Out-of-Scope bullet (AC-002).
4. Correct the three dead `test_ci_gate_excludes_pr_only_jobs` citations with rename notes
   (AC-003).
5. Correct the two stale "six `needs` jobs" job-count claims to "eight" with a parenthetical
   (AC-004).
6. Register both this story and `S-CIGATE-3` in `STORY-INDEX.md` per the standard convention.
7. Run `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` — both must
   exit 0 (no BCs touched).

## Story Points and Effort

**1 story point** (xsmall). This is a same-day, single-file prose correction with no code,
test, or CI changes — sized deliberately small per the brief's explicit instruction, and
delivered immediately (status: `done`) rather than queued, since the risk being mitigated (a
stale, actively-misleading open story) is live for as long as it remains uncorrected.

Risk: LOW — prose-only change to a non-code file; no build, test, or CI surface is affected.
