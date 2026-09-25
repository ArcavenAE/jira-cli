# Technical-Debt Assessment — crate `jr` (Jira CLI)

**Date:** 2026-09-24
**Branch:** `develop`
**Scope:** READ-ONLY. Rust best-practices non-compliance + structural debt the linter *cannot* see.
**Method:** Whole-tree LOC + production-vs-test split, function-span analysis, panic-site audit, duplication/coupling grep, cross-check against `CLAUDE.md` "Known Size Deviations" and ADR-0012.
**Grounding re-measured:** 116 `src/*.rs` files, 80,283 total LOC. A separate `clippy --pedantic --nursery` run is merged elsewhere — this report deliberately targets what clippy misses.

> **Headline correction (affects every downstream reading of "20 files > 1000 LOC"):** Raw file LOC badly overstates production debt because most large files carry large *inline* `#[cfg(test)]` suites. When measured on **production code only** (lines before the first `#[cfg(test)]` block), the set of files genuinely over 1,000 *production* LOC shrinks from 20 to **12**, and only **2** of those are undocumented. See TD-07/TD-08. The real, actionable debt is concentrated in a handful of **god-functions**, not in file counts.

---

## Top 10 Highest-Value Items

| ID | Title | Sev | Effort | Genuine vs Documented |
|----|-------|-----|--------|-----------------------|
| TD-01 | `edit.rs::handle_edit` is a 1,314-LOC single function | HIGH | L | Genuine (file size documented; *function* size is not) |
| TD-02 | `list.rs::handle_list` is a 775-LOC single function | HIGH | M | Genuine (file documented; function not) |
| TD-03 | `client.rs::send_inner` — 414-LOC retry/refresh/rate-limit state machine in one fn | MEDIUM | M | Genuine, undocumented |
| TD-04 | `api/client.rs` (1,562 prod LOC) undocumented oversize; redaction cluster is a clean split seam | MEDIUM | M | Genuine, undocumented drift |
| TD-05 | `api/jira/issues.rs` (1,297 prod LOC) undocumented oversize; search + comments seams | MEDIUM | M | Genuine, undocumented drift |
| TD-06 | Disambiguation logic duplicated (teams/users/labels + 11 call sites) | MEDIUM | M | Genuine |
| TD-09 | `ProfileConfig.auth_method`/`oauth_scopes` stringly-typed (should be enum / `Vec<Scope>`) | MEDIUM | S | Genuine |
| TD-07 | `CLAUDE.md` size deviations measure *total* LOC incl. tests → over-flags 4 files whose prod code is < 1,000 | MEDIUM | S | Doc-accuracy defect |
| TD-16 | `clippy::cast_possible_truncation` ×~21 — potential silent-truncation `as` casts, needs scoped classification | MEDIUM | S-M | Genuine (clippy-sourced) |
| TD-10 | Untyped `serde_json::Value` field API in `api/jira` + 143 `Value` refs in `cli/` | LOW-MED | M | Genuine (partly inherent to Jira) |
| TD-13 | Secondary long handlers (7 functions, 238–494 LOC) | LOW-MED | M | Genuine |

**Findings by severity:** HIGH ×2 · MEDIUM ×8 · LOW ×7 → **17 findings total** (incl. clippy synthesis TD-16/TD-17 appended below).
Dimensions where the code is **clean** (stated honestly, not padded): error-handling discipline (TD-14), pure-core purity (TD-11 context), unsafe usage, lint-suppression hygiene.

---

## Dimension 1 — Oversized-File Cohesion

**Production-only LOC for every file whose *total* LOC > 1,000** (prod = lines before first `#[cfg(test)]`):

| File | Total | Prod | Test | > 1k prod? | CLAUDE.md status |
|------|------:|-----:|-----:|:--:|---|
| `adf.rs` | 14,617 | 3,792 | 10,825 | yes | Documented ADR-0012 exception ✅ still valid |
| `api/auth.rs` | 6,199 | 2,331 | 3,868 | yes | Documented ADR-0012 exception ✅ |
| `api/client.rs` | 3,681 | **1,562** | 2,119 | **yes** | **UNDOCUMENTED (TD-04)** |
| `cli/issue/attachments.rs` | 3,467 | 2,426 | 1,041 | yes | Documented ✅ |
| `cli/issue/edit.rs` | 3,287 | 2,511 | 776 | yes | Documented ✅ |
| `cache.rs` | 2,770 | **879** | 1,891 | no | grounding mislabeled — see TD-08 |
| `cli/auth/tests/mod.rs` | 2,570 | 2,570 | (all test) | n/a | Documented (test file) ✅ |
| `cli/issue/field_resolve.rs` | 2,267 | 1,531 | 736 | yes | Documented ✅ |
| `config.rs` | 2,244 | **556** | 1,688 | no | grounding mislabeled — TD-08 |
| `cli/issue/list.rs` | 2,057 | 1,239 | 818 | yes | Documented ✅ |
| `api/auth_windows_store.rs` | 1,996 | **798** | 1,198 | no | grounding mislabeled — TD-08 |
| `cli/field.rs` | 1,901 | **819** | 1,082 | no | Documented as "crosses 1000" — over-flag TD-07 |
| `cli/auth/login.rs` | 1,869 | 1,085 | 784 | yes | Documented ✅ |
| `cli/component.rs` | 1,796 | 1,796 | 0 | yes | Documented ✅ (tests live in `tests/`) |
| `cli/mod.rs` | 1,453 | 1,434 | 19 | yes | Documented ✅ (clap derive tree) |
| `api/jira/issues.rs` | 1,368 | **1,297** | 71 | **yes** | **UNDOCUMENTED (TD-05)** |
| `cli/issue/jsm_create.rs` | 1,341 | **840** | 501 | no | Documented as "crosses 1000" — over-flag TD-07 |
| `cli/issue/create.rs` | 1,304 | **698** | 606 | no | Documented as "crosses 1000" — over-flag TD-07 |
| `cli/issue/workflow.rs` | 1,272 | 1,131 | 141 | yes | Documented ✅ |
| `cli/issue/helpers.rs` | 1,120 | **682** | 438 | no | Documented as "1,113 LOC" — over-flag TD-07 |

### TD-04 — `api/client.rs` is genuinely oversized and mixes 3 concerns (UNDOCUMENTED)
**Severity: MEDIUM · Effort: M · Genuine, undocumented drift.**
Not in `CLAUDE.md`'s Known Size Deviations, and unlike `adf.rs`/`api/auth.rs` it has no ADR-0012 exemption. 1,562 production LOC spanning **three separable concerns**:
1. **HTTP client + retry/refresh/rate-limit state machine** — `from_config`, the verb methods, `send`/`send_bounded`/`send_inner`/`send_raw`, `clamp_retry_sleep` (this is the module's true job).
2. **stderr redaction/truncation utilities** — `sanitize_for_stderr` (L1415), `cap_entry` (L1226), `serialize_value_bounded` (L1277). ~300 LOC of pure, heavily-unit-tested string logic with **no dependency on `JiraClient`**.
3. **error-body extraction/classification** — `parse_error`, `extract_error_message`/`_raw` (L1696/1709), `classify_401_body` (L1540).
**Remediation:** extract cluster (2) to `src/api/redact.rs` (or fold into `observability.rs`) and cluster (3) to `src/api/error_body.rs`. Both are self-contained and move their tests with them, dropping `client.rs` well under 1,000 prod LOC with zero behavioral risk. Add the file to `CLAUDE.md` if kept as-is.

### TD-05 — `api/jira/issues.rs` oversized, resource-cohesive but splittable (UNDOCUMENTED)
**Severity: MEDIUM · Effort: M · Genuine, undocumented drift.**
1,297 prod LOC. More defensible than TD-04 (it's the "issues resource"), but two clean seams exist:
- **Search cluster** — `search_issues`/`search_issues_with_fields`/`search_issue_keys`/`approximate_count` (L210–571), incl. the JRACLOUD-95368 dedup + fixed-window-pagination guard (~360 LOC) → `api/jira/issue_search.rs`.
- **Comments cluster** — `add_comment`/`delete_comment`/`update_comment`/`get_comment`/`list_comments` (L858–1297) → `api/jira/comments.rs` (sibling to the existing per-resource file convention the module already follows).
**Remediation:** split as above; keeps the "one file per resource" convention `CLAUDE.md` documents for `api/jira/`. Lower priority than TD-04.

**All other > 1k-prod files are documented and their DOCUMENT-AS-IS rationale still holds** (single command-family cohesion / clap derive tree / ADF codec). No re-litigation recommended — but see TD-01/TD-02: file-level cohesion does **not** excuse function-level monoliths inside them.

---

## Dimension 2 — Long / Complex Functions (the real readability debt)

Function spans measured across production regions (all visibility forms):

| Function | Prod LOC | Location |
|----------|---------:|----------|
| `edit.rs::handle_edit` | **~1,314** | L45 |
| `list.rs::handle_list` | **~775** | L152 |
| `adf.rs::end` (ADF builder finalize) | ~564 | L1753 |
| `workflow.rs::handle_move` | ~494 | L303 |
| `create.rs::handle_create` | ~460 | L21 |
| `client.rs::send_inner` | ~414 | L533 |
| `jsm_create.rs::handle_jsm_create` | ~394 | L97 |
| `component.rs::handle_delete` | ~390 | L820 |
| `attachments.rs::handle_attachment_delete` | ~378 | L1931 |
| `adf.rs::render_node` | ~289 | L3346 |
| `component.rs::handle_edit` | ~286 | L484 |
| `attachments.rs::handle_attachment_upload_jsm` | ~277 | L1654 |
| `attachments.rs::handle_batch_download` | ~238 | L919 |
| `edit.rs::edit_issue_components` | ~205 | L1359 |
| `auth.rs::oauth_login` | ~200 | L1690 |

### TD-01 — `edit.rs::handle_edit` is a 1,314-LOC function
**Severity: HIGH · Effort: L · Genuine (distinct from the documented *file* size).**
This is the single biggest maintainability risk in the codebase. `CLAUDE.md` justifies `edit.rs`'s 3,287 file LOC on command-family cohesion — **that argument does not extend to one 1,314-line function**. It sequentially handles: arg validation, the `--field`+`--label` mutual-exclusion Gate, single-key vs bulk routing, field/label/type/component paths, `--dry-run`, `--jql` set resolution, and type-error enrichment — each an independently-testable sub-step currently sharing one stack frame and one giant `?`-chain.
**Remediation:** decompose into `handle_edit` (dispatch only, ≤ ~80 LOC) delegating to `edit_single_field`, `edit_bulk_fields`, `edit_labels`, `edit_type`, `edit_components`, `resolve_edit_targets` (the `--jql`/positional set builder), and `render_dry_run`. Several already exist as siblings (`edit_issue_components` at L1359); the work is hoisting the inline branches into peers. Do this behind the existing test suite (776 test LOC already pin behavior).

### TD-02 — `list.rs::handle_list` is a 775-LOC function
**Severity: HIGH · Effort: M · Genuine.**
Handles JQL composition (delegating to `build_jql_base_parts`), the full filter matrix (`--component`/`--updated-recent`/`--sort`/`--fields`/date clauses), team/points/component enrichment, and table-vs-JSON rendering in one body. The nested `.map(...).map(...)` enrichment closures (L332, L813–843) push cyclomatic complexity high.
**Remediation:** extract `compose_list_jql(...)`, `enrich_rows(...)`, and `render_list(...)` as named functions; leave `handle_list` as orchestration. The date-clause block (L282–288) and field-projection block (L616) are trivially liftable first steps.

### TD-03 — `client.rs::send_inner` — 414-LOC HTTP state machine
**Severity: MEDIUM · Effort: M · Genuine, undocumented.**
One function encoding: build/send, 429 rate-limit retry loop (`clamp_retry_sleep`), blanket-401 detection, per-profile single-flight refresh coordination, the one-attempt post-refresh retry, AND the AC-010 post-reconcile retry. The three near-identical `try_clone().expect("… cloneable (JSON body)")` retry rebuilds (L596/828/897) are a symptom of the copy-forward structure.
**Remediation:** extract `retry_after_rate_limit(...)`, `attempt_refresh_and_retry(...)`, and `reconcile_and_retry(...)` helpers so the top-level loop reads as a linear policy. Reduces the triplicated clone-retry blocks to one helper. Pairs naturally with TD-04.

### TD-13 — Secondary long handlers (238–494 LOC)
**Severity: LOW-MED · Effort: M (aggregate) · Genuine.**
`handle_move` (494), `handle_create` (460), `handle_jsm_create` (394), `handle_delete` (390), `handle_attachment_delete` (378), `component.rs::handle_edit` (286), `handle_attachment_upload_jsm` (277), `handle_batch_download` (238). Each is a candidate for the same dispatch-vs-step decomposition as TD-01/02, but individually lower-risk. `adf.rs::end` (564) and `render_node` (289) are inherent to a recursive codec and are acceptable as-is.

---

## Dimension 3 — Duplication

### TD-06 — Name-disambiguation logic duplicated across teams / users / labels (and 11 call sites)
**Severity: MEDIUM · Effort: M · Genuine.**
The identical control shape — `empty → error`, `len==1 → shortcut`, `partial_match(...)` then a 4-arm `MatchResult` match (`Exact → position().expect(...)`, `ExactMultiple → dialoguer::Select`, `Ambiguous → dialoguer::Select`, `None → error`), with a `no_input` branch inside each interactive arm — is re-implemented three times in `helpers.rs`:
- teams: `resolve_team_field` L131–196 (`.expect("matched name must exist in teams")` L135, L192)
- users: `disambiguate_user` L292–375 (`.expect("… in users")` L297, L366)
- labels: L545–620 (`.expect("… in results")` L539, `.expect("matched label …")` L550)

`partial_match::partial_match` is additionally called from **11 files** (`requesttype.rs`, `field.rs`, `queue.rs`, `links.rs`, `list.rs`, `jsm_create.rs`, `workflow.rs`, `mentions.rs`, `assets/tickets.rs`, `assets/schemas.rs`, `helpers.rs`), several re-deriving the same "match-arm + prompt + no_input error" boilerplate.
**Remediation:** add a generic `resolve_or_prompt<T>(matches: MatchResult, items: &[T], key: impl Fn(&T)->&str, no_input, prompt, empty_err, none_err) -> Result<&T>` to `partial_match.rs`. Collapses ~200 LOC of near-duplicate branching and removes six `position().expect()` re-lookups (which exist *only* because the match arms discard the index — the generic helper can return the item directly).

No other significant copy-paste found: `field_resolve.rs` already correctly shares `dispatch_field_value` between create/edit (per ADR-0012), which is the right pattern — good precedent for TD-06.

---

## Dimension 4 — Error Handling Consistency  ✅ (largely clean)

### TD-14 — Panic-site audit: disciplined, with a few uncommented residuals
**Severity: LOW · Effort: S · Mostly a positive finding.**
Production `unwrap`/`expect`/`panic!`/`unreachable!` count is **low** (the 1,401 tree-wide total is ~95% test code; e.g. 74 of them are in `cli/auth/tests/mod.rs`). Every audited production site is either:
- **provably safe with a proof comment** — e.g. `client.rs` `try_clone().expect("… JSON body")` (JSON bodies are always cloneable; multipart takes the separate rebuild path per the ADR-0017 gotcha), `helpers.rs` `position().expect("matched name must exist …")` (index into the same slice just matched), `attachments.rs` `expect("clap ensures …")`; or
- **enum-dispatch guards** — the `unreachable!()` arms in `links.rs` (L54/124/234), `workflow.rs` (L316/958/1019/1117), `attachments.rs` (L1173/1272/1947), `main.rs` (L234) all follow a variant already matched by the caller.

`JrError`/`exit_code()` mapping is used consistently across handlers; the `--output json` error envelope routes through `output::render_json` (the #526 invariant holds in audited paths).

**Two LOW residuals worth a comment (not a bug today):**
- `adf.rs:929` — `text[token_start..trimmed_end].chars().next_back().unwrap()` has **no** safety comment; relies on an implicit non-empty-slice invariant. Add a justification comment or guard.
- `partial_match.rs:27/28` — `exact_matches.into_iter().next().unwrap()` inside `1 =>` / `n if n>1 =>` arms; safe by the arm guard but uncommented.

Recommendation: annotate these two; otherwise this dimension is a model for the rest of the codebase.

---

## Dimension 5 — Type Design / Idioms

### TD-09 — `ProfileConfig` primitive-obsession: `auth_method` / `oauth_scopes` are `String`
**Severity: MEDIUM · Effort: S · Genuine.**
`src/config.rs` `ProfileConfig`:
- `auth_method: Option<String>` — a closed set (`"oauth"` / `"api-token"`) modeled as free text. It flows into `derive_auth_state` and `auth status`; a typo or drift is only caught at runtime. Should be `Option<AuthMethod>` (a `#[derive(Deserialize)]` enum). This is also **inconsistent** with the project's own `Profile(String)` newtype fence (ADR-0011/D-317) — the team already chose type-level invariants for profile names but left auth method stringly-typed.
- `oauth_scopes: Option<String>` — a space-separated scope list carried as one string, re-split at every use (`resolve_oauth_scopes`, `DEFAULT_OAUTH_SCOPES`). A `Vec<Scope>`/`ScopeSet` newtype would centralize the 8→16-scope expansion logic that recently churned.
**Remediation:** introduce `AuthMethod` enum (S) and, separately, a `ScopeSet` newtype (S-M). Field-ID strings (`team_field_id`, `story_points_field_id`, `cloud_id`) are lower value — leave as-is.

### TD-10 — Untyped `serde_json::Value` field API in `api/jira` + heavy `Value` use in `cli/`
**Severity: LOW-MED · Effort: M · Partly inherent.**
`create_issue(fields: Value)`, `edit_issue(key, fields: Value)`, `add_comment(body: Value)`, `get_comment -> Value` (`api/jira/issues.rs`) push all field-shape construction up into `cli/` (143 `serde_json::Value` references across `src/cli/`). Some of this is **inherent** to Jira's dynamic custom-field model and is defensible. But the fully-untyped `fields: Value` contract means field construction is re-implemented across `create.rs`/`edit.rs`/`jsm_create.rs` with no compile-time shape guarantee, feeding the TD-01 monolith.
**Remediation:** a thin `IssueFields` builder (typed setters for the governed/dedicated fields — summary/description/issuetype/priority/labels/components/parent/assignee — with an escape-hatch `custom(key, Value)`) would type the 80% common path while preserving the `Value` escape hatch. Medium effort; do *after* TD-01 decomposition exposes the shared field-assembly sites.

### TD-15 — Clone density (informational, LOW)
`.clone()` counts in prod regions: `field_resolve.rs` 35, `edit.rs` 23, `list.rs` 21, `helpers.rs` 19. Most are owned-`String`-into-JSON and legitimately necessary; a subset in the disambiguation arms (TD-06) disappears if items are returned by reference. Not a headline item — flag only for opportunistic cleanup during TD-01/TD-06 work.

---

## Dimension 6 — Module / Coupling  ✅ (mostly clean)

**Pure-core purity holds:** `adf.rs`, `duration.rs`, `jql.rs`, `partial_match.rs` import **no** `api`/`cli`/`cache`/`config` — the documented pure-core boundary is respected. `reqwest::` is confined to `api/` plus two justified sites (`error.rs` error-mapping, `cli/api.rs` passthrough).

### TD-11 — `output.rs` depends up-layer on `cli::OutputFormat` (LOW)
**Severity: LOW · Effort: S · Genuine layering inversion.**
`src/output.rs:1` — `use crate::cli::OutputFormat;`. The output/formatting utility (a lower-level concern) reaches *up* into the `cli` layer for its format enum. Minor, but it means `output.rs` can't be reasoned about without `cli`.
**Remediation:** move `OutputFormat` into `output.rs` (or a shared `types`/root module) and have `cli` re-export it. Cheap, removes the only inward-pointing arrow from a utility module.

### TD-12 — `reqwest::Response` leaks into a `cli` helper (LOW)
**Severity: LOW · Effort: S · Genuine but minor.**
`cli/issue/attachments.rs:681` takes `response: reqwest::Response` — the CLI layer handling a raw transport type (download redirect/CDN body processing). Consistent with `CLAUDE.md`'s documented two-step download design, but ideally the response-draining helper lives in `api/jira/attachments.rs` so `cli/` never names `reqwest`.
**Remediation:** relocate the response-body helper into the api layer; return bytes/typed data to `cli/`. Low priority.

**`pub` surface:** 58 `pub fn`/`pub async fn` in `cli/`. Because `jr` is a **binary** crate (with `lib.rs` only for integration-test access), over-`pub` exposure carries little real risk; not worth a dedicated remediation. Tightening to `pub(crate)`/`pub(super)` where integration tests don't need it is opportunistic-only.

---

## Dimension 7 — Doc-Drift

### TD-07 — `CLAUDE.md` "Known Size Deviations" measure *total* LOC (incl. inline tests), over-flagging 4 files
**Severity: MEDIUM · Effort: S · Doc-accuracy defect.**
ADR-0012's rule ("`src/cli/` files at ≥1,000 LOC are shard candidates") is applied against **total** LOC in `CLAUDE.md`, but several entries described as "CROSSES the 1,000-LOC shard threshold" have **production** code well under 1,000 (the rest is inline `#[cfg(test)]`):

| File | CLAUDE.md says | Actual total | Prod-only | Reality |
|------|---------------|-------------:|----------:|---------|
| `cli/issue/create.rs` | "~1,253 … CROSSES 1,000" | 1,304 | **698** | prod < 1k |
| `cli/issue/jsm_create.rs` | "~1,341 … CROSSES 1,000" | 1,341 | **840** | prod < 1k |
| `cli/field.rs` | "~1,901 … CROSSES 1,000" | 1,901 | **819** | prod < 1k |
| `cli/issue/helpers.rs` | "~1,113 LOC" | 1,120 | **682** | prod < 1k |

**Recommendation:** state the shard-threshold basis explicitly (production LOC vs total), and either re-measure these four on a prod-LOC basis (removing the "crosses threshold" framing) or keep them documented but note the test-inflation. This matters because these entries currently signal debt that doesn't exist in shippable code, diluting the genuine deviations (`edit.rs`, `attachments.rs`, `component.rs`, `field_resolve.rs`, `list.rs`, `workflow.rs`, `login.rs`, `mod.rs`).

### TD-08 — Grounding-data "undocumented oversized" list is mostly test-inflation
**Severity: LOW · Effort: S · Correction to the assessment inputs.**
The pre-collected grounding flagged `cache.rs (2,770)`, `config.rs (2,244)`, `auth_windows_store.rs (1,996)` as undocumented oversized files to flag as doc-drift. **On production LOC they are not oversized:** `cache.rs` = **879** prod (1,891 test), `config.rs` = **556** prod (1,688 test), `auth_windows_store.rs` = **798** prod (1,198 test). These are well-tested modules, not god-files — no split warranted, no `CLAUDE.md` entry needed. The *genuinely* undocumented oversized production files are only **`api/client.rs` (1,562)** and **`api/jira/issues.rs` (1,297)** — see TD-04/TD-05.

### Documented-LOC deltas (minor drift, informational)
Re-measured vs `CLAUDE.md`'s stated figures (all within normal churn, none material):
`list.rs` 2,012→**2,057** (+45) · `create.rs` 1,253→**1,304** (+51) · `workflow.rs` 1,277→**1,272** (−5) · `component.rs` 1,800→**1,796** (−4) · `attachments.rs` 3,472→**3,467** (−5) · `helpers.rs` 1,113→**1,120** (+7) · `field_resolve.rs` 2,269→**2,267** (−2). `edit.rs`, `mod.rs`, `field.rs`, `login.rs`, `jsm_create.rs`, `auth/tests/mod.rs` match exactly. No remediation needed beyond a maintenance-sweep refresh.

---

## Clean-Bill-of-Health (stated honestly)

- **Error handling** (Dimension 4): disciplined `JrError` mapping, proof-commented panics, enum-dispatch `unreachable!()`. Only 2 cosmetic residuals.
- **`unsafe`**: limited to `env::set_var/remove_var` Rust-2024 test seams — appropriate.
- **Lint suppression**: few and justified (`adf.rs` `too_many_lines`, ~12 `too_many_arguments`, one `dead_code` in `refresh_coordinator.rs`). No suppression-instead-of-refactor smell.
- **Pure-core boundary**: intact (Dimension 6).
- **No meaningful `TODO`/`FIXME`/`unimplemented!` debt** in production paths.

## Suggested Sequencing

1. **TD-01** then **TD-03/TD-04** (the two highest-risk monoliths + their natural file split) — biggest maintainability ROI.
2. **TD-06** (duplication; also removes six `expect()` re-lookups) and **TD-09** (`AuthMethod` enum; small, high clarity).
3. **TD-02**, then **TD-05** file split.
4. **TD-07/TD-08** doc corrections (cheap, unblocks accurate future assessments).
5. Opportunistic: TD-10 builder, TD-11/TD-12 layering, TD-13 secondary handlers, TD-14/TD-15 residuals, **TD-17 hygiene batch** (auto-fixable).

---

## Clippy Pedantic/Nursery Synthesis

**Source:** `cargo clippy --all-targets -- -W clippy::pedantic -W clippy::nursery` (exit 0). Full log: `/private/tmp/claude-501/-Users-zious-Documents-GITHUB-jira-cli/9a25bf3d-4371-4e09-a4fc-ecd85235e682/scratchpad/clippy-pedantic.log`.

**Reading the raw number:** ~3,229 raw warnings, but the count is heavily inflated by per-test-target duplication (~31 duplicate emissions per compiled target — the same source line re-reported for each `--all-targets` unit). **Distinct** pedantic/nursery findings are far fewer (~600–700). None of these lints are part of the repo's enforced default clippy gate (`cargo clippy -- -D warnings`), so **exit 0 on the enforced gate is unaffected** — everything below is opt-in.

Top distinct lints: `doc_markdown` ×63 · `redundant_closure_for_method_calls` ×28 · **`too_many_lines` ×22** · **`cast_possible_truncation` ×21** · `uninlined_format_args` ×19 · `map_unwrap_or` ×18 · `items_after_statements` ×10 · `semicolon_if_nothing_returned` ×9 · `needless_pass_by_value` ×6 · `manual_let_else` ×6 · `similar_names` ×5 · `option_if_let_else` ×5 · `use_self` ×4.

### Corroboration of TD-01/TD-02/TD-03/TD-13 (independent mechanical confirmation)
**`clippy::too_many_lines` ×22 independently confirms the long-function findings.** This is a mechanical, tool-sourced signal arriving at the same conclusion as the manual function-span analysis in Dimension 2: the codebase's dominant structural debt is a cluster of oversized functions, not file count. The `too_many_lines` sites overlap the hand-identified monoliths — **TD-01** (`edit.rs::handle_edit`, ~1,314 LOC), **TD-02** (`list.rs::handle_list`, ~775), **TD-03** (`client.rs::send_inner`, ~414), and the **TD-13** secondary handlers (`handle_move`, `handle_create`, `handle_jsm_create`, `handle_delete`, `handle_attachment_delete`, `handle_attachment_upload_jsm`, `handle_batch_download`). Two independent methods (clippy's line-count heuristic and this report's span analysis) converging on the same functions raises confidence that the TD-01/02/03/13 decomposition work is the correct top priority. No new action beyond those findings — noted here as validation.

### TD-16 — `clippy::cast_possible_truncation` ×~21 — potential silent-truncation `as` casts
**Severity: MEDIUM (if any site is reachable with a large value) / LOW (if all provably-bounded) · Effort: S-M · Genuine, clippy-sourced.**
21 lossy `as` casts where a wider integer/float is narrowed with `as`, silently wrapping/truncating instead of erroring. Distinct sites (from the log's `--> src/...` references):

| Cast | Sites | Assessment |
|------|-------|------------|
| `usize`→`u32` (64-bit) | `api/assets/objects.rs:31`, `api/jira/issues.rs:1000/1105/1188`, `api/jsm/queues.rs:58`, `cli/issue/field_resolve.rs:99`, `cli/issue/format.rs:127`, `cli/queue.rs:170`, `cli/issue/attachments.rs:1200`, `main.rs:107`, `api/client.rs:31` (+several dup) | Almost all pagination `startAt`/`maxResults`/counts (collection `len()` → API `u32`). Benign in practice (counts are small) but technically truncating; should be `u32::try_from(...)`. |
| `u128`→`u64` | `api/client.rs:446` (`as_micros()/1000`), `api/client.rs:705` (`as_millis()`) | `Duration` arithmetic → millis/micros for logging/sleep. Benign (durations bounded), but `try_from` is cleaner. |
| `u64`→`usize` | `adf.rs:3364` (ADF nesting `level`) | Bounded by `MAX_ADF_DEPTH = 256`; provably safe — annotate. |
| `f64`→`i64` | 2 sites (log L10417, L10845 — worklog/points rounding) | **Worth the closest look:** fractional truncation semantics; confirm intended rounding vs truncation. |
| `i64`→`usize` | 1 site (log L9226) | Sign-loss + truncation; confirm the source is non-negative and bounded. |
| `usize`→`u32` | `edit.rs:314/325/359`, `api/auth_windows_store.rs:433` | Bulk-index / envelope-length casts; verify bounds. |

**Remediation:** triage the ~21 sites in one scoped pass. For each: (a) if provably bounded (e.g. `adf.rs:3364` under `MAX_ADF_DEPTH`), replace with `try_from().expect("<invariant>")` or add `#[allow(clippy::cast_possible_truncation)]` **with a justification comment**; (b) if reachable with an unbounded value (the `f64`→`i64` and `i64`→`usize` sites are the prime suspects), switch to fallible `try_into()` and surface a `JrError` rather than silently truncating. This is the one clippy-sourced finding with genuine correctness (not just style) potential, which is why it is broken out rather than folded into TD-17.

### TD-17 — Remaining ~600 pedantic/nursery style warnings — optional "hygiene batch"
**Severity: LOW · Effort: S (mechanical, largely auto-fixable) · Genuine but non-blocking.**
The bulk of the distinct findings are pure opt-in style polish with no correctness impact: `doc_markdown` (backtick-wrap identifiers in rustdoc), `uninlined_format_args` (`format!("{}", x)` → `format!("{x}}")`), `redundant_closure_for_method_calls`, `map_unwrap_or`, `semicolon_if_nothing_returned`, `use_self`, `items_after_statements`, `manual_let_else`, `option_if_let_else`, `needless_pass_by_value`, `similar_names`. Most are `cargo clippy --fix -- -W clippy::pedantic` auto-applicable in a single mechanical commit. **None are part of the enforced gate**, so they represent zero shipping risk.

**Recommendation — do NOT enable `clippy::pedantic`/`nursery` wholesale in CI.** The signal-to-noise ratio is poor (63 `doc_markdown` alone would dominate every future diff), and the repo already runs a strict `-D warnings` default gate. Instead, if any tightening is desired, **cherry-pick a few high-value lints into the enforced set** rather than the whole group — the two justified candidates are:
- `clippy::cast_possible_truncation` (correctness-adjacent — pairs with TD-16 to prevent regressions once triaged), and
- `clippy::too_many_lines` with a **raised threshold** (e.g. `#![deny(clippy::too_many_lines)]` configured via `too-many-lines-threshold` in `clippy.toml` set generously, so it guards against *new* `handle_edit`-scale monoliths without flagging the 22 existing/inherent ones until TD-01/02/03/13 land).

Handle TD-17 as a single low-priority mechanical PR (or skip entirely) — explicitly **not** worth tracking as individual findings.
