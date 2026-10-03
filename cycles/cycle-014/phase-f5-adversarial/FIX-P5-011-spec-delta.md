# FIX-P5-011 spec delta (D-405, cycle-014 F5 pass-10, spec v2.8.7)

Spec-only. BC-X.14.001 Invariant 3 reworded (shared cache/bypass/refresh-once semantics; search step deliberately diverges between `jr field options` and `--field`). Also fixed: BC-X.14.001 Behavior paragraph, BC-X.14 Source line, BC-INDEX BC-X.14.001 row, cross-cutting.md trace bullet, spec-changelog [2.8.7]. BC-7.1.006 NOT amended (`field_resolve.rs` not in `git diff --name-only 204b1fb5..b2b8ee3b -- src/`).

## Product-repo items for the implementer

- **N1 (CHANGELOG.md, ~L298-320):** the Cf-stripping Security entry should mention the EC-24 deliberately-kept characters, cite EC-18..EC-24, and not imply that all blank-rendering characters are stripped.
- **N2 (CLAUDE.md):** architecture tree says `component.rs` "~1066 LOC"; Known Size Deviations and disk say ~1,800. Align the tree.
- **CR10-001 (CLAUDE.md tree comments):** `src/cli/user.rs` — "thin wrapper over api/jira/users.rs" is stale; it now resolves the project via `Config::project_key` and has the `StyledCell` Active column. `src/cli/api.rs` — comment should mention `-q`/`--query-param`.
- **CR10-002 (src/cli/field.rs rustdoc):** add a one-line rustdoc to `field_not_available_for_type_msg`, `field_not_available_on_request_type_msg` and `field_not_on_edit_screen_msg` stating that only `field_id` is sanitized and the other interpolated values are residual (b)11 of BC-7.1.006's inventory.
- **Optional:** `field.rs::is_customfield_literal` rustdoc ("mirrors `resolve_edit_fields`'s Step 1") remains accurate for Step 1; no change needed.
