# PR #702 — Fresh-Eyes PR Review

**Verdict:** APPROVE (clean; two informational nits, zero blocking/suggestion findings)
**Reviewed SHA (`covered_sha`):** `c0fa930c` (`c0fa930cd4ac8039e6945cac217c8200bff01a5a`)
**Base:** `develop` · **Head branch:** `test/mutants-scope-queue-main`
**CI:** 15/15 checks pass (CI Gate, Clippy ubuntu+windows, MSRV 1.85.0, Mutation testing, Test macos/ubuntu/windows, Deny, Spec Guards, etc.)

One-line rationale: A behavior-preserving refactor with genuine new coverage, a fully debug+unix-gated test seam that cannot reach a shipped binary, correct dev-dependency placement, and accurate docs — every merge-critical concern checks out.

---

## Checklist Assessment

### 1. Diff coherence / intent match — PASS
Every hunk maps to the stated intent, no scope creep:
- `.cargo/mutants.toml` `examine_globs` 16 → 18 (`src/cli/queue.rs`, `src/main.rs`), each with inline HIGH-value rationale.
- `src/main.rs`: extracts `run_until_shutdown<W,S,T>(work, shutdown) -> RunOutcome<T>`; adds `#[cfg(all(debug_assertions, unix))]` readiness seam + inline `#[cfg(test)] mod tests`.
- `tests/interrupt_signal.rs` (new): real-SIGINT subprocess test.
- `tests/jr_test_block_until_sigint_release_gate.rs` (new): release-gate pin.
- `docs/specs/cargo-mutants-policy.md`: 2 new + 5 backfilled §Scope bullets, count 16→18, Changelog row.
- `CLAUDE.md`: `JR_TEST_BLOCK_UNTIL_SIGINT` seam bullet.
- `Cargo.toml`/`Cargo.lock`: `libc` promoted to explicit edge; zero new crates.
- `src/cli/queue.rs` genuinely untouched (scope-only, AC-012).

### 2. Behavior preservation (BC-X.3.006) — PASS (verified equivalent)
- Original: `select!{ result = main_task => result, _ = ctrl_c() => { eprintln!("\nInterrupted"); exit(130) } }`.
- New production path (`test_seam_active == false`): `work = Box::pin(main_task)`, `shutdown = async { let _ = ctrl_c().await; }`, then `match … { Completed(result) => result, Interrupted => { eprintln!("\nInterrupted"); exit(130) } }`.
- Original discarded ctrl_c's `io::Result` via `_`; new `let _ = …await` fires identically on Ok/Err. `eprintln!` + `exit(130)` stay at the `run()` boundary byte-for-byte. Result propagation unchanged.
- Subprocess test asserts real exit `130` and byte-exact `"\nInterrupted\n"`; Mutation CI (green) confirms the `130` literal and `eprintln!` deletion mutants are killable.

### 3. Release-build safety of the debug seam — PASS
Seam fn `block_until_sigint_test_seam`, the env read, and the seam-selecting `shutdown` branch are all `#[cfg(all(debug_assertions, unix))]`. The `#[cfg(not(...))]` arm hard-binds `test_seam_active = false` and uses plain `ctrl_c()` with no reference to the seam fn. Release/non-unix compile the seam out entirely. Windows clippy + MSRV green confirm no dead-code / `-D warnings` fallout (subprocess test kept fully inline to avoid the round-15 Windows dead-code trap).

### 4. Test quality — PASS (meaningful, non-tautological; gate effective)
- Inline `mod tests`: injects `ready`/`pending`, asserts both `RunOutcome` arms — kills an "always Completed" mutant.
- Subprocess test: readiness handshake (polls `JR-TEST-READY`, no fixed sleep) then real `libc::kill(SIGINT)`, asserting real child exit code + stderr; bounded timeouts prevent suite hangs.
- Release gate: locates `std::env::var("JR_TEST_BLOCK_UNTIL_SIGINT")` and requires `debug_assertions` within the preceding 5 lines. Since the cfg is on the immediately-preceding line, removing the gate drops `debug_assertions` from the window → test fails. Genuinely catches an un-gated read.

### 5. Correctness / security / maintainability — PASS
- `unsafe libc::kill` is test-only; no unsafe added to `src/`.
- Non-`Send` boxed `work`/`shutdown` is fine — `run()` is `.await`ed as the root future, not spawned.
- `RunOutcome`/`run_until_shutdown` `pub(crate)` in the bin crate — no external surface.
- `libc` confirmed in `[dev-dependencies]` (Cargo.toml line 77, block starts line 48) and already a transitive normal dep on Unix → zero new crates, no `cargo deny` surface (Deny job green).
- Seam only activates under debug+unix+`=1`; cannot redirect auth/IO/config. Not security-sensitive.

### 6. Doc accuracy — PASS
CLAUDE.md seam bullet correctly describes the stricter `#[cfg(all(debug_assertions, unix))]` gate + release-gate pin; policy §Scope documents all 18 entries with correct count and dated Changelog row; queue.rs/main.rs function citations consistent with the diff (Spec Guards citation check green).

### 7. Demo evidence — PASS (appropriate for infra/CI story)
No user-facing surface; evidence is a text transcript driving the real binary + `cargo mutants` (3 caught / 0 missed / 4 unviable / 0 timeout, 100% over viable), the real terminal SIGINT demo (byte-exact stderr + exit 130), and per-guard output. Consistent with the S-693-1 precedent for infra stories.

### 8. Diff size / dependencies — PASS
+518 / −4, dominated by new test files and doc backfill. All upstream dependency PRs merged; `depends_on: []`.

---

## Findings

| Severity | Category | Finding | Suggestion |
|----------|----------|---------|------------|
| nit | maintainability | Production path now `Box::pin`s `main_task` (one heap allocation) to unify the two branch types. | Immaterial for a run-once CLI and necessary for the design — no action. |
| nit | coverage | Release-gate window heuristic could theoretically false-*pass* if `debug_assertions` appeared coincidentally within 5 lines. | Acceptable — reliably catches the failure that matters (no gate at all) and matches the established sibling-seam convention. No action. |

No blocking or suggestion-severity findings. Nothing rubber-stamped: the behavior-equivalence of the `select!` refactor, the release gating, the dev-dep section, and the CI matrix were each independently verified.

**READY. covered_sha = c0fa930c.**
