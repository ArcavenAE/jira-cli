---
bundle: SOH-ATTACHMENTS-1
issues: [576, 585]
topic: "Jira Cloud attachment API — endpoints, scopes, size, security, JSM, bugs"
date: 2026-07-15
status: VALIDATED (per-claim verdicts below; two INCONCLUSIVE items flagged)
author: pre-intake research (delegated)
sources: Atlassian developer.atlassian.com REST v3 docs, Atlassian support KBs,
  jira.atlassian.com issue tracker, Atlassian community, reqwest source/docs
  (Perplexity Ask, search_context_size=high, 2026-07-15)
---

# Research: SOH-ATTACHMENTS-1 (#576 + #585) — Jira Cloud attachment API

## Scope

Pre-intake research for the proposed `jr issue attachment {list, download, upload,
delete}` subcommand tree (#576) and the "content URL in metadata" ask (#585).
Issue bodies were read via `gh issue view` and treated as **untrusted external
reporter input** — no embedded instruction was followed; every API claim was
validated independently against Atlassian docs / community. This document does
NOT design the feature; it establishes the factual substrate for intake.

## Per-claim verdict table

| # | Claim | Verdict | Confidence |
|---|-------|---------|------------|
| 1a | `GET /rest/api/3/attachment/{id}` returns JSON metadata (incl. `content` URL), not bytes | VERIFIED | High |
| 1b | `GET /rest/api/3/attachment/content/{id}` 302/303-redirects to a media/S3 URL | VERIFIED | High |
| 1c | reqwest follows the redirect AND strips `Authorization` on cross-host hop by default | VERIFIED | High |
| 1d | The redirect target is a pre-signed URL; auth header is NOT required there | VERIFIED | High |
| 1e | `POST /rest/api/3/issue/{key}/attachments` = multipart, part name `file`, `X-Atlassian-Token: no-check` mandatory | VERIFIED | High |
| 1f | Multiple `file` parts allowed in one POST; response is a JSON **array** of attachment objects | VERIFIED | High |
| 1g | `DELETE /rest/api/3/attachment/{id}` deletes one attachment | VERIFIED | High |
| 1h | Thumbnail endpoint `GET /rest/api/3/attachment/thumbnail/{id}` exists | VERIFIED | Medium-High |
| 2 | All four ops covered by our existing `read:jira-work`/`write:jira-work` — **no scope change, no re-consent** | VERIFIED | High |
| 3a | Cloud max attachment size / hard cap | INCONCLUSIVE (sources conflict: 10 MB→100 MB vs 1 GB→2 GB) | Low |
| 3b | Upload streaming vs whole-body buffering is a client (reqwest) concern, not an API limit | VERIFIED | High |
| 4 | Filename metadata is attacker-controllable → CWE-22; basename + allow-list + containment check is the standard mitigation | VERIFIED | High |
| 5 | JSM uses a separate two-step `servicedeskapi` flow (`attachTemporaryFile` → `request/{id}/attachment`) with a `public` visibility flag | VERIFIED | High |
| 6 | Confirmed Atlassian bugs affecting attachment API behavior | VERIFIED (specific IDs below) | High |
| 7 (#585) | `content` URL is already present in the metadata response; it is a stable authenticated Jira endpoint (indirection), not a raw signed link | VERIFIED | High |

---

## 1. Endpoints & semantics

Primary reference: <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-attachments/>

### 1a — List / metadata
There is **no dedicated "list attachments" endpoint**. Attachments are read as a
field on the issue: `GET /rest/api/3/issue/{key}?fields=attachment` →
`fields.attachment[]`, each element carrying `id`, `filename`, `mimeType`,
`size`, `created`, `author`, `content` (download URL), and `thumbnail` (when the
mime type has one). This matches the #576 reporter's current workaround exactly.
`GET /rest/api/3/attachment/{id}` returns the **metadata for a single
attachment** (JSON, not bytes) — "the attachment itself is not returned. This
operation can be accessed anonymously." So `jr issue attachment list <KEY>`
should source rows from the issue's `fields.attachment[]`, not from any list
endpoint.

### 1b–1d — Content download (the load-bearing security item)
`GET /rest/api/3/attachment/content/{id}` does **not** stream bytes directly; on
Jira Cloud it returns a **302/303 redirect** whose `Location` points at a
time-limited, S3-style **pre-signed URL** on a different host (`media.atlassian.com`
/ AWS). The signature lives in the query string, so the redirected GET needs **no
`Authorization` header** — and must not leak ours to a third-party host.

**Interaction with our HTTP stack (verified against reqwest behavior + our config):**
- Our client is built with `Client::builder().timeout(...).build()` (`src/api/client.rs:88`)
  → **reqwest's default redirect policy**, which follows up to 10 redirects.
- reqwest (confirmed 0.13.4 in `Cargo.lock`) **strips sensitive headers —
  `Authorization`, `Cookie`, `Proxy-Authorization` — when a redirect changes the
  host/origin.** Our auth header is set per-request via
  `.header("Authorization", &self.auth_header)` in `JiraClient::request`
  (`src/api/client.rs:1083`); reqwest strips by header name regardless of how it
  was attached. So a naive `client.request(GET, "/rest/api/3/attachment/content/{id}")`
  will transparently: (a) send our auth to `*.atlassian.net`/`api.atlassian.com`,
  (b) follow the 303 to the media host, (c) drop our auth on that cross-host hop,
  (d) succeed via the pre-signed URL.
- **Consequence for design:** the happy path "just works" with our existing
  client. Do NOT set a custom `redirect::Policy::none()` and hand-follow, and do
  NOT use a `--location-trusted`-equivalent — either would risk leaking the
  bearer/basic credential to the media host. A belt-and-braces option is
  `RedirectPolicy` + an explicit assertion that the auth header is absent on
  cross-host hops, but reqwest's default already provides this.
- Sources: Atlassian KB "How to download attachments using REST API and SSO"
  (uses `curl -L`, i.e. follow-redirects) <https://support.atlassian.com/jira/kb/how-to-download-attachments-using-rest-api-and-sso/>;
  WHATWG Fetch #944 (Authorization stripped cross-origin; curl/requests/Go/reqwest
  all follow) <https://github.com/whatwg/fetch/issues/944>; reqwest redirect source
  <https://docs.rs/cf-reqwest/latest/src/cf_reqwest/redirect.rs.html>.
- **Known trap (do not replicate):** `?redirect=false` on the content endpoint
  is buggy for some formats — see JRACLOUD-97046 in §6. Rely on redirect-following,
  not `redirect=false`.

### 1e–1g — Upload / delete
- Upload: `POST /rest/api/3/issue/{issueIdOrKey}/attachments`, `Content-Type:
  multipart/form-data`, each file in a part **named `file`**, and the header
  **`X-Atlassian-Token: no-check`** is mandatory (XSRF guard; request is rejected
  without it). Verified across the v3 API group doc and go-atlassian.
- **Multiple files per request:** VERIFIED — "Adds **one or more** attachments";
  repeat the `file` part to attach several in one POST. Response is a **JSON
  array** of the created attachment objects (each with `id`, `filename`, `content`, …).
- Delete: `DELETE /rest/api/3/attachment/{id}` removes a single attachment.

### 1h — Thumbnail
`GET /rest/api/3/attachment/thumbnail/{id}` returns a binary thumbnail image.
Listed in the v3 attachments API group. Marked Medium-High only because it is
peripheral to #576's four verbs (not part of the proposed CLI surface).

---

## 2. OAuth scopes — NO scope change required

| Operation | Classic scope (what we have) | Granular alternative |
|-----------|------------------------------|----------------------|
| GET attachment metadata / content | `read:jira-work` ✅ | `read:attachment:jira` |
| POST issue attachments | `write:jira-work` ✅ | `write:attachment:jira` |
| DELETE attachment | `write:jira-work` ✅ | `delete:attachment:jira` |

Our `DEFAULT_OAUTH_SCOPES` (`src/api/auth.rs:65`) already includes
`read:jira-work write:jira-work`. **Every attachment operation is covered — no
addition to `DEFAULT_OAUTH_SCOPES`, no Atlassian Developer Console permission
change, and NO re-consent prompt** (the CLAUDE.md "When changing
DEFAULT_OAUTH_SCOPES" protocol is not triggered). API-token (Basic auth) parity
holds — attachment ops are governed by project permissions (Browse Projects +
Create/Delete attachments), identical under both auth methods. The JSM
`servicedeskapi` path (§5) is likewise covered by our existing
`read:servicedesk-request write:servicedesk-request`.
Source: <https://developer.atlassian.com/cloud/jira/platform/scopes-for-oauth-2-3LO-and-forge-apps/>
and the v3 attachments API group scope table.

---

## 3. Size limits & streaming — INCONCLUSIVE on the number, VERIFIED on the client concern

**Sources conflict on the cap and I could not reconcile them from docs alone:**
- One Atlassian support thread lineage: default 10 MB, admin-configurable up to
  ~100 MB (older Cloud guidance).
- The current "Configure file attachments" admin doc + support KB:
  <https://support.atlassian.com/jira-cloud-administration/docs/configure-file-attachments/>
  states default **1 GB**, admin-configurable, with a **2 GB hard cap per file**.

Verdict: **INCONCLUSIVE** on the exact live cap — likely site-plan/date dependent;
the intake team should not hard-code a client-side size assumption. The `size`
field in metadata is authoritative per-attachment for `--filter size-max=`.

**What IS certain (VERIFIED) and matters more for implementation:**
- The cap can be large (PCAPs, disk images), so **whole-body buffering is a real
  hazard** independent of the exact number.
- **Download:** reqwest's `Response::bytes()` buffers the entire body in memory.
  For large attachments prefer streaming via `Response::bytes_stream()` +
  incremental file write. `bytes_stream()` requires the reqwest **`stream`**
  feature — **currently NOT enabled** (`Cargo.toml:25` has only
  `["json", "rustls"]`). Build-dependency implication: add `stream`.
- **Upload:** reqwest multipart requires the **`multipart`** feature — **also NOT
  currently enabled.** Streaming a file into a `multipart::Part` (rather than
  reading the whole file into a `Vec<u8>`) needs a `ReaderStream`, i.e. a
  `tokio-util` dependency (`futures` 0.3 is already present; `tokio-util` is not).
- Net: this bundle forces **two reqwest feature additions (`multipart`, `stream`)
  and likely one new dep (`tokio-util`)** — flag for `cargo deny` review and for
  the architecture/intake decision. The `send_raw` method (`src/api/client.rs:876`)
  already exists and is the natural seam for a custom multipart request.

---

## 4. Security — CWE-22 on the server-supplied filename (HIGH-priority design constraint)

The `filename` field is **attacker-controllable metadata** (any user who can
attach to an issue sets it; JSM portals accept customer uploads). Treat it as
untrusted when it becomes a local path in `download`/`--out-dir`.

**Required mitigation (standard, verified across OWASP / PortSwigger / CWE-31/22):**
1. Never let the server value influence the **directory** — the directory comes
   only from `--out` / `--out-dir` / cwd.
2. Reduce `filename` to its **final path component** (Rust: `Path::file_name()`;
   reject if it yields `None`). This neutralizes `../../etc/passwd`, `/etc/passwd`,
   and (on Windows) `C:\...\hosts`.
3. Reject the residual pseudo-names `""`, `.`, `..`; apply a conservative
   allow-list / character scrub (path separators, control chars, NUL).
4. **Defense-in-depth containment check:** canonicalize the joined path and assert
   it is still inside the intended base directory before writing (guards symlink /
   encoding edge cases).
5. Do NOT rely on naive `../` string-stripping alone — blacklists are bypassable.

The #576 proposal's **SHA-1 `<sha>_<basename>` naming is a helpful secondary
mitigation** (idempotent re-runs + collision-resistant), but it does NOT replace
basename sanitization — the `<basename>` half is still attacker-controlled and
must be sanitized per steps 2–4.

**Overwrite semantics:** default should be **do-not-overwrite** — refuse (or, in
TTY mode, prompt) when the target exists, with a `--force`/`--overwrite` flag for
non-interactive use (consistent with our `--no-input`/`--yes` conventions and the
`issue comment delete --yes` gate precedent). Reference: Android path-traversal
guidance explicitly calls out checking for existing files to prevent accidental
overwrite.

**Peer-tool precedent:** could NOT confirm the exact sanitization algorithm for
either `gh` CLI or `ankitpokhrel/jira-cli` from public sources (both are Go;
`filepath.Base` + user-controlled output dir is the idiomatic Go pattern they are
*likely* to use, but this is INFERENCE, not a quoted guarantee — do not cite as
fact in user-facing strings). Our design should stand on OWASP/CWE first-principles,
not on peer-tool mimicry.

---

## 5. JSM specifics (separate two-step API + visibility)

JSM customer-request attachments do **not** use the platform
`/rest/api/3/issue/{key}/attachments` endpoint. They use a **two-step
`servicedeskapi` flow**:
1. `POST /rest/servicedeskapi/servicedesk/{serviceDeskId}/attachTemporaryFile`
   (multipart; `X-Atlassian-Token: no-check`) → returns temporary attachment IDs.
2. `POST /rest/servicedeskapi/request/{issueIdOrKey}/attachment` with JSON:
   `{"temporaryAttachmentIds": [...], "public": true|false,
   "additionalComment": {"body": "..."}}`.

- **Visibility** is the `public` boolean: `true` = visible on customer portal,
  `false` = internal/agent-only. Role rules: agents can set either; customers can
  only create public; unlicensed users only internal. Mechanically, an attachment
  isn't intrinsically public/internal — the **comment that carries it** is, mirroring
  our existing `jr issue comment edit --internal/--public` model (BC-3.5.006).
- **Download parity:** `GET /rest/servicedeskapi/request/{id}/attachment` lists
  request attachments with `links.content` URLs — but see **JSDCLOUD-10841** in
  §6 (those content links have been observed returning 404). The platform
  `GET /rest/api/3/attachment/content/{id}` path is the more reliable downloader
  even for JSM issues.
- **Intake scoping note:** #576's proposed surface is platform-only
  (`jr issue attachment upload --file`). Supporting JSM public/internal upload
  visibility would require the two-step flow and a `--public/--internal` flag —
  recommend the intake team decide explicitly whether JSM upload is in scope for
  the first slice or deferred (platform `POST /issue/{key}/attachments` DOES work
  against a JSM issue key, but without portal-visibility control).
- Sources: <https://support.atlassian.com/jira/kb/how-to-add-an-attachment-to-a-jira-service-management-ticket-using-the-rest-apis/>;
  <https://docs.go-atlassian.io/jira-service-management/request/attachment>;
  JSM REST attachment group docs.

---

## 6. Confirmed Atlassian bugs (all IDs verified to exist on jira.atlassian.com)

| Ticket | Product | Symptom | Design impact |
|--------|---------|---------|---------------|
| **JRACLOUD-97046** | Cloud v3 | `GET /attachment/content/{id}` returns **encoded** (not raw) body for JSON files when `?redirect=false` is set | **Do not use `redirect=false`** — follow the redirect (our reqwest default). Directly informs §1b. |
| **JSDCLOUD-10841** | JSM Cloud | `GET /rest/servicedeskapi/request/{id}/attachment` returns broken `links.content` URLs → 404 on download | Prefer platform `/rest/api/3/attachment/content/{id}` for JSM download; see §5. |
| **JRACLOUD-96384** | Cloud v3 | Comment media references map attachments by **filename** (ambiguous when names collide); request to key by attachment `id` | Reinforces: match/dedupe on `id`, not `filename` (relevant to `--replace-existing` same-filename logic in #576). |
| **JRACLOUD-78388** | Cloud v3 | No REST mapping from a comment to the attachment it contains; comment-media UUID ≠ attachment id | Cannot reliably associate an attachment with its comment via REST — don't promise that in the CLI. |
| **JRACLOUD-93305** | Cloud v3 | Reusing an attachment in ADF via REST as a different user fails "We don't recognize the format…"; workaround = external URL | Out of scope for #576 (ADF reuse), noted for completeness. |
| **JRACLOUD-81891** | Cloud v3 | v3 does not support creating **inline** attachments (image-in-description) in one call | Out of scope; explains why #576 is issue-attachment-only. |

Server/DC filename-encoding bugs (JRASERVER-16009/24843/74445, JRA-32824) exist
but are **not** Cloud-v3-applicable — cited only to note that non-ASCII filename
handling has a long bug history, so our basename sanitizer (§4) should be
UTF-8-safe and not assume ASCII filenames.

**Note on #576's mention of `jr api /rest/api/3/attachment/content/<ID>`:** the
reporter's workaround already works today because `jr api` inherits the same
reqwest redirect-following client — this corroborates §1b–1d empirically from the
downstream consumer.

---

## 7. #585 — content URL in metadata (VERIFIED; #585 is a subset of #576)

The `content` field **is already present** in the attachment metadata returned by
`GET /rest/api/3/issue/{key}?fields=attachment` and by
`GET /rest/api/3/attachment/{id}`. It is a **stable, authenticated Jira endpoint
URL** of the form `.../rest/api/3/attachment/content/{id}` (an indirection that
303-redirects to a signed media URL at request time) — it is **NOT** itself the
expiring signed link. So:
- #585's ask ("include `.contentUrl` so scripts don't reconstruct") is *slightly*
  mis-stated: the field already exists (named `content`), and the reporter's own
  #576 workaround reconstructs `/attachment/content/<ID>` only because they filter
  on `mimeType` and don't read `content` back. If `jr issue attachment list
  --output json` surfaces the raw `content` field (which it should, being lossless
  JSON passthrough), #585 is satisfied incidentally.
- #585 correctly self-identifies as **"closes with #576"** — the `download`
  subcommand internalizes the redirect-following, making manual URL use
  unnecessary. Recommend intake treat #585 as absorbed by #576, not a separate
  slice.

---

## Open questions for intake (not blockers)

1. **Exact live size cap** (§3a) — INCONCLUSIVE. Don't hard-code; rely on the
   API's own 413/400 rejection and the per-attachment `size` field.
2. **JSM upload visibility** (§5) — explicit scope decision needed: platform
   POST (no visibility control) for slice 1, two-step `servicedeskapi` +
   `--public/--internal` deferred? 
3. **reqwest feature additions** (§3b) — `multipart` + `stream` (+ likely
   `tokio-util`); needs `cargo deny` sign-off and an ADR-worthy note (first
   streaming/multipart surface in the crate).
4. `--filter mime="image/*"` glob semantics, `--newest N`, `--older-than 7d`
   (reuse `src/duration.rs`?) are pure CLI-design choices, no API risk.

---

# Part 2 — JSM two-step upload deep-dive (2026-07-15)

Follow-up requested after the human ruled **JSM upload visibility IN SCOPE** for
SOH-ATTACHMENTS-1 (F1 gate held pending this validation). Same untrusted-input
and no-product-code constraints as Part 1. All eight sub-questions validated
below.

## Part 2 verdict table

| # | Claim | Verdict | Confidence |
|---|-------|---------|------------|
| P2-1a | `attachTemporaryFile` multipart contract: part name `file`, `X-Atlassian-Token: no-check` required, multiple files per call | VERIFIED | High |
| P2-1b | Response shape `{"temporaryAttachments":[{"temporaryAttachmentId":"…","fileName":"…"}]}` | VERIFIED | High |
| P2-1c | `serviceDeskId` is NOT derivable directly from an issue key — indirect lookup via project | VERIFIED | High |
| P2-2 | Temporary attachment TTL ≈ 1 hour; expiry surfaces as a "temporary attachment not found" error | VERIFIED (TTL); INCONCLUSIVE (exact Cloud API error string/status) | Medium |
| P2-3a | `public: true` = customer-visible on portal; `public: false` = internal/agent-only | VERIFIED | High |
| P2-3b | `additionalComment` is OPTIONAL; the endpoint attaches without requiring a comment body | VERIFIED | Medium-High |
| P2-3c | Response shape of `request/{id}/attachment` | INCONCLUSIVE (Cloud schema not published in consulted sources) | Low |
| P2-3d | Invalid/expired `temporaryAttachmentId` → error at attach time | VERIFIED (that it errors); INCONCLUSIVE (exact status) | Medium |
| P2-4a | **Platform POST to a JSM issue is INTERNAL-by-default — NOT a customer-data-leak footgun** | VERIFIED (REFUTES the Part 1 footgun hypothesis) | High |
| P2-4b | servicedeskapi request-attachment against a non-JSM issue → 404 | VERIFIED | Medium-High |
| P2-5 | Both servicedeskapi calls covered by our existing `write:servicedesk-request` (+`read:`) — **no re-consent** | VERIFIED | High |
| P2-6 | JSDCLOUD-10841 breaks JSM read-back `links.content` → verify via platform content endpoint | VERIFIED | High |
| P2-7 | Size cap firm-up + whether temp-file endpoint has a different limit | PARTIALLY RESOLVED (cap still plan/config-dependent; no separate temp-file limit found) | Medium |
| P2-8 | No RustSec/GHSA advisories against reqwest 0.13.x (multipart/stream/redirect) or tokio-util 0.7.x | VERIFIED | High |

---

## P2-1 — `attachTemporaryFile` contract, response, and serviceDeskId discovery

**Endpoint:** `POST /rest/servicedeskapi/servicedesk/{serviceDeskId}/attachTemporaryFile`
- **Multipart:** part name **`file`**; **`X-Atlassian-Token: no-check` required**
  (multipart XSRF guard, same as the platform endpoint); accepts **one or more**
  `file` parts in a single call. VERIFIED.
- **Response (Cloud, confirmed verbatim in the Atlassian KB):**
  `{"temporaryAttachments":[{"temporaryAttachmentId":"5ad41f7b-…","fileName":"test2.txt"}]}`
  — top-level `temporaryAttachments` array of `{temporaryAttachmentId, fileName}`.
  A serde struct pair (`TempAttachmentResponse { temporary_attachments: Vec<TempAttachment> }`,
  `TempAttachment { temporary_attachment_id, file_name }`) covers it. VERIFIED.
- **serviceDeskId discovery (load-bearing for the CLI, which takes an issue KEY):**
  There is **no `issue key → serviceDeskId` endpoint.** The lookup chain is
  indirect: issue key → issue's project (`fields.project.key`/`.id` from
  `GET /rest/api/3/issue/{key}`) → `GET /rest/servicedeskapi/servicedesk`
  (paginated) → match on `projectKey`/`projectId` → `serviceDeskId`. VERIFIED.
  - **Design implication:** `attachment upload --public` on a JSM issue costs an
    extra `GET issue` (for project) + a paginated `GET /servicedesk` scan
    (cache-worthy per `(profile, projectKey)` → `serviceDeskId`, 7-day TTL, same
    family as the existing request-type / service-desk caches). This mirrors the
    `require_service_desk` resolution already in `src/api/jsm/servicedesks.rs`.
- Sources: <https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-servicedesk/>;
  <https://support.atlassian.com/jira/kb/how-to-add-an-attachment-to-a-jira-service-management-cloud-ticket-using-the-rest-apis/>;
  <https://support.atlassian.com/jira/kb/find-the-service-desk-id-for-your-jira-service-management-cloud-project/>.

## P2-2 — Temporary attachment lifetime

- **TTL ≈ 1 hour**, stated by Atlassian staff in a Cloud `attachTemporaryFile`
  community thread ("We have an expiry time for temporary attachments of 1 hour.
  So you have to make them permanent in that timeframe, otherwise they will be
  gone and you will see the error"). VERIFIED (TTL value).
- The associated symptom string "Temporary attachment not found, session may have
  timed out before submitting the form" is documented in a **Server/DC** KB, not a
  Cloud API reference — so the **exact Cloud API error body/HTTP status on expiry
  is INCONCLUSIVE.** Treat expiry as: the second call fails; do not assume a
  specific machine-readable code.
- **Design implication:** for a CLI the two steps run back-to-back (seconds
  apart), so the 1-hour TTL is effectively a non-issue in the happy path. Guard
  only matters if a large multi-file upload is chunked or a retry loop stalls;
  surface any second-call failure with a "temporary upload expired — retry the
  upload" hint rather than pattern-matching an error code.
- Sources: <https://community.atlassian.com/forums/Jira-Service-Management/Errors-with-the-attachTemporaryFile-API/qaq-p/1555337>;
  <https://confluence.atlassian.com/jirakb/creating-an-issue-in-jira-throws-the-error-temporary-attachment-not-found-session-may-have-timed-out-before-submitting-the-form-1157465119.html>
  (Server/DC).

## P2-3 — `request/{issueIdOrKey}/attachment` semantics

**Endpoint:** `POST /rest/servicedeskapi/request/{issueIdOrKey}/attachment`, JSON
body `{"temporaryAttachmentIds":[…], "public": true|false,
"additionalComment": {"body": "…"}}`.
- **`public` flag:** `true` = **customer-visible on the portal**; `false` =
  **internal/agent-only**. Role gate: agents may set either; customers may create
  only public; unlicensed users only internal. VERIFIED. This maps cleanly onto a
  `--public` / `--internal` CLI flag pair mirroring our existing
  `issue comment edit --public/--internal` model (BC-3.5.006) — recommend the same
  flag names and the same "public is the consequential one, gate it" instinct.
- **Comment creation:** `additionalComment` is **optional** — the endpoint
  attaches without a comment body ("an additional comment may be provided… will be
  prepended to the attachments"). The JSM data model still associates visibility
  with a carrying comment under the hood, but the caller is not required to supply
  comment text. VERIFIED (Medium-High — Cloud doc wording + community).
- **Response shape:** Cloud JSON schema for this endpoint is **not published** in
  the consulted Atlassian sources → INCONCLUSIVE. Recommend the implementer
  capture the live shape during the JSM e2e run (the EJ project, gated by
  `JR_E2E_JSM_PROJECT`) and pin a serde struct from that, rather than guessing.
- **Invalid/expired `temporaryAttachmentId`:** the attach call fails (consistent
  with the 1-hour TTL). Exact status/body INCONCLUSIVE — handle as a generic
  4xx with a retry-the-upload hint.

## P2-4 — Error modes and the platform-vs-servicedeskapi visibility question (the key finding)

- **P2-4a — REFUTES the Part 1 "footgun" hypothesis (HIGH confidence).** Adding an
  attachment to a JSM issue via the **platform** endpoint
  `POST /rest/api/3/issue/{key}/attachments` (or the agent issue-view attachment
  panel) is **internal by default — it is NOT shown on the customer portal** unless
  it is subsequently surfaced through a public "Reply to customer" comment.
  Confirmed by the Atlassian JSM Cloud KB ("Attachments in Jira tickets are
  visible to portal customers only if included in a public comment") and Cloud bug
  JSDCLOUD-13030 ("attachment added from the issue view into the attachment tab…
  is not visible on the customer portal"; "Add to issue only" = internal).
  - **Consequence for design (this flips the risk framing):** the *dangerous*
    direction is the opposite of what Part 1 hypothesized. Platform-POST is the
    **safe, internal-by-default** path. The servicedeskapi two-step is required
    specifically to make an attachment **customer-visible (`public: true`)** — i.e.
    `--public` is the credential-consequential flag that must be explicit and
    gated (never defaulted on). Recommended CLI default: `attachment upload` on a
    JSM issue behaves like the platform path (internal) unless the user passes
    `--public`, which routes through the servicedeskapi two-step flow.
- **P2-4b — servicedeskapi against a non-JSM issue → 404** (the JSM REST reference
  returns 404 when the service desk / request is not found or not permitted; a
  regular software issue key does not resolve to a customer request). VERIFIED
  (Medium-High). Design: detect JSM-ness up front (the `serviceDeskId` resolution
  in P2-1 already fails cleanly for non-JSM projects) and give a clear
  "`--public` requires a JSM project" error rather than surfacing a raw 404.

## P2-5 — OAuth scope coverage (no-re-consent invariant holds)

- `attachTemporaryFile` — Cloud scope table: classic **`write:servicedesk-request`**
  (granular alt: `read:request.attachment:jira-service-management` +
  `write:request.attachment:jira-service-management`).
- `request/{id}/attachment` — covered by classic **`write:servicedesk-request`**
  ("Create and edit customer requests, including add comments and attachments").
- Our `DEFAULT_OAUTH_SCOPES` (`src/api/auth.rs:65`) already grants
  **`read:servicedesk-request write:servicedesk-request`**. **Both calls are
  covered — no scope addition, no Developer Console change, NO re-consent.** The
  CLAUDE.md scope-change protocol remains untriggered for the JSM upload path,
  same as the platform path in Part 1 §2. VERIFIED.
- Source: <https://developer.atlassian.com/cloud/jira/service-desk/scopes-for-oauth-2-3LO-and-forge-apps/>;
  <https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-servicedesk/>.

## P2-6 — JSDCLOUD-10841 and the post-upload read-back

- JSDCLOUD-10841 (confirmed) reports that `GET /rest/servicedeskapi/request/{id}/attachment`
  returns **broken `links.content` URLs → 404** on download. **Implication for the
  verify step:** after a JSM upload, do NOT read back / verify via the
  servicedeskapi attachment-list `links.content` URL. Instead confirm the upload by
  reading the issue's platform `fields.attachment[]`
  (`GET /rest/api/3/issue/{key}?fields=attachment`) and, for download, use the
  platform `GET /rest/api/3/attachment/content/{id}` path (Part 1 §1b — the
  reliable downloader for both platform and JSM issues). This keeps `attachment
  list` / `download` on ONE code path regardless of project type; only `upload
  --public` forks to servicedeskapi. VERIFIED.

## P2-7 — Size cap firm-up

- Still **plan/config-dependent** and could not be pinned to a single
  authoritative current number: the current admin "Configure file attachments"
  doc lineage says default large (order of GB) with a per-file hard cap in the
  low-GB range, admin-configurable; older guidance cites tens of MB. Treat as
  **site-configurable; do not hard-code** (unchanged from Part 1 §3a).
- **No evidence of a *separate* size limit for the servicedeskapi
  `attachTemporaryFile` endpoint** — the consulted sources describe one
  instance-level attachment-size setting governing both paths. So the platform and
  JSM upload paths should be assumed to share the same cap.
- **Operative guidance unchanged:** rely on the server's own 413/400 rejection +
  the per-attachment `size` metadata; stream the upload (P2-8 deps) rather than
  buffer, so a large file doesn't OOM the CLI regardless of the exact cap.

## P2-8 — Dependency advisory sweep (planned additions)

Verified against the local RustSec advisory-db (1160 advisories) and Perplexity
cross-check on 2026-07-15:
- **Current tree is clean:** `cargo deny check advisories` → "advisories ok";
  `cargo audit` (347 deps) → no vulnerabilities reported.
- **`reqwest` 0.13.4** (the `multipart` + `stream` feature paths, and redirect
  handling): **no RustSec (RUSTSEC-*) and no GHSA advisory** against the crate.
  Independent corroboration of the Part 1 redirect finding: GHSA-9857-6MW7-FQ2M
  (against `gix-transport`, NOT reqwest) explicitly states the **reqwest backend is
  not affected** because it "compares `prev_url.host_str()` to `curr_url.host_str()`
  and stops / strips sensitive headers on cross-domain redirects" — i.e. reqwest's
  default redirect policy is the mitigation, exactly the behavior our `download`
  path relies on.
- **`tokio-util` 0.7.x:** **no RustSec/GHSA advisory** against the crate. Known
  advisories in that neighborhood target the core `tokio` crate, not `tokio-util`.
  **Bonus finding:** `tokio-util 0.7.18` is **already present in `Cargo.lock`**
  (transitive) — promoting it to a direct dependency for `ReaderStream`-based
  multipart streaming adds **no new crate to the supply-chain surface**, only a
  direct-dependency declaration. This lowers the cost of the P2/Part-1 §3b
  recommendation.
- **Net:** the `multipart` + `stream` reqwest features and a direct `tokio-util`
  dep are clean today. Standard practice: re-run `cargo deny check` in the
  feature's PR (already a CI gate) and note the feature additions in the ADR.

---

## Part 2 — open items for intake

1. **Cloud response schema** for `request/{id}/attachment` (P2-3c) and the exact
   expiry error (P2-2/P2-3d) — INCONCLUSIVE; capture live during the gated JSM e2e
   run (EJ project) and pin serde structs from real responses rather than guessing.
2. **CLI default confirmed by research:** `attachment upload` should default to the
   internal-safe platform POST; `--public` opts into the servicedeskapi two-step
   and requires a JSM project (else a clear error, not a raw 404). `--public` is
   the gated/consequential flag — mirror `comment edit --public/--internal`.
3. **serviceDeskId cache** — add a `(profile, projectKey) → serviceDeskId` cache
   entry (7-day TTL, `v1/` family) to avoid a paginated `/servicedesk` scan on
   every `--public` upload; reuse the `require_service_desk` resolution path.
4. **`tokio-util` is already transitive** — promoting to a direct dep is low-risk;
   still surface the reqwest `multipart`+`stream` feature adds in the ADR + PR
   `cargo deny` gate.
