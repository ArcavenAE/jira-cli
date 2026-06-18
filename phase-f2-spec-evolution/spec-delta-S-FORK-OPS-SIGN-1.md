---
document_type: phase-f2-spec-delta
story: S-FORK-OPS-SIGN-1
feature: fork-ops-signing-hardening
created: 2026-06-18
revised: 2026-06-18
revision_reason: FINDINGS-REQUIRE-ITERATION (round 7) — three F5 adversarial findings resolved: (C-2) scope-rule internal inconsistency — job enumeration was a strictly smaller set than the behavioral rule; resolved by making criteria (a)/(b)/(c) behavioral rule authoritative with explicit prohibition on hardcoded job-name lists, relegating named jobs to illustrative examples; (H-1 / default-deny) replaced high-risk-list framing with a clean DEFAULT-DENY rule for run: bodies — ALL non-allowlisted expressions including steps.*/needs.* outputs MUST be env-bound regardless of server-generated provenance, with explicit rationale that cross-job derivation cannot be reliably traced; matrix.* and runner.* explicitly carved out as safe (author-controlled, not attacker-controlled); (M-1) guard fail-closed requirements added as requirement 5 — non-zero exit on YAML parse error, missing YAML library, unreadable file, or zero in-scope jobs detected (positive-coverage job count assertion is the enforcement mechanism for the zero-jobs case). Prior round 6 changes (allowlist addition, three-scope-alignment) are preserved unchanged.
f1_outcome: APPROVED
---

# Phase F2 Spec Delta: S-FORK-OPS-SIGN-1 (Fork-Ops Signing Hardening)

## Summary

F1 delta analysis (APPROVED) determined that zero new BCs, NFRs, or VPs are
needed for this infrastructure bug-fix story. The sole spec change is an
engineering-spec delta to `docs/specs/fork-friendly-release-ops.md`.

This delta was revised after adversarial review passes (FINDINGS-REQUIRE-ITERATION)
to correct the atomic-tag mechanism, broaden the CWE-77 injection rule, close
the dangerous-sink loophole, upgrade the CI regression guard from optional to
REQUIRED (with F6 as the implementing phase), and add affected workflow files
to the implementation-scope table. A third round addressed placement and
convergence of the retry loop, tightened the CI guard requirements to be
YAML-structure-aware, corrected the allowlist rationale, expanded the
dangerous-sink and high-risk lists to non-exhaustive, scoped the git push
prohibition precisely to the alpha-sign job, required that the guard not flag
env:-bound values, and added a mandatory negative-fixture F6 sub-deliverable.
A fourth round (grounded against actual workflow code) inverted the
`--cleanup-tag` ordering to eliminate a self-defeating TOCTOU contradiction
(purge MUST precede the atomic reservation), corrected the homebrew reconciliation
paragraph to accurately describe the code (HOMEBREW_TAP_REPO is env-bound;
github.repository is accessed as the runner env var ${GITHUB_REPOSITORY} —
neither is inlined as `${{ }}` in a run-block), broadened the F5 scan scope to
name backfill-release.yml's signing job explicitly alongside sign-and-publish.yml,
and recorded the empty/missing head_branch latent defect as an out-of-scope
follow-up observation.

A fifth round resolved a HIGH composition gap: the "Generate alpha version" step
control flow had been specified piecewise across four normative paragraphs with
no single reconciled view. The unconditional pre-reservation
`gh release delete --cleanup-tag` purge was identified as itself TOCTOU-class
(it can delete a ref a concurrent run just reserved) and is DROPPED entirely.
The four paragraphs were replaced with one worked end-to-end control-flow block
(numbered sequence covering seed hint → atomic reservation → retry loop → export
$TAG) that an F4 implementer can follow without reassembly. Orphan cleanup from
prior failed runs is noted as a separate out-of-scope concern (future housekeeping
story). [Process-gap lesson:] multi-step atomic sequences must be specified as
one worked control-flow block, not as piecewise normative paragraphs.

A sixth round resolved a MEDIUM spec self-consistency gap: the normative CWE-77
scope header covered all jobs with secrets OR `contents: write`, but the F5 scan
scope and CI-guard scope only named signing jobs. This left backfill-release.yml's
`release` job — which declares `permissions: contents: write` and inlines
`${{ github.repository }}` in run-blocks — inside the normative scope but outside
both verification mechanisms. Resolved by two complementary changes: (1) adding
`github.repository` and `github.repository_owner` to the format-constrained
allowlist (GitHub naming rules prohibit shell metacharacters in repo/owner slugs,
making existing inline usage compliant without an env-binding refactor); (2)
restating both the F5 scan scope and the CI-guard scope as covering every job with
secrets OR `contents: write` across both files, naming the `release` job explicitly.
The three scope statements (normative header, F5 scan, CI guard) are now mutually
consistent. The atomic-tag control-flow block was NOT modified.

A seventh round resolved three F5 adversarial findings: (C-2) scope-rule internal
inconsistency — the section header correctly stated the behavioral rule (secrets OR
`contents: write`), but the CI guard and F5 scan text also contained a hardcoded job
enumeration that was a strictly smaller set; an implementer who hardcoded that
enumeration missed the `build` and `alpha-build` jobs. Resolved by restructuring the
scope header into explicit criteria (a)/(b)/(c), marking the job names as illustrative
examples, and adding an explicit prohibition on hardcoded job-name lists in guard
implementations. (H-1 / default-deny) the "high-risk list" framing was replaced with a
clean DEFAULT-DENY rule: ALL non-allowlisted context expressions in `run:` bodies MUST
be env-bound, including `steps.*.outputs.*` and `needs.*.outputs.*` regardless of
apparent provenance — the prior exemption for "server-generated" step outputs was
unsound because derivation chains (e.g. `stable-sign.outputs.tag` ← `head_branch`)
cannot be reliably traced by a guard. `matrix.*` and `runner.*` are explicitly
classified as safe (author/platform-controlled, not attacker-controlled) so the guard
spec is unambiguous about their treatment. (M-1) four fail-closed requirements were
added to the CI guard as requirement 5: non-zero exit on YAML parse error, missing YAML
library, unreadable workflow file, and zero in-scope jobs found (zero jobs is a
sentinel for broken scope-detection or silent job rename — the positive-coverage job
count assertion from requirement 3 is the enforcement mechanism).

Supersedes the `git push` tag mechanism described in the F1 delta-analysis HIGH-2.

**F6 scope expansion:** The required CI regression guard (see Verification Delta
below) is a NEW in-scope deliverable for this story. It expands F6 beyond the
original F5 scan. The orchestrator must surface this at the human gate before
proceeding to F6.

---

## PRD / BC Delta

**NONE.**

No existing BC-S.SS.NNN identifiers cover signing workflow behavior. The items
being fixed (CWE-77 shell injection, TOCTOU race, predictable temp paths,
missing pipefail) are CI/CD workflow security requirements, not `jr` product
behavioral contracts. No new BCs are appropriate for CI/CD workflow
implementation details. No existing BCs are modified.

---

## NFR Delta

**NONE.**

The existing NFR catalog was reviewed for supply-chain, release, and security
NFRs that might reference signing workflow behavior. No such NFRs exist in the
catalog — the catalog covers `jr` binary non-functional requirements (latency,
reliability, output format), not CI/CD workflow security posture. These
hardening requirements are engineering-implementation constraints on the
workflow files themselves, not product NFRs.

No new NFRs are added. No existing NFRs are modified.

---

## Architecture / Engineering-Spec Delta

**File modified:** `.worktrees/S-FORK-OPS-SIGN-1/docs/specs/fork-friendly-release-ops.md`
(story worktree path; maps to `docs/specs/fork-friendly-release-ops.md` on
the `fix/fork-ops-sign-hardening` branch)

**Section modified:** `## Security constraints (sign-and-publish.yml / backfill-release.yml)`

The section documents four hardening requirements (revised through three
adversarial rounds):

1. **No inline context data in shell run-blocks (CWE-77)** — Broadened from
   `github.event.*`-only to a positive allowlist model. The allowlist rationale
   was corrected: `github.sha`/`run_id`/`run_number` are safe because they are
   FORMAT-CONSTRAINED (`[0-9a-f]`/integers), not because they have "no
   user-controlled content" — `github.sha` provenance can be attacker-influenced,
   but its hex format makes it safe. The allowlist is stated as the ONLY
   exception set; everything not on it is high-risk by default. The high-risk
   list was made NON-EXHAUSTIVE and expanded to include `github.ref`,
   `github.base_ref`, `github.actor`, `github.triggering_actor` alongside the
   prior entries. The dangerous-sink list was made NON-EXHAUSTIVE and expanded
   to include arithmetic context `$(( ))`, indirect expansion `${!var}`,
   `source`/`.` of attacker-influenced content, here-strings/here-docs feeding
   a parser, and re-execution via `xargs sh`/`printf -v`-then-execute, with the
   governing principle stated: the bound value must never reach ANY context that
   re-parses or re-executes it. A guard-scope note was added: the CI regression
   guard MUST NOT flag context expansions in `env:`, `with:`, or `if:` keys —
   ONLY those textually inside a `run:` script body; the canonical-repo ci-gate
   MUST pass with the env-bound HEAD_BRANCH example present. Round 6: added
   `github.repository` and `github.repository_owner` to the allowlist with the
   rationale that GitHub naming rules constrain repo/owner slugs to
   `[A-Za-z0-9._-]` (plus a single `/` separator) — no shell metacharacters
   possible. This makes existing `${{ github.repository }}` inline usage in the
   `release` and homebrew jobs compliant without requiring an env-binding refactor.
   The F5 scan scope and CI-guard scope were restated to cover every job with
   secrets OR `contents: write` across both workflow files, naming
   backfill-release.yml's `release` job explicitly alongside the signing jobs,
   so the three scope statements (normative header, F5 scan, CI guard) are now
   mutually consistent. Round 7: replaced the "high-risk list" framing with a
   clean DEFAULT-DENY rule — EVERY non-allowlisted context expression in a `run:`
   body MUST be env-bound. `steps.*.outputs.*` and `needs.*.outputs.*` are
   explicitly included with rationale (cross-job derivation laundering cannot be
   reliably traced). `matrix.*` and `runner.*` explicitly classified as safe
   (author/platform-controlled) with rationale, so guard treatment is spec-grounded.

2. **Atomic alpha-tag creation (no TOCTOU)** — The entire "Generate alpha
   version" step is now specified as ONE worked end-to-end control-flow block
   (round 5), replacing the four piecewise normative paragraphs that left the
   purge/retry-loop interaction unreconciled. The unconditional
   `gh release delete --cleanup-tag` pre-reservation purge is DROPPED: it
   targeted only the seed name (e.g. `.1`) and was itself TOCTOU-class — it
   could delete a ref that a concurrent run just reserved. With atomic
   reservation and bounded retry, a pre-existing ref from a prior failed run
   simply causes a 422 and the loop walks to the next sequence number
   (harmless gap; correctness is guaranteed by the reservation loop, not by
   pre-cleaning). Orphan cleanup is noted as a separate out-of-scope concern.
   The complete control flow: (1) bind COMMIT_SHA and GH_TOKEN from `env:`;
   (2) compute seed hint via `git ls-remote | wc -l` (a starting hint only —
   correctness does NOT depend on its accuracy); (3) attempt atomic reservation
   via `gh api POST .../git/refs`; (4) on 422, increment SEQ from the just-rejected
   value (never re-count), retry, bound 10, `exit 1` with diagnostic on exhaustion
   (silent success / `|| true` / swallowed skips are prohibited); (5) export
   `$TAG` via `$GITHUB_OUTPUT`. Nothing after step 5 may delete or recreate the
   reserved ref. Placement (BEFORE certificate import/signing/notarization/`gh
   release create`) and the `git push` prohibition (scoped to the `alpha-sign`
   job's tag-creation only) are unchanged from prior rounds. The homebrew
   reconciliation (HOMEBREW_TAP_REPO env-bound; github.repository via
   ${GITHUB_REPOSITORY}) is unchanged from round 4.

3. **Required CI regression guard (NEW — expands F6 scope)** — Upgraded from
   "recommended" to REQUIRED. The guard requirements were strengthened: (a)
   the `run:` block extraction MUST be YAML-structure-aware (parse the document
   and iterate `jobs.*.steps[].run`, or use a workflow-security linter such as
   zizmor/actionlint that models run-block boundaries); a naive line-oriented
   grep is INSUFFICIENT and explicitly prohibited; (b) scope covers all `run:`
   blocks reachable from in-scope jobs (computed via criteria a/b/c), including
   local composite actions they invoke — NOT from a hardcoded job-name list; (c)
   the positive-coverage assertion MUST report the COUNT OF JOBS classified
   in-scope AND total `${{ }}` occurrences scanned vs. classified so a broken
   scope-detection heuristic (zero in-scope jobs) is immediately visible. `matrix.*`
   and `runner.*` inline expressions MUST NOT be flagged. The guard must be wired
   into CI via `ci-gate.needs`. Round 7 added requirement 5 (fail-closed): the
   guard MUST exit non-zero on (a) YAML parse error, (b) missing YAML library,
   (c) unreadable workflow file, (d) zero in-scope jobs found in either file —
   zero is treated as a guard failure, not a clean pass. A REQUIRED negative-fixture
   sub-deliverable was added for F6: the guard must be exercised against a
   deliberately-injected violation fixture (a sample `run:` block with an inline
   `${{ github.event.* }}`) and confirmed to reject it — proving the detector
   is not a no-op (prevents TD-VSDD-057 false-green class).

4. **Verify-step shell conventions (CWE-377/362, CWE-390)** — Unchanged from
   round 2: `mktemp` + `trap '...' EXIT` cleanup for temp files (predictable
   `/tmp/*.out` paths prohibited), temp-file reuse across loop iterations, and
   `set -eo pipefail` on all verification steps. The `grep ... || { exit 1; }`
   guard MUST NOT be removed as redundant — it checks pattern presence that
   pipefail alone does not enforce.

The section is placed immediately before "## Known limitations", consistent
with the doc's existing structure. The surrounding content is unchanged.

---

## Verification Delta

**New VPs: NONE.**

No VPs cover CI/CD workflow files. The verification mechanism for these
requirements is:

- **F5 adversarial scan** (primary): scan all `${{ }}` inline expansions in
  every job meeting criteria (a)/(b)/(c) across BOTH workflow files — scope
  computed by inspection, not hardcoded job-name list; current illustrative
  examples include `stable-sign`, `alpha-sign` in `sign-and-publish.yml` and
  `sign`, `release` in `backfill-release.yml`; normative rule, F5 scan scope,
  and CI-guard scope now all aligned on the same behavioral criteria; the
  `release` job's inline `${{ github.repository }}` is compliant via the
  allowlist addition; verify retry loop
  has a bounded maximum (10 attempts) and exits non-zero on exhaustion; confirm
  `mktemp` temp files are cleaned up on error paths and not created per-loop-iteration;
  verify `pipefail` interacts correctly with existing `|| { ...; exit 1; }` patterns;
  verify `gh api` (not `git push`) is used for tag creation; verify SHA is env-bound
  per CWE-77 rule; verify NO unconditional `gh release delete --cleanup-tag` purge
  precedes or is embedded in the atomic reservation sequence (the purge is dropped —
  confirm its absence); verify sequence-number gaps are accepted (no per-iteration
  purge-then-reserve pattern).

- **F6 CI guard (REQUIRED, in-scope for S-FORK-OPS-SIGN-1):** Implement the
  required workflow-lint check. Must be YAML-structure-aware (not line-oriented
  grep), compute in-scope jobs by inspecting criteria (a)/(b)/(c) — NOT a
  hardcoded job-name list — cover all `run:` blocks reachable from those jobs
  including composite actions, NOT flag `env:`/`with:`/`if:` keys or
  `matrix.*`/`runner.*` inline expressions, emit a positive-coverage assertion
  reporting COUNT OF IN-SCOPE JOBS AND total `${{ }}` occurrences scanned vs.
  classified, be wired into `ci-gate.needs`, and fail closed (non-zero) on YAML
  parse error / missing library / unreadable file / zero in-scope jobs found.
  This is a new deliverable that expands F6 scope — flagged for the human gate.
  **Required F6 sub-deliverable:** exercise the guard against a
  deliberately-injected violation fixture (a sample `run:` block with an inline
  `${{ github.event.* }}`) and confirm it returns non-zero. This proves the
  detector is not a no-op and prevents the TD-VSDD-057 false-green class.

### Out-of-scope observations (noted for follow-up, not blocking)

**Empty/missing head_branch:** Neither spec nor workflow guards against an empty
or missing `github.event.workflow_run.head_branch` value (leading to `TAG=""` or
`VERSION=""`). This is a pre-existing latent defect outside this delta's
CWE-77/TOCTOU scope. A future story should add an explicit early guard (e.g.
`if [ -z "$HEAD_BRANCH" ]; then echo "::error::head_branch is empty"; exit 1;
fi`) before the tag-generation logic. This story's scope is not expanded to
cover it.

**Alpha orphan cleanup:** Orphaned alpha tags and releases from prior failed runs
(sequence gaps) are NOT cleaned by the "Generate alpha version" step. A future
housekeeping story should address this (e.g. a scheduled job that deletes alpha
tags/releases older than N days with no associated binary assets). Sequence-number
gaps in the alpha channel are acceptable and harmless.

**[Process-gap lesson] — Multi-step atomic sequences must be specified as one
worked control-flow block, not piecewise normative paragraphs.** This delta went
through four rounds before a round-5 adversary identified that the "Generate alpha
version" step's behavior had been described in four separate paragraphs, leaving
the purge/retry-loop interaction unreconciled. Future specs for any step that
involves: (a) a seed/hint computation, (b) an atomic server-side operation, and
(c) a bounded retry loop MUST present all three phases as one numbered
control-flow block in a single location. Piecewise prose that each describe part
of the sequence without a unified view MUST be refactored before the delta is
considered complete.

---

## Spec Version Bump Recommendation

**PATCH** — engineering-spec hardening and clarification with no behavioral
change to the `jr` binary, no new product contracts, and no API surface change.

---

## Dependency Graph Impact

**NONE.** No `.factory/specs/architecture/` files are touched. No module
decomposition, no dependency edges, no VP assignments, and no subsystem
classifications change. The architecture component graph is unaffected.

---

## Affected Files (Complete List for F2)

| File | Location | Change |
|------|----------|--------|
| `docs/specs/fork-friendly-release-ops.md` | Story worktree | Section modified (security constraints) |
| `.github/workflows/sign-and-publish.yml` | Story worktree | MODIFIED — implement atomic tag via `gh api`, CWE-77 env-binding, verify-step hygiene |
| `.github/workflows/backfill-release.yml` | Story worktree | MODIFIED — CWE-77 env-binding, verify-step hygiene |
| `scripts/check-signing-workflow-injection.sh` | Story worktree | NEW — required CI regression guard (F6 deliverable) |
| `spec-delta-S-FORK-OPS-SIGN-1.md` | `.factory/phase-f2-spec-evolution/` | This document (revised) |

All other spec files (BC files, NFR catalog, holdout scenarios, ADRs, all
`.factory/specs/architecture/` files, VP-INDEX.md, ARCH-INDEX.md) are
unchanged.
