# Fresh-Context PR Review — PR #774 (FIX-F5-CYCLE4-2)

- **Branch:** `fix/cycle4-f5-low2` @ `58240f7a`
- **Scope:** cycle-004 F5 actionable LOW hardening (auth/tenant module)
- **Reviewer stance:** independent; implementer self-report not trusted
- **Verdict: CLEAN — merge-ready.** No BLOCKING or WARNING findings. Two non-blocking NITs recorded below.

## CI status (`gh pr checks 774`, `headRefOid 58240f7a`)

| Check | Result |
|-------|--------|
| Format | pass |
| Clippy (ubuntu-latest) | pass |
| MSRV (1.85.0) | pass |
| Deny (licenses + vuln) | pass |
| Spec Guards | pass |
| Mutation testing | pass |
| Secret Scan (gitleaks) | pass |
| Signing Workflow Injection Guard | pass |
| dependency-review | pass |
| Test (ubuntu/macos/windows) | **pending** |
| Clippy (windows-latest) | pending |
| Coverage | pending |

`mergeable: MERGEABLE`, `mergeStateStatus: BLOCKED` (blocked only by pending required checks / code-owner approval — no merge conflict). Clippy(ubuntu)+MSRV green ⇒ all new code (incl. the new `futures::StreamExt` usage and both new `#[cfg(test)]` modules) compiles; the affected unit/integration tests were static-verified but their CI legs are still running.

## Verification per requested item

**1a. `is_plausible_cloud_id` — does NOT over-reject.** Accepts non-empty ASCII-alphanumeric-and-hyphen. Real Atlassian cloudIds are UUIDs (hex + hyphen), a strict subset — accepted (pinned by `test_is_plausible_cloud_id_accepts_real_uuid_shape` and `..._existing_test_fixture_values` covering the `tests/cloud_id_tenant_info.rs` mock literals `the-real-cloud-id` / `irrelevant-for-this-test`). Rejects empty/whitespace/garbage only. Rejection routes through `anyhow::bail!` → caller soft-fail (BC-1.2.053 PC2/3); never persisted. `{"cloudId":""}` now parses OK then fails the plausibility gate (new `test_fetch_cloud_id_soft_fails_on_empty_cloud_id_field`). Correct.

**1b. `validate_and_trim_site_url` — precondition and request-base now share one trimmed string.** Precondition keeps the case-insensitive `https://` check; both `#[cfg(debug_assertions)]` and release arms now derive `base` from `trimmed_site_url` instead of the untrimmed `site_url`. For normal (untrimmed) inputs `trim()` is a no-op ⇒ zero behavior change. Non-https / whitespace-only ⇒ `None` ⇒ `bail!` before the client is built ⇒ zero-request invariant intact. Redirect `Policy::none()`, 10s timeout, no `Authorization` header, no query string — all untouched (client builder not modified). Correct.

**1c. 64 KiB body cap — authoritative, no truncation of normal responses.** Content-Length is a fast-reject fast-path; the streamed read (`bytes_stream()` + `while let Some(chunk)`) is authoritative regardless of a missing/lying Content-Length, capping at `> MAX_TENANT_INFO_RESPONSE_BYTES` (exactly 64 KiB passes). Real tenant_info payloads are a few hundred bytes — never truncated/denied. `reqwest` has the `stream` feature and `futures` (`async-await`) is a dep; compilation confirmed by green Clippy(ubuntu)/MSRV. New `test_fetch_cloud_id_soft_fails_on_oversized_response_body` covers it. `response.json()` → `serde_json::from_slice(&body)` is behavior-equivalent for valid small bodies (error message text changed, but no existing test pins the old serde message; soft-fail tests assert `is_err()` only). Correct.

**2. `clear_profile_api_token_pair` attempt-all.** Both deletes now attempted unconditionally via the extracted host-pure `clear_api_token_pair_attempt_all`; first error (call order) wins; `delete_credential_tolerating_no_entry` keeps `NoEntry`→`Ok`. Matches the sibling `clear_profile_oauth_pair`/`clear_profile_creds` first-error-wins attempt-all pattern. No new keys touched — still only `<profile>:email` + `<profile>:api-token` (no over-deletion). Four new host-pure unit tests cover both-fail / first-fail-second-runs / second-fail-only / both-ok. Correct; genuinely fixes the orphaned-token bug on the mechanism-switch path.

**3. `init.rs` precedence.** GraphQL `cloud_id` now set only when `entry.cloud_id.is_none()`. `org_id` still set unconditionally and the GraphQL call still runs every invocation (org_id + Step-7 team prefetch have no other source). API-token branch: `login_token` (Step 3) → `resolve_and_apply_cloud_id` → `fetch_cloud_id` still fetches on every invocation and overwrites `p.cloud_id` unconditionally on success (`src/cli/auth/login.rs:257-268`), so BC-1.2.053 fetch-on-every-invocation is preserved and the reloaded config already holds the fresh value ⇒ Step 6 correctly skips. OAuth branch: `login_oauth` never sets `cloud_id`, so Step 6 remains the sole source. Fallback when Step-3 tenant_info soft-failed is preserved. Correct.

**4. Doc sweep (`tests/cloud_id_tenant_info.rs`, `auth_chosen_flow_reconcile.rs`, `auth_oauth_default_creation.rs`).** Module-header prose only; retains the historical RED narrative and marks current green status. No code/assertion changes in these three files' bodies (only header comment blocks). Confirmed cosmetic.

**5. Accepted-by-spec skips.** The API-token cloud_id soft-fail warning text is left intact — correct, it is byte-pinned by existing `src/cli/auth/login.rs` tests (`warning: could not look up/refresh cloud_id ...`). The 3 explicit-accept items (`--cloud-id` unvalidated on API-token path; API-token `cloud_id` unused by `base_url()` per BC-1.2.054; warning noise) are untouched. Correct.

**Extra (finding #6): `legacy_none_orphan_clear_target` extraction (`src/cli/auth/login.rs`).** Behavior-preserving: `None` on nothing-probed or same-mechanism; `Some(outgoing)` on differing kind — identical to the inlined `let-else` + equality guard it replaces. Lifetimes fine (`&'static` arg coerces to `&'a`). Adds 3 non-keychain-gated dispatch unit tests. Correct.

**Cross-cutting:** no let-chains (all `if let`/`while let` are single-condition or nested); no `#[allow]`; no new `unsafe` in non-test code (test `set_var` uses the established gated pattern); CHANGELOG entry is under `[Unreleased]` and accurately describes all five items + the two assessed-unchanged items; no scope creep (8 files, all auth/tenant/init/login + their tests + CHANGELOG).

## Findings

### NIT-1 (init re-init edge, non-blocking, `src/cli/init.rs`)
The `is_none()` guard makes a narrow theoretical difference from the old unconditional overwrite: re-running `jr init` on an **existing** profile whose **site changed** AND whose Step-3 `login_token` tenant_info fetch **soft-fails** (network error), but whose Step-6 GraphQL succeeds, would now keep the stale `cloud_id` where the old code refreshed it from GraphQL. Impact is very low: (a) the scenario requires re-init + changed site + selective network failure; (b) API-token `cloud_id` is unused by `base_url()` (BC-1.2.054), Assets/CMDB being the only consumer; (c) on a normal fetch success the value is already fresh. Acceptable as documented; noted for completeness, no change required.

### NIT-2 (changelog cosmetic, non-blocking, `CHANGELOG.md`)
CHANGELOG enumerates items (1)-(5) while the in-code comments reference "finding #2/#3/#6"; item (5) (the `login.rs` extraction) is "finding #6" in code but unnumbered in the CHANGELOG. Purely cosmetic finding-number discontinuity (earlier numbers presumably consumed by FIX-F5-CYCLE4-1). No action required.

## Conclusion
CLEAN / merge-ready pending the still-running CI legs (Test matrix, Clippy-windows, Coverage) and required approval. All five requested items verified correct; no F2-approved BC (BC-1.2.052/053/054) behavior changed; no new defect, no MSRV/let-chain/`#[allow]` issue, CHANGELOG accurate, no scope creep.
