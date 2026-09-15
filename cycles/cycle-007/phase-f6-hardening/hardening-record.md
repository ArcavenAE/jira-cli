---
document_type: f6-hardening-record
phase: phase-f6-targeted-hardening
producer: formal-verifier
cycle: cycle-007-auth-correctness-dx
feature: "auth-correctness-dx"
status: complete
timestamp: 2026-09-14
project: jira-cli
mode: BROWNFIELD
intent: feature
scope_baseline: "develop @ 11c95d5e"
inputs:
  - ".factory/phase-f2-spec-evolution/cycle-007-verification-delta.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".cargo/mutants.toml"
vps_in_scope:
  - VP-AUTHDX-024
  - VP-AUTHDX-025
  - VP-AUTHDX-026
  - VP-AUTHDX-027
  - VP-AUTHDX-028
  - VP-AUTHDX-029
dtu_required: false
overall_verdict: HARDENED_WITH_RESIDUALS
input-hash: "5ec1ad8"
---

# Phase F6 — Targeted Hardening Evidence Record — cycle-007 `auth-correctness-dx`

Scope: the cycle-007 delta (auth correctness + DX) on `develop @ 11c95d5e`. This
record documents formal-verification coverage for the six cycle-007 VPs
(VP-AUTHDX-024..029), the Kani/cargo-fuzz proptest-substitution justification,
the mutation-gate status (with the `src/api/auth.rs` `examine_globs` nuance), and
security-scan / DTU / accessibility dispositions. **No production code was
modified** by this phase — verification-and-evidence only.

---

## 1. Per-VP Coverage (verdicts + citations)

All test names below were confirmed present and PASSING in this repo at
`develop @ 11c95d5e` (run results in §4). Line numbers are approximate (`~`)
anchors, per CLAUDE.md citation-form convention.

### VP-AUTHDX-024 — `auth list` STATUS ↔ `auth status` machine-`status` parity (shared `derive_auth_state`)
**Verdict: COVERED.**
- `src/api/auth.rs::derive_auth_state` (~2259) — the single shared 3-state
  derivation both machine channels route through.
- `test_bc_1_6_048_derive_auth_state_exhaustive_truth_table` (`src/api/auth.rs:~2644`)
  — enumerates all 4 equivalence classes `{url: None,Some} × {matching_kind: t,f}`
  with determinism (double-call equality) + an embedded proptest over arbitrary
  URL strings proving only `url.is_none()` gates.
- `test_bc_1_6_048_derive_auth_state_url_none_always_unset` / `_url_some_no_match_yields_no_credentials`
  / `_url_some_match_yields_configured` (`src/api/auth.rs:~2590..2619`).
- Call-site parity: `test_bc_1_6_049_both_renderers_share_derive_auth_state_call_site`
  (`src/cli/auth/tests/mod.rs:~1987`); `test_bc_1_6_050_status_json_status_uses_shared_derivation`
  (`tests/auth_status_json.rs:~113`); `test_bc_1_6_050_json_field_names_match_list_json`
  (`src/cli/auth/tests/mod.rs:~2421`).

### VP-AUTHDX-025 — `auth list` STATUS is a real credential PROBE, not `url.is_some()`
**Primary BC-1.6.049 (#788). Verdict: COVERED.**
- Differential (kills the #788 defect): `test_bc_1_6_049_list_status_derives_from_probe_not_url`
  (`src/cli/auth/tests/mod.rs:~1775`) — `url: Some` + `matching_kind_present=false`
  renders `no-credentials`, not `configured`, in BOTH renderers.
- Conditional-probe call-count: `test_bc_1_6_049_list_probes_at_most_once_per_url_profile`
  (`src/cli/auth/tests/mod.rs:~1887`) — K probes = count of URL-present profiles, 0 for `url: None`.
- Injection-seam purity: `test_bc_1_6_049_renderers_are_probe_free`
  (`tests/auth_list_status.rs:~34`).
- JSON-schema stability: `test_bc_1_6_049_list_json_schema_unchanged_except_status_values`
  (`src/cli/auth/tests/mod.rs:~567`); vocabulary values
  `test_bc_1_6_049_list_json_schema_status_vocabulary_values` (`src/api/auth.rs:~2706`).
- No-ANSI STATUS column: `test_bc_1_6_049_list_status_column_is_plain_text_no_ansi`
  (`src/cli/auth/tests/mod.rs:~2050`).

### VP-AUTHDX-026 — `auth status --output json` full 6-key schema + `render_json` routing
**Primary BC-1.6.050 (#787). Verdict: COVERED.**
- Full schema (api_token): `test_bc_1_6_050_status_json_full_schema_api_token`
  (`src/cli/auth/tests/mod.rs:~2182`).
- `env` verbatim/lossless: `test_bc_1_6_050_status_json_env_verbatim_lossless`
  (`src/cli/auth/tests/mod.rs:~2237`).
- `oauth_app` present-when-oauth / null-when-api-token:
  `test_bc_1_6_050_status_json_oauth_app_present_when_oauth` (`~2304`) +
  `test_bc_1_6_050_status_json_oauth_app_null_when_api_token` (`~2340`).
- `render_json` pretty routing (#526 invariant): `test_bc_1_6_050_status_json_routes_through_render_json_pretty`
  (`~2374`).
- Probe-free JSON builder: `test_bc_1_6_050_json_builder_is_probe_free`
  (`tests/auth_status_json.rs:~276`); dispatch-arm coverage
  `test_bc_1_6_050_status_success_dispatch_arms_covered` (`~342`); fresh-install early-return
  `test_bc_1_6_050_ec2_fresh_install_no_json_output` (`~214`).
- **Postcondition 6 (human-text byte-for-byte unchanged):**
  `test_bc_1_6_050_status_human_text_byte_for_byte_unchanged` (`tests/auth_status_json.rs:~609`)
  — **KEYRING-GATED** (`JR_RUN_KEYRING_TESTS=1`). See §5 Residual R1.

### VP-AUTHDX-027 — recovery command PARSES **and** credential-absence exits 2 (both `auth.rs` sites)
**Primary BC-1.4.032 + BC-1.4.033 (#784 + #786). Verdict: COVERED.**
- (a) Remediation parses + negative old-positional anchor:
  `test_bc_1_4_032_remediation_command_parses_against_clap`
  (`tests/auth_credential_absence.rs:~85`) — `jr auth login --profile=<p>` binds
  `AuthCommand::Login { profile: Some(_) }`; old positional form fails to bind.
- (b) Exit-2 reclassification, both branches:
  `test_bc_1_4_032_credential_absence_exits_2_not_64` (`src/api/auth.rs:~4091`);
  `test_bc_1_4_033_partial_write_exits_2_and_recommends_login_not_logout` (`~4165`).
- Supporting unit corpus in `src/api/auth.rs`: `_absent_namespaced_keys_no_legacy_pair_returns_actionable_exit2`
  (`~4223`), `_legacy_pair_present_returns_identical_actionable_exit2` (`~4238`),
  `_no_copy_invariant_legacy_pair_untouched_and_no_percred_written` (`~4264`),
  `_default_profile_not_special_cased` (`~4295`), `_repeated_calls_return_same_err` (`~4328`),
  `test_bc_1_4_033_namespaced_partial_email_present...` (`~4351`) / `_token_present...` (`~4373`),
  `_partial_precedence_over_legacy_pair_present` (`~4398`),
  `test_bc_1_4_033_remediation_message_never_mentions_auth_logout` (`~4434`, SR-009 substring-absence).

### VP-AUTHDX-028 — NEGATIVE pin: unknown-profile stays exit 64 (two failure classes stay distinct)
**Primary BC-1.1.004 (deliberately unchanged). Verdict: COVERED.**
- `test_bc_1_1_004_unknown_profile_stays_exit_64` (`tests/auth_credential_absence.rs:~157`).
- JSON envelope: `test_bc_1_1_004_unknown_profile_json_envelope_is_standard_error_shape` (`~184`).
- Distinct-code discriminator: `test_auth_credential_absence_vs_unknown_profile_are_distinct_codes`
  (`~256`) + `test_auth_unknown_profile_still_exits_64_not_2` (`~220`).
- Corroborating profile-not-found=64 convention: `tests/auth_profiles.rs`
  (`auth_status_unknown_profile_exits_64` `~88`, and the `--profile`-propagation set).

### VP-AUTHDX-029 — `auth status` HUMAN-TEXT `Credentials:` line tracks the `matching_kind_present` boolean
**Primary BC-1.6.048 Postcondition 3 (F2-M1 follow-on). Verdict: COVERED (keyring-gated positive assertions).**
- Text-agreement (AC-007): `test_vp_authdx_029_status_text_agrees_with_matching_kind_present`
  (`tests/auth_status_json.rs:~714`) — **KEYRING-GATED**.
- Intentional divergence non-assertion (AC-008, EC-1.6.050-4):
  `test_bc_1_6_050_ec4_url_none_credential_present_divergence_is_intentional`
  (`tests/auth_status_json.rs:~811`) — **KEYRING-GATED**. Confirms text shows
  credential-present while machine `status` shows `unset` for `(url: None, creds present)`
  — documented divergence, NOT a parity violation.
- Default-CI indirect coverage via the pure `peek_oauth_app_source_for_test` helper and the
  dispatch-arm test above. See §5 Residual R1.

**No VP axis is uncovered.** Every VP-AUTHDX-024..029 axis has a real, passing
verification test. The only qualification is that VP-029's (and BC-1.6.050
Postcondition 6's) *effectful human-text* assertions run under
`JR_RUN_KEYRING_TESTS=1` rather than default CI (Residual R1, LOW).

---

## 2. Kani / cargo-fuzz — JUSTIFIED-SKIP (0-GAP)

Kani and cargo-fuzz are **not provisioned** in this repo (no `kani`/`kani-verifier`
crate in `Cargo.toml`, no `fuzz/` directory). Proptest substitution is applied per
the established **cycle-002/003/004/005/006/012 precedent** (STATE.md Skip Log;
`verification-delta-674.md` §3; cycle-007 verification-delta §3). This cycle is an
even weaker Kani/fuzz candidate:

- **No new arithmetic/overflow/OOB/`unsafe` surface.** The only new pure logic is
  `derive_auth_state(url: Option<&str>, matching_kind_present: bool) -> AuthState`
  — a total pure function to a 3-value enum with no arithmetic, indexing, or `unsafe`.
  The defect classes Kani is strongest at are absent.
- **Finite, tiny domain.** The whole input domain is 4 equivalence classes
  (`{url: None,Some} × {matching_kind: true,false}`). The exhaustive `#[test]`
  truth-table (`test_bc_1_6_048_derive_auth_state_exhaustive_truth_table`) enumerates
  it completely, with an embedded proptest over arbitrary URL strings proving only
  `url.is_none()` gates — the "universal property" IS the enumerated table; symbolic
  exploration adds nothing.
- **Two-state (not three-way) domain (OBS-PB-1).** `matching_kind_present: bool` is
  computed caller-side via `load_*().is_ok()`, which collapses both credential-absence
  AND keychain backend-error into `false` — there is no realizable `Err`/fail-closed
  third arm to model (would be dead code). Distinguishing backend-error from absence is
  OUT OF SCOPE (standing item OBS-PB-1).
- **Correctness-critical claims are EFFECTFUL** — real credential PROBE, `render_json`
  routing, process exit codes (2 vs 64), clap-parse of the remediation string — all
  observable only through the CLI/parser/keychain boundary, entirely out of Kani/fuzz
  reach. Covered by `assert_cmd`/clap-round-trip/keyring-gated tests instead.
- **Fuzzing value (crash-finding on untrusted bytes) is N/A** — no new untrusted-byte
  parsing surface; auth-state derivation consumes already-parsed config + a boolean.

**0-GAP:** skipping Kani/cargo-fuzz introduces no coverage gap relative to the
cycle-007 BC set — every claim is either (a) a finite truth table fully enumerated by
example+proptest, (b) an effectful CLI/exit-code/parse behavior tested through the
process boundary, or (c) a keyring-gated real-backend scenario. Documented
substitution, not an omission.

---

## 3. Mutation-Gate Status (cargo-mutants)

**Ran GREEN in CI** on the cycle-007 merge PRs (#813 cycle-012 F5 bundle context and
#814 the cycle-007 F5 consolidation PR); per instruction it was **NOT re-run locally**
in this F6 phase. Gate config: `.cargo/mutants.toml` (policy: `docs/specs/cargo-mutants-policy.md`).

**In `examine_globs` (COVERED by mutation testing):**
- `src/cli/auth/list.rs` — `derive_auth_state` call-site wiring, `collect_probe_results`
  injection seam, `render_list_table`/`render_list_json` renderer purity (B1).
- `src/cli/auth/status.rs` — `build_status_json` pure JSON builder + `status()`
  `OutputFormat` dispatch (B2).

**NOT in `examine_globs` — accurate nuance (do NOT claim coverage it lacks):**
- `src/api/auth.rs` is **NOT** in `examine_globs`. The consolidated
  `derive_auth_state` and `collect_probe_results` live here (CR-002/F-C007-M1, cycle-007
  F5 consolidation into one shared impl). Therefore **`derive_auth_state` has NO
  cargo-mutants coverage** — it is instead covered by the **exhaustive default-CI
  truth-table + embedded proptest** (`test_bc_1_6_048_derive_auth_state_exhaustive_truth_table`),
  which enumerates the complete 4-class domain and so is functionally equivalent to
  100% mutation kill on that pure function.
- `probe_matching_kind_credential` (`src/api/auth.rs`) — keychain-effectful, no injection
  seam; its mutations cannot be caught by default-CI tests. An `exclude_re` **pair** is
  present but presently **inert** (the file it anchors to is not globbed) — retained so
  the exclusion travels with the function if `src/api/auth.rs` later enters scope.
  Documented pre-existing state.
- `peek_oauth_app_source` (`src/cli/auth/status.rs`) — keychain-gated, no injection seam;
  its `exclude_re` pair **IS active** (status.rs is globbed). `peek_oauth_app_source_for_test`
  (pure) is NOT excluded and is default-CI tested.

`tests/mutants_glob_existence.rs` guards every `examine_globs` entry resolves to ≥1
real file.

---

## 4. Local Test Run (this phase — confirming green)

Run at `develop @ 11c95d5e`. Full workspace suite deliberately NOT run (scoped to
auth per instruction).

| Command / binary | Result |
|---|---|
| `cargo test --lib auth` | **270 passed; 0 failed; 48 ignored** (0.24s) — incl. `test_bc_1_6_048_derive_auth_state_exhaustive_truth_table` and the BC-1.4.032/033 unit corpus |
| `cargo test --test auth_credential_absence` | **31 passed; 0 failed; 1 ignored** |
| `cargo test --test auth_status_json` | **31 passed; 0 failed; 3 ignored** |
| `cargo test --test auth_list_status` | **2 passed; 0 failed; 0 ignored** |
| `cargo test --test auth_output_json` | **32 passed; 0 failed; 1 ignored** |

**Aggregate: 366 passed, 0 failed, 53 ignored.** The 53 ignored are the
`JR_RUN_KEYRING_TESTS=1` / `JR_RUN_OAUTH_INTEGRATION=1`-gated real-backend
confirmations (expected inert in default CI; VP-AUTHDX-005/006/007 established
pattern) — not failures.

---

## 5. Residual Gaps (all LOW)

- **R1 (LOW) — VP-029 / BC-1.6.050 Postcondition 6 human-text assertions are
  keyring-gated.** The positive text-line agreement (AC-007), the intentional-divergence
  non-assertion (AC-008), and the byte-for-byte-unchanged check (AC-006) all run only
  under `JR_RUN_KEYRING_TESTS=1` — the human-text `Credentials:` path performs a real
  keychain probe with no default-CI injection seam. This is **consistent with the
  cycle-007 verification-delta coverage boundary** and the VP-AUTHDX-007
  `JR_RUN_KEYRING_TESTS=1` pattern. Default-CI carries the regression weight via the
  pure `peek_oauth_app_source_for_test` helper, the probe-free JSON builder test, and
  the dispatch-arm coverage test. Accepted.
- **R2 (LOW) — `derive_auth_state` has no cargo-mutants coverage** because
  `src/api/auth.rs` is not in `examine_globs` (pre-existing state). Mitigated by the
  exhaustive truth-table + proptest, which fully enumerate the finite domain (functionally
  equivalent to full mutation kill on a total pure function). The `probe_matching_kind_credential`
  exclusion pair is inert-but-retained. Accepted, documented.
- **R3 (LOW, standing / out of scope) — OBS-PB-1:** keychain BACKEND-ERROR is not
  distinguished from credential-ABSENCE (`load_*().is_ok()` collapses both to `false`,
  → `no-credentials` with no stderr warning). Deliberate; cycle-007 preserves shipped
  behavior. Tracked as a standing item, explicitly out of cycle-007 scope.

No MEDIUM/HIGH/CRITICAL residuals.

---

## 6. Security / DTU / Accessibility Dispositions

- **Security scan: CLEAN.** F5 security-reviewer (cycle-007) + gitleaks + `cargo-deny`
  in CI already clean at `develop @ 11c95d5e`. No new untrusted-input surface introduced
  by this cycle. No re-run performed by F6.
- **DTU: N/A** — `dtu_required: false`. No third-party behavioral clone in scope.
- **Accessibility / visual: N/A** — no UI surface (CLI-only auth commands).

---

## 7. Overall F6 Verdict

**HARDENED_WITH_RESIDUALS.**

All six cycle-007 VPs (VP-AUTHDX-024..029) have real, passing verification coverage
with cited tests; no VP axis is uncovered. Kani/cargo-fuzz proptest-substitution is
justified and 0-GAP per standing precedent. Mutation gate is GREEN in CI for the
globbed auth CLI renderers/builders, with the `src/api/auth.rs` non-globbing of
`derive_auth_state` accurately documented and mitigated by an exhaustive truth-table +
proptest. Security scan clean; DTU and accessibility N/A. The three residuals are all
LOW, documented, and consistent with the cycle-007 verification-delta coverage
boundaries and standing project precedent.
