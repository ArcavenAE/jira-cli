# PR #620 Review — `jr issue comment edit --internal/--public` (S-577-5)

## VERDICT: APPROVE

No blocking findings. The visibility pipeline is correct, the confirmation-gate
mechanism matches the documented DEC-174 constraint exactly, and the test suite
genuinely exercises every claimed behavior at the wire and exit-code level. Two
non-blocking suggestions below.

Reviewed as a fresh-eyes reviewer against the diff `a486f79...HEAD`, PR
description, and test evidence only.

---

## Checklist — all verified

1. **Visibility pipeline correctness** — `visibility_flag` maps `--internal → Some(true)`,
   `--public → Some(false)`, neither `→ None`, threaded into
   `update_comment(&key, &id, adf_body, visibility_flag)`. Wire-body tests
   (AC-001/003) confirm exact top-level key-set `{"body","properties"}` with
   `properties[0] = {"key":"sd.public.comment","value":{"internal":<bool>}}` and no
   `"visibility"` key. Correct.
2. **Confirmation gate tests `no_input` ALONE** — gate uses `if no_input && !yes` /
   `else if !yes`; no `is_terminal()` or `refuse_noninteractive(...)` in the handler.
   The `--stdin`-implies-`no_input` mutation is flag-based and TTY-agnostic, avoiding a
   double-read of already-consumed stdin. AC-009 proves TTY-agnosticism via the
   `JR_STDIN_IS_TTY=1` seam. Matches Architecture Compliance Rule 8.
3. **EOF/io::Error → exit 130** — `Ok(0) | Err(_) => JrError::Interrupted`, distinct from
   cancel path. AC-012 pins exit 130. Correct.
4. **Cancel envelope** — exactly `{"cancelled": true, "updated": false}` via `render_json`,
   `updated` a boolean literal `false`, no `id`/`key` leaked. AC-008 asserts the exact
   2-key set and boolean types. Correct.
5. **`--yes` lacks `requires("public")`** — destructure just binds `yes`; AC-010 (both
   variants) proves `--yes` alone is a silent no-op (exit 0) and that empty-body still
   yields exit 64 (handler guard) not exit 2 (clap `requires`). Correct per DEC-169.
6. **JSDCLOUD-6050 hint stderr-only** — `eprintln!`, fires after ADF success and before
   PUT, on both `--internal` and `--public`; not on cancel (returns earlier) or ADF
   failure. AC-005/006 confirm the substring on stderr even under `--output json`. Correct.
7. **Test quality (`tests/comment_edit.rs`, 13 tests)** — high quality. Inspect actual
   mock request bodies, assert exact JSON key-sets with `BTreeSet`, distinguish boolean
   `false` from missing/null/`"false"`, use `.expect(0)`/`.expect(1)` to assert whether
   the PUT fired. Dual-pin stderr assertions (AC-007) prove the exit originates from the
   step-3b gate, not the body gate. Tests exercise behaviors, not proxies.
8. **E2E test (`tests/e2e_live.rs`)** — properly gated: `#[ignore]`, `if !e2e_enabled()
   { return; }`, `JR_E2E_JSM_PROJECT` check with clean `[SKIP]`. Uses a pre-existing
   issue as shared fixture (not closed), best-effort teardown with `[WARN]`, retry/poll
   for property lag, and anti-vacuous-pass guards (asserts round-trip visibility on
   read-back before testing preservation). Three scenarios (MERGE stability,
   PRESERVED-visibility baseline, orthogonal compound cell) match spec. Consistent with
   repo conventions.
9. **CLAUDE.md MERGE gotcha** — accurate. `None`/`Some(true)`/`Some(false)` semantics match
   the handler's `visibility_flag` derivation and the wire shape proven by tests; e2e
   citation resolves to a real function.
10. **Security / write-path design** — sound. Confirmation gate guards only the risky
    direction (`--public`, making customer-visible); `--internal` needs none. `--yes`
    bypass is meaningful only with `--public`, no-op otherwise. MERGE avoids clobbering
    unrelated properties. No new attack surface. Consistent with SEC-577-001 / DEC-169.

Diff size (1787 insertions) is dominated by tests (973) + e2e (637); source change is
184 LOC. Appropriate for the feature; not a concern.

---

## Findings

### SUGGESTION — test-coverage — interactions.rs (interactive accept path)
The interactive *accept* path is not covered. AC-003/006 use `--yes` (bypass), AC-008
tests cancel (`N`), AC-012 tests EOF — but no test drives the branch where a user types
`y`/`yes` at the interactive prompt and the code falls through to the PUT. The
`answer == "y" || answer == "yes"` acceptance arm is unexercised; a mutation flipping
that comparison would likely survive. Recommend adding one test (`JR_STDIN_IS_TTY=1`,
`write_stdin("y\n")`, `--public`, assert `.expect(1)` PUT fired + exit 0 +
`(marked public)` on stderr).

### NIT — ux — interactions.rs (table-mode cancel)
On interactive cancel in *table* mode the `OutputFormat::Table => {}` arm prints nothing
to stdout or stderr, so the user gets a silent exit 0 after answering `N`. The `[y/N]`
prompt on stderr makes intent reasonably clear, but a one-line `eprintln!("Cancelled.")`
would confirm the no-op. Fix if convenient.

---

## Summary

Clean, well-scoped implementation (184 LOC source, rest tests/e2e/docs). The `--public`
confirmation gate faithfully implements the DEC-174 manual `eprint! + read_line`
mechanism, correctly gates on `no_input` alone, distinguishes cancel (exit 0, 2-key
envelope) from interrupt (exit 130), and the JSDCLOUD-6050 hint is stderr-only. Tests
inspect real wire bodies and exact JSON key-sets rather than proxies, and the e2e probe
is properly gated with anti-vacuous-pass guards. One test-coverage gap (interactive
`y`-accept path) and one minor UX nit; neither blocks merge.
