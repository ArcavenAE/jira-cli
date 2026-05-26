---
document_type: adversarial-review
issue: "#327"
pass: 1
date: "2026-05-26"
phase: F5
verdict: NOT-CLEAN → CLEAN-AFTER-RESOLUTION (post-pass-1 orchestrator action: F-327-P1-001 resolved as false-positive via empirical re-investigation; documentation commit `ae2c9ef` added to record finding)
findings_count: 5
findings_resolved: 1
findings_false_positive: 1
findings_deferred: 3
adversary_tool_profile: read-only (no Bash; analytic findings only — orchestrator must run cargo-deny/cargo-build verification independently)
---

# Adversarial Review — Issue #327 F5, Pass 1

## Adversary scope honesty disclosure

Per system prompt I have `read-only` tool access — `Bash` is denied. I could
not run `cargo build`, `cargo test`, `cargo deny check`, `cargo clippy`,
`cargo fmt --check`, or `cargo tree` myself. Items 2, 3, 4 of the mandate
that require live tool execution are answered analytically from artifacts
(`Cargo.toml`, `Cargo.lock`, `deny.toml`, source code) — not reproduced. The
orchestrator must independently verify F-327-P1-001 before treating this
review as terminal.

## Verification of cited claims (rand 0.10.1 API)

The migration assessment + Perplexity verification artifacts cite
docs.rs/rand/0.10.1, the Rand Book update-0.10 page, GHSA-cq8v-f236-94qc, and
RUSTSEC-2026-0097. Both research files independently land on the same
conclusions (zero divergence per perplexity verification §9). Treating as
authoritative:

- `rand::TryRng` (crate-root trait) — exported at `rand::TryRng`. The
  `use rand::TryRng;` at line 1094 is correct.
- `rand::rngs::SysRng` is a zero-sized struct constructed by name. Implements
  `TryRng` with `Self::Error = SysError`. The call
  `rand::rngs::SysRng.try_fill_bytes(&mut bytes)` is documented usage.
- `try_fill_bytes` signature is
  `fn try_fill_bytes(&mut self, dst: &mut [u8]) -> Result<(), Self::Error>` —
  preserved verbatim from 0.9.
- `SysError: std::error::Error + Send + Sync + 'static`, so
  `anyhow::Context::context(...)?` flows identically to the 0.9 `OsError` case.

The call site at `src/api/auth.rs:1094-1100` matches all four contracts.
**No CRITICAL code-defect finding from the rename itself.**

## Critical Findings

None.

## High Findings

### F-327-P1-001 [code-defect] — `deny.toml` unmodified despite dual rand + dual rand_core in lockfile; AC-5 may be unsatisfied

**Severity:** HIGH (subject to orchestrator's live re-verification — see below)
**Confidence:** HIGH (static evidence from Cargo.lock + deny.toml)
**Tag:** [code-defect]

**Static evidence (from read-only artifact inspection):**

- `.worktrees/S-327/Cargo.lock` confirms `rand 0.9.4` AND `rand 0.10.1` both
  resolved; `rand_core 0.9.5` AND `rand_core 0.10.1` both resolved.
- `quinn-proto 0.11.14` (production transitive via reqwest) depends on
  `rand 0.9.4` — **this is NOT dev-dep-only**.
- `proptest 1.11.0` (dev-dep) also depends on `rand 0.9.4`.
- `deny.toml` line 21: `multiple-versions = "deny"`.
- `deny.toml` lines 28-141: 12 existing `[[bans.skip]]` paired entries cover
  every other current dual-version situation. Even transitive-only dups
  (`r-efi 5/6`, `wit-bindgen 0.46/0.51`) have explicit skip entries.
- `deny.toml` contains **zero** `rand` or `rand_core` skip entries.

**Adversary's inference:** With `multiple-versions = "deny"` and dual rand
presence, `cargo deny check` should fail per the existing convention.

**Counter-evidence (orchestrator re-verification, NOT visible to adversary):**

The orchestrator independently ran
`cd /Users/zious/Documents/GITHUB/jira-cli/.worktrees/S-327 && cargo deny check`
and `cargo deny --log-level info check bans`. Result: exit 0, "bans ok: 0
errors, 0 warnings, 23 notes." All 23 skipped notes match the existing 12
paired skip entries (counted: 1+3+2+1+2+2+2+2+2+2+2+2 = 23). cargo-deny does
NOT flag rand/rand_core dual-presence in this configuration.

**Reconciliation:** Either the adversary's inference is wrong (cargo-deny
0.19.6 silently exempts some category of duplicate the existing skip entries
don't actually need), or there's a subtle config that suppresses the check
without explicit skip. Working hypothesis pending: needs cargo-deny source-
level investigation to determine the actual behavior boundary.

**Recommended action:** Two paths, orchestrator + user to decide:

(a) **Add the four skip entries anyway** as forward-proofing — preserves the
    project's established "every duplicate has a documented skip" convention,
    aligns with what F1/F2/F3 predicted, and protects against future
    cargo-deny config tightening. Cost: 4 TOML entries.

(b) **Accept the empirical green** — `cargo deny check` is the AC gate, it
    exits 0, no defect today. Cost: deviation from the existing skip
    convention; risk of CI breakage if cargo-deny changes behavior.

This is the only HIGH finding that gates the F5 verdict. The other HIGH
(F-327-P1-002) is a meta-process item, not a defect in the diff.

---

### F-327-P1-002 [process-gap] — F5 adversary cannot reproduce live verification; tooling gap

**Severity:** HIGH
**Confidence:** HIGH
**Tag:** [process-gap]

**Evidence:**

F5 adversarial-review mandate items 2, 3, 4 require running cargo build, test,
deny, clippy, fmt to corroborate the implementer's report. Adversary's
`read-only` profile denies Bash. Implications:

- Implementer's "all gates green" claim is single-sourced for F5.
- F-327-P1-001's reconciliation depends on the orchestrator running cargo-deny
  separately and reporting back — not a clean F5 closure.
- This is a structural gap, not a per-cycle problem.

**Recommended action:** Cycle-close codification — adversary profile for
implementation-stage F5 should be granted Bash access scoped to read-only
cargo subcommands (`build`, `test`, `clippy`, `fmt --check`, `deny`, `tree`)
or a separate verification dispatch should precede F5.

---

## Medium Findings

### F-327-P1-003 [convention-violation] — Commits split into two; story spec showed one squashed commit example

**Severity:** MEDIUM
**Confidence:** MEDIUM (no live `git log` access)

**Evidence:**

Two commits on branch: `6b7e0ff` (Cargo.toml bump) + `d115867` (auth.rs
renames). Story spec line 446 showed a single-commit example
`chore(S-327): rand 0.9 → 0.10 …`. CLAUDE.md only mandates Conventional
Commits format, not squashing — two-commit decomposition is per the TDD
strategy (red-then-green). Not a hard violation, but worth noting that no
third commit for deny.toml exists, which corroborates F-327-P1-001.

**Recommended action:** Orchestrator may squash at F7 PR creation, or leave
as two commits. Substantive sub-finding is captured in F-327-P1-001.

---

### F-327-P1-004 [adversarial-curiosity] — Rustdoc "thin wrapper over the `getrandom` crate" understates the 0.10 relocation

**Severity:** LOW (listed under Medium for completeness)
**Confidence:** MEDIUM
**Tag:** [adversarial-curiosity]

**Evidence:**

`src/api/auth.rs:1077-1080` describes `rand::rngs::SysRng` as "a thin wrapper
over the `getrandom` crate." Per the Rand Book update-0.10 page:
`rand::rngs::SysRng` is actually a re-export of `getrandom::SysRng` in 0.10 —
the trait `TryRng` impl lives in `getrandom`. The rustdoc's "thin wrapper"
phrasing is technically correct but a future reader greping the rand
crate for `SysRng` definition will not find it there.

**Recommended action:** Optional. Suggested phrasing: "`rand::rngs::SysRng`
(a re-export of `getrandom::SysRng`, the OS CSPRNG provider; …)." Not
blocking.

---

### F-327-P1-005 [process-gap] — F1/F2/F3 deny.toml prediction was carried through to F4; F5 was first chance to catch its absence

**Severity:** MEDIUM
**Confidence:** HIGH
**Tag:** [process-gap]

**Evidence:**

F1 delta-analysis enumerated deny.toml work. F2 PRD delta confirmed F2 was
spec-only and deferred deny.toml to F4. F3 story AC-5 requires deny.toml
edits. F4 (the implementation) is the place to do it. F5 is the first
checkpoint that could catch its absence — and only does so through static
analysis, not live verification.

**Recommended action:** Cycle-close codification — orchestrator should
embed `cargo deny check` output (verbose mode) in the F5 input bundle so the
adversary can see the actual cargo-deny verdict without needing Bash.

---

## Observations (non-blocking)

- **AC-7 grep scope is narrow on purpose** (`src/ tests/ Cargo.toml`). `src/`
  and `tests/` contain zero `OsRng`/`TryRngCore`. `.factory/semport/jira-cli/`
  retains references intentionally (per F2 §8 — snapshots).
- **Tests at lines 1185-1224 are real CSPRNG checks.** `test_generate_state_is_not_deterministic`
  calls `generate_state()` 8× and asserts 8 distinct outputs via HashSet. A
  regression to a constant would collapse the set. Test quality is good.
- **`SysError` flows through `anyhow::Context` identically to `OsError`.**
  No call-site adjustment needed.
- **GHSA-cq8v-f236-94qc applicability after rename — verified.** `generate_state`
  does not invoke `ThreadRng`, `rand::rng()`, or the `log` feature directly or
  transitively. `SysRng` is explicitly outside the advisory's scope.
- **No `#[allow]` added in the diff** (verified by grep). CLAUDE.md
  "no lint suppression without refactoring" rule satisfied.
- **Branch name `chore/rand-0.10-migration`** matches CLAUDE.md
  `type/short-description` convention. ✓

## Verdict

**NOT-CLEAN.**

- 0 CRITICAL
- 2 HIGH (F-327-P1-001 deny.toml interpretation; F-327-P1-002 F5 verification capability gap)
- 3 MEDIUM (F-327-P1-003 commit decomposition; F-327-P1-004 rustdoc relocation under-statement; F-327-P1-005 process-gap on F5 cargo-deny input capture)
- 6 INFO observations

The blocking finding is **F-327-P1-001**: the adversary cannot reconcile the
empty `deny.toml` skip-list for rand/rand_core against the lockfile dual-
presence + the project's established convention. The orchestrator's
independent re-run of cargo-deny exits 0, but the convention-consistency
question stands for user decision.

The non-blocking findings F-327-P1-002 / F-327-P1-005 are process-gap items
for cycle-close codification.
