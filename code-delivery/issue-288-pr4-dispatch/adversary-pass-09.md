# S-288-pr4-dispatch Adversary Pass 09

## Verdict
**CLEAN → 3/3 CONVERGED** per BC-5.39.001 per-story adversarial review.

Zero new findings. 28 confirmed invariants re-verified via fresh-context re-derivation. Per-story convergence loop closes; story ready for Step 5 (demos) → Step 6 (push) → Step 7 (PR lifecycle).

## Findings
None.

## Confirmed Invariants (28 across passes 01-09)

### Dispatch / Platform-path regression
1. Dispatch gate is `request_type.is_some()` only — no project-type probe at gate
2. Platform path structurally unchanged (early-return before any platform-specific code)
3. All 5 platform-only flag warnings fire pre-dispatch with verbatim BC-3.8.011 strings
4. `--markdown` validation mirrors platform path verbatim

### BC contract correctness
5. `require_service_desk` call-site label = `"`jr issue create --request-type` requires"` (BC-3.8.002)
6. Numeric ID bypass: digit-only AND non-empty guard
7. Request-type cache profile-scoped via `&config.active_profile_name`
8. `JsmRequestBuilder` is JiraClient-free (proptest-callable)
9. `serviceDeskId` / `requestTypeId` top-level (negative-space pinned by C.4 proptest + AC-005)
10. `raiseOnBehalfOf` top-level when Some, absent when None (C.3 negative-space pin)
11. `isAdfRequest: true` iff description Some (C.2 both branches)
12. `labels` plain string array, not object array
13. `--field` first-equals split, last-wins (A.1, A.3 proptests + AC-009)
14. `--field NAME=` empty value allowed (A.2)
15. `--field NAME` missing `=` exits 64 pre-POST (M-02 with `expect(0)` guard)
16. `--field summary=X` overrides `--summary X` (cross-source merge order)

### 401 / auth
17. OAuth `InsufficientScope` 401 AND Basic `NotAuthenticated` 401 both surface `write:servicedesk-request` hint
18. Platform 401 does NOT surface JSM scope hint (negative-guard pinned)
19. `DEFAULT_OAUTH_SCOPES` contains `write:servicedesk-request` + 2 pin tests

### Process / convention
20. `.cargo/mutants.toml` examine_globs includes all 3 PR-added files
21. No `unsafe` blocks; no clippy `#[allow]` added (refactor via JsmCreateArgs + JsmRequestBuilder structs)
22. No L-288-pr2-02 accept-either patterns (grep clean)
23. All 29 integration tests + 8 proptests in scope; AC count = 19; BC count = 14
24. CHANGELOG entry for scope + flag additions
25. CLAUDE.md updated with dispatch-fork + OAuth-scope-change gotchas
26. Test file uses subprocess + wiremock with isolated XDG_CACHE_HOME / XDG_CONFIG_HOME (no cross-test contamination)
27. `partial_match::ExactMultiple` arm mirrors `cli/requesttype.rs` exactly
28. Not-found cache-deletion hint uses `cache::cache_dir(profile)` (XDG-aware path, H-04 pinned)

## Reviewed surfaces
Full read across all 17 impl files in scope + 29 integration tests + 8 proptests + spec/story/configs (per adversary's report).

## Not reviewed (out of perimeter)
- pr1-api / pr2-cli (merged)
- Prior adversary reports (fresh-context discipline)

## Known deferred items (carry forward to post-merge follow-up issues)
- **M-03 (pass-03)**: `JrError::InsufficientScope` Display surfaces stale `write:jira-work` legacy text — refactor of shared error type, out of pr4 perimeter
- **O-01 (pass-05)**: Platform-path inverse silent-drop of `--field`/`--on-behalf-of` — BC-3.8.011 symmetry candidate
- **O-08-01..07 (pass-08)**: 6 LOW UX/AC-text refinement observations

## Cycle-closing checklist (S-7.02)
Process-gap findings from pass-01 (PG-01..04), pass-02-retry (PG-02-A), pass-03 (PG-01), pass-05 (LOW process-gap), and pass-08 (O-08-03 candidate) — all flagged as DEFER → follow-up issues. State-manager will log to STATE.md Drift Items in Step 9.

## Novelty Assessment
**NONE** — 3rd consecutive clean pass. Story has fully converged. Recommend immediate progression to Step 5 (demo recording).
