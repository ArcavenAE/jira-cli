---
document_type: story
story_id: "S-FORK-OPS-SIGN-1"
title: "Fork-ops signing-workflow security & correctness hardening"
wave: feature-followup
status: draft
intent: bug-fix
feature_type: infrastructure
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
points: 5
priority: P2
tdd_mode: strict
estimated_effort: small
estimated_days: 1.5
target_module: ci
subsystems: []
depends_on: []
blocks: []
bc_anchors: []
bcs: []
# BC status: pending PO authorship
# No product BCs are added or modified by this story. The BC catalog count is unchanged.
# All items are CI/CD workflow security/correctness changes with zero src/ runtime impact.
# These hardening requirements are engineering-implementation constraints on workflow files,
# not product behavioral contracts. No existing BCs are modified.
# Do NOT add BCs to this story.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/phase-f2-spec-evolution/spec-delta-S-FORK-OPS-SIGN-1.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 6
assumption_validations: []
risk_mitigations: []
created: "2026-06-18"
version: "1.0"
last_updated: "2026-06-18"
changelog:
  - "1.0 (2026-06-18): Initial story decomposition — Phase F3."
breaking_change: false
lineage:
  - S-E2E-FORK-1  # fork-safe CI enablement (established fork-safe repo-variable gate pattern)
  - S-CIGATE-1    # CI gate aggregator (ci-gate.needs wiring convention)
drift_items:
  - FORK-OPS-SIGN-INJECTION
  - FORK-OPS-ALPHA-RACE
  - FORK-OPS-NIT-USECROSS-GUARD
  - FORK-OPS-NIT-TMP-PREDICTABLE
  - FORK-OPS-NIT-PIPEFAIL
files_modified:
  - .github/workflows/sign-and-publish.yml   # MODIFY — atomic tag via gh api, CWE-77 env-binding, verify-step hygiene
  - .github/workflows/backfill-release.yml   # MODIFY — CWE-77 env-binding (inputs.tag), verify-step hygiene
  - scripts/check-signing-workflow-injection.sh  # NEW — required YAML-aware CI regression guard
  - .github/workflows/ci.yml                 # MODIFY — wire check-signing-workflow-injection into ci-gate.needs
  - docs/specs/fork-friendly-release-ops.md  # MODIFY — security constraints section (already edited in F2 worktree)
---

# S-FORK-OPS-SIGN-1 — Fork-ops signing-workflow security & correctness hardening

## Source of Truth

F1 Delta Analysis: `.factory/phase-f1-delta-analysis/delta-analysis.md`
F2 Spec Delta: `.factory/phase-f2-spec-evolution/spec-delta-S-FORK-OPS-SIGN-1.md`
Converged spec section: `docs/specs/fork-friendly-release-ops.md` § "Security constraints (sign-and-publish.yml / backfill-release.yml)"
Blocking decision: DEC-104 (fork signing enablement)

## Behavioral Contracts

No product BCs are added or modified by this story. The BC catalog count is unchanged.

**Why no BC anchor:** All five drift items (FORK-OPS-SIGN-INJECTION, FORK-OPS-ALPHA-RACE,
FORK-OPS-NIT-USECROSS-GUARD, FORK-OPS-NIT-TMP-PREDICTABLE, FORK-OPS-NIT-PIPEFAIL) are
CI/CD workflow security and correctness changes. They do not modify `src/` production runtime
behavior, nor do they change any externally observable postcondition, precondition, or invariant
of any `jr` domain entity. Both workflow files are INERT in the canonical repo (`vars.SIGNING_ENABLED`
is unset) — the fixes unblock downstream fork signing without affecting any canonical-repo CI job.

This story traces its ACs to the named drift items, following the same convention used by
S-CIGATE-1 (CI-infra story with no product BC surface) and S-TESTTOOL-1.

## Story Narrative

As a fork maintainer enabling `SIGNING_ENABLED=true`,
I want the signing workflows free of CWE-77 shell injection, TOCTOU race conditions, predictable
temp paths, missing pipefail, and a missing defensive rustup step,
so that the signing workflows are safe to enable without risk of secret exfiltration via crafted
branch names or tag reservation races.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~5,000 |
| `.github/workflows/sign-and-publish.yml` (~450 LOC) | ~5,800 |
| `.github/workflows/backfill-release.yml` (~200 LOC) | ~2,600 |
| `.github/workflows/ci.yml` (ci-gate.needs section only, ~30 LOC) | ~400 |
| `docs/specs/fork-friendly-release-ops.md` § Security constraints (~120 LOC) | ~1,500 |
| F2 spec delta (verification delta, affected files table) | ~2,000 |
| Tool outputs (yamllint / grep verification commands) | ~500 |
| **Total** | **~17,800** |

Well within 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**S-E2E-FORK-1** established the fork-safe repo-variable gate pattern (`vars.JR_E2E_ENABLED`)
and documented the fail-safe default-deny approach for CI opt-in features. The `vars.SIGNING_ENABLED`
gate already follows this pattern; this story does NOT change whether signing is enabled.

**S-CIGATE-1** established the `ci-gate.needs` wiring convention. New required CI checks MUST
be added to `ci-gate.needs` in `ci.yml`, never wired directly into branch protection (prevents
the matrix-rename fragility class documented in DEC-096/DEC-097). This story follows that
convention for the new `check-signing-workflow-injection` script.

**N/A — no prior story has modified `sign-and-publish.yml` or `backfill-release.yml`** for
security hardening. The verify steps (predictable `/tmp/*.out` paths, missing pipefail) were
introduced by PR #530 (commit 99f212d); this story is the first hardening pass.

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| CI gate wiring | CLAUDE.md "CI Gate" convention + S-CIGATE-1 | New required CI checks go into `ci-gate.needs` in `.github/workflows/ci.yml`, NEVER directly into branch protection. The job name "CI Gate" is THE single required branch-protection status. Adding the injection-check script to `ci-gate.needs` is the correct and ONLY wiring path. |
| SIGNING_ENABLED must remain unset | F2 spec delta §Summary + DEC-104 | The canonical repo has `vars.SIGNING_ENABLED` unset — signing stays INERT. This story MUST NOT set or change `SIGNING_ENABLED`. The fix unblocks forks; it does not enable signing in the canonical repo. |
| No inline `${{ }}` in run-blocks for high-risk context | `docs/specs/fork-friendly-release-ops.md` § "No inline context data in shell run-blocks" | Any context value NOT on the short allowlist (github.sha, github.run_id, github.run_number, github.repository, github.repository_owner) MUST be bound via step `env:` and referenced as a quoted shell variable. Allowlist is the ONLY exception set; everything else is high-risk by default. |
| Dangerous-sink prohibition | `docs/specs/fork-friendly-release-ops.md` § "Dangerous-sink rule" | Env-bound values MUST NOT be passed to eval, bash -c, backticks, unquoted substitution, $(( )), ${!var}, source/., here-strings/here-docs feeding a parser, or xargs sh/printf-v-then-execute. Double-quoting is insufficient at a dangerous sink. |
| Guard scope for CI injection check | F2 spec delta § "Required CI regression guard" | The CI guard MUST NOT flag `env:`, `with:`, or `if:` keys — ONLY textual content inside a `run:` script body. A correct step that binds HEAD_BRANCH in `env:` must pass the guard cleanly. |
| Atomic tag via gh api, not git push | F2 spec delta § "Atomic alpha-tag creation" | Tag reservation MUST use `gh api --method POST /repos/{owner}/{repo}/git/refs`. The prior `gh release delete --cleanup-tag` purge is DROPPED entirely. `git push` for tag creation in the alpha-sign job is PROHIBITED. |
| No src/ changes | F1 delta analysis §"Impact Assessment" | `src/` files are read-only for this story. |

## Library and Framework Requirements

No new library or framework dependencies. All changes are YAML workflow edits and a shell script.

| Item | Version / Constraint |
|------|---------------------|
| `gh` CLI | Already available on GitHub Actions macOS runners — no version pin needed |
| `mktemp` | POSIX utility — available on all macOS GitHub Actions runners |
| `yq` or `python3 -c 'import yaml'` | For YAML-structure-aware parsing in the CI guard script — `python3` is available on all GitHub Actions runners; `yq` may need installation. Prefer `python3` for zero-install-step dependency. |
| `zizmor` / `actionlint` | Optional alternative to custom Python parsing — if used, must be installed in the CI step. Check availability on runner before choosing. Custom Python parser is the safer default. |

Do not add any new entries to `Cargo.toml` or `deny.toml`. The guard script is a shell/Python
utility, not a Rust artifact.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|-------------|
| `.github/workflows/sign-and-publish.yml` | MODIFY | (1) `stable-sign` job "Extract release metadata" step: add `env: { HEAD_BRANCH: "${{ github.event.workflow_run.head_branch }}" }` and replace inline `${{ github.event.workflow_run.head_branch }}` with `"$HEAD_BRANCH"`. (2) `alpha-sign` job "Generate alpha version" step: replace count→delete→create logic with the 5-step atomic control-flow block from spec (seed hint → `gh api POST git/refs` → bounded retry 10 → export $TAG via $GITHUB_OUTPUT; remove `gh release delete --cleanup-tag` purge). (3) All 3 signature-verify steps (`alpha-sign` and `stable-sign`): `mktemp`+`trap ... EXIT` for temp files, `set -eo pipefail`. (4) `alpha-build` job: add defensive `rustup target add` step. (5) `backfill-release.yml` `sign` job "Verify" step: same `mktemp`+`trap`+`set -eo pipefail` hygiene. |
| `.github/workflows/backfill-release.yml` | MODIFY | Env-bind `${{ inputs.tag }}` occurrences in run-blocks that are inside jobs with secrets or `contents: write` scope. Apply `mktemp`+`trap`+`set -eo pipefail` to the `sign` job verify step (same hygiene as sign-and-publish.yml). |
| `scripts/check-signing-workflow-injection.sh` | CREATE | New YAML-structure-aware CI guard. See AC-005 for full requirements. Executable (`chmod +x`). |
| `.github/workflows/ci.yml` | MODIFY | Add `check-signing-workflow-injection` (or the job name that runs the script) to `ci-gate.needs`. Follow the existing `ci-gate.needs` array convention exactly. |
| `docs/specs/fork-friendly-release-ops.md` | MODIFY | The security constraints section has already been edited in the F2 worktree (`.worktrees/S-FORK-OPS-SIGN-1/docs/specs/fork-friendly-release-ops.md`). The implementer must apply the same section content to the branch version. Read the worktree file to get the exact converged text. |

**Files NOT to create:** No new Rust source files, no new spec files, no new BC documents, no new ADR.

**Files NOT to touch:** `src/` (all production source), `.factory/specs/`, `Cargo.toml`,
`deny.toml`, all BC count surfaces (`bc-*.md` frontmatter, `BC-INDEX.md`, `CANONICAL-COUNTS.md`).

## Acceptance Criteria

### AC-001 (FORK-OPS-SIGN-INJECTION) — CWE-77 env-binding in stable-sign "Extract release metadata"

In `sign-and-publish.yml`, the `stable-sign` job's "Extract release metadata" step binds
`github.event.workflow_run.head_branch` via a step-level `env:` mapping and references it as
`"$HEAD_BRANCH"` inside the `run:` block. No inline `${{ github.event.workflow_run.head_branch }}`
appears in any `run:` block body in any job with secrets or `contents: write` in scope across
BOTH workflow files, with the exception of allowlisted values
(`github.sha`, `github.run_id`, `github.run_number`, `github.repository`, `github.repository_owner`).
`${{ inputs.tag }}` in `backfill-release.yml` run-blocks within signing-scope jobs is likewise
env-bound.

**Verifiable by:**
```bash
# Must produce zero output (no inline high-risk expansions in run-blocks)
grep -n 'github\.event\.' .github/workflows/sign-and-publish.yml \
  .github/workflows/backfill-release.yml | grep -v '^\s*env:' | grep -v '^\s*if:' | grep -v '^\s*with:'
# Expected: empty (any remaining hits are in env:/if:/with: keys only, not run: bodies)

# Confirm HEAD_BRANCH env-binding is present in stable-sign Extract step
grep -A3 'Extract release metadata' .github/workflows/sign-and-publish.yml | grep 'HEAD_BRANCH'
# Expected: matches
```

(traces to drift item FORK-OPS-SIGN-INJECTION — CWE-77 shell injection in stable-sign run-block)

---

### AC-002 (FORK-OPS-ALPHA-RACE) — Atomic alpha-tag creation via gh api with bounded retry

In `sign-and-publish.yml`, the `alpha-sign` job's "Generate alpha version" step implements the
5-step atomic control-flow block specified in `docs/specs/fork-friendly-release-ops.md`
§ "Atomic alpha-tag creation":

1. Inputs bound from `env:` (COMMIT_SHA from github.sha, GH_TOKEN from github.token)
2. Seed hint via `git ls-remote --tags origin "refs/tags/alpha-${DATE}.*" | wc -l`
3. Atomic reservation: `gh api --method POST /repos/{owner}/{repo}/git/refs -f ref=... -f sha=...`
   — HTTP 201 → success, HTTP 422 → retry, any other exit → `exit 1` with diagnostic
4. Retry loop: increment SEQ from just-rejected value (NEVER re-count remote tags), bounded to
   10 total attempts, `exit 1` with diagnostic on exhaustion (no silent success, no `|| true`)
5. Export `$TAG` via `echo "tag=$TAG" >> "$GITHUB_OUTPUT"`

The `gh release delete --cleanup-tag` purge is ABSENT from the step. Nothing after step 5
deletes or recreates the reserved ref. `git push` is NOT used for tag creation.

**Verifiable by:**
```bash
# Purge command must be absent
grep 'release delete' .github/workflows/sign-and-publish.yml
# Expected: empty (or only in unrelated jobs — confirm context manually)

# gh api POST refs must be present in alpha-sign Generate step
grep 'gh api' .github/workflows/sign-and-publish.yml | grep 'git/refs'
# Expected: matches

# Retry bound must be present
grep 'MAX_ATTEMPTS\|max_attempts' .github/workflows/sign-and-publish.yml
# Expected: matches (value 10)
```

(traces to drift item FORK-OPS-ALPHA-RACE — TOCTOU race on alpha tag creation)

---

### AC-003 (FORK-OPS-NIT-TMP-PREDICTABLE + FORK-OPS-NIT-PIPEFAIL) — Verify-step shell conventions in all 3 verify locations

All three signature-verify steps — `alpha-sign` "Verify signatures" and `stable-sign` "Verify
signatures" in `sign-and-publish.yml`; "Verify" in `backfill-release.yml` `sign` job — use:

- `CS_OUT=$(mktemp)` and `SPCTL_OUT=$(mktemp)` (or equivalent) instead of hardcoded `/tmp/cs.out`
  and `/tmp/spctl.out`
- `trap 'rm -f "$CS_OUT" "$SPCTL_OUT"' EXIT` (or equivalent trap) for cleanup on error paths
- `set -eo pipefail` (not just `set -e`)
- The existing `grep ... || { exit 1; }` pattern is RETAINED — it checks pattern presence
  that pipefail alone does not enforce and MUST NOT be removed as "redundant"

**Verifiable by:**
```bash
# No hardcoded /tmp/*.out paths remain
grep '/tmp/cs\.out\|/tmp/spctl\.out' .github/workflows/sign-and-publish.yml \
  .github/workflows/backfill-release.yml
# Expected: empty

# mktemp present in verify steps
grep 'mktemp' .github/workflows/sign-and-publish.yml .github/workflows/backfill-release.yml
# Expected: ≥3 matches (one per verify location)

# pipefail present in verify steps
grep 'pipefail' .github/workflows/sign-and-publish.yml .github/workflows/backfill-release.yml
# Expected: ≥3 matches
```

(traces to drift items FORK-OPS-NIT-TMP-PREDICTABLE — CWE-377/362 predictable temp paths;
FORK-OPS-NIT-PIPEFAIL — CWE-390 missing pipefail on pipe-to-tee verify steps)

---

### AC-004 (FORK-OPS-NIT-USECROSS-GUARD) — Defensive rustup target add step in alpha-build

The `alpha-build` job in `sign-and-publish.yml` includes a `rustup target add ${{ matrix.target }}`
step (unconditional, since `alpha-build` uses no `use_cross` matrix field and targets only native
macOS). This achieves defensive parity with the `release.yml` pattern at lines ~43–45.

**Verifiable by:**
```bash
grep -A2 'rustup target add' .github/workflows/sign-and-publish.yml
# Expected: matches a step inside the alpha-build job context
```

(traces to drift item FORK-OPS-NIT-USECROSS-GUARD — missing defensive rustup step in alpha-build)

---

### AC-005 (FORK-OPS-SIGN-INJECTION guard) — scripts/check-signing-workflow-injection.sh exists, is YAML-aware, and wired into ci-gate

`scripts/check-signing-workflow-injection.sh` exists, is executable, and meets ALL of these
requirements:

1. **YAML-structure-aware:** parses the YAML document and iterates `jobs.*.steps[].run` to
   extract `run:` block bodies. Naive line-oriented `grep` is insufficient and explicitly
   prohibited — the script must model run-block boundaries (e.g., use Python's `yaml` module,
   `yq`, `zizmor`, or `actionlint`).
2. **Scope:** scans every job with secrets OR `contents: write` in scope across BOTH
   `sign-and-publish.yml` and `backfill-release.yml`. Named jobs in scope: `stable-sign`,
   `alpha-sign` (sign-and-publish.yml); `sign`, `release` (backfill-release.yml).
3. **Detection:** FAILS (exits non-zero) on any inline `${{ }}` expansion of a high-risk
   context value (anything not on the allowlist: `github.sha`, `github.run_id`,
   `github.run_number`, `github.repository`, `github.repository_owner`) found textually inside
   a `run:` script body.
4. **Non-flagging scope:** MUST NOT flag context expansions in `env:`, `with:`, or `if:` YAML
   keys — only text inside `run:` script bodies. A correctly-written step with
   `env: { HEAD_BRANCH: "${{ github.event.workflow_run.head_branch }}" }` MUST pass cleanly.
5. **Positive-coverage assertion:** emits a summary reporting total `${{ }}` occurrences
   scanned vs. total classified (compliant / flagged). An unexpectedly-low scanned count is
   visible and actionable.
6. **Negative fixture:** the script includes (or a companion test exercises) a deliberately-injected
   violation — a sample `run:` block containing an inline `${{ github.event.inputs.foo }}` —
   and confirms the script returns non-zero against it. This proves the detector is not a no-op
   and prevents the TD-VSDD-057 false-green class.
7. **CI wiring:** `.github/workflows/ci.yml` `ci-gate.needs` array includes the job or step that
   runs `scripts/check-signing-workflow-injection.sh`. The job is NOT wired directly into branch
   protection — only into `ci-gate.needs` per the CI Gate convention.

**Verifiable by:**
```bash
# Script exists and is executable
ls -la scripts/check-signing-workflow-injection.sh
# Expected: -rwxr-xr-x ...

# Script passes on the current (hardened) workflow files
bash scripts/check-signing-workflow-injection.sh
# Expected: exit 0, coverage summary printed

# Script fails on the negative fixture (embedded in script or separate fixture file)
# Exact invocation depends on implementation — see script's own usage/help output
# Expected: exit non-zero when given a run-block with inline ${{ github.event.* }}

# ci-gate.needs wiring
grep 'check-signing' .github/workflows/ci.yml
# Expected: matches inside the ci-gate job's needs array
```

(traces to F2 Verification Delta § "F6 CI guard (REQUIRED)" — required YAML-aware injection check
wired into ci-gate)

---

### AC-006 (Integration) — canonical-repo ci-gate passes; SIGNING_ENABLED unchanged; no src/ changes

1. `cargo test` exits 0 (no Rust source touched; no new test failures introduced)
2. `cargo clippy -- -D warnings` exits 0
3. `cargo fmt --all -- --check` exits 0
4. `bash scripts/check-spec-counts.sh` exits 0 (no BC files touched; counts unchanged)
5. `bash scripts/check-bc-cumulative-counts.sh` exits 0 (no cumulative count drift)
6. `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0 (no BC files touched)
7. `bash scripts/check-signing-workflow-injection.sh` exits 0 against the hardened workflows
   (the guard MUST NOT flag the correctly env-bound `HEAD_BRANCH` step)
8. `vars.SIGNING_ENABLED` is NOT set in any committed file — signing remains INERT in the
   canonical repo. No workflow file enables signing unconditionally.

(traces to drift items collectively — end-to-end integration gate proving signing stays inert
and CI is green with all hardening in place)

---

## Tasks

### Item 1: `sign-and-publish.yml` — CWE-77 env-binding (stable-sign)

- [ ] Read `.github/workflows/sign-and-publish.yml` in full to understand current structure
- [ ] In the `stable-sign` job "Extract release metadata" step, add `env:` block binding
  `HEAD_BRANCH: ${{ github.event.workflow_run.head_branch }}`
- [ ] Replace inline `TAG="${{ github.event.workflow_run.head_branch }}"` with `TAG="$HEAD_BRANCH"`
- [ ] Scan all other run-blocks in `stable-sign` and `alpha-sign` for any remaining high-risk
  inline `${{ }}` expansions; env-bind any found outside the allowlist

### Item 2: `sign-and-publish.yml` — Atomic alpha-tag (alpha-sign "Generate alpha version")

- [ ] Read the complete "Generate alpha version" step current implementation (lines ~142–167 as
  of F1 analysis; line numbers may drift — search by step name)
- [ ] Read `docs/specs/fork-friendly-release-ops.md` § "Complete control flow for the Generate
  alpha version step" (the converged 5-step block in the F2 worktree) — this is the sole normative
  source; implement it exactly
- [ ] Remove the `gh release delete "$TAG" --cleanup-tag --yes 2>/dev/null || true` line
- [ ] Replace count→construct→delete logic with 5-step atomic flow:
  - Bind COMMIT_SHA and GH_TOKEN via `env:`
  - Seed hint via `git ls-remote | wc -l`
  - Atomic `gh api POST .../git/refs` with 201/422/other handling
  - Bounded retry (MAX_ATTEMPTS=10), incrementing SEQ from just-rejected value
  - Export via `$GITHUB_OUTPUT`
- [ ] Confirm no `git push` for tag creation in this step

### Item 3: `sign-and-publish.yml` and `backfill-release.yml` — Verify-step hygiene (3 locations)

- [ ] Locate all 3 "Verify signatures" / "Verify" steps across both files
- [ ] In each: replace `/tmp/cs.out` and `/tmp/spctl.out` with `$(mktemp)`
- [ ] Add `trap 'rm -f "$CS_OUT" "$SPCTL_OUT"' EXIT` (or named-var equivalent) in each
- [ ] Change `set -e` to `set -eo pipefail` in each
- [ ] Confirm `grep ... || { exit 1; }` guards are still present after edits

### Item 4: `sign-and-publish.yml` — Defensive rustup step in alpha-build

- [ ] Locate `alpha-build` job "Install Rust" step
- [ ] Add a step after the toolchain install: `rustup target add ${{ matrix.target }}`
  (unconditional — no `use_cross` guard needed for alpha-build)

### Item 5: `backfill-release.yml` — CWE-77 env-binding (inputs.tag)

- [ ] Read `.github/workflows/backfill-release.yml` in full
- [ ] Identify all `${{ inputs.tag }}` occurrences inside `run:` blocks of jobs with secrets
  or `contents: write` in scope
- [ ] Env-bind `RELEASE_TAG: ${{ inputs.tag }}` at the step level and replace inline references
  with `"$RELEASE_TAG"`

### Item 6: `scripts/check-signing-workflow-injection.sh` — Create YAML-aware guard (NEW)

- [ ] Create `scripts/check-signing-workflow-injection.sh` (executable)
- [ ] Implement YAML-structure-aware `run:` block extraction (Python yaml module recommended;
  `yq`/`zizmor`/`actionlint` acceptable if available without install step)
- [ ] Scope: both `sign-and-publish.yml` and `backfill-release.yml`, all jobs with secrets or
  `contents: write` (stable-sign, alpha-sign, sign, release)
- [ ] Detection logic: flag any `${{ X }}` in a `run:` body where X is not on the allowlist
  (`github.sha`, `github.run_id`, `github.run_number`, `github.repository`,
  `github.repository_owner`)
- [ ] Guard scope: MUST NOT flag `env:`, `with:`, or `if:` YAML keys
- [ ] Positive-coverage assertion: print "Scanned N run-blocks, M total ${{}} occurrences,
  K flagged" (or equivalent) — K=0 expected on hardened files
- [ ] Negative fixture: include a test mode or inline fixture that proves the detector fires
  on a `run:` body containing `${{ github.event.inputs.foo }}` (exits non-zero)
- [ ] Verify: `bash scripts/check-signing-workflow-injection.sh` exits 0 on the hardened files
- [ ] Verify: negative fixture invocation exits non-zero

### Item 7: `.github/workflows/ci.yml` — Wire guard into ci-gate.needs

- [ ] Read `.github/workflows/ci.yml` to locate the `ci-gate` job and its `needs:` array
- [ ] Add a new job (or step-only job) that runs `scripts/check-signing-workflow-injection.sh`
- [ ] Add that job's name to `ci-gate.needs`
- [ ] Do NOT add the check directly to branch protection — ONLY to `ci-gate.needs`

### Item 8: `docs/specs/fork-friendly-release-ops.md` — Apply F2 converged section

- [ ] Read `.worktrees/S-FORK-OPS-SIGN-1/docs/specs/fork-friendly-release-ops.md`
  § "Security constraints (sign-and-publish.yml / backfill-release.yml)" (lines ~97–end of section)
- [ ] Apply the same section text to the branch `docs/specs/fork-friendly-release-ops.md`
  (the section was edited in the worktree during F2; this item syncs it to the implementation branch)

### Integration checks (all must pass before PR)

- [ ] `cargo test` exits 0
- [ ] `cargo clippy -- -D warnings` exits 0
- [ ] `cargo fmt --all -- --check` exits 0
- [ ] `bash scripts/check-spec-counts.sh` exits 0
- [ ] `bash scripts/check-bc-cumulative-counts.sh` exits 0
- [ ] `bash scripts/check-bc-no-numeric-test-counts.sh` exits 0
- [ ] `bash scripts/check-signing-workflow-injection.sh` exits 0 (guard passes on hardened files)

## Out of Scope

**Empty/missing head_branch guard:** Neither spec nor workflow guards against an empty or
missing `github.event.workflow_run.head_branch` value (leading to `TAG=""` or `VERSION=""`).
This is a pre-existing latent defect outside this delta's CWE-77/TOCTOU scope. A future story
should add an explicit early guard (e.g. `if [ -z "$HEAD_BRANCH" ]; then echo "::error::head_branch
is empty"; exit 1; fi`) before tag-generation logic. This story's scope is NOT expanded to cover it.

**Alpha orphan-tag cleanup:** Orphaned alpha tags and releases from prior failed runs (sequence
gaps from the retry loop) are NOT cleaned by the "Generate alpha version" step. A future
housekeeping story should address this (e.g. a scheduled job that deletes alpha tags/releases
older than N days with no associated binary assets). Sequence-number gaps are acceptable and harmless.

**Enabling SIGNING_ENABLED in the canonical repo:** Out of scope. This story fixes the security
and correctness defects that BLOCKED DEC-104; DEC-104 itself (the decision to enable signing)
is a separate deliberate act.

**Any change to Cargo.toml, deny.toml, or src/:** No Rust source or dependency changes.

**New BCs, new VPs, new NFRs, new ADRs:** Not applicable to CI/CD workflow security hardening.

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `sign-and-publish.yml` | `.github/workflows/` | Effectful (GitHub Actions runner, Apple keychain, GitHub API) | CWE-77 fix and atomic-tag implementation live here |
| `backfill-release.yml` | `.github/workflows/` | Effectful (GitHub Actions runner, Apple keychain) | CWE-77 env-binding and verify-step hygiene |
| `check-signing-workflow-injection.sh` | `scripts/` | Pure (reads YAML, emits report, no side effects) | New YAML-structure-aware lint guard |
| `ci.yml` | `.github/workflows/` | Effectful (GitHub Actions ci-gate aggregation) | ci-gate.needs wiring only |
| `fork-friendly-release-ops.md` | `docs/specs/` | N/A (documentation) | Sync F2 converged security-constraints section to branch |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | F1 §HIGH-2 / F2 §Atomic alpha-tag | Two concurrent `develop` pushes trigger `alpha-sign` simultaneously — both observe the same ls-remote count | First runner to POST `git/refs` gets HTTP 201 and reserves the tag. Second runner gets HTTP 422 and increments SEQ, eventually reserving SEQ+1. No tag collision. Both runners produce distinct valid tags. |
| EC-002 | F2 §Atomic alpha-tag retry exhaustion | All 10 retry attempts return HTTP 422 (burst contention ceiling) | Step exits 1 with diagnostic message "alpha tag reservation failed after N attempts — burst contention ceiling exceeded; retry when concurrent workflow runs settle". No silent success, no `|| true`. |
| EC-003 | F2 §CI guard scope | The guard script is run against a workflow file where `env:` binding is present for `HEAD_BRANCH` — i.e., the correct fix is in place | Guard exits 0. The `env:` key line containing `${{ github.event.workflow_run.head_branch }}` is NOT inside a `run:` body; YAML-structure-aware parsing routes it to `env:` not `run:`, so it is not flagged. |
| EC-004 | F2 §Negative fixture requirement | Guard script is invoked against a fixture `run:` block containing inline `${{ github.event.inputs.foo }}` | Guard exits non-zero, emitting the flagged location. Proves the detector is not a no-op (prevents TD-VSDD-057 false-green). |
| EC-005 | F1 §LOW-2 / F2 §Verify-step conventions | `codesign` exits non-zero during signing verification | `set -eo pipefail` causes the pipe `codesign ... | tee` to propagate the non-zero exit. The `grep ... || { exit 1; }` guard additionally catches any case where codesign appeared to succeed but produced empty/unexpected output. Both guards are complementary; removing either is prohibited. |
| EC-006 | F2 §Allowlist rationale | `${{ github.repository }}` appears inline in a `run:` block in `backfill-release.yml` `release` job | This is ON the allowlist (`github.repository` is format-constrained to `[A-Za-z0-9._-]+/[A-Za-z0-9._-]+` per GitHub naming rules — no shell metacharacters possible). The guard MUST NOT flag it. Existing inline usage is compliant without env-binding refactor. |

## Dependency Analysis

**depends_on: []** — No story dependencies. This is a standalone infrastructure hardening story.
S-E2E-FORK-1 and S-CIGATE-1 are lineage ancestors (patterns followed) but are already MERGED;
there is no runtime dependency. Topological order: leaf node. Can be implemented in any wave.

**blocks: []** — No story depends on this story within the current story graph.
DEC-104 (signing enablement) is a DECISION, not a story — it is unblocked by this story but
not a tracked dependency in the story graph.

This is a LEAF story in the dependency graph.

---

## Story Points and Effort

**5 story points** (small/medium). Breakdown:
- Item 1 (CWE-77 env-binding, stable-sign): 0.5 SP
- Item 2 (Atomic alpha-tag implementation, alpha-sign): 2 SP (most complex item — control-flow
  must match spec exactly; retry loop + error handling)
- Item 3 (Verify-step hygiene, 3 locations): 0.5 SP
- Item 4 (Defensive rustup step): 0.25 SP
- Item 5 (CWE-77 env-binding, backfill inputs.tag): 0.5 SP
- Item 6 (YAML-aware CI guard script, with negative fixture): 1 SP
- Item 7 (ci-gate.needs wiring): 0.25 SP
- Item 8 (docs/specs sync from F2 worktree): 0 SP (copy, no authoring)

Risk: MEDIUM — the atomic retry loop requires careful implementation to match the spec exactly
(NEVER re-count, bounded to 10, exit-1 on exhaustion). The CI guard requires genuine
YAML-structure-awareness; a naive grep implementation is explicitly prohibited and will fail AC-005.
