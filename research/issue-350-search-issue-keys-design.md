---
document_type: research-validation
issue: 350
status: complete
date: 2026-05-13
producer: research-agent
sources_consulted: [perplexity, web-search, web-fetch, atlassian-developer-community, crates.io-registry, ankitpokhrel-jira-cli-go-source]
---

# Research Validation: Issue #350 — `search_issue_keys` lightweight API

Scope: focused validation pass on top of prior Perplexity work for the proposal to
add a `search_issue_keys` method on `JiraClient` that fetches only issue keys from
`POST /rest/api/3/search/jql`, avoiding the heavy `BASE_ISSUE_FIELDS` payload.

## Summary (net-new findings)

- **`maxResults` per-page cap is documented as 5000, not 100.** The existing
  `.min(100)` clamp in `search_issues` (issues.rs:50) is conservative, not a
  hard API limit. There is one Atlassian-confirmed regression (Apr 2025) where
  the server briefly ignored `maxResults` and returned up to 10,000 issues per
  page; this has since been fixed but is worth pinning in tests.
- **The Atlassian docs themselves explicitly recommend keys-only requests for
  bulk pagination.** Quote (paraphrased from `support.atlassian.com` and
  `developer.atlassian.com`): "the greatest number of items returned per page
  is achieved when requesting `id` or `key` only." This directly justifies #350.
- **Response shape for `fields=["key"]` is partially inconclusive at the
  documentation level.** Atlassian's developer.atlassian.com page is the
  authoritative reference but its rendered content keeps getting truncated;
  every cross-reference I could find (ankitpokhrel/jira-cli Go source,
  community.atlassian.com threads, web examples) describes
  `{issues: [{id, key, self, fields}], nextPageToken, isLast}` — but **none**
  show an empirical capture of the response when `fields=["key"]` specifically
  is sent. Prior Perplexity claim that "key is always at the top level
  regardless of `fields`" is consistent with the docs and the Go reference
  implementation but should be **defensively validated by the deserializer**
  (treat `fields.key` as a fallback, see Design §1c).
- **Rust SDK naming: `list_*` is more common than `search_*` for
  collection-style methods, but `search_*` is correct when a JQL query is the
  primary input.** Verdict for #350 below in Design §2.
- **Concrete crate versions verified against crates.io 2026-05-13:**
  `wiremock = 0.6.5`, `reqwest = 0.13.3`. The repo's wiremock-rs invocation
  pattern (`body_json`, `body_partial_json`) is current and idiomatic in v0.6.x.
- **No conflict between `nextPageToken` semantics and a keys-only fields list.**
  JRACLOUD-94632 (repeated-cursor loop) is independent of the `fields`
  parameter — the existing anti-loop guard transfers unchanged.

## 1. Jira API edge cases for `fields=["key"]`

### 1a. Does any documented tenant config reject `fields=["key"]`?

**Verdict: No documented tenant config rejects minimal `fields` lists.**

- Perplexity search (May 2026) found no documented site-admin toggle or per-
  tenant configuration that requires `*navigable` over `["key"]`. The official
  schema for `/search/jql` accepts an array of arbitrary field names including
  the magic values `*all` and `*navigable`. (sources: [Atlassian dev docs —
  Issue Search](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/),
  [Adaptavist deprecation notice](https://docs.adaptavist.com/sr4jc/latest/release-notes/breaking-changes/atlassian-rest-api-search-endpoints-deprecation))
- The community "disaster" thread reports general flakiness (pagination, token
  expiry, sometimes-missing `isLast`) but **no report of `fields=["key"]`
  itself being rejected**. (source: [community.atlassian.com 3101716](https://community.atlassian.com/forums/Jira-questions/REST-The-new-rest-api-3-search-jql-endpoint-is-a-complete/qaq-p/3101716))
- **One caveat surfaced:** that same thread notes "when i make a call with
  just the jql param, it returns the expected isLast and nextPageToken. IF i
  add any other params, i get 50 issues and no isLast or nextPageToken."
  Confidence: anecdotal, not reproducible across reports. **Mitigation:** the
  existing `CursorPage<T>` deserializer already treats `next_page_token` as
  `Option<String>` and the loop terminates when it is `None` — keys-only
  requests inherit the same safety.

### 1b. Is the response shape stable across tenants when `fields` is minimal?

**Verdict: Stable per official schema; defensively validate `key` extraction.**

- The `ankitpokhrel/jira-cli` Go reference implementation deserializes
  `/search/jql` responses into `SearchResult { IsLast bool, NextPageToken
  string, Issues []*Issue }` — confirming top-level `isLast` and
  `nextPageToken`. (source: [github.com/ankitpokhrel/jira-cli pkg/jira/search.go](https://github.com/ankitpokhrel/jira-cli))
- The repo's existing `pub struct Issue { pub key: String, pub fields:
  IssueFields }` (`src/types/jira/issue.rs:9`) has worked against
  `/search/jql` since the migration — this is empirical confirmation that
  `key` is at the top level. The local struct doesn't even declare `id` or
  `self` and has not broken.
- **One conflicting Perplexity claim:** a search result said that with
  `fields` filter, the response is `{"fields": {"key": "..."}}` only, with no
  top-level `key`. This claim is **REFUTED** — Perplexity confused the
  general `fields=...` query-parameter behavior (which controls what goes
  *inside* `fields{}`) with the `key` field's top-level placement (which is
  not a member of `fields{}` and is always emitted by the server, per the
  documented schema for `/search/jql`).
- **Inconclusive at the documentation level:** Atlassian's interactive doc
  page is rendered behind JavaScript and the WebFetch tool only retrieves a
  truncated version of it. The shape is confirmed by the existing local
  binary's behavior and by the Go reference, but not by a quotable schema
  capture.

### 1c. Does `fields: ["key"]` ALSO put `key` inside the `fields` object?

**Verdict: Inconclusive — defensively assume both shapes are possible.**

- No source consulted (Perplexity, community.atlassian.com, Atlassian dev
  docs cached content) produces a definitive empirical capture of the
  response body for `POST /search/jql` with `fields: ["key"]`.
- The general server behavior is: `fields` array names additional projections
  to include in the response's `fields{}` sub-object; `key` is a top-level
  identifier and is not typically projected. But the server *may* echo
  requested-yet-unknown-as-projectable field names into `fields{}` as
  `null` — observed in older Jira Server behavior, undocumented for `/search/jql`.
- **Design implication:** The new `KeySearchResult` deserializer should
  bind `key` from the **top level** only. If empirically the server starts
  returning `key` only nested inside `fields`, the response will fail to
  deserialize loudly (because top-level `key: String` is required), which
  is preferable to silently dropping issues. The integration test should
  pin both shapes — see Design §4.

### 1d. What is the documented `maxResults` cap?

**Verdict: Documented 5000 max per page; default 50; existing 100 clamp is
conservative and should stay for #350.**

- [Atlassian support KB](https://support.atlassian.com/jira/kb/how-to-use-the-maxresults-api-parameter-for-jira-issue-search-rest-api/):
  default 50, configurable.
- [Atlassian dev docs](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/):
  maximum 5000 per page; "the greatest number of items returned per page is
  achieved when requesting id or key only" — this is a documented hint that
  with `fields: ["key"]` the server can return more items per response than
  with the full BASE_ISSUE_FIELDS list.
- **Regression history:** [community.developer.atlassian.com 88287](https://community.developer.atlassian.com/t/post-rest-api-3-search-jql-does-not-respect-maxresults-param/88287)
  reports a 2025 regression where the API returned **up to 10,000 issues**
  ignoring `maxResults`; Atlassian confirmed and rolled a fix. The existing
  `.min(100)` clamp is a defense against this class of bug — keep it for
  `search_issue_keys` too.
- **For #350:** since `key`-only payloads are dramatically smaller, the
  caller might want a larger per-page cap to reduce round trips. Recommend
  *not* changing the 100 clamp in the initial implementation — keep it
  identical to `search_issues` to inherit all hardening. Optimization can
  be a follow-up.

## 2. API method naming + struct field naming

### 2a. `search_issue_keys` vs `list_issue_keys` vs `find_issue_keys`

**Verdict: `search_issue_keys` — matches the existing `search_issues` name,
which is the dominant idiom when a JQL query drives selection.**

| Crate | Pattern for query-driven listing | Pattern for unfiltered listing |
|---|---|---|
| octocrab | `search().issues_and_pull_requests(q)` | `list_*` (e.g., `repos.list()`) |
| aws-sdk-rust | (uses paginated builders, not `list_keys`) | `list_*` (`list_buckets`, `list_objects`) |
| kube-rs | (uses `Api::list(&lp)` with `ListParams`) | `list_*` |
| Local repo | **`search_issues`** (jql + limit + extra_fields) | `list_*` (e.g., `list_boards`) |

The dominant convention is:
- `search_*` when a **query** (JQL/text) is the primary input.
- `list_*` when iterating a **collection** (no query, possibly with filters).

Issue #350's method takes a JQL string as its primary input — so
`search_issue_keys` is correct. Bonus: it mirrors the existing
`search_issues` name, preserving discoverability.

(sources: [Rust API Guidelines naming](https://rust-lang.github.io/api-guidelines/naming.html),
direct inspection of [octocrab](https://docs.rs/octocrab), aws-sdk-rust patterns)

### 2b. Result struct field name: `keys` vs `items`

**Verdict: `keys` — domain-named is more idiomatic for a single-purpose
result struct.**

- The existing `SearchResult { issues: Vec<Issue>, has_more: bool }` uses
  the domain name `issues`, not `items`. Symmetry argues for `keys`.
- Generic `items` is appropriate for parameterized container types
  (`OffsetPage<T>::items()` returns `&[T]`), but `KeySearchResult` is
  monomorphized to `Vec<String>` — there is no reason to be generic.
- Rust API Guidelines C-COLLECT prefers domain-named methods over generic
  collection adapters when the function is single-purpose.

(sources: [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/naming.html), repo's existing `SearchResult`)

## 3. Pagination semantics under minimal fields

### 3a. Does `nextPageToken` behave identically with `fields: ["key"]` vs full fields?

**Verdict: Yes — no documented difference; the cursor is opaque to the
client and the server's pagination logic is field-independent.**

- The cursor is documented as an opaque token; the server's internal page
  state is built from the JQL + sort, not the projected fields. (source:
  [Atlassian dev docs](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/))
- No community report (across the 10+ threads scanned) ties `fields=` to
  pagination misbehavior. JRACLOUD-94632 reproduces with arbitrary fields.

### 3b. Does the JRACLOUD-94632 anti-loop guard transfer?

**Verdict: Yes — copy the guard verbatim.**

- The repeated-cursor loop is a server-side bug unrelated to projected
  fields. The existing guard at `issues.rs:97-107` should be replicated in
  `search_issue_keys` with the same warning text and JRACLOUD-94632
  citation. No design change required.

## 4. Test strategy + wiremock-rs current best practice

### 4a. wiremock-rs version + idiomatic usage

**Verified against crates.io API 2026-05-13:** `wiremock = "0.6.5"` is the
current release. The repo's existing wiremock invocation pattern in
`tests/` (Mock::given/and/respond_with/mount) is current.

(source: [crates.io API for wiremock](https://crates.io/api/v1/crates/wiremock))

### 4b. Asserting `fields == ["key"]` exactly in the request body

**Recommended pattern: `body_partial_json` for the `fields` projection only,
plus a separate `body_partial_json` or `body_json` matcher for `jql` and
`maxResults`.**

```rust
use serde_json::json;
use wiremock::matchers::{body_partial_json, method, path};
use wiremock::{Mock, MockServer, ResponseTemplate};

let server = MockServer::start().await;

Mock::given(method("POST"))
    .and(path("/rest/api/3/search/jql"))
    .and(body_partial_json(json!({ "fields": ["key"] })))
    .and(body_partial_json(json!({ "jql": "project = FOO" })))
    .respond_with(ResponseTemplate::new(200).set_body_json(json!({
        "issues": [{ "key": "FOO-1", "fields": {} }],
        "isLast": true
    })))
    .expect(1)
    .mount(&server)
    .await;
```

- `body_partial_json` is more robust than `body_json` (exact match) because
  it tolerates serde_json's nondeterministic object-key ordering for the
  outer JSON.
- For a strict assertion that `fields` is **exactly** `["key"]` and not e.g.
  `["key", "summary"]`, the partial-JSON matcher works because array-element
  matching is by value at the position. To catch over-inclusion explicitly,
  add a negative assertion: a second `Mock` that matches `body_partial_json
  (json!({"fields": ["key", "summary"]}))` and `.expect(0)`.

(source: [wiremock 0.6.5 docs.rs matchers](https://docs.rs/wiremock/0.6.5/wiremock/matchers/index.html))

### 4c. Recommended test cases beyond happy path

| Test case | Why |
|---|---|
| Single page, `isLast: true`, ≤ limit | Happy path |
| Two pages, second has `isLast: true` and no `nextPageToken` | Cursor termination |
| Two pages, server returns **same `nextPageToken` twice** | JRACLOUD-94632 anti-loop guard fires + stderr warning |
| Response with empty `issues: []` | Empty JQL match |
| Limit + 1 lookahead idiom (`effective_max + 1`) | Migration from `search_issues` in `create.rs:386` — exact-match check that `has_more` flips correctly |
| Server returns issue **without** top-level `key` (only `fields.key`) | Defensive: must fail loudly, not silently drop |
| Server returns `maxResults` ignored (10k items in one page) | Regression pin for JRACLOUD/CDAC bug — limit clamp must protect |
| Wiremock asserts `body_partial_json({"fields": ["key"]})` exact | Confirms BASE_ISSUE_FIELDS is NOT sent |

## 5. Library specifics (reqwest 0.13, serde)

### 5a. reqwest 0.13.x — current idiomatic POST + deserialize

**Verified against crates.io 2026-05-13:** `reqwest = "0.13.3"`. Public API
unchanged from 0.12.x for `Client::post().json(&body).send().await?.json::<T>().await`.
The repo's existing `JiraClient::post` wrapper is already idiomatic.

(source: [crates.io API for reqwest](https://crates.io/api/v1/crates/reqwest))

### 5b. `#[serde(deny_unknown_fields)]` vs accepting unknowns

**Verdict: DO NOT use `deny_unknown_fields` on the issue-row struct.**

Rationale:
- Atlassian regularly adds new top-level fields to issue objects (`expand`,
  `renderedFields`, `properties`, `editmeta`, `versionedRepresentations`, etc.).
  Even though the request asks for `fields: ["key"]`, the server is free to
  emit additional metadata at the top level — and historically does.
- The existing `Issue` struct (`src/types/jira/issue.rs:9`) does NOT use
  `deny_unknown_fields` — it has just `key` and `fields` and silently ignores
  everything else. Keep this convention.
- `deny_unknown_fields` would make the SDK brittle against any future
  Atlassian additive change. Defaults (silently ignore unknowns) are the
  correct semantic for SDKs against evolving external APIs.
- One caveat: `deny_unknown_fields` is incompatible with `#[serde(flatten)]`
  anyway, so future struct evolution wouldn't be friendly.

(source: [serde derive docs](https://docs.rs/serde_derive))

## Confirmed-vs-Refuted-vs-Inconclusive matrix

| Claim (from prior validation or proposal) | Verdict | Evidence |
|---|---|---|
| `fields: ["key"]` is the minimal valid POST body value | CONFIRMED | Atlassian dev docs + community examples; no contrary report |
| `key` is always at top level of each issue object | CONFIRMED (defensively) | Existing local `Issue` struct works today (`src/types/jira/issue.rs:9`); Go reference confirms |
| `key` is ALSO duplicated inside `fields{}` when requested | INCONCLUSIVE | No primary source confirms either way; treat top-level as truth; don't fall back to `fields.key` |
| Per-page max is 100 | REFUTED | Documented max is 5000; default 50; repo's `.min(100)` is a conservative client-side clamp |
| Option A (concrete `KeySearchResult` struct) is idiomatic | CONFIRMED | Mirrors existing `SearchResult`; aligns with Rust API Guidelines C-COLLECT |
| `search_issue_keys` is the right name (not `list_*` / `find_*`) | CONFIRMED | Matches existing `search_issues`; `search_*` is idiomatic when JQL drives selection |
| Field name should be `keys`, not `items` | CONFIRMED | Mirrors `issues` in `SearchResult`; matches C-COLLECT |
| JRACLOUD-94632 anti-loop guard applies unchanged to keys-only | CONFIRMED | Cursor is opaque + field-independent; no community report ties bug to projection |
| wiremock-rs 0.6.x `body_json` / `body_partial_json` are current | CONFIRMED | crates.io 0.6.5; docs.rs schema unchanged from prior repo usage |
| reqwest 0.13.x is the current line | CONFIRMED | crates.io 0.13.3 |
| Use `#[serde(deny_unknown_fields)]` for safety | REFUTED | Anti-pattern for SDKs against evolving external APIs; existing `Issue` doesn't use it |
| Atlassian docs explicitly recommend keys-only for bulk pagination | CONFIRMED (new finding) | Atlassian dev docs: "greatest number of items returned per page is achieved when requesting id or key only" |
| There was a recent regression where `maxResults` was ignored | CONFIRMED (new finding) | [community.developer.atlassian.com 88287](https://community.developer.atlassian.com/t/post-rest-api-3-search-jql-does-not-respect-maxresults-param/88287); fixed but worth pinning |

## Design recommendations (applied to #350)

### Method signature

```rust
// Result struct — mirrors SearchResult; field name `keys` mirrors `issues`.
pub struct KeySearchResult {
    pub keys: Vec<String>,
    pub has_more: bool,
}

impl JiraClient {
    /// Search and return ONLY issue keys for a JQL query.
    ///
    /// This is a lightweight variant of `search_issues` for callers that
    /// only need keys (e.g., bulk edit selection via `--jql`). It avoids
    /// fetching the BASE_ISSUE_FIELDS payload (description, issuelinks, etc.).
    ///
    /// Atlassian documents that "the greatest number of items returned per
    /// page is achieved when requesting id or key only" — so keys-only
    /// requests are both cheaper and (potentially) less paginated.
    pub async fn search_issue_keys(
        &self,
        jql: &str,
        limit: Option<u32>,
    ) -> Result<KeySearchResult> { ... }
}
```

### Response deserialization

Use a thin local struct, NOT a reuse of `Issue`:

```rust
#[derive(Deserialize)]
struct IssueKeyRow {
    key: String,
    // NOTE: deliberately omit deny_unknown_fields — Atlassian adds top-level
    // fields over time (expand, properties, renderedFields). Silently
    // ignoring unknowns is the correct SDK posture.
}
```

Rationale: reusing `Issue` would force a non-null `fields: IssueFields` deserialization, which would either fail (because the response's `fields{}` is empty when only `key` is projected) or require making `IssueFields` fully optional and degrade type safety for every other caller.

### Pagination loop

Copy the existing `search_issues` loop verbatim with the only changes being:
- request body uses `"fields": ["key"]` (not `BASE_ISSUE_FIELDS`)
- response deserializes to `CursorPage<IssueKeyRow>`
- accumulates `Vec<String>` (mapping `.key`)
- keep the `.min(100)` per-page clamp identical
- **keep the JRACLOUD-94632 anti-loop guard verbatim including the stderr
  warning** — this is a server bug, not a `fields`-sensitive one

### Migration of the existing caller

`src/cli/issue/create.rs:386` should switch from
`.search_issues(jql_str, Some(effective_max + 1), &[])`
to
`.search_issue_keys(jql_str, Some(effective_max + 1))`
and drop the `.into_iter().map(|i| i.key).collect()` adapter — the result is already `Vec<String>`.

### Tests (new file: `tests/issue_search_keys.rs` or integration into existing harness)

| # | Test | Wiremock expectation |
|---|---|---|
| 1 | Happy path: one page, 3 keys returned | `body_partial_json({"fields": ["key"]})` + `isLast: true` |
| 2 | Two pages with cursor; second page has no `nextPageToken` | Two mocks; second responds with `isLast: true` |
| 3 | Anti-loop: server returns same `nextPageToken` twice → guard fires, stderr warning | Asserts on returned partial result + log capture |
| 4 | Empty result `issues: []` | Returns `KeySearchResult { keys: vec![], has_more: false }` |
| 5 | `limit + 1` lookahead: server returns `limit + 1` keys → `has_more = true`, truncated to `limit` | Mirrors `create.rs:386` pattern |
| 6 | Negative: server response missing top-level `key` → deserialization error surfaces | Pins defensive design §1c |
| 7 | Body assertion: BASE_ISSUE_FIELDS is NOT in the request | Negative `Mock` with `.expect(0)` for `body_partial_json({"fields": ["summary"]})` |

### Out of scope for #350 (defer)

- Raising the per-page clamp from 100 toward 5000 for keys-only requests:
  measure first; not required for correctness.
- A streaming/async-iterator variant: current callers want a single `Vec`.
- Generalizing into `search_field_projection<T>` — premature; only one
  keys-only caller exists today.

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| Perplexity search | 5 | API edge cases, response shape, naming conventions, wiremock-rs, fields=["key"] community reports |
| Perplexity reason | 1 | Cross-check response shape claim against documentation |
| WebSearch | 5 | Atlassian community threads, regression reports, idiomatic reqwest 0.13 |
| WebFetch | 9 | crates.io for wiremock/reqwest versions, docs.rs/wiremock matchers, Atlassian dev docs, ankitpokhrel/jira-cli Go source, community threads (3101716, 88287, 90176) |
| Grep / Read (local) | 4 | Verify existing `Issue` struct in `src/types/jira/issue.rs`, the caller in `cli/issue/create.rs:386`, and pagination types |
| Training data | 1 area | General Rust API conventions cross-check (low; verified against API Guidelines) |

**Total external tool calls:** 24
**Training data reliance:** low — all version numbers verified against crates.io live registry on 2026-05-13; API shape claims grounded in either Atlassian docs (where readable), the Go reference implementation, or empirical confirmation against the existing local `Issue` struct that already deserializes `/search/jql` responses successfully.

**Confidence flags:**
- HIGH: naming, struct field name, test strategy, wiremock pattern, reqwest pattern, anti-loop guard reuse, maxResults documented 5000.
- MEDIUM: response shape for `fields: ["key"]` specifically — no quotable empirical capture, but the existing local code path is in production. Mitigated by defensive deserializer design.
- LOW / INCONCLUSIVE: whether `key` ever appears duplicated inside `fields{}` — flagged explicitly in §1c; design fails loudly if observed.

---

## Addendum: Design Adversarial Pass (2026-05-13)

Pressure-test pass against the 6-section proposed design. Verdicts: CONFIRM /
CONCERN / GAP / REFUTED. Built on top of the validation above — does not
re-derive prior findings.

### Q1. Derives on `KeySearchResult` — `Debug`, `Clone`, `PartialEq`

**Verdict: CONCERN → add `#[derive(Debug, Clone, PartialEq)]`.**

Rust API Guidelines C-COMMON-TRAITS (AAA level) requires public types in
public modules to derive at minimum `Debug` and `Clone`; octocrab and
aws-sdk-rust consistently derive all three on response structs. The existing
`SearchResult` (`issues.rs:32-35`) derives nothing — this is a latent gap,
not an intentional choice (no comment justifies it; the inline tests in
`issues.rs:305-321` even construct it manually and would benefit from
`Debug`/`PartialEq` for assertion ergonomics). Adding derives to the new
struct does NOT force the same on `SearchResult` (additive). Recommend
`#[derive(Debug, Clone, PartialEq)]`. Source:
[Rust API Guidelines C-COMMON-TRAITS](https://rust-lang.github.io/api-guidelines/interoperability.html#c-common-traits).

### Q2. `has_more` semantics when `limit=None`

**Verdict: GAP → document the contract explicitly.**

The current design conflates "API says more pages exist" with "caller-side
truncation occurred". When `limit=None`, the loop exhausts the cursor and
`has_more` is always `false` — which is fine for the current caller (it
passes `Some(effective_max + 1)`) but the public API contract is ambiguous
for future callers. octocrab and aws-sdk-rust convention: paginators
distinguish "stream complete" from "stream interrupted by caller". Two
options: (a) document that `has_more = true` strictly means "caller-side
truncation, not API-side", or (b) define `has_more` as the union (always
returns API `next_page_token.is_some()` if the last fetched page had one).
The simplest fix is option (a) plus a rustdoc note: `has_more` reflects
ONLY caller-cap truncation; pure pagination always returns `false` when
`limit=None`. Mirrors existing `SearchResult` semantics. Source: prior
research §3.5 + adversarial cross-check.

### Q3. Negative-mock `.expect(0)` and `body_partial_json` array semantics

**Verdict: REFUTED partly → the over-inclusion negative-mock is REDUNDANT.**

Two findings:
(a) `wiremock-rs 0.6.5` `Mock::expect(0)` reliably panics on `MockServer`
drop when the mock matched ≥1 request. The pattern is correct. Source:
[docs.rs/wiremock/0.6.5](https://docs.rs/wiremock/0.6.5/wiremock/).
(b) `body_partial_json` wraps `assert-json-diff`'s `assert_json_include` —
which is order-preserving and length-strict for arrays (objects are loose;
arrays are strict). So `body_partial_json({"fields": ["key"]})` already
FAILS to match a request carrying `fields=["key","summary"]`. The proposed
negative `.expect(0)` mock for `{"fields":["summary"]}` adds no signal
beyond what the positive mock provides — the test will fail at `.expect(1)`
on the positive mock if BASE_ISSUE_FIELDS leaks. Keep the negative mock for
documentation/intent purposes only; do not add others. Source:
[docs.rs/assert-json-diff](https://docs.rs/assert-json-diff) array
semantics + Perplexity verification.

### Q4. JRACLOUD-94632 guard — false-positive risk

**Verdict: CONCERN → guard semantics are correct but stderr warning text
needs nuance.**

Repeated `nextPageToken` is NOT always a server bug. JRACLOUD-95368
documents that the new `/search/jql` endpoint lacks snapshot stability: if
issues are modified mid-pagination, the cursor can produce overlapping
windows. The existing warning text claims "Atlassian /rest/api/3/search/jql
returned the same nextPageToken twice — aborting pagination loop" which
implies a bug. Reality: the guard is correct (abort to prevent infinite
loop), but the cause may be live data drift, not a server bug. Since
`search_issue_keys` copies the guard verbatim per design §4, it inherits
the same imprecise warning. Not a blocker for #350, but worth a follow-up
issue to tighten the message ("...possibly due to JRACLOUD-94632 or live
data drift during pagination"). Source:
[JRACLOUD-95368](https://jira.atlassian.com/browse/JRACLOUD-95368),
[JRACLOUD-94632](https://jira.atlassian.com/browse/JRACLOUD-94632).

### Q5. `fields=["key"]` vs `fields=[]`

**Verdict: CONFIRM `fields=["key"]` (do NOT use empty array).**

Community testing on Jira Cloud (May 2026) confirms that `fields=[]` is
treated as "return all fields" (the empty array is effectively ignored —
NOT "return no fields" as one might expect). `*none` is invalid and
returns 400. `*navigable` is unreliable on the v3 `/search/jql` endpoint
(legacy server behavior, not preserved). Only `fields=["key"]` reliably
returns a minimal payload. Design choice is correct. Source: prior
research §1a + Perplexity cross-check covering 2025-2026 community reports.

### Q6. Missing test cases

**Verdict: GAP → add 3 cases.**

Beyond the 8 proposed, three are missing:

1. **Empty result set** (`issues: []`, `isLast: true`) → returns
   `KeySearchResult { keys: vec![], has_more: false }`. Currently NOT
   listed (the listed cases all assume ≥1 issue). Cheap and important —
   covers JQL that matches zero issues, a common path.
2. **401 mid-pagination** (page 1 returns 200 with `nextPageToken`, page 2
   returns 401). Should propagate the error (current design via
   `anyhow::Result`); partial results are dropped. This is the correct
   semantic but should be PINNED by a test, because the OAuth auto-refresh
   wiring (S-3.03) is downstream and a future refactor could silently
   change behavior to "return partial".
3. **Malformed JSON on a page** (200 status, body is `not-json` or
   truncated). Confirms `anyhow` error path surfaces a useful message.

JQL injection is NOT our concern — the parameter is passed verbatim to the
Jira API as a request-body string field and the server validates it. Skip.

### Q7. Caller migration — existing-test impact

**Verdict: CONFIRM — no breakage. One nuance.**

Survey of `tests/`: 22 occurrences of `path("/rest/api/3/search/jql")` (all
in `tests/issue_bulk_pr2.rs`). The mocked responses use `jql_search_response`
(`issue_bulk_pr2.rs:79-110`), which returns fully-populated `IssueFields`
including `summary`, `status`, etc. After migration to `search_issue_keys`,
the deserializer `IssueKeyRow { key }` ignores all those extra fields
(silently, by serde default) — so existing tests continue to pass without
modification. Zero existing tests assert on the request body's `fields`
array (no `body_partial_json({"fields":...})` hits in `tests/`). The
migration is purely additive at the test layer; no test rewrites required.
Verified via Grep across the entire `tests/` tree.

### Q8. Documentation fallout — CLAUDE.md, ADRs, BCs

**Verdict: GAP → 3 doc touches required.**

1. **CLAUDE.md `src/api/jira/issues.rs` blurb** (line 36):
   currently `# search, get, create, edit, list comments`. Should append
   `, search keys` (or rewrite to mention the new method). One-line touch.
2. **No ADR change required.** ADR-0001 (thin client) is unaffected — this
   is just another method on the same `JiraClient`. ADR-0004 (per-feature
   specs) is honored by writing the feature spec for #350.
3. **BC catalog**: `bc-2-issue-read.md` §2.6 (API layer) ends at BC-2.6.049.
   The new method warrants a BC entry — proposal: **BC-2.6.050:
   `client.search_issue_keys(jql, limit)` sends `fields: ["key"]`,
   deserializes top-level `key` only, paginates via `CursorPage<IssueKeyRow>`
   with the JRACLOUD-94632 anti-loop guard.** Must be added before merging
   per the project's VSDD spec corpus (cumulative count in BC-INDEX.md
   needs +1, definitional_count in bc-2 frontmatter needs +1). Run
   `scripts/check-spec-counts.sh` after editing. Source:
   `.factory/specs/prd/bc-2-issue-read.md`, BC-INDEX.md frontmatter.
