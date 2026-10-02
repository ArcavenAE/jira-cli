---
document_type: spec-delta-handoff
cycle: cycle-014
phase: f5-adversarial
fix: FIX-P5-009
decision: D-403
spec_version: 2.8.4
---

# FIX-P5-009 spec delta — product-repo hand-off (Pass 8)

Decision D-403: fix everything from Pass 8, raise the F5 pass cap to 15, keep the strict rule (three
consecutive clean adversarial passes). Spec-side changes already made (this burst, base develop
`b9ae0862`): P8-001 (BC-X.16.001/002, BC-X.7.002, BC-INDEX IMPLEMENTED status + symbol anchors),
P8-002/SEC8-001 (BC-7.1.006 v1.7.4, Canonical Sink Inventory made complete, residuals (b)17-24),
complete audit of BC-7.1.006 / X.7.002 / X.14.001-004 / X.16.001-002 (see spec-changelog [2.8.4]).
Items below are for the implementer (product repo).

1. **P8-003** — `docs/specs/cargo-mutants-policy.md` §Scope `src/cli/field.rs` bullet (~L39) and the
   `.cargo/mutants.toml` comment (~L58-65): name this cycle's `field.rs` security functions
   (`search_field_list`'s ID step, `candidate_labels`, and the four builders
   `field_not_available_for_type_msg`, `field_not_available_on_request_type_msg`,
   `field_not_on_edit_screen_msg`, `field_not_found_msg`); drop or approximate the stale "~91 mutants"
   count.
2. **NIT** `CHANGELOG.md` ~L77: "Both ambiguity hints" -> "All three ambiguity messages" (consistent
   with ~L111-112, which lists three `search_field_list` ambiguity messages).
3. **NIT** `CHANGELOG.md` ~L285: "strips every Unicode format (Cf) character" from all table/human
   output overclaims — residual unsanitized sinks exist (BC-7.1.006 Canonical Sink Inventory (b)).
   Scope it to the sanitizer policy / covered sinks.
4. **NIT** `tests/field_options.rs` module doc (~L3-13) still says `handle` is a `todo!()` stub; rewrite
   to describe the suite as it stands.
5. **NIT** `tests/field_options.rs::test_bc_x_14_004_not_available_field_id_echo_is_sanitized_in_stderr_and_json`
   is order-dependent on the one-time legacy-config migration notice (first loop iteration sees it,
   the second does not; JSON mode parses `stderr.trim()` first). Make each mode independent
   (fresh harness/config dir per mode, or strip the notice before parsing in both modes).
6. **NIT** `docs/specs/cargo-mutants-policy.md` ~L41 and `.cargo/mutants.toml` ~L80 name
   `render_table_with_styles` as the color gate's home; the gate is in
   `render_table_with_styles_inner` (`src/output.rs`).
7. **NIT** `README.md` `jr field options <NAME>` row (~L346): mention that system field IDs
   (e.g. `issuetype`, `priority`) are accepted, matching the help text.

Spec-reported code-adjacent observations (no spec change required; optional product follow-ups):
- **Code change (orchestrator-added, spec pre-staged as BC-7.1.006 (a)4 / EC-25, NOT YET IMPLEMENTED):** sanitize `disambiguate_user`'s echoed `name` via `sanitize_terminal_line`, computed ONCE at the top. CONSTRAINT: use the sanitized copy only for the `Multiple users named/match "<name>"` echoes (messages and picker prompts); `partial_match` and the ExactMultiple duplicate filter MUST keep using the raw `name` — on the `@Name` path `name` is a raw server `display_name` compared for equality against raw candidate names, and shadowing `name` at the top would break that match. `empty_msg`/`none_msg_fn` are caller-built and stay raw (residuals (b)20/(b)21). Target test `test_disambiguate_user_sanitizes_echoed_name` (spec fixture `"Mal\u{1b}[31mlory\u{9b}\nEve"` on two users, expects `Multiple users named "Mallory Eve" found:`); report the final test name so the spec citation can be made live.
- `src/output.rs` `SPEC_CF_RANGES` comment already says "NOT an independent derivation"; spec now agrees.

## Post-merge (spec v2.8.5, 2026-10-02) — PR #902 merged into `develop` as `f72255cd`

Pre-staged items converted to live citations (see `.factory/spec-changelog.md` [2.8.5]):

- BC-7.1.006 Canonical Sink Inventory (a)4, retired slot (b)12 and EC-25: IMPLEMENTED, "merged in PR #902, `f72255cd`". Code: `src/cli/issue/helpers.rs::disambiguate_user` (`name_echo`, both messages + both picker prompts; raw `name` kept for matching). Test (verified present): `src/cli/issue/helpers.rs::tests::test_disambiguate_user_sanitizes_echoed_name` — covers the non-interactive `ExactMultiple`/`Ambiguous` messages and a `None` clean-output pin only; the picker prompts are verified by code inspection only (dialoguer needs a TTY).
- EC-16b / VP-SEC-001-001 (d): header echoed name now sanitized; integration tests `..._strips_hostile_display_name_newline` (`"Mallory Eve"`), `..._strips_hostile_display_name_field` (`"Mallory"`), `..._strips_ec16b_fixture` (`"Alice"`) in `tests/table_output_sanitization.rs` cited.
- Color gate home corrected to `render_table_with_styles_inner` (production implementation; only `force_styling` is test-only).
- Field-options test split: `test_bc_x_14_004_not_available_field_id_echo_is_sanitized_in_stderr` / `..._in_json`; BC-X.14.004 EC-X.14.004-10 citation updated.
- Matching wording: case-insensitive (`partial_match`; ExactMultiple filter via `to_lowercase()`). HTTP wording: field-ID step adds no HTTP beyond the name lookup's `list_fields()` fetch; zero `GET /rest/api/3/field` on a cache hit.
- Items 1-7 of the implementer list above: all landed in PR #902 (mutants policy/`mutants.toml`, CHANGELOG nits, `tests/field_options.rs` module doc + independent tests, README system IDs); no spec change was required for them beyond the items listed here.
