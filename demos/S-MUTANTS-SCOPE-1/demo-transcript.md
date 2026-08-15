# Demo Evidence — S-MUTANTS-SCOPE-1

Close the `queue.rs`/`main.rs` mutation-scope false-green: add both files to
`examine_globs`, extract `run_until_shutdown`, and land the `ctrl_c`/SIGINT
test pair (VP-MUTANTS-SCOPE-1-001/002).

**Format used:** text transcript (`demo-transcript.md`), following the
project precedent for infra/CI-hardening/refactor stories established by
`.factory/demos/S-693-1/demo-transcript.md` and the `--self-test` evidence
style used for S-627-1. This story has no user-facing CLI surface — its
product is (a) a CI mutation-scope fix, (b) a behavior-preserving
`run_until_shutdown` extraction inside `src/main.rs`, and (c) a new test
pair. A VHS/asciinema recording would just be a screen capture of the same
terminal text below with no added evidentiary value, so a transcript driving
the real compiled binary and the real `cargo`/`cargo-mutants`/shell-script
tooling is the correct artifact — nothing below is hand-transcribed.

**Worktree / HEAD:** `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-MUTANTS-SCOPE-1`,
branch `test/mutants-scope-queue-main`, commit `c0fa930c` ("test(release-gate):
make cfg-gate check token-based to match its doc (pass-9 LOW)") — the tip of
this story's branch. `git status` was clean before and after every step below;
only files under `.factory/demos/S-MUTANTS-SCOPE-1/` were written by this
recording session.

---

## 1. AC-005 — mutation false-green CLOSED (the story's core purpose)

Governing AC: **AC-005** — `cargo mutants --in-diff` touching
`src/cli/queue.rs`/`src/main.rs` must report a non-"0 mutants" result, with
the story's own bar (recorded in the story file, M-1 tightening) being
caught=3, missed=0, unviable=4, timeout=0 — a 100% kill rate over viable
mutants, 0 timeout survivors.

Command run from the worktree root:

```
$ DIFF_FILE=$(mktemp -t pr.diff.XXXXXX)
$ git diff origin/develop...HEAD > "$DIFF_FILE"
$ cargo mutants --in-diff "$DIFF_FILE" --jobs 4 --timeout 240
```

The diff (`git diff origin/develop...HEAD`) confirmed to include the two
`examine_globs` entries added by this story:

```diff
diff --git a/.cargo/mutants.toml b/.cargo/mutants.toml
index 1f8976b4..8895dec9 100644
--- a/.cargo/mutants.toml
+++ b/.cargo/mutants.toml
@@ -45,6 +45,16 @@ examine_globs = [
     "src/api/jsm/servicedesks.rs",
+    # HIGH-value: collapse_and_truncate's F6-hardened 200-char truncation boundary (PR #700)
+    # and resolve_queue_by_name's partial-match resolution. Whole-file scope — cargo-mutants
+    # examine_globs has no sub-file targeting. (added S-MUTANTS-SCOPE-1)
+    "src/cli/queue.rs",
+    # HIGH-value: previously-zero-coverage run_until_shutdown ctrl_c/SIGINT fork (closed by
+    # this story — VP-MUTANTS-SCOPE-1-001/002) and the InvalidSubcommand intercept.
+    # Whole-file scope — cargo-mutants examine_globs has no sub-file targeting; other
+    # branch-dense regions of main.rs (init_tracing, stdin-TTY flip) become mutation
+    # targets too as an accepted, tracked risk. (added S-MUTANTS-SCOPE-1)
+    "src/main.rs",
 ]
```

### Fresh run output (this session, on HEAD `c0fa930c`)

```
$ DIFF_FILE=$(mktemp -t pr.diff.XXXXXX)
$ git diff origin/develop...HEAD > "$DIFF_FILE"
$ cargo mutants --in-diff "$DIFF_FILE" --jobs 4 --timeout 240
Found 7 mutants to test
ok       Unmutated baseline in 52s build + 86s test
7 mutants tested in 6m: 3 caught, 4 unviable
```

(exit code `0` — cargo-mutants exits non-zero only when a mutant is
`Missed` or `Timeout`; neither occurred here.) This is a genuine, freshly
executed run in this session (not the pre-existing directory below) — total
wall time was baseline (52s build + 86s test) plus ~5 minutes testing the 7
mutants with `--jobs 4`. The summary line omits `missed`/`timeout` entirely
because both are zero, matching `missed.txt`/`timeout.txt` being empty
(confirmed below) — **7 mutants tested: 3 caught, 4 unviable, 0 missed, 0
timeout**, i.e. AC-005's non-"0 mutants" bar and the recorded 100%-kill-rate-
over-viable-mutants bar are both met on this exact commit.

The fresh run's own `mutants.out/` (`caught.txt`/`missed.txt`/`unviable.txt`/
`timeout.txt`), re-read immediately after this run completed, is byte-identical
in content to the "corroborating" listing quoted just below — same three
caught mutants, same four unviable mutants, both other files empty.

### Corroborating: pre-existing `mutants.out/` from the immediately preceding
run on this same HEAD

Before triggering the fresh run above, the worktree already contained a
`mutants.out/` directory from a prior run against this exact commit
(`c0fa930c`, confirmed via `git log -1 --format="%H %ci"` matching the
`mutants.out/debug.log` build-copy timestamp window). Its per-outcome files:

```
$ cat mutants.out/caught.txt
src/main.rs:194:5: replace block_until_sigint_test_seam with ()
src/main.rs:220:5: replace run -> anyhow::Result<()> with Ok(())
src/main.rs:490:20: replace == with != in run

$ cat mutants.out/missed.txt
(empty)

$ cat mutants.out/unviable.txt
src/main.rs:172:5: replace run_until_shutdown -> RunOutcome<T> with RunOutcome::new()
src/main.rs:172:5: replace run_until_shutdown -> RunOutcome<T> with RunOutcome::from(Default::default())
src/main.rs:172:5: replace run_until_shutdown -> RunOutcome<T> with RunOutcome::new(Default::default())
src/main.rs:172:5: replace run_until_shutdown -> RunOutcome<T> with RunOutcome::from_iter([Default::default()])

$ cat mutants.out/timeout.txt
(empty)
```

caught=3, missed=0, unviable=4, timeout=0 — 7 mutants total, exactly matching
the story's recorded authoritative bar. The three caught mutants land
precisely on the risk this story exists to close: the
`block_until_sigint_test_seam` seam function (deleted body → caught by
`tests/interrupt_signal.rs`'s SIGINT-observation test), the `run()` function
body (replaced wholesale with `Ok(())` → caught), and the seam-selection
condition itself (`==` → `!=` on `test_seam_active` — the specific "silent
mis-selection" class this story's own new scaffolding could have introduced,
caught by a fast test failure, not a timeout). The four unviable mutants are
all on `run_until_shutdown`'s generic return type (`RunOutcome::new()` /
`::from(...)` / etc. — `RunOutcome` has no such constructors, so these mutants
fail to *compile*, not fail to be caught; `cargo-mutants` correctly classifies
compile failures as Unviable rather than Caught/Missed).

**Before this story:** neither `src/main.rs` nor `src/cli/queue.rs` was in
`examine_globs` at all, so an `--in-diff` run touching only those files (as
PRs #696, #698, #700 did) reported `Found 0 mutants to test` — the
silent, gate-passing false-green that let all three PRs merge unchecked
(`mutants` job reports `skipped`/no-op, `ci-gate`'s `ALLOWED_SKIPS` allowlist
tolerates it by design, and no reviewer sees a red flag). **After this
story:** the identical class of diff now surfaces real mutants and a real
kill-rate report.

---

## 2. BC-X.3.006 interrupt behavior — the real terminal demo (VP-001 subject)

Governing ACs: **AC-006/AC-007/AC-009/AC-010** — `run_until_shutdown`'s
boundary contract, byte-exact `"\nInterrupted\n"` + exit 130 on the
interrupted path, and a deterministic (non-sleep) readiness handshake.

### Build

```
$ cargo build
   Compiling jr v0.7.0-dev.1 (/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-MUTANTS-SCOPE-1)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 3.03s
```

### Deterministic SIGINT demo, driving the real debug binary

Script (run from the worktree root; no fixed sleep is used to decide when to
send the signal — the loop polls for the `JR-TEST-READY` marker the seam
writes to stdout once `tokio::signal::ctrl_c()`/`signal(SIGINT)` has actually
registered, matching AC-010):

```bash
OUT=$(mktemp -t jr_sigint_out.XXXXXX)
ERR=$(mktemp -t jr_sigint_err.XXXXXX)
JR_TEST_BLOCK_UNTIL_SIGINT=1 ./target/debug/jr me >"$OUT" 2>"$ERR" &
PID=$!
for i in $(seq 1 100); do
  grep -q "JR-TEST-READY" "$OUT" 2>/dev/null && break
  sleep 0.05
done
kill -INT "$PID"
wait "$PID"; EXIT=$?
```

Real output captured:

```
started pid=70515
marker seen after 10 polls
--- stdout so far ---
JR-TEST-READY
exit=130
--- stderr ---

Interrupted
--- stdout final ---
JR-TEST-READY
```

`xxd` on the captured stderr file confirms the byte-exact contract (leading
newline, no trailing/extra whitespace):

```
$ xxd "$ERR" | tail -5
00000000: 0a49 6e74 6572 7275 7074 6564 0a         .Interrupted.
```

i.e. `"\nInterrupted\n"` byte-for-byte, exit code `130` — matching
BC-X.3.006's contract and AC-007's "byte-for-byte unchanged" requirement.
The marker appeared after 10 polls (≈500ms), demonstrating the handshake is
what gates the signal send, not a guessed duration.

---

## 3. Guard / test evidence

Governing ACs: **AC-003/AC-014** (policy-citation guard), **AC-009/AC-010/AC-011**
(subprocess SIGINT test), and the release-gate pin for the
`JR_TEST_BLOCK_UNTIL_SIGINT` seam referenced throughout AC-009/AC-010.

### `cargo test --test interrupt_signal`

```
$ cargo test --test interrupt_signal -- --nocapture
    Finished `test` profile [unoptimized + debuginfo] target(s) in 0.14s
     Running tests/interrupt_signal.rs (target/debug/deps/interrupt_signal-f57e841a027d86e0)

running 1 test
test test_sigint_during_run_exits_130_with_byte_exact_interrupted_stderr ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.62s
```

### `cargo test --test jr_test_block_until_sigint_release_gate`

```
$ cargo test --test jr_test_block_until_sigint_release_gate -- --nocapture
    Finished `test` profile [unoptimized + debuginfo] target(s) in 0.26s
     Running tests/jr_test_block_until_sigint_release_gate.rs (target/debug/deps/jr_test_block_until_sigint_release_gate-802d5d02467e81e0)

running 1 test
test test_jr_test_block_until_sigint_cfg_gate_present_in_main_source ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
```

### `scripts/check-cargo-mutants-policy-citations.sh`

```
$ scripts/check-cargo-mutants-policy-citations.sh
Check passed: 18 bullets parsed, 52 (file, fn) pairs validated
```

Matches the exact bar named in the delegation brief (18 bullets / 52 pairs)
and confirms **AC-002/AC-014**: the two new bullets for `queue.rs`/`main.rs`
plus the five backfilled pre-existing bullets (`interactions.rs`,
`cli/issue/attachments.rs`, `api/jira/attachments.rs`, `api/jsm/attachments.rs`,
`api/jsm/servicedesks.rs`) plus the 11 originally-documented entries all
resolve to real `(file, fn)` pairs with zero offenders.

### Bonus — AC-008's portable, non-signal test pair (both arms of `run_until_shutdown`)

Not explicitly requested in the delegation brief's guard list, but directly
proves AC-006/AC-008 (the extracted function's boundary contract and both
`RunOutcome` arms), captured for completeness:

```
$ cargo test --bin jr run_until_shutdown -- --nocapture
   Compiling jr v0.7.0-dev.1 (/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-MUTANTS-SCOPE-1)
    Finished `test` profile [unoptimized + debuginfo] target(s) in 1.41s
     Running unittests src/main.rs (target/debug/deps/jr-f432cb579a7ead0a)

running 2 tests
test tests::test_run_until_shutdown_returns_interrupted_when_shutdown_fires_first ... ok
test tests::test_run_until_shutdown_returns_completed_when_work_finishes_first ... ok

test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
```

(These are the two `#[tokio::test]` functions inside `src/main.rs`'s inline
`#[cfg(test)] mod tests` block, per AC-008 — `src/main.rs:566-598`.)

---

## Summary — evidence-to-AC/BC mapping

| Evidence item | ACs proven | BC | Result |
|---|---|---|---|
| §1 `cargo mutants --in-diff` run | AC-005 | drift item `MUTANTS-SCOPE-GAP-QUEUE-MAIN` | caught=3, missed=0, unviable=4, timeout=0 — non-"0 mutants", 100% kill rate over viable mutants, 0 timeout survivors. False-green closed. |
| §2 Real SIGINT terminal demo | AC-006, AC-007, AC-009 (behavioral half), AC-010 | BC-X.3.006 Behavior items 1–2, Edge Case EC-1 | Exit code `130`, stderr byte-exact `"\nInterrupted\n"`, readiness marker gates signal delivery (10 polls, no fixed sleep). |
| §3 `cargo test --test interrupt_signal` | AC-009, AC-010, AC-011 | BC-X.3.006 Verification Properties — VP-MUTANTS-SCOPE-1-001 | 1 passed — real out-of-process subprocess assertion on exit code + stderr. |
| §3 `cargo test --test jr_test_block_until_sigint_release_gate` | AC-010 (seam is debug/unix-only, matching convention) | BC-X.3.006 EC-1 mitigation | 1 passed — `#[cfg(debug_assertions)]` confirmed within 5 lines of the env read. |
| §3 `scripts/check-cargo-mutants-policy-citations.sh` | AC-002, AC-003, AC-014 | — (pure doc/policy governance) | `Check passed: 18 bullets parsed, 52 (file, fn) pairs validated` — 0 offenders. |
| §3 bonus `cargo test --bin jr run_until_shutdown` | AC-006, AC-008 | BC-X.3.006 Verification Properties — VP-MUTANTS-SCOPE-1-002 | 2 passed — both `RunOutcome` arms (`Completed`/`Interrupted`) covered portably, no signal involved. |

**Not captured in this session (out of scope for this delegation):**
AC-001/AC-004 (`.cargo/mutants.toml` content + `tests/mutants_glob_existence.rs`)
and AC-012/AC-013 (source-diff-scope / human-decision-recorded) are
documentation/config-content assertions already covered by the story file's
own AC text and the `git diff` shown in §1 — no additional runtime evidence
was generated for them here, per the delegation brief's evidence list.
AC-011 (clippy dead-code check on `#[cfg(unix)]` helpers under a non-Unix
target) was not re-run in this session; it is a build-time compiler check,
not runtime demo evidence, and this is a macOS (Unix) worktree.
