---
document_type: adr
adr_id: ADR-0023
status: Accepted
date: 2026-09-06
subsystems_affected: ["SS-02", "SS-04", "SS-05", "SS-08"]
supersedes: null
superseded_by: null
related: ["ADR-0012", "ADR-0014", "ADR-0019"]
---

# ADR-0023: Markdown Mention Conversion — Two-Pure-Entrypoints + One-Effectful-Resolver Seam

## Status

**Accepted** (2026-09-06). Gate: F2 spec evolution for GitHub issue #674 ("adf-mentions",
Feature Mode cycle-005). Ratifies, at the architecture layer, the seam the F1 delta analysis
(`.factory/phase-f1-delta-analysis/cycle-005/delta-analysis.md` §2, "THE CENTRAL ARCHITECTURAL
DECISION") proposed and the F2 PRD delta encoded into BC-7.2.016/017/018/019 and
BC-X.7.007/008/009/010. This is the first `src/adf.rs` feature cycle (of ten, #470→#674) that
needs data obtainable only through network I/O — every prior cycle (#470/#471 task lists, #472
footnotes, #473 bare-URL autolink, #474 subsup/heading-attrs, #483 GFM alert panels, #489/#492
block HTML, #522 CR/LF chokepoint, #553 recursion guard, #571 code-mark exclusivity) was
resolvable from the markdown text alone. This ADR sets the precedent for any future `adf.rs`
feature with the same shape (e.g. issue #202's still-open `inlineCard`/`emoji` reverse-render
work, if a future cycle ever needs a network lookup to resolve link-preview metadata).

**§7 addendum (same date, 2026-09-06):** folds in a second F2-gate human decision — resolving
`EC-X.7.007-5` (the "fuzzy single-hit resolves without name-level verification" open question the
pass-2 adversarial review flagged for this gate) by tightening `@Name` single-result resolution.
See §7 for the full mechanism; it is additive to everything in §1–§6 and changes no prior
decision in this ADR.

> **NOTE — factory-artifact placement, not yet an F4 code artifact:** This ADR governs
> `src/cli/issue/mentions.rs` (new), extensions to `src/adf.rs`, and a visibility bump to
> `src/cli/issue/helpers.rs::disambiguate_user` — none of which exist in this shape in `src/`
> as of this writing (F2). The corresponding product-repo ADR file under `docs/adr/` is an F4
> story deliverable, created in a worktree via PR when implementation lands — it is NOT created
> here. This factory artifact at
> `.factory/specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md`
> is the sole ADR-0023 record until F4 promotes it into `docs/adr/`.

## Context

GitHub issue #674 requires `jr` to convert markdown mention syntax into ADF `mention` nodes on
write (`issue comment add`, `issue create` — both platform and JSM `--request-type` paths —
and `issue edit --description`), and to render `mention` nodes back to `@name` text on read
(`adf_to_text`, closing the issue #202/NFR-O-I deferral). Two forms are in scope:

1. **Bracket form**, `[~accountid:<id>]` — the id is supplied verbatim in the text. Converting
   this to `{"type":"mention","attrs":{"id":"<id>"}}` needs no lookup — but the human-approved
   scope additionally requires (a) preflight-validating the id against Jira (`GET
   /rest/api/3/user?accountId=`) so an invalid/stale id hard-errors instead of silently
   producing a dead, non-notifying mention, and (b) populating `attrs.text` with a display name,
   which the SAME validation call already returns.
2. **`@Name` form** — inherently effectful: it requires `GET /rest/api/3/user/search` plus the
   existing `disambiguate_user` interactive/`--no-input` resolution logic
   (`src/cli/issue/helpers.rs`).

`src/adf.rs::markdown_to_adf` is architecture-documented as **pure** (`system-overview.md`
§Purity Boundary) and has held that invariant across all nine prior feature cycles: no
`async fn`, no `Client` parameter, no network/filesystem access. This cycle must not be the one
that breaks it — `adf.rs` is the single most heavily hardened file in the codebase (275
`#[test]`s, the `MAX_ADF_DEPTH` recursion guard, the INV-1 CR/LF chokepoint, the code-mark
exclusivity invariant), and it is depended on by six call sites across the whole CLI surface
(create, edit ×2, comment add, comment edit, JSM create).
A regression here has the widest blast radius of any file in the product.

The question this ADR answers: **how does an inherently-async resolution step feed a
synchronous pure converter, for both mention forms, without `adf.rs` importing `JiraClient` or
`tokio`** — and, as a corollary, why must `@Name`→accountId resolution NOT live inside the pure
converter at all.

## Decision

### 1. Two pure entrypoints in `adf.rs`, one effectful pre-resolution module outside it

`adf.rs` gains exactly two new pure functions, both zero-HTTP, both operating only on
already-in-memory data:

```rust
// PURE — read-only scan. Runs the identical TextMergeStream<Parser> build markdown_to_adf
// runs, so it sees the exact same tree shape (code-mark exclusion included; link-marked text
// is NOT excluded — see §5's H-2 correction), and returns every literal mention-candidate span
// found in an eligible position. Performs zero conversion and zero HTTP — parsing text is not
// I/O.
pub(crate) fn find_mention_candidates(markdown: &str) -> Result<MentionCandidates, JrError>;

// PURE — the real markdown_to_adf body, extended. Every bracket-form span is ALWAYS
// converted to a mention node (self-contained). Every @Name span is converted ONLY IF
// `resolved` has a matching entry — otherwise it is left as literal text (safe default:
// an unresolved @Name never silently vanishes, it just isn't a mention).
pub fn markdown_to_adf_with_mentions(
    markdown: &str,
    resolved: &MentionResolutions,
) -> Result<Value, JrError>;
```

`markdown_to_adf`'s existing 1-arg signature is **unchanged** — it becomes a one-line wrapper:

```rust
pub fn markdown_to_adf(markdown: &str) -> Result<Value, JrError> {
    markdown_to_adf_with_mentions(markdown, &MentionResolutions::empty())
}
```

This preserves all 275 pre-#674 `#[test]`s and all pre-#674 call sites verbatim: bracket-form
mentions convert "for free" (id only, no `attrs.text`) even through bare `markdown_to_adf`,
while `@Name` stays inert (matches today's zero-mention behavior exactly, since an empty
resolutions map never has a matching entry).

The effectful half lives entirely in a **new file**, `src/cli/issue/mentions.rs` (SS-02, CLI
Layer — a support module alongside `helpers.rs`/`field_resolve.rs`, not a top-level command
handler):

```rust
pub(super) async fn resolve_mentions(
    client: &JiraClient,
    text: &str,
    no_input: bool,
) -> Result<MentionResolutions, JrError> {
    let candidates = adf::find_mention_candidates(text)?;      // PURE, in-process
    // dedup candidates per unique bracket-id / unique @Name token BEFORE any network call
    // one GET /rest/api/3/user?accountId= per unique bracket id (BC-X.7.010)
    // one GET /rest/api/3/user/search + disambiguate_user per unique @Name (BC-X.7.007/008/009)
}
```

Call-site shape at every one of the four wiring points becomes a two-line pattern:

```rust
let resolutions = mentions::resolve_mentions(client, &text, no_input).await?;   // effectful
let adf_body = adf::markdown_to_adf_with_mentions(&text, &resolutions)?;        // pure
```

### 2. `MentionCandidates`/`MentionResolutions` are owned by `adf.rs`, not by `mentions.rs`

Both data types are defined in `src/adf.rs`, as plain data (no `Client`, no `async`, no I/O):

- `MentionCandidates` — the output of `find_mention_candidates`: every bracket-form id and
  every `@Name` token found, in scan order, without deduplication (deduplication is a
  network-cost concern, not a detection-grammar concern, so it belongs in `mentions.rs`, not in
  the pure scanner).
- `MentionResolutions` — the input to `markdown_to_adf_with_mentions`: a lookup keyed
  separately per form (bracket-form keys are accountIds; `@Name`-form keys are the literal
  `@Name` span text, since that is the only string both the pure scanner and the pure emitter
  agree on) mapping to `{account_id, display_name}`. `MentionResolutions::empty()` is the
  wrapper's zero-mention default.

This keeps the dependency direction strictly one-way (`mentions.rs` → `adf.rs`, never the
reverse) and keeps each grammar owned by exactly one layer: the bracket-form and `@Name`
**detection** grammars live in `adf.rs` alone (self-contained, reused identically by both the
scan pass and the emit pass); `mentions.rs` never re-implements "is this text eligible" — it
only consumes the span list `find_mention_candidates` already extracted and turns spans into
resolved identities. This mirrors the reasoning ADR-0019 §1 used to keep `FieldValueSpec`
CLI-local rather than duplicating a resolution grammar across layers, applied in the opposite
direction: here the *shared* artifact is owned by the *lower*, pure layer because both
producer (`find_mention_candidates`) and consumer (`markdown_to_adf_with_mentions`) of that
artifact already live there.

### 3. Why `@Name`→accountId resolution must NOT live in the pure converter

Three independent reasons, all load-bearing:

1. **It requires network I/O by construction.** `GET /rest/api/3/user/search` cannot be
   performed by a function with the signature `fn(&str) -> Result<Value, JrError>`. Any attempt
   to fold resolution into the emitter would force `adf.rs` to take a `&JiraClient` and become
   `async fn`, which breaks the purity invariant `system-overview.md` has documented since Pass
   1 and every one of the nine prior `adf.rs` cycles has preserved. A pure core that suddenly
   grows an HTTP dependency is no longer formally reasoned-about the same way — every one of
   its 275 existing tests, and the property-based ones among them, currently assume determinism
   and zero I/O.
2. **It requires human-facing disambiguation UX** (interactive `dialoguer::Select` prompts,
   `--no-input` exit-64 branches) that has no home inside a value-in/value-out pure function —
   `disambiguate_user`'s existing three-way `Exact`/`ExactMultiple`/`None` contract is
   fundamentally a CLI-layer concern (BC-X.7.007/008/009), reused verbatim rather than
   reinvented.
3. **A single raw-string rewrite pass (`@Name` → `[~accountid:<id>]` text, performed before
   CommonMark parsing) was considered and rejected** — named directly in the F1 delta analysis
   as the alternative the brief itself suggested. A pre-parse rewrite cannot know whether a
   matched `@Name` span sits inside a fenced code block or an inline code span, because that
   information only exists *after* parsing. Rewriting before parsing would incorrectly convert
   a literal `@JaneDoe` appearing inside `` `@JaneDoe` `` or a fenced code example into a real
   mention — exactly the class of bug the code/mark exclusion rules (shared with
   `autolink_bare_urls`) exist to prevent. The two-pass design (scan the built tree, resolve
   off-thread, re-walk the built tree to emit) parses once in the *same* structural positions
   the final emitter will honor, so both mention forms respect code-fence and inline-code
   boundaries identically to how bare-URL autolinking already does.

The double-parse cost (one `TextMergeStream` build for `find_mention_candidates`, one more
inside `markdown_to_adf_with_mentions`) is in-process and negligible against the network round
trips it straddles.

### 4. The `\@` escape — recommended mechanism: code-context-guarded pre-parse sentinel protect/restore

The human-approved scope requires `\@Name` to render as literal text `@Name`, never as a
mention candidate (BC-7.2.018 point 6). This is genuinely hard to satisfy by walking
`markdown_to_adf`'s *built* tree: CommonMark treats `@` as an escapable ASCII punctuation
character, and pulldown-cmark's inline parser consumes the backslash and merges the literal `@`
into the surrounding text *before* any post-`finish()` tree-walk ever runs —
`src/adf.rs::test_markdown_escape_literal_asterisk` already proves this exact class of
invisibility for `\*`, and `\@` has no reason to behave differently. By the time
`find_mention_candidates` sees the built text, `\@Name` and `@Name` are byte-identical.

Three options were assessed:

| Option | Mechanism | Verdict |
|---|---|---|
| **(a)** `into_offset_iter()` source-offset mapping against `AdfBuilder`'s shared iterator | Track each merged text run's original byte range, cross-check a candidate `@` position against the raw source for an unescaped preceding backslash | **NOT recommended as primary** — see rationale below |
| **(b)** Pre-parse sentinel protect/restore | Before parsing, scan the raw markdown for unescaped `\@` and replace it with a private-use-area sentinel; restore the sentinel to a literal `@` in the final text nodes after the tree is built | **RECOMMENDED, ONLY IN THE CORRECTED, CODE-CONTEXT-GUARDED FORM BELOW** |
| **(c)** Declare `\@` infeasible; `--no-mentions` is the sole opt-out | No escape mechanism; users who need a literal `@token` must suppress ALL mention detection for the whole invocation | **NOT recommended** — see rationale below |

**Correction (pass-1 adversarial review, MED-1) — the originally-specified (b) is REJECTED as
written and must not be built.** A pre-parse `\@`→sentinel replace that runs over the raw string
with no awareness of code spans/fences also replaces `\@` **inside** `` `...` `` inline code and
fenced code blocks, where CommonMark does not process backslash escapes at all. `` `\@x` `` MUST
stay literal `` `\@x` `` — backslash preserved — per the code-skip-context contract
(EC-7.2.016-3, BC-7.2.018 point 4); the originally-specified (b) would silently strip the
backslash and emit `` `@x` ``, a real correctness regression, not a cosmetic gap. **The framing
that "either approach satisfies this BC's observable contract" is false and is retracted here:**
option (a) was never context-blind in the first place, because it inspects the real parser's own
event stream, which natively distinguishes `Event::Code`/`Tag::CodeBlock` from prose — only the
originally-specified (b) had this gap. Any implementation of (b) that omits the correction below
does not satisfy BC-7.2.018 point 4 and must not ship.

**Revised (b), RECOMMENDED — code-context-guarded pre-parse sentinel protect/restore:**

1. **Code-range guard (closes MED-1).** Before any sentinel substitution, run a **disposable,
   single-purpose scan**: `pulldown_cmark::Parser::new_ext(markdown, <the same Options bitset
   markdown_to_adf's main build uses>).into_offset_iter()`, executed once against the
   **untouched, original** raw string, collecting only the byte ranges of `Event::Code` (inline
   code spans) and `Tag::CodeBlock` (fenced and indented code blocks) — every other event in
   that stream is discarded immediately, and no tree is retained. This is **not** a hand-rolled
   second copy of CommonMark's backtick/fence grammar: it is the same parser and the same
   grammar the rest of `adf.rs` already trusts, invoked once, narrowly, for exactly one
   question ("which byte ranges are code?"). Avoiding a hand-rolled duplicate grammar here
   matters specifically because this ADR's own Rationale section names the risk of "a lexer that
   can silently under-report relative to the real parser it claims to mirror" (citing this
   repo's own `check-ci-gate.sh` history in `CLAUDE.md`) — hand-matching backticks/fences here
   would be exactly that risk, transplanted from `ci.yml` to `adf.rs`. This guard scan is also
   **not** the rejected option (a): it never touches, wraps, or correlates positions against
   `AdfBuilder`'s shared `TextMergeStream<Parser>` (the concern that sank (a) as a primary
   mechanism), and it never maps an *already-merged* text run's position back to a raw offset
   (the "offset drift" risk BC-7.2.018 flagged for (a)) — it runs once, before any merging
   happens, directly against the pristine input, and answers only "is offset P inside a code
   range," which `into_offset_iter()` answers exactly and cheaply for unmerged input.
2. **Pre-existing-sentinel collision guard (NEW, closes pass-2 adversarial review L-3).** Before
   inserting our own escape sentinel, guard against a raw input that already contains one, so a
   user-authored literal codepoint is never silently reinterpreted as our own marker. Reserve
   **two** Private Use Area codepoints, not one: `SENTINEL_ESCAPE = U+E000` (stands in for an
   escaped `\@`, as originally specified) and `SENTINEL_GUARD = U+E001` (stands in for a
   pre-existing literal `U+E000` found in the user's raw input). Within the **complement** of the
   code ranges from step 1 only, scan for every literal occurrence of `U+E000` and replace each
   one with `U+E001` — i.e. "this position held a real user-supplied `U+E000`; restore it to a
   literal `U+E000`, not to `@`." Content **inside** a detected code range is left completely
   untouched by this step too (identical rationale to step 3 below: code content is never
   substituted into at all, by either sentinel pass, so a pre-existing `U+E000` inside a code span
   or fence already survives untouched with no guard needed there). This step runs strictly
   *before* step 3, so that by the time step 3 inserts `U+E000` as its own marker, any genuine
   pre-existing `U+E000` in the eligible region has already been moved out of the way to `U+E001`
   — the two meanings can never collide in the same substituted string.
3. Within the **complement** of those code ranges only, perform the original backslash-parity
   scan (walk backward from a candidate `@`, count consecutive `\` — an odd count means the `@`
   is escaped, an even count, e.g. `\\@`, means it is not) and replace each unescaped `\@` with
   `U+E000` (`SENTINEL_ESCAPE`, now guaranteed collision-free per step 2). Any `\@` whose byte
   position falls **inside** a detected code range is left **completely untouched, byte-for-byte**
   — CommonMark's no-escape-processing-inside-code rule is preserved exactly, so `` `\@x` ``
   enters the parser as literal backslash+`@`+`x` and, because code-node content passes through
   verbatim, resolves to a literal `` `\@x` `` text node at every downstream stage.
4. This protect step (steps 1–3 together) is exposed as **one shared pure helper**,
   `pub(crate) fn protect_mention_escapes(markdown: &str) -> String`, in `adf.rs`, called at the
   top of **both** `find_mention_candidates` and `markdown_to_adf_with_mentions` — never
   duplicated as two independently-maintained backslash-parity checks. This closes a real defect
   the single-call-site framing of this ADR's first draft left open: without a shared call at both
   sites, `mentions.rs::resolve_mentions` would treat an escaped `\@JaneDoe` as a live `@Name`
   candidate, issue a wasted (or worse, incorrect) `GET /rest/api/3/user/search`, and could pop an
   interactive disambiguation prompt for a name the user explicitly escaped — a real UX defect,
   not merely an internal inefficiency.

   **Correction (pass-2 adversarial review, L-3 fallout) — `markdown_to_adf_no_mentions` must
   NOT call `protect_mention_escapes` at all; the prior "harmless no-op, for uniformity" framing
   is retracted.** `markdown_to_adf_no_mentions` performs no mention detection whatsoever, so it
   has no need to hide an escaped `\@` from a scanner that never runs against its output. Worse,
   calling `protect_mention_escapes` there without a paired restore step (which this entrypoint,
   by design, never runs — it has no `convert_mentions`/sentinel-restore pass at all) would leave
   BOTH sentinels permanently un-restored in the emitted ADF: an intentionally-escaped `\@Name`
   would surface as the raw `U+E000` byte instead of literal `@Name`, and — after this L-3 fix —
   any pre-existing literal `U+E000` in the user's input would surface as `U+E001` instead of
   being preserved. Either outcome breaks BC-7.2.016 point 7 / EC-7.2.016-7's promise that
   `markdown_to_adf_no_mentions` is "byte-for-byte equivalent to `markdown_to_adf`'s pre-#674
   behavior." That promise is already satisfied with zero extra code: per this ADR's own Context
   section, pulldown-cmark's inline parser natively consumes the backslash and merges a literal
   `@` into surrounding text for `\@` **before** any post-`finish()` pass ever runs — this is
   exactly the pre-#674 behavior (there was no mention detection, hence no sentinel machinery,
   before this cycle), and it is correct and sufficient on its own for this entrypoint. Reserve
   `protect_mention_escapes` for the two entrypoints that actually perform mention detection.
5. Run the existing parse → `finish()` → post-`finish()` pipeline unmodified on this
   selectively-transformed string, in the now-definitive pass order pinned in §5 below.
6. **Restore, code-context-guarded (defense in depth) — now a two-sentinel restore.** In the
   post-`finish()` sentinel-restore pass (position pinned in §5), walk `text` nodes exactly where
   `autolink_bare_urls` already walks, and apply the **same skip rule** `autolink_bare_urls`
   already uses for `code`: a `text` node carrying a `code` mark, or content inside a `codeBlock`
   node, is left **completely untouched** — never scanned for, and never has, a sentinel replaced
   within it (H-2 note: this skip rule covers `code` only, never `link` — see the correction in
   §5 below). Because steps 2–3 above never *insert* either sentinel into code content in the
   first place, this restore-side skip is belt-and-suspenders, not the primary correctness
   mechanism — but it is still required so the contract holds even in the maximally-adversarial
   case where the user's raw source already contains a literal sentinel byte inside a code span,
   which must survive untouched rather than be silently rewritten by our own restore pass. Within
   eligible (non-code) text, the restore pass applies **two independent, single-codepoint
   substitutions** in one linear walk — `U+E000` → literal `"@"`, and `U+E001` → literal `U+E000`
   — order-insensitive against each other since the two codepoints are distinct and neither
   substitution's output re-triggers the other's input pattern.

   **Residual risk, explicitly accepted, not eliminated (L-3):** this two-level scheme closes the
   single-codepoint collision (a raw `U+E000` in ordinary prose being misread as our own escape
   marker) but does not generalize to zero risk. A pathological input that ALSO contains a literal
   `U+E001` as ordinary prose content (in addition to a literal `U+E000`) would still have that
   `U+E001` misinterpreted as our own guard marker on restore — a nested collision one level
   deeper, and correspondingly far less likely than the single-codepoint case this fix closes,
   since it requires the user's raw markdown to contain two specific, adjacent Private Use Area
   codepoints as literal authored content. This ADR judges that residual acceptable rather than
   building an unbounded escape-of-escape chain: both codepoints are outside anything a markdown
   author types via a normal keyboard, and no real-world use case involving PUA codepoints in
   issue text surfaced during this cycle's research. Documented here explicitly, per this review
   round's own instruction, rather than left as a silent gap; not re-engineered further by this
   ADR.

**Why (b), revised, over (a):** unchanged on the *iteration-machinery* question — (b) never
touches or wraps `AdfBuilder`'s shared `TextMergeStream<Parser>`, the single highest-blast-radius
piece of machinery in the codebase (275 tests, `MAX_ADF_DEPTH`, INV-1). The code-range guard
added above closes the one respect in which (a) was *naturally* stronger (context-awareness,
inherited for free from inspecting the real parser's own event types) without reopening (a)'s
blast-radius or offset-drift problems, because the guard is a **disposable** `into_offset_iter()`
call scoped to code-range extraction only — never the shared, stateful iteration path the rest of
`AdfBuilder` depends on, and never asked to correlate a *merged* run's position back to source.

**Why not (c) as the primary design:** `--no-mentions` is a blunt, whole-invocation opt-out. A
user who wants to write exactly one literal `@Override` inside an otherwise mention-rich
comment would have to give up *every* mention in that same comment/description to avoid the
human-approved BC-X.7.009 hard-error path. That is a materially worse UX than a working escape,
and `\@` is an explicitly human-promised feature point (BC-7.2.018 point 6) — declaring it
infeasible without attempting the lower-risk option (b) first is not justified by anything in
this cycle's research.

**Cost of the correction:** the code-range guard adds a **third** parse pass per mention-aware
call site (code-range scan, then `find_mention_candidates`, then `markdown_to_adf_with_mentions`'s
build) — up from the two parses this ADR originally accepted. This is judged **equally
negligible**: the guard scan discards its event stream immediately (it materializes only a
`Vec<Range<usize>>`, never a tree), and all three passes remain in-process and negligible against
the network round trips mention resolution straddles, consistent with the original
double-parse-cost framing in Consequences below. The L-3 pre-existing-sentinel guard (step 2
above) adds **no additional parse pass** — it is a second linear string scan/substitution over
the same raw string and the same code-range result step 1 already computed, folded into the same
`protect_mention_escapes` string transform as step 3's backslash-parity substitution.

**Residual risk, explicitly flagged as an F4 spike input (not resolved by this ADR):** the
sentinel codepoint's behavior under pulldown-cmark 0.13's full feature set (emphasis, strong,
code-span exclusion, footnote/task-list interactions) has not been empirically verified — this
is a narrower, single-character round-trip check than option (a) would have required, but it is
still unverified today. **F4 must additionally verify the code-range guard's boundary handling**
at the exact edges of a code span/fence (e.g. an unescaped `\@` immediately adjacent to, but
outside, a closing backtick) has no off-by-one drift, since `into_offset_iter()`'s range
endpoints must be interpreted consistently (inclusive/exclusive) with however the
backslash-parity scan indexes into the same string. If empirical F4 testing shows the chosen
sentinel interacts badly with some other enabled `Options` flag, the fallback order is: try a
different PUA codepoint first; only fall back to (c) (`--no-mentions`-only, no working `\@`
escape) if no sentinel codepoint proves clean. Option (a) is deprioritized as a *second* fallback
below (c), not above it — its blast radius on `adf.rs` is higher, and it should only be revisited
if a *future* cycle needs general-purpose escape-awareness across many different escaped
characters, at which point the investment is worth spreading over more than this one feature.

### 5. Post-`finish()` pass ordering — definitive (closes MED-2)

Four passes touch a built tree after `finish()`: the pre-existing `autolink_bare_urls`; the new
`convert_mentions` (the emit-side pass inside `markdown_to_adf_with_mentions` that splits text
nodes at mention-candidate spans and replaces eligible ones with `mention` nodes —
`find_mention_candidates` runs the identical walk in "collect, don't mutate" mode); the §4
sentinel-restore pass; and the pre-existing `assign_local_ids`. Their relative order is
observable, not an implementation detail free to vary, for the reasons below. This ADR pins one
definitive sequence, applied identically inside both `find_mention_candidates`'s own build and
`markdown_to_adf_with_mentions`'s build:

```
0. protect_mention_escapes(markdown)        — pre-parse, code-range-guarded (§4)
1. parse + finish()                         — base tree
2. autolink_bare_urls
3. convert_mentions   (find_mention_candidates: candidate-collection, same walk, no mutation)
4. sentinel-restore
5. assign_local_ids
```

**Correction (pass-2 adversarial review, H-2) — the "also skip `link`" rule below is REJECTED
and must not be built; this paragraph replaces the ADR's original rationale for that rule.** The
original text here had `convert_mentions`/`find_mention_candidates` extend the code-skip rule to
"also skip `link`." This directly contradicts BC-7.2.016's own EC-7.2.016-4 (a bracket-form span
sitting inside markdown link text, `[[~accountid:X]](url)` — "the mention conversion still
applies to the inner span") and BC-7.2.018's own EC-7.2.018-6 ("`@Name` inside an existing
link/code mark: excluded per point 4 (code) — link-mark interaction is NOT separately
excluded"). Both ECs are correct as written and require **no change**; the defect was in this
ADR's own prose, which this correction retracts.

**Final rule (H-2):** `convert_mentions`/`find_mention_candidates` skip ONLY text carrying a
`code` mark (or `codeBlock` content) — identical to the pre-existing code-exclusion rule already
shared with `autolink_bare_urls`. They do **not** skip `link`-marked text, regardless of whether
that mark came from an explicit markdown link (`Tag::Link`, applied during the initial parse-time
tree build — i.e. already present before any post-`finish()` pass ever runs) or from
`autolink_bare_urls` (a post-`finish()` pass). Both mention forms convert freely inside
link-marked text: `[[~accountid:X]](url)` and `[@jsmith](url)` both produce a real mention node
from their inner span, exactly as EC-7.2.016-4 and EC-7.2.018-6 already specify. There is no
mark-provenance question to solve (explicit-link mark vs. autolink mark) because the rule no
longer distinguishes on `link` marks at all — it never has to tell the two apart.

**Why this is safe against the URL-interior false positive that `autolink_bare_urls` (2) before
`convert_mentions` (3) was originally invoked to prevent** (`http://example.com/@handle`): the
pre-existing start-of-node/whitespace boundary rule (BC-7.2.016 point 2, shared verbatim with
`find_bare_url_spans`'s own boundary check) already excludes this case on its own, with no
dependency on marks at all. A bare `http(s)://` URL span (i) never begins with `@` — bare-URL
autolinking is scoped to explicit `http(s)://` schemes only (see the bare-URL-autolinking note in
this repo's own conventions) — and (ii) by construction contains no internal whitespace
(`find_bare_url_spans`'s extent runs only to the next whitespace or `<`). Therefore no byte
position strictly inside a URL span can ever be "at the beginning of a text node" (the run always
starts with `h` of `http`/`https`) or "immediately after whitespace" (there is none inside the
span) — the two, and only two, conditions the boundary rule accepts. An `@` embedded mid-URL
fails the boundary rule regardless of whether that text run carries a `link` mark, has already
been split out of a larger run, or is still merged with surrounding prose — the argument holds
identically whether `autolink_bare_urls` has run yet or not. The "also skip `link`" rule this
correction retracts was therefore both **incorrect** (it silently broke the two ECs above) and
**unnecessary** (the boundary rule alone already closes the exact gap it was trying to close).

**Pass order — UNCHANGED, but no longer load-bearing for this specific reason.** §5's six-step
sequence still keeps `autolink_bare_urls` (2) before `convert_mentions` (3). This ADR does not
revise that pinned sequence — it is retained for documentation stability and because
`find_mention_candidates` must still reproduce `markdown_to_adf_with_mentions`'s exact
tree-splitting shape (the byte-for-byte candidate-set requirement in the Scope note below).
It is NOT retained because swapping the two passes would change any mention-detection result:
under the corrected rule, the boundary-rule argument above holds identically before or after any
text-node split, so the relative order of `autolink_bare_urls` and `convert_mentions` is provably
inert to the URL-interior case. The original correctness argument for *why* the order mattered is
retracted along with the "skip link" rule it existed to support; F4 may add one regression test
confirming order-invariance if it wants empirical confirmation of this property, but the ADR does
not mandate one.

**Why `convert_mentions` (3) before sentinel-restore (4):** this is the exact ordering
constraint MED-2 named. An intentionally-escaped `\@Name` survives to this point as the PUA
sentinel codepoint — it never matched `protect_mention_escapes`'s candidate grammar as a live
`@`, by construction. If sentinel-restore ran *before* `convert_mentions`, the sentinel would
already be a literal `@` again by the time mention detection ran, making `\@Name` and a genuine,
unescaped `@Name` byte-identical once more — exactly the invisibility problem §4 exists to
prevent, reintroduced one pass later. Running `convert_mentions` first, while the sentinel is
still a sentinel, is the only ordering that keeps the escape meaningful.

**Why sentinel-restore (4) before `assign_local_ids` (5), and why `assign_local_ids` runs last
overall:** `assign_local_ids` is a DFS pre-order walk and must see the tree's **final** node set
to remain a stable, auditable contract — a pass that runs mid-pipeline, followed by more
node-splitting (autolink's link splits, mention's node insertions), risks a future node type that
*does* need a `localId` being silently skipped simply because it did not exist yet when IDs were
assigned. This ADR makes `assign_local_ids` run **last, after every other post-`finish()` pass,
unconditionally** — a single, future-proof invariant, rather than a pairwise rule renegotiated
per new pass. **This is a deliberate, in-scope tightening of the pre-existing documented order**
(`CLAUDE.md`'s GFM task-list note: "`assign_local_ids` ... runs after `finish()`, before
`autolink_bare_urls`") for any pipeline that now also runs the mention passes. It is
behavior-preserving for every pre-#674 test: neither `mention` nodes nor `link`-marked text runs
are node types that currently receive a `localId` attribute in the ADF schema this codebase
targets, so moving `assign_local_ids` to run after `autolink_bare_urls` as well as after the two
new mention passes changes no existing test's assigned IDs, while removing the need to
re-litigate this ordering question the next time a new post-`finish()` pass is added.

**Scope note:** `find_mention_candidates` performs steps 0–3 only — it returns a
`MentionCandidates` list, not an ADF `Value`, so it has no sentinel-restore or `assign_local_ids`
step of its own — but it MUST perform steps 0–2 identically to `markdown_to_adf_with_mentions`'s
build, via the same shared `protect_mention_escapes` helper and the same `code` skip rule (H-2:
there is no `link` skip rule to keep in lockstep — see the correction above), so the span set it
reports as candidates is byte-for-byte the set `convert_mentions` later acts on. A divergence here
(e.g. `find_mention_candidates` skipping the `autolink_bare_urls` pre-step, which would change the
tree's text-node splits it scans over even though the boundary-rule *result* is provably the same
either way — see above) would let `resolve_mentions()` in `mentions.rs` resolve a candidate the
emit-side pass would never actually convert, or silently fail to resolve one it would.

### 6. `--no-mentions` flag shape and composition

Per BC-7.2.016 point 7, plain `markdown_to_adf` unconditionally converts bracket-form mentions
(Decision #1 above), so an opt-out needs a **third** pure entrypoint:

```rust
// PURE — byte-for-byte equivalent to markdown_to_adf's pre-#674 behavior. Both mention
// forms are left as literal text; zero mention nodes; zero HTTP.
pub fn markdown_to_adf_no_mentions(markdown: &str) -> Result<Value, JrError>;
```

`--no-mentions` is a plain boolean clap flag, declared alongside the existing `--markdown` flag
on every write-command args struct that already has one:

- `IssueCommand::Create` args (`src/cli/mod.rs`) — covers both the platform path
  (`create.rs::handle_create`) and, via the same struct, the JSM `--request-type` dispatch fork
  (`jsm_create.rs::handle_jsm_create`, BC-3.8.018) — ONE flag on ONE `issue create` invocation
  covers whichever path the `--request-type` presence/absence selects.
- `IssueCommand::Edit` args (`src/cli/mod.rs`) — covers BOTH of `edit.rs`'s two internal
  `markdown_to_adf` call sites (dry-run preview and live PUT, BC-3.4.032) from the single flag
  on the one `issue edit` invocation.
- `CommentSubcommand::Add` args (`src/cli/mod.rs`) — `comment add`.
- `CommentSubcommand::Edit` args (`src/cli/mod.rs`) — `comment edit`.

**Composition rules:**

- No `conflicts_with`/`requires` relationship to `--markdown`. `--no-mentions` without
  `--markdown` is an accepted, silent no-op (EC-3.3.012-2) — mentions were never going to be
  detected on the `text_to_adf` path regardless, since mention detection is scoped to
  `--markdown` mode only.
- `--no-mentions` is a CLI-layer dispatch decision, not something `mentions.rs` or `adf.rs`
  reason about internally: when present, the call site skips the `mentions::resolve_mentions()`
  `.await` entirely (saving every HTTP round trip the flag is presumably requested to avoid)
  and calls `adf::markdown_to_adf_no_mentions(text)` in place of
  `adf::markdown_to_adf_with_mentions(text, &resolutions)`. This is why the design introduces a
  dedicated third pure function rather than a `bool` parameter threaded through
  `markdown_to_adf_with_mentions` — a boolean parameter would still force every call site to
  construct and thread an (unused) resolutions map, and would not by itself let the CLI
  short-circuit before ever calling the resolver.
- The flag is per-invocation, not per-call-site: `issue edit`'s single `--no-mentions` flag
  governs both of its two internal `markdown_to_adf` call sites identically, because both
  belong to the same invocation (there is exactly one `--description` value per `issue edit`
  call, converted twice — once for the dry-run preview, once for the live PUT — not two
  independent descriptions).

### 7. F2-gate human decision (2026-09-06): tighten `@Name` single-result resolution — resolves EC-X.7.007-5

**Decision (human-approved at the F2 gate, overriding the pass-through default `disambiguate_user`
would otherwise apply):** a search result set of **exactly one active user** whose display name
does **not** name-match the typed `@Name` query is no longer silently resolved. It is routed to
BC-X.7.009's zero-match HARD ERROR (exit 64), not BC-X.7.007's happy path. This closes the
"OPEN DECISION" `EC-X.7.007-5` left for this gate (`.factory/specs/prd/cross-cutting.md` §X.7):
`client.search_users(name)` performs a server-side fuzzy match, so a query can return exactly one
active hit whose display name has no textual relationship to the query at all (e.g. `@jsmith` →
a sole fuzzy hit `"John Smith"` via some other matched field) — `disambiguate_user`'s pre-existing
`users.len() == 1` short-circuit accepts that hit with **zero** name-similarity check, and because
a mention has a real side effect (notifying a third party who was never intended to be tagged),
this cycle's human reviewer judged that gap unacceptable specifically for mentions, even though it
is long-standing, unchanged, inherited behavior for `resolve_user`/`resolve_assignee`/
`resolve_assignee_by_project`, which this decision does **not** touch.

**Confirmed `partial_match` semantics (`src/partial_match.rs`), reused as-is, never reinvented:**
name-match is defined as this file's own existing two-step predicate, applied to the candidate's
display name against the typed query — there is no separate "prefix" rule; substring containment
already subsumes prefix matching:

1. **Exact** — `candidate.to_lowercase() == query.to_lowercase()` (full-string, case-insensitive).
   1 hit → `MatchResult::Exact(name)`; ≥2 hits → `MatchResult::ExactMultiple(first_name)`.
2. **Substring** (reached only when step 1 finds zero exact hits) —
   `candidate.to_lowercase().contains(&query.to_lowercase())`, i.e. the **query is a substring of
   the candidate's display name**, not the reverse, and not prefix-anchored. 0 hits →
   `MatchResult::None(all_candidates)`; **≥1 hits, including exactly one, → `MatchResult::Ambiguous(matches)`**
   — `partial_match` itself never collapses a lone substring hit into a silent single-answer
   result (proven by `src/partial_match.rs`'s own
   `test_partial_match_single_substring_is_ambiguous`/`test_blocked_single_substring_is_ambiguous`
   unit tests). The silent-single-answer collapse this decision closes happens exclusively in
   `disambiguate_user`'s separate `users.len() == 1` short-circuit, which today runs **upstream of
   ever calling `partial_match` at all** — that is precisely the gap being tightened for mentions.

**Chosen mechanism: Option (a) — pre-filter the active-filtered search results by name-match
BEFORE calling `disambiguate_user`. `disambiguate_user` itself is left completely UNCHANGED** (no
new parameter, no new variant, no behavior change to its three existing callers).

In `mentions.rs::resolve_mentions`, for each unique `@Name` token, after the existing
active-only filter (BC-X.7.007 point 1: `active == Some(true)`) and immediately before calling
`helpers::disambiguate_user`, insert one new, pure, synchronous, in-memory reduction step:

```rust
// mentions.rs — new helper. Pure: no I/O, no async — consumes only already-fetched User
// data and the pre-existing, general-purpose partial_match::partial_match. Not part of
// adf.rs's pure core (see the "stays effectful" note below) — it is a plain sync fn that
// happens to do no I/O, same status as most of helpers.rs's own non-async functions.
fn filter_by_name_match(active_users: Vec<User>, query: &str) -> Vec<User> {
    let display_names: Vec<String> =
        active_users.iter().map(|u| u.display_name.clone()).collect();
    match crate::partial_match::partial_match(query, &display_names) {
        crate::partial_match::MatchResult::Exact(m)
        | crate::partial_match::MatchResult::ExactMultiple(m) => active_users
            .into_iter()
            .filter(|u| u.display_name.eq_ignore_ascii_case(&m))
            .collect(),
        crate::partial_match::MatchResult::Ambiguous(matches) => {
            let lower: std::collections::HashSet<String> =
                matches.iter().map(|s| s.to_lowercase()).collect();
            active_users
                .into_iter()
                .filter(|u| lower.contains(&u.display_name.to_lowercase()))
                .collect()
        }
        crate::partial_match::MatchResult::None(_) => Vec::new(),
    }
}
```

Call-site change in `resolve_mentions` (the only change to the resolver's own control flow):

```rust
let name_matched = filter_by_name_match(active_users, name);   // NEW reduction step
let (account_id, display_name) =
    helpers::disambiguate_user(&name_matched, name, no_input, &empty_msg, none_msg_fn)?;
```

`disambiguate_user`'s function body, its `users.len() == 1` short-circuit, and its internal
`partial_match` calls on the `ExactMultiple`/`Ambiguous`/`None` arms are **untouched**. The
tightening is entirely a caller-side reduction of the slice `disambiguate_user` receives, reusing
`partial_match`'s own classification (never a second, independently-maintained name-match
predicate) to decide which raw search hits are even allowed to reach `disambiguate_user`.

**Why this composes correctly, traced through every arity of the reduced input:**

| Raw active-filtered search result | `filter_by_name_match` outcome | What `disambiguate_user` then does | Behavior change vs. today? |
|---|---|---|---|
| 0 results | `partial_match(query, &[])` → `None(vec![])` (per `partial_match.rs`'s own `empty_candidates_always_returns_none` proptest) → reduced list empty | `users.is_empty()` branch → `Err(empty_msg)` | **No** — identical to today's genuine-zero-result path |
| Exactly 1 result, name-matching (exact or substring) | `Exact`/`Ambiguous(len 1)` → reduced list retains that 1 user | `len() == 1` short-circuit → resolves | **No** — the true happy path (H-NEW-MENTION-002) is unaffected |
| **Exactly 1 result, name NOT matching at all (EC-X.7.007-5)** | `None(all_names)` → reduced list **empty** | `users.is_empty()` branch → `Err(empty_msg)` | **YES — this is the new, tightened outcome.** Lands on the SAME branch, and therefore the SAME pinned `"No user found matching"` substring contract (BC-X.7.009 point 2), as a genuine zero-search-result `@nobody` — no new message class, no new exit code, no new `JrError` variant. |
| 2+ results | `Exact`/`ExactMultiple`/`Ambiguous`/`None` reduces (or leaves unchanged) the set exactly as `partial_match` already would | `len() > 1` path re-runs `partial_match` on the (possibly smaller) reduced set — its own pre-existing, unmodified contract | **No** — `ExactMultiple` can only arise from ≥2 exact duplicates already present in `active_users`, and this decision does not alter the `>1` branch's semantics at all |

**Why NOT option (b)** [a new parameter/variant of `disambiguate_user` that disables the
`len() == 1` short-circuit]: would require touching (at minimum, threading a new argument
through) all three of `disambiguate_user`'s existing callers (`resolve_user`, `resolve_assignee`,
`resolve_assignee_by_project`) even though the human decision scopes the tightening to mentions
only — and it would duplicate, one call deeper, exactly the reduction `partial_match` already
gives the pre-filter for free. Not chosen.

**Why NOT option (c)** [a dedicated, mention-only resolution routine independent of
`disambiguate_user`]: would fork the `Exact`/`ExactMultiple`/`Ambiguous`/`None` four-way contract
BC-X.7.007/008/009 already pin as "reuses `disambiguate_user` verbatim" into a second,
independently-maintained copy of the same decision logic — precisely the "a lexer that can
silently under-report relative to the real parser it claims to mirror" class of bug this ADR's own
Rationale section (below) already cites from this repo's `check-ci-gate.sh` history as one to
avoid. Not chosen.

**Effectful/pure boundary — confirmed unaffected; nothing leaks into `adf.rs`.**
`filter_by_name_match` and its caller live entirely in `src/cli/issue/mentions.rs` (SS-02,
effectful CLI shell) and operate only on already-in-memory `User` search results plus the
pre-existing, general-purpose `partial_match::partial_match` helper — a small, Jira-agnostic
utility that already has zero knowledge of ADF, markdown, or `adf.rs`'s data types. This decision
touches none of `adf.rs`'s public surface: `find_mention_candidates`,
`markdown_to_adf_with_mentions`, `markdown_to_adf_no_mentions`, and the `MentionCandidates`/
`MentionResolutions`/`MentionResolution` data shapes defined in §2 above are all **unchanged** —
those functions have no visibility into Jira user search results at all, by design, and this
decision does not give them any. (`filter_by_name_match` is "pure" only in the narrow,
incidental sense of doing no I/O itself — it is not part of, and does not need to be part of,
the formally-hardened pure core `adf.rs` occupies; `resolve_mentions`, its caller, remains the
one place the effectful/HTTP boundary is crossed, exactly as §1–§3 above already establish.)

**Downstream spec work this ADR does not itself perform** (left to the product-owner and
formal-verifier, per this task's own scope — this ADR specifies the mechanism, it does not edit
BC/EC/holdout files):

1. **BC-X.7.007** (`.factory/specs/prd/cross-cutting.md` §X.7) must be revised to retire
   `EC-X.7.007-5`'s "OPEN DECISION, no behavior change" framing and instead state the tightened
   contract as shipped behavior. Exact behavioral contract to encode:
   - **Single result + name matches** (exact case-insensitive equality, or query is a
     case-insensitive substring of the candidate's display name) → resolves silently (unchanged
     happy path).
   - **Single result + name does NOT match** → HARD ERROR, exit 64, same class as a genuine
     zero-match (`disambiguate_user`'s empty-list branch), carrying the pinned
     `"No user found matching"` substring (BC-X.7.009 point 2).
   - **Zero results** → HARD ERROR, exit 64 (unchanged, BC-X.7.009).
   - **Multiple name-matches** (2+ results surviving the pre-filter) → ambiguous
     disambiguation path (unchanged, BC-X.7.008): interactive prompt or `--no-input` exit 64
     with the candidate list.
2. A **new or revised edge case** (superseding `EC-X.7.007-5`) documenting the "single result,
   fuzzy non-match → hard error" behavior, cross-referencing `EC-X.7.007-3`/`EC-X.7.009-4`'s
   existing empty-list-branch framing (same branch, same pinned substring, different cause: a
   name-mismatch reduction rather than an `active` filter).
3. **`H-NEW-MENTION-002`** (the unique-match happy-path holdout) should be reviewed to make
   explicit that its fixture's sole search result DOES name-match the query — so it continues to
   exercise the genuine happy path rather than the now-rejected silent-fuzzy-resolve path this
   decision closes.
4. A **new holdout scenario** is required for the fuzzy-non-match case (e.g.
   `H-NEW-MENTION-012`, next available ID in Group 21): fixture returns exactly one active user
   whose display name does not contain the queried name as a case-insensitive substring and is
   not case-insensitively equal to it → `jr` exits 64, stderr (or the `--output json` error
   envelope) contains `"No user found matching"`, and **zero** mutation HTTP call is made.
5. Any `VP-674-*` verification property describing BC-X.7.007's `len() == 1` short-circuit as
   unconditional should be checked against this tightened contract and revised if it asserts the
   pre-tightening behavior.

## Rationale

- **Preserves the single most valuable invariant in the codebase:** `adf.rs` remains pure,
  synchronous, and zero-I/O after this cycle, exactly as documented in `system-overview.md`
  since Pass 1. Every prior `adf.rs` regression-prevention mechanism (275 tests, the
  `MAX_ADF_DEPTH` guard, the INV-1 chokepoint, the code-mark exclusivity invariant) continues to
  apply unmodified to the whole file, including the two new functions, because they are
  additive and follow the exact same tree-walk/emit style `autolink_bare_urls` already
  established.
- **No new subsystem, no structural redesign.** Everything lands inside the existing SS-02 (CLI
  Layer) and SS-08 (Cross-cutting Utilities) subsystems from the ARCH-INDEX.md Subsystem
  Registry. The only new *seam* is the pure/effectful boundary crossing itself — which this ADR
  exists specifically to document as a reusable precedent.
- **Grammar ownership stays single-sourced.** Detection (what counts as a candidate span) is
  defined exactly once, in `adf.rs`, and reused identically by both the scan pass
  (`find_mention_candidates`) and the emit pass (`markdown_to_adf_with_mentions`) — there is no
  second, independently-maintained copy of the boundary/charset/skip-context rules anywhere in
  `mentions.rs`, closing off the exact class of bug this repository's own `check-ci-gate.sh`
  history (CLAUDE.md) spent sixteen rounds learning the hard way: "a lexer that can silently
  under-report relative to the real parser it claims to mirror."
- **Zero-HTTP-on-failure discipline extends cleanly.** Because resolution happens entirely
  before the pure conversion call, and the pure conversion call happens entirely before any
  mutation HTTP call, the existing "resolve identity before mutate, fail before POST/PUT"
  pattern (`resolve_assignee_by_project`, BC-3.3.005) extends to mentions with no new ordering
  primitive required at any of the four wiring call sites.

## Consequences

### Positive

- `markdown_to_adf`'s public signature is unchanged — every existing external caller and all
  275 pre-#674 tests are unaffected without modification.
- The new effectful module (`mentions.rs`) is small, single-purpose, and independently testable
  against wiremock without needing to touch `adf.rs`'s own test suite at all.
- The pure/effectful boundary crossing pattern (two pure entrypoints + one effectful resolver)
  is now a documented, reusable precedent for any future `adf.rs` feature that needs external
  data (e.g. a future `inlineCard`/`emoji` closure of issue #202, if one is ever undertaken).
- `disambiguate_user`'s visibility bump (`fn` → `pub(super) fn`) is mechanical and carries zero
  behavior change to its three existing callers (`resolve_user`, `resolve_assignee`,
  `resolve_assignee_by_project`).
- **§7's F2-gate tightening closes EC-X.7.007-5 with zero change to `disambiguate_user` or
  `partial_match`.** The fuzzy-single-result-no-verification gap is closed entirely by a new,
  caller-side reduction step in `mentions.rs` that reuses `partial_match`'s own classification —
  `disambiguate_user`'s three pre-existing callers (`resolve_user`, `resolve_assignee`,
  `resolve_assignee_by_project`) are provably unaffected, and the genuine happy-path and
  genuine-zero-result arities for mentions are provably unaffected too (see §7's arity table).

### Negative / Trade-offs

- **Double-parse cost.** Every mention-aware call site now runs the markdown parser twice (once
  in `find_mention_candidates`, once in `markdown_to_adf_with_mentions`) instead of once. This
  is judged negligible: both parses are in-process, and comment/description-sized text is small
  relative to the network round trips the resolution step performs regardless.
- **Two new key spaces to keep straight.** `MentionResolutions` must be looked up differently
  per form (accountId for bracket-form, literal `@Name` span text for the `@Name` form) — a
  discriminated-key or two-map internal representation is required; this is an F4 implementation
  detail this ADR does not mandate a specific shape for, but flags as a real design decision
  the implementer must make deliberately, not accidentally.
- **The `\@`-escape mechanism is genuinely new** — no prior `adf.rs` feature has needed a
  pre-parse source-mutation pass, and (post-MED-1 correction) that pass is now itself
  code-context-guarded by a third, disposable `into_offset_iter()` scan (§4). Post-pass-2 (L-3),
  it also reserves TWO Private Use Area codepoints rather than one (`U+E000` for the escape
  marker, `U+E001` guarding against a pre-existing literal `U+E000` in the raw input) and is
  called by exactly two entrypoints, not three (`markdown_to_adf_no_mentions` does not call it —
  see §4's L-3-fallout correction). It requires its own dedicated F4 empirical verification —
  the sentinel codepoints' survival under the full enabled `Options` set, and the code-range
  guard's boundary handling at code-span/fence edges — before BC-7.2.018 point 6's postcondition
  can be considered proven rather than aspirational.
- **Pass-2 adversarial review corrections (H-2, L-3) are folded into §4/§5 above, not listed as a
  separate open item.** H-2 retracted the "also skip `link`" mention-detection exclusion rule
  (it contradicted EC-7.2.016-4/EC-7.2.018-6, both of which required no change) in favor of a
  code-only exclusion rule, safe against the URL-interior false positive purely via the
  pre-existing boundary rule; the six-step pass order is unchanged but is no longer load-bearing
  for that specific concern. L-3 added the second reserved sentinel codepoint above and removed
  `markdown_to_adf_no_mentions` from `protect_mention_escapes`'s caller list.
- **Triple-parse cost, not double.** The MED-1 correction adds a third in-process parse pass
  (the disposable code-range guard) ahead of the two the design originally accepted
  (`find_mention_candidates`, `markdown_to_adf_with_mentions`). Still judged negligible — see §4
  "Cost of the correction."
- **Post-`finish()` pass ordering is now a five-step, cross-pass invariant** (§5), not a single
  pairwise rule. Any future new post-`finish()` pass in `adf.rs` must be inserted with explicit
  reasoning about where it sits relative to `autolink_bare_urls`, `convert_mentions`,
  sentinel-restore, and `assign_local_ids` — not simply appended without re-deriving these
  ordering constraints. This also tightens `assign_local_ids`'s pre-existing documented position
  (previously: after `finish()`, before `autolink_bare_urls`) to "runs last, unconditionally,"
  which is behavior-preserving for all pre-#674 tests but is a real, in-scope change to a
  previously-shipped invariant that the implementer must apply, not merely a new-code concern.
- **`--no-mentions` adds a third pure entrypoint** to `adf.rs`'s public surface, growing the
  file's already-large public API. This is accepted as the minimal change consistent with
  Design Decision #1's two-function shape (an alternative — a `bool` parameter on
  `markdown_to_adf_with_mentions` — was rejected because it doesn't let the CLI skip the
  resolver call itself, only the emission step).
- **§7's tightening narrows the set of `@Name` queries that silently resolve.** A query that
  previously resolved silently via a fuzzy, name-unrelated single search hit now hard-errors
  instead. This is judged a deliberate, human-approved product tightening (not a regression) for
  the reason given in §7: a mention carries a real-world side effect (a Jira notification to a
  third party) that plain issue-assignment resolution does not, and Jira's own confirmed cases
  of this behavior (`resolve_user`/`resolve_assignee`/`resolve_assignee_by_project`) do not carry
  that same asymmetry to the same degree. Any user who previously relied on this exact fuzzy
  silent-resolve behavior for a mention will now see exit 64 instead — expected and desired per
  the F2-gate decision, not an unintended breakage.
- **One new downstream spec-propagation obligation** (§7's numbered list): BC-X.7.007 needs a
  revision, `H-NEW-MENTION-002` needs a review pass, and a new holdout scenario is required. This
  ADR specifies the mechanism precisely enough for the product-owner and formal-verifier to
  encode it without re-deriving the design, but the actual BC/EC/holdout edits are explicitly out
  of scope for this ADR and are not performed here.

## Alternatives Considered

1. **Raw-string `@Name` → `[~accountid:<id>]` rewrite before parsing** (named in the original
   GitHub issue #674 as one possible approach). Rejected — see Decision §3 point 3: a
   pre-parse rewrite cannot distinguish code-fenced/inline-code occurrences from real prose,
   since that distinction only exists after parsing. **Note (post-MED-1):** the §4 code-range
   guard shows a *targeted*, narrowly-scoped exception to "that distinction only exists after
   parsing" is achievable via a disposable `into_offset_iter()` pre-scan — but this alternative
   remains rejected regardless, because it would still require running that same code-detection
   logic AND the full `@Name`→bracket-form string rewrite AND HTTP resolution all before the
   real parse ever runs, collapsing the clean two-pass (detect-then-resolve, then emit)
   separation §1–§3 rely on into one entangled pre-parse step.
2. **Make `adf.rs` async and give it a `&JiraClient`.** Rejected outright — breaks the
   purity invariant this file has held across nine prior feature cycles, and would require every
   one of `adf.rs`'s 275 tests (many synchronous, several property-based) to be re-architected
   around an async runtime for a single feature's benefit.
3. **Fold resolution into `helpers.rs` instead of a new `mentions.rs` file.** Rejected per the
   F1 delta analysis's own sizing rationale: `helpers.rs` is already a documented ADR-0012 size
   deviation (~1,113 LOC); piling mention-specific candidate coordination, per-candidate search,
   accountId preflight validation, and dedup bookkeeping onto it would push it further past its
   already-flagged threshold for no compounding benefit, whereas the new logic is a cohesive,
   feature-scoped unit that mirrors the existing "one file per concern" convention already used
   by `format.rs`/`changelog.rs`/`field_resolve.rs`/`attachments.rs` within `cli/issue/`.
4. **`into_offset_iter()` source-offset mapping as the `\@`-escape PRIMARY mechanism** (this was
   the mechanism named as "recommended" in the F1/F2 spec text). Reassessed and demoted to a
   secondary fallback here — see Decision §4 for the full rationale (higher blast radius on the
   shared parser iteration machinery, unresolved offset-drift risk on already-merged text runs).
5. **(§7) A new `disambiguate_user` parameter/variant disabling the `len() == 1` short-circuit.**
   Rejected — would require touching all three existing callers for a change scoped to mentions
   only, and would duplicate `partial_match`'s own classification one call deeper than necessary.
   See §7's "Why NOT option (b)."
6. **(§7) A dedicated, mention-only user-resolution routine, independent of `disambiguate_user`.**
   Rejected — would fork BC-X.7.007/008/009's "reuses `disambiguate_user` verbatim" contract into
   a second, independently-maintained copy of the same `Exact`/`ExactMultiple`/`Ambiguous`/`None`
   decision logic. See §7's "Why NOT option (c)."

## Source / Origin

- GitHub issue #674 ("adf-mentions")
- `.factory/phase-f1-delta-analysis/cycle-005/delta-analysis.md` §2 ("THE CENTRAL
  ARCHITECTURAL DECISION — Purity/Effect Boundary for Mentions"), §3 ("Markdown Mention Syntax
  — Tokenization Decision Surface"), §4 ("Design Decisions Recorded for F2")
- `.factory/phase-f2-spec-evolution/prd-delta-674.md`
- BC-7.2.016, BC-7.2.017, BC-7.2.018, BC-7.2.019 (`.factory/specs/prd/bc-7-output-render.md`)
- BC-X.7.007, BC-X.7.008, BC-X.7.009, BC-X.7.010 (`.factory/specs/prd/cross-cutting.md`)
- EC-X.7.007-5 (`.factory/specs/prd/cross-cutting.md` §X.7) — the OPEN DECISION §7 resolves;
  EC-X.7.007-3/EC-X.7.009-4 (same file) — the pre-existing empty-list-branch framing §7's new
  outcome reuses
- `H-NEW-MENTION-002` (`.factory/specs/prd/holdout-scenarios.md`, Group 21) — happy-path holdout
  §7 flags for a review pass; a new holdout (working id `H-NEW-MENTION-012`) is required
- BC-3.3.012, BC-3.4.032, BC-3.5.013, BC-3.8.018 (`.factory/specs/prd/bc-3-issue-write.md`)
- ADR-0012 (module shard rule — sizing rationale for the new `mentions.rs` file)
- ADR-0014 (JSM dispatch fork — governs BC-3.8.018's synchronous-builder threading constraint)
- ADR-0019 (Field DX — precedent for a "spec-level, no `src/` code yet" architecture delta and
  for keeping a shared pure/effectful-boundary data type close to its producing layer)
