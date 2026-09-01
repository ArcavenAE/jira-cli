---
document_type: adr
adr_id: ADR-0020
status: Accepted
date: 2026-09-01
subsystems_affected: ["SS-02", "SS-03", "SS-08"]
supersedes: null
superseded_by: null
related: ["ADR-0006", "ADR-0007", "ADR-0011", "ADR-0013"]
---

# ADR-0020: Per-Profile Credential Ownership, Environment Tagging, and OAuth-Default-at-Creation

## Status

**Accepted** (2026-09-01). Gate: F2 spec evolution for the `auth-profile-dx` bundle (Feature
Mode cycle-003; DEC-312 through DEC-316 in `.factory/STATE.md`'s Decisions Log). Combines
three decisions the F1 delta analysis recommended treating as one ADR
(`.factory/cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` §1.3, Open Question 3)
because they share one "config overhaul" window and are causally linked — DEC-317's un-defer
of ADR-0011 is explicitly justified by this ADR's credential normalization multiplying the
cross-profile scoping surface.

> **NOTE — factory-artifact placement, not yet an F4 code artifact.** This ADR governs new
> functions in `src/api/auth.rs` (`store_api_token(profile, …)` / `load_api_token(profile)`
> and their migration/clear-path siblings), a new field on `src/config.rs::ProfileConfig`,
> and CLI-surface changes in `src/cli/auth/{login,logout,remove,mod}.rs` and `src/cli/mod.rs`
> — none of which exist in this shape in `src/` as of this writing (F2). It is a companion
> to ADR-0011's amendment (`docs/adr/0011-type-level-profile-fence.md`), which this ADR's
> Decision §1/§2 is the stated trigger for. The corresponding product-repo file
> (`docs/adr/00NN-*.md`, next number after 0016 in that directory's own sequence) is an **F4
> story deliverable**, created in a worktree via PR when implementation lands — it is NOT
> created here. This factory artifact is the sole ADR-0020 record until F4 promotes it.

## Context

`jr` supports two coequal authentication mechanisms — OAuth 2.0 (3LO, embedded app per
ADR-0006) and API-token Basic auth — selected per-profile via `ProfileConfig.auth_method`.
Today's keychain layout is a **mixed-scoping invariant**: OAuth tokens are already
per-profile-namespaced (`<profile>:oauth-access-token` / `-refresh-token`, established when
multi-profile support landed), but API-token credentials (`email`, `api-token`) are **shared,
account-level, flat keys** — one email/token pair for the entire keychain, regardless of how
many profiles exist (`.factory/cycles/cycle-003/investigation/auth-profile-current-state.md`
§A.4, "Keychain layout (single service, mixed scoping)"). This asymmetry is a real, in-tree
invariant today: CLAUDE.md's "Per-profile vs shared OAuth keys" Gotcha and BC-1.4.027
("Shared keys… are NOT namespaced") both document it as current, intentional behavior — not
a bug. This ADR **reverses** that invariant for API-token credentials.

`auth_method` itself is a config field a profile happens to carry, not a property `jr`
treats as fixed at creation: `jr auth login` (bare) defaults to the API-token flow, while `jr
init`'s interactive picker already defaults to OAuth (`src/cli/init.rs::handle_init`'s
`Select::new().items(&["OAuth 2.0 (recommended)", "API Token"]).default(0)` prompt) — a
pre-existing inconsistency the current-state brief flags as "the seam the 'make OAuth
default' ask is really about" (§A.3). `jr auth refresh` additionally accepts a
per-invocation `--oauth` override (`src/cli/auth/mod.rs::chosen_flow_for_profile`) that can
select a different mechanism than the profile's own `auth_method` for that one call — the
only place in the codebase where a per-command flag currently outranks the profile's stored
mechanism.

Profiles also carry no structured notion of "kind" beyond `auth_method` itself
(current-state brief §B.5): no environment/role tag, no site-role grouping. Human-confirmed
scope (DEC-314) asks for a lightweight, additive `env`/role tag (prod/sandbox/uat) — NOT a
structural profile-kind system; per-profile `url` remains the actual environment lock
(profile = environment + identity), and platform-vs-JSM dispatch stays per-command as today.

**Carried-forward constraints (unaffected, confirmed in the F1 pass and re-confirmed here):**
- **ADR-0006** — embedded `jr` OAuth app, fixed callback port `53682`, BYO escape hatch.
  Nothing in this ADR touches the embedded-app resolution chain, the callback listener, or
  which app credentials are used — only which mechanism is chosen *by default* and how the
  *user's own* credentials (not the OAuth app's) are stored per profile.
- **ADR-0013** — PKCE deferral. Orthogonal; this ADR does not touch the OAuth authorization
  flow itself.
- **SD-002** (`.factory/architecture/security-decisions/SD-002-jr-auth-header-prod-gating.md`)
  — `JR_AUTH_HEADER`/`JR_BASE_URL` debug-only release gates. Unaffected; no new production
  env-var seam is introduced by this ADR (see § Alternatives Considered on why a keychain
  version marker, which WOULD need one, is rejected).
- **Single-use refresh tokens + `refresh_coordinator.rs` single-flight.** Unaffected — this
  ADR governs credential *storage location*, not the refresh grant or its concurrency
  control.
- **Windows Credential Manager posture (SEC-WCM-DOC).** Unaffected — per-profile namespacing
  is a key-naming change, not a storage-backend or isolation-boundary change.
- **ADR-0007** (multi-profile fields fix) is this ADR's direct precedent, not a dependency:
  it established "per-profile data read from `ProfileConfig`, never a shared/global fallback"
  as the correctness pattern for `story_points_field_id`/`team_field_id`. This ADR extends
  that same pattern from config-file fields to keychain-stored credentials. Referencing
  ADR-0007 here because its Option-A rationale ("no fallback to a shared struct that will
  silently be wrong for a second profile") is structurally identical to why this ADR's
  migration (§ Decision 2) is a one-time copy-and-delete, not a permanent shared+override
  fallback.

## Decision

We adopt the following, as one coherent change to the profile/credential model:

### 1. Per-profile API-token credential storage (DEC-315)

New keychain functions in `src/api/auth.rs`, mirroring the existing OAuth-token functions
byte-for-byte in shape:

```rust
fn api_token_email_key(profile: &str) -> String { format!("{profile}:email") }
fn api_token_key(profile: &str) -> String { format!("{profile}:api-token") }

pub fn store_api_token(profile: &str, email: &str, token: &str) -> Result<()> { /* … */ }
pub fn load_api_token(profile: &str) -> Result<(String, String)> { /* … */ }
```

This is a straight signature change from today's `store_api_token(email, token)` /
`load_api_token()` (no `profile` parameter — flat keys) to a profile-scoped pair symmetric
with `store_oauth_tokens(profile, …)` / `load_oauth_tokens(profile)`. `client.rs`'s
`JiraClient::load_auth_from_keychain`'s `api_token` branch (today's `_ => { let (email,
token) = crate::api::auth::load_api_token()?; … }`) switches to
`load_api_token(profile_name)`. `login_token` (`src/cli/auth/login.rs::login_token`) writes
to the per-profile pair instead of the flat one. The shared/flat `oauth_client_id` /
`oauth_client_secret` keys (the BYO **OAuth app** credential pair, a different axis from the
**user's** login credentials) are explicitly **out of scope** — they remain shared, since a
BYO OAuth app registration is inherently one-per-keychain, not one-per-profile.

### 2. One-time lazy `"default"`-only migration (DEC-315)

`load_api_token(profile)` mirrors `load_oauth_tokens`'s exact migration discipline
(`src/api/auth.rs::load_oauth_tokens`) as of this writing:

1. Try the namespaced keys (`<profile>:email`, `<profile>:api-token`) first.
2. If BOTH namespaced keys are absent AND `profile == "default"`: read the legacy flat
   `email` / `api-token` keys; if both present, copy them to the namespaced pair
   (`store_api_token("default", …)`), best-effort-delete the legacy pair (`Ok(()) |
   Err(NoEntry)` treated as success, matching `load_oauth_tokens`'s delete semantics), and
   return the copied values.
3. Any other profile with absent namespaced keys — or `"default"` with an absent/partial
   legacy pair — surfaces the same actionable "no stored credential" error
   `load_oauth_tokens` already produces for its non-default case, not a silent failure.
4. Partial-state handling (one of `email`/`api-token` present, the other absent) gets its
   own instance of `load_oauth_tokens`'s partial-recovery-then-explicit-error branch — try
   legacy recovery for `"default"`, else a clear "run `jr auth logout`/`jr auth login`
   to restore a clean state" error, never a silent misread.

**Trigger:** lazy, on first read — no eager config-load-time migration (unlike the TOML
`[instance]` → `[profiles.default]` migration, which must run before any profile is
resolvable at all; this migration has no such ordering dependency). **Idempotency:** a second
read short-circuits at step 1 — no-op, byte-identical result. **Scope discipline:** this
migration only fires when `load_api_token` is called for an `api_token`-method profile; it
never fires for, or conflates with, the OAuth token migration, which is separate code
operating on separate keys.

**Backward compat / rollback:** identical posture to the existing OAuth migration — no
automated rollback; a user reverting to a pre-cycle-003 binary after migration has run
would need to re-run `jr auth login` (the legacy flat keys are deleted post-migration). This
is the SAME accepted posture `docs/specs/multi-profile-auth.md`'s "Rollback story (manual
only)" already documents for the OAuth-token migration — not a new risk this ADR introduces.

### 3. Keychain/cache namespace version bump: cache-only if any bump happens at all (resolves F1 Open Question 1)

No new keychain version marker (e.g. `<profile>:v2:api-token`) is introduced. The
credential-KIND is already disambiguated by key suffix (`:email`/`:api-token` vs.
`:oauth-access-token`/`:oauth-refresh-token`); the profile-name prefix is, and remains, the
only namespacing keychain has ever needed. Inventing a version segment would be genuinely
novel, unproven surface for data that (unlike cache) is not disposable — losing a stored
OAuth refresh token or API token means a full re-auth, not a slow refetch. If a cache-root
`v1→v2` bump is separately judged worthwhile at F3/F4 story-authoring time, it reuses the
EXISTING, already-documented, disposable lever (`src/cache.rs::cache_dir`,
`cache_root().join("v1").join(profile)` — BC-6.2.004/BC-6.2.016) and is orthogonal to this
ADR's keychain decision.

### 4. Additive `env`/role tag (DEC-314)

`src/config.rs::ProfileConfig` gains one new field:

```rust
pub struct ProfileConfig {
    // …existing fields…
    /// Free-form environment/role tag (e.g. "prod", "sandbox", "uat"). Additive,
    /// tolerant: absent in old configs deserializes as `None`. Not validated
    /// against a fixed enum — `url` remains the actual environment lock; this
    /// tag is a human-readable label, not an access-control boundary.
    pub env: Option<String>,
}
```

`#[serde(default)]` behavior is already implicit for `Option<T>` fields in this struct's
existing derive (every other `ProfileConfig` field is `Option`, and none carry an explicit
`#[serde(default)]` attribute today — `serde` gives `Option<T>` a default-`None`-on-absence
reader without one). No forced cache/keychain namespace bump for this field alone (DEC-314's
own wording) — purely additive, zero migration.

**Surfacing:** `env` appears in `auth list --output json` and `auth status`'s JSON/text
output unconditionally (every profile's `env` value, `null`/absent when unset). For `auth
list`'s human table output, this ADR recommends adding `env` as a fifth column — the tag's
entire purpose (distinguishing prod/sandbox/uat profiles at a glance) is defeated if it is
JSON-only, and `auth list` is the one place a human scans all profiles side-by-side. This is
an explicit, acknowledged **breaking change** to BC-1.6.046's pinned 4-column insta-snapshot
(see § Breaking-Change Acknowledgment). This recommendation resolves F1 Open Question 7 at
the architecture level; the product-owner's BC authoring pass formalizes the exact column
placement/header text and updates the snapshot.

No enum/allowlist validation is imposed on `env`'s value — free text, matching DEC-314's
"prod/sandbox/uat" framing as examples, not an exhaustive set. If a future cycle wants
enum-validated values, that is a separate, additive change to make later without touching
this ADR's storage decision.

### 5. `auth_method` as an intrinsic, creation-time-only profile property (DEC-313)

- `jr auth login` (bare, interactive, no flags) presents the SAME `["OAuth 2.0
  (recommended)", "API Token"]` picker `jr init` already uses, defaulting to OAuth
  (`.default(0)`) — closing the A.3 inconsistency the current-state brief documents.
- **Non-interactive** `auth login` (`--no-input`, non-TTY stdin, or `JR_EMAIL`/
  `JR_API_TOKEN` present) selects API-token and NEVER launches a browser — this is a
  byte-for-byte regression-safety pin on DEC-313's explicit "CI stays token-first"
  guarantee, not a new capability.
- A new explicit `--api-token` flag is added to `LoginArgs`/`RefreshArgs`
  (`src/cli/mod.rs::AuthCommand::Login`/`Refresh`) as `--oauth`'s coequal, symmetric
  opt-in — resolving F1 Open Question 5 in favor of an explicit flag rather than
  interactive-picker-only creation-time selection, since non-interactive users need an
  unambiguous way to declare `api_token` even when `JR_EMAIL`/`JR_API_TOKEN` aren't yet
  set (e.g., scripting a fresh profile creation with `--email`/`--token` flags instead of
  env vars).
- `--oauth` is retained as a **deprecated-but-accepted alias**: unchanged functional
  behavior, plus a stderr-only deprecation notice (human mode only, consistent with the
  Output-channels convention — never on stdout, preserving `--output json` cleanliness per
  the #526 JSON-render invariant) pointing at creation-time semantics. No removal date is
  set (F1 Open Question 4 remains open — a follow-up removal story, if any, is a later
  cycle's decision, not architecture's to schedule here).
- `JiraClient::from_config`'s `.unwrap_or("api_token")` runtime default for an unset
  `auth_method` (`src/api/client.rs`, `let auth_method = profile.and_then(|p|
  p.auth_method.as_deref()).unwrap_or("api_token")`) is **unchanged, byte-for-byte**. This
  is the exact mechanism DEC-313 requires NOT to flip — an unset `auth_method` (hand-edited
  config, or a future profile-creation path that omits it) continues to attempt api-token
  auth, never a silent OAuth attempt against absent tokens.
- `Config::base_url`'s `profile.auth_method.as_deref() == Some("oauth")` branch is
  unaffected — it already reads the intrinsic per-profile field; nothing about DEC-313
  changes how the gateway URL is chosen once `auth_method` is set.

### 6. `auth refresh`'s `--oauth`/`--api-token` become pure deprecated aliases with no override power (resolves F1 Open Question 8)

`chosen_flow_for_profile` (`src/cli/auth/mod.rs::chosen_flow_for_profile`) today lets a
per-invocation `--oauth` flag override the target profile's stored `auth_method` for that
one `refresh` call. DEC-313's "every invocation auto-selects the profile's mechanism… no
per-command auth switch" language is read literally here: `refresh` always follows the
profile's intrinsic `auth_method`, with **no override**, full stop — `--oauth`/
`--api-token` on `refresh` become syntactically accepted (so existing scripts passing
`--oauth` don't hard-error) but behaviorally inert aliases carrying the same deprecation
notice as `login`'s. `chosen_flow_for_profile`'s `oauth_override: bool` parameter is
removed (or ignored) at the F4 implementation step; `refresh`'s "clear-then-relogin" always
relogs in via the profile's own `auth_method`. This closes the one place in the current
codebase where a per-command flag outranks the profile's stored mechanism, making
`auth_method` genuinely intrinsic rather than intrinsic-with-an-escape-hatch.

### 7. `auth remove`/`auth logout` scope extension for per-profile API-token credentials (resolves F1 Open Question 6)

- **`auth remove`** (`src/cli/auth/remove.rs::handle_remove`) gains a fourth delete step:
  the per-profile `<profile>:email`/`<profile>:api-token` pair, alongside its existing
  three (config entry, cache subdir, per-profile OAuth pair). This makes `remove`'s
  "delete everything this profile owns" contract symmetric across both credential kinds —
  the profile now genuinely owns its API-token credential the same way it owns its OAuth
  tokens, so removal must cover both.
  `clear_profile_creds`/`clear_all_credentials` (`src/api/auth.rs`) each gain the
  per-profile API-token pair as an additional deletable-key branch, following the exact
  same `NoEntry`-is-success aggregation pattern already used for the OAuth pair.
- **`auth logout`** (`src/cli/auth/logout.rs::handle_logout`) remains **OAuth-specific by
  design** — it does not grow API-token-clearing behavior. Rationale: "logout" is a
  session-clear concept (end a live OAuth session, keep the profile ready for frictionless
  re-login); API-token auth has no session to end, only a credential to either keep or
  delete outright — and "delete the credential outright" is `remove`'s job, not a
  session-scoped `logout`'s. A `jr auth logout` on an `api_token`-method profile remains a
  no-op for that profile's credentials (by design, not by omission) — this ADR makes that
  omission an explicit, documented decision rather than leaving it implicit.

## Rationale

- **DEC-315's per-profile credential model is the direct architectural extension of
  ADR-0007's precedent.** ADR-0007 established that per-profile data (`story_points_field_id`,
  `team_field_id`) must be read from `ProfileConfig` with NO shared-struct fallback, because a
  fallback silently serves the wrong data to a second profile. The identical failure mode
  applies to credentials: a shared `email`/`api-token` pair silently authenticates every
  profile as the SAME Jira account, defeating the entire premise of "environment-locked
  profiles" (prod/sandbox/uat) DEC-312 names as this cycle's goal. A profile whose `url`
  points at a sandbox site but whose credentials are silently shared with a prod-profile's
  login is not environment-locked at all.
- **Migration discipline reuses proven code shape, not proven code.** The OAuth-token lazy
  migration (`load_oauth_tokens`) is not itself touched by this ADR, but its shape — try
  namespaced first, `"default"`-only legacy fallback, best-effort delete-after-copy,
  non-default profiles never inherit — is the validated pattern this ADR's new API-token
  migration copies exactly. This is a proven PATTERN, not proven CODE (the F1 delta analysis'
  own §3 caveat); the new migration needs its own direct-ported test suite, not a
  "should just work" assumption.
- **`--oauth` deprecation-not-removal preserves the existing `auth switch --profile`
  rejection precedent (BC-1.2.047/S-663-1) as a model:** the repo has already shipped one
  documented, deliberate CLI-surface break in the `auth` family when the alternative was
  worse (silent, ambiguous behavior). Retaining `--oauth` functionally while demoting it to
  an alias is the more conservative version of that same precedent — no script that passes
  `--oauth` today breaks.
- **Cache-only versioning (§3) avoids inventing unproven, non-disposable-data infrastructure
  for a namespace collision that does not exist.** Keychain keys are already disambiguated by
  both profile prefix and kind-suffix; a version segment would solve a problem this layout
  does not have.

## Alternatives Considered

- **Flat bag (status quo, do nothing):** keep `email`/`api-token` shared account-level.
  Rejected — this is precisely the invariant DEC-312 (environment-locked profiles) requires
  reversing; a shared credential pair cannot lock a profile to a distinct Jira account/site.
- **Nested namespace** (`[profiles.<kind>.<name>]`, or a `[credentials.<profile>]` config
  table separate from `[profiles.<name>]`): rejected per the modern-CLI research brief
  (`.factory/cycles/cycle-003/investigation/modern-cli-auth-profile-research.md`) — this
  would be a structural config-schema change beyond DEC-314's explicitly "lightweight,
  additive" framing, and duplicates information (`profile` identity) across two config
  locations for no benefit the flat `[profiles.<name>]` + namespaced-keychain-key model
  doesn't already provide more simply.
- **`kubectl`-style three-table model** (separate `clusters`/`users`/`contexts` tables with
  a profile as a named combination of the three): rejected — this is the heaviest structural
  option and was explicitly out of scope per DEC-314's rejection of a "structural profile-kind
  system" in favor of a single additive tag; it would also require a genuinely new migration
  (splitting today's single `[profiles.<name>]` table into three) that DEC-315's scope
  (a keychain-layout change, not a config-schema restructuring) does not call for.
- **Keychain version marker as part of this migration** (§3's rejected alternative): would
  solve a disambiguation problem that does not exist (credential kind is already
  suffix-disambiguated) at the cost of inventing new, non-disposable-data versioning
  infrastructure with no existing lever to reuse (unlike cache's `v1/` path segment).

## Consequences

### Positive
- Closes the shared-credential correctness gap DEC-312 names as this cycle's motivating
  problem — profiles become genuinely environment-locked (`url` + now-owned credentials).
- OAuth and API-token credential storage become symmetric (`<profile>:oauth-*` and
  `<profile>:email`/`<profile>:api-token` follow one naming convention), simplifying the
  mental model for anyone reading `src/api/auth.rs` and reducing the surface ADR-0011's
  hard fence (once implemented) needs to special-case.
- `--api-token`'s addition gives non-interactive profile creation an explicit, unambiguous
  declaration path that does not depend on env-var presence alone.

### Negative / Trade-offs
- **Highest-risk new code path in the cycle** (F1 delta analysis §3): the migration touches
  the auth-header composition hot path (`JiraClient::from_config` → every HTTP call). A bug
  here risks either silent auth failure for existing users on upgrade, or — worse — a
  security-relevant leak if migration copies credentials to the wrong profile. Mandatory
  mitigations: direct-ported unit tests mirroring `load_oauth_tokens`'s three proof shapes,
  a keyring-gated end-to-end migration test, and an idempotency test (F1 delta analysis §3
  table, row 1).
- `env`-as-table-column is a deliberate, acknowledged break to a pinned insta-snapshot (see
  below) — not a cost-free addition.
- `--oauth`'s open-ended deprecation window (no removal date) means the CLI surface carries
  a permanently-documented legacy alias until a future cycle decides otherwise.

### Status as of this ADR (2026-09-01, cycle-003 F2)
**Accepted, not yet implemented.** No `src/` file has changed. This ADR is the design F4's
delta-implementation stories execute against; the product-owner's F2 BC-authoring pass (a
separate, parallel F2 pass) is responsible for the concrete BC text this ADR's decisions
imply (F1 delta analysis §1.2 lists ~9-13 candidate new/amended BCs).

## Breaking-Change Acknowledgment

- **`--oauth` demotion to deprecated-but-accepted alias** (Decision §5/§6): functionally
  non-breaking (existing invocations keep working byte-for-byte) but introduces a new
  stderr deprecation line — scripts asserting exact stderr content could break. Mitigated by
  keeping the notice stderr-only (never stdout) and the underlying behavior unchanged.
- **`auth list`'s `env` table column** (Decision §4): a genuine, deliberate break to
  BC-1.6.046's pinned 4-column insta-snapshot — the snapshot must be regenerated as part of
  the implementing story, and the BC's contract text must be amended (not silently
  re-pinned) to describe 5 columns. Precedent: BC-1.2.047 (`auth switch --profile`
  rejection) already establishes that documented auth-family CLI breaks are acceptable when
  the alternative (an invisible-to-humans tag) undermines the feature's own purpose.
- **`auth refresh --oauth` losing its override power** (Decision §6): behavior-changing for
  any script relying on `jr auth refresh --oauth` to force an OAuth relogin on a profile
  whose stored `auth_method` is `api_token`. This is a narrow, intentional behavior change
  DEC-313's "no per-command auth switch" invariant requires; flagged explicitly here since
  it is easy to miss (the flag still parses and no error is raised — the behavior silently
  narrows rather than erroring).
- **`auth remove`'s fourth delete step** (Decision §7): non-breaking additively — `remove`
  already deletes profile-owned artifacts; this makes an existing artifact (the API-token
  credential) one of them, which is a bugfix-shaped completion of `remove`'s existing
  contract, not a new destructive capability.

## Sequencing

Recommended land order (mirrors, and is authoritative for, the F1 delta analysis' preliminary
story list §2):

1. `env` tag (Decision §4) — pure-additive, zero dependencies, can land first and
   independently.
2. Per-profile credential storage functions (Decision §1) — no dependencies.
3. Lazy migration (Decision §2) — depends on #2 (needs the per-profile reader/writer to
   exist).
4. `auth remove`/`auth logout` scope extension (Decision §7) — depends on #2/#3.
5. **ADR-0011's `Profile` newtype threading** — depends on #2/#3/#4 landing first, so the
   call-site sweep covers the enlarged, post-restructuring surface exactly once (see
   ADR-0011's amended text, § Sequencing).
6. OAuth-default-at-creation + `--oauth`/`--api-token` flag surface (Decision §5) — depends
   on #2/#3, so newly-OAuth-defaulted profiles' sibling API-token path is already on the new
   per-profile storage model.
7. `chosen_flow_for_profile`/`auth refresh` reconciliation (Decision §6) — depends on #6.

## Source / Origin

- `.factory/cycles/cycle-003/investigation/auth-profile-current-state.md` — current-state
  grounding, especially §A.3 (login-default inconsistency), §A.4 (keychain layout being
  reversed), §B.5 (no structural profile-kind today).
- `.factory/cycles/cycle-003/investigation/modern-cli-auth-profile-research.md` — modern-CLI
  research (39 sources) behind the rejected nested-namespace and three-table alternatives.
- `.factory/STATE.md` Decisions Log, DEC-312 through DEC-316 — the confirmed scope this ADR
  designs against.
- `.factory/cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md` — impact boundary,
  BC/ADR/module inventories, regression risk table, migration surface, and the eight Open
  Questions this ADR resolves (§1, §2 numbers above map to that report's Open Questions
  1/3/5/6/7/8; Open Question 4's window-length question is explicitly left open, not
  architecture's call).
- `src/api/auth.rs::load_oauth_tokens`, `::store_oauth_tokens`, `::clear_profile_creds`,
  `::clear_all_credentials` — the existing per-profile OAuth pattern this ADR's API-token
  functions mirror.
- `src/api/client.rs::JiraClient::from_config`, `::load_auth_from_keychain` — the auth-header
  composition hot path this ADR's migration must not regress.
- `src/config.rs::ProfileConfig`, `::base_url` — the schema this ADR extends and the
  `auth_method` branch it leaves unchanged.
- `src/cli/init.rs::handle_init` — the existing OAuth-default interactive picker this ADR's
  `auth login` creation-time default mirrors.
- `src/cli/auth/mod.rs::chosen_flow_for_profile` — the per-command override this ADR
  removes.
- ADR-0006, ADR-0007, ADR-0011 (amended), ADR-0013 — carried-forward/precedent/companion
  decisions cited throughout.
