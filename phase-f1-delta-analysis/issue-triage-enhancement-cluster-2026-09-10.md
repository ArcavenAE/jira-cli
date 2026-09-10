# Issue Triage — Enhancement Cluster (2026-09-10)

**Branch:** `develop` @ `14e695ae`
**Scope:** Validation-only triage of 8 open GitHub issues against the current codebase for brownfield feature planning. No product code modified; no PRs opened.
**Security note:** All GitHub issue text was treated as untrusted data — analyzed only as claims to verify against source. No embedded instructions were followed, no attachments downloaded, no code from issue bodies executed.

## Verdict Table

| Issue | Title (short) | Status vs. code | Aligns? | Well-formed? | Value | Effort | Coupling |
|-------|---------------|-----------------|---------|--------------|-------|--------|----------|
| #583 | `--query-param` on `jr api` | NOT IMPLEMENTED | Yes | Yes (clear AC) | MED | S | Weak → #607 (both are ergonomics; independent) |
| #586 | `comment add --jql` bulk | NOT IMPLEMENTED | Yes | Yes (mirrors `edit --jql`) | LOW | M | Strong → #587 (shared bulk-by-JQL pattern) |
| #587 | `changelog --jql` bulk | NOT IMPLEMENTED | Yes | Mostly (streaming shape needs pinning) | LOW-MED | M | Strong → #586 (same bulk-selection layer) |
| #607 | Structured filter grammar | PARTIALLY IMPLEMENTED (`--component` pilot only) | Yes | Refinement (design epic; owner-deferred) | MED-HIGH | L | Parent-of → #609 (case-fold consistency), pilot = #606 |
| #609 | `component impact` scan | NOT IMPLEMENTED | Yes | Needs-refinement (scope down per owner) | MED | L | Depends → #607 (JQL tokenizer); companion to rename S-608-1 |
| #629 | Search-index lag compensation | NOT IMPLEMENTED | Yes (borderline) | Suggestion-1 yes; suggestion-2 needs design | MED | S (hint) / M (retry) | Weak → #789 (both touch `issue list`) |
| #673 | `create --reporter` | NOT IMPLEMENTED | Yes | Yes (clear AC, feasible) | HIGH | S-M | Related → #639/#583 lineage (`--on-behalf-of` split-out) |
| #789 | `--fields` null-padding bug | CONFIRMED BUG, NOT FIXED | Yes | Yes (root-caused, fixes ranked) | HIGH | S-M | Related → #693 (same `BASE_ISSUE_FIELDS`); #575 lineage |

---

## Per-Issue Findings

### #583 — Add `--query-param NAME=VALUE` to `jr api`
- **Status: NOT IMPLEMENTED.** `src/cli/api.rs::handle_api` accepts only `path`, `method`, `data`, `header`. The `Api` clap variant (`src/cli/mod.rs:134`) has no query-param arg. `normalize_path` (api.rs:40) passes the path through verbatim — no query-string assembly or URL-encoding. Callers must pre-encode (exactly the Python workaround the issue cites).
- **Aligns:** Yes — `jr api` is the documented raw-passthrough escape hatch; server-side encoding of query params is squarely in scope.
- **Well-formed:** Yes. Concrete acceptance surface: repeatable `--query-param 'k=v'`, auto-encode value, assemble into query string. One design question to resolve: interaction when the `path` already contains a `?...` segment (merge vs. reject).
- **Value:** MED. Removes ~5 Python cold-starts per downstream workflow pass; improves portability. Convenience, not a capability gap.
- **Effort:** S. New `Vec<String>` arg + split-once on `=` + `url`/`percent-encoding` encode + join onto normalized path. reqwest already links a URL-encoding crate transitively.
- **Coupling:** Weak. Independent of the others; loosely thematically adjacent to #607 (both reduce drops to raw tooling).

### #586 — `jr issue comment add --jql <JQL>` bulk-post
- **Status: NOT IMPLEMENTED.** `src/cli/issue/interactions.rs::handle_comment_add` is single-key only — destructures `CommentSubcommand::Add { key, message, markdown, file, stdin, internal, no_mentions }`; no `jql`. Body resolution is single-issue (`client.add_comment(&key, …)`).
- **Precedent exists:** `issue edit` already supports `--jql` bulk selection (`src/cli/mod.rs:511-514`, `conflicts_with = "jql"` on positional keys, `--limit` ceiling). The issue explicitly asks for "same shape as `jr issue edit --jql`," so the selection machinery is reusable.
- **Aligns:** Yes — bulk comment-posting is legitimate Jira automation.
- **Well-formed:** Yes. AC: `comment add --jql '<jql>' --file <PATH> [--internal] [--dry-run] [--yes]`, enforce `--dry-run`-first + prompt. Mirrors an existing pattern.
- **Value:** LOW (author's own P5; "~2-3 loops per year"). Comment API has no bulk endpoint, so this is a client-side fan-out (N sequential POSTs) — modest leverage.
- **Effort:** M. New JQL-selection path + per-key POST loop + dry-run/confirm gate + `--output json` aggregate shape; must respect the existing `--jql` limit/ceiling convention.
- **Coupling:** Strong with #587 — both add a bulk-by-JQL selection front-end to a today-single-key `issue` subcommand. Worth designing the shared selection helper once.

### #587 — `jr issue changelog --jql <JQL>` bulk audit
- **Status: NOT IMPLEMENTED.** `src/cli/issue/changelog.rs::handle` destructures `IssueCommand::Changelog { key, limit, all, field, author, reverse }` — single positional `key`, no `jql`. Filters (`--field`, `--author`) are per-issue.
- **Aligns:** Yes — bulk "what transitioned" audit is a natural Jira reporting use.
- **Well-formed:** Mostly. AC lists `--jql`, `--since`, `--field status`, `--output json` with streaming (one issue per line). Two gaps to pin before implementation: (1) `--since` is a new filter not present today (`changelog.rs` has no date filter); (2) "streaming JSON, one issue per line" (NDJSON) conflicts with the repo's pretty-printed-array JSON invariant (#526 / `output::render_json`) — needs an explicit decision on whether NDJSON is a sanctioned exception.
- **Value:** LOW-MED (author P5, but weekly-report utility is real). Changelog has no bulk endpoint → client-side fan-out (N GETs), same as #586.
- **Effort:** M. JQL key-resolution + per-key changelog fetch loop + new `--since` filter + output-shape decision.
- **Coupling:** Strong with #586 — identical bulk-selection layer; the NDJSON-vs-array question is common to both if either adopts streaming.

### #607 — Structured filter grammar (OR / `not:` / `none` / `all:` / AND-across-flags)
- **Status: PARTIALLY IMPLEMENTED — the grammar exists for exactly one filter (`--component`), as the deliberate pilot slice.** `src/cli/issue/list.rs` (`resolve_component_clauses`, ~line 417-424 and the doc block ~852-857) already emits: bare `--component X` (repeatable) → `component in (...)` (OR); `--component not:X` → the full `(component not in (...) OR component is EMPTY)` form (EMPTY footgun handled correctly, matching the issue's own note); `none` → `is EMPTY`; `all:` → AND. This is S-606-1 / #606 per CLAUDE.md §8.4.
- **What #607 asks BEYOND that:** generalize the same `not:`/`all:`/`none`/repeat vocabulary across `--label`, `--status`, `--priority`, `--type`, and retrofit `not:`/repetition onto the existing single-valued `Option<T>` flags — plus surface the composed JQL under `--verbose`. Per the owner's own issue comment, this is a **subsystem-scale** retrofit (every `Option<T>` flag → an operator-carrying multi-value type + a new operator-emit layer in `src/jql.rs`), explicitly **deferred as a design epic** with #606 taken as the single-flag proof.
- **Aligns:** Yes. **Well-formed:** It is a design-level epic, not a single actionable unit — the collaborator and owner agree to split into per-flag implementation issues once a design pass lands. Treat as refinement/decomposition work, not a ready ticket.
- **Value:** MED-HIGH (removes frequent drops to raw `--jql`), realizable incrementally per-flag.
- **Effort:** L overall; each per-flag slice is S-M once the shared operator type + emit layer exist.
- **Coupling:** Parent of #609 (which needs the same JQL-aware, case-folded matching); pilot is #606/`--component`.

### #609 — `component impact`: scan filters/boards/dashboards before a rename
- **Status: NOT IMPLEMENTED.** No `Impact` variant on `ComponentSubcommand`; `src/cli/component.rs::handle_rename` (and `handle_rename_single_project` / `handle_rename_all_projects`, ~line 1210+) performs the PUT + cache invalidation only. The sole warning it emits is an unrelated issue-count-fetch failure notice (~line 210); there is **no** pre-flight scan of filters/boards/quick-filters/dashboards, and no reference/blast-radius check.
- **Aligns:** Yes — rename-safety for a footgun the codebase itself acknowledges (component names embedded as strings).
- **Well-formed:** Needs-refinement. The owner's validation comment already scoped it down: dashboards (no public REST for native-gadget JQL — JRACLOUD-98635) and automation rules (Automation API not reachable by OAuth apps) are **infeasible** for `jr`; feasible surface is **saved filters + board backing-filters + quick-filters**. Also requires a real JQL tokenizer (today `src/jql.rs` only escapes/validates/`strip_order_by` — no lexer) and rate-limit fan-out care.
- **Value:** MED (author: "would have caught the riskiest rename this week"), but only after scope-down.
- **Effort:** L. New subcommand + 3 REST scans (paginated, 429-prone) + a net-new JQL field-reference matcher + wiring as a `rename` pre-flight (`--force` to override).
- **Coupling:** Depends on #607's JQL-aware matching (shared tokenizer/case-fold); direct companion to the rename path added in S-608-1.

### #629 — Compensate for Jira Cloud search-index lag (read-after-write)
- **Status: NOT IMPLEMENTED.** `src/cli/issue/list.rs` supports `--updated-recent` (emits `updated >= -{d}` via `build_filter_clauses`) but has **no** empty-result recency hint and **no** retry flag. `src/api/jira/issues.rs` handles a *different* consistency problem — repeated-`nextPageToken` drift under live mutation (JRACLOUD-95368), with an anti-loop guard + `seen_keys` dedupe — which is unrelated to the create-then-search index lag described here (that is about zero results shortly after create, not pagination instability).
- **Aligns:** Yes, borderline — it asks `jr` to compensate for a server-side eventual-consistency property the issue itself concedes is "not a jira-cli bug." Suggestion 1 (hint) is a good-citizen UX fit; suggestion 2 (retry) is more speculative.
- **Well-formed:** Suggestion 1 is actionable (stderr note when `issue list --jql` returns empty AND the JQL contains a short recency filter — keeps stdout/JSON contract intact). Suggestion 2 (`--retry-empty <N[,delay]>`) needs design (detecting "recency filter present" reliably; empty-set-is-legitimately-empty false positives).
- **Value:** MED. Turns a silent-empty cascade into a self-explaining one; retry saves hand-rolled sleep loops in scripted dedup checks.
- **Effort:** S for the hint (substring-detect a recency clause + one `eprintln!`); M for the opt-in retry loop with backoff.
- **Coupling:** Weak with #789 (both modify `issue list` output/behavior; no logical dependency).

### #673 — `issue create --reporter <NAME|EMAIL>` (file on behalf of reporter)
- **Status: NOT IMPLEMENTED.** `src/cli/issue/create.rs` builds `fields` with `summary/description/issuetype/priority/components/labels/parent/assignee` — no `reporter` write. `--on-behalf-of` exists but is **JSM-only**: on the platform path it exits 64 pre-flight (`create.rs:125`, DEC-188/S-639-1). So there is no way to set the platform `reporter` field today except a follow-up `jr api` PUT (as the issue demonstrates). `--reporter` is a **distinct platform-path field**, not covered by `--on-behalf-of`.
- **Feasibility:** High. Platform `reporter` is settable at create time via `fields.reporter.accountId` (standard Jira Cloud, subject to project "Modify Reporter" permission / createmeta field availability — the issue's own working `jr api` PUT confirms it). The user-resolution machinery already exists — `helpers::resolve_assignee_by_project` (used by `--to`) resolves a name/email → accountId; `--reporter` can reuse it, with a `--reporter-account-id` bypass mirroring the existing `--account-id`. Setting reporter in the create body (vs. the issue's two-call create-then-PUT) also fixes the "wrong reporter until the PUT lands / no rollback" problem.
- **Aligns:** Yes — strongly. Service-desk filing on behalf of a reporter is a core Jira workflow.
- **Well-formed:** Yes. Clear AC: `--reporter <NAME|EMAIL>` (resolved) + `--reporter-account-id` (bypass) → `fields.reporter.accountId`. Companion ask (`issue edit --reporter`) noted as optional symmetry.
- **Value:** HIGH. Collapses a 3-step (create + user-search + PUT) flow to one call and removes a real correctness hazard (ticket briefly mis-attributed to the automation account).
- **Effort:** S-M. Two new args + reuse existing resolver + one `fields["reporter"]` write + createmeta-availability handling + echo/JSON plumbing. Optionally gate via createmeta to fail cleanly when the field isn't on the create screen.
- **Coupling:** Lineage with #639 (this is suggestion-1 of #639 split out) and the `--on-behalf-of` JSM path; independent to implement.

### #789 — `--fields` narrows the request but JSON still emits all 17 default keys as null
- **Status: CONFIRMED BUG, NOT FIXED.** Verified end-to-end:
  1. Request narrowing works: `src/cli/issue/list.rs` (~line 568-570) calls `client.search_issues_with_fields(&effective_jql, effective_limit, &field_refs)`, which sends the caller's `fields` verbatim (REPLACES `BASE_ISSUE_FIELDS`, per the method rustdoc at `src/api/jira/issues.rs:335`).
  2. Response over-serializes: results go straight to `output::print_output(output_format, &[], &[], &issues)` (list.rs ~line 575) → `render_json` over `Vec<Issue>`. `src/types/jira/issue.rs:57` `IssueFields` declares all 17 named fields as plain `Option<T>` **with no `#[serde(skip_serializing_if = "Option::is_none")]`** (only `components`/`fix_versions`/`labels` carry `#[serde(default)]`, which affects *de*serialization, not serialization). So every unrequested field serializes as `null`. The issue's reproduction and root-cause citation (issue.rs:57, issues.rs:16 `BASE_ISSUE_FIELDS`) are accurate.
- **Aligns:** Yes — output-contract correctness for a shipped flag.
- **Well-formed:** Yes — root-caused with 4 ranked fixes. Trade-off to adjudicate: option 1 (`skip_serializing_if` on every field) is simplest but also prunes genuinely-null keys from **default** (non-`--fields`) output — a behavior change for existing consumers (`resolution`/`duedate` are legitimately null on ordinary issues). Option 2 (prune only when `--fields` supplied, via a filtered map) preserves default output byte-for-byte at the cost of a second code path — the compatibility-safest choice given the repo's JSON-contract discipline.
- **Value:** HIGH — the flag currently cannot express "field absent vs. field empty," defeating a primary purpose of `--fields` for programmatic consumers.
- **Effort:** S-M depending on option (option 1 ~trivial but breaking; option 2 a small filtered-serialization path keyed on the requested list — recommended).
- **Coupling:** Related to #693 (same hardcoded `BASE_ISSUE_FIELDS` causing field loss in `queue view`) and the #575 `--fields` lineage; a shared decision on field-set handling would cover both.

---

## Cross-Cutting Observations

- **Two bulk-by-JQL asks (#586, #587)** share one missing capability: a reusable JQL→keys selection front-end for today-single-key `issue` subcommands. The `issue edit --jql` machinery (limit + ceiling + `conflicts_with` positional keys) is the template. Both also raise the same NDJSON-vs-pretty-array output question against invariant #526 — decide once.
- **#607 is the umbrella** the owner/collaborator already agreed to decompose; #609 quietly **depends** on it (both need JQL-aware, case-folded field-reference matching that `src/jql.rs` does not yet provide). Sequencing: land the shared JQL tokenizer once, then #607 per-flag slices and #609's filter/board/quick-filter scan can both consume it.
- **#673 and #789 are the two clear HIGH-value, well-formed, near-term items** — one a capability gap with an existing resolver to reuse, one a confirmed output-contract bug with a compatibility-safe fix already identified.
- **#583 is a clean, low-risk S** that removes a real downstream Python dependency.
- **#629 suggestion-1 (hint)** is the cheapest good-citizen win; **suggestion-2 (retry)** should be split into its own design ticket.
