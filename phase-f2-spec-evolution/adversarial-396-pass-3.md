---
document_type: adversarial-report
issue: "#396"
pass: 3
date: "2026-05-22"
verdict: NOT-CLEAN
critical: 0
high: 0
medium: 3
low: 2
observations_addressed: 1
total_findings: 5
resolution_status: resolved
---

# Adversarial Review — Issue #396 F2 Pass 3

**VERDICT: NOT-CLEAN** (0 CRITICAL, 0 HIGH, 3 MEDIUM, 2 LOW, 1 Observation addressed)

All findings are new — no retreads of pass-1 or pass-2.

---

## MEDIUM Findings

### P3-MED-001 — prd-delta-396.md §7 stale after pass-1/pass-2 EC additions

`prd-delta-396.md §7 "Error and Edge Cases (summary)"` table was stale: it listed only
EC-3.4.015-1..10, EC-3.4.016-1..3, EC-3.4.017-1..8. Pass-1 and pass-2 added many ECs
to the BC body but never re-synced §7 — notably the entire cache EC surface
(EC-3.4.015-14/-15/-16) and all pass-1/pass-2 additions were absent.

**Resolution**: FIXED. The enumerated table has been **replaced with an authoritative-
pointer section** (preferred over re-syncing, which would require ongoing maintenance):

> "The enumerated EC table that was originally here is now stale and has been removed to
> prevent recurring drift. Authoritative EC catalog: see the §Edge Cases sections of
> BC-3.4.015, BC-3.4.016, BC-3.4.017."

The BC body is the single source of truth. This approach eliminates the class of drift
where §7 falls behind BC body edits.

---

### P3-MED-002 — §11 Coverage Statistics rows not flagged as unguarded

`prd-delta-396.md §11` listed BC-INDEX Coverage Statistics table rows without noting
that these rows are NOT validated by `check-bc-cumulative-counts.sh`. The guard script
covers Surfaces A–H; the Coverage Statistics table is a manually-updated 9th surface
(noted in BC-INDEX.md header comments as separately unguarded).

**Resolution**: FIXED. A footnote block added to §11 immediately after the count-surface
table stating: "The BC-INDEX Coverage Statistics table rows (Section 3 row, Total row,
prose, and '+N enumeration') are NOT validated by the guard script — they are a manually-
updated surface. When updating counts, these rows require a manual visual check."

---

### P3-MED-003 — `--dry-run` × `--field` exit code unpinned + resolution-failure undefined

Two gaps in the dry-run contract:

(a) EC-3.4.015-18 and VP-396-008 both said "exit code follows existing `--dry-run`
behavior (0 or per convention)" — unverifiable without reading the source.

(b) No EC or VP defined what happens when resolution fails (zero-match, ambiguous name,
unsupported type, editmeta-absent) under `--dry-run`. The dry-run flag should NOT
suppress resolution errors.

**Resolution**: FIXED.

(a) EC-3.4.015-18 amended: **exit code pinned to 0**, sourced from
`src/cli/issue/create.rs:707: return Ok(());` at the end of the dry-run block.
VP-396-008 description and test strategy updated to assert exit code 0 (not "0 or per
convention").

(b) **EC-3.4.015-19 added**: "Resolution failure under `--dry-run`" — resolution errors
(zero-match, ambiguous, unsupported type, editmeta-absent, operations missing "set") still
exit 64 under `--dry-run`. The dry-run flag does not suppress or defer resolution errors;
it only suppresses the PUT and redirects the success path to a preview. VP-396-008
extended with a "resolution failure under `--dry-run`" sub-case: mock field list without
the target field → assert exit 64 → assert no preview emitted → assert no PUT.

---

## LOW Findings

### P3-LOW-001 — VP partitioning verified correct

Adversary verified VP partitioning is correct. No action required.

**Resolution**: PASS — no action.

---

### P3-LOW-002 — `EditMetaField.operations` present in struct but unchecked in algorithm

The proposed `EditMetaField` struct carried `operations: Vec<String>`, `required: bool`,
and `EditMetaFieldSchema.system`, but the BC-3.4.015 resolution algorithm read only
`schema.type` + `allowedValues`. A field present in `editmeta` with `operations` lacking
`"set"` would pass the Step-3 presence check but the server PUT would be rejected. The
unused struct fields also create a potential `dead_code` clippy warning (CLAUDE.md: no
lint suppression without refactoring).

**Resolution**: FIXED — option (a) chosen (correctness guard).

**Step 3b added to BC-3.4.015 algorithm**: after confirming field presence (Step 3),
inspect `editmeta.fields[id].operations`. If `"set"` is NOT in the list → exit 64 with
hint: "field '<NAME>' does not support direct `set` via the edit API (operations:
[<actual_ops>]). Use the Jira web UI or check with your project admin." No PUT attempted.

**EC-3.4.015-20 added**: documents the Step 3b error path including the empty-operations
sub-case.

**VP-396-012 added**: exercises EC-3.4.015-20 — field in `editmeta` with
`operations: ["transition"]` (no "set") → assert exit 64 + hint → assert no PUT.

**prd-delta §5 struct-field-usage note added**: documents that all `EditMetaField`
fields are either actively used (`name`, `schema.field_type`, `allowed_values`,
`operations`) or are parsed-but-future-use (`required`, `system`) — no silent dead-code.
Guidance provided for the clippy case: add a comment `// Future use: required-field
validation` and open a follow-up rather than removing or `#[allow]`-ing.

---

## Additional VP Coverage Gap (Observations)

### VP gap — `user`/`date`/`datetime` wire shapes uncovered

The `user`-type wire shape `{"accountId": VALUE}` and `date`/`datetime` bare-string
pass-through were claimed in BC-3.4.015 Step 4 and prd-delta §8 but no VP exercised
them. VP-396-001 covers string/number echo; VP-396-010 covers number wire serialization.
The pass-through types were an untested claim.

**Resolution**: FIXED. **VP-396-011 added** covering:
- `user` type: mock PUT body match requiring `{"customfield_NNNNN": {"accountId": "abc123"}}`.
- `date` type: mock PUT body match requiring `{"customfield_NNNNN": "2026-12-31"}` (bare string).
- `datetime` type: same pattern with an ISO 8601 datetime string.
- Robustness: non-ISO date value still accepted (client-side validation deliberately absent).

---

## Post-Resolution State

- Total BCs: 583 (unchanged — adversary pass 3 does not add BCs)
- Total VPs for issue #396: **12** (VP-396-001 through VP-396-012)
  - Added in pass 3: VP-396-011 (user/date/datetime wire), VP-396-012 (operations check)
- Guard scripts: both exit 0 after pass-3 amendments
- `check-bc-cumulative-counts.sh`: 9 surfaces, Surface H active
