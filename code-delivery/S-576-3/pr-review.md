# PR Review — #635 (S-576-3) — Cycle 3 (post `cargo fmt`)

**Verdict: APPROVE**
**covered_sha:** `5a70c0add71db4f7ee2a45d7f5366617574e093c`

## Scope

Review cycle 3 — reviewing the new HEAD after a `cargo fmt` CI-fix push. The
range `ae347e0c..5a70c0ad` contains exactly one commit and one file:

- Commit: `5a70c0ad style(S-576-3): cargo fmt — reformat new mutation-kill tests (CI fix cycle 2)`
- File: `tests/attachment_upload.rs` (+7 / -13)

No source files changed. No other test files changed.

## Assessment

### 1. Purely a formatting change (no logic mutations)?

Yes. Every hunk is `rustfmt` line-collapsing (multi-line → single-line where it
fits the width budget). No logic tokens changed:

- `test_bc_3_9_001_rate_limit_retry_after_at_cap_proceeds`:
  `JiraClient::new_for_test(server.uri(), "Basic dGVzdDp0ZXN0".to_string())` and
  the `tokio::spawn(async move { client.upload_attachments("TEST-1", &[file_path]).await })`
  closure were reflowed — identical args, auth string, and spawn semantics.
- `test_bc_3_9_001_rate_limit_retry_after_above_cap_aborts`:
  the `.respond_with(ResponseTemplate::new(429).insert_header("Retry-After",
  (MAX_RETRY_AFTER_SECS + 1).to_string().as_str()))` chain was reflowed — same
  429 status, `Retry-After` header, `MAX_RETRY_AFTER_SECS + 1` value, `.expect(1)`.
- `test_bc_3_9_001_rate_limit_retry_after_zero_skips_sleep`: required no
  reformatting; untouched.

### 2. Tests still pin the boundary behaviors?

Yes. The mock configurations that encode the boundaries are semantically
identical after the reflow (at-cap proceeds via the 5s wall-clock gate; above-cap
aborts via `MAX_RETRY_AFTER_SECS + 1` with `.expect(1)`). The assertion bodies
sit outside the changed hunks and are unmodified. The prior `ae347e0c` APPROVE
still holds — nothing behavioral moved.

## Findings

None. Whitespace/style-only change with no behavioral impact.

**covered_sha: 5a70c0add71db4f7ee2a45d7f5366617574e093c**

---

## Cycle-2 review (retained for history) — covered_sha `ae347e0c`

## Scope

Review cycle 2 — reviewing the new HEAD after a CI-fix push. The only change
since the prior APPROVE (`b5977e5e`, see cycle-1 review below) is a single commit
`ae347e0c`, which adds 252 lines to `tests/attachment_upload.rs`: three
mutation-kill tests plus a header comment block. **No source changes** —
implementation is unchanged since the prior APPROVE.

## Verified against the implementation

`src/api/jira/attachments.rs` (branch HEAD):
- Line 257: `if delay > MAX_RETRY_AFTER_SECS` → abort with
  `JrError::ApiError { status: 429, message: "Rate limited; Retry-After {}s exceeds {}s cap. Rerun later." }`
- Line 267: `if delay > 0 { sleep }`
- `MAX_RETRY_AFTER_SECS = 60` (`src/api/rate_limit.rs`)
- `src/main.rs`: in `--output json` mode, errors are written to **stderr** via
  `eprintln!` with `e.to_string()` embedded — so the human message reaches
  stderr even in JSON mode. This validates test 3's stderr assertion.

## Test-by-test assessment

1. `test_bc_3_9_001_rate_limit_retry_after_zero_skips_sleep` — delay=0:
   `0 > 60` false (no abort), `0 > 0` false (no sleep) → 429 then 200 → exit 0.
   Rustdoc/commit honestly state the three line-267 mutants are genuinely
   equivalent for `u64 delay=0` and this test only documents the boundary — no
   over-claim. `.expect(1)` on the 429 mock is a real drop-time guard: if the
   ordering assumption were wrong and 200 served first, the test fails loudly
   rather than passing falsely. Correct and self-guarding.

2. `test_bc_3_9_001_rate_limit_retry_after_at_cap_proceeds` — delay==60:
   original `60 > 60` false → sleeps 60s; spawned task + `timeout(5s)` →
   `result.is_err()` (Elapsed) passes. `>=` mutant aborts immediately → task
   resolves fast → `timeout` returns `Ok(...)` → `result.is_err()` false →
   assertion fails → mutant killed. Pins "delay==cap proceeds" exactly. 5s wait
   has a 55s margin vs the 60s sleep — not flaky. `start_paused`/wiremock note
   is accurate.

3. `test_bc_3_9_001_rate_limit_retry_after_above_cap_aborts` — delay==61:
   original `61 > 60` true → abort → exit 1; `==` mutant `61 == 60` false →
   sleeps 61s → 15s subprocess timeout → exit code `None` → `assert_eq(Some(1))`
   fails → mutant killed. stderr assertion matches the source message verbatim
   and reaches stderr in JSON mode. `.expect(1)` pins no-retry-after-abort.
   Correct.

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| suggestion | coherence | Test 1's rustdoc says "Wiremock priority: most-recently-registered-wins — register 200 first, 429 second", which contradicts the actual code (429 is registered **first**) and the test's own inline comment + commit message ("first-registered wins"). | Fix the rustdoc sentence to match the code (429 registered first, first-registered-wins). Non-blocking — the test behaves correctly regardless because the `.expect(1)` guard enforces the 429 path. |

## Conclusion

No BLOCKING findings. The three tests are well-formed, correctly pin the claimed
boundary behaviors (delay==cap proceeds, delay>cap aborts), reuse proven
patterns already established in this file and `rate_limit_cap_tests.rs`, and
honestly document the equivalent-mutant limitation rather than overstating
coverage. One non-blocking documentation inconsistency noted above.

**covered_sha: ae347e0c1b2b6bc537d6205be282023c04dde00e**

---

## Cycle-1 review (retained for history) — covered_sha `b5977e5e`

Reviewed as a fresh-eyes reviewer against the diff, PR description, and demo
evidence. All five requested focus areas verified against the actual code:
(1) confirmation gate uses `eprint!` not `dialoguer`; (2) DELETE loop treats 404
as benign skip and aborts on non-404; (3) `--dry-run` suppresses the gate but not
file pre-checks; (4) `X-Atlassian-Token: no-check` on every upload request;
(5) no blocking spec violations. Non-blocking suggestions: 401 auto-refresh
bypass (documented, ADR-0017 multipart constraint) and benign-404 substring
match (DEC-168). APPROVED.
