# Step 4.5 Convergence Record — S-SOH-589-1

**Story:** S-SOH-589-1 (story #105) — tolerate id-absent editmeta allowedValues in `issue edit --field`
**Criterion:** STRICT (any delta-attributable LOW resets window)
**Result:** CONVERGED
**Date:** 2026-07-09

## Summary

| Metric | Value |
|--------|-------|
| Total passes | 7 |
| Fix rounds | 4 |
| Convergence window | p5 / p6 / p7 (CLEAN×3) |
| Finding trajectory | 3 → 4 → 0 → 1 → 0 → 0 → 0 |
| Human overrides | 0 |
| Delta-attributable findings resolved | All |

STRICT CONVERGED: clean window p5/p6/p7. Zero human overrides throughout all 7 passes.

## Finding Trajectory

```
p1: 3  (2 LOW + 1 INFO)
p2: 4  (1 MED + 1 LOW + 1 LOW + 1 OBS)       ← genuine catch; fix round 2
p3: 0  (2 INFO — non-delta, non-actionable)    ← window reset by p2 MED
p4: 1  (1 LOW + 1 OBS)                         ← partial symbol-form propagation
p5: 0  (INFO only)                              ← window start
p6: 0  (INFO only)
p7: 0  (INFO only)
```

## Per-Pass Details

### Pass 1 (3 findings: 2 LOW + 1 INFO)

**Findings:**

| ID | Severity | Description | Action |
|----|----------|-------------|--------|
| P1-F1 | LOW | Defensive-guard comment in `field_resolve.rs` for the `id.is_none()` skip path was absent; missing inline comment left intent implicit | Added `// None-id values lack a stable key; skip in partial match (EC-3.4.016-8)` |
| P1-F2 | LOW | Test `test_field_resolve_exits_64_when_all_values_lack_id` did not assert the exact exit-64 error message substring; only exit code checked | Added `contains("no selectable values")` assertion pin |
| P1-F3 | INFO | Test adjacency: the two new serde tests lived in `src/types/jira/editmeta.rs` inline module while the resolver tests lived in integration file; architecturally sound but noted as observation | No action (INFO — pre-existing adjacency convention) |

**Fix round 1:** P1-F1 + P1-F2 fixed. P1-F3 deferred (INFO).

---

### Pass 2 (4 findings: 1 MED + 1 LOW + 1 LOW + 1 OBS — genuine catch)

**Findings:**

| ID | Severity | Description | Action |
|----|----------|-------------|--------|
| P2-F1 | MED | Substring-guard test gap: `test_field_resolve_exits_64_when_all_values_lack_id` asserted `contains("no selectable values")` but the actual error message emitted by the fix was `"no values with a stable id"` — the pin was testing the wrong string and would pass vacuously | Fixed assertion to match actual emitted string |
| P2-F2 | LOW | Count-drift: the STORY-INDEX.md row still showed status `approved` rather than `in_progress`; minor bookkeeping drift | Updated during fix round 2 burst |
| P2-F3 | LOW | Line-cite drift: `step-4-5-convergence.md` (this file's draft stub) cited stale line ranges from `field_resolve.rs` that shifted after the Option<String> change | Corrected to symbol-form citations |
| P2-OBS | OBS | The `id.is_none()` pin (`test_allowed_value_id_none_not_included_in_match_candidates`) was authored as an adversarial-round test after Green Gate; noted for completeness | No action (observation) |

**Fix round 2:** P2-F1 (genuine MED catch) + P2-F2 + P2-F3 fixed. Window reset.

---

### Pass 3 (0 actionable; 2 INFO)

**Findings:**

| ID | Severity | Description | Action |
|----|----------|-------------|--------|
| P3-I1 | INFO | `AllowedValue.id` Option change is a valid deserialization relaxation matching Atlassian's schema; no semantic concerns | No action |
| P3-I2 | INFO | Fix scope is minimal (2 type sites + 4 call sites + 2 test files) — well-bounded, no sprawl | No action |

Window reset still active from p2 MED (must complete fresh clean run of 3).

---

### Pass 4 (1 LOW + 1 OBS)

**Findings:**

| ID | Severity | Description | Action |
|----|----------|-------------|--------|
| P4-F1 | LOW | Partial symbol-form propagation: the CLAUDE.md Gotchas cite for `issue edit --field` constraints still used bare `field_resolve.rs:NN-MM` line-range form rather than `field_resolve.rs::resolve_edit_fields` symbol form (post-#408 convention) | Updated to symbol-form |
| P4-OBS | OBS | Mutation gap: the `id.is_none()` skip-in-partial-match path was not covered by a dedicated mutation test; pre-empted via adversarial-round test 50 (added as fix round 4 companion) | No action (pre-empted) |

**Fix round 3:** P4-F1 fixed. P4-OBS pre-empted by existing adversarial-round test 50.

Window started fresh at p5.

---

### Pass 5 (CLEAN — INFO only)

No actionable findings. INFO observations only (previously noted spec-changelog range-shift verified non-defect per factory commit). Window start: p5.

---

### Pass 6 (CLEAN — INFO only)

No actionable findings. Hygiene observations noted and fixed as cosmetic (trailing whitespace in one comment; no semantic impact). Window continues: p5/p6.

---

### Pass 7 (CLEAN — INFO only)

No actionable findings. INFO only (observation: BC-3.4.016-8 prose is consistent with implementation). Window complete: p5/p6/p7.

**STRICT CONVERGED — 3-pass clean window achieved.**

## Fix Round Summary

| Round | Pass that triggered | Changes |
|-------|---------------------|---------|
| 1 | p1 | Defensive-guard comment + error-message assertion pin |
| 2 | p2 | Error-message substring corrected (genuine MED catch); STORY-INDEX bookkeeping; line-cite → symbol-form |
| 3 | p4 | CLAUDE.md Gotcha cite → symbol-form (LOW propagation) |
| 4 | p4 companion | Adversarial-round test 50 pre-empted mutation gap (OBS) |

## Deferred Items

None. All findings resolved or classified INFO/OBS with no residual delta-attributable gaps.
