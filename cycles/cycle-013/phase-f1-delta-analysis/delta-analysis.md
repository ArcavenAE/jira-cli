---
document_type: delta-analysis
cycle: cycle-013-msrv-1.88-bump
mode: brownfield-feature
producer: architect (F1, combined with business-analyst-role BC/test mapping — no separate agent spawn this pass; rationale in §0)
timestamp: 2026-09-15
status: complete
feature: Raise project MSRV from 1.85 to 1.88
feature_name: "MSRV 1.88 Bump"
intent: enhancement
feature_type: infrastructure
scope: standard
trivial: false
severity: "N/A"
route: Full F1-F7 (small, but multi-file blast radius with one HIGH-risk test-contract coupling — not quick-dev-eligible)
inputs:
  - .factory/research/msrv-let-chains-comfy-table-2026-07-30.md
  - .factory/research/msrv-1.88-ecosystem-policy-2026-09-15.md
input-hash: "9964eb4"
---

# Phase F1 Delta Analysis: Raise MSRV from 1.85 to 1.88 (cycle-013 `msrv-1.88-bump`)

**Validated against:** `develop @ 11c95d5e` (current tip at analysis time; git status shows only
untracked `.claude/` local-config noise, no uncommitted source changes).

**§0 — Process note:** This report performs both the architect's impact-boundary role (Step 3)
and the business-analyst's BC/test-mapping role (Step 4) in one pass rather than two separately
spawned agents. Precedent: `cycle-007-auth-delta-analysis.md` §0 did the same for a bundle of
comparable size. Rationale here is stronger, not weaker: this delta touches zero PRD requirements
(BC-S.SS.NNN) and zero architecture components — it is a build-configuration / CI-contract /
lint-policy change with three incidental source-level simplifications, not a behavioral feature.
Splitting the analysis across two agents would duplicate the same file-reading work for no
BC-mapping benefit (there is no BC to map to). Both roles' outputs are present below (§2 impact
boundary / architecture verdict, §3 file inventory + regression-risk mapping) and remain
separable if a future review wants to audit them independently.

---

## 1. Feature Summary

Raise `jr`'s declared and CI-enforced Minimum Supported Rust Version from **1.85** to **1.88**,
per explicit human approval of the 1.88 target. This is headroom, not a forced bump — no current
dependency requires more than 1.85 in the checked lib+bins graph (see §4, Q3). 1.88 is chosen
because it is the exact floor that: (a) stabilizes let-chains (edition 2024), letting the repo
retract its one active MSRV-driven lint-convention exception, and (b) unblocks `comfy-table`
7.2.2+ and `wiremock` 0.6.x, both of which already silently require ≥1.88 today (comfy-table via
an unpinned `"7"` range that resolves past the floor if the `=7.2.1` pin is ever lifted; wiremock
as the documented reason the `msrv` CI job is scoped to `lib + bins` only, excluding
`--all-targets`).

**Existing supporting research** (both cited as F1 evidence, not re-derived):
- `.factory/research/msrv-let-chains-comfy-table-2026-07-30.md` — empirical dependency-floor
  analysis (already on disk from a prior session; re-used here, not re-run).
- `.factory/research/msrv-1.88-ecosystem-policy-2026-09-15.md` — new companion note (written
  this pass) capturing the ecosystem/ MSRV-policy side of the human's decision context (current
  stable version, comparable-CLI MSRVs, the unfollowed "latest stable minus 3" policy line) so it
  is persisted rather than living only in this conversation's supplied instructions.

**Intent:** `enhancement` — human says "raise", explicitly approves a target version; nothing is
currently broken for end users (binary/Homebrew consumers are unaffected regardless of MSRV,
per the existing `comfy-table` pin CHANGELOG entry's own "User impact: None" note).

**Feature type:** `infrastructure` — CI/CD + build-config + lint-policy change. Three source
files gain a trivial, behavior-preserving syntactic simplification (nested `if` → let-chain) as a
direct corollary of the bump, not as independent feature work.

**Trivial scope? No.** Blast radius spans ≥10 files across four categories (build manifest, CI
workflow, a self-testing CI-gate contract, prose docs) plus 3 source files — fails the
single-module/single-file trivial criterion outright. More importantly, one of the touched files
(`tests/ci_gate_completeness.rs`) is a **HIGH-risk coupling**: it hard-pins the literal strings
this change must alter, and per CLAUDE.md's own CI-Gate section, this file is explicitly in the
six-file "review scope is SIX files, not one" set for anything CI-gate-adjacent. A LOW/trivial
regression-risk verdict cannot be honestly claimed while that coupling exists unresolved.
Route: **Full F1-F7**, not quick-dev.

---

## 2. Impact Boundary / Architecture Verdict (Step 3)

**No structural/interface redesign.** Zero new modules, zero new subsystems, zero ADR-mandated
pattern shift, zero new crate/module boundary. Nothing in `.factory/specs/architecture/` needs
touching (confirmed no `ARCH-INDEX.md`/module-criticality artifacts reference Rust-toolchain
version — searched, no hits) and this project has no `module-criticality.md` /
`dtu-assessment.md` at `.factory/specs/` (both absent — this is a maintained brownfield CLI
operating in ongoing Feature Mode, not mid-greenfield-pipeline; N/A rather than a gap).

The only thing resembling a "design decision" here is F2's job, not F1's: whether to (a) simply
delete the repo's now-unnecessary "No let-chains" convention line, or (b) additionally adopt
let-chains prospectively as a preferred style for *new* code (not just retrofit the 3 existing
sites). Recommend F2 treat this as a one-line CLAUDE.md convention removal only — no new ADR
needed, this is tooling-floor bookkeeping, not an architectural decision the codebase's shape
depends on.

**DTU applicability: N/A.** No external service dependency is touched; `dtu_required: false`
would apply by the same rationale every prior `jr` cycle has recorded (CLI tooling change, no new
integration surface). No `dtu-assessment.md` exists at the specs root for this brownfield project
to update.

**UX applicability: N/A.** `jr` has no UI surface; this is a build-config/CI change with no
user-facing screen, consistent with every prior cycle's `feature_type` classification for
non-UI work.

---

## 3. File Inventory (Step 4 — change type, risk)

### Modified Files

| File | Change | Risk | Notes |
|---|---|---|---|
| `Cargo.toml` | `rust-version = "1.85"` → `"1.88"` (L7); drop `comfy-table = "=7.2.1"` pin (L33) → allow `"7"` (7.2.2+) or re-pin to a specific ≥7.2.2 version; relax the `saphyr-parser` MSRV commentary (L74-81, the note that saphyr-parser's own MSRV is "exactly 1.85.0 against this repo's rust-version, zero headroom" becomes stale once the floor moves to 1.88) | **MEDIUM** | Edition is already `2024` — no change there. Unpinning comfy-table is the one line with an actual behavior-risk tail (see comfy-table row below). |
| `.github/workflows/ci.yml` | `msrv` job (L248-275): job name `"MSRV (1.85.0)"` → `"MSRV (1.88.0)"`; `dtolnay/rust-toolchain` `with.toolchain: "1.85.0"` → `"1.88.0"`; `env.RUSTUP_TOOLCHAIN: "1.85.0"` → `"1.88.0"`; the lib+bins-only scope workaround comment (L263-272, driven by wiremock/comfy-table needing ≥1.88) becomes stale and should be re-evaluated — at 1.88 the stated reason for excluding `--all-targets` (wiremock's let-chains requirement) no longer holds, so F2/F3 should decide whether to widen scope to `--all-targets` or explicitly document a *new* reason to keep it narrow. Pinned action SHA at this step is `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772` (verified by direct read — **not** `fa04a1451ff1842e2626ccb99004d0195b455a88`, the SHA CLAUDE.md's Gotchas section currently and incorrectly cites; see CLAUDE.md row). | **MEDIUM** | Scope-widening is a genuine design choice, not mechanical — flag for F2/F3, do not silently fold into the version-bump story. |
| `tests/ci_gate_completeness.rs` | `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` (~L3673 onward) hard-pins the literal strings `toolchain: "1.85.0"` / `RUSTUP_TOOLCHAIN: "1.85.0"` at multiple assertion sites (confirmed by direct grep: matches at "exactly once each" assertions plus explanatory doc comments spanning ~L3566-L3920, e.g. the `assert_eq!(text, "1.85.0", …)` calls and their `ScalarStyle::DoubleQuoted` checks). **This is the single highest-risk file in the delta** — CLAUDE.md's own text calls it out as such, independently. | **HIGH** | Must move in the *same* commit/burst as the `ci.yml` change or the CI Gate's own self-test (part of the `ci-gate` required check) fails outright, blocking every subsequent PR on `develop`/`main`. This is the coupling that disqualifies "trivial scope." |
| `tests/common/wf.rs` | One doc-comment reference to `RUSTUP_TOOLCHAIN: "1.85.0"` (~L1784), describing the shape of the real `ci.yml` step vs. a decoy step used elsewhere in the same test file's fixtures. Prose only — no assertion logic here. | **LOW** | Should be updated in lockstep for accuracy, but a missed update would not break any test (it's a comment, not a pinned literal). |
| `CLAUDE.md` | (1) Delete the "No let-chains" convention entry (Conventions section, current text begins "**No let-chains.** ... Temporary — delete this entry and the three citing in-code comments when MSRV is raised to ≥1.88."); (2) fix the stale SHA in the Gotchas section's `rust-toolchain.toml` bullet — currently claims the replacement SHA was `fa04a1451ff1842e2626ccb99004d0195b455a88`; the actual pinned SHA in `ci.yml` today is `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772` (confirmed by direct file read this pass — this drift predates cycle-013 and is unrelated to the MSRV bump itself, but should be corrected in the same pass since it's adjacent prose in the same Gotchas bullet); (3) update the two `1.85.0`-pin literal citations inside the CI-Gate `ci_gate_completeness.rs`-describing Gotchas prose (if any restate the value) to `1.88.0`. | **LOW** | Prose-only. `tests/claude_md_citations.rs`'s dead-citation guard checks file-path citations, not numeric-version prose — this change does not risk that guard. |
| `src/cli/auth/keychain.rs` (~L50) | Collapse the `if let Ok(v) = std::env::var(env_name) { if !v.is_empty() { ... } }` nested form (currently commented `// Nested if (not a let-chain): ...`) into `if let Ok(v) = std::env::var(env_name) && !v.is_empty() { ... }`. | **LOW** | Must preserve short-circuit order and drop-order semantics exactly — see §4 Q4 for the specific caveat let-chains introduce (drop-order change vs. nested `if`, per the 1.88 release blog's own stated rationale). Behavior-preserving refactor, trivially unit-testable via existing coverage for this helper. |
| `src/cli/board.rs` (~L231) | Same collapse pattern, same source comment marker. | **LOW** | Same caveat as above. |
| `src/cli/issue/list.rs` (~L760) | Same collapse pattern, same source comment marker. | **LOW** | Same caveat as above. |
| `README.md` (L8) | MSRV badge `MSRV-1.85-orange.svg` → `MSRV-1.88-orange.svg`. | **LOW** | Cosmetic, no functional coupling. |
| `CHANGELOG.md` | New `[Unreleased]` entry documenting the MSRV raise, the comfy-table unpin, and (if F2/F3 decides to widen it) the `msrv` job's `--all-targets` scope change. | **LOW** | Standard practice per every prior MSRV-adjacent CHANGELOG entry already in this file (L1065-1096 document the *previous* MSRV-correctness fix in the same style — good template to follow). |
| `docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md` (L656-658) | Declares an MSRV Policy of **"1.85.0 (or latest stable minus 3 releases)"** — a policy the repo does not actually follow (current stable is 1.98 per the ecosystem research note; "minus 3" from 1.98 would be far higher than either 1.85 or 1.88). This is a genuine **pre-existing spec inconsistency**, not something cycle-013 introduces. Flagging per the human's explicit instruction to reconcile it. | **LOW (decision needed, not mechanical)** | F2 must decide: (a) update the design spec's stated policy to match actual practice (e.g., "MSRV bumps are evaluated ad hoc against ecosystem/dependency pressure, not a fixed offset from current stable"), or (b) leave the historical design-spec text as-is and record the deviation as an accepted, documented policy gap. Either is defensible; picking one is an F2 decision, not F1's to make. |

### Dependent Files (unchanged, but regression-relevant)

| File | Depends On | Regression Risk | Notes |
|---|---|---|---|
| `src/output.rs` (sole `use comfy_table::{...}` import site in `src/`, confirmed by grep) | `Cargo.toml`'s comfy-table version resolution | **MEDIUM** | This is the actual regression-risk carrier for the comfy-table unpin, not `Cargo.toml` itself. The comfy-table 7.2.2 changelog (per the existing research doc) states two behavior changes beyond the let-chain refactor: "Fixed edge case with multiple `LowerBoundary` constraints" and "**Fixed table misformatting without vertical border styling**" — the second is a rendering-output bug fix, which is exactly the kind of change that can silently break byte-exact snapshot assertions. |
| `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` | `src/output.rs` → comfy-table rendering | **MEDIUM** | Confirmed via repo-wide `.snap` file search: this is the **only** insta snapshot in `src/`/`tests/` that exercises table-mode (non-JSON) rendering output. If comfy-table's `7.2.2` "table misformatting" fix changes this table's border/spacing bytes, this is the one and only test that will flag it — and it is a direct, mechanical `cargo insta review` fix if it does (not a design question). No other snapshot is at risk from the comfy-table bump. |
| Every other `src/cli/` command handler that renders `OutputFormat::Table` (i.e., calls into `output::render_table`/equivalent) | `src/output.rs` transitively | **LOW** | These are exercised by ordinary (non-snapshot) integration tests that assert on parsed/substring content, not byte-exact table output — lower risk than the one pinned snapshot, but still part of the regression suite that must stay green (Rule 1, scoping rules: regression is never scoped down). |

### Files NOT Changed (Regression Baseline)

- All of `src/api/`, `src/types/`, `src/cache.rs`, `src/config.rs`, `src/adf.rs`, `src/jql.rs`,
  `src/duration.rs`, `src/error.rs`, `src/observability.rs` — zero Rust-edition/MSRV-sensitive
  syntax in these modules; no let-chain-eligible pattern found outside the 3 cited sites (grep
  for the marker comment returns exactly 3 hits, matching the human-supplied inventory).
- The entire `tests/` integration suite *other than* `ci_gate_completeness.rs` and its
  `tests/common/wf.rs` helper — must continue to pass unmodified; this is the binary regression
  gate per scoping Rule 1.
- `.cargo/config.toml` (Windows `/STACK:8388608` linker flag) — unrelated mechanism, no MSRV
  coupling.
- `rust-toolchain.toml` (`channel = "stable"`) — already floats to stable, not pinned to 1.85;
  confirmed via direct read, genuinely out of scope, not merely assumed.
- `docs/adr/`, `.factory/specs/architecture/decisions/ADR-*.md` — no existing ADR references
  Rust-toolchain version; none needs amending or superseding for this change (confirmed: no new
  ADR is warranted per §2).
- `deny.toml`, `Cargo.lock` — `cargo deny check` and lockfile resolution are unaffected by an MSRV
  metadata bump alone; only affected if the comfy-table pin is actually *lifted* (which does touch
  `Cargo.lock` mechanically at implementation time, but that's an F4 execution detail, not an F1
  scope item).

---

## 4. Regression Risk Assessment + Mitigation

| Risk | Level | Mitigation |
|---|---|---|
| `ci_gate_completeness.rs` assertions drift out of sync with `ci.yml`'s actual literals | **HIGH** | Update both files in the same commit/burst, in that order (ci.yml first, test second, or as one diff) — never land one without the other. This is the single hardest constraint on F3/F4 sequencing: it must be one atomic story, not split across two stories in different waves. |
| comfy-table 7.2.2's "table misformatting" fix silently changes rendered output | **MEDIUM** | Run the full test suite (including `cargo insta review` if the one at-risk snapshot fails) after the unpin; if `list_table_snapshot` changes, review the diff visually before accepting — it should be a legitimate upstream *fix*, not a regression, but must be eyeballed rather than blindly `cargo insta accept`-ed. |
| Let-chain collapse at the 3 sites changes drop-order or short-circuit behavior versus the nested-`if` form | **LOW** | The 1.88 stabilization's own rationale (per the existing research doc) is that let-chains needed "the `if let` temporary scope change for more consistent drop order" first — i.e., the semantics were deliberately made to *match* nested-if's now-more-predictable drop order, not diverge from it, precisely so this class of mechanical refactor is safe. Still: write/keep unit tests for all 3 call sites covering both the present/non-empty and absent/empty branches before and after, per CLAUDE.md's "default to fixing code, not tests" + TDD conventions. |
| Some other dev-dependency (beyond wiremock, already known) newly requires >1.88 | **LOW** | Full `[dev-dependencies]` block reviewed this pass (`assert_cmd`, `predicates`, `tempfile`, `wiremock 0.6`, `insta`, `proptest`, `tokio` (test-util), `temp-env`, `scopeguard`, `glob`, `sha1`, `saphyr-parser =0.0.11`, `libc`) — none besides wiremock/comfy-table is known to gate on 1.88 specifically; `saphyr-parser`'s own stated MSRV is exactly 1.85 (i.e., *more* permissive, not a new floor). No further dependency audit beyond this manifest read was performed this pass; F4 should still run `cargo check --all-targets --locked` under 1.88.0 once the toolchain is bumped, as a cheap confirmation this claim holds live (not just from manifest inspection). |
| `docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md`'s unfollowed "latest stable minus 3" MSRV policy line causes future confusion (recurs every MSRV cycle) | **LOW, but recurring** | F2 should resolve it once and for all this cycle rather than deferring again — see the file's row in §3 for the two defensible options. |
| CI Gate self-test (`ci_gate_completeness.rs`) failing to update in the fix-review pass is exactly the "silently defang the gate" failure mode CLAUDE.md warns about repo-wide | **Structural, not probabilistic** | This is why scope is `standard`, not `trivial`, and why this delta gets full F1-F7 treatment (adversarial review at F5 should specifically re-check this file's assertions against `ci.yml`'s actual post-change literals, byte for byte). |

**Overall regression risk verdict: MEDIUM** (driven by the HIGH-risk `ci_gate_completeness.rs`
coupling and MEDIUM comfy-table rendering risk; everything else in the delta is LOW).
**Architecture risk: NONE** (no structural change). **Security risk: NONE** (no new dependency,
no new attack surface — MSRV/edition metadata only). **Performance risk: NONE** (no runtime-path
change from this delta; the 3 let-chain collapses are syntactically equivalent, not
optimizations).

---

## 5. Preview Story Decomposition (final decomposition is F3's job)

This is a preview only, per the task's own framing — not a commitment. Likely 3-story shape:

1. **Story A — Mechanical version bump + CI-gate contract in lockstep.** `Cargo.toml`
   `rust-version`, `.github/workflows/ci.yml`'s `msrv` job (name/toolchain/env), and
   `tests/ci_gate_completeness.rs`'s pinned-literal assertions, all in one atomic change. This is
   the HIGH-risk coupling from §4 and should not be split. `tests/common/wf.rs`'s doc-comment
   update rides along here since it's the same file family.
2. **Story B — Let-chain retrofit + convention cleanup.** Collapse the 3 nested-`if` sites into
   let-chains; delete CLAUDE.md's "No let-chains" convention entry (which explicitly names these
   3 sites as its own trigger for deletion). Independent of Story A's CI mechanics — can run in
   parallel once Story A establishes the 1.88 floor is real in CI (sequencing: A should land or at
   least be CI-green before B's let-chain syntax would compile in the `msrv` job).
3. **Story C — Doc/policy reconciliation.** README badge, CHANGELOG entry, CLAUDE.md's stale SHA
   fix (independent bug, opportunistically bundled), and the design-spec MSRV-policy-line
   reconciliation (§3, §4). Lowest risk, most parallelizable, could even land before A/B.
   Additionally: decide (and either execute or explicitly defer) the `ci.yml` `msrv` job's
   `--all-targets` scope-widening question flagged in §3 — recommend treating this as an
   explicit **open question for the human** at the F1 gate (see §7) rather than silently bundling
   it into Story A, since it changes what the MSRV job actually validates going forward.

Comfy-table's unpin (drop `=7.2.1`, decide range vs. exact re-pin) belongs in Story A alongside
the version-bump mechanics, since it's the one line in `Cargo.toml` with a real regression tail
(§3, §4) and should be reviewed together with the CI-contract change, not deferred to Story C.

---

## 6. Impact Assessment (template-format summary)

| Dimension | Affected | Details |
|---|---|---|
| PRD Requirements (BC-S.SS.NNN) | 0 new, 0 modified | No behavioral contract governs Rust-toolchain version; this delta has no BC surface. |
| Architecture | 0 components added, 0 modified | No `ARCH-INDEX.md`/section files reference MSRV; no structural change (§2). |
| UX Screens | N/A | No UI surface (`feature_type: infrastructure`). |
| Stories | ~3 new stories estimated (§5) | Preview only — final count/shape is F3's decision. |
| Existing Tests in risk zone | `tests/ci_gate_completeness.rs` (full file, HIGH), `tests/common/wf.rs` (doc-comment only, LOW), `src/cli/auth/tests/*` (keychain helper unit tests, LOW), `src/cli/board.rs`/`src/cli/issue/list.rs` inline unit tests covering the 3 refactor sites (LOW), `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` (MEDIUM, comfy-table rendering), `tests/claude_md_citations.rs` (LOW, must keep passing — no new dead citations introduced), `tests/mutants_glob_existence.rs` (unaffected, listed for completeness since it's in the same spec-guard CI job family) | See §3/§4 for full risk reasoning per file. |
| Verification Properties | 0 new VP-NNN needed | Build-config change; existing test coverage (unit tests on the 3 refactor sites, the CI-gate self-test, the one snapshot) is the appropriate verification surface — no new formal property to prove. |

---

## 7. Open Questions for the Human (F1 Gate)

1. **Cycle scaffold:** `.factory/cycles/CURRENT` currently points to `cycle-002` (stale — the
   cycle-summary log shows cycle-012 as the most recently closed cycle and "no OPEN cycle remains
   anywhere in the factory"). This F1 pass did **not** touch `CURRENT` (that's a state-manager
   write, not architect's to make). Confirm whether opening cycle-013 should also correct
   `CURRENT` to `cycle-013`, or whether that pointer's meaning/lifecycle is something else
   entirely that a state-manager burst should investigate separately.
2. **`msrv` job `--all-targets` scope widening (§3, §5 Story C):** now that wiremock's ≥1.88
   requirement is no longer a blocker, should the `msrv` job's `cargo check` scope widen from
   `lib + bins` to `--all-targets` (closing the documented gap where inline `#[cfg(test)]`
   modules and integration tests sit outside MSRV enforcement), or should scope stay narrow for
   an unrelated reason? Recommend widening (closes a real, CLAUDE.md-documented enforcement gap
   for free), but this changes CI behavior beyond the literal ask and should be an explicit human
   call, not an architect default.
3. **Design-spec MSRV policy line reconciliation (§3, §4):** update the stated "latest stable
   minus 3" policy text, or formally record the deviation? Recommend updating the text to
   describe actual practice (ad hoc, ecosystem-pressure-driven bumps) since "minus 3" has never
   once been the actual mechanism per the cycle history reviewed this pass.
4. **Re-pin strategy for comfy-table:** drop to a bare `"7"` caret range (floats with future
   7.x releases, re-exposed to the same class of silent-MSRV-violation risk the existing pin was
   protecting against) vs. an explicit `">=7.2.2, <8"` or exact-pin-with-review-gate approach
   (mirrors the `saphyr-parser` exact-pin rationale already in the codebase). Recommend the
   latter, consistent with existing project convention for dependencies with a history of
   MSRV surprises — but this is a judgment call for F2, flagging here so it isn't decided
   silently at implementation time.

---

## Scope Recommendation

- **Mode:** Feature Mode (not Full Pipeline — no PRD/architecture/domain-spec rewrite needed).
- **Estimated new stories:** 3 (§5), all small.
- **Estimated effort:** Low (each story is single-session-sized); the coordination risk (§4 HIGH
  item) is about *sequencing correctness*, not raw effort.
- **Can parallelize:** Story C is fully independent and can run anytime. Story B should not merge
  ahead of Story A reaching a green `msrv` CI run at 1.88.0 (its let-chain syntax needs the new
  floor to be real in CI, not just declared in `Cargo.toml`).
