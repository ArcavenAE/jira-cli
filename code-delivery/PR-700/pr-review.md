## Fresh-Eyes PR Review — #700 `test(queue): pin collapse_and_truncate 200-char boundary`

**Verdict: APPROVE-equivalent (posted as COMMENT — the authenticated `gh` account is the PR author, so GitHub blocks a formal `--approve`).**

No blocking findings. This is a clean, well-scoped, genuinely non-tautological test-only change. Three non-blocking findings below, one of which (SUGGESTION-2) is worth acting on because it affects whether this fix stays fixed.

---

### What I verified (not a rubber-stamp)

I checked out the PR head into a scratch worktree and ran the following independently of the author's claims:

1. **Diff is genuinely test-only.** `git show` on `4fe1a3a1` touches exactly one file, `src/cli/queue.rs`, entirely inside the existing `#[cfg(test)] mod tests` block. The single deletion is the `use super::{…}` import line being widened to bring in `MAX_CAUSE_LEN` and `collapse_and_truncate`. `collapse_and_truncate`'s body (lines 222–230) is byte-identical to `develop`. Confirmed no production-code delta.

2. **Baseline GREEN.** `cargo test --lib queue::` → 24 passed, 0 failed, including both new tests.

3. **The `>` → `>=` mutant is genuinely CAUGHT.** I applied the mutant to the working tree and re-ran:
   ```
   test ..._boundary_exact_length_is_not_truncated ... FAILED
   test ..._boundary_over_length_is_truncated ... ok
   test result: FAILED. 23 passed; 1 failed
   ```

4. **The `>` → `==` mutant is genuinely CAUGHT.** Same procedure:
   ```
   test ..._boundary_over_length_is_truncated ... FAILED
   test ..._boundary_exact_length_is_not_truncated ... FAILED
   test result: FAILED. 22 passed; 2 failed
   ```
   Both new tests are load-bearing — neither is a passenger, and neither passes vacuously under the mutation it targets.

5. **The "5/5" denominator checks out.** `cargo mutants -f src/cli/queue.rs --list` reports exactly five mutants on `collapse_and_truncate`: two function-replacement mutants (`String::new()`, `"xyzzy".into()`), and three on the predicate (`> → ==`, `> → <`, `> → >=`). The two function-replacement mutants are killed by any assertion in either new test; the `> → <` mutant is killed by the over-length test (250 < 200 is false → no truncation → assertion fails). So 5/5 is accurate.

6. **Lint clean.** `cargo clippy --lib --all-features -- -D warnings` passes on the PR head. `std::iter::repeat_n` is stable since Rust 1.82, comfortably under the 1.85 MSRV (and tests are outside the `msrv` job's lib+bins scope anyway, so no risk there either).

7. **Test naming matches repo convention.** `test_<subject>_<condition>_<expected_outcome>` — consistent with the sibling tests already in this module (`test_extra_fields_allow_list_keeps_only_customfield_tokens`, `test_extra_fields_allow_list_dedups_preserving_first_seen_order`) and with `docs/specs/test-naming-convention.md`.

8. **Test independence is right.** The expected value in the over-length test is built with `std::iter::repeat_n(…).chain(once('…'))` rather than by re-invoking the production `format!("{truncated}\u{2026}")` — so the assertion is an independent restatement of the contract, not an echo of the implementation. Good instinct.

9. **CI.** All completed checks green at review time (Format, Clippy ubuntu, MSRV, Mutation testing, Spec Guards, gitleaks, dependency-review, Signing Workflow Injection Guard); Test legs / Coverage / Deny / Clippy windows still pending. Nothing failing. See SUGGESTION-2 on why the green "Mutation testing" check does not actually corroborate this PR's central claim.

---

### Findings

| # | Severity | Category | Finding |
|---|----------|----------|---------|
| 1 | suggestion | coherence | Inline comment misstates the mutant's observable effect (off by one) |
| 2 | suggestion | coverage | `src/cli/queue.rs` is outside `examine_globs`, so this fix has no standing regression guard |
| 3 | nit | coherence | `250` is a magic number where `MAX_CAUSE_LEN + 50` would self-adjust |

---

#### [SUGGESTION] `src/cli/queue.rs` — comment in `test_collapse_and_truncate_boundary_exact_length_is_not_truncated` is off by one

```rust
// Under the `>=` mutant, this 200-char input would be wrongly
// truncated to 199 chars + '…', catching that mutant.
```

This is factually wrong, and the assertion it's explaining is correct — so the comment is the defect, not the code. The truncation arm is `collapsed.chars().take(MAX_CAUSE_LEN)`, and `take()` is independent of the predicate. Under the `>=` mutant a 200-char input takes **200** chars, not 199, then appends `…` for a 201-char result. I confirmed this empirically by applying the mutant and reading the assertion diff:

```
left:  "aaa…(200 a's)…aaa…"     <- 200 'a' + U+2026, i.e. 201 chars
right: "aaa…(200 a's)…aaa"      <- the 200-char input
```

Suggested fix:

```rust
// Under the `>=` mutant, this 200-char input would be wrongly
// truncated — `take(MAX_CAUSE_LEN)` still yields 200 chars, but a
// trailing '…' is appended (201 chars total), so the equality
// assertion below fails and catches that mutant.
```

Flagging this at suggestion rather than nit level because a comment that asserts a specific numeric behavior the code does not exhibit is exactly the comment-rot class this repo takes seriously elsewhere (see the citation-discipline convention in `CLAUDE.md`). The whole value of these two tests is that a future maintainer can read the comment and understand *why* the boundary matters; a wrong number there actively misleads.

---

#### [SUGGESTION] `.cargo/mutants.toml` — this fix has no standing regression guard, and the green "Mutation testing" check does not verify the PR's claim

`src/cli/queue.rs` is not in `examine_globs`. I verified the consequence directly:

```
$ cargo mutants --list | grep -c "src/cli/queue.rs"
0
$ cargo mutants --list | wc -l
1080
```

Zero of the project's 1080 in-scope mutants live in `queue.rs`. The five mutants on `collapse_and_truncate` are only reachable with an explicit CLI override (`-f src/cli/queue.rs`), which is presumably how the F6 run that found these survivors was invoked.

Two consequences worth naming:

1. **The PR's own green `Mutation testing` check is vacuous here.** The CI job runs `cargo mutants --in-diff`, and this diff contains no production code — so the mutant set for this run is empty regardless of scope. It passed in 31s. It is *not* evidence that the two survivors are now caught. (My manual RED proof above is; I'm noting this so nobody later reads the green check as the corroboration.)

2. **Nothing prevents these mutants from silently re-opening.** If someone later refactors `collapse_and_truncate` or deletes a test, no CI job will notice. That's the same durability gap this PR exists to close, just moved one level out.

Suggested fix — add to `examine_globs` in the same spirit as the existing S-576-1 / S-577-1 entries, which document exactly this "mutation-relevant work happened here → put the file in scope" precedent (`P22-001`, `MAINT-MUTANTS-GLOBS-01`):

```toml
# F6 survivors closed in PR #700 — collapse_and_truncate's MAX_CAUSE_LEN
# boundary predicate. In scope so the fix has a standing regression guard.
"src/cli/queue.rs",
```

Cost check, since scope additions are not free: `cargo mutants -f src/cli/queue.rs --list` raises the total from 1080 to 1114, i.e. **~34 mutants** for the whole file. And because CI runs `--in-diff`, the incremental CI cost on any given PR is effectively zero — it only matters when someone touches `queue.rs`, which is precisely when you want it.

I'd also note `docs/specs/cargo-mutants-policy.md §Scope` is the canonical scope definition per the config's own header comment, and it's guarded by `scripts/check-cargo-mutants-policy-citations.sh` — so a scope addition needs the matching policy-doc bullet in the same commit or spec-guard will fail. That's a small amount of extra work, which is a legitimate reason to do it as a follow-up rather than expanding this deliberately-narrow PR. Either is fine; leaving it undone entirely is the outcome I'd push back on.

---

#### [NIT] `src/cli/queue.rs` — `250` is a magic number in the over-length test

```rust
let input = "b".repeat(250);
```

The exact-length test correctly derives its input from the constant (`"a".repeat(MAX_CAUSE_LEN)`); this one hardcodes `250`. `MAX_CAUSE_LEN + 50` would keep the two symmetric and self-adjust if the cap is ever retuned.

To be clear about the actual risk: this **fails loudly** rather than silently if `MAX_CAUSE_LEN` were raised past 250 (the expected string is still built from `MAX_CAUSE_LEN`, so the assertion would mismatch), so it's a maintenance trip-wire, not a coverage hole. Purely a readability/symmetry point — fix if convenient.

---

### Observations (no action requested)

- **Demo evidence: N/A, not a gap.** This is a pure test addition with a provably zero-byte production delta, so there is no user-observable behavior to record. Flagging missing `docs/demo-evidence/` here would be cargo-culting the checklist.
- **UTF-8 boundary is untested**, despite `collapse_and_truncate`'s doc comment advertising "UTF-8-safe". A multi-byte input straddling char 200 (e.g. 199 ASCII + a 4-byte emoji + filler) would exercise the `chars()`-vs-bytes distinction that makes the `take()` safe. Explicitly **out of scope for this PR**, which is correctly narrow — the new tests' own header comment is upfront that single-line ASCII inputs were chosen to isolate the predicate. Mentioning only so it's on the record as an adjacent gap; do not expand this PR for it.
- **Out-of-scope, pre-existing (from #693, not this diff):** the `///` doc comment at `src/cli/queue.rs:215-219` describes `collapse_and_truncate`'s behavior but is attached to `const MAX_CAUSE_LEN` on line 220, so it renders as the constant's documentation. Worth a one-line fix whenever this file is next touched.

---

### Checklist

| # | Item | Result |
|---|------|--------|
| 1 | Diff coherence | PASS — one file, one concern, no unrelated changes |
| 2 | Description accuracy | PASS — body matches the diff; "5/5 caught" independently corroborated |
| 3 | Test coverage | PASS — both named mutants proven RED under mutation |
| 4 | Demo evidence | N/A — zero production delta, nothing to demo |
| 5 | Commit quality | PASS — conventional format, single focused commit, clear body |
| 6 | Diff size | PASS — 36 insertions / 1 deletion |
| 7 | Missing changes | PASS, with SUGGESTION-2 noted as the one arguable omission |
| 8 | Dependency status | PASS — #693's helper is already on `develop`; base is `develop`; MERGEABLE |
