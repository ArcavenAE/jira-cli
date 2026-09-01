---
document_type: story
level: ops
story_id: "S-578-4"
epic_id: "none"
title: "issue create --field platform (non-JSM) path — createmeta resolution + DEC-188 guard reversal + create-path collision guard (D2)"
wave: feature-followup
status: ready
intent: feature
feature_type: backend-cli
mode: feature
scope: standard
severity: HIGH
trivial_scope: false
points: 13
priority: P0
tdd_mode: strict
producer: story-writer
timestamp: "2026-08-26T00:00:00"
phase: 3
inputs:
  - ".factory/specs/prd/bc-3-issue-write.md"
  - ".factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md"
  - ".factory/phase-f2-spec-evolution/verification-delta-field-dx.md"
  - ".factory/stories/S-639-1.md"
input-hash: "44d224f"
traces_to: "src/cli/issue/create.rs::handle_create"
cycle: field-dx
bundle: field-dx
estimated_effort: large
estimated_days: 5
target_module: src/cli/issue/create.rs
subsystems: ["SS-02", "SS-04"]
depends_on: [S-580-1, S-578-2]
blocks: []
behavioral_contracts:
  [BC-3.3.010, BC-3.3.011, BC-3.4.014, BC-3.8.012, BC-3.8.013]
verification_properties:
  [VP-578-001, VP-578-002, VP-578-003, VP-578-004, VP-578-017, VP-578-018, VP-578-019, VP-578-020, VP-578-021, VP-578-022]
holdout_anchors: [H-NEW-PREFLIGHT-001, H-NEW-PREFLIGHT-002, H-NEW-PREFLIGHT-003, H-NEW-PREFLIGHT-004, H-NEW-PREFLIGHT-005, H-NEW-PREFLIGHT-006]
nfr_anchors: []
adr_refs: [ADR-0019, ADR-0014]
sd_refs: []
parent_phase: F3-incremental-stories
spec_source: ".factory/specs/prd/bc-3-issue-write.md"
implementation_strategy: tdd
module_criticality: HIGH
acceptance_criteria_count: 19
assumption_validations: []
risk_mitigations: []
created: "2026-08-26"
version: "1.0"
last_updated: "2026-08-26"
breaking_change: false
retroactive: false
origin: >
  Feature Mode cycle field-dx, issues #580/#578 — part 5 of field-dx bundle (#580, #578).
  Extends the platform (non-JSM) `issue create --field` path with a createmeta-driven
  resolution pipeline mirroring S-578-2's edit-path dispatch algorithm, sourced from
  get_createmeta_fields (S-580-1, REUSED VERBATIM — do not re-implement a second
  createmeta-fields fetcher). Reverses the DEC-188 pre-flight exit-64 guard for --field
  specifically (DEC-310, human-approved at the F2 gate) — S-639-1's own guard, deliberately,
  not accidentally. --on-behalf-of's guard (BC-3.8.013) is UNCHANGED. Adds the create-path
  ten-member collision guard (D2/D2-correction), distinct from and NOT identical to the
  edit-path five-member Gate B (BC-3.4.017).
changelog:
  - "1.0 (2026-08-26): Initial story authored; F2 gate convergence; bundle field-dx (issues #580/#578), wave 3."
---

> **tdd_mode:** strict — Red Gate required. Write all tests in `tests/issue_create_jsm.rs`
> (platform-path inverse-flag section) and a NEW `tests/issue_create_field.rs` first — they
> MUST fail because `handle_create` has no createmeta `--field` resolution and still carries
> the DEC-188 exit-64 guard. Red Gate: new tests FAIL → all tests PASS. This story ALSO
> DELETES existing DEC-188-era tests per BC-3.8.012's own "F3/F4 removal obligations" — the
> Red Gate protocol for those is test INVERSION (old exit-0/exit-64 assertions replaced), not
> pure addition; see Task 5.

> **Execute:** `/vsdd-factory:deliver-story S-578-4`

# S-578-4: `issue create --field` Platform-Path Support — createmeta Resolution + DEC-188 Reversal

**Bundle**: field-dx (issues #580, #578) — part 5 of 5
**GitHub issue**: #578 (item 2)
**BC anchors**: BC-3.3.010 (resolution algorithm), BC-3.3.011 (error taxonomy), BC-3.4.014
(amended — create-path table echo), BC-3.8.012 (amended/reversed — DEC-310), BC-3.8.013
(unchanged — re-verify only)
**VPs**: VP-578-001, VP-578-002, VP-578-003, VP-578-004, VP-578-017, VP-578-018, VP-578-019,
VP-578-020, VP-578-021, VP-578-022 (create call site — 3rd of 3 shared call sites)
**Routing**: standard feature, Wave 3
**Sequencing**: `depends_on: [S-580-1, S-578-2]` — reuses `get_createmeta_fields` (built by
S-580-1) VERBATIM (same `GET .../createmeta/{proj}/issuetypes/{itid}` call, one implementation
for both stories — do NOT re-implement a second createmeta-fields fetcher), and mirrors
S-578-2's dispatch-pattern precedent (`resolve_edit_fields`'s hinted-bypass algorithm,
extended with a createmeta-vs-editmeta source parameter). Both are hard prerequisites: S-580-1
supplies the HTTP method this story calls; S-578-2 supplies the dispatch algorithm this story's
own `resolve_edit_fields` extension is layered on top of (they share the SAME function).

**Subsystem anchor justification**: `subsystems: ["SS-02", "SS-04"]` — SS-02 (CLI Layer) owns
`create.rs`'s new `--field` resolution call, the DEC-188 guard removal, and the D2 collision
guard. SS-04 (Jira API Resources) is touched only via the ALREADY-BUILT `get_createmeta_fields`
(no new SS-04 code — this story is a pure consumer of S-580-1's method).

**Dependency anchor justification**: `depends_on: [S-580-1, S-578-2]` — S-580-1 because this
story's field resolution literally calls `get_createmeta_fields`, which does not exist until
S-580-1 merges; S-578-2 because `resolve_edit_fields` gains a createmeta-vs-editmeta source
parameter THIS story adds, and that extension must land on top of S-578-2's already-hinted
dispatch algorithm, not before it (extending a function that doesn't yet have hinted dispatch
would require redoing the extension twice). `blocks: []` — no downstream story in this bundle
depends on S-578-4's own code.

---

## Narrative

- **As a** `jr` CLI user creating a NEW platform (non-JSM) issue via `issue create`
- **I want** `--field NAME[:kind]=VALUE` to resolve and merge custom fields into the create
  POST body — the SAME resolution machinery `issue edit --field` already uses, substituting
  `createmeta` for `editmeta` because the issue does not exist yet at create time
- **So that** I can set custom fields (including JSM Urgency/Impact-class select fields,
  Assets object references, and any field on the project's Create screen) at creation time,
  without the DEC-188-era requirement to fake a `--request-type` or create-then-edit

*This is a full reversal (DEC-310) of a deliberate breaking change (DEC-188, S-639-1) shipped
exactly one cycle prior. It is purely permission-widening — no previously-working invocation is
broken; something that used to exit 64 now either succeeds or fails later with a more specific
resolution error.*

---

## Behavioral Contracts

| BC | Summary | Clauses Covered |
|----|---------|-----------------|
| BC-3.3.010 | `issue create --field NAME=VALUE` (repeatable, non-JSM platform path) resolves via `createmeta` and merges into the create POST body | Resolution algorithm (6 steps), Preconditions (guard-ordering SSOT reference), Postconditions, Invariants 1–5, EC-3.3.010-1..6a |
| BC-3.3.011 | Error taxonomy for `issue create --field` on the platform path (createmeta-sourced, parallels BC-3.4.015/016's editmeta-sourced taxonomy) | Error taxonomy table (10 rows), Postconditions |
| BC-3.4.014 | (amended) `issue create` table-mode success echo gains `--field NAME[:kind]=VALUE` echo rules per hint kind | "Fields echoed" `--field` bullet (amended 2026-08-26 D2) |
| BC-3.8.012 | (CURRENT BEHAVIOR — effective 2026-08-25, DEC-310) `--field` guard REMOVED; resolves via createmeta instead | "[CURRENT BEHAVIOR]" section, F3/F4 removal obligations, VP-578-017/018/019 |
| BC-3.8.013 | (unchanged) `--on-behalf-of` on platform path without `--request-type` still exits 64 pre-flight | "[CURRENT BEHAVIOR — effective 2026-08-25]" (trigger-scope note only — guard itself unmodified) |

**Platform-Path Guard Ordering SSOT** (`bc-3-issue-write.md` §"Platform-Path Guard Ordering —
`handle_create`") is authoritative for step numbering — read it in full before implementing.
Steps this story touches: step 2a (`parse_field_kv` hint-parse pass, NEW), step 2b (D2 collision
guard, NEW), step 4b (`--field` createmeta field resolution, NEW). Step 2 (BC-3.8.013) is
PRE-EXISTING and UNMODIFIED in position.

---

## Acceptance Criteria

### AC-001: Guard ordering — steps 2, 2a, 2b in the pinned deterministic order
(traces to the SSOT "Platform-Path Guard Ordering" block, BC-3.3.010 Preconditions)

Step 1 (JSM dispatch fork) → step 2 (BC-3.8.013 `--on-behalf-of` guard, PRE-EXISTING position
UNCHANGED) → step 2a (`parse_field_kv` hint-parse pass, NEW — malformed hint exits 64 here) →
step 2b (D2 create-path collision guard, NEW) → [NO `--field`-alone guard, per BC-3.8.012's
reversal] → step 3 (project-key resolution) → step 4 (interactive prompts) → step 4a
(`--description-stdin` blocking read) → step 4b (`--field` createmeta field resolution, NEW) →
step 5 (helper HTTP) → step 6 (platform POST). `jr issue create --priority X --field
priority=Y --on-behalf-of Z` (no `--request-type`) surfaces ONLY step 2's `--on-behalf-of`
error — neither step 2a's parse error nor step 2b's collision error is reached.

**Test**: `test_ssot_guard_ordering_step2_wins_over_step2a_and_2b` +
`test_ssot_guard_ordering_step2a_wins_over_step2b_when_step2_absent` in
`tests/issue_create_field.rs`.

---

### AC-002: `--field` no longer exits 64 pre-flight — DEC-188 guard removed (VP-578-017)
(traces to BC-3.8.012 "[CURRENT BEHAVIOR]" Behavior/Outputs, VP-578-017)

`jr issue create --field a=b` (no `--request-type`, well-formed field) → exit 0, platform POST
fires with the resolved field merged in; stderr does NOT contain `"--field is only valid
with"`. The old DEC-188 verbatim error string is DEAD — removed from `src/cli/issue/create.rs`.

**Test**: `test_bc_3_8_012_field_alone_no_longer_exits_64` (VP-578-017,
`test_platform_create_field_flag_exits_64_without_request_type` from S-639-1's AC-1 is
SUPERSEDED — do NOT author it as exit-64; author its inversion here) in
`tests/issue_create_field.rs`.

---

### AC-003: Combined `--field` + `--on-behalf-of` — ONLY BC-3.8.013's standalone guard fires
(traces to BC-3.8.013 "Combined pre-flight error [REWRITTEN]", VP-578-018)

`jr issue create --field a=b --on-behalf-of X` (no `--request-type`) → exit 64 via BC-3.8.013's
STANDALONE `--on-behalf-of` guard (NOT the now-removed combined guard); stderr contains
BC-3.8.013's single-flag error string, NOT the old combined-error string. `--field` no longer
contributes to any pre-flight error on the platform path.

**Test**: `test_bc_3_8_013_combined_invocation_fires_standalone_guard_only` (VP-578-018,
supersedes S-639-1's AC-3) in `tests/issue_create_field.rs`.

---

### AC-004: `--on-behalf-of` alone — unchanged, wire-for-wire from DEC-188-era behavior (VP-578-019)
(traces to BC-3.8.013, VP-578-019 regression pin)

`jr issue create --on-behalf-of X` alone (no `--field`, no `--request-type`) → exit 64 via
BC-3.8.013, UNCHANGED wire-for-wire from DEC-188-era behavior — proves this reversal did not
accidentally weaken BC-3.8.013's own guard.

**Test**: `test_vp_578_019_on_behalf_of_alone_unchanged_regression_pin` (VP-578-019) in
`tests/issue_create_field.rs`.

---

### AC-005: `--field` resolution algorithm — `customfield_NNNNN` bypass + cache-first name resolution
(traces to BC-3.3.010 Resolution algorithm Steps 1–2)

1. `customfield_\d+` bypass — same regex, same behavior as BC-3.4.015 Step 1.
2. Field-name resolution — same cache-first `fields.json`/`list_fields()` lookup as BC-3.4.015
   Step 2/2b (shared function, shared cache, no new cache family).

**Test**: `test_bc_3_3_010_customfield_bypass_on_create` +
`test_bc_3_3_010_cache_first_field_name_resolution` in `tests/issue_create_field.rs`.

---

### AC-006: Source substitution — `get_createmeta_fields` (S-580-1) instead of `editmeta`
(traces to BC-3.3.010 Resolution algorithm Step 3, Postconditions, VP-578-020(a))

Instead of `GET /issue/{key}/editmeta`, calls `get_createmeta_fields` — `GET
/rest/api/3/issue/createmeta/{projectKey}/issuetypes/{issueTypeId}` (REUSED VERBATIM from
S-580-1, NOT re-implemented), offset-paginated internally. `issueTypeId` is resolved via the
SAME `get_issue_types_for_project` (S-331) `jr` already uses for bulk `--type`. A target field
on fields-page ≥2 (two-page wiremock fixture) is collected and resolves — NOT dropped with a
spurious "not on the Create screen" error. If the field is absent from ANY page of the resolved
issue type's createmeta fields → "not on the Create screen" exit-64 shape (BC-3.3.011).

**Test**: `test_bc_3_3_010_source_substitution_createmeta_not_editmeta` +
`test_vp_578_020a_field_on_createmeta_page_2_resolves` (VP-578-020(a)) in
`tests/issue_create_field.rs`.

---

### AC-007: `get_issue_types_for_project` — offset-paginated, page ≥2 resolves (VP-578-020(b))
(traces to BC-3.3.010 Postconditions "issue-type lookup", VP-578-020(b))

`get_issue_types_for_project` (S-331, `src/api/jira/issues.rs`) is OFFSET-PAGINATED internally
(`startAt`/`maxResults=200`/`total`). A `--type` on issuetypes-page ≥2 of a large enterprise
type scheme still resolves — NOT silently dropped. This is a distinct call from
`get_createmeta_fields`, fires AT MOST ONCE per invocation, and is introduced by `--field`'s
presence (on the standard platform create path without `--field`, `--type` is passed to the
POST body BY NAME and does NOT itself trigger this lookup).

**Test**: `test_vp_578_020b_type_on_issuetypes_page_2_resolves` (VP-578-020(b)) in
`tests/issue_create_field.rs`.

---

### AC-008: Type dispatch and option-value resolution — identical to BC-3.4.015 Step 4/BC-3.4.016 Step 4a
(traces to BC-3.3.010 Resolution algorithm Step 4)

Identical to the edit-path dispatch, reading `allowedValues[].id` from the createmeta field
entry (same untyped-`items` shape caveat). Hint-kind syntax (`:option`/`:id`/`:name`/`:asset`,
BC-3.4.026-030) is available on this path — SAME parser (S-578-1), SAME wire-shape rules,
`allowedValues` source substituted per Step 3. `resolve_edit_fields` is extended to accept a
createmeta-vs-editmeta source parameter, enabling one shared dispatch function for both stories
— NOT a second, independently-implemented dispatch.

**Test**: `test_bc_3_3_010_type_dispatch_shares_resolve_edit_fields_createmeta_source` +
`test_bc_3_3_010_hint_kinds_available_on_platform_create` in `tests/issue_create_field.rs`.

---

### AC-009: `:asset` cold-cache workspace-discovery failure taxonomy — create-path call site
(traces to BC-3.4.030 Error taxonomy table, VP-578-022 — 3rd of 3 shared call sites)

Four rows, exercised at THIS (`create.rs` platform path) call site independently of S-578-2's
edit-path assertion and S-578-3's JSM-path assertion:

| Condition | Behavior |
|---|---|
| 403 or 404 | `JrError::UserError`: "Assets is not available on this Jira site..." → exit 64 |
| 200 + zero workspace entries | `JrError::UserError`: "No Assets workspace found on this Jira site..." → exit 64 |
| 401 | Standard `JrError::NotAuthenticated`/`InsufficientScope` mapping |
| 5xx / network error | Standard `JrError::ApiError`/`NetworkError` mapping |

**Test**: `test_bc_3_4_030_create_path_asset_cold_cache_403_404_assets_unavailable` +
`test_bc_3_4_030_create_path_asset_cold_cache_empty_workspace` +
`test_bc_3_4_030_create_path_asset_cold_cache_401_standard_auth_mapping` +
`test_bc_3_4_030_create_path_asset_cold_cache_5xx_network_standard_mapping` (VP-578-022) in
`tests/issue_create_field.rs`.

---

### AC-010: All-or-nothing multi-`--field` failure — zero POST on any resolution failure (VP-578-003)
(traces to BC-3.3.010 Invariant 2, VP-578-003)

On resolution failure (zero-match, ambiguous name, unsupported type, field absent from
createmeta) → exit 64, ZERO HTTP POST. Same all-or-nothing semantics as BC-3.4.015
EC-3.4.015-12/VP-396-009, transplanted to the create path.

**Test**: `test_vp_578_003_all_or_nothing_multi_field_failure` (VP-578-003) in
`tests/issue_create_field.rs`.

---

### AC-011: Create-path collision guard — ten-member governed set (D2/D2-correction, VP-578-021)
(traces to BC-3.3.010 Invariant 5, EC-3.3.010-6/6a, BC-3.3.011 taxonomy row, VP-578-021)

A dedicated-flag × `--field` wire-key collision is rejected exit 64 BEFORE resolution, BEFORE
project/type resolution, via `field_resolve::detect_flag_field_overlap` (the SAME shared
function BC-3.4.017's edit-path Gate B uses, called with a DIFFERENT, TEN-member set — this
extension does NOT modify Gate B's own five-member edit-path set):

**5 original Gate-B-shaped static keys**: `summary`, `description`, `issuetype`, `priority`,
`components`.
**3 new static keys**: `labels` (`--label`) — DELIBERATELY DIFFERS from edit-path Gate B, which
EXCLUDES `labels` because `issue edit --label` forks to a different endpoint/payload shape
(BUG-LABEL-400); `issue create --label` has NO such fork — one code path writes
`fields["labels"]` unconditionally, so `labels` MUST be governed here. `parent` (`--parent`).
`assignee` (`--to`/`--account-id`).
**2 new resolved-id keys, asserted SEPARATELY**: `--points` → story-points `customfield_NNNNN`
(bypass-form-only equality; `resolve_story_points_field_id` is unconditionally config-only) and
`--team` → team `customfield_NNNNN` (only when `team_field_id` configured; `client.
find_team_field_id()` HTTP is NEVER invoked to service this guard).

**Documented non-firing residual**: `--points 5 --field "Story Points"=8` (a human DISPLAY NAME
spelling, not the `customfield_NNNNN` bypass form) does NOT trip the guard — resolving a display
name here would require hoisting general field-name resolution ahead of the step-2b zero-HTTP
boundary. This is a NEGATIVE regression pin, not a silently-accepted gap.

**Test**: `test_vp_578_021_create_path_collision_5_original_static_keys` +
`test_vp_578_021_create_path_collision_labels_parent_assignee` +
`test_vp_578_021_create_path_collision_points_resolved_id` +
`test_vp_578_021_create_path_collision_team_resolved_id_configured` +
`test_vp_578_021_negative_pin_display_name_spelling_does_not_trip_guard` (VP-578-021) in
`tests/issue_create_field.rs`.

---

### AC-012: Error taxonomy — 10-row table, collision row evaluated FIRST (VP-578-004)
(traces to BC-3.3.011 Error taxonomy table, Postconditions, VP-578-004)

Full table, "Create screen" substituted for "Edit screen" throughout: dedicated-flag × `--field`
collision (evaluated BEFORE every other row and before project/type resolution) → zero matches
in `list_fields()` → multiple substring matches → field absent from createmeta ("is not on the
Create screen") → number field non-numeric → `array`/`any` unsupported type → option field
unresolvable value → option field ambiguous → matched entry `id: None` ("no machine-readable
id") → `list_fields()`/createmeta HTTP failure (401/403/5xx) propagated. Each row independently
exercised by a wiremock test asserting exit 64, zero POST, and the exact load-bearing substring.

**Test**: `test_bc_3_3_011_error_taxonomy_all_10_rows` (table-driven, VP-578-004) in
`tests/issue_create_field.rs`.

---

### AC-013: Create-path echo (BC-3.4.014 amendment) — `--field` fields in the success echo
(traces to BC-3.4.014 "Fields echoed" `--field` bullet, D2 amendment)

`--field` fields appear in the create success echo (table mode) alongside existing
`--summary`/`--priority`/etc bullets, interleaved into the SAME alphabetical field-name
ordering. Echo KEY is the human field name (or `customfield_NNNNN` literal for bypass). Echo
VALUE mirrors the edit-path `changed_fields` convention per hint kind: bare/`:option` →
resolved human-readable label (or `"<parent> > <child>"` for cascading); `:id` → raw id
literal; `:name` → `VALUE` verbatim; `:asset` → `"<workspaceId>:<objectId>"` composite string.
Per the D2 amendment, a `--field priority=High` entry sorting under `priority` alongside a
dedicated `--priority` flag is no longer reachable in practice — the D2 guard (AC-011) rejects
that combination before echo assembly.

**Test**: `test_bc_3_4_014_field_echo_bare_and_hinted_per_kind` in `tests/issue_create_field.rs`.

---

### AC-014: JSON mode is UNCHANGED — no `changed_fields` key added to create JSON output
(traces to BC-3.4.014 "JSON mode is UNCHANGED")

`issue create --output json` already performs a follow-up GET returning the full created issue
object — a superset of the edit `changed_fields`. No `changed_fields` key is added; the JSON
path is byte-for-byte identical to pre-#398 behavior.

**Test**: `test_bc_3_4_014_json_mode_unchanged_no_changed_fields_key` in
`tests/issue_create_field.rs`.

---

### AC-015: Field resolution runs AFTER project/type resolution, BEFORE POST (Invariant 1)
(traces to BC-3.3.010 Invariant 1, SSOT step 4b)

`--field` resolution on create runs AFTER `--project`/`--type` resolution and BEFORE the POST —
same ordering discipline as BC-3.4.015 Invariant 1 on the edit path. Step 4b's `--field`
createmeta resolution requires all of steps 2/2a/2b/3 to have already passed.

**Test**: `test_bc_3_3_010_field_resolution_ordering_after_project_type_before_post` in
`tests/issue_create_field.rs`.

---

### AC-016: F3/F4 removal obligations — DEC-188 test inversion, help-text reversion
(traces to BC-3.8.012 "[CURRENT BEHAVIOR]" F3/F4 removal obligations)

The `--field`-alone pre-flight check and its verbatim error string are DELETED from
`src/cli/issue/create.rs`. The COMBINED-check is narrowed to `--on-behalf-of`-alone (already
BC-3.8.013's existing guard — no new code, just removal of the `--field` half). Every test
asserting the OLD `"--field is only valid with"`/combined-error strings on a `--field`-alone or
combined invocation is UPDATED to assert the NEW createmeta-resolution success/error paths.
`src/cli/mod.rs`'s `--field` help text's "requires --request-type" clause is REVERTED. The
AC-12 help-text substring count changes from `== 2` to `== 1`, scoped to the `--on-behalf-of`
help line ONLY.

**Test**: `test_bc_3_8_012_field_help_text_no_longer_requires_request_type` +
`test_ac12_help_text_substring_count_is_1_on_behalf_of_only` in `tests/issue_create_field.rs`.

---

### AC-017: Holdout scenarios H-NEW-PREFLIGHT-001/003/006 rewritten to the reversed contract
(traces to BC-3.8.012 "[CURRENT BEHAVIOR]" F3/F4 removal obligations)

H-NEW-PREFLIGHT-001 (`--field`-alone, human mode) and H-NEW-PREFLIGHT-003 (combined-flag
invocation) and H-NEW-PREFLIGHT-006 (`--output json` mode counterpart of -001) are REWRITTEN IN
PLACE (not left MUST-PASS against a superseded contract) to assert the NEW createmeta-resolution
success/error paths (VP-578-017/018). H-NEW-PREFLIGHT-002 (`--on-behalf-of` alone) is UNCHANGED
and MUST NOT be touched. H-NEW-PREFLIGHT-004 (neither flag, exit 0 regression pin) and
H-NEW-PREFLIGHT-005 (JSM path non-mis-fire) are unaffected.

**Test**: manual verification against `.factory/specs/prd/holdout-scenarios.md` — the actual
rewrite of holdout scenario text is a doc-fallout deliverable of this story's PR, not a
`tests/` assertion.

---

### AC-018: `--markdown --field description=x` intersection with DEC-188 removal
(traces to EC-3.8.012-5, now stale post-reversal — regression check only)

`--markdown --field description=x` WITHOUT `--request-type` no longer fires BC-3.8.012's
now-removed guard. The platform path (`handle_create`) still has NO `--markdown`-requires-
`--description` guard of its own (that guard exists only in `jsm_create.rs`/`edit.rs`) —
`--field description=x --markdown` resolves via createmeta like any other `--field`, and
`--markdown` applies to the resolved description value normally.

**Test**: `test_ec_3_8_012_5_markdown_field_description_no_longer_guarded` in
`tests/issue_create_field.rs`.

---

### AC-019: Config/auth failures still precede the (now-removed) guard entirely (EC-3.8.012-6 unaffected)
(traces to EC-3.8.012-6, unaffected by this reversal)

`Config::load_with` and `JiraClient::from_config` run in `src/main.rs` BEFORE `handle_create` is
invoked. Unauthenticated callers exit 2 and misconfigured callers exit 78 before `handle_create`
is reached — this ordering fact is unaffected by the DEC-188 guard's removal (there is no guard
left for auth/config failures to precede).

**Test**: no new test required — this is a regression NON-change; assert via existing
auth/config test families, cite in the PR description rather than duplicating coverage.

---

## Architecture Mapping

| Component | File | Pure/Effectful | Notes |
|-----------|------|-----------------|-------|
| DEC-188 guard removal | `src/cli/issue/create.rs::handle_create` (MODIFIED) | Effectful shell | Delete the `--field`-alone check + verbatim string |
| `parse_field_kv` hint-parse pass (step 2a) | `src/cli/issue/create.rs::handle_create` (MODIFIED) | Effectful shell (calls S-578-1's pure parser) | Malformed hint exits 64 here |
| D2 create-path collision guard (step 2b) | `src/cli/issue/create.rs::handle_create` (MODIFIED) | Effectful shell (calls pure `detect_flag_field_overlap`) | Ten-member set — distinct call site from edit-path Gate B |
| `--field` createmeta field resolution (step 4b) | `src/cli/issue/create.rs::handle_create` (MODIFIED) | Effectful shell | Calls S-580-1's `get_createmeta_fields` verbatim |
| `resolve_edit_fields` createmeta-vs-editmeta source parameter | `src/cli/issue/field_resolve.rs` (MODIFIED) | Effectful shell (unchanged classification) | Extends the SAME function S-578-2 hint-enabled — one shared dispatch, not a second implementation |
| `detect_flag_field_overlap` create-path variant | `src/cli/issue/field_resolve.rs` (MODIFIED — likely a distinct create-path variant/table, not a mutation of the edit-path 5-member set) | Pure core | See Forbidden Dependencies |
| `src/cli/mod.rs` `--field` help text | `src/cli/mod.rs` (MODIFIED) | N/A (clap help string) | Revert "requires --request-type" clause |

---

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-3.3.010-1 | `--field "Unknown Field=Value"` | exit 64, same hint as EC-3.4.015-1 |
| EC-3.3.010-2 | Field found globally but absent from resolved createmeta | exit 64, "is not on the Create screen" |
| EC-3.3.010-3 | `--field` supplied but `--project`/`--type` unresolvable | pre-existing project/type resolution error fires first |
| EC-3.3.010-4 | `customfield_NNNNN` literal on create | same bypass as BC-3.4.015 Step 1, against createmeta |
| EC-3.3.010-5 | Option-type field, value not in `allowedValues` | exit 64 listing allowed values |
| EC-3.3.010-6/6a | Dedicated-flag × `--field` collision (10-member set) | exit 64, D2 guard, zero HTTP |
| EC-3.8.012-1 | `--on-behalf-of ""` WITH `--field` present | STALE post-reversal — BC-3.8.013's standalone guard now governs unconditionally |
| EC-3.8.012-5 | `--markdown --field description=x` WITHOUT `--request-type` | no longer guarded; resolves via createmeta (AC-018) |
| EC-3.8.012-6 | Config/auth failures precede any guard | unaffected — no guard remains to precede for `--field`-alone (AC-019) |
| EC-3.8.012-9 | `--field a=` (empty VALUE) | FULLY SUPERSEDED — resolves via createmeta success/error paths, not the removed guard |

---

## Purity Classification

| Module | Classification | Justification |
|--------|-----------------|----------------|
| `src/cli/issue/create.rs::handle_create` (modified) | effectful-shell (unchanged classification) | Already-classified effectful handler; hint-syntax + createmeta resolution are new call patterns within an already-effectful module |
| `src/cli/issue/field_resolve.rs::detect_flag_field_overlap` (create-path variant) | pure-core (function) | Set-intersection over an already-parsed map and a caller-supplied governed-key set; no I/O |
| `src/cli/issue/field_resolve.rs::resolve_edit_fields` (extended) | effectful-shell (unchanged classification) | Already effectful; createmeta-vs-editmeta source param is additive |

---

## Token Budget Estimate

| Item | Est. Tokens |
|------|------------|
| Story spec (this file) | ~14 k |
| BC-3.3.010/011 (full) | ~9 k |
| BC-3.4.014 (amended `--field` bullet) | ~2 k |
| BC-3.8.012 (full, incl. DEC-188 superseded block for audit context) | ~14 k |
| BC-3.8.013 (full) | ~3 k |
| Platform-Path Guard Ordering SSOT block | ~3 k |
| `src/cli/issue/create.rs` (existing `handle_create`, 394 LOC) | ~3 k |
| `src/cli/issue/field_resolve.rs` (post-S-578-2, ~914+ LOC — read the hinted dispatch this story extends) | ~10 k |
| `S-639-1.md` (DEC-188 origin, read for reversal context) | ~6 k |
| New/modified tests | ~10 k |
| **Total** | **~74 k** |

This is the largest, most context-dense story in the bundle (13 points, 19 ACs). If actual
implementation context materially exceeds this estimate, consider splitting the DEC-188
removal + D2 guard (steps 2/2a/2b) into a separate sub-PR from the createmeta resolution
pipeline (step 4b) — flag to the orchestrator before expanding scope unilaterally.

---

## Tasks

**Red Gate protocol**: This story has TWO kinds of Red Gate work: (a) NEW tests for the
createmeta resolution pipeline (pure addition, standard Red Gate); (b) INVERTED tests for the
DEC-188 guard removal (existing `tests/issue_create_jsm.rs` platform-path-inverse-flag tests
must be rewritten from exit-64 assertions to exit-0/createmeta-resolution assertions — mirror
DEC-188's OWN test-inversion discipline the first time around, documented in BC-3.8.012's
"[DEC-188 BEHAVIOR, superseded]" block's Removal postcondition text).

### Task 0 — Read source context

Read:
- `.factory/stories/S-639-1.md` in full — the DEC-188 origin story this story deliberately,
  not accidentally, reverses
- BC-3.3.010, BC-3.3.011 in full (`bc-3-issue-write.md`)
- BC-3.8.012 in full, INCLUDING the superseded `[DEC-188 BEHAVIOR]`/`[DEC-188 CONTRACT]` blocks
  for audit-trail context AND the `[CURRENT BEHAVIOR — effective 2026-08-25]` section — the
  AC-1..21 list's superseded/unaffected split is critical: AC-1/3/5/7/9/10/11/13/17/18/19 are
  SUPERSEDED (do NOT author as exit-64), AC-2/16/20/6/21 are UNAFFECTED (author as-is)
- BC-3.8.013 in full, including the "[CURRENT BEHAVIOR — effective 2026-08-25]" rewrite note
- BC-3.4.014's amended `--field` bullet
- The Platform-Path Guard Ordering SSOT block in full
- `src/cli/issue/create.rs::handle_create` (current, 394 LOC)
- `.factory/stories/S-580-1-field-options-command.md` — confirms `get_createmeta_fields`'s
  exact signature to reuse verbatim
- `.factory/stories/S-578-2-edit-field-hint-dispatch.md` — confirms `resolve_edit_fields`'s
  post-S-578-2 shape (hinted dispatch already present) that this story extends further

### Task 1 — Write tests/issue_create_field.rs (Red Gate, new coverage)

Write AC-005 through AC-015, AC-018, AC-019. Confirm they fail (no createmeta resolution
exists in `handle_create` yet).

### Task 2 — Invert the DEC-188-era platform-path tests in tests/issue_create_jsm.rs

Per BC-3.8.012's AC-1..21 superseded list: rewrite AC-1/3/5/7/9/10/11/13/17/18/19's test
bodies to assert createmeta-resolution success/error paths (VP-578-017/018/019), NOT exit-64.
AC-2/16/20 (unaffected `--on-behalf-of`-alone) and AC-6/21 (JSM non-mis-fire) remain
authoritative as-is. AC-12's help-text pin changes `count() == 2` → `count() == 1`.

### Task 3 — Remove the DEC-188 guard + verbatim strings

Delete the `--field`-alone pre-flight check from `handle_create`. Narrow the combined check to
`--on-behalf-of`-alone (BC-3.8.013's pre-existing guard, unmodified in behavior — only the
`--field` half of the combined check is removed).

### Task 4 — Implement step 2a (`parse_field_kv` hint-parse pass) and step 2b (D2 collision guard)

Per the SSOT block's exact positions. The D2 guard's ten-member governed set is DISTINCT from
edit-path Gate B's five-member set — implement as a separate call to
`detect_flag_field_overlap` with the create-path's own governed-key set, not a mutation of
Gate B's set.

### Task 5 — Implement step 4b (`--field` createmeta field resolution)

Extend `resolve_edit_fields` with a createmeta-vs-editmeta source parameter. Reuse
`get_createmeta_fields` (S-580-1) and `get_issue_types_for_project` (S-331) verbatim.

### Task 6 — Implement the create-path echo (BC-3.4.014 amendment)

### Task 7 — Revert `--field` help text; fix AC-12 count

### Task 8 — Rewrite holdout scenarios H-NEW-PREFLIGHT-001/003/006 in place

### Task 9 — Confirm all tests pass + full regression

```bash
cargo test --test issue_create_field -- --nocapture
cargo test --test issue_create_jsm -- --nocapture   # inverted ACs + unaffected ACs
cargo clippy -- -D warnings
```

### Task 10 — PR creation

Create PR to `develop`:
- Title: `feat(issue): issue create --field platform-path createmeta resolution — reverses DEC-188 (#578 part 5)`
- Reference #578; explicitly cite DEC-310 (registered 2026-08-26, human-approved at the F2
  gate, reverses DEC-188); CHANGELOG entry under `### Changed` (NOT `### Breaking Changes` —
  this reversal does not break any previously-working invocation)

---

## Previous Story Intelligence

**S-639-1** (`.factory/stories/S-639-1.md`) is the DEC-188 origin story — read it in full. This
story is a DELIBERATE, documented reversal of S-639-1's own guard, not an accidental
regression of its own intent. S-639-1's AC-1..21 test-body precedent (verbatim error strings,
FULL-STRING vs prefix pins, DISCRIMINATING/FALSIFIABLE-COARSE/HYGIENE negative-assertion
labeling convention) is the exact structure this story's test-inversion work follows — do not
invent a new labeling scheme; reuse S-639-1's own conventions for the inverted assertions.

**S-580-1** (once merged) is the origin of `get_createmeta_fields` — this story's step 4b
consumes it verbatim; do not re-implement a second createmeta-fields fetcher, even a
"simplified" one.

**S-578-2** (once merged) is the dispatch-pattern precedent this story mirrors: `resolve_edit_fields`'s
hinted-bypass algorithm (kind-aware dispatch reading `spec.kind` before falling through to
type-based auto-detect) is extended here with a source parameter, not reimplemented from
scratch. Read S-578-2's finished story for the exact function shape before writing the
createmeta-source extension.

---

## Architecture Compliance Rules

(Extracted from ADR-0019 §"D2 correction", CLAUDE.md, `architecture-delta-field-dx.md` §"D2 correction")

1. **`get_createmeta_fields` is reused VERBATIM from S-580-1.** Do not re-implement a second
   createmeta-fields fetcher, even a "simplified" or "create-path-specific" one — same
   `GET .../createmeta/{proj}/issuetypes/{itid}` call, one implementation for both stories.
2. **The edit-path Gate B five-member set (BC-3.4.017, pre-existing, unchanged) and the
   create-path D2 ten-member set (BC-3.3.010/3.3.011, new) are DISTINCT and MUST NEVER be
   described as the same set or unified into one function signature that silently applies one
   set to both paths.** `detect_flag_field_overlap` is a SHARED FUNCTION (mechanism reuse),
   NOT a claim of identical governed-key sets — each caller passes its own governed set.
3. **`labels` is governed on create but NOT on edit** — this is a deliberate, documented
   asymmetry (BUG-LABEL-400's endpoint fork on edit has no analog on create), never "fix" it
   into symmetry with Gate B.
4. **The DEC-188 guard removal MUST NOT be a partial deletion.** Both the `--field`-alone check
   AND its verbatim error string, AND the combined-check's `--field` half, must be fully
   removed — a lingering dead code path that never fires is still a maintenance hazard and
   contradicts the "F3/F4 removal obligations" text.
5. **`--on-behalf-of`'s guard (BC-3.8.013) is UNTOUCHED in mechanism** — only its TRIGGER SCOPE
   widens (it now fires standalone even when `--field` is also present, since the combined
   check that used to pre-empt it is gone). Do not modify BC-3.8.013's own verbatim error
   string or guard placement.
6. **VP-578-022 is asserted independently at THIS call site** (AC-009) — do not treat it as
   "already covered" by S-578-2 or S-578-3's own assertions of the same VP at their own call
   sites.

---

## Library & Framework Requirements

| Library | Version | Constraint |
|---------|---------|------------|
| wiremock | 0.6 | FIFO ordering — use isolated `MockServer` instances with ONLY `expect(0)` mocks for zero-HTTP proof tests (mirrors S-639-1's AC-8 `MockServer` isolation constraint); do NOT reuse a shared `mount_platform_create_stubs` helper for guard-tripping tests |
| (no new crate) | N/A | No new third-party dependency |

---

## File Structure Requirements

| File | Action | Notes |
|------|--------|-------|
| `src/cli/issue/create.rs` | MODIFY | `handle_create` — DEC-188 guard split/removal, step 2a/2b guards, step 4b createmeta field resolution, create-path echo |
| `src/cli/issue/field_resolve.rs` | MODIFY | Extend `resolve_edit_fields` with createmeta-vs-editmeta source param; extend `detect_flag_field_overlap` for the create-path ten-member set (distinct variant/table) |
| `src/cli/mod.rs` | MODIFY | Revert `--field` help text's "requires --request-type" clause |
| `tests/issue_create_field.rs` | CREATE | AC-005 through AC-015, AC-018, AC-019 |
| `tests/issue_create_jsm.rs` | MODIFY | Invert AC-1/3/5/7/9/10/11/13/17/18/19; AC-12 count fix; AC-2/16/20/6/21 unaffected |
| `.factory/specs/prd/holdout-scenarios.md` | MODIFY (doc-fallout) | Rewrite H-NEW-PREFLIGHT-001/003/006 in place |
| `docs/adr/0014-jsm-request-type-dispatch.md` | MODIFY (doc-fallout) | Further amendment noting the `--field` guard's removal |
| `CHANGELOG.md` | MODIFY (doc-fallout) | `### Changed` entry (not `### Breaking Changes`) |

**Files that MUST NOT change:**
- `src/cli/issue/edit.rs` — S-578-2's scope
- `src/cli/issue/jsm_create.rs`, `src/api/jsm/requests.rs` — S-578-3's scope
- `src/cli/field.rs` — S-580-1's scope (this story only CONSUMES `get_createmeta_fields`, never
  modifies the module that defines it)
- BC-3.8.013's own verbatim error string or guard placement
- Any `.factory/specs/prd/` BC file
