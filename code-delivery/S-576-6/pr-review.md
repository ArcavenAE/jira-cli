VERDICT: APPROVE — 0 CRITICAL + 0 HIGH findings

# Fresh-Eyes PR Review — PR #643 (S-576-6)

**Title:** test(e2e): attachment live-Jira coverage — platform round-trip + JSM visibility echo shapes (S-576-6, #576 e2e coverage)
**Base:** develop ← feat/S-576-6-attachment-e2e-coverage
**Type:** facade story (SOH-ATTACHMENTS-1 final), test + docs only
**Files:** 3 changed — `tests/e2e_live.rs` (+1007), `docs/specs/e2e-live-jira-testing.md` (+24/-7), `CLAUDE.md` (+2/-2)

## Verdict

**APPROVE.** This is a clean, well-scoped facade story. Zero `src/` delta confirmed. All four new tests are correctly gated and inert in offline CI. The findings below are LOW/INFO polish items, none blocking.

## Checklist Results

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — all changes relate to S-576-6 E2E coverage |
| 2 | Description accuracy | PASS (one cosmetic name typo, INFO-1) |
| 3 | Test coverage | PASS — 4 new gated live tests; no `src/` to cover |
| 4 | Demo evidence | N/A — facade/test story; live-run evidence cited (runs 30031724733, 30041659024) |
| 5 | Commit quality | PASS — conventional format, S-576-6 scoped, clear messages |
| 6 | Diff size | 1033 additions but test+docs only; acceptable for a coverage story |
| 7 | Missing changes | PASS — 4 ACs → 4 tests + docs |
| 8 | Dependency status | PASS — FIX-576-DL (#642) merged before this PR per description |

## Constraint Verification

1. **Triple-gating** — CONFIRMED. All 4 tests carry `#[ignore]` + `if !e2e_enabled() { return; }`. The 3 JSM tests also gate on `JR_E2E_JSM_PROJECT` (Gate 1 clean-skip). `test_e2e_attachment_platform_roundtrip` uses the standard required `JR_E2E_PROJECT` path (via `seed_issue`), consistent with every other ES-project test in the file — it is double-gated + required-var, which is the established convention (not a JSM test).
2. **AttachmentDropGuard unwind-safe** — Substantially yes; see LOW-1. The Drop impl matches command results and routes failures to `eprintln!`, and `jsm_self_close` is documented best-effort/never-panics.
3. **No `src/` changes** — CONFIRMED. `gh pr view` reports only CLAUDE.md, docs/specs/e2e-live-jira-testing.md, tests/e2e_live.rs.
4. **Surface guard not broken** — CONFIRMED. All new CLI invocations (`issue attachment list/download --id --out/delete --yes --output`, `upload --public --internal --yes --output`) are already registered in `tests/e2e_cli_surface_guard.rs` SURFACE table (lines 172-204).
5. **Test naming** — Tests follow the file-local `test_e2e_<subject>` convention (consistent with all neighbors, e.g. `test_e2e_jsm_attachment_upload_public`). Acceptable.
6. **CLAUDE.md citations resolve** — CONFIRMED. `docs/specs/e2e-live-jira-testing.md` and `docs/specs/jsm-e2e-coverage.md` both exist on disk.

## Findings

### LOW-1 — AttachmentDropGuard::drop can panic during unwind (theoretical double-panic)
`tests/e2e_live.rs` ~line 117. The Drop impl builds a fresh `E2eHarness::new()` (calls `TempDir::new().expect(...)`) and `.cmd()` (calls `env::var("JR_E2E_BASE_URL"/"JR_AUTH_HEADER").expect(...)`). If the guard runs while the thread is already unwinding from a failed assertion AND one of those `.expect()` calls fails, the second panic aborts the process. In practice the env vars are set and temp-dir creation succeeds by the time an issue was created, so this never triggers; the pattern also mirrors existing S-576-5 teardown. Non-blocking. Optional hardening: swallow harness-construction errors in Drop rather than `.expect()`.

### LOW-2 — internal/no_flag tests lack the Drop guard (narrow pre-teardown orphan window)
`test_e2e_jsm_attachment_internal_echo_shape` and `test_e2e_jsm_attachment_upload_no_flag` use manual collect-results-then-assert teardown, not `AttachmentDropGuard`. This covers assertion-failure cleanup, but a panic between issue creation and the manual teardown block (e.g. `TempDir::new().expect`, `fs::write(...).expect`, or the upload spawn `.expect`) would orphan the JSM issue. The public test guards this window via the Drop guard (key registered before the temp-file write). The rustdoc scopes the Drop-guard obligation to the public test (ADV-022 — public attachments persist), and orphan risk is documented as LOW/accepted. Non-blocking; noted for consistency.

### INFO-1 — PR description name transposition
The PR body "Four New E2E Tests" box lists `test_e2e_attachment_jsm_upload_no_flag`, but the actual function (and the docs) is `test_e2e_jsm_attachment_upload_no_flag`. Cosmetic only — code and docs agree.

### INFO-2 — Heavy doc bookkeeping churn
Five of the ten commits harmonize the JSM test-count prose (11→13, §4/§8 wording). The final state is internally consistent: 13-function JSM family (12 gated + 1 ungated non-JSM guard), plus `test_e2e_comment_edit_visibility_merge_semantics` (S-577) = 13 JSM-gated tests. The CLAUDE.md change to replace the hardcoded "8 test functions" count with a doc reference is a good anti-drift move.

## What Was Verified (no rubber-stamp)
- Ran `gh pr view` — confirmed exactly 3 files, zero `src/`.
- Read the full 1087-line diff.
- Confirmed all 4 tests have `#[ignore]` + `e2e_enabled()` early-return.
- Confirmed the 3 JSM tests have `JR_E2E_JSM_PROJECT` Gate-1 clean-skip + Gate-2 (empty RT) + Gate-3 (403) skips.
- Confirmed 403 clean-skip paths call `jsm_self_close` (internal/no_flag) or rely on the Drop guard (public).
- Cross-checked every new CLI invocation against the surface-guard SURFACE table — all registered.
- Confirmed both CLAUDE.md doc citations resolve to real files.
