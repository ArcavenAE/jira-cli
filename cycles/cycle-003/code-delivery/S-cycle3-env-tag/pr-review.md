## PR Review — Cycle 3 (final)

**Verdict: READY / APPROVE**
**covered_sha: `0d99536e34fe03ae96b51e85458b68dc496b6ba6`** (confirmed current PR HEAD at post time)

Scope of this cycle: the delta since my cycle-2 approval at `a03139ae`. I re-verified the
new commit end to end rather than reading the commit message and trusting it.

---

### 1. Diff coherence — PASS

`git diff a03139ae..0d99536e` is **one file, +45/−0**:

```
 src/output.rs | 45 +++++++++++++++++++++++++++++++++++++++++++++
```

Both additions land inside the existing `#[cfg(test)] mod tests` block. **Zero production
code changed** — no drift, nothing unrelated smuggled in. This is the right shape for the
finding: the OSC ST-terminator logic was already correct; what was missing was a test that
made its two sub-conditions independently observable.

### 2. Mutant-kill claims — INDEPENDENTLY VERIFIED (did not take the commit message on trust)

The check under test, `src/output.rs:146`:

```rust
if next == '\u{1b}' && chars.peek() == Some(&'\\') {
```

I extracted `strip_control_and_ansi` + the `sanitize_env_display` cap wrapper into a
standalone harness, parameterized the line-146 predicate over all four variants
(original + the three reported mutations), and ran both new test inputs through each:

| Variant | T1 `before ESC ] x \ y VISIBLE BEL TAIL` | T2 `before ESC ] p ESC q VISIBLE BEL TAIL` |
|---|---|---|
| original | `"beforeTAIL"` — passes | `"beforeTAIL"` — passes |
| `146:33 ==`→`!=` | `"beforeyVISIBLETAIL"` — **KILLED** | `"beforeTAIL"` — survives |
| `146:45 &&`→`\|\|` | `"beforeyVISIBLETAIL"` — **KILLED** | `"beforeVISIBLETAIL"` — **KILLED** |
| `146:61 ==`→`!=` | `"beforeTAIL"` — survives | `"beforeVISIBLETAIL"` — **KILLED** |

Conclusions I draw from this, beyond what the commit message asserts:

- All three reported mutants are killed by the union of the two tests. Confirmed.
- **Both tests are load-bearing, neither is redundant.** T1 is the *only* killer of the
  `146:33` mutant; T2 is the *only* killer of the `146:61` mutant. Deleting either one
  silently reopens a specific mutant. Worth knowing before anyone "consolidates" these two
  tests into one in a future cleanup — they are deliberately asymmetric.
- The unmutated variant passes both, so the tests are not vacuous or over-fitted to a
  mutant.
- The 40-char `MAX_ENV_DISPLAY_LEN` cap cannot mask any of these: expected output is 10
  chars, worst mutated output 18 chars — both far below the cap, so truncation never
  enters the comparison. The tests isolate the OSC logic cleanly.

I also ran the real tests in the worktree at the PR head (clean tree, `git status` empty):
all 16 `output::tests::test_sanitize_env_display_*` pass, including the two new ones, so my
harness matches the shipped code rather than a paraphrase of it.

The root-cause narrative in the commit message also checks out: the pre-existing OSC tests
covered only BEL-terminated and unterminated-to-EOF inputs. In a well-formed `ESC \` ST
both sub-conditions are true simultaneously, so `&&`↔`||` and either `==`↔`!=` flip are
behaviorally invisible there. Decoupling the two sub-conditions was exactly the right fix.

### 3. CI — GREEN on the final SHA

All **15/15** checks pass on run `33604447671`, whose `headSha` I confirmed is
`0d99536e34fe03ae96b51e85458b68dc496b6ba6` (not an inherited result from an earlier SHA):

`CI Gate`, `Clippy (ubuntu/windows)`, `Coverage`, `Deny`, `Format`, `MSRV (1.85.0)`,
`Mutation testing`, `Secret Scan (gitleaks)`, `Signing Workflow Injection Guard`,
`Spec Guards`, `Test (macos/ubuntu/windows)`, `dependency-review`.

**Mutation testing: `25 caught / 0 missed / 0 timeout / 0 unviable` — 100% kill rate.**

One thing I checked specifically because it is the classic way a mutation-score fix gets
gamed: **the denominator did not move.** Cycle 2 was 22 caught + 3 missed = 25 killable;
this run is 25 caught + 0 missed = 25 killable. The kill rate rose because three mutants
are now genuinely killed, *not* because scope was narrowed, a glob was trimmed, or an
`#[allow]`/skip was introduced to shrink the mutant population. Same 25 mutants, three more
dead.

### 4. Commit quality — PASS

Conventional format, correct type (`test:`), story ID present, and the body is genuinely
useful: it names each mutant by file:line:col, explains *why* the existing tests could not
observe them, and states which test kills which mutant. It also records a manual RED-proof
(each mutation applied individually, then reverted). My independent replication agrees with
its per-test attribution exactly.

### 5. Remaining checklist items

- **Test coverage** — PASS (verified above).
- **Demo evidence** — unchanged from cycle 2, where it was reviewed and accepted. This diff
  is test-only and alters no acceptance-criterion behavior, so no re-recording is warranted.
- **Diff size** — 45 lines. Well within limits.
- **Missing changes** — none. Correctly resisted the temptation to "fix" production code
  that was never broken.
- **Dependency status** — N/A; base is `develop`, no upstream PR dependency.

---

## Findings

| Severity | Category | Finding | Suggestion |
|---|---|---|---|
| NIT | description | PR body's Pre-Merge Checklist still reads `cargo test --lib` **1234/1234**. The actual count at this HEAD is **1236** passed / 11 ignored — stale by exactly the two tests this commit adds. The commit message itself correctly says 1236/1236. | Optional: bump the checklist line to 1236/1236 if the PR body is touched again. Not worth a commit on its own, and not a merge blocker. |

No BLOCKING findings. No SUGGESTION findings.

---

## What I verified (explicitly, so this is not a rubber stamp)

1. The delta since cycle-2 approval is *exactly* two test functions and nothing else —
   confirmed by `--stat` (+45/−0, one file) and by reading the full diff, not just the stat.
2. Each of the three reported mutants was reproduced and executed against both new test
   inputs in a standalone harness; kill/survive was determined by running code, not by
   reading the commit message.
3. Both tests were shown to be individually necessary — each is the sole killer of one
   mutant.
4. The two new tests pass against the real shipped source in a clean worktree at the PR
   head SHA.
5. The mutation kill-rate improvement was checked for denominator gaming; the killable
   population is unchanged at 25.
6. The CI run reporting green was confirmed to have run against this exact SHA.
7. The truncation cap was checked and ruled out as a confounder for the test assertions.

Nothing new surfaced. Cycle-1 BLOCKING-1 (mutation-testing scope) is now demonstrably
closed by its own consequence: the job it enabled caught a real gap, and that gap is fixed
with the mutation population intact.

**READY.** Merge remains human-gated, as intended.
