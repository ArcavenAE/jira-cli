---
document_type: delta-analysis-report
feature_name: "Gate tests #4/#5/#6 in multi_cloudid_disambiguation.rs — wiremock-only refactor to close coverage gap"
created: 2026-05-28
revised: 2026-05-28
revision: v2
spec_version_at_analysis: "post-S-410-v1"
status: draft
intent: "bug-fix"
feature_type: "infrastructure"
scope: "non-trivial"
severity: "LOW"
issue: 428
predecessor_cycle: "S-410 (PR #416)"
traces_to: "L-410-1, L-421-4"
---

# F1 Delta Analysis — Issue #428 (v2)

## Revision History

| Version | Date | Author | Change |
|---------|------|--------|--------|
| v1 | 2026-05-28 | architect a1b15ae199bf7ae0c | Initial analysis. Recommended GATE-NOW for tests #4/#5/#6; flagged real coverage gap in Section 9; framed gap as accepted trade-off consistent with S-410 precedent. Open Question 1 asked whether the gap was accepted. |
| v2 | 2026-05-28 | architect (this session) | **Scope expansion approved at human-approval gate.** User chose to close the coverage gap via a wiremock-only refactor in F3 rather than accept the gap. Production code (`src/api/auth.rs`) is now in scope. Scope reclassified `trivial → non-trivial`. Regression risk raised to MEDIUM. Refactor design sketch and exit-code preservation strategy added. All previously-valid sections preserved. |

**Why the revision was triggered:** Open Question 1 from v1 was answered affirmatively: the user does NOT accept the coverage gap. The fix must preserve always-run CI coverage of the exit-64 disambiguation contract by refactoring tests #4, #5, #6 from subprocess-style (`jr_isolated()`) to in-process style (calling the extracted disambiguation function directly against a wiremock server). This eliminates the keychain-race root cause at the test level rather than hiding it behind a gate.

---

## 1. Inputs and Feature Request

- **Issue:** https://github.com/Zious11/jira-cli/issues/428
- **Predecessor cycle:** S-410 (PR #416, merged 2026-05-26) — gated 6 KEYCHAIN-TRANSITIVE tests in `tests/multi_cloudid_disambiguation.rs` behind `JR_RUN_KEYRING_TESTS=1`. The S-410 F1 architect classified 6 other tests as NO-KEYCHAIN on the basis that their subprocess exits 64 before `store_oauth_tokens` is reached.
- **Observed flakes (3 occurrences):** Tests `test_cloud_id_flag_value_not_in_response_exits_64`, `test_no_input_multi_org_exits_64_with_actionable_error`, and `test_no_input_multi_org_lists_available_cloud_ids_in_error` each flaked on CI with `Error: Platform secure storage failure: The specified item already exists in the keychain.` and exited 1 instead of 64 — despite the S-410 F1 architect's NO-KEYCHAIN classification.
- **Original requested scope (v1):** Gate tests #4, #5, #6 behind `#[ignore]` + `JR_RUN_KEYRING_TESTS=1`. Update CLAUDE.md to bump "6 KEYCHAIN-TRANSITIVE" to "9 KEYCHAIN-TRANSITIVE".
- **Revised scope (v2):** Refactor tests #4, #5, #6 to call the disambiguation logic in-process against a wiremock server — no `jr_isolated()`, no keychain access, no gating required. This closes the coverage gap while also eliminating the race condition root cause.
- **This analysis:** Validates the recommendation against actual test bodies and production code. Does NOT accept the S-410 architect's exit-code reasoning at face value — per L-410-1, all test bodies were inspected directly.

---

## 2. L-410-1 Precaution Applied

**L-410-1** (codified 2026-05-27): "Whenever the F1 architect produces a per-test classification table for a test file, it MUST cross-check the table row count against `grep -c "^async fn test_\|^fn test_" <test_file>`."

**Cross-check executed:**

```
grep -c "^async fn test_\|^fn test_" tests/multi_cloudid_disambiguation.rs
```

Result: **12**. The per-test inspection table in Section 8 has exactly 12 rows. Counts match — same as v1. No new tests were added; the refactor changes bodies of existing tests.

Additionally, L-421-4 (codified 2026-05-28 during the S-421 PR cycle that observed the flakes) records the root-cause lesson: "The architect's 'follows exit path' reasoning for keychain classification was incomplete — it considered only the explicit code path to keychain write, not the full subprocess lifecycle (where JR_SERVICE_NAME is set at subprocess spawn time, before any exit-64 branch is reached)." This analysis applies L-421-4 directly by inspecting each affected test body for the `jr_isolated()` call pattern, not by reasoning about exit codes.

---

## 3. Impact Boundary Identification

### Files NEW (none)

No new files are created by this fix.

### Files MODIFIED

| File | Change Type | Risk |
|------|------------|------|
| `src/api/auth.rs` | Extract `resolve_cloud_id` (or equivalent) from the disambiguation block in `oauth_login` as a `pub(crate)` function callable from tests | MEDIUM — production code; OAuth login path |
| `tests/multi_cloudid_disambiguation.rs` | Rewrite bodies of tests #4, #5, #6 to call extracted function directly; no `jr_isolated()`, no `#[ignore]`, no env-gate | LOW — test file only; existing tests #1–#3, #7–#12 are untouched |
| `CLAUDE.md` | Update the keychain test count line (see Section 13 for exact wording) | LOW — documentation |

### Files DEPENDENT (unchanged, no regression risk)

| File | Depends On | Regression Risk |
|------|-----------|----------------|
| `src/cli/auth/login.rs` | Calls `crate::api::auth::oauth_login` which contains the disambiguation block | NONE — CLI handler is not modified; it delegates to `oauth_login` unchanged |
| `tests/oauth_refresh_integration.rs` | Shares `JR_RUN_KEYRING_TESTS` gate convention | NONE — not modified |
| `tests/auth_profiles.rs` | Shares `JR_RUN_KEYRING_TESTS` gate convention | NONE — not modified |

**Production code change scope:** Single function extraction in `src/api/auth.rs`. The overall behavior of `oauth_login` is unchanged; the disambiguation block is lifted into a named helper and called from the same site.

---

## 4. Affected Artifact Mapping

### BCs Affected

**None.** The behavioral contract for the three tests is:
- `--cloud-id <value>` not in accessible-resources → exit 64 + explanatory stderr mentioning the missing ID and listing available IDs.
- `--no-input` + multi-org + no `--cloud-id` → exit 64 + "Multiple Atlassian orgs" + `--cloud-id` in stderr.

These contracts exist today in `src/api/auth.rs::oauth_login` (disambiguation match arm). The refactor does not change the observable behavior — it only changes how the tests exercise the behavior (in-process call vs subprocess). No BC text is modified; no new BCs are needed.

### Existing Tests in Regression Risk Zone

All tests in `tests/multi_cloudid_disambiguation.rs` are in scope for review because this file is being modified. The 9 tests NOT being rewritten must remain byte-for-byte identical.

No tests outside this file are in the regression risk zone. `src/api/auth.rs::oauth_login` is not currently called directly by any test outside `multi_cloudid_disambiguation.rs` — its entry points are all through `src/cli/auth/login.rs::login_oauth`, which is covered by the already-gated `#[ignore]` tests.

**Caller check:** `grep -rn "oauth_login\b" src/ tests/` confirms `oauth_login` is called only from `src/cli/auth/login.rs::login_oauth`. The only test file that exercises this path at the API layer is `tests/multi_cloudid_disambiguation.rs`. No other test is at risk.

---

## 5. Intent Classification

**Classified intent: `bug-fix` (unchanged from v1)**

Rationale: The root cause — keychain-race due to `jr_isolated()` subprocess lifecycle — is a test infrastructure defect, not a production defect. The refactor eliminates the race at the source by removing the subprocess call entirely for the affected tests. Production behavior is unchanged.

---

## 6. Scope Classification

**RECLASSIFIED: `trivial → non-trivial`**

A change is trivial when ALL of the following are true:

| Criterion | v1 Status | v2 Status | Notes |
|-----------|-----------|-----------|-------|
| Single module / single file or doc-only | YES — 2 files | NO — 3 files | `src/api/auth.rs` added as MODIFIED |
| No new BCs needed | YES | YES | Still no BC changes |
| No architecture change | YES | YES | Extract helper ≠ architecture change |
| No new external dependencies | YES | YES | None |
| Regression risk: LOW | YES | NO | MEDIUM (production OAuth code touched) |

**Justification for reclassification:** The extraction of a `pub(crate)` function from `src/api/auth.rs::oauth_login` is a production code change on the OAuth login path. Even a pure refactor (no behavior change) on the authentication flow carries MEDIUM regression risk: a compile-time or logic error in the extraction could break the only login path for OAuth users. This is categorically different from adding `#[ignore]` to a test.

Per VSDD policy, the user has overridden to full F1-F7 treatment regardless of scope classification (documented in v1 Section 6 and unchanged).

---

## 7. Severity Classification

**Classified severity: LOW (unchanged from v1)**

Rationale:
- All three flakes cleared on rerun — no sustained breakage.
- The fix eliminates the flake by removing its root cause (subprocess keychain race), not by hiding it behind a gate.
- LOW component: the original symptom (intermittent CI noise, cleared on rerun) is low severity. The fix is now more thorough than v1 proposed, but the severity of the triggering defect has not changed.

---

## 8. Per-Test Inspection Table

**L-410-1 precaution:** Row count verified against `grep -c "^async fn test_\|^fn test_" tests/multi_cloudid_disambiguation.rs` = 12. Table has 12 rows. Counts match.

**Classification criteria applied (per L-421-4, NOT per S-410 exit-code reasoning):**

- **REWRITE-IN-PROCESS:** test currently calls `jr_isolated()` and exercises a path that can be tested in-process by calling the extracted disambiguation function; rewriting eliminates the keychain race without losing coverage.
- **KEEP-GATED:** test calls `jr_isolated()` AND exercises a path that cannot reasonably be tested in-process (e.g., full OAuth token storage round-trip requiring keychain write). Stays `#[ignore]` + `JR_RUN_KEYRING_TESTS=1`.
- **KEEP-ALWAYS:** test does NOT call `jr_isolated()` — safe to run always.

| # | Test name | Currently gated? | Uses jr_isolated()? | v1 Verdict | v2 Verdict |
|---|-----------|-----------------|---------------------|------------|------------|
| 1 | `test_cloud_id_flag_recognized_in_help` | NO | NO | KEEP-ALWAYS | KEEP-ALWAYS |
| 2 | `test_cloud_id_flag_is_parsed_not_rejected_by_clap` | YES | YES | KEEP-GATED | KEEP-GATED |
| 3 | `test_cloud_id_flag_picks_named_resource_not_first` | YES | YES | KEEP-GATED | KEEP-GATED |
| 4 | `test_cloud_id_flag_value_not_in_response_exits_64` | NO — OBSERVED FLAKE | YES | GATE-NOW | **REWRITE-IN-PROCESS** |
| 5 | `test_no_input_multi_org_exits_64_with_actionable_error` | NO — OBSERVED FLAKE | YES | GATE-NOW | **REWRITE-IN-PROCESS** |
| 6 | `test_no_input_multi_org_lists_available_cloud_ids_in_error` | NO — LIKELY FLAKE | YES | GATE-NOW | **REWRITE-IN-PROCESS** |
| 7 | `test_single_resource_no_regression_single_org_path` | YES | YES | KEEP-GATED | KEEP-GATED |
| 8 | `test_callback_url_contains_127_0_0_1_and_port_53682` | NO | NO | KEEP-ALWAYS | KEEP-ALWAYS |
| 9 | `test_cloud_id_flag_does_not_change_redirect_uri_in_authorize_url` | YES | YES | KEEP-GATED | KEEP-GATED |
| 10 | `test_interactive_select_via_stdin_picks_second_resource` | YES | YES | KEEP-GATED | KEEP-GATED |
| 11 | `test_cloud_id_help_text_mentions_disambiguation_or_multiple_orgs` | NO | NO | KEEP-ALWAYS | KEEP-ALWAYS |
| 12 | `test_interactive_render_shows_name_url_and_id` | YES | YES | KEEP-GATED | KEEP-GATED |

**Summary:**
- REWRITE-IN-PROCESS (was GATE-NOW): **3** tests (#4, #5, #6)
- KEEP-GATED (already gated by S-410): **6** tests (#2, #3, #7, #9, #10, #12)
- KEEP-ALWAYS (confirmed NO-KEYCHAIN): **3** tests (#1, #8, #11)
- Total: **12** tests — matches grep count.

---

## 9. Coverage Loss Assessment (Revised)

**Coverage gap: CLOSED.**

Unlike v1 (which accepted the gap as a trade-off), v2 eliminates it entirely. Tests #4, #5, #6 remain in always-run CI and continue to assert the exit-64 disambiguation contract. They do so by calling the extracted in-process function directly, exercising the same disambiguation logic, with the same wiremock HTTP mocks, without spawning a subprocess and without touching the keychain.

The issue body's incorrect "alternative coverage in issue_edit_field.rs tests 26/27" claim (debunked in v1 Section 9) is moot under v2 — no alternative coverage is needed because the tests themselves remain always-run.

---

## 10. Regression Risk Assessment (Revised)

| Risk Type | v1 Level | v2 Level | Rationale |
|-----------|----------|----------|-----------|
| Production regression | NONE | MEDIUM | `src/api/auth.rs::oauth_login` is modified; the disambiguation block is extracted. Any error in the extraction breaks the OAuth login path for all users with multi-org Atlassian accounts. Correct extraction preserves identical behavior. |
| Test regression | LOW | LOW | Only 3 test bodies change. The other 9 tests are untouched. The refactored tests lose subprocess overhead and keychain dependency — they become more reliable, not less. |
| Documentation drift | LOW | LOW | CLAUDE.md count stays at the current gated total (6) because the 3 affected tests do NOT become `#[ignore]`-gated; the CLAUDE.md line changes only in what it describes. See Section 13 for exact wording. |
| CI reliability | POSITIVE | STRONGLY POSITIVE | Gating was the symptom-mask. In-process refactor eliminates the race condition root cause entirely — those 3 tests become immune to keychain contention. |

### Regression Baseline — Files That Must Not Change

- `tests/oauth_refresh_integration.rs` — already correctly gated; untouched
- `tests/auth_profiles.rs` — existing keychain tests; untouched
- `src/cli/auth/login.rs` — CLI handler that calls `oauth_login`; untouched
- All other `src/` files — no production code changes in scope beyond `src/api/auth.rs`
- All other `tests/` files — no regression risk

---

## 11. Production Code Factorability Assessment

### Where the Disambiguation Logic Lives

The disambiguation block lives in `src/api/auth.rs::oauth_login` at approximately the `// Disambiguation: BC-1.5.038` comment (verified by direct inspection). The block is a `match resources.len() { ... }` expression that:

1. `0` arms: returns `JrError::UserError` ("No Atlassian sites authorized...") — not relevant to tests #4/#5/#6.
2. `1` arm: auto-selects `resources[0].id.clone()` — not relevant to tests #4/#5/#6.
3. `_` (multi-org) arm: contains all three paths exercised by tests #4, #5, #6:
   - `cloud_id_override` is `Some` → find-by-id or `JrError::UserError` (test #4 path)
   - `no_input` is `true` and `cloud_id_override` is `None` → `JrError::UserError` with listing (tests #5, #6 path)
   - Interactive branch → prompt via `dialoguer` (not relevant to the 3 affected tests)

### Is the Logic Already Factorable?

**YES — "extract function" (low-risk refactor).**

The entire `match resources.len()` block depends on:
- `resources: Vec<AccessibleResource>` (already fetched from the API response)
- `cloud_id_override: Option<&str>` (passed into `oauth_login`)
- `no_input: bool` (passed into `oauth_login`)

It produces a `Result<String, anyhow::Error>` (the selected `resource_id`) — or returns early from the outer function with a `UserError`.

The interactive branch (dialoguer) depends on `std::io::stdin()` being a TTY. This branch is NOT in scope for the 3 affected tests (they all use `--no-input` or `--cloud-id`). The extract can include the interactive branch as a dead code path for tests #4/#5/#6, OR the interactive branch can be left in `oauth_login` and the extraction can cover only the `cloud_id_override`/`no_input` branches. Either works; the simpler extraction is the full `match` block.

There is **no restructuring of the call site** required: `oauth_login` calls `resolve_cloud_id(...)` where the match block currently sits, and the result flows through identically. This is purely "lift into named function."

### Error Types Involved

All three error paths produce `crate::error::JrError::UserError(String)`. Confirmed by direct inspection of `src/api/auth.rs::oauth_login`:

```
// --cloud-id not found path (test #4):
crate::error::JrError::UserError(format!(
    "Provided --cloud-id '{override_id}' not found in accessible resources. Available:\n{listing}"
))

// --no-input multi-org path (tests #5, #6):
crate::error::JrError::UserError(format!(
    "Multiple Atlassian orgs found. Use --cloud-id <id> to disambiguate. Available:\n{listing}"
))
```

`JrError::UserError` maps to exit code 64 via `src/error.rs::JrError::exit_code()`. The `_` wildcard arm in `exit_code()` would map to exit 1; `UserError` is explicitly listed as 64. Confirmed by reading `src/error.rs`:

```rust
JrError::UserError(_) => 64,
```

---

## 12. Refactor Design Sketch

This is pseudo-code, not a real edit. Intended to give the implementer and test-writer enough information to act without further architectural decisions.

### BEFORE — current structure in `src/api/auth.rs::oauth_login`

```rust
pub async fn oauth_login(
    profile: &str,
    client_id: &str,
    client_secret: &str,
    scopes: &str,
    strategy: RedirectUriStrategyRequest,
    cloud_id_override: Option<&str>,
    no_input: bool,
) -> Result<OAuthLoginResult> {
    // ... token exchange, HTTP setup ...

    let resources: Vec<AccessibleResource> = resources_response.json().await?;

    // Disambiguation: BC-1.5.038
    let resource_id: String = match resources.len() {
        0 => return Err(JrError::UserError("No Atlassian sites...").into()),
        1 => resources[0].id.clone(),
        _ => {
            if let Some(override_id) = cloud_id_override {
                resources.iter()
                    .find(|r| r.id == override_id)
                    .map(|r| r.id.clone())
                    .ok_or_else(|| JrError::UserError(format!(...)))?
            } else if no_input {
                return Err(JrError::UserError(format!("Multiple Atlassian orgs...")).into());
            } else {
                // dialoguer interactive selection ...
                resources[selection].id.clone()
            }
        }
    };
    // ... rest of oauth_login
}
```

### AFTER — extract `resolve_cloud_id`

```rust
/// Resolve the cloud ID from `accessible-resources` for OAuth login disambiguation.
///
/// Returns `Ok(cloud_id)` on success. Returns `Err(JrError::UserError)` (exit 64)
/// when `resources` is empty, `cloud_id_override` is not found in `resources`,
/// or `no_input` is true with multiple resources and no `cloud_id_override`.
///
/// The interactive branch (dialoguer prompt) is included here but only reachable
/// when `no_input = false` and `len > 1`. Tests #4/#5/#6 only exercise the
/// non-interactive paths.
pub(crate) fn resolve_cloud_id(
    resources: &[AccessibleResource],
    cloud_id_override: Option<&str>,
    no_input: bool,
) -> Result<String, crate::error::JrError> {
    match resources.len() {
        0 => Err(JrError::UserError(
            "No Atlassian sites authorized this token. Re-run `jr auth login` \
             and select at least one site at the consent screen."
                .into(),
        )),
        1 => Ok(resources[0].id.clone()),
        _ => {
            if let Some(override_id) = cloud_id_override {
                resources
                    .iter()
                    .find(|r| r.id == override_id)
                    .map(|r| r.id.clone())
                    .ok_or_else(|| {
                        let listing = resources
                            .iter()
                            .map(|r| format!("  {} — {} ({})", r.id, r.name, r.url))
                            .collect::<Vec<_>>()
                            .join("\n");
                        JrError::UserError(format!(
                            "Provided --cloud-id '{override_id}' not found in accessible \
                             resources. Available:\n{listing}"
                        ))
                    })
            } else if no_input {
                let listing = resources
                    .iter()
                    .map(|r| format!("  {} — {} ({})", r.id, r.name, r.url))
                    .collect::<Vec<_>>()
                    .join("\n");
                Err(JrError::UserError(format!(
                    "Multiple Atlassian orgs found. Use --cloud-id <id> to disambiguate. \
                     Available:\n{listing}"
                )))
            } else {
                // ... interactive branch unchanged — dialoguer or line-based fallback
                // returns Ok(selected_id)
                todo!("interactive branch — copied verbatim from oauth_login, not repeated here")
            }
        }
    }
}

pub async fn oauth_login(...) -> Result<OAuthLoginResult> {
    // ... all unchanged preamble ...
    let resources: Vec<AccessibleResource> = resources_response.json().await?;

    // CHANGED: call extracted function instead of inline match
    let resource_id = resolve_cloud_id(&resources, cloud_id_override, no_input)
        .map_err(anyhow::Error::from)?;

    // ... rest of oauth_login unchanged
}
```

**Key design choices in the extract:**

1. `resolve_cloud_id` returns `Result<String, JrError>` (not `anyhow::Error`) so tests can match on the variant directly without downcasting.
2. `pub(crate)` visibility — accessible from `tests/multi_cloudid_disambiguation.rs` via `use jr::api::auth::resolve_cloud_id` (or `jr::api::auth` re-export if needed).
3. The interactive branch is included verbatim — tests #4/#5/#6 pass `no_input=true` or a `cloud_id_override`, so they will never reach it. The function signature does not need to be split.
4. The `0`-arm result type changes from `return Err(...)` to `Err(...)` because the function returns `Result` rather than being inside the `oauth_login` async body that returns early. The semantics are identical.

**Visibility note:** `AccessibleResource` must also be `pub(crate)` (or already is) for tests to construct fixture data. Verify the current visibility of `AccessibleResource` in `src/api/auth.rs` before implementing.

---

## 13. Exit-Code Preservation Strategy

**Decision: Option (a) — Existing tests already cover JrError → exit 64 mapping. No new subprocess smoke test is required.**

**Justification:**

The `JrError::UserError(_) => 64` mapping is a unit-level invariant of `src/error.rs::JrError::exit_code()`. It is currently tested by the unit test `src/error.rs::tests::user_error_exit_code`:

```rust
// src/error.rs (inline unit test, always-run, not gated)
fn user_error_exit_code() {
    assert_eq!(JrError::UserError("test".into()).exit_code(), 64);
}
```

This test is NOT subprocess-dependent, NOT keychain-dependent, and runs in `cargo test --lib` on every CI run. It covers the exact mapping that the 3 disambiguation error paths rely on.

The `main.rs` error-dispatch path (`e.chain().find_map(|cause| cause.downcast_ref::<JrError>()).map(|je| je.exit_code())`) is NOT specifically tested by a dedicated unit test, but it is exercised indirectly by every always-run integration test that asserts `exit_code == 64` against a subprocess (e.g., `tests/oauth_flow_holdouts.rs::test_auth_refresh_no_input_no_url_exits_64`, `tests/issue_commands.rs` transition-ambiguity tests, `tests/issue_read_holdouts.rs` scheme-validation tests). These tests collectively verify that `JrError::UserError` propagates through `main.rs` into a process exit 64 for non-disambiguation contexts.

The in-process wiremock tests for #4/#5/#6 will assert:

```rust
// Test body sketch for test #4 (in-process version):
let resources = two_resources_b_first_as_vec(); // helper returning Vec<AccessibleResource>
let result = jr::api::auth::resolve_cloud_id(
    &resources,
    Some("cloud-NONEXISTENT"),
    true, // no_input
);
assert!(result.is_err());
let err = result.unwrap_err();
assert!(matches!(err, jr::error::JrError::UserError(_)));
let msg = err.to_string();
assert!(msg.contains("cloud-NONEXISTENT") || msg.contains("not found"));
```

The in-process test confirms:
- The correct `JrError` variant is returned.
- The error message contains the expected content.

The exit-code-64 mapping for that variant is confirmed by `user_error_exit_code` in `src/error.rs`. The two together give complete coverage without a subprocess.

**No new smoke test is required.**

---

## 14. Updated Story Scope for F3

**Mode:** Full VSDD treatment (user override — documented in v1 Section 11, unchanged).

**Story artifacts to produce:**

1. **`src/api/auth.rs` — production refactor**
   - Extract `pub(crate) fn resolve_cloud_id(resources: &[AccessibleResource], cloud_id_override: Option<&str>, no_input: bool) -> Result<String, crate::error::JrError>` from the disambiguation block in `oauth_login`.
   - Update the call site in `oauth_login` to delegate to `resolve_cloud_id`.
   - Verify `AccessibleResource` visibility is `pub(crate)` or add re-export as needed.
   - No change to function signatures of `oauth_login`, `login_oauth`, or any other function.

2. **`tests/multi_cloudid_disambiguation.rs` — test rewrites**
   - Rewrite bodies of tests #4, #5, #6 only.
   - Remove `jr_isolated(...)` calls from all three.
   - Remove `write_oauth_profile_config`, `TempDir`, `MockServer`, `mount_token_exchange` setup from these tests (they only need `AccessibleResource` fixture data and a direct function call).
   - Assert on `Result::Err` variants and message content (not `exit_code`).
   - Do NOT add `#[ignore]` or `JR_RUN_KEYRING_TESTS` guard to these tests.
   - The 9 other tests are untouched.

3. **`CLAUDE.md` — count update**
   - The current line reads approximately: `(6 KEYCHAIN-TRANSITIVE tests touching \`store_oauth_tokens\`)`.
   - After v2 fix: the count remains **6** KEYCHAIN-TRANSITIVE tests (tests #2, #3, #7, #9, #10, #12 — unchanged from S-410).
   - Tests #4, #5, #6 become in-process, not keychain-transitive — they do NOT increment the KEYCHAIN-TRANSITIVE count.
   - The CLAUDE.md line description should be updated to add context: change `(6 KEYCHAIN-TRANSITIVE tests touching \`store_oauth_tokens\`)` to `(6 KEYCHAIN-TRANSITIVE tests touching \`store_oauth_tokens\`; tests #4, #5, #6 in the same file are in-process wiremock tests — no keyring access)`.
   - This update MUST be in the same commit as the test and production code changes (doc-fallout rule, per PR #356 R14-R18 lesson, cited in CLAUDE.md).

**No new BCs.** The fix does not alter any behavioral contract.

---

## 15. Open Questions for F1 Re-Approval Gate

1. **`AccessibleResource` visibility:** The refactor requires `resolve_cloud_id` and `AccessibleResource` to be visible from integration tests. Verify the current visibility of `AccessibleResource` in `src/api/auth.rs` before F3 dispatch. If `AccessibleResource` is `pub(crate)` or `pub`, no change needed. If it's private, it must be bumped to `pub(crate)`. This is a 1-line change with zero behavioral impact — but it is technically a public API surface expansion for the crate's `lib.rs` consumers, which should be confirmed as acceptable.

2. **Interactive branch in `resolve_cloud_id`:** The design sketch includes the dialoguer interactive branch in the extracted function. An alternative is to leave the interactive branch in `oauth_login` and have `resolve_cloud_id` handle only the `0`, `1`, and non-interactive multi-org cases. This would require `oauth_login` to have a small conditional at the call site. The full-extraction approach (all three paths in `resolve_cloud_id`) is cleaner but adds a dialoguer/stdin dependency to the extracted function. Confirm the preferred split before F3 dispatch.

3. **Fixture construction for in-process tests:** The in-process test bodies need `Vec<AccessibleResource>` constructed from the same mock data as `two_resources_b_first()` (currently builds `serde_json::Value` for wiremock). The implementer will need either: (a) a helper that constructs `Vec<AccessibleResource>` directly (bypassing serde), or (b) serialize the existing `serde_json::Value` fixture and deserialize into `Vec<AccessibleResource>` in-test. Option (b) is simpler and avoids touching the test harness's `mock_harness` module. Confirm preference. This is an implementation detail, not an architectural decision.

4. **`#[cfg(debug_assertions)]` or `pub(crate)` on `resolve_cloud_id`:** Should `resolve_cloud_id` be `pub(crate)` unconditionally (accessible from integration tests via the crate's `lib.rs` re-export), or gated behind `#[cfg(test)]`? Since the function may have legitimate future callers (e.g., a future `jr auth check` command that validates accessible resources without completing the full OAuth flow), `pub(crate)` unconditional is preferred. Confirm.

---

## Appendix: S-410 Architect Lesson Reference

**L-410-1** (codified 2026-05-27): F1 per-test audit must cross-check table row count via grep. Applied in this analysis — grep count (12) matched table row count (12).

**L-421-4** (codified 2026-05-28): "The architect's 'follows exit path' reasoning for keychain classification was incomplete — it considered only the explicit code path to keychain write, not the full subprocess lifecycle (where JR_SERVICE_NAME is set at subprocess spawn time, before any exit-64 branch is reached). Future keychain-isolation audits must check whether the test subprocess sets JR_SERVICE_NAME at all, regardless of whether the code path reaches an explicit keychain call."

Both lessons were applied as primary methodology in this analysis. The v2 verdict for tests #4, #5, #6 is REWRITE-IN-PROCESS — a more thorough resolution than GATE-NOW — based on the finding that the disambiguation logic is factorable into a pure function that can be tested without a subprocess.

**Additional lesson (implicit in this revision):** When a coverage gap is identified in F1 and the gap is non-trivial, the F1 architect should present BOTH options — accept the gap (simpler) vs close the gap (more thorough) — rather than pre-selecting the simpler path. The human-approval gate is the appropriate decision point. This revision was triggered by exactly that feedback loop.
