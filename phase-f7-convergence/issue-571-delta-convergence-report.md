---
document_type: f7-delta-convergence-report
feature: issue-571 / S-ADF-CODE-MARK-1
bundle: ADF-CODE-MARK-EXCLUSIVITY
spec_version: v1.3.24 → v1.3.25
pr_fix: "#593"
pr_changelog: "#594"
pr_sha_fix: 7ba4cf4
pr_sha_changelog: d7875e6
date: 2026-07-08
status: AWAITING_HUMAN_F7_AUTHORIZATION
maximum_viable_refinement_reached: false
producer: state-manager
inputs:
  - ".factory/phase-f6-hardening/summary.md"
  - ".factory/phase-f7-convergence/issue-571-traceability-chain-delta.md"
  - ".factory/specs/prd/holdout-scenarios.md"
input-hash: "4dc9f48"
---

# Delta Convergence Report: ADF-CODE-MARK-EXCLUSIVITY (issue #571)

## Feature Summary

- **Feature:** issue #571 (CLOSED) — ADF code-mark exclusivity at `push_code` emit site
- **Story:** S-ADF-CODE-MARK-1 v1.9 (story #103, 12 ACs, 4 pts)
- **Bundle:** ADF-CODE-MARK-EXCLUSIVITY
- **Spec version:** v1.3.24 → v1.3.25 (BC-7.2.015 added; BC-7.2.007 EC-2 amended → closed)
- **PRs:** #593 (fix, squash-merged @ `7ba4cf4`) + #594 (changelog, squash-merged @ `d7875e6`)
- **Files changed (delta `0d8a8a5..d7875e6`):**
  - `src/adf.rs` (+594 lines — production + unit tests)
  - `tests/adf_code_mark_exclusivity.rs` (+499 lines, new file — H-NEW-ADF-010 Calls A–D)
  - `tests/issue_create_jsm.rs` (+237 lines — H-NEW-ADF-010 Call E, JSM path parity)
  - `CLAUDE.md` (clause-b splice; 1 line changed)
  - `CHANGELOG.md` (added via fix-PR #594)
- **New BCs:** BC-7.2.015 (code-mark exclusivity). BC-7.2.007 EC-2 amended + closed.
- **New VPs:** VP-571-001 (proptest universal quantifier), VP-571-002 (EC anchors), VP-571-003 (node-scoped stripping), VP-571-004 (read-tolerance retained), VP-571-005 (JSM path parity)

---

## Five-Dimensional Convergence

| Dimension | Metric | Target | Actual | Status |
|-----------|--------|--------|--------|--------|
| **Spec** | F2 adversary novelty at convergence (19 passes; clean window 17+18+19) | < 0.15 | ~0.00 (zero novel findings at clean window) | **PASS** |
| **Test** | Mutation kill rate on delta (`--in-diff 0d8a8a5..d7875e6`) | ≥ 90% | **100% (1/1 caught; mutant killed in 4.2 s)** | **PASS** |
| **Implementation** | F5 adversary verification rate; open CRIT/HIGH at convergence | 0 open CRIT/HIGH | 3/3 STRICT CLEAN passes (p4/p5/p6); 1 real finding total (p3 MISSING-CHANGELOG-ENTRY, LOW — fixed via #594); 0 CRIT/HIGH any pass | **PASS** |
| **Verification** | Proptest VP-571-001 @ 2000 cases (Kani substitute); fuzz; mutation; cargo deny+audit | All pass or justified-skip | Proptest PASS; fuzz justified-skip (no cargo-fuzz; proptest is substitute); mutation 100%; cargo deny+audit 0 vulns/347 crates | **PASS** |
| **Holdout** | H-NEW-ADF-010 mean satisfaction; ADF regression suite | ≥ 0.85 mean; zero must-pass < 0.6 | Mean **1.00** (7 scenarios: H-NEW-ADF-010 delta 1.00 + 6 ADF regression 1.00); zero must-pass < 0.6 | **PASS** |

### Dimension Notes

**Spec Convergence:** F2 ran 19 adversarial passes (DEC-158: STRICT criterion — any delta-attributable LOW resets; VA-informational exempt). Trajectory 3→4→5→5→0→1→0→4→1→0→3→1→1→0→2→3→0→0→0. Clean window 17+18+19. BC-7.2.015 authored; BC-7.2.007 EC-2 amended to record closure; H-NEW-ADF-010 added to holdout-scenarios.md (Group 12, MUST-PASS); VP-571-001..005 added. Novelty score at convergence effectively 0.00.

**Test Convergence:** 1 in-scope mutant generated (`src/adf.rs:1282:9 replace push_code with ()`). Killed immediately (4.2 s) by the EC-1..EC-6 example-based tests + PANEL-ANCHOR test asserting `marks == [code]`; kill rate 100%. No vacuously true tests: every `tests/adf_code_mark_exclusivity.rs` integration test carries a `Mock::given(any()).expect(0)` catch-all enforcing zero extra HTTP calls plus assertion on the captured request body's `marks` array.

**Implementation Convergence:** F3 story adversarial STRICT CONVERGED (10 passes / 6 fix rounds; window 8+9+10 CLEAN — DEC-160). F4 Step-4.5 adversarial STRICT CONVERGED (window F4-p2/F4-p3/F4-p4 — DEC-161). F5 ran 6 passes with STRICT criterion: p1 CLEAN (post-#593 merge), p2 CLEAN, p3 1 LOW MISSING-CHANGELOG-ENTRY (fixed via fix-PR #594 squash-merged @ d7875e6, DEC-128 honored), p4 CLEAN, p5 CLEAN (one informational observation: spec-changelog range-shift; verified NON-DEFECT per factory commit b5c0f6c), p6 CLEAN. Window p4/p5/p6 CLEAN×3 = STRICT CONVERGED (DEC-162). No [process-gap] findings any pass. Open CRIT/HIGH: 0/0/0/0/0/0.

**Verification Convergence:** VP-571-001 `prop_bc_7_2_015_no_code_marked_text_node_carries_typographic_marks` run at `PROPTEST_CASES=2000` (10× default; held as formal-verification substitute per `.factory/phase-f6-hardening/kani-results.md`) — PASS. Fuzz: justified-skip (no cargo-fuzz in project; proptest is the substitute; delta introduces no new panic/I/O surface). `cargo audit` exit 0, 347 crates, 0 vulnerabilities. `cargo deny` exit 0, 3 unused-allowance warnings (pre-existing baseline). `push_code` is pure-core; BC-7.2.015 SEC framing: restrictive-only allowlist, no untrusted-input execution, no `href` scheme validation change — no CRIT/HIGH security findings.

**Holdout Convergence:** H-NEW-ADF-010 (Group 12, MUST-PASS) Calls A–E all passed. Call A: EC-1 strong+code → `marks == [code]`. Call B: EC-4 subsup+code (primary regression target; CONFIRMED-INPUT — `^\`code\`^` form retained unchanged) → `marks == [code]`. Call C: EC-5 link+code retained → marks ⊇ {code, link}. Call D: EC-6 mixed-range → sibling strong nodes retain marks; code node carries `[code]` only. Call E: JSM path parity via `tests/issue_create_jsm.rs`; `requestFieldValues.description` code text node `marks == [code]`; `.expect(0)` dispatch-fork regression guard (ADR-0014) passed. ADF regression suite (6 scenarios from Groups 7–11: ADF task-list, block-HTML, footnotes, panels, misc) — all satisfaction 1.00. Zero must-pass scenarios < 0.6. Mean satisfaction 1.00.

---

## Regression Validation

| Metric | Baseline (pre-bundle `0d8a8a5`) | Current (post-bundle `d7875e6`) | Status |
|--------|--------------------------------|---------------------------------|--------|
| Total tests passing | ~1,952 (pre-#571 estimate) | **2,007** | -- |
| Existing tests passing | ~1,952 | 2,007 | **PASS** |
| Unexpected failures | 0 | **0** | **PASS** |
| Ignored (gated) | 93 | **93** (pre-existing; keychain/OAuth E2E) | **PASS** |
| adf::tests lib tests | 275 | **275 / 275** (0 fail) | **PASS** |
| cargo clippy -D warnings | CLEAN | **CLEAN (exit 0)** | **PASS** |
| cargo fmt --all -- --check | CLEAN | **CLEAN (exit 0)** | **PASS** |

Zero regressions. All 275 `adf::tests` lib unit tests pass. The 93 gated-ignored tests (macOS keychain: `JR_RUN_KEYRING_TESTS=1`; OAuth integration: `JR_RUN_OAUTH_INTEGRATION=1`; E2E: `JR_RUN_E2E=1`) are pre-existing and unchanged.

---

## Fresh-Context Consistency Audit

**Result: CONSISTENT.**

Three counting scripts all exit 0:
- `scripts/check-spec-counts.sh` — frontmatter counts match body counts across all BC files.
- `scripts/check-bc-cumulative-counts.sh` — 8 surfaces agree (per-file frontmatter A, BC-INDEX.md sections B/C, CANONICAL-COUNTS.md D, body preamble, BC-INDEX.md frontmatter total_bcs E, CANONICAL-COUNTS.md sum row F, grand-total prose G).
- `scripts/check-bc-citation-symbols.sh` — 312 citations checked; all file::symbol citations in BC bodies resolve to real `src/` symbols.

STATE/index/detail/product-doc surfaces agree: BC **612**, Holdouts **83**, Stories **103**, NFR **42**, ADR **16**.

---

## Input-Hash Drift Check (gate-7 mandate)

**Pre-bump scan result:** 11 STALE (all bookkeeping/historical) + 2 UNRESOLVABLE (accepted, human-gate rule satisfied).

| Category | Count | Disposition |
|----------|-------|-------------|
| STALE bookkeeping/historical | 11 | BUMPED (stale hashes updated; no content re-derivation) |
| UNRESOLVABLE | 2 | UNTOUCHED — accepted authoring quirks in closed-cycle records |
| Live spec artifacts stale | 0 | None |

**Stale files bumped (11):**
- `cycles/cycle-001/S-340/implementation/red-gate-log.md`
- `cycles/cycle-001/session-checkpoints.md`
- `cycles/cycle-001/burst-log.md`
- `cycles/cycle-001/blocking-issues-resolved.md`
- `cycles/cycle-001/lessons.md`
- `cycles/cycle-001/S-ADF-CODE-MARK-1/implementation/red-gate-log.md`
- `code-delivery/issue-333/spec-evolution.md`
- `phase-f1-delta-analysis/business-analyst-input-346.md`
- `phase-f1-delta-analysis/business-analyst-input-345.md`
- `phase-f1-delta-analysis/business-analyst-input.md`
- `phase-f1-delta-analysis/business-analyst-input-288.md`

**UNRESOLVABLE files (2 — untouched, human-gate rule satisfied):**
1. `code-delivery/issue-333/delta-analysis.md` — lists a GitHub URL (`https://github.com/Zious11/jira-cli/issues/333`) as an input; compute-input-hash cannot fetch remote URLs. Authoring quirk in closed-cycle record. No content re-derivation needed.
2. `phase-f1-delta-analysis/issue-383/delta-analysis.md` — references 2 never-produced F1 step files (`impact-boundary.md` + `affected-artifacts.md`). Those files were never created for issue #383 (F1 was never run for that issue). Authoring quirk in closed-cycle record. No content re-derivation needed.

**Post-bump scan:** 0 STALE, 2 UNRESOLVABLE (documented above), no NEW drift introduced.

---

## Traceability Chain

Full traceability chain recorded in:
`.factory/phase-f7-convergence/issue-571-traceability-chain-delta.md` (input-hash `1aa2d75`)

Summary chain:

```
BC-7.2.015 (new) + BC-7.2.007 EC-2 (amended → closed)
  → VP-571-001..005
  → S-ADF-CODE-MARK-1 v1.9 (story #103, 12 ACs, 4 pts)
  → src/adf.rs::push_code (allowlist filter; single production emit site)
  → src/adf.rs::tests (inline unit + proptest; EC-1..EC-6 + CONTROL + PANEL-ANCHOR + VP-571-004 read-tolerance)
  → tests/adf_code_mark_exclusivity.rs (H-NEW-ADF-010 Calls A–D, platform path)
  → tests/issue_create_jsm.rs (H-NEW-ADF-010 Call E, JSM path parity)
  → F3: STRICT CONVERGED (10 passes / 6 fix rounds; window 8+9+10 — DEC-160)
  → F4 Step-4.5: STRICT CONVERGED (window F4-p2/p3/p4 — DEC-161); PR #593 @ 7ba4cf4
  → F5: STRICT CONVERGED (6 passes; window p4/p5/p6 — DEC-162); fix-PR #594 @ d7875e6
  → F6: TARGETED HARDENING COMPLETE (2026-07-08); proptest 2000 cases PASS; mutation 100% kill
  → Regression: 2007/0/93; clippy CLEAN; fmt CLEAN
  → Consistency audit: CONSISTENT (3 scripts exit 0; 312 citations)
  → Drift check: 11 stale bumped; 2 UNRESOLVABLE documented
```

Cross-references:
- BC-7.2.007 EC-2 (amended/closed): deferred follow-up from issue #474; enforced at emission time since #571.
- BC-7.2.011 INV-1: `push_code` is one of the three INV-1 enforcement chokepoints.
- Unified traceability matrix: does not exist under `.factory/cycles/cycle-001/`; this delta document is the authoritative artifact for S-ADF-CODE-MARK-1 / issue-571.

---

## Cost-Benefit Analysis (DF-027)

No cost-tracker instrumentation in this project (PERF-COST-TRACKING drift item — OPEN). Session-level estimate for the resume→F7 arc: ~1.2M subagent tokens (health check, PR #594 lifecycle, F5 passes p4–p6, F6 targeted hardening, F7 evidence package).

### Refinement iterations

| Phase | Passes | Trajectory | Quality |
|-------|--------|-----------|---------|
| F2 spec adversarial | 19 passes / 13 fix rounds | 3→4→5→5→0→1→0→4→1→0→3→1→1→0→2→3→0→0→0 | Clean window 17+18+19 |
| F3 story adversarial | 10 passes / 6 fix rounds | 3→2→1→0→1→3→1→0→0→0 | STRICT CONVERGED (DEC-160) |
| F4 Step-4.5 adversarial | 4 passes / 0 fix rounds | →1→0→0→0 | STRICT CONVERGED (DEC-161) |
| F5 scoped adversarial | 6 passes / 1 fix-PR | →0→0→1→0→0→0 | STRICT CONVERGED (DEC-162) |
| F6 hardening | Automated gate | N/A | GO |
| **Total** | **All phases converged cycle 1** | — | — |

All five dimensions converged in cycle 1 of F7 — no additional F7 cycles are projected. MAXIMUM_VIABLE_REFINEMENT_REACHED criterion is not triggered (converged first; criterion applies when additional passes have zero expected value but is redundant here because convergence was achieved).

---

## Deferrals

The following items are approved deferrals and do NOT block F7 authorization:

| ID | Description | Target | Approved |
|----|-------------|--------|---------|
| F5-OBS-001 | BC-7.2.015 lossiness (`**\`x\`**` → code-only) not cross-listed in BC-7.2.011 five-case lossy round-trip catalogue; already documented in BC-7.2.007 EC-2 + CLAUDE.md clause-b splice | Next spec-maintenance sweep | Human-approved 2026-07-08 |
| F5-OBS-002 | No runtime stderr warning when `push_code` strips typographic marks; silent strip is the correct product call vs pre-fix HTTP 400; candidate `--verbose` observability enhancement | v2 backlog | Human-approved 2026-07-08 |

---

## Recommendation

**Status: AWAITING HUMAN F7 AUTHORIZATION.**

All five convergence dimensions PASS. Full regression suite 2007/0/93 with zero failures. Consistency audit CONSISTENT (3 scripts exit 0; 312 citations). Input-hash drift check resolved (11 bookkeeping bumps; 2 UNRESOLVABLE documented and accepted). Traceability chain complete (`.factory/phase-f7-convergence/issue-571-traceability-chain-delta.md`). Two approved deferrals (F5-OBS-001/002) are non-blocking.

**READY — all gates green. Awaiting human F7 authorization to close bundle ADF-CODE-MARK-EXCLUSIVITY and route to optional release.**

Post-authorization disposition:
- Bundle CLOSED: ADF-CODE-MARK-EXCLUSIVITY issue #571 fully delivered.
- Optional release: ships with next batched `develop → main` release (no standalone release required; BC-7.2.015 is a correctness fix with no user-visible behavior change visible at the CLI surface).
- Next backlog: per STATE.md RESUME PLAN OPEN BACKLOG — MEDIUM: S-PG-MERGE-AUTH-BYPASS (story 91); TEST-ONLY-GATE-ELIGIBILITY; BC-7.3.010-FORBIDDEN-PATTERN-CI-GUARD.

---

## Cycle Summary

| Phase | Result | Date |
|-------|--------|------|
| F1 Delta Analysis | PASSED (human-approved 2026-07-07; emit-site filter scope, STANDARD criterion, DEC-157) | 2026-07-07 |
| F2 Spec Evolution | STRICT CONVERGED (19 passes / 13 fix rounds; window 17+18+19; BC-7.2.015 + H-NEW-ADF-010 + VP-571-001..005; DEC-158/DEC-159) | 2026-07-07 |
| F3 Story Decomposition | STRICT CONVERGED (10 passes / 6 fix rounds; window 8+9+10; S-ADF-CODE-MARK-1 v1.7→v1.9; DEC-160) | 2026-07-08 |
| F4 TDD Delivery | DELIVERED (PR #593 @ 7ba4cf4; Step 4.5 STRICT CONVERGED window F4-p2/p3/p4; 275 lib + 49 integration + 256-case proptest; mutation gate PASS 5m32s; issue #571 CLOSED; DEC-161) | 2026-07-08 |
| F5 Scoped Adversarial | STRICT CONVERGED (6 passes; window p4/p5/p6; fix-PR #594 @ d7875e6; 2 approved deferrals F5-OBS-001/002; DEC-162) | 2026-07-08 |
| F6 Targeted Hardening | PASS (proptest VP-571-001 @ 2000 cases; fuzz justified-skip; mutation 100% 1/1; cargo deny+audit 0 vulns/347; regression 2007/0/93; clippy+fmt clean; zero FIX-F6) | 2026-07-08 |
| **F7 Delta Convergence** | **AWAITING HUMAN AUTHORIZATION — 5/5 DIMENSIONS PASS** | **2026-07-08** |
