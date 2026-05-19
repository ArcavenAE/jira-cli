# S-288-pr4-dispatch Adversary Pass 08

## Verdict
**CLEAN — clean-pass counter advances to 2/3.**

No CRITICAL/HIGH/MEDIUM findings. Six LOW Observations documented; all defer-or-fix discretion items at API boundaries.

## Findings
None (Critical/High/Medium).

### LOW / NIT (observations — non-blocking)

- **O-08-01**: Generic `NotAuthenticated` → JSM-scope hint mapping misleads Basic-auth users (Basic-auth API token expiry surfaces as "missing OAuth scope" hint). BC-1.3.023 satisfied; UX boundary. Defer or refine.
- **O-08-02**: JSM-path "project is required" terser than platform-path equivalent. BC-3.8.002 spec satisfied verbatim; could expand BC + hint together.
- **O-08-03** [process-gap]: AC-013 declares `HashMap<String, serde_json::Value>` but impl + BC-3.8.008 use `HashMap<String, String>`. Impl is BC-compliant; AC text stale. Cosmetic story-doc drift.
- **O-08-04**: `--request-type ""` empty-string degrades to "Ambiguous matches all" — defendable (exit 64, no POST) but mild UX paper-cut.
- **O-08-05**: `require_service_desk` 401 cannot surface JSM hint (only `create_jsm_request` map_err does). Partial-credit hint already exists for write-scope-only users.
- **O-08-06**: `--field description=plain` + `--markdown` desyncs `isAdfRequest: true` with literal string description (Atlassian would 400). Requires deliberate misuse; latent.
- **O-08-07**: `--type` warning fires pre-dispatch even when project is non-JSM (warning + error both shown). BC-3.8.010 explicitly permits via "need not fire" language.

### DEFERRED (acknowledged, not re-flagged)
- M-03 (pass-03): InsufficientScope Display stale text
- O-01 (pass-05): platform-path inverse silent-drop

### Process-gap findings
- O-08-03 tagged process-gap candidate but single-occurrence; codification weight small.

## Cross-axis verification (all PASS)
- BC-3.8.001..011 + BC-3.3.001 + BC-1.3.023 + BC-X.3.005: verbatim wording confirmed
- L-288-pr2-02 grep: 0 prohibited hits in JSM scope
- Multi-profile cache (CRITICAL): correct
- Platform-path regression: dispatch fork structurally first; pinned by expect(1)/expect(0)
- Mutation testing scope (AC-018): 3 new files in examine_globs
- Zero `#[allow]` (refactor-not-suppress via JsmCreateArgs struct)
- snake-case test naming convention
- Citation discipline: all external refs verified
- All 19 ACs pinned by precise integration/proptest assertions

## Reviewed surfaces
Full read across all 17 impl files in scope + 29 integration tests + 8 proptests + spec/story/configs.

## Not reviewed (out of perimeter)
- pr1-api / pr2-cli (merged)
- Prior adversary reports (fresh-context discipline)

## Novelty Assessment
**LOW** — six refinement observations at boundaries (auth-type / hint-call-site / spec-↔-impl-AC drift / latent layering bug). No spec gaps, no contract violations, no test precision regressions. Recommend pass-09 to attempt 3/3 close.
