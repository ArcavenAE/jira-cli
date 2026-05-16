---
document_type: f1-delta-analysis
phase: phase-f1-delta-analysis
producer: state-manager
issue: 346
status: orchestrator-approved
timestamp: 2026-05-16
project: jira-cli
mode: BROWNFIELD
intent: enhancement
feature_type: infrastructure
trivial_scope: false
regression_risk: low
inputs:
  - ".factory/phase-f1-delta-analysis/architect-input-346.md"
  - ".factory/phase-f1-delta-analysis/business-analyst-input-346.md"
---

# F1 Delta Analysis — Issue #346

## Issue Summary

Issue #346 ("chore(ci): add cargo-mutants to CI scoped to bulk + edit modules with 90% kill-rate target") is an audit-followup from the F6 hardening review of PR #110-pr2 (2026-05-10). It introduces a new `mutants` CI job to `.github/workflows/ci.yml` that runs `cargo-mutants` scoped to `src/cli/issue/create.rs`, `src/api/jira/bulk.rs`, and `src/types/jira/bulk.rs` on every pull request, with a 90% mutation kill-rate enforcement threshold. The job uses raw `cargo install cargo-mutants` (no GitHub Action wrapper, no new SHA-pin surface, no new Cargo.toml dependency). A companion `.mutants.toml` configuration file, a `docs/specs/cargo-mutants-policy.md` spec codifying the `#[mutants::skip]` whitelist convention, and CLAUDE.md documentation additions round out the change. No production source files are modified by this issue itself; surviving mutants discovered by the baseline run are either whitelisted (with justification comments) or deferred to follow-up issues rather than blocking this PR.

## Approved Scope

CI-ONLY with whitelist convention codified. Scope is STANDARD (multi-file CI change + policy doc; potential follow-up issues if baseline fails 90%). The deliverables are:

1. A new `mutants` job in `.github/workflows/ci.yml` (PR-only trigger, `--in-diff origin/${{ github.base_ref }}` scoping, `timeout-minutes: 60`, kill-rate enforcement via shell one-liner reading `mutants.out/caught.txt` and `mutants.out/missed.txt`).
2. `.gitignore` — add `mutants.out/` entry.
3. `CLAUDE.md` — two additions: local `cargo mutants` command in Build & Test section; AI Agent Note clarifying cargo-mutants is a binary tool installed via `cargo install`, never a Cargo.toml dependency.
4. `.mutants.toml` — `timeout_multiplier = 3.0` plus explicit file scope for the three designated files; kill-rate threshold NOT set here (stays in CI YAML for visibility).
5. `docs/specs/cargo-mutants-policy.md` — codifies `#[mutants::skip]` whitelist convention (mandatory justification comment required), the 90% kill-rate target rationale, and the deferral policy (surviving mutants below 90% on first baseline → file follow-up issues, do NOT block the initial PR).
6. `.factory/architecture/cicd-setup.md` — F2 architect's responsibility to add the new `mutants` job to the CI job catalog (NOT modified in F4).

## Impact Assessment Table

| Artifact | Change |
|----------|--------|
| PRD | UNCHANGED — no existing BC contracts CI job shape or mutation-testing thresholds. No new BC ID is created; kill-rate is a CI enforcement policy, not a domain behavioral invariant. If baseline run reveals untested contract gaps in bulk.rs or create.rs, new BCs are anchored at that time via follow-up issues. |
| Architecture | `cicd-setup.md` MODIFIED (F2, not F4): architect adds the new `mutants` job to the CI job catalog. No production module boundary crossed. |
| UX | n/a — CI infrastructure only; no user-visible behavior change |
| Stories | +1 (S-346; feature-followup; code-delivery/issue-346/story.md) |
| Tests | n/a — no new test files; the existing test suite becomes the mutation test harness. The `#[mutants::skip]` whitelist annotations (if needed at F4) are placed in production source, not in test files. |
| VPs | n/a — no VP directory exists; the kill-rate threshold is a meta-verification property, not a VP in the proptest-invariant sense. |
| New spec | `docs/specs/cargo-mutants-policy.md` NEW — standalone policy spec establishing the `#[mutants::skip]` convention with mandatory justification, the 90% kill-rate rationale, and the deferral policy for initial-baseline misses. |

## Files Likely Changed

- `.github/workflows/ci.yml` — MODIFIED: new `mutants` job (~25-35 lines). Job uses `if: github.event_name == 'pull_request'` guard (matches existing `security` job pattern). Installs cargo-mutants via `cargo install cargo-mutants` + Swatinem cache. Runs `cargo mutants --in-diff origin/${{ github.base_ref }} --file src/cli/issue/create.rs --file src/api/jira/bulk.rs --file src/types/jira/bulk.rs`. Kill-rate threshold enforced via inline shell step reading `mutants.out/caught.txt` and `mutants.out/missed.txt`. Sets `timeout-minutes: 60`. Satisfies R-L12 (missing-timeout gap) for this job.
- `.gitignore` — MODIFIED: add `mutants.out/` line. Prevents accidental commit of mutation results artifacts.
- `CLAUDE.md` — MODIFIED: (1) Build & Test section: new `cargo mutants` invocation line showing local usage. (2) AI Agent Notes section: line documenting that cargo-mutants is a binary tool installed via `cargo install cargo-mutants`, not a Cargo.toml dependency, and should never be added as one.
- `.mutants.toml` — NEW: minimal config. `timeout_multiplier = 3.0` (prevents false "unviable" results on async bulk code paths). Explicit file scope for the three designated files so local `cargo mutants` invocations match CI behavior by default. Kill-rate threshold NOT set here.
- `docs/specs/cargo-mutants-policy.md` — NEW: codifies `#[mutants::skip]` whitelist convention (comment format: `// mutants::skip: <reason>`), the 90% kill-rate rationale, the deferral policy (initial-baseline surviving-mutant clusters → file follow-up issues, whitelist only when justification is clear), and the anti-pattern of adding cargo-mutants to Cargo.toml.
- `.factory/architecture/cicd-setup.md` — MODIFIED (F2 architect, not F4): add the new `mutants` job row to the CI job catalog. F4 implementer must NOT touch this file.
- `.factory/code-delivery/issue-346/story.md` — NEW: S-346 story file (feature-followup pattern).

## Files NOT Changed (regression baseline)

- `Cargo.toml` — UNCHANGED. cargo-mutants is a binary tool installed via `cargo install cargo-mutants` in CI; it is not a crate dependency and must never be added to `[dev-dependencies]`. Adding it there would be incorrect.
- All production source files (`src/`) — UNCHANGED. The mutation testing CI job exercises the existing source against mutations; it does not modify any source file. If the baseline run reveals surviving mutants, fix-PRs or `#[mutants::skip]` whitelist annotations are deferred to follow-up issues (not this PR).
- All test files (`tests/`) — UNCHANGED. Existing test suite serves as the mutation harness without modification.
- `.factory/architecture/cicd-setup.md` — NOT modified in F4; F2 architect owns this update.
- `.factory/specs/prd/BC-INDEX.md` — UNCHANGED. No new BC ID; no in-place BC extension.
- `.factory/stories/STORY-INDEX.md` — MODIFIED (F3): S-346 registered at next available ID.

## Risk Assessment

- **Regression risk: LOW** for the CI plumbing itself — the new `mutants` job is additive; the `if: github.event_name == 'pull_request'` guard prevents it from running on push to develop/main, bounding blast radius to PRs. Existing jobs are independent and unaffected. The primary risk is a YAML syntax error or incorrect `--in-diff` ref format, mitigated by keeping the job structure identical to the existing `security` job pattern.
- **CONDITIONAL MEDIUM if baseline reveals surviving mutants below 90%** — particularly likely for: (1) `if adds.is_empty() && removes.is_empty()` short-circuit bail in `handle_edit_bulk_labels`; (2) `await_bulk_task` grace-period branch (debug-only path exercised by integration tests with timing sensitivity); (3) `build_labels_edited_fields` object-vs-array branch (proptest added by #345 should cover this, but verify that cargo-mutants exercises proptest-gated tests). Mitigation: F4 runs local baseline before the PR; surviving mutants are whitelisted with justification or deferred to follow-up issues. The PR is NOT blocked on achieving 90% on the first run.
- **Architecture risk: NONE** — pure CI/CD addition; no production module boundary crossed; no trait or interface change; no async boundary modification.
- **Security risk: NONE** — no new secrets required; no new network calls from the test harness; no GITHUB_TOKEN permission escalation. NFR-S-E compliance maintained by using `run:` steps with `cargo install` rather than a `uses:` action reference (no new SHA-pin surface introduced).
- **`#[mutants::skip]` whitelist misuse risk: LOW** — mitigated by the mandatory justification comment convention codified in `docs/specs/cargo-mutants-policy.md` before F4 applies any annotation.

## Recommended Scope for Subsequent Phases

- **F2:** Architect updates `.factory/architecture/cicd-setup.md` to add the new `mutants` job to the CI job catalog. No new BC needed (kill-rate is a CI enforcement policy, not a domain behavioral invariant). No BC-INDEX or CANONICAL-COUNTS change required.
- **F3:** Story-writer creates S-346 as a feature-followup story (`code-delivery/issue-346/story.md`); no `bc_anchors` (meta-CI work with no BC-level anchor); registers in STORY-INDEX.md at next available ID.
- **F4:** Implementer adds ci.yml mutants job + .gitignore entry + CLAUDE.md docs + .mutants.toml + docs/specs/cargo-mutants-policy.md. Runs local baseline before the PR (`cargo mutants --file src/cli/issue/create.rs --file src/api/jira/bulk.rs --file src/types/jira/bulk.rs`). For each surviving-mutant cluster: either add `#[mutants::skip]` annotation with mandatory justification comment (per policy doc) OR file a follow-up issue. Does NOT block PR on achieving the 90% kill-rate threshold on the first baseline run. Does NOT add cargo-mutants to Cargo.toml. Does NOT modify `.factory/architecture/cicd-setup.md` (F2 scope).
- **F5:** Scoped adversarial on the diff (CI YAML correctness, policy doc completeness, CLAUDE.md doc accuracy, .mutants.toml scope correctness).
- **F6:** Minimal — the mutation testing CI job IS the hardening artifact for this issue. No proofs, no fuzz, no property tests needed. Copilot review expected to be 1-2 rounds (CI YAML syntax + policy wording).
- **F7:** PR via pr-manager; target develop; labels `ci`, `infrastructure`, `audit-followup`; closes #346.

## Deferred

The following items will be filed AT F4 if the local baseline run reveals surviving mutants:

- **Follow-up issues per surviving-mutant cluster** — one issue per distinct uncovered region (e.g., "cargo-mutants: cover `await_bulk_task` grace-period branch", "cargo-mutants: cover `handle_edit_bulk_labels` bail check"). These are not blocking this PR.
- **`track-debt` entries for whitelisted cases** — each `#[mutants::skip]` annotation applied in F4 must have a corresponding entry in the tech-debt register recording the justification and the expected condition under which the whitelist would be removed.

Issue #331 (empirical Atlassian Bulk API schema verification) remains sandbox-blocked and is explicitly out of scope for #346.

## Quality Gate

Orchestrator approved 2026-05-16.
