# S-576-3 Step 4.5 Adversarial Convergence — 7 Passes

**Story:** S-576-3 (`jr issue attachment upload`)
**Bundle:** SOH-ATTACHMENTS-1
**Criterion:** STRICT
**Date converged:** 2026-07-20
**Window:** p5 CLEAN / p6 CLEAN / p7 CLEAN
**Passes:** 7 / Fix rounds: 4 / Human overrides: 0

---

## Trajectory

`p1 FINDINGS(4M/3L) → p2 FINDINGS(1H/2M) → p3 FINDINGS(1M/1L/P3-003-DEFERRED) → p4 FINDINGS(2M/kill-test) → p5 CLEAN(1/3) → p6 CLEAN(2/3,d15b7192) → p7 CLEAN(3/3 CONVERGED)`

---

## Pass-by-Pass Narrative

### Pass 1 — FINDINGS (4M / 3L)

**P1-001 (MEDIUM):** Gate-prompt canon mismatch. The `--replace-existing` confirmation gate prompt wording diverged from the BC-3.9.014 canonical form. The test had been pinned to the wrong prompt string and would have passed a non-conformant implementation.

**P1-002 (MEDIUM):** Not-a-regular-file branch absent. The `is_file()` pre-flight check (BC-3.9.001 FILE-not-found guard) did not distinguish between a missing file and a non-regular-file input (e.g., a directory passed as FILE). The branch was unexercised and code behavior for that input was undefined.

**P1-003 (MEDIUM):** Tautological CWE-93 test. `test_sec_576_004_content_disposition_crlf_injection_guard` asserted percent-encoding presence in a way that would pass even if raw CRLF passed through; the assertion was not strong enough to demonstrate the invariant it claimed to pin.

**P1-004 (MEDIUM):** Doc 401-exit discrepancy. Inline rustdoc on a handler function described exit-code behavior as exit 1 for 401, but BC-3.9.012 taxonomy mandates exit 2 for 401 (not-authenticated class).

**3L:** Stale comments in adjacent helpers; story count nits.

**Fix round 1:** Gate-prompt string corrected to BC-3.9.014 canonical form; `is_file()` branch added with distinct "not a regular file" error path and canonical message; CWE-93 test assertion hardened; rustdoc corrected to exit 2; 3L nits resolved.

---

### Pass 2 — FINDINGS (1H / 2M)

**P2-003 (HIGH — real destructive-path bug):** DELETE-404 abort-instead-of-benign-skip. When `--replace-existing` step 1 found a match and issued DELETE but received 404 (race condition: the attachment was deleted between the list-step and the delete-step), the handler aborted the entire upload with an error. BC-3.9.017 specifies 404 on the delete step is **BENIGN** and must be treated as a skip — the attachment is already gone; proceed with POST. This was a real correctness bug on a destructive code path: a 404 race window caused the upload to silently fail when it should have succeeded.

**P2-001 (MEDIUM):** Quote-vector coverage gap. A double-quote (`"`) in a filename was not covered by the CWE-93/RFC-7230 injection tests. reqwest percent-encodes it correctly, but no regression pin existed to prevent a future regression from un-doing the encoding.

**P2-002 (MEDIUM):** Story `allow_hyphen_values` error at 3 live sites. Story AC-001, Task 5, and the File Structure row each described `allow_hyphen_values = true` on the `<FILE...>` positional, but the shipped code (correctly) omits it. On a multi-value positional, setting `allow_hyphen_values = true` causes clap to consume subsequent flags (e.g., `--output json`) as file path arguments. The story was documenting incorrect behavior as correct.

**Fix round 2:** DELETE-404 treated as benign skip instead of abort (P2-003); regression pin test added (`test_bc_3_9_017_delete_404_is_benign_skip`); double-quote vector test added (`test_ac_018_double_quote_filename_well_formed_content_disposition`, `#[cfg(unix)]`) (P2-001); story corrected at 3 sites to document `allow_hyphen_values` intentionally ABSENT with full rationale (P2-002). Count 20→22. Story v1.43/v1.44.

---

### Pass 3 — FINDINGS (1M / 1L / P3-003 DEFERRED)

**P3-001 (MEDIUM):** Count/enumeration drift. Story test-count references in 6 locations (Token Budget ~548, budget note ~555, Task 2 body ~571, AC-006 test list, AC-018 test list, File Structure ~663) still showed the pre-fix-round-2 count of 20 after the worktree had 22 tests. The story understated coverage and would mislead implementers resuming from the story spec.

**1L:** Stale rustdoc on an attachment API helper that referenced an old parameter name after the `is_file()` branch refactor in fix-round-1.

**P3-003 (observation, DEFERRED to wave gate):** The upload multipart path bypasses `JiraClient::send()` (uses `reqwest::Client::execute` directly for streaming efficiency), so the OAuth blanket-401 auto-refresh mechanism (S-3.03) does not apply to `attachment upload`. BC-3.9.012 specifies 401→exit-2, which is spec-sanctioned. Adversary flagged it as a wave-gate ruling candidate: the gate should rule whether to implement a refresh-rebuild path (complex: must reconstruct multipart stream post-refresh) or to document this as a known limitation.

**Fix round 3:** Count sync 20→22 at 6 story sites (P3-001); stale rustdoc corrected (1L). P3-003 DEFERRED to wave gate — BC ruling already covers the observed behavior; not story-blocking. Story v1.44.

---

### Pass 4 — FINDINGS (2M) — kill-test round

**P4-001 (MEDIUM):** Rustdoc taxonomy imprecision. Inline rustdoc on the attachment delete API helper described error-return semantics using internal enum names rather than the user-visible exit codes from BC-3.9.012 taxonomy. A code reader consulting the rustdoc to understand the contract would see inaccurate information.

**P4-002 (MEDIUM):** Non-404 DELETE coverage gap / mutation survivors. The kill-test round (mutation pre-empt, applied before CI per S2 process lesson) identified 4 surviving mutations:
1. DELETE-403 abort-vs-skip distinguisher absent — a 403 on the delete step must abort (unlike 404 which skips); mutation swapping the 403 path to skip-not-abort survived.
2. Table dry-run exact-string pins absent — mutation on the output format string survived (discriminated only by presence of specific key strings).
3. Uppercase-Y gate acceptance absent — the gate must accept both `"y"` and `"Y"` via `eq_ignore_ascii_case`; mutation making the check case-sensitive survived.
4. Persistent-429 exhaustion absent — BC-3.9.012 terminal-failure taxonomy row; mutation that skipped the retry loop survived.

**Fix round 4:** Rustdoc corrected to exit-code vocabulary per BC-3.9.012 (P4-001); 4 mutation-kill integration tests added:
- `test_bc_3_9_017_delete_403_aborts_flow` — DELETE 403 is non-benign and MUST abort
- `test_bc_3_9_020_dry_run_table_output_strings` — exact-string pins for table dry-run arm
- `test_bc_3_9_014_gate_confirm_uppercase_y_proceeds` — gate accepts uppercase "Y"
- `test_bc_3_9_001_persistent_429_exhausts_retries` — persistent 429 exhausts retries and exits 1

Count 22→26. Story v1.45.

---

### Pass 5 — CLEAN (window 1/3)

No findings of any severity. Adversary independently verified: all 26 integration tests present, clippy clean, fmt clean, deny clean, BC-3.9.014 gate-prompt canon confirmed, DELETE-404 benign-skip path (P2-003 regression pin present), double-quote percent-encoding pin (`#[cfg(unix)]`), `allow_hyphen_values` story correction at all 3 sites, count sync confirmed at 6 locations (20→22→26), 4 mutation-kill pins each exercising correct boundary conditions. Window starts (1/3).

---

### Pass 6 — CLEAN (window 2/3)

No actionable findings within S-576-3 implementation scope. One out-of-perimeter informational note: a doc comment in an adjacent module (not within S-576-3 implementation files) referenced a stale parameter name. Adversary flagged it as informational; orchestrator authorized a targeted one-liner fix (commit `d15b7192`) without resetting the window per out-of-perimeter precedent. All behavioral surfaces clean. Window continues (2/3).

---

### Pass 7 — CLEAN (window 3/3 — STRICT CONVERGED)

No findings of any severity. Adversary verified: 26 integration tests confirmed present and green, `d15b7192` out-of-perimeter fix confirmed clean, BC-3.9.017 non-atomicity disposition verified as spec-sanctioned, double-quote Content-Disposition neutralization BC ruling verified (reqwest RFC-7230 percent-encoding; `#[cfg(unix)]` pin present and correctly scoped), all 4 mutation-kill pins exercising correct boundary conditions, P3-003 wave-gate deferral documented correctly. Window complete (3/3). **STRICT CONVERGED**.

---

## Accepted Residuals

| ID | Severity | Description | Disposition |
|----|----------|-------------|-------------|
| P3-003-oauth-refresh-bypass | observation | Upload multipart path bypasses `JiraClient::send()` → S-3.03 blanket-401 auto-refresh does not apply to `attachment upload` | Wave-gate ruling pending: implement-refresh-rebuild vs document. BC-3.9.012 401→exit-2 spec-sanctioned. |
| delete-then-post-non-atomicity | LOW | Non-atomic race window for `--replace-existing`: new same-named attachment created between list and POST step is not deleted | BC-3.9.017-sanctioned. No action at S-576-3. |
| double-quote-content-disposition-unix-only | LOW | Double-quote regression pin is `#[cfg(unix)]` only; reqwest percent-encoding covers all platforms | Accepted — BC ruling verified; noted in AC-018. |

---

## Process Note

Mutation pre-empt kill-round (P4-002 + persistent-429 + table dry-run) applied **before** CI this time, per S2 session lesson: run mutation pre-empt BEFORE pushing to save a CI round trip. First clean application of this process improvement.
