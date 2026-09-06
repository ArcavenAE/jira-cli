---
document_type: architecture-delta
phase: phase-f2-spec-evolution
issue: 674
cycle: cycle-005
producer: architect
timestamp: 2026-09-06
status: complete
inputs:
  - .factory/phase-f1-delta-analysis/cycle-005/delta-analysis.md
  - .factory/phase-f2-spec-evolution/prd-delta-674.md
  - .factory/specs/prd/bc-7-output-render.md
  - .factory/specs/prd/cross-cutting.md
  - .factory/specs/prd/bc-3-issue-write.md
  - .factory/specs/architecture/ARCH-INDEX.md
  - .factory/architecture/system-overview.md
  - .factory/architecture/component-graph.md
  - .factory/architecture/dtu-assessment.md
input-hash: "504dd1e"
---

# Architecture Delta — GitHub #674 ("adf-mentions", cycle-005)

Feature Mode Phase F2, Step 3 (architect). This is an incremental architecture delta, not a
rewrite — everything below is additive to the existing architecture. No new subsystem, no
new external dependency, no structural redesign.

## 1. Summary of Architecture Changes

| Change | File(s) | Status |
|---|---|---|
| New ADR | `.factory/specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` | Written |
| ADR registered | `.factory/specs/architecture/ARCH-INDEX.md` (Architecture Decisions table) | Updated |
| Purity Boundary delta | `.factory/architecture/system-overview.md` §Purity Boundary | Updated (new `[PLANNED, F2 2026-09-06 — Markdown Mentions, issue #674, ADR-0023]` bullet, following the exact precedent set by the Component Management / Field DX deltas) |
| Dependency-graph delta | `.factory/architecture/component-graph.md` (new `§Markdown Mentions Delta — DAG Verification` section) | Updated |
| DTU confirmation | `.factory/architecture/dtu-assessment.md` §3 Verdict | Updated (confirmation note; `DTU_REQUIRED` unchanged at `false`) |
| F2-gate human decision: `@Name` single-result tightening | ADR-0023 §7 (new) | Written — resolves `EC-X.7.007-5`; see §9 below |

**Note on architecture-doc locations:** this repository's actual working architecture documents
(system overview, component/dependency graph, DTU assessment, risk register) live in
`.factory/architecture/` — a pre-VSDD-factory-migration layout that predates and has continued
alongside the newer sharded-template convention. `.factory/specs/architecture/` holds only
`ARCH-INDEX.md` and `decisions/` (ADR-0017+), per that file's own header note ("ADRs 0001–0016
predate the VSDD-factory migration and live in `docs/adr/`"). Every prior Feature Mode
architecture delta for this repo (issue #288's JSM dispatch fork, the Component Management
bundle, the Field DX bundle) updated the SAME `.factory/architecture/*.md` files this delta
updates, using the same `[PLANNED, F2 <date> — <feature>, issue #<n>, ADR-NNNN; no src/ code
exists yet]` bullet convention for the purity boundary and the same `## <Feature> Delta — DAG
Verification` section shape for the component graph. This delta follows that repo-specific,
already-established convention rather than introducing a parallel sharded set of section files
that no prior cycle in this repo's history has used.

## 2. New/Modified Component Definitions

### 2.1 `src/adf.rs` — three new PURE functions + two new pure data types (additive)

- `pub(crate) fn find_mention_candidates(markdown: &str) -> Result<MentionCandidates, JrError>`
  — read-only scan, zero HTTP, reuses the same `TextMergeStream<Parser>` build the rest of
  `markdown_to_adf` runs.
- `pub fn markdown_to_adf_with_mentions(markdown: &str, resolved: &MentionResolutions) -> Result<Value, JrError>`
  — the real converter body, extended: bracket-form spans always convert; `@Name` spans convert
  only when `resolved` has a matching entry.
- `pub fn markdown_to_adf_no_mentions(markdown: &str) -> Result<Value, JrError>` — the
  `--no-mentions` bypass entrypoint; byte-for-byte pre-#674 behavior.
- `pub fn markdown_to_adf(markdown: &str)` — **UNCHANGED signature**, becomes a 1-line wrapper:
  `markdown_to_adf_with_mentions(markdown, &MentionResolutions::empty())`.
- New pure data types, defined in `adf.rs` (not `types::`, not CLI-local — see ADR-0023 §2 for
  the ownership rationale): `MentionCandidates` (scan output, undeduplicated), `MentionResolutions`
  (resolution lookup, keyed per-form: accountId for bracket-form, literal `@Name` span text for
  the `@Name` form), `MentionResolution` (`{account_id, display_name}`).
- `AdfRenderer::render_node` gains a new pure `"mention"` match arm (BC-7.2.019), inserted
  before the existing `_` catch-all.

**Purity Boundary Map:** all of the above are **pure core**. `markdown_to_adf`'s classification
is unchanged; the three new functions and the reverse-render arm join it in the pure column.
Recorded in `system-overview.md §Purity Boundary` (new delta bullet) and cross-checked in
`component-graph.md §Markdown Mentions Delta`.

### 2.2 `src/cli/issue/mentions.rs` (NEW FILE) — effectful CLI-layer resolver

```rust
pub(super) async fn resolve_mentions(
    client: &JiraClient,
    text: &str,
    no_input: bool,
) -> Result<MentionResolutions, JrError>
```

- Sits in **SS-02 (CLI Layer)**, effectful shell — same purity class as
  `cli::issue::helpers::resolve_user`/`resolve_assignee`/`resolve_assignee_by_project`.
- Classified as an L2 **support module** (no dispatch of its own), the same architectural role
  `cli::issue::helpers`/`cli::issue::field_resolve` already occupy — not a new top-level command.
- Calls `adf::find_mention_candidates` (pure), then deduplicates candidates per unique
  bracket-id/`@Name` token BEFORE issuing any HTTP call, then:
  - one `GET /rest/api/3/user?accountId=<id>` per unique bracket-form id (`JiraClient::get_user`,
    reused as-is — BC-X.7.010),
  - one `GET /rest/api/3/user/search?query=<Name>` + `helpers::disambiguate_user` per unique
    `@Name` token (`JiraClient::search_users`, reused as-is — BC-X.7.007/008/009).
- Reuses `helpers::disambiguate_user` verbatim after a **visibility bump**: `fn` →
  `pub(super) fn` in `src/cli/issue/helpers.rs`. Mechanical, zero behavior change to its three
  existing callers.
- New file rather than an extension of `helpers.rs`, per the F1 delta analysis's own sizing
  rationale (`helpers.rs` is already an ADR-0012 size deviation at ~1,113 LOC) — mirrors the
  established "one file per cohesive concern" convention already used by
  `format.rs`/`changelog.rs`/`field_resolve.rs`/`attachments.rs` in `cli/issue/`.
- **New (§9, F2-gate human decision, ADR-0023 §7):** `resolve_mentions` gains one additional,
  purely local reduction step for the `@Name` path — `filter_by_name_match(active_users, name)`
  — inserted between the existing `active == Some(true)` filter and the `disambiguate_user` call.
  It calls the existing `partial_match::partial_match` (no new crate, no new module) to reduce
  the candidate slice to only those users whose display name name-matches the query before
  `disambiguate_user` ever sees them. See §9 below for the full mechanism and why it requires no
  change to `disambiguate_user` itself.

### 2.3 Dependency graph — verified ACYCLIC

New/modified edges (full detail in `component-graph.md §Markdown Mentions Delta`):

```
cli::issue::mentions (L2, NEW) → adf (L6)                    [new pure fns/types]
cli::issue::mentions (L2, NEW) → api::jira::users (L4)       [REUSED: get_user, search_users]
cli::issue::mentions (L2, NEW) → cli::issue::helpers (L2)    [disambiguate_user, pub(super)]
cli::issue::mentions (L2, NEW) → partial_match (L6)          [NEW, §9: filter_by_name_match
                                                               pre-filter, ADR-0023 §7]
cli::issue::mentions (L2, NEW) → error (L6)

cli::issue::interactions (L2) → cli::issue::mentions (L2, NEW)   [handle_comment_add/edit]
cli::issue::create       (L2) → cli::issue::mentions (L2, NEW)   [handle_create]
cli::issue::edit         (L2) → cli::issue::mentions (L2, NEW)   [handle_edit, both call sites]
cli::issue::jsm_create   (L2) → cli::issue::mentions (L2, NEW)   [handle_jsm_create]
```

**Acyclicity verification:** `cli::issue::mentions`'s only outbound edges are to `adf` (L6),
`api::jira::users` (L4), `cli::issue::helpers` (L2 sibling), `partial_match` (L6, new — §9), and
`error` (L6). None of these — nor `helpers.rs` itself — has any edge back into `mentions.rs`,
`create.rs`, `edit.rs`, `interactions.rs`, or `jsm_create.rs`. `partial_match` in particular is a
pure, dependency-free L6 leaf module (already consumed today by `cli::issue::helpers` itself and
by other command families such as `board`/`sprint` status matching) with zero outbound edges of
its own, so it trivially cannot participate in a cycle. All new edges follow the existing layer
direction (L2 → L4 → L3 → L6; L2 → L6 directly; L2 → L2 sibling, the last already precedented by
the existing `cli::issue::edit`/`cli::issue::create` → `cli::issue::helpers` edges recorded in the
Component Management Delta). **No cycle is introduced. The DAG remains a strict acyclic graph
after this delta** — confirmed the same way every prior delta (`#288`, Component Management,
Field DX) was confirmed: by tracing every new edge's direction against the Layer Isolation
Summary and checking for a return path back to the new module. There is none.

**This change is purely additive** at the architecture level: zero existing edges removed,
zero existing edges modified (only one existing function signature grows a parameter —
`handle_comment_add` gains `no_input: bool`, with exactly one call site to update — and one
existing function's visibility widens — `disambiguate_user`). Zero new subsystems. Zero new
external dependencies. The §9 F2-gate tightening (`filter_by_name_match`) adds exactly one new
edge (`cli::issue::mentions → partial_match`, above) and zero new external dependencies — it
reuses the `partial_match` crate-internal module verbatim, the same module `disambiguate_user`
itself already calls.

## 3. New ADR

**ADR-0023: Markdown Mention Conversion — Two-Pure-Entrypoints + One-Effectful-Resolver Seam**

- Path: `.factory/specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md`
- Registered in `.factory/specs/architecture/ARCH-INDEX.md` (Architecture Decisions table),
  subsystems `SS-02, SS-04, SS-05, SS-08`.
- Ratifies the F1 delta analysis's proposed seam (two pure `adf.rs` entrypoints + one effectful
  `mentions.rs` resolver), formalizes ownership of `MentionCandidates`/`MentionResolutions` in
  `adf.rs`, records the three-reasons argument for why `@Name` resolution must not live in the
  pure converter, and makes the architecture-level call on the `\@`-escape mechanism and the
  `--no-mentions` flag shape (both detailed below).
- Sets precedent for any future `adf.rs` feature needing external data (explicitly named:
  issue #202's still-open `inlineCard`/`emoji` reverse-render work, if ever undertaken).

## 4. The Two Flagged Design Risks — Architectural Resolution

### 4.1 `\@` escape feasibility

**Recommendation: option (b) — a pre-parse, private-use-sentinel protect/restore pass —
CORRECTED per pass-1 adversarial review (MED-1) to be code-context-guarded. The
originally-circulated version of (b) is REJECTED and must not be built.**

The product-owner's concern is well-founded: `find_mention_candidates`/`markdown_to_adf_with_mentions`
walk the *built* pulldown-cmark tree, and CommonMark's own backslash-escape handling for `@`
happens upstream of that tree — `src/adf.rs::test_markdown_escape_literal_asterisk` already
proves this exact invisibility class for `\*`, and nothing suggests `\@` behaves differently.
By the time `jr`'s post-`finish()` pass runs, `\@Name` and `@Name` are byte-identical in the
built AST.

**MED-1 finding, and why the original (b) is rejected:** a pre-parse `\@`→sentinel replace with
no awareness of code spans/fences also rewrites `\@` **inside** `` `...` `` inline code and
fenced code blocks — regions where CommonMark does not process backslash escapes at all.
`` `\@x` `` MUST stay literal `` `\@x` `` (backslash preserved, per the code-skip-context
contract, EC-7.2.016-3 / BC-7.2.018 point 4); the original (b) mechanism silently strips the
backslash and emits `` `@x` ``, which is a correctness regression, not an equally-valid
tradeoff. **The prior framing that "either approach satisfies this BC's observable contract" is
false and is retracted:** option (a) was never context-blind — it inspects the real parser's own
event stream, which natively distinguishes `Event::Code`/`Tag::CodeBlock` from prose — only the
original (b) had this gap.

| Option | Verdict | Why |
|---|---|---|
| (a) `into_offset_iter()` source-offset mapping against `AdfBuilder`'s shared iterator | **Rejected as primary** | Requires reworking or wrapping the exact `TextMergeStream<Parser>` iteration machinery every mention pass shares with the rest of `AdfBuilder` — a change to the shared iterator of the single highest-blast-radius file in the codebase (275 tests, `MAX_ADF_DEPTH`, INV-1). It also does not eliminate the hard part: correlating a candidate's position in an *already-merged* text run back to a raw source offset, when an earlier backslash in the same run may have already been consumed — precisely the "offset drift" risk BC-7.2.018 itself flags as unproven. |
| **(b) Pre-parse sentinel protect/restore — REVISED, code-context-guarded** | **RECOMMENDED, in this corrected form only** | Before any substitution, run a **disposable, single-purpose** `pulldown_cmark::Parser::new_ext(markdown, <same Options bitset the main build uses>).into_offset_iter()` scan against the **untouched, original** raw string, collecting only the byte ranges of `Event::Code` (inline code spans) and `Tag::CodeBlock` (fenced/indented code blocks); discard everything else immediately — no tree retained. This reuses pulldown-cmark's own code-span/fence grammar (not a hand-rolled second copy, avoiding the exact "lexer diverges from the real parser" risk this repo's own `check-ci-gate.sh` history warns about) and is **not** the rejected option (a): it never touches `AdfBuilder`'s shared `TextMergeStream<Parser>`, and — because it runs once against the pristine, unmerged input — it never faces the "offset drift" problem of correlating an already-merged text run back to source. Then, within the **complement** of those code ranges only, scan for an *unescaped* `\@` (backslash-parity check: walk backward counting consecutive `\` before the `@` — an odd count means the `@` is escaped; `\\@` is an escaped backslash followed by a genuine, non-escaped `@`) and replace each with a single reserved Unicode Private Use Area codepoint (e.g. `U+E000`); any `\@` inside a code range is left completely untouched, byte-for-byte. Run the existing pipeline unmodified on the result. Restore the sentinel to a literal `@` in a small post-`finish()` pass (position pinned in §4.3 below), applying the SAME code-context skip `autolink_bare_urls` already uses (skip `codeBlock` content and any `text` node carrying a `code` mark) as defense-in-depth. Exposed as one shared pure helper, `protect_mention_escapes`, called identically by both `find_mention_candidates` and `markdown_to_adf_with_mentions` (and, per the pass-2/L-3 correction, deliberately NOT called by `markdown_to_adf_no_mentions` — that entrypoint relies on pulldown-cmark's native `\@`→`@` escape handling, which already matches its byte-for-byte pre-#674 contract with zero extra code) — required so `resolve_mentions()` never mistakes an escaped `\@JaneDoe` for a live candidate and wastes an HTTP call or interactive prompt on it. **Pass-2 (L-3) addition:** before the backslash-parity substitution, a second guard scan (same complement-of-code-ranges region) replaces any PRE-EXISTING literal `U+E000` in the raw input with a second reserved codepoint `U+E001`, so a user-authored `U+E000` is never misread as our own escape marker; restore reverses both (`U+E000`→`@`, `U+E001`→`U+E000`) in one pass. Full mechanism and residual-risk note: ADR-0023 §4 step 2/step 6. |
| (c) Declare infeasible; `--no-mentions` sole opt-out | **Rejected as primary design** | `--no-mentions` is a blunt, whole-invocation opt-out — a user wanting exactly one literal `@Override` in an otherwise mention-rich comment would have to suppress every mention in that same invocation. `\@` is an explicitly human-promised feature point (BC-7.2.018 point 6); declaring it infeasible without attempting (b) first is not justified by anything surfaced during this cycle's research. |

**Cost of the correction:** the code-range guard adds a **third** in-process parse pass per
mention-aware call site (guard scan, `find_mention_candidates`, `markdown_to_adf_with_mentions`'s
build) — up from the two this delta originally accepted. Judged equally negligible: the guard
scan materializes only a `Vec<Range<usize>>`, never a tree, and all three remain negligible
against the network round trips mention resolution straddles.

**F4 spike flag (per the BC's own "confirm before implementation" note, which this ADR does
NOT consider closed):** the sentinel codepoint's survival under pulldown-cmark 0.13's full
enabled `Options` set (emphasis, strong, code-span exclusion, footnote/task-list interactions)
is unverified — narrower in scope than option (a)'s unknowns, but still a real F4 empirical
check. **F4 must additionally verify the code-range guard's boundary handling** at the exact
edges of a code span/fence, since `into_offset_iter()`'s range endpoints must be interpreted
consistently (inclusive/exclusive) with the backslash-parity scan's own indexing. **Fallback
order if (b) fails empirically:** try a different PUA codepoint first; if no codepoint proves
clean, fall back to (c) (`--no-mentions`-only, no working `\@` escape) before reconsidering (a)
— (a)'s blast radius is strictly higher and is only worth its cost if a *future* cycle needs
general-purpose multi-character escape-awareness, spreading the investment over more than this
one feature.

### 4.3 Post-`finish()` pass ordering — definitive (closes pass-1 MED-2)

Four passes touch a built tree after `finish()`, and their relative order is observable, not an
implementation detail: the pre-existing `autolink_bare_urls`; the new `convert_mentions`
(`markdown_to_adf_with_mentions`'s emit-side pass — splits text nodes at mention-candidate spans,
replaces eligible ones with `mention` nodes; `find_mention_candidates` runs the identical walk in
"collect, don't mutate" mode); the §4.1 sentinel-restore pass; and the pre-existing
`assign_local_ids`. **Definitive sequence**, applied identically in both `find_mention_candidates`
and `markdown_to_adf_with_mentions`:

```
0. protect_mention_escapes(markdown)        — pre-parse, code-range-guarded (§4.1)
1. parse + finish()                         — base tree
2. autolink_bare_urls
3. convert_mentions   (find_mention_candidates: candidate-collection, same walk, no mutation)
4. sentinel-restore
5. assign_local_ids
```

- **`autolink_bare_urls` before `convert_mentions` — retained, but see the pass-2 (H-2) correction
  below for why the original rationale here is WRONG and has been retracted, not just refined.**
  The original design had mention detection extend the existing "skip already-marked text" rule
  (already used for `code`) to also skip `link`. **This is REJECTED as of pass-2 adversarial
  review (H-2):** it directly contradicted BC-7.2.016 EC-7.2.016-4 (`[[~accountid:X]](url)` still
  converts) and BC-7.2.018 EC-7.2.018-6 (`[@jsmith](url)` — link mark NOT separately excluded) —
  both ECs are correct as written and require no change; this delta's own prose was the defect.
  **Corrected rule:** `convert_mentions`/`find_mention_candidates` skip ONLY `code`-marked text —
  never `link`-marked text, from either an explicit markdown link or an autolinked bare URL. The
  URL-interior false positive this paragraph originally invoked `link`-skipping to prevent is
  actually already closed by the pre-existing start-of-node/whitespace boundary rule alone: a bare
  `http(s)://`-scoped URL span never begins with `@` and, by construction, contains no internal
  whitespace, so no position inside it can ever satisfy "at start of node" or "after whitespace" —
  the two only conditions the boundary rule accepts — regardless of whether that span carries a
  `link` mark or has been split out by `autolink_bare_urls` yet. The pass order (`autolink_bare_urls`
  before `convert_mentions`) is UNCHANGED — kept for documentation stability and so
  `find_mention_candidates` reproduces the identical tree-splitting shape — but is no longer
  load-bearing for the URL-interior concern under the corrected rule; the two passes could be
  swapped with no behavioral change. Full derivation: ADR-0023 §5 (H-2 correction).
- **`convert_mentions` before sentinel-restore:** an escaped `\@Name` survives to this point as
  the PUA sentinel. If sentinel-restore ran first, it would already be a literal `@` by the time
  mention detection ran, making `\@Name` and a genuine `@Name` byte-identical again — the exact
  invisibility problem §4.1 exists to prevent, reintroduced one pass later.
- **`assign_local_ids` last, unconditionally:** this DFS pre-order pass must see the tree's
  final node set. This tightens the pre-existing documented order (`CLAUDE.md`'s GFM task-list
  note: runs after `finish()`, before `autolink_bare_urls`) to "runs last, after every
  post-`finish()` pass" — behavior-preserving for all pre-#674 tests (neither `mention` nor
  `link`-marked nodes currently receive a `localId`), and removes the need to re-derive this
  ordering question for every future new pass.
- **Scope:** `find_mention_candidates` performs steps 0–3 only (no sentinel-restore/local-id
  step of its own) but MUST perform steps 0–2 identically to the emit-side build via the same
  shared `protect_mention_escapes` helper and the same `code` skip rule (H-2 correction above:
  there is no `link` skip rule to share — mentions do not exclude on `link` marks at all), so
  the candidate set it reports is byte-for-byte the set `convert_mentions` later acts on.

### 4.2 `--no-mentions` flag shape

- **Placement:** a plain boolean clap flag declared alongside the existing `--markdown` flag on
  every write-command args struct that already has one — `IssueCommand::Create` (covers both
  the platform path and the JSM `--request-type` fork via the same struct), `IssueCommand::Edit`
  (covers both of its internal `markdown_to_adf` call sites — dry-run and live — from one flag,
  since both belong to the same invocation), `CommentSubcommand::Add`, `CommentSubcommand::Edit`.
- **Composition:** no `conflicts_with`/`requires` relationship to `--markdown`. `--no-mentions`
  without `--markdown` is an accepted, silent no-op (mentions were never detected on the
  `text_to_adf` path regardless). No interaction with any other existing flag (`--internal`/
  `--public`, `--dry-run`, `--field`, etc.) — it is a pure conversion-mode selector, orthogonal
  to visibility, preview, and field-resolution concerns.
- **Dispatch mechanics:** when present, the CLI call site skips the
  `mentions::resolve_mentions().await` call ENTIRELY (saving every HTTP round trip) and calls
  `adf::markdown_to_adf_no_mentions(text)` in place of
  `adf::markdown_to_adf_with_mentions(text, &resolutions)`. This is why the design uses a
  dedicated third pure function rather than threading a `bool` through
  `markdown_to_adf_with_mentions` — a boolean parameter would still force every call site to
  construct and pass an (unused) resolutions map and would not let the CLI skip the resolver
  call itself.
- Confirms this architecture shape as the F2-flagged-for-review answer to the BC's own open
  question (BC-7.2.016 point 7's "[SPEC CHOICE FLAGGED FOR F2 HUMAN REVIEW]").

## 5. DTU Confirmation

`dtu_required` stays **false**. Mentions reuse two already-implemented `JiraClient` methods
(`get_user`, `search_users`) against the existing Service 1 (Atlassian Jira REST API v3) — zero
new HTTP methods, zero new endpoints, zero new external service. None of `dtu-assessment.md`
§6's Future Revisit Triggers fire. Confirmation note appended to `dtu-assessment.md` §3 Verdict.

## 6. Report Back

- **ADR id allocated:** ADR-0023 (next after ADR-0022, per ARCH-INDEX.md).
- **Architecture change is purely additive; dependency graph confirmed ACYCLIC** — see §2.3
  above and `component-graph.md §Markdown Mentions Delta` for the full edge-by-edge trace. Zero
  existing edges removed or modified; one function signature grows a parameter
  (`handle_comment_add`, one call site); one function's visibility widens
  (`disambiguate_user`, zero behavior change).
- **`\@`-escape recommendation (CORRECTED, pass-1 MED-1):** option (b), pre-parse
  private-use-sentinel protect/restore, **but only in its code-context-guarded form** (§4.1) —
  the originally-circulated context-blind version is rejected outright, since it corrupts
  `\@` occurrences inside code spans/fences (EC-7.2.016-3, BC-7.2.018 point 4). The corrected
  mechanism adds a disposable `into_offset_iter()` code-range guard (reusing pulldown-cmark's
  own grammar, not a hand-rolled second copy) before the sentinel substitution, and the same
  code-context skip on restore as defense-in-depth. Still lower blast radius on the shared
  parser iteration machinery than offset-tracking (never touches `AdfBuilder`'s shared
  `TextMergeStream<Parser>`), reuses the `String → String` pre/post transform technique class
  already established by the INV-1 chokepoint, and remains independently testable without
  touching `adf.rs`'s existing 275 tests — now at the cost of a third, disposable parse pass
  (judged negligible, §4.1). Flagged as an F4 spike input (sentinel-codepoint empirical survival
  check, AND the code-range guard's boundary handling at code-span/fence edges) — not yet
  proven, but now with a concrete, lower-risk, code-safe mechanism and an explicit fallback
  order (try another codepoint → `--no-mentions`-only → offset-tracking as a last resort) rather
  than an open-ended "needs F4 design." The prior claim that "either approach [(a) or (b)]
  satisfies this BC's observable contract" was inaccurate and is retracted: only the corrected
  (b) above, or (a), actually satisfies the code-skip-context contract — the original (b) did
  not.
- **Post-`finish()` pass ordering (NEW, pass-1 MED-2):** definitive five-step sequence pinned in
  §4.3 — `protect_mention_escapes` (pre-parse) → `finish()` → `autolink_bare_urls` →
  `convert_mentions` → sentinel-restore → `assign_local_ids` (last, unconditionally). This is
  the sequence the product owner should encode verbatim into BC-7.2.016; it also tightens
  `assign_local_ids`'s pre-existing documented position (previously: before
  `autolink_bare_urls`) to "runs last, after every post-`finish()` pass" — behavior-preserving
  for all pre-#674 tests, but a real, in-scope change to a previously-shipped ordering
  invariant, not merely new-code scope.
- **`--no-mentions` flag placement:** a boolean clap flag on each of `IssueCommand::Create`,
  `IssueCommand::Edit`, `CommentSubcommand::Add`, `CommentSubcommand::Edit` — one flag per
  invocation, no `conflicts_with`/`requires` ties to `--markdown` or any other flag, dispatched
  by the CLI layer to skip `resolve_mentions()` entirely and call the new
  `markdown_to_adf_no_mentions` pure entrypoint in place of `markdown_to_adf_with_mentions`.
- **Link-marked-text exclusion rule (CORRECTED, pass-2 H-2) and pre-existing-sentinel collision
  guard (NEW, pass-2 L-3):** see §7 below for the full, product-owner-facing statement of both
  fixes and the exact BC/EC propagation required (or, for H-2, confirmed NOT required).
- **`@Name` single-result tightening (NEW, F2-gate human decision, resolves EC-X.7.007-5):** see
  §9 below for the full mechanism (`filter_by_name_match` pre-filter in `mentions.rs`,
  `disambiguate_user` unchanged), the four-row behavioral contract, and the exact BC/EC/holdout
  propagation required of the product-owner and formal-verifier.

## 7. Pass-2 Adversarial Review Corrections (H-2, L-3)

### 7.1 H-2 (HIGH) — link-marked-text contradiction, resolved

**Final rule:** `convert_mentions`/`find_mention_candidates` skip ONLY text carrying a `code`
mark (or `codeBlock` content). They do **not** skip `link`-marked text — neither an explicit
markdown link's display text nor an autolinked bare URL. Both mention forms convert freely
inside link-marked text.

**Why this is safe (no provenance-distinguishing needed):** the pre-existing start-of-node /
after-whitespace boundary rule (BC-7.2.016 point 2, shared with `find_bare_url_spans`) already
excludes any `@` embedded mid-URL on its own — a bare `http(s)://`-scoped URL span never begins
with `@` and, by construction, contains no internal whitespace, so no position inside it can
ever be "at start of node" or "after whitespace." This holds regardless of `link`-mark presence,
mark provenance (explicit link vs. autolink), or pass order. The originally-specified "also skip
`link`" rule was therefore not a safer alternative needing a tie-breaker — it was simply wrong,
and is retracted, not replaced by a provenance-distinguishing mechanism.

**Pass order:** UNCHANGED. The six-step sequence in §4.3 (`protect_mention_escapes` →
`finish()` → `autolink_bare_urls` → `convert_mentions` → sentinel-restore →
`assign_local_ids`) stands as pinned. It is retained for documentation stability and so
`find_mention_candidates` reproduces `markdown_to_adf_with_mentions`'s exact tree-splitting
shape — NOT because the relative order of `autolink_bare_urls` and `convert_mentions` is
load-bearing for the URL-interior concern any more; under the corrected rule it provably is not
(see ADR-0023 §5 for the full boundary-rule argument).

**Exact BC/EC propagation required of the product-owner:**

| Artifact | Disposition | Action |
|---|---|---|
| EC-7.2.016-4 (`.factory/specs/prd/bc-7-output-render.md`) | **NO CHANGE** | Already correct as written ("the mention conversion still applies to the inner span" for a bracket-form mention inside `[[~accountid:X]](url)`). Confirm, do not edit. |
| EC-7.2.018-6 (same file) | **NO CHANGE** | Already correct as written ("link-mark interaction is NOT separately excluded" for `[@jsmith](url)`). Confirm, do not edit. |
| BC-7.2.016 point 10 (same file, the paragraph following the pass-order code block) | **MUST CHANGE** | Delete the sentence "`convert_mentions`/`find_mention_candidates` extend the existing 'skip text already carrying an owning mark' rule (already applied to `code`) to also skip `link`." Replace with: "`convert_mentions`/`find_mention_candidates` skip ONLY text carrying a `code` mark (or `codeBlock` content); `link`-marked text is NOT excluded — see EC-7.2.016-4/EC-7.2.018-6. The URL-interior case (`http://example.com/@handle`) is excluded solely by the point-2 start-of-node/whitespace boundary rule, independent of any mark." |
| BC-7.2.018 point 4 (same file) | **MUST CHANGE** | Currently reads "identical to the bracket form (BC-7.2.016 point 3) — never inside `codeBlock` content, never inside a text node already carrying a `code` mark" — this line is ALREADY correct (it only names `code`, not `link`) and needs no wording change, but add a one-line cross-reference to EC-7.2.018-6 confirming `link` is deliberately excluded from this skip set, to prevent a future reader re-deriving the retracted "also skip `link`" rule from BC-7.2.016 point 10's old text before it's fixed. |
| BC-7.2.018 point 6 (same file, `protect_mention_escapes` description) | **MUST CHANGE** | The clause "(and, as a harmless no-op, `markdown_to_adf_no_mentions`)" naming `markdown_to_adf_no_mentions` as a caller of `protect_mention_escapes` must be deleted — that entrypoint must NOT call it (see §7.2 below). Also add the pre-existing-sentinel guard step (§7.2) to this point's description of `protect_mention_escapes`'s internal steps. |

No other EC or BC in this cycle's delta requires a change for H-2.

### 7.2 L-3 (LOW) — sentinel collision, resolved

**Guard added:** `protect_mention_escapes` reserves a SECOND Private Use Area codepoint,
`U+E001` (`SENTINEL_GUARD`), alongside the original `U+E000` (`SENTINEL_ESCAPE`). Before the
backslash-parity substitution, and within the same complement-of-code-ranges region computed by
the code-range guard, every literal pre-existing `U+E000` in the raw input is replaced with
`U+E001`. The later restore pass applies two independent single-codepoint substitutions:
`U+E000` → `"@"` and `U+E001` → `U+E000`. This prevents a user-authored literal `U+E000`
byte from being silently misread as our own escape marker and rewritten to `"@"`.

**Fallout correction:** `markdown_to_adf_no_mentions` must NOT call `protect_mention_escapes`
at all (this delta's §4.1 table cell above already reflected the "two callers only" shape
correctly; BC-7.2.018 point 6 in the PRD does not yet — see the table row above). That
entrypoint performs no mention detection, so it has no need for sentinel machinery, and calling
`protect_mention_escapes` without a paired restore step (which this entrypoint never runs)
would permanently leave un-restored sentinel bytes in its output — breaking its own
byte-for-byte pre-#674 equivalence promise (BC-7.2.016 point 7 / EC-7.2.016-7). Pulldown-cmark's
native `\@`→`@` escape handling already satisfies that promise with zero extra code.

**Residual risk, documented not silently accepted:** a pathological input containing BOTH a
literal `U+E000` AND a literal `U+E001` as ordinary prose (outside code context) would still
have the `U+E001` misread as the guard marker on restore — a second-level collision. Judged
acceptable: it requires two specific adjacent PUA codepoints as literal authored content, an
outcome with no known real-world occurrence surfaced by this cycle's research. Not re-engineered
into an unbounded escape-of-escape chain by this ADR.

**Exact BC/EC propagation required of the product-owner:**

| Artifact | Disposition | Action |
|---|---|---|
| BC-7.2.018 point 6 (`.factory/specs/prd/bc-7-output-render.md`) | **MUST CHANGE** | (1) Remove `markdown_to_adf_no_mentions` from `protect_mention_escapes`'s caller list (see §7.1's table above — same edit closes both a H-2-adjacent and this L-3-adjacent defect in one line). (2) Add the pre-existing-sentinel guard step: reserve `U+E001` alongside `U+E000`; pre-existing literal `U+E000` in non-code raw text is remapped to `U+E001` before the `\@`→`U+E000` substitution; restore reverses both. (3) Add the residual-risk sentence above (nested collision, accepted). |
| EC-7.2.016-3 / EC-7.2.018-4 (code-skip-context ECs, same file) | **NO CHANGE** | These already correctly scope the code-context guard to the `\@`→`U+E000` substitution; the new `U+E000`→`U+E001` pre-guard reuses the identical code-range complement, so no new edge case class is introduced for these ECs to cover. |

Full technical derivation for both H-2 and L-3: ADR-0023 §4 (steps 2 and 6) and §5.

## 8. Follow-Up for F3/F4

- F3 (incremental story decomposition) should split stories per the F1 delta analysis's
  proposed shape (Story A: pure bracket-form conversion incl. reverse-render;
  Story B: `@Name` effectful resolution; Story C: accountId preflight-validate +
  `attrs.text` population, folded per the human-approved scope into the same delivery as
  Story B rather than deferred) plus one wiring pass covering all four call sites.
- F4 implementer should treat (1) the `\@`-escape sentinel-codepoint empirical verification,
  (2) the code-range guard's boundary handling at code-span/fence edges (both closing MED-1),
  and (3) the `MentionResolutions` internal key-space design (discriminated key vs. two separate
  maps) as the three concrete open implementation decisions this ADR deliberately leaves to F4,
  consistent with this cycle's "F4 empirical check" precedent already established by VP-571-002.
- F4 implementer must also implement the definitive post-`finish()` pass order pinned in §4.3
  (closing MED-2) exactly as specified — `protect_mention_escapes` → `finish()` →
  `autolink_bare_urls` → `convert_mentions` → sentinel-restore → `assign_local_ids` — including
  the tightened, now-unconditional "last" position for `assign_local_ids`.
- **F3/F4 must additionally implement §9's `filter_by_name_match` pre-filter step** as part of
  Story B (`@Name` effectful resolution) — it is a small addition to the same story, not a
  separate story, since it only touches `resolve_mentions`'s internal control flow for the
  `@Name` path and requires no new file, no new dependency, and no `disambiguate_user` change.

## 9. F2-Gate Human Decision (2026-09-06): `@Name` Single-Result Tightening — Resolves EC-X.7.007-5

**Context.** Pass-2 adversarial review flagged `EC-X.7.007-5` as an OPEN DECISION for this F2
human gate (`.factory/specs/prd/cross-cutting.md` §X.7): `client.search_users(name)` performs a
server-side fuzzy match, so a query can return exactly one active result whose display name has
no textual relationship to the query at all. `disambiguate_user`'s pre-existing `users.len() ==
1` short-circuit (`src/cli/issue/helpers.rs:280-282`) accepts that lone result with **zero**
name-similarity check — a real UX risk specific to mentions, since a mention has an observable
side effect (a Jira notification to a possibly-unintended third party) that plain
issue-assignment resolution does not. **Human decision at this gate: tighten.** A lone active
result whose display name does not name-match the query is now a hard error, not a silent
resolve.

**Confirmed `partial_match` semantics** (`src/partial_match.rs`, reused as-is, not reinvented):
exact case-insensitive full-string equality (1 hit → `Exact`, ≥2 → `ExactMultiple`), else
case-insensitive substring containment of the query WITHIN the candidate's display name (0 hits
→ `None`, ≥1 hits — including exactly one — → `Ambiguous`). There is no separate prefix rule;
substring containment already subsumes it. Critically, `partial_match` itself never collapses a
lone substring hit to a silent single answer — that collapse is `disambiguate_user`'s own
`len() == 1` short-circuit, which runs BEFORE `partial_match` is ever consulted. That is the
precise gap this decision closes, for mentions only.

**Chosen mechanism: Option (a) — pre-filter, `disambiguate_user` UNCHANGED.** In
`mentions.rs::resolve_mentions`, after the existing `active == Some(true)` filter and before the
`disambiguate_user` call, add one pure, synchronous, in-memory reduction step,
`filter_by_name_match(active_users, query) -> Vec<User>`, that calls
`partial_match::partial_match(query, &display_names)` and keeps only the users whose display name
falls in the returned match set (`Exact`/`ExactMultiple` → the matched name, case-insensitively;
`Ambiguous` → the full match list, case-insensitively; `None` → empty). The reduced list is what
`disambiguate_user` actually receives. `disambiguate_user`'s function body — including its
`len() == 1` short-circuit and its own internal `partial_match` calls on the `>1` arms — requires
**zero code changes**. Full mechanism, the composability trace across every result-count arity,
and the two rejected alternatives (a `disambiguate_user` parameter/variant; a dedicated
mention-only resolver): **ADR-0023 §7** (this delta does not duplicate that derivation here).

**Exact behavioral contract** (for the product-owner to encode into BC-X.7.007, retiring
`EC-X.7.007-5`'s "OPEN DECISION" framing):

| Search outcome (post active-filter) | Result |
|---|---|
| Zero results | HARD ERROR, exit 64 (unchanged — BC-X.7.009, empty-list branch) |
| Single result, name matches (exact or substring, case-insensitive) | Resolves silently (unchanged happy path — BC-X.7.007) |
| **Single result, name does NOT match** | **HARD ERROR, exit 64 — NEW.** Same branch/class as zero-match (`disambiguate_user`'s empty-list branch), carrying the pinned `"No user found matching"` substring (BC-X.7.009 point 2) |
| Multiple results after name-match reduction | Ambiguous disambiguation (unchanged — BC-X.7.008): interactive prompt, or `--no-input` exit 64 with candidate list |

**Effectful/pure boundary.** Confirmed unaffected. `filter_by_name_match` lives in
`src/cli/issue/mentions.rs` (SS-02, effectful shell) and calls only the pre-existing,
Jira-agnostic `partial_match::partial_match` utility on already-fetched `User` data — no I/O of
its own. Nothing in `adf.rs` changes: `find_mention_candidates`, `markdown_to_adf_with_mentions`,
`markdown_to_adf_no_mentions`, and the `MentionCandidates`/`MentionResolutions`/
`MentionResolution` data shapes from §2.1 above are untouched by this decision — they have no
visibility into Jira user search results, by design, and none is introduced.

**Downstream spec/holdout work required (NOT performed by this delta or by ADR-0023 — explicitly
out of scope for the architecture layer; assigned to product-owner + formal-verifier):**

| Artifact | Disposition | Action |
|---|---|---|
| `BC-X.7.007` (`.factory/specs/prd/cross-cutting.md` §X.7) | **MUST CHANGE** | Retire `EC-X.7.007-5`'s "OPEN DECISION, no behavior change" framing; encode the four-row contract table above as shipped behavior. |
| `EC-X.7.007-5` | **MUST CHANGE / SUPERSEDE** | Replace with (or revise into) an edge case documenting "single result, fuzzy non-match → hard error," cross-referencing `EC-X.7.007-3`/`EC-X.7.009-4`'s existing empty-list-branch framing (same branch and pinned substring, different cause). |
| `H-NEW-MENTION-002` (`.factory/specs/prd/holdout-scenarios.md`, Group 21) | **SHOULD REVIEW** | Confirm its fixture's sole search result DOES name-match the query, so it continues to test the genuine happy path rather than the now-rejected silent-fuzzy-resolve path. |
| New holdout scenario, working id `H-NEW-MENTION-012` (Group 21, next available id) | **MUST ADD** | Fixture returns exactly one active user whose display name neither case-insensitively equals nor contains the queried name as a substring → `jr` exits 64, stderr/`--output json` error envelope contains `"No user found matching"`, zero mutation HTTP call. |
| `VP-674-*` verification properties describing BC-X.7.007's `len() == 1` short-circuit as unconditional | **SHOULD REVIEW** | Revise any that assert the pre-tightening (silent-fuzzy-resolve) behavior. |

**Why this is additive, not a redesign.** Zero new files, zero new external dependencies, zero
change to `disambiguate_user`'s signature or body, zero change to any of ADR-0023 §1–§6's prior
decisions. The only new architecture-visible artifact is the single new dependency edge recorded
in §2.3 above (`cli::issue::mentions → partial_match`) and the one new private helper function
(`filter_by_name_match`) inside the already-planned `mentions.rs` file.

Full technical derivation, the arity-by-arity composability trace, and the two rejected
mechanism alternatives: **ADR-0023 §7**.
