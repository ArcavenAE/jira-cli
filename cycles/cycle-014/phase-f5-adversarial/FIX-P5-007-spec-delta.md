# FIX-P5-007 spec delta — implementer hand-off (cycle-014 F5 pass 6, D-401, spec v2.8.0)

Product code baseline: `develop` at `ce6be7ad`. Spec-only delta; nothing below is implemented yet.

## 1. Sanitization sites (src/cli/field.rs) — BC-X.14.004 EC-X.14.004-10

Pass each value through `output::sanitize_terminal_line` before it is interpolated:

| Site | Value |
|---|---|
| `handle`, `Mode::Createmeta` (M2) `"Field '{field_id}' is not available for issue type '{type_name}' in project '{project_key}'."` | `field_id` |
| `handle`, `Mode::RequestType` (M3) `"Field '{field_id}' is not available on request type '{rt_query}'."` | `field_id` |
| `handle`, `Mode::Editmeta` (M1) `"Field '{field_id}' is not on the Edit screen for issue {issue_key} (or is not available)."` | `field_id` |
| `resolve_field_id` not-found `"Field '{query}' not found. …"` | `query` |

Sanitize once at message-construction time (the UserError Display feeds both stderr and the JSON
`"error"` field). Templates, exit code 64 and the JSON envelope are unchanged. Out of scope (stay
residual, BC-7.1.006 residual list): `map_project_not_found`'s `project_key`, `type_name`/`rt_query`,
`resolve_request_type_id`'s errors, the "Issue type not found" valid-types list,
`degrade_hint_for_schema`.

Tests to add (names are the spec's targets):
- `src/cli/field.rs::test_bc_x_14_004_field_id_echo_is_sanitized_in_not_available_errors` — hostile `field_id` (ESC/CSI + `\n`) through the M1/M2/M3 message builders; no ESC/`\n` survives, template intact. (Factor the three messages into small pure builders if needed so they are unit-testable.)
- `src/cli/field.rs::test_bc_x_14_004_not_found_query_echo_is_sanitized`
- `tests/field_options.rs::test_bc_x_14_004_not_available_field_id_echo_is_sanitized_in_stderr_and_json` — wiremock M1 editmeta lacking a hostile `customfield_NNNNN` bypass literal; assert stderr and JSON `"error"` are control-byte-free and single-line.

## 2. P6-004 harness change

BC-X.14.004 Preconditions now require the M2/M3 no-resolvable-project exit-64 tests (EC-X.14.004-5 and
the incomplete-M2 row) to run hermetically: ambient `JR_*` scrubbed (except seams the test sets:
`JR_CONFIG_DIR`, `JR_CACHE_DIR`, `JR_BASE_URL`, `JR_AUTH_HEADER`), fresh `TempDir` config/cache, cwd with
no ancestor `.jr.toml`. Route `tests/field_options.rs`'s `Harness` (`Harness::new` and
`Harness::with_profile_project`, and the command builder they feed) through the helpers in
`tests/common/hermetic.rs` so every invocation is hermetic by construction.

## 3. ANTI-DRIFT RULES (apply in the same PR)

1. CLAUDE.md "Known Size Deviations": use approximate `~N LOC` only; drop exact line numbers,
   "production code ends at line N" boundaries and per-growth LOC deltas. Keep the DOCUMENT-AS-IS
   rationale and ADR-0012 reference. Do not re-measure per fix.
2. Rustdoc on `output::sanitize_table_cell` and `output::sanitize_terminal_line` (and
   `sanitize_terminal_text`): replace the duplicated covered-sink/residual inventories with a short
   pointer: "Which sinks are covered or residual: see BC-7.1.006 'Canonical Sink Inventory'
   (`.factory/specs/prd/bc-7-output-render.md`)". Keep the policy semantics each describes
   (per-character policy, `\n` handling, JSON never sanitized).
3. CLAUDE.md sanitize Gotcha (`output::sanitize_table_cell` bullet): same treatment — keep the policy
   description, replace the sink/residual enumeration with the pointer above.
4. When a sink is later covered or a residual found, edit ONLY BC-7.1.006's canonical list (plus the
   BC-X.14.004 EC if it is field.rs); never restate it in rustdoc, CLAUDE.md or other specs.
5. Cite code by symbol (`<file>::<fn>`), not line number.

CLAUDE.md citation guard (`tests/claude_md_citations.rs`, BC-X.13.001..003): backtick-quoted
file-path citations must resolve via `Path::exists()`. `.factory/` paths, globs (`*`, `{`, `}`),
symbol-form tokens (`::fn`), bare shorthands (`adf.rs`), `~/` paths and extensionless tokens are
auto-excluded, so a pointer to `.factory/specs/prd/bc-7-output-render.md` is safe. Any non-`.factory/`
path you cite (e.g. `tests/common/hermetic.rs`) must exist. Also run
`scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh`,
`scripts/check-bc-no-numeric-test-counts.sh` and `scripts/check-bc-citation-symbols.sh` after any
BC edit.

## 4. Flip-to-live (after merge)

Convert "NOT YET IMPLEMENTED (FIX-P5-007)" qualifiers in BC-X.14.004 (EC-X.14.004-10, taxonomy row,
Preconditions) and BC-7.1.006 canonical list (a)6 to live citations (state-manager/product-owner
post-merge PATCH, as for FIX-P5-005/006).
