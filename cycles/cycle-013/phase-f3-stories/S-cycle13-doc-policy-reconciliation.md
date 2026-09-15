---
document_type: story
level: ops
story_id: "S-cycle13-doc-policy-reconciliation"
epic_id: "MSRV-1.88-BUMP"
title: "Doc/policy reconciliation: README badge, CHANGELOG, design-spec MSRV policy, stale SHA citation"
wave: 2
status: draft
intent: enhancement
feature_type: documentation
mode: feature
scope: trivial
severity: LOW
trivial_scope: true
producer: story-writer
timestamp: "2026-09-15T00:00:00"
phase: 3
inputs:
  - ".factory/cycles/cycle-013/phase-f1-delta-analysis/delta-analysis.md"
  - ".factory/specs/architecture/decisions/ADR-0025-raise-msrv-to-1-88.md"
  - "README.md"
  - "docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md"
  - "CLAUDE.md"
input-hash: "c3f7137"
traces_to: "ADR-0025 Decision (going-forward MSRV policy); F1 delta-analysis.md §3 (README/CLAUDE.md/design-spec rows)"
cycle: cycle-013-msrv-1.88-bump
estimated_effort: xsmall
estimated_days: 0.5
target_module: "README.md, CHANGELOG.md, docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md, CLAUDE.md"
subsystems: []
depends_on: ["S-cycle13-msrv-cargo-ci-atomic-bump"]
blocks: []
behavioral_contracts: []
bcs: []
# BC status: N/A by design — doc-only deliverable, no BC anchor. Mirrors the
# S-cycle7-readme-migration-note / S-cycle4-windows-docs precedent: a README badge, CHANGELOG
# entry, design-spec policy-prose reconciliation, and a stale-SHA citation fix have no
# independently-testable behavioral contract to pin. ADR-0025 is this story's normative anchor.
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: ["ADR-0025"]
sd_refs: []
priority: P2
parent_phase: F3-incremental-stories
spec_source: ".factory/cycles/cycle-013/phase-f3-stories/dependency-graph-extended.md"
implementation_strategy: tdd
tdd_mode: facade
module_criticality: LOW
points: 2
acceptance_criteria_count: 5
assumption_validations: []
risk_mitigations: []
created: "2026-09-15"
version: "1.0"
last_updated: "2026-09-15"
breaking_change: false
retroactive: false
origin: >
  cycle-013 msrv-1.88-bump, Wave 2, depends_on: [S-cycle13-msrv-cargo-ci-atomic-bump]. Unlike
  the let-chain retrofit (S-cycle13-letchain-retrofit-convention-cleanup), this story's
  dependency on Story 1 is a CONTENT-ACCURACY dependency, not a compile-order one: this story's
  CHANGELOG entry (AC-002) and README MSRV badge (AC-001) must state facts only knowable after
  Story 1 completes — the exact comfy-table version Story 1's implementer selected (Story 1
  AC-002 leaves this open, "current latest 7.x release at implementation time"), and whether
  the msrv job's --all-targets scope widening actually shipped without surfacing a new failure
  (Story 1 EC-004). Writing this story's doc claims before Story 1 merges risks stating a
  version number or scope claim that turns out wrong. This is a real (if soft) build-order
  requirement, not merely an editorial recommendation — encoded as a depends_on: edge per the
  Anchor Justification Requirement, distinguishing it from the S-cycle7-readme-migration-note
  precedent's "recommended-but-not-a-graph-edge" pattern (that story had no comparable
  content-accuracy stake in its predecessor's exact implementation details). F1 §5's own preview
  decomposition explicitly notes this story "could even land before A/B" is possible in
  principle, but the CHANGELOG content-accuracy concern above is the reason this F3 pass
  chooses NOT to leave it fully independent. Human-approved at the F1 gate (2026-09-15).
---

> **tdd_mode:** `facade` — pure documentation/prose changes across four files, no executable
> behavior to TDD against. Each AC's "test" is a content-presence/accuracy check verified at PR
> review time, not a `#[test]` function. `module_criticality: LOW`.

> **Execute:** `/vsdd-factory:deliver-story S-cycle13-doc-policy-reconciliation`

# S-cycle13-doc-policy-reconciliation — README/CHANGELOG/design-spec/CLAUDE.md reconciliation

## Narrative

- **As a** `jr` contributor or user reading README.md, CHANGELOG.md, the 2026-03-21 design
  spec, or CLAUDE.md's Gotchas section
- **I want to** all four documents to accurately reflect the post-cycle-013 state (MSRV 1.88,
  the going-forward "bump as needed" policy, and the correct `msrv` job action SHA)
- **So that** none of these four documents states something that was already false before this
  cycle (the design spec's unfollowed "minus 3" policy, CLAUDE.md's incorrect SHA citation) or
  becomes false as a direct result of this cycle's code changes (the README's 1.85 badge)

## Behavioral Contracts

**N/A by design — doc-only deliverable.** No PRD BC anchors this story (mirrors the
`S-cycle7-readme-migration-note`/`S-cycle4-windows-docs` precedent). This story's ACs trace
directly to ADR-0025's own content (the Decision section's going-forward MSRV policy statement,
which this story's design-spec edit operationalizes) and to F1 delta-analysis.md §3's file
inventory rows for `README.md`, `CHANGELOG.md`, and the design spec.

## Acceptance Criteria

### AC-001 (traces to F1 delta-analysis.md §3 — README badge row)
`README.md` line 8's MSRV badge changes from `MSRV-1.85-orange.svg` to `MSRV-1.88-orange.svg`,
reflecting the value `S-cycle13-msrv-cargo-ci-atomic-bump` actually landed in `Cargo.toml`.
**Test:** `grep "MSRV-1.88" README.md` matches; `grep "MSRV-1.85" README.md` returns no match.

### AC-002 (traces to CLAUDE.md conventions — CHANGELOG delivery task, cross-referencing Story 1's actual outcome)
`CHANGELOG.md`'s `[Unreleased]` section entry for the MSRV bump (added by
`S-cycle13-msrv-cargo-ci-atomic-bump`'s own AC-007) is reviewed/supplemented if needed to also
mention: the `msrv` job's `--all-targets` scope widening (if not already covered by Story 1's
entry) and this story's own design-spec/README/CLAUDE.md reconciliation, so the `[Unreleased]`
section reads as one coherent MSRV-bump narrative rather than three disconnected entries. If
Story 1's entry already covers this ground adequately, this AC is satisfied by NOT duplicating
it — a single consolidated entry is preferred over three near-identical ones.
**Test:** N/A (doc artifact; verified by PR review — confirm no duplicate/contradictory
`[Unreleased]` entries exist for the same MSRV bump after this story lands).

### AC-003 (traces to ADR-0025 Decision — going-forward MSRV policy statement, both self-contradicting mentions in the design spec)
`docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md` §"MSRV Policy" (lines ~656-658,
currently stating "1.85.0 (or latest stable minus 3 releases)") is rewritten to state the
going-forward policy ADR-0025's Decision section records: **"bump as needed (currently 1.88),
driven by dependency floor and ecosystem pressure, evaluated ad hoc per cycle"** — replacing the
never-followed "latest stable minus 3" mechanism. This resolves the pre-existing spec
inconsistency F1 §3/§7 Open Question 3 flagged (recommended: "update the text to describe actual
practice") and ADR-0025's Decision section explicitly assigns to this story ("the design-spec
text itself is reconciled by F4 (Story 3 in the F1 preview decomposition)"). **This AC's scope
also covers the same document's separate, earlier mention at line ~616** ("MSRV check: Test
against the declared minimum Rust version (1.85.0)", in the CI/testing section, distinct from
and not previously scoped by this AC to the §"MSRV Policy" section at ~L656-658) — updated to
`1.88.0` (or generalized to avoid hard-coding a version that will drift again, e.g. "the
currently-declared MSRV floor — see §MSRV Policy"), so the design spec does not self-contradict
between its two MSRV mentions after this story lands.
**Test:** `grep -A2 "MSRV Policy" docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md` no
longer contains "latest stable minus 3"; contains "bump as needed" and "1.88"; separately,
`grep -n "1.85.0" docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md` returns no match at
line ~616 (the "MSRV check" line) after this story lands.

### AC-004 (traces to F1 delta-analysis.md §3 — CLAUDE.md stale SHA citation, occurrence-2 ONLY, opportunistic bundling)
CLAUDE.md's Gotchas section bullet ("`rust-toolchain.toml` outranks `rustup default`...") cites
the SHA `fa04a1451ff1842e2626ccb99004d0195b455a88` **twice, and the two occurrences are NOT
equivalent — only one is stale.** **Occurrence 1** ("...the SHA replacement to
`fa04a1451ff1842e2626ccb99004d0195b455a88` was a hard prerequisite — this version of the action
declares `toolchain` as a required input") is a **historically-accurate, past-tense** account of
what `S-626-1` actually did — corroborated by `CHANGELOG.md:~L1071` — and **MUST stay
untouched**; optionally append a short parenthetical noting the later bump, e.g. "(later bumped
to `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`)", but do not remove or reword the historical
claim itself. **Occurrence 2** ("Note: at the currently pinned SHA (`fa04a1451ff1842e2626ccb99004d0195b455a88`),
the action validates `toolchain:` as a hard-required input...") is a **present-tense claim about
the CURRENT pinned SHA**, and IS stale — F1 confirmed by direct file read that the ACTUAL pinned
SHA in `ci.yml` today (and unchanged by `S-cycle13-msrv-cargo-ci-atomic-bump`, which only changes
the `toolchain:`/`RUSTUP_TOOLCHAIN:` values, not the SHA) is
`6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`. **Only occurrence 2 is corrected** to
`6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`. This is a pre-existing, unrelated drift predating
cycle-013, bundled opportunistically per F1's explicit recommendation ("should be corrected in
the same pass since it's adjacent prose in the same Gotchas bullet") rather than deferred to a
separate cleanup story — but the fix must be scoped to the stale, present-tense occurrence only,
never a blanket replace that would corrupt the historically-accurate occurrence 1 (mirrors the
tense-guard discipline AC-005 already applies to the `"1.85.0"` literal citations in the same
bullet).
**Test (corrected at Pass-4, F-C: `grep -c` counts matching LINES, not occurrences — both
occurrences of the SHA sit on the SAME physical line, `CLAUDE.md:248`, one long Gotchas-bullet
paragraph, so `grep -c` returns `1` both BEFORE and AFTER this AC's fix and cannot verify the
surgical edit; `grep -o | wc -l` counts occurrences and is used instead):**
`grep -o "fa04a1451ff1842e2626ccb99004d0195b455a88" CLAUDE.md | wc -l` returns **2 before** this
AC's fix (both occurrences present) and **1 after** (occurrence 1 — the historical claim —
remains; the corrected occurrence 2 no longer contains it); separately, assert the present-tense
phrase "currently pinned SHA (`fa04a1451" no longer appears anywhere in `CLAUDE.md` after the fix
(`grep -c "currently pinned SHA (\`fa04a1451" CLAUDE.md` returns `0`), confirming occurrence 2's
present-tense framing — not just its SHA value — was corrected, not merely appended to;
`grep -c "6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772" CLAUDE.md` returns `>=1` (matches the value
already correct in `ci.yml` per this story's own file-read verification, plus occurrence 2's fix,
plus any optional parenthetical added to occurrence 1);
`tests/claude_md_citations.rs::test_claude_md_citations_resolve_to_real_files` remains green (a
SHA string is not a file-path citation, so this guard is unaffected either way — noted here only
to confirm no regression).

### AC-005 (traces to F1 delta-analysis.md §3 — CLAUDE.md `rust-toolchain.toml` Gotchas bullet: ADD a present-tense "now pinned to 1.88.0" note; do NOT swap any existing `"1.85.0"` literal in place)
**Corrected per cycle-013 F3 Pass-2 finding F-1 — every existing `"1.85.0"` literal already
present in CLAUDE.md's `rust-toolchain.toml` outranks `rustup default` Gotchas bullet (~L248) is
HISTORICAL narrative, not a "currently pinned" claim, and this AC does NOT edit any of them in
place.** There are two distinct historical clusters in that bullet, both out of scope for
in-place editing:
1. The **pre-fix broken-job account** ("The pre-fix `msrv` CI job pointed at the tip of
   dtolnay's `1.85.0` version branch..." through "...adding `with: {toolchain: "1.85.0"}` alone
   would have been silently ignored by GitHub Actions") — describes the OLD, pre-S-626-1 job.
2. The **S-626-1 fix account** ("The fix adds both `with: {toolchain: "1.85.0"}}` (to install
   the correct toolchain) AND `env: {RUSTUP_TOOLCHAIN: "1.85.0"}}` on the `cargo check` step —
   ... ensuring cargo uses 1.85.0 at check time") — this is a POST-fix, past-tense account of
   what `S-626-1` actually did, corroborated by `CHANGELOG.md:~L1073`. It is NOT a present-tense
   "currently pinned to 1.85.0" claim (there is no such claim anywhere in this bullet — AC-004
   already handles the bullet's one present-tense claim, occurrence 2, which cites a SHA, not a
   `"1.85.0"` version literal), so it must be preserved verbatim, exactly like AC-004's
   occurrence-1 preservation of the historical "SHA replacement... was a hard prerequisite"
   account. Both AC-004 and this AC apply the SAME discipline to the bullet's two different
   stale-citation classes (SHA vs. version literal): correct the present-tense claim by ADDING
   text, never by rewriting historical prose in place.

Instead, this AC **appends one new, clearly present-tense sentence** to the end of the bullet
stating that the `msrv` job is now pinned to `1.88.0` as of `S-cycle13-msrv-cargo-ci-atomic-bump`
— e.g.: "As of `S-cycle13-msrv-cargo-ci-atomic-bump`, the `msrv` job's `with.toolchain` /
`env.RUSTUP_TOOLCHAIN` are pinned to `1.88.0` (same action SHA,
`6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`); the `1.85.0` values described above are historical,
from the original S-626-1 fix." Every existing `"1.85.0"` literal in the bullet (both clusters
above) is left completely untouched by this AC.
**Test:** within the `rust-toolchain.toml` Gotchas bullet, `grep -c "1.85.0"` returns the SAME
count before and after this story lands (proving no existing occurrence was removed or altered);
the bullet gains a new trailing sentence containing both `"1.88.0"` and
`S-cycle13-msrv-cargo-ci-atomic-bump` (or an equivalent explicit present-tense marker).

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|-----------------|
| MSRV badge | `README.md` | N/A (documentation) |
| Unreleased changelog | `CHANGELOG.md` | N/A (documentation) |
| MSRV Policy section | `docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md` | N/A (documentation) |
| Gotchas SHA/version citations | `CLAUDE.md` | N/A (documentation) |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|--------------------|
| EC-001 | This story is dispatched before `S-cycle13-msrv-cargo-ci-atomic-bump` merges (violating the `depends_on:` edge) | README/CHANGELOG claims (AC-001/AC-002) would state a comfy-table version or scope-widening outcome not yet real — do not dispatch out of wave order; this is the reason the dependency edge exists (see frontmatter `origin:`) |
| EC-002 | The implementer mistakenly swaps an existing HISTORICAL "1.85.0" literal in the `rust-toolchain.toml` Gotchas bullet in place, instead of appending a new sentence per AC-005 — either the pre-fix broken-job narrative ("The pre-fix `msrv` CI job pointed at...") OR the post-fix S-626-1 fix account ("The fix adds both `with: {toolchain: "1.85.0"}}` ... AND `env: {RUSTUP_TOOLCHAIN: "1.85.0"}}` ... ensuring cargo uses 1.85.0 at check time") | Both clusters are historical narrative, not "currently pinned" claims — NEITHER may be edited or removed. AC-005 is satisfied ONLY by appending a new, distinct present-tense sentence stating the job is now pinned to 1.88.0; it is never satisfied by editing any existing `"1.85.0"` occurrence in this bullet |
| EC-003 | Story 1's implementer selected a comfy-table version this story's CHANGELOG-review step (AC-002) can't find recorded anywhere in Story 1's own merged PR/CHANGELOG entry | Read Story 1's actual merged CHANGELOG entry or PR diff directly (`git log`/`git show` on `Cargo.toml`) rather than guessing; do not fabricate a version number |

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|-----------------|
| `README.md`, `CHANGELOG.md`, `docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md`, `CLAUDE.md` | N/A (documentation) | Not source code; no purity classification applies |

## Token Budget Estimate

| Context Source | Estimated Tokens |
|-----------------|-------------------|
| This story spec | ~2,800 |
| Referenced content (README badge line, design-spec MSRV Policy section, CLAUDE.md Gotchas bullet, Story 1's merged CHANGELOG entry) | ~3,000 |
| N/A (no test files — doc-only) | 0 |
| Tool outputs overhead | ~800 |
| **Total** | **~6,600** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~3%** |

Trivially within budget.

## Tasks

1. [ ] Confirm `S-cycle13-msrv-cargo-ci-atomic-bump` has merged; read its actual `Cargo.toml`
   diff for the exact comfy-table version selected and its CHANGELOG entry text — `implementer`
2. [ ] Update `README.md`'s MSRV badge 1.85 → 1.88 (AC-001) — `implementer`
3. [ ] Review/supplement `CHANGELOG.md`'s `[Unreleased]` MSRV entry, avoiding duplication with
   Story 1's own entry (AC-002) — `implementer`
4. [ ] Rewrite `docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md`'s MSRV Policy section
   (~L656-658) to the "bump as needed (currently 1.88)" going-forward policy, AND update the
   separate "MSRV check... (1.85.0)" mention at ~L616 to `1.88.0` (or generalize it) so the two
   mentions don't self-contradict (AC-003) — `implementer`
5. [ ] Fix CLAUDE.md's stale SHA citation — **occurrence 2 ONLY** (`fa04a145...` →
   `6c977a6ca...`, the present-tense "at the currently pinned SHA" claim); leave occurrence 1
   (the historical "SHA replacement... was a hard prerequisite" account) untouched, optionally
   appending "(later bumped to `6c977a6ca...`)" (AC-004) — `implementer`
6. [ ] Append a new present-tense sentence to CLAUDE.md's `rust-toolchain.toml` Gotchas bullet
   stating the `msrv` job is now pinned to `1.88.0` (same SHA,
   `6c977a6ca4077a0ceb28ffbe03f59d46e9ac8772`); leave EVERY existing `"1.85.0"` literal in that
   bullet untouched — both the pre-fix broken-job narrative and the S-626-1 fix account (AC-005,
   EC-002) — `implementer`
7. [ ] Run `cargo test --test claude_md_citations` (or the equivalent full suite invocation) to
   confirm no dead-citation regression — `implementer`

## Previous Story Intelligence

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|-----------------|--------------------------|------------------------|
| `S-cycle13-msrv-cargo-ci-atomic-bump` (this cycle, Wave 1, hard content-accuracy dependency) | The exact comfy-table version pin and whether the insta snapshot changed are facts only this story's Task 1 can discover post-merge, not predicted in advance | This story's CHANGELOG task explicitly avoids duplicating Story 1's own CHANGELOG entry — check what's already there first | N/A yet — populate from Story 1's actual merged PR |
| S-cycle7-readme-migration-note (cycle-007) | Established the "doc-only story, no BC/VP anchor, content-presence-check ACs" precedent this story follows | A doc-only story's `depends_on:` should reflect a REAL build-order or content-accuracy requirement, not blanket editorial preference — that precedent used `depends_on: []` with a prose-only recommendation because its predecessor's status had no content-accuracy stake in its own claims; THIS story's situation is different (its CHANGELOG/README claims genuinely need Story 1's landed facts), which is why this story uses a real `depends_on:` edge instead | Distinguish "recommended sequencing" (no edge) from "content-accuracy dependency" (real edge) case by case — do not default to one pattern without checking which applies |

## Architecture Compliance Rules

| Rule | Source | Enforcement |
|------|--------|--------------|
| Do not fabricate the comfy-table version number or any other Story-1-dependent fact — read Story 1's actual merged output | This story's own EC-003; general "no hallucinated facts in docs" discipline | Task 1 requires reading Story 1's real diff/CHANGELOG before writing this story's own AC-001/AC-002 content |
| Do not alter CLAUDE.md's historical/narrative "1.85.0" mentions — this covers BOTH the pre-fix broken-job narrative (what the OLD, pre-S-626-1 job looked like) AND the post-fix S-626-1 fix account (what the fix's `with:`/`env:` values actually were at the time) — AC-005 is satisfied only by appending a new sentence, never by editing either cluster | AC-005; EC-002 | Read sentence tense before editing; grep alone is insufficient — a human/implementer review pass is required; `grep -c "1.85.0"` count within the bullet must be unchanged before/after |
| Avoid duplicate or contradictory `[Unreleased]` CHANGELOG entries for the same MSRV bump across Story 1 and this story | CLAUDE.md conventions (CHANGELOG delivery task, applied consistently); this story's AC-002 | PR review: diff `CHANGELOG.md`'s `[Unreleased]` section for redundancy before merging |

## Library & Framework Requirements

N/A — this story touches no source code and introduces no library dependency.

## File Structure Requirements

| File | Action | Purpose |
|------|--------|---------|
| `README.md` | modify | MSRV badge 1.85 → 1.88 (AC-001) |
| `CHANGELOG.md` | modify | `[Unreleased]` entry review/supplement (AC-002) |
| `docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md` | modify | MSRV Policy section rewrite (AC-003) |
| `CLAUDE.md` | modify | Stale SHA fix + remaining `"1.85.0"` value citations (AC-004, AC-005) |
