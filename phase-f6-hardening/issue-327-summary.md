# Phase F6 — Targeted Hardening: issue #327

- **Story:** issue #327 — `rand` 0.9 → 0.10 migration (3 symbol renames + manifest bump + deny.toml comment block)
- **Merge commit:** (TBD — F7 has not yet merged; current branch HEAD: `ae2c9ef` on `chore/rand-0.10-migration`)
- **Baseline commit:** `91a29b9` (develop HEAD post-#412 merge)
- **Diff scope:** `src/api/auth.rs` (6 lines changed at 3 sites — `OsRng` → `SysRng` × 2, `TryRngCore` → `TryRng` × 1; doc comment likewise updated), `Cargo.toml` (`rand = "0.9"` → `"0.10"`), `deny.toml` (+13 non-executable comment lines), `Cargo.lock` (auto-resolved). Total: 4 files, 61 insertions, 10 deletions.
- **Date:** 2026-05-26
- **Verifier:** formal-verifier agent

## Verdict: PASS

All hardening gates passed. Mutation kill rate on the changed function (`generate_state`) is 100% (2/2 mutants caught). Security scans (`cargo audit`, `cargo deny check`) exit 0 with no advisories. Full regression suite is green (1483 / 0 / 18 — identical to the issue-407 baseline). No new attack surface introduced — the change is a symbol-rename refresh tracking upstream `rand` 0.10's rename of `OsRng` → `SysRng` and `TryRngCore` → `TryRng`.

---

## 1. Mutation Testing (cargo-mutants on diff scope)

### Canonical run (CLAUDE.md `--in-diff` form)

**Command:**

```
DIFF_FILE=$(mktemp -t pr.diff.XXXXXX) && trap 'rm -f "$DIFF_FILE"' EXIT && \
git diff origin/develop...HEAD > "$DIFF_FILE" && \
cargo mutants --in-diff "$DIFF_FILE" --baseline=skip --jobs 4 --no-shuffle
```

**Result:** `INFO No mutants to filter` — exit 0.

**Why zero mutants from `--in-diff` alone:** `.cargo/mutants.toml::examine_globs` is scoped to the F6-hardening-critical modules (`bulk.rs`, `bulk` types, `create.rs`, JSM `requests.rs` / `request_types.rs`, `requesttype.rs`). It does **not** include `src/api/auth.rs`. Per `docs/specs/cargo-mutants-policy.md`, this scope is the project's deliberate kill-rate target list — keeping the high-coupling state-changing paths under hard mutation pressure without inflating timeouts on integration-heavy modules. The combination `--in-diff` ∩ `examine_globs` produces an empty intersection for this diff: `src/api/auth.rs` is in the diff but not in scope, so `cargo-mutants` correctly reports "No mutants to filter".

The other diff files (`Cargo.toml` manifest line, `deny.toml` comment block, `Cargo.lock` auto-resolution) are not Rust source files and cannot be mutated by cargo-mutants in any configuration.

### Augmented run (directly target the changed function)

To complete due-diligence coverage of the actual semantic change in this PR, ran cargo-mutants directly against the changed function (out-of-policy scope, but appropriate for verifier independence on a function-rename PR):

**Command:**

```
cargo mutants --file src/api/auth.rs --regex 'generate_state' --baseline=skip --jobs 4 --no-shuffle
```

**Result table:**

| Metric | Value |
|---|---|
| Mutants found | 2 |
| Mutants caught | 2 |
| Mutants missed | 0 |
| Mutants unviable | 0 |
| Mutants timed out | 0 |
| **Kill rate** | **100%** (2/2) — target ≥90% |
| Elapsed | 63s |

**Mutant detail (both caught):**

```
src/api/auth.rs:1094:5: replace generate_state -> Result<String> with Ok(String::new())
src/api/auth.rs:1094:5: replace generate_state -> Result<String> with Ok("xyzzy".into())
```

Both mutants replace the entire `generate_state` body with a constant return.

- `Ok(String::new())` — caught by `test_generate_state_is_64_hex_chars` (empty string ≠ 64 chars) and `test_generate_state_is_not_deterministic` (8 calls return 8 copies of `""`, set length 1 ≠ 8).
- `Ok("xyzzy".into())` — caught by `test_generate_state_is_hex` (`"xyzzy"` contains `'y'` and `'z'` which are not ASCII hex digits) and `test_generate_state_is_64_hex_chars` (5 chars ≠ 64).

Three existing unit tests (`src/api/auth.rs:1185-1224`) form a complete kill harness for the function: hex-charset constraint, length pin, and 8-sample distinctness pin together cover both "constant output" and "non-CSPRNG entropy regression" classes.

**Baseline note:** `--baseline=skip` was used per the issue-407 template precedent and per the explicit task brief direction. The 300-second default timeout (used when `--baseline=skip` is set) absorbed the 63s actual runtime with ample headroom. No baseline flakiness observed for this scope (the macOS-keychain-blocking baseline test that troubled the issue-407 run lives in a different test path and was not triggered by the `--regex 'generate_state'` filter).

---

## 2. Security Scans

### `cargo audit`

| Item | Value |
|---|---|
| Exit code | **0** |
| Advisories loaded | 1098 (RustSec) |
| Crates scanned | 345 |
| Vulnerabilities found | **0** |
| Warnings | 0 |

Clean. The previously-investigated [GHSA-cq8v-f236-94qc](https://github.com/advisories/GHSA-cq8v-f236-94qc) ("`Rng::sample` thread-unsafe when used with a `&mut` borrowed `OsRng`") was empirically verified not applicable to `jr` during F1 — `generate_state` does not call `Rng::sample`, uses single-threaded `try_fill_bytes`, and was already on a safe call pattern in rand 0.9. The audit reflects this by emitting zero findings against the dependency graph. See `.factory/research/rand-0.10-perplexity-verification.md`.

### `cargo deny check`

| Item | Value |
|---|---|
| Exit code | **0** |
| advisories | ok |
| bans | ok |
| licenses | ok |
| sources | ok |

Three pre-existing `license-not-encountered` warnings for unused allow-list entries (`BSD-2-Clause` line 8, `Unicode-DFS-2016` line 13, `OpenSSL` line 15) — these are "we'd allow these if we saw them; we didn't see them" warnings, harmless, identical to the issue-407 baseline. **Not a security finding.**

The `bans` check specifically validates that the new 13-line comment block added to `deny.toml:57-69` (explaining why `rand` 0.9 + 0.10 transitive dual-presence is intentionally NOT skipped) does not introduce a real `[[bans.skip]]` entry — it does not, and `cargo-deny` correctly does not flag the lockfile-only `rand 0.9.4` ghost dependency as a multiple-versions violation. Empirically verified during F5 (see `.factory/phase-f2-spec-evolution/adversarial-327-pass-1.md`).

### `semgrep`

Not run — `semgrep` is not installed in the verifier environment (`which semgrep → not found`). This is acceptable per the F6 brief, which marks semgrep as optional for this story. Symbol renames `OsRng` → `SysRng` / `TryRngCore` → `TryRng` do not introduce any new I/O, parsing, deserialization, network, or unsafe code paths, so a static-analysis security scanner would have no surface to report on.

### New-code security pattern review (manual)

The 3 changed call-sites in `src/api/auth.rs` are byte-for-byte equivalent to the pre-bump code modulo the upstream rand 0.10 rename:

```rust
// Before (rand 0.9)              // After (rand 0.10)
use rand::TryRngCore;             use rand::TryRng;
rand::rngs::OsRng                 rand::rngs::SysRng
    .try_fill_bytes(&mut bytes)        .try_fill_bytes(&mut bytes)
```

Both `OsRng` (rand 0.9) and `SysRng` (rand 0.10) are documented as thin wrappers over the `getrandom` crate (`getrandom(2)` on Linux, `BCryptGenRandom` on Windows, `arc4random_buf` on macOS via `/dev/urandom`). The rename was a semantic clarification by the rand maintainers, not a behavioral change. The doc comment in `auth.rs:1077-1085` was updated in lockstep. Verified during F1 against the rand 0.10 changelog and Perplexity-validated against upstream documentation.

**No insecure patterns identified.**

---

## 3. Kani Formal Proofs

**Status: NO-OP.**

`generate_state` performs OS syscalls via `getrandom(2)` / `BCryptGenRandom`, which is effectful, non-deterministic, and not reducible by Kani's symbolic execution. No other function in the diff is a pure-core proof candidate. No project-wide Kani harness exists in the repository today (`grep -r 'kani' .` finds no harnesses), so there is no harness to either run or update.

---

## 4. Fuzzing

**Status: NO-OP.**

The diff introduces no parsing, decoding, deserialization, or input-validation code paths. No new attack surface. The 3-symbol rename does not change the data flow of `generate_state`, which never consumes external input — it only reads from the OS CSPRNG and renders bytes as hex. No fuzz target is justified.

---

## 5. Regression Confirmation

**Command:** `cargo test --all-features`

| Metric | Value |
|---|---|
| Passed | **1483** |
| Failed | **0** |
| Ignored | 18 (gated: macOS keychain + OAuth integration tests behind `JR_RUN_*=1`) |
| Test binaries | 72 |
| Doc-tests | 0 |

Full suite clean. Numbers are byte-for-byte identical to the issue-407 baseline reported in `.factory/phase-f6-hardening/issue-407-summary.md` (1483 / 0 / 18) — confirming the rand 0.10 migration is regression-neutral across the full codebase, including the 6-story regression zone (S-1.06, S-1.08, S-3.01, S-3.03, S-3.04, issue-288-pr4-dispatch) plus the 3 `generate_state` unit tests that exercise the rand 0.10 surface directly.

The 18 ignored tests match the documented gates per `CLAUDE.md` (keyring tests behind `JR_RUN_KEYRING_TESTS=1`, OAuth integration behind `JR_RUN_OAUTH_INTEGRATION=1`). No new ignored tests; no flaky tests surfaced.

---

## 6. Purity Boundary

**N/A.** `generate_state` was already an effectful function (OS CSPRNG syscall) before the bump and remains so after. No purity boundary touched.

---

## F6 Gate Decision

| Gate | Target | Actual | Status |
|---|---|---|---|
| Mutation kill rate (changed function `generate_state`) | ≥90% | 100% (2/2) | PASS |
| Mutation kill rate (diff ∩ policy scope) | ≥90% | N/A — no in-policy-scope mutants in diff | PASS |
| `cargo audit` | exit 0, no high/critical | exit 0, 0 vulns | PASS |
| `cargo deny check` | exit 0 | exit 0 (3 pre-existing harmless `license-not-encountered` warnings) | PASS |
| Full regression suite | 0 unexpected failures | 1483 pass / 0 fail / 18 gated-ignored | PASS |
| `generate_state` unit tests | all green | 3/3 green | PASS |
| Purity boundary | preserved | N/A (effectful function pre- and post-bump) | PASS |
| Semgrep | optional | not installed; manual review clean | PASS (waived) |
| Kani | optional | NO-OP (no pure-core surface in diff) | PASS (waived) |
| Fuzzing | optional | NO-OP (no parsing/input-validation surface in diff) | PASS (waived) |

**Verdict: PASS — Phase F6 complete for issue #327.**

---

## 7. Carry-Forward to F7

Items the F7 (delta convergence + PR description + merge) phase should incorporate:

1. **PR description should mention the upstream soundness fix in rand 0.10.1** (`Rng::sample` Send/Sync trait bounds tightened) for transparency — even though `jr` was already on a safe call pattern in rand 0.9 (verified during F1 against `.factory/research/rand-0.10-perplexity-verification.md`). The mention prevents reviewer confusion about why the PR exists ("did they hit the GHSA bug?" → no, this is hygiene + tracking upstream).

2. **The `deny.toml` comment block** (lines 57-69, +13 lines, non-executable) must land with the PR as-is. It documents why `cargo deny check` does NOT flag the rand 0.9 / 0.10 lockfile dual-presence and provides forward guidance for a future cargo-deny upgrade that might start flagging this (instructions: add paired `[[bans.skip]]` entries at that point with actual root-cause text). Reviewer-facing rationale block; do not strip.

3. **`Cargo.lock` auto-resolution** is part of the diff (`+50 / -6` from the lockfile). This is expected — `cargo build` regenerated the lock when `rand = "0.9"` → `"0.10"` in `Cargo.toml`. The `rand 0.9.4` lockfile entry that remains is a transitive cross-platform/feature placeholder for proptest, not a real dependency in the active build graph (verified by `cargo tree`).

4. **`.cargo/mutants.toml` scope (advisory):** the policy file does not include `src/api/auth.rs` in `examine_globs`. This means future PRs to `auth.rs` will also report "No mutants to filter" on the `--in-diff` canonical command. If the project wants `auth.rs` under hard mutation pressure going forward, that's a separate `docs/specs/cargo-mutants-policy.md` scope change — out of scope for #327 but worth noting for backlog triage. For this story the augmented direct-file run (Section 1) provides the equivalent kill-rate evidence.

5. **No new `JR_*` env-var seam added** — CLAUDE.md `JR_*` documentation block does not need an update for this PR.

6. **No CHANGELOG entry required** — this is a dependency-hygiene maintenance change with no user-observable behavioral delta. The 64-hex-char OAuth state contract (BC-1.5.035) is unchanged. Per project convention (CLAUDE.md, "When changing `DEFAULT_OAUTH_SCOPES`" section by analogy), CHANGELOG entries are reserved for user-observable changes; this PR has none.
