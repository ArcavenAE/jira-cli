## Fresh-Eyes Pre-Merge Review — PR #714 (S-605-2)

**Verdict: APPROVE** ✅

`jr issue edit --component` multi-key/`--jql` bulk path (BC-3.4.023). Reviewed the diff, PR
description, and test evidence as an independent final gate (non-redundant with Step-4.5 per
DEC-284). No BLOCKING / HIGH / MEDIUM findings.

### Rationale

The bulk `--component` path faithfully implements BC-3.4.023: exact `multiselectComponents`
wire shape (single object, integer `componentId`, deliberately no `sendBulkNotification`),
two-POST ADD-then-REMOVE sequencing, chunk-major/action-minor 1000-issue chunking, cross-project
guard (live + dry-run), correct user-vs-internal parse-error taxonomy, and mutual exclusion with
`--summary/--priority/--type/--label`. Tests are exact (full-body JSON equality, ordered key
assertions, `is_u64()` integer checks, `.expect(0)` negative mocks, single-JSON-document parse
assertions). CLI surface guard, help text, and CLAUDE.md LOC docs are all kept accurate.

### Verified against ground truth (BC-3.4.023 + story S-605-2)

- **CLI contract:** `--component` is `Vec<String>` with manual `add:`/`remove:` parsing — no
  `ValueEnum`, so the sibling-story kebab-vs-SCREAMING_SNAKE class does not apply. Help text in
  `src/cli/mod.rs` matches behavior. `num_args`/`--max` widened to 10000 for `--component` only,
  with the tighter `BULK_MAX_KEYS` ceiling enforced at runtime for every other flag
  (`src/cli/issue/edit.rs:50-65, 98`); `test_max_above_1000_without_component_still_rejected`
  pins the asymmetry.
- **Wire fidelity:** `build_component_edited_fields` + `BulkEditRequest` emit exactly
  `{selectedIssueIdsOrKeys, selectedActions, editedFieldsInput}` — no `sendBulkNotification`.
  AC-001 asserts this both by exact-body equality AND an independent top-level-key-set check.
- **Integer `componentId`:** `is_u64()` + `!is_string()` + no `{"name":...}` assertions (AC-003).
- **Two sequential POSTs / chunking:** AC-002/007/008 assert exact POST count, ordering, and
  per-chunk key membership via `body_partial_json` and ordered `selectedIssueIdsOrKeys` equality.
- **Chunk-failure abort:** AC-009 mounts chunk 3 with `.expect(0)`, asserts exit 1 + `FAILED`.
- **Error taxonomy:** numeric-bypass overflow → `UserError`/exit 64/zero POSTs; resolver-returned
  non-numeric id → `Internal` (matches BC Invariant 2, 2026-08-19 clarification).
- **Dry-run parity:** cross-project guard + oversized-numeric-id parse check hoisted so dry-run
  refuses exactly what the live run refuses; component list fetched once and shared (Round-3 F2).
- **JSON invariant #526:** routes through `output::render_json`. AC-010 live smoke test correctly
  `#[ignore]` + `e2e_enabled()`-gated (documented release gate, not run in CI).

### Findings (all non-blocking)

- **LOW** — `bail!("No component changes specified.")` in `handle_edit_bulk_components` yields
  exit 1, not exit 64; semantically a user error. Effectively unreachable (caller guarantees
  `!components.is_empty()`; empty/unknown specs are rejected earlier with a `UserError`). Note or
  swap to `UserError` only if the function is touched — not worth a fix burst.
- **nit** — >1000-without-`--component` rejection is tested via the `--jql`/`--max` path only; the
  positional-keys equivalent (`edit.rs:98`) has no dedicated test. Symmetric, low-risk gap.
- **nit** — the `--label` arm inside `component_bulk_conflicts` is documented-unreachable
  (BC-3.4.020 amendment block returns first). Intentional defense-in-depth; harmless.

### Accepted deferrals confirmed present (INFO only, per review scope)

`{"operations":[...]}` JSON shape divergence; cosmetic table-mode stream-routing arms;
inaccessible-key → exit 0; numeric-id predicate duplication (F5/F7) and cross-project-guard
duplication (intentional, mirrors `--type`); `edit.rs` ~3,187 LOC (ADR-0012 DOCUMENT-AS-IS,
CLAUDE.md updated in this PR); AC-010 live smoke test not yet run (release gate, does not block
the develop merge).

Ready to merge into `develop`.
