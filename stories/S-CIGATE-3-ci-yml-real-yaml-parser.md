---
document_type: story
level: ops
story_id: "S-CIGATE-3"
epic_id: "none"
title: "Replace tests/ci_gate_completeness.rs's line-based YAML extraction with a real YAML parser"
version: "1.0"
producer: story-writer
timestamp: "2026-08-06T00:00:00"
phase: 3
cycle: CIGATE-REAL-YAML-PARSER
inputs:
  - ".github/workflows/ci.yml"
  - "tests/ci_gate_completeness.rs"
input-hash: "699e503"
traces_to: "tests/ci_gate_completeness.rs (residual documented in fix/ci-gate-skipped-false-green commit cf00f2fc)"
wave: feature-followup
status: draft
intent: tech-debt
feature_type: ci
mode: feature
scope: small
severity: MEDIUM
trivial_scope: false
points: 8
priority: P2
tdd_mode: strict
estimated_effort: standard
estimated_days: 2
target_module: ci
subsystems: []
depends_on: ["S-CIGATE-2"]
blocks: []
behavioral_contracts: []
bc_anchors: []
bcs: []
# BC status: no product BCs (CI-test-infra refactor; trace ACs to the residual documented in
# S-CIGATE-2's close-out commit `cf00f2fc` and to CLAUDE.md's ci-gate conventions). BC catalog
# untouched. Do NOT add BCs.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F1-delta-analysis
spec_source: "No pre-existing delta-analysis document. Written from a direct read of
  .github/workflows/ci.yml, tests/ci_gate_completeness.rs (develop HEAD, 8 tests) and the
  in-flight fix/ci-gate-skipped-false-green branch (.worktrees/S-CIGATE-2, 17 tests,
  commit cf00f2fc — read-only, not modified by this story), plus the S-CIGATE-1/S-CIGATE-2
  story files, on 2026-08-06."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 6
assumption_validations: []
risk_mitigations:
  - "Scoped as an evaluate-then-implement story rather than a pre-committed library choice:
     the brief that originated this story presumed a fix category (real parser) without
     naming a library; this story requires a documented supply-chain evaluation (AC-001)
     before any Cargo.toml change, because MSRV 1.85 + `cargo deny check` compliance are
     both load-bearing CI gates in this repo and `serde_yaml` (the obvious first guess) is
     unmaintained (see AC-001)."
created: "2026-08-06"
last_updated: "2026-08-06"
breaking_change: false
files_modified:
  - tests/ci_gate_completeness.rs   # MODIFY: parse ci.yml once via the chosen approach; assert structure over the parsed tree; retain today's byte-for-byte scalar pins as a SECOND assertion layer over parsed values, not a replacement
  - Cargo.toml                      # MODIFY (dev-dependencies): add the chosen YAML-parsing crate, OR no change if the shell-out-to-PyYAML approach is chosen instead
  - Cargo.lock                      # MODIFY: lockfile update for the new dependency (if a crate is chosen)
  - deny.toml                       # MODIFY (conditional): only if the chosen crate or one of its transitive deps needs an explicit allow/skip entry
  - CLAUDE.md                       # MODIFY: document the chosen parsing approach and the "byte pins are a second layer, not the only layer" convention under the existing ci-gate bullet
---

# S-CIGATE-3 — Replace Line-Based YAML Extraction with a Real YAML Parser

## Source of Truth

`.github/workflows/ci.yml` (develop HEAD, 445 lines) and `tests/ci_gate_completeness.rs`
(develop HEAD, 750 lines / 8 test functions, built on `read_ci_yml()` + `parse_needs_set()`
source-text helpers — no YAML library is used today).

The durable-fix direction and its motivating defect were established, not invented here, by
the in-flight `fix/ci-gate-skipped-false-green` branch's close-out commit `cf00f2fc`
("docs(ci-gate): document node-properties residual risk, not fixed (close-out, human
decision)"), read from `.worktrees/S-CIGATE-2` for this story (read-only — that worktree is
frozen pending merge and is NOT touched by this story). That commit's message states
verbatim: *"A follow-up story to replace line-based extraction with a real YAML parser is
tracked separately and is NOT opened by this change."* This story is that follow-up.

**Independently re-verified for this story (2026-08-06), not taken on report:**

- On the frozen branch, `tests/ci_gate_completeness.rs` has grown to 3,887 lines / 17 test
  functions, all built on the same three line-based primitives: `read_ci_yml()`,
  `collect_mapping_key_set()`, and `extract_key_name_at_indent()`. Six independent members of
  the "lexer disagrees with a real YAML parser" defect class were found across three
  consecutive PR #671 review rounds while hardening these primitives (per `cf00f2fc`'s own
  history summary): comment-indentation truncation in `collect_mapping_key_set` (round 13),
  UTF-8 BOM prefix (round 13), YAML explicit-key syntax `? key` (round 13), lone CR (U+000D)
  and three Unicode line breaks — NEL U+0085, LS U+2028, PS U+2029 (round 14), and **key-level
  node properties — `&anchor` / `!tag` / `!!tag` prefixing a mapping key on the same physical
  line (round 16, left open)**. The finding rate across these three rounds is flat, not
  decaying.
- The open member is demonstrable and was independently verified against real YAML parsers
  (PyYAML and Ruby Psych), not merely asserted: inserting `        &x shell: cat {0}` as a
  one-line addition to the `ci-gate` step's mapping is parsed by both loaders as adding a real
  `shell:` key (`["env","name","run","shell"]`, `shell: "cat {0}"` — the same custom-shell-
  template override rounds 11/14 already showed defeats the pinned `run:` line), while
  `extract_key_name_at_indent`'s bare-key branch stops at the space after `&x`, sees no colon,
  returns `None`, and is invisible to every key-set pin built on that function. The frozen
  branch's own commit records a full 17/17 green run of the existing suite with this line
  present.
- **What is NOT established** (per `cf00f2fc`, restated here rather than overclaimed): this
  repo's exact payload has not been executed against a real GitHub Actions runner by anyone —
  only against PyYAML/Ruby Psych locally. GitHub shipped YAML anchor/alias support to
  production Actions on 2025-09-18 (per the official github.blog changelog cited in
  `cf00f2fc`), so the underlying mechanism is confirmed live, not hypothetical — but the
  runner-level reproduction of this specific payload is a separate, unverified claim this
  story does not need to re-derive to justify the fix (a real parser closes the *class* of
  gap, independent of whether this exact payload has been run against a live runner).
- `cf00f2fc`'s own framing of the durable fix, restated precisely because a prior round (11)
  conflated two different proposals: round 11 *correctly* rejected "hand-roll a full
  block-mapping parser" as impractical; it did **not** reject, and this story does not
  re-litigate, the separate and always-viable option of using an **off-the-shelf YAML
  parser** — the same category `actionlint` and GitHub's own runner both use.

## Behavioral Contracts

No product BCs are added or modified. BC catalog untouched. This story traces its ACs to the
residual risk documented in `fix/ci-gate-skipped-false-green`'s close-out commit `cf00f2fc`
and to `CLAUDE.md`'s `ci-gate` convention bullet, following the same no-BC convention used by
`S-CIGATE-1` and `S-CIGATE-2` for CI-test-infra-only stories.

## Story Narrative

As a maintainer of `jr`,
I want `tests/ci_gate_completeness.rs`'s structural assertions about `.github/workflows/ci.yml`
to be built on a real YAML parse tree instead of a hand-rolled line-by-line lexer,
so that the "lexer disagrees with a real parser" defect class — which has produced a new,
previously-undiscovered member every round for three consecutive rounds of adversarial review,
each one capable of defeating every existing set-equality pin with a single, syntactically
valid, one-line YAML addition — is closed structurally rather than patched member-by-member.

## Problem Statement

Every one of `tests/ci_gate_completeness.rs`'s test functions is built on `read_ci_yml()` →
`str::lines()` → hand-rolled indent/key extraction (`extract_key_name_at_indent`,
`collect_mapping_key_set`, and siblings on the frozen branch). This is a partial
re-implementation of a YAML lexer that has repeatedly proven narrower than the YAML spec
actual runners implement against. Patching each discovered gap (BOM, explicit-key syntax,
Unicode line breaks, now node properties) treats a structural mismatch — "a string-splitting
approximation of a context-free grammar" — as a series of unrelated bugs. The fix pattern is
the same each time (widen the lexer's character/token acceptance) and the finding rate has
not decayed after three rounds, which is evidence the approximation has an unbounded number of
remaining gaps, not a small finite list.

## Approach

Parse `.github/workflows/ci.yml` **once**, with a real YAML parser, into a structured
document. Assert `ci-gate`/`mutants`/`spec-guard`/other-gated-job structure (job existence,
`needs:` membership, `if:` conditions, step bodies) **over the parsed tree** — key lookups,
not line-position arithmetic. Retain today's byte-for-byte scalar pins (e.g. the exact `run:`
step body text, the exact `if:` expression string) as a **second assertion layer applied to
values read out of the parsed tree**, not as a replacement for structural parsing and not
deleted. This dual-layer design is deliberate: the parse-tree layer closes the lexer-fidelity
gap class (this story's purpose); the byte-pin layer keeps catching semantically-inert
whitespace/formatting drift that a structural-equality check alone would treat as unchanged
(the property that made byte pins valuable in the first place, per round 10's original
rationale).

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| `S-CIGATE-1` | Introduced the `ci-gate` aggregator job; used source-text grep testing of `ci.yml` (no YAML parser dependency) as the original, pragmatic choice for a ~20-line job. | `extract_job_block()`-style helper anchoring assertions to one job's slice, to avoid cross-job false matches — established the pattern this story's assertions must migrate off of. | A source-text-grep approach that was adequate for a single, small, newly-added job did not scale as the file grew and came under adversarial review — the same lesson `S-CIGATE-2` records independently. |
| `S-CIGATE-2` | Kept `ci-gate.needs` as the single source of truth and moved the pass/fail *decision* logic into an extracted, self-tested shell script (`scripts/check-ci-gate.sh`) rather than inline YAML — a "decision logic in scripts/, source-text pins in tests/" split. | 20+ PR #671 review rounds hardened `tests/ci_gate_completeness.rs`'s line-based extraction helpers one member at a time (BOM, explicit-key syntax, Unicode line breaks, comment-indentation truncation) — each round found a NEW member of the same defect class, not a one-off bug. | The line-based approximation of a YAML lexer has an apparently unbounded number of remaining gaps (round 16's node-properties finding was the third consecutive round to find a new member, at a flat, non-decaying rate) — the close-out commit `cf00f2fc` explicitly named "parse once with a real YAML parser" as the durable fix and deferred it to this story rather than attempting a fourth patch-in-place round. |

_Populated from a direct read of `S-CIGATE-1`, `S-CIGATE-2`, and the frozen
`fix/ci-gate-skipped-false-green` branch's commit history (`cf00f2fc` specifically) — the two
prior stories to touch this exact file, plus the branch that discovered and documented this
story's motivating defect._

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Parse once, assert many times | This story | `ci.yml` is parsed into a document exactly once per test-binary run (or once per test, if per-test isolation is preferred for failure-message clarity) — not re-parsed line-by-line per assertion. |
| Byte pins are a second layer, not deleted | Brief instruction; `cf00f2fc` rationale | Every existing byte-for-byte scalar pin (`run:` step bodies, `if:` expression strings) is retained and re-anchored to read its input from the parsed tree's scalar value, not from a fresh substring/line search. |
| MSRV 1.85 compliance | `CLAUDE.md` Build & Test; `Cargo.toml::rust-version` | Any new crate dependency (test-scoped or otherwise) MUST compile under the pinned 1.85 toolchain (`rust-toolchain.toml`); verified by the existing `msrv` CI job, not a new one. |
| `cargo deny check` compliance | `CLAUDE.md` Build & Test | Any new crate dependency MUST pass `cargo deny check` (license + vulnerability audit) with zero new advisories/license violations, or ships with an explicit, justified `deny.toml` allow/skip entry. |
| No change to `ci-gate`'s runtime evaluator | Scope boundary (this story vs. S-CIGATE-2) | `scripts/check-ci-gate.sh` (S-CIGATE-2/PR #671) evaluates `toJSON(needs)` at CI **runtime** — it does not parse `ci.yml` itself and is unaffected by this story. This story is scoped entirely to the **static test-time** assertions in `tests/ci_gate_completeness.rs`. |

## Library & Framework Requirements (MANDATORY)

**No library is pre-selected — evaluating and selecting one is AC-001 of this story.**
Candidates to evaluate, per the originating brief and independent confirmation:

| Candidate | Notes to verify at implementation time |
|-----------|----------------------------------------|
| `serde_yaml` | Officially unmaintained (author archived the repo); do not adopt without a documented reason to override that status — the default expectation is REJECT. |
| `saphyr` | Newer, spec-focused YAML 1.1/1.2 parser; verify MSRV 1.85 compatibility, `cargo deny` license (MIT/Apache dual per most Rust YAML crates, verify exactly), and API ergonomics for the "parse once, query by job/key path" access pattern this story needs. |
| `yaml-rust2` | Fork of the unmaintained `yaml-rust`; verify current maintenance activity, MSRV, and license before adoption. |
| Shell out to PyYAML (or Ruby Psych) | Precedent exists in this exact repo: `tests/ci_gate_completeness.rs`-adjacent `scripts/check-signing-workflow-injection.sh` and `scripts/check-ci-gate.sh` are both already shelled-out-to from CI, and `scripts/*.sh` generally is an established pattern here. Verify: (a) `python3`/PyYAML availability on `ubuntu-latest` without an extra `pip install` step (adds CI time + a new supply-chain surface of its own), (b) whether shelling out from a `#[test]` fn (`std::process::Command`) is acceptable given this repo's "hermetic, no network, no external process" convention for `tests/` generally — verify against existing test conventions before assuming this is equivalent to the shell-script precedent. |

Whichever is chosen, the decision and its rationale (including the rejected alternatives and
why) MUST be recorded in this story's Verification Log or a follow-up ADR — do not leave the
choice implicit in a diff.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|--------------|
| `tests/ci_gate_completeness.rs` | MODIFY | Replace `read_ci_yml()`'s line-based consumers with a single parse step; rewrite structural assertions (job existence, `needs:` set membership, `if:` presence) to query the parsed tree; retain byte-for-byte scalar pins as a second layer over parsed values. |
| `Cargo.toml` | MODIFY (conditional) | Add the selected YAML-parsing crate under `[dev-dependencies]` if a crate (not shell-out) is chosen. |
| `Cargo.lock` | MODIFY (conditional) | Lockfile update accompanying the `Cargo.toml` change. |
| `deny.toml` | MODIFY (conditional) | Only if `cargo deny check` flags the new dependency or a transitive dependency and an explicit, justified allow/skip entry is warranted. |
| `CLAUDE.md` | MODIFY | Extend the existing `ci-gate` Conventions bullet (or add a sibling bullet) documenting: `tests/ci_gate_completeness.rs` asserts over a real parsed YAML tree, with byte-for-byte scalar pins as a second, non-exclusive layer — so a future contributor extending this file does not reintroduce line-based extraction. |

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|-----------------|----------------|
| Parsed-tree structural assertions | `tests/ci_gate_completeness.rs` | pure-core | Reads `ci.yml` as bytes, parses via the chosen YAML approach, and asserts on the resulting tree/values only — no network, no filesystem writes, no `cargo mutants` invocation |
| Byte-for-byte scalar pins (second layer) | `tests/ci_gate_completeness.rs` | pure-core | Asserts exact string equality on scalar values read out of the parsed tree — hermetic and deterministic given a fixed `ci.yml` |
| `ci-gate` / `mutants` / `spec-guard` job definitions | `.github/workflows/ci.yml` | effectful-shell (CI config, not Rust) | Unmodified by this story — this story only changes how the job definitions are *asserted against* in tests, not the definitions themselves |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `tests/ci_gate_completeness.rs` | pure-core | Reads `ci.yml` as a string/bytes and asserts on parsed structure and scalar values only; no network calls, no script execution, no filesystem writes beyond reading the one tracked file — fully hermetic and deterministic given a fixed `ci.yml`, matching this file's existing classification (unchanged by this story) |
| The chosen YAML-parsing dependency (crate or shelled-out interpreter) | pure-core (crate) / effectful-shell (shell-out) | A crate-based parser is a pure, in-process function call (no I/O beyond reading the already-open file). The shell-out alternative (invoking `python3`/PyYAML as a subprocess) would be effectful — this classification difference is itself an input to the AC-001 evaluation, since a pure-core-preserving choice is preferable, all else equal |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~4,500 |
| `.github/workflows/ci.yml` (current, 445 LOC) | ~4,800 |
| `tests/ci_gate_completeness.rs` (develop HEAD, 750 LOC; up to ~3,900 LOC on the not-yet-merged `S-CIGATE-2` branch — re-read at implementation time) | ~9,000–45,000 (wide range depending on merge-time file size) |
| `S-CIGATE-1` / `S-CIGATE-2` story files (cross-reference for Previous Story Intelligence) | ~5,000 |
| Candidate YAML crate docs (`saphyr` / `yaml-rust2`) research overhead | ~2,000 |
| **Total** | **~25,300–61,300** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~13–31%** |

At the upper end of the range (if implementation begins before `tests/ci_gate_completeness.rs`
has been trimmed post-merge), this approaches the 20–30% target ceiling — the implementer
should re-check actual file size at dispatch time and consider splitting the rewrite (e.g.
one pass per job-block's assertions) if the file has grown substantially beyond the 3,900 LOC
observed on the frozen branch.

## Acceptance Criteria

### AC-001 — Documented library/approach evaluation, not a pre-committed choice

A YAML-parsing approach is evaluated against MSRV 1.85, `cargo deny check`, license, and
maintenance-status criteria across at least the four candidates listed above (or others found
during evaluation), and the chosen approach is recorded with its rationale (this story's
Verification Log, or a new ADR if the choice is judged architecturally significant enough to
warrant one — implementer's judgment, consistent with `ADR-0001`–`ADR-0003`'s precedent of
recording dependency-choice ADRs for this repo's other core dependencies).

### AC-002 — `ci.yml` is parsed once into a structured tree; job/needs/if: structure is asserted over that tree

`tests/ci_gate_completeness.rs` parses `.github/workflows/ci.yml` via the chosen approach
exactly once (per test-binary run or per test — implementer's choice), and its structural
assertions (job existence, `needs:` set membership and exact-set checks, job-level and
step-level `if:` presence/content) query the parsed tree by key path rather than by
line-position or indent-column arithmetic.

### AC-003 — Byte-for-byte scalar pins are retained as a second assertion layer, not deleted or replaced

Every existing byte-for-byte pin on a scalar value (e.g. the `ci-gate` gate step's exact
`run:` body, exact `if:` expression strings) continues to assert the exact expected string,
now sourced from the parsed tree's scalar node rather than a raw substring search. No byte pin
is deleted, weakened to a substring/contains check, or replaced by structural-equality-only
coverage.

### AC-004 — New dependency (if any) passes `cargo deny check` and compiles under MSRV 1.85

If a crate dependency is added (vs. the shell-out approach), `cargo deny check` exits 0 with
the new dependency present, and `cargo build`/`cargo test` succeed under the pinned 1.85
toolchain (verified via the existing `msrv` CI job — no new CI job is required for this).

### AC-005 — The node-properties defeat case from `cf00f2fc` is caught by the new assertions

Inserting a key-level node property (`&x` or `!!str`) immediately before a mapping key inside
the `ci-gate` gate step's body (the exact reproduction case from `cf00f2fc`: `&x shell: cat
{0}`) causes at least one of the rewritten assertions to fail — because a real YAML parse
correctly resolves the resulting document to include a `shell` key where the pinned expected
key set does not, and the parse-tree-based key-set assertion (AC-002) detects the mismatch
that the old line-based `extract_key_name_at_indent` could not see. This is proven as a
RED-then-fixed cycle: the malicious line is inserted against a temporary/local copy of
`ci.yml` (not the tracked file) and confirmed to fail the new assertions before this AC is
marked satisfied; the tracked `ci.yml` itself is never modified to include the malicious line.

### AC-006 — No regression: full existing suite passes against the current, legitimate `ci.yml`

`cargo test --test ci_gate_completeness` exits 0 against the tracked (non-malicious)
`.github/workflows/ci.yml`, with every pre-existing test function still present (none silently
deleted, renamed without a documented reason, or weakened to make the rewrite pass), and
`cargo test` (full suite) shows no regression elsewhere. `cargo clippy -- -D warnings` and
`cargo fmt --all -- --check` are both clean.

## Out of Scope (explicit)

- **Any change to `scripts/check-ci-gate.sh`'s runtime `toJSON(needs)` evaluation logic** — that
  script does not parse `ci.yml` and is unaffected by this story (S-CIGATE-2/PR #671 scope).
- **Executing the node-properties payload against a real GitHub Actions runner** — per
  `cf00f2fc`, this remains unverified end-to-end; this story closes the *test-suite-side*
  detection gap, not a live-runner reproduction. Not required for this story's ACs.
- **A general-purpose YAML linter/schema-validator for `ci.yml`** (e.g. wiring up
  `actionlint` in CI) — a related but distinct idea; not opened by this story, no pointer
  added since it is not identified as a residual risk anywhere in the source material.
- **Migrating any other test file's source-text-grep pattern** (e.g. `tests/ci_yml_windows_matrix.rs`,
  if it uses a similar approach) to a real parser — scoped to `tests/ci_gate_completeness.rs`
  only, since that is the file with the demonstrated, repeatedly-recurring defect class.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | Merge-key (`<<:`) YAML syntax, a related but distinct anchor/alias feature | Per `cf00f2fc`'s research, GitHub has NOT shipped merge-key support in Actions (github/community discussion #185877 is an open follow-on request) — anchors/tags are the confirmed-live mechanism, merge keys are not. A real parser (AC-002) will correctly resolve merge keys if GitHub ever ships them, without further code change, since the fix is structural rather than per-syntax. Not a required test case for this story; noted for completeness. |
| EC-002 | The chosen parser rejects or warns on a construct actionlint accepts (or vice versa) | Not expected to be reachable for this repo's own `ci.yml` (which is not adversarially authored), but if implementation discovers a real divergence, document it in the Verification Log rather than silently picking whichever tool is more permissive. |
| EC-003 | Future `ci.yml` edits (by unrelated PRs) land on `develop` between this story's authoring and its dispatch, changing job names/needs lists | The rewritten assertions must be re-derived against `ci.yml` as it exists AT IMPLEMENTATION TIME, not against the job list quoted in this story's Source of Truth section (which is a snapshot, not a live reference) — mirrors the "re-derive current test function names/count from the tree at merge time" convention already established in `S-CIGATE-2`'s AC-006 coordination note. |

## Test Coverage Summary

| # | Assertion | File | AC |
|---|-----------|------|-----|
| 1 | `ci.yml` parses successfully into a structured document via the chosen approach | `tests/ci_gate_completeness.rs` | AC-002 |
| 2 | Job existence / `needs:` set membership assertions query the parsed tree, not line position | `tests/ci_gate_completeness.rs` | AC-002 |
| 3 | Every pre-existing byte-for-byte scalar pin still asserts its exact string, now sourced from the parsed tree | `tests/ci_gate_completeness.rs` | AC-003 |
| 4 | `cargo deny check` exits 0 with the new dependency (if any) present | CI (`deny` job) | AC-004 |
| 5 | `cargo build`/`cargo test` succeed under MSRV 1.85 | CI (`msrv` job) | AC-004 |
| 6 | Node-properties payload (`&x shell: cat {0}`) against a local/temporary `ci.yml` copy fails at least one rewritten assertion; proven RED-then-fixed | `tests/ci_gate_completeness.rs` (test-local fixture, not the tracked file) | AC-005 |
| 7 | `cargo test --test ci_gate_completeness` exits 0 against the tracked `ci.yml`; no test functions silently removed | `tests/ci_gate_completeness.rs` | AC-006 |

## Dependency Analysis

**depends_on: ["S-CIGATE-2"]** — `tests/ci_gate_completeness.rs` is the exact file
`S-CIGATE-2`'s in-flight `fix/ci-gate-skipped-false-green` branch has already grown from 8
tests (develop HEAD) to 17 tests (frozen worktree), rewriting/adding the very primitives
(`collect_mapping_key_set`, `extract_key_name_at_indent`) this story targets for replacement.
Dispatching this story's F4 implementation BEFORE `S-CIGATE-2` merges would mean building the
new parser-based assertions against a version of the file that is about to be superseded
wholesale by that merge, guaranteeing a large, wasted merge conflict. **This story MUST NOT be
dispatched until `S-CIGATE-2`'s PR #671 merges to `develop`.**

**blocks: []** — no story depends on this one.

## Tasks

1. Re-read `tests/ci_gate_completeness.rs` and `.github/workflows/ci.yml` as they exist on
   `develop` HEAD AT IMPLEMENTATION TIME (post-`S-CIGATE-2` merge) — do not assume this
   story's snapshot (8 tests / develop HEAD, or 17 tests / frozen branch) is still current.
2. Evaluate the YAML-parsing approach candidates (AC-001): MSRV 1.85, `cargo deny check`,
   license, maintenance status, and API fit for a "parse once, query by key path, plus
   byte-pin a subset of scalar values" access pattern. Record the decision and rationale.
3. If a crate is chosen: add it to `Cargo.toml`/`Cargo.lock`; run `cargo deny check` and the
   `msrv`-pinned build to confirm AC-004 before writing the rewrite.
4. Rewrite `tests/ci_gate_completeness.rs`'s structural assertions to parse `ci.yml` once and
   query the parsed tree (AC-002), retaining every existing byte-for-byte scalar pin as a
   second layer over parsed values (AC-003).
5. Prove AC-005: against a local/temporary copy of `ci.yml` (not the tracked file), insert
   `&x shell: cat {0}` into the `ci-gate` step and confirm at least one rewritten assertion
   fails; record this as the RED proof.
6. Run `cargo test --test ci_gate_completeness` against the tracked `ci.yml` — confirm AC-006
   (all tests green, none silently removed).
7. Run `cargo test` (full suite), `cargo clippy -- -D warnings`, `cargo fmt --all -- --check`
   — confirm no regressions.
8. Update `CLAUDE.md`'s `ci-gate` convention bullet documenting the parse-tree + byte-pin
   dual-layer approach.
9. Run `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` — both must
   exit 0 (no BCs touched, so this should be a no-op).

## Story Points and Effort

**8 story points** (standard). Breakdown:
- Library/approach evaluation (AC-001), documented with rejected-alternative rationale: 2 SP
- F4 TDD (parse-tree rewrite of ~750–3,900 LOC of assertions depending on merge-time file
  size, dual-layer byte-pin retention, RED-proof cycle for AC-005): 5 SP
- F5/F7 review + CI verification: 1 SP

Risk: MEDIUM — this lands in the same heavily-adversarially-reviewed file
(`tests/ci_gate_completeness.rs`) that `S-CIGATE-2`'s 20+ PR #671 review rounds already
hardened; a rewrite that accidentally narrows coverage during the parse-tree migration would
be a regression in the single most scrutinized test file in this repo. Mitigated by AC-003's
explicit "retain every existing pin" requirement and AC-006's full-suite regression check.
