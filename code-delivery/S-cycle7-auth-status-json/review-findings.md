# Review Findings — S-cycle7-auth-status-json (PR #807)

## Convergence Tracking

| Cycle | Reviewer | Findings | Blocking | Fixed | Remaining | Verdict |
|-------|----------|----------|----------|-------|-----------|---------|
| Pre-PR (adversarial, pass 1) | vsdd-factory:adversary | 3 | 1 | 3 | 0 | Fixed |
| Pre-PR (adversarial, pass 2) | vsdd-factory:adversary | 2 | 0 | 2 | 0 | Fixed |
| Pre-PR (adversarial, pass 3) | vsdd-factory:adversary | 2 | 1 (MED-1) | 2 | 0 | Fixed |
| Pre-PR (adversarial, pass 4) | vsdd-factory:adversary | 0 | 0 | 0 | 0 | CLEAN |
| Pre-PR (adversarial, pass 5) | vsdd-factory:adversary | 0 | 0 | 0 | 0 | CLEAN |
| Pre-PR (adversarial, pass 6) | vsdd-factory:adversary | 0 | 0 | 0 | 0 | CLEAN |
| Post-PR (security) | vsdd-factory:security-reviewer | 0+1 INFO | 0 | N/A | 0 | CLEAN |
| 1 (pr-reviewer) | vsdd-factory:pr-reviewer (a224fb9cd2784f7f9) | 5+3 INFO | 1 BLOCKING + 2 MAJOR | 5 | 0 | REQUEST_CHANGES |
| 2 (pr-reviewer×2) | aa228ab2b5ce73348 + aa64eb80185d50b7a | 4 MINOR/SUGGESTION | 0 | 4 (MINOR) | 0 | APPROVE |

## Pre-PR Adversarial Review Summary (passes 1-6)

### Pass 1 Findings
- **F-1 (MEDIUM):** JSON object construction not pure — inline inside `status()` entangled with keychain I/O. **FIXED:** Extracted into `build_status_json()` pure function (AC-013 added).
- **C-1 (LOW):** Missing `#[ignore]` on keyring-dependent tests. **FIXED:** AC-006/007/008 correctly gated.
- **I-1/I-2 (LOW):** Minor spec labeling. **FIXED:** VP-AUTHDX-026 tags added to AC-001 through AC-006.

### Pass 2 Findings
- **LOW-3:** VP-AUTHDX-024 absent from `verification_properties` without explanation. **FIXED:** Frontmatter comment added explaining VP-AUTHDX-024 is Wave-gate (H-W2-INT-001), not story-level.
- One other doc clarification. **FIXED.**

### Pass 3 Findings
- **MED-1:** `probe_matching_kind_credential`/`peek_oauth_app_source` added to `examine_globs` scope without `exclude_re` entries — would surface false-surviving mutants. **FIXED:** 4 `exclude_re` regex entries added with justification comment.
- **LOW-1:** File Structure Requirements table misrouted AC-011 test to `tests/` crate (pub(crate) symbols not accessible). **FIXED:** Corrected to inline `src/cli/auth/tests/mod.rs`.

### Passes 4, 5, 6
CLEAN — no findings. 3 consecutive clean passes. **CONVERGED.**

## Security Review (PR #807)

Reviewer: vsdd-factory:security-reviewer
Verdict: CLEAN
- Critical: 0 / High: 0 / Medium: 0 / Low: 0
- INFO: `env` field verbatim in JSON (intentional, documented) — not a finding
- Security gate: PASSED

## PR Review Cycle 1

Reviewer: vsdd-factory:pr-reviewer (a224fb9cd2784f7f9)
Verdict: REQUEST_CHANGES

Findings:
- BLOCKING-1: docs/specs/multi-profile-auth.md stale "no --output json" claim → FIXED (commit 0992e5c8)
- MAJOR-1: cargo-mutants-policy.md exclusions registry not updated → FIXED (commit 0992e5c8)
- MAJOR-2: e2e-live-jira-testing.md:83 stale "emits no JSON" claim → FIXED (commit 0992e5c8)
- MINOR-1: PR body double-counts tests → PARTIALLY FIXED (summary table corrected)
- MINOR-2: PR body overstates auth list parity → FIXED

## PR Review Cycle 2

Reviewers: aa228ab2b5ce73348 (independent) + aa64eb80185d50b7a (cycle 2 focused)
Verdict: APPROVE (both reviewers)
covered_sha: 0992e5c80622388d6c8d2515f19334c504776c56

Remaining non-blocking: SUGGESTION (glob count prose, scope bullet) + NIT (exclusion attribution)

## CI Gate (Cycle 2)

Status: ALL 24/24 CHECKS PASS at commit 0992e5c80622388d6c8d2515f19334c504776c56
- CI Gate: PASS
- Mutation Testing (Aggregate): PASS
- Test (ubuntu, macos, windows): ALL PASS
- All other checks: PASS

## Final State

READY-TO-MERGE at HEAD: 0992e5c80622388d6c8d2515f19334c504776c56
Stale-verdict check: PASS (covered_sha matches live HEAD)
Pending: Human squash-merge via GitHub UI (automated merge is permission-gated)
