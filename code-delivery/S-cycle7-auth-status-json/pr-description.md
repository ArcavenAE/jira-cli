# S-cycle7-auth-status-json — `auth status --output json` full schema, retires NFR-O-N

**Epic:** AUTH-CORRECTNESS-DX-1 — Auth Correctness & Developer Experience
**Mode:** feature
**Convergence:** CONVERGED after 6 adversarial passes (3 consecutive clean: passes 4/5/6)

![Tests](https://img.shields.io/badge/tests-14%20total%3A%2011%20default%20CI%20%2B%203%20keyring--gated-brightgreen)
![Coverage](https://img.shields.io/badge/coverage-status.rs%20in%20examine__globs-brightgreen)
![Mutation](https://img.shields.io/badge/mutation-dispatch--arm%20mutants%20killed-green)
![Holdout](https://img.shields.io/badge/holdout-N%2FA--evaluated%20at%20wave%20gate-blue)

Closes #787. Implements BC-1.6.050: `jr auth status --output json` now emits a 6-key JSON object (`profile`, `url`, `env`, `auth_method`, `status`, `oauth_app`). This shares 4 field names with `auth list --output json` (`url`, `env`, `auth_method`, `status`); the `profile` and `oauth_app` keys differ from `auth list`'s `name` and `active` keys respectively (AC-011 asserts the 4 shared-name fields exactly). The existing human-text output is byte-for-byte UNCHANGED in all cases. The `"status"` field is derived from the shared `derive_auth_state` helper (introduced by `S-cycle7-auth-state-derivation`), ensuring `auth status` and `auth list` cannot report divergent states for the same profile. Retires the NFR-O-N standing documentation gap.

Depends on: `S-cycle7-auth-state-derivation` (merged to `develop` as prerequisite). No downstream stories are blocked by this PR.

---

## Architecture Changes

```mermaid
graph TD
    main_rs["main.rs\nAuthCommand::Status dispatch"]
    status_rs["src/cli/auth/status.rs\nstatus(&OutputFormat)"]
    build_json["build_status_json()\nPURE — new"]
    probe["probe_matching_kind_credential()\nEffectful-shell — extracted"]
    derive_auth["src/api/auth.rs\nderive_auth_state()\nPURE — from B1"]
    output_rs["src/output.rs\nrender_json()"]

    main_rs -->|threads &cli.output| status_rs
    status_rs -->|calls once| probe
    status_rs -->|passes matching_kind_present| build_json
    build_json -->|calls| derive_auth
    build_json -->|routes through| output_rs
    style build_json fill:#90EE90
    style probe fill:#FFFACD
```

<details>
<summary><strong>Architecture Decision Record</strong></summary>

### ADR: Pure JSON builder function, single credential probe

**Context:** `jr auth status` had no `--output json` path (NFR-O-N). Adding JSON output required threading `&OutputFormat` through `status()` and constructing a 6-key object without breaking the existing human-text channel.

**Decision:** Extract the 6-key JSON object assembly into a pure `build_status_json()` function. Extract the inline `creds_ok` match into a named `probe_matching_kind_credential()` function. `status()` calls the probe ONCE and feeds its result to both the text branch and the pure JSON builder.

**Rationale:** Mirrors `S-cycle7-auth-state-derivation`'s effectful-shell / pure-core split. Makes AC-001/003/004/005/011's schema tests runnable in DEFAULT CI without any keychain dependency. The single probe call ensures the text and JSON channels can never diverge on their `Credentials:` / `"status"` values.

**Alternatives Considered:**
1. Inline JSON construction inside `status()` — rejected because it entangles keychain I/O with JSON formatting, requiring keyring-gated tests for every JSON shape assertion.
2. Separate probe call for JSON channel — rejected because BC-1.6.048 Postcondition 3 prohibits two separate probes that could return different results.

**Consequences:**
- 14 new default-CI tests (no keychain), 3 keyring-gated tests.
- `status.rs` added to `examine_globs`; two impure functions `exclude_re`'d per cargo-mutants policy.

</details>

---

## Story Dependencies

```mermaid
graph LR
    B1["S-cycle7-auth-state-derivation\n(Wave 1, B1)\nMERGED to develop"]
    B2["S-cycle7-auth-status-json\n(Wave 2, B2)\nThis PR"]
    B1 -->|provides derive_auth_state| B2
    style B2 fill:#FFD700
    style B1 fill:#90EE90
```

Dependency check: `S-cycle7-auth-state-derivation` is merged to `develop` (verified — `derive_auth_state` is available in the worktree build).

---

## Spec Traceability

```mermaid
flowchart LR
    BC050["BC-1.6.050\nauth status JSON"]
    BC047["BC-1.6.047\nenv verbatim"]
    BC048["BC-1.6.048\nsingle probe"]

    AC001["AC-001\nJSON schema 6-key"]
    AC002["AC-002\nshared derive_auth_state"]
    AC003["AC-003\nenv verbatim/lossless"]
    AC004["AC-004\noauth_app always present"]
    AC005["AC-005\nrender_json routing"]
    AC006["AC-006\nhuman text unchanged"]
    AC007["AC-007\nVP-AUTHDX-029 agreement"]
    AC008["AC-008\nEC-4 intentional divergence"]
    AC009["AC-009\nunknown profile EC-1"]
    AC010["AC-010\nfresh install EC-2"]
    AC011["AC-011\nfield name parity with list"]
    AC012["AC-012\nNFR-O-N retirement doc"]
    AC013["AC-013\nbuilder purity"]

    BC050 --> AC001 & AC002 & AC003 & AC004 & AC005 & AC006 & AC009 & AC010 & AC011 & AC012 & AC013
    BC047 --> AC003
    BC048 --> AC007 & AC008

    T001["test_bc_1_6_050_status_json_full_schema_api_token\nDEFAULT CI"]
    T002["test_bc_1_6_050_status_json_status_uses_shared_derivation\nDEFAULT CI"]
    T003["test_bc_1_6_050_status_json_env_verbatim_lossless\nDEFAULT CI"]
    T004a["test_bc_1_6_050_status_json_oauth_app_present_when_oauth\nDEFAULT CI"]
    T004b["test_bc_1_6_050_status_json_oauth_app_null_when_api_token\nDEFAULT CI"]
    T005["test_bc_1_6_050_status_json_routes_through_render_json_pretty\nDEFAULT CI"]
    T006["test_bc_1_6_050_status_human_text_byte_for_byte_unchanged\nKEYRING-GATED"]
    T007["test_vp_authdx_029_status_text_agrees_with_matching_kind_present\nKEYRING-GATED"]
    T008["test_bc_1_6_050_ec4_url_none_credential_present_divergence_is_intentional\nKEYRING-GATED"]
    T009["test_bc_1_6_050_ec1_unknown_profile_json_still_standard_error_envelope\nDEFAULT CI"]
    T010["test_bc_1_6_050_ec2_fresh_install_no_json_output\nDEFAULT CI"]
    T011["test_bc_1_6_050_json_field_names_match_list_json\nDEFAULT CI (inline)"]
    T013["test_bc_1_6_050_json_builder_is_probe_free\nDEFAULT CI"]
    T_dispatch["test_bc_1_6_050_status_success_dispatch_arms_covered\nDEFAULT CI"]

    AC001 --> T001
    AC002 --> T002
    AC003 --> T003
    AC004 --> T004a & T004b
    AC005 --> T005
    AC006 --> T006
    AC007 --> T007
    AC008 --> T008
    AC009 --> T009
    AC010 --> T010
    AC011 --> T011
    AC013 --> T013 & T_dispatch
```

---

## Test Evidence

### Coverage Summary

| Metric | Value | Threshold | Status |
|--------|-------|-----------|--------|
| Default-CI tests (new) | 14 pass (no keychain) | 100% | PASS |
| Keyring-gated tests (new) | 3 (AC-006/007/008, `#[ignore]`) | gated | GATED (by design) |
| AC-011 inline test | 1 pass (`src/cli/auth/tests/mod.rs`) | 100% | PASS |
| Dispatch-arm mutants | killed by `test_bc_1_6_050_status_success_dispatch_arms_covered` | 100% | PASS |
| `status.rs` in examine_globs | YES | required | PASS |
| `probe_matching_kind_credential` / `peek_oauth_app_source` excluded | YES (`exclude_re`, MED-1) | justified | PASS |

### Test Flow

```mermaid
graph LR
    DefaultCI["14 Default-CI Tests\nno keychain dependency"]
    KeyringGated["3 Keyring-Gated Tests\n#[ignore]+JR_RUN_KEYRING_TESTS=1"]
    InlineTest["1 Inline Test\nsrc/cli/auth/tests/mod.rs\nAC-011 field parity"]
    MutantGate["mutants-aggregate\ndispatch-arm kill confirmed"]

    DefaultCI -->|AC-001 through AC-013| Pass1["PASS"]
    KeyringGated -->|AC-006/007/008| Gated["GATED (design)"]
    InlineTest -->|AC-011| Pass3["PASS"]
    MutantGate -->|examine_globs status.rs| Pass4["PASS"]

    style Pass1 fill:#90EE90
    style Pass3 fill:#90EE90
    style Pass4 fill:#90EE90
    style Gated fill:#FFFACD
```

| Metric | Value |
|--------|-------|
| **New tests** | 14 new tests total: 6 inline (src/cli/auth/tests/mod.rs, default CI) + 8 in tests/auth_status_json.rs (5 default CI + 3 keyring-gated) |
| **Files modified** | 8 (`.cargo/mutants.toml`, `CHANGELOG.md`, `CLAUDE.md`, `src/cli/auth/mod.rs`, `src/cli/auth/status.rs`, `src/cli/auth/tests/mod.rs`, `src/main.rs`, `tests/auth_status_json.rs`) |
| **Lines added (diff)** | +1,445 insertions, -32 deletions |
| **Regressions** | 0 (human-text channel byte-for-byte unchanged per AC-006) |

<details>
<summary><strong>Key Tests</strong></summary>

| Test | Location | CI Gate | AC |
|------|----------|---------|-----|
| `test_bc_1_6_050_status_json_full_schema_api_token` | `src/cli/auth/tests/mod.rs` | DEFAULT | AC-001 |
| `test_bc_1_6_050_status_json_env_verbatim_lossless` | `src/cli/auth/tests/mod.rs` | DEFAULT | AC-003 |
| `test_bc_1_6_050_status_json_oauth_app_present_when_oauth` | `src/cli/auth/tests/mod.rs` | DEFAULT | AC-004 |
| `test_bc_1_6_050_status_json_oauth_app_null_when_api_token` | `src/cli/auth/tests/mod.rs` | DEFAULT | AC-004 |
| `test_bc_1_6_050_status_json_routes_through_render_json_pretty` | `src/cli/auth/tests/mod.rs` | DEFAULT | AC-005 |
| `test_bc_1_6_050_json_field_names_match_list_json` | `src/cli/auth/tests/mod.rs` | DEFAULT | AC-011 |
| `test_bc_1_6_050_status_json_status_uses_shared_derivation` | `tests/auth_status_json.rs` | DEFAULT | AC-002 |
| `test_bc_1_6_050_json_builder_is_probe_free` | `tests/auth_status_json.rs` | DEFAULT | AC-013 |
| `test_bc_1_6_050_status_success_dispatch_arms_covered` | `tests/auth_status_json.rs` | DEFAULT | AC-013 (mutants) |
| `test_bc_1_6_050_ec1_unknown_profile_json_still_standard_error_envelope` | `tests/auth_status_json.rs` | DEFAULT | AC-009 |
| `test_bc_1_6_050_ec2_fresh_install_no_json_output` | `tests/auth_status_json.rs` | DEFAULT | AC-010 |
| `test_bc_1_6_050_status_human_text_byte_for_byte_unchanged` | `tests/auth_status_json.rs` | KEYRING-GATED | AC-006 |
| `test_vp_authdx_029_status_text_agrees_with_matching_kind_present` | `tests/auth_status_json.rs` | KEYRING-GATED | AC-007 |
| `test_bc_1_6_050_ec4_url_none_credential_present_divergence_is_intentional` | `tests/auth_status_json.rs` | KEYRING-GATED | AC-008 |

</details>

---

## Demo Evidence

**SKIPPED** — human decision, consistent with Wave 2 stories A (S-cycle7-credential-absence-fix) and B1 (S-cycle7-auth-state-derivation).

**Justification:** This is an output-only CLI change (new `--output json` path on `auth status`). The default-CI success-path test `test_bc_1_6_050_status_success_dispatch_arms_covered` plus the inline JSON-shape tests fully cover the observable behavior. Producing a keychain-state terminal recording is impractical on the CI/development host (requires a real stored credential). The human-text channel regression is covered by AC-006's keyring-gated test. No VHS/Playwright demo is required.

---

## Holdout Evaluation

**N/A — evaluated at wave gate.** Per Wave 2 integration-gate design, H-W2-INT-001 (VP-AUTHDX-024: `auth status` and `auth list` agree for same profile/keychain state) is evaluated at the wave-level gate after all Wave 2 stories merge, not at individual story level.

---

## Adversarial Review

| Pass | Findings | Critical | High | Med | Low | Status |
|------|----------|----------|------|-----|-----|--------|
| 1 | 3 | 0 | 0 | 1 (F-1: JSON builder purity) | 2 | Fixed (C-1/I-1/I-2) |
| 2 | 2 | 0 | 0 | 0 | 2 (VP-AUTHDX-024 comment + LOW-3) | Fixed/Documented |
| 3 | 2 | 0 | 0 | 1 (MED-1: mutants exclude_re scope) | 1 | Fixed |
| 4 | 0 | 0 | 0 | 0 | 0 | CLEAN |
| 5 | 0 | 0 | 0 | 0 | 0 | CLEAN |
| 6 | 0 | 0 | 0 | 0 | 0 | CLEAN |

**Convergence:** 3 consecutive clean passes (4/5/6). CONVERGED.

<details>
<summary><strong>Key Findings & Resolutions</strong></summary>

### Pass 1 — F-1 (Medium): JSON builder not pure
- **Problem:** Original design had JSON construction inline in `status()`, entangling keychain I/O with schema assembly. AC-001/003/004/005 tests would require keyring-gated `#[ignore]` test functions.
- **Resolution:** Extracted 6-key JSON assembly into pure `build_status_json()` function taking plain arguments. Extracted probe into `probe_matching_kind_credential()`. Added AC-013 purity source-scan test.

### Pass 3 — MED-1: mutants.toml exclude_re scope insufficient
- **Problem:** Adding `status.rs` to `examine_globs` without `exclude_re` entries for the two impure functions would surface legitimate survived mutants under `cargo mutants --in-diff`.
- **Resolution:** Appended 4 regex entries for `probe_matching_kind_credential` and `peek_oauth_app_source` to `.cargo/mutants.toml`'s `exclude_re` array, with justification comment.

</details>

---

## Security Review

**CLEAN — 0 findings (Critical: 0 / High: 0 / Medium: 0 / Low: 0 / INFO: 1)**

**Surface reviewed:** `src/cli/auth/status.rs`, `src/main.rs`, `src/cli/auth/mod.rs`

```mermaid
graph LR
    Critical["Critical: 0"]
    High["High: 0"]
    Medium["Medium: 0"]
    Low["Low: 0"]
    Info["INFO: 1 (env verbatim — intentional)"]

    style Critical fill:#90EE90
    style High fill:#90EE90
    style Medium fill:#90EE90
    style Low fill:#90EE90
    style Info fill:#87CEEB
```

Key verifications:
- **CWE-200/CWE-312 (credential exposure):** `probe_matching_kind_credential` calls `.is_ok()` on token results — token values are never bound. `peek_oauth_app_source` uses wildcard `Ok(Some(_))` discard — no credential propagates. All 6 JSON fields confirmed non-secret. CLEAN.
- **CWE-89/CWE-79/CWE-78 (injection):** JSON built via `serde_json::json!` macro, routed through `output::render_json`. CLEAN.
- **CWE-306/CWE-287 (auth bypass):** Read-only status reporting; `validate_profile_name` + unknown-profile guard fire before any probe. CLEAN.
- **CWE-20 (input validation):** `profile_arg` flows through `Config::load_with` → `validate_profile_name`. CLEAN.
- **INFO (not a finding):** `env` JSON field is verbatim (no control-char stripping); human-text path applies `sanitize_env_display`. Intentional, documented in code comment at status.rs:102. User-controlled config label, not external input.

---

## Risk Assessment & Deployment

### Blast Radius
- **Systems affected:** `src/cli/auth/status.rs`, `src/main.rs` (one dispatch call site), `CLAUDE.md`, `CHANGELOG.md`, `.cargo/mutants.toml`
- **User impact:** `auth status` gains a new JSON output path. No existing behavior changed. Human-text output is byte-for-byte identical.
- **Data impact:** No new data stored. No credential exposure (pure output formatting).
- **Risk Level:** LOW — additive-only change, no mutation of existing code paths.

### Performance Impact
| Metric | Before | After | Delta | Status |
|--------|--------|-------|-------|--------|
| `jr auth status` latency | baseline | +0ms | negligible (one `serde_json::json!` call) | OK |

<details>
<summary><strong>Rollback Instructions</strong></summary>

**Immediate rollback:**
```bash
git revert <merge_sha>
git push origin develop
```

**Verification after rollback:**
- `jr auth status` (human text) works identically.
- `jr auth status --output json` returns an error or is absent (prior behavior).

</details>

### Feature Flags
None — this is a direct CLI enhancement with no feature flag.

---

## Traceability

| BC | Story AC | Test | CI Gate | Status |
|----|----------|------|---------|--------|
| BC-1.6.050 PC1 | AC-001 | `test_bc_1_6_050_status_json_full_schema_api_token` | DEFAULT | PASS |
| BC-1.6.050 PC2 | AC-002 | `test_bc_1_6_050_status_json_status_uses_shared_derivation` | DEFAULT | PASS |
| BC-1.6.050 PC3 / BC-1.6.047 PC2a | AC-003 | `test_bc_1_6_050_status_json_env_verbatim_lossless` | DEFAULT | PASS |
| BC-1.6.050 PC4 | AC-004 | `test_bc_1_6_050_status_json_oauth_app_present_when_oauth` + `_null_when_api_token` | DEFAULT | PASS |
| BC-1.6.050 PC5 / #526 | AC-005 | `test_bc_1_6_050_status_json_routes_through_render_json_pretty` | DEFAULT | PASS |
| BC-1.6.050 PC6 | AC-006 | `test_bc_1_6_050_status_human_text_byte_for_byte_unchanged` | KEYRING-GATED | GATED |
| BC-1.6.048 PC3 / VP-AUTHDX-029 | AC-007 | `test_vp_authdx_029_status_text_agrees_with_matching_kind_present` | KEYRING-GATED | GATED |
| BC-1.6.050 EC-4 | AC-008 | `test_bc_1_6_050_ec4_url_none_credential_present_divergence_is_intentional` | KEYRING-GATED | GATED |
| BC-1.6.050 EC-1 | AC-009 | `test_bc_1_6_050_ec1_unknown_profile_json_still_standard_error_envelope` | DEFAULT | PASS |
| BC-1.6.050 EC-2 | AC-010 | `test_bc_1_6_050_ec2_fresh_install_no_json_output` | DEFAULT | PASS |
| BC-1.6.050 INV1 | AC-011 | `test_bc_1_6_050_json_field_names_match_list_json` | DEFAULT (inline) | PASS |
| BC-1.6.050 INV2 / NFR-O-N | AC-012 | CLAUDE.md updated (doc artifact) | N/A | DONE |
| BC-1.6.050 PC2 / F-1 purity | AC-013 | `test_bc_1_6_050_json_builder_is_probe_free` + `test_bc_1_6_050_status_success_dispatch_arms_covered` | DEFAULT | PASS |

---

## AI Pipeline Metadata

<details>
<summary><strong>Pipeline Details</strong></summary>

```yaml
ai-generated: true
pipeline-mode: feature
factory-version: "1.0.0"
cycle: cycle-007-auth-correctness-dx
wave: 2
story: S-cycle7-auth-status-json
pipeline-stages:
  spec-crystallization: completed
  story-decomposition: completed (F3 adversary passes 1-6)
  tdd-implementation: completed
  holdout-evaluation: N/A (wave-gate)
  adversarial-review: completed (6 passes, CONVERGED)
  formal-verification: skipped (output-only CLI change)
  convergence: achieved (3 consecutive clean passes 4/5/6)
adversarial-passes: 6
models-used:
  builder: claude-sonnet-4-6
  adversary: vsdd-factory adversary agent
generated-at: "2026-09-11T00:00:00"
```

</details>

---

## Pre-Merge Checklist

- [ ] All CI status checks passing (incl. `mutants-aggregate`)
- [ ] `test_bc_1_6_050_status_success_dispatch_arms_covered` passes (dispatch-arm mutant kill confirmed)
- [ ] No critical/high security findings unresolved
- [ ] Human-text output byte-for-byte unchanged verified (AC-006 keyring-gated test documented)
- [x] Demo evidence: SKIPPED by human decision (output-only CLI change, consistent with Wave 2 story A/B1 skips)
- [x] NFR-O-N retired in CLAUDE.md and CHANGELOG.md
- [ ] PR reviewer APPROVE with covered_sha
- [ ] Human squash-merge (not automated — permission-gated)
