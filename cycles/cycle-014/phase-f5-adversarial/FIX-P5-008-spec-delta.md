---
document_type: spec-delta-handoff
cycle: cycle-014
phase: f5-adversarial
fix: FIX-P5-008
decision: D-402
spec_version: 2.8.2
---

# FIX-P5-008 spec delta — product-repo hand-off (Pass 7)

Spec-side changes already made (this burst): BC-X.7.002 test-assertion prose (P7-001), BC-7.1.006 v1.7.2
(P7-002 spec side, VP-SEC-001-002 description, residual (b)11 `issue_key` echo), spec-changelog [2.8.2].
Base: develop `ecbc5cda`. Items below are for the implementer (product repo).

1. **P7-002** — `src/output.rs::sanitize_table_cell` rustdoc and the CLAUDE.md sanitize Gotcha: replace
   "no C1 handling" with "handles only NEL (U+0085) among C1 controls" for `strip_control_and_ansi`
   (and by extension `sanitize_env_display`).
2. **P7-003** — `docs/specs/cargo-mutants-policy.md` line ~41: the multi-line/single-line order is
   reversed; correct it.
3. **P7-004** — `README.md` `jr api` row: `--output` does not affect the response body; errors still
   honor `--output json`.
4. **CR7-001** — `tests/common/hermetic.rs` module header: it is a general jr subprocess-test helper;
   list its current users accurately or avoid enumerating them.
5. **CR7-002** — `src/cli/user.rs::format_user_row_styled`: column-position coupling. Add a test
   asserting styled and plain rows stay column-aligned with the `print_user_list` headers, or derive
   one from the other.
6. **CR7-003** — `src/cli/field.rs::search_field_list`: derive `query_lower` internally and sanitize
   lazily at the error sites; watch for equivalent-mutant patterns (cargo-mutants).
7. **CR7-004** — `src/cli/user.rs::test_bc_7_1_006_structural_cell_styling_technique_survives_rendering`:
   make its doc state precisely that it pins third-party `comfy_table` behavior jr relies on; keep the test.
