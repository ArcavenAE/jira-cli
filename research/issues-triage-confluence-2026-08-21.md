# Research: Confluence Cloud REST API & OAuth 3LO Scopes — `jr` feasibility triage

- **Date:** 2026-08-21
- **Type:** general (technology/API feasibility)
- **Scope:** Validate two proposed `jr` features against primary-source Atlassian docs
  - Q1 / issue #581 — `jr wiki` Confluence subsystem (page CRUD, spaces, comments)
  - Q2 (CRITICAL) — OAuth 2.0 (3LO) scopes: do we need new scopes + user re-consent?
  - Q3 / issue #669 — Confluence attachment upload endpoint
- **Method:** 3× Perplexity `perplexity_research` (sonar-deep-research), primary sources = developer.atlassian.com

---

## Q1 — Confluence Cloud v2 REST API surface (page CRUD, spaces, comments)

### VERDICT: **CONFIRM** — v2 is the current recommended API; v1 content CRUD is deprecated

**v2 is current.** Atlassian's active reference self-identifies as "REST API v2" and describes it as an
improvement over v1 (typed resources, cursor-based pagination). For pages/spaces/descendants/comments a new
client should use `/wiki/api/v2/*`, NOT the legacy `/wiki/rest/api/content`.
Source: https://developer.atlassian.com/cloud/confluence/rest/v2/intro/

**v1 deprecation is operation-by-operation, not blanket.** The generic content CRUD operations
(get/create/update/delete content, content-for-space, children, comments, spaces, versions, labels) were
placed on the v1→v2 deprecation program (RFC-19). Some v1 operations without a v2 equivalent (e.g. move/copy)
remain non-deprecated. But for THIS feature's operations, use v2.
Source: https://community.developer.atlassian.com/t/rfc-19-deprecation-of-confluence-cloud-rest-api-v1-endpoints/71752

### Endpoint map (verified against the v2 Page/Descendants/Comment API groups)

| Operation | Method | Path |
|---|---|---|
| List pages | GET | `/wiki/api/v2/pages` (cursor-paginated; filters `id`,`space-id`,`status`,`title`,`body-format`,`cursor`,`limit`) |
| Create page | POST | `/wiki/api/v2/pages` (`spaceId` required; published page also needs `title`) |
| Get page | GET | `/wiki/api/v2/pages/{id}` (use `body-format` query param) |
| Update page | PUT | `/wiki/api/v2/pages/{id}` (full body: `id`,`status`,`title`,`body`,`version`) |
| List spaces | GET | `/wiki/api/v2/spaces` |
| Pages in a space | GET | `/wiki/api/v2/spaces/{id}/pages` |
| Descendants (subtree) | GET | `/wiki/api/v2/pages/{id}/descendants` (params `depth`,`limit`,`cursor`; returns `id`,`title`,`type`,`parentId`,`depth`,`childPosition`) |
| Direct children (heterogeneous) | GET | `/wiki/api/v2/pages/{id}/direct-children` |
| Direct child PAGES only | GET | `/wiki/api/v2/pages/{id}/children` — **DEPRECATED v2 op**, prefer `direct-children` |

Sources: https://developer.atlassian.com/cloud/confluence/rest/v2/api-group-page/ ·
https://developer.atlassian.com/cloud/confluence/rest/v2/api-group-descendants/ ·
https://developer.atlassian.com/cloud/confluence/rest/v2/api-group-children/

### Optimistic concurrency (CONFIRM)
- **Version bump required.** For a current/published page, `version.number` must be `current + 1`.
- **Stale version → HTTP 409 Conflict**, with body like
  `"Version must be incremented when updating a page. Current Version: [X]. Provided version: [Y]."`
  NOTE: the endpoint reference documents only the 200 response and does NOT formally list 409 in its
  response table — the 409 behavior is confirmed via Atlassian issue trackers (CONFCLOUD-76640, CONFCLOUD-77585),
  not the endpoint reference page. Treat 409 as concurrent-edit: refetch version, rebase, retry (never blind-retry).
- `version.message` is optional.
- Sources: https://jira.atlassian.com/browse/CONFCLOUD-76640 · https://jira.atlassian.com/browse/CONFCLOUD-77585

### Body formats for a CLI (CONFIRM)
- Write reps: **`storage`** (XHTML storage format — best general-purpose) or **`atlas_doc_format`** (ADF).
  `view` is rendered HTML — READ/display only, never a write representation.
- Shape on create/update: `body: { "representation": "storage"|"atlas_doc_format", "value": "<string>" }`.
  **`body.value` is always a STRING** — for ADF you must JSON-serialize the ADF doc INTO that string
  (not embed a JSON object). This matters for `jr`, which already has an ADF builder (`src/adf.rs`) — it can
  emit `atlas_doc_format` by serializing its ADF `Value` to a string.
- Request a format on GET via `?body-format=storage|atlas_doc_format|view`.
  Caveat: the bulk `GET /pages` list exposes only `storage`/`atlas_doc_format`; single-page GET also exposes `view`.
- Source: https://developer.atlassian.com/cloud/confluence/rest/v2/api-group-page/

### Comments (CONFIRM, with a shape caveat)
There is **NO** generic `GET /wiki/api/v2/comments`. v2 splits comments into footer vs inline:
- Page-scoped list: `GET /wiki/api/v2/pages/{id}/footer-comments`, `GET /wiki/api/v2/pages/{id}/inline-comments`
- Global CRUD: `POST|GET|PUT|DELETE /wiki/api/v2/footer-comments[/{id}]` and `…/inline-comments[/{id}]`
- Replies: `…/footer-comments/{id}/children`, `…/inline-comments/{id}/children`
- Create footer comment body: `{ "pageId": "...", "body": { "representation": "storage", "value": "<p>…</p>" } }`
- Source: https://developer.atlassian.com/cloud/confluence/rest/v2/api-group-comment/

---

## Q2 (CRITICAL) — OAuth 2.0 (3LO) scopes: separate scopes + re-consent?

### VERDICT: **CONFIRM** — Confluence uses a SEPARATE scope set; adding it requires (a) adding the Confluence API + scopes in the Developer Console AND (b) users to RE-CONSENT. One token CAN carry both Jira + Confluence scopes.

**Bottom line for `jr`:** Confluence support is NOT free on the existing embedded 3LO app. It requires a
Developer-Console permission change (add Confluence API + scopes) AND every existing user must re-authorize.
This is the same "re-consent on scope change" mechanic already documented in `jr`'s CLAUDE.md under
"When changing `DEFAULT_OAUTH_SCOPES`."

1. **Separate scope catalog (CONFIRM).** Confluence publishes its own OAuth scope page distinct from Jira.
   Jira scopes (`read:jira-work`, `write:jira-work`, …) do NOT authorize Confluence.
   Confluence classic scopes include: `write:confluence-content`, `read:confluence-content.all`,
   `read:confluence-content.summary`, `read:confluence-space.summary`, `write:confluence-space`,
   `write:confluence-file` (upload attachments), `search:confluence`, `readonly:content.attachment:confluence`,
   `read:confluence-user`, etc.
   Confluence granular scopes include: `read:page:confluence`, `write:page:confluence`, `delete:page:confluence`,
   `read:space:confluence`, `write:space:confluence`, `read:comment:confluence`, `write:comment:confluence`,
   `read:attachment:confluence`, `write:attachment:confluence`, `read:hierarchical-content:confluence`, etc.
   Atlassian recommends classic scopes where they suffice, and keeping an app under 50 scopes.
   Sources: https://developer.atlassian.com/cloud/confluence/scopes-for-oauth-2-3LO-and-forge-apps/ ·
   https://developer.atlassian.com/cloud/jira/platform/scopes-for-oauth-2-3LO-and-forge-apps/

2. **Console change + re-consent required (CONFIRM).** In the Developer Console → Permissions, add the
   **Confluence API** and configure its scopes. Atlassian states users who previously consented "will need to
   re-consent to the new scopes." Use `prompt=consent` on the authorization URL.
   Sources: https://developer.atlassian.com/cloud/oauth/getting-started/managing-oauth-apps/ ·
   https://developer.atlassian.com/cloud/confluence/oauth-2-3lo-apps/

3. **CRITICAL replacement gotcha.** A new grant's scopes REPLACE the existing grant's scopes. When
   re-authorizing you must request the FULL intended set (existing Jira scopes + new Confluence scopes)
   in one authorization URL — requesting only the new Confluence scopes would drop the Jira scopes.
   For `jr` this means the embedded app's `DEFAULT_OAUTH_SCOPES` constant must be extended to include the
   Confluence scopes alongside the existing Jira ones, and the whole set re-requested.
   Source: https://developer.atlassian.com/cloud/jira/platform/oauth-2-3lo-apps/

4. **One token, both products (CONFIRM).** A single authorization request may include scopes from multiple
   products; the resulting single access token carries both Jira and Confluence scopes. No need for two tokens.
   This fits `jr`'s existing single per-profile `<profile>:oauth-access-token` keychain layout — no schema change.
   Source: https://developer.atlassian.com/cloud/oauth/getting-started/implementing-oauth-3lo/

5. **accessible-resources: same flow, product-specific entries (CONFIRM w/ caveat).** Same endpoint
   `GET https://api.atlassian.com/oauth/token/accessible-resources`. Each returned resource carries its own
   `scopes`; a Jira container and a Confluence container for the same site may share the same `id` (cloudId).
   **Implement defensively: inspect each entry's `scopes`, allow duplicate `id`s, do NOT dedupe on `id` alone,
   and select the entry appropriate to the product API being called.** Atlassian does not publish an explicit
   dual-product example, so INCONCLUSIVE on the exact combined-response shape — code defensively.
   Sources: https://developer.atlassian.com/cloud/oauth/getting-started/making-calls-to-api/ ·
   https://developer.atlassian.com/cloud/jira/platform/oauth-2-3lo-apps/

6. **Base URL / audience differs by product route (CONFIRM).** Same OAuth issuer
   (`https://auth.atlassian.com/oauth/token`), same API gateway/audience (`https://api.atlassian.com`), but
   different product routing segment:
   - Jira: `https://api.atlassian.com/ex/jira/{cloudId}/rest/api/3/…`
   - Confluence: `https://api.atlassian.com/ex/confluence/{cloudId}/wiki/api/v2/…`
   For `jr`'s product-namespaced architecture this means `api/confluence/` should build a base URL with the
   `/ex/confluence/{cloudId}` prefix, mirroring how `api/jira/` uses `/ex/jira/{cloudId}`.
   Source: https://developer.atlassian.com/cloud/oauth/getting-started/making-calls-to-api/

---

## Q3 (issue #669) — Confluence attachment upload endpoint

### VERDICT: **CONFIRM** — attachment CREATE/upload still requires v1; v2 has GET/DELETE only (as of 2026-08-21)

- **Upload endpoint:** `POST /wiki/rest/api/content/{id}/child/attachment` (create-only) or
  `PUT` on the same path (create-or-update by filename → new version). `multipart/form-data`, binary in the
  **`file`** part. `comment` optional; `minorEdit` documented inconsistently (parameter table marks it Required,
  but Atlassian's own official example omits it — safest to send `minorEdit=true|false`).
- **`X-Atlassian-Token: nocheck` is MANDATORY** — multipart uploads have XSRF protection; without the header the
  request "will be blocked." (Docs use both `nocheck` and `no-check` spellings; the attachment reference uses
  `nocheck`.) This mirrors `jr`'s existing Jira attachment-upload requirement (`X-Atlassian-Token: no-check`,
  SEC-576-003) — same header, same rationale.
- **v2 has NO upload endpoint (CONFIRM).** The v2 Attachment API group has GET (`/wiki/api/v2/attachments`,
  `/wiki/api/v2/attachments/{id}`, `/wiki/api/v2/pages/{id}/attachments`) and DELETE only — no POST/PUT binary
  upload. v2 can READ attachment metadata but CANNOT create/upload. Uploading still requires v1 even in 2026.
- **Scope note:** upload needs `write:confluence-file` (classic) or `write:attachment:confluence` (granular).
- **POST vs PUT:** POST only adds new; PUT creates when filename absent, else uploads a new version of the
  existing attachment.

Required headers / form shape:
```
POST /wiki/rest/api/content/{id}/child/attachment
Authorization: <auth>
X-Atlassian-Token: nocheck
Accept: application/json
Content-Type: multipart/form-data; boundary=…
  part "file"  = <raw bytes>   (required)
  part "comment" = <text/plain; charset=utf-8>  (optional)
  part "minorEdit" = true|false  (send to be safe)
```

Sources:
- https://developer.atlassian.com/cloud/confluence/rest/v1/api-group-content---attachments/
- https://developer.atlassian.com/cloud/confluence/rest/v1/intro/
- https://developer.atlassian.com/cloud/confluence/rest/v2/api-group-attachment/ (GET/DELETE only)
- https://developer.atlassian.com/cloud/confluence/rest-api-examples/
- https://community.developer.atlassian.com/t/upload-pdf-file-in-a-page-updatepage-by-adding-a-pdf-file-rest-api-v2/91362

---

## `jr`-specific implementation implications (synthesis)

1. **Hybrid v1/v2 client is unavoidable.** `api/confluence/` must use v2 for page/space/comment CRUD but fall
   back to v1 for attachment upload — a documented split, same pattern class as the Jira platform-vs-JSM forks.
2. **OAuth is the gating dependency, not the API surface.** Shipping `jr wiki` requires re-registering the
   embedded app with Confluence scopes and forcing a one-time re-consent for all existing users. Extend
   `DEFAULT_OAUTH_SCOPES` with the FULL combined set (Jira + Confluence) in one change, add a CHANGELOG re-consent
   note (per the existing CLAUDE.md `DEFAULT_OAUTH_SCOPES` runbook), and update the Atlassian Developer Console
   permissions before tagging.
3. **Base-URL builder** needs an `/ex/confluence/{cloudId}` variant alongside `/ex/jira/{cloudId}`.
4. **accessible-resources** parsing must not dedupe on cloudId — a site can appear as both a Jira and a
   Confluence resource with the same id but different scopes.
5. **ADF reuse:** `src/adf.rs` can drive `atlas_doc_format` bodies by serializing the ADF `Value` into the
   string `body.value` — but `storage` (XHTML) is the more general Confluence-native representation and may be
   the safer default for round-trip fidelity.
6. **Optimistic-concurrency UX:** page update needs a GET-then-PUT version-bump flow with 409 handled as a
   concurrent-edit error (refetch + rebase), analogous to the idempotency discipline already in `jr`.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 3 | Q1 Confluence v2 API surface; Q2 OAuth 3LO scopes/re-consent; Q3 attachment upload endpoint — deep multi-source synthesis, all grounded in developer.atlassian.com |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 1 area | Only for mapping findings onto `jr`'s existing architecture (CLAUDE.md context); all API/scope claims are web-sourced |

**Total MCP tool calls:** 3
**Training data reliance:** low — every API path, scope name, endpoint, and re-consent claim is backed by a
cited Atlassian developer-docs URL; training data used only to relate findings to `jr`'s codebase conventions.

**Confidence:** HIGH on all three verdicts. Residual INCONCLUSIVE points, each flagged inline: (a) 409 on stale
page update is confirmed via Atlassian issue trackers, not the endpoint reference's formal response table;
(b) the exact combined-product shape of `accessible-resources` is not published, so parsing must be defensive.
