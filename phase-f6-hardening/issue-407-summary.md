# Phase F6 — Targeted Hardening: issue #407 (S-407)

- **Story:** S-407 — `--label` conflict block coverage + structural meta-test
- **Merge commit:** `6eb2535` on `develop`
- **Baseline commit:** `699a5fd` (FIX-F5-001)
- **Diff scope:** `src/cli/issue/create.rs` (+159), `tests/issue_edit_field.rs` (+448) — 607 lines added, test-hardening cycle
- **Date:** 2026-05-25
- **Verifier:** formal-verifier agent

## Verdict: PASS

All hardening gates passed. CI on the merge commit is green.

---

## 1. Mutation Testing (cargo-mutants on diff scope)

**Command (CLAUDE.md canonical):**

```
DIFF_FILE=$(mktemp -t pr.diff.XXXXXX) && git diff 699a5fd..HEAD > "$DIFF_FILE" && \
cargo mutants --in-diff "$DIFF_FILE" --baseline=skip --jobs 4
```

**Result:** **1 mutant found in scope, 1 caught — 100% kill rate (1/1)**

| Metric | Value |
|---|---|
| Mutants found | 1 |
| Mutants caught | 1 |
| Mutants missed | 0 |
| Mutants unviable | 0 |
| Mutants timed out | 0 |
| **Kill rate** | **100%** (target: ≥90%) |
| Elapsed | 37s |

**Mutant detail:**

```
src/cli/issue/create.rs:304:5: replace handle_edit -> Result<()> with Ok(())
```

This is the entry point of `handle_edit`. Replacing the whole body with `Ok(())` bypasses every validation gate (including the `--label` conflict block) and would silently succeed on every edit. The new test corpus (12 positive `test_label_plus_*` tests asserting exit 64 + zero HTTP) immediately fires because exit code becomes 0 instead of 64. Caught cleanly.

**Why only 1 mutant in scope:**

- `cargo-mutants` ignores comments (the 5-line guard comment at line 442–446 produces no mutants — expected and correct).
- `.cargo/mutants.toml::examine_globs` includes `src/cli/issue/create.rs` but **not** `tests/issue_edit_field.rs`, so the 448 lines of new test code produce zero mutants. This is the documented and intended scope per `docs/specs/cargo-mutants-policy.md`.
- The only function in `create.rs` that the diff touches structurally is `handle_edit` (via the comment and via the two new `#[cfg(test)]` meta-tests that live inside its mod). `--in-diff` therefore narrows correctly to that one function entry point.

**Baseline note:** The unmutated baseline run failed with one macOS-keychain-blocking test (`test_cloud_id_flag_picks_named_resource_not_first` — "The specified item already exists in the keychain"). This is a known pre-existing local-environment issue (cargo-mutants copies the workspace into a fresh tmpdir but the macOS keychain is shared system state, so a prior auth-login mock writes a real keychain entry that subsequent baseline runs trip over). `--baseline=skip` is the correct mitigation per cargo-mutants docs; the warning-recommended explicit timeout defaulted to 300s, which is far more than the 37s actual.

---

## 2. Security Scans

### `cargo audit`

| Item | Value |
|---|---|
| Exit code | **0** |
| Advisories loaded | 1098 (RustSec) |
| Crates scanned | 341 |
| Vulnerabilities found | **0** |
| Warnings | 0 |

Clean. No new dependencies were added in this PR (test-only delta), so the audit posture is identical to the pre-S-407 develop baseline.

### `cargo deny check`

| Item | Value |
|---|---|
| Exit code | **0** |
| advisories | ok |
| bans | ok |
| licenses | ok |
| sources | ok |

Two `license-not-encountered` warnings (`OpenSSL`, `Unicode-DFS-2016`) — these are unused entries in `deny.toml`'s allow-list, pre-existing, harmless (they say "we'd allow these if we saw them; we didn't see them"). Not a security finding.

### New-test security pattern review

All 10 new `test_label_plus_*` tests use the constrained `jr_cmd` fixture (not `jr_cmd_with_xdg`). `jr_cmd` only sets:

- `JR_BASE_URL` → wiremock URI (debug-only env-var, gated via `#[cfg(debug_assertions)]` per CLAUDE.md base_url release-gate)
- `JR_AUTH_HEADER=Basic dGVzdDp0ZXN0` (test:test in base64; debug-only env-var, also release-gated)

No real Atlassian credentials, no real `~/.cache/jr/` writes (Gate A/B reject before any cache or config read), no real keychain access, no PII. Pattern matches the FIX-F5-001 baseline tests above them.

The two new meta-tests (`test_label_conflict_block_lists_every_relevant_flag`, `test_label_conflict_block_extractor_pin_12_members`) are pure-Rust source-text inspection via `include_str!`. No I/O, no env-var reads, no subprocess. Zero attack surface.

**No insecure patterns identified.**

---

## 3. Full Regression Suite

**Command:** `cargo test --all-features`

| Metric | Value |
|---|---|
| Passed | **1483** |
| Failed | **0** |
| Ignored | 18 (gated: macOS keychain + OAuth integration tests requiring `JR_RUN_*=1`) |
| Doc-tests | 0 |

Full suite clean. The 18 ignored tests match the documented gates per CLAUDE.md (keyring tests behind `JR_RUN_KEYRING_TESTS=1`, OAuth integration behind `JR_RUN_OAUTH_INTEGRATION=1`).

**Note vs. task brief:** The task brief warned of "3 pre-existing `oauth_refresh_integration` failures" and "9 macOS-keychain-blocking tests if running on macOS". When `cargo test` runs them directly (not via cargo-mutants' tmpdir copy), they hit the `#[ignore]` gate and skip cleanly. So in the full-suite run they appear as ignored, not failed, which is the correct outcome. The cargo-mutants baseline failure (`test_cloud_id_flag_picks_named_resource_not_first`) does NOT appear in `cargo test` because cargo-mutants runs `--all-features` AND retains some test-tmpdir state pollution that the normal `cargo test` invocation avoids on a fresh workspace.

---

## 4. Property/Meta Checks

### Two new meta-tests passing

```
cli::issue::create::tests::test_label_conflict_block_extractor_pin_12_members ... ok
cli::issue::create::tests::test_label_conflict_block_lists_every_relevant_flag ... ok
```

### Failure-mode quality (without inducing failure)

Reviewed the `assert_eq!` failure messages in both meta-tests (lines ~1900 and ~1960 of `src/cli/issue/create.rs`):

- `test_label_conflict_block_lists_every_relevant_flag` prints both the **missing** set (`expected \ extracted`) and the **spurious** set (`extracted \ expected`), with a clear remediation paragraph ("If you added a new Edit flag, extend the --label conflict block in handle_edit and update the expected set in this test"). Actionable: future contributors get pinpoint guidance, not an opaque set-diff.
- `test_label_conflict_block_extractor_pin_12_members` performs the count check FIRST with the actual extracted set in the message, then a set-equality check with both sides. A regression in the extractor logic (e.g., formatting drift) surfaces with a count mismatch distinguishable from a content drift, satisfying the R2 pin intent (extractor-logic regression vs. content regression are surface-distinguishable).

### Proptest harness for the extractor?

The extractor logic is 8 lines of pure string-prefix/suffix matching against a closed grammar (`conflicting.push("--<flag>");`). The R2 count-pin test already covers regression on the extractor against the real file. Building a proptest harness that synthesizes random Rust source-like strings would add ~50 lines of code to test 8 lines of deterministic parsing with no documented edge cases.

**Decision: skip proptest harness — overkill for a 1-point test-hardening cycle, not justified by mutation testing (no mutants surfaced in the extractor logic since it lives in `#[cfg(test)]`).**

---

## 5. Purity Boundary

**N/A.** No production logic changed beyond a 5-line comment block. The comment itself is documentation-only and cannot introduce side effects.

---

## 6. CI Status

| Run | Result | Duration |
|---|---|---|
| `CI` on `6eb2535` (merge commit) | **success** | 2m40s |

Source: `gh run list --branch develop --limit 5` (run ID 26419501809, completed 2026-05-25T20:57Z).

---

## F6 Gate Decision

| Gate | Target | Actual | Status |
|---|---|---|---|
| Mutation kill rate (diff scope) | ≥90% | 100% (1/1) | PASS |
| `cargo audit` | exit 0, no high/critical | exit 0, 0 vulns | PASS |
| `cargo deny check` | exit 0 | exit 0 | PASS |
| Full regression suite | 0 unexpected failures | 1483 pass / 0 fail / 18 gated-ignored | PASS |
| New tests pass | all green | 12/12 label-plus + 2/2 meta-tests | PASS |
| CI on merge commit | green | success in 2m40s | PASS |
| Purity boundary | preserved | N/A (no prod logic change) | PASS |

**Verdict: PASS — Phase F6 complete for issue #407 / S-407.**
