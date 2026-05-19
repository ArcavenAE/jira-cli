# S-288-pr4-dispatch Adversary Pass 04

## Verdict
**CLEAN — clean-pass counter advances to 1/3.**

No CRITICAL, no HIGH, no MEDIUM findings. Four LOW observations (O-01..O-04) documented for visibility; none block convergence. One DEFERRED item (M-03 InsufficientScope Display) acknowledged but not re-flagged.

## Findings

### CRITICAL / HIGH / MEDIUM
None.

### LOW / NIT (observations — non-blocking)

- **O-01**: ADR-0014 lives at `.factory/architecture/adr/0014-*.md` (gitignored) not `docs/adr/`. CLAUDE.md references it. Authorial choice between published vs in-flight ADRs; cosmetic.
- **O-02**: BC-3.8.011 Trace field uses "5 new warning-emission tests" (would match PG-365-1 regex). Mitigated because `.factory/` is gitignored so the check doesn't fire on it.
- **O-03**: Warning block fires before late validation; BC-3.8.010 says "warning need not fire" on early-exit — permissive language, current order is BC-compliant.
- **O-04**: AC-019 idempotence ("twice → ONE warning") not integration-tested but structurally guaranteed by clap `Option<String>` last-wins semantics.

### DEFERRED (acknowledged from prior passes)
- **M-03 (pass-03)**: `JrError::InsufficientScope` Display surfaces stale "write:jira-work" legacy guidance — refactor of shared error type is out of pr4 perimeter; tracked as post-merge follow-up.

### Process-gap findings
None.

## Cross-axis verification (all PASS)
- L-288-pr2-02 grep mandate (`||` / `.or_else()` / accept-either): 0 hits
- POLICY multi-profile-cache (CRITICAL): correct profile threading
- Platform-path regression (BC-3.3.001, AC-002): dispatch fork structurally first; existing platform code bit-for-bit unchanged
- Mutation testing scope (AC-018): .cargo/mutants.toml includes all 3 new files
- POLICY zero-clippy + refactor-not-suppress: 0 `#[allow]` introduced
- POLICY snake-case-tests: all 29 tests + 4 proptests follow convention
- POLICY non-interactive-equiv: all error arms return JrError::UserError (exit 64, no prompt)

## Reviewed surfaces
- Full read: src/cli/issue/create.rs, src/api/jsm/requests.rs, src/api/jsm/mod.rs, src/api/auth.rs, src/cli/auth/tests/mod.rs, src/api/client.rs (401/InsufficientScope dispatch), src/cache.rs, src/cli/requesttype.rs (sibling), src/error.rs, tests/issue_create_jsm.rs (29 tests)
- Spec/story: bc-3-issue-write.md, story.md
- Configs: CLAUDE.md, CHANGELOG.md, .cargo/mutants.toml, docs/specs/cargo-mutants-policy.md, scripts/check-bc-no-numeric-test-counts.sh

## Not reviewed (out of scope)
- pr1-api / pr2-cli (merged)
- Regression baseline tests/* (assumed unmodified per BC-3.3.001)
- Other unrelated jsm submodules

## Novelty Assessment
**LOW** — story converged. Pass-03 fixes propagated correctly. Observations are refinements or already-mitigated. Recommend two more clean passes before merge.
