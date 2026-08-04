---
document_type: story
level: ops
story_id: "S-MUTANTS-EXAMINE-GLOBS-1"
epic_id: null
# epic_id: null — no named epic or bundle exists for this standalone CI-infrastructure story. Added for template compliance 2026-08-04.
title: "Restore mutation scope: add edit.rs + jsm_create.rs to examine_globs + fix policy-doc citations (DEC-149)"
wave: feature-followup
status: draft
intent: ci-hardening
feature_type: infrastructure
mode: feature
scope: small
severity: MEDIUM
trivial_scope: false
points: 2
priority: P2
tdd_mode: strict
estimated_effort: xsmall
estimated_days: 0.5
target_module: ci-infrastructure
subsystems: []
depends_on: []
blocks: []
behavioral_contracts: []
# BC status: policy-doc-only (no BC). Governing artifact: docs/specs/cargo-mutants-policy.md §Scope.
# No product behavioral contract governs CI-configuration scope. The S-7.01 Spec-First Gate
# does not apply to CI-infrastructure stories where the governing artifact is an internal
# policy doc (not a product contract). Status=draft is correct for a non-retroactive story
# with empty BCs; do NOT set to ready until a product-owner explicitly authors BCs.
# Pattern: S-TESTTOOL-1 (drift-item MAINT-MUTANTS-GLOBS-01, status:draft, bcs:[]).
bcs: []
verification_properties: []
holdout_anchors: []
nfr_anchors: []
adr_refs: []
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: "docs/specs/cargo-mutants-policy.md §Scope"
producer: story-writer
timestamp: "2026-07-02T00:00:00"
phase: 3
cycle: null
# cycle: null — no named cycle; standalone F3 story in feature-followup wave. Added for template compliance 2026-08-04.
inputs:
  - "docs/specs/cargo-mutants-policy.md"
input-hash: "9c370da"
traces_to: "docs/specs/cargo-mutants-policy.md"
implementation_strategy: tdd
module_criticality: LOW
acceptance_criteria_count: 6
assumption_validations: []
risk_mitigations: []
created: "2026-07-02"
version: "1.3"
last_updated: "2026-08-04"
breaking_change: false
retroactive: false
origin: >
  DEC-149 (CITATION-DEBT-PRODUCT-FILES cycle; surfaced by adversarial gate on PR #568,
  2026-07-02). ADR-0012 Seam A/B module extraction (PR #558 Seam B / PR #556 Seam A)
  relocated handle_edit, handle_edit_bulk_labels, handle_edit_bulk_fields (→ edit.rs) and
  handle_jsm_create (→ jsm_create.rs) from create.rs, but .cargo/mutants.toml::examine_globs
  was not updated. These behavior-dense surfaces have been outside mutation coverage since
  Seam A/B. F1 analysis: .factory/phase-f1-delta-analysis/mutants-examine-globs-2026-07-02-delta.md.
  Intent decision: Option (a) — restore scope.
changelog:
  - "1.3 (2026-08-04): Template conformance pass + anchor migration. Added missing frontmatter
    keys (level, epic_id, producer, timestamp, phase, cycle, inputs, input-hash, traces_to) for
    template compliance; epic_id and cycle set to null (standalone CI-infrastructure story with no
    named epic or bundle). Added missing Purity Classification section (N/A — all changes are
    CI config or documentation, no src/ Rust module created or modified). Renamed section heading
    'Library and Framework Requirements' to 'Library & Framework Requirements' (& vs and) to
    match template. Migrated 6 stale ci.yml ~:259 line-number citations to anchor form
    ci.yml :: mutants / Run mutation tests on PR diff; changelog entry for v1.1 ci.yml:195
    annotated as historical (line number at v1.1 authoring time; file has since changed)."
  - "1.0 (2026-07-02): Initial F3 story — MUTANTS-EXAMINE-GLOBS-STALE-AFTER-SEAM-B (DEC-149).
    Option (a): add edit.rs (99 mutants) + jsm_create.rs (9 mutants) to examine_globs; fix
    policy-doc function-location citations (SWEEP-WHOLE-TOUCHED-FILE); fix cicd-setup.md
    false edit.rs coverage claim; CLAUDE.md verify (F1 confirms no change needed). 6 ACs.
    Policy-doc-only governance. Story count: 99 → 100."
  - "1.2 (2026-07-02): consistency-validator residuals: Task 5 cicd-setup.md check repointed to
    state-manager post-merge; AC-001 mutant counts marked drift-tolerant (~99, ~9, ~108, ~594,
    ~702); SP breakdown cicd-setup.md line annotated DEFERRED; STORY-INDEX manifest row description
    updated to reflect deferral."
  - "1.1 (2026-07-02): F5 round-1/round-2 amendments (orchestrator-authorized): (1) ci.yml
    comment fix authorized — F5 perimeter lens finding F-1 MED required repointing the stale
    ci.yml:195 [historical line number at time of v1.1 authoring; file has since changed] scope comment to policy doc; ci.yml change limited to one comment-line indirection,
    no job/step/logic changes; CHANGELOG.md [Unreleased] entry also authorized. (2) AC-003
    deferral documented — .factory/cicd-setup.md lives on factory-artifacts branch; applied
    by state-manager in cycle-close factory-artifacts commit after PR merge. (3) files_modified
    updated to actual delivered set. (4) AC-005 and Architecture Compliance Rules row 3 amended
    to reflect authorized ci.yml comment fix. Counts marked drift-tolerant (~) where applicable."
lineage:
  - S-346             # cargo-mutants CI job + whitelist policy (PR #373 @ d909e65, 2026-05-16)
  - S-TESTTOOL-1      # last examine_globs expansion: added issues.rs + cache.rs (PR #533, 2026-06-18)
  - S-MUTATION-CI-TIMEOUT-1  # mutation gate hardening: --timeout 240, false-green guards (PR #567, 2026-06-28)
drift_items:
  - MUTANTS-EXAMINE-GLOBS-STALE-AFTER-SEAM-B
files_modified:
  - .cargo/mutants.toml                  # add edit.rs + jsm_create.rs to examine_globs; update comment
  - docs/specs/cargo-mutants-policy.md   # repoint handle_edit_bulk_labels/fields → edit.rs, handle_jsm_create → jsm_create.rs; update create.rs entry to parse_field_kv only; add changelog entry; SWEEP-WHOLE-TOUCHED-FILE
  - .github/workflows/ci.yml             # comment-only: repoint stale scope comment in ci.yml :: mutants / "Run mutation tests on PR diff" to policy doc §Scope (authorized by orchestrator, F5 round-1 F-1 MED finding; no job/step/logic changes)
  - CHANGELOG.md                         # [Unreleased] entry per CHANGELOG-per-PR hygiene (authorized)
# deferred_files: .factory/cicd-setup.md — EXPLICITLY DEFERRED (see AC-003). Lives on
# factory-artifacts branch; fix applied by state-manager in cycle-close commit after PR merge.
---

# S-MUTANTS-EXAMINE-GLOBS-1 — Restore Mutation Scope: Add edit.rs + jsm_create.rs to examine_globs

**Status:** DRAFT — F3 complete (2026-07-02); awaiting F4 dispatch.

**Origin:** DEC-149 (CITATION-DEBT-PRODUCT-FILES cycle). Adversarial gate on PR #568 surfaced
the drift item MUTANTS-EXAMINE-GLOBS-STALE-AFTER-SEAM-B. ADR-0012 Seam A/B module extraction
(PRs #556/#558) relocated `handle_edit`, `handle_edit_bulk_labels`, `handle_edit_bulk_fields`
(→ `src/cli/issue/edit.rs`) and `handle_jsm_create` (→ `src/cli/issue/jsm_create.rs`) from
`create.rs`, but `.cargo/mutants.toml::examine_globs` was not updated. These behavior-dense
surfaces — complex conditional logic covering bulk routing forks, the C-1 guard, the label
endpoint fork, and JSM dispatch — have been outside mutation coverage since the split.

**F1 delta analysis:** `.factory/phase-f1-delta-analysis/mutants-examine-globs-2026-07-02-delta.md`
**Governing spec:** `docs/specs/cargo-mutants-policy.md §Scope`

---

## Governance Note

**Policy-doc-only governance. No BC authored.** The governing artifact is
`docs/specs/cargo-mutants-policy.md`. The `bcs: []` field is intentional. The Spec-First Gate
(S-7.01) does not apply: no behavioral contract governs CI-configuration scope selection. This
pattern follows S-MUTATION-CI-TIMEOUT-1 (DEC-144, PR #567) and S-TESTTOOL-1 (MAINT-MUTANTS-GLOBS-01,
PR #533), both policy-doc-only CI-infrastructure stories with empty `bcs:`.

**Scope classification:** CI-config + doc governance only. No production `src/` change. No test
change. The mutation gate on the fix PR itself passes via the 0-mutant path (config/doc diff
generates no code mutants — DEC-144 precedent). Worst-case CI cost increase: +58 min on a
full-file `edit.rs` PR; +5 min on any `jsm_create.rs` PR — both within the 90-minute budget.

---

## Narrative

As a contributor to the `jr` CLI,
I want `edit.rs` and `jsm_create.rs` added to `.cargo/mutants.toml::examine_globs` and the
associated policy-doc citation drift corrected (cicd-setup.md deferred to state-manager post-merge),
so that PRs touching these behavior-dense surfaces face mutation testing consistent with the
original S-346 intent, and governance documents accurately describe the actual mutation scope.

---

## Traceability

| Source | Link |
|--------|------|
| Drift item origin | DEC-149 (`MUTANTS-EXAMINE-GLOBS-STALE-AFTER-SEAM-B`) |
| F1 delta analysis | `.factory/phase-f1-delta-analysis/mutants-examine-globs-2026-07-02-delta.md` |
| Root cause | ADR-0012 Seam A/B split (PRs #556/#558) — behavior relocated, examine_globs not updated |
| Governing policy doc | `docs/specs/cargo-mutants-policy.md §Scope` |
| Preceding scope story | S-TESTTOOL-1 (MAINT-MUTANTS-GLOBS-01, PR #533, 2026-06-18) |
| Preceding gate story | S-MUTATION-CI-TIMEOUT-1 (DEC-144, PR #567, 2026-06-28) |
| Original mutation gate | S-346 (PR #373, 2026-05-16) |

---

## Behavioral Contracts

No BC-S.SS.NNN was authored for this cycle. The governing artifact is
`docs/specs/cargo-mutants-policy.md`. Each AC traces to the relevant policy doc section rather
than a BC clause.

| Policy Section | Topic |
|---------------|-------|
| §Scope | examine_globs list; rationale for each scoped file; function-location table |
| §CI Integration | --in-diff + examine_globs double-gate; 0-mutant legitimate path; base-ref-drift guard |
| §Absolute Timeout Ceiling | 90-minute wall-clock budget; split-PR signal at 200+ mutants |

---

## Token Budget Estimate

| Context component | Estimated tokens |
|---|---|
| Story spec (this file) | ~3,500 |
| `.cargo/mutants.toml` (full file) | ~300 |
| `docs/specs/cargo-mutants-policy.md` (Scope + CI Integration + changelog sections) | ~3,000 |
| `.github/workflows/ci.yml` (ci.yml :: mutants / "Run mutation tests on PR diff" area; comment-only change) | ~500 |
| `CHANGELOG.md` ([Unreleased] section) | ~300 |
| F1 delta analysis doc (relevant sections) | ~4,000 |
| **Total** | **~11,600** |

Well within 20% agent context window budget. No splitting required.

---

## Tasks

1. Read `.cargo/mutants.toml`. Add `"src/cli/issue/edit.rs"` and `"src/cli/issue/jsm_create.rs"`
   to the `examine_globs` array. Update the inline comment on line 8 (currently "adf, bulk/create,
   issues, cache, and jsm modules") to reflect "adf, bulk/create/edit/jsm_create, issues, cache,
   and jsm modules" (or equivalent phrasing such as "issue-write cluster").
2. Read `docs/specs/cargo-mutants-policy.md`. Apply SWEEP-WHOLE-TOUCHED-FILE-NOT-JUST-TARGET-LINE:
   a. Near line 19 (primary): correct the `src/cli/issue/create.rs` entry — update function list
      to `parse_field_kv` only (drop relocated functions). Add rows for `src/cli/issue/edit.rs`
      (`handle_edit`, `handle_edit_bulk_labels`, `handle_edit_bulk_fields`) and
      `src/cli/issue/jsm_create.rs` (`handle_jsm_create`).
   b. Scan every other line for same-class stale references: any citation of `create.rs` for
      `handle_edit_bulk_labels`, `handle_edit_bulk_fields`, or `handle_jsm_create` must be
      corrected. F1 analysis confirms none found beyond line 19 — re-verify.
   c. Add changelog entry: date 2026-07-02, scope widening (+edit.rs 99 mutants +jsm_create.rs
      9 mutants), Seam A/B origin, DEC-149 cycle reference.
3. (**DEFERRED — state-manager factory-artifacts commit post-PR-merge**) Read `.factory/cicd-setup.md`.
   Locate scope description near line 76. Remove false pre-existing claim that `src/cli/issue/edit.rs`
   is in scope (it was in prose but NOT in mutants.toml). After the mutants.toml change in Task 1,
   add both `edit.rs` and `jsm_create.rs` to the scope description to match the actual post-change
   config. (This task is NOT part of the delivering PR — cicd-setup.md lives on factory-artifacts
   branch. See AC-003 for full deferral details.)
3a. Read `.github/workflows/ci.yml`. Locate the scope comment in ci.yml :: mutants / "Run mutation tests on PR diff". Repoint it to
    `docs/specs/cargo-mutants-policy.md §Scope` (authorized by F5 round-1 finding F-1 MED). This
    IS part of the delivering PR. Change is limited to the single comment line only.
4. Read `CLAUDE.md`. Verify the mutation command in §Build & Test and any examine_globs references.
   The F1 analysis confirms CLAUDE.md has no mutation-scope stale citations. Make no change if
   confirmed; if any stale citation is found, correct it in the same commit.
5. Self-verify: read back all modified files; confirm examine_globs in mutants.toml matches the
   policy doc §Scope table. cicd-setup.md consistency is verified by state-manager post-merge
   (AC-003 deferral — that check is not possible at PR commit time).

---

## Previous Story Intelligence

**S-MUTATION-CI-TIMEOUT-1 (DEC-144, PR #567, 2026-06-28):**
Established the HARD-REQUIRED mutation gate with absolute `--timeout 240` ceiling and 5 false-green
guards. This story does NOT change the CI job, the timeout, or any gate guards — it extends
`examine_globs` scope within the existing gate structure. The gate is already wired and working.

**S-TESTTOOL-1 (MAINT-MUTANTS-GLOBS-01, PR #533, 2026-06-18):**
Last examine_globs expansion — added `src/api/jira/issues.rs` and `src/cache.rs`. This story
follows the same scope-extension pattern. Key difference: S-TESTTOOL-1 also included a test
change (keyring-gate annotation); this story makes NO test changes.

**MUTANTS-FIRST-SCOPED-PR-CALIBRATION watch-item:**
DEC-144 left a watch-item: first code-change PR touching an examine_globs file exercising the
non-zero-mutant `--timeout 240` path. PR #568 (DEC-149) confirmed the 0-mutant path works
correctly (rustdoc-only diff → ~34s, PASS). After this story merges, the NEXT code-change PR
modifying `edit.rs` becomes the first calibration of the non-zero-mutant code path. This
watch-item is carried forward in AC-006.

---

## Architecture Compliance Rules

| Rule | Source | Constraint |
|------|--------|-----------|
| ci-gate.needs wiring unchanged | DEC-096/DEC-097 | No change to ci-gate composition. The `mutants` job is already in `ci-gate.needs` per S-MUTATION-CI-TIMEOUT-1. Only examine_globs scope changes. |
| `--in-diff` + examine_globs double-gate | `docs/specs/cargo-mutants-policy.md §CI Integration` | The `--in-diff` flag restricts mutation to changed lines; examine_globs restricts the file set. Together they prevent the global 702-mutant scope from materializing on any individual PR. Zero cost on PRs that do not touch edit.rs or jsm_create.rs. |
| `.github/workflows/ci.yml` change is comment-line only | `.cargo/mutants.toml` / F5 round-1 (F-1 MED, authorized 2026-07-02) | Timeout ceiling set via `cargo mutants --timeout 240` in `ci.yml` (unchanged). The one authorized ci.yml change is repointing the stale scope comment in ci.yml :: mutants / "Run mutation tests on PR diff" to `docs/specs/cargo-mutants-policy.md §Scope`. No job, step, matrix, or logic changes are permitted. |
| SWEEP-WHOLE-TOUCHED-FILE-NOT-JUST-TARGET-LINE | DEC-149 (lesson codified) | When correcting citations in `docs/specs/cargo-mutants-policy.md`, scan the ENTIRE file for same-class stale function-location references, not only the identified line 19. F1 analysis found none beyond line 19, but implementer must re-verify at commit time. |
| `tests/ci_gate_completeness.rs` unchanged | S-MUTATION-CI-TIMEOUT-1 | The exact 8-job set in `test_ci_gate_needs_exactly_the_required_jobs` remains valid. examine_globs changes do not affect ci-gate composition or ci_gate_completeness.rs assertions. |

---

## Library & Framework Requirements

| Tool | Version | Constraint |
|------|---------|-----------|
| cargo-mutants | @27 (pinned in ci.yml) | No version change. Scope widening does not require a version bump. @27 exit-code semantics, JSON schema, and `--timeout` flag availability are unaffected. |

No new crate dependencies. No Rust source changes. No Cargo.toml changes.

---

## File Structure Requirements

| File | Create / Modify | Description |
|------|-----------------|-------------|
| `.cargo/mutants.toml` | MODIFY | Add `"src/cli/issue/edit.rs"` and `"src/cli/issue/jsm_create.rs"` to `examine_globs`. Update line 8 comment. |
| `docs/specs/cargo-mutants-policy.md` | MODIFY | Line ~19: repoint function-location entries. SWEEP-WHOLE-FILE for same-class stale refs. Add changelog entry. |
| `.github/workflows/ci.yml` | MODIFY (comment-line only) | Repoint stale scope comment in ci.yml :: mutants / "Run mutation tests on PR diff" to `docs/specs/cargo-mutants-policy.md §Scope`. No job/step/logic changes. Authorized: F5 round-1 F-1 MED. |
| `CHANGELOG.md` | MODIFY | Add [Unreleased] entry: examine_globs scope widened (+edit.rs 99 mutants, +jsm_create.rs 9 mutants). Per CHANGELOG-per-PR hygiene. |
| `CLAUDE.md` | VERIFY (no change expected) | Read mutation-scope citations; F1 confirmed no stale refs. No change if confirmed. |
| `.factory/cicd-setup.md` | **DEFERRED** (factory-artifacts branch) | state-manager cycle-close commit post-PR-merge. Line ~76: add edit.rs + jsm_create.rs; remove false pre-Seam-B claim. Line ~45: scope list update. Line ~202: timeout-minutes 60→90 (separate drift item). |

---

## Acceptance Criteria

All ACs trace to `docs/specs/cargo-mutants-policy.md` sections (no BC-S.SS.NNN exists for this story).

---

### AC-001 — `.cargo/mutants.toml::examine_globs` includes `edit.rs` and `jsm_create.rs`; `create.rs` retained
(traces to `docs/specs/cargo-mutants-policy.md §Scope` — scope rationale for issue-write cluster)

After the change, `.cargo/mutants.toml::examine_globs` contains ALL of:
```toml
"src/cli/issue/create.rs",
"src/cli/issue/edit.rs",
"src/cli/issue/jsm_create.rs",
```
in the same array. `create.rs` is NOT removed — it retains coverage for `parse_field_kv` (the
remaining non-trivial function in the thin dispatcher, 10 mutants). The policy-doc §Scope table
matches the final examine_globs list.

Measured mutant counts (F1 analysis, 2026-07-02): `edit.rs` = ~99 mutants; `jsm_create.rs` = ~9 mutants.
New total scope: ~594 + ~108 = ~702 mutants (+18% over ~594 baseline). Per-PR cost is bounded
by `--in-diff`; worst-case full-edit.rs PR ≈ 58 min, within the 90-min budget.

---

### AC-002 — `docs/specs/cargo-mutants-policy.md` function-location citations corrected (SWEEP-WHOLE-TOUCHED-FILE)
(traces to `docs/specs/cargo-mutants-policy.md §Scope` — policy doc is governance source of truth)

The policy doc §Scope function-location table (near line 19) is corrected so that:
- `src/cli/issue/create.rs` entry lists: `parse_field_kv` (only; `handle_create` dispatcher if listed)
- `src/cli/issue/edit.rs` entry (new): `handle_edit`, `handle_edit_bulk_labels`, `handle_edit_bulk_fields`
- `src/cli/issue/jsm_create.rs` entry (new): `handle_jsm_create`

A SWEEP-WHOLE-TOUCHED-FILE pass confirms no other lines in `cargo-mutants-policy.md` misattribute
`handle_edit_bulk_labels`, `handle_edit_bulk_fields`, or `handle_jsm_create` to `create.rs`.

A changelog entry is added to the policy doc recording: date 2026-07-02, scope widening
(+edit.rs ~99 mutants, +jsm_create.rs ~9 mutants), Seam A/B root cause, DEC-149 cycle reference.

---

### AC-003 — `.factory/cicd-setup.md` false coverage claim corrected — EXPLICITLY DEFERRED
(traces to `docs/specs/cargo-mutants-policy.md §CI Integration` — cicd-setup.md must match actual config)

**STATUS: EXPLICITLY DEFERRED — factory-artifacts branch; state-manager applies post-PR-merge.**

`.factory/cicd-setup.md` lives on the factory-artifacts branch, not on the feature branch delivering
this story. The corrections CANNOT be applied in the same PR as the mutants.toml / policy doc changes.
State-manager applies the fix in the cycle-close factory-artifacts commit immediately after PR merge.

**Deferred fix details** (for state-manager cycle-close commit reference):
- Line ~76: remove the false pre-existing claim that `src/cli/issue/edit.rs` is in scope (it was
  in the prose but NOT in mutants.toml before the fix); after the mutants.toml change, add both
  `edit.rs` AND `jsm_create.rs` to the scope description so prose matches the actual post-change config
- Line ~45: update scope list to match the new examine_globs set (all 7 files including edit.rs +
  jsm_create.rs)
- Line ~202: `timeout-minutes: 60` → `90` is a SEPARATE pre-existing drift item unrelated to the
  Seam A/B examine_globs fix; state-manager should flag this independently if it addresses it in
  the cycle-close commit, not conflate it with this AC

Verification criterion (for state-manager): after the factory-artifacts commit, the scope description
in cicd-setup.md must list all files currently in examine_globs in `.cargo/mutants.toml`.

---

### AC-004 — CLAUDE.md checked; no stale mutation-scope citations found; no change made
(traces to `docs/specs/cargo-mutants-policy.md §CI Integration` — governance consistency; DEC-149 citation-debt lesson)

The mutation command in CLAUDE.md §Build & Test and any examine_globs references in CLAUDE.md
are read and verified. Per the F1 delta analysis (§CLAUDE.md, 2026-07-02): CLAUDE.md already
correctly locates `handle_edit`/`handle_edit_bulk_*` in `edit.rs` and `handle_jsm_create` in
`jsm_create.rs`. No mutation-scope stale citation exists in CLAUDE.md.

Expected outcome: no CLAUDE.md change is made. If any stale mutation-scope citation IS found
during implementation, it must be corrected in the same commit as the other changes.

---

### AC-005 — No production `src/` change; no test change; mutation gate on fix PR passes via 0-mutant path
(traces to `docs/specs/cargo-mutants-policy.md §CI Integration` — config/doc diff generates no code mutants; DEC-144 precedent)

The delivering PR contains changes ONLY to:
- `.cargo/mutants.toml` (config — examine_globs scope extension)
- `docs/specs/cargo-mutants-policy.md` (documentation — function-location corrections + changelog entry)
- `.github/workflows/ci.yml` (comment-line only — repoint stale scope comment in ci.yml :: mutants / "Run mutation tests on PR diff" to policy doc;
  authorized by orchestrator 2026-07-02 per F5 round-1 perimeter-lens finding F-1 MED; no job/step/logic changes)
- `CHANGELOG.md` ([Unreleased] entry per CHANGELOG-per-PR hygiene; authorized)
- Optionally `CLAUDE.md` (documentation, only if AC-004 finds stale refs)

Note: `.factory/cicd-setup.md` is NOT in this PR — it is DEFERRED to state-manager factory-artifacts
commit post-PR-merge (see AC-003).

No `src/` Rust source file is modified. No `tests/` file is modified. No `Cargo.toml` is modified.
The mutation gate on the fix PR passes via the 0-mutant path (config/doc diff generates no killable
mutants; `--in-diff` scope produces an empty examine_globs intersection with changed lines). This
matches DEC-144 precedent (PR #567: CI-config-only diff → 0-mutant path → PASS in ~32s).

---

### AC-006 — MUTANTS-FIRST-SCOPED-PR-CALIBRATION watch-item carried; interaction with MUTANTS-SHARDING-PATH-B documented
(traces to `docs/specs/cargo-mutants-policy.md §CI Integration` — calibration status; path-B interaction)

The MUTANTS-FIRST-SCOPED-PR-CALIBRATION watch-item (from DEC-144; 0-mutant path CONFIRMED-GOOD
on PR #568 at ~34s) is documented in this story and carried forward in the delivering PR description:
- 0-mutant path: CONFIRMED-GOOD (PR #568, ~34s)
- Code-mutant non-zero path: PENDING — will be exercised on the next code-change PR touching `edit.rs`
- Watch: if `timeout` outcomes appear in `Check kill rate` on that PR, bump `--timeout` per
  `docs/specs/cargo-mutants-policy.md §Absolute Timeout Ceiling`

MUTANTS-SHARDING-PATH-B interaction note: adding ~108 mutants (edit.rs + jsm_create.rs) increases
total scope from ~594 to ~702 mutants (+18%). This does NOT accelerate the need for Path B — the
90-minute budget constraint is driven by `adf.rs` alone (351 mutants, ~3.4 hours for a full-file
PR). Path B trigger condition is unchanged: when a PR produces a `timeout` outcome or the 90-minute
wall-clock budget is exceeded in practice. No Path B story needs to be opened in parallel.

---

## Regression Risk

| Area | Risk | Rationale |
|------|------|-----------|
| PRs not touching edit.rs/jsm_create.rs | NONE | `--in-diff` bounds cost to changed lines; zero new mutants on unrelated PRs |
| First code-change PR to edit.rs post-merge | LOW-MEDIUM | May surface surviving mutants requiring `#[mutants::skip]` with justification or targeted test strengthening; this is expected and appropriate — the desired behavior of the gate |
| 90-minute CI budget | LOW | Worst-case full-edit.rs PR (~99 mutants, ~58 min) fits within budget; split-PR signal fires if combined with large adf.rs change (~351+~99=~450 mutants, ~263 min) |
| ci-gate false-block | NONE | No changes to ci-gate logic, timeout, or false-green guards |
| Policy doc / config divergence | NONE | AC-001 + AC-002 are paired; self-verify step 5 confirms consistency before commit |

---

## Out of Scope (explicit)

**No production source changes.** This story modifies only `.cargo/mutants.toml` (CI config),
`docs/specs/cargo-mutants-policy.md` (policy doc), `.github/workflows/ci.yml` (one comment-line
only, authorized F5 F-1 MED), and `CHANGELOG.md` ([Unreleased] entry). The `.factory/cicd-setup.md`
fix is deferred to state-manager factory-artifacts commit post-PR-merge (see AC-003).
No `src/` module, no API method, no CLI flag, no test file, no Cargo.toml, and no observable
user-facing behavior is changed.

**No test changes required.** The mutation gate is tested by `tests/ci_gate_completeness.rs`
(unchanged). Scope changes to examine_globs do not require new tests.

**Surviving mutants in edit.rs/jsm_create.rs.** When the first code-change PR modifying `edit.rs`
runs the mutation gate, it may surface surviving mutants. Closing gaps (via targeted tests or
`#[mutants::skip]` with justification per policy doc) is the responsibility of the delivering PR
for that future feature story — not in scope here.

**Historical citation files (LOW, not changed).** `.factory/research/e2e-priority-assign-worklog.md`,
`.factory/spec-changelog.md`, `docs/superpowers/plans/` entries, and `docs/specs/adf-recursion-depth.md`
contain historical pre-split citations to `create.rs::handle_edit_bulk_fields` and similar symbols.
Per SWEEP-WHOLE-TOUCHED-FILE-NOT-JUST-TARGET-LINE, these historical files require no update —
they document past state; updating them would create anachronistic rewrites of historical records.

---

## Architecture Mapping

| Component | Module | Pure/Effectful | Justification |
|-----------|--------|---------------|---------------|
| `examine_globs` scope config | `.cargo/mutants.toml` | N/A (config) | Adds edit.rs and jsm_create.rs to the mutation file scope; no executable code change |
| Policy doc §Scope table | `docs/specs/cargo-mutants-policy.md` | N/A (documentation) | Corrects function-location entries; adds changelog entry; SWEEP-WHOLE-TOUCHED-FILE |
| ci.yml scope comment | `.github/workflows/ci.yml` | N/A (CI config) | Repoints stale scope comment in ci.yml :: mutants / "Run mutation tests on PR diff" to policy doc §Scope (one comment-line only; F5 F-1 MED authorized) |
| Release log | `CHANGELOG.md` | N/A (documentation) | [Unreleased] entry: examine_globs scope widened (+edit.rs + jsm_create.rs) |
| Scope description | `.factory/cicd-setup.md` | N/A (factory artifact, **DEFERRED**) | state-manager cycle-close factory-artifacts commit post-PR-merge; see AC-003 |

**Subsystem anchor justification:** No ARCH-INDEX subsystem applies — all modified files are CI
infrastructure (`.cargo/mutants.toml`), documentation (`docs/specs/`), or factory artifacts
(`.factory/`). No cross-subsystem interaction in these changes.

**Dependency anchor justification:** `depends_on: []` — all prerequisite mutation gate infrastructure
(S-346, S-MUTATION-CI-TIMEOUT-1, S-TESTTOOL-1) is already merged. `blocks: []` — no story
depends on this scope change.

---

## Edge Cases

| ID | Source | Description | Expected Behavior | AC |
|----|--------|-------------|-------------------|----|
| EC-001 | F1 delta §1.2 | PR touches only `create.rs` (thin dispatcher, 10 mutants) | Gate runs on create.rs mutants only; edit.rs/jsm_create.rs not in diff → 0 additional mutants from new entries | AC-001 |
| EC-002 | F1 delta §3 | PR touches only `jsm_create.rs` (~9 mutants max) | Gate runs ≤~9 mutants; ~5 min worst case — well within budget | AC-001 |
| EC-003 | F1 delta §3 | PR touches both `adf.rs` (~351 mutants) and `edit.rs` (~99 mutants) | Total ~450 mutants, ~263 min — exceeds 90-min budget; split-PR signal fires; contributor must split PR per policy doc §Absolute Timeout Ceiling | AC-001, AC-006 |
| EC-004 | MUTANTS-FIRST-SCOPED-PR-CALIBRATION | First code-change PR touching `edit.rs` after this story merges | Non-zero mutant path exercised; --timeout 240 calibration event; if `timeout` outcomes appear, bump --timeout per policy doc | AC-006 |
| EC-005 | DEC-149 origin | Surviving mutants discovered in edit.rs/jsm_create.rs on first code-change PR | Kill-rate gate may block merge if survivors > 10%; targeted tests or `#[mutants::skip]` with justification required per policy doc; out of scope for this story — see Out of Scope | AC-005 (documented only) |

---

## Purity Classification

All files modified in this story are CI configuration, documentation, or factory artifacts — not production Rust source. The Pure/Effectful classification (which applies to Rust modules with the pure-core / effectful-shell boundary per ADR-0011) is N/A: no `src/` module is created or modified.

| Module | Classification | Justification |
|--------|---------------|---------------|
| `.cargo/mutants.toml` | N/A (config) | CI configuration file; not a Rust module |
| `docs/specs/cargo-mutants-policy.md` | N/A (documentation) | Policy document; not a Rust module |
| `.github/workflows/ci.yml` | N/A (CI config) | GitHub Actions workflow; not a Rust module |
| `CHANGELOG.md` | N/A (documentation) | Release log; not a Rust module |

---

## Story Points and Effort

**2 story points** (CI-config + doc governance; no code implementation).

Breakdown:
- `.cargo/mutants.toml` scope extension (2 lines + comment update): 0.5 SP
- `docs/specs/cargo-mutants-policy.md` citation correction + SWEEP + changelog entry: 0.75 SP
- `.factory/cicd-setup.md` false-claim correction: 0.5 SP (DEFERRED — state-manager post-merge, see AC-003)
- CLAUDE.md verification (no expected change): 0.25 SP

Comparable stories: S-TESTTOOL-1 (2 SP, examine_globs expansion + keyring gate), S-MUTATION-CI-TIMEOUT-1
(2 SP retroactive, CI-config + policy doc). Estimate is 2 SP because 3 file changes (not 1) and
the SWEEP-WHOLE-TOUCHED-FILE obligation on the policy doc.
