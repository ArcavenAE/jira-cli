---
document_type: story
story_id: "S-MUTATION-CI-TIMEOUT-1"
title: "Retroactive F3 traceability — cargo-mutants CI gate promotion + absolute --timeout 240 ceiling + false-green guards (#567)"
wave: feature-followup
status: done
intent: ci-hardening
feature_type: infrastructure
mode: feature
scope: small
severity: LOW
trivial_scope: false
issue: ~567
points: 2
priority: P2
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0
target_module: ci-infrastructure
subsystems: []
depends_on: []
blocks: []
behavioral_contracts: []
# BC status: policy-doc-only (no BC). Governing artifact: docs/specs/cargo-mutants-policy.md.
# status=done is permissible for retroactive stories without a BC when the governing artifact
# is an internal policy doc (not a product contract). The story must remain status=done, not
# status=ready — this is a closed cycle, not an open delivery.
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: "docs/specs/cargo-mutants-policy.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 6
assumption_validations: []
risk_mitigations: []
created: "2026-06-28"
last_updated: "2026-06-28"
breaking_change: false
retroactive: true
retroactive_reason: >
  PR #567 was delivered via the MUTATION-CI-TIMEOUT F1–F7 pipeline cycle before a story
  file was filed. This story provides the missing F3 traceability and closes the process
  deviation. Governance is policy-doc-only (docs/specs/cargo-mutants-policy.md); no BC
  was authored. All 6 ACs are characterization pins — each was verified PASS at the time
  of merge (develop @ 3b122a8).
predecessor_cycles: >
  PR #567 (ci(mutants): make mutation gate required with absolute --timeout 240 ceiling +
  false-green guards, develop @ 3b122a8). Multi-commit squash via 7 interim commits:
  257757a (initial gate promotion), 813cdd7 (--timeout 180 + base-ref-drift hardening),
  e547a80 (drift-fail gate fix), 44d779d (policy doc propagation), e6c4d9f (F5 warranted
  fixes: CHANGELOG + version pin + reconciliation), 012c200 (schema-drift/integer guard
  docs), 3b122a8 (merge).
origin: >
  DEC-136 root-cause analysis: cargo-mutants job had no per-mutant timeout ceiling, causing
  CI wall-clock timeouts (60 min) when long-running tests ran for each mutant. Also: job
  was advisory-only (not in ci-gate.needs), so a kill-rate failure did not block PRs.
  This cycle established the hard-required gate, the absolute --timeout 240 ceiling, and
  the false-green detection guards that make kill-rate failures actionable.
f5_review_outcome: >
  3-clean-pass adversarial gate (passes 1–3 in F5 cycle). Final gate output: CLEAN (0 CRIT,
  0 HIGH; 5 MEDIUM + O-class findings all resolved in F5 warranted-fix commits). Resolved
  findings: O1 (timeout_multiplier disambiguation), O3 (cicd-setup.md reference soften),
  M-1 malformed-JSON schema-drift guard (defensive-mode documented), M-4 integer validation
  per-field precision (implemented), M-5 summary-key schema-drift guard (documented).
  Warning-only total_mutants reconciliation (M-2) was a deliberate design decision with
  explicit rationale preserved in policy doc. Post-resolution gate: CLEAN.
delivering_prs:
  - "PR #567 — develop @ 3b122a8"
skip_log:
  - reason: "Per-AC demo recording N/A — CI infrastructure story; no user-facing surface added or changed."
changelog:
  - date: "2026-06-28"
    phase: F3-story-decomposition
    author: story-writer
    summary: >
      Retroactive F3 traceability backfill for PR #567 (MUTATION-CI-TIMEOUT cycle).
      6 characterization pins documented. Governing artifact: docs/specs/cargo-mutants-policy.md.
      Adversary gate: CLEAN post-resolution (3 clean passes). Story count: 96 → 97.
files_modified:
  - .cargo/mutants.toml                  # absolute --timeout 240 ceiling; removed minimum_test_timeout + timeout_multiplier
  - .github/workflows/ci.yml             # mutants job in ci-gate.needs; timeout-minutes 60→90; base-ref-drift guard; false-green guards
  - tests/ci_gate_completeness.rs        # mutants added to exact 8-job set; new test_mutants_is_in_ci_gate_needs; rename advisory-test
  - docs/specs/cargo-mutants-policy.md   # all guards + @27 evidence basis documented; CI Integration section updated
  - CHANGELOG.md                         # entry for MUTATION-CI-TIMEOUT cycle
  - CLAUDE.md                            # CLAUDE.md AI Agent Notes section update (minor wording)
---

# S-MUTATION-CI-TIMEOUT-1 — Retroactive F3 Traceability: Mutation CI Gate Promotion + Timeout Ceiling + False-Green Guards

## Status

**DONE — already delivered.**

This story is a RETROACTIVE TRACEABILITY BACKFILL. PR #567 was merged to `develop` (develop
@ 3b122a8) before a story file was written, following the DEC-136 retroactive-F3 pattern
established by PRs #560/#561 and their traceability story S-D4-TEST-HARDENING-BACKFILL-1.
This document provides the missing F3 artifact and closes the deviation. All acceptance
criteria are characterization pins verified PASS at the time of merge.

**Governance:** This story is policy-doc-only. No behavioral contract (BC-S.SS.NNN) was
authored — the governing artifact is `docs/specs/cargo-mutants-policy.md`. The `bcs: []`
field is intentional. The story is `status: done`, not `status: ready` — the Spec-First Gate
(S-7.01) does not apply to closed retroactive stories.

**Adversarial convergence:** 3 clean passes before merge (0 CRIT, 0 HIGH post-resolution).
Five findings resolved in F5 warranted-fix commits (O1 timeout disambiguation, O3 reference
soften, M-1 malformed-JSON guard documentation, M-4 per-field integer validation,
M-5 summary-key schema-drift guard). M-2 (total_mutants reconciliation) was a deliberate
warning-only design decision with rationale documented in `docs/specs/cargo-mutants-policy.md
§CI Integration`.

**Calibration caveat (watch-item):** AC-005 and AC-006 (kill-rate ceiling / kill-rate failure
path) are unexercised until the first PR that touches a file in `.cargo/mutants.toml::examine_globs`
after the gate became required. The gate's false-positive guards (AC-003, AC-004) have been
exercised in CI runs since merge.

## Source of Truth

| Artifact | Location |
|----------|----------|
| CI job and gate | `.github/workflows/ci.yml` (mutants job + ci-gate.needs) |
| Timeout config | `.cargo/mutants.toml` |
| Gate guard test | `tests/ci_gate_completeness.rs::test_mutants_is_in_ci_gate_needs` |
| Policy doc | `docs/specs/cargo-mutants-policy.md` |
| PR merge commit | `develop @ 3b122a8` |

## Behavioral Contracts

No BC-S.SS.NNN was authored for this cycle. The governing artifact is
`docs/specs/cargo-mutants-policy.md`. Each AC below traces to the relevant policy doc
section rather than a BC clause.

| Policy Section | Topic |
|---------------|-------|
| §CI Integration | Job configuration, ci-gate wiring, base-ref-drift guard |
| §Kill-Rate Target | 90% kill-rate threshold; CLI-only enforcement |
| §Local Invocation | `--timeout` CLI flag; no .toml floor or multiplier |

## Story Narrative

As a contributor to the `jr` CLI,
I want the cargo-mutants job to be a HARD-REQUIRED CI check with a deterministic absolute
per-mutant timeout and false-green detection guards,
so that kill-rate regressions block PRs rather than silently passing, and transient CI
timeouts from unbounded per-mutant execution do not mask real test failures.

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~2,500 |
| `.github/workflows/ci.yml` (relevant mutants job section) | ~1,000 |
| `.cargo/mutants.toml` | ~200 |
| `tests/ci_gate_completeness.rs` (relevant new tests) | ~1,500 |
| `docs/specs/cargo-mutants-policy.md` (CI Integration section) | ~2,000 |
| **Total** | **~7,200** |

Well within a 20% agent context window budget. No splitting required.

## Previous Story Intelligence

**Predecessor context (S-D4-TEST-HARDENING-BACKFILL-1, PRs #560/#561):**
S-D4-TEST-HARDENING-BACKFILL-1 established the retroactive-F3 traceability pattern used
here (DEC-136). That story covered per-profile cache isolation and fields.json self-heal
pins. This story follows the same structure: `retroactive: true`, `status: done`,
`bcs: []` with policy-doc governance, and `predecessor_cycles:` naming the delivering PR.

**N/A — no successor stories blocked by this backfill.**

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| ci-gate.needs wiring pattern | DEC-096/DEC-097 | New required CI checks MUST be added to `ci-gate.needs`, never directly to branch protection. The `mutants` job follows this pattern — wired via `ci-gate.needs`, not as a separate branch-protection check. |
| `mutants` skips on push events | `docs/specs/cargo-mutants-policy.md §CI Integration` | The `mutants` job runs on `pull_request` events only (not push). The ci-gate job checks `failure` and `cancelled` statuses only — `skipped` passes through safely. No push regression exposure. |
| Absolute `--timeout` is CLI-only | `.cargo/mutants.toml` | The per-mutant timeout ceiling is set via `cargo mutants --timeout 240` in `ci.yml`. The `.cargo/mutants.toml` does NOT contain `minimum_test_timeout` or `timeout_multiplier` — both were removed. CLI-only is the canonical source of truth (visible in the job YAML without parsing TOML). |
| @27 version pin | `docs/specs/cargo-mutants-policy.md §CI Integration` | `cargo-mutants` is pinned to @27 in `ci.yml`. This pin protects verified exit-code semantics, JSON output schema, and timeout flag behavior. Schema-drift guards validate at runtime; @27 pin is the primary protection layer. |
| Test-only scope (ci_gate_completeness.rs) | `tests/ci_gate_completeness.rs` | The `test_mutants_is_in_ci_gate_needs` test pins the exact 8-job set in `ci-gate.needs`. Any ci-gate composition change must update this test in the same commit to avoid CI-CIGATE-001 failure. |

## Library and Framework Requirements

| Tool | Version | Constraint |
|------|---------|-----------|
| cargo-mutants | @27 (pinned in ci.yml) | Pinned to protect exit-code semantics (0 = all killed / threshold met; 1 = survivors below threshold; 2 = build error), JSON output schema (`.mutants.out/outcomes.json`), and `--timeout` flag availability. Schema-drift guards in the `Check kill rate` step validate key fields at runtime. |
| tokio | current (from Cargo.toml) | No version change; `#[tokio::test]` harness unchanged. |

No new crate dependencies were added by PR #567.

## File Structure Requirements

| File | Created / Modified | Description |
|------|--------------------|-------------|
| `.cargo/mutants.toml` | MODIFIED (PR #567) | `minimum_test_timeout` and `timeout_multiplier` removed; config comment updated to reference `--timeout 240` CLI flag in ci.yml as the operative ceiling. `examine_globs` scope unchanged. |
| `.github/workflows/ci.yml` | MODIFIED (PR #567) | `mutants` job: `--timeout 240` added; `timeout-minutes: 60 → 90`; added to `ci-gate.needs` (promoting from advisory to hard-required). `Check kill rate` step: malformed-JSON guard, per-field integer validation, runtime schema-drift guard, warning-only `total_mutants` reconciliation, base-ref-drift guard (empty overall diff → FAIL; non-empty 0-mutant diff → PASS). |
| `tests/ci_gate_completeness.rs` | MODIFIED (PR #567) | `mutants` added to exact 8-job set in `test_ci_gate_needs_exactly_the_required_jobs`; new `test_mutants_is_in_ci_gate_needs`; `test_ci_gate_excludes_pr_only_jobs` renamed to `test_ci_gate_excludes_advisory_and_secret_scan_jobs` (removes stale `mutants` exclusion assertion); M1 docstring updated to note `mutants` intentionally omitted from unconditional-run check. |
| `docs/specs/cargo-mutants-policy.md` | MODIFIED (PR #567) | `§CI Integration` section added documenting: `--timeout 240` ceiling and `timeout-minutes: 90` rationale; base-ref-drift guard (empty overall diff → FAIL, non-empty 0-mutant → PASS); malformed-JSON check; per-field integer validation; runtime schema-drift guard; warning-only `total_mutants` reconciliation (M-2 deliberate design decision); @27 pin evidence basis. |
| `CHANGELOG.md` | MODIFIED (PR #567) | Entry for MUTATION-CI-TIMEOUT cycle. |
| `CLAUDE.md` | MODIFIED (PR #567) | Minor wording update in AI Agent Notes (cargo-mutants invocation example). |

---

## Acceptance Criteria

All ACs below are **characterization pins** — each was verified PASS at the time the
delivering PR merged (develop @ 3b122a8). No production source code change is required.
Each AC traces to the relevant policy doc section.

---

### AC-001 — `mutants` job added to `ci-gate.needs`; exact 8-job set pinned
(traces to `docs/specs/cargo-mutants-policy.md §CI Integration` — mutants is a hard-required check)

The `ci-gate` job's `needs:` array in `.github/workflows/ci.yml` contains `mutants` as a
member. The exact 8-job set is pinned by
`tests/ci_gate_completeness.rs::test_mutants_is_in_ci_gate_needs` (new test in PR #567) and
by the existing `test_ci_gate_needs_exactly_the_required_jobs` (updated to reflect 8 jobs).
A PR that removes `mutants` from `ci-gate.needs` will fail CI via CI-CIGATE-001 at the
`test_mutants_is_in_ci_gate_needs` assertion before it can merge.

Verified PASS (develop @ 3b122a8).
Pinned by: `tests/ci_gate_completeness.rs::test_mutants_is_in_ci_gate_needs`
           `tests/ci_gate_completeness.rs::test_ci_gate_needs_exactly_the_required_jobs`

---

### AC-002 — Absolute `--timeout 240` per-mutant ceiling; `minimum_test_timeout` + `timeout_multiplier` removed
(traces to `docs/specs/cargo-mutants-policy.md §Local Invocation` — CLI-only timeout; no TOML floor/multiplier)

The `cargo mutants` invocation in `.github/workflows/ci.yml` includes `--timeout 240`
(absolute 240-second ceiling per mutant). `.cargo/mutants.toml` does NOT contain
`minimum_test_timeout` or `timeout_multiplier` — both keys are absent from the file. The
`timeout-minutes` for the `mutants` job was raised from 60 to 90 to accommodate the new
ceiling. The CLI flag is the single canonical source of truth for the timeout ceiling;
reviewers can verify it without parsing TOML.

Calibration note: 240s was measured against the longest-running test in the mutation scope
at the time of delivery (bulk deadline propagation real-sleep test: ~40s; 240s = 6×).

Verified PASS (develop @ 3b122a8).
Pinned by: `.cargo/mutants.toml` (absence of `minimum_test_timeout` / `timeout_multiplier`);
           `.github/workflows/ci.yml` (presence of `--timeout 240`)

---

### AC-003 — Base-ref-drift guard: empty overall diff → FAIL; non-empty 0-mutant diff → PASS
(traces to `docs/specs/cargo-mutants-policy.md §CI Integration` — base-ref-drift guard prevents false-green from stale checkout)

The `Check kill rate` step in `.github/workflows/ci.yml` includes a base-ref-drift guard:
- If the overall diff (`git diff origin/develop...HEAD`) is empty (all lines in the scoped
  files were unchanged at diff computation but the scoped diff is 0 mutants): the guard
  detects a base-ref checkout failure and exits with a descriptive error (FAIL — not a
  silent skip).
- If the overall diff is non-empty but the scoped diff produces 0 killable mutants (the PR
  does not touch any `examine_globs` file): the guard exits 0 (PASS — no killable mutants
  is a legitimate state, not a drift signal).

This guard closes the DEC-136 false-green class where a misconfigured base-ref checkout
could produce 0 mutants with 100% kill rate, silently passing the threshold check.

Verified PASS (develop @ 3b122a8).
Pinned by: `.github/workflows/ci.yml §Check kill rate` (base-ref-drift guard logic)

---

### AC-004 — False-green guards: malformed-JSON check, per-field integer validation, runtime schema-drift guard, warning-only total_mutants reconciliation
(traces to `docs/specs/cargo-mutants-policy.md §CI Integration` — four guard layers against result-parsing false-greens)

The `Check kill rate` step implements four guard layers against false-green results from
JSON parsing failures or schema migration in cargo-mutants output:

1. **Malformed-JSON guard:** if `outcomes.json` is absent or malformed, the step exits with
   an error rather than defaulting to 0/0 and passing the 90% threshold.
2. **Per-field integer validation:** `caught` and `total` summary fields are validated as
   integers before the division. A string value or null in either field causes an error exit.
3. **Runtime schema-drift guard:** if both `caught` and `total` summary keys are 0, the step
   checks whether the JSON has a recognizable `outcomes.json` structure. Summary keys at 0
   indicate a schema migration (v27 defensive-mode: documented in policy doc §CI Integration).
4. **Warning-only total_mutants reconciliation (M-2):** the step emits a warning when
   `total_mutants` in the JSON summary does not match the count from `--in-diff` scope, but
   does NOT fail — a mismatch can legitimately occur from new outcome categories in future
   cargo-mutants versions. The @27 pin is the primary protection; reconciliation is
   defense-in-depth.

Verified PASS (develop @ 3b122a8).
Pinned by: `.github/workflows/ci.yml §Check kill rate` (guard logic);
           `docs/specs/cargo-mutants-policy.md §CI Integration` (rationale for each guard)

---

### AC-005 — cargo-mutants pinned at @27 in ci.yml
(traces to `docs/specs/cargo-mutants-policy.md §CI Integration` — @27 pin protects verified schema/exit-code/timeout assumptions)

The `cargo install cargo-mutants` step in `.github/workflows/ci.yml` pins `cargo-mutants`
to a specific version (@27 at time of delivery) via `--version`. The pin protects:
- Exit-code semantics: 0 = threshold met; 1 = survivors below threshold; 2 = build error
- JSON output schema: `outcomes.json` key layout relied upon by the `Check kill rate` step
- `--timeout` flag availability (added in a specific cargo-mutants release)

The policy doc documents the @27 evidence basis. A version bump requires verifying the
above properties against the new release's changelog before updating the pin.

Verified PASS (develop @ 3b122a8).
Pinned by: `.github/workflows/ci.yml` (version pin in cargo install step);
           `docs/specs/cargo-mutants-policy.md §CI Integration` (@27 evidence basis section)

---

### AC-006 — Policy doc documents all guards + @27 evidence basis; CHANGELOG + CLAUDE.md updated
(traces to `docs/specs/cargo-mutants-policy.md §CI Integration` — policy doc is the single governance artifact for this cycle)

`docs/specs/cargo-mutants-policy.md` contains a `§CI Integration` section that documents:
- `--timeout 240` ceiling and `timeout-minutes: 90` rationale with measured baseline data
- Base-ref-drift guard behavior (empty diff → FAIL, non-empty 0-mutant → PASS)
- Malformed-JSON check rationale
- Per-field integer validation rationale
- Runtime schema-drift guard (summary-keys-0 detection; defensive-mode semantics)
- Warning-only `total_mutants` reconciliation (M-2) with explicit rationale for warning-only
- @27 pin evidence basis (exit-code semantics, schema contract, `--timeout` flag availability)

`CHANGELOG.md` includes an entry for the MUTATION-CI-TIMEOUT cycle. `CLAUDE.md` includes
a minor update to the cargo-mutants invocation reference in the AI Agent Notes section.

Verified PASS (develop @ 3b122a8).
Pinned by: `docs/specs/cargo-mutants-policy.md §CI Integration` (full documentation);
           `CHANGELOG.md` (entry for MUTATION-CI-TIMEOUT)

---

## Out of Scope (explicit)

**No production source changes.** PR #567 modifies CI infrastructure only (`.cargo/mutants.toml`,
`.github/workflows/ci.yml`, `tests/ci_gate_completeness.rs`, `docs/`, `CHANGELOG.md`, `CLAUDE.md`).
No `src/` module, no API method, no CLI flag, no keychain entry, and no observable user-facing
behavior was changed.

**Per-AC demo recording.** CI infrastructure story; no observable user-facing surface. Skip
Log: `per-AC demo recording N/A — CI infrastructure / no user-facing surface`.

**Kill-rate exercise paths.** The kill-rate ceiling (90%) and the kill-rate failure path are
unexercised at the time of merge — the gate only fires on PRs touching `examine_globs` files.
This is a calibration watch-item, not a defect. First exercise will occur when the next PR
modifies a scoped file (`src/adf.rs`, `src/api/jira/bulk.rs`, etc.).

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `test_mutants_is_in_ci_gate_needs` | `tests/ci_gate_completeness.rs` | Pure (file read + string assert) | Reads ci.yml via `include_str!`; asserts `mutants` is present in ci-gate.needs list; no I/O side effects |
| `test_ci_gate_needs_exactly_the_required_jobs` (updated) | `tests/ci_gate_completeness.rs` | Pure (file read + string assert) | Updated exact-set assertion to include `mutants` (8-job set); same pure pattern as before |
| `Check kill rate` step | `.github/workflows/ci.yml` | Effectful (subprocess + file read + arithmetic) | Reads `outcomes.json` from `cargo mutants` run; performs JSON parsing, integer validation, and threshold check; emits exit code to fail/pass the CI gate |
| `--timeout 240` config | `.cargo/mutants.toml` + `.github/workflows/ci.yml` | N/A (config) | Absolute per-mutant ceiling; TOML contains no timeout keys (CLI-only canonical source) |

**Subsystem anchor justification:** No ARCH-INDEX subsystem applies — all modified files
are CI infrastructure (`.github/workflows/ci.yml`), test tooling (`tests/ci_gate_completeness.rs`),
config (`.cargo/mutants.toml`), and documentation (`docs/specs/`). No cross-subsystem
interaction in these changes.

**Dependency anchor justification:** `depends_on: []` — all prerequisite cargo-mutants
infrastructure (`.cargo/mutants.toml` examine_globs, S-346 baseline CI job) was already
merged. `blocks: []` — no story depends on this CI hardening step.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC |
|----|--------|-------------|-------------------|----|
| EC-001 | Policy §CI Integration | PR does not touch any `examine_globs` file | 0 killable mutants; non-empty overall diff; base-ref-drift guard exits 0 (PASS — legitimate state) | AC-003 |
| EC-002 | Policy §CI Integration | Base-ref checkout failure → empty overall diff | Base-ref-drift guard detects empty diff and exits with error (FAIL — not silent skip) | AC-003 |
| EC-003 | Policy §CI Integration | `outcomes.json` absent or malformed JSON | Malformed-JSON guard exits with error before threshold check (no false-green from division by zero) | AC-004 |
| EC-004 | Policy §CI Integration | Schema migration: summary keys at 0 | Runtime schema-drift guard emits diagnostic; M-2 reconciliation is warning-only; @27 pin is primary protection | AC-004, AC-005 |
| EC-005 | Policy §CI Integration | Per-mutant test exceeds 240s | `cargo mutants --timeout 240` kills the test process; mutant is scored as "timed out" (not killed); contributes to survivors (not an invisible false-green) | AC-002 |
| EC-006 | Policy §CI Integration | Kill rate below 90% on scoped PR | `Check kill rate` step exits 1; ci-gate fails; PR is blocked | AC-001 |

---

## Test Coverage Summary

All tests pass at delivering commit (develop @ 3b122a8). `cargo test` green.

### PR #567 — ci_gate_completeness.rs changes (2 new tests, 1 rename)

| Test name | Governing artifact | AC |
|-----------|-------------------|-----|
| `test_mutants_is_in_ci_gate_needs` (NEW) | `docs/specs/cargo-mutants-policy.md §CI Integration` | AC-001 |
| `test_ci_gate_needs_exactly_the_required_jobs` (UPDATED — 8-job set) | DEC-096/DEC-097 + policy doc | AC-001 |
| `test_ci_gate_excludes_advisory_and_secret_scan_jobs` (RENAMED from `test_ci_gate_excludes_pr_only_jobs`) | N/A (stale `mutants` exclusion removed) | AC-001 |

**Total new tests: 1** (`test_mutants_is_in_ci_gate_needs`). 1 updated, 1 renamed. All pass at develop @ 3b122a8.

---

## Dependency Analysis

**No dependency cycle introduced.** This story has `depends_on: []` and `blocks: []`.
It is a leaf node in the dependency graph.

Wave placement: feature-followup (retroactive backfill of delivered CI infrastructure changes).
No wave gate impact — story is already `done`.

---

## Story Points and Effort

**2 story points** (retroactive F3 traceability document only; implementation already merged).

Breakdown:
- F3 story authoring: 1 SP
- Multi-pass adversarial convergence (3 clean passes) already run before merge: 1 SP

From-scratch TDD estimate would be ~5 SP (CI job design + false-green guard implementation
+ policy doc authoring + test coverage). Reduction reflects that all artifacts are already
written, merged, and passing.
