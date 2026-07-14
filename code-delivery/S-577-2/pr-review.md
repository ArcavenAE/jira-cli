# Fresh-Eyes PR Review — #611

**PR:** feat(api): add comment CRUD API methods — delete/update/get (S-577-2, #577)
**Base:** develop
**Files:** `src/api/jira/issues.rs` (+76), `tests/comment_crud_api.rs` (+302)
**Reviewer:** pr-reviewer (fresh context, cognitive-diversity model)

## Verdict: APPROVE

No blocking findings. Three API-layer methods are wire-correct, error propagation is sound, and test coverage maps to all five acceptance criteria plus the encoding pin. One LOW description-accuracy finding and two informational notes below.

---

## Findings

### F-1 — PR body's AC→test table does not match any actual test name (LOW, non-blocking)
- **Category:** description-accuracy (checklist item 2)
- **Location:** PR description "Acceptance criteria → tests" table
- The PR body lists test names `test_s_577_2_ac1_delete_comment_sends_correct_request`, `test_s_577_2_ac2_...`, `test_s_577_2_ac3_update_comment_visibility_true_adds_internal_true`, `test_s_577_2_ac4_...`, `test_s_577_2_ac5_get_comment_expands_properties`, and `test_s_577_2_url_encoding_key_with_slash_is_percent_encoded`.
- The actual tests in `tests/comment_crud_api.rs` are: `test_delete_comment_204_returns_ok`, `test_update_comment_body_only_no_properties_key`, `test_update_comment_internal_properties_wire_shape`, `test_update_comment_public_properties_wire_shape`, `test_get_comment_sends_expand_properties_query_param`, `test_delete_comment_encodes_key_with_space_in_url`. **None of the six match.**
- The mismatch also carries a factual error: the body's last row claims the encoding test uses a key "with_slash" percent-encoded, but the real test uses a **space** → `%20`, not a slash. The test's own docstring notes the `%20` assertion is non-load-bearing and the real mutant-kill assertion is `reqs.len()==1`.
- **Impact:** a reviewer following the table cannot locate the tests, and the table overstates what the encoding test proves. The actual test names correctly follow the `test_<verb>_<subject>_<outcome>` convention. **Suggestion:** correct the table to the real names; no code change needed.

### F-2 — No error-path coverage at the API layer (LOW, informational)
- **Category:** test-coverage (checklist item 3)
- All six tests cover happy paths (204/200) only; no test for 4xx/5xx propagation (e.g., delete of a nonexistent comment → 404). Acceptable for this story: error mapping is centralized in `JiraClient::send_inner` (4xx/5xx → `JrError::ApiError`, 401 → auth path) and tested elsewhere; handler-level error UX is scoped to S-577-4/5. Noted for scope confirmation.

### F-3 — No demo evidence in the PR (LOW, informational)
- **Category:** demo-evidence (checklist item 4)
- No `docs/demo-evidence/` content; body states demos live in `.factory/demos/S-577-2/`. For a pure API-layer story adding internal `JiraClient` methods with no user-observable CLI surface, there is nothing to record visually — the methods are consumed by later handler stories. Not treated as blocking (the missing-demo BLOCKING rule presumes a user-facing AC). pr-manager should confirm the S-577-2 AC set has no CLI-observable behavior.

---

## Verified correct (no rubber-stamp)

1. **Wire shapes** — all three match Jira REST v3: `DELETE`/`PUT`/`GET /rest/api/3/issue/{key}/comment/{id}`, `?expand=properties` on GET. Correct client helpers (`delete`/`put`/`get`).
2. **`update_comment` conditional shape** — `{"body": body}` built first, `"properties"` inserted only under `Some(_)`. Deliberate asymmetry (BC-3.5.005/006/007) preserved and pinned by AC-2's exact-key-set assertion. Property key `"sd.public.comment"` (dot) and `internal` as boolean asserted in AC-3/AC-4. Not flagged as a simplification opportunity.
3. **URL encoding** — `key` percent-encoded via `urlencoding::encode` (consistent with 13 existing call sites); `id` raw with identical `# Preconditions` rustdoc on all three methods requiring `^[0-9A-Za-z_-]+$`. `urlencoding = "2"` already declared.
4. **`?` propagation / soundness** — all three delegate to helpers using `?`; `send_inner` maps non-2xx (except 401→auth) to `JrError::ApiError`; no silent-success paths. `update_comment` discarding response and `get_comment` returning raw `Value` are documented and correct per BC-3.5.010.
5. **LOC note** — `issues.rs` is exactly 917 lines on the branch (>900 soft target, <1,000 ADR-0012 threshold). Do-not-extract mandate appropriately flagged in the PR body.
6. **Diff size** 378/0 (well under 500); **commits** conventional, story-ID-tagged, clean stub→red→green→doc TDD history; **dependency** base `develop`, independent of unrelated parallel #610.
