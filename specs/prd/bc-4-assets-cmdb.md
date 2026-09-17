---
context: bc-4
title: "Assets & CMDB"
total_bcs: 32   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 22   # count of `#### BC-` headings in this file
last_updated: 2026-09-17
source_pass: 3
trace: |
  - L2: .factory/specs/domain-spec/bc-04-assets-cmdb.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.4
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.3
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.7
  - cycle-008 `oauth-surface-correctness` F2 spec evolution (2026-09-17), ADR-0026 Decision 1 —
    BC-4.2.001 AMENDED in place: adds the OAuth 3LO gateway-routing invariant
    (`get_or_fetch_workspace_id` and 6 sibling JSM `servicedeskapi` call sites MUST address
    `base_url`, never `instance_url`, under an OAuth profile), attaches VP-OAUTH-GW-001, and
    anchors the unified 7-call-site fix table from ADR-0026's Decision 1 here. COUNT-NEUTRAL —
    no BC added/removed, total_bcs (32) and definitional_count (22) UNCHANGED. BC-4.2.002..005
    are explicitly NOT amended (confirmed already gateway-correct by F1 code audit). Same burst:
    21 pre-existing TD-031 volatile line cites in this file converted from `:NNN` to `:~NNN`
    form to clear the `validate-stable-anchors` hook blocker (mirrors the precedent fix applied
    to bc-2-issue-read.md at P14-006) — citation targets unchanged, tilde marks them approximate
    per CLAUDE.md's own citation-form convention. See
    `.factory/cycles/cycle-008/F2-architecture-delta.md` §S3,
    `.factory/cycles/cycle-008/verification-delta.md` §VP-OAUTH-GW-001.
---

# BC-4 — Assets & CMDB

32 behavioral contracts across 4 subdomains: AQL / CMDB field resolution (4.1),
Asset search & view (4.2), Asset enrichment — MUST-FIX (4.3), Error handling (4.4).

---

## Subdomains

### 4.1 AQL / CMDB Field Resolution

#### BC-4.1.001: `find_cmdb_fields()` filters by `schema.custom == "com.atlassian.jira.plugins.cmdb:cmdb-object-cftype"`

**Confidence**: HIGH
**Source**: `tests/cmdb_fields.rs:~50-83`
**Subject**: Assets/CMDB
**Behavior**: Returns `Vec<(String, String)>` of (id, name) tuples matching ONLY CMDB custom fields. Story points and summary are filtered out. Filter is schema.custom string, NOT name-based heuristic.
**Edge cases**: empty result when no CMDB fields exist.
**Trace**: Pass 3 BC-301; BC-1137a (R4)

---

#### BC-4.1.002: `build_asset_clause` for single CMDB field emits `"<NAME>" IN aqlFunction("Key = \"<KEY>\"")`  (NO outer parens)

**Confidence**: HIGH
**Source**: `src/jql.rs:~61-82`
**Subject**: Assets/CMDB
**Behavior**: Single-field branch returns `clauses.into_iter().next().unwrap()` — no outer parens. For field `("customfield_10191", "Client")` and key `"CUST-5"` → `"Client" IN aqlFunction("Key = \"CUST-5\"")`. LHS is field NAME not id. AQL attribute is capital `Key` (NOT `objectKey`).
**Trace**: Pass 3 BC-306, BC-306-R (R1); CLAUDE.md gotcha

---

#### BC-4.1.003: `build_asset_clause` uses `escape_value` for BOTH field name AND asset key

**Confidence**: HIGH
**Source**: `src/jql.rs:~67-74`
**Subject**: Assets/CMDB
**Behavior**: Both name and key go through `escape_value`. JQL injection via field names or keys is structurally prevented.
**Trace**: Pass 3 BC-307, BC-307-R (R1)

---

#### BC-4.1.004: Two CMDB fields → parenthesized OR-join: `("X" IN aqlFunction(...) OR "Y" IN aqlFunction(...))`

**Confidence**: HIGH
**Source**: `src/jql.rs:~77-81`
**Trace**: Pass 3 BC-308, BC-308-R (R1)

---

#### BC-4.1.005: `validate_asset_key("CUST-5")` → Ok; `"CUST"` → Err; `"5-CUST"` → Err

**Confidence**: HIGH
**Source**: `src/jql.rs:~39-54`
**Subject**: Assets/CMDB
**Behavior**: ASCII alphanumeric prefix + `-` + ASCII digit suffix, both nonempty.
**Trace**: Pass 3 BC-309

---

#### BC-4.1.006: `extract_linked_assets` reads `[{label, objectKey}]` shape → `LinkedAsset{key, name}`

**Confidence**: HIGH
**Source**: `tests/cmdb_fields.rs:~86-118`
**Subject**: Assets/CMDB
**Behavior**: `"customfield_10191": [{"label": "Acme Corp", "objectKey": "OBJ-1"}]` → `LinkedAsset { name: Some("Acme Corp"), key: Some("OBJ-1"), ... }`.
**Trace**: Pass 3 BC-302; BC-1137c (R4)

---

#### BC-4.1.007: `extract_linked_assets` returns empty Vec for null custom field value

**Confidence**: HIGH
**Source**: `tests/cmdb_fields.rs:~120-146`
**Trace**: Pass 3 BC-303; BC-1137d (R4); BC-324 (R1)

---

### 4.2 Asset Search & View

#### BC-4.2.001: `assets search` discovers workspace ID first (cache or API); OAuth profiles MUST target the API gateway host, never the site host

**STATUS: AMENDED (2026-09-17, cycle-008 `oauth-surface-correctness`, ADR-0026 Decision 1, VP-OAUTH-GW-001)** — adds the OAuth 3LO gateway-routing invariant. Prior to this amendment the Behavior clause below described only the request shape (path + cache), leaving the HOST the request is addressed to undocumented; live OAuth use surfaced that `get_or_fetch_workspace_id` (and six sibling JSM `servicedeskapi` call sites, anchored here as the single canonical statement of the shared invariant) were built via `get_from_instance`/`post_to_instance`, which target `instance_url` unconditionally instead of routing OAuth traffic through the API gateway.

**Confidence**: HIGH
**Source**: `tests/assets.rs` (workspace-discovery test group); `src/api/assets/workspace.rs::get_or_fetch_workspace_id`
**Subject**: Assets/CMDB
**Behavior**: GET `/rest/servicedeskapi/assets/workspace` → `{values: [{workspaceId: "ws-123"}]}`. Cached as `WorkspaceCache` with 7d TTL. Cache hit → no HTTP.

**OAuth 3LO gateway-routing invariant (ADR-0026 Decision 1):** Under an OAuth (3LO) auth profile, the `GET /rest/servicedeskapi/assets/workspace` call above MUST be addressed via `base_url` (`https://api.atlassian.com/ex/jira/{cloudId}/...`, i.e. `client.get(...)`) — NEVER via `instance_url` (`https://{site}.atlassian.net/...`, i.e. `client.get_from_instance(...)`). This is the mirror image of ADR-0009 (`instance_url` is reserved for browser-facing `/browse/{key}` URLs only, never an API call); together ADR-0009 and ADR-0026 fully partition the legitimate use of both host variables — API calls always use `base_url`, browser URLs always use `instance_url`, nothing else is a valid use of either. The identical invariant applies to six sibling JSM `servicedeskapi` call sites, outside this BC's own Assets/CMDB subject area but sharing the exact same routing rule; they are anchored here, per ADR-0026 Decision 1's unified fix table, as the single canonical BC-level statement of the invariant rather than duplicated across `bc-X.8`/`bc-X.12`:

| File::Symbol | Command surface |
|---|---|
| `src/api/jsm/servicedesks.rs::list_service_desks` | `jr queue list/view`, `jr requesttype list/fields`, JSM attachment upload/download/delete (transitively, via `require_service_desk`/`get_or_fetch_project_meta`) |
| `src/api/jsm/request_types.rs::list_request_types` | `jr requesttype list` |
| `src/api/jsm/request_types.rs::get_request_type_fields` | `jr requesttype fields` |
| `src/api/jsm/queues.rs::list_queues` | `jr queue list` |
| `src/api/jsm/queues.rs::get_queue_issue_keys` | `jr queue view` |
| `src/api/jsm/requests.rs::create_jsm_request` | `jr issue create --request-type` |
| `src/api/assets/workspace.rs::get_or_fetch_workspace_id` | `jr assets search/view/schema/tickets` (this BC's own call site) |

None of these six sibling call sites' request/response SHAPE (payload, caching, error text) changes — this is a base-URL-only method swap (`get_from_instance`→`get`, `post_to_instance`→`post`), confirmed by ADR-0026/F1 code audit to be a no-op for every payload/caching contract already pinned by BC-X.8.004-010 and BC-X.12.001-008 (`cross-cutting.md`). Those BCs are intentionally NOT amended by this routing fix — their contracts are confirmed unaffected by regression test, not by a spec edit. `src/api/assets/objects.rs`/`linked.rs`/`schemas.rs`/`tickets.rs` (AQL/object/schema/enrichment paths, all via `client.get_assets`/`post_assets`) and `src/api/jsm/attachments.rs` (already builds URLs from `client.base_url()` directly) require NO code change — confirmed already gateway-correct.

**API-token invariant (why this fix is provably a no-op for API-token auth):** for an API-token (Basic auth) profile, `base_url() == instance_url()` (both resolve to the site's own host), so `get_from_instance`/`get` (and `post_to_instance`/`post`) are indistinguishable — the routing fix changes ZERO observable behavior for API-token users. It is exclusively a fix for OAuth (3LO) profiles, where the two hosts diverge.

**Verification**: VP-OAUTH-GW-001 — constructs the client via the existing `JiraClient::new_for_test_with_instance_url(base_url, instance_url, auth_header)` seam with `base_url != instance_url`, mounts a wiremock server at `base_url` only, and asserts the mocked gateway endpoint receives the request, for each of the 7 call sites listed above (one test case per site). A companion always-on assertion that the `instance_url` mock received zero requests guards against a future accidental revert to `get_from_instance`/`post_to_instance` at any of the 7 sites.

**Trace**: Pass 3 BC-310; BC-322 (R1); cycle-008 `oauth-surface-correctness` F2 spec evolution (2026-09-17), ADR-0026 Decision 1 — OAuth 3LO gateway-routing invariant added, unified 7-call-site fix table anchored here, VP-OAUTH-GW-001 attached. Qualitative test coverage: `src/api/assets/workspace.rs` unit tests plus a new wiremock integration-test group spanning `tests/assets.rs` and the sibling JSM test files (`tests/jsm_request_api.rs`, `tests/attachment_jsm.rs` transitively) exercising the `new_for_test_with_instance_url` seam.

---

#### BC-4.2.002: `client.search_assets(workspace_id, aql, limit, include_attrs)` POSTs to `/jsm/assets/workspace/<id>/v1/object/aql`

**Confidence**: HIGH
**Source**: `tests/assets.rs:~39-80, ~238-295`
**Subject**: Assets/CMDB
**Behavior**: Query params: `startAt=0`, `maxResults=25` (asset-specific page size, NOT 50), `includeAttributes=false|true`. Pagination advances `startAt` by 25 per page (offset, not cursor).
**Trace**: Pass 3 BC-316 (R1)

---

#### BC-4.2.003: `AssetsPage::is_last` accepts both bool and string-encoded bool `"true"`

**Confidence**: HIGH
**Source**: `tests/assets.rs:~140-170`
**Subject**: Assets/CMDB
**Behavior**: Custom deserializer handles `"isLast": true` AND `"isLast": "true"`.
**Trace**: Pass 3 BC-317 (R1)

---

#### BC-4.2.004: `client.get_asset(workspace_id, id, include_attrs=true)` GETs `/jsm/assets/workspace/<id>/v1/object/<oid>?includeAttributes=true`

**Confidence**: HIGH
**Source**: `tests/assets.rs:~172-203`
**Trace**: Pass 3 BC-318 (R1)

---

#### BC-4.2.005: `client.get_connected_tickets(workspace_id, oid)` GETs `/jsm/assets/workspace/<id>/v1/objectconnectedtickets/<oid>/tickets`

**Confidence**: HIGH
**Source**: `tests/assets.rs:~205-236`
**Behavior**: Returns `{tickets: [...], allTicketsQuery: Option<String>}`. `tickets[].status.colorName` present.
**Trace**: Pass 3 BC-319 (R1)

---

#### BC-4.2.006: `assets tickets <KEY> --status PROG` ambiguous → exit 64 `Ambiguous status` + both candidates

**Confidence**: HIGH
**Source**: `tests/assets.rs:~1579-1684`
**Behavior**: Workspace → resolve_object_key → connected_tickets endpoint. `partial_match` returns `Ambiguous` on two-match. Literal stderr `"Ambiguous status"`, `"In Progress"`, `"Progressing"`.
**Trace**: Pass 3 BC-320 (R1)

---

#### BC-4.2.007: `assets schema <TYPE-SUBSTR>` ambiguous → exit 64 `Ambiguous type` + NO per-type attribute fetch

**Confidence**: HIGH
**Source**: `tests/assets.rs:~1695-1799`
**Behavior**: `Mock::expect(0)` on per-type attribute endpoints. Short-circuit before expensive fetch.
**Trace**: Pass 3 BC-321 (R1)

---

#### BC-4.2.008: `assets tickets --open` filters `status.colorName != "green"` (client-side)

**Confidence**: MEDIUM
**Source**: `src/cli/assets/tickets.rs::filter_tickets`; unit tests
**Behavior**: Tickets with no status are included under `--open`, excluded under `--status`. Client-side color filter.
**Trace**: Pass 3 BC-314

---

#### BC-4.2.009: `assets tickets --open` and `--status` clap conflict

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs:~51-58`
**Trace**: Pass 3 BC-315

---

### 4.3 Asset Enrichment (MUST-FIX: NFR-R-E)

#### BC-4.3.001: Asset enrichment `resolved` HashMap MUST be keyed by `(workspace_id, oid)` not `oid` alone [MUST-FIX: NFR-R-E]

**Confidence**: HIGH
**Source**: `src/cli/issue/list.rs:~440, ~446, ~449, ~456` (BUG SITES)

> **MUST-FIX (HIGH — NFR-R-E):** Current code at line ~446 creates `resolved: StdHashMap<String, _>` keyed
> by `oid` alone. Multi-workspace tenants sharing `oid` values across workspaces experience
> last-write-wins mis-attribution. The separate `api/assets/linked.rs::enrich_assets` is CORRECT
> (uses composite key). This contract describes the FIXED behavior.

**Spec contract (fixed behavior):**
- `to_enrich: HashMap<(String, String), ()>` — correctly uses composite `(wid, oid)` key ✓ (already correct at line ~398)
- `resolved: HashMap<(String, String), (String, String, String)>` — MUST ALSO use composite key (currently broken)
- Line ~449: `resolved.insert((wid.clone(), oid.clone()), ...)` — workspace preserved
- Line ~456: `resolved.get(&(wid.clone(), oid.clone()))` — workspace-qualified lookup

**Effects**: Multi-workspace tenants see correct asset names. Single-workspace tenants unaffected.
**Holdout:** H-036 — Multi-workspace asset HashMap composite key.
**Trace**: Pass 3 BC-147 (R1); NFR-R-E; Pass 4 R4 §1.4

---

#### BC-4.3.002: `enrich_assets(client, &mut [LinkedAsset])` resolves ONLY assets with `id.is_some() && key.is_none() && name.is_none()`

**Confidence**: HIGH
**Source**: `tests/cmdb_fields.rs:~148-189`
**Subject**: Assets/CMDB
**Behavior**: Only id-only assets are re-fetched. Assets with name/key already populated skip the GET. After enrichment: `key = Some("OBJ-88")`, `name = Some("Acme Corp")`, `asset_type = Some("Client")`.
**Trace**: Pass 3 BC-304; BC-323 (R1); BC-1137e (R4)

---

#### BC-4.3.003: `LinkedAsset::display()` falls back to `#<id> (run 'jr init' to resolve asset names)` when only id present

**Confidence**: HIGH
**Source**: `src/types/assets/linked.rs::tests::display_id_fallback_with_hint`
**Trace**: Pass 3 BC-305

---

### 4.4 Asset Error Handling

#### BC-4.4.001: `assets search` 5xx → exit 1 + `API error (500)` + no panic

**Confidence**: HIGH
**Source**: `tests/assets_errors.rs:~21-64`; `tests/assets_errors.rs:~20-153` (BC-1136 R4)
**Subject**: Assets/CMDB
**Behavior**: Workspace discovery is first call; errors there propagate same as direct-issue endpoints.
**Trace**: Pass 3 BC-311; BC-1136 (R4)

---

#### BC-4.4.002: `assets search` 401 → exit 2 + `Not authenticated` + `jr auth login`

**Confidence**: HIGH
**Source**: `tests/assets_errors.rs:~67-113`
**Trace**: Pass 3 BC-312

---

#### BC-4.4.003: `assets search` network drop → exit 1 + `Could not reach`

**Confidence**: HIGH
**Source**: `tests/assets_errors.rs:~116-153`
**Trace**: Pass 3 BC-313

---

## Key Invariants

- AQL attribute for object key: capital `Key` (NOT `objectKey`) — CLAUDE.md gotcha
- `aqlFunction()` LHS: field NAME, not `cf[ID]` or `customfield_NNNNN` — CLAUDE.md gotcha
- Asset page size: 25 (NOT 50 like Jira)
- `is_last` is bool-or-string (tolerance via custom deserializer)
- Workspace ID: discovered via JSM REST, cached 7d per profile
