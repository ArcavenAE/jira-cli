# S-288-pr4-dispatch Adversary Pass 07

## Verdict
**CLEAN — clean-pass counter advances to 1/3.**

No CRITICAL, HIGH, or MEDIUM findings. Cross-axis verification confirms all 14 anchored BC contracts + 19 ACs + 4 holdout scenarios are pinned by precise integration/proptest assertions. Known-deferred items (M-03, O-01) correctly remain out of scope.

## Findings
None.

## Confirmed invariants (17 cross-axis checks PASS)
1. Dispatch gate is `request_type.is_some()` only — platform path structurally unchanged
2. Body shape: serviceDeskId/requestTypeId/raiseOnBehalfOf top-level; never in requestFieldValues
3. Labels wire shape: plain string array (not `[{"name":"..."}]`)
4. isAdfRequest present iff description present
5. `--field NAME=VALUE`: first-equals split, duplicate last-wins
6. Numeric ID bypass: no list endpoint call (expect(0))
7. Per-profile cache isolation (`&config.active_profile_name` threaded)
8. Both InsufficientScope and NotAuthenticated 401 paths surface `write:servicedesk-request` hint
9. All 5 BC-3.8.011 flag warnings fire pre-dispatch with verbatim wording
10. OAuth scope present + 2 pin tests
11. Call-site label "`jr issue create --request-type` requires" correctly threaded
12. L-288-pr2-02 grep satisfied (zero `||` accept-either in JSM scope)
13. CHANGELOG + CLAUDE.md doc fallout complete
14. AC-018 mutants scope updated
15. snake-case test naming convention
16. `--markdown` without description error message verbatim parity with platform path
17. handle_jsm_create arg-count refactored via JsmCreateArgs struct (no `#[allow]`)

## Reviewed surfaces
Full read: src/cli/issue/create.rs (dispatch + handle_jsm_create + proptests), src/api/jsm/requests.rs (full + 4 proptests), src/api/jsm/servicedesks.rs, src/api/auth.rs, src/api/client.rs (401 paths), src/cli/auth/tests/mod.rs (scope pins), src/cli/mod.rs, src/cli/issue/mod.rs, src/cache.rs, src/config.rs, src/error.rs, src/cli/issue/helpers.rs, src/partial_match.rs, tests/issue_create_jsm.rs (2277 LOC, 29 tests), .cargo/mutants.toml, CHANGELOG.md, CLAUDE.md
Spec/story: story.md (19 ACs), bc-3-issue-write.md (BC-3.3.001, BC-3.8.001..011), docs/specs/cargo-mutants-policy.md

## Not reviewed (out of perimeter)
- pr1-api / pr2-cli (merged)
- Prior adversary reports (fresh-context discipline)

## Novelty Assessment
**NONE** — clean fresh-context re-derivation confirms convergence. Recommend pass-08 for 2/3.
