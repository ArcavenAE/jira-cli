# Feature Spec: JSM E2E Coverage Expansion (project EJ)

**Status:** Approved (F1 human gate passed 2026-06-01)
**Author:** jr maintainers (F2 spec evolution 2026-06-01)
**Extends:** `docs/specs/e2e-live-jira-testing.md` — cross-reference, not duplication.
  Sections of that spec updated by this feature are called out explicitly in §10 below.
**Research:** `.factory/planning/brainstorming-report-jsm-e2e.md` + `.factory/phase-f1-delta-analysis/jsm-e2e-expansion/delta-analysis.md`
**Tracking:** GitHub issue TBD (filed during F4 delivery)

---

## 1. Problem and Context

The live E2E suite has exactly two JSM tests — `test_e2e_jsm_queue_list_exits_ok` and
`test_e2e_jsm_requesttype_list_exits_ok` — both gated on `JR_E2E_JSM_PROJECT` (currently
unset → clean-skip) and both asserting only `exit 0 + is-array`. This is the same
false-confidence profile that motivated live E2E testing in the first place: the
createmeta/label/priority wire-shape bugs that shipped undetected through mocks and only
surfaced against real Jira. Shallow JSM assertions repeat that risk verbatim.

The deeper structural problem: JSM has divergent code paths that mocks cannot exercise.
`issue create --request-type` routes to `POST /rest/servicedeskapi/request` (the ADR-0014
dispatch fork), not to `/rest/api/3/issue`. The `sd.public.comment` entity property
determining internal/external comment visibility is set via platform endpoints but only
readable as live Jira data — a mock returns whatever the test fixture says; real Jira
actually enforces the property. The `require_service_desk` guard calls
`get_or_fetch_project_meta` and fails in a project-type-specific way that requires a real
project record to discriminate.

Now that project `EJ` (E2E-JSM) exists on the live site, JSM commands can be exercised
with the same shape-asserting and round-trip rigour applied to platform commands.

**BC and NFR corpora unchanged.** All new tests trace to existing BCs. The BC corpus
(585 BCs) and NFR corpus (41 NFRs) are EXPLICITLY UNCHANGED by this spec. No new BC
file is created; no existing BC is modified; BC-INDEX.md is unchanged.

---

## 2. Scope and Constraints

### 2.1 Zero src/ Delta

This feature is zero-`src/`. All JSM commands already exist:

| Command | Implementation |
|---------|----------------|
| `jr queue list/view` | `src/cli/queue.rs` + `src/api/jsm/queues.rs` |
| `jr requesttype list/fields` | `src/cli/requesttype.rs` + `src/api/jsm/request_types.rs` |
| `jr issue create --request-type` | `src/cli/issue/create.rs::handle_jsm_create` + `src/api/jsm/requests.rs` |
| `jr issue comment --internal` | `src/cli/issue/workflow.rs` + `src/api/jira/issues.rs::add_comment` |
| `jr issue comments --output json` | `src/cli/issue/comments.rs` (serializes `properties[]` including `sd.public.comment`) |
| `jr issue move` | existing platform transitions path |
| `require_service_desk` guard | `src/api/jsm/servicedesks.rs` |

F1 confirmed no jr capability gap. F4 has no `src/` change, no Red Gate invocation, and no
demo story. The implementing story is pure test and documentation.

### 2.2 BC / NFR Coverage Map

New tests trace to existing BCs without modification:

| BC | What the new test exercises |
|----|----------------------------|
| BC-X.8.004 | Non-JSM guard: `require_service_desk` error message shape + exit code when a JSM command targets ES (a Jira Software project). |
| BC-X.12.001 | `jr requesttype list` — now deepened to assert per-item `id` + `name` fields. |
| BC-X.12.005 | `jr requesttype fields <ID>` — GET `.../requesttype/{id}/field`; asserts `fields` array shape. |
| BC-3.8.001 | `jr issue create --request-type` write round-trip — `POST /rest/servicedeskapi/request`; asserts `{"key": "EJ-N"}` on stdout. |
| BC-3.8.004 | Numeric-bypass in create test (using RT id directly). |

---

## 3. Clean-Skip Policy

All JSM tests share a uniform clean-skip policy. A skip is loud (eprintln to stderr) and
MUST never cause a test failure.

### 3.1 Primary gate — JR_E2E_JSM_PROJECT

Every JSM test MUST begin with:

```rust
let jsm_project = match std::env::var("JR_E2E_JSM_PROJECT") {
    Ok(p) if !p.trim().is_empty() => p.trim().to_string(),
    _ => {
        eprintln!("[SKIP] JR_E2E_JSM_PROJECT not set — skipping JSM test");
        return;
    }
};
```

No new env var is introduced. The variable is already wired in `e2e.yml` (line ~100) as
`JR_E2E_JSM_PROJECT: ${{ vars.JR_E2E_JSM_PROJECT }}`. Activation requires only setting the
value `EJ` in the `jira-e2e` GitHub Environment (see §9).

### 3.2 Dynamic-discovery skip — empty list

When a test derives a fixture from a list (queues, request types), it MUST skip cleanly if
the list is empty:

```rust
let queues: Vec<serde_json::Value> = serde_json::from_str(&stdout).expect("JSON");
if queues.is_empty() {
    eprintln!("[SKIP] No queues found on EJ — skipping queue view test");
    return;
}
```

An empty list is a valid configuration state, not an error.

### 3.3 403 / feature-unavailable skip

Any JSM API call returning HTTP 403 (feature not on plan, insufficient permission, or plan
tier) MUST be treated as a clean-skip condition, not a test failure. Emit an eprintln
message. Pattern: check `status.success()` and additionally inspect stderr for a `403`
substring before asserting.

---

## 4. Dynamic-Discovery Design

### 4.1 Queue Fixture

`queue view` requires a queue id and name. These are derived dynamically — no hardcoded
fixture env var is introduced.

Discovery pattern:
1. Run `jr queue list --project <EJ> --output json`.
2. Parse the JSON array; if empty → clean-skip (§3.2).
3. Take `queues[0]["id"]` (string or integer → stringify) for the `--id` path.
4. Take `queues[0]["name"]` (string) for the by-name path.
5. Use the exact name from step 4 — `partial_match` requires an unambiguous substring;
   using the full name from the API response guarantees uniqueness.

### 4.2 Request-Type Fixture

`requesttype fields` and `issue create --request-type` both require a real request-type id.
These are derived dynamically.

Discovery pattern:
1. Run `jr requesttype list --project <EJ> --output json`.
2. Parse the JSON array; if empty → clean-skip (§3.2).
3. Take `rts[0]["id"]` as a string.
4. Confirm the value is numeric (all JSM request-type ids on the Atlassian platform are
   positive integers); if not numeric for any reason → skip with a warning.
5. Use this id string as the `--request-type <id>` argument. Because the string is
   all-ASCII-digit, `handle_jsm_create` takes the numeric-bypass path
   (`src/cli/issue/create.rs`: `if request_type_arg.chars().all(|c| c.is_ascii_digit())`)
   and skips name resolution — the most robust path.

The requesttype list test is declared before the create and fields tests in `e2e_live.rs`.
Because `--test-threads=1` serializes execution in declaration order, the create test can
depend on requesttype list having been exercised — but MUST re-fetch its own fixture
independently (no shared state between test functions).

---

## 5. Test Scenarios

Seven test scenarios are defined. All are `#[ignore]`-gated via the `e2e_enabled()` check
and additionally gated on `JR_E2E_JSM_PROJECT` per §3.1.

### Scenario 1 — Deepen queue list shape assertions

**Test function:** `test_e2e_jsm_queue_list_shape` (replaces or supplements the existing
shallow `test_e2e_jsm_queue_list_exits_ok`)

**Steps:**
1. Run `jr queue list --project <EJ> --output json`.
2. Assert exit 0.
3. Parse the response as a JSON array.
4. If the array is non-empty, assert that each item has an `"id"` field (non-null) and a
   `"name"` field (non-null, non-empty string). A single item assertion is sufficient to
   catch wire renames; iterating all items is preferred.

**Clean-skip condition:** None (an empty array is asserted as a valid state; the test
passes even with zero queues, since the per-item assertion only fires if items exist).

**BC traced:** BC-X.12.001 (queue read command output shape).

---

### Scenario 2 — Deepen requesttype list shape assertions

**Test function:** `test_e2e_jsm_requesttype_list_shape` (replaces or supplements the
existing shallow `test_e2e_jsm_requesttype_list_exits_ok`)

**Steps:**
1. Run `jr requesttype list --project <EJ> --output json`.
2. Assert exit 0.
3. Parse the response as a JSON array.
4. If the array is non-empty, assert that each item has an `"id"` field (non-null) and a
   `"name"` field (non-null, non-empty string).

**Clean-skip condition:** None (empty array is a valid state).

**BC traced:** BC-X.12.001 (requesttype read command output shape).

---

### Scenario 3 — Queue view by name AND by --id

**Test function:** `test_e2e_jsm_queue_view`

**Steps:**
1. Run `jr queue list --project <EJ> --output json`; parse the array.
2. If the array is empty → clean-skip (§3.2).
3. Extract `first_id` (stringify) and `first_name` (exact string) from `queues[0]`.
4. **By-name path:** Run `jr queue view "<first_name>" --project <EJ> --output json`.
   Assert exit 0; assert the returned object contains `"id"` and `"name"` fields matching
   the discovered values (case-sensitive, exact match on name).
5. **By-id path:** Run `jr queue view --id <first_id> --project <EJ> --output json`.
   Assert exit 0; assert the returned object contains `"id"` field equal to `first_id`.

**Clean-skip condition:** Skip when the queue list is empty (§3.2). Skip on 403 (§3.3).

**BC traced:** BC-X.12.001 (queue view output shape). The `--id` flag path exercises the
distinct routing branch in `src/cli/queue.rs`.

---

### Scenario 4 — requesttype fields shape + numeric-bypass pin

**Test function:** `test_e2e_jsm_requesttype_fields`

**Steps:**
1. Run `jr requesttype list --project <EJ> --output json`; parse the array.
2. If the array is empty → clean-skip (§3.2).
3. Extract `first_rt_id` (stringify) from `rts[0]["id"]`; confirm it is all-ASCII-digit.
4. Run `jr requesttype fields <first_rt_id> --project <EJ> --output json`.
5. Assert exit 0.
6. Parse the response; assert the top-level shape contains a `"fields"` key (array, possibly
   empty) — the array validates the endpoint contract and deserialization.

**Numeric-bypass pin:** Because `first_rt_id` is all-ASCII-digit, `src/cli/requesttype.rs`
(`if !name_or_id.is_empty() && name_or_id.chars().all(|c| c.is_ascii_digit())`) takes the
numeric-id path, bypassing `partial_match` and cache name resolution. This test pins that
the numeric path succeeds end-to-end against real Jira. The degenerate case (a request type
named exactly "100" is unreachable by name) is documented in CLAUDE.md and not exercised
here (unit-test concern).

**Clean-skip condition:** Skip when the requesttype list is empty (§3.2). Skip on 403 (§3.3).

**BC traced:** BC-X.12.005 (requesttype fields output shape). BC-3.8.004 (numeric bypass).

---

### Scenario 5 — Internal vs external comment visibility round-trip

**Test function:** `test_e2e_jsm_comment_visibility`

This is the most complex JSM test. It creates a fresh JSM request, exercises the
`--internal` flag, reads back the `sd.public.comment` property from the comments JSON, and
self-closes.

**Steps:**
1. Run `jr requesttype list --project <EJ> --output json`; parse; if empty → clean-skip.
2. Extract `first_rt_id` from `rts[0]["id"]`.
3. Create a fresh JSM request:
   ```
   jr issue create --project <EJ> --request-type <first_rt_id>
     --summary "[e2e-jsm-comment <run_id>] visibility round-trip"
     --output json
   ```
   Parse stdout as `{"key": "<key>"}`. Capture `key`.
4. Add a **public** comment (no flag):
   ```
   jr issue comment <key> "public comment from e2e run <run_id>"
   ```
   Assert exit 0.
5. Add an **internal** comment:
   ```
   jr issue comment <key> "internal comment from e2e run <run_id>" --internal
   ```
   Assert exit 0.
6. Read back all comments:
   ```
   jr issue comments <key> --output json
   ```
   Assert exit 0. Parse as a JSON array.
7. Assert that at least one comment in the array has
   `properties[].key == "sd.public.comment"` with `.value.internal == true`. This is the
   internal comment.
8. Assert that at least one comment does NOT have any `properties[]` entry with
   `key == "sd.public.comment"` and `value.internal == true`. This is the public comment.
   (An absent `properties` array or an empty array on the public comment is acceptable —
   the absence of the property is the signal.)
9. Self-close: `jr issue move <key> <Done>` (using `JR_E2E_STATUS_DONE` or default `"Done"`).
   Assert exit 0 or log a warning on failure (do not fail the test on close failure).

**sd.public.comment property detail:** `src/api/jira/issues.rs::list_comments` adds
`?expand=properties` (verified in F1 code read). This causes Jira to return a `properties`
array on each comment object containing entity properties, including `sd.public.comment`
when set. `src/types/jira/issue.rs::Comment.properties` is `Vec<EntityProperty>`.
`src/cli/issue/comments.rs` serializes `&comments` directly in JSON mode, preserving the
full `properties` array. The E2E test reads this JSON path:
`comment.properties[*]` where `key == "sd.public.comment"` and `value.internal == true`.

The discriminator `comment_visibility()` at `src/cli/issue/format.rs` returns
`Some("Internal")` when `sd.public.comment.internal == true`. The E2E assertion uses the
raw JSON path, not the table display value, for precision.

**Teardown:** Self-close in step 9. See §6 for orphan-risk documentation.

**Clean-skip conditions:** requesttype list empty (§3.2); 403 on any step (§3.3); create
returns non-zero exit (skip with eprintln, not fail).

**BC traced:** `jr issue comment --internal` (existing JSM comment BC). `jr issue comments
--output json` (properties exposure). `jr issue create --request-type` (create path for
fixture setup).

---

### Scenario 6 — issue create --request-type write round-trip

**Test function:** `test_e2e_jsm_create_request_roundtrip`

**Steps:**
1. Run `jr requesttype list --project <EJ> --output json`; parse; if empty → clean-skip.
2. Extract `first_rt_id` from `rts[0]["id"]`; confirm all-ASCII-digit.
3. Create a request:
   ```
   jr issue create --project <EJ> --request-type <first_rt_id>
     --summary "[e2e-jsm <run_id>] create round-trip"
     --output json
   ```
4. Assert exit 0. Parse stdout as JSON; assert the `"key"` field is present and non-empty.
   Capture `key`.
5. `poll_view(key)` — bounded retry of `jr issue view <key> --output json` until exit 0,
   confirming GET-by-key consistency. Assert the returned JSON contains a `"key"` field
   equal to `key`.
6. Assert that the issue key prefix matches the JSM project key (e.g. starts with `"EJ-"`).
7. Self-close: `jr issue move <key> <Done>`. Assert exit 0 or log a warning on failure.

**ADR-0014 dispatch fork pin:** this test exercises `handle_jsm_create` which dispatches to
`POST /rest/servicedeskapi/request` — a completely different endpoint from the platform
`POST /rest/api/3/issue`. The response type `JsmRequestCreated` (in
`src/types/jsm/request_type.rs`) deserializes `issue_key: String` and `handle_jsm_create`
emits `{"key": issue_key}` on stdout in `--output json` mode. This end-to-end path cannot
be validated by mocks that lack real Jira project and request-type metadata.

**Teardown:** Self-close in step 7. See §6 for orphan-risk documentation.

**Clean-skip conditions:** requesttype list empty (§3.2); 403 (§3.3); create returns
non-zero exit (skip with eprintln, not fail).

**BC traced:** BC-3.8.001 (`issue create --request-type` write path). BC-3.8.004 (numeric
bypass used implicitly via all-digit id).

---

### Scenario 7 — Non-JSM guard (require_service_desk)

**Test function:** `test_e2e_jsm_non_jsm_guard`

**Steps:**
1. Run `jr queue list --project <ES> --output json` where `<ES>` is the standard Scrum
   project (`JR_E2E_PROJECT`, typically `ES`).
2. Assert exit code is non-zero (specifically 64, `UserError`, per `JrError::exit_code()`).
3. Assert stderr contains the `require_service_desk` error message. The error message
   format is `<call_site_label> a Jira Service Management project.` where `call_site_label`
   is a noun phrase passed by the queue list handler. Assert that stderr contains the
   substring `"Jira Service Management project"` (locale-stable substring of the
   call-site-labeled message, per BC-X.8.004).

**Note on BC-X.8.004 call-site label contract:** `require_service_desk` takes a
`call_site_label: &'static str` that is prepended before `" a Jira Service Management
project."`. The exact phrase depends on the call site. The E2E test asserts a stable
substring (`"Jira Service Management project"`) rather than the full verbatim string to
remain resilient to call-site-label wording changes that don't alter the core contract.

**Clean-skip condition:** None. This test does not use `JR_E2E_JSM_PROJECT` and targets
the standard project `JR_E2E_PROJECT`, so it runs whenever the primary E2E gate is active.
It does NOT need the JSM project gate.

**BC traced:** BC-X.8.004 (`require_service_desk` guard error + exit code).

---

## 6. Teardown Design and Orphan-Risk Documentation

### 6.1 Self-Close in Test Body

Scenarios 5 and 6 create JSM requests on EJ and MUST self-close them in the test body.

The pattern is: capture `key` from `--output json` stdout immediately after create; run
all assertions; unconditionally attempt `jr issue move <key> <JR_E2E_STATUS_DONE:-Done>`
at the end of the function. If the move fails (e.g. workflow does not have a transition to
Done, or the issue is already Done), emit a warning (`eprintln!`) but do NOT fail the test
on close failure — the close step is best-effort cleanup, not an assertion.

```rust
// Always attempt close at end of test
let close_out = e2e_cmd()
    .args(["issue", "move", &key, &status_done])
    .output()
    .expect("close command");
if !close_out.status.success() {
    eprintln!("[WARN] Failed to close EJ issue {key}: {:?}", close_out.status);
}
```

`jr issue move <EJ-key> <Done>` calls `POST /rest/api/3/issue/{key}/transitions` (the
platform transitions endpoint), which is valid for JSM issues — they are standard Jira
issues underneath the service management layer.

### 6.2 Labels Do NOT Propagate to JSM Requests — Sweeper Cannot Cover EJ

F1 code analysis confirmed that labels inserted into `requestFieldValues` via
`JsmRequestBuilder::build()` (`src/api/jsm/requests.rs`) do NOT reliably propagate to
the Jira issue's `labels` field. The existing e2e.yml teardown sweeper (line ~189) queries:

```
project=$JR_E2E_PROJECT AND labels=e2e-$GITHUB_RUN_ID AND statusCategory != Done
```

This sweeper targets `JR_E2E_PROJECT` (ES) only. Even if labels propagated, EJ issues
would not be caught without extending the sweeper.

**Conclusion: The label-based sweeper CANNOT be relied on for EJ-created requests.**

### 6.3 Residual Orphan Risk

If a test panics mid-flight (between `create` and the self-close step), the EJ issue stays
open. This is LOW risk:

- EJ issues do not affect the platform project ES or any other test.
- Free Jira Cloud sites have no issue quota concern.
- Nightly runs will create and close fresh issues — orphans accumulate but are inert.
- The CI sweeper does NOT cover EJ and labels do not propagate from the JSM create path —
  this is an explicit accepted gap. If orphan accumulation becomes a problem, extend the
  sweeper as a separate maintenance task outside this feature scope.

This orphan risk is documented explicitly here and must be noted in the implementing story's
ACs.

---

## 7. Deferred Sub-Gaps (Out of Scope)

The following JSM behaviors are explicitly out of scope for this feature. They are
documented here to prevent re-discovery and to enable future targeting.

| Sub-gap | Reason deferred | Prerequisite |
|---------|----------------|--------------|
| `--on-behalf-of` flag on `issue create --request-type` | Requires a second customer account on the EJ site. The CI service account is the only account; creating a request on behalf of a second user requires that account to exist. | Provision a second Atlassian account on the E2E site. |
| `write:servicedesk-request` 401 scope hint | Requires a scope-stripped OAuth token to trigger the `InsufficientScope` path (BC-3.8.015). The E2E suite authenticates via Basic auth (`JR_AUTH_HEADER`); a 401 scope error would require a Bearer token with the `write:servicedesk-request` scope absent. | Provision a scope-stripped OAuth token as a CI secret. |
| JSM queue/requesttype pagination | EJ has a small number of queues/request types; pagination is not exercised at free-tier scale. | A larger JSM project with paginated results. |
| Service desk `requesttype` creation/deletion | No `jr requesttype create/delete` command exists. | New jr feature (separate feature scope). |

---

## 8. Verification Properties

These properties have no formal proof strategy (the feature is test-only; no new Rust code
is introduced). They are empirical CI-run checks verified during Phase F6 (targeted
hardening) by inspecting CI run output after `JR_E2E_JSM_PROJECT=EJ` is activated.

### VER-JSM-E2E-1: Queue list shape

**Scenario:** 1 (§5, Scenario 1)
**Condition:** `jr queue list --project EJ --output json` exits 0 and returns a JSON array
where every item has non-null `"id"` and `"name"` fields.
**Verification method (F6):** Inspect the CI E2E run log entry for
`test_e2e_jsm_queue_list_shape`. Confirm the test passes (not skipped) and the assertion
on per-item field presence succeeds.
**Expected outcome:** test passes; no shape assertion fires.

---

### VER-JSM-E2E-2: Requesttype list shape

**Scenario:** 2 (§5, Scenario 2)
**Condition:** `jr requesttype list --project EJ --output json` exits 0 and returns a JSON
array where every item has non-null `"id"` and `"name"` fields.
**Verification method (F6):** Inspect the CI E2E run log for
`test_e2e_jsm_requesttype_list_shape`. Confirm the test passes.
**Expected outcome:** test passes; no shape assertion fires.

---

### VER-JSM-E2E-3: Queue view by name and by --id

**Scenario:** 3 (§5, Scenario 3)
**Condition:** `jr queue view "<name>" --project EJ --output json` exits 0 with `"id"` +
`"name"` in the response; `jr queue view --id <id> --project EJ --output json` exits 0
with `"id"` in the response.
**Verification method (F6):** Inspect the CI E2E run log for `test_e2e_jsm_queue_view`.
Confirm both the by-name and by-id sub-paths are exercised (not skipped) and both
assertions pass.
**Expected outcome:** test passes; both routing branches exercise the real endpoint.

---

### VER-JSM-E2E-4: Requesttype fields shape and numeric-bypass

**Scenario:** 4 (§5, Scenario 4)
**Condition:** `jr requesttype fields <numeric_id> --project EJ --output json` exits 0
and the response contains a top-level `"fields"` key.
**Verification method (F6):** Inspect the CI E2E run log for
`test_e2e_jsm_requesttype_fields`. Confirm the test passes and the numeric-bypass path
was taken (the id used is all-digit).
**Expected outcome:** test passes; `"fields"` key present in response.

---

### VER-JSM-E2E-5: Comment internal vs external visibility round-trip

**Scenario:** 5 (§5, Scenario 5)
**Condition:** After adding a public comment and an `--internal` comment to a fresh EJ
request, `jr issue comments <key> --output json` returns an array where:
- At least one item has `properties[].key == "sd.public.comment"` with
  `value.internal == true` (the internal comment).
- At least one item does NOT have that property (the public comment).
**Verification method (F6):** Inspect the CI E2E run log for
`test_e2e_jsm_comment_visibility`. Confirm the test passes, the EJ issue was created and
closed, and both visibility assertions succeed.
**Expected outcome:** test passes; `sd.public.comment` property correctly present on the
internal comment and absent (or not set to `true`) on the public comment.

---

### VER-JSM-E2E-6: issue create --request-type write round-trip

**Scenario:** 6 (§5, Scenario 6)
**Condition:** `jr issue create --project EJ --request-type <id> --summary "..." --output
json` exits 0, returns `{"key": "EJ-N"}`, `poll_view(key)` resolves, and `jr issue move
<key> Done` succeeds.
**Verification method (F6):** Inspect the CI E2E run log for
`test_e2e_jsm_create_request_roundtrip`. Confirm the ADR-0014 dispatch fork is exercised
(POST to servicedeskapi endpoint, not to `/rest/api/3/issue`), the key is returned, and
the issue is closed.
**Expected outcome:** test passes; key captured, poll_view resolves, self-close succeeds.

---

### VER-JSM-E2E-7: Non-JSM guard exits with correct error

**Scenario:** 7 (§5, Scenario 7)
**Condition:** `jr queue list --project ES --output json` exits non-zero (exit 64) and
stderr contains the substring `"Jira Service Management project"`.
**Verification method (F6):** Inspect the CI E2E run log for `test_e2e_jsm_non_jsm_guard`.
Confirm the test passes and the exit-code + stderr assertions succeed.
**Expected outcome:** test passes; exit 64 confirmed; `require_service_desk` error message
confirmed against BC-X.8.004.

---

## 9. Rollout

No workflow code change is needed. The variable `JR_E2E_JSM_PROJECT` is already wired in
`e2e.yml` (line ~100) as `JR_E2E_JSM_PROJECT: ${{ vars.JR_E2E_JSM_PROJECT }}` inside the
"Run live E2E tests" step `env:` block. Activation requires a single admin operation:

**Set `JR_E2E_JSM_PROJECT=EJ` in the `jira-e2e` GitHub Environment.**

Steps:
1. Navigate to `https://github.com/Zious11/jira-cli/settings/environments/jira-e2e`.
2. Under "Environment variables", click "Add variable".
3. Name: `JR_E2E_JSM_PROJECT`, Value: `EJ`.
4. Save.
5. Verify: trigger a `workflow_dispatch` run on `develop`. Confirm the JSM tests appear in
   the run log as executing (not as `[SKIP]`) and the new test functions are present.

This is an environment variable (environment-scoped to `jira-e2e`), NOT a repository
variable. Environment-scoped variables are passed to the runner after the job starts — the
`JR_E2E_JSM_PROJECT` variable is consumed inside the running Rust test binary, not in a
`jobs.<id>.if:` expression, so environment-scoping is correct for this use case.

---

## 10. F4 Implementation Touch-Point List

The following files are modified in F4. This list is normative for the implementing story.
No other files are touched.

| File | Change | Spec reference |
|------|--------|---------------|
| `tests/e2e_live.rs` | Add 7 new `#[ignore]`-gated test functions (Scenarios 1-7, §5), all gated on `JR_E2E_JSM_PROJECT` per §3.1 (except Scenario 7 which uses `JR_E2E_PROJECT`). Scenarios 5 and 6 include self-close teardown per §6. Replace or supplement the existing 2 shallow JSM tests. | §3, §5, §6 |
| `tests/e2e_cli_surface_guard.rs` | Add 4 new rows to the `SURFACE` static table: `(&["queue", "view"], &["--project", "--output", "--id"])`, `(&["requesttype", "fields"], &["--project", "--output"])`, `(&["issue", "comment"], &["--internal", "--output"])`, `(&["issue", "create"], &["--request-type", "--project", "--output", "--summary"])`. | §5, Scenarios 3-6 |
| `docs/specs/e2e-live-jira-testing.md` | §4 "Optional / feature-flagged" JSM entry: update to list all 7 new test function names and note that queue view, requesttype fields, comment visibility, and create round-trip are now covered. §8 Configuration inventory: update `JR_E2E_JSM_PROJECT` row notes to reflect `EJ` as the value and document the teardown design note (self-close, not sweeper). | §4, §9 |
| `CLAUDE.md` | In the AI Agent Notes E2E section: update `JR_E2E_JSM_PROJECT` entry to note `EJ` is now set; add teardown design convention for JSM write tests (`self-close in test body, not label-sweeper, because labels do not propagate through servicedeskapi to Jira issue labels`). | §6.2 |

**Files confirmed NOT changed:**
- `src/` (all files — zero Rust source changes)
- `.github/workflows/e2e.yml` (wiring already exists; no code change)
- `.github/workflows/ci.yml`, `.github/workflows/release.yml`, `.github/workflows/e2e-sweeper.yml`
- `Cargo.toml`, `Cargo.lock`, `deny.toml`, `.cargo/mutants.toml`
- `scripts/`, `.factory/specs/` (no BC, PRD, or architecture change)
- `BC-INDEX.md`, `CANONICAL-COUNTS.md`

**F4 delivery notes:**
- Zero Rust compilation required for the delta (tests are `--test-threads=1` serialized;
  all new tests are `#[ignore]`-gated and never run in `ci.yml`).
- `cargo test` (non-E2E) and `cargo test --test e2e_cli_surface_guard` MUST pass with the
  new SURFACE rows. This is the F6 offline verification step.
- No Red Gate invocation; no demo story; no mutation testing run (zero `src/` change).
- Delivery is a single story (`S-JSM-E2E-1`, 3 SP) touching tests, SURFACE guard, and
  documentation.

---

## 11. F1 Decisions Encoded in This Spec

| Decision | Encoded in | Value |
|----------|-----------|-------|
| Test set (7 scenarios) | §5 | Scenarios 1-7 as specified |
| Dynamic discovery of queue/RT fixtures | §4 | No new env var; parse list output |
| Self-close teardown (not sweeper) | §6 | Capture key from `--output json`; `jr issue move` at test end |
| Sweeper does NOT cover EJ (labels don't propagate) | §6.2, §6.3 | Explicit accepted gap |
| Residual orphan risk accepted | §6.3 | LOW; inert EJ issues; documented |
| Clean-skip on unset JR_E2E_JSM_PROJECT | §3.1 | Loud eprintln, return |
| Clean-skip on empty list | §3.2 | Loud eprintln, return |
| Clean-skip on 403 | §3.3 | Loud eprintln, not fail |
| Numeric-bypass for RT id | §4.2 | All-ASCII-digit id → `handle_jsm_create` bypass |
| No new BC, no new NFR | §2.2 | BC corpus 585, NFR corpus 41, unchanged |
| Deferred: --on-behalf-of, scope-stripped-token 401 | §7 | Documented sub-gaps |
| Rollout: set JR_E2E_JSM_PROJECT=EJ in jira-e2e env | §9 | Environment variable (env-scoped, not repo-level) |
| Zero src/ delta | §2.1 | All JSM commands exist; F4 is test-only |

---

## 12. References

- F1 delta analysis: `.factory/phase-f1-delta-analysis/jsm-e2e-expansion/delta-analysis.md`
- Brainstorming report: `.factory/planning/brainstorming-report-jsm-e2e.md`
- Existing E2E spec: `docs/specs/e2e-live-jira-testing.md`
- Fork-safe CI spec: `docs/specs/e2e-fork-safe-ci-enablement.md`
- ADR-0004: Per-feature specs: `docs/adr/0004-per-feature-specs.md`
- ADR-0014: JSM create dispatch fork: `docs/adr/0014-jsm-request-creation.md`
- BC-X.8.004: `require_service_desk` guard: `.factory/specs/prd/bc-x-cross-cutting.md`
