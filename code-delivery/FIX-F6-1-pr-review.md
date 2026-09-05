# PR #775 Review — FIX-F6-1 (cycle-004 F6 mutation hardening)

**PR:** #775 — `test+ci(tenant): FIX-F6-1 — close mutants.toml scope gap + kill body-cap boundary survivors`
**Branch:** `fix/cycle4-f6-mutation` → `develop` (commit `a585711a`)
**Reviewer:** pr-reviewer (independent, fresh-context, F5-lite)
**Verdict: CLEAN — merge-ready** (blocked only on in-flight required CI checks, not on any finding)

---

## Scope of change (5 files, +200/-1)

| File | Change | Assessment |
|------|--------|-----------|
| `src/api/jira/tenant.rs` | +13 lines, **test-module only** | No production change |
| `tests/cloud_id_tenant_info.rs` | +115 lines (2 tests + 1 helper + doc-table rows) | Correct, non-vacuous |
| `.cargo/mutants.toml` | +8 lines (adds `tenant.rs` to `examine_globs`) | Consistent |
| `docs/specs/cargo-mutants-policy.md` | +37 lines (citation bullet + count + deferrals) | Consistent, guard passes |
| `CHANGELOG.md` | +28 lines (`[Unreleased] → Changed`) | Accurate |

No unrelated changes; no scope creep.

---

## Checklist item 1 — NO production-logic change in tenant.rs ✅

Verified by diffing only the non-context lines: the sole additions to `src/api/jira/tenant.rs`
are the `#[test] fn test_max_tenant_info_response_bytes_is_64_kib` and its doc comment, added at
line 245 — **inside `mod tests` (which begins at line 165)**. Production symbols are untouched:
- Constant `MAX_TENANT_INFO_RESPONSE_BYTES: usize = 64 * 1024` (line 27) — unchanged.
- Content-Length fast-path guard `if len > MAX...` (line 132) — unchanged, still `>`.
- Streamed-read guard `if body.len() > MAX...` (line 143) — unchanged, still `>`.

The body-cap fix was purely killing test-quality survivors, not fixing a code bug — confirmed.
**No production behavior changed.**

## Checklist item 2 — boundary tests correct & non-vacuous ✅

- `test_fetch_cloud_id_succeeds_on_body_exactly_at_cap` — body of exactly 64 KiB (65536 bytes)
  built by `build_tenant_info_body_of_exact_len`, which produces otherwise-valid tenant_info JSON
  (`{"cloudId":"the-real-cloud-id","padding":"aaa…"}`) whose serialized length is asserted to
  equal the target exactly. Since the guards are `len > MAX` (not `>=`), a 64-KiB body must be
  **accepted** → asserts `Ok("the-real-cloud-id")`.
- `test_fetch_cloud_id_soft_fails_on_body_one_byte_over_cap` — 65537-byte body, otherwise valid
  and parseable, must **soft-fail** (`Err`), proving the cap rejects before parse would succeed.
- `test_max_tenant_info_response_bytes_is_64_kib` — pins the constant (`== 64 * 1024 == 65536`),
  killing the `* → +` mutant (65536 vs 1088) that no HTTP-level test can distinguish.

Both bodies are genuinely valid tenant_info JSON with a plausible cloudId, so the size cap — not
JSON validity — is the only variable. **Ran all three: pass.** Independently proved
non-vacuous by mutating the streamed-read guard `>` → `>=` and re-running: the exactly-at-cap
test **FAILED** as expected (the one-over test hits the Content-Length fast-path first, so the
exactly-at-cap test is the one exercising the streamed guard). This confirms the tests genuinely
kill the `>`→`>=`/`==` boundary mutants on both guards, not merely execute the code.

## Checklist item 3 — mutants.toml + policy doc + CI guards ✅

- `.cargo/mutants.toml` adds `"src/api/jira/tenant.rs"` to `examine_globs` (now 22 entries),
  with an accurate rationale comment (21 mutants, no keyring/Windows-cfg boundary, drift class).
- `docs/specs/cargo-mutants-policy.md` §Scope adds the matching citation bullet, updates the count
  "21 → 22 entries", documents the `auth.rs`/`login.rs` deferral (keyring/Windows-cfg-dominated)
  and the `auth_windows_store.rs` SKIP (runtime-cost deferral, not a flooding problem — honestly
  characterized).
- `scripts/check-cargo-mutants-policy-citations.sh` — **PASS** (22 bullets parsed, 77 (file,fn)
  pairs validated, exit 0). All `tenant.rs` symbol citations (`fetch_cloud_id`,
  `validate_and_trim_site_url`, `is_plausible_cloud_id`, `MAX_TENANT_INFO_RESPONSE_BYTES` guards)
  resolve.
- `tests/mutants_glob_existence.rs` — **PASS** (9 tests; new entry resolves to a real file;
  coverage floor respected).

## Checklist item 4 — CHANGELOG accurate; no scope creep ✅

CHANGELOG `[Unreleased] → Changed` entry accurately describes: the scope-gap closure (21→22
entries), the 2 new boundary tests + inline constant pin, "21/21 mutants (100%)", and the honest
deferral of `auth.rs`/`login.rs`/`auth_windows_store.rs`. No overclaiming. `git diff --stat`
confirms exactly the 5 expected files — no unrelated changes.

---

## CI status (`gh pr checks 775`)

PASS: Clippy (ubuntu), Deny, Format, MSRV, **Mutation testing**, Secret Scan, dependency-review,
Signing Workflow Injection Guard, **Spec Guards (incl. mutants policy scope)**.
PENDING (in-flight at review time): Test (ubuntu/windows/macos), Clippy (windows), Coverage.

`mergeable`: **MERGEABLE** · `mergeStateStatus`: **BLOCKED** (awaiting the pending required checks;
not a merge conflict, not a failing gate).

## Recommendation

**CLEAN / merge-ready.** No BLOCKING, WARNING, or NIT findings. This is a well-scoped,
low-risk dev-infra + test-quality change: production behavior is provably unchanged, the two new
boundary tests are correct and demonstrably non-vacuous (mutation-verified), and all CI guards
that can be evaluated offline pass. Merge once the pending `Test`/`Clippy (windows)`/`Coverage`
required checks go green. Per instructions: not posted to GitHub, not merged.
