---
document_type: delta-analysis-report
feature_name: "auth-profile-dx (cycle-003)"
created: 2026-09-01
spec_version_at_analysis: "BC-INDEX v6.82 (719 BCs / 32 VPs / 106 holdouts, unchanged this analysis)"
status: draft
intent: enhancement
feature_type: backend
scope: standard
severity: "N/A"
producer: architect
inputs:
  - ".factory/cycles/cycle-003/investigation/auth-profile-current-state.md"
  - ".factory/cycles/cycle-003/investigation/modern-cli-auth-profile-research.md"
  - ".factory/STATE.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/prd/bc-6-config-cache.md"
  - ".factory/specs/prd/nfr-catalog.md"
  - "docs/adr/0006-embedded-jr-oauth-app.md"
  - "docs/adr/0007-multi-profile-fields-fix.md"
  - "docs/adr/0011-type-level-profile-fence.md"
  - "docs/adr/0013-pkce-deferral.md"
  - "docs/specs/multi-profile-auth.md"
  - "docs/specs/oauth-scopes-configurable.md"
traces_to: ".factory/STATE.md#DEC-312..DEC-319"
input-hash: "344ff59"
---

# F1 Delta Analysis: auth-profile-dx (cycle-003)

## Feature Request

- **Brief:** Make OAuth the default auth mechanism; restructure `jr` auth so authentication
  is an intrinsic per-profile property with per-profile credential ownership, enabling
  environment-locked profiles (prod/sandbox/uat). Scope CONFIRMED by the human at the
  senior-architect gate on 2026-09-01 as DEC-312 through DEC-319 (`.factory/STATE.md`
  Decisions Log). This report does not re-decide scope — it maps impact against it.
- **Requested by:** human, at senior-architect scope gate, following grounded investigation
  (`cycles/cycle-003/investigation/auth-profile-current-state.md`) and modern-CLI research
  (`cycles/cycle-003/investigation/modern-cli-auth-profile-research.md`, 39 sources).
- **Date:** 2026-09-01.

## Classifications

**Intent:** `enhancement`. DEC-312's own framing ("make OAuth the default", "restructure
auth") is improve/change language on an existing subsystem, not a net-new capability
grafted onto an unrelated surface. It has a `feature`-shaped edge (per-profile credential
ownership and the `env` tag are genuinely new BCs, not modifications of existing ones) — the
routing is identical either way (Full F1-F7), so this does not change scope.

**Feature type:** `backend`. `jr` is CLI-only (no UI screens); every touch point is CLI
dispatch, config/keychain/cache modules, or documentation. No UX Spec is anticipated for
this cycle (matches the cycle-002 precedent — see STATE.md Skip Log "UX Spec (cycle-003,
tentative)" — this report recommends confirming that skip at the F1 gate).

**Trivial scope:** `standard` (NOT trivial). Fails every trivial criterion: touches ≥6
modules, requires ≥10 new BCs (see §1), requires at least one new ADR plus an amendment to
ADR-0011, and the shared-key credential migration is HIGH regression risk (see §3). Full
F1-F7 pipeline applies — no quick-dev routing.

**Severity:** N/A (not a bug-fix).

---

## 1. Impact Boundary

### 1.1 BCs to AMEND (existing contracts whose text becomes stale or incomplete)

| BC | File | What changes |
|----|------|---------------|
| BC-1.1.009 / BC-1.1.010 / BC-1.1.017 | `bc-1-auth-identity.md` §1.1/1.2 | "writes shared `email`/`api-token` keychain keys" → per-profile `<profile>:email`/`<profile>:api-token` keys (DEC-315). All three BCs' Behavior/Effects text cites the shared-key write as the observable effect of `auth login`. |
| BC-1.2.013 | `auth logout` deletes only `<profile>:oauth-*` | Currently states "Shared keys (`email`, `api-token`, …) untouched" as the contract. Under DEC-315 there is no longer one shared `email`/`api-token` pair for `logout` to leave untouched — the profile now owns its own token pair. Needs to state what `logout` does for an `api_token`-method profile (today: nothing, by omission — see Open Question 6). |
| BC-1.2.014 | `auth remove` three-step delete | Currently step 2 deletes only `<name>:oauth-*`. Under DEC-315, per-profile `email`/`api-token` become a fourth deletable artifact — this BC's "three-step" enumeration and the "shared api-token never touched" invariant both need to change (see Open Question 6). |
| BC-1.4.025 | `default`-only lazy legacy-OAuth-key migration | Needs a sibling clause (or a cross-reference to a new BC) describing the parallel api-token migration DEC-315 mandates, and must explicitly reconfirm this BC's OWN behavior is UNCHANGED by the credential restructuring (regression-risk item, §3). |
| BC-1.4.027 | Per-profile keychain keys: `<profile>:oauth-access-token`/`-refresh-token`; "Shared keys… NOT namespaced" | The second clause ("email, api-token… are NOT namespaced") becomes FALSE for `email`/`api-token` post-DEC-315 (they become namespaced; only `oauth_client_id`/`oauth_client_secret` remain shared/flat). Must be split or amended. |
| BC-1.4.029 | `load_oauth_tokens("sandbox")` does not inherit legacy | Needs a cross-reference (or new sibling BC) confirming the same non-inheritance holds for the new per-profile api-token reader. |
| BC-1.6.046 | `auth list` table: 4 columns, pinned snapshot | If the `env`/role tag (DEC-314) is surfaced as a table column, this BC's pinned 4-column/insta-snapshot contract breaks (Open Question 7). If `env` is JSON-only or `--verbose`-gated, this BC is unaffected — the decision changes whether this is AMEND or untouched. |
| BC-6.2.015 | Cache soft-fence convention (`profile: &str` first-arg, "no compile-time enforcement") | Un-deferring ADR-0011 (DEC-317) converts this from a documented **soft**-fence to a **hard** (compile-time) fence. The BC's own wording ("This is a soft fence (convention, not type system)") becomes false once `Profile` newtype lands; must be amended to describe the new enforcement mechanism. Its `Related: NFR-SCA-2` cross-reference should flip to a resolved-NFR reference. |
| NFR-SCA-2 (nfr-catalog.md) | "DEFER: Introduce `Profile(String)` newtype" | Status changes from `DEFER` to a resolved/FIX-IN-CYCLE state once ADR-0011 is un-deferred and implemented — this is an NFR-catalog edit, not a BC edit, but it is directly entailed by DEC-317 and must be tracked in F2. |

**Not amended (verified, cite for the record):** BC-1.1.007 (profile-resolution precedence — flag > env > config > default is unchanged by any of DEC-312..319), BC-1.2.018/BC-1.2.047 (`auth switch` global-`--profile` rejection — orthogonal to auth-method/credential changes; confirmed no interaction), BC-1.3.019–024 (embedded-app mechanics — untouched; DEC-313 changes only *default selection*, not the embedded-app resolution chain itself), BC-1.4.026/030 (`refresh_oauth_token` signature, keychain-over-embedded app-cred preference — these govern the BYO **OAuth app credential** resolver, a different axis from the **user's** per-profile credentials DEC-315 restructures), BC-1.5.031–041 (OAuth state machine — untouched; port 53682, PKCE deferral, state CSRF check are all orthogonal), BC-1.6.042–045 (401 dispatch/scope-mismatch taxonomy — untouched), BC-6.1.001–013 (legacy TOML migration mechanics — untouched; serves as the design PRECEDENT for the new migration, not a BC that itself changes), BC-6.2.001–014, 016–018 (generic cache mechanics, Windows path resolution, warm-hit invariant — untouched unless the `v1→v2` bump is adopted, in which case ONLY the version-literal in BC-6.2.004/6.2.016's prose needs a documentation update, not a behavioral rewrite), BC-6.3.001 (multi-profile fields MUST-FIX — already-shipped, unrelated axis).

**Rough count:** ~8 BCs to AMEND (7 in bc-1, 1 in bc-6, plus 1 NFR-catalog status edit).

### 1.2 BCs to ADD (new contracts)

Grouped by DEC:

**DEC-313 (auth_method as intrinsic profile property, OAuth-default-at-creation, `--oauth` deprecated alias):**
1. New BC: `auth login` (bare, interactive, no flags) defaults to the OAuth flow, mirroring `jr init`'s existing `["OAuth 2.0 (recommended)", "API Token"]` `.default(0)` picker (`src/cli/init.rs:95-99`) — closes the documented A.3 inconsistency in the current-state brief.
2. New BC: `auth login` in non-interactive mode (`--no-input`, non-TTY, or `JR_EMAIL`/`JR_API_TOKEN` present) selects API-token and NEVER launches a browser — an explicit REGRESSION-SAFETY contract pinning DEC-313's "CI stays token-first" guarantee (today this is implicit/absent as a BC; BC-1.1.011 covers a related-but-different failure path).
3. New BC: once `auth_method` is set at profile creation, no per-command flag or config re-read may change which mechanism a given invocation uses (the "no per-command auth switch" invariant) — a negative-space contract worth pinning given `chosen_flow_for_profile` (`cli/auth/mod.rs:107`) currently DOES accept a per-call `--oauth` override on `refresh` (Open Question 8).
4. New BC: `--oauth` on `auth login`/`auth refresh` is accepted but deprecated — behavior unchanged, but emits a deprecation notice (stderr, human mode only, consistent with the Output-channels convention) pointing at the new creation-time semantics.
5. New BC (contingent on Open Question 5): if a new `--api-token` explicit flag is introduced as `--oauth`'s coequal, its acceptance/precedence contract.
6. New BC: `client.rs::from_config`'s `.unwrap_or("api_token")` runtime default for an unset `auth_method` is explicitly UNCHANGED (a regression-safety pin, since this is the exact mechanism DEC-313 says must NOT flip).

**DEC-314 (additive `env`/role tag):**
7. New BC: `ProfileConfig.env: Option<String>` (or equivalent) is a free-form/enumerated tag; old profiles deserialize with `env: None`; tolerant reader confirmed no migration-required.
8. New BC: `env` tag surfaced in `auth list`/`auth status` output (JSON shape at minimum; table-column question is Open Question 7).
9. New BC (if a fixed enum `prod|sandbox|uat` is adopted instead of free text): validation/rejection contract for an unrecognized `env` value — TBD at F2, contingent on schema shape decided there.

**DEC-315 (per-profile credentials + one-time migration):**
10. New BC: `store_api_token`/`load_api_token`-equivalent functions become per-profile: `<profile>:email`/`<profile>:api-token`, symmetric with `<profile>:oauth-access-token`/`-refresh-token`.
11. New BC: one-time, lazy, on-read migration of shared flat `email`/`api-token` → `<default>:email`/`<default>:api-token`, mirroring `load_oauth_tokens`'s exact discipline (namespaced-keys-present short-circuit; `"default"`-only; best-effort delete-after-copy; non-default profiles never inherit) — this is the highest-risk new contract in the cycle (§3).
12. New BC: partial-state handling for the new per-profile api-token pair (email present, token absent, or vice versa) — mirrors BC-1.4.028's OAuth partial-state `Err`, needs its own instance for the new credential pair.
13. New BC (contingent on Open Question 1/2): if a keychain/cache `v1→v2` namespace bump is adopted, the orphaning/no-loss contract for old-root data.

**DEC-317 (ADR-0011 un-defer):**
14. Likely NOT a BC-level change (compile-time-only; behavior is identical, only enforcement timing changes) — tracked as an ADR/NFR-catalog change (§1.3, §1.4), not a new BC. Flagged here so F2 doesn't accidentally skip it for lack of a BC "home."

**Rough count:** ~9–13 new BCs (9 firm, up to 4 contingent on F2/Open-Question resolution), against a current corpus of 719 total / 58 in bc-1 / 43 in bc-6 — a ~1.3–1.8% corpus growth, concentrated entirely in bc-1 §1.1/§1.2/§1.4 and bc-6 §6.1/§6.2.

### 1.3 ADRs to author/amend

| ADR | Action | Rationale |
|-----|--------|-----------|
| **ADR-0011** (`Profile` newtype hard-fence) | **AMEND** (Status: Deferred → Accepted; rewrite Decision/Consequences to describe the now-executed newtype threading) | DEC-317 explicitly names this ADR's own documented revisit trigger #3 ("a related refactor… creates a natural migration window") as the reason to un-defer — the decision doesn't reverse, it confirms a documented condition was met. An in-place status flip (not a superseding ADR) is the natural fit; confirmed as Open Question 2 since this is a process-convention call, not purely technical. |
| **New ADR** (credential-layout + `env` tag + creation-time OAuth-default) | **AUTHOR** | DEC-315's shared→per-profile keychain restructuring is a genuine architectural reversal of an existing, ADR-adjacent invariant (the current-state brief's §A.4 keychain-layout table and CLAUDE.md's "Per-profile vs shared OAuth keys" Gotcha both describe the invariant being reversed) — this is exactly the class of decision ADR-0006/0007/0013 exist to record (alternatives considered, migration plan, rollback posture, breaking-change acknowledgment). Whether DEC-313 (OAuth-default-at-creation) and DEC-314 (`env` tag) ride in the SAME new ADR or get split out is Open Question 3; this report recommends ONE combined ADR given all three DECs share the same "config overhaul" window ADR-0011 itself names. |
| ADR number | **Flag, do not assume** | `docs/adr/` currently ends at `0016-windows-build-target.md`, but `ADR-0017`, `ADR-0018`, `ADR-0019` are already cited in prose (CLAUDE.md, CHANGELOG.md, `docs/specs/attachments.md`) for decisions that were never filed as `docs/adr/00NN-*.md` files (attachment retry, component shard rationale, field-dx context mechanism respectively). The next SAFE new ADR file number is **0020**, not 0017 — a collision-check against prose-only citations is mandatory before allocating, mirroring the DEC-namespace collision check already practiced for STATE.md's Decisions Log. This pre-existing drift (ADR IDs spoken for without files) is out of scope to backfill here but must not be silently perpetuated by picking a colliding number. |
| ADR-0007 (multi-profile fields) | **Cross-reference only, no amendment** | Its "per-profile field IDs must be read from ProfileConfig, not global" precedent is the model DEC-315 extends to credentials — cite it in the new ADR's Context, don't edit ADR-0007 itself (its own decision is unaffected). |
| ADR-0006 / ADR-0013 | **No change** | Embedded-app mechanics and PKCE deferral are both orthogonal to which mechanism is the *default* and how credentials are *stored per-profile*. Both are explicitly "Constraints Carried Forward" per STATE.md — confirmed unaffected by this pass. |

### 1.4 Modules to change (file-by-file)

| File | Nature of change |
|------|-------------------|
| `src/config.rs` | Schema: add `ProfileConfig.env: Option<String>` (DEC-314, additive, tolerant reader — `#[serde(default)]`). Possibly extend `validate_profile_name` or add a sibling validator if `env` gets an enum/allowlist (F2 decision). No change to `resolve_active_profile_name`/precedence chain. `base_url()`'s `#[cfg(debug_assertions)]` `JR_BASE_URL` gate pattern is the template to mirror for any NEW debug seam this cycle might introduce (Open Question 1's keychain-bump path, if it needs test isolation). |
| `src/api/auth.rs` | Keychain layout: new `store_api_token(profile, email, token)`/`load_api_token(profile)` (currently `store_api_token`/`load_api_token` take NO profile arg — flat). New migration function mirroring `load_oauth_tokens`'s `"default"`-only lazy-copy-then-delete logic (lines ~253-311 today). `clear_profile_creds`/`clear_all_credentials` (lines ~422/467) likely need a 4th deletable-artifact branch for per-profile `email`/`api-token` (Open Question 6). `resolve_refresh_app_credentials` (OAuth **app**-credential resolver) is UNCHANGED — different axis. |
| `src/api/client.rs` | `JiraClient::from_config` (lines ~73-86): `load_auth_from_keychain(auth_method, profile_name)` (line 124) currently reads flat `email`/`api-token` for the `api_token` branch — must switch to the new per-profile reader. The `.unwrap_or("api_token")` runtime default (line ~74-75) stays byte-for-byte per DEC-313 (regression-critical, §3). |
| `src/cli/auth/login.rs` | `login_token`/`login_oauth` write per-profile creds instead of shared. `handle_login`'s flow-selection branch (`args.oauth` → `login_oauth`, else `login_token`) gains the interactive-default-to-OAuth branch (mirroring `init.rs`) and the deprecated-alias notice for `--oauth`. |
| `src/cli/auth/keychain.rs` | `resolve_credential`/`resolve_oauth_app_credentials` — the OAuth-**app**-credential resolver chain (flag→env→keychain→embedded→prompt) is unaffected; only the **user**-credential resolution (email/token prompt/flag/env) changes storage target from flat to per-profile. |
| `src/cli/auth/status.rs` | `status()` — surface `env` tag; surface per-profile credential presence for `api_token` profiles the same way it already reports OAuth token presence; `peek_oauth_app_source` unaffected. |
| `src/cli/auth/list.rs` | `handle_list` — surface `env` in JSON always; table-column question is Open Question 7 (breaks the pinned BC-1.6.046 snapshot if added as a column). |
| `src/cli/auth/refresh.rs` | `refresh_credentials` (clear-then-relogin) — for `api_token` profiles, "clear" now means clearing PER-PROFILE creds, not shared ones; `chosen_flow_for_profile` interaction is Open Question 8. |
| `src/cli/auth/remove.rs` | `handle_remove` three-step delete gains (or doesn't — Open Question 6) a fourth step for per-profile `email`/`api-token`. |
| `src/cli/auth/logout.rs` | `handle_logout` — currently OAuth-only; Open Question 6 asks whether it grows api-token-clearing behavior or stays OAuth-specific by design. |
| `src/cli/mod.rs` | `AuthCommand::Login`/`Refresh` — `oauth: bool` field semantics change (demoted to deprecated alias); possible new `--api-token` field (Open Question 5). |
| `src/cli/init.rs` | Reference implementation for creation-time OAuth-default — likely UNCHANGED itself (already correct), used as the model `auth login`'s new default-selection logic mirrors. |
| `src/cache.rs` | Only touched if the `v1→v2` cache-root bump (Open Question 1) is adopted: the version literal in `cache_root()`'s path-join changes; NO other function signature changes. If ADR-0011's `Profile` newtype lands, every public fn here changes its `profile: &str` parameter to `profile: &Profile` (~12+ functions, per ADR-0011's own estimate of "~50-70 changes" across the whole call graph). |
| `docs/adr/0011-type-level-profile-fence.md` | Status flip + rewrite (§1.3). |
| `docs/adr/00NN-<new>.md` | New file (§1.3). |
| `docs/specs/multi-profile-auth.md` | Update: Config Schema section (add `env`), Keyring Layout section (per-profile credential table), Migration section (new migration domain #4 for api-token, alongside the existing 3), CLI Surface section (`--oauth` deprecation, any new flag). |
| `CLAUDE.md` | Multiple "Gotchas"/"Per-profile vs shared OAuth keys" entries become stale and must be updated in the SAME commit as the code change (per the repo's own "doc-fallout" convention cited repeatedly in CLAUDE.md itself); ADR-0011 Gotcha reference; any new `JR_*` env var per the codified pattern. |
| `tests/auth_profiles.rs`, `tests/multi_cloudid_disambiguation.rs`, `tests/oauth_refresh_integration.rs`, new `tests/*` for the api-token migration (mirroring `tests/migration_legacy.rs`) | See §3. |

### 1.5 NFRs affected

- **NFR-SCA-2** (soft-fence, DEFER) → resolved/closed by DEC-317 (§1.1, §1.3).
- **NFR-S-B** (`JR_AUTH_HEADER` unconditional read, listed SECURITY-DECIDE/undecided in nfr-catalog.md) — investigated and found **adjacent but NOT in scope**: CLAUDE.md's "AI Agent Notes" section documents this as already gated behind `#[cfg(debug_assertions)]` (mirroring the `JR_BASE_URL`/SD-002 pattern), which appears to postdate the nfr-catalog.md row's undecided status. **Flagged as a documentation-drift unknown** (nfr-catalog.md row vs. CLAUDE.md may be out of sync) — not this cycle's job to fix, but the F2 spec-evolution pass should confirm nfr-catalog.md's NFR-S-B row is updated to match reality rather than being silently left stale while this cycle touches adjacent auth code.
- **NFR-O-S** (`accessible-resources` first-wins, no `--cloud-id` disambiguation flag) — adjacent (also in `src/api/auth.rs`) but explicitly OUT of DEC-312..319's scope; not touched.
- No NFR in the Security dimension needs a NEW row for this cycle's own changes as currently scoped — the per-profile credential migration is a correctness/compatibility concern (tracked as regression risk, §3) rather than a net-new security posture change, PROVIDED the migration is implemented as a straight lazy-copy mirroring the existing OAuth pattern (no new attack surface). If a keychain `v1→v2` versioning MECHANISM is invented (Open Question 1, part C) rather than reusing cache's existing lever, that novel mechanism should get its own NFR-catalog row at F2 (unproven-safe until specified).

---

## 2. Stories (Preliminary — F3 Candidates, Not Yet Written)

Dependency order (top = land first). BC anchors are the §1.2 candidate IDs pending exact F2 numbering.

1. **S-cycle3-env-tag** — Add `ProfileConfig.env: Option<String>` + tolerant reader + surface in `auth list --output json`/`auth status`. BC anchors: DEC-314 new BCs #7-8. Depends on: none. Risk: LOW (pure-additive). Can land first and independently.

2. **S-cycle3-percred-storage** — New per-profile keychain functions (`store_api_token(profile,…)`/`load_api_token(profile)`); `login_token` writes per-profile; `load_auth_from_keychain`'s `api_token` branch reads per-profile. BC anchors: DEC-315 new BC #10. Depends on: none (can run parallel to #1).

3. **S-cycle3-percred-migration** — One-time lazy migration of shared flat `email`/`api-token` → `<default>:*`, mirroring `load_oauth_tokens`'s discipline exactly; partial-state handling (BC #11, #12). Depends on: #2 (needs the per-profile reader/writer to exist first). **Highest-risk story in the cycle — see §3.**

4. **S-cycle3-remove-logout-semantics** — Extend `auth remove`'s delete steps (and decide `auth logout`'s api-token behavior) for the new per-profile credential pair (Open Question 6). Depends on: #2/#3.

5. **S-cycle3-adr0011-newtype** — Un-defer ADR-0011: introduce `Profile(String)` newtype; thread through `cache.rs`, `Config.active_profile_name`, `JiraClient.profile_name` (~50-70 call sites per ADR-0011's own estimate). Depends on: recommend sequencing AFTER #2/#3/#4 land, so the newtype sweep covers the enlarged (post-restructuring) call-site surface exactly once rather than twice. Purely mechanical; zero data/behavior change. Risk: LOW-correctness / MEDIUM-mechanical-churn (large diff, easy to miss a call site — mitigated by the compiler itself once the type is introduced).

6. **S-cycle3-oauth-default-creation** — `auth login` interactive creation-time default flips to OAuth (mirrors `init.rs`); `--oauth` demoted to deprecated-but-accepted alias with a deprecation notice; non-interactive/CI path explicitly pinned as token-first (regression-safety BC #2, #6). Depends on: recommend AFTER #2/#3 land, so newly-OAuth-defaulted profiles' sibling api-token path is already on the new per-profile storage model (avoids a two-step credential-storage migration for the same feature window). Independent of #5.

7. **S-cycle3-chosen-flow-reconcile** — Audit/reconcile `chosen_flow_for_profile` (`cli/auth/mod.rs:107`, used by `auth refresh`) against the "auth_method is intrinsic, no per-command switch" invariant (Open Question 8; new BC #3). Depends on: #6.

8. **S-cycle3-cache-keychain-version-bump** (CONDITIONAL — only if Open Question 1 resolves to "yes, bump") — `v1→v2` cache-root literal change and/or a new keychain-namespace version marker. Depends on: #3 (credential migration should be stable before any version-root bump lands on top of it).

9. **S-cycle3-docs** — `docs/specs/multi-profile-auth.md` (Config Schema, Keyring Layout, Migration §4, CLI Surface sections), CLAUDE.md doc-fallout updates, ADR-0011 status flip + new ADR file (§1.3). Depends on: interleaved with every story above (doc updates should land in the SAME PR as their triggering code change per the repo's doc-fallout convention, not as one giant end-of-cycle doc story — listed here as a checklist item, not a literal standalone story).

10. **S-cycle3-regression-coverage** — New/extended test files: api-token migration test mirroring `tests/migration_legacy.rs`; keyring-gated per-profile store/load round-trip tests (pattern: `src/api/auth.rs::tests`); extend `tests/auth_profiles.rs` for `env` tag and per-profile credentials; new release-gate test if any new debug-only seam is introduced (§3). Depends on: interleaved with #1-#8, not a single terminal story — called out separately here because it is easy to under-scope as "just extend existing tests" when in fact several NEW test files/fixtures are required (no existing coverage exists for api-token-specific migration, per §3).

**Existing stories requiring coordination, not necessarily new work** (regression-risk zone, §3):
- **S-663-1** (`auth switch --profile` guard, status: done/shipped) — touches `main.rs`'s `AuthCommand::Switch` dispatch arm; verify this guard's ordering (fires before `Config::load_with`) is undisturbed by any `main.rs` changes story #6/#7 introduce.
- **S-384** (`is_oauth_auth()` gating for JSM 401 hints, status: ready, not yet delivered) — directly consumes `auth_method`; should be sequenced with awareness of story #6 (OAuth becoming the default changes which profiles most commonly hit this gate, though not the gating logic itself).
- **S-MAINT-532** (global `--profile` fallback coverage gap on Login/Refresh/Logout, status: draft) — exercises exactly the `subcmd.profile.or(cli.profile)` composition that story #6 touches on `Login`/`Refresh`. Recommend either landing S-MAINT-532 BEFORE cycle-003's login/refresh changes (clean baseline coverage first) or explicitly folding its scope into story #6/#10 to avoid two uncoordinated touches of the same composition logic.

---

## 3. Regression Risk

| Risk item | Level | Rationale | Safety net (existing) | New tests MANDATORY |
|---|---|---|---|---|
| **Shared `email`/`api-token` → per-profile migration** | **HIGH** | Genuinely new code path (no prior art beyond the OAuth-token sibling); touches the auth-header composition hot path (`client.rs::from_config` → every HTTP call); a bug here means either silent auth failure for existing users on upgrade, or a security-relevant leak if migration copies to the wrong profile. | The OAuth-token migration (`load_oauth_tokens`, `auth.rs::tests::load_oauth_tokens_default_partial_recovers_from_legacy`, `clear_profile_creds_default_also_clears_legacy_flat_keys`, `clear_profile_creds_non_default_leaves_legacy_keys_alone`) proves the PATTERN is soundly implementable — but proves nothing about the NEW code, since api-token migration is separate code, not shared code. | (1) Direct port of the three OAuth-migration unit-test shapes above, applied to the new api-token migration function. (2) A keyring-gated integration test (pattern: existing `#[ignore]`-gated tests behind `JR_RUN_KEYRING_TESTS=1`) proving end-to-end: pre-cycle shared keys present → post-upgrade first read → `<default>:*` populated, shared keys deleted, non-default profile unaffected. (3) Idempotency test: second read after migration is a no-op (byte/value-identical), mirroring BC-6.1.002's TOML-migration idempotency proof pattern. |
| **"default"-only legacy OAuth-key migration discipline regressing as a side effect** | **MEDIUM** | The OAuth migration code itself is untouched by this cycle, but it lives in the SAME file (`auth.rs`) immediately adjacent to the new api-token migration function, and `clear_profile_creds`/`clear_all_credentials` (which the OAuth path already uses) are prime candidates for a shared-helper refactor that could accidentally cross-wire the two credential kinds' clear logic. | `auth.rs::tests` pins the exact OAuth behavior today (5+ dedicated unit tests). | No new tests needed IF the OAuth path's existing test suite is run and confirmed green, byte-for-byte, after the api-token work lands (a diff-zero regression check) — call this out explicitly as a mandatory CI gate for this cycle's PRs, not a new test to author. |
| **Release-gate pins** (`base_url_release_gate.rs`, `jr_service_name_release_gate.rs`, `config_dir_release_gate.rs`) | **LOW-MEDIUM** | These are source-adjacency grep tests (`#[cfg(debug_assertions)]` within N lines of an env-var read) — they can silently stop verifying anything if refactored code moves the env-var read without moving the cfg-gate the expected distance, OR if a new debug-only seam for the migration/version-bump is added WITHOUT a matching new release-gate pin (the "citation discipline"/"new JR_* var" convention already codified in CLAUDE.md — this cycle must follow it, not invent an exception). | The three existing `*_release_gate.rs` files themselves, if kept passing. | If ANY new `JR_*` debug-only env var is introduced for this cycle's migration/testing seams, a NEW `tests/*_release_gate.rs` (mirroring the existing three) is mandatory, plus the corresponding CLAUDE.md "AI Agent Notes" table entry in the SAME commit. |
| **401 auto-refresh path** (`client.rs::send_inner`, `refresh_coordinator.rs`) | **LOW** | DEC-312..319 do not touch OAuth refresh mechanics at all — but `from_config`'s `auth_method` branch and the new per-profile api-token reader sit in the same function neighborhood as the code this path depends on, so a careless edit could collide. | `tests/oauth_refresh_integration.rs` (keyring-gated, AC-002/009-011). | None beyond confirming this suite stays green — flagged as a MUST-NOT-TOUCH regression baseline file in §4 of the template sense (this report's Files-NOT-Changed set, below). |
| **Cross-profile cache leakage during ADR-0011 newtype threading** | **LOW (post-landing) / MEDIUM (mechanical, in-flight)** | The newtype refactor touches ~12+ `cache.rs` functions and their ~50-70 call sites (ADR-0011's own estimate) — a purely mechanical sweep with no behavior change once compiling, but a large diff surface where a missed call site is a compile error (fail-safe) while a WRONG-but-compiling substitution (e.g., passing the wrong `Profile` value) is not caught by the type system alone. | BC-6.2.009/6.2.010 cross-profile isolation tests; the compiler itself becomes the primary new safety net once the newtype lands. | No new tests strictly required (existing cross-profile isolation tests should be re-run unchanged as the acceptance bar), but a full `cargo build`+`cargo test` pass with zero warnings is the operative gate given the diff size. |
| **CLI-surface break: `--oauth` demoted to deprecated alias** | **MEDIUM** | Existing scripts/CI/agents invoking `jr auth login --oauth` explicitly continue to work per DEC-313 ("retained as a deprecated-but-accepted alias"), but the migration WINDOW length is undefined (Open Question 4) and a deprecation-notice stderr line could itself break brittle scripts that assert on exact stderr content. | BC-1.2.015/016 (`auth refresh --help` includes `--oauth`) pin the flag's continued EXISTENCE — good baseline. | A new test asserting `--oauth`'s continued FUNCTIONAL behavior (not just `--help` presence) is unchanged, plus a test confirming the deprecation notice is stderr-only (never stdout, preserving `--output json` cleanliness per the #526 JSON-render invariant). |
| **`v1→v2` cache-root/keychain-namespace bump, if adopted** | **LOW (cache) / MEDIUM-HIGH (keychain, if a novel mechanism is invented)** | Cache: explicitly designed as a disposable, self-healing lever (BC-6.2.004/6.2.016 already document "old files orphan harmlessly") — near-zero risk, mild perf cost (cold refetch across all 9 cache families on first post-upgrade run). Keychain: NO existing versioning lever exists (unlike cache's `v1/` path segment) — inventing one is new, unproven surface, and keychain data (unlike cache) is NOT disposable/refetchable (losing an OAuth refresh token means a full re-auth, not a slow refetch). | Cache: BC-6.2.018's warm-hit invariant tests (9 families) — confirm they operate through `cache_root()`/`cache_dir(profile)` as the sole choke point, so a version-literal change requires touching exactly one function. Keychain: none (no prior art). | If a keychain version marker is adopted: a full new test suite proving forward-compat (old-version binary reading new-version keys fails safely, not silently) and backward-compat (migration path) — scoped as its own story (§2 item 8) precisely because it needs dedicated design, not a drive-by addition to the credential-migration story. |
| **Existing story surface collisions** | **MEDIUM** | S-663-1 (`main.rs` `AuthCommand::Switch` guard), S-384 (`is_oauth_auth()` JSM gating), S-MAINT-532 (global `--profile` composition on Login/Refresh/Logout) all touch code this cycle's stories also touch. | Each story's own existing/planned test coverage. | No new tests required beyond what those stories already specify — the risk is COORDINATION (two stories editing the same function in different PRs), not missing coverage. Recommend the F3 story-decomposition explicitly sequences or merges S-MAINT-532 with story #6 above (§2). |

**Files NOT changed (regression baseline for this cycle, to be confirmed at F2):** `src/api/auth.rs`'s OAuth login/refresh/state-machine functions (`oauth_login`, `generate_state`, `build_authorize_url`, `extract_query_param`, redirect-strategy types), `src/api/auth_embedded.rs` (embedded-app XOR/obfuscation), `src/api/refresh_coordinator.rs` (single-flight), `src/cli/init.rs` (reference model, not itself edited), `src/cache.rs`'s non-signature internals (TTL logic, corruption-recovery, per-family read/write bodies) unless the newtype/version-bump stories land.

---

## 4. Migration Surface

### 4.1 Shared `email`/`api-token` → `<default>:email`/`<default>:api-token` (DEC-315, mandatory)

- **Mechanism:** Lazy, on first read, inside the new per-profile `load_api_token(profile)` — mirrors `load_oauth_tokens` byte-for-byte in shape: (1) try namespaced keys first; (2) if BOTH namespaced keys absent AND `profile == "default"`, read the legacy flat `email`/`api-token` keys, copy them to the namespaced pair, best-effort-delete the legacy pair, return the copied values; (3) any other profile with absent namespaced keys gets `NotAuthenticated`/an actionable error, exactly as `load_oauth_tokens` does today for non-default profiles.
- **Trigger:** first read after upgrade (no eager config-load-time migration needed for this piece — unlike the TOML `[instance]`→`[profiles.default]` migration, which IS eager because it must run before any profile can be resolved at all).
- **Idempotency:** second read sees namespaced keys and short-circuits at step (1) — no-op, matching BC-1.4.025's OAuth equivalent.
- **Backward compat / rollback:** identical posture to the existing OAuth migration and to `docs/specs/multi-profile-auth.md`'s documented "Rollback story (manual only)" — no automated `jr config rollback`; a user reverting to a pre-cycle-003 binary after migration has already run would need to re-run `jr auth login` (the legacy flat keys are deleted post-migration, same as today's OAuth path). This is an ACCEPTED, pre-existing posture, not a new risk this cycle introduces.
- **Scope discipline:** this migration ONLY runs for `auth_method == "api_token"` profiles reading credentials — it must not fire for OAuth profiles (which have their own, already-shipped, separate migration) and must not conflate the two credential kinds' legacy keys.

### 4.2 `env`/role tag (DEC-314) — NO migration

Purely additive `Option` field with `#[serde(default)]`; old `config.toml` files simply deserialize with `env: None`/absent. Confirmed explicitly by DEC-314's own wording ("no forced cache/keychain namespace bump for this field alone"). No action item here beyond the schema addition itself.

### 4.3 `v1→v2` cache-root bump — conditional, on the table (DEC-315)

If adopted: reuses the EXISTING, already-documented lever (BC-6.2.004/6.2.016's `v1/` versioned root) — bump the literal, old `~/.cache/jr/v1/<profile>/` (and Windows `%LOCALAPPDATA%\jr\v1\<profile>\`) directories orphan harmlessly, first post-upgrade access to any of the 9 cache families is a cold miss that self-heals via the existing TTL-miss/refetch code path. Zero data-loss risk (cache is disposable by design). Idempotent and reversible by construction (the old `v1/` data simply sits unused; a downgrade would see it again).

### 4.4 Keychain-namespace version marker — conditional, NOVEL if adopted (no existing lever)

Unlike cache, the keychain layout has NO existing `v1`-style version segment in its key names (`<profile>:oauth-access-token` etc. are namespaced by profile only, never by a schema version). If DEC-315's "v1→v2 bump… on the table" is meant to ALSO cover keychain (not just cache), this requires either (a) inventing a new key-naming scheme (e.g., `<profile>:v2:oauth-access-token`), which is a genuinely new migration mechanism needing its own design, testing, and rollback story, or (b) concluding that keychain namespacing doesn't need a version marker at all — the per-profile prefix IS the only namespacing keychain has ever needed, and the credential-KIND (`email`/`api-token` vs `oauth-*`) is already disambiguated by key suffix, so there is nothing for a "v2" to version. **This report recommends (b) as the default reading unless F2 surfaces a concrete forward-compat need**, but flags it as Open Question 1 since DEC-315's text is genuinely ambiguous on this point.

### 4.5 ADR-0011 `Profile` newtype — NO data migration

Pure Rust type-level change; zero on-disk, keychain, or wire-format impact. All migration risk here is mechanical (compile-time call-site sweep), not data-migration risk — already covered in §3.

---

## 5. Open Questions for the F1 Human Gate

These are genuinely new questions this impact analysis surfaces — DEC-312 through DEC-319 are treated as settled and are not re-litigated below.

1. **Does the `env`/role tag (DEC-314) and the per-profile-credential keychain restructuring (DEC-315) share ONE `v1→v2` namespace bump, or none, or two independent ones?** DEC-314 explicitly needs no bump. The only live candidate is DEC-315's credential restructuring — and even there, does "bump" mean the CACHE root (which has an existing, safe, disposable lever — §4.3) only, or does it also imply a KEYCHAIN version marker (which has no existing lever and is NOT disposable data — §4.4)? This report recommends: cache-only if any bump happens at all, keychain namespacing left as-is (profile-prefix only, no version segment) unless F2 finds a concrete need.

2. **Is ADR-0011 un-deferred via an in-place status amendment (Deferred → Accepted) or a formal supersession (a new ADR that supersedes it)?** This report recommends in-place amendment (the decision doesn't reverse, it confirms a documented revisit trigger was met) but flags this as a process-convention choice, not a purely technical one — confirm with spec-steward/architect convention before F2 writes it.

3. **Does per-profile credential storage (DEC-315), the `env` tag (DEC-314), and OAuth-default-at-creation (DEC-313) warrant ONE combined new ADR, or separate ADRs per decision?** This report recommends ONE combined ADR (all three share the same "config overhaul" window ADR-0011 itself names as its own revisit trigger, and they are causally linked — DEC-317's un-defer is explicitly justified BY DEC-315's credential normalization) — confirm at the gate.

4. **What is the backward-compat window length for `--oauth` as a "deprecated-but-accepted alias"?** DEC-313 specifies retention "for a migration window" without a duration. This determines the CLI deprecation-notice wording, CHANGELOG language, and whether a follow-up removal story should be pre-registered in STORY-INDEX now (as a future-dated placeholder) or left undecided until a later cycle.

5. **Does `auth login` gain a new explicit `--api-token` flag (symmetric opt-in to today's `--oauth`) as the creation-time mechanism-declaration surface, or does creation-time selection happen ONLY via the interactive picker (mirroring `init.rs`) with non-interactive users relying purely on `JR_EMAIL`/`JR_API_TOKEN` presence (no explicit flag at all)?** This determines whether `handle_login`'s flag surface grows a new boolean or whether `--oauth`'s demotion to alias is a pure narrowing with no replacement flag.

6. **Does `auth remove`'s three-step delete (BC-1.2.014) grow a fourth step to delete per-profile `<profile>:email`/`<profile>:api-token`, and does `auth logout` (BC-1.2.013, currently OAuth-token-only) gain equivalent api-token-clearing behavior — or does `logout` remain OAuth-specific by design** (API-token auth has no "session" concept to log out of, only credentials to remove entirely, which arguably belongs to `remove` not `logout`)**?** DEC-315 does not resolve this UX-semantics question; it only mandates that per-profile storage EXISTS.

7. **Does the new `env` tag get a table column in `auth list`'s human output (breaking BC-1.6.046's pinned 4-column insta-snapshot, a deliberate/documented breaking change), or is it JSON-only / `--verbose`-gated to avoid touching the pinned snapshot at all?** This is a concrete, decidable UX call the F1 gate should make so F2 can write the correct BC (amend vs. leave untouched) rather than guessing.

8. **Does `chosen_flow_for_profile` (`cli/auth/mod.rs:107`), which today lets `auth refresh --oauth` override the profile's stored `auth_method` for that one invocation, survive DEC-313's "no per-command auth switch" invariant as a documented exception (since `refresh`'s job — credential rotation — is arguably a different concern from `login`'s job — mechanism *selection*), or does it get removed/simplified so `refresh` always follows the profile's intrinsic `auth_method` with no override?** This is the one place in the current codebase where a per-invocation flag already DOES override the stored mechanism, and DEC-313's "every invocation auto-selects... no per-command auth switch" language does not explicitly address whether `refresh`'s existing override is grandfathered or must be removed.

### Flagged unknowns / not independently re-verified this pass

- `nfr-catalog.md`'s NFR-S-B row (`JR_AUTH_HEADER` unconditional-read, listed SECURITY-DECIDE/undecided) appears to be STALE against CLAUDE.md's documented `#[cfg(debug_assertions)]` gate — not this cycle's scope to fix, but flagged so F2 doesn't inherit a false "undecided" status for an adjacent NFR while editing nearby auth code (§1.5).
- The exact current shape of `resolve_credential`/`resolve_oauth_app_credentials` in `src/cli/auth/keychain.rs` was cited from the current-state investigation brief and CLAUDE.md, not re-read line-by-line this pass — confirm exact function signatures before F2 spec authoring locks in per-profile-storage call sites.
- `ADR-0017`/`ADR-0018`/`ADR-0019` prose-only citations (no `docs/adr/` files) are a PRE-EXISTING drift unrelated to this cycle; flagged in §1.3 purely to prevent this cycle's new ADR from colliding with an already-spoken-for-but-unfiled number.
