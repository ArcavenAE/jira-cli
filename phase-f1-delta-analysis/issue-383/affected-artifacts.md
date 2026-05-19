---
document_type: affected-artifact-report
issue: 383
title: "Platform-path inverse warning symmetry: --field/--on-behalf-of silent-drop (O-01 from #381)"
phase: F1-Step-4
feature_type: backend
intent: enhancement
severity: N/A
scope_class: standard
produced: 2026-05-19
---

# Affected Artifact Report — Issue #383

## 1. Template: BC-3.8.011 (forward direction, quoted verbatim)

```
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
the same flag twice still emits ONE warning per logical flag.

**Inputs**: any combination of `--team`, `--points`, `--parent`, `--to`, `--account-id`
with `--request-type`
**Outputs/Effects**: One stderr warning line per dropped flag; JSM dispatch continues
normally; exit 0 on success.
**Errors**: None — these are warnings, not errors. Dispatch proceeds.
**Trace**: `tests/issue_create_jsm.rs` (per-flag warning-emission integration tests, one assertion per platform-only flag)
**Source**: Adversary pass-01 C-02 codification; mirrors BC-3.8.010 pattern
**Confidence**: HIGH

[NEW 2026-05-19 issue #288 pr4 adversary-pass-01 C-02] Added to codify the cross-flag
warning policy after adversary pass-01 found silent-drop of 5 platform-only flags on
the JSM dispatch path.
```

---

## 2. Next-Available BC-3.8.NNN Verification

From `CANONICAL-COUNTS.md` (last updated 2026-05-18):
- `bc-3-issue-write.md` frontmatter: `total_bcs: 88`, `definitional_count: 59`
- The file note at line 752 reads: "Total BCs in this file: 59 individually-bodied (cumulative 88 incl. range-collapsed)"
- BC-3.8 section ends at BC-3.8.011 (added 2026-05-19 issue #288 adversary-pass-01)

**Verified max in BC-3.8: BC-3.8.011**
**Next available: BC-3.8.012 and BC-3.8.013** — confirmed, the issue assumption is correct.

---

## 3. BC Change Classification

| BC ID | Status | Description |
|-------|--------|-------------|
| BC-3.8.011 | UNCHANGED (adjacent, forward direction) | Platform-only flags ignored on JSM path emit warnings. The template this issue mirrors. |
| BC-3.8.010 | UNCHANGED (adjacent) | `--type` ignored with warning when `--request-type` is set. |
| BC-3.8.001 | UNCHANGED (adjacent) | JSM dispatch routing; affected file: `handle_create`. |
| BC-3.3.001 | UNCHANGED (adjacent) | Platform path unchanged when `--request-type` absent. |
| **BC-3.8.012** | **NEW** | Platform path: `--field` passed without `--request-type` is silently dropped; must emit stderr warning. |
| **BC-3.8.013** | **NEW** | Platform path: `--on-behalf-of` passed without `--request-type` is silently dropped; must emit stderr warning. |

No existing BCs are modified. This is a pure additive change.

### BC-3.8.012 (proposed, 1-line description)
When `--field NAME=VALUE` is passed on the platform path (no `--request-type`), the handler
MUST emit one stderr warning per flag: `"warning: --field is ignored when --request-type is
not set; --field applies to JSM requests only"`.

### BC-3.8.013 (proposed, 1-line description)
When `--on-behalf-of <accountId>` is passed on the platform path (no `--request-type`), the
handler MUST emit one stderr warning: `"warning: --on-behalf-of is ignored when
--request-type is not set; --on-behalf-of sets the JSM requester"`.

Both BCs mirror BC-3.8.011 structure: one warning line to stderr, exit unchanged (0 on
success), JSON output shape unchanged, warning fires regardless of `--no-input` or
`--output json`.

---

## 4. Existing Forward-Direction Tests (BC-3.8.011 mirror templates)

All five are in `tests/issue_create_jsm.rs`. Verbatim function names:

1. `test_jsm_create_team_flag_emits_warning_with_request_type` (line 1590)
2. `test_jsm_create_points_flag_emits_warning_with_request_type` (line 1646)
3. `test_jsm_create_parent_flag_emits_warning_with_request_type` (line 1702)
4. `test_jsm_create_to_flag_emits_warning_with_request_type` (line 1758)
5. `test_jsm_create_account_id_flag_emits_warning_with_request_type` (line 1814)

Plus BC-3.8.010 pin (adjacent):
- `test_jsm_create_type_flag_ignored_with_warning` (line 1242)

The 2 new tests for BC-3.8.012/013 must mirror this structure: wiremock platform
POST mock (`POST /rest/api/3/issue`) with `expect(1)`, assert exit 0, assert stderr
contains verbatim warning string.

---

## 5. Regression-Risk Stories Touching `handle_create`

Stories that modified `src/cli/issue/create.rs`:

| Story ID | Title | Status |
|----------|-------|--------|
| issue-288-pr4-dispatch | `jr issue create --request-type` dispatch fork + OAuth scope addition | completed (PR #381, merged 2026-05-19) |
| S-345 | Extract `build_labels_edited_fields` + proptest | MERGED (PR #371) |
| S-2.02 | BC-3 issue-write holdout suite | MERGED (PR #304) |
| S-382 | `JrError::InsufficientScope` Display refactor | completed (PR #389, merged 2026-05-19) |

`issue-288-pr4-dispatch` is the highest regression risk: it introduced the JSM dispatch
fork in `handle_create` that this issue extends. The platform path (no `--request-type`)
is the unchanged branch — adding warnings to it requires modifying the same function.

---

## 6. Existing Integration Tests Covering `handle_create` (Must Remain Green)

**Platform path tests** (`tests/issue_create_json.rs`):
- `issue_create_json_returns_full_shape` (line 18)
- Three additional unnamed `#[tokio::test]` functions (lines 134, 231, 309)

**JSM path tests** (`tests/issue_create_jsm.rs`):
- `test_jsm_create_without_request_type_uses_platform_path` (line 254) — regression guard: `POST /rest/servicedeskapi/request` must NOT fire when `--request-type` absent
- `test_jsm_create_happy_path_routes_to_servicedeskapi` (line 184)
- All 5 BC-3.8.011 warning tests listed in §4 above
- `test_jsm_create_type_flag_ignored_with_warning` (line 1242)

All of these must continue to pass. The BC-3.8.012/013 changes touch the platform branch
of `handle_create`, which is exercised by `test_jsm_create_without_request_type_uses_platform_path`
and `issue_create_json.rs` — those are the primary regression guards.

---

## 7. Verification Properties (VPs)

No new VPs are needed. Both BC-3.8.012 and BC-3.8.013 describe additive warning-emission
behavior on the existing platform path. The invariants are:

- Warning emits to stderr (not stdout) — covered by integration test assertion pattern
  already established for BC-3.8.010 and BC-3.8.011
- Exit code unchanged — covered by `assert!(status.success())` pattern
- JSON output shape unchanged — covered by `test_jsm_create_output_json_shape_matches_platform`
  (line 1441) which can be extended or used as a reference

The existing VP for BC-3.8 ("dispatch route is flag-gated") continues to hold. No new
invariants beyond "warning emits to stderr" are introduced.

---

## 8. Feature Classification

| Attribute | Value |
|-----------|-------|
| Feature type | backend |
| Intent | enhancement |
| Severity | N/A (not a bug-fix; the silent-drop is currently by design, O-01 deferred from #381) |
| BCs modified | 0 |
| BCs new | 2 (BC-3.8.012, BC-3.8.013) |
| Tests new | 2 integration tests in `tests/issue_create_jsm.rs` |
| Files modified | `src/cli/issue/create.rs` (platform branch of `handle_create`), `tests/issue_create_jsm.rs`, `.factory/specs/prd/bc-3-issue-write.md`, `.factory/specs/prd/CANONICAL-COUNTS.md` |

---

## 9. Scope-Class Recommendation: STANDARD

**Reasoning:** Per F1 Step 4c, "trivial" requires zero new BCs and zero new test files.
This change adds 2 new BCs (BC-3.8.012, BC-3.8.013) and 2 new integration tests, which
disqualifies it from "trivial" by policy. However, the implementation is mechanically
minimal:

- The logic addition in `handle_create` is < 10 lines (two `if flags.field.is_some()` /
  `if flags.on_behalf_of.is_some()` checks emitting `eprintln!()`)
- The test structure is a copy-paste mirror of the 5 existing BC-3.8.011 tests
- No new data structures, no new API calls, no new modules

Classify as **standard** (not large/complex). One-story delivery is appropriate; no
multi-wave decomposition needed.
