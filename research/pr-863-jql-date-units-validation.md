# PR #863 — JQL Relative-Date Units Validation

**Date:** 2026-09-22
**Type:** general (technology / API-behavior verification)
**Purpose:** Validate a factual claim about Jira Cloud JQL relative-date offset units to determine whether PR #863's "reject `M` and `y`" fix is correct.

## Claim Under Test

> "Jira Cloud JQL relative-date expressions (e.g. `created >= -7d`) support ONLY the
> time-unit suffixes w (weeks), d (days), h (hours), and m (minutes). They do NOT support
> M (months) or y (years). A value like `-2M` is parsed as 2 MINUTES (because unit matching
> after w/d/h consumes 'm'-family), and `-1y` is an unknown/unsupported unit that Jira
> answers with an empty result set rather than an HTTP 400 error."

## Verdict Summary

| # | Sub-claim | Verdict |
|---|-----------|---------|
| 1 | Supported relative-date unit set is exactly `{w, d, h, m}` | **CONFIRMED** |
| 2 | `M` (month) and `y` (year) NOT supported as raw `-<n><unit>` offset units | **CONFIRMED** |
| 3 | Unit matching is case-insensitive, so `2M` == `2m` == 2 minutes | **CONFIRMED** |
| 4 | Unsupported unit `1y` returns an EMPTY result set (not HTTP 400 / error) | **REFUTED** |

**Overall:** The claim's core premise (only `{w,d,h,m}`; `M`→minutes silently; `M`/`y` unsupported)
is CONFIRMED. The claim's part-4 assertion about `-1y` behavior is **REFUTED** — Atlassian's own
issue tracker documents `-1y` as producing a **validation error** (`date value '-1y' … is invalid`),
which through the validated REST search path surfaces as **HTTP 400**, not a silent empty result.

---

## Detailed Findings

### 1. Supported relative-date unit set — CONFIRMED

The current Jira Cloud **JQL fields** reference documents exactly `{w, d, h, m}` for date/time
fields (`created`, `updated`, `resolved`):

> "Or use `"w"` (weeks), `"d"` (days), `"h"` (hours) or `"m"` (minutes) to specify a date
> relative to the current time. The default is `"m"` (minutes)."
> — https://support.atlassian.com/jira-software-cloud/docs/jql-fields/

Corroborated by the JQL vulnerability-search reference, which lists the valid relative formats:

> "m, h, d, w (minutes, hours, days, weeks) – e.g. -59m, -8h, 3w 2d."
> — https://support.atlassian.com/jira-software-cloud/docs/jql-vulnerability-search/

Note: date-only fields such as `due` are documented even more narrowly (`w` and `d` only):

> "Or use `"w"` (weeks) or `"d"` (days) to specify a date relative to the current date."
> — https://support.atlassian.com/jira-software-cloud/docs/jql-fields/

**No** Atlassian doc lists `M` or `y` among raw relative-offset units.

### 2. `M` and `y` not supported as raw offset units — CONFIRMED

Atlassian Community (official-answer thread) states plainly:

> "As per the documentation for the Created field search, it doesn't support specifying a time
> period of a month or a year." (recommends `-60d`, `-8w`, `startOfMonth()`, or `startOfYear()`)
> — https://community.atlassian.com/forums/Jira-questions/What-period-formats-are-accepted-in-JQL-search/qaq-p/2481874

Important contrast (as the claim anticipated): calendar-month/year units `M`/`y` DO exist, but
ONLY inside JQL **functions** (`startOfMonth()`, `startOfYear()`, etc.), as the optional
increment argument — a different mechanism from the raw `-<n><unit>` operand. The function-argument
grammar is `(+/-)nn(y|M|w|d|h|m)`:

> "`startOfMonth("+1")` is the same as `startOfMonth("+1M")`" and
> "`startOfYear("+1")` is the same as `startOfYear("+1y")`"
> — https://support.atlassian.com/jira-software-cloud/docs/jql-functions/

So `created >= startOfMonth("-2M")` is valid (function), while `created >= -2M` is NOT a
month offset (raw operand). This exactly matches the claim.

### 3. Case-insensitive unit matching (`2M` == 2 minutes) — CONFIRMED

The decisive evidence is Atlassian's own Jira API documentation for the duration parser
(`DateUtils.getDuration`):

> "Given a duration string, get the number of minutes it represents
> w = weeks  d = days  h = hours  m = minutes (all case insensitive)
> If no category is specified, assume minutes."
> — https://docs.atlassian.com/software/jira/docs/api/1.4/com/atlassian/jira/util/DateUtils.html

"all case insensitive" + "If no category is specified, assume minutes" means `M` matches the
`m` (minutes) category — there is no separate month category in this parser — so `-2M` is parsed
as **2 minutes**, identical to `-2m`. This is the exact silent-misinterpretation the PR targets.

Caveat: the *current* consumer-facing Jira Cloud JQL-fields support page does NOT itself restate
the case-insensitivity rule; the explicit statement lives in the API/Javadoc. The support page's
"Query terms in Jira are not case-sensitive" line refers to text-search terms and is NOT valid
evidence for date-suffix behavior on its own.

### 4. `-1y` returns empty result vs. error — REFUTED

The claim asserts `-1y` yields an **empty result set** rather than an error. Atlassian's own
issue tracker documents the opposite — it is treated as an **invalid date value** and errors:

> `created >= "-1y"` "throws an error message stating that the date value '-1y' for the 'created'
> field is invalid." (valid examples given: `'-5d', '4w 2d'`)
> — https://jira.atlassian.com/browse/JRACLOUD-82707

Through the validated REST search endpoint, invalid JQL surfaces as HTTP 400:

> "Jira may return a HTTP 400 'Bad Request' if the JQL query is invalid" (response body carries
> JSON `errorMessages`)
> — https://support.atlassian.com/jira/kb/how-to-handle-http-400-bad-request-errors-on-jira-search-rest-api-endpoint/

**Why this matters for the PR:** `y` is asymmetric to `M`. `M` is the genuinely dangerous case
(silently reinterpreted as minutes, no error, wrong results). `y` is already rejected by Jira with
an error, so it fails loudly server-side rather than silently. The claim's stated rationale for
`y` (empty result) is incorrect, but that does NOT invalidate the fix — see implications below.

---

## Implications for PR #863 ("reject `M` and `y`")

- **Rejecting `M` client-side is clearly correct and valuable.** Jira silently reinterprets `-2M`
  as 2 minutes (case-insensitive parser, no server error), so a user typing `-2M` intending
  "2 months" gets silently wrong results with zero feedback. Pre-rejecting it in the CLI converts
  a silent-wrong-result footgun into a clear error. This is the strongest justification for the fix.

- **Rejecting `y` client-side is defensible but for a different reason than the claim states.**
  Jira already errors on `-1y` (HTTP 400 via the search API), so the CLI is not preventing a
  silent-wrong-result — it is providing an earlier, cleaner, better-worded error before the round
  trip. Good UX, but the PR description/commit message should NOT claim "`-1y` returns empty
  results" as the rationale — that premise is factually wrong per JRACLOUD-82707. Recommend
  correcting the rationale wording to "`-1y` is rejected by Jira as an invalid date value" if the
  PR cites part 4.

- **Do not conflate raw offsets with function args.** If the CLI ever needs to support month/year
  granularity, the correct mechanism is `startOfMonth("-2M")` / `startOfYear("-1y")` functions,
  where `M`/`y` ARE valid — not the raw `-<n><unit>` operand. The rejection should be scoped to
  raw relative-offset operands only.

---

## Confidence

- Parts 1, 2, 3: **HIGH** — multiple independent Atlassian first-party sources (current support
  docs + API Javadoc + community official answer), mutually consistent.
- Part 4: **HIGH (refutation)** — direct Atlassian issue-tracker ticket (JRACLOUD-82707) plus the
  REST 400 KB article. One residual nuance: exact surfacing (400 vs. a UI validation message)
  depends on whether the query is submitted through the validated REST search path vs. some
  autocomplete/basic-search contexts; the underlying parse is invalid in all documented cases,
  so "empty result set" is not supported by any source found.

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 1 | Deep multi-source verification of JQL relative-date unit set, `M`/`y` support, case-insensitivity, and `-1y` error-vs-empty behavior against Atlassian first-party docs |
| Training data | 0 areas | Not relied upon — all claims sourced to live Atlassian docs/tracker |

**Total MCP tool calls:** 1
**Training data reliance:** low — every verdict is backed by a first-party Atlassian URL with quoted text.

### Key Sources
- https://support.atlassian.com/jira-software-cloud/docs/jql-fields/ (unit set `{w,d,h,m}`)
- https://support.atlassian.com/jira-software-cloud/docs/jql-vulnerability-search/ (`m,h,d,w` examples)
- https://support.atlassian.com/jira-software-cloud/docs/jql-functions/ (function-arg grammar `(+/-)nn(y|M|w|d|h|m)`)
- https://docs.atlassian.com/software/jira/docs/api/1.4/com/atlassian/jira/util/DateUtils.html (case-insensitive, default minutes)
- https://jira.atlassian.com/browse/JRACLOUD-82707 (`-1y` invalid → error)
- https://support.atlassian.com/jira/kb/how-to-handle-http-400-bad-request-errors-on-jira-search-rest-api-endpoint/ (invalid JQL → HTTP 400)
- https://community.atlassian.com/forums/Jira-questions/What-period-formats-are-accepted-in-JQL-search/qaq-p/2481874 (month/year unsupported in raw offsets)
