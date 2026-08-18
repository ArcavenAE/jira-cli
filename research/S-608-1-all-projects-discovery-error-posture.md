# S-608-1 — `jr component rename --all-projects` DISCOVERY-phase error posture

**Type:** general (technology / architecture pattern research)
**Date:** 2026-08-17
**Author:** Research Agent (Corverax / vsdd-factory)
**Question owner:** `jr` design — `component rename OLD NEW --all-projects`

---

## 1. The decision in one line

For a MUTATION fan-out advertised as "rename it in **every** accessible project," the
research strongly supports a **HYBRID discovery-error posture**, not a pure choice between
the two options as framed:

- **Transient / uncertain discovery failures** (network error, timeout, 5xx, 429 after
  the retry budget is exhausted) → **retry with bounded exponential backoff + jitter first**;
  if still failing, **FAIL-CLOSED and ABORT the entire fan-out before any mutation** (zero
  renames). Rationale: the tool cannot know whether that project contains `OLD`, and the
  user asked for "everywhere." Silently dropping a possibly-in-scope target is the
  more-surprising, less-safe outcome.
- **Deterministic exclusions** (a `403` — and, with caveats, a `404` — on a *specific,
  already-known* project's components endpoint) → **SKIP that one project, warn loudly to
  stderr, and account for it in the summary/exit status**. Rationale: the project is
  genuinely not component-listable by this principal; retrying the identical request will
  not help; it is legitimately out of the achievable scope. This is the availability half.
- Offer an explicit **`--best-effort` / `--allow-partial`** opt-in that downgrades the
  transient-error ABORT to skip-and-warn, because "partial success" should be an explicit,
  observable user choice — never the silent default.

This is a deliberate refinement of the current "always fail-closed abort on any discovery
error" behavior: it keeps fail-closed for the cases where state is *uncertain*, but lets a
genuinely-inaccessible project be skipped rather than blocking an org-wide rename.

Confidence: **HIGH** for the general principle (multiple authoritative sources agree);
**MEDIUM** for the Jira-specific `403`-means-deterministic-skip mapping (the exact status
codes are *undocumented* on this endpoint — see §4, flagged INCONCLUSIVE where relevant).

---

## 2. Best practice for fan-out MUTATION CLIs on ENUMERATION/DISCOVERY failure (Q1)

**Finding:** Established CLIs do **not** implement a general "silently skip a failed
enumeration and then mutate whatever happened to be found" convention. The dominant pattern
across the surveyed tools is: **fully enumerate and validate the target set before the first
irreversible action; if enumeration itself fails, error out (nonzero) rather than proceeding
as if the discovered subset were complete.** Per-*item action* failures (after a successful
enumeration) are commonly handled best-effort with an aggregate nonzero exit — but that is a
distinct phase from enumeration failure.

Concrete documented behavior:

| Tool | Enumeration/discovery failure | Per-item action failure (post-enumeration) |
|------|------------------------------|--------------------------------------------|
| **GitHub `gh`** (`gh codespace delete --all` / filtered bulk delete) | **Fail-closed.** The command lists matching codespaces first; a `GetUser` / `ListCodespaces` / fetch error is returned immediately (`error getting codespaces` / `error fetching codespace information`) **before** the delete fan-out starts. [gh-codespace-delete][gh-deleting-codespace] | **Continue-and-report.** After successful enumeration, per-codespace deletes run; individual failures are logged and the command returns an aggregate nonzero ("N codespace(s) failed to delete"). Materially different from the enumeration-failure abort. |
| **`gh api --paginate`** | Emits each page as it arrives, so earlier successful pages can already be on stdout when a later page fails (e.g., several 200s then an HTTP 403 terminating pagination). Produces **partial output *plus* an error** — it does *not* present that as a complete successful listing. [gh-cli-4443][gh-api-manual] | n/a (read path) |
| **`kubectl`** | **Mixed.** `kubectl get pods --all-namespaces` is a single cluster-wide *collection* request, not a per-namespace fan-out — there is no individual namespace listing to "skip"; RBAC/server failure of that collection fails the listing. For a comma-separated resource-type set, the resource builder uses `ContinueOnError()` ("visit as many objects as possible"), so partial traversal is possible — **but errors are surfaced and returned, never represented as complete success.** API discovery similarly returns known groups **plus** `ErrGroupDiscoveryFailed` ("unable to retrieve the complete list of server APIs"). [k8s-api-concepts][k8s-resource-builder][k8s-delete-src][k8s-api-resources] | `kubectl delete` (multi-resource) is best-effort across independently-resolved objects via the same `ContinueOnError` mechanism; **not transactional** — earlier deletes are not rolled back — and the overall command still returns nonzero. |
| **AWS CLI** | **Effectively fail-closed at output assembly.** Auto-pagination calls `build_full_result()` before emitting normal structured output; Botocore's paginator invokes each page request without converting an exception into skip-and-warn, so a failed later page **propagates as an error** rather than yielding a "successful partial" result. `--no-paginate` / `--max-items` are *explicit* truncation modes, not accidental partial success. No general multi-region fan-out exists in the base CLI (multi-region is user shell/SDK orchestration). [aws-cli-pagination][aws-cli-formatter][aws-cli-multiregion-issue] | Service-native batch APIs (e.g., MediaLive `batch-delete`) return server-defined `Successful`/`Failed` lists — a per-item *action* result, not a CLI enumeration-failure policy. |
| **`git`** | No close analogue to remote namespace/project *API discovery* — submodules/remotes are enumerated from local config. `git submodule foreach` is **fail-fast** on a per-submodule command failure (nonzero terminates unless the user appends `\|\| :`). `git fetch --all` is **best-effort on the action**: the test suite verifies it continues fetching other remotes after one errors, while the overall command still fails and successful updates remain — partial mutation **plus nonzero**, not skip-and-warn *success*. [git-submodule][git-fetch][git-fetch-multiple-test] | Same row — these are action failures, not discovery failures. |

**Cross-tool takeaway (Q1):** The precedents that most resemble our case — `gh
codespace delete --all` (a mutation fan-out that lists-then-mutates) and AWS CLI
auto-pagination — both **fail closed when the *listing* step fails**, and none of the tools
ever label an incomplete enumeration as a mere warning that then proceeds to a successful
mutation. `kubectl`'s `ContinueOnError` is the notable counterexample for continuing across
*independently-resolved* targets, but even it (a) surfaces the error and returns nonzero and
(b) does not treat `--all-namespaces` as a per-namespace skip-list. Bottom line:
**skip-and-warn-then-mutate is not an established default; fail-closed-on-enumeration-error
is.** [gh-codespace-delete][aws-cli-formatter][k8s-resource-builder]

---

## 3. The MUTATION-specific safety argument & least surprise (Q2)

Four authoritative threads converge on **fail-closed on *uncertain* discovery** for a
state-changing `--all` command:

1. **Fail-safe / fail-secure defaults (Saltzer & Schroeder).** The original principle —
   "base access decisions on permission rather than exclusion," so that omissions default to
   *deny* rather than accidentally *allow* — is an access-control rule, but it generalizes
   to: *treat an incomplete or uncertain result as NOT authorizing execution of the
   plan.* For a batch mutation, the safe default is "do not begin" when the target universe
   is unknown. [saltzer-schroeder][owasp-fail-securely] (The extension from "access control"
   to "this batch mutation" is a reasoned application, not a verbatim quote — flagged as
   design judgment.)

2. **Principle of least astonishment.** `--all` / `--all-projects` communicates
   *exhaustive coverage*, not "all targets that happened to be reachable during this
   attempt." Unless the contract is explicitly documented otherwise, **a clear abort before
   changes is less surprising than a success that silently omitted a project the user
   believed was covered.** This is a design heuristic (least astonishment is not a formal
   correctness rule), but it is the standard one for CLI UX. [least-astonishment][esr-taoup]

3. **Deterministic vs. transient error classification.** Google Cloud and AWS both
   classify `408`, `429`, `5xx`, socket timeouts, and TCP/DNS failures as *transient /
   retryable*, and authentication/authorization/validation/misconfiguration as *permanent /
   non-retryable*. The load-bearing nuance from the SRE-adjacent guidance:
   **"non-retryable does NOT mean safe to skip."** A permanent `403` only means *repeating
   the identical request won't help* — it does not, by itself, prove the target is out of
   scope. Skipping is justified **only when the error also proves, under the command's
   documented scope contract, that no potentially-included target is being hidden.**
   [gcp-retry-strategy][aws-retry-backoff][aws-builders-idempotent]

4. **Idempotency & retry (RFC 9110 / SRE).** A discovery `GET` is idempotent, so it is
   *safe to auto-retry* on transient failures with bounded exponential backoff + jitter,
   respecting `Retry-After`, under an overall deadline and retry budget. A genuine `403`
   "should not be automatically repeated with the same credentials" (RFC 9110). Google SRE:
   separate retriable from non-retriable errors, never retry permanent errors indefinitely,
   randomize backoff, prevent retry amplification. [rfc9110][gcp-retry-strategy][sre-cascading-failures]

**Availability counter-argument (and why it loses for the *default*):** "one flaky or
inaccessible project shouldn't block an org-wide operation." This is legitimate — and it is
exactly why the recommendation is a **hybrid**, not a blanket abort. A *genuinely
inaccessible* project (deterministic `403`) is a bounded, knowable exclusion and can be
skipped-with-warning; a *transiently unreachable* project (`5xx`/network) leaves the state
**unknown**, so treating its unknown contents as "empty / nothing to rename" is precisely
the silent-drop the user did not consent to. Google's own API design guidance (AIP-233/234)
reinforces that **partial success must be an explicit, observable semantic choice** —
synchronous batch is atomic, async partial-success is opt-in, and individual failures must
be reported, not hidden. [google-aip-234]

**Principle-of-least-surprise verdict for "rename it EVERYWHERE":** the user's mental model
is *"after this returns 0, `OLD` is `NEW` in every project that had it."* Honoring that model
means: if a project's state is *uncertain*, don't claim success — abort (or, with explicit
`--best-effort`, report the gap). If a project is *provably inaccessible*, skip it but say so
loudly. Never let an exit code of 0 quietly mean "…except the three I couldn't reach."

---

## 4. Atlassian API specifics for `GET /rest/api/3/project/{key}/components` (Q3)

Sourced from the official Atlassian Cloud REST v3 reference and general Atlassian HTTP
guidance. **Several precise status-code semantics for this endpoint are UNDOCUMENTED and are
flagged INCONCLUSIVE below — do not encode them as certainties in user-facing strings.**

- **Permission to list a project's components:** the operation requires the
  **`Browse Projects`** project permission for the specified project (grantable
  anonymously where anonymous access is configured). OAuth classic scope `read:jira-work`;
  granular scopes include `read:project:jira` and `read:project.component:jira`. Connect
  apps require `READ`. [atlassian-components-api]

- **What does `403` vs `404` vs `5xx` mean on THIS endpoint?** The endpoint-specific docs
  **document only `200`** for this operation — they do **not** define `403`, `404`, or any
  `5xx`. Therefore any claim like "`403` here always means missing Browse Projects" or
  "`404` means the project doesn't exist" is **INCONCLUSIVE / not corroborated for this
  specific endpoint.** Under Atlassian's *general* HTTP guidance: `403 Forbidden` = caller
  identified but lacks permission; `404 Not Found` = resource doesn't exist; `5xx` =
  server/infrastructure failure. **Caveat:** Jira APIs sometimes use `404` to conceal an
  inaccessible resource (RFC 9110 explicitly permits this) — but that behavior is *not
  corroborated for this particular v3 endpoint.* [atlassian-components-api][atlassian-webhook-status-kb][rfc9110]

- **Can a project appear in `/project/search` yet return `403` on `/components`?**
  **Yes, a documented authorization mismatch is possible.** `GET /project/search` returns
  projects where the caller has **any one** of `Browse Projects`, `Administer Projects`, or
  global `Administer Jira`; component listing specifically requires `Browse Projects`. So a
  project can surface in search via an *administrative* permission while the caller lacks
  `Browse Projects` — leaving them outside the documented permission for component listing.
  This is a real "visible-in-search-but-not-component-listable" path. **However**, the
  component endpoint does **not** document that this condition yields exactly `403` (could
  surface differently) — so the *precise status* is **INCONCLUSIVE**. Note the converse: if
  the caller genuinely *has* `Browse Projects`, there is **no** documented
  "visible-but-not-component-listable" distinction — `Browse Projects` *is* the listed
  component-read permission; a `403` in that case points to something outside these docs
  (OAuth/app scope, auth context, policy enforcement, or an anomalous response).
  [atlassian-projects-api][atlassian-components-api]

- **Are `403`s deterministic and `5xx` transient?** **Usually, but not categorically.** A
  genuine permission-based `403` persists until permissions/scopes/credentials/policy change
  — retrying the identical request won't help (consistent with RFC 9110's "don't
  auto-repeat a 403"). But because this endpoint doesn't document `403` at all, the v3
  reference does **not guarantee** every observed `403` here is deterministic/permission-based
  (INCONCLUSIVE). For `5xx`, Atlassian explicitly states **some** 5xx (e.g. some `503`s) are
  transient and may carry `Retry-After` — it does **not** say every 5xx is transient. Such
  responses are server-side/uncertain and warrant bounded retry (backoff + jitter,
  `Retry-After`) for this idempotent `GET`. [atlassian-components-api][atlassian-rate-limiting][rfc9110]

**Practical mapping for `jr` (grounded, with the INCONCLUSIVE flags carried forward):**
Because the *precise* status semantics are undocumented, the safe engineering move is to key
the SKIP-vs-ABORT decision on the **transient/deterministic class**, not on a hard-coded
belief about what `403` "must" mean:

- `403` / `401` / `404` on a *known* project's components GET → treat as **deterministic ⇒
  SKIP that project with a loud, itemized warning** (the project is genuinely not
  component-listable by this principal, or gone). Retrying won't help. *(Caveat: `404`
  could conceal a `403`; either way the class is "deterministic, this known project is not
  listable," so skip-with-warning is the correct action.)*
- `408` / `429` / `5xx` / network / timeout → treat as **transient/uncertain ⇒ RETRY with
  bounded backoff + jitter (respect `Retry-After`); on budget exhaustion, ABORT the whole
  fan-out**, because that project's component set — and thus whether it contains `OLD` — is
  unknown.

---

## 5. Concrete recommendation (Q4)

**Recommend: HYBRID, defaulting to fail-closed on *uncertain* discovery, with a scoped skip
for *deterministic* inaccessibility, plus an explicit `--best-effort` opt-in.**

### 5.1 Algorithm

1. **Discovery sweep (no mutations).** For every project from `/project/search`, GET its
   components. Classify each project's result:
   - **OK** → record the discovered component set (freeze the plan for that project).
   - **Deterministic failure** (`401`/`403`/`404`) → mark **SKIPPED (inaccessible)**;
     record the project key + reason for the summary.
   - **Transient failure** (`408`/`429`/`5xx`/network/timeout) → retry the *idempotent* GET
     with bounded exponential backoff + jitter, honoring `Retry-After`, under a deadline and
     retry budget. If it eventually succeeds → OK. If the budget is exhausted → mark
     **UNCERTAIN**.
2. **Gate before any mutation:**
   - If **any project is UNCERTAIN** (and `--best-effort` was *not* passed) → **ABORT the
     entire fan-out. Zero mutations.** Exit nonzero (`JrError::NetworkError`/`ApiError`, exit
     1 — an operational failure, retryable). Message: name the unreachable project(s), state
     that no renames were performed, and tell the user to retry (the GET is idempotent, so
     retry is safe).
   - Otherwise (all projects OK or deterministically SKIPPED) → **proceed to the mutation
     phase** over the OK set only.
3. **Mutation phase** (existing per-project continue-on-error, unchanged): PUT
   `/rest/api/3/component/{id}` per project; a failed PUT in project B does not roll back A
   or stop C. Aggregate failures → nonzero exit.
4. **Summary & exit status (least-surprise contract):** Always print, to stderr, the count
   and keys of **SKIPPED (inaccessible)** projects so an exit-0 never silently hides an
   omission. Consider a distinct exit code or a `--output json` field
   (`{"renamed":[…],"skipped_inaccessible":[…],"failed":[…]}`) so scripts can detect partial
   coverage. `--output json` should carry the full accounting per the JSON render invariant.
5. **`--best-effort` / `--allow-partial` (explicit opt-in):** downgrades the step-2 UNCERTAIN
   ABORT to skip-and-warn, so an operator who *knowingly* accepts partial coverage across a
   flaky org can proceed. Partial success stays an explicit, observable choice — never the
   default. [google-aip-234]

### 5.2 Why this and not the alternatives

- **Not pure fail-closed-abort (current behavior):** it needlessly blocks an org-wide rename
  when a single project is *genuinely inaccessible* (deterministic `403`) — a bounded,
  knowable exclusion that `gh`/`kubectl`/AWS would surface but not treat as
  state-uncertainty. The availability argument legitimately applies to *this* class only.
- **Not pure skip-and-continue:** silently (or even loudly) skipping a **transiently
  unreachable** project and reporting overall success violates fail-safe defaults and least
  astonishment — the user asked to rename `OLD` *everywhere*, and that project's contents
  (possibly including `OLD`) are unknown. No surveyed tool treats a failed *listing* as a
  complete listing. [aws-cli-formatter][gh-codespace-delete][saltzer-schroeder]
- **The hybrid** matches the well-established rule that **"non-retryable ≠ safe to skip"**:
  it skips only when the failure is *both* non-retryable *and* proves (under the
  `--all-projects` scope contract "all projects I can list components for") that the project
  is out of achievable scope; it fails closed whenever state is merely *uncertain*.
  [gcp-retry-strategy][rfc9110]

### 5.3 Caveats to encode carefully

- The Jira status semantics for this endpoint are **undocumented** (§4). Key the
  skip/abort branch on the **transient-vs-deterministic class** (which maps cleanly to
  Atlassian's *general* HTTP + rate-limiting guidance), **not** on a literal belief that
  `403` "means" out-of-scope. If citing any JRACLOUD/behavioral claim in user-facing
  strings, Perplexity-validate first (per repo citation discipline) — several precise
  mappings here are INCONCLUSIVE.
- The rename **PUT** (mutation phase) is out of scope for this question but note: renaming
  `OLD`→`NEW` is naturally idempotent-adjacent (a second run finds no `OLD` to rename); keep
  the per-project continue-on-error behavior as-is.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 3 | (a) fan-out mutation CLI enumeration-failure behavior across gh/kubectl/AWS/git; (b) Atlassian `GET /project/{key}/components` permissions + 403/404/5xx semantics + search-vs-components mismatch; (c) fail-safe defaults / least astonishment / deterministic-vs-transient classification / idempotent-retry guidance (Saltzer-Schroeder, RFC 9110, Google SRE, AWS/GCP, Atlassian rate-limiting, Google AIP) |
| Perplexity perplexity_reason | 0 | — |
| Perplexity perplexity_search | 0 | — |
| Perplexity perplexity_ask | 0 | — |
| Context7 | 0 | — |
| Tavily (all) | 0 | — |
| WebFetch | 0 | — |
| WebSearch | 0 | — |
| Training data | 1 area | Framing/organization of the recommendation and mapping to `jr`'s `JrError` exit codes — all substantive claims are web-sourced and cited; exit-code mapping is from the repo's own CLAUDE.md, not external research |

**Total MCP tool calls:** 3 (all `perplexity_research`, `reasoning_effort` high-equivalent depth)
**Training data reliance:** **low** — every external claim is attributed to a cited source;
Atlassian status-code specifics that could not be corroborated are explicitly flagged
INCONCLUSIVE rather than asserted.

---

## Sources

**Fan-out CLI enumeration behavior (Q1):**
- [gh-codespace-delete] GitHub CLI manual — `gh codespace delete`: https://cli.github.com/manual/gh_codespace_delete
- [gh-deleting-codespace] GitHub Docs — Deleting a codespace: https://docs.github.com/en/codespaces/developing-in-a-codespace/deleting-a-codespace
- [gh-cli-4443] cli/cli #4443 — `gh api --paginate` partial pages then error: https://github.com/cli/cli/issues/4443
- [gh-api-manual] GitHub CLI manual — `gh api`: https://cli.github.com/manual/gh_api
- [k8s-api-concepts] Kubernetes — API concepts (collections, `--all-namespaces`, pagination): https://kubernetes.io/docs/reference/using-api/api-concepts/
- [k8s-resource-builder] `k8s.io/kubernetes/pkg/kubectl/resource` (Builder / `ContinueOnError`): https://pkg.go.dev/k8s.io/kubernetes/pkg/kubectl/resource
- [k8s-delete-src] kubectl `pkg/cmd/delete/delete.go`: https://github.com/kubernetes/kubectl/blob/master/pkg/cmd/delete/delete.go
- [k8s-api-resources] Kubernetes — `kubectl api-resources` / `ErrGroupDiscoveryFailed` ("unable to retrieve the complete list of server APIs"): https://kubernetes.io/docs/reference/kubectl/generated/kubectl_api-resources/ ; https://access.redhat.com/solutions/4765881
- [aws-cli-pagination] AWS CLI User Guide — Pagination (`--no-paginate`, `--max-items`): https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-pagination.html
- [aws-cli-formatter] AWS CLI `formatter.py` (`build_full_result()` before output): https://fossies.org/linux/aws-cli/awscli/formatter.py
- [aws-cli-multiregion-issue] aws/aws-cli #7173 — multi-region enhancement request: https://github.com/aws/aws-cli/issues/7173
- [git-submodule] `git submodule` docs (`foreach` fail-fast): https://git-scm.com/docs/git-submodule
- [git-fetch] `git fetch` docs (`--all`, `skipFetchAll`): https://git-scm.com/docs/git-fetch
- [git-fetch-multiple-test] git test `t5514-fetch-multiple.sh` (continue after a remote errors): https://sigit.si/git/git/blob/bisect/t/t5514-fetch-multiple.sh

**Safety / least surprise / retry theory (Q2, Q4):**
- [saltzer-schroeder] Saltzer & Schroeder design principles (fail-safe defaults): https://www.cs.virginia.edu/~evans/cs551/saltzer/
- [owasp-fail-securely] OWASP — Fail securely: https://owasp.org/www-community/Fail_securely
- [least-astonishment] Principle of least astonishment: https://en.wikipedia.org/wiki/Principle_of_least_astonishment
- [esr-taoup] E. S. Raymond, TAOUP ch.11 — least surprise in CLI design: http://www.catb.org/esr/writings/taoup/html/ch11s01.html
- [gcp-retry-strategy] Google Cloud — Retry strategy (transient vs. permanent; backoff+jitter; idempotency): https://docs.cloud.google.com/storage/docs/retry-strategy
- [aws-retry-backoff] AWS Prescriptive Guidance — Retry with backoff: https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/retry-backoff.html
- [aws-builders-idempotent] AWS Builders' Library — Making retries safe with idempotent APIs: https://aws.amazon.com/builders-library/making-retries-safe-with-idempotent-APIs/
- [rfc9110] RFC 9110 — HTTP Semantics (idempotent methods; don't auto-repeat 403; 404 may conceal 403): https://datatracker.ietf.org/doc/html/rfc9110
- [sre-cascading-failures] Google SRE Book — Addressing Cascading Failures (retry classification, budgets): https://sre.google/sre-book/addressing-cascading-failures/
- [google-aip-234] Google AIP-234 — Batch methods / partial success as explicit choice: https://google.aip.dev/234

**Atlassian API specifics (Q3):**
- [atlassian-components-api] Atlassian Cloud Jira REST v3 — Project components (Browse Projects, scopes, documents only 200): https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-components/
- [atlassian-projects-api] Atlassian Cloud Jira REST v3 — Projects / `/project/search` (any of Browse/Administer Projects/Administer Jira): https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-projects/
- [atlassian-webhook-status-kb] Atlassian KB — 400/401/403 interpretation: https://support.atlassian.com/jira/kb/webhooks-or-web-requests-fail-with-http-status-code-400-401-or-403-in-jira/
- [atlassian-rate-limiting] Atlassian — Rate limiting (some 5xx transient, `Retry-After`, backoff+jitter, idempotency): https://developer.atlassian.com/cloud/jira/platform/rate-limiting/
