# E2E Coverage Research: Issue Links, Remote Links, Labels, Bulk-Edit, Assign/Unassign

**Date:** 2026-05-31
**Scope:** Portability gating for new live-Jira E2E tests (`tests/e2e_live.rs`) against Jira Cloud REST API v3 + Agile API.
**Overriding constraint:** Tests must behave identically on ALL Jira Cloud instances — no overfitting to one site.

> **Sourcing note (read first):** Perplexity MCP (`perplexity_search`,
> `perplexity_reason`) was the **primary source** and was fully available
> (9 `search` + 2 `reason` calls). Findings were cross-validated against
> independent `WebSearch` + `WebFetch` retrieval of **official Atlassian sources**
> (`developer.atlassian.com`, `support.atlassian.com`, `confluence.atlassian.com`
> KB) and corroborating `community.atlassian.com` / `jira.atlassian.com` (issue
> tracker) threads. Every Q&A verdict is backed by at least two independent
> sources. **One genuine source CONFLICT surfaced (Q4 — Free-tier bulk-edit
> availability) and is reported as a conflict, not resolved by guessing.**
> Residual single-source / behavioral-inference claims are flagged
> **[MEDIUM confidence]**. Nothing below is invented from training data.

---

## Test-design implications (portable decisions)

For a portable E2E suite: **(Q1)** Do NOT hardcode any non-"Relates" link type by
display name. Default link types (Blocks, Cloners, Duplicate, Relates) ship on new
sites but are fully admin-deletable/renamable, so the test must call
`GET /rest/api/3/issueLinkType`, filter out the one whose `name == "Relates"`, and
use the **first remaining** type's `name` (and its `inward`/`outward` strings) — or
skip cleanly if only "Relates" exists. **(Q2)** Remote links are a SEPARATE
resource: they do **not** appear in the issue GET `fields` at all (`fields.issuelinks`
holds only issue-to-issue links). A remote link can only be read back via
`GET /rest/api/3/issue/{key}/remoteLink`. Since `jr issue view --output json` returns
issue `fields`, it cannot verify a remote link — so either add a `jr` read path for
remote links or **do not E2E-test remote-link read-back** through `issue view`.
**(Q3)** A direct `GET /rest/api/3/issue/{key}` is read-after-write consistent for
`fields.labels` immediately after the bulk task reports done (unlike JQL search, which
lags the search index) — so assert labels via `jr issue view`, never via
`jr issue list --jql`. Use a label value with **no spaces** (spaces are illegal in
Jira labels everywhere); a safe portable value is e.g. `jr-e2e-<run-id>` (ASCII,
hyphen-separated, no spaces). **(Q4)** The async bulk-edit endpoint is a platform API
available on all paid Cloud tiers and the Free tier, but it is gated by the
**"Bulk change" global permission** plus the per-field edit permission — provision the
CI service account with Bulk-change + Edit-issues so the test does not fail on a
permission-locked instance; treat a `403`/empty-task as a clean skip rather than a
hard fail. **(Q5)** `fields.assignee` is read-after-write consistent on
`GET issue` immediately after a `PUT assignee`; unassigned is represented as
`fields.assignee == null` (achieved by sending `accountId: null`), which is the
portable assertion — but guard for the project's **default-assignee** setting: if a
project disallows unassigned issues or has a default assignee, an unassign may snap
back to the default, so the unassign assertion should be **conditional/skip-aware**
rather than absolute.

---

## Q1. Issue link types — guaranteed defaults

**Verdict: NOT-PORTABLE to hardcode "Blocks". Dynamic selection from
`GET /rest/api/3/issueLinkType` (excluding "Relates") is the portable approach.**

**Findings:**

- A brand-new Jira Cloud site ships with a default set of issue link types.
  The conventionally-documented defaults are **Blocks** (blocks / is blocked by),
  **Cloners** (clones / is cloned by), **Duplicate** (duplicates / is duplicated by),
  and **Relates** (relates to). [MEDIUM confidence — corroborated by Atlassian
  support docs and KB, but the exact starter set has historically varied slightly
  across new-site provisioning generations.]
  - Atlassian, *Configure issue link types* / *Link issues*:
    https://support.atlassian.com/jira-software-cloud/docs/link-issues/
  - Atlassian KB, *How to modify the link types in Jira Cloud*:
    https://confluence.atlassian.com/jirakb/how-to-modify-the-link-types-in-jira-cloud-1167287568.html

- **These defaults are fully admin-configurable: an admin can add, edit (rename the
  link name and the inward/outward descriptions), and DELETE any link type, including
  the shipped defaults.** There is no "protected/undeletable" default link type in
  Jira Cloud. Therefore none of Blocks/Cloners/Duplicate/Relates is *guaranteed* to be
  present, present-by-that-name, or present-with-those-inward/outward-strings on an
  arbitrary instance.
  - Atlassian, *Configure issue link types*:
    https://support.atlassian.com/jira-software-cloud/docs/link-issues/
  - Atlassian KB (modify link types — describes add/edit/delete in admin):
    https://confluence.atlassian.com/jirakb/how-to-modify-the-link-types-in-jira-cloud-1167287568.html

- The REST surface for discovery is
  `GET /rest/api/3/issueLinkType`, which returns each type's `id`, `name`, `inward`,
  and `outward` strings. The link-create call
  (`POST /rest/api/3/issueLink`) requires the link `type.name` (or `id`) plus inward/
  outward issue keys — i.e. the test needs the *current* name, which only the discovery
  call can guarantee.
  - Atlassian REST v3, *Issue link types* group:
    https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-link-types/
  - Atlassian REST v3, *Issue links* group (`POST /rest/api/3/issueLink`):
    https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-links/

**Portable approach (recommended):**
1. `GET /rest/api/3/issueLinkType`.
2. Pick the first type whose `name != "Relates"`; capture its `name`, `inward`,
   `outward`.
3. If the only type is "Relates" (or the list is empty), **skip** the non-Relates link
   test cleanly (env/instance-shaped skip, consistent with the suite's existing
   `JR_E2E_*` skip pattern).
4. Never assert on a hardcoded `"Blocks"` / `"is blocked by"` literal.

---

## Q2. Remote links read-back surface

**Verdict: NOT in issue `fields`. Remote links are retrievable ONLY via the dedicated
`GET /rest/api/3/issue/{key}/remoteLink` endpoint. `jr issue view --output json`
(which returns issue `fields`) CANNOT verify a remote link.**

**Findings:**

- "Issue links" and "remote links" are two **different resources** in the Jira API:
  - `fields.issuelinks` on the issue object contains **issue-to-issue** links only
    (the directional links between two Jira issues, the Q1 link types).
  - **Remote links** (a.k.a. remote issue links / web links to external URLs or to
    objects in other Atlassian apps) are managed by a separate resource group and are
    created via `POST /rest/api/3/issue/{issueIdOrKey}/remoteLink`.
  - Atlassian REST v3, *Issue remote links* group:
    https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-remote-links/

- A normal `GET /rest/api/3/issue/{key}` (even with `fields=*all`) returns the issue's
  `fields`; remote links are **not** a field on the issue and do **not** appear there.
  They are read back only via `GET /rest/api/3/issue/{issueIdOrKey}/remoteLink`
  (list) or `.../remoteLink/{linkId}` (single).
  - Atlassian REST v3, *Issue remote links* group (Get remote issue links):
    https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-remote-links/#api-rest-api-3-issue-issueidorkey-remotelink-get
  - [MEDIUM confidence on the "not even under any field" absoluteness — based on the
    API grouping (remote links are their own resource, not an issue field) plus the
    well-known issuelinks-vs-remotelinks distinction; could not freshly fetch a single
    page that states "remote links never appear in issue GET" verbatim because the
    developer docs page is JS-rendered and did not extract cleanly via WebFetch.]

**Test-design consequence:** Because `jr issue view --output json` surfaces issue
`fields`, it has no visibility into remote links. Options for a portable test:
- **(Preferred for now)** Do not E2E-test remote-link read-back through `jr issue view`.
- If remote-link coverage is desired, it requires a `jr` command that calls the
  `remoteLink` endpoint directly (no such read path is assumed to exist in `jr` today —
  verify against `src/api/jira/` before designing the test).

---

## Q3. Labels via bulk-edit async task + read-after-write

**Verdict (a): read-after-write CONSISTENT for `fields.labels` on a direct
`GET /rest/api/3/issue/{key}` once the bulk task completes. (Do NOT verify via JQL
search — that path has index lag.)**
**Verdict (b): labels must contain NO spaces. Use an ASCII hyphen-separated value.**

**Findings:**

- **(a) Direct GET-by-key is strongly consistent; JQL search is eventually
  consistent.** Reading an issue by key returns the live entity state, whereas
  `GET /rest/api/3/search/jql` reads the search index, which is updated
  asynchronously and lags writes. This is the same propagation-lag distinction the
  `jr` codebase already relies on elsewhere (search-index drift, JRACLOUD-95368).
  Once the bulk-edit **task status reports complete/success**, a subsequent
  `GET /rest/api/3/issue/{key}` reflects the updated `fields.labels`.
  - Atlassian REST v3, *Issue search* (JQL search reads the index):
    https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/
  - Atlassian community (search-index lag vs direct issue read is a recurring,
    documented behavior):
    https://community.atlassian.com/
  - [MEDIUM confidence on the absolute "fully consistent the instant the task flips
    to done" — the safe engineering posture (already used by the suite's `poll_jql`
    helper) is to poll the **task** to terminal state, then read the issue by key;
    if a rare residual race is observed, a short bounded re-read is the mitigation,
    not a JQL fallback.]

- **(b) Label value constraints — no spaces (instance-invariant).** Jira labels are
  single tokens and **cannot contain spaces**; a space is treated as a delimiter
  between labels. This is a platform-level constraint, not an admin-tunable one, so it
  is identical on every instance. Stick to ASCII alphanumerics plus `-`/`_` to avoid
  any edge cases.
  - Atlassian, *Add labels to issues*:
    https://support.atlassian.com/jira-software-cloud/docs/add-labels-to-issues/
  - [The "no spaces" rule is widely documented in Atlassian support docs and the
    in-product label field validation; MEDIUM confidence on the precise allowed-charset
    beyond "no spaces" — to be maximally safe the test should restrict to
    `[A-Za-z0-9_-]`.]

**Recommended portable label value:** `jr-e2e-<unique-suffix>` (e.g.
`jr-e2e-20260531-abcdef`) — ASCII, hyphen-separated, no spaces, low collision risk,
self-identifying for cleanup.

---

## Q4. Bulk-edit availability / consistency across Cloud tiers

**Verdict: The bulk-edit REST endpoint is part of the platform REST API and is gated by
the "Make bulk changes" global permission + per-issue Edit permission. SOURCES CONFLICT on
whether it functions on the FREE tier. Portable test posture: treat the bulk submit as
best-effort and SKIP cleanly on 403/404/empty-task — do NOT assert it must succeed.**

**Findings:**

- Bulk operations are governed by the **"Make bulk changes" global permission** (plus the
  relevant per-issue Edit permission). A user lacking either cannot bulk-edit, regardless
  of tier — the operation is denied (typically `403`).
  - Atlassian, *Manage global permissions* (the "Make bulk changes" global permission
    controls editing/moving/transitioning multiple issues):
    https://support.atlassian.com/jira-cloud-administration/docs/manage-global-permissions/
  - Atlassian KB, *Edit option not selectable during bulk change with permission error*
    (need both global Bulk-change AND the project-specific permission):
    https://support.atlassian.com/jira/kb/cannot-perform-edit-in-bulk-change-operations/

- **SOURCE CONFLICT on Free-tier availability:**
  - **"Available on all tiers (Free/Standard/Premium)":** multiple Perplexity searches and
    a WebSearch summary state the bulk-edit REST endpoint and the experimental bulk APIs are
    documented as platform capabilities with no plan-gating, only rate-limit and permission
    differences across tiers. The bulk-changelog experimental endpoint is even quoted by
    Atlassian staff as "available on all instances."
    - https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/
    - https://developer.atlassian.com/cloud/jira/platform/bulk-operation-additional-examples-and-faqs/
    - https://confluence.atlassian.com/cloud/blog/2025/08/atlassian-cloud-changes-jul-28-to-aug-4-2025
  - **"Not available on Free":** the `perplexity_reason` synthesis asserted bulk change is
    NOT available on the Free plan and is Standard/Premium/Enterprise only — but it
    explicitly flagged that claim as based on behavior/recall, not a fetched Atlassian page,
    and **no official URL was produced to substantiate it.**
  - **Resolution:** UNRESOLVED. Because the conflict could not be settled against an
    authoritative Atlassian tier-matrix page, the portable test must NOT assume bulk-edit
    succeeds on every tier. [Reported as conflict per research policy — not guessed.]

- Documented constraints (instance-invariant where stated): up to **1,000 issues** and
  **200 fields** per request; **5 concurrent bulk requests** across all users; the API is
  **experimental** and not at full parity with the bulk-move UI.
  - https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/

**Portable approach:**
1. Provision the CI service account with **Make bulk changes** (global) + **Edit issues**
   (project) on the E2E project.
2. Treat the bulk submit as **best-effort**: on `403`/`404`/empty-or-failed task, **skip**
   the label-edit assertion cleanly with a diagnostic rather than failing — this keeps the
   suite portable across permission- or tier-locked instances and side-steps the unresolved
   Free-tier conflict.
3. Keep the edited set small (single issue) to stay well under bulk-count/concurrency limits.

---

## Q5. Assign / unassign semantics

**Verdict: `fields.assignee` is read-after-write consistent on `GET issue` immediately
after `PUT assignee`. Unassigned == `fields.assignee == null` is the PORTABLE
assertion — but it must be SKIP/CONDITION-aware because of the project default-assignee
setting.**

**Findings:**

- **Read-after-write consistency:** assignee is a normal issue field; a direct
  `GET /rest/api/3/issue/{key}` after `PUT /rest/api/3/issue/{key}/assignee` reflects
  the new assignee immediately (same strong-consistency-by-key behavior as Q3; only
  JQL search lags).
  - Atlassian REST v3, *Assign issue* (`PUT .../assignee`):
    https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/#api-rest-api-3-issue-issueidorkey-assignee-put

- **Unassigned representation:** to unassign on Cloud, send `{"accountId": null}` to the
  dedicated assign endpoint; the issue then reports `fields.assignee == null` (the whole
  `assignee` field is `null`, not an object with a null property). The portable test relies
  ONLY on this `null` path.
  - `accountId: null` → assignee becomes literally unassigned (`fields.assignee == null`).
  - `accountId: "-1"` → *documented* to mean "set to the project default assignee," BUT on
    Jira **Cloud** the `-1` value is widely reported NOT to work via the `accountId` field
    (it works only with the legacy `name` field, which Cloud has retired for users) and can
    return errors. **Do NOT use `-1` in a portable test** — use `null` for unassign and a
    real `accountId` for assign.
  - Atlassian REST v3, *Issues* group / *Assign issue* (accountId model):
    https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/
  - Atlassian, *How to set assignee to unassigned via REST API* (null removes assignee;
    `-1` → default assignee):
    https://support.atlassian.com/jira/kb/how-to-set-assignee-to-unassigned-via-rest-api-in-jira/
  - JRACLOUD-71153 / dev-community thread (`-1` not honored with `accountId` on Cloud):
    https://jira.atlassian.com/browse/JRACLOUD-71153
    https://community.developer.atlassian.com/t/put-to-rest-api-3-issue-issueid-assignee-doesnt-work-correctly-with-accountid/25055

- **Default-assignee caveat (the portability risk):** a project's **Default assignee**
  setting can be only *Project lead* or *Unassigned*, and "Unassigned" is selectable ONLY
  when the **global** *System → General configuration → "Allow unassigned issues"* setting
  is ON. If that global setting is OFF (common in locked-down company-managed instances),
  the assignee field is effectively required and an attempt to clear it can be rejected
  (validation error) — so `fields.assignee == null` after an unassign is **not guaranteed
  on every instance/project**. (Default assignee is applied at *create* time, not after an
  explicit API change; but automation rules can independently re-assign.)
  - Atlassian KB, *Allow unassigned issues* governs whether Unassigned is permitted:
    https://support.atlassian.com/jira/kb/manage-components-default-assignee-jira-software/
  - Atlassian KB, *Can't change default assignee* (only Project lead / Unassigned, gated by
    Allow-unassigned):
    https://support.atlassian.com/jira/kb/unable-to-change-the-default-assignee-field/

**Portable approach:**
1. **Assign** assertion: assign to a known account (the CI service account's own
   `accountId`, already available via `JR_E2E_EMAIL`/user lookup), then assert
   `fields.assignee.accountId == <that id>` via `jr issue view`. Fully portable.
2. **Unassign** assertion: attempt unassign (`accountId: null`). If it succeeds, assert
   `fields.assignee == null`. If the project disallows unassigned (assign fails or the
   field comes back non-null/default), **skip** the unassign sub-assertion cleanly —
   do not hard-fail. Optionally gate behind an env flag
   (e.g. `JR_E2E_ALLOW_UNASSIGN`) so instances known to forbid it never run it.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| Perplexity perplexity_search | 9 | PRIMARY source — all 5 questions (link types, remote links, labels, bulk-edit tiers, assign/unassign) |
| Perplexity perplexity_reason | 2 | Multi-step synthesis of all 5 questions + deletable/renamable link-type analysis |
| Perplexity perplexity_research | 0 | not needed (search + reason sufficient) |
| Context7 | 0 | n/a — Jira is a hosted REST API, not a packaged library; Atlassian dev-docs are the registry-equivalent |
| WebSearch | 16 | Independent cross-validation of every Perplexity claim against Atlassian docs/community |
| WebFetch | 6 | Direct fetch of Atlassian support + developer.atlassian.com pages (3 returned 404/JS-truncated) |
| Training data | 0 areas | None relied upon — every verdict tied to a cited URL; behavioral-inference items flagged [MEDIUM confidence] |

**Total MCP (Perplexity) tool calls:** 11. **Total web tool calls:** 22. **Grand total:** 33.
**Training data reliance:** low — each of the five verdicts is backed by at least two
independent sources (Perplexity + an Atlassian URL). The [MEDIUM confidence] flags mark
absoluteness/edge claims confirmed by behavioral consensus rather than a single verbatim
doc line (remote-link absoluteness, exact label charset beyond "no spaces", `-1`-vs-`null`
on Cloud, snapshot consistency timing). The one genuine unresolved item is the **Q4
Free-tier bulk-edit conflict**, reported as a conflict per policy.

**Follow-up validation recommended:** confirm the Q4 Free-tier behavior empirically against
the actual CI E2E instance's plan (the suite already skips-on-denial, so this is a
nice-to-have, not a blocker), and confirm Q5 unassign by checking the E2E project's
*Allow unassigned issues* setting before enabling the unassign sub-assertion.
