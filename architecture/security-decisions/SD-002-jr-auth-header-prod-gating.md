# SD-002: JR_AUTH_HEADER Production Gating

**Status:** RESOLVED
**Owner:** Phase 3 SECURITY-DECIDE
**Deadline:** Resolved at Phase 1 → 2 gate (2026-05-04)
**References:** NFR-S-B (nfr-catalog.md), R-H2 (risk-register.md), `src/api/client.rs:64-66`

---

## Context

`JiraClient::build_headers` reads `JR_AUTH_HEADER` unconditionally in the production binary at `client.rs:64-66`. Any process that inherits this environment variable from its parent (e.g., a CI runner, a shell script, or a test harness) bypasses keychain authentication entirely. This is intentional for integration tests (`JiraClient::new_for_test`), but the env-var check has no `#[cfg(test)]` gate — it is active in release builds.

**Risk surface:** In CI/CD environments (GitHub Actions, Jenkins) where env vars are shared between steps or jobs, a leaked `JR_AUTH_HEADER` containing a valid `Authorization: Bearer <token>` value would allow any step that runs `jr` to authenticate without the keychain. This is a privilege escalation vector in multi-tenant or shared-runner environments.

---

## Options

### Option A: Gate behind `#[cfg(test)]` (test-only)

- Wrap the `JR_AUTH_HEADER` read at `client.rs:64-66` in `#[cfg(test)]`.
- `JR_AUTH_HEADER` would then be a compile-time test-only mechanism.
- **Impact on tests:** Integration tests currently use `JiraClient::new_for_test(base_url, auth_header)` which passes the header directly as a constructor argument — these are unaffected. Any test that sets `JR_AUTH_HEADER` as an env var directly would break; search for such tests before applying.
- **Migration concern:** Removes a potentially useful debugging escape hatch for power users.

### Option B: Require simultaneous `JR_BASE_URL`

- Only honor `JR_AUTH_HEADER` when `JR_BASE_URL` is also set.
- Reasoning: A rogue process inheriting `JR_AUTH_HEADER` alone is blocked; a test harness always sets both.
- Lowest-risk migration — no behavior change for integration tests (which always set both vars via `JiraClient::new_for_test`).
- Does not fully eliminate the risk in CI environments where `JR_BASE_URL` is also leaked, but substantially narrows the window.

---

## Decision Log

| Date | Decision | Rationale |
|------|----------|-----------|
| TBD  | PENDING  | Awaiting Phase 3 security review |
| **Decide-by** | **Phase 1 → 2 gate** | Required before Phase 2 story decomposition begins (ADV-P2-009) |
| 2026-05-04 | Option A — `#[cfg(test)]` compile-time gate | Categorical security guarantee — code excluded from release binary. Test migration cost bounded (most tests use `JiraClient::new_for_test` already). Rust 1.80+ check-cfg validates conditional-compilation specs. |

---

## Resolution

**Chosen option:** A (`#[cfg(test)]` compile-time gate)

**Rationale:** Research conducted at gate approval (perplexity deep_research, 2026-05-06) showed `#[cfg(test)]` provides the categorically strongest security posture for this anti-pattern: the env-var read is excluded from release-mode compiled binaries entirely, eliminating runtime exploitation vectors. Industry CLIs (gh, glab, aws, gcloud, az) all expose env vars in production with documented precedence; choosing Option A means jr is more secure than industry standard, not just matching it. The "lost debug escape hatch" trade-off is acceptable because `--profile` flag + `auth login` provide the documented power-user path; bare env-var debug is not a documented use case for jr.

**Phase 3 implementation requirements:**
1. Audit `tests/` for any test using bare `JR_AUTH_HEADER` env var (vs. `new_for_test` constructor) — likely 0 because canonical fixture uses `new_for_test`
2. Migrate any survivors to `JiraClient::new_for_test(base_url, auth_header)` constructor
3. Wrap `src/api/client.rs:64-66` env-var read in `#[cfg(test)]`:
```rust
#[cfg(test)]
{
    if let Ok(header) = std::env::var("JR_AUTH_HEADER") {
        return Ok(header);
    }
}
```
4. Add a `#[cfg(not(test))]` integration test that builds in release mode and asserts `JR_AUTH_HEADER` is NOT honored:
```rust
#[test]
fn jr_auth_header_not_honored_in_release_build() {
    // verify cfg!(test) is false in release-mode integration test
    // ... actual implementation depends on test harness
}
```

**Resolves DRIFT-002** — NFR-S-B holdout becomes definable now that fix path is fixed; queue for Phase 2 story decomposition.

## Resolution Requirement

Before closing this SD, the Phase 3 implementer must:
1. Confirm which integration tests (if any) rely on `JR_AUTH_HEADER` as a bare env var (not via `new_for_test`).
2. Choose Option A or Option B and implement it.
3. Add a test that verifies `JR_AUTH_HEADER` is NOT honored in the chosen constraint scenario.
4. Record the outcome in this document.
