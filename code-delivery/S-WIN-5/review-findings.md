# S-WIN-5 Review Findings — PR #510

Date: 2026-06-14
Branch: feat/win-5-ci-yml-windows-job → develop
PR: https://github.com/Zious11/jira-cli/pull/510

## Convergence Tracking

| Cycle | Agent | Verdict | Blocking Findings | Fixed | Remaining |
|-------|-------|---------|-------------------|-------|-----------|
| 1 | pr-reviewer | APPROVE | 0 | — | 0 |
| — | security-reviewer | PASS (advisory) | 0 CRITICAL/HIGH | — | 2 LOW (advisory) |

## Security Findings (Advisory Only — Non-blocking)

| ID | Severity | Description | New / Pre-existing |
|----|----------|-------------|-------------------|
| SEC-001 | LOW | Matrix jobs (`test`, `clippy`) lack `permissions: contents: read` — inherits default token permissions. `harden-runner` with `egress-policy: audit` is present on all steps, mitigating. | New (matrix jobs are new) |
| SEC-006 | LOW | `spec-guard` job lacks `harden-runner` and `permissions:` — pre-existing, not introduced by this PR | Pre-existing |

## CI Check Results

| Check | Status | Notes |
|-------|--------|-------|
| Clippy (ubuntu-latest) | PASS | |
| Clippy (windows-latest) | PASS | AC-006 integration gate MET |
| Coverage | PASS | |
| Deny (licenses + vulnerabilities) | PASS | |
| Format | PASS | |
| MSRV (1.85.0) | PASS | |
| Mutation testing | PASS | |
| Secret Scan (gitleaks) | PASS | |
| Spec Guards (BC counts) | PASS | |
| Test (macos-latest) | PASS | |
| Test (ubuntu-latest) | PASS | |
| dependency-review | PASS | |
| **Test (windows-latest)** | **FAIL** | **AC-005/AC-007 integration gate — 13 failures** |

## Windows Test Failure Details

Run: https://github.com/Zious11/jira-cli/actions/runs/27486959214/job/81244872950

**898 passed, 13 failed, 10 ignored.**

### Class A — Cache isolation failures (2 tests)

Root cause: `with_temp_cache()` in `src/cache.rs` sets `XDG_CACHE_HOME` but NOT `JR_CACHE_DIR`.
On Windows, `cache_root()` uses `%LOCALAPPDATA%\jr` (ignores `XDG_CACHE_HOME`),
so tests write to the real Windows user cache instead of the TempDir.

| Test | Location | Failure |
|------|----------|---------|
| `cache::tests::cross_profile_isolation_team_cache` | `src\cache.rs:660:13` | `assertion failed: read_team_cache("sandbox").unwrap().is_none()` — sandbox sees prod's cache entry |
| `cache::tests::read_missing_object_type_attr_cache_returns_none` | `src\cache.rs:983:13` | `assertion failed: result.is_none()` — stale entry from non-isolated Windows cache |

**Fix required:** `with_temp_cache()` must also set `JR_CACHE_DIR` to the TempDir path
(same pattern as test helper migration in this story, but for the INLINE unit test helper).
This is the EC-002 / Out-of-Scope item from the story spec:
> "src/config.rs inline unit tests use set_var("XDG_CONFIG_HOME") — On Windows these tests
> also need set_var("JR_CONFIG_DIR") added for correct isolation"
The same gap applies to `src/cache.rs::with_temp_cache`.

### Class B — Config PoisonError cascade (10 tests, 1 primary + 9 collateral)

Root cause: `config_load_errors_when_jr_profile_targets_unknown_profile` is the primary failure.
The test sets `XDG_CONFIG_HOME` but NOT `JR_CONFIG_DIR`; on Windows `Config::load()` reads
`%APPDATA%\jr\config.toml` (ignores `XDG_CONFIG_HOME`), finds no config file there, uses
defaults — and defaults don't error on an unknown profile (lenient by design). The test
expected `Err` but got `Ok`. The test's `ENV_MUTEX` guard uses `.unwrap()` (not `.unwrap_or_else(|e| e.into_inner())`), so when this test panics, the mutex is poisoned and all 9 subsequent config tests that acquire the same mutex fail with `PoisonError`.

Primary failure:
| Test | Location | Failure |
|------|----------|---------|
| `config::tests::config_load_errors_when_jr_profile_targets_unknown_profile` | `src\config.rs:1177:26` | `Config::load` returned `Ok` (expected `Err`) — `XDG_CONFIG_HOME` not honoured on Windows |

Collateral PoisonError cascade (9 tests):
`config_load_lenient_succeeds_when_active_profile_unknown`, `config_load_precedence_flag_overrides_env_overrides_field`, `config_load_rejects_invalid_profile_key_in_config`, `config_load_rejects_invalid_profile_name_from_env`, `test_base_url_api_token`, `test_base_url_env_override`, `test_base_url_missing`, `test_base_url_oauth`, `test_base_url_trailing_slash_trimmed`

**Fix required:** All inline config unit tests that set `XDG_CONFIG_HOME` must also set
`JR_CONFIG_DIR` to the `.join("jr")`-suffixed TempDir. Additionally, `ENV_MUTEX.lock()`
in config tests should use `.unwrap_or_else(|e| e.into_inner())` (poison-recovery) so that
one failing test doesn't cascade through all subsequent tests.

### Class C — Windows error message string (1 test)

| Test | Location | Failure |
|------|----------|---------|
| `cli::api::tests::test_resolve_body_at_file_not_found` | `src\cli\api.rs:335:9` | `err.to_string().to_lowercase().contains("no such file")` — Windows says "The system cannot find the file specified." not "no such file or directory" |

**Fix required:** Change assertion to be OS-agnostic. Options:
- Check `err.kind() == std::io::ErrorKind::NotFound` (if the error is wrapped as `io::Error`)
- Or use a platform-specific string: `#[cfg(windows)] contains("cannot find") #[cfg(not(windows))] contains("no such file")`
- Or simply check that the error is non-empty and refers to the path

## Recommendation

**NEEDS ATTENTION — DO NOT MERGE**

Windows CI is red. The failures are genuine Windows-specific bugs surfaced by this story's CI run (as predicted). They fall into the same class as the EC-002 / Out-of-Scope item documented in the story spec: inline unit tests in `src/cache.rs` and `src/config.rs` that set `XDG_*` vars but not `JR_*` seam vars.

The fixes are mechanical and scoped:
1. `src/cache.rs::with_temp_cache` — add `set_var("JR_CACHE_DIR", dir.path())` + `remove_var` cleanup
2. `src/config.rs` inline tests — add `set_var("JR_CONFIG_DIR", dir.path().join("jr"))` at each XDG_CONFIG_HOME call site; poison-recover the ENV_MUTEX lock
3. `src/cli/api.rs:335` — fix OS-agnostic file-not-found assertion
