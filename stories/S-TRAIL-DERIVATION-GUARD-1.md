---
document_type: story
level: ops
story_id: "S-TRAIL-DERIVATION-GUARD-1"
epic_id: "none"
title: "Mechanical guard for hand-maintained commit-trail claims in story files (closes drift item TRAIL-DERIVATION-UNGUARDED)"
version: "1.0"
producer: story-writer
timestamp: "2026-08-07T00:00:00"
phase: 3
cycle: TRAIL-DERIVATION-GUARD
wave: feature-followup
status: draft
intent: ci-hardening
feature_type: infrastructure
mode: feature
scope: standard
severity: MEDIUM
trivial_scope: false
points: 8
priority: P2
tdd_mode: strict
estimated_effort: standard
estimated_days: 2
target_module: ci-infrastructure
subsystems: []
depends_on: []
blocks: []
behavioral_contracts: []
bc_anchors: []
bcs: []
# BC status: no product BCs (spec-process tooling guard; scope is .factory/stories/*.md
# frontmatter, not src/ product behavior). Traces to the FIX-ROUND-20 drift-item entry
# TRAIL-DERIVATION-UNGUARDED (.factory/STATE.md Drift Items table + Decisions Log,
# 2026-08-07) and to CLAUDE.md's existing DRIFT-001/DRIFT-002 guard-script conventions.
# BC catalog untouched. Do NOT add BCs.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F1-delta-analysis
inputs:
  - ".factory/STATE.md"
  - ".factory/stories/S-626-1.md"
input-hash: "55c4fbc"
traces_to: ".factory/STATE.md Drift Items table, row TRAIL-DERIVATION-UNGUARDED"
spec_source: "No pre-existing delta-analysis document exists for this story. Written directly
  from the FIX-ROUND-20 drift-item entry TRAIL-DERIVATION-UNGUARDED (.factory/STATE.md Drift
  Items table + Decisions Log + Current Phase Steps rows, 2026-08-07) and the orchestrator's
  carried-forward design brief from the same round, which itself records: 'a guard was
  designed this burst (report only, not implemented)' plus the marker-shape sketch and the
  two named fail-open constraints reproduced verbatim below."
implementation_strategy: tdd
module_criticality: MEDIUM
acceptance_criteria_count: 8
assumption_validations: []
risk_mitigations:
  - "Scoped as an evaluate-then-implement story, not a pre-committed tooling choice: this
     repo's only existing precedent for spec-guard-domain checks (scripts/check-bc-citation-symbols.sh,
     scripts/check-spec-counts.sh, scripts/check-cargo-mutants-policy-citations.sh) is a bash-script
     family with a --self-test convention (DEC-148/DEC-150), but a Rust tests/*.rs integration test
     (mirroring tests/claude_md_citations.rs and tests/ci_gate_completeness.rs) is also viable and has
     the type-safety advantage for the classification logic in AC-005/AC-006. AC-001 requires a
     documented evaluation before either is committed to."
  - "Explicitly does NOT retrofit S-626-1's existing hand-written trail prose into the new marker
     schema. S-626-1 is under active, concurrent adversarial revision (20 fix rounds and counting
     as of this story's authoring) and this story-writer dispatch is explicitly forbidden from
     touching it. Retrofitting is named as a follow-up task in Out of Scope, not performed here."
created: "2026-08-07"
last_updated: "2026-08-07"
breaking_change: false
files_modified:
  - scripts/check-commit-trails.sh          # CREATE (Candidate A only — see AC-001): bash guard, git-log-based, --self-test flag
  - tests/commit_trail_guard.rs             # CREATE (Candidate B only — see AC-001): Rust integration-test guard, alternative to the above
  - tests/fixtures/commit-trail-guard/       # CREATE: known-bad fixture set for AC-007 self-test (a stale file-scope trail; an ambiguous step-boundary diff)
  - .github/workflows/ci.yml                 # MODIFY (Candidate A only): wire scripts/check-commit-trails.sh into the spec-guard job's script list, mirroring the existing check-bc-citation-symbols.sh wiring. NOT modified under Candidate B (a tests/*.rs guard rides the existing `test` job automatically, per the tests/claude_md_citations.rs precedent).
  - CLAUDE.md                                # MODIFY: document the new guard (mirrors the existing "Run scripts/check-spec-counts.sh…" / "tests/claude_md_citations.rs — always-run guard…" bullets) and the commit_trails: frontmatter marker schema convention for future story authors
---

# S-TRAIL-DERIVATION-GUARD-1 — Mechanical Guard for Hand-Maintained Commit-Trail Claims

## Source of Truth

`.factory/STATE.md`'s Drift Items table (row `TRAIL-DERIVATION-UNGUARDED`, MEDIUM, opened
FIX-ROUND-20, 2026-08-07) and the Decisions Log / Current Phase Steps rows from the same
burst, which record — verbatim, restated here as the design constraints this story must
satisfy, not re-derived from scratch:

> Two hand-maintained commit trails in S-626-1 must match mechanically-derivable git facts;
> the off-by-one recurred five rounds before this burst broke the streak. A guard was
> designed this burst (report only, not implemented). Key design constraints: ground truth
> is time-varying because `origin/develop..HEAD` moves, so the story must store the
> derivation command plus a `verified_head`, not a frozen count; the step-scoped trail is
> exactly the EXTRACTOR-UNDER-REPORT-FAILS-OPEN shape (parsing step boundaries from a YAML
> diff can silently under-match) — treat it as `≥N` with a hard error on boundary ambiguity,
> never a silent skip.

The two motivating trails, both currently maintained as hand-written prose inside
`.factory/stories/S-626-1.md` (not touched by this story — see Out of Scope):

- **Trail 1** — commits unique to the branch that modified `tests/ci_gate_completeness.rs`
  (whole-file, path-based scope), cited at 2 sites in `S-626-1.md` (the AC-9 "Test file
  authorized" block and the File Structure Requirements MUST-NOT-change exception list).
  As of FIX-ROUND-20 this trail stood at 17 commits, re-verified correct with no count
  change needed that round.
- **Trail 2** — commits whose diff hunks fall inside `ci.yml`'s `test` job step "Run tests
  (zero-test floor, POL-11)" (step-scoped), cited at 4 sites (the BC-X.13.007 Behavioral
  Contracts table row, AC-10's body, the Architecture Mapping row, and the `ci.yml` File
  Structure Requirements row). This trail grew 7→9 during FIX-ROUND-20 and has independently
  drifted short-by-one in five of the six most recent rounds — a flat, non-decaying rate, the
  same shape S-CIGATE-2/S-CIGATE-3 documented for the file's line-based YAML-lexing defects.

## Behavioral Contracts

No product BCs are added or modified. BC catalog untouched. This story traces its ACs to the
`TRAIL-DERIVATION-UNGUARDED` drift-item entry in `.factory/STATE.md` and to CLAUDE.md's
existing DRIFT-001 (`scripts/check-spec-counts.sh`) / DRIFT-002
(`scripts/check-bc-cumulative-counts.sh`) guard-script convention, following the same
no-BC pattern `S-CIGATE-1`–`S-CIGATE-4` use for CI/spec-process-only stories.

## Story Narrative

As a maintainer authoring or reviewing a story file that asserts a commit trail
(a claim of the form "these N commits, and only these, touched file X" or "…touched step Y
of file X"),
I want a mechanical guard that re-derives each trail from live git history and fails the
build on any mismatch,
so that the trail cannot silently drift out of sync with reality the way S-626-1's two trails
did across six consecutive fix rounds — where careful dispatch ordering alone proved
insufficient, because the timing gap between "story is written" and "round's final commit
lands" reopens on any late-breaking change (a Windows regression fix reopened it again this
round, even under the most careful ordering discipline attempted so far).

## Problem Statement

`S-626-1`'s two commit trails are hand-transcribed prose lists, re-typed at each of the
story's 20+ fix rounds by whoever authors that round's `risk_mitigations` entry. The
underlying git facts they describe are mechanically derivable (`git log` against a
resolvable scope), but nothing re-derives and checks them — a human has to remember to run
the right `git log` invocation, count correctly, and propagate the result to every citation
site (2 for Trail 1, 4 for Trail 2) by hand, every round. This has failed short-by-one in
five of the last six rounds. Dispatch-ordering discipline (holding the trail-dependent
findings until the round's commit list is final) reduced but did not eliminate the failure
mode, because a truly late commit (this round: a same-day Windows regression fix, commit
`177b3727`) can still land after ordering discipline has already been applied. Only a
mechanical, CI-enforced re-derivation closes the gap structurally, the same argument
`S-CIGATE-3` makes for `ci.yml`'s line-based YAML lexing (patch-in-place vs. structural fix).

## Approach

Introduce a `commit_trails:` frontmatter marker convention any story file may declare, and a
guard that re-derives each declared trail from live git history at guard-run time — never
from a stored count — and fails loudly on mismatch. Two scope kinds, with two different
assertion strengths, because they have two different soundness properties:

1. **`scope: file`** — the trail is the exact set of commits in `<merge-base>..HEAD` that
   touch the given path. This is a purely path-based `git log` filter — sound and complete;
   nothing about it can silently under- or over-report. The guard asserts **exact set
   equality** between the stored `commits:` list and the freshly re-derived list.
2. **`scope: step:<job>/<step-name>`** — the trail is the subset of the (sound, complete)
   file-scope candidate set whose diff hunks fall inside one named YAML step. Determining
   step membership from a diff is a **classification problem**, not a filter, and can be
   wrong in the same way `S-CIGATE-2`/`S-CIGATE-3` found repeated wrong in `ci.yml`'s
   line-based structural assertions (a renamed step, a shifted line range, a hunk straddling
   a step boundary). The guard therefore asserts **`actual_count >= verified_count_floor`**
   only — never exact equality — and, critically, treats every commit whose step-membership
   it cannot determine with certainty as a **hard error**, never a silent exclusion from the
   count. A guard that silently classified an ambiguous commit as "not in step" would
   reproduce the exact failure mode this story exists to close (a false "trail complete"
   green), just moved one layer down.

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| `S-CIGATE-1` | Introduced source-text grep testing of `ci.yml` (no YAML parser dependency) as the pragmatic first choice for a small, newly-added job. | `extract_job_block()`-style helper anchoring assertions to one job's slice. | A source-text-grep approach adequate for one small job did not scale under adversarial review as the file grew — directly analogous to why this story's step-scoped extractor (AC-005) must not silently under-report. |
| `S-CIGATE-2` | Hardened `tests/ci_gate_completeness.rs`'s line-based extraction helpers across 20+ PR review rounds. | Each round found a NEW member of the "lexer disagrees with a real parser" defect class (BOM, explicit-key syntax, Unicode line breaks, node properties) — a flat, non-decaying finding rate, not a shrinking one. | A hand-rolled approximation of a structural parser has an apparently unbounded number of remaining gaps; the durable fix is structural (parse once, correctly), not patch-per-finding — the same lesson this story applies to step-boundary classification rather than line-position lexing. |
| `S-CIGATE-3` | Durable follow-up (still `draft`/P2, not yet implemented): replace `ci.yml`'s line-based structural extraction with a real YAML parser. Tooling choice left explicitly open (`serde_yaml`/`saphyr`/`yaml-rust2`/shell-out-to-PyYAML), pending an MSRV-1.85 + `cargo deny` evaluation. | Established the "evaluate-then-implement, don't pre-commit a library" pattern this story's AC-001 reuses. | If this story ships before S-CIGATE-3, its step-boundary classifier must NOT hand-roll a second independent YAML-structure lexer for the same file — it should either reuse whatever S-CIGATE-3 lands on, or stay deliberately conservative (hard-error-biased) so it never needs full structural parsing to be correct, only to be safely incomplete. See Architecture Compliance Rules. |
| `S-BC-CITATION-GUARD-1` | Delivered guard (`scripts/check-bc-citation-symbols.sh`) enforcing citation accuracy against live source, with a `--self-test` mode proving detection against ≥10 known-bad fixtures before being trusted in CI (DEC-148/DEC-150). | Established this repo's canonical spec-guard-domain shape: script-scope threshold constants (single recalibration touchpoint), fail-closed on missing input, `--self-test` as a mandatory non-optional gate, wired into the `spec-guard` CI job. | A guard that only asserts "did the count change" without a fixture-proven detection path for each named failure mode is not actually verified to catch anything — directly informs this story's AC-007 (self-test fixtures required per fail-open constraint, not just an aggregate pass/fail). |
| `S-626-1` (this story's motivating case, read-only — not modified here) | Six consecutive fix rounds (15 through 20) re-derived and re-published both trails by hand; FIX-ROUND-20 broke the immediate off-by-one streak only by holding the trail-dependent findings to a second dispatch wave after the round's code commits were final — and even that discipline nearly failed when a same-day Windows regression fix landed as an 18th, unplanned commit. | Demonstrated that dispatch-ordering discipline is a mitigation, not a fix — the timing gap between "trail written" and "round's true final commit" can reopen on any late change, however carefully ordered. | This is the direct evidence that motivated `TRAIL-DERIVATION-UNGUARDED`: "a mechanical guard is the durable fix, not dispatch ordering" (STATE.md, verbatim). |

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Resolve `origin/develop` fresh at guard-run time; never hardcode a merge-base | This story's design brief (verbatim from the FIX-ROUND-20 drift entry) | The guard MUST compute `git merge-base origin/develop HEAD` (or equivalent) at the moment it runs. It MUST NOT read a merge-base SHA embedded in the story frontmatter, a config file, or any value computed at a prior invocation. |
| File-scope trails assert exact equality; step-scope trails assert a lower bound only | This story's design brief | The guard's code and its user-facing output must both make the assertion-strength distinction explicit — no single generic "PASS/FAIL" that elides which mode fired. A file-scope mismatch reports "expected exactly N, found M, diff: {…}". A step-scope shortfall reports "expected at least N, found M" — and a step-scope match never claims completeness. |
| Ambiguous step-membership is a hard error, never a silent exclusion | `TRAIL-DERIVATION-UNGUARDED` drift item, generalizing the `EXTRACTOR-UNDER-REPORT-FAILS-OPEN` shape already on this repo's drift register | Any commit whose diff-hunk-vs-step-boundary relationship cannot be determined with certainty (step renamed since `verified_head`, hunk straddles the step boundary, anchor text shifted) MUST cause the guard to exit non-zero naming the ambiguous commit. It MUST NOT be silently treated as out-of-step, in-step, or dropped from any collection. |
| Every extractor's failure mode is an `Err`, never an empty/truncated collection | This story's design brief (verbatim) | A parse or git-command failure inside either extractor MUST be observably distinct, in both exit code and message, from "the extractor ran successfully and found zero matching commits." A caller must never be able to mistake "could not compute" for "computed and got zero." |
| Self-test fixtures are mandatory before the guard is trusted in CI | DEC-148/DEC-150 spec-guard convention (`check-bc-citation-symbols.sh --self-test`, `check-cargo-mutants-policy-citations.sh --self-test`) | The guard ships with a `--self-test` mode (or equivalent, if the Rust-test candidate is chosen) that exercises at least one known-bad fixture per named failure mode (stale file-scope trail; ambiguous step-boundary commit; extractor-failure case) and proves detection, RED-then-green, before the guard is wired into `spec-guard`. |
| No change to `S-626-1`'s existing trail prose | Scope boundary — file-ownership constraint on this dispatch | `S-626-1.md` is read-only input to this story (cited for its motivating trails) and MUST NOT be edited by this story or its eventual implementation task. Retrofitting is a separate follow-up (see Out of Scope). |

## Library & Framework Requirements (MANDATORY)

**No tooling approach is pre-selected — evaluating and selecting one is AC-001 of this
story.** Candidates, per this repo's existing precedent and the constraints above:

| Candidate | Notes to verify at implementation time |
|-----------|----------------------------------------|
| Bash script under `scripts/` (`check-commit-trails.sh`), git-log + narrowly-scoped `grep`/`awk` frontmatter-field extraction | This repo's only existing precedent for spec-guard-domain checks (`check-bc-citation-symbols.sh`, `check-spec-counts.sh`, `check-cargo-mutants-policy-citations.sh` all live here, all bash, all carry `--self-test`). Risk: hand-rolled YAML-frontmatter parsing in bash is exactly the "lexer diverges from a real parser" trap `S-CIGATE-2`/`S-CIGATE-3` document — MUST be scoped to reading only the 5 known `commit_trails:` field names by fixed-format extraction, never a general YAML parse, or it reproduces the defect class one layer removed. |
| Rust `tests/*.rs` integration test (mirrors `tests/claude_md_citations.rs`, `tests/ci_gate_completeness.rs`), shelling to `git log` via `std::process::Command` | Type-safe classification logic (useful for AC-005's `Err`-not-empty contract). Open question, same one `S-CIGATE-3` already raised for its PyYAML shell-out candidate and left unresolved: does spawning a subprocess (`git log`) from a `#[test]` fn violate this repo's "hermetic, no external process" test convention? Verify against existing test conventions before assuming this is equivalent precedent. If YAML-frontmatter parsing is needed beyond the 5 fixed fields, do NOT make an independent library choice — coordinate with whatever `S-CIGATE-3` selects (if it has landed by implementation time) rather than adding a second YAML-parsing dependency to the tree. |
| Shell out to a narrowly-scoped Python/PyYAML helper for frontmatter-field extraction only (invoked from either candidate above) | Precedent: `S-CIGATE-3` already lists this pattern as a live candidate for its own YAML-parsing need; `scripts/check-signing-workflow-injection.sh` and `scripts/check-ci-gate.sh` already shell out from this repo's CI. Would resolve the "5 known fields only" constraint above with a real parser instead of hand-rolled extraction, at the cost of a `python3`/PyYAML availability dependency on `ubuntu-latest` (verify, per `S-CIGATE-3`'s own open question on this exact point — do not re-answer it independently if `S-CIGATE-3` has already settled it by implementation time). |

Whichever is chosen, the decision and rationale (including rejected alternatives and why)
MUST be recorded in this story's Verification Log or a follow-up ADR — do not leave the
choice implicit in a diff.

## File Structure Requirements

| File | Create / Modify | Description |
|------|----------------|--------------|
| `scripts/check-commit-trails.sh` | CREATE (Candidate A only) | Bash guard: for each story file declaring `commit_trails:`, re-derive each trail per its `scope` and assert per AC-003/AC-004; `--self-test` flag per AC-007. |
| `tests/commit_trail_guard.rs` | CREATE (Candidate B only) | Rust integration-test equivalent, if that candidate is selected instead. |
| `tests/fixtures/commit-trail-guard/` | CREATE | Known-bad fixtures for AC-007: (a) a minimal story file with a `commit_trails:` entry whose `commits:` list is missing one real commit relative to a small fixture git history; (b) a fixture `ci.yml`-shaped diff containing a step-boundary-ambiguous commit (renamed step name, or a hunk straddling the step boundary). |
| `.github/workflows/ci.yml` | MODIFY (Candidate A only) | Wire `scripts/check-commit-trails.sh` into the `spec-guard` job's script list, mirroring the existing `check-bc-citation-symbols.sh` wiring. Not touched under Candidate B. |
| `CLAUDE.md` | MODIFY | Document the guard (mirrors the existing `scripts/check-spec-counts.sh` / `tests/claude_md_citations.rs` bullets) and the `commit_trails:` frontmatter marker schema as a convention for future story authors. |

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|-----------------|----------------|
| Trail re-derivation (`git log` invocation, scope-fresh resolution) | `scripts/check-commit-trails.sh` or `tests/commit_trail_guard.rs` | effectful-shell / effectful-io | Reads live git history via a subprocess or `git2`-style call — not deterministic across time by design (that is the entire point: it must see current reality, not a frozen snapshot). |
| Step-boundary classification | same file | pure-core (once given diff text as input) | A pure function from (diff hunk, step boundary description) → {in, out, ambiguous}; the impurity is confined to obtaining the diff text, not the classification logic itself — this separation is what makes the classifier unit-testable against fixtures without invoking real git. |
| Frontmatter `commit_trails:` marker parsing | same file | pure-core | Reads already-open file content and extracts 5 known fields; no I/O beyond the read. |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `scripts/check-commit-trails.sh` / `tests/commit_trail_guard.rs` | effectful-shell / effectful-io (git subprocess) wrapping a pure-core classifier | The guard's outer shell is inherently effectful (reads live git state, which is the reason the guard exists); the step-membership classification function it calls, given diff text and step-boundary description as plain inputs, is pure and independently testable — matching this repo's existing purity-boundary convention for CLI/test code that wraps I/O around a pure decision function. |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~4,200 |
| `.factory/STATE.md` (drift-item + decision-log excerpts actually needed, not the full file) | ~2,500 |
| `.factory/stories/S-626-1.md` (the two trail sections + their citation sites, not the full 1,869-line file) | ~3,000 |
| `S-CIGATE-1`/`S-CIGATE-2`/`S-CIGATE-3` cross-reference (Previous Story Intelligence) | ~4,000 |
| `S-BC-CITATION-GUARD-1` cross-reference (self-test convention) | ~1,500 |
| Existing `scripts/check-bc-citation-symbols.sh` (pattern reference) | ~1,000 |
| **Total** | **~16,200** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~8%** |

Well under the 20–30% ceiling — no split required.

## Acceptance Criteria

### AC-001 — Documented tooling-approach evaluation, not a pre-committed choice

A guard-implementation approach is evaluated against the candidates in Library & Framework
Requirements (bash script / Rust integration test / PyYAML shell-out helper), checked against
this repo's hermetic-test convention (if a subprocess-spawning Rust test is considered) and
the "don't hand-roll a second YAML lexer" risk (if bash-side frontmatter parsing is chosen),
and the chosen approach is recorded with rationale (Verification Log or a new ADR,
implementer's judgment).

### AC-002 — `commit_trails:` frontmatter marker schema is defined and documented

A story file may declare zero or more entries under `commit_trails:`, each with `trail_id`,
`path`, `scope` (`file` or `step:<job-id>/<step-name>`), `derivation_command` (the literal
command used to re-derive, for human auditability), `verified_head`, and either
`verified_count` + `commits:` (scope `file`) or `verified_count_floor` + `commits:` (scope
`step:…`). The schema is documented in `CLAUDE.md` and is generic — usable by any story file,
not hardcoded to `S-626-1`'s two trails (see Generalizability, below the Edge Cases table).

### AC-003 — File-scope trails: exact re-derivation against LIVE current state, never a frozen count

For `scope: file` entries, the guard resolves `origin/develop` fresh at run time (never a
cached or hardcoded merge-base), computes `git log --format=%h <merge-base>..HEAD -- <path>`
against the **current** checkout (not `verified_head`), and asserts **exact set equality**
against the frontmatter's `commits:` list. Any mismatch (missing commit, extra commit, or
count mismatch) fails the guard and reports the specific commits to add or remove — this is
the guard's implementation of "store the derivation command and `verified_head`, not a frozen
count" (design brief, verbatim): `verified_head`/`verified_count` are provenance metadata for
humans, never inputs the guard's own pass/fail decision trusts.

### AC-004 — Step-scope trails: lower-bound assertion only, never exact-count

For `scope: step:…` entries, the guard asserts `actual_confirmed_in_step_count >=
verified_count_floor`. The guard's code and its output message both state explicitly that
this is a lower-bound check, not an exact-match check — no code path or user-facing string
claims step-scope completeness. This directly encodes the "treat the step-scoped trail as
`≥N`" constraint as a requirement a future implementer cannot silently satisfy with an
exact-match implementation that merely happens to pass on today's fixture.

### AC-005 — Ambiguous step-boundary commits hard-error; they are never silently excluded

Every commit in a step-scope trail's file-level candidate set (the sound, complete file-scope
list) is classified into exactly one of `{confirmed-in-step, confirmed-out-of-step,
ambiguous}`. Any commit landing in `ambiguous` (step renamed since `verified_head`, diff hunk
straddles the step boundary, anchor text used to locate the step no longer matches uniquely)
causes the guard to exit non-zero, naming the specific ambiguous commit and the reason
classification failed. The guard MUST NOT default an ambiguous commit to `confirmed-out` (which
would silently undercount, reproducing `TRAIL-DERIVATION-UNGUARDED`'s own failure mode) or to
`confirmed-in` (which would silently overcount and mask real drift in the other direction).
Proven by a fixture (AC-007) containing exactly one deliberately ambiguous commit.

### AC-006 — Extractor failure is always an `Err`, never an empty or truncated collection

Both extractors (file-scope git-log filter; step-scope classifier) have a failure mode
(git command failure, unreadable/malformed diff input, frontmatter parse failure) that is
observably distinct — in exit code AND in message — from "ran successfully, found zero
matching commits." A test asserts: given a deliberately broken extraction input (e.g. an
unreachable `origin/develop` ref, or a malformed `commit_trails:` block), the guard exits
non-zero with an error message distinguishable from a legitimate `commits: []` / zero-count
result.

### AC-007 — Guard self-test proves detection against known-bad fixtures, RED-then-green

The guard ships a `--self-test` mode (or equivalent for the chosen tooling approach) that
runs against the fixtures in `tests/fixtures/commit-trail-guard/` and proves: (a) a
file-scope trail missing one real commit is detected (AC-003); (b) a step-scope trail whose
`verified_count_floor` is not met is detected (AC-004); (c) the deliberately ambiguous
step-boundary commit is detected and hard-errors, not silently skipped (AC-005); (d) the
deliberately broken extraction input hard-errors distinctly from a zero-count result
(AC-006). Each fixture is proven RED (guard correctly fails against the known-bad case) then
confirmed the guard passes clean against the corresponding known-good fixture — mirroring the
RED-then-green convention `S-BC-CITATION-GUARD-1`'s 10-fixture self-test already established
for this repo's spec-guard family.

### AC-008 — Wired into CI; no regression on existing spec-guard checks

The guard runs as part of the `spec-guard` CI job (Candidate A) or rides the existing `test`
job automatically (Candidate B, per the `tests/claude_md_citations.rs` precedent — no new CI
wiring needed). `cargo test` (full suite, if Candidate B), `cargo clippy -- -D warnings`, and
`cargo fmt --all -- --check` all remain clean. Existing `scripts/check-spec-counts.sh` and
`scripts/check-bc-cumulative-counts.sh` continue to exit 0 (this story does not touch their
inputs).

## Generalizability

**Yes — the marker schema and guard are designed to be generic**, not hardcoded to
`S-626-1`'s two trails. Any story file may declare `commit_trails:` entries with `scope: file`
or `scope: step:<job>/<step-name>` for any path. `S-626-1`'s Trail 1 (file-scope,
`tests/ci_gate_completeness.rs`) and Trail 2 (step-scope, `ci.yml`'s POL-11 step) are this
story's motivating case and the two fixture shapes AC-007 must cover, but the guard itself
contains no `S-626-1`-specific logic, path, or story-ID reference. Retrofitting `S-626-1`'s
existing hand-written trail prose into this marker format is explicitly a separate follow-up
task (see Out of Scope) — this story delivers the mechanism, not the migration.

## Out of Scope (explicit)

- **Retrofitting `S-626-1`'s existing prose trails into the new `commit_trails:` marker
  format.** `S-626-1` is under active, concurrent adversarial revision and is off-limits to
  this dispatch. Once it stabilizes (merges or reaches a quiet adversarial window), a
  follow-up task should add `commit_trails:` frontmatter to it and confirm the guard passes
  against its real history — that follow-up is not performed here.
- **Building a general "any two files, any two commits" diff tool.** Scoped to the two named
  scope kinds (`file`, `step:…`) motivated by `S-626-1`'s actual trails.
- **Resolving `S-CIGATE-3`'s YAML-parser-library choice.** If this story's implementation
  needs YAML-frontmatter parsing beyond the 5 fixed `commit_trails:` field names, it should
  reuse whatever `S-CIGATE-3` selects rather than making an independent choice — but this
  story does not depend on `S-CIGATE-3` shipping first (see Dependency Analysis).
- **A general drift-detection system for all hand-maintained claims in story files** (e.g.
  test counts, line-number citations). Those are separate, already-named drift-register
  shapes (`SPEC-NUMERIC-CLAIM` class, `#408` citation-form convention) with their own
  guards or conventions; not opened or extended by this story.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|--------------------|
| EC-001 | A step is renamed between `verified_head` and current HEAD | The `scope: step:<job>/<step-name>` string no longer matches any step in the current file. This MUST be treated as ambiguous-at-the-trail-level (AC-005's hard-error path), not silently resolved by fuzzy-matching the old name to a new one — a human must re-derive and update the frontmatter's `scope` string deliberately. |
| EC-002 | A commit touches `ci.yml` but only via a whitespace/comment change entirely outside the named step's line range | MUST classify as `confirmed-out-of-step`, not `ambiguous` — over-hard-erroring on unambiguous outside-step edits would make the guard too noisy to trust, defeating AC-007's purpose. The classifier's `ambiguous` bucket is for genuine uncertainty, not for "not the step we're tracking." |
| EC-003 | The step's anchor text (used to locate its boundary) shifts line position because an earlier, unrelated step grew — but the step's own content is unchanged | MUST still correctly classify `confirmed-out-of-step` for that commit if anchor-based (not line-number-based) location is used, per the same "prefer anchors over `~:NN` line citations" principle CLAUDE.md's citation-form convention (#408) already establishes for this repo — a line-shift alone is not evidence of ambiguity if the anchor text is still uniquely locatable. |
| EC-004 | `origin/develop` itself has no commits since `verified_head` (nothing moved) | Guard behavior is unchanged — it always resolves fresh and re-derives; a stable `origin/develop` is simply the case where the fresh resolution and a cached one would have agreed. Not a special case in the implementation. |
| EC-005 | A story file declares `commit_trails:` for a `path` that does not exist in the current tree (renamed/deleted) | Hard error (AC-006), not a silent zero-commit result — a renamed/deleted path is exactly the kind of drift this guard exists to surface, not paper over. |

## Test Coverage Summary

| # | Assertion | File | AC |
|---|-----------|------|-----|
| 1 | `origin/develop` merge-base is resolved fresh at guard-run time (not cached/hardcoded) | guard test suite | AC-003 |
| 2 | File-scope trail: exact set equality asserted against live current state; mismatch reports specific add/remove commits | guard test suite + fixture | AC-003 |
| 3 | Step-scope trail: lower-bound (`>=`) assertion only; code/output never claims exact-match completeness | guard test suite + fixture | AC-004 |
| 4 | Ambiguous step-boundary commit (renamed step / straddling hunk) hard-errors, named explicitly, never silently excluded | guard test suite + fixture (b) | AC-005 |
| 5 | Unambiguous outside-step commit does NOT spuriously hard-error (EC-002 regression guard) | guard test suite + fixture | AC-005 |
| 6 | Broken extraction input (unreachable ref, malformed `commit_trails:` block) hard-errors distinctly from a legitimate zero-count result | guard test suite + fixture | AC-006 |
| 7 | `--self-test` (or equivalent) runs all fixtures RED-then-green, proving detection per named failure mode | guard test suite | AC-007 |
| 8 | Guard wired into CI (`spec-guard` job or rides `test` job); no regression to existing spec-guard checks | CI (`spec-guard`/`test` job) | AC-008 |

## Dependency Analysis

**depends_on: []** — This story delivers a standalone, generic guard mechanism. It does not
require `S-CIGATE-3` (the `ci.yml` real-YAML-parser story) to land first: its step-boundary
classifier is designed to be conservative and hard-error-biased rather than fully structurally
correct, so it does not need a real YAML parser to be *sound* — only to be *usefully complete*
(see Library & Framework Requirements' coordination note: if a YAML dependency is needed for
frontmatter parsing, reuse `S-CIGATE-3`'s choice if it has landed, but do not block on it).

It also does not depend on `S-626-1` reaching any particular state, because it explicitly does
not touch `S-626-1` (see Out of Scope) — the guard is validated entirely against the fixtures
this story creates, not against `S-626-1`'s live history.

**blocks: []** — No story currently declares a dependency on this one. The natural future
consumer is a follow-up "retrofit `S-626-1`'s trails onto `commit_trails:` frontmatter" task,
named in Out of Scope but not yet opened as a story.

**Soft coordination note (not a blocking dependency):** if `S-CIGATE-3` has already selected
and landed a YAML-parsing library by the time this story is implemented, and this story's
chosen approach (AC-001) needs YAML parsing beyond the 5 fixed `commit_trails:` fields, prefer
reusing that library over adding an independent second YAML dependency to the tree.

## Tasks

1. Evaluate the tooling-approach candidates (AC-001): bash-script-family precedent vs. Rust
   `tests/*.rs` integration test vs. PyYAML shell-out helper for frontmatter parsing. Check
   the hermetic-test-convention question for any subprocess-spawning Rust-test candidate.
   Record the decision and rationale.
2. Define and document the `commit_trails:` frontmatter marker schema (AC-002) in `CLAUDE.md`.
3. Implement the file-scope extractor: resolve `origin/develop` fresh, compute
   `git log --format=%h <merge-base>..HEAD -- <path>` against current HEAD, assert exact set
   equality (AC-003).
4. Implement the step-scope classifier as a pure function `(diff hunk, step boundary
   description) -> {confirmed-in, confirmed-out, ambiguous}`, wrapped by an effectful shell
   that supplies live diff text; assert `actual >= verified_count_floor` only (AC-004).
5. Implement the ambiguous-commit hard-error path (AC-005) and the extractor-failure
   `Err`-not-empty contract (AC-006).
6. Build `tests/fixtures/commit-trail-guard/` fixtures: (a) file-scope trail missing one
   commit; (b) step-scope trail below its floor; (c) one deliberately ambiguous
   step-boundary commit; (d) one deliberately unambiguous outside-step commit (EC-002
   regression guard); (e) one deliberately broken extraction input.
7. Implement `--self-test` (or equivalent) proving RED-then-green detection against all five
   fixtures (AC-007).
8. Wire the guard into CI: `spec-guard` job script list (Candidate A) or confirm it rides the
   existing `test` job automatically (Candidate B) (AC-008).
9. Update `CLAUDE.md` with the new guard bullet and the `commit_trails:` schema convention.
10. Run `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` — both
    must exit 0 (no BCs or spec-count-tracked files touched by this story).

## Story Points and Effort

**8 story points** (standard). Breakdown, calibrated against `S-CIGATE-3` (P2/8 points, the
closest sibling — also a "durable structural fix for a hand-maintained/lexer-derived trail
that has repeatedly drifted"):
- Tooling-approach evaluation (AC-001), documented with rejected-alternative rationale: 1 SP
- File-scope extractor + exact-equality assertion (AC-003): 1 SP
- Step-scope classifier with the three-way `{in, out, ambiguous}` contract, hard-error path,
  and `Err`-not-empty extractor contract (AC-004/AC-005/AC-006) — the hardest part, structurally
  similar in kind to `S-CIGATE-3`'s step-boundary problem: 3 SP
- Fixture set + `--self-test` (AC-007): 2 SP
- CI wiring + `CLAUDE.md` documentation (AC-002/AC-008): 1 SP

**Priority: P2.** Not blocking any in-flight delivery (S-626-1's PR #667 is HELD on an
unrelated adversarial-window gate, not on this guard) — same P2 rationale as `S-CIGATE-3`:
durable but not urgent. Recommend scheduling before the next long, multi-round adversarial
S-626-1-style cycle begins, since that is precisely the condition under which the drift this
guard closes has recurred five times already.
