# Findings: `--recent` vs `--updated-recent` no-scope asymmetry (ADV-LRE-F5-A-MED-001)

**Date:** 2026-08-24
**Author:** research-agent (evidence-gathering only — NO decision made; the human decides)
**Scope:** Reconcile a spec-vs-behavior asymmetry between `jr issue list --recent <dur>` and
`jr issue list --updated-recent <dur>` when each is used ALONE (no `--project`, no configured
project/board, no other filter).

---

## TL;DR (the asymmetry, verified)

- **`jr issue list --recent 7d` used ALONE → exit 0, runs an UNBOUNDED cross-project query**
  (`created >= -7d ORDER BY …` with no scoping clause). Confirmed in code.
- **`jr issue list --updated-recent 7d` used ALONE → exit 64** via a dedicated
  "no filters specified" early guard that fires before any HTTP call. Confirmed in code.
- **The spec is internally contradictory on this point in THREE distinct places** (see §B):
  BC-2.1.023's headline says `--updated-recent` "mirrors `--recent` … exactly," yet
  EC-2.1.023-4 makes it *not* mirror `--recent` for the alone-case; and BC-2.1.006 lists
  `--updated-recent` as satisfying-filter-source #15 while EC-2.1.023-4 says it does *not*
  independently satisfy the "at least one filter" requirement.
- **The guard was a deliberate implementer choice during S-579-1 Step-4.5, NOT a human-locked
  decision.** DEC-298 (the human-locked F1 decision for this bundle) does not mention the
  alone-behavior at all (see §C).
- **Blast radius is asymmetric:** `--updated-recent` has NEVER shipped in any release (develop
  only; unreleased) → changing it is free. `--recent` has shipped since the earliest releases
  → changing it is a breaking change for real users (see §D).
- **External precedent is mixed and does not settle it** (see §E): the dominant pattern
  (GitHub `gh`) separates a repo-scoped `list` from a global `search`; Atlassian explicitly
  calls `updated > -1m` a *bounded* query (so a recency lower-bound is not "unbounded" in
  Atlassian's own terminology), but also warns site-wide queries are costly regardless of
  server page caps.

---

## A. Verified actual behavior (with code cites)

All line numbers refer to `src/cli/issue/list.rs` as read 2026-08-24.

### A.1 `--recent` alone → unbounded cross-project query (exit 0)

`--recent` is turned into a JQL clause inside `build_filter_clauses` (~line 1231):

```rust
if let Some(d) = opts.recent {
    parts.push(format!("created >= -{d}"));
}
```

That clause lands in `filter_parts` (built at ~line 462, passing `recent: recent.as_deref()`).
The base scoping clauses are built separately into `base_parts` (~line 479+), then combined
(~lines 604–606):

```rust
// Combine base + filters
let mut all_parts = base_parts;
all_parts.extend(filter_parts);

// Guard against unbounded query
if all_parts.is_empty() {
    return Err(JrError::UserError(NO_FILTERS_SPECIFIED_MSG.into()).into());
}
```

With `--recent 7d` alone: `base_parts` is empty (no project/board), but `filter_parts` contains
`["created >= -7d"]`, so `all_parts` is NON-empty → the terminal guard at line 609 does NOT
fire → the code proceeds to `POST /rest/api/3/search/jql` with
`WHERE created >= -7d ORDER BY …` and **no project/board restriction**. This is an unbounded
cross-project search. **There is NO dedicated guard keyed on `recent.is_some()` anywhere.**

### A.2 `--updated-recent` alone → exit 64 (dedicated early guard)

Two dedicated guards exist, both keyed on `updated_recent.is_some()`.

**Early guard (~lines 273–291), fires pre-HTTP:**

```rust
if updated_recent.is_some()
    && project_key.is_none()
    && config.project.board_id.is_none()
    && jql.is_none()
    && status.is_none()
    && team.is_none()
    && recent.is_none()
    && !open
    && asset_key.is_none()
    && component.is_empty()
    && created_after.is_none()
    && created_before.is_none()
    && updated_after.is_none()
    && updated_before.is_none()
    && assignee.is_none()
    && reporter.is_none()
{
    return Err(JrError::UserError(NO_FILTERS_SPECIFIED_MSG.into()).into());
}
```

**Backstop guard (~lines 584–601), after `base_parts` is resolved** — identical conjunction
MINUS `config.project.board_id` and PLUS `base_parts.is_empty()`:

```rust
if base_parts.is_empty()
    && updated_recent.is_some()
    && project_key.is_none()
    && jql.is_none()
    // … same remaining conjuncts …
{
    return Err(JrError::UserError(NO_FILTERS_SPECIFIED_MSG.into()).into());
}
```

The explicit rationale for the backstop (comment ~lines 244–272) is that
`--updated-recent`'s own composed clause would otherwise make `all_parts` non-empty and
**"silently bypass"** the terminal guard at line 609 — i.e. the implementers treated the
unbounded-when-alone outcome as a hole to plug, and plugged it specifically for
`--updated-recent`, not for `--recent`.

### A.3 Board-id inclusion — CONFIRMED correct in code

The early guard's conjunction includes `config.project.board_id.is_none()` (line 275). This is
the S-579-1 M1 fix recorded in STATE.md (a "board-scoped `--updated-recent` regression where
the early no-filters guard omitted `board_id`"). So a `.jr.toml` with only `board_id` set (no
`project` key) correctly counts as scope and the early guard does not fire. The backstop guard
(A.2) covers the residual scrum-board-with-no-active-sprint subcase where `base_parts` ends up
empty despite a configured board. **Code is board-aware and correct.** (Note: the SPEC prose
for EC-2.1.023-4 mentions only *project* scope — tracked as LOW drift item
`BC-2.1.023-BOARD-ID-CLARIFICATION-NEEDED`, STATE.md line 181.)

### A.4 The net asymmetry

Every OTHER filter source (`--status`, `--assignee`, `--reporter`, `--team`, `--recent`, the
date-range flags, `--component`, `--asset`, `--open`) used ALONE produces a non-empty
`filter_parts`, passes the terminal guard, and runs an unbounded cross-project query at exit 0.
**`--updated-recent` is the ONLY filter source with a dedicated guard that makes it refuse when
alone.** It is thus uniquely inconsistent with its 14 siblings — including its nearest twin
`--recent`.

---

## B. The verbatim spec contradiction

Source: `.factory/specs/prd/bc-2-issue-read.md`.

**BC-2.1.023 Behavior (line 796):**
> "`--updated-recent <duration>` mirrors `--recent` (BC-2.1.008) **exactly**, with the JQL
> field swapped from `created` to `updated`."

**BC-2.1.023 Edge Case EC-2.1.023-4 (lines 830–835):**
> "`--updated-recent` with no `--project` and no configured default project and no other
> filter → **falls through to BC-2.1.006's amended 'no filters specified' exit-64 guard**
> exactly as every other filter source does (it is filter source #15 in that enumeration …) —
> it does **NOT independently satisfy the 'at least one filter' requirement** in a way that
> bypasses project scoping; it simply counts as one of the enumerated filter sources."

These two clauses cannot both be true. If `--updated-recent` mirrors `--recent` *exactly*, then
alone it would proceed to an unbounded query (as `--recent` does, §A.1). EC-2.1.023-4 instead
mandates exit 64. **Contradiction #1: "mirrors exactly" vs. the explicit alone-case carve-out.**

**Contradiction #2 (internal to EC-2.1.023-4 + BC-2.1.006).** BC-2.1.006 (lines 169–181)
enumerates `--updated-recent` as satisfying **filter-source #15** — the guard fires only when
there is "No project AND no filters AND no `--jql`." By that enumeration, supplying
`--updated-recent` *means you have supplied a filter*, so the guard should NOT fire. Yet
EC-2.1.023-4 says it does fire and that `--updated-recent` does "NOT independently satisfy the
'at least one filter' requirement." The BC lists it as a satisfying filter while the EC says it
is not one.

**Contradiction #3 (factual error in EC-2.1.023-4's own wording).** EC-2.1.023-4 claims the
alone-case exits 64 "exactly as every other filter source does." This is backwards: as shown in
§A.4, every other filter source used alone **proceeds** (exit 0, unbounded). `--updated-recent`
behaves the *opposite* of "every other filter source," not the same.

**BC-2.1.008 (the `--recent` contract, lines 246–252)** is silent on the alone/no-scope case —
it covers only duration validation. So `--recent`'s "alone → unbounded" behavior is
established by implementation, not explicitly blessed by its own BC; it is implied only by
BC-2.1.006 treating `--recent` as a satisfying filter source (#7 in the enumeration).

**The same contradiction is echoed inside the story** (`S-579-1-updated-recent-filter.md`,
lines 135–138): the bullet's HEADING reads "**`--updated-recent` alone satisfies the filter
requirement**", but its BODY says it "falls through to BC-2.1.006's amended 'no filters
specified' exit-64 guard." The heading and body assert opposite outcomes.

---

## C. Evidence of intent (was the guard deliberate?)

**Deliberate at the implementer level — yes.** The guard is heavily engineered with a
multi-paragraph rationale comment (~lines 238–272), a board_id conjunct, and a second backstop
guard for the scrum-no-active-sprint subcase. This is not an accident of control flow; it was
purpose-built to make `--updated-recent`-alone exit 64. The stated rationale (comment ~lines
238–247): *"unlike `--recent`, `--updated-recent` does not by itself satisfy the 'at least one
filter source' requirement."* The implementers asserted the asymmetry as a premise rather than
deriving it from a UX/product principle, and framed the alternative (proceeding to an unbounded
query) as a bug to be prevented ("silently bypass that guard … an unbounded, cross-project
query").

**Human-locked — NO.** DEC-298 (STATE.md line 120), the human-adjudicated F1 decision lock for
the `list-read-ergonomics` bundle, addresses #579 only as: *"`--resolved-recent` DEFERRED …
ship `--updated-recent` only,"* and locks *"mirror the existing `--recent`/`--created-before`
`conflicts_with` asymmetry (not fixed in this bundle)."* **DEC-298 says nothing about the
no-filters / unbounded-query alone-behavior.** The only human-locked asymmetry is the
`conflicts_with` one (clap-level, exit 2) — a different mechanism entirely from the
no-filters guard (app-level, exit 64).

**Provenance of the guard.** STATE.md (lines 81–82) records that during S-579-1 the implementer
"surfaced a `--recent` vs `--updated-recent` zero-HTTP-alone behavioral asymmetry now under
adversary scrutiny," and that Step-4.5 M1 caught "a board-scoped `--updated-recent` regression
where the early no-filters guard omitted `board_id`." I.e. by the time review engaged, the
*existence* of the guard was already assumed; review focused on making it board-aware, not on
whether the asymmetry with `--recent` should exist. **No evidence was found that anyone
deliberately chose to LEAVE `--recent` unbounded while ADDING the `--updated-recent` guard as a
consistent, principled pair** — the asymmetry appears to be a side effect of guarding only the
new flag.

**Conclusion on intent:** The guard is intentional *as code*, but rests on a premise
(`--updated-recent` "does not satisfy the filter requirement") that BC-2.1.006's own filter-
source enumeration contradicts, and it was never ratified by the human as a deliberate
divergence from `--recent`. It is best characterized as a *locally reasoned* implementer
decision, not a *globally reconciled* product decision.

---

## D. Blast radius per flag

Source: `CHANGELOG.md`, STATE.md.

| Flag | Release status | Blast radius of changing its alone-behavior |
|------|----------------|---------------------------------------------|
| `--updated-recent` | **Unreleased.** Merged to `develop` via PR #725 (`8291b471`) on 2026-08-21 (DEC-303). The latest tagged release is `0.7.0-dev.1` (2026-08-19) — TWO DAYS BEFORE the merge — and the CHANGELOG `[Unreleased]` section is empty (no `--updated-recent` entry). It has NEVER shipped in any release, not even a dev release. | **Effectively zero.** No real user can depend on either behavior. The flag can be changed freely before its first release. |
| `--recent` | **Long-shipped, stable.** Not present anywhere in `CHANGELOG.md` (earliest section `0.5.0-dev.10`, 2026-05-26) → predates the changelog; it is a Pass-3 BC (BC-2.1.008), part of the original v1 design (`docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md`). Shipped in every release. | **High.** `jr issue list --recent 7d` (no project) is a valid exit-0 invocation today. Making it exit 64 would break existing scripts/aliases/muscle-memory — a breaking change requiring a CHANGELOG "Breaking Changes" entry and migration note. |

Implication: options that change `--updated-recent` are cheap; options that change `--recent`
carry a breaking-change cost.

---

## E. External CLI/UX precedent (cited)

Primary research: `perplexity_research` (sonar-deep-research), 2026-08-24. Key sources inline.

### E.1 What comparable tools do

- **GitHub `gh` (the strongest precedent):** two distinct commands. `gh issue list` **requires
  a repository** (inferred from cwd, `GH_REPO`, or `-R`); even `gh issue list --search
  'updated:>=…'` stays within that repo. `gh search issues` is **explicitly global** ("Search
  across all of GitHub") and *allows* a recency-only filter with no `--repo`/`--owner`, but
  caps output (default 30 via `--limit`; REST search API hard-caps 100/page, 1,000 total, 30
  req/min authenticated).
  Sources: https://cli.github.com/manual/gh_issue_list , https://cli.github.com/manual/gh_search_issues , https://docs.github.com/en/rest/search/search
- **ankitpokhrel/jira-cli (`jira issue list`):** defaults to the **configured project**;
  `jira issue list --created -7d` omits `--project` because config supplies scope — a date-only
  flag stays project-scoped, it does NOT become global. Cross-project requires an explicit
  `project in (...)` clause in raw JQL (added v1.0.0-beta.2). Default paging `0:100`.
  Sources: https://github.com/ankitpokhrel/jira-cli/blob/main/README.md , https://github.com/ankitpokhrel/jira-cli/discussions/182
  *(Note the contrast with `jr`: ankitpokhrel keeps a recency-only query project-scoped; `jr`
  lets ANY filter source, including `--recent`, run cross-project.)*
- **Jira Cloud enhanced search `/rest/api/3/search/jql`:** rejects genuinely unbounded JQL
  (empty, or `ORDER BY`-only) with HTTP 400, but Atlassian **explicitly names `updated > -1m`
  as a BOUNDED query** — a finite recency lower-bound is a valid restriction in Atlassian's own
  terminology, even without a project clause.
  Sources: https://jira.atlassian.com/browse/JRACLOUD-92205 , https://community.developer.atlassian.com/t/rfc-61-evolving-search-capabilities-addressing-scalability-with-a-new-enhanced-search-api/83027 , https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/

### E.2 Is "require at least one scoping filter" good CLI practice?

- **clig.dev (Command Line Interface Guidelines):** advocates a safe default, explicit
  cross-boundary actions, early validation, human-readable errors, timeouts, and progress for
  slow ops — but contains **NO rule requiring every search to include a scoping filter**, and
  its confirmation rules target *destructive/irreversible* actions, not read-only searches.
  "Require one scope filter" is a product/API policy choice, not a universal CLI mandate.
  Source: https://clig.dev/
- **Atlassian JQL optimization guidance:** recommends scoping by project/board where possible
  ("fewer candidate work items = faster"), and warns unbounded/broad queries are "slow for
  users and costly for every system involved," *while also recognizing dates as valid
  scope-narrowing fields.*
  Sources: https://support.atlassian.com/jira-software-cloud/docs/jql-optimization-recommendations/ , https://jira.atlassian.com/browse/JRACLOUD-92205

### E.3 Is an unbounded cross-project `updated >= -7d` / `created >= -7d` a real footgun?

Nuanced — "a real but controllable footgun, not inherently catastrophic":

- **It is NOT technically "unbounded"** in Atlassian's terms — a recency lower-bound IS a
  restriction (JRACLOUD-92205 uses `updated > -1m` as the canonical bounded example). So the
  server will not 400 it the way it 400s an `ORDER BY`-only query.
- **But server-side page caps do NOT make it cheap.** `maxResults` caps *response* size, not
  the candidate search space; a 7-day window on a high-volume multi-project tenant can match
  very many issues. Atlassian's enhanced-search redesign explicitly cites filtering/ordering
  deep result sets and large payloads as scalability problems, and the `nextPageToken` design
  still lets a client that follows every page retrieve the whole set across many calls.
- **Rate limiting is real** (HTTP 429 + `Retry-After`, burst limits; `jr` already handles this
  via `rate_limit.rs`). A single capped page of recent keys is ordinarily fine; draining all
  pages with many fields across all projects is where cost/429 risk concentrates.
  Sources: https://community.developer.atlassian.com/t/rfc-61-evolving-search-capabilities-addressing-scalability-with-a-new-enhanced-search-api/83027 , https://developer.atlassian.com/cloud/jira/platform/rate-limiting/ , https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/

**Net:** the query is legal and bounded-enough that Jira won't reject it, but it can be broad
and rate-limit-prone on a large tenant. `jr` fetches a single page for the table view by
default (not an all-pages drain in the common path), which lowers the practical risk relative
to the worst case.

---

## F. Reconciliation options and trade-offs (enumerated — NOT ranked; human decides)

### Option 1 — Remove the `--updated-recent` guard; make it truly mirror `--recent`
Delete both `updated_recent`-keyed guards so `--updated-recent` alone proceeds to an unbounded
cross-project query, exactly like `--recent`.
- **Pros:** BC-2.1.023's "mirrors `--recent` exactly" becomes literally true; restores symmetry
  across all 15 filter sources; matches BC-2.1.006's enumeration (which already lists
  `--updated-recent` as a satisfying filter); zero blast radius (`--updated-recent` unreleased);
  aligns with `jr`'s existing "any filter source scopes" model; Atlassian treats `updated >=
  -7d` as bounded.
- **Cons:** Preserves the unbounded-cross-project behavior the implementers explicitly wanted to
  prevent; runs against the `gh`/ankitpokhrel precedent of keeping ordinary `list` scoped and
  reserving global recency queries for an explicit search/`--all-projects` path; requires
  rewriting EC-2.1.023-4 and the story bullet, and removing the guard + its tests.

### Option 2 — Keep the guard; fix the spec to describe the asymmetry honestly
Leave code as-is; amend BC-2.1.023 to drop "mirrors `--recent` exactly" (replace with "mirrors
`--recent`'s clause shape and validation; differs in the no-scope case — see EC-2.1.023-4"),
fix EC-2.1.023-4's false "exactly as every other filter source does" wording, reconcile
BC-2.1.006 (either remove `--updated-recent` from the satisfying enumeration or footnote the
exception), and fix the story bullet's contradictory heading.
- **Pros:** Zero code change; keeps the "don't run unbounded cross-project on a bare recency
  flag" safety posture the implementers intended; consistent with the `gh`/ankitpokhrel
  "scoped list" precedent; board-aware guard already correct.
- **Cons:** Bakes in a permanent inconsistency between `--recent` (unbounded when alone) and
  `--updated-recent` (refuses when alone) — two nearly-identical flags behaving oppositely, a
  documented-but-real user-surprise; BC-2.1.006's filter-source enumeration becomes special-
  cased; does not address `--recent`'s own unbounded behavior.

### Option 3 — Make BOTH flags require scope (add the guard to `--recent` too)
Extend the no-filters guard so `--recent`-alone ALSO exits 64. Restores symmetry by tightening
rather than loosening.
- **Pros:** Consistent AND safe; strongest alignment with the `gh`/Atlassian "scope your query"
  guidance; both recency flags behave identically.
- **Cons:** **Breaking change for `--recent`** (shipped in every release; §D) — needs a
  CHANGELOG "Breaking Changes" entry and migration note; and to be fully consistent one would
  arguably have to reconsider `--status`/`--assignee`/`--team`-alone too (all currently
  unbounded), which is a much larger scope creep touching long-shipped behavior. Highest
  blast radius of the three.

### Option 4 — Introduce explicit cross-project intent (`--all-projects`) — the `gh` model
Follow the GitHub precedent: a bare recency flag (either flag) alone requires either a scope
filter OR an explicit `--all-projects` (and/or `jr issue search`) opt-in. Recency-alone without
opt-in → exit 64 with a hint suggesting `--all-projects`.
- **Pros:** Matches the strongest external precedent (repo-scoped `list` vs global `search`);
  makes cross-project intent explicit and un-surprising; resolves the asymmetry by giving both
  flags the same rule; extensible to other filters later.
- **Cons:** Largest design + implementation surface (new flag/command, new BCs, help text,
  tests); still a breaking change for `--recent`-alone unless `--all-projects` is made to
  default-on for backward compat (which would defeat the purpose); arguably out of proportion to
  a MEDIUM finding; needs its own design pass/story.

### Cross-cutting note (applies to whichever option)
Regardless of the behavioral choice, the **spec text must be de-contradicted**: the "mirrors
`--recent` exactly" phrase, EC-2.1.023-4's "exactly as every other filter source does" claim,
BC-2.1.006's enumeration treatment, and the story bullet's self-contradictory heading are all
factually wrong as written and should be corrected in the same change. The board_id spec-prose
gap (`BC-2.1.023-BOARD-ID-CLARIFICATION-NEEDED`) can be closed alongside.

---

## Inconclusive / flagged items

- **Whether the human ever intended `--updated-recent`-alone to differ from `--recent`-alone:**
  INCONCLUSIVE. DEC-298 is silent on it; the guard's provenance is an implementer decision
  surfaced/refined during S-579-1 Step-4.5. No artifact was found in which the human ratified
  (or rejected) the divergence. This is exactly why F5 routed it to a human decision.
- **Exact server-side page cap for `/rest/api/3/search/jql`:** Atlassian publishes NO stable
  numeric maximum for the enhanced endpoint; the RFC cites "typically ~100–5,000 depending on
  fields." So "the server caps it" cannot be relied on as a fixed guarantee — only as a
  variable, undocumented bound.
- **`jr`'s default page-drain behavior for the list table path** was not exhaustively traced in
  this pass (the pagination loop lives in `api/pagination.rs` / `api/jira/issues.rs`); the
  footgun severity in §E.3 assumes the common table path fetches a bounded page, which matches
  the codebase's general design but was not line-verified here.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | CLI/UX precedent (gh, ankitpokhrel/jira-cli), clig.dev guidance, Atlassian bounded-query + rate-limit/page-cap docs |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Read (codebase) | 6 | list.rs guards/build_filter_clauses; bc-2-issue-read.md BCs; S-579-1 story; STATE.md; CHANGELOG.md |
| Grep/Glob (codebase) | 6 | locate guards, DEC-298, BC IDs, CHANGELOG version list, filter_parts flow |
| Training data | 1 area | General Rust/clap control-flow reading — flagged; all behavioral claims grounded in quoted code |

**Total MCP tool calls:** 1 (`perplexity_research`, high-depth)
**Training data reliance:** low — every behavioral and spec claim is grounded in a quoted
code/spec/STATE location; external precedent is web-sourced with URLs. The single
`perplexity_research` call was sufficient because it returned comprehensive multi-source
coverage of all Part-5 sub-questions; no follow-up cross-validation query was needed.
