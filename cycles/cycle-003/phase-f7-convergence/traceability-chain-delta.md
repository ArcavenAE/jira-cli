---
document_type: traceability-chain-delta
level: ops
version: "1.0"
status: final
producer: spec-steward
phase: phase-f7-convergence
cycle: cycle-003
feature: auth-profile-dx
branch: develop
baseline_commit: 87f17aff
head_commit: 202414f2
input-hash: "a8aee06"
traces_to: ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md; .factory/cycles/cycle-003/phase-f7-convergence/consistency-audit-delta.md; .factory/STATE.md"
---

# Traceability Chain Delta — `auth-profile-dx` (cycle-003)

## Master chain file status

No master chain file exists yet at `.factory/cycles/cycle-003/convergence/traceability-chain.md`.
(A sibling cycle-002 file exists at `.factory/cycles/cycle-002/convergence/traceability-chain.md`;
cycle-003 has no equivalent on disk as of this write.) Per this agent's governance scope, this
delta file stands alone as the authoritative cycle-003 chain record rather than being silently
appended into a file that does not exist. **No new file was created at that path** — creating a
`cycle-003/convergence/` directory was judged unnecessary for this delta write, since the delta
file itself lives under the already-existing `phase-f7-convergence/` directory. If a future burst
wants a persistent cross-cycle master chain, it should be bootstrapped from this file plus
cycle-002's, not built from scratch.

## Chain shape

```
DEC-3xx -> BC-S.SS.NNN -> VP-AUTHDX-NNN -> test_xxx -> src/xxx.rs -> PR#/commit -> F5-ADV-CONVERGED -> F6(mutation/kani-sub)
```

`F5-ADV-CONVERGED` = 3/3 clean adversarial re-run passes (Pass A/lifecycle, Pass B/error-concurrency,
Pass C/spec-contract) on `develop` @ `202414f2`, per `.factory/STATE.md` Phase Progress row
`F5-CONVERGED (cycle-003)`. `F6(...)` cites the per-file mutation result and the Kani→proptest
substitution verdict from `.factory/cycles/cycle-003/phase-f6-hardening/summary.md`.

---

## 1. `S-cycle3-env-tag` (PR #752 @ `4d0ae2d5`)

| Field | Value |
|---|---|
| DEC | DEC-314 (`ProfileConfig.env` schema field), DEC-324 (`auth list` 5-column surfacing) |
| BC-1.6.046 | AMENDED — `auth list` 5th column, DEC-324 breaking snapshot change |
| BC-1.6.047 | NEW — `env` JSON/status surfacing, channel-split verbatim-vs-sanitized |
| BC-6.1.015 | NEW — `ProfileConfig.env` schema field |
| VP-AUTHDX-009 | Tolerant-reader round-trip / deserialization indistinguishability (bounds: BC-6.1.015) |
| test | `src/config.rs:2099`, `:2123`, `:2140` (three proptests) |
| src | `src/config.rs` (`ProfileConfig.env`), `src/cli/auth/list.rs`, `src/cli/auth/status.rs` |
| PR/commit | PR #752 @ `4d0ae2d5` |
| F5 | ADV-CONVERGED (3/3 clean, `develop` @ `202414f2`) |
| F6 | Mutation: 0 delta mutants attributed to this file set in the 28/28 in-diff scorecard breakdown beyond `src/cache.rs`/`src/output.rs`/`src/main.rs` (see F6 summary §3 per-file list — `config.rs`/`list.rs`/`status.rs` produced no `--in-diff` mutants this cycle); Kani-substitution: 0 GAP via VP-AUTHDX-009 |

BC-1.4.027/HIGH-1 and BC-1.4.029/HIGH-2 do **not** apply here — see story 2/3 below.

## 2. `S-cycle3-percred-storage` (PR #755 @ `d3ba2726`)

| Field | Value |
|---|---|
| DEC | DEC-315 (per-profile write clause, namespaced-key split) |
| BC-1.1.009 | AMENDED — `auth login --profile <new>` per-profile write clause |
| BC-1.1.010 | AMENDED — `auth login --profile X` vs `JR_PROFILE` per-profile write clause |
| BC-1.2.017 | AMENDED — same per-profile write clause, `JR_PROFILE=ghost` scenario |
| BC-1.4.027 | AMENDED — namespaced-key split. **HIGH-1 (consistency audit): no AC traced to this BC in `S-cycle3-percred-storage.md` — FIXED this burst; substance was already exercised by BC-1.4.031's AC-004, annotation gap closed.** |
| BC-1.4.031 | NEW — `store_api_token`/`load_api_token` per-profile functions |
| VP-AUTHDX-004 | Round-trip correctness + cross-profile isolation (SECURITY INVARIANT), bounded-generator property test (O-3) |
| test | `src/api/auth.rs:2786` `prop_bc_1_4_031_round_trip_and_cross_profile_isolation` + keyring-gated companions |
| src | `src/api/auth.rs` (`store_api_token`, `load_api_token`), `src/api/client.rs` (auth-method branch), `src/cli/auth/login.rs::login_token` |
| PR/commit | PR #755 @ `d3ba2726` |
| F5 | ADV-CONVERGED |
| F6 | Mutation: 0 in-scope diff mutants for `api/auth.rs`/`api/client.rs`/`cli/auth/*.rs` — these are NOT `examine_globs` members (pre-existing policy documented in CLAUDE.md), so the ≥95% security-critical bar is met vacuously; credential logic instead verified via keyring-gated VP-AUTHDX-004. Kani-substitution: 0 GAP |

## 3. `S-cycle3-credential-absence-guard` (PR #756 @ `5c568d0f`)

| Field | Value |
|---|---|
| DEC | DEC-326 (no-copy detect-and-instruct, supersedes DEC-325(a)'s lazy-migration clause) |
| BC-1.4.025 | AMENDED — regression-confirmation clause; `load_oauth_tokens` MUST-NOT-TOUCH baseline |
| BC-1.4.029 | AMENDED — cross-ref confirming `load_api_token`'s non-inheritance mirrors `load_oauth_tokens("sandbox")`'s. **HIGH-2 (consistency audit): no AC traced to this BC in `S-cycle3-credential-absence-guard.md` — FIXED this burst.** |
| BC-1.4.032 | NEW, REDESIGNED — no-copy detect-and-instruct (HIGHEST-RISK new contract in the cycle) |
| BC-1.4.033 | NEW, REDESIGNED — partial-write recovery, namespaced-pair-only |
| BC-1.4.034 | NEW — one-time re-login breaking-change contract |
| VP-AUTHDX-005 | Detect-and-instruct correctness — no legacy pair ever read/copied (SAFETY-CRITICAL) |
| VP-AUTHDX-006 | No profile special-cased, incl. `"default"` (SAFETY INVARIANT) |
| VP-AUTHDX-007 | MANDATORY keyring-gated end-to-end scenario, real OS keychain backend |
| VP-AUTHDX-008 | No-half-credential safety invariant, namespaced-pair case |
| test | VP-005: `src/api/auth.rs:3366` (`#[ignore]`, keyring-gated); VP-006: `src/api/auth.rs:3405` (`#[ignore]`); VP-007: `src/api/auth.rs:3225` (`#[ignore]`, mandatory scenario); VP-008: `src/api/auth.rs:3431` (`#[ignore]`) |
| src | `src/api/auth.rs::load_api_token` (detect-and-instruct branch) |
| PR/commit | PR #756 @ `5c568d0f` |
| F5 | ADV-CONVERGED — F5 MED-2 reconciliation explicitly documents the VP-AUTHDX-005/006/008 keyring-gated coverage boundary as intentional, not a gap |
| F6 | Mutation: same vacuous-≥95% treatment as story 2 (`api/auth.rs` outside `examine_globs`); Kani-substitution: 0 GAP; holdout H-W2-REG-003 (0.7) flags the legacy-`email` existence-probe observation against this BC cluster — non-blocking, consistent with the by-design boundary |

## 4. `S-cycle3-remove-logout-semantics` (PR #757 @ `5e9dba8a`)

| Field | Value |
|---|---|
| DEC | DEC-322 (`auth logout` non-destructive session-clear vs. `auth remove` full-delete) |
| BC-1.2.013 | AMENDED — non-destructive `logout`, informational stderr notice on api-token profiles (I-3/SR-015) |
| BC-1.2.014 | AMENDED — 4-step delete with credentials-before-config reordering, genuine keychain errors surfaced not swallowed (I-4/SR-008) |
| VP | None dedicated — ordinary AC `VP-1.2.014-001` anchored directly to BC-1.2.014's Postconditions |
| test | `VP-1.2.014-001` (ordinary F4 acceptance test, not a promoted VP-AUTHDX property) |
| src | `src/cli/auth/logout.rs`, `src/cli/auth/remove.rs`, `src/api/auth.rs::clear_profile_creds`/`clear_all_credentials` |
| PR/commit | PR #757 @ `5e9dba8a` — Burst 13 notes a HIGH security finding (SEC-1) found+fixed within this PR, leading to DEC-331's refined auto-merge policy |
| F5 | ADV-CONVERGED |
| F6 | Mutation: `refresh_coordinator.rs` unchanged in delta (0 mutants); `cli/auth/*.rs` outside `examine_globs` (documented policy) |

## 5. `S-cycle3-adr0011-newtype` (PR #758 @ `b7e513f9`)

| Field | Value |
|---|---|
| DEC | DEC-317 (un-defer ADR-0011, `Profile` newtype hard-fence) |
| BC-6.2.015 | AMENDED — target contract for the compile-time hard fence (`cache.rs` + `api/auth.rs`'s 4 credential functions + `Config::active_profile_name` + `JiraClient::profile_name`) |
| VP | None dedicated — BC-6.2.015 frames this as mechanical, not behavioral; existing cross-profile isolation tests (BC-6.2.009/BC-6.2.010) are the operative regression safety net |
| test | BC-6.2.009/BC-6.2.010 existing regression suite (unchanged pass/fail baseline) |
| src | `src/cache.rs` (12+ functions), `src/config.rs::Config::active_profile_name`, `src/api/client.rs::JiraClient::profile_name`, `src/api/auth.rs` (4 credential functions) |
| PR/commit | PR #758 @ `b7e513f9` — also applies the staged ADR-0011 amendment to `docs/adr/0011-type-level-profile-fence.md` (Deferred → Accepted), a named binding task for this story |
| F5 | ADV-CONVERGED |
| F6 | Mutation: `src/cache.rs` 2 caught mutants (per-profile path construction) — part of the 28/28 100% kill; Kani-substitution: N/A (no dedicated VP; covered by build-clean + full regression) |

**Cross-reference:** BC-6.2.015 extends ADR-0011 (existing, pre-cycle-003 artifact, now un-deferred by this cycle rather than newly authored).

## 6. `S-cycle3-oauth-default-creation` (PR #761 @ `b70dd6f4`)

| Field | Value |
|---|---|
| DEC | DEC-313 (interactive OAuth-default picker), DEC-323 (`--api-token` flag), DEC-327 (env-var suppresses picker, non-interactive only, refines DEC-313) |
| BC-1.1.013 | NEW — interactive OAuth-default picker |
| BC-1.1.014 | NEW — non-interactive api-token default (regression-safety pin) |
| BC-1.1.015 | NEW — runtime-default unchanged |
| BC-1.1.016 | NEW — airtight non-interactive OAuth guard (F2-gate hardening, closes adversarial finding I-1); reconciled 2026-09-02/03 against DEC-321 (F5 MED-1) |
| BC-1.2.049 | NEW — `--oauth` deprecated-but-accepted alias |
| BC-1.2.050 | NEW — `--api-token` explicit flag |
| VP-AUTHDX-001 | Non-interactive invocation never launches OAuth browser flow (SAFETY INVARIANT) |
| VP-AUTHDX-002 | Runtime-default-unchanged regression pin |
| test | VP-001: `tests/auth_oauth_default_creation.rs:38` (proptest); VP-002: `tests/auth_oauth_default_creation.rs:279` (proptest) + `:1207` (keyring-gated companion) |
| src | `src/cli/auth/login.rs::handle_login`, `src/cli/auth/refresh.rs::refresh_credentials` (extended-cell guard target), `src/cli/mod.rs` (`LoginArgs`/`RefreshArgs`) |
| PR/commit | PR #761 @ `b70dd6f4` — 2 MEDs found+fixed during Wave 4 per Burst 14 |
| F5 | ADV-CONVERGED |
| F6 | Mutation: `cli/auth/*.rs`/`cli/mod.rs` outside `examine_globs` (documented policy); Kani-substitution: 0 GAP via VP-AUTHDX-001/002 |

**Cross-reference:** depends on `S-cycle3-percred-storage`, `S-cycle3-credential-absence-guard`,
and (derived dependency, not in ADR-0020's literal text) `S-cycle3-remove-logout-semantics` —
the re-declaration credential-clear path reuses `clear_profile_creds`'s API-token-pair branch
added by story 4.

## 7. `S-cycle3-chosen-flow-reconcile` (PR #762 @ `1dfcd013`)

| Field | Value |
|---|---|
| DEC | DEC-321 (refresh override removed, "relogin-then-replace" ordering fix I-6) |
| BC-1.2.048 | NEW — general `auth_method`-is-intrinsic invariant |
| BC-1.2.051 | NEW — specific `auth refresh --oauth`/`--api-token` override removal |
| VP-AUTHDX-003 | `auth_method`-is-intrinsic invariant, 2×3 mechanism/flag proptest matrix (SAFETY INVARIANT) |
| test | `tests/auth_chosen_flow_reconcile.rs:24` (2×3 matrix proptest, 32 cases) |
| src | `src/cli/auth/refresh.rs::refresh_credentials` (sole citable F6 target — `chosen_flow_for_profile` is simplified to single-argument form, not removed, per LOW-1 correction) |
| PR/commit | PR #762 @ `1dfcd013` — squash-merged, final cycle-003 story; F1 (BYO-OAuth-cred over-delete on `refresh`) RESOLVED as a side effect |
| F5 | ADV-CONVERGED |
| F6 | Mutation: `cli/auth/refresh.rs` outside `examine_globs`; Kani-substitution: 0 GAP via VP-AUTHDX-003 |

## F5 fix PRs (post-story, pre-F6)

| PR/commit | Scope | DEC/BC touched | F5 status |
|---|---|---|---|
| PR #763 @ `aafa9f9f` | Login-switch relogin-then-replace fix (mirrors story 7's I-6 pattern on the `auth login` mechanism-switch path) | BC-1.1.013 EC-1.1.013-2 (re-declaration credential-clear) | Fixed + merged |
| PR #764 @ `202414f2` | F5-refinement bundle: 1 MED (locked-keychain refresh-error swallow) + 3 LOW | Reconciles BC-1.1.016↔DEC-321 (spec-only, MED-1) and VP-AUTHDX-005/006/008 coverage-boundary (spec-only, MED-2) | Fixed + merged; `develop` reaches current tip `202414f2` here |

## VP-AUTHDX Test-Existence cross-check (from consistency-audit-delta.md)

| VP | F6 Target | Test(s) |
|---|---|---|
| VP-AUTHDX-001 | Yes | `tests/auth_oauth_default_creation.rs:38` |
| VP-AUTHDX-002 | Yes (`src/api/client.rs::from_config`) | `tests/auth_oauth_default_creation.rs:279` + `:1207` (keyring-gated) |
| VP-AUTHDX-003 | Yes (`refresh.rs::refresh_credentials`) | `tests/auth_chosen_flow_reconcile.rs:24` (32-case matrix) |
| VP-AUTHDX-004 | Yes | `src/api/auth.rs:2786` + keyring-gated tests |
| VP-AUTHDX-005 | Yes | `src/api/auth.rs:3366` (`#[ignore]`) |
| VP-AUTHDX-006 | Yes | `src/api/auth.rs:3405` (`#[ignore]`) |
| VP-AUTHDX-007 | Yes | `src/api/auth.rs:3225` (`#[ignore]`, mandatory) |
| VP-AUTHDX-008 | Yes | `src/api/auth.rs:3431` (`#[ignore]`) |
| VP-AUTHDX-009 | Yes (`ProfileConfig` in `src/config.rs`) | `src/config.rs:2099/2123/2140` (three proptests) |

All 9/9 VPs have confirmed, existing, correctly-shaped tests. No gap.

## Cross-references (cycle-003 BC extends/depends-on existing artifacts)

| Cycle-003 artifact | Relationship | Existing artifact |
|---|---|---|
| BC-1.4.031/032/033/034 (`store_api_token`/`load_api_token`) | mirrors-shape-of | `store_oauth_tokens`/`load_oauth_tokens` (pre-existing OAuth credential functions) |
| BC-1.4.025 (AMENDED) | regression-baseline-for | `load_oauth_tokens`'s pre-existing test suite (MUST-NOT-TOUCH) |
| BC-6.2.015 (AMENDED) | un-defers | ADR-0011 (`Profile` newtype, pre-existing Deferred artifact) |
| BC-1.2.048/BC-1.2.051 | removes-override-from | pre-existing `chosen_flow_for_profile` (`src/cli/auth/mod.rs`) |
| `S-cycle3-oauth-default-creation` | sequence-aware-of, no code overlap | `S-384` (`is_oauth_auth()` JSM 401-hint gating, ready/undelivered) |
| `S-cycle3-oauth-default-creation` | folds-in-recommendation (human confirmed: kept separate, DEC-329) | `S-MAINT-532` (global `--profile` fallback coverage, deferred out of cycle-003) |
| — | no interaction, disjoint dispatch path | `S-663-1` (`auth switch --profile` guard, DONE, touches `AuthCommand::Switch` only) |

## Traceability link count

- **24 BC-level chain rows** (one per cycle-003 BC, grouped into the 7 story tables above: story 1 = 3 BCs, story 2 = 5 BCs, story 3 = 5 BCs, story 4 = 2 BCs, story 5 = 1 BC, story 6 = 6 BCs, story 7 = 2 BCs = 24).
- **9 VP-AUTHDX test-existence links** (cross-checked table).
- **2 F5 fix-PR links** (PR #763, PR #764).
- **7 cross-reference links** (extends/depends-on/sequence-aware table).
- **Total traceability links recorded in this delta file: 42** (24 + 9 + 2 + 7).
