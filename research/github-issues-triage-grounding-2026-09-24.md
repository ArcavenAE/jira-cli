# External Grounding for Open GitHub Issue Triage

**Date:** 2026-09-24 | **Type:** general (technology/API grounding) | **Scope:** issues #860, #861, #862, #789, #785, #673, #629, #609, #607, #587/#586, #583, #387
**Mode:** read-only research. No repository source or specs were modified.

Confidence legend: **HIGH** = official docs quoted/fetched directly; **MEDIUM** = official docs plus secondary synthesis, or the behavior was inferred from source/issue evidence; **LOW** = community reports only.

---

## #860: `issue list --jql` and ORDER BY

**Facts**
- (a) `jql` on `GET/POST /rest/api/3/search/jql` is a complete JQL expression, so `ORDER BY` belongs inside it. Atlassian's JQL docs say ORDER BY "must be at the end of the query". Two ORDER BY clauses make the JQL invalid. The endpoint then returns **HTTP 400** with parser text shaped like `Error in the JQL Query: Expecting ',' or end of query but got 'ORDER'. (line 1, character N)`. The exact message text is **not** a documented contract, and a related KB shows the wording changes with parser context. Sources: https://support.atlassian.com/jira-software-cloud/docs/jql-keywords/ , https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/ , https://support.atlassian.com/jira/kb/getting-the-error-error-in-the-jql-query-expecting-but-got-order-when-doing-a-drill-down-on-a-two-dimensional-filter-gadget/
- (b) **There is no separate sort/orderBy parameter** on `/search/jql`. Neither the GET query params nor the POST body schema has one. Several other resources (for example `filter/search`) do have `orderBy`, so don't confuse the two. Source: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/
- (c) Detecting ORDER BY:
  - **Authoritative:** `POST /rest/api/3/jql/parse?validation=none|warn|strict` returns a parsed structure with separate `where` and `orderBy` objects (`orderBy.fields[]` of `{field, direction}`). Per Perplexity, it can be called anonymously. Cost: one extra HTTP round-trip. Source: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-jql/ (MEDIUM: from a Perplexity summary; the page was not fetched directly)
  - **Heuristic pitfalls:** `ORDER BY` can legitimately appear inside quoted string literals (e.g. `summary ~ "order by date"`). `order` is a JQL reserved word, so a field literally named "order" must be quoted. A naive case-insensitive substring or regex check therefore gives false positives. A safe local detector needs a small tokenizer that skips `"…"` and `'…'` literals (including backslash escapes) and then looks for the `ORDER` token followed by whitespace and the `BY` token at top level. Source: https://support.atlassian.com/jira-software-cloud/docs/what-is-advanced-search-in-jira-cloud/
  - The project's own CLAUDE.md already pins the hint wording "append `, key ASC` to an existing sort…" for the same one-ORDER-BY rule (JRACLOUD-95368 hint).

**External grounding verdict:** Supported. JQL allows only one ORDER BY, and a second one gives HTTP 400. The endpoint has no sort parameter, so a default sort must be spliced into the JQL only when none is present. The robust options are a quote-aware tokenizer (no HTTP) or `/rest/api/3/jql/parse` (authoritative, +1 call). **HIGH** for (a)/(b), **MEDIUM** for the parse-endpoint shape.

---

## #861: `field options` for system fields (`allowedValues` shapes)

The `allowedValues[]` item type is **untyped/polymorphic** in the OpenAPI spec. Each entry has the shape of the Jira entity the field represents. Clients should dispatch on `schema.system` / `schema.type` / `schema.custom` rather than assume one shape.

| Field | Typical entry | Display label | Source |
|---|---|---|---|
| `priority` (system) | `{self, iconUrl, name, id}` (id is a string) | **`name`** | https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-priorities/ |
| Custom select/radio/checkbox/multiselect | `{self, value, id, disabled?}` | **`value`** | https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-custom-field-options/ |
| Cascading select | parent `{self,value,id,disabled?,children:[{self,value,id,…}]}` | `value` (both levels) | older DC examples; current Cloud v3 metadata example not found (**inconclusive**) |
| `resolution` | `{self, id, description, name}` | `name` | https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-resolutions/ |
| `fixVersions` / `versions` | `{self, id, name, archived, released, projectId, …}` | `name` | https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-versions/ |
| `components` | `{self, id, name}` | `name` | https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-project-components/ |
| `security` | `{self, id, description, name}` | `name` | https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-security-level/ |
| `issuetype` | `{self, id, description, iconUrl, name, subtask, avatarId?, hierarchyLevel?}` | `name` | https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-types/ |
| JSM request-type field `validValues[]` | `{value, label, children:[]}` | **`label`** (`value` is what gets submitted) | https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-servicedesk/ |

- Wire shapes: priority is `{"id":"…"}` (the current v3 Create example) or `{"name":"…"}` (historically accepted, not shown in current v3 docs). Options are `{"value":"…"}` or `{"id":"…"}`. Cascading uses `{"value":…,"child":{"value":…}}`, with singular `child` on write and plural `children` in metadata. Source: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ , https://support.atlassian.com/cloud-automation/docs/advanced-field-editing-using-json/
- `resolution` is usually present only in **transition** metadata, not in createmeta/editmeta, depending on screens.
- Current official v3 examples for createmeta and editmeta are thin: the editmeta example shows scalar strings for a multi-select, which is unrealistic. **Do not model on the doc examples.**

**External grounding verdict:** Supported. System fields label with `name`, custom options with `value`, and JSM with `label`. Any enumerator that reads only `value` will show blanks for priority, components, versions and similar system fields. **HIGH** for the name/value split and the system shapes; **MEDIUM/inconclusive** for populated cascading `children` in current Cloud v3 metadata and for populated JSM `children`.

---

## #862: clap global `--project` plus a subcommand-local `--project`

- Documented (clap **4.6.7**, fetched from docs.rs): "Global arguments only propagate down, not up (to parent commands), however their values once a user uses them will be propagated back up to parents. In effect, this means one should define all global arguments at the top level, however it doesn't matter where the user uses the global argument." https://docs.rs/clap/latest/clap/struct.Arg.html#method.global
- Verified from clap issue #5690 (closed as not planned): when a subcommand already has an arg with the same **id**, `Command::_propagate_global_args` logs `skipping "<id>" to <sub>, already exists`. The subcommand's local definition **shadows** the global, and there is **no debug-assert panic**. The parsed value is still propagated back up to the parent under the same id. If the two definitions have **different types**, access panics at runtime with "Mismatch between definition and access of `<id>`. Could not downcast…". https://github.com/clap-rs/clap/issues/5690
- Therefore, with both fields `Option<String>`, `jr issue list --project X` fills the child field. The value also propagates up, so the top-level field most likely sees `Some("X")` too. The reverse direction is **not verified**: whether `jr --project X issue list` (before the subcommand) fills the child-local shadow field depends on how `ArgMatcher` fills in global values. Pin this with a unit test before relying on it (MEDIUM).
- "Argument names must be unique" debug-asserts fire only when two same-id args coexist in the **same** command, for example through duplicate `#[command(flatten)]`. https://github.com/clap-rs/clap/issues/4556
- Idiomatic merge, per the clap docs:
  1. Declare `--project` **once**, globally at the top level, and read `cli.project` in dispatch.
  2. Or declare it in the subcommand struct as `#[arg(from_global)] project: Option<String>`, which reads the global value and adds no second arg. See the derive reference: https://docs.rs/clap/latest/clap/_derive/index.html
  3. If the meanings really differ, rename both the id and the long flag.
- Perplexity cited clap #5355 as evidence that shadowing is intended. **That citation is wrong**: #5355 is about hiding global options in help. The shadowing evidence above comes from #5690 and the propagation log line.

**External grounding verdict:** Partly supported. There is no panic: the local arg silently shadows the global and the value propagates up. That silent overlap is the latent footgun (type-mismatch panic, confusing help), and the documented fix is a single global plus `from_global`. **HIGH** for the doc semantics and the absence of a panic; **MEDIUM** for which field is filled when the flag comes before the subcommand. Context7 was not reachable in this session (tools not surfaced), so docs.rs was fetched directly instead.

---

## #789: `--fields` and JSON output shape

- `gh … --json f1,f2` outputs **only the requested keys**. An unknown field is an **error** that lists the available fields. https://cli.github.com/manual/gh_help_formatting
- Azure and AWS `--query '{A:a,B:b}'` (JMESPath multiselect hash) output only the requested keys, and a requested key that is missing on a record becomes `null`. Plain list projections (`[].b`) drop nulls. https://learn.microsoft.com/en-us/cli/azure/query-azure-cli , https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-filter.html , https://jmespath.org/specification.html
- kubectl `-o custom-columns` shows `<none>` for missing values. `-o jsonpath` prints empty output, or errors when `--allow-missing-template-keys=false`. https://kubernetes.io/docs/reference/kubectl/
- ankitpokhrel/jira-cli `--columns` selects table/plain columns only, not JSON. glab uses `--output json` plus `--jq`. https://github.com/ankitpokhrel/jira-cli , https://docs.gitlab.com/cli/mr/list/
- In serde, `skip_serializing_if = "Option::is_none"` is a **static, per-field** omission rule and cannot express a runtime field list (https://serde.rs/field-attrs.html). Runtime projection means serializing to `serde_json::Value` and then either `Map::retain` (omit) or building a new map that inserts `Value::Null` for each requested-but-absent key (JMESPath style). https://docs.rs/serde_json/latest/serde_json/struct.Map.html#method.retain

**External grounding verdict:** The convention is **only the requested keys**, never every key padded with nulls. A requested but absent key is either `null` (JMESPath) or an error for an unknown name (gh). Recommended contract: validate names against a known set (gh-style error), emit exactly the requested keys, and use `null` for known-but-empty values. **HIGH**.

---

## #785: Env-var auth (token from environment)

| CLI | Env vars | Precedence | Per-invocation? | Source |
|---|---|---|---|---|
| gh | `GH_TOKEN` > `GITHUB_TOKEN` (and `GH_ENTERPRISE_TOKEN` > `GITHUB_ENTERPRISE_TOKEN` for GHES) | env **overrides** stored keyring/hosts.yml | yes, resolved in each process that needs auth; the keyring is untouched | https://cli.github.com/manual/gh_help_environment ; `gh auth status` shows the source e.g. `(GH_TOKEN)`: https://cli.github.com/manual/gh_auth_status |
| ankitpokhrel/jira-cli | `JIRA_API_TOKEN` (plus `JIRA_AUTH_TYPE=bearer` for PAT) | env > `.netrc` > keychain | yes | https://github.com/ankitpokhrel/jira-cli#readme , https://github.com/ankitpokhrel/jira-cli/discussions/356 |
| Atlassian `acli` | **no native token env var**; `acli jira auth login --token` reads the token from **stdin**, and the CI guide pipes `$BOT_API_TOKEN` into it | n/a | no | https://developer.atlassian.com/cloud/acli/reference/commands/jira-auth-login/ , https://developer.atlassian.com/cloud/acli/guides/use-acli-on-ci/ |
| glab | `GITLAB_TOKEN` > `GITLAB_ACCESS_TOKEN` > `OAUTH_TOKEN` (not `GLAB_TOKEN`) | env > keyring/config > `CI_JOB_TOKEN` (only when CI auto-login is on) | "for every authenticated command"; `glab auth login` warns if an env token is set | https://docs.gitlab.com/cli/authentication/ |

**Security**
- CWE-526 ("Cleartext Storage of Sensitive Information in an Environment Variable"): env values reach child processes and can be copied into logs or messages. https://cwe.mitre.org/data/definitions/526.html
- `/proc/<pid>/environ` is readable subject to a ptrace `PTRACE_MODE_READ_FSCREDS` check: same-UID or privileged processes can read it, not every user. https://man7.org/linux/man-pages/man5/proc_pid_environ.5.html
- Children inherit the environment through fork/execve. https://man7.org/linux/man-pages/man7/environ.7.html
- CI: mask secrets and rotate any secret that leaked into a log. https://docs.github.com/en/actions/reference/security/secure-use , https://docs.gitlab.com/ci/variables/
- Among these CLIs, only gh (the auth-status source label) and glab (a warning when an env token shadows a login) surface that an env override is active. None prominently warns about CWE-526, and jira-cli even suggests exporting the token in `.bashrc`.

**Implications for jr (inference):** Prior art supports an env override that is (1) resolved per invocation, (2) higher priority than the keychain, and (3) never persisted. jr should also (4) show the token source in `auth status` and (5) warn when an env token shadows a stored credential. Because `jr` has per-profile OAuth and api-token modes, the env var needs defined profile semantics. Note the existing `JR_AUTH_HEADER`/`JR_BASE_URL` seams are debug-only by design (CLAUDE.md), so a release-build env token is a **new trust surface**, not an extension of those seams.

**External grounding verdict:** Supported. Mainstream CLIs (gh, glab, jira-cli) resolve env tokens on every invocation and give them precedence over stored credentials. Atlassian's own acli is the exception: it uses a stdin login instead. Security guidance supports shipping it with source visibility and documented CWE-526 caveats. **HIGH**.

---

## #673: `--reporter` on `issue create`

- Wire shape: `fields.reporter = {"accountId":"<id>"}`. The current v3 generated example uses `{"id":"<accountId>"}`, and JRACLOUD-71625 (Won't Fix) shows some update paths accepting only `id`. Both forms carry the accountId. https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ , https://jira.atlassian.com/browse/JRACLOUD-71625
- Permission: the **Modify Reporter** project permission (`MODIFY_REPORTER`), in addition to Browse and Create. https://support.atlassian.com/jira-cloud-administration/docs/work-item-permissions/
- Screen: reporter must be on the project/issue-type **Create screen**, and appears in createmeta only if the caller can set it. Failure returns HTTP 400 `{"errors":{"reporter":"Field 'reporter' cannot be set. It is not on the appropriate screen, or unknown."}}`. The **same generic message** is returned when Modify Reporter is missing, so the two causes can't be told apart from the error alone. https://community.atlassian.com/forums/Jira-questions/Getting-quot-Field-reporter-cannot-be-set-It-is-not-on-the/qaq-p/859632 , https://support.atlassian.com/jira/kb/you-dont-have-permission-to-modify-the-reporter-in-this-project-in-jira/
- Checking createmeta for a `reporter` field is a pre-flight test that covers both causes. This fits the existing S-578-4 createmeta resolution path.
- JSM contrast: `raiseOnBehalfOf` is a top-level body property on `POST /rest/servicedeskapi/request`, not `fields.reporter`. The caller must be an **agent or project admin**, and the target is a **customer**. Customers cannot use it. https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-request/ , https://support.atlassian.com/jira-service-management-cloud/docs/raise-a-request-on-behalf-of-a-customer/

**External grounding verdict:** Supported and feasible. Reporter can be set on create, with two server-side preconditions: Modify Reporter and the field on the Create screen. Both surface as the same HTTP 400, so the error hint should name both causes, and a createmeta pre-check is the best diagnostic. **HIGH**.

---

## #629: Search index lag and read-after-write

- **Officially documented.** The Search and Reconcile guide (fetched directly) says: "The API doesn't provide read-after-write consistency by default… subsequent search operations… without the `reconcileIssues` parameter may return stale or outdated data." It also says: "the delay might vary from a few seconds to minutes, depending on the operation. The majority of modifications are shown within seconds." https://developer.atlassian.com/cloud/jira/platform/search-and-reconcile/
- **`reconcileIssues` exists** on both `GET` (query array) and `POST` (body array) `/rest/api/3/search/jql`. It takes **numeric issue IDs, not keys**, with a **maximum of 50**. Consistency is guaranteed **only for the listed IDs**. After an edit, pass `returnIssue=true` to get the ID back. Atlassian's answer in RFC-61 says consistency does not carry over to later requests that omit an ID, so the list must be sent on every page. https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-search/ , https://community.developer.atlassian.com/t/rfc-61-evolving-search-capabilities-addressing-scalability-with-a-new-enhanced-search-api/83027?page=2
- The endpoint reference itself says: "Recent updates might not be immediately visible in the returned search results."
- Observed magnitudes are anecdotal:
  - 2–3 s after `IssueCreatedEvent`: https://community.developer.atlassian.com/t/jql-search-returns-no-results-immediately-after-issuecreatedevent-indexing-delay-in-jira-cloud/92312
  - JRACLOUD-97427: bulk-created issues missing from JQL, from immediately up to occasionally hours: https://jira.atlassian.com/browse/JRACLOUD-97427
  - JRACLOUD-97045: about 2 minutes for new custom-field options: https://jira.atlassian.com/browse/JRACLOUD-97045
- The old `/rest/api/3/search` was removed in 2025 (CHANGE-2046). The eventual-consistency design is part of the replacement endpoint (RFC-61). https://developer.atlassian.com/cloud/jira/platform/changelog/

**External grounding verdict:** Strongly supported. Eventual consistency is official and documented, and `reconcileIssues` is the documented tool for strong consistency on up to 50 known issue IDs. It cannot help with "find issues I just changed" when the IDs are unknown, or with more than 50 of them. Lag is usually seconds but has no upper bound. **HIGH**.

---

## #609: Component impact scan

| Surface | API | Visibility limit |
|---|---|---|
| Saved filters | `GET /rest/api/3/filter/search?expand=jql` (offset-paginated; `filterName` matches **names only**, not JQL, so the JQL must be scanned client-side) | Only filters the caller owns or can see. `overrideSharePermissions=true` returns all filters but requires **Administer Jira** and is experimental. https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-filters/ , https://community.developer.atlassian.com/t/new-apis-shipped-to-jira-cloud/56470 |
| Boards | `GET /rest/agile/1.0/board` → `/board/{id}/configuration` (`filter.id`, Kanban `subQuery`); `/board/{id}/quickfilter` (has `jql`) | Only boards visible to the caller. https://developer.atlassian.com/cloud/jira/software/rest/api-group-board/ |
| Dashboards | `GET /rest/api/3/dashboard/search`, `/dashboard/{id}/gadget` | Owned, shared or public dashboards only, with **no** admin override (JRACLOUD-79274 still open). The gadget API does **not** expose built-in gadget preferences (filter ID or JQL). https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-dashboards/ , https://jira.atlassian.com/browse/JRACLOUD-79274 |
| Automation rules | Automation Rule Management API (GA) `…/rest/v1/rule/summary`, `…/rule/{uuid}` | Needs automation admin rights; not available to OAuth2/Forge apps. JQL sits nested in component configs. https://developer.atlassian.com/cloud/automation/rest/api-group-rule-management/ |
| JSM queues | `GET /rest/servicedeskapi/servicedesk/{id}/queue` (has `jql`) | Caller must be an agent of that project. https://developer.atlassian.com/cloud/jira/service-desk/rest/api-group-servicedesk/ |

- JQL accepts a component **name or numeric ID** (`component = 20500`). No Atlassian doc guarantees that name-based JQL is rewritten when a component is renamed. https://support.atlassian.com/jira-software-cloud/docs/jql-fields/
- Filters can reference other filters (`filter = 123`), so a complete scan needs a dependency graph.

**External grounding verdict:** Feasible only as a **best-effort, visibility-bounded** scan. Filters, board quick filters and JSM queues can be scanned. Dashboard gadgets cannot be resolved through the public API, and a normal user sees only shared or owned objects. The output must say "not provably complete". **HIGH** on the API facts, **MEDIUM** on whether rename rewrites name-based JQL (undocumented).

---

## #607: Structured filter grammar (prior art, low priority)

- **gh:**
  - `gh issue list --label a --label b` means **AND**.
  - OR goes through `--search 'label:a,b'`.
  - Negation uses a `-label:x` qualifier in `--search`.
  - "None" uses `no:label` and `no:assignee`.
  - https://cli.github.com/manual/gh_issue_list , https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/filtering-and-searching-issues-and-pull-requests
- **ankitpokhrel/jira-cli:** repeated `-l` means AND; a `~` value prefix negates (`-s~Done`). https://github.com/ankitpokhrel/jira-cli
- **glab:** `--label` is repeatable or comma-separated with AND semantics, and `--not-label` excludes. https://docs.gitlab.com/cli/issue/list/

**External grounding verdict:** Prior art is consistent: repeated flags mean AND, and negation is a separate flag (`--not-label`) or a prefix (`-`/`~`/`not:`). Explicit OR is rare and usually goes through a query language. jr's existing `--component` `not:`/`all:`/`none` forms are in line with this. **MEDIUM** (single perplexity_ask lookup; docs not individually fetched).

---

## #587 / #586: Bulk changelog and bulk comments

- `POST /rest/api/3/changelog/bulkfetch` exists.
  - Body: `issueIdsOrKeys` (required, **max 1000**), `fieldIds` (**max 10**), `maxResults`, `nextPageToken` (cursor; loop until it is absent).
  - Needs Browse projects; not available to Connect apps; classic scope `read:jira-work`.
  - `maxResults` default and max are not stated on the rendered docs page. Secondary sources say default 1000, max 10000 (**MEDIUM**).
  - https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/ , https://community.developer.atlassian.com/t/bulk-fetch-changelogs-experimental-api/87240
- **There is no bulk comment-add REST endpoint.** `POST /rest/api/3/issue/{key}/comment` takes one issue per call. `POST /rest/api/3/comment/list` is bulk **read** by comment ID. `bulk/issues/fields` has no comment input. The UI's bulk "Change Comment" has no public REST equivalent. https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-comments/ , https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-bulk-operations/
- Rate limits: https://developer.atlassian.com/cloud/jira/platform/rate-limiting/
  - A points-based quota has been enforced since 2026-03-02 for Forge/Connect/**OAuth 2.0** apps. **API-token traffic is excluded** from points but is still subject to burst limits.
  - Burst limits are 100 req/s for GET/POST and 50 req/s for PUT/DELETE, per endpoint.
  - Per-issue write limits are **20 writes / 2 s** and **100 writes / 30 s**.
  - A 429 comes with `Retry-After` (seconds) and `RateLimit-Reason`.
  - N sequential comment POSTs across different issues are fine. Use bounded concurrency and honor `Retry-After`, which jr already does.

**External grounding verdict:** #587 is supported: a bulk changelog endpoint exists (1000 issues, 10 field IDs, cursor-paged). #586 is supported as "must fan out": bulk comment add requires N per-issue POSTs, with no batch endpoint. **HIGH**; exact `maxResults` bounds **MEDIUM**.

---

## #583: `jr api --query-param`

- gh api (verified from the manual): "The default HTTP request method is `GET` normally and `POST` if any parameters were added… To send the parameters as a `GET` query string instead, use `--method GET`." `-f` sends a raw string and `-F` a typed value (`@file`, `{owner}`, true/false/null/int). `key[]=v` repeats into an array. With `--input`, "any parameters specified via field flags are added to the query string of the endpoint URL." https://cli.github.com/manual/gh_api
- Encoding: gh builds queries with Go's `url.Values` (form encoding: space becomes `+`, reserved characters become `%XX`, brackets in names get encoded). The manual does not specify the escaping rules (MEDIUM, implementation-derived).
- glab api mirrors gh (`-f/-F/-X/--input`). https://docs.gitlab.com/cli/api/
- HTTPie `name==value` auto-escapes names and values. https://httpie.io/docs/cli/querystring-parameters
- curl `-G --data-urlencode` encodes the value only; the name must already be encoded. https://curl.se/docs/manpage.html
- The expected behavior across tools is for the client to percent-encode user-supplied raw values. Users should not pre-encode, because that double-encodes `%` as `%25`.

**External grounding verdict:** Supported. Established prior art has a flag-driven query builder that encodes raw values itself. The most-copied model is gh's `-f/-F` plus `--method GET`, although a dedicated `--query-param k=v` (HTTPie-like) avoids gh's implicit POST switch. **HIGH** for flag semantics, **MEDIUM** for exact encoding.

---

## #387: git history rewrite with git filter-repo

Main source for the points below: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository

- A force-push of rewritten history changes the SHAs of every commit from the first rewritten one onward. It invalidates signatures, disrupts open PRs (GitHub says to close or merge them first), and can lose the diffs of closed PRs.
- **Forks are not rewritten** and keep the old objects.
- **PR refs (`refs/pull/*`) are read-only**, so a mirror push cannot update them and they keep old blobs reachable.
- **Cached views** can serve old commits by SHA.
- Unreachable objects persist until server-side GC, which users cannot trigger.
- A **GitHub Support request** is needed to dereference PR refs, GC, and purge cached views and orphaned LFS objects. Support does this **only for sensitive data**, not for ordinary size reduction, and not while forks still reference the data.
- Size: rewriting can shrink a **fresh clone** if the large blobs are gone from all branches and tags, because clone fetches only objects reachable from advertised refs (https://github.com/git/git/blob/master/Documentation/fetch-options.txt).
- Server storage is not freed: fork networks share an object pool (https://github.blog/open-source/git/counting-objects/), and GitHub will not GC non-sensitive data.
- Cheaper alternatives are `--filter=blob:none` or `--depth=1` clones (https://github.blog/open-source/git/get-up-to-speed-with-partial-clone-and-shallow-clone/) and Git LFS going forward (https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github).
- For git-filter-repo itself, pushing every ref matters: https://github.com/newren/git-filter-repo

**External grounding verdict:** Only weakly supported for a size-only goal. A rewrite can shrink fresh clones, but it breaks SHAs, signatures, open PRs and forks. GitHub keeps the old objects through PR refs, forks and caches, and Support will not purge non-sensitive data, so the server-side benefit is essentially none. Partial or shallow clones get most of the benefit with no disruption. **HIGH**.

---

## Inconclusive and flagged items
1. Exact HTTP 400 body for a duplicate ORDER BY is not a documented contract. Match on the status code, not the message text.
2. Current Cloud-v3 createmeta/editmeta examples with populated cascading `children`, and populated JSM `validValues.children`, were not found.
3. clap: whether a subcommand-local shadow field receives a value supplied **before** the subcommand is unverified. Pin it with a test.
4. `changelog/bulkfetch` `maxResults` bounds are from secondary sources only.
5. Whether Jira rewrites name-based component JQL on rename is undocumented.
6. Perplexity mis-cited clap #5355 for the shadowing claim. It was corrected via #5690, found through WebSearch and checked with WebFetch.

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 8 | search/jql (reconcileIssues, lag, ORDER BY); allowedValues shapes; reporter + bulkfetch + bulk comments + rate limits; env-var auth + CWE-526; clap global shadowing; --fields conventions + serde; filter/board/dashboard impact scan; gh api + git filter-repo |
| Perplexity perplexity_reason | 0 | not needed |
| Perplexity perplexity_search | 0 | not needed |
| Perplexity perplexity_ask | 2 | #607 filter-grammar prior art; jql/parse orderBy + reserved word `order` |
| Context7 | 0 | Context7 tools were not surfaced in this session's tool list (deferred and not callable). clap was verified by fetching docs.rs (4.6.7) directly instead |
| Tavily | 0 | not available in this session |
| WebFetch | 6 | Atlassian search-and-reconcile guide; docs.rs clap Arg::global; cli.github.com gh_api manual; clap issue #5355 (disproved the citation); clap command.rs raw source (inconclusive); clap issue #5690 |
| WebSearch | 1 | clap `_propagate_global_args` "already exists" log line → #5690 |
| Training data | 2 areas | clap ArgMatcher global-value fill-in direction (flagged unverified); Go `url.Values` encoding details (flagged MEDIUM) |

**Total MCP tool calls:** 10
**Training data reliance:** low. Every verdict rests on cited web sources. Only the two flagged areas lean on model knowledge.
