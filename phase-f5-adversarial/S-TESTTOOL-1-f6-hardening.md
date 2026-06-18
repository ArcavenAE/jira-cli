# Phase F6 — Targeted Hardening Record: S-TESTTOOL-1

- **Story:** S-TESTTOOL-1 (test/config/docs tooling hardening — `examine_globs` expansion + keyring-gate fix)
- **Branch:** `chore/s-testtool-1-test-tooling-hardening`
- **Worktree:** `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-TESTTOOL-1`
- **Date:** 2026-06-18
- **Phase:** VSDD Feature Mode F6 (Targeted Hardening)
- **Result:** PASS — F6 COMPLETE

## Scope of the Delta

Diff vs `origin/develop` (`git diff origin/develop...HEAD`), 5 files, +111/-4:

| File | Class |
|------|-------|
| `.cargo/mutants.toml` | config (adds `src/api/jira/issues.rs` + `src/cache.rs` to `examine_globs`) |
| `CLAUDE.md` | docs |
| `docs/specs/cargo-mutants-policy.md` | docs |
| `docs/specs/multi-profile-auth.md` | docs |
| `tests/auth_profiles.rs` | tests (gate one keyring test `#[ignore]`; add one ungated substitute test) |

**No new or changed production `src/` code.** Verified via `git diff origin/develop...HEAD --name-only` — no path under `src/` appears. This is a test/config/docs-only delta.

## Formal Verification / Fuzzing / Property Testing — N/A (justified)

These hardening dimensions are **Not Applicable** to this delta, for a concrete reason rather than convenience:

- **Kani proofs — N/A.** Formal proofs establish properties of *production code* (overflow-freedom, bounds, state-machine invariants). The diff introduces zero new or changed production functions, expressions, or control flow. There is no new proof obligation to discharge. Fabricating a VP for unchanged code would violate the formal-verifier constraint against marking properties verified without a genuine obligation.
- **Fuzz testing — N/A.** Fuzzing targets new input-handling code paths. No new public interface, parser, or input-decoding path was added. The two newly-`examine_globs`'d files (`issues.rs`, `cache.rs`) are *pre-existing* code unchanged by this PR — they enter mutation scope, not fuzz scope, and only because the config (not the code) changed.
- **Proptest harnesses — N/A.** No new pure function with an algebraic property to assert. The added test (`test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64`) is a single deterministic exit-code assertion, not a property under randomized inputs.

This is explicitly documented to avoid fabricated proof obligations: there is nothing new to prove or fuzz.

## Full-Tree Hardening Gates

### Gate 1 — Full regression suite: PASS
Command: `cargo test --all-features` (exit 0)
- Aggregate across all test binaries: **1855 passed; 0 failed; 92 ignored.**
- Largest binary (lib unit tests): `test result: ok. 947 passed; 0 failed; 10 ignored; 0 measured; 0 filtered out`.
- Every `test result:` line reports `0 failed` (83 result-ok lines, zero FAILED lines).
- New ungated substitute test executed in default CI scope:
  `test test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64 ... ok`
  (recovers the global-`--profile`→`auth status` propagation coverage that was lost when
  `global_profile_flag_targets_auth_status` was keyring-gated under `#526-F6-KEYRING-GATE`).

### Gate 2 — Clippy (zero warnings): PASS
Command: `cargo clippy --all-targets --all-features -- -D warnings` (exit 0). No warnings, no errors.

### Gate 3 — Format check: PASS
Command: `cargo fmt --all -- --check` (exit 0). Clean.

### Gate 4 — Dependency / license audit: PASS (matches develop baseline)
Command: `cargo deny check` (exit 0). Result: `advisories ok, bans ok, licenses ok, sources ok`.
- **No new advisories.** `Cargo.toml` and `Cargo.lock` are byte-for-byte unchanged in this diff
  (verified: `git diff origin/develop...HEAD -- Cargo.toml Cargo.lock` is empty), so the dependency
  tree is identical to develop's baseline — confirmed.
- The 3 `license-not-encountered` lines (`BSD-2-Clause`, `OpenSSL`, `Unicode-DFS-2016`) are
  pre-existing **warnings** for allowance entries in `deny.toml` that no current dependency uses.
  They are baseline, not introduced by this delta, and do not affect the `ok` verdict.

### Gate 5 — Mutation testing (PR-diff scope): PASS — 0 mutants (expected)
Command: `DIFF_FILE=$(mktemp) && git diff origin/develop...HEAD > "$DIFF_FILE" && cargo mutants --in-diff "$DIFF_FILE" --jobs 4`
- Result: `INFO No mutants to filter` — **0 mutants generated.**
- Expected and correct: `--in-diff` intersects changed lines with `examine_globs` files. The diff
  changes lines only in `.cargo/mutants.toml`, `CLAUDE.md`, two `docs/specs/*.md`, and
  `tests/auth_profiles.rs` — none of which is an `examine_globs` source file. In-diff mutation is
  a no-op for this delta.

#### AC-001 mechanical proof — newly-scoped files ARE in baseline scope
`cargo mutants --list` (baseline scope, config-driven, no `--in-diff`):
- `src/api/jira/issues.rs` → **49 mutants** now listed.
- `src/cache.rs` → **80 mutants** now listed.

Both files are present in baseline mutation scope solely because this PR added them to
`.cargo/mutants.toml::examine_globs`. This is the mechanical proof that the config change
takes effect — the two HIGH-value modules (JRACLOUD-95368 anti-loop guard / `seen_keys`
dedup / `has_more` sentinel / cursor-vs-offset branch in `issues.rs`; TTL + per-profile path +
model-a/model-b error-handling split in `cache.rs`) are now subject to mutation testing on any
future PR that touches them.

### Gate 6 — Security review: PASS
- **No new `unsafe`.** No `src/` change at all; `git diff origin/develop...HEAD -G'unsafe' -- 'src/**'` empty.
- **No new dependencies.** `Cargo.toml`/`Cargo.lock` unchanged (see Gate 4).
- **No secret/credential material.** The added test uses placeholder URLs only
  (`https://default.example`, `https://sandbox.example`, profile name `ghost`); no real Jira
  keys, org IDs, instance URLs, tokens, or emails. Consistent with the no-real-data policy.
- `cargo deny` advisories check clean (Gate 4). No CRITICAL/HIGH findings → no security-reviewer escalation required.

## Quality Gate Summary

| Gate | Result | Proof |
|------|--------|-------|
| Kani / fuzz / proptest | N/A (justified) | zero new production code → no proof/fuzz obligation |
| Full regression (`cargo test --all-features`) | PASS | 1855 passed; 0 failed; 92 ignored (exit 0) |
| Clippy `-D warnings` | PASS | exit 0, zero warnings |
| `cargo fmt --check` | PASS | exit 0 |
| `cargo deny check` | PASS | advisories/bans/licenses/sources ok; no dep changes |
| Mutation `--in-diff` | PASS | 0 mutants (delta touches no `examine_globs` source) |
| AC-001 baseline scope | PROVEN | issues.rs=49, cache.rs=80 mutants now in scope |
| Security (unsafe/deps/secrets) | PASS | none added |

**Phase F6 status: COMPLETE.** All applicable full-tree gates pass; formal/fuzz/proptest correctly N/A for a test/config/docs-only delta; AC-001 mechanically proven.
