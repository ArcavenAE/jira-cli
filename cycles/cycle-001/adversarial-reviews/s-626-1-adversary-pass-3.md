---
document_type: adversarial-review
level: ops
version: "1.0"
status: complete
producer: adversary
timestamp: 2026-07-30T21:15:53Z
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
input-hash: "0aa722e"
traces_to: .factory/stories/S-626-1.md
story: S-626-1
cycle: cycle-001
pass: 3
agent: adversary
basis: TRUE ADVERSARY AGENT
date: 2026-07-30
feature_head: 15597e84b0f5e3994c5620edbcf1caf83766d2b7
pr: 667
verdict: NOT CLEAN — root-cause mechanism falsified; 3 MEDIUM GAPs
previous_review: .factory/cycles/cycle-001/adversarial-reviews/s-626-1-adversary-pass-2.md
---

# Adversarial Review — S-626-1 (SOH-DX-1), Pass 3

## Header

Adversary pass 3, S-626-1 @ `15597e84`, PR #667. Worktree identity confirmed via `git rev-parse HEAD` = `15597e84b0f5e3994c5620edbcf1caf83766d2b7` (10 commits over `origin/develop`). Spec read from canonical `.factory/stories/S-626-1.md` (v1.5). All 15 inputs read in full. Delivered via `SendMessage`.

---

## Preflight — Orchestrator SHA Fabrication (record verbatim)

**The orchestrator's embedded `feature-HEAD-SHA` was fabricated.** The dispatch supplied `15597e8455ba4b4b5e5c7f4a0e0e0b3e8c9d1f2a`; the actual HEAD is `15597e84b0f5e3994c5620edbcf1caf83766d2b7`. Only the 8-character prefix matched — the remaining 32 hex characters were invented. The adversary detected this via its own `git rev-parse HEAD` check and reviewed against the real value. The Worktree-Identity Preflight worked exactly as designed. Also: the adversary's pass-2 count of 4 `"7.2.1"` occurrences was low; the orchestrator's count of 7 was correct.

---

## Pass-2 Fix Verification (Partial-Fix Regression Discipline)

All round-2 dispositions checked. Three pass-2 fixes introduced new defects — see MEDIUM-001, MEDIUM-002, LOW-004, LOW-005.

- **MEDIUM-001 caret-range spec** — FIXED in story v1.5 (7 occurrences → `"=7.2.1"`; EC-10 extended). Confirmed.
- **MEDIUM-002 inverted AC-8** — FIXED in story v1.5. Confirmed.
- **MEDIUM-003 workflow comments** — ROUTED to S-641-1. Steps kept. But the fix-round introduced a new false premise — see MEDIUM-002 below.
- **LOW-001 hard-required toolchain clause** — FIXED in `15597e84`. Confirmed.
- **LOW-002 tests/ prohibition amended** — FIXED in story v1.5. But marking is wrong — see LOW-005 below.
- **INFO-002 scope comment** — FIXED in `15597e84`. Confirmed.

**Independent checks clean:** AC-2/AC-7 (7 full-40-char SHA occurrences; `c93f4f9c` zero matches repo-wide) ✓; `msrv` in `ci-gate.needs` ✓; `Cargo.lock` diff minimal comfy-table-only 4 lines ✓; `--locked` present on msrv check ✓; `cargo check --all-features --locked` clean under `RUSTUP_TOOLCHAIN=1.85.0` ✓; tests 2343/0/100 ✓; clippy and fmt clean ✓.

---

## ADV-P3-MEDIUM-001 — the documented root-cause mechanism is factually false, in `CLAUDE.md` and `CHANGELOG.md`
**GAP · in-delta · MEDIUM**

`dtolnay/rust-toolchain` **never reads `rust-toolchain.toml`** — at either SHA. Both `action.yml` files were fetched:

- **New SHA `fa04a145` (master):** `toolchain` input present, `required: true`, no default, plus an explicit guard `if [[ -z $toolchain ]]; then echo "'toolchain' is a required input" >&2; exit 1; fi`. **No toml-reading logic anywhere.**
- **Old SHA `c93f4f9c`:** the `toolchain` input **does not exist** (only `targets`/`target`/`components`), and the parse step hard-codes `env: toolchain: 1.85.0`.

That old-SHA shape is the signature of the action repo's numeric-version-branch generator, found in dtolnay's own CI script:
```
if [[ $rev == 1* ]]; then
  sed -i "/^  toolchain:/,+2d; s/\${{inputs\.toolchain}}/$rev/" action.yml
else
  sed -i "s/^    required: true$/    required: false\n    default: $rev/" action.yml
fi
```
So `c93f4f9c` is the tip of the action's **`1.85.0` version branch**.

**What actually happened pre-fix:** the action installed 1.85.0 correctly and set it as `rustup default`. The false-green came *solely* from the second half — `cargo check` ran in the repo root, where `rust-toolchain.toml` (`channel = "stable"`) outranks `rustup default`, so the check ran under stable. **The fix and the conclusion are right; the stated mechanism is wrong.**

Three in-delta artifacts assert the false half: (1) `CLAUDE.md` gotcha body — *"the action therefore read `rust-toolchain.toml` and installed stable"* — flatly false; (2) `CLAUDE.md` gotcha **title** — *"`rust-toolchain.toml` outranks `dtolnay/rust-toolchain`'s `toolchain` input"* — misattributes the precedence relation, since the toml outranks `rustup default` (what the action *sets*), not the action's *input* (which controls what gets *installed*); (3) `CHANGELOG.md` `### Fixed` — same false claim, in a published changelog. Also inherited by the story's Problem Statement (Defect 2) and AC-3.

Why this matters beyond pedantry: `CLAUDE.md` is the project's authoritative gotcha registry and exists to prevent regression. As written, a contributor could reasonably conclude that deleting `rust-toolchain.toml` is a sufficient alternative fix, or that the `toolchain:` input is the thing being overridden. It also collides with the repo's own codified citation-discipline convention for externally-verifiable claims in user-facing text and docs.

The pass-2 LOW-001 fix **did** land correctly and is verified true: at `fa04a145` the `toolchain:` input is hard-required and its omission fails loudly. Keep that clause.

---

## ADV-P3-MEDIUM-002 — the M-003 F4 assessment reached the right decision from a false premise
**GAP · in-delta · MEDIUM · partial-fix regression on ADV-P2-MEDIUM-003 · [process-gap]**

v1.5 recorded: root cause **unconfirmed**; the three comments *"assert a specific mechanism … that is not evidenced by the action's parse script"*; *"the mechanism is self-contradictory now that `toolchain: stable` was added."*

All three claims are wrong. The mechanism is now **confirmed**, and the comments are substantively **correct**: at the `1.85.0`-branch SHA the action installed `targets: ${{matrix.target}}` onto the **1.85.0** toolchain, while `cargo build` ran under **stable** (toml > `rustup default`), which lacked that target → `E0463`. `sign-and-publish.yml:59-61` already states this nearly verbatim: *"The target the action installed sits on the wrong toolchain."* It isn't in the action's parse script because it lives in **rustup's** override precedence — the very precedence AC-3 and the CLAUDE.md gotcha depend on.

**Live consequence:** S-641-1 was specified to rewrite these comments to say *"root cause unconfirmed"*, which would replace a correct explanation with a false hedge. Fix MEDIUM-001 and MEDIUM-002 **before** S-641-1 runs, and re-scope its comment task.

What *is* genuinely stale post-fix: with `toolchain: stable` now agreeing with the toml, the target lands on the active toolchain, so the three steps become idempotent no-ops. Keeping them remains correct (P71-003, EC-1) — but the comments' present-tense *"without this step the build fails"* is now historical, not current. That is the accurate rewrite for S-641-1.

**[process-gap]:** P71-001 established the old SHA was *"a per-version-branch commit (expected behavior for that repo's branch structure)"* and stopped. It never asked the follow-on question — *what does a version branch's `action.yml` actually do?* That single unasked question is the common root of MEDIUM-001, -002 and -003. Provenance verification that classifies a pin without reading the pinned artifact is incomplete.

---

## ADV-P3-MEDIUM-003 — Defect 1 is mis-framed; the real defect is larger and undocumented
**GAP · in-delta · MEDIUM**

Because `c93f4f9c` is the **1.85.0** version branch, the six sites commented `# stable` (`release.yml`, `sign-and-publish.yml`, `backfill-release.yml`, `e2e.yml`, `e2e-sweeper.yml`, `ci.yml` coverage) were installing **Rust 1.85.0** — their `# stable` comments were wrong, and the pin was semantically wrong for those jobs. The story frames Defect 1 purely as provenance (*"not a master ancestor"*), which materially understates a live wrong-toolchain defect across six jobs.

Two consequences, both of which strengthen the PR:
- **The SHA substitution is load-bearing, not hygiene.** On the numeric branch the `toolchain` input does not exist, so adding `with: {toolchain: …}` alone would have been silently ignored (GitHub emits at most an *"Unexpected input(s)"* warning). The SHA swap is a hard prerequisite for the fix, not a tidy-up bundled alongside it.
- **Blast radius, stated precisely so it is not overstated:** builds still *ran* under stable (toml wins), so shipped binaries were compiled by stable — **not** by 1.85.0. The concrete harm was a wasted toolchain install, cross targets installed onto the wrong toolchain, and misleading comments — masked by the defensive `rustup target add` steps. This is stated explicitly so the correction does not get inflated into "release binaries were built with the wrong compiler." They were not.

Related: **AC-4 ("MSRV comment accuracy verified") audited the one comment that was already correct.** `# 1.85.0` on the msrv step was accurate pre-fix — it named the 1.85.0 branch. The six `# stable` comments were the inaccurate ones, and no AC checked them. They are correct at HEAD, so this is an AC-coverage aim problem, not a code defect.

---

## ADV-P3-LOW-004 — AC-5's v1.5 table row for `release.yml` asserts a comment that does not exist
**REFINEMENT · in-delta · partial-fix regression on ADV-P2-MEDIUM-003**

AC-5's table claims `release.yml` ~:43 → *"E0463 comment preserved | yes."* `grep -c E0463 .github/workflows/release.yml` → **0**. The step is a bare `- name: Ensure cross-target installed (defensive)` with no comment block. Only `backfill-release.yml` and `sign-and-publish.yml` have E0463 comments (1 each). The pre-implementation blockquote repeats the error. Line ref has also drifted: step at ~:43, `rustup target add` at ~:46. Introduced by the v1.5 extension that answered pass 2's finding — the fourth site was added to the table but its attributes were assumed rather than checked.

---

## ADV-P3-LOW-005 — `tests/team_column_parity.rs` marked CREATE; it is a MODIFY
**REFINEMENT · in-delta · partial-fix regression on ADV-P2-LOW-002**

File Structure Requirements lists it as **CREATE**. It exists on `origin/develop` at **487 lines**; this PR appends 108 → `MODIFY`. AC-9's *"(108 lines, added by commit `b51fc26a`)"* is ambiguous but survivable; the table entry is definitively wrong. Introduced by the v1.5 L-002 fix. Authorization itself is fine — the amended "other `tests/` files" prohibition covers it correctly.

---

## ADV-P3-LOW-006 — CHANGELOG comfy-table entry omits the mandated user-impact line
**REFINEMENT · in-delta**

The Delivery Checklist requires the entry carry *"**User impact:** None for binary users or source-builders on Rust ≥1.85.0."* The `### Changed` comfy-table entry has no user-impact statement; its two sibling entries (msrv job, let-chains) both carry a no-user-visible-change line. Checklist item not fully satisfied. (Story-ID citations in CHANGELOG are established convention — 20 pre-existing on develop — so `S-626-1` there is fine.)

---

## ADV-P3-INFO-007 — CLAUDE.md precedence list is correct but incomplete

The five-level order matches the rustup book exactly (`+toolchain` > `RUSTUP_TOOLCHAIN` > directory override > `rust-toolchain.toml` > default) — **verified, no change needed**. It omits the book's documented exception: directory overrides and `rust-toolchain.toml` are *additionally* ranked by proximity to cwd, so a nearer toml beats a farther `rustup override`. Immaterial in CI (no directory override present); flagged only so the gotcha isn't later cited as a complete precedence reference.

---

## ADV-P3-INFO-008 — pre-existing; bounds what the pin protects

`fmt`, `clippy`, `test`, `deny` in `ci.yml` install **no** toolchain — they use the runner's preinstalled Rust resolved via `rust-toolchain.toml`. Only `msrv` and `coverage` carry a pinned action step. Out of delta; relevant context for how much the SHA pin actually buys.

---

## Confirmed Clean at This HEAD (no findings raised)

`msrv` in `ci-gate.needs` ✓ (`[fmt, clippy, test, msrv, deny, spec-guard, check-signing-workflow-injection, mutants]`) · 7/7 SHA sites full 40-char ✓ · `c93f4f9c` zero matches repo-wide ✓ · `Cargo.lock` diff minimal, comfy-table only, 4 lines, no transitive change ✓ · `Cargo.toml` pin is `"=7.2.1"` with `issue #626` citation and no `.factory/` path ✓ (AC-8 as inverted in v1.5 is met) · `--locked` present on the msrv check ✓ · job name already `MSRV (1.85.0)` on develop (Task 3's rename was a pre-satisfied no-op) ✓ · pass-2 LOW-001 and INFO-002 clauses landed and LOW-001 is externally **verified true** ✓ · `src/cli/board.rs` and `src/cli/issue/list.rs` still absent from `.cargo/mutants.toml` `examine_globs` (deliberate; zero mutation signal on the `src/` rewrites) ✓.

---

## Round-3 Dispositions (orchestrator, all verified)

- **Product repo, commit `64cdb59b` pushed to #667:** MEDIUM-001 (gotcha title + body + `CHANGELOG.md` `### Fixed` all corrected to the real mechanism, and the "SHA swap is a hard prerequisite because the old branch had no `toolchain` input" point added); LOW-006 (user-impact line added); INFO-007 (taken — proximity-to-cwd clause added). Orchestrator-verified: no surviving instance of the false claim in either file; tests 2343/0/100; `RUSTUP_TOOLCHAIN=1.85.0 cargo check --all-features --locked` clean; clippy and fmt clean.
- **`.factory/` — S-626-1 v1.5 → v1.6:** MEDIUM-001 inherited fix (Defect 2 + AC-3); MEDIUM-002 (F4 assessment corrected — decision KEEP stands, reasoning replaced: root cause **confirmed**, comments **correct**, only the present-tense claim is stale); MEDIUM-003 (Defect 1 expanded with the version-branch finding, the load-bearing SHA-swap consequence, and the explicit do-not-overstate blast-radius bound; AC-4 aim note added); LOW-004 (AC-5 `release.yml` row corrected to "no comment; bare step name only", line refs ~:43-45); LOW-005 (CREATE → MODIFY). `[process-gap]` codified in Previous Story Intelligence.
- **S-641-1 v0.2 → v0.3:** comment task re-scoped — preserve the causal explanation, re-tense the present-tense claim as historical (idempotent no-ops retained per P71-003). **Ordering gate added: AC-4 must NOT be actioned before S-626-1 v1.6 merges.** The superseded "root cause unconfirmed" wording is deliberately retained in two places as a documented hazard so it is not reinstated.
- STORY-INDEX v1.5.50; spec-changelog `[1.3.175]`; BC 657 and holdout 106 unchanged; all four guards exit 0.
- **Convergence: 0 of 3.** Three passes, three NOT CLEAN — but each found a distinct layer: pass 1 code defects, pass 2 spec artifacts, pass 3 the causal model underneath both. Not re-declared off a fix round.
- **Orchestrator-attributable:** the fabricated HEAD SHA in the pass-3 dispatch; and three of pass 3's findings (MEDIUM-002's false premise, LOW-004, LOW-005) were **introduced by the orchestrator's own v1.5 fix instructions**. Add these as datapoints to `ORCHESTRATOR-ERROR-INJECTION-RATE`.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH | 0 |
| MEDIUM | 3 |
| LOW | 3 |
| INFO | 2 |

**Overall Assessment:** NOT CLEAN — root-cause mechanism falsified; 3 MEDIUM GAPs

**Convergence: 0 of 3.** Three passes, three NOT CLEAN — each found a distinct layer. Not re-declared off a fix round.

---

## Novelty Assessment

| Field | Value |
|-------|-------|
| **Pass** | 3 |
| **New findings** | 8 (3 MEDIUM + 3 LOW + 2 INFO) |
| **Duplicate/variant findings** | 0 — all new |
| **Median severity** | LOW |
| **Trajectory** | pass 1 (5M+5L+3I) → pass 2 (3M+2L+2I) → pass 3 (3M+3L+2I) |
| **Verdict** | NOT CLEAN — 3 MEDIUM GAPs; round-3 dispositions all verified; convergence 0/3 |
