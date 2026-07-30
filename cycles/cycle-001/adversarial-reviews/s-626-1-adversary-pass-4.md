---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-07-30T22:05:26Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .github/workflows/ci.yml
  - .github/workflows/sign-and-publish.yml
  - .github/workflows/backfill-release.yml
  - .github/workflows/release.yml
  - .github/workflows/e2e.yml
  - .github/workflows/e2e-sweeper.yml
  - Cargo.toml
  - Cargo.lock
  - CHANGELOG.md
  - CLAUDE.md
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - src/cli/auth/keychain.rs
  - tests/team_column_parity.rs
input-hash: "87c8745"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 4
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-07-30
feature_head: 64cdb59ba04d7547a3708f1bf643ae5bb5ee6e7b
pr: 667
verdict: NOT CLEAN — 4 LOW + 1 INFO; zero MEDIUM+; zero code defects
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-3.md
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 4

## Preflight

Tuple verified with no mismatch — `git rev-parse HEAD` → `64cdb59ba04d7547a3708f1bf643ae5bb5ee6e7b`, 11 commits over merge-base `acdad17427a057d1e022669303cb80d5f48449c9`; factory HEAD `d0f334d077c15c8de80417e690f90506d5424ce0`. Every tuple element checked out. (Contrast pass 3, where the orchestrator's embedded SHA was fabricated beyond its 8-char prefix.)

---

## ADV-P4-LOW-001 — three in-tree comments cite a CLAUDE.md gotcha that does not contain the cited constraint; no convention forbids let-chains
**GAP · in-delta**

`src/cli/board.rs:231`, `src/cli/issue/list.rs:523`, `src/cli/auth/keychain.rs:50` each read `// Nested if (not a let-chain): let-chains require Rust >= 1.88 + edition 2024; MSRV is 1.85. See CLAUDE.md toolchain gotcha.` The gotcha at `CLAUDE.md:218` is entirely about rustup override precedence, the version-branch SHA and the `toolchain:` input. `grep -in "let-chain\|let chain" CLAUDE.md` → **zero occurrences**. The pointer resolves to text that does not support the claim attached to it.

Substantive half: the recurrence-prevention rule for this story's *headline in-tree defect* — "do not write let-chains; MSRV is 1.85" — is codified nowhere durable. It lives only in three comments at the three already-fixed sites, i.e. exactly where it can no longer prevent anything. The Conventions section has the natural slot alongside `No unsafe code` and `No lint suppression without refactoring`. Recurrence is not hypothetical: `docs/superpowers/plans/2026-04-23-team-field-object-shape-tolerance.md:111` already recorded *"let-chain syntax … stabilized in Rust 1.88 and breaks the crate's MSRV of 1.85"* in April 2026 — and three let-chains landed anyway.

Mitigating, and why LOW not MEDIUM: the `msrv` job (in `ci-gate.needs`) now genuinely catches let-chains in `src/` lib+bins, where all three were. The automated backstop is closed; this is authoring-ergonomics / defence-in-depth. Not an implementation deviation — AC-6 required only precedence documentation, so it is an AC-coverage gap.

---

## ADV-P4-LOW-002 — the ci.yml scope comment's final warning names an unreachable failure mode
**GAP · in-delta (introduced by fix-round commit `15597e84`)**

`.github/workflows/ci.yml:78-82` warned that a let-chain in an inline `#[cfg(test)]` module *"would pass this job but fail `cargo test` at 1.85.0."* Five lines earlier the same block establishes that dev-dependencies cannot compile at 1.85.0 — so `cargo test` at 1.85.0 fails unconditionally at wiremock before reaching any in-tree test module. Verified empirically at HEAD: `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-targets --locked` → exit 101, `E0658` at `wiremock-0.6.5/src/matchers.rs:214` and `:215`; the narrower `cargo test --lib --no-run --locked` → exit 101, same error. Unreachable in *every* form of `cargo test`.

The gap warned about is real (inline `#[cfg(test)]` code is unvalidated at 1.85.0); the consequence attributed to it is not, and the implied remediation goal — keep `cargo test` green at 1.85.0 — is unachievable while a dev-dep requires 1.88. Accurate framing: in-tree `#[cfg(test)]` code sits outside the MSRV floor's enforceable scope and cannot be brought inside until dev-deps support 1.85.

The block's other two factual claims are **correct** and were verified: wiremock 0.6.5 does use a let-chain and ships no `rust-version` (only `edition = "2024"`); the crate has no `[features]` table.

---

## ADV-P4-LOW-003 — the story's Delivery Checklist mandates a CHANGELOG sentence that is false as written; the implementation correctly omitted it, leaving the item unsatisfied and unrecorded
**GAP · spec artifact**

`.factory/stories/S-626-1.md:452-453` requires the entry record *"**User impact:** None for binary users or source-builders on Rust ≥1.85.0. The behavior of `comfy-table` (table rendering) is unchanged between 7.2.1 and 7.2.2."* Delivered `CHANGELOG.md:23-28` includes the first sentence and omits the second. **The omission is correct.** comfy-table's own CHANGELOG for 7.2.2 lists two genuine fixes — *"Fixed an edge-case, where multiple LowerBoundary constraints weren't uphold"* and *"Fixed an issue where tables were misformatted when no vertical border styling was specified"* (PR #198). "Behavior unchanged between 7.2.1 and 7.2.2" is therefore false as an unqualified claim.

It **is** true for `jr`, verified rather than assumed — this was the adversary's main MEDIUM candidate and came out clean: PR #198's fix only changes output where `should_draw_vertical_lines(table)` is false (7.2.2 gates the middle-intersection insert on it: `if !first && draw_vertical_lines`); `src/output.rs:9` loads `UTF8_FULL_CONDENSED` = `"││──╞═╪╡┆    ┬┴┌┐└┘"`, whose `┆` sets `VerticalLines`, so the predicate is **true** and the fix is a no-op here; the other `borders.rs` change is a pure reordering, logically equivalent under case analysis on `part_iter.peek().is_some()`; `grep -rn "Constraint" src/` → zero, so the LowerBoundary fix is irrelevant to `jr`.

So `User impact: None` **as delivered** is accurate and the downgrade does not regress rendering. The risk is forward-looking: a future fix round "completing" the checklist item would publish a false claim. Remedy is to amend the story's mandated wording to be jr-scoped, not to add the sentence.

**[process-gap]:** the Delivery Checklist mandated an unqualified upstream-behaviour claim without anyone reading the upstream CHANGELOG. Same shape as the rule v1.6 codified — *"provenance verification that classifies a pin without reading the pinned artifact is incomplete"* — written for SHA pins and applying identically to version pins. Generalise the codified rule rather than logging a second instance.

---

## ADV-P4-LOW-004 — dtolnay pin trailing comments name a toolchain where every other pin in the same files names the action version
**REFINEMENT · pre-existing pattern touched in-delta**

All 7 sites carry `# stable` or `# 1.85.0`. Every other 40-char pin in `ci.yml` annotates the **action** version: `actions/checkout@3d3c… # v7.0.1`, `Swatinem/rust-cache@e18b… # v2`, `step-security/harden-runner@bf74… # v2.20.0`, `codecov/codecov-action@fb8b… # v6`, `gitleaks/gitleaks-action@e0c4… # v3.0.0`, `EmbarkStudios/cargo-deny-action@3c63… # v2`.

Consequence: the pinned action's version stays unrecoverable from the pin line — the precise opacity that let a version-branch SHA masquerade as a master pin through 84 F2 passes, three Step 4.5 passes and a PR review. And `# 1.85.0` is now redundant with `toolchain: "1.85.0"` two lines below while contributing nothing about the action. Counter-precedent exists (`taiki-e/install-action@e5de… # cargo-llvm-cov` annotates purpose), so the convention is not absolute — hence LOW. Not covered by any AC: AC-4 audited whether `# 1.85.0` *agreed with* the toolchain input, i.e. it validated the toolchain-naming convention rather than questioning it.

---

## ADV-P4-INFO-005 — [process-gap]: the stated let-chain detection method is incomplete

The orchestrator's confirmed-invariant list included *"`grep '&& let'` across `src/`, `tests/`, `build.rs` returns nothing"*. That detector catches only the **condition-first** form (`… && let Some(x) = …`) and misses the **let-first** form — exactly what `src/cli/auth/keychain.rs` had:
```rust
if let Ok(v) = std::env::var(env_name)
    && !v.is_empty()
```
and exactly what comfy-table 7.2.2 uses. The adversary's own first grep of comfy-table 7.2.2 for `&& let` returned zero and it nearly filed a false "the let-chain claim is unsubstantiated" finding; compiling the crate at 1.85.0 is what caught it (`E0658` at `arrangement/disabled.rs:21` and `formatting/content_format.rs:101`, both let-first).

It then ran the complete set (`&& let`; `^\s*&&`; `(if|while) let .*=.*&&`; `^\s*||`) across `src/`, `tests/`, `build.rs`, reading 4 lines of preceding context for each of the 34 form-B hits in `src/` — all plain boolean continuations, not let bindings. So the invariant's **conclusion holds**; the **method stated for it does not**. Flagged because that grep is the natural thing S-640-1 or a future maintainer would reuse, and it silently under-reports.

*(Orchestrator confirmation: on `origin/develop`, `grep -c '&& let'` against `keychain.rs` → **0**; `grep -cE '^\s+&& '` → **1**. The cited grep was structurally incapable of finding one of the three defects it was said to prove absent.)*

---

## Verified Clean — Claims Checked and Found Accurate

**Provenance (AC-1):** `gh api` on `fa04a1451ff1842e2626ccb99004d0195b455a88` → date `2026-06-30T15:43:18Z`, message `Add 1.96.1 patch release`; `compare …master` → `behind_by: 0, ahead_by: 1`. Confirmed master ancestor.

**The "hard-required input / fails loudly" claim is correct** — the pinned `action.yml` was read rather than trusting `required: true` metadata (which GitHub does not enforce). The composite's first step guards explicitly and cites the runner issue: `if [[ -z $toolchain ]]; then # GitHub does not enforce 'required: true' inputs itself. https://github.com/actions/runner/issues/1070 / echo "'toolchain' is a required input" >&2 / exit 1`. The same file corroborates the confirmed E0463 root cause and the F4 assessment: `rustup toolchain install <tc> --target … --profile minimal` then `rustup default <tc>` (the latter `continue-on-error: true`) — targets land on the named toolchain, and `rustup default` is the rank the toml outranks.

**AC-2/AC-5/AC-7:** 7 SHA sites, all full 40-char; `grep -rn "c93f4f9c"` repo-wide (excluding `.git`/`target`) → zero. All 6 `# stable` sites carry `toolchain: stable`. Three `rustup target add` steps present and unchanged (`release.yml:46`, `backfill-release.yml:80`, `sign-and-publish.yml:65`). No other workflow installs Rust without a dtolnay pin.

**AC-8/AC-9 semantics:** pin is `comfy-table = "=7.2.1"` with `# See: issue #626.` and no `.factory/` path; `rust-version = "1.85"` unchanged; README badge 1.85; no stale `1.88` references. All three rewrites semantically equivalent by case analysis — `if A && let Some(x)=B {I} else {E}` → `if A { if let Some(x)=B {I} else {E} } else {E}` with `E = Vec::new()` in both arms (board.rs, list.rs); keychain fall-through preserved. The two new tests are non-vacuous (anchored on `Assignee`/`Summary`; issue summaries use lowercase "team" so no substring collision with the `"Team"` header) and both pass.

**Gates re-run independently:** `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features --locked` → exit 0 under `rustc 1.85.0 (4d91de4e4 2025-02-17)`; `cargo fmt --all -- --check` → 0; `cargo clippy --all-targets -- -D warnings` → 0 (clean because `rust-version = "1.85"` keeps MSRV-aware `collapsible_if` quiet — load-bearing for S-640-1); `cargo test --all-features` → **2343 passed / 0 failed / 100 ignored**; `cargo deny check` → all four sections ok; `cargo test --test claude_md_citations` → 61 passed (the new gotcha introduces no dead citation).

**Live CI proof the false-green is actually fixed:** run `30581732754` at `64cdb59b`, all 15 checks SUCCESS including `MSRV (1.85.0)` and `Mutation testing`; PR #667 MERGEABLE onto `develop`. The msrv job log shows `rustup toolchain install 1.85.0 --profile minimal --no-self-update` → `1.85.0-x86_64-unknown-linux-gnu installed - rustc 1.85.0 (4d91de4e4 2025-02-17)`, and the check step's env block contains `RUSTUP_TOOLCHAIN: 1.85.0`. **This is the end-to-end evidence the story's core claim was previously missing.**

**On routed ADV-P2-INFO-001 (rust-cache key derived under stable)** — not re-litigated, but bounded for S-641-1: it cannot produce a false-green, because cargo's fingerprint includes the rustc version, so any artefact built by a different toolchain is rebuilt regardless of cache key. Cache-efficiency issue only.

---

## Adversary's Assessment (verbatim)

Four LOW findings, no MEDIUM or above, and — for the third consecutive round — **zero code defects**. The code has been correct since `20d533e4` and nothing was found to contradict that. This was the first pass where the causal model held up under independent verification, and it held: four attempts to break the mechanism narrative (the wiremock claim, the `[features]` claim, the "hard-required input" claim, the comfy-table behavioural-equivalence claim) all survived. Two of the four findings are residue of the fix rounds themselves (LOW-002 from `15597e84`, LOW-003 from the v1.6 checklist), consistent with the warning that remediation is a defect source. The other two sit in documentation/convention surfaces no AC ever gated — the pattern being that remaining defects hide in prose not covered by an acceptance criterion, now that the code and ACs are sound. None of the four blocks merge on its own.

---

## Round-4 Dispositions (orchestrator)

- **Fixed pre-merge, commit `4223ea09` pushed to #667:** LOW-001 (a `No let-chains` entry added to `CLAUDE.md` **Conventions** — beside `No unsafe code` and `No lint suppression without refactoring` — and all three in-code comments re-pointed at it, so the rule now sits where an author reads it *before* writing a let-chain rather than at the three already-fixed sites); LOW-002 (warning rewritten to the accurate "outside the MSRV floor's enforceable scope" framing). Orchestrator-verified: `grep -c 'No let-chains' CLAUDE.md` → 1; three comments cite Conventions; the unreachable `cargo test` claim → 0; tests 2343/0/100; msrv `--locked` clean; clippy clean; `claude_md_citations` 61 passed.
- **Routed to `.factory/`:** LOW-003 (checklist wording amended to be jr-scoped with the verification reasoning recorded; provenance rule generalised from SHA pins to version pins), LOW-004 (→ S-641-1, which already touches those lines), INFO-005 (invariant corrected; S-641-1's AC-2 guard must use the complete form set).
- **Convergence: 0 of 3.** Four passes, four NOT CLEAN, but severity ceiling fell MEDIUM → LOW and code defects have been zero for three rounds.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 0 |
| LOW | 4 |
| INFO | 1 |

**Overall Assessment:** NOT CLEAN — 4 LOW + 1 INFO; zero MEDIUM+; zero code defects

**Convergence: 0 of 3.** Four passes, four NOT CLEAN — severity ceiling fell MEDIUM → LOW; code defects zero for three rounds.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 4 |
| **New findings** | 5 (4 LOW + 1 INFO) |
| **Duplicate/variant findings** | 0 — all new |
| **Median severity** | LOW |
| **Trajectory** | pass 1 (5M+5L+3I) → pass 2 (3M+2L+2I) → pass 3 (3M+3L+2I) → pass 4 (0M+4L+1I) |
| **Verdict** | NOT CLEAN — 4 LOW + 1 INFO; zero MEDIUM+; zero code defects; round-4 dispositions committed; convergence 0/3 |
