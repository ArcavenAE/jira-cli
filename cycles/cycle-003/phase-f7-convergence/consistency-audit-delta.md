---
document_type: consistency-report
level: ops
version: "1.0"
status: "fail"
producer: consistency-validator
timestamp: 2026-09-03T00:00:00
phase: F7
inputs: [".factory/specs/prd/bc-1-auth-identity.md", ".factory/specs/prd/bc-6-config-cache.md", ".factory/specs/prd/BC-INDEX.md", ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-env-tag.md", ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-percred-storage.md", ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-credential-absence-guard.md", ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-remove-logout-semantics.md", ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-adr0011-newtype.md", ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-oauth-default-creation.md", ".factory/cycles/cycle-003/phase-f3-stories/S-cycle3-chosen-flow-reconcile.md", ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md", ".factory/cycles/cycle-003/phase-f3-stories/dependency-graph-extended.md", ".factory/cycles/cycle-003/phase-f3-stories/wave-schedule.md", ".factory/stories/STORY-INDEX.md", "docs/adr/0011-type-level-profile-fence.md", ".factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md", ".factory/STATE.md", "src/api/auth.rs", "src/cli/auth/login.rs", "src/cli/auth/logout.rs", "src/cli/auth/remove.rs", "src/cli/auth/refresh.rs", "src/cli/auth/list.rs", "src/cli/auth/status.rs", "src/cli/auth/switch.rs", "src/cli/auth/mod.rs", "src/config.rs", "src/api/client.rs", "src/profile.rs", "src/cache.rs", "docs/specs/multi-profile-auth.md", "CLAUDE.md", "scripts/check-spec-counts.sh", "scripts/check-bc-cumulative-counts.sh"]
input-hash: "98a2928"
traces_to: ".factory/cycles/cycle-003/phase-f3-stories/decomposition-manifest.md"
---

# Consistency Validation Report: jira-cli cycle-003 `auth-profile-dx` (Phase F7 pre-approval delta audit)

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jira-cli (`jr`) |
| **Generated** | 2026-09-03T00:00:00 |
| **Generator** | consistency-validator (fresh-context, 6 parallel sub-audits) |
| **Artifacts Scanned** | 24 BCs, 9 VPs, 7 stories, 2 ADRs, 1 STORY-INDEX, 1 BC-INDEX, ~12 src files, 1 design doc, CLAUDE.md |
| **Baseline** | `develop @ 202414f2` |
| **Scope** | Feature Mode delta audit — NOT a full greenfield L1-L4 pipeline validation. Scope is the cycle-003 `auth-profile-dx` delta only (24 new/amended BCs, 9 VPs, 7 stories). Sections below that assume a full-pipeline scope (Story Sizing, ASM/R Traceability, Architecture Module Coverage) are marked N/A with justification where cycle-003 introduced no new items in that category. |

## Summary

| # | Check | Result |
|---|-------|--------|
| 1 | L2 to L3 Requirement Coverage (cycle-003 delta) | pass |
| 2 | L3 to L4 Verification Property Coverage (VP-AUTHDX-001..009) | pass |
| 3 | Dependency Acyclicity (7 cycle-003 stories) | pass (2 label-only staleness items, non-blocking) |
| 4 | Architecture Alignment | pass |
| 5 | Acceptance Criteria Quality / AC-BC bidirectional traceability | **fail** (2 HIGH gaps) |
| 6 | Story Sizing (all <= 13 points) | pass |
| 7 | Priority Consistency | pass |
| 8 | L1 to L2 to L3 to L4 Chain Completeness | pass (chain itself intact; see Cross-Reference Validation for index-currency issue) |
| 9 | AC Completeness Coverage | **fail** (2 HIGH gaps, same as #5) |
| 10 | ASM/R Traceability | N/A — cycle-003 introduced no new ASM-NNN/R-NNN entries (delta-analysis.md scope); full ASM/R set was validated at the F2 gate (DEC-328) and is unchanged by this delta |

**Overall Verdict: INCONSISTENT.** One CRITICAL and three HIGH findings block a clean F7 approval as currently documented — all in the documentation/index layer, none in shipped code (see Delta-Scoped Findings Table below for full detail and the per-check narrative sections that follow).

---

## Delta-Scoped Findings Table (primary output of this audit)

Six independent fresh-context sub-audits ran in parallel (no shared context) covering: (A) credential-storage BC cluster vs. code, (B) OAuth-default/refresh-override BC cluster vs. code (incl. targeted re-verification of the claimed F5 MED-1 reconciliation), (C) env-tag BC cluster + ADR-0011 + ADR-0020, (D) VP-AUTHDX-001..009 test-existence + count-consistency scripts, (E) story ↔ STORY-INDEX.md ↔ BC-INDEX.md bidirectional traceability + acyclicity, (F) scope-completeness of the auth subcommand surface. Findings below are deduplicated and independently spot-verified where load-bearing (CRIT-1 was independently re-confirmed by direct read, not just sub-agent report).

### Counts by Severity

| Severity | Count |
|---|---|
| CRITICAL | 1 |
| HIGH | 3 |
| MEDIUM | 2 |
| LOW | 6 |
| **Total findings** | **12** |

| ID | Severity | Layer | Description | Suggested Route |
|---|---|---|---|---|
| CRIT-1 | **CRITICAL** | Story Index | `.factory/stories/STORY-INDEX.md` is stale and directly contradicts `.factory/STATE.md`. All 7 `S-cycle3-*` rows (lines 1080-1086, and file-path table rows 1461-1467) read `status: ready` / `F4 dispatch pending` / `awaiting F4 dispatch` — i.e. not yet implemented. `STATE.md` records Phase F4 **COMPLETE** (all 7 stories merged to `develop` @ `1dfcd013` via PRs #752/#755/#756/#757/#758/#761/#762), Phase F5 **CONVERGED** (PRs #763/#764 merged), Phase F6 **IN PROGRESS**. Independently re-confirmed by direct grep/read of STORY-INDEX.md (not just sub-agent report): the rows verbatim still say `**ready** — F3 human gate APPROVED (2026-09-01, DEC-329), awaiting F4 dispatch; ... F4 dispatch pending`. STORY-INDEX.md's own frontmatter narrative additionally claims the table was already "corrected" to draft/current status — that claim is itself false against the table's actual content. Anyone consulting the canonical story index alone would conclude cycle-003 implementation has not started. | Route to state-manager: update all 7 rows' status/phase fields with correct PR/commit citations before the F7 human gate. Not cosmetic — this is the source of truth other checks and future sessions resume from. |
| HIGH-1 | HIGH | Story ↔ BC traceability | `BC-1.4.027` (AMENDED — namespaced-key split) is in `S-cycle3-percred-storage.md`'s `bcs:` frontmatter and body BC table, but **no AC traces to it** — all 9 ACs cite BC-1.4.031 or the combined BC-1.1.009/010/BC-1.2.017 line. Confirmed independently by two separate sub-audits. | Route to story-writer/product-owner: add or annotate an AC in `S-cycle3-percred-storage.md` tracing to `BC-1.4.027`. |
| HIGH-2 | HIGH | Story ↔ BC traceability | `BC-1.4.029` (AMENDED — cross-ref to `load_api_token` non-inheritance) is in `S-cycle3-credential-absence-guard.md`'s `bcs:` frontmatter and body BC table, but **no AC traces to it** — AC-001..AC-012 trace only to BC-1.4.032/033/034/025. Confirmed independently by two separate sub-audits. | Same route as HIGH-1, targeting `S-cycle3-credential-absence-guard.md` / `BC-1.4.029`. |
| HIGH-3 | HIGH | Design doc (docs/specs) | `docs/specs/multi-profile-auth.md` is internally self-contradictory and only partially updated for cycle-003, despite the cycle's own F1 delta-analysis explicitly naming this file's "Keyring Layout" and "CLI Surface" sections as required updates. Its Migration/Config Schema sections correctly describe the shipped per-profile model; its Keyring Layout table and CLI Surface subsection still describe the pre-cycle-003 flat/shared model verbatim (`email`/`api-token` marked "Shared," 4-column `auth list`, `auth refresh --oauth` documented as "forces the OAuth path" — the exact behavior DEC-321 removed). `git log` on this file shows only 2 cycle-003-era touches, neither touching the stale sections. | Route to technical-writer: update Keyring Layout + CLI Surface sections to match shipped model before F7 sign-off. |
| MED-1 | MEDIUM | Count consistency | The "41 total VPs" figure (STATE.md, repeated) has no automated cross-check and no discoverable single source of truth — no `VP-INDEX.md`, no script analogous to `check-bc-cumulative-counts.sh`. The 733-BC figure, by contrast, is verified: both `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` re-run clean (exit 0) in this audit. All 9 cycle-003 VP-AUTHDX are independently accounted for and test-verified (see VP table below); the aggregate 41 claim itself is unverifiable. | Route to spec-steward: cite the 41-VP source of truth explicitly, or add a VP-count consistency script. Non-blocking for cycle-003's own VPs. |
| MED-2 | MEDIUM | Story metadata | `S-cycle3-oauth-default-creation.md` and `S-cycle3-chosen-flow-reconcile.md` carry stale wave-number labels in their own prose ("Wave 5"/"Wave 6") left over from the superseded 6-wave preliminary numbering; the adopted 5-wave schedule (correctly reflected in `wave-schedule.md`, `dependency-graph-extended.md`, and STORY-INDEX.md) places them at Wave 4 and Wave 5. Dependency edges themselves are correct and the graph is genuinely acyclic — label-only drift. | Route to story-writer: correct wave-number prose in both files. |
| LOW-1 | LOW | Spec/Story internal accuracy | `BC-1.2.048`'s Trace note and STORY-INDEX.md's `S-cycle3-chosen-flow-reconcile` row both claim `chosen_flow_for_profile` "is REMOVED entirely... not merely simplified." Factually inaccurate: the function still exists in `src/cli/auth/mod.rs` (~line 170), simplified to single-argument form, still called from `refresh.rs`. `BC-1.2.051`'s own text correctly hedges ("if retained at all"). Does not affect any F6/test citation correctness. | Route to product-owner: correct "removed entirely" to "simplified" in both places. |
| LOW-2 | LOW | Code comment | `src/cli/auth/logout.rs` (~lines 21-23) retains a stale pre-DEC-315 comment ("shared API-token credential... keyed by host, not profile") directly above the correct current docstring. Harmless — code behavior is correct. | Trivial doc-comment fix, no behavior change. |
| LOW-3 | LOW | CLAUDE.md | The "Per-profile vs shared keychain keys" gotcha entry omits the stderr-notice text BC-1.2.013 requires for `auth logout` on api-token profiles (implemented correctly in code, just undocumented in CLAUDE.md). | Add the detail at next CLAUDE.md revision pass. |
| LOW-4 | LOW | BC-INDEX.md | `BC-1.6.047`'s BC-INDEX title drops the "JSON/text" phrasing present in the BC file's own H1 heading — paraphrase inconsistency, arguably more accurate to current reality (JSON path deferred per NFR-O-N), not a functional error. | Align titles at next index maintenance pass. |
| LOW-5 | LOW | STORY-INDEX.md | A stale legacy "Story Manifest" section (~line 1271) still headlines "Total rows: 133," far short of the current 168. Pre-existing drift, not cycle-003-specific, but compounds the CRIT-1 currency concern. | Bundle with CRIT-1 fix. |
| LOW-6 | LOW | Scope/UX completeness | No CLI flag sets a profile's new `env` tag (hand-edit `config.toml` only) — appears intentional per ADR-0020 §Decision 4 scope, but undocumented as a deliberate boundary. | Add one sentence to ADR-0020/BC-6.1.015 stating this is out of scope by design. |

### VP-AUTHDX Test-Existence Table

| VP | F6 Target Exists | Test(s) Found |
|---|---|---|
| VP-AUTHDX-001 | Yes | `tests/auth_oauth_default_creation.rs:38` (proptest) |
| VP-AUTHDX-002 | Yes (`src/api/client.rs::from_config`) | `tests/auth_oauth_default_creation.rs:279` (proptest) + `:1207` keyring-gated companion |
| VP-AUTHDX-003 | Yes (`refresh.rs::refresh_credentials`) | `tests/auth_chosen_flow_reconcile.rs:24` (2×3 matrix proptest, 32 cases) |
| VP-AUTHDX-004 | Yes | `src/api/auth.rs:2786` `prop_bc_1_4_031_round_trip_and_cross_profile_isolation` + keyring-gated tests |
| VP-AUTHDX-005 | Yes | `src/api/auth.rs:3366` (`#[ignore]`, keyring-gated) |
| VP-AUTHDX-006 | Yes | `src/api/auth.rs:3405` (`#[ignore]`) |
| VP-AUTHDX-007 | Yes | `src/api/auth.rs:3225` (`#[ignore]`, mandatory scenario) |
| VP-AUTHDX-008 | Yes | `src/api/auth.rs:3431` (`#[ignore]`) |
| VP-AUTHDX-009 | Yes (`ProfileConfig` in `src/config.rs`) | `src/config.rs:2099/2123/2140` (three proptests) |

All 9/9 VPs have real, correctly-shaped, existing cited F6 targets and tests. No gap.

---

## 1. L2 to L3 Requirement Coverage

### 1.1 Domain Capabilities to Behavioral Contracts (cycle-003 delta scope)

24/24 cycle-003 BCs trace to their originating capability/decision (DEC-313 through DEC-328) per `decomposition-manifest.md` §1's BC Coverage Matrix, independently re-verified against `bc-1-auth-identity.md`/`bc-6-config-cache.md` full text. No gap. (Full L1→L2 CAP-NNN chain is out of this delta's scope — unchanged by cycle-003, already validated at prior gates.)

## 2. L3 to L4 Verification Property Coverage

### 2.1 Behavioral Contracts to Verification Properties

9/9 VP-AUTHDX declared, each anchored to a specific BC (see decomposition-manifest.md §1 VP Coverage Matrix) and each independently confirmed to have a real, existing test (see VP-AUTHDX Test-Existence Table above). No orphaned VP, no BC lacking a VP where one is warranted (several BCs correctly have "Verification Properties: None" with an explicit TRIAGED/DEMOTED justification, e.g. BC-1.2.049/050 — reviewed and found sound: ordinary clap `conflicts_with` arity checks, not invariants).

## 3. Dependency Acyclicity

### 3.1 Topological Order

`env-tag`, `percred-storage` (Wave 1, no deps) → `credential-absence-guard` (Wave 2) → `remove-logout-semantics` (Wave 3) → `adr0011-newtype`, `oauth-default-creation` (Wave 4, no edge between them) → `chosen-flow-reconcile` (Wave 5, terminal). Genuinely acyclic; independently re-derived from each story's `depends_on:`/`blocks:` fields and cross-checked against `dependency-graph-extended.md` and `wave-schedule.md` — all three agree. See MED-2 for two stories' stale wave-number **labels** (edges themselves are correct).

### 3.2 Critical Path

`percred-storage` → `credential-absence-guard` → `remove-logout-semantics` → `oauth-default-creation` → `chosen-flow-reconcile` = 8+8+5+13+5 = 39 points (matches STATE.md's "39-pt critical path" claim, of 57 total points).

## 4. Architecture Alignment

### 4.1 Module Coverage

| Architecture Component | Stories Covering It | Coverage |
|-----------------------|--------------------|---------:|
| `src/api/auth.rs` (credential storage) | percred-storage, credential-absence-guard, remove-logout-semantics, adr0011-newtype | full |
| `src/cli/auth/{login,refresh}.rs` (mechanism selection) | oauth-default-creation, chosen-flow-reconcile | full |
| `src/config.rs` (env field) | env-tag, adr0011-newtype | full |
| `src/cli/auth/{list,status}.rs` (display) | env-tag | full |
| `src/cache.rs` (Profile newtype threading) | adr0011-newtype | full |

### 4.2 Component Consistency

All story "target" file lists (per STORY-INDEX.md rows) match the actual files touched (spot-checked against `git log` on each PR). No story references an undeclared component.

## 5. Acceptance Criteria Quality

### 5.1 Concreteness

All 7 stories' ACs are concrete, example-based, and traced to specific BC postconditions/preconditions — no vague or subjective ACs found in this delta. **However**, see HIGH-1/HIGH-2: two BCs present in a story's frontmatter/BC-table have **zero** ACs tracing to them at all, which is an AC-**completeness** gap distinct from AC-quality.

### 5.2 Testability

Every AC checked maps to a concrete, testable assertion (property test, unit test, or keyring-gated integration test) — confirmed via the VP-AUTHDX Test-Existence Table and the credential-storage/OAuth-cluster sub-audits' direct code inspection.

## 6. Story Sizing

| Story | Points | Status |
|-------|-------:|--------|
| S-cycle3-env-tag | 5 | ok |
| S-cycle3-percred-storage | 8 | ok |
| S-cycle3-credential-absence-guard | 8 | ok |
| S-cycle3-remove-logout-semantics | 5 | ok |
| S-cycle3-adr0011-newtype | 13 | ok (at threshold) |
| S-cycle3-oauth-default-creation | 13 | ok (at threshold) |
| S-cycle3-chosen-flow-reconcile | 5 | ok |

All 7 stories <= 13 points. No violation.

## 7. Priority Consistency

`S-cycle3-credential-absence-guard` and `S-cycle3-oauth-default-creation` are P0. Both have all `depends_on` predecessors (`percred-storage`; `percred-storage`+`credential-absence-guard`+`remove-logout-semantics` respectively) at equal-or-effectively-P0 priority — no P0 story blocked by an unresolved lower-priority dependency. No violation.

## 8. L1 to L2 to L3 to L4 Chain Completeness

### L1 to L2 to L3 to L4 Chain Overview (cycle-003 delta only)

| Level | Artifact | Count | Traced Forward | Traced Backward | Coverage |
|-------|----------|-------|---------------|----------------|----------|
| L2 | Decisions (DEC-313..328) | 16 | 16 to L3 BCs | N/A | 100% |
| L3 | Behavioral Contracts (24 cycle-003 BCs) | 24 | 24 to L4 VPs-or-justified-none | 24 to L2 | 100% |
| L4 | Verification Properties (VP-AUTHDX-001..009) | 9 | 9 to stories | 9 to L3 | 100% |
| Stories | S-cycle3-* | 7 | 7 to implementation (merged PRs) | 7 to L3 BCs | 100% (frontmatter/table level); **91.7%** (24/26 BC-references at AC-trace level — see HIGH-1/HIGH-2) |

### Broken Chains

| Gap ID | From | To | Missing Link | Impact | Priority |
|--------|------|----|-------------|--------|----------|
| CHAIN-1 (=HIGH-1) | `S-cycle3-percred-storage.md` frontmatter/BC-table | BC-1.4.027 | No AC traces to this BC | Coverage-completeness gap, not a functional defect (BC's substance is exercised by an existing AC that just lacks the annotation) | P1 |
| CHAIN-2 (=HIGH-2) | `S-cycle3-credential-absence-guard.md` frontmatter/BC-table | BC-1.4.029 | No AC traces to this BC | Same as above | P1 |

### Orphaned Artifacts

None found. Every BC, VP, and story in the cycle-003 delta has both a forward and backward trace at the frontmatter/table level; the two gaps above are AC-level annotation gaps, not orphaned artifacts.

## 9. AC Completeness Coverage

### 9.1 BC Clause Coverage (Level 1, cycle-003 delta)

| BC-S.SS.NNN | Total Clauses | Covered | Uncovered | Gap Entries | Coverage % |
|-------------|---------------|---------|-----------|-------------|------------|
| BC-1.4.027 | (per its Preconditions/Postconditions) | 0 direct AC | all | 0 (no Gap Register entry either) | 0% at AC-trace level (substance covered indirectly by BC-1.4.031's AC-004) |
| BC-1.4.029 | (per its Preconditions/Postconditions) | 0 direct AC | all | 0 | 0% at AC-trace level (substance covered indirectly) |
| All other 22 cycle-003 BCs | — | full | none | — | 100% |

**L1 Score:** 22/24 BCs = 91.7% at strict AC-trace level (100% at story-frontmatter/BC-table level).

### 9.2 Edge Case & Error Coverage (Level 2)

| Source | Total IDs | Covered | Orphaned | Coverage % |
|--------|-----------|---------|----------|------------|
| BC Edge Cases (EC-1.1.x/1.2.x/1.4.x/1.6.x) | all cited across the 6 sub-audits | all confirmed present in story ACs or code | 0 | 100% |

### 9.3 Cross-Cutting Coverage (Level 3)

Not separately re-derived in this delta audit beyond what's captured above — no new NFR-NNN or holdout scenario was introduced by cycle-003 per the F1 delta-analysis (confirmed: cycle-003 is scoped to auth BCs only, no new NFR/holdout entries claimed in decomposition-manifest.md).

### 9.4 AC Completeness Summary

| Level | Weight | Score | Weighted |
|-------|--------|-------|----------|
| L1 -- BC Clause Coverage | 50% | 91.7% | 45.85% |
| L2 -- Edge Case & Error Coverage | 30% | 100% | 30% |
| L3 -- Cross-Cutting Coverage | 20% | 100% (no new items in scope) | 20% |
| **Overall** | **100%** | | **95.85%** |

**Gate Result:** PASS by the numeric >=90% weighted threshold — but the two underlying gaps (HIGH-1/HIGH-2) are still flagged as blocking-class findings per this audit's own severity judgment, because a BC explicitly claimed as "story-covered" with literally zero AC-trace is a completeness defect regardless of the aggregate percentage clearing threshold.

## 10. ASM/R Traceability

N/A for this delta. Cycle-003's F1 delta-analysis introduced no new ASM-NNN or R-NNN entries; the project's full ASM/R register is unchanged by this cycle and was last validated at the F2 human gate (DEC-328).

## Cross-Reference Validation

### ID Consistency

| Check | Status | Issues |
|-------|--------|--------|
| BC IDs unique (cycle-003 delta) | pass | none |
| VP IDs unique (VP-AUTHDX-001..009) | pass | none |
| BC traces to valid DEC/decision | pass | none |
| VP traces to valid BC | pass | none |
| Story ACs trace to valid BC | **fail** | HIGH-1 (BC-1.4.027), HIGH-2 (BC-1.4.029) — BC exists and is valid, but no AC cites it |

### Naming Convention Compliance

| Convention | Expected Pattern | Violations |
|-----------|-----------------|------------|
| BC naming | BC-S.SS.NNN | none |
| VP naming | VP-AUTHDX-NNN | none |
| Story naming | S-cycle3-<slug> | none (deliberate deviation from numeric `S-{issue}-*` scheme, explicitly justified in decomposition-manifest.md §0, not a violation) |

### Canonical Frontmatter Validation

| Artifact | document_type | level | version | producer | traces_to | Status |
|----------|--------------|-------|---------|----------|-----------|--------|
| 7 × S-cycle3-*.md | present | present | present | present | present | pass |
| BC-INDEX.md | present | present | present | present | present | pass |
| STORY-INDEX.md | present | present | present | present | present | pass (frontmatter structurally valid; **content is stale**, see CRIT-1) |

## Spec vs Implementation Drift

| Artifact | Spec Version | Implementation State | Drift Detected | Notes |
|----------|-------------|---------------------|---------------|-------|
| bc-1-auth-identity.md / bc-6-config-cache.md | current (2026-09-01 F2-gate + F5 MED-1 fix) | current, matches code | no | All 24 BCs' Preconditions/Postconditions/Invariants verified against actual `src/` behavior — clean, including the specifically re-checked BC-1.1.016↔DEC-321 reconciliation. |
| ADR-0011 | Accepted | Applied (`Profile` newtype threaded through ~26+ call sites) | no | Confirmed via direct grep of `src/cache.rs`, `src/api/auth.rs`, `src/config.rs`, `src/api/client.rs`. |
| ADR-0020 | Accepted | Fully shipped | no | All 3 design claims (namespaced keys, `env` field, OAuth-default flow) match code exactly. |
| STORY-INDEX.md | n/a (index, not spec) | reflects F3-gate state only | **yes — CRIT-1** | Index frozen at F3 approval; never updated through F4/F5/F6 execution recorded in STATE.md. |
| docs/specs/multi-profile-auth.md | partially updated | shipped (per-profile model) | **yes — HIGH-3** | Keyring Layout + CLI Surface sections still describe the pre-cycle-003 flat model. |
| CLAUDE.md auth gotchas | mostly current | shipped | minor (LOW-3) | One omitted implementation detail (logout stderr notice), otherwise accurate. |

## Findings

### Critical
- **CRIT-1**: `.factory/stories/STORY-INDEX.md` phase-status staleness contradicting `.factory/STATE.md` — must be resolved before F7 human gate (see Delta-Scoped Findings Table for full detail).

### Major
- **HIGH-1**: BC-1.4.027 has no AC trace in `S-cycle3-percred-storage.md`.
- **HIGH-2**: BC-1.4.029 has no AC trace in `S-cycle3-credential-absence-guard.md`.
- **HIGH-3**: `docs/specs/multi-profile-auth.md` self-contradictory / stale Keyring Layout + CLI Surface sections.
- **MED-1**: "41 total VPs" claim unverifiable — no VP-INDEX or count script.
- **MED-2**: Stale wave-number labels in two story files' prose (label-only, edges correct).

### Minor
- **LOW-1** through **LOW-6**: documentation-accuracy nits (chosen_flow_for_profile "removed" vs "simplified" language; stale logout.rs comment; CLAUDE.md omission; BC-INDEX title paraphrase; stale legacy STORY-INDEX section; undocumented env-flag scope boundary). Full detail in Delta-Scoped Findings Table above.

## Validation Gate Result

**FAIL** — blocking findings: CRIT-1, HIGH-1, HIGH-2, HIGH-3. MEDIUM/LOW findings are non-blocking and may be swept in the same pass or explicitly carried forward per this project's established residual-sweep convention (as done at the F2 and F5 gates).

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 12 (per the 7-point custom check list requested + this template's 10-section structure, overlapping) |
| **Passed** | 8 |
| **Failed** | 4 (checks 5 and 9 share the same underlying HIGH-1/HIGH-2 root cause; CRIT-1 and HIGH-3 fail Cross-Reference Validation / Spec-vs-Implementation-Drift respectively) |
| **Warnings** | 2 (MED-1, MED-2) + 6 (LOW-1..6) |
| **Overall Status** | inconsistencies-found |

All code-level BC↔implementation correspondence, all 9 VP↔test mappings, ADR-0011/ADR-0020 status and application, dependency acyclicity, story sizing, and priority consistency are clean. The defects found are entirely in the documentation/index layer: one canonical index (STORY-INDEX.md) frozen at a stale phase, two BCs with incomplete AC-level traceability despite correct frontmatter/table coverage, and one design doc left half-updated by its own cycle's delta-analysis instructions. Recommend fixing CRIT-1/HIGH-1/HIGH-2/HIGH-3 (or obtaining explicit human sign-off to defer them, as has been the project's practice at prior gates) before presenting cycle-003 to the F7 approval gate as "converged."

## Appendix: Validation Methodology

Six independent fresh-context general-purpose sub-agents were dispatched in parallel, each given a self-contained, file-path-specific brief with zero access to this coordinating session's prior findings or to each other's output, mirroring the "different reviewer, different context" discipline this project's own adversarial-review process uses. Each sub-agent used only read-only tools (Read/Grep/Bash-readonly) against the live `develop @ 202414f2` checkout — no spec or source file was modified by this audit. Coordinating agent independently re-verified the single CRITICAL finding (STORY-INDEX.md staleness) via direct grep before including it, per this project's stated practice of not merely trusting a single sub-agent's self-report for load-bearing claims. Two findings (BC-1.4.027 and BC-1.4.029 AC-trace gaps) were corroborated by two independent sub-audits arriving at the same conclusion via different investigation paths, which increases confidence these are genuine gaps rather than a single agent's misreading. Full sub-audit briefs and raw findings are preserved in this session's transcript; this report is the deduplicated, severity-ranked synthesis. Reference: consistency-validator agent operating procedure (`AGENTS.md`) for the full 80-criterion canonical checklist — this delta audit applied the subset of those criteria (and the seven custom checks explicitly requested for this cycle) that are relevant to a Feature Mode delta scope rather than a full greenfield pipeline validation.
