# S-MUTANTS-SCOPE-1 — Testing the `ctrl_c()` graceful-shutdown fork in `src/main.rs` for mutation coverage

**Story:** S-MUTANTS-SCOPE-1 (add `src/main.rs` to cargo-mutants `examine_globs`)
**Date:** 2026-08-14
**Author:** Research agent
**Status:** Complete — decision-oriented

---

## TL;DR recommendation

**Primary:** Write ONE `#[cfg(unix)]` subprocess integration test that spawns the compiled
`jr` binary, waits for a deterministic readiness signal, sends it `SIGINT`, and asserts
`exit code == 130` and `stderr == "\nInterrupted\n"`. This is the only test that actually
kills the load-bearing mutants on this block: the exit-code literal `130`, the
`eprintln!` deletion, and the `select!` arm behaviour. Deliver signal via `libc::kill`
(libc `0.2.183` is **already** in the dependency tree — CONFIRMED below) rather than
adding the `nix` crate.

**Secondary (recommended, not strictly required):** Extract the `select!` into a small
generic async fn taking an `impl Future` shutdown parameter, and add a portable
`#[tokio::test]` that injects a ready future. This gives deterministic, cross-platform
coverage of the *arm-selection* logic and shrinks the un-unit-testable surface in `main`.
It does **not** replace the subprocess test (see "Why refactor alone is insufficient").

**Skip-with-justification (`#[mutants::skip]`) is effectively OFF THE TABLE for this repo**
— the project's own policy doc explicitly lists "It's hard to test" as an *invalid*
justification and calls it "a refactoring opportunity" (`docs/specs/cargo-mutants-policy.md`
§Whitelist Convention, verbatim). CONFIRMED against the repo file.

---

## The code under test

`src/main.rs:415-421` (verified against the current file):

```rust
tokio::select! {
    result = main_task => result,
    _ = tokio::signal::ctrl_c() => {
        eprintln!("\nInterrupted");
        std::process::exit(130);
    }
}
```

### Mutants cargo-mutants will likely generate here (INFERRED from cargo-mutants' documented mutation model)
- Replace the exit-code literal `130` (e.g. with `0`, `1`, off-by-one).
- Delete `eprintln!("\nInterrupted")` (statement removal).
- Replace the `ctrl_c` arm body / swap arm behaviour.
- Replace the whole `select!` block's value / arm with `Default`-ish substitutes.

None of these are killed by any current test (the block has zero coverage), so absent new
tests they will **survive** and drag the PR-diff kill rate below the 90% floor. This is the
core problem the story must solve.

---

## Verified crate/tooling facts (checked against crates.io + this repo's Cargo.lock, 2026-08-14)

| Item | Finding | Source / confidence |
|------|---------|---------------------|
| `libc` | **`0.2.183` is ALREADY a resolved (transitive) dependency** in `Cargo.lock` (pulled in on Unix by tokio/reqwest). MSRV of libc 0.2 is far below 1.85. | `Cargo.lock` grep — CONFIRMED |
| `nix` | Latest stable **`0.31.3`**; stated MSRV **1.69** (comfortable headroom under repo MSRV 1.85). **NOT currently in the dependency tree** (`Cargo.lock` grep: no match) — adding it is a *new* dev-dependency + new transitive graph. | crates.io API — CONFIRMED |
| `rexpect` (PTY driver) | Latest **`0.7.1`**, published **2026-05-14**; stated MSRV **1.85.0 — exactly equal to the repo MSRV, zero headroom**. | crates.io API — CONFIRMED |
| `assert_cmd` | Repo dev-dep `= "2"`. API is **run-to-completion / request-response**: `assert()`, `output()` execute and wait; it does **not** expose a running `std::process::Child` or a mid-run signal-delivery API. Escape hatch = drop to raw `std::process::Command`. | docs.rs/assert_cmd + Perplexity reasoning — CONFIRMED (docs), the "no mid-run signal API" is confirmed by absence in the documented surface |
| Repo test patterns | `assert_cmd` already used for subprocess tests (`tests/cli_smoke.rs`); `#[cfg(unix)]` gating already an established pattern (`tests/ci_gate_completeness.rs`). | CLAUDE.md + task context — CONFIRMED |
| cargo-mutants CI | `mutants` job runs on **ubuntu-latest only**, on PRs, `--in-diff`. So a `#[cfg(unix)]` test **is present and executes during the mutation run** (Linux) — it will kill Unix-gated mutants. | `docs/specs/cargo-mutants-policy.md` §CI Integration — CONFIRMED |

---

## Task 1 — Idiomatic ways to test the fork

### Option A — Raw `std::process::Command` + signal delivery (RECOMMENDED for the real test)

Spawn the built binary, wait for readiness, signal it, collect output, assert. This is the
**common Unix integration-test idiom** for signal behaviour (CONFIRMED as the standard
pattern; Perplexity reasoning + std docs). Sketch:

```rust
#[cfg(unix)]
#[test]
fn test_ctrl_c_exits_130_and_prints_interrupted() {
    use std::process::{Command, Stdio};

    let mut child = Command::new(env!("CARGO_BIN_EXE_jr"))
        // pick a subcommand that blocks/runs long enough to receive the signal,
        // or a debug-only test seam that parks until signalled (see readiness note)
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("spawn jr");

    wait_until_ready(&mut child); // deterministic handshake — NOT a fixed sleep

    // libc is already in the tree; no new crate needed.
    unsafe { libc::kill(child.id() as libc::pid_t, libc::SIGINT); }

    let out = child.wait_with_output().expect("wait");
    assert_eq!(out.status.code(), Some(130));
    assert_eq!(String::from_utf8_lossy(&out.stderr), "\nInterrupted\n");
}
```

**Signal-delivery mechanism choice:**
- `libc::kill(pid, SIGINT)` — zero new dependency (libc already resolved). Requires adding
  `libc` as an explicit `[dev-dependencies]` entry, but adds **no new crate to the tree**.
  One `unsafe` block (acceptable in a test; CLAUDE.md's no-unsafe rule allows justified use).
- `nix::sys::signal::kill(Pid::from_raw(pid), Signal::SIGINT)` — safe wrapper, ergonomic,
  MSRV 1.69 (safe). Cost: a **new** dev-dependency + transitive graph. Prefer only if the
  team wants to avoid `unsafe` in tests.

**The critical race (must handle, else flaky):** `tokio::signal::ctrl_c()` only registers
its listener when first polled. If the test sends `SIGINT` before the child has polled the
`select!`, the default `SIGINT` disposition may terminate the process (exit ≠ 130) instead
of hitting the graceful branch. CONFIRMED behaviour (tokio signal docs + reasoning). Do
**not** use a fixed `sleep` — use a deterministic readiness handshake: a debug-only test
seam that prints a `READY` line to stdout after the `select!` is armed, or a readiness pipe.
This repo already has debug-only test seams (`JR_STDIN_IS_TTY`, etc.), so a
`#[cfg(debug_assertions)]` readiness marker is idiomatic here.

### Option B — `assert_cmd`

Great for the ordinary run-to-completion assertions this repo already does, but **cannot
send a mid-run signal** — no running-`Child` handle is exposed. CONFIRMED. Use `assert_cmd`
for everything else; drop to raw `std::process::Command` for this one test. (You may still
use `env!("CARGO_BIN_EXE_jr")` for binary discovery without `assert_cmd`.)

### Option C — `rexpect` / PTY drivers

**Overkill and higher-risk here.** rexpect `0.7.1` MSRV is **exactly 1.85** (zero headroom)
— a future rexpect patch could raise MSRV and silently break the repo's MSRV gate, the same
class of trap that bit `comfy-table` 7.2.2 (see Cargo.toml comment). A PTY is unnecessary:
the test needs to send a signal to a PID and read exit code + stderr, all of which raw
`Command` + `libc::kill` does without a pseudo-terminal. **Not recommended.**

### Option D — Refactor the `select!` into a unit-testable fn (RECOMMENDED as a complement)

Extract the decision from `main`, inject the shutdown future:

```rust
enum RunOutcome<T> { Completed(T), Interrupted }

async fn run_until_shutdown<W, S, T>(work: W, shutdown: S) -> RunOutcome<T>
where W: Future<Output = T>, S: Future<Output = ()> {
    tokio::pin!(work); tokio::pin!(shutdown);
    tokio::select! {
        v = &mut work => RunOutcome::Completed(v),
        _ = &mut shutdown => { eprintln!("\nInterrupted"); RunOutcome::Interrupted }
    }
}
```

Portable, deterministic unit test (runs on Windows too):

```rust
#[tokio::test]
async fn test_shutdown_branch_selected_when_shutdown_ready() {
    let outcome = run_until_shutdown(
        std::future::pending::<()>(),   // work never completes
        std::future::ready(()),         // shutdown fires immediately
    ).await;
    assert!(matches!(outcome, RunOutcome::Interrupted));
}
```

`#[tokio::test]` + `std::future::{ready, pending}` suffice; `tokio-test` is not required
(it's already an implicit capability via the `test-util` feature the repo enables). This
kills the "arm swapped / replaced with Completed" mutants deterministically and on every
platform. **`process::exit(130)` stays at the thin `main` boundary.**

---

## Why refactor alone is insufficient (the key nuance for this story)

Even after Option D, two mutants remain that the injected-future unit test does **not** kill:

1. **`eprintln!("\nInterrupted")` deletion** — a `#[tokio::test]` cannot easily assert on
   the child/test process's own stderr, so deleting the line survives the unit test.
2. **The `std::process::exit(130)` literal at the `main` boundary** — `main` is not
   unit-testable; mutating `130 → 0` survives any in-process test.

Both are only reliably killed by an **out-of-process** observation: spawn the binary, read
its real exit code and real stderr. That is exactly Option A. **Therefore the subprocess
test is load-bearing and cannot be replaced by the refactor.** The refactor is valuable for
determinism/portability of the arm logic and for shrinking `main`, but the story cannot rely
on it alone to hit 90% on the diff.

---

## Task 2 — Cross-platform caveat

`SIGINT` / `libc::kill` / `nix` are **Unix-only**; Windows has no POSIX `SIGINT` and no
equivalent `nix::Signal::SIGINT`. `tokio::signal::ctrl_c()` *itself* is portable (it maps to
Windows console `CTRL_C_EVENT`), but the *test mechanism* for delivering the interrupt is
not. CONFIRMED (tokio signal docs).

**`#[cfg(unix)]`-gating the SIGINT subprocess test is the accepted norm** and matches this
repo's existing convention (`tests/ci_gate_completeness.rs` already gates Unix-only
subprocess tests with `#[cfg(unix)]`; the round-15 CLAUDE.md history documents this pattern
and the Windows dead-code lint hazard of gating). CONFIRMED (Perplexity reasoning +
repo convention).

Recommended split:
- Portable injected-future unit test (Option D) → runs on **all** platforms.
- `#[cfg(unix)]` SIGINT subprocess test (Option A) → Linux/macOS only; **runs during the
  ubuntu-latest mutation job**, so it kills the Unix-gated mutants.
- Do **not** claim the Unix test proves Windows Ctrl+C behaviour. A Windows-specific
  Ctrl+C integration test is optional and out of scope unless Windows interrupt behaviour
  is a supported contract (it is not currently exercised anywhere).

**Windows dead-code lint hazard (repo-specific, IMPORTANT):** per CLAUDE.md round-15,
`#[cfg(unix)]`-gating a *test* does not remove the helpers only that test uses from a
Windows build — `-D warnings` on `clippy (windows-latest)` will hard-error on the orphaned
helpers. Any `#[cfg(unix)]`-only helper (e.g. `wait_until_ready`, a `libc` import) MUST also
be `#[cfg(unix)]`-gated. This is a known trap in this exact repo; flag it in the
implementation.

---

## Task 3 — How real Rust projects handle cargo-mutants against signal/exit/`#[tokio::main]` code

CONFIRMED from the cargo-mutants documentation (mutants.rs book) via Perplexity reasoning
with citations:

- **No automatic exemption.** cargo-mutants has **no** documented special rule skipping
  `std::process::exit`, `#[tokio::main]`, or signal handlers. Auto-exclusions are limited to
  tests, `#[cfg(test)]`, `unsafe` fns, and `#[mutants::skip]` items. (`mutants.rs/mutants.html`)
  So `main.rs`'s fork **will** be mutated once it's in `examine_globs`.
- **`std::process::exit` argument is mutable.** `skip_calls` exists specifically to suppress
  mutation of *arguments to named calls* (e.g. `skip_calls = ["exit"]`), but it does not skip
  the called body and matches on the final path component only (so `"exit"` is broad).
  (`mutants.rs/skip_calls.html`)
- **Documented triage order** (the maintained consensus, in priority):
  1. **Refactor to make behaviour testable** — inspect the missed mutant, add/tighten a test.
     For termination code the canonical pattern is exactly Option D: separate the *decision*
     (pure/injectable) from the *irreversible effect* (`exit`, signal registration, runtime
     bootstrap). (`mutants.rs/using-results.html`)
  2. **Explicitly skip genuinely untestable code** with `#[mutants::skip]` (function/expr) or
     `exclude_globs` (whole module), *with a visible justification comment*. Legitimate
     documented reasons: mutants hang tests, tested only via higher-level/manual means,
     hard-to-test side effects. (`mutants.rs/skip.html`, `mutants.rs/attrs.html`,
     `mutants.rs/skip_files.html`)
  3. **Accept survivors below threshold** is **not** the book's guidance — CI success is
     defined as "all viable mutants caught"; an accepted survivor should be represented as an
     explicit, reviewed skip/exclusion, not a silent threshold waiver.
     (`mutants.rs/exit-codes.html`)
- **No evidence** that exit/signal/`#[tokio::main]` mutants are *"commonly reported
  survivors"* as a named taxonomy — the docs acknowledge the general hard-to-test class but
  publish no prevalence statistic. (INFERRED-limits stated explicitly.)

**This repo is stricter than the upstream book.** `docs/specs/cargo-mutants-policy.md`
§Whitelist Convention lists, verbatim, as **invalid** justifications: *"Tests don't cover
this" — that is a gap to close, not a reason to skip* and *"It's hard to test" — that is a
refactoring opportunity, not a reason to skip.* Valid skips are limited to defensive-guard/
unreachable, performance-only, and debug-only-assertion categories. A `ctrl_c` fork does not
fit any valid category → **`#[mutants::skip]` for this block would violate the repo policy
and must be rejected in review.** CONFIRMED against the repo file.

Note the repo also treats **timeouts as survived** (policy §Timeout Semantics): a subprocess
SIGINT test that hangs would count against the kill rate, reinforcing the need for a
deterministic readiness handshake and a bounded child (Option A's `--timeout 240` ceiling
applies per mutant).

---

## Task 4 — Recommendation (decision)

**Primary: write the `#[cfg(unix)]` SIGINT subprocess test (Option A), signalling via
`libc::kill`.** Rationale:
- It is the **only** approach that kills the three real mutants on this block (exit-code
  `130`, `eprintln!` deletion, arm behaviour) by observing the *real* process's exit code and
  stderr — the refactor and any in-process test structurally cannot kill the `eprintln!` and
  `exit(130)` mutants.
- It runs on the ubuntu-latest mutation job, so it counts toward the PR-diff kill rate.
- Lowest *dependency* risk: `libc 0.2.183` is already resolved (no new crate); avoids
  `rexpect`'s zero-MSRV-headroom trap and avoids adding `nix`.
- Aligns with the repo's anti-skip policy (refactor/test, don't waive) and its existing
  `assert_cmd`-subprocess + `#[cfg(unix)]` conventions.
- Residual risk: the signal-registration race → mitigated with a `#[cfg(debug_assertions)]`
  readiness handshake (idiomatic in this repo), never a fixed sleep.

**Strongly recommended complement: refactor the `select!` into `run_until_shutdown` (Option
D) + a portable injected-future `#[tokio::test]`.** Rationale: deterministic, cross-platform
coverage of the arm-selection logic; shrinks the un-testable `main` boundary to just
`if Interrupted { exit(130) }`; directly satisfies the policy doc's "hard to test =
refactoring opportunity" stance. Keep `process::exit` at the outermost boundary so the core
fn never terminates the test harness.

**Fallbacks (in order):**
1. If the readiness race proves too flaky in CI, still keep Option D (portable unit test)
   AND move `eprintln!` into the extracted fn so at least the message/arm mutants die
   in-process; then the only residual mutant is the boundary `exit(130)` literal.
2. Only if a specific residual mutant is provably an equivalent/unreachable mutant may a
   `#[mutants::skip]` be added — and **only** with a justification that fits a *valid* repo
   category (defensive-guard/unreachable), reviewed as a code change. "Hard to test" is
   explicitly forbidden. Do not use `exclude_globs` to drop `main.rs` wholesale — that would
   defeat the entire purpose of this story (adding `main.rs` to scope).
3. `nix` (dev-dep, MSRV 1.69) is an acceptable substitute for `libc::kill` if the team
   prefers to avoid `unsafe` in tests — at the cost of a new dependency graph.

**Reject:** `rexpect`/PTY (unnecessary, MSRV-fragile); `assert_cmd` for the signal step (no
mid-run signal API); `#[mutants::skip]` justified as "hard to test" (policy-forbidden);
accept-baseline survivors (contradicts the 90% required gate and the story's intent).

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Attempted deep multi-source synthesis of the full question — **TIMED OUT after 300s** (see MCP note below); superseded by two focused `perplexity_reason` calls. |
| Perplexity perplexity_reason | 2 | (1) idiomatic tokio ctrl_c test options, signal delivery, `#[cfg(unix)]` gating norm; (2) cargo-mutants consensus on untestable signal/exit/`#[tokio::main]` code + `#[mutants::skip]`/`skip_calls`/`exclude_globs` docs. Both `search_context_size: high`, citations returned. |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily | 0 | — |
| WebFetch | 2 | crates.io API for `nix` (0.31.3, MSRV 1.69) and `rexpect` (0.7.1, MSRV 1.85, 2026-05-14) version+MSRV verification. |
| WebSearch | 0 | — |
| Read (local) | 3 | `Cargo.toml`, `src/main.rs` fork, `docs/specs/cargo-mutants-policy.md` (verified anti-skip policy verbatim). |
| Grep (local) | 3 | `Cargo.lock` — confirmed `libc 0.2.183` present, `nix` absent. |
| Training data | 1 area | General Rust/tokio idioms — flagged; all load-bearing claims (crate versions, MSRVs, cargo-mutants doc behaviour, dependency presence) were verified against crates.io, the repo's Cargo.lock, or Perplexity-cited docs, not training data. |

**Total MCP tool calls:** 3 (1 `perplexity_research` [timed out], 2 `perplexity_reason`).
**Training data reliance:** low — version numbers verified against crates.io; dependency
presence verified against Cargo.lock; cargo-mutants behaviour and the repo policy verified
against cited docs and the repo file respectively.

**MCP note (not an escalation — gate satisfied):** The first `perplexity_research`
(`sonar-deep-research`) call returned a hard timeout: `Request timeout: Perplexity API did
not respond within 300000ms.` Per the agent's fallback guidance I substituted two
`perplexity_reason` calls (`search_context_size: high`), which returned source-grounded
answers with citations. The MCP toolchain is available and functioning — this is a
per-call latency failure of the deep-research preset, not a toolchain outage, so the
MCP-UNAVAILABLE escalation path does not apply.

### Confidence ledger
- **CONFIRMED:** libc already in tree; nix/rexpect versions + MSRVs; assert_cmd has no
  mid-run signal API; repo policy forbids "hard-to-test" skips; `#[cfg(unix)]` gating is the
  repo norm; cargo-mutants has no auto-exemption for exit/signal/`#[tokio::main]`; the
  ctrl_c registration race is real; mutants job runs ubuntu-only.
- **INFERRED (flagged):** the exact mutant set cargo-mutants generates on this specific block
  (not run against this file yet — confirm with `cargo mutants --list --diff` once `main.rs`
  is in scope); the claim that refactor-alone leaves `eprintln!`/`exit(130)` mutants alive
  (follows from in-process test limitations, strongly supported, not empirically run here).
- **NOT FOUND:** any published statistic that exit/signal mutants are "commonly" survivors
  across real Rust projects — the docs acknowledge the class but publish no prevalence data.
