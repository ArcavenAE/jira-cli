---
document_type: research
title: "E2E testing jr against a real Jira Cloud instance in GitHub Actions (public repo)"
last_updated: 2026-05-28
research_method: WebSearch + WebFetch against primary Atlassian/GitHub docs (Perplexity + Tavily MCP servers were UNAVAILABLE this run — see Research Methods)
confidence_legend: "HIGH = confirmed by primary vendor doc + ≥1 independent source; MEDIUM = single primary source or multiple secondary sources, no contradiction; LOW = secondary sources only or conflicting evidence"
---

# E2E Testing `jr` Against a Real Jira Cloud Instance in CI

Decision-oriented research for designing a feature that runs end-to-end tests of the
`jr` CLI against a **real Jira Cloud instance**, triggered on push to `develop`/`main`
in GitHub Actions, on a **public** repository.

> **Tooling caveat (read first):** The Perplexity and Tavily MCP servers were not
> available in this environment (`mcp__perplexity__*` and `mcp__tavily__*` tools did not
> resolve). All findings below were gathered via WebSearch + WebFetch against **primary
> vendor documentation** (Atlassian developer/support docs, GitHub docs) and cross-checked
> against independent secondary sources. Where I could only reach secondary sources, I have
> downgraded confidence accordingly and flagged it. This does not change any HIGH-confidence
> conclusion (all HIGH items are anchored to a primary vendor doc), but the user asked for
> Perplexity/Tavily validation specifically, so this gap is disclosed up front.

---

## Q1 — Test instance options (2026)

**Recommended answer: Use a dedicated free Jira Cloud site as the primary CI target,
provisioned with one Scrum-enabled software project and one JSM project. Treat
Assets/CMDB E2E as out-of-scope (Premium-gated). Keep the site warm to dodge idle
deactivation.**

### (a) Free Jira Cloud plan — limits and capability coverage

| Dimension | Free plan (2026) | Confidence |
|---|---|---|
| Users (Jira Software/Work Mgmt) | **≤ 10 users** | HIGH |
| JSM agents | **≤ 3 agents** | HIGH |
| Projects / issues | Unlimited projects and issues | HIGH |
| Scrum **and** Kanban boards | **Included** (boards, sprints, backlog, agile reporting) | HIGH |
| Storage | 2 GB total | HIGH |
| Automation | ~100 rule runs/month, instance-wide | MEDIUM |
| Email notifications | ~100/day cap | MEDIUM (primary doc, exact number) |
| Assets / CMDB | **NOT available** (Premium feature) | HIGH |
| Idle deactivation | ~**120 consecutive days** no login → deactivation, then grace period | MEDIUM |

**Coverage against what `jr` exercises:**

- **Issue CRUD** (create/edit/view/list/move/assign/comment/link) — fully supported on Free. **HIGH.**
- **Sprints + boards** (`sprint`, `board`) — supported, **but require a Scrum board to exist**.
  The Free plan includes Scrum boards; your CI setup step must create a software project of
  **template type Scrum** so `sprint add/remove/current` have a board to target. `jr sprint`
  already errors on kanban-only projects (per `CLAUDE.md`), so the test project must be Scrum. **HIGH.**
- **Worklogs** (`worklog add/list`) — time tracking is core Jira, available on Free. **HIGH.**
- **JSM** (`queue`, `requesttype`, `issue create --request-type`) — JSM has a Free tier
  (≤ 3 agents) that includes service desks, queues, and request types. A **JSM project must be
  created** in setup for these commands to have a service desk to target. **MEDIUM** (Free JSM
  exists and includes queues/request types; exact 2026 feature gating of individual request-type
  fields not re-verified to primary source — treat JSM E2E as best-effort, gate behind a feature flag).
- **Assets/CMDB** (`assets`, `jr ... --request-type` with CMDB fields, linked-asset lookup) —
  **Assets is Premium-only.** A free site **cannot** exercise the `api/assets/*` paths end-to-end.
  These must be covered by the existing wiremock integration tests, not live E2E. **HIGH.**

### (b) Atlassian developer / sandbox instances

- **Marketplace developer instance** — if you enroll in the Atlassian developer program you can
  request a free development instance under the Atlassian Developer Terms, with a limited user
  count for test purposes. Viable but heavier-weight to set up than a plain free site, and the
  terms are oriented at app/Marketplace developers rather than CLI E2E. **MEDIUM.**
- **Built-in "Sandbox" feature** — the first-class Atlassian *Sandbox* (Admin → Apps → Sandboxes,
  a clone of production) is **Premium/Enterprise-only** and is not free. Not appropriate for an
  OSS CLI's CI. **HIGH.**

### (c) Stability for CI

- **Throttling** — Jira Cloud REST is rate-limited (429 + `Retry-After`); `jr` already has
  rate-limit retry in `api/rate_limit.rs` / `api/client.rs`. Free-tier cost budgets are generous
  enough for a small E2E suite if you keep request counts modest. **HIGH** (jr behavior),
  **MEDIUM** (free-tier limits are not separately published as hard numeric API caps).
- **Idle expiry** — ~120 days of no logins risks deactivation. A scheduled "keep-warm" workflow
  (a weekly `workflow_dispatch`/`cron` that does a trivial authenticated `jr issue list`) trivially
  prevents this. **MEDIUM.**

> **Recommendation:** One **dedicated free Jira Cloud site** with (1) a **Scrum** software project,
> (2) a **JSM** project, both created once and reused. Accept that **Assets/CMDB cannot be E2E-tested
> live** and stays under wiremock. Add a low-frequency keep-warm job to avoid idle deactivation.

---

## Q2 — Headless CI auth

**Recommended answer: Use email + API-token Basic auth as the CI credential. It works
non-interactively for REST v3 and the Agile API, it is the simplest to seed, and `jr`
already supports it. Plan for the 1-year token expiry with a documented annual rotation.
Do NOT use OAuth 3LO in CI.**

### Does Basic auth (email + API token) still work in 2026?

- **Yes — confirmed by Atlassian's own docs.** "Basic auth for REST APIs" still documents
  `--user me@example.com:my-api-token` and is the recommended method for "simple scripts and
  manual calls." Only **password-based** Basic auth and cookie auth were deprecated (back in 2019);
  email + **API token** Basic auth is current. **No 2026 deprecation is announced.** Applies to both
  the platform REST v3 and the Agile/Software REST API (same auth layer). **HIGH** (primary:
  developer.atlassian.com basic-auth + deprecation-notice pages).

### API token expiry policy (this is the operational gotcha)

- Tokens created **after Dec 15, 2024** default to a **1-year expiry**; you may set **1–365 days**
  at creation. **There is no "never-expires" option** (the long-standing feature requests
  ID-7825 / ID-8790 remain unresolved). **HIGH** (primary: support.atlassian.com manage-API-tokens).
- Tokens created **before Dec 15, 2024** were force-expired: after Mar 13, 2025 they were set to a
  1-year clock and **expire between Mar 14 and May 12, 2026.** So any pre-2025 token you might
  already have is dead or dying *right now*. **HIGH.**
- **Rotation cadence:** manual, at most yearly. Atlassian does not auto-rotate API tokens; the
  owner must mint a new one before expiry. **HIGH.**

### Is OAuth 3LO feasible headlessly?

- **Technically yes, but not recommended for this CI.** With `offline_access` scope you get a
  refresh token after one interactive consent, and you can pre-seed it as a secret and mint
  access tokens (1-hour lifetime, `expires_in: 3600`) non-interactively. **HIGH** (primary:
  oauth-2-3lo-apps doc + community confirmation of `expires_in=3600`).
- **The blocker is rotation.** Atlassian uses **rotating refresh tokens** — each refresh issues a
  *new* refresh token and invalidates the old one. In a CI environment you would have to **write
  the new refresh token back into a GitHub secret on every run** (e.g. via `gh secret set`), which
  is fragile: concurrent runs, retries, or a failed write-back permanently break the credential
  (`invalid_grant`). **HIGH** (primary doc confirms rotation).
  - **Conflict to flag:** Atlassian's public OAuth doc states a **10-minute reuse leeway** on the
    old refresh token. **However, this repo's own prior research (`CLAUDE.md` gotcha +
    `.factory/research/S-3.03-v2-design-verification.md`, Claim 5 REFUTED) found that window
    "is NOT documented by Atlassian and is known to fail in clusters" and treats refresh tokens as
    strictly single-use.** Given `jr`'s own `refresh_coordinator.rs` exists precisely to serialize
    refreshes per-profile, do not rely on the leeway. **This is a genuine source conflict** — the
    vendor doc says 10 min; observed/hard-won project behavior says single-use. Treat as single-use.
    **MEDIUM** (conflicting sources, project evidence wins for design purposes).

> **Recommendation:** **Basic auth (email + API token)** stored as a GitHub *environment* secret
> (see Q3). Seed it once by minting a 365-day token from a dedicated CI service account
> (a real Atlassian account that is a member of the test site — ideally a no-mailbox/role account,
> not a personal login). **Rotation:** set a calendar reminder / scheduled workflow to fail loudly
> ~30 days before the 1-year expiry; rotate by minting a new token and updating the secret.
> Document this in the feature spec as a known annual maintenance task. OAuth 3LO is rejected for
> CI on rotation-fragility grounds.

---

## Q3 — GitHub Actions secret safety on a PUBLIC repo

**Recommended answer: Secrets are already withheld from fork PRs by GitHub. Belt-and-suspenders:
gate the E2E job on `github.event_name == 'push'` to `develop`/`main`, and bind it to a GitHub
**Environment** whose deployment-branch policy is restricted to `develop`/`main` (and optionally
required reviewers). This makes the Jira credential reachable only from trusted same-repo runs.**

### Core guarantee (confirmed)

- **"With the exception of `GITHUB_TOKEN`, secrets are not passed to the runner when a workflow is
  triggered from a forked repository."** This is GitHub's documented, intentional behavior to stop a
  forker from adding `echo ${{ secrets.X }}` and exfiltrating credentials via logs. On a `pull_request`
  event from a fork, `secrets.*` resolve to empty strings, and `GITHUB_TOKEN` is downgraded to
  read-only. **HIGH** (GitHub docs, echoed by multiple independent write-ups).
- **`pull_request_target` is the dangerous escape hatch** — it runs in the context of the *base*
  repo with secrets available, and is a well-known fork-PR exfiltration vector. **Do NOT use it for
  the E2E job.** **HIGH.**

### Safe trigger config (conceptual — no code per task scope)

1. **Trigger only on push to trusted branches:**
   - Workflow `on: push: branches: [develop, main]`, and/or
   - Job-level guard `if: github.event_name == 'push' && (github.ref == 'refs/heads/develop' || github.ref == 'refs/heads/main')`.
   - This alone means fork PRs (which arrive as `pull_request`, never `push` to your branches)
     never reach the credentialed job.
2. **Bind the job to a GitHub Environment (e.g. `jira-e2e`):**
   - Store the Jira credential as an **environment secret**, not a repo secret. Environment secrets
     are only readable by jobs that declare `environment: jira-e2e`. **HIGH.**
   - Set the environment's **deployment branch policy to "Selected branches" = `develop`, `main`**
     (or "Protected branches only"). A workflow on any other branch — including an attacker's
     feature branch in the base repo — cannot read the environment's secrets. **HIGH** (GitHub docs:
     branch policies = No restriction / Protected branches only / Selected branches & tags).
   - Optionally add **required reviewers** so a maintainer must approve each E2E run before the
     credential is released — "a job cannot access environment secrets until approval is granted by
     a reviewer." This is the strongest guard if you ever loosen the trigger. **HIGH.**
3. **Least privilege:** set `permissions:` to the minimum (`contents: read`) on the E2E job, and
   never pass the Jira secret into any step that runs untrusted/fork-supplied code.

> **Recommendation:** `push`-to-`develop`/`main` trigger **+** dedicated `jira-e2e` Environment with
> deployment-branch policy locked to `develop`/`main`. Optionally add required-reviewer approval.
> This is defense-in-depth: even though GitHub already withholds secrets from fork PRs, the
> environment + branch policy guarantees the credential is only ever released on trusted same-repo runs.

---

## Q4 — E2E isolation & cleanup against live Jira

**Recommended answer: dedicated test project + per-run unique label/prefix + guaranteed
teardown (`if: always()`) + reconcileIssues for read-after-write + lean on jr's existing
429 handling.**

### Isolation

- **Dedicated test project** (e.g. a project key like `E2E`) used by nothing else, so a botched
  teardown never touches real work. Pass it via `jr --project E2E` / `JR_PROFILE`. **HIGH** (standard practice).
- **Run-scoped unique tags:** stamp every created artifact with a unique marker —
  e.g. a label `e2e-${GITHUB_RUN_ID}` and/or a summary prefix `[e2e ${GITHUB_RUN_ID}]`. This lets
  teardown select exactly this run's issues via JQL (`project = E2E AND labels = e2e-<run_id>`),
  and avoids cross-run interference under Actions concurrency. **HIGH** (pattern; `jr` supports
  `--label` and `--jql`).
- **Idempotency:** `jr`'s single-key `move`/`assign` are already idempotent (exit 0 if already in
  target state, per `CLAUDE.md`), so re-running a step is safe. Note **bulk** `move`/`edit --jql` are
  **not** idempotent — design E2E assertions around single-key state changes where idempotency matters. **HIGH** (project docs).

### Cleanup / teardown

- A final teardown step with **`if: always()`** so it runs even when tests fail: enumerate this
  run's issues (`jr issue list --jql "project = E2E AND labels = e2e-${GITHUB_RUN_ID}" --output json`),
  then delete them. **Caveat:** `jr` does not appear to expose an `issue delete` command today, so
  teardown either (a) needs a new `jr issue delete`, or (b) calls `DELETE /rest/api/3/issue/{key}`
  directly in the workflow, or (c) transitions issues to a terminal/closed status and relies on the
  prefix to keep the project navigable. Decide this in the feature spec. **HIGH** (`if: always()` pattern;
  **MEDIUM** on jr lacking a delete command — verify against current CLI surface during design).
- **Sprints/worklogs** created during the run should likewise be removed/closed in teardown
  (`jr sprint remove`, etc.). **MEDIUM.**

### Eventual consistency (Jira search-index lag after create)

- **Confirmed: the JQL search API is eventually consistent by default.** "The API doesn't provide
  read-after-write consistency by default… subsequent search operations… may return stale or
  outdated data… for some time. The delay might vary from a few seconds to minutes… The majority of
  modifications are shown within seconds." **HIGH** (primary: Atlassian "Search and Reconcile").
- **Two mitigations:**
  1. **`reconcileIssues` parameter** on `/rest/api/3/search/jql`: pass the just-created issue IDs
     (extract from the create response) and the search returns consistent results immediately for
     those issues. **Max 50 IDs per request; consistency guaranteed only for the listed IDs.**
     This is the *correct* fix for "I just created it, now find it." **HIGH** (primary doc). If `jr`'s
     `search_issues`/`search_issue_keys` don't yet plumb `reconcileIssues`, the E2E harness should
     either add support or **poll**.
  2. **Polling with backoff** as a fallback: after create, poll `jr issue view <KEY>` (GET by key is
     read-after-write consistent — only *search* is lagged) or retry the JQL a few times with short
     backoff (e.g. 5 attempts, ~1–2 s apart, up to ~15–30 s). Prefer **`jr issue view <KEY>`** for
     existence checks because a direct GET by key avoids the index entirely. **MEDIUM/HIGH** (GET-by-key
     consistency is implied by the doc framing "search… without reconcileIssues"; verify in design).

### Rate-limit handling

- 429 + `Retry-After` is already handled by `jr` (`api/rate_limit.rs`, `api/client.rs`, plus the
  documented anti-loop guard in `search_issues`). E2E should keep request volume modest and **not**
  add its own competing retry layer on top of jr. **HIGH** (project docs).

> **Recommendation:** Dedicated `E2E` project + `e2e-${GITHUB_RUN_ID}` label on everything +
> `if: always()` teardown selecting by that label + use `reconcileIssues` (or GET-by-key polling)
> for read-after-write + rely on jr's built-in 429 retry. Resolve the "how do we delete" question
> (add `jr issue delete` vs raw DELETE vs close-only) explicitly in the spec.

---

## Q5 — Flakiness & cost controls

**Recommended answer: run E2E as a separate, non-blocking-for-PRs job that only fires on
push to develop/main + a manual/scheduled trigger; add per-test retries, hard timeouts, and
concurrency serialization on a single shared site.**

| Control | Recommendation | Confidence |
|---|---|---|
| **Trigger** | `push` to `develop`/`main` **+** `workflow_dispatch` (manual) **+** optional nightly `schedule` cron. Manual/scheduled lets you run E2E without a push and doubles as the keep-warm job. | HIGH |
| **Blocking?** | E2E should **not** block PR merges (fork PRs can't run it anyway, and live-API flakiness shouldn't gate code review). It runs *after* merge to `develop`. Keep it as a required check only if you accept occasional flaky reds; otherwise make it informational + alert on failure. | MEDIUM (judgment) |
| **Concurrency** | A single shared free site = shared mutable state. Use `concurrency: group: jira-e2e, cancel-in-progress: false` so runs **serialize** rather than clobber each other's issues/sprints. Combined with per-run labels this prevents cross-run interference. | HIGH |
| **Retries** | Retry at the *test-case* level for known-transient failures (search lag, 429), not whole-job blind reruns. Prefer `reconcileIssues`/polling over retries for consistency lag. A bounded job-level rerun (e.g. 1 retry) is acceptable for network blips. | MEDIUM |
| **Timeouts** | Set `timeout-minutes` on the E2E job (e.g. 15–20) so a hung live call can't burn Actions minutes; jr already has internal bulk-poll timeouts (`JR_BULK_AWAIT_TIMEOUT_SECS` default 300s). | HIGH |
| **Cost** | Public-repo Actions minutes are free for standard runners; the real "cost" is Jira rate budget + maintenance. Keep the suite small and high-value (smoke-level happy paths per command family), not exhaustive. | MEDIUM |

> **Recommendation:** Separate non-PR-blocking `e2e` workflow, `push` + `workflow_dispatch`
> (+ optional nightly `schedule`), `concurrency` group to serialize, job `timeout-minutes`,
> targeted per-case retries for transient classes only.

---

## Q6 — Reference implementations

**Recommended answer: there is no strong public precedent for live-Jira E2E in a CLI's CI;
the dominant pattern (including the closest peer, ankitpokhrel/jira-cli) is mock/unit tests
in CI with live testing done manually. Borrow the live-SaaS CI patterns from broader practice.**

1. **ankitpokhrel/jira-cli (Go) — the closest peer.** Its CI (`.github/workflows/ci.yml`) is a
   single `tests` job: checkout → setup Go → `make deps` → `make lint` → `make test`. **There is no
   live-Jira integration in CI** — it runs unit/local tests only; any real-Jira exercise is manual
   (clone + run against your own instance). **Takeaway: even the most popular Jira CLI does NOT
   E2E against live Jira in CI** — strong signal that live E2E is a deliberate, careful addition,
   not table stakes. **HIGH** (fetched its actual CI YAML).
2. **General live-SaaS-in-CI pattern (DB/service-container guides, REST API integration testing).**
   The consistent best practices across write-ups: dedicated test account/credentials injected as
   secrets, `if: always()` cleanup steps, isolation via test-scoped data, and gating credentialed
   jobs away from untrusted triggers. No single Jira-specific exemplar surfaced. **MEDIUM** (secondary sources).
3. **stripe-cli / gh cli live testing.** I could **not** confirm from primary sources that either runs
   credentialed live-API E2E on every push (gh's API tests largely use recorded/mock fixtures;
   Stripe uses test-mode keys + sandbox accounts conceptually). **Treat as INCONCLUSIVE — LOW** —
   do not cite specifics without verifying their repos directly. The transferable idea from Stripe
   is "test-mode / sandbox credentials distinct from production," which maps to "dedicated free Jira
   site" here.

> **Recommendation:** Don't expect to copy a turnkey Jira-CLI E2E pipeline — none exists publicly.
> Combine the generic live-SaaS-in-CI hygiene (dedicated creds, isolation, `if: always()` cleanup,
> environment-gated secrets) with `jr`'s Jira-specific needs (Scrum project, JSM project,
> `reconcileIssues`).

---

## Recommended architecture

A single, decision-ready design for the feature:

- **Instance:** One **dedicated free Jira Cloud site** owned by a CI service account. Provision once:
  one **Scrum** software project (key `E2E`) for issue/sprint/board/worklog coverage, and one **JSM**
  project for queue/request-type coverage. **Assets/CMDB stays under wiremock** (Premium-gated, not
  E2E-able on free). Add a low-frequency keep-warm run to avoid ~120-day idle deactivation.
- **Auth:** **Email + API-token Basic auth** for the service account, stored as a **GitHub Environment
  secret**. `jr` already supports this. Seed once (mint a 365-day token); document an **annual rotation**
  task and a scheduled workflow that fails loudly ~30 days before expiry. **OAuth 3LO is rejected** for
  CI due to rotating-refresh-token fragility (and this repo's own evidence that the refresh leeway is unreliable).
- **Trigger & secret safety:** Workflow `on: push: branches: [develop, main]` + `workflow_dispatch`
  (+ optional nightly `schedule`). Job guarded by `if: github.event_name == 'push'` on those branches
  and bound to a **`jira-e2e` Environment** whose **deployment-branch policy = `develop`/`main`** (and
  optionally **required reviewers**). Fork PRs (`pull_request`) never get the secret — GitHub withholds
  it by default, and the environment/branch policy is the second lock. **Never `pull_request_target`.**
- **Isolation & cleanup:** Stamp every artifact with label `e2e-${GITHUB_RUN_ID}` and a summary prefix.
  Use **`reconcileIssues`** (≤50 IDs) or **GET-by-key polling** for read-after-write consistency
  (search lag is seconds-to-minutes). Teardown in an **`if: always()`** step that selects this run's
  artifacts by label and deletes/closes them — decide `jr issue delete` vs raw `DELETE` vs close-only
  in the spec. Lean on jr's built-in 429/`Retry-After` retry; don't double-retry.
- **Flakiness/cost:** Separate, **non-PR-blocking** job; `concurrency: group: jira-e2e,
  cancel-in-progress: false` to serialize against the shared site; `timeout-minutes` cap; targeted
  per-case retries for transient classes (search lag, 429) only.

### Open items to resolve in the feature spec (flagged inconclusive / needs design decision)

1. **Deletion mechanism** — does `jr` expose `issue delete`? If not, choose: add it, raw `DELETE`, or close-only. (MEDIUM)
2. **`reconcileIssues` plumbing** — does `jr`'s search path support it? If not, harness uses GET-by-key polling. (MEDIUM)
3. **Free-JSM 2026 feature gating** — confirm request-type/queue coverage on the free JSM tier during implementation; gate JSM E2E behind a flag so the suite still passes if a feature is unavailable. (MEDIUM)
4. **Refresh-token leeway conflict** — vendor doc (10 min) vs project evidence (single-use). Not blocking, since we chose Basic auth, but noted. (MEDIUM)

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| Perplexity perplexity_ask | 0 | **UNAVAILABLE this run** — `mcp__perplexity__*` did not resolve |
| Perplexity perplexity_search | 0 | UNAVAILABLE |
| Perplexity perplexity_research | 0 | UNAVAILABLE |
| Perplexity perplexity_reason | 0 | UNAVAILABLE |
| Context7 | 0 | Not applicable (no library version questions) |
| Tavily tavily_search | 0 | **UNAVAILABLE this run** — `mcp__tavily__*` did not resolve |
| Tavily tavily_research/extract/crawl/map | 0 | UNAVAILABLE |
| WebFetch | 6 | Atlassian manage-API-tokens; Atlassian oauth-2-3lo-apps; Atlassian search-and-reconcile; Atlassian what-is-free-plan; GitHub secure-use; GitHub manage-environments; ankitpokhrel CI YAML |
| WebSearch | 9 | API token expiry; free-plan limits; developer sandbox; basic-auth deprecation; fork-PR secret behavior; refresh-token rotation; access-token lifetime; idle deactivation; env branch policy; live-SaaS CI patterns; ankitpokhrel testing |
| Training data | 2 areas | (a) general GitHub Actions `concurrency`/`if: always()` idioms; (b) jr's own internals (cross-referenced to `CLAUDE.md` + prior `.factory/research/S-3.03-*` rather than relied on raw) |

**Total external tool calls:** ~15 (6 WebFetch + 9 WebSearch).
**Training data reliance:** low — every vendor-behavior claim is anchored to a primary Atlassian or
GitHub doc and cross-checked with ≥1 independent source; jr-specific claims are anchored to in-repo
`CLAUDE.md` / prior research files.

**Confidence summary:** Q1 HIGH (free-plan capabilities, Assets=Premium) with MEDIUM edges
(automation/email caps, JSM free gating, idle window). Q2 HIGH (Basic auth works; token expiry policy;
access-token 1h; rotating refresh) with one MEDIUM source conflict (10-min leeway). Q3 HIGH throughout.
Q4 HIGH (consistency model, reconcileIssues, jr 429) with MEDIUM on jr's delete surface. Q5 HIGH on
mechanisms, MEDIUM on blocking/cost judgment. Q6 HIGH on ankitpokhrel (mock-only CI), LOW/INCONCLUSIVE
on stripe-cli/gh-cli specifics.

### Primary sources (anchors for HIGH claims)
- Atlassian — Manage API tokens (expiry policy): https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
- Atlassian — Basic auth for REST APIs: https://developer.atlassian.com/cloud/jira/platform/basic-auth-for-rest-apis/
- Atlassian — Deprecation notice (basic/cookie auth): https://developer.atlassian.com/cloud/jira/platform/deprecation-notice-basic-auth-and-cookie-based-auth/
- Atlassian — OAuth 2.0 (3LO) apps: https://developer.atlassian.com/cloud/jira/platform/oauth-2-3lo-apps/
- Atlassian — Search and Reconcile (reconcileIssues, eventual consistency): https://developer.atlassian.com/cloud/jira/platform/search-and-reconcile/
- Atlassian — Explore Jira Cloud plans: https://support.atlassian.com/jira-cloud-administration/docs/explore-jira-cloud-plans/
- Atlassian — What is the Free Jira Cloud plan: https://support.atlassian.com/jira-cloud-administration/docs/what-is-the-free-jira-cloud-plan/
- GitHub — Secure use reference: https://docs.github.com/en/actions/reference/security/secure-use
- GitHub — Manage environments (protection rules, branch policies): https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments
- GitHub — Deployments and environments: https://docs.github.com/en/actions/reference/workflows-and-actions/deployments-and-environments
- ankitpokhrel/jira-cli CI: https://github.com/ankitpokhrel/jira-cli/blob/main/.github/workflows/ci.yml
- In-repo cross-reference: `CLAUDE.md` (refresh-token single-use gotcha), `.factory/research/S-3.03-v2-design-verification.md`

---

## Perplexity Validation Pass (2026-05-28)

> **MCP tooling status — Perplexity DID NOT resolve (again).** All documented tool-name
> forms were attempted and every one returned `No such tool available`:
> `mcp__perplexity__search`, `mcp__perplexity__reason`, `mcp__perplexity__deep_research`,
> `mcp__perplexity__perplexity_search`, and bare `perplexity_search`. Tavily
> (`mcp__tavily__tavily_search`) also did not resolve. The Perplexity MCP server is **not
> mounted in this environment** — the tool-name fix from the task brief was not the cause of
> the prior failure; the server is simply absent. This validation pass therefore again used
> **WebSearch + WebFetch against primary Atlassian/GitHub docs**, cross-checked with independent
> secondary sources. Every HIGH verdict below is anchored to a primary vendor doc. If a future
> run needs genuine Perplexity validation, the MCP server must first be added to the agent's
> MCP config — it is not a tool-naming problem.

### Verdict table

| # | Claim (abridged) | Verdict | Primary source | Nuance / spec impact |
|---|------------------|---------|----------------|----------------------|
| 1 | Free plan: issue CRUD, Scrum boards+sprints+backlog, worklogs; ≤10 Software users, ≤3 JSM agents; Scrum (not kanban) project needed for `jr sprint` | **CONFIRMED** | Atlassian "What is the Free Jira Cloud plan" + "Explore Jira Cloud plans" | ≤10 users (Software) and ≤3 agents (JSM) confirmed verbatim ("10 users or fewer (Jira) or 3 agents or fewer (JSM)"). Free includes Scrum + Kanban boards, sprints, backlog, time tracking/worklogs. The "Scrum project required for `jr sprint`" half is a **`jr`-behavior fact** (CLAUDE.md: `jr sprint` errors on kanban), not an Atlassian-plan fact — the plan supports both; the *constraint* is jr's. Spec already states this correctly (§4, §10 step 3). No spec change. |
| 2 | Assets/CMDB is PREMIUM-only and cannot be exercised on a free site | **PARTIALLY-CONFIRMED** | Atlassian Assets feature page ("Assets is now available for all Standard customers!"); Atlassian Service Collection pricing | The **"Premium-only" framing is OUTDATED as of Feb 5, 2026**: Assets is now included on **Standard** (5,000 objects free), Premium (50,000), Enterprise (500,000); overage ~$0.02/object/mo. **BUT the load-bearing conclusion still holds: Assets is NOT on Free.** The spec's operational decision ("Assets/CMDB stays under wiremock, not E2E-able on a free site") is still correct. **Spec change recommended:** soften "Assets is an Atlassian **Premium** feature" → "Assets requires a **paid** plan (Standard+) and is **not on Free**" in §2 Non-Goals and the research Q1 table, so the rationale doesn't read as factually stale. |
| 3 | Email+API-token Basic auth works in 2026 for REST v3 AND Agile/Software API; only password Basic auth deprecated (2019); no 2026 deprecation | **CONFIRMED** | Atlassian "Basic auth for REST APIs" (platform + Jira Software variants); "Deprecation notice — Basic auth & cookie auth" | Password-based Basic auth progressively disabled from Jun 3 2019; **email + API-token Basic auth remains current and recommended for "simple scripts and manual calls."** Same auth layer covers platform REST v3 and the Agile/Software REST API (dedicated Jira-Software basic-auth doc exists). No 2026 deprecation announced. Atlassian *encourages* OAuth/JWT but does not deprecate token Basic auth. No spec change. |
| 4 | Tokens created after ~Dec 15 2024 expire ≤1yr (1–365d settable), no never-expires; pre-Dec-2024 tokens force-migrated to 1-yr clock, expire Mar–May 2026 | **CONFIRMED** | Atlassian "Manage API tokens"; Atlassian Community article "API tokens will now have a maximum one-year expiry"; unresolved feature requests ID-7825 / ID-8790 | From Dec 15 2024 new tokens are 1–365 days (max 1 year), no indefinite option. Pre-Dec-15-2024 tokens: after Mar 13 2025 set to a 1-year clock, **expiring Mar 14 – May 12 2026** (verbatim). Spec §9 annual-rotation plan is correct. **Minor nuance for spec:** any pre-2025 token a maintainer already holds is dead/dying *now* (within the Mar–May 2026 window) — the runbook should mint a fresh token rather than reuse any existing one. No structural spec change. |
| 5 | Repo AND environment secrets are NOT exposed to fork-triggered `pull_request` runs (only read-only GITHUB_TOKEN); `pull_request_target` DOES expose secrets and is the known exfil vector | **CONFIRMED** | GitHub Docs "Secure use reference" | Verbatim: "With the exception of GITHUB_TOKEN, secrets are not passed to the runner when a workflow is triggered from a forked repository"; fork-PR GITHUB_TOKEN is read-only. `pull_request_target` runs in base-repo context with secrets — documented exfil vector. Applies to **both** repo and environment secrets (environment secrets are strictly more restrictive). Spec §6 and the `if: github.event_name != 'pull_request'` guard are correct. No spec change. |
| 6 | GitHub Environments support a deployment-branch policy (No restriction / Protected branches only / Selected branches & tags) restricting secret access, plus optional required-reviewer approval gate | **CONFIRMED** | GitHub Docs "Managing environments for deployment" + "Deployments and environments" | All three policy modes confirmed verbatim. "If the environment requires approval, a job cannot access environment secrets until one of the required reviewers approves it." A job cannot access env secrets until all protection rules pass. Spec §6 / §8 / §10 step 6 are correct. No spec change. |
| 7 | JQL search (`/rest/api/3/search/jql`) is eventually consistent (sec–min stale); `reconcileIssues` (≤50 IDs) forces read-after-write for those IDs; GET issue by key is read-after-write consistent (not index-lagged) | **PARTIALLY-CONFIRMED** | Atlassian "Search and Reconcile" | Sentences 1–2 **CONFIRMED verbatim**: no read-after-write consistency by default; delay "a few seconds to minutes"; `reconcileIssues` accepts "a maximum of 50 reconcile issues" and reconciles them regardless of index lag. **Sentence 3 (GET-by-key is consistent) is NOT stated on the Search-and-Reconcile page** — it is a well-reasoned inference (GET issue reads the DB, not the search index) supported only by secondary sources, **not a primary-doc guarantee**. Verdict is PARTIALLY-CONFIRMED purely because of this. **Spec nuance:** §4/§7 lean on `poll_view` via GET-by-key as "read-after-write consistent." This is almost certainly true and is the right design, but the spec should label it as a **reasonable assumption (not vendor-documented)** and keep the bounded-retry poll as the safety net — which it already has. Recommend a one-line caveat; no design change. |
| 8 | Free Jira sites are deactivated after ~120 consecutive days with no logins | **CONFIRMED** | Atlassian Community (Atlassian-staff answer) "deactivated due to inactivity" | Verbatim: "if you have 120 consecutive days with no activity (no logins to Jira) then the subscription will be deactivated." Activity = logging in and viewing any page. **Added nuance the spec should note:** after deactivation there is only a **short reactivation window (15 days if Free is your only product; up to ~60 days depending on billing experience)** before data is **permanently deleted**. So the nightly keep-warm job (spec §9) isn't merely nice-to-have — a ~4-month outage of the nightly schedule risks irreversible data loss of the E2E site. Recommend strengthening §9 wording from "prevents idle deactivation" to "prevents idle deactivation; note the post-deactivation grace window is only 15–60 days before permanent deletion." |

### Spec changes recommended (for maintainer to fold in)

1. **Claim 2 — de-stale the "Premium-only" rationale.** §2 Non-Goals + research Q1 row currently say Assets is *Premium*. As of Feb 5 2026 it's on **Standard** too. Reword to "requires a paid plan (Standard+); not on Free." The actual decision (wiremock, not live) is unchanged.
2. **Claim 7 — flag GET-by-key consistency as an assumption.** The poll-via-`jr issue view` strategy is sound, but "GET-by-key is read-after-write consistent" is an inference, not vendor-documented on the Search-and-Reconcile page. Add a one-line caveat; keep the bounded-retry poll (already present) as the guarantee.
3. **Claim 8 — strengthen keep-warm rationale.** Note the post-deactivation grace window is only **15–60 days** before permanent data deletion, making the nightly keep-warm job a data-loss safeguard, not just a convenience.

(Claims 1, 3, 4, 5, 6 require **no** spec changes — the spec already states them correctly.)

### Research methods (this pass)

| Tool | Queries | Purpose |
|------|---------|---------|
| Perplexity (all name forms) | 6 attempts | **ALL FAILED — server not mounted.** Tried `mcp__perplexity__search`, `__reason`, `__deep_research`, `__perplexity_search`, bare `perplexity_search`, plus `mcp__tavily__tavily_search`. |
| WebSearch | 8 | Free-plan limits; Assets plan gating; Basic-auth currency; token-expiry policy; fork-PR secret behavior; env branch policy; JQL eventual consistency + reconcileIssues + GET-by-key; idle deactivation |
| WebFetch | 2 | Atlassian Search-and-Reconcile (primary, claim 7); Atlassian Assets feature page (primary, claim 2) |
| Training data | 0 areas | No claim rested on training data; all anchored to retrieved vendor/community sources. |

**Total external calls (this pass):** 10 (8 WebSearch + 2 WebFetch). Perplexity reliance: **0 (unavailable)**.
