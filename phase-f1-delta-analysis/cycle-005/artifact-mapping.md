---
document_type: phase-f1-delta-analysis
level: ops
producer: business-analyst
cycle: cycle-005
feature_mode_bundle: adf-mentions
issue: "#674"
status: draft
timestamp: 2026-09-06
inputs:
  - src/adf.rs
  - .factory/specs/prd/bc-7-output-render.md
  - .factory/specs/prd/bc-3-issue-write.md
  - .factory/specs/prd/cross-cutting.md
  - .factory/specs/prd/CANONICAL-COUNTS.md
  - .factory/specs/prd/nfr-catalog.md
  - .factory/specs/prd/holdout-scenarios.md
  - .factory/stories/STORY-INDEX.md
traces_to: ""
input-hash: "87d279c"
---

# Artifact Mapping — cycle-005 "adf-mentions" (issue #674)

Companion to the architect's `delta-analysis.md` in this same directory (not authored or
touched here). This file is the business-analyst's requirements-side mapping: which
existing BCs are affected, what regression zone protects them, what tests are the
baseline, what VP extensions are needed, and the feature-classification inputs the
architect needs for the trivial-scope determination.

## 1. BC Mapping

### 1.1 Existing BCs — MODIFIED

| BC | Current text (summary) | Why MODIFIED |
|---|---|---|
| **BC-7.2.004** | `adf_to_text`: table/code/headings preserved; lossy nodes (**mention**/emoji/inlineCard/media) silently dropped | Not modified by the MVP scope itself (MVP is write-path only: `markdown_to_adf`). Flagged MODIFIED-candidate, not MODIFIED-confirmed, because once `jr` itself starts *emitting* mention nodes (via `--description`/comment `--markdown`), the existing silent-drop-on-read behavior becomes user-visible in jr's own round-trip surfaces (see §7 below: `issue edit --dry-run` ADF preview, `issue view` rendering of a mention jr itself created). **Decision needed at F2**: keep BC-7.2.004 UNCHANGED (mention stays a reverse-path no-op, consistent with NFR-O-I's "physical implementation of the rendering is still future work (issue #202)" note) vs. extend `adf_to_text` to render `mention` → `@<attrs.text>` fallback `@<attrs.id>`. Recommend architect decide; either choice is a spec edit to BC-7.2.004, not a code-only decision, because NFR-O-I currently documents the drop as deliberate. |
| **BC-3.3.008** | `issue create --markdown -d '...'` converts markdown to ADF before POST | MODIFIED — this is the exact call site the mention post-pass rides through for `issue create --description --markdown`. No wire-shape change to the BC itself (still "converts markdown to ADF before POST"), but the BC's Behavior/EC section needs a new EC noting `[~accountid:...]`/`@Name` tokens are now recognized inside that conversion. |
| **BC-3.4.003 / BC-3.4.004** | `issue edit` PUTs ADF description; `markdown_to_adf("**bold text**")` → `strong` mark example | MODIFIED — same rationale as BC-3.3.008, for the edit path's `--description --markdown`. |
| **BC-3.5.009** | `comment edit` body source flags (`--file`/`--stdin`/positional/`--markdown`) | MODIFIED — mention recognition applies wherever `--markdown` triggers `markdown_to_adf`, which includes `comment edit`. Needs an EC cross-reference to the new mention BC. |
| **BC-3.5.001** | `issue comment add <key> --internal` adds `sd.public.comment` property | MODIFIED-candidate for the interaction note in scope item (e): document that comment *visibility* (`--internal`/`--public`) and mention *notification* are orthogonal — Jira, not jr, decides whether an internal comment's mention reaches a JSM customer (a customer without portal/internal access silently does not get notified, mirroring the existing "invalid id fails silently" behavior). Recommend as an EC addition to BC-3.5.001 rather than a body rewrite. |
| **BC-3.8.006** | JSM create: `--description` → `requestFieldValues.description`; `--markdown` triggers ADF | MODIFIED — same call-site rationale as BC-3.3.008/3.4.003, for `jr issue create --request-type ... --markdown`. Confirms scope item (e) also touches the JSM create path, not just comment. |

### 1.2 Existing BCs — UNCHANGED (but load-bearing / cited for regression safety)

- **BC-7.2.001..003, 005..015** — the rest of the ADF conversion family (bold/italic marks, round-trip coverage, listItem normalization, subsup, heading-attrs, GFM alerts→panel, task lists, block-HTML hardBreak, recursion-depth guard, footnotes, autolink, code-mark exclusivity). The mention post-pass is additive (a new recognized inline token + a new emitted node type); it must not perturb any of these. All are regression baseline, not touched by this feature's scope.
- **BC-3.4.012 / BC-3.4.013** — `issue edit` changed-fields echo (table `(updated)` marker / JSON raw-input-string). The mention-bearing description still flows through the same echo path; no new echo behavior is in scope (echo shows raw input text, mentions included, unchanged).
- **BC-3.4.017** — `--field` C-1 guard + flag-overlap list (`summary`/`description`/`issuetype`/`priority`/`components`). Unaffected — mentions ride inside `--description`'s existing value, not a new flag.
- **BC-X.7.001** — `user search Q` GETs `/rest/api/3/user/search?query=Q`. This is the **existing precedent BC** for the @Name→accountId resolution mechanism (scope item 2). No wire-shape change needed; the mention resolver is a new *caller* of this already-specified endpoint.
- **BC-X.7.004** — Duplicate display names + `--no-input` → exit non-zero, stderr shows emails+accountIds+duplicate name. This is the **existing precedent BC** for disambiguation UX (scope item 2's "disambiguation"). The mention resolver should reuse this contract's shape rather than inventing a new one — flag to architect as a "reuse, don't reinvent" constraint for F2.
- **BC-3.3.002 / BC-3.3.005** — `issue create` assignee resolution via `search_assignable_users_by_project` + "not-found stops short of create". Structurally analogous prior art for "resolve a human-readable identity to an accountId before the mutating call," though NOT the same endpoint (assignable/multiProjectSearch is project-scoped; mention resolution per the validated research should use the *unscoped* `/user/search` per BC-X.7.001, since a mentioned user need not be assignable to the issue's project). Cited so F2 doesn't accidentally reuse the wrong resolver.

### 1.3 NEW BCs needed

Proposed IDs are the next available slot in each family's existing numbering (verified via
grep against the current bodies — see Detail column). Bodies are NOT authored here (F2 scope).

| Proposed ID | Scope-item | Family / next-available basis | One-line intent |
|---|---|---|---|
| **BC-7.2.016** | (a) forward conversion | bc-7 §7.2 ADF Rendering; last existing is BC-7.2.015 | `markdown_to_adf` post-pass recognizes `[~accountid:<id>]` and emits `{"type":"mention","attrs":{"id":"<id>"}}` |
| **BC-7.2.017** | (d) attrs.text population | same family, next slot after BC-7.2.016 | Defines whether/how `attrs.text` is populated for the raw `[~accountid:<id>]` form (MVP: likely omitted — no HTTP lookup available at conversion time in `adf.rs`, which is a pure function) vs. the `@Name`-resolved form (CLI layer already has the display name from user-search, and should pass it through so the emitted node carries `attrs.text: "@<DisplayName>"`) |
| **BC-7.2.018** | interaction w/ BC-7.2.004 | same family | Documents the reverse-path decision for mention nodes jr itself produced (see §1.1 BC-7.2.004 row) — whichever way F2 decides, it needs its own contract so BC-7.2.004's "silently dropped" text isn't silently contradicted |
| **BC-X.7.007** | (b) @Name resolution + disambiguation | cross-cutting §X.7 Users; last existing is BC-X.7.006 | New shared resolver (`resolve_mention_target` or similar) wrapping `search_users` (BC-X.7.001) with disambiguation reusing BC-X.7.004's contract shape, callable from create/edit/comment-add |
| **BC-3.3.012** | (a)+(b) wiring into create | bc-3 §3.3 Issue Create; last existing is BC-3.3.011 | `issue create --description` recognizes `[~accountid:]`/`@Name` tokens when `--markdown` is set; resolution failure behavior (exit code, zero-POST guarantee mirroring BC-3.3.005) |
| **BC-3.4.032** | (a)+(b) wiring into edit | bc-3 §3.4 Issue Edit; last existing is BC-3.4.031 | Same as BC-3.3.012 for `issue edit --description` |
| **BC-3.5.013** | (a)+(b)+(e) wiring into comment add | bc-3 §3.5 Comment; last existing is BC-3.5.012 | `issue comment add` recognizes mention tokens in the body; interaction with `--internal`/`--public` documented per §1.1 BC-3.5.001 row (visibility and notification are orthogonal — Jira-side, not jr-side) |
| **BC-3.8.018** | (a)+(b)+(e) wiring into JSM create | bc-3 §3.8 JSM Create; last existing is BC-3.8.017 | Same as BC-3.3.012 for `jr issue create --request-type ... --description --markdown` (JSM path uses a separate `handle_jsm_create` body-assembly function per ADR-0014 — needs its own contract, cannot just cite BC-3.3.012) |
| **BC-7.2.019** (or fold into BC-7.2.017) | (c) invalid-id silent failure | bc-7 §7.2 | Documents, as a jr-side behavioral contract (not just a research note), that jr performs NO client-side accountId format/existence validation before emitting the mention node for the raw `[~accountid:<id>]` form — an invalid id round-trips to Jira and fails silently there (per the validated research); jr's own success/exit-code behavior is unaffected by id validity. This is a "document the boundary of jr's responsibility" BC, important for the holdout/EC catalog so a future reviewer doesn't mistake the silent Jira-side failure for a jr defect. |

**Range summary to reserve at F2:** `BC-7.2.016..019` (4), `BC-X.7.007` (1), `BC-3.3.012` (1),
`BC-3.4.032` (1), `BC-3.5.013` (1), `BC-3.8.018` (1). **9 new individually-bodied BCs**,
pending F2's actual drafting (some may collapse — e.g. BC-7.2.017/018/019 could merge into
fewer bodies; architect/product-owner call at F2, not decided here).

## 2. Regression-Risk Story Zone

- **`docs/superpowers/plans/2026-03-21-jr-implementation.md` Task 9 ("ADF Handling")** — the
  original `src/adf.rs` implementation (`text_to_adf`, `markdown_to_adf`, `adf_to_text`) predates
  the STORY-NNN system; this is the true origin of the module the mention post-pass extends.
- **S-471-adf-task-lists.md, S-474-adf-minor-constructs.md, S-483-adf-gfm-alerts-panel.md,
  S-492-adf-block-html-hardbreak-fix.md, S-522-adf-push-text-cr-normalization.md,
  S-ADF-CODE-MARK-1.md** — the incremental post-v1 stories that each added a `markdown_to_adf`
  post-pass or emission-site guard (task lists, subsup/heading-attrs, GFM alerts→panel,
  block-HTML hardBreak, CR/LF normalization chokepoint, code-mark exclusivity respectively).
  The mention post-pass is architecturally the same shape as these (a `finish()`-time or
  inline pass over the built tree, same as `autolink_bare_urls`/`assign_local_ids`) — same
  regression-risk profile: MAX_ADF_DEPTH recursion guard, `is_empty_block_container` pruning,
  and the INV-1 (no raw `\n`/`\r` in non-codeBlock text nodes) chokepoint must all keep holding.
- **S-577-1.md .. S-577-6.md** — comment CRUD subcommand group (`jr issue comment add/edit/
  delete/view`), the regression zone for scope item's comment-add wiring.
  BC-3.5.001..012 all trace here.
- **S-398-issue-edit-create-changed-fields-echo.md** — the changed-fields echo mechanism
  (BC-3.4.012/013) that will echo a mention-bearing description's raw input string unchanged.
- **S-692-1-dry-run-stdin-adf-preview.md** — `issue edit --dry-run` renders the actual
  `descriptionAdf` (the built ADF tree, not a text rendering) into the JSON preview
  (BC-3.4.021). This is the regression zone for confirming a mention node surfaces correctly
  in the dry-run preview's `plannedChanges.descriptionAdf` — since the preview shows the ADF
  tree itself, not `adf_to_text` output, the BC-7.2.004 reverse-path question (§1.1) does NOT
  block this preview from showing mentions correctly; only `issue view`'s human-readable
  render (which does go through `adf_to_text`) is affected by that open question.
- **Field DX bundle stories (S-578-*, issue #578/#580)** — not directly touched, but
  `create.rs`/`field_resolve.rs` are the same files the mention wiring for `--description`
  lives in; F4 implementers must not disturb the D2 `CREATE_D2_GOVERNED_KEYS` guard or the
  createmeta resolution flow documented at length in CLAUDE.md's `cli/issue/create.rs` /
  `field_resolve.rs` Known Size Deviations entries.

## 3. Affected Tests (regression baseline to keep green)

- **`src/adf.rs` inline tests** (543 `#[test]`/`fn test_` occurrences) — the full markdown→ADF,
  ADF→text, and round-trip suite. Any mention post-pass must run as a genuinely additive pass
  (mirroring `autolink_bare_urls`'s post-`finish()` placement) so none of these regress.
- **`tests/adf_code_mark_exclusivity.rs`, `tests/adf_inline_html_inv1_e2e.rs`,
  `tests/adf_recursion_depth.rs`** — integration-level ADF invariant guards (code-mark
  exclusivity, INV-1 CR/LF chokepoint, MAX_ADF_DEPTH). The mention node's own text content
  (if any, e.g. `attrs.text`) must respect INV-1; the mention node itself must be depth-guard
  compatible (it's a leaf inline node, so this should be a no-op concern, but worth an explicit
  regression test per the recursion-guard's own history of surprising escapes).
- **`tests/comment_crud_api.rs`, `tests/comments.rs`, `tests/comment_edit.rs`,
  `tests/comment_delete.rs`, `tests/comment_view.rs`** — comment CRUD wire-shape and CLI-surface
  tests; comment-add markdown-body tests live inside `tests/comments.rs`/`tests/cli_smoke.rs`
  per the current grep (no dedicated `comment_add.rs` file exists — new mention tests for
  comment add should extend `tests/comments.rs`, not create a redundant file, unless F3
  decides otherwise).
- **`tests/issue_create_echo.rs`, `tests/issue_create_field.rs`, `tests/issue_create_json.rs`,
  `tests/issue_create_jsm.rs`** — create-path echo/JSON/JSM coverage; the JSM one is directly
  relevant to BC-3.8.018 (interaction e).
- **`tests/issue_edit_echo.rs`, `tests/issue_edit.rs`, `tests/issue_edit_field.rs`** —
  edit-path echo/field coverage relevant to BC-3.4.032.
- **`tests/duplicate_user_disambiguation.rs`, `tests/user_commands.rs`,
  `tests/multi_cloudid_disambiguation.rs`** — existing disambiguation-pattern tests; the new
  `resolve_mention_target` helper (BC-X.7.007) should be tested in the same style, and these
  files are the closest existing analog for a fresh-context test-writer to imitate rather than
  invent a new disambiguation UX.
- **`tests/e2e_cli_surface_guard.rs`** — offline `--help` surface guard; must be updated if
  any new flag surfaces (scope as written implies NO new flag — mentions ride inside the
  existing `--description`/comment-body value — so this file should need zero changes; flag to
  F3/F4 as a thing to verify, not assume).

## 4. VP Extensions + New VPs

**Caveat on VP counting**: this repo's VP identifiers are issue-scoped (`VP-<issue#>-NNN`,
e.g. `VP-571-001..005`, `VP-577-001..030`), inline `**Verification Properties**:` subsections
inside the owning BC body — there is no separate `.factory/specs/verification-properties/`
directory in this repo (a grep for one returned nothing) and no per-file VP frontmatter count
to reconcile against. A raw grep of all `VP-[A-Za-z0-9]*-[0-9]{3}` identifiers across
`bc-*.md` found 177 distinct ids; STATE.md's frontmatter tracks a running total of "55 VPs"
which does not reconcile against that raw count under any grouping tried (neither
"distinct ids" nor "distinct issue-prefix groups" = 55). This is a pre-existing counting-basis
ambiguity, not something introduced by this cycle — flagging it for the architect/state-manager
rather than guessing at a reconciliation. **Recommendation**: treat STATE.md's 55 as the
authoritative running total to increment, using this cycle's *proposed new-VP count* below
as the delta, and let state-manager's existing bookkeeping process reconcile the basis (same
as it does for every prior cycle).

- **Extends VP-571-00x pattern** (property-based invariant + example EC anchors, node-scoped
  stripping, reverse-path read-tolerance) as the template shape for the new mention VPs —
  BC-7.2.015 was "the first inline VP subsection in bc-7"; the mention BCs should follow the
  same convention (inline `**Verification Properties**:` subsection under whichever of
  BC-7.2.016..019 ends up owning the forward-conversion body).
- **New VPs proposed** (issue-scoped `VP-674-NNN`, following the established convention):
  1. `VP-674-001` — property: for any valid accountId-shaped string `S`, `markdown_to_adf("[~accountid:" + S + "]")` emits exactly one `mention` node with `attrs.id == S`, nested correctly inside its enclosing paragraph/mark context (mirrors VP-571-001's property-based framing).
  2. `VP-674-002` — example-based: `@Name` resolution happy path — a single unambiguous user-search match resolves to the correct accountId and the emitted node's `attrs.text` (if BC-7.2.017 decides to populate it) matches the resolved display name.
  3. `VP-674-003` — example-based: `@Name` resolution disambiguation — duplicate display names reuses BC-X.7.004's exit/stderr contract verbatim (no new disambiguation UX invented).
  4. `VP-674-004` — negative/no-HTTP: the raw `[~accountid:<id>]` form performs **zero** HTTP calls during conversion (pure-function invariant of `adf.rs` — mirrors the "cache warm-hit no-HTTP" invariant class already established for BC-6.2.018/S-CACHE-WARM-HIT-COVERAGE-1, applied here to prove the accountId path never round-trips through user-search).
  5. `VP-674-005` — mark-interaction: a mention token inside active marks (`**[~accountid:X]**`, inside a link, inside a code span) either composes correctly or is explicitly rejected/escaped — needs an explicit rule the same way BC-7.2.015 nailed down code-mark exclusivity (mention nodes are typically NOT markable the way text nodes are — ADF's `mention` node type has its own restricted mark set; this needs empirical verification against the ADF schema at F2/F4, same "F4 empirical check" pattern VP-571-002 used).
  6. `VP-674-006` — depth/INV-1 regression pin: mention post-pass does not defeat `MAX_ADF_DEPTH` (BC-7.2.012) or introduce a raw `\n` (INV-1) via any `attrs.text` content.

  **6 new VPs proposed** (VP-674-001..006), pending F2 refinement (may split/merge, e.g. if
  BC-7.2.017 attrs.text turns out MVP-out-of-scope, VP-674-002/005 partially collapse).

## 5. Feature-Type

**backend** (not ui / full-stack / infrastructure).

Rationale: `jr` is a CLI/backend tool wrapping the Jira REST API v3 directly (ADR-0001 thin
client). This feature is entirely: (a) a pure-function extension to `src/adf.rs` (markdown→ADF
conversion, no I/O), (b) a new HTTP-calling resolver reusing an already-specified endpoint
(`GET /rest/api/3/user/search`, BC-X.7.001) wired into three existing CLI handlers
(`create.rs`, `edit.rs`, `interactions.rs`/comment-add), and (c) CLI-surface wiring with zero
new flags (mentions ride inside existing `--description`/comment-body text values). There is
no UI layer in this repository at all — "full-stack" and "ui" do not apply — and no
infrastructure/CI/deployment surface is touched.

## 6. Intent

**feature** (new capability), not enhancement or bug-fix.

Justification: prior to this cycle, `jr` has **no mechanism** by which a CLI-authored
comment or description can @-notify a Jira user — `markdown_to_adf` has never emitted a
`mention` node (confirmed: `grep -n mention src/adf.rs` finds only the `_`-catch-all reverse-
path comment referencing NFR-O-I, never a forward-path emission site), and `adf_to_text`
only ever *drops* mention nodes on read (BC-7.2.004). This is a functional gap ("cannot
notify anyone") closed by wholly new code paths (a new inline-token recognizer in the
markdown converter, a new resolver calling an existing-but-previously-uncalled-for-this-
purpose endpoint), not a fix to broken existing behavior and not a refinement of an existing
mention capability (none exists). Matches the "functional gap" framing in the task prompt.

## 7. Trivial-Scope Input (for architect's determination)

Feeding the architect's trivial-scope gate, not deciding it:

- **New BCs needed?** Yes — 9 proposed (§1.3). Exceeds any "0 new BCs, doc-sync only" trivial
  threshold by a wide margin.
- **Modules touched?** At minimum: `src/adf.rs` (forward conversion + possible reverse-path
  decision), a new or extended user-resolution module (likely `src/api/jira/users.rs` plus a
  new shared CLI-layer helper — `src/cli/issue/helpers.rs` is the existing home for
  team/points/user resolution helpers per CLAUDE.md's file map, so the mention resolver
  likely belongs there rather than a new file), `src/cli/issue/create.rs`,
  `src/cli/issue/edit.rs`, `src/cli/issue/interactions.rs` (comment add), and
  `src/cli/issue/jsm_create.rs` (JSM create path per BC-3.8.018, ADR-0014's separate
  dispatch fork). **6 source modules minimum**, well past "1 module touched."
  Additionally, this feature was already handed to F1 as a bundle named `adf-mentions`
  targeting Feature Mode (not quick-dev/maintenance), so the mode decision is effectively
  already made upstream of this analysis — this section documents why that routing is correct,
  not a fresh recommendation.
- **Conclusion input**: NOT trivial scope. Full F1→F7 Feature Mode pipeline is warranted.

## 8. Projected Counts After This Cycle

| Metric | Current (per STATE.md v3.74 / CANONICAL-COUNTS.md) | Projected delta | Projected after cycle-005 |
|---|---|---|---|
| total_bcs | 742 | +9 (BC-7.2.016..019, BC-X.7.007, BC-3.3.012, BC-3.4.032, BC-3.5.013, BC-3.8.018) — may net down 1-2 if F2 merges the attrs.text/reverse-path/invalid-id trio (BC-7.2.017/018/019) into fewer bodies | **~750-751** |
| VPs | 55 (STATE.md running total; basis not independently reconcilable, see §4 caveat) | +6 (VP-674-001..006) | **~61** |
| holdout scenarios | 106 | +1 to +2 — the existing holdout-scenarios.md:456 "Mention node silently dropped (current behavior)" scenario should be revisited (it currently documents the pre-#674 reverse-path drop as an oracle; if BC-7.2.004/018 changes that behavior even for jr-authored mentions, this holdout's expected output needs a matching update, not necessarily a new scenario) plus at minimum 1 new holdout for the forward-path happy case (comment/description with `@Name` mention → notification-eligible ADF on the wire) | **107-108** |
| stories | 172 | +3 to +5 new S-674-* stories at F3 (plausible split: 1 for the `adf.rs` forward conversion + resolver, 1 for create/edit wiring, 1 for comment-add wiring, possibly 1 for JSM-create wiring, possibly 1 for the BC-7.2.004 reverse-path decision if F2 elects to implement it rather than defer) | **175-177** |

These are business-analyst estimates for F1 sizing only; F2 (spec-evolution) and F3
(story decomposition) own the authoritative counts once BCs/VPs/stories are actually drafted.

---

## Summary for Orchestrator

- 5 existing BCs flagged MODIFIED (BC-7.2.004 conditionally, BC-3.3.008, BC-3.4.003/004,
  BC-3.5.009, BC-3.5.001, BC-3.8.006); ~15 existing BCs cited UNCHANGED-but-load-bearing
  including the two key precedents this feature should reuse rather than reinvent
  (BC-X.7.001 user-search endpoint, BC-X.7.004 duplicate-name disambiguation contract).
- 9 new BCs proposed across bc-7 (ADF), cross-cutting (X.7 Users), and bc-3 (create/edit/
  comment/JSM-create wiring) — IDs reserved as next-available slots, bodies deferred to F2.
- Regression zone: `docs/superpowers/plans/2026-03-21-jr-implementation.md` Task 9 (adf.rs
  origin) + 6 post-v1 ADF stories (S-471/474/483/492/522/S-ADF-CODE-MARK-1) + S-577-1..6
  (comment CRUD) + S-398 (echo) + S-692-1 (dry-run ADF preview).
  `src/adf.rs`'s 543-test inline suite plus 15+ integration test files are the baseline to
  keep green.
  6 new VPs proposed (VP-674-001..006); a pre-existing VP-counting-basis ambiguity was found
  and flagged (not caused by this cycle).
- Feature-type: backend. Intent: feature (functional gap, no prior mention capability exists).
  Not trivial scope — 6+ source modules, 9 new BCs. Feature Mode pipeline confirmed warranted.
- One open design question surfaced for the architect: whether `adf_to_text`'s existing
  silent-drop-mention behavior (BC-7.2.004) should be extended now that jr itself emits
  mention nodes, since `issue view`'s human-readable render (not the dry-run JSON preview,
  which shows the raw ADF tree and is therefore unaffected) goes through that reverse path.

## Alternative decomposition (F2 input)

**Provenance:** a second, independent business-analyst F1 run (dispatched due to an
orchestrator coordination error — the same F1 scope was accidentally re-run) produced a
second `artifact-mapping.md`, originally written to
`.factory/cycles/cycle-005/phase-f1-delta-analysis/artifact-mapping.md`. That file has been
reconciled into this canonical document and removed; the two points below are its genuinely
distinct proposals, preserved here so F2 (architect + product-owner) has both inputs to
choose from or reconcile. Everything else in that second run substantially overlapped the
decomposition above and is not repeated.

**1. Reverse-path disposition — committed close of #202/NFR-O-I, not left open.**
Where §1.1 (BC-7.2.004 row) and the proposed-IDs table above frame the `adf_to_text`
reverse-path interaction as an **open F2 decision** (keep BC-7.2.004 unchanged vs. extend
it), the alternative run instead proposes a concrete, individually-bodied BC:

| Proposed ID | Family | Covers | Requirement letter |
|---|---|---|---|
| **BC-7.2.019** | ADF Rendering | `adf_to_text` reverse-path render of `mention` nodes: implements the render hint already stubbed in the existing `_ =>` catch-all comment (render `attrs.text` if present, else a `@?` fallback) instead of silently dropping. This BC is the one that **closes issue #202 and NFR-O-I** and is the direct AMENDMENT target for BC-7.2.004. | reverse-path / closes #202 & NFR-O-I |

Under this proposal, BC-7.2.004's body is amended to *remove* `mention` from its
"silently dropped" node-type enumeration and cross-reference BC-7.2.019, rather than
leaving the disposition as a still-open question for F2 to first decide and then encode.
Two supporting VPs are proposed alongside it: `VP-674-007` (reverse-render `@?` fallback
when `attrs.text` is absent) and `VP-674-008` (property/round-trip test — mention nodes
never crash `adf_to_text` at any legal inline-content nesting position).

**2. `@Name` resolution — 3-way BC split, not one shared-resolver BC.**
Where the proposed-IDs table above collapses `@Name` resolution (happy path +
disambiguation) into a single **BC-X.7.007** ("New shared resolver ... wrapping
`search_users` with disambiguation reusing BC-X.7.004's contract shape"), the alternative
run splits it into three individually-bodied BCs along the resolution-outcome boundary:

| Proposed ID | Family | Covers | Requirement letter |
|---|---|---|---|
| **BC-X.7.007** | Cross-Cutting Users | `@Name` resolves via `GET /rest/api/3/user/search?query=` to **exactly one** accountId → silently converted to a mention node (happy path). Requires "Browse users" permission; GDPR-safe `query` param, not `username`. | (b) |
| **BC-X.7.008** | Cross-Cutting Users | `@Name` resolving to **2+** candidates → disambiguation, mirroring the fail-closed pattern already established by BC-X.7.004 and the `resolve_component`/`resolve_assignee` precedent: non-interactive/`--no-input` → exit 64 listing candidate display names + accountIds; interactive → `dialoguer::Select`. | (b) |
| **BC-X.7.009** | Cross-Cutting Users | `@Name` resolving to **zero** candidates → exit 64. Deliberate asymmetry with the raw-token path: an already-resolved accountId is never validated (silent Jira-side no-op), but a bare `@Name` IS validated at CLI resolution time because the CLI itself must call user-search to turn a name into an id. | (b) |

Two supporting VPs are proposed alongside this split: `VP-674-009` (`@Name` unique-match
resolution) and `VP-674-010` (`@Name` ambiguous/zero-match exit-64 taxonomy, non-interactive
and interactive). A third VP, `VP-674-011`, covers JSM internal/public mention-visibility
notification orthogonality (proposed against a `BC-3.5.013` slot in both runs, with slightly
different scope emphasis — the alternative run frames it specifically as
"mention presence does not alter the existing visibility-routing contracts"
vs. this document's framing of general comment-add wiring).

**Net effect on projected new-BC/VP counts if F2 adopts the alternative shape:** +1 BC
overall (3 `@Name` BCs instead of 1, but −0 net from folding the reverse-path decision into
a committed BC instead of a deferred one — i.e. 8 proposed here vs. **10** individually-bodied
BCs under the alternative: BC-7.2.016/017/018/019 ×4, BC-X.7.007/008/009 ×3, BC-3.3.012,
BC-3.4.032, BC-3.8.018, BC-3.5.013 — architect/product-owner should reconcile overlap at F2,
not decide it here); VP count would land at **+11** (VP-674-001..011) rather than the +6
(VP-674-001..006) estimated above. **F2 is the deciding phase for both points — this section
records both proposals, it does not resolve between them.**

---

File written: `.factory/phase-f1-delta-analysis/cycle-005/artifact-mapping.md`
