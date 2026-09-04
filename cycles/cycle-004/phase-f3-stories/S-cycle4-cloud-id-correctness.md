---
document_type: story
level: ops
story_id: "S-cycle4-cloud-id-correctness"
epic_id: "WINDOWS-CORRECTNESS-1"
title: "API-token login/refresh acquires cloud_id via tenant_info fetch, closing A-PA-LOW-001"
wave: 1
status: draft
intent: bug-fix
feature_type: backend
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
points: 8
priority: P1
tdd_mode: strict
producer: story-writer
timestamp: "2026-09-04T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/architecture/decisions/ADR-0022-api-token-cloud-id-acquisition-tenant-info.md"
  - ".factory/cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md"
  - ".factory/cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md"
  - ".factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md"
input-hash: "22324f7"
traces_to: ".factory/specs/prd/bc-1-auth-identity.md"
cycle: cycle-004-windows-correctness
estimated_effort: medium
estimated_days: 3
target_module: src/api/jira/tenant.rs
subsystems: ["SS-04"]
depends_on: []
blocks: ["S-cycle4-windows-docs"]
behavioral_contracts:
  - "BC-1.2.052"
  - "BC-1.2.053"
  - "BC-1.2.054"
bcs:
  - "BC-1.2.052"
  - "BC-1.2.053"
  - "BC-1.2.054"
verification_properties:
  - "VP-AUTHDX-019"
  - "VP-AUTHDX-020"
  - "VP-AUTHDX-021"
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0022"]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md"
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 9
assumption_validations: []
risk_mitigations: []
created: "2026-09-04"
version: "1.3"
last_updated: "2026-09-04"
breaking_change: false
retroactive: false
origin: >
  cycle-004 windows-correctness, Wave 1 (no deps, file-disjoint from
  S-cycle4-dpapi-storage-fix -- touches cli/auth/login.rs, cli/auth/refresh.rs,
  cli/init.rs, and a new api/jira/tenant.rs, none of which S-cycle4-dpapi-storage-fix
  touches). Human-added scope item closing A-PA-LOW-001: login_token (the API-token
  login path) never acquires cloud_id today, permanently breaking Assets/CMDB for every
  API-token profile -- a gap #759's DPAPI fix widens by pushing more Windows users onto
  the API-token workaround. Adds a new api/jira/tenant.rs::fetch_cloud_id, wired into
  login_token's --cloud-id override / tenant_info fetch / soft-fail fallback chain, and
  confirms (does not modify) that Config::base_url()'s auth_method==oauth gateway guard
  and assets_base_url's cloud_id-only computation are already correct.
---

> **tdd_mode:** `strict` — full TDD Iron Law enforced. New network-I/O module and a
> modified login dispatch path, not a facade/DTU candidate.

> **Execute:** `/vsdd-factory:deliver-story S-cycle4-cloud-id-correctness`

# S-cycle4-cloud-id-correctness — API-token `cloud_id` acquisition (A-PA-LOW-001)

> **Revision note (v1.2 → v1.3, F3 round-3 re-review comprehensive fix pass, 2026-09-04):**
> appended the anchoring `VP-AUTHDX-019` citation to AC-001, AC-005, and AC-006 — all three
> are within VP-AUTHDX-019's oracle (AC-001's override-precedence-and-persist is the VP's
> own Postcondition-1/Pass-2-Finding-#8 clause; AC-005's fetch-success-overwrite-and-persist
> is the VP's own Postcondition-5 clause; AC-006's three-explicit-trigger-sites/plain-reqwest
> claim is the VP's own Invariant-1/3 and EC-1.2.052-5 auth-refresh-trigger-site clause) but
> had omitted the citation while AC-002/AC-003 already carried it (F3 round-3 re-review
> Finding #2 — comprehensive sweep of all four cycle-004 stories' ACs for the same omission
> class). **AC-004 (`jr init` reuses the same function, BC-1.2.052 postcondition 4) is left
> intentionally VP-uncited**, mirroring `S-cycle4-dpapi-storage-fix`'s AC-019/AC-020
> precedent: no existing VP-AUTHDX-0NN asserts the "single call site, no second independent
> `tenant_info` path" property specifically — this Architecture Compliance Rule row's
> enforcement is code review (Task 1/9), not a VP oracle, so no citation is invented here.
>
> **Revision note (v1.1 → v1.2, F3 re-review comprehensive fix pass, 2026-09-04):** added a
> `CHANGELOG.md` row to File Structure Requirements — Task 17 already required a CHANGELOG
> entry, but the file itself was missing from this table, and it is concurrently edited by
> all three other cycle-004 stories (F3 re-review Finding #1; see `conflict-report.md`
> §1/§4, `wave-schedule.md` §2/§3).

## Anchor Justification

**Subsystem anchor:** `SS-04` (Jira API Resources) owns this story's scope because the
new `src/api/jira/tenant.rs` file lands in the existing, already-generically-covered
`src/api/jira/` product-namespaced directory (architecture-delta.md §2.2) — no Subsystem
Registry text change needed, consistent with every other `api/jira/*.rs` file's anchor.

**Dependency anchors:** `depends_on: []` — this story's new module
(`api/jira/tenant.rs::fetch_cloud_id`) and its `login_token`/`handle_login`/
`refresh_credentials` call-site wiring are self-contained; nothing in cycle-004 must land
before it. File-disjoint from `S-cycle4-dpapi-storage-fix`/`S-cycle4-honest-fail-message`
(those touch `src/api/auth.rs`/`src/api/auth_windows_store.rs`; this story touches
`src/cli/auth/login.rs`, `src/cli/auth/refresh.rs`, `src/cli/init.rs`, and the new
`src/api/jira/tenant.rs` — zero file overlap), so it runs in parallel with that story in
Wave 1.

**Blocks anchor:** `S-cycle4-windows-docs` depends on this story because its `cloud_id`
auto-discovery caveat (AC-004 of that story) must describe THIS story's finalized fetch/
override/soft-fail contract, not the pre-fix "OAuth-only" limitation issue #760 originally
reported — see `S-cycle4-windows-docs.md`'s own Anchor Justification for the symmetric
statement of this dependency.

## Source of Truth

- `.factory/specs/prd/bc-1-auth-identity.md` §1.2, BC-1.2.052, BC-1.2.053, BC-1.2.054
  (all read in full for this story).
- `ADR-0022-api-token-cloud-id-acquisition-tenant-info.md` §1 (`fetch_cloud_id`), §2
  (`login_token`/`handle_login` wiring, the `refresh_credentials` second call site), §3
  (mechanism-switch refresh-not-clear), §4 (confirmed-unchanged guards).
- `architecture-delta.md` §1.2 (target-state diagram), §2.2 (new module interface
  table), §3 (modified-components table), §4 (confirmed-unchanged section).

## Narrative

As a `jr` user authenticating via API token (the workaround Windows users are increasingly
pushed onto by #759, and the default flow for anyone who declines OAuth), I want
`jr auth login`/`jr init` to automatically discover and persist my instance's `cloud_id`,
so that Assets/CMDB commands don't permanently fail with "Cloud ID not configured" even
immediately after a successful login.

## Behavioral Contracts

| BC | Status | What this story delivers |
|----|--------|---------------------------|
| BC-1.2.052 | NEW | `login_token` gains a `cloud_id_override: Option<&str>` parameter and an ordered fallback chain: explicit `--cloud-id` override (persisted) → unauthenticated `GET {site}/_edge/tenant_info` fetch via new `api/jira/tenant.rs::fetch_cloud_id` → soft-fail (never blocks login). `handle_login` and `jr init`'s API-token branch both route through this same function — no second, independent `tenant_info` call site. |
| BC-1.2.053 | NEW | An oauth→api_token mechanism switch REFRESHES `cloud_id` on fetch success and PRESERVES the prior value on fetch failure — falls out of BC-1.2.052's general fetch-on-every-invocation behavior, with no dedicated switch-detection code; gets its own BC/EC/test per the architect's explicit flag |
| BC-1.2.054 | CONFIRMED-UNCHANGED | `Config::base_url()`'s `auth_method == "oauth"` gateway guard and `assets_base_url`'s `cloud_id`-only computation are verified already correct — no code change, but a regression-pin VP closes this half of A-PA-LOW-001 alongside BC-1.2.052/053's acquisition half |

## Acceptance Criteria

### AC-001 — Explicit `--cloud-id` override takes precedence and is persisted
`login_token` gains a `cloud_id_override: Option<&str>` parameter; `handle_login` passes
`args.cloud_id.as_deref()` through on the API-token branch (currently silently dropped).
When supplied, the `tenant_info` fetch is never attempted, and the override value
OVERWRITES `p.cloud_id` and is PERSISTED via `Config::save_global()` — symmetric with
`login_oauth`'s existing `cloud_id_override` handling, not merely used in-memory to skip
the fetch.
(traces to BC-1.2.052 postcondition 1; VP-AUTHDX-019)

### AC-002 — `tenant_info` fetch: bare path, no auth header, bounded timeout, https-only precondition
`fetch_cloud_id(site_url)` issues `GET {site_url}/_edge/tenant_info` with NO
`Authorization` header, NO query string, a 10-second bounded timeout, and parses ONLY the
`cloudId` field (serde-default tolerant of unknown fields). When `site_url` does not start
with `https://` (case-insensitive), the fetch is SKIPPED ENTIRELY — zero network requests
made — flowing directly into the soft-fail path.
(traces to BC-1.2.052 postcondition 2; VP-AUTHDX-019)

### AC-003 — Soft-fail never aborts login, never panics
On any fetch failure (non-2xx incl. 401/403/404, a 3xx redirect treated as an ordinary
non-2xx per the `redirect::Policy::none()` client config, network/DNS/TLS error,
missing/malformed `cloudId` field, or the non-https skip) — `login_token` does NOT abort;
it emits a single human-mode-only `eprintln!` diagnostic (never stdout) and leaves
`p.cloud_id` untouched (`None` for brand-new, prior value for existing). Login still
succeeds, exit 0.
(traces to BC-1.2.052 postcondition 3, invariant 2; VP-AUTHDX-019)

### AC-004 — `jr init`'s API-token branch reuses the same function
`jr init`'s interactive picker (API-token branch) invokes the SAME `login_token`/
`fetch_cloud_id` plumbing — no second, independent `tenant_info` call site anywhere in
the codebase.
(traces to BC-1.2.052 postcondition 4)

### AC-005 — Fetch success overwrites `cloud_id` unconditionally and persists
On fetch success, the returned `cloudId` OVERWRITES `p.cloud_id` unconditionally and
persists via `Config::save_global()`, unchanged mechanism from the existing save path.
(traces to BC-1.2.052 postcondition 5; VP-AUTHDX-019)

### AC-006 — Not routed through `JiraClient`; three explicit trigger sites, including `auth refresh`
`fetch_cloud_id` is a plain `reqwest` call, never routed through `JiraClient` (mirrors
`oauth_login`'s direct `accessible-resources` calls). The fetch fires on exactly THREE
sites: `auth login`, `jr init`, and `jr auth refresh` whenever it resolves to the
api_token flow (`refresh_credentials` calls `login_token` directly, with
`cloud_id_override` hardcoded `None` — no `--cloud-id` flag on `RefreshArgs` — mirroring
the existing sibling `login_oauth` call on the same function) — intentional, not an
oversight; this is the compile-forcing second call site the architecture delta identifies.
(traces to BC-1.2.052 invariants 1/3; VP-AUTHDX-019)

### AC-007 — Mechanism-switch refresh-not-clear, never a bare clear
For an oauth→api_token mechanism switch: if the `tenant_info` fetch succeeds, the fresh
`cloudId` OVERWRITES the stale OAuth-era value (a plain instance of AC-005, no
switch-specific code); if the fetch fails, the PRIOR value is preserved intact — including
when the prior value was itself `None` (preserved as `None`) — NEVER an unconditional
clear. No new "mechanism switch" detection code is added anywhere in `client.rs` or
`config.rs`.
(traces to BC-1.2.053 postconditions 1/2, invariant 1; VP-AUTHDX-020)

### AC-008 — Config-layer verification without a real credential store
The mechanism-switch property (AC-007) is verified at the CONFIG layer: `wiremock`
synthesizes the fetch outcome, applied directly to an in-memory `ProfileConfig`
pre-seeded with a stale `cloud_id` (and, separately, `None`) — asserting overwrite-on-success
/ preserve-on-failure without touching `store_api_token`/the real OS keychain. This
config-layer core runs in DEFAULT CI. The real-keychain, full-`login_token` end-to-end
scenario is an OPTIONAL keyring-gated confirmation tail extending
`tests/auth_chosen_flow_reconcile.rs`, not the primary oracle.
(traces to BC-1.2.053 VP-AUTHDX-020 coverage boundary)

### AC-009 — `base_url()`/`assets_base_url` regression pin (confirmed-unchanged, no code change)
A property test (`proptest` over arbitrary `auth_method`/`cloud_id` combinations) pins:
`Config::base_url()` selects the gateway URL IFF `auth_method == Some("oauth")` AND
`cloud_id` is present, for the FULL cross product of `auth_method` ∈ {oauth, api_token,
unset/None} × `cloud_id` ∈ {present-correct, present-stale, absent}; `JiraClient::from_config`'s
`assets_base_url` derives from `cloud_id` alone, un-gated by `auth_method`. This test
FAILS LOUD if a future change adds an `auth_method` gate to `assets_base_url` or removes
the `oauth` gate from `base_url()`. No `src/config.rs`/`src/api/client.rs` code change is
made by this story — this AC is a regression pin on already-correct, pre-existing
behavior.
(traces to BC-1.2.054 postconditions 1/2/3, invariants 1/2; VP-AUTHDX-021)

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|---------------|
| `fetch_cloud_id(site_url)` | `src/api/jira/tenant.rs` (NEW) | Effectful Shell (network I/O) |
| `login_token` (post-change) | `src/cli/auth/login.rs` | Effectful Shell (unchanged classification; gains one more effectful call) |
| `handle_login` (post-change) | `src/cli/auth/login.rs` | Effectful Shell (unchanged; passes through the new parameter) |
| `refresh_credentials` (post-change) | `src/cli/auth/refresh.rs` | Effectful Shell (unchanged; second call site updated for the new parameter) |
| `Config::base_url()`, `JiraClient::from_config`'s `assets_base_url` computation | `src/config.rs`, `src/api/client.rs` | Effectful Shell / pure config-derivation (CONFIRMED-UNCHANGED, no code touched) |

## UX Screens

N/A — CLI-only, no UI surface.

## Design System Components

N/A — not a UI story.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-1.2.052-1 | `--cloud-id` supplied with a wrong/stale value | Not validated against the actual site — consistent with `login_oauth`'s existing `cloud_id_override` precedent, not a gap unique to this BC |
| EC-1.2.052-2 | Site returns 401/403/404, or a 3xx redirect | Treated as an ordinary non-2xx soft-fail; `redirect::Policy::none()` means a redirect is never followed cross-host |
| EC-1.2.052-3 | Response is valid JSON but omits `cloudId` | serde missing-required-field deserialization failure → soft-fail, never a panic |
| EC-1.2.052-4 | Network-level error (DNS, connection refused, TLS failure) | Identical soft-fail; bounded by the 10-second timeout |
| EC-1.2.052-5 | An explicit `--cloud-id` override is NOT durable across a subsequent `jr auth refresh` (no `--cloud-id` flag on `RefreshArgs`) | INTENDED: a later refresh's fetch success unconditionally overwrites the override value; it survives only if that refresh's fetch fails |
| EC-1.2.053-1 | Mechanism switch, fetch fails, profile never had a `cloud_id` to begin with | Preserved as `None` — Postcondition 2's "preserve" applies uniformly |
| EC-1.2.053-2 | Two consecutive mechanism switches without an intervening successful fetch | The value after the FIRST switch's fetch outcome is what the SECOND switch's own fetch independently refreshes/preserves — no switch-history tracking |
| EC-1.2.054-3 | Assets/CMDB against an api_token profile with a correct `cloud_id` | Conditional: IF the gateway accepts the profile's classic API-token Basic auth, THEN Assets succeeds — acquisition itself is unconditional and does NOT depend on Assets working (classic-token gateway acceptance is UNCONFIRMED, per Pass-1 adversarial review Finding #1) |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `api/jira/tenant::fetch_cloud_id` | Effectful Shell | Network I/O (`reqwest`); no pure sub-component to extract — the entire function is "make one HTTP call, parse one field" |
| `login_token`, `handle_login`, `refresh_credentials` (post-change) | Effectful Shell (unchanged) | Already effectful (keychain + config I/O); gain one more effectful call each |
| `Config::base_url()` / `assets_base_url` (unchanged) | Effectful Shell / pure config-derivation | CONFIRMED-UNCHANGED; not modified by this story |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|---------------|-----------------|
| This story spec | ~3,600 |
| BC-1.2.052/053/054 (full) | ~6,000 |
| ADR-0022 (relevant sections) | ~3,000 |
| `src/cli/auth/login.rs` (`login_token`/`handle_login`, ~150 LOC) | ~2,000 |
| `src/cli/auth/refresh.rs` (`refresh_credentials`, ~80 LOC) | ~1,000 |
| `src/cli/init.rs` (API-token branch, read for wiring confirmation) | ~1,500 |
| New `src/api/jira/tenant.rs` (to be written, ~60-100 LOC) | ~1,200 |
| `src/config.rs::base_url` / `src/api/client.rs`'s `assets_base_url` (read-only, confirm-unchanged) | ~1,000 |
| `wiremock`-based tests | ~2,000 |
| **Total** | **~21,300** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~11%** |

Comfortably within budget.

## Tasks

1. [ ] Read `src/cli/init.rs`'s API-token branch to confirm it actually calls
   `login_token` (not a separate, parallel credential-write path) before assuming this
   story's fix reaches it for free — flagged explicitly in architecture-delta.md §9 item 2
   as unverified during F2
2. [ ] Write failing tests for `fetch_cloud_id`'s bare-path/no-auth-header/bounded-timeout/
   https-only-precondition contract, `wiremock`-based (AC-002)
3. [ ] Write failing tests for the soft-fail contract across every failure shape (AC-003,
   VP-AUTHDX-019)
4. [ ] Implement `src/api/jira/tenant.rs::fetch_cloud_id` (plain `reqwest`,
   `redirect::Policy::none()`, 10s timeout, serde-default-tolerant `cloudId`-only parse)
5. [ ] Write failing tests for `login_token`'s override/fetch/soft-fail fallback chain and
   the persistence behavior (AC-001, AC-005)
6. [ ] Implement `login_token`'s `cloud_id_override` parameter and fallback chain wiring
7. [ ] Update `handle_login` to pass `args.cloud_id.as_deref()` through (AC-001)
8. [ ] Update `refresh_credentials`'s `login_token` call site with the hardcoded `None`
   parameter (AC-006)
9. [ ] Wire `jr init`'s API-token branch through the SAME function (AC-004), per Task 1's
   verification
10. [ ] Write failing config-layer tests for the mechanism-switch refresh-not-clear
    property, `wiremock` + in-memory `ProfileConfig`, no real keychain (AC-007, AC-008)
11. [ ] Implement/confirm the mechanism-switch behavior falls out of Task 6's general
    fetch-on-every-invocation logic with NO dedicated switch-detection code
12. [ ] Write the `base_url()`/`assets_base_url` regression-pin `proptest` (AC-009) —
    NO code change to either function
13. [ ] Verify purity boundaries against the table above
14. [ ] Update STATE.md (state-manager, not this story's implementer)
15. [ ] Verify Red Gate (all new tests fail before implementation)
16. [ ] Refactor
17. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` describing the `cloud_id`
    acquisition fix (A-PA-LOW-001), before creating the PR

## Previous Story Intelligence

N/A — first story in the `WINDOWS-CORRECTNESS-1` epic's `cloud_id` sub-thread; no
completed cycle-004 stories exist yet, and this story is file-disjoint from
`S-cycle4-dpapi-storage-fix`/`S-cycle4-honest-fail-message` so there is no shared-file
intelligence to carry forward from them. Cross-reference for a future reader: this story's
`fetch_cloud_id` design mirrors `oauth_login`'s existing direct-`reqwest`
`accessible-resources` call pattern in `src/api/auth.rs` — read that function first as the
concrete precedent for "a plain `reqwest` call at login time, before a `JiraClient` can be
constructed."

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|-----------|
| `fetch_cloud_id` is a plain `reqwest` call, NEVER routed through `JiraClient` | BC-1.2.052 invariant 1; ADR-0022 §1 | Code review; no `JiraClient` construction inside `fetch_cloud_id` |
| `redirect::Policy::none()` on the fetch client | BC-1.2.052 EC-1.2.052-2; ADR-0022 §1 (Pass-1 Finding #12) | AC-002/AC-003 tests assert a 3xx redirect is treated as non-2xx, never followed |
| https-only precondition — an `http://`/scheme-less `site_url` skips the fetch entirely | BC-1.2.052 postcondition 2 (Pass-4 Finding #4) | AC-002 test asserts ZERO requests reach the `wiremock` server for a non-https site |
| No second, independent `tenant_info` call site (login, init, refresh all share one function) | BC-1.2.052 postcondition 4; ADR-0022 §2 | AC-004, Task 1/9 |
| No new "mechanism switch" detection code in `client.rs`/`config.rs` | BC-1.2.053 invariant 1 | Code review must reject a bespoke switch-detection branch |
| `Config::base_url()`/`assets_base_url` are NOT modified — re-implementing either as new/duplicate code is explicitly rejected | BC-1.2.054 invariant 1; ADR-0007 | AC-009 is a pin, not a rewrite; code review rejects any diff touching either function's logic |
| EC-1.2.054-3 worded/tested as a CONDITIONAL outcome, never an unconditional "Assets works" claim | BC-1.2.054 postcondition/EC (Pass-1 Finding #1) | AC-009's test asserts acquisition/persistence, not a live Assets 200 |
| Zero-warnings policy | CLAUDE.md | `cargo clippy -- -D warnings` |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `reqwest` | existing pinned version, unchanged | Direct HTTP call in `fetch_cloud_id`, mirroring `oauth_login`'s existing usage |
| `wiremock` (dev-dependency, already present) | existing pinned version | Synthesizing `tenant_info` success/failure/redirect shapes for AC-002/003/008 |
| `serde` (existing) | unchanged | `cloudId`-only, unknown-fields-tolerant deserialization |

No new external dependency is introduced by this story.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/api/jira/tenant.rs` | CREATE | `fetch_cloud_id(site_url: &str) -> Result<String>` |
| `src/api/jira/mod.rs` | MODIFY | Add module declaration + re-export for `tenant` |
| `src/cli/auth/login.rs` | MODIFY | `login_token` gains `cloud_id_override` parameter + fallback chain; `handle_login` passes `args.cloud_id.as_deref()` through |
| `src/cli/auth/refresh.rs` | MODIFY | `refresh_credentials`'s `login_token` call site updated (hardcoded `None` for `cloud_id_override`) |
| `src/cli/init.rs` | MODIFY (pending Task 1 verification) | API-token branch confirmed/wired to call `login_token` (not a second, parallel path) |
| `tests/auth_chosen_flow_reconcile.rs` | MODIFY | Extend with the config-layer mechanism-switch scenario (AC-007/008) and an optional keyring-gated confirmation tail |
| A new `tests/` file (e.g. `tests/cloud_id_tenant_info.rs`) | CREATE | `wiremock`-based tests for `fetch_cloud_id`'s contract and `login_token`'s fallback chain (AC-001-006) |
| `src/config.rs`, `src/api/client.rs` | READ-ONLY (confirm, do not modify) | `base_url()`/`assets_base_url` regression-pin test target (AC-009) |
| `CHANGELOG.md` | MODIFY | `[Unreleased] > Fixed` entry per Task 17 (F3 story-review Finding #1) — this file is ALSO edited by `S-cycle4-dpapi-storage-fix` (Wave 1, parallel), `S-cycle4-honest-fail-message` (Wave 2), and `S-cycle4-windows-docs` (Wave 2); see `conflict-report.md` §1/§4 and `wave-schedule.md` §2/§3 for the cross-story `[Unreleased]`-section hotspot analysis — each story appends its OWN distinct bullet line, so this is a trivial append-collision, not a real conflict |

**Files NOT to touch:** `src/api/auth.rs`, `src/api/auth_windows_store.rs` (DPAPI work is
`S-cycle4-dpapi-storage-fix`/`S-cycle4-honest-fail-message`'s scope, unrelated to this
story), `README.md` (`S-cycle4-windows-docs`'s scope, depends on this story's OUTPUT but
is not this story's file).

## Out of Scope

- The Windows DPAPI storage fix and honest-fail messaging — `S-cycle4-dpapi-storage-fix`
  / `S-cycle4-honest-fail-message`.
- README documentation — `S-cycle4-windows-docs` (which depends on this story for
  content accuracy).
- Any code change to `Config::base_url()` or `JiraClient::from_config`'s `assets_base_url`
  computation — confirmed-correct, pinned, not modified (AC-009).
- Validating whether the Assets gateway actually accepts a CLASSIC (non-scoped) API token
  over Basic auth — explicitly unconfirmed and out of this story's guaranteed scope
  (EC-1.2.054-3).

## Dependency Analysis

**depends_on: []** — root story, Wave 1, alongside `S-cycle4-dpapi-storage-fix`
(file-disjoint, safe to run in parallel — see Anchor Justification).

**blocks:** `S-cycle4-windows-docs` — see that story's Anchor Justification for the
symmetric statement (content-accuracy dependency on this story's finalized `cloud_id`
caveat text).

## Story Points and Effort

**8 story points** (medium). Breakdown:
- New `fetch_cloud_id` module + `wiremock` test suite: 2.5 SP
- `login_token`/`handle_login` fallback-chain wiring + persistence: 2 SP
- `refresh_credentials` second-call-site update + `jr init` wiring verification: 1.5 SP
- Mechanism-switch config-layer property (BC-1.2.053, VP-AUTHDX-020): 1.5 SP
- `base_url()`/`assets_base_url` regression-pin `proptest` (BC-1.2.054, VP-AUTHDX-021): 0.5 SP

Risk: MEDIUM (module criticality MEDIUM — a genuinely new module and a login-path change,
but the ambient risk is bounded: soft-fail-by-design means a defect here degrades to "no
`cloud_id`," the pre-existing failure mode, not a login break). The `jr init` wiring
verification (Task 1) is the main unknown — `init.rs` was not read in full during F2, so
F4 should budget time for this discovery step before assuming the fix reaches `jr init`
for free.
