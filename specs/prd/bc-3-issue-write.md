---
context: bc-3
title: "Issue Write (create/edit/move/assign/comment/link/open/remote-link)"
total_bcs: 120   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 91   # count of `#### BC-` headings in this file
last_updated: 2026-07-11
source_pass: 3
trace: |
  - L2: .factory/specs/domain-spec/bc-03-issue-write.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.3
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.1
  - F2 addition (2026-05-15): BC-3.4.009 — bulk-poll timeout task_id contract (issue #340)
  - F2 addition (2026-05-18): BC-3.8.001..010 — JSM request submission (issue #288 F2 added 001..009; F1d pass-01 added BC-3.8.010 to close --type interaction)
  - F1d addition (2026-05-18): BC-3.8.010 — --type ignored with warning when --request-type is set (issue #288 adversary pass-01)
  - F1d addition (2026-05-19): BC-3.8.011 — platform-only flags emit stderr warnings on JSM path (issue #288 adversary-pass-01 C-02); H-01 BC-3.8.003 verb aligned "Use"→"Run"
  - F2 addition (2026-05-19): BC-3.8.012..013 — inverse warning symmetry: --field and --on-behalf-of silent-drop on platform path (issue #383)
  - F2 addition (2026-05-19): BC-3.8.014..015 — JSM 401 auth-conditional hints on handle_jsm_create: Basic-auth (is_oauth_auth==false) → API-token hint with InsufficientScope rewrite; OAuth (is_oauth_auth==true) → existing behavior preserved (issue #384; corrected model: gate is is_oauth_auth() alone)
  - F2 addition (2026-05-20): BC-3.8.016 — --request-type "" (empty) exits 64 before partial_match (issue #385)
  - F2 addition (2026-05-20): BC-3.8.017 — --markdown + --field description= conflict rejected at parse-time exit 64 (issue #385)
  - F2 modified (2026-05-20): BC-3.8.002 — JSM project-required error harmonized with platform affordances (issue #385 O-08-02)
  - F2 modified (2026-05-20): BC-3.8.010 — warning position clarified: fires post-require_service_desk only (issue #385 O-08-07)
  - F2 modified (2026-05-20): BC-3.8.011 — same warning-position constraint applied (issue #385 O-08-07)
  - F2 addition (2026-05-20): BC-3.4.010 — `edit --type` cross-hierarchy 400 → CROSS_HIERARCHY_HINT (JRACLOUD-27893) (issue #388)
  - F2 addition (2026-05-20): BC-3.4.011 — `edit --type` same-hierarchy/indeterminate 400 → typo hint or raw error (issue #388)
  - F2 modified (2026-05-20): BC-3.4.003 — Errors cross-reference added for BC-3.4.010 and BC-3.4.011 (issue #388 annotation only)
  - F2 addition (2026-05-21): BC-3.4.012 — `issue edit` table-mode success echoes one stderr line per changed field (issue #398)
  - F2 addition (2026-05-21): BC-3.4.013 — `issue edit` JSON-mode success includes `changed_fields` object; description carries the RAW user-supplied input string (NOT an adf.rs round-trip); `updated:true` retained (issue #398)
  - F2 addition (2026-05-21): BC-3.4.014 — `issue create` table-mode success echoes resolved team name when `--team` is set (issue #398)
  - F2 modified (2026-05-22, human-gate): BC-3.4.014 — broadened from team-only to ALL set fields, mirroring BC-3.4.012 (human-gate decision 2026-05-22)
  - F2 modified (2026-05-21): BC-3.4.003 — cross-reference to BC-3.4.012 and BC-3.4.013 added (issue #398 annotation only)
  - F2 modified (2026-05-21, adversary round 3): BC-3.4.012 — EC-13 (--description+--summary alphabetical sort pin) and EC-14 (--markdown table-mode still shows (updated)) added (M-1, MED-1, MED-2)
  - F2 modified (2026-05-21, adversary round 3): BC-3.4.013 — EC-11 (--markdown raw Markdown in changed_fields) added; frontmatter trace corrected to raw-input-string model (MED-2, M-1)
  - F2 modified (2026-05-21, adversary round 3): BC-3.4.014 — H1 title KEY token dropped; output channel profile reclassified to profile 4 (Symmetric) (COS-1, MED-4)
  - F2 modified (2026-05-21, adversary round 4): BC-3.4.014 — profile-4 carve-out paragraph added; EC-3.4.014-3 exit code pinned to 64; VP-398-001 fixture constraint added (F-1, O-2, F-3)
  - F2 modified (2026-05-21, adversary round 4): BC-3.4.012 — EC-3.4.012-10 stored-casing clause; VP-398-001 fixture constraint (F-2, F-3)
  - F2 modified (2026-05-21, adversary round 4): BC-3.4.013 — EC-3.4.013-8 stored-casing clause; VP-398-001 fixture constraint (F-2, F-3)
  - F2 modified (2026-05-21, adversary round 5): BC-3.4.012 — VP-398-001 negative case rewritten as direct unit-level is_team_uuid assertion; EC-3.4.012-15 added (MatchResult::None) (F-1, F-3)
  - F2 modified (2026-05-21, adversary round 5): BC-3.4.013 — VP-398-001 negative case rewritten as direct unit-level is_team_uuid assertion; EC-3.4.013-12 added (MatchResult::None) (F-1, F-3)
  - F2 modified (2026-05-21, adversary round 5): BC-3.4.014 — VP-398-001 negative case rewritten as direct unit-level is_team_uuid assertion; EC-3.4.014-5 added (MatchResult::None) (F-1, F-3)
  - F2 modified (2026-05-21, adversary round 7): BC-3.4.012 — VP-398-001 module-private placement sentence added; EC-3.4.012-12 test name pinned; EC-3.4.012-2 clap-conflict wording; VP-398-004 added (F-1, F-2, F-4, F-5)
  - F2 modified (2026-05-21, adversary round 7): BC-3.4.013 — VP-398-001 module-private placement sentence added; EC-3.4.013-10 test name pinned; EC-3.4.013-3 clap-conflict wording; VP-398-002 stdin trailing-newline sub-case inline; VP-398-004 added (F-1, F-2, F-4, F-5, F-6)
  - F2 modified (2026-05-21, adversary round 7): BC-3.4.014 — VP-398-001 module-private placement sentence added (F-1)
  - F2 modified (2026-05-21, adversary round 8): BC-3.4.012 — two-site insertion enumeration for points/parent; f64 .to_string() invariant scoped to --points branch; concrete assertion values for points; EC-3.4.012-12 pinned as integration test (wiremock); EC-3.4.012-16 added (empty-stdin edge case) (MAJOR-1, IMP-3, OBS-2, OBS-4)
  - F2 modified (2026-05-21, adversary round 8): BC-3.4.013 — two-site insertion enumeration for points/parent; f64 .to_string() invariant scoped to --points branch; invariant 4 + VP-398-003 body add test_edit_response_empty_changed_fields; EC-3.4.013-13 added (empty-stdin edge case) (MAJOR-1, MAJOR-2, IMP-3)
  - F2 modified (2026-05-21, adversary round 9): BC-3.4.012 — EC-3.4.012-12 wiremock-only note added (IMPORTANT-1)
  - F2 modified (2026-05-21, adversary round 9): BC-3.4.013 — EC-3.4.013-10 wiremock-only note added (IMPORTANT-1)
  - F2 modified (2026-05-21, adversary round 10): BC-3.4.012 — invariant 6 added (map construction vs emission timing; map discarded on PUT error, emitted only post-204); EC-3.4.012-16 has_any_field_change→has_updates [NOTE: this rename was an over-correction; corrected back in round 12] (IMPORTANT-3, IMPORTANT-2)
  - F2 modified (2026-05-21, adversary round 10): BC-3.4.013 — invariant 4 pinned regenerated snapshot body + top-level key order note; invariant 6 added (map construction vs emission timing); EC-3.4.013-13 has_any_field_change→has_updates [NOTE: this rename was an over-correction; corrected back in round 12]; top-level key order note added to signature paragraph (MAJOR-1, IMPORTANT-1, IMPORTANT-2, IMPORTANT-3)
  - F2 modified (2026-05-21, adversary round 12): BC-3.4.012 — EC-3.4.012-16 reverted to has_any_field_change (pre-HTTP guard at edit.rs::has_any_field_change); two-guard clarifying parenthetical added (MAJOR-2)
  - F2 modified (2026-05-21, adversary round 12): BC-3.4.013 — EC-3.4.013-13 reverted to has_any_field_change (pre-HTTP guard at edit.rs::has_any_field_change); two-guard clarifying parenthetical added; serde_json top-level key order rationale corrected from insertion-order to alphabetical-by-default (MAJOR-1, MAJOR-2)
  - F2 modified (2026-05-21, adversary round 12): BC-3.4.013 — signature paragraph top-level key order rationale corrected from insertion-order to alphabetical-by-default (MAJOR-1)
  - F2 modified (2026-05-21, adversary round 12): BC-3.4.013 — invariant 4 top-level key order rationale corrected from insertion-order to alphabetical-by-default (MAJOR-1)
  - F2 addition (2026-05-22): BC-3.4.015 — `issue edit --field NAME=VALUE` string/number/date/datetime/user field on single-key path via editmeta (issue #396)
  - F2 addition (2026-05-22): BC-3.4.016 — `issue edit --field NAME=VALUE` single-select option field: value→allowedValues id resolution, wire `{"id":"..."}`, echo shows human label (issue #396)
  - F2 addition (2026-05-22): BC-3.4.017 — `--field` multi-key/--jql multi-issue rejection (C-1 guard) + flag-overlap hard error for summary/description/issuetype/priority (issue #396)
  - F2 amended (2026-05-22, adversary pass 1): BC-3.4.015 — EC-3.4.015-9 empty-NAME behavior corrected; EC-3.4.015-4a number wire format; EC-3.4.015-12a PUT-failure discard; EC-3.4.015-17 case-sensitive bypass deliberate; EC-3.4.015-18 dry-run; resolve_edit_fields canonical signature; VP-396-007..010 added
  - F2 amended (2026-05-22, adversary pass 1): BC-3.4.016 — EC-3.4.016-4 id/label collision note; VP-396-006 added to Verification Properties
  - F2 amended (2026-05-22, adversary pass 1): BC-3.4.017 — invariant 1 Gate B-before-A ordering; EC-3.4.017-2 JQL-multi clarification; EC-3.4.017-10 same-field two-pairs; EC-3.4.017-11 type vs issuetype; EC-3.4.017-12 simultaneous Gate A+B; Gate A postcondition split; LOW-001 EC ref corrected; VP-396-008 added
  - F2 amended (2026-05-22, adversary pass 3): BC-3.4.015 — Step 3b (operations/"set" check + exit 64 hint) added; EC-3.4.015-19 (resolution failure under --dry-run exits 64); EC-3.4.015-20 (operations lacks "set"); EC-3.4.015-18 exit code pinned to 0; VP-396-011 (user/date/datetime wire) and VP-396-012 (operations check) added; VP-396-008 one-liner updated
  - F2 modified (2026-05-25): BC-3.4.017 — EC-3.4.017-14 added (mechanical enforcement meta-test for invariant 2 completeness); invariant 2 cross-reference added (issue #407 F2)
  - F2 amended (2026-05-27): BC-3.4.015 — invariant 5 rewritten to describe two-stage i64-first strategy (no behavioral change for previously-correct inputs); EC-3.4.015-4b added (i64-boundary regression pin: "9223372036854775808" and "-9223372036854775809" MUST emit f64 wire form) (issue #421)
  - F1 amended (2026-07-09, issue #589 SOH-BUGS-1): BC-3.4.015 — VP-396-008 extended (dry-run succeeds when editmeta has idless allowedValues on non-targeted fields; AllowedValue.id typed Option<String>); VP-589-001 added (deserialization succeeds for id-absent allowedValues entries on non-targeted fields; targeted string-type edit proceeds normally)
  - F1 amended (2026-07-09, issue #589 SOH-BUGS-1): BC-3.4.016 — EC-3.4.016-8 added (id=None matched entry → exit 64 with actionable message; load-bearing substrings: "no machine-readable id", "--field"); Step 1 id-bypass amended (id=None entries excluded silently, fall through to label matching); Invariant 4 extended (id=None never triggers id-bypass); VP-396-002 clarified ({"id":...} wire form applies only when matched entry has non-None id)
  - F1 amended (2026-07-09, issue #589 SOH-BUGS-1): BC-3.4.017 — VP-396-008 extended (idless allowedValues on non-targeted fields; dry-run succeeds sub-case)
  - F2 addition (2026-06-01): BC-3.4.018 — `issue edit KEY1 KEY2 --type <NAME>` multi-key bulk wire shape: selectedActions=["issuetype"] (lowercase), editedFieldsInput["issueType"]={"issueTypeId":"<id-string>"} (camelCase key, id-based value); name→id resolved via GET /rest/api/3/issue/createmeta/{proj}/issuetypes; unknown type name exits 64; dry-run builder consistency pin (issue #331 F2)
  - F2 addition (2026-06-01): BC-3.4.019 — `issue edit KEY1 KEY2 --type <NAME>` cross-project guard: when resolved keys span >1 distinct project, exit 64 with actionable message BEFORE any API call; references single-issueTypeId-per-batch constraint as rationale (issue #331 F2)
  - F2 addition (2026-06-03): BC-3.2.013 — `issue move` proactive resolution enforcement on done-category transitions (single-key only): REQUIRED resolution → mandatory (prompt or --resolution or exit 64 on --no-input; --no-resolution exits 64); OPTIONAL resolution → explicit choice required (--resolution / --no-resolution / prompt; non-interactive without either flag exits 64); breaking change to jr issue move default behavior; BC-3.2.009 retained as backstop (F2 jsm-resolution-required)
  - F2 addition (2026-06-08): BC-3.2.014 — multi-key bulk move `bulkTransitionInputs` nested wrapper wire schema (document-as-is correctness bug fix, commit acca854, live run 27156639337)
  - F2 addition (2026-06-30): BC-3.4.020 — `issue edit --label` routing fork: single-key PUT bare-string labels vs 2+ key bulk POST `{"name":...}` objects; load-bearing asymmetry MUST NOT be unified (BUG-LABEL-400; BC-subclause-pass F2)
  - F2 addition (2026-06-30): BC-3.4.021 — `issue edit --dry-run` `plannedChanges` output structure + `--output json` schema `{dryRun, issues, plannedChanges}`; intentionally simplified preview shapes (BC-subclause-pass F2)
  - F2 addition (2026-07-09, issue #577 SOH-COMMENT-CRUD-1, DEC-168): BC-3.5.002..BC-3.5.012 — comment delete/edit/view CRUD and CLI subcommand group refactor: delete endpoint+confirmation+404-exit-64; edit body-only-PUT invariant, --internal/--public explicit properties, --public always-confirm, body sources, mutual-exclusion; view GET+display+JSON; CLI breaking change (comment→subcommand group, add canonical form, old flat form → clap error with migration hint)
  - F2 adversary pass-32 fix round 38 (2026-07-10, spec v1.3.29): BC-3.5.006 F1 stale jsm_self_close clause replaced with forward-reference; BC-3.5.005 F2 VP-577-025 added (human echo markers pinned); BC-3.5.006 F3 sequencing constraint added; EC-3.5.012-5 F4 BC-3.4.011 removed from item (a)
  - F2 adversary pass-34 fix round 39 (2026-07-10, spec v1.3.30): BC-3.5.005 F-577-A VP-577-026 added (jsm_internal boolean-type + key-absence parse pin); BC-3.5.010 F-577-B field-6 identifier-fallback extended (defensive rendering per research issue-577-visibility-identifier-shape-2026-07-10.md)
  - F2 adversary pass-35 fix round 40 (2026-07-10, spec v1.3.31): BC-3.5.012 F-A1 EC-3.5.012-5 items (f)+(g) README+CLAUDE.md migration obligations; BC-3.5.004/005/010 F-A2 Other-4xx/5xx-except-401 + 401-auth-path exit-2 clause; BC-3.5.002 F-A3 EC-3.5.002-2 KEY URL-encoding + VP-577-027; BC-3.5.008 F-A4 EC-3.5.008-4 --yes silent-no-op (orchestrator ruling) + VP-577-028; BC-3.5.003/008 F-A5 EC-3.5.003-3 + EC-3.5.008-5 dialoguer Err → JrError::Interrupted exit 130; BC-3.5.010 F-A6 field-6 rung(c/d) unknown-type defensive rendering (four-rung ladder); VP-577 family 26→28
  - F2 adversary pass-36 fix round 41 (2026-07-10, spec v1.3.32): BC-3.5.008 F-1 VP-577-028 second variant reformulated (runtime clap-requires probe: empty-body exit-64 proves requires("public") absent); BC-3.5.010 F-2 field-6 rung(b) broadened to include empty-string value; BC-3.5.002 F-3 VP-577-027 reformulated (received_requests URL inspection replaces dual-mount); F-4 EC-3.5.002-2 site-ordering corrected (per-endpoint helper named first; client.rs noted as generic layer); VP count unchanged (28)
  - F2 adversary pass-37 fix round 42 (2026-07-10, spec v1.3.33): BC-3.5.012 F-01 Edit subcommand-to-BC map corrected (BC-3.5.010 removed from Edit range; explicit non-contiguous list); BC-3.5.002 F-02 VP-577-009 reformulated (BTreeSet exact key-set assertion); BC-3.5.010 F-03 normative label-value separator sentence added + VP-577-021 third variant (JSM internal: N/A byte-level pin; in-place variant, VP count unchanged); F-04 EC-3.5.010-2 split into (a)/(b) (UserError depth-guard propagates unchanged; future error kinds must be re-classified); field-7 cross-ref updated to EC-3.5.010-2 (a); VP count unchanged (28)
  - F2 adversary pass-38 fix round 43 (2026-07-11, spec v1.3.34): BC-3.5.005 F-01 VP-577-023 top-level key-set + VP-577-026 variants 1/2/3 changed_fields key-set assertions (in-place); BC-3.5.002 F-02 VP-577-009 human-mode variant added; BC-3.5.010/holdout F-03 VP-577-007 "updated" key + H-NEW-COMMENT-004 Expected A properties assertion hardened; BC-3.5.008 R-1 EC-3.5.008-4 + VP-577-028 human-ratified 2026-07-11 (gate language removed, ratification note added); R-2 stray-confirmation-flag follow-up story candidate added (human-approved 2026-07-11); VP count unchanged (28)
  - F2 adversary pass-39 fix round 44 (2026-07-11, spec v1.3.35): BC-3.5.005 F1 VP-577-023 human-mode variant; F4 VP-577-025 JSDCLOUD-6050 assertions (both variants); BC-3.5.008 F2 VP-577-029 (interactive cancel JSON key-set mirrors VP-577-013); F3 VP-577-030 (EOF/interrupt exit 130 two variants); BC-3.5.010 F5 VP-577-021 variants 4/5/6 (field-6 rungs a/b/c); M1 VP-577-021 variant 7 (JSM internal: No); VP-577 family 28→30
  - F2 adversary pass-40 fix round 45 (2026-07-11, spec v1.3.36): BC-3.5.010 F-01 routing-sentence mis-anchor corrected (handle_comment_view sibling + relocates qualifier); BC-3.5.007 F-02 SEC-577-001 first-cite definitional pointer added (premise corrected: defined in security-review-577.md); BC-3.5.003 F-03 VP-577-013 BTreeSet exact key-set + id/key-omitted-from-cancel-envelope rule; VP count unchanged (30)
  - F2 adversary pass-41 fix round 46 (2026-07-11, spec v1.3.37): BC-3.5.006 + BC-3.5.007 F-01 VP-577-002 + VP-577-003 extended (d) properties key-name + array-len pin (sd.public.comment + len==1); VP count unchanged (30)
  - F2 adversary pass-44 fix round 47 (2026-07-11, spec v1.3.38): BC-3.5.008 F-1 VP-577-006 rewritten (non-empty body invocation + setup note; stderr substrings "visibility to public" + "--yes" prove step-3 --public gate fires not step-2 body gate); error-taxonomy.md F-2 comment 403/404 override rows added + TD-031 pre-existing volatile-line-cite fixed; streak reset 2/3→0/3 under Full STRICT; VP count unchanged (30)
  - F2 adversary pass-45 fix round 48 (2026-07-11, spec v1.3.39): BC-3.5.008 F-1 VP-577-006 setup-note gate mis-cite corrected (bodyless invocation fires BC-3.5.009 body-required rule, not EC-3.5.009-5; message updated verbatim from BC-3.5.009 ~line 2452); BC-3.5.008 Trace updated; VP count unchanged (30)
---

# BC-3 — Issue Write

120 behavioral contracts across 8 subdomains: Assign (3.1), Move/Transition (3.2),
Create (3.3), Edit+Open (3.4), Comment (3.5), Links (3.6), Remote links (3.7),
JSM Request Create + Platform-Path Inverse Warnings + Auth-Conditional 401 Hints (3.8).

---

## Subdomains

### 3.1 Assign

#### BC-3.1.001: `issue assign --account-id <id>` PUTs `/issue/<key>/assignee` with `{accountId: <id>}`

**Confidence**: HIGH
**Source**: `tests/cli_handler.rs:58-91`; `tests/issue_commands.rs:1646-1703`
**Subject**: Issue write
**Behavior**: Body partial-JSON match `{accountId: "direct-id-001"}`. Output JSON: `{"changed": true, "key": "HDL-1", "assignee": "direct-id-001", "assignee_account_id": "direct-id-001"}`.
**Effects**: HTTP PUT to `/rest/api/3/issue/<key>/assignee`.
**Trace**: Pass 3 BC-201; BC-1077 (R4)

---

#### BC-3.1.002: `issue assign --to <name>` resolves via assignable user search then assigns

**Confidence**: HIGH
**Source**: `tests/cli_handler.rs:93-133`; `tests/issue_commands.rs:807-854`
**Subject**: Issue write
**Behavior**: GET `/rest/api/3/user/assignable/search?query=<name>&issueKey=<key>` → PUT with resolved accountId. Output `"assignee": "Jane Doe"`, `"changed": true`.
**Trace**: Pass 3 BC-202; BC-1059 (R4)

---

#### BC-3.1.003: `issue assign --to me` resolves current user via `/myself`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:879-920`
**Subject**: Issue write
**Behavior**: `get_myself()` → `assign_issue(key, Some(&me.account_id))`. ZERO search HTTP.
**Trace**: Pass 3 BC-203; BC-1061 (R4)

---

#### BC-3.1.004: `issue assign` is idempotent — already-assigned-to-target → exit 0 + `"changed": false`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:922-965`
**Subject**: Issue write
**Behavior**: `search_assignable_users` returns the user; `get_issue` shows already-assigned matching account_id; NO PUT mock mounted. Wiremock returns 404 for unmounted paths — test passes proving CLI short-circuits before PUT.
**Trace**: Pass 3 BC-204; BC-1062 (R4)

---

#### BC-3.1.005: `issue assign --unassign` PUTs `{accountId: null}`

**Confidence**: MEDIUM
**Source**: `src/cli/issue/workflow.rs::handle_assign`
**Trace**: Pass 3 BC-205

---

#### BC-3.1.006: `--to` ⊕ `--account-id` ⊕ `--unassign` clap conflict (mutually exclusive)

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs:170-211`
**Trace**: Pass 3 BC-206

---

#### BC-3.1.007: `search_assignable_users` returning empty Vec → `Ok(Vec::new())` (NOT Err); handler decides UX

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:856-877`
**Behavior**: Empty result is a caller-level UX error, not a client error.
**Trace**: Pass 3 BC-1060 (R4)

---

#### BC-3.1.008: `assign_issue("ERR-1", Some("bogus-id"))` against 404 → Err + `"does not exist"` message

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1705-1738`
**Behavior**: 404 body `{errorMessages: ["User '...' does not exist."]}` → `JrError::ApiError{status: 404, ..}`; extracted via `extract_error_message`.
**Trace**: Pass 3 BC-1078 (R4)

---

#### BC-3.1.009: `search_assignable_users_by_project(query, projectKey)` GETs `/rest/api/3/user/assignable/multiProjectSearch` (NOT `/user/search`)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1024-1082`
**Behavior**: Uses `projectKeys` AND `query` params. Accepts same FOUR response shapes as `search_users`.
**Trace**: Pass 3 BC-1064 (R4)

---

### 3.2 Move / Transition

#### BC-3.2.001: `issue move <key> <target>` is idempotent when current == target (by status name)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1500-1549`
**Subject**: Issue write
**Behavior**: `get_issue` shows current status == target → exit 0; stderr `"already in status"`; ZERO `POST /transitions` mock fires.
**Trace**: Pass 3 BC-207; BC-1074 (R4); Top-30 BC rank #12

---

#### BC-3.2.002: `issue move <key>` is idempotent via transition-name→status-name resolution too

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1551-1604`
**Subject**: Issue write
**Behavior**: Transition name `"Complete"` → destination status `"Completed"` → already there → short-circuit. stderr `"already in status"`.
**Trace**: Pass 3 BC-1075 (R4)

---

#### BC-3.2.003: `issue move` resolves transition by NAME match (e.g., `"Complete"`)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1219-1276`
**Behavior**: Fetches transitions, resolves `transition.name == "Complete"`, POSTs with `{transition: {id: "21"}}`. stderr: `"Moved FOO-1"`.
**Trace**: Pass 3 BC-1069 (R4)

---

#### BC-3.2.004: `issue move` resolves by STATUS NAME match (e.g., `transition.to.name == "Completed"`)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1278-1335`
**Behavior**: Status NAME match path (distinct from transition-name match). Same POST.
**Trace**: Pass 3 BC-1070 (R4)

---

#### BC-3.2.005: Duplicate candidates (same transition + status name) are de-duplicated; only ONE candidate presented

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1337-1394`
**Behavior**: `transition.name == "Done"` AND `transition.to.name == "Done"` → dedup → one candidate → succeeds.
**Trace**: Pass 3 BC-1071 (R4)

---

#### BC-3.2.006: Ambiguous move → exit non-zero + stderr `"Ambiguous"` + NO POST

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1396-1444`
**Trace**: Pass 3 BC-1072 (R4)

---

#### BC-3.2.007: No-match move → enriched candidate list in stderr: `"Complete (→ Completed)"` format

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1446-1498`
**Behavior**: Transition NAME → status NAME format in error candidates.
**Trace**: Pass 3 BC-1073 (R4)

---

#### BC-3.2.008: `--no-input` single-substring move → exit 64 + `"Ambiguous transition"` + ZERO POST

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1748-1810`
**Behavior**: `mock.expect(0)` on `POST /transitions`. stderr contains `"Ambiguous transition"` AND `"In Progress"`. Exit EXACTLY 64.
**Trace**: Pass 3 BC-1079 (R4)

---

#### BC-3.2.009: `issue move` 400 "resolution required" → `--resolution` hint + `jr issue resolutions` discovery pointer

**Confidence**: HIGH
**Source**: `tests/issue_resolution.rs:88-158`
**Behavior**: 400 body `{errors: {resolution: "Field 'resolution' is required"}}` → stderr contains `--resolution` AND `jr issue resolutions`.
**Trace**: Pass 3 BC-208, BC-209

---

#### BC-3.2.010: `issue resolutions` reads cache-first (7d TTL); JSON: `[{name, id, description}]`

**Confidence**: HIGH
**Source**: `tests/issue_resolution.rs:11-46, 49-86`
**Behavior**: GET `/rest/api/3/resolution`, cached 7 days. Table shows Name + Description. Resolutions without `id` dropped on cache write (+ stderr warning).
**Trace**: Pass 3 BC-210

---

#### BC-3.2.011: `transition_issue(key, id, Some(&fields))` body contains `{transition: {id}, fields: {resolution: {name: "Done"}}}`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:79-103`
**Behavior**: Fields merged alongside transition in body. `expect(1)`.
**Trace**: Pass 3 BC-1039 (R4)

---

#### BC-3.2.012: `transition_issue(key, id, None)` body MUST NOT contain `"fields"` key

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:105-128`
**Behavior**: Negative-serialization pin. `body.contains("\"fields\"") == false`. Atlassian rejects `fields: null`.
**Trace**: Pass 3 BC-1040 (R4)

---

#### BC-3.2.013: `issue move` (single-key) proactively enforces resolution when the target transition is done-category AND offers a resolution field — or is conditional

**Confidence**: HIGH
**Source**: `tests/issue_resolution.rs` (new); `tests/issue_move_resolution_enforce.rs` (new)
**Subject**: Issue write
**Origin**: BROWNFIELD

**Trigger condition**: After calling `GET /rest/api/3/issue/{key}/transitions?expand=transitions.fields` and resolving the target transition (via the existing name/status-name match logic), the enforcement gate fires when ALL of:

- `transition.to.statusCategory.key == "done"` (the stable, lowercase, instance-independent Jira Cloud category constant), AND
- `transition.fields` contains the key `"resolution"` (resolution is on the transition screen) OR `transition.isConditional == true` (hidden validator or condition may require resolution).

**Conservative gate**: If `to.statusCategory` is absent from the API response (expand unavailable or incomplete deserialization), enforcement is SKIPPED. The transition is attempted and BC-3.2.009 (reactive 400 handler) applies as backstop.

**Scope**: Single-key `issue move` only. The bulk transition path does NOT receive proactive enforcement (out of scope; see ADR-0015 rationale).

**Resolution-REQUIRED branch** (`fields.resolution.required == true` OR `isConditional == true`):

- `--resolution <name>` provided → validate name against `transition.fields.resolution.allowedValues` (when present) → set `{resolution: {name: "<name>"}}` in the transition body (same shape as BC-3.2.011) → proceed.
- `--no-resolution` provided → exit 64 (`UserError`) with stderr:
  ```
  error: the "<to_status_name>" transition requires a resolution and --no-resolution cannot be used here.

  Try:
      jr issue move <KEY> <to_status_name> --resolution <name>

  Run `jr issue resolutions` to see available values.
  ```
- Interactive (TTY, `--no-input` absent), no flag → prompt via `dialoguer::Select` listing resolution names from `transition.fields.resolution.allowedValues` (when available) or `load_resolutions(client, false)` (instance-global cache fallback). No "(none — no resolution)" option is offered. On Ctrl+C / prompt failure → exit non-zero.
- Non-interactive (`--no-input` OR stdin not a TTY), no flag → exit 64 (`UserError`) with stderr:
  ```
  error: the "<to_status_name>" transition requires a resolution.

  Try:
      jr issue move <KEY> <to_status_name> --resolution <name>

  Run `jr issue resolutions` to see available values.
  ```

**Resolution-OPTIONAL branch** (`fields.resolution.required == false` AND NOT `isConditional`):

- `--resolution <name>` provided → set `{resolution: {name: "<name>"}}` → proceed.
- `--no-resolution` provided → transition without a `resolution` field in the body (body shape matches BC-3.2.012, no `"fields"` key) → proceed.
- Interactive (TTY, `--no-input` absent), neither flag → prompt via `dialoguer::Select` listing resolution names PLUS a final `"(none — no resolution)"` option. Selecting "(none — no resolution)" proceeds without a resolution body field. On Ctrl+C / prompt failure → exit non-zero.
- Non-interactive (`--no-input` OR stdin not a TTY), neither flag → exit 64 (`UserError`) with stderr:
  ```
  error: the "<to_status_name>" transition offers a resolution field. You must explicitly choose:

      jr issue move <KEY> <to_status_name> --resolution <name>
      jr issue move <KEY> <to_status_name> --no-resolution

  Run `jr issue resolutions` to see available values.
  ```

**Flag constraints**:

- `--resolution` and `--no-resolution` are mutually exclusive (clap conflict). Both present → clap exits with usage error before any HTTP call.
- `--no-resolution` is a new flag introduced by this feature. It has no effect when the enforcement gate does not fire (non-done-category transitions, or conservative-gate fallback) and has no semantics outside of `issue move`.

**Resolution value format**: Always an object (`{resolution: {name: "<name>"}}`), never a bare string, per the Atlassian API requirement (OpenAPI FieldMetadata schema).

**Idempotency**: The existing idempotency check (BC-3.2.001 / BC-3.2.002 — already in target status → exit 0) is preserved and runs BEFORE the enforcement gate. No resolution prompt fires for a no-op move.

**Backstop retained**: BC-3.2.009 (reactive 400 "resolution required" handler) is preserved as a fallback for workflows that enforce resolution via a server-side validator not reflected in the transition screen's `fields` map (conservative gate passes, POST fires, API returns 400).

**Breaking change**: This is a breaking change to `jr issue move` default behavior. Previously, a done-category move with a resolution field silently succeeded with `resolution=null`. After this change, such a move in non-interactive mode exits 64 unless `--resolution` or `--no-resolution` is supplied. A CHANGELOG entry under Breaking Changes is required for the next minor version.

**Edge cases**:

- EC-3.2.013-1: `isConditional == true` with no `resolution` key in `fields` → treated as REQUIRED branch (conservative; the conditional may require resolution that the expand cannot enumerate). Exit 64 / prompt as per REQUIRED branch.
- EC-3.2.013-2: `fields.resolution.allowedValues` is empty or absent → fall back to `load_resolutions(client, false)` (instance-global resolution list) for the prompt menu; resolution name validation skipped when allowedValues is absent.
- EC-3.2.013-3: Resolution name provided via `--resolution` not found in `allowedValues` (when present) → exit 64 listing allowed values (same style as other name-resolution failures).
- EC-3.2.013-4: Transition has `to.statusCategory.key == "done"` but `fields` map is entirely absent (API returned expanded response with no fields key) → enforcement SKIPPED; BC-3.2.009 backstop applies.
- EC-3.2.013-5: Interactive prompt aborted via Ctrl+C → exit 130 (`Interrupted`).
- EC-3.2.013-6: `--resolution` supplied on a non-done-category transition (enforcement gate does not fire) → `--resolution` is forwarded as a fields body parameter exactly as it was pre-BC-3.2.013. BC-3.2.011 behavior.
- EC-3.2.013-7: `--no-resolution` supplied on a non-done-category transition (enforcement gate does not fire) → flag is silently ignored (no HTTP change; the transition body has no resolution field regardless, matching BC-3.2.012).
- EC-3.2.013-8: Bulk `issue move` (multi-key positional or `--to` set) with a done-category target → enforcement gate NOT invoked; bulk path is out of scope. If the API rejects a bulk transition for missing resolution, BC-3.2.009-class per-key error appears.

**Test vectors** (canonical, for test-writer):

| Scenario | Mock transitions response | Flag(s) | Expected exit | Expected stderr |
|---|---|---|---|---|
| REQUIRED, non-interactive, no flag | `statusCategory.key="done"`, `fields.resolution.required=true` | `--no-input` | 64 | contains `"--resolution"` and `"jr issue resolutions"` |
| REQUIRED, `--no-resolution` | same | `--no-resolution` | 64 | contains `"requires a resolution"` and `"--no-resolution cannot be used"` |
| REQUIRED, `--resolution Done` | same, `allowedValues=[{name:"Done",id:"10000"}]` | `--resolution Done` | 0 | contains `"Moved"` |
| OPTIONAL, non-interactive, no flag | `statusCategory.key="done"`, `fields.resolution.required=false` | `--no-input` | 64 | contains `"must explicitly choose"` and `"--no-resolution"` |
| OPTIONAL, `--no-resolution` | same | `--no-resolution --no-input` | 0 | contains `"Moved"` (no fields key in POST body) |
| OPTIONAL, `--resolution Done` | same, `allowedValues=[{name:"Done",id:"10000"}]` | `--resolution Done --no-input` | 0 | contains `"Moved"` (POST body contains `resolution`) |
| `isConditional=true`, non-interactive | `statusCategory.key="done"`, `isConditional=true`, no `resolution` in fields | `--no-input` | 64 | contains `"--resolution"` |
| No `statusCategory` (conservative gate) | `to.name="Done"`, no `statusCategory` key | `--no-input` | 0 | POST fired; BC-3.2.009 backstop in effect |
| Not done-category | `statusCategory.key="indeterminate"` | `--no-input` | 0 | no enforcement; POST fired |
| No `fields` key at all | `statusCategory.key="done"`, no `fields` key | `--no-input` | 0 | conservative gate fires; BC-3.2.009 backstop |

**Trace**: F2 jsm-resolution-required (2026-06-03); API validation: `.factory/research/jsm-resolution-required-api-validation.md`; Delta analysis: `.factory/phase-f1-delta-analysis/jsm-resolution-required/delta-analysis.md`

---

#### BC-3.2.014: Multi-key `issue move` bulk transition POST body nests keys and transitionId inside `bulkTransitionInputs` array wrapper — NOT at top level

**Confidence**: HIGH
**Source**: `src/api/jira/bulk.rs::bulk_transition`; `src/types/jira/bulk.rs::BulkTransitionRequest`; `src/types/jira/bulk.rs::BulkTransitionInput`; `src/cli/issue/workflow.rs::handle_move_bulk`
**Subject**: Issue write
**Origin**: DOCUMENT-AS-IS (correctness bug fix, live run 27156639337)

**Wire schema** — `POST /rest/api/3/bulk/issues/transition` body MUST be:

```json
{
  "bulkTransitionInputs": [
    {
      "selectedIssueIdsOrKeys": ["K1", "K2", ...],
      "transitionId": "<id>"
    }
  ],
  "sendBulkNotification": false
}
```

**Invariants**:

1. `selectedIssueIdsOrKeys` and `transitionId` are fields of an object **inside** the `bulkTransitionInputs` array — they are NEVER top-level fields of the request body.
2. `bulkTransitionInputs` is always a JSON array containing exactly **one** entry for a given `jr issue move` invocation: all supplied keys share the same single `BulkTransitionInput` object.
3. `transitionId` is resolved from the FIRST key in the supplied set via `GET /rest/api/3/issue/{first_key}/transitions` and is applied to all keys in that same single entry.
4. `sendBulkNotification` is always `false` (mirrors the bulk-edit default).
5. The flat body shape `{ "selectedIssueIdsOrKeys": [...], "transitionId": "..." }` (without the `bulkTransitionInputs` wrapper) is INVALID; live Jira Cloud returns HTTP 400 "bulkTransitionInputs must not be empty". This flat shape was the pre-fix bug body (fixed in commit acca854).
6. Same-workflow assumption: all keys are expected to share the same workflow and therefore the same transition is valid for all. Cross-workflow keys with a differing transition availability are a pre-existing limitation (out of scope); no guard fires — the API may reject individual keys in the task results.
7. After the POST, `jr` polls `GET /rest/api/3/bulk/queue/{taskId}` until a terminal status (COMPLETE, FAILED, CANCELLED, DEAD) and renders per-key results. Same polling and rendering path as bulk edit (BC-3.4.005).

**Edge cases**:

- EC-3.2.014-1: Only one key in the positional list (degenerate bulk invocation, dispatched from `handle_move_bulk`) — the `bulkTransitionInputs` array still has one entry with a one-element `selectedIssueIdsOrKeys` array; POST body shape is identical.
- EC-3.2.014-2: `sendBulkNotification: false` — must be present in all serialized bodies; absence would use the Jira default (true), which would send notifications for potentially many issues. This field is always serialized because `BulkTransitionRequest.send_bulk_notification: bool` has no `#[serde(skip_serializing_if)]`.
- EC-3.2.014-3: `transitionId` is a string in the JSON body (not a number), even though Jira transition IDs are numeric in the GET response. The `BulkTransitionInput.transition_id: String` field serializes with `#[serde(rename_all = "camelCase")]` to `"transitionId"` as a JSON string value. Sending a number would violate the OpenAPI spec and may be rejected.
- EC-3.2.014-4: Proactive resolution enforcement (BC-3.2.013) is NOT applied on the bulk path; bulk `issue move` with a done-category target proceeds unconditionally. The reactive BC-3.2.009 backstop (400 "resolution required" per-key error in the poll results) is the only safeguard. Pre-filtering with `jr issue list --jql "... AND status != \"<target>\""` is recommended for done-category bulk moves.

**Test vectors** (canonical, for test-writer):

| Scenario | Keys | POST body assertion | Expected exit |
|---|---|---|---|
| Three keys, "Done" target | `["BAR-10","BAR-11","BAR-12"]` | `bulkTransitionInputs[0].selectedIssueIdsOrKeys == ["BAR-10","BAR-11","BAR-12"]`, `transitionId == "31"`, `sendBulkNotification == false` | 0 |
| Flat body shape (regression) | any | `body_string_contains("bulkTransitionInputs")` fails → mock not matched → wiremock `.expect(1)` fires | N/A (red gate) |

**Trace**: F2 fix-bulk-transition-schema (2026-06-08, commit acca854); wiremock regression: `tests/issue_bulk.rs::test_move_multikey_bulk_transition_uses_bulktransitioninputs_wrapper`; pre-existing wiremock: `tests/issue_bulk.rs::test_move_multi_key_issues_one_bulk_transition_post_then_polls`; live E2E: `tests/e2e_live.rs::test_e2e_issue_move_multikey_bulk` (live run 27156639337)

---

### 3.3 Create

#### BC-3.3.001: `issue create` POSTs `/rest/api/3/issue` returning `{"key": "FOO-123"}`

**Confidence**: HIGH
**Source**: `tests/issue_create_json.rs` (integration tests covering create body shape, field combinations, and JSON output)
**Subject**: Issue write
**Behavior**: Body includes summary, project, issuetype, optional priority, labels, description (ADF), team UUID, story points. Output JSON: `{"key": "FOO-123"}`.

> **[UPDATED 2026-05-18 issue #288; amended 2026-05-19 issue #383]** The platform endpoint behavior described above applies ONLY when `--request-type` is absent. When `--request-type` is present, dispatch is to `POST /rest/servicedeskapi/request` instead (see BC-3.8.001). The POST body, JSON response, and exit code on the platform path are unchanged by these additions; however, when `--field` or `--on-behalf-of` are supplied without `--request-type`, the platform path now emits stderr warnings (see BC-3.8.012, BC-3.8.013) — so the platform path is not fully unmodified in observable behavior post-#383.
> **Previous (pre-#288):** This BC stated unconditionally that `issue create` always POSTs to `/rest/api/3/issue`. After #288 that invariant becomes conditional: platform endpoint when `--request-type` absent; JSM endpoint when `--request-type` present.

**Trace**: Pass 3 BC-211

---

#### BC-3.3.002: `issue create` with assignee — uses `search_assignable_users_by_project` (multiProjectSearch)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1024-1082`
**Behavior**: Full body partial-match: `{project: {key}, issuetype: {name}, summary, assignee: {accountId}}`. Response 201 with `key: "FOO-99"`.
**Trace**: Pass 3 BC-1064 (R4)

---

#### BC-3.3.003: `issue create --to me` uses `get_myself()` (no search HTTP)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1084-1127`
**Trace**: Pass 3 BC-1065 (R4)

---

#### BC-3.3.004: `issue create` WITHOUT assignee — body has `{project, issuetype, summary}` ONLY (no assignee key)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1129-1154`
**Trace**: Pass 3 BC-1066 (R4)

---

#### BC-3.3.005: `issue create` assignee-not-found → stops short of create (NO POST mock)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1156-1180`
**Trace**: Pass 3 BC-1067 (R4)

---

#### BC-3.3.006: `issue create --account-id <id>` skips user search entirely

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1182-1217`
**Behavior**: Body has `assignee: {accountId: "direct-acct-789"}` directly.
**Trace**: Pass 3 BC-1068 (R4)

---

#### BC-3.3.007: `--to` and `--account-id` clap conflict on `issue create`

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs:215-235`
**Trace**: Pass 3 BC-224

---

#### BC-3.3.008: `issue create --markdown -d '...'` converts markdown to ADF before POST

**Confidence**: MEDIUM
**Source**: `tests/issue_create_json.rs`
**Trace**: Pass 3 BC-212

---

#### BC-3.3.009: `create_issue` browse URL uses `client.instance_url()` (NOT `client.base_url()`)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1606-1644`
**Behavior**: Integration test constructs URL via `client.instance_url()`. Cross-references BC-3.4.001 (NFR-R-B bug).
**Trace**: Pass 3 BC-1076 (R4)

---

### 3.4 Edit and Open

#### BC-3.4.001: `handle_open` MUST compose URL as `<instance_url>/browse/<key>` using `client.instance_url()` [MUST-FIX: NFR-R-B]

**Confidence**: HIGH
**Source**: `src/cli/issue/workflow.rs:636` (BUG SITE: currently uses `client.base_url()`)

> **MUST-FIX (HIGH — NFR-R-B):** Current code at line 636 uses `client.base_url()` which
> returns `api.atlassian.com/ex/jira/<cloudId>` for OAuth profiles — not a valid browse URL.
> This contract describes the FIXED behavior.

**Spec contract (fixed behavior):**
URL is composed as `format!("{}/browse/{}", client.instance_url(), key)`. `client.instance_url()` returns the real `*.atlassian.net` URL even for OAuth profiles. Fix is one line.

**Effects**: `issue open` and `issue open --url-only` produce correct browse URLs for OAuth users.
**Holdout:** H-046 — `jr issue open FOO-1` uses instance URL, not API gateway URL.
**Trace**: Pass 3 BC-220; NFR-R-B; BC-1010 (R4)

---

#### BC-3.4.002: `issue open --url-only` prints URL to stdout (no browser launch)

**Confidence**: MEDIUM
**Source**: Pass 2 §2b.1
**Trace**: Pass 3 BC-221

---

#### BC-3.4.003: `issue edit` PUTs `/rest/api/3/issue/<key>` with ADF description; accepts 204

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:609-645`
**Behavior**: Body partial-match pins full ADF doc shape: `{fields: {description: {version:1, type:"doc", content[0]: {type:"paragraph", ...}}}}`.
**Errors**: When `edit --type X` returns HTTP 400, the error path is further classified — see BC-3.4.010 (cross-hierarchy mismatch → `CROSS_HIERARCHY_HINT`) and BC-3.4.011 (same-hierarchy or indeterminate → typo hint or raw error). The primary success path (PUT 204) and ADF description behavior are byte-for-byte unchanged.
**Success output**: On the single-key success path (PUT 204), see BC-3.4.012 (table-mode success: one stderr line per changed field in `field → value` format) and BC-3.4.013 (JSON-mode success: `edit_response` extended with `changed_fields` map). This contract specifies only the PUT wire contract; BC-3.4.012 and BC-3.4.013 govern the confirmation output layer.
**Trace**: Pass 3 BC-1055 (R4)

> **[UPDATED 2026-05-20 issue #388]** Errors cross-reference added for `edit --type` 400 enrichment paths (BC-3.4.010, BC-3.4.011). No behavioral change to this contract.

> **[UPDATED 2026-05-21 issue #398]** Success output cross-reference added for changed-fields echo (BC-3.4.012, BC-3.4.013). No behavioral change to the PUT wire contract.

> **[UPDATED 2026-05-22 issue #396]** `--field NAME=VALUE` extension cross-reference added: BC-3.4.015 (string/number/date/datetime/user field single-key path), BC-3.4.016 (single-select option field), BC-3.4.017 (multi-key/--jql rejection + flag-overlap guard). These BCs extend the `handle_edit` execution path but do not change the PUT wire contract specified here.

---

#### BC-3.4.004: `issue edit` with `markdown_to_adf("**bold text**")` → ADF marks `[{type: "strong"}]` on wire

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:647-687`
**Trace**: Pass 3 BC-1056 (R4)

---

#### BC-3.4.005: `issue edit` with multiple fields sends both in body simultaneously

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:689-727`
**Trace**: Pass 3 BC-1057 (R4)

---

#### BC-3.4.006: `issue edit --label add:foo --label remove:bar` interprets prefix and emits correct JSON wire shape

**Confidence**: HIGH
**Source**: `tests/issue_bulk.rs`; `tests/issue_bulk_pr2.rs`; `src/cli/issue/edit.rs::build_labels_edited_fields`; `src/cli/issue/edit.rs` inline `#[cfg(test)] mod build_labels_proptests`
**Behavior**: `add:` and `remove:` prefixes adjust existing labels; bare label replaces.
The label JSON builder (`build_labels_edited_fields`) ALWAYS produces `{"labelsFields": [...]}` —
top-level key is `labelsFields`, inner action key is `bulkEditMultiSelectFieldOption`. The `labelsFields`
array ALWAYS contains element objects; there is NO object-form vs array-form dichotomy.
`labelsAction` and a bare top-level `labels` key NEVER appear — those keys were from a stale spec
superseded by issue #446 schema verification.

Wire shape (single-action ADD only):
```json
{
  "labelsFields": [
    {"fieldId":"labels","bulkEditMultiSelectFieldOption":"ADD","labels":[{"name":"foo"}]}
  ]
}
```

Wire shape (both ADD and REMOVE — coalesced into a single bulk POST):
```json
{
  "labelsFields": [
    {"fieldId":"labels","bulkEditMultiSelectFieldOption":"ADD","labels":[{"name":"foo"}]},
    {"fieldId":"labels","bulkEditMultiSelectFieldOption":"REMOVE","labels":[{"name":"bar"}]}
  ]
}
```

**Invariants**:
1. The ADD element appears in `labelsFields` if and only if `adds` is non-empty.
2. The REMOVE element appears in `labelsFields` if and only if `removes` is non-empty.
3. The caller bails on empty inputs — at least one of ADD or REMOVE is always present when `build_labels_edited_fields` is invoked.
4. When both ADD and REMOVE entries are present, the ADD element precedes the REMOVE element.

**Confidence rationale**: HIGH — verified against Atlassian Bulk Operations FAQ (issue #446);
proptest `build_labels_edited_fields_invariants` in `src/cli/issue/edit.rs` module `build_labels_proptests`
covers all four invariants against the real `labelsFields`/`bulkEditMultiSelectFieldOption` schema.
The shape documented here agrees with BC-3.4.020 Path B (which was verified against live Jira E2E run
26730687481).

**Trace**: Pass 3 BC-213; issue #345; issue #446 (schema fix: labelsFields/bulkEditMultiSelectFieldOption replaces stale labelsAction shape); S-345

---

#### BC-3.4.007: `--description` and `--description-stdin` clap conflict

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs:34-48`
**Trace**: Pass 3 BC-214

---

#### BC-3.4.008: `--points X` and `--no-points` clap conflict

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs:280-287`
**Trace**: Pass 3 BC-215

---

#### BC-3.4.009: outer-loop deadline check MUST include `task_id` literal in stderr message

**Confidence**: HIGH
**Source**: issue #340 + PR #360; `src/api/jira/bulk.rs:408-418` (`[deadline:bulk-outer]` site); `tests/bulk_deadline_propagation.rs`
**Subject**: Issue write (bulk edit path)
**Behavior**: When `await_bulk_task_inner`'s top-of-loop deadline check fires (i.e., the
bulk task remained non-terminal until the caller-supplied wall-clock deadline expired),
the `JrError::DeadlineExceeded` error message emitted to stderr MUST contain the literal
value of `task_id` AND the site tag `[deadline:bulk-outer]`. The message format is:
`"[deadline:bulk-outer] Bulk task <task_id> did not complete within <N>s timeout. Check Jira for task status."`
This allows the user to recover manually by inspecting the task directly at
`jr api /rest/api/3/bulk/queue/<task_id>`.

**Scope**: This contract applies exclusively to the outer-loop deadline site
(`[deadline:bulk-outer]` tag at `src/api/jira/bulk.rs:408-418`). It does NOT extend to
inner-loop deadline exits (`[deadline:429-retry]` in `JiraClient::send_inner`,
`src/api/client.rs:585-600`), because `task_id` is not in scope at those sites and
plumbing it through `send_inner` would require a non-trivial cross-module signature
change. Out-of-scope deferral noted; if a future enhancement adds `task_id` to the
client layer, a sibling BC SHOULD be created to cover that site.
**Effects**: Exit code 124 (`JrError::DeadlineExceeded`). Stderr contains the `task_id` value.
**Invariants**: The `task_id` value in the message MUST match the `taskId` returned by the
initial bulk POST response. It MUST pass `validate_task_id` before insertion (CWE-117
log-injection guard — audited in PR #355).
**VP Extension**: Extends `BC-bulk.poll.deadline-bounded` (issue-333 working label) —
adds the requirement that `task_id` appears in the stderr output in addition to the
existing wall-clock bound and `"deadline"` substring assertions.
**Trace**: issue #340 AC #1; `src/api/jira/bulk.rs::await_bulk_task_inner` (`[deadline:bulk-outer]` site)

---

#### BC-3.4.010: `issue edit KEY --type X` HTTP 400 + cross-hierarchy subtask-flag mismatch → exit 1, `CROSS_HIERARCHY_HINT` on stderr (JRACLOUD-27893)

**Confidence**: HIGH
**Source**: `tests/issue_edit_type_errors.rs` (integration tests — cross-hierarchy direction paths); `src/cli/issue/edit.rs::is_cross_hierarchy_type_error` (pure classifier helper); `src/cli/issue/edit.rs::CROSS_HIERARCHY_HINT` (shared constant); `src/cli/issue/edit.rs` inline `#[cfg(test)] mod is_cross_hierarchy_type_error_proptests` proptest for `is_cross_hierarchy_type_error`
**Subject**: Issue write
**Behavior**: When `edit_issue` returns HTTP 400 AND `is_cross_hierarchy_type_error(src_subtask, tgt_subtask, err)` returns `CrossHierarchy` (i.e., both `src_subtask` and `tgt_subtask` are `Some(a)` and `Some(b)` with `a != b`, covering both standard→sub-task and sub-task→standard directions), the CLI exits 1 and emits `CROSS_HIERARCHY_HINT` on stderr. The hint wording is pinned verbatim:

```
The Jira Cloud REST API does not support changing the standard / sub-task hierarchy level via this endpoint (see JRACLOUD-27893). To convert it, open the issue in the Jira web UI and use the action menu to find the Convert option.
```

This shared constant is also emitted on the `--no-parent` subtask-bound 400 path (gated by `no_parent && is_subtask_parent_error` in `handle_edit`). On the `--no-parent` path, the caller MUST prepend the following verbatim context sentence before the shared constant:

```
Sub-tasks are structurally bound to a parent; clearing it requires converting the sub-task to a standard issue.
```

On the `edit --type` path, the constant is emitted directly with no prepended sentence. The neutral framing ("does not support changing the...hierarchy level via this endpoint") accurately describes both call sites — neither requires the word "Converting" which would mis-describe the `--no-parent` case.

**Preconditions**:
- Single-key `jr issue edit KEY --type X` is issued (multi-key bulk path is unaffected by this contract).
- `edit_issue` (PUT `/rest/api/3/issue/<key>`) returns HTTP 400. **HTTP-400 gate**: the caller (`handle_edit`) observes this by downcasting `edit_issue`'s `anyhow::Error` to `JrError::ApiError { status: 400, .. }` (constructed at `src/api/client.rs::parse_error` ~lines 973-997, defined in `src/error.rs`). If `edit_issue` fails with a non-400 error (401, 403, 5xx, network error, etc.), NO enrichment occurs — the raw error is surfaced unchanged and neither BC-3.4.010 nor BC-3.4.011 enrichment applies. The error-enrichment block is entered only on `status == 400`. Note: a non-400 `edit_issue` error (R0b routing row) bypasses both BC-3.4.010 and BC-3.4.011 entirely; see test #10 (`test_edit_type_non_400_edit_error_surfaces_raw_error_no_enrichment`).
- **Call ordering**: `handle_edit` calls `get_issue` FIRST (it supplies both the source `issuetype.subtask` flag and `fields.project.key`). Only if `get_issue` succeeds is `get_project_issue_types(project_key)` called. Therefore: a `get_issue` failure → Indeterminate immediately (the second call never executes); the unresolvable-name sub-path is reachable only when `get_issue` already succeeded and returned HTTP 200.
- `get_issue` uses the full `BASE_ISSUE_FIELDS` projection (which includes `"issuetype"`). The Atlassian Jira Cloud REST API v3 returns the complete `IssueType` object — including the `subtask` boolean and `hierarchyLevel` — as a nested field within any projected `issuetype` field. The `fields=` query parameter filters top-level issue fields, NOT nested properties of a returned field. Therefore `get_issue` (with `issuetype` in `BASE_ISSUE_FIELDS`) returns the `subtask` sub-field reliably. The `subtask` field is carried in `IssueType` (the struct at `fields.issuetype` in the `Issue` response from `get_issue`); this is the struct that receives the additive `subtask: Option<bool>` field in issue #388 (F4 implementation, not yet in the codebase at F2 spec time).
- **`Option<IssueType>` outer-layer flatten**: `issue.fields.issuetype` in `src/types/jira/issue.rs:62` is `Option<IssueType>` (the whole issuetype object may be absent from the response). `IssueType.subtask` is itself `Option<bool>`. The caller MUST flatten both layers: `issue.fields.issuetype.as_ref().and_then(|t| t.subtask)`. Two distinct sources of `src_subtask: None` exist: (a) the `issuetype` object is wholly absent from the response `fields` — `Option<IssueType>` is `None`; (b) `issuetype` is present but its `subtask` key is omitted from the JSON — `IssueType.subtask` is `None`. Both (a) and (b) collapse to `src_subtask: None` → Indeterminate via the and_then flatten.
- **`get_project_issue_types` deserialization behavior (net-new lookup)**: The type-name lookup against `get_project_issue_types` is **net-new F4 logic** built inside `handle_edit`'s error path — it does not pre-exist. `get_project_issue_types` calls `GET /rest/api/3/project/{key}`, extracts `issueTypes`, and deserializes via `.and_then(|v| from_value::<Vec<IssueTypeMetadata>>(v).ok()).unwrap_or_default()` (live code, `src/api/jira/projects.rs:47-51`). A 200 response with a malformed or missing `issueTypes` key returns `Ok(vec![])` — NOT an `Err`. Therefore deserialization failure is NOT an Indeterminate-trigger; only an HTTP error or network error causes `get_project_issue_types` to return `Err` (→ Indeterminate). A 200 with an unparseable body yields `Ok([])` → the target name is absent from an empty list → the **unresolvable-name sub-path** (typo hint), NOT Indeterminate. This graceful outcome is acceptable: a malformed project-metadata response is rare and the typo hint is not harmful. The client-side name lookup uses **case-insensitive exact match** on the `name` field — this is a deliberate choice for the error-enrichment path and may not perfectly mirror Jira's server-side resolution, but divergence only affects which hint is shown, never edit correctness.
- `is_cross_hierarchy_type_error(src_subtask, tgt_subtask, err)` returns `CrossHierarchy`: both arguments are `Some(_)` and the inner boolean values differ (`src != tgt`).

**Postconditions**:
- Exit code 1.
- Stderr contains the verbatim `CROSS_HIERARCHY_HINT` string:
  ```
  The Jira Cloud REST API does not support changing the standard / sub-task hierarchy level via this endpoint (see JRACLOUD-27893). To convert it, open the issue in the Jira web UI and use the action menu to find the Convert option.
  ```
- Stderr contains the literal `JRACLOUD-27893`.
- Stderr does NOT contain the substring `jr api /rest/api/3/issue` (regression pin unique to the removed fake `PUT /rest/api/3/issue/{key}/convert` hint at `src/cli/issue/edit.rs::handle_edit` §"--no-parent 400 path" (historical: code relocated from pre-split `create.rs` to `edit.rs`); the exact prior hint text was `jr api /rest/api/3/issue/{key}/convert -X put -d '{"type":{"name":"Task"}}'`; the pin substring `jr api /rest/api/3/issue` uniquely identifies this removed fake-endpoint hint without over-matching the broader `/rest/api/3/issue/` path fragment which may legitimately appear in other diagnostics).
- Stdout is empty (no JSON output for this error path).

**Invariants**:
1. The subtask-flag mismatch via `is_cross_hierarchy_type_error(src_subtask: Option<bool>, tgt_subtask: Option<bool>, err: &str) -> Classification` is the PRIMARY classifier — locale-independent. The pure function returns `CrossHierarchy` only when both arguments are `Some(_)` and differ. The English substring `"issue type selected is invalid"` MUST NOT be used as the sole gate (it fires on plain typos; see research addendum A1).
2. `CROSS_HIERARCHY_HINT` is a shared named constant referenced identically from this path and from the `--no-parent` subtask-bound 400 path (gated by `no_parent && is_subtask_parent_error` in `src/cli/issue/edit.rs::handle_edit`). Bug fix: replaces the prior fake `PUT /rest/api/3/issue/{key}/convert` hint. On the `--no-parent` path, the caller MUST prepend the following verbatim context sentence before the shared constant:

```
Sub-tasks are structurally bound to a parent; clearing it requires converting the sub-task to a standard issue.
```

On the `edit --type` path, the constant is emitted directly with no prepended sentence. The context sentence frames conversion as the means to clear the parent and leads directly into the shared `CROSS_HIERARCHY_HINT`.
3. This contract applies to SINGLE-KEY edit only. The bulk `--type` path (`handle_edit_bulk_fields`) does NOT include this enrichment and must not be modified.

> **Wording note (not a runtime contract):** The word "sub-task" is spelled with a hyphen throughout all hint strings in this BC (not "subtask" without hyphen). This is a spec-drafting convention for the pinned hint strings above; it is not enforced by any test and does not produce observable CLI behavior distinct from a non-hyphenated spelling.

**Deliberate gate asymmetry (m-4)**: The `edit --type` arm enters the enrichment block via a structured downcast: `edit_issue`'s `anyhow::Error` downcasts to `JrError::ApiError { status: 400, .. }` (per `src/error.rs`). The `--no-parent` arm uses the legacy string-based gate `is_subtask_parent_error(&anyhow::Error)` to decide whether to emit the prepended context sentence + `CROSS_HIERARCHY_HINT`. This asymmetry is deliberate: migrating `is_subtask_parent_error` to a structured downcast is explicitly out of #388 scope per KL-3.4.010-1 below — both gates reach the same shared constant, but via distinct mechanisms that were intentionally left unchanged.

**`--no-parent` hint replacement scope (CRITICAL)**: The ENTIRE prior `--no-parent` hint block at `src/cli/issue/edit.rs::handle_edit` (block relocated from pre-split `create.rs` to `edit.rs`) is replaced. The prior block consisted of a multi-line `format!` followed by a separate `bail!` statement. The prior `format!` contained FOUR sentences: "Tip: subtasks are structurally bound…", "To clear the parent, first convert…", the fake `jr api /rest/api/3/issue/{key}/convert -X put -d '{"type":{"name":"Task"}}'` line, and "(then re-run with --no-parent if needed.)". NONE of these four old sentences are retained. The new block is exactly: the verbatim context sentence below (prepended first), followed immediately by `CROSS_HIERARCHY_HINT` — and nothing else.

**`--no-parent` path postcondition (M-1)**: When `no_parent && is_subtask_parent_error` fires (the `--no-parent` subtask-bound 400 path), stderr MUST contain:
1. The verbatim context sentence `Sub-tasks are structurally bound to a parent; clearing it requires converting the sub-task to a standard issue.` (prepended before the shared constant).
2. The verbatim `CROSS_HIERARCHY_HINT` string (containing `JRACLOUD-27893`).
3. The literal `JRACLOUD-27893`.
4. NOT the substring `jr api /rest/api/3/issue` (regression pin on removed fake-endpoint hint; the removed fake hint was `jr api /rest/api/3/issue/{key}/convert -X put -d '{"type":{"name":"Task"}}'` — the pin substring uniquely identifies this removed text).

This postcondition is verified by **T-06 in `tests/issue_edit_no_parent.rs`** (`test_subtask_parent_clear_surfaces_400_with_convert_hint`), NOT by the `issue_edit_type_errors.rs` test set (tests #1/#2/#5 in that file cover the `edit --type` path only).

**`--type` + `--no-parent` dual-gate precedence**: `--type` and `--no-parent` are NOT mutually exclusive in clap — there is NO `conflicts_with` annotation between `issue_type` and `no_parent` on the `IssueCommand::Edit` variant (confirmed in `src/cli/mod.rs` lines 437-459). Both flags can be supplied simultaneously. If both are set and `edit_issue` returns HTTP 400, both the `--type` cross-hierarchy enrichment arm and the `--no-parent` arm could have satisfied preconditions. The deterministic evaluation order in `handle_edit`'s `if let Err(ref e) = edit_result` block MUST be: the `--type` cross-hierarchy enrichment is evaluated FIRST (invoking `get_issue` → `get_project_issue_types` → `is_cross_hierarchy_type_error`); only if it does NOT emit a hint (i.e., the classification is SameCategory or Indeterminate and no hint was shown) does the `--no-parent` arm evaluate. This ordering ensures the more-specific cross-hierarchy diagnosis takes precedence over the legacy string-match gate.

**Known Limitations**:
- KL-3.4.010-1: The `--no-parent` arm's hint emission is gated by `is_subtask_parent_error`, which is a disjunctive English-substring matcher: `msg.contains("subtask") || (msg.contains("parent") && msg.contains("400"))`. The locale-fragility risk differs by disjunct: the first disjunct (`"subtask"`) is an English word and will miss the error on non-English Jira instances; the second disjunct (`"parent"` + `"400"`) is partially locale-robust because `"400"` is a locale-independent HTTP status token, but `"parent"` is still English and may not appear in non-English error messages. Both disjuncts are inherited from the pre-#388 `is_subtask_parent_error` implementation. This is a deliberate scope boundary for issue #388 — modifying `is_subtask_parent_error`'s locale resilience is not part of this delta and is not a regression introduced here.

**Edge Cases**:
- EC-3.4.010-1: standard→sub-task direction (source `subtask: false`, target `subtask: true`) → same hint, same exit code.
- EC-3.4.010-2: sub-task→standard direction (source `subtask: true`, target `subtask: false`) → same hint, same exit code.
- EC-3.4.010-3: The English error substring `"issue type selected is invalid"` is present in the 400 body but the flags DO match (same hierarchy, typo scenario) → hint MUST NOT fire; this is the BC-3.4.011 SameCategory path.

**Trace**: issue #388 F2; `src/cli/issue/edit.rs::is_cross_hierarchy_type_error`; `src/cli/issue/edit.rs::CROSS_HIERARCHY_HINT`; `src/cli/issue/edit.rs` inline `#[cfg(test)] mod is_cross_hierarchy_type_error_proptests` proptest for `is_cross_hierarchy_type_error`; `tests/issue_edit_type_errors.rs` (integration — cross-hierarchy direction paths)

---

#### BC-3.4.011: `issue edit KEY --type X` HTTP 400 + same-hierarchy flags OR indeterminate resolution → exit 1, typo hint or raw error (no JRACLOUD-27893 hint)

**Confidence**: HIGH
**Source**: `tests/issue_edit_type_errors.rs` (integration tests — same-hierarchy typo path, indeterminate paths); `src/cli/issue/edit.rs::is_cross_hierarchy_type_error` (pure classifier — `SameCategory` and `Indeterminate` return paths); `src/cli/issue/edit.rs` inline `#[cfg(test)] mod is_cross_hierarchy_type_error_proptests` proptest for `is_cross_hierarchy_type_error` (primary verification for classifier properties); `src/cli/issue/edit.rs::handle_edit` (caller: unresolvable name → typo hint; fetch-failure → `Indeterminate`)
**Subject**: Issue write
**Behavior**: When `edit_issue` returns HTTP 400 (observed by downcasting to `JrError::ApiError { status: 400, .. }` — constructed at `src/api/client.rs::parse_error` ~lines 973-997, defined in `src/error.rs`) AND `is_cross_hierarchy_type_error(src_subtask, tgt_subtask, err)` does NOT return `CrossHierarchy`, the CLI exits 1 without emitting `CROSS_HIERARCHY_HINT`. If `edit_issue` fails with a non-400 error (401, 403, 5xx, network error, etc.), NO enrichment occurs — the raw error is surfaced unchanged and neither BC-3.4.010 nor BC-3.4.011 enrichment applies; this is the R0b routing row tested by test #10. Three distinct sub-paths apply (all require the HTTP-400 gate to have fired):

**Indeterminate fetch-failure detection — `is_err()` gate, NOT a status downcast**: The `handle_edit` enrichment-fetch failure gate is `Result::is_err()` on the `get_issue` / `get_project_issue_types` call — ANY `Err` variant triggers Indeterminate, regardless of the underlying error variant. This is deliberately distinct from the HTTP-400 gate on `edit_issue`'s error, which IS a structured downcast to `JrError::ApiError { status: 400, .. }` (because `edit_issue`'s 400 does become `ApiError` via `parse_error`). An implementer who detects the Indeterminate fetch-failure by "downcast the enrichment-fetch error to `JrError::ApiError` and check status" would MISS 401s and other non-ApiError variants. Specifically: `get_issue` returning HTTP 401 does NOT produce `JrError::ApiError` — it produces `JrError::NotAuthenticated` or `JrError::InsufficientScope` (per `src/api/client.rs::parse_error` ~lines 973-997 which dispatches 401 to these variants, not `ApiError`). The `is_err()` gate catches all `Err` variants uniformly. The two gate mechanisms are deliberately different and must not be conflated.

**Unresolvable-name sub-path (SameCategory outcome, caller-side)** — `handle_edit` resolves the target type name `X` against the project's issue-type list BEFORE invoking the pure classifier. If `get_project_issue_types` returns HTTP 200 with a non-empty list that simply does not contain the requested name `X` (i.e., a typo'd or wrong type name), `handle_edit` emits the typo hint directly and never calls the classifier:
- Emit the pinned typo hint on stderr:

```
Jira rejected the type change. If the type name is wrong, run `jr project types` to list valid types; the change may also be blocked by workflow or scheme constraints.
```

- Surface the `extract_error_message`-processed 400 message text carried in `JrError::ApiError.message` on stderr (this is the extracted message only — e.g., `issuetype: The issue type selected is invalid.`; the raw JSON envelope such as `{"errors": {...}}` is NOT surfaced because `JiraClient::parse_error` in `src/api/client.rs` runs `extract_error_message()` on the response bytes before constructing `JrError::ApiError.message`; `extract_error_message` is `sanitize_for_stderr(extract_error_message_raw(body))` per `src/api/client.rs:1481` — for plain-ASCII message text, `sanitize_for_stderr` is a no-op, so test substrings from plain-ASCII extracted text are safe; test assertions MUST use plain-ASCII substrings, not control characters or multibyte sequences). When asserting this in tests (#3), choose a substring from the EXTRACTED message (e.g., `The issue type selected is invalid` survives extraction; `{"errors"` or `"issuetype":` as raw JSON keys do not).
- `CROSS_HIERARCHY_HINT` (containing `JRACLOUD-27893`) MUST NOT appear on stderr.
- The pure classifier (`is_cross_hierarchy_type_error`) is NOT invoked on this path.

**SameCategory sub-path (classifier-side)** — `get_project_issue_types` succeeds and the target name IS found; `is_cross_hierarchy_type_error` returns `SameCategory`: both `src_subtask` and `tgt_subtask` are `Some(_)` and the inner boolean values are equal. This covers valid type names rejected by workflow or scheme constraints (a valid type name rejected because the target workflow lacks the issue's current status). The enrichment lookup that determines whether the name IS found uses **case-insensitive exact match on the issue-type `name` field** (so the enrichment verdict agrees with how Jira server-side resolves the type name; partial_match substring matching MUST NOT be used, which could mis-resolve ambiguous type names):
- Emit the same pinned typo hint on stderr (verbatim above).
- Surface the `extract_error_message`-processed 400 message text carried in `JrError::ApiError.message` on stderr (same extraction semantics as the unresolvable-name sub-path above — `sanitize_for_stderr(extract_error_message_raw(body))` is effectively a no-op for plain-ASCII text; assert a plain-ASCII substring from the extracted message in tests (#4), not raw JSON envelope keys).
- `CROSS_HIERARCHY_HINT` (containing `JRACLOUD-27893`) MUST NOT appear on stderr.

**Indeterminate sub-path** — `is_cross_hierarchy_type_error` returns `Indeterminate`. This occurs in two distinct ways:
1. **Either enrichment fetch fails** (Cause-1): `get_issue` OR `get_project_issue_types` returns `Err` — detected by `Result::is_err()` on the call result. ANY `Err` variant triggers Indeterminate: `JrError::NotAuthenticated` (e.g., a `get_issue` 401), `JrError::InsufficientScope` (a `get_issue` 403 scope failure), `JrError::ApiError { status: 5xx, .. }`, network errors, and all other `Err` variants. The `handle_edit` caller does NOT downcast or inspect the error variant — `is_err()` is the gate. NOTE: a 200 response with a malformed `issueTypes` body is NOT a fetch failure — `get_project_issue_types` returns `Ok(vec![])` in that case (due to `.and_then(|v| from_value::<Vec<IssueTypeMetadata>>(v).ok()).unwrap_or_default()` in `src/api/jira/projects.rs:47-51`), which routes to the unresolvable-name sub-path (typo hint), NOT Indeterminate. Indeterminate via Cause-1 requires an actual `Err`, not a 200 with malformed body.
2. **A fetch succeeds but the `subtask` field is absent** (Cause-2): `get_issue` or `get_project_issue_types` returns HTTP 200, but the `issuetype.subtask` field is missing (`None`) after deserialization (field omitted by Jira). The pure classifier `is_cross_hierarchy_type_error(None, _, _)` or `is_cross_hierarchy_type_error(_, None, _)` returns `Indeterminate`. Note: for the source-issue side, Cause-2 also covers the case where the `issuetype` object is wholly absent (`Option<IssueType>` is `None`), because `issue.fields.issuetype.as_ref().and_then(|t| t.subtask)` produces `None` for both a missing issuetype and a present-but-subtask-absent issuetype.

On either Indeterminate cause:
- Surface the `extract_error_message`-processed 400 message text carried in `JrError::ApiError.message` on stderr with NO enrichment hint. When asserting this in tests (#6, #7), choose a substring from the extracted message, not raw JSON envelope keys.
- Neither the cross-hierarchy hint (`CROSS_HIERARCHY_HINT`) nor the typo/workflow hint is emitted.
- Exit code 1.

**Preconditions**:
- Single-key `jr issue edit KEY --type X` is issued.
- `edit_issue` returns HTTP 400. (If `edit_issue` fails with a non-400 error, no enrichment occurs — see R0b routing row / test #10.)
- **Call ordering**: `handle_edit` calls `get_issue` FIRST. Only if `get_issue` succeeds (HTTP 200) is `get_project_issue_types(project_key)` called. A `get_issue` failure — detected by `Result::is_err()` (ANY `Err` variant, not a downcast) → Indeterminate immediately (the second call never executes). The unresolvable-name sub-path is reachable only when `get_issue` already succeeded. This ordering ensures the caller-side routing is provably total with no input matching two branches simultaneously.
- **`Option<IssueType>` outer-layer flatten**: `issue.fields.issuetype` (`src/types/jira/issue.rs:62`) is `Option<IssueType>`; `IssueType.subtask` is `Option<bool>`. The caller MUST read `src_subtask` via `issue.fields.issuetype.as_ref().and_then(|t| t.subtask)`. Two distinct sources of `src_subtask: None` exist: (a) the `issuetype` object is wholly absent from the response — `Option<IssueType>` is `None`; (b) `issuetype` is present but its `subtask` key is omitted from the JSON — `IssueType.subtask` is `None`. Both (a) and (b) collapse to `src_subtask: None` → Indeterminate. Test #6 covers case (b) (source-side subtask key omitted); it also covers case (a) via the same `and_then` flatten path — both produce `src_subtask: None` and route identically.
- ONE OF three routing conditions applies:
  - (Unresolvable-name) `get_project_issue_types` returns HTTP 200 with a non-empty list that does not contain the target name `X` → caller emits typo hint without invoking classifier.
  - (SameCategory) Both `get_issue` and `get_project_issue_types` succeed, the target name IS found, and the deserialized `subtask` values are both `Some(_)` AND equal → classifier returns `SameCategory` → typo hint emitted.
  - (Indeterminate) At least one of `get_issue` or `get_project_issue_types` returns an `Err` (ANY 4xx, 5xx, or network error — NOT a 200 with malformed body, which routes to unresolvable-name instead), OR both fetches return 200 but at least one `subtask` field is `None` → raw error only.

**Postconditions**:
- Exit code 1.
- `CROSS_HIERARCHY_HINT` is absent from stderr on ALL sub-paths (prevents false positives on plain typos and workflow-incompatibility 400s).
- Unresolvable-name and SameCategory: stderr contains the pinned typo hint (verbatim above) plus the `extract_error_message`-processed 400 message text carried in `JrError::ApiError.message`.
- Indeterminate: stderr contains the `extract_error_message`-processed 400 message text carried in `JrError::ApiError.message`; no enrichment hint of any kind.

**Invariants**:
1. `JRACLOUD-27893` MUST NOT appear on stderr on any of the three sub-paths. This prevents the cross-hierarchy hint from misleading users experiencing typos or workflow-incompatibility rejections.
2. Indeterminate degrades gracefully: a fetch failure on the error-enrichment path never supersedes the original 400 error body.
3. The unresolvable-name case routes to the typo hint (not Indeterminate) because the 200 response confirms the API is reachable and the name is definitively wrong — no ambiguity warrants degrading to raw error.

**Edge Cases**:
- EC-3.4.011-1: Both flags are `subtask: false` (two standard issue types, different names — target name found) → SameCategory → typo/workflow hint; no JRACLOUD-27893.
- EC-3.4.011-2: `get_project_issue_types` returns HTTP 5xx → Indeterminate (Cause-1, `is_err()` gate) → `extract_error_message`-processed 400 message only; no hint. Tested by `test_edit_type_indeterminate_project_types_5xx_surfaces_raw_error` (test #4 — covers the R2 routing row: `get_issue` succeeds, project-types call returns 5xx).
- EC-3.4.011-3: `get_project_issue_types` returns HTTP 200 with a non-empty list that does NOT contain the target name `X` (typo'd or wrong type name) → unresolvable-name sub-path → typo hint; NOT Indeterminate. The caller `handle_edit` emits the typo hint directly without invoking the pure classifier (because the name is definitively absent from a successful 200 response, not an API error). Tested by `test_edit_type_unresolved_type_name_surfaces_typo_hint` (test #8).
- EC-3.4.011-4: `get_issue` returns HTTP 401 (auth failure on enrichment fetch — surfaces as `JrError::NotAuthenticated` or `JrError::InsufficientScope`, NOT `JrError::ApiError{401}`, per `src/api/client.rs::parse_error`) → Indeterminate (Cause-1, caught by `is_err()` gate on the `get_issue` call) → `extract_error_message`-processed 400 message only; no hint; `JRACLOUD-27893` absent. This is the R1 routing row (`get_issue` itself fails): `get_issue` returns 5xx or any error → Indeterminate immediately (project-types never called). Tested by `test_edit_type_indeterminate_get_issue_fails_surfaces_raw_error` (test #9 — distinct from test #4 which covers R2 where `get_issue` succeeds but project-types fails).
- EC-3.4.011-5: `get_issue` returns HTTP 200 but Jira omits the `subtask` field from the issuetype object → `subtask: None` after deserialization → `is_cross_hierarchy_type_error(None, _, _)` returns `Indeterminate` → `extract_error_message`-processed 400 message only; no hint. Tested by `test_edit_type_indeterminate_absent_subtask_flag_surfaces_raw_error` (test #6 — source-side absent subtask flag).
- EC-3.4.011-6: `get_issue` returns HTTP 200 (source `subtask` field present), `get_project_issue_types` returns HTTP 200, but the matched target type's `subtask` key is OMITTED from the response object → `tgt_subtask: None` after deserialization → `is_cross_hierarchy_type_error(_, None, _)` returns `Indeterminate` → `extract_error_message`-processed 400 message only; no enrichment hint; `JRACLOUD-27893` absent. Tested by `test_edit_type_indeterminate_absent_target_subtask_flag_surfaces_raw_error` (test #7 — target-side absent subtask flag; symmetric to EC-3.4.011-5).
- EC-3.4.011-7: `get_project_issue_types` returns HTTP 200 with a list that does NOT contain the target name `X` (unresolvable-name path) → typo hint → exit 1; `JRACLOUD-27893` absent; `jr api /rest/api/3/issue` absent. Tested by `test_edit_type_unresolved_type_name_surfaces_typo_hint` (test #8 — the eighth integration test added to cover this previously-untested sub-path).

**Test sub-path mapping** (authoritative — tests in `tests/issue_edit_type_errors.rs`):
- Test #1 (`test_edit_type_cross_hierarchy_std_to_subtask_surfaces_conversion_hint`): CrossHierarchy standard→subtask direction — exercises BC-3.4.010.
- Test #2 (`test_edit_type_cross_hierarchy_subtask_to_std_surfaces_conversion_hint`): CrossHierarchy subtask→standard direction — exercises BC-3.4.010.
- Test #3 (`test_edit_type_same_hierarchy_400_surfaces_typo_hint`): SameCategory classifier-side (both flags `Some(false)`, target name found, hierarchy equal) — exercises BC-3.4.011 SameCategory classifier-side sub-path. `JRACLOUD-27893` MUST NOT appear.
- Test #4 (`test_edit_type_indeterminate_project_types_5xx_surfaces_raw_error`): Indeterminate Cause-1 (GET project types returns 5xx) — exercises BC-3.4.011 Indeterminate sub-path. `JRACLOUD-27893` MUST NOT appear.
- Test #5 (`test_edit_type_cross_hierarchy_hint_no_fake_endpoint_literal`): Regression pin — CrossHierarchy path does NOT emit `jr api /rest/api/3/issue` — exercises BC-3.4.010 postcondition.
- Test #6 (`test_edit_type_indeterminate_absent_subtask_flag_surfaces_raw_error`): Indeterminate Cause-2 source-side (subtask field absent on GET issue) — exercises BC-3.4.011 Indeterminate sub-path EC-3.4.011-5.
- Test #7 (`test_edit_type_indeterminate_absent_target_subtask_flag_surfaces_raw_error`): Indeterminate Cause-2 target-side (subtask field absent on GET project types) — exercises BC-3.4.011 Indeterminate sub-path EC-3.4.011-6.
- Test #8 (`test_edit_type_unresolved_type_name_surfaces_typo_hint`): Unresolvable-name sub-path (200 response, name NOT in list) — exercises BC-3.4.011 unresolvable-name sub-path. `get_project_issue_types` returns 200 with a list that does NOT contain the `--type` value → typo hint, exit 1, `JRACLOUD-27893` absent, `jr api /rest/api/3/issue` absent.
- Test #9 (`test_edit_type_indeterminate_get_issue_fails_surfaces_raw_error`): R1 routing row — `edit_issue` 400, then `get_issue` returns 5xx → Indeterminate (detected by `is_err()` on the `get_issue` call; project-types never called) → exit nonzero, raw error on stderr, no hint, `JRACLOUD-27893` absent, `jr api /rest/api/3/issue` absent. Distinct wiremock topology from test #4 (R2): test #9 has `get_issue` fail; test #4 has `get_issue` succeed then project-types fail. Exercises EC-3.4.011-4.
- Test #10 (`test_edit_type_non_400_edit_error_surfaces_raw_error_no_enrichment`): R0b routing row — `edit_issue` returns e.g. HTTP 403 (a non-400 error) → exit nonzero, raw error on stderr, NEITHER the cross-hierarchy hint NOR the typo hint, `JRACLOUD-27893` absent, `jr api /rest/api/3/issue` absent. No enrichment fetch occurs (`get_issue` and `get_project_issue_types` mocks NOT mounted). Exercises BC-3.4.010 and BC-3.4.011 negative constraint: the enrichment block is entered ONLY on `status == 400`.

**Trace**: issue #388 F2; `src/cli/issue/edit.rs::is_cross_hierarchy_type_error` (pure classifier, `SameCategory` and `Indeterminate` variants); `src/cli/issue/edit.rs` inline `#[cfg(test)] mod is_cross_hierarchy_type_error_proptests` proptest for `is_cross_hierarchy_type_error`; `src/cli/issue/edit.rs::handle_edit` (unresolvable name → typo hint; fetch-failure → `Indeterminate` caller dispatch); `tests/issue_edit_type_errors.rs` (integration — same-hierarchy, indeterminate, absent-subtask-flag, and unresolvable-name paths, tests #3–#8)

---

#### BC-3.4.012: `issue edit KEY` single-key success (table mode) echoes one stderr line per changed field in `field → value` format; resolved team name for `--team`; `(updated)` marker for description

**Confidence**: HIGH
**Source**: issue #398 F2 spec evolution; `src/cli/issue/edit.rs::handle_edit` (single-key success path); `output::print_success` (existing stderr channel)
**Subject**: Issue write
**Behavior**: On the single-key `issue edit KEY` success path (PUT 204), AFTER printing `"Updated <key>"` to stderr via `output::print_success`, the handler emits one additional stderr line per field that was changed in this invocation. Format is `  <field> → <value>` (two leading spaces, unicode arrow). Fields and their echo values:

- `summary` → the literal string value passed to `--summary`
- `issue_type` → the literal string value passed to `--type`
- `priority` → the literal string value passed to `--priority`
- `parent`:
  - **`--parent <key>` branch** (`if let Some(parent_key) = parent`): `changed_fields` receives an insertion `"parent" → parent_key_string` at the `if let Some(parent_key) = parent` site.
  - **`--no-parent` branch** (`if no_parent`): `changed_fields` receives an insertion `"parent" → "(cleared)"` at the `if no_parent` site. Key is always `parent` in both cases; no separate `no_parent` key is ever inserted.
- `points`:
  - **`--points <n>` branch** (`if let Some(pts) = points`): `changed_fields` receives an insertion `"points" → pts.to_string()` at the `if let Some(pts) = points` site. The value is Rust's default `f64::to_string()` (e.g., `"5"` for `5.0`, `"2.5"` for `2.5`). This `.to_string()` formatting applies ONLY to this branch.
  - **`--no-points` branch** (`if no_points`): `changed_fields` receives an insertion `"points" → "(cleared)"` at the `if no_points` site. No numeric formatting applies here — the value is the literal string `"(cleared)"`. Key is always `points` in both cases; no separate `no_points` key is ever inserted.
- `team` → the RESOLVED team name (not the user's partial-match query, not the UUID); sourced from the third element of the updated `resolve_team_field` return tuple `(field_id, team_id, team_name)`. When `--team` value was passed as a raw UUID and the UUID-bypass path fires, `team_name` is the UUID itself (echo of the raw value the caller supplied). The UUID-bypass predicate (`is_team_uuid`) checks exactly 36 chars in 8-4-4-4-12 hyphen-separated groups of ASCII hex digits (case-insensitive). A team name that resembles a UUID but fails this predicate still resolves via partial-match.
- `description` → the literal marker `(updated)` — the content is an ADF blob and is NEVER echoed inline. This asymmetry is intentional: the `(updated)` marker tells the user that description changed without flooding the terminal. See the research rationale in `.factory/research/issue-398-field-echo-conventions.md §4` (table/human channel: marker; JSON channel: raw user-supplied input string).

Map keys are always the literal lowercase identifiers in the key table (`summary`, `issue_type`, `priority`, `parent`, `points`, `team`, `description`) — never `customfield_*` IDs. The issue-type key is the literal `issue_type` (matching the Rust field identifier), NOT `type` and NOT `issuetype`.

`--label` edits (single OR multi key) route through `handle_edit_bulk_labels` and are NOT covered by this contract; no `label` key appears in `changed_fields`.

Only fields that were actually changed in the invocation are echoed. The field-echo lines all go to **stderr** (Symmetric profile 4, same channel as the existing confirmation message). Stdout is empty (no JSON in table mode). Exit code 0.

**Scope**: Single-key `handle_edit` path ONLY. The bulk `handle_edit_bulk_fields` and `handle_edit_bulk_labels` paths are unaffected by this contract. Single-key means `effective_keys.len() == 1` after resolution — including a `--jql` query matching exactly one issue. Multi-key (2+ positional, or `--jql` matching 2+) routes to the bulk path and is out of scope.

**Preconditions**:
- `jr issue edit <key> [field flags...]` issued without `--output json` (table mode).
- At least one field flag is supplied. When no field flags are given, `handle_edit` bails with `"No fields specified to update..."` before reaching the PUT — exit 1, no echo fires.
- `--dry-run` is NOT set. `--dry-run` short-circuits before the PUT and emits its own planned-changes preview; the changed-fields echo of this contract does not fire on `--dry-run`.
- Single key (not a bulk path).
- When `--points` or `--no-points` is used, `story_points_field_id` must be configured; otherwise `handle_edit` errors via `resolve_story_points_field_id` (`JrError::ConfigError`, exit 1) before the PUT and the echo does not fire.
- PUT 204 received from Jira API.

**Postconditions**:
- Exit code 0.
- Stderr contains `"Updated <key>"` (via `output::print_success`).
- Stderr contains one `  <field> → <value>` line per changed field, in **alphabetical field-name order**, matching the JSON `changed_fields` BTreeMap key order. Both table-mode echo and JSON-mode `changed_fields` iterate the same `BTreeMap`, guaranteeing identical ordering.
- Stdout is empty.

**Invariants**:
1. The `team` echo value is the RESOLVED name, never a UUID or the user's raw partial-match query (unless the caller supplied a raw UUID, in which case the UUID is echoed). VP-398-001 verifies this invariant.
2. The `description` echo value is always exactly `(updated)`, never the content or a truncated preview. VP-398-002 verifies the asymmetry invariant.
3. The field-echo lines are on stderr, NOT stdout. They are not visible in `--output json` mode (which is governed by BC-3.4.013).
4. Points value uses Rust's default `.to_string()` for `f64` on the **`--points <n>` branch only** (`if let Some(pts) = points`). The `--no-points` branch inserts the literal string `"(cleared)"` — `.to_string()` is not involved. The snapshot test MUST pin both values.
5. All `changed_fields` keys are human-readable field names (never `customfield_*` IDs).
6. **Map construction vs emission timing**: the `changed_fields` BTreeMap MAY be constructed during field resolution (before the PUT), but it is EMITTED (table-mode stderr echo lines) ONLY AFTER `edit_result?` succeeds — i.e., after the PUT returns 204 and passes the BC-3.4.010/011 dual-gate error block. On a 400 or any other error response, the constructed map is discarded and never emitted. The echo lines in this contract are always post-PUT.

**Edge Cases**:
- EC-3.4.012-1: `--team` supplied as a UUID directly (UUID-pass-through path, predicate: 36-char 8-4-4-4-12 ASCII hex groups) → team echo shows the UUID (the raw caller-supplied value, since no name resolution occurred). A team name that resembles a UUID but does not satisfy the exact predicate (e.g., wrong length, non-hex char) still resolves via partial-match.
- EC-3.4.012-2: `--description` and `--description-stdin` are mutually exclusive (BC-3.4.007 clap conflict); whichever one is supplied populates the single `description` key in `changed_fields`. The table-mode echo always shows `  description → (updated)` regardless of which flag was used. The raw string is captured verbatim from the supplied source, including any trailing newline — no normalization is applied before the ADF conversion.
- EC-3.4.012-3: `--no-parent` → map key is `parent`, echo is `  parent → (cleared)`.
- EC-3.4.012-4: `--no-points` → map key is `points`, echo is `  points → (cleared)`.
- EC-3.4.012-5: `--points 5.0` → echo depends on Rust `f64::to_string()` (may produce `"5"` not `"5.0"`); pinned by snapshot test. Concrete assertions (NOT snapshot-only): `--points 5` → stderr contains `  points → 5`; `--points 2.5` → stderr contains `  points → 2.5`. Snapshot pins the full line; assertion pins the exact string to catch a wrong-but-stable snapshot value.
- EC-3.4.012-6: Multiple fields changed simultaneously → one echo line per changed field in **alphabetical field-name order** (BTreeMap iteration order), same ordering as JSON `changed_fields`.
- EC-3.4.012-7: No field flags supplied → `handle_edit` bails with exit 1 before PUT; this contract does not fire.
- EC-3.4.012-8: `--label` flag supplied → routes through `handle_edit_bulk_labels`; this contract does not fire.
- EC-3.4.012-9: `--dry-run` set → `handle_edit` emits planned-changes preview and exits; this contract does not fire.
- EC-3.4.012-10: `--team` triggers interactive disambiguation (`ExactMultiple` or `Ambiguous` match result, `--no-input` absent) → user selects a team from the prompt → the echoed team name is the SELECTED team's display name (not the original query string). The echoed name is the cached team's STORED display-name casing: `duplicates[selection].name` for the `ExactMultiple` path and `teams[idx].name` for the `Ambiguous` path — NOT the user's query-string casing.
- EC-3.4.012-11: `--points/--no-points` used when `story_points_field_id` is not configured → `resolve_story_points_field_id` errors with `JrError::ConfigError` (exit 1) before the PUT; the echo does not fire.
- EC-3.4.012-12: `--summary ""` (empty-string value) → echo is `  summary → ` with nothing after the arrow. This is correct behavior — the empty string is a valid value, not a rendering bug. Pinned by test `test_bc_3_4_012_empty_summary_echoes_empty_value` (integration test (wiremock) — `handle_edit` needs a wiremock PUT 204, so this MUST be an integration test; it cannot be a unit test). Note: this is a wiremock-only test scenario — real Jira rejects an empty `summary` with HTTP 400 (`summary` is a system-required field), so the success-path echo is not reachable against live Jira; the test exercises the echo formatting via a mocked 204 response only.
- EC-3.4.012-13: `jr issue edit KEY --description "x" --summary "y"` → stderr emits, in alphabetical field-name order: `  description → (updated)` first, then `  summary → y` second. This pins that the `description` marker participates in the same BTreeMap alphabetical sort as all other keys — it is NOT moved to the end, and the `(updated)` literal is the value used in the sort position for `description`.
- EC-3.4.012-14: `jr issue edit KEY --markdown --description "**bold**"` → table-mode echo is still `  description → (updated)` regardless of `--markdown`. The Markdown content is never surfaced in table mode; the `(updated)` marker applies uniformly to all description-change paths.
- EC-3.4.012-15: `--team` value matches no team at all (`MatchResult::None(_)`) → `resolve_team_field` errors via `JrError::UserError` before the PUT (exit code per `src/error.rs::exit_code()`, currently 64); no team echo line is emitted and the changed-fields echo does not fire. The error text contains the stable substring `No team matching` (exact wording varies by `fetched_fresh` cache state; assert only the substring). Note: the `None` variant carries a `Vec<String>` of candidate names, unused by this contract.
- EC-3.4.012-16: `jr issue edit KEY --description-stdin < /dev/null` → `desc_text = Some("")`. The edit proceeds — `--description-stdin` is itself a field flag so the no-fields-specified bail (the `has_any_field_change` guard, the pre-HTTP guard at `edit.rs::has_any_field_change` ~line 106) does not fire regardless of stdin content; an empty description is a valid change. (Note: there are two distinct no-fields guards in `handle_edit` — `has_any_field_change` at ~line 106 bails before any HTTP/JQL, and `has_updates` at line 634 bails inside the field-resolution block. The bail described in this EC is the FORMER — `has_any_field_change` — because `--description-stdin` is an unconditional flag predicate in that `let` binding.) Table-mode echo is `  description → (updated)` (same as any non-empty description). The empty description string is still converted to ADF for the PUT body. Exit code 0.

**Verification Properties**:
- VP-398-001: Resolved team name in `edit` table output is the display name, not a UUID substring. Negative case (DECISION LOCKED — round 5 F-1): write a **direct unit-level assertion on `is_team_uuid`** — call `is_team_uuid("36885b3c-1bf0-4f85-a357-c5b858c31de")` (35 chars, one short of UUID length) and assert the return value is `false`. Reuse or cite the existing `is_team_uuid_rejects_wrong_length` test at `src/cli/issue/helpers.rs` (~line 617). Do NOT write an integration test routing this probe through `partial_match` — that tests `partial_match` fallback behavior, not the `is_team_uuid` predicate boundary. **PLACEMENT (DECISION LOCKED — round 7 F-1): `is_team_uuid` has no `pub` visibility — it is module-private. The `is_team_uuid` negative-case assertion is a UNIT test that MUST be placed in the `#[cfg(test)] mod tests` block inside `src/cli/issue/helpers.rs` (because `is_team_uuid` is module-private and not exported via lib.rs). Do NOT place it in `tests/`. The team-echo positive cases (verifying that a resolved display name, not a UUID, appears in stderr or JSON) remain wiremock integration tests in `tests/`.**
- VP-398-002: Description echo is exactly `(updated)` in table output (not a content preview, not a length, not empty).
- VP-398-004: `--no-parent` produces exactly one `changed_fields` key named `parent` with value `(cleared)` — no `no_parent` key is ever present; identically for `--no-points` → key `points` value `(cleared)`, no `no_points` key. This is verified by asserting the JSON `changed_fields` object (in `--output json` mode) contains exactly the key `parent` (not `no_parent`) with value `"(cleared)"` when `--no-parent` is used, and contains exactly the key `points` (not `no_points`) with value `"(cleared)"` when `--no-points` is used. The table-mode echo uses the same keys (`parent →`, `points →`), verified by asserting stderr does not contain `no_parent` or `no_points` as field labels.

**Trace**: issue #398 F2; `src/cli/issue/edit.rs::handle_edit`; `src/cli/issue/helpers.rs::resolve_team_field` (signature change to return 3-tuple; `is_team_uuid` predicate: 36-char, 8-4-4-4-12 ASCII hex groups, case-insensitive); `.factory/research/issue-398-field-echo-conventions.md`; `.factory/phase-f2-spec-evolution/prd-delta-398.md §2`

[NEW 2026-05-21 issue #398 F2]
[UPDATED 2026-05-21 adversarial review round 1: C-2 no-flags is pre-PUT exit-1; M-1 --label exclusion; MED-1 single-key cleared-field model; MED-2 BTreeMap/alphabetical ordering noted; MED-3 --dry-run precondition; MED-4 --jql single-match scope; MIN-2 UUID predicate pinned]
[UPDATED 2026-05-21 adversarial review round 2: F-2 alphabetical ordering pinned in postconditions+EC-6; F-2 stdin verbatim capture clarified in EC-2; F-3 points precondition added EC-11; F-8 interactive disambiguation EC-10; F-9 VP-398-001 negative case rewritten; F-10 key naming clarified; F-13 empty-string EC-12]
[UPDATED 2026-05-21 adversarial review round 3: MED-1 EC-13 added (concrete --description+--summary alphabetical ordering pin with description marker in sort); MED-2 EC-14 added (--markdown table mode still shows (updated) marker); M-1 plain-text reference in description field corrected to raw-user-supplied-input-string]
[UPDATED 2026-05-21 adversarial review round 4: F-2 EC-3.4.012-10 stored-casing clause added (duplicates[selection].name / teams[idx].name, NOT query-string casing); F-3 VP-398-001 fixture constraint + No-team-matching substring assertion]
[UPDATED 2026-05-21 adversarial review round 5: F-1 VP-398-001 negative case rewritten as direct unit-level is_team_uuid assertion (cite is_team_uuid_rejects_wrong_length); F-3 EC-3.4.012-15 added (MatchResult::None → JrError::UserError exit 64, no echo)]
[UPDATED 2026-05-21 adversarial review round 7: F-1 VP-398-001 + explicit module-private placement sentence (UNIT test in helpers.rs #[cfg(test)] block, NOT tests/); F-2 EC-3.4.012-12 test name pinned; F-4 VP-398-004 added (cleared-field single-key model); F-5 EC-3.4.012-2 reworded (clap conflict, not co-occurrence)]
[UPDATED 2026-05-21 adversarial review round 8: MAJOR-1 points/parent bullet split into two-site insertion enumeration; invariant 4 f64 .to_string() scoped to --points branch only; OBS-2 concrete assertion values added to EC-3.4.012-5; OBS-4 EC-3.4.012-12 pinned as integration test (wiremock); IMP-3 EC-3.4.012-16 added (empty-stdin edge case)]
[UPDATED 2026-05-21 adversarial review round 9: IMPORTANT-1 EC-3.4.012-12 wiremock-only note added (real Jira rejects empty summary with HTTP 400)]
[UPDATED 2026-05-21 adversarial review round 10: IMPORTANT-3 invariant 6 added (map construction vs emission timing — map discarded on PUT error, emitted only post-204); IMPORTANT-2 EC-3.4.012-16 has_any_field_change replaced with has_updates]
[UPDATED 2026-05-21 adversarial review round 12: EC-3.4.012-16 reverted to `has_any_field_change` — the round-10 rename to `has_updates` was an over-correction; `has_any_field_change` (`edit.rs::handle_edit` ~line 106) is the pre-HTTP no-fields guard the EC reasons about]

---

#### BC-3.4.013: `issue edit KEY` single-key success (JSON mode) includes `changed_fields` object in `edit_response`; `updated: true` retained; description carries the RAW user-supplied input string

**Confidence**: HIGH
**Source**: issue #398 F2 spec evolution; `src/cli/issue/json_output.rs::edit_response` (signature change); `src/cli/issue/edit.rs::handle_edit` (field-resolution block where `desc_text` is captured as the raw user input — `src/adf.rs` ADF→text converter is NOT used for this field)
**Subject**: Issue write
**Behavior**: On the single-key `jr issue edit KEY --output json` success path (PUT 204), the JSON payload on stdout is extended from the prior `{"key": "<key>", "updated": true}` shape to include a `changed_fields` object:

```json
{
  "key": "<key>",
  "updated": true,
  "changed_fields": {
    "<field_name>": "<string_value>"
  }
}
```

`"updated": true` is RETAINED for backward compatibility. Downstream consumers using `.key` or `.updated` in `jq` expressions are unaffected.

`changed_fields` maps literal lowercase field identifiers to JSON string values (never `customfield_*` IDs). JSON key order is deterministic (alphabetical) because `edit_response` uses `BTreeMap<String, String>` internally. All values are JSON strings, including numeric fields (e.g., `"5"` not `5`). The issue-type key is the literal `"issue_type"` (matching the Rust field identifier), NOT `"type"` and NOT `"issuetype"`. Keys and value semantics:

| Key | Value |
|-----|-------|
| `"description"` | The **raw user-supplied input string** from `--description` or `--description-stdin`. NOT the `(updated)` marker. NOT an ADF→text round-trip. The raw string is lossless — it is exactly what the caller sent, before any `markdown_to_adf` conversion. |
| `"issue_type"` | Verbatim string passed to `--type` |
| `"parent"` | **`--parent <key>` branch** (`if let Some(parent_key) = parent`): `changed_fields` receives insertion `"parent" → parent_key_string` at the `if let Some(parent_key) = parent` site. **`--no-parent` branch** (`if no_parent`): `changed_fields` receives insertion `"parent" → "(cleared)"` at the `if no_parent` site. Key is always `"parent"` in both cases; no separate `"no_parent"` key is ever inserted. |
| `"points"` | **`--points <n>` branch** (`if let Some(pts) = points`): `changed_fields` receives insertion `"points" → pts.to_string()` at the `if let Some(pts) = points` site. Value is Rust's default `f64::to_string()` (e.g., `"5"` for `5.0`, `"2.5"` for `2.5`). This `.to_string()` formatting applies ONLY to this branch. **`--no-points` branch** (`if no_points`): `changed_fields` receives insertion `"points" → "(cleared)"` at the `if no_points` site — no numeric formatting. Key is always `"points"` in both cases; no separate `"no_points"` key. |
| `"priority"` | Verbatim string passed to `--priority` |
| `"summary"` | Verbatim string passed to `--summary` |
| `"team"` | RESOLVED team display name (not UUID, not partial-match query); from the `team_name` element of the updated `resolve_team_field` return tuple |

`--label` edits (single OR multi key) route through `handle_edit_bulk_labels` and are NOT covered by this contract; no `"label"` key appears in `changed_fields`.

The deliberate asymmetry between BC-3.4.012 (table: `(updated)` marker for description) and BC-3.4.013 (JSON: raw input string for description) is intentional: the human channel optimizes for scannability; the machine channel must be complete and faithful. This asymmetry MUST NOT be "fixed" to make them match. A CLAUDE.md Gotcha entry should accompany the implementation.

`changed_fields` contains only the fields that were changed in this invocation (same map construction as BC-3.4.012). The JSON output is on stdout. No stderr output in JSON mode (Symmetric profile 4). Exit code 0.

`edit_response` signature changes to: `pub(crate) fn edit_response(key: &str, changed_fields: &BTreeMap<String, String>) -> Value`. The `BTreeMap` is passed from `handle_edit` after it is constructed during field resolution. Alphabetical key order within `changed_fields` is guaranteed by `BTreeMap`. The top-level object key order (the relative position of `"key"`, `"updated"`, and `"changed_fields"`) is determined by `serde_json::Map`'s default alphabetical key ordering (`preserve_order` feature is NOT enabled in this crate — confirmed in Cargo.toml). The top-level keys `changed_fields`, `key`, `updated` are already in alphabetical order, so the pinned snapshot body is `{"changed_fields": {...}, "key": "TEST-1", "updated": true}` regardless of the order they are written in the `json!{}` literal. The top-level key order is NOT contractually pinned beyond whatever the regenerated insta snapshot records; only the INNER `changed_fields` key order is contractually alphabetical.

**Preconditions**:
- `jr issue edit <key> [field flags...] --output json` issued.
- At least one field flag is supplied. When no field flags are given, `handle_edit` bails with `"No fields specified to update..."` before reaching the PUT — exit 1, no JSON emitted.
- `--dry-run` is NOT set. `--dry-run` short-circuits before the PUT and emits its own planned-changes preview; the changed-fields echo of this contract does not fire on `--dry-run`.
- Single key (not a bulk path). Single-key means `effective_keys.len() == 1` after resolution — including a `--jql` query matching exactly one issue. Multi-key (2+ positional, or `--jql` matching 2+) routes to the bulk path and is out of scope.
- When `--points` or `--no-points` is used, `story_points_field_id` must be configured; otherwise `handle_edit` errors via `resolve_story_points_field_id` (`JrError::ConfigError`, exit 1) before the PUT and no JSON is emitted.
- PUT 204 received from Jira API.

**Postconditions**:
- Exit code 0.
- Stdout is valid JSON with keys: `"key"` (string), `"updated"` (boolean `true`), `"changed_fields"` (object with string values in alphabetical key order).
- `"updated": true` is present (backward-compat invariant).
- `changed_fields["team"]` is the resolved display name, never a UUID (unless the caller supplied a raw UUID directly).
- `changed_fields["description"]` is the raw user-supplied input string, never `"(updated)"`.
- Stderr is empty.

**Invariants**:
1. `"updated": true` MUST remain in the payload. Its removal is a breaking change. VP-398-003 verifies this invariant.
2. `changed_fields["description"]` MUST be the raw user input string (lossless; no ADF→text round-trip). VP-398-002 verifies the asymmetry holds (JSON gets raw string; table gets `(updated)` marker).
3. `changed_fields["team"]` MUST be the resolved display name. VP-398-001 verifies.
4. `changed_fields` JSON key order is alphabetical (guaranteed by `BTreeMap`). The insta snapshot `jr__cli__issue__json_output__tests__edit.snap` MUST be updated to reflect the new shape. The `test_edit` unit test in `src/cli/issue/json_output.rs` MUST be updated to pass a non-empty `BTreeMap` for `changed_fields` — specifically `BTreeMap` with `"summary" → "New title"`. **Pinned expected regenerated snapshot body (DECISION LOCKED — round 10 MAJOR-1)**: the regenerated snapshot content MUST be exactly `{"changed_fields": {"summary": "New title"}, "key": "TEST-1", "updated": true}` (with `changed_fields` before `key` before `updated`). The top-level key order is alphabetical because `serde_json::Map` serializes keys in alphabetical order by default — the `preserve_order` feature is NOT enabled in this crate (confirmed in Cargo.toml). The top-level keys `changed_fields`, `key`, `updated` are already in alphabetical order, so the pinned snapshot body is correct regardless of the order they are written in the `json!{}` literal. Additionally, a new test `test_edit_response_empty_changed_fields` MUST be added (applying the new-test `test_<verb>_<subject>_<expected_outcome>` naming convention): this test calls `edit_response` with an empty `BTreeMap<String, String>` and asserts the resulting JSON has `"updated": true` and `"changed_fields": {}`. It does NOT use an insta snapshot (see VP-398-003 snapshot test split). **Top-level key order note**: the top-level `edit_response` object key order follows `serde_json::Map`'s default alphabetical key ordering (`preserve_order` NOT enabled) and is NOT contractually pinned beyond whatever the regenerated snapshot records. Only the INNER `changed_fields` key order is contractually alphabetical.
5. All `changed_fields` keys are the literal lowercase identifiers (`summary`, `issue_type`, `priority`, `parent`, `points`, `team`, `description`) — never `customfield_*` IDs. The issue-type key is the literal `issue_type` (matching the Rust field identifier), NOT `type` and NOT `issuetype`.
6. **Map construction vs emission timing**: the `changed_fields` BTreeMap MAY be constructed during field resolution (before the PUT), but it is EMITTED (included in the JSON payload on stdout) ONLY AFTER `edit_result?` succeeds — i.e., after the PUT returns 204 and passes the BC-3.4.010/011 dual-gate error block. On a 400 or any other error response, the constructed map is discarded and the JSON payload of this contract is never written to stdout.

**Edge Cases**:
- EC-3.4.013-1: No field flags supplied → `handle_edit` bails with exit 1 before PUT; no JSON emitted.
- EC-3.4.013-2: `--team` value was a raw UUID (UUID-bypass path) → `changed_fields["team"]` is the UUID (the raw value supplied, since no name lookup occurred).
- EC-3.4.013-3: `--description` and `--description-stdin` are mutually exclusive (BC-3.4.007 clap conflict); whichever one is supplied populates the single `description` key. When `--description-stdin` is used, `changed_fields["description"]` is the raw piped content string (same lossless path as `--description`). The raw string is captured verbatim as read from stdin, including any trailing newline — no trailing-newline normalization is applied.
- EC-3.4.013-4: `--no-parent` set → `changed_fields["parent"] = "(cleared)"`. No separate `"no_parent"` key.
- EC-3.4.013-5: `--no-points` set → `changed_fields["points"] = "(cleared)"`. No separate `"no_points"` key.
- EC-3.4.013-6: `--label` flag supplied → routes through `handle_edit_bulk_labels`; this contract does not fire.
- EC-3.4.013-7: `--dry-run` set → `handle_edit` emits planned-changes preview and exits; this contract does not fire.
- EC-3.4.013-8: `--team` triggers interactive disambiguation (`ExactMultiple` or `Ambiguous` match result, `--no-input` absent) → user selects a team from the prompt → `changed_fields["team"]` is the SELECTED team's display name (not the original query string). The echoed name is the cached team's STORED display-name casing: `duplicates[selection].name` for the `ExactMultiple` path and `teams[idx].name` for the `Ambiguous` path — NOT the user's query-string casing.
- EC-3.4.013-9: `--points/--no-points` used when `story_points_field_id` is not configured → `resolve_story_points_field_id` errors with `JrError::ConfigError` (exit 1) before the PUT; no JSON is emitted.
- EC-3.4.013-10: `--summary ""` (empty-string value) → `changed_fields["summary"] = ""`. The empty string is a valid value; the key is present in the output. Pinned by test `test_bc_3_4_013_empty_summary_in_changed_fields` (asserting the JSON `changed_fields` object contains `"summary": ""` — the key is present with an empty string value, not absent). Note: this is a wiremock-only test scenario — real Jira rejects an empty `summary` with HTTP 400 (`summary` is a system-required field), so the success-path echo is not reachable against live Jira; the test exercises the echo formatting via a mocked 204 response only.
- EC-3.4.013-11: `jr issue edit KEY --markdown --description "**bold**"` → `changed_fields["description"]` is the literal raw string `**bold**` (raw Markdown), NOT ADF JSON and NOT plain-text-rendered. The `--markdown` flag causes `markdown_to_adf("**bold**")` to be invoked for the PUT body sent to Jira, but the raw input string `"**bold**"` is captured BEFORE that conversion and stored in `changed_fields`. The `src/adf.rs` converter is not involved in populating `changed_fields["description"]` in any way.
- EC-3.4.013-12: `--team` value matches no team at all (`MatchResult::None(_)`) → `resolve_team_field` errors via `JrError::UserError` before the PUT (exit code per `src/error.rs::exit_code()`, currently 64); no JSON is emitted and the changed-fields echo does not fire. The error text contains the stable substring `No team matching` (exact wording varies by `fetched_fresh` cache state; assert only the substring). Note: the `None` variant carries a `Vec<String>` of candidate names, unused by this contract.
- EC-3.4.013-13: `jr issue edit KEY --description-stdin < /dev/null` → `desc_text = Some("")`. The edit proceeds — `--description-stdin` is itself a field flag so the no-fields-specified bail (the `has_any_field_change` guard, the pre-HTTP guard at `edit.rs::has_any_field_change` ~line 106) does not fire regardless of stdin content; an empty description is a valid change. (Note: there are two distinct no-fields guards in `handle_edit` — `has_any_field_change` at ~line 106 bails before any HTTP/JQL, and `has_updates` at line 634 bails inside the field-resolution block. The bail described in this EC is the FORMER — `has_any_field_change` — because `--description-stdin` is an unconditional flag predicate in that `let` binding.) JSON output: `changed_fields["description"]` is `""` (empty string). The `"description"` key IS present in `changed_fields`. Exit code 0.

**Verification Properties**:
- VP-398-001: Resolved team name in `edit` JSON `changed_fields.team` is the display name, not a UUID substring. Negative case (DECISION LOCKED — round 5 F-1): write a **direct unit-level assertion on `is_team_uuid`** — call `is_team_uuid("36885b3c-1bf0-4f85-a357-c5b858c31de")` (35 chars, one short of UUID length) and assert the return value is `false`. Reuse or cite the existing `is_team_uuid_rejects_wrong_length` test at `src/cli/issue/helpers.rs` (~line 617). Do NOT write an integration test routing this probe through `partial_match` — that tests `partial_match` fallback behavior, not the `is_team_uuid` predicate boundary. **PLACEMENT (DECISION LOCKED — round 7 F-1): `is_team_uuid` has no `pub` visibility — it is module-private. The `is_team_uuid` negative-case assertion is a UNIT test that MUST be placed in the `#[cfg(test)] mod tests` block inside `src/cli/issue/helpers.rs` (because `is_team_uuid` is module-private and not exported via lib.rs). Do NOT place it in `tests/`. The team-echo positive cases (verifying that a resolved display name, not a UUID, appears in JSON `changed_fields.team`) remain wiremock integration tests in `tests/`.**
- VP-398-002: `changed_fields.description` in JSON output is NOT `"(updated)"` (it is the raw user input string). In table output, description echo IS `(updated)` (asymmetry pinned by two separate assertions). **Sub-case — stdin trailing-newline not normalized**: When `--description-stdin` is used and the piped content ends with a trailing newline, `changed_fields["description"]` MUST be exactly `"My description\n"` — the trailing `\n` must be present and must not be silently stripped. Test: `printf 'My description\n' | jr issue edit KEY --description-stdin --output json`; parse JSON; assert `changed_fields.description == "My description\n"` (not `"My description"`). Suggested test name: `test_bc_3_4_013_description_stdin_trailing_newline_preserved_in_changed_fields`. Applies to BC-3.4.013 (JSON mode); table mode always shows `(updated)` regardless of content.
- VP-398-003: `"updated": true` is present in `edit_response` JSON payload (backward-compat invariant). Test strategy: pass a single-field edit (e.g., `--summary "New title"`) in `--output json` mode; parse JSON; assert `output["updated"] == true` and `output["changed_fields"]` is non-empty. Also assert `"updated": true` in the updated insta snapshot. **Snapshot test split (DECISION LOCKED — round 7 F-3; see also invariant 4 above)**: the existing `test_edit` MUST be updated to pass a non-empty `BTreeMap`; the NEW `test_edit_response_empty_changed_fields` test covers the empty-map case and asserts `"updated": true` AND `"changed_fields": {}` directly (no snapshot). Both tests together verify that `"updated": true` is always present regardless of whether `changed_fields` is empty or non-empty.
- VP-398-004: `--no-parent` produces exactly one `changed_fields` key named `parent` with value `(cleared)` — no `no_parent` key is ever present; identically for `--no-points` → key `points` value `(cleared)`, no `no_points` key. Assert: `changed_fields` in JSON output contains `"parent": "(cleared)"` (not `"no_parent"`) when `--no-parent` is used; and `"points": "(cleared)"` (not `"no_points"`) when `--no-points` is used.

**Trace**: issue #398 F2; `src/cli/issue/json_output.rs::edit_response`; `.factory/research/issue-398-field-echo-conventions.md §4`; `.factory/phase-f2-spec-evolution/prd-delta-398.md §2`

[NEW 2026-05-21 issue #398 F2]
[UPDATED 2026-05-21 adversarial review round 1: C-2 no-flags is pre-PUT exit-1; M-1 --label exclusion; M-2 description is raw input string not ADF→text; MED-1 single-key cleared-field model (parent/points); MED-2 BTreeMap alphabetical ordering; MED-3 --dry-run precondition; MED-4 --jql single-match scope]
[UPDATED 2026-05-21 adversarial review round 2: F-2 stdin verbatim capture clarified in EC-3; F-3 points precondition added EC-9; F-8 interactive disambiguation EC-8; F-9 VP-398-001 negative case rewritten; F-10 key naming clarified; F-13 empty-string EC-10]
[UPDATED 2026-05-21 adversarial review round 3: MED-2 EC-11 added (--markdown --description raw Markdown string in changed_fields; src/adf.rs not used for changed_fields population)]
[UPDATED 2026-05-21 adversarial review round 4: F-2 EC-3.4.013-8 stored-casing clause added (duplicates[selection].name / teams[idx].name, NOT query-string casing); F-3 VP-398-001 fixture constraint + No-team-matching substring assertion]
[UPDATED 2026-05-21 adversarial review round 5: F-1 VP-398-001 negative case rewritten as direct unit-level is_team_uuid assertion (cite is_team_uuid_rejects_wrong_length); F-3 EC-3.4.013-12 added (MatchResult::None → JrError::UserError exit 64, no JSON emitted)]
[UPDATED 2026-05-21 adversarial review round 7: F-1 VP-398-001 + explicit module-private placement sentence (UNIT test in helpers.rs #[cfg(test)] block, NOT tests/); F-2 EC-3.4.013-10 test name pinned; F-4 VP-398-004 added (cleared-field single-key model); F-5 EC-3.4.013-3 reworded (clap conflict, not co-occurrence); F-6 VP-398-002 stdin trailing-newline sub-case added inline]
[UPDATED 2026-05-21 adversarial review round 8: MAJOR-1 parent/points table rows split into two-site insertion enumeration; f64 .to_string() scoped to --points branch only (not --no-points); MAJOR-2 invariant 4 + VP-398-003 body add test_edit_response_empty_changed_fields; IMP-3 EC-3.4.013-13 added (empty-stdin edge case, changed_fields["description"]=="")]
[UPDATED 2026-05-21 adversarial review round 9: IMPORTANT-1 EC-3.4.013-10 wiremock-only note added (real Jira rejects empty summary with HTTP 400)]
[UPDATED 2026-05-21 adversarial review round 10: MAJOR-1 invariant 4 pinned regenerated snapshot body ({"changed_fields": {"summary": "New title"}, "key": "TEST-1", "updated": true}); IMPORTANT-1 top-level key order note added to invariant 4 and signature paragraph; IMPORTANT-2 EC-3.4.013-13 has_any_field_change replaced with has_updates; IMPORTANT-3 invariant 6 added (map construction vs emission timing — map discarded on PUT error, emitted only post-204)]
[UPDATED 2026-05-21 adversarial review round 12: EC-3.4.013-13 reverted to `has_any_field_change` — the round-10 rename to `has_updates` was an over-correction; `has_any_field_change` (`edit.rs::handle_edit` ~line 106) is the pre-HTTP no-fields guard the EC reasons about]

---

#### BC-3.4.014: `issue create` table-mode success echoes ALL set fields to stderr (mirroring BC-3.4.012)

**Confidence**: HIGH
**Source**: issue #398 F2 spec evolution; `src/cli/issue/create.rs::handle_create` (table-mode success path); `src/cli/issue/helpers.rs::resolve_team_field` (signature change to return 3-tuple)
**Subject**: Issue write

> **[REVISED 2026-05-22 human-gate]** BC-3.4.014 broadened from team-only to all-set-fields echo to match BC-3.4.012. The sentence "Unlike `issue edit`, `issue create` echoes ONLY the resolved team name" is superseded and removed.

**Behavior**: On the `jr issue create` success path (table mode, no `--output json`), the existing two-line output:

```
Created issue FOO-123
https://example.atlassian.net/browse/FOO-123
```

gains one `  <field> → <value>` stderr line per field the create command set, appearing between the `"Created issue <key>"` confirmation and the browse URL:

```
Created issue FOO-123
  assignee → Jane Doe
  description → (updated)
  issue_type → Task
  label → bug, urgent
  parent → PROJ-5
  points → 5
  priority → High
  summary → Fix the login bug
  team → Platform Core
https://example.atlassian.net/browse/FOO-123
```

Field echo lines are sorted in **alphabetical field-name order** (matching BC-3.4.012). Only fields actually set by the caller appear — unset optional fields emit no line. Format is `  <field> → <value>` with two leading spaces and a unicode right arrow, identical to BC-3.4.012.

**Fields echoed and their table-mode values (create-path enumeration)**:

- `summary` → literal `--summary` value. Required field; always present on the platform path (post-resolve).
- `issue_type` → literal `--type` value. Required field; always present on the platform path.
- `description` → literal `(updated)` marker. Content is never echoed in table mode. Same asymmetry as BC-3.4.012. (`--description` or `--description-stdin`; either source shows the marker.)
- `priority` → literal `--priority` value.
- `label` → comma-separated list of label values (e.g., `bug, urgent` for `--label bug --label urgent`). If a single label is supplied, no trailing comma. If `--label` is absent, no echo line.
- `team` → RESOLVED display name (not UUID, not partial-match query). UUID-bypass: when the caller passes a raw UUID, the UUID is echoed as-is (no lookup occurred). Uses the third element from `resolve_team_field`'s `(field_id, team_id, team_name)` return tuple.
- `points` → `f64::to_string()` result (e.g., `"5"` for 5.0, `"2.5"` for 2.5).
- `parent` → issue key string from `--parent` (e.g., `PROJ-5`).
- `assignee` → display name of the resolved assignee. Sourced from `resolve_assignee_by_project`'s second return element `_display_name` (currently unused — must be bound and used for echo). When `--account-id` is used instead of `--to`, the account ID is echoed as the value (no display name lookup occurs on the `--account-id` path).

**Fields NOT echoed**:
- `project` — implicit/required; not echoed (same decision as BC-3.4.012 which does not echo the issue key).
- `--request-type` path fields — the JSM path is governed by BC-3.8.011; this contract applies to the platform path only.
- `--label` on create is the platform single-POST path (NOT the bulk path used by `edit --label`). Because all labels are present in the create POST body, echoing them as a comma-joined list is feasible and IS implemented. There is no `label` key exclusion on create (contrast with BC-3.4.012 which explicitly excludes `label` because `edit --label` routes through `handle_edit_bulk_labels`).

**JSON mode is UNCHANGED**: `issue create --output json` already performs a follow-up GET returning the full created issue object — a superset of the edit `changed_fields`. No `changed_fields` key is added to create JSON output; the JSON path is byte-for-byte identical to pre-#398 behavior. The full issue object is richer than `changed_fields` would be, making a `changed_fields` addition redundant.

**Output channel profile**: All output lines (`Created issue <key>`, field echo lines, browse URL) are emitted to **stderr**. Stdout is empty in table mode. The browse URL was already on stderr pre-#398 (via `eprintln!`). This is **output channel profile 4 (Symmetric)**: stdout is empty in table mode; in `--output json` mode stdout carries the full JSON payload while stderr is empty. Profile-4 carve-out: success confirmation lines on stderr is pre-existing behavior, not an error path. #398 only inserts field-echo lines into the same pre-existing stderr stream.

**Preconditions**:
- `jr issue create [flags...]` issued without `--output json`.
- The `--request-type` flag is absent (platform create path; JSM path is governed by BC-3.8.011).
- All field resolution succeeds (team, assignee, story-points field ID).
- POST 201 received; `issueKey` extracted.

**Postconditions**:
- Exit code 0.
- Stderr contains `"Created issue <key>"` (via `output::print_success`).
- Stderr contains one `  <field> → <value>` line per field set, in alphabetical field-name order, between the "Created issue" line and the browse URL.
- Stderr contains the browse URL.
- Stdout is empty.

**Invariants**:
1. The `team` echo value is the RESOLVED display name, never a UUID (unless the caller supplied a UUID directly). VP-398-001 covers `edit` and `create` table-mode team echo.
2. The `description` echo value is always `(updated)` — never the content, never truncated. Same asymmetry as BC-3.4.012.
3. Field echo lines appear between the "Created issue" confirmation and the browse URL — never after the browse URL.
4. When no optional flags are set (only required `--summary` and `--type` supplied), the minimal echo contains only `issue_type` and `summary` lines.
5. The `label` echo is a comma-separated join of the labels Vec, in the order they appear on the command line (no re-sorting of the labels themselves; only the field-key `label` is alphabetically sorted relative to other field keys).
6. The echo map is constructed alongside field-building; it is discarded if the POST fails. Field echo lines are emitted only post-201.

**Edge Cases**:
- EC-3.4.014-1: `--team` supplied as a UUID directly → team echo shows the UUID (UUID-bypass path; no name resolution occurred).
- EC-3.4.014-2: `--team` triggers disambiguation prompt (interactive, `--no-input` absent) → user selects a team → resolved name is echoed.
- EC-3.4.014-3: `--no-input` with an ambiguous team name → `resolve_team_field` errors via `JrError::UserError` before POST (exit code per `src/error.rs::exit_code()`, currently 64); no echo emitted.
- EC-3.4.014-4: JSM create path (`--request-type` set) → this BC does NOT apply; the team warning is governed by BC-3.8.011 (`--team` is ignored on JSM path). None of the create field echo lines fire on the JSM path.
- EC-3.4.014-5: `--team` value matches no team at all (`MatchResult::None(_)`) → `resolve_team_field` errors via `JrError::UserError` before POST (exit code per `src/error.rs::exit_code()`, currently 64); no echo emitted and the create does not proceed. The error text contains the stable substring `No team matching` (exact wording varies by `fetched_fresh` cache state; assert only the substring). Note: the `None` variant carries a `Vec<String>` of candidate names, unused by this contract.
- EC-3.4.014-6: `--label` absent → no `label` echo line emitted.
- EC-3.4.014-7: `--to me` → assignee resolves via `get_myself()`; display name from the myself response is echoed as `assignee → <display_name>`.
- EC-3.4.014-8: `--account-id <id>` used instead of `--to` → `assignee → <account_id>` (the account ID is echoed; no display-name lookup is performed on the `--account-id` path, consistent with existing `jr issue assign --account-id` behavior).
- EC-3.4.014-9: `--label bug --label urgent` → `label → bug, urgent` (comma-space separated).
- EC-3.4.014-10: Only `--summary` and `--type` set → echo contains `issue_type` and `summary` lines only; output byte-for-byte identical to `BC-3.4.012` equivalent when only those two fields are set.
- EC-3.4.014-11: `--points 5.0` → echo depends on Rust `f64::to_string()` (may produce `"5"` not `"5.0"`); pinned by snapshot test. Concrete assertions (NOT snapshot-only): `jr issue create ... --points 5` → stderr contains `  points → 5`; `jr issue create ... --points 2.5` → stderr contains `  points → 2.5`. Snapshot pins the full line; assertion pins the exact string to catch a wrong-but-stable snapshot value. (Mirrors EC-3.4.012-5.)
- EC-3.4.014-12: `jr issue create ... --summary ""` (empty-string value) → echo line is `  summary → ` with nothing after the arrow. This is correct rendering — the empty string is a valid value, not a rendering bug. Note: this is a wiremock-only test scenario — real Jira rejects an empty `summary` with HTTP 400 (`summary` is a system-required field), so the success-path echo is not reachable against live Jira; the test exercises the echo formatting via a mocked 201 response only. (Mirrors EC-3.4.012-12; clap accepts `--summary ""` even though the field is required by the API.)
- EC-3.4.014-13: `--points` used when `story_points_field_id` is not configured → `handle_create` errors via `resolve_story_points_field_id` with `JrError::ConfigError` (exit 1) before the POST; no echo fires. (Mirrors EC-3.4.012-11.)

**Verification Properties**:
- VP-398-001: Resolved team name in `create` table output is the display name, not a UUID substring (shared VP with BC-3.4.012 and BC-3.4.013). Negative case (DECISION LOCKED — round 5 F-1): write a **direct unit-level assertion on `is_team_uuid`** — call `is_team_uuid("36885b3c-1bf0-4f85-a357-c5b858c31de")` (35 chars, one short of UUID length) and assert the return value is `false`. Reuse or cite the existing `is_team_uuid_rejects_wrong_length` test at `src/cli/issue/helpers.rs` (~line 617). Do NOT write an integration test routing this probe through `partial_match`. **PLACEMENT (DECISION LOCKED — round 7 F-1): `is_team_uuid` has no `pub` visibility — it is module-private. The `is_team_uuid` negative-case assertion is a UNIT test that MUST be placed in the `#[cfg(test)] mod tests` block inside `src/cli/issue/helpers.rs`. Do NOT place it in `tests/`.** The team-echo positive cases remain wiremock integration tests in `tests/`.
- VP-398-005: Broadened to cover all-fields create echo. Integration test (wiremock) verifies: (a) `jr issue create --team <unresolvable_name> --no-input` exits 64, no POST issued; (b) `jr issue create --summary X --type Task --priority High --team "Platform Core"` in table mode emits `  priority → High` and `  team → Platform Core` on stderr (alphabetical order) between "Created issue" and browse URL. Suggested test names: `test_bc_3_4_014_create_unresolvable_team_no_input_exits_64`, `test_bc_3_4_014_create_all_fields_echo_alphabetical_order`. See verification-delta-398.md §VP-398-005 for full test strategy.
- VP-398-006 (NEW): Create `description` echo is `(updated)` marker (table mode) — never the content. Integration test: `jr issue create --summary X --type Task --description "Some content"` in table mode emits `  description → (updated)` on stderr, does NOT contain `"Some content"`. Suggested test name: `test_bc_3_4_014_create_description_echo_is_updated_marker`.

**Trace**: issue #398 F2; `src/cli/issue/create.rs::handle_create`; `src/cli/issue/helpers.rs::resolve_team_field`; `.factory/phase-f2-spec-evolution/prd-delta-398.md §2`; human-gate decision 2026-05-22

[NEW 2026-05-21 issue #398 F2]
[UPDATED 2026-05-21 adversarial review round 1: MIN-3 Trace repointed to prd-delta-398.md §2 (locked decisions)]
[UPDATED 2026-05-21 adversarial review round 2: F-7 output channel profile explicit (all three lines to stderr; stdout empty)]
[UPDATED 2026-05-21 adversarial review round 3: COS-1 H1 title drops erroneous KEY token; MED-4 output channel profile reclassified from profile 5 (No-log facade) to profile 4 (Symmetric)]
[UPDATED 2026-05-21 adversarial review round 4: F-1 profile-4 carve-out paragraph added; F-3 VP-398-001 fixture constraint + No-team-matching substring assertion; O-2 EC-3.4.014-3 exit code pinned to 64]
[UPDATED 2026-05-21 adversarial review round 5: F-1 VP-398-001 negative case rewritten as direct unit-level is_team_uuid assertion; F-3 EC-3.4.014-5 added]
[UPDATED 2026-05-21 adversarial review round 7: F-1 VP-398-001 + explicit module-private placement sentence]
[UPDATED 2026-05-21 adversarial review round 8: IMP-5 EC-3.4.014-3/5 wording softened; VP-398-005 added]
[REVISED 2026-05-22 human-gate: BC-3.4.014 broadened from team-only echo to ALL set fields echo, mirroring BC-3.4.012; label/assignee decisions documented; EC-3.4.014-6..10 added; VP-398-006 added; JSON-mode note added; obsolete "ONLY --team" scope sentence removed]
[UPDATED 2026-05-22 re-convergence pass 1-3: EC-3.4.014-11 added (--points f64::to_string() format assertions, mirrors EC-3.4.012-5); EC-3.4.014-12 added (empty-string --summary echo, mirrors EC-3.4.012-12); EC-3.4.014-13 added (--points without story_points_field_id configured → ConfigError exit 1, mirrors EC-3.4.012-11)]

---

#### BC-3.4.015: `issue edit KEY --field NAME=VALUE` (string/number/date/datetime/user field, single-key path) — resolves field name, validates against editmeta, serializes per type, PUTs; success echoes field in `changed_fields`

**Confidence**: HIGH
**Source**: issue #396 F2 spec evolution; `src/cli/issue/edit.rs::handle_edit` (single-key success path, extended); `src/api/jira/issues.rs::get_editmeta` (new); `src/cli/issue/field_resolve.rs::resolve_edit_fields` (new, owns field-lookup and ambiguity handling); `.factory/research/issue-396-jsm-fields-validation.md`
**Subject**: Issue write

**Description**: On the single-key `issue edit KEY --field NAME=VALUE` path, for fields
whose `editmeta` schema type is `string`, `number`, `date`, `datetime`, or `user`:
the handler resolves the field name to its `customfield_NNNNN` id, confirms the field
is on the Edit screen via `editmeta`, serializes `VALUE` per the schema type, and PUTs
it alongside any other changed fields. Successful resolution inserts the field into the
`changed_fields` BTreeMap (key: human field name or `customfield_NNNNN` literal; value:
the raw `VALUE` string), so it appears in the BC-3.4.012 table-mode echo and the
BC-3.4.013 JSON-mode `changed_fields` object.

**`resolve_edit_fields` canonical signature** (as of F2 amendment, P2-006 corrected, F-1 reconciled):
`resolve_edit_fields(client: &JiraClient, profile: &str, key: &str, field_pairs: &HashMap<String, String>, fields: &mut Value, changed_fields: &mut BTreeMap<String, String>) -> Result<()>`

The `field_pairs` parameter is `&HashMap<String, String>` (NOT `&[(String, String)]`) because `parse_field_kv` (the upstream parser at `src/cli/issue/create.rs::parse_field_kv`) returns `HashMap<String, String>`. `parse_field_kv` uses `map.insert(key, value)` with last-wins semantics — duplicate `--field` keys are collapsed AT PARSE TIME, before `resolve_edit_fields` ever runs. An ordered slice would be structurally incompatible with this upstream output. `HashMap` is the correct type at this boundary.

The `profile: &str` parameter (second arg, after `client`) is REQUIRED because `read_fields_cache(profile)` and `write_fields_cache(profile, ...)` are called inside this function. Per the CLAUDE.md hard rule: every cache reader/writer takes `profile: &str`; cross-profile leakage is a correctness bug (sandbox vs prod custom-field IDs can differ). The caller passes `&config.active_profile_name`.

The function mutates the caller's `fields` JSON object and `changed_fields` map in place; returns `Ok(())` on full success or `Err` on any resolution failure. The divergent F1 line-141 form `-> Result<(Value, Vec<(String,String)>)>` (which also lacked `profile` and used `Vec`) is **superseded** by this signature; the `&mut` + `HashMap` form avoids allocations and is structurally consistent with the upstream parser output. Any implementation that uses the F1 form must be updated before merge.

**Field-name resolution algorithm** (per `resolve_edit_fields`):

1. If `NAME` matches `customfield_\d+` (case-sensitive): bypass Steps 2–2b; use `NAME`
   as the field ID. This is the same bypass used by `parse_field_kv` on the JSM
   create path (BC-3.8.008).
2. **Cache-first field-list fetch** (new per F2 amendment): read
   `~/.cache/jr/v1/<profile>/fields.json` (`read_fields_cache(profile)`).
   - **Cache hit (non-stale, ≤7 days old)**: use the cached `Vec<(id, name)>` directly.
     No `GET /rest/api/3/field` HTTP call is made.
   - **Cache miss or stale**: call `list_fields()` (→ `GET /rest/api/3/field`). On
     success, write the result to `fields.json` via `write_fields_cache(profile, &fields)`
     using the **best-effort writer pattern** (see invariant 6). The fetched result is
     used for this invocation regardless of whether the cache write succeeds.
   - The field list (from cache or API) is shared across all `--field` pairs in the same
     invocation — at most one cache read and at most one API call per `issue edit`
     invocation, regardless of how many `--field` pairs are supplied.
2b. Perform case-insensitive exact match first against the field list; if no exact match,
   perform case-insensitive substring match.
   - Zero matches → `JrError::UserError` with hint to use `jr project fields` or
     supply `customfield_NNNNN` directly. Exit 64.
   - Multiple substring matches → `JrError::UserError` naming the ambiguous candidates.
     Exit 64.
   - Single match → use its `id`.
3. Call `get_editmeta(key)` (→ `GET /rest/api/3/issue/{key}/editmeta`). If the
   resolved field ID is absent from `editmeta.fields` → `JrError::UserError` with
   Edit-screen actionable message (exact substrings: `"is not on the Edit screen"` and
   `"A project admin must add it to the Edit screen"` — verified from
   `src/cli/issue/field_resolve.rs` Step 3 error). Exit 64. This applies to BOTH the
   name-resolved path AND the `customfield_NNNNN` literal bypass path. The `editmeta`
   response is NOT cached (see non-goal note below).
3b. **Operations check** (new, P3-LOW-002): inspect `editmeta.fields[id].operations`.
   If `"set"` is NOT present in the list → `JrError::UserError`: "field '<NAME>'
   does not support direct `set` via the edit API (operations: [<actual_ops>]). Use
   the Jira web UI or check with your project admin." Exit 64. No PUT attempted.
   This guards against fields that are present on the Edit screen but are read-only
   (e.g., system-managed computed fields) — a PUT for such a field would be rejected
   by the server anyway; catching it early gives a more actionable error. Standard
   editable custom fields always include `"set"` in their `operations` array.
4. Read `editmeta.fields[id].schema.type` and serialize `VALUE`. Full type dispatch
   matrix (F-4: `option` explicitly anchored here so this step covers all types):
   - `string` or `text`: bare JSON string.
   - `number`: parse `VALUE` as `f64` (error → exit 64 if non-numeric or non-finite).
     Wire: JSON number. See EC-3.4.015-4 and EC-3.4.015-4a.
   - `date` / `datetime`: bare JSON string (no client-side ISO 8601 validation; server
     validates). See VP-396-011.
   - `user`: `{"accountId": VALUE}`. Caller supplies raw `accountId`. See VP-396-011.
   - **`option`**: → dispatch to BC-3.4.016 Step 4a. Resolve `VALUE` against
     `editmeta.fields[id].allowedValues` (human label → option `id`); wire payload is
     `{"id": "<optionId>"}`. `resolve_edit_fields` delegates the option-value resolution
     step to the same code path as BC-3.4.016. This arm must be handled BEFORE the
     unknown→exit-64 arm — `option` is a known, supported type.
   - `array` / `any` / unknown: `JrError::UserError` naming the unsupported type with
     a hint. Exit 64.
5. Merge the resolved `(field_id, serialized_value)` pair into the shared `fields`
   JSON object (same object used by all other `issue edit` flags).
6. After successful resolution: insert `(human_name_or_field_id, VALUE)` into
   `changed_fields`. For the `customfield_NNNNN` literal bypass path, the key is the
   literal `customfield_NNNNN` string. For name-resolved fields, the key is the human
   name as it was supplied in `--field NAME=VALUE` (not the resolved `customfield_*` id).

**Non-goal — `editmeta` is NOT cached**: The `GET /rest/api/3/issue/{key}/editmeta`
response is issue-specific and mutable (an admin can change the Edit screen at any
time). Caching it would risk stale `allowedValues` producing wrong option IDs on the
wire. No `editmeta` cache is planned for v1. This is a deliberate non-goal and must
not be flagged as a gap by reviewers.

**Preconditions**:
- `jr issue edit <key> --field NAME=VALUE [--field ...]` issued on the single-key path.
- No flag-overlap (BC-3.4.017 Gate B passes).
- No multi-key context (BC-3.4.017 Gate A passes).
- At least one other field flag OR `--field` alone satisfies `has_any_field_change`.
- PUT 204 received from Jira API.

**Postconditions**:
- Exit code 0.
- The field is updated on the Jira issue.
- `changed_fields` contains the `--field` key/value entries alongside any other changed
  fields, in BTreeMap alphabetical order.
- Table-mode stderr: `  <NAME> → <VALUE>` echo line (consistent with BC-3.4.012).
- JSON-mode stdout: `changed_fields["<NAME>"] == "<VALUE>"` (consistent with BC-3.4.013).
- `GET /rest/api/3/field` is NOT called when a warm (non-stale) `fields.json` cache
  exists for the active profile. At most one `GET /rest/api/3/field` call per invocation
  regardless of how many `--field` pairs are supplied.
- `fields.json` cache is populated on a cache miss; the populated file persists for
  subsequent invocations (7-day TTL, same as all other jr caches).
- `get_editmeta(key)` is called AT MOST ONCE per invocation (the response is shared
  across all `--field` pairs).
- `get_editmeta` is NOT called when `--field` is absent (no latency added to existing
  `issue edit` invocations).

**Invariants**:
1. `--field` pairs are resolved AFTER all existing flag resolutions (description,
   summary, type, priority, team, points, no_points, parent, no_parent). The
   `resolve_edit_fields` call is the last step before `client.edit_issue`.
2. The `changed_fields` map key for a `--field` entry is the human-supplied `NAME`
   (or the `customfield_NNNNN` literal for bypass calls) — never the internal
   `customfield_NNNNN` ID when a name was resolved.
3. The `fields` JSON object is the same object used by all other flags. The
   `--field` entries are merged into it, not a separate object.
4. On PUT failure (non-204 response), the constructed `changed_fields` entries for
   `--field` are discarded (same invariant as BC-3.4.012 invariant 6 — map emitted
   only post-204).
5. The `number` type serialization uses i64 parse first; falls back to f64 for decimals,
   scientific notation, and out-of-i64-range integers. Wire value is i64 for exact integer
   inputs (Stage 1), f64 for non-integer inputs OR integer inputs whose f64 representation
   rounds outside the safe i64 range (Stage 2 with strict bounds: `parsed > (i64::MIN as f64)`
   AND `parsed < (i64::MAX as f64)`). NaN and Inf inputs are rejected upstream. If `VALUE`
   cannot be parsed as either i64 or f64, exit 64 before the PUT. See EC-3.4.015-4a
   (i64 wire form for integer inputs) and EC-3.4.015-4b (f64 wire form for i64-boundary inputs).
6. **Field-list cache contract** (mirrors `CmdbFieldsCache` / `cmdb_fields.json` pattern
   in `src/cache.rs`): the `fields.json` cache stores `Vec<(String, String)>` — `(id, name)`
   tuples — under `~/.cache/jr/v1/<profile>/fields.json`, 7-day TTL, per-profile. The
   struct is `FieldsCache { fields: Vec<(String, String)>, fetched_at: DateTime<Utc> }`
   implementing `Expiring`. Read function: `read_fields_cache(profile: &str) -> Result<Option<FieldsCache>>`.
   Write function: `write_fields_cache(profile: &str, fields: &[(String, String)]) -> Result<()>`.
7. **Best-effort writer** (`write_fields_cache`): cache write failures are swallowed via
   `eprintln!("warning: failed to write fields cache: {e}")` and the function returns
   `Ok(())`. This follows the request-type cache writer pattern (`write_request_type_cache`
   in `src/cache.rs`): a missed cache write costs at most one extra HTTP call on the
   next invocation — it must NEVER fail a successful field resolution. The writer's
   rustdoc MUST document this choice with: "Best-effort: disk-write errors are logged to
   stderr and swallowed; callers always proceed with the fetched result."
8. **Cache is a read-acceleration shortcut only** — not correctness-critical. The global
   field list changes only when Jira admins add/remove custom fields (infrequent). A
   7-day stale cache in the worst case causes a name-resolution failure against a newly
   added field (user can clear via cache path or supply `customfield_NNNNN` directly).
9. The `editmeta` response is NEVER cached. See non-goal note above the algorithm.
10. **`resolve_edit_fields` MUST be called INSIDE the `--dry-run` block** (before the
    `return Ok(())` short-circuit), NOT after it. The existing `--dry-run` block in
    `src/cli/issue/edit.rs` (~lines 366-559) is self-contained and short-circuits with
    `return Ok(())` at ~line 559. Any code placed AFTER the dry-run block never executes
    under `--dry-run`. Therefore: `resolve_edit_fields` (Steps 1–6) must be invoked
    within the dry-run path so that (a) the resolved `--field` entries appear in the
    planned-changes preview table/JSON, and (b) resolution failures (zero-match, bad type,
    absent from `editmeta`, `"set"` absent from `operations`) still propagate as `Err`
    and exit 64 even under `--dry-run`. The PUT (Step 6 `client.edit_issue`) must NOT be
    called inside the dry-run path. Concrete placement: the dry-run path runs parse →
    Gate B → Gate A → existing-flag resolutions → `resolve_edit_fields` →
    render-preview → `return Ok(())`. The live path runs the same steps but replaces
    render-preview with `client.edit_issue` → success-echo.

**Edge Cases**:
- EC-3.4.015-1: `--field "Unknown Field=Value"` — zero matches in `list_fields()` →
  exit 64 with actionable hint naming `jr project fields` as a discovery tool.
- EC-3.4.015-2: `--field "Sum=Value"` — multiple substring matches (e.g., "Summary",
  "Sum Total") → exit 64 naming the ambiguous candidates with their `customfield_NNNNN`
  IDs to help the caller use the literal bypass.
- EC-3.4.015-3: Field found in `list_fields()` but absent from `editmeta` (not on Edit
  screen) → exit 64. stderr contains BOTH substrings `"is not on the Edit screen"` and
  `"A project admin must add it to the Edit screen"` (exact substrings from
  `src/cli/issue/field_resolve.rs` Step 3 error, verified from source).
- EC-3.4.015-4: Number field (`schema.type: "number"`) with a non-numeric or non-finite
  `VALUE` → exit 64 with parse error message. No PUT attempted. Two distinct failure
  modes: (a) `"abc".parse::<f64>()` fails at parse → exit 64 immediately; (b) `"inf"` or
  `"nan"` parse successfully as `f64` but `serde_json::Number::from_f64(v)` returns
  `None` for non-finite values (NaN, +Inf, -Inf) → exit 64 at the JSON-number
  construction step. Both paths produce the same user-facing exit 64; see EC-3.4.015-4a
  for the integer-representation invariant on success.
- EC-3.4.015-4a: Number field with `VALUE = "5"` (integer input) → parses to `f64(5.0)`
  → wire value is the JSON number `5` (NOT `5.0`). The `serde_json` `Number` type
  preserves the integer representation when `f64` has no fractional part (i.e., `5.0_f64`
  serializes as `5`, not `5.0`). Implementation: use `serde_json::Number::from_f64(v)`
  (returns `Option`; error if NaN/Inf → exit 64). VP-396-010 pins this invariant.
  `5e3` round-trips as `5000` (serde_json normalizes scientific notation to integer form
  when the value is a whole number). `5.5` serializes as `5.5`.
- EC-3.4.015-4b: Number field with `VALUE` representing an integer outside the i64 range —
  e.g., `"9223372036854775808"` (i64::MAX + 1 = 2^63), or `"-9223372036854775809"` (i64::MIN - 1) —
  MUST emit the f64 JSON wire form, NOT a silently-saturated i64.

  Implementation rationale: `i64::MAX as f64` rounds UP to `9223372036854775808.0` (2^63) because
  f64 cannot exactly represent every integer above 2^53. A naive predicate `parsed <= i64::MAX as f64`
  passes the boundary value, and the subsequent `as i64` cast saturates silently (Rust 1.45+ behavior).
  The two-stage parser eliminates this: Stage 1 (`value.parse::<i64>()`) rejects out-of-range integers
  cleanly; Stage 2 (f64 fallback) uses strict inequalities (`>` lower, `<` upper) on both bounds so
  the boundary cannot collide.

  Test pins (regression):
  - `"9223372036854775808"` → f64 wire (NOT i64 `9223372036854775807` saturated)
  - `"-9223372036854775809"` → f64 wire (NOT i64 `-9223372036854775808` saturated)

  Source: issue #421 (filed from Copilot review on PR #418); Perplexity-validated against
  Rust language reference + f64 docs 2026-05-27.
- EC-3.4.015-5: Field has `schema.type: "array"` or `schema.type: "any"` → exit 64
  with message naming the unsupported type and suggesting the Jira UI or a future
  `--field` v2 for multi-value support.
- EC-3.4.015-6: `list_fields()` API failure (401/403/5xx) → propagated via `?`. The
  error surfaces as a standard auth/API error using the existing error-hint infrastructure
  (`API_TOKEN_EXPIRY_HINT` on 401, raw message on other statuses). No PUT attempted.
- EC-3.4.015-7: `get_editmeta` API failure (including 404 = unknown issue key) →
  propagated via `?`. Same error surface as EC-3.4.015-6.
- EC-3.4.015-8: `customfield_NNNNN` literal bypass — field absent from `editmeta` →
  exit 64 with Edit-screen hint using the literal `customfield_NNNNN` as the field
  name in the message. Same error as EC-3.4.015-3 but triggered without a `list_fields()`
  round-trip.
- EC-3.4.015-9: `--field =VALUE` (empty `NAME`) → `parse_field_kv` splits on the first
  `=` and returns `Ok(("", "VALUE"))` (no error — the string contains `=`). The empty key
  falls through to Step 2b name resolution and exits 64 via the zero-match path (same as
  EC-3.4.015-1: zero matches → exit 64 with actionable hint). There is no dedicated
  empty-NAME guard in `parse_field_kv`; the zero-match exit path in `resolve_edit_fields`
  is the sole error handler for empty NAME.
- EC-3.4.015-10: `--field NAME` (no `=` in the argument) → parse error at
  `parse_field_kv` → exit 64.
- EC-3.4.015-11: `--field NAME=` (empty `VALUE`, name present) → allowed. Empty string
  is a legal value for string fields and is passed to Jira. Jira validates required
  fields server-side; optional string fields may be cleared with an empty value.
- EC-3.4.015-12: Multiple `--field` pairs in one invocation — all share the same
  field list (from cache or single API fetch) and the same `editmeta` result. If any
  pair fails resolution (e.g., `--field A=ok --field B=bad` where `B` is absent from
  `list_fields()`), `resolve_edit_fields` returns `Err` on the first failing pair; the
  entire call fails with exit 64 and zero PUT is attempted. `changed_fields` is discarded
  (never emitted). VP-396-009 pins this all-or-nothing invariant.
- EC-3.4.015-12a: Valid `--field` with a PUT mock returning 400 → the resolution
  succeeds (exit 64 is NOT triggered at the resolution stage); the PUT is attempted; the
  400 surfaces as a `JrError` with the server's error body; exit code reflects failure
  (exit 1 or as mapped by `JrError`). `changed_fields` is discarded (invariant 4:
  emitted only post-204). VP-396-009 pins this path. No `  NAME → VALUE` echo is
  emitted on table mode; no `changed_fields` key appears in JSON mode.
- EC-3.4.015-13: `--field` and other flags (`--summary`, `--priority`, etc.) in the
  same invocation — the `fields` JSON object contains entries from both sources; the
  single PUT carries all changes simultaneously. The `changed_fields` map contains
  entries from both sources in alphabetical key order.
- EC-3.4.015-14: **Cache hit** — `~/.cache/jr/v1/<profile>/fields.json` exists and is
  ≤7 days old → field list is loaded from cache; `GET /rest/api/3/field` is NOT called.
  The resolution and PUT proceed normally. VP-396-006 verifies this invariant.
- EC-3.4.015-15: **Cache miss or stale** — `fields.json` absent or >7 days old → `GET
  /rest/api/3/field` is called; result is written to `fields.json` via the best-effort
  writer; resolution proceeds with the fetched list. Subsequent invocations within 7
  days skip the HTTP call.
- EC-3.4.015-16: **Cache-write failure** — disk full, permissions error, or other I/O
  failure during `write_fields_cache` → `eprintln!("warning: failed to write fields
  cache: ...")` is emitted to stderr; the function returns `Ok(())`. The current
  invocation proceeds with the fetched field list and resolves normally; exit code is
  NOT affected by the cache-write failure. The next invocation will encounter a cache
  miss (and attempt another fetch + write).

- EC-3.4.015-17: `--field CUSTOMFIELD_10001=Value` (mixed/upper-case `customfield_`
  prefix) → the bypass regex `customfield_\d+` is case-sensitive (Rust `Regex::is_match`
  on a lowercase-only pattern). `CUSTOMFIELD_10001` does NOT match the bypass. It falls
  through to Step 2b name resolution. If no field named `CUSTOMFIELD_10001` exists in
  the cached/fetched field list, exit 64 via the zero-match path with the standard
  actionable hint ("use `jr project fields` or supply the lowercase `customfield_NNNNN`
  literal directly"). This is a deliberate design choice: the Jira Cloud REST API uses
  lowercase `customfield_` prefix in all API responses; accepting uppercase would mask
  typos and create a second bypass surface. Users must supply the exact lowercase literal
  to activate the bypass.
- EC-3.4.015-18: `--field NAME=VALUE --dry-run` → Gate A and Gate B still fire (the
  guards are evaluated before any HTTP, including under `--dry-run`). If the gates pass,
  `resolve_edit_fields` is called INSIDE the `--dry-run` block (before the `return Ok(())`
  short-circuit) — see invariant 10 for the mandatory control-flow placement. The
  read-only HTTP calls (`GET /rest/api/3/field` / cache read, `GET /rest/api/3/issue/
  {key}/editmeta`) execute within `resolve_edit_fields` as they would on the live path.
  The PUT is NOT issued. The planned-changes preview (same as BC-3.4.012 EC-3.4.012-9
  behavior) reflects the resolved `--field` entries in the preview table.
  **Exit code: 0** (the dry-run block returns `Ok(())` — confirmed from source at
  `src/cli/issue/edit.rs` ~line 559: `return Ok(());` at the end of the dry-run block).
  Mirrors EC-3.4.012-9. Implementers MUST NOT place `resolve_edit_fields` after the
  dry-run `return Ok(())` — it would silently skip `--field` preview and never surface
  resolution failures under `--dry-run`.
- EC-3.4.015-19: **Resolution failure under `--dry-run`** — if field resolution fails
  (zero-match, ambiguous name, unsupported type, field absent from `editmeta`, or
  `"set"` absent from `operations`) while `--dry-run` is set, the resolution error is
  still surfaced with **exit 64**. The dry-run preview is NOT rendered when resolution
  fails: the read-only HTTP calls (`list_fields()`, `editmeta`) run as normal, but if
  they produce an error before the preview is rendered, `resolve_edit_fields` returns
  `Err` and the error propagates through `handle_edit` as a standard `JrError`. The
  `--dry-run` flag does not suppress or defer resolution errors — it only suppresses
  the PUT and redirects the success path to a preview. VP-396-008 covers the
  resolution-failure-under-dry-run sub-case.
- EC-3.4.015-20: **`operations` lacks `"set"`** — field is present in `editmeta` (Step 3
  passes), but `editmeta.fields[id].operations` does not contain `"set"` → Step 3b fires
  → exit 64 with hint naming the field and its actual operations list. No PUT attempted.
  This covers computed/read-only fields that appear on the Edit screen but cannot be set
  via the API. VP-396-012 verifies this path.

**Verification Properties**:
- VP-396-001: String/number `--field` value appears in `changed_fields` echo (table and
  JSON); human name as key; `customfield_NNNNN` literal bypass skips field-list fetch
  entirely.
- VP-396-003: Field absent from `editmeta` → exit 64 with Edit-screen actionable hint;
  no PUT issued.
- VP-396-004: Unsupported field types (`array`, `any`) → exit 64 with hint; no PUT issued.
- VP-396-006: Warm `fields.json` cache (non-stale) → no `GET /rest/api/3/field` HTTP
  call; field resolution and PUT still succeed.
- VP-396-007: Cache-write failure (`write_fields_cache` I/O error) → `warning:` line on
  stderr, exit 0, resolution and PUT succeed (best-effort swallow positively tested).
- VP-396-008: `--field` + `--dry-run` → success path exits 0; read-only HTTP (cache,
  `editmeta`) fires; PUT NOT issued; resolution failure under `--dry-run` still exits 64;
  dry-run succeeds when editmeta contains allowedValues entries with absent `id` on
  non-targeted fields (AllowedValue.id is Option<String>; absent entries do not fail
  deserialization). See VP-589-001 for the standalone deserialization assertion.
- VP-396-009: Multi-`--field` partial-failure and PUT-failure discard `changed_fields`.
- VP-396-010: Number field `f64` wire serialization — integer inputs produce exact integer
  JSON output (`5` → `5`, NOT `5.0`).
- VP-396-011: `user`-type wire shape `{"accountId": VALUE}` and `date`/`datetime`
  bare-string pass-through are present on wire; claimed in BC-3.4.015 Step 4.
- VP-396-012 (P3-LOW-002): field present in `editmeta` but `"set"` absent from
  `operations` → exit 64 with actionable hint; no PUT.
- VP-589-001: editmeta response with allowedValues entries lacking `id` on any
  non-targeted field deserializes without serde error; a targeted string-type field
  edit proceeds normally (AllowedValue.id typed as Option<String>). Covers GDPR-era
  user/group picker fields where Jira omits `id` from allowedValues entries.

**Trace**: issue #396 F2; `src/cli/issue/edit.rs::handle_edit` (resolution integration); `src/api/jira/issues.rs::get_editmeta` (new); `src/cli/issue/field_resolve.rs::resolve_edit_fields` (new, orchestrates resolution pipeline — owns exact-match-then-substring logic and all exit-64 ambiguity handling; any field-lookup helper it calls is an implementation detail not spec-anchored here); `src/types/jira/editmeta.rs` (new — `EditMeta`, `EditMetaField`, `EditMetaFieldSchema`, `AllowedValue`; `AllowedValue.id` typed `Option<String>` per issue #589 SOH-BUGS-1); `src/cache.rs::FieldsCache` / `read_fields_cache` / `write_fields_cache` (new, mirrors `CmdbFieldsCache` / `cmdb_fields.json` pattern; best-effort writer); `.factory/research/issue-396-jsm-fields-validation.md`; `.factory/research/issue-589-editmeta-allowedvalue-id-2026-07-08.md`; `.factory/phase-f2-spec-evolution/prd-delta-396.md §3 and §5`

[NEW 2026-05-22 issue #396 F2]
[AMENDED 2026-05-22 F2 cache gap: field-list cache (fields.json, 7-day TTL, best-effort writer) specified; editmeta non-goal stated; EC-3.4.015-14..16 added; invariants 6-9 added; VP-396-006 cited]
[AMENDED 2026-05-22 adversary pass 3: Step 3b (operations/"set" check) added; EC-3.4.015-19 (resolution failure under --dry-run, exit 64) added; EC-3.4.015-18 exit code pinned to 0; VP-396-011 (user/date/datetime wire) and VP-396-012 (operations check) added]
[AMENDED 2026-07-09 issue #589 SOH-BUGS-1: VP-396-008 extended (dry-run succeeds when editmeta contains idless allowedValues on non-targeted fields; AllowedValue.id typed Option<String>); VP-589-001 added (deserialization succeeds for id-absent allowedValues entries; targeted string-type edit proceeds normally); Trace updated with AllowedValue.id Option<String> note and research file reference]

---

#### BC-3.4.016: `issue edit KEY --field NAME=VALUE` (single-select `option` field) — resolves human option value to `allowedValues[].id`, sends `{"id":"<id>"}` on wire; `changed_fields` echo shows human label

**Confidence**: HIGH
**Source**: issue #396 F2 spec evolution; `src/cli/issue/edit.rs::handle_edit`; `src/api/jira/issues.rs::get_editmeta`; `src/cli/issue/field_resolve.rs::resolve_edit_fields` (option-arm: id-bypass, case-insensitive exact→substring on allowedValues, ambiguity/empty errors); `.factory/research/issue-396-jsm-fields-validation.md §Q2`
**Subject**: Issue write

**Description**: When `editmeta` reports `schema.type == "option"` for the resolved
field, the handler additionally resolves the human-readable `VALUE` to the numeric
option `id` from `editmeta.fields[id].allowedValues`. The wire payload uses the
`{"id": "<optionId>"}` shape required by the Jira Cloud REST API for single-select
custom fields. The `changed_fields` echo shows the human option label (not the id),
keeping the output readable for both table and JSON consumers.

This BC builds on BC-3.4.015 (same field-name resolution, `editmeta` fetch, and
merge steps apply). Only Step 4 differs: instead of bare-string serialization, the
option value is resolved to its `id` before building the wire fragment. **The
cache-first field-list fetch from BC-3.4.015 invariants 6–8 applies here equally** —
field-name resolution reads from `fields.json` before falling back to `GET
/rest/api/3/field`; the `editmeta` response remains uncached.

**Option value resolution** (Step 4a, applied after `schema.type == "option"` is
detected):

1. If `VALUE` matches an `allowedValues[].id` exactly (numeric string comparison) →
   use that `id` as-is (id-bypass path). Entries where `id` is absent (`None`) are
   silently excluded from this comparison and fall through to label matching (Step 2);
   they do not participate in the id-bypass regardless of the input value. The
   `changed_fields` echo value is `VALUE` (the raw literal, not a reverse-looked-up
   label — no label resolution occurs on the id-bypass path).
2. Otherwise: perform case-insensitive exact match on `allowedValues[].value`.
   If no exact match, perform case-insensitive substring match.
   - Zero matches → `JrError::UserError` listing allowed values (e.g., "Allowed values:
     High, Medium, Low"). Exit 64.
   - Multiple substring matches → `JrError::UserError` listing ambiguous candidates with
     their ids (e.g., "value 'H' is ambiguous — found: High (id=10286), Unknown (id=10299).
     Specify the exact value."). Exit 64.
   - `allowedValues` is empty or absent → `JrError::UserError` ("field 'NAME' has no
     configured option values. Confirm the field is set up correctly in your Jira
     project admin."). Exit 64.
   - Single match → use its `id`. `changed_fields` echo value is the matched
     `allowedValues[].value` (the stored label, not the user's query casing).

Wire payload: `{"fields": {"customfield_NNNNN": {"id": "<optionId>"}}}`.

`changed_fields` key: human field name (or `customfield_NNNNN` literal for bypass).
`changed_fields` value: matched `allowedValues[].value` (stored label) — NOT the
option `id`. Exception: when the id-bypass path fires, `changed_fields` value is
`VALUE` (the id literal).

**Preconditions**:
- Same as BC-3.4.015 (single-key path, no flag-overlap, no multi-key context, PUT 204).
- `editmeta.fields[id].schema.type == "option"`.
- `allowedValues` is populated (non-empty) for single-match case.

**Postconditions**:
- Exit code 0.
- PUT body contains `{"customfield_NNNNN": {"id": "<resolvedOptionId>"}}`.
- `changed_fields["<NAME>"]` == matched option label (stored casing from `allowedValues[].value`),
  NOT the option `id`, NOT the user's query casing.
- Table-mode stderr: `  <NAME> → <matched_label>` echo (consistent with BC-3.4.012).
- JSON-mode `changed_fields["<NAME>"]` == `"<matched_label>"` (consistent with BC-3.4.013).

**Invariants**:
1. The wire payload for `option`-type fields MUST use `{"id": "<optionId>"}`. Sending
   `{"value": "..."}` is rejected by the Jira Cloud REST API (confirmed in research Q2).
2. The `changed_fields` value is the STORED label (casing from `allowedValues[].value`),
   not the user's query string. Case-insensitive matching but stored-casing echo.
3. The option `id` is never exposed in the `changed_fields` echo (for the name-match
   path). The id appears only on the wire and in the server's response.
4. The id-bypass path (when `VALUE` is an exact numeric match to an `allowedValues[].id`)
   does not perform a reverse lookup — the echo value is the raw id. Entries where `id`
   is absent (`None`) are excluded from the id-bypass comparison — they never trigger
   this path regardless of the input value.

**Edge Cases**:
- EC-3.4.016-1: `allowedValues` is empty or absent for the `option`-type field → exit
  64 with "field has no configured option values" message. This is unusual but possible
  for misconfigured fields.
- EC-3.4.016-2: `VALUE` matches no `allowedValues[].value` → exit 64 listing the allowed
  values. The error message enumerates all `allowedValues[].value` strings to aid the caller.
- EC-3.4.016-3: `VALUE` is a substring match against multiple `allowedValues[].value`
  entries (e.g., `--field Urgency=h` matches "High" and "High Priority") → exit 64
  listing ambiguous candidates with their ids.
- EC-3.4.016-4: `VALUE` is a valid option `id` (numeric, e.g., `"10286"`) → id-bypass:
  used directly without `allowedValues[].value` lookup. `changed_fields` echo is `"10286"`.
  No reverse label lookup. This mirrors the `customfield_NNNNN` bypass for field names.
  Note: if an option `id` and an option `value` happen to be the same numeric string
  (e.g., id=`"42"` and another option value=`"42"`), the id-bypass wins — the numeric
  check is applied first. This is a deliberate disambiguation rule: id-bypass takes
  priority over label matching when the value string is purely numeric and matches an id.
- EC-3.4.016-5: Case-insensitive matching: `--field Urgency=high` (all lowercase) →
  matches `"High"` in `allowedValues` → `changed_fields` shows `"High"` (stored casing),
  not `"high"`.
- EC-3.4.016-6: `--field Urgency=HIGH` (all uppercase) → matches `"High"` →
  `changed_fields` shows `"High"` (stored casing).
- EC-3.4.016-7: Exact match takes precedence over substring: `"High"` with `VALUE="High"`
  (exact) → uses exact-match result, even if "High" is also a substring of "High Priority".
  Ambiguity is evaluated only when there is no exact match.
- EC-3.4.016-8: `resolve_edit_fields` matches an option by label/value (exact or
  substring path) but the matched `allowedValues` entry has no `id` field (`id=None`) —
  a wire payload `{"id": ...}` cannot be constructed. Exit 64 with message:
  "option '<VALUE>' has no machine-readable id and cannot be set via --field. This
  typically occurs with user/group picker fields. Use the Jira UI or the field's native
  picker to set this value." Load-bearing substrings in the exit-64 message:
  `"no machine-readable id"` and `"--field"`. This covers id-absent option entries
  introduced by GDPR accountId migration and plugin-defined fields. The id-bypass
  path (Step 1) is unaffected — id=None entries are silently excluded from id-bypass
  comparison before this EC can fire.

**Verification Properties**:
- VP-396-002: Option field resolves to `{"id": ...}` on wire (requires the matched
  allowedValues entry to have a non-None id — EC-3.4.016-8 exits 64 when id is
  absent); `changed_fields` echo shows human label (not id); case-insensitive
  matching; option-id bypass.
- VP-396-006: Warm `fields.json` cache (non-stale) → no `GET /rest/api/3/field` HTTP
  call; field-name resolution for option fields proceeds from cache; `editmeta` fetch
  and PUT still execute normally. (BC-3.4.016 inherits the cache-first behavior from
  BC-3.4.015 invariants 6–8 — the same `resolve_edit_fields` step 2/2b path is
  followed regardless of whether the field schema type is `string` or `option`.)

**Trace**: issue #396 F2; `src/cli/issue/edit.rs::handle_edit`; `src/cli/issue/field_resolve.rs::resolve_edit_fields` (option-arm: id-bypass, case-insensitive exact→substring on allowedValues, ambiguity/empty errors; id=None entries excluded from id-bypass per issue #589 SOH-BUGS-1); `src/api/jira/issues.rs::get_editmeta`; `src/types/jira/editmeta.rs::AllowedValue` (id field typed Option<String> per issue #589 SOH-BUGS-1); `.factory/research/issue-396-jsm-fields-validation.md §Q2` (wire format confirmed: `{"customfield_NNNNN": {"id": "..."}}` is the working shape); `.factory/research/issue-589-editmeta-allowedvalue-id-2026-07-08.md`; `.factory/phase-f2-spec-evolution/prd-delta-396.md §3`

[NEW 2026-05-22 issue #396 F2]
[AMENDED 2026-05-22 adversary pass 1: EC-3.4.016-4 id/label collision note; VP-396-006 added to Verification Properties]
[AMENDED 2026-07-09 issue #589 SOH-BUGS-1: EC-3.4.016-8 added (id=None matched entry → exit 64; load-bearing substrings "no machine-readable id" and "--field"); Step 1 id-bypass amended (id=None entries excluded silently, fall through to label matching); Invariant 4 extended (id=None never triggers id-bypass); VP-396-002 clarified ({"id":...} wire form requires non-None id); Trace updated with AllowedValue.id Option<String> and research file reference]

---

#### BC-3.4.017: `--field` multi-key/`--jql` multi-issue rejection (C-1 guard) + flag-overlap hard error for `summary`/`description`/`issuetype`/`priority`

**Confidence**: HIGH
**Source**: issue #396 F2 spec evolution; `src/cli/issue/edit.rs::handle_edit` (C-1 guard, `REJECTED_IN_BULK` set); `.factory/phase-f2-spec-evolution/prd-delta-396.md §3`
**Subject**: Issue write

**Description**: Two enforcement gates ensure `--field` is not misused in contexts
where its behavior is either undefined (bulk edit) or would silently overwrite an
explicitly-set flag value (flag overlap). Both gates fire BEFORE any HTTP call.

**Gate A — multi-key/`--jql` multi-issue rejection (C-1 guard):**

`--field` is added to the `REJECTED_IN_BULK` set in `handle_edit`. When the handler
detects 2+ positional keys, or when `--jql` resolves to 2+ issues, the C-1 block
fires with the same error pattern used by other bulk-rejected flags (`--parent`,
`--team`, `--description`): "Multi-key bulk edit doesn't yet support: `--field`. Use
a single key, or open an issue if this matters for your workflow." Exit 64.

`--jql` resolving to exactly ONE issue routes through the existing single-match fast
path and proceeds normally on the single-key path (consistent with BC-3.4.003 and
all other bulk-rejected flags).

**Gate B — flag-overlap hard error:**

If a dedicated flag and `--field` both target the same system field in the same
invocation:
- `--summary X --field summary=Y` (or `--field Summary=Y` — case-insensitive on the
  `--field NAME` side against the known system field keys)
- `--description X --field description=Y`
- `--type X --field issuetype=Y` (note: `--type` maps to the Jira system field key
  `issuetype`, not `type`)
- `--priority X --field priority=Y`

→ `JrError::UserError`: "<Field> is set by both --<flag> and --field; use only one."
Exit 64. NO HTTP call (no `list_fields()`, no `editmeta`, no PUT).

Gate B is evaluated at the top of `handle_edit`, after clap parsing (so both flag
values are in scope), but before any field resolution or HTTP calls. This ensures the
guard is O(1) and never causes a latency penalty.

**Scope of Gate B**: Exactly four first-party system fields (`summary`, `description`,
`issuetype`, `priority`). Team (`--team`) and points (`--points`/`--no-points`) use
dynamically-resolved custom field IDs; overlap detection for those would require an
API call, violating the "no HTTP before the guard" invariant. These are deferred to v2.

**Scope of Gate A**: `--field` is REJECTED_IN_BULK (not BULK_SUPPORTED). This is
intentional: the Jira Cloud Bulk API does not support arbitrary custom field writes;
adding bulk `--field` support would require a separate design pass.

**Preconditions for Gate A error**:
- 2+ positional keys supplied, OR `--jql` resolves to 2+ issues.
- `--field` is present.

**Preconditions for Gate B error**:
- At least one of the four dedicated flags (`--summary`, `--description`, `--type`,
  `--priority`) is present AND the corresponding system field key is targeted by a
  `--field NAME=VALUE` pair (case-insensitive key comparison).

**Postconditions (Gate A)**:
- Exit code 64.
- Stderr contains a message referencing `--field` and the bulk-rejection pattern.
- **Positional multi-key sub-case**: No HTTP calls are made (no JQL execution, no
  `list_fields()`, no `editmeta`, no PUT). The gate fires purely from argument count.
- **`--jql` multi-issue sub-case**: The JQL search IS executed to determine the matched
  issue count (you cannot know the count without running the query). Once 2+ results are
  detected, the gate fires. No `list_fields()`, no `editmeta`, no PUT is issued.
  The JQL call is the only HTTP call that occurs before the gate fires.

**Postconditions (Gate B)**:
- Exit code 64.
- Stderr contains the overlap error message naming the conflicting flag and field.
- No HTTP calls are made.

**Invariants**:
1. **Gate B is evaluated before Gate A.** When an invocation is BOTH multi-key AND flag-
   overlap (both conditions are simultaneously true), Gate B fires first: the flag-overlap
   error is emitted to stderr, Gate A is NOT evaluated, and exactly ONE error message
   reaches stderr. This ordering is intentional: a flag-overlap error is a programmer
   mistake that is equally invalid on any key count, and surfacing it directly is more
   actionable than a bulk-rejection that obscures the root cause.
2. The `REJECTED_IN_BULK` set partition test (the compile-time assertion in
   `test_343_every_edit_field_is_categorized` that partitions flags into `SELECTORS`,
   `BULK_SUPPORTED`, and `REJECTED_IN_BULK`) must be updated to include `--field`. This
   ensures the partition is exhaustive: `--field` appears in exactly ONE of the three
   sets. The `--label` conflict block's completeness against that partition is
   mechanically enforced by `test_label_conflict_block_lists_every_relevant_flag`
   (see EC-3.4.017-14).
3. `--jql` matching exactly ONE issue routes to the single-key path — this is NOT an
   error. Gate A only fires when `--jql` matches 2+ issues.
4. The flag-overlap comparison on the `--field NAME` side is case-insensitive against
   the canonical system field keys (`summary`, `description`, `issuetype`, `priority`).
   A `--field SUMMARY=X` or `--field Summary=X` is detected as an overlap for
   `--summary Y`.

**Edge Cases**:
- EC-3.4.017-1: `jr issue edit KEY1 KEY2 --field Urgency=High` → Gate A fires → exit
  64, bulk-rejection message.
- EC-3.4.017-2: `jr issue edit --jql "project = FOO" --field Urgency=High` when JQL
  matches 2+ issues → JQL search executes (required to determine match count) → Gate A
  fires → exit 64. No `list_fields()`, no `editmeta`, no PUT.
- EC-3.4.017-3: `jr issue edit --jql "key = FOO-1" --field Urgency=High` when JQL
  matches exactly 1 issue → Gate A does NOT fire → single-key path proceeds normally.
- EC-3.4.017-4: `jr issue edit KEY --summary "New title" --field summary=Other` →
  Gate B fires for `summary` → exit 64, overlap error, no HTTP.
- EC-3.4.017-5: `jr issue edit KEY --description "text" --field description=other` →
  Gate B fires for `description` → exit 64.
- EC-3.4.017-6: `jr issue edit KEY --type Bug --field issuetype=Task` → Gate B fires
  for `issuetype` (note: `--type` maps to the `issuetype` system field key, not `type`)
  → exit 64.
- EC-3.4.017-7: `jr issue edit KEY --priority High --field priority=Low` → Gate B
  fires for `priority` → exit 64.
- EC-3.4.017-8: `jr issue edit KEY --team "Platform Core" --field team=Other` → Gate B
  does NOT fire (team uses a dynamically-resolved custom field ID; deferred to v2) →
  both `--team` and `--field team=Other` are processed; last-write-wins in the `fields`
  JSON object. This is a known limitation documented in the CLAUDE.md Gotcha entry.
- EC-3.4.017-9: `jr issue edit KEY --field NAME=` (empty value) → Gate B does NOT fire
  (field overlap check requires matching a dedicated flag, not just any `--field` pair);
  empty value is allowed by BC-3.4.015 EC-3.4.015-11.
- EC-3.4.017-10: `jr issue edit KEY --field summary=A --field summary=B` (two `--field`
  pairs targeting the same system field, WITHOUT the dedicated `--summary` flag) → Gate B
  does NOT fire (Gate B requires the dedicated flag AND a `--field` pair for the same
  key; two `--field` pairs for the same key without the dedicated flag is not a Gate B
  condition). `parse_field_kv` (at `src/cli/issue/create.rs::parse_field_kv`) collapses the
  duplicate key AT PARSE TIME via `map.insert(key, value)` — the HashMap retains only
  the LAST value (`"B"`). `resolve_edit_fields` never sees both entries; it receives
  `{"summary": "B"}` as a single-entry `HashMap<String, String>`. No "second write"
  occurs inside `resolve_edit_fields` — the collapse happens before it is called.
  End state: `summary` is set to `"B"` on the wire. No error is produced.
  This is last-wins behavior, implemented entirely within `parse_field_kv` (BC-3.8.008).
- EC-3.4.017-11: `jr issue edit KEY --field type=Bug` (using `type` as the field name,
  not `issuetype`) → Gate B does NOT fire. The Gate B comparison checks whether the
  `--field NAME` key, lowercased, matches the canonical system field keys `summary`,
  `description`, `issuetype`, `priority`. The key `type` does NOT match `issuetype`.
  `--field type=Bug` is treated as an ordinary name lookup in `resolve_edit_fields` and
  proceeds to field-name resolution (Step 2b). Note: `--type` maps to the `issuetype`
  system field key in Jira; a `--field` pair targeting `issuetype` directly WOULD trigger
  Gate B when `--type` is also present. Using `type` (without `issue`) as a field name
  is a user error that surfaces as a resolution error (EC-3.4.015-1: zero matches or
  wrong field), not a Gate B conflict.
- EC-3.4.017-12: `jr issue edit KEY1 KEY2 --summary "New" --field summary=Other` →
  both multi-key (Gate A) AND flag-overlap (Gate B) conditions are true. Gate B fires
  first (evaluated before Gate A per invariant 1): the flag-overlap error is emitted to
  stderr, Gate A is NOT evaluated, and exit code is 64. Exactly one error message
  reaches stderr. The multi-key detection is not reached.
- EC-3.4.017-13: `jr issue edit KEY --label add:foo --field Severity=Critical` on a single
  key → exit 64 with `--label` conflict-block error. The `--label` short-circuit at
  `src/cli/issue/edit.rs::handle_edit § "Route: labels → bulk API"` routes to `handle_edit_bulk_labels` which does not accept
  `field_pairs`; without rejection before the routing decision the `--field` write silently
  drops (exit 0, data loss). The `--label` mutual-exclusion block in `handle_edit` rejects
  this combination before any HTTP call. Error: `"--label cannot be combined with --field in
  the same call. Run separate \`jr issue edit\` commands, or open an issue to track combined
  label + field bulk edits (see #331)."` Combined label + custom-field bulk edits tracked at
  #331. [FIX-F5-001]
- EC-3.4.017-14: The `--label` conflict block at
  `src/cli/issue/edit.rs::handle_edit::if !labels.is_empty()` is mechanically enforced
  complete by `test_label_conflict_block_lists_every_relevant_flag` (in `edit.rs::tests`).
  **Extraction strategy**: the meta-test parses the conflict-block source via
  `include_str!("edit.rs")` and extracts every `conflicting.push("--<flag>")` literal
  from the ENTIRE file (global extraction). This is safe because the local variable name
  `conflicting` is used exclusively within the `if !labels.is_empty() { ... }` block in
  `handle_edit`; if a future cycle introduces a second `conflicting` variable anywhere in
  `edit.rs`, the meta-test must be re-scoped to brace-matched extraction. A guard comment
  MUST be added in `edit.rs` at the conflict-block declaration site: `// NOTE: the variable
  name 'conflicting' is reserved for this block — test_label_conflict_block_lists_every_relevant_flag
  uses a global scan of conflicting.push("--...") in edit.rs`.
  **Expected set construction**: build a `BTreeSet<String>` (NOT `HashSet` — deterministic
  failure diffs across runs, mirrors `test_343_every_edit_field_is_categorized`) from
  `(BULK_SUPPORTED \ {"label"}) ∪ REJECTED_IN_BULK`. For each field, the kebab-case CLI
  flag name is the explicit `long = "<literal>"` value when present, otherwise the field
  name with underscores replaced by hyphens (clap's implicit default). Of the 12 fields
  currently in scope: `issue_type` carries `#[arg(long = "type")]` and maps to `--type`
  (NOT `--issue-type`); the other 11 (`summary`, `priority`, `team`, `points`,
  `no_points`, `parent`, `no_parent`, `description`, `description_stdin`, `markdown`,
  `field`) use the implicit snake→kebab transform. Any future field added to
  `BULK_SUPPORTED`/`REJECTED_IN_BULK` with a non-mechanical `long = "..."` rename will
  be caught by the R2 pin's 12-flag enumeration — the extractor side and the expected
  side must be reconciled together.
  **Assertion**: assert extracted `BTreeSet<String>` equals expected `BTreeSet<String>`.
  A regression that drops any `conflicting.push` line OR adds a new Edit field to
  `BULK_SUPPORTED`/`REJECTED_IN_BULK` without extending the conflict block fails this
  meta-test at `cargo test` time.
  **R2 pin**: include at least one pin test asserting the extractor correctly parses a
  known-good input string (e.g., assert extracted set has exactly 12 members for the
  current block: `--field`, `--summary`, `--priority`, `--type`, `--team`, `--points`,
  `--no-points`, `--parent`, `--no-parent`, `--description`, `--description-stdin`,
  `--markdown`. `--label` itself is the guard condition on the outer `if`, not a pushed
  entry).
  **Co-author**: 10 positive regression tests in `tests/issue_edit_field.rs`
  (`test_label_plus_<flag>_rejected_with_exit_64_no_http` for each of: `priority`, `type`,
  `team`, `points`, `no-points`, `parent`, `no-parent`, `description`, `description-stdin`,
  `markdown`). Test names use snake_case substitution for kebab-case flags
  (e.g., `--no-points` → `test_label_plus_no_points_...`; Rust identifiers cannot contain
  hyphens). Each test asserts exit 64, stderr contains `"--label cannot be combined with"`,
  and stderr contains the specific flag name as a SEPARATE assertion — not as one
  concatenated substring (the conflict block joins all conflicting flags into a single
  comma-separated message). For the `--markdown` test specifically: the invocation uses
  `--label add:x --markdown --description "text"`, which causes BOTH `--description` and
  `--markdown` to appear in the conflict output (`"--label cannot be combined with
  --description, --markdown in the same call. ..."`). Assert `stderr.contains("--markdown")`
  AND `stderr.contains("--label cannot be combined with")` as two separate checks, NOT
  `stderr.contains("--label cannot be combined with --markdown")` (that concatenation does
  not appear verbatim when `--description` precedes `--markdown` in the joined output). Note:
  the `--markdown` test uses `--label add:x --markdown --description "text"` because
  `--markdown` alone triggers an earlier guard at `edit.rs` ~line 87 before the conflict
  block; pairing with `--description` bypasses the early guard and reaches the conflict block,
  verifying the `--markdown` row. [Issue #407]

**Verification Properties**:
- VP-396-005: Multi-key/`--jql`-multi-issue rejection exits 64; flag-overlap hard error
  for `summary`, `description`, `issuetype`, `priority` exits 64 before any HTTP call.
- VP-396-008: `--field` + `--dry-run` → success path exits 0; Gate A/B still fire;
  read-only HTTP executes for preview; PUT NOT issued; resolution failure still exits 64;
  dry-run succeeds when editmeta contains allowedValues entries with absent `id` on
  non-targeted fields (issue #589 SOH-BUGS-1; AllowedValue.id is Option<String>).

**Trace**: issue #396 F2; `src/cli/issue/edit.rs::handle_edit` (`REJECTED_IN_BULK`
set update; Gate B overlap check; `has_any_field_change` update to include `--field`);
`.factory/phase-f2-spec-evolution/prd-delta-396.md §3`

[NEW 2026-05-22 issue #396 F2]
[AMENDED 2026-07-09 issue #589 SOH-BUGS-1: VP-396-008 extended (dry-run succeeds when editmeta contains idless allowedValues entries on non-targeted fields)]

---

#### BC-3.4.018: `issue edit KEY1 KEY2 --type <NAME>` multi-key bulk path — `editedFieldsInput["issueType"] = {"issueTypeId": "<id-string>"}` with `selectedActions: ["issuetype"]`; name resolved via `GET /rest/api/3/issue/createmeta/{proj}/issuetypes`

**Confidence**: HIGH
**Source**: issue #331 F2 spec evolution; `.factory/research/issue-331-issuetype-bulk-schema.md` (verified verbatim from Atlassian Bulk Operations FAQ — priority precedent BC confirmed live Jira #452); `tests/issue_bulk_pr2.rs` (new tests required in F4)
**Subject**: Issue write (bulk edit path)

**Description**: When `jr issue edit` is invoked with 2+ positional keys and `--type <NAME>`,
`handle_edit_bulk_fields` builds a `BulkEditRequest` for `POST /rest/api/3/bulk/issues/fields`.
This contract governs the canonical wire shape and the name→issueTypeId resolution mechanism.

**Preconditions**:
- 2 or more positional keys are supplied (all in the same Jira project — cross-project guard is BC-3.4.019).
- `--type <NAME>` is present (NAME is a user-supplied display name, e.g. `Bug`, `Story`, `Task`).
- `--no-input` is set or stdin is non-TTY (non-interactive execution assumed for all bulk paths).

**Postconditions**:
1. `GET /rest/api/3/issue/createmeta/{projectKey}/issuetypes` is called once before the bulk POST. The `projectKey` is derived from the common project prefix of all supplied keys (see Invariant 4 for extraction rule). The response is NOT cached (one-shot HTTP call per invocation, mirroring the priority resolver model).
2. The bulk `POST /rest/api/3/bulk/issues/fields` body contains:
   - `"selectedActions": ["issuetype"]` — the action string uses lowercase `"issuetype"` (system field id, NOT camelCase).
   - `"editedFieldsInput": {"issueType": {"issueTypeId": "<id-string>"}}` — the container key is camelCase `"issueType"`; the value object uses the string `issueTypeId`, NOT `name`. The id is a JSON string (e.g. `"10013"`), NOT an integer.
   - `"selectedIssueIdsOrKeys": [<keys>]` — all supplied keys are included.
3. The `selectedActions` element `"issuetype"` (lowercase) and the `editedFieldsInput` key `"issueType"` (camelCase) INTENTIONALLY differ. This asymmetry is confirmed by the verbatim Atlassian Bulk Operations FAQ example and mirrors the priority pattern (`selectedActions: ["priority"]`, container key `"priority"` — both lowercase there; for issueType the action string diverges from the container key casing). Do not "fix" them to match.
4. On a dry-run invocation (`--dry-run --output json`), the `plannedChanges` preview emits `"issueType"` as a bare string value (the type name, NOT `{"issueTypeId": "..."}`) — intentionally simplified, same model as the priority dry-run. The surrounding comment in the dry-run builder MUST NOT carry a "best-guess" or "unverified" qualifier for issueType after this fix ships.
5. On success, the async bulk task proceeds through the existing `await_bulk_task` / `BulkOperationProgress` poll loop (unchanged behavior; see BC-3.4.009 for the timeout/deadline contract).

**Invariants**:
1. The name→issueTypeId resolution is case-insensitive exact match on the `name` field returned by `GET .../createmeta/{proj}/issuetypes`. Substring matching (partial_match) MUST NOT be used here — it could resolve ambiguous names and produce incorrect type changes.
2. If the supplied `<NAME>` does not match any entry in the createmeta issuetypes response, `handle_edit_bulk_fields` exits 64 with a `JrError::UserError` listing the valid type names for the project. No bulk POST is issued. The error message format mirrors the priority unknown-name error: `"Issue type '<NAME>' not found for project <KEY>. Valid types: <comma-joined list>."`.
3. The single-key `--type` path (`handle_edit` → `PUT /rest/api/3/issue/{key}`) is BYTE-FOR-BYTE UNCHANGED by this fix. BC-3.4.003, BC-3.4.010, and BC-3.4.011 remain authoritative for that path. The createmeta issuetypes lookup MUST NOT execute on a single-key invocation.
4. **Project key extraction rule**: a Jira issue key has the form `<PROJECT>-<NUMBER>` where `<PROJECT>` is one or more uppercase ASCII letters optionally followed by uppercase digits (no hyphens). The project key is extracted by splitting on the LAST hyphen and taking all characters before it. Examples: `FOO-1` → `FOO`, `PROJ2-100` → `PROJ2`, `MY-LONG-KEY-1` is invalid Jira project-key form (project keys contain no hyphens), but if encountered the last-hyphen split is still applied for consistency.
5. The dry-run builder and the live POST builder MUST stay consistent in their treatment of `--type`: both must use `"issueType"` (camelCase) as the `editedFieldsInput` key. If the dry-run builder still uses `"issuetype"` (lowercase) after this fix ships, it is a spec violation. The VALUE in the dry-run preview (bare name string) is intentionally different from the live POST value (`{"issueTypeId": "..."}`); the KEY must be identical.

**Edge Cases**:
- EC-3.4.018-1: `jr issue edit FOO-1 FOO-2 --type Bug --no-input` — happy path: createmeta returns `[{id: "10001", name: "Bug"}]`; bulk POST body contains `"issueType"` (camelCase key) and `"issueTypeId": "10001"` (string id, NOT `"name": "Bug"`); `selectedActions` contains `"issuetype"` (lowercase). Verified by `test_bulk_issuetype_body_uses_issuetype_id_not_name`.
- EC-3.4.018-2: `jr issue edit FOO-1 FOO-2 --type Nonexistent --no-input` — createmeta returns `[{id: "10001", name: "Bug"}]`; name `"Nonexistent"` not found; exit 64; stderr contains `"Issue type 'Nonexistent' not found"` and lists `"Bug"` as a valid type. NO bulk POST is issued. Verified by `test_bulk_issuetype_unknown_type_name_exits_non_zero`.
- EC-3.4.018-3: `jr issue edit FOO-1 FOO-2 --type bug --no-input` (lowercase name) — case-insensitive match against `name: "Bug"` succeeds; `issueTypeId` is resolved; bulk POST proceeds. The case of the input does not affect resolution.
- EC-3.4.018-4: `jr issue edit FOO-1 --type Bug` (single key) — routes to `handle_edit` single-key path (PUT `/rest/api/3/issue/FOO-1`); `GET .../createmeta/.../issuetypes` is NOT called; this BC does not apply. Existing BC-3.4.003/010/011 govern.
- EC-3.4.018-5: `jr issue edit FOO-1 FOO-2 --type Bug --dry-run --output json` — `GET .../createmeta/.../issuetypes` is NOT called during dry-run (id resolution is skipped). The camelCase `"issueType"` key appears in `plannedChanges` (matching the live POST key per invariant 5 of this BC). For the complete dry-run preview shape (bare name string, intentionally simplified), see BC-3.4.021 EC-3.4.021-3, which is the canonical owner of the dry-run `--type` output shape.

**Verification Properties**:
- VP-331-001: Multi-key bulk `--type` POST body contains camelCase `"issueType"` key in `editedFieldsInput` AND `"issueTypeId"` string value AND lowercase `"issuetype"` in `selectedActions`; does NOT contain `"\"name\":"` in the issueType value position.
- VP-331-002: Unknown type name exits 64 before any bulk POST; stderr names the invalid type and lists valid alternatives.

**Trace**: issue #331 F2; `.factory/research/issue-331-issuetype-bulk-schema.md`; `src/cli/issue/edit.rs::handle_edit_bulk_fields`; `src/api/jira/issues.rs::get_issue_types_for_project` (new); `tests/issue_bulk_pr2.rs` (new integration tests: `test_bulk_issuetype_body_uses_issuetype_id_not_name`, `test_bulk_issuetype_unknown_type_name_exits_non_zero`; rewrite `test_multi_key_type_update_uses_consistent_issuetype_casing` → `test_multi_key_type_update_body_uses_issue_type_id`); live E2E coverage qualitative (gated `JR_RUN_E2E`)

[NEW 2026-06-01 issue #331 F2]

---

#### BC-3.4.019: `issue edit KEY1 KEY2 --type <NAME>` cross-project guard — when keys span more than one Jira project, exit 64 BEFORE any API call

**Confidence**: HIGH
**Source**: issue #331 F2 spec evolution; `.factory/research/issue-331-issuetype-bulk-schema.md §CRITICAL per-project caveat for multi-key bulk`; human-gate decision 2026-06-01 (error-early v1; per-project grouping deferred to a future issue)
**Subject**: Issue write (bulk edit path)

**Description**: The Jira Cloud bulk endpoint accepts a single `issueTypeId` for the entire
batch. Issue-type IDs are project-scoped — the same type name (`Bug`) can have different IDs
in different projects. A multi-key `--type` edit spanning multiple projects cannot reliably
use one `issueTypeId` for all issues. This contract defines the v1 error-early guard that
prevents a silent partial-or-incorrect mutation.

**Rationale**: The Atlassian bulk endpoint `POST /rest/api/3/bulk/issues/fields` provides a
single `editedFieldsInput["issueType"] = {"issueTypeId": "<id>"}` slot — there is no per-issue
issueTypeId mechanism. When keys span multiple projects, the resolved id for project FOO would
be wrong for project BAR's issues, causing silent per-issue failures in the async bulk task.
Per-project grouping (one POST per project, each with the project-correct id) is a valid v2
path but is explicitly OUT OF SCOPE for this fix — it adds significant complexity and was
not approved at the human gate for this issue. Error-early (this BC) is the safe v1 choice.

**Preconditions**:
- 2 or more positional keys are supplied.
- `--type <NAME>` is present.
- The keys' project prefixes (extracted by splitting each key on the LAST hyphen, per BC-3.4.018 Invariant 4) are NOT all identical — i.e., at least two distinct project prefixes are present in the supplied key set.

**Postconditions**:
- Exit code 64.
- Stderr contains an actionable error message. Required substrings (all MUST appear):
  - the literal `--type` (names the offending flag).
  - a reference to the cross-project constraint, e.g. `"requires all issues to be in the same project"` or equivalent phrasing.
  - the distinct project keys detected, so the user can identify which keys caused the conflict.
- NO `GET /rest/api/3/issue/createmeta/{proj}/issuetypes` call is issued (no resolution attempted).
- NO `POST /rest/api/3/bulk/issues/fields` call is issued (no mutation attempted).
- The guard fires before ANY outbound HTTP call — this is a pure client-side argument check.

**Invariants**:
1. The cross-project check is performed BEFORE the name→issueTypeId resolution (see BC-3.4.018). No HTTP calls are made if the guard fires.
2. The guard is specific to `--type` on the multi-key bulk path. Other bulk flags (`--summary`, `--priority`) are NOT affected by this guard — they operate on global or project-independent values.
3. Per-project grouping (attempting to issue one bulk POST per project group, each with the project-specific issueTypeId) is explicitly NOT implemented in v1. Any code that attempts per-project grouping MUST NOT be introduced without updating this BC first.
4. The guard is ONLY active when `--type` is present. A multi-key bulk edit without `--type` (e.g., `--summary` only) is unaffected.

**Edge Cases**:
- EC-3.4.019-1: `jr issue edit FOO-1 BAR-2 --type Bug --no-input` — keys span projects FOO and BAR; exit 64; stderr names `--type`, references cross-project constraint, and lists `FOO` and `BAR`; no HTTP calls issued. Verified by `test_bulk_issuetype_cross_project_keys_exits_64`.
- EC-3.4.019-2: `jr issue edit FOO-1 FOO-2 FOO-3 --type Bug --no-input` — all keys in project FOO; guard does NOT fire; proceeds to BC-3.4.018 resolution and bulk POST.
- EC-3.4.019-3: `jr issue edit PROJ2-1 PROJ2-2 --type Bug --no-input` — project key `PROJ2` (uppercase letters + digit, no hyphen); last-hyphen split correctly extracts `PROJ2` from both keys; both keys are in the same project; guard does NOT fire.
- EC-3.4.019-4: `jr issue edit FOO-1 BAR-2 --summary "New title" --no-input` (no `--type`) — cross-project guard DOES NOT fire; only `--type` triggers this guard. The `--summary` bulk edit proceeds normally (summary is not project-scoped).
- EC-3.4.019-5: `jr issue edit FOO-1 BAR-2 --type Bug --dry-run --output json` — guard fires (same as non-dry-run); exit 64 even in dry-run mode, because the cross-project constraint is a pre-resolution error, not a live-API error. No `plannedChanges` are emitted.

**Verification Properties**:
- VP-331-003: Cross-project `--type` bulk edit exits 64 before any HTTP call; stderr contains `--type` and both project keys; no createmeta and no bulk POST mocks are hit.

**Trace**: issue #331 F2; `.factory/research/issue-331-issuetype-bulk-schema.md §CRITICAL per-project caveat for multi-key bulk`; `src/cli/issue/edit.rs::handle_edit` (cross-project guard at ~line 335, pre-dry-run and pre-routing); `tests/issue_bulk_pr2.rs` (new integration test: `test_bulk_issuetype_cross_project_keys_exits_64`)

[NEW 2026-06-01 issue #331 F2]

---

#### BC-3.4.020: `issue edit --label` routes single-key through `PUT /rest/api/3/issue/{key}` with bare-string labels; routes 2+ keys through `POST /rest/api/3/bulk/issues/fields` with `{"name":...}` objects — these two paths are LOAD-BEARING asymmetric and MUST NOT be unified

**Confidence**: HIGH
**Source**: CLAUDE.md Gotcha BUG-LABEL-400; `src/cli/issue/edit.rs::handle_edit_bulk_labels` (Path A lines ~961-1001, Path B lines ~1004-1020); `src/api/jira/issues.rs::update_issue_labels` (bare-string PUT payload); live E2E run 26730687481 (bulk payload returns HTTP 400 on single-key PUT path on real Jira Cloud)
**Subject**: Issue write (label edit routing)

**Description**: `handle_edit_bulk_labels` inspects `keys.len()` to choose between two entirely
different API endpoints with mutually incompatible payload shapes. The routing decision fires
after `--jql` resolution, so a `--jql` query matching exactly one issue follows Path A (PUT).
This asymmetry is confirmed by live E2E run 26730687481: the bulk `{"name":...}` payload causes
HTTP 400 on real Jira Cloud when applied to the single-key PUT endpoint.

**Preconditions**:
1. `jr issue edit --label <spec>` is invoked with 1 to N positional keys (or `--jql` resolving to 1..N keys).
2. At least one `--label` value is supplied.
3. None of the `--label` mutual-exclusion flags are supplied alongside `--label`. The full set (verified from `src/cli/issue/edit.rs::handle_edit` lines 180-227, CLAUDE.md FIX-F5-001): `--summary`, `--priority`, `--type`, `--team`, `--points`, `--no-points`, `--parent`, `--no-parent`, `--description`, `--description-stdin`, `--markdown`, `--field`. Combining `--label` with any of these flags causes the block to exit 64 before this contract's routing logic fires; the block fires unconditionally on `!labels.is_empty() && !conflicting.is_empty()` (NOT only on `!field_pairs.is_empty()`) regardless of key count. This gate is **distinct from BC-3.4.017 Gate B** — Gate B covers multi-key (`--jql` or 2+ positional keys) + flag-overlap for `--summary`/`--description`/`--type`/`--priority` only; the `--label` conflict block is a separate earlier-return covering all 12 flags at any key count.
4. `--dry-run` is NOT set. When `--dry-run` is present, `handle_edit` short-circuits at the dry-run block (`src/cli/issue/edit.rs` ~lines 366-559, verified: `if dry_run {` at line 366, `return Ok(());` at line 559) BEFORE the label-routing branch at line 603 (`if !labels.is_empty()`). No PUT or bulk POST is issued under `--dry-run`. The label dry-run preview (plannedChanges with action/name entries) is owned by BC-3.4.021 Invariant 4. Path A and Path B of this contract apply only to live, non-dry-run label edits.

**Postconditions — Path A (single key, `keys.len() == 1`)**:
1. `PUT /rest/api/3/issue/{key}` is called exactly once with Content-Type `application/json`.
2. Request body is `{"update": {"labels": [{"add": "foo"}, {"remove": "bar"}]}}` where label values are **bare strings** (NOT `{"name":...}` objects).
3. `add:` prefix entries produce `{"add": "name"}` operations; `remove:` prefix entries produce `{"remove": "name"}`; bare entries (no prefix) produce `{"add": "name"}`.
4. Returns HTTP 204 → exit 0.
5. `POST /rest/api/3/bulk/issues/fields` is NOT called.
6. `GET .../editmeta` is NOT called (label edits skip editmeta validation).

**Postconditions — Path B (multi-key, `keys.len() >= 2`)**:
1. `POST /rest/api/3/bulk/issues/fields` is called exactly once (both ADD and REMOVE coalesce into a single POST).
2. Request body `selectedActions` array is `["labels"]`.
3. Request body `editedFieldsInput` is:
   ```json
   {
     "labelsFields": [
       {"fieldId":"labels","bulkEditMultiSelectFieldOption":"ADD","labels":[{"name":"foo"}]},
       {"fieldId":"labels","bulkEditMultiSelectFieldOption":"REMOVE","labels":[{"name":"bar"}]}
     ]
   }
   ```
   where label items are `{"name":"..."}` **objects** (NOT bare strings). If only ADD entries: `labelsFields` has one element. If only REMOVE: one element. If both: two elements, ADD first, REMOVE second.
4. `PUT /rest/api/3/issue/{key}` is NOT called.
5. The async bulk task from PC1 is polled via `GET /rest/api/3/bulk/queue/{taskId}` (where `taskId` is read from the submit-response body at `src/api/jira/bulk.rs` lines 271-273, `bulk_edit_fields`; the poll URL is constructed at `bulk.rs` line 317) until terminal status; exit 0 on success. Equivalent to BC-3.4.018's task-polling mechanism.

**Invariants**:
1. The same `--label` spec (e.g., `--label add:foo`) produces DIFFERENT wire payloads depending on key count. This asymmetry is LOAD-BEARING and MUST NOT be unified — live Jira Cloud returns HTTP 400 if the bulk `{"name":...}` payload is sent to the single-key PUT endpoint, and vice versa. (BUG-LABEL-400)
2. `keys.len() == 1` is determined AFTER `--jql` resolution — a `--jql` query matching exactly one issue takes Path A (PUT), not Path B (bulk POST).
3. The routing check is `keys.len() == 1`, NOT "was `--jql` used?".
4. The bulk POST for labels uses `labelsFields` (NOT `issueType` or `priority` field names). The `labelsFields` key and `bulkEditMultiSelectFieldOption` field name are Atlassian-defined and must not be changed.

**Edge Cases**:
- EC-3.4.020-1: One positional key → PUT path; body contains `{"add":"name"}` bare strings; bulk POST is NOT called.
- EC-3.4.020-2: `--jql "project = FOO AND key = FOO-1"` matching exactly one issue → PUT path (not bulk), same behavior as one positional key.
- EC-3.4.020-3: Two positional keys → bulk POST path; `labelsFields` contains `{"name":"name"}` objects; PUT is NOT called.
- EC-3.4.020-4: `--jql "project = FOO"` matching two issues → bulk path; same `labelsFields` object shape.
- EC-3.4.020-5: Bare label (no prefix, e.g., `--label feature`) → treated as ADD; produces `{"add":"feature"}` on PUT path; `{"name":"feature"}` under `bulkEditMultiSelectFieldOption:"ADD"` on bulk path.
- EC-3.4.020-6: Only REMOVE entries for a single key → `{"update":{"labels":[{"remove":"x"}]}}` body (no ADD element); `labelsFields` absent.
- EC-3.4.020-7: Only ADD entries for multiple keys → `labelsFields` has exactly one element (ADD only; no REMOVE element).
- EC-3.4.020-8: `FOO-1 --label add:foo --label remove:bar` (single key, both ADD and REMOVE in one invocation) → PUT body `{"update":{"labels":[{"add":"foo"},{"remove":"bar"}]}}` — all adds precede all removes in the `label_ops` array REGARDLESS of CLI input order. `src/api/jira/issues.rs::update_issue_labels` (lines 478–484) iterates the `adds` array first, then the `removes` array. Contrast: dry-run `plannedChanges.labels` PRESERVES CLI input order (iterates the raw `labels` vec at `edit.rs` lines 431–443), so `--label remove:bar --label add:foo` yields `[{"action":"REMOVE","name":"bar"},{"action":"ADD","name":"foo"}]` in dry-run but `[{"add":"foo"},{"remove":"bar"}]` on the live PUT wire. Holdout mocks targeting the live path must expect adds-before-removes.

**Canonical Test Vectors**:

| Scenario | Keys | Input | Expected endpoint | Expected payload fragment |
|----------|------|-------|------------------|--------------------------|
| Single-key ADD | `FOO-1` | `--label add:bug` | `PUT /rest/api/3/issue/FOO-1` | `{"update":{"labels":[{"add":"bug"}]}}` |
| Single-key REMOVE | `FOO-1` | `--label remove:bug` | `PUT /rest/api/3/issue/FOO-1` | `{"update":{"labels":[{"remove":"bug"}]}}` |
| Multi-key ADD | `FOO-1 FOO-2` | `--label add:bug` | `POST .../bulk/issues/fields` | `labelsFields[0].bulkEditMultiSelectFieldOption = "ADD"`, `labels[0].name = "bug"` |

**Verification Properties**:
- VP-LABEL-FORK-001: Single-key `--label` invocation calls PUT exactly once; bulk POST mock is not hit (`.expect(0)`); PUT body contains bare-string `{"add":"..."}` (not `{"name":"..."}`).
- VP-LABEL-FORK-002: Two-key `--label` invocation calls bulk POST exactly once; PUT mock is not hit (`.expect(0)`); bulk body `labelsFields[0].labels[0]` is an object with a `name` key (not a bare string).

**Trace**: CLAUDE.md Gotcha BUG-LABEL-400; `src/cli/issue/edit.rs::handle_edit_bulk_labels`; `src/api/jira/issues.rs::update_issue_labels`; BC-3.4.006 (complementary: `build_labels_edited_fields` pure-function shape); H-NEW-LABEL-FORK-001 (holdout unblocked by this BC)

[NEW 2026-06-30 BC-subclause-pass F2]

---

#### BC-3.4.021: `jr issue edit --dry-run` emits `plannedChanges` JSON or table preview on stdout without issuing any mutation HTTP call; `--output json` schema is `{dryRun: true, issues: [...], plannedChanges: {...}}`

**Confidence**: HIGH
**Source**: `src/cli/issue/edit.rs::handle_edit` dry-run block (implementation-defined; no external Atlassian analogue); CLAUDE.md `--dry-run is implemented on issue edit (multi-key positional + --jql-resolved sets) with --output json support`
**Subject**: Issue write (dry-run preview)

**Description**: When `--dry-run` is present, `handle_edit` emits a preview of planned changes and
exits 0 without issuing any mutation HTTP call. The output format is INTERNAL to `jr` — there is no
Jira Cloud API endpoint for this behavior. The `plannedChanges` field shapes are intentionally
SIMPLIFIED previews that do NOT match the live-edit wire payloads (e.g., labels as a flat array
instead of `labelsFields`; priority as a bare string instead of `{"priorityId":"..."}`). These
simplifications are deliberate design choices documented in source comments.

**Preconditions**:
1. `jr issue edit KEY(s) --dry-run [flags]` is invoked.
2. At least one field flag is supplied (the pre-HTTP zero-flag guard fires at exit 64 before the dry-run block; this BC does not apply when no flags are given).
3. `--dry-run` is explicitly set (not inferred from any other condition).
4. Keys may be positional or resolved via `--jql`.

**Postconditions — Common (regardless of `--output`)**:
1. No mutation HTTP call is issued: `PUT /rest/api/3/issue/{key}`, `POST /rest/api/3/bulk/issues/fields`, and `POST /rest/api/3/bulk/issues/transition` are all NOT called.
2. `--jql` resolution fires (read-only search endpoint is called) if `--jql` is supplied.
3. If `--field NAME=VALUE` is supplied: `GET /rest/api/3/issue/{key}/editmeta` fires (read-only field validation). A resolution failure (field absent from editmeta, unknown option value) still exits 64 — `--dry-run` does NOT suppress exit-64 resolution errors (BC-3.4.015 EC-3.4.015-19 preserved).
4. Exit code is 0 on successful dry-run completion.
5. Output is written to **stdout** (not stderr).

**Postconditions — `--output json`**:
1. stdout is a single pretty-printed JSON object with exactly three top-level keys:
   ```json
   {
     "dryRun": true,
     "issues": ["FOO-1", "FOO-2"],
     "plannedChanges": { ... }
   }
   ```
2. `plannedChanges` is a JSON object containing ONLY the field keys the user explicitly requested. Absent flags do NOT appear in `plannedChanges`.
3. `plannedChanges` key names and value types per flag:
   - `--summary "X"` → `"summary": "X"` (bare string)
   - `--priority "High"` → `"priority": "High"` (bare string; NOT `{"priorityId":"..."}`)
   - `--type "Bug"` → `"issueType": "Bug"` (bare string; NOT id-resolved)
   - `--parent "FOO-0"` → `"parent": "FOO-0"` (bare string)
   - `--no-parent` → `"parent": null` (JSON null, NOT absent key)
   - `--points 3` → `"points": 3.0` (number)
   - `--no-points` → `"points": null` (JSON null, NOT absent key)
   - `--team "Backend"` → `"team": "Backend"` (bare string)
   - `--description "X"` → `"description": "X"` (bare string; raw input, NOT ADF)
   - `--description-stdin` → `"description": "<from stdin — not yet read in dry-run>"` (literal placeholder; stdin NOT read)
   - `--markdown` → `"markdown": true` (boolean)
   - `--label add:foo` → `"labels": [{"action": "ADD", "name": "foo"}]` (flat array; NOT the `labelsFields` bulk schema)
   - `--field NAME=VALUE` (resolved) → `"<field display-name>": "<display value>"` merged into `plannedChanges` as string key/value pairs. The key is the HUMAN display name (e.g. `"Story Points"`), NOT the `customfield_NNNNN` wire ID. The value is the display value (e.g. `"5"` for a number field; the matched option label for a select field). Source: `src/cli/issue/field_resolve.rs::resolve_edit_fields` step 6 inserts `(human_name, display_value)` into `changed_fields`, which is the same map merged into `plannedChanges` via `dr_changed` at `edit.rs` lines 480–482.
4. `dryRun: true` is always present as a boolean top-level key.
5. `issues` is always present as a string array of the resolved keys.
6. Output is produced via `output::render_json(&payload)` (JSON render invariant, BC-7.3.010).

**Postconditions — `--output table` (default)**:
1. stdout lines in source insertion order (only lines for explicitly-supplied flags are emitted):
   ```
   DRY RUN — no changes will be made.
   Issues affected (N):
     <KEY-1>
   Planned changes:
     summary → <value>
     priority → <value>
     labels → add:foo, remove:bar
     type → <value>
     parent → <value> | (clear)
     points → <value> | (clear)
     team → <value>
     description → <preview>
     markdown rendering: enabled
     <field-name> → <value>
   ```
2. `--description "..."` longer than 60 Unicode codepoints → truncated to 60 codepoints with `"..."` suffix. Truncation uses `chars().count()` / `chars().take(60)` (codepoint-aware, not byte-slice).
3. `--description-stdin` → `"  description → (read from stdin — not yet read in dry-run)"`.
4. `--no-parent` → `"  parent → (clear)"`.
5. `--no-points` → `"  points → (clear)"`.
6. `--label add:foo --label remove:bar` → `"  labels → add:foo, remove:bar"` (comma-joined, prefix preserved).
7. All output is on stdout (output-channel profile 1 for dry-run path per source comment).

**Invariants**:
1. The `plannedChanges` field shapes are INTENTIONALLY SIMPLIFIED previews that do NOT match live-edit wire payloads:
   - `labels`: dry-run emits `[{"action":"ADD","name":"foo"}]`; live bulk POST sends `labelsFields` array with `bulkEditMultiSelectFieldOption` (see BC-3.4.006 / BC-3.4.020).
   - `priority`: dry-run emits a bare string; live POST wraps as `{"priorityId":"<id>"}`.
   - `issueType`: dry-run emits the type name; live POST uses `{"issueTypeId":"<id>"}`.
   These simplifications are intentional (source comment at `edit.rs` dry-run block). Do NOT "fix" them to match live wire shapes. Note: the single-key live PUT (`src/cli/issue/edit.rs` lines 675, 681, 712) uses a THIRD distinct shape — object wrappers with name/key fields (`issuetype: {"name":t}`, `priority: {"name":p}`, `parent: {"key":parent_key}`) — so dry-run bare strings differ from BOTH the bulk POST shapes AND the single-key PUT shapes.
2. `--dry-run` does NOT suppress exit-64 resolution errors. Only `PUT`/`POST` mutation is suppressed.
3. `--dry-run` does NOT read stdin for `--description-stdin` — the literal placeholder string is the correct behavior, not a bug.
4. This BC owns ONLY the dry-run preview shapes built inside `handle_edit`'s dry-run block (`src/cli/issue/edit.rs` lines ~431–559). `handle_edit_bulk_labels` (line 935) and `handle_edit_bulk_fields` (line 1059) take NO `dry_run` parameter and have NO dry-run path of their own — `handle_edit` returns `Ok(())` at line 559 (the dry-run early-return) BEFORE reaching the label-routing branch (line 603) or the multi-key-routing branch (line 618). Live wire shape ownership: live bulk label shape → BC-3.4.020 Path B (verified: BC-3.4.006 is about labels via `build_labels_edited_fields`, not priority); live multi-key `--type` bulk shape → BC-3.4.018; the live bulk `--priority` shape (`{"priorityId":"<id>"}`, `src/cli/issue/edit.rs::handle_edit_bulk_fields` line 1093) has NO dedicated owning BC; the single-key PUT field shapes (`issuetype: {"name":t}`, `priority: {"name":p}`, `parent: {"key":...}` at `edit.rs` lines 675, 681, 712) have NO dedicated owning BC — all three PUT shapes are documented inline in Invariant 1 of this BC. (Note: BC-3.4.012 owns the SUCCESS ECHO/changed_fields map, not the PUT wire payload.)
5. Exit code 0 is unconditional after the dry-run block returns `Ok(())`.

**Edge Cases**:
- EC-3.4.021-1: `--output json --summary "X"` → `{"dryRun":true,"issues":["FOO-1"],"plannedChanges":{"summary":"X"}}`; PUT not called.
- EC-3.4.021-2: `--output json --label add:foo --label remove:bar` → `plannedChanges.labels = [{"action":"ADD","name":"foo"},{"action":"REMOVE","name":"bar"}]` (flat array; NOT `labelsFields`).
- EC-3.4.021-3: `--output json --type "Bug"` → `plannedChanges.issueType = "Bug"` (bare string; no id-resolution HTTP call).
- EC-3.4.021-4: `--output json --no-parent` → `plannedChanges.parent = null` (JSON null, not absent key).
- EC-3.4.021-5: `--output json --no-points` → `plannedChanges.points = null` (JSON null, not absent key).
- EC-3.4.021-6: `--output json --description-stdin --dry-run` → `plannedChanges.description = "<from stdin — not yet read in dry-run>"` (literal placeholder); stdin not read.
- EC-3.4.021-7: `--output table --description "..."` longer than 60 codepoints → truncated with `"..."` suffix in table output.
- EC-3.4.021-8: `FOO-1 FOO-2 --summary "X" --output json --dry-run` → `issues: ["FOO-1","FOO-2"]`; bulk POST NOT called; both keys in `issues` array.
- EC-3.4.021-9: `--field NAME=VALUE --dry-run` → editmeta GET fires; resolved key+value appear in `plannedChanges`; PUT NOT called; exit 0 (happy path). Exit 64 if field resolution fails (BC-3.4.015 EC-3.4.015-19 preserved).
- EC-3.4.021-10: Zero field flags + `--dry-run` → exit 64 before dry-run block (pre-HTTP guard fires; precondition 2 fails; this BC does not apply).
- EC-3.4.021-11: `--output table --no-parent` → stdout contains `"  parent → (clear)"` (not `"null"` or absent line).
- EC-3.4.021-12: `--output json --points 0 --dry-run` → `plannedChanges.points = 0.0` (JSON number zero, NOT `null`). This is semantically distinct from `--no-points` → `plannedChanges.points = null` (EC-3.4.021-5). The `Some(f64)` branch at `edit.rs` line 454 handles `--points 0`; the explicit-null branch at line 457 handles `--no-points`. Zero-valued numbers must not be confused with cleared fields.
- EC-3.4.021-13: `--output table --description "..."` with exactly 60 codepoints → no truncation suffix (description is emitted verbatim). With exactly 61 codepoints → the first 60 codepoints are kept and `"..."` is appended. Source: `edit.rs` line 537 uses `char_count > 60` (strict-greater): a count of exactly 60 is NOT greater than 60, so the else branch fires (no suffix). This is a codepoint boundary, not byte-length; multi-byte UTF-8 characters count as one codepoint each (`chars().count()` / `chars().take(60)`).
- EC-3.4.021-14: `--priority High --dry-run --output json` → `plannedChanges.priority = "High"` (bare string, NOT `{"name": "High"}` or `{"priorityId": "..."}`, intentionally simplified per invariant 1). Contrast: single-key PUT body wraps priority as `{"priority":{"name":"High"}}` (Jira v3 `update` shape); bulk POST body resolves and sends `{"priorityId": "<id>"}` (name→id via `GET /rest/api/3/priority`, ADR #331). The dry-run preview emits the user-supplied name verbatim, no resolution HTTP call. Source: `src/cli/issue/edit.rs` line ~407 (`planned.insert("priority".into(), json!(p))` where `p: &String`).

**Canonical Test Vectors**:

| Scenario | Flags | `--output` | Expected stdout fragment | PUT called? |
|----------|-------|------------|--------------------------|-------------|
| Summary dry-run JSON | `FOO-1 --summary "Fix bug" --dry-run` | json | `{"dryRun":true,"issues":["FOO-1"],"plannedChanges":{"summary":"Fix bug"}}` | No |
| Label dry-run JSON | `FOO-1 --label add:bug --dry-run` | json | `plannedChanges.labels[0] = {"action":"ADD","name":"bug"}` | No |
| Multi-key dry-run | `FOO-1 FOO-2 --summary "X" --dry-run` | json | `issues: ["FOO-1","FOO-2"]` | No |
| Table dry-run | `FOO-1 --summary "X" --dry-run` | table | stdout has "DRY RUN — no changes will be made." | No |
| null parent | `FOO-1 --no-parent --dry-run` | json | `plannedChanges.parent = null` | No |

**Verification Properties**:
- VP-DRY-RUN-001: `--dry-run --output json` stdout parses as valid JSON with exactly `dryRun`, `issues`, `plannedChanges` at top level; `dryRun` is `true`; `issues` is a non-empty string array; `plannedChanges` contains only explicitly-supplied-flag keys; PUT mock is not hit.
- VP-DRY-RUN-002: `--dry-run --output json --no-parent` → `plannedChanges.parent` is JSON null (not absent); PUT not called.
- VP-DRY-RUN-003: `--dry-run --output json --label add:foo` → `plannedChanges.labels[0].action == "ADD"` and `.name == "foo"` (flat-array form, NOT `labelsFields`).

**Trace**: `src/cli/issue/edit.rs::handle_edit` dry-run block (implementation-defined; no external Atlassian API spec); CLAUDE.md `--dry-run is implemented on issue edit`; BC-3.4.015 EC-3.4.015-19 (preserved); BC-3.4.020 (label wire asymmetry); BC-7.3.010 (JSON render invariant); H-NEW-DRY-RUN-001 (holdout unblocked by this BC)

[NEW 2026-06-30 BC-subclause-pass F2]

---

### 3.5 Comments (12 BCs: BC-3.5.001..BC-3.5.012)

#### BC-3.5.001: `issue comment add <key> --internal` adds `sd.public.comment` property

**Confidence**: HIGH
**Source**: `src/api/jira/issues.rs::add_comment(internal: bool)`
**Behavior**: `properties: [{key:"sd.public.comment", value:{internal:true}}]`. Non-JSM: silently ignored.
**Note**: The canonical CLI form is `jr issue comment add <KEY> <text> --internal` (BC-3.5.012 subcommand group refactor; the old flat `jr issue comment <KEY>` form is removed).
**Trace**: Pass 3 BC-219; adversary pass-5 M2 title update (2026-07-09)

---

#### BC-3.5.002: `comment delete <KEY> --id <ID>` sends `DELETE /rest/api/3/issue/{key}/comment/{id}`; 204 → exit 0

**Confidence**: HIGH
**Source**: `src/api/jira/issues.rs::add_comment` (sibling; `delete_comment` added at F4; citations updated at delivery); `src/cli/issue/workflow.rs::handle_comment` (relocates to interactions.rs under PF-017 at F4; citations updated at delivery)
**Subject**: Issue write
**Origin**: NEW FEATURE (issue #577 SOH-COMMENT-CRUD-1)

On a 204 response, exit 0. Output channel profile 4 (Symmetric — stdout for `--output json` success data; stderr for human-readable errors and prompts in either mode):

- **Human output** (stderr, via `output::print_success` per state-changing-command convention): `Deleted comment <ID> on <KEY>.`
- **JSON output** (`--output json`, stdout via `output::render_json`): `{"deleted": true, "id": "<ID>", "key": "<KEY>"}` (3 keys alphabetical).

The `--id` flag accepts a `String` (Jira comment IDs are not guaranteed to be `u64`; treating `--id` as an opaque string avoids u64-range hazards on legacy/hosted instances).

**EC-3.5.002-1** (shared --id validation, applies to BC-3.5.002/005/010): Before any API call, `--id` MUST match `^[0-9A-Za-z_-]+$`. A value that does not match → exit 64; stderr: `"invalid comment id: <VALUE>"`. This prevents URL-path injection via the `--id` path segment.

**EC-3.5.002-2** (KEY URL-encoding, applies to BC-3.5.002/005/010): The issue KEY path segment in every comment-family URL (`/rest/api/3/issue/<KEY>/comment/<ID>`) MUST be URL-percent-encoded via `urlencoding::encode` before interpolation into the request path. For standard Jira keys (e.g. `FOO-123`, `PROJECT-1`) this is a no-op, but project keys containing URL-unsafe characters (e.g. spaces, brackets) MUST be correctly encoded. The `--id` value, once validated by EC-3.5.002-1 to be `[0-9A-Za-z_-]+`, needs no further encoding (all characters are URL-safe). Encoding is applied at the per-endpoint helper (e.g., `src/api/jira/issues.rs::add_comment`, which formats the path with `urlencoding::encode(key)`) — not duplicated by each handler; `src/api/client.rs` is a generic HTTP layer and does not hold path templates (symbol-form citation per #408).

**Verification Properties**:

**VP-577-009**: wiremock: DELETE returns 204 → exit 0; `--output json` stdout parses as JSON; parsed stdout object keys == `BTreeSet::from(["deleted", "id", "key"])` (exact key-set assertion, mirroring VP-577-001/002/003 pattern; `deleted` value is `true`). **Human-mode variant**: `jr issue comment delete FOO-1 --id 10001 --yes` against wiremock returning 204 → exit 0; stderr contains `"Deleted comment 10001 on FOO-1"`; stdout is empty.

**VP-577-022**: EC-3.5.002-1 regex guard — three-command regression pin (pre-HTTP, parse+guard level; wiremock routes mounted but unhit):
(a) `jr issue comment delete FOO-1 --id "../evil" --yes` → exit 64; stderr contains `"invalid comment id"`; wiremock `.expect(0)` on any DELETE.
(b) `jr issue comment edit FOO-1 --id "10001;x" "body"` → exit 64; stderr contains `"invalid comment id"`; zero PUT.
(c) `jr issue comment view FOO-1 --id "../x"` → exit 64; stderr contains `"invalid comment id"`; zero GET.

**VP-577-027**: EC-3.5.002-2 KEY URL-encoding pin — verify the request URL path segment is correctly encoded: `jr issue comment delete "MY KEY-1" --id 10001 --yes` against a wiremock mounted with `Mock::given(wiremock::matchers::method("DELETE"))` (or `any()` matcher) responding `ResponseTemplate::new(204)` (per BC-3.5.002; mirrors VP-577-009) → exit 0; inspect `mock_server.received_requests().await[0].url` and assert the path component contains the raw percent-encoded byte sequence `MY%20KEY-1` (i.e., the space is encoded to `%20` before the HTTP request is sent). Test-writer note: `urlencoding::encode` is the normative crate; the key `MY KEY-1` is a synthetic fixture exercising the space-encoding path; the URL assertion operates on the raw request URL bytes captured by wiremock, not on a decoded form. (Added adversary pass-35 F-A3; reformulated adversary pass-36 F-3.)

**Trace**: F2 spec evolution (2026-07-09, DEC-168; adversary pass-17 F1 VP-577-022; adversary pass-35 F-A3 EC-3.5.002-2 KEY URL-encoding + VP-577-027; adversary pass-36 F-3 VP-577-027 reformulated (received_requests URL inspection); F-4 EC-3.5.002-2 site-ordering corrected (per-endpoint helper first); adversary pass-37 F-02 VP-577-009 reformulated (BTreeSet exact key-set assertion); adversary pass-38 F-02 VP-577-009 human-mode variant added (stderr pin "Deleted comment…"); issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.003: `comment delete` requires `--yes` in non-interactive mode; prompts interactively; `--yes` bypasses

**Confidence**: HIGH
**Source**: `src/cli/issue/workflow.rs::handle_comment` (relocates to interactions.rs under PF-017 at F4; citations updated at delivery)
**Subject**: Issue write

Confirmation mechanics:

1. **Non-interactive** (`--no-input` OR stdin not a TTY) without `--yes` → exit 64 (`UserError`); stderr: `"Delete comment <ID> on <KEY>? Use --yes to confirm."` No HTTP DELETE sent.
2. **Interactive** (TTY, `--no-input` absent), no `--yes` → `y/N` prompt: `"Delete comment <ID> on <KEY>? [y/N] "`. Default is N (cancel). Selecting N or pressing Enter → exit 0 (cancelled, no DELETE). Selecting Y → proceed.
3. **`--yes` present** → proceed without prompt regardless of TTY state.

**Delete-pipeline ordering pin**: (1) `--id` regex validation per EC-3.5.002-1 (stderr `"invalid comment id"` on failure, exit 64); (2) confirmation gate (BC-3.5.003, items 1–3 above); (3) HTTP DELETE.

**EC-3.5.003-1**: Interactive-mode default is N (cancel without action), not Y. Pressing Enter alone cancels. This differs from some confirmation patterns in other CLIs; it matches the safety convention in this codebase where destructive operations default to cancel.

**EC-3.5.003-2**: `--output json` × interactive confirmation matrix:

- The y/N prompt is always written to **stderr** regardless of `--output json` (prompts are diagnostic, not data).
- **Cancel path** (user selects N or presses Enter in interactive mode): `--output json` → stdout `{"cancelled": true, "deleted": false}` (via `output::render_json`), exit 0. Human mode → no stdout, exit 0. `id` and `key` are deliberately omitted from the cancel envelope: the operation was cancelled before any HTTP call, so no server confirmation exists. (Key order shown matches `serde_json` default alphabetical emission; JSON key order is not semantically load-bearing but examples match the wire.)
- **Confirm path** (user selects Y or `--yes` is present): output is identical to the direct `--yes` path (BC-3.5.002).

**EC-3.5.003-3** (dialoguer Err → `JrError::Interrupted` exit 130 on delete prompt): When the `comment delete` confirmation prompt receives a `dialoguer::Error` (including EOF — Ctrl+D — or Ctrl+C interrupt mid-prompt), the handler MUST propagate it as `JrError::Interrupted`; exit 130. A `dialoguer::Error` MUST NOT be silently swallowed or mapped to the cancel path (exit 0). This ensures consistent Ctrl+C / EOF behavior across all interactive confirmation prompts in the comment family (mirrors EC-3.5.008-5 for the `--public` prompt).

**Verification Properties**:

**VP-577-005**: `--no-input` mode without `--yes` → exit 64; assert no HTTP DELETE was sent (wiremock `.expect(0)` on the DELETE route).

**VP-577-013**: `comment delete FOO-1 --id 10001 --output json` in interactive mode; user selects N (cancel) → exit 0; stdout parses as JSON `{"cancelled": true, "deleted": false}`; parsed stdout top-level object keys == `BTreeSet::from(["cancelled", "deleted"])` (exact key-set; pins EC-3.5.003-2's id/key-omitted-from-cancel-envelope rule); no HTTP DELETE sent (wiremock `.expect(0)`). **Seam note**: the interactive branch (TTY path) is unreachable in wiremock tests without the `JR_STDIN_IS_TTY` debug seam — set this env var to `"1"` to force `jr` to treat stdin as a TTY in debug builds; see the Delivery-task obligation below.

**Implementation note (interactive-branch test seam)**: Seam mechanism and delivery obligation: see the Delivery-task obligation below; duplicated at BC-3.5.006 item (c).

**Delivery-task obligation (implementing story, F4)**: Per BC-3.5.006 item (c), duplicated here: a `JR_STDIN_IS_TTY` debug seam (`#[cfg(debug_assertions)]`-gated, release builds ignore) enabling interactive-branch tests (VP-577-013 and analogous y/N prompt tests) — the interactive branch (TTY path) is unreachable in wiremock tests without this seam; when set to `"1"` in a debug build, `jr` treats stdin as a TTY regardless of the actual fd state; the seam implementation MUST be accompanied in the same commit by a release-gate regression test (mirrors the `JR_BASE_URL`/`JR_CONFIG_DIR` gate pattern) and a `CLAUDE.md` doc line for `JR_STDIN_IS_TTY` (codified doc-fallout rule); interactive prompts MUST UNCONDITIONALLY use `interact_on(&Term::stderr())` or equivalent (NOT default `/dev/tty` attachment — not a seam-gated requirement; required in all builds) so piped stdin drives the interaction (`Term::stderr()` writes the prompt to stderr per the prompt-to-stderr invariant — EC-3.5.003-2 / EC-3.5.008-2 — while dialoguer still reads input from stdin); interact_on(&Term::stderr()) MUST be used unconditionally (required in all builds); the seam gates ONLY the src/main.rs auto-`--no-input` flip; the F4 story MUST prove the seam+prompt combination works in a wiremock subprocess test before relying on VP-577-013.

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 3; adversary pass-2 MEDIUM-1 remediation; adversary pass-6 MEDIUM-1 JR_STDIN_IS_TTY seam; adversary pass-8 L1 seam-scope; adversary pass-11 F1 Term::stderr(); adversary pass-22 F4 delivery-task obligation added; adversary pass-35 F-A5 EC-3.5.003-3 dialoguer Err → JrError::Interrupted exit 130; adversary pass-40 F-03 VP-577-013 extended (BTreeSet exact key-set + id/key-omitted-from-cancel-envelope rule); issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.004: `comment delete` 404 → exit 64; surfaces Jira error body — NOT idempotent

**Confidence**: HIGH
**Source**: `src/cli/issue/workflow.rs::handle_comment` (relocates to interactions.rs under PF-017 at F4; citations updated at delivery); `src/api/jira/issues.rs::add_comment` (sibling; `delete_comment` added at F4; citations updated at delivery)
**Subject**: Issue write

**SUPERSEDES F1 draft BC-3.5.004** (F1 proposed idempotent exit 0 on 404; DEC-168 ruling 3 overrides).

Jira intentionally conflates 404 (nonexistent comment) with permission-equivalent 403 into a single 404 status code to avoid resource-existence disclosure (research verdict: Claim 3 CONFIRMED). Silent idempotent success would mask permission failures, which are operationally significant.

Behavior:

- **204** → success (BC-3.5.002).
- **404** → exit 64 (`UserError`); stderr: `"comment not found or permission denied: <KEY>#<ID>"`. Append the Jira response body on a separate stderr line following the preamble (text mode; JSON mode carries both in the single H-020 envelope error field) (e.g., the `errorMessages` string from `{"errorMessages":["Comment with id '10001' does not exist."]}`).
- **403** (if surfaced by endpoint variant) → exit 64 + surface body (preamble + Jira response body). ALL 403 causes take this path — the surfaced body itself disambiguates OAuth-scope causes from permission denials.
- **Other 4xx/5xx (except 401)** → propagate via `JrError::ApiError`; exit 1. **401** → framework auth-error path (`JrError::NotAuthenticated` / `JrError::InsufficientScope`); exit 2 per error-taxonomy.md §Section 3.

**EC-3.5.004-1**: The Jira response body is surfaced on 404 to help the user distinguish "wrong comment ID" from "insufficient permission" when both produce the same HTTP status.

**EC-3.5.004-2** (429-retry edge, accepted): A 404 arriving on a retry after a 429 rate-limit on DELETE is indistinguishable from a genuine not-found and exits 64; this is an accepted low-risk edge (no retry-state special-casing this cycle). Test-writer MUST NOT attempt to guard this edge. Operational experience: a user with JSM portal visibility may lack "Delete own/all comments" on the service project → confusing 404 where a 403-flavored message would be more informative. The raw body gives the operator the extra signal.

**Implementation note (404 body-surfacing mechanism)**: The CONTRACT is a two-line stderr output: line 1 = preamble (`"comment not found or permission denied: <KEY>#<ID>"`); line 2 = the Jira error body (e.g., the `errorMessages` string extracted from `{"errorMessages":["Comment with id '10001' does not exist."]}`). The recommended mechanism is catching the API error and matching `err.downcast_ref::<JrError>()` for `ApiError { status: 404, message }` — `message` already carries the extracted `errorMessages` text via `src/api/client.rs` `parse_error` plumbing. The handler MUST re-wrap the matched `ApiError` into `JrError::UserError` (exit 64) — `ApiError`'s default exit code is 1 (`error.rs` catch-all). A distinct API-layer error signature is acceptable if the two-line stderr CONTRACT is preserved. This same mechanism applies to BC-3.5.005 `comment edit` 404 handling and BC-3.5.010 `comment view` 404 handling (cross-referenced in both). In text mode, the two components emit on separate stderr lines via the standard main-error rendering. In `--output json` mode, `main.rs`'s `{"error": ..., "code": ...}` envelope (H-020) captures both components in the single error field with the newline JSON-escaped as `\n` — the envelope MUST NOT be bypassed. VP-577-004 / H-NEW-COMMENT-003 / H-NEW-COMMENT-004 Expected B substring assertions are mode-agnostic and hold in both modes.

**Verification Properties**:

**VP-577-004**: wiremock: DELETE returns 404 with body `{"errorMessages":["Comment with id '10001' does not exist."]}` → exit 64; stderr contains BOTH (a) the preamble substring `"comment not found or permission denied"` AND (b) the Jira error text `"Comment with id '10001' does not exist."` (on a separate line following the preamble).

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 3; research verdict Claim 3; adversary pass-11 F2 H-020 output-mode clause; adversary pass-35 F-A2 401-exclusion + auth-path exit-2 clause; issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.005: `comment edit` default body-only PUT — the `"properties"` key MUST NOT be present in the PUT body when neither `--internal` nor `--public` is passed

**Confidence**: HIGH
**Source**: `src/api/jira/issues.rs::add_comment` (sibling; `update_comment` added at F4; citations updated at delivery); `src/cli/issue/workflow.rs::handle_comment` (relocates to interactions.rs under PF-017 at F4; citations updated at delivery)
**Subject**: Issue write

**Core safety invariant. DEC-168 ruling 1.**

When `jr issue comment edit <KEY> --id <ID> [body source] [--markdown]` is invoked WITHOUT `--internal` or `--public`, the HTTP PUT body sent to `PUT /rest/api/3/issue/{key}/comment/{id}` MUST contain ONLY the `"body"` field (an ADF document). The `"properties"` key MUST NOT be present — not as an empty array, not as `null`, not as any value.

Wire shape (body-only):
```json
{
  "body": { "version": 1, "type": "doc", "content": [ ... ] }
}
```

**Rationale**: Research (Claim 1 REFUTED) confirmed that Jira preserves `sd.public.comment` when `properties` is omitted from the PUT body. The dangerous path is explicitly sending a `properties` array the caller does not fully control. Body-only PUT is therefore the safe default. This is the inversion of the original footgun claim in the issue.

**EC-3.5.005-1**: Non-JSM issue — the invariant applies identically. Whether the issue is a JSM project or a software project, the PUT body is body-only when no visibility flag is set. On non-JSM issues, `sd.public.comment` is absent from the comment's `properties` array; there is nothing to preserve and nothing to inject.

**EC-3.5.005-2** (--id validation cross-reference): `--id` input MUST be validated per EC-3.5.002-1 (shared rule; applies to BC-3.5.002/005/010) before any HTTP call. Input not matching `^[0-9A-Za-z_-]+$` → exit 64; stderr: `"invalid comment id: <VALUE>"`. See VP-577-022 for the three-command regex guard regression pin (delete/edit/view).

**Edit pipeline — validation ordering** (pin for implementers): The `comment edit` handler MUST execute steps in the following order: (1) `--id` regex validation per EC-3.5.002-1; (2) body-source resolution and empty/whitespace check per EC-3.5.009-5 (see also BC-3.5.009); (3) `--public` confirmation gate if applicable (BC-3.5.008); (4) ADF conversion (`text_to_adf` or `markdown_to_adf`); (5) HTTP PUT. Steps 1–3 MUST complete before any ADF conversion or HTTP call. This mirrors the ordering in the existing `handle_comment` body-resolution pattern where body resolution precedes the API call. Note: EC-3.5.009-5 (empty body) and BC-3.5.008 (--public gate) each contain a cross-reference to this ordering pin. **JSDCLOUD-6050 hint timing**: The JSDCLOUD-6050 stderr hint (EC-3.5.006-1 / EC-3.5.007-1) fires after step 4 (ADF conversion) succeeds and BEFORE step 5 (HTTP PUT). If step 4 fails (e.g., `markdown_to_adf` returns an error), the hint does NOT fire — the handler exits with the ADF error instead.

**Implementation note**: Three hazards, all violating the "key MUST NOT be present" invariant, all three caught by VP-577-001's key-set assertion:

(i) `Option<Vec<EntityProperty>>` where `None` serializes as `"properties": null` (key present, null value).

(ii) Reusing the response `Comment` struct as the PUT request body — `src/types/jira/issue.rs::Comment.properties` is `Vec<EntityProperty>` with `#[serde(default)]` and no `skip_serializing_if`, so `Vec::new()` serializes as `"properties": []` (key present, empty array). Additionally, the `Comment` struct carries `id`, `author`, `created`, and other fields that are not part of the PUT body; reusing it without `skip_serializing_if` on those fields would emit extra keys beyond `{"body"}` or `{"body","properties"}`.

Implementations MUST choose one of: (a) a separate PUT request struct that includes only the fields the PUT endpoint accepts — `body` always, plus `properties` when `--internal`/`--public` is passed (PREFERRED — only option that achieves key-set exactly equal to `{"body"}` or `{"body","properties"}` without relying on `skip_serializing_if` on every non-body field); (b) `Option<Vec<...>>` with `#[serde(skip_serializing_if = "Option::is_none")]` covering `properties`, plus `skip_serializing_if` on `id`, `author`, `created`, and all other non-body fields in the reused struct; (c) `Vec<...>` with `#[serde(skip_serializing_if = "Vec::is_empty")]` for `properties`, plus the same additional `skip_serializing_if` annotations on all other non-body fields; or (d) construct the payload via the `serde_json::json!` macro with `body` always present and `properties` conditionally injected — mirrors `add_comment` at `src/api/jira/issues.rs` (existing project idiom); needs no struct at all and natively satisfies the key-set invariant. Options (b) and (c) cover the `properties` field only in their simplest form — achieving the "ONLY body" key-set invariant when reusing the response struct requires `skip_serializing_if` on every non-body field including `id`, `author`, and `created`. Do NOT reuse the response `Comment` struct as the PUT request body without `skip_serializing_if` on all non-body fields.

(iii) The same three-pattern rule applies to any `visibility` field on the PUT request struct. `jr` NEVER sends a `visibility` key on `comment edit` this cycle (no restriction-editing surface exposed). The PREFERRED pattern is omitting the `visibility` field from the request struct entirely — do NOT include it as an `Option<...>` field unless `skip_serializing_if = "Option::is_none"` is also present.

**Response 200 output** (canonical for all three `comment edit` variants — default, `--internal`, `--public`):

- **Human success** (stderr, via `output::print_success` per state-changing-command convention): `"Updated comment <ID> on <KEY>."` When `--internal` was passed, append `" (marked internal)"`; when `--public` was passed and confirmed, append `" (marked public)"`. (Echo markers pinned by VP-577-025.)
- **JSON output** (`--output json`, stdout via `output::render_json`):
  ```json
  {
    "changed_fields": {
      "body": "<raw user-supplied input string>",
      "jsm_internal": true
    },
    "id": "<ID>",
    "key": "<KEY>",
    "updated": true
  }
  ```
  (The example above illustrates the --internal case; in the default body-only variant changed_fields contains only body and the jsm_internal key is omitted entirely; in the --public confirmed variant jsm_internal is false.)
  `changed_fields.body` carries the **raw user-supplied input string** from the body source (file content, stdin content, or positional text argument) — NOT `"(updated)"`, NOT an ADF round-trip. This is the lossless machine channel per the #398 echo-asymmetry precedent (BC-3.4.013: human echoes a marker, machine channel is lossless). `changed_fields.jsm_internal` (boolean: `true` when `--internal` was passed, `false` when `--public` was passed) is present ONLY when `--internal` or `--public` was passed; when neither flag was used, the key is omitted entirely. (Key presence, boolean type, and key-absence all pinned by VP-577-026.) **Human/machine asymmetry (BC-3.4.013 precedent)**: the human echo marker uses `" (marked internal)"` / `" (marked public)"` — project-agnostic verbing that avoids overloading both the word "visibility" and BC-3.5.010's "JSM internal:" field label; the human channel is deliberately distinct from the machine key name, per established echo-asymmetry precedent (BC-3.4.013: human echoes a lossy marker, machine channel is lossless). (Key order shown matches `serde_json` default alphabetical emission (`Value::Object` uses `BTreeMap`); `"body"` sorts before `"jsm_internal"` — JSON key order is not semantically load-bearing but examples match the wire.)
- **Cancel path**: when `--public` confirmation is cancelled, see BC-3.5.008 EC-3.5.008-2 (`{"cancelled": true, "updated": false}` in JSON mode, exit 0).
- **No-truncation note**: `changed_fields.body` is the raw user-supplied input without truncation; downstream consumers must handle arbitrarily large values (mirrors BC-3.4.013 lossless channel precedent).
- **Byte-for-byte echo pin**: `changed_fields.body` echoes the pre-trim source string byte-for-byte. Whitespace trimming applies to the EC-3.5.009-5 emptiness gate AND to the ADF conversion input (matching comment add's trim-then-ADF behavior — verified: `workflow.rs::handle_comment` runs `let text = text.trim().to_string()` before ADF conversion); the JSON echo channel (`changed_fields.body`) receives the raw pre-trim source string byte-for-byte.

**Response 404 / Response 403**:
- **404** → exit 64 (`UserError`); stderr: `"comment not found or permission denied: <KEY>#<ID>"`. Append the Jira response body on a separate stderr line following the preamble (text mode; JSON mode carries both in the single H-020 envelope error field, newline JSON-escaped as `\n`).
- **403** (if surfaced by endpoint variant) → same treatment as 404: exit 64 + surface body (preamble + Jira response body) — inherits BC-3.5.004's 403 clause.
- BC-3.5.006 (`--internal`) and BC-3.5.007 (`--public`) inherit this 404/403 behavior — both are strict extensions of the same `comment edit` wire path.
- **Other 4xx/5xx (except 401)** → propagate via `JrError::ApiError`; exit 1. **401** → framework auth-error path (`JrError::NotAuthenticated` / `JrError::InsufficientScope`); exit 2 per error-taxonomy.md §Section 3.
- See BC-3.5.004 Implementation note for the recommended `downcast_ref::<JrError>()` body-surfacing mechanism (applies here identically).

**Verification Properties**:

**VP-577-001**: wiremock captures the PUT request body; assert the parsed PUT body's top-level key set equals exactly `{"body"}`: `serde_json::from_str::<serde_json::Value>(&body).unwrap().as_object().unwrap().keys().map(|k| k.as_str()).collect::<std::collections::BTreeSet<_>>() == std::collections::BTreeSet::from(["body"])` must be `true`. This positive key-set containment subsumes the prior absence assertions for `"properties"` and `"visibility"` — a stray extra key would also fail this test.

**VP-577-023**: `jr issue comment edit FOO-1 --id 10001 "  Hello with spaces  " --output json` → exit 0; `stdout.changed_fields.body` equals the literal string `"  Hello with spaces  "` byte-for-byte (leading and trailing whitespace preserved in the JSON echo channel). Whitespace trimming applies to the EC-3.5.009-5 emptiness gate AND to the ADF conversion input (matching comment add's trim-then-ADF behavior — verified: `workflow.rs::handle_comment` runs `let text = text.trim().to_string()` before ADF conversion); the JSON echo channel (`changed_fields.body`) receives the raw pre-trim source string byte-for-byte. Wiremock mounts PUT returning 200. **Key-set assertion**: parsed stdout top-level object keys == `BTreeSet::from(["changed_fields", "id", "key", "updated"])` (exact key-set; mirrors VP-577-001 pattern; stray extra keys fail this test). **Human-mode variant**: `jr issue comment edit FOO-1 --id 10001 "Updated text"` (NO `--output json`) against a wiremock returning PUT 200 → exit 0; stderr contains `"Updated comment 10001 on FOO-1"` (human-channel echo defined in BC-3.5.005 Response 200 output); stdout is empty.

**VP-577-024**: wiremock: PUT returns 404 with body `{"errorMessages":["Comment with id '10001' does not exist."]}` → exit 64; stderr contains BOTH (a) the preamble substring `"comment not found or permission denied"` AND (b) the Jira error text `"Comment with id '10001' does not exist."` (on a separate line following the preamble; mirrors VP-577-004 against the PUT route).

**VP-577-025**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --internal` → exit 0; stderr contains `"(marked internal)"` (the human-channel echo marker from BC-3.5.005 Response 200 output) AND also contains `"JSDCLOUD-6050"` (EC-3.5.006-1 hint pin). Wiremock mounts PUT returning 200. **Second variant (`--public --yes` path)**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --public --yes` → exit 0; stderr contains `"(marked public)"` AND also contains `"JSDCLOUD-6050"` — simultaneously proving that `--yes` does NOT suppress the JSDCLOUD-6050 hint (EC-3.5.008-1: hint fires on every `--public` PUT path regardless of `--yes`). Wiremock mounts PUT returning 200. Pins the `" (marked internal)"` / `" (marked public)"` human echo markers defined in BC-3.5.005 Response 200 output and EC-3.5.008-2 Confirm path. (Added adversary pass-32 F2.)

**VP-577-026**: Parse-level `changed_fields.jsm_internal` boolean-type and key-absence pin — three variants (adversary pass-34 F-577-A; lossless machine-channel gap; #398 VP-398-002/004 pattern):
- **(1) `--internal` path**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --internal --output json` → exit 0; stdout parses as JSON; `changed_fields["jsm_internal"]` equals `serde_json::Value::Bool(true)` — boolean, NOT the string `"true"`; AND `changed_fields` object keys == `BTreeSet::from(["body", "jsm_internal"])` (exact key-set).
- **(2) `--public --yes` path**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --public --yes --output json` → exit 0; `changed_fields["jsm_internal"]` equals `serde_json::Value::Bool(false)` — boolean, NOT the string `"false"`; AND `changed_fields` object keys == `BTreeSet::from(["body", "jsm_internal"])` (exact key-set).
- **(3) default body-only path**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --output json` → exit 0; `changed_fields` object does NOT contain the key `"jsm_internal"` at all — assert `stdout_json["changed_fields"].as_object().unwrap().contains_key("jsm_internal")` is `false` (key ENTIRELY ABSENT, not null, not false); AND `changed_fields` object keys == `BTreeSet::from(["body"])` (exact key-set).
All three variants: Wiremock mounts PUT returning 200. Pins `changed_fields.jsm_internal` as defined in BC-3.5.005 Response 200 JSON output (boolean gate: present-`true` / present-`false` / entirely absent). Rationale: lossless machine-channel precedent per #398 — VP-398-002 pins `description` raw-input string; VP-398-004 pins `changed_fields` key-set — the boolean type and key-absence rule are load-bearing for downstream JSON consumers. (Added adversary pass-34 F-577-A.)

> **RESOLVED (visibility PRESERVED verdict, 2026-07-09)**: Body-only PUT does NOT clear an existing role/group visibility restriction — restriction changes ONLY when the caller explicitly includes a `visibility` object in the PUT body (verdict medium-high confidence; `.factory/research/issue-577-visibility-put-semantics-2026-07-09.md`; load-bearing evidence: Atlassian's child-comment-visibility-400 announcement is only coherent under PRESERVED semantics; patch-shaped PUT convention, zero restriction-loss reports across community usage, GET-symmetry argument). `jr` NEVER sends a `visibility` key on `comment edit` in this cycle (no restriction-editing surface exposed). Definitive empirical check rides the deferred EJ probe — extended to include the 2-step visibility check (see delivery-task obligation in BC-3.5.006); if the probe ever refutes PRESERVED, the edit wire shape must preserve visibility via read-modify-write.

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 1; research verdict Claim 1 REFUTED-footgun; adversary pass-5 M6b marker (since resolved — PRESERVED verdict 2026-07-09); adversary pass-32 F2 VP-577-025 human-echo-marker pin; adversary pass-34 F-577-A VP-577-026 jsm_internal boolean-type + key-absence parse pin; adversary pass-35 F-A2 Other-4xx/5xx-except-401 + 401-auth-path clause; adversary pass-38 F-01 VP-577-023 top-level key-set assertion + VP-577-026 variants 1/2/3 changed_fields key-set assertions; adversary pass-39 F1 VP-577-023 human-mode variant; F4 VP-577-025 JSDCLOUD-6050 assertions (both variants); issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.006: `comment edit --internal` explicitly sends `properties:[{"key":"sd.public.comment","value":{"internal":true}}]` in the PUT body

**Confidence**: MEDIUM-HIGH
**Source**: `src/api/jira/issues.rs::add_comment` (sibling; `update_comment` added at F4; citations updated at delivery); `src/cli/issue/workflow.rs::handle_comment` (relocates to interactions.rs under PF-017 at F4; citations updated at delivery)
**Subject**: Issue write

When `--internal` is passed, the PUT body to `PUT /rest/api/3/issue/{key}/comment/{id}` MUST include:
```json
{
  "body": { ... },
  "properties": [{ "key": "sd.public.comment", "value": { "internal": true } }]
}
```

The `value.internal` field MUST be a JSON boolean (`true`), NOT a string (`"true"`). (Research red flag: JSDCLOUD-9766 showed a string form in the importer context; the REST community pattern uses boolean — BOOLEAN is the correct form for the PUT endpoint.)

No confirmation required (`--internal` reduces visibility; not an exposure risk).

> **RESOLVED (HIGH-3 MERGE verdict, human-approved 2026-07-09)**: Jira's comment-PUT `properties` array is MERGE semantics (unlisted entity properties preserved) — research verdict medium-high confidence (`.factory/research/issue-577-properties-merge-replace-2026-07-09.md`; per-key CRUD architecture, no bulk endpoints for comment properties, zero property-loss reports across years of community single-key usage). Direct-array pattern as specced is confirmed safe. Definitive empirical probe DEFERRED to a gated e2e follow-up (see delivery-task note below); if that probe ever refutes MERGE, the `--internal`/`--public` wire shape must be revised to read-modify-write.

**Delivery-task obligation (implementing story, F4)**: The story MUST include: (a) a `CLAUDE.md` gotcha documenting the MERGE verdict, citing `.factory/research/issue-577-properties-merge-replace-2026-07-09.md`, and explicitly stating the do-not-default-to-sending-properties rule (BC-3.5.005); and (b) a gated e2e test in `tests/e2e_live.rs` implementing the 5-step MERGE probe from `.factory/research/issue-577-properties-merge-replace-2026-07-09.md § "Proposed empirical probe"` against project EJ (`JR_E2E_JSM_PROJECT`), self-cleaning per the per-comment DELETE rule stated below. The test function implements three scenarios in sequence: **Scenario 1 (MERGE probe)**: the 5-step MERGE probe described above. **Scenario 2 (PRESERVED base — 2-step)**: (1) create a JSM comment with a role/group visibility restriction; (2) perform a body-only PUT and re-GET; assert the restriction survives (confirming the PRESERVED verdict from `.factory/research/issue-577-visibility-put-semantics-2026-07-09.md`). **Scenario 3 (compound cell — NOT a substitute for Scenario 2)**: create a JSM comment carrying BOTH a role/group visibility restriction AND a `jr.test.marker` property; the PUT body is `{"body": ..., "properties": [{"key": "sd.public.comment", "value": {"internal": false}}]}` with NO `visibility` key; re-GET; assert BOTH the restriction AND `jr.test.marker` survive. This closes the weakest safety-table cell: MERGE for properties does not interfere with PRESERVED for visibility when both are simultaneously present. Scenario 3 is an explicit ADDITION to Scenario 2 — NOT a substitute for it; both MUST run. All three scenarios live in the same gated e2e test function and self-clean via `jr issue comment delete <key> --id <cid> --yes` (or the equivalent DELETE API call) on each probe comment created — NOT via `jsm_self_close`, which closes the parent issue and would consume the reusable EJ test asset. If a probe run creates a fresh JSM request, the parent MAY additionally be closed via `jsm_self_close` at teardown; the comment-DELETE step is mandatory in either flow. **Sequencing constraint (delivery PR, F3):** `jr issue comment delete` ships in the SAME story (S-577-1). For CLI-based teardown to work, the delete subcommand MUST be implemented before or alongside the e2e probe function in the same PR — the teardown call `jr issue comment delete <key> --id <cid> --yes` requires the subcommand to be present in the binary under test. A raw-API-DELETE fallback (via `jr api DELETE /rest/api/3/issue/{key}/comment/{id}`) is permitted but drops the incidental CLI regression signal that `jr issue comment delete` works against a live endpoint. The story PR MUST explicitly declare which teardown pattern is used (CLI-delete or raw-API-DELETE). Additionally: (c) a `JR_STDIN_IS_TTY` debug seam (`#[cfg(debug_assertions)]`-gated, release builds ignore) enabling interactive-branch tests (VP-577-013 and analogous y/N prompt tests); the seam implementation MUST be accompanied in the same commit by a release-gate regression test (mirrors the `JR_BASE_URL`/`JR_CONFIG_DIR` gate pattern) and a `CLAUDE.md` doc line for `JR_STDIN_IS_TTY` (codified doc-fallout rule); interactive prompts MUST UNCONDITIONALLY use `interact_on(&Term::stderr())` or equivalent (NOT default `/dev/tty` attachment — not a seam-gated requirement; required in all builds) so piped stdin drives the interaction (`Term::stderr()` writes the prompt to stderr per the prompt-to-stderr invariant — EC-3.5.003-2 / EC-3.5.008-2 — while dialoguer still reads input from stdin); interact_on(&Term::stderr()) MUST be used unconditionally (required in all builds); the seam gates ONLY the src/main.rs auto-`--no-input` flip; the F4 story MUST prove the seam+prompt combination works in a wiremock subprocess test before relying on VP-577-013. (Duplicated at BC-3.5.003 delivery obligation.)

**EC-3.5.006-1** (JSDCLOUD-6050 caveat): When `--internal` is passed, emit a stderr hint before the PUT is sent: `"note: visibility change is best-effort on JSM projects — verify in the portal (JSDCLOUD-6050); no-op on non-JSM projects."` This hint is informational; it does NOT affect exit code and is not suppressed by `--no-input`. **Timing cross-note**: fires after ADF conversion succeeds (step 4 in BC-3.5.005 edit pipeline ordering pin), before HTTP PUT (step 5); does not fire if step 4 fails.

**EC-3.5.006-2** (Non-JSM behavior): On a non-JSM issue, the `sd.public.comment` property is sent verbatim in the PUT body; Jira silently ignores it (mirrors BC-3.5.001 behavior). The JSDCLOUD-6050 hint from EC-3.5.006-1 still fires (`jr` does not detect JSM vs non-JSM at write time; the hint is informational and harmless on non-JSM projects). No additional non-JSM-specific warning is emitted.

**Verification Properties**:

**VP-577-002**: wiremock captures the PUT request body; assert (a) `serde_json::from_str::<serde_json::Value>(&body).unwrap()["properties"][0]["value"]["internal"]` equals `true` (JSON boolean, not string); AND (b) the body does NOT contain the key `"visibility"` at the top level — `…unwrap().get("visibility").is_none()` must be `true`; AND (c) the parsed PUT body's top-level key set equals exactly `{"body","properties"}` — `…as_object().unwrap().keys().map(|k| k.as_str()).collect::<std::collections::BTreeSet<_>>() == std::collections::BTreeSet::from(["body","properties"])` must be `true`. The visibility absence assertion (b) is the `--internal` case of the BC-3.5.005 note-(iii) invariant: `jr` NEVER sends a `visibility` key on any `comment edit` path this cycle. AND (d) `parsed["properties"].as_array().unwrap().len() == 1 && parsed["properties"][0]["key"] == "sd.public.comment"` must be `true` (pins the exact property key name and single-element array cardinality; a key-name typo such as `sd_public_comment` or a stray second array entry would pass assertions (a)–(c) while the JSM visibility change silently no-ops server-side — Jira ignores unknown property keys).

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 1; research verdict Claim 7 PARTIALLY VALIDATED; adversary pass-3 HIGH-3 + MEDIUM-1 remediation; HIGH-3 closure: MERGE verdict human-approved 2026-07-09, probe deferred to gated e2e; adversary pass-8 M1 VP-577-002 visibility-absence; adversary pass-11 F1 Term::stderr() + F4 compound-cell Scenario-3; adversary pass-32 F1 stale jsm_self_close clause replaced + F3 sequencing constraint added; adversary pass-41 F-01 VP-577-002 extended (d) properties key-name + array-len pin; issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.007: `comment edit --public` explicitly sends `properties:[{"key":"sd.public.comment","value":{"internal":false}}]`; always requires confirmation

**Confidence**: MEDIUM-HIGH
**Source**: `src/api/jira/issues.rs::add_comment` (sibling; `update_comment` added at F4; citations updated at delivery); `src/cli/issue/workflow.rs::handle_comment` (relocates to interactions.rs under PF-017 at F4; citations updated at delivery)
**Subject**: Issue write

When `--public` is passed, the PUT body MUST include:
```json
{
  "body": { ... },
  "properties": [{ "key": "sd.public.comment", "value": { "internal": false } }]
}
```

The `value.internal` field MUST be a JSON boolean (`false`), NOT a string (`"false"`).

**Confirmation always required.** Making a JSM comment publicly visible to the customer is a high-stakes, potentially irreversible action. Confirmation fires on every `--public` invocation regardless of the comment's current visibility state (no GET of current state required).

**Design decision (DEC-168 open point): Option (a) — always confirm when `--public` is passed.**

Rationale: (1) Option (b) (confirm only if currently internal) would reintroduce a GET roundtrip that DEC-168 explicitly eliminated; if the GET fails, a new failure mode is introduced. (2) Option (c) (no confirmation) is inappropriate given the data-exposure risk. (3) Always confirming is the simplest, most predictable design. `--yes` is the scripting escape hatch. This matches the `comment delete` confirmation pattern (BC-3.5.003). The gate flow ALSO surfaces the JSDCLOUD-6050 best-effort caveat via the separate stderr hint (EC-3.5.007-1) emitted after confirmation and before the PUT — the prompt itself stays project-agnostic per SEC-577-001 (defined in `.factory/phase-f2-spec-evolution/security-review-577.md` § SEC-577-001).

**EC-3.5.007-1** (JSDCLOUD-6050 caveat): When `--public` is passed and the user confirms (or `--yes` is present), emit a stderr hint before the PUT is sent: `"note: visibility change is best-effort on JSM projects — verify in the portal (JSDCLOUD-6050); no-op on non-JSM projects."` This hint does NOT fire when the user cancels at the confirmation prompt. **Timing cross-note**: fires after ADF conversion succeeds (step 4 in BC-3.5.005 edit pipeline ordering pin), before HTTP PUT (step 5); does not fire if step 4 fails or if the confirmation is cancelled.

**EC-3.5.007-2** (Non-JSM behavior): On a non-JSM issue, the `sd.public.comment` property is sent verbatim in the PUT body; Jira silently ignores it (mirrors BC-3.5.001 behavior). The JSDCLOUD-6050 hint from EC-3.5.007-1 still fires (`jr` does not detect JSM vs non-JSM at write time; the hint is informational and harmless on non-JSM projects). No additional non-JSM-specific warning is emitted.

> **RESOLVED (HIGH-3 MERGE verdict)**: MERGE semantics: see the RESOLVED block in BC-3.5.006 (verdict + probe deferral apply identically here).

**Verification Properties**:

**VP-577-003**: wiremock captures the PUT request body; assert (a) `serde_json::from_str::<serde_json::Value>(&body).unwrap()["properties"][0]["value"]["internal"]` equals `false` (JSON boolean, not string `"false"`); AND (b) the body does NOT contain the key `"visibility"` at the top level — `…unwrap().get("visibility").is_none()` must be `true`; AND (c) the parsed PUT body's top-level key set equals exactly `{"body","properties"}` — `…as_object().unwrap().keys().map(|k| k.as_str()).collect::<std::collections::BTreeSet<_>>() == std::collections::BTreeSet::from(["body","properties"])` must be `true`. The visibility absence assertion (b) is the `--public` case of the BC-3.5.005 note-(iii) invariant: `jr` NEVER sends a `visibility` key on any `comment edit` path this cycle. AND (d) `parsed["properties"].as_array().unwrap().len() == 1 && parsed["properties"][0]["key"] == "sd.public.comment"` must be `true` (pins the exact property key name and single-element array cardinality; a key-name typo or stray second array entry would pass assertions (a)–(c) while the JSM visibility change silently no-ops server-side — Jira ignores unknown property keys).

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 1 and open design point Option a; research verdict Claim 7 PARTIALLY VALIDATED; adversary pass-3 HIGH-3 + MEDIUM-1 remediation; HIGH-3 closure: MERGE verdict human-approved 2026-07-09, probe deferred to gated e2e; adversary pass-8 M1 VP-577-003 visibility-absence; adversary pass-40 F-02 SEC-577-001 first-cite definitional pointer added (premise corrected: defined in security-review-577.md); adversary pass-41 F-01 VP-577-003 extended (d) properties key-name + array-len pin; issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.008: `comment edit --public` confirmation gate

**Confidence**: HIGH
**Source**: `src/cli/issue/workflow.rs::handle_comment` (relocates to interactions.rs under PF-017 at F4; citations updated at delivery)
**Subject**: Issue write

Confirmation mechanics for `--public` (mirrors BC-3.5.003 delete-confirmation pattern; step 3 in the BC-3.5.005 edit pipeline ordering pin — fires AFTER `--id` validation and body-source resolution):

1. **Non-interactive** (`--no-input` OR stdin not a TTY) without `--yes` → exit 64 (`UserError`); stderr: `"This will set the comment's visibility to public. Use --yes to confirm."` No HTTP PUT sent.
2. **Interactive** (TTY, `--no-input` absent), no `--yes` → `y/N` prompt: `"Set this comment's visibility to public? [y/N] "`. Default is N (cancel). N or Enter → exit 0 (cancelled, no PUT). Y → proceed. (Project-agnostic wording — same CWE-1021 lineage as SEC-577-001 fix on item 1.)
3. **`--yes` present** → proceed without prompt; JSDCLOUD-6050 hint (EC-3.5.007-1) fires before the PUT.

**EC-3.5.008-1**: `--yes` bypasses the confirmation gate but does NOT suppress the JSDCLOUD-6050 stderr hint (EC-3.5.007-1). The hint is informational, not confirmatory, and always fires on the `--public` path when the PUT is sent.

**EC-3.5.008-2**: `--output json` × interactive confirmation matrix:

- The y/N prompt is always written to **stderr** regardless of `--output json`.
- **Cancel path** (user selects N or presses Enter in interactive mode): `--output json` → stdout `{"cancelled": true, "updated": false}` (via `output::render_json`), exit 0. Human mode → no stdout, exit 0. `id` and `key` are deliberately omitted from the cancel envelope: the operation was cancelled before any HTTP call, so no server confirmation exists. (Key order shown matches `serde_json` default alphabetical emission; JSON key order is not semantically load-bearing but examples match the wire.)
- **Confirm path** (Y or `--yes`): output follows BC-3.5.005 Response 200 output with `changed_fields.jsm_internal: false`; human echo appends `" (marked public)"` per the updated terminology. (Echo marker pinned by VP-577-025 second variant. Boolean type `false` and key-presence for `--public --yes` path pinned by VP-577-026 variant 2.)

**EC-3.5.008-3**: When `--stdin` is used as the body source AND `--public` is set, the handler MUST treat `--stdin` as implying `no_input=true` at handler-start (before the `--public` confirmation gate fires) — independent of TTY detection. This prescriptive rule is necessary because a y/N prompt after stdin has been consumed to EOF would read a dead fd; silent-cancel of a state-changing intent (making a comment public) is unacceptable. Relying solely on the "stdin is a pipe → auto-enables `--no-input`" inference would fail when `JR_STDIN_IS_TTY=1` is set and stdin is actually a pipe: the auto-flip would be suppressed by the seam, and the interactive branch would be reached with an exhausted stdin fd. Therefore `--public --stdin` without `--yes` ALWAYS takes the non-interactive branch (item 1) and exits 64 — whether or not `JR_STDIN_IS_TTY` is set. The targeted stderr hint for this path is: `"--stdin disables interactive prompts — pass --yes to confirm the visibility change."` (replaces the generic item 1 message on this specific code path). Both the generic non-interactive message (item 1) and this targeted hint MUST contain the substring `--yes` (load-bearing pin). **Clarification — "at handler-start" scope**: "at handler-start" means the `no_input` flag mutation happens at handler-start; enforcement of the non-interactive exit-64 path still flows through the BC-3.5.005 pipeline order — step 2 (body-source resolution and empty/whitespace check per EC-3.5.009-5) fires before step 3 (the `--public` confirmation gate). The EC-3.5.008-3 targeted hint is emitted at step 3, not as a handler-start short-circuit.

**EC-3.5.008-4** (`--yes` silent no-op on non-`--public` paths — human-ratified 2026-07-11): When `--yes` is supplied on a `comment edit` invocation that does NOT include `--public`, the flag MUST be accepted silently and have no effect — identical to the ADR-0015 `--no-resolution` accepted-silently precedent. `--yes` without `--public` is NOT an error; it MUST NOT trigger exit 64. The `--public` confirmation gate (step 3) is simply not reached on non-`--public` paths, so `--yes` has no observable behavior there. **Implementation constraint**: clap MUST NOT define `--yes` as `requires("public")` — this would break the accepted-silently contract and fail scripting patterns like `jr issue comment edit FOO-1 --id 10001 "text" --yes` (future-proofing, copy-paste hygiene) that must not error. [Human-ratified 2026-07-11 (research-backed: 9/9 surveyed CLIs LENIENT incl. ankitpokhrel/jira-cli; no design guide advocates strict; house precedents --no-resolution/--no-input; see `.factory/research/issue-577-yes-flag-noop-convention-2026-07-11.md`).]

**EC-3.5.008-5** (dialoguer Err → `JrError::Interrupted` exit 130 on `--public` prompt): When the `--public` confirmation prompt receives a `dialoguer::Error` (including EOF — Ctrl+D — or Ctrl+C interrupt mid-prompt), the handler MUST propagate it as `JrError::Interrupted`; exit 130. This mirrors EC-3.5.003-3 (delete prompt), ensuring consistent Ctrl+C / EOF handling across all interactive confirmation prompts in the comment family. A `dialoguer::Error` MUST NOT be silently swallowed or mapped to the cancel path (exit 0).

**Verification Properties**:

**VP-577-006**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --public --no-input` → exit 64; assert no HTTP PUT was sent (wiremock `.expect(0)` on the PUT route); stderr contains BOTH `"visibility to public"` AND `"--yes"` (the non-interactive BC-3.5.008 item-1 gate message — confirms exit 64 originates from the step-3 `--public` gate, NOT the step-2 body gate). **Setup note**: a non-empty body (`"Updated text"`) is REQUIRED — a bodyless invocation exits 64 at step-2 (BC-3.5.009 body-required rule, `"body is required — use --file, --stdin, or pass text as a positional argument."`) BEFORE the security-critical `--public` non-interactive gate is ever reached, producing a false-passing test while the gate regresses silently. Mirror of VP-577-017's setup-note pattern.

**VP-577-017**: `--public --stdin` without `--yes` → exit 64; stderr contains BOTH `"--stdin"` AND `"--yes"` (the targeted EC-3.5.008-3 message); wiremock `.expect(0)` on the PUT route — zero PUT calls. **Second variant (prescriptive-rule pin)**: same invocation with `JR_STDIN_IS_TTY=1` set (seam active, auto-flip suppressed) → STILL exit 64; same stderr assertions; zero PUT calls. This variant proves the `--stdin` flag-based branch fires independently of TTY-detection state, per the EC-3.5.008-3 normative rule. **Setup note**: the stdin pipe fed to `--stdin` MUST contain a NON-EMPTY body (e.g., `echo "Updated text" | jr issue comment edit …`) so the step-2 empty-body check (EC-3.5.009-5) passes; the EC-3.5.008-3 targeted message is emitted at the step-3 `--public` gate, not as a handler-start short-circuit. An empty-stdin + `--public --stdin` without `--yes` correctly exits 64 on EC-3.5.009-5 with `"comment body cannot be empty."` (correct behavior per BC-3.5.005 pipeline, but that exit path does NOT produce the `"--stdin"` / `"--yes"` substrings — out of scope for this VP).

**VP-577-028**: EC-3.5.008-4 `--yes` silent-no-op pin [human-ratified 2026-07-11]: `jr issue comment edit FOO-1 --id 10001 "text" --yes` (WITHOUT `--public`) against a wiremock returning PUT 200 → exit 0; wiremock receives exactly one PUT hit (the `--yes` flag does NOT suppress the edit operation); stderr does NOT contain any error substring relating to `"--yes"` being unexpected or invalid. **Second variant (runtime clap-requires probe)**: `jr issue comment edit FOO-1 --id 10001 "" --yes` (empty-string positional body, WITHOUT `--public`) → exit 64; stderr contains `"comment body cannot be empty"` (EC-3.5.009-5 empty-body path, handler-level); exit code is 64, NOT 2 (which would indicate clap's `MissingRequiredArgument` or `requires("public")` fired at parse time). Rationale: the `"comment body cannot be empty"` exit-64 path is only reachable if the handler was entered — meaning clap accepted `--yes` without `--public`, proving `requires("public")` was not applied. Wiremock mounts PUT (uncalled — body check fires before HTTP). (Added adversary pass-35 F-A4; second variant reformulated adversary pass-36 F-1.)

**VP-577-029**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --public --output json` in interactive mode (`JR_STDIN_IS_TTY=1`); user selects N (cancel) → exit 0; stdout parses as JSON with top-level keys == `BTreeSet::from(["cancelled", "updated"])` (exact key-set); `cancelled` equals `true`; `updated` equals `false`; no HTTP PUT sent (wiremock `.expect(0)` on the PUT route). Mirrors VP-577-013 pattern for `comment delete` cancel JSON envelope. **Seam note**: set `JR_STDIN_IS_TTY=1` to force TTY-mode in debug builds (BC-3.5.006 delivery obligation § JR_STDIN_IS_TTY).

**VP-577-030**: EOF / interrupt propagation on interactive confirmation prompts (EC-3.5.003-3 and EC-3.5.008-5 delivery) — two variants:
- **(1) Delete prompt EOF**: `jr issue comment delete FOO-1 --id 10001` in interactive mode (`JR_STDIN_IS_TTY=1`) with stdin fed EOF → exit 130 (`JrError::Interrupted`); no HTTP DELETE sent (wiremock `.expect(0)`).
- **(2) `--public` prompt EOF**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --public` in interactive mode (`JR_STDIN_IS_TTY=1`) with stdin fed EOF → exit 130 (`JrError::Interrupted`); no HTTP PUT sent (wiremock `.expect(0)`).
Both variants: `interact_on(&Term::stderr())` MUST be used unconditionally (all builds; BC-3.5.006 delivery obligation); `dialoguer::Error` from EOF MUST propagate as `JrError::Interrupted`, NOT silently swallowed or mapped to the cancel path (exit 0).

**Trace**: F2 spec evolution (2026-07-09, DEC-168 open design point Option a; adversary pass-2 MEDIUM-1 + LOW-2 remediation; adversary pass-5 L1 VP-577-017; adversary pass-9 F1 EC-3.5.008-3 prescriptive + VP-577-017 second-variant; adversary pass-35 F-A4 EC-3.5.008-4 --yes silent-no-op (orchestrator ruling) + VP-577-028; F-A5 EC-3.5.008-5 dialoguer Err → JrError::Interrupted; adversary pass-36 F-1 VP-577-028 second variant reformulated (runtime clap-requires probe); adversary pass-38 R-1 EC-3.5.008-4 + VP-577-028 human-ratified 2026-07-11 (gate language removed); adversary pass-39 F2 VP-577-029 (interactive cancel JSON key-set mirrors VP-577-013); F3 VP-577-030 (EOF/interrupt exit 130 two variants); adversary pass-44 F-1 VP-577-006 extended (non-empty body + setup note; stderr substrings pin --public gate not body gate); adversary pass-45 F-1 VP-577-006 setup-note gate mis-cite corrected (bodyless invocation fires BC-3.5.009 body-required rule not EC-3.5.009-5; verbatim message updated); issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.009: `comment edit` body source flags — `--file`, `--stdin`, positional text, `--markdown`

**Confidence**: HIGH
**Source**: `src/cli/issue/workflow.rs::handle_comment` (relocates to interactions.rs under PF-017 at F4; citations updated at delivery); `src/adf.rs::markdown_to_adf`; `src/adf.rs::text_to_adf`
**Subject**: Issue write

Body source options for `comment edit`, mirroring `comment add` (BC-3.5.001 add path):

- `--file PATH`: read body text from the file at PATH. Apply `--markdown` transformation if set.
- `--stdin`: read body text from stdin. Apply `--markdown` transformation if set.
- Positional `<text>` argument: inline body text. Apply `--markdown` transformation if set.
- `--markdown`: convert the body via `src/adf.rs::markdown_to_adf`; without it, `src/adf.rs::text_to_adf` is used.

At least one body source (`--file`, `--stdin`, or positional text) MUST be provided. If no source is given → exit 64; hint: `"body is required — use --file, --stdin, or pass text as a positional argument."` No HTTP call made.

**EC-3.5.009-1**: `--file PATH` where PATH does not exist → exit 64 (`JrError::UserError`); stderr: `"file not found: <PATH>"`. No HTTP call made. EC-3.5.009-1 covers `ErrorKind::NotFound` only; broader IO-error remaps (permission-denied, is-a-directory) are follow-up story candidates in the same class as the add exit-code alignment.

**Rationale (deliberate divergence from `comment add`)**: `comment add`'s current `--file` not-found path exits 1 via `?`-propagated `std::io::Error` (pre-existing behavior, out of F2 scope). `comment edit` MUST exit 64 via explicit `NotFound → JrError::UserError` mapping — map `ErrorKind::NotFound` to `JrError::UserError`; do NOT use bare `?` on `read_to_string` in `edit`. The tighter exit code is intentional. Aligning the `add` path to exit 64 is a **follow-up story candidate**.

**EC-3.5.009-2**: `--file` and `--stdin` are mutually exclusive (clap `conflicts_with` rejects during argument parsing, before any handler dispatch or HTTP call); exit 2. Note: `comment add`'s three-body-source resolution retains legacy priority order (`--stdin` > `--file` > positional) WITHOUT clap `conflicts_with` — deliberate asymmetry (`Add` is byte-for-byte legacy behavior per BC-3.5.012 EC-3.5.012-2) (verified: `workflow.rs::handle_comment` resolution chain begins `if stdin { … } else if let Some(ref path) = file { … } else if let Some(ref msg) = message`). Aligning `add` to clap-level mutual exclusion is a follow-up story candidate (same class as the EC-3.5.009-1 exit-code alignment).

**EC-3.5.009-3**: `--file` and positional text are mutually exclusive (clap `conflicts_with` rejects during argument parsing, before any handler dispatch or HTTP call); exit 2.

**EC-3.5.009-4**: `--stdin` and positional text are mutually exclusive (clap `conflicts_with` rejects during argument parsing, before any handler dispatch or HTTP call); exit 2.

**EC-3.5.009-5**: An empty or whitespace-only body from ANY source (file, stdin, or positional text) → exit 64; stderr: `"comment body cannot be empty."` No HTTP PUT sent. This prevents `comment edit` from silently blanking an existing comment's content. (Step 2 in the BC-3.5.005 edit pipeline ordering pin — body-source resolution and empty check MUST fire before the `--public` confirmation gate.)

**EC-3.5.009-6** (visibility-only edit unsupported): `comment edit` does NOT support changing only the visibility of a comment without also supplying a body. `--internal` and `--public` are always paired with a body source (this is enforced by BC-3.5.009's body-required rule (handler-level guard, exit 64) — at least one body source is always required). An attempt to pass `--internal` or `--public` without any body source hits the existing exit 64 guard from BC-3.5.009's body-required rule ("At least one body source MUST be provided"). This is a deliberate scope decision for F2; a visibility-only edit path (no body resubmission) is a **follow-up story candidate** (M6b closure: `visibility` PRESERVED verdict confirmed — see BC-3.5.005 RESOLVED block; the scope exclusion remains regardless).

**Verification Properties**:

**VP-577-011**: `comment edit FOO-1 --id 10001 --file /nonexistent/path.txt` → exit 64; no HTTP PUT sent (wiremock `.expect(0)` on the PUT route).

**VP-577-012**: `comment edit FOO-1 --id 10001 "   "` (whitespace-only positional body) → exit 64; stderr contains `"comment body cannot be empty"`; no HTTP PUT sent (wiremock `.expect(0)` on the PUT route).

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 4 — scope confirmed; adversary pass-1 MEDIUM-3/MEDIUM-4 remediation; issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.010: `comment view <KEY> --id <ID>` sends `GET /rest/api/3/issue/{key}/comment/{id}?expand=properties`; renders comment details

**Confidence**: HIGH
**Source**: `src/api/jira/issues.rs::add_comment` (sibling; `get_comment` added at F4; citations updated at delivery); `src/cli/issue/workflow.rs::handle_comment` (relocates to interactions.rs under PF-017 at F4; citations updated at delivery)
**Subject**: Issue write

Endpoint: `GET /rest/api/3/issue/{key}/comment/{id}?expand=properties`

The `?expand=properties` query parameter is required to include the `properties` array in the response (research verdict Claim 4 CONFIRMED; Claim 2 CONFIRMED). Without it, `sd.public.comment` is absent even on JSM comments.

**--id validation**: This endpoint shares the `--id` validation rule EC-3.5.002-1 (applies to BC-3.5.002/005/010): `--id` MUST match `^[0-9A-Za-z_-]+$` before any HTTP call; exit 64 on mismatch. See VP-577-022 for the three-command regex guard regression pin (delete/edit/view).

**Response 200 — Human output** (profile 3, Mixed — stdout for data, stderr for errors and hints):

Display comment details via plain key-value lines (NOT a comfy-table multi-row layout) to stdout, in the following field order:
1. `ID:` — the comment ID string from the `id` field; render `"N/A"` if the field is absent or null (uncommon in practice but graceful-degradation safe).
2. `Author:` — display name from the comment's `author.displayName` field; render `"Unknown"` if the `author` key is absent, `null`, or its `displayName` is missing.
3. `Created:` — ISO 8601 timestamp from `created`; render `"N/A"` if the field is absent or null (uncommon in practice but graceful-degradation safe).
4. `Updated:` — ISO 8601 timestamp from `updated`; render `"N/A"` if the field is absent or null (uncommon in practice but graceful-degradation safe).
5. `JSM internal:` — `"Yes"` if `sd.public.comment.internal == true`; `"No"` if `false`; `"N/A"` if the property is absent or the `properties` array is empty. If the property is present but its `value.internal` sub-key is absent, null, or not a JSON boolean (e.g., stringly-typed `"true"` per JSDCLOUD-9766), render `"N/A"`. If multiple entries share key == `"sd.public.comment"`, the FIRST such entry (by array order) is authoritative; subsequent duplicates are ignored (matches `iter().find()` idiom). Do NOT panic; graceful-degradation-safe like fields 2/4/6.
6. `Restricted:` — value from the Jira `visibility` field (`{"type": "role"|"group", "value": "<name>", "identifier": "<id-or-name>"}`): four-rung ladder — (a) if `type` is `"role"` or `"group"` AND `value` is a non-null, non-empty string → display `<value>`; (b) else if `type` is `"role"` or `"group"` AND `value` is not a non-empty string (i.e., absent, null, non-string, or empty string `""`) BUT `identifier` is a non-null, non-empty string → display `"id=<identifier>"` (distinguishable marker — NOT bare `"None"`, to avoid misrepresenting a real restriction as unrestricted); (c) else if `type` is any non-null, non-empty string (including unrecognized types) AND either `value` or `identifier` is a non-null, non-empty string → display `<type>:<value-or-identifier>` (prefer `value` if non-null/non-empty, else use `identifier`; defensive rendering for unknown restriction kinds — prevents future Jira visibility types silently reading as `"None"`); (d) `"None"` if the `visibility` key is absent or null, or if all identity candidates are absent/null/non-string after exhausting rungs (a)–(c). Do NOT panic; graceful-degradation-safe like fields 1–5. Distinct from JSM internal/public flag — this is Jira's comment-level role/group restriction. (Research citation: `.factory/research/issue-577-visibility-identifier-shape-2026-07-10.md` — Q1 schema VALIDATED high: `identifier` formally documented alongside `value` in the Jira Cloud visibility bean; Q2 identifier-only GET responses INCONCLUSIVE-leans-rare: mechanism supported by GDPR group-ID migration, but no Atlassian-authoritative GET-response example with `identifier` and absent `value` was found; defensive rendering chosen so an identifier-only restriction never silently reads as "None".)
7. Body — rendered below the header fields via `adf_to_text`, separated by a blank line. If body is absent or null, render an empty body block (blank line after the header fields, no additional content). Do NOT panic. A present but malformed ADF value that produces an `adf_to_text` error propagates per EC-3.5.010-2 (a).

All field lines (fields 1–6) render as `<label> <value>` — single space between the label's colon and the first character of the value, LF line terminator. Example: `"JSM internal: Yes\n"`, `"Restricted: None\n"`.

The human render path accesses all fields via `serde_json::Value` (same code path as JSON output; no typed `Comment` round-trip; the typed `Comment` struct is NOT extended this cycle and MUST NOT be used for deserializing the view response — it would silently drop `updated`/`self`/`updateAuthor`/`visibility`/`jsdPublic` — the `serde_json::Value` passthrough is mandatory).

Routing: the F4-added `handle_comment_view` handler (sibling to the existing `handle_comment` in `src/cli/issue/workflow.rs`; relocates to `interactions.rs` under PF-017 at F4) delegates the render step to a dedicated `render_comment_view` helper (or equivalent) in the same file.

**Response 200 — JSON output** (`--output json`):

The raw Jira response is deserialized as `serde_json::Value` and routed through `output::render_json` (pretty-printed, per JSON render invariant #526). **No typed `Comment` round-trip** — the Value passthrough preserves every field returned by Jira, including fields not present in `src/types/jira/issue.rs::Comment` (e.g., `"self"`, `"updateAuthor"`, `"jsdPublic"`). (`renderedBody` appears only with `?expand=renderedBody`, which `jr` does not request this cycle.) The `properties` key is passed through as returned by the API (absent entirely or empty `[]` on non-JSM issues; populated for JSM issues) — see EC-3.5.010-1.

**Response 404** → exit 64 (`UserError`); stderr: `"comment not found or permission denied: <KEY>#<ID>"`. Append the Jira response body on a separate stderr line following the preamble (text mode; JSON mode carries both in the single H-020 envelope error field, newline JSON-escaped as `\n`) (applied by architectural inference from Claim 3 (DELETE-verified) to GET; same rationale as BC-3.5.004). See BC-3.5.004 implementation note for the recommended `downcast_ref::<JrError>()` body-surfacing mechanism — applies identically here.

**Response 403** (if surfaced by endpoint variant) → same treatment as 404: exit 64 + surface body (preamble + Jira response body) — inherits BC-3.5.004's 403 clause.

**Other 4xx/5xx (except 401)** → propagate via `JrError::ApiError`; exit 1. **401** → framework auth-error path (`JrError::NotAuthenticated` / `JrError::InsufficientScope`); exit 2 per error-taxonomy.md §Section 3.

**EC-3.5.010-1**: `--output json` returns the full `Comment` JSON shape. The `properties` array may be present (empty `[]` or populated) OR absent entirely on non-JSM issues; the `serde_json::Value` passthrough preserves either shape unchanged. For JSM internal comments, `properties` contains `[{"key":"sd.public.comment","value":{"internal":true}}]`. Consumers MUST treat `properties` as OPTIONAL — a missing key is valid and must not cause a panic or deserialization error.

**EC-3.5.010-2**: ADF body in the comment is rendered via `adf_to_text` in human mode. (a) A `JrError::UserError` from `adf_to_text` (currently only the depth-guard, BC-7.2.012 / SEC-001) propagates unchanged; exit 64. (b) Any other future `adf_to_text` error kind is NOT covered by this cycle and MUST be re-classified when introduced.

**Verification Properties**:

**VP-577-007**: `comment view FOO-1 --id 10001 --output json` against a wiremock returning a JSM internal comment → exit 0; stdout is valid JSON parseable by `serde_json`; top-level keys include `"id"`, `"author"`, `"body"`, `"created"`, `"updated"`, `"properties"`; `jq '.properties[0].value.internal'` equals `true`; AND the captured wiremock request URL contains the query parameter `expand=properties` (wiremock request-capture assertion, mirroring H-NEW-COMMENT-004 Setup A).

**VP-577-016**: `comment view FOO-1 --id 10001 --output json` against a wiremock response that includes a `"self"` URL field (a standard Jira API field absent from the typed `Comment` struct) → the `"self"` key survives in stdout JSON (lossless `serde_json::Value` passthrough confirmed; no typed round-trip lossy drop). Parse-level test against wiremock fixture.

**VP-577-021**: `comment view FOO-1 --id 10001` (NO `--output json`) against a wiremock fixture returning a JSM-internal comment → exit 0; stdout contains each of the exact labels `"ID:"`, `"Author:"`, `"Created:"`, `"Updated:"`, `"JSM internal: Yes"`, `"Restricted: None"` in that byte order; body text appears after a blank-line separator following the key-value header block. **Second variant (body-absent fallback)**: same invocation against a fixture where `body` is absent from the JSON response → exit 0; header fields render with their graceful-degradation fallbacks (fields 1–6 per BC-3.5.010); empty body block (blank line after header fields, no additional content); no panic. Byte-level pin: stdout ends with `"Restricted: None\n\n"` — the structural blank line separator always renders, leaving nothing after it when body is absent. **Third variant (JSM internal N/A — property absent)**: same invocation against a fixture where `properties` is absent entirely from the JSON response → exit 0; stdout contains the exact substring `"JSM internal: N/A"` (single space after colon, per the `<label> <value>` separator rule); stdout does NOT contain `"JSM internal: Yes"` or `"JSM internal: No"`. Pins the `"N/A"` render path (field 5) and confirms the `<label> <value>` format rule at byte level. **Fourth variant (field-6 rung (a) — named role)**: same invocation against a fixture where `visibility` is `{"type":"role","value":"Administrators"}` → exit 0; stdout contains `"Restricted: Administrators"` (field-6 rung (a): `type == "role"` AND `value` non-empty → display value directly). **Fifth variant (field-6 rung (b) — empty value, identifier fallback)**: same against a fixture where `visibility` is `{"type":"role","value":"","identifier":"admin-role-id"}` → exit 0; stdout contains `"Restricted: id=admin-role-id"` (field-6 rung (b): `type == "role"` AND `value` empty AND `identifier` non-empty → display `id=<identifier>`). **Sixth variant (field-6 rung (c) — non-role type with non-empty value)**: same against a fixture where `visibility` is `{"type":"team","value":"AlphaTeam","identifier":"team-123"}` → exit 0; stdout contains `"Restricted: team:AlphaTeam"` (field-6 rung (c): `type != "role"` AND `value` non-empty → display `<type>:<value>`). **Seventh variant (JSM internal: No — `internal: false`)**: same against a fixture where `properties` is `[{"key":"sd.public.comment","value":{"internal":false}}]` → exit 0; stdout contains `"JSM internal: No"` (field-5 `internal: false` → render `"No"`); stdout does NOT contain `"JSM internal: Yes"` or `"JSM internal: N/A"`. (Variants 4–7 added adversary pass-39 F5/M1.)

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 4; research verdicts Claim 4 CONFIRMED, Claim 2 CONFIRMED; adversary pass-3 MEDIUM-2 + MEDIUM-3 + LOW-1 remediation; adversary pass-13 F2 VP-577-021; adversary pass-34 F-577-B field-6 identifier-fallback (defensive rendering; research issue-577-visibility-identifier-shape-2026-07-10.md); adversary pass-35 F-A2 Other-4xx/5xx-except-401 + 401-auth-path clause; F-A6 field-6 rung(c/d) unknown-type defensive rendering; adversary pass-36 F-2 field-6 rung(b) broadened to include empty-string value; adversary pass-37 F-03 normative label-value separator added + VP-577-021 third variant (JSM internal: N/A byte-level pin); F-04 EC-3.5.010-2 split (a/b) + field-7 cross-ref updated; adversary pass-38 F-03 VP-577-007 "updated" key added + H-NEW-COMMENT-004 Expected A properties assertion hardened; adversary pass-39 F5 VP-577-021 variants 4/5/6 (field-6 rungs a/b/c); M1 VP-577-021 variant 7 (JSM internal: No); adversary pass-40 F-01 routing-sentence mis-anchor corrected (handle_comment_view sibling + relocates qualifier); issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.011: `--internal` and `--public` are mutually exclusive on `comment edit`; exit 2

**Confidence**: HIGH
**Source**: `src/cli/mod.rs` (clap `conflicts_with` annotation on `CommentSubcommand::Edit`)
**Subject**: Issue write

`--internal` and `--public` are mutually exclusive options on `jr issue comment edit`, enforced by clap `conflicts_with`. Passing both → clap `conflicts_with` rejects the combination during argument parsing, before any handler dispatch or HTTP call; exit 2.

**EC-3.5.011-1**: The clap error for `--internal --public` will contain "cannot be used with" language (clap default message). No custom error handler is required; the invariant is that the process exits 2.

**Verification Properties**:

**VP-577-010**: `jr issue comment edit FOO-1 --id 10001 --internal --public "text"` → exit 2; stderr contains `"cannot be used with"` (clap default mutual-exclusion message); no HTTP call made. Parse-level test (wiremock-free).

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 1; adversary pass-1 MEDIUM-6 remediation; issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.012: `jr issue comment` becomes a subcommand group; old flat form produces clap error with migration hint

**Confidence**: HIGH
**Source**: `src/cli/mod.rs` (`IssueCommand::Comment(CommentSubcommand)`); `src/cli/issue/mod.rs` (dispatch); `src/cli/issue/workflow.rs::handle_comment` (handlers relocate to interactions.rs under PF-017 at F4; citations updated at delivery)
**Subject**: Issue write

**Breaking CLI change. DEC-168 ruling 2: Option A clean break.**

`IssueCommand::Comment` changes from a leaf variant (with positional `message` argument) to a subcommand group (`Comment(CommentSubcommand)`) with variants:

- `Add` — canonical form of the existing `comment add` behavior, byte-for-byte identical to the old `jr issue comment <KEY> <text>`. Preserves all existing fields: positional message, `--file`, `--stdin`, `--internal`, `--markdown`.
- `Delete` — new (BC-3.5.002..BC-3.5.004).
- `Edit` — new (BC-3.5.005..BC-3.5.009, BC-3.5.011).
- `View` — new (BC-3.5.010).

The old flat form `jr issue comment <KEY> "text"` is NOT preserved as a compatibility shim. clap's subcommand dispatch interprets the KEY as an unknown subcommand name and produces a usage error.

**EC-3.5.012-1**: The custom hint fires on **any** `ErrorKind::InvalidSubcommand` under `jr issue comment`, with two sub-cases:

- **`list` or `ls` token** (`jr issue comment list …` or `jr issue comment ls …`): exit 2 AND stderr contains `"jr issue comments"` (the plural form — directs to `IssueCommand::Comments`, the existing command for listing all comments on an issue). Token matching for the list/ls sub-case is case-insensitive (`eq_ignore_ascii_case` — `LS`, `List`, `LIST` all route to the plural hint).
- **All other invalid tokens** (including the flat form `jr issue comment KEY "text"`, KEY-only form `jr issue comment FOO-1`, and typos like `jr issue comment addd KEY`): exit 2 AND stderr contains `"use \`jr issue comment add\` instead"` (load-bearing substring — asserted by VP-577-008). Typos of delete/edit/view (e.g. `del`, `edt`, `vw`) also receive the 'add' hint by design this cycle — the fixed hint favors the migration case; Levenshtein-based typo discrimination (restoring clap's default suggestion for close matches) is a follow-up story candidate.

Because clap 4 does NOT print the parent subcommand's `about`/`long_about` text in `InvalidSubcommand` errors (verified against compiled `jr`), the hint MUST be injected by custom error handling — e.g., intercepting the clap error kind and inspecting the attempted subcommand token in a `try_parse` path or equivalent. The mechanism is the implementer's choice; the two-sub-case invariant above is binding.

**Implementation note (sub-case discrimination)**: The REQUIRED approach is to walk the clap `Error` context() iterator as the authoritative source for the attempted-subcommand token — argv inspection is NON-RECOMMENDED due to the global-flag reordering hazard (`jr --output json issue comment KEY "text"` places a flag between `jr` and `issue`, breaking naive positional scans of `argv`). The discrimination logic MUST be isolated from the rendering path so non-`InvalidSubcommand` errors are never intercepted.

**Invariant (clap rendering preservation)**: The try_parse error handler MUST preserve clap's default rendering for every non-`InvalidSubcommand` error kind (`ArgumentConflict`, `MissingRequiredArgument`, `UnknownArgument`, and all others) byte-identically to pre-refactor behavior. The handler intercepts `InvalidSubcommand` ONLY; all other clap error kinds pass through unmodified.

In contrast, a **bare** `jr issue comment` with no arguments (`ErrorKind::MissingSubcommand`) → clap's built-in subcommand listing is the migration guidance and NO custom hint is injected. The listing already enumerates `add`, `delete`, `edit`, `view`, which IS the migration hint. This asymmetry is intentional: MissingSubcommand is the "don't know what to type" case; InvalidSubcommand is the "typed the wrong thing" case where specific direction adds value.

`IssueCommand::Comments` (plural, `jr issue comments <KEY>`) is KEPT unchanged and NOT merged into the new subcommand group. Help text for `jr issue comment` SHOULD mention: "to list all comments, use `jr issue comments`" (or equivalent phrasing directing to the plural form).

**EC-3.5.012-2**: `jr issue comment add FOO-1 "text"` (new canonical form) → behavior byte-for-byte identical to the former `jr issue comment FOO-1 "text"`. All existing tests updated to use the `comment add` form in the same PR as story S-577-1.

**EC-3.5.012-3**: `CommentSubcommand::Add` positional `<message>` MUST carry `allow_hyphen_values = true` (CLAUDE.md invariant — applied to all positional free-text write-command inputs). `jr issue comment add FOO-1 "- [ ] task"` MUST parse successfully; the leading dash MUST NOT be interpreted as an unknown flag. `CommentSubcommand::Edit` positional `<text>` MUST ALSO carry `allow_hyphen_values = true` for the same reason — `jr issue comment edit FOO-1 --id 10001 "- update"` MUST parse successfully. Regression pins: VP-577-018 (add path) and VP-577-019 (edit path).

**EC-3.5.012-4**: `comment edit` and `comment delete` do NOT support `--dry-run` in this cycle (parity gap with `issue edit` BC-3.4.021 acknowledged). Passing `--dry-run` to either subcommand → exit 2 (clap unknown flag). Adding dry-run support to comment operations is a **follow-up story candidate**.

**Follow-up story candidate (stray-confirmation-flag stderr hint — human-approved 2026-07-11)**: Emit `"note: --yes has no effect without --public"` to stderr (suppressed under `--output json`) when `--yes` is passed without `--public` on `comment edit`. Consider applying the same hint pattern to `--no-resolution` (non-done transitions) and `--no-input` (already-non-TTY stdin) for house-wide consistency. Human-approved candidate 2026-07-11; research: `.factory/research/issue-577-yes-flag-noop-convention-2026-07-11.md`.

**EC-3.5.012-5** (try_parse regression obligations, story-input scope): The `src/main.rs` `try_parse()` refactor required by EC-3.5.012-1 modifies the whole-CLI clap error path. The implementing story (S-577-1) MUST include regression-test obligations for the following surfaces: (a) BC-3.7.003/004 remote-link error paths; (b) BC-3.8.010 JSM create error paths; (c) `--help` snapshot tests; (d) `tests/e2e_cli_surface_guard.rs` SURFACE table — the existing single `comment` row MUST be replaced with four rows (one each for `comment add`, `comment delete`, `comment edit`, `comment view`) each carrying its own flag set; (e) `tests/e2e_live.rs` flat-form sweep per EC-3.5.012-2 (all `"issue", "comment"` call sites updated to `comment add` form in the same PR as the CLI refactor). Regression suites for each surface MUST pass unchanged post-refactor. (BC-3.4.011 removed from this list at adversary pass-32 F4 — it is post-clap HTTP-400 handling, orthogonal to the parse-time intercept exercised by the `try_parse()` refactor.) (f) `README.md`: the §Commands table entry and EVERY `jr issue comment …` example (currently `README.md` ~lines 185, 188, 212, 339) MUST be updated to the `jr issue comment add` form in the same PR as the CLI refactor. Note that `tests/claude_md_citations.rs` guards file paths only, not command-example text — hence the explicit obligation here. (g) `CLAUDE.md`: the "allow_hyphen_values on free-text CLI args" bullet MUST be updated to cite `issue comment add` (positional message) AND `issue comment edit` (positional text) per EC-3.5.012-3 in the same PR as the CLI refactor.

**CHANGELOG requirement**: A "Breaking Changes" entry documenting the rename from `jr issue comment` to `jr issue comment add` is REQUIRED in the same PR as the CLI surface refactor (story S-577-1). Minimum version bump: next minor boundary per project convention (e.g., 0.6.x → 0.7.0).

**Verification Properties**:

**VP-577-008**: `jr issue comment FOO-1 "some text"` (old flat form, InvalidSubcommand) → exit 2; stderr contains the exact substring `"use \`jr issue comment add\` instead"` (load-bearing marker text). Parse-level test (wiremock-free; no network call made).

**VP-577-014**: `jr issue comment` (bare, no subcommand, MissingSubcommand) → exit 2; stderr contains clap's subcommand listing (names `add`, `delete`, `edit`, `view`); stderr does NOT contain the prefix `"use \`jr issue comment"` (the shared marker prefix — confirms no custom InvalidSubcommand hint was injected on the MissingSubcommand path). Parse-level test (wiremock-free).

**VP-577-015**: `jr issue comment list FOO-1` (list token, InvalidSubcommand) → exit 2; stderr contains `"jr issue comments"` (the plural form hint). Parse-level test (wiremock-free; no network call made).

**VP-577-018**: `jr issue comment add FOO-1 "- [ ] task"` → parses without clap error (exit code is NOT 2); the leading-dash body text is accepted as a positional argument. Parse-level test (wiremock-free; no network call required — the test need not exercise the HTTP path; formalizes EC-3.5.012-3's `allow_hyphen_values` regression pin for the add path).

**VP-577-019**: `jr issue comment edit FOO-1 --id 10001 "- update"` → parses without clap error (exit code is NOT 2); the leading-dash positional `<text>` is accepted without being treated as an unknown flag. Parse-level test (wiremock-free; formalizes EC-3.5.012-3's `allow_hyphen_values` regression pin for the edit path).

**VP-577-020**: `jr issue comment ls FOO-1` (`ls` alias token, `InvalidSubcommand`) → exit 2; stderr contains `"jr issue comments"` (the plural-form hint directing to `IssueCommand::Comments`). Parse-level test (wiremock-free; no network call made). Mirrors VP-577-015 (`list` token); confirms the EC-3.5.012-1 two-sub-case discrimination covers both the `list` and `ls` alias tokens. **Mixed-case variant:** `jr issue comment LS FOO-1` → exit 2; stderr contains `"jr issue comments"` (pins the EC-3.5.012-1 pass-24 F3 `eq_ignore_ascii_case` rule — `LS`, `List`, `LIST` all route to the plural hint).

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 2 Option A; adversary pass-1 HIGH-1 + LOW-1; adversary pass-2 MEDIUM-2 + LOW-3 + MEDIUM-4 remediation; adversary pass-3 HIGH-2 + MEDIUM-4 + LOW-4 remediation; adversary pass-5 L2 VP-577-018; adversary pass-7 F3 VP-577-019; adversary pass-8 L3 VP-577-020; adversary pass-25 VP-577-020 mixed-case variant; adversary pass-32 F4 BC-3.4.011 removed from EC-3.5.012-5 item (a); adversary pass-35 F-A1 EC-3.5.012-5 items (f)+(g) README+CLAUDE.md migration obligations; adversary pass-37 F-01 Edit subcommand-to-BC map corrected (BC-3.5.010 removed from Edit range); issue #577 SOH-COMMENT-CRUD-1)

---

### 3.6 Links

#### BC-3.6.001: `issue link <k1> <k2> [--type T]` POSTs `/rest/api/3/issueLink`; default type "Relates"

**Confidence**: HIGH
**Source**: `src/api/jira/links.rs::tests`; `tests/issue_commands.rs:233-248`
**Trace**: Pass 3 BC-216; BC-1045 (R4)

---

#### BC-3.6.002: `issue link FOO-1 FOO-2 --type block` single-substring → exit 64 + `"Ambiguous link type"` + ZERO POST

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1812-1867`
**Trace**: Pass 3 BC-1080 (R4)

---

#### BC-3.6.003: `issue unlink FOO-1 FOO-2 --type block` single-substring → exit 64 + ZERO DELETE

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:1869-1920`
**Trace**: Pass 3 BC-1081 (R4)

---

#### BC-3.6.004: `client.delete_issue_link("10001")` DELETEs `/rest/api/3/issueLink/10001`; accepts 204

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:250-262`
**Trace**: Pass 3 BC-1046 (R4)

---

#### BC-3.6.005: `client.list_link_types()` returns 3 link types from `/rest/api/3/issueLinkType`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:188-206`
**Trace**: Pass 3 BC-218; BC-1043 (R4)

---

### 3.7 Remote Links

#### BC-3.7.001: `issue remote-link <key> --url X` POSTs `/issue/<key>/remotelink`; URL gains trailing slash from `url::Url::parse` normalization

**Confidence**: HIGH
**Source**: `tests/issue_remote_link.rs:19-84`
**Behavior**: Body partial-JSON: `{object: {url: "https://example.com/", title: "Example"}}`. Trailing slash on URL. Output JSON: `{key, id, url, title, self}` (5 keys, normalized URL).
**Trace**: Pass 3 BC-222; BC-1126 (R4)

---

#### BC-3.7.002: `issue remote-link` defaults `--title` to URL when omitted

**Confidence**: HIGH
**Source**: `tests/issue_remote_link.rs:87-147`
**Trace**: Pass 3 BC-223; BC-1127 (R4)

---

#### BC-3.7.003: `issue remote-link --url not-a-url` → exit 64 + `"--url"` + `"not a valid url"`; ZERO HTTP

**Confidence**: HIGH
**Source**: `tests/issue_remote_link.rs:259-301`
**Behavior**: Pre-HTTP URL validation.
**Trace**: Pass 3 BC-1130 (R4)

---

#### BC-3.7.004: `issue remote-link --url ftp://example.com` → exit 64 + `"http or https"` + `"ftp"`

**Confidence**: HIGH
**Source**: `tests/issue_remote_link.rs:309-348`
**Behavior**: Scheme allowlist: only `http` and `https` accepted; all other schemes (e.g., `ftp`) rejected. Any URL whose scheme is not `http` or `https` triggers exit 64 with stderr containing `"http or https"` and the rejected scheme name.
**Trace**: Pass 3 BC-1131 (R4)

---

### 3.8 JSM Request Create + Platform-Path Inverse Warnings + Auth-Conditional 401 Hints

17 behavioral contracts covering: (a) `jr issue create --request-type` dispatch to the JSM service desk API
(BC-3.8.001..009), (b) forward-direction cross-flag warnings when platform-only flags are passed alongside
`--request-type` (BC-3.8.010..011), (c) inverse-direction cross-flag warnings when JSM-only flags are
passed on the platform path (BC-3.8.012..013), (d) auth-conditional 401 error hints on the JSM POST
path: Basic-auth API-token-expiry hint (BC-3.8.014) and OAuth write-scope hint (BC-3.8.015), gated solely
by `JiraClient::is_oauth_auth()`, and (e) JSM-path input guards: empty `--request-type` early-exit
(BC-3.8.016) and `--markdown` + `--field description=` conflict rejection (BC-3.8.017).
BCs 001..011 require `--request-type` to be set. The platform path (BC-3.3.001) — its POST body,
JSON response, and exit code — is unchanged when `--request-type` is absent. BCs 012..013 add
inverse-direction stderr warnings on the platform path (when `--field` / `--on-behalf-of` are
passed without `--request-type`) without altering POST behavior, response, or exit code.

---

#### BC-3.8.001: `issue create --request-type <NAME|ID>` dispatches to `POST /rest/servicedeskapi/request`; platform POST body, JSON response, and exit code unchanged when `--request-type` absent

**Confidence**: HIGH
**Subject**: Issue write (JSM path)
**Behavior**: When `--request-type` is present, `handle_create` dispatches to `JiraClient::create_jsm_request` which POSTs to `/rest/servicedeskapi/request`. Body: `{serviceDeskId (string), requestTypeId (string), requestFieldValues (map), isAdfRequest (bool)}`. Response 201 includes `issueKey`. Output JSON (both table and `--output json`): `{"key": "<issueKey>"}` — identical shape to platform create. When `--request-type` is absent, the `POST /rest/servicedeskapi/request` endpoint is not called (validated by `expect(0)` mock pattern).
**Inputs**: `--request-type <NAME|ID>`, `--project <KEY>` (or active profile), `--summary <text>`
**Outputs/Effects**: HTTP POST to `/rest/servicedeskapi/request`; stdout `{"key": "HELP-42"}` on success; exit 0.
**Errors**: Non-JSM project (via `require_service_desk`) → exit 64 before any HTTP; see BC-3.8.002. 401 → BC-3.8.009 (auth-conditional: Basic-auth API-token hint → BC-3.8.014; OAuth → BC-3.8.015).
**Trace**: `tests/issue_create_jsm.rs` (integration tests — dispatch path, routing guard); `src/cli/issue/create.rs` (conditional dispatch branch)
**Source**: API-verified: `POST /rest/servicedeskapi/request` returns 201 with `{issueId, issueKey, currentStatus, _links}`
**Confidence**: HIGH

> **[UPDATED 2026-05-19 issue #384]** Errors cross-reference updated: 401 on the JSM POST is auth-conditional; see BC-3.8.009 (auth-conditional gate), which cross-references BC-3.8.014 (Basic-auth: API-token-expiry hint) and BC-3.8.015 (OAuth: existing write-scope hint behavior). No behavioral change — cross-reference refresh only.

---

#### BC-3.8.002: JSM body uses `requestFieldValues` map; `serviceDeskId` resolved via `require_service_desk` from `--project`

**Confidence**: HIGH
**Subject**: Issue write (JSM path)
**Behavior**: Before POSTing, `handle_jsm_create` calls `require_service_desk(client, project_key)` to resolve the numeric `serviceDeskId` string. The JSM request body uses `requestFieldValues` (a `Map<String, serde_json::Value>`) for all field values, NOT the platform `fields` map. `serviceDeskId` is a required top-level field (string, NOT integer). If `--project` is absent and no active-profile project is configured, exits 64 with actionable message before any HTTP.
**Inputs**: `--project <KEY>` (or config active project); resolved `serviceDeskId`
**Outputs/Effects**: Body shape: `{serviceDeskId: "3", requestTypeId: "5", requestFieldValues: {...}}`. `serviceDeskId` is the string representation of the integer ID returned by the service desk list API.
**Errors**: Non-JSM project → `require_service_desk` returns `JrError::UserError`; exit 64; no HTTP to servicedeskapi. Error message MUST be call-site-specific: 'Project "<KEY>" is a <type> project. `--request-type` requires a Jira Service Management project. Run "jr project list" to find a JSM project.' (NOT the legacy "Queue commands require…" string from BC-X.8.004 — that string is reserved for queue commands only; see BC-3.8.002 and BC-X.8.004 [UPDATED 2026-05-18 issue #288].) No project resolvable AND (`no_input` is effective OR `prompt_input` itself errors) → exit 64 with the harmonized message: "Project key is required for JSM request creation. Use --project or configure .jr.toml. Run \"jr project list\" to see available JSM projects." — carries the same `--project` / `.jr.toml` / `jr project list` affordances as the platform path (see BC-3.3.001) while preserving the "for JSM request creation" context. Note: `no_input` is effective when set explicitly via `--no-input` OR when stdin is not a TTY (`--no-input` is auto-enabled on non-TTY stdin per CLAUDE.md). The code site (`src/cli/issue/jsm_create.rs::handle_jsm_create` §"project-key resolution") checks `no_input` only — the non-TTY case is already covered by that single flag. When `no_input` is NOT effective, the handler attempts `helpers::prompt_input("Project key")` first; the harmonized error surfaces only if the prompt itself errors.
**Trace**: `tests/issue_create_jsm.rs` (service desk ID resolution, non-JSM project error path, missing-project error string); `src/api/jsm/servicedesks.rs::require_service_desk`
**Source**: API-verified: `serviceDeskId` is a required string in request body
**Confidence**: HIGH

> **[UPDATED 2026-05-20 issue #385 O-08-02]** The "no project configured" error string harmonized. Previous verbatim: `"project is required for JSM request creation"` (terse, lowercase, no affordances). New verbatim: `"Project key is required for JSM request creation. Use --project or configure .jr.toml. Run \"jr project list\" to see available JSM projects."` — adds `--project`/`.jr.toml`/`jr project list` affordances, sentence-cases the opening, and preserves the JSM-specific context label. The implementing story MUST update `test_jsm_create_missing_project_exits_64_with_jsm_specific_hint` (in `tests/issue_create_jsm.rs`) to assert the new string. The previous error string was: `"project is required for JSM request creation"`.

> **[UPDATED 2026-05-20 issue #385 adversary pass-8 M-01]** Precondition for the harmonized error qualified: the error fires only when no project is resolvable AND `no_input` is effective (OR `prompt_input` itself errors). `no_input` is effective when set explicitly via `--no-input` OR when stdin is not a TTY (auto-enabled per CLAUDE.md) — the code site checks `no_input` only; the non-TTY path is not a separate trigger. When `no_input` is not effective, the handler attempts `helpers::prompt_input` first. "No project configured" alone (without the `no_input`-effective qualifier) is an incomplete precondition.

> **[UPDATED 2026-05-20 issue #385 adversary pass-13 H-1]** Reframed from three independent triggers (`--no-input` / non-TTY / `prompt_input` failure) to TWO conditions: (1) `no_input` is effective (covering both explicit `--no-input` and auto-enabled non-TTY as a single flag check), (2) `prompt_input` itself errors. Resolves the apparent contradiction between "three triggers" in the BC and "one check (`no_input`)" in the code.

---

#### BC-3.8.003: `--request-type <NAME>` resolved via partial-match (case-insensitive); errors clean on Ambiguous, ExactMultiple, None with `jr requesttype list` hint

**Confidence**: HIGH
**Subject**: Issue write (JSM path)
**Behavior**: When `--request-type` is a non-numeric string, the handler fetches (or cache-hits) the service desk's request type list, then calls `partial_match(input, &names)`. `MatchResult::Exact(id)` → proceeds. `MatchResult::Ambiguous` or `MatchResult::ExactMultiple` → exits 64 with "Ambiguous request type" + candidate names + hint "Run `jr requesttype list --project <KEY>` to see all request types". `MatchResult::None` → exits 64 with "Request type not found" + hint. In `--no-input` mode, ambiguous partial match exits 64 cleanly (does NOT prompt).

[UPDATED 2026-05-19 issue #288 pr4 adversary-pass-01 H-01] Hint verb aligned from
"Use" to "Run" to match Wave 2 cli/requesttype.rs sibling (line 227) and the
Wave 3 `src/cli/issue/jsm_create.rs` RT-resolution hint site (dispatch fork decision
remains in `create.rs::handle_create`). Imperative active
verb fits jr CLI ergonomics. Wave 2 pass-02 M-2 precedent applied.
**Inputs**: `--request-type <NAME>` (string, non-numeric); service desk request type list (API or cache)
**Outputs/Effects**: Resolved `requestTypeId` string passed into JSM request body.
**Errors**: Ambiguous → exit 64; None → exit 64; both with actionable hint. Zero HTTP to `POST /rest/servicedeskapi/request` on error paths.
**Trace**: `tests/issue_create_jsm.rs` (name-not-found path, ambiguous-match path); `src/partial_match.rs`; `src/cli/requesttype.rs`
**Source**: Follows `partial_match` pattern established by `jr issue move` and `jr queue`
**Confidence**: HIGH

---

#### BC-3.8.004: `--request-type <ID>` (numeric string) bypasses name resolution

**Confidence**: HIGH
**Subject**: Issue write (JSM path)
**Behavior**: When `--request-type` value is parseable as a non-negative integer (e.g., `"5"`, `"12"`), the value is used directly as `requestTypeId` without fetching or querying the request type list. No partial-match is performed. No cache read for this path. The numeric string is passed verbatim as `requestTypeId` in the JSM request body.
**Inputs**: `--request-type <ID>` where ID parses as `u64`
**Outputs/Effects**: Body includes `requestTypeId: "<numeric-string>"`; no GET to request type list endpoint.
**Errors**: If the API rejects the ID (e.g., 400 "invalid request type"), standard API error path applies (exit 1 + message).
**Trace**: `tests/issue_create_jsm.rs` (numeric-ID bypass path)
**Source**: Consistent with `jr queue view <ID>` numeric-bypass pattern
**Confidence**: HIGH

---

#### BC-3.8.005: `--summary` → `requestFieldValues.summary` (required by JSM API)

**Confidence**: HIGH
**Subject**: Issue write (JSM path)
**Behavior**: The `--summary` flag value is placed in `requestFieldValues["summary"]` as a JSON string. The JSM API requires `summary` in `requestFieldValues` (not as a top-level field). If `--summary` is absent and `--no-input` is set, exits 64 with "summary is required" — mirrors existing platform required-summary behavior. Interactive mode (TTY, no `--no-input`) may prompt for summary.
**Inputs**: `--summary <text>`
**Outputs/Effects**: `requestFieldValues["summary"] = "<text>"` in body.
**Errors**: Missing `--summary` + `--no-input` → exit 64 "summary is required for JSM request submission".
**Trace**: `tests/issue_create_jsm.rs` (summary field mapping); body shape assertions
**Source**: API-verified: `summary` is a required field in `requestFieldValues` for most request types
**Confidence**: HIGH

---

#### BC-3.8.006: `--description` → `requestFieldValues.description`; `--markdown` triggers ADF; plain text uses `text_to_adf` + `isAdfRequest: true`

**Confidence**: HIGH
**Subject**: Issue write (JSM path)
**Behavior**: When description is provided, `isAdfRequest: true` is always set in the request body (both plain-text and markdown paths use ADF). Plain-text description (`--description "text"` without `--markdown`) is converted via `text_to_adf("text")` and placed in `requestFieldValues["description"]`. Markdown description (`--description "**bold**" --markdown`) is converted via `markdown_to_adf("**bold**")` and placed in `requestFieldValues["description"]`. When description is absent, `requestFieldValues["description"]` is omitted (NOT null) and `isAdfRequest` may be omitted or set to false. The ADF utilities are the same `src/adf.rs` functions used by the platform create path.
**Inputs**: `--description <text>` (optional), `--markdown` (flag)
**Outputs/Effects**: `requestFieldValues["description"] = <ADF-doc-object>` when description present; `isAdfRequest: true` in body when description present.
**Errors**: `--description` and `--description-stdin` clap conflict (inherits from platform create).
**Trace**: `tests/issue_create_jsm.rs` (description ADF conversion); `src/adf.rs` unit tests
**Source**: API-verified: `isAdfRequest: true` enables ADF for rich-text fields
**Confidence**: HIGH

---

#### BC-3.8.007: `--priority <NAME>`, `--label <X>` (repeatable) → `requestFieldValues.priority` / `requestFieldValues.labels`

**Confidence**: HIGH
**Subject**: Issue write (JSM path)
**Behavior**: `--priority <NAME>` maps to `requestFieldValues["priority"] = {"name": "<NAME>"}` (same object shape as platform priority; consistent with existing `jr issue create` platform behavior). `--label <X>` (repeatable) maps to `requestFieldValues["labels"] = ["<X1>", "<X2>", ...]` as a JSON array of plain strings — NOT `[{"name": "foo"}]`. These are system-field name mappings (using the field's logical name, not `customfield_NNNNN`). If the request type does not include these fields, the JSM API ignores or rejects them; no client-side validation of which fields are valid for a given request type is performed (validation is server-side).
**Inputs**: `--priority <NAME>` (optional), `--label <X>` (optional, repeatable)
**Outputs/Effects**: Corresponding entries in `requestFieldValues` map when flags are set.
**Errors**: Unsupported field for request type → API 400; handled as standard API error (exit 1 + message).
**Trace**: `tests/issue_create_jsm.rs` (priority and label mapping); body shape assertions
**Source**: Atlassian docs confirm `labels` wire shape is a plain string array `["alpha","beta"]` for both `POST /rest/api/3/issue` and `POST /rest/servicedeskapi/request` `requestFieldValues` (https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-labels/). Priority wire shape `{"name": "<NAME>"}` is consistent with current `jr` platform-create code. Caveat: JSDSERVER-4564 documents that JSM may silently ignore `requestFieldValues.priority` if the request type schema does not include priority — implementation MUST NOT assume the field surfaces in the response.
**Confidence**: HIGH

---

#### BC-3.8.008: `--field NAME=VALUE` (repeatable) maps NAME → `requestFieldValues`; `customfield_NNNNN` literal bypasses lookup; only first `=` splits key; empty value allowed; duplicate NAME → last wins

**Confidence**: HIGH
**Subject**: Issue write (JSM path)
**Behavior**: Each `--field NAME=VALUE` pair is parsed by splitting on the FIRST `=` only (value may contain `=`). The resulting `(name, value)` is inserted into `requestFieldValues` with `name` as the JSON key and `value` as a JSON string. If `NAME` begins with `customfield_` followed by digits (e.g., `customfield_10200`), it is used as-is as the key (no lookup). Otherwise, `NAME` is used as-is as the key (logical field name). Empty value (`--field "fieldname="`) is valid and inserts an empty string. Duplicate `NAME` entries → last occurrence wins (map semantics). `--field` entries are merged with `--summary`, `--description`, `--priority`, `--label` entries in `requestFieldValues`; `--field summary=X` overrides `--summary X` (last-wins on the map key).
**Inputs**: `--field NAME=VALUE` (optional, repeatable)
**Outputs/Effects**: Each pair inserted into `requestFieldValues`; merged with other field sources.
**Errors**: Missing `=` in `--field` value → exit 64 "invalid field format: expected NAME=VALUE".
**Trace**: `tests/issue_create_jsm.rs` (field mapping, first-equals split, duplicate-key, empty-value); body shape assertions
**Source**: Consistent with `--field` conventions; split-on-first-equals is standard CLI convention
**Confidence**: HIGH

---

#### BC-3.8.009: `--on-behalf-of <accountId>` → `raiseOnBehalfOf`; value passed through as-is; invalid accountIds rejected server-side

**Confidence**: HIGH
**Subject**: Issue write (JSM path)
**Behavior**: When `--on-behalf-of <accountId>` is set, the value is placed as `raiseOnBehalfOf: "<accountId>"` in the JSM request body top level (NOT inside `requestFieldValues`). When absent, `raiseOnBehalfOf` is omitted from the body entirely (NOT null). `--on-behalf-of` accepts the raw value as-is and passes through to JSM API as `raiseOnBehalfOf` field. No client-side regex format validation is performed — this matches `--account-id` pass-through behavior (see BC-3.1.001); client-side format validation would false-negative legacy accountIds (Atlassian accountIds are not documented as a fixed format; migrated accountIds may use colon-separated forms like `557058:abc...`). Invalid accountIds are rejected server-side by JSM with a 400 — surface that error with a hint to use `jr user search <query>` to look up accountIds. No email-to-accountId lookup is performed (consistent with `--account-id` convention elsewhere in `jr`).
**Inputs**: `--on-behalf-of <accountId>` (optional)
**Outputs/Effects**: `raiseOnBehalfOf: "<accountId>"` in body when set; omitted when absent.
**Errors**: JSM 400 on invalid accountId → exit 1 with API error message + hint "Use `jr user search <query>` to look up accountIds". 401 on the JSM POST is auth-conditional — see BC-3.8.014 (Basic-auth: API-token-expiry hint) and BC-3.8.015 (OAuth: `write:servicedesk-request` hint). See also BC-X.3.005 (InsufficientScope dispatch) + BC-1.6.042 (401 substring match) + H-NEW-JSM-RT-003 (OAuth scope-mismatch regression pin).
**Trace**: `tests/issue_create_jsm.rs` (raiseOnBehalfOf injection, absence omission); `src/cli/issue/jsm_create.rs::handle_jsm_create`
**Source**: BC-3.1.001 (`issue assign --account-id` pass-through precedent); BC-X.3.005 (server-rejected accountId error path). Pass-through behavior is the documented Atlassian recommendation; client-side format validation would false-negative legacy accountIds.
**Confidence**: HIGH

> **[UPDATED 2026-05-19 issue #384]** Errors section revised: the monolithic "Scope error for `write:servicedesk-request`" wording replaced with auth-conditional phrasing. The gate is `client.is_oauth_auth()` alone — not error variant. Basic-auth 401s (any body shape, including "scope does not match") route to BC-3.8.014 (API-token-expiry hint; any `InsufficientScope` is rewritten to `NotAuthenticated`). OAuth 401s route to BC-3.8.015 (existing behavior, now explicitly gated: for OAuth, BOTH the `InsufficientScope` arm AND the `NotAuthenticated` arm produce the `write:servicedesk-request` hint — the pre-#384 `map_err` at `src/cli/issue/jsm_create.rs::handle_jsm_create` §"map_err auth-rewrite" already rewrites `NotAuthenticated` to inject this hint for all auth schemes). The prior single-hint behavior is superseded by the auth-gate introduced in BC-3.8.014/015.
>
> **[REVISED 2026-05-19 issue #384 adversary-pass-2 H-05/H-06]** Corrected false claim: previous text stated OAuth `NotAuthenticated` gives "generic `jr auth login` hint" — this is FALSE. The existing pre-#384 `map_err` (`src/cli/issue/jsm_create.rs::handle_jsm_create` §"map_err auth-rewrite") already rewrites the `NotAuthenticated` arm to inject `write:servicedesk-request` for all auth schemes. Post-#384, that rewrite is preserved unchanged for OAuth. Both arms produce `write:servicedesk-request` for OAuth.

---

#### BC-3.8.010: `--type` is IGNORED with stderr warning when `--request-type` is set

**Confidence**: HIGH
**Subject**: Issue write (JSM path)
**Behavior**: When `--request-type` is present, the `--type` flag (if also supplied) is silently ignored at the JSM-dispatch site EXCEPT for emitting a single stderr line: "warning: --type is ignored when --request-type is set; request type encodes the issue type". Exit code unchanged (still 0 on success, or 64/1/2 on applicable error paths). JSON output shape is unchanged from BC-3.8.001. **Warning position (O-08-07):** the warning is emitted at step 5 of the Canonical Guard Ordering (see BC-3.8.016) — INSIDE `handle_jsm_create` AFTER `require_service_desk` returns `Ok`, and BEFORE request-type resolution (step 6: numeric-bypass check, `resolve_jsm_request_type_id`, `parse_field_kv`, POST). NOT before `handle_jsm_create` is called and NOT before `require_service_desk` is called. Consequence: on a non-JSM project (assuming `--request-type` is non-empty — an empty/whitespace-only `--request-type` exits at step 1 per BC-3.8.016 regardless of project type), the user sees ONLY the non-JSM project error (from `require_service_desk`), NOT both the warning and the error. The warning is suppressed on early-exit paths where `require_service_desk` fails. Because the warning fires at step 5 — before request-type resolution at step 6 — on a JSM project with an unresolvable `--request-type` name, the `--type` warning WILL have fired (step 5) and the partial-match error from BC-3.8.003 follows at step 6; both appear on stderr. This is acceptable because the project IS a valid service desk so the "type ignored" warning is genuinely informative. On the success path, the warning fires regardless of `--no-input` or `--output json` settings.
**Inputs**: `--request-type <X>` AND `--type <Y>` (both set simultaneously)
**Outputs/Effects**: Same JSM POST behavior as BC-3.8.001 with the `--type` value unused. One stderr line emitted: "warning: --type is ignored when --request-type is set; request type encodes the issue type". No change to stdout JSON shape. No change to exit code.
**Errors**: None — this is a warning path, not an error path. The presence of `--type` alongside `--request-type` is not an error.
**Trace**: `tests/issue_create_jsm.rs` (warning_on_type_with_request_type integration test; non-JSM project warning-suppression test)
**Source**: ADR-0014 §"Dispatch fork: --type interaction" — `--type` is meaningless in the JSM path because `requestTypeId` encodes the issue type server-side; emitting a warning rather than erroring preserves backward compatibility for scripts that habitually pass `--type`.
**Confidence**: HIGH

> **[UPDATED 2026-05-20 issue #385 O-08-07]** Warning position clarified: the `--type` warning MUST fire inside `handle_jsm_create` AFTER `require_service_desk` returns `Ok`, not before `handle_jsm_create` is entered. Previous behavior (warning firing pre-`require_service_desk` in `handle_create`) produced spurious dual output on non-JSM projects. The implementing story MUST add `test_jsm_create_type_flag_warning_suppressed_on_non_jsm_project` asserting that when `--request-type` is set (non-empty) + project is non-JSM, the `--type` warning is ABSENT from stderr and only the non-JSM project error is emitted. The existing test `test_jsm_create_type_flag_ignored_with_warning` (JSM path) MUST remain green — warnings still fire on the JSM success path.

> **[UPDATED 2026-05-20 issue #385 adversary pass-7 M-01]** Step placement made explicit: warning fires at step 5 (Canonical Guard Ordering), BEFORE request-type resolution at step 6 — not after. Removed stale "after flag parsing and request-type resolution succeed" wording. Removed stale "need not fire" clause for partial-match failure (BC-3.8.003): because the warning fires at step 5 BEFORE step-6 resolution, the warning WILL have appeared by the time partial-match failure surfaces — both messages appear on stderr on a JSM project with an unresolvable request type.

> **[UPDATED 2026-05-20 issue #385 adversary pass-8 H-03]** Threading note: achieving step-5 placement requires the `--type` (`issue_type`) flag value to be in scope inside `handle_jsm_create` at the warning site. Pre-#385, `JsmCreateArgs` does not carry `issue_type`. The implementer MUST thread it in — by extending `JsmCreateArgs`, passing it as an additional parameter, or an equivalent mechanism. The BC constrains WHEN the warning fires (step 5), not HOW the value is threaded. See prd-delta-385.md §O-08-07 Implementation Note for the full threading discussion covering all six flags.

> **[UPDATED 2026-05-20 issue #385 adversary pass-12 F-02]** Single-site requirement: the existing pre-dispatch warning emission block in `handle_create` (which currently fires these warnings before `handle_jsm_create` is called) MUST be REMOVED as part of implementing O-08-07. The `--type` warning must exist at exactly ONE site — canonical step 5 inside `handle_jsm_create`. Double-emission from two code sites is a defect. The new `test_jsm_create_platform_flag_warnings_emit_once_on_success` (Required Test Deliverable item 7) pins this constraint. This is distinct from BC-3.8.011's idempotency contract (one warning per repeated logical flag) — that covers duplicate flag occurrences, not duplicate code sites.

---

#### BC-3.8.011: Platform-only flags ignored on JSM path emit stderr warnings

**Confidence**: HIGH
**Subject**: JSM request submission cross-flag interaction
**Behavior**: When `--request-type <NAME|ID>` is set on `jr issue create`, the following
platform-only flags are NOT supported by the JSM `/rest/servicedeskapi/request` endpoint
and are silently ignored if passed. For EACH such flag set, the handler MUST emit ONE
warning line to stderr (NOT stdout, NOT in --output json data), then continue with the
JSM dispatch normally. Flags covered:

- `--team <id>`: warning `"warning: --team is ignored when --request-type is set; teams are managed by the request type's workflow"`
- `--points <n>`: warning `"warning: --points is ignored when --request-type is set; story points are not part of JSM request schema"`
- `--parent <key>`: warning `"warning: --parent is ignored when --request-type is set; JSM requests cannot be sub-tasks"`
- `--to <accountId>`: warning `"warning: --to is ignored when --request-type is set; use --on-behalf-of to set the requester"`
- `--account-id <id>`: warning `"warning: --account-id is ignored when --request-type is set; use --on-behalf-of to set the requester"`

Generalizes the existing `--type` warning pattern from BC-3.8.010. Idempotent — passing
the same flag twice still emits ONE warning per logical flag. **Warning position (O-08-07):** all six warnings (the `--type` warning of BC-3.8.010 plus the five platform-only flag warnings of BC-3.8.011) are emitted INSIDE `handle_jsm_create` AFTER `require_service_desk` returns `Ok` — mirroring the BC-3.8.010 position constraint. On a non-JSM project, NONE of these warnings fire; only the non-JSM project error is emitted.

**Inputs**: any combination of `--team`, `--points`, `--parent`, `--to`, `--account-id`
with `--request-type`
**Outputs/Effects**: One stderr warning line per dropped flag; JSM dispatch continues
normally; exit 0 on success.
**Errors**: None — these are warnings, not errors. Dispatch proceeds.
**Related BCs**: BC-3.4.014 — on the JSM path, the `--team` flag is ignored (this contract applies instead); BC-3.4.014's team echo does NOT fire on the JSM path. BC-3.4.014 EC-3.4.014-4 records this exclusion reciprocally.
**Trace**: `tests/issue_create_jsm.rs` (per-flag warning-emission integration tests, one assertion per platform-only flag)
**Source**: Adversary pass-01 C-02 codification; mirrors BC-3.8.010 pattern
**Confidence**: HIGH

[NEW 2026-05-19 issue #288 pr4 adversary-pass-01 C-02] Added to codify the cross-flag
warning policy after adversary pass-01 found silent-drop of 5 platform-only flags on
the JSM dispatch path.

> **[UPDATED 2026-05-20 issue #385 O-08-07]** Warning position constraint applied: all six warnings (the `--type` warning of BC-3.8.010 plus the five platform-only flag warnings of BC-3.8.011) move inside `handle_jsm_create` AFTER `require_service_desk` succeeds — co-located so that on a non-JSM project, NONE of these warnings fire; only the non-JSM project error is emitted. All existing per-flag integration tests MUST remain green — warnings still fire on the JSM success path.

> **[UPDATED 2026-05-20 issue #385 adversary pass-8 H-03]** Threading note: achieving step-5 placement for the five platform-only flag warnings (`--team`, `--points`, `--parent`, `--to`, `--account-id`) requires those flag values to be in scope inside `handle_jsm_create` at the warning site. Pre-#385, `JsmCreateArgs` does not carry these fields. The implementer MUST thread them in — by extending `JsmCreateArgs`, passing them as additional parameters, or an equivalent mechanism. This BC constrains WHEN the warnings fire (step 5), not HOW the values are threaded. See prd-delta-385.md §O-08-07 Implementation Note for the full threading discussion.

> **[UPDATED 2026-05-20 issue #385 adversary pass-12 F-02]** Single-site requirement: the existing pre-dispatch warning emission block in `handle_create` (which currently fires these warnings before `handle_jsm_create` is called) MUST be REMOVED as part of implementing O-08-07. All five platform-only flag warnings must exist at exactly ONE site — canonical step 5 inside `handle_jsm_create`. Double-emission from two code sites is a defect. The new `test_jsm_create_platform_flag_warnings_emit_once_on_success` (Required Test Deliverable item 7) pins this. Note: this is distinct from the existing idempotency contract ("one warning per logical flag regardless of how many times that flag is repeated by the caller") — idempotency concerns duplicate flag occurrences, not duplicate code sites emitting warnings.

---

#### BC-3.8.012: `--field` on platform path emits stderr warning (idempotent per flag NAME)

**Confidence**: HIGH
**Subject**: Issue write (platform path cross-flag interaction)
**Behavior**: When `jr issue create` is invoked WITHOUT `--request-type` but WITH one or
more `--field NAME=VALUE` flags, the handler MUST emit ONE warning line to stderr
(NOT stdout, NOT in `--output json` data) BEFORE the platform POST is issued. The
warning fires ONCE per logical flag NAME — mirroring BC-3.8.011's idempotent semantic.
Passing `--field` multiple times (e.g., `--field A=1 --field A=2`, or
`--field A=1 --field B=2`) emits exactly one warning total; the warning is per-flag-NAME
(`--field`), not per-NAME-VALUE pair. The platform path then runs to completion as if
`--field` was not supplied. Exit code is unchanged (0 on success). Stdout output
(e.g., `{"key": "FOO-123"}`) is unchanged.

Verbatim warning string (emitted once, regardless of how many `--field` occurrences):
`"warning: --field is ignored on the platform create path; it only applies with --request-type (JSM service-desk requests). To pass custom fields to a JSM request type, also supply --request-type."`

Inverse symmetry to BC-3.8.008: `--field` is accepted and meaningful on the JSM path
(maps to `requestFieldValues`); on the platform path it has no effect and MUST warn.
The warning fires regardless of `--no-input` or `--output json` settings. If the command
early-exits before the POST (e.g., missing required field), the warning need not fire.

When `--field` is absent (clap default: empty Vec), NO warning is emitted — i.e., the
stderr stream from a plain platform-path invocation is byte-identical to pre-issue-#383
behavior.

Platform path does NOT parse `--field NAME=VALUE` strings (only detects presence of
the flag). A malformed `--field` (e.g., `--field bare-name-no-equals`) on the platform
path still triggers the one warning and is then discarded; no exit-64 error fires.
Format validation per BC-3.8.008 applies only on the JSM path.

Cross-reference: BC-3.8.012 and BC-3.8.013 fire independently when both `--field` and
`--on-behalf-of` are present without `--request-type`; both warnings appear on stderr
(each collapsed per its own idempotency rule).

**Inputs**: `--field NAME=VALUE` (one or more) WITHOUT `--request-type`
**Outputs/Effects**: ONE stderr warning line (regardless of how many `--field` flags);
platform POST proceeds normally with the `--field` values discarded; stdout and exit
code unchanged.
**Errors**: None — this is a warning path, not an error path.
**Trace**: `tests/issue_create_jsm.rs` (integration tests covering platform-path inverse-warning
for `--field`). Test placement: current Trace cites the existing JSM test file; F3
story-writer may choose to (a) keep tests in `issue_create_jsm.rs` (extending the file's
scope) or (b) split into a new test file for cleaner perimeter. That decision is deferred
to F3.
**Source**: Issue #383 F1 delta analysis; structurally mirrors BC-3.8.010 (Inputs/Outputs
sub-fields), semantically mirrors BC-3.8.011 (warn-and-continue pattern, idempotent per
logical flag NAME); inverse symmetry to BC-3.8.008 / BC-3.8.009. Note: wording expanded
from F1 proposal (`"warning: --field is ignored without --request-type; use --request-type
to submit a JSM request with custom fields"`) to clarify the "platform create path" vs JSM
dispatch distinction explicitly, per F2 review.
**Confidence**: HIGH

[NEW 2026-05-19 issue #383 F2] Added to close the platform-path inverse-warning symmetry
gap identified in F1 delta analysis: `--field` is silently dropped on platform path with
no user feedback.

---

#### BC-3.8.013: `--on-behalf-of` on platform path emits stderr warning

**Confidence**: HIGH
**Subject**: Issue write (platform path cross-flag interaction)
**Behavior**: When `jr issue create` is invoked WITHOUT `--request-type` but WITH
`--on-behalf-of <ACCOUNT_ID>`, the handler MUST emit ONE warning line to stderr
(NOT stdout, NOT in `--output json` data) BEFORE the platform POST is issued. The
platform path then runs to completion as if `--on-behalf-of` was not supplied. Exit
code is unchanged (0 on success). Stdout output (e.g., `{"key": "FOO-123"}`) is
unchanged. Because `--on-behalf-of` is `Option<String>` and can only appear once on
the command line, idempotency does not alter the observable behavior — one occurrence
emits one warning, matching BC-3.8.011's per-logical-flag-NAME rule.

Verbatim warning string:
`"warning: --on-behalf-of is ignored on the platform create path; it only applies with --request-type (JSM service-desk requests). To raise a request on behalf of another user, also supply --request-type."`

Inverse symmetry to BC-3.8.009: `--on-behalf-of` is accepted and meaningful on the
JSM path (maps to `raiseOnBehalfOf`); on the platform path it has no effect and MUST
warn. The warning fires regardless of `--no-input` or `--output json` settings. If the
command early-exits before the POST (e.g., missing required field), the warning need
not fire.

When `--on-behalf-of` is absent (clap default: None), NO warning is emitted — i.e.,
the stderr stream from a plain platform-path invocation is byte-identical to
pre-issue-#383 behavior.

Cross-reference: BC-3.8.012 and BC-3.8.013 fire independently when both `--field` and
`--on-behalf-of` are present without `--request-type`; both warnings appear on stderr
(each collapsed per its own idempotency rule).

**Inputs**: `--on-behalf-of <ACCOUNT_ID>` WITHOUT `--request-type`
**Outputs/Effects**: ONE stderr warning line; platform POST proceeds normally with
`--on-behalf-of` discarded; stdout and exit code unchanged.
**Errors**: None — this is a warning path, not an error path.
**Trace**: `tests/issue_create_jsm.rs` (integration tests covering platform-path inverse-warning
for `--on-behalf-of`). Test placement: current Trace cites the existing JSM test file;
F3 story-writer may choose to (a) keep tests in `issue_create_jsm.rs` (extending the
file's scope) or (b) split into a new test file for cleaner perimeter. That decision is
deferred to F3.
**Source**: Issue #383 F1 delta analysis; structurally mirrors BC-3.8.010 (Inputs/Outputs
sub-fields), semantically mirrors BC-3.8.011 (warn-and-continue pattern, idempotent per
logical flag NAME); inverse symmetry to BC-3.8.008 / BC-3.8.009. Note: wording expanded
from F1 proposal (`"warning: --on-behalf-of is ignored without --request-type; use
--request-type to submit a JSM request on behalf of another user"`) to clarify the
"platform create path" vs JSM dispatch distinction explicitly, per F2 review.
**Confidence**: HIGH

[NEW 2026-05-19 issue #383 F2] Added to close the platform-path inverse-warning symmetry
gap identified in F1 delta analysis: `--on-behalf-of` is silently dropped on platform
path with no user feedback.

---

#### BC-3.8.014: Basic-auth 401 on JSM POST (`handle_jsm_create`) → API-token-expiry hint; no OAuth-scope language

**Confidence**: HIGH
**Subject**: Issue write (JSM path — auth-conditional error hint)
**Behavior**: When `POST /rest/servicedeskapi/request` returns 401 AND the active auth scheme is Basic (i.e., `JiraClient::is_oauth_auth()` returns `false`), the `handle_jsm_create` `map_err` MUST surface an API-token-expiry hint and exit 2. The gate is `is_oauth_auth() == false` ALONE — the incoming error variant is irrelevant.

Implementation: the `map_err` must inspect `client.is_oauth_auth()`. If `false`, REWRITE any incoming error (whether `JrError::NotAuthenticated` or `JrError::InsufficientScope`) to `JrError::NotAuthenticated { hint: <API_TOKEN_HINT> }`. This rewrite is mandatory: a Basic-auth 401 whose response body contains "scope does not match" would otherwise propagate as `InsufficientScope` (per `src/api/client.rs:696-704`), causing the user to see OAuth scope language that is actionably wrong for Basic-auth users. The rewrite suppresses that path.

The `hint` field value (stored in `JrError::NotAuthenticated { hint }`) MUST be the shared constant `API_TOKEN_EXPIRY_HINT` (defined once in **`src/error.rs`** — NOT in `src/api/client.rs` or any new module — referenced identically by the `handle_jsm_create` site and the `require_service_desk` site — see BC-X.8.006). `src/error.rs` is imported by both the `api` and `cli` layers with no layering inversion, and it keeps "no new modules / no architecture delta" true. This shared constant prevents hint-text divergence between the two call sites.

The rendered stderr line prepends `"Not authenticated. "` (from `src/error.rs:5`); the `hint` field contains only the body text after that prefix. Tests MUST assert via `contains`, not `==`, to tolerate the rendered prefix. The hint field value is:

<!-- This block is duplicated from the CANONICAL copy in prd-delta-384.md §BC-3.8.014 — all copies MUST be updated together; cf. the JR_* doc-fallout pattern in CLAUDE.md (adversary-pass-4 F-04). -->
```
Your API token may be expired or revoked. Regenerate it at
https://id.atlassian.com/manage-profile/security/api-tokens
then run `jr auth login` to re-store the credentials.
```

The hint MUST NOT contain any OAuth-scope language (e.g., `write:servicedesk-request`, `OAuth`, `scope`). Basic-auth users have API tokens with implicit permissions, not OAuth granular scopes; surfacing a scope hint is misleading and actionably wrong. The hint MUST NOT say `jr auth refresh` (meaningless for Basic auth — no OAuth refresh token).

Gate: `client.is_oauth_auth() == false` — predicate is `self.auth_header.starts_with("Bearer ")`. **Value-space precision**: `JiraClient::load_auth_from_keychain` produces exactly `"Bearer {access_token}"` for OAuth or `"Basic {base64_encoded}"` for Basic/API-token. The `JR_AUTH_HEADER` debug-only test seam (CLAUDE.md SD-002, `#[cfg(debug_assertions)]`) can inject either form in tests. `auth_header` is never empty at call time — the constructor errors via `?` if the keychain yields nothing. `is_oauth_auth()` is `self.auth_header.starts_with("Bearer ")` — the SAME discriminant the production code already trusts at `src/api/client.rs:718` and `:802`. No other predicate or ad-hoc string check should be introduced. This is 100% reliable for the value-space produced by `load_auth_from_keychain`.

**Inputs**: Active auth = Basic; JSM POST returns HTTP 401 (any body shape — including generic expiry and "scope does not match" bodies)
**Outputs/Effects**: exit 2; stderr contains the API-token-expiry hint (assert via `contains`); stdout empty; any `InsufficientScope` from the 401 is rewritten to `NotAuthenticated` before surfacing.
**Errors**: None beyond the 401 itself — this BC IS the error-handling contract.
**Trace**: `tests/issue_create_jsm.rs` (integration tests for the HTTP-401 Basic-auth path): (a) `test_jsm_create_basic_auth_scope_mismatch_401_rewrites_to_api_token_hint` (NEW) — pins the `InsufficientScope`→`NotAuthenticated` rewrite path with a "scope does not match" body fixture; (b) `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` (REPURPOSED in place by F4 — fixture stays Basic `JR_AUTH_HEADER=Basic dGVzdDp0ZXN0`, generic-expiry 401 body; assertions flipped from `write:servicedesk-request` to API-token-expiry hint; negative assertion that `write:servicedesk-request` is ABSENT; per adversary-pass-9 C-01 correction — this test is a BC-3.8.014 pin, NOT a BC-3.8.015 pin). The Basic-auth generic-expiry path is pinned by test (b); test (a) covers the scope-mismatch rewrite path. Both AC-3 and AC-5 describe the same observable behavior (API-token-expiry hint for Basic-auth 401) and share test (b) as the generic-expiry pin.
**Source**: Issue #384 F2 corrected model; O-08-01 CONFIRMED in `.factory/research/issue-288-pr4-deferred-validation.md`; `src/api/client.rs:696-704` (scope-mismatch body check fires before Bearer guard at line 718 — body content, not auth scheme, decides variant before map_err); CLAUDE.md gotcha "Atlassian's expired-access-token 401 response shape".
**Confidence**: HIGH

[NEW 2026-05-19 issue #384 F2] Closes O-08-01: Basic-auth API-token-expiry 401 was incorrectly surfacing the OAuth `write:servicedesk-request` scope hint. The gate is `is_oauth_auth() == false` alone; the map_err must REWRITE any incoming 401-derived error variant to `NotAuthenticated` with the API-token hint, because a Basic-auth 401 with a "scope does not match" body arrives as `InsufficientScope` (body check at client.rs:696 fires before Bearer guard at line 718).

[REVISED 2026-05-19 issue #384 F2 adversary correction] Previous version incorrectly stated "Basic-auth 401s land in `JrError::NotAuthenticated`, not `InsufficientScope`." This is FALSE. The 401 handler in `src/api/client.rs` checks the response BODY for "scope does not match" at line 696 BEFORE checking the `Bearer` guard at line 718. So a Basic-auth 401 with a scope-mismatch-flavored body lands in `InsufficientScope`. The corrected model: gate is `is_oauth_auth() == false` alone; `map_err` must rewrite both `NotAuthenticated` and `InsufficientScope` arms to the API-token hint.

---

#### BC-3.8.015: OAuth 401 on JSM POST (`handle_jsm_create`) → `write:servicedesk-request` hint via `InsufficientScope` scope-mismatch path (deterministic); `NotAuthenticated` post-refresh path is pre-existing, out of #384 test scope

**Confidence**: HIGH
**Subject**: Issue write (JSM path — auth-conditional error hint)
**Behavior**: When `POST /rest/servicedeskapi/request` returns 401 AND the active auth scheme is OAuth/Bearer (i.e., `JiraClient::is_oauth_auth()` returns `true`), the observable behavior depends on the 401 response body:

- **`JrError::InsufficientScope` (body contains "scope does not match" — client.rs:696-704 short-circuit, DETERMINISTIC):** The scope-mismatch body check at `src/api/client.rs:696-704` fires BEFORE the Bearer guard at `src/api/client.rs:718` AND before the refresh coordinator. This means for a Bearer client, a scope-mismatch 401 short-circuits directly to `InsufficientScope` and lands in `handle_jsm_create`'s `map_err` as a genuine `JrError`. The `map_err` on the `is_oauth_auth() == true` branch preserves `InsufficientScope` and its hint names `write:servicedesk-request` + `required_scope: Some("write:servicedesk-request")`; exit 2. **This is the ONLY deterministically testable OAuth→`JrError`→`write:servicedesk-request` path via the `JR_AUTH_HEADER` test seam.** The EXISTING test `async fn test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` (under the `// ─── C-01: OAuth InsufficientScope 401 surfaces write:servicedesk-request ────` section banner in `tests/issue_create_jsm.rs`) is the BC-3.8.015 regression pin. It uses `JR_AUTH_HEADER=Bearer test-oauth-token` + body `{"errorMessages": ["Unauthorized; scope does not match"]}` and asserts `write:servicedesk-request`, `jr auth refresh`, `jr auth login`. This test is GREEN on `develop` UNMODIFIED — it is the BC-3.8.015 pin. It MUST remain green unmodified.

- **`JrError::NotAuthenticated` (non-scope-mismatch Bearer 401, post-refresh path — NOT deterministically testable via `JR_AUTH_HEADER` seam):** A Bearer client with a generic-expiry 401 body (no "scope does not match") does NOT short-circuit at client.rs:696-704. Instead, it enters the auto-refresh coordinator at line 727+. In any test using the `JR_AUTH_HEADER=Bearer ...` seam (no keychain OAuth tokens, no `JR_OAUTH_TOKEN_URL` mock), the refresh call deterministically fails with a raw `anyhow::bail!` error from `refresh_oauth_token_with_url` — NOT a `JrError`. That raw anyhow error propagates to `handle_jsm_create`'s `map_err`, where `e.downcast::<JrError>()` hits the `Err(other) => other` arm — no `JrError` branch fires, and the `write:servicedesk-request` hint is NEVER injected. **Consequence:** BC-3.8.015 must NOT claim a Bearer + generic-expiry 401 surfaces `write:servicedesk-request`. The pre-existing `NotAuthenticated` arm rewrite at `src/cli/issue/jsm_create.rs::handle_jsm_create` §"NotAuthenticated arm" injects `write:servicedesk-request` for OAuth only after a SUCCESSFUL token refresh followed by a 401 retry — this path is real and pre-existing but is NOT reliably reachable via the `JR_AUTH_HEADER` test seam. It is pre-existing behavior, unchanged by #384, and is out of #384's deterministic-test scope. No test for this path is mandated by this delta.

The gate is `is_oauth_auth() == true` ALONE for the `map_err` branch decision. This BC documents what was previously implicit and makes it explicitly gated by the `is_oauth_auth()` check.

Gate: `client.is_oauth_auth() == true` (predicate returns true when `Authorization` header starts with `Bearer `).

**Test instruction (adversary-pass-9 C-01 corrected design):**

`test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` is the BC-3.8.015 regression pin. It is already green on `develop` and MUST remain green unmodified. F4 must NOT alter this test. Confirmed by reading `async fn test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` in `tests/issue_create_jsm.rs`: Bearer fixture (`JR_AUTH_HEADER=Bearer test-oauth-token`), scope-mismatch body (`{"errorMessages": ["Unauthorized; scope does not match"]}`), asserts `write:servicedesk-request` + `jr auth refresh` + `jr auth login`. Uses `mount_project_meta_help`, `mount_service_desk_list`, `mount_request_types_password_reset` helpers, project `HELP`, `--request-type "Password Reset"`, `--summary "Reset my password"`.

H-NEW-JSM-RT-003 is re-bound to `test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` — see the Revised Holdout Scenarios section in `prd-delta-384.md`.

`test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` (repurposed in place by F4; `JR_AUTH_HEADER=Basic dGVzdDp0ZXN0`, generic 401 body; assertions assert API-token-expiry hint and assert `write:servicedesk-request` is ABSENT) is the **BC-3.8.014 pin** — NOT a BC-3.8.015 pin. Basic + generic-401 produces the API-token-expiry hint.

**Inputs**: Active auth = Bearer/OAuth; JSM POST returns HTTP 401 with scope-mismatch body (`{"errorMessages": ["Unauthorized; scope does not match"]}`)
**Outputs/Effects**: exit 2; stderr contains `write:servicedesk-request`; stdout empty.
**Errors**: None beyond the 401 itself — this BC IS the error-handling contract.
**Trace**: `tests/issue_create_jsm.rs` — `async fn test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` (under the `// ─── C-01: OAuth InsufficientScope 401 surfaces write:servicedesk-request ────` section banner; existing test, green on `develop`; logic/fixture/assertions MUST remain unmodified; F4 SHOULD add `// H-NEW-JSM-RT-003 + BC-3.8.015 anchor` to its rustdoc comment — comment-only, no behavior impact; this IS the BC-3.8.015 pin and IS H-NEW-JSM-RT-003 per re-bind in adversary-pass-9 C-01).
**Source**: Issue #384 F2 adversary-pass-9 C-01 corrected design; BC-1.3.023; H-NEW-JSM-RT-003; `src/api/client.rs:696-704` (scope-mismatch short-circuit fires BEFORE refresh coordinator — the ONLY deterministic Bearer→`JrError` path); `src/api/client.rs:718` (Bearer guard — NOT reached for scope-mismatch bodies); `src/api/client.rs:727+` (refresh coordinator — entered by generic-expiry Bearer 401; deterministically fails with raw anyhow error via `JR_AUTH_HEADER` seam, not a `JrError`).
**Confidence**: HIGH

[NEW 2026-05-19 issue #384 F2] Formally pins the OAuth path as the surviving branch after the Basic/OAuth split. Pre-#384, both Basic and OAuth 401s shared the same hint logic; post-#384, the Basic-auth arm is intercepted by BC-3.8.014 before it reaches the OAuth behavior.

[REVISED 2026-05-19 issue #384 F2 adversary-pass-2 C-02/H-05/H-06] (C-02) Renderer prefix corrected: `"Insufficient token scope: "` (colon) not `"Insufficient token scope. "` (period) — per `src/error.rs:8-16`. (H-05/H-06) Corrected false claim about pre-#384 map_err behavior; both arms produce `write:servicedesk-request` for OAuth — exactly as pre-#384.

[REVISED 2026-05-19 issue #384 adversary-pass-5 F-01/F-02/F-03] (F-01) Clarified H-NEW-JSM-RT-003 artifact identity. (F-02) Added explicit warning about mandatory Bearer fixture migration. (F-03) Confirmed test function by reading its body; symbol-relative anchor used.

[REVISED 2026-05-19 issue #384 adversary-pass-8 F-02] Replaced hardcoded line citations with symbol-relative anchors per CLAUDE.md anti-drift convention.

[REVISED 2026-05-19 issue #384 adversary-pass-9 C-01 CRITICAL design correction] Complete rewrite of testable contract. The F2 passes 1-8 plan ("migrate the pre-#384 Basic-auth 401 test to Bearer + generic-expiry body") was unworkable: a Bearer + generic-expiry 401 routes through the refresh coordinator (client.rs:727+), which deterministically fails with a raw anyhow error (not a `JrError`) via the `JR_AUTH_HEADER` seam, so the `write:servicedesk-request` hint is never injected. The ONLY deterministic Bearer→`JrError`→`write:servicedesk-request` path is the scope-mismatch short-circuit (client.rs:696-704). BC-3.8.015 is now re-specified to its true testable contract: the scope-mismatch path, pinned by the EXISTING `async fn test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` (already green on `develop`, unmodified). H-NEW-JSM-RT-003 re-bound to this test. `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` stays Basic and becomes a BC-3.8.014 pin with flipped assertions. BC-X.8.007 Setup corrected to scope-mismatch body.

---

#### Canonical Guard Ordering — `handle_jsm_create`

**SINGLE SOURCE OF TRUTH** for the complete guard/HTTP ordering in `handle_jsm_create`. BC-3.8.016 (step 1) and BC-3.8.017 (step 2) reference this block rather than embedding copies. `prd-delta-385.md §Canonical Guard Ordering` is a pointer to this block. When changing any step, update ONLY this block.

The following is the complete, implementer-authoritative ordering of input guards, warnings, and HTTP calls in `handle_jsm_create`. Every BC and holdout in this delta is specified against this ordering:

0. Project-key resolution (BC-3.8.002; `src/cli/issue/jsm_create.rs::handle_jsm_create` §"project-key resolution") — may exit 64 when no project is resolvable AND `no_input` is effective (set explicitly via `--no-input` or auto-enabled on non-TTY stdin) OR `prompt_input` errors. NO HTTP. (O-08-02/BC-3.8.002 harmonizes the error string emitted by this block; see BC-3.8.002)
1. **BC-3.8.016** — Empty/whitespace-only `--request-type` guard — exit 64, NO HTTP. Guard evaluates `request_type_arg.trim().is_empty()`; the inline numeric-bypass check and `partial_match` (both inside step 6) occur much later.
2. **BC-3.8.017** — `--markdown` + `--field description=<value>` conflict guard — exit 64, NO HTTP. Fires when any raw `--field` token's key (substring before first `=`, NO trim, NO case-fold) is exactly `"description"` — case-SENSITIVE exact match mirroring `parse_field_kv`.
3. Existing `--markdown`-requires-`--description` guard — exit 64, NO HTTP.
4. `require_service_desk` — FIRST HTTP call in `handle_jsm_create`.
5. BC-3.8.010/BC-3.8.011 platform-only flag warnings — all six warnings (the `--type` warning of BC-3.8.010 plus the five platform-only flag warnings of BC-3.8.011) fire only AFTER `require_service_desk` returns `Ok`. The existing pre-dispatch warning block in `handle_create` MUST be removed — warnings exist at exactly ONE site (this step).
6. Numeric-bypass check → `resolve_jsm_request_type_id` (non-numeric input) → summary resolution, then description resolution (both in `handle_jsm_create`, after request-type resolution) → `parse_field_kv` → POST.

Guards 1 and 2 fire after project-key resolution (step 0) and before `require_service_desk` (step 4) — zero HTTP when either fires.

---

#### BC-3.8.016: `--request-type ""` or whitespace-only value exits 64 before `require_service_desk` with explicit message

**Confidence**: HIGH
**Subject**: Issue write (JSM path — input guard)
**Behavior**: When `--request-type` is set to the empty string or a whitespace-only string (i.e., the user passes `--request-type ""` or `--request-type "   "`), `handle_jsm_create` MUST detect the empty-or-whitespace-only input AFTER project-key resolution (step 0) but BEFORE `require_service_desk` (step 4). Guard ordering: see the Canonical Guard Ordering for subdomain 3.8 above (this guard is step 1).

Exit code: 64. Stderr contains: `"request type cannot be empty"` (**CANONICAL SOURCE — all duplicate occurrences in prd-delta-385.md, holdout-scenarios.md, and spec-changelog.md MUST be updated together with this copy; cf. JR_* doc-fallout pattern in CLAUDE.md**) (assert via `contains`). No HTTP calls are issued. The guard evaluates `request_type_arg.trim().is_empty()` — it rejects empty-or-whitespace-only values. The un-trimmed value is passed downstream UNCHANGED if the guard does NOT fire; this BC does NOT normalize or trim the value for downstream use. Consequently, non-empty whitespace-padded values (e.g. `--request-type " 5 "`) are OUT OF SCOPE for this BC and are EXPLICITLY DEFERRED out of #385 scope — they pass this guard and the un-trimmed value proceeds to step 6, where `" 5 "` fails the numeric-bypass check (not all-digits) and falls into `partial_match`. The current outcome is a potentially confusing "request type not found" error (because `" 5 "` is unlikely to substring-match any request type name), not a clean exit. This is a KNOWN RESIDUAL edge case — deferred, not benign.
**Inputs**: `--request-type ""` or `--request-type "   "` (empty or whitespace-only after trim); whitespace-padded non-empty values are out of scope for this BC.
**Outputs/Effects**: exit 64; stderr contains "request type cannot be empty" (substring match via `contains` — duplicated from the CANONICAL copy above; update together); stdout empty; no HTTP.
**Errors**: This BC IS the error contract. No downstream resolution attempted.
**Trace**: `tests/issue_create_jsm.rs::test_jsm_create_empty_request_type_exits_64` (integration test — H-NEW-JSM-RT-006 realized_by binding); `src/cli/issue/jsm_create.rs::handle_jsm_create` (guard after project-key resolution (step 0), before `require_service_desk`)
**Source**: O-08-04 CONFIRMED in `.factory/research/issue-288-pr4-deferred-validation.md`. Without this guard, `--request-type ""` falls through to `resolve_jsm_request_type_id` → `partial_match("", &names)` → returns `Ambiguous` for any NON-EMPTY candidate list (and `None` for an empty one) — either outcome produces a misleading message. See `src/partial_match.rs::partial_match` (substring-match branch): `"<anything>".contains("")` is `true` for all candidates, so every name in a non-empty list matches the empty string.
**Confidence**: HIGH

[NEW 2026-05-20 issue #385 F2] Closes O-08-04: empty `--request-type` guard. Guard fires at top of `handle_jsm_create` before `require_service_desk` — no HTTP can be issued.

[UPDATED 2026-05-20 issue #385 adversary pass-1 F-01/F-03/F-08] Placement strengthened from "before `resolve_jsm_request_type_id`" to "at the VERY TOP of `handle_jsm_create`, before `require_service_desk`" — ensuring zero HTTP on this path. Canonical guard ordering list added. Assertion mode made explicit: stderr asserted via `contains` of substring "request type cannot be empty".

[UPDATED 2026-05-20 issue #385 adversary pass-2 F-01] Scope clarified: guard tests `trim().is_empty()` only; it does NOT normalize the value for downstream use. Non-empty whitespace-padded values (e.g. `" 5 "`) are OUT OF SCOPE — they pass the guard and follow existing pre-#385 resolution behavior.

[UPDATED 2026-05-20 issue #385 adversary pass-3 H-01/H-05] Wording corrected: guard fires at step 1, before `require_service_desk` (step 4); numeric-bypass check and `partial_match` occur at step 6, not near the handler top — removed any phrasing implying otherwise. CANONICAL SOURCE designation added to the "request type cannot be empty" message string.

---

#### BC-3.8.017: `--markdown` + `--field description=<value>` combination rejected at the top of `handle_jsm_create`; exit 64

**Confidence**: HIGH
**Subject**: Issue write (JSM path — input guard)
**Behavior**: When `handle_jsm_create` detects both (a) `--markdown` is set AND (b) the raw `--field` arg list contains an entry whose key (first `=`-delimited token) is `"description"`, the handler MUST reject the combination AFTER project-key resolution (step 0) but BEFORE `require_service_desk`. Guard ordering: see the Canonical Guard Ordering for subdomain 3.8 above (this guard is step 2).

Guard 2 (this BC) uses a RAW first-`=`-split on each `--field` token — full `parse_field_kv` is not required for the conflict check. The key check is: any `--field` token where the raw substring before the first `=` (NO trimming, NO case-folding) is EXACTLY `"description"` — case-SENSITIVE, no-trim match, identical to how `parse_field_kv` extracts the key. This check is performed BEFORE `require_service_desk` so that NO HTTP is issued when the conflict is present. The guard fires if and only if the raw key equals `"description"` exactly — so `--field Description=X` (key `Description`) and `--field " description"=X` (key `" description"`) do NOT trigger the guard and are not a desync (HashMap key `Description` does not overwrite `requestFieldValues["description"]`).

The guard fires whenever `--markdown` is set AND a `--field description=…` is present — regardless of whether `--description` is also present. (The guard sits at step 2 above, BEFORE the existing `--markdown`-requires-`--description` guard at step 3. So `--markdown --field description=X` with NO `--description` flag correctly triggers THIS guard's conflict message, not the "requires --description" message.)

Exit code: 64. Stderr message (verbatim — **CANONICAL SOURCE; all duplicate occurrences in prd-delta-385.md, holdout-scenarios.md, and spec-changelog.md MUST be updated together with this copy; cf. JR_* doc-fallout pattern in CLAUDE.md**):
"`--field description=...` cannot be combined with `--markdown`: it would overwrite the ADF description with plain text, desyncing `isAdfRequest: true` with a plain-string description value (may result in a JSM 400 error or silently dropped ADF formatting). Pass `--description` with `--markdown`, or omit `--markdown`."
No HTTP calls are issued on this path.

When `--markdown` is absent, the guard does NOT fire — `--field description=value` without `--markdown` is permitted (it populates `requestFieldValues["description"]` as a plain string with `isAdfRequest: false` or omitted, which is coherent). When no `--field` token has a raw key exactly equal to `"description"`, the guard does NOT fire — `--markdown` alone (with `--description` or `--description-stdin`) is the normal ADF path. The guard does not inspect the description source (`--description` vs `--description-stdin`): if `--markdown` is set and a `--field` token has the raw key exactly `"description"`, the guard fires regardless of which description-source flag was used (EC-3.8.017-4). `--field Description=X` (capital D) + `--markdown` does NOT trigger the guard — raw key `Description` does not equal `"description"`; no desync occurs because HashMap key `Description` does not overwrite `requestFieldValues["description"]` (EC-3.8.017-3). A `--field` token with NO `=` character at all (e.g. `--field description`) does NOT trigger this guard — the raw first-`=`-split check requires a `=`-present form to extract a key; a no-`=` token has no extractable key and therefore never satisfies the conflict condition (EC-3.8.017-5). The downstream outcome depends on other flags: if a description source (`--description` or `--description-stdin`) is also present (e.g. `--markdown --description "X" --field description`), step 3 is satisfied and the no-`=` token reaches `parse_field_kv` at step 6, which surfaces the existing malformed-pair error; if NO description source is present alongside `--markdown`, the step-3 `--markdown`-requires-`--description` guard fires first. In both cases, BC-3.8.017's step-2 guard does not fire.

**Rationale**: `JsmRequestBuilder::build()` populates `requestFieldValues["description"]` with the ADF object during description handling and computes `is_adf_request = true`; it then iterates `extra_fields`, and an `extra_fields` entry keyed exactly `"description"` overwrites the ADF value with a plain string; `isAdfRequest: true` is still emitted in the final body — producing the desync. This desync may produce a JSM 400 error OR silently drop ADF formatting — the exact Atlassian behavior is not documented and must not be asserted. Parse-time rejection is the correct fix.
**Inputs**: `--markdown` flag set AND `--field <key>=<any value>` where the raw `<key>` (substring before first `=`, NO trimming, NO case-folding) is exactly `"description"` — case-SENSITIVE, no-trim match. `--field Description=X` (key `Description`) does NOT trigger this guard.
**Outputs/Effects**: exit 64; stderr contains the conflict message (assert via `contains`); stdout empty; no HTTP.
**Errors**: This BC IS the error contract. The rejection happens at the top of `handle_jsm_create` before `require_service_desk`.
**Trace**: `tests/issue_create_jsm.rs::test_jsm_create_markdown_field_description_conflict_exits_64` (integration test — H-NEW-JSM-RT-007 realized_by binding); `src/cli/issue/jsm_create.rs::handle_jsm_create` (guard after project-key resolution (step 0), before `require_service_desk`)
**Source**: O-08-06 PARTIAL in `.factory/research/issue-288-pr4-deferred-validation.md`. The "may produce a JSM 400 OR silently drop ADF" phrasing is intentional per CLAUDE.md citation discipline — this spec MUST NOT assert "Atlassian returns 400" because the exact server behavior is undocumented. The guard rationale is the desync, not a confirmed 400.
**Confidence**: HIGH

[NEW 2026-05-20 issue #385 F2] Closes O-08-06: `--markdown` + `--field description=` conflict guard. Guard is in `handle_jsm_create` (not in `JsmRequestBuilder::build()`), preserving `JsmRequestBuilder` as a pure builder with no validation responsibility. Conflict guard in `build()` would require extending `tests/jsm_request_api.rs` proptest suite — caller-side placement keeps that suite unchanged.

[UPDATED 2026-05-20 issue #385 adversary pass-1 F-01/F-03/F-04] Placement strengthened: guard sits at the VERY TOP of `handle_jsm_create` before `require_service_desk` (no HTTP). Guard ordering listed explicitly. Guard fires whenever `--markdown` + `--field description=…` is present regardless of whether `--description` is also set (guard precedes the `--markdown`-requires-`--description` guard). Raw first-`=`-split is sufficient — full `parse_field_kv` not required for the conflict check. EC-3.8.017-1 updated accordingly.

[UPDATED 2026-05-20 issue #385 adversary pass-3 H-02/H-03] Key matching changed from case-SENSITIVE literal `"description"` to case-INSENSITIVE (`key.trim().to_ascii_lowercase() == "description"`). Removed the uncited claim that JSM field names are case-sensitive. EC-3.8.017-3 updated: `--field Description=X` now DOES trigger the guard. EC-3.8.017-4 added: `--markdown --description-stdin --field description=X` → guard fires; guard does not inspect `--description`/`--description-stdin` source.

[UPDATED 2026-05-20 issue #385 adversary pass-5 M-03] EC-3.8.017-5 added: a `--field` token with NO `=` character does NOT trigger this guard — no extractable key means the conflict condition is never satisfied. Non-triggering-cases paragraph updated to reference EC-3.8.017-5 and describe two possible downstream outcomes (step-6 malformed-pair error when a description source is present; step-3 markdown-requires-description guard when no description source is present).

[UPDATED 2026-05-20 issue #385 adversary pass-11 H-1] Key matching REVERSED from case-INSENSITIVE (pass-3 H-02) to case-SENSITIVE, no-trim — the guard MUST mirror `parse_field_kv`'s raw key extraction (`pair[..eq_pos]`, no `.trim()`, no case-folding) and HashMap exact-overwrite semantics. The desync (`extra_fields["description"]` overwrites `requestFieldValues["description"]`) occurs ONLY when the raw key is exactly `"description"`. `--field Description=X` produces HashMap key `Description`, which does NOT overwrite `requestFieldValues["description"]` — no desync, guard does NOT fire. The pass-3 H-02 case-insensitive framing was based on the incorrect premise that a differently-cased key could produce the desync. EC-3.8.017-3 updated: `--field Description=X` does NOT trigger the guard. Inputs field, non-triggering-cases paragraph, and all guard-match descriptions updated to remove "case-insensitive"/"trim" wording.

---

## JSON Output Shape Contracts (all confirmed by insta snapshots)

| Operation | JSON shape | Key field note |
|-----------|-----------|---------------|
| `move` (changed) | `{"changed": true, "key": "TEST-1", "status": "In Progress"}` | 3 keys alphabetical |
| `move` (unchanged) | `{"changed": false, "key": "TEST-1", "status": "Done"}` | idempotent form |
| `assign` (changed) | `{"assignee": "Jane Doe", "assignee_account_id": "abc123", "changed": true, "key": "TEST-1"}` | `assignee_account_id` snake_case |
| `assign` (unchanged) | identical with `changed: false` | |
| `unassign` | `{"assignee": null, "changed": true, "key": "TEST-1"}` | `assignee` is EXPLICIT null |
| `edit` | `{"changed_fields": {...}, "key": "TEST-1", "updated": true}` | 3 keys; `changed_fields` is a BTreeMap-ordered object |
| `link` | `{"key1": "TEST-1", "key2": "TEST-2", "linked": true, "type": "Blocks"}` | symmetric key1/key2 |
| `unlink` | `{"count": 2, "unlinked": true}` | `count: 0` when no match |
| `remote-link` | `{"id": 10000, "key": "TEST-1", "self": <url>, "title": <title>, "url": <url>}` | 5 keys |
| `create` | `{"key": "FOO-123"}` | minimal |

Sources: `src/cli/issue/snapshots/jr__cli__issue__json_output__tests__*.snap`; BC-1104..BC-1112 (R4)

## Total BCs in this file: 91 individually-bodied (cumulative 120 incl. range-collapsed; see BC-INDEX.md)

_Last updated 2026-07-09 (issue #577 SOH-COMMENT-CRUD-1 F2, DEC-168): +11 BCs (BC-3.5.002..BC-3.5.012) — comment delete (BC-3.5.002..BC-3.5.004: endpoint/exit-codes, confirmation, 404-exit-64+body-surface), comment edit (BC-3.5.005..BC-3.5.009: body-only-PUT invariant, --internal wire, --public wire+always-confirm, --public confirmation gate, body sources), comment view (BC-3.5.010: GET+expand=properties, table+JSON, 404-exit-64), mutual exclusion (BC-3.5.011), CLI breaking change (BC-3.5.012: comment→subcommand group, old flat form → clap error with migration hint); §3.5 header updated to 12 contracts. Previous update 2026-06-30 (BC-subclause-pass F2): +2 BCs (BC-3.4.020..021) — BC-3.4.020 (`issue edit --label` routing fork: single-key PUT bare-string vs 2+ key bulk POST `{"name":...}` objects; BUG-LABEL-400), BC-3.4.021 (`issue edit --dry-run` `plannedChanges` output structure + `--output json` schema `{dryRun, issues, plannedChanges}`; intentionally simplified preview shapes); Section 3.4 header updated to 21 contracts. Previous update 2026-06-08 (fix-bulk-transition-schema F2): +1 BC (BC-3.2.014) — BC-3.2.014 (multi-key bulk move `bulkTransitionInputs` nested wrapper wire schema; documents correctness bug fix commit acca854; live run 27156639337); Section 3.2 header updated to 14 contracts. Previous update 2026-06-03 (jsm-resolution-required F2): +1 BC (BC-3.2.013) — BC-3.2.013 (proactive resolution enforcement on done-category transitions: REQUIRED and OPTIONAL branches, --no-resolution flag, isConditional coverage, conservative gate, BC-3.2.009 backstop retained; single-key only; breaking change); Section 3.2 header updated to 13 contracts. Previous update 2026-06-01 (issue #331 F2): +2 BCs (BC-3.4.018..019) — BC-3.4.018 (multi-key `--type` bulk wire shape: camelCase `issueType` key, `issueTypeId` string value, name resolved via createmeta issuetypes), BC-3.4.019 (cross-project guard: keys spanning >1 project exit 64 before any API call); Section 3.4 header updated to 19 contracts. Previous update 2026-05-27 (issue #421 F2): BC-3.4.015 invariant 5 rewritten (two-stage i64-first strategy); EC-3.4.015-4b added (i64-boundary regression pin); no BC count changes (103/74 unchanged). Previous update (2026-05-25 issue #407 F2): +EC-3.4.017-14 — mechanical enforcement meta-test for BC-3.4.017 invariant 2 (conflict block completeness via `test_label_conflict_block_lists_every_relevant_flag`); BC-3.4.017 invariant 2 cross-reference added; no BC count changes (103/74 unchanged). Previous update (2026-05-22 issue #396 F2): +3 BCs (BC-3.4.015..017) — BC-3.4.015 (`issue edit --field` string/number/date/datetime/user field single-key path, with editmeta validation, fields.json cache, and dry-run invariants), BC-3.4.016 (`issue edit --field` single-select `option` field), BC-3.4.017 (`--field` multi-key/`--jql` rejection Gate A and flag-overlap Gate B); Section 3.4 header updated to 17 contracts. Previous update (2026-05-21 issue #398 F2): +3 BCs (BC-3.4.012..014) — BC-3.4.012 (issue edit table-mode success echo), BC-3.4.013 (issue edit JSON-mode success echo with changed_fields), BC-3.4.014 (issue create table-mode all-fields echo (broadened from team-only at the 2026-05-22 human-gate to mirror BC-3.4.012)); BC-3.4.003 Success output cross-reference added; Section 3.4 header updated to 14 contracts. Previous update (2026-05-20 issue #388): +2 BCs (BC-3.4.010..011): BC-3.4.010 (cross-hierarchy `edit --type` 400 → CROSS_HIERARCHY_HINT citing JRACLOUD-27893) and BC-3.4.011 (same-hierarchy/indeterminate `edit --type` 400 → typo hint or raw error, no JRACLOUD-27893 hint) added in F2 delta (issue #388). BC-3.4.003 Errors cross-reference updated (annotation only, no behavioral change). Section 3.4 header updated to 11 contracts. Previous update (2026-05-20 issue #385): +2 BCs (BC-3.8.016..017); BC-3.8.002/010/011 modified._
