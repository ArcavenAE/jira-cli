---
issue: 577
story: S-577-5
topic: "JSM comment visibility restrictions — top-level `visibility` field acceptance, invalid-role behavior, default JSM roles, role enumeration API, visibility × sd.public.comment interaction, body-only PUT preservation on JSM"
date: 2026-07-14
status: MIXED — Q1 VALIDATED (High) / Q2 INCONCLUSIVE-leans-400 (Low-Medium) / Q3 VALIDATED (High) / Q4 VALIDATED endpoint, permissions inferred (High/Medium) / Q5 VALIDATED-independent (Medium-High) / Q6 PRESERVED (Medium-High)
supersedes: none
siblings:
  - issue-577-comment-crud-jsdpublic-2026-07-09.md
  - issue-577-visibility-put-semantics-2026-07-09.md
  - issue-577-visibility-identifier-shape-2026-07-10.md
  - issue-577-properties-merge-replace-2026-07-09.md
---

# Research: Issue #577 / S-577-5 — JSM comment `visibility` restrictions

## Scope

Six questions specific to Jira Service Management (company-managed) projects, for a
`jr` feature that sets `visibility` on `POST`/`PUT /rest/api/3/issue/{key}/comment[/{id}]`.
Prior sibling research settled the *general-platform* visibility semantics (PUT-omission →
PRESERVED; identifier-vs-value shape; visibility × `sd.public.comment` independence at the
schema level). This file confirms or refutes those for **JSM company-managed projects
specifically** and answers three new JSM-only questions (invalid-role behavior, default
role names, role-enumeration API).

## Answer summary

| Q  | Question                                                              | Verdict                                                        | Confidence   |
| -- | --------------------------------------------------------------------- | -------------------------------------------------------------- | ------------ |
| Q1 | Is top-level `visibility` accepted on JSM comment POST/PUT?           | **YES — same schema/endpoint as Software; no JSM exception.**  | High         |
| Q2 | Non-existent role name → HTTP 400, or 2xx with field silently dropped? | **INCONCLUSIVE — leans 400, but NOT documentation-confirmed.** | Low-Medium   |
| Q3 | Is "Service Desk Team" a reliable default JSM company-managed role?   | **YES — canonical, Atlassian explicitly declined to rename.**  | High         |
| Q4 | Correct role-enumeration API + permissions?                          | **`GET /rest/api/3/project/{key}/role`; Browse Projects likely suffices.** | High endpoint / Medium perms |
| Q5 | Can one comment carry BOTH role/group `visibility` AND `sd.public.comment`? | **YES — architecturally independent; no documented conflict.** | Medium-High  |
| Q6 | Body-only PUT preserves existing visibility on JSM?                  | **PRESERVED — no JSM-specific counter-evidence.**              | Medium-High  |

---

## Q1 — Is `visibility` accepted on JSM comment POST/PUT?

**VALIDATED — High confidence.**

JSM issues are ordinary Jira issues at the platform layer. Their comments live in the same
schema and are manipulated through the same `POST /rest/api/3/issue/{key}/comment` /
`PUT /rest/api/3/issue/{key}/comment/{id}` resource as Jira Software — Atlassian's platform
reference documents these as generic issue operations with **no** project-type variant
([Jira Cloud v3 Issues API group](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/)).
The `Comment` representation carries a top-level optional `visibility` object
(`{"type":"role"|"group","value"|"identifier": …}`) whose semantics are unchanged from the
server model shown in Atlassian's canonical add-comment example
([server REST add-comment example](https://developer.atlassian.com/server/jira/platform/jira-rest-api-example-add-comment-8946422/)):

```json
{ "body": "Just a comment.", "visibility": { "type": "role", "value": "Administrators" } }
```

JSM overlays its **internal/public** semantics through a *separate* mechanism — the
`sd.public.comment` entity property (Cloud) / `sd.comment.property` (DC) — not by changing
the comment schema or disabling `visibility`. Atlassian's DC KB shows internal comments are
just ordinary comments with a property attached, joined at the DB level
([DC KB: retrieve internal/external comments](https://support.atlassian.com/jira/kb/jira-service-management-data-center-how-to-retrieve-internal-or-external-comments/)).
There is **no** documented JSM-specific restriction that causes JSM projects to ignore or
reject role/group `visibility`. See Q5 for the visibility × internal/public interaction.

**Confidence: High** — the endpoint and schema are platform-level and no JSM exception is
documented. (Medium-High only for "no interaction beyond normal permission effects" — that
sub-claim rests on structural analysis + JSDCLOUD-829, not an explicit Atlassian sentence.)

---

## Q2 — Non-existent role name: HTTP 400 or silent 2xx drop? (LOAD-BEARING for test validity)

**INCONCLUSIVE — leans toward HTTP 400, but NOT confirmed by any authoritative source.**
**Low-Medium confidence.** This is the question the task flagged as gating test validity,
and it is the weakest-evidenced of the six — I am flagging it explicitly.

What the evidence supports:
- Jira Cloud's general pattern for endpoints that reference a project role or group by name
  is to **reject** an unknown identifier with a 4xx (400/404) rather than silently ignore
  it — consistent with how permission-scheme and role-actor endpoints behave
  ([Jira Cloud v3 Project roles API group](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-roles/)).
- Deep-research synthesis (Perplexity, reasoning_effort=high) reports that hands-on behavior
  of the comment endpoint returns a 400-class error ("role does not exist / no permission")
  for an invalid `visibility.value` role name, uniformly across Software and JSM, because
  validation is in the shared comment service — but this is **prior-observation / inference,
  not a cited Atlassian doc or ticket**.

What the evidence does NOT provide:
- **No** Atlassian doc paragraph, changelog, or JRACLOUD/JSDCLOUD ticket was located that
  states the error code/message for an invalid project-role name in comment `visibility`.
  A targeted search (`…visibility role does not exist error 400 invalid project role name`)
  surfaced only unrelated auth/JQL "value does not exist" errors, not the visibility case.
- Therefore the silent-drop hypothesis (2xx + field dropped) cannot be *positively ruled
  out* from documentation alone.

**Load-bearing consequence for S-577-5 tests (the reason this question was asked):** because
silent-drop is not *disproven*, a test that hard-codes a role name and asserts only on the
HTTP status (2xx) is **at risk of passing vacuously** if the role happens not to exist and
the field is silently dropped. Two robust mitigations, in preference order:

1. **Assert on the round-trip, not the status.** After the POST/PUT, GET the comment
   (`?expand=properties` if also touching JSM state) and assert that `visibility` is present
   with the expected `type`/`value`. A silently-dropped restriction then FAILS the test.
2. **Use a runtime-enumerated real role** (Q4) rather than a hard-coded literal, so the role
   is guaranteed to exist in the target project — removing the vacuous-pass path entirely for
   any wiremock/live fixture that mirrors real role state. For pure unit/wiremock tests this
   is moot (the mock returns whatever you script); it matters for live/E2E (`tests/e2e_live.rs`).

**Confidence: Low-Medium** — the "leans 400" direction is well-motivated by Jira's
invalid-identifier conventions, but no authoritative source documents this specific edge. If
S-577-5 needs certainty, run the empirical probe (below) against the `EJ` JSM sandbox; one
POST with a deliberately-bogus role name settles it definitively.

---

## Q3 — Default JSM company-managed roles; is "Service Desk Team" reliable?

**VALIDATED — High confidence. "Service Desk Team" is the canonical, stable default agent
role on JSM company-managed Cloud projects and has NOT been renamed.**

Default project roles on a company-managed JSM project (standard template):
- **Administrators** (project admins; project lead assigned here by default)
- **Service Desk Team** (agents / licensed users, plus collaborators added to this role)
- **Service Desk Customer** / **Service Desk Customers** (requesters — note the naming
  nuance below)
- **Stakeholders** (present in many but not universally treated as a comment-visibility target)

Evidence "Service Desk Team" is stable and current:
- **JSDCLOUD-1376 "Rename Project Role 'Service Desk Team' to 'Service Desk Agents'" —
  Resolution: Won't Fix** (<https://jira.atlassian.com/browse/JSDCLOUD-1376>). Atlassian
  *explicitly declined* to rename the role — the strongest possible signal that the literal
  name is intentionally stable.
- **Community 2025-03-10** (<https://community.atlassian.com/forums/Jira-questions/Project-role-assignment-to-users/qaq-p/2967133>):
  "Project Roles available for Company Managed projects are defined globally by Jira
  Administrators. The default roles are Administrator, Service Desk Team, and Service Desk
  Customer. The last two apply only to Service Management projects." Confirms the exact names
  are current as of 2025.
- **Atlassian JSM Cloud docs (2024-01-23)** — "What users and roles are there in Jira Service
  Management" (<https://support.atlassian.com/jira-service-management-cloud/docs/what-users-and-roles-are-there-in-jira-service-management/>):
  documents the **Service Desk Team** role (agents + collaborators) verbatim, under the
  Jira-Service-Management (post-rebrand) product name — i.e. the role kept its "Service Desk"
  name even after the product rename from Jira Service Desk → JSM.
- **Confluence "Permissions overview in JSM"** (<https://confluence.atlassian.com/spaces/SECURITY/pages/1402421161/Permissions+overview+in+Jira+Service+Management>):
  the standard JSM permission scheme grants Browse/Create/etc. to `Project Role (Service Desk
  Team)` and `Project Role (Administrators)` — confirming Service Desk Team is a genuine
  project role usable as a `visibility.type=role` target.

Naming nuances worth encoding:
- The **customer**-facing access is a **security type** ("Service Desk Customer - Portal
  Access"), *not always a clean project role*, so `visibility.type=role,value="Service Desk
  Customers"` is a less-reliable target than `"Service Desk Team"`. For restricting a comment
  to *agents/internal staff*, **"Service Desk Team" is the best-supported literal.**
- **team-managed** JSM projects use **"Agent"** instead of "Service Desk Team" (community
  2025-03-10). S-577-5 is scoped to company-managed, but do not assume "Service Desk Team"
  exists on a TM service project.
- **Do NOT rename/delete these roles:** **JSDCLOUD-12783**
  (<https://jira.atlassian.com/browse/JSDCLOUD-12783>) documents that renaming the default
  JSM roles causes critical permission errors ("roles for service desk team and service desk
  customers are missing") — i.e. the names are effectively contractual. This *strengthens*
  the reliability of the literal but is a caveat for any code that mutates roles (jr does not).

**Confidence: High** for the presence/stability of "Service Desk Team" on standard
company-managed templates; Medium for the universal-across-all-instances claim (admins *can*
customize, and there is no API guarantee every project has it — hence Q4 runtime enumeration
is still the belt-and-suspenders approach).

---

## Q4 — Role-enumeration API and required permissions/scope

**VALIDATED endpoint (High); permissions/scope inferred (Medium).**

- **Endpoint:** `GET /rest/api/3/project/{projectIdOrKey}/role` — returns a JSON map of
  `roleName → roleUrl` for the project. Part of the platform "Project roles" API group,
  uniform across JSM and Software
  ([Jira Cloud v3 Project roles API group](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-roles/)).
  A community integration walkthrough confirms the `GET …/project/{key}/role` → per-role
  detail pattern in practice
  (<https://community.developer.atlassian.com/t/jira-api-issues-to-retrieve-all-users-permissions-to-projects/79702>).
- **Permissions:** Atlassian's standard pattern for *read-only* project-metadata listing is
  **Browse Projects** on the target project, not project-admin/Jira-admin (write operations
  on roles need admin). JSM agents in the Service Desk Team role have Browse Projects
  (confirmed by the permission-scheme table in the Confluence permissions doc cited in Q3),
  so an agent-level token should be able to enumerate role names. **Caveat:** Atlassian
  occasionally gates a REST read behind admin even when the UI shows the data to non-admins;
  the exact minimum permission for *this* endpoint is not stated in a doc snippet I located,
  so treat "Browse Projects suffices" as inferred (Medium).
- **OAuth scope:** reading project roles falls under `read:jira-work` (classic). jr's existing
  `DEFAULT_OAUTH_SCOPES` already include the classic work scopes used elsewhere, so **no
  re-consent is expected** for adding a role-enumeration read — consistent with the
  scope conclusion in sibling `issue-577-comment-crud-jsdpublic-2026-07-09.md` (Claim 5).
  Confirm against the granular-scope table if jr ever moves off classic scopes.

**Confidence: High** for the endpoint (documented + community-confirmed); **Medium** for the
"Browse Projects is sufficient" permission floor and the exact scope mapping (inferred from
Jira's read-metadata conventions, not a pinned doc sentence).

---

## Q5 — Can one comment carry BOTH `visibility` AND `sd.public.comment`?

**VALIDATED — the two are architecturally independent; YES they coexist; no documented
conflict. Medium-High confidence.**

- `visibility` is a **first-class field of the core comment resource** (platform permission
  layer: which Jira users/roles/groups can see the comment in the Jira UI / via REST).
- `sd.public.comment` is a **JSM entity property** attached to the same comment (portal
  layer: whether the comment is a customer-facing reply or an internal note, and which
  notifications fire).
- The DC KB (<https://support.atlassian.com/jira/kb/jira-service-management-data-center-how-to-retrieve-internal-or-external-comments/>)
  models internal comments as *ordinary comments with a property joined on* — nothing filters
  on or precludes a co-present visibility restriction.
- **JSDCLOUD-829** (<https://jira.atlassian.com/browse/JSDCLOUD-829>) is the load-bearing
  interaction evidence: customers who gain *Jira* (not just portal) access can **see internal
  comments**, and the documented workaround is to revoke their Jira access — proving internal
  status is **not** auto-backed by a restrictive `visibility` clause. The two mechanisms
  operate in parallel: marking a comment internal does **not** implicitly set `visibility`,
  and vice versa. An admin who wants internal notes hidden from Jira-licensed customers must
  *additionally* apply a role `visibility` (e.g. Service Desk Team) — which is exactly the
  combined use case S-577-5 enables.
- **JSDCLOUD-6050** (<https://jira.atlassian.com/browse/JSDCLOUD-6050>) is about
  `sd.public.comment` REST edits not reflecting in the portal — it concerns the property
  round-trip only and reports **no** conflict with `visibility`.

No JRACLOUD/JSDCLOUD ticket was found documenting a *conflict* between the two mechanisms, and
none documents a *requirement* that internal comments carry any particular visibility. They
are orthogonal.

**Confidence: Medium-High** — the independence is clear from schema/architecture (DC KB) and
two tickets; Atlassian has not published a single explicit "you may combine these" sentence,
so the verdict is structural + observed rather than a dedicated doc paragraph.

---

## Q6 — Body-only PUT preserves existing visibility on JSM?

**PRESERVED — reconfirmed for JSM company-managed; no JSM-specific counter-evidence.
Medium-High confidence.**

JSM comment updates use the **same** `PUT /rest/api/3/issue/{key}/comment/{id}` endpoint,
which follows Jira Cloud's partial-update convention (only fields present in the body are
modified; omitted fields are untouched). No JSM-specific override of this behavior is
documented. Sibling `issue-577-visibility-put-semantics-2026-07-09.md` established PRESERVED
for the general platform case (Medium-High, load-bearing on the child-comment 400 announcement
whose logic collapses under CLEARED semantics). This file finds **no JSM-specific
counter-evidence**:
- JSDCLOUD-6050 (property round-trip) and JSDCLOUD-829 (access control) — the two JSM comment
  tickets that surface — neither reports visibility being lost on a body edit.
- No community report of JSM comment edits dropping visibility restrictions.

The JSM-specific *addition* to the general verdict: because JSM comments may also carry
`sd.public.comment`, a body-only PUT preserving `visibility` should — by the same
partial-update logic and per sibling `issue-577-comment-crud-jsdpublic-2026-07-09.md`
(Claim 1, MERGE/PRESERVED) — **also** leave `sd.public.comment` untouched. jr's body-only
edit path is safe on JSM: it strips neither the role/group restriction nor the internal/public
state.

**Confidence: Medium-High** — the platform PUT semantics apply cleanly to JSM and there is no
JSM exception; the slight discount is the absence of a JSM-specific doc sentence (same
documentation-gap pattern as the general case).

---

## Recommendations for jr / S-577-5

1. **Ship `visibility` on JSM comment create/edit** — accepted the same as Software (Q1). No
   JSM-specific gating needed for the happy path.
2. **For a restrict-to-agents default, prefer the literal `"Service Desk Team"`** (Q3), but
   **enumerate roles at runtime via `GET /rest/api/3/project/{key}/role`** (Q4) rather than
   trusting the literal — this also hardens against the Q2 vacuous-pass risk on live tests.
3. **Test design (Q2, load-bearing):** do NOT assert only on HTTP 2xx after setting
   `visibility`. Assert on a GET round-trip that the `visibility` object is present with the
   expected `type`/`value`; and/or use a runtime-enumerated real role. A hard-coded bogus role
   that is silently dropped would otherwise pass vacuously.
4. **`visibility` and `--internal`/`--public` are independent axes** (Q5) — jr may expose both
   on one command; setting one must not implicitly set or clear the other. Body-only edits
   preserve both (Q6).
5. **Do not empirically confirm against a shared/live JSM instance without approval** (repo
   memory `feedback_no_live_mutations`); the `EJ` sandbox probe below is the sanctioned path if
   Q2 certainty is required.

## Optional empirical probe (settles Q2 definitively; `EJ` JSM sandbox)

Extends the sibling probes. `${INSTANCE}`/`${AUTH}`/`${KEY}` as before; `${BOGUS}` = a role
name that does NOT exist (e.g. `Nonexistent-Role-2026`).

```bash
# Q2 — invalid role name on POST. Observe status + whether visibility survives.
RESP=$(curl -sS -w '\n%{http_code}' -X POST \
  -H "Authorization: ${AUTH}" -H "Content-Type: application/json" \
  "https://${INSTANCE}/rest/api/3/issue/${KEY}/comment" \
  -d '{"body":{"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":"Q2 probe — bogus role"}]}]},
       "visibility":{"type":"role","value":"'"${BOGUS}"'"}}')
echo "$RESP"
#   4xx (400/404)                → rejects invalid role (leans-verdict CONFIRMED). Test can rely on error.
#   2xx AND GET shows no visibility → SILENT DROP (vacuous-pass risk CONFIRMED). Assert on round-trip, not status.
#   2xx AND GET shows visibility  → server accepted/echoed it (unexpected; larger doc gap).
```

## Research methods

| Tool                                  | Calls | Purpose                                                                     |
| ------------------------------------- | ----: | --------------------------------------------------------------------------- |
| Read (3 sibling research files)       |     3 | Reuse general-platform verdicts (PUT-omission, identifier shape, jsdPublic) without re-litigating. |
| `perplexity_research` (high)          |     1 | Multi-source synthesis of all six JSM-specific questions (16 cited sources). |
| `perplexity_search`                   |     2 | Targeted firming of Q2 (invalid-role error semantics) and Q3 ("Service Desk Team" rename / current defaults). |

**Total MCP calls:** 3. **Training-data reliance:** low — every verdict cites an Atlassian
doc, a jira.atlassian.com ticket (JSDCLOUD-1376/-829/-6050/-12783), or a dated community
thread. Per house rule (#361), each ticket ID was checked to document the claimed symptom:
JSDCLOUD-1376 = the Won't-Fix rename decision; JSDCLOUD-829 = customers seeing internal
comments; JSDCLOUD-6050 = `sd.public.comment` REST round-trip; JSDCLOUD-12783 = rename causes
permission errors. Q2 is explicitly flagged as the one verdict with NO authoritative source —
its "leans 400" direction is inference, not citation.
