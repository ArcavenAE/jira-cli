---
document_type: adversarial-pass-report
issue: "#396"
pass: 6
date: "2026-05-22"
verdict: NOT-CLEAN
findings_count: 2
severities: "0 CRITICAL, 1 HIGH, 1 MEDIUM, 0 LOW"
observations_noted: 1
---

# Adversarial Pass 6 Report — Issue #396: `issue edit --field NAME=VALUE`

**Date**: 2026-05-22  
**Verdict**: NOT-CLEAN → RESOLVED  
**Findings**: 1 HIGH, 1 MEDIUM  
**Observations**: O-5 (process-gap, no action required from product-owner)

---

## Findings

### F-1 [HIGH] (dry-run control-flow placement — spec not implementable as written)

**Finding**: The `--dry-run` block in `src/cli/issue/create.rs:551-708` is
self-contained and short-circuits with `return Ok(())` at line 707 — any code placed
AFTER the dry-run block never executes under `--dry-run`. prd-delta §9 listed
`resolve_edit_fields` as step 5 and `client.edit_issue` as step 6 with NO mention of
the dry-run path split. An F3 story-writer or F4 implementer working from §9 would
naturally place `resolve_edit_fields` after the dry-run block, producing a dry-run path
that: (a) never runs editmeta or list_fields, (b) never previews `--field` entries, and
(c) never exits 64 on a bad `--field` — violating EC-3.4.015-18, EC-3.4.015-19, and
VP-396-008.

Additionally, EC-3.4.015-18 stated the read-only HTTP calls "execute as normal" but did
not make the control-flow placement requirement explicit — a reader could miss that
`resolve_edit_fields` must be invoked before `return Ok(())`.

**Resolution**:

1. **BC-3.4.015 invariant 10 added**: explicit mandatory control-flow placement rule —
   `resolve_edit_fields` MUST be called INSIDE the `if dry_run { ... }` block (before
   the `return Ok(())` short-circuit). The invariant states both (a) why placement after
   the block fails (silently skips preview and resolution errors) and (b) the concrete
   step sequence for each path (dry-run: parse → gates → resolve → render-preview →
   `return Ok(())`; live: parse → gates → resolve → `client.edit_issue` → echo).

2. **EC-3.4.015-18 amended**: added explicit statement that `resolve_edit_fields` is
   called INSIDE the dry-run block (before `return Ok(())`), with a cross-reference
   to invariant 10. Added warning that implementers MUST NOT place `resolve_edit_fields`
   after the dry-run short-circuit.

3. **prd-delta §9 restructured** into three sections:
   - "Steps common to both live and dry-run paths" (steps 1–3: guard, Gate B, Gate A)
   - "Inside the `if dry_run { ... }` block" (steps 4-dry through 7-dry: resolve →
     render-preview → `return Ok(())`)
   - "On the live path" (steps 4–7: resolve → PUT → echo)
   - Critical implementation constraint paragraph (cross-references invariant 10 and
     the three BCs/VPs violated by wrong placement).

**Files changed**:
- `.factory/specs/prd/bc-3-issue-write.md` — BC-3.4.015 invariant 10 (new), EC-3.4.015-18 (amended)
- `.factory/phase-f2-spec-evolution/prd-delta-396.md` — §9 restructured with dry-run/live split

---

### F-2 [MEDIUM] (stale footer prose)

**Finding**: `bc-3-issue-write.md` line 2121 — the `_Last updated_` prose line below
the numeric footer still read "2026-05-21: +3 BCs (BC-3.4.012..014) ... Section 3.4
header updated to 14 contracts." This was not advanced for issue #396 F2, which added
BC-3.4.015..017 and updated Section 3.4 to 17 contracts.

Additionally, this prose surface was not listed in prd-delta §11's count surfaces table,
making it invisible to future delta authors and ensuring it would be forgotten again.

**Resolution**:

1. **`_Last updated_` prose advanced**: updated to "2026-05-22 (issue #396 F2): +3 BCs
   (BC-3.4.015..017) — BC-3.4.015 (`issue edit --field` string/number/date/datetime/user
   field single-key path, with editmeta validation, fields.json cache, and dry-run
   invariants), BC-3.4.016 (`issue edit --field` single-select `option` field), BC-3.4.017
   (`--field` multi-key/`--jql` rejection Gate A and flag-overlap Gate B); Section 3.4
   header updated to 17 contracts. Previous update: [prior entry preserved]..."

2. **prd-delta §11 count surfaces table updated**: new row added for
   `bc-3-issue-write.md _Last updated_ prose` (Before: "2026-05-21 ... 14 contracts";
   After: "2026-05-22 ... 17 contracts").

3. **prd-delta §11 footnote extended**: note added that this prose line is NOT validated
   by either guard script (Surface H parses only the numeric footer); process-gap O-5
   acknowledged.

**Files changed**:
- `.factory/specs/prd/bc-3-issue-write.md` — `_Last updated_` prose line advanced
- `.factory/phase-f2-spec-evolution/prd-delta-396.md` — §11 table row + footnote

---

## Observation

### O-5 (process-gap): `_Last updated_` prose is an unguarded surface

The guard scripts validate numeric count surfaces (Surfaces A–H) but not the
`_Last updated_` narrative prose below the numeric footer. This is a known gap.
No script change required from product-owner this pass — noted as a process-gap follow-up.

---

## Resolution Summary

| Finding | Severity | Resolution |
|---------|----------|------------|
| F-1 | HIGH | BC-3.4.015 invariant 10 added (mandatory dry-run control-flow placement); EC-3.4.015-18 amended with explicit placement requirement; prd-delta §9 restructured into common/dry-run/live sub-paths with critical implementation constraint warning. |
| F-2 | MEDIUM | `_Last updated_` prose advanced to 2026-05-22 / BC-3.4.015..017 / 17 contracts. prd-delta §11 table row and footnote updated to track this surface. |

**Final VP count**: 12 (VP-396-001 through VP-396-012) — unchanged.

**Guard scripts**:
- `check-spec-counts.sh`: exit 0
- `check-bc-cumulative-counts.sh`: exit 0 (583 total across 8 files; Surface H footer verified)
