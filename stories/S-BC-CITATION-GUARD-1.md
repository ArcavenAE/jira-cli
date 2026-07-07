---
document_type: story
story_id: "S-BC-CITATION-GUARD-1"
title: "CITATION-GUARDS Story B: BC-body Trace/Source file::symbol citation guard (DEC-148)"
wave: feature-followup
status: delivered
intent: ci-hardening
feature_type: infrastructure
mode: feature
scope: standard
severity: LOW
trivial_scope: false
points: 8
priority: P1
tdd_mode: strict
estimated_effort: medium
estimated_days: 2.0
target_module: ci-infrastructure
subsystems: []
depends_on: ["S-MUTANTS-SCOPE-GUARDS-1"]
blocks: []
behavioral_contracts: ["BC-X.13.004", "BC-X.13.005", "BC-X.13.006"]
# BC status: anchored F2 2026-07-05; DEC-154 Option A deltas committed 2026-07-06 (commit
# 125f081); F3 pass-3 BC fixes b85c4bb 2026-07-06 (N=331/FLOOR=248, strip-from-first-paren,
# branch (d) ^[[:space:]]* anchor, EC-CITE-059); F-01 two-tier shape guard 7575e54 2026-07-06
# (N=309/FLOOR=231, two-tier baseline 2b09313: 304 .rs + 5 .snap; pre-two-tier: N=331,
# FLOOR=248; EC-CITE-060). BC-X.13.004: file-existence + SCOPE-EMPTY
# guard + coverage floor = floor(0.75 × N) ≈ 231 in CANONICAL_MODE (N=309 two-tier baseline
# 2b09313; pre-two-tier post-Task-0-hygiene census: N=331, FLOOR=248; pre-hygiene DEC-154:
# N=326, FLOOR=244); collect-all semantics;
# EC-CITE-058 hygiene dependency. BC-X.13.005: two-pass extraction (F-B2-02); 7-branch
# symbol dispatch: (a) fn-grep primary; (b) ::tests mod-grep; (c) ::tests::testfn composition;
# (d) UPPER_CASE const/static with ^[[:space:]]* anchor; (e) standalone CamelCase type-def;
# (f) Type::method dual-check; (7) DEAD — no permissive fallback; EC-CITE-052..059 added.
# BC-X.13.006: Guard 1 scope (bc-*.md Trace/Source only; BC-INDEX excluded — zero
# Trace/Source lines); CI topology (spec-guard dual-worktree); GREEN on develop HEAD;
# RED on stale citation; 10 fixtures (A–K); "All self-test fixtures passed (10/10)"
# observable success string.
bcs: ["BC-X.13.004", "BC-X.13.005", "BC-X.13.006"]
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 7
assumption_validations: []
risk_mitigations: []
created: "2026-07-04"
version: "1.13"
last_updated: "2026-07-07"
breaking_change: false
retroactive: false
origin: >
  DEC-148 citation-debt-filewide cycle (2026-06-30): 12 stale file::symbol citations in
  .factory/specs/prd/bc-3-issue-write.md — 9 citing handle_jsm_create in create.rs after
  it moved to jsm_create.rs (ADR-0012 Seam A/B), 2 citing edit.rs functions in create.rs,
  1 citing field_resolve.rs functions in helpers.rs. Consumed ~30 adversarial passes to
  hand-fix (DEC-147/148/149). No CI guard existed to catch Trace/Source field staleness.
  F1 delta analysis citation-guards-2026-07-02-delta.md §2 (BC-CITATION-CI-GUARD / Guard 1).
  Stories recommended: 2 (wave_order: guards-2-3-first per F1 §7). This is Story B.
changelog:
  - "1.13 (2026-07-07): DELIVERED — PR #592 squash-merged by human to develop @ 0d8a8a5 (DEC-128 honored); post-merge guard verification PASS (self-test 10/10; canonical 309 checked). Recorded as DEC-156."
  - "1.12 (2026-07-07): pass-2 obs fixes — Step-2 two-variable pattern canonized (BC lockstep); --bc-dir CANONICAL_MODE note corrected."
  - "1.11 (2026-07-06): F-01 two-tier shape guard lockstep (BC 7575e54; EC-CITE-060; N=309/FLOOR=231; Fixture B .snap sub-probe)."
  - "1.10 (2026-07-06): F3 CONVERGED under DEC-153 standard criterion — 15 fresh-context adversary passes, 9 fix rounds (v1.1→v1.9); clean window = passes 13/14/15 (CLEAN×3). Status → ready. Recorded as DEC-155."
  - "1.9 (2026-07-06): F3 pass-8 fixes (bc-1-auth-identity.md filename drift ×4 sites; Task 0 rationale DEAD-vs-missed precision)."
  - "1.8 (2026-07-06): F3 pass-6 fixes (F-P6-01 Fixture D skeleton, F-P6-02 type_name derivation, 3 LOW clarity touches)."
  - "1.7 (2026-07-06): F3 pass-5 coherence fixes (F-P5-01..07). F-P5-01 (MED): RED-gate
    staging rc=1 group corrected: E removed from {A,B,C,D,E,G,J} → {A,B,C,D,G,J}; rc=0-with-
    content group is {E,F,I,K} (E expects rc=0 + '1 citations checked'). F-P5-02 (MED):
    'four post-fixture self-assertions' → 'five' at AC-002 and File Structure (Task 3
    enumerates BC-CITE-001 count pin; anti-self-match; bash -n pin; grep -oE pin; fixtures_run
    integrity pin = 5). F-P5-03 (MED): Fixture J kill-trace (b) removed (unsound: symbol
    nonexistent_mod never enters branch (b) due to ^tests$ guard); note added pointing to
    Fixture I for polarity-swap kill; Fixture I gains kill-trace (b) (polarity-swap explicitly
    listed). F-P5-04 (LOW): 'Task 8 (formerly Task 7)' → 'Task 7' in AC-001 sequencing note
    (no renumbering occurred; tasks are 0–7). F-P5-05 (LOW-MED): --bc-dir documented as
    designed-to-support-only per ARG-PARSER-GATE-POLARITY convention; fixture harness uses
    BC_DIR= env path (tested path); CANONICAL_MODE=1 floor-active behavior for standalone
    --bc-dir invocation noted. F-P5-06 (LOW): AC-002 trace 'Fixture A→EC-CITE-039/dead-symbol'
    corrected to BC-X.13.005 fn-grep NO-MATCH/dead-symbol (no dedicated EC); EC-CITE-039
    anchors to Fixture C (import-only DEC-148 class) only. F-P5-07 (LOW): RED-gate Fixture G
    bullet rewritten to remove self-contradiction ('passes rc assertion initially'); now uses
    consistent 'stub rc=0, assertion expects rc=1, fails → RED' model throughout."
  - "1.6 (2026-07-06): F3 pass-4 fixes (F-B4-CRIT-01 pin=4, F-B4-H-01 space-args sub-probe,
    F-B4-M-01 pipefail guard, Task 0 worktree preface). F-B4-CRIT-01 (CRIT): BC-CITE-001
    count pin corrected 3→4 (header comment + preamble grep + Step-1 echo + own assertion
    line = 4; composed-fragment anti-self-match line does NOT count by design); F-B4-H-01
    (HIGH): Fixture F sub-probe (2) citation changed from `mock_f_fn_selftest()` to
    space-args form `mock_f_fn_selftest(args: T)` (per corrected EC-CITE-059); kill-trace
    (d) rewritten accurately (Pass 2 space-split → unbalanced `(` → malformed ERE → grep
    exits 2 → caught); one-sentence ()-vs-(args: asymmetry rationale added (empty parens =
    valid ERE group → would NOT catch mutation); mock fn body `fn mock_f_fn_selftest() {}`
    unchanged; F-B4-M-01 (MED): `|| true` appended to Pass-1 pipeline with pipefail
    rationale sentence (zero matches legitimate → flows to SCOPE-EMPTY/floor guards);
    Task 0 preface: one sentence added naming factory-artifacts worktree convention."
  - "1.5 (2026-07-06): F3 pass-3 fixes (F-B3-01..06) — F-B3-01 (CRIT): Step 5 strip rewritten
    as strip-from-first-( (`symbol=${symbol%%\\(*}` subsumes bare () and (args...) forms;
    EC-CITE-059 added; Pass 2 example updated); F-B3-02 (MED): branch (d) const/static grep
    gains `^[[:space:]]*` anchor (mid-line false-green vector closed; EC-CITE-051 kill-trace
    rewritten: group-removal + anchor-removal mutations; negative sub-probe added to Fixture F);
    F-B3-03 (LOW): N=331/FLOOR=248 (post-Task-0-hygiene census; pre-hygiene: N=326, FLOOR=244;
    implementer remeasures at delivery); F-B3-04 (MED): Fixture J mock content changed from
    touch (empty) to `printf 'nonexistent_mod\\n'` (permissive-fallback mutation now properly
    killed; kill-trace lists both (a) permissive-fallback + (b) polarity-swap); F-B3-05 (MED):
    Fixture F sub-probe adds `mock_f_fn_selftest()` fn citation with trailing () (Step-5 strip
    mutation now killed; EC-CITE-059 kill-trace added to Fixture F); F-B3-06 (LOW): Out-of-Scope
    note added naming check-bc-single-line-trace.sh as F5 companion-lint follow-up candidate.
    Count sweep: all N/FLOOR surfaces updated; EC-CITE-059 wired into BC table + AC traces +
    Edge Cases EC-002."
  - "1.4 (2026-07-06): consistency fix — Task 7 self-verify fixture count 7→10 (v1.3 sweep miss)."
  - "1.3 (2026-07-06): F3 pass-2 fixes (F-B2-01..09) + DEC-154 Option A grammar extension.
    F-B2-01 (CRIT) Fixture F sub-probe path mismatch fixed: citation src/adf.rs::MAX_ADF_DEPTH
    → src/mock_f.rs::MAX_ADF_DEPTH (mock const written to mock file, not adf.rs). F-B2-02/07
    (HIGH/MED) single-pass regex → two-pass extractor everywhere (Pass 1: backtick-only stop;
    Pass 2: space-split + comma-lineref normalization); §-form rationale corrected (two-pass
    genuinely reduces, prior regex DROPPED space-containing tokens); Fixture E reworked to
    assert '1 citations checked' (differential signal). DEC-154 grammar: 3 new branches added
    to Task 2 Step 4 in 7-branch BC dispatch order (a) fn-grep → (b) ::tests mod-grep →
    (c) ::tests::testfn composition → (d) UPPER_CASE → (e) standalone CamelCase type-def →
    (f) Type::method → DEAD; no-permissive-fallback enumeration updated; Out-of-Scope §6
    v2 deferrals shrunk to macros/correlation/continuation-line only. New fixtures I/J/K
    (EC-CITE-052/053/054) with hermetic printf skeletons added; EXPECTED_FIXTURES 7→10;
    summary echo updated to (10/10). F-B2-05 (MED) Fixture G second probe (100 citations,
    below FLOOR); kill-trace: -lt FLOOR→-lt 5 mutation → mid-range probe rc=0 → caught.
    F-B2-06 (MED) unset CANONICAL_MODE at top of --self-test block + explicit invariant.
    FLOOR 249→244, N 332→326 everywhere (adjudication census 2026-07-06). Hygiene bundle
    (EC-CITE-058): files_modified extended + new Task 0 with exact pre-AC-001 hygiene edits
    (3 dead citation clusters + bc-3 multi-line Trace re-flow); ships as factory-artifacts
    commit in same story cycle. F-B2-09 (LOW) --src-root usage-error message pinned to
    Story A form ('Error: --src-root is only valid with --self-test'). Count sweep: all
    surfaces updated (fixture count 7→10; EC-CITE-052..058; grep -oE pin=2 verified under
    two-pass; BC table updated)."
  - "1.2 (2026-07-06): F3 pass-1 fixes (F-B1-01..10): F-B1-01 (HIGH) FLOOR scope →
    script-scope assignment at script top (single recalibration touchpoint); PSI §3
    corrected (Story A hardcodes 'expected >= 11', Story B deviates deliberately); Maint
    Touchpoints §2/§4 updated to single-site model. F-B1-02 (HIGH) CI job name stale
    baseline corrected (actual current = 'Spec Guards (BC counts, numeric-count lint,
    mutants policy scope)'); AC-006(b) target updated to preserve all live segments.
    F-B1-03 (MED) Task 4 / AC-006(a) rewritten: new steps appended after
    check-cargo-mutants-policy-citations canonical step (Story A's last step), not after
    check-bc-cumulative-counts. F-B1-04 (MED) hermetic fixture setup skeletons added to
    AC-002 (A dead-symbol, B dead-file, C import-only, E §-form, F success, G floor).
    F-B1-05 (MED) grep -oE count pin fixed 3 → 2 (single call site + assertion line;
    'adjust at delivery' hedge removed). F-B1-06 (MED) self-test summary echo requirement
    added to Task 3 and AC-002: script MUST emit 'All self-test fixtures passed (7/7)'
    (BC-X.13.006 postcondition). F-B1-07 (MED) const/static grep updated from
    '(pub[[:space:]]+)?' to '(pub(\([^)]*\))?[[:space:]]+)?'; pub(crate) rationale +
    EC-CITE-051 (src/adf.rs::MAX_ADF_DEPTH probe) referenced; EC-002 updated. F-B1-09
    (LOW) anti-self-match assertion added to AC-002 post-fixture assertions (Story A
    precedent). F-B1-10 (LOW) glob pre-check inserted before shape guard in Task 2 Step 4."
  - "1.1 (2026-07-05): F2 BC anchoring (BC-X.13.004..006) + ratified research revisions:
    FLOOR formula floor(0.75 × N) ≈ 249 replaces hardcoded FLOOR=30; EC-002 shape-split
    per BC-X.13.005 Step 5 (fn-grep primary, UPPER_CASE const/static, Type::method
    dual-check; permissive grep -q fallback removed); glob-skip EC-011 added (BC-X.13.005
    Step 3 EC-CITE-043); Fixture G CANONICAL_MODE script-scope invariants + unset-after
    (Story A Fixture H precedent); BC-INDEX.md structural rationale added (zero Trace/Source
    lines); AC traces updated (provisional → anchored, EC-CITE-034..050 added). EC count
    10 → 11; acceptance_criteria_count unchanged (7)."
  - "1.0 (2026-07-04): Initial F3 story draft — S-BC-CITATION-GUARD-1 (CITATION-GUARDS
    Story B, Guard 1). BC body Trace/Source file::symbol citation guard. Bash script +
    spec-guard CI steps. 7 ACs. 4-file set (new script + ci.yml + CHANGELOG + CLAUDE.md;
    cross-cutting.md/BC-INDEX/CANONICAL-COUNTS are F2 artifacts). F1 delta analysis:
    citation-guards-2026-07-02-delta.md §2 (Guard 1)."
lineage:
  - S-MUTANTS-SCOPE-GUARDS-1     # Story A (Guards 2+3), wave 1 of CITATION-GUARDS bundle; wave 2 is this story
  - S-MAINT-DEAD-CITATION-CI     # prior art: established BC-X.13 subsystem (tests/claude_md_citations.rs); Guard 1 extends to BC-X.13.004+
  - S-408-stale-citation-anchors  # DEC-129 codified CI-checkout topology lesson applied here
drift_items:
  - BC-CITATION-CI-GUARD
  - "#492-PG-TRACE-TESTS"
  - CITATION-FORM-DISCIPLINE
  - PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY
files_modified:
  - scripts/check-bc-citation-symbols.sh        # NEW — Guard 1: extract Trace/Source src/ citations from bc-*.md bodies; validate file::symbol against develop's src/ tree; 10 fixtures (A–K); two-pass extractor; 7-branch symbol dispatch
  - .github/workflows/ci.yml                    # MODIFY — spec-guard job: +2 steps (--self-test + canonical run); update job name to include "citation checks"
  - CHANGELOG.md                                # MODIFY — [Unreleased] entry per CHANGELOG-per-PR hygiene
  - CLAUDE.md                                   # MODIFY — doc-fallout note in AI Agent Notes (parallel to check-cargo-mutants-policy-citations.sh line)
  # HYGIENE BUNDLE (EC-CITE-058) — factory-artifacts commit in same story cycle (Task 0),
  # BEFORE product PR is opened; AC-001's canonical run reads this factory-artifacts state:
  - .factory/specs/prd/bc-7-output-render.md    # MODIFY — citation hygiene: src/cli/auth.rs::handle_login etc. → src/cli/auth/<login|switch|logout|remove|status|…>.rs::fn (7-8 tokens)
  - .factory/specs/prd/bc-1-auth-identity.md     # MODIFY — citation hygiene: src/cli/auth.rs::auth_json_response etc. → real paths; src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap → src/cli/auth/tests/snapshots/…
  - .factory/specs/prd/bc-4-assets-cmdb.md      # MODIFY — citation hygiene: src/cli/assets.rs:303-321 → src/cli/assets/<mod|search|view|…>.rs:NN-MM (verify current file per refactored layout)
  - .factory/specs/prd/bc-3-issue-write.md      # MODIFY — continuation-line re-flow: L1434-1441 and L1555-1559 multi-line Trace fields → single-line (class 16 pre-fix, avoids multi-line stitching grammar work)
  # NOT in this F4 delivery (F2 artifacts authored separately; PO already committed):
  #   .factory/specs/prd/cross-cutting.md    MODIFY — new BCs BC-X.13.004/005/006 + DEC-154 Option A (commit 125f081)
  #   .factory/specs/prd/BC-INDEX.md         MODIFY — updated counts
  #   .factory/specs/prd/CANONICAL-COUNTS.md MODIFY — updated counts
---

# S-BC-CITATION-GUARD-1 — CITATION-GUARDS Story B: BC-body Trace/Source file::symbol Citation Guard

**Status:** DRAFT — F3 initial decomposition (2026-07-04); BCs anchored F2 2026-07-05 (BC-X.13.004..006); v1.2 F3 pass-1 fixes applied 2026-07-06 (F-B1-01..10); v1.3 F3 pass-2 fixes applied 2026-07-06 (F-B2-01..09, DEC-154 Option A grammar extension, FLOOR=244, 10 fixtures); v1.4 Task 7 self-verify fixture count 7→10 consistency fix; v1.5 F3 pass-3 fixes applied 2026-07-06 (F-B3-01..06: strip-from-first-paren, branch (d) anchor, N=331/FLOOR=248, Fixture J/F kill coverage, EC-CITE-059); v1.6 F3 pass-4 fixes applied 2026-07-06 (F-B4-CRIT-01: count pin 3→4, F-B4-H-01: space-args sub-probe, F-B4-M-01: pipefail guard, Task 0 worktree preface); v1.7 F3 pass-5 coherence fixes applied 2026-07-06 (F-P5-01..07); v1.8 F3 pass-6 fixes applied 2026-07-06 (F-P6-01 Fixture D skeleton, F-P6-02 type_name derivation, 3 LOW clarity touches); v1.9 F3 pass-8 fixes applied 2026-07-06 (F-B8-M-01: bc-1-auth-identity.md filename drift ×4 sites; F-B8-L-01: Task 0 rationale DEAD-vs-missed precision); v1.11 F-01 two-tier shape guard lockstep (BC 7575e54; EC-CITE-060; N=309/FLOOR=231; Fixture B .snap sub-probe); v1.12 pass-2 obs fixes — Step-2 two-variable pattern canonized (BC lockstep); --bc-dir CANONICAL_MODE note corrected.

**Origin:** DEC-148 citation-debt-filewide cycle. After ADR-0012 Seam A/B extracted
`handle_jsm_create` to `src/cli/issue/jsm_create.rs` and `handle_edit` to
`src/cli/issue/edit.rs`, the `.factory/specs/prd/bc-3-issue-write.md` `**Trace**:`
and `**Source**:` fields still cited the old file paths. 12 stale citations, ~30 adversarial
passes to hand-fix. No CI guard detected the drift.

**F1 delta analysis:** `.factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md`
**Story A (wave 1):** `S-MUTANTS-SCOPE-GUARDS-1` (delivered PR #572, develop @ ab78a2d)
**CI topology analysis:** F1 §3 (verified against live ci.yml) — option (a) chosen.

---

## Governance Note

**Formal BCs anchored F2 2026-07-05.** Unlike Story A (policy-doc-only governance under the
MUTATION-CI-TIMEOUT / S-TESTTOOL-1 / S-MUTANTS-EXAMINE-GLOBS-1 pattern), this story warrants
formal behavioral contracts because the citation-extraction grammar — handling `::symbol`,
`§ "..."`, `:~NN`, and bare file forms, plus the v1-pragmatic shape-split for non-function
symbols — has enough combinatorial complexity that future regressions to the guard itself are
plausible without machine-checkable contracts. This is the same reasoning that drove BCs for
`tests/claude_md_citations.rs` in the DEAD-CITATION-CI cycle (DEC-129, BC-X.13.001/002/003).
Subject-matter (citation-integrity guard extending the existing BC-X.13 PRD subsystem) is the
load-bearing driver; implementation form (bash vs Rust) is not.

Anchored BC IDs (authored and committed in F2 2026-07-05; DEC-154 Option A deltas committed
2026-07-06, commit 125f081):
- **BC-X.13.004:** Every `src/` file path in a `**Trace**:` or `**Source**:` line in any
  `bc-*.md` body resolves to a real on-disk file in the develop checkout; SCOPE-EMPTY guard;
  coverage floor = floor(0.75 × N) ≈ 231 in CANONICAL_MODE (N=309, two-tier baseline on
  2b09313: 304 .rs + 5 .snap; pre-two-tier post-Task-0-hygiene census: N=331, FLOOR=248;
  pre-hygiene DEC-154 values: N=326, FLOOR=244; implementer remeasures at delivery);
  collect-all semantics; EC-CITE-058 hygiene dependency.
- **BC-X.13.005:** Extraction grammar for Trace/Source `src/` citation tokens — two-pass
  extractor (DEC-154 F-B2-02: Pass 1 backtick-only stop, Pass 2 space-split + comma-lineref
  normalization); `::symbol` form + 7-branch shape-split: (a) fn-grep primary; (b) `::tests`
  mod-grep; (c) `::tests::testfn` composition; (d) UPPER_CASE const/static; (e) standalone
  CamelCase type-def; (f) Type::method dual-check; (7) DEAD — no permissive fallback;
  strip-from-first-(; glob silent-skip; macro/continuation-line v2 deferrals.
- **BC-X.13.006:** Guard 1 scope (bc-*.md Trace/Source only; BC-INDEX excluded structurally —
  zero Trace/Source lines); CI topology (spec-guard dual-worktree); GREEN on develop HEAD;
  RED on stale citation introduction; 10 fixtures (A–K); "All self-test fixtures passed (10/10)"
  observable success string.

Per S-7.01 Spec-First Gate: `bcs:` is non-empty with canonical BC IDs; story may transition
to `ready` once F4 implementation is complete.

**F4 delivery scope:** `scripts/check-bc-citation-symbols.sh` + CI wiring + CHANGELOG +
CLAUDE.md. The BCs in `cross-cutting.md` and related `BC-INDEX.md` /
`CANONICAL-COUNTS.md` updates are F2 artifacts (authored 2026-07-05).

**CI topology — option (a) confirmed:** F1 §3 verified against live `.github/workflows/ci.yml`
(lines 110–132). The existing `spec-guard` job:
1. Checks out develop (`src/` tree available).
2. Runs `git worktree add .factory origin/factory-artifacts` (`.factory/specs/prd/bc-*.md`
   available).

Guard 1's script runs as a step in this job — both the cited `src/` files AND the citing
BC bodies are simultaneously on-disk. Options (b) (pre-commit only) and (c) (dual-checkout
new job) are REJECTED. Option (a) matches the DEAD-CITATION-CI pattern (DEC-129 lesson).

---

## Narrative

As a contributor to the `jr` CLI,
I want a CI guard that validates every `src/` file path (and its cited symbol, where applicable)
referenced in a `**Trace**:` or `**Source**:` field of a BC body in `.factory/specs/prd/bc-*.md`,
so that a module refactor (file move, function rename, or Seam extraction) cannot silently leave
stale citations in the behavioral contracts without immediate CI detection.

---

## Traceability

| Source | Link |
|--------|------|
| Root-cause cycle | DEC-148 (CITATION-DEBT-FILEWIDE, 2026-06-30) — 12 stale citations in bc-3; ~30 adversarial passes to hand-fix |
| Motivation quantification | `.factory/phase-f1-delta-analysis/citation-debt-filewide-2026-06-30-delta.md` — 14 relocation-stale citations in bc-2 and bc-3 alone |
| F1 delta analysis (scope) | `.factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md §2` (BC-CITATION-CI-GUARD / Guard 1) |
| CI topology analysis | F1 §3 — option (a) confirmed; spec-guard job already dual-mounts develop + factory-artifacts |
| Symbol-resolution feasibility | F1 §6 — file-existence alone too weak; must check symbol definition |
| Preceding delivery | S-MUTANTS-SCOPE-GUARDS-1 PR #572 (Guards 2+3); develop @ ab78a2d |
| Prior art: citation guard pattern | `tests/claude_md_citations.rs` (DEAD-CITATION-CI, BC-X.13.001-003; Guard 1 extends same subsystem) |
| Prior art: bash guard with self-test | `scripts/check-cargo-mutants-policy-citations.sh` (S-MUTANTS-SCOPE-GUARDS-1 PR #572) |
| Prior art: Trace/Source line scanning | `scripts/check-bc-no-numeric-test-counts.sh` (PG-365-1) — same `^\*\*(Trace|Source)\*\*:` grep anchor |
| Open gap addressed | STATE.md BC-CITATION-CI-GUARD drift item |
| Open gap NOT addressed | STATE.md #492-PG-TRACE-TESTS (tests/ citation hygiene — see Out of Scope) |

---

## Behavioral Contracts

BCs anchored F2 2026-07-05. This story extends the BC-X.13 CI-guards subsystem in
`.factory/specs/prd/cross-cutting.md §BC-X.13`.

| BC ID | Contract topic | EC-CITE refs |
|-------|---------------|-------------|
| BC-X.13.004 | File-existence + SCOPE-EMPTY guard + coverage floor = floor(0.75 × N) ≈ 231 in CANONICAL_MODE (N=309, two-tier baseline on 2b09313: 304 .rs + 5 .snap; pre-two-tier post-Task-0-hygiene census: N=331, FLOOR=248; pre-hygiene: N=326, FLOOR=244); collect-all semantics; `DEAD:` offender accumulation; EC-CITE-058 hygiene dependency | EC-CITE-033, EC-CITE-034, EC-CITE-035, EC-CITE-036, EC-CITE-037, EC-CITE-058 |
| BC-X.13.005 | Extraction grammar: two-pass extractor (DEC-154 F-B2-02); two-tier shape guard (F-01): any-extension `^src/[a-zA-Z0-9_/.-]+\.[a-zA-Z0-9]+$` — `.rs` → tier (i) full pipeline; non-`.rs` → tier (ii) file-existence-only (counted in N); `::symbol` 7-branch shape-split — (a) fn-grep primary; (b) `::tests` mod-grep; (c) `::tests::testfn` composition; (d) UPPER_CASE const/static with `^[[:space:]]*` anchor; (e) standalone CamelCase type-def; (f) Type::method dual-check; strip-from-first-`(` (subsumes bare `()` and `(args...)`); glob silent-skip; no permissive fallback | EC-CITE-038, EC-CITE-039, EC-CITE-040, EC-CITE-041, EC-CITE-042, EC-CITE-043, EC-CITE-044, EC-CITE-045, EC-CITE-051, EC-CITE-052, EC-CITE-053, EC-CITE-054, EC-CITE-055, EC-CITE-056, EC-CITE-057, EC-CITE-059, EC-CITE-060 |
| BC-X.13.006 | Guard 1 scope (bc-*.md Trace/Source only; BC-INDEX structural exclusion — zero Trace/Source lines); CI topology (spec-guard dual-worktree); GREEN on develop HEAD; RED on stale citation; 10 fixtures (A–K); "All self-test fixtures passed (10/10)" | EC-CITE-046, EC-CITE-047, EC-CITE-048, EC-CITE-049, EC-CITE-050 |

---

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~12,000 (v1.0; expected to grow through adversarial passes) |
| F1 delta analysis §2/§3/§6/§7 (Guard 1 scope) | ~4,000 |
| `scripts/check-bc-no-numeric-test-counts.sh` (prior art — Trace/Source scanning pattern) | ~800 |
| `scripts/check-cargo-mutants-policy-citations.sh` (prior art — bash guard pattern, self-test design) | ~2,500 |
| `tests/claude_md_citations.rs` (prior art — BC-X.13 subsystem, same guard family) | ~3,000 |
| `.github/workflows/ci.yml` spec-guard job section (lines 110–140) | ~700 |
| Representative `bc-*.md` file (e.g. `bc-3-issue-write.md` — to understand Trace/Source field format) | ~10,000 |
| `CHANGELOG.md` [Unreleased] section | ~300 |
| **Total** | **~33,000** |

~17% of a 200k context window. Well within 20% threshold; no story splitting required.

---

## Tasks

**RED-gate staging (`tdd_mode: strict`):** Under strict TDD, the bash self-test fixture suite
(Task 3 `--self-test` block) is written first against a stub `run_check() { return 0; }` that
emits no output. Under the no-output stub ALL ten fixtures fail RED:
- Fixtures A, B, C, D, G, J (all expecting `rc=1`) fail their `[ "$rc" -eq 1 ]` assertions.
- Fixtures F, I, K (expecting `rc=0`) pass the rc check BUT fail their content assertion
  (`^Check passed:` regex against empty output).
- Fixture E (expecting `rc=0` AND output contains `1 citations checked`) fails the content
  assertion (empty output has no `citations checked`).
- Fixture G: CANONICAL_MODE=1 is set but stub returns rc=0 (floor guard never fires) →
  assertion expects rc=1, fails → RED.
- Fixture G second probe: stub rc=0 but assertion expects rc=1 → RED.

An output-emitting stub is NOT sanctioned (same rationale as Story A): it could incidentally
satisfy Fixture F's content assertion while leaving others RED, corrupting the RED-gate
observation. The no-output stub mandates all fixtures to be RED before implementation begins.

0. **Apply citation hygiene fixes (EC-CITE-058 — pre-AC-001 GREEN prerequisite, factory-artifacts
   commit in same story cycle).** The hygiene edits are made in a factory-artifacts worktree
   (e.g. `git worktree add ../jira-cli-fa factory-artifacts`), NOT on a develop checkout where
   `.factory/` is unmounted — then committed/pushed there BEFORE the product PR opens. These
   factory-side edits MUST be committed to the `factory-artifacts` branch BEFORE the product PR
   is opened. AC-001's canonical guard run reads the `factory-artifacts` state mounted by the
   spec-guard CI job.

   **Why:** The guard (once built) correctly flags the three truly-dead citation clusters as DEAD, and silently misses the tokens on the two bc-3 multi-line Trace fields (continuation lines lack the `^\*\*(Trace|Source)\*\*:` anchor); Task 0 addresses both classes. These are NOT grammar failures — they are citation hygiene issues that accumulated before Guard 1 existed (adjudication §1.3 EC-CITE-058). Fixing them in the factory-artifacts commit is the cleanest path: no BC semantics change, just path corrections.

   **(i) Dead `src/cli/auth.rs::*` citations (~7-8 tokens across bc-7-output-render.md and
   bc-1-auth-identity.md):** The `auth` module was refactored to a directory (`src/cli/auth/mod.rs` +
   siblings). For each citation of the form `src/cli/auth.rs::fn_name`, locate the function
   in `src/cli/auth/<file>.rs` via `grep -r "fn fn_name" src/cli/auth/` and update the
   citation to `src/cli/auth/<file>.rs::fn_name`. Affected functions from adjudication §1.3:
   `handle_login`, `handle_switch`, `handle_logout`, `handle_remove`, `auth_json_response`,
   `peek_oauth_app_source` (and any others found). The implementer MUST verify current file
   locations on develop HEAD before writing the corrections.

   **(ii) Dead `src/cli/assets.rs:303-321` (bc-4-assets-cmdb.md):** The `assets` module was
   refactored to a directory (`src/cli/assets/mod.rs` + siblings). Locate the relevant code via
   `grep -n "relevant_function_or_struct" src/cli/assets/` and update the citation to the real
   `src/cli/assets/<file>.rs:NN-MM` path. Verify on develop HEAD.

   **(iii) Moved snapshot path (bc-1-auth-identity.md):**
   `src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` →
   `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap`
   (verified via glob in adjudication §1.3; exact destination confirmed by `find src/cli/auth`).

   **(iv) Multi-line Trace re-flow (bc-3-issue-write.md L1434-1441 and L1555-1559 approx.):**
   These continuation-line Trace/Source blocks span multiple lines (class 16 in adjudication
   §1.2). The guard uses single-line regex; continuation tokens are silently missed. Re-flow
   each multi-line Trace block to a single line (comma-separated citations on one `**Trace**:`
   line). This removes 5 class-16 missed tokens without any grammar work. The line numbers
   are approximate (adjudication census); search for multi-line `**Trace**:` blocks in bc-3.

   **Delivery:** `git add .factory/specs/prd/bc-*.md && git commit -m "spec(prd): citation
   hygiene — EC-CITE-058 pre-AC-001 dead-path fixes (auth refactor, assets refactor, snapshot
   reloc, bc-3 multi-line re-flow) (story #102)"`

1. **Read the target format.** Read at least one `bc-*.md` file (e.g.,
   `.factory/specs/prd/bc-3-issue-write.md`) to understand the `**Trace**:` and `**Source**:`
   field format. Key observations:
   - Citations appear as backtick-quoted tokens on Trace/Source lines:
     `` **Trace**: `src/cli/issue/edit.rs::handle_edit` (handle_edit function) ``
   - Forms: `file::symbol` (most common), `file § "comment"` (section ref),
     `file:~NN` (approximate line), `file` (bare file-existence),
     `file:NN-MM, NN-MM` (comma-space line-ref list — 10 instances in corpus).
   - The two-pass extractor (DEC-154 F-B2-02 fix) extracts tokens including internal spaces:
     **Pass 1** (`grep -oE '`src/[^`]+`' | tr -d '`'`) extracts the full backtick-quoted
     token (backtick-only stop, no space stop). **Pass 2** (split on first space) reduces
     multi-word tokens: `` `src/file.rs § "text"` `` → Pass 1 extracts `src/file.rs § "text"`,
     Pass 2 keeps `src/file.rs`. **The prior single-pass form** `` `src/[^` ]+` `` stopped at
     the first space, silently DROPPING §-form and comma-space line-ref tokens instead of
     reducing them — those 11 tokens were neither checked nor counted. Two-pass recovers them.
   - `tests/` citations (e.g., `tests/issue_commands.rs:1646-1703`) on Trace/Source lines are
     NOT in scope — Guard 1 validates `src/` paths only (see Out of Scope).
   - `check-bc-no-numeric-test-counts.sh` uses `grep -nE '^\*\*(Trace|Source)\*\*:'` as the
     Trace/Source line anchor — reuse this exact pattern.

2. **Write `scripts/check-bc-citation-symbols.sh` (Guard 1).**

   **Script error ID:** `BC-CITE-001` (analogous to `CI-MUTANTS-CITE-001` in Story A).
   Embed this literal in the script header comment for a static pin (same mechanism as
   `check-cargo-mutants-policy-citations.sh`).

   **Flags:**
   - Default (no flag): canonical CI run. `CANONICAL_MODE=1` when neither `--self-test` nor
     `--bc-dir` supplied. Initialize `self_test=0` and `CANONICAL_MODE=0` before the parse
     loop (prior art: `check-cargo-mutants-policy-citations.sh:202-203`):
     ```bash
     self_test=0
     CANONICAL_MODE=0
     # ... argument parsing ...
     if [ "$self_test" = "0" ] && [ -z "${BC_DIR+x}" ]; then CANONICAL_MODE=1; fi
     ```
   - `--bc-dir <path>`: override the BC directory (default: `.factory/specs/prd`).
     **Designed-to-support only** (same ARG-PARSER-GATE-POLARITY convention as `--policy-doc`
     in Story A). The fixture harness uses the in-process `BC_DIR=…` env assignment — that is
     the tested code path; the `--bc-dir` CLI flag itself is not exercised by any fixture. Note:
     standalone CLI use of `--bc-dir` sets the `BC_DIR` shell variable, so
     `[ -z "${BC_DIR+x}" ]` is false → CANONICAL_MODE stays 0 (floor OFF — user override
     skips floor) — documented behavior, not a target of any fixture.
   - `--src-root <dir>`: override the source root for file-existence and symbol grep. Without
     `--self-test`, this is a usage error (exit 64) to prevent accidental redirect of a real
     guard run to a temp directory. Exit message text (pinned to Story A form, F-B2-09):
     `"Error: --src-root is only valid with --self-test"`.
   - `--self-test`: run all ten self-test fixtures (A–K); exit 0 if all pass, 1 if any fail.

   **Repo-root resolution:** Use SCRIPT_DIR convention:
   ```bash
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
   ```

   **Top-of-file syntax self-check (unconditional, before arg parsing):**
   ```bash
   bash -n "${BASH_SOURCE[0]}"
   ```

   **`run_check` function algorithm:**

   Script-scope variable (declared at top of script, OUTSIDE `run_check` — F-B1-01):
   ```bash
   FLOOR=231  # floor(0.75 × N); N ≈ 309 (two-tier baseline on 2b09313: 304 .rs + 5 .snap; F-01).
              # Pre-two-tier post-Task-0-hygiene census (author census): N=331, FLOOR=248.
              # Pre-hygiene DEC-154 census: N=326, FLOOR=244.
              # Script-scope (NOT local) — single recalibration touchpoint (BC-X.13.004 invariant).
              # Implementer MUST run canonical mode on develop HEAD, record N, set FLOOR=floor(0.75*N).
   ```

   Default variable initialization (at top of `run_check`):
   ```bash
   local bc_dir="${BC_DIR:-.factory/specs/prd}"
   local src_root="${SRC_ROOT:-${REPO_ROOT}}"
   local canonical="${CANONICAL_MODE:-0}"
   # NOTE: FLOOR is NOT declared local here — it is a script-scope variable (see above).
   ```

   **FLOOR and CANONICAL_MODE scope invariants (BC-X.13.004, F-B1-01):**
   - `FLOOR` MUST be a script-scope variable, NOT a `local` inside `run_check`. This provides a
     single recalibration touchpoint: the implementer changes exactly ONE line (the script-top
     `FLOOR=N` assignment) when recalibrating. The Fixture G assertion `grep -qF "expected >= ${FLOOR}"`
     resolves the SAME script-scope `FLOOR` that the guard comparison uses — so a mutation weakening
     only the comparison value (e.g., replacing `"$FLOOR"` with `"5"` in the
     `[ "$total_citations" -lt "$FLOOR" ]` check) still leaves `"expected >= ${FLOOR}"` in the
     message, and Fixture G catches the weakening by seeing exit 0 where it expects exit 1.
   - `CANONICAL_MODE` MUST ALSO be a script-scope variable, NOT a `local` inside `run_check`. The
     Fixture G toggle mechanism (`CANONICAL_MODE=1` set in shell scope before invoking
     `run_check`) requires this: if CANONICAL_MODE were `local`, Fixture G's env mutation would
     be a no-op and the floor guard would false-green.
   - The `--self-test` Fixture G block MUST `unset CANONICAL_MODE` after all assertions to
     prevent leakage to subsequent fixtures (Story A Fixture H precedent,
     `check-cargo-mutants-policy-citations.sh:472`).

   **Step 1: Enumerate bc-*.md files. Fail-closed if none found** (mirrors
   `check-bc-no-numeric-test-counts.sh:23-27`):
   ```bash
   bc_files=("$bc_dir"/bc-*.md)
   if [ ! -f "${bc_files[0]}" ]; then
       echo "BC-CITE-001: no bc-*.md files found in $bc_dir — nothing to scan"
       return 1
   fi
   ```

   **Step 2: For each bc-*.md file, find all Trace/Source lines:**
   ```bash
   grep -nEh '^\*\*(Trace|Source)\*\*:' "${bc_files[@]}" || true
   ```
   The `|| true` guard prevents `set -euo pipefail` abort when no Trace/Source lines exist.

   **Step 3: Extract backtick-quoted `src/` citation tokens from each line (two-pass extractor,
   DEC-154 F-B2-02 fix):**

   **Pass 1** — extract every full backtick-quoted token beginning with `src/`, including
   internal spaces (backtick-only stop — `[^`]+`, NOT `[^` ]+`):
   ```bash
   grep -oE '`src/[^`]+`' | tr -d '`' || true
   ```
   The `|| true` guard prevents `set -euo pipefail` abort when a Trace/Source line has no
   backtick-quoted `src/` tokens — zero matches is a legitimate outcome (flows to
   SCOPE-EMPTY/floor guards; consistent with the `|| true` in Step 2).
   This is the **canonical extraction regex** — single source of truth (one call site in the
   script; counted by the post-fixture `grep -cF 'grep -oE'` pin). The `[^`]+` pattern stops
   only at a backtick, recovering tokens that contain internal spaces (comma-space line-ref
   lists, §-form citations, fn-with-args tokens). **The prior single-pass form**
   `` `src/[^` ]+` `` stopped at the first space, silently DROPPING 11 such tokens — do NOT
   revert to it (BC-X.13.005 invariant, DEC-154).

   **Pass 2** — for each token extracted by Pass 1, split on the first space and keep only
   the pre-space portion (`token="${token%% *}"`). This correctly reduces:
   - `` `src/file.rs::symbol` `` → `src/file.rs::symbol` (no space; unchanged)
   - `` `src/file.rs § "text"` `` → `src/file.rs` (space before §; reduced to bare path)
   - `` `src/config.rs:269-282, 308-310` `` → `src/config.rs:269-282` (further reduced by
     Step 4 line-ref strip)
   - `` `src/api/jira/issues.rs::add_comment(internal: bool)` `` → `src/api/jira/issues.rs::add_comment(internal:` (Step 5 strip-from-first-`(` normalizes to `add_comment`; EC-CITE-059)
   - `` `src/file.rs:~120` `` → `src/file.rs:~120` (no space; unchanged)
   - `` `src/file.rs` `` → `src/file.rs` (no space; unchanged)

   **Comma-lineref normalization (Pass 2 cleanup):** after the space-split, strip any trailing
   `, NN` or `, NN-MM` groups from the file component (comma-space line-ref list form,
   e.g., `src/cache.rs:7` after Pass 2 already strips the `, 30-32` part; Step 4 line-ref
   strip then reduces to `src/cache.rs`).

   **Step 4: For each extracted token, determine citation form and check:**

   a. Strip citation suffixes to get the file path:
      - `::symbol` form: `file="${token%%::*}"` + `symbol="${token##*::}"` (last `::` strip,
        analogous to Story A's `::strip transform`). If `file == token` (no `::` found),
        there is no symbol component — treat as bare file form.
      - `:~NN` or `:NN`/`:NN-MM` form: `file="${token%%:*}"` (strip at first `:`).
      - `§ ...` form: never reaches here — Pass 2 space-split already reduced to bare file.
      - Bare file: `file="$token"`.

   **(pre-check) Glob silent-skip:** If the `file` component (after suffix stripping) contains
   `*`, silently skip this token — emit NO `DEAD:` message, continue to next token (EC-011;
   BC-X.13.005 Step 3, EC-CITE-043). This explicit pre-check MUST appear BEFORE the shape guard
   so that glob paths never produce spurious `DEAD: malformed citation` output.
   ```bash
   if printf '%s' "$file" | grep -qF '*'; then
       continue
   fi
   ```

   b. **File-path shape guard:** Validate `file` against `^src/[a-zA-Z0-9_/.-]+\.[a-zA-Z0-9]+$`
      (any extension); reject path-traversal (`..`). Truly-malformed tokens (containing `..` or
      failing this shape — e.g. missing extension, illegal characters) → emit
      `DEAD: malformed citation skipped: $token` and continue.

      **Tier assignment (Step 3b — applied immediately after shape guard passes and glob tokens
      are skipped):**
      - **Tier (i) — `.rs` tokens:** proceed to file-existence check (step c), then full symbol
        dispatch (step d) for `::symbol` forms.
      - **Tier (ii) — non-`.rs` `src/` tokens** (e.g., `.snap`, `.json`, `.toml`): proceed to
        file-existence check (step c) only. If absent → `DEAD: $file not found`. Symbol check
        (step d) is **not run** — the symbol grammar (`fn`/`mod`/`struct`/`const` grep anchors)
        is Rust-specific and does not apply to non-Rust files. Token **counts toward
        `total_citations` / N** identically to `.rs` tokens.

   c. **File-existence check:** `[ -f "$src_root/$file" ]` → if fails, emit
      `DEAD: $file not found` and continue (applies to both tier (i) and tier (ii)).

   d. **Symbol check (only for `::symbol` form; tier (i) `.rs` tokens — tier (ii) tokens skip
      this step entirely):** Strip from the first `(` onward from `symbol`
      before classification (`symbol="${symbol%%\(*}"` — subsumes bare `()` and `(args...)`,
      e.g., `cache_root()` → `cache_root`; `add_comment(internal: bool)` → `add_comment`;
      EC-CITE-042, EC-CITE-059). Then apply the
      **7-branch shape-split** (BC-X.13.005 Step 5, DEC-154 Option A dispatch order — first
      match wins; "post-`::` symbol" means the component after `file::`, or after `file::tests::`
      for branch (c)):

      **(a) Function / method (primary — applies to all symbols first):** Definition-anchored
      grep (NOT plain `grep -q symbol` — that false-greens on import-only occurrences, the
      exact DEC-148 class; EC-CITE-039):
      ```bash
      grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?((unsafe|const|async|extern[[:space:]]+\"[^\"]*\")[[:space:]]+)*fn[[:space:]]+${symbol}([^[:alnum:]_]|$)" \
          "$src_root/$file"
      ```
      If matches: ALIVE. If fails: proceed to (b).

      **(b) `::tests` module-path [DEC-154 addition — on fn-grep failure]:** If `symbol` matches
      `^tests$` (exact — the `mod tests` module-path form, e.g., `src/adf.rs::tests`), run the
      module-definition anchored grep (verified against 5/5 cited files in adjudication §2.1):
      ```bash
      grep -Eq '^[[:space:]]*(pub[[:space:]]+)?mod[[:space:]]+tests[[:space:]{]' \
          "$src_root/$file"
      ```
      The `[[:space:]{]` end-anchor requires a space or opening brace after `tests`, preventing
      false-matches on `mod testsuite` or `mod tests_helpers`. If matches: ALIVE. If fails: DEAD
      (no further fallback for the `::tests` shape).

      **(c) `::tests::testfn` composition [DEC-154 addition — on fn-grep failure]:** If the full
      post-file component of the token (everything between `file::` and end of token) matches
      `^tests::[a-z_][a-z0-9_]*$` (i.e., `src/file.rs::tests::testfn`), apply defense-in-depth
      composition: (1) run the `mod tests` check from (b) on the file; (2) run the fn-grep from
      (a) on the final `testfn` symbol. Both must pass → ALIVE. If either fails → DEAD. (In the
      current corpus the sole instance `src/types/assets/linked.rs::tests::display_id_fallback_with_hint`
      also passes branch (a) alone — test functions are defined with `fn`. Branch (c) is
      defense-in-depth confirming the test module exists; EC-CITE-056.)

      **(d) Constant [was (b) — on fn-grep failure]:** If `symbol` matches `^[A-Z][A-Z0-9_]*$`
      (all-caps Rust constant convention, EC-CITE-041), apply anchored grep:
      ```bash
      grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?(const|static)[[:space:]]+${symbol}[[:space:]:]" \
          "$src_root/$file"
      ```
      The `^[[:space:]]*` line anchor prevents mid-line false-greens — a `const` declaration
      occurring after non-whitespace content on the same line (e.g., in a doc comment
      `/// pub const NAME:` or a string literal) would match the unanchored form but is rejected
      by the anchor. The `(\([^)]*\))?` group captures visibility-restriction suffixes —
      `pub(crate)`, `pub(super)`, `pub(in path::to::mod)` — so `pub(crate) const MAX_ADF_DEPTH:
      usize` is matched. **The anchor and group together are the operative protection**: without
      the anchor, the `(\([^)]*\))?` group alone does not prevent mid-line false-greens; without
      the group, the anchor alone does not handle `pub(crate)` visibility. Without this group, any
      `pub(crate) const NAME:` declaration falls through to DEAD. **Ordering note:** branch (d)
      MUST run before branch (e) — UPPER_CASE symbols (e.g., `MAX_ADF_DEPTH`) also match the
      CamelCase pattern `^[A-Z][A-Za-z0-9_]*$`; (d) takes priority so UPPER_CASE symbols are not
      mis-routed to the type-def grep. (EC-CITE-051; F-B3-02.) If matches: ALIVE. If fails: proceed to (e).

      **(e) Standalone CamelCase type [DEC-154 addition — on fn-grep and UPPER_CASE failure]:**
      If `symbol` matches `^[A-Z][A-Za-z0-9_]*$` (CamelCase — starts with uppercase, body may
      contain mixed-case letters, digits, underscores; no further `::` separators in the
      post-file component — e.g., `src/adf.rs::AdfBuilder`, `src/types/jira/bulk.rs::BulkTransitionRequest`),
      run the type-definition anchored grep (verified against 6/6 cited types in adjudication §2.3):
      ```bash
      grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?(struct|enum|type|trait|union)[[:space:]]+${symbol}[<[:space:](]" \
          "$src_root/$file"
      ```
      The `[<[:space:](]` end-anchor handles generics (`struct Foo<T>`), unit-struct brace
      (`struct Foo {`), tuple struct (`struct Foo(`), and type-alias space (`type Foo =`). If
      matches: ALIVE. If fails: DEAD.

      **(f) Type::method [was (c) — on fn-grep failure]:** If the original `::symbol` token has
      at least two `::` separators AND the component before the last `::` is CamelCase (e.g.,
      `src/adf.rs::AdfBuilder::finish`; EC-CITE-040), apply dual check: (1) fn-grep on the
      method name (last `::` component); (2) verify the type name (CamelCase component before
      last `::`) appears as a type definition:
      ```bash
      type_name="${token%::*}"; type_name="${type_name##*::}"  # component before last ::
      # CAUTION: ${token##*::} alone would yield the METHOD name (last :: component), not the type name.
      grep -Eq "(struct|enum|type|trait|impl)[[:space:]]+${type_name}" "$src_root/$file"
      ```
      If BOTH sub-checks pass: ALIVE. If either fails: DEAD.

      **(7) No permissive fallback:** symbols that do not match any of the 7 branches —
      (a) fn-grep primary, (b) `::tests` module-path, (c) `::tests::testfn` composition,
      (d) UPPER_CASE constant, (e) standalone CamelCase type, (f) Type::method, (7) otherwise
      DEAD — are classified DEAD. The draft's former "secondary `grep -q $symbol`" fallback is
      intentionally NOT implemented — it false-greens on import-only occurrences, exactly
      reopening the DEC-148 class. Fixture C in `--self-test` proves import-only occurrences
      are correctly DEAD. v2 deferrals (macro citations, Type::method correlation, continuation-
      line stitching) — see Out of Scope §6.

   e. **Count all checked citations** for the coverage-floor guard.

   **Step 5: Coverage-floor guard (CANONICAL_MODE only):**
   ```bash
   if [ "$canonical" = "1" ] && [ "$total_citations" -lt "$FLOOR" ]; then
       echo "BC-CITE-COVERAGE-FLOOR: expected >= ${FLOOR} src/ citations, got ${total_citations}. Update FLOOR when citations are intentionally removed (the floor is a lower bound; additions never fire it)."
       return 1
   fi
   ```
   `FLOOR` is set via the formula `floor(0.75 × N)` where N is the total `src/` citation count
   measured by running the script in canonical mode on develop HEAD at delivery time. Calibration
   at 2026-07-06 (two-tier baseline on 2b09313, F-01): N ≈ 309, FLOOR ≈ 231 (pre-two-tier
   post-Task-0-hygiene census: N=331, FLOOR=248; pre-hygiene DEC-154 census: N=326, FLOOR=244;
   implementer remeasures at delivery).
   The implementer MUST run the script in canonical mode on develop HEAD, record N, and set
   `FLOOR=floor(0.75 × N)` at script scope (NOT `local`
   inside `run_check` — see scope invariants above) before submitting the PR. The FLOOR is a
   LOWER BOUND — additions never fire it; recalibrate only
   when Trace/Source lines are intentionally removed.

   **Step 6: Report offenders or success:**
   - Non-empty offenders list: print each `DEAD:` line, then summary
     `$K stale citation(s) found in bc-*.md Trace/Source fields`; `return 1`.
   - Empty offenders: print `Check passed: $N citations checked`; `return 0`.

   **Post-run preamble checks (in `--self-test` block, before any fixture):**
   - `bash -n "${BASH_SOURCE[0]}"` (top-of-file; unconditional)
   - `grep -Eq '^#.*BC-CITE-001' "${BASH_SOURCE[0]}"` (literal pin in script header)

3. **Write `--self-test` fixture suite (10 fixtures A–K, embedded in script).**

   Self-test follows the Story A fixture idiom exactly:
   - All variable assertions use `[ <cond> ] || { echo "Fixture X FAIL: …"; exit 1; }` — no
     `&&`-style positive assertions (not safe under `set -e`).
   - Each fixture uses `set +e; output=$(run_check 2>&1); rc=$?; set -e`.
   - Fixtures use hermetic temp dirs: `BC_DIR`, `SRC_ROOT` set to temp paths.
   - `fixtures_run` counter (initialized to 0; incremented once per fixture, including sub-probed
     fixtures; checked after all fixtures against `readonly EXPECTED_FIXTURES=10`).
   - Cleanup trap: `trap 'rm -rf "${tmp_A:-}" ... "${tmp_K:-}" "${tmp_G2:-}" "${tmp_F_neg:-}" "${tmp_B_snap_pos:-}" "${tmp_B_snap_neg:-}"' EXIT`.
   - **CANONICAL_MODE hygiene (F-B2-06):** add `unset CANONICAL_MODE` at the TOP of the
     `--self-test` block (before any fixture), plus the explicit invariant: "CANONICAL_MODE MUST
     NOT be set during Fixtures A–F/I–K; Fixture G sets it inline and unsets it after."

   **Self-test success echo (BC-X.13.006 postcondition, F-B1-06):** After all fixtures and
   post-fixture assertions pass, the `--self-test` block MUST emit:
   ```bash
   echo "All self-test fixtures passed (${fixtures_run}/${EXPECTED_FIXTURES})"
   exit 0
   ```
   This is the observable success string `All self-test fixtures passed (10/10)` required by
   BC-X.13.006. The count `10/10` is load-bearing — any reduction in fixture coverage surfaces
   here via this line. Emit this AFTER the `fixtures_run = EXPECTED_FIXTURES` integrity check
   (so the count is verified correct) and as the final statement before `exit 0`.

   See AC-002 for the full fixture specification including hermetic printf setup skeletons
   (one per fixture), assertions, kill-traces, and post-fixture self-assertions.

4. **Modify `.github/workflows/ci.yml`:** Story A PR #572 added two steps to the `spec-guard`
   job (the Guard 2 pair: `check-cargo-mutants-policy-citations self-test (Guard 2)` + `check-cargo-mutants-policy-citations (Guard 2, DEC-150)`). These are currently the LAST two steps in the
   job's step list (verified against live ci.yml). Add Guard 1's two new steps AFTER the
   existing `check-cargo-mutants-policy-citations (Guard 2, DEC-150)` step, preserving the
   per-guard self-test-before-canonical ordering for the new guard:
   ```yaml
   - name: check-bc-citation-symbols self-test (BC-CITE-001)
     run: bash scripts/check-bc-citation-symbols.sh --self-test

   - name: check-bc-citation-symbols (BC-CITE-001)
     run: bash scripts/check-bc-citation-symbols.sh
   ```
   Also update the `spec-guard` job `name:` field. **Current value** (set by Story A PR #572,
   verified against live ci.yml line 111):
   `"Spec Guards (BC counts, numeric-count lint, mutants policy scope)"`.
   **Update to:** `"Spec Guards (BC counts, numeric-count lint, citation checks, mutants policy scope)"` —
   inserting `"citation checks"` before the existing `"mutants policy scope"` segment to
   preserve all live name segments. No changes to `ci-gate.needs` (per DEC-096/097: `spec-guard`
   is already a required job).

5. **Modify `CHANGELOG.md`:** Under `## [Unreleased]`, add under `### Added`:
   ```
   - **CI: BC-body Trace/Source citation guard (Guard 1) (DEC-148):** adds
     `scripts/check-bc-citation-symbols.sh` (BC-CITE-001; validates `src/` file and symbol
     citations in `**Trace**:`/`**Source**:` fields of all `bc-*.md` bodies; definition-anchored
     symbol grep; self-test fixtures; coverage-floor guard) as a step in the `spec-guard` CI job.
     Prevents the Seam-extraction citation-drift class (DEC-147/148/149).
   ```

6. **Modify `CLAUDE.md`:** Add one doc-fallout bullet in "AI Agent Notes" (following the
   `scripts/check-cargo-mutants-policy-citations.sh` bullet added by Story A PR #572):
   - `scripts/check-bc-citation-symbols.sh` — runs in spec-guard CI job; validates `src/` file
     and symbol citations in `**Trace**:`/`**Source**:` fields of `.factory/specs/prd/bc-*.md`
     bodies; exits 1 with `BC-CITE-001` offender list if any citation is stale. `--bc-dir`
     (designed-to-support) + `--src-root` (self-test only) + `--self-test` flags for offline verification.
     (DEC-148 Guard 1)

7. **Self-verify:** Read back all modified files. Confirm:
   - `scripts/check-bc-citation-symbols.sh --self-test` exits 0 (all 10 fixtures pass; preamble
     checks pass; `fixtures_run = "10"`).
   - `scripts/check-bc-citation-symbols.sh` (canonical run) exits 0 on develop HEAD with
     `.factory/specs/prd/` mounted (spec-guard job context). If run locally: set
     `BC_DIR=.factory/specs/prd` and run from repo root.
   - Guard emits `Check passed: N citations checked` where N ≥ FLOOR (implementer verifies:
     run in canonical mode on develop HEAD; N ≥ FLOOR ≈ 231 at 2026-07-06 calibration, two-tier baseline F-01).
   - ci.yml spec-guard job `name:` updated; two new steps present in correct position.
   - CHANGELOG `### Added` entry contains `BC-CITE-001`, `Trace`, `Source`, `bc-*.md`,
     `definition-anchored`, `DEC-148` keywords.
   - CLAUDE.md notes reference `scripts/check-bc-citation-symbols.sh` with correct description.
   - Grep for `&& (echo|printf|:|true|\{)` in the script — must emit zero lines (Story A
     VP-1-P25 idiom applied here: no `&&`-style positive assertions).

---

## Acceptance Criteria

ACs trace to BC-X.13.004, BC-X.13.005, BC-X.13.006 (anchored F2 2026-07-05) and to
specific EC-CITE-NNN clauses per the BC-X.13 subsystem in `cross-cutting.md §BC-X.13`.

---

### AC-001 — Guard passes GREEN on develop HEAD

`scripts/check-bc-citation-symbols.sh` exits 0 when run with `.factory/specs/prd/` mounted
(spec-guard job context, after Story A PR #572 develop @ ab78a2d). This confirms no stale
`src/` citations exist in bc-*.md Trace/Source fields on current develop HEAD.

(traces to BC-X.13.006 postcondition: GREEN on develop HEAD; EC-CITE-047)

**Sequencing note:** Guard 1 verifies citations that were already cleaned by DEC-148. Three
truly-dead citation clusters (EC-CITE-058) survive in `factory-artifacts` from before Guard 1
existed — these are correctly flagged by the guard. They MUST be resolved in the Task 0
factory-artifacts commit (citation hygiene) BEFORE the canonical guard can reach GREEN. If any
NEW stale citations have been introduced since the DEC-148 cleanup, the guard will report them
as additional findings — Task 7 self-verify step will catch this before the
PR is opened.

---

### AC-002 — Self-test fixture table

`scripts/check-bc-citation-symbols.sh --self-test` exits 0. The `--self-test` block runs
all ten fixtures (A–K) and five post-fixture self-assertions using hermetic temp directories.

**Fixture assertion idiom (VP-1-P25 from Story A — apply here):**
All fixture assertions MUST use the form `[ <cond> ] || { echo "Fixture X FAIL: …"; exit 1; }`.
No `&&`-style positive-action forms. Verify with:
```bash
grep -E '&& (echo|printf|:|true|\{)' scripts/check-bc-citation-symbols.sh
```
must output zero lines.

| Fixture | Description | Expected behavior | Kill-trace |
|---------|-------------|-------------------|------------|
| A | Dead-symbol: `src/adf.rs::nonexistent_fn_selftest` — file exists (touch), symbol NOT defined | `rc=1`; output contains `DEAD: nonexistent_fn_selftest not found in src/adf.rs` | (a) Omit definition-anchored grep → fn-check never runs → `rc=0` → RED |
| B | Dead-file: `src/nonexistent_file_selftest.rs::some_fn` — file NOT created; **tier-(ii) sub-probes (EC-CITE-060):** positive: `.snap` file exists (`src/mock_b.snap` present) → ALIVE, counted; negative: `.snap` file absent (`src/missing_b.snap` not created) → `DEAD: src/missing_b.snap not found` | Main: `rc=1`; output contains `DEAD: src/nonexistent_file_selftest.rs not found`; positive sub-probe: `rc=0`, output contains `1 citations checked`; negative sub-probe: `rc=1`, output contains `DEAD: src/missing_b.snap not found` | (a) Omit file-existence check → script tries symbol grep on missing file → error → RED differently; (b) file-existence check fires first → clean DEAD message; (c) [tier-ii kill] Shape guard uses old `\.rs$` pattern — `.snap` extension rejected → `DEAD: malformed citation skipped: src/mock_b.snap` instead of ALIVE → positive sub-probe `rc=1` → RED; proves any-extension shape guard (`\.[a-zA-Z0-9]+$`) required |
| C | Import-only false-green: `src/cli/issue/create.rs::handle_jsm_create` — mock `create.rs` has only `use super::jsm_create::{JsmCreateArgs, handle_jsm_create};` (import) | `rc=1`; `handle_jsm_create` DEAD (import not a definition) | (a) Plain `grep -q "handle_jsm_create"` → matches import → `rc=0` → RED; proves definition-anchored grep is required |
| D | Source-field extraction: `**Source**: `src/nonexistent_source_selftest.rs::source_fn`` (Source field, not Trace) — file NOT created | `rc=1`; output contains dead citation | (a) Scan only `**Trace**:` lines, skip `**Source**:` → `rc=0` → RED; proves both field types are scanned |
| E | Two-pass extraction: `**Trace**: `src/mock_e.rs § "some section"`` — mock `mock_e.rs` exists (touch, empty); F-B2-02/07 differential signal | `rc=0`; output contains `1 citations checked` (proves Pass 1 extracted the space-containing token, Pass 2 reduced it to bare path, file-existence check ran — NOT silently dropped) | (a) Use old single-pass regex `[^` ]+` (stop-on-space) → § form token SILENTLY DROPPED → `0 citations checked` in output → assertion fails → RED; (b) Apply symbol grep to §-form token → grepping empty file fails → `rc=1` → RED; proves §-form is file-existence-only and that the token IS extracted |
| F | Success path: `**Trace**: `src/mock_f.rs::mock_f_fn_selftest`` + `**Source**: `src/mock_f.rs`` — mock `mock_f.rs` defines `fn mock_f_fn_selftest() {}`; sub-probes: (1) `src/mock_f.rs::MAX_ADF_DEPTH` with `pub(crate) const MAX_ADF_DEPTH: usize = 256;` (EC-CITE-051, anchored branch (d)); (2) `src/mock_f.rs::mock_f_fn_selftest(args: T)` fn citation with space-args form (EC-CITE-059, Step-5 strip: Pass 2 space-split → `mock_f_fn_selftest(args:`; strip-from-first-`(` → `mock_f_fn_selftest`); negative probe: mock containing ONLY `    // pub const MAX_ADF_DEPTH: usize = 256` doc-comment line MUST classify DEAD under anchored form | `rc=0` for all positive probes; output matches `^Check passed: [0-9]+ citations checked$`; negative probe `rc=1` (DEAD) | (a) Inverted polarity (return 1 on success) → `rc=1` → RED; (b) Omit success summary line → content assertion fails → RED; (c) [group-removal] Sub-probe: omit `(\([^)]*\))?` group → `pub(crate) const MAX_ADF_DEPTH:` from line-start no longer matches simplified `(pub[[:space:]]+)?` pattern → DEAD → `rc=1` → caught (EC-CITE-051); [anchor-removal] remove `^[[:space:]]*` anchor → negative probe's doc-comment line `    // pub const MAX_ADF_DEPTH:` matches unanchored form → false-ALIVE → `rc=0` → RED; (d) Delete Step-5 strip (`%%\(*`) → Pass 2 space-split gives `mock_f_fn_selftest(args:` → unstripped symbol `mock_f_fn_selftest(args:` has unbalanced `(` → fn-grep ERE is malformed → grep exits 2 → DEAD → `rc=1` → caught (EC-CITE-059); bare `()` form would NOT kill this mutation (empty parens = valid ERE group → grep exits 0 on the balanced group) |
| G | Coverage-floor RED probe: (1) bc dir with ONE citation total (well below FLOOR); (2) second sub-probe with 100 citations (still below FLOOR=231) — both with CANONICAL_MODE=1; `unset CANONICAL_MODE` after all G assertions (Story A Fixture H precedent + F-B2-06) | Both probes: `rc=1`; output contains `BC-CITE-COVERAGE-FLOOR:`; output contains `expected >= ${FLOOR}` (no hardcoded integer); single `fixtures_run` increment for entire G | (a) Omit CANONICAL_MODE gate → floor never fires → `rc=0` → RED; (b) FLOOR mutation `-lt "$FLOOR"` → `-lt "5"` → 100-citation probe: 100 > 5 → rc=0 → assertion `[ "$rc" -eq 1 ]` fails → caught; (c) CANONICAL_MODE as `local` in run_check → floor false-greens → RED |
| I | `::tests` module-path ALIVE (EC-CITE-052): `src/mock_i.rs::tests` — mock `mock_i.rs` defines `mod tests { }` | `rc=0`; output matches `^Check passed: [0-9]+ citations checked$` | (a) Omit mod-tests anchored grep → symbol `tests` falls through all branches → DEAD → `rc=1` → RED; proves branch (b) is required; (b) Polarity swap on branch (b): invert mod-tests return so a matching `mod tests` block returns DEAD → symbol `tests`, file has `mod tests { }` → normally ALIVE but swap → DEAD → `rc=1` → assertion `[ "$rc" -eq 0 ]` fails → RED |
| J | `::tests` module-path negative DEAD (EC-CITE-053): `src/mock_j.rs::nonexistent_mod` — file has bare text `nonexistent_mod` (no `mod` keyword), symbol not a definition | `rc=1`; output contains `DEAD:` | (a) Add permissive `grep -q "$symbol"` fallback → bare text `nonexistent_mod` in file matches → `rc=0` → RED; proves no-permissive-fallback is enforced (requires non-empty mock — empty file would not trigger permissive fallback, failing to kill mutation). Branch (b) polarity swap is caught by Fixture I (symbol=tests, normally ALIVE → swap → DEAD → rc≠0 → RED) — J's symbol `nonexistent_mod` never enters branch (b) (fails the `^tests$` entry guard), so polarity-swap kill does not apply here. |
| K | Standalone CamelCase type ALIVE (EC-CITE-054): `src/mock_k.rs::MockKStruct` — mock `mock_k.rs` defines `pub struct MockKStruct { }` | `rc=0`; output matches `^Check passed: [0-9]+ citations checked$` | (a) Omit type-def anchored grep → symbol `MockKStruct` falls through all branches → DEAD → `rc=1` → RED; proves branch (e) is required; (b) Polarity swap on branch (e): invert type-def return so a matching type definition returns DEAD → symbol `MockKStruct`, file has `pub struct MockKStruct { }` → normally ALIVE but swap → DEAD → `rc=1` → assertion `[ "$rc" -eq 0 ]` fails → RED |

**Hermetic fixture setup skeletons (F-B1-04 + DEC-154 additions):**

Each fixture creates an isolated temp directory, populates a bc-*.md stub, and (where needed)
creates mock `src/` files. Set `BC_DIR` and `SRC_ROOT` env vars before invoking `run_check`.
The bc stub file name MUST match `bc-*.md` (e.g., `bc-mock.md`) to be picked up by the glob.

**CANONICAL_MODE hygiene (F-B2-06):** The `--self-test` block MUST begin with:
```bash
unset CANONICAL_MODE   # F-B2-06: ensure floor guard is OFF during Fixtures A–F/I–K;
                       # Fixture G sets CANONICAL_MODE=1 inline and unsets it after
```
Invariant: CANONICAL_MODE MUST NOT be set during Fixtures A–F/I–K; Fixture G sets it inline
(`CANONICAL_MODE=1`) and unsets it after all G assertions (`unset CANONICAL_MODE`).

```bash
# Fixture A — dead-symbol (file exists, fn NOT defined)
mkdir -p "$tmp_A/src"
printf '**Trace**: `src/adf.rs::nonexistent_fn_selftest`\n' > "$tmp_A/bc-mock.md"
touch "$tmp_A/src/adf.rs"   # file exists; symbol NOT in it
set +e; BC_DIR="$tmp_A" SRC_ROOT="$tmp_A" output=$(run_check 2>&1); rc=$?; set -e

# Fixture B — dead-file (file NOT created)
mkdir -p "$tmp_B/src"
printf '**Source**: `src/nonexistent_file_selftest.rs::some_fn`\n' > "$tmp_B/bc-mock.md"
# $tmp_B/src/nonexistent_file_selftest.rs intentionally NOT created
set +e; BC_DIR="$tmp_B" SRC_ROOT="$tmp_B" output=$(run_check 2>&1); rc=$?; set -e

# Fixture B sub-probe (EC-CITE-060) — tier (ii) .snap positive (file exists → ALIVE)
# Shape guard accepts `.snap` extension ([a-zA-Z0-9]+ matches `snap`); Step 4 file-existence
# passes; Step 5 symbol check skipped; token counted toward N.
# Kill: old `\.rs$` guard → DEAD: malformed citation skipped: src/mock_b.snap → rc=1 → RED.
mkdir -p "$tmp_B_snap_pos/src"
printf '**Trace**: `src/mock_b.snap`\n' > "$tmp_B_snap_pos/bc-mock.md"
touch "$tmp_B_snap_pos/src/mock_b.snap"   # .snap file exists → tier (ii) file-existence passes → ALIVE
set +e; BC_DIR="$tmp_B_snap_pos" SRC_ROOT="$tmp_B_snap_pos" output_b_pos=$(run_check 2>&1); rc_b_pos=$?; set -e
[ "$rc_b_pos" -eq 0 ] || { echo "Fixture B sub-probe (snap-positive) FAIL: expected rc=0, got rc=$rc_b_pos; output=$output_b_pos"; exit 1; }
printf '%s' "$output_b_pos" | grep -q '1 citations checked' || { echo "Fixture B sub-probe (snap-positive) FAIL: expected '1 citations checked' in output; output=$output_b_pos"; exit 1; }

# Fixture B sub-probe (EC-CITE-060) — tier (ii) .snap negative (file absent → DEAD: not found)
# Shape guard accepts `.snap`; Step 4 file-existence fails → DEAD: src/missing_b.snap not found.
mkdir -p "$tmp_B_snap_neg/src"
printf '**Trace**: `src/missing_b.snap`\n' > "$tmp_B_snap_neg/bc-mock.md"
# $tmp_B_snap_neg/src/missing_b.snap intentionally NOT created
set +e; BC_DIR="$tmp_B_snap_neg" SRC_ROOT="$tmp_B_snap_neg" output_b_neg=$(run_check 2>&1); rc_b_neg=$?; set -e
[ "$rc_b_neg" -eq 1 ] || { echo "Fixture B sub-probe (snap-negative) FAIL: expected rc=1, got rc=$rc_b_neg"; exit 1; }
printf '%s' "$output_b_neg" | grep -qF 'DEAD: src/missing_b.snap not found' || { echo "Fixture B sub-probe (snap-negative) FAIL: expected DEAD message in output; output=$output_b_neg"; exit 1; }
# (Both snap sub-probes share Fixture B's fixtures_run increment — count once total)

# Fixture C — import-only (fn in use statement, NOT a definition)
mkdir -p "$tmp_C/src/cli/issue"
printf '**Trace**: `src/cli/issue/create.rs::handle_jsm_create`\n' > "$tmp_C/bc-mock.md"
printf 'use super::jsm_create::{JsmCreateArgs, handle_jsm_create};\n' \
    > "$tmp_C/src/cli/issue/create.rs"
set +e; BC_DIR="$tmp_C" SRC_ROOT="$tmp_C" output=$(run_check 2>&1); rc=$?; set -e

# Fixture D — Source-field extraction (dead-file on **Source** line, not **Trace**)
mkdir -p "$tmp_D/src"
printf '**Source**: `src/nonexistent_source_selftest.rs::source_fn`\n' > "$tmp_D/bc-mock.md"
# $tmp_D/src/nonexistent_source_selftest.rs intentionally NOT created
set +e; BC_DIR="$tmp_D" SRC_ROOT="$tmp_D" output=$(run_check 2>&1); rc=$?; set -e

# Fixture E — two-pass extraction / §-form (F-B2-02/07 differential signal)
# Pass 1 extracts full token `src/mock_e.rs § "some section"` (backtick-only stop);
# Pass 2 splits at space → `src/mock_e.rs`; file-existence check runs; no symbol check.
# Assert output contains "1 citations checked" — proves the token was NOT silently dropped.
mkdir -p "$tmp_E/src"
printf '**Trace**: `src/mock_e.rs § "some section"`\n' > "$tmp_E/bc-mock.md"
touch "$tmp_E/src/mock_e.rs"   # file exists; empty (no fns); symbol check MUST NOT run
set +e; BC_DIR="$tmp_E" SRC_ROOT="$tmp_E" output=$(run_check 2>&1); rc=$?; set -e

# Fixture F — success path (fn defined; both Trace and Source scanned)
mkdir -p "$tmp_F/src"
printf '**Trace**: `src/mock_f.rs::mock_f_fn_selftest`\n**Source**: `src/mock_f.rs`\n' \
    > "$tmp_F/bc-mock.md"
printf 'fn mock_f_fn_selftest() {}\n' > "$tmp_F/src/mock_f.rs"
set +e; BC_DIR="$tmp_F" SRC_ROOT="$tmp_F" output=$(run_check 2>&1); rc=$?; set -e
# NOTE: assert this invocation's rc/output BEFORE the sub-probes below overwrite them.
# Each invocation gets its own rc/output variables; the second run_check call reassigns
# `output` and `rc` — assertions for this first invocation must precede that point.

# Fixture F sub-probe (1): pub(crate) const MAX_ADF_DEPTH (EC-CITE-051, F-B2-01+F-B3-02 fixed)
# Citation MUST reference src/mock_f.rs (the mock file), NOT src/adf.rs (F-B2-01 fix).
printf '**Trace**: `src/mock_f.rs::MAX_ADF_DEPTH`\n' >> "$tmp_F/bc-mock.md"
printf 'pub(crate) const MAX_ADF_DEPTH: usize = 256;\n' >> "$tmp_F/src/mock_f.rs"
# rerun: must be ALIVE via anchored const/static grep (^[[:space:]]* anchor + (\([^)]*\))? group)

# Fixture F sub-probe (2): fn citation with space-args form (EC-CITE-059, F-B4-H-01 corrected)
# Citation `mock_f_fn_selftest(args: T)`: Pass 2 space-split → `mock_f_fn_selftest(args:`;
# strip-from-first-( removes `(args:` → `mock_f_fn_selftest`; fn-grep finds definition → ALIVE.
# Under delete-strip mutation: unstripped `mock_f_fn_selftest(args:` has unbalanced `(` →
# fn-grep ERE is malformed → grep exits 2 → DEAD → rc=1 → caught (EC-CITE-059).
# Bare `()` form would NOT kill this mutation: empty parens = valid ERE group → grep exits 0.
printf '**Trace**: `src/mock_f.rs::mock_f_fn_selftest(args: T)`\n' >> "$tmp_F/bc-mock.md"
# mock_f_fn_selftest is defined above as `fn mock_f_fn_selftest() {}`; body stays unchanged

set +e; BC_DIR="$tmp_F" SRC_ROOT="$tmp_F" output=$(run_check 2>&1); rc=$?; set -e
# All citations checked (fn, bare, const, fn-with-paren); rc=0; output matches "^Check passed:"

# Fixture F negative sub-probe: doc-comment mock MUST classify DEAD under anchored form (F-B3-02)
# A mock containing ONLY an indented doc-comment line mentioning const NAME must be DEAD
# (non-whitespace // before pub const → ^[[:space:]]* anchor rejects → no match → DEAD)
mkdir -p "$tmp_F_neg/src"
printf '**Trace**: `src/mock_f_neg.rs::MAX_ADF_DEPTH`\n' > "$tmp_F_neg/bc-mock.md"
printf '    // pub const MAX_ADF_DEPTH: usize = 256;\n' > "$tmp_F_neg/src/mock_f_neg.rs"
set +e; BC_DIR="$tmp_F_neg" SRC_ROOT="$tmp_F_neg" output_fn=$(run_check 2>&1); rc_fn=$?; set -e
# Assertion: rc_fn=1 (DEAD — doc-comment line non-whitespace prefix // rejected by anchor)
[ "$rc_fn" -eq 1 ] || { echo "Fixture F negative sub-probe FAIL: doc-comment mock should be DEAD (rc=$rc_fn)"; exit 1; }
# (Negative sub-probe shares Fixture F's fixtures_run increment — counts once total)

# Fixture G — coverage-floor probe (TWO probes: 1-citation + 100-citation, both below FLOOR)
mkdir -p "$tmp_G/src"
printf '**Trace**: `src/mock_g.rs::mock_g_fn_selftest`\n' > "$tmp_G/bc-mock.md"
printf 'fn mock_g_fn_selftest() {}\n' > "$tmp_G/src/mock_g.rs"
CANONICAL_MODE=1   # toggle floor guard ON for this fixture (script-scope variable)
# G main probe: 1 citation, CANONICAL_MODE=1 → floor fires
set +e; BC_DIR="$tmp_G" SRC_ROOT="$tmp_G" output=$(run_check 2>&1); rc=$?; set -e
# ... assertions: rc=1; "BC-CITE-COVERAGE-FLOOR:"; "expected >= ${FLOOR}" ...

# G second probe: 100 citations (below FLOOR=231); kill-trace tests FLOOR literal mutation
mkdir -p "$tmp_G2/src"
{ for i in $(seq 1 100); do printf '**Trace**: `src/mock_g2.rs::mock_g2_fn`\n'; done; } \
    > "$tmp_G2/bc-mock.md"
printf 'fn mock_g2_fn() {}\n' > "$tmp_G2/src/mock_g2.rs"
# CANONICAL_MODE=1 still set from above
set +e; BC_DIR="$tmp_G2" SRC_ROOT="$tmp_G2" output_g2=$(run_check 2>&1); rc_g2=$?; set -e
# Kill-trace: mutation -lt "$FLOOR" → -lt "5": 100 > 5 → rc=0 → assertion fails → caught
# ... assertion: rc_g2=1; "BC-CITE-COVERAGE-FLOOR:" in output_g2 ...
unset CANONICAL_MODE   # Story A Fixture H + F-B2-06: prevent leakage to subsequent fixtures
fixtures_run=$((fixtures_run + 1))   # G (including second sub-probe) counts once

# Fixture I — ::tests module-path ALIVE (EC-CITE-052, DEC-154 branch (b))
mkdir -p "$tmp_I/src"
printf '**Trace**: `src/mock_i.rs::tests`\n' > "$tmp_I/bc-mock.md"
printf 'mod tests {\n}\n' > "$tmp_I/src/mock_i.rs"
set +e; BC_DIR="$tmp_I" SRC_ROOT="$tmp_I" output=$(run_check 2>&1); rc=$?; set -e

# Fixture J — ::tests module-path negative DEAD (EC-CITE-053, DEC-154 branch (b))
# File has bare text occurrence of "nonexistent_mod" (no `mod` keyword) so that a
# permissive `grep -q "$symbol"` fallback mutation IS killed: bare text matches
# permissive grep → rc=0 → assertion fails → caught. An empty file (touch) would
# not trigger this kill (grep returns rc=1 for both correct and mutated code).
mkdir -p "$tmp_J/src"
printf '**Trace**: `src/mock_j.rs::nonexistent_mod`\n' > "$tmp_J/bc-mock.md"
printf 'nonexistent_mod\n' > "$tmp_J/src/mock_j.rs"   # bare text; no mod keyword → DEAD
set +e; BC_DIR="$tmp_J" SRC_ROOT="$tmp_J" output=$(run_check 2>&1); rc=$?; set -e

# Fixture K — standalone CamelCase type ALIVE (EC-CITE-054, DEC-154 branch (e))
mkdir -p "$tmp_K/src"
printf '**Trace**: `src/mock_k.rs::MockKStruct`\n' > "$tmp_K/bc-mock.md"
printf 'pub struct MockKStruct {\n}\n' > "$tmp_K/src/mock_k.rs"
set +e; BC_DIR="$tmp_K" SRC_ROOT="$tmp_K" output=$(run_check 2>&1); rc=$?; set -e
```

Multi-probe fixture convention: Fixture F (main + EC-CITE-051 sub-probe), Fixture G (main +
100-citation sub-probe) each count ONCE in `fixtures_run`. Fixtures I, J, K each count once.
Total fixture increments: A(1) + B(1) + C(1) + D(1) + E(1) + F(1) + G(1) + I(1) + J(1) + K(1) = 10.

**Test-writer discretion note (BC lockstep):** The BC pins EXPECTED_FIXTURES=10 (A–K). Fixtures
L (`::tests::testfn` positive, EC-CITE-056) and M (standalone CamelCase negative, EC-CITE-055)
are candidates that would strengthen coverage of branches (c) and (e) respectively. The
adjudication recommends adding them but acknowledges they push the count to 12, diverging from
the BC's K=10 pin. Do NOT add L/M without first updating BC-X.13.006 (PO decision required).
Stay at 10 fixtures to remain in BC lockstep.

**Post-fixture self-assertions (NOT fixtures; do NOT increment `fixtures_run`):**
- `[ "$(grep -cF 'BC-CITE-001' "${BASH_SOURCE[0]}")" = "4" ]` — exact count pin (header comment
  + preamble grep + Step-1 echo + own assertion line = 4; the composed-fragment `lit1='BC-CITE-''001'` anti-self-match line does NOT count by design; addition raises to 5 → RED, deletion drops to 3 → RED).
- Composed-fragment anti-self-match (Story A precedent, `check-cargo-mutants-policy-citations.sh:572-574`):
  `lit1='BC-CITE-''001'` then `[ "$(grep -E 'FAIL:' "${BASH_SOURCE[0]}" | grep -cF "$lit1")" = "0" ]` —
  enforces mechanically that no `FAIL:` diagnostic line contains the literal `BC-CITE-001`
  (which would corrupt the count-pin above). The fragment composition (`'BC-CITE-''001'`) avoids
  self-matching the assertion line itself (same mechanism as Story A).
- `[ "$(grep -cF 'bash -n' "${BASH_SOURCE[0]}")" = "2" ]` — top-of-file check + own assertion = 2.
- `[ "$(grep -cF 'grep -oE' "${BASH_SOURCE[0]}")" = "2" ]` — canonical extraction regex
  occurrence pin. Count is 2: one **Pass 1 grep** call site in `run_check`
  (`grep -oE '`src/[^`]+`' | tr -d '`'` — the single source of truth per BC-X.13.005
  invariant; the pattern appears ONCE in the script, not more) + this assertion line itself.
  Pass 2 (space-split) uses shell parameter expansion `${token%% *}`, NOT another grep -oE,
  so the count remains 2 under the two-pass extraction. (F-B1-05: pin fixed from stale "3" to
  firm "2"; verified correct under two-pass extractor — F-B2-02 does not add a second grep -oE.)
- Self-test summary echo: `[ "$(... | grep -cF 'All self-test fixtures passed')" = "1" ]` is
  NOT needed as a post-fixture assertion — the echo fires as the final statement before `exit 0`,
  so its presence is verified by the `--self-test` block reaching `exit 0`. However, the CI step
  `check-bc-citation-symbols self-test (BC-CITE-001)` can verify it by capturing stdout.
- `[ "$fixtures_run" = "$EXPECTED_FIXTURES" ]` — fixture-count integrity pin (string equality;
  prevents silent fixture omission via drop-a-fixture mutation; `EXPECTED_FIXTURES=10` declared
  `readonly` before first fixture).

(traces to BC-X.13.004, BC-X.13.005, BC-X.13.006 — all three contracts exercised across the
fixture suite; Fixture A→BC-X.13.005 fn-grep NO-MATCH/dead-symbol (no dedicated EC), B→EC-CITE-036/dead-file+EC-CITE-060/.snap-tier-ii-sub-probes, C→EC-CITE-039/
import-only, D→BC-X.13.004 precondition/Source-field scan, E→EC-CITE-045+EC-CITE-057/two-pass-
extraction-differential, F→BC-X.13.004 postcondition/success-path+EC-CITE-051/pub(crate)-const+
EC-CITE-059/fn-with-paren-strip+F-neg/anchor-negative-probe, G→EC-CITE-037/coverage-floor+
FLOOR-literal-mutation, I→EC-CITE-052/::tests-ALIVE, J→EC-CITE-053/::tests-DEAD+permissive-
fallback-kill, K→EC-CITE-054/CamelCase-ALIVE)

---

### AC-003 — Error output formats

When citations fail, the script emits lines in the following formats:
- `DEAD: $file not found` — file does not exist on disk; applies to **both tier (i) `.rs`
  tokens and tier (ii) non-`.rs` tokens** (the same file-existence check runs for both tiers)
- `DEAD: $symbol not found in $file` — file exists but symbol definition absent; applies to
  **tier (i) `.rs` tokens only** — tier (ii) tokens skip Step 5 symbol check entirely
- `DEAD: malformed citation skipped: $token` — extracted token fails the path shape guard
  (`^src/[a-zA-Z0-9_/.-]+\.[a-zA-Z0-9]+$`) or contains path-traversal (`..`); occurs before
  tier assignment
- `BC-CITE-COVERAGE-FLOOR: expected >= ${FLOOR} src/ citations, got ${N}. Update FLOOR when
  citations are intentionally removed (the floor is a lower bound; additions never fire it).`
  (CANONICAL_MODE=1 only)

All `DEAD:` lines are accumulated into an offenders list before reporting (collect-ALL semantics,
analogous to Story A's definition-anchored grep). The script does NOT exit early on first DEAD
citation — all citations in all bc-*.md files are checked before reporting. Summary line:
`$K stale citation(s) found in bc-*.md Trace/Source fields` (where K = offender count).

(traces to BC-X.13.004 postconditions: collect-all DEAD output formats; BC-X.13.005 postconditions: symbol classification ALIVE/DEAD; two-tier Step 3b (EC-CITE-060): `DEAD: not found` applies to both tiers; `DEAD: symbol not found` only tier (i); malformed only for shape-guard failures; EC-CITE-033, EC-CITE-035, EC-CITE-060)

---

### AC-004 — Scope restriction: Trace/Source lines only; src/ paths only

The guard extracts citations ONLY from lines matching `^\*\*(Trace|Source)\*\*:` (anchored at
line start, exact markup). It does NOT extract from:
- BC frontmatter (YAML block before `---` delimiter)
- BC body prose, Description, Preconditions, Postconditions, Invariants, Examples sections
- Lines that mention `src/` paths incidentally (not in a Trace/Source field)
- `tests/` citation paths (OUT OF SCOPE — see Out of Scope §1)
- BC-INDEX.md (OUT OF SCOPE — see Out of Scope §2)

Fixture F exercises the positive Trace + Source extraction path. Fixture D specifically
proves `**Source**:` lines are scanned (not just `**Trace**:`).

(traces to BC-X.13.004 precondition: scope — only Trace/Source lines; BC-X.13.006 invariant: Trace/Source anchor `^\*\*(Trace|Source)\*\*:` enforces scope mechanically; EC-CITE-049, EC-CITE-050)

---

### AC-005 — Coverage floor: fail-closed guard on empty-extraction

When run in CANONICAL_MODE (canonical CI invocation, no `--bc-dir` or `--self-test` flag),
the script MUST fail if the total count of `src/` citations extracted across all bc-*.md
files is below `FLOOR`.

The FLOOR guards against the fail-open scenario where the extraction logic silently skips all
citations (e.g., due to a bc_dir misconfiguration or a future bc-*.md glob expansion change)
and exits 0 vacuously. **FLOOR calibration:** the implementer MUST run the script in canonical
mode on develop HEAD, record N (the actual citation count), and set `FLOOR=floor(0.75 × N)` as a
script-scope assignment at script top (NOT `local` inside `run_check` — see Task 2 scope
invariants). Calibration at 2026-07-06 (two-tier baseline on 2b09313, F-01)
yields N ≈ 309, FLOOR ≈ 231 (pre-two-tier post-Task-0-hygiene census: N=331, FLOOR=248;
pre-hygiene DEC-154 census: N=326, FLOOR=244; implementer remeasures at delivery). The formula
gives ~25% headroom for legitimate BC edits while still catching catastrophic extraction dropout
(EC-CITE-037).

**FLOOR scope invariant (BC-X.13.004 invariant, F-B1-01):** `FLOOR` MUST be a script-scope
variable, NOT a `local` inside `run_check`. The single recalibration touchpoint is the
script-top `FLOOR=N` assignment. Because `FLOOR` is script-scope, Fixture G's assertion
`grep -qF "expected >= ${FLOOR}"` resolves the SAME `FLOOR` the guard comparison uses —
a mutation weakening only the comparison value (e.g., replacing `"$FLOOR"` with `"5"`)
while leaving `"expected >= ${FLOOR}"` in the message is caught by Fixture G seeing exit 0
where it expects exit 1 (Fixture G kill-trace (b)).

**CANONICAL_MODE scope invariant (BC-X.13.004 invariant):** CANONICAL_MODE MUST ALSO be a
script-scope variable, NOT a `local` inside `run_check`. The Fixture G toggle mechanism
(`CANONICAL_MODE=1` set in shell scope before invoking `run_check`) requires this: if
CANONICAL_MODE were `local`, Fixture G's env mutation would be a no-op and the floor guard
would false-green (Fixture G kill-trace (c)).

The `FLOOR` symbol MUST be used in BOTH the comparison (`[ "$total_citations" -lt "$FLOOR" ]`)
AND the message interpolation (`expected >= ${FLOOR}`). The script-scope binding ensures both
sites resolve the same variable. A mutation that weakens only the comparison value is caught by
Fixture G's `grep -qF "expected >= ${FLOOR}"` assertion (no hardcoded integer — the grep checks
the variable interpolation, not a literal "248", which is sound BECAUSE FLOOR is script-scope
and visible in the `--self-test` block).

(traces to BC-X.13.004 invariant: FLOOR symbol bound in both comparison and message;
BC-X.13.004 invariant: FLOOR and CANONICAL_MODE are script-scope; EC-CITE-037)

---

### AC-006 — CI wiring, job name, CLAUDE.md

**(a) CI steps:** The `spec-guard` job in `.github/workflows/ci.yml` contains two new Guard 1
steps (in this order), appended AFTER the existing `check-cargo-mutants-policy-citations (Guard 2, DEC-150)` step (which is the last step in Story A's delivery and remains the last step of
the Guard 2 pair):
1. `check-bc-citation-symbols self-test (BC-CITE-001)` — runs `--self-test` flag
2. `check-bc-citation-symbols (BC-CITE-001)` — runs canonical guard

The four-step ordering for the two guards preserves per-guard self-test-before-canonical
sequencing:
```
check-cargo-mutants-policy-citations self-test (Guard 2)   ← Story A step 1
check-cargo-mutants-policy-citations (Guard 2, DEC-150)    ← Story A step 2
check-bc-citation-symbols self-test (BC-CITE-001)          ← Story B step 1 (new)
check-bc-citation-symbols (BC-CITE-001)                    ← Story B step 2 (new)
```

**(b) Job name:** `spec-guard` job `name:` field reads
`"Spec Guards (BC counts, numeric-count lint, citation checks, mutants policy scope)"`.
Updated from the current value `"Spec Guards (BC counts, numeric-count lint, mutants policy scope)"`
(set by Story A PR #572, verified live at ci.yml line 111). The segment `"citation checks"` is
inserted before `"mutants policy scope"` to preserve all existing live segments.

**(c) `ci-gate.needs` unchanged:** `spec-guard` is already in `ci-gate.needs` (verified via
F1 §5). No `ci-gate.needs` modification required. Per DEC-096/097: no direct branch-protection
changes for new guards.

**(d) CLAUDE.md:** "AI Agent Notes" section contains one new bullet for
`scripts/check-bc-citation-symbols.sh` with a description including `BC-CITE-001`,
`**Trace**:`/`**Source**:`, `bc-*.md`, and `DEC-148 Guard 1`.

(traces to BC-X.13.006 postconditions: CI topology — spec-guard dual-worktree; self-test before canonical; EC-CITE-046, EC-CITE-048)

---

### AC-007 — CHANGELOG entry

`CHANGELOG.md` `## [Unreleased]` → `### Added` contains an entry with these keywords
(exact line-wrapping may differ):
- Topic prefix: `**CI: BC-body Trace/Source citation guard (Guard 1) (DEC-148):**`
- Script path: `scripts/check-bc-citation-symbols.sh`
- Error code: `BC-CITE-001`
- Field types: `**Trace**:`/`**Source**:`
- Files targeted: `bc-*.md`
- Capability keywords: `definition-anchored symbol grep`, `coverage-floor guard`
- Origin: `DEC-148`

(traces to CHANGELOG-per-PR hygiene convention)

---

## Previous Story Intelligence

**S-MUTANTS-SCOPE-GUARDS-1 (Story A, PR #572, delivered 2026-07-04 @ ab78a2d):**

Story A delivered Guards 2 and 3. Key lessons that apply to Guard 1:

1. **Definition-anchored grep is required.** The `fn`-anchored grep regex from Story A
   is directly applicable here:
   ```bash
   grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?((unsafe|const|async|extern[[:space:]]+\"[^\"]*\")[[:space:]]+)*fn[[:space:]]+${symbol}([^[:alnum:]_]|$)"
   ```
   Plain `grep -q "$symbol"` false-greens on import-only occurrences — exactly the DEC-148
   class (Fixture C proves this). Story A Fixture B (import-only false-green proof) is the
   direct precedent.

2. **`||true` on all may-match-zero grep calls.** Under `set -euo pipefail`, grep exit 1
   (zero matches) aborts the script. Every grep returning "no matches = success" MUST be
   guarded. Pattern: `grep ... || true`. (Story A pass-2 C-4 FIX.)

3. **FLOOR scope: script-scope assignment (Story B DEVIATION from Story A, F-B1-01).**
   Story A HARDCODES the integer literal `expected >= 11` directly in its Fixture H assertions
   (lines 433 and 456 of `scripts/check-cargo-mutants-policy-citations.sh`). This works for
   Story A because the floor value `11` is static and unlikely to change. Story B deliberately
   deviates: because FLOOR is calibrated from a large measured count (N ≈ 309 → FLOOR ≈ 231,
   two-tier baseline on 2b09313, F-01; pre-two-tier author census: N=331, FLOOR=248;
   pre-hygiene DEC-154: N=326, FLOOR=244; implementer remeasures at delivery), hardcoding
   the integer in the Fixture G assertion would require a two-site update every time FLOOR
   is recalibrated. Instead, Story B declares
   `FLOOR` as a script-scope variable (NOT `local` inside `run_check`) and writes Fixture G's
   assertion as `grep -qF "expected >= ${FLOOR}"` (variable reference). This assertion is sound
   BECAUSE `FLOOR` is script-scope: the `--self-test` block can read the same `FLOOR` value that
   `run_check` uses, making the floor guard's mutation-catching guarantee sound. This gives
   Story B a SINGLE recalibration touchpoint: update the script-top `FLOOR=N` line and both
   the comparison AND the Fixture G assertion automatically track the new value. `FLOOR` MUST
   appear in both the guard comparison (`[ "$total_citations" -lt "$FLOOR" ]`) AND the message
   interpolation (`expected >= ${FLOOR}`). (Supersedes Story A MED-1-P22 FIX for this story.)

4. **Canonical extraction regex is a single source of truth.** From Story A (F-VA-33-3):
   the Pass 1 extraction grep `` grep -oE '`src/[^`]+`' `` (backtick-only stop — DEC-154 F-B2-02
   form, NOT the superseded single-pass `` `src/[^` ]+` ``) must appear in the script exactly
   once as the authoritative pattern; Pass 2 space-split is shell parameter expansion, not a
   second grep -oE. The `grep -cF 'grep -oE'` count pin = 2 remains correct.

5. **Fixture-count integrity pin with `readonly EXPECTED_FIXTURES`.** Use string `=` (not
   `-eq`) for the comparison per Story A FIND-VA-35-2/F-VA-28-3. Initialize `fixtures_run=0`
   before first fixture; increment ONCE per fixture (multi-probe fixtures still count once);
   post-fixture self-assertions do NOT increment.

6. **`run_check` must return, not exit.** `run_check` calls `return 1` (not `exit 1`) so that
   self-test fixtures can capture both output and return code via
   `set +e; output=$(run_check 2>&1); rc=$?; set -e`. (Story A F-M-3 FIX.)

7. **FALSE-POSITIVE RISK IS LOW.** F1 §6 analyzed the false-positive surface for Guard 1.
   The primary risk (symbol renamed but file kept) is actually a TRUE POSITIVE (citation IS
   stale). The symbol-boundary anchor `([^[:alnum:]_]|$)` in the grep prevents substring
   matches (e.g., `handle_foo` not falsely matched by `handle_foobar`). Guard the boundary.

**DEAD-CITATION-CI cycle (DEC-125-130):**
The DEAD-CITATION-CI cycle established `tests/claude_md_citations.rs` and the BC-X.13
subsystem. Key lesson from DEC-129: a Rust test in the `test` job does NOT have
factory-artifacts access — which is why Guard 1 MUST be a bash script in the `spec-guard`
job (not a Rust integration test). This is option (a) confirmed by F1 §3.

---

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| Guard 1 in spec-guard job ONLY | F1 §3 (CI topology, DEC-129 lesson) | `scripts/check-bc-citation-symbols.sh` runs as spec-guard steps. Do NOT add to `test` job (Rust). Do NOT create a new CI job. `spec-guard` already mounts factory-artifacts — dual-access is built-in. |
| ci-gate.needs unchanged | DEC-096/097 | `spec-guard` is already in `ci-gate.needs`. No branch-protection changes. |
| `--self-test` step BEFORE canonical step | MUTANTS-ARBITER-OFFLINE-SELFTEST precedent | The offline fixture run (`--self-test`) MUST be a separate CI step that executes BEFORE the canonical guard run. If the fixture suite regresses, it fails visibly rather than silently corrupting the canonical run. |
| Definition-anchored grep REQUIRED | F1 §6, DEC-148 (root cause) | Plain `grep -q "$symbol"` false-greens on import-only occurrences. The definition-anchored regex from Story A is the canonical form. A PR using plain grep-q MUST NOT merge. |
| `src/` citations ONLY | F1 §6 (scope recommendation) | Extract only tokens starting with `src/`. The `tests/` citation class is OUT OF SCOPE (tracked as #492-PG-TRACE-TESTS). |
| Zero `src/` changes | F1 §7 regression baseline | No production Rust source files are modified. Script + CI + docs changes only. |
| Mutation gate passes via 0-mutant path | DEC-144 precedent | Guard script and CI config are not in `examine_globs`. No killable mutants in PR diff. Expected ~30-35s on `--in-diff` run. |

---

## Library and Framework Requirements

| Tool | Version | Constraint |
|------|---------|-----------|
| `bash` | `/usr/bin/env bash` | Script uses `set -euo pipefail`. Compatible with ubuntu-latest (GitHub Actions). |
| `grep` | POSIX ERE (`-E`) | Use `-E` (POSIX extended RE) not `-P` (PCRE/GNU-only). Use `[[:space:]]`, `[[:alnum:]]` not `\s`, `\w`. Use `([^[:alnum:]_]\|$)` not `\b` for word boundary (portability to BSD grep / macOS). |
| `awk`, `sed`, `tr` | POSIX | All text processing must use POSIX-portable forms. |
| No new Rust crates | — | Guard 1 is a bash script. No `Cargo.toml` changes. No dev-dependencies added. |
| No new Rust integration test | — | Guard 1 does NOT produce a `tests/*.rs` file. It's a bash script in `spec-guard` (factory-artifacts access needed). |

---

## File Structure Requirements

| File | Create / Modify | Description |
|------|-----------------|-------------|
| `scripts/check-bc-citation-symbols.sh` | CREATE | Guard 1: scan `**Trace**:`/`**Source**:` lines in bc-*.md bodies; two-pass extractor (DEC-154 F-B2-02); two-tier shape guard (F-01): any-extension `^src/[a-zA-Z0-9_/.-]+\.[a-zA-Z0-9]+$`; `.rs` → tier (i) full pipeline; non-`.rs` → tier (ii) file-existence-only (counts toward N); strip-from-first-`(` (EC-CITE-059); 7-branch symbol dispatch with `^[[:space:]]*` anchor on branch (d) (F-B3-02); SCOPE-EMPTY guard; BC-CITE-COVERAGE-FLOOR guard (CANONICAL_MODE only, FLOOR=231); **ten self-test fixtures (A–K, Fixture B gains .snap sub-probes EC-CITE-060)** embedded in `--self-test` block; five post-fixture self-assertions; `BC-CITE-001` error class literal pinned in header comment. |
| `.github/workflows/ci.yml` | MODIFY | spec-guard job: update `name:` to `"Spec Guards (BC counts, numeric-count lint, citation checks, mutants policy scope)"`; append `--self-test` step + canonical step for Guard 1 AFTER the existing `check-cargo-mutants-policy-citations (Guard 2, DEC-150)` step (currently last). No other job changes. No `ci-gate.needs` change. |
| `CHANGELOG.md` | MODIFY | Add `[Unreleased] → ### Added` entry per CHANGELOG-per-PR hygiene. |
| `CLAUDE.md` | MODIFY | Add doc-fallout bullet in AI Agent Notes for `scripts/check-bc-citation-symbols.sh`. |
| `.factory/specs/prd/bc-7-output-render.md` | MODIFY (Task 0) | Citation hygiene: `src/cli/auth.rs::*` → real `src/cli/auth/<file>.rs::fn` paths (EC-CITE-058). |
| `.factory/specs/prd/bc-1-auth-identity.md` | MODIFY (Task 0) | Citation hygiene: `src/cli/auth.rs::*` paths + snapshot path relocation (EC-CITE-058). |
| `.factory/specs/prd/bc-4-assets-cmdb.md` | MODIFY (Task 0) | Citation hygiene: `src/cli/assets.rs:303-321` → real path in `src/cli/assets/` (EC-CITE-058). |
| `.factory/specs/prd/bc-3-issue-write.md` | MODIFY (Task 0) | Continuation-line Trace re-flow at approx L1434-1441 and L1555-1559 (EC-CITE-058 class 16). |

8-file delivery (4 product files + 4 factory hygiene files). Factory hygiene files ship as a
separate factory-artifacts commit (Task 0) before the product PR. Cross-cutting.md / BC-INDEX.md
/ CANONICAL-COUNTS.md are F2 artifacts (authored when PO anchors BC-X.13.004/005/006; DEC-154
deltas committed 125f081); NOT part of this F4 delivery.

---

## Edge Cases

| ID | Description | Expected behavior |
|----|-------------|-------------------|
| EC-001 | Import-only occurrence: citation `src/file.rs::fn` where `fn` appears only in a `use`/`pub use` statement, not as a definition | DEAD: symbol not found in file (Fixture C) |
| EC-002 | Symbol is a constant (UPPER_CASE), Type::method, standalone CamelCase type, `::tests` module-path, or `::tests::testfn`; fn with trailing `()` or `(args...)` stripped before classification | Strip-from-first-`(` applied first (`symbol="${symbol%%\(*}"` — subsumes bare `()` and `(args...)` forms; EC-CITE-042, EC-CITE-059). Then 7-branch dispatch: (a) fn-grep primary; (b) `^tests$` → mod-tests grep (EC-CITE-052); (c) `^tests::[a-z_]…` → mod-tests+fn-grep composition (EC-CITE-056); (d) UPPER_CASE `^[A-Z][A-Z0-9_]*$` → anchored const/static grep `^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?` (anchor prevents mid-line false-greens; group captures `pub(crate)`; EC-CITE-041, EC-CITE-051); (e) CamelCase `^[A-Z][A-Za-z0-9_]*$` (no further `::`) → type-def grep with `struct|enum|type|trait|union` (EC-CITE-054); (f) Type::method (two+ `::`, CamelCase before last `::`) → fn-grep on method + type-presence check (EC-CITE-040). No permissive `grep -q "$symbol"` fallback — that reopens the DEC-148 import-only false-green class. Symbols not matching any branch → DEAD. |
| EC-003 | `§` form citation: `` `src/file.rs § "section"` `` — Pass 1 extracts full token; Pass 2 splits at space → bare path | Token reduced to `src/file.rs` (Pass 2 space-split); file-existence check only; no symbol check (census: 0 §-form tokens on Trace/Source lines in corpus; coverage via Fixture E) |
| EC-004 | `:~NN` form citation: `` `src/file.rs:~120` `` | Token `src/file.rs:~120` extracted; `:~120` stripped → `src/file.rs`; file-existence check only |
| EC-005 | Coverage floor: total `src/` citations < FLOOR (≈231, calibrated floor(0.75 × N), N≈309 two-tier baseline) in CANONICAL_MODE | Exit 1, `BC-CITE-COVERAGE-FLOOR: expected >= ${FLOOR}` (Fixture G; EC-CITE-037) |
| EC-006 | No bc-*.md files found in BC_DIR | Exit 1 immediately with `BC-CITE-001: no bc-*.md files found`; fail-closed (no false-green) |
| EC-007 | Trace/Source line with multiple citations (comma-separated backtick tokens) | Each backtick token extracted independently; all checked; all offenders reported |
| EC-008 | Citation on a non-Trace/Source body line | NOT extracted (Fixture F covers the non-extraction of ordinary body lines) |
| EC-009 | Path-traversal in citation: `` `src/../etc/passwd.rs::fn` `` | Shape guard rejects `..` → `DEAD: malformed citation skipped:` |
| EC-010 | `tests/` citation on Trace/Source line | NOT extracted; `src/`-only scope; `tests/` path does not start with `src/` (EC-CITE-050) |
| EC-011 | Glob citation: `` `src/cli/**/*.rs` `` on a Trace/Source line (e.g., `bc-7-output-render.md:677` BC-7.3.010) | Silently skipped — shape guard detects `*` in path component; no DEAD message emitted; no false positive. Mirrors BC-X.13.002 step-(a) glob-skip precedent. (BC-X.13.005 Step 3, EC-CITE-043) |

---

## Out of Scope

### 1. `tests/` citation hygiene (`#492-PG-TRACE-TESTS`)

BC Trace/Source lines sometimes cite test files:
```
**Trace**: tests/issue_commands.rs:1646-1703
```

Guard 1 does NOT validate `tests/` citations. Reasons:
- F1 §6 explicitly recommends scoping to `src/` for the initial pass
- `tests/` citations use bare line-range form (`:NN-MM`), which drifts as tests are added
  but the FILE never dies — file-existence checks add noise without value
- Symbol-level checks for test function names are the separate gap `#492-PG-TRACE-TESTS`

The `#492-PG-TRACE-TESTS` drift item remains OPEN after Guard 1 delivery.

### 2. BC-INDEX.md scope exclusion (`PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY`)

`BC-INDEX.md` is NOT scanned by Guard 1. Rationale:
- BC-INDEX.md is a derived/generated index, not the primary authorship surface
- The authoritative Trace/Source citations live in `bc-*.md` body files; BC-INDEX.md
  cross-references the same citations in a different format (section headers, not
  `**Trace**:`/`**Source**:` fields)
- Scanning BC-INDEX.md would produce duplicate reports for the same stale citation
  (once from bc-*.md, once from BC-INDEX.md)
- BC-INDEX.md line format differs from the `^\*\*(Trace|Source)\*\*:` anchor pattern
- **Structurally, BC-INDEX.md has ZERO lines matching `^\*\*(Trace|Source)\*\*:`** — the scope
  exclusion is both a deliberate design choice AND a structural fact: zero extractions would
  result regardless. BC-INDEX.md uses section-header and pipe-table format, not Trace/Source
  field format. (Research cross-cutting finding F2, 2026-07-05; BC-X.13.006 structural invariant;
  EC-CITE-049)

The `PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY` process-gap is PARTIALLY addressed:
Guard 1 mechanically enforces citation integrity in bc-*.md files. BC-INDEX.md coverage
remains a manual review concern and OPEN drift item.

### 3. CITATION-FORM-DISCIPLINE

Guard 1 validates that cited `src/` paths and symbols are ALIVE, but does NOT enforce which
citation FORM is used (e.g., whether `:~NN` forms should be migrated to `::symbol` forms per
the #408 convention). The `CITATION-FORM-DISCIPLINE` drift item (enforcing the canonical
symbol-form convention) remains OPEN after Guard 1 delivery.

### 4. EXTRACTION-SET-PIN

Guard 1 validates citation EXISTENCE (file/symbol alive) but not the full SET of expected
citations. A deletion of an entire citation (removing the `**Trace**:` line entirely rather
than leaving a stale one) is not caught. This mirrors the Story A EXTRACTION-SET-PIN
residual. Mitigated by fresh-context adversarial review; accepted terminal residual.

### 5. SCOPE-EXAMINE-GLOBS-CROSS-SET-EDGE, BACKTICK-RESERVATION-CONVENTION

These are Story A F4 residuals (process gaps from the delivered Guard 2 script). They are
unrelated to Guard 1 and remain OPEN under their existing tracking. Guard 1 is OUT OF SCOPE
for addressing them.

### 6. Remaining v2 deferrals (BC-X.13.005)

Guard 1 v1 uses the full 7-branch shape-split (BC-X.13.005 Step 5, DEC-154 Option A):
(a) fn-grep; (b) `::tests` mod-grep; (c) `::tests::testfn` composition; (d) UPPER_CASE
const/static; (e) standalone CamelCase type-def; (f) Type::method. These 7 branches cover
all symbol classes found in the corpus. Symbols that fall through all 7 are classified DEAD.

**v2 deferrals (explicitly out of scope per BC-X.13.005 v2-deferrals section, post-DEC-154)**:
- ~~Standalone CamelCase type citations~~ — **NOW COVERED by branch (e)** (DEC-154 Option A).
- ~~Module-path citations (`::tests`)~~ — **NOW COVERED by branches (b) and (c)** (DEC-154).
- **Macro citations** (`macro_rules! sym`): fall through to DEAD in v1 (no grep primitive
  added; `macro_rules!` definitions use different syntax than `fn` or `struct`). LOW impact:
  no macro citations found on Trace/Source lines in the current corpus.
- **Type::method correlation reporting**: when both sub-checks in branch (f) fail, the error
  reports the method as DEAD but does not indicate whether the Type name itself is still valid.
  Correlation reporting deferred to v2.
- **Continuation-line Trace/Source stitching** (class 16 — 5 tokens on bc-3-issue-write.md):
  multi-line Trace/Source fields are not stitched by the guard. Pre-AC-001 hygiene (Task 0)
  re-flows the 5 continuation-line tokens to single-line form, removing this class entirely
  without grammar work. Any new multi-line Trace/Source blocks added after delivery would
  be silently missed — convention: keep Trace/Source fields on a single line.

These are VERY LOW residual risks after DEC-154. The macro and Type::method-correlation
deferrals have zero current corpus impact.

**Symbol validation for non-`.rs` files (permanently out of scope — tier (ii) is existence-only,
F-01):** Tier (ii) handles non-`.rs` `src/` tokens (e.g., `.snap`, `.json`, `.toml`) with
file-existence-only validation. Step 5 symbol check is permanently NOT run for tier (ii) tokens
— the symbol grammar (`fn`/`mod`/`struct`/`const` grep anchors) is Rust-specific and does not
apply to non-Rust files. Any `::symbol` suffix on a non-`.rs` citation is nonsensical; the
guard ignores it at Step 3b tier assignment. This is a design constraint, not a v2 deferral.

### 7. Companion-lint follow-up: check-bc-single-line-trace.sh (F-B3-06)

The Task 0 hygiene work (EC-CITE-058) establishes the convention that `**Trace**:` and `**Source**:` fields must be on a single line; a future F5 follow-up story candidate is `check-bc-single-line-trace.sh` — a mechanical companion lint that enforces the single-line Trace/Source convention and flags any multi-line continuation blocks before they silently drop tokens under the two-pass extractor.

### 8. Non-backtick-quoted citations

Guard 1 extracts only BACKTICK-QUOTED `src/` tokens (Pass 1: `` grep -oE '`src/[^`]+`' ``). A
Trace/Source field containing an unquoted `src/file.rs:~120` (without surrounding backticks)
is NOT extracted and therefore NOT validated. Per the #408 convention, new citations should
always be backtick-quoted; unquoted forms are legacy. Recommend a separate sweep to
backtick-quote any remaining unquoted forms, but NOT in this story.

---

## Maintenance Touchpoints

- **When a Seam extraction moves a function:** Guard 1 will catch the stale BC citation on the
  next PR that touches bc-*.md OR on any PR where Guard 1 runs (all PRs via spec-guard).
  Action: update the `**Trace**:` / `**Source**:` field in the affected BC body.
- **When FLOOR becomes stale:** If BCs are refactored and the citation count drops legitimately,
  rerun the script in canonical mode, record new N, and update the script-scope `FLOOR=N`
  assignment at the TOP of the script (the single recalibration touchpoint — NOT `local` inside
  `run_check`). The floor message includes `"Update FLOOR when citations are intentionally
  removed"` as a reminder. Update in the SAME commit as the BC edit. Current baseline:
  N ≈ 309, FLOOR ≈ 231 (two-tier baseline on 2b09313, F-01: 304 .rs + 5 .snap; pre-two-tier
  post-Task-0-hygiene census: N=331, FLOOR=248; pre-hygiene: N=326, FLOOR=244;
  implementer remeasures at delivery).
- **BC-INDEX.md stale citations (out-of-scope residual):** Run manual `grep -r
  'src/cli/issue/create.rs\|src/cli/issue/helpers.rs' .factory/specs/prd/BC-INDEX.md`
  after any Seam extraction to catch BC-INDEX.md drift not covered by Guard 1.
- **Job name drift:** The spec-guard job `name:` field must be updated when new guards are
  added. The target state after Guard 1 delivery is
  `"Spec Guards (BC counts, numeric-count lint, citation checks, mutants policy scope)"`.
  Future guards should insert their segment before `"mutants policy scope"` and update the
  `name:` in the same PR as the new step (F1 §5 pattern).
- **FLOOR calibration at delivery:** The implementer MUST run `scripts/check-bc-citation-symbols.sh`
  in canonical mode on develop HEAD, record N, and update the script-scope `FLOOR=N` assignment
  at the TOP of the script (single recalibration touchpoint — NOT `local` inside `run_check`)
  before submitting the PR. Current calibration (two-tier baseline on 2b09313, F-01):
  N ≈ 309, FLOOR ≈ 231 (304 .rs + 5 .snap; pre-two-tier post-Task-0-hygiene census: N=331,
  FLOOR=248; pre-hygiene: N=326, FLOOR=244; implementer remeasures at delivery). Document
  the measured N (expected ≈ 309, FLOOR ≈ 231 at two-tier baseline) in the CHANGELOG entry.
