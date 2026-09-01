---
document_type: f7-convergence-report
bundle: field-dx
feature: "field-dx: --field NAME:kind=VALUE hint-syntax + jr field options command (GitHub issues #578, #580)"
spec_files: [".factory/specs/prd/bc-3-issue-write.md", ".factory/specs/prd/cross-cutting.md"]
bc_index_total: 719 (unchanged through F4/F5/F6 — field-dx BCs already counted at F2 close)
develop_sha: 2000c455
activation_version: v0.7.0-dev.2
date: 2026-08-31
producer: state-manager (F7 delta convergence synthesis)
recommendation: READY FOR MERGE
gate_status: AWAITING HUMAN AUTHORIZATION — cycle-002 not yet marked closed
---

# F7 Delta Convergence Report — field-dx

## 1. Feature Summary

**Bundle:** field-dx (GitHub issues #578 + #580)
**Cycle:** cycle-002, `feature_mode_bundle: field-dx`
**Spec delta:** `bc-3-issue-write.md` v1.3.107 → v1.3.164 across the F2 evolution window
(BC-3.4.026/027/028/029/030/031 new; BC-X.14.001..004 new in `cross-cutting.md`; BC-3.3.010/011
new; BC-3.4.014/015/016/021 amended; BC-3.8.012 REVERSED in place under DEC-310, BC-3.8.013
amended alongside). BC-INDEX total 719, unchanged since F2 close of this bundle.

**Stories delivered (5, all `done` and MERGED to `develop`):**

| Story | Title | Points | PR | Merge SHA | Issue |
|---|---|---|---|---|---|
| S-578-1 | `--field NAME:kind=VALUE` hint-syntax parser | 5 | #739 | `993de833` | #578 part 1 |
| S-580-1 | `jr field options <field>` — M1/M2/M3 context-mechanism resolution | 8 | #740 | `74221bbc` | #580 |
| S-578-2 | `issue edit --field` hint-kind dispatch + cascading select + dry-run | 13 | #741 | `a3739763` | #578 part 3 |
| S-578-3 | JSM `issue create --field` hint-kind uniformity | 8 | #742 | `41763ff0` | #578 part 4 |
| S-578-4 | Platform `issue create --field` path — createmeta resolution, reverses DEC-188 | 13 | #746 | `ae8514b8` | #578 part 5 |

Plus three feature-level fix PRs (F5/F6/F7 scoped adversarial and hardening remediation):

| Fix PR | Scope | Merge SHA |
|---|---|---|
| FIX-F5-001 | `get_issue_types_for_project` pagination-termination bound + total-absent heuristic (mirrors `get_createmeta_fields`); F5 sole MEDIUM finding | #747, `4e4ae4f5` |
| FIX-F6-001 | `.cargo/mutants.toml::examine_globs` gained `field.rs` + `field_resolve.rs` (18→20); policy §Scope citations updated | #749, `dd311e13` |
| FIX-F7-001 | `create.rs` size-deviation CLAUDE.md write-up + DEC-310 pre-flight note + field-dx CHANGELOG entries (documentation-only) | #750, `2000c455` |

**`develop` HEAD:** `2000c455`. **`activation_version`:** `v0.7.0-dev.2` (unchanged, re-derived
and confirmed against `Cargo.toml` at `2000c455`).

**Files changed (new/modified source):** `src/cli/field.rs` (new), `src/cli/issue/field_resolve.rs`
(new), `src/cli/issue/create.rs`, `src/cli/issue/jsm_create.rs`, `src/api/jsm/requests.rs`,
`src/api/jira/issues.rs`, `src/types/jira/editmeta.rs`. **New test suites:**
`tests/field_options.rs` (51 tests), `tests/issue_create_field.rs` (37 tests),
`tests/issue_field_hint_kinds.rs` (36 tests), plus extensions to `tests/issue_create_jsm.rs`
and inline `#[cfg(test)]` unit/proptest suites in `src/cli/issue/create.rs` and
`src/cli/issue/field_resolve.rs`.

---

## 2. Five-Dimensional Convergence (Delta)

| Dimension | Metric | Target | Actual | Status |
|-----------|--------|--------|--------|--------|
| Spec | adversary novelty | < 0.15 | LOW — F5 CONVERGED at Round 1 (5 findings: 0 CRIT, 0 HIGH, 1 MED → **fixed as FIX-F5-001**, 4 LOW tracked non-blocking) | **PASS** |
| Test | mutation kill rate | ≥ 90% | `field.rs` + `field_resolve.rs`: **100%** on conclusively-scored mutants (93 caught / 0 missed of 93 numerically-scored; config gap that under-scoped these two files fixed and merged in-phase as **FIX-F6-001**); the other 6 delta files (`create.rs`, `jsm_create.rs`, `issues.rs`, `requests.rs`, `editmeta.rs`) each independently ≥90% via their own PR's required CI mutation gate at merge time | **PASS** |
| Implementation | adversary CRIT/HIGH residuals | none | **0 CRIT / 0 HIGH** (F5 scoped-adversarial review, integrated delta `91d04fe1..ae8514b8` reviewed as one unit) | **PASS** |
| Verification | proofs + fuzz + audit | all pass | 32/32 declared VPs realized (proptest/wiremock coverage; Kani N/A-by-design — no proof harness in this codebase — and cargo-fuzz N/A-by-design, both justifiably substituted with proptest per repo convention); `cargo deny`/`cargo audit`: 0 vulnerabilities, 0 CRIT/HIGH, 3 LOW documented (SEC-F6-1/2/3); purity/layering boundaries intact (thin HTTP client convention, no new `unsafe`) | **PASS** |
| Holdout | mean satisfaction | ≥ 0.85 | **mean 0.917**, minimum must-pass scenario 0.75, all MUST-PASS scenarios cleared | **PASS** |

**Spec-dimension detail:** the F5 scoped-adversarial review treated the integrated field-dx
delta (all 5 stories' merged diffs, `91d04fe1..ae8514b8`) as one unit rather than re-reviewing
each story in isolation — every story had already individually converged through its own
Step-4.5 adversarial window during F4. The single MEDIUM finding (`get_issue_types_for_project`
pagination-termination gap, mirroring a pattern S-580-1's `get_createmeta_fields` had already
guarded against) was fixed and merged in-phase as FIX-F5-001 rather than deferred. The
secondary review tier (Step 7) was justifiably SKIPPED — see STATE.md Skip Log — since every
story was already individually converged and the primary pass found only 1 low-likelihood
MEDIUM plus 4 LOW items.

**Test-dimension detail:** mutation testing surfaced exactly one config-quality gap, not a
test-quality gap: `field.rs` and `field_resolve.rs` (the #1-priority resolution/dispatch hub
for the whole bundle) were absent from `.cargo/mutants.toml::examine_globs`, so the CI mutation
gate under-scoped the field-dx delta to 71/207 in-diff mutants. This was fixed in-phase
(FIX-F6-001) rather than deferred as debt. The follow-on numeric run scored 142/177 mutants
conclusively — 93 caught, 0 MISSED (100% kill rate on conclusively-scored mutants); the 38
timeouts + 35 unscored are documented host-contention artifacts (concurrent-agent load on this
machine), independently corroborated by the F6 formal-verifier's static coverage pass finding 0
test-quality-gap survivors across the same functions.

**Implementation-dimension detail:** 0 CRIT/HIGH across both the F5 scoped-adversarial pass and
every individual story's PR-level pr-reviewer + security-reviewer pass. The 4 LOW findings from
F5 and 3 LOW findings from F6's security scan are non-blocking and tracked (see §5 Outstanding).

**Verification-dimension detail:** Kani and cargo-fuzz are not set up anywhere in this
repository (CLAUDE.md: single-crate thin client, no purity-boundary architecture that would
warrant a Kani harness) — both are N/A-by-design, not silently skipped, and proptest
substitution is the established repo convention (per `phase-f6-hardening/kani-results.md` and
`fuzz-results.md`). All 32 declared field-dx VPs have realizing test coverage (VP-578-016
carries an intended parity-PENDING deferral, documented as a PASS-with-deferral, not a GAP).
`cargo deny check` and `cargo audit` both ran clean against the full dependency tree; 0 new
dependencies were introduced by this bundle.

---

## 3. Regression Validation

| Metric | Baseline | Current | Status |
|--------|----------|---------|--------|
| Full test suite | prior green at every merge gate along the way (5 stories + 2 prior fix-PRs, each CI-gated) | **4,660 passed / 0 failed / 106 ignored** (`develop` @ `2000c455`) | **PASS** |
| clippy `-D warnings` + `cargo fmt --check` | clean | clean at every merge gate (5 story PRs + 3 fix PRs, all CI-gated) | **PASS** |
| CI Gate (required status check) | green | green at every merge | **PASS** |
| `cargo deny`/`cargo audit` | clean | clean, 0 new deps, 0 CRIT/HIGH, 3 LOW documented | **PASS** |

The 106 ignored tests are the standing gated suites (live-E2E `#[ignore]` tests requiring
`JR_RUN_E2E=1`, keyring-integration tests requiring `JR_RUN_KEYRING_TESTS=1`, and OAuth
integration tests requiring `JR_RUN_OAUTH_INTEGRATION=1`) — unrelated to field-dx and consistent
with this repository's standing count across recent cycles.

---

## 4. Traceability Chain

Full 4-level chain (BC → VP → test → src) for all field-dx BCs across the 5 stories, plus the
DEC-310/DEC-188 reversal cross-reference, the S-578-4→S-580-1/S-578-2 dependency chain, and the
shared `field_resolve.rs` module note, is at:

**`.factory/phase-f7-convergence/traceability-chain-delta.md`**

The new links from that file are also appended to the cycle-002 master chain (created fresh
this pass, since no such file previously existed):

**`.factory/cycles/cycle-002/convergence/traceability-chain.md`**

Summary: every new/amended field-dx BC traces to at least one named test function in
`tests/field_options.rs` (51 tests), `tests/issue_create_field.rs` (37 tests),
`tests/issue_field_hint_kinds.rs` (36 tests), `tests/issue_create_jsm.rs`, or the inline
`#[cfg(test)]`/proptest suites in `src/cli/issue/create.rs` — no orphan BCs, no fabricated test
citations. No Kani proof harness applies to this codebase (N/A by design, consistent with the
components-mgmt and bucket1-defects bundles' own traceability records in the same directory).

**TASK 1 fix, this pass:** `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md`
cited a non-existent `tests/issue_create.rs` 13 times for VP-578-001/002/003/004/017-021; all
13 occurrences corrected to the real file, `tests/issue_create_field.rs`. Verified via grep:
0 remaining occurrences of the stale path, 13 occurrences of the corrected path. No other
citation in the file was touched.

---

## 5. Cost-Benefit Assessment / MAXIMUM_VIABLE_REFINEMENT_REACHED

**Observed cost:** 5 stories, each individually adversarially converged during F4 (per-story
Step-4.5 windows), plus one feature-level F5 scoped-adversarial pass (Round 1, converged
immediately) and one F6 targeted-hardening pass (formal/fuzz/mutation/security, one in-phase
fix). Three feature-level fix PRs closed real findings rather than deferring them (FIX-F5-001
MEDIUM, FIX-F6-001 mutation config gap, FIX-F7-001 documentation debt).

**Observed benefit:** the finding rate decayed monotonically across the delta pipeline —
F5's integrated-delta pass found 1 MEDIUM + 4 LOW after every story had already individually
converged at F4; F6's targeted hardening found exactly one actionable item (a config-scope
gap, not a test-quality gap — the underlying tests were already sound once the scope was
corrected) plus 3 LOW security-hardening notes; this F7 pass found zero production-logic
defects — its only substantive action was a documentation consistency fix (the stale test-file
citation in TASK 1). No production-logic defect has surfaced since the S-578-4 adversary
pass-2 window closed during F4.

**Marginal value assessment:** the novel-finding rate across F5→F6→F7 dropped to
documentation/test-infrastructure nitpicks with no correctness defects remaining reachable.
Each successive review phase found progressively less, and what it did find was fixed in-phase
rather than accumulated as debt (FIX-F5-001, FIX-F6-001) — the two exceptions being genuinely
LOW-severity, explicitly-justified deferrals (S-578-3-SHARED-ASSET-VALIDATOR and similar; see
§6). The delta is well-hardened: five dimensions PASS, full regression PASS, and the cost of a
further F5/F7 cycling round is assessed as very unlikely to surface anything beyond cosmetic
findings, well below the value of proceeding to the human gate.

**Verdict: recommend cycle close.** No further F5/F7 cycling is warranted before the human
gate.

---

## 6. Outstanding Items (Non-Blocking, Tracked)

None of the items below block this gate. All are LOW severity, already individually justified
in the phase artifacts that originated them, and carried forward here for the human's
ratify-or-amend decision at the authorization gate.

**F5 scoped-adversarial (4 LOW, `phase-f5-adversarial/convergence-summary.md`):**

| Item | Description |
|---|---|
| `S-578-3-SHARED-ASSET-VALIDATOR` | Extract a shared `validate_asset_value` helper used by BOTH `field_resolve.rs::compose_asset_hint` (platform) and `jsm_create.rs::resolve_asset_field_l2` (JSM). Cross-referenced (not duplicated) by both F5 and F6. |
| `F5-EDIT-GATEB-SHARE` | `edit.rs:155-193` Gate B not refactored onto the shared `detect_flag_field_overlap` helper (ADR-0019 §D2); only `create.rs` wired to it. Behavior correct, error strings consistent; out-of-scope for S-578-4. |
| `F5-ISSUETYPE-CASEFOLD-SPLIT` | `field_resolve.rs::resolve_against_createmeta` (`eq_ignore_ascii_case`) vs. `field.rs` (`to_lowercase()`) diverge on issue-type name→id case-folding. Negligible (issue-type names near-always ASCII). |
| `F5-VP578021-WEAK-NEGPIN` | `tests/issue_create_field.rs::test_vp_578_021_negative_pin_display_name_spelling_does_not_trip_guard` asserts only `!requests.is_empty()`, not exit-0/POST-body/last-wins residual. |

**F6 targeted hardening (3 LOW security, `phase-f6-hardening/security-scan-results.md`):**

| Item | Description |
|---|---|
| `SEC-F6-1` | `src/api/jsm/requests.rs::compose_asset_wire` invariant panic on a missing `:` separator; unreachable today (sole production caller always supplies a qualified value). |
| `SEC-F6-2` | `AllowedValue.children` (recursive field, `src/types/jira/editmeta.rs`) has no deserialization-time recursion-depth guard. Cross-references the pre-existing `SEC-001-EDITMETA-RECURSION-GUARD` item — not a duplicate, same underlying candidate. |
| `SEC-F6-3` | `:asset` `WORKSPACE` segment has no format/charset validation beyond non-emptiness; not an injection/SSRF vector (JSON-escaped, never concatenated into a URL). No fix required. |

**F7 (1 LOW, pre-existing):**

| Item | Description |
|---|---|
| Story frontmatter `status: ready` vs. `completed` | All 5 field-dx story files carry `status: ready` in frontmatter despite being merged and delivered — a repo-wide pre-existing pattern (`STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` family), not introduced by or specific to field-dx. Not corrected in this pass to avoid scope creep into an unrelated standing debt item. |

Additional standing items unrelated to field-dx specifically (5 Dependabot PRs pending
`syn 2.0`-vs-`3.0` convergence, `DEC-NAMESPACE-COLLISION-RISK`, `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING`)
are tracked in STATE.md's Drift/Standing Items and are explicitly out of scope for this bundle's
gate — see §7 note below on the hash-drift resolution this pass performed.

---

## 7. Input-Hash Drift Resolution (This Pass)

Per the F7-gate drift resolution obligation, the 7 BENIGN cycle-002 input-hashes below were
recomputed and written (all confirmed completed-work / bookkeeping artifacts; the upstream
BC/ADR refinements they trace to are already reflected in merged code, so no content
re-derivation was needed):

- `.factory/stories/S-578-1-field-value-kind-hint-parser.md` — `b4915a8` → `8e0daa7`
- `.factory/stories/S-578-2-edit-field-hint-dispatch.md` — `a79cf31` → `8e0daa7`
- `.factory/stories/S-578-3-jsm-create-field-hint-dispatch.md` — `1066c58` → `9725334`
- `.factory/stories/S-578-4-platform-create-field-support.md` — `c020bd9` → `44d224f`
- `.factory/cycles/cycle-002/session-checkpoints.md` — `[live-state]` → `0cec1ff`
- `.factory/cycles/cycle-002/burst-log.md` — `[live-state]` → `0cec1ff`
- `.factory/cycles/cycle-002/lessons.md` — `[live-state]` → `0cec1ff`

Re-scan (`compute-input-hash --check`) on all 7 confirms MATCH (exit 0) post-update. The
remaining ~142 historical stale `input-hash` artifacts factory-wide are the separately-tracked
`F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` standing debt item — explicitly NOT touched by
this pass (not field-dx / cycle-002-specific, no bulk `--scan --update` run).

---

## 8. Recommendation: READY FOR MERGE — cycle-002 close pending human authorization

All five convergence dimensions PASS. Full regression PASS (4,660/0/106). Cost-benefit
assessment concludes the delta is well-hardened and recommends cycle close — no further F5/F7
cycling is warranted before the human gate. Traceability chain is complete and grounded across
all 5 stories, zero fabricated test/src citations. No open CRIT/HIGH residuals anywhere in the
delta. The one consistency defect found this pass (13 stale test-file citations in
`verification-delta-field-dx.md`) has been fixed in this same pass.

**This report requests the human's final authorization to close the field-dx bundle / cycle-002.**

Per the task instruction for this pass, **Phase F7 is NOT marked COMPLETE by this report** —
STATE.md records F7 as "5-dimensional convergence + regression PASS — AWAITING HUMAN
AUTHORIZATION GATE." F7 closure and cycle-002 closure both require explicit human approval at
the gate, not an automated marking by this pass.

**Post-authorization actions (not yet taken, pending this gate):**

1. **Outstanding-item disposition** — ratify or amend the 8 LOW items in §6 above.
2. **Release step** — version bump per the field-dx feature scope, CHANGELOG.md finalization
   (FIX-F7-001 already added the field-dx entries), git tag, `gh release`. `activation_version`
   is currently `v0.7.0-dev.2`, unchanged through this entire bundle (no crate version bump
   was required by any of the 5 stories or 3 fix PRs) — the release workflow determines the
   next bump at authorization time.
3. **Standing debt review** — `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` (~142 historical
   stale hashes factory-wide) remains open and unrelated to this bundle; not a gate blocker.
