# F1 Impact Boundary: ADF `code` mark exclusivity (issue #571)

- **Date:** 2026-07-07
- **Feature cycle:** ADF-CODE-MARK-EXCLUSIVITY
- **GitHub issue:** #571
- **Research basis:** `.factory/research/issue-571-adf-code-mark-exclusivity-2026-07-07.md`

---

## 1. Affected component map

### Epicenter: `src/adf.rs::push_code`

**Classification: MODIFIED**

`push_code` is the single emit path for all inline `code` marks. It fires from
`AdfBuilder::process_event` when pulldown-cmark yields `Event::Code(text)` (line ~504).

Root cause (lines ~1284–1290):
```rust
let mut marks = self.active_marks.clone();
marks.push(json!({ "type": "code" }));
self.append_child(json!({
    "type": "text",
    "text": text,
    "marks": dedup_marks_by_type(&marks),
}));
```

When `active_marks` contains `strong`, `em`, `strike`, or `subsup` (because the inline
code appears inside a bold/italic/etc. span), the emitted text node carries e.g.
`marks: [strong, code]`. The ADF JSON schema (`code_inline_node.marks.items.anyOf`)
permits only `{code, link, annotation}` on a code-carrying text node; the server-side
validator rejects anything else with HTTP 400.

**Fix site:** `push_code` only. Before building the marks array, strip any typographic
marks from the cloned `active_marks` set; retain `link` and `annotation` (both are
schema-valid on `code_inline_node`). No other function needs touching on the write path.

### No other `code`-mark emitters exist

A full grep of `src/` for sites that push a `"code"` mark to a text node yields only
`push_code` at line ~1285. Every other `"code"` string occurrence in `src/adf.rs` is
either a detection pattern in `autolink_bare_urls`, a constant in the reverse-render
`apply_marks`, or a test fixture. The post-pass functions (`normalize_list_item_content`,
`normalize_blockquote_content`, `normalize_panel_content`, `assign_local_ids_walk`,
`autolink_bare_urls`) do not emit code marks.

### `src/adf.rs::autolink_bare_urls` — NOT CHANGED

Already skips text nodes carrying a `code` mark (lines ~216–227):
```rust
Some("link") | Some("code") => /* skip */
```
This is correct and must be preserved. No change needed.

### `src/adf.rs::dedup_marks_by_type` — NOT CHANGED

Only deduplicates marks of the same type. Not responsible for cross-type exclusivity.
The fix belongs in `push_code`, not here.

### `src/adf.rs::apply_marks` (reverse render) — NOT CHANGED; decision below

`apply_marks` applies `code` innermost regardless of its position in the marks array
(see `src/adf.rs::apply_marks` docstring). Its own docstring explicitly notes that
`push_code` used to emit `[strong, code]`, and the innermost-code logic was a
compensating display strategy.

After the fix, `markdown_to_adf` will no longer produce `[strong, code]` on a
single node. However, `adf_to_text` is a **read function** — it processes ADF returned
by the Jira REST API (existing issues, fetched comments) and may encounter legacy or
third-party ADF that carries typographic + code marks together. Retaining reading
leniency for `[strong, code]` and similar combos is the correct posture: the write path
enforces the schema; the read path renders whatever arrives without rejecting it.

**Decision: `apply_marks` is NOT changed. Its code-innermost behavior is retained as
deliberate read-tolerance.** This is the same tolerance model used by `adf_to_text` for
other historically-invalid constructs.

---

## 2. Component classification table

| Component | Classification | Rationale |
|-----------|---------------|-----------|
| `src/adf.rs::push_code` | MODIFIED | Root cause; fix site |
| `src/adf.rs::dedup_marks_by_type` | DEPENDENT (read-only context) | Called from `push_code`; no change to this function, but behavior at call site changes when typographic marks are stripped before the call |
| `src/adf.rs::apply_marks` | DEPENDENT (reverse read path) | Called from `adf_to_text`; not modified; retains leniency for externally-produced ADF |
| `src/adf.rs::autolink_bare_urls` | DEPENDENT (post-pass) | Already skips code nodes; no change needed |
| `src/adf.rs` — forward test `test_markdown_inline_code_mark_and_composition` | MODIFIED (test update) | Currently pins INVALID behavior (`code + strong` on same node); must be updated |
| `src/adf.rs` — reverse tests `test_render_marks_code_and_strong`, `test_render_strong_with_code_applies_code_innermost` | RETAINED (not updated) | Test the read-path leniency; remain valid after the fix |
| `src/cli/issue/create.rs` | DEPENDENT (call site) | Calls `markdown_to_adf`; no code change needed |
| `src/cli/issue/edit.rs` | DEPENDENT (call site) | Calls `markdown_to_adf`; no code change needed |
| `src/cli/issue/workflow.rs` | DEPENDENT (call site) | Calls `markdown_to_adf` for `--markdown` comments; no code change needed |
| `src/api/jsm/requests.rs` | DEPENDENT (call site) | Calls `markdown_to_adf` for JSM request descriptions; no code change needed |
| `src/cli/worklog.rs` | NOT AFFECTED | Uses `text_to_adf`, not `markdown_to_adf`; no markdown parsing, no code marks |
| All other `src/` files | NOT AFFECTED | Do not call `markdown_to_adf` or emit code marks |

---

## 3. Structural classification

**Internal-logic-only change. No new modules. No structural changes.**

The fix is confined to a single method body (`push_code`) within the `AdfBuilder`
struct in `src/adf.rs`. No new files, no new public API surface, no new modules. The
function signature of `push_code` is unchanged (it is a private method); the change is
purely in how the marks array is built before `append_child` is called.

There is a potential for a small helper function — e.g. a `strip_typographic_marks`
free function inside `src/adf.rs` — to keep `push_code` readable, but this would be
a private function in the same file; it does not change the module structure.

---

## 4. Regression risk per module

### `src/adf.rs` — HIGH

Core shared module. Every markdown write surface flows through `markdown_to_adf`,
which dispatches to `push_code` for inline code events. The risk is HIGH because:

- Any incorrect stripping (e.g., stripping `link` in addition to typographic marks) would
  break the schema-valid `code + link` combination (confirmed legal by the ADF schema;
  see research §Claim E).
- Any conditional over-scoping could affect plain inline code (no surrounding marks) if
  the condition is misdrafted.
- The existing forward test currently pins the *wrong* behavior; it will fail after the
  fix and must be rewritten to pin the correct behavior. This is expected.
- Several adjacent tests (`test_url_in_inline_code_not_linkified`,
  `test_markdown_inline_code_is_preserved_in_bold_context`, etc.) must still pass —
  regression baseline.

Mitigation: the fix is a single-site filter on a private method body. The scope for
collateral damage is narrow. All test suites for `markdown_to_adf` cover the output.

### `src/cli/issue/create.rs`, `edit.rs`, `workflow.rs`, `src/api/jsm/requests.rs` — LOW

Call sites. The change they see is that `markdown_to_adf` no longer returns a
schema-invalid node for `**\`code\`**`-style inputs. No code change at these sites.
Existing integration tests that exercise the full issue-create/edit/comment paths are
the regression baseline; they will pass or fail based on the `adf.rs` change, not
their own code.

### All other modules — NO RISK (not involved)

---

## 5. Write surfaces that depend on `markdown_to_adf`

All five surfaces that invoke `markdown_to_adf` are affected by the bug and by the fix:

| Surface | Call site | Markdown flag / path |
|---------|-----------|----------------------|
| Issue create — description | `src/cli/issue/create.rs::handle_create` | `--description` / `--description-stdin` |
| Issue edit — description | `src/cli/issue/edit.rs` | `--description` / `--description-stdin` |
| Issue comment (markdown mode) | `src/cli/issue/workflow.rs::handle_comment` | `--markdown` flag on `jr issue comment` |
| JSM request create — description | `src/api/jsm/requests.rs::JsmRequestBuilder` | `use_markdown: true` path |

The JSM path shares the same `markdown_to_adf` pipeline as the platform path.
Research §Claim D found no evidence of endpoint-specific leniency between
`/rest/servicedeskapi/request` and `/rest/api/3/issue`; both are treated identically.

**Not affected:** `worklog add --message` uses `text_to_adf` (no markdown parsing;
plain text with newlines only), so it cannot produce code marks and is out of scope.
`jr issue comment` without `--markdown` also uses `text_to_adf`.

---

## 6. Reverse-path decision: `adf_to_text` and its tests

`adf_to_text` calls `apply_marks` (line ~2514) which applies `code` innermost
regardless of array position. This behavior is:

1. **Correct for display:** rendering `[strong, code]` as `` **`x`** `` (not `` `**x**` ``)
   matches the semantic intent of the original markdown source.

2. **Appropriate as read-tolerance:** `adf_to_text` reads ADF from Jira's API.
   Existing issues may have been created by other tools (Jira web editor, third-party
   integrations, or earlier `jr` versions before this fix) and could carry typographic +
   code combos. Refusing to render them, or rendering them incorrectly, would be a
   regression for users who read issue descriptions.

3. **Not a validation concern:** reading leniency does not imply writing leniency. The
   read path rendering a `[strong, code]` node does not mean the write path is permitted
   to emit one.

**Decision: `apply_marks` and the two reverse-path tests are RETAINED unchanged.**

- `test_render_marks_code_and_strong` (line ~6564): tests reading `[code, strong]` ADF.
  Valid after fix; retained as-is.
- `test_render_strong_with_code_applies_code_innermost` (line ~6666): tests reading
  `[strong, code]` ADF. Valid after fix; retained as-is.

The `apply_marks` docstring references `push_code` emitting `[strong, code]` — this
will become historically inaccurate after the fix. The docstring should be updated to
note that the innermost-code logic is retained for read-tolerance of externally-produced
ADF, not because the write path still emits that combination. (This is a doc change
within `src/adf.rs`, not a behavior change.)

---

## 7. Files changed / not changed summary

### Files that will be modified

| File | Change type | Description |
|------|------------|-------------|
| `src/adf.rs` | Logic + test update | `push_code`: strip typographic marks before emitting; `test_markdown_inline_code_mark_and_composition`: update to assert correct single-mark behavior; new forward tests for em/strike/subsup + code combos; `apply_marks` docstring update |

### Files that will NOT be modified (regression baseline)

| File | Reason unchanged |
|------|----------------|
| `src/cli/issue/create.rs` | Call site; no code change needed |
| `src/cli/issue/edit.rs` | Call site; no code change needed |
| `src/cli/issue/workflow.rs` | Call site; no code change needed |
| `src/api/jsm/requests.rs` | Call site; no code change needed |
| `src/cli/worklog.rs` | Uses `text_to_adf`; unaffected |
| All other `src/` files | No `markdown_to_adf` call; no code mark emit path |
| `tests/` integration tests | Behavior improvement (HTTP 400 bug fixed); no test updates needed unless a test explicitly expected the broken output |

### New test coverage needed (in `src/adf.rs`)

The implementation ticket should add forward tests for all four excluded typographic
marks + code combos to prevent regression:

- `**\`code\`**` — `strong + code` (the original bug report, currently pinned wrong)
- `*\`code\`*` — `em + code`
- `~~\`code\`~~` — `strike + code`
- `^\`code\`^` — `subsup + code` (superscript)
- `~\`code\`~` — `subsup + code` (subscript)
- `[**\`code\`**](url)` — `link + strong + code` (link must be preserved; strong stripped)
- `\`code\`` — plain inline code; no marks stripped; must continue to work

Each of these should assert that the emitted node carries only `{code}` (or `{code,
link}` where a link mark is present), with no typographic marks.

---

## 8. Scope boundary — what is explicitly out of scope

- **`annotation` marks:** `annotation` is schema-valid on `code_inline_node` (confirmed,
  research §Claim A). `jr` never emits `annotation` marks today, but the fix must not
  strip them if any future path were to add one. The type-exclusion list must be an
  explicit allowlist (`keep: link, annotation`) rather than a denylist.

- **`underline`, `textColor`, `backgroundColor` marks:** `jr` does not currently emit
  these; they are excluded from `code_inline_node` by the schema. Treating them the same
  as `strong`/`em`/`strike`/`subsup` (strip on code) is safe and forward-compatible.
  However, since `jr` doesn't emit them today, they are not a regression risk for this
  cycle and can be included in the exclusion list defensively without requiring dedicated
  tests.

- **`codeBlock` content:** `push_code` handles inline `Event::Code` only. Code fences
  (`\`\`\``) are handled by a separate block-level path and never interact with
  `active_marks`. Out of scope.

- **`adf_to_text` behavior for schema-invalid input:** Read tolerance is retained (see
  §6). No scope here to harden `adf_to_text` against all possible invalid ADF inputs.

- **Splitting mixed-range nodes:** The research (§Claim C) documents a "split-nodes"
  strategy for `**a \`b\` c**` (where bold wraps both plain text and inline code). This
  fix cycle does NOT implement node-splitting; it uses the simpler drop-typographic-mark
  strategy. The output for `**a \`b\` c**` will be: `"a "` node with `[strong]`, `"b"`
  node with `[code]` only (strong stripped), `" c"` node with `[strong]`. This is
  schema-valid and semantically reasonable (code semantics preserved; bold on prose
  preserved; bold lost on the code span only — same as Atlaskit's own editor behavior
  for a code-only range). This is the minimal, schema-correct output; node-splitting to
  preserve bold-on-mixed-content would be a follow-up enhancement if user demand warrants.
