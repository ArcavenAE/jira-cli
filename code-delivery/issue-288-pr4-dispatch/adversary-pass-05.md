# S-288-pr4-dispatch Adversary Pass 05

## Verdict
**CLEAN — clean-pass counter advances to 2/3.**

No CRITICAL, no HIGH, no MEDIUM findings. One LOW pending-intent observation (O-01) flagged as forward-looking; deferred to post-merge follow-up.

## Findings

### CRITICAL / HIGH / MEDIUM
None.

### LOW / NIT

- **O-01 (pending intent)**: Platform path silently drops `--field` and `--on-behalf-of` (inverse of BC-3.8.011 which mandates platform-only-flag warnings on JSM path). Clap help text says "JSM requests only" but no runtime feedback. Symmetric inverse would emit warnings when `--field`/`--on-behalf-of` set without `--request-type`. Author may have intentionally relied on clap help text — flagged for human review per S-7.01 intent adjudication. **Defer to post-merge follow-up issue.**

### DEFERRED (acknowledged)
- **M-03 (pass-03)**: `JrError::InsufficientScope` Display surfaces stale `write:jira-work` legacy text — refactor of shared error type out of pr4 perimeter. Mitigation: handle_jsm_create map_err prepends correct JSM hint before Display fires; tests pin the prepended hint reaches stderr. Acceptable workaround.

### Process-gap findings
None.

## Cross-axis verification (all PASS)
- L-288-pr2-02 grep (`||` / `.or_else()` / accept-either): 0 hits
- POLICY multi-profile-cache (CRITICAL): correct
- Platform-path regression (BC-3.3.001, AC-002): dispatch fork structurally first
- POLICY zero-clippy + refactor-not-suppress: 0 `#[allow]`
- POLICY citation-discipline: no new external-tracker IDs
- BC-3.8.011 verbatim wording: 5 stderr pins match BC character-for-character
- Multi-profile cache threading: `&config.active_profile_name` threaded correctly
- AC-016 lockstep: src/api/auth.rs:61 + src/cli/auth/tests/mod.rs:342 confirmed
- AC-018 mutants scope: all 3 new files in examine_globs

## Reviewed surfaces
- Full read: src/cli/issue/create.rs, src/api/jsm/requests.rs, src/api/auth.rs, src/cli/auth/tests/mod.rs, src/cli/mod.rs, src/cli/issue/mod.rs, src/error.rs, src/api/client.rs (401 dispatch), src/api/jsm/servicedesks.rs, src/cache.rs, tests/issue_create_jsm.rs (29 tests)
- Spec/story: bc-3-issue-write.md, story.md (19 ACs)
- Configs: CLAUDE.md, CHANGELOG.md, .cargo/mutants.toml

## Not reviewed (out of perimeter)
- pr1-api / pr2-cli (merged)
- Regression baseline tests/* (per BC-3.3.001 must remain green; spot-checked structural protection)
- partial_match crate internals
- refresh_coordinator (not touched by pr4)

## Novelty Assessment
**LOW** — single inverse-symmetry observation. All MUST-style invariants satisfied. Recommend pass-06 to attempt 3/3 close.
