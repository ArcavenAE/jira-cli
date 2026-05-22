---
document_type: adversarial-pass-report
issue: "#396"
pass: 9
date: "2026-05-22"
verdict: CLEAN
findings_count: 0
severities: "0 CRITICAL, 0 HIGH, 0 MEDIUM, 0 LOW"
observations: 4
clean_pass_count: 3
convergence_reached: true
convergence_passes: "7, 8, 9"
---

# Adversarial Pass 9 Report — Issue #396: `issue edit --field NAME=VALUE`

**Date**: 2026-05-22  
**Verdict**: CLEAN  
**Convergence**: REACHED — passes 7, 8, 9 all clean (3 consecutive). F2 spec is converged.

---

## Findings

None. 0 CRITICAL, 0 HIGH, 0 MEDIUM, 0 LOW.

---

## Confirmatory Observations

The following four observations were noted during pass 9 as confirmations of correctness — no spec changes required.

### Observation 1: `EditMetaFieldSchema.customId` omission is serde-safe

The Jira editmeta JSON response includes a `customId` numeric field in the `schema`
object (e.g., `"customId": 10176`). `EditMetaFieldSchema` in prd-delta §5 does not
model this field. This is serde-safe: without `#[serde(deny_unknown_fields)]`, serde
silently ignores unknown fields during deserialization. `customId` is derivable by
stripping `"customfield_"` from the HashMap key; adding it as a struct field would
add no resolution value for v1. The omission is intentional and correct.

### Observation 2: Invariant 10 dry-run dual-arm rendering note

BC-3.4.015 invariant 10 correctly states that `resolve_edit_fields` MUST execute
inside the `if dry_run { ... }` block to surface `--field` entries in the preview and
propagate resolution failures as exit 64. The invariant text was verified to be
unambiguous about the dual-arm requirement: the dry-run path (resolve → render-preview
→ `return Ok(())`) and the live path (resolve → PUT → echo) both call
`resolve_edit_fields`; only the PUT and success-echo differ between them. No
additional clarification needed.

### Observation 3: `parse_field_kv` line citation verified exact

BC-3.4.015's `resolve_edit_fields` canonical signature block and EC-3.4.017-10 cite
`src/cli/issue/create.rs:1982-1997` as the location of `parse_field_kv`. This
citation was verified to be consistent across all three sites where it appears
(BC-3.4.015 signature block, EC-3.4.017-10, prd-delta §9). The citation style
(file:line-range) is the project convention for locating implementation anchors in
spec prose.

### Observation 4: `FieldsCache` verified a faithful `CmdbFieldsCache` mirror

The prd-delta §5 `FieldsCache` struct (`fields: Vec<(String, String)>`,
`fetched_at: DateTime<Utc>`, implementing `Expiring`) was confirmed to faithfully
mirror the `CmdbFieldsCache` / `cmdb_fields.json` pattern described in CLAUDE.md
Gotchas and `src/cache.rs`. The best-effort writer contract (`write_fields_cache`
swallows I/O errors via `eprintln!` and returns `Ok(())`) matches the
`write_request_type_cache` pattern documented in CLAUDE.md. No structural deviation
from the established cache pattern.

---

## Convergence Statement

F2 adversarial review for issue #396 (`issue edit --field NAME=VALUE`) is **converged**.

- Pass 7: CLEAN (substantively — 2 LOW + 1 cosmetic swept)
- Pass 8: CLEAN (substantively — 3 observations swept)
- Pass 9: CLEAN (0 findings, 4 confirmatory observations)

The spec artifacts — `bc-3-issue-write.md` (BC-3.4.015, BC-3.4.016, BC-3.4.017),
`prd-delta-396.md`, and `verification-delta-396.md` — are ready to advance to F3
(story decomposition) and F4 (delta implementation).
