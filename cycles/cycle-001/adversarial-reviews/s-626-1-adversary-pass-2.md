---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-07-30T20:28:01Z
phase: 5
inputs:
  - .factory/stories/S-626-1.md
  - .github/workflows/ci.yml
  - .github/workflows/sign-and-publish.yml
  - .github/workflows/backfill-release.yml
  - .github/workflows/release.yml
  - Cargo.toml
  - Cargo.lock
  - CHANGELOG.md
  - CLAUDE.md
  - src/cli/board.rs
  - src/cli/issue/list.rs
  - src/cli/auth/keychain.rs
  - tests/team_column_parity.rs
input-hash: "a821bee"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 2
agent: adversary
basis: TRUE ADVERSARY AGENT (not a DEC-190 substitute)
date: 2026-07-30
feature_head: 20d533e45e42eaf08b4f2d172fe8b86a8490fb44
pr: 667
verdict: NOT CLEAN — 3 MEDIUM GAPs (all spec-artifact; zero code changes required)
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-1.md
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 2

## Header

Adversary pass 2, S-626-1 @ `20d533e4`, PR #667. Worktree identity confirmed: `git rev-parse HEAD` = `20d533e45e42eaf08b4f2d172fe8b86a8490fb44`, 9 commits over `origin/develop`, no `.factory/` in worktree; spec read from canonical `.factory/stories/S-626-1.md` (v1.4). Delivered via `SendMessage` on first attempt — no nudge required, confirming `PG-ADV-DISPATCH-001` was the sole cause of pass 1's non-delivery.

**Bottom line: 3 MEDIUM + 2 LOW + 2 INFO. Zero require a code change.** All three MEDIUMs are story/doc-artifact defects. The shipped code is correct, verified independently including against the live CI log.

---

## Pass-1 fix verification (Partial-Fix Regression Discipline)

All six claimed fixes propagated. Two overshot or left a sibling untouched — see MEDIUM-002 and MEDIUM-003.

- **MEDIUM-001 rustup precedence** — FIXED, correct. Chain reads `+toolchain > RUSTUP_TOOLCHAIN > directory override > rust-toolchain.toml > rustup default`, matching rustup's documented order; `rustup override` removed from the "overridden by toml" list; "highest-precedence" softened. Residual imprecision → LOW-001.
- **MEDIUM-002 fabricated pre-fix history** — FIXED in both files; both now state the pre-fix job had a bare `uses:` with no `with:` block. Cross-checked against the actual diff — the pre-fix line *was* bare. Accurate. But the same defect class survives untouched in three workflow comments → MEDIUM-003.
- **MEDIUM-003 `--locked`** — FIXED and confirmed live. Run `30573809646` job `90976940731` step env shows `cargo check --all-features --locked` with `RUSTUP_TOOLCHAIN: 1.85.0`.
- **LOW-001 `S-640-1` in manifest** — FIXED but overshot → MEDIUM-002.
- **LOW-002 in-code markers** — FIXED. Identical one-line comment at all three sites, each directly above the rewritten construct.
- **LOW-005 + INFO-001** — FIXED. Comment reads `wiremock (0.6.x)`; no "benches".

**Independent checks that came back clean (no findings raised):** AC-2/AC-7 (all 7 occurrences across 6 files on the full 40-char `fa04a145…`; `c93f4f9c` returns zero matches repo-wide); AC-4 (`# 1.85.0` comment + job name `MSRV (1.85.0)`); AC-5 (all three defensive `rustup target add` steps + E0463 comments present and byte-unchanged — **note `release.yml` has a fourth that AC-5 does not enumerate**); `Cargo.lock` diff is comfy-table-only (4 lines) so the `deny check bans` hazard is avoided; **`msrv` IS in `ci-gate.needs`** — checked specifically because a fixed-but-unwired job would be a deeper false-green than the one being fixed; `grep '&& let'` across `src/`, `tests/`, `build.rs` returns **nothing**, so AC-9's "three occurrences" is complete tree-wide.

**Semantic equivalence of all three rewrites: verified by case analysis, all equivalent.** `keychain.rs` — outer `if let Ok(v)` / inner `if !v.is_empty()`, no `else` on either, fall-through identical. `board.rs:232-260` and `list.rs:524-555` — `if A && let Some(x)=B {I} else {E}` → `if A { if let Some(x)=B {I} else {E} } else {E}`; all three input cases map identically, `E` is `Vec::new()` in both arms. All three sites read in full rather than trusting the diff shape.

---

## ADV-P2-MEDIUM-001 — Story's literal pin syntax is a caret range and would reintroduce the exact defect the story fixes
**GAP · in-delta (spec artifact) · MEDIUM**

`Cargo.toml` at HEAD is correct: `comfy-table = "=7.2.1"`. **The story says `"7.2.1"`** — which in Cargo is `^7.2.1` and resolves to 7.2.2. Four sites, one self-contradictory on its own line: AC-8 heading ("pins `comfy-table = "7.2.1"` (exact, not a caret range)" — the quoted value *is* a caret range); Task 7a code block; Architecture Mapping row; Library & Framework Requirements. EC-10 enumerates the drift shapes as `"^7"` or `">=7.2.0"`, omitting bare `"7.2.1"` — the same caret range, and the shape a reader is most likely to type after reading AC-8. This is the spec-of-record for a story whose entire purpose is preventing a silent resolution to 7.2.2. Anyone re-deriving the manifest from it — a revert-and-reapply, or S-640-1's author reading AC-8 to decide what to unpin — reintroduces the bug, and CI stays green until the next `cargo update`. Fix: `=7.2.1` at all four sites; add bare `"7.2.1"` to EC-10's enumerated failure shapes.

*(Orchestrator note: verified 7 occurrences, not 4.)*

---

## ADV-P2-MEDIUM-002 — Fixing ADV-P1-LOW-001 stripped a citation that AC-8 still mandates; AC-8 now fails at HEAD
**GAP · in-delta · MEDIUM · Partial-Fix Regression**

Pin comment evolution: `3a3fd74a` → `# Ref: .factory/research/msrv-let-chains-comfy-table-2026-07-30.md`; `148a9489` → `# See: issue #626, follow-up S-640-1.`; `20d533e4` → `# See: issue #626.`. AC-8 still reads: "The pin entry in `Cargo.toml` carries an inline comment citing `.factory/research/msrv-let-chains-comfy-table-2026-07-30.md`". **That AC is unmet at HEAD.** The code is right — LOW-001's point was not to publish internal `.factory` paths in a manifest that ships to crates.io, and `issue #626` is the correct public-durable substitute. The AC was never reconciled, so the Delivery Checklist cannot be honestly signed. Fix: amend AC-8 to require a public-durable citation and record LOW-001's ruling in the version trail (the v1.4 / ADV-P1-LOW-004 pattern).

---

## ADV-P2-MEDIUM-003 — Three "defensive rustup target add" comments assert a mechanism the delta visibly falsifies; AC-5 froze them so nobody reconciled it
**GAP · pre-existing root, newly aggravated by the delta · MEDIUM · [process-gap]**

`release.yml` ~:43, `sign-and-publish.yml` ~:58, `backfill-release.yml` ~:73 all say: *"rust-toolchain.toml pins channel = "stable", which overrides the toolchain dtolnay/rust-toolchain installs above."* This PR added `toolchain: stable` on the immediately-preceding step — so the two toolchain identifiers are now the same literal string, and the comment reads as self-contradictory to anyone scanning the file. The pinned action's actual behavior was checked rather than assumed: its own parse script (visible in the msrv job log) resolves `stable` via the `else echo "toolchain=$toolchain"` branch and passes `--target` to that same `rustup toolchain install`. Perplexity confirms `targets:` installs onto the toolchain the action selected, and that an explicit `toolchain:` input does not change the target-installation mechanism. **Not claiming the defensive steps are unnecessary** — the E0463 was empirically observed, P71-003 mandates keeping them, and there is no evidence for the true root cause. Per the repo's own citation-discipline rule, that is the problem: the comment asserts an unvalidated mechanism. Same defect class as ADV-P1-MEDIUM-002, fixed in `CLAUDE.md` + `CHANGELOG.md` but not propagated to the three workflow comments sitting directly adjacent to the diff. Compounding it: the story preamble says *"Assess whether they can be removed at F4 only"* and **no assessment is recorded** — scoped to this story's implementation phase and silently skipped. Fix: keep the steps; rewrite the comment to state the observed symptom and that the root cause is unconfirmed. Deferrable to S-641-1 rather than touching three release workflows in this PR.

---

## ADV-P2-LOW-001 — The pinned action makes `toolchain` hard-required, which the gotcha doesn't capture
**REFINEMENT · in-delta · LOW**

Direct evidence from the action's own script at SHA `fa04a145` (msrv job log): `if [[ -z $toolchain ]]; then echo "'toolchain' is a required input" >&2; exit 1; fi`. A future maintainer who deletes the `with:` block gets a **loud job failure**, not a silent stable-validation false-green. The CLAUDE.md gotcha describes "the action therefore read `rust-toolchain.toml` and installed stable" — true of the *old* SHA, which is why the pre-fix job was green — without noting the pinned SHA behaves differently. The gotcha's job is to prevent a regression; it currently over-warns on the input (now fail-safe) while the only genuinely silent vector is dropping the `RUSTUP_TOOLCHAIN` env. Its closing sentence already scopes the silent-revert claim to the env correctly, so this is one added clause, not a correction.

---

## ADV-P2-LOW-002 — `tests/` modified despite a MANDATORY "MUST NOT change: `tests/`"
**GAP · in-delta · LOW**

108 lines added to `tests/team_column_parity.rs` (`b51fc26a`). A *harder* constraint than the `test_files: []` frontmatter drift logged from pass 1 — it is in the MANDATORY File Structure Requirements section and phrased as a prohibition. The change itself is good and should be kept: the two tests are the only mutation-detecting coverage of the new `else { Vec::new() }` branches, and they explicitly guard against vacuous-pass by anchoring on `Assignee`/`Summary` before asserting `contains("Team").not()`. The story is what needs amending.

---

## ADV-P2-INFO-001 — msrv job's rust-cache key is derived under `stable`, not `1.85.0`

`RUSTUP_TOOLCHAIN` is step-scoped on `cargo check` (correct, per EC-4), so `Swatinem/rust-cache` fingerprints the toml-resolved `stable` rustc. Log evidence: the check step finished in **6.14s compiling only `jr`** — every dependency came from a restored cache. **Not a false-green vector** (rust-cache keys include the lockfile hash, and cargo fingerprints include the rustc version, so a dep bump or toolchain change forces a rebuild). Two real consequences: the msrv cache is discarded every stable release even though 1.85.0 didn't move; and on a cache hit the job's *dependency*-MSRV coverage is inherited from an earlier run, so that run's log doesn't independently evidence "comfy-table 7.2.1 compiles at 1.85.0". Sharpens ADV-P1-MEDIUM-004 — suggest S-641-1's evidence step echo the resolved toolchain **and** whether deps were rebuilt, not just `rustc --version`.

---

## ADV-P2-INFO-002 — msrv scope comment omits inline `#[cfg(test)]` modules

The comment explains the `--all-targets` exclusion via dev-dependencies/`wiremock`, framing it as being about the `tests/` directory. The same exclusion also skips `#[cfg(test)] mod tests` inside `src/`. Currently zero live defect (no let-chains anywhere in the tree), but a let-chain added to an inline test module would pass the msrv job and break `cargo test` at 1.85. One clause closes it.

---

## On the four items routed to S-641-1

**Routing is correct — none is blocking for this PR.** One concrete discharge to record: `.github/dependabot.yml` and every workflow in `.github/workflows/` were checked. The cargo ecosystem has a 7-day cooldown and **there is no auto-merge workflow anywhere in the repo**. So a dependabot bump of `=7.2.1`→`=7.2.2` opens a PR that goes red at the now-genuine msrv job and cannot self-merge. That materially lowers ADV-P1-LOW-003's urgency and supports deferral. ADV-P1-MEDIUM-004 is partly discharged already by the live log (`RUSTUP_TOOLCHAIN: 1.85.0` present in the step env, `jr` compiled fresh at 1.85.0). MEDIUM-005 is a new guard mechanism, not a defect in this delta. F7 likewise.

---

## Briefing correction [process-gap]

The orchestrator's dispatch stated the story frontmatter reads `target_module: .github/workflows/ci.yml`. At `factory-artifacts` HEAD it reads **`target_module: src/cli/`** (line 29). Either way it is singular-and-wrong for a story spanning 6 workflows + 3 `src/` files + 1 test file — but the ledger entry for C-LOW-001 should be corrected to the actual value before it is carried forward.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 3 |
| LOW | 2 |
| INFO | 2 |

**Overall Assessment:** NOT CLEAN — 3 MEDIUM GAPs (all spec-artifact; zero code changes required)

**Convergence: 0 of 3.** Passes 1 and 2 both NOT CLEAN. Not re-declared off a fix round; pass 3 to be dispatched. Note the trend: pass 1 found code defects, pass 2 found only spec-artifact defects.

---

## Round-2 dispositions (orchestrator, all verified)

- **Fixed in `.factory/` (story v1.4 → v1.5, STORY-INDEX v1.5.49):** MEDIUM-001 (all 7 bare-caret occurrences → `"=7.2.1"`; EC-10 gains the bare form); MEDIUM-002 (AC-8 requirement **inverted** — the research path must now NOT appear in the published manifest); MEDIUM-003 assessment recorded (keep the steps; root cause unconfirmed; comment rewrite routed to S-641-1; AC-5 enumeration extended for `release.yml`'s fourth site); LOW-002 (prohibition amended to `other tests/ files` with `tests/team_column_parity.rs` explicitly authorised by AC-9).
- **Fixed in the product repo (commit `15597e84`, pushed to #667):** LOW-001 (CLAUDE.md clause on the pinned SHA's hard-required `toolchain:` input) and INFO-002 (ci.yml scope comment now names inline `#[cfg(test)]` modules).
- Gates re-verified by the orchestrator at `15597e84`: tests **2343/0/100**, `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features --locked` clean, clippy clean.
- **Convergence: 0 of 3.** Passes 1 and 2 both NOT CLEAN. Not re-declared off a fix round; pass 3 to be dispatched. Note the trend: pass 1 found code defects, pass 2 found only spec-artifact defects.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 2 |
| **New findings** | 7 (3 MEDIUM + 2 LOW + 2 INFO) |
| **Duplicate/variant findings** | 0 — all new |
| **Median severity** | LOW |
| **Trajectory** | pass 1 (5M+5L+3I) → pass 2 (3M+2L+2I) |
| **Verdict** | NOT CLEAN — 3 in-delta spec-artifact GAPs; zero code changes required; pass 3 to be dispatched |
