---
document_type: demo-evidence-report
story_id: issue-288-pr4-dispatch
evidence_class: cli-commands (vhs-help + wiremock-integration-tests + proptests)
timestamp: 2026-05-18
producer: demo-recorder
recording_strategy: C (VHS --help recordings + 29 wiremock integration tests + 8 proptests as primary evidence)
---

# Demo Evidence: issue-288-pr4-dispatch

## Recording Strategy: Option C

**Rationale:** `issue-288-pr4-dispatch` adds the `--request-type`, `--field`, and
`--on-behalf-of` flags to `jr issue create` and wires conditional dispatch to
`POST /rest/servicedeskapi/request`. The dispatch behavior and all 19 ACs are driven by
live HTTP interactions stubbed with wiremock. Demonstrating the full behavioral contracts
(dispatch isolation, body-field placement, 401 hint routing, proptest invariants) requires
either a real Atlassian instance (unavailable) or the wiremock test suite.

VHS recordings demonstrate the static CLI surface — the new flag presence in `--help`
confirms clap wiring (AC-001/AC-002) and the scope grep confirms AC-016 — without
requiring credentials.

For every substantive behavioral contract (dispatch isolation, body shape, error paths,
proptest properties), the 29 wiremock-based integration tests in
`tests/issue_create_jsm.rs` and 8 inline proptests are the authoritative evidence.
Each integration test uses `assert_cmd::Command::cargo_bin("jr")` with `JR_BASE_URL` /
`JR_AUTH_HEADER` overrides and `wiremock::MockBuilder::expect(N)` constraints that fail
if HTTP endpoint call counts diverge from spec — making dispatch isolation
machine-verifiable without manual observation.

**What VHS covers:** CLI surface visible without credentials — new flags in help text
(AC-001, AC-002 clap wiring) and scope-presence grep (AC-016).

**What integration tests cover:** All 19 ACs with strict positive + negative-space
assertions. The `expect(1)` / `expect(0)` patterns on wiremock mocks enforce
dispatch exclusivity (AC-001 holdout H-NEW-JSM-RT-001).

**Precedent:** Matches Wave 2 S-288-pr2-cli recording strategy documented in
`docs/demo-evidence/issue-288-pr2-cli/evidence-report.md` (also Option C).

---

## VHS Recordings

| Recording | ACs | Description |
|-----------|-----|-------------|
| [AC-001-jsm-create-help.tape](AC-001-jsm-create-help.tape) | AC-001, AC-002, AC-006, AC-009, AC-010, AC-011 | `jr issue create --help` — confirms `--request-type`, `--field`, `--on-behalf-of` flags are present in the clap interface |
| [AC-001-jsm-create-help.gif](AC-001-jsm-create-help.gif) | AC-001, AC-002 | GIF embed for PR review |
| [AC-001-jsm-create-help.webm](AC-001-jsm-create-help.webm) | AC-001, AC-002 | Archival WebM |
| [AC-016-auth-scopes.tape](AC-016-auth-scopes.tape) | AC-016 | Grep of `src/api/auth.rs` confirms `write:servicedesk-request` is present in `DEFAULT_OAUTH_SCOPES` |
| [AC-016-auth-scopes.gif](AC-016-auth-scopes.gif) | AC-016 | GIF embed for PR review |
| [AC-016-auth-scopes.webm](AC-016-auth-scopes.webm) | AC-016 | Archival WebM |

---

## AC to Integration Test Mapping

All 29 integration tests are in `tests/issue_create_jsm.rs`. References below use
`tests/issue_create_jsm.rs::<test_name>` format; line numbers are the `async fn`
definition lines as of this recording.

| AC | Summary | Test Ref | Line |
|----|---------|----------|------|
| AC-001 | Dispatch to servicedeskapi; zero platform POSTs (H-NEW-JSM-RT-001) | `tests/issue_create_jsm.rs::test_jsm_create_happy_path_routes_to_servicedeskapi` | 184 |
| AC-002 | Platform path unchanged when `--request-type` absent (BC-3.3.001) | `tests/issue_create_jsm.rs::test_jsm_create_without_request_type_uses_platform_path` | 254 |
| AC-003 | Non-JSM project exits 64, zero HTTP POST (H-NEW-JSM-RT-002) | `tests/issue_create_jsm.rs::test_jsm_create_non_jsm_project_exits_64_zero_http` | 328 |
| AC-004 | Ambiguous request type exits 64 with hint + `jr requesttype list` | `tests/issue_create_jsm.rs::test_jsm_create_ambiguous_request_type_exits_64` | 393 |
| AC-005 | Numeric ID bypasses name resolution (no list endpoint call) | `tests/issue_create_jsm.rs::test_jsm_create_numeric_id_bypasses_name_lookup` | 503 |
| AC-006 | `--summary` → `requestFieldValues.summary`; missing summary exits 64 | `tests/issue_create_jsm.rs::test_jsm_create_summary_in_requestfieldvalues` | 582 |
| AC-006 | Missing summary exits 64 (no-input path) | `tests/issue_create_jsm.rs::test_jsm_create_missing_summary_exits_64` | 1927 |
| AC-007 | `--description` → ADF + `isAdfRequest: true` | `tests/issue_create_jsm.rs::test_jsm_create_description_is_adf_with_is_adf_request_true` | 653 |
| AC-007 | Description fields absent when no flag | `tests/issue_create_jsm.rs::test_jsm_create_plain_description_absent_when_no_description_flag` | 748 |
| AC-008 | `--priority` and `--label` mapped into `requestFieldValues` | `tests/issue_create_jsm.rs::test_jsm_create_priority_and_labels_mapped` | 831 |
| AC-009 | `--field` first-equals split, duplicate last-wins | `tests/issue_create_jsm.rs::test_jsm_create_field_first_equals_split_and_duplicate_last_wins` | 943 |
| AC-009 | Missing `=` in `--field` exits 64 | `tests/issue_create_jsm.rs::test_jsm_create_field_missing_equals_exits_64` | 1027 |
| AC-009 | `--field summary=X` overrides `--summary X` | `tests/issue_create_jsm.rs::test_jsm_create_field_summary_overrides_summary_flag` | 2056 |
| AC-010 | `--on-behalf-of` → `raiseOnBehalfOf` top-level | `tests/issue_create_jsm.rs::test_jsm_create_on_behalf_of_injected_at_top_level` | 1094 |
| AC-010 | `raiseOnBehalfOf` absent (not null) when flag not set | `tests/issue_create_jsm.rs::test_jsm_create_on_behalf_of_absent_when_not_set` | 1173 |
| AC-011 | `--type` ignored with stderr warning (H-NEW-JSM-RT-004) | `tests/issue_create_jsm.rs::test_jsm_create_type_flag_ignored_with_warning` | 1242 |
| AC-012 | 401 hint contains `write:servicedesk-request` (H-NEW-JSM-RT-003) | `tests/issue_create_jsm.rs::test_jsm_create_401_hint_contains_write_servicedesk_request` | 1309 |
| AC-012 | OAuth 401 scope-mismatch surfaces hint | `tests/issue_create_jsm.rs::test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` | 1523 |
| AC-013 | `parse_field_kv` extracted as standalone function; 4 proptests A.1–A.4 | `src/cli/issue/create.rs::parse_field_kv_proptests` (proptest block) | 1675 |
| AC-014 | `JsmRequestBuilder::build` extracted; 4 proptests C.1–C.4 | `src/api/jsm/requests.rs::proptests` (proptest block) | 158 |
| AC-015 | `--output json` shape `{"key": "HELP-42"}` matches platform create | `tests/issue_create_jsm.rs::test_jsm_create_output_json_shape_matches_platform` | 1441 |
| AC-016 | `write:servicedesk-request` in `DEFAULT_OAUTH_SCOPES`; pin test passes | `src/cli/auth/tests/mod.rs::default_oauth_scopes_pins_the_full_set_with_offline_access` | 332 |
| AC-016 | Dedicated AC-016 scope-presence assertion | `src/cli/auth/tests/mod.rs` (AC-016 test, line 758) | 758 |
| AC-017 | Release-gate: all suites pass; no new `unsafe`/`#[allow]` | `tests/issue_create_jsm.rs` (all 29), `tests/issue_create_json.rs`, `tests/issue_commands.rs`, `tests/issue_write_holdouts.rs` | — |
| AC-018 | `.cargo/mutants.toml` examine_globs extended with 3 new files | `.cargo/mutants.toml` + `docs/specs/cargo-mutants-policy.md` | — |
| AC-019 | `--team` flag emits warning on JSM path | `tests/issue_create_jsm.rs::test_jsm_create_team_flag_emits_warning_with_request_type` | 1590 |
| AC-019 | `--points` flag emits warning on JSM path | `tests/issue_create_jsm.rs::test_jsm_create_points_flag_emits_warning_with_request_type` | 1646 |
| AC-019 | `--parent` flag emits warning on JSM path | `tests/issue_create_jsm.rs::test_jsm_create_parent_flag_emits_warning_with_request_type` | 1702 |
| AC-019 | `--to` flag emits warning on JSM path | `tests/issue_create_jsm.rs::test_jsm_create_to_flag_emits_warning_with_request_type` | 1758 |
| AC-019 | `--account-id` flag emits warning on JSM path | `tests/issue_create_jsm.rs::test_jsm_create_account_id_flag_emits_warning_with_request_type` | 1814 |

---

## Additional Integration Tests (Edge Cases and Adversary-Discovered)

These tests pin edge cases and scenarios discovered during adversarial review passes:

| Test Ref | Finding / BC | Line |
|----------|-------------|------|
| `tests/issue_create_jsm.rs::test_platform_create_401_no_jsm_scope_hint` | Negative-space: platform 401 must NOT surface JSM scope hint | 1381 |
| `tests/issue_create_jsm.rs::test_jsm_create_missing_project_exits_64_with_jsm_specific_hint` | BC-3.8.002: missing `--project` on JSM path exits 64 with JSM-specific message | 1874 |
| `tests/issue_create_jsm.rs::test_jsm_create_request_type_not_found_exits_64` | BC-3.8.003: not-found request type exits 64 with cache-deletion hint | 1983 |
| `tests/issue_create_jsm.rs::test_jsm_create_markdown_description_yields_adf_with_strong_marks` | BC-3.8.006: `--markdown` renders bold/strong via ADF marks | 2123 |
| `tests/issue_create_jsm.rs::test_jsm_create_markdown_without_description_exits_64_with_platform_message` | `--markdown` without `--description` exits 64; error message mirrors platform path | 2233 |

**Total integration tests: 29** (23 AC-primary + 2 for AC-012 OAuth variants + 4 edge-case).

---

## Proptest Properties (8 total across 2 modules)

### A.1–A.4: `parse_field_kv` (AC-013, BC-3.8.008)

Location: `src/cli/issue/create.rs::parse_field_kv_proptests` (lines 1675–1755)

| Property | ID | Invariant |
|----------|----|-----------|
| `prop_parse_field_kv_first_equals_split` | A.1 | First `=` is the delimiter; subsequent `=` chars are part of the value. For any NAME and VALUE, round-tripping preserves the full value after the first `=`. |
| `prop_parse_field_kv_empty_value_allowed` | A.2 | `key=` (empty value) is accepted and produces `{"key": ""}`. |
| `prop_parse_field_kv_last_value_wins_on_duplicates` | A.3 | Duplicate keys collapse to one entry; the last value wins. |
| `prop_parse_field_kv_no_panic_on_arbitrary_input` | A.4 | No panic on any input string (Ok or Err both acceptable; only panics are forbidden). |

### C.1–C.4: `JsmRequestBuilder::build` (AC-014, BC-3.8.001/005/006/009)

Location: `src/api/jsm/requests.rs::proptests` (lines 158–336)

| Property | ID | Invariant |
|----------|----|-----------|
| `prop_build_jsm_request_body_summary_always_present` | C.1 | `requestFieldValues.summary` is always present and equals the passed-in `summary` argument (BC-3.8.005). |
| `prop_build_jsm_request_body_description_adf_presence` | C.2 | When `description` is `Some`: `isAdfRequest: true` AND `requestFieldValues.description` is a JSON object (ADF root). When `None`: both must be absent (BC-3.8.006). |
| `prop_build_jsm_request_body_raise_on_behalf_of_presence` | C.3 | `raiseOnBehalfOf` is present at top level when `Some`, completely absent (not null) when `None` (BC-3.8.009). |
| `prop_build_jsm_request_body_top_level_ids` | C.4 | `serviceDeskId` and `requestTypeId` are top-level string fields; both must NOT appear inside `requestFieldValues` (BC-3.8.001, adversary pass-03 M-02). |

---

## Adversarial Convergence Evidence

Three consecutive CLEAN passes achieved per BC-5.39.001 per-story adversarial review policy:

| Pass | File | Verdict | Key Confirmation |
|------|------|---------|-----------------|
| Pass 07 | `.factory/code-delivery/issue-288-pr4-dispatch/adversary-pass-07.md` | CLEAN — counter 1/3. No CRITICAL/HIGH/MEDIUM findings. All 19 ACs + 14 BCs + 4 holdouts traced. 17 cross-axis checks pass. | L-288-pr2-02 grep: zero `||` accept-either hits in JSM scope. |
| Pass 08 | `.factory/code-delivery/issue-288-pr4-dispatch/adversary-pass-08.md` | CLEAN — counter 2/3. Six LOW/NIT observations (non-blocking); all deferred. Full BC-by-BC re-derivation confirmed. | Zero `#[allow]` suppressions (refactored via `JsmCreateArgs` struct). |
| Pass 09 | `.factory/code-delivery/issue-288-pr4-dispatch/adversary-pass-09.md` | CLEAN → 3/3 CONVERGED. 28 invariants re-verified via fresh-context re-derivation. Ready for Step 5 (demos). | All 29 tests + 8 proptests in scope; `partial_match::ExactMultiple` arm mirrors `cli/requesttype.rs` exactly. |

Pass 07 explicitly confirmed: **zero `||` accept-either disjunctions in JSM scope** — the
L-288-pr2-02 grep mandate is clean.

Pass 09 closed-loop verified all 28 invariants including:
- Dispatch gate is `request_type.is_some()` only (no project-type probe)
- Platform path structurally unchanged (early-return before platform-specific code)
- `JsmRequestBuilder` is `JiraClient`-free (proptest-callable, AC-014)
- `raiseOnBehalfOf` top-level when Some, absent when None (C.3 negative-space pin)
- `serviceDeskId`/`requestTypeId` never inside `requestFieldValues` (C.4 negative-space pin)
- Both InsufficientScope (OAuth 401) and NotAuthenticated (Basic 401) surface `write:servicedesk-request` hint
- Platform 401 does NOT surface JSM scope hint (negative-guard pinned)

---

## Wave Foundation Cross-References

This story is the third and final wave of issue #288. It depends on both prior waves being merged.

| Wave | PR | Story | Key Artifacts |
|------|----|-------|---------------|
| Wave 1 | PR #379 (merged) | `issue-288-pr1-api` | `JiraClient::create_jsm_request`, `list_request_types`, `get_request_type_fields`, all serde types in `src/api/jsm/` and `src/types/jsm/` |
| Wave 2 | PR #380 (merged) | `issue-288-pr2-cli` | `jr requesttype list/fields`, `require_service_desk(call_site_label)`, `read_request_type_cache`, `write_request_type_cache`, `read_request_type_fields_cache`, `write_request_type_fields_cache` |
| Wave 3 | This PR | `issue-288-pr4-dispatch` | `--request-type`/`--field`/`--on-behalf-of` flags; `handle_jsm_create`; `parse_field_kv`; `JsmRequestBuilder`; `write:servicedesk-request` OAuth scope addition |

Wave 2 evidence report is at:
`docs/demo-evidence/issue-288-pr2-cli/evidence-report.md`

---

## Regression-Guard Evidence

| Test Suite | Purpose | Must Pass Without Modification |
|-----------|---------|-------------------------------|
| `tests/issue_create_json.rs` | Platform path regression baseline (BC-3.3.001) | Yes |
| `tests/issue_commands.rs` | Platform path regression baseline | Yes |
| `tests/issue_write_holdouts.rs` | Platform path holdout scenarios | Yes |
| `tests/requesttype_commands.rs` | Wave 2 regression (15 tests) | Yes |
| `tests/queue.rs` | BC-X.8.004 call-site label unchanged | Yes |

AC-002 is pinned by `test_jsm_create_without_request_type_uses_platform_path`
(line 254) which uses `expect(0)` on the servicedeskapi mock — machine-verifying that
the platform path never touches the JSM endpoint even when the binary is built with all
new flags compiled in.

---

## L-288-pr2-02 Grep Mandate Compliance

Per adversary pass-07 cross-axis check #12:

```
grep -r '|| accept-either' tests/issue_create_jsm.rs src/cli/issue/create.rs src/api/jsm/
```

Result: **zero hits**. All positive assertions use precise single-value matchers, not
accept-either disjunctions. Confirmed clean in pass-07, re-verified in pass-09.

---

## BC Coverage Summary

| BC ID | Summary | Pinning Tests |
|-------|---------|---------------|
| BC-3.8.001 | `--request-type` dispatches to servicedeskapi; platform path unchanged when absent | AC-001 (`expect(0)` on platform mock), AC-002 (`expect(0)` on servicedeskapi mock), C.4 proptest |
| BC-3.8.002 | Body uses `requestFieldValues`; `serviceDeskId` via `require_service_desk` | AC-003 (H-NEW-JSM-RT-002), missing-project test (line 1874) |
| BC-3.8.003 | Name resolution via `partial_match`; errors clean on Ambiguous/None | AC-004 (line 393), AC not-found test (line 1983) |
| BC-3.8.004 | Numeric `--request-type <ID>` bypasses name resolution | AC-005 (`expect(0)` on list endpoint mock, line 503) |
| BC-3.8.005 | `--summary` → `requestFieldValues.summary` (required) | AC-006 (line 582), C.1 proptest |
| BC-3.8.006 | `--description` → ADF; `isAdfRequest: true` | AC-007 (lines 653, 748), markdown tests (lines 2123, 2233), C.2 proptest |
| BC-3.8.007 | `--priority`/`--label` → `requestFieldValues` | AC-008 (line 831) |
| BC-3.8.008 | `--field NAME=VALUE`; first `=` splits; duplicate last-wins | AC-009 (lines 943, 1027, 2056), A.1–A.4 proptests |
| BC-3.8.009 | `--on-behalf-of` → `raiseOnBehalfOf` top-level; absence omitted | AC-010 (lines 1094, 1173), C.3 proptest |
| BC-3.8.010 | `--type` ignored with stderr warning when `--request-type` set | AC-011 (line 1242, H-NEW-JSM-RT-004) |
| BC-3.8.011 | Platform-only flags emit stderr warnings on JSM path | AC-019 (5 tests, lines 1590–1814) |
| BC-3.3.001 | Platform path unchanged when `--request-type` absent | AC-002 (line 254), `issue_create_json.rs` + `issue_commands.rs` green |
| BC-1.3.023 | 401 scope-mismatch hint surfaces `write:servicedesk-request` | AC-012 (lines 1309, 1523, H-NEW-JSM-RT-003), AC-016 (line 332) |
| BC-X.3.005 | `InsufficientScope` dispatch on 401 | `test_jsm_create_oauth_scope_mismatch_401_...` (line 1523) |
