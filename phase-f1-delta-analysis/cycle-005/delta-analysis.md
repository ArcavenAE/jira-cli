---
document_type: delta-analysis-report
feature_name: "Markdown mentions -> ADF mention node ([~accountid:<id>] MVP + @Name resolution)"
issue: 674
cycle: cycle-005
created: 2026-09-06
spec_version_at_analysis: "post-cycle-004 (v0.7.0-dev.5, all four tracked cycles CLOSED, pipeline at rest)"
status: complete
intent: "feature"
feature_type: "backend"
scope: "standard"
severity: "N/A"
predecessor_cycles: "PR history establishing the markdown_to_adf extension pattern this cycle must follow: #470/#471 (task lists), #472 (footnotes), #473 (bare-URL autolink), #474 (subsup/heading-attrs), #483 (GFM alert panels), #489/#492 (block HTML), #522 (CR/LF INV-1 chokepoint), #553 (MAX_ADF_DEPTH recursion guard), #571 (code-mark exclusivity)"
research_source: "developer.atlassian.com ADF mention node reference, Atlaskit adf-schema, Jira REST API v3 (Perplexity-validated 2026-09-06); grounded against src/adf.rs, src/cli/issue/{interactions,create,edit,helpers}.rs, src/api/jira/users.rs, src/api/jsm/requests.rs as they exist at commit 024de4d8 (develop tip)"
authored_by: architect
companion_artifact: "artifact-mapping.md (this cycle-005 dir, business-analyst) — authoritative BC/story/test/VP id mapping; this report intentionally does not mint BC-S.SS.NNN ids"
---

# Delta Analysis Report: Markdown Mentions → ADF Mention Node (GitHub #674)

## Feature Request

- **Brief:** GitHub #674 — markdown `@mention`/`[~accountid:...]` syntax is not converted
  to an ADF `mention` node anywhere in `jr`, so a CLI-authored comment or description can
  never notify anyone. Human-approved scope is BOTH (1) the MVP bracket form
  `[~accountid:<id>]` → ADF mention node (id supplied verbatim by the caller), AND
  (2) `@Name` → accountId resolution via Jira user search with disambiguation. Lands in
  `jr issue comment add`, `jr issue create` (description), and `jr issue edit`
  (description) via the shared `markdown_to_adf` converter in `src/adf.rs`.
- **Requested by:** GitHub issue #674 (human-approved scope, both sub-features in one cycle)
- **Date:** 2026-09-06

---

## Classifications

### Intent Classification

**Classified intent:** `feature`

**Rationale:** No mention capability exists today in any form — this is net-new, not a
regression fix or an incremental tweak to existing behavior. `adf.rs`'s `render_node`
already has an explicit, dated placeholder comment (`src/adf.rs:2416-2423`, NFR-O-I)
naming `mention` as "Not implemented in v0.5; tracked under issue #202" — confirming this
has never worked and is being built for the first time, consistent with the `feature`
route (full F1-F7).

### Feature Type Classification

**Classified type:** `backend`

**Rationale:** `jr` is a CLI tool with no UI screens. Every touched file is in `src/adf.rs`
(pure conversion core) or `src/cli/issue/*.rs`/`src/api/*` (command handlers and HTTP
resource calls). Identical classification to every prior `adf.rs` extension cycle
(#470-#571, all classified `backend`).

### Trivial Scope Classification

**Classified scope:** `standard` (NOT trivial) — confirmed below in the Trivial-Scope
Assessment section (#6).

### Severity Classification

N/A — not a bug-fix intent.

---

## Impact Assessment

| Dimension | Affected | Details |
|---|---|---|
| PRD Requirements | New BCs on 3 write paths + reverse-render display paths; exact BC-S.SS.NNN ids owned by `artifact-mapping.md` (companion, business-analyst) | New: mention-conversion behavior on `issue comment add`, `issue create` (+ JSM path pending OQ-1), `issue edit` description; reverse-render behavior on `issue view`/`issue comments`/`issue list` display |
| Architecture | 0 new subsystems, 1 new file, 1 new pure/effectful seam pattern | `src/cli/issue/mentions.rs` (new); `src/adf.rs` extended (new pure fns + new reverse-render arm); no ARCH-INDEX subsystem registry change — everything stays inside SS-02 (CLI Layer) and SS-08 (Cross-cutting Utilities) |
| UX Screens | N/A (CLI, no screens) | `jr` is a terminal tool; "screens" are N/A. New CLI-visible behavior only (mention conversion is transparent — no new flags required for the bracket form; `@Name` detection is automatic within existing `--markdown` mode) |
| Stories | 3 estimated (2 if OQ-2 resolves to fast-follow) | Story A: pure bracket-form conversion; Story B: `@Name` effectful resolution + wiring; Story C: accountId preflight-validate + `attrs.text` population (conditional on OQ-2) |
| Existing Tests | `src/adf.rs` (275 `#[test]`s) + 9 integration suites in the risk zone | See Regression Baseline below for the full file list |
| Verification Properties | New VPs needed for: bracket-form tokenizer purity/determinism, code/mark-exclusion parity with `autolink_bare_urls`, depth-guard interaction, `@Name` boundary-rule false-positive exclusions (npm/annotation/email), disambiguation zero-match/ambiguous-match behavior, reverse-render round-trip | Exact VP-NNN ids owned by `artifact-mapping.md` (companion) |

---

## 1. Impact Boundary

### Verdict: INTERNAL changes to existing modules, plus ONE new module — not a structural
architecture change in the ADR/subsystem-registry sense.

No new subsystem (SS-NN) is required — everything lands inside the existing **SS-02 CLI
Layer** and **SS-08 Cross-cutting Utilities** (`ARCH-INDEX.md` Subsystem Registry; `adf.rs`
is explicitly enumerated under SS-08). No new external dependency, no new HTTP resource
family, no new subsystem boundary. What IS structural, in the narrower sense the factory
cares about (a new **seam**, not a new **subsystem**): this cycle introduces the first
case where a pure `src/adf.rs` conversion needs data that can only be obtained through
network I/O. That seam is the subject of Design Decision #2 below and is the reason this
is `standard` scope, not `trivial`, despite staying inside two existing subsystems.

| Component | File | Classification | Evidence |
|---|---|---|---|
| Pure mention tokenizer/emitter (forward) | `src/adf.rs` (new fn(s), alongside `autolink_bare_urls`/`find_bare_url_spans`) | **NEW** (functions), **MODIFIED** (file) | Mirrors the existing post-`finish()` tree-walk pattern at `src/adf.rs:174` (`autolink_bare_urls(&mut content, 0)?`) called from `markdown_to_adf` (`src/adf.rs:119-180`) |
| Mention reverse-render arm | `src/adf.rs::AdfToTextRenderer::render_node` (new `"mention"` match arm) | **MODIFIED** | Currently falls through to the documented `_` catch-all at `src/adf.rs:2415-2433`; the comment there already specifies the intended render (`attrs.text`, fallback `"@?"`) |
| New pure entrypoint accepting resolved mentions | `src/adf.rs` (new `pub fn`, e.g. `markdown_to_adf_with_mentions`) | **NEW** | See Design Decision #2 — additive wrapper, `markdown_to_adf` unchanged in signature |
| Pure candidate-extraction entrypoint | `src/adf.rs` (new `pub(crate) fn`, e.g. `find_mention_candidates`) | **NEW** | See Design Decision #2 |
| Effectful `@Name`→accountId + accountId-validation pre-resolution | `src/cli/issue/mentions.rs` | **NEW FILE** | No existing file owns "scan text for mention candidates, hit the network, disambiguate" — see rationale below |
| Comment add handler | `src/cli/issue/interactions.rs::handle_comment_add` (`src/cli/issue/interactions.rs:31-92`) | **MODIFIED** | Currently `async fn handle_comment_add(sub, output_format, client)` with NO `no_input` parameter and a synchronous `adf::markdown_to_adf(&text)?` call at line 71 — needs an added `no_input: bool` parameter and an `.await` resolution step inserted before that call |
| Comment add dispatch | `src/cli/issue/mod.rs:~92` | **MODIFIED** | One-line call-site change to thread `no_input` through (the value is already in scope there — `handle_comment_delete`/`handle_comment_edit` already receive it at lines 95/101) |
| Issue create handler | `src/cli/issue/create.rs::handle_create` (call site `src/adf.rs`-invoking line `src/cli/issue/create.rs:259`) | **MODIFIED** | `no_input` is already a parameter of `handle_create` (`src/cli/issue/create.rs:26`) and already used for other resolution calls (e.g. `resolve_assignee_by_project`, line 316) — the new resolution step follows the same pattern |
| Issue edit handler (live path) | `src/cli/issue/edit.rs` (call site `~966`) | **MODIFIED** | `no_input` already a parameter (`src/cli/issue/edit.rs:49`) |
| Issue edit handler (dry-run path) | `src/cli/issue/edit.rs` (call site `~599`, `dr_desc_adf`) | **MODIFIED** | Same function, second call site; the file's own comments (`src/cli/issue/edit.rs:567-585`) already document a load-bearing ordering invariant ("resolution error must surface BEFORE any table-mode preview output") that the new resolution step must preserve — see Regression Risk |
| JSM create description path | `src/api/jsm/requests.rs` (call site `~103`) | **MODIFIED, scope TBC** | Shares the identical `markdown`/`text_to_adf` fork (`src/api/jsm/requests.rs:71,103,105`) as the platform create path; flagged as **Open Question OQ-1** below — the human-approved scope line names "`issue create`" without disambiguating the ADR-0014 JSM dispatch fork |
| `disambiguate_user` visibility | `src/cli/issue/helpers.rs:269` | **MODIFIED** (visibility only) | Currently a bare private `fn disambiguate_user(...)` (`src/cli/issue/helpers.rs:269-`) — the new `mentions.rs` module needs to reuse this exact disambiguation algorithm (candidate-name partial-match, `ExactMultiple` interactive/`--no-input` handling) rather than re-implementing it; requires bumping to `pub(super)` |
| `JiraClient::get_user` | `src/api/jira/users.rs:244` | **DEPENDENT (reused, unmodified)** | Already implements `GET /rest/api/3/user?accountId=` for `jr user view`; directly reusable for the bracket-form accountId preflight-validate decision (Design Decision #4a) with zero new HTTP-call code |
| `JiraClient::search_users` / `search_assignable_users*` | `src/api/jira/users.rs:27,121,144` | **DEPENDENT (reused, unmodified)** | Reused for `@Name` search — same endpoints `resolve_user`/`resolve_assignee`/`resolve_assignee_by_project` already call |
| `partial_match::partial_match` | `src/partial_match.rs:16` | **DEPENDENT (reused, unmodified)** | Already the disambiguation primitive `disambiguate_user` calls; reused transitively |
| `adf_to_text` consumers | `src/cli/issue/{list,view,comments}.rs` | **DEPENDENT (unmodified)** | Call `adf::adf_to_text` (`src/cli/issue/list.rs:562`, `view.rs:119`, `comments.rs:33,48`) with no code change needed; behavior improves automatically once the new `"mention"` render arm exists |
| `worklog.rs` | `src/cli/worklog.rs:33` | **NOT AFFECTED** | Uses `adf::text_to_adf` only (no `--markdown` flag on `worklog add`) — mentions are scoped to the `markdown_to_adf` path only, so worklog comments are structurally out of reach of this feature, not merely out of scope |

### Why one NEW file (`src/cli/issue/mentions.rs`) rather than extending `helpers.rs`

`helpers.rs` is already a documented ADR-0012 size-deviation file at ~1,113 LOC
(CLAUDE.md "Known Size Deviations"). The mention feature adds a non-trivial amount of new
logic: `@Name` span-finding coordination, per-candidate search + disambiguation, accountId
preflight validation, and dedup-before-network-call bookkeeping. Piling this onto
`helpers.rs` would push it further past its already-flagged threshold for no compounding
benefit — the new logic is a cohesive, feature-scoped unit (unlike `helpers.rs`'s grab-bag
of team/points/user/asset/component resolution used across many unrelated flags). A
sibling file mirrors the existing `cli/issue/` module-per-concern convention (`format.rs`,
`changelog.rs`, `field_resolve.rs`, `attachments.rs` are all precedent for "one file per
cohesive concern" within this directory).

---

## 2. THE CENTRAL ARCHITECTURAL DECISION — Purity/Effect Boundary for Mentions

### Constraint

`src/adf.rs::markdown_to_adf` is architecture-documented as **pure** (`.factory/architecture/system-overview.md` lines 51 and 151 both list `adf.rs` under "Pure (no I/O, verifiable)"). Every one of the eight prior `adf.rs` feature cycles (#470-#571) preserved this — none of them ever added an `async fn`, a `Client` parameter, or any network/filesystem access to `adf.rs`. This invariant must not be the one this cycle breaks.

The MVP bracket form `[~accountid:<id>]` is, in isolation, embarrassingly pure: the id
arrives already inside the text, so tokenize → emit `{"type":"mention","attrs":{"id":id}}`
needs no lookup. But two of the requested design decisions attach an I/O requirement even
to this "pure" form:

- **Decision 4a (preflight-validate accountId)** requires one `GET /rest/api/3/user?accountId=` per unique id (`JiraClient::get_user`, already implemented).
- **Decision 4b (attrs.text population)** — populating `attrs.text` for the bracket form needs a display name, which the SAME preflight call already returns for free.

`@Name` resolution is unconditionally effectful: it requires `GET /rest/api/3/user/search`
(`search_users`/`search_assignable_users*`) plus the existing `disambiguate_user`
interactive/`--no-input` logic (`src/cli/issue/helpers.rs:269-`).

So the real question is not "is the bracket form pure" (yes, trivially) — it's "how do we
let an inherently-async resolution step feed a synchronous pure converter, for BOTH forms,
without adf.rs importing `JiraClient` or `tokio`."

### Recommended seam: two-pass pure API + one new effectful pre-resolution module

**adf.rs gains two new pure functions (additive; `markdown_to_adf`'s existing 1-arg
signature is UNCHANGED, preserving all 275 existing `#[cfg(test)]` call sites and all four
existing external callers that don't need mentions):**

1. `pub(crate) fn find_mention_candidates(markdown: &str) -> Result<MentionCandidates, JrError>`
   — runs the *same* `TextMergeStream<Parser>` build `markdown_to_adf` runs (so it sees the
   exact same tree shape, including which text falls inside `codeBlock`/inline-`code`/
   existing `link` marks), walks it with the *same* boundary/exclusion rules the mention
   emitter will use, and returns the set of literal spans found in eligible positions:
   bare accountIds inside `[~accountid:<id>]` brackets, and bare `@Name` tokens. It performs
   **zero** conversion — it is a read-only scan, still 100% pure (parsing text is not I/O).

2. `pub fn markdown_to_adf_with_mentions(markdown: &str, resolved: &MentionResolutions) -> Result<Value, JrError>`
   — the real `markdown_to_adf` body, extended: wherever the tree-walk (new function,
   sibling to `autolink_bare_urls`) meets a `[~accountid:<id>]` span it always emits a
   mention node (self-contained, needs no map lookup unless Decision 4a/4b enrichment is
   wanted); wherever it meets an `@Name` span, it emits a mention node **only if** `resolved`
   has an entry for that exact span text — otherwise the span is left as literal text
   (safe default: an unresolved `@Name` never silently disappears, it just isn't a mention).
   `pub fn markdown_to_adf(markdown: &str) -> Result<Value, JrError>` becomes a one-line
   wrapper: `markdown_to_adf_with_mentions(markdown, &MentionResolutions::empty())` —
   bracket-form mentions with no id-validation/text-population still convert; `@Name` spans
   are inert (matches today's zero-mention behavior exactly when no caller opts in).

**The effectful half lives entirely in the new `src/cli/issue/mentions.rs`:**

```
pub(super) async fn resolve_mentions(
    client: &JiraClient,
    text: &str,
    no_input: bool,
) -> Result<MentionResolutions> {
    let candidates = adf::find_mention_candidates(text)?;      // PURE
    // one GET per unique accountId (dedup first) — Decision 4a/4b
    // one search + disambiguate_user per unique @Name — Decision 4c
    // returns a MentionResolutions map keyed by literal span text
}
```

Call-site shape at all four wiring points (`interactions.rs::handle_comment_add`,
`create.rs::handle_create`, `edit.rs::handle_edit` ×2, and `jsm/requests.rs` if OQ-1
resolves in-scope) becomes:

```rust
let resolutions = mentions::resolve_mentions(client, &text, no_input).await?;   // effectful
let adf_body = adf::markdown_to_adf_with_mentions(&text, &resolutions)?;        // pure
```

### Why this beats the alternative named in the brief ("rewrite `@Name` to `[~accountid:id]` text before conversion")

A raw-string text rewrite of `@Name` → `[~accountid:<id>]` performed *before* CommonMark
parsing cannot know whether the matched `@Name` span sits inside a fenced code block or
inline code span — that information only exists after parsing. A rewrite pass would
therefore incorrectly convert a literal `@JaneDoe` appearing inside `` `@JaneDoe` `` or a
fenced code example into a real mention. The two-pass design above parses once to find
candidates in the *same* structural positions the final emitter will honor (reusing the
existing code/mark-exclusion logic `autolink_bare_urls` already established), so both
forms respect code-fence and inline-code boundaries identically to how bare-URL
autolinking already does. The double-parse cost is negligible (in-process, no I/O,
comment/description-sized text) against the network round trips it straddles.

### Why this doesn't need a shared "mention grammar" duplicated across layers

Each grammar is owned by exactly one layer, eliminating the class of bug this repository's
own CI-gate history (CLAUDE.md's extensive `check-ci-gate.sh` saga) spent sixteen rounds
learning the hard way — "a lexer that can silently under-report relative to the real
parser it's supposed to mirror":
- `[~accountid:<id>]` grammar is owned by `adf.rs` alone (self-contained, no map needed).
- `@Name` grammar is owned by `adf.rs`'s `find_mention_candidates` for *detection*, and by
  `mentions.rs` for *resolution* — but `mentions.rs` never re-implements the "is this text
  eligible" boundary rules; it only consumes the list of spans `find_mention_candidates`
  already extracted.

---

## 3. Markdown Mention Syntax — Tokenization Decision Surface

### Why `[foo]` survives as literal text (grounding, not assumption)

pulldown-cmark resolves `[label]` as a shortcut reference link only when a matching link
reference definition (`[label]: url`) exists elsewhere in the document. This repository's
own footnote-marker code already documents and relies on the opposite case: "pulldown-cmark
only emits `FootnoteReference` for *defined* labels — an undefined `[^x]` stays literal
text upstream" (`src/adf.rs` footnote section, issue #472). `[~accountid:<id>]` will,
absent a pathological coincidence where the user's own text also defines
`[~accountid:<id>]: <url>` as a real reference elsewhere in the same comment, arrive as an
ordinary literal `Event::Text("[~accountid:<id>]")` — exactly the same shape bare URLs
already arrive in for `autolink_bare_urls` to post-process. Recommend a single documented
edge case (EC) for the reference-collision scenario (treat as non-mention, literal text,
zero special-casing) rather than defending against it structurally.

### Bracket-form grammar (accountId)

- **Boundary:** literal `[~accountid:` prefix, immediately followed by an opaque id, then `]`.
- **Id charset:** per validated research, accountId is opaque; DO NOT assume UUID shape.
  Recommend accepting `[A-Za-z0-9:_-]+` between `accountid:` and the closing `]` — this
  covers both documented id formats (colon- and hyphen-bearing) without over- or
  under-matching. No `regex` crate needed — a manual byte/char scan mirrors
  `find_bare_url_spans`'s existing style (`src/adf.rs:286-336`) and this repository's
  stated preference to avoid new dependencies where a hand-rolled scan suffices
  (`validate_comment_id`'s own comment: "No `regex` or `once_cell` crate needed").
- **Start boundary:** same GFM-derived rule the bare-URL autolinker already applies — a
  candidate `[~accountid:` may start at text-node start or after whitespace/`*_~(`,
  reducing the (already-low) risk of matching mid-word.
- **Skip contexts:** identical exclusion set to `autolink_bare_urls` — never inside
  `codeBlock` content, never inside a text node already carrying a `code` mark. This is a
  hard requirement (a code example showing the literal syntax, e.g. documentation
  explaining `[~accountid:xyz]` itself, must not be converted).
- **Depth guard interaction:** the new tree-walk is a sibling of `autolink_bare_urls`, so it
  reuses `MAX_ADF_DEPTH = 256` (`src/adf.rs:15`) with the identical `depth >= MAX_ADF_DEPTH`
  early-return contract (`src/adf.rs:204-208`) — no new depth-guard design needed, just one
  more call site following the established pattern.
- **INV-1 interaction:** the emitted mention node carries no raw text with embedded `\n`/`\r`
  (a mention node has no free-text body — only `attrs.id`/`attrs.text`, and `attrs.text` is
  a single `"@" + display_name` string built by `mentions.rs`, not user-authored free text,
  so INV-1's raw-newline concern does not apply to it the way it applies to `text` nodes).

### `@Name` grammar — the higher-risk surface

Unlike bare URLs (`http(s)://` explicit scheme, near-zero false-positive rate — this is
exactly why #473 excluded `www.`-prefixed hosts and bare emails), `@` is a heavily
overloaded character in the domain this CLI's own users write about:

- npm scoped packages: `@angular/core`, `@types/node`
- Docker/OCI digests and Twitter/social handles
- Java annotations: `@Override`, `@Deprecated`
- Email local parts: `user@example.com` (the `@` here is NOT preceded by whitespace, so the
  existing GFM-style "boundary before" rule — start-of-node or after whitespace/`*_~(` —
  already excludes most of these, mirroring how the bare-URL autolinker's boundary rule
  works today)
- Slack-style broadcast mentions: `@channel`, `@here` (no corresponding Jira user)

**Recommendation (for F2 to ratify as a BC, not a final architect decision):**

1. Reuse the bare-URL autolinker's boundary rule verbatim: `@Name` may start only at
   text-node start or after whitespace/`*_~(`. This alone excludes email local parts
   (`user@example.com` — `@` is mid-word, boundary fails).
2. Bound the token to a single whitespace-delimited run with a restricted charset (letters,
   digits, `.`, `_`, `-` — explicitly **excluding `/`**). Excluding `/` specifically kills
   `@angular/core`/`@types/node`-shaped false positives, which are near-certain to appear in
   this tool's own commit-message-adjacent comment text.
3. **Multi-word display names are an explicit open question, not silently supported.** A
   bare single-token grammar cannot match `@Jane Doe` without inventing a delimiter. Two
   options for F2/PO to choose between: (a) scope `@Name` to single-token names/usernames
   only for this cycle, documenting multi-word names as "use the `[~accountid:<id>]` form
   instead"; (b) introduce an explicit multi-word delimiter (e.g. `@[Jane Doe]`, bracket-
   wrapped) as a second recognized `@`-form. Recommend (a) for MVP — it is zero-grammar-risk
   and the bracket escape hatch already exists for every case the simple grammar misses.
4. Skip contexts identical to the bracket form: never inside `codeBlock`/inline-`code`.
5. Because `@Name` detection is folded into `find_mention_candidates`'s single AST-aware
   pass (Design Decision #2), it automatically inherits the depth guard and code/mark
   exclusions — no separate design needed there.

---

## 4. Design Decisions Recorded for F2

**(a) Preflight-validate accountId vs. document silent failure — RECOMMEND validate.**
Cost: one `GET /rest/api/3/user?accountId=` per *unique* id in the input (dedup before
calling — a comment mentioning the same person three times costs one call, not three).
`JiraClient::get_user` already exists (`src/api/jira/users.rs:244`), so this is reusing an
existing, already-tested method, not building a new HTTP call. Rationale: Jira's own
silent-`@unknown` failure mode is exactly the kind of footgun this codebase has a strong,
repeated precedent for closing at the CLI layer even when the upstream API won't (BC-3.2.013
proactive resolution enforcement; `sanitize_attachment_filename`'s containment work; the
`--replace-existing` attachment collision guards). Shipping a feature whose entire purpose
is "notify someone" with a documented, easily-triggered silent-no-op failure mode
(mistyped or copy-pasted stale accountId) undermines the feature's reason for existing.

**(b) `attrs.text` population — RECOMMEND populate for both forms, as a free byproduct of (a).**
For `@Name`, the display name is already in hand from the search result — no extra cost.
For the bracket accountId form, the SAME preflight call in (a) returns `display_name`
(`User.display_name`, per `src/types/jira/user.rs`), so populating `attrs.text = "@" +
display_name"` costs nothing beyond the call (a) already pays for. If (a) is deferred/cut
from MVP, `attrs.text` is correspondingly omitted for the bracket form only (Jira's own
editor still resolves `attrs.id` to a live name at render time — the omission only affects
plain-text exports/emails, which is the exact tradeoff the validated research names).

**(c) `@Name` ambiguity/disambiguation — RECOMMEND reuse `disambiguate_user` verbatim.**
`src/cli/issue/helpers.rs:269-` already implements: single match → resolve silently; zero
matches → `JrError::UserError` (exit 64); multiple exact matches → list candidates and, in
`--no-input` mode, exit 64 with the candidate list rendered (mirrors `resolve_user`/
`resolve_assignee`/`resolve_assignee_by_project`'s existing three-way pattern). Requires
bumping `disambiguate_user`'s visibility to `pub(super)` (currently a bare private `fn`) —
a mechanical, near-zero-risk change. **Deliberate deviation from `resolve_user`/
`resolve_assignee`'s "zero matches → hard error" convention:** because `@Name` is detected
inside free-form prose rather than supplied via an explicit `--assignee`/`--user` flag, a
**zero-match** `@Name` candidate should NOT hard-error the whole comment/description —
recommend treating "grammar matched, search found nobody" as a silent pass-through (the
span stays literal text, `--verbose` may log it), while an **ambiguous** (multiple exact
matches) candidate still hard-errors/prompts exactly like the flag-based resolvers, since
multiple matches is strong evidence the user did mean a real mention and just under-
specified it. Rationale: unlike an explicit `--assignee jane`, free text is not an
unambiguous declaration of intent to mention a Jira user — treating every zero-match
`@word` as fatal would make ordinary technical writing (`@types/node`, `@Override`, a typo
in someone's name) break comment/create/edit commands outright, which is a materially worse
regression than "the intended mention silently didn't happen" (which the user can detect via
`--dry-run`/preview or by noticing no notification arrived, and retry with the unambiguous
bracket form).

**(d) JSM internal/public interaction — RECOMMEND document only, no blocking validation.**
`jr` has no reliable, cheap way to determine whether a resolved accountId belongs to a
portal customer (who cannot see internal-only comments) versus staff, without an extra API
call per mention per comment. Recommend documenting the limitation in CLAUDE.md/help text
(mirrors the existing documented pattern for JSM comment-visibility asymmetries, e.g.
BC-3.5.006's merge-semantics note) rather than adding validation cost/complexity for a
narrow edge case.

**(e) Unresolvable `@Name` — hard error vs. pass-through — RECOMMEND pass-through (see (c)).**
Consistent with (c)'s reasoning: a zero-match single-token `@Name` candidate is not
distinguishable with confidence from ordinary prose containing a stray `@`, so the safer
default for a free-text scan (as opposed to an explicit CLI flag) is silent pass-through,
not exit 64. The unambiguous `[~accountid:<id>]` form remains available whenever the user
needs a guaranteed mention and wants preflight validation to catch typos loudly (per (a),
an invalid accountId in bracket form SHOULD hard-error, since that form has already
declared unambiguous intent).

---

## 5. Regression Risk Assessment

| Module | Risk | Justification |
|---|---|---|
| `src/adf.rs` | **HIGH** | CORE, pure, 8 direct dependents across the whole CLI (`interactions.rs`, `create.rs`, `edit.rs`, `list.rs`, `view.rs`, `comments.rs`, `worklog.rs`, `api/jsm/requests.rs`), 275 existing `#[test]`s, the single most heavily hardened file in the codebase (recursion-depth guard SEC-001, INV-1 CR/LF chokepoint, code-mark exclusivity BC-7.2.015). Any regression here potentially corrupts every markdown-mode conversion in the product. Mitigation: purely additive changes (new functions, new match arm, new wrapper preserving the existing 1-arg `markdown_to_adf` signature byte-for-byte) — no existing function body is modified beyond adding the new post-pass call and the new `"mention"` render arm. |
| `src/cli/issue/edit.rs` | **MEDIUM-HIGH** | Already the largest, most adversarially-hardened file in the CLI layer (~3,187 LOC, 3 rounds of Step-4.5 review per CLAUDE.md's Known Size Deviations). TWO independent call sites (`~599` dry-run, `~966` live) both need the new resolution step, and the dry-run path has an explicit, previously-litigated ordering invariant ("resolution error surfaces BEFORE any table-mode preview output," `src/cli/issue/edit.rs:567-585`) that the new `.await` must respect identically to the existing `markdown_to_adf` call it sits beside. |
| `src/cli/issue/create.rs` | **MEDIUM** | Single call site, `no_input` and `client` already in scope and already used for an analogous async resolution (`resolve_assignee_by_project`) — low novelty, but this is the universal issue-creation description path. |
| `src/cli/issue/interactions.rs` (`handle_comment_add`) | **MEDIUM** | Requires a public-signature change (add `no_input: bool`) to a function with exactly one call site (`cli/issue/mod.rs:~92`) — mechanically simple, but `comment add` is one of the highest-traffic write commands in the tool. |
| `src/api/jsm/requests.rs` | **MEDIUM (conditional on OQ-1)** | Same class of change as `create.rs`, but only if the human/PO confirms the JSM dispatch fork is in scope (see OQ-1). If excluded, this file moves to the regression baseline untouched. |
| `src/cli/issue/mentions.rs` (NEW) | **LOW** | Nothing in the existing codebase depends on a file that doesn't yet exist; risk is confined to the new code's own correctness, fully covered by new tests. |
| `src/cli/issue/helpers.rs` | **LOW** | Visibility-only change (`fn` → `pub(super) fn` on `disambiguate_user`); no behavior change to any existing caller. |
| `src/api/jira/users.rs` | **LOW** | Reused as-is (`get_user`, `search_users`, `search_assignable_users*`); zero code changes. |
| `src/cli/issue/{list,view,comments}.rs` | **LOW** | No code change; behavior improves automatically via the new `adf_to_text` mention arm. |
| Everything else (regression baseline) | **N/A** | See Files NOT Changed below. |

---

## 6. Trivial-Scope Assessment

**NOT trivial** — confirmed against all five criteria:

- Impact boundary: **multi-module** (adf.rs core + 1 new file + 3-4 CLI handler files + 1
  visibility change) — fails the single-module/single-file bar.
- New BCs needed: **yes** — new mention-conversion BCs on `issue comment add`/`issue
  create`/`issue edit`, plus reverse-render BCs on `issue view`/`comments`/`list` display
  paths (business-analyst owns exact BC ids in the companion `artifact-mapping.md`).
- Architecture change: **arch-adjacent** — no new subsystem, but a genuinely new *seam*
  (first-ever async-resolution-feeding-pure-converter pattern in `adf.rs`'s history) that
  sets precedent for any future `adf.rs` feature needing external data (e.g. #202's
  `inlineCard`/`emoji`/`media`).
- New external dependencies: none required (no new crate; reuses existing REST endpoints).
- Regression risk: **HIGH** on `adf.rs` (see §5) — fails the LOW bar outright.

→ Full F1-F7 applies. Quick-dev routing is not appropriate.

---

## 7. Files Changed

### New Files

| File Path | Purpose |
|---|---|
| `src/cli/issue/mentions.rs` | Effectful `@Name`→accountId resolution + accountId preflight-validate/text-population pre-pass (`resolve_mentions`), reusing `helpers::disambiguate_user`, `JiraClient::get_user`/`search_users*` |

### Modified Files

| File Path | Change Type | Risk |
|---|---|---|
| `src/adf.rs` | New pure functions (`find_mention_candidates`, `markdown_to_adf_with_mentions`) + new forward tree-walk (mirrors `autolink_bare_urls`) + new `"mention"` reverse-render arm; `markdown_to_adf` becomes a thin wrapper (signature unchanged) | HIGH |
| `src/cli/issue/interactions.rs` | `handle_comment_add` gains `no_input: bool` param + `.await` resolution step before `markdown_to_adf` call | MEDIUM |
| `src/cli/issue/mod.rs` | One-line dispatch change threading `no_input` into `handle_comment_add` | LOW |
| `src/cli/issue/create.rs` | `.await` resolution step before the `markdown_to_adf` call (line ~259) | MEDIUM |
| `src/cli/issue/edit.rs` | `.await` resolution step before BOTH `markdown_to_adf` call sites (dry-run ~599, live ~966) | MEDIUM-HIGH |
| `src/cli/issue/helpers.rs` | `disambiguate_user` visibility `fn` → `pub(super) fn` | LOW |
| `src/api/jsm/requests.rs` | Same pattern as `create.rs` — **conditional on OQ-1** | MEDIUM (conditional) |

### Dependent Files (unchanged, behavior improves)

| File Path | Depends On | Regression Risk |
|---|---|---|
| `src/cli/issue/list.rs` | `adf::adf_to_text` | LOW |
| `src/cli/issue/view.rs` | `adf::adf_to_text` | LOW |
| `src/cli/issue/comments.rs` | `adf::adf_to_text` | LOW |
| `src/api/jira/users.rs` | called by `mentions.rs` | LOW |
| `src/partial_match.rs` | called transitively via `disambiguate_user` | LOW |

---

## Files NOT Changed (Regression Baseline)

- `src/api/client.rs`, `src/api/auth*.rs`, `src/api/refresh_coordinator.rs`, `src/api/pagination.rs`, `src/api/rate_limit.rs` — HTTP/auth core, no dependency on ADF conversion
- `src/cache.rs`, `src/config.rs` — no relationship to mention resolution
- `src/output.rs`, `src/error.rs`, `src/jql.rs`, `src/duration.rs`, `src/observability.rs` — cross-cutting utilities unrelated to ADF conversion
- `src/cli/worklog.rs` — uses `text_to_adf` only; `worklog add` has no `--markdown` flag, structurally unreachable by this feature
- `src/cli/{board,sprint,team,user,init,project,component,queue,requesttype}.rs` — no markdown/ADF conversion in any of these command families
- `src/api/jira/{issues,bulk,boards,sprints,fields,statuses,links,resolutions,teams,worklogs,projects,attachments,components}.rs` — all unrelated resource calls
- `src/api/jsm/{servicedesks,queues,request_types,attachments}.rs` — unrelated JSM resources (only `requests.rs` is touched, and only conditionally)
- `src/api/assets/*.rs` — Assets/CMDB, unrelated
- `src/types/**` — no new wire type needed beyond what's already in `User`/mention JSON built inline via `serde_json::json!` (consistent with how every other ADF node in `adf.rs` is built — no dedicated struct)
- `src/cli/issue/{format,view,comments,jsm_create,workflow,links,assets,changelog,field_resolve,attachments,json_output}.rs` — no touch beyond the explicitly listed dependents above

---

## Risk Assessment

| Risk Type | Level | Rationale |
|---|---|---|
| Regression | HIGH (on `adf.rs`), MEDIUM overall | See §5; mitigated by additive-only design preserving `markdown_to_adf`'s existing signature and the full 275-test suite |
| Architecture | LOW-MEDIUM | No new subsystem; one new seam pattern (pure-converter + effectful pre-resolution) that must be documented as a reusable precedent for future `adf.rs` I/O-needing features (#202) |
| Security | LOW-MEDIUM | Mention `attrs.text`/`attrs.id` are server-echoed display names/opaque ids, not attacker-controlled markup; the accountId-charset scan (manual, no regex) should be reviewed for the same class of ReDoS-adjacent concern `find_bare_url_spans` already avoids by construction. `@Name` false-positive scanning is a correctness/UX risk, not a security one. |
| Performance | LOW | One extra CommonMark parse pass (in-process, no I/O) plus at most a handful of deduped network calls per comment/description — negligible against existing per-command HTTP round trips. |

---

## Regression Baseline

- **Total existing tests (adf.rs alone):** 275 `#[test]` functions, plus integration suites `tests/adf_code_mark_exclusivity.rs`, `tests/adf_inline_html_inv1_e2e.rs`, `tests/adf_recursion_depth.rs`, `tests/comment_crud_api.rs`, `tests/comment_edit.rs`, `tests/comment_view.rs`, `tests/issue_create_field.rs`, `tests/issue_create_jsm.rs`, `tests/issue_edit.rs`, `tests/issue_commands.rs`
- **Tests in risk zone:** all of the above (any regression in the shared `markdown_to_adf`/`adf_to_text` pure core is visible through every one of these suites)
- **Risk zone test files:** `src/adf.rs` (inline `mod tests`), `tests/adf_*`, `tests/comment_*`, `tests/issue_create_*`, `tests/issue_edit.rs`

---

## Scope Recommendation

- **Mode:** Feature Mode (full F1-F7), consistent with every prior `adf.rs` extension cycle
- **Estimated new stories:** 3 (see below), possibly 2 if F2/PO defers Design Decision (a)/(b) validation+text-population to a fast-follow
- **Proposed story shape:**
  1. **Story A — Pure bracket-form mention conversion.** `find_mention_candidates` + `markdown_to_adf_with_mentions` in `adf.rs` (forward tokenizer/emitter mirroring `autolink_bare_urls`, plus the reverse `"mention"` render arm), wired into all 3-4 call sites with an EMPTY `MentionResolutions` map (i.e., bracket-form works end-to-end; `@Name` is parsed as a candidate but not yet resolved — behaves as literal text). This story alone closes the MVP half of #674 and is independently shippable/testable.
  2. **Story B — `@Name` effectful resolution.** New `src/cli/issue/mentions.rs`, `resolve_mentions()`, reusing `disambiguate_user` (visibility bump) and `search_users*`; wires the non-empty `MentionResolutions` map into the same call sites Story A established. Depends on Story A.
  3. **Story C — AccountId preflight-validate + `attrs.text` population (Decision 4a/4b).** Extends `resolve_mentions()` to also validate/enrich bracket-form ids via `get_user`, folding the display name into the same resolution map Story B's structure already carries. Can be delivered as part of Story B if F2 decides (a)/(b) are MVP-required rather than fast-follow (recommend folding in — see Design Decision (a) rationale) — **F2 should make this call explicitly**, not default it.
  - Comment-add vs. create/edit wiring is **not** split into separate stories — all three (plus the conditional JSM path) share the identical two-line call pattern (`resolve_mentions().await` then `markdown_to_adf_with_mentions()`), so splitting by call site would fragment one mechanical pattern across multiple stories for no benefit. Recommend one "wiring" story (or fold wiring into Story A/B directly) covering all four call sites together, with per-call-site acceptance criteria.
- **Can parallelize:** Story A can proceed independently. Story B depends on Story A's `find_mention_candidates`/`markdown_to_adf_with_mentions` existing. Story C depends on Story B's resolution-map plumbing.

---

## Open Questions

- **OQ-1:** Does the human-approved scope's "`jr issue create`" include the ADR-0014 JSM
  dispatch fork (`--request-type` → `src/api/jsm/requests.rs::handle_jsm_create`), which
  shares the identical `markdown`/`text_to_adf` fork? Recommend YES for consistency (same
  flag surface, same converter, low incremental cost) but this was not explicitly named in
  the approved scope and should be confirmed before F2 authors BCs against it.
- **OQ-2:** Should Design Decisions (a) accountId preflight-validate and (b) `attrs.text`
  population be MVP-required (folded into Story B) or an explicit fast-follow (Story C)?
  Architect recommends folding in (see rationale under Decision (a)), but this is a
  product/scope call, not a purely technical one.
- **OQ-3:** Should `@Name` support multi-word display names in this cycle (via a bracket-
  wrapped `@[Jane Doe]` second syntax) or defer multi-word names to the unambiguous
  `[~accountid:<id>]` form only? Architect recommends deferring (single-token `@Name` only
  for MVP) to minimize false-positive/grammar risk — see §3.
- **OQ-4:** Confirm the zero-match-`@Name`-is-pass-through-not-hard-error stance (Design
  Decision (c)/(e)) with the human/PO — this is a deliberate deviation from every existing
  `resolve_*` helper's "zero matches → exit 64" convention, justified by the free-text
  false-positive domain risk (npm packages, annotations, typos) rather than a technical
  constraint, and should be explicitly ratified rather than inherited by default.
