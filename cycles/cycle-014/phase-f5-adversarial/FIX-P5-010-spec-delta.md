---
document_type: spec-delta
fix: FIX-P5-010
cycle: cycle-014
phase: f5-adversarial (pass 9)
decision: D-404
spec_version: 2.8.6
bc: BC-7.1.006 v1.7.6
swept_at: develop f72255cd
---

# FIX-P5-010 spec delta (D-404, P9-001 MEDIUM)

## Decision

Split the Canonical Sink Inventory (BC-7.1.006) completeness claim: (i) SERVER/CONFIG-supplied echoes are COMPLETE for the changed src files (mechanically verified, table below); (ii) USER-typed echoes are explicitly NON-EXHAUSTIVE (self-injection; SEC6-003's `main.rs` chokepoint is the systematic fix). Spec-only, COUNT-NEUTRAL.

## Spec changes

- `.factory/specs/prd/bc-7-output-render.md`: Canonical Sink Inventory completeness statement rewritten as a split claim; (b) header notes the split; new residual items (b)25-(b)32; SEC6-003 follow-up paragraph extended; trace bullet; version row 1.7.6.
- `.factory/spec-changelog.md`: [2.8.6] PATCH.
- Anti-claim grep (BC-7.1.006, BC-X.14.*, BC-X.7.002, BC-X.16.*, BC-INDEX, CLAUDE.md): the only live completeness claim was the one in the inventory; other hits are dated history rows (left untouched).

## Sweep method (mechanical)

Files: `git diff --name-only 204b1fb5..f72255cd -- src/` = `src/api/jira/issues.rs`, `src/cli/api.rs`, `src/cli/field.rs`, `src/cli/issue/helpers.rs`, `src/cli/issue/interactions.rs`, `src/cli/issue/workflow.rs`, `src/cli/mod.rs`, `src/cli/user.rs`, `src/main.rs`, `src/output.rs`, `src/types/jira/editmeta.rs`. (`src/cli/issue/mentions.rs`, named in the old D-403 file list, is NOT in this diff; it is retained in (b)21 only.)

Per file, production code (up to the first `#[cfg(test)]`) was grepped for: `format!(`, `println!`, `eprintln!`, `print!(`, `eprint!(`, `print_success|print_error|print_warning|output::print`, `JrError::`, `anyhow!`, `bail!`, `.context(`, `with_context(`, `with_prompt(`, `.items(`, `.item(`, `Select`, `Confirm`, `Input::`, `write!(`, `writeln!(` (306 raw hits). Hits were then read in context and reduced to the sites below. Excluded from the table with reason: (1) ~25 request-path/URL `format!` calls in `issues.rs` (`/rest/api/3/issue/{key}/…`) and `api.rs::append_query_params`/`normalize_path` URL building: they build HTTP requests, not terminal output; (2) doc-comment and constant-string-only hits (`bail!`/`UserError` with no interpolation, clap help text in `mod.rs`); (3) `--output json` `println!` arms: lossless by design (EC-12). `src/cli/mod.rs` and `src/types/jira/editmeta.rs` have zero output sites.

Source classes: SERVER = derived from an API response; CONFIG = config/`.jr.toml`/profile; USER = CLI args, stdin, markdown body; INTERNAL = counts/enums/our own formatting. Sanitization: A = covered by inventory (a); U = unsanitized; `-` = n/a (internal, or the documented `jr api` passthrough exception).

## Sweep table

| # | File::site | Interpolated value / site | Source | San. | Inventory |
|---|---|---|---|---|---|
| 1 | `issues.rs::get_issue_project_key` | "Issue {key} response missing fields.project.key" (JrError::Internal) | USER | U | (ii) |
| 2 | `issues.rs::get_issue_project_key` | "Issue {key} not found or not accessible." | USER | U | (ii) |
| 3 | `issues.rs::get_changelog_all (pagination guard)` | "changelog pagination did not advance (startAt {} -> {})" | INTERNAL | - | - |
| 4 | `issues.rs::get_comments_all (pagination guard)` | "comment pagination did not advance (startAt {} -> {})" | INTERNAL | - | - |
| 5 | `issues.rs::get_issue_types_for_project` | cap error: project '{project_key}' (JrError::Internal) | CONFIG | U | NEW (b)31 |
| 6 | `issues.rs::get_createmeta_fields` | cap error: project '{project_key}' + issue type '{issue_type_id}' | CONFIG+SERVER | U | NEW (b)31 |
| 7 | `api.rs::parse_header` | "Header must be in 'Key: Value' format (got: {raw})" | USER | U | (b)19 |
| 8 | `api.rs::parse_header` | "Invalid header name '{key}': {e}" | USER | U | (b)19 |
| 9 | `api.rs::parse_header` | "Invalid header value '{value}': {e}" | USER | U | (b)19 |
| 10 | `api.rs::parse_query_param` | "--query-param must be in NAME=VALUE format (got: {raw})" | USER | U | (b)19 |
| 11 | `api.rs::parse_query_param` | "--query-param NAME cannot be empty (got: {raw})" | USER | U | (b)19 |
| 12 | `api.rs::resolve_body` | "Request body is not valid JSON: {e}" (serde error over user body) | USER | U | (ii) |
| 13 | `api.rs::handle_api` | non-2xx JrError::ApiError{message: extract_error_message(body)} | SERVER | U | (b)16 |
| 14 | `api.rs::handle_api` | raw response-body stdout passthrough | SERVER | - (documented exception) | (a) note |
| 15 | `field.rs::handle (M2)` | "Issue type '{type_name}' not found for project {project_key}. Valid types: {server names}" | USER+CONFIG+SERVER | U | (b)10/(b)11 |
| 16 | `field.rs::field_not_available_for_type_msg` | field_id | SERVER | A | (a)6 |
| 17 | `field.rs::field_not_available_for_type_msg` | type_name, project_key | USER+CONFIG | U | (b)11 |
| 18 | `field.rs::field_not_available_on_request_type_msg` | field_id | SERVER | A | (a)6 |
| 19 | `field.rs::field_not_available_on_request_type_msg` | rt_query | USER | U | (b)11(ii) |
| 20 | `field.rs::field_not_on_edit_screen_msg` | field_id | SERVER | A | (a)6 |
| 21 | `field.rs::field_not_on_edit_screen_msg` | issue_key | USER | U | (b)11(iii) |
| 22 | `field.rs::field_not_found_msg` | query | USER | A | (a)6 |
| 23 | `field.rs::map_project_not_found` | project_key | CONFIG | U | (b)11(i) |
| 24 | `field.rs::map_issue_not_found` | key | USER | U | (b)11(iv) |
| 25 | `field.rs::degrade_hint_for_schema (x4 format!)` | display_name, autoCompleteUrl | SERVER | U | (b)8 |
| 26 | `field.rs::normalize_or_degrade` | eprintln of degrade hint | SERVER | U | (b)8 |
| 27 | `field.rs::candidate_labels` | candidate name/id | SERVER | A | (a)5 |
| 28 | `field.rs::search_field_list (x3 errors)` | echoed query + candidates | USER+SERVER | A | (a)5 |
| 29 | `field.rs::resolve_request_type_id` | ExactMultiple: request-type name + ids | SERVER | U | (b)9 |
| 30 | `field.rs::resolve_request_type_id` | Ambiguous: query, matched names, project_key | USER+SERVER+CONFIG | U | (b)9/(b)11 |
| 31 | `field.rs::resolve_request_type_id` | None: query, project_key | USER+CONFIG | U | (b)11 |
| 32 | `field.rs::render_rows_recursive / handle` | option id/label table rows via print_output | SERVER | A | (a)1 |
| 33 | `helpers.rs::resolve_team_field` | verbose eprintln (x2): team_name | USER | U | (ii) |
| 34 | `helpers.rs::resolve_team_field` | ExactMultiple no-input: team_name, team names/ids | USER+SERVER | U | (b)23 |
| 35 | `helpers.rs::resolve_team_field` | ExactMultiple picker prompt + labels | USER+SERVER | U | (b)23 |
| 36 | `helpers.rs::resolve_team_field` | Ambiguous no-input: team_name, matches | USER+SERVER | U | (b)23 |
| 37 | `helpers.rs::resolve_team_field` | Ambiguous picker prompt + items | USER+SERVER | U | (b)23 |
| 38 | `helpers.rs::resolve_team_field` | None (x2): team_name | USER | U | (b)23 |
| 39 | `helpers.rs::resolve_story_points_field_id` | ConfigError: active_profile_name | CONFIG | U | NEW (b)30 |
| 40 | `helpers.rs::prompt_input` | with_prompt/with_context(prompt) (callers pass literals) | INTERNAL | - | - |
| 41 | `helpers.rs::disambiguation_labels (x2)` | display_name/email/account_id picker labels | SERVER | A | (a)4 |
| 42 | `helpers.rs::disambiguate_user` | empty_msg (caller-built) | USER+CONFIG | U | (b)20/(b)21 |
| 43 | `helpers.rs::disambiguate_user` | ExactMultiple lines (display_name/email/account_id) | SERVER | A | (a)4 |
| 44 | `helpers.rs::disambiguate_user` | ExactMultiple header + prompt: name_echo | USER/SERVER | A | (a)4 |
| 45 | `helpers.rs::disambiguate_user` | Ambiguous message + prompt: name_echo, matches | USER/SERVER | A | (a)4 |
| 46 | `helpers.rs::disambiguate_user` | None: none_msg_fn(sanitized names) | SERVER | A | (a)4 |
| 47 | `helpers.rs::resolve_user/resolve_assignee/resolve_assignee_by_project (x6 format!)` | caller-built messages: name, issue_key, project_key | USER+CONFIG | U | (b)20 |
| 48 | `helpers.rs::resolve_asset` | "No assets matching {input}" | USER | U | (b)13 |
| 49 | `helpers.rs::resolve_asset (x8 sites)` | label/object_key in errors, picker prompts + items | SERVER+USER | U | (b)13 |
| 50 | `interactions.rs::handle_comment_add` | print_success "Added comment to {key} (id: {comment.id})" | SERVER+USER | U | NEW (b)28 |
| 51 | `interactions.rs::validate_comment_id` | "invalid comment id: {id}" | USER | U | (ii) |
| 52 | `interactions.rs::handle_comment_delete` | no-input UserError, y/N prompt, success echo: id,key | USER | U | (ii) |
| 53 | `interactions.rs::handle_comment_delete` | 404/403 "comment not found...: {key}#{id}\n{message}" | USER+SERVER | U | NEW (b)29 |
| 54 | `interactions.rs::handle_comment_edit` | "file not found: {path}" | USER | U | (ii) |
| 55 | `interactions.rs::handle_comment_edit` | success echo "Updated comment {id} on {key}" | USER | U | (ii) |
| 56 | `interactions.rs::handle_comment_edit` | 404/403 message | USER+SERVER | U | NEW (b)29 |
| 57 | `interactions.rs::handle_comment_view` | 404/403 message | USER+SERVER | U | NEW (b)29 |
| 58 | `interactions.rs::handle_comment_view` | print! six fields + body | SERVER | A | (a)2 |
| 59 | `workflow.rs::resolve_resolution_by_name` | Internal "matched resolution {name} not found" | SERVER | U | NEW (b)26 |
| 60 | `workflow.rs::resolve_resolution_by_name` | ExactMultiple: query + names + ids | USER+SERVER | U | NEW (b)26 |
| 61 | `workflow.rs::resolve_resolution_by_name` | Ambiguous: query + matches | USER+SERVER | U | NEW (b)26 |
| 62 | `workflow.rs::resolve_resolution_by_name` | None: query + all resolution names | USER+SERVER | U | NEW (b)26 |
| 63 | `workflow.rs::load_resolutions` | warning "{n} resolution(s) lacked an id" | INTERNAL | - | - |
| 64 | `workflow.rs::finish_transition` | "requires a resolution": to_label, key | SERVER+USER | U | NEW (b)27 |
| 65 | `workflow.rs::finish_transition` | print_success "Moved {key} to {new_status}" | SERVER+USER | U | (b)2 |
| 66 | `workflow.rs::handle_move` | "No transitions available for {key}." (x2) + "Available transitions for {key}:" | USER | U | (ii) |
| 67 | `workflow.rs::handle_move` | numbered list: transition name, to_name | SERVER | U | (b)2 |
| 68 | `workflow.rs::handle_move` | "Too many issue keys" counts | INTERNAL | - | - |
| 69 | `workflow.rs::handle_move` | "{key} is already in status {current_status}" | SERVER+USER | U | (b)2 |
| 70 | `workflow.rs::handle_move` | Internal "matched candidate {name} not found" (x3) | SERVER | U | NEW (b)27 |
| 71 | `workflow.rs::handle_move` | Ambiguous transition: target_status + matches (error) | USER+SERVER | U | NEW (b)27 |
| 72 | `workflow.rs::handle_move` | Ambiguous match eprintln: target_status + numbered matches | USER+SERVER | U | (b)2 |
| 73 | `workflow.rs::handle_move` | No transition matching: target_status + labels | USER+SERVER | U | NEW (b)27 |
| 74 | `workflow.rs::handle_move` | "Resolution '{q}' is not allowed on '{to_label}'. Allowed: {names}" | USER+SERVER | U | NEW (b)26 |
| 75 | `workflow.rs::handle_move` | resolution-required UserErrors (x4): to_label, key | SERVER+USER | U | NEW (b)27 |
| 76 | `workflow.rs::handle_move` | Select "(required)": items = resolution names | SERVER | U | NEW (b)25 |
| 77 | `workflow.rs::handle_move` | Select "(optional)": items = resolution names + NONE_LABEL | SERVER | U | NEW (b)25 |
| 78 | `workflow.rs::handle_move_bulk` | "No transitions available for {first_key}" | USER | U | (ii) |
| 79 | `workflow.rs::handle_move_bulk` | "Transition number {n} out of range" counts | INTERNAL | - | - |
| 80 | `workflow.rs::handle_move_bulk` | Internal "matched transition {name}" | SERVER | U | NEW (b)27 |
| 81 | `workflow.rs::handle_move_bulk` | Ambiguous: target_status + matches | USER+SERVER | U | NEW (b)27 |
| 82 | `workflow.rs::handle_move_bulk` | No transition matching: target_status + labels | USER+SERVER | U | NEW (b)27 |
| 83 | `workflow.rs::handle_move_bulk` | success echo "Moved {key} to {target_status}" | USER | U | (ii) |
| 84 | `workflow.rs::handle_move_bulk` | "error: {key}: {err_msg}" | USER+SERVER | U | (b)2 |
| 85 | `workflow.rs::handle_move_bulk` | "warning: {key}: {status}" | USER+SERVER | U | (b)2 |
| 86 | `workflow.rs::handle_assign (unassign)` | "{key} is already unassigned" / "Unassigned {key}" | USER | U | (ii) |
| 87 | `workflow.rs::handle_assign` | "{key} is already assigned to {display_name}" / "Assigned {key} to {display_name}": display_name | SERVER | A | (a)3 |
| 88 | `workflow.rs::handle_assign` | same messages: key | USER | U | (b)22 |
| 89 | `workflow.rs::handle_open` | --url-only println {instance_url}/browse/{key} | CONFIG+USER | U | NEW (b)32 |
| 90 | `workflow.rs::handle_open` | "Opened {key} in browser" | USER | U | (ii) |
| 91 | `main.rs::main error handler` | "Error: {e}" and JSON "error": e.to_string() | SERVER+USER+CONFIG | U | (b)24 |
| 92 | `main.rs::run (Me)` | print_output Name/Email table | SERVER | A | (a)1 |
| 93 | `user.rs::handle_view` | "User with accountId '{account_id}' not found." | USER | U | (b)18 |
| 94 | `user.rs::print_user_list / handle_view` | print_output_with_styles tables | SERVER | A | (a)1 |
| 95 | `output.rs::print_output / print_output_with_styles` | table arms render_table(_with_styles) | SERVER | A | (a)1 |
| 96 | `output.rs::print_success/print_warning/print_error` | pass-through sink helpers (message built by caller) | INTERNAL | - | n/a (caller sites above) |
| 97 | `output.rs::sanitize_env_display` | format!("{truncated}…") | INTERNAL | - | - |

## Summary

97 output/echo sites with a non-constant interpolation (grouped sites counted once). A site is counted under every source class it carries, so class counts overlap: SERVER 55, CONFIG 12, USER 61, INTERNAL-only 8.

By strictest class (disjoint): 
- SERVER and/or CONFIG: 63 sites — 16 covered by (a), 46 unsanitized and listed in (b), 1 documented exception (`jr api` passthrough).
- USER-only: 26 sites — 1 sanitized (`field_not_found_msg` query), 25 unsanitized (self-injection; (ii) non-exhaustive; the ones with a (b) number are examples).
- INTERNAL-only: 8 sites, nothing to sanitize.

Sites newly added to (b) by this sweep (NEW rows above): (b)25 resolution-picker items (SERVER); (b)26 resolution-name errors (SERVER); (b)27 transition/status-name error text (SERVER); (b)28 `comment.id` (SERVER); (b)29 comment 404/403 server message (SERVER); (b)30 profile name in `resolve_story_points_field_id` (CONFIG); (b)31 createmeta-cap `project_key` (CONFIG) / `issue_type_id` (SERVER); (b)32 `handle_open --url-only` instance URL (CONFIG). Every SERVER/CONFIG row in the table is now either `A`, a pre-existing (b) item, or one of these.

User-typed sites named in the finding and left to (ii) (no new numbered item): `validate_comment_id`, `handle_comment_delete`/`handle_comment_edit` key/id echoes, unassign messages, `handle_open`'s "Opened {key} in browser", "No transitions available for {key}.", `handle_move_bulk`'s first_key message.

## Implementer items (code/rustdoc only; spec says nothing about these)

1. **P9-002** — `src/cli/user.rs`, rustdoc of `test_bc_7_1_006_format_active_returns_bare_glyph_no_esc_bytes_when_color_forced_on` (~L357-361): remove the claim that stdout "isn't a terminal (the default under `cargo test`, where stdout is captured)". Reword consistent with ~L444-448: stdout may or may not be a terminal depending on how the runner was launched; libtest's capture does not redirect fd 1; the forced `ColorOverride` is what makes the assertion deterministic regardless.
2. **CR9-002** — `src/output.rs::render_table_with_styles_inner` rustdoc: ensure a one-line note that `force_styling` is a TEST-ONLY knob and production (`render_table_with_styles`) always passes `false`. At `f72255cd` the rustdoc (L102-104) already says "`render_table_with_styles` itself always calls this with `force_styling = false` ... the parameter is a pure test-observability seam"; the implementer should confirm it reads as a standalone one-liner on the parameter and tighten only if needed.

## Guards

See the hand-off report (exit codes of `scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh`, `scripts/check-bc-no-numeric-test-counts.sh`, `scripts/check-bc-citation-symbols.sh --bc-dir .factory/specs/prd`).
