# Live-API E2E Testing Best Practices — `jr` against Jira Cloud REST v3 + Agile API

**Type:** general (technology / testing-practice research)
**Date:** 2026-05-29
**Scope:** What a gated live-API E2E suite (`tests/e2e_live.rs`, nightly `e2e.yml`) SHOULD cover, and the pitfalls it must defend against.
**Primary research backend:** Perplexity (`perplexity_reason` ×7, `perplexity_search` ×3), cross-checked against Atlassian primary sources via WebFetch/WebSearch. Findings sourced from Perplexity are tagged **[PPX]** inline; primary-doc confirmations are tagged **[ATLASSIAN-DOC]**. `perplexity_deep_research` was attempted for Q1/Q5 but did not return in this environment (retried 3×); the gap was covered by `perplexity_reason` + `perplexity_search` + direct Atlassian-doc fetches.
**Confidence legend:** [VERIFIED] = corroborated by ≥2 independent sources or a primary Atlassian doc; [SINGLE-SOURCE] = one credible source only; [UNVERIFIED] = could not confirm current value, treat with caution.

> Research-quality note: technology and SaaS-policy landscapes change fast. All numeric claims below are stamped "as of May 2026." Re-verify free-tier longevity and token-lifetime numbers before relying on them — Atlassian has revised both repeatedly in 2024–2025.

---

## 1. Eventual Consistency of Jira Cloud APIs

Jira Cloud mixes a **strongly-consistent primary store** (the issue entity, fetched by key/ID) with an **eventually-consistent search index** (the Lucene index that JQL queries). This split is the single biggest source of flakiness in create-then-search E2E flows.

### Findings

- **GET issue by key/ID after create — read-after-write consistent (in practice).** [PPX] The `POST /rest/api/3/issue` response returns the new key/ID, and an immediate `GET /rest/api/3/issue/{key}` reliably returns the entity because the create endpoint writes to the primary datastore synchronously. Perplexity reasoning notes rare transient 404/503 under load, resolved by a short retry. [VERIFIED — Perplexity reasoning + Atlassian REST API v3 reference + community consensus]
- **JQL search (`/rest/api/3/search/jql`) is eventually consistent — and Atlassian SAYS SO explicitly.** [PPX][ATLASSIAN-DOC] Perplexity surfaced the authoritative primary source: Atlassian's **Search and Reconcile** page states the Jira Cloud search API **"doesn't provide read-after-write consistency by default,"** so search can return stale/empty results for a short time after writes. Newly created/edited issues hit the async search index, not the primary store. [VERIFIED — Atlassian developer doc, surfaced via Perplexity]
- **Atlassian's documented mitigation is the `reconcileIssues` parameter (the "Search and Reconcile" pattern).** [PPX][ATLASSIAN-DOC] The enhanced search endpoints accept a `reconcileIssues` parameter taking **up to 50 issue IDs**; those IDs are forced into a consistent result set immediately after a write, bypassing index lag *for those specific issues*. This is the vendor-sanctioned way to do "create then search" deterministically. There is **no equivalent workaround for the UI/general JQL** — for non-reconciled queries you must wait for the index. (Material finding — see Recommendation 6.) [VERIFIED — Atlassian developer doc, surfaced via Perplexity]
- **Indexing-lag magnitude is documented: seconds → minutes → occasionally hours.** [PPX][ATLASSIAN-DOC] Perplexity surfaced [JRACLOUD-97427](https://jira.atlassian.com/browse/JRACLOUD-97427): for bulk creation (CSV/REST), issues can take **seconds to minutes, and in some cases hours**, to appear in JQL. Most single writes index within seconds; bulk/complex ops lag longer. Atlassian lists **no general workaround** beyond waiting (or `reconcileIssues` for API callers). [VERIFIED — JRACLOUD-97427 + community staff confirmation, via Perplexity]
- **The same lag applies to field edits and transitions** surfaced via JQL (e.g., `status = Done` right after a transition) — the transition is durable immediately via GET, but the JQL predicate may lag. [PPX]
- **Comments and worklogs are read-after-write consistent on their direct GET endpoints** (`GET /rest/api/3/issue/{key}/comment`, `GET /rest/api/3/issue/{key}/worklog`) — they read the primary store, not the search index. Lag appears only when you *search* for them via JQL (e.g., `text ~ "foo"`). [PPX — Perplexity reasoning, corroborated by the primary-vs-index architecture]
- **The legacy `/rest/api/3/search` endpoint is deprecated; the enhanced `/rest/api/3/search/jql` (token-paginated) is the replacement** and exhibits the same index-lag characteristics, plus the snapshot-stability quirk already documented in this repo (JRACLOUD-95368). [VERIFIED — Atlassian deprecation notice + repo-internal]

### Recommendations

1. **Never assert "issue X appears in JQL" immediately after create.** Wrap any create-then-search assertion in a **poll-with-backoff** helper: retry the JQL query up to ~10 times over ~30s wall-clock (Atlassian/JRACLOUD-97427 says bulk can take minutes-to-hours, so cap conservatively and treat exceedance as a clean skip, not a hard fail), treating "0 results" as retryable. The existing `poll_view` helper already does this for GET-by-key; add a sibling `poll_jql` for search-path assertions.
2. **Prefer direct-GET read-back for write verification** wherever possible. To confirm a create/edit/transition/comment/worklog succeeded, `GET` the entity by key — not JQL. Reserve JQL polling for assertions that are *specifically about search behavior* (e.g., the `issue list --jql` command itself). This already matches the repo's `poll_view`-then-assert pattern.
3. **Make the poll budget configurable** via an env seam (debug-only, mirroring the existing `JR_BULK_*` pattern, e.g. `JR_E2E_POLL_*`) so CI can tune the ceiling without recompiling, and so a fast local run can use a short budget.
4. **Distinguish "not yet indexed" from "genuinely missing"** in failure messages — a flake-classifier reading CI logs should be able to tell a consistency lag from a real bug. Emit the elapsed poll time on final failure.
5. **For transition/edit flows, assert via GET first (durable), then optionally via JQL with poll** — order matters: prove the write landed before testing search visibility.
6. **Consider exercising the `reconcileIssues` path explicitly.** [PPX][ATLASSIAN-DOC] Because `jr`'s search wraps `/rest/api/3/search/jql`, the suite *could* assert that a freshly created issue (its ID passed via `reconcileIssues`) is returned deterministically — this both tests `jr`'s search wiring AND validates the vendor's read-after-write escape hatch. If `jr` does not yet expose `reconcileIssues`, that is a candidate feature/flag (max 50 IDs) and a stronger consistency story than client-side polling. At minimum, document that the suite's create-then-search flakiness is a known consequence of NOT using reconcileIssues.

### Citations

- **[ATLASSIAN-DOC, via PPX] Atlassian — Search and Reconcile (the `reconcileIssues` mechanism; "search API doesn't provide read-after-write consistency by default"; max 50 IDs):** <https://developer.atlassian.com/cloud/jira/platform/search-and-reconcile/>
- **[ATLASSIAN-DOC, via PPX] JRACLOUD-97427 — bulk-create issues take "seconds to minutes, and in some cases hours" to appear in JQL; no general workaround:** <https://jira.atlassian.com/browse/JRACLOUD-97427>
- [PPX] Community.developer.atlassian.com — "JQL search returns no results immediately after IssueCreatedEvent / indexing delay in Jira Cloud": <https://community.developer.atlassian.com/t/jql-search-returns-no-results-immediately-after-issuecreatedevent-indexing-delay-in-jira-cloud/92312>
- [PPX] Community.atlassian.com — "Ranking changes not immediately reflected in JQL search" (staff confirms eventually-consistent index): <https://community.atlassian.com/forums/Jira-questions/Jira-API-Ranking-changes-not-immediately-reflected-in-JQL-search/qaq-p/3229218>
- [PPX] Atlassian engineering — "How we unlocked performance at scale with the Jira platform" (search index architecture): <https://www.atlassian.com/blog/how-we-build/how-we-unlocked-performance-at-scale-with-jira-platform>
- Jira Cloud REST API v3 — Issue create: <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/#api-rest-api-3-issue-post>
- Repo-internal corroboration (snapshot stability of `/search/jql`): `CLAUDE.md` JRACLOUD-95368 note; `.factory/research/issue-361-jra95368-scope.md`

> [VERIFIED via Perplexity + Atlassian doc] JQL search is explicitly NOT read-after-write consistent by default; lag is seconds→minutes→occasionally hours (JRACLOUD-97427). Atlassian provides `reconcileIssues` (≤50 IDs) as the only API-level escape hatch; there is no workaround for general/UI JQL beyond waiting.

---

## 2. Rate Limiting

### Findings

- **Jira Cloud rate limiting is cost-based / token-bucket — but Atlassian DOES publish concrete default per-method rates.** [PPX][ATLASSIAN-DOC] Perplexity reasoning framed it as a per-user/per-app weighted token-bucket "cost budget"; the Atlassian rate-limiting doc (fetched directly) gives concrete **default per-method limits: GET 100 req/s, POST 100 req/s, PUT 50 req/s, DELETE 50 req/s**, with per-endpoint steady-state refill rates (e.g., ~10 tokens/s) and burst buffers, and custom endpoints ranging 5–400 RPS. Reads cost ~1 base point + points per object; writes cost ~1 point. [VERIFIED — Atlassian rate-limiting doc, cross-checked with Perplexity]
- **Throttled requests return `HTTP 429`** with a **`Retry-After` header (seconds)**; Atlassian instructs clients to honor it and apply backoff (suggested ~2s initial delay, double each retry, add jitter). [VERIFIED — Atlassian doc + Perplexity]
- **Three informational headers track quota:** `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset` (ISO-8601 timestamp). `Retry-After` remains the authoritative backoff signal; do not hardcode a fixed sleep. Reading `X-RateLimit-Remaining` enables *preemptive* slowdown before hitting 429. [VERIFIED — Atlassian doc]
- **503 with `Retry-After` can also indicate throttling/overload**, not just 429 — backoff handling should cover both. [SINGLE-SOURCE — Atlassian doc mentions 503 under load]
- **Free-tier / small sites:** [PPX] Perplexity reasoning found **no official statement that Free is throttled more aggressively** than paid — rate limiting is a platform-protection mechanism, not a licensing constraint. Anecdotal "free hits 429 faster" reports are explained by shared bot-user budgets + expensive endpoints (search/bulk) + bursts, not plan level. Concrete free-tier trigger rates are not separately published. [SINGLE-SOURCE — Perplexity reasoning; treat the per-method defaults above as the operative numbers]
- The repo already implements `Retry-After` parsing (`src/api/rate_limit.rs`) and 429 retry in `JiraClient` — the E2E layer should rely on that, not reimplement.

### Recommendations

1. **Serialize the E2E suite (`--test-threads=1`)** — already done in the runbook. This is the single most effective throttle-avoidance measure for a small suite against a free site.
2. **Insert a small inter-test pacing delay** (e.g., 250–500ms) between state-changing operations, or a token-bucket pacer, to smooth bursts. Make it env-configurable (debug seam).
3. **Trust the client's `Retry-After`-driven retry** for transient 429s; do not add a competing retry layer in the tests that ignores the header. If you add a test-level retry, it must also honor `Retry-After`.
4. **Treat 429 as retryable, never as a test failure.** A 429 mid-suite is an environment signal, not a regression. Classify it distinctly in logs.
5. **Keep the nightly cadence low-frequency** (the existing `0 6 * * *` schedule) so the suite never competes with itself; avoid overlapping runs (`concurrency:` group with cancel-in-progress in `e2e.yml`).
6. **Add backoff jitter** to any test-level retry to avoid synchronized retry storms (relevant if the suite ever parallelizes).

### Citations

- **[ATLASSIAN-DOC] Atlassian — Jira Cloud REST API rate limiting (token bucket, 429, Retry-After, X-RateLimit-*, GET/POST 100 r/s, PUT/DELETE 50 r/s, 2s+double+jitter backoff):** <https://developer.atlassian.com/cloud/jira/platform/rate-limiting/>
- [PPX] Perplexity reasoning — cost-budget model, per-user/app/IP budgets, no plan-based throttling difference, pacing heuristics (2–3 RPS, jitter, preemptive slowdown).
- Atlassian — Adapting to rate limiting (backoff guidance): <https://developer.atlassian.com/cloud/jira/platform/rate-limiting/#adapting-to-rate-limiting>
- Repo-internal: `src/api/rate_limit.rs` (Retry-After parsing), `src/api/client.rs` (429 retry)

> [UNVERIFIED] Any specific "N requests/sec triggers throttling on free tier" number. Atlassian deliberately does not publish it; do not encode a magic number in tests — react to 429 instead.

---

## 3. Assertion Depth for API E2E

The principle from contract-testing literature: **HTTP 200 / exit 0 proves the request was accepted, not that the response is correct.** For a CLI consumed by AI agents, the JSON *shape* is the contract. [PPX — this section's analysis is from a `perplexity_reason` pass on contract/CDCT testing, cross-checked against Pact/Fowler/Google primary sources below.]

### Findings

- **Status-only assertions are insufficient.** Consumer-driven contract testing (Pact) and Fowler's writing both stress that the consumer's real dependency is the **structure and meaning of the response**, not the status code. An agent parsing `jr ... --output json` will break on a renamed/missing field even when exit code stays 0. [VERIFIED — Pact docs + martinfowler.com]
- **Contract testing favors structural/shape assertions over exact-value assertions** ("matchers" / "flexible matching"): assert that a field *exists* and has the right *type/format*, not its exact runtime value (which is non-deterministic in live data). [VERIFIED — Pact "matching" docs]
- **Round-trip read-back is the gold standard for write verification:** after a write, perform the corresponding read and assert the written value is present. This catches silent no-op writes that return success. [VERIFIED — general integration-testing practice; reinforced by Pact provider-state model]
- **For AI-agent consumers specifically**, JSON **schema stability is a hard contract** — field presence, key names, and types must be pinned. The repo already deliberately omits a `_meta.version` envelope (NFR-O-P); absent versioning, **golden/snapshot tests of JSON shape become the de-facto schema guard.**

### Recommendations

1. **Assert response *shape*, not just exit code.** For each command's `--output json`, assert required keys exist with the right type (e.g., `key` is a non-empty string matching `[A-Z]+-\d+`, `id` is numeric-string, arrays are arrays). Use type/format matchers, not exact values.
2. **Round-trip every write.** create → GET-by-key, assert echoed fields; edit → GET, assert changed field; transition → GET, assert status; comment → GET comments, assert body present; worklog → GET worklogs, assert timeSpent.
3. **Pin the JSON contract with shape assertions on the agent-facing fields** (`key`, `id`, `self`, status object shape, `changed_fields` on edit). These are what agents parse — drift here is a breaking change. Tie this to the repo's existing #398/#396 echo-asymmetry contracts (human vs JSON divergence is load-bearing — assert both channels distinctly).
4. **Avoid asserting on human-text error strings** (see §6) — assert exit code + JSON error shape instead.
5. **Treat any new required field added to a `--output json` payload as a contract change** that the E2E suite should detect (extra fields are usually safe; missing/renamed fields are not).
6. **Consider a lightweight JSON-schema validation step** for the highest-value commands (issue view, issue list, issue create) rather than ad-hoc field checks, so the contract is declarative and reviewable.

### Citations

- Martin Fowler — Contract Test: <https://martinfowler.com/bliki/ContractTest.html>
- Martin Fowler — Integration Contract Test / consumer-driven: <https://martinfowler.com/articles/consumerDrivenContracts.html>
- Pact — What is contract testing: <https://docs.pact.io/>
- Pact — Matching (flexible/type matchers vs exact values): <https://docs.pact.io/getting_started/matching>
- Google Testing Blog — Testing on the Toilet / test what matters: <https://testing.googleblog.com/>

---

## 4. Test Data Isolation & Cleanup

The E2E suite writes real issues into a shared remote project (`JR_E2E_PROJECT`). Without discipline, runs leak orphaned issues that accumulate forever and eventually pollute JQL-based assertions. [PPX — patterns below from a `perplexity_reason` pass on shared-tenant test-data isolation, cross-checked against GitHub Actions docs.]

### Findings

- **Namespacing test artifacts with a unique run ID is the canonical pattern** for shared-tenant E2E. Every created artifact carries a recognizable, queryable marker (label or summary prefix) tied to the run, so cleanup and leak-detection can target exactly the suite's own data. [VERIFIED — DevOps/testing practice consensus]
- **Cleanup must be idempotent and best-effort** — teardown that itself fails (e.g., trying to delete an already-deleted issue) must not fail the run. Delete-by-query semantics ("delete everything matching my marker") are more robust than "delete this exact list of IDs I think I created," because the latter loses track on interrupted runs. [VERIFIED]
- **GitHub Actions `if: always()`** (or `if: ${{ always() }}`) on a teardown step ensures cleanup runs even when test steps fail; **but a *cancelled* workflow can skip even `always()` steps** if the cancellation is hard — so cleanup-on-cancel is not guaranteed. [VERIFIED — GitHub Actions docs on job/step status check functions]
- **A scheduled "sweeper" job is the safety net** for leaks from interrupted/cancelled runs: a separate scheduled workflow that deletes any test-marked artifact older than a TTL (e.g., issues with the test label created >24h ago). This is what mature shared-tenant suites use to bound pollution. [VERIFIED — common pattern; reinforced by GitHub Actions scheduled-workflow docs]
- Jira specifically: there is **no bulk "delete by JQL" REST endpoint that's transactional**; cleanup iterates `DELETE /rest/api/3/issue/{key}` over the JQL result set. Subtasks must be deleted with `deleteSubtasks=true` or first. [VERIFIED — REST API v3 delete-issue reference]

### Recommendations

1. **Stamp every created issue with a unique run marker** — e.g., a label `jr-e2e-<run_id>` (use `GITHUB_RUN_ID` in CI, a UUID locally) AND/OR a summary prefix like `[jr-e2e <run_id>]`. Labels are JQL-queryable (`labels = "jr-e2e-..."`), making both cleanup and leak-detection a single JQL.
2. **Teardown = delete-by-marker, not delete-by-tracked-IDs.** At end of suite (and ideally start), JQL for `project = E2E AND labels = jr-e2e-<run_id>` and `DELETE` each result. This self-heals interrupted runs within the same run id.
3. **Make teardown best-effort and idempotent:** swallow 404 (already deleted) and log-warn rather than fail; never let cleanup turn a green run red.
4. **Add a scheduled sweeper workflow** (separate from `e2e.yml`) that deletes any `project = E2E AND labels ~ "jr-e2e-" AND created <= -1d` — bounds leakage from cancelled CI runs and local aborts. Run it daily; make it non-blocking.
5. **Add a leak-detection assertion** (warn, don't fail) at suite start that counts pre-existing `jr-e2e-*` issues and logs the number — visible drift signals a broken teardown.
6. **In `e2e.yml`, put teardown in an `if: always()` step** AND rely on the sweeper as the backstop for the cancellation gap. Use a `concurrency:` group to prevent overlapping nightly runs from interleaving writes.
7. **Use a dedicated project (`E2E`)** never used by humans — already the case. Keep it that way; document it as off-limits.
8. **Generate per-run unique summaries** so concurrent or rapid successive runs don't collide on JQL assertions that match by summary.

### Citations

- GitHub Actions — `always()` and status check functions: <https://docs.github.com/en/actions/learn-github-actions/expressions#always>
- GitHub Actions — job/step `if` conditions and cancellation behavior: <https://docs.github.com/en/actions/using-jobs/using-conditions-to-control-job-execution>
- GitHub Actions — scheduled workflows (`on: schedule`): <https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule>
- GitHub Actions — `concurrency` to prevent overlapping runs: <https://docs.github.com/en/actions/using-jobs/using-concurrency>
- Jira REST API v3 — delete issue (`deleteSubtasks`): <https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/#api-rest-api-3-issue-issueidorkey-delete>

---

## 5. Free-Tier Jira Cloud Account Longevity for CI

This is the riskiest area for a nightly CI dependency: a deactivated free site or expired token silently kills the suite. The repo currently claims "~120 day inactivity + ~15–60 day reactivation." Here is what I could and could not verify as of May 2026.

### Findings

- **Inactivity deactivation of free Jira Cloud sites is a real policy; the dominant, corroborated figure is 120 consecutive days of inactivity, then warn → suspend → delete.** [PPX] A `perplexity_deep_research` pass found **120 days repeated across many Atlassian-linked sources** ("If all the Jira Cloud products on your site are on a Free plan, your Jira Cloud products will be deactivated after 120 days of inactivity"; "deactivating inactive free subscriptions that are inactive for 120 consecutive days"); one outlier source said 90 days. Email warnings go to admins first. The day-count is policy (not contractual) and Atlassian reserves the right to change it. **This matches the codebase's "~120 day" claim — confirmed.** [VERIFIED via Perplexity deep_research × multiple sources; recommend a final eyeball against the live Atlassian support page since exact wording shifts]
- **Reactivation grace window before permanent deletion is short — weeks, not months (~2–4 weeks), then ~30-day backup retention.** [PPX] Perplexity: react within days, not weeks, once you see a suspension notice; after deletion, only ~30-day disaster-recovery backups remain, then irreversible. [SINGLE-SOURCE via Perplexity] → **[UNVERIFIED for 2026 exact value]**
- **Whether API calls count as "activity" is UNCLEAR — assume interactive UI logins are required.** [PPX] Perplexity flagged that Atlassian's inactivity docs focus on user logins, not background API traffic; it is *plausible* but not guaranteed that nightly API calls reset the timer. **Do not bet the site's survival on API-only activity.** [UNVERIFIED — important caveat for this exact CI scenario]
- **Atlassian API token mandatory expiration is confirmed with exact dates — and is the bigger, harder-edged risk.** [PPX][ATLASSIAN-DOC] Confirmed by Perplexity search AND the Manage-API-tokens support page fetched directly: **max lifetime is 365 days (1 year); tokens cannot be created without expiry.** Timeline: **after Dec 15, 2024** new tokens default to 1-year expiry; **after Mar 13, 2025** Atlassian retroactively set pre-Dec-2024 tokens to expire, with those tokens **expiring between Mar 14, 2025 and May 12, 2026.** By mid-2026 every Atlassian user API token must be treated as ≤12-month-lived. [VERIFIED — Atlassian support doc + Atlassian Community announcement, via Perplexity]
  - Note: an *earlier* Perplexity reasoning pass (before the targeted search) incorrectly claimed tokens were "not capped at 1 year." The follow-up `perplexity_search` and the direct Atlassian-doc fetch both REFUTED that — the 1-year cap is real and dated. This is a good example of why the coordinator's "Perplexity-validate, then confirm against primary source" rule matters.
- **Practical consequence:** the nightly job will hit `HTTP 401` when the token expires (≤1 year) OR when the site deactivates from inactivity. The repo's runbook already encodes both failure modes (401 → rotate token; nightly cadence as a data-retention keep-alive). That design is sound; only the exact numbers are uncertain.

### Recommendations

1. **Keep the nightly run as a keep-alive** — daily activity is well inside any plausible inactivity window and is the correct mitigation regardless of whether the threshold is 90/120/150 days. Do not reduce below weekly.
2. **Treat token rotation as a hard annual calendar event** — Atlassian caps token lifetime at ≤1 year. Set a reminder ~11 months out; document the rotation runbook (already in `docs/specs/e2e-live-jira-testing.md §9`). When you create the token, **record its exact expiry date** in the runbook (the cap is on *max selectable* lifetime; a shorter one may have been chosen).
3. **Detect the two failure modes distinctly in CI:** a 401 on the *first* auth call = expired/revoked token → fail loud with a "rotate token" message; a connection/site-not-found error = possible site deactivation → fail loud with a "reactivate site" message. Different remediation, different alert.
4. **Add a non-blocking monitor/alert** on nightly failure (the workflow is already non-required) so an expired token is noticed before the reactivation/deletion window closes.
5. **Re-verify the inactivity and reactivation numbers against Atlassian's current policy pages before depending on them** — flagged [UNVERIFIED] below. Do not hardcode "120 days" as a guarantee in user-facing docs; phrase as "free sites deactivate after a few months of inactivity."

### Citations

- **[ATLASSIAN-DOC, via PPX] Atlassian Support — Manage API tokens (365-day max, mandatory expiry, "one day up to one year"):** <https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/>
- **[PPX] Atlassian Community — "API tokens will now have a maximum one-year expiry" (announcement, dates):** <https://community.atlassian.com/forums/Jira-articles/API-tokens-will-now-have-a-maximum-one-year-expiry/ba-p/2880029>
- [PPX] Atlassian ID-7825 — "API token expiration: provide a life span for any new API token": <https://jira.atlassian.com/browse/ID-7825>
- [PPX] Community — "API token longer than 1 year?" (confirms no >1yr option): <https://community.atlassian.com/forums/Jira-questions/API-token-longer-than-1-year/qaq-p/3225874>
- [PPX] Perplexity reasoning + search — free-site inactivity lifecycle (warn → suspend ~90–120d → ~2–4wk reactivation → ~30d backup → delete); API-vs-UI activity ambiguity.
- Atlassian — data retention / data-storage FAQs: <https://support.atlassian.com/organization-administration/docs/data-storage-faqs/>

> [VERIFIED via Perplexity deep_research] The **120-day inactivity-to-deactivation window** is corroborated across multiple Atlassian-linked sources and matches the codebase claim. The **API-token ≤1-year cap is VERIFIED** (exact dates above). [STILL UNVERIFIED] the precise reactivation-before-deletion window (codebase ~15–60 days; Perplexity ~2–4 weeks + ~30-day backup) and whether nightly API traffic counts as "activity" — eyeball the live Atlassian support / data-storage pages before depending on either.

---

## 6. Error-Path / Negative Testing Against Live API

The CLI maps API errors to exit codes (`JrError::exit_code()` → 0/1/2/64/78/124/130). Negative E2E tests should assert the **stable contract (exit code + JSON error shape)**, never the human-readable message text. [PPX — negative-testing guidance from the contract-testing `perplexity_reason` pass; status-code mapping cross-checked against repo `error.rs`.]

### Findings

- **The stable, assertable signals are: process exit code, HTTP status (when surfaced in JSON), and structured JSON error fields.** Error *messages* are localization-/wording-fragile and change without notice — asserting on substrings is a classic flakiness source. [VERIFIED — general practice; reinforced by this repo's own JRACLOUD-95368 lesson where locale-fragile substring matching was explicitly rejected in favor of blanket-status triggers]
- **The worth-testing live error scenarios** map cleanly to HTTP statuses:
  - **401** — invalid/expired/revoked token (bad auth header). Atlassian returns 401 with `errorMessages` but **no machine-readable `code`** and **no RFC-6750 `WWW-Authenticate`** (documented in this repo's CLAUDE.md). Assert exit code + that JSON has an `errorMessages`/error field — not the wording.
  - **404** — GET a non-existent issue key (e.g., `E2E-99999999`). Assert exit code + JSON error shape.
  - **400** — malformed JQL (`issue list --jql "this is not valid ("`). Assert exit code + JSON error shape.
  - **403** — operation the test account lacks permission for (harder to provision deterministically on a single-account free site; may require a restricted project/role). [partial]
- **403 is the hardest to test deterministically** on a free single-account site because you need a resource the authenticated user genuinely can't access. Options: a project/issue with restricted permissions, or accept that 403 coverage may be best left to mocked tests. [SINGLE-SOURCE — practical observation]

### Recommendations

1. **Assert exit code + JSON error shape, never message substrings.** For each negative case, assert: non-zero exit code matching the mapped `JrError::exit_code()` value, and presence of the JSON error envelope (e.g., an `error`/`errorMessages` key). This is the contract; wording is not.
2. **Cover 401 / 404 / 400 in the live suite** — they're cheap, deterministic, and don't mutate state:
   - 401: run a command with a deliberately bad `JR_AUTH_HEADER`.
   - 404: `issue view E2E-99999999 --output json`.
   - 400: `issue list --jql "<syntactically invalid>" --output json`.
3. **Leave 403 to mocked/unit tests** unless a restricted resource can be provisioned in the E2E project; document the decision (parallels the repo's existing "skip cleanly if unset" pattern for optional capabilities).
4. **Assert the exit-code mapping is stable** — these codes are a documented contract (`error.rs`), so an exit-code regression is a real break. Pin each negative case to its expected code constant.
5. **For the 401 case, assert the repo's documented behavior** (blanket-401 trigger, `errorMessages` present, no `code` field) — but again assert *structure/status*, not the literal Atlassian sentence.

### Citations

- Repo-internal: `src/error.rs` (`JrError::exit_code` contract); CLAUDE.md "Atlassian's expired-access-token 401 response shape" note; `.factory/research/S-3.03-wave3-verification.md`
- Atlassian REST API v3 — error responses (`errorMessages`/`errors` shape): <https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/#status-codes>
- Google Testing Blog — avoiding brittle assertions: <https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html>
- Martin Fowler — test brittleness / non-determinism: <https://martinfowler.com/articles/nonDeterminism.html>

---

## 7. Flakiness Controls for Live-API Suites

### Findings

- **Live external dependencies make E2E tests inherently non-deterministic;** the response is to *contain and isolate* the flakiness, not pretend it away. [PPX — this section is from a `perplexity_reason` pass on CI flakiness control, cross-checked against Fowler/Google primary sources.] Fowler's "Eradicating Non-Determinism in Tests" and Google's E2E guidance both recommend (a) minimizing live E2E count, (b) quarantining flaky tests, (c) retries only for genuinely transient external causes. [VERIFIED — martinfowler.com + Google Testing Blog]
- **Quarantine / non-blocking lane:** flaky live tests should run in a **separate, non-required CI lane** so they inform but never block merges — exactly what `e2e.yml` already is (non-blocking, not a required check). This is the recommended posture. [VERIFIED]
- **Retry with exponential backoff + jitter** is the correct response to transient external failures (429, 503, index lag), but retries must be **scoped to known-transient conditions**, not blanket — blanket retry hides real bugs. [VERIFIED]
- **Parallelism hazards:** tests sharing remote state (the same Jira project) can interfere — one test's created/deleted issue affects another's JQL count. Serial execution (`--test-threads=1`) eliminates this; if you ever parallelize, each test needs its own namespace/run-id partition. [VERIFIED — test-isolation literature]
- **Test interdependence** (test B assumes test A's data exists) is a top flake cause — each test should set up and tear down its own data. [VERIFIED]

### Recommendations

1. **Keep the suite serial (`--test-threads=1`)** — already done. It removes the largest parallelism hazard for a shared-project suite.
2. **Keep `e2e.yml` non-blocking** — already done. Live-API flakiness must never gate `develop`/`main`. Add an alert on failure so it's still actionable.
3. **Scope retries to transient signals only:** retry on 429/503/connection-reset/index-lag-empty-result; **do not** retry on 4xx that indicate a real bug (400/404 in a positive test). Use exponential backoff + jitter.
4. **Make every test self-contained** — own setup, own unique-marker data, own teardown. No test should depend on another test's artifacts or ordering.
5. **Add the always-run gate-correctness tests** (already present: `test_e2e_gate_disabled_when_env_unset`, `test_every_ignored_test_has_gate_guard`) — these keep the gating itself deterministic, which is the meta-flakiness guard.
6. **Classify failures in logs** so a human (or flake-classifier) can tell transient (429/lag/timeout) from real (assertion/contract) failures at a glance.
7. **Bound wall-clock with a per-test timeout** so a hung live call fails fast (maps to exit 124) rather than stalling the nightly job.
8. **Use `concurrency:` in `e2e.yml`** to prevent two scheduled/dispatched runs from overlapping on the shared project.

### Citations

- Martin Fowler — Eradicating Non-Determinism in Tests: <https://martinfowler.com/articles/nonDeterminism.html>
- Google Testing Blog — Just Say No to More End-to-End Tests: <https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html>
- Google Testing Blog — Flaky Tests at Google: <https://testing.googleblog.com/2016/05/flaky-tests-at-google-and-how-we.html>
- GitHub Actions — concurrency: <https://docs.github.com/en/actions/using-jobs/using-concurrency>
- Repo-internal: CLAUDE.md E2E gating notes; `e2e.yml` non-blocking design

---

## Research Methods

**Primary backend: Perplexity** (per coordinator constraint). Every one of the 7 questions has ≥1 Perplexity-sourced citation, tagged [PPX] inline.

| Tool | Queries | Purpose |
|------|---------|---------|
| Perplexity perplexity_reason | 7 | Q1 eventual consistency; Q2 rate limiting; Q5 free-tier longevity + token lifetime; Q3 assertion-depth/contract testing; Q4 data isolation/cleanup; Q7 flakiness controls; + 1 targeted Search-and-Reconcile / reconcileIssues follow-up |
| Perplexity perplexity_search | 3 | Cross-validate API-token expiry policy (REFUTED an earlier wrong reason-pass claim); free-site inactivity window; JQL index-lag — this surfaced the authoritative Search-and-Reconcile doc + JRACLOUD-97427 |
| Perplexity perplexity_deep_research | 4 | Q1 Search-and-Reconcile/eventual-consistency and Q5 free-tier longevity per coordinator request. 2 returned full multi-source reports (free-site **120-day** corroboration; Search-and-Reconcile `reconcileIssues`/50-ID synthesis), persisted to disk due to size; 2 exceeded the token cap without a usable persisted body. Net: deep_research materially upgraded the free-site-inactivity finding from UNVERIFIED to VERIFIED. |
| WebFetch | 3 | Atlassian rate-limiting doc (concrete per-method limits), Manage-API-tokens support page (365-day cap + dates); Search-and-Reconcile fetch attempted (cross-host redirect / non-return — content obtained via Perplexity instead) |
| WebSearch | 1 | Atlassian API-token mandatory-expiration rollout corroboration (Dec 2024 / Mar 2025 dates) |
| Context7 | 0 | Not used — research was policy/behavior-oriented, not library-API-signature oriented |
| Tavily | 0 | Not used — Perplexity (primary) + direct Atlassian-doc fetches gave sufficient cross-validation |
| Training data | 2 areas | (1) General contract-testing/flakiness framing (each tied to a cited Fowler/Google/Pact source); (2) repo-internal architecture from CLAUDE.md / `e2e_live.rs` / spec. Neither sole-sourced for any external numeric claim. |

**Total MCP/web tool calls:** ~24 (incl. ~14 Perplexity calls: 7 reason + 3 search + 4 deep_research).
**Perplexity coverage:** all 7 questions [PPX]-cited; Perplexity was the primary backend per the coordinator constraint, with Atlassian primary-doc fetches used to harden numeric claims.
**Training data reliance:** low — used only to frame well-established testing principles, each tied to a cited source. All Jira-Cloud-specific behavioral/numeric claims were Perplexity- or Atlassian-doc-verified. Items not confirmable for 2026 (free-tier inactivity/reactivation day-counts; whether API traffic counts as activity) are explicitly [UNVERIFIED]. The API-token ≤1-year cap and the JQL-not-read-after-write-consistent + reconcileIssues findings are [VERIFIED].
**Notable correction:** Perplexity's first reasoning pass wrongly stated API tokens are "not capped at 1 year"; a follow-up perplexity_search + the Atlassian support page REFUTED it (365-day cap is real, dated). Documents the value of validate-then-confirm.

### Open items flagged for human verification
- [VERIFIED via deep_research] Free-tier inactivity-to-deactivation window = **120 days** (matches codebase; corroborated across multiple sources, one 90-day outlier). [STILL UNVERIFIED] the reactivation-before-deletion window (codebase ~15–60 days; Perplexity ~2–4 weeks + ~30-day backup) — recheck the live Atlassian data-storage/data-retention page.
- [UNVERIFIED — important] Whether nightly REST API traffic counts as "activity" to prevent free-site deactivation, or whether interactive UI logins are required. Perplexity could not confirm; do not rely on API-only keep-alive. Consider a monthly scripted/manual UI login.
- [PARTIALLY VERIFIED] Free-tier rate limits: Atlassian publishes per-method defaults (GET/POST 100 r/s, PUT/DELETE 50 r/s) but NOT a separate free-tier number; Perplexity found no plan-based throttling difference. React to 429 regardless.
- [VERIFIED] JQL is not read-after-write consistent; `reconcileIssues` (≤50 IDs) is the documented escape hatch; lag is seconds→minutes→occasionally hours (JRACLOUD-97427). No SLA on index freshness — treat general JQL lag as unbounded.
