# FIX-P5-013 spec delta and implementer hand-off (cycle-014 F5, rehearsal R13 before counted pass 12)

Spec version 2.8.9 (PATCH). Spec-only on the spec side. Product-repo items below are rustdoc/help/doc wording only (no behavior change). Verified against develop `470f0967`.

## Spec changes already made (under `.factory/`)

| File | Change |
|---|---|
| `specs/prd/bc-7-output-render.md` | BC-7.1.006 v1.7.8: styled-Active-column caller list now `jr user list`, `jr user search`, `jr user view`; Canonical Sink Inventory picker-row note distinguishes `ExactMultiple` labels from `Ambiguous` items; version row 1.7.8; frontmatter trace bullet |
| `specs/prd/cross-cutting.md` | BC-X.7.008 Behavior 1/2 branch-precise; BC-X.14.001 M3 `--project` required-or-defaulted (intro, M3 paragraph, Preconditions, arity-precedence paragraph, M2-resolution-step sentence); frontmatter trace bullet |
| `specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md` | In-place dated corrections in §1 and § Consequences; new Amendment (2026-10-04) item 7 |
| `spec-changelog.md` | `[2.8.9]` entry |

## Product-repo items for the implementer

### R13-001: `jr user search` also uses `print_output_with_styles`

Code fact: `src/cli/user.rs::handle_search` -> `print_user_list` -> `output::print_output_with_styles` (rows from `format_user_row_styled`/`active_cell`); `handle_list` also -> `print_user_list`; `handle_view` calls `print_output_with_styles` directly. Reword "`jr user list`/`jr user view`" to include `jr user search` (or say "the `src/cli/user.rs` user tables") in:

- `src/output.rs` ~L40-41: `StyledCell` rustdoc ("Today the only caller is `jr user list`/`jr user view`'s Active column").
- `src/output.rs` ~L171-173: `print_output_with_styles` rustdoc ("Used only by `jr user list`/`jr user view`").
- `src/output.rs` ~L379-381: `sanitize_table_cell` rustdoc ("used by `jr user list`/`jr user view`").
- `src/output.rs` ~L1364-1366: test-section comment ("the ONLY production table-mode rendering path for `jr user list`/`jr user view`").
- `CLAUDE.md` ~L345: the `output::sanitize_table_cell` Gotcha bullet ("`format_active` (the `jr user list`/`jr user view` Active column)"). Also check its other mentions of the pair in the same bullet.
- `CHANGELOG.md` ~L152-153, ~L257, ~L267: the three "`jr user list`/`jr user view`" Active-column mentions.

### R13-003: `--project` is required-or-defaulted for `--request-type` (M3), not optional

Code fact: `src/cli/field.rs::handle` M3 arm: `resolve_m2_project(cli_project, config).ok_or_else(|| JrError::UserError("--request-type needs a resolvable project — pass --project <P> or configure a default."))` — exit 64 when neither flag nor default supplies a project, same as M2.

- `src/cli/mod.rs` `FieldCommand::Options`, ~L1247-1248 (the `--request-type` doc comment: "`--project` is an optional companion naming the service-desk project explicitly") and ~L1257-1258 (the `--project` doc comment: "required-or-defaulted for `--type`, optional for `--request-type`, ignored for `--issue`"). Change to required-or-defaulted for BOTH `--type` and `--request-type`, ignored for `--issue`.
- `README.md` ~L346 (the `jr field options` row: "`--project` is a companion flag (required-or-defaulted for `--type`, optional for `--request-type`, ignored for `--issue`)"): same change.
- Test pinning: grep of `tests/` and `src/` found NO test or snapshot that pins either help string (`optional for`, `optional companion`, `Companion project override`, `naming the service-desk project` appear only in `src/cli/mod.rs`; `required-or-defaulted` only in `src/cli/mod.rs` and `README.md`). The help text is clap doc-comment output, so changing it should need no test update; still run `cargo test` and check for insta help snapshots (none found by grep).
