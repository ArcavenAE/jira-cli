<!--
STAGED F2 amendment to docs/adr/0011-type-level-profile-fence.md
(Status Deferred→Accepted, Profile newtype design, DEC-317).
NOT yet applied to the main-repo file. The F4 story
S-cycle3-adr0011-newtype MUST apply this amendment to
docs/adr/0011-type-level-profile-fence.md as part of its
implementation PR.
-->

# ADR-0011: Type-Level Profile Fence (Newtype)

## Status
**Accepted** (amended 2026-09-01, cycle-003 `auth-profile-dx`, DEC-317 — un-defers this ADR
in place; this is a status amendment, not a supersession, since the underlying decision does
not reverse, it confirms a documented revisit trigger was met). Originally **Deferred**
(promoted to `docs/adr/` 2026-06-24, PR #549/SC-03; the deferral itself predates the VSDD-factory
migration — see git history for the pre-promotion origin).

**Trigger met:** Condition for Revisiting #3 below — "a related refactor (e.g., a major config
overhaul) creates a natural migration window." Cycle-003's per-profile credential restructuring
(DEC-315: shared flat `email`/`api-token` keychain keys become `<profile>:email`/
`<profile>:api-token`, symmetric with the existing per-profile OAuth token pair) is exactly that
window: it is itself a `ProfileConfig`/keychain-scoping change that touches nearly every
call site this newtype would guard, so implementing the hard fence in the SAME cycle (sequenced
AFTER the credential restructuring lands — see the new combined ADR, `.factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`,
§ Sequencing) means the call-site sweep covers the enlarged, post-restructuring surface exactly
once rather than twice. Condition #1 (a leakage bug in production) and Condition #2 (>5
committers) remain NOT met — DEC-317 explicitly cites #3 alone as sufficient.

> **Design decision, not yet a completed migration.** This amendment records the ACCEPTED
> decision to implement the hard fence. The actual `Profile(String)` newtype and its ~50-70
> call-site threading through `src/cache.rs`, `Config::active_profile_name`, and
> `JiraClient::profile_name` are an **F4 implementation deliverable** of cycle-003 (story
> `S-cycle3-adr0011-newtype` in the F1 delta analysis' preliminary story list) — no `src/` file
> has been touched by this F2 architecture pass. `src/cache.rs`, `src/config.rs`, and
> `src/api/client.rs` still carry `profile: &str` / `profile_name: String` as of this writing.

## Context

Per-profile cache isolation is a critical correctness invariant in `jr`. Every cache
reader and writer takes `profile: &str` as its first argument. `JiraClient` carries
`profile_name: String` and exposes `profile_name()` for modules that have a client but
not a config.

This is a **convention-enforced (soft-fence) boundary.** There is no compile-time
enforcement preventing a future contributor from:
- Adding a new cache-reading function that does not take a `profile` parameter
- Calling `cache::read_*` with a hardcoded string instead of the active profile name
- Adding a new resource impl that fetches and stores data without the profile qualifier

**Newtype proposal:** Introduce a `Profile(String)` newtype that would make
profile-unaware cache calls a compile error:

```rust
// Current (soft fence — compiles but silently wrong)
pub fn read_teams_cache(profile: &str) -> Result<Option<Vec<TeamEntry>>> { ... }

// Proposed (hard fence — profile must be an explicit Profile wrapper)
pub fn read_teams_cache(profile: &Profile) -> Result<Option<Vec<TeamEntry>>> { ... }
```

**Trade-off summary:**

| Aspect | Newtype (hard fence) | Current convention (soft fence) |
|--------|---------------------|--------------------------------|
| Compile-time safety | Yes — wrong profile type doesn't compile | No — any `&str` accepted |
| Refactoring scope | Large — all 12+ cache fns + all callers must change type | Zero |
| Code verbosity | Adds `.0` dereferences and `Profile::from` coercions | Cleaner call sites |
| Interop with Config | `active_profile_name` would change from `String` to `Profile` | No change |
| Discovery cost | New cache fn callers are guided by the type | Contributor may accidentally omit the profile arg |

## Decision

**Accepted (amended).** Un-defer the type-level hard fence. Introduce a `Profile(String)`
newtype and thread it through every per-profile boundary the soft fence today protects by
convention only:

1. `pub struct Profile(String)` with `impl From<String> for Profile`, `impl AsRef<str> for
   Profile`, and a `Display` impl (call sites that currently interpolate `profile: &str`
   directly into format strings — error messages, cache-path joins, keychain key
   construction — must keep working without a wrapper-visible behavior change).
2. Every `cache::{read_*,write_*,clear_*,invalidate_*}` function signature changes
   `profile: &str` → `profile: &Profile` (12+ functions in `src/cache.rs` as of this
   writing; the exact count is whatever `src/cache.rs` has grown to by the time
   `S-cycle3-adr0011-newtype` lands — cycle-003's own DEC-315 credential work adds new
   per-profile keychain functions in `src/api/auth.rs`, not `src/cache.rs`, so it does
   not by itself grow this function count, but see Sequencing below).
3. `Config::active_profile_name: String` → `Profile`.
4. `JiraClient::profile_name: String` → `Profile`.
5. Fix all call sites — ADR-0011's original estimate was "~50-70 changes"; DEC-317's own
   rationale for un-deferring THIS cycle is that DEC-315's credential normalization
   "multiplies cross-profile scoping call-sites," so the realized count at
   implementation time is expected to be at or above that original estimate, not below
   it.

**Sequencing (binding on the F4 implementation story, not just a suggestion):** the newtype
call-site sweep is sequenced to land AFTER cycle-003's per-profile credential-storage and
migration stories (`S-cycle3-percred-storage`, `S-cycle3-percred-migration`) are stable — see
`.factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`
§ Sequencing for the full cross-story ordering. Landing the newtype first would mean sweeping
the call-site surface once, then re-sweeping it again once the credential restructuring adds
new per-profile call sites — the same rework this ADR's Condition #3 exists to avoid.

This is a **pure Rust type-level change with zero on-disk, keychain, or wire-format impact**
(§4.5 of the F1 delta analysis, `.factory/cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md`).
No data migration, no cache-root version bump, no keychain-namespace change. All risk is
mechanical (a large, compiler-checked call-site diff), not behavioral.

## Conditions for Revisiting (historical — retained for record)

This decision was to be revisited in v0.6.0 or later if any of the following occurred:
1. A cache cross-profile leakage bug is discovered in a released version (i.e., the soft
   fence fails in practice) — **NOT met.** No such bug has been reported as of this
   amendment.
2. The contributor count grows beyond ~5 active committers (convention enforcement weakens
   with team size) — **NOT met.**
3. A related refactor (e.g., a major config overhaul) creates a natural migration window —
   **MET.** Cycle-003 (`auth-profile-dx`, DEC-312..319) is that refactor; see Status above.

## Consequences

### Positive
- Closes NFR-SCA-2 (soft-fence, previously `DEFER` in `nfr-catalog.md`) — the F2 PRD-supplement
  pass tracks this NFR's status change alongside this ADR (F1 delta analysis §1.1/§1.5; not
  edited by this architecture pass).
- A profile-unaware cache reader, or a hardcoded-string call site, becomes a compile error
  instead of a silent cross-profile leakage risk — the exact failure mode ADR-0007
  (multi-profile fields bug) demonstrated was reachable under the soft-fence convention alone.
- The compiler becomes the primary regression safety net for cross-profile isolation going
  forward, superseding "code review is the enforcement gate" as the sole control.

### Negative / Trade-offs
- Large, mechanical diff (~50-70+ call sites) — reviewable primarily by "does it compile and
  do existing cross-profile isolation tests still pass," not by manual per-site correctness
  reasoning (a WRONG-but-compiling `Profile` value substitution is not caught by the type
  system alone — F1 delta analysis §3 "Cross-profile cache leakage during ADR-0011 newtype
  threading," classified MEDIUM-mechanical-churn / LOW-post-landing risk).
- Adds `.0`/`AsRef<str>` friction at call sites that previously took a bare `&str` — accepted
  as the intended cost of the hard fence (see the original trade-off table above, unchanged).
- Interop with `Config`/`JiraClient` requires updating their field types in the same change —
  not a standalone `cache.rs`-only patch.

### Status as of this amendment (2026-09-01, cycle-003 F2)
**Accepted, not yet implemented.** No `src/` file has changed as a result of this ADR
amendment. Implementation is tracked as story `S-cycle3-adr0011-newtype` (F1 delta analysis
§2, item 5), sequenced after the credential-storage/migration stories per Sequencing above.
`src/cache.rs`'s functions, `Config::active_profile_name`, and `JiraClient::profile_name` all
still use `&str`/`String` as of this writing — this ADR describes the target design the F4
implementation will execute, not a completed migration.

## See Also

- `src/cache.rs` — all per-profile cache read/write functions (soft-fence convention today;
  hard-fence target per this amendment)
- `src/config.rs::Config` — `active_profile_name` field
- `src/api/client.rs::JiraClient` — `profile_name` field and `profile_name()` accessor
- ADR-0007 — Multi-profile fields fix (parallel profile-correctness decision; the concrete
  bug class this hard fence is designed to make uncompilable)
- `.factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`
  — the DEC-315 credential-restructuring ADR whose call-site growth is this amendment's
  stated trigger, and which this ADR's implementation is sequenced after
- `.factory/cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` §1.1, §1.3, §1.5, §3,
  §4.5 — the impact analysis this amendment is grounded in
- `.factory/architecture/risk-register.md` R-L1 — cites this ADR's (formerly Deferred) status;
  flagged for a follow-up update in `.factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md`
  § Flagged Follow-Ups
