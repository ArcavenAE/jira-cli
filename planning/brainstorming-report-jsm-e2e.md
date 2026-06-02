---
document_type: brainstorming-report
topic: JSM (Jira Service Management) E2E test coverage expansion
date: 2026-06-02
mode: feature
techniques: [mind-mapping]
status: direction-selected
recommended_next_step: phase-f1-delta-analysis
---

# Brainstorming Report — JSM E2E Coverage Expansion

## Session Summary

- **Facilitator:** orchestrator (brainstorming skill)
- **Date:** 2026-06-02
- **Technique:** Mind mapping (map the JSM command surface → per-command coverage branches → per-assertion sub-branches; prioritize by value/risk and flag feasibility constraints)
- **Trigger:** Human added a JSM (Jira Service Management) project `EJ` (name "E2E-JSM") to the E2E test site to exercise JSM features. Goal: expand JSM E2E coverage beyond the two existing shallow read tests.

## Problem and Context

The live E2E suite currently has only TWO shallow JSM tests — `test_e2e_jsm_queue_list_exits_ok` and `test_e2e_jsm_requesttype_list_exits_ok` — both gated on `JR_E2E_JSM_PROJECT` (currently unset → clean-skip) and both asserting only `exit 0 + is-array`. This project adopted live E2E precisely because shallow/mock-only tests gave false confidence (the createmeta/label/priority wire-shape bugs all passed mocks and only failed live). Shallow JSM assertions repeat that risk. Now that a real JSM project (`EJ`) exists, JSM coverage can be activated and deepened.

## Current State (grounding)

`jr` JSM command surface and current coverage:
- `jr queue list --project <JSM>` — read. Covered (shallow: exits-0 + is-array).
- `jr queue view <queue> --project <JSM>` (name partial-match or `--id`) — read. UNCOVERED.
- `jr requesttype list --project <JSM>` — read. Covered (shallow).
- `jr requesttype fields <NAME|ID>` — read. UNCOVERED. Has a documented numeric-bypass gotcha (an RT named "100" is unreachable by name).
- `jr issue create --request-type <RT>` — WRITE. UNCOVERED. Routes to POST /rest/servicedeskapi/request (ADR-0014); `--type` silently ignored on this path; custom fields via `--field`; `--on-behalf-of`; 401 → write:servicedesk-request scope hint.
- `jr issue comment <key> [--internal]` — WRITE. `--internal` sets the `sd.public.comment` entity property `{"internal": true}` (agent-only); default = public/customer-visible reply. Uses platform endpoint /rest/api/3/issue/{key}/comment with entityProperties. JSM comment visibility UNCOVERED by E2E.
- `jr issue comments <key> --output json` — READ. Surfaces each comment's `properties[]` including `sd.public.comment`, and shows a Visibility column. So internal/external visibility is READ-BACK-CAPABLE → a comment-visibility round-trip is feasible.
- `require_service_desk` (src/api/jsm/servicedesks.rs, BC-X.8.004) — errors with a call-site-labeled message when a JSM command targets a non-JSM project.

Config: `JR_E2E_JSM_PROJECT` is wired in e2e.yml as `${{ vars.JR_E2E_JSM_PROJECT }}` and consumed in a step env (not the job-level if:), so it belongs as an ENVIRONMENT variable in the `jira-e2e` environment (matching JR_E2E_PROJECT=ES, JR_E2E_BOARD_ID=3, JR_E2E_ISSUE_TYPE_ALT=Bug). It is currently UNSET.

## Ideas Generated (mind map)

```
JSM E2E coverage (project EJ)
├─ Deepen existing reads:  queue list → assert id+name; requesttype list → assert id+name (catch wire-rename)
├─ New reads:  queue view <q> (by name AND --id);  requesttype fields <NAME|ID> (+ pin numeric-bypass gotcha)
├─ Comments internal vs external:  add public + add --internal → comments --output json →
│     assert sd.public.comment {"internal":true} present on internal, absent on public  (JSM-defining)
├─ Write: create --request-type:  create request on EJ → verify → close  (⚠️ teardown design needed —
│     servicedeskapi requests may not carry the run-label the sweeper closes by)
└─ Error/guard paths:
     ├─ require_service_desk on non-JSM project (point a JSM command at ES → clear error, BC-X.8.004)  ✅
     ├─ write:servicedesk-request 401 scope hint  ❌ impractical (needs scope-stripped token)
     └─ --on-behalf-of  ❌ blocked (needs a 2nd customer account; site has one user)
```

## Themes

1. **Activate + deepen reads** (queue list/view, requesttype list/fields) — turn shallow into shape-asserting.
2. **JSM-defining behaviors** — internal/external comment visibility round-trip; the servicedeskapi create path.
3. **Guard/error correctness** — non-JSM-project rejection.
4. **Feasibility-blocked** — on-behalf-of and scope-hint (single-user / token constraints).

## Selected Direction

**Full first-cut JSM E2E test set, including the `create --request-type` write round-trip.**

- **Test set (first cut):**
  1. Deepen `queue list` + `requesttype list` to assert per-item shape (id + name).
  2. `queue view <queue>` — by name AND by `--id`.
  3. `requesttype fields <NAME|ID>` — incl. pinning the numeric-bypass gotcha.
  4. **Comments internal vs external** — on a JSM issue, add a public comment + an `--internal` comment, read back via `comments --output json`, assert `sd.public.comment` visibility on the internal one and its absence on the public one.
  5. **`issue create --request-type`** write round-trip on EJ → verify → **explicit per-test teardown** (capture the returned key and close it in the test's own always() cleanup, since the sweeper's label-based close may not catch servicedeskapi requests).
  6. **Non-JSM guard** — point a JSM command at the standard project (ES) and assert the `require_service_desk` error (BC-X.8.004) + exit code.
- **Deferred (noted in STATE as JSM E2E sub-gaps):** `--on-behalf-of` (needs a 2nd customer account); `write:servicedesk-request` 401 scope hint (needs a scope-stripped token). Revisit if a 2nd account/token is provisioned.
- **Audience:** maintainers (real JSM regression safety net), JSM `jr` users (queue/requesttype/request-create/comment-visibility paths verified against live Jira).
- **Differentiator:** deep, round-trip assertions against a real JSM project — not exits-0/mock shallowness — directly targeting the false-confidence failure mode that justified live E2E; covers the servicedeskapi create path and the sd.public.comment visibility property that mocks cannot validate.
- **Rollout (part of the feature):** set `JR_E2E_JSM_PROJECT=EJ` as an environment variable in the `jira-e2e` environment (matching the data-var convention).

## Open Questions for Phase F1 (Delta Analysis)

1. **Teardown for servicedeskapi-created requests:** does `jr issue create --request-type` return an issue key usable by `jr issue move`/close? Do labels propagate to servicedeskapi requests so the existing sweeper catches them, or must the test self-close in always()? Design the teardown so the write test never pollutes EJ.
2. **Free-tier / plan JSM availability:** confirm via a live run that queue list/view, requesttype list/fields, and create-request all work on EJ's plan; tests must clean-skip (not fail) on a 403/feature-unavailable.
3. **Which request type to create:** does the create test need a known request-type name/id on EJ, or should it discover one dynamically via `requesttype list`? Consider whether a new env var (e.g. JR_E2E_JSM_REQUEST_TYPE) is needed or derive dynamically.
4. **queue view fixture:** queue view needs a queue (with issues) on EJ; derive the queue from `queue list` output or require a known queue id.
5. **Comment-visibility round-trip on EJ:** confirm `jr issue comments --output json` exposes `properties[].sd.public.comment` for a JSM issue and that `--internal` round-trips; ensure the comment is added to a JSM issue (EJ-N), not a platform issue.
6. **requesttype fields numeric-bypass:** decide whether to pin the gotcha (all-digit input treated as ID) in E2E or leave to unit tests.
7. **Surface guard:** new invocations (`queue view`, `requesttype fields`, `issue comment --internal`, `issue create --request-type`) and any flags must be registered in tests/e2e_cli_surface_guard.rs (avoid the positional/flag-arity class of misses).
8. **Scope confirmation:** likely zero-`src/` (all JSM commands already exist) — F4 = new tests in tests/e2e_live.rs + the env var + surface-guard rows. Confirm no jr capability gap (esp. teardown). If a gap is found (e.g. cannot close a JSM request), that becomes a separate jr feature.
9. **Env-var scope:** JR_E2E_JSM_PROJECT must be an environment variable in jira-e2e (read in step env, not job if:), value EJ.

## Recommended Next Step

Proceed to **Phase F1 — Delta Analysis** (`/vsdd-factory:phase-f1-delta-analysis`) for "JSM E2E coverage expansion (project EJ)". Likely LOW regression risk and probably zero-`src/` (test-only + CI env var + surface-guard), pending the teardown-feasibility finding in OQ-1/OQ-8.
