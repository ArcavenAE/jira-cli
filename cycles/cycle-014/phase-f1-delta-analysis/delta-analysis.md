---
document_type: delta-analysis-report
feature_name: "issue-triage-quickfixes (cycle-014)"
created: 2026-09-24
spec_version_at_analysis: "total_bcs 160 (cross-cutting.md) — develop @ 09bb2803, v0.8.0-dev.1"
status: approved
intent: "bug-fix"
feature_type: "backend"
scope: "standard"
severity: "LOW"
---

# Delta Analysis Report: issue-triage-quickfixes (cycle-014)

## F1 Gate Outcome (2026-09-24)

**"Approve, as corrected."** Scope minted as **D-378** (pending mint by
state-manager): #862 (full) + #861 READ-SIDE ONLY + #583 (full). Three
parallel-wave-eligible S stories: STORY-A = #862, STORY-B = #861 read-side,
STORY-C = #583.

The #861 WRITE-SIDE item (`find_option_match`/`resolve_option_value`
name-fallback in `src/cli/issue/field_resolve.rs`) is **REMOVED from
scope** — the fresh-context audit REFUTED its reachability. Verified in
code: `dispatch_field_value` (`src/cli/issue/field_resolve.rs`) matches on
`meta_field.schema.field_type` and only reaches
`resolve_option_value`/`find_option_match` for `"option"`. The hinted
`:option` composer's entry gate (EC-3.4.027-1) likewise admits only
`"option" | "option-with-child"`. Real Jira system fields report
`schema.type` `priority`/`resolution`/`issuetype`/`securitylevel`, so
`--field Priority=High` fails earlier via `unsupported_field_type_error`,
and never reaches value-only matching. Corroborated by
`tests/issue_edit_field.rs::test_bc_3_4_017_field_priority_without_flag_does_not_trigger_gate_b`,
which mocks priority as a custom `"string"` field. The Item #861 appendix,
the Files Changed tables, the risk-zone tests, and Open Question 2 below
are corrected accordingly; `field_resolve.rs` is removed from #861's
modified-files list (retained only as a dependent/unchanged reference
file).

The newly-surfaced separate gap — "`--field` cannot set system-typed
fields (priority/resolution/issuetype/securitylevel → unsupported field
type error)" — is recorded as a **Deferred / Follow-up** item (see that
section below), NOT folded into #861's scope. Suggested drift-item ID:
`FIELD-SYSTEM-TYPES-UNSUPPORTED` (LOW), final ID to be assigned by
state-manager.

Audit finding folded in: `src/cli/api.rs` and `src/cli/user.rs` are added
to the planned `.cargo/mutants.toml` `examine_globs` additions (in scope
for this cycle's implementation/F6). `.cargo/mutants.toml` is now listed
in Modified Files below.

Accepted without change: #861's `field options --output json` `label`
changing from `null` to a string for system fields is a bug fix
(non-breaking). #583's four design defaults are accepted (merge with
existing `?`, allow repeated same-name params, encode raw values exactly
once, method-orthogonal). BC filing for `jr api` is deferred to F2 as a
cross-cutting subsection. The `user_list_requires_project_flag` test-name
note is acknowledged (no rename).

Every Open Question below is marked RESOLVED with the decision recorded
inline. Manifest status: `f1-approved`. Next phase: **F2**.

## Feature Request

- **Brief:** Human-approved bundle of three GitHub issue fixes (decision
  pending mint as **D-378**): #862 (`jr user list` ignores global
  `--project`), #861 (`jr field options` renders system-field options as
  `(unnamed)`), #583 (`jr api --query-param NAME=VALUE`). No other items are
  in scope.
- **Requested by:** Human, via GitHub issue triage
  (`.factory/research/github-issues-triage-grounding-2026-09-24.md` external
  grounding + `.factory/phase-f1-delta-analysis/issue-triage-enhancement-cluster-2026-09-10.md`
  prior triage, both consulted; issue bodies themselves read via
  `gh issue view <N> --json title,body` and treated strictly as untrusted
  third-party requirement claims — no instructions, links, or code from
  issue bodies were followed or executed).
- **Date:** 2026-09-24

---

## Classifications

### Intent Classification

**Classified intent:** `bug-fix`
**Rationale:** #862 and #861 are confirmed defects against
already-documented/expected behavior (a same-id local `--project` flag that
silently fails to receive the global value the rest of the CLI honors; a
display-label field that renders blank for a whole class of fields the
existing `AllowedValue` type already carries data for). #583 is a
capability gap rather than a broken contract, but the human's own bundling
decision routes it through this bug-fix-shaped quickfix cycle alongside the
other two rather than a full feature cycle — recorded here as the human's
explicit choice, not a reclassification of #583's actual nature (see Open
Question 4).

### Feature Type Classification

**Classified type:** `backend`
**Rationale:** All three are CLI-argument-parsing / config-resolution /
API-passthrough layer changes with no UX/visual surface, no screen, no
front-end component.

### Trivial Scope Classification

- [x] Impact boundary: single module, single file, or documentation only —
      **FAILS for the bundle as a whole** (3 independent file groups across
      2 subsystems: CLI dispatch/config-merge, and field-option
      normalization/matching, and API passthrough); each ITEM individually
      would pass this criterion in isolation.
- [ ] No new BCs needed — **FAILS**: #583 needs an entirely new BC (no `jr
      api` BC file exists today).
- [x] No architecture change — true for all three.
- [x] No new external dependencies — true for all three (`url`/
      `urlencoding` already direct deps).
- [x] Regression risk: LOW — true for all three (see Risk Assessment).

**Classified scope:** `standard`
**Rationale:** Fails 2 of 5 trivial criteria at the bundle level (impact
boundary breadth, new-BC requirement), even though every individual item is
S-sized with LOW regression risk. Routes through full F1→F7 (this is
already Feature Mode, not quick-dev), not quick-dev routing.

### Severity Classification (bug-fix intent only)

**Classified severity:** `LOW`
**Rationale:** All three have workarounds today: #862 can be worked around
via a per-invocation `.jr.toml` project default; #861 can be worked around
by reading the numeric `id` directly from `--output json` (only the
human-readable label is blank, not the data); #583 can be worked around by
pre-assembling the query string onto the `path` argument by hand (the
issue's own reported workaround). No data loss, no security exposure, no
production-down condition for any of the three.

---

## Impact Assessment

| Dimension | Affected | Details |
|-----------|----------|---------|
| PRD Requirements | 0 new, 2 modified, 1 new BC pending F2 | BC-X.7.002 (amended, additive); BC-X.14.001 + BC-X.14.003 (amended, label-resolution rule); new BC subsection for `jr api --query-param` (numbering TBD at F2, precedent: BC-X.14's cross-cutting-subsection sizing) |
| Architecture | 0 components added, 0 modified | No `.factory/specs/architecture/*` change — none of the three crosses a module or purity boundary; all are config-merge, display/matching-fallback, or additive-flag changes within existing modules |
| UX Screens | 0 | CLI-only, no UX artifact |
| Stories | 3 new stories estimated (S-sized each) | STORY-A (#862, CLI+config+handler), STORY-B (#861, read+write label/match fallback), STORY-C (#583, new flag + encoding) — see Scope Recommendation |
| Existing Tests | 3 tests directly touched/verified, 0 required to change | `tests/user_commands.rs::user_list_requires_project_flag` (survives unchanged, verified by text inspection — see item detail below); `tests/field_options.rs::test_bc_x_14_003_degenerate_entry_table_glyphs` + `..._json_emits_null_not_glyph` (survive unchanged, fixtures omit `name` too); no `jr api` test exists to touch for #583 |
| Verification Properties | 0 new VP-NNN required (BC-level fixes, not new provable-property class) | Existing VP families (VP-580-xxx for BC-X.14, cross-cutting VPs for BC-X.7) extend via new example-based test cases at F4, not new VP definitions |

---

## Files Changed

### New Files

None. All three items modify existing files only.

### Modified Files

| File Path | Change Type | Risk |
|-----------|------------|------|
| `src/cli/mod.rs` | Interface change (2 non-overlapping enum variants: `UserCommand::List.project` type change #862; new `Command::Api.query_param` field #583) | LOW |
| `src/main.rs` | Internal logic (`Command::User` dispatch arm — pass `cli.project.as_deref()` through) | LOW |
| `src/cli/user.rs` | Interface change (`handle`/`handle_list` signatures gain `project_override: Option<&str>`, merge via `config.project_key`) | LOW |
| `src/cli/field.rs` | Internal logic (`normalize_from_allowed_values_at_depth` label fallback to `name`) — READ-SIDE ONLY, per D-378 | LOW |
| `src/types/jira/editmeta.rs` | Doc comment only (`AllowedValue.name` "unused in v1" claim corrected) | LOW |
| `src/cli/api.rs` | Internal logic + new pure function (query-param parsing, percent-encoding, merge-with-existing-`?` assembly); ALSO added to `.cargo/mutants.toml` `examine_globs` (audit finding, D-378) | LOW |
| `.factory/specs/prd/cross-cutting.md` | Spec amendment (BC-X.7.002 additive; BC-X.14.001/BC-X.14.003 text amendment, read-side only; new BC subsection for #583) | LOW (additive/corrective, no BC narrowed or removed) |
| `.cargo/mutants.toml` | Config change — add `src/cli/api.rs` and `src/cli/user.rs` to `examine_globs` (audit finding folded in at the F1 gate, D-378) | LOW |

### Dependent Files (unchanged but depend on modified files)

None identified. `config.project_key` (consumed, not modified, by #862's
fix) already has 4 other callers (`queue.rs`, `requesttype.rs`, `field.rs`,
`issue/create.rs`, `component.rs`) with no signature change to that
function — those callers are unaffected, not merely low-risk-affected.
`AllowedValue` (consumed by #861's fix) gains no new field and no signature
change — only a doc-comment edit and the read-side call site
(`normalize_from_allowed_values_at_depth`, `src/cli/field.rs`) reading an
already-existing field (`name`) it previously ignored.
`src/cli/issue/field_resolve.rs` is DEPENDENT-UNCHANGED for this cycle
(REMOVED from #861's modified-files list at the F1 gate, D-378 —
reachability of the originally-proposed write-side fallback was refuted;
see F1 Gate Outcome above). It remains referenced only as the location of
`dispatch_field_value`'s schema.field_type dispatch, which is what the
audit used to establish that the write-side path is unreachable for
system-typed fields.

---

## Files NOT Changed (Regression Baseline)

These files must not be modified during implementation. All their tests
must continue to pass after implementation.

- `src/api/jira/*.rs`, `src/api/jsm/*.rs`, `src/api/assets/*.rs` -- no wire-call shape changes anywhere in this cycle; all three items are client-side parsing/config/display fixes.
- `src/adf.rs`, `src/cache.rs`, `src/output.rs`, `src/duration.rs`, `src/jql.rs` -- unrelated subsystems, no dependency on any changed code.
- `src/cli/component.rs`, `src/cli/queue.rs`, `src/cli/requesttype.rs` -- referenced only as PRECEDENT for #862's merge pattern; not themselves modified.
- Every `src/cli/issue/*.rs` file, INCLUDING `field_resolve.rs` (REMOVED from #861's modified-files list at the F1 gate, D-378 — see F1 Gate Outcome above) -- in particular `create.rs`, `list.rs`, `edit.rs`, `workflow.rs`, `attachments.rs`, `jsm_create.rs`, `field_resolve.rs` are all out of scope for this cycle; Gate B (`edit.rs`), `CREATE_D2_GOVERNED_KEYS`, and `dispatch_field_value`'s schema.field_type dispatch (all in `field_resolve.rs`) are read-only referenced, not modified.
- `src/cli/issue/mod.rs`, `src/cli/mod.rs`'s other ~40 subcommand definitions besides the 2 touched enum variants -- unrelated command families.
- `.factory/specs/architecture/*` -- no architecture change; none of the three crosses a module or purity boundary.
- `Cargo.toml`/`Cargo.lock` -- no new dependency; `url`/`urlencoding` already present.

---

## Risk Assessment

| Risk Type | Level | Rationale |
|-----------|-------|-----------|
| Regression | LOW | Each item is additive or narrowly-scoped-fallback: #862 changes only the failure MECHANISM for the true no-project case (clap exit 2 -> app exit 64), not the failure fact, and the merge primitive (`config.project_key`) is already proven across 4 other command families; #861's fix is a pure `.or_else` fallback that only activates when the prior behavior was already broken (blank label) -- no existing correct-`value` case is touched; #583 is a net-new opt-in flag with zero effect when unused. All three verified against the actual existing test suite (see Regression Baseline below) with no required test edits. |
| Architecture | LOW | No module boundary change, no new file, no purity-boundary crossing (pure config-merge, pure display/matching fallback, pure query-string assembly -- all stay within existing effectful-shell command handlers). |
| Security | LOW | #583's query-param values go through the same percent-encoding discipline already used elsewhere (`url`/`urlencoding` crates); no new injection surface distinct from what `jr api`'s existing `-d`/`-H` flags already accept from the same trust boundary (the invoking user). No credential/auth-header interaction (the existing `Authorization`-header-rejection guard in `parse_header` is untouched and orthogonal to query params). |
| Performance | LOW | No new HTTP calls added by any of the three; #862 and #861 fixes are pure in-process logic; #583 adds one pure string-assembly step before an HTTP call that was always going to be made. |

---

## Regression Baseline

- **Tests directly verified for survival:** 3 (`tests/user_commands.rs::user_list_requires_project_flag`, `tests/field_options.rs::test_bc_x_14_003_degenerate_entry_table_glyphs`, `tests/field_options.rs::test_bc_x_14_003_degenerate_entry_json_emits_null_not_glyph`) -- all verified by direct text/fixture inspection to still pass after the proposed fix (F1 is analysis-only; no code was run or changed to confirm this beyond inspection, per task instructions).
- **Risk zone test files:** `tests/user_commands.rs` (user list family), `tests/field_options.rs` (read-side label-rendering family, the only #861 risk zone in scope for this cycle), `tests/cli_handler.rs` (`jr api` invocations) + `src/cli/api.rs`'s inline tests (path/header/body parsing). `src/cli/issue/field_resolve.rs`'s inline `mod tests` (18 tests) and `tests/issue_edit_field_adf.rs` / `tests/issue_field_hint_kinds.rs` / `tests/issue_create_field.rs` / `tests/issue_create_field_adf.rs` (option-field matching family) are NO LONGER risk-zone for this cycle — REMOVED along with the write-side item at the F1 gate (D-378); listed here only for completeness since they are still referenced as the audit's proof point (`test_bc_3_4_017_field_priority_without_flag_does_not_trigger_gate_b`).
- **No existing test requires modification.** New tests are additive at F4 (see per-item detail below).

---

## Scope Recommendation

- **Mode:** Feature Mode (already the active mode; bundle does not warrant escalation to Full Pipeline -- each item is small and the three are already scoped/bounded by this F1 pass).
- **Estimated new stories:** 3 (S-sized each) -- STORY-A (#862), STORY-B (#861, READ-SIDE ONLY per D-378), STORY-C (#583).
- **Estimated effort:** S / S / S per the prior 2026-09-10 triage's independent effort rating for #583 (S), consistent with this pass's file-count findings for #862 and #861 (each touches 2-3 files with no new HTTP call, no new dependency).
- **Can parallelize:** All three. They touch completely disjoint file sets except `src/cli/mod.rs`, which is touched by all three but at non-overlapping enum variants (`UserCommand::List`, `Command::Api`; #861 does not touch `mod.rs` at all) -- no merge-conflict risk in a single serialized wave, and genuinely schedulable as one parallel wave if throughput is preferred over serialization.

---

## Open Questions

**All RESOLVED at the F1 human gate, 2026-09-24 ("Approve, as corrected").**

1. **D-378 mint wording — RESOLVED.** Scope minted as: #862 (full) + #861
   READ-SIDE ONLY + #583 (full). No others.
2. **#861 write-side scope — RESOLVED: REMOVED from scope, not deferred as
   a follow-up story.** A fresh-context audit REFUTED the write-side
   `find_option_match`/`resolve_option_value` name-fallback fix's
   reachability: `dispatch_field_value` (`src/cli/issue/field_resolve.rs`)
   matches on `meta_field.schema.field_type` and only reaches
   `resolve_option_value`/`find_option_match` for `"option"`
   (`"option-with-child"` for the hinted `:option` composer's entry gate,
   EC-3.4.027-1). Real Jira system fields report `schema.type`
   `priority`/`resolution`/`issuetype`/`securitylevel`, so `--field
   Priority=High` fails earlier via `unsupported_field_type_error` and
   never reaches value-only matching — corroborated by
   `tests/issue_edit_field.rs::test_bc_3_4_017_field_priority_without_flag_does_not_trigger_gate_b`
   (mocks priority as a custom `"string"` field). The genuinely separate
   capability gap this surfaced ("`--field` cannot set system-typed
   fields") is recorded as a Deferred / Follow-up item, suggested ID
   `FIELD-SYSTEM-TYPES-UNSUPPORTED` (LOW), not folded into #861.
3. **#861 output-shape caution — RESOLVED: accepted without change.**
   `field options --output json`'s `label` key for a system field changing
   from `null` to a real string is treated as a bug fix, not a breaking
   change.
4. **#583 nature vs. bundling — RESOLVED: confirmed YES**, #583 stays
   bundled in this bug-fix-intent cycle.
5. **#583 BC filing — RESOLVED: confirmed**, deferred to F2 as a
   cross-cutting subsection, per BC-X.14's own precedent.
6. **#583 design defaults — RESOLVED: confirmed**, all four recommended
   defaults accepted (merge-with-existing-`?`, allow-repeated-same-name,
   encode-raw-once, method-orthogonal).
7. **Story split — RESOLVED: confirmed 3 stories (A/B/C),
   parallel-wave-eligible.** STORY-B (#861) is now read-side only per item
   2 above.
8. **`user_list_requires_project_flag` test name — RESOLVED: no rename.**
   Acknowledged as accurate-but-under-describing; left as-is per the
   "don't rename existing tests for style alone" convention.

---

## Appendix: Per-Item Detail

### Item #862 -- `jr user list` ignores `--project`

**Impact boundary detail:**

| Layer | Component | Change type |
|---|---|---|
| CLI surface | `src/cli/mod.rs::UserCommand::List` | MODIFIED -- `project: String` becomes `project: Option<String>` |
| Dispatch | `src/main.rs` (`Command::User` arm) | MODIFIED -- pass `cli.project.as_deref()` through, matching every other `Command` variant that has a same-id local `--project` field |
| Handler | `src/cli/user.rs::handle` + `handle_list` | MODIFIED -- accept a `project_override: Option<&str>`, merge via `config.project_key(project_override)` (the same merge primitive `queue.rs`/`requesttype.rs` already use), exit 64 `JrError::UserError` if unresolved (no HTTP) |
| Spec | `.factory/specs/prd/cross-cutting.md` BC-X.7.002 | AMENDED (additive) -- document local flag -> global flag -> `.jr.toml`/profile default -> exit 64 resolution order |
| Architecture | none | DEPENDENT only -- no module boundary change, no new file, no purity-boundary impact |

**Verified root cause and precedent:**

- `src/cli/mod.rs` line ~1148: `UserCommand::List { project: String, ... }` is the ONLY subcommand-local `project` field in the entire CLI surface that is `String` (required) rather than `Option<String>`. Every other same-id local `--project` field (`IssueCommand::Create` @419, `FieldCommand::Options` @1253, `ComponentSubcommand::{List,Create,Edit,Delete,Rename}` @1290/1304/1328/1358/1405) is `Option<String>`.
- `src/main.rs`'s `Command::User { command }` dispatch arm calls `cli::user::handle(command, &cli.output, &client).await` -- the only project-bearing `Command` arm that does NOT also pass `cli.project.as_deref()` (`Queue`, `RequestType`, `Field`, `Component`, `Project`, `Issue`, `Board`, `Sprint` all receive it).
- Confirmed a complete sweep of every subcommand-local `project`/`project_type` field in `src/cli/mod.rs`: `UserCommand::List` is the sole shadowing-bug instance. Every other instance already implements the correct merge -- `component.rs::handle`: `project.as_deref().or(project_flag)` (List) / `project.or_else(|| project_flag.map(str::to_string))` (Create), F5-A-L2 precedent; `field.rs::handle`: `let cli_project = project.as_deref().or(project_override);`, ADR-0019's companion-flag pattern; `queue.rs`/`requesttype.rs`: no local field at all, call `config.project_key(project_override)` directly; `issue/create.rs::handle_create`: `.or_else(|| config.project_key(project_override))`.
- No other in-scope candidates found. This closes the task's "sweep ALL other subcommands" requirement -- the bug is isolated to `user list`.

**Tests pinning current behavior:**

- `tests/user_commands.rs::user_list_requires_project_flag` (line ~123) asserts `jr --no-input user list` (no `--project`) fails and stderr contains `"--project"` or `"required"`. Today this fires via clap's own missing-required-arg message (exit 2).
- Survival analysis: after the fix, the same invocation (no `--project` anywhere, no config default, isolated test env with no `.jr.toml`) still fails -- but now via `config.project_key(None)` returning `None`, producing `JrError::UserError("No project configured. Run \"jr init\" or pass --project. ...")` (exit 64, mirroring `queue.rs`/`requesttype.rs`'s existing wording). This message contains the substring `"--project"`, so the test's assertion still passes -- confirmed by direct text inspection (F1 is analysis-only, no `src/` change made). Per "Default to fixing code, not tests," no test edit is strictly required, though the test's name becomes slightly imprecise -- flagged as Open Question 8, not a defect.
- `tests/user_commands.rs::user_list_by_project_returns_users` (line ~142) exercises `--project FOO` explicitly -- unaffected.
- New tests needed (F4): `jr --project FOO user list` (global flag alone) succeeds; `.jr.toml`/profile-default project resolves `user list` with no flag at all -- both currently untested and currently broken.

**Regression risk: LOW** -- single file family, no wire/API shape change, merge primitive already proven across 4 other command families.

### Item #861 -- `jr field options` system-field `(unnamed)` labels (READ-SIDE ONLY, per D-378)

**Impact boundary detail:**

| Layer | Component | Change type |
|---|---|---|
| Read side (M1/M2) | `src/cli/field.rs::normalize_from_allowed_values_at_depth` | MODIFIED -- `label` now falls back from `v.value` to `v.name` when `value` is absent |
| Types | `src/types/jira/editmeta.rs::AllowedValue.name` doc comment | MODIFIED -- remove/correct the stale "unused in v1" claim |
| Write side (M1 editmeta option-field resolution) | `src/cli/issue/field_resolve.rs::find_option_match` / `resolve_option_value` | **REMOVED FROM SCOPE at the F1 gate (D-378).** Originally proposed as a symmetric fallback; a fresh-context audit REFUTED its reachability (see F1 Gate Outcome above and Open Question 2). `field_resolve.rs` is DEPENDENT-UNCHANGED for this cycle, not modified. |
| Not affected | M3 (JSM request-type fields) -- `normalize_from_valid_values_at_depth` (`field.rs`) | UNCHANGED -- already correctly reads `.value` for id and `.label` for display; confirmed by direct inspection |
| Spec | `.factory/specs/prd/cross-cutting.md` BC-X.14.001 / BC-X.14.003 | AMENDED -- label-resolution rule (value, else name), READ-SIDE ONLY; `AllowedValue.name` no longer "reserved for v2" |

**Verified root cause:**

- `AllowedValue` (`src/types/jira/editmeta.rs` line ~79-96) has both `value: Option<String>` and `name: Option<String>`, with `name`'s doc comment claiming it is "unused in v1 resolution logic... Future: v2." Now demonstrably stale.
- Externally grounded (HIGH confidence, `.factory/research/github-issues-triage-grounding-2026-09-24.md` §#861): `priority`, `resolution`, `versions`/`fixVersions`, `components`, `security`, `issuetype` allowedValues entries carry `name` as the display label; only custom select/radio/checkbox/multiselect options carry `value`. An enumerator reading only `value` renders blanks (`UNNAMED_LABEL`, `"(unnamed)"`) for every system field.
- `normalize_from_allowed_values_at_depth` (`field.rs` line ~638-654) maps `label: v.value.clone()` -- the exact, sole culprit for M1 (`--issue`) and M2 (`--type`) read paths.
- M3 (`normalize_from_valid_values_at_depth`, `field.rs` line ~677-699) already reads `v.get("label")` for display and `v.get("value")` for the submission id -- already correct, no change needed; confirms the task's instruction to check the M3 JSM path resolves to "M3 is fine."
- **Write-side item REMOVED at the F1 gate (D-378), reachability REFUTED.** The originally-proposed companion fix to `find_option_match` (`field_resolve.rs` line ~1108-1220) — falling back to `av.name` wherever `av.value` is consulted — was found, on fresh-context audit, to be unreachable for system fields: `dispatch_field_value` matches on `meta_field.schema.field_type` and only routes to `resolve_option_value`/`find_option_match` when `schema.field_type` is `"option"` (or `"option-with-child"` for the hinted `:option` composer's EC-3.4.027-1 entry gate). Real Jira system fields (`priority`, `issuetype`, `resolution`, `security`) report `schema.type` values of `priority`/`resolution`/`issuetype`/`securitylevel` — none of which is `"option"` — so `jr issue edit ISSUE-1 --field Priority=High` fails earlier via `unsupported_field_type_error` and never reaches `find_option_match` at all. The originally-cited "Gate B only blocks the collision case, not `--field` alone" observation is true but does not establish reachability, since the type-dispatch gate upstream of Gate B already rejects the call. Corroborated by `tests/issue_edit_field.rs::test_bc_3_4_017_field_priority_without_flag_does_not_trigger_gate_b`, which mocks priority as a custom `"string"` field (not `"priority"`) specifically because a real `"priority"`-typed field never reaches that code path. This is a real capability gap (the bare, un-hinted `--field NAME=VALUE` form cannot set system-typed fields; the `:id`/`:name` hinted-bypass composers, BC-3.4.028/029, already can) but a DIFFERENT one from #861's read-side display defect — tracked separately, see Deferred / Follow-up.

**Tests pinning current behavior:**

- `tests/field_options.rs::test_bc_x_14_003_degenerate_entry_table_glyphs` (line ~1738) and `..._json_emits_null_not_glyph` (line ~1780): both fixtures use JSON objects that omit the `name` key entirely (e.g. `{"id": "10002", "value": null}`), which serde's derive maps to `None` for a missing `Option<String>` field. Verified: these tests are UNAFFECTED by the fix -- the `name`-fallback only activates when `name` is present; these fixtures have `name: None` too, so `(unnamed)`/`NULL_GLYPH` output is unchanged.
- No existing test exercises a `name`-only, `value`-absent fixture (a realistic `priority`/`issuetype` shape) -- precisely the gap #861 reports. New tests needed (F4): M1/M2 fixture with `{"id": "1", "name": "Highest"}` (no `value`) -> label renders `"Highest"`, not `"(unnamed)"`.
- **Write-side test note (REMOVED from #861's scope at the F1 gate, D-378, reachability refuted).** `src/cli/issue/field_resolve.rs`'s inline `mod tests` (18 tests) plus `tests/issue_edit_field_adf.rs` / `tests/issue_field_hint_kinds.rs` / `tests/issue_create_field.rs` / `tests/issue_create_field_adf.rs` cover option-field matching but do not surface a name-only, value-absent fixture — this is no longer a gap `find_option_match` needs to close under #861, since `--field Priority=High` never reaches `find_option_match` for a real `"priority"`-typed field (it fails earlier via `unsupported_field_type_error`). No test is needed here for #861. The DIFFERENT capability-gap fix ("`--field` cannot set system-typed fields") is out of scope for this cycle — see Deferred / Follow-up.

**Regression risk: LOW** -- additive `.or_else` fallback on the read side only (write side removed from scope, D-378); any fixture that already sets `value` is unaffected (value still wins when both present); only previously-broken cases change.

### Item #583 -- `jr api --query-param NAME=VALUE`

**Impact boundary detail:**

| Layer | Component | Change type |
|---|---|---|
| CLI surface | `src/cli/mod.rs::Command::Api` | MODIFIED -- add a repeatable `--query-param`/`-q` `NAME=VALUE` arg |
| Logic | `src/cli/api.rs::handle_api` + a new pure function | MODIFIED/NEW -- parse `NAME=VALUE` pairs, percent-encode raw values once (never double-encode), assemble onto the normalized path, merging with any `?` already present |
| Spec | none exists today | NEW BC -- no `jr api` BC file exists; nearest analogs are the scattered `BC-X.1.007`/`BC-X.1.011` cross-cutting entries. F2 decides new cross-cutting subsection vs. dedicated file; recommended default is a new subsection (e.g. `BC-X.16`), mirroring BC-X.14's own precedent |
| Dependencies | none new | `url = "2"` and `urlencoding = "2"` are already direct dependencies (`Cargo.toml` lines 55-56) |

**Verified root cause and design questions (from grounding + prior triage):**

- `src/cli/api.rs::normalize_path` (line ~40) passes the path through verbatim; there is no query-string assembly or percent-encoding anywhere in `api.rs`. Confirmed absent -- matches both the issue and the prior 2026-09-10 triage (`.factory/phase-f1-delta-analysis/issue-triage-enhancement-cluster-2026-09-10.md` §#583, independently rated MED value / S effort / weak coupling).
- External grounding (HIGH confidence for flag semantics, MEDIUM for exact encoding rules): established prior art (`gh api -f/-F`, HTTPie `==`, `glab api`, `curl -G --data-urlencode`) universally has the client percent-encode raw user-supplied values; users must not pre-encode (avoids double-encoding `%` to `%25`). A dedicated `--query-param k=v` (HTTPie-style) is recommended over gh's `-f/-F` + implicit-POST-switch model, since `jr api` already has an explicit `-X`/`--method` flag.
- Design questions to resolve at F2, with recommendations: (1) path already contains `?` -> MERGE, append after existing query string; (2) repeated same-name params -> ALLOW, multiple `key=value` pairs; (3) encoding -> encode the raw user value once via `url`/`urlencoding`, never re-encode a pre-encoded value; (4) non-GET methods -> query params compose identically regardless of method, orthogonal to `-d`/body.

**Tests pinning current behavior:**

- `tests/cli_handler.rs` (multiple `["api", ...]` invocations) and `src/cli/api.rs`'s own inline tests (path normalization, header parsing, body resolution) -- no query-param tests exist, confirming the gap. No existing test needs to change. New tests needed (F4): repeatable `--query-param`, merge-with-existing-`?`, repeated-same-name, encoding of reserved characters, interaction with every `-X` method value.

**Regression risk: LOW** -- purely additive CLI surface, zero effect when unused, no dependency additions.

### Cross-Cutting Observations

- The three items touch completely disjoint file sets except `src/cli/mod.rs`, which is touched by #862 and #583 at non-overlapping enum variants (`UserCommand::List`, `Command::Api`) -- no merge-conflict risk, parallelizable.
- CHANGELOG impact: all three are non-breaking. #862 relaxes a requirement (was hard-required flag, becomes flag-OR-global-OR-config). #861 only fixes previously-blank output (see Open Question 3 for the JSON `label` null-to-string nuance). #583 is a net-new opt-in flag.
- **Audit finding folded in (F1 gate, D-378):** `src/cli/api.rs` and `src/cli/user.rs` are added to this cycle's planned `.cargo/mutants.toml` `examine_globs` additions, in scope for F6 targeted `cargo mutants --in-diff` hardening. `.cargo/mutants.toml` is listed in Modified Files above.

---

## Deferred / Follow-up

- **`FIELD-SYSTEM-TYPES-UNSUPPORTED` (suggested ID, LOW priority, final ID
  assigned by state-manager)** -- "`--field` cannot set system-typed
  fields (priority/resolution/issuetype/securitylevel → unsupported field
  type error)." Surfaced by this F1 pass's fresh-context audit of the
  originally-proposed #861 write-side fix: `dispatch_field_value`
  (`src/cli/issue/field_resolve.rs`) routes to option-matching logic only
  for `schema.field_type == "option"` (or `"option-with-child"`), so
  `jr issue edit ISSUE-1 --field Priority=High` (or any other
  system-typed field bare-form `--field` use) fails earlier via
  `unsupported_field_type_error` and never reaches `find_option_match`.
  This is a genuine capability gap, but a DIFFERENT one from #861's
  read-side display-label defect (#861 concerns the RENDERING of a
  system field's existing option values; this concerns the INABILITY to
  submit a system field via `--field` at all). **Explicitly NOT in scope
  for cycle-014** (D-378, human gate, 2026-09-24). No spec, story, or
  implementation work for this item happens under cycle-014.
