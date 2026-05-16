---
document_type: business-analyst-input
phase: F1
issue: 346
producer: business-analyst
inputs:
  - ".factory/specs/prd/BC-INDEX.md"
  - ".factory/specs/prd/nfr-catalog.md"
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/architecture/risk-register.md"
  - ".factory/architecture/cross-cutting.md"
  - ".factory/STATE.md"
  - ".github/workflows/ci.yml"
input-hash: "[pending]"
status: draft
timestamp: 2026-05-16
---

# F1 Business-Analyst Input — Issue #346

## BC Mapping

No existing BC in any body file (`bc-1-auth-identity.md` through `cross-cutting.md`)
contracts CI job shape, mutation-testing thresholds, or quality-gate pass criteria.
The NFR catalog covers CI indirectly via three NFRs that reference `ci.yml` by name
(NFR-S-E, NFR-S-F, R-H6, R-L12, R-L13), but none of those concern mutation testing
or kill-rate targets.

The table below catalogs every existing BC/NFR that could plausibly overlap with
issue #346, and whether it is being MODIFIED, READ-ONLY, or UNAFFECTED.

| BC/NFR ID | Title | Status | Notes |
|-----------|-------|--------|-------|
| NFR-S-E | GHA floating action tags (SHA pinning gap) | READ-ONLY | The new `mutants` job must follow the same SHA-pinning rule if it uses `uses: <action>@...`; if it only uses `run:` steps with `cargo`, no new pinnable action is introduced. Not modified by #346 but relevant to implementation hygiene. |
| NFR-S-F | `cargo-deny` / SBOM supply-chain gap | READ-ONLY | Cargo.toml will add `cargo-mutants` under `[dev-dependencies]` or only in CI install steps. If installed via `cargo install` in CI (not added to Cargo.toml), no new crate enters the dependency graph — NFR-S-F is unaffected. |
| R-H6 | GHA floating-tag supply chain risk (cicd-setup.md GAP-1) | READ-ONLY | Any `uses: sourcefrog/cargo-mutants-action@...` reference must be SHA-pinned. Not a BC-level change; implementation hygiene constraint. |
| R-L12 | CI/CD job timeouts not configured | READ-ONLY | The new `mutants` job MUST have a `timeout-minutes:` value or it will worsen R-L12. Not a new NFR violation — it is the same gap. The implementation should add the timeout. |
| R-L13 | No secrets scanning in CI | UNAFFECTED | #346 adds no secrets-handling logic. |
| BC-3.4.006 | `issue edit --label` bulk label shapes | UNAFFECTED | Targets a scoped set of source files; no relationship to CI plumbing. |
| BC-3.4.009 | `await_bulk_task` deadline task_id contract | UNAFFECTED | Production behavior is unchanged; #346 only adds a CI quality gate over these paths. |
| (no existing BC) | Mutation-testing quality gate (kill-rate >= 90%) | GAP | No BC currently formalizes a kill-rate threshold as a behavioral contract. |
| (no existing BC) | Local `cargo-mutants` invocation | GAP | CLAUDE.md "Build & Test" section lists five canonical commands; `cargo mutants` is absent. |

**Key finding:** Issue #346 introduces a new CI surface — the `mutants` job — and a
new operational discipline — mutation kill-rate tracking for `src/cli/issue/create.rs`,
`src/api/jira/bulk.rs`, and `src/types/jira/bulk.rs`. Neither surface is contracted
by any existing BC. This is additive infrastructure with no BC-level MODIFICATION,
only a potential new entry if the kill-rate target is to be formally tracked as a
quality invariant.

**Anchor justification:** The gap rows above are grounded in the issue statement's
explicit scope ("90% kill-rate target", "New CI job `mutants`") and in the absence of
any matching `#### BC-` heading in the body files. They are not invented from
general CI/CD patterns.

## NFR / VP Mapping

| NFR/VP ID | Category | Status | Notes |
|-----------|----------|--------|-------|
| NFR-S-E | Security / CI integrity | READ-ONLY | SHA-pin requirement extends to any new GHA action reference in the `mutants` job. The fix-in-phase-3 action on NFR-S-E is still OPEN; #346 must not add a new unpinned action. |
| NFR-S-F | Security / supply-chain | READ-ONLY | If `cargo-mutants` is installed via `cargo install` in CI rather than declared in Cargo.toml, the dependency graph is unchanged. |
| R-H6 | Risk / CI supply-chain | READ-ONLY | Applies to implementation hygiene; not a spec change. |
| R-L12 | Risk / missing job timeouts | READ-ONLY | Adding `timeout-minutes:` on the new job is required to avoid worsening R-L12. |
| (no existing NFR) | Testability / mutation kill-rate | GAP | There is no NFR-T-* category in the current catalog. A new NFR could be minted (e.g., NFR-T-A) to formalize the 90% kill-rate contract. However, given that cargo-mutants is a developer-aid tool (not a runtime constraint), the appropriate level of formalization is a CLAUDE.md doc entry and a CI job threshold, not a full NFR entry. See Trivial-Scope Verdict below. |

No VP directory exists at `.factory/specs/verification-properties/`. The closest
analogue to "mutation testing as verification" in this codebase is the inline
proptest pattern (BC-X.9.001, BC-X.5.010, BC-X.10.002). A mutation-testing threshold
is a meta-verification property (it measures how well the existing tests can
distinguish correct from incorrect code), not a VP in the same sense as proptest
invariants. No new VP file is warranted.

## Story Risk Zone

Stories or PRs are in the risk zone only if they would be directly regressed or
would cause the new `mutants` CI job to fail unexpectedly.

| Story / PR | Why in risk zone | Risk level |
|-----------|-----------------|------------|
| PR #370 (S-340, closes #340) | Delivered `src/api/jira/bulk.rs` (870 LOC) and `src/types/jira/bulk.rs` (284 LOC) — the primary mutation targets. High test coverage already established (reported as high in issue context). The `mutants` job scoped to these files should start with a healthy baseline. | LOW — coverage is confirmed high |
| PR #348 (Feature Mode #110-pr2, closes #110) | Delivered `src/cli/issue/create.rs` (1,601 LOC) — the third mutation target. Contains `handle_edit_bulk_labels` and the `build_labels_edited_fields` pure function (added by S-345 / PR #371). | LOW — recent work has high test coverage |
| PR #371 (S-345, closes #345) | Added the proptest for `build_labels_edited_fields` and the function extraction. If any surviving mutants exist in that function, this PR's work is the natural fix location (already merged; only relevant if the baseline run reveals gaps). | LOW — proptest + integration tests already cover this function |
| Any future story modifying `ci.yml` | The `mutants` job runs on PR (not push-to-develop). Any future CI job addition must not break the mutants job dependency chain or conflict with its timeout budget. | LOW — additive jobs do not conflict |

No Wave 0–3 story in the current cycle modifies `ci.yml`. The risk zone is narrow:
the three target source files and `ci.yml` itself.

## Tests in Neighborhood

This change is CI infrastructure, not production test code. No existing test file
is modified by #346. The mutation testing CI job exercises the existing test suite
against mutants of the target modules — it does not add new test files.

The only test-adjacent change is the documentation of local invocation in CLAUDE.md
or `docs/specs/`. This affects maintainer workflow, not the test suite itself.

| Area | Relation to #346 |
|------|-----------------|
| `tests/issue_bulk.rs` | These tests are what cargo-mutants will run against mutants of `src/api/jira/bulk.rs`. They are NOT modified; they serve as the mutation test harness. |
| `tests/issue_bulk_pr2.rs` | Same role: will be run against bulk.rs and create.rs mutants. |
| `tests/bulk_deadline_propagation.rs` | Covers BC-3.4.009 deadline/task_id contract — will run against bulk.rs mutants. |
| `src/cli/issue/create.rs` (inline proptests) | The `build_labels_edited_fields` proptest added by S-345 will run against create.rs mutants. |
| CLAUDE.md "Build & Test" section | Gets a new `cargo mutants` command entry. Affects maintainer docs only. |

## Feature Type

`infrastructure`

The change consists entirely of:
1. A new CI job in `.github/workflows/ci.yml` (no production code change)
2. A documentation update in `CLAUDE.md` (and/or `docs/specs/cargo-mutants.md`)
3. Potentially a `Cargo.toml` change if `cargo-mutants` must be added under
   `[dev-dependencies]` (more likely it is installed via `cargo install` in CI,
   not declared as a dep)

No user-facing behavior changes. No API change. No new Rust source file.
No new business capability. This is a pure CI/CD and developer-tooling addition.

## Intent Classification

`infrastructure`

**Reasoning:** The issue is labeled `ci` + `test` + `audit-followup`. The deliverable
is a CI job and documentation entry — not a user-facing feature, not a bug fix, not a
refactor of production code. The closest vocabulary match is `infrastructure` (CI/CD
setup; additive, well-scoped, no UX or API surface).

**Not `enhancement`:** No enhancement to user-visible functionality. The only users
of the new job are maintainers and CI pipelines.

**Not `refactor`:** No production code is restructured.

**Not `feature`:** No new command, flag, or API interaction.

**Audit-followup context:** Issue #346 was filed as a follow-up to the S-340 bulk
work (merged via PR #370). Its purpose is to lock in quality coverage via automated
mutation testing before the next cycle begins. The audit-followup label is accurate.

## Trivial-Scope Verdict

STANDARD

Criterion-by-criterion:

- **Single module/file/docs-only?** FAIL — Multiple files are touched:
  `.github/workflows/ci.yml` (new job), `CLAUDE.md` (new `cargo mutants` command
  entry), and possibly `docs/specs/cargo-mutants.md` (new spec file). If a baseline
  run finds below-90% surviving mutants, production source files are also touched.
  Three to five files at minimum; potentially more.

- **No new BCs?** CONDITIONAL — No existing BC is modified. Whether a new BC
  is minted depends on whether the kill-rate threshold is formalized as a behavioral
  contract. The baseline finding could reveal gaps in `src/api/jira/bulk.rs` or
  `src/types/jira/bulk.rs` that require new BCs to anchor the fixes. In CI-ONLY
  scope (see Recommendation), no new BC is strictly required for the CI job itself.
  PASS if CI-ONLY scope; conditional if CI-PLUS-BASELINE reveals gaps.

- **No architecture change?** BORDERLINE — Adding a new CI job IS an additive
  architecture change in the CI/CD pipeline. It is well-scoped and additive (no
  existing job is removed or renamed). However, it introduces `cargo-mutants` as a
  new tool in the CI toolchain and establishes a quality enforcement policy (90%
  kill-rate) that future code changes must satisfy. This is a non-trivial policy
  addition. FAIL on strict reading; PASS on "no production architecture change".

- **No new external deps?** CONDITIONAL — If `cargo-mutants` is installed via
  `cargo install cargo-mutants` in the CI job (not added to `Cargo.toml`), the
  Rust dependency graph is unchanged. If a `sourcefrog/cargo-mutants-action` GHA
  action is used, that adds a new action reference that must be SHA-pinned (NFR-S-E
  hygiene). Either way, there is a new external tool dependency at the CI layer.
  FAIL on strict reading; PASS if `cargo install` pattern is used.

- **LOW regression risk?** CONDITIONAL — The new job is PR-only and additive.
  However, if the initial baseline run discovers that existing bulk/create modules
  have surviving mutants below the 90% threshold, the scope expands to include test
  additions or production code fixes. That expansion moves the work from TRIVIAL to
  STANDARD. The issue author acknowledges this risk ("any below-90% surviving mutants
  either fixed or whitelisted with justification").

**Verdict: STANDARD.** Three of five criteria fail on strict application. The
multi-file scope, the new CI policy constraint, and the conditional scope-expansion
risk from surviving mutants collectively push this past the TRIVIAL threshold.

## Recommendation

**CI-ONLY first, with BASELINE-REPORT as a fast-follow.**

Rationale:

1. **Separate the infrastructure from the remediation.** The CI job addition +
   CLAUDE.md doc update is 1-2 hours of deterministic work. Fixing surviving mutants
   is open-ended (the issue author estimates ~1 hour total, but baseline results are
   unknown). Decoupling these reduces PR scope and adversarial review surface.

2. **CI-ONLY scope for the story:** A `code-delivery/issue-346/story.md` should
   target only the new CI job, CLAUDE.md doc update, and (if needed) `--in-diff`
   baseline configuration. The kill-rate threshold is set to 90% as a CI gate but
   the initial PR is not responsible for achieving 90% — it only introduces the gate.
   If the gate fails on the first run, surviving mutants are either whitelisted
   (with justification comment in `.cargo/mutants.toml` or equivalent) or a follow-up
   issue is filed.

3. **No new BC is required for the CI-ONLY path.** The kill-rate threshold is a
   CI enforcement policy, not a domain behavioral invariant. It does not warrant a
   new `#### BC-` heading. If surviving mutants reveal untested contract gaps in
   `bulk.rs` or `create.rs`, those gaps can be anchored in new BCs at that time
   (separate follow-up issues).

4. **NFR-S-E compliance is mandatory.** Any GHA action reference (e.g.,
   `sourcefrog/cargo-mutants-action@...`) must be SHA-pinned in the same commit.
   Using `cargo install cargo-mutants` in a `run:` step avoids introducing a new
   action reference entirely and is the lower-risk approach.

5. **R-L12 compliance:** The new `mutants` job must include `timeout-minutes:` (suggest
   60 minutes for the scoped three-module run) to avoid compounding the existing
   timeout gap documented in R-L12.

6. **`--in-diff origin/develop` mode** is the right PR-efficiency tradeoff. The
   issue author specified this mode. It limits mutation targets to changed lines,
   keeping CI time acceptable. The full-module baseline should be run once locally
   and the report attached to the PR description (not a CI requirement).

**Summary:** Deliver the CI job + docs as a STANDARD story. Defer fixing any
surviving mutants below 90% to follow-up issues (whitelist them with justification
in the initial PR if the gate fails on day one). Do not block the CI job PR on
achieving the threshold — that conflates infrastructure delivery with remediation.
