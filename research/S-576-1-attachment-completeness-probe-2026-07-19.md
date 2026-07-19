# S-576-1 — BC-2.7.001 Attachment Completeness Probe

**Date:** 2026-07-19
**Story:** S-576-1
**Discharge path:** (b) — documentation citation
**Researcher:** research-agent (Perplexity Sonar Deep Research + direct Atlassian doc verification)

## Claim

`GET /rest/api/3/issue/{key}?fields=attachment` on Jira Cloud returns the
**complete** attachment array in `fields.attachment[]` — the field is NOT
paginated and there is no truncation at any attachment count.

**Secondary question:** Does Atlassian document any bound on the maximum number
of attachments per issue? (A documented bound would also satisfy the probe.)

## Verdict

**CONFIRMED** (primary claim) — with a documented-limit corollary that
independently satisfies discharge path (b).

- The `attachment` field is **not documented as paginated**. The Jira Cloud
  REST API v3 issue endpoint exposes no field-level `startAt`/`maxResults` for
  `fields.attachment[]`, and no published schema or example describes a
  per-array item cap or truncation behavior. Atlassian is consistently explicit
  about pagination where it applies (issue search `POST /rest/api/3/search`;
  JSM `GET /rest/servicedeskapi/request/{key}/attachment` is expressly
  "paginated") — the absence of such language on the issue `attachment` field
  is meaningful, not an oversight.
- Atlassian's own KB article on exporting attachments **treats
  `.fields.attachment[]` as the complete list** — it iterates the array with
  `jq` and carries **no truncation caveat**, while explicitly warning about
  issue-level pagination (100 results/page via `maxResults` + `startAt`). If the
  attachment array were truncated at a fixed count, this export procedure would
  silently miss attachments — a caveat that is conspicuously absent.
- **Documented per-issue bound exists (path (b) corollary):** Atlassian's
  Enterprise advisory states plainly that "Jira Cloud limits the number of
  attachments per issue." The existence of a bound is documented, though the
  exact numeric value for Cloud is NOT published (the 2,000-attachment figure in
  that article is a **Data Center** SQL diagnostic threshold, not a Cloud limit —
  verified directly, do not cite it as a Cloud maximum).

Net effect for the CLI: in ordinary usage the array returned by a single
`GET …?fields=attachment` can be treated as the authoritative, complete set of
attachments the caller is permitted to see. No client-side pagination loop over
the attachment field is required or possible.

## Evidence & Citations

1. **Issue attachments API group** (no field-level pagination documented):
   https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-attachments/
2. **Issues API group** (`attachment` is a plain multi-valued array field):
   https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/
3. **Issue search API group** (pagination is documented at the *issue* level, not field level):
   https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/
4. **KB: Export Jira project attachments using REST API** — iterates
   `.fields.attachment[]` as complete; warns only about issue-level pagination;
   NO attachment-array truncation caveat (verified directly 2026-07-19):
   https://support.atlassian.com/jira/kb/export-jira-project-attachments-using-rest-api/
5. **Enterprise: Issues with too many attachments** — documents that Jira Cloud
   limits attachments per issue (no numeric Cloud value; 2,000 is a DC diagnostic
   threshold) (verified directly 2026-07-19):
   https://confluence.atlassian.com/enterprise/issues-with-too-many-attachments-1402420952.html
6. **Contrast — JSM customer-request attachments ARE expressly paginated**,
   showing Atlassian documents pagination when it applies:
   https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/ (§ and JSM servicedeskapi attachment endpoint)

**Cloud vs Server/DC:** All primary findings above are Jira **Cloud** (`/rest/api/3`).
The 2,000-attachment SQL query in source 5 is Data Center-only (direct DB access);
it is not a Cloud limit.

**Honesty note:** Atlassian does not affirmatively state "the attachment field is
not paginated." The CONFIRMED verdict rests on (a) documented absence of any
pagination mechanism, (b) Atlassian's own export KB treating the array as
complete, and (c) the explicit contrast with endpoints Atlassian *does* document
as paginated. This is strong documentary evidence, not an explicit vendor
guarantee — a future undocumented internal response-size limit on pathologically
large issues cannot be fully excluded, but no source reports attachment-array
truncation at any count.

## PR-ready one-liner

BC-2.7.001 completeness-probe: path (b) — CONFIRMED. Jira Cloud REST v3 does not
document pagination or a per-array cap on `fields.attachment[]`; Atlassian's own
export KB treats the array as complete, and the Enterprise advisory documents a
(numerically-unspecified) per-issue attachment limit — so a single
`GET /rest/api/3/issue/{key}?fields=attachment` returns the complete attachment
list. Cite: developer.atlassian.com issues API group + support.atlassian.com
export-attachments KB + confluence.atlassian.com "Issues with too many attachments".
