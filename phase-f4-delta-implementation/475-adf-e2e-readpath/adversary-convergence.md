---
document_type: per-story-adversary-convergence
story: S-475-adf-e2e-readpath
issue: "#475"
phase: F4-delta-implementation
verdict: CONVERGED
worktree_branch: test/issue-475-adf-e2e-readpath
commits: [d052264, ca07cbc]
rounds: 2
date: 2026-06-11
producer: vsdd-factory:adversary
traces_to: BC-5.39.001
---

# Per-Story Adversary Convergence — S-475 ADF E2E Read-Path

**Verdict: CONVERGED** (per-story Step-4.5, BC-5.39.001)
Worktree branch `test/issue-475-adf-e2e-readpath`, commits d052264 + ca07cbc.

---

## Round 1 — Findings

### F-1 (HIGH) — Async test silently escaped gate-guard meta-test

The new E2E test `test_e2e_adf_read_path_produces_correct_rendered_text` was written as:

```rust
#[tokio::test]
async fn test_e2e_adf_read_path_produces_correct_rendered_text() {
```

Zero `.await` expressions existed in the body. The test functioned correctly at
runtime (the async executor ran it as a sync task), but it silently escaped the
`test_every_ignored_test_has_gate_guard` meta-guard in `tests/e2e_cli_surface_guard.rs`.

**Root cause:** The guard matched lines containing `fn test_` only (via string
search pattern `fn test_`). An `async fn test_` line does NOT match that pattern,
so the meta-guard never saw the new test and reported a false-green PASS.

**Impact:** The gating invariant — every `#[ignore]`-annotated test must have a
corresponding `if !e2e_enabled() { return; }` guard call — was enforced for sync
tests but silently bypassed for async tests. A future async test added without the
gate guard would have passed the meta-test while being ungated, risking live-Jira
side effects in unguarded CI runs.

**Fix (ca07cbc):** De-asynced the test to `#[test] fn` (root-cause fix — no
`.await` existed, so `async` was incorrect and unnecessary). This restores correct
meta-guard coverage without requiring guard-pattern changes.

### F-1b (LOW [process-gap]) — Gate-guard meta-test blind to `async fn` signatures

Even after the root fix (de-async), the meta-guard pattern `fn test_` would remain
blind to any future `async fn test_` test. This is a process-gap — the guard's own
pattern excludes a valid Rust construct.

**Fix (ca07cbc, hardening):** Guard hardened to strip a leading `async ` prefix
before pattern matching (lines ~1207/1219 in `tests/e2e_cli_surface_guard.rs`). A
future legitimate `async fn test_` test will now be recognized by the meta-guard.

---

## Round 2 — Three Consecutive Clean Passes (Fresh Context)

| Pass | Findings | Notes |
|------|----------|-------|
| Pass 1 | 0 | Full diff reviewed; both fixes verified real with no regression |
| Pass 2 | 0 | Correctness sweep: AC mappings, assertion strategy, gating, teardown |
| Pass 3 | 0 | Final confirmation — no new findings |

### Correctness Sweep — All items verified clean

- **AC-1** single-token assertions (Header/snippet/blockquote/link) map correctly to
  real `adf_to_text` rendering — verified against `src/adf.rs` output contracts.
- **AC-3** discriminator — `**body**` / `*emphasis*` / `!_emphasis_` are load-bearing
  expected strings and correctly test the apply_marks path at `src/adf.rs:2255–2256`.
- **`adf_has_blockquote_in_list_item` helper** — correct direct-child detection,
  panic-safe on missing or unexpected node shapes.
- **Fixture** parses to the asserted constructs (verified via ADF shape inspection).
- **`--description-stdin`** used correctly for leading-dash input.
- **Gating** correct — `if !e2e_enabled() { return; }` present, `#[ignore]` annotated.
- **No exact ADF-tree equality** — structural/rendered assertions only (per spec
  v1.3.9 mandate; avoids Jira server-side ADF rewrite fragility).
- **Teardown** — test issue labeled + `best_effort_close` called correctly.
- **Rename** complete at both touch-points (test fn name + SURFACE guard registration).
- **SURFACE guard** unaffected — no missing or spurious entries.

---

## Non-Blocking Observations

### OBS-1 (LOW) — comfy-table word-wrap (pre-existing class)

Single-token assertion strategy (mandated by O1-TABLE-ASSERT drift item from F3)
correctly mitigates this class. No action required this cycle.

### OBS-2 (LOW [process-gap]) — `pub async fn` not recognized by hardened guard

The hardened guard strips `async ` prefix for bare `async fn test_` but does not
handle `pub async fn test_`. No such tests exist in the codebase; this is a
pre-existing potential gap, not introduced by this story. Added to meta-guard
future-hardening backlog. No action required this cycle.

---

## Orchestrator Hardening-Gate Results

| Gate | Result |
|------|--------|
| `cargo test` full suite | ALL CLEAN — 0 failures |
| `cargo deny check` advisories | OK |
| `cargo deny check` bans | OK |
| `cargo deny check` licenses | OK |
| `cargo deny check` sources | OK |
| `cargo clippy -- -D warnings` | CLEAN |
| `cargo fmt --all -- --check` | CLEAN |
| `cargo build` | CLEAN |
| F5 (adversarial refinement) | SATISFIED — per-story 3-clean-pass review on full diff |
| F6 (fuzz/mutation) | N/A — test-only story, no production code changed |

**Demo justification:** adapted-skip (same handling as prior test-only E2E cycles
#493/#495). Test-only story with NO production behavior change. Evidence: offline
hermetic verification (compile + gate guards + full suite green + `--list`) and
nightly `e2e.yml` live run.
