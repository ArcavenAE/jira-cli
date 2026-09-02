# PR #756 Review — S-cycle3-credential-absence-guard

**Story:** No-copy detect-and-instruct guard for absent per-profile API-token credentials (DEC-326)
**Cycle:** cycle-003 (auth-profile-dx), Wave 2 — HIGH-risk (auth-header hot path; one-time breaking change for every pre-cycle-003 API-token profile)
**Diff reviewed:** `d3ba2726...HEAD` (`src/api/auth.rs`, `CHANGELOG.md`, `docs/specs/multi-profile-auth.md`)

## Verdict: APPROVE

Core change is correct, clippy-clean, and satisfies all six review dimensions. Two LOW documentation nits in `CHANGELOG.md`; no code changes required.

Verification run:
- `cargo clippy --lib --all-features -- -D warnings` → clean
- `cargo clippy --tests --all-features -- -D warnings` → clean (forced recompile of `auth.rs`)

## Dimension-by-dimension

### 1. No-copy guarantee — VERIFIED
`legacy_flat_pair_exists()` (`src/api/auth.rs:386-388`) performs only two `read_keyring_optional(...)` reads (`get_password`), `.is_some()`, `&&`. No `set_password`, no `delete_credential`. `load_api_token`'s `(None, None)` branch binds the result to `_legacy_pair_present` and discards it. Neither function writes or deletes any key on any path, for `"default"` or any other profile. The legacy pair's *value* is never bound anywhere.

### 2. No `if profile == "default"` special-casing — VERIFIED
Both the both-absent and partial branches format uniformly with `{profile}`. Grep confirms no default special-case. `prop_vp_authdx_006` injects `"default"` into the generator.

### 3. Precedence (namespaced-partial before legacy) — VERIFIED
`match (email, token)`: `(Some,Some)` → Ok; `(None,None)` → both-absent (the *only* arm that calls `legacy_flat_pair_exists`); `_` → partial. A partial state matches `_` and never consults the legacy pair. Correctness rests on pattern *exclusivity*, not arm order — the docstring's "this match's arm order encodes that" is slightly imprecise but the behavior is correct. `test_bc_1_4_033_partial_precedence_over_legacy_pair_present` covers it.

### 4. Backend-error vs. absent — VERIFIED
`read_keyring_optional` collapses only `NoEntry` → `Ok(None)`; any other keyring error propagates via `?` at lines 439-440 before the match, and again inside the both-absent branch via `legacy_flat_pair_exists()?`. A backend error is never coerced into the actionable message. End-to-end: anyhow-wrapped `JrError::UserError` downcast in `main.rs:125-128` → exit 64; client hot path (`client.rs:133`) propagates via `?`.

### 5. Test quality — strong; one caveat
Byte-exact assertions via single-source-of-truth helpers; no-copy invariant directly asserted (namespaced entries `NoEntry` + legacy bytes unchanged); both partial combinations; repeated-call stability; mandatory real-backend `test_vp_authdx_007...` present and `#[ignore]` + `JR_RUN_KEYRING_TESTS=1`-gated; proptests 005/006/008 cover legacy present/absent, all profiles incl. `"default"`, both partial orderings.

**Caveat (not a defect):** all new tests are gated behind a real keyring backend and `with_test_keyring` early-returns when the env var is unset, so none run in default CI. This matches established module precedent (the keyring mock has no cross-`Entry` persistence). Accepted limitation, not a blocker.

**Count note:** task described "31 new test/proptest functions"; the diff adds **12 unit + 3 proptest = 15** functions (plus non-test helpers). Flagged only for accuracy.

## Findings

### LOW-1 (doc) — CHANGELOG.md:14 directional reference
New entry says the storage change is "**above**", but it is physically **below** (line 31, reverse-chronological). Change "above" → "below" or "in this release".

### LOW-2 (doc) — CHANGELOG.md:42-47 stale forward-reference
The older same-Unreleased S-cycle3-percred-storage entry still quotes the *old* failure message `No stored API token for profile "<name>"` (now replaced by `No credentials stored for profile '<name>'...`) and states the detect-and-instruct guidance "lands with the follow-on ... story" — which has now landed in the same Unreleased block. Both ship in one release describing two different error strings and a "future" story that is present. Recommend reconciling the storage entry's final two sentences for changelog coherence.

Both are non-blocking polish.

## Docs
`docs/specs/multi-profile-auth.md` section (4) is accurate; the illustrative `load_api_token` code block is correctly labeled and its Properties list matches the implementation (no-copy invariant, byte-identical error, no profile special-casing, distinct partial-write error checked first, never suggests `jr auth logout`, one-time cost).
