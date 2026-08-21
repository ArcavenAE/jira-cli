# F1 Delta Analysis — Bundle: `list-read-ergonomics`

**Product**: `jr` Jira CLI (Rust, brownfield) · **Repo**: `/Users/zious/Documents/GITHUB/jira-cli`
**Checkout**: `develop @ 67c5a6d0` · **Intent**: `enhancement` (DX / read-path ergonomics, no behavioral bug)
**Feature type**: `backend` (CLI + API-client only; no UI/UX surface)
**Trivial scope?**: NO — 4 stories, new BCs, ≥2 files touched with moderate blast radius. Full F1→F7 routing, not quick-dev.

## Bundle

| # | Title | Priority | Blocks on |
|---|---|---|---|
| #575 | `--fields <CSV>` on `jr issue list` / `jr issue view` | P1 | — |
| #584 | Preserve raw ADF for `--fields comment` | P4 | #575 |
| #579 | `--updated-recent <duration>` on `jr issue list` | P2 | — |
| #588 | `--sort <field>:asc\|desc` shorthand on `jr issue list` | P5 | — |

---

## 1. Impact Boundary

### 1.1 Files touched, per issue

| File | #575 | #584 | #579 | #588 | Change type |
|---|:-:|:-:|:-:|:-:|---|
| `src/cli/mod.rs` (`IssueCommand::List`, `IssueCommand::View`) | ✅ | — | ✅ | ✅ | MODIFIED — new flags on two arg structs |
| `src/cli/issue/list.rs` (~1256 LOC — `handle_list`, `build_filter_clauses`, `FilterOptions`, `build_jql_base_parts`) | ✅ | — | ✅ | ✅ | MODIFIED — three independent edits to the same hot file |
| `src/cli/issue/view.rs` (`handle_view`) | ✅ | (confirmatory only) | — | — | MODIFIED — new flag wiring + output-format gate |
| `src/api/jira/issues.rs` (`get_issue`, `search_issues`) | ✅ | — | — | — | MODIFIED — additive: new client methods, no signature break |
| `src/jql.rs` | — | — | (reuse `validate_duration`, no change) | (new: `parse_sort_spec` or similar) | MODIFIED (588 only) |
| `tests/all_flag_behavior.rs`, `tests/issue_commands.rs`, `tests/issue_list_errors.rs`, `tests/issue_view_errors.rs`, `tests/cli_smoke.rs` | ✅ | ✅ (new fixture) | ✅ | ✅ | test-only additions |
| `.factory/specs/prd/bc-2-issue-read.md` | ✅ | ✅ | ✅ | ✅ | F2 scope, not this phase — flagged here for the F2 handoff |

**Not touched by this bundle** (regression baseline — safe to assume unaffected):
`src/cli/issue/format.rs` (row formatting — `--fields` is JSON-only, see Design Decision #1, so no column-rendering code changes), `src/cli/issue/json_output.rs` (that file only holds hand-built `serde_json::json!` response shapes for *write* commands — `issue list`/`issue view` JSON already flows through `output::print_output`/`render_json(&issue)` directly, untouched by this bundle), `src/adf.rs` (no new ADF logic needed — see Design Decision #2), `src/duration.rs` (NOT the parser `--recent`/`--updated-recent` actually use — see correction below), `src/output.rs`, `src/cli/issue/comments.rs`, `src/cli/issue/interactions.rs`, `src/cli/issue/attachments.rs`, `src/cli/board.rs`, `src/cli/queue.rs`, `src/cli/sprint.rs`, `src/cli/component.rs` (all other `get_issue`/`search_issues` callers — see §1.3, these get new *sibling* methods, not signature changes, so they compile and behave identically).

**Correction to the task brief**: `src/duration.rs::parse_duration_validate` is a *different* parser (worklog durations: `1h30m`, `2d 3h 30m`, space-separated, multi-unit). The parser `--recent` actually uses is `src/jql.rs::validate_duration` — single `<digits><unit>` token, no combined units, case-sensitive `M`=months/`m`=minutes (`src/jql.rs:16-34`, cited by BC-2.1.008). `--updated-recent` must reuse `jql::validate_duration`, not `duration.rs`.

### 1.2 Blast radius / regression risk

| Area | Risk | Why |
|---|---|---|
| `build_filter_clauses` / `FilterOptions` (`list.rs:915-976`) | **MEDIUM** | Three of four stories (#575 doesn't touch this, #579/#588 do) add fields to the same struct and the same ordered-`Vec<String>` builder that 20+ existing unit tests (`build_jql_parts_*`) pin via **positional** equality (not membership) — BC-2.1.007's "stable order" contract. A careless insertion point shifts every downstream clause's index and could silently pass a test that only checks JQL *substring* presence while breaking one that checks exact clause order. |
| `order_by` variable across the 4 composition branches (`list.rs:301-371`) | **MEDIUM** | `--sort` (#588) is the only issue touching this. All 4 existing branches (`--jql`, scrum-active-sprint, kanban, default-project) currently return one of 3 hardcoded literals (`"updated DESC"`, `"rank ASC"` ×2) pinned by BC-2.1.002/003/004/005 as **exact composed JQL strings** in both unit tests and `tests/all_flag_behavior.rs`. `--sort` must NOT touch the default (absent-flag) value in any branch — it only overrides when the flag is present — to keep those 4 BCs' pinned literals unchanged when `--sort` is omitted. |
| `get_issue` / `search_issues` signatures (`api/jira/issues.rs:191`, `:464`) | **LOW, if additive** | 10 non-list/view call sites depend on the current signatures (`edit.rs` ×2, `links.rs`, `create.rs`, `assets.rs`, `workflow.rs` ×3, `board.rs`, `queue.rs`). Recommend **new sibling methods** (`get_issue_with_fields`, `search_issues_with_fields` or equivalent), not signature changes — keeps blast radius scoped to `list.rs`/`view.rs` only, zero risk to the other 10 sites. If the implementer instead widens the existing signature (e.g., `Option<&[&str]>`), blast radius becomes **MEDIUM** (10 call sites need a mechanical `None`/`&[]` update, compiler-enforced but touches files this bundle has no other reason to open). |
| `IssueFields` struct / `#[serde(flatten)] extra` (`types/jira/issue.rs`) | **LOW** | No struct change needed for #575/#584 (see Design Decisions #1/#2) — `extra: HashMap<String, Value>` already exists and already flattens unnamed fields (including a hypothetical `comment` or `customfield_*`) into top-level JSON untouched. This is a **zero-new-field** delta, which is the main reason this bundle's core risk is lower than it might first appear. |
| `--component` filter machinery (BC-2.1.018-022, landed 2026-08-15/17) | **LOW, adjacency only** | Not touched by this bundle, but shares the exact same `build_filter_clauses`/`FilterOptions` file region that #579/#588 modify. Recent (last week) churn in this region raises the chance of a rebase conflict if this bundle's stories are worked in parallel worktrees — see §4. |
| `BC-2.1.006`'s pinned 14-source stderr enumeration | **LOW, textual** | #579 adds `--updated-recent` as filter source #15 — mechanical string-literal update, same shape as the 2026-08-15 `--component` addition (13→14). `--sort` is **not** a filter source (it doesn't restrict the result set) and must **not** be added to this list — a plausible implementer mistake worth flagging explicitly. |

### 1.3 `get_issue`/`search_issues` existing call-site census (for the additive-methods argument)

```
get_issue:      edit.rs (×2), links.rs, create.rs, assets.rs, workflow.rs (×3), view.rs   → 8 call sites outside this bundle's direct scope + view.rs (in scope)
search_issues:  board.rs, queue.rs, list.rs                                                → 2 call sites outside scope + list.rs (in scope)
search_issue_keys: component.rs, edit.rs                                                   → untouched by this bundle (keys-only search, no `fields=` concept applies)
```

---

## 2. Proposed Story Breakdown

### Story S-1 — `--fields <CSV>` on `issue list` / `issue view` (#575)

**Scope**: Add a `--fields <CSV>` flag to both `IssueCommand::List` and `IssueCommand::View`. When present, it **replaces** the field set requested from Jira's `fields=` parameter (bypassing `BASE_ISSUE_FIELDS` and the config-driven extras from `--points`/`--assets`/`--duedate`/team). Requires `--output json`; table mode + `--fields` exits 64 (see Design Decision #1).

**Acceptance criteria (sketch)**:
1. `jr issue list --jql "..." --fields "summary,status,comment" --output json` requests exactly `fields=summary,status,comment` (no `BASE_ISSUE_FIELDS` union) and returns the typed `Issue`/`IssueFields` JSON shape — named fields not covered by the request deserialize/serialize as `null`; unnamed fields (`comment`, `customfield_NNNNN`, `attachment`) flow through `extra` verbatim.
2. `jr issue view <KEY> --fields "summary,comment" --output json` — same semantics via a new `get_issue_with_fields`-style client method.
3. `jr issue list --fields "..."` **without** `--output json` (table mode, default or `--output table`) → exit 64, stderr states `--fields requires --output json`.
4. `--fields ""` (empty string) and `--fields ","` (empty segments) → exit 64, pre-HTTP validation (mirrors BC-2.1.008/009's "validate before any network call" discipline).
5. `--fields` present + `--points`/`--assets`/`--duedate` also present → those three flags' extra-field injection becomes a no-op (silent, since they are column-rendering flags and table mode is already blocked); no error.
6. `key` is always present in output regardless of whether `key` appears in `--fields` (Jira always returns it top-level — `IssueKeyRow`'s doc comment already documents this Jira guarantee elsewhere; no new code needed, just confirm via test).
7. Whitespace-trimming on each CSV segment (`--fields "summary, status"` behaves identically to `"summary,status"`).

**Files changed**: `src/cli/mod.rs` (List + View structs), `src/cli/issue/list.rs` (`handle_list` wiring, output-format gate, pre-HTTP CSV validation), `src/cli/issue/view.rs` (`handle_view` wiring, same gate), `src/api/jira/issues.rs` (new `get_issue_with_fields`/`search_issues_with_fields`-shaped methods, or equivalent — additive, see §1.2).

**New/changed BCs**: BC-2.2.033 (new — `--fields` on list), BC-2.3.041 (new — `--fields` on view), BC-2.6.052 (new — client-layer field-override plumbing). No amendment needed to BC-2.2.028/BC-2.3.036 (those contract the *default* `BASE_ISSUE_FIELDS` path, which is unchanged and still the default when `--fields` is absent).

---

### Story S-2 — Raw ADF preservation for `--fields comment` (#584)

**Blocks on**: S-1 (needs `--fields` to exist to even reach `comment` field, and needs S-1's implementation choice — REPLACE vs UNION on the request — settled first).

**Scope**: **Confirmatory, not implementation-heavy.** Because `IssueFields.extra: HashMap<String, Value>` is `#[serde(flatten)]` (`src/types/jira/issue.rs:76-78`) and no code path calls `adf::adf_to_text` on `issue list`/`issue view`'s JSON output (confirmed — the only 4 call sites of `adf_to_text` are `comments.rs`, `interactions.rs`, and `view.rs`'s **table**-mode description row, none of which touch `extra`), requesting `comment` via S-1's `--fields` mechanism already returns Jira's raw `fields.comment.comments[].body` ADF object untouched. This story's real work is:
1. A wiremock fixture + integration test proving `--fields comment --output json` on both `list` and `view` returns `.fields.comment.comments[].body` as `{"type":"doc",...}` byte-for-byte, not a string.
2. A negative test proving the existing `issue comments <KEY>` command (which DOES flatten via `adf_to_text`, `comments.rs:33,48`) is unaffected — the two code paths must stay independent.
3. A defensive review note / code comment at the `--fields` wiring site in S-1 warning future maintainers not to "helpfully" post-process `extra` for consistency with `issue comments`.

**Files changed**: `tests/` only (new fixture, 2 new tests). **No `src/` changes anticipated** unless S-1's implementation turns out to need a `extra`-cleanup pass for some other field (unlikely — see Design Decision #2).

**New/changed BCs**: BC-2.2.034 (new — `--fields comment` raw-ADF passthrough, list), BC-2.3.042 (new — same, view). Both cite BC-2.2.033/BC-2.3.041 (S-1) as the mechanism and the `extra` flatten field as the reason zero incremental code is needed.

---

### Story S-3 — `--updated-recent <duration>` (#579)

**Scope**: Mirror `--recent` (BC-2.1.008) exactly, but filter on `updated` instead of `created`. Reuses `jql::validate_duration` (not `duration.rs` — see §1.1 correction). `--resolved-recent` is **recommended deferred** — see Design Decision #3.

**Acceptance criteria (sketch)**:
1. `jr issue list --updated-recent 60d` → clause `updated >= -60d`, composed at the same relative position `--recent` occupies today (immediately after `--recent`'s slot in `build_filter_clauses`, i.e. between `team` and `asset`).
2. `--updated-recent` validated via `jql::validate_duration` before any HTTP call (pre-flight, same discipline as BC-2.1.008/009).
3. `--updated-recent` + `--updated-after` → clap `conflicts_with` (mirrors the existing asymmetric `--recent`×`--created-after` pattern exactly — see Design Decision #3 for why only the `-after` half is blocked, matching the pre-existing inconsistency rather than silently fixing it).
4. `--updated-recent` composes freely (AND) with `--recent`, `--created-after/before`, `--status`, `--component`, etc. — no new conflicts beyond #3.
5. BC-2.1.006's exit-64 "no filters" stderr enumeration gains `--updated-recent` as filter source #15 (14→15, mechanical, same shape as the 2026-08-15 `--component` addition).

**Files changed**: `src/cli/mod.rs` (new `updated_recent: Option<String>` field + `conflicts_with`), `src/cli/issue/list.rs` (validation, `FilterOptions` field, `build_filter_clauses` insertion, BC-2.1.006 stderr string update).

**New/changed BCs**: BC-2.1.023 (new — `--updated-recent` clause + validation), BC-2.1.006 AMENDED (14→15 sources), BC-2.1.007 AMENDED (stable-order list gains `updated-recent` between `recent` and `asset`).

---

### Story S-4 — `--sort <field>:asc|desc` shorthand (#588)

**Scope**: New `--sort <field>:<direction>` flag on `issue list`. Overrides the `order_by` value computed in all 4 composition branches (`--jql`, scrum-active-sprint, kanban, default-project) when present; absent-flag behavior is byte-for-byte unchanged in every branch (protects BC-2.1.002/003/004/005's pinned literals). Appends `, key ASC` as a proactive stable secondary sort (turning the existing JRACLOUD-95368 advisory stderr recommendation into default behavior for this new opt-in path — see Design Decision #4), except when the requested field IS `key` (avoids a redundant/self-conflicting `key DESC, key ASC`).

**Acceptance criteria (sketch)**:
1. `--sort updated:desc` → `order_by = "updated DESC, key ASC"`.
2. `--sort key:asc` → `order_by = "key ASC"` (no redundant secondary clause).
3. Direction token is case-insensitive (`asc`/`ASC`/`Asc` all accepted); anything else → exit 64 pre-HTTP.
4. Missing `:` separator, or empty field/direction segment → exit 64 pre-HTTP, `Invalid --sort "<value>". Use <field>:asc or <field>:desc (e.g., updated:desc).`
5. Field name is **passed through to Jira unvalidated** (no local allowlist — see Design Decision #4); an unsortable/unknown field surfaces Jira's own 400 `JrError::ApiError` (exit 1), matching the existing trust posture of `--jql`'s free-form WHERE clause.
6. `--sort` composes with `--jql` (overrides the otherwise-hardcoded `"updated DESC"` even when `--jql` supplies its own now-discarded `ORDER BY`) and with board-driven branches (scrum/kanban) — explicit override wins in every branch, no silent exception (flagged as an open question in §5 in case the human prefers board branches to stay rank-locked).
7. `--sort` is NOT added to BC-2.1.006's filter-source enumeration (it doesn't restrict results).

**Files changed**: `src/cli/mod.rs` (new `sort: Option<String>` field), `src/cli/issue/list.rs` (parse/validate helper, `order_by` override applied after the existing 4-branch `match`/`if` block, before `all_parts.join`).

**New/changed BCs**: BC-2.1.024 (new — `--sort` parse/validate), BC-2.1.025 (new — `--sort` overrides `order_by` in all 4 branches + `key ASC` secondary-sort + JRACLOUD-95368 cross-reference). No amendment to BC-2.1.002/003/004/005 themselves (their pinned literals describe the **absent-`--sort`** case, unchanged).

---

## 3. New/Changed Behavioral Contracts (proposed IDs)

| BC ID | Statement | Status |
|---|---|---|
| BC-2.2.033 | `issue list --fields <CSV>` replaces the requested `fields=` set; requires `--output json` (exit 64 otherwise); pre-HTTP CSV validation | NEW |
| BC-2.3.041 | `issue view --fields <CSV>` — same semantics as BC-2.2.033, via a new `get_issue`-family client method | NEW |
| BC-2.6.052 | `JiraClient` gains field-override client methods (additive; existing `get_issue`/`search_issues` signatures and their 10 other call sites unchanged) | NEW |
| BC-2.2.034 | `issue list --fields comment --output json` returns `.fields.comment.comments[].body` as raw ADF via the pre-existing `extra` flatten — zero incremental transformation code | NEW |
| BC-2.3.042 | `issue view --fields comment --output json` — same, via `IssueFields.extra` | NEW |
| BC-2.1.023 | `--updated-recent <duration>` → `updated >= -{d}` clause, validated via `jql::validate_duration`, positioned after `--recent`'s slot | NEW |
| BC-2.1.006 | AMENDED: filter-source enumeration 14 → 15 (`--updated-recent` added) | AMENDED |
| BC-2.1.007 | AMENDED: stable clause order gains `updated-recent` (between `recent` and `asset`) | AMENDED |
| BC-2.1.024 | `--sort <field>:<dir>` parse/validate: case-insensitive direction, exit 64 on malformed input, pre-HTTP | NEW |
| BC-2.1.025 | `--sort` overrides `order_by` in all 4 composition branches when present; appends `, key ASC` secondary stable sort unless field is `key`; field name passed through to Jira unvalidated | NEW |

*(All BC numbers are the next-available slot per subdomain as of `bc-2-issue-read.md`'s current state — 2.1 through .022, 2.2 through .032, 2.3 through .040, 2.6 through .051 — confirmed by direct grep of the file's `#### BC-2.` headings. F2 must re-verify against the file's live state at F2 time in case another bundle lands first, and must update `total_bcs`/`definitional_count` frontmatter + `CANONICAL-COUNTS.md` per `scripts/check-bc-cumulative-counts.sh`.)*

---

## 4. Dependency / Wave Order

```
Wave 1 (parallel-eligible in principle, same-file caution — see note below):
  S-1 (#575)  ─┐
  S-3 (#579)   ├─ independent of each other
  S-4 (#588)  ─┘

Wave 2 (hard dependency):
  S-2 (#584)  ← requires S-1 merged (needs --fields to exist; needs S-1's
                REPLACE-vs-UNION request semantics settled, since that
                determines whether `comment` even reaches the wire)
```

**Sequencing caution (not a hard dependency, a delivery-process note)**: S-1, S-3, and S-4 are semantically independent but all three edit `src/cli/mod.rs`'s `IssueCommand::List` variant and/or `src/cli/issue/list.rs`'s `build_filter_clauses`/`FilterOptions`/`order_by` region — the same ~250-line hot zone that also saw the `--component` bundle land 2026-08-15/17 (per `bc-2-issue-read.md`'s trace log). Recommend delivering Wave 1's three stories **sequentially** (one worktree at a time, S-1 → S-3 → S-4 or any order) rather than in parallel worktrees, to avoid a 3-way merge conflict on the same struct/function — even though there is no *logical* ordering requirement among them. If the human prefers true parallelism, at minimum S-3 and S-4 (both touch `build_filter_clauses`/`order_by` directly) should not run concurrently; S-1 touches a disjoint region of `list.rs` (the field-list/output-gate logic near the `search_issues` call, not `build_filter_clauses`) and is the safest to parallelize against the other two.

---

## 5. Design Decisions

### Decision 1 — `#575`: `--fields` is JSON-only and REPLACES the requested field set

**Resolution**: `--fields <CSV>` requires `--output json` (exit 64 in table mode). When present, it fully replaces `BASE_ISSUE_FIELDS` plus any config-driven extras (`--points`'s `customfield_NNNNN`, `--assets`'s CMDB field IDs, team field id) in the Jira `fields=` request — it does **not** union with them. `--points`/`--assets`/`--duedate` become no-ops when `--fields` is set (they're column-rendering flags; table mode is already blocked).

**Why REPLACE, not UNION**: The issue's own workaround command is instructive —
```
jr api ".../search/jql?jql=...&fields=summary,status,assignee,updated,attachment,customfield_10084,...,comment&maxResults=200"
```
The user builds the *entire* `fields=` list themselves, including base fields like `summary`/`status`/`updated` they'd get for free from `BASE_ISSUE_FIELDS`. That's a strong signal they expect full control, not an additive union — and the issue body says explicitly "Pass-through to the underlying `?fields=` param. **No interpretation.**" A union interpretation would technically still work for their stated use case (comment/customfield inclusion) but silently diverges from the literal ask and keeps 17 fields on the wire the user didn't request, defeating part of the wire-cost motivation.

**Why JSON-only**: Table mode's fixed columns (`Key, Type, Status, Priority, [Due Date], [Points], Assignee, [Team], [Assets], Summary`, per BC-2.2.032's column-position clause) read from named `IssueFields` struct fields that a REPLACE-semantics `--fields` could omit from the request, silently blanking columns the user didn't think to ask for. Rather than partially-interpreting `--fields` for table mode (contradicting "no interpretation") or maintaining two different semantics per output mode, the cleanest cut is: `--fields` is a JSON-output feature only, matching both of #575's own examples (`--output json` in both).

**JSON shape**: `render_json(&issue)`/`render_json(&issues)` (`src/output.rs:20-22`) stays typed-struct serialization — **no change to the output-shaping mechanism**. Named `IssueFields` fields not covered by a REPLACE `--fields` request will simply come back `None` from Jira (serde's built-in "missing key → `None`" behavior for `Option<T>` fields, no `#[serde(default)]` needed) and serialize as JSON `null` (no `#[serde(skip_serializing_if)]` on any of them today, confirmed by BC-2.3.039's existing analysis of this exact mechanism for `duedate`). This means the literal issue text "returns exactly the requested fields" is satisfied at the **wire/request** level (less data pulled from Jira, the actual cost the issue cares about — eliminating ~200 REST calls) but not at the **output-shape** level (`null` placeholders for unrequested named fields remain visible) — a deliberate, lower-risk trade documented as Open Question #1 below in case the human wants literal field-set-only output instead.

**Code citations**: `src/types/jira/issue.rs:76-78` (`#[serde(flatten)] extra`), `src/api/jira/issues.rs:201-202` (`BASE_ISSUE_FIELDS.to_vec(); fields.extend_from_slice(extra_fields)` — the union point that REPLACE must bypass), `src/output.rs:20-22` (`render_json`), `bc-2-issue-read.md` BC-2.3.039 (established precedent: JSON is typed-struct serialization, "not raw passthrough").

---

### Decision 2 — `#584`: raw ADF for `--fields comment` requires (almost) zero new code

**Resolution**: `comment` is not a named field on `IssueFields` — it has no dedicated struct field, so it lands in `extra: HashMap<String, Value>` (`#[serde(flatten)]`), which is untyped `serde_json::Value`. Once S-1's `--fields` mechanism requests `comment` from Jira, the response's `fields.comment.comments[].body` (already raw ADF on the wire — Jira never flattens it server-side) flows straight through `render_json` untouched. Confirmed empirically: the only 4 call sites of `adf::adf_to_text` in the whole codebase are `src/cli/issue/comments.rs:33,48` (the dedicated `issue comments <KEY>` command), `src/cli/issue/interactions.rs:658` (single-comment view/add/edit), and `src/cli/issue/view.rs:87` (table-mode **description** row only) — none of these run on the `issue list`/`issue view --output json` code path. This is confirmed JSON-only per Decision 1 (table mode has no `comment` concept at all — there is no comment column and none is proposed).

**Code citations**: `src/types/jira/issue.rs:76-78`, the 4 `adf_to_text` call sites above (`src/cli/issue/comments.rs`, `src/cli/issue/interactions.rs`, `src/cli/issue/view.rs:87`), confirming none touch `extra`.

---

### Decision 3 — `#579`: reuse `jql::validate_duration`; defer `--resolved-recent`

**Resolution**: `--updated-recent` reuses `src/jql.rs::validate_duration` (the same validator `--recent` uses — BC-2.1.008), **not** `src/duration.rs` (that's the worklog-duration parser, a different grammar — see §1.1 correction to the task brief). Clause shape mirrors `--recent` exactly: `updated >= -{d}` (BC-2.1.008's `created >= -{d}` with the field swapped).

`--resolved-recent` (RESOLUTIONDATE field): **recommend deferring** to a follow-up issue, not included in this bundle. Rationale: (1) the GH issue itself frames it as "consider," not a stated requirement — it's explicitly softer than the primary ask; (2) `resolutiondate` has different NULL semantics than `created`/`updated` (unresolved issues have `resolutiondate = null`; a naive `resolutiondate >= -{d}` clause silently excludes all open issues, which may or may not be the closure-hygiene author's intent — this needs its own design conversation about whether unresolved issues should be included/excluded/warned-about, not a mechanical copy of the `--recent` pattern); (3) keeping this bundle to exactly the 4 named issues keeps the F1→F7 pipeline's scope boundary clean and matches VSDD's per-issue traceability discipline.

**Conflict rule**: `--updated-recent` gets `conflicts_with = "updated_after"` only, mirroring the existing **asymmetric** pattern where `--recent` conflicts with `--created-after` but not `--created-before` (`src/cli/mod.rs:351` has `conflicts_with = "recent"` on `created_after`; `created_before` has no such attribute). This is a pre-existing inconsistency in the codebase, not something this bundle should silently "fix" as a side effect — flagged as Open Question #2.

**Code citations**: `src/jql.rs:16-34` (`validate_duration`), `src/cli/issue/list.rs:952-954` (`--recent`'s clause-building line, the direct template), `src/cli/mod.rs:325-361` (existing `recent`/`created_after`/`created_before`/`updated_after`/`updated_before` flags and their asymmetric `conflicts_with`).

---

### Decision 4 — `#588`: `--sort` overrides `order_by` in all branches; pass-through field validation; opportunistic `key ASC`

**Resolution**:
- **Composition with JRACLOUD-95368's `key ASC` guard**: The guard today is **purely advisory** — a stderr warning fired only on a repeated-cursor-token abort (`src/api/jira/issues.rs:277-303`), recommending the user append `, key ASC` themselves. `jr` does **not** currently append it proactively anywhere. Since `--sort` is a brand-new, fully opt-in code path (zero effect when absent, preserving BC-2.1.002/003/004/005's pinned default literals), it is the right place to turn the advisory recommendation into default behavior: `--sort <field>:<dir>` composes `order_by = "<field> <DIR>, key ASC"`, except when the requested field is `key` itself (case-insensitive match), where the plain `"<field> <DIR>"` is used (a redundant `key DESC, key ASC` would be nonsensical and is not what the pagination guard is protecting against once the primary sort already IS key-based). This is a strict readability/stability improvement scoped entirely to the new flag — the existing default `order_by` values (`"updated DESC"` etc.) are **not** touched, so the recommendation is not retroactively applied to `--sort`-absent invocations (that would require reopening BC-2.1.002/003/004/005's pinned test literals and is out of scope for this bundle — flagged as Open Question #3 in case the human wants it done everywhere, not just opt-in).
- **Allowlist vs pass-through**: **Pass-through, no allowlist.** JQL's set of orderable fields is Jira-instance-dependent (custom fields can be orderable; system-field orderability has changed across Jira Cloud versions), so a hardcoded allowlist would either wrongly reject valid instance-specific fields or wrongly accept fields that turn out not to be orderable — Jira's own 400 response is the only reliable source of truth. This mirrors the exact trust posture jr already extends to `--jql`'s free-form WHERE clause (BC-2.1.002 — no local field validation, Jira's response is authoritative) and to `--status`'s only-partially-local validation (which *does* pre-fetch via `get_project_statuses`/`get_all_statuses`, but that's because Jira exposes a first-class statuses-list endpoint — there is no equivalent "orderable fields" discovery endpoint to pre-validate against). Local validation is limited to **syntax**: `field:direction` split, direction case-insensitively `asc`/`desc`, non-empty segments — all pre-HTTP, exit 64 on failure (matching BC-2.1.008/009's discipline). An unsortable/unknown field name surfaces as `JrError::ApiError{status:400,...}` (exit 1) from Jira's own validation, propagated through the existing generic HTTP-error path (`src/api/client.rs`).
- **Precedence vs `--jql`**: `--jql`'s embedded `ORDER BY` is already unconditionally stripped and replaced today (BC-2.1.002 — "user's `ORDER BY rank ASC` is silently replaced"). `--sort`, when present, becomes the new replacement value in place of the hardcoded `"updated DESC"` — this is a strict improvement (the silent-replacement behavior BC-2.1.002 already documents as a wart now has an escape hatch) with zero behavior change when `--sort` is absent.
- **Precedence vs board branches (scrum-active-sprint, kanban)**: **`--sort`, when given, always wins** — applied uniformly across all 4 branches, no board-specific exception. Rationale: predictability (one mental model: "the flag always wins when present") over the alternative (silently ignoring `--sort` on board-scoped invocations, which would be a confusing, undocumented exception a user has no way to discover except by reading source). This is the one sub-decision most likely to warrant human pushback — flagged explicitly as Open Question #4, since overriding rank-order on a board view arguably defeats part of the reason `board_id` scoping exists.
- **Not a filter source**: `--sort` must not be added to BC-2.1.006's "no filters specified" stderr enumeration — it doesn't restrict the result set, only its order, and adding it there would be a plausible but incorrect implementation choice worth flagging in the story's acceptance criteria explicitly.

**Code citations**: `src/api/jira/issues.rs:277-303` (advisory-only JRACLOUD-95368 warning, confirming nothing proactively appends `key ASC` today), `src/cli/issue/list.rs:301-371` (the 4-branch `order_by`-producing match/if block), `src/cli/issue/list.rs:387-388` (`effective_jql = format!("{where_clause} ORDER BY {order_by}")` — the single composition point `--sort` must feed into), `bc-2-issue-read.md` BC-2.1.002/003/004/005 (the 4 branches' pinned default literals that must stay unchanged when `--sort` is absent), `src/api/client.rs` (generic 4xx→`ApiError` mapping for Jira's own field-validity rejection).

---

## 6. Open Questions for the Human

1. **(#575, Decision 1)** Is "wire-level field reduction + typed-struct output with `null` placeholders for unrequested named fields" an acceptable interpretation of "return exactly the requested fields," or does the human want a literal field-set-only JSON shape (would require bypassing `render_json(&issue)`'s typed serialization for the `--fields` path specifically — materially larger/riskier implementation, effectively a second JSON output mode)?
2. **(#579, Decision 3)** Should `--updated-recent`'s `conflicts_with` also cover `--updated-before` (fixing the pre-existing `--recent`/`--created-before` asymmetry at the same time), or should it deliberately mirror the existing inconsistent pattern to avoid an unrelated behavior change riding along in this bundle?
3. **(#588, Decision 4)** Should the `, key ASC` secondary-sort improvement be scoped only to `--sort`-present invocations (this plan's recommendation, zero risk to existing pinned defaults), or should the human want it eventually applied to the default `order_by` values too (a separate, larger, BC-2.1.002/003/004/005-touching follow-up, explicitly out of scope here)?
4. **(#588, Decision 4)** Should `--sort` override board-driven `rank ASC` ordering on scrum-active-sprint/kanban branches, or should those two branches be excluded from `--sort`'s effect (silently ignoring the flag, or exiting 64 with a clear "cannot combine --sort with a board-scoped project" message)? This plan recommends "always wins" for predictability but flags it as the most debatable sub-decision in the bundle.
5. **`--resolved-recent`**: confirmed deferred per Decision 3 — is that acceptable, or does the human want it pulled into this bundle as a 5th story (adds ~2-3 points and a NULL-semantics design conversation)?
6. **Sequencing**: does the human want Wave 1's three stories (S-1/S-3/S-4) delivered strictly sequentially (this plan's recommendation, given all three touch the same `list.rs` hot region) or is parallel-worktree delivery with a planned merge-conflict-resolution step acceptable to save wall-clock time?

---

## 7. Rough Sizing

| Story | Points | Rationale |
|---|---:|---|
| S-1 — `--fields` on list/view (#575) | 8 | Central plumbing change (new client methods, two CLI arg structs, two handler wiring sites, output-format gate, pre-HTTP CSV validation); moderate-risk shared-file edits; needs both positive and negative (table-mode-rejection) test coverage on two commands |
| S-2 — raw ADF confirmation (#584) | 2 | Mostly test-only; depends on S-1 landing first; low implementation risk given Decision 2's zero-new-code finding |
| S-3 — `--updated-recent` (#579) | 3 | Small, mechanical mirror of an existing, well-tested pattern (`--recent`); one new clap flag, one new clause, one stderr-string update |
| S-4 — `--sort` shorthand (#588) | 5 | Touches all 4 `order_by`-producing branches; new parse/validate helper; secondary-sort interaction logic; moderate test surface (asc/desc × 4 branches × malformed-input cases) |
| **Total** | **18** | — |

*(`--resolved-recent`, if the human pulls it into scope per Open Question #5, adds an estimated +2-3 points on top of the above.)*
