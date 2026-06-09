---
context: bc-7
title: "Output Rendering & Error"
total_bcs: 87   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings; +4 added 2026-05-08 (BC-7.4.013-016, Fix-PR A); +1 added 2026-06-08 (BC-7.2.006, issue #470 listItem content-model conformance); +2 added 2026-06-08 (BC-7.2.007..008, issue #474 markdown subsup + heading-attr)
definitional_count: 41   # count of `#### BC-` headings in this file
last_updated: 2026-06-08
source_pass: 3
trace: |
  - L2: .factory/specs/domain-spec/bc-07-output-render.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.12-2.13
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.5-3.6
---

# BC-7 — Output Rendering & Error

87 behavioral contracts across 5 subdomains: Table/JSON output (7.1), ADF rendering (7.2),
Error display (7.3), JSON output shapes (7.4), Observability (7.5). (+4 BC-7.4.013-016 added 2026-05-08 by Fix-PR A for auth JSON shapes. +1 BC-7.2.006 added 2026-06-08 by issue #470 listItem content-model conformance. +2 BC-7.2.007..008 added 2026-06-08 by issue #474 markdown subsup + heading-attr.)

---

## Subdomains

### 7.1 Table / JSON Output

#### BC-7.1.001: `--output table` uses comfy-table renderer; `--output json` emits structured JSON

**Confidence**: HIGH
**Source**: `src/output.rs::tests`; integration tests using `--output json`
**Subject**: Output rendering
**Behavior**: Default is `table`. Integration test pattern: assert `serde_json::from_str(&stdout)` parses. Table uses comfy-table crate.
**Trace**: Pass 3 BC-1101

---

#### BC-7.1.002: `--no-color` and `NO_COLOR` env disable ANSI escape sequences

**Confidence**: HIGH
**Source**: `src/main.rs:13-15`; colored crate
**Trace**: Pass 3 BC-1102

---

#### BC-7.1.003: `--no-input` auto-enables when stdin is not a TTY (`IsTerminal` check)

**Confidence**: HIGH
**Source**: `src/main.rs:18-23`
**Subject**: Output rendering
**Behavior**: Auto-set on pipes / AI agents / scripts. Every command must have fully non-interactive flag equivalents.
**Trace**: Pass 3 BC-1103

---

#### BC-7.1.004: Truncation hint emitted to stderr (NOT stdout); `--all` suppresses hint

**Confidence**: HIGH
**Source**: `tests/sprint_commands.rs:97-100, 175-179`
**Subject**: Output rendering
**Behavior**: stderr line: `"Showing N results"`. With `--all`: NO hint. Used by issue list, sprint current, board view.
**Trace**: Pass 3 BC-1110, BC-1111

---

#### BC-7.1.005: `--output json` error shape: `{"error": "<message>", "code": <exit>}` to stderr

**Confidence**: MEDIUM
**Source**: `src/main.rs:34-49`
**Subject**: Output rendering
**Behavior**: When `--output json` is active AND an error occurs, stderr gets JSON error envelope.
**Trace**: Pass 3 BC-1208 (error handling context)

---

### 7.2 ADF Rendering (8 individually-bodied BCs: BC-7.2.001..008; 54 BCs cumulative including range-collapsed)

#### BC-7.2.001: `text_to_adf("hello")` emits `{type:"doc", version:1, content:[{type:"paragraph", content:[{type:"text", text:"hello"}]}]}`

**Confidence**: HIGH
**Source**: `src/adf.rs::tests` (unit tests covering text→ADF, markdown→ADF, ADF→text variants)
**Subject**: Output rendering
**Behavior**: Standard ADF doc shape. Version is always 1.
**Trace**: Pass 3 BC-1104

---

#### BC-7.2.002: `markdown_to_adf("**bold**")` emits marks `[{type:"strong"}]` on the text node

**Confidence**: HIGH
**Source**: `src/adf.rs::tests`
**Trace**: Pass 3 BC-1105

---

#### BC-7.2.003: ADF markdown round-trip covers: headings, lists, code blocks, blockquotes, tables, links

**Confidence**: HIGH
**Source**: `src/snapshots/jr__adf__tests__markdown_complex_to_adf.snap` (330-line snapshot)
**Subject**: Output rendering
**Behavior**: Canonical complex doc → ADF snapshot. Round-trip canary; specific bytes pinned.
**Trace**: Pass 3 BC-1117 (R4)

---

#### BC-7.2.004: ADF→text rendering: table render, code, headings preserved; lossy nodes (mention/emoji/inlineCard/media) silently dropped

**Confidence**: HIGH
**Source**: `src/adf.rs::tests`; `src/snapshots/jr__adf__tests__adf_to_text_complex.snap` (18-line snapshot)
**Subject**: Output rendering
**Behavior**: `_` fall-through arm at `adf.rs:531-540` silently drops unsupported nodes (documented per #202 spec). NFR-O-A (MEDIUM): ADF lossy nodes in text mode.
**Trace**: Pass 3 BC-1106; BC-1116 (R4)

---

#### BC-7.2.005: `markdown_to_adf("**bold text**")` body on wire: `marks: [{type: "strong"}]`; `text` is `"bold text"` NOT `"**bold text**"`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:647-687`
**Behavior**: Wire-level pin; markdown fully converted before HTTP.
**Trace**: Pass 3 BC-1056 (R4)

---

#### BC-7.2.006: `markdown_to_adf` produces only permitted child node types inside any `listItem` — `blockquote`, `heading`, `table`, and `rule` are normalized before output

**Confidence**: HIGH
**Source**: `src/adf.rs::normalize_list_item_content`; `src/adf.rs::flatten_table_to_paragraphs`; listItem unit tests in `src/adf.rs::tests`; `docs/specs/adf-listitem-content-model.md`
**Subject**: Output rendering
**Behavior**: The ADF `listItem` content model permits exactly five child node types: `paragraph`, `bulletList`, `orderedList`, `codeBlock`, `mediaSingle`. `markdown_to_adf` calls `normalize_list_item_content` on every `listItem` before `wrap_inlines_as_blocks`, applying four normalizations:
1. **`blockquote`** — unwrapped recursively; child block nodes are spliced inline in place of the `blockquote` node.
2. **`heading`** — converted to `paragraph`; inline content and marks are preserved exactly; the `level` attribute is dropped.
3. **`table`** — flattened by `flatten_table_to_paragraphs` to one `paragraph` per `tableRow` in `| a | b |` form; cell inline marks are preserved as real ADF marks (NOT via a lossy `adf_to_text` round-trip).
4. **`rule` (horizontal rule)** — dropped entirely; no replacement node emitted.

After normalization, no `listItem` in the output document contains any node type outside the five permitted types. This invariant holds recursively — nested lists whose items receive disallowed node types from nested markdown are also normalized.

**Edge cases**:
- A `blockquote` nested inside another `blockquote` inside a `listItem` is unwrapped recursively until all blockquote wrappers are removed.
- A `table` inside a `listItem` that contains cells with bold, italic, code, or link marks: cell paragraph nodes carry those marks as first-class ADF marks, not plain text with markdown syntax characters.
- A `rule` that is the only child of a `listItem`: after dropping the rule the `listItem` has no children; `wrap_inlines_as_blocks` subsequently wraps it in an empty `paragraph` to keep the list item structurally valid.
- A `listItem` containing only permitted node types (the common case): `normalize_list_item_content` is a no-op; output is byte-for-byte identical to pre-normalization behavior.

**Trace**: `src/adf.rs::normalize_list_item_content`; `src/adf.rs::flatten_table_to_paragraphs`; `src/adf.rs::tests` (listItem normalization unit tests); `docs/specs/adf-listitem-content-model.md`; issue #470 / PR #477

---

#### BC-7.2.007: `markdown_to_adf` maps `^x^`→`subsup` sup and `~x~`→`subsup` sub; double-tilde `~~x~~` stays `strike`

**Confidence**: HIGH
**Source**: `src/adf.rs::tests` (`test_markdown_superscript_to_subsup_sup`, `test_markdown_subscript_to_subsup_sub`, `test_markdown_intraword_superscript_stays_literal`, `test_markdown_double_tilde_still_strikethrough_not_subscript`, `test_render_subsup_mark_reverse_path`, `test_subsup_markdown_to_text_roundtrip`, `test_subsup_composes_with_strong`, `test_markdown_strike_sub_sup_coexist`, `test_markdown_nested_sub_in_sup_dedupes_subsup_mark`, `test_markdown_nested_sub_in_sup_keeps_outer_sup`, `test_markdown_superscript_no_mark_leak_to_trailing_text`)
**Subject**: Output rendering
**Behavior**: `markdown_to_adf` enables `Options::ENABLE_SUPERSCRIPT | Options::ENABLE_SUBSCRIPT`. The `AdfBuilder` handles the new pulldown-cmark events as follows:
- `Tag::Superscript` → `push_mark({"type":"subsup","attrs":{"type":"sup"}})` — text wrapped in `^…^` emits a `subsup` mark with `attrs.type = "sup"` on every text node inside the span.
- `Tag::Subscript` → `push_mark({"type":"subsup","attrs":{"type":"sub"}})` — text wrapped in single-tilde `~…~` emits a `subsup` mark with `attrs.type = "sub"`.
- Enabling `ENABLE_SUBSCRIPT` reassigns single-tilde `~x~` from strikethrough to subscript. Double-tilde `~~x~~` continues to produce `Tag::Strikethrough` → `strike` mark — this disambiguation is a load-bearing tokeniser behaviour of pulldown-cmark 0.13 pinned by `test_markdown_double_tilde_still_strikethrough_not_subscript`.
- **Deduplication (`dedup_marks_by_type`)**: ADF ProseMirror requires that each mark type appears at most once per text node. `dedup_marks_by_type` (a free function) filters `active_marks` to the first occurrence of each `type` value before emitting any text node. It is applied at both `push_text` and `push_code`. For nested same-type spans such as `^a ~b~ c^`, the inner text node `b` would otherwise carry two `subsup` marks (one sup from the outer `^`, one sub from the inner `~`); after dedup it carries exactly one `subsup` mark (first-wins, so `sup` (the outer span) in that specific nesting).
- **Reverse path (`adf_to_text`)**: The `apply_marks` function gains a `"subsup"` arm. If `attrs.type == "sub"`, the rendered text is wrapped as `~{text}~`; otherwise (sup or missing `type`) it is wrapped as `^{text}^`. This makes the markdown→ADF→text round-trip lossless for content that became a `subsup` mark (standalone `^x^` and `~x~`); intraword forms that never became a mark (EC-1) are out of scope of this guarantee — `^sup^` round-trips to `^sup^` and `~sub~` round-trips to `~sub~`.

**Edge cases**:
- **(EC-1) Intraword caret stays literal**: pulldown-cmark does not open a `Tag::Superscript` when `^` is immediately adjacent to a preceding word character. `mc^2^` produces literal text `mc^2^` with no `subsup` mark. Use `mc ^2^` (space before `^`) to produce a superscript. Pinned by `test_markdown_intraword_superscript_stays_literal`.
- **(EC-2) `code` mark cannot coexist with `subsup` on one text node**: ADF schema forbids the `code` mark alongside `subsup`, `em`, `strong`, or `strike` on the same text node. `` ^`x`^ `` (superscript wrapping a code span) would produce a node with both `code` and `subsup` marks, which Jira rejects with HTTP 400. This is an accepted known limitation in the same class as `` **`x`** `` (pre-existing); not guarded here, tracked as a follow-up.
- **(EC-3) Dedup is first-wins**: when two spans of the same type are nested (e.g., `^a ~b~ c^`), the first `subsup` mark encountered for a given text node is kept. The result is deterministic and consistent regardless of nesting depth.
- **(EC-4) Footnote marker interaction is inert**: `push_footnote_marker` (from issue #472) bypasses the dedup'd text-emission path entirely — it appends an unmarked text node directly via `append_child` without going through `push_text`, so `dedup_marks_by_type` is never called on that path. No interaction.

**Trace**: `src/adf.rs::markdown_to_adf` (Options block); `src/adf.rs::AdfBuilder::start` (Superscript/Subscript arms); `src/adf.rs::push_text` (dedup call); `src/adf.rs::push_code` (dedup call); `src/adf.rs::dedup_marks_by_type`; `src/adf.rs::apply_marks` (subsup arm); `src/adf.rs::tests` (`test_markdown_superscript_to_subsup_sup`, `test_markdown_subscript_to_subsup_sub`, `test_markdown_intraword_superscript_stays_literal`, `test_markdown_double_tilde_still_strikethrough_not_subscript`, `test_render_subsup_mark_reverse_path`, `test_subsup_markdown_to_text_roundtrip`, `test_subsup_composes_with_strong`, `test_markdown_strike_sub_sup_coexist`, `test_markdown_nested_sub_in_sup_dedupes_subsup_mark`, `test_markdown_nested_sub_in_sup_keeps_outer_sup`, `test_markdown_superscript_no_mark_leak_to_trailing_text`); issue #474

---

#### BC-7.2.008: `markdown_to_adf` consumes heading attribute syntax `## Title {#id}` instead of leaking it into heading text

**Confidence**: HIGH
**Source**: `src/adf.rs::tests` (`test_markdown_heading_attributes_stripped`, `test_markdown_heading_non_attribute_brace_stripped`)
**Subject**: Output rendering
**Behavior**: `markdown_to_adf` enables `Options::ENABLE_HEADING_ATTRIBUTES`. Once enabled, pulldown-cmark parses and discards id (`{#id}`), class (`{.cls}`), key-value (`{key=val}`), and combined (`{#id .cls}`) attribute blocks that appear at the end of a heading line — they are consumed internally by the parser and never emitted as `Event::Text`. The `AdfBuilder` requires no code change: heading text events already pass through the standard text handler; the absence of attribute-syntax text events means those characters never enter the heading node's content. Result: `## Title {#id}` yields a heading node whose text is exactly `"Title"`, not `"Title {#id}"`. ADF headings have no id attribute; the parsed id, class, and key-value values are silently dropped with no ADF representation.

**Edge cases**:
- **(EC-1) Four attribute forms are all consumed**: `{#myid}`, `{.cls}`, `{#id .cls}`, `{key=val}` — all produce heading text equal to the heading title only, with zero leakage. Pinned by `test_markdown_heading_attributes_stripped`.
- **(EC-2) Any trailing `{...}` block is consumed and dropped regardless of content**: when `ENABLE_HEADING_ATTRIBUTES` is active, pulldown-cmark consumes ANY trailing `{...}` block at the end of an ATX heading — including blocks whose contents are not valid attribute syntax. `## Foo {bar}` (contents `bar` contain no `#`, `.`, or `=`) yields heading text `"Foo"`, NOT `"Foo {bar}"`. Pinned by `test_markdown_heading_non_attribute_brace_stripped`. Scope: tested for the trailing-brace case only; behaviour for mid-heading braces (e.g., `## Fo{o} bar`) is untested and not asserted here.
- **(EC-3) No ADF id field emitted**: ADF does not support heading ids; there is no `id` field in the heading node's `attrs`. The parsed id value is consumed and not stored anywhere in the output document.

**Trace**: `src/adf.rs::markdown_to_adf` (Options block — `ENABLE_HEADING_ATTRIBUTES`); `src/adf.rs::tests` (`test_markdown_heading_attributes_stripped`, `test_markdown_heading_non_attribute_brace_stripped`); issue #474

---

### 7.3 Error Display

#### BC-7.3.001: `extract_error_message` 7-step precedence chain (canonical from source)

**Confidence**: HIGH
**Source**: `src/api/client.rs:448-490`; `tests/api_client.rs:257-342`
**Subject**: Output rendering
**Behavior**: Precedence (first match wins, returning `String`):
1. Empty body (len == 0) → literal string `"<empty response body>"` (early return before UTF-8 check)
2. Non-UTF-8 bytes → `String::from_utf8_lossy` with replacement chars (early return)
3. `errorMessages[]` non-empty (JSON array with at least one string element) → elements joined with `"; "`
4. `errors{}` non-empty (JSON object) → `"field: value"` pairs, alphabetically sorted, joined with `"; "`; non-string values use `serde_json::Value` display
5. `message` string field → as-is
6. `errorMessage` string field (singular; seen in JSM endpoints) → as-is
7. Raw body string fallback (non-JSON or no recognized field matches)

**Key invariant**: Empty body check is step 1 — the literal `"<empty response body>"` string IS the return value. There is no None/caller-derives path; the string propagates into `ApiError { message }`.

Note: The function doc comment inside client.rs lists precedence as "1. errorMessages … 5. Empty body … 6. Raw body" — this comment is STALE and does NOT reflect code execution order. Steps 1–2 are early returns before JSON parsing begins. Source code is authoritative; doc comment will be fixed in Phase 3. Corrected by R1 CONV-ABS-004; further corrected by ADV-P2-001.
**Trace**: Pass 3 BC-1201-R (R1); ADV-P2-001

---

#### BC-7.3.002: `errors{}` string values: `field: <value>`; non-string: `field: <serde_json::Value debug>`

**Confidence**: HIGH
**Source**: `src/api/client.rs:469-475`; `tests/api_client.rs:303-307`
**Behavior**: Mixed types: `{summary: "is req", customfield_10001: {messages:["invalid"]}}` → `customfield_10001: {"messages":["invalid"]}`.
**Trace**: Pass 3 BC-1201a (R1)

---

#### BC-7.3.003: `errors{}` iteration is alphabetically sorted (deterministic)

**Confidence**: HIGH
**Source**: `src/api/client.rs:477`; `tests/api_client.rs:286-292`
**Behavior**: `pairs.sort()` before join. `{summary: "req", priority: "req"}` → `priority: req; summary: req` (priority first).
**Trace**: Pass 3 BC-1201b (R1)

---

#### BC-7.3.004: Empty `errorMessages[]` and empty `errors{}` fall through to raw body (no early exit)

**Confidence**: HIGH
**Source**: `src/api/client.rs:459-466`; `tests/api_client.rs:294-300`
**Trace**: Pass 3 BC-1201c (R1)

---

#### BC-7.3.005: `--output json` + empty 4xx body → stderr JSON `{"error": "<empty response body>", "code": <exit>}`

**Confidence**: HIGH
**Source**: `src/main.rs:34-49`; `src/api/client.rs:448-490`
**Subject**: Output rendering
**Behavior**: When `--output json` is active AND the response has a zero-length body (4xx), `extract_error_message` returns the literal string `"<empty response body>"` (step 1 of BC-7.3.001). This string propagates into `JrError::ApiError { message }` and then into the JSON error envelope: `{"error": "<empty response body>", "code": <exit-code>}` to stderr. `code` is the integer exit code matching `JrError::exit_code()`. There is no status-code-derived substitution; the literal string IS the message.
**Edge case**: If body is `{}` (empty JSON object, NOT zero-length bytes), `extract_error_message` falls to step 7 (raw body `{}`), not the empty-body path. The `"<empty response body>"` literal only appears when `body.is_empty()` is true (byte length == 0).
**Trace**: Pass 3 BC-1208; BC-7.3.001 (extract_error_message); ADV-P1-026; ADV-P2-001

---

#### BC-7.3.006: `JrError::exit_code()` mapping

**Confidence**: HIGH
**Source**: `src/error.rs:51-62`; inline tests
**Subject**: Output rendering
**Behavior**: See error-taxonomy.md for full table. Key codes: NotAuthenticated=2, InsufficientScope=2, ConfigError=78, UserError=64, Interrupted=130, NetworkError=1, ApiError=1, Json=1, Http=1, Other=1, Success=0.
**Trace**: Pass 3 BC-1204

---

#### BC-7.3.007: All API errors must suggest a next step (CLAUDE.md convention)

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs`, `tests/issue_resolution.rs`, `tests/auth_refresh.rs`, `tests/issue_view_errors.rs`
**Subject**: Output rendering
**Behavior**: At least one of: `jr auth login`, `--jql`, `--resolution`, `jr issue resolutions`, `jr team list --refresh`, `board_id`, `check your connection`, `jr init` must appear in stderr.
**Trace**: Pass 3 BC-1212

---

#### BC-7.3.008: stderr must NEVER contain `panic`

**Confidence**: HIGH
**Source**: 16+ tests across `tests/*_errors.rs` files asserting `!stderr.contains("panic")`
**Subject**: Output rendering
**Behavior**: Universal constraint. All error paths produce friendly messages.
**Trace**: Pass 3 BC-1205

---

#### BC-7.3.009: Internal errors prefix with `Internal error:`

**Confidence**: MEDIUM
**Source**: `src/error.rs:30-36`
**Trace**: Pass 3 BC-1213

---

### 7.4 JSON Output Shapes (insta snapshot contracts)

All snapshots from `src/cli/issue/snapshots/` and `src/cli/snapshots/`. Keys are sorted alphabetically in insta output.

#### BC-7.4.001: move changed → `{"changed": true, "key": "TEST-1", "status": "In Progress"}`
**Source**: `jr__cli__issue__json_output__tests__move_response_changed.snap`
**Trace**: Pass 3 BC-1104 (R4)

#### BC-7.4.002: move unchanged → `{"changed": false, "key": "TEST-1", "status": "Done"}`
**Source**: `jr__cli__issue__json_output__tests__move_response_unchanged.snap`
**Trace**: Pass 3 BC-1105 (R4)

#### BC-7.4.003: assign changed → `{"assignee": "Jane Doe", "assignee_account_id": "abc123", "changed": true, "key": "TEST-1"}` — `assignee_account_id` is snake_case (NOT camelCase)
**Source**: `jr__cli__issue__json_output__tests__assign_changed.snap`
**Trace**: Pass 3 BC-1106 (R4)

#### BC-7.4.004: unassign → `{"assignee": null, "changed": true, "key": "TEST-1"}` — `assignee` is EXPLICIT null (NOT omitted)
**Source**: `jr__cli__issue__json_output__tests__unassign.snap`
**Trace**: Pass 3 BC-1108 (R4)

#### BC-7.4.005: edit → `{"key": "TEST-1", "updated": true}` — minimal 2-key shape
**Source**: `jr__cli__issue__json_output__tests__edit.snap`
**Trace**: Pass 3 BC-1109 (R4)

#### BC-7.4.006: link → `{"key1": "TEST-1", "key2": "TEST-2", "linked": true, "type": "Blocks"}` — symmetric key1/key2
**Source**: `jr__cli__issue__json_output__tests__link.snap`
**Trace**: Pass 3 BC-1110 (R4)

#### BC-7.4.007: unlink → `{"count": 2, "unlinked": true}`; no-match → `{"count": 0, "unlinked": false}` (count: 0 NOT omitted)
**Source**: `jr__cli__issue__json_output__tests__unlink_success.snap`
**Trace**: Pass 3 BC-1111 (R4)

#### BC-7.4.008: remote-link → `{"id": 10000, "key": "TEST-1", "self": <url>, "title": <title>, "url": <url>}` — id is u64
**Source**: `jr__cli__issue__json_output__tests__remote_link.snap`
**Trace**: Pass 3 BC-1112 (R4)

#### BC-7.4.009: sprint add → `{"added": true, "issues": [...], "sprint_id": 100}` — sprint_id snake_case
**Source**: `jr__cli__sprint__tests__sprint_add_response.snap`
**Trace**: Pass 3 BC-1113 (R4)

#### BC-7.4.010: sprint remove → `{"issues": [...], "removed": true}` — NO sprint_id (remove is sprint-agnostic)
**Source**: `jr__cli__sprint__tests__sprint_remove_response.snap`
**Trace**: Pass 3 BC-1114 (R4)

#### BC-7.4.011: auth list table → 4 cols: NAME, URL, AUTH, STATUS; active prefix `* ` (asterisk-space); inactive `  ` (2 spaces)
**Source**: `jr__cli__auth__tests__list_table_snapshot.snap`
**Trace**: Pass 3 BC-1115 (R4)

#### BC-7.4.012: `user view` hidden email → table shows em-dash `—`; JSON output shows explicit `null` (privacy boundary)
**Source**: `tests/user_commands.rs` BC-1132j/k
**Trace**: Pass 3 BC-1132j, BC-1132k (R4)

#### BC-7.4.013: `auth login --output json` emits `{"profile": <name>, "action": "login", "ok": true}` to stdout on success

**Confidence**: HIGH
**Source**: `src/cli/auth.rs::handle_login` (JSON branch); `src/cli/auth.rs::auth_json_response`
**Subject**: JSON output shape — auth login
**Behavior**: When `--output json` is set and `jr auth login` completes successfully, stdout receives exactly the JSON object `{"action": "login", "ok": true, "profile": "<profile-name>"}` (keys sorted alphabetically in insta output). The `profile` field reflects the profile name that was logged in. No other output is written to stdout. Human-readable success text is suppressed when `--output json` is active.

```json
{"action": "login", "ok": true, "profile": "<name>"}
```

Field types: `profile` is `string`, `action` is `string` literal `"login"`, `ok` is `bool` literal `true`.
**Production code**: `src/cli/auth.rs::handle_login` (JSON branch); helper `auth_json_response(profile_name, "login")`
**Snapshot test**: `src/cli/snapshots/jr__cli__auth__tests__auth_login_json_shape.snap`
**Trace**: S-2.07 v2.0.0 (BC-7.4.013, added 2026-05-08 by Fix-PR A)

---

#### BC-7.4.014: `auth switch --output json` emits `{"profile": <name>, "action": "switch", "ok": true}` to stdout on success

**Confidence**: HIGH
**Source**: `src/cli/auth.rs::handle_switch` (JSON branch); `src/cli/auth.rs::auth_json_response`
**Subject**: JSON output shape — auth switch
**Behavior**: When `--output json` is set and `jr auth switch <profile>` completes successfully, stdout receives exactly the JSON object `{"action": "switch", "ok": true, "profile": "<profile-name>"}` (keys sorted alphabetically). The `profile` field reflects the profile switched to. Human-readable success text is suppressed when `--output json` is active.

```json
{"action": "switch", "ok": true, "profile": "<name>"}
```

Field types: `profile` is `string`, `action` is `string` literal `"switch"`, `ok` is `bool` literal `true`.
**Production code**: `src/cli/auth.rs::handle_switch` (JSON branch); helper `auth_json_response(profile_name, "switch")`
**Snapshot test**: `src/cli/snapshots/jr__cli__auth__tests__auth_switch_json_shape.snap`
**Trace**: S-2.07 v2.0.0 (BC-7.4.014, added 2026-05-08 by Fix-PR A)

---

#### BC-7.4.015: `auth logout --output json` emits `{"profile": <name>, "action": "logout", "ok": true}` to stdout on success

**Confidence**: HIGH
**Source**: `src/cli/auth.rs::handle_logout` (JSON branch); `src/cli/auth.rs::auth_json_response`
**Subject**: JSON output shape — auth logout
**Behavior**: When `--output json` is set and `jr auth logout` completes successfully, stdout receives exactly the JSON object `{"action": "logout", "ok": true, "profile": "<profile-name>"}` (keys sorted alphabetically). The `profile` field reflects the profile logged out. Human-readable success text is suppressed when `--output json` is active.

```json
{"action": "logout", "ok": true, "profile": "<name>"}
```

Field types: `profile` is `string`, `action` is `string` literal `"logout"`, `ok` is `bool` literal `true`.
**Production code**: `src/cli/auth.rs::handle_logout` (JSON branch); helper `auth_json_response(profile_name, "logout")`
**Snapshot test**: `src/cli/snapshots/jr__cli__auth__tests__auth_logout_json_shape.snap`
**Trace**: S-2.07 v2.0.0 (BC-7.4.015, added 2026-05-08 by Fix-PR A)

---

#### BC-7.4.016: `auth remove --output json` emits `{"profile": <name>, "action": "remove", "ok": true}` to stdout on success

**Confidence**: HIGH
**Source**: `src/cli/auth.rs::handle_remove` (JSON branch); `src/cli/auth.rs::auth_json_response`
**Subject**: JSON output shape — auth remove
**Behavior**: When `--output json` is set and `jr auth remove <profile>` completes successfully, stdout receives exactly the JSON object `{"action": "remove", "ok": true, "profile": "<profile-name>"}` (keys sorted alphabetically). The `profile` field reflects the profile removed. Human-readable success text is suppressed when `--output json` is active.

```json
{"action": "remove", "ok": true, "profile": "<name>"}
```

Field types: `profile` is `string`, `action` is `string` literal `"remove"`, `ok` is `bool` literal `true`.
**Production code**: `src/cli/auth.rs::handle_remove` (JSON branch); helper `auth_json_response(profile_name, "remove")`
**Snapshot test**: `src/cli/snapshots/jr__cli__auth__tests__auth_remove_json_shape.snap`
**Trace**: S-2.07 v2.0.0 (BC-7.4.016, added 2026-05-08 by Fix-PR A)

---

### 7.5 Observability

#### BC-7.5.001: Verbose request logging emits `[verbose] METHOD URL` + `[verbose] body: <utf8>` (when body present)

**Confidence**: HIGH
**Source**: `src/api/client.rs:197-204, 274-279`
**Subject**: Output rendering
**Behavior**: Two lines per request. Body is utf-8 lossy. Retry logging: `[verbose] Rate limited (429). Retrying in {delay}s (attempt N/M)`. Authorization header NOT logged (NFR-S-C flag — body IS logged, auth NOT).
**Trace**: Pass 3 BC-1405; BC-1405-R (R1)

---

#### BC-7.5.002: `log_parse_failure_once` gate — parse failure logged at most once per (process, key)

**Confidence**: MEDIUM
**Source**: `src/observability.rs::tests`
**Trace**: Pass 3 BC-1109 (format.rs context)

---

#### BC-7.5.003: `format_duration(seconds)` collapses to `30m` / `2h` / `1h30m` (hours+minutes only; never weeks/days)

**Confidence**: HIGH
**Source**: `src/duration.rs:52-60`
**Trace**: Pass 3 BC-1107

---

## Key Invariants

- stdout = data; stderr = errors, warnings, hints (universal discipline)
- ADF lossy for mention/emoji/inlineCard/media — documented, not a bug
- JSON output uses snake_case for jr-internal fields (NOT Atlassian camelCase)
- Insta snapshots pin exact bytes — any glyph or key change breaks snapshot test
- `extract_error_message` empty-body check is FIRST (not last)
