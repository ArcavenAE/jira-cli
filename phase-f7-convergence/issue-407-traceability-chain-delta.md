---
document_type: f7-traceability-chain-delta
feature: issue-407 / S-407
spec_version: v1.5.0 (no version bump — EC addition only)
pr: "#411"
pr_sha: 6eb2535
date: 2026-05-25
producer: architect-agent
depends_on_chain: issue-396-traceability-chain-delta.md
---

# Traceability Chain — S-407 Delta

This document records the end-to-end traceability for the S-407 delta: `--label`
conflict-block positive regression coverage (10 tests) + structural meta-test (2
tests). PR #411 squash-merged @ `6eb2535` on `develop`, 2026-05-25.

The S-407 delta is APPENDED to the traceability chain. Prior feature deltas:
- S-388: `traceability-chain-delta.md`
- S-398: `issue-398-traceability-chain-delta.md`
- S-396 + FIX-F5-001: `issue-396-traceability-chain-delta.md`

---

## BC → EC → Tests → Implementation → Verification

### BC-3.4.017 invariant 2 + EC-3.4.017-14 — `--label` Conflict Block Completeness

#### Behavioral Contract Anchor

| Link | Artifact |
|------|----------|
| **Behavioral Contract** | `BC-3.4.017` in `.factory/specs/prd/bc-3-issue-write.md` |
| **Invariant** | Invariant 2: "The `--label` conflict block in `handle_edit` must enumerate every flag in `(BULK_SUPPORTED \ {label}) ∪ REJECTED_IN_BULK`. The block is mechanically enforced complete by `test_label_conflict_block_lists_every_relevant_flag`." (Cross-reference to EC-3.4.017-14 added in F2.) |
| **Edge Case (new)** | EC-3.4.017-14: The `--label` conflict block at `src/cli/issue/create.rs::handle_edit::if !labels.is_empty()` is mechanically enforced complete by `test_label_conflict_block_lists_every_relevant_flag` (in `create.rs::tests`). The meta-test parses the conflict-block source via `include_str!("create.rs")`, extracts every `conflicting.push("--<flag>")` literal, and asserts the extracted set equals `(BULK_SUPPORTED \ {"label"}) ∪ REJECTED_IN_BULK`. A regression that drops any `conflicting.push` line or adds a new Edit field without extending the conflict block fails this meta-test. [Issue #407] |
| **Prior EC** | EC-3.4.017-13 (FIX-F5-001, PR #406): `--label` + `--field` conflict block guard established the pattern. EC-3.4.017-14 generalizes coverage to all 12 entries. |
| **Story** | `S-407` — 16 ACs, 12 test deliverables, 1 SP, LOW criticality |
| **F2 PRD delta** | `.factory/phase-f2-spec-evolution/prd-delta-407.md` |
| **No new VPs** | The structural meta-test is an inline verification artifact for BC-3.4.017 invariant 2; it operates on source-text structure, not observable runtime behavior. No standalone VP is warranted. |

---

#### Implementation: Modified Files

| File | Delta | What S-407 Added |
|------|-------|-----------------|
| `src/cli/issue/create.rs` | +159 LOC | (1) Guard comment at `let mut conflicting` declaration (~line 442–446) reserving the variable name for the `--label` block. (2) `test_label_conflict_block_lists_every_relevant_flag` in existing `#[cfg(test)]` block: reads source via `include_str!("create.rs")`, extracts `conflicting.push("--<flag>")` literals via line-scan, asserts `BTreeSet<String>` equality against expected set derived from `(BULK_SUPPORTED \ {"label"}) ∪ REJECTED_IN_BULK`. (3) `test_label_conflict_block_extractor_pin_12_members` R2 pin: asserts exactly 12 members are extracted. No production logic changed. |
| `tests/issue_edit_field.rs` | +448 LOC | 10 positive regression tests (AC-001..AC-010): one per previously-untested conflict-block entry. Pattern: `Mock::given(any()).expect(0)` catch-all + `jr issue edit TEST-1 --label add:x --<flag> [value]` + assert exit 64 + assert stderr contains `"--label cannot be combined with"` (separate) + assert stderr contains `"--<flag>"` (separate). |

**No new source files. No Cargo.toml changes. No new dependencies.**

---

#### Test Deliverables — Full Enumeration (12 tests)

| # | Test Name | File | Type | AC | Notes |
|---|-----------|------|------|----|-------|
| 1 | `test_label_plus_priority_rejected_with_exit_64_no_http` | `tests/issue_edit_field.rs` | integration | AC-001 | Standard pattern |
| 2 | `test_label_plus_type_rejected_with_exit_64_no_http` | `tests/issue_edit_field.rs` | integration | AC-002 | Standard pattern |
| 3 | `test_label_plus_team_rejected_with_exit_64_no_http` | `tests/issue_edit_field.rs` | integration | AC-003 | Standard pattern |
| 4 | `test_label_plus_points_rejected_with_exit_64_no_http` | `tests/issue_edit_field.rs` | integration | AC-004 | Standard pattern |
| 5 | `test_label_plus_no_points_rejected_with_exit_64_no_http` | `tests/issue_edit_field.rs` | integration | AC-005 | Boolean flag, no value arg |
| 6 | `test_label_plus_parent_rejected_with_exit_64_no_http` | `tests/issue_edit_field.rs` | integration | AC-006 | Standard pattern |
| 7 | `test_label_plus_no_parent_rejected_with_exit_64_no_http` | `tests/issue_edit_field.rs` | integration | AC-007 | Boolean flag, no value arg |
| 8 | `test_label_plus_description_rejected_with_exit_64_no_http` | `tests/issue_edit_field.rs` | integration | AC-008 | Standard pattern |
| 9 | `test_label_plus_description_stdin_rejected_with_exit_64_no_http` | `tests/issue_edit_field.rs` | integration | AC-009 | Boolean flag; conflict guard fires before stdin read — no pipe needed |
| 10 | `test_label_plus_markdown_rejected_with_exit_64_no_http` | `tests/issue_edit_field.rs` | integration | AC-010 | MUST pair with `--description "text"` — pre-guard at line 357 fires first otherwise; two SEPARATE stderr assertions |
| 11 | `test_label_conflict_block_lists_every_relevant_flag` | `src/cli/issue/create.rs` `#[cfg(test)]` | unit (meta-test) | AC-011, AC-012, AC-016 | Global scan via `include_str!`; BTreeSet equality; covers deletion + addition failure modes |
| 12 | `test_label_conflict_block_extractor_pin_12_members` | `src/cli/issue/create.rs` `#[cfg(test)]` | unit (R2 pin) | AC-013 | Asserts exactly 12 members extracted from live source; extractor-logic regression anchor |

**Coverage before S-407:** 2/12 conflict-block entries tested (EC-3.4.017-13 `--label`+`--field`, EC-3.4.017-12 `--label`+`--summary`).
**Coverage after S-407:** 12/12 conflict-block entries tested (all entries) + structural enforcement via meta-test.

---

#### AC → Test → Source Bidirectional Map

| AC | Test | Traces To | Source |
|----|------|-----------|--------|
| AC-001 | `test_label_plus_priority_rejected_with_exit_64_no_http` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `create.rs` `conflicting.push("--priority")` line |
| AC-002 | `test_label_plus_type_rejected_with_exit_64_no_http` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `create.rs` `conflicting.push("--type")` line |
| AC-003 | `test_label_plus_team_rejected_with_exit_64_no_http` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `create.rs` `conflicting.push("--team")` line |
| AC-004 | `test_label_plus_points_rejected_with_exit_64_no_http` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `create.rs` `conflicting.push("--points")` line |
| AC-005 | `test_label_plus_no_points_rejected_with_exit_64_no_http` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `create.rs` `conflicting.push("--no-points")` line |
| AC-006 | `test_label_plus_parent_rejected_with_exit_64_no_http` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `create.rs` `conflicting.push("--parent")` line |
| AC-007 | `test_label_plus_no_parent_rejected_with_exit_64_no_http` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `create.rs` `conflicting.push("--no-parent")` line |
| AC-008 | `test_label_plus_description_rejected_with_exit_64_no_http` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `create.rs` `conflicting.push("--description")` line |
| AC-009 | `test_label_plus_description_stdin_rejected_with_exit_64_no_http` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `create.rs` `conflicting.push("--description-stdin")` line |
| AC-010 | `test_label_plus_markdown_rejected_with_exit_64_no_http` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `create.rs` `conflicting.push("--markdown")` line; pre-guard at line 357 |
| AC-011 | `test_label_conflict_block_lists_every_relevant_flag` | BC-3.4.017 inv.2 + EC-3.4.017-14 | `include_str!("create.rs")` global scan |
| AC-012 | `test_label_conflict_block_lists_every_relevant_flag` | BC-3.4.017 inv.2 + EC-3.4.017-14 | expected set = `(BULK_SUPPORTED \ {"label"}) ∪ REJECTED_IN_BULK` |
| AC-013 | `test_label_conflict_block_extractor_pin_12_members` | EC-3.4.017-14 R2 pin | extracted set has 12 members |
| AC-014 | Guard comment in `create.rs` ~line 442–446 | EC-3.4.017-14 | `// NOTE: the variable name 'conflicting' is reserved…` |
| AC-015 | `test_label_plus_markdown_rejected_with_exit_64_no_http` | EC-3.4.017-14 assertion pattern | Two SEPARATE `stderr.contains(...)` checks — NOT one concatenated substring |
| AC-016 | `test_label_conflict_block_lists_every_relevant_flag` | EC-3.4.017-14 | `issue_type → "--type"` explicit mapping (not implicit snake→kebab) |

---

#### F5 Adversarial Verification

| Pass | Date | Verdict | HIGH | MEDIUM | LOW | Notes |
|------|------|---------|------|--------|-----|-------|
| 1 | 2026-05-25 | CLEAN | 0 | 0 | 4 | O-1/O-2: pre-existing stale citations (→ #408); O-3: single-line extractor by design; O-4: 12/12 coverage confirmation |
| 2 | 2026-05-25 | CLEAN | 0 | 0 | 0 | 11 positive confirmations; novelty: NONE |
| 3 | 2026-05-25 | CLEAN | 0 | 0 | 0 | 8 LOW re-derived from pass 1; convergence declared |

Trajectory: `4→0→0` (LOW). HIGH at every pass: `0→0→0`. Convergence at 3 consecutive CLEAN.
Reference: `.factory/phase-f5-adversarial/issue-407/convergence-summary.md`

---

#### Mutation Verification

| Metric | Value |
|--------|-------|
| Diff scope | `699a5fd..6eb2535` (S-407 delta) |
| Mutants found | 1 |
| Mutants caught | 1 |
| Mutants missed | 0 |
| **Kill rate** | **100% (1/1)** |
| Mutant | `src/cli/issue/create.rs:304:5: replace handle_edit -> Result<()> with Ok(())` |
| Caught by | 10 new `test_label_plus_*` tests asserting exit 64; body-replacement gives exit 0 — caught immediately |

The test-only additions in `tests/issue_edit_field.rs` produce zero mutants (correct per `mutants.toml` `examine_globs`). The 2 new meta-tests in `#[cfg(test)]` similarly produce no mutants (non-production code). The single in-scope mutant on `handle_edit` body-replacement is killed by the positive regression corpus.

---

#### Full Verification Chain

| Verification Type | Result | Evidence |
|------------------|--------|----------|
| F2 spec adversarial | 4 passes; 3/3 CLEAN (passes 2/3/4); trajectory 7→2→1→2 (all LOW) | `prd-delta-407.md` |
| F4 per-story adversarial | 3 passes; all CLEAN; Copilot R1 3 findings all REFUTED → R2 0 inline (CONVERGED) | PR #411 |
| F5 scoped adversarial | 3 passes; all CLEAN; trajectory 4→0→0 | `.factory/phase-f5-adversarial/issue-407/convergence-summary.md` |
| Kani formal proofs | N/A — test-only cycle; no new pure-function logic | No Kani infra in project |
| Fuzz testing | N/A — no new external-input parser | Not applicable |
| Mutation testing | **100% (1/1 caught)** | `.factory/phase-f6-hardening/issue-407-summary.md` §1 |
| `cargo audit` | PASS — 0 vulnerabilities, 341 crates scanned | F6 summary §2 |
| `cargo deny check` | PASS — advisories/bans/licenses/sources all ok | F6 summary §2 |
| Security pattern review | PASS — `jr_cmd` constrained fixture; no real credentials; meta-tests pure-Rust source inspection; zero attack surface | F6 summary §2 |
| Purity boundary | N/A — no production logic changed; 5-line comment block only | F6 summary §5 |
| Full regression suite | **PASS — 1,483 passed, 0 failed** (18 gated-ignored) | F6 summary §3 |
| CI on merge commit | **success** (2m40s, run ID 26419501809, 2026-05-25T20:57Z) | F6 summary §6 |

---

## Cross-Reference to Existing Traceability

S-407 is a DIRECT continuation of the S-396 FIX-F5-001 delta. The dependency chain is:

```
BC-3.4.017 (invariant 2)
  → EC-3.4.017-13 (FIX-F5-001, PR #406 @ 699a5fd): --label + --field guard established
  → EC-3.4.017-14 (S-407, PR #411 @ 6eb2535): completeness enforcement generalized
    → test_label_conflict_block_lists_every_relevant_flag (meta-test)
    → test_label_plus_{priority,type,team,points,no_points,parent,no_parent,description,description_stdin,markdown}_rejected_with_exit_64_no_http (10 regression tests)
    → test_label_conflict_block_extractor_pin_12_members (R2 pin)
```

The S-396 FIX-F5-001 drift items DI-396-F5-1 and DI-396-F5-2 (recorded in
`issue-396-traceability-chain-delta.md`) are RESOLVED by S-407:

| DI | Description | Resolution |
|----|-------------|------------|
| DI-396-F5-1 | 10/12 conflict entries untested | RESOLVED — 10 positive regression tests bring coverage to 12/12 |
| DI-396-F5-2 | No structural/meta-test enforcing block completeness | RESOLVED — meta-test EC-3.4.017-14 is the mechanical enforcement witness |

---

## Remaining Drift Items (not resolved by S-407)

| ID | Description | Issue | Status |
|----|-------------|-------|--------|
| O-1 (F5 pass 1) | Pre-existing stale code-comment line citation in `test_343_every_edit_field_is_categorized` (cites lines ~426-465 for C-1 block, actual 569-603) | #408 | Routed — NOT a new drift item |
| O-2 (F5 pass 1) | Pre-existing stale spec citation in EC-3.4.017-10 for `parse_field_kv` line range (cites 1982-1997; actual 2245-2260) | #408 | Routed — NOT a new drift item |
| DI-396-F5-3 | clap `--field` help text does not mention `--label` exclusion (UX papercut) | No ticket | DEFERRED — cosmetic |
| DI-396-F5-4 | EC-3.4.017-13 line-anchor citation class — will drift as bc-3 is edited | #408 | Routed to same class as O-1/O-2 |

---

## Traceability Append Note

The S-407 entries in this file extend the chain from `issue-396-traceability-chain-delta.md`.
Combined: BC-3.4.017 is now fully traced from its 3 behavioral sub-contracts (Gate A, Gate B,
`--label` conflict) through 12/12 coverage tests, the structural meta-test, and the R2 pin.

If a project-level unified traceability matrix is produced in a future cycle, the S-407
entries should be merged with:
`bc_ids: [BC-3.4.017]`, `story: S-407`, `ec: EC-3.4.017-14`,
`pr: #411`, `pr_sha: 6eb2535`.
