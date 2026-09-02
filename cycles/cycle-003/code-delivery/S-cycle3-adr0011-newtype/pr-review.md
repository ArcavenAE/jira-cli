# PR #758 Review — `refactor(config): Profile newtype type-fence (ADR-0011 accepted)`

**Verdict: APPROVE (with nits) — recommend MERGE.**

Fresh-eyes AI review under the information-asymmetry wall: only the PR diff, description, and
stated test evidence were used. No `.factory/` artifacts were consulted.

No CRITICAL or HIGH findings. This is a clean, coherent, behavior-preserving mechanical
refactor threading a `Profile(String)` newtype through every per-profile cache/credential
boundary. The compiler is the primary regression net and the trait impls are correct.

## Explicit confirmations

### Debug / Display / AsRef byte-identity — CONFIRMED CORRECT
- `Debug` is hand-written and delegates via `fmt::Debug::fmt(&self.0, f)` → renders `"prod"`,
  NOT `Profile("prod")`. Every pre-existing `{:?}` message (config.rs `base_url()` error,
  the `"unknown profile: ..."` path) renders byte-for-byte identically.
- `Display` is `f.write_str(&self.0)` — verbatim, no bracket/quote decoration. `format!`
  interpolation, cache-path joins, and keychain key construction unchanged.
- `AsRef<str>` returns `&self.0` verbatim. Keychain keys (`oauth_access_key(profile.as_ref())`)
  and cache paths (`cache_dir` → `.join("v1").join(profile.as_ref())`) produce identical strings.

### Behavior preservation — CONFIRMED
No observable change to keychain key strings, cache paths, JSON output, error messages, or ordering.
- Key-builder functions kept `&str`, fed `.as_ref()` → identical wire keys.
- `clear_all_credentials`: `.contains(&"default")` → `.iter().any(|p| p.as_ref() == "default")` —
  semantically equivalent.
- `tests/worklog_duration_holdouts.rs` gives positive proof: asserts
  `cache_dir(&Profile::from("default")) == <temp>/jr/v1/default` — the path join is unchanged.
- `config.rs` runs `validate_profile_name` on the raw `String` BEFORE `Profile::from(...)`
  boundary construction — no validation relaxation, and the newtype is infallible by design (SR-017).

### compile_fail fence (AC-005) — PRESENT and load-bearing
The `compile_fail` doctest on `Profile` demonstrates that a bare `&str` does not coerce to
`&Profile` at a function boundary. `From<&str>` only constructs owned values explicitly and does
not weaken the fence.

### Fence scope — COHERENT
`oauth_login`, `refresh_oauth_token_with_url`, the refresh coordinator, and the key-builders
retain `&str`, with `Profile` constructed at the boundary. Defensible: those resolve credentials
/ coordinate by name and receive the profile from the now-`Profile`-typed `Config`. Not a
behavior gap.

### ADR-0011 + CHANGELOG — both present
ADR-0011 Status is `Accepted` (DEC-317). CHANGELOG has an `### Internal` entry noting no
user-visible change.

### Conventions
No lint suppression, no let-chains, no new `unsafe` (the `unsafe` in tests is pre-existing
env-var seams). Added `From<&str>` / `PartialEq<str>` / `PartialEq<&str>` / `Ord` / `Hash` impls
each carry justifying doc comments; the `From`/`PartialEq` impls are load-bearing for test
ergonomics without weakening the boundary fence.

## Findings

| # | Severity | Category | Finding | Suggestion |
|---|----------|----------|---------|------------|
| 1 | LOW (new) | doc-accuracy | `src/profile.rs` module doc ("Scaffolding-only… the mechanical call-site sweep has NOT happened yet… signatures still read `profile: &str`") and the ADR-0011 body blockquote ("As of the STUB step… the sweep has NOT started: `src/cache.rs`, `src/config.rs`, `src/api/client.rs`, `src/api/auth.rs` still carry `profile: &str`… as of this writing") are FALSE in the merged state — this PR performs that sweep. The merged docs are internally self-contradictory. | Non-blocking follow-up: update the module doc and ADR to describe the completed sweep, or add a "superseded by the F4 implementation in this PR" note. Known verbatim-staging artifact (PR desc: "applied verbatim per Task Item 1"), not a behavior issue. |
| 2 | LOW (known) | testing | No dedicated Debug-only unit test; Debug byte-identity exercised only indirectly. | Prior review already flagged — not re-escalated. |
| 3 | LOW (known) | design | `Ord`/`Hash` derives currently unused by any call site. | Prior review already flagged; justified as forward-looking. Not re-escalated. |

## Merge recommendation: MERGE

Finding #1 is the only new item — a non-blocking documentation-accuracy nit suitable for a
follow-up. Test evidence is strong: `cargo test --lib` 1249 passed / 0 failed, doctest fence
passing, integration (110 binaries) 0 failed, clippy `-D warnings` clean, `cargo fmt --check`
clean. Verdict: **APPROVE**.
