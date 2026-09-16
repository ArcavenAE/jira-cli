---
document_type: story
level: ops
story_id: "S-cycle13-msrv-cargo-ci-atomic-bump"
epic_id: "MSRV-1.88-BUMP"
title: "Mechanical MSRV bump: Cargo.toml + ci.yml msrv job + ci_gate_completeness.rs, atomic"
wave: 1
status: draft
intent: enhancement
feature_type: infrastructure
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
producer: story-writer
timestamp: "2026-09-15T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-013/phase-f1-delta-analysis/delta-analysis.md"
  - ".factory/specs/architecture/decisions/ADR-0025-raise-msrv-to-1-88.md"
  - ".factory/cycles/cycle-013/phase-f2-spec-evolution/verification-delta.md"
  - "Cargo.toml"
  - ".github/workflows/ci.yml"
  - "tests/ci_gate_completeness.rs"
input-hash: "eace019"
traces_to: "ADR-0025 Decision + Consequences (Negative) §1"
cycle: cycle-013-msrv-1.88-bump
estimated_effort: small
estimated_days: 1
target_module: "Cargo.toml, .github/workflows/ci.yml, tests/ci_gate_completeness.rs"
subsystems: ["SS-09"]
depends_on: []
blocks: ["S-cycle13-letchain-retrofit-convention-cleanup", "S-cycle13-doc-policy-reconciliation"]
behavioral_contracts: []
bcs: []
# BC status: N/A by design — no BC-S.SS.NNN governs Rust-toolchain/MSRV version or the msrv
# CI job's pinned literals (F2 verification-delta.md §5 confirms BC-X.13.007 explicitly
# disclaims governing "the msrv job's toolchain-pinning guard ... with no corresponding BC
# or VP registered in this PRD"). This story's ACs trace to ADR-0025 and to
# tests/ci_gate_completeness.rs's own existing assertion shapes (which this story updates,
# not invents) instead of a BC.
verification_properties: ["VP-CIGATE-001"]
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0025"]
sd_refs: []
priority: P0
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-013/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: facade
module_criticality: HIGH
points: 5
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations: []
created: "2026-09-15"
version: "1.0"
last_updated: "2026-09-15"
breaking_change: true
retroactive: false
origin: >
  cycle-013 msrv-1.88-bump, Wave 1, no deps, blocks both other cycle-013 stories. F1 delta-
  analysis (.factory/cycles/cycle-013/phase-f1-delta-analysis/delta-analysis.md §3/§4)
  identifies tests/ci_gate_completeness.rs as the single HIGH-risk file in this cycle: it
  hard-pins the literal strings toolchain: "1.85.0" / RUSTUP_TOOLCHAIN: "1.85.0" at multiple
  assertion sites (confirmed this pass: grep -c "1.85.0" tests/ci_gate_completeness.rs = 30
  occurrences), and per CLAUDE.md's own CI-Gate section this file is one of the six files in
  the "review scope is SIX files, not one" set for anything CI-gate-adjacent. Landing
  Cargo.toml/ci.yml's version bump without updating this test's pinned literals in the SAME
  atomic commit breaks the ci-gate required check for every subsequent PR on develop/main —
  this is the coupling that makes cycle-013 non-trivial (F1 §1) and the reason this story
  cannot be split across two stories or two waves. ADR-0025 (Decision, Consequences/Negative
  §1) records the same coupling as the decision's primary trade-off. Human-approved at the F1
  gate (2026-09-15): MSRV target 1.88; widen msrv job to --all-targets; comfy-table re-pin via
  explicit pin-with-review (saphyr-parser convention).
---

> **tdd_mode:** `facade` — this story's "implementation" is a config/CI-contract change plus a
> literal-value update to an existing self-test (`tests/ci_gate_completeness.rs`), not new
> product code with a todo!()-stub Red Gate cycle. The existing test IS the verification
> mechanism; this story updates its pinned values in lockstep with the files it verifies.
> `module_criticality: HIGH` (not LOW) despite `tdd_mode: facade`, because a partial or
> out-of-order application of this story breaks the `ci-gate` required check for the whole
> repo — see Architecture Compliance Rules.

> **Execute:** `/vsdd-factory:deliver-story S-cycle13-msrv-cargo-ci-atomic-bump`

# S-cycle13-msrv-cargo-ci-atomic-bump — Mechanical MSRV bump (Cargo.toml + ci.yml + ci-gate self-test, atomic)

## Narrative

- **As a** `jr` maintainer merging PRs against `develop`/`main`
- **I want to** raise the declared and CI-enforced MSRV from 1.85 to 1.88 in `Cargo.toml` and
  the `msrv` CI job, with `tests/ci_gate_completeness.rs`'s pinned literals updated in the
  same atomic change
- **So that** `Cargo.toml`'s `rust-version` becomes true again for the full dependency graph
  (closing the `comfy-table`/`wiremock` false-MSRV gap ADR-0025 documents), the `msrv` job
  validates the real floor across `--all-targets` instead of a `lib + bins`-only carve-out, and
  the `ci-gate` required check never goes red from a self-test/workflow-file mismatch

## Behavioral Contracts

**No BC-S.SS.NNN anchors this story** (see frontmatter `# BC status` comment and
`bcs: []`/`behavioral_contracts: []`). This story's acceptance criteria trace to **ADR-0025**
(the decision record) and to the **existing, unmodified assertion shapes** in
`tests/ci_gate_completeness.rs` (this story changes the pinned *value* those assertions check,
not the assertions' shape or the property they verify — F2 verification-delta.md §3 confirms
`VP-CIGATE-001`'s assertion count and shape are unaffected by this cycle). Per the Spec-First
Gate (S-7.01), this story's `status:` MUST remain `draft` until `behavioral_contracts:`
transitions non-empty — it will not, by design, since no BC governs this surface; this story is
therefore dispatch-eligible under the `bcs: []`-with-ADR-anchor path this project already uses
for infrastructure-only F3 stories (precedent: `S-cycle7-oauth-help-text-fix`,
`S-cycle7-readme-migration-note`, both `bcs: []` with a non-BC trace target).

## Acceptance Criteria

### AC-001 (traces to ADR-0025 Decision — "rust-version = 1.88")
`Cargo.toml`'s `[package]` section reads `rust-version = "1.88"` (was `"1.85"`, line 7).
`edition = "2024"` is unchanged (already satisfies the let-chains edition gate; ADR-0025
Context).
**Test:** `cargo metadata --format-version=1 --no-deps | jq -r '.packages[] | select(.name=="jr") | .rust_version'` reads `1.88` (or the exact string `>=1.88`/`1.88`, cargo-metadata-normalized); `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` (below, AC-004) is the CI-facing half of this check.

### AC-002 (traces to ADR-0025 Decision — comfy-table re-pin, explicit pin-with-review)
`Cargo.toml`'s `comfy-table` dependency is no longer pinned to the stale `=7.2.1` exact
version. Per the human's F1-gate decision (explicit pin-with-review, mirroring the
`saphyr-parser = "=0.0.11"` convention already in this file — NOT a bare `"7"` caret range,
which ADR-0025's "Alternatives Considered" implicitly disfavors by analogy to the caret-range
risk that created the original `=7.2.1` pin), `comfy-table` is re-pinned to an exact,
human-reviewed version `>=7.2.2` (the implementer selects the current latest 7.x release at
implementation time and records it in the CHANGELOG per AC-007) with an inline comment
explaining the exact-pin rationale, replacing the stale comment that currently reads "Pinned to
7.2.1: 7.2.2 uses let-chains ... Pin holds until MSRV is raised to 1.88 in a dedicated story."
**Test:** `Cargo.toml` grep shows `comfy-table = "=7.2.X"` (X >= 2) with an updated inline
comment; `cargo update -p comfy-table --dry-run` (or equivalent) confirms no caret-range drift
is possible without a manifest edit.

### AC-003 (traces to ADR-0025 Rationale item 2 — stale saphyr-parser MSRV commentary, both stale clauses)
The `saphyr-parser = "=0.0.11"` dependency's inline comment (`Cargo.toml` ~L74-80) is updated to
reflect the new floor, in BOTH of its two stale clauses:
1. The "zero headroom" framing (currently: "this crate's own MSRV happens to be exactly 1.85.0
   against this repo's rust-version = "1.85", zero headroom") is stale once `rust-version` moves
   to 1.88 (saphyr-parser's own MSRV, unchanged at ~1.85, now sits *below* the repo floor with
   headroom, not at parity).
2. The immediately-following clause (currently: "but that is NOT enforced by the msrv CI job,
   since it's a dev-dependency and that job's `cargo check` scope is lib + bins only, not
   --all-targets") is ALSO stale, and independently so: AC-005's `--all-targets` widening of the
   `msrv` job means saphyr-parser (a `[dev-dependencies]` entry) is now genuinely compiled and
   checked by that job — leaving this "NOT enforced ... lib + bins only" claim in place would
   self-contradict AC-005 within the same commit. This clause is rewritten to state that
   saphyr-parser now sits below the 1.88 floor WITH headroom AND is enforced under the widened
   `--all-targets` `msrv` job scope.
**Test:** `Cargo.toml` grep confirms the comment no longer asserts "zero headroom" against a
"1.85" repo floor, and no longer asserts "NOT enforced ... lib + bins only, not --all-targets"
(both clauses updated in the same commit as AC-005's `ci.yml` widening, since clause 2's accuracy
depends on AC-005 actually landing).

### AC-004 (traces to ADR-0025 Consequences/Negative — the HIGH-risk `ci_gate_completeness.rs` coupling, atomic-commit requirement, PRINCIPLE-based)
`.github/workflows/ci.yml`'s `msrv` job (currently lines 248-275) has its job name
(`name: MSRV (1.85.0)` → `MSRV (1.88.0)`), the `dtolnay/rust-toolchain` step's
`with.toolchain: "1.85.0"` → `"1.88.0"`, the `cargo check` step's
`env.RUSTUP_TOOLCHAIN: "1.85.0"` → `"1.88.0"`, and the `uses: dtolnay/rust-toolchain@6c977a6ca...`
line's trailing `# 1.85.0` inline comment → `# 1.88.0` (~L259) all updated to `1.88.0`, in the
**same commit** as `tests/ci_gate_completeness.rs`'s corresponding assertions being updated.
The action SHA (`dtolnay/rust-toolchain@6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`) itself is
unchanged — only the `toolchain:`/`RUSTUP_TOOLCHAIN:` values and the trailing comment move.

**Principle (replaces the line-number enumeration approach; adopted at Pass-3 to dissolve
F-M1/F-M2/F-M3, whose root cause was a brittle line-by-line inventory that kept missing
grep-invisible line-wrapped copies and scattered parentheticals):** in the SAME atomic commit as
the `ci.yml` changes above, update EVERY current-contract reference in
`tests/ci_gate_completeness.rs` (and `ci.yml`, `Cargo.toml`) asserting or describing `1.85.0` as
the `msrv` job's live pinned value, changing it to `1.88.0` — while PRESERVING every
historical/illustrative account unchanged (HISTORICAL-PRESERVE allow-list below). Do not attempt
to hand-enumerate every line number: a full-string or single-location search reliably misses
line-wrapped copies and parenthetical asides. This atomicity rule is not limited to the
`1.85.0`→`1.88.0` version literals — it extends to **every** `ci.yml`↔`ci_gate_completeness.rs`
coupling this story's `ci.yml` edits touch, including the cargo-check run-line selector string
affected by AC-005's `--all-targets` widening (see AC-008, a distinct coupling from this AC's
version-literal coupling, landed in the same commit).

**Load-bearing literals (named explicitly — these are the ci-gate-RED-critical assertion sites
and MUST remain named regardless of the principle-based framing above):**
- `with.toolchain` assertion, `tests/ci_gate_completeness.rs` ~L3746
- `env.RUSTUP_TOOLCHAIN` assertion, `tests/ci_gate_completeness.rs` ~L3897

**HISTORICAL-PRESERVE allow-list (these STAY `1.85.0`, must NOT be changed by this AC or by the
Verification Gate below — completed at Pass-4 per finding F-B, which found the Pass-3 list
incomplete and confirmed by direct read this pass that all entries below are non-operative
comment/docstring/decoy prose, never a live assertion literal):**
- The commented-out `RUSTUP_TOOLCHAIN: "1.85.0"` decoy-fixture line, `tests/ci_gate_completeness.rs` ~L1571
  (sibling of the `:1568` `if:false`-bypass fixture immediately above it)
- The pre-fix dtolnay `1.85.0` version-branch account, `tests/ci_gate_completeness.rs` ~L3574
- The fix-mechanism prose describing what S-626-1's `with:`/`env:` values were,
  `tests/ci_gate_completeness.rs` ~L3579-3583
- The decoy narrative's own `with: {toolchain: "1.85.0"}` mention, `tests/ci_gate_completeness.rs` ~L3691
- The decoy narrative's `env: {RUSTUP_TOOLCHAIN: "1.85.0"}` mention, `tests/ci_gate_completeness.rs` ~L3796
- The decoy narrative's `{RUSTUP_TOOLCHAIN: "1.85.0"}` insertion mention, `tests/ci_gate_completeness.rs`
  ~L3857 — this entry and the next are a paired decoy/result and MUST be preserved TOGETHER
  (~L3857 is the decoy's inserted value, ~L3864 is the decoy narrative's asserted result;
  preserving one without the other leaves the decoy narrative self-contradictory)
- The RED-proof historical result "returned `RUSTUP_TOOLCHAIN="1.85.0"`",
  `tests/ci_gate_completeness.rs` ~L3864
- The `find_sole_step_by` docstring's illustrative decoy mention, `tests/ci_gate_completeness.rs` ~L6743

**Opportunistic bundled fix (unrelated to the version bump but touching the same file in
this same commit):** `tests/ci_gate_completeness.rs:~L3769`'s panic-message prose currently
reads "at the pinned SHA (`fa04a1451ff1842e2626ccb99004d0195b455a88`)" — this is a stale,
present-tense claim about the CURRENT pinned SHA (the real SHA is already
`6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772` and unchanged by this story); it is corrected to the
real SHA as part of this AC. This is distinct from CLAUDE.md's own stale-SHA citation (a
Gotchas-prose bullet), which is out of this story's file scope and is fixed instead by
`S-cycle13-doc-policy-reconciliation` AC-004.
**Test:** `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` (existing test,
`tests/ci_gate_completeness.rs::~L3673` onward) passes against the updated `ci.yml`, asserting
`toolchain: "1.88.0"` and `RUSTUP_TOOLCHAIN: "1.88.0"` (`ScalarStyle::DoubleQuoted`, exactly
once each) — **landing `ci.yml`'s change without this test's matching update, or vice versa,
fails the `ci-gate` required check outright; this AC is satisfied only by both changing in one
commit, never one without the other.** Additionally, the shared Verification Gate defined at the
end of AC-008 is run and passes before this story is considered complete.

### AC-005 (traces to human F1-gate decision — widen `msrv` job to `--all-targets`)
The `msrv` job's `cargo check` step scope widens from `lib + bins` (implicit default scope) to
`cargo check --all-targets --all-features --locked`, and the now-stale explanatory comment
block (lines ~263-272, citing `wiremock`'s ≥1.88 requirement as the reason for the narrow
scope) is removed — that reason no longer holds once the floor is 1.88, per ADR-0025's
"Alternatives Considered" (rejecting "keep scope narrow" because "the sole reason ... no longer
applies"). This closes the documented gap where inline `#[cfg(test)]` modules and integration
tests sat outside the `msrv` job's enforceable reach.
**Test:** `ci.yml` grep confirms `--all-targets` is present in the `msrv` job's `cargo check`
invocation and the wiremock-scope-justification comment block is gone; a live `msrv` job run
(post-merge, CI) exercises `cargo check --all-targets --locked` under 1.88.0 and passes —
this is the first time this repo's `#[cfg(test)]`/integration-test code is validated against
the MSRV floor, not just `lib + bins`.

### AC-006 (traces to ADR-0025 Consequences/Negative — comfy-table 7.2.2 rendering-fix regression tail)
After the `comfy-table` re-pin (AC-002), `cargo insta review` is run against
`src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` — the one and
only insta snapshot in the repo exercising table-mode rendering byte-for-byte (F1 §3 "Dependent
Files" table; F2 verification-delta.md does not re-litigate this, deferring to F1's analysis).
If the snapshot diff appears (comfy-table 7.2.2's documented "Fixed table misformatting without
vertical border styling" changelog entry), it is reviewed **visually**, not blindly
`cargo insta accept`-ed, and accepted only if the diff is a legitimate upstream rendering fix
(not a `jr`-introduced regression). If no diff appears, this AC is satisfied trivially (record
that outcome in the PR description either way).
**Test:** `cargo insta test` / `cargo insta review` run recorded in the PR description with the
outcome (diff-and-reviewed-accepted, or no-diff); full `cargo test` suite green either way.

**Note (F1 affected-files.txt row 19, `src/output.rs`, DEPENDENT/MEDIUM):** `src/output.rs` (the
`comfy-table` consumer) is not named by any AC in this story in its own right — a 7.2.1→7.2.2
patch bump is API-compatible, so any `output.rs` rendering breakage from the AC-002 re-pin is
caught transitively by this AC's insta-snapshot review plus the full `cargo test` suite run
(Task 12), not by a dedicated `output.rs`-specific AC.

### AC-007 (traces to CLAUDE.md conventions — CHANGELOG delivery task)
`CHANGELOG.md`'s `[Unreleased]` section gains a `Changed` entry documenting: the MSRV raise
(1.85→1.88), the `comfy-table` re-pin (from `=7.2.1` to the exact version selected in AC-002),
and the `msrv` job's `--all-targets` scope widening — mirroring the style of the prior
MSRV-correctness entry already in this file (S-626-1, per F1 §3's citation of
`CHANGELOG.md` L1065-1096 as "a good template to follow" — that block sits under the dated
`## [0.6.0] - 2026-08-13` release header, not `[Unreleased]`; this AC's own new entry is the one
that goes under `[Unreleased]`), including a "User impact: None for
binary/Homebrew users; source-builders need Rust ≥1.88" line.
**Test:** N/A (doc artifact; verified by PR review); presence check only.

### AC-008 (traces to ADR-0025 Consequences/Negative — ci-gate self-test run-line selector coupling with AC-005's `--all-targets` widening, PRINCIPLE-based)
AC-005 widens the `msrv` job's `cargo check` invocation from `cargo check --all-features
--locked` to `cargo check --all-targets --all-features --locked`. `tests/ci_gate_completeness.rs`
selects that step's run-line by an **exact string match** (`text == "cargo check --all-features
--locked"`, ~L3812) — widening `ci.yml` without updating this selector makes it match zero
steps, and the self-test panics (`ci-gate` goes RED for every subsequent PR).

**Principle (replaces the line-number enumeration approach; adopted at Pass-3 to dissolve
F-M1/F-M2/F-M3, whose root cause was a brittle line-by-line inventory that kept missing
grep-invisible line-wrapped copies and scattered parentheticals):** in the SAME atomic commit as
AC-005's `ci.yml` change, update EVERY current-contract reference in
`tests/ci_gate_completeness.rs` that quotes, selects on, or describes the `msrv` job's
`cargo check` run-line as `"cargo check --all-features --locked"` (the pre-AC-005 form) —
panic messages, docstrings, annotation comments, and selector-label strings alike — to the
widened literal `"cargo check --all-targets --all-features --locked"`. Do not attempt to
hand-enumerate every line number, for the same reason given in AC-004. This is a second, distinct
`ci.yml`↔`ci_gate_completeness.rs` coupling from AC-004's version-literal coupling, and is
equally load-bearing for keeping `ci-gate` green.

**Load-bearing literal (named explicitly — this is the ci-gate-RED-critical run-line SELECTOR
predicate and MUST remain named regardless of the principle-based framing above):**
- The exact-string step-lookup selector the self-test uses to find the `msrv` job's
  `cargo check` step, `tests/ci_gate_completeness.rs` ~L3812

**DECOY-PRESERVE allow-list (these intentionally keep the pre-AC-005 `"cargo check
--all-features --locked"` form; they are NOT current-contract citations and must NOT be changed
by this AC or by the Verification Gate below):**
- NIT-level hypothetical/illustrative fixtures, `tests/ci_gate_completeness.rs` ~L1568 and ~L2425
- The `find_sole_step_by` docstring's past-tense fix-burst-6 history narrative run-line half —
  "...has `run:` == `cargo check --all-features --locked`", but never..." —
  `tests/ci_gate_completeness.rs` ~L6739 (F1 Pass-5: the SOLE remaining gap after enumerating
  all 13 `cargo check…all-features` occurrences in this file). This is the sibling half of the
  SAME fix-burst-6 sentence whose other half — `env: {RUSTUP_TOOLCHAIN: "1.85.0"}` at ~L6743 —
  is already on AC-004's HISTORICAL-PRESERVE allow-list above; both halves are preserved
  unchanged TOGETHER, for the same reason the ~L3857/~L3864 paired decoy/result entry on that
  list must be preserved together
- `tests/common/wf.rs`'s ~L1782-1784 run-line examples — this is a hypothetical decoy-attack
  narrative in fixture/doc-comment form, NOT the real `msrv` job step shape (F-H1, Pass-3
  adversarial review: an earlier revision of this story mischaracterized `:1784` as "the real
  `RUSTUP_TOOLCHAIN` step shape" in the Architecture Mapping table and directed a Task to bump
  it — both were wrong and have been corrected; `wf.rs` is entirely out of this story's scope
  and is left untouched, consistent with this AC's original classification)

**Also in this same commit:** the `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env`
docstring at ~L3604-3608 currently asserts, as a live-contract claim, that "The `msrv` job
carries a 10-line scope-rationale comment discussing `--all-targets` and `--all-features` (why
the job omits the former and why the latter is a no-op for this crate)". AC-005 removes that
scope-rationale comment block from `ci.yml` entirely AND makes the job's `cargo check` now
**include** `--all-targets` — so this docstring's claim becomes false the moment AC-005 lands.
This docstring prose is rewritten to state that the `msrv` job's `cargo check` step now runs
`--all-targets` directly (no omission, no scope-rationale comment to discuss), and that the
third assertion's "not currently comment-satisfiable because the comment doesn't quote the full
run-line" reasoning is retired along with the comment itself.

**Docstring-rewrite scope also covers the ~L3594-3597 enumeration parenthetical (Pass-4, F-E):**
the SAME docstring's earlier parenthetical — "(The bare substring `1.85.0` also appears in the
job's `name:` line, the `dtolnay/rust-toolchain` version-pin comment, and two scope-rationale
comments — which is why the assertions below match the longer, key-qualified forms rather than
the bare version string.)" — enumerates FOUR bare-`1.85.0` sources, two of which
(the "two scope-rationale comments", confirmed this pass at `ci.yml` ~L265/~L271 — "cannot
compile at 1.85.0" and "require dev-dependencies that build at 1.85.0", both inside the same
wiremock-scope comment block AC-005 deletes) cease to exist the moment AC-005's comment-block
removal lands, going stale in the same commit for the same reason as the ~L3604-3608 claim above.
This parenthetical is rewritten in lockstep to drop "and two scope-rationale comments" and to
enumerate only the two bare-`1.85.0` sources that remain post-AC-005 (the job's `name:` line and
the `dtolnay/rust-toolchain` version-pin comment) — otherwise updated to `1.88.0` per AC-004's
own principle-based literal sweep.
**Test:** the self-test itself (the exact-string step lookup at
`tests/ci_gate_completeness.rs:~L3812`) locates and asserts against the widened run-line
successfully post-change; a local `cargo test --test ci_gate_completeness` run is green with
`ci.yml`'s AC-005 widening applied; the ~L3604-3608 docstring no longer claims the `msrv` job
"omits" `--all-targets` or carries a scope-rationale comment discussing that omission. **Landing
AC-005's `ci.yml` widening without this AC's selector/docstring update, or vice versa, fails the
`ci-gate` required check outright — same atomicity class as AC-004, never split across commits.**
The shared Verification Gate below is run and passes before this story is considered complete.

**Verification Gate (shared by AC-004 and AC-008 — REDESIGNED at Pass-4 per finding F-A. The
Pass-3 gate ran a bare file-wide `all-features` fragment grep and demanded every hit either show
`--all-targets` or sit on an allow-list. That is dangerously over-broad: `all-features` also
appears, legitimately and unrelatedly, in the CLIPPY job's run-line (`cargo clippy --all
--all-features --tests -- -D warnings`, asserted at `tests/ci_gate_completeness.rs:1823,1829`)
and the TEST job's run-line (`cargo test --all-features …`, asserted at many sites including
`:2512,2552,2599,2640,2968,2971,2984,2991,2994,2995,3003,3029,3362,3398`) — neither of which this
story touches or should ever touch. A naive attempt to make that blunt grep "pass" could mislead
an implementer into editing those unrelated clippy/test assertions, which would then mismatch
the real, unchanged `ci.yml` run-lines and drive `ci-gate` RED — precisely the failure this gate
exists to prevent. The redesign below replaces the blunt negative grep with a scoped positive
check, backed by the self-test as the real authority.):**

**PRIMARY gate — the actual RED-preventing check, and the acceptance evidence for both AC-004 and
AC-008 (run this first; treat it as authoritative, not the grep below):** run `cargo test --test
ci_gate_completeness` (Task 9(a)) and confirm it is green, alongside the full `cargo test` suite
(Task 12). `tests/ci_gate_completeness.rs` parses `ci.yml` via a real YAML event-stream parse and
asserts directly against it — a passing self-test IS the proof that `ci.yml`'s pinned literals and
run-line selector match what the test expects. **This — not a file-wide grep — is what makes
`ci-gate` green or red, and is the primary acceptance evidence for both this AC and AC-008.** The
two operative version-literal assertions (`with.toolchain` ~L3746, `env.RUSTUP_TOOLCHAIN`
~L3897) and the run-line selector predicate (~L3812) remain the named load-bearing edits this
gate exercises.

**SECONDARY gate — scoped + positive (required acceptance evidence alongside the self-test, for
the `all-features`/`--all-targets` coupling specifically):** run a grep SCOPED to lines that
actually mention `cargo check` together with `all-features` — never a bare `all-features`
search — so the clippy and test-job run-lines are structurally excluded (neither contains the
substring `cargo check`):
```
grep -nE 'cargo check[^|]*all-features' tests/ci_gate_completeness.rs .github/workflows/ci.yml
```
Every matching line MUST either (a) also show `--all-targets` on the same line (the AC-005-widened
form — the expected shape for every current-contract reference once this story lands), or (b) be
on the AC-008 DECOY-PRESERVE allow-list (~L1568, ~L2425, ~L6739 in `tests/ci_gate_completeness.rs`).
`tests/common/wf.rs` ~L1782-1784 is out of this grep's file scope entirely (that file is not
edited by this story, per the Architecture Mapping table and Task 9's note below) and is
confirmed untouched separately, not via this grep. Any hit that is neither (a) nor (b) is a stale,
unupdated current-contract reference and fails this gate.

For the `1\.85\.0` version-literal side of AC-004's coupling, the PRIMARY gate above is sufficient
acceptance evidence on its own (the self-test directly asserts the two operative literals) — no
separate scoped grep is required for that half.

**REVIEWER-ASSIST hint only — NOT a binary pass/fail acceptance gate, optional, never required,
and never grounds for editing anything outside the two gates above:** a bare, file-wide fragment
grep for `all-features` or `1\.85\.0` across `tests/ci_gate_completeness.rs` /
`.github/workflows/ci.yml` / `Cargo.toml` will ALSO surface the clippy run-line, the
`cargo test --all-features …` run-line, and every entry on the AC-004 HISTORICAL-PRESERVE and
AC-008 DECOY-PRESERVE allow-lists above. **These hits are expected and correct as-is. Do NOT edit
the clippy run-line, the `cargo test --all-features …` run-line, or any allow-listed
decoy/historical entry to make a bare grep "look clean."** A reviewer who runs this broader grep
for extra confidence must cross-check every hit against the HISTORICAL-PRESERVE list (AC-004) and
the DECOY-PRESERVE list (AC-008) before treating anything as a finding — a hit on either list is
not a finding.

Paste the PRIMARY gate's `cargo test` result and the SECONDARY gate's grep command plus full
output into the PR description as evidence both gates were run and passed — this is the ACs'
acceptance evidence, not merely a suggested sanity check.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| MSRV/edition manifest declaration | `Cargo.toml` | N/A (build metadata, not runtime code) |
| CI `msrv` job (toolchain pin, scope) | `.github/workflows/ci.yml` | N/A (CI workflow configuration) |
| CI-gate self-test (pinned literals) | `tests/ci_gate_completeness.rs` | Pure (parses/asserts against `ci.yml`'s text via a real YAML event-stream parse; no network/filesystem effects beyond reading the checked-in workflow file) |
| Decoy-attack narrative fixture — NOT the real `msrv` job step shape, left unchanged (F-H1, Pass-3: out of this story's scope, see AC-008 DECOY-PRESERVE allow-list) | `tests/common/wf.rs` (~L1782-1784) | Pure (fixture/doc-comment only) — read-only reference, never edited |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-001 | A PR lands `ci.yml`'s `msrv` job version bump without the matching `tests/ci_gate_completeness.rs` literal update, OR lands the `--all-targets` scope widening (AC-005) without the matching run-line-selector update (AC-008) — or either vice versa | `ci-gate` required check fails (`test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` fails against the mismatched literals; the exact-string step-lookup at `tests/ci_gate_completeness.rs:~L3806-3814` matches zero steps and panics against the mismatched run-line) — this is the intended fail-closed behavior, not a bug; AC-004 and AC-008 exist specifically to prevent these two distinct coupling failures by requiring one atomic commit each |
| EC-002 | `comfy-table`'s newly-selected exact version (AC-002) turns out to have its own unforeseen ≥1.89 dependency, or another dev-dependency besides `wiremock`/`comfy-table` silently requires >1.88 | F1 §4 risk table already flags this LOW (full `[dev-dependencies]` manifest reviewed this pass, no other candidate identified); if it occurs, `cargo check --all-targets --locked` under 1.88.0 (AC-005's own verification mechanism) fails loudly at CI time rather than silently — this story's own AC-005 test IS the detection mechanism for this edge case, not a separate guard |
| EC-003 | `cargo insta review` (AC-006) shows a snapshot diff that looks like more than a cosmetic border/spacing change (e.g., column reordering, data loss) | Treat as a genuine regression, not an upstream fix — do NOT accept; investigate whether the selected comfy-table version introduces a real behavior change beyond the documented border-styling fix, and consider pinning to a different `>=7.2.2` patch version instead |
| EC-004 | The `msrv` job at `--all-targets` scope surfaces a NEW compile failure in `tests/` or an inline `#[cfg(test)]` module that was previously invisible to this job (e.g., a test-only let-chain usage added before this story, or an MSRV-incompatible dev-dependency feature) | **Split by root cause.** (a) If the failure is fixable WITHIN the 1.88 floor (e.g., a stray test-only let-chain expression, a syntax issue, a fixable feature-flag mismatch) — this is the intended, desired outcome of AC-005 (closing the enforcement gap); fix the surfaced issue as part of this story rather than reverting the scope widening. **Effort-risk acknowledgment (distinct from case (b)'s external-dependency scenario):** the `tests/` tree and inline `#[cfg(test)]` modules have NEVER been compiled at the MSRV floor before — the pre-existing `msrv` job was `lib + bins`-only — and today they build only under `stable` (far newer than 1.88.0). `--all-targets` at 1.88 could therefore surface not just one "stray" usage but a genuinely PERVASIVE set of our-own post-1.88 feature usages across test code (not a hypothetical dependency issue — our own code), each requiring a real rewrite, not a one-line fix. If the surfaced set of fixable-in-1.88 issues turns out to be pervasive rather than isolated, that is itself an F4 discovery to surface explicitly (in the PR description and to the orchestrator) rather than silently absorbed into this story's existing point budget — do not quietly expand scope past what "small"/5-points assumed. (b) If the failure's root cause is a dependency (dev-dependency or otherwise) that genuinely REQUIRES a Rust version `>1.88` to compile — this invalidates the 1.88 MSRV target itself, which is a human re-decision (a new/amended ADR-0025 target), not something this story can silently "fix" by bumping the target higher or patching around it. In case (b), STOP, do not merge, and escalate back to the human F1-gate decision point rather than absorbing the re-target into this story's scope. |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `Cargo.toml` | N/A (build manifest) | Not source code |
| `.github/workflows/ci.yml` | N/A (CI configuration) | Not source code |
| `tests/ci_gate_completeness.rs` | pure-core (test code) | Parses a checked-in text file via `saphyr-parser`'s event stream and asserts on it; no network, no mutation of external state |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~3,200 |
| Referenced code (`Cargo.toml` full, `ci.yml` `msrv` job region, relevant `ci_gate_completeness.rs` assertion functions — NOT the full 7,000+-line file, only the ~250-line `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` region + its helper fns) | ~9,000 |
| Test files (existing `ci_gate_completeness.rs` assertions being updated; `tests/common/wf.rs`'s ~L1782-1784 decoy-narrative region, read-only, to confirm it is out of scope per AC-008) | ~4,000 |
| Tool outputs overhead (cargo check, cargo test, cargo insta review output) | ~3,000 |
| **Total** | **~19,200** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~10%** |

Well within budget. The implementer should NOT read the full `tests/ci_gate_completeness.rs`
file (7,000+ lines per CLAUDE.md's own file-size notes) — targeted `grep -n "1.85.0"` plus
reading only the flagged line regions is sufficient and keeps this story's actual working
context far below the estimate above.

**Effort-risk note (EC-004(a)):** the `estimated_effort: small` / `points: 5` / `estimated_days:
1` figures above assume AC-005's `--all-targets` widening surfaces at most a small, isolated set
of fixable-in-1.88 issues in `tests/`/`#[cfg(test)]` code (per EC-004(a)'s intended-outcome
case). Because that code has never before been compiled at the MSRV floor, this assumption is
unverified until AC-005's `cargo check --all-targets --locked` actually runs under 1.88.0 — if it
surfaces a pervasive rather than isolated set of our-own post-1.88 usages requiring real
rewrites, treat that as an F4 discovery to surface explicitly rather than silently absorbing the
extra effort into this story's existing estimate.

## Tasks

1. [ ] `Cargo.toml`: bump `rust-version` 1.85 → 1.88 (AC-001) — `implementer`
2. [ ] `Cargo.toml`: re-pin `comfy-table` to an exact reviewed `>=7.2.2` version with an updated
   inline comment (AC-002) — `implementer`
3. [ ] `Cargo.toml`: refresh the `saphyr-parser` "zero headroom" comment (AC-003) —
   `implementer`
4. [ ] `.github/workflows/ci.yml`: update the `msrv` job's name, `toolchain:`,
   `RUSTUP_TOOLCHAIN:`, and the `uses: dtolnay/rust-toolchain@6c977a6ca...` line's trailing
   `# 1.85.0` inline comment (~L259) — all to `1.88.0` (AC-004) — `implementer`
5. [ ] `.github/workflows/ci.yml`: widen the `msrv` job's `cargo check` to `--all-targets`,
   remove the stale wiremock-scope comment block (AC-005) — `implementer`
6. [ ] `tests/ci_gate_completeness.rs`: apply AC-004's PRINCIPLE — update EVERY current-contract
   `"1.85.0"` reference to `"1.88.0"` (not a hand-built line-number list), explicitly confirming
   the two load-bearing literals (`with.toolchain` ~L3746, `env.RUSTUP_TOOLCHAIN` ~L3897) land
   correctly; LEAVE every entry on the AC-004 HISTORICAL-PRESERVE allow-list (~L3574,
   ~L3579-3583, ~L3864) at `1.85.0` — read each occurrence's surrounding sentence tense before
   editing (AC-004) — `implementer`, **same commit as Task 4/5**
7. [ ] `tests/ci_gate_completeness.rs:~L3769`: correct the panic-message's stale, present-tense
   SHA citation ("at the pinned SHA (`fa04a1451...`)") to
   `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772` — an opportunistic bundled fix, unrelated to the
   version bump but touching the same file in the same commit (AC-004) — `implementer`
8. [ ] `tests/ci_gate_completeness.rs`: apply AC-008's PRINCIPLE — update EVERY current-contract
   reference to the `msrv` job's `cargo check` run-line (panic messages, docstrings, annotation
   comments, selector-label strings) from `"cargo check --all-features --locked"` to
   `"cargo check --all-targets --all-features --locked"` (not a hand-built line-number list),
   explicitly confirming the load-bearing run-line SELECTOR predicate (~L3812) lands correctly;
   LEAVE every entry on the AC-008 DECOY-PRESERVE allow-list (~L1568, ~L2425, and
   `tests/common/wf.rs` ~L1782-1784 — read-only, NOT edited, see Task list note below)
   unchanged; separately rewrite the ~L3604-3608 docstring prose that currently claims the
   `msrv` job "carries a 10-line scope-rationale comment" and "omits" `--all-targets` — both now
   false once AC-005 lands (AC-008) — `implementer`, **same commit as Task 5**
9. [ ] Run the AC-004/AC-008 shared Verification Gate (redesigned at Pass-4, F-A):
   (a) **PRIMARY** — `cargo test --test ci_gate_completeness` green (this is the real
   `ci-gate`-integrity evidence, not the grep below);
   (b) **SECONDARY** — the scoped positive grep `grep -nE 'cargo check[^|]*all-features'
   tests/ci_gate_completeness.rs .github/workflows/ci.yml`, confirming every hit either shows
   `--all-targets` alongside `--all-features` or sits on the AC-008 DECOY-PRESERVE allow-list —
   including `tests/ci_gate_completeness.rs` ~L6739 (the `find_sole_step_by` docstring's
   past-tense fix-burst-6 history run-line half; leave it unchanged, parallel to AC-004's
   HISTORICAL-PRESERVE ~L6743 sibling covering the other half of that same sentence).
   Do NOT edit the clippy (`cargo clippy --all --all-features --tests`) or test-job
   (`cargo test --all-features …`) run-lines — the grep's `cargo check` anchor structurally
   excludes them, and they must stay untouched. Paste both gates' commands/output into the PR
   description as evidence (AC-004, AC-008) — `implementer`, **same commit as Task 6/8, run
   after both**

   **Note on `tests/common/wf.rs` (F-H1, Pass-3):** `wf.rs` is explicitly OUT of this story's
   scope. Its ~L1782-1784 run-line examples are decoy/fixture narrative for a hypothetical
   attack scenario, not the real `msrv` job step shape — see AC-008's DECOY-PRESERVE allow-list
   and the Architecture Mapping table above. No task in this story modifies `wf.rs`; it is read
   only, to confirm (during Task 9's grep pass) that it stays on the allow-list and is left
   untouched.
10. [ ] Run `cargo check --all-features --locked` and `cargo check --all-targets --locked`
    locally under a real 1.88.0 toolchain (or `rustup run 1.88.0 cargo check ...`) to confirm
    AC-001/AC-005 before pushing — `implementer`
11. [ ] Run `cargo insta test` / `cargo insta review` against
    `list_table_snapshot.snap`; visually review any diff before accepting (AC-006) —
    `implementer`
12. [ ] Run the full `cargo test` suite (including `tests/ci_gate_completeness.rs` and
    `tests/mutants_glob_existence.rs`) green — `implementer`
13. [ ] Add a CHANGELOG entry under `[Unreleased] > Changed` (AC-007), before creating the PR —
    `implementer`
14. [ ] PR description explicitly calls out that this is the ONE atomic commit landing `ci.yml`
    and `tests/ci_gate_completeness.rs` together for BOTH couplings — the version-literal
    coupling (AC-004) AND the run-line-selector coupling (AC-008) — per the six-file CI-Gate
    review-scope convention in CLAUDE.md, and includes the Task 9 Verification Gate evidence —
    `implementer`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| S-626-1 (prior MSRV-correctness fix, cited in CLAUDE.md Gotchas and `CHANGELOG.md` L1065-1096) | Established the `RUSTUP_TOOLCHAIN` env-override pattern (outranks `rust-toolchain.toml`) and the "User impact: None for binary users" CHANGELOG framing this story's AC-007 should mirror | `tests/ci_gate_completeness.rs`'s pinned-literal-assertion mechanism for the `msrv` job; the six-file CI-Gate review-scope convention | The action SHA replacement (`fa04a1451...` → the then-current SHA) was a HARD prerequisite alongside the `with:`/`env:` values — this story does NOT touch the SHA (it's already correct at `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`, confirmed by direct read this pass; CLAUDE.md's OWN citation of the SHA is stale and is fixed by `S-cycle13-doc-policy-reconciliation`, not this story) |
| N/A — first cycle-013 story, no prior cycle-013 stories exist | — | — | — |

_This is Wave 1's sole story for cycle-013; `S-cycle13-letchain-retrofit-convention-cleanup`
and `S-cycle13-doc-policy-reconciliation` (both Wave 2, `depends_on: [S-cycle13-msrv-cargo-ci-atomic-bump]`)
will read this story's actual PR outcome — the exact comfy-table version selected in Task 2 and
whether the insta snapshot changed in Task 11 — as their own "Previous Story Intelligence" input._

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| `ci.yml`'s `msrv` job change and `tests/ci_gate_completeness.rs`'s matching updates MUST land in the same atomic commit — never split across two PRs/commits. This covers **every** coupling this story's `ci.yml` edits create, not only the `1.85.0`→`1.88.0` version literals: (1) the `toolchain:`/`RUSTUP_TOOLCHAIN:` value literals (AC-004), and (2) the `cargo check` run-line selector string used by the self-test's exact-match step lookup (AC-008, triggered by AC-005's `--all-targets` widening) | ADR-0025 Consequences (Negative) §1; F1 delta-analysis.md §4 ("HIGH" risk row); CLAUDE.md CI Gate section ("review scope is SIX files, not one") | PR review: reject any PR that touches one file without the other, for EITHER coupling; `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` fails CI if the version literals diverge, and the self-test's exact-string step lookup (`~L3806-3814`) panics if the run-line selector diverges from AC-005's widened invocation |
| `ci-gate` is THE single required branch-protection status check — new/changed jobs go into `ci-gate.needs`, never wired directly into branch protection | CLAUDE.md "CI Gate — SCOPE SUMMARY" | This story does not add a new job to `ci-gate.needs` (the `msrv` job already exists there); no action needed beyond not breaking the existing membership |
| Do not skip hooks or bypass CI gates to land this change faster | CLAUDE.md Git Safety Protocol | Standard PR flow through `develop`, full `ci-gate` green required |
| Exact-pin-with-review convention for MSRV-surprise-prone dependencies (not a caret range) | `saphyr-parser = "=0.0.11"` precedent already in `Cargo.toml`; human F1-gate decision this cycle | AC-002's `comfy-table` re-pin must be an exact version string (`"=7.2.X"`), not `"7"` or `">=7.2.2"` |

## Library & Framework Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| Rust toolchain (MSRV floor) | 1.88.0 (was 1.85.0) | New declared/enforced minimum — `dtolnay/rust-toolchain@6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772` action, SHA unchanged |
| `comfy-table` | `=7.2.X` where X >= 2, exact version selected by implementer at delivery time (current latest 7.x per crates.io at implementation time) | Table rendering; the version whose let-chain-using internals require ≥1.88 (ADR-0025 Context) |
| `saphyr-parser` | `=0.0.11` (unchanged) | YAML event-stream parsing for `ci_gate_completeness.rs` (S-CIGATE-3); comment-only update, no version change |
| `wiremock` | `0.6` (unchanged) | Now compiles under the widened `--all-targets` `msrv` job scope (was the reason for the prior narrow-scope carve-out) |

_No new dependency is added by this story — only version-floor and pin-strategy changes to
existing manifest entries._

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `Cargo.toml` | modify | `rust-version` bump, `comfy-table` re-pin, `saphyr-parser` comment refresh (AC-001/002/003) |
| `.github/workflows/ci.yml` | modify | `msrv` job name/toolchain/env bump, `--all-targets` scope widening (AC-004/005) |
| `tests/ci_gate_completeness.rs` | modify | Every current-contract `"1.85.0"` reference → `"1.88.0"` per AC-004's principle (historical narrative on the HISTORICAL-PRESERVE allow-list left unchanged); stale SHA panic-message fix at ~L3769 (AC-004); every current-contract `cargo check --all-features --locked` run-line reference → the widened `--all-targets` form per AC-008's principle (DECOY-PRESERVE allow-list left unchanged) — same commit as `ci.yml`; Verification Gate (Task 9) run and its output recorded in the PR |
| `tests/common/wf.rs` | none — out of scope (F-H1, Pass-3) | Decoy/fixture narrative at ~L1782-1784, NOT the real `msrv` job step shape; read-only during the Task 9 grep pass, never edited (see AC-008 DECOY-PRESERVE allow-list) |
| `CHANGELOG.md` | modify | `[Unreleased] > Changed` entry (AC-007) |
| `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` | modify (conditional, via `cargo insta accept` only after visual review) | Only if the comfy-table re-pin changes table rendering output (AC-006) |
