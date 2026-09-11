---
document_type: story
level: ops
story_id: "S-cycle7-auth-state-derivation"
epic_id: "AUTH-CORRECTNESS-DX-1"
title: "Shared derive_auth_state helper + auth list STATUS truthful-probe wiring (issue #788)"
wave: 1
status: draft
intent: bug-fix
feature_type: correctness
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
producer: story-writer
timestamp: "2026-09-10T00:00:00"
phase: 3
inputs:
  - ".factory/phase-f2-spec-evolution/cycle-007-prd-delta.md"
  - ".factory/phase-f2-spec-evolution/cycle-007-verification-delta.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - "src/api/auth.rs"
  - "src/cli/auth/list.rs"
input-hash: "5048eff"
traces_to: ".factory/phase-f2-spec-evolution/cycle-007-prd-delta.md §2/§8"
cycle: cycle-007-auth-correctness-dx
estimated_effort: medium
estimated_days: 3
target_module: "src/api/auth.rs; src/cli/auth/list.rs"
subsystems: ["SS-02", "SS-03"]
depends_on: []
blocks: ["S-cycle7-auth-status-json"]
behavioral_contracts:
  - BC-1.6.048
  - BC-1.6.049
  - BC-1.6.046
bcs:
  - BC-1.6.048
  - BC-1.6.049
  - BC-1.6.046
verification_properties:
  - VP-AUTHDX-024
  - VP-AUTHDX-025
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0020"]
sd_refs: []
priority: P0
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-007/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: strict
module_criticality: HIGH
points: 8
acceptance_criteria_count: 14
assumption_validations: []
risk_mitigations: []
created: "2026-09-10"
version: "1.0"
last_updated: "2026-09-11"
breaking_change: true
retroactive: false
origin: >
  cycle-007 auth-correctness-dx, Wave 1 of 2, no deps within this cycle, but
  BLOCKS S-cycle7-auth-status-json (Wave 2) which reuses the shared
  `derive_auth_state` helper this story introduces. `auth list`'s STATUS
  column/field currently derives from `p.url.is_some()` alone
  (`src/cli/auth/list.rs::render_list_table`/`render_list_json`) — the
  renderer's own doc comment already self-flags this as provisional
  ("Status today is a coarse... check — credential-store probing comes in
  Task 13"). This means a profile with a URL configured but NO usable
  credential (or a credential of the WRONG kind for its configured
  `auth_method`) is reported `configured` — a health-check-reports-green-for-
  an-unusable-resource defect (issue #788). This story introduces the shared,
  pure, auth_method-aware `derive_auth_state(url, matching_kind_present) ->
  AuthState` helper (BC-1.6.048) and wires `auth list`'s two renderers through
  it (BC-1.6.049), closing #788. F2 (`cycle-007-prd-delta.md`, six adversary
  fix rounds on this exact helper's signature and comparison primitive — see
  BC-1.6.048's STATUS notes for the full audit trail from the
  existence-only-probe defect through the `probe_stored_credential_kind`
  comparison defect to the final locked kind-specific-probe design) was
  human-APPROVED at the F1 gate (2026-09-10).
---

> **tdd_mode:** `strict` — full TDD Iron Law enforced. This is a
> security-sensitive auth-module correctness fix (`module_criticality: HIGH`)
> introducing a new safety-invariant helper (`derive_auth_state`) that a
> sibling story (`S-cycle7-auth-status-json`) depends on for its own
> guarantees — the pure-function test suite here must be a genuine
> RED-before-GREEN proof, never a facade.

> **Execute:** `/vsdd-factory:deliver-story S-cycle7-auth-state-derivation`

> **STORY REVISED (2026-09-10, F3 adversary pass-1, finding F-1, MEDIUM):** the
> kind-specific credential probe is relocated from `render_list_table`/
> `render_list_json` into the effectful handler `handle_list` (and a small
> extracted probing-loop helper it calls). The two renderers become PURE,
> taking a pre-computed per-profile `probe_results` value as a parameter. This
> gives AC-005/AC-006/AC-009/AC-010's mutant-killing differential tests a
> real DEFAULT-CI injection point (no `#[ignore]`, no `JR_RUN_KEYRING_TESTS`),
> so the Task-14 `.cargo/mutants.toml examine_globs` addition for `list.rs` is
> a genuinely TRUE coverage signal rather than a partially-false one. AC-004,
> AC-005, AC-006, AC-007, AC-009, AC-010 are reworded below; AC-013 (LOW-1,
> BC-1.6.049 Postcondition 3 explicit no-color assertion) and AC-014 (the F-1
> purity/default-CI confirmation) are NEW. This is a pure story-level/
> implementation-shape revision — it does not change BC-1.6.048/049's own
> text (their "Preferred implementation shape" language already permits this
> caller-selects-the-probe split; it does not mandate the probe live inside
> the renderer specifically) and does not touch product code.

> **STORY REVISED (2026-09-10, F3 adversary pass-2, findings LOW-2/LOW-3/
> MEDIUM-1-reconciliation):** AC-001/AC-002/AC-003/AC-011/AC-012 now each
> carry an explicit **Test method: DEFAULT CI** tag, for consistency with
> every other AC in this story (all five were already default-CI-testable
> — pure `derive_auth_state` unit tests plus the injected-state snapshot
> regen — this is a labeling fix only, no assertion content changed).
> Task 14 now includes a reconciliation note cross-referencing
> `S-cycle7-credential-absence-fix`'s Task 10a: this story adds NO
> `exclude_re` entry to `.cargo/mutants.toml` (its own code is fully
> default-CI-testable per the F3 pass-1 F-1 fix); the one `exclude_re`
> entry in that shared file, scoped to `load_api_token`, belongs to Story A
> alone. This is a pure labeling/reconciliation revision — it does not
> change any AC's assertion content and does not touch product code or any
> BC/VP spec.

> **STORY REVISED (2026-09-10, F3 adversary pass-3, finding MED-1):** the
> F3 pass-2 reconciliation note above ("this story adds NO `exclude_re`
> entry of its own") is CORRECTED, not merely re-confirmed — it was itself
> incomplete. AC-004's/AC-009's kind-specific probe SELECTION logic (the
> `auth_method == "oauth" => load_oauth_tokens(...).is_ok()` / `_ =>
> load_api_token(...).is_ok()` match) is extracted into its own small,
> file-local, NAMED function, `probe_matching_kind_credential(profile: &str,
> auth_method: &str) -> bool`, defined in `src/cli/auth/list.rs` and called
> from `collect_probe_results`. This function's body is EXACTLY the
> production code AC-005/AC-006/AC-009's differential tests do NOT exercise
> — those tests inject a `probe_results` value or a counting closure
> DIRECTLY, deliberately bypassing the real keychain-reading match arms
> (that is the whole point of the F-1 fix's injection seam). A mutant
> inside `probe_matching_kind_credential` itself (e.g. flipping which
> branch of the `auth_method` match calls which loader, or replacing
> `.is_ok()` with a constant) is therefore NOT killable by any DEFAULT-CI
> test this story writes — it has no in-memory injection seam, the same
> `load_api_token`/`load_oauth_tokens` coverage boundary VP-AUTHDX-005/006
> already documents. Task 14's `.cargo/mutants.toml examine_globs` addition
> for `list.rs` therefore now ALSO requires a JUSTIFIED `exclude_re` pair
> scoped to this one function (mirroring Story A's `load_api_token`
> exclusion design) — see the new **Mutation Testing Scope —
> `probe_matching_kind_credential` Exclusion** section below. AC-004,
> AC-009, Task 11, Task 14, the Architecture Mapping table, and the Purity
> Classification table are revised accordingly. This is completeness of the
> F-1 injection-seam fix (it does not reverse it — the injection seam
> itself is unchanged and still what makes AC-005/006/007/009/010's tests
> DEFAULT-CI-runnable), not a new design decision, and does not touch
> product code or any BC/VP spec text.

> **STORY REVISED (2026-09-10, F3 adversary pass-4, findings MEDIUM-1 and
> LOW-1):**
>
> **MEDIUM-1 (fallout from `S-cycle7-credential-absence-fix`'s own MEDIUM-1
> fix):** Task 14's "confirm `src/api/auth.rs` entry exists rather than add
> a duplicate — a no-op confirmation if A lands first, or add it if this
> story lands first and A's PR is still pending" clause is REMOVED. Story A's
> own Task 10 (the whole-file `src/api/auth.rs` `examine_globs` addition
> this confirm-or-add clause depended on) has been DROPPED and deferred — see
> that story's "Deferred: `src/api/auth.rs` Mutation-Scope Expansion"
> section. Consequently, this story's implementer must NOT add
> `src/api/auth.rs` to `examine_globs` under ANY circumstance, including as
> the "this story lands first" fallback the removed clause described — that
> whole-file addition is deferred cycle-wide, not merely reassigned to
> whichever of A/B1 lands first. This story's OWN `examine_globs` scope is
> unchanged and unaffected: it still owns `src/cli/auth/list.rs`'s entry
> exclusively (Task 14) with its own `probe_matching_kind_credential`
> `exclude_re` pair (Task 14a) — neither of which touches `src/api/auth.rs`.
>
> **LOW-1:** the File Structure Requirements table's test-placement row is
> corrected. AC-005/AC-006/AC-007/AC-009's tests call `render_list_table`/
> `render_list_json`/`collect_probe_results` DIRECTLY as injected-input
> calls against these `pub(crate)` symbols (per their own AC/Test text,
> unchanged) — `pub(crate)` symbols are NOT visible from the `tests/`
> integration crate (a separate compilation unit), so these tests MUST be
> inline (`src/cli/auth/tests/mod.rs` or an inline `#[cfg(test)] mod`,
> matching the existing `list_table_snapshot`/`list_json_shape` precedent
> this story's own Task 13a already cites at `src/cli/auth/tests/mod.rs:519`/
> `:526`). The AC bodies were always correct about calling these functions
> DIRECTLY; only the File Structure Requirements destination table
> incorrectly routed them to `tests/`. See the revised table below.
>
> Neither finding changes any AC's assertion content, exit code, or message
> text, and neither touches product code or any BC/VP spec.

> **STORY REVISED (2026-09-11, F3 adversary pass-8, finding MEDIUM-1):**
> Task 13a's `render_list_table`/`render_list_json` signature-fallout
> enumeration is completed. Task 12's `probe_results` parameter addition
> (grep-confirmed at pass-8 time) affects FOUR existing call sites in
> `src/cli/auth/tests/mod.rs`, not the two Task 13a originally listed:
>
> 1. `list_table_snapshot` (`:519`, call at `:521`) — already covered by
>    Task 13a.
> 2. `list_json_shape` (`:526`, call at `:528`) — already covered by
>    Task 13a.
> 3. `test_render_list_table_headers_include_env_between_url_and_auth`
>    (`:607`, call at `:609`) — NEWLY ADDED by this revision. Calls
>    `render_list_table(&empty, "default")` against an empty
>    `GlobalConfig::default()` (no profiles at all); its assertions target
>    only header ORDER (`NAME`/`URL`/`ENV`/`AUTH`/`STATUS` column positions),
>    never any STATUS cell value, so the mechanical fix is to pass an empty
>    `probe_results` value (e.g. `&HashMap::new()` / `&BTreeMap::new()`,
>    matching whatever container type Task 12 settles on) — a pure
>    compile-fallout fix, no new assertion.
> 4. `test_render_list_json_env_key_is_verbatim_and_never_omitted` (`:629`,
>    call at `:660`) — NEWLY ADDED by this revision. Calls
>    `render_list_json(&global, "tagged")` against a 3-profile fixture; its
>    assertions target only the `"env"` key's verbatim/never-omitted
>    property (BC-1.6.047), never `"status"`'s value, so the mechanical fix
>    is to pass a `probe_results` value covering the fixture's three profile
>    names (`"tagged"`/`"untagged"`/`"empty-env"`) with any valid
>    `matching_kind_present` booleans (the test does not assert on them) —
>    a pure compile-fallout fix, no new assertion.
>
> Both newly-added sites are grep-confirmed as the ONLY other
> `render_list_table`/`render_list_json` call sites in the codebase besides
> the two Task 13a already covers and the one production call site inside
> `handle_list` (`list.rs:80`/`:83`, already covered by Task 12 itself) and
> the re-export at `src/cli/auth/mod.rs:15` (not a call site). Task 13a and
> the File Structure Requirements `tests/mod.rs` row are revised below to
> include all four sites. This is completeness of the LOW-3/pass-3
> signature-fallout note, not a new design decision — neither site's
> assertion content changes, and this does not touch product code or any
> BC/VP spec. No point re-estimate (both additions are mechanical
> compile-fixes, identical in kind to the two sites Task 13a already
> covered).

> **STORY REVISED (2026-09-11, F3 adversary pass-10, finding LOW-1):** the
> "Mutation Testing Scope — `probe_matching_kind_credential` Exclusion"
> section's own "Scope decision" paragraph is REWORDED below — it
> previously read as though AC-014's source-scan test is what "guards"
> `handle_list`'s own shape, which is misleading: a source-scan AC is not a
> mutation-testing coverage mechanism, and must not be described as one.
> AC-014's source-scan is a STATIC, STRUCTURAL check on
> `render_list_table`/`render_list_json`'s bodies only (no
> keychain-reading symbol referenced) — it never executes `handle_list`
> and therefore cannot kill any mutant inside it. Once Task 14 adds
> `src/cli/auth/list.rs` to `examine_globs` (whole file — no sub-file
> targeting exists) and this story's own diff modifies `handle_list` (Task
> 11 adds the `collect_probe_results` call), `cargo-mutants --in-diff` WILL
> generate mutants inside `handle_list` itself (arm swaps, render-call
> replacement, etc.) that no DEFAULT-CI test in this story kills —
> AC-005/AC-006/AC-007/AC-009/AC-010's tests call `render_list_table`/
> `render_list_json`/`collect_probe_results` DIRECTLY with injected input,
> deliberately bypassing `handle_list`'s own body, and `handle_list` itself
> requires a real `Config::load_with` call no default-CI unit test drives.
> The section is reworded below to acknowledge these as an
> ACCEPTED-SURVIVOR mutation residual — consistent with, not a new instance
> separate from, the whole-file `examine_globs` tradeoff this project
> already accepts for `src/main.rs`/`src/cli/queue.rs`'s branch-dense
> regions (`docs/specs/cargo-mutants-policy.md` §Scope, "whole-file scope,
> no sub-file targeting — same tradeoff as `main.rs`/`queue.rs`") — rather
> than implying it is covered by a non-mutation-testing mechanism. No
> `exclude_re` entry is added for `handle_list` (an `exclude_re` would
> SILENCE the residual from ever being reported rather than honestly
> document it as accepted). This does not change AC-014's own assertion
> content, does not touch product code or any BC/VP spec, and does not
> re-estimate `points`/`estimated_days`.

# S-cycle7-auth-state-derivation — Shared auth-state vocabulary + `auth list` truthful STATUS

## Narrative

- **As a** `jr` user or AI agent running `jr auth list` to decide which
  profile to use
- **I want to** see a STATUS column that reflects whether a profile actually
  has a USABLE, matching-kind credential stored — not merely whether a URL is
  configured
- **So that** I don't select a profile that will immediately fail with
  `NotAuthenticated` on the very next command, and so that `auth list`'s
  STATUS and `auth status`'s reported state can never silently disagree
  (the parity guarantee `S-cycle7-auth-status-json`, Wave 2, extends to the
  JSON `auth status` channel)

## Behavioral Contracts

| BC | Role | Clauses this story implements |
|----|------|-------------------------------|
| BC-1.6.048 | PRIMARY (new) | Postconditions 1, 2, 4 (the pure `derive_auth_state` helper + caller-side kind-specific probe selection); Invariants 1-3; EC-1.6.048-1/2/4 |
| BC-1.6.049 | PRIMARY (new) | Postconditions 1-4; Invariants 1-2; EC-1.6.049-1/2/3/4 |
| BC-1.6.046 | CROSS-REFERENCE (amended, fixture-regen obligation only) | The "All STATUS cells `configured`" 3-profile insta-snapshot fixture line, flagged stale by BC-1.6.049's own Description, must be regenerated in this story's burst |

**Not implemented by this story (deferred to Wave 2, `S-cycle7-auth-status-json`):** BC-1.6.050 (`auth status --output json`) and the text-channel half of BC-1.6.048 Postcondition 3 (VP-AUTHDX-029) — this story's scope is `derive_auth_state`'s existence plus `auth list`'s wiring only. The full two-machine-channel parity VP-AUTHDX-024 asserts is only end-to-end-provable once Wave 2 lands; this story proves the pure-function half plus the call-site-level regression (both `list.rs` renderers call the identical helper).

## Acceptance Criteria

### AC-001 (traces to BC-1.6.048 postcondition 1)
A new pure function `derive_auth_state(url: Option<&str>, matching_kind_present: bool) -> AuthState` (3-value enum: `Unset`/`NoCredentials`/`Configured`, serializing to `"unset"`/`"no-credentials"`/`"configured"`) returns `Unset` whenever `url.is_none()`, REGARDLESS of `matching_kind_present`. **(F3 adversary pass-3, finding LOW-2):** the parameter is `Option<&str>`, not `Option<Url>` — the real `ProfileConfig.url` field (`src/config.rs`) is `Option<String>`, and every actual call site (`list.rs`'s `p.url.as_deref()`, `status.rs`'s equivalent) already produces a borrowed `&str`. `derive_auth_state` only ever calls `.is_none()` on this parameter — it never parses, validates, or otherwise needs a `Url`-typed value — so pinning `Url` would force a needless (and currently nonexistent) conversion at every call site for no behavioral benefit. This is a pure signature-shape correction; it does not change BC-1.6.048's "Preferred implementation shape" text, which already describes the parameter generically as "the profile's configured URL," not as any specific Rust type.
**Test:** `test_bc_1_6_048_derive_auth_state_url_none_always_unset`. **Test method: DEFAULT CI** (pure function call, no keychain).

### AC-002 (traces to BC-1.6.048 postcondition 1)
`derive_auth_state` returns `NoCredentials` when `url.is_some()` AND `matching_kind_present == false`.
**Test:** `test_bc_1_6_048_derive_auth_state_url_some_no_match_yields_no_credentials`. **Test method: DEFAULT CI** (pure function call, no keychain).

### AC-003 (traces to BC-1.6.048 postcondition 1)
`derive_auth_state` returns `Configured` when `url.is_some()` AND `matching_kind_present == true`.
**Test:** `test_bc_1_6_048_derive_auth_state_url_some_match_yields_configured`. **Test method: DEFAULT CI** (pure function call, no keychain).

### AC-004 (traces to BC-1.6.048 postcondition 2, "Preferred implementation shape")
The CALLER — specifically `src/cli/auth/list.rs::handle_list` (the EFFECTFUL command handler; per the F3 adversary-pass-1 finding F-1 fix, the probe lives HERE, never inside `render_list_table`/`render_list_json` — see the Architecture Mapping table and Architecture Compliance Rules below), via a small probing-loop helper `handle_list` calls (e.g. `collect_probe_results`, implementer's naming choice) — selects and invokes the kind-specific probe by the profile's configured `auth_method`, via a small NAMED function `probe_matching_kind_credential(profile: &str, auth_method: &str) -> bool` (F3 adversary pass-3, finding MED-1 — extracted specifically so its mutation-testing exclusion, below, can be file+function-name anchored rather than requiring line:col pins): `auth_method == "oauth"` → `load_oauth_tokens(profile).is_ok()`; `auth_method == "api_token"` (or unset/legacy) → `load_api_token(profile).is_ok()` — its `.is_ok()` `bool` outcome is collected per-profile into a `probe_results` value that `handle_list` passes down to the now-PURE renderers. `derive_auth_state` itself performs NO probing/IO and is NEVER called with `probe_stored_credential_kind`'s output as a comparison input.
**Test:** `test_bc_1_6_048_derive_auth_state_is_pure_no_io` (a compile-time/signature-level check plus a call-site source-scan asserting `probe_stored_credential_kind` does not appear as an input to `derive_auth_state`, AND — per the F-1 fix — that `render_list_table`/`render_list_json` contain no reference to `load_oauth_tokens`/`load_api_token`/any keychain-reading symbol). **Test method: DEFAULT CI** (source-scan + signature check; no keychain). **Coverage boundary (MED-1):** `probe_matching_kind_credential`'s OWN body (the real `load_oauth_tokens`/`load_api_token` invocations) has no DEFAULT-CI test and is a documented, `exclude_re`'d mutation-testing residual — see the Mutation Testing Scope section below. This AC's own test does not, and is not intended to, kill mutants inside that function's body.

### AC-005 (traces to BC-1.6.048 EC-1.6.048-2 / VP-AUTHDX-025 differential, the #788 defect killed directly)
An `oauth`-method profile holding ONLY a stored api-token pair — modeled, per the F-1 fix, as an INJECTED `probe_results` entry of `matching_kind_present == false` passed DIRECTLY into `render_list_table`/`render_list_json` as their `probe_results` parameter (no real keychain call in this test; that `handle_list`'s own probe-selection logic would in fact compute this same `false` for such a profile is AC-004's/AC-009's concern, not this AC's) → `derive_auth_state` returns `NoCredentials`, NOT `Configured`. A mutant reverting either `list.rs` renderer to `url.is_some()`-only, OR a mutant that makes either renderer ignore its injected `probe_results` parameter and probe the keychain directly instead, fails this test.
**Test:** `test_bc_1_6_049_list_status_derives_from_probe_not_url` (mismatched-kind fixture arm, calling `render_list_table`/`render_list_json` directly with a constructed `probe_results` value). **Test method: DEFAULT CI** (pure renderer call, injected boolean, no keychain — the direct fix for F-1: this differential was previously reachable only under `#[ignore]+JR_RUN_KEYRING_TESTS=1`).

### AC-006 (traces to BC-1.6.048 EC-1.6.048-4 / VP-AUTHDX-025 both-kinds fixture)
An `api_token`-method profile holding BOTH a stored api-token pair AND a stored (orphaned/unused) OAuth pair — modeled, per the F-1 fix, as an INJECTED `probe_results` entry of `matching_kind_present == true` (the outcome `load_api_token(profile).is_ok()` would in fact produce, succeeding regardless of the orphaned OAuth pair) passed DIRECTLY into `render_list_table`/`render_list_json` — → `derive_auth_state` returns `Configured`. This is the exact case a `probe_stored_credential_kind`-comparison design (rejected at F2, see BC-1.6.048's STATUS notes) would get wrong.
**Test:** `test_bc_1_6_049_list_status_derives_from_probe_not_url` (both-kinds fixture arm, same injected-`probe_results` mechanism as AC-005). **Test method: DEFAULT CI** (injected boolean, no keychain).

### AC-007 (traces to BC-1.6.049 postcondition 1)
`render_list_table`'s STATUS column and `render_list_json`'s `"status"` field both derive their value via the shared `derive_auth_state` helper, fed from their `probe_results` parameter — never `url.is_some()` alone (the current, defective implementation at `src/cli/auth/list.rs:33` and `:64`), and never by probing the keychain themselves (per the F-1 fix; see AC-004/Architecture Compliance Rules).
**Test:** `test_bc_1_6_049_list_status_derives_from_probe_not_url` (differential assertion, both renderers, injected `probe_results`). **Test method: DEFAULT CI**.

### AC-008 (traces to BC-1.6.049 postcondition 2)
The JSON `"status"` field's string values are exactly `"unset"` / `"no-credentials"` / `"configured"`. The `"name"`/`"url"`/`"env"`/`"auth_method"`/`"active"` fields are UNCHANGED — no schema field is added or removed by this story, only `"status"`'s derivation and value set.
**Test:** `test_bc_1_6_049_list_json_schema_unchanged_except_status_values`

### AC-009 (traces to BC-1.6.049 postcondition 4 / invariant 1)
`auth list` against N configured profiles issues AT MOST N calls to the kind-specific keychain probe — exactly ONE per profile with `url.is_some()`, and ZERO for any profile with `url: None` (never probed — nothing to probe against). Per the F-1 fix, this probing loop is extracted into its own small function (implementer's naming choice, e.g. `collect_probe_results(global: &GlobalConfig, probe: impl Fn(&str, &str) -> bool) -> probe_results`, called once from `handle_list`) that accepts the kind-specific probe as an INJECTABLE parameter: production wires `probe_matching_kind_credential` (MED-1's named function, AC-004) as the real `load_oauth_tokens`/`load_api_token`-backed argument; the test wires a call-counting closure instead. This is what makes the LOOP's call-count property (call `collect_probe_results`'s injected `probe` parameter once per `url: Some` profile, zero times per `url: None` profile) verifiable without a real keychain, closing the F-1 gap.
**Test:** `test_bc_1_6_049_list_probes_at_most_once_per_url_profile` (injected counting closure over a fixture `GlobalConfig` mixing `url: Some`/`url: None` profiles). **Test method: DEFAULT CI** (injected closure, no keychain). **Scope note (MED-1):** this test proves `collect_probe_results`'s CALL-COUNT behavior (the loop/gating logic), which IS fully default-CI-testable and must NOT be swept into the `probe_matching_kind_credential` exclusion below — only the production probe function's own body (the real keychain reads) is the excluded residual.

### AC-010 (traces to BC-1.6.049 invariant 2 / VP-AUTHDX-024 call-site regression)
`render_list_table` and `render_list_json` both call the IDENTICAL shared `derive_auth_state` helper function, sourcing each profile's `matching_kind_present` value from their shared `probe_results` PARAMETER — never by probing the keychain themselves (per the F-1 fix) — asserted structurally (not merely by matching output), so a future refactor that reintroduces a second, textually-similar-but-separate implementation in one renderer, OR that has one renderer read the keychain directly instead of its `probe_results` parameter, is caught even if its output happens to coincidentally match today's fixtures.
**Test:** `test_bc_1_6_049_both_renderers_share_derive_auth_state_call_site`. **Test method: DEFAULT CI** (structural/source-scan check, no keychain).

### AC-011 (traces to VP-AUTHDX-024 safety invariant, pure-function half)
For the full profile-configuration state space this story's pure function covers (`url: None/Some` × `matching_kind_present: true/false`, i.e. all 4 classes collapsing onto the 3-value `AuthState` enum, across both `api_token` and `oauth` auth methods at the call-site level), `derive_auth_state`'s output is a total, deterministic function of its two inputs with no hidden state. This story proves the SHARED-HELPER half of VP-AUTHDX-024's parity guarantee (one function, not two independently-maintained implementations); the full end-to-end `auth list` vs. `auth status --output json` cross-command parity is completed by `S-cycle7-auth-status-json` (Wave 2), which reuses this exact helper.
**Test:** `test_bc_1_6_048_derive_auth_state_exhaustive_truth_table` (proptest or exhaustive enumeration over the 4-class domain). **Test method: DEFAULT CI** (pure function, proptest/exhaustive enumeration — no keychain).

### AC-012 (traces to BC-1.6.046 cross-reference note / F4 fixture-regen obligation)
`BC-1.6.046`'s 3-profile `auth list` insta snapshot (`src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap`) is regenerated in this story's burst: its stale "All STATUS cells `configured`" fixture description is corrected to reflect real, probe-derived STATUS values for the test's mocked/injected keychain state (which may not report all three profiles as `configured` once probing is real).
**Test:** regenerated `.snap` file reviewed and committed; `cargo insta review` (or equivalent) run as part of this task, not a new `#[test]` function. **Test method: DEFAULT CI** (injected/mocked keychain state feeding the fixture — see H-W1-INT-004's snapshot-regen-discipline check; no real keyring backend required).

### AC-013 (traces to BC-1.6.049 postcondition 3, NEW — F3 adversary pass-1, finding LOW-1)
The table's STATUS column renders all three vocabulary values (`unset`/`no-credentials`/`configured`) as PLAIN TEXT — no color, icon, or other visual/ANSI treatment is added to the STATUS column by this story. This is an explicit, standalone assertion (distinct from AC-012's snapshot regeneration) so a mutant that adds styling to the STATUS column specifically is caught directly rather than only incidentally via a snapshot diff.
**Test:** an explicit assertion within the EXISTING `list_table_snapshot` test's body (`src/cli/auth/tests/mod.rs:519`; **(F3 adversary pass-3, finding LOW-3):** this is the real, current test name — a prior draft of this AC cited a nonexistent `test_bc_1_6_046_list_table_snapshot`, which does not exist in the codebase and must not be searched for or newly created under that name) — or an adjacent dedicated test — that the rendered STATUS cell string contains no ANSI escape sequence (`\x1b[`) and matches the plain vocabulary string exactly, for all three values. **Test method: DEFAULT CI**.

**Signature-fallout note (LOW-3):** `list_table_snapshot` (line 519) and the neighboring `list_json_shape` (line 526) both call `render_list_table`/`render_list_json` with those functions' CURRENT signatures (`global`, `active` only). Task 12 (BC-1.6.046 snapshot regen) and Task 3 (AC-005/AC-006 injected-`probe_results` tests) both require these two existing tests to be mechanically updated to pass a `probe_results` argument once `render_list_table`/`render_list_json` gain that new parameter (Task 12/AC-004) — this is routine signature fallout from the parameter addition, not a new behavioral assertion, and must not be treated as out of scope for this story's burst.

### AC-014 (traces to BC-1.6.048 postcondition 2, "Preferred implementation shape" / VP-AUTHDX-024 coverage boundary; NEW — F3 adversary pass-1, finding F-1: renderer purity / default-CI coverage confirmation)
`render_list_table` and `render_list_json` are PURE with respect to credential probing: neither references `load_oauth_tokens`, `load_api_token`, or any other keychain-reading symbol anywhere in their bodies — ALL kind-specific probing happens in `handle_list` (or the extracted `collect_probe_results`-style helper it calls), never inside either renderer. This closes the F-1 gap under which AC-005/AC-006/AC-009's mutant-killing differential tests were previously reachable ONLY under `#[ignore]+JR_RUN_KEYRING_TESTS=1`, making the Task-14 `.cargo/mutants.toml examine_globs` addition for `list.rs` a genuinely TRUE (not partially-false) coverage signal for the renderer-reversion mutant class this story exists to kill.
**Test:** `test_bc_1_6_049_renderers_are_probe_free` (source-scan, mirrors AC-004's pattern) PLUS a PR-time confirmation (Task 16) that AC-005/AC-006/AC-007/AC-009/AC-010's test functions carry no `#[ignore]` attribute and need no `JR_RUN_KEYRING_TESTS` env var. **Test method: DEFAULT CI**.

## Mutation Testing Scope — `probe_matching_kind_credential` Exclusion (F3 adversary pass-3, MED-1)

**Problem this section closes:** without scoping, adding whole-file
`src/cli/auth/list.rs` to `examine_globs` (Task 14) would report every
mutant inside `probe_matching_kind_credential`'s body — the one piece of
this story's OWN new code that genuinely has no default-CI injection
seam — as MISSED/survived under `cargo mutants --in-diff` on this story's
own PR gate. This is the exact partially-false-coverage anti-pattern this
story's own F-1 fix eliminated for the renderers; MED-1 closes the one
remaining instance of it (the production probe-selection function itself,
as opposed to the renderers and the `collect_probe_results` loop, both of
which ARE fully default-CI-tested via AC-005/006/007/009/010's injection
seams).

**Scope decision:** the `exclude_re` allowlist below covers ONLY
`probe_matching_kind_credential` — NOT `collect_probe_results` (its
call-count/gating logic IS covered by AC-009's injected counting closure)
and NOT `handle_list` (no `exclude_re` entry is written for it either).
This keeps the `exclude_re` allowlist as narrow as Story A's
`load_api_token` exclusion is broad-but-justified — here, unlike
`load_api_token`, only ONE small function is genuinely untestable in
default CI, so only that one function is formally excluded from mutation
reporting.

**`handle_list` is an ACCEPTED-SURVIVOR mutation residual, not a
source-scan-covered function (LOW-1 correction, F3 adversary pass-10):**
`handle_list` is a thin dispatcher, and this story's own diff modifies it
(Task 11 wires the new `collect_probe_results` call in). Once Task 14 adds
`src/cli/auth/list.rs` to `examine_globs` as a WHOLE FILE (no sub-file
targeting mechanism exists in `cargo-mutants` — the same tradeoff
`docs/specs/cargo-mutants-policy.md` already documents for
`src/main.rs`/`src/cli/queue.rs`'s branch-dense regions), `cargo-mutants
--in-diff` WILL generate mutants inside `handle_list`'s own body (e.g.
swapping/removing the `collect_probe_results` call, replacing a
`render_list_table`/`render_list_json` argument, reordering match arms).
None of this story's DEFAULT-CI tests kill them: AC-005/AC-006/AC-007/
AC-009/AC-010's tests call `render_list_table`/`render_list_json`/
`collect_probe_results` DIRECTLY as injected-input unit tests, deliberately
bypassing `handle_list`'s own body (that is what makes them DEFAULT-CI-
runnable at all — see the AC-004/AC-009 Test notes above), and `handle_list`
itself requires a real `Config::load_with` call that no default-CI unit
test in this story drives. AC-014's source-scan test is a STATIC,
STRUCTURAL check on `render_list_table`/`render_list_json`'s bodies only
(asserting no keychain-reading symbol is referenced) — it never executes
`handle_list` and therefore CANNOT kill any mutant inside `handle_list`'s
own control flow. It is not a substitute for mutation coverage of
`handle_list` and must not be described as one.

These `handle_list` mutants are therefore left as an ACCEPTED-SURVIVOR
residual — consistent with, not a new instance separate from, the same
accepted-survivor class `main.rs`/`queue.rs`'s branch-dense regions already
carry under their own whole-file `examine_globs` entries (there is no
sub-file targeting mechanism to exclude only `handle_list` while still
gaining a genuine default-CI-backed signal for `render_list_table`/
`render_list_json`/`collect_probe_results`/`derive_auth_state`/
`probe_matching_kind_credential` in the same file). Deliberately, NO
`exclude_re` entry is written for `handle_list`: an `exclude_re` entry
SILENCES a mutant from ever being reported, which would hide this residual
rather than honestly document it as accepted; an accepted survivor, by
contrast, is expected to show up in `cargo mutants --in-diff`'s MISSED
output for this story's PR gate and is accepted as-is — the same posture
this project already takes for `main.rs`/`queue.rs`. Task 16's "F-1 closure
verification" step (confirming AC-005/006/007/009/010/014 pass under
DEFAULT CI, no `#[ignore]`) is unaffected by this — it verifies TEST
coverage, not MUTATION coverage, and `handle_list`'s accepted-survivor
status does not block it or this story's PR gate.

**Exact `.cargo/mutants.toml` diff (append to the existing `exclude_re`
array, immediately after Story A's `load_api_token` entries):**

```toml
# JUSTIFIED EXCLUSION (S-cycle7-auth-state-derivation, F3 adversary
# pass-3, finding MED-1) — mirrors Story A's load_api_token exclusion
# design (file+function-name anchored, two-shape). See
# docs/specs/cargo-mutants-policy.md §Exclusions / FIX-F6-A.
#
# `probe_matching_kind_credential` (src/cli/auth/list.rs) selects and
# invokes the real `load_oauth_tokens`/`load_api_token` keychain probe by
# auth_method. It has no in-memory injection seam (VP-AUTHDX-005/006's own
# documented coverage boundary) — AC-005/006/007/009/010's differential
# tests deliberately inject a `probe_results` value or a counting closure
# DIRECTLY, bypassing this function's body entirely (that is what makes
# them DEFAULT-CI-runnable at all). A mutant inside this one function is
# therefore reachable only by a real keychain-backed test, which this
# project does not run in default CI.
#
# Scope is ONLY this one function — `collect_probe_results` (the injectable
# call-count loop, covered by AC-009) and `handle_list` (thin dispatcher)
# are NOT excluded and must continue to show a TRUE default-CI coverage
# signal.
#
# VERIFY BEFORE LANDING: run `cargo mutants --file src/cli/auth/list.rs
# --list` against the POST-implementation code and confirm every listed
# `probe_matching_kind_credential` mutant matches one of the two regexes
# below, and no mutant belonging to `collect_probe_results`, `handle_list`,
# `render_list_table`, or `render_list_json` is inadvertently matched. Any
# `handle_list` mutants the dry-run lists are an EXPECTED, ACCEPTED-SURVIVOR
# residual (LOW-1, F3 adversary pass-10 — see the "Scope decision" prose
# above) — do NOT widen either regex below to also match `handle_list`; a
# `handle_list` mutant showing MISSED under `cargo mutants --in-diff` on
# this story's own PR gate is the correct, honest outcome, not a failure to
# fix here.
'^src/cli/auth/list\.rs:\d+:\d+: replace probe_matching_kind_credential .*$',
'^src/cli/auth/list\.rs:\d+:\d+: .+ in probe_matching_kind_credential$',
```

These two lines are appended INTO the existing `exclude_re = [...]` array
(`.cargo/mutants.toml:132-134` plus Story A's own additions), not a second
array.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| `derive_auth_state` (NEW) | `src/api/auth.rs` | Pure-core (no IO, total function over 2 inputs) |
| `probe_matching_kind_credential` (NEW; F3 adversary pass-3 finding MED-1) | `src/cli/auth/list.rs` | Effectful-shell (invokes `load_oauth_tokens`/`load_api_token`, which read the OS keychain) — the one genuinely untestable-in-default-CI residual this story introduces; `exclude_re`'d per the Mutation Testing Scope section above |
| `collect_probe_results` (NEW; F3 adversary pass-1 finding F-1) | `src/cli/auth/list.rs::handle_list` (extracted per-profile-loop helper it calls) | Effectful-shell, but its LOOP/gating logic is fully default-CI-testable — the kind-specific probe is passed in as an injectable parameter (production wires `probe_matching_kind_credential`; tests wire a counting closure, AC-009) |
| `render_list_table`/`render_list_json` | `src/cli/auth/list.rs` | Pure-core (REVISED, F-1 fix — was effectful-shell) — receive a pre-computed per-profile `probe_results` parameter from `handle_list` and call `derive_auth_state`; perform NO keychain probing themselves |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-1.6.048-1 | A profile with `url: Some` whose ONLY stored credential is the legacy shared flat pair (no namespaced pair) | `no-credentials`, not `configured` — mirrors BC-1.4.032's no-copy contract exactly |
| EC-1.6.048-3 | A profile transitions from `no-credentials` to `configured` mid-session (concurrent `jr auth login` elsewhere) | The NEXT invocation reflects the new state — no caching of auth-state across invocations |
| EC-1.6.049-1 | A profile with `url: Some` and ONLY a legacy-flat-pair credential | `no-credentials`, per BC-1.6.048 EC-1.6.048-1 |
| EC-1.6.049-3 | N profiles configured on a platform where each keychain read can trigger an OS-level access prompt | `auth list` may issue up to N such prompts — accepted, known UX cost, not a regression to eliminate this cycle |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `derive_auth_state` | pure-core | Total function, 2 inputs, no IO, no hidden state — the exact shape BC-1.6.048's "Preferred implementation shape" mandates |
| `src/cli/auth/list.rs::render_list_table`/`render_list_json` | pure-core (REVISED, F-1 fix — was effectful-shell) | Take a pre-computed `probe_results` parameter and call `derive_auth_state`; no keychain access, no IO — moved from effectful-shell to pure-core so AC-005/AC-006/AC-009/AC-010's mutant-killing tests run in DEFAULT CI |
| `src/cli/auth/list.rs::handle_list` (and its extracted probing-loop helper, `collect_probe_results`) | effectful-shell (NEW locus, F-1 fix) | Performs the kind-specific keychain probe per profile (via the injectable `probe_matching_kind_credential`), then calls the pure renderers with the collected `probe_results`; `collect_probe_results`'s own loop/gating logic is default-CI-testable via the injection seam (AC-009) |
| `src/cli/auth/list.rs::probe_matching_kind_credential` | effectful-shell (NEW, F3 adversary pass-3 finding MED-1) | The real `load_oauth_tokens`/`load_api_token` invocation; no in-memory injection seam — this is the one function this story's diff introduces that is NOT default-CI-testable, `exclude_re`'d per the Mutation Testing Scope section above |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~5,200 |
| Referenced code files (`src/api/auth.rs` relevant region, `src/cli/auth/list.rs` full file, `src/config.rs::Profile`) | ~8,000 |
| Test files (new pure-function unit tests, `list.rs` injected-`probe_results`/closure tests, purity source-scan, insta snapshot) | ~7,000 |
| Tool outputs overhead (cargo test/insta review/clippy runs, grep) | ~4,000 |
| **Total** | **~24,200** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~12%** |

Well under the 20-30% threshold — no split needed.

## Tasks

1. [ ] Write failing tests for AC-001/AC-002/AC-003/AC-011 (`derive_auth_state`'s exhaustive truth table) — `test-writer`
2. [ ] Write failing test for AC-004 (purity/no-IO + `probe_stored_credential_kind` source-scan, EXTENDED per the F-1 fix to also assert `render_list_table`/`render_list_json` reference no keychain-reading symbol) — `test-writer`
3. [ ] Write failing tests for AC-005/AC-006 (mismatched-kind and both-kinds fixtures, calling `render_list_table`/`render_list_json` DIRECTLY with an injected `probe_results` value — DEFAULT CI, no keychain, per the F-1 fix) — `test-writer`
4. [ ] Write failing test for AC-007/AC-008 (both renderers derive via the shared helper from their injected `probe_results` parameter; JSON schema unchanged except values) — `test-writer`
5. [ ] Write failing test for AC-009 (conditional-probe call-count assertion, via an injected counting closure into the extracted probing-loop helper — DEFAULT CI, per the F-1 fix) — `test-writer`
6. [ ] Write failing test for AC-010 (call-site structural regression — both renderers share `derive_auth_state`, neither probes the keychain directly) — `test-writer`
7. [ ] Write failing test for AC-013 (LOW-1: STATUS column plain-text/no-ANSI assertion) — `test-writer`
8. [ ] Write failing test for AC-014 (F-1: renderer purity source-scan) — `test-writer`
9. [ ] Verify Red Gate: all new tests fail against current `url.is_some()`-only code
10. [ ] Implement `derive_auth_state` in `src/api/auth.rs` (pure, `pub(crate)` or `pub`, per implementer's judgment on visibility needs from `list.rs`/the Wave-2 `status.rs` consumer) — `implementer`
11. [ ] Implement the EFFECTFUL probing step: a small NAMED function `probe_matching_kind_credential(profile: &str, auth_method: &str) -> bool` (F3 adversary pass-3, MED-1 — named specifically so it can be `exclude_re`'d by file+function name, mirroring Story A's design) containing the kind-specific `auth_method == "oauth"` → `load_oauth_tokens`/else → `load_api_token` match; and `collect_probe_results` (or implementer's naming choice), an extracted per-profile-loop helper `handle_list` calls, producing a per-profile `probe_results` value with the probe passed in as an INJECTABLE parameter (generic/closure) — production wires `probe_matching_kind_credential`; AC-009's test wires a counting closure instead — `implementer`
12. [ ] Implement `render_list_table`/`render_list_json` as PURE functions taking `probe_results` as a new parameter, replacing the `p.url.is_some()` ternary with a `derive_auth_state` call fed from that parameter — NO keychain access inside either renderer — `implementer`
13. [ ] Regenerate the BC-1.6.046 insta snapshot (AC-012) — review and commit the new `.snap`
13a. [ ] **(F3 adversary pass-3, LOW-3; EXTENDED at F3 pass-8, MEDIUM-1, signature fallout)** Mechanically update ALL FOUR existing `src/cli/auth/tests/mod.rs` call sites of `render_list_table`/`render_list_json` to pass a `probe_results` argument per the new parameter added by Task 12 — routine call-site fallout from the signature change, not a new assertion:
    - `list_table_snapshot` (`:519`, call at `:521`) — confirm still compiles and passes via Task 13's snapshot regen
    - `list_json_shape` (`:526`, call at `:528`) — confirm still compiles and passes via a plain rebuild
    - `test_render_list_table_headers_include_env_between_url_and_auth` (`:607`, call at `:609`) — pass an EMPTY `probe_results` value (test uses `GlobalConfig::default()`, no profiles; asserts header order only, never a STATUS cell value) — confirm still compiles and passes unmodified otherwise
    - `test_render_list_json_env_key_is_verbatim_and_never_omitted` (`:629`, call at `:660`) — pass a `probe_results` value covering the fixture's three profile names (`"tagged"`/`"untagged"`/`"empty-env"`), any valid booleans (test asserts only the `"env"` key, never `"status"`) — confirm still compiles and passes unmodified otherwise
14. [ ] Add `src/cli/auth/list.rs` to `.cargo/mutants.toml` `examine_globs` — **NOT currently present** (confirmed absent by grep at F3 time). **Ownership reconciliation (F3 adversary pass-3, MED-1, supersedes the pass-1 draft):** this story owns `list.rs`'s `examine_globs` entry EXCLUSIVELY (Story A no longer adds `list.rs`/`status.rs` — see A's own revised Task 10 — and `status.rs`'s entry belongs solely to `S-cycle7-auth-status-json`'s Task 15, since that story is the one that actually modifies `status.rs`). **`src/api/auth.rs` is NOT added to `examine_globs` by this story, nor by any other cycle-007 story (F3 adversary pass-4, finding MEDIUM-1 — supersedes the pass-3 "confirm rather than add a duplicate" handling this bullet previously described).** `S-cycle7-credential-absence-fix`'s (Story A) own Task 10 whole-file `auth.rs` addition was DROPPED and deferred at F3 pass-4 (see that story's "Deferred: `src/api/auth.rs` Mutation-Scope Expansion" section) — this story's implementer must NOT add `src/api/auth.rs` to `examine_globs` under any circumstance, including as a fallback if Story A's PR is still pending; that whole-file addition is deferred cycle-wide, not reassigned to whichever of A/B1 lands first. This story's `examine_globs` scope is `src/cli/auth/list.rs` ONLY.
14a. [ ] **(F3 adversary pass-3, MED-1, corrects the pass-2 "no exclude_re" claim)** In the SAME commit as Task 14's `list.rs` `examine_globs` addition, append the two `probe_matching_kind_credential`-scoped `exclude_re` entries specified in this story's "Mutation Testing Scope — `probe_matching_kind_credential` Exclusion" section above to `.cargo/mutants.toml`'s `exclude_re` array, together with that section's justification comment. Run the section's "VERIFY BEFORE LANDING" dry-run check before the PR is opened. `derive_auth_state`, `collect_probe_results`'s loop logic, and the AC-014-purified `render_list_table`/`render_list_json` remain fully default-CI-testable and MUST NOT be swept into this exclusion — it covers `probe_matching_kind_credential` ONLY.
15. [ ] Refactor: confirm the renamed/removed `render_list_table` doc comment ("Status today is a coarse... check — credential-store probing comes in Task 13") is updated to reflect the new real-probe behavior, closing the self-documented provisional note
16. [ ] F-1 closure verification: confirm AC-005/AC-006/AC-007/AC-009/AC-010/AC-014's test functions carry NO `#[ignore]` attribute and require no `JR_RUN_KEYRING_TESTS` env var — run `cargo test` (default, no flags/env) and confirm all of them execute and pass, not merely compile
17. [ ] Add a CHANGELOG entry under `[Unreleased] > Fixed` describing the shipped behavior (truthful `auth list` STATUS), before creating the PR

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|----------------|------------------------|----------------------|
| S-cycle7-credential-absence-fix (this cycle, Wave 1, no dependency edge but shares `src/api/auth.rs`) | Independently fixes `load_api_token`'s two error-message branches | N/A — no shared code path with this story's `derive_auth_state` addition | Both stories touch `src/api/auth.rs`; **recommended intra-wave sequencing**: land whichever PR is ready first, the other rebases — no functional dependency, pure file-overlap risk (see `wave-schedule.md` §2) |
| S-cycle3-percred-storage (cycle-003) | Introduced `load_oauth_tokens`/`load_api_token`'s per-profile-namespaced pattern this story's kind-specific probe selection reuses verbatim | `.is_ok()` collapses any `Err` (absence or backend error alike) to `false` — this story's `matching_kind_present: bool` signature deliberately matches that collapse (see BC-1.6.048's round-4 STATUS note) rather than threading a `Result` through | A `Result<bool>`-typed `matching_kind_present` parameter was drafted and REJECTED at F2 (round 4, finding F-2) as unrealizable from this exact caller shape — do not reintroduce it |
| S-cycle3-env-tag (cycle-003) | Established the `src/cli/auth/list.rs` table/JSON dual-renderer pattern this story extends | `render_list_table` and `render_list_json` must never diverge on shared logic — exactly the invariant this story's AC-010 protects | N/A |
| (this story, F3 adversary pass-1, finding F-1 — forward-looking note for `S-cycle7-auth-status-json`, Wave 2) | Probe-then-format: the effectful kind-specific probe belongs in the command HANDLER, never inside a renderer/formatter; the renderer takes the already-computed `bool`/`AuthState` as a plain parameter | This pattern is what makes a renderer's mutant-killing tests runnable in DEFAULT CI — `S-cycle7-auth-status-json`'s `status()` JSON builder should follow the same split (see that story's own F-1 revision) | Do not let a "just call `derive_auth_state` inline while we're in here" shortcut reintroduce a keychain call inside a formatting function — that is precisely the regression this fix closes |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| `derive_auth_state` must be PURE — no IO, no keychain access, no `Result`-typed parameters | BC-1.6.048 Postcondition 2 "Preferred implementation shape" (locked, round 4) | AC-004/AC-011; a mutant/refactor that threads IO or `Result<bool>` into this function's signature is a spec violation, not a style choice |
| `derive_auth_state` must NOT be called with `probe_stored_credential_kind`'s output as an input | BC-1.6.048 Postcondition 2 (round 2 correction — `probe_stored_credential_kind` returns the first-present kind in FIXED PRIORITY order, not the kind matching `auth_method`) | AC-004's source-scan; `probe_stored_credential_kind` remains valid for ITS OWN distinct purpose (`login.rs`'s orphaned-pair cleanup) and must not be repurposed here |
| A profile with `url: None` is NEVER probed | BC-1.6.049 Invariant 1 | AC-009 |
| Both `list.rs` renderers must call the SAME `derive_auth_state` instance/function, never two separately-implemented equivalents | BC-1.6.049 Invariant 2, BC-1.6.048 Postcondition 2 ("Both call sites... MUST both call the identical `derive_auth_state`") | AC-010 |
| `render_list_table`/`render_list_json` must be PURE — no keychain access, no call to `load_oauth_tokens`/`load_api_token`/any keychain-reading symbol; the kind-specific probe runs ONLY in `handle_list` (or a helper it calls), which passes precomputed `probe_results` down | F3 adversary pass-1 finding F-1 (this story's own implementation-shape fix; consistent with, not a change to, BC-1.6.048 Postcondition 2's "Preferred implementation shape" pure-core/effectful-shell split) | AC-004, AC-005, AC-006, AC-007, AC-009, AC-010, AC-014; a mutant/refactor that reintroduces keychain access inside either renderer is a spec violation, not a style choice |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| `proptest` | Per `Cargo.toml` pin (existing dependency, unchanged) | AC-011's exhaustive/property-based truth-table coverage over `derive_auth_state`'s 4-class domain |
| `insta` | Per `Cargo.toml` pin (existing dev-dependency, unchanged) | AC-012's snapshot regeneration |

No new library is introduced — this story reuses the exact tools/versions already pinned in `Cargo.toml`.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `src/api/auth.rs` | modify | Add the new pure `derive_auth_state` function |
| `src/cli/auth/list.rs` | modify | `handle_list` gains an extracted `collect_probe_results` helper (effectful kind-specific probing loop with an injectable probe parameter) plus a new named `probe_matching_kind_credential` function (the real keychain-probe selector, MED-1); `render_list_table`/`render_list_json` become PURE, taking `probe_results` as a new parameter and calling `derive_auth_state`, replacing the `url.is_some()` ternary; update the stale doc comment |
| `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` | modify (regenerate) | BC-1.6.046 fixture regeneration (AC-012) |
| `src/cli/auth/tests/mod.rs` (inline `#[cfg(test)] mod`, matching the `list_table_snapshot`/`list_json_shape` precedent at `src/cli/auth/tests/mod.rs:519`/`:526`) | modify | **(F3 adversary pass-4, LOW-1 — corrects the destination previously given below)** Injected-`probe_results`/counting-closure unit tests for AC-005/AC-006/AC-007/AC-009 — these call `render_list_table`/`render_list_json`/`collect_probe_results` DIRECTLY as `pub(crate)` symbols with constructed/injected inputs, which CANNOT compile from the `tests/` integration crate (a separate compilation unit with no visibility into `pub(crate)` items). MUST be placed inline. **(F3 adversary pass-8, MEDIUM-1)** ALSO modify, as pure signature-fallout (Task 13a): the two additional pre-existing call sites `test_render_list_table_headers_include_env_between_url_and_auth` (`:607`, call at `:609`) and `test_render_list_json_env_key_is_verbatim_and_never_omitted` (`:629`, call at `:660`), which Task 12's `probe_results` parameter addition also breaks at compile time — neither test's own assertion content changes. |
| `tests/` (existing `tests/auth_profiles.rs` or a new file, implementer's judgment) | modify or create | Remaining tests that do not require direct `pub(crate)` symbol access — AC-008/AC-014 (DEFAULT CI, no keychain) |
| `.cargo/mutants.toml` | modify | Add `src/cli/auth/list.rs` to `examine_globs` (Task 14); append the two `probe_matching_kind_credential`-scoped `exclude_re` entries + justification comment (Task 14a). **`src/api/auth.rs` is NOT added by this story (F3 adversary pass-4, MEDIUM-1 — deferred; see `S-cycle7-credential-absence-fix`'s "Deferred: `src/api/auth.rs` Mutation-Scope Expansion" section).** |
| `CHANGELOG.md` | modify | `[Unreleased] > Fixed` entry (Task 17) |
