# Holdout Evaluation — Cycle-004 (windows-correctness), Phase F7 Dimension-5

**Evaluator:** black-box holdout evaluator (strict information asymmetry: public CLI surface + holdout scenarios only; no source/spec/review-pass access)
**Host:** macOS (Darwin 25.5.0) — no real Windows DPAPI available
**Checkout:** `develop` @ 024de4d8 (jr v0.7.0-dev.4, debug build)
**Date:** 2026-09-05

## Summary
- Scenarios total: 13 (Wave 1: 7, Wave 2: 6)
- Evaluable on this host: 12
- Windows-deferred (not evaluable, per DEC-335/337): 1 (H-W1-WIN-001)
- **Mean satisfaction across EVALUABLE scenarios: 0.95** (target >= 0.85) — PASS
- **Must-pass minimum: 0.90** (threshold: none < 0.6) — PASS
- **Dimension-5 verdict: PASS-WITH-WINDOWS-DEFERRAL**

The real-DPAPI `CryptProtectData`/`CryptUnprotectData` round-trip cannot be exercised on macOS.
The routing, isolation, message-selection, soft-fail, and picker logic around it are all evaluable
cross-platform (via wiremock, the debug-only `JR_FORCE_DPAPI_*`/`JR_S759_*`/`JR_TENANT_INFO_URL`
seams, and behavioral CLI) and pass. The one purely-Windows persistence round-trip is deferred to
the REQUIRED manual Windows-11 smoke gate, per the DEC-335/337 two-tier Windows-validation plan.

## Per-Scenario Results

| Scenario | Must-pass | Score | Pass/Fail | Notes |
|----------|-----------|-------|-----------|-------|
| H-W1-INT-001 | yes | 0.90 | PASS* | winoauth(DPAPI)+apitoken(cloud_id) coexistence/isolation logic green (auth_profiles 46, cloud_id_tenant_info 15, force_dpapi seams). Actual DPAPI-file persistence Windows-deferred. |
| H-W1-INT-002 | yes | 0.90 | PASS* | `jr init` picker routing (OAuth→DPAPI / API-token→tenant_info) confirmed via picker/non-interactive CLI behavior + tests. Real DPAPI leg Windows-deferred. |
| H-W1-REG-001 | yes (reg-crit) | 1.00 | PASS | macOS/Linux store_oauth_tokens unchanged: lib auth 252 / full lib 1384 green; release-gate tests green. |
| H-W1-REG-002 | yes (reg-crit) | 1.00 | PASS | cycle-003 per-profile storage untouched: auth_profiles 46, api_token_percred_wiring, auth_chosen_flow_reconcile 8 all green. |
| H-W1-REG-003 | yes (reg-crit) | 1.00 | PASS | base_url/assets_base_url pin: covered by full lib suite (1384 passed, 0 failed) — pin passes against current code (behavior-preserving). |
| H-W1-REG-004 | yes (reg-crit) | 0.95 | PASS | DEC-321 relogin-then-replace: auth_refresh 29 + auth_chosen_flow_reconcile 8 green; fetch_cloud_id soft-fail-leaves-cloud_id-untouched verified. One keyring-gated variant is #[ignore] (env-limited). |
| H-W1-WIN-001 | n/a | — | DEFERRED | Real DPAPI round-trip on Windows 11 — DEFERRED to F4 spike / F7 manual gate (DEC-335). Not scored, not a failure. |
| H-W2-INT-001 | yes | 0.90 | PASS* | Honest-fail selects Site-1 (with grant-revoke, DEC-334 account-wide framing) vs Site-3 (without) against real DpapiFallbackFailed type: covered by lib auth inline suite (green); recent commits landed message + DEC-334 correction. DPAPI-failure trigger on Windows deferred. |
| H-W2-INT-002 | yes | 1.00 | PASS | README cloud_id caveat matches shipped behavior: soft-fail framing, fallback chain (OAuth-free / API-token GET _edge/tenant_info on login+init+refresh), exact `--cloud-id <uuid>` flag — all match cloud_id_tenant_info tests + CLI help. |
| H-W2-REG-001 | yes (reg-crit) | 1.00 | PASS | Four message sites incl. Site 4 (audit-only) green: lib auth suite passes. |
| H-W2-REG-002 | yes (reg-crit) | 1.00 | PASS | Non-Windows release-build unreachability: jr_force_dpapi_fallback_release_gate + siblings green — release build ignores the seam, LEGACY message path preserved. |
| H-W2-REG-003 | yes (reg-crit) | 0.90 | PASS | README three sections (Unblock-File 76-83, path table 335-336, cloud_id caveat 400-416) present & coherent; Windows-asset language at 66-68 present/correct. Exact diff-scope vs pre-story base is a review artifact not fully diffable under asymmetry. |
| H-W2-CLOSE-001 | yes (MANDATORY) | 0.90 | PASS | fmt --check clean; check-spec-counts + check-bc-cumulative-counts green; full lib 1384 green; all auth integration binaries green. Full all-targets `cargo test` + `clippy -D warnings` remain the CI gate proper (not exhaustively re-run here). |

\* PASS on all host-evaluable aspects; residual DPAPI-persistence leg is Windows-deferred (H-W1-WIN-001).

## Behavioral evidence (public CLI surface)
- `--oauth` + `--api-token` → exit 2, clap mutual-exclusion.
- `jr auth login --oauth --no-input` → `Error: OAuth requires an interactive terminal; use --api-token for non-interactive auth.` (OAuth-first picker cannot proceed headless; directs to API-token).
- `jr auth login --no-input` (no mechanism flag) → defaults to API-token path (`Jira email is required...`) — correct non-interactive default (BC-1.2.050).
- `--oauth` documented as DEPRECATED accepted alias; `--cloud-id <CLOUD_ID>` flag present with disambiguation help text.
- New profile under `--no-input` with no URL → `Error: --url required when the target profile has no URL configured`.

## Test-suite evidence (behavioral pass/fail)
- auth_profiles 46✓ | api_token_percred_wiring 2 ign (env-gated) | auth_chosen_flow_reconcile 8✓ | auth_oauth_default_creation 42✓ | auth_refresh 29✓ | cloud_id_tenant_info 15✓ (3 keyring-gated ign) | auth_remove_logout_semantics 4✓ | auth_output_json 32✓ | multi_cloudid_disambiguation 6✓
- Release-gate: jr_force_dpapi_fallback / jr_force_dpapi_load_pair / jr_s759_force_toolong / jr_tenant_info_url — all 2✓ each | oauth_flow_holdouts 37✓
- lib auth 252✓ | full lib 1384 passed, 0 failed
- fmt clean | check-spec-counts.sh OK (8 files) | check-bc-cumulative-counts.sh OK (742 BCs, 9 files)

## Findings / gaps
- No behavioral defects found on any host-evaluable scenario.
- The only true gap is the mandated Windows-11 manual DPAPI smoke test (H-W1-WIN-001), plus the
  DPAPI-persistence legs of INT-001 / INT-002 / W2-INT-001 whose message/routing halves pass here
  but whose actual `CryptProtectData` round-trip must be confirmed on real Windows. This is by
  design (DEC-335/337), not a remediation item for this dimension.
- H-W2-CLOSE-001 / H-W2-REG-003 carry minor (0.90) uncertainty only because exhaustive all-targets
  `cargo test` + `clippy -D warnings` and pre-story `git diff` scoping are CI/review artifacts
  outside a pure black-box behavioral pass; every aspect reproducible here is green.

## Verdict
**Dimension-5 (HOLDOUT): PASS-WITH-WINDOWS-DEFERRAL.**
Mean 0.95 >= 0.85; no must-pass < 0.6 (min 0.90). All CI-gated cycle-004 holdout scenarios satisfied
on this host. Final closure is contingent on the REQUIRED manual Windows-11 DPAPI smoke gate
(H-W1-WIN-001), which is deferred by plan, not failing.
