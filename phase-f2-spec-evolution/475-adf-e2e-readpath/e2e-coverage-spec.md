---
document_type: e2e-coverage-spec
issue: 475
feature: "ADF E2E read-path coverage"
created: 2026-06-11
status: complete
story: "S-475-adf-e2e-readpath"
bc_anchors:
  - BC-7.2.003
  - BC-7.2.004
  - BC-7.2.006
---

# E2E Coverage Spec — Issue #475: ADF E2E Read-Path Coverage

## Problem Statement

The ADF subsystem (`src/adf.rs`) has comprehensive unit and snapshot tests for
the `markdown_to_adf` write direction. However, the `adf_to_text` **read
direction** — the path exercised when `jr issue view` or `jr issue comments`
renders an ADF body back to human-readable text — has zero live E2E coverage.
Additionally, `normalize_list_item_content` has never been exercised against a
real Jira Cloud instance (only against the Jira mock via unit tests).

Issue #475 closes these coverage gaps with three test additions and one rename.

## Scope

Test-only. No production code changes. No new BCs or NFRs.

Files that change in F4 (implementation):
- `tests/e2e_live.rs` — new test function + rename
- `tests/e2e_cli_surface_guard.rs` — SURFACE table rename (if entry exists)

Files that change in F3 (stories):
- `.factory/specs/stories/S-475-adf-e2e-readpath.md` — new story
- `docs/specs/e2e-live-jira-testing.md` — coverage matrix update (see §7 below)
- `bc-7-output-render.md` Trace fields — already updated in F2

## BC Anchors and AC Mapping

| AC | Test name (new/renamed) | BC anchored | Coverage added |
|----|-------------------------|-------------|---------------|
| AC-1 | `test_e2e_adf_read_path_human_output` | BC-7.2.003, BC-7.2.004 | First live exercise of `adf_to_text` via `jr issue view` human mode |
| AC-2 | sub-case within AC-1 | BC-7.2.006 | First live exercise of `normalize_list_item_content` against Jira Cloud |
| AC-3 | `test_e2e_adf_read_path_human_output` (same function, comment section) | BC-7.2.004 | First live exercise of `adf_to_text` via `jr issue comments` human mode |
| AC-4 | Rename `test_e2e_issue_markdown_description_roundtrip` → `test_e2e_markdown_description_produces_heading_node` | BC-7.2.003 | Name accuracy; no behavioral change |

## Gating

All new and renamed tests follow the standard two-layer gate (S-410):

```rust
#[tokio::test]
#[ignore]
async fn test_e2e_adf_read_path_human_output() {
    if !e2e_enabled() { return; }
    // ...
}
```

- `#[ignore]` — excluded from `cargo test` / `ci.yml` (never `--include-ignored`)
- `if !e2e_enabled() { return; }` — per-test early return guard
- `JR_RUN_E2E=1` — test-binary environment variable that enables `e2e_enabled()`
- `JR_E2E_ENABLED` — workflow-level repository variable that gates the CI job

The renamed test `test_e2e_markdown_description_produces_heading_node` retains
both attributes from `test_e2e_issue_markdown_description_roundtrip`; no gating
change is involved.

## Test Design: AC-1 and AC-2 (`test_e2e_adf_read_path_human_output`)

### Setup

1. Construct a markdown description string containing:
   - A level-2 heading (`## Section Header`)
   - An unordered list item whose body contains a blockquote
     (`- > nested blockquote text`) — this is the AC-2 normalization sub-case.
     **Precondition note (F2 adversary F2):** the string `- > nested blockquote text`
     must demonstrably parse to a blockquote inside a listItem (verified
     empirically in pulldown-cmark unit tests) — the normalization sub-case
     is only meaningful if this input parses as intended.
   - A fenced code block (`` ```\ncode snippet\n``` ``)
   - A hyperlink (`[link text](https://example.com)`)
   - A short paragraph of plain prose

2. Create a Jira issue:
   ```
   jr issue create --project <JR_E2E_PROJECT> --summary "ADF read path E2E" \
       --description-stdin --markdown --label <E2E_TEST_LABEL>
   ```
   The `--label <E2E_TEST_LABEL>` (same label used by other write tests in
   `e2e_live.rs`) is REQUIRED for the CI sweeper to clean up the issue.
   Capture the returned JSON key.

   **[Adversary F1 fix]** Without a label, the CI sweeper cannot find and
   delete this issue — it becomes a permanent orphan on the live Jira site.

3. Wait for the issue to be readable via the standard `poll_view` helper used
   elsewhere in `e2e_live.rs`. The poll should gate on the *presence* of the
   description content before any absence assertion runs (see AC-2 below).

### AC-1 Assertion: human-mode view renders text

```rust
// Use the real harness pattern from e2e_live.rs (~line 481-485):
let output = harness.cmd().args(["issue", "view", &key]).output()
    .expect("jr issue view failed");
let stdout = String::from_utf8_lossy(&output.stdout);

// Assert text rendered by adf_to_text appears in output.
// Use content words from the original markdown — NOT ADF node names.
assert!(stdout.contains("Section Header"), "heading text must appear in view output");
assert!(stdout.contains("link text"), "link text must appear in view output");
assert!(stdout.contains("code snippet"), "code block content must appear in view output");
// Blockquote content was normalized — assert the text word appears somewhere in
// the rendered output (sanity check that normalization did not silently drop content):
assert!(stdout.contains("nested blockquote text"), "blockquote content text must appear in view output");
```

**Assertion strategy:** Match on content words from the original markdown prose,
NOT on ADF structural terms (`paragraph`, `heading`, `blockquote`, `listItem`).
This makes assertions resilient to minor rendering changes while still verifying
that `adf_to_text` is producing output (not empty or error).

**[Adversary F6 fix]** Code block is now asserted. All four content constructs
in the fixture are asserted: heading, link, code, blockquote text.

### AC-2 Assertion: listItem normalization succeeds (no Jira 400)

AC-2's primary assertion is that `jr issue create` exits 0. A Jira 400 would
indicate that `normalize_list_item_content` failed to strip the blockquote
before submission.

Secondary assertions via `jr issue view <key> --output json` JSON inspection:

**Step 1 — poll-gate (positive content presence):**
Before asserting structural absence, confirm the description content has landed
and contains a `listItem` node. This prevents false passes on stale/empty reads.

**[Adversary F4/F5 fix]** The inspection channel is `jr issue view <key> --output json`,
which returns a `fields.description` JSON object containing the ADF tree. The
positive gate assertion should confirm `listItem` nodes exist before the
absence assertion runs.

```rust
// Verify create exits 0 (no Jira 400 from invalid ADF)
assert!(output.status.success(), "create with blockquote-in-listItem must exit 0");

// Use the real poll_view helper (e2e_live.rs:~474):
//   poll_view(key, &harness) — returns serde_json::Value of `jr issue view <key> --output json`
let json_output = poll_view(&key, &harness);
let description_json = &json_output["fields"]["description"];

// Positive gate: confirm listItem nodes are present (prevents vacuous absence assertion
// on stale or empty ADF). Uses existing adf_has_node_type (e2e_live.rs:~8950).
let has_list_item = adf_has_node_type(description_json, "listItem");
assert!(has_list_item, "ADF must contain listItem nodes (positive gate before absence assertion)");

// Sanity check: confirm "nested blockquote text" appears somewhere in the ADF text
// content (uses existing adf_contains_text, e2e_live.rs:~8932). This is a cheap
// guard that the content was not silently dropped, though it cannot independently
// distinguish "unwrapped" from "preserved in place" — the absence assertion below
// is the definitive normalization check.
assert!(
    adf_contains_text(description_json, "nested blockquote text"),
    "blockquote text must appear in the ADF (sanity check — content not dropped)"
);

// Absence assertion: no blockquote node inside any listItem.content.
// adf_has_blockquote_in_list_item is a NEW helper to be authored in F4
// (analogous to existing adf_has_task_item at e2e_live.rs:~8912).
assert!(
    !adf_has_blockquote_in_list_item(description_json),
    "listItem.content must not contain a blockquote node after normalize_list_item_content"
);
```

**Helper inventory:**
- `poll_view(key, &harness)` — **existing** (`e2e_live.rs:~474`); returns `serde_json::Value` of `jr issue view <key> --output json`.
- `adf_has_node_type(json, type_str)` — **existing** (`e2e_live.rs:~8950`).
- `adf_contains_text(json, text)` — **existing** (`e2e_live.rs:~8932`).
- `adf_has_blockquote_in_list_item(json)` — **NEW** (to be authored in F4); walks `listItem` nodes and returns true if any `listItem.content` array contains a node with `type == "blockquote"`. Modelled on `adf_has_task_item` (`e2e_live.rs:~8912`).

**[F1-M1 fix]** All previously "existing" helper names now correctly reflect the actual function names in `e2e_live.rs`; the new helper is explicitly marked NEW.

## Test Design: AC-3 (comment read path, within same test function)

After the issue view assertions (AC-1, AC-2), the same test function continues:

**AC ordering dependency:** AC-3 reuses the issue created in AC-1. If AC-1's
create step fails, the test should early-return (issue key is unavailable).
Within the single test function, the sequencing is: create → AC-1 asserts →
AC-2 asserts → comment seed → AC-3 asserts → teardown. No skip logic needed
beyond the early-return gate at the top. **[Adversary F9 fix]**

1. Seed a comment via `jr issue comment <key> "Comment **body** with _emphasis_" --markdown`.
2. Invoke `jr issue comments <key>` (human/table mode, no `--output json`).
3. Assert stdout contains the rendered form produced by `adf_to_text`:

```
// adf_to_text is a markdown RE-EMITTER: strong → **x**, em → *x* (single asterisk).
// Assert the RE-EMITTED form appears — not the raw input markdown syntax.
//
// Input:  "Comment **body** with _emphasis_"
// After markdown_to_adf → Jira → adf_to_text:
//   strong "body"   renders as  **body**
//   em "emphasis"   renders as  *emphasis*   (single asterisk, NOT underscore)
assert!(stdout_comments.contains("**body**"), "strong text must render as **body**");
assert!(stdout_comments.contains("*emphasis*"), "em text must render as *emphasis* (single asterisk)");

// The underscore form _emphasis_ is consumed by markdown_to_adf into an em mark;
// adf_to_text re-emits it as *emphasis*, so _emphasis_ should NOT appear.
// This distinguishes the live adf_to_text round-trip from a raw passthrough:
// a passthrough would contain "_emphasis_"; the rendered path produces "*emphasis*".
assert!(!stdout_comments.contains("_emphasis_"),
    "underscore em syntax must not appear — adf_to_text re-emits em as *x*, not _x_");
```

Note: `--markdown` on `jr issue comment` converts the comment body through
`markdown_to_adf` before submission. The AC-3 read path then exercises
`adf_to_text` in `cli/issue/comments.rs`. The key differentiator is the
`_emphasis_` → `*emphasis*` transform: a raw passthrough would leave the
underscore form intact; the live `adf_to_text` path converts it to
single-asterisk `em` rendering. The `**body**` positive assertion confirms
strong rendering is intact (output is non-empty and marks are applied).

## Test Design: AC-4 (rename)

The rename `test_e2e_issue_markdown_description_roundtrip` →
`test_e2e_markdown_description_produces_heading_node` is a mechanical change:

Touch-points for the rename (all must be updated in F4):

1. **`tests/e2e_live.rs`** — rename the function definition.
2. **`docs/specs/e2e-live-jira-testing.md:~123`** — the bullet
   `- \`test_e2e_issue_markdown_description_roundtrip\` — a heading in the markdown...`
   must be updated to `test_e2e_markdown_description_produces_heading_node`.
   **[F1-H1 fix]** This file was missing from the AC-4 touch-point list.
3. **`tests/e2e_cli_surface_guard.rs` SURFACE table** — NOT affected. The SURFACE
   table is keyed on CLI command paths (e.g. `("issue", "create")`), not test
   function names. The rename requires no SURFACE row update.

**New test CLI surface registration — RESOLVED (no action needed):**
The three CLI paths invoked by `test_e2e_adf_read_path_human_output` are already
registered in `tests/e2e_cli_surface_guard.rs` (verified at F2 time):
- `("issue", "view")` — line 73, flags `["--output"]`. Human-mode invocation
  adds no flags; the row covers it.
- `("issue", "comment")` — line 118, flags `["--output","--internal","--file","--stdin","--markdown"]`.
  `--markdown` is already registered.
- `("issue", "comments")` — line 122, flags `["--output"]`. No-flag invocation covered.

No new SURFACE rows needed. **[F1-L1 resolved as hard fact]**

Verify `tests/e2e_cli_surface_guard.rs::test_parser_paths_are_subset_of_surface_table`
passes after the rename — it should, since no SURFACE entries change.

Rationale: The old name `roundtrip` implies that the test reads back the ADF
and verifies the full cycle. In fact, the test only asserts that the ADF
document submitted to Jira contains a `heading` node (forward direction only —
`markdown_to_adf`). The new name `test_e2e_markdown_description_produces_heading_node`
accurately reflects the forward-only assertion.

Convention: `test_<verb>_<subject>_<expected_outcome>` per
`docs/specs/test-naming-convention.md`:
- verb: `e2e` (scope prefix) + `markdown_description` (subject) + `produces` (verb)
- expected_outcome: `heading_node`
- Full decomposition: `test_` + `e2e` + `_` + `markdown_description` + `_produces_` + `heading_node`

## Teardown

The issue created in `test_e2e_adf_read_path_human_output` relies on the
label-based CI sweeper for cleanup. **[Adversary F1 fix]** The `--label`
flag MUST be passed at issue creation time (see Setup step 2 above). The
specific label value is whatever label the other write tests in `e2e_live.rs`
use for the sweeper — F4 implementer must inspect the existing tests to use
the correct label constant or variable. No `best_effort_close` call is needed
since this is a standard issue (not a JSM request), but calling `best_effort_close`
at the end of the test is acceptable as a belt-and-suspenders measure.

## Server-Side ADF Mutation Guardrail (research-validated)

Source: `.factory/research/issue-475-adf-e2e-external-validation.md` Claim 3,
`developer.atlassian.com` accessed 2026-06-11.

### Confirmed Risk

Jira Cloud silently normalizes/rewrites submitted ADF on store. Observed
mutations include: `localId` injection on nodes, reordering/consolidation of
adjacent marks, coalescing of consecutive paragraphs within a container, and
silent dropping of schema-invalid nodes (rather than returning HTTP 400).
Atlassian publishes **no exhaustive, contractual list** of store-time transforms —
the exact mutation set is empirically observed and version-drifting.

### Mandatory Assertion Constraint (codifies existing AC design — do not relax)

All ACs MUST assert structural invariants and/or `adf_to_text` rendered output.
NEVER assert raw returned-ADF-tree equality or use JSON snapshots of the full
ADF tree.

**Rationale per AC:**

- **AC-1:** asserts rendered text via `adf_to_text` (content-word substrings
  from the original markdown). Robust to `localId` injection, mark reordering,
  and paragraph coalescing — those mutations do not change the rendered text
  for the constructs used.
- **AC-2:** asserts (a) create returned HTTP 2xx / no 400, and (b) the
  **negative structural invariant** — no `blockquote` node is a direct child
  of any `listItem` in the returned ADF tree. Does NOT assert the list subtree
  byte-for-byte. This is the correct form: paragraph coalescing or `localId`
  injection inside the list would not affect the blockquote-absence invariant.
- **AC-3:** asserts `adf_to_text` rendered text of the returned comment body.
  Same robustness as AC-1.

**Warning for future maintainers:** do NOT tighten these assertions into
exact-ADF snapshot comparisons (e.g. `assert_eq!(description_json, expected_adf)`).
That would introduce flakiness against server normalization — tests would fail
on any Jira-side `localId` schema update or mark-ordering change without any
`jr` code change. Node-type presence/absence and rendered-text assertions are
the correct granularity.

### Verified Guardrails (confirmed facts)

**Read path returns raw ADF, not rendered HTML (code-confirmed 2026-06-11):**

- `get_issue` (`src/api/jira/issues.rs:~426`): URL is
  `/rest/api/3/issue/{key}?fields={}` — NO `expand=renderedFields`.
  The returned `fields.description` is a raw ADF JSON object.
- `list_comments` (`src/api/jira/issues.rs:~654`): URL is
  `/rest/api/3/issue/{key}/comment?startAt=N&maxResults=N&expand=properties` —
  NOT `expand=renderedBody`. The returned `comments[].body` is a raw ADF JSON
  object.

Both paths confirmed by direct code inspection. The tests inspect ADF, not HTML.
This guardrail is already satisfied and must remain satisfied if either function
is ever modified.

**Fixture constraint — no `@mentions` or user-identity nodes:**
The current AC-1/AC-2/AC-3 markdown fixtures (headings, bold, em, lists, code
block, blockquote) contain no user mentions. Do not add `@mention` nodes to
test fixtures. GDPR/privacy processing makes user-mention rendering
non-deterministic across accounts (returned ADF may differ based on the
requesting account's permission level). Source: Claim 5, Atlassian deprecation
notice, accessed 2026-06-11.

**Tolerance for server mutations:**
Tests must tolerate: injected `localId` attributes, reordered/coalesced marks,
coalesced adjacent paragraphs. The node-type-walk and rendered-text assertion
strategies (mandated above) already provide this tolerance.

**Recency (non-blocking monitor items):**
No breaking change to `GET /rest/api/3/issue` or `GET .../comment` ADF
representation in the last ~12 months (2025–2026). One adjacent item to
monitor: classic API token deprecation for Jira Product Discovery **GraphQL**
operations (effective 2026-11-01) — does NOT affect the REST v3 issue/comment
endpoints used by these tests. Source: Claim 5, developer.atlassian.com
changelog, accessed 2026-06-11.

## Out of Scope

- The `adf_to_text` JSON round-trip (reading ADF back and re-encoding to JSON)
  is not tested here. That is a separate concern.
- Coverage of every markdown construct (`subsup`, `panel`, `taskList`, etc.) in
  the E2E read path. AC-1 verifies the path is exercised; comprehensive
  construct coverage is deferred to a follow-up issue.
- `--output json` view shape is already covered by existing E2E tests.

## Section to Add to `docs/specs/e2e-live-jira-testing.md` (F3 story-writer action)

The following section should be appended to the ADF coverage portion of the
live testing doc when F3 story-writer updates it. It is documented here rather
than directly edited to respect the F2/F3 boundary.

---

### ADF Read-Path Coverage (issue #475)

| Test | AC | BC Anchors | Coverage |
|------|----|------------|----------|
| `test_e2e_adf_read_path_human_output` | AC-1 | BC-7.2.003, BC-7.2.004 | `jr issue view` human mode: `adf_to_text` output verified via content-word substring matching |
| `test_e2e_adf_read_path_human_output` | AC-2 | BC-7.2.006 | `normalize_list_item_content` live: blockquote-in-listItem create exits 0; JSON inspect confirms no blockquote node in listItem.content |
| `test_e2e_adf_read_path_human_output` | AC-3 | BC-7.2.004 | `jr issue comments` human mode: seeded comment body text appears after `adf_to_text` rendering |
| `test_e2e_markdown_description_produces_heading_node` | AC-4 (rename) | BC-7.2.003 | Formerly `test_e2e_issue_markdown_description_roundtrip`; forward markdown→ADF only; name now accurate |

Gate: `JR_RUN_E2E=1` + `#[ignore]` + `if !e2e_enabled() { return; }`.
No new env vars required beyond the standard E2E set.

---
