---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-07-30T19:17:32Z
phase: 5
inputs:
  - .github/workflows/ci.yml
  - .github/workflows/sign-and-publish.yml
  - .github/workflows/backfill-release.yml
  - .github/dependabot.yml
  - Cargo.toml
  - Cargo.lock
  - CHANGELOG.md
  - CLAUDE.md
  - README.md
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - src/cli/auth/keychain.rs
  - tests/team_column_parity.rs
  - .factory/stories/S-626-1.md
input-hash: "9dc6021"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 1
agent: adversary
basis: TRUE ADVERSARY AGENT (not a DEC-190 substitute) — first adversary application in this bundle
date: 2026-07-30
feature_head: 148a9489f3d0f213ed402caf4522ce04ea5ffad3
pr: 667
verdict: NOT CLEAN — in-delta GAPs present
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-step45-pass-c.md
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 1

## Header Context

Adversarial Review — S-626-1 (SOH-DX-1), Pass 1, adversary agent, first application. Scope: branch `ci/fix-toolchain-sha-msrv` @ `148a9489`, 8 commits over `origin/develop` @ `acdad174`, PR #667. All 14 changed files read in full. Story spec read from canonical `.factory/` (v1.3, 9 ACs). Worktree-identity preflight passed.

## Independent Verification Performed

Independent verification the adversary performed (not taken on trust): read all three `src/` let-chain rewrites in full surrounding context and found **all three semantically equivalent** — `board.rs::handle_view` and `list.rs::handle_list` both have the correct three-level `else { Vec::new() }` chain feeding `show_team_col = !team_displays.is_empty()`; `keychain.rs::resolve_credential` preserves fall-through on both the `Err` and empty-string paths. Grepped the old SHA repo-wide (not just the 6 workflow files): zero occurrences outside `.git`; new SHA present exactly 7× in exactly 6 files, so AC-2/AC-7 hold beyond their stated scope. Retrieved the pre-fix msrv job from `origin/develop` and the live CI logs for PR #667's msrv job (run `30570295998`, job `90965011883`). Perplexity-validated rustup's documented precedence order against `rust-lang.github.io/rustup/overrides.html`.

## Partial-Fix Regression Discipline — Prior-Pass Closures Verified

A-LOW-001 ✅ (two tests present with positive anchors so the negative assertion cannot pass vacuously), B-LOW-001 ✅ (`ci.yml:74-79`), B-LOW-002 ✅, F2 ✅ (`Cargo.lock` diff exactly 4 lines, comfy-table only), F4 ✅, F5 ✅ (`test_` prefixes present), F6 ✅. **F3 only half-remediated — see ADV-P1-LOW-001.**

## Finding ID Convention

Finding IDs use the format: `ADV-P<PASS>-<SEV>-<SEQ>` (no cycle prefix — no `.factory/current-cycle` file present in this project).

---

## Part B — New Findings

### MEDIUM

#### ADV-P1-MEDIUM-001: CLAUDE.md gotcha inverts rustup's own documented precedence order

- **Severity:** MEDIUM
- **Classification:** REFINEMENT · in-delta
- **Location:** `CLAUDE.md:218`
- **Description:** The gotcha states the toolchain file overrides `rustup default`, `rustup override`, and the `toolchain` input. Per the rustup book's ordered list, a directory override set with `rustup override` is #3 and `rust-toolchain.toml` is #4 — the override wins, not the file. It also states `RUSTUP_TOOLCHAIN` is "the highest-precedence override in the rustup precedence chain"; it is #2, the `+toolchain` command-line shorthand is #1. Matters beyond pedantry: this gotcha exists specifically to be the durable record of rustup precedence and is the artifact a future contributor (including S-640-1) will consult. The inverted claim also forecloses a valid alternative fix — a reader would conclude `rustup override set 1.85.0` cannot work, when in fact it outranks the toml. CLAUDE.md's own convention ("Perplexity-validate… keep paraphrasing rustdoc in lockstep") is the guard that should have caught this.

#### ADV-P1-MEDIUM-002: CLAUDE.md gotcha and CHANGELOG assert a pre-fix history that never happened

- **Severity:** MEDIUM
- **Classification:** REFINEMENT · in-delta
- **Location:** `CLAUDE.md:218`, `CHANGELOG.md:9-11`
- **Description:** Both read: the msrv job "installed Rust 1.85.0 via the action's `toolchain: "1.85.0"` input but then ran `cargo check` under stable." Verified against `origin/develop:.github/workflows/ci.yml` — the pre-fix step was a bare `- uses: dtolnay/rust-toolchain@c93f4f9c…  # 1.85.0` with **no `with:` block at all**. The action therefore read `rust-toolchain.toml` and installed **stable**; 1.85.0 was never installed and the toml never had to re-assert over anything. The described defect is the state that would exist after applying only half of this PR — not the state before it. The general mechanism claim is correct (per ADV-P1-MEDIUM-001's corrected ordering the toml does beat `rustup default`), so the fix is right and both flags genuinely are load-bearing, but the root cause is misattributed: the actual defect was a **missing input**, not an **insufficient input**. A reader debugging a future false-green will look for the wrong thing. The CHANGELOG line is user-facing.

#### ADV-P1-MEDIUM-003: The msrv gate resolves dependencies at run time instead of validating the committed lock

- **Severity:** MEDIUM
- **Classification:** GAP · in-delta
- **Location:** `ci.yml:80`
- **Description:** `- run: cargo check --all-features` carries no `--locked`. The live job log confirms: `Run cargo check --all-features / RUSTUP_TOOLCHAIN: 1.85.0 / Updating crates.io index / Compiling jr v0.6.0-dev.11`. Cargo contacted the index and was free to re-resolve. Two problems: (1) divergence from the story's own acceptance command — AC-8/AC-9 and the recorded verification both use `--locked`, so the CI gate runs a strictly weaker command and the thing proven locally is not the thing CI enforces; (2) soundness — this story exists because an unpinned dependency resolved past the MSRV floor, and a floor-validation gate that re-resolves rather than validating the shipped `Cargo.lock` can pass on a resolution that never ships, and with `Cargo.toml`/lock drift would silently rewrite the lock in-CI. Honest bounding: today's practical risk is nil — `=7.2.1` is exact and every other requirement is already satisfied by the committed lock, so no resolution change is possible right now; the risk is latent. Also noted: no job in `ci.yml` uses `--locked`, but `msrv` is the one job whose entire purpose is version-floor enforcement and where lock fidelity is the property under test.

#### ADV-P1-MEDIUM-004: The msrv job produces no evidence of which compiler actually ran

- **Severity:** MEDIUM
- **Classification:** GAP (verification) · in-delta
- **Location:** `ci.yml:74-82`
- **Description:** This story fixed a false-green caused by an unverified assumption about which toolchain was in use, and the fix rests on the same class of unverified assumption. The only artifact attesting to 1.85.0 at check time is the echoed `RUSTUP_TOOLCHAIN: 1.85.0` env line. There is no `rustc --version`, no assertion, and nothing that would go red if the env override silently stopped taking effect (an upstream rustup precedence change, a future step reordering, a shim change) — the job would go green exactly as it does today. This is a sharper, cheaper framing of the already-open F7 (no negative control). The self-evidencing half is a one-line addition: `- run: rustc --version && rustc --version | grep -q '^rustc 1\.85\.0 '` with `env: RUSTUP_TOOLCHAIN: "1.85.0"`. That makes the gate self-enforcing rather than merely self-documenting, and it fails loudly if the override mechanism ever stops working — the entire failure mode this story was opened for.

#### ADV-P1-MEDIUM-005: The MSRV floor is now asserted at eight-plus string sites with no drift guard

- **Severity:** MEDIUM
- **Classification:** GAP · in-delta (this PR added two of them)
- **Location:** `Cargo.toml` `rust-version`; `README.md:8` badge; `ci.yml:60` job name; `ci.yml:70` comment; `ci.yml:72` `toolchain:`; `ci.yml:82` `RUSTUP_TOOLCHAIN:`; plus mentions in the CLAUDE.md gotcha and the CHANGELOG
- **Description:** Nothing enforces agreement, and S-640-1 will have to change all of them atomically. This repo has an unusually strong established pattern for exactly this class — `scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh` (8-surface agreement), `tests/mutants_glob_existence.rs`, `tests/claude_md_citations.rs`, `tests/e2e_cli_surface_guard.rs`, `scripts/check-signing-workflow-injection.sh`. An MSRV/toolchain guard is the idiomatic missing member and the natural single home for ADV-P1-MEDIUM-003, ADV-P1-MEDIUM-004, F7 and ADV-P1-LOW-003: old SHA absent from `.github/workflows/`; every `dtolnay/rust-toolchain` step carries an explicit `toolchain:` input; msrv job's `toolchain:` == `RUSTUP_TOOLCHAIN:` == job-name version == `Cargo.toml` `rust-version` == README badge; `comfy-table` requirement is an exact (`=`) pin. Rides the existing `test` job with no CI YAML change, as `tests/claude_md_citations.rs` does. Recommended over the F7 negative-control framing — broader, cheaper, and covers the S-640-1 transition.

---

### LOW

#### ADV-P1-LOW-001: F3 is only half-remediated: `Cargo.toml` still cites an internal `.factory` story ID

- **Severity:** LOW
- **Classification:** REFINEMENT · in-delta · [partial-fix regression]
- **Location:** `Cargo.toml:21`
- **Description:** F3 removed a gitignored `.factory/research/…` path from the pin comment because it has no public referent. The replacement is `# See: issue #626, follow-up S-640-1.` — `#626` resolves publicly; **`S-640-1` does not**. It is a `.factory/stories/` identifier in a manifest published to crates.io and rendered on docs.rs. The same commit demonstrates the correct treatment: `CHANGELOG.md` deliberately writes "tracked as a dedicated follow-up story" without naming the ID. `Cargo.toml` and `CHANGELOG.md` are inconsistently redacted within one change. Suggest matching the CHANGELOG's phrasing, or filing a public GitHub issue for the MSRV raise and citing that number.

#### ADV-P1-LOW-002: No in-code marker at the three rewrite sites explaining why they are not let-chains

- **Severity:** LOW
- **Classification:** GAP · in-delta
- **Location:** `src/cli/board.rs` ~:231, `src/cli/issue/list.rs` ~:523, `src/cli/auth/keychain.rs` ~:50
- **Description:** All three sites now contain a nested `if` whose only reason for existing is the 1.85 floor, and none carries a comment saying so. This repo's convention is emphatic and pervasive about exactly this ("load-bearing", "do NOT unify", "Do NOT re-introduce"), and the story's own Previous Story Intelligence records the inversion trap: S-640-1 must put let-chains back where clippy asks for them. A contributor reading `board.rs` today sees an idiomatic-looking nested `if` with no signal, and the natural "modernization" silently violates the floor. Bounded severity: the msrv job now catches it — that is the point of this story — so the failure mode is a red CI job, not a shipped defect. Still, a one-line marker at each site converts a CI round-trip into a read.

#### ADV-P1-LOW-003: The `=7.2.1` pin has no dependabot `ignore` entry

- **Severity:** LOW
- **Classification:** GAP · in-delta
- **Location:** `.github/dependabot.yml`
- **Description:** Cargo dependabot is configured daily with a 7-day cooldown and updates exact (`=`) requirements. `comfy-table 7.2.2` is already published (it was in `origin/develop`'s lock), so cooldown has elapsed. Dependabot will therefore open — and, after each close, re-open — a PR bumping `=7.2.1` → `=7.2.2` until MSRV is raised. The failure mode is loud (red msrv job), not silent, so this is not a correctness hole. The concern is operational: recurring red-on-routine-dep-bump trains reviewers to discount a msrv failure, which is precisely the signal this story just made trustworthy. Either add an `ignore` entry for `comfy-table` until S-640-1 lands, or accept the churn deliberately and record that decision in the pin comment.

#### ADV-P1-LOW-004: AC-9's table contradicts both the story's own narrative and the implementation

- **Severity:** LOW
- **Classification:** REFINEMENT · in-delta
- **Location:** story metadata, `.factory/stories/S-626-1.md` AC-9 table
- **Description:** The row reads `src/cli/auth/keychain.rs | (multiple) | different shape; ~8 lines affected`. The implementation contains exactly one occurrence, and `CHANGELOG.md` correctly says the three files "each contained one let-chain". The story's own Problem Statement also says "Three occurrences" total, which is only consistent with one per file — so AC-9's table contradicts the narrative two sections above it. "Different shape" is also loose: `keychain.rs` is `if let Ok(v) = … && !v.is_empty()`, while board/list are `if matches!(…) && let Some(…) = …` — same construct class, mirrored operand order. The "each must be reviewed independently" instruction in EC-13 rests on a shape difference smaller than described. (The adversary did review each independently; all three are equivalent.)

#### ADV-P1-LOW-005: Version-form citation in the msrv scope comment will drift

- **Severity:** LOW
- **Classification:** REFINEMENT · in-delta
- **Location:** `ci.yml:76`
- **Description:** The comment pins the claim to `wiremock 0.6.5`. `Cargo.toml` declares the caret range `wiremock = "0.6"`, so the resolved version moves on the next dependabot bump and the citation goes stale silently. CLAUDE.md's citation-form convention prefers stable forms over drifting ones for exactly this reason. Suggest `wiremock (0.6.x)` or dropping the patch digit.

---

### INFO

#### ADV-P1-INFO-001

The msrv scope comment says `--all-targets` "pulls in dev-dependencies (tests, benches)". The crate has no benches. Harmless, but the parenthetical is inaccurate.

#### ADV-P1-INFO-002

Retaining `--all-features` "for explicitness" when there is no `[features]` table (confirmed absent) is what produced F4 in the first place — a no-op flag that a reader mistook for the operative scope limiter. The comment now correctly disclaims it, but removing the flag would remove the misreading permanently.

#### ADV-P1-INFO-003 — Mutation testing check gave zero signal on this PR

The job passed in 28s with `INFO No mutants to filter` (0 mutants, exit via the "non-empty diff / no mutable lines in examine_globs" branch). `src/cli/board.rs` and `src/cli/issue/list.rs` are not in `.cargo/mutants.toml` `examine_globs` — pre-existing, deliberate scope. Flagged so "Mutation testing pass" is not read as evidence about the `src/` rewrites or about the kill-power of the two tests added for A-LOW-001. The adversary independently confirmed semantic equivalence by reading all three sites and confirmed the new tests carry positive anchors (`Assignee`, `Summary`) so the `Team`-absent assertion cannot pass vacuously — which is why this stays INFO rather than becoming a verification finding.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 5 |
| LOW | 5 |
| INFO | 3 |

**Overall Assessment:** pass-with-findings — 10 in-delta findings (3 GAPs, 5 REFINEMENTs, 2 INFO, 0 CRIT/HIGH)

**Convergence:** FINDINGS_REMAIN — in-delta GAPs present; Step 4.5 window RESET

**Readiness:** requires revision (in-delta GAP class)

---

## Notes on Scope Framing (not findings)

The frontmatter discrepancy (`feature_type: infrastructure` / `target_module: .github/workflows/ci.yml` vs 3 `src/` files) was flagged to the adversary as deliberately preserved for auditability; it concurs that leaving it is defensible, noting only that `target_module` is **singular and wrong** rather than merely understated, and `test_files: []` is now false (`tests/team_column_parity.rs` was modified). If any tooling consumes `target_module` or `test_files` it will consume wrong values. C-LOW-001 remains correct as filed: `files_modified` omits `CHANGELOG.md` — and also omits `tests/team_column_parity.rs`. The story carries no BC anchors; for a change that now modifies output-formatting code paths in two commands, the absence of any BC/VP anchor means the two new tests are the sole traceable contract — noting the consequence, not disputing the ruling. **No security-relevant finding:** full 40-char SHA form at all 7 sites; replacement SHA matches AC-1 verbatim; `rustup target add` steps at `sign-and-publish.yml:~64` and `backfill-release.yml:~79` and their E0463 comments present and unchanged (AC-5 holds).

---

## [process-gap] PG-ADV-DISPATCH-001

Adversary dispatch instructions told it to "return findings as chat text in your final message" and explicitly not to write a file. As an agent teammate its plain text output is not visible to the orchestrator; `SendMessage` is the only channel. Its first attempt therefore evaporated silently — no artifact, no delivery, and from the orchestrator's side indistinguishable from an idle agent. **Recommend the dispatch template say "return findings via SendMessage to the dispatching agent" rather than "as chat text in your final message". The read-only constraint is fine and should stay; only the delivery instruction is wrong.** This is the genuine upstream item for drbothen/vsdd-factory, replacing the retired invalid `ENGINE-ADVERSARY-TWO-BUGS`.

---

## Post-Pass Routing (orchestrator-recorded)

- **Six findings fixed** on `20d533e4` (pushed to #667), orchestrator-verified: ADV-P1-MEDIUM-001 (ADV-M1), ADV-P1-MEDIUM-002 (ADV-M2), ADV-P1-MEDIUM-003 (ADV-M3), ADV-P1-LOW-001 (ADV-L1), ADV-P1-LOW-002 (ADV-L2), ADV-P1-LOW-005+ADV-P1-INFO-001 (ADV-L5+ADV-I1).
- **Four routed** to a new guard story being registered concurrently: ADV-P1-MEDIUM-004 (ADV-M4), ADV-P1-MEDIUM-005 (ADV-M5), ADV-P1-LOW-003 (ADV-L3), plus F7 folded in.
- **ADV-P1-LOW-004 (ADV-L4)** routed to a story-metadata correction, in flight.
- **Step 4.5 window RESET** on the in-delta GAPs. Convergence is NOT re-declared off a fix round; a fresh confirming pass is required.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 1 |
| **New findings** | 13 (5 MEDIUM + 5 LOW + 3 INFO) |
| **Duplicate/variant findings** | 0 — first adversary application to this bundle |
| **Novelty score** | 1.0 (13/13) |
| **Median severity** | LOW |
| **Trajectory** | N/A → pass 1 (first adversary pass; prior Step 4.5 passes were code-reviewer aperture only) |
| **Verdict** | FINDINGS_REMAIN — 3 in-delta GAPs (ADV-P1-MEDIUM-003, ADV-P1-MEDIUM-004, ADV-P1-MEDIUM-005) unresolved at time of capture; post-capture 6 fixed + 4 routed per Post-Pass Routing above. The adversary states explicitly: "I would not treat pass 1 as converged." |
