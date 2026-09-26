---
context: bc-x
title: "Cross-cutting (HTTP client, Runtime, Users, Teams, Worklogs, Projects, Queues, JQL, Partial-match, JSM Request Types, CI Guards, Field Option Discovery, API Query Parameters)"
total_bcs: 162   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings; +2 added 2026-09-25 (BC-X.16.001..002, cycle-014 `issue-triage-quickfixes` F2 spec evolution, issue #583 — new `## BC-X.16: API Query Parameters` subsection: `jr api --query-param NAME=VALUE` percent-encoded query-string composition + malformed-value error taxonomy; same-burst amendments to BC-X.7.002 (issue #862, project-resolution order) and BC-X.14.001/003 (issue #861, M1/M2 label-resolution fallback, READ-SIDE ONLY per D-378) are COUNT-NEUTRAL; BC-X.14.004 gains one documentation-only cross-reference row (empty `<field>`), COUNT-NEUTRAL; the §BC-X.14 intro is reworded (count-neutral)); was 160 before this addition; prior: +1 added 2026-09-17 (BC-X.15.001, cycle-008 `oauth-surface-correctness` F2 spec evolution, ADR-0026 Decision 3, VP-OAUTH-GW-003 — new `## BC-X.15: OAuth Agile-Command Error-Mapping` subsection: `jr board`/`jr sprint` 401 auth-scheme-conditional call-site rewrite disambiguating scope-mismatch vs. expired-token vs. (regression-guard) wrong-host, modeled on `require_service_desk`/BC-X.8.006..007); was 159 before this addition; prior: +4 added 2026-09-06 (BC-X.7.007..010, cycle-005 `adf-mentions` F2 spec evolution, issue #674 — `@Name` mention resolution: unique-match (007), ambiguous-match disambiguation (008), zero-match HARD ERROR exit 64 (009, human-approved override of the architect's pass-through recommendation); bracket-form accountId mandatory preflight validation (010)); was 155 before that addition
definitional_count: 96   # count of `#### BC-` headings in this file
last_updated: 2026-09-25
source_pass: 3
trace: |
  - cycle-014 `issue-triage-quickfixes` F2 (spec 2.4.0, 2026-09-25): amended BC-X.7.002 (#862
    `user list --project` resolution: `List.project` becomes `Option<String>`; clap global
    propagation plus `Config::project_key` fallback; `&Config` threaded from `main.rs`; pure
    `resolve_user_list_project`), amended BC-X.14.001/003 (#861 M1/M2 label value→name fallback,
    read-side only; BC-X.14.001's field-name resolution text corrected from `partial_match`/
    BC-X.10.001 to `search_field_list` — aligns spec with existing code/tests; no behavior
    change; Invariant 3 corrected: `src/cli/field.rs`'s customfield bypass and cache-first name
    resolution is a mirrored copy of `src/cli/issue/field_resolve.rs::resolve_edit_fields`'s
    Step 1 (customfield bypass) and Step 2 (cache-first load/fetch plus its nested
    `search_field`), not a shared function — they share only
    `read_fields_cache`/`write_fields_cache`/`list_fields`, and a change to one must be mirrored
    in the other; aligns spec with existing code; no behavior change), new BC-X.16 subsection
    BC-X.16.001/002 (#583 `jr api --query-param`). BC-X.14.004
    gains one cross-reference row in its error-taxonomy table (the pre-existing empty-`<field>`
    guard, citing BC-X.14.001 EC-X.14.001-15) — documentation-only, contract unchanged,
    COUNT-NEUTRAL. §BC-X.14 intro also reworded — broadened from "a custom select field's" to
    "a field's" allowed options (custom select fields and system fields) and a duplicated
    trailing "(cycle-014, #861)" citation dropped — wording-only, COUNT-NEUTRAL.
    Revision history: `.factory/cycles/cycle-014/phase-f2-spec-evolution/prd-delta.md`.
  - cycle-008 `oauth-surface-correctness` wave-level finding F-WG-1 (human-approved scope amendment,
    ruling = EXPAND, 2026-09-17, product-owner burst): BC-X.15.001 Behavior clause 1's call-site →
    hint mapping WIDENED beyond the original ADR-0026 Decision 3 `jr board`/`jr sprint` boundary
    (and beyond the same-day F1 internal-helper widening, above) to also cover the SAME Agile HTTP
    calls made by two other command families that were not audited by the original cycle-008 F1
    delta analysis: `jr issue list`'s board-resolution/board-based-JQL path
    (`src/cli/issue/list.rs::handle_list` → `client.get_board_config(bid)` then, on a scrum board,
    `client.list_sprints(bid, Some("active"))`) and `jr init`'s per-project board-selection prompt
    (`src/cli/init.rs::handle` → `client.list_boards(None, None)`). Mechanical mapping (same
    endpoint → same hint as the existing `board.rs`/`sprint.rs` sites, per `oauth-scope-matrix.md`
    #52/#53/#55-57 — no new scope strings, no new detection rule, reuses the same shared
    scope-mismatch-substring-under-OAuth rewrite this BC already specifies):
    - `src/cli/issue/list.rs::handle_list` → `get_board_config` → `read:board-scope.admin:jira-software`
      and `read:project:jira` (same hint as `jr board view`/`resolve_scrum_board`, matrix #53)
    - `src/cli/issue/list.rs::handle_list` → `list_sprints` → `read:sprint:jira-software` +
      `read:issue-details:jira` + `read:jql:jira` (same grouped hint as `jr sprint list`/`current`,
      per EC-X.15.001-4's "reuse the grouped hint at every `list_sprints` call site" ruling, matrix
      #55, over-inclusive-by-design since `handle_list` alone would only strictly need
      `read:sprint:jira-software`)
    - `src/cli/init.rs::handle` → `list_boards` → `read:board-scope:jira-software` and
      `read:project:jira` (same hint as `jr board list`/`resolve_board_id`, matrix #52)
    NO new BC minted, NO BC id change, NO count change (still 94 individually-bodied / 160
    cumulative in this file) — this is a further call-site coverage widening of the
    already-approved BC-X.15.001, layered on top of the same-day F1 internal-helper widening
    below, not a new contract. VP-OAUTH-GW-003's minimum new-test-case count raised 8→11 (+3, one
    per newly-covered call site — scope-mismatch class only; the expired-token fall-through and
    Basic-auth short-circuit classes are already proven generically by AC-002/AC-004's sibling
    coverage and are not re-derived per call site). Story
    `S-cycle8-agile-scope-mismatch-error-mapping` (`phase-f3-stories/`) updated in the same burst
    with new ACs (AC-013..AC-015) and a version bump; File Structure gains `src/cli/issue/list.rs`
    and `src/cli/init.rs` as modified files. Companion note added to ADR-0026 Decision 3
    documenting the extended call-site-rewrite coverage.
  - cycle-008 `oauth-surface-correctness` adversary finding F1 (MEDIUM, spec/code drift) fix
    (2026-09-17, product-owner burst): BC-X.15.001's `get_board_config` scope hint references
    corrected from `read:board-scope.admin:jira-software` (alone) to
    `read:board-scope.admin:jira-software` and `read:project:jira`, at all 4 remaining locations
    that still named only the single scope — Behavior clause 1's `board.rs::handle_view` bullet,
    Behavior clause 1's `sprint.rs::resolve_scrum_board` bullet, and the two corresponding
    Canonical Test Vectors rows (`jr board view` / `jr sprint list`/`current`/`add`/`remove`).
    Root cause: the F-WAVE-4 code+test fix widened the emitted hint to require both scopes per
    `oauth-scope-matrix.md` #53 (GET /board/{id}/configuration requires
    `read:board-scope.admin:jira-software` + `read:project:jira`), but this file's `get_board_config`
    references were missed in that burst — leaving the BC internally inconsistent with its own
    `list_boards` bullets (which already correctly carried `+ read:project:jira`, matrix #52). NO
    BC id change, NO AC/count change (still 94 individually-bodied / 160 cumulative in this file) —
    wording-accuracy correction only, restoring consistency with `oauth-scope-matrix.md` #52/#53.
  - cycle-008 `oauth-surface-correctness` adversary finding OBS-1 (LOW, spec-prose accuracy) fix
    (2026-09-17, product-owner burst, same day as the F1/F2 entries below): BC-X.15.001 Behavior
    clause 4 reworded — the prior wording said a Basic-auth 401 "continues to surface via the
    universal BC-X.3.002 (`Not authenticated` + `jr auth login`, exit 2) path" unconditionally,
    which is inaccurate for the scope-mismatch sub-case: `client.rs::send_inner`'s pre-refresh
    scope check is auth-scheme-agnostic and runs BEFORE the auth-scheme guard, so a Basic-auth 401
    body containing a scope-mismatch substring surfaces the generic `InsufficientScope` (issue
    #185) template, not the BC-X.3.002 path. Clause 4 now distinguishes the two Basic-auth
    sub-cases explicitly. This is a PRE-EXISTING, AC-007-frozen `client.rs` behavior (not
    introduced by this story) and was already correctly asserted by AC-004's test — only the
    narrative sentence was self-inconsistent with its own test column. NO BC id change, NO AC
    change, NO test change, NO count change (still 94 individually-bodied / 160 cumulative in this
    file). Companion correction applied to
    `.factory/cycles/cycle-008/phase-f3-stories/S-cycle8-agile-scope-mismatch-error-mapping.md`
    AC-004 narrative in the same burst.
  - cycle-008 `oauth-surface-correctness` F1 human-approved scope-widening ruling (2026-09-17, same
    day as the F2 evolution below, product-owner burst): BC-X.15.001 Behavior clause 1 CLARIFIED/
    WIDENED in place — call-site coverage now explicitly names 8 call sites (the originally-named 4
    top-level command handlers PLUS 4 internal board/sprint resolution helpers: `board.rs`'s
    `resolve_board_id` → `list_boards`; `sprint.rs`'s `resolve_scrum_board` → `get_board_config`;
    `board.rs::handle_view`'s unconditional `get_board_config` call across both branches;
    `sprint.rs`'s `SprintCommand::Add { current: true, .. }` → `list_sprints` lookup), all reusing
    the shared `rewrite_agile_scope_error` helper. New EC-X.15.001-4 records the F4 ruling: KEEP
    `jr sprint list`'s grouped (over-inclusive) hint as spec-conformant, and reuse the same grouped
    hint at the new `list_sprints`-calling internal sites for consistency, since over-inclusion is
    benign. Also fixes a stale `jr board view --config` label (no such flag exists — `handle_view`
    calls `get_board_config` unconditionally) to `jr board view` throughout. Canonical Test Vectors
    and VP-OAUTH-GW-003's description widened to match (minimum test count 4→8). NO new BC minted,
    NO BC id change, NO count change (still 94 individually-bodied / 160 cumulative in this file) —
    this is a coverage clarification of the already-approved BC-X.15.001, not a new contract. Story
    `S-cycle8-agile-scope-mismatch-error-mapping` (phase-f3-stories/) updated in the same burst with
    matching new ACs (AC-009..AC-012) and File Structure additions.
  - cycle-008 `oauth-surface-correctness` F2 spec evolution (2026-09-17), ADR-0026 Decision 3, VP-OAUTH-GW-003: new subsection `## BC-X.15: OAuth Agile-Command Error-Mapping` added with 1 new BC (BC-X.15.001) — `jr board`/`jr sprint` 401 disambiguates (i) OAuth scope-mismatch (auth-scheme-conditional granular-scope hint) from (ii) expired/invalid token (routes to the existing auto-refresh coordinator, never surfaces `InsufficientScope`) from (iii) wrong-host-401 (regression-guard only — no longer reachable post-ADR-0026 for the 7 routing call sites BC-4.2.001 anchors). New call-site rewrite in `src/cli/board.rs`/`src/cli/sprint.rs`, modeled on the proven `require_service_desk` pattern (BC-X.8.006/BC-X.8.007) — does NOT modify `src/error.rs`'s shared `InsufficientScope` Display template (BC-1.6.042-045 unchanged) and does NOT alter BC-3.8.015's JSM-create POST path (regression-guarded). Cross-reference note added to BC-5.1.001 (`bc-5-boards-sprints.md`) clarifying its existing routing-correct GET currently 401s under OAuth for a SCOPE reason (fixed by BC-1.3.023's ADR-0026 Decision 2 amendment), not a routing reason. definitional_count 93→94; total_bcs 159→160.
  - cycle-005 `adf-mentions` F2 pass-4 INTEGRATE sub-burst (2026-09-06, issue #674, human-approved TIGHTENING decision at the F2 gate; mechanism finalized by the architect as Option (a)): BC-X.7.007 amended in place — inserts `filter_by_name_match` (NEW pure pre-filter, `src/cli/issue/mentions.rs`) BETWEEN the `active==Some(true)` filter and the `disambiguate_user` call; `disambiguate_user` itself is UNCHANGED. A single search result whose display name does NOT case-insensitively-substring-match the query is now filtered OUT before `disambiguate_user` runs, producing an EMPTY list and the same zero-match hard-error path as BC-X.7.009 (was previously a silent resolve via `disambiguate_user`'s `len()==1` short-circuit — EC-X.7.007-5's former OPEN DECISION). EC-X.7.007-5 rewritten from "OPEN DECISION" to RESOLVED; EC-X.7.007-2 scope narrowed to reflect the guaranteed name-match on the lone-result path. New VP-674-021 citation. No BC count change (still 93 individually-bodied / 159 cumulative in this file). See `.factory/specs/prd/holdout-scenarios.md` H-NEW-MENTION-012 (new) and H-NEW-MENTION-002 (fixture updated to a name-matching query, since `query=jsmith` → sole result "John Smith" now hard-errors under the tightened contract).
  - cycle-005 `adf-mentions` F2 spec evolution INTEGRATE sub-burst (2026-09-06, issue #674): +4 BCs BC-X.7.007..010 added to §X.7 Users — `@Name` mention candidate resolution (unique-match BC-X.7.007, reuses `disambiguate_user`'s `Exact` arm; ambiguous-match BC-X.7.008, reuses `ExactMultiple`/`Ambiguous` arms verbatim; zero-match BC-X.7.009, HARD ERROR exit 64 — human-approved decision superseding the architect's own pass-through recommendation from `delta-analysis.md` OQ-4) and bracket-form `[~accountid:<id>]` mandatory accountId preflight validation (BC-X.7.010, `GET /rest/api/3/user?accountId=`, deduplicated per unique id). BC count 155→159 (definitional_count 89→93). See `.factory/phase-f2-spec-evolution/prd-delta-674.md`, `.factory/phase-f2-spec-evolution/verification-delta-674.md`.
  - F2 adversary-convergence round-3 amendments (2026-08-26, cycle field-dx — no BC
    added/removed/retired, no count change, still 89 individually-bodied / 155 cumulative in this
    file): fix round following a fresh 3-pass adversarial streak that found a HIGH contradiction,
    3 MEDIUMs, and several LOWs. F-MED-2 (MEDIUM): BC-X.14.001 H1 corrected from `--type <T>
    --project <P>` (unbracketed) to `--type <T> [--project <P>]` (bracketed), mirroring M3 and
    matching D1's flag-OR-default parity decision; BC-INDEX title-row propagation flagged for
    state-manager. F-B (architect-decided, propagated): `FieldOption.id`/`.label` changed
    `String` → `Option<String>` per ADR-0019 § Amendment F-B; new EC-X.14.001-7 never-drop
    invariant; BC-X.14.003 gains a degenerate-entry rendering contract (`NULL_GLYPH`/`"—"` for
    missing id, `"(unnamed)"` for missing label, JSON `null` with no substitution); VP-580-005
    and VP-580-008 flagged/strengthened for the verifier. F-LOW-1 (LOW): BC-X.14.004's
    incomplete-M2 message widened from "--type requires --project" to "--type needs a resolvable
    project — pass --project <P> or configure a default". O-3 (LOW): new createmeta/enumeration
    400 taxonomy row + EC-X.14.004-7 (issue type rejected by `get_createmeta_fields` after both
    earlier resolution calls already succeeded). Full rationale and the companion
    `bc-3-issue-write.md` fixes (F-A, F-MED-1, F-C, F-LOW-4, O-1, O-2):
    `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md` "2026-08-26 F2 adversary-convergence
    round-3 amendments" section.
  - F2 adversary-convergence round-2 amendments (2026-08-26, cycle field-dx — no BC
    added/removed/retired, no count change, still 89 individually-bodied / 155 cumulative in this
    file): fix round following a fresh 3-pass adversarial streak that found residual partial-fix/
    coverage gaps, none requiring a new design decision. Pass2-F2 (MEDIUM): BC-X.14.004's error
    taxonomy gains a new `--project not found (404)` row, distinct from the existing "no
    resolvable project" (companion-absent, pre-HTTP arity failure) and "non-JSM project" (project
    resolves, wrong type) rows — `jr field options` performs no client-side project-existence
    pre-check on either the M2 (`get_issue_types_for_project`/`get_createmeta_fields`) or M3
    (`get_or_fetch_project_meta`) path, so a nonexistent `--project` is a genuine, previously-
    undocumented HTTP 404 outcome; new EC-X.14.004-6 added. Whether this new row warrants its own
    dedicated VP (beyond the general per-row coverage VP-580-004 already asserts) is flagged open
    for the verifier, not resolved here. **[RESOLVED round-3, F2 adversary-convergence round-5,
    LOW-2]** This was resolved round-3: VP-580-012 minted (see below, `--project` not found (404)
    on the M2/M3 paths dedicated coverage) — no longer open. Pass2-F6 (MEDIUM, this file's 1 of 3 sites): the dangling
    `.factory/specs/verification-delta/` directory citation (never existed) replaced with the
    actual verifier artifact path `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md`
    — the other two sites are in `bc-3-issue-write.md`. Full rationale and bc-3-issue-write.md's
    companion Pass2-F1/F3/F4/F5 fixes:
    `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md` "2026-08-26 F2 adversary-convergence
    round-2 amendments" section.
  - F2 adversary-convergence amendments (2026-08-26, cycle field-dx, D1 + A-M2/B-F1/A-LOW-2 + LOWs
    — no BC added/removed/retired, no count change, still 89 individually-bodied / 155 cumulative
    in this file): propagates the architect's D1 decision (ADR-0019 § Amendment 2026-08-26) into
    BC-X.14.001 and fixes pure-spec-text defects the F2 adversary-convergence loop surfaced. **D1**
    (M2 default-project resolution parity): the "§BC-X.14 context-mechanism decision" section
    intro, BC-X.14.001's Preconditions/Invariant 1/VP-580-006/Trace, and BC-X.14.004's error-
    taxonomy row + precedence paragraph are all rewritten so the pure mode-selector arity check is
    a 3-boolean function (`has_type`/`has_request_type`/`has_issue` only — `has_project` removed
    entirely) and a NEW sibling paragraph ("M2 project resolution step") documents the separate,
    post-arity `resolve_m2_project` step that resolves M2's project as flag-OR-profile-default,
    restoring parity with BC-3.3.010/M3. **A-M2**: BC-X.14.002's bare-invocation example corrected
    to include a mode selector (`--issue FOO-1`), clarifying "bare" means absence of `--value`, not
    absence of a context flag. **B-F1**: BC-X.14.001's Postconditions M3-pagination claim corrected
    — `get_request_type_fields` is a single non-paginated GET (flat `RequestTypeFieldsResponse`
    envelope, no `isLastPage`), not a reuse of `list_request_types`'s pagination as previously
    claimed; the M2 createmeta/issuetypes pagination claims (both correct) are unchanged.
    **A-LOW-2**: the `--issue <KEY>` Precondition parenthetical reworded from "(no `--project`
    companion)" to "(`--project` not consulted)" for consistency with VP-580-006. **B-LOW
    (`--value`)**: BC-X.14.002 gains `--value ""` identity-filter documentation and a
    graceful-degrade interaction note (degrade hint still fires with `--value` present). **B-LOW
    (M3 reverse name-resolution)**: BC-X.14.001 gains EC-X.14.001-6, the reverse of EC-X.14.001-5
    — a field enumerable via M3's `validValues` but not name-resolvable via the global field list.
    Full rationale, D2/D3's `bc-3-issue-write.md` counterparts, and C-M1's DEC renumber:
    `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md` "2026-08-26 F2 adversary-convergence
    amendments" section.
  - Adversary pass-28 fix, F-1 (2026-08-25, issue #580, MEDIUM): BC-X.14.001's Postconditions
    bullet claimed "exactly one of the three enumeration HTTP calls (createmeta /
    requesttype-fields / editmeta) fires" — this contradicted ADR-0019 §1, which specifies the M2
    (createmeta, `get_createmeta_fields`) mechanism is OFFSET-PAGINATED
    (`startAt`/`maxResults`/`total`), and overlooked that M3 (requesttype-fields) already reuses
    `jr requesttype fields`'s own existing pagination. Reworded to "exactly one enumeration
    MECHANISM fires" — one logical enumeration, which may issue multiple HTTP page-fetches for M2
    or M3; M1 (editmeta) remains a genuine single call. Companion fix in `bc-3-issue-write.md`
    (BC-3.3.010, the createmeta consumer BC-X.14.001 M2 shares code with) — same defect, same
    root cause, corrected together per that BC's own trace entry; new VP-578-020 there pins the
    page-≥2 field-resolution behavior (realized by the formal-verifier in
    `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md` in parallel). No BC added/removed/retired, no count
    change (still 89 individually-bodied / 155 cumulative in this file; 719 total_bcs / 106
    holdout scenarios factory-wide unchanged). Pre-pass-28 wording retained inline for audit
    trail.
  - Adversary pass-20 fix, M1 (2026-08-25, issue #580): BC-X.14.001 Invariant 1 REWRITTEN —
    corrected the arity model from an under-specified "exactly one of `--project`/`--type` |
    `--request-type` | `--issue`" framing (which treated `--project` as a co-equal mode-selector,
    wrongly making `--project --request-type` a pairing error and leaving M3-with-an-explicit-
    project reachable only via a profile/config default) to the mode-selector/companion model:
    exactly one of three MODE-SELECTOR flags (`--type`, `--request-type`, `--issue`) selects the
    enumeration mode; `--project` is never a mode selector — it is a companion flag, REQUIRED for
    M2 (`--type`), OPTIONAL for M3 (`--request-type`, so `--project --request-type` is now VALID,
    not a pairing error), and not consulted for M1 (`--issue`). VP-580-006 rewritten so the arity
    check is evaluated over the three mode-selector booleans only (never `has_project`); new
    VP-580-009 added as the dedicated `--project --request-type` VALID-pairing regression guard.
    BC-X.14.004's error-taxonomy precedence paragraph REWRITTEN to match (mode-selector arity
    evaluated first; `--project`'s companion role validated second, against the confirmed mode
    only). Ratified at the architecture layer by ADR-0019 §1 (Accepted 2026-08-25).
    Prose/citation-only amendment — no BC added or removed (still 89 individually-bodied / 155
    cumulative in this file).
  - Adversary pass-16 fix, MEDIUM-1 (2026-08-25, issue #580): BC-X.14.001 AMENDED — the M2
    (`--project`/`--type`) path was missing the `--type` name→issueTypeId resolution step that
    `get_createmeta_fields` requires (createmeta needs a numeric id; `--type` is a NAME). Added
    an explicit resolution step mirroring BC-3.3.010 Step 3 (`get_issue_types_for_project`,
    S-331, project-scoped, case-insensitive, at most once per invocation); reworded Postcondition
    3 to account for the additional resolution call on the M2 path only; added an error-taxonomy
    row + EC-X.14.004-4 for an unresolvable/ambiguous `--type` name; added
    `get_issue_types_for_project` to BC-X.14.001's Trace. Prose/citation-only amendment — no BC
    added or removed (still 89 individually-bodied / 155 cumulative in this file).
  - F2 spec evolution, Field DX bundle (2026-08-25, issue #580): +4 individually-bodied BCs —
    new "## BC-X.14: Field Option Discovery" subsection (BC-X.14.001..004), filed as a
    Cross-Cutting subsection per the `jr requesttype` (BC-X.12) precedent rather than a new
    numbered section file (sizing rationale: `.factory/phase-f1-delta-analysis/field-dx-bc-mapping.md`
    §1.3). `jr field options <field>` enumerates a custom select field's allowed options; it
    selects its enumeration mode by exactly one of three MODE-SELECTOR flags {`--type`,
    `--request-type`, `--issue`} (`--type` → createmeta PRIMARY for platform fields;
    `--request-type` → JSM requesttype-fields PRIMARY for JSM fields; `--issue <KEY>` → editmeta
    FALLBACK); `--project` is a companion (REQUIRED for M2/`--type`, OPTIONAL for
    M3/`--request-type` so `--project --request-type` is VALID, IGNORED for M1/`--issue`) — see
    ADR-0019 §1 / adversary pass-20 M1, settling the F1 open design fork per
    `.factory/research/field-dx-context-mechanism-2026-08-25.md`'s ranked recommendation.
    BC-X.14.005 (the issue's own "nice-to-have" `jr requesttype fields --enumerate-options`
    stretch goal) is DEFERRED, not committed as a BC slot this cycle, per the F1 BA mapping
    doc's own recommendation. definitional_count 85→89; total_bcs 151→155. See
    `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md`,
    `.factory/phase-f1-delta-analysis/delta-analysis-field-dx.md`.
  - F2 spec evolution, component-management bundle (2026-08-15, issues #604/#605/#606/#608):
    BC-X.10.001 AMENDED — EC-1 caller-example list and Trace gain a citation for the new
    `src/cli/issue/helpers.rs::resolve_component` caller (project-scoped component name
    resolution, numeric-id-bypass convention). Citation-only amendment; the shared
    `partial_match` primitive's own contract is unchanged. The component-specific caller
    contract (numeric bypass, project scoping, disambiguation shapes) is owned by
    `bc-8-components.md` §8.4, not duplicated here. No BC count change (still 85
    individually-bodied / 151 cumulative). See `bc-8-components.md` §8.4 placement rationale
    note.
  - F2 spec evolution (2026-08-14, S-MUTANTS-SCOPE-1): BC-X.3.006 AMENDED — promoted from thin semport stub (Confidence MEDIUM; only title/Confidence/Source/Trace; stale `src/main.rs:~264` citation) to a fully-specified BC (Subject/Behavior/Edge Cases EC-1..EC-3/Verification Properties added; Confidence HIGH; Source corrected to `src/main.rs::run` ~415). Pins the exact byte-level contract (`stderr == "\nInterrupted\n"`, `exit == 130`) that S-MUTANTS-SCOPE-1's F4 will exercise via a new `#[cfg(unix)]` subprocess SIGINT test (VP-MUTANTS-SCOPE-1-001) and a portable `run_until_shutdown` arm-selection unit test (VP-MUTANTS-SCOPE-1-002), ahead of `src/main.rs` entering `.cargo/mutants.toml::examine_globs`. No BC count change (still 85 individually-bodied / 151 cumulative). Also fixed a pre-existing stale cross-reference in `.factory/specs/prd/edge-case-catalog.md` EC-HTTP-005 ("Covered by BC-X.1.009" — wrong; BC-X.1.009 is the unrelated 429-exhausted-warning BC — corrected to BC-X.3.006). See `.factory/phase-f2-spec-evolution/S-MUTANTS-SCOPE-1-spec-delta.md`.
  - F2 spec evolution, bucket1-defects bundle (2026-08-13, issue #693): BC-X.8.009 AMENDED — Issue fetch pipeline step 3 now threads the resolved `Queue`'s declared `fields[]` (filtered to drop `issuekey` and any `BASE_ISSUE_FIELDS` member) into `search_issues`'s `extra_fields` argument, surfacing queue-configured custom fields in `--output json` via `IssueFields`'s existing `#[serde(flatten)] extra` mechanism. Table output unchanged (no new column; issue #575 tracks render-side work separately, out of scope here). `--id` path costs one additional `list_queues` call to obtain `queue.fields` that the `<name>` path does not incur (already has the `Queue` in hand from `resolve_queue_by_name`). Pre-#693 text (empty `extra_fields`) retained inline for audit trail. No BC count change (still 85 individually-bodied). See `.factory/research/bucket1-693-queue-view-fields-2026-08-13.md`.
  - L2: .factory/specs/domain-spec/cross-cutting.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.6-2.15
  - Source R1: .factory/semport/jira-cli/jira-cli-pass-3-deep-r1.md §3.6-3.8
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.2-3.4
  - F2 addition (2026-05-18): BC-X.12.001..008 — JSM request type discovery (issue #288)
  - F2 addition (2026-05-19): BC-X.8.006..007 — auth-conditional 401 hints on require_service_desk path (cache miss only): Basic-auth (is_oauth_auth==false) → API-token hint with InsufficientScope rewrite; OAuth (is_oauth_auth==true) → read:jira-work + read:servicedesk-request hint (issue #384; corrected model: gate is is_oauth_auth() alone)
  - S-QUEUE-BC-1 addition (2026-06-08): BC-X.8.008..009 — document-as-is BCs for jr queue list and jr queue view (queue traceability orphan closure)
  - DEAD-CITATION-CI F2 addition (2026-06-19): BC-X.13.001..003 — CLAUDE.md dead-citation CI guard (citation path-existence, glob/suffix/punct exclusion, ALL .factory/ excluded — re-scoped F2 Iteration 2)
  - F2 pass-5 precision fix (2026-06-27): BC-X.10.001 Trace — removed false `expect(1)` pin claim; `resolve_queue_single_substring_is_ambiguous` uses absence-of-mount (zero `.expect(` calls confirmed), not `expect(1)`; no behavioral or count change
  - CITATION-GUARDS Story B F2 addition (2026-07-05): BC-X.13.004..006 — Guard 1 bc-*.md Trace/Source file::symbol citation guard (S-BC-CITATION-GUARD-1, story #102)
  - D-154 Option A spec update (2026-07-06): BC-X.13.005 — extend v1 grammar (3 branches: ::tests, ::tests::testfn, standalone CamelCase); space-tolerant two-pass extraction (F-B2-02); BC-X.13.004 — FLOOR recalibration N=326, FLOOR=244; BC-X.13.006 — fixture count 7→10 (A–K)
  - F-01 two-tier shape guard (2026-07-06, story #102 Step-4.5 pass-1): BC-X.13.005 Step 3 rewrite — shape guard now `^src/[a-zA-Z0-9_/.-]+\.[a-zA-Z0-9]+$` (any extension); non-.rs src/ tokens routed to tier (ii) file-existence-only (counts toward N); .rs tokens continue full pipeline tier (i); truly-malformed DEAD-malformed unchanged; EC-CITE-060 added (tier-ii .snap positive pin); EC-CITE-058 updated (.snap mechanism corrected); BC-X.13.004 N=309 FLOOR=231 (two-tier baseline 2b09313); BC-X.13.006 test vector N ≥ 231
  - SOH-BUGS-1 post-fix micro-BC (2026-07-09): BC-X.1.011 — `-X`/`--method` case-insensitive HTTP method parsing; VP-590-001 registered (issues #590/#582, PR #597)
  - SOH-ATTACHMENTS-1 F2 addition (2026-07-15): BC-X.8.010 — JSM attachment upload resolves serviceDeskId via the EXISTING ProjectMeta cache (`get_or_fetch_project_meta`; `project_meta.json`) — NO new cache file, NO new writer (model-b discussion MOOT); SEC-576-006 self-heal; P6-001/P6-004 correction (D-179, issues #576 #585)
  - SOH-ATTACHMENTS-1 adversary pass-37 fix round (2026-07-17): BC-X.8.010 frontmatter description corrected from withdrawn pre-P6 design to reuse design (P37-001b)
  - SOH-ATTACHMENTS-1 F3 adversary pass-11 fix round (2026-07-18): BC-X.8.010 EC-X.8.010-1 added — service-desk-list no-match None-path exit 64 before step 1 (P11-005; spec v1.3.86)
  - WAVE-576-05 DOCUMENT-AS-IS ruling (2026-07-24, F5 round 12): BC-X.8.010 EC-X.8.010-2 added + stale_healed per-command-not-per-file note — multi-file upload second independent step-1 failure after heal already fired propagates raw ApiError exit 1 (near-unreachable path; DOCUMENT-AS-IS-COMPLETE); 0 new BCs; counts unchanged (150/84); spec v1.3.106
  - FIX ROUND 12 addition (2026-08-05, S-626-1 issue #626): BC-X.13.007 — `test` job runtime test-execution floor (Guard 2): binary-count floor + named-canary check + zero-test floor, gating `ci-gate` against a false-green CI result from zero or near-zero test execution (POL-11); anchors story S-626-1 AC-10
  - Round-19 boundary clarification (2026-08-05, S-626-1 issue #626, adversarial passes 45-47, commit `e076e96b`): BC-X.13.007 Invariants gained a bullet distinguishing it from the sibling `ci-gate`/`msrv` job story-AC guards (AC-001/002/003/AC-3/M1/M2) strengthened this round — no BC/VP in this PRD governs those guards; VP-CIGATE-001's twelve assertions and this BC's verification-status grades are unchanged (round 19 did not touch `test_verify_test_job_has_zero_test_floor`); no new BC, no count change (658 total / 85 individually-bodied unchanged in this file)
  - Round-20 staleness correction (2026-08-07, S-626-1 issue #626, commits `7f702bf6`/`424d64de`): BC-X.13.007's sibling-guard-list Invariant corrected — the "a literal `run: exit 1` body" guard description was stale (self-flagged in a prior burst report as at risk); `7f702bf6` retired that F-01 assertion as strictly subsumed by `test_ci_gate_pass_fail_semantics_are_structurally_placed`'s M2-i `PINNED_GATE_RUN_LINE` byte-for-byte pin once S-CIGATE-2 replaced the gate step's `run:` body — reworded in place to describe the current guard and to make explicit that coverage was superseded, not dropped; also updated the `EC-002 / M1` test citation from `test_ci_gate_needs_jobs_have_no_event_conditional_if` to its round-20 rename `test_ci_gate_needs_jobs_have_no_job_level_if` (`424d64de`, ADV-P48-LOW-001); no BC/VP text-content change beyond this Invariant bullet, no new BC, no count change (658 total / 85 individually-bodied unchanged in this file)
  - Round-20 staleness correction, part 2 (2026-08-07, S-626-1 issue #626, commits `424d64de`/`177b3727`): BC-X.13.007 Behavior item 2 and the paired Verification-status bullet corrected — both self-flagged in a prior burst report as stale, describing the named-canary check as proving only that the canary binary was *launched*, not that it *reported results* (a binary that crashed or was `#[ignore]`d before printing its own `test result:` line would satisfy the check as described); `424d64de` (ADV-P50-LOW-002) closed exactly this gap by locating the canary's own `test result:` line and requiring a non-zero passed count from it, and `177b3727` made that lookup path-separator-agnostic (`[/\\]`) so it matches `windows-latest`'s backslash `Running` line as well as Unix's forward slash — reworded both sites in place to describe the current two-stage check. The Verification-status bullet also gained an explicit disclosure: `tests/ci_gate_completeness.rs::test_verify_test_job_has_zero_test_floor` (VP-CIGATE-001, still twelve assertions) was NOT extended to pin this strengthened logic or the separator-agnostic match — confirmed against the round-20 diff (touches only the msrv-anchor and job-key-set assertions documented in the Invariants bullet above) and the Windows-fix commit (touches only `ci.yml`); disclosed as unpinned code/spec drift, not silently closed. No new BC, no count change (658 total / 85 individually-bodied unchanged in this file)
  - Round-20 regression-pin catch-up, closing STRENGTHENED-CANARY-UNPINNED and SPEC-EDGE-CASES-LAG-GUARD-STRENGTHENING (2026-08-07, S-626-1 issue #626, commit `ada50a34`): `test_verify_test_job_has_zero_test_floor` was extended from twelve to fifteen `str::contains` assertions — verified directly (`grep -c "assert!(" ` scoped to the function body). The three new assertions (Instrument 2b's two sub-assertions, `tail -n +"${_canary_running_line}"` and `"${_canary_passed}" -eq 0`; Instrument 2c, the raw-string regex `Running tests[/\\\\]ci_gate_completeness\.rs`) pin the ADV-P50-LOW-002 non-zero-passed strengthening and its path-separator-agnostic lookup that `424d64de`/`177b3727` had left unpinned. Every prior "twelve assertions" / "unpinned code/spec drift" claim in this BC's body (Verification-status intro, Behavior items 1–3 status, the sibling-guard-list Invariant, and VP-CIGATE-001's own description and grading breakdown) is corrected in place to "fifteen assertions" / "now pinned", naming the three new assertions; the two prior dated trace entries above (Round-19, Round-20 part 2) are left as-is — they accurately describe the state at the time they were written. Also closes the previously-flagged edge-case gap: EC-CIGATE-006 added (canary binary launches — satisfying the bare presence check — but its own `test result:` line reports zero passed; distinct from EC-CIGATE-002, where the binary never launches at all) with a matching Verification-status bullet and Canonical Test Vectors row; Postcondition 5 split so the named-canary check's two distinct failure messages (`did not run` vs `ran but reported 0 passed assertions`) are enumerated separately, matching what the step's shell script actually emits (`ci.yml` :: `test` / "Run tests (zero-test floor, POL-11)"). Judgement call: the pre-`177b3727` Windows-separator failure mode (a forward-slash-only pattern hardcoding the passed count to 0 and unconditionally failing every Windows run) was evaluated for its own EC and NOT given one — it is a false-RED guard-implementation-correctness bug (already fixed, now pinned by Instrument 2c), not a target scenario the guard is designed to detect the way EC-CIGATE-001/002/003/006 are; it remains documented in Behavior item 2 and Precondition 1 (3-OS matrix) rather than the Edge Cases catalog. No new BC, no count change (658 total / 85 individually-bodied unchanged in this file)
  - Class-level correction sweep, ADV-P51-MED-001 assertion-count/gate-arity catch-up (2026-08-07, S-626-1 issue #626, commit `3ad496eb`): a discovery pass found this BC's body had gone stale against `3ad496eb`, which closed three guard-strength gaps in `test_verify_test_job_has_zero_test_floor` — a step key-set/env pin (`test_test_job_guard_step_key_set_and_env_are_pinned`, not text-pinned by VP-CIGATE-001 and out of scope here), a pipefail ordering pin (also out of scope), and, load-bearing for this BC, replacing the single generic `assert!(test_block.contains("exit 1"))` with four PER-BRANCH `extract_if_block`-scoped pins (ADV-P51-MED-001) — a net +3, taking `test_verify_test_job_has_zero_test_floor` from fifteen to eighteen `str::contains` assertions, verified directly (`grep -c "assert!(" ` scoped to the function body). Every "fifteen assertions" claim in this BC's body (Verification-status intro, Behavior items 1–4 status, EC-CIGATE-003, the sibling-guard-list Invariant, and VP-CIGATE-001's own description and grading breakdown) is corrected in place to "eighteen assertions"; the "Weakest" tier's `exit 1` entry is removed and a new "Per-branch, scoped" tier added, matching the promoted status of that instrument. This also promotes the named-canary passed-count gate from a sub-check of Behavior item 2 to its own top-level item 3, renumbering Behavior/Postcondition/EC-CIGATE-004 gate-count language from "three" to "four" gates (`ci.yml`'s own step comment and the test docstring were, at the time of this sweep, being aligned to four in a parallel change; this BC's four-gate enumeration anchors that shape). EC-CIGATE-003's arithmetic was re-verified rather than assumed: at eighteen total, wholesale deletion of the `if [ "${total}" -eq 0 ]; ... fi` block now defeats TWO assertions (the direct text-pin AND the new `zero_test_floor_block` per-branch `exit 1` pin, which shares the same condition-line lookup), so the "assertions unaffected" count is corrected to sixteen, not the naive eighteen-minus-one. Also removed a CLASS-6 inaccuracy from the sibling-guard-list Invariant: "step-level `contains(needs.*.result, 'failure'|'cancelled')`" was listed as a currently-pinned `ci-gate` guard alongside the accurate members of that list, but no such construct exists in `ci.yml` and no test pins one — the gate decision is `scripts/check-ci-gate.sh`, fail-closed, already covered by the adjacent "byte-for-byte pinned gate-decision `run:` line" list member; the stale member is deleted, not reworded, since it names a mechanism that was never shipped. No new BC, no count change (658 total / 85 individually-bodied unchanged in this file)
  - S-cycle13 doc reconciliation (2026-09-15, S-cycle13 combined S1+S2, commit `29e2d362`): BC-X.13.007's sibling-guard-list Invariant `msrv`-job scope-exclusion bullet corrected — the `toolchain: "1.85.0"` / same-step `RUSTUP_TOOLCHAIN: "1.85.0"` literals and the `--all-targets`-omitted "lib + bins"-only framing they anchored were stale against the landed cycle-013 MSRV bump: `.github/workflows/ci.yml`'s `msrv` job now pins `toolchain: "1.88.0"` + `RUSTUP_TOOLCHAIN: "1.88.0"` and runs `cargo check --all-targets --all-features --locked` (dropping the prior narrower `lib + bins`-only scope now that the 1.88 floor covers the let-chain syntax the job's own `wiremock` dev-dependency tree required at ≥1.88). Reworded in place to current-state literals/scope and attributed to S-cycle13-msrv-1.88-atomic-bump; the self-disclaimer that no corresponding BC or VP is registered in this PRD for the `msrv`/`ci-gate` story-AC guards is preserved verbatim. Verified against `tests/ci_gate_completeness.rs::test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env`, which now asserts the 1.88.0 literals and the `--all-targets` scalar. No new BC, no count change (658 total / 85 individually-bodied unchanged in this file)
---

# BC-X — Cross-cutting

162 behavioral contracts covering: HTTP client (X.1), Pagination (X.2), Error handling (X.3),
Rate limiting (X.4), Worklogs & duration (X.5), Teams (X.6), Users (X.7), Projects & Queues (X.8),
JQL utilities (X.9), Partial-match (X.10), Build-time (X.11), JSM Request Types (X.12),
CI Guards (X.13), Field Option Discovery (X.14), OAuth Agile-Command Error-Mapping (X.15), API
Query Parameters (X.16). (+2 BC-X.16.001..002 added 2026-09-25 cycle-014
`issue-triage-quickfixes` issue #583 — `jr api --query-param NAME=VALUE`; BC-X.7.002 amended in
place for issue #862 (project-resolution order) and BC-X.14.001/003 amended in place for issue
#861 (M1/M2 label-resolution fallback, READ-SIDE ONLY), no separate count for either amendment;
BC-X.14.004 gains one documentation-only cross-reference row (empty `<field>`), COUNT-NEUTRAL;
the §BC-X.14 intro is reworded (count-neutral); +1 BC-X.15.001 added 2026-09-17 cycle-008
`oauth-surface-correctness` ADR-0026 Decision 3 — `jr board`/`jr sprint` OAuth 401 error-mapping
call-site rewrite; +4 BC-X.7.007..010 added 2026-09-06 by issue #674 markdown mentions — `@Name`
resolution (unique/ambiguous/zero-match) + bracket-form accountId preflight validation.)

---

## Subdomains

### X.1 HTTP Client (JiraClient)

#### BC-X.1.001: Auth header injected on every API call via `req.header("Authorization", &self.auth_header)` at line 195

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~14`; `src/api/client.rs:~195`
**Subject**: HTTP client
**Behavior**: Header value is verbatim auth string (e.g., `Basic dGVzdEBleGFtcGxlLmNvbTpteS1hcGktdG9rZW4=`). Pinned by wiremock `header(...)` matcher. Injected on every retry attempt including the first.
**Trace**: Pass 3 BC-1410-R (R1); BC-1082 (R4)

---

#### BC-X.1.002: `client.send(request)` retries 429 transparently; returns parsed response on 200

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~42`
**Behavior**: 429-then-200 → caller sees 200 (typed T). Retry is transparent.
**Trace**: Pass 3 BC-1402; BC-1083 (R4)

---

#### BC-X.1.003: `client.send(request)` on exhausted 429 raises `JrError::ApiError{status: 429}` via `parse_error`

**Confidence**: HIGH
**Source**: `src/api/client.rs:~184`
**Behavior**: After MAX_RETRIES=3 (4 total calls), the last 429 response is parsed via `parse_error` → `JrError::ApiError`. Distinct from `send_raw` behavior (which returns 429, not raises).
**Trace**: Pass 3 BC-1402-R (R1)

---

#### BC-X.1.004: `client.send(request)` requires `RequestBuilder::try_clone()` to succeed; non-cloneable bodies panic

**Confidence**: HIGH
**Source**: `src/api/client.rs:~191`
**Behavior**: `request.try_clone().expect("request should be cloneable (JSON body)")`. Streaming-body refactor would panic.
**Trace**: Pass 3 BC-1402a (R1)

---

#### BC-X.1.005: `client.send_raw(request)` returns 429 to caller (NOT raises) after MAX_RETRIES=3; `expect(4)` pin

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~424`
**Subject**: HTTP client
**Behavior**: 4 total calls (initial + 3 retries). FINAL response IS 429. `send_raw` returns it, not raises.
**Trace**: Pass 3 BC-1401; BC-1092 (R4)

---

#### BC-X.1.006: `send_raw` 429-then-200 retries identically to `send`; caller sees 200

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~394`
**Trace**: Pass 3 BC-1091 (R4)

---

#### BC-X.1.007: `send_raw` preserves 404 as response (NOT converted to Err); used by `jr api` raw passthrough

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~367`
**Subject**: HTTP client
**Behavior**: 404 response returned to caller with body intact. Error-conversion happens in `get`/`post`/etc., NOT `send_raw`.
**Trace**: Pass 3 BC-1409-R (R1); BC-1090 (R4)

---

#### BC-X.1.008: `send_raw` non-cloneable body returns `anyhow::Error` with explicit message (NOT panic)

**Confidence**: HIGH
**Source**: `src/api/client.rs:~267`
**Behavior**: `req.try_clone().ok_or_else(|| anyhow::anyhow!("request cannot be retried..."))`. More defensive than `send`.
**Trace**: Pass 3 BC-1402b (R1)

---

#### BC-X.1.009: 429-exhausted warning always emitted to stderr (not verbose-gated)

**Confidence**: HIGH
**Source**: `src/api/client.rs:~233, 309-313`
**Behavior**: `"warning: rate limited by Jira — gave up after 3 retries. Wait a moment and try again."` — unconditional. Same from both `send` and `send_raw`.
**Trace**: Pass 3 BC-1404; BC-1404-R (R1)

---

#### BC-X.1.010: All HTTP methods (get, post, put, delete, send_raw) inject auth header — no bypass

**Confidence**: HIGH
**Source**: `src/api/client.rs` (R4 §4.1 verification)
**Behavior**: 9 high-level methods use `self.send(request)` (auth at line 195). 2 raw methods use `self.client.execute(req)` after `self.request()` injects header. No method bypasses.
**Trace**: Pass 4 R4 §4.1

---

#### BC-X.1.011: `-X` / `--method` flag accepts HTTP method values case-insensitively; help text renders lowercase canonical variants

**Confidence**: HIGH
**Source**: `src/cli/mod.rs` § `#[arg(short = 'X', long, value_enum, ignore_case = true, default_value_t = api::HttpMethod::Get)]`
**Subject**: CLI arg parsing / `jr api` passthrough
**Behavior**: The `-X` / `--method` clap argument on `jr api` accepts the five HTTP methods in any capitalisation — `DELETE`, `delete`, and `Delete` all parse to `HttpMethod::Delete` and dispatch the corresponding HTTP verb via `From<HttpMethod> for reqwest::Method`. The `ignore_case = true` attribute is set on the `#[arg]` annotation in `src/cli/mod.rs`, NOT on the `HttpMethod` enum definition in `src/cli/api.rs`. Help text (`[possible values: get, post, put, patch, delete]`) remains lowercase because clap renders enum variant names, not user-supplied input — `ignore_case = true` has no effect on help rendering.

**Preconditions**: clap `#[arg(value_enum, ignore_case = true)]` annotation present on `-X`/`--method` in `src/cli/mod.rs`.

**Postconditions**:
1. Any capitalisation of a valid HTTP method string (DELETE/delete/Delete, GET/get, POST/post, PUT/put, PATCH/patch) is accepted by clap without a parse error (exit 2 eliminated for case-variant inputs).
2. The accepted input maps to the corresponding `HttpMethod` variant; `From<HttpMethod> for reqwest::Method` dispatch behaviour is unchanged.
3. Help text under `--method` still renders `[possible values: get, post, put, patch, delete]` (lowercase); `ignore_case = true` does not alter help rendering.

**Invariants**:
- `HttpMethod` enum definition in `src/cli/api.rs` is NOT modified; case-insensitivity is purely a clap parse-time attribute on the arg, not on the enum.
- Invalid method strings (e.g., `-X FOO`) continue to be rejected by clap with exit 2; `ignore_case = true` relaxes capitalisation only, not enum membership.

**Edge Cases**:
- EC-X.1.011-1 (`-X DELETE` uppercase): clap parse succeeds; `HttpMethod::Delete` dispatched; HTTP DELETE sent; exit 0.
- EC-X.1.011-2 (`-X delete` lowercase): regression guard — unchanged from pre-fix behaviour; still dispatches HTTP DELETE; exit 0.
- EC-X.1.011-3 (`-X Delete` mixed-case): clap parse succeeds; `HttpMethod::Delete` dispatched; HTTP DELETE sent; exit 0.
- EC-X.1.011-4 (other uppercase methods — `-X PATCH`, `-X GET`, etc.): identical mechanism; all parse correctly via `ignore_case`; no test written per-method (scope is DELETE per VP-590-001; other methods are the same code path).
- EC-X.1.011-5 (`-X FOO` invalid method): still rejected with clap error exit 2; `ignore_case = true` has no effect on enum membership.

**Verification Properties**:
- VP-590-001: uppercase/lowercase/mixed-case parse to `HttpMethod::Delete` and dispatch HTTP DELETE — `tests/cli_handler.rs::test_parse_api_method_uppercase_delete_dispatches_http_delete`, `tests/cli_handler.rs::test_parse_api_method_lowercase_delete_dispatches_http_delete`, `tests/cli_handler.rs::test_parse_api_method_mixedcase_delete_dispatches_http_delete` all succeed; wiremock server records exactly one DELETE request per invocation.

**Trace**: issues #590 (bug: uppercase -X rejected by clap), #582 (feature: match `curl -X` / `gh api -X` convention); PR #597 merged @ 4f3960e0 on develop; S-SOH-590-1 (SOH-BUGS-1 bundle); post-fix micro-BC per D-165 (human-approved as recommended)

[NEW 2026-07-09 post-fix micro-BC per D-165, issues #590/#582, PR #597]

---

### X.2 Pagination

#### BC-X.2.001: Offset pagination: `startAt`/`maxResults` + `total` for issue comments, projects, worklogs

**Confidence**: HIGH
**Source**: `src/api/pagination.rs`; unit test suite (pagination module); `tests/comments.rs:~104`
**Trace**: Pass 3 BC-1406, BC-1407-R (R1)

---

#### BC-X.2.002: Cursor pagination via `nextPageToken` for JQL search

**Confidence**: HIGH
**Source**: `src/api/pagination.rs::CursorPage`; `tests/issue_commands.rs`
**Trace**: Pass 3 BC-1406

---

#### BC-X.2.003: ServiceDeskPage pagination (JSM service desks)

**Confidence**: HIGH
**Source**: `src/api/pagination.rs::ServiceDeskPage`
**Trace**: Pass 3 BC-1406

---

#### BC-X.2.004: `AssetsPage::is_last` accepts bool or string-encoded bool (custom deserializer)

**Confidence**: HIGH
**Source**: `src/api/pagination.rs::AssetsPage`
**Trace**: Pass 3 BC-317 (R1)

---

#### BC-X.2.005: User pagination advances `startAt` by REQUESTED `maxResults` (NOT by returned count)

**Confidence**: HIGH
**Source**: `tests/user_pagination.rs:~202`; `tests/all_flag_behavior.rs:~155`
**Subject**: Pagination
**Behavior**: Page 1 returns 35 users; page 2 startAt=100 (advanced by requested 100, NOT by 35). This is a deliberate workaround for JRACLOUD-71293.
**Trace**: Pass 3 BC-702; BC-1119 (R4)

---

#### BC-X.2.006: `USER_PAGINATION_SAFETY_CAP = 1500` (15 pages × 100); emits stderr `"hit pagination safety cap"`; exits 0

**Confidence**: HIGH
**Source**: `tests/user_pagination.rs:~459`
**Behavior**: Safety cap prevents infinite loops. Warning is observable; exit 0.
**Trace**: Pass 3 BC-1124, BC-1125 (R4)

---

### X.3 Error Handling (universal rules)

#### BC-X.3.001: Network drop → `Could not reach <host>; check your connection` exit 1

**Confidence**: HIGH
**Source**: `tests/issue_list_errors.rs:~320`; `tests/issue_view_errors.rs:~102`; `tests/assets_errors.rs:~115`
**Behavior**: Connect-refused (port 1) → `JrError::NetworkError(host)`.
**Trace**: Pass 3 BC-1206

---

#### BC-X.3.002: 401 → `Not authenticated` + `jr auth login` exit 2 (universal across all subcommands)

**Confidence**: HIGH
**Source**: 6+ test files; `tests/issue_list_errors.rs`, `tests/issue_view_errors.rs`, `tests/comments.rs`, `tests/worklog_commands.rs`, `tests/team_commands.rs`, `tests/assets_errors.rs`
**Trace**: Pass 3 BC-1207

> **[UPDATED 2026-05-19 issue #384]** JSM auth-conditional footnote: For JSM dispatch paths (both `handle_jsm_create` and `require_service_desk`), 401 behavior is auth-conditional — see BC-3.8.014 / BC-X.8.006 (Basic-auth: `is_oauth_auth() == false` → API-token-expiry hint; any `InsufficientScope` is REWRITTEN to `NotAuthenticated` before surfacing) and BC-3.8.015 / BC-X.8.007 (OAuth: `is_oauth_auth() == true` → existing error-variant behavior preserved). The gate is `is_oauth_auth()` alone, not error variant. The Base contract BC-X.3.002 applies to all non-JSM paths and to any JSM path that does not trigger the auth-conditional map_err.

---

#### BC-X.3.003: 5xx → `API error (<status>)` + extract_error_message(body) + exit 1

**Confidence**: HIGH
**Source**: All `*_errors.rs` files; assert `stderr.contains("API error (500)")`
**Trace**: Pass 3 BC-1210

---

#### BC-X.3.004: 400 with field-specific Jira error → stderr formatted as `field: message` (sorted alphabetically)

**Confidence**: HIGH
**Source**: `tests/issue_resolution.rs:~124`
**Trace**: Pass 3 BC-1211

---

#### BC-X.3.005: 401 + scope-mismatch (case-insensitive) → InsufficientScope with 5 substrings; 403 with substring NOT dispatched

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~99`
**Trace**: Pass 3 BC-015..018; BC-1085..1088 (R4)

---

#### BC-X.3.006: Ctrl+C during a running command exits 130 with stderr `"\nInterrupted\n"` — `tokio::select!` graceful-shutdown race between the in-flight command and `tokio::signal::ctrl_c()`

**STATUS: UPDATED (2026-08-14, S-MUTANTS-SCOPE-1)** — promoted from a thin semport-extracted stub (Confidence MEDIUM, stale `src/main.rs:~264` citation, no Subject/Behavior/Edge Cases/Verification Properties) to a fully-specified BC as part of adding `src/main.rs` to `.cargo/mutants.toml::examine_globs`. This block previously had ZERO test coverage (confirmed: grep for `ctrl_c`/`SIGINT`/`signal::` across `tests/` returns no hits) — S-MUTANTS-SCOPE-1's F4 closes that gap per the Verification Properties below. Previous version retained for audit trail below.

**Confidence**: HIGH
**Source**: `src/main.rs::run` — the `RunOutcome::Interrupted` match arm (citation refreshed 2026-08-14 post-S-MUTANTS-SCOPE-1-F4 refactor, adversarial finding F-3 LOW; delivered on branch `test/mutants-scope-queue-main`, not yet merged to develop — the `~526` target below is that branch's post-refactor line, which is correct and intended since this BC ships with the story). The `tokio::select!` race described below now lives inside `run_until_shutdown` at `src/main.rs:~174`; the interrupt arm itself (`eprintln!("\nInterrupted")` + `std::process::exit(130)`) sits at `src/main.rs:~526`. Previous `~415` pointed at the pre-refactor inline `tokio::select!` block in `run()` directly, which F4 extracted into `run_until_shutdown` — that citation is now stale.
**Subject**: Runtime / Cross-cutting error handling
**Behavior**: `run()`'s single top-level `tokio::select!` races two futures for the lifetime of any `jr` invocation:
1. `main_task` — the dispatched subcommand's own async work (the full `match cli.command { … }` handler chain).
2. `tokio::signal::ctrl_c()` — resolves when the process receives `SIGINT` (Unix) / `CTRL_C_EVENT` (Windows; `tokio::signal::ctrl_c()` itself is a portable, cross-platform primitive, though this BC's own verification below is Unix-scoped).

If `main_task` completes first, its `Result` is returned normally (existing per-command exit-code/JSON-error handling downstream in `main()` is unaffected by this BC). If `tokio::signal::ctrl_c()` resolves first (the user pressed Ctrl+C / sent SIGINT while a command was in flight), `run()` takes the interrupt branch, which does exactly two things, in order:
1. Writes the literal string `"\nInterrupted"` to stderr via `eprintln!("\nInterrupted")` — `eprintln!` appends its own trailing `\n`, so the byte-exact stderr contribution is `"\nInterrupted\n"` (leading blank line, then `Interrupted`, then newline).
2. Calls `std::process::exit(130)` — terminates the process immediately with exit code 130 (`128 + SIGINT`, the POSIX convention `jr` follows for signal-terminated processes; matches the `JrError::exit_code()` `Interrupted` mapping in `src/error.rs` and `error-taxonomy.md` §Exit Code Semantics, row `130 | Interrupted (Ctrl+C) | Interrupted`).

**No cleanup/drop logic runs between steps 1 and 2** — `std::process::exit` does not unwind the stack or run destructors. This is a pre-existing characteristic of the block (not a new decision introduced by this amendment); no in-flight resource (HTTP connection, file handle, keychain session) requires graceful teardown on interrupt in the current codebase.

**Race condition (documented, not a defect)**: `tokio::signal::ctrl_c()` only registers its OS-level signal listener the first time it is polled inside the `select!`. A signal delivered before that registration completes falls through to the process's default `SIGINT` disposition (immediate termination — NOT exit 130, NOT the `"\nInterrupted\n"` message). This is a narrow, real-world-negligible window and is exactly why the Unix subprocess Verification Property below requires a deterministic readiness handshake rather than a fixed sleep — see VP-MUTANTS-SCOPE-1-001.

**Edge cases**:
- **(EC-1) SIGINT arrives before the `select!` first polls (registration race)**: Falls through to default OS disposition; process terminates by signal, not via this BC's graceful path. Documented limitation, not exercised by VP-MUTANTS-SCOPE-1-001 (which is specifically designed to avoid triggering this window via a readiness handshake, not a fixed sleep).
- **(EC-2) SIGINT arrives after `main_task` has already won the race**: Not reachable — `select!` only polls remaining arms until ONE resolves; once `main_task` wins, the `ctrl_c` arm is dropped and no further signal handling occurs through this path for that invocation (a second SIGINT hits the OS default disposition, same as any ordinary already-exiting process).
- **(EC-3) Ctrl+C during a JSON-output (`--output json`) invocation**: The interrupt path is unconditional — it always writes plain-text `"\nInterrupted\n"` to stderr, never the `{"error": "…", "code": 130}` JSON-error envelope (BC-7.3.010's JSON render invariant governs `JrError` results returned from `main_task`; it does NOT apply to this out-of-band `process::exit` path, since no `JrError` value is ever constructed for a signal interrupt). This asymmetry is intentional and pre-existing, not newly introduced by this amendment.

**Verification Properties**:
- VP-MUTANTS-SCOPE-1-001: Out-of-process SIGINT observation (`#[cfg(unix)]` subprocess test) — spawns the compiled `jr` binary (`env!("CARGO_BIN_EXE_jr")`), waits for a deterministic readiness signal (NOT a fixed sleep — must avoid the EC-1 registration race), sends `SIGINT` via `libc::kill` (libc 0.2.183 already resolved in `Cargo.lock`; no new dependency), and asserts on the REAL child process's exit code (`== 130`) and REAL stderr (`== "\nInterrupted\n"`, byte-exact). This is the only test shape capable of killing the `130` literal-substitution mutant and the `eprintln!` statement-deletion mutant — both require observing the actual OS-level process boundary, which no in-process test can do. Runs on the `mutants` CI job's `ubuntu-latest` runner (Unix-gated, consistent with the existing `#[cfg(unix)]` convention in `tests/ci_gate_completeness.rs`), so it counts toward the `src/main.rs` PR-diff kill rate once `main.rs` enters `examine_globs`. Detail + full mechanism-selection rationale: `.factory/research/S-MUTANTS-SCOPE-1-ctrl-c-mutation-testing.md`.
- VP-MUTANTS-SCOPE-1-002: Portable arm-selection unit test — the `select!`'s two-arm race is refactored (behavior-preserving) into a small generic `run_until_shutdown(work: impl Future<Output = T>, shutdown: impl Future<Output = ()>) -> RunOutcome<T>` fn, with a `#[tokio::test]` injecting `std::future::pending::<()>()` for `work` and `std::future::ready(())` for `shutdown`, asserting the shutdown arm is selected (`RunOutcome::Interrupted`). Runs on every platform (deterministic future resolution only, no signal delivery), giving cross-platform coverage of the arm-selection decision itself. Does NOT and cannot kill the `eprintln!`/`exit(130)` mutants at the `main` boundary (an in-process test cannot observe a `process::exit` call, nor deterministically a sibling process's own stderr) — VP-MUTANTS-SCOPE-1-001 remains load-bearing for those. `process::exit(130)` and the `eprintln!` stay at the thin `main`/`run` boundary, outside `run_until_shutdown` itself.
- **Explicitly rejected**: `#[mutants::skip]` on this block. `docs/specs/cargo-mutants-policy.md` §Whitelist Convention lists "It's hard to test" and "Tests don't cover this" as invalid justifications verbatim; a signal-handler fork does not fit any of the three valid categories (defensive-unreachable-guard, performance-only-optimization, debug-only-assertion). A skip here would violate repo policy and must be rejected in review.

**Previous version (superseded by S-MUTANTS-SCOPE-1, retained for audit trail):**
> **Confidence**: MEDIUM
> **Source**: `src/main.rs:~264`
> No Subject/Behavior/Edge Cases/Verification Properties sections existed; the BC was a range-collapsed-style semport stub consisting only of a title, Confidence, Source, and Trace.

**Trace**: Pass 3 BC-1209; F2 amended (2026-08-14, S-MUTANTS-SCOPE-1) — promoted from thin semport stub to fully-specified BC with exact behavior, edge cases, and two Verification Properties (VP-MUTANTS-SCOPE-1-001/002), ahead of `src/main.rs` entering `.cargo/mutants.toml::examine_globs` in F4; stale `~264` source citation corrected to `~415`; see `.factory/phase-f2-spec-evolution/S-MUTANTS-SCOPE-1-spec-delta.md`

| Version | Date | Author | Change |
|---------|------|--------|--------|
| 1.0.0 | (semport Pass 3) | — | Initial stub extraction: title + Confidence (MEDIUM) + stale Source (`~264`) + Trace only |
| 1.1.0 | 2026-08-14 | product-owner | S-MUTANTS-SCOPE-1 F2: promoted to full BC — Subject/Behavior/Edge Cases sections added; exact stderr text (`"\nInterrupted\n"`) and exit code (130) pinned; Source citation corrected to `~415`; Confidence MEDIUM→HIGH; added `**Verification Properties**:` subsection (VP-MUTANTS-SCOPE-1-001 subprocess SIGINT test, VP-MUTANTS-SCOPE-1-002 portable arm-selection test) |

---

#### BC-X.3.007: Error messages must suggest next step (CLAUDE.md convention, universal)

**Confidence**: HIGH
**Source**: Multiple integration tests asserting remediation strings
**Trace**: Pass 3 BC-1212

---

#### BC-X.3.008: stderr must NEVER contain `panic` (universal)

**Confidence**: HIGH
**Source**: 16+ negative assertion tests
**Trace**: Pass 3 BC-1205

---

### X.4 Rate Limiting

#### BC-X.4.001: MAX_RETRIES = 3 (initial + 3 = 4 total calls); `expect(4)` pin

**Confidence**: HIGH
**Source**: `tests/api_client.rs:~424`; `src/api/client.rs:~265`
**Trace**: Pass 3 BC-1401-R (R1)

---

#### BC-X.4.002: `Retry-After` header parsed as u64 INTEGER ONLY — HTTP-date format NOT supported

**Confidence**: HIGH
**Source**: `src/api/rate_limit.rs:~14`; unit test suite (rate_limit module)
**Subject**: Rate limiting
**Behavior**: `header.parse::<u64>()`. HTTP-date format → `None` → falls back to `DEFAULT_RETRY_SECS = 1`. No upper bound — `Retry-After: 86400` is honored as 24h (NFR-R-NEW-1, LOW). CONV-ABS-001 correction.
**Trace**: Pass 3 BC-1403-R (R1)

---

 > [BC-X.4.003..008 are range-collapsed in BC-INDEX.md; not individually bodied]

#### BC-X.4.009: `MAX_RETRY_AFTER_SECS = 60` cap — Retry-After exceeding 60s prints warning and aborts retry

**Confidence**: HIGH (PROPOSED — FIX-IN-PHASE-3)
**Source**: `src/api/rate_limit.rs` (proposed addition)
**Subject**: Rate limiting
**Behavior**: When `Retry-After` header value is a valid u64 AND exceeds `MAX_RETRY_AFTER_SECS = 60`: (1) print to stderr `"warning: Retry-After <NNN>s exceeds 60s; aborting retry, run jr again later"` and (2) exit non-zero (the retry loop does NOT sleep and retry; it returns the 429 response). Values ≤ 60s continue to be honored as before.
**Related**: NFR-R-NEW-1 (cross-link); H-027 (holdout that pins current no-upper-bound behavior — will need updating when this fix lands).
**Note**: This BC describes the PROPOSED fixed behavior, not current behavior. Currently BC-X.4.002 documents no upper bound. This BC is the Phase 3 target state. H-027 documents the current gap.
**Trace**: ADV-P1-029; NFR-R-NEW-1

---

### X.5 Worklogs & Duration

#### BC-X.5.001: `client.add_worklog(key, seconds, message)` POSTs `/issue/<key>/worklog`; returns Worklog; accepts 201

**Confidence**: HIGH
**Source**: `tests/worklog_commands.rs:~8`
**Trace**: Pass 3 BC-501

---

#### BC-X.5.002: `client.list_worklogs(key)` paginates via `/issue/<key>/worklog` [MUST-FIX: NFR-R-A — HIGH]

**Confidence**: HIGH
**Source**: `src/api/jira/worklogs.rs:~25` (BUG SITE)

> **MUST-FIX (HIGH — NFR-R-A):** Current code fetches ONE `OffsetPage<Worklog>` and discards
> `total`/`start_at`/`max_results`. Issues with >50 worklogs silently truncate. This contract
> describes the FIXED behavior.

**Spec contract (fixed behavior):**
`list_worklogs` MUST paginate in a loop until `page.total <= page.start_at + page.items().len()`. All pages concatenated and returned to caller. No silent truncation.

**Holdout:** H-045 — `list_worklogs` pagination — all pages returned.
**Trace**: Pass 3 BC-502; NFR-R-A; Pass 4 R4 §1.1

---

#### BC-X.5.003: `worklog list` 5xx → exit 1 + `API error (500)`

**Confidence**: HIGH
**Source**: `tests/worklog_commands.rs:~55`
**Trace**: Pass 3 BC-503

---

#### BC-X.5.004: `worklog list` 401 → exit 2 + `Not authenticated` + `jr auth login`

**Confidence**: HIGH
**Source**: `tests/worklog_commands.rs:~95`
**Trace**: Pass 3 BC-504

---

#### BC-X.5.005: `parse_duration_validate("1w2d3h30m")` accepts combined units (validator — production path only)

**Confidence**: HIGH
**Source**: `src/duration.rs::tests::test_complex`
**Subject**: Duration
**Behavior**: Distinguished from JQL `validate_duration` which rejects combined units. Used for worklog add. `parse_duration_validate("1w2d3h30m")` is the sole production path. Note: the 3-arg `parse_duration(s, hours_per_day, days_per_week)` calculator was deleted in S-3.10 — it had no production caller after S-2.06 v2.0.0 and was retained only for the `format_duration` round-trip proptest, which has been rewritten to not depend on it.
**Trace**: Pass 3 BC-505

---

#### BC-X.5.006: `parse_duration` is case-insensitive (input lowercased first)

**Confidence**: HIGH
**Source**: `src/duration.rs:~6`
**Trace**: Pass 3 BC-506

---

#### BC-X.5.007: `parse_duration("")` errors `Duration cannot be empty`

**Confidence**: HIGH
**Source**: `src/duration.rs:~7`
**Trace**: Pass 3 BC-507

---

#### BC-X.5.008: `parse_duration("5")` errors `Number without unit`

**Confidence**: HIGH
**Source**: `src/duration.rs:~38`
**Trace**: Pass 3 BC-508

---

#### BC-X.5.009: `worklog add` forwards the user-supplied duration string to Jira as `timeSpent`

**Confidence**: HIGH
**Source**: `src/cli/worklog.rs::handle_add` + `src/api/jira/worklogs.rs::add_worklog` + `src/duration.rs::parse_duration_validate`
**Subject**: Duration
**Behavior**: `worklog add` forwards the user-supplied duration string to Jira as `timeSpent`. Jira's server applies its configured `workingHoursPerDay`/`workingDaysPerWeek`. `parse_duration_validate` is a client-side syntax validator only (no arithmetic). Resolves NFR-R-C silent-wrong-answer on customized instances. RESOLVED via S-2.06 v2.0.0 (PR #308 / c8f15d8 / D-010 / Option 1 pivot).
**Trace**: Pass 3 BC-1014 (R4)

---

#### BC-X.5.010: Duration proptest: `valid_single_units_always_parse`; `combined_units_always_parse`; `garbage_input_never_panics`; `format_roundtrip` (sub-day)

**Confidence**: HIGH
**Source**: `src/duration.rs:~128`
**Trace**: Pass 3 BC-1099..BC-1102 (R4)

---

### X.6 Teams

#### BC-X.6.001: `client.get_org_metadata(hostname)` POSTs GraphQL `tenantContexts` query to `/gateway/api/graphql`

**Confidence**: HIGH
**Source**: `tests/team_commands.rs:~8`
**Subject**: Teams
**Behavior**: Returns `TenantContext { org_id, cloud_id }` (ADR-0005).
**Trace**: Pass 3 BC-601

---

#### BC-X.6.002: `client.list_teams(orgId)` GETs `/gateway/api/public/teams/v1/org/<orgId>/teams`

**Confidence**: HIGH
**Source**: `tests/team_commands.rs:~28`
**Trace**: Pass 3 BC-602

---

#### BC-X.6.003: `team list` 5xx → exit 1; 401 → exit 2; standard error paths

**Confidence**: HIGH
**Source**: `tests/team_commands.rs:~62-`
**Trace**: Pass 3 BC-603, BC-604

---

#### BC-X.6.004: `team list` cache-first (7d TTL); `--refresh` forces re-fetch

**Confidence**: MEDIUM
**Source**: `src/cache.rs`
**Trace**: Pass 3 BC-605

---

### X.7 Users [BC-X.7.007..010 added 2026-09-06 issue #674 — `@Name`/bracket-form mention resolution for the markdown-mentions feature]

#### BC-X.7.001: `user search Q` GETs `/rest/api/3/user/search?query=Q`

**Confidence**: HIGH
**Source**: `tests/user_commands.rs`; `tests/all_flag_behavior.rs:~155`
**Trace**: Pass 3 BC-701

---

#### BC-X.7.002: `jr user list` resolves `--project` via local flag → global flag → configured project default (`Config::project_key`) → exit 64; once resolved, calls `/rest/api/3/user/assignable/multiProjectSearch?projectKeys=<resolved project key>`

> **Previous version (pre-cycle-014, spec 2.3.2):** H1 was `user list --project P` calls `/rest/api/3/user/assignable/multiProjectSearch?projectKeys=P` — accurate for the pre-fix shape, where `UserCommand::List.project` was a clap-required `String`, the sole source of `P`: no global-flag fallback, no config default, no `jr`-level exit-64 (an absent flag was rejected by clap itself, exit 2). Source/Trace at that time: `tests/all_flag_behavior.rs:~260-`; Pass 3 BC-704.

**Confidence**: HIGH
**Source**: `tests/all_flag_behavior.rs:~260-`; `tests/user_commands.rs::user_list_requires_project_flag` (isolation to be added, no rename — human-accepted at the F1 gate, cycle-manifest Open Question 8: under the required hermetic setup its assertion, that stderr mentions `--project`, still accurately describes what the test checks); `src/cli/mod.rs::UserCommand::List.project` (type change `String` → `Option<String>`, to be modified cycle-014); `src/cli/user.rs::{handle,handle_list,resolve_user_list_project}` (`&Config` threading + new pure resolver, to be implemented cycle-014); `src/main.rs`'s `Command::User` dispatch arm (`&Config` threading only, to be modified cycle-014); `src/config.rs::Config::project_key` (reused, unmodified).
**Subject**: Users — `user list` project resolution (issue #862)
**Behavior**: `jr user list` needs a resolved project key before it can call
`/rest/api/3/user/assignable/multiProjectSearch?projectKeys=P`.

Root cause (verified directly against `src/cli/mod.rs::UserCommand::List.project`, `src/cli/user.rs::handle_list`, and the `clap_builder` parser source — not a hypothesis): `UserCommand::List.project` is typed `String`, clap-REQUIRED — the only subcommand-local `--project` field in the entire CLI surface with this typing. clap 4.6.7's parse sequence (`_do_parse`: `get_matches_with` runs required-argument validation, THEN `propagate_globals` copies a global-position value into same-ID local fields) validates required arguments BEFORE propagating global values, so `jr --project FOO user list` exits 2 before propagation ever gets a chance to fill the local field. `handle_list` (`src/cli/user.rs`) also has no `Config`-backed fallback for a missing project — there is no config default path today at all.

Fix:
1. `UserCommand::List.project` becomes `Option<String>` (`src/cli/mod.rs`) — only the type
   changes; the field keeps its existing `#[arg(long, short = 'p')]` attribute, including
   `short = 'p'`, unmodified (`src/cli/mod.rs` ~L1147). The field's help text (doc comment on
   `src/cli/mod.rs::UserCommand::List.project`, `~L1146`, currently "Project key (e.g., FOO)") is
   also updated to state the fallback order, modeled on `ComponentSubcommand::List`'s wording
   (quoted verbatim below) (`src/cli/mod.rs` ~L1287-1288: "Project key (overrides the configured default
   project). Required when no project is configured in `.jr.toml`."). `user list`'s new help
   text cannot reuse that string byte-for-byte, though: `ComponentSubcommand::List`'s help text
   names only `.jr.toml`, understating its own behavior — `handle_list` (`src/cli/component.rs`
   ~L188) calls `Config::project_key` (`src/config.rs` ~L423-428), which also falls back to the
   active profile's configured `project` default, so `component list` behaves the same way;
   only its help text understates that. `user list`'s new help text names both sources
   explicitly. Pinned exact new string:
   "Project key (overrides the configured default project). Required when no project is
   configured in `.jr.toml` or the active profile." — asserted by VP-USER-LIST-PROJECT-001's
   `--help` cell.
2. Once required-argument validation no longer blocks it, clap's existing global-value propagation (`fill_in_global_values`) fills the local field automatically whenever only the global `--project` is given; when both local and global are given, the local (child) value wins and that value propagates back up to the shared global-position arg. Both behaviors are clap's own mechanism — no `jr`-level local-vs-global merge code is written for this half of the resolution.
3. `cli::user::handle` gains a `&Config` parameter, threaded through to `handle_list` for the config-default fallback step. `src/main.rs`'s `Command::User` arm passes the `config` binding it already constructs (`Config::load_with(cli.profile.as_deref())`) through unchanged. `handle`/`handle_list` MUST NOT call `Config::load`/`Config::load_with` themselves — reloading would ignore the `--profile`/`JR_PROFILE` selection already resolved into that binding.
4. A pure resolver is extracted in `src/cli/user.rs`, matching `src/cli/field.rs::resolve_m2_project`'s signature style:
   `pub(crate) fn resolve_user_list_project(cli_project: Option<&str>, config: &Config) -> Option<String>` = `config.project_key(cli_project)`.
   `handle_list` calls this resolver with the post-clap local field value (which already reflects local-vs-global precedence) and exits 64 on `None`.
5. Passing `cli.project` from `main.rs` through to the handler as a separate fallback parameter (the pattern every other project-bearing dispatch arm uses — verified directly against `src/main.rs`: `Project`, `Issue`, `Board`, `Sprint`, `Queue`, `RequestType`, `Field`, and `Component`, each passing `cli.project.as_deref()` as an explicit parameter alongside `command`/`config`/`client`; `Worklog`, `Team`, `User`, `Api`, `Assets`, `Me`, among others, do not) is unnecessary: by the time any handler runs, clap has already resolved `project` to local-or-global on the `UserCommand::List` variant itself.

Resolution order, evaluated entirely in-process before any HTTP call:
1. **Local `--project`** — supplied after `user list` on the command line; fills `UserCommand::List.project` directly.
2. **Global `--project`** — supplied before the subcommand; fills the local field via clap's propagation whenever (1) is absent.
3. **Configured project default** — `Config::project_key`'s existing fallback chain (per `src/config.rs`: the per-project `.jr.toml` `project` key first, then the active profile's configured `project` default); consulted only when (1) and (2) are both absent.
4. **Exit 64** — `JrError::UserError`, when none of (1)-(3) resolve a project, before any HTTP call. `config::validate_profile_name`, `Config::load_with` (e.g. unknown profile, malformed config) and `JiraClient::from_config` failures all preempt this step; some of these also exit 64.

This is the same config-default-fallback shape `jr component list`/`jr component edit`/`jr component delete` already use (`src/cli/component.rs::handle`'s `List` arm: `project.as_deref().or(project_flag)`, then `handle_list`'s `config.project_key(project)` — `handle_list`'s own `project` parameter is
already `Option<&str>`, so no `.as_deref()` call appears at this call site. `handle_edit`/
`handle_delete` instead receive an owned `project: Option<String>` (the `Edit`/`Delete` arms in
`handle` perform no local/global merge at all — see below) and call
`config.project_key(project.as_deref())` internally, where the `.as_deref()` converts that owned
field to the `Option<&str>` the shared `project_key` signature expects), and the same one `jr field options --type` (BC-X.14.001's M2 project resolution step), `jr queue`, and `jr requesttype` already use for their own config-default fallback. BC-8.1.004 covers ONLY the no-project-configured exit-64 condition — it does not itself specify local-over-global precedence. The actual local-over-global precedent for `component list`/`create` lives in the code (`src/cli/component.rs::handle`'s `List` arm — `project.as_deref().or(project_flag)` — and `Create` arm — `project.or_else(|| project_flag.map(str::to_string))`, local checked first, global consulted only as a fallback), not in a shared BC-level contract. `component edit`/`delete` rely on the same clap global-value-propagation mechanism `user list` now will (no explicit `.or()`/`or_else()` merge call in those arms). Local wins over global when both are supplied (`jr --project GLOBAL user list --project LOCAL` resolves `LOCAL`) — via clap's propagation, producing the same observable result as `component create`'s explicit local-over-global code.

**Preconditions**:
- `jr user list` invoked with any combination of: local `--project`, global `--project`, a configured `.jr.toml`/profile-default project, or none of the three.
- `tests/user_commands.rs::user_list_requires_project_flag` and the new EC-X.7.002-4 regression test are CONFIG-SENSITIVE once this BC lands, because `Config::project_key` reads both the active profile's configured default and any `.jr.toml` found by `find_project_config`'s cwd-and-ancestors walk (`src/config.rs`). Both tests MUST set `JR_CONFIG_DIR`/`JR_CACHE_DIR` to a fresh `TempDir` and run from a `cwd` with no `.jr.toml` in any ancestor directory, in addition to supplying auth (`JR_AUTH_HEADER`/`JR_BASE_URL`, as `user_list_requires_project_flag` already does) — otherwise a real developer/CI environment with a configured default project would silently resolve step 3 and the exit-64 assertion would spuriously fail. Both tests MUST also clear every ambient `JR_`-prefixed variable EXCEPT the hermetic seams the test sets (`JR_CONFIG_DIR`, `JR_CACHE_DIR`, `JR_BASE_URL`, `JR_AUTH_HEADER`), per `.factory/cycles/cycle-014/phase-f2-spec-evolution/verification-delta.md` §2, since `Config::load_inner`'s (`src/config.rs`) two env-reading sites — `Figment::new()...merge(Env::prefixed("JR_"))`, which lets any stray `JR_`-prefixed variable in the ambient shell silently override a `GlobalConfig` field, and the separate `std::env::var("JR_PROFILE")` read that resolves the active profile name — would otherwise leak an ambient value in. An ambient `JR_PROFILE` pointing at a profile with its own configured project default would silently resolve step 3 the same way an ambient `.jr.toml`/config default would, spuriously masking EC-X.7.002-4's exit-64 assertion. `user_list_requires_project_flag` specifically may keep its existing unreachable `JR_BASE_URL=http://127.0.0.1:1` (no mock server): since a stray request would fail with a connection error rather than a mock response, and its assertion only inspects stderr for `--project`/`required`, an unreachable base URL cannot mask the exit-64 assertion.
- In `src/main.rs`'s `run` function, `config::validate_profile_name` (validating a supplied `--profile` name) runs before command dispatch, and in the `Command::User` arm, `Config::load_with` (e.g. unknown profile, malformed config) then `api::client::JiraClient::from_config(&config, ...)` run and can each fail (`JrError::UserError` for an invalid/unknown profile name, `JrError::ConfigError` for a missing/unknown active profile or a missing profile URL, or `JrError::NotAuthenticated` via keychain/`JR_AUTH_HEADER` credential loading) BEFORE `cli::user::handle`/`handle_list` is ever invoked: `config::validate_profile_name`, `Config::load_with` (e.g. unknown profile, malformed config) and `JiraClient::from_config` failures all preempt this step; some of these also exit 64 — never the reverse. A hermetically-isolated EC-X.7.002-4 test MUST supply valid auth and a valid, known profile precisely so it reaches this BC's own exit-64 path instead of failing earlier on one of these preemption points.

**Postconditions**:
1. Local `--project` present → that value is used, regardless of whether a global `--project` or a configured default is also present (local wins unconditionally).
2. Local `--project` absent, global `--project` present → the global value is used (via clap propagation), regardless of whether a configured default is also present.
3. Both flags absent, a configured default (`.jr.toml` project or profile default) is present → the configured default is used. "Present" here means `Config::project_key`'s underlying `Option` is `Some(_)`, including `Some("")` — an empty-string configured default (`.jr.toml` `project = ""` or profile `project = ""`) counts as present and is used as-is (see EC-X.7.002-7); it is not treated as absent.
4. None of the three present → exit 64 `JrError::UserError`, message naming `--project` (byte-identical to `queue.rs`/`requesttype.rs`'s existing wording: `"No project configured. Run \"jr init\" or pass --project. Run \"jr project list\" to see available projects."`), before any HTTP call (zero requests to `/rest/api/3/user/assignable/multiProjectSearch`).
5. Once resolved (by any of 1-3), every request issued to enumerate users carries `projectKeys=<resolved-key>` — the original H1 wire-call contract, unchanged, but not necessarily "exactly one" request: the default (non-`--all`) path fires exactly one `GET /rest/api/3/user/assignable/multiProjectSearch?projectKeys=<resolved-key>` (BC-X.7.003's single-call legacy contract), while `--all` paginates through one-or-more offset pages of the same endpoint via `src/api/jira/users.rs::search_assignable_users_by_project_all` — every page still carries the same `projectKeys=<resolved-key>` value.

**Invariants**:
- This is a config-merge, pre-HTTP resolution step — no new `Config`/`ProfileConfig` accessor, no new cache file; reuses `Config::project_key` exactly as `component`/`field`/`queue`/`requesttype` already do.
- The failure MECHANISM changes (clap exit 2 → `jr`-level exit 64 on the true no-project case), but the failure FACT does not: an invocation with no project resolvable anywhere still fails, in both the pre-fix and post-fix shape.
- `tests/user_commands.rs::user_list_requires_project_flag` passes once hermetically isolated (no rename — its assertion, stderr contains `"--project"` or `"required"`, matches both the old clap message and the new `JrError::UserError` message) but only with config/cache isolation and auth supplied as described in Preconditions above. Human-accepted at the F1 gate (cycle-manifest Open Question 8): unlike a test whose NAME asserts a mechanism the code doesn't use, this test's name makes no mechanism claim, so its assertion continues to accurately describe what it checks after this fix lands. After this fix lands, the failure it pins is never clap's; its stale `// No server needed — clap should fail before any HTTP call.` comment must be updated accordingly.

**Edge Cases**:
- EC-X.7.002-1: Both local AND global `--project` supplied (`jr --project GLOBAL user list --project LOCAL`) → LOCAL wins, via clap's own global-value propagation (the child/local value wins and propagates back up to the shared global-position arg), not a hand-written `jr`-level precedence check — the same mechanism `component edit`/`delete` rely on (clap propagation only, no explicit `.or()`/`or_else()` merge call in those arms). This produces the same observable result as `component list`/`create`'s explicit local-over-global merge code (`src/cli/component.rs::handle`'s `List` arm — `project.as_deref().or(project_flag)` — and `Create` arm — `project.or_else(|| project_flag.map(str::to_string))`), even though `user list` reaches that result via clap propagation rather than an explicit merge call.
- EC-X.7.002-2: Global `--project` only (`jr --project FOO user list`, no local flag, no configured default) → FOO resolves; this is the exact invocation issue #862 reported as broken (previously exit 2 via clap's own missing-required-argument message).
- EC-X.7.002-3: Configured default only (`.jr.toml` `project = "FOO"` or profile default, no local flag, no global flag) → FOO resolves via `Config::project_key`'s fallback chain.
- EC-X.7.002-4: None of the three present → exit 64 `JrError::UserError` naming `--project`, zero HTTP calls (regression pin for `tests/user_commands.rs::user_list_requires_project_flag`). Must run with `JR_CONFIG_DIR`/`JR_CACHE_DIR` isolated to a fresh `TempDir`, a `cwd` with no ancestor `.jr.toml`, and valid supplied auth — see Preconditions above.
- EC-X.7.002-5: No local flag, no global flag, and `--profile <NAME>` selects a non-default profile that has its own configured project default → the configured default resolved is THAT profile's default, not the `"default"` profile's, ONLY when no `.jr.toml` project exists in cwd or an ancestor (a `.jr.toml` project would win at step 3 ahead of any profile default, per `Config::project_key`'s own fallback order). This holds because `main.rs` loads `config` once via `Config::load_with(cli.profile.as_deref())` before calling `cli::user::handle`, and `handle`/`handle_list` never reload config — the `&Config` passed through already reflects the `--profile`/`JR_PROFILE` selection.
- EC-X.7.002-6: `--project ""` (empty
  string), whether supplied as the local flag or the global flag → passed through as-is and
  resolves the project key to the empty string: `Config::project_key`'s
  `cli_override.map(String::from)` treats `Some("")` as present and returns `Some(String::new())`
  immediately, without consulting the configured default. This is the same pass-through
  `jr queue`/`jr requesttype` already exhibit for an empty `--project` today — there is no
  special-casing of the empty string anywhere in this resolution chain. The resulting
  `projectKeys=` (empty) request is sent as-is; Jira's response, not `jr`, decides whether that
  is an error. This pass-through choice (rather than treating `--project ""` as absent, or
  rejecting it) is settled behavior, human-confirmed 2026-09-25 (D-380) — see "Decisions confirmed
  during F2 review" in `prd-delta.md`.
- EC-X.7.002-7 (informational, no VP cell): a configured empty project (`.jr.toml` `project = ""`
  or profile `project = ""`), with no local or global `--project` flag, resolves at step 3 to
  `Some("")` through `Config::project_key`'s presence-based `Option` chain — no exit 64 fires, and
  the request carries `projectKeys=` (empty). A `.jr.toml` `project = ""` shadows a populated
  profile default, per the normal `.jr.toml`-before-profile fallback order. This is inherited
  `Config::project_key` behavior, shared with `queue`/`requesttype`/`component list` and not
  special-cased for `user list`; treated the same way as EC-X.14.001-14 (informational, no VP
  cell).

**Verification Properties**:
- VP-USER-LIST-PROJECT-001: project-resolution precedence over the 2^3 presence space of
  {local `--project`, global `--project`, configured default} (Postconditions 1-5,
  EC-X.7.002-1..6), plus the zero-HTTP guarantee on the exit-64 path. The local-vs-global half is
  decided by clap's global-value propagation, not by `jr` code; the config-fallback half is the
  pure resolver. Four layers:
  (a) **Clap propagation pin.** An inline `Cli::try_parse_from` unit test in `src/cli/` asserts
  the parsed `UserCommand::List.project` field for all four flag cells:
  `["jr","user","list"]` → `None` (parses successfully, no exit 2);
  `["jr","user","list","--project","L"]` → `Some("L")` (local only);
  `["jr","--project","G","user","list"]` → `Some("G")` (global only fills the local field);
  `["jr","--project","G","user","list","--project","L"]` → `Some("L")` (both given → local
  wins). EC-X.7.002-6 cells: `["jr","user","list","--project",""]` and
  `["jr","--project","","user","list"]` → `Some("")` (empty string passes through, not
  collapsed to `None`). Short-alias cells for the retained local `short = 'p'`:
  `["jr","user","list","-p","L"]` → `Some("L")`; `["jr","--project","G","user","list","-p","L"]`
  → `Some("L")` (local short form wins over the global long form). The global `--project`
  (`src/cli/mod.rs::Cli.project`, `#[arg(long, global = true)]`) has no short form, so there is
  no global `-p` cell. A clap upgrade that changes propagation, or dropping the local `-p`
  alias, fails this test.
  (b) **Pure resolver proptest.** A `proptest!` on
  `pub(crate) fn resolve_user_list_project(cli_project: Option<&str>, config: &Config) ->
  Option<String>` (`src/cli/user.rs`), with distinct arbitrary non-empty keys `C`, `J` (`.jr.toml`
  project, `config.project.project`) and `P` (active profile's `project`), over the presence
  cells of `cli_project` × {neither, `.jr.toml`-only, profile-only, both} configured sources:
  `cli_project = Some(C)` → `Some(C)` in every configured cell; `cli_project = None` →
  `.jr.toml`-only → `Some(J)`, profile-only → `Some(P)`, both → `Some(J)` (`.jr.toml` wins over the
  profile default, EC-X.7.002-5's caveat), neither → `None` — the only result that maps to exit
  64. EC-X.7.002-6 cell: `cli_project = Some("")` → `Some(String::new())` in every configured
  cell (the configured default is not consulted). Together with (a), this covers the full 2^3
  presence space.
  (c) **Wiring layer (wiremock integration).** Every test here is hermetic per cycle-014
  `verification-delta.md` §2 (a case that needs a `.jr.toml` writes it into its own temp `cwd`),
  so it reaches this BC's own exit-64 path rather than failing earlier on auth. Cases:
  EC-X.7.002-1 (both flags → one request with `projectKeys=LOCAL`); EC-X.7.002-2 (global only →
  `projectKeys=FOO`); EC-X.7.002-3 split three ways: `.jr.toml`-only (temp `cwd` containing
  `.jr.toml` `project = "JRT"`, profile has no `project` → `projectKeys=JRT`), profile-only (temp
  `config.toml` profile `project = "FOO"`, no `.jr.toml` → `projectKeys=FOO`), and both
  (`.jr.toml` `project = "JRT"` plus profile `project = "FOO"` → exactly one request with
  `projectKeys=JRT`, `.expect(0)` on a `projectKeys=FOO` mock); EC-X.7.002-4 (none → exit 64,
  stderr contains the pinned message `No project configured. Run "jr init" or pass --project.
  Run "jr project list" to see available projects.`, `.expect(0)` on `multiProjectSearch`;
  `tests/user_commands.rs::user_list_requires_project_flag` is made hermetic the same way);
  EC-X.7.002-5 (temp `config.toml` with profile `default` → `project = "DEF"` and profile `alt`
  → `project = "ALT"`, both URLs at the mock server, no `.jr.toml`, `jr --profile alt user list`
  with no `--project` → exactly one request with `projectKeys=ALT`, `.expect(0)` on a
  `projectKeys=DEF` mock); EC-X.7.002-6 (profile `project = "FOO"` configured, `jr user list
  --project ""` → exactly one request whose `projectKeys` value is the empty string,
  `.expect(0)` on a `projectKeys=FOO` mock). `--all` pagination
  (Postcondition 5): two tests on the three-page pattern of
  `tests/user_pagination.rs::user_list_all_cli_paginates` (`startAt=0` → 100 users,
  `startAt=100` → a short non-empty page, `startAt=200` → empty; each mock matched on
  `query_param("projectKeys", "FOO")` with `.expect(1)`), one with the global flag
  (`jr --project FOO user list --all`) and one with the configured default (`jr user list
  --all`). Each also mounts a `query_param_is_missing("projectKeys")` catch-all with
  `.expect(0)` and asserts every received request carries exactly one `projectKeys=FOO` pair.
  The non-`--all` path keeps BC-X.7.003's single-request contract.
  (d) **Help-text pin.** `--help` cell (Fix step 1's pinned help text): `jr user list --help` exits 0, and its stdout,
  with every whitespace run collapsed to one space, contains both `Project key (overrides the
  configured default project). Required when no project is configured in` and `or the active
  profile`. The pin deliberately excludes the `.jr.toml` token between those two substrings (clap
  renders doc-comment backticks literally, but the pin stays independent of that) and the
  trailing period (clap_derive strips the trailing period of a single-paragraph doc comment, as
  `jr component list --help` shows). Help-text drift fails this cell.
  **Fault model (killed by example/proptest):** (1) the resolver body replaced (`-> None`,
  `-> Some(String::new())`, a constant key) — killed by (b)'s cells expecting the exact key;
  (2) `handle_list` bypassing the resolver (reading only the post-clap field, never consulting
  `Config`) — killed by the EC-X.7.002-3 and configured-default `--all` tests; (3) the handler
  reloading config instead of using the passed `&Config` — killed by the EC-X.7.002-5 test,
  since a reload resolves `"default"` and sends `projectKeys=DEF`; (4) the resolved key applied
  to page 1 only — killed by the `--all` tests; (5) an empty-string special case (`Some("")`
  treated as absent) — killed by (a)/(b)'s EC-X.7.002-6 cells and the EC-X.7.002-6 wiring test.

**Trace**: issue #862; `.factory/cycles/cycle-014/phase-f1-delta-analysis/delta-analysis.md`
§Item #862; `src/cli/component.rs::handle` List/Create arms (the actual local-over-global
precedent — explicit code: `project.as_deref().or(project_flag)` (List) /
`project.or_else(|| project_flag.map(str::to_string))` (Create), local checked first, global
consulted only as a fallback) and Edit/Delete arms (clap global-value propagation only, no
explicit merge call — the same mechanism `user list` now relies on); BC-8.1.004 (covers ONLY the
no-project-configured exit-64 condition — it does NOT itself specify local-over-global
precedence); BC-X.14.001 "M2 project resolution step" (companion-flag-or-default precedent);
Pass 3 BC-704

---

#### BC-X.7.003: `user list` (default, no --all) uses single-call legacy path; no startAt/maxResults params

**Confidence**: HIGH
**Source**: `tests/all_flag_behavior.rs:~271`
**Behavior**: `query_param_is_missing("startAt")` assertion.
**Trace**: Pass 3 BC-705

---

#### BC-X.7.004: Duplicate display names + `--no-input` → exit non-zero; stderr shows emails + accountIds + duplicate name

**Confidence**: HIGH
**Source**: `tests/duplicate_user_disambiguation.rs:~21`
**Subject**: Users
**Behavior**: Three users "John Smith" x2 + "John Smithson" → disambiguation shows only the two Smiths (not Smithson).
**Trace**: Pass 3 BC-706..BC-708

---

#### BC-X.7.005: `user view <id>` → 404 → friendly `"User with accountId '<id>' not found"` exit 64

**Confidence**: HIGH
**Source**: `tests/user_commands.rs` BC-1132i
**Trace**: Pass 3 BC-1132i (R4)

---

#### BC-X.7.006: `user search --all` advances startAt by REQUESTED maxResults (JRACLOUD-71293 workaround)

**Confidence**: HIGH
**Source**: `tests/user_pagination.rs:~202`
**Trace**: Pass 3 BC-1119 (R4)

---

#### BC-X.7.007: `@Name` mention candidate resolves to a UNIQUE, NAME-MATCHING Jira user via `GET /rest/api/3/user/search?query=<Name>` → silently converted to a mention node (happy path); a lone result whose display name does NOT name-match the query is filtered out before resolution and hard-errors instead

**Confidence**: HIGH
**Source**: `src/api/jira/users.rs::JiraClient::search_users` (reused as-is — same endpoint BC-X.7.001 already specifies); `src/cli/issue/helpers.rs::disambiguate_user` (reused, UNCHANGED, visibility bumped to `pub(super)`); `src/cli/issue/mentions.rs::filter_by_name_match` (NEW, human-approved F2 TIGHTENING decision, mechanism finalized by the architect as Option (a)); issue #674
**Subject**: Users — `@Name` mention resolution (unique-match happy path, name-match tightened)

**Description**: The new effectful resolver (proposed home: `src/cli/issue/mentions.rs::resolve_mentions`, per `delta-analysis.md` §2 — a NEW FILE, not an extension of `helpers.rs`, per the architect's file-size rationale) takes the set of `@Name` candidates `find_mention_candidates` (BC-7.2.018) found in a comment/description body and, for each UNIQUE candidate token (deduplicated before any network call — a body mentioning the same `@jsmith` three times costs one search call, not three), calls `client.search_users(name)` (the SAME unscoped `/rest/api/3/user/search?query=` endpoint BC-X.7.001 already specifies — deliberately NOT `search_assignable_users_by_project`/`multiProjectSearch`, since a mentioned user need not be assignable to the issue's project, per `artifact-mapping.md` §1.2's explicit "cited so F2 doesn't accidentally reuse the wrong resolver" note).

**Behavior**:
1. Filter results to `active == Some(true)` (mirrors `resolve_user`'s existing convention).
2. **NEW — `filter_by_name_match` (human-approved F2 TIGHTENING decision, resolves EC-X.7.007-5's former OPEN DECISION, mechanism finalized by the architect, Option (a))**: a pure step, `filter_by_name_match(active_users, query) -> Vec<User>`, runs BETWEEN the active-filter (point 1) and the `disambiguate_user` call (point 3 below). It keeps only the users whose `display_name` name-matches `query`, reusing `partial_match`'s existing matching semantics and precedence UNCHANGED (applied here as a caller-side pre-filter rather than a change inside `disambiguate_user`): a case-insensitive EXACT match on `display_name` takes precedence and, when present, is the sole basis for keeping a candidate; only when no candidate exact-matches does the filter fall back to `partial_match`'s case-insensitive SUBSTRING check to decide what survives. `disambiguate_user` itself is UNCHANGED — every other caller (`resolve_user`/`resolve_assignee`/`resolve_assignee_by_project`) is unaffected; only the mention resolver's call site inserts this pre-filter.
3. Pass the filtered (active AND name-matching) candidate list to `disambiguate_user(&filtered_users, name, no_input, empty_msg, none_msg_fn)` (bumped from private `fn` to `pub(super) fn`, per `delta-analysis.md` §1's "MODIFIED (visibility only)" note) — the EXACT SAME function `resolve_user`/`resolve_assignee`/`resolve_assignee_by_project` already call, no new disambiguation algorithm.
4. **Resolution branch, corrected (cycle-005 F2 pass-2 adversarial review M-1) and tightened (F2 human gate)**: `disambiguate_user` (`src/cli/issue/helpers.rs`) short-circuits `if users.len() == 1 { return Ok((users[0].account_id.clone(), users[0].display_name.clone())); }` at lines ~280-282 — BEFORE `partial_match`/`MatchResult::Exact` ever runs (that match statement, lines ~284-286 onward, is only reached when `users.len() >= 2`). Because point 2's `filter_by_name_match` step has already reduced the list to name-matching users only, this `len()==1` short-circuit now ALWAYS resolves a name-matching result — a fuzzy hit that does not name-match never reaches this branch at all (it was filtered out at point 2, see EC-X.7.007-5). `MatchResult::Exact` is reached only when the filtered search returns 2+ name-matching active users AND exactly one of them exact-matches `name` case-insensitively; that is a real but less common path through the same function. Either way the resolver records `MentionResolutions[@Name span] = {account_id, display_name}` from whichever branch returned `Ok`.
5. This resolution result feeds BC-7.2.016/017's pure emitter — `markdown_to_adf_with_mentions` converts the matched `@Name` span into `{"type":"mention","attrs":{"id":"<account_id>","text":"@<display_name>"}}`.

**Behavioral contract — search outcome to result (tightened, F2 human gate)**:

| Search outcome | Result |
|---|---|
| Zero results | HARD ERROR exit 64 (BC-X.7.009) |
| Single result, name matches (case-insensitive substring) | Resolves (BC-X.7.007) |
| Single result, name does NOT match | HARD ERROR exit 64 — NEW, same empty-list branch/substring as zero-match |
| Multiple matches after reduction | Ambiguous (BC-X.7.008) |

**Edge Cases**:
- **(EC-X.7.007-1) Deduplication**: a description mentioning `@jsmith` three times issues exactly ONE `GET /rest/api/3/user/search?query=jsmith` call; all three occurrences resolve from the same cached result within the single command invocation (no cross-invocation cache — this is a per-invocation, in-memory dedup only, distinct from `src/cache.rs`'s persistent XDG cache families).
- **(EC-X.7.007-2) Case-insensitive exact match — reached only on 2+ name-matching active results** (corrected, cycle-005 F2 pass-2 adversarial review M-1; scope narrowed by the F2 tightening decision): `disambiguate_user`'s `MatchResult::Exact` branch matches case-insensitively (per `partial_match::partial_match`'s existing behavior) — but per point 4 above, this branch is reached ONLY when the point-2-filtered (active AND name-matching) search returns 2+ users; on a lone result the `len()==1` short-circuit resolves without ever consulting `partial_match` inside `disambiguate_user` — and, since the tightening, that lone result is now GUARANTEED to be a name match (point 2 already excluded any non-matching lone hit), not merely assumed to be one. See EC-X.7.007-5 for the non-matching case.
- **(EC-X.7.007-3) Deactivated users excluded — via the EMPTY-LIST branch, not `MatchResult::None`** (corrected, pass-1 adversarial review CRIT-1): an `@Name` candidate that only matches a deactivated Jira user (`active == Some(false)`) is filtered out of the active-user list BEFORE `disambiguate_user` is called. Because the filtered list handed to `disambiguate_user` is then EMPTY, this hits the `if users.is_empty()` branch (`src/cli/issue/helpers.rs::disambiguate_user`, lines ~276-278) — NOT the `MatchResult::None` branch (lines ~365-367), which only fires on a NON-empty list with no name-level match. It falls through to the zero-match hard-error path (BC-X.7.009) via that empty-list branch specifically, NOT a silent resolve to a deactivated account. See BC-X.7.009's corrected mechanism description and EC-X.7.009-4 for the full empty-list-vs-`None` distinction.
- **(EC-X.7.007-4) Bot/app accounts are NOT filtered out — intentional, not accidental** (pass-1 adversarial review LOW-1): point 1's filter is `active == Some(true)` ONLY. A Jira `userType: "app"` account (a bot/integration/Connect-app user) that is active and matches `@Name` resolves and is mentioned exactly like a human user — `jr` does not additionally filter on `userType`/`accountType`. This is a DELIBERATE product decision, not an oversight: a user may legitimately want to `@`-mention a bot/app account (e.g. to trigger an integration's own mention-based automation, or to loop in a service account a team treats as a pseudo-teammate), and Jira's `/rest/api/3/user/search` response does not reliably expose `accountType` in a way every caller can branch on without an additional shape check. If a future cycle decides bot/app accounts should be excluded by default, that is a NEW, separately-specified BC (with its own `--include-bots`-style opt-in/opt-out flag design), not a silent addition to this BC's filter.
- **(EC-X.7.007-5) Fuzzy single-hit that does NOT name-match is now a HARD ERROR, not a silent resolve — RESOLVED at the F2 human gate (human-approved TIGHTENING decision; mechanism finalized by the architect as `filter_by_name_match`, Option (a); supersedes this edge case's former "OPEN DECISION for the F2 human gate" framing)**: because `client.search_users(name)` performs a server-side FUZZY match (not an exact-name lookup), a query can return exactly ONE active result whose display name does NOT contain the query string at all — e.g. `@jsmith` → the search API's fuzzy ranking returns a sole active hit `"John Smith"`. Per point 2's `filter_by_name_match` step, this candidate is now filtered OUT before `disambiguate_user` is ever called: the resulting list is EMPTY, and the mention resolver falls into `disambiguate_user`'s empty-list branch — the SAME zero-match hard-error CODE PATH a genuine zero-result search takes (BC-X.7.009), and mechanically identical to EC-X.7.007-3/EC-X.7.009-4's deactivated-only-match case. **The error MESSAGE is NOT identical, however (cycle-005 F2 pass-5 M-2)**: this scenario's sole hit ("John Smith") IS active — only its name failed to match — so the resolver MUST select BC-X.7.009 point 2's wording **(iii)** (neutral "No user found matching…", no deactivated hint), not wording **(ii)** (the EC-X.7.007-3/EC-X.7.009-4 deactivated-only case) — using (ii)'s wording here would falsely tell the user a real account exists but is deactivated, when in fact it's active and simply didn't name-match. **This is a deliberate behavior change from the pre-tightening status quo, scoped to the mention resolver only**: every OTHER `disambiguate_user` caller (`resolve_user`, `resolve_assignee`, `resolve_assignee_by_project`) retains the untouched single-result-no-verification property — `filter_by_name_match` is inserted ONLY at the mention resolver's call site, per the human's decision that a mention's real-world side effect (a notification to a third party) warrants a stricter contract than plain issue-assignment resolution. See VP-674-021 for the discriminating wiremock test (matching vs. non-matching single result) and H-NEW-MENTION-012 for the corresponding holdout scenario.

**Verification Properties**:
- VP-674-002 (shared with BC-7.2.017): example-based happy-path resolution, asserting the correct accountId and `attrs.text`.
- VP-674-009: `@Name` unique-match resolution — wiremock test asserting exactly ONE `GET /rest/api/3/user/search` call for N repeated occurrences of the same `@Name` in one body.
- `VP-674-021` — single-result name-match tightening (§6): wiremock/CLI-integration — `query=jsmith` returning exactly ONE user `{"displayName":"John Smith", "active": true}` (name does NOT contain "jsmith") → exits 64 with `"No user found matching"` and ZERO POST/PUT, AND asserts the message does NOT contain the deactivated-hint substring `"deactivated"` (cycle-005 F2 pass-5 M-2 — confirms BC-X.7.009 point 2(iii)'s neutral wording is used, not (ii)'s, since the sole hit is active); `query=smith` returning the same single "John Smith" (name DOES contain "smith") → resolves. Guards against regression to the `disambiguate_user` len==1 short-circuit.

**Trace**: `src/api/jira/users.rs::JiraClient::search_users`; `src/cli/issue/helpers.rs::disambiguate_user` (visibility bump, `pub(super)`, UNCHANGED); `src/cli/issue/mentions.rs::filter_by_name_match` (NEW, F2 tightening); BC-X.7.001 (endpoint precedent); issue #674

[NEW 2026-09-06 issue #674 F2]

---

#### BC-X.7.008: `@Name` mention candidate resolving to TWO OR MORE candidates → disambiguation, reusing BC-X.7.004's contract shape verbatim (interactive `dialoguer::Select` prompt / `--no-input` exit 64 with candidate list)

**Confidence**: HIGH
**Source**: `src/cli/issue/helpers.rs::disambiguate_user` (`MatchResult::ExactMultiple`/`MatchResult::Ambiguous` arms); BC-X.7.004 (contract-shape precedent); issue #674
**Subject**: Users — `@Name` mention resolution (ambiguous-match disambiguation)

**Description**: When `@Name`'s user-search result disambiguates to `MatchResult::ExactMultiple` (two or more users share the exact same display name, case-insensitive) or `MatchResult::Ambiguous` (one or more non-exact substring hits), the mention resolver reuses `disambiguate_user`'s EXISTING behavior verbatim — no new disambiguation UX is invented for mentions.

**Behavior**:
1. **Non-interactive** (`no_input == true`): exit 64 (`JrError::UserError`), stderr lists each duplicate/ambiguous candidate with display name + email (or accountId when email is hidden) — the identical wording `disambiguate_user`'s `ExactMultiple`/`Ambiguous` branches already produce for `resolve_user`/`resolve_assignee`/`resolve_assignee_by_project` (`"Multiple users named \"{name}\" found:\n{lines}\nSpecify the accountId directly or use a more specific name."` for `ExactMultiple`; `"Multiple users match \"{name}\": {matches}. Use a more specific name."` for `Ambiguous`).
2. **Interactive** (TTY, `no_input == false`): `dialoguer::Select` prompt listing the candidates, identical mechanics to every other `disambiguate_user` caller.
3. **Zero-POST guarantee — non-interactive (or otherwise unresolvable) ambiguity only** (corrected, pass-1 adversarial review MED-3 — this point previously contradicted point 2 above): exactly like BC-3.3.005's assignee-not-found precedent, a NON-INTERACTIVE (or otherwise unresolvable — e.g. an interactive prompt that is aborted/produces no selection) ambiguous `@Name` mention candidate stops the whole comment/description write SHORT of the POST/PUT — the entire body's mention resolution is all-or-nothing (mirrors the field-resolution "all-or-nothing" convention already established for BC-3.3.010/BC-3.4.015's `--field` resolution). This is NOT in tension with point 2: an INTERACTIVE ambiguous match PROCEEDS to a resolved mention once the `dialoguer::Select` prompt is answered, and the write continues normally. A single ambiguous `@Name` among several otherwise-resolvable candidates fails the WHOLE write, not just that one mention, only in the write-stopping (non-interactive/unresolved) case.
4. **`--no-mentions` bypass**: this entire resolution step (and therefore this BC) is skipped when `--no-mentions` is passed — see BC-7.2.016 point 7.

**Edge Cases**:
- **(EC-X.7.008-1) `@Name` disambiguation error surfaces before any HTTP mutation**: same ordering discipline as `resolve_assignee_by_project`'s existing pattern — the resolution step runs entirely BEFORE the comment `POST`/create `POST`/edit `PUT` call, so an ambiguous mention never leaves a partially-written comment/description.
- **(EC-X.7.008-2) Reuses BC-X.7.004's exact stderr wording**: no new message strings are introduced — test-writer should assert against the SAME substrings `tests/duplicate_user_disambiguation.rs` already pins for `resolve_user`, applied to the new mention call site.

**Verification Properties**:
- VP-674-003: example-based — duplicate display names reuses BC-X.7.004's exit/stderr contract verbatim (no new disambiguation UX invented); asserted against the mention resolver call site specifically, not just the pre-existing `resolve_user` callers.
- VP-674-010 (partial — ambiguous half): `@Name` ambiguous exit-64 taxonomy, non-interactive AND interactive branches, exercised via the mention resolver.

**Trace**: `src/cli/issue/helpers.rs::disambiguate_user`; BC-X.7.004 (contract-shape source); `tests/duplicate_user_disambiguation.rs` (closest existing test-style analog per `artifact-mapping.md` §3); issue #674

[NEW 2026-09-06 issue #674 F2]

---

#### BC-X.7.009: `@Name` mention candidate resolving to ZERO Jira users → HARD ERROR, exit 64 (human-approved decision; supersedes the architect's pass-through recommendation)

**Confidence**: HIGH on the mechanism (reuses `disambiguate_user`'s two pre-existing zero-outcome arms — the empty-list branch and `MatchResult::None` — verbatim, both already proven by every other `disambiguate_user` caller; see the Mechanism correction below for which of the two the real-world scenarios actually take); the POLICY choice itself (hard error vs. pass-through) is a human decision, not a technical inference — see the note below.
**Source**: `src/cli/issue/helpers.rs::disambiguate_user` (BOTH the `if users.is_empty()` empty-list arm, lines ~276-278 — already returns `Err(JrError::UserError(empty_msg.to_string()).into())` — AND the `MatchResult::None(all_names)` arm, lines ~365-367 — already returns `Err(JrError::UserError(none_msg_fn(&all_names)).into())`); issue #674
**Subject**: Users — `@Name` mention resolution (zero-match hard error)

**Description**: A `@Name` mention candidate that resolves to ZERO usable Jira users is a HARD ERROR — exit 64 — identical in mechanism to `resolve_user`/`resolve_assignee`/`resolve_assignee_by_project`'s existing zero-match convention.

**Mechanism correction (pass-1 adversarial review, CRIT-1) — supersedes this BC's original single-branch framing**: `disambiguate_user` (`src/cli/issue/helpers.rs`) has TWO distinct zero-outcome exits, not one: an EMPTY-LIST branch (`if users.is_empty()` → `Err(JrError::UserError(empty_msg.to_string()))`, lines ~276-278) and a `MatchResult::None` branch (non-empty list, no name-level match found by `partial_match`, → `Err(JrError::UserError(none_msg_fn(&all_names)))`, lines ~365-367). Because BC-X.7.007 point 1 filters search results to `active == Some(true)` BEFORE calling `disambiguate_user`, the two headline real-world zero-match scenarios this BC exists to cover — a genuine `@nobody` where `GET /rest/api/3/user/search?query=nobody` itself returns `[]` (H-NEW-MENTION-004), AND an `@Name` matching only a deactivated Jira user (EC-X.7.007-3/EC-X.7.009-4) — BOTH hit the EMPTY-LIST branch, NOT `MatchResult::None` as this BC's original text (and EC-X.7.007-3/EC-X.7.009-4's original wording) incorrectly claimed. The `MatchResult::None` branch remains reachable in principle (e.g. the search API returns a non-empty result set that shares no exact/partial match with the queried name under `partial_match`'s rules) but is NOT the path either headline scenario actually takes. This BC's HARD-ERROR postcondition applies uniformly to BOTH exits — no special-casing is needed in the mention resolver to select between them, since both are `disambiguate_user`'s pre-existing, already-`Err`-returning arms (BC-X.7.007/008/009 remain three FACETS of one `disambiguate_user` call, not three separately-coded branches) — but test-writer and the holdout evaluator MUST target the EMPTY-LIST branch specifically for the `@nobody`/deactivated-only scenarios, not `MatchResult::None`.

**Further correction (cycle-005 F2 pass-6 adversarial review M-3) — supersedes the "reachable in principle" framing above for THIS call site specifically**: the F2 pass-4 INTEGRATE sub-burst inserted `filter_by_name_match` (BC-X.7.007 point 2) BETWEEN the active-filter and the `disambiguate_user` call on the mention path. Because that pre-filter already discards every active candidate whose display name does NOT name-match the query, any list `disambiguate_user` actually receives via the mention resolver's call site has ALREADY been reduced to name-matching candidates only — a non-empty list handed to `disambiguate_user` here can therefore no longer fail `partial_match`'s internal name-matching check, since every member already passed an equivalent (case-insensitive substring) check upstream. The scenario that previously would have produced `MatchResult::None` (a non-empty list sharing no name-level match with the query — e.g. EC-X.7.007-5's fuzzy single-hit) is now intercepted BEFORE `disambiguate_user` is ever called and reaches the EMPTY-LIST branch instead (wording (iii), point 2 below) — NOT `MatchResult::None`. **`MatchResult::None` is therefore NOT reachable via the mention resolver's call site post-tightening.** It remains reachable only through `disambiguate_user`'s OTHER, unmodified callers (`resolve_user`, `resolve_assignee`, `resolve_assignee_by_project`), which do not run `filter_by_name_match` and can still hand `disambiguate_user` an unfiltered, potentially non-name-matching list. Point 2(i)'s reference to "`MatchResult::None`'s non-empty-but-no-match case" below, and VP-674-010's "supplementary case exercising the `MatchResult::None` branch directly," both describe this now-unreachable-on-the-mention-path scenario and are corrected accordingly.

**[DECISION NOTE — supersedes architect recommendation, not re-litigated here]**: `delta-analysis.md` §4 Design Decision (c)/(e) and Open Question OQ-4 recommended the OPPOSITE policy — silent pass-through (leave the span as literal text) for a zero-match `@Name`, reasoning that free-text prose (unlike an explicit `--assignee` flag) is not an unambiguous declaration of mention intent, and that treating every zero-match `@word` as fatal risks breaking ordinary technical writing (`@types/node`, `@Override`, a typo in someone's name). **The human-approved scope for this cycle (F2 task instruction) explicitly directs HARD ERROR, exit 64, for zero-match** — this BC encodes that directive verbatim, per this agent's instruction to encode human-approved decisions rather than re-litigate them. The architect's risk analysis is preserved here as a documented, ACKNOWLEDGED consequence (see Edge Cases below), not silently dropped: a comment/description containing prose like "add @Override to the method" or referencing `@types/node` OUTSIDE a code span will now hard-fail the entire write with exit 64 unless a Jira user happens to match the token. **This is flagged for explicit human awareness at the F2 gate, in the same spirit as OQ-4 — resolved, not ignored.**

**Behavior**:
1. The resolver calls `disambiguate_user` uniformly (same call site as BC-X.7.007/008) — no separate zero-match code path is written; BOTH the empty-list branch's `Err(JrError::UserError(empty_msg.to_string()))` (the branch a real `@nobody` or a deactivated-only match actually takes, per the mechanism correction above) AND `MatchResult::None`'s `Err(JrError::UserError(none_msg_fn(&all_names)))` return ARE the hard-error behavior — the resolver's call site is responsible for supplying BOTH `empty_msg` and `none_msg_fn` with equivalent wording (point 2 below), not just the latter.
2. **Error message — THREE-way selection, all pinned to the same load-bearing substring** (closes CRIT-1(b); reconciles LOW-3; extended from a two-way to a three-way selection by cycle-005 F2 pass-5 adversarial review M-2, which identified that BC-X.7.007 point 2's `filter_by_name_match` tightening introduces a third cause of the empty-list branch not covered by the original two-way wording choice): `disambiguate_user` takes an `empty_msg: &str` (for the empty-list branch) and a `none_msg_fn: impl Fn(&[String]) -> String` (for the `MatchResult::None` branch) — the mention resolver's call site MUST supply both such that EVERY generated message contains the load-bearing substring `"No user found matching"` (H-NEW-MENTION-004 asserts this substring against a `query=nobody` → `[]` response, which takes the empty-list branch). **Wording-source clarification (cycle-005 F2 pass-2 adversarial review L-4)**: "reuses `disambiguate_user` verbatim" (this BC's Confidence line, and BC-X.7.007/008's equivalent phrasing) refers strictly to the FUNCTION/MECHANISM — the same `disambiguate_user` code path, branches, and call signature — NOT to reusing an EXISTING CALLER's message-text strings. `resolve_user` (an existing, pre-#674 `disambiguate_user` caller, `src/cli/issue/helpers.rs`) supplies its OWN `empty_msg`/`none_msg_fn` wording today, e.g. `"No active user found matching \"{}\". The user may be deactivated."` — that string is `resolve_user`-specific and is NOT the mention resolver's pinned string. The mention resolver's call site constructs its OWN `empty_msg`/`none_msg_fn` arguments, distinct from every other caller's, containing the substring `"No user found matching"` (no `"active"`) as specified below — an implementer must not copy `resolve_user`'s `"No active user found matching…"` text under the mistaken assumption that "reuse verbatim" extends to message strings. The mention resolver's call site inspects the RAW (pre-`active`-filter, pre-`filter_by_name_match`) `search_users` result before calling `disambiguate_user`, and selects among THREE `empty_msg` wordings (exact final string is an F4 choice; the pinned substring is load-bearing, the rest is not):
   - **(i) Genuinely no user found** — raw search returned `[]`: `"No user found matching \"@<Name>\" — verify the spelling or use the [~accountid:<id>] form."` **(Corrected, cycle-005 F2 pass-6 M-3)**: the previously-listed alternate trigger, "`MatchResult::None`'s non-empty-but-no-match case," does NOT apply on the mention path — per the Mechanism correction above, `filter_by_name_match` intercepts that scenario upstream of `disambiguate_user`, so it reaches the EMPTY-LIST branch under wording (iii) below, not `MatchResult::None` under wording (i).
   - **(ii) All matches were deactivated** — raw search returned ≥1 result, but ZERO of them are active (`active == Some(true)`), i.e. BC-X.7.007 point 1's active-filter alone already empties the list before `filter_by_name_match` (point 2) ever runs — **LOW-3**: `"No user found matching \"@<Name>\" (a matching account exists but is deactivated) — verify the spelling or use the [~accountid:<id>] form."` This preserves the pinned substring while adding a "no ACTIVE user" hint distinguishing "nobody by that name exists" from "that person exists but can't be mentioned."
   - **(iii) NEW (cycle-005 F2 pass-5 M-2) — an active match exists but none name-matches the query** — raw search returned ≥1 result with AT LEAST ONE active (`active == Some(true)`) candidate, but BC-X.7.007 point 2's `filter_by_name_match` pre-filter reduces that active set to EMPTY because no active candidate's display name case-insensitively-substring-matches the query (EC-X.7.007-5's fuzzy-single-hit scenario, e.g. `@jsmith` fuzzy-matching only the active user "John Smith"): `"No user found matching \"@<Name>\" — verify the spelling or use the [~accountid:<id>] form."` — the SAME NEUTRAL wording as (i), deliberately WITHOUT the "deactivated" hint. This is load-bearing, not cosmetic: the matched account(s) in this branch ARE active, so (ii)'s "a matching account exists but is deactivated" hint would be FACTUALLY WRONG here — the account isn't deactivated, it simply didn't match by name. An implementer must not conflate "empty-list branch reached" with "use the deactivated wording"; the branch alone is not sufficient to select (ii) over (iii).

   Because `disambiguate_user`'s own signature has no visibility into the PRE-filter search result, the mention resolver (not `disambiguate_user`) is responsible for constructing whichever `empty_msg` variant applies. The three-way selection is a single inspection of the raw (pre-filter) result, branching purely on ACTIVE-candidate counts (no separate inspection of the post-`filter_by_name_match` set is needed, since the resolver already knows that set is empty whenever it is choosing an `empty_msg` at all): raw result empty → (i); raw result non-empty with zero active candidates → (ii); raw result non-empty with ≥1 active candidate (necessarily filtered to empty by `filter_by_name_match`, since the resolver only reaches this selection when the post-filter list is empty) → (iii).
3. **Zero-POST guarantee**: identical to BC-X.7.008 point 3's write-stopping case — the entire comment/description write is all-or-nothing; a single zero-match `@Name` (via either exit) among otherwise-resolvable candidates fails the WHOLE write.
4. **`--no-mentions` bypass**: skipped entirely when `--no-mentions` is passed (BC-7.2.016 point 7) — this is the recommended escape hatch for a user who deliberately wants to write `@Override`/`@types/node`-shaped prose without triggering resolution.

**Edge Cases**:
- **(EC-X.7.009-1) Java annotation in prose hard-fails**: `add @Override to the method` (outside code marks — see BC-7.2.018 EC-7.2.018-3) → exit 64 unless a Jira user is literally named "Override". **Documented, accepted consequence of the human-approved decision** — mitigation is `--no-mentions` or wrapping the annotation in a code span (which BC-7.2.018's skip-context rule already excludes from detection).
- **(EC-X.7.009-2) npm scoped package hard-fails on the package-name-minus-scope token**: `@angular/core` → candidate token is `@angular` (charset excludes `/`, BC-7.2.018 point 2) → exit 64 unless a Jira user is named "angular". Same mitigation as EC-X.7.009-1.
- **(EC-X.7.009-3) Slack broadcast tokens hard-fail**: `@channel`/`@here` → exit 64, same mechanism, same mitigation.
- **(EC-X.7.009-4) Deactivated-only match is a zero match — via the EMPTY-LIST branch, not `MatchResult::None`** (corrected, pass-1 adversarial review CRIT-1): per BC-X.7.007 EC-X.7.007-3, an `@Name` matching only a deactivated user is filtered out of the active-user list before `disambiguate_user` is called, so `disambiguate_user` receives an EMPTY list and takes the `if users.is_empty()` branch (`src/cli/issue/helpers.rs::disambiguate_user`, lines ~276-278) — NOT the `MatchResult::None` branch (lines ~365-367) — falling into THIS zero-match hard-error path, not a silent resolve. Per LOW-3, the resolver's `empty_msg` for this specific case SHOULD include the "matching account exists but is deactivated" hint (BC-X.7.009 Behavior point 2's second wording variant) rather than a bare "no user found" — the user does exist, just not as an active account — while still carrying the pinned `"No user found matching"` substring.

**Verification Properties**:
- VP-674-010: `@Name` ambiguous/zero-match exit-64 taxonomy — the zero-match half specifically asserts exit 64 (not exit 0/pass-through) and zero POST/PUT to the mutation endpoint, exercised non-interactively via the EMPTY-LIST branch (the `@nobody`/deactivated-only shape, per the mechanism correction above), with a supplementary case exercising the EMPTY-LIST branch's wording-(iii) path specifically (a search result that returns ≥1 active candidate whose display name does not name-match the query — intercepted by `filter_by_name_match` before `disambiguate_user` is ever called). **Corrected, cycle-005 F2 pass-6 adversarial review M-3**: this supplementary case previously described exercising the `MatchResult::None` branch directly — per the Mechanism correction above, that input is now intercepted upstream by `filter_by_name_match` and reaches the EMPTY-LIST branch instead, so `MatchResult::None` is not reachable via this call site post-tightening. (formal-verifier is updating the VP-674-010 definition itself in `verification-delta-674.md` in parallel; this BC-body wording is kept consistent with that correction: non-name-match → empty-list branch, not `MatchResult::None`.)

**Trace**: `src/cli/issue/helpers.rs::disambiguate_user` (BOTH the `if users.is_empty()` empty-list arm, lines ~276-278, AND the `MatchResult::None` arm, lines ~365-367 — already implemented, reused as-is); `delta-analysis.md` §4 Decision (c)/(e), Open Question OQ-4 (superseded by this human-approved directive); issue #674

[NEW 2026-09-06 issue #674 F2 — resolves delta-analysis.md OQ-4 to HARD ERROR per human-approved scope, superseding the architect's pass-through recommendation]

---

#### BC-X.7.010: Bracket-form `[~accountid:<id>]` mention accountId is preflight-validated via `GET /rest/api/3/user?accountId=<id>` before any comment/description POST or PUT; an unknown id is a HARD ERROR, exit 64; validation is deduplicated per unique id and performs at most one call per unique id per invocation

**Confidence**: HIGH
**Source**: `src/api/jira/users.rs::JiraClient::get_user` (reused as-is, ALREADY implemented and tested for `jr user view`); BC-X.7.005 (existing "friendly not-found" wording precedent, `"User with accountId '<id>' not found"` exit 64); issue #674
**Subject**: Users — bracket-form accountId preflight validation (mandatory, per human-approved Design Decision (a))

**Description**: Per the human-approved scope (task item 2), every unique bracket-form accountId `find_mention_candidates` (BC-7.2.016) finds in a comment/description body is validated via `client.get_user(account_id)` BEFORE the body is posted. This closes the specific footgun named in `delta-analysis.md` §4 Decision (a): Jira's own server-side behavior for an invalid/unknown `attrs.id` on a `mention` node is to accept the ADF silently and render a dead, non-notifying `@unknown` in the issue — since the ENTIRE PURPOSE of the mention feature is "notify someone," shipping it with an easily-triggered silent-no-op failure mode (a mistyped or stale copy-pasted accountId) would undermine the feature's own reason for existing.

**Behavior**:
1. **Deduplication**: exactly like BC-X.7.007 EC-X.7.007-1's `@Name` dedup, the resolver collects the SET of unique bracket-form accountIds found by `find_mention_candidates` before issuing any HTTP call — a body mentioning the same `[~accountid:X]` three times costs ONE `GET /rest/api/3/user?accountId=X` call, not three.
2. **Validation call**: `client.get_user(account_id)` — the SAME method `jr user view <id>` already calls, reused with zero new HTTP-call code.
3. **Unknown id → hard error**: `get_user`'s existing 404/400 mapping (`JrError::ApiError { status: 404 | 400, .. }`, per its own rustdoc — "Jira is inconsistent which it returns") is translated by the mention resolver into `JrError::UserError`, exit 64, mirroring BC-X.7.005's existing wording style: `"User with accountId '<id>' not found — the mention will not notify anyone."` (exact final wording is an F4 choice; the load-bearing substring should include `"not found"`, consistent with BC-X.7.005).
4. **Known id → success, feeds `attrs.text`**: on success, `get_user`'s returned `User.display_name` populates `MentionResolutions[<id>] = {account_id, display_name}`, which BC-7.2.017 consumes to set `attrs.text = "@" + display_name` on the emitted mention node.
5. **Zero-POST guarantee**: identical to BC-X.7.008/009 — an invalid bracket-form accountId fails the WHOLE write (all-or-nothing across every mention candidate in the body, both forms), BEFORE any comment/create/edit HTTP mutation call.
6. **`--no-mentions` bypass**: skipped entirely when `--no-mentions` is passed (BC-7.2.016 point 7) — bracket-form syntax passes through as literal, unvalidated text in that mode.
7. **Deliberate asymmetry with `@Name`**: an ALREADY-RESOLVED bracket-form accountId is validated because the CLI must make an extra round trip anyway to get `attrs.text` (BC-7.2.017) — validating costs nothing additional once that round trip is happening. This is NOT inconsistent with a hypothetical "don't validate what's already unambiguous" principle; it is simply that Design Decision (a)/(b) bundle validation and enrichment into the same call for both forms.

**Edge Cases**:
- **(EC-X.7.010-1) Malformed-but-charset-valid id**: an id matching the `[A-Za-z0-9:_-]+` bracket-form charset (BC-7.2.016 point 1) but not corresponding to any real Jira user (e.g. a stale accountId from a since-deleted user, or a typo) → treated identically to "unknown id" — `get_user` returns 404, hard error, exit 64. `jr` does NOT attempt to distinguish "malformed" from "deleted" from "typo" — Jira's own 404/400 inconsistency (per `get_user`'s rustdoc) makes that distinction unreliable to surface cleanly, so all three collapse to one message.
- **(EC-X.7.010-2) Multiple distinct ids in one body**: `[~accountid:A]` and `[~accountid:B]` in the same comment → TWO `get_user` calls (one per unique id), both must succeed for the write to proceed; if EITHER fails, the whole write fails (all-or-nothing).
- **(EC-X.7.010-3) HTTP failure during validation (401/403/5xx, not 404/400)**: propagates via the standard `JrError` mapping (auth/API hint), NOT re-wrapped as a mention-specific "not found" error — consistent with `get_user`'s own documented error shape and this repo's general convention of not swallowing auth/rate-limit errors into a narrower error class.

**Verification Properties**:
- VP-674-001 (shared with BC-7.2.016): property-based bracket-form emission is unaffected by this BC's validation step (validation is orthogonal to the pure emitter's own correctness).
- VP-674-013 (assigned by formal-verifier, F2, `verification-delta-674.md`): accountId preflight-validation dedup — wiremock test asserting exactly ONE `GET /rest/api/3/user?accountId=` call for N repeated occurrences of the same bracket-form id in one body, and exit 64 + zero POST/PUT when `get_user` returns 404.

**Trace**: `src/api/jira/users.rs::JiraClient::get_user`; BC-X.7.005 (wording precedent); `.factory/phase-f1-delta-analysis/cycle-005/delta-analysis.md` §4 Decision (a)/(b); issue #674

[NEW 2026-09-06 issue #674 F2]

---

### X.8 Projects & Queues

#### BC-X.8.001: `project_exists(key)` → true on 200; false on 404

**Confidence**: HIGH
**Source**: `tests/input_validation.rs:~9`
**Trace**: Pass 3 BC-801

---

#### BC-X.8.002: `get_project_statuses(key)` → 404 → `JrError::ApiError{status: 404}`

**Confidence**: HIGH
**Source**: `tests/input_validation.rs:~233`
**Trace**: Pass 3 BC-802

---

#### BC-X.8.003: `get_or_fetch_project_meta(client, key)` caches by project key with 7d TTL

**Confidence**: HIGH
**Source**: `tests/project_meta.rs:~24`
**Behavior**: Service-desk project → `service_desk_id = Some("15")`. Software project → `None`.
**Trace**: Pass 3 BC-804

---

#### BC-X.8.004: `require_service_desk` errors for software project: "Jira Software project" + queue-command-specific error message

**Confidence**: HIGH
**Source**: `tests/project_meta.rs:~99`
**Trace**: Pass 3 BC-805

> **[UPDATED 2026-05-18 issue #288]** The literal "Queue commands require…" error string is removed from `src/api/jsm/servicedesks.rs::require_service_desk` and replaced by a caller-supplied context label. BC-X.8.004 now defines the queue-command-specific message only: 'Project "<KEY>" is a <type> project. Queue commands (`jr queue`) require a Jira Service Management project. Run "jr project list" to find a JSM project.' For the `jr issue create --request-type` call site, the error message is: 'Project "<KEY>" is a <type> project. `--request-type` requires a Jira Service Management project. Run "jr project list" to find a JSM project.' (see BC-3.8.002). For `jr requesttype list/fields` call sites: 'Project "<KEY>" is a <type> project. `jr requesttype` commands require a Jira Service Management project. Run "jr project list" to find a JSM project.' (see BC-X.12.003). Previous version of this BC required only the common prefix "Jira Software project" — the call-site-specific suffix is now part of the contract.
>
> **Implementation contract**: The call-site label is passed to `require_service_desk(client, project_key, call_site_label)` as a `&'static str` parameter. The function MUST NOT hard-code per-call-site branches; the message is formatted with the supplied label. Acceptable `call_site_label` values: `"queue commands"`, `"--request-type"`, `"jr requesttype commands"` (or equivalent constants in the calling modules). The implementer may use an enum if it strengthens type safety, but the boundary contract at the function signature is `&'static str`.

---

#### BC-X.8.005: `list_projects` paginates via `startAt`; filter via `typeKey` query param

**Confidence**: HIGH
**Source**: `tests/project_commands.rs:~1`
**Trace**: Pass 3 BC-1133d, BC-1133e (R4)

---

#### BC-X.8.006: Basic-auth 401 from `require_service_desk` (cache miss) → API-token-expiry hint; no OAuth-scope language

**Confidence**: HIGH
**Subject**: X.8 Projects & Queues (JSM auth-conditional error hint — require_service_desk path)
**Behavior**: `require_service_desk` in `src/api/jsm/servicedesks.rs` calls `get_or_fetch_project_meta` which is cache-first (7-day TTL). The 401 hint described here fires ONLY on a cache MISS — when live HTTP calls are actually issued. **Trigger clarification (C-01):** `get_or_fetch_project_meta` issues TWO live GETs on a cache miss for a `service_desk`-type project: (1) `GET /rest/api/3/project/{key}` to fetch project details, and (2) `GET /rest/servicedeskapi/servicedesk` (via `client.list_service_desks()`) to match service desk by `projectId`. The new `map_err` wraps the entire `get_or_fetch_project_meta(...)` future, so it catches a 401 from EITHER GET. Both are JSM-read operations; the API-token-expiry hint applies uniformly to both. **User-facing behavioral boundary**: a warm `(profile, project_key)` project-meta cache entry suppresses this hint at the `require_service_desk` step; the 401 then surfaces at the next live HTTP call (e.g., the JSM POST → BC-3.8.014/015). Any test exercising this BC MUST force a cache miss (e.g., by not pre-populating the project-meta cache).

When a live GET inside `get_or_fetch_project_meta` returns 401 AND the active auth scheme is Basic (i.e., `JiraClient::is_oauth_auth()` returns `false`), the implementation MUST **introduce a NEW `map_err`** on the `get_or_fetch_project_meta(...)` call inside `require_service_desk` (line 117 of `src/api/jsm/servicedesks.rs`). The current code at line 117 is `let meta = get_or_fetch_project_meta(client, project_key).await?;` — the `?` propagates raw with no hint. The new `map_err` must surface an API-token-expiry hint. The gate is `is_oauth_auth() == false` ALONE — the incoming error variant is irrelevant.

**Dual exit codes on `require_service_desk`:** After this BC is implemented, `require_service_desk` has TWO failure exit codes: exit 64 (`JrError::UserError`, the existing non-JSM-project path, BC-X.8.004) and exit 2 (`JrError::NotAuthenticated`, the new 401 path). The implementer MUST NOT normalize them — they are distinct error categories.

Implementation: the new `map_err` must REWRITE any incoming error (whether `JrError::NotAuthenticated` or `JrError::InsufficientScope`) to `JrError::NotAuthenticated { hint: API_TOKEN_EXPIRY_HINT }`. The shared constant `API_TOKEN_EXPIRY_HINT` (defined once in **`src/error.rs`** — NOT in `src/api/client.rs` or any new module) is referenced identically by both the `handle_jsm_create` site (BC-3.8.014) and this `require_service_desk` site. `src/error.rs` is imported by both the `api` and `cli` layers with no layering inversion. This prevents hint-text divergence between the two call sites and adds no new modules.

The `hint` field value (stored in `JrError::NotAuthenticated { hint }`) MUST be identical to BC-3.8.014's hint (shared constant). The rendered stderr line prepends `"Not authenticated. "`; the `hint` field contains only the body text. Tests MUST assert via `contains`, not `==`. The hint field value is:

<!-- This block is duplicated from the CANONICAL copy in prd-delta-384.md §BC-3.8.014 — all copies MUST be updated together; cf. the JR_* doc-fallout pattern in CLAUDE.md (adversary-pass-4 F-04). -->
```
Your API token may be expired or revoked. Regenerate it at
https://id.atlassian.com/manage-profile/security/api-tokens
then run `jr auth login` to re-store the credentials.
```

This hint MUST NOT contain any OAuth-scope language. The hint MUST NOT say `jr auth refresh` (meaningless for Basic auth). The `require_service_desk` function is shared across all JSM callers: `handle_jsm_create` (`jr issue create --request-type`), `jr queue list/view`, and `jr requesttype list/fields`. All callers benefit from this contract.

Gate: `client.is_oauth_auth() == false` at the new `map_err` site on the `get_or_fetch_project_meta` call inside `require_service_desk` (per orchestrator decision 1: the contract is on `require_service_desk` itself, not on individual callers).

**Inputs**: Active auth = Basic; `GET /rest/api/3/project/{key}` returns HTTP 401 (any body shape); project-meta cache is empty (cache miss — the live GET is issued).
**Outputs/Effects**: exit 2; stderr contains the API-token-expiry hint (assert via `contains`); stdout empty; any `InsufficientScope` from the 401 is rewritten to `NotAuthenticated` before surfacing.
**Errors**: None beyond the 401 itself — this BC IS the error-handling contract.
**Setup** (for `test_require_service_desk_basic_auth_401_surfaces_api_token_hint`):
0. **Isolated `XDG_CACHE_HOME` tempdir** (e.g., `tempfile::tempdir()`) — forces a project-meta cache miss so the live GET inside `get_or_fetch_project_meta` actually fires. A warm cache would bypass the HTTP call and the 401 would never be seen.
1. Auth fixture: `JR_AUTH_HEADER=Basic <b64>` (capital B, single space — any valid Base64 value; e.g., `Basic dGVzdDp0ZXN0`).
2. Mount `GET /rest/api/3/project/{KEY}` to return HTTP 401 with a verbatim generic-expiry body: `{"errorMessages": ["The access token provided is expired, revoked, malformed, or invalid for other reasons."], "errors": {}}`. This is the **canonical pinned 401 path** for this named test — the project GET is triggered first by `get_or_fetch_project_meta` on a cache miss. **URL-encoding note (adversary-pass-8 LOW):** the project key is URL-encoded by `get_or_fetch_project_meta` via `urlencoding::encode`, so a wiremock `path()` matcher is exact for plain-alphanumeric keys (the named test uses `HELP`); a project key containing special characters would require an encoded mock path.
3. The second GET arm (`list_service_desks()` → `GET /rest/servicedeskapi/servicedesk`) is covered **structurally** because the `map_err` wraps the entire `get_or_fetch_project_meta` future — it is NOT separately pinned by this test. A dedicated test for the service-desk-list 401 arm is not required; the `map_err` wraps both GETs uniformly. The canonical-vs-structural distinction is explicit: this test pins the project-GET arm; the service-desk-list arm is covered by the shared `map_err` on `get_or_fetch_project_meta`.
4. Drive via: `jr issue create --project <KEY> --request-type <NAME> --summary "..." --no-input` (which calls `require_service_desk` first, triggering the 401 before reaching the JSM POST).
**Trace**: `tests/issue_create_jsm.rs` (integration test `test_require_service_desk_basic_auth_401_surfaces_api_token_hint` — NEW; Basic-auth fixture, cache miss forced; asserts stderr `contains` "expired or revoked" and `contains` `id.atlassian.com/manage-profile/security/api-tokens` and `contains` `jr auth login`; asserts stderr does NOT contain `write:servicedesk-request`). The new `map_err` is placed inside `require_service_desk` (shared by `jr issue create`, `jr queue`, `jr requesttype`), so all three callers structurally benefit; this test pins the `create` caller path; existing `queue`/`requesttype` integration tests cover regression for those callers.
**Source**: Issue #384 F2; O-08-05 CONFIRMED in `.factory/research/issue-288-pr4-deferred-validation.md` (lines 342-381); `src/api/client.rs:~696` (body check before Bearer guard — same issue as BC-3.8.014); `src/api/jsm/servicedesks.rs:~52` (get_or_fetch_project_meta issues TWO live GETs on a service_desk-type cache miss: GET /rest/api/3/project/{key} AND GET /rest/servicedeskapi/servicedesk; the new map_err must wrap the entire future, catching 401 from either GET); `src/api/jsm/servicedesks.rs:~117` (raw `?` propagation — no existing map_err on get_or_fetch_project_meta call; the new map_err MUST be introduced here).
**Confidence**: HIGH

[NEW 2026-05-19 issue #384 F2] Closes O-08-05: `require_service_desk` 401 on the project-GET/service-desk-list path had no JSM-specific hint. The auth-conditional `map_err` is placed inside `require_service_desk` itself (not at call sites), so all three JSM caller paths benefit. Gate is `is_oauth_auth() == false` alone; map_err must rewrite both `NotAuthenticated` and `InsufficientScope` to the API-token hint (shared constant with BC-3.8.014 site).

[REVISED 2026-05-19 issue #384 F2 adversary correction] Previous version incorrectly stated `src/api/client.rs:~711 (Basic-auth 401 → NotAuthenticated)` as the explanation. This is incomplete: a Basic-auth 401 with a "scope does not match" body lands in `InsufficientScope` (body check at line 696 fires before Bearer guard at line 718). The corrected model: gate is `is_oauth_auth() == false` alone; `map_err` rewrites any incoming variant.

[REVISED 2026-05-19 issue #384 F2 adversary-pass-2 C-01/H-01/H-04/M-02/M-03] (C-01) Changed "map_err inside require_service_desk" to "MUST introduce a NEW map_err" — no existing map_err exists at line 117; the implementation must add one. (H-01) Dual exit codes documented explicitly: exit 64 (UserError, non-JSM) vs exit 2 (NotAuthenticated, 401). (M-02) Cache-warm suppression stated as user-facing behavioral boundary, not just a test-setup note. (M-03) API_TOKEN_EXPIRY_HINT constant location pinned to src/error.rs.

[REVISED 2026-05-19 issue #384 F2 adversary-pass-3 C-01/H-05] (C-01) Trigger broadened: `get_or_fetch_project_meta` issues TWO live GETs for service_desk-type projects — the project GET AND the service-desk list GET. The new map_err catches 401 from either. (H-05) Named acceptance test function added: `test_require_service_desk_basic_auth_401_surfaces_api_token_hint`; cross-caller coverage clarified (map_err is in require_service_desk; test pins create path; queue/requesttype existing tests cover regression).

---

#### BC-X.8.007: OAuth 401 from `require_service_desk` (cache miss) → read-side scope hint (`read:jira-work` + `read:servicedesk-request`)

**Confidence**: HIGH
**Subject**: X.8 Projects & Queues (JSM auth-conditional error hint — require_service_desk path)
**Behavior**: `require_service_desk` calls `get_or_fetch_project_meta` which is cache-first (7-day TTL). This BC fires ONLY on a cache MISS — when live HTTP calls are actually issued. **Trigger clarification (C-01):** `get_or_fetch_project_meta` issues TWO live GETs on a cache miss for a `service_desk`-type project: (1) `GET /rest/api/3/project/{key}` to fetch project details, and (2) `GET /rest/servicedeskapi/servicedesk` (via `client.list_service_desks()`) to match service desk by `projectId`. The new `map_err` wraps the entire `get_or_fetch_project_meta(...)` future, so it catches a 401 from EITHER GET. Both are JSM-read operations; the read-side scope hint applies uniformly to both. **User-facing behavioral boundary**: a warm `(profile, project_key)` project-meta cache entry suppresses this hint at the `require_service_desk` step; the 401 then surfaces at the next live HTTP call (e.g., the JSM POST → BC-3.8.014/015). Any test exercising this BC MUST force a cache miss.

When a live GET inside `get_or_fetch_project_meta` returns 401 AND the active auth scheme is OAuth/Bearer (i.e., `JiraClient::is_oauth_auth()` returns `true`), the NEW `map_err` introduced inside `require_service_desk` (see BC-X.8.006 — same new `map_err` on line 117) MUST surface a read-side scope hint for BOTH sub-cases, via `JrError::NotAuthenticated { hint }`. The gate is `is_oauth_auth() == true` ALONE.

**Dual exit codes on `require_service_desk`:** After BC-X.8.006/007 are implemented, `require_service_desk` has TWO failure exit codes: exit 64 (`JrError::UserError`, the existing non-JSM-project path, BC-X.8.004) and exit 2 (`JrError::NotAuthenticated`, the new 401 path from this BC and BC-X.8.006). The implementer MUST NOT normalize them — they are distinct error categories.

For both sub-cases of OAuth 401, the implementation rewrites to `JrError::NotAuthenticated { hint }` (NOT `InsufficientScope` — the `InsufficientScope` Display is a fixed template purpose-built for the issue-#185 POST scenario; for a read GET it produces irrelevant POST-specific noise). Both arms of the `map_err` emit the SAME single canonical hint string — there is ONE pinnable hint text, not two. This makes the acceptance test unambiguous: both the `InsufficientScope` arm and the `NotAuthenticated` arm produce identical output.

Rationale for hint content: `GET /rest/api/3/project/{key}` is a platform endpoint requiring `read:jira-work`; JSM service-desk context discovery additionally requires `read:servicedesk-request`. Both scopes are in `DEFAULT_OAUTH_SCOPES` (verified: `src/api/auth.rs:~60`), so re-consent via `jr auth login` genuinely obtains them — the hint IS actionable. Because jr's default OAuth app already grants these scopes, expiry is the more common cause for default-scoped users. The hint therefore LEADS with session-expiry recovery (`jr auth refresh` / `jr auth login`) and SECOND mentions, for BYO-OAuth users, that `jr auth login` must be used to re-consent with `read:jira-work` and `read:servicedesk-request` — `jr auth refresh` alone cannot add missing scopes (it re-mints with the same granted scope set) (H-03: expiry-recovery leads; BYO-scope sentence is secondary and explicitly connects `jr auth login` to scope acquisition).

NOTE: this does NOT change BC-3.8.015 — the JSM POST OAuth `InsufficientScope` arm is genuinely the #185 POST scenario, so keeping `InsufficientScope` there is correct and unchanged. Scopes are `read:jira-work` + `read:servicedesk-request` (NOT `write:servicedesk-request` — that applies to the subsequent POST, which `require_service_desk` never reaches).

Gate: `client.is_oauth_auth() == true` at the new `map_err` site inside `require_service_desk` (same `map_err` as BC-X.8.006, branching on the predicate result).

The `hint` field value (body text after the `"Not authenticated. "` renderer prefix from `src/error.rs`). Tests MUST assert via `contains`, not `==`. Both arms of the `require_service_desk` OAuth 401 `map_err` emit this identical hint:

<!-- This block is duplicated from the CANONICAL copy in prd-delta-384.md §BC-X.8.007 — all copies MUST be updated together; cf. the JR_* doc-fallout pattern in CLAUDE.md (adversary-pass-4 F-04). -->
```
Your OAuth token may be expired. Run `jr auth refresh` to renew the token, or
`jr auth login` to re-authorize. If using a custom OAuth app, run `jr auth login`
to re-consent with read:jira-work and read:servicedesk-request — `jr auth refresh`
alone cannot add missing scopes (it re-mints with the same granted scope set).
```

This is the canonical pinnable string for `test_require_service_desk_oauth_401_surfaces_read_scope_hint`. Acceptance tests assert `contains` `read:jira-work` AND `contains` `read:servicedesk-request`; assert does NOT contain `write:servicedesk-request`.

**Inputs**: Active auth = Bearer/OAuth; a live GET inside `get_or_fetch_project_meta` returns HTTP 401 (any body — project GET or service-desk list GET); project-meta cache is empty (cache miss — the live GETs are issued).
**Outputs/Effects**: exit 2; stderr contains `"Not authenticated. "` prefix and read-scope hint (assert `contains` `read:jira-work` AND `contains` `read:servicedesk-request`; assert does NOT contain `write:servicedesk-request`); stdout empty.
**Errors**: None beyond the 401 itself — this BC IS the error-handling contract.
**Setup** (for `test_require_service_desk_oauth_401_surfaces_read_scope_hint`):
0. **Isolated `XDG_CACHE_HOME` tempdir** (e.g., `tempfile::tempdir()`) — forces a project-meta cache miss so the live GET inside `get_or_fetch_project_meta` actually fires. A warm cache would bypass the HTTP call and the 401 would never be seen.
1. Auth fixture: `JR_AUTH_HEADER=Bearer test-oauth-token` (capital B, single space — the established OAuth/Bearer fixture string used throughout `tests/issue_create_jsm.rs`).
2. Mount `GET /rest/api/3/project/{KEY}` to return HTTP 401 with a **scope-mismatch body**: `{"errorMessages": ["Unauthorized; scope does not match"]}`. **WHY scope-mismatch body is required:** A Bearer client receiving a generic-expiry 401 body on this GET does NOT short-circuit to `JrError::InsufficientScope` — it enters the auto-refresh coordinator (client.rs:~727+), which deterministically fails with a raw `anyhow::bail!` error (not a `JrError`) via the `JR_AUTH_HEADER` seam (no keychain tokens). That raw error propagates without entering the `map_err`'s `JrError` match arms, so the read-scope hint is never injected. The scope-mismatch body (`"scope does not match"` substring) triggers the short-circuit at client.rs:~696 BEFORE the refresh coordinator, landing as `JrError::InsufficientScope` in the `map_err`, which then rewrites to `JrError::NotAuthenticated { hint }` with the read-scope hint. A generic-expiry body would produce a non-deterministic, non-`JrError` failure path — not a valid pin for this BC. **BC-X.8.006 (Basic) is NOT affected** by this constraint: a Basic 401 never enters the refresh path (gated on `Bearer` at client.rs:~718), so any body deterministically yields a `JrError`; BC-X.8.006's Setup may use a generic-expiry body (as specified). This is the **canonical pinned 401 path** for this named test — the project GET is triggered first by `get_or_fetch_project_meta` on a cache miss. **URL-encoding note (adversary-pass-8 LOW):** the project key is URL-encoded by `get_or_fetch_project_meta` via `urlencoding::encode`, so a wiremock `path()` matcher is exact for plain-alphanumeric keys (the named test uses `HELP`); a project key containing special characters would require an encoded mock path.
3. The second GET arm (`list_service_desks()` → `GET /rest/servicedeskapi/servicedesk`) is covered **structurally** because the `map_err` wraps the entire `get_or_fetch_project_meta` future — it is NOT separately pinned by this test. The canonical-vs-structural distinction is explicit: this test pins the project-GET arm; the service-desk-list arm is covered by the shared `map_err` on `get_or_fetch_project_meta`. No dedicated test for the service-desk-list 401 arm is required; both arms emit the identical hint (as established in BC-X.8.007 body above).
4. Drive via: `jr issue create --project <KEY> --request-type <NAME> --summary "..." --no-input` (which calls `require_service_desk` first, triggering the 401 before reaching the JSM POST). The test mounts only the 401 project-GET mock; no request-type resolution mock is needed because the command exits at the `require_service_desk` step.
**Trace**: `tests/issue_create_jsm.rs` (integration test `test_require_service_desk_oauth_401_surfaces_read_scope_hint` — NEW; OAuth/Bearer fixture, cache miss forced; asserts stderr `contains` `read:jira-work` AND `contains` `read:servicedesk-request`; asserts stderr does NOT contain `write:servicedesk-request`). The new `map_err` is placed inside `require_service_desk` (shared by `jr issue create`, `jr queue`, `jr requesttype`), so all three callers structurally benefit; this test pins the `create` caller path; existing `queue`/`requesttype` integration tests cover regression for those callers.
**Source**: Issue #384 F2; O-08-05 CONFIRMED; `src/api/auth.rs:~60` (both `read:jira-work` and `read:servicedesk-request` in DEFAULT_OAUTH_SCOPES — hint IS actionable for default-scoped users); `src/api/client.rs:~696` (scope-mismatch body detection → InsufficientScope); `src/api/jsm/servicedesks.rs:~52` (get_or_fetch_project_meta issues TWO live GETs on a service_desk-type cache miss: GET /rest/api/3/project/{key} AND GET /rest/servicedeskapi/servicedesk; the new map_err must wrap the entire future); orchestrator decision: read-side scopes for this path, NOT write-scope; `src/api/jsm/servicedesks.rs:~117` (new map_err must be introduced here — see BC-X.8.006).
**Confidence**: HIGH

[NEW 2026-05-19 issue #384 F2] Pins the OAuth read-scope hint for the require_service_desk 401 path. Prior to issue #384, no hint existed for this path. The read-side scope names differ from BC-3.8.015's write-scope name — a user whose token has `write:servicedesk-request` but not `read:jira-work` would fail at require_service_desk before ever reaching the POST. Both scopes are in DEFAULT_OAUTH_SCOPES, making `jr auth login` genuinely actionable for session-expiry cases.

[REVISED 2026-05-19 issue #384 F2 adversary-pass-2 C-02/C-03/H-01/M-02] (C-02) Removed incorrect "Insufficient token scope. " (period) renderer-prefix citation — the actual `InsufficientScope` Display renders with a colon: "Insufficient token scope: {message}". (C-03) Both sub-case arms of the OAuth 401 now rewrite to `JrError::NotAuthenticated { hint }` — NOT `InsufficientScope`. The `InsufficientScope` Display is purpose-built for the issue-#185 POST scenario and always appends irrelevant POST-specific guidance when applied to a read GET. (H-01) Dual exit codes documented explicitly. (M-02) Cache-warm suppression stated as user-facing behavioral boundary.

[REVISED 2026-05-19 issue #384 F2 adversary-pass-3 C-01/H-03/H-04/H-05] (C-01) Trigger broadened: get_or_fetch_project_meta issues TWO live GETs for service_desk-type projects; map_err wraps the entire future and catches 401 from either. (H-03) Hint ordering corrected: leads with session-expiry recovery (jr auth refresh / jr auth login), BYO-scope sentence is SECONDARY. (H-04) Both arms of the map_err emit ONE canonical verbatim hint — no sub-case difference; single pinnable string documented; hint block relabeled "both arms emit this identical hint". (H-05) Named acceptance test function added: `test_require_service_desk_oauth_401_surfaces_read_scope_hint`; cross-caller coverage clarified.

[REVISED 2026-05-19 issue #384 adversary-pass-6 F-07] BYO-OAuth sentence in hint reworded: for a BYO-OAuth user with genuinely missing scopes, `jr auth refresh` re-mints a token with the SAME deficient scope set — it cannot add scopes. Only `jr auth login` re-consents and can acquire `read:jira-work` + `read:servicedesk-request`. Hint text updated to connect `jr auth login` explicitly to scope acquisition; `jr auth refresh` positioned as expiry-recovery only. Rationale paragraph in BC body aligned.

[REVISED 2026-05-19 issue #384 adversary-pass-9 C-01 CRITICAL design correction] Setup block corrected: the project-GET 401 mock body changed from generic-expiry to **scope-mismatch** (`{"errorMessages": ["Unauthorized; scope does not match"]}`). A Bearer client receiving a generic-expiry 401 on this GET routes through the refresh coordinator (client.rs:~727+), which fails with a raw anyhow error (not a `JrError`) via the `JR_AUTH_HEADER` seam — the read-scope hint is never injected, making the test non-deterministic. The scope-mismatch body short-circuits to `JrError::InsufficientScope` at client.rs:~696 BEFORE the refresh coordinator, deterministically reaching the `map_err`. BC-X.8.006 (Basic) is UNAFFECTED — Basic 401s never enter the refresh path and any body yields a `JrError` deterministically; BC-X.8.006's generic-expiry Setup remains as-is.

---

#### BC-X.8.008: `jr queue list` auto-paginates `/rest/servicedeskapi/servicedesk/{sdId}/queue` and renders `["Queue", "Issues"]` table; empty queue list is a valid success

**Confidence**: HIGH
**Subject**: X.8 Projects & Queues (JSM queue list)
**Behavior**: `handle_list` in `src/cli/queue.rs` calls `client.list_queues(service_desk_id)`. `list_queues` auto-paginates `GET /rest/servicedeskapi/servicedesk/{sdId}/queue?includeCount=true&start={N}&limit=50` using `ServiceDeskPage` until `isLastPage == true`, collecting all `Queue` values. Exit 0 on success. Requires a JSM service desk project — non-JSM projects are rejected by `require_service_desk` before `handle_list` is reached (BC-X.8.004).

**Table output** (default): two-column table with headers `["Queue", "Issues"]`. The Issues cell shows `q.issue_count.map(|c| c.to_string()).unwrap_or_else(|| "\u{2014}".into())` — i.e., the numeric count when `issueCount` is present in the API response, or em-dash `—` (U+2014) when `issueCount` is absent (None). An empty queue list (service desk with zero queues) in table mode renders the literal `No results found.` line (dimmed, via `src/output.rs::print_output`'s empty-rows branch), or `[]` in JSON mode, and exits 0 — NOT an error condition.

**JSON output** (`--output json`): `Vec<Queue>` serialized directly to a JSON array. Each element is a `Queue` object: `id` (string, non-null — serde `String`; empty-string is not type-prevented), `name` (string, non-null — serde `String`; empty-string is not type-prevented), and optionally `jql` (string or null), `fields` (array of strings or null), `issueCount` (number or null, serde field name `issueCount`). An empty array `[]` is a valid success state. The JSON output shape is governed by `src/types/jsm/Queue`'s `#[derive(Serialize)]` and the `#[serde(rename = "issueCount")]` annotation on `issue_count`.

**Pagination details**: page size is 50 per request; `includeCount=true` query param is always sent (causes the API to populate `issueCount` on each queue object). Pagination uses `ServiceDeskPage::has_more()` and `ServiceDeskPage::next_start()` for loop control. No client-side item cap (unlike `handle_view`).

**Inputs**: `service_desk_id` string (resolved by `require_service_desk`); `output_format` (table or JSON).
**Outputs/Effects**: stdout table or JSON array; exit 0.
**Errors**: 5xx → exit 1, `API error (N)` on stderr. 401 → exit 2, `Not authenticated` + `jr auth login` on stderr. Network drop → exit 1, `Could not reach <host> — check your connection` on stderr. Non-JSM project → exit 64 via `require_service_desk` (BC-X.8.004), before reaching `handle_list`.
**Trace**: `tests/queue.rs` (list_queues_returns_all_queues, list_queues_empty, queue_list_server_error_surfaces_friendly_message, queue_list_unauthorized_dispatches_reauth_message, queue_list_network_drop_surfaces_reach_error, test_queue_list_non_jsm_project_emits_canonical_callsite_message); `src/cli/queue.rs::handle_list`; `src/api/jsm/queues.rs::list_queues`
**Source**: S-QUEUE-BC-1 document-as-is; `src/cli/queue.rs::handle_list`; `src/api/jsm/queues.rs::list_queues`; `src/types/jsm/queue.rs`

[NEW 2026-06-08 S-QUEUE-BC-1] Closes traceability orphan: `jr queue list` was implemented but had no individually-bodied BC. Document-as-is: no aspirational behavior — all details verified against source and test files.

---

#### BC-X.8.009: `jr queue view` resolves queue by name (via `partial_match`) or `--id` (string pass-through), fetches issue keys in queue order, batch-fetches full issues (with the queue's declared custom fields threaded through as `extra_fields`), and reorders to queue position; issues absent from search are silently omitted

**STATUS: UPDATED (2026-08-13, issue #693)** — Issue fetch pipeline step 3 and the JSON-output clause below are amended: the queue's declared `fields[]` (filtered to real requestable field ids) now flow into `search_issues`'s `extra_fields` parameter, so queue-configured custom fields surface in `--output json`. Table output is unchanged. Pre-#693 text (empty `extra_fields`, no custom-field mention) is retained inline in each amended clause and summarized in the "Previous version" note near the end of this BC.

**Confidence**: HIGH
**Subject**: X.8 Projects & Queues (JSM queue view)
**Behavior**: `handle_view` in `src/cli/queue.rs` resolves a queue ID by one of two paths, then fetches and renders issues.

**Queue ID resolution (two paths):**
1. **By `--id <id>`**: The `id: Option<String>` argument is taken verbatim as the queue ID string. It is passed directly to `get_queue_issue_keys` without validation. There is no numeric validation — any string is accepted (e.g., `--id 10`, `--id "my-queue"`). This path BYPASSES `resolve_queue_by_name` entirely. **[AMENDED 2026-08-13 F2 issue #693]** Because this path bypasses `resolve_queue_by_name`, the resolved `Queue` object (and its `fields[]`) is NOT otherwise in hand here — obtaining it for step 3's `extra_fields` costs one additional `client.list_queues(service_desk_id)` call, matched by id, that the `<name>` path below does not incur (see Issue fetch pipeline step 3). **[AMENDED 2026-08-13 F2 issue #693, MEDIUM-3]** This auxiliary lookup is enrichment-only and fails OPEN, never closed: if it errors (5xx/401/network) or succeeds with no entry whose `id` matches the requested `--id`, `jr` does NOT hard-fail the command — it degrades to `extra_fields = &[]` and proceeds exactly as it did pre-#693, EMITTING A STDERR WARNING first (LOW-1, not a fully-silent degrade — see EC-X.8.009-1 and the Errors clause below for the full contract).
2. **By positional `<name>`**: `resolve_queue_by_name(service_desk_id, &name, client)` is called, which calls `client.list_queues(service_desk_id)` and applies `partial_match::partial_match(name, &names)`. Resolution outcomes:
   - `MatchResult::Exact(matched_name)` → returns the `id` of the matched queue (**[AMENDED 2026-08-13 F2 issue #693]** — the matched `Queue` object, including its `fields[]`, is now also retained for step 3's `extra_fields`; this path incurs NO additional HTTP call beyond the `list_queues` it already made). Proceeds.
   - `MatchResult::Ambiguous(matches)` → exit 64: `"<name>" matches multiple queues: "<m1>", "<m2>". Be more specific or use --id.`
   - `MatchResult::ExactMultiple(matched_name)` → exit 64: `Multiple queues named "<matched_name>" found (IDs: <id1>, <id2>, ...). Use --id <id1> to specify.` (where `<matched_name>` carries the queue's stored casing, e.g., input `"triage"` yields `Multiple queues named "Triage"` — NOT the user's input string)
   - `MatchResult::None(_)` → exit 64: `No queue matching "<name>" found. Run "jr queue list" to see available queues.`
   - Neither `<name>` nor `--id` supplied → exit 64: `Specify a queue name or use --id. Run "jr queue list" to see available queues.`
   
   **Partial-match semantics (verified from unit tests in `src/cli/queue.rs` and `tests/queue.rs`):** A lone substring hit (e.g., `"escal"` matching `"Escalations"`) is returned as `MatchResult::Ambiguous` — NOT Exact. The caller must supply the full exact name (case-insensitive) for `MatchResult::Exact` to fire. This is the strict-matching invariant from `src/partial_match.rs`.

**Issue fetch pipeline (after queue ID is resolved):**
1. `client.get_queue_issue_keys(service_desk_id, &queue_id, effective_limit)` — GETs `/rest/servicedeskapi/servicedesk/{sdId}/queue/{queueId}/issue` in pages of up to 50, collecting issue keys in queue order. The effective limit is `limit.or(Some(crate::cli::DEFAULT_LIMIT))` — i.e., `DEFAULT_LIMIT = 30` when `--limit` is absent; `--limit N` caps collection at N. Unaffected by #693 — this call still discards the queue-issue response's `fields` object per its own doc comment (`QueueIssueKey { key }`-only shape); it exists purely to establish queue-order key sequence, not to source field data.
2. If the keys list is empty (queue has zero issues): renders the `No results found.` line in table mode (via `src/output.rs::print_output`) or `[]` in JSON mode, and exits 0 immediately — no `search_issues` call is made, and no `list_queues` call is made for `extra_fields` purposes either (nothing to fetch fields for).
3. **[AMENDED 2026-08-13 F2 issue #693; ALLOW-LIST design, adversary pass-2 MEDIUM-1]** Otherwise: `client.search_issues(&jql, Some(keys.len() as u32), &extra_fields)` with `jql = "key IN (<k1>, <k2>, ...)"` (keys NOT quoted in JQL — issue keys are identifiers) and `extra_fields` derived from the resolved `Queue`'s declared `fields: Option<Vec<String>>` — the same array `jr queue list --output json` surfaces per BC-X.8.008. `extra_fields` construction is an ALLOW-LIST, not a drop-list: ONLY tokens matching the ANCHORED pattern `^customfield_\d+$` (**[PINNED, adversary pass-3 INFO-1]** — full-string match, `\d+` requires ONE OR MORE ASCII digits, no upper bound on digit count; case-SENSITIVE, matching Jira's own custom-field id convention — Jira never emits any other casing for this prefix) are kept in `extra_fields`. This is a precise, narrow shape, not a loose "starts with `customfield_`" substring test: `customfield_10050` MATCHES (kept); `customfield_` (zero digits) does NOT match (dropped); `customfield_10050_x` (trailing non-digit content after the anchored digit run) does NOT match (dropped, since `$` requires the digit run to reach the end of the token); `Customfield_10050` (wrong case) does NOT match (dropped, per the case-sensitivity rule above). Every other token in `queue.fields` — the `issuekey` pseudo-column, any `BASE_ISSUE_FIELDS` member (`summary`, `status`, etc.), and any other unknown/display-only/non-customfield token the queue happens to declare, INCLUDING any token that merely starts with `customfield_` without matching the full anchored pattern — is DROPPED. **Design rationale (human-ruled, adversary pass-2 MEDIUM-1):** a drop-list design (subtract known base-fields, pass everything else through) risks handing a non-requestable queue column straight to the PRIMARY `search_issues` call, which is NOT covered by the auxiliary-lookup fail-open guard below (item 1 / EC-X.8.009-1 — that guard covers failures of the `list_queues` metadata lookup, not a downstream `search_issues` 400 caused by an invalid `fields` value it was handed). An allow-list scoped to exactly the shape Jira's own custom-field ids take eliminates that regression risk structurally — `search_issues` can never receive an `extra_fields` token this feature invented that Jira might reject. Custom fields are also the actual goal of #693 (the reporter's complaint was specifically about missing `customfield_*` values); non-custom queue columns remain fully in scope for #575's general `--fields` work, not this BC. If `queue.fields` is empty/absent, or contains no `customfield_<digits>`-shaped token, `extra_fields = &[]`, byte-identical to pre-#693 behavior (see EC-X.8.009-2). Batch size equals the number of keys fetched. **[AMENDED 2026-08-13 F2 issue #693, MEDIUM-3]** On the `--id` path specifically, if the auxiliary `list_queues` lookup (Queue ID resolution item 1) needed to obtain `queue.fields` fails or finds no matching id, `extra_fields` is `&[]` here for that reason alone — this step does not distinguish "queue declared no fields" from "the fields lookup itself failed"; both degrade to the same empty-`extra_fields` outcome (with a stderr warning, LOW-1 — see EC-X.8.009-1), and neither blocks `search_issues` from running.
4. `reorder_by_queue_position(search_result.issues, &keys)` — re-orders the batch-fetched issues to match the original queue key ordering. Issues present in the queue keys but absent from the search result (e.g., permission-denied) are silently omitted (issues absent from the `search_issues` result are never present in the returned vec — `reorder_by_queue_position` only reorders the issues search actually returned; it neither synthesizes nor drops missing keys). Unaffected by #693.

**Rejected alternative (per research brief, human-endorsed, not pursued):** rendering table/JSON output directly from the queue endpoint's own `values[].fields` (skipping the `search_issues` round-trip entirely) was considered and rejected. The queue-admin-configured field set is a subset the queue is CONFIGURED to show as columns, NOT guaranteed to be a superset of `jr`'s base render columns — Atlassian's own example queue config (`["issuetype","issuekey","summary","created","reporter","duedate"]`) contains no `status`, `priority`, or `assignee`, all three of which `jr queue view`'s table currently renders unconditionally. Rendering directly from queue `fields` would silently blank those columns for any queue not configured to display them. The two-step fetch (queue keys → `search_issues`) is retained specifically to guarantee the base render fields and the typed `Issue` shape; only the `extra_fields` argument changes.

**EC-X.8.009-1** (#693, MEDIUM-3 — `--id` path's auxiliary `list_queues` lookup fails or has no matching id, DEGRADE not hard-fail; **[UPDATED, adversary pass-2 LOW-1 — degrade is NOT fully silent]**): `jr queue view --id 999 --output json` where the auxiliary `client.list_queues(service_desk_id)` call (needed only to obtain `queue.fields` for `extra_fields`) either (a) errors — 5xx, 401, or a network drop — or (b) succeeds (HTTP 200) but no returned entry's `id` matches `"999"` → in BOTH cases `jr` proceeds with `extra_fields = &[]` and completes the command normally (base-fields-only `Issue` objects, exit 0) rather than surfacing any error from this auxiliary call. **The degrade emits a stderr warning before proceeding** (LOW-1), following the model-b cache-write-warning convention already established in this codebase (CLAUDE.md: `write_cmdb_fields_cache`/`write_object_type_attr_cache` — swallow the failure, `eprintln!("warning: …")`, never `?`/`let _ =` silently): `warning: could not fetch queue field configuration for --id 999 (<cause>); showing base fields only.` where `<cause>` is a short, terse failure description (e.g. `API error (500)`, `not authenticated`, `no matching queue`, or the network-drop message) — NOT the full raw HTTP response body, matching the terse style of the existing model-b warnings. The warning fires for BOTH failure sub-cases above (lookup error and no-id-match) and goes to **stderr** in BOTH `--output json` and `--output table` modes (diagnostic, not data — the same channel convention as every other hint/warning in `jr`, e.g. the `board view` truncation hint; CLAUDE.md "Output channels"). It does NOT affect the exit code (still 0) or stdout content (JSON stdout carries no warning field; this is not the `{"error","code"}` shape — the command still SUCCEEDS). This is a deliberate regression guard: a `--id`-path invocation that worked (base fields only) before #693 MUST continue to work (exit 0) after #693 even when the NEW auxiliary fields-enrichment lookup this feature adds cannot resolve `queue.fields` for any reason — the user is informed via the warning, not blocked. It also means the `--id` and `<name>` paths can never diverge in JSON *shape* due to enrichment-lookup health — both converge on the same `extra_fields = &[]` fallback under any enrichment failure; the only observable difference between the two paths (beyond the warning) is HTTP call count (Queue ID resolution item 1), never the presence/absence of the base `Issue` fields. Contrast with a REAL failure of the primary pipeline (e.g. `get_queue_issue_keys` or `search_issues` itself returning 401/5xx) — that is NOT degraded, it surfaces via the ordinary Errors clause below exactly as before #693, and DOES affect the exit code.

**EC-X.8.009-2** (#693, LOW-1; **[UPDATED, allow-list design, adversary pass-2 MEDIUM-1]** — queue `fields[]` non-empty but nothing matches the `customfield_<digits>` allow-list): a queue configured with `fields: ["issuekey", "summary", "status"]` (none of the three match the `customfield_<digits>` pattern) → after Issue fetch pipeline step 3's allow-list filter, the kept set is empty → `extra_fields = &[]`, identical to a queue with `fields: null` or `fields: []`. This also covers a queue declaring a token `jr` has never seen (e.g. a hypothetical future non-`customfield_*` Jira built-in) — it is dropped just like `issuekey`/`summary`/`status`, never passed through speculatively. No spurious empty-string or invalid `fields` parameter is ever sent to `search_issues`; the filter's output is a genuinely empty slice, not an empty-but-present entry. **Previous version (pre-pass-2, drop-list mechanism, retained for audit trail):** "all three are either the `issuekey` pseudo-column or `BASE_ISSUE_FIELDS` members" — described a DROP-list (subtract known tokens, pass the rest through) rather than the current ALLOW-list (keep only `customfield_<digits>` tokens); the OUTCOME for this specific example is unchanged (empty either way), but the general filtering RULE differs — see step 3.

**Output (both resolution paths):**
- **Table output** (default): standard issue table using `issue_table_headers(...)` and `format_issue_rows_public(&issues)`. **[AMENDED 2026-08-13 F2 issue #668]** Prior text pinned a literal 3-positional-arg call, `issue_table_headers(false, false, false)`, and claimed "Same column set as `jr issue list`" unconditionally. Both are now qualified: `jr issue list --duedate` (BC-2.2.032) adds a 4th, opt-in Due Date column to `issue_table_headers`/`format_issue_row`'s signature; `jr queue view` does NOT gain a `--duedate` flag under BC-2.2.032 (see that BC's Scope clause) and continues to omit the Due Date column unconditionally — passing the new parameter as absent/`false` at this call site. The column set is therefore the SAME as `jr issue list`'s DEFAULT (no `--duedate`) column set, not `jr issue list`'s column set unconditionally; `jr queue view` has no equivalent of `--duedate` and cannot be made to show the column via any flag. **[AMENDED 2026-08-13 F2 issue #693] The table is ALSO unaffected by the queue-custom-field `extra_fields` change** — no new column is added for queue-configured custom fields; that render-side work is tracked separately as issue #575, explicitly out of scope here. `extra_fields` only changes what is REQUESTED from Jira and what appears in JSON; it does not change what the row/header builders render.
- **JSON output** (`--output json`): JSON array of full `Issue` objects (each has `key` + `fields`). NOT Queue objects. Empty array `[]` is a valid success state (queue exists, zero issues or all silently omitted). `duedate` is present in `fields` here too (unconditional, per BC-2.2.028/BC-2.3.036), since this path also flows through the shared `Issue`/`IssueFields` struct and `BASE_ISSUE_FIELDS` request list — no separate contract needed, noted for completeness. **[AMENDED 2026-08-13 F2 issue #693]** As of #693, `fields` ALSO carries any `customfield_*` keys the queue is configured to show as columns (Issue fetch pipeline step 3's `extra_fields`, above). These surface via `IssueFields`'s `#[serde(flatten)] extra: HashMap<String, Value>` field (no dedicated typed struct field is added, no `skip_serializing_if` suppresses them) — keyed exactly as Jira returns them (e.g. `customfield_10050`), value is the raw untyped `serde_json::Value` Jira sent, no display-name resolution or type coercion. Pre-#693 these keys were never requested (`extra_fields` was always `&[]` from this call site) and therefore never present in the output regardless of queue configuration.

**Requires JSM service desk project**: delegated to `require_service_desk` in the shared `handle` dispatcher before `handle_view` is entered (BC-X.8.004).

**Inputs**: `service_desk_id` string (from `require_service_desk`); `name: Option<String>` (positional); `id: Option<String>` (`--id` flag); `limit: Option<u32>` (`--limit` flag); `output_format`.
**Outputs/Effects**: stdout table or JSON array of issue objects; exit 0.
**Errors**: Name resolution errors → exit 64 (see messages above). 5xx from any HTTP call → exit 1, `API error (N)`. 401 → exit 2, `Not authenticated` + `jr auth login`. Network drop → exit 1, `Could not reach`. Non-JSM project → exit 64 via `require_service_desk` (BC-X.8.004), before reaching `handle_view`. **[AMENDED 2026-08-13 F2 issue #693, MEDIUM-3]** This taxonomy governs the PRIMARY pipeline calls only: the `list_queues` call inside `resolve_queue_by_name` (name-path resolution), `get_queue_issue_keys`, and `search_issues`. It does NOT govern the `--id` path's AUXILIARY `list_queues` call used solely to obtain `queue.fields` for `extra_fields` — failures of that call (any status, any transport error) never produce any of the exit codes above; they degrade to `extra_fields = &[]` (with a stderr warning, LOW-1 — NOT silent) per EC-X.8.009-1 and the command proceeds.

**Previous version (superseded by issue #693, retained for audit trail)**:

> **Issue fetch pipeline step 3 (pre-#693):** Otherwise: `client.search_issues(&jql, Some(keys.len() as u32), &[])` with `jql = "key IN (<k1>, <k2>, ...)"` (keys NOT quoted in JQL — issue keys are identifiers). Batch size equals the number of keys fetched. (`extra_fields` was always the empty slice — no custom fields were ever requested, regardless of queue configuration.)
>
> **JSON-output clause (pre-#693):** "JSON array of full `Issue` objects (each has `key` + `fields`)" — with no mention that queue-configured custom fields are absent from `fields` (they were, silently, because `extra_fields` was always empty).

**Trace**: `tests/queue.rs` (resolve_queue_duplicate_names_error_message, resolve_queue_single_substring_is_ambiguous, resolve_queue_mixed_case_duplicate_names_error_message, get_queue_issue_keys_returns_keys, get_queue_issue_keys_with_limit, get_queue_issue_keys_paginated, resolve_queue_ambiguous_fires_list_exactly_once_no_followon_http); `src/cli/queue.rs` (handle_view, resolve_queue_by_name, build_key_in_jql, reorder_by_queue_position); `src/api/jsm/queues.rs::get_queue_issue_keys`; `src/api/jira/issues.rs::search_issues` (`extra_fields` parameter, pre-existing, non-empty value supplied by this BC's caller only); `src/types/jira/issue.rs::IssueFields` (`#[serde(flatten)] extra` — custom-field round-trip mechanism); BC-X.8.008 (`Queue.fields` deserialization, unaffected); BC-2.2.028 (`BASE_ISSUE_FIELDS`, unaffected — extended per-call, not by changing the constant); F2 adversary pass-1 fix round (2026-08-13): EC-X.8.009-1/-2 added, Errors clause scoped, case-insensitive BASE_ISSUE_FIELDS note added (MEDIUM-3, LOW-1); F2 adversary pass-2 fix round (2026-08-13): step 3's `extra_fields` filter redesigned DROP-list→ALLOW-LIST (`customfield_<digits>` only), superseding the pass-1 case-insensitive BASE_ISSUE_FIELDS note (MEDIUM-1); EC-X.8.009-1's degrade path now emits a stderr `warning:` (model-b convention) instead of degrading silently (LOW-1); F2 adversary pass-3 fix round (2026-08-13, fresh context): the allow-list shape pinned precisely as the anchored regex `^customfield_\d+$` (full-string match, ≥1 digit, case-sensitive) with explicit reject examples (`customfield_`, `customfield_10050_x`, wrong casing) so F4 cannot implement it as a loose prefix test (INFO-1)
**Source**: S-QUEUE-BC-1 document-as-is; `src/cli/queue.rs::handle_view`; `src/cli/queue.rs::resolve_queue_by_name`; `src/api/jsm/queues.rs::get_queue_issue_keys`; `src/cli/mod.rs::DEFAULT_LIMIT`; research brief `.factory/research/bucket1-693-queue-view-fields-2026-08-13.md`

[NEW 2026-06-08 S-QUEUE-BC-1] Closes traceability orphan: `jr queue view` was implemented but had no individually-bodied BC. Document-as-is: no aspirational behavior — all details verified against source and test files.

[AMENDED 2026-08-13 F2 issue #668, adversarial review finding F4] Output/Table-output bullet corrected: the literal 3-arg `issue_table_headers(false, false, false)` citation and the unconditional "Same column set as `jr issue list`" claim are both qualified against `jr issue list`'s new opt-in `--duedate` column (BC-2.2.032) — `jr queue view` does not gain that flag and continues to omit the Due Date column unconditionally.

[AMENDED 2026-08-13 F2 issue #693] Issue fetch pipeline step 3 and the JSON-output clause amended: the resolved `Queue`'s declared `fields[]` (filtered to drop `issuekey` and any `BASE_ISSUE_FIELDS` member) now flow into `search_issues`'s `extra_fields` argument, surfacing queue-configured custom fields in `--output json`. Table output unchanged (no new column; #575 tracks that separately). `--id` path costs one additional `list_queues` call to obtain `queue.fields` that the `<name>` path does not incur (already has the `Queue` in hand from `resolve_queue_by_name`).

[AMENDED 2026-08-13 F2 issue #693, adversary pass-1 fix round (MEDIUM-3, LOW-1)]: (1) `--id` path's auxiliary `list_queues` lookup for `queue.fields` now has explicit fail-open/degrade semantics — a lookup failure (5xx/401/network) or a no-match on the requested id degrades to `extra_fields = &[]` rather than hard-failing the command (EC-X.8.009-1 added; Queue ID resolution item 1 and Issue fetch pipeline step 3 both updated; Errors clause scoped to exclude this auxiliary call). This closes a regression risk where a `--id`-path invocation that worked pre-#693 could newly hard-fail solely because the NEW enrichment lookup failed. (2) `BASE_ISSUE_FIELDS` membership filter in step 3 is now pinned CASE-INSENSITIVE, so a differently-cased queue-declared token (e.g. `fixversions` vs. the constant's `fixVersions`) is correctly recognized as a base field and filtered out rather than slipping through as a spurious duplicate `extra_fields` entry; EC-X.8.009-2 added for the "queue `fields[]` non-empty but every entry filters out to nothing" case.

[AMENDED 2026-08-13 F2 issue #693, adversary pass-2 fix round (MEDIUM-1, LOW-1)]: (1) Step 3's `extra_fields` construction changed from a DROP-list (subtract `issuekey` + `BASE_ISSUE_FIELDS` members, pass the rest — including the now-moot case-insensitive `BASE_ISSUE_FIELDS` comparison, superseded by this change) to an ALLOW-LIST: only tokens matching `customfield_<digits>` are kept, everything else is dropped. This closes a regression risk the pass-1 fail-open guard (EC-X.8.009-1) does NOT cover — a non-requestable queue column reaching the PRIMARY `search_issues` call and 400ing it; the allow-list makes that structurally unreachable, since `search_issues` can never receive an `extra_fields` token this feature invented that Jira might reject. EC-X.8.009-2 updated to describe the allow-list mechanism (its example outcome is unchanged: still empty `extra_fields` for `["issuekey","summary","status"]`). (2) The `--id`-path fail-open degrade (EC-X.8.009-1, MEDIUM-3 from pass-1) is no longer fully silent: it now emits a stderr `warning: …` before proceeding, following the model-b cache-write-warning convention (CLAUDE.md `write_cmdb_fields_cache` et al.) — the Errors clause's stale "silently degrade" wording is corrected to match.

---


#### BC-X.8.010: JSM attachment upload resolves `serviceDeskId` via existing `ProjectMeta` cache (`project_meta.json`, (profile, projectKey)-scoped, 7-day TTL); `serviceDesk.projectId == project.id` match; no new cache file [P6-001/P6-004 correction]

**Confidence**: HIGH
**Source**: `src/api/jsm/servicedesks.rs::get_or_fetch_project_meta`; `src/cache.rs::read_project_meta` / `src/cache.rs::write_project_meta`; `src/types/jsm/servicedesk.rs::ServiceDesk` (field `project_id` from `#[serde(rename = "projectId")]`); `src/api/jsm/attachments.rs::attach_temporary_file` (implementation pending — story S5)
**Subject**: X.8 Projects & Queues (JSM serviceDeskId resolution for attachment upload)

When `jr issue attachment upload <KEY> --public` (or `--internal`) needs the `serviceDeskId` for the target JSM project, it calls the EXISTING `get_or_fetch_project_meta` function (`src/api/jsm/servicedesks.rs`) — shared with `jr queue`, `jr requesttype`, and other JSM commands. No new cache file family is introduced.

**Resolution chain** (on cache miss or stale): `get_or_fetch_project_meta(client, project_key)` where `project_key` is extracted from `fields.project.key` in the issue GET: (1) fetches `GET /rest/api/3/project/{project_key}` → extracts `projectTypeKey` + `project.id`; (2) if `projectTypeKey == "service_desk"`: paginates `GET /rest/servicedeskapi/servicedesk` → finds entry where `serviceDesk.projectId == project.id` (the `ServiceDesk` struct in `src/types/jsm/servicedesk.rs` has `project_id: String` from `#[serde(rename = "projectId")]` — there is NO `projectKey` field; **P6-001 correction**: prior spec incorrectly said "match `projectKey`") → extracts `serviceDesk.id` as the `serviceDeskId`; (3) writes `ProjectMeta { project_type, project_id, service_desk_id: Some(id), ... }` to `project_meta.json` via `cache::write_project_meta`; (4) returns the `ProjectMeta`.

**Cache**: the existing `project_meta.json` (CANONICAL-COUNTS Cache Types item 2 — NOT a new separate file), keyed by `(profile, project_key)`, read via `cache::read_project_meta` and written via `cache::write_project_meta`. The 7-day TTL is enforced per `ProjectMeta.fetched_at`. No new cache FILE or cache-family functions; the single-entry invalidation (stale-ID self-healing) is an inline read-modify-write of `project_meta.json` (or a small private helper) — implementer's choice at S5. The model-b discussion from the original draft is **MOOT** — the existing `write_project_meta` writer already handles disk-write errors; no additional model-b function is needed. No independent-expiry drift: the shared ProjectMeta cache serves all JSM commands.

**Stale-ID self-healing (SEC-576-006)**: If a cached `serviceDeskId` is used and the step-1 `POST .../attachTemporaryFile` returns HTTP 404 or 403, the implementation MUST:

1. Invalidate the `project_meta.json` cache entry for `(profile, project_key)` — delete the entry from the map and re-write the file (triggering a cache miss on the next `read_project_meta` call).
2. Re-call `get_or_fetch_project_meta` once (cache miss path: re-resolves via `GET /rest/api/3/project/{key}` + paginated `GET /rest/servicedeskapi/servicedesk`).
3. Re-attempt step 1 with the re-resolved `serviceDeskId`.
4. If the re-resolved ID also fails, apply per-status exit mapping: 404 → exit 64 (`"Service desk for <projectKey> not found after refresh."`); 403 → exit 1 (permission denied); 401 → exit 2 (not authenticated); 5xx / network → exit 1. The blanket exit 64 for all second-failure codes is INCORRECT — 403 is a permission error (exit 1), not a user input error (exit 64).

The retry is a single-attempt guard — it does not loop.

**`stale_healed` guard is per-command, not per-file (WAVE-576-05, DOCUMENT-AS-IS)**: The `stale_healed: bool` flag in `src/api/jsm/attachments.rs::handle_attachment_upload_jsm` is a per-command-invocation guard, NOT a per-file guard. In a multi-file JSM upload (`jr issue attachment upload <KEY> <file1> <file2> ... --public`), the heal fires AT MOST ONCE for the entire command invocation. After a successful heal (one file's step-1 returned 404/403, cache invalidated, sdId re-resolved), all subsequent files use the corrected `sdId`. A second independent 404/403 on a subsequent file propagates as a raw `JrError::ApiError` (exit 1) rather than triggering the friendly post-retry exit-64 mapping. This is DOCUMENT-AS-IS-COMPLETE: (a) after a successful heal the corrected `sdId` is authoritative — a second independent stale-404 is nearly unreachable in practice; (b) a 403 on a subsequent file reflects a consistent permission denial, not an intermittent cache staleness, and exit 1 is the correct mapping; (c) adding per-file `stale_healed` flags was scoped out at F5 round 12 as over-engineering a near-unreachable path.

**EC-X.8.010-2** (multi-file upload: second independent step-1 failure after heal already fired — WAVE-576-05, DOCUMENT-AS-IS-COMPLETE): In a multi-file upload where `stale_healed == true` (heal already consumed by an earlier file in the same command), a subsequent file that receives HTTP 404 or 403 on step 1 is NOT re-healed. The error propagates as `JrError::ApiError { status: 404 | 403 }` → exit 1. User-visible symptom: partial upload (earlier files succeeded or healed; later file fails with exit 1). **Accepted edge**: the path is nearly unreachable — after a successful heal the `sdId` is freshly resolved from the live servicedeskapi list, so a second independent stale-404 on the same command would require the service desk to be deleted mid-command; a 403 would be a consistent permission denial (not intermittent). DOCUMENT-AS-IS ruling per WAVE-576-05 human ruling (F5 round 12 SOH-ATTACHMENTS-1); no BC-fix obligation.

**EC-X.8.010-1** (service desk list succeeded, but no entry's `projectId` matches `project.id` — `resolve_service_desk_id` returns `None`): When the paginated `GET /rest/servicedeskapi/servicedesk` request SUCCEEDS (HTTP 200) but exhausts all pages without finding any entry where `serviceDesk.projectId == project.id`, `jr` exits 64 BEFORE any `attachTemporaryFile` call, with the canonical message to stderr: `"No JSM service desk found for project <KEY>. The project may still be provisioning; verify with \`jr queue list --project <KEY>\`."` **ERROR** (§3.9 stderr taxonomy — unconditional; emitted in both human and `--output json` modes; this is a fatal pre-step-1 resolution failure, not an HTTP error). **Distinctions**: (a) HTTP errors on the list call itself (5xx, 401, network) propagate via the existing resolution-chain error rules in **Errors** below — this EC only applies when the list request returns HTTP 200 with a paginated response that contains no entry whose `projectId` matches; (b) this EC fires after the `projectTypeKey == "service_desk"` guard already confirmed the project is a JSM project — the BC-3.9.005 non-JSM guard (which fires earlier, at Step 0 before any servicedeskapi call) is therefore NOT in play here. **No stale-heal:** the self-heal sequence in **Stale-ID self-healing** above does NOT apply to this path — there is no previously-cached `serviceDeskId` to invalidate; the resolution chain found no ID to cache. P11-005.

**Scope**: governs `serviceDeskId` resolution for the JSM attachment upload path (`--public`/`--internal`). Other JSM commands (`queue`, `requesttype`, etc.) use the same `get_or_fetch_project_meta` function and `project_meta.json` cache; they are not separately affected by this BC.

**Inputs**: `project_key: &str` (extracted from `fields.project.key` in the issue GET response).
**Outputs/Effects** (cache hit): returns `ProjectMeta.service_desk_id`; no HTTP issued. (cache miss/stale): resolution chain runs; `ProjectMeta` written to cache; resolved `serviceDeskId` returned.
**Errors**: resolution-chain HTTP errors propagate normally (401 → exit 2, 404 → exit 64, 5xx → exit 1).

[P6-001/P6-004 correction 2026-07-16 SOH-ATTACHMENTS-1]: rewritten from a bespoke `service_desk_id_<projectKey>.json` cache design (original F2 draft) to REUSE the existing `ProjectMeta` cache via `get_or_fetch_project_meta`. Pre-code-audit original incorrectly described a new cache family and incorrectly stated "match `projectKey`" — the Jira `ServiceDesk` API response field is `projectId`, not `projectKey` (source-verified: `src/types/jsm/servicedesk.rs`). Delivery obligation revised: story S5 implementer reuses existing `read_project_meta` / `write_project_meta`; no new `read/write_service_desk_id_cache` functions to be added.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, D-179); P6-001/P6-004 correction 2026-07-16 (projectId field + reuse get_or_fetch_project_meta + reuse ProjectMeta cache); `src/api/jsm/servicedesks.rs::get_or_fetch_project_meta`; `src/types/jsm/servicedesk.rs::ServiceDesk.project_id`; `src/cache.rs::ProjectMeta`; BC-3.9.003/BC-3.9.004 (caller context); SEC-576-006 (stale-ID self-healing clause); P11-005 (EC-X.8.010-1 added: service-desk-list no-match None-path exit 64 before step 1; ERROR unconditional both modes; distinct from HTTP errors on list call and BC-3.9.005 non-JSM guard; no stale-heal applies); WAVE-576-05 2026-07-24 (EC-X.8.010-2 added + stale_healed per-command-not-per-file note: multi-file second independent step-1 failure after heal propagates exit 1 without re-heal; DOCUMENT-AS-IS-COMPLETE per F5 round 12 human ruling; spec v1.3.106)

---

### X.9 JQL Utilities

#### BC-X.9.001: `escape_value` proptest: for any printable Unicode up to 100 chars, output has NO unescaped quote

**Confidence**: HIGH
**Source**: `src/jql.rs:~383`; `proptest-regressions/jql.txt` (seed: `s = ""`)
**Subject**: JQL
**Behavior**: `has_unescaped_quote` helper tracks backslash-runs. Regression corpus pinned.
**Trace**: Pass 3 BC-1094 (R4)

---

#### BC-X.9.002: `validate_duration("4w2d")` → Err; single unit `"7d"` → Ok

**Confidence**: HIGH
**Source**: `src/jql.rs:~16`
**Behavior**: JQL relative-date validator (distinct from worklog parser).
**Trace**: Pass 3 BC-131 (R1)

---

#### BC-X.9.003: `validate_date` → `YYYY-MM-DD` format only; invalid → `JrError::UserError`

**Confidence**: HIGH
**Source**: `src/jql.rs`
**Trace**: Pass 3 BC-132 (R1)

---

#### BC-X.9.004: `strip_order_by` removes ORDER BY clause before count calls and paren-wrapping

**Confidence**: HIGH
**Source**: `src/jql.rs`; `src/cli/issue/list.rs`
**Trace**: Pass 3 BC-102, BC-125 (R1)

---

### X.10 Partial-Match

#### BC-X.10.001: `partial_match` with single-substring → `Ambiguous` (NOT Exact); never auto-resolves

**Confidence**: HIGH
**Source**: `src/partial_match.rs::tests`; unit test suite (partial_match module); property tests
**Subject**: Partial-match
**Behavior**: Single-substring match returns `MatchResult::Ambiguous(matches)`. Callers must reject this under `--no-input`. This is the fail-closed invariant.

**Edge cases**:
- **(EC-1) Ambiguous input short-circuits before any network call (no-network pre-API property)**: `partial_match` is a pure function — it takes a `&str` input and a `&[String]` candidates slice and returns a `MatchResult` without performing any I/O. The callers (e.g., `src/cli/queue.rs::resolve_queue_by_name`, `src/cli/issue/workflow.rs` move-status resolution, `src/cli/requesttype.rs` request-type name resolution, `src/cli/issue/helpers.rs::resolve_component` — **[NEW 2026-08-15 issue #605/#606/#608 F2]** project-scoped component name resolution, see below) evaluate `partial_match` BEFORE issuing any additional HTTP requests. Consequence: when the result is `MatchResult::Ambiguous`, the handler exits 64 with the disambiguation message and ZERO extra HTTP requests are issued beyond the initial list-fetch needed to populate the candidates. Wiremock integration tests can assert `expect(1)` (list fetch only, no follow-on GET/PUT/POST) to verify this no-network property. The no-network behavior is a consequence of `partial_match` being a pure function, not a separately configurable mode.

**[NEW 2026-08-15 issue #605/#606/#608 F2] Component resolver caller**: `src/cli/issue/helpers.rs::resolve_component` (pending F4) is a new caller of this primitive, added by the component-management bundle. It wraps `partial_match` with a component-specific numeric-id bypass (all-ASCII-digit input skips `partial_match` entirely, mirroring the `requesttype fields <NAME|ID>` convention already cited above) and always scopes the `candidates` slice to a SINGLE project's component-name list — never a cross-project union. The component-specific caller contract (numeric bypass, project scoping, disambiguation message shapes) is owned by `bc-8-components.md` §8.4 (BC-8.4.001..005); this file continues to own only the shared `partial_match` primitive itself. See BC-8.4.001 for the full caller contract and BC-8.4.004 for the cross-project-non-collision invariant this scoping enforces.

**Trace**: Pass 3 BC-105 context; `src/partial_match.rs` (pure function — no I/O); `src/cli/queue.rs::resolve_queue_by_name` (ambiguous → exit 64 before queue-issues fetch); `src/cli/issue/workflow.rs` (ambiguous status name → exit 64 before transition POST); `src/cli/requesttype.rs` (ambiguous RT name → exit 64 before RT-fields fetch); `src/cli/issue/helpers.rs::resolve_component` (ambiguous/unknown component name → exit 64 before any create/edit/delete/rename mutating call — see `bc-8-components.md` §8.4, BC-8.4.001..005, added 2026-08-15 F2); `tests/queue.rs::resolve_queue_single_substring_is_ambiguous` — this test mounts ONLY the queue-list GET and asserts the Ambiguous short-circuit (`JrError::UserError` + `"matches multiple queues"` message); the second endpoint (queue-issues) is never mounted, so any follow-on request would return 404 as unmatched. The zero-follow-on-HTTP property holds STRUCTURALLY via `partial_match` purity. This test does NOT use a wiremock `expect(1)` call-count pin (confirmed: zero `.expect(` calls in the test body); adding one (as in `tests/requesttype_commands.rs::test_requesttype_list_cache_hit_no_second_http`) is recommended future coverage.

---

#### BC-X.10.002: `partial_match(s, &candidates)` proptest: exact match always found; never panics on arbitrary input; empty candidates → None

**Confidence**: HIGH
**Source**: `src/partial_match.rs:~153`
**Trace**: Pass 3 BC-1095..BC-1097 (R4)

---

#### BC-X.10.003: Duplicate candidates → `MatchResult::ExactMultiple(name)` with `name.to_lowercase() == input.to_lowercase()`

**Confidence**: HIGH
**Source**: `src/partial_match.rs:~182`
**Trace**: Pass 3 BC-1098 (R4)

---

### X.11 Build-Time

#### BC-X.11.001: `build.rs` reads `JR_BUILD_OAUTH_CLIENT_ID` + `_SECRET` env vars

**Confidence**: HIGH
**Source**: `build.rs` (125 LOC)
**Trace**: Pass 3 BC-1301

---

#### BC-X.11.002: Unix → `/dev/urandom` for 32-byte XOR key; Windows → inline `BCryptGenRandom` FFI

**Confidence**: HIGH
**Source**: `build.rs`
**Trace**: Pass 3 BC-1302

---

#### BC-X.11.003: Non-unix/non-windows → `compile_error!`

**Confidence**: HIGH
**Source**: `build.rs`
**Trace**: Pass 3 BC-1303

---

#### BC-X.11.004: Unset build vars → `EMBEDDED_*` constants are `None`; BYO/prompt path proceeds

**Confidence**: HIGH
**Source**: `build.rs`; `src/api/auth_embedded.rs::tests`
**Trace**: Pass 3 BC-1304

---

#### BC-X.11.005: `proptest-regressions/jql.txt` pinned regression seed for `escape_value("")`

**Confidence**: HIGH
**Source**: `proptest-regressions/jql.txt`
**Trace**: Pass 3 BC-1103 (R4)

---

## BC-X.12: JSM Request Type Discovery

8 behavioral contracts covering `jr requesttype list` and `jr requesttype fields` subcommands,
backed by the service desk requesttype API. These are discovery commands used before
`jr issue create --request-type` to identify valid request types and their required fields.

---

#### BC-X.12.001: `jr requesttype list` lists request types for the active project's service desk

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: `jr requesttype list --project <KEY>` calls `GET /rest/servicedeskapi/servicedesk/<id>/requesttype` (paginated via `isLastPage`). Default table output shows columns: Name, Description. ID is available in `--output json` only. Returns all request types for the resolved service desk. Uses `require_service_desk(client, key)` to resolve the `serviceDeskId` before calling the list endpoint.
**Inputs**: `--project <KEY>` (required; uses active-profile project if absent and profile has one configured)
**Outputs/Effects**: stdout table (Name + Description columns by default); exit 0 on success.
**Errors**: No project configured and no `--project` flag → exit 64 "project is required". Non-JSM project → exit 64 via `require_service_desk` (BC-X.8.004).
**Trace**: `tests/requesttype_commands.rs` (list command, table output); `src/cli/requesttype.rs`; `src/api/jsm/request_types.rs`
**Source**: API-verified: `GET /rest/servicedeskapi/servicedesk/{id}/requesttype` returns `{start, limit, isLastPage, values}`
**Confidence**: HIGH

---

#### BC-X.12.002: `--search <QUERY>` filters via JSM `searchQuery` parameter (name or description partial match)

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: When `--search <QUERY>` is set, the `searchQuery` query parameter is appended to `GET /rest/servicedeskapi/servicedesk/<id>/requesttype?searchQuery=<QUERY>`. Filtering is server-side (Atlassian API). No client-side secondary filtering is applied. If `--search` returns an empty `values` array, the command exits 0 with an empty table (NOT an error). The `searchQuery` parameter supports name and description substring matching as defined by the Atlassian API.
**Inputs**: `--search <QUERY>` (optional)
**Outputs/Effects**: Filtered request type list; may be empty table on no match.
**Errors**: API error (5xx) → exit 1 + "API error (N)". 401 → exit 2 + `jr auth login`.
**Trace**: `tests/requesttype_commands.rs` (search parameter propagation, empty-result path)
**Source**: API-verified: `searchQuery` is a supported query param on the list endpoint
**Confidence**: HIGH

---

#### BC-X.12.003: `--project <KEY>` overrides active profile; `require_service_desk` errors clean on non-JSM project with call-site-specific message

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: `--project <KEY>` takes precedence over any project configured in the active profile (same precedence rule as all other project-flag uses). The flag is the non-interactive mechanism for specifying the target project. `require_service_desk` returns a typed error for non-JSM (software) projects — the command exits 64 with a call-site-specific error message (NOT the legacy "Queue commands require…" string). Error message MUST be: 'Project "<KEY>" is a <type> project. `jr requesttype` commands require a Jira Service Management project. Run "jr project list" to find a JSM project.' Zero HTTP calls to the requesttype endpoint are made.
**Inputs**: `--project <KEY>` (overrides profile-level project config)
**Outputs/Effects**: Project-scoped service desk ID resolved before any requesttype API call.
**Errors**: Non-JSM project → exit 64 + call-site-specific message (see above); NO requesttype HTTP. Software project check fires before the list request.
**Trace**: `tests/requesttype_commands.rs` (non-JSM project exit-64 path); `src/api/jsm/servicedesks.rs::require_service_desk`
**Source**: Reuses `require_service_desk` established for `jr queue`; caller-supplied context label per BC-X.8.004 [UPDATED 2026-05-18 issue #288]
**Confidence**: HIGH

---

#### BC-X.12.004: `--output json` returns structured JSON array; default table shows Name + Description columns

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: `jr requesttype list --output json` returns a JSON array to stdout: `[{id: "<str>", name: "<str>", description: "<str>", helpText: "<str>"|null, issueTypeId: "<str>"|null, groupIds: ["<str>", ...]}, ...]`. Each element uses the fields returned by the Atlassian API; `null` for absent optional fields. Table output (default) shows Name + Description columns only; ID is not shown in table mode. Truncation hint ("Showing N of M") goes to stderr when applicable.
**Inputs**: `--output json` (optional flag)
**Outputs/Effects**: stdout JSON array on `--output json`; stdout table on default.
**Errors**: Empty list returns `[]` (JSON) or empty table; NOT an error condition.
**Trace**: `tests/requesttype_commands.rs` (JSON output shape, table output shape); body deserialization tests
**Source**: API-verified: response values include `id`, `name`, `description`, `helpText`, `issueTypeId`, `groupIds`
**Confidence**: HIGH

---

#### BC-X.12.005: `jr requesttype fields <NAME|ID>` lists fields for a request type

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: `jr requesttype fields <NAME|ID> --project <KEY>` resolves the request type (by name or numeric ID, same logic as BC-X.12.006 below), then calls `GET /rest/servicedeskapi/servicedesk/<id>/requesttype/<rtId>/field`. Returns metadata about each field: `fieldId`, `name`, `required` (bool), `jiraSchema` (system/custom type info), and optionally `defaultValues` and `validValues`. Default table output shows columns: Field Name, Required (YES/NO), Type.
**Inputs**: `<NAME|ID>` positional argument (required); `--project <KEY>` (required or from profile)
**Outputs/Effects**: stdout table with field metadata; exit 0 on success.
**Errors**: Request type not found → exit 64 via `partial_match` (BC-X.12.006). Non-JSM project → exit 64 via `require_service_desk`.
**Caching**: Fields for a request type are cached per `(profile, serviceDeskId, requestTypeId)` with 7-day TTL at cache key `~/.cache/jr/v1/<profile>/request_type_fields_<service_desk_id>_<request_type_id>.json`. Cache miss → HTTP fetch + write. Corrupt or expired cache is treated as a miss (self-heals). Recovery path: manual deletion of the cache file (same convention as BC-X.12.008 for the request-type list cache). No `--refresh` flag is provided in this delta.
**Trace**: `tests/requesttype_commands.rs` (fields command, required/optional field rendering, cache hit: second call fires no HTTP); `src/cli/requesttype.rs`; `src/api/jsm/request_types.rs`; `src/cache.rs` (request_type_fields cache read/write functions)
**Source**: API-verified: `GET .../requesttype/{rtId}/field` returns `{canRaiseOnBehalfOf, canAddRequestParticipants, requestTypeFields[{fieldId, name, description?, required, defaultValues?, validValues?, jiraSchema{system|custom|customId|type}, visible}]}`. See also architecture-delta.md §"Cache Key Prefix".
**Confidence**: HIGH

---

#### BC-X.12.006: Partial-name resolution for `<NAME|ID>` uses `partial_match`; ambiguity errors with disambiguation hint

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: When `<NAME|ID>` is a non-numeric string, the handler fetches (or cache-hits) the request type list, extracts names, and calls `partial_match(input, &names)`. `MatchResult::Exact(id)` → proceeds. `MatchResult::Ambiguous` → exits 64 with "Ambiguous request type" + all candidate names listed in stderr + hint "Run `jr requesttype list --project <KEY>` to see all request types". `MatchResult::None` → exits 64 with "Request type not found: <input>" + same hint. `MatchResult::ExactMultiple(name)` (case-variant duplicates, e.g., "Password Reset" and "password reset") → exits 64 with `'Multiple request types named "<name>" found (IDs: <id1>, <id2>, ...). Pass the numeric ID directly.'` in stderr. Rationale: Atlassian REST does not guarantee a stable ordering for case-variant duplicates within the same service desk, so deterministic resolution requires the numeric ID. This matches the `cli/queue.rs` precedent for duplicate queue names. In `--no-input` mode, ambiguous result exits 64 cleanly without prompting.
[UPDATED 2026-05-18 issue #288 adversary-pass-01 H-3]: ExactMultiple was previously documented as "treated as Exact, proceeds" — hardened to exits 64 after impl review confirmed Atlassian REST does not guarantee stable ordering for case-variant duplicates, making "pick first" non-deterministic and unsafe. Conservative resolution (require numeric ID) matches cli/queue.rs precedent.
[UPDATED 2026-05-18 issue #288 adversary-pass-01 M-2]: Hint verb changed from "Use" to "Run" to match imperative active voice used throughout jr's CLI ergonomics and the impl's actual emission.
**Inputs**: `<NAME|ID>` positional (non-numeric → name resolution; numeric → bypass as in BC-3.8.004)
**Outputs/Effects**: Resolved `requestTypeId` integer used for the field fetch call.
**Errors**: Ambiguous → exit 64; None → exit 64; both without firing the field GET.
**Trace**: `tests/requesttype_commands.rs` (partial-match disambiguation, not-found, numeric bypass); `src/partial_match.rs`
**Source**: Follows `partial_match` pattern established by `jr queue` and `jr issue move`
**Confidence**: HIGH

---

#### BC-X.12.007: `--output json` for `jr requesttype fields` returns structured JSON with `required` bool per field; default table shows Field, Required, Type

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: `jr requesttype fields <NAME|ID> --output json --project <KEY>` returns a JSON object to stdout: `{canRaiseOnBehalfOf: bool, canAddRequestParticipants: bool, fields: [{fieldId: "<str>", name: "<str>", required: bool, jiraSchema: {type: "<str>", ...}, defaultValues?: [...], validValues?: [...]}]}`. The `required` field is a boolean (true = must be provided by submitter). Default table output shows: Field (name column), Required (YES/NO), Type (from `jiraSchema.type`).
**Inputs**: `--output json` (optional flag)
**Outputs/Effects**: stdout JSON object on `--output json`; stdout table on default.
**Errors**: API error (5xx) → exit 1. 401 → exit 2.
**Trace**: `tests/requesttype_commands.rs` (JSON output shape, required flag rendering)
**Source**: API-verified: `requestTypeFields[].required` is a boolean field in the API response
**Confidence**: HIGH

---

#### BC-X.12.008: Request types cached per `(profile, serviceDeskId)` with 7-day TTL; cache miss self-heals; cache key: `v1/<profile>/request_types_<service_desk_id>.json`

**Confidence**: HIGH
**Subject**: JSM request type discovery
**Behavior**: On `requesttype list` or name-resolution calls, the handler first checks `read_request_type_cache(profile, service_desk_id)`. Cache hit (valid, within 7-day TTL) → returns cached `Vec<RequestType>` without HTTP. Cache miss (absent, expired, or corrupt JSON) → fetches from API, writes to `write_request_type_cache(profile, service_desk_id, types)`, then proceeds. Cache file path: `~/.cache/jr/v1/<profile>/request_types_<service_desk_id>.json`. The `<service_desk_id>` in the filename is the numeric service desk ID as a string. Cache is keyed per `(profile, serviceDeskId)` to respect multi-profile isolation invariant (different profiles may have different service desks). Corrupt cache file is treated as a miss (self-heals).
**Inputs**: profile name (active profile), serviceDeskId (resolved by `require_service_desk`)
**Outputs/Effects**: Cache write on miss; cache read on hit (no HTTP). Cache TTL = 7 days (matching all other `jr` caches).
**Errors**: Cache write failure is non-fatal (logged to stderr as hint; does not abort the command). Cache corruption is non-fatal (treated as miss).
**Stale-cache window**: Up to 7 days. If a Jira admin renames a request type or modifies its required fields, users will see stale data for up to 7 days. No `--refresh` or `--no-cache` flag is provided in this delta (deferred). Recovery path: users may force a refresh by deleting `~/.cache/jr/v1/<profile>/request_types_<service_desk_id>.json` manually. Cache miss on `partial_match::None` does NOT auto-retry with cache-bypass; the error message MUST hint at manual cache deletion: 'Request type "<NAME>" not found. Run `jr requesttype list --project <KEY>` to see all request types, or delete the cache file at ~/.cache/jr/v1/<profile>/request_types_<service_desk_id>.json if a recent admin change is suspected.'

[UPDATED 2026-05-18 issue #288 adversary-pass-04 M-1 + M-4] Aligned hint phrasing
to BC-X.12.006 ("see all request types") and added the `--project <KEY>` flag for
actionability when no profile project is configured. Prior wording ("current types"
without `--project`) is superseded; impl + tests already match the aligned form.
**Fields cache**: See BC-X.12.005 §Caching for the per-request-type fields cache (sibling cache, same 7-day TTL and recovery semantics).
**Trace**: `tests/requesttype_commands.rs` (cache hit: second call fires no HTTP); `src/cache.rs` (RequestTypeCache struct); `src/api/jsm/request_types.rs`
**Source**: Follows `teams.json` cache pattern; 7-day TTL matches all other caches in `src/cache.rs`
**Confidence**: HIGH

---

## BC-X.13: CI Guards

7 behavioral contracts covering Guard 0 (`tests/claude_md_citations.rs` — the CLAUDE.md doc-fallout
guard verifying every file-path citation resolves to a real on-disk file; BC-X.13.001..003),
Guard 1 (`scripts/check-bc-citation-symbols.sh` — the bc-*.md Trace/Source file::symbol citation
guard; BC-X.13.004..006; CITATION-GUARDS Story B, 2026-07-05), and Guard 2 (the `test` job's own
runtime test-execution floor in `.github/workflows/ci.yml` — a false-green CI guard, distinct from
Guards 0/1 which scan documentation rather than CI's own test-execution proof; BC-X.13.007;
FIX ROUND 12, S-626-1, 2026-08-05).

---

#### BC-X.13.001: Every in-scope backtick-quoted path citation in CLAUDE.md resolves to a real on-disk file; guard fails listing all dead references with source context

**Confidence**: HIGH
**Subject**: CI guard / doc-fallout invariant
**Behavior**: The `test_claude_md_citations_resolve_to_real_files` test in `tests/claude_md_citations.rs` reads `CLAUDE.md` via `include_str!("../CLAUDE.md")`, extracts every backtick-quoted token that is IN-SCOPE per BC-X.13.002 step (c) — either (1) starts with a develop-tracked directory prefix (`src/`, `tests/`, `docs/`, `.github/`, `scripts/`) OR (2) exactly equals a member of the curated ROOT_FILES set (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`) — AND has a recognized file extension (`.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`), after normalization per BC-X.13.002 (glob skip, symbol-form strip, line-ref strip, trailing-punct trim), then asserts `Path::new(root).join(&citation).exists()` for each remaining path. ALL `.factory/` prefixes are EXCLUDED — `.factory/` is git-ignored and lives in a separate orphan-branch worktree that is ABSENT from the CI checkout; dead-citation coverage for `.factory/` paths is handled by the maintenance doc-drift sweep, NOT this guard. Bare-filename shorthands (e.g., `ci.yml`, `adf.rs`, `fields.json`) that are not in ROOT_FILES remain excluded. On failure, the assertion message lists EVERY dead path (not just the first) with the canonical message format below. The test passes green on the current `develop` HEAD (zero dead citations) and fails deterministically when any newly-cited path does not exist.

**Preconditions**:
- `CLAUDE.md` is readable via `include_str!` at compile time
- The crate root (`CARGO_MANIFEST_DIR`) is the jira-cli repo root
- All cited develop-tracked paths in CLAUDE.md exist as files on the working branch at test time

**Postconditions (on success)**:
- Exit 0; test passes
- Every backtick token matching the in-scope grammar — dir-prefix (`src/...`, `tests/...`, `docs/...`, `.github/...`, `scripts/...`) OR ROOT_FILES exact-match (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`) — resolves to a real file

**Postconditions (on failure)**:
- Test fails with the CANONICAL failure message (exact wording, authoritative per error-taxonomy CI-CITE-001):
  ```
  CLAUDE.md cites file paths that do not exist on disk:
    <path> (line 142)
    <path> (line 287)
  Fix the citation or restore the file.
  Note: .factory/, glob, and symbol-form tokens are auto-excluded. Root-level files (Cargo.toml, CLAUDE.md, etc.) are checked.
  ```
- Each dead citation is listed on its own line, prefixed with two spaces, followed by ` (line {n})` where `{n}` is the real 1-based line number in CLAUDE.md where the backtick citation occurs — computed from the `(path, line)` pairs returned by `extract_path_citations` filtered by `!Path::exists()`
- The message includes the "Fix the citation or restore the file." instruction plus the auto-exclusion note and root-file inclusion note

**Invariants**:
- The guard runs on the 3-OS matrix (ubuntu, macos, windows) as part of the existing `test` job — no new CI job or `ci-gate.needs` edit required
- A citation that was valid when committed becomes a failing test the moment the referenced file is deleted or renamed — drift is caught at the NEXT CI run touching either CLAUDE.md or the deleted file
- `Path::join` (not string concatenation) is used to resolve paths — correct path-separator handling on Windows without a separate codepath
- ALL `.factory/` prefixes are excluded — no partitioning between `.factory/research/` (checked) and `.factory/specs/` (allowlisted); the old "off-branch allowlist" design is SUPERSEDED by this all-exclude rule
- ROOT_FILES members (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`) ARE checked — bare-filename shorthands not in ROOT_FILES remain excluded

**Edge Cases**:
- EC-CITE-001: CLAUDE.md contains zero in-scope citations → test passes (empty `dead` vec)
- EC-CITE-002: A citation uses `Detail: path1, path2` comma-delimited form → both tokens extracted (interior whitespace tokenization); trailing comma stripped by trailing-punct rule (BC-X.13.002 step (b) sub-step (4)) → both checked independently
- EC-CITE-003: A citation has CRLF line ending (Windows checkout) → `lines()` and `.trim_end_matches('\r')` normalize before tokenization; no false positive
- EC-CITE-004: A path with a recognized extension (e.g., `src/cli/issue.rs`) that resolves to a directory rather than a file → `Path::exists()` returns true for directories; guard passes (the "path is a directory" case only arises when an extensioned token happens to name an existing directory, which is extremely rare; extensionless directory tokens such as `src/cli/issue` are excluded earlier by the extension filter at step (d))
- EC-CITE-005: Two different CLAUDE.md lines cite the same path → path checked twice; redundant but not harmful (no dedup needed)
- EC-CITE-016 (M-1): Token appears inside a triple-backtick fenced code block (e.g., the architecture tree in CLAUDE.md) → OUT OF SCOPE; the guard extracts ONLY inline single-backtick spans, not fenced-block contents; fenced-block paths are never checked and never cause false positives
- EC-CITE-017: CLAUDE.md cites `.factory/research/S-3.03-wave3-verification.md` → prefix `.factory/` → EXCLUDED (not checked); no failure even if file exists or does not exist on the working tree
- EC-CITE-022 (forward-reference): A CLAUDE.md citation references a develop-tracked file (e.g., `tests/claude_md_citations.rs`) that does not yet exist on the working tree at CI time → the guard FAILS with a dead-citation error for that path. In-scope citations must reference files present in the SAME working tree at test time. The correct fix is to land the citation and the referenced file in the SAME commit or PR — e.g., the guard's own doc-fallout note in CLAUDE.md and the new `tests/claude_md_citations.rs` file must be introduced together, not in separate PRs.

**Canonical Test Vectors**:

| Input token (after backtick extraction) | In-scope? | Expected outcome |
|----------------------------------------|-----------|-----------------|
| `src/adf.rs` | YES | Pass (file exists) — dir-prefix rule |
| `tests/auth_profiles.rs` | YES | Pass (file exists) — dir-prefix rule |
| `docs/adr/0016-windows-build-target.md` | YES | Pass (file exists) — dir-prefix rule |
| `.factory/research/S-3.03-wave3-verification.md` | NO | Excluded (`.factory/` prefix) |
| `.factory/specs/prd/bc-3-issue-write.md` | NO | Excluded (`.factory/` prefix) |
| `scripts/check-spec-counts.sh` | YES | Pass (file exists) — dir-prefix rule |
| `src/api/jsm/nonexistent.rs` | YES | FAIL — listed in dead citations |
| `Cargo.toml` | YES | Pass (file exists) — ROOT_FILES inclusion |
| `CLAUDE.md` | YES | Pass (file exists) — ROOT_FILES inclusion |
| `build.rs` | YES | Pass (file exists) — ROOT_FILES inclusion |
| `deny.toml` | YES | Pass (file exists) — ROOT_FILES inclusion |
| `ci.yml` | NO | Excluded (not in ROOT_FILES; `.github/workflows/` shorthand) |
| `adf.rs` | NO | Excluded (not in ROOT_FILES; `src/` shorthand) |
| `fields.json` | NO | Excluded (not in ROOT_FILES; cache-file shorthand) |
| `~/.config/jr/config.toml` | NO | Excluded (no known dir prefix, not in ROOT_FILES) |
| `%APPDATA%\jr` | NO | Excluded (no known dir prefix, not in ROOT_FILES) |
| `http://127.0.0.1:53682/callback` | NO | Excluded (no known dir prefix, not in ROOT_FILES) |
| `JR_BASE_URL` | NO | Excluded (no `/` and no extension, not in ROOT_FILES) |
| `std::sync::Mutex` | NO | Excluded (no known dir prefix, not in ROOT_FILES) |
| `BC-3.2.013` | NO | Excluded (no `/`, not in ROOT_FILES) |
| `JRACLOUD-95368` | NO | Excluded (no `/`, not in ROOT_FILES) |

**Verification Properties**:
- VP-CITE-001: `extract_path_citations` grammar — unit + proptest coverage of in-scope detection and all normalization/exclusion rules including ROOT_FILES inclusion (EC-CITE-029..031); no false positives on documented edge cases. See `verification-delta-DEAD-CITATION-CI.md` §VP-CITE-001.
- VP-CITE-002: Integration self-verification — `test_claude_md_citations_resolve_to_real_files` passes green on develop HEAD; fails deterministically when fed a fixture with a known-dead citation; ROOT_FILES members (Cargo.toml, CLAUDE.md, etc.) are included in the existence check. See `verification-delta-DEAD-CITATION-CI.md` §VP-CITE-002.

**Traceability**:
- F1 Delta Analysis: `DEAD-CITATION-CI-delta-analysis.md` §7 BC-CITE-001
- Research: `maint-pg-dead-citation-ci-approach.md` §(a)
- Implementing story: S-MAINT-DEAD-CITATION-CI (F3)
- Source: `tests/claude_md_citations.rs::test_claude_md_citations_resolve_to_real_files` (new file)

---

#### BC-X.13.002: Backtick tokens with glob wildcards (`*`, `{`, `}`), symbol suffixes (`::fn`), line-ref suffixes (`:~NN`/`:NN`), trailing punctuation, and section refs (` §N`) are excluded from or normalized before the path-existence check — no false positives on these forms

**Confidence**: HIGH
**Subject**: CI guard / parser grammar
**Behavior**: The `extract_path_citations(doc: &str) -> Vec<(String, usize)>` helper in `tests/claude_md_citations.rs` applies a two-step extraction followed by a canonical pipeline in order before the `Path::exists()` check. Each entry in the returned vec is a `(normalized_path, line_number)` pair where `line_number` is the 1-based line in `doc` where the backtick citation token occurs. Line tracking is deterministic from the input string (count newlines up to the token start) and requires no I/O. The function remains pure (no `Path::exists()` calls inside):

**Two-step extraction (SR-001):**
1. Extract all inline single-backtick spans (`` `…` ``) from the CLAUDE.md text. Fenced triple-backtick code blocks are OUT OF SCOPE and never read (M-1).
2. Split each span interior on ASCII whitespace. Each whitespace-delimited token is a candidate citation.

Section-ref tokens (`§9`-style) require no special pipeline step — they lack a known directory prefix and are excluded automatically by the dir-prefix filter at step (c). Whitespace tokenization (step 2 above) has already separated them from any preceding path token.

**Canonical normalization/skip pipeline (steps applied in this exact order — SR-004, merged-fixpoint revision F2-Iter5):**

a. **Glob skip**: if the token contains `*`, `{`, or `}` anywhere, skip entirely (not checked). Handles ``.factory/specs/prd/bc-*.md``, `adf-{block,task}-list.md`, and similar brace-glob forms (SR-002).
b. **Normalize — single fixpoint (SR-005, merges former steps b/c/e)**: Repeat the following ordered sub-steps as ONE unit until a complete pass leaves the token unchanged:
   (1) strip a trailing `::…` symbol-form suffix (strip from first `::` onward). `src/adf.rs::push_text` → `src/adf.rs`. `adf::tests::test_bare_*` → already skipped at step (a).
   (2) strip a trailing `:~[0-9]+` or `:[0-9]+` line-ref suffix. `src/config.rs:~42` → `src/config.rs`.
   (3) strip one leading `(` or `[`.
   (4) greedily trim trailing `.`, `,`, `;`, `:` (repeat until none remain on this sub-step pass).
   (5) trim one trailing `)` iff `count('(') < count(')')` over the whole token.
   (6) trim one trailing `]` iff `count('[') < count(']')` over the whole token.
   **Termination**: ONE condition — a full pass (all six sub-steps) makes no change. There is no per-sub-step early exit. Merging symbol-strip (1), line-ref-strip (2), and punctuation-trim (3)–(6) into one fixpoint eliminates the ordering-class bug where a leading `(` prevented the line-ref suffix from being seen in a single non-iterating strip (F-PASS6-01): `(src/config.rs:~42)` → pass 1: sub-step (3) strips `(` → `src/config.rs:~42)`, sub-step (5) strips `)` → `src/config.rs:~42`; pass 2: sub-step (2) strips `:~42` → `src/config.rs`; pass 3: stable. Result: `src/config.rs` (checked).
c. **Dir-prefix filter + ROOT_FILES inclusion**: a token (after all normalization above) is IN-SCOPE if it meets EITHER of the following two conditions:
   - **Condition 1 (dir-prefix)**: the token starts with a develop-tracked directory prefix: `src/`, `tests/`, `docs/`, `.github/`, `scripts/`. ALL `.factory/` prefixes are excluded at this step — they are absent from the CI checkout. URL tokens (`http://`, `https://`), home-directory tokens (`~/`), Windows-env tokens (`%APP`), and bare identifiers with no `/` that do not exactly match ROOT_FILES are all excluded here as corollaries.
   - **Condition 2 (ROOT_FILES inclusion)**: the normalized token exactly equals one of the following curated root-level tracked files (this set is explicitly enumerated — do NOT expand it without updating BC-X.13.002):
     `ROOT_FILES = { build.rs, Cargo.toml, CHANGELOG.md, CLAUDE.md, deny.toml, README.md, rust-toolchain.toml }`
     These files are git-tracked at the repo root (confirmed by `git ls-files --full-name | grep -v /`) and are stable, citable reference targets. Bare-filename shorthands for files in subdirectories (e.g., `ci.yml` for `.github/workflows/ci.yml`, `adf.rs` for `src/adf.rs`, `fields.json` for a cache file) are NOT in ROOT_FILES and remain excluded.

   **False-positive-safety rationale**: the ROOT_FILES set is curated via exact-match, not a structural rule. The following categories are intentionally EXCLUDED from ROOT_FILES to prevent false positives:
   - Workflow shorthands: `ci.yml`, `e2e.yml`, `release.yml` → NOT in ROOT_FILES (they are `.github/workflows/` shorthands; checking them at root would false-positive)
   - Cache-file shorthands: `fields.json` → NOT in ROOT_FILES (a cache file shorthand, not a root file)
   - Source-file shorthands: `adf.rs`, `auth.rs`, `view.rs`, `comments.rs`, `refresh_coordinator.rs`, `embedded_oauth.rs` → NOT in ROOT_FILES (`src/` shorthands; covered by the dir-prefix rule if cited correctly)
   - `Cargo.lock` → NOT in ROOT_FILES (`.lock` is not in the recognized extension set at step (d), so it would be excluded there anyway; excluded from ROOT_FILES for consistency)
d. **Extension filter**: after all normalization, the token must end with a recognized file extension: `.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`. Extensionless tokens (`src/cli/issue`) are excluded here.
e. **Path::exists() check**: only tokens surviving steps (a)-(d) reach this check.

**Cardinality note (F2-Iter5 merged-fixpoint, supersedes F3-MINOR/LOW-1/LOW-2/LOW-3):** BC-X.13.002 now defines 5 top-level pipeline steps (a)–(e). Step (b) is the single unified normalization fixpoint encompassing all former symbol-strip, line-ref-strip, and punctuation-trim rules as ordered sub-steps (1)–(6). Steps (c) and (d) are the two filter gates. Step (e) is the effectful existence check. References to the former (a)–(h) scheme (steps b/c/d/e/f/g/h) are superseded by this canonical (a)–(e) statement.

**Preconditions**:
- `extract_path_citations` is called with the full CLAUDE.md text as a `&str`
- The CLAUDE.md citation conventions described in CLAUDE.md §"Citation form in spec/CLAUDE.md" are in effect (symbol-form `<file>::<fn>`, approximate line `<file>:~NN`)

**Postconditions**:
- Returns `Vec<(String, usize)>` — each entry is `(normalized_path, line_number)` where `line_number` is the 1-based line in the input `doc` where the backtick citation token appears
- No token matching the glob, brace-glob, symbol-form, line-ref, trailing-punct, or section-ref patterns causes a false-positive path-existence failure
- After normalization (stripping in fixpoint step b), the underlying file path (e.g. `src/adf.rs`) IS checked — the guard doesn't skip the file entirely, only strips the disambiguation suffix
- `[docs/x.md]`-style bracket-wrapped tokens are CHECKED (not silently excluded) — fixpoint sub-step (6) strips the unbalanced `]` before the extension filter at step (d) runs
- `(src/config.rs:~42)`-style combined paren-wrapped + line-ref tokens are CHECKED — the merged fixpoint resolves both the leading `(` and the `:~42` suffix across successive passes (F-PASS6-01 fix)

**Invariants**:
- `::` cannot appear in a file path on any supported OS (Windows, macOS, Linux) — stripping `::.*` in sub-step (1) is unambiguous and safe
- A glob/brace-glob pattern (`*`, `{`, `}`) causes skip at step (a), not strip — the base path before the wildcard would be a directory, not a file, and the glob intent is documentation of a naming pattern, not a specific file
- The single unified fixpoint at step (b) is the sole normalization loop — there is no separate per-rule single-pass outside it
- **ROOT_FILES set is immutable without a BC update (F2 amendment):** The curated set `{ build.rs, Cargo.toml, CHANGELOG.md, CLAUDE.md, deny.toml, README.md, rust-toolchain.toml }` is ENUMERATED in BC-X.13.002 step (c). Adding or removing a root file from the set requires updating this BC, the arch-delta, and the verification-delta in the SAME commit. Never expand ROOT_FILES by structural rule (e.g., "all root files with extension X") — the exact-match approach is the false-positive-safety guarantee.
- **ROOT_FILES extension dependency:** Every file in ROOT_FILES must also have a recognized extension per step (d) (`.md`, `.rs`, `.sh`, `.toml`, `.yml`, `.yaml`). `Cargo.lock` is excluded because `.lock` is not in the recognized extension set; if `.lock` were added to the extension filter, `Cargo.lock` could be added to ROOT_FILES. Do not add files to ROOT_FILES whose extension is not in step (d).
- **Case-sensitivity limitation (M-2, v1 documented):** `Path::exists()` uses the host OS's native case sensitivity. On case-insensitive filesystems (macOS HFS+, Windows NTFS), a citation with wrong case (e.g., `Src/adf.rs` instead of `src/adf.rs`) will return true and pass the guard. This is a documented v1 limitation; case-exact readdir validation is deferred to v2.
- **Space-containing paths (L-2, v1 documented):** paths containing spaces are unsupported by the whitespace tokenizer and will be split into multiple fragments. By design; no escape exists in v1.
- **Backslash paths (L-4, v1 documented):** only forward-slash path tokens are recognized. Windows-style `%APPDATA%\jr` paths are excluded by the dir-prefix filter at step (c) and are not checked.
- **Proptest alphabet requirement:** The proptest covering `extract_path_citations` must include `]` alongside `(`, `)`, `[` in its character alphabet, and must include `:`, `~` to exercise the line-ref strip sub-step. Architect note: this applies to `VP-CITE-001`'s proptest coverage.

**Edge Cases**:
- EC-CITE-006: Token is `src/adf.rs::tests::test_bare_url_split_by_emphasis_links_only_leading_run` — fixpoint pass 1 sub-step (1) strips from first `::` → `src/adf.rs` → stable → checked → pass
- EC-CITE-007: Token is `src/config.rs:~42` — fixpoint pass 1 sub-step (2) strips `:~42` → `src/config.rs` → stable → checked → pass
- EC-CITE-008: Token is `.factory/specs/prd/bc-*.md` — contains `*` → skip entirely at step (a) → no false positive
- EC-CITE-009: Token is `docs/specs/e2e-live-jira-testing.md §9` — whitespace tokenization yields `docs/specs/e2e-live-jira-testing.md` (checked) and `§9` (excluded by dir-prefix filter at step c) → pass
- EC-CITE-010: Token is `adf::tests::test_bare_url_split` — has `::` but NO known directory prefix in the portion before `::` — after fixpoint strip `adf` has no known prefix → excluded by dir-prefix filter at step (c)
- EC-CITE-011: Token is `src/cli/issue` (no extension, from hypothetical prose) — fixpoint leaves token unchanged; no recognized extension after normalization → excluded by extension filter at step (d)
- EC-CITE-012 (trailing punct): Token is `src/adf.rs,` from a comma-delimited `Detail:` line — fixpoint sub-step (4) trims trailing comma → `src/adf.rs` → checked → pass
- EC-CITE-013 (brace-glob): Token is `adf-{block,task}-list.md` — contains `{` and `}` → skip at step (a) → no false positive
- EC-CITE-014 (unbalanced paren — leading punct): Token is `(src/adf.rs)` from prose — fixpoint pass 1: sub-step (3) strips leading `(` → `src/adf.rs)`; sub-step (5) `count('(')=0 < count(')')=1` → strips `)` → `src/adf.rs`; pass 2: stable → passes dir-prefix filter (step c) → checked. Outcome: CHECKED (no false negative).
- EC-CITE-015 (balanced paren — no leading punct): Token is `src/types/assets/mod.rs(foo)` (hypothetical) — no leading `(` or `[` to strip at sub-step (3); sub-step (5): `count('(')=1, count(')')=1` → balanced → NOT trimmed; fixpoint: stable → token remains `src/types/assets/mod.rs(foo)` → extension filter at step (d) excludes it (no recognized terminal extension after `)`) → excluded, no false positive. Outcome: EXCLUDED (correct; the `(foo)` suffix is not a real file path).
- EC-CITE-016 (fenced block, M-1): Token appears inside a triple-backtick fenced code block → not extracted (only inline single-backtick spans are processed) → never checked
- EC-CITE-023 (`[`/`]` symmetric trim, LOW-1): Token is `[docs/x.md]` — fixpoint pass 1: sub-step (3) strips leading `[` → `docs/x.md]`; sub-step (6) `count('[')=0 < count(']')=1` → strips `]` → `docs/x.md`; pass 2: stable → passes dir-prefix + extension filters → CHECKED. Without sub-step (6), the `.md]` suffix fails the extension filter and the citation is silently excluded — a latent false-negative.
- EC-CITE-024 (mixed trailing punct, LOW-2): Token is `(src/adf.rs).` — fixpoint pass 1: sub-step (3) strips `(` → `src/adf.rs).`; sub-step (4) strips `.` → `src/adf.rs)`; sub-step (5) `count('(')=0 < count(')')=1` → strips `)` → `src/adf.rs`; pass 2: stable → checked. Demonstrates sub-step (4) plain-punct stripping runs before the bracket balance checks within one pass.
- EC-CITE-025 (double-wrap, LOW-3): Token is `((src/x.rs))` — fixpoint pass 1: sub-step (3) strips leading `(` → `(src/x.rs))`; sub-step (5) `count('(')=1, count(')')=2` → strips one `)` → `(src/x.rs)`; pass 2: sub-step (3) strips `(` → `src/x.rs)`; sub-step (5) `count('(')=0, count(')')=1` → strips `)` → `src/x.rs`; pass 3: stable → checked. Single-fixpoint rule handles arbitrarily nested wraps deterministically.
- EC-CITE-026 (paren-wrap + line-ref — F-PASS6-01 fix): Token is `(src/config.rs:~42)` — fixpoint pass 1: sub-steps (1)/(2) find no suffix to strip (still has leading `(`); sub-step (3) strips leading `(` → `src/config.rs:~42)`; sub-step (5) `count('(')=0 < count(')')=1` → strips `)` → `src/config.rs:~42`; pass 2: sub-step (2) strips `:~42` → `src/config.rs`; pass 3: stable → checked → pass. Under the former separated pipeline this token was a false-negative: the one-shot line-ref strip ran on `(src/config.rs:~42)` (no match, trailing `)`), leaving `:~42` after paren trim completed.
- EC-CITE-027 (line-ref + trailing comma): Token is `src/api/client.rs:~195,` — fixpoint pass 1: sub-step (4) strips trailing `,` → `src/api/client.rs:~195`; pass 2: sub-step (2) strips `:195` → `src/api/client.rs`; pass 3: stable → checked → pass.
- EC-CITE-028 (symbol-form + trailing punct): Token is `src/foo.rs::bar().` — fixpoint pass 1: sub-step (1) strips from first `::` → `src/foo.rs`; sub-steps (2)-(6) find nothing to strip on `src/foo.rs`; pass 2: stable → checked → pass. (The trailing `.` is inside the `::bar().` suffix and is eliminated together with it by sub-step (1); no separate plain-punct pass is needed.)
- EC-CITE-029 (ROOT_FILES inclusion — Cargo.toml): Token is `Cargo.toml` — no known dir prefix; exactly matches ROOT_FILES member → IN-SCOPE at step (c) → passes extension filter at step (d) (`.toml`) → checked. `Cargo.toml` exists at repo root → pass. Demonstrates that root-level file citations without a dir prefix ARE checked when in ROOT_FILES.
- EC-CITE-030 (ROOT_FILES exclusion — ci.yml shorthand): Token is `ci.yml` — no known dir prefix; does NOT exactly match any ROOT_FILES member → EXCLUDED at step (c). The file `.github/workflows/ci.yml` exists, but the bare `ci.yml` shorthand is a path shorthand, not a root file; checking it at root would false-positive. Correct citation is `.github/workflows/ci.yml`.
- EC-CITE-031 (ROOT_FILES exclusion — adf.rs shorthand): Token is `adf.rs` — no known dir prefix; does NOT exactly match any ROOT_FILES member (`adf.rs` is a shorthand for `src/adf.rs`, not a root file) → EXCLUDED at step (c). No false positive. The correct citation is `src/adf.rs` (which IS in-scope via the dir-prefix rule).
- EC-CITE-032 (ROOT_FILES paren-wrapped — punctuation interaction): Token is `(Cargo.toml)` — fixpoint pass 1: sub-step (3) strips leading `(` → `Cargo.toml)`; sub-step (5) `count('(')=0 < count(')')=1` → strips `)` → `Cargo.toml`; pass 2: stable. Now no dir prefix, but exactly matches ROOT_FILES member → IN-SCOPE at step (c) → passes extension filter at step (d) (`.toml`) → CHECKED. `Cargo.toml` exists at repo root → pass. **Load-bearing interaction:** confirms that punctuation unwrapping (step b) runs BEFORE the ROOT_FILES exact-match test (step c) — a token like `(Cargo.toml)` reaches the ROOT_FILES check only after the fixpoint strips its parens. Proptest note: the proptest alphabet must include `(` and `)` to exercise this interaction (i.e., generate `(Cargo.toml)` class inputs); the architect should add a `Cargo.toml` (or any ROOT_FILES member) with paren wrapping to the VP-CITE-001 proptest alphabet so the wrap+exact-match interaction is exercised by random inputs.

**Canonical Test Vectors** (for `extract_path_citations` unit tests; returned type is `Vec<(String, usize)>` — tests assert on the path component of each tuple):

| Raw backtick content | Extracted path (after normalization) | Checked? |
|---------------------|-------------------------------------|---------|
| `src/adf.rs::push_text` | `src/adf.rs` (fixpoint sub-step (1) strips `::push_text`) | YES |
| `src/config.rs:~42` | `src/config.rs` (fixpoint sub-step (2) strips `:~42`) | YES |
| `.factory/specs/prd/bc-*.md` | (skipped — contains `*`, step a) | NO |
| `adf-{block,task}-list.md` | (skipped — contains `{`, step a) | NO |
| `docs/specs/e2e-live-jira-testing.md` | `docs/specs/e2e-live-jira-testing.md` | YES |
| `adf::tests::test_bare_*` | (skipped — contains `*`, step a) | NO |
| `std::sync::Mutex<HashMap>` | (excluded — no known dir prefix, step c) | NO |
| `src/api/jsm/servicedesks.rs::require_service_desk` | `src/api/jsm/servicedesks.rs` (fixpoint sub-step (1)) | YES |
| `.factory/research/S-3.03-wave3-verification.md` | (excluded — `.factory/` prefix, step c) | NO |
| `src/config.rs,` | `src/config.rs` (fixpoint sub-step (4) trims trailing comma) | YES |
| `(src/adf.rs)` | `src/adf.rs` (fixpoint: sub-step (3) strips `(`; sub-step (5) strips unbalanced `)`) | YES |
| `src/types/assets/mod.rs(foo)` | excluded (fixpoint: `)` is balanced → not stripped; no recognized extension after `)`, step d) | NO |
| `[docs/x.md]` | `docs/x.md` (fixpoint: sub-step (3) strips `[`; sub-step (6) strips unbalanced `]`) | YES |
| `(src/adf.rs).` | `src/adf.rs` (fixpoint pass 1: sub-step (3) strips `(` → `src/adf.rs).`; sub-step (4) strips `.` → `src/adf.rs)`; sub-step (5) strips `)` → `src/adf.rs`; pass 2: stable) | YES |
| `((src/x.rs))` | `src/x.rs` (fixpoint pass 1: sub-step (3) strips `(` → `(src/x.rs))`; sub-step (5) strips one `)` → `(src/x.rs)`; pass 2: sub-step (3) strips `(` → `src/x.rs)`; sub-step (5) strips `)` → `src/x.rs`; pass 3: stable) | YES |
| `(src/config.rs:~42)` | `src/config.rs` (fixpoint pass 1: sub-step (3) strips `(` → `src/config.rs:~42)`; sub-step (5) strips `)` → `src/config.rs:~42`; pass 2: sub-step (2) strips `:~42` → `src/config.rs`; pass 3: stable — NEW, EC-CITE-026, F-PASS6-01 fix) | YES |
| `src/api/client.rs:~195,` | `src/api/client.rs` (fixpoint pass 1: sub-step (4) strips `,` → `src/api/client.rs:~195`; pass 2: sub-step (2) strips `:195` → `src/api/client.rs`; pass 3: stable — NEW, EC-CITE-027) | YES |
| `src/foo.rs::bar().` | `src/foo.rs` (fixpoint pass 1: sub-step (1) strips `::bar().` → `src/foo.rs`; pass 2: stable — NEW, EC-CITE-028) | YES |
| `Cargo.toml` | `Cargo.toml` (no dir prefix; exactly matches ROOT_FILES member → step (c) passes; `.toml` passes step (d) → checked — NEW, EC-CITE-029) | YES |
| `ci.yml` | excluded (no dir prefix; NOT in ROOT_FILES — bare shorthand for `.github/workflows/ci.yml`; step (c) excludes — NEW, EC-CITE-030) | NO |
| `adf.rs` | excluded (no dir prefix; NOT in ROOT_FILES — shorthand for `src/adf.rs`; step (c) excludes — NEW, EC-CITE-031) | NO |
| `(Cargo.toml)` | `Cargo.toml` (fixpoint pass 1: sub-step (3) strips `(` → `Cargo.toml)`; sub-step (5) strips unbalanced `)` → `Cargo.toml`; pass 2: stable → exactly matches ROOT_FILES member → step (c) passes; `.toml` passes step (d) → checked — NEW, EC-CITE-032) | YES |
| `fields.json` | excluded (no dir prefix; NOT in ROOT_FILES — cache-file shorthand; step (c) excludes) | NO |
| `release.yml` | excluded (no dir prefix; NOT in ROOT_FILES — `.github/workflows/` shorthand; step (c) excludes) | NO |

**Verification Properties**:
- VP-CITE-001: `extract_path_citations` grammar — unit + proptest coverage of all normalization/exclusion rules including glob-skip at step (a) (with `{`/`}`), merged-fixpoint at step (b) (symbol-form strip sub-step 1, line-ref strip sub-step 2, leading-bracket strip sub-step 3, plain-punct trim sub-step 4, unbalanced `)` trim sub-step 5, unbalanced `]` trim sub-step 6), dir-prefix filter and ROOT_FILES inclusion at step (c) (curated set: `build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`; bare shorthands `ci.yml`, `adf.rs`, `fields.json`, `release.yml` excluded), extension filter at step (d); no false positives on any documented edge cases including combined paren-wrap + line-ref tokens (EC-CITE-026) and ROOT_FILES shorthands (EC-CITE-029..031). See `verification-delta-DEAD-CITATION-CI.md` §VP-CITE-001.

**Traceability**:
- F1 Delta Analysis: `DEAD-CITATION-CI-delta-analysis.md` §5b OUT-OF-SCOPE, §6 Risk 1/2/3/4
- Research: `maint-pg-dead-citation-ci-approach.md` §(d) grammar rules 4/5
- Implementing story: S-MAINT-DEAD-CITATION-CI (F3)
- Source: `tests/claude_md_citations.rs::extract_path_citations` (new function; returns `Vec<(String, usize)>`; has inline `#[cfg(test)]` unit tests)

[REVISED 2026-06-19 F2-Iter5 F-PASS6-01] Merged the formerly separate symbol-form-strip step (b), line-ref-strip step (c), and punctuation-trim fixpoint step (e) into ONE unified normalization fixpoint as step (b) with ordered sub-steps (1)–(6). Pipeline is now (a)–(e) instead of (a)–(h). Root cause: under the former separated pipeline, a token like `(src/config.rs:~42)` caused a false-negative — the one-shot line-ref strip (former step c) ran when the token still had its leading `(`, so `:~42$` didn't match the trailing `)`, and after paren-trim completed the `:~42` residue was left unchecked. The merged single-fixpoint eliminates this ordering-class entirely by re-running all sub-steps until stable. Step (d) (section-ref) was always a no-op code marker — it is now folded into the extraction preamble prose. References to former steps (a)–(h) in external docs (arch-delta, verification-delta) have been propagated (F2-Iter6 step-letter propagation sweep, 2026-06-19).

---

#### BC-X.13.003: ALL `.factory/` paths are excluded from the guard; `.factory/` is absent from the CI checkout; the dead-citation class for `.factory/` is covered by the maintenance doc-drift sweep, NOT this guard

**Confidence**: HIGH
**Subject**: CI guard / directory scope
**Behavior**: The guard's step (c) filter (BC-X.13.002) recognizes ONLY the following as in-scope: tokens starting with develop-tracked directory prefixes (`src/`, `tests/`, `docs/`, `.github/`, `scripts/`) OR tokens exactly matching the ROOT_FILES set (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`). `.factory/` is NOT in either category — it is not a develop-tracked directory prefix and not a ROOT_FILES member. As a result, ALL `.factory/` citations — regardless of sub-path (`specs/`, `research/`, `holdout-scenarios/`, `cycles/`, or any other) — are excluded by the step (c) filter and never reach the `Path::exists()` check. The ROOT_FILES addition (F2 amendment 2026-06-19) does not affect `.factory/` exclusion — `.factory/` paths begin with `.factory/` not with any ROOT_FILES exact-match string.

**Rationale:** `.factory/` is git-ignored in the develop working tree and lives in a separate orphan-branch worktree (`factory-artifacts`). It is ABSENT from a normal `git checkout develop` or any CI checkout of `develop`. There is no sub-path partition within `.factory/` that is tracked on develop — the old "off-branch allowlist" design (which checked `.factory/research/` but allowlisted `.factory/specs/`) was based on an incorrect premise (`.factory/research/` is also absent from the CI checkout). That design is SUPERSEDED by this all-exclude rule.

Dead-citation coverage for `.factory/` paths is handled by the maintenance doc-drift sweep, which runs with access to the `factory-artifacts` worktree and can check factory-spec citations against their actual content.

There is NO `is_off_working_branch_allowlisted` function in the final implementation — the old allowlist concept is replaced by the simpler and correct dir-prefix exclusion rule.

**Preconditions**:
- The checked-out working tree is `develop` (or a feature branch off `develop`), produced by a standard `git checkout`
- `.factory/` is NOT present in this working tree (it is git-ignored and lives only in the orphan-branch worktree)

**Postconditions**:
- ANY CLAUDE.md citation starting with `.factory/` (e.g., `.factory/specs/prd/bc-3-issue-write.md`, `.factory/research/S-3.03-wave3-verification.md`, `.factory/holdout-scenarios/H-001.md`) does NOT cause the guard to fail — it is excluded by the step (c) filter before any existence check
- The guard only fails for dead citations that are either: (a) in develop-tracked directories (`src/`, `tests/`, `docs/`, `.github/`, `scripts/`) or (b) exact members of ROOT_FILES (`build.rs`, `Cargo.toml`, `CHANGELOG.md`, `CLAUDE.md`, `deny.toml`, `README.md`, `rust-toolchain.toml`) that do not exist at the repo root

**Invariants**:
- The dir-prefix filter is the single mechanism for `.factory/` exclusion — no allowlist function is needed or implemented
- Adding a new develop-tracked directory (e.g., `benchmarks/`) requires updating the dir-prefix filter in `extract_path_citations`; adding a new `.factory/` sub-path requires NO guard change
- The maintenance doc-drift sweep (not this guard) is the responsible party for `.factory/` citation health

**Edge Cases**:
- EC-CITE-017: CLAUDE.md cites `.factory/research/S-3.03-wave3-verification.md` → prefix `.factory/` → excluded by dir-prefix filter → not checked → no failure (supersedes the old "NOT allowlisted → checked" behavior)
- EC-CITE-018: CLAUDE.md cites `.factory/specs/prd/bc-3-issue-write.md` → prefix `.factory/` → excluded by dir-prefix filter → not checked → no false positive (same result as old allowlist, but via dir-prefix exclusion not allowlist lookup)
- EC-CITE-019: CLAUDE.md cites `.factory/holdout-scenarios/H-001.md` → prefix `.factory/` → excluded by dir-prefix filter → not checked → no false positive
- EC-CITE-020: CLAUDE.md cites `.factory/cycles/cycle-01.md` → prefix `.factory/` → excluded by dir-prefix filter → not checked → no false positive
- EC-CITE-021: A future CLAUDE.md citation uses a new `.factory/` sub-path not previously seen → still excluded (prefix rule; no allowlist update needed)

**Canonical Test Vectors** (for `extract_path_citations` step (c) filter unit tests):

| Path | Excluded by step (c) filter? | Rationale |
|------|------------------------------|-----------|
| `.factory/specs/prd/bc-3-issue-write.md` | YES | `.factory/` not in develop-tracked prefix set; not in ROOT_FILES |
| `.factory/holdout-scenarios/H-001.md` | YES | `.factory/` not in develop-tracked prefix set; not in ROOT_FILES |
| `.factory/cycles/cycle-01.md` | YES | `.factory/` not in develop-tracked prefix set; not in ROOT_FILES |
| `.factory/research/S-3.03-wave3-verification.md` | YES | `.factory/` not in develop-tracked prefix set; not in ROOT_FILES |
| `docs/adr/0016-windows-build-target.md` | NO | `docs/` is develop-tracked; existence is checked |
| `src/adf.rs` | NO | `src/` is develop-tracked; existence is checked |
| `.github/workflows/ci.yml` | NO | `.github/` is develop-tracked; existence is checked |
| `Cargo.toml` | NO | Exactly matches ROOT_FILES member; existence is checked (F2 amendment) |
| `CLAUDE.md` | NO | Exactly matches ROOT_FILES member; existence is checked (F2 amendment) |
| `build.rs` | NO | Exactly matches ROOT_FILES member; existence is checked (F2 amendment) |
| `ci.yml` | YES | NOT in ROOT_FILES (`.github/workflows/` shorthand); NOT a develop-tracked prefix token (F2 amendment) |

**Verification Properties**:
- VP-CITE-002: Integration self-verification — `test_claude_md_citations_resolve_to_real_files` passes green on develop HEAD; `.factory/` citations never trigger failures; fixture-based `test_dead_citation_detected_in_fixture` verifies develop-tracked dead citations ARE detected. See `verification-delta-DEAD-CITATION-CI.md` §VP-CITE-002.

**Traceability**:
- F1 Delta Analysis: `DEAD-CITATION-CI-delta-analysis.md` §5c (superseded by re-scope)
- Re-scope decision: DEAD-CITATION-CI F2 Iteration 2 (2026-06-19, human-approved)
- Implementing story: S-MAINT-DEAD-CITATION-CI (F3)
- Source: `tests/claude_md_citations.rs::extract_path_citations` (returns `Vec<(String, usize)>`; dir-prefix filter — `.factory/` absence from prefix set)

---

#### BC-X.13.004: Every `src/` file path cited in a `**Trace**:` or `**Source**:` field of any bc-*.md body resolves to a real on-disk file in the develop checkout; guard exits 1 listing all dead references with collect-all semantics; fail-closed SCOPE-EMPTY guard; coverage floor = floor(0.75 × N) ≈ 231 in CANONICAL_MODE

**Confidence**: HIGH
**Subject**: CI guard / Trace/Source file-existence (Guard 1)

**Behavior**: `scripts/check-bc-citation-symbols.sh` (Guard 1) scans all `bc-*.md` files in `.factory/specs/prd/` by running in the `spec-guard` CI job, which simultaneously mounts the develop checkout (containing `src/`) and the `factory-artifacts` worktree (containing `.factory/specs/prd/bc-*.md`). For each `bc-*.md` file, every line matching the anchor `^\*\*(Trace|Source)\*\*:` is extracted. From those lines, all backtick-quoted `src/` citation tokens are extracted via the space-tolerant two-pass extractor (see BC-X.13.005 Step 1 for the canonical extraction spec and normalization pipeline). Each extracted token is normalized to a bare file path (stripping `::symbol`, `:~NN`/`:NN` suffixes, and space-trailing content via the first-space split of Step 1 Pass 2 — see BC-X.13.005 Steps 1–3) and checked for file existence at `$src_root/$file`. Tokens with `::symbol` suffix additionally undergo a symbol-definition check (see BC-X.13.005 Step 5). Dead citations are accumulated into an offenders list without early exit — ALL citations in ALL bc-*.md files are checked before reporting (collect-all semantics, matching BC-X.13.001's approach). **Fail-closed SCOPE-EMPTY guard**: if no `bc-*.md` files are found in the bc_dir, the guard exits 1 immediately with `BC-CITE-001: no bc-*.md files found in <dir>` — the guard NEVER exits 0 vacuously on an empty corpus. **Coverage floor (CANONICAL_MODE only)**: after processing all citations, if the total count of checked `src/` citations is below `FLOOR = floor(0.75 × N)` — where N is the measured citation count on develop HEAD at delivery time; the F-01 two-tier recalibration yields N ≈ 309, FLOOR ≈ 231 (implementer remeasures at delivery; two-tier F-01 baseline on 2b09313: N=304+5=309; pre-two-tier post-Task-0-hygiene census: N=331, FLOOR=248; pre-hygiene D-154 census: N=326, FLOOR=244) — the guard exits 1 with `BC-CITE-COVERAGE-FLOOR: expected >= <FLOOR> src/ citations, got <N>. Update FLOOR when citations are intentionally removed (the floor is a lower bound; additions never fire it).` This floor guards against the fail-open scenario where an extraction-logic regression (e.g., bc_dir misconfiguration or regex change) silently drops all citations and exits 0 vacuously. `FLOOR` is declared once at script scope (top-level assignment, not `local` inside any function) — this is the single recalibration touchpoint; update it there when intentionally removing citations. `CANONICAL_MODE` is set to 1 at script entry when neither `--self-test` nor `--bc-dir` is supplied, and 0 otherwise; it is also a script-scope variable (see Invariants).

**Preconditions**:
- `scripts/check-bc-citation-symbols.sh` runs in the `spec-guard` CI job, which mounts both the develop checkout (`src/` tree available) and the `factory-artifacts` worktree (`.factory/specs/prd/bc-*.md` available); see BC-X.13.006 for CI topology
- At least one `bc-*.md` file exists in the bc_dir (fail-closed if not — SCOPE-EMPTY guard)
- `src/` paths cited in Trace/Source fields reference files tracked on develop HEAD at the time the citation was written

**Postconditions (on success)**:
- Guard exits 0; prints `Check passed: N citations checked` (N ≥ FLOOR when CANONICAL_MODE=1)
- Every `src/` file path extracted from a Trace/Source line in any bc-*.md file resolves to a real file under `$src_root`
- Every `src/file.rs::symbol` citation has the symbol present as a definition (not merely an import) in the referenced file (see BC-X.13.005 Step 5)

**Postconditions (on failure)**:
- Guard exits 1
- Dead citations are reported as one or more of:
  - `DEAD: <file> not found` — file path does not exist on disk
  - `DEAD: <symbol> not found in <file>` — file exists but symbol definition absent (see BC-X.13.005)
  - `DEAD: malformed citation skipped: <token>` — extracted token fails path shape guard (BC-X.13.005 Step 3b)
  - `BC-CITE-COVERAGE-FLOOR: expected >= <FLOOR> src/ citations, got <N>. Update FLOOR when citations are intentionally removed (the floor is a lower bound; additions never fire it).` (CANONICAL_MODE=1 only)
- Summary line (non-floor failures): `<K> stale citation(s) found in bc-*.md Trace/Source fields`
- ALL dead citations across ALL bc-*.md files are reported before exit (collect-all; no early termination)

**Invariants**:
- The guard runs in the spec-guard CI job on every PR touching develop, regardless of whether the PR modifies bc-*.md files — drift is caught at the NEXT spec-guard run after the referenced file is deleted or symbol moved
- `FLOOR` is a script-scope variable, NOT a `local` inside `run_check` (single declaration at script top — the single recalibration touchpoint). Because `FLOOR` is script-scope, self-test Fixture G can set `CANONICAL_MODE=1` in the shell environment and invoke `run_check` with an undersupply of citations, whereupon the comparison `[ "$total_citations" -lt "$FLOOR" ]` resolves the SAME `FLOOR` the guard uses — making the mutation-catching guarantee sound. A mutation that hardens the comparison to a literal (e.g., replaces `"$FLOOR"` with `"5"` in the comparison while leaving `"expected >= ${FLOOR}"` unchanged) is caught by Fixture G: the guard no longer exits 1 for a 100-citation undersupply (100 ≥ 5), so Fixture G sees exit 0 where it expects exit 1, catching the weakening. `FLOOR` uses the symbol in BOTH the comparison AND the message interpolation — they share the same script-scope binding.
- `CANONICAL_MODE` is a script-scope variable, NOT a `local` inside `run_check`; the Fixture G toggle mechanism (`CANONICAL_MODE=1` set in shell scope before invoking `run_check`) requires this to work correctly — if `CANONICAL_MODE` were `local`, Fixture G's toggle would be a no-op and the floor guard would false-green

**Edge Cases**:
- EC-CITE-033: No bc-*.md files in bc_dir → exit 1 immediately; `BC-CITE-001: no bc-*.md files found in <dir>` (SCOPE-EMPTY guard; never false-green on empty corpus)
- EC-CITE-034: bc-*.md files exist but have no Trace/Source lines → 0 citations extracted → CANONICAL_MODE floor guard fires (0 < FLOOR) → exit 1; non-CANONICAL_MODE → exit 0 (bc-*.md with no Trace/Source fields is unusual but not invalid)
- EC-CITE-035: Multiple backtick-quoted `src/` tokens on one Trace/Source line → each extracted independently; all checked; all offenders accumulated (collect-all)
- EC-CITE-036: A file cited in Trace/Source was deleted or renamed without updating the BC body → `DEAD: <file> not found` → guard fires deterministically on the next spec-guard run
- EC-CITE-037: Total citation count drops below FLOOR in CANONICAL_MODE (e.g., large BC refactor removes many Trace/Source lines) → `BC-CITE-COVERAGE-FLOOR:` message; developer updates `FLOOR=N` (script-scope assignment at script top — the single recalibration touchpoint) to the new validated baseline in the same commit

**Canonical Test Vectors**:

| Input (Trace/Source line content) | Expected outcome |
|-----------------------------------|-----------------|
| `**Trace**: \`src/cli/issue/edit.rs::handle_edit\`` (file exists, fn defined) | Pass — file exists, symbol check passes (BC-X.13.005) |
| `**Trace**: \`src/cli/issue/create.rs::handle_jsm_create\`` (file exists, fn only in import) | DEAD: handle_jsm_create not found in src/cli/issue/create.rs |
| `**Source**: \`src/cache.rs\`` (file exists, bare path) | Pass — bare file, existence check only |
| `**Trace**: \`src/nonexistent.rs::some_fn\`` (file absent) | DEAD: src/nonexistent.rs not found |
| No bc-*.md files in bc_dir | Exit 1; BC-CITE-001: no bc-*.md files found in \<dir\> |
| 0 citations extracted, CANONICAL_MODE=1, FLOOR=231 | Exit 1; BC-CITE-COVERAGE-FLOOR: expected >= 231 src/ citations, got 0 |

**Verification Properties**:
- VP-BC-CITE-001: File-existence assertion — every Trace/Source `src/` citation in bc-*.md is checked against the develop src/ tree; dead citations reported collect-all; SCOPE-EMPTY guard fires on empty corpus; coverage floor fires in CANONICAL_MODE when count < FLOOR. Covered by `scripts/check-bc-citation-symbols.sh --self-test` Fixtures B, D, F, G (S-BC-CITATION-GUARD-1 AC-002).
- VP-BC-CITE-002: Integration self-verification — guard exits 0 on develop HEAD with factory-artifacts mounted; Fixture G proves CANONICAL_MODE floor guard is active and FLOOR symbol is bound in both comparison and message.

**Traceability**:
- Implementing story: S-BC-CITATION-GUARD-1 (CITATION-GUARDS Story B, issue #102)
- Root-cause cycle: D-148 (12 stale Trace/Source citations in bc-3-issue-write.md after ADR-0012 Seam A/B; ~30 adversarial passes to hand-fix)
- F1 delta analysis: `.factory/phase-f1-delta-analysis/citation-guards-2026-07-02-delta.md §2`
- Error taxonomy: BC-CITE-001 (Section 8 of error-taxonomy.md)
- Source: `scripts/check-bc-citation-symbols.sh::run_check` (new file; CI script — not in `src/`)

---

#### BC-X.13.005: Extraction grammar for Guard 1 Trace/Source `src/` citation tokens — canonical extraction regex; `::symbol` form normalization; definition-anchored `fn`-grep for function symbols; v1-pragmatic shape-split (Type::method + constants); glob citation silent-skip; type-def/module-def checks deferred to v2

**Confidence**: HIGH
**Subject**: CI guard / Trace/Source citation extraction grammar (Guard 1)

**Behavior**: The `run_check` function in `scripts/check-bc-citation-symbols.sh` applies the following pipeline to each Trace/Source line (lines matching `^\*\*(Trace|Source)\*\*:` anchor), in this exact order:

**Step 1 — Extraction**: From each Trace/Source line, all backtick-quoted tokens starting with `src/` are extracted via a space-tolerant two-pass extractor (D-154 F-B2-02 fix):

- **Pass 1** — extract every full backtick-quoted token that begins with `src/`, including internal spaces: `` grep -oE '`src/[^`]+`' | tr -d '`' `` — MUST be `|| true`-guarded at the call site (i.e., `… | tr -d '`' || true`) so zero-match Trace/Source lines return empty string rather than aborting under `set -euo pipefail`; zero matches is a legitimate state that must flow to the SCOPE-EMPTY/coverage-floor guards, not abort extraction (Story A pipefail-safety precedent)
- **Pass 2** — for each extracted token, split on the first space (if present) and keep only the portion before the space. This correctly reduces: `` `src/file.rs § "section"` `` → `src/file.rs`; `` `src/config.rs:~269, 308-310` `` → `src/config.rs:~269` (further reduced at Step 2 line-ref strip); `` `src/api/jira/issues.rs::add_comment(internal: bool)` `` → `src/api/jira/issues.rs::add_comment(internal:` (Step 5 strip-from-first-`(` normalizes to `add_comment`).
- **Pass 2 — comma-lineref normalization**: after the space-split, strip any trailing `, NN` or `, NN-MM` groups that appear in the file component (comma-space line-ref list form, e.g., `src/cache.rs:~7, 30-32` → after space-split already reduced to `src/cache.rs:~7`; Step 2 line-ref strip then reduces to `src/cache.rs`).

**Why the fix matters**: the prior single-pass regex `` `src/[^` ]+` `` used a stop-on-backtick-OR-space character class. Any backtick-quoted token containing an internal space (10 comma-space line-ref lists + 1 fn-with-space-args, 11 tokens total in the corpus) failed to match at all and was silently dropped — these citations were neither checked nor counted. The two-pass form recovers all 11 tokens. N increases from ~315 to ~326; FLOOR increases from 236 to 244 (adjudication §4 census, 2026-07-06).

**Step 2 — Form classification**: Each extracted token is classified:
- **`::symbol` form**: `file="${token%%::*}"` (strip at first `::` → bare file path); `symbol="${token#*::}"` (first-`::` strip → full post-file component, e.g. `AdfBuilder::finish` for a `Type::method` token). If `file == token` (no `::`), the token has no symbol component — treat as bare-file form. Branch (f) re-derives `type_name` and method directly from the token: `type_name="${token%::*}"; type_name="${type_name##*::}"` (e.g., `src/adf.rs::AdfBuilder` → `AdfBuilder`); method = `"${token##*::}"` (e.g., `finish`). **Stricter Type::method consequence (intended):** with `symbol` = full post-file component, branch (a) fn-grep tests `fn AdfBuilder::finish` (never matches Rust source) and falls through to (f); a renamed Type with a surviving method is DEAD because the type-def grep in (f) fails — under the old `${token##*::}` single-last-component scheme the same citation was ALIVE via fn-grep on the method name alone.
- **`:~NN` or `:NN`/`:NN-MM` form** (line-ref suffix): `file="${token%%:*}"` (strip at first `:`); treated as bare-file form after stripping.
- **Bare file**: `file = $token`.

**Step 3 — Path shape validation**: Validate `file` against `^src/[a-zA-Z0-9_/.-]+\.[a-zA-Z0-9]+$` (any extension); reject path-traversal (`..`). Truly-malformed tokens (containing `..` or failing this shape — e.g. missing extension, illegal characters) → emit `DEAD: malformed citation skipped: <token>` (continue; do NOT exit early). **Glob-citation silent-skip (EC-011 class)**: if the file component contains `*` (e.g., `src/cli/**/*.rs` from a Trace/Source line referencing a directory pattern) → silently skip with no DEAD message. This mirrors BC-X.13.002 step (a)'s glob-skip rule: glob tokens document naming patterns, not specific files, and must not be DEAD-flagged.

**Step 3b — Tier assignment** (applied immediately after the shape guard passes and glob tokens are skipped):
- **Tier (i) — `.rs` tokens** (`file` ends in `.rs`): routed to the full pipeline — Step 4 file-existence check, then Step 5 symbol check (if `::symbol` form). Behavior unchanged from pre-F-01.
- **Tier (ii) — non-`.rs` `src/` tokens** (e.g., `.snap`, `.json`, `.toml`, `.txt`): routed to **file-existence-only** validation. Step 4 runs as normal (`[ -f "$src_root/$file" ]`; if absent → `DEAD: <file> not found`). Step 5 symbol check is **not run** — the symbol grammar (`fn`/`mod`/`struct`/`const` grep anchors) is Rust-specific and does not apply to non-Rust files. Non-`.rs` tokens **count toward `total_citations` / N** identically to `.rs` tokens — they contribute to the coverage floor denominator. Rationale: a `.snap` citation to a moved file is as dead as a `.rs` citation to a moved file; excluding them from the count would allow extraction-dropout to go undetected for this class.

**Step 4 — File-existence check**: `[ -f "$src_root/$file" ]` — if fails, emit `DEAD: <file> not found`; continue (do not attempt symbol check for a missing file).

**Step 5 — Symbol check (`::symbol` form only; tier (i) `.rs` tokens — tier (ii) tokens skip this step entirely)**: Strip from the first `(` onward from `symbol` before classification (`symbol="${symbol%%\(*}"` — subsumes bare `()` and `(args...)`, e.g., `cache_root()` → `cache_root`; `add_comment(internal: bool)` → `add_comment`; `from_config()` → `from_config`). Then apply the v1-pragmatic shape-split (ratified by research adjudication 2026-07-05, Q4):

(a) **Function / method (primary — applies to all symbols first)**: Definition-anchored grep (the canonical Guard 1 grep, preventing import-only false-greens — the D-148 class):
```bash
grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?((unsafe|const|async|extern[[:space:]]+\"[^\"]*\")[[:space:]]+)*fn[[:space:]]+${symbol}([^[:alnum:]_]|$)" \
    "$src_root/$file"
```
If this grep matches → ALIVE. If it fails → proceed to shape-based routing (b)/(c).

(b) **`::tests` module-path [D-154 addition — on fn-grep failure]**: If `symbol` matches `^tests$` (exact — the `mod tests` module-path form such as `src/adf.rs::tests`), run the module-definition anchored grep (verified against all 5 cited files in adjudication §2.1, 5/5 pass):
```bash
grep -Eq '^[[:space:]]*(pub[[:space:]]+)?mod[[:space:]]+tests[[:space:]{]' "$src_root/$file"
```
The `[[:space:]{]` end-anchor requires a space or opening brace after `tests`, preventing false-matches on `mod testsuite` or `mod tests_helpers`. If this grep matches → ALIVE. If it fails → DEAD (no further fallback for the `::tests` shape).

(c) **`::tests::testfn` composition [D-154 addition — on fn-grep failure]**: If the full post-file component of the token (everything between `file::` and end of token) matches `^tests::[a-z_][a-z0-9_]*$` (i.e., the token has the form `src/file.rs::tests::testfn`), apply a defense-in-depth composition: (1) run the `mod tests` check from (b) on the file; (2) run the fn-grep from (a) on the final `testfn` symbol. Both must pass → ALIVE. If either fails → DEAD. **Note**: in the current corpus the sole instance (`src/types/assets/linked.rs::tests::display_id_fallback_with_hint`) is also ALIVE via branch (a) alone — test functions are defined with `fn`, so the fn-grep on the final component succeeds independently. Branch (c) is therefore defense-in-depth that confirms the test module exists in addition to the function.

(d) **Constant [was (b) — on fn-grep failure]**: If `symbol` matches `^[A-Z][A-Z0-9_]*$` (all-caps Rust constant convention — uppercase letters, digits, underscores only), apply a secondary anchored grep:
```bash
grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?(const|static)[[:space:]]+${symbol}[[:space:]:]" \
    "$src_root/$file"
```
The `^[[:space:]]*` line anchor prevents mid-line false-greens — a `const` declaration occurring after non-whitespace content on the same line (e.g., in a doc comment `/// pub const NAME:` or a string literal) would match the unanchored form but is rejected by the anchor. The `(\([^)]*\))?` group captures visibility-restriction suffixes — `pub(crate)`, `pub(super)`, `pub(in path::to::mod)` — so constants like `pub(crate) const MAX_ADF_DEPTH: usize` are matched. The anchor and group together are the operative protection: without the anchor the `(\([^)]*\))?` group alone does not prevent mid-line false-greens; without the group the anchor alone does not handle `pub(crate)` visibility. Without this group, any `pub(crate) const NAME:` declaration would fall through to DEAD (latent false-DEAD for 8+ real declarations in `src/`).
If this grep matches → ALIVE. If it fails → DEAD. **Ordering note**: this branch MUST run before branch (e) — the standalone-CamelCase pattern `^[A-Z][A-Za-z0-9_]*$` also matches UPPER_CASE symbols (e.g., `MAX_ADF_DEPTH` matches both); running (d) first ensures UPPER_CASE symbols are not mis-routed to the type-def grep.

(e) **Standalone CamelCase type [D-154 addition — on fn-grep and UPPER_CASE failure]**: If `symbol` matches `^[A-Z][A-Za-z0-9_]*$` (CamelCase — starts with uppercase, body may contain mixed-case letters, digits, underscores; no further `::` separators in the post-file component — forms such as `src/adf.rs::AdfBuilder` or `src/types/jira/bulk.rs::BulkTransitionRequest`), run the type-definition anchored grep (verified against 6/6 cited types in adjudication §2.3):
```bash
grep -Eq "^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?(struct|enum|type|trait|union)[[:space:]]+${symbol}[<[:space:](]" \
    "$src_root/$file"
```
The `[<[:space:](]` end-anchor handles: generics (`struct Foo<T>`), unit-struct brace (`struct Foo {`), tuple struct (`struct Foo(`), and type-alias space (`type Foo =`). If this grep matches → ALIVE. If it fails → DEAD. Because branch (d) has already run, any UPPER_CASE symbol that reaches (e) has already failed the const/static check and is correctly DEAD.

(f) **Type::method [was (c) — on fn-grep failure]**: If the original `::symbol` token has at least two `::` separators AND the component before the last `::` is a CamelCase identifier (suggesting a `Type::method` form such as `src/adf.rs::AdfBuilder::finish`), re-derive from the token: `type_name="${token%::*}"; type_name="${type_name##*::}"` (e.g., `src/adf.rs::AdfBuilder` → `AdfBuilder`); `method="${token##*::}"` (e.g., `finish`). Apply a dual check: (1) run the fn-grep on `method` in the file; (2) verify `type_name` appears as a type definition: `grep -Eq "(struct|enum|type|trait|impl)[[:space:]]+${type_name}"`. If BOTH sub-checks pass → ALIVE. If either fails → DEAD.

**No permissive fallback**: symbols that do not match any of the 7 branches — (a) fn-grep primary, (b) `::tests` module-path, (c) `::tests::testfn` composition, (d) UPPER_CASE constant, (e) standalone CamelCase type, (f) Type::method, or (7) otherwise DEAD — are classified DEAD. The draft's "secondary `grep -q $symbol`" fallback is intentionally NOT implemented — it false-greens on import-only occurrences (`use super::module::fn_name` matches bare `grep -q "fn_name"`), exactly reopening the D-148 class. Fixture C in `--self-test` proves import-only occurrences are correctly DEAD.

**v2 deferrals (explicitly out of scope for v1, superseded by D-154 for classes 8/9/10)**:
- Macro citations (`macro_rules! sym`) — no grep primitive added; fall through to DEAD
- `Type::method` correlation: when both sub-checks in (f) fail, the error reports the method as DEAD but does not indicate whether the Type name itself is still valid — correlation reporting deferred
- Continuation-line Trace/Source blocks (class 16 — 5 tokens on bc-3-issue-write.md L1434-1441 and L1555-1559): multi-line Trace/Source fields are not stitched; pre-AC-001 hygiene re-flow of those 5 tokens belongs to the story PR's `files_modified`, not the grammar extension

**Preconditions**:
- Called from within `run_check` with a valid `src_root` pointing to the develop checkout
- The anchor filter `^\*\*(Trace|Source)\*\*:` has already been applied; only Trace/Source lines are processed
- `set -euo pipefail` is active; all `grep` calls that may return exit 1 (zero matches) are guarded with `|| true` to prevent unintended script abort under `pipefail`

**Postconditions**:
- Every extracted token is classified ALIVE or DEAD
- Import-only occurrences of a function name are classified DEAD (fn-grep requires a definition, not a use-site — the D-148 class)
- Trailing `(` and any following text (bare `()` or `(args...)` forms) on symbol names does not affect classification — strip-from-first-`(` (`symbol="${symbol%%\(*}"`) is applied before Step 5 classification
- Glob-containing file paths (`*` in path component) are silently skipped — no DEAD message, no false positive
- `§`-form citations (e.g., `` `src/file.rs § "note"` ``) are treated as bare-file existence checks (no symbol verification) — Pass 2 space-split of Step 1 reduces them to `src/file.rs`; the `§` and trailing text are discarded before Steps 2–5

**Invariants**:
- The two-pass extractor (Pass 1: `` grep -oE '`src/[^`]+`' ``, Pass 2: split on first space) is the single source-of-truth extraction pattern; it appears in the script exactly once as the authoritative call (analogous to BC-X.13.002's single-fixpoint principle; Story A F-VA-33-3 finding). The prior single-pass form `` grep -oE '`src/[^` ]+`' `` is superseded by D-154 — do not revert to it
- The fn-grep regex uses POSIX ERE (`-E`, not `-P`), POSIX character classes (`[[:space:]]`, `[[:alnum:]]`), and `([^[:alnum:]_]|$)` (not `\b`) for word boundary — BSD grep / macOS portability required (spec-guard runs on ubuntu-latest; `--self-test` SHOULD also pass on macOS for local verification)
- The symbol boundary anchor `([^[:alnum:]_]|$)` prevents substring false-greens: `handle_foobar` is NOT matched by a citation checking for `handle_foo`

**Edge Cases**:
- EC-CITE-038: `src/cli/issue/edit.rs::handle_edit` — `fn handle_edit` is defined in the file → fn-grep matches → ALIVE
- EC-CITE-039: `src/cli/issue/create.rs::handle_jsm_create` — appears only as `use super::jsm_create::{JsmCreateArgs, handle_jsm_create};` → fn-grep fails; not UPPER_CASE; not Type::method → DEAD (the D-148 class; Fixture C in `--self-test` pins this)
- EC-CITE-040: `src/adf.rs::AdfBuilder::finish` — Type::method form; method `finish` fn-grep passes; type `AdfBuilder` struct found → ALIVE via (f)
- EC-CITE-041: `src/cli/issue/edit.rs::CROSS_HIERARCHY_HINT` — matches UPPER_CASE pattern → const/static anchored grep → ALIVE via (d)
- EC-CITE-042: `src/cache.rs::cache_root()` — strip-from-first-`(` (`symbol%%\(*`) → `cache_root` → fn-grep matches → ALIVE via (a)
- EC-CITE-043 (glob skip / EC-011 class): `src/cli/**/*.rs` from a bc-*.md Trace/Source line (e.g., bc-7-output-render.md:677 BC-7.3.010) → shape guard detects `*` in path component → silently skipped; no DEAD message; no false positive (research cross-cutting finding F1, 2026-07-05)
- EC-CITE-044: `src/adf.rs:~120` → `:~120` suffix stripped at Step 2 → bare file `src/adf.rs` → file-existence check only; Step 5 does not run
- EC-CITE-045 [F-B2-02 corrected]: `` `src/file.rs § "some section"` `` → Pass 1 extracts the FULL token `src/file.rs § "some section"` (no space-stop); Pass 2 splits on first space → `src/file.rs`; Steps 2–5 process `src/file.rs` as bare-file check only. Under the superseded single-pass regex `` `src/[^` ]+` `` (stop-on-space), the §-form token would have been SILENTLY DROPPED (no match), not reduced to `src/file.rs` — census shows 0 §-form tokens in Trace/Source scope, so this was a latent bug with no observable impact on N
- EC-CITE-051 [F-B1-07 + F-B3-02 — anchor+group]: `src/adf.rs::MAX_ADF_DEPTH` — matches UPPER_CASE pattern; anchored const/static grep `^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?(const|static)[[:space:]]+MAX_ADF_DEPTH[[:space:]:]` finds `pub(crate) const MAX_ADF_DEPTH:` at line-start in `src/adf.rs` → ALIVE via (d). Kill-trace basis: the anchor AND the group together provide the operative protection — (1) with the anchor, removing the `(\([^)]*\))?` group alone reverts to `(pub[[:space:]]+)?`, which no longer matches `pub(crate) const MAX_ADF_DEPTH:` from line start (the `(crate)` suffix is not captured by the simplified pub pattern) → DEAD → mutation caught; (2) removing the `^[[:space:]]*` anchor alone allows mid-line occurrences such as `    // pub const MAX_ADF_DEPTH: usize = 256` (a doc-comment or string literal inside a function body) to match the unanchored form → false-ALIVE. Negative probe expectation: a mock file containing ONLY a doc-comment or string-literal line that mentions `const MAX_ADF_DEPTH:` after non-whitespace content (e.g., `    // pub const MAX_ADF_DEPTH: usize = 256` where `//` precedes the constant text) MUST classify DEAD under the anchored form — the `//` is not whitespace, so after `^[[:space:]]*` the next char is `/`, not `pub` or `const`, and the pattern fails to match. This distinguishes the anchored form from the unanchored mutation, which would match `const MAX_ADF_DEPTH:` anywhere on the line.
- EC-CITE-052 [D-154 branch (b) positive]: `src/adf.rs::tests` — symbol == `tests`; mod-tests anchored grep finds `mod tests {` at line 2561 in `src/adf.rs` → ALIVE via (b). Covers 20 corpus occurrences of `src/adf.rs::tests` in bc-7 (adjudication §1.3 class 9). Self-test Fixture I.
- EC-CITE-053 [D-154 branch (b) negative]: `src/adf.rs::nonexistent_mod` (fabricated) — symbol `nonexistent_mod` does NOT match `^tests$`; fn-grep fails; does not match any other branch → DEAD. Self-test Fixture J.
- EC-CITE-054 [D-154 branch (e) positive]: `src/types/jira/bulk.rs::BulkTransitionRequest` — fn-grep fails (no `fn BulkTransitionRequest`); not `tests`; not `tests::*`; UPPER_CASE check fails (has mixed-case); CamelCase check fires → type-def grep finds `pub struct BulkTransitionRequest {` at line 297 → ALIVE via (e). Self-test Fixture K.
- EC-CITE-055 [D-154 branch (e) negative]: `src/adf.rs::NonexistentType` (fabricated) — fn-grep fails; UPPER_CASE fails; CamelCase check fires → type-def grep finds no `struct|enum|type|trait|union NonexistentType` → DEAD.
- EC-CITE-056 [D-154 branch (c) — defense-in-depth]: `src/types/assets/linked.rs::tests::display_id_fallback_with_hint` — post-file component is `tests::display_id_fallback_with_hint` (matches `^tests::[a-z_][a-z0-9_]*$`); fn-grep (a) already finds `fn display_id_fallback_with_hint` at line 100 → ALIVE via (a); branch (c) additionally confirms `mod tests` at line 68. Both paths concur: ALIVE.
- EC-CITE-057 [D-154 F-B2-02 extraction recovery]: `src/config.rs:~269, 308-310` on a Trace/Source line — Pass 1 extracts full token `src/config.rs:~269, 308-310`; Pass 2 splits on first space → `src/config.rs:~269`; comma-lineref normalization strips trailing `, 308-310` residue if present before Step 2; Step 2 line-ref strip → bare file `src/config.rs` → file-existence check only. Previously silently MISSED by single-pass regex (one of 10 comma-space line-ref list tokens recovered by the fix; adjudication §1.2 class 14).
- EC-CITE-058 [Pre-AC-001 hygiene dependency]: 3 truly-dead citation clusters that the guard CORRECTLY flags as DEAD — (a) `src/cli/auth.rs::*` (~7-8 tokens across bc-7 and bc-1): file does not exist; `auth` was refactored to directory `src/cli/auth/mod.rs` + siblings; (b) `src/cli/assets.rs:~303` (bc-4): file does not exist; `assets` refactored to `src/cli/assets/`; (c) `src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` (bc-1): moved to `src/cli/auth/tests/snapshots/` — under the two-tier shape guard (Step 3b), this `.snap` citation passes the shape guard (extension `.snap` matches `[a-zA-Z0-9]+`) and is routed to tier (ii) file-existence-only; the file does NOT exist at the cited stale path → `DEAD: src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap not found`. These are not grammar failures — they are citation hygiene issues that must be resolved in the story PR's `files_modified` list BEFORE Guard 1 can reach GREEN on develop HEAD. The guard catching (c) via the tier (ii) file-existence check is correct behavior (see EC-CITE-060 for the 5 alive `.snap` corpus cases that prove this tier works for both pass and fail).
- EC-CITE-059 [F-B3-01 class-15 normalization — fn with space args]: `src/api/jira/issues.rs::add_comment(internal: bool)` (bc-3:~2100) — Pass 2 space-split reduces the full backtick-quoted token to `src/api/jira/issues.rs::add_comment(internal:`; Step 5 strip-from-first-`(` (`symbol="${symbol%%\(*}"`) then reduces `add_comment(internal:` → `add_comment`; fn-grep finds `fn add_comment` at `src/api/jira/issues.rs:~579` → ALIVE via (a). Under the prior bare-`()` strip (`symbol="${symbol%()}"`) the symbol `add_comment(internal:` had no trailing `)` to strip — the strip was a no-op → symbol `add_comment(internal:` was emitted to the fn-grep ERE → malformed pattern → DEAD → AC-001 blocked. The F-B3-01 fix (`%%\(*` strip-from-first-`(`) subsumes both the bare-`()` case (EC-CITE-042) and the class-15 space-args case, making the two classes a single strip rule. Note: Fixture F's sub-probe citation must use a SPACE-ARGS form (e.g., `src/mock_f.rs::mock_f_fn_selftest(args: T)`) to give Step-5 strip-from-first-`(` mutation coverage. A bare-`()` form is UNSOUND: under a delete-strip mutation `()` is a valid empty ERE group, so `fn name() {}` still matches → mutation ALIVE → not caught; only the space-args form forces Pass 2 to yield `name(args:` (unbalanced `(`) → fn-grep ERE malformed (grep exits 2) → mutation DEAD → caught. This fixture content detail is story-writer scope (the BC does not pin the exact mock file text).

- EC-CITE-060 [F-01 two-tier — tier (ii) `.snap` file-existence, positive and negative]: **Positive (ALIVE)**: 5 `.snap` citations in bc-*.md Trace/Source fields that resolve to real on-disk files — bc-1:514, bc-5:205, bc-5:214, bc-7:97, bc-7:107 (verified present on develop @ ab78a2d). Under tier (ii): shape guard accepts the `.snap` extension (`[a-zA-Z0-9]+` matches `snap`), Step 4 file-existence check passes → token classified ALIVE and **counted** (+1 to `total_citations` for each, contributing to N and the coverage floor denominator). Step 5 symbol check is skipped. **Negative (DEAD)**: see EC-CITE-058(c) — `src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` cited in bc-1 (pre-hygiene stale path); tier (ii) file-existence check fails → `DEAD: src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap not found`. **N impact**: these 5 alive `.snap` tokens raise N from 304 (`.rs`-only on 2b09313) to 309 (two-tier), FLOOR from 228 to 231.

**Canonical Test Vectors** (for `run_check` Step 5 unit coverage via `--self-test`):

| Token | Form | Step 5 path | Expected |
|-------|------|-------------|---------|
| `src/cli/issue/edit.rs::handle_edit` | ::symbol (function) | fn-grep: `fn handle_edit` | ALIVE |
| `src/cli/issue/create.rs::handle_jsm_create` | ::symbol (import only) | fn-grep fails; not `tests`; not CamelCase; not UPPER_CASE; not Type::method → DEAD | DEAD (Fixture C) |
| `src/adf.rs::AdfBuilder::finish` | Type::method | fn-grep on `finish` + type def for `AdfBuilder` | ALIVE via (f) |
| `src/cli/issue/edit.rs::CROSS_HIERARCHY_HINT` | constant (UPPER_CASE) | const/static anchored grep | ALIVE via (d) |
| `src/cache.rs::cache_root()` | fn with `()` suffix | strip-from-first-`(` → `cache_root` → fn-grep `fn cache_root` | ALIVE via (a) |
| `src/api/jira/issues.rs::add_comment(internal: bool)` (extracted bc-3:~2100) | fn with space args (class-15) | Pass 2 space-split → `add_comment(internal:`; strip-from-first-`(` → `add_comment`; fn-grep | ALIVE via (a) (EC-CITE-059) |
| `src/cli/**/*.rs` | glob | shape guard: `*` in path → silently skip | SKIPPED (no DEAD) |
| `src/adf.rs:~120` | line-ref | stripped at Step 2 → bare file | file-exists check only (Fixture E analog) |
| `src/adf.rs::MAX_ADF_DEPTH` | constant (UPPER_CASE, `pub(crate)`) | anchored const/static grep `^[[:space:]]*(pub(\([^)]*\))?[[:space:]]+)?` | ALIVE via (d) (EC-CITE-051) |
| `src/adf.rs::tests` | `::tests` module-path | symbol == `tests` → mod-tests anchored grep | ALIVE via (b) (EC-CITE-052; Fixture I) |
| `src/adf.rs::nonexistent_mod` | `::tests` negative | symbol `nonexistent_mod` does not match any branch → DEAD | DEAD (EC-CITE-053; Fixture J) |
| `src/types/jira/bulk.rs::BulkTransitionRequest` | standalone CamelCase type | fn-grep fails; UPPER_CASE fails; CamelCase → type-def grep | ALIVE via (e) (EC-CITE-054; Fixture K) |

**Verification Properties**:
- VP-BC-CITE-001: Extraction grammar coverage — Fixtures A (dead symbol), C (import-only DEAD), E (§-form file-only check), F (success path with fn defined), I (`::tests` module-path ALIVE), J (`::tests` negative DEAD), K (standalone CamelCase ALIVE) in `scripts/check-bc-citation-symbols.sh --self-test` cover all 7 grammar branches. Glob-skip (EC-043), strip-from-first-`(` (EC-042/EC-059), and Type::method (EC-040) are covered by AC-002 Fixtures F variant (Fixture F sub-probe must use a SPACE-ARGS form (e.g., `src/mock_f.rs::mock_f_fn_selftest(args: T)`) to give strip-from-first-`(` mutation coverage — story-writer scope) and the import-only proof. See S-BC-CITATION-GUARD-1 AC-002.

**Traceability**:
- Implementing story: S-BC-CITATION-GUARD-1 (CITATION-GUARDS Story B, issue #102)
- Root-cause analysis: F1 delta analysis §6 — file-existence alone too weak; must check symbol definition; import-only false-green was the D-148 root cause
- Research adjudication: `.factory/research/story-b-open-questions-2026-07-05.md` Q4 — v1-pragmatic shape-split (Type::method + constants mandatory; type-def/module-def deferred v2); permissive fallback explicitly rejected
- D-154 adjudication: `.factory/research/story-b-grammar-adjudication-2026-07-06.md` — extends v1 grammar with 3 new branches (::tests, ::tests::testfn, standalone CamelCase); space-tolerant two-pass extraction (F-B2-02); FLOOR recalibration N=326, FLOOR=244
- Source: `scripts/check-bc-citation-symbols.sh::run_check` Steps 1–5 (new file; CI script — not in `src/`)

---

#### BC-X.13.006: Guard 1 is GREEN on develop HEAD; RED on stale citation introduction; scope limited to bc-*.md Trace/Source fields; BC-INDEX.md and tests/ citations excluded; CI topology via spec-guard job dual-worktree (develop + factory-artifacts)

**Confidence**: HIGH
**Subject**: CI guard / Guard 1 scope, CI topology, self-verifiability

**Behavior**: Guard 1 (`scripts/check-bc-citation-symbols.sh`) has the following scope, CI topology, and verifiability properties:

**Scope**: The guard scans ONLY lines matching the anchor `^\*\*(Trace|Source)\*\*:` in `bc-*.md` files — lines that begin with exactly `**Trace**:` or `**Source**:` (no leading whitespace; exact markdown bold markup). Citations in BC body prose (Description, Preconditions, Postconditions, Invariants, Examples, Canonical Test Vectors sections), BC frontmatter YAML, and BC-INDEX.md are NOT scanned. `tests/` citation paths on Trace/Source lines are NOT extracted — only `src/`-prefixed backtick tokens are in scope (BC-X.13.005 Step 1 canonical regex enforces this programmatically).

**BC-INDEX.md exclusion (structural)**: BC-INDEX.md is NOT scanned by Guard 1. Rationale: BC-INDEX.md has zero lines matching the `^\*\*(Trace|Source)\*\*:` anchor — the BC-INDEX uses section-header and pipe-table format, not Trace/Source field format. The scope exclusion is both a deliberate design choice and a structural fact (zero extractions would result regardless). BC-INDEX.md citation health is a manual review concern (PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY drift item, partially addressed). See research cross-cutting finding F2 (2026-07-05).

**CI topology (spec-guard dual-worktree)**: Guard 1 runs as two sequential steps in the existing `spec-guard` CI job (confirmed by F1 §3 against live `.github/workflows/ci.yml`):
1. `--self-test` step: runs all 10 self-test fixtures offline using hermetic temp dirs; exits 0 if all pass, 1 if any fail
2. Canonical step: runs Guard 1 against the real factory-artifacts and develop src/ tree

The `spec-guard` job already mounts the `factory-artifacts` worktree via `git worktree add .factory origin/factory-artifacts` before the BC-count steps — Guard 1 inherits this dual-mount. This is CI topology option (a) from F1 §3; options (b) (pre-commit only) and (c) (new dual-checkout job) are rejected. No new CI job is created; no `ci-gate.needs` change is needed — `spec-guard` is already in `ci-gate.needs` per D-096/097.

**Self-test fixture suite**: 10 fixtures (A–K) embedded in `scripts/check-bc-citation-symbols.sh --self-test` cover all key failure modes (Fixture A: dead symbol; B: dead file; C: import-only false-green prevention; D: Source-field extraction; E: §-form file-only; F: success path; G: coverage-floor RED probe; I: `::tests` module-path ALIVE [D-154]; J: `::tests` negative DEAD [D-154]; K: standalone CamelCase type ALIVE [D-154]). `--self-test` step ALWAYS executes BEFORE the canonical step in CI.

**GREEN on develop HEAD**: Running `bash scripts/check-bc-citation-symbols.sh` from the repo root with `.factory/specs/prd/` mounted exits 0 on develop HEAD (post-D-148 cleanup). All bc-*.md Trace/Source `src/` citations are alive.

**RED on stale citation**: If a PR moves a function without updating bc-*.md Trace/Source fields (e.g., a Seam extraction as in ADR-0012), the next spec-guard run emits `DEAD: <symbol> not found in <old-file>` and exits 1, blocking CI. The guard fires on the PR introducing the drift, not only PRs touching bc-*.md.

**Preconditions**:
- `spec-guard` job mounts both develop checkout and factory-artifacts worktree
- `scripts/check-bc-citation-symbols.sh` is present in the develop checkout at `scripts/`
- The `--self-test` step runs and passes before the canonical step (enforced by CI step ordering)

**Postconditions (on GREEN)**:
- Guard exits 0; prints `Check passed: N citations checked` (N ≥ FLOOR)
- No stale `src/` citations exist in any bc-*.md Trace/Source field on develop HEAD
- `--self-test` step exits 0; script prints `All self-test fixtures passed (10/10)` (the observable success string; the count `10/10` is load-bearing — any reduction in fixture coverage surfaces here)

**Postconditions (on RED)**:
- Guard exits 1; developer receives actionable `DEAD:` offender list
- The `--self-test` step failing independently provides a distinct failure signal when the fixture suite itself regresses vs when a real citation is stale

**Invariants**:
- `--self-test` step ALWAYS runs BEFORE the canonical step in CI; fixture-suite regression fails visibly rather than silently corrupting the canonical run (MUTANTS-ARBITER-OFFLINE-SELFTEST precedent from Story A)
- Guard 1 delivers ZERO changes to `src/` files — the F4 delivery is bash script + CI YAML + CLAUDE.md + CHANGELOG only; no Rust source mutations; no `cargo test` regression possible
- `tests/` citation paths on Trace/Source lines are excluded from extraction — the `#492-PG-TRACE-TESTS` drift item (tests/ citation hygiene) remains OPEN after Guard 1 delivery
- BC-INDEX.md has zero `^\*\*(Trace|Source)\*\*:` lines — the scope exclusion is both deliberate and structural; the anchor pattern enforces it mechanically

**Edge Cases**:
- EC-CITE-046: Guard runs on a PR that does NOT modify bc-*.md (e.g., a pure Rust source refactor) → Guard 1 still runs in spec-guard; if the refactor moved a cited symbol, the guard catches the staleness → exit 1 (desired behavior; cross-PR drift detection)
- EC-CITE-047: Guard runs on develop HEAD where all citations are alive → exit 0; `Check passed: N citations checked` with N ≥ FLOOR
- EC-CITE-048: A stale citation is introduced (file renamed, symbol moved) in a PR → guard fires → exit 1 with `DEAD:` offender list → CI blocked
- EC-CITE-049: BC-INDEX.md has zero `^\*\*(Trace|Source)\*\*:` lines → excluded by anchor pattern; no extraction; no false positive (research cross-cutting finding F2)
- EC-CITE-050: `tests/issue_commands.rs:~1646` appears on a Trace/Source line → NOT extracted; canonical regex only matches `src/`-prefixed backtick tokens; excluded from scope

**Canonical Test Vectors**:

| Scenario | Expected behavior |
|----------|-------------------|
| `bash scripts/check-bc-citation-symbols.sh --self-test` (all 10 fixtures pass) | Exit 0; `All self-test fixtures passed (10/10)` |
| `bash scripts/check-bc-citation-symbols.sh` on develop HEAD (factory-artifacts mounted) | Exit 0; `Check passed: N citations checked` (N ≥ 231) |
| PR moves `fn handle_jsm_create` from `create.rs` to `jsm_create.rs` without updating bc-*.md | Guard fires: `DEAD: handle_jsm_create not found in src/cli/issue/create.rs`; exit 1 |
| BC-INDEX.md has no Trace/Source lines | Zero extractions from BC-INDEX.md; no DEAD messages; guard unaffected |
| `tests/claude_md_citations.rs::some_test` on a bc-*.md Trace/Source line | NOT extracted; `src/`-only scope enforced by canonical regex |

**Verification Properties**:
- VP-BC-CITE-002: Integration self-verification — `scripts/check-bc-citation-symbols.sh --self-test` exits 0 with all 10 fixtures passing; canonical run exits 0 on develop HEAD with factory-artifacts mounted; Fixture A proves dead-symbol detection; Fixture C proves import-only is DEAD; Fixture G proves CANONICAL_MODE floor guard is active; Fixtures I/J/K prove D-154 grammar branches (::tests, negative, standalone CamelCase). See S-BC-CITATION-GUARD-1 AC-001/AC-002/AC-005/AC-006.

**Traceability**:
- Implementing story: S-BC-CITATION-GUARD-1 (CITATION-GUARDS Story B, issue #102)
- CI topology: F1 delta analysis §3 — option (a) spec-guard dual-worktree confirmed; D-129 lesson (Rust test in `test` job cannot access factory-artifacts) applied
- Scope decision: F1 §6 — `src/`-only; `tests/` excluded; BC-INDEX.md excluded (structural zero-Trace/Source lines; research cross-cutting finding F2)
- Prior art: `scripts/check-cargo-mutants-policy-citations.sh` (S-MUTANTS-SCOPE-GUARDS-1, self-test fixture idiom)
- Source: `scripts/check-bc-citation-symbols.sh` (new file; CI script — not in `src/`); `.github/workflows/ci.yml` `spec-guard` job (modified)

[NEW 2026-07-05 CITATION-GUARDS Story B S-BC-CITATION-GUARD-1 issue #102] Guard 1 bc-*.md Trace/Source file::symbol citation guard, extending the BC-X.13 CI-guards subsystem established by DEAD-CITATION-CI.

---

#### BC-X.13.007: The `test` job enforces a runtime-computed test-execution floor — CI cannot report success from zero-test or near-zero-test execution, even though `cargo test`'s own exit code alone cannot distinguish "tests ran and passed" from "nothing ran"

**Confidence**: HIGH
**Subject**: CI guard / `test` job runtime test-execution integrity (POL-11)

**Verification status** (per claim group; COVERED = exercised for real by a test or live CI,
PARTIAL = the claim's text/expression is pinned but the scenario itself is not exercised,
MANUAL = reproduced once by hand, not by an automated test, NONE = nothing verifies this today,
deliberately unverified = intentionally not test-covered, with reason. VP-CIGATE-001 below grades
the eighteen individual assertions that pin the guard's own literal text; this block grades the
claims those assertions serve):

- **Behavior items 1–4** (binary-count floor / named-canary presence / named-canary passed-count /
  zero-test floor): PARTIAL — VP-CIGATE-001 pins each gate's triggering *expression* (e.g.
  `"${binaries}" -lt 90`) as a literal/variable-bound substring of `ci.yml`; no test executes the
  step's script under any of the four triggering scenarios, so a syntactically-present but
  logically-broken gate would not be caught. Items 2 and 3's wording below reflect, respectively, the
  named-canary presence check (a bare launch-detection substring presence test) and the named-canary
  passed-count gate — a stronger requirement (ADV-P50-LOW-002, round 20, commit `424d64de`) that the
  canary binary's own `test result:` line report a non-zero passed count, located via a
  path-separator-agnostic `[/\\]` match so the lookup succeeds on both Unix and `windows-latest`
  runners (Windows regression fix, commit `177b3727`) — closing the earlier "launched but never
  reported" gap. Both the passed-count gate and the separator-agnostic match are now pinned by
  `test_verify_test_job_has_zero_test_floor` (commit `ada50a34`): Instrument 2b's two
  sub-assertions — `tail -n +"${_canary_running_line}"` (scopes the `test result:` lookup to the
  canary binary's own output, not the first such line anywhere in the capture) and
  `"${_canary_passed}" -eq 0` (the non-zero-passed gate itself) — pin the ADV-P50-LOW-002
  strengthening; Instrument 2c (the raw-string regex `Running tests[/\\\\]ci_gate_completeness\.rs`)
  pins the path-separator-agnostic lookup. This closes the previously-disclosed gap — VP-CIGATE-001's
  eighteen assertions now cover both, graded in the breakdown below.
- **Precondition 1** (`test` job runs on every push/PR to `develop`/`main`, 3-OS matrix, `ci-gate.needs`
  member): COVERED — `ci-gate.needs` inclusion of `test` is pinned exactly (set equality) by
  `test_ci_gate_needs_exactly_the_required_jobs`, and `windows-latest` presence in the `test` job's
  `strategy.matrix.os` list is pinned by `test_ci_yml_has_windows_latest_in_test_matrix`
  (`tests/ci_yml_windows_matrix.rs`) — neither is VP-CIGATE-001. Those two assertions do not
  individually enumerate `ubuntu-latest`/`macos-latest`, but the job runs for real, on all three
  OSes, on every live CI invocation.
- **Precondition 2** (cargo does not forward `--color` to libtest, so the anchored grep sees plain
  ASCII): NONE — confirmed empirically once, by hand (`cargo test 2>&1 | cat -v`); no test would
  notice if a future cargo/libtest release changed this.
- **Postconditions 1–3** (success path: step exits 0, positive-coverage line emitted, job/`ci-gate`
  proceeds): COVERED — this is the path live CI exercises on every push/PR, with the real test suite
  actually passing; it is not merely a text-pin.
- **Postconditions 4–6** (failure path: step exits non-zero, `FAIL (POL-11)` diagnostic emitted,
  `ci-gate` blocked): MANUAL — reproduced once by hand in a scratchpad copy of the script (recorded
  in the round-17 commit message); no automated test drives the failure branches.
- **Invariant 1** (`cargo test` with 0 tests exits 0 by default): deliberately unverified —
  documented upstream cargo behavior; re-proving it here would test cargo, not this repo.
- **Invariant 2** (floor checks are additive to cargo's own failure signal, via `set -euo pipefail`):
  PARTIAL — the `set -euo pipefail` text is pinned by VP-CIGATE-001; the causal behavior (a real
  `cargo test` failure actually failing the step) was reproduced once by hand with a mock `cargo`
  binary, not by an automated regression test.
- **Invariant 3** (the binary-count floor and named-canary check are both required — self-orphaning
  escapes the floor alone): NONE — the reasoning is prose only; no test constructs a scenario where
  the binary count stays ≥90 while the canary binary is absent.
- **EC-CIGATE-001** (mass `tests/` orphaning) and **EC-CIGATE-002** (canary self-orphaning): NONE —
  never reproduced, automated or by hand.
- **EC-CIGATE-003** (a harness/filter misconfiguration causes genuine zero-passed-tests output at
  runtime): NONE for the runtime scenario itself. A one-off scratchpad check does exist, but it
  validates something narrower than EC-CIGATE-003: deleting the `if [ "${total}" -eq 0 ]; ... fi`
  block from `ci.yml` and re-running VP-CIGATE-001's Rust regression test confirmed that test's
  other nine (now eleven, now sixteen) assertions stayed green — i.e. it proves the
  `"${total}" -eq 0` text-pin was a necessary addition to VP-CIGATE-001, not that the zero-test-floor
  shell logic correctly fires when fed genuine "every binary reports zero passed" `cargo test`
  output. At eighteen total, wholesale deletion of that `if` block now defeats TWO assertions, not
  one: the direct `"${total}" -eq 0` text-pin (Instrument 3) and, since ADV-P51-MED-001, the
  `zero_test_floor_block` per-branch `exit 1` pin
  (`extract_if_block(test_block, "if [ \"${total}\" -eq 0 ]; then\n")`), which panics on a missing
  condition line once the block is gone rather than merely failing its assertion — so the count of
  assertions unaffected by this specific deletion is sixteen (eighteen minus the two that target
  this block), not seventeen.
- **EC-CIGATE-004** (a genuine assertion failure propagates via `cargo test`'s own exit code): MANUAL
  — this one *was* reproduced against the actual shell logic, not just the Rust test: a mock
  `cargo` binary exiting 101 after printing passing `test result:` lines was fed through the step's
  script in a scratchpad copy, confirming `set -eu` (pipefail dropped) falls through to `Check
  passed: ...` while the unmodified `set -euo pipefail` correctly propagates the failure and aborts
  the step. Still one-off and by hand — no automated regression test drives this scenario.
- **EC-CIGATE-005** (threshold recalibration on a legitimate binary-count reduction): deliberately
  unverified — a human process note with no pass/fail outcome, not a testable behavior.
- **EC-CIGATE-006** (canary binary launches — satisfying the bare presence check — but its own
  `test result:` line reports zero passed): NONE for the runtime scenario itself — never
  reproduced, automated or by hand. The triggering *expression* is pinned by VP-CIGATE-001
  Instrument 2b (`tail -n +"${_canary_running_line}"`, `"${_canary_passed}" -eq 0`) and Instrument
  2c (the path-separator-agnostic `Running` line regex), added commit `ada50a34` — same PARTIAL
  grading shape as Behavior items 1–4 above: the expression is pinned, the runtime scenario is not
  driven through the script.
- **Canonical Test Vectors**: see the table's own "Verified by" column below.

**Behavior**: The `test` job's test-execution step (`.github/workflows/ci.yml` `test` job, step
`Run tests (zero-test floor, POL-11)`) does not treat a zero exit code from
`cargo test --all-features` as sufficient proof that tests actually ran. It captures the full test
output, computes two runtime metrics from it — (1) the number of test binaries that reported a
`test result:` line, and (2) the summed passed-test count across those binaries — and enforces
four independent gate checks against those metrics before the step (and therefore the job, and
therefore the required `ci-gate` check) can report success:

1. **Binary-count floor**: the step fails if the number of test binaries that reported results
   falls below a fixed, non-zero threshold. This defends against mass orphaning of `tests/`
   integration-test files — a defect class a bare "total passed > 0" predicate cannot catch,
   because `src/`-inline unit tests keep running (and keep the passed-count positive) even when
   every `tests/` binary is silently dropped from the build.
2. **Named-canary presence check**: the step fails if the string `ci_gate_completeness` does not
   appear anywhere in the captured `cargo test` output — satisfied at minimum by cargo's own
   `Running tests/ci_gate_completeness...` announcement line. This defends against the self-orphaning
   case — the one binary that carries this guard's own regression pin is dropped from the build
   entirely (renamed, excluded via `[[test]]`, or `autotests=false`) — while the aggregate binary
   count stays at or above the floor, a case the binary-count floor alone cannot detect.
3. **Named-canary passed-count gate** (ADV-P50-LOW-002, round 20): beyond item 2's bare presence
   check, the step separately locates this binary's own `Running tests` line (matched via a `[/\\]`
   character-class regex so it recognizes either `Running tests/ci_gate_completeness.rs` on Unix
   runners or `Running tests\ci_gate_completeness.rs` on `windows-latest`), finds that binary's own
   subsequent `test result:` line, and fails unless the passed count on that specific line is
   non-zero. This closes the gap where a binary that launched and then crashed, was entirely
   `#[ignore]`d, or was skipped by an env-gate before any assertion ran would satisfy item 2's bare
   presence check while reporting zero passed tests — this gate proves the canary binary *reported a
   passing result*, not merely that it was launched.
4. **Zero-test floor**: the step fails if the summed passed-test count across all reporting
   binaries is exactly zero.

A genuine test failure (any non-zero `cargo test` exit code) still fails the step independently of
these four checks — the floor mechanism is additive to cargo's own pass/fail signal, not a
replacement for it.

On success, the step emits a runtime-computed, human-readable count of tests executed and binaries
that ran. Exit code 0 alone is deliberately treated as insufficient evidence that the guard ran and
passed; the positive-coverage line is the observable proof.

**Preconditions**:
- The `test` job runs on every push/PR to `develop`/`main` (3-OS matrix) as an existing
  `ci-gate.needs` member
- `cargo test --all-features` output is captured in full — untruncated — before the floor checks
  run. The runtime metric computation assumes the anchored `test result:` line stays plain ASCII;
  this holds today because cargo does not forward its own colour preference to the libtest
  harness — only cargo's own status lines (`Finished`, `Running`) are ANSI-wrapped under
  `CARGO_TERM_COLOR=always`, confirmed empirically (`cargo test 2>&1 | cat -v`), while the
  anchored `grep -E "^test result: "` line is not. The step's own `CARGO_TERM_COLOR: never`
  override is hardening against that assumption changing in a future cargo/libtest release, not
  a defense against a corruption risk observed today.

**Postconditions**:
1. On success (floor cleared): the step exits 0.
2. On success: a positive-coverage line naming the runtime-computed test count and binary count is
   emitted (not merely a bare exit code).
3. On success: the job, and therefore `ci-gate`, proceeds to reflect success.
4. On failure (any of the four gates trips): the step exits non-zero before the job can report
   success.
5. On failure: a canonical `FAIL (POL-11): ...` diagnostic identifying which gate tripped is
   emitted, together with a list of plausible causes (e.g. a build-config change that disables
   default test-target discovery, a test-target rename, mass test-file deletion, or a harness
   misconfiguration). The named-canary presence check (item 2) and the named-canary passed-count
   gate (item 3) emit distinct messages depending on which trips:
   - `FAIL (POL-11): tests/ci_gate_completeness did not run.` — the bare presence check
     (item 2 / Instrument 2) found no `Running tests[/\\]ci_gate_completeness.rs` line at all
     anywhere in the capture; the binary was never launched (EC-CIGATE-002).
   - `FAIL (POL-11): tests/ci_gate_completeness ran but reported 0 passed assertions.` — the
     binary launched (item 2's presence check is satisfied) but its own `test result:` line
     reported a passed count of zero (item 3 / Instrument 2b/2c, ADV-P50-LOW-002; EC-CIGATE-006).
   The binary-count floor and zero-test floor each emit their own single, distinct diagnostic:
   `FAIL (POL-11): only ${binaries} test binaries reported results (floor: 90).` and
   `FAIL (POL-11): zero tests executed across ${binaries} test binaries.` respectively.
6. On failure: `ci-gate` is blocked — a CI run that executed zero or near-zero tests cannot reach
   the required merge-blocking check.

**Invariants**:
- A `cargo test` invocation that runs zero tests exits 0 by default — the floor mechanism exists
  precisely because cargo's own exit code cannot distinguish "ran and passed" from "nothing ran";
  the guard's checks are computed from parsed runtime output, not inferred from the exit code alone
- The floor checks run in addition to, not instead of, cargo's own failure signal — a real test
  failure still fails the step
- The named-canary check and the binary-count floor are both required: the binary-count floor
  alone cannot detect self-orphaning of the one binary that carries this guard's own regression
  pin, because that binary's removal does not necessarily drop the aggregate binary count below
  the floor
- This BC governs the `test` job's own runtime-integrity guard — distinct from BC-X.13.001..006,
  which govern static citation-checking scripts (`tests/claude_md_citations.rs`,
  `scripts/check-bc-citation-symbols.sh`) that scan documentation, not CI's own test-execution proof
- This BC also does not govern the `ci-gate` job's own structural / pass-fail-semantics guards
  (job `name:`/`runs-on:`/job-level `if: always()`; exact eight-job `needs` set; advisory/
  secret-scan job exclusion from `needs`; `mutants` inclusion in `needs`; failure on any
  failed-or-cancelled `need`; no job-level `if:` key on the seven unconditionally-run `needs`
  members; a byte-for-byte pinned gate-decision `run:` line) or the `msrv` job's toolchain-pinning
  guard (`toolchain: "1.88.0"` + a
  same-step `RUSTUP_TOOLCHAIN: "1.88.0"` env override + `cargo check --all-targets --all-features
  --locked`; re-pinned from 1.85.0 to 1.88.0 by S-cycle13-msrv-1.88-atomic-bump, which also dropped
  the job's prior `lib + bins`-only scope in favor of `--all-targets` now that the 1.88 floor covers
  the let-chain syntax `wiremock`'s dev-dependency tree requires). Those are pinned at the
  S-CIGATE-1 / S-626-1 story-AC layer (AC-001, AC-002, AC-003, AC-3, M1, M2) by the complete
  eight-test sibling-guard set in `tests/ci_gate_completeness.rs`:
  `test_ci_gate_job_exists_with_required_metadata` (AC-001),
  `test_ci_gate_needs_exactly_the_required_jobs` (AC-003, exact-set),
  `test_ci_gate_excludes_advisory_and_secret_scan_jobs` (AC-003, exclusion),
  `test_mutants_is_in_ci_gate_needs` (AC-003, `mutants` inclusion — anchored to
  S-MUTATION-CI-TIMEOUT-1, the story that promoted `mutants` to a hard-required
  `ci-gate.needs` member),
  `test_ci_gate_fails_on_failed_or_cancelled_need` (AC-002, retargeted S-CIGATE-2),
  `test_ci_gate_needs_jobs_have_no_job_level_if` (EC-002 / M1; renamed in round 20 —
  ADV-P48-LOW-001 — from `test_ci_gate_needs_jobs_have_no_event_conditional_if` to match round
  19's broadened predicate),
  `test_ci_gate_pass_fail_semantics_are_structurally_placed` (AC-001/AC-002, M2, retargeted
  S-CIGATE-2 — its M2-i assertion pins the gate step's `run:` line byte-for-byte against
  `PINNED_GATE_RUN_LINE`), and
  `test_verify_msrv_job_pins_toolchain_and_rustup_toolchain_env` (AC-3) — with no
  corresponding BC or VP registered in this PRD. Round 19 (adversarial passes 45–47, commit
  `e076e96b`) closed seven guard-strength gaps in those sibling tests, one of which — an exact
  `run: exit 1` body pin (F-01) — was itself retired in round 20 (commit `7f702bf6`, "retire
  F-01's exit-1 literal pin, superseded by S-CIGATE-2 M2-i") once S-CIGATE-2 replaced the gate
  step's `run:` body with the `scripts/check-ci-gate.sh` invocation, making the literal
  `run: exit 1` text permanently false of the shipped `ci.yml`. Coverage was superseded, not
  dropped: `test_ci_gate_pass_fail_semantics_are_structurally_placed`'s M2-i assertion pins the
  same step's `run:` line byte-for-byte against `PINNED_GATE_RUN_LINE`, which strictly subsumes
  F-01's narrower exact-match pin while also catching exit-swallowing suffixes (`|| true`,
  `| cat`) F-01 could not. Round 19's other six gaps (a same-step `RUSTUP_TOOLCHAIN` placement
  pin for the msrv guard; broadening the no-job-level-`if:` check from a
  `github.event_name`-substring match to rejecting any job-level `if:` key; a
  panic-on-missing-`needs:` fix; a rename of a test that had been asserting a shell it never
  checked; and two stale job-count doc corrections) are unaffected by the round-20 retirement.
  `test_verify_test_job_has_zero_test_floor` was untouched by round 19, and by round 20's own
  `424d64de`/`177b3727` commits — but round 20's later catch-up commit `ada50a34` did extend it,
  from twelve assertions to fifteen (Instrument 2b/2c), to close the STRENGTHENED-CANARY-UNPINNED
  gap those two commits had left open. A subsequent fix (ADV-P51-MED-001) extended it further, from
  fifteen assertions to eighteen, replacing the single generic `exit 1` presence check with four
  PER-BRANCH `extract_if_block`-scoped pins (one per gate branch), closing the gap where mutating
  any one branch's `exit 1` to `exit 0` went undetected as long as at least one of the other three
  branches retained its own `exit 1`; see the Behavior items 1–4 and VP-CIGATE-001 entries above for
  the current eighteen-assertion state.

**Edge Cases**:
- EC-CIGATE-001: All `tests/*.rs` integration-test files are orphaned (e.g. a build-config change
  that disables default test-target discovery, or a target-list override) while `src/`-inline
  `#[cfg(test)]` tests continue running → binary-count floor trips (a bare passed-count predicate
  would stay positive and mask the defect) → step fails
- EC-CIGATE-002: Only the binary carrying this guard's own regression pin is renamed or excluded,
  while the rest of the `tests/` suite is intact and the binary count stays at or above the floor
  → named-canary check trips → step fails
- EC-CIGATE-003: A test filter or harness misconfiguration causes every reporting binary to show
  zero passed tests (binaries run, but none of their tests execute) → zero-test floor trips →
  step fails
- EC-CIGATE-004: A genuine test assertion fails → `cargo test`'s own non-zero exit code fails the
  step independently of the four floor checks (the floor checks are additive, not substitutive)
- EC-CIGATE-005: A deliberate, legitimate reduction in the number of test binaries (e.g.
  consolidating several integration-test files into fewer targets) narrows the margin between the
  current binary count and the floor threshold → the floor threshold is a lower bound, not an
  exact-match assertion, and requires periodic recalibration when a large legitimate reduction is
  planned
- EC-CIGATE-006: The named-canary binary (`ci_gate_completeness`) is launched — cargo prints its
  `Running tests[/\\]ci_gate_completeness.rs` announcement line, satisfying the bare presence
  check (Instrument 2) — but its own `test result:` line reports a passed count of zero (e.g.
  every test in the file is `#[ignore]`d, an env-gate early-returns before any assertion runs, or
  a test filter matched the binary but excluded every test inside it) → the non-zero-passed gate
  (Instrument 2b/2c, ADV-P50-LOW-002) trips independently of the presence check → step fails.
  Distinct from EC-CIGATE-002: EC-CIGATE-002 is the binary ABSENT from the build entirely (no
  `Running` line at all, so the presence check itself trips); EC-CIGATE-006 is the binary PRESENT
  and launched but never executing a passing assertion, so the presence check alone is satisfied
  and only the passed-count gate catches it — the two edge cases trip different sub-checks and
  emit different diagnostic messages (see Postcondition 5)

**Canonical Test Vectors**:

| Scenario | Expected behavior | Verified by |
|----------|-------------------|-------------|
| Full suite runs normally; all binaries report results; passed-count > 0 | Step exits 0; positive-coverage line printed with runtime-computed counts | Live CI — this scenario runs, for real, on every push/PR |
| `tests/` fully orphaned (default test-target discovery disabled); `src/`-inline tests still pass | Binary-count floor trips; `FAIL (POL-11): ...`; step exits non-zero | Not verified — never driven through the script, automated or by hand (EC-CIGATE-001) |
| Named-canary binary alone renamed/excluded; rest of `tests/` intact (no `Running` line at all) | Named-canary presence check trips; `FAIL (POL-11): tests/ci_gate_completeness did not run.`; step exits non-zero | Not verified — never driven through the script, automated or by hand (EC-CIGATE-002) |
| Every reporting binary shows zero passed tests (filter matches nothing) | Zero-test floor trips; `FAIL (POL-11): ...`; step exits non-zero | Not verified as a runtime scenario — the existing scratchpad check only proves the `"${total}" -eq 0` text-pin is necessary, not that this scenario trips it (EC-CIGATE-003) |
| A real assertion fails inside any test | `cargo test` itself exits non-zero; step fails independently of the floor checks | One-off scratchpad reproduction of the actual shell logic, with a mock `cargo` binary; not automated (EC-CIGATE-004) |
| Named-canary binary launches (satisfies the presence check) but its own `test result:` line reports 0 passed (e.g. every test `#[ignore]`d) | Non-zero-passed gate trips independently of the presence check; `FAIL (POL-11): tests/ci_gate_completeness ran but reported 0 passed assertions.`; step exits non-zero | Not verified as a runtime scenario — never driven through the script, automated or by hand; the triggering expression is text-pinned by VP-CIGATE-001 Instrument 2b/2c (EC-CIGATE-006) |

**Verification Properties**:
- VP-CIGATE-001: Regression pin —
  `tests/ci_gate_completeness.rs::test_verify_test_job_has_zero_test_floor` makes eighteen
  `str::contains` assertions against the `test` job's step block, extracted by
  `extract_job_block` (`tests/common/yaml.rs`) as a raw string slice of the YAML — comment lines
  included. Three of the eighteen — Instrument 2b's two sub-assertions (`tail -n
  +"${_canary_running_line}"` and `"${_canary_passed}" -eq 0`) and Instrument 2c (the raw-string
  regex `Running tests[/\\\\]ci_gate_completeness\.rs`) — were added in the round-20 catch-up
  (commit `ada50a34`) to pin the ADV-P50-LOW-002 non-zero-passed strengthening and its
  path-separator-agnostic lookup (commit `177b3727`) — closing the gap disclosed in the prior
  round (STRENGTHENED-CANARY-UNPINNED). This is on top of the twelve described below. Two of
  those twelve (`shell: bash` and the full `cargo test --all-features 2>&1 | tee
  "$RUNNER_TEMP/cargo_test_out.txt"\n` capture invocation) were added in an earlier round, on top
  of the ten before that (themselves including two added the round before that: `"${total}" -eq
  0` and `set -euo pipefail\n`, each closing a demonstrated hole where every one of the
  previously-existing eight assertions stayed green under a reproduced false-green mutation —
  deleting the `if [ "${total}" -eq 0 ]; ... fi` block wholesale, and separately weakening
  `set -euo pipefail` to `set -eu` while feeding a mock `cargo` that exits 101 after printing
  passing `test result:` lines). A later fix (ADV-P51-MED-001) added three more net — replacing
  the single generic `exit 1` presence check with four PER-BRANCH `extract_if_block`-scoped pins
  — bringing the total from fifteen to eighteen; see the new "Per-branch, scoped" tier below. The
  eighteen assertions are graded by how hard each is to defeat without also breaking the
  enforcement logic it pins:
  - **Variable/command-bound, and unique-pattern** (hardest to defeat — a rename or rewrite that
    neuters the check also breaks the literal text required): `"${binaries}" -lt 90`
    (binary-count floor), `"${total}" -eq 0` (zero-test floor), `grep -q "ci_gate_completeness"`
    (named-canary presence), `tail -n +"${_canary_running_line}"` (scopes the canary's own
    `test result:` lookup to its own output rather than the first such line anywhere in the
    capture — round-20 ADV-P50-LOW-002), `"${_canary_passed}" -eq 0` (the non-zero-passed gate
    itself), and `Running tests[/\\\\]ci_gate_completeness\.rs` (the path-separator-agnostic
    canary-lookup regex, pinned via a Rust raw string literal so the source reproduces the exact
    backslash byte sequence). None of these six forms appears anywhere else in `ci.yml`; a bare
    `-lt 90` / `-eq 0` / `ci_gate_completeness` substring, by contrast, also appears in this
    guard's own comments and echo diagnostics and would stay satisfied even after a variable
    rename neutered the check.
  - **Exact standalone line** (comment-satisfiable only by a future comment reproducing the
    identical trailing form — no such comment exists today): `set -euo pipefail\n`,
    `set +o pipefail\n`, `set -o pipefail\n`, and the full capture invocation `cargo test
    --all-features 2>&1 | tee "$RUNNER_TEMP/cargo_test_out.txt"\n`. `set -euo pipefail` is the
    sole mechanism propagating a genuine `cargo test` failure through the pipeline into a failed
    step; `"set -o pipefail\n"` is not a substring of `"set -euo pipefail\n"`, so these three
    assertions are independent of one another — dropping any one of the three lines fails exactly
    that one assertion, not the others. The capture-invocation assertion is the literal `run:`
    command itself, occurring exactly once in `ci.yml`; it pins `--all-features` (so
    `#[cfg(test)]`-gated code is actually exercised) and the `tee` target (the same path the
    `total=`/`binaries=` computations read back from) — but it does not pin those computation
    pipelines themselves (see "Not pinned" below).
  - **Literal substring, weaker still** (a comment or unrelated step could in principle reproduce
    it): `CARGO_TERM_COLOR: never`, `shell: bash`. Both are step-level YAML key-value pairs;
    `shell: bash` occurs exactly once in `ci.yml` today but nothing prevents a future comment
    from reproducing the string.
  - **Weakest** (also appears inside this guard's own `echo` diagnostics; a rewrite that
    preserves the diagnostic strings while gutting the enforcement logic underneath would not be
    caught by these alone): `FAIL (POL-11)`, `Check passed:`.
  - **Per-branch, scoped** (ADV-P51-MED-001): `exit 1`, four times — moved OUT of the "Weakest"
    tier above and off the single generic `test_block.contains("exit 1")` form entirely. A bare
    presence check for `exit 1` is satisfied by ANY ONE of the four gate branches (binary-count
    floor, named-canary presence, named-canary passed-count, zero-test floor) retaining its own
    `exit 1` — mutating a single branch's `exit 1` to `exit 0` (that branch still prints its
    `FAIL (POL-11)` diagnostic, then exits the STEP successfully, skipping the remaining three
    gates) went undetected by the old generic check, since the other three branches' `exit 1`
    kept the bare substring present. `extract_if_block` now locates each branch's own
    `if ... then ... fi` block by its unique condition line and asserts `exit 1` appears INSIDE
    that block specifically, so each of the four gates is independently pinned — a mutation to
    any one branch's exit code fails exactly that branch's assertion, not a shared one.

  **Not pinned.** Pinning the full capture-invocation line closes part of the previously-open
  gap — it now catches a rewrite that drops `--all-features` or redirects capture to a different
  file. What remains unpinned: the `total=`/`binaries=` computation pipelines (the
  `grep`/`grep -Eo`/`awk` and `grep`/`wc -l`/`tr` chains) that derive those two variables from the
  captured output — only their *usages* (`"${total}" -eq 0`, `"${binaries}" -lt 90`) are pinned.
  A rewrite that preserves the capture invocation verbatim but replaces the computation logic with
  an unconditional `binaries=999; total=999` would satisfy every one of the eighteen assertions in
  this test. This is a structural limit of a substring-based guard applied to a raw YAML slice,
  not an oversight the test can close on its own.

**Traceability**:
- Implementing story: S-626-1 (FIX ROUND 12, v1.17), issue #626
- Policy: POL-11 (positive-coverage / false-green CI guard policy; adversary pass-18 finding)
- Prior art / anti-pattern cited: TD-VSDD-057 / prism PR #127 — ANSI-wrapped output silently
  zeroing an anchored `grep`, producing a permanent false-red with no diagnostic; the reason this
  guard's step overrides `CARGO_TERM_COLOR` for itself
- Source: `.github/workflows/ci.yml` `test` job, step `Run tests (zero-test floor, POL-11)`;
  `tests/ci_gate_completeness.rs::test_verify_test_job_has_zero_test_floor`

[NEW 2026-08-05 FIX ROUND 12 S-626-1 issue #626] `test` job runtime test-execution floor (Guard 2),
extending the BC-X.13 CI-guards subsystem established by DEAD-CITATION-CI (Guard 0) and
CITATION-GUARDS Story B (Guard 1).

---

## BC-X.14: Field Option Discovery

4 behavioral contracts covering `jr field options <field>` — a new top-level command family
(issue #580) that enumerates a field's allowed options (custom select fields and system fields
such as priority/components/versions, whose labels resolve correctly since cycle-014 #861) with
their machine option ids, so a caller can look up an id (e.g., for `--field NAME:id=<id>`, BC-3.4.028)
BEFORE creating or editing a ticket, without an admin-gated API call. Sized and filed as a
Cross-Cutting subsection per the `jr requesttype` (BC-X.12) precedent, not a new numbered
section file — see `.factory/phase-f1-delta-analysis/field-dx-bc-mapping.md` §1.3 sizing
rationale.

**Context-mechanism decision (baked in per `.factory/research/field-dx-context-mechanism-2026-08-25.md`,
settling the F1 open design fork; ARITY MODEL CORRECTED per ADR-0019 §1, adversary pass-20 M1)**:
`jr field options <field>` requires EXACTLY ONE of three MODE-SELECTOR flags —
`--type`, `--request-type`, `--issue` — none or multiple → exit 64 before any HTTP.
**`--project` is NEVER a mode selector — it is a companion flag** whose role (required,
optional, or absent) is determined by which mode selector is present:
- **PRIMARY, platform fields**: `--type <T>` (requires a RESOLVABLE PROJECT as its companion —
  an explicit `--project <P>` flag OR the active profile/config default; **[CORRECTED
  2026-08-26, ADR-0019 § Amendment D1]** see "D1" note below — the flag is NOT strictly
  required, only a resolvable project is) → `GET
  /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}` (M2). Chosen PRIMARY
  because it needs no pre-existing issue (closes #580's "before creating" motivating gap) and
  its only documented project permission is Create Issues — no admin gate. **Note the
  correction below (adversary pass-25 HIGH, Option A):** `--project` present WITHOUT `--type`
  AND without `--request-type` AND without `--issue` (i.e. a bare `--project` with no mode
  selector at all) is the ZERO-mode-selector error, NOT the incomplete-M2 error — `--project`
  is never itself a mode selector, so that invocation still has zero of the three present. The
  incomplete-M2 error fires only when `--type` IS present AND no project is resolvable at
  all — neither an explicit `--project` flag NOR a profile/config default. See BC-X.14.004 for
  the full taxonomy and precedence rules.

**[CORRECTED 2026-08-26, ADR-0019 § Amendment (2026-08-26) D1 — M2 default-project resolution
parity]**: an earlier revision of this decision pinned the mode-selector arity CHECK itself to a
4-boolean function `(has_type, has_request_type, has_issue, has_project)`, requiring
`has_project` (the literal `--project` flag) for M2 — which meant `jr field options FOO --type
Bug` exited 64 even when the active profile had a default project configured, contradicting
BC-3.3.010 (create-path `--field` resolves project as "flag OR profile default") and M3's own
optional-`--project`-companion fallback. **Fix: the "is a project resolvable at all?" question
moves OUT of the pure arity function into a separate, post-arity, M2-only resolution step.** The
pure arity check (`resolve_field_context`) is narrowed to a 3-boolean signature —
`(has_type, has_request_type, has_issue) -> Result<Mode, ArityError>` — and no longer takes
`has_project` as an argument at all; it is solely about mode-selector COMBINATION validity. A
new function (e.g. `resolve_m2_project(cli_project: Option<&str>, config: &Config) ->
Option<String>`), invoked only after Step 1 selects M2, resolves the project as: the explicit
`--project` flag value, OR the active profile/config default — the SAME source BC-3.3.010's
create-path project resolution and M3's optional-companion fallback already read; no new
resolution mechanism. If neither is available, M2 still fails with the same incomplete-M2
exit-64 error (message unchanged) — only the TRIGGER CONDITION widens, from "no flag" to "no
flag AND no default." This step reads only already-loaded in-process `Config` state (no HTTP),
so it stays inside the existing "arity guard evaluated before any HTTP call" contract while
being a distinct, later function from the pure arity check. Both `resolve_field_context` (Step
1) and `resolve_m2_project` (Step 2) are pure core — same purity class as
`config::validate_profile_name` — they are two sibling pure functions, not one widened function.
See BC-X.14.001 Invariant 1 / VP-580-006 below for the propagated text.
- **PRIMARY, JSM request-type fields**: `--request-type <NAME|ID>` (`--project <P>` is an
  OPTIONAL companion) → reuses `jr`'s existing
  `GET /rest/servicedeskapi/servicedesk/{sd}/requesttype/{rt}/field` call and 7-day cache (M3,
  same mechanism as `jr requesttype fields`, BC-X.12.005). `--project --request-type` together
  is VALID (M3 with an explicit service-desk project) — NOT a pairing error; when `--project`
  is absent, the ambient profile/config-default project supplies it, resolved via
  `require_service_desk`/`get_or_fetch_project_meta` exactly as `jr requesttype fields` already
  does.
- **FALLBACK / convenience**: `--issue <KEY>` (no `--project` companion — the issue key alone
  supplies project context) → reuses the existing `GET /issue/{key}/editmeta` call `jr` already
  owns (M1, same mechanism as `issue edit --field`, BC-3.4.015). Useful when the caller has a
  concrete reference issue to copy option ids from. **[CAVEAT ADDED 2026-08-26, F2
  adversary-convergence round-6, LOW]**: M1 enumerates the PLATFORM editmeta Edit-screen field
  set for `<KEY>` — this can DIVERGE from the portal request-type field set reachable via M3
  (`--request-type`) on a JSM issue, since the Edit-screen (agent-facing) field set and a request
  type's portal-facing field set are independently configured by a JSM admin and are not
  guaranteed to match. A JSM user who wants the options a customer sees on the PORTAL form (not
  the agent Edit screen) needs `--request-type <RT>` (M3), not `--issue <KEY>` (M1), even when
  they have a concrete issue key in hand.

All three mechanisms are OAuth-3LO-accessible for an ordinary (non-admin) user — this is the
pivot away from the admin-gated `GET /field/{id}/context/{ctx}/option` endpoint #580's own
issue text proposes as a workaround (research verdict: CONFIRM that endpoint requires
`manage:jira-configuration` + Administer Jira and fails for `jr`'s typical user).

**[CORRECTED 2026-08-25 adversary pass-20 M1]**: an earlier revision of this decision framed
`--project`/`--type` as one paired mode-selector unit co-equal with `--request-type`/`--issue`,
which made `--project --request-type` a pairing error and left M3-with-an-explicit-project
reachable only via a profile/config default — inconsistent with the sibling `jr requesttype
fields`, which happily accepts an ambient `--project` alongside a request-type lookup. The
model above (mode-selector/companion split) is the binding one; treat any remaining BC/VP text
elsewhere describing `--project` as a mode selector as stale. See ADR-0019 §1 for the full
rationale and the enumerated arity error cases.

---

#### BC-X.14.001: `jr field options <field> (--type <T> [--project <P>] | --request-type <RT> [--project <P>] | --issue <KEY>)` resolves `<field>` and enumerates its allowed options into a normalized `{id, label, children}` model

> **[H1 CORRECTED 2026-08-26, F2 adversary-convergence round-3, F-MED-2]** M2's synopsis changed from `--type <T> --project <P>` (unbracketed, implying `--project` is mandatory alongside `--type`) to `--type <T> [--project <P>]` (bracketed, mirroring M3's own `[--project <P>]`) — per ADR-0019 § Amendment D1, `--project` on M2 is a flag-OR-profile-default resolution, not a hard requirement; the unbracketed H1 synopsis contradicted D1's own parity decision. **State-manager propagation flag:** the BC-INDEX.md title row for BC-X.14.001 mirrors this H1 verbatim per this doc's own H1-title-source-of-truth convention — the product-owner does not edit BC-INDEX.md directly (state-manager reconciles it last); this note flags that row for the state-manager's next reconciliation pass.

**Confidence**: HIGH
**Subject**: Field option discovery (issue #580)
**Behavior**: After the mode-selector arity check (Invariant 1), and before any cache read or
HTTP call — this ordering is a code-level fact, verified by inspection of
`resolve_field_id` (the guard at ~L442-447 precedes the cache read at ~L451) — an empty-string
`<field>` (`""`) is rejected:
`src/cli/field.rs::resolve_field_id`'s `query.is_empty()` guard exits 64 with `Field ''
not found. The field name must not be empty.` (`test_bc_x_14_001_empty_field_name_exits_64_zero_http`
pins exit 64, the message's `Field '' not found` / `must not be empty` substrings, and zero HTTP
calls on a cold cache — it does not itself pin the
before-any-cache-read ordering) **[CORRECTED cycle-014: aligns with
existing code and tests; no behavior change]**. Otherwise, `<field>` accepts EITHER a
`customfield_NNNNN` literal (bypasses name lookup,
same regex/case-sensitivity convention as BC-3.4.015 Step 1) OR a human field name, resolved
via `GET /rest/api/3/field` (`list_fields()`, same cache-first `fields.json` contract as
BC-3.4.015 Step 2/2b — shared cache and shared `list_fields`/`read_fields_cache`/
`write_fields_cache`, no new cache family; the resolution logic itself is mirrored, not shared
(Invariant 3)) followed by
`src/cli/field.rs::search_field_list` for case-insensitive disambiguation **[CORRECTED
cycle-014: aligns with existing code and tests; no behavior change]** — a single case-insensitive
EXACT name match resolves; two or more exact matches exit 64 (ambiguous, naming the candidates);
otherwise, a single case-insensitive SUBSTRING match resolves; two or more substring matches
exit 64 (ambiguous); zero matches of either kind return "not found". `list_fields()` is
re-fetched on a cache miss OR when `<field>` is absent from the cached list (`Ok(None)` from
`search_field_list`); an ambiguity found IN the cached list (`Err`) exits 64 immediately,
WITHOUT a refresh — the cache is never re-fetched merely to re-check an ambiguous match
(`src/cli/field.rs::resolve_field_id` ~L451-462). This is a distinct
algorithm from `partial_match`/BC-X.10.001 (which never auto-resolves a single substring match) —
`jr field options <field>`'s own field-name resolution auto-resolves on a single substring match,
by design (implements #580's "resolve by human name" nice-to-have, e.g. `jr field options "SOC
Client"`). Exactly ONE
of three MODE-SELECTOR flags — `--type`, `--request-type`, `--issue` — selects the enumeration
mode; `--project` is a companion flag, never itself a mode selector (see §BC-X.14
context-mechanism decision above, and ADR-0019 §1).

**M2 (`--type <T>`) project resolution step [ADDED 2026-08-26, ADR-0019 § Amendment D1]**: the
mode-selector arity check (Invariant 1) is a pure function over `(has_type, has_request_type,
has_issue)` ONLY — `--project`'s presence plays no role in mode arity at all. Once M2 is
selected, a SEPARATE, non-HTTP resolution step determines the project to use: an explicit
`--project <P>` flag value, OR the active profile/config default project — the SAME source
BC-3.3.010's create-path project resolution and M3's optional-`--project`-companion fallback
already read (no new resolution mechanism, no new `Config`/`ProfileConfig` accessor). If neither
is available, M2 fails with the incomplete-M2 exit-64 error (message UNCHANGED; only the trigger
condition widens from "no flag" to "no flag AND no default"). This resolution step runs BEFORE
the issue-type name→id resolution below (which needs a resolved project) and BEFORE
`get_createmeta_fields`, and stays inside the existing "arity guard evaluated before any HTTP
call" contract — it reads only already-loaded in-process `Config` state, no HTTP. It is a
distinct, sibling pure function to the arity check (both are pure core, same class as
`config::validate_profile_name`), not a widened arity check. Known ordering drift (tracked as
drift item `FIELD-OPTIONS-RESOLUTION-ORDER`, out of scope for cycle-014): `src/cli/field.rs::handle`
resolves `<field>` (Step 2, `resolve_field_id`) BEFORE this M2 project-resolution step runs, so a
human-name `<field>` on a cold cache issues one `GET /rest/api/3/field` before the incomplete-M2
project error can fire — in tension with Invariant 1's "before any HTTP call" framing for that
specific error, though not for the mode-selector arity check itself.

**M2 (`--type <T> [--project <P>]`) issue-type name→id resolution step [BRACKETED 2026-08-26, F2 adversary-convergence round-5, LOW-1 — was unbracketed, stale relative to the H1/D1-corrected `[--project <P>]` form]**: `get_createmeta_fields`
(the shared M2 enumeration function, ADR-0019 §1) needs a NUMERIC `issueTypeId`, but `--type`
is accepted as a NAME (same convention as `issue create --type`), so the M2 path resolves
`--type <T>` to an `issueTypeId` BEFORE calling `get_createmeta_fields` — mirroring BC-3.3.010
Step 3 exactly: the SAME project-scoped, case-insensitive `get_issue_types_for_project` lookup
(S-331, `src/api/jira/issues.rs`) `jr` already uses for bulk `--type` and for `issue create
--field`'s createmeta path. This resolution call fires AT MOST ONCE per invocation, and ONLY on
the M2 path (M1/`--issue` and M3/`--request-type` never call it — M1 resolves an issue KEY, not
a project+type pair; M3 resolves a request-type name via its own `partial_match` mechanism,
BC-X.12.006). An unknown or ambiguous `--type` name → exit 64 listing valid issue types for the
resolved project, BEFORE `get_createmeta_fields` is called — see BC-X.14.004's error taxonomy
for the exact row.

**M3 (`--request-type <RT> [--project <P>]`) service-desk resolution step**: `--project` is an
OPTIONAL companion on the M3 path, never a mode selector — `--project --request-type` together
is a VALID invocation (M3 with an explicit service-desk project), NOT a pairing error. When
`--project <P>` is supplied, it names the service-desk project explicitly; when absent, the
ambient profile/config-default project supplies it. Either way, the resolved project key is
handed to `require_service_desk`/`get_or_fetch_project_meta` (`src/api/jsm/servicedesks.rs`)
EXACTLY as `jr requesttype fields <NAME|ID> --project <KEY>` (BC-X.12.005) already does — same
functions, same 7-day `project_meta.json` cache, no new resolution path. A resolved project
that is non-JSM (software) → exit 64 via `require_service_desk`'s call-site-specific message
(BC-X.8.004), same as BC-X.12.003. No resolvable ambient project at all (no `--project`, no
profile/config default) → the existing `require_service_desk` "project required" error,
unchanged from `jr requesttype fields`'s own behavior on the same condition — see BC-X.14.004's
error taxonomy for the exact row. This resolution call fires AT MOST ONCE per invocation and
ONLY on the M3 path (mirroring the M2 `--type` resolution call's at-most-once/single-path
scoping above).

**M3 `--request-type` numeric-bypass edge, inherited [ADDED 2026-08-26, F2 adversary-convergence round-4, O-2]:** M3 reuses `jr requesttype fields`'s existing plumbing verbatim (§ context-mechanism decision above), including its all-ASCII-digit numeric-bypass convention (CLAUDE.md "AI Agent Notes" § `jr requesttype fields <NAME|ID>` numeric-bypass edge case): a `--request-type` value consisting entirely of ASCII digits is treated as a numeric request-type ID and skips `partial_match` name resolution entirely. Consequence, inherited unmodified by `jr field options`: a request type NAMED e.g. `"100"` is unreachable by name on the M3 path — the caller must discover its numeric ID via `jr requesttype list --output json | jq` and pass that ID directly via `--request-type`. This is a pre-existing, documented `jr` behavior (not a new defect introduced by BC-X.14.001), noted here in the `jr field options` M3 path/taxonomy per this cycle's own documentation discipline.

The three sources return option entries under two different key spellings — `M1`/`M2`
(createmeta/editmeta) use `allowedValues[].id`; `M3` (JSM requesttype fields) uses
`validValues[].value` as the option id, with `.label` as display text (`.value` for M1/M2's
display text is the field named `value` when present, falling back to `name` when `value` is
absent **(cycle-014, #861)** — see the "M1/M2 label-resolution fallback" paragraph immediately
below the `FieldOption` contract for the full rule and rationale; the naming collision between
JSM's id-bearing `value` key and M1/M2's label-bearing `value` key is deliberate Atlassian API
inconsistency, not a `jr` bug).

> Previous version (pre-cycle-014, spec 2.3.2): "`.value` for M1/M2's display text is the field
> named `value`, NOT `id`"

`jr` normalizes BOTH shapes into one internal model:
```rust
struct FieldOption {
    id: Option<String>,
    label: Option<String>,
    children: Vec<FieldOption>,   // cascading-select children; empty for non-cascading
}
```
**[CONTRACT AMENDED 2026-08-26, ADR-0019 § Amendment F-B, propagated by product-owner F2 adversary-convergence round-3]** `id` and `label` changed from `String` to `Option<String>` — a faithful pass-through of the already-optional input shape (`types::jira::editmeta::AllowedValue.id`/`.value` are already `Option<String>` one layer below `FieldOption`), NOT a new sentinel invented at this layer. A source `allowedValues`/`validValues` entry with a genuinely missing `id` and/or missing label-source field(s) (e.g. a GDPR-restricted user-picker option, or a config-broken option) degrades that entry's own field(s) to `None` rather than being coerced to an empty string or dropped. (cycle-014, #861) "Missing label-source field(s)" means, precisely: missing BOTH `value` AND `name` for the M1/M2 sources (M1/M2's `label` is the `value`-else-`name` fallback described below — "missing `label`" is not itself a wire-level condition for these two sources), and missing `label` for the M3 (JSM requesttype-fields) source (M3 has no fallback — its `label` field is read directly from the wire `.label` key). See EC-X.14.001-7 (never-drop invariant) and BC-X.14.003 (rendering) below. `children` is UNCHANGED — always present, never `Option`, per EC-X.14.001-4's existing "always present, never `null`/absent" contract; F-B extends the same *presence* discipline to a different per-field *value* state, it does not alter `children`'s own shape.

**M1/M2 label-resolution fallback: `value`, else `name`, else `None`**: the M1/M2
normalizer's label mapping is `label: v.value.clone().or_else(|| v.name.clone())`, NOT
`label: v.value.clone()` alone. System-typed fields — `priority`, `resolution` (when present on
the Create/Edit screen; resolution usually is not — see EC-X.14.001-5),
`versions`/`fixVersions`, `components`, `security`, `issuetype` (externally grounded against
first-party Atlassian API docs, `.factory/research/github-issues-triage-grounding-2026-09-24.md`
§#861, HIGH confidence) — return `allowedValues[]` entries carrying `name`, not `value`, as
their display label; a normalizer reading `value` alone therefore rendered EVERY system-field
option's label as BC-X.14.003's degenerate-entry placeholder (`"(unnamed)"` table / `null` JSON)
even though the entry was fully well-formed on the wire — a display-label defect, not a
missing-data one. No prior BC text narrowed M1/M2's label to `value`-only as a deliberate
contract choice — the earlier characterization (quoted above, "the field named `value`") rested
on `.factory/research/field-dx-context-mechanism-2026-08-25.md`, which sampled only CUSTOM
select/radio/checkbox/multiselect fields (which do carry `value`) and never sampled a system
field's `allowedValues` shape; this correction closes that research gap, it does not reverse a
considered design decision.

F4 corrects two stale doc comments on `src/types/jira/editmeta.rs::AllowedValue` — no `src/`
edit is made by this F2 spec-only delta:
1. The `AllowedValue` struct-level doc comment (`src/types/jira/editmeta.rs:~64-77`), which
   states "`name` is parsed but unused in v1 — retained for future cascade-select matching."
2. The `name` field's own doc comment (`src/types/jira/editmeta.rs:~83-85`), which states
   "Secondary label present on some Jira option types (e.g. cascade-select children). Parsed
   from the API response; unused in v1 resolution logic. Future: v2 cascade-select name
   matching."
Both were verified against the current file content and both still read "unused in v1" —
`AllowedValue.name` is now a genuine v1 resolution input for the M1/M2 label fallback above, so
both comments misstate the current behavior, not merely an aspirational future one.

**Scope boundary — READ-SIDE ONLY, WRITE-side explicitly out of scope [D-378]**: this amendment
governs ONLY the M1/M2 enumeration normalizer (`normalize_from_allowed_values`, this BC). The
WRITE-side `--field` value-matching path
(`src/cli/issue/field_resolve.rs::find_option_match`/`resolve_option_value`) is explicitly OUT
OF SCOPE — a fresh-context audit REFUTED that path's reachability for system-typed fields:
`dispatch_field_value` routes to option-matching logic only when
`meta_field.schema.field_type` is `"option"` (or `"option-with-child"` for the hinted `:option`
composer's EC-3.4.027-1 entry gate), and real Jira system fields report `schema.type`
`priority`/`resolution`/`issuetype`/`securitylevel` — none of which is `"option"` — so `jr issue
edit ISSUE-1 --field Priority=High` fails earlier via `unsupported_field_type_error` and never
reaches `find_option_match` at all (corroborated by
`tests/issue_edit_field.rs::test_bc_3_4_017_field_priority_without_flag_does_not_trigger_gate_b`,
which mocks priority as a custom `"string"` field specifically because a genuine
`"priority"`-typed field never reaches that code path). The distinct, genuine capability gap
this audit surfaced — the bare, un-hinted `--field NAME=VALUE` form cannot set system-typed
fields; the `:id`/`:name` hinted-bypass composers (BC-3.4.028/029) already can — is tracked
separately as drift item `FIELD-SYSTEM-TYPES-UNSUPPORTED` (LOW priority), NOT folded into this BC.

**M3 (JSM requesttype-fields) is UNCHANGED and was ALREADY CORRECT — stated explicitly, not
merely implied**: `normalize_from_valid_values` reads `.value` for the option id and `.label`
for the display text — two DIFFERENT wire keys, no fallback needed, no naming collision with
this amendment's M1/M2 `value`/`name` fallback. This amendment does not touch M3's normalizer,
its wire-shape contract, or any M3-specific edge case at all.

Cascading fields (`option-with-child` / JSM `children[]`) are enumerable — child options are
nested under their parent's `children` array in the normalized model, recursively (both M1/M2's
`allowedValues[].children[]` and M3's `validValues[].children` are read into the same shape).
**[read-side shape per research; write-side unverified — see BC-3.8.008]** This READ-side
`children[]` shape for all three sources (M1/M2's `allowedValues[].children[]` with per-child
`id`; M3's `validValues[].children` with per-child `value`) is CONFIRMed by
`.factory/research/field-dx-context-mechanism-2026-08-25.md` (§Q-A, M1/M2/M3 rows: "cascading
parent+child both carry `id` under `children[]`"; "note the key is `value`, not `id`"; §"all
three expose cascading child IDs"), not merely asserted by analogy — this is the read/GET
enumeration path (`jr field options`), distinct from the JSM `requestFieldValues` WRITE-side
cascading composition on `issue create --request-type` (BC-3.8.008's amendment), which remains
explicitly UNVERIFIED against live JSM and out of scope this cycle. Do not conflate the two: a
CONFIRMed read shape here does not imply a verified write shape there.

**Preconditions**:
- `jr field options <field>` invoked with EXACTLY ONE of the three MODE-SELECTOR flags —
  `--type` (requiring a RESOLVABLE PROJECT as its companion — an explicit `--project <P>` flag
  OR the active profile/config default; **[CORRECTED 2026-08-26, ADR-0019 § Amendment D1]** see
  the "M2 project resolution step" paragraph above — the flag itself is not strictly required,
  only a resolvable project is), `--request-type <RT>` (with an OPTIONAL `--project <P>`
  companion), or `--issue <KEY>` (`--project` not consulted — **[REWORDED 2026-08-26, A-LOW-2]**
  a stray `--project` alongside `--issue` is harmlessly ignored, not rejected; this is a
  "not consulted" statement, not a prohibition).
- `<field>` resolves to exactly one field (via `customfield_NNNNN` bypass or unambiguous
  `search_field_list` name resolution — `src/cli/field.rs::search_field_list`, NOT
  `partial_match`/BC-X.10.001; see Invariant 4).

**Postconditions**:
- On success: a `Vec<FieldOption>` is produced, normalized regardless of source mechanism.
- `GET /rest/api/3/field` is NOT called when `<field>` is empty (`""` — the `query.is_empty()`
  guard exits 64 before any cache read — a code-level ordering verified by inspection, per the
  Behavior paragraph above; the empty-field test itself pins zero HTTP calls on a cold cache,
  not this ordering **[CORRECTED
  cycle-014: aligns with existing code and tests; no behavior change]**), NOT called when
  `<field>` is a `customfield_NNNNN` literal, and
  NOT called when a warm `fields.json` cache exists for the active profile AND `<field>`
  resolves (exactly or unambiguously by substring) within that cached list (same cache
  contract as BC-3.4.015 invariants 6-8). A warm cache that does not contain `<field>` still
  triggers exactly one fresh `GET /rest/api/3/field` fetch (cache miss OR name absent from the
  cached list); an ambiguity found WITHIN the warm cache exits 64 immediately, without any
  refetch (`src/cli/field.rs::resolve_field_id` ~L451-462).
- **[CORRECTED, adversary pass-28 F-1; M3 claim corrected, F2 adversary-convergence pass, B-F1]**
  Exactly one of the three enumeration MECHANISMS (createmeta / requesttype-fields / editmeta)
  fires, per the selected mode selector — "one mechanism" means one logical enumeration, NOT
  necessarily one HTTP call. The M2 (createmeta, `get_createmeta_fields`) mechanism PAGINATES
  INTERNALLY until all pages are collected (OFFSET-paginated, `startAt`/`maxResults`/`total`, per
  ADR-0019 §1), so it may issue MULTIPLE `GET`s for a single invocation. **The M3
  (requesttype-fields) mechanism is a SINGLE, non-paginated `GET`**:
  `src/api/jsm/request_types.rs::get_request_type_fields` returns a flat envelope
  (`RequestTypeFieldsResponse { can_raise_on_behalf_of, can_add_request_participants,
  request_type_fields: Vec<...> }`) with NO `size`/`start`/`limit`/`isLastPage`/`_links.next`
  fields — it is a DIFFERENT function from the `isLastPage`-style-paginated `list_request_types`
  (which lists request TYPES, not one request type's FIELDS); the earlier claim that M3 "reuses
  the EXISTING `jr requesttype fields` pagination" conflated the two. If a future JSM
  tenant/API version returns a paginated field envelope this claim would need revisiting, but the
  CURRENT truth, as of this cycle, is: one GET, no pagination. M1 (editmeta) remains genuinely a
  single `GET`. Plus — on the M2 (`--type`) path
  only — exactly one LOGICAL `get_issue_types_for_project` issue-type name→id resolution (at most
  once per invocation, per BC-3.3.010's own Postconditions), OFFSET-PAGINATED INTERNALLY
  (`startAt`/`maxResults`/`total`) — one or more GETs until all issue-type pages are collected, so
  a `--type` name landing on page ≥2 still resolves; carries no cache — which fires BEFORE the
  createmeta enumeration mechanism and is absent on the M1 and M3 paths. **[CORRECTED, adversary
  pass-29 F-1]** the preceding `get_issue_types_for_project` clause was reworded from pass-28's own
  text, which wrongly claimed the call was "itself a single, non-paginated call, unaffected by
  this correction" — that claim is false: `get_issue_types_for_project` (`src/api/jira/issues.rs`)
  offset-paginates identically in kind to `get_createmeta_fields` above, and a `--type` name
  landing on page ≥2 of a large enterprise type scheme would have been silently dropped under the
  pass-28 framing. **[Pre-pass-29 wording, superseded, retained for audit trail]:** "exactly one
  `get_issue_types_for_project` issue-type name→id resolution call (itself a single, non-paginated
  call, unaffected by this correction)" — this is the exact clause pass-29 corrects.
  **[Pre-pass-28 wording, superseded,
  retained for audit trail]:** "Exactly one of the three enumeration HTTP calls (createmeta /
  requesttype-fields / editmeta) fires, per the selected mode selector, plus — on the M2
  (`--type`) path only — exactly one `get_issue_types_for_project` issue-type name→id resolution
  call, which fires BEFORE the createmeta enumeration call and is absent on the M1 and M3
  paths." — this literally described M2/M3 as single HTTP calls, contradicting ADR-0019 §1's
  offset-pagination spec for `get_createmeta_fields` and the pre-existing pagination of `jr
  requesttype fields`.
  **[Pre-B-F1 wording, superseded, retained for audit trail]:** "M2 (createmeta,
  `get_createmeta_fields`) and M3 (requesttype-fields) mechanisms each PAGINATE INTERNALLY until
  all pages are collected, so either may issue MULTIPLE `GET`s for a single invocation: M2 is
  OFFSET-paginated (`startAt`/`maxResults`/`total`, per ADR-0019 §1); M3 reuses the EXISTING `jr
  requesttype fields` pagination (`isLastPage`-style, `src/api/jsm/request_types.rs`), unchanged
  by this BC." — this M3 half is FACTUALLY FALSE: `get_request_type_fields` is a single
  non-paginated GET; the cited `isLastPage` loop belongs to the different function
  `list_request_types` (lists request TYPES, not one request type's FIELDS).

**Invariants**:
1. **Mode-selector mutual exclusion is enforced BEFORE any HTTP call.** Exactly one of the three
   MODE-SELECTOR flags — `--type`, `--request-type`, `--issue` — must be present; `--project` is
   NEVER counted as a mode selector. Zero mode selectors → exit 64 ("specify exactly one of
   --type, --request-type, --issue"). Two OR more mode selectors specified simultaneously (e.g.,
   `--issue KEY --request-type RT`) → exit 64, same message, listing the conflicting flags.
   `--type` present with NO resolvable project — neither an explicit `--project` flag NOR a
   profile/config default — → exit 64, the incomplete-M2 error. **[CORRECTED 2026-08-26,
   ADR-0019 § Amendment D1]**: the pure mode-selector arity check itself (`resolve_field_context`)
   is a function of `has_type`/`has_request_type`/`has_issue` ONLY and does not evaluate
   `--project` or project-resolvability at all — project resolvability is a separate, post-arity,
   M2-only step (see the "M2 project resolution step" paragraph above and VP-580-006 below). A
   bare `--project` with no mode selector at all is a ZERO-mode-selector invocation
   (`--project` is never counted as a mode selector), so it lands in the zero-mode-selector row
   above, NOT the incomplete-M2 row — the two conditions are distinct and must not be conflated.
   `--request-type` WITH
   `--project` is VALID (M3 with an explicit service-desk project) — NOT a pairing error. See
   BC-X.14.004 for the full error taxonomy and precedence rules.
2. This command is READ-ONLY — zero mutating HTTP calls under any invocation.
3. The `customfield_NNNNN` bypass and `fields.json` cache-first contract use the SAME algorithm
   and the SAME cache file/functions (`read_fields_cache`/`write_fields_cache`/`list_fields`),
   implemented in `src/cli/field.rs` as a mirrored copy of
   `src/cli/issue/field_resolve.rs::resolve_edit_fields`'s Step 1 (customfield bypass) and Step 2
   (cache-first load/fetch plus its nested `search_field`) — not a shared function; a change to
   one must be mirrored in the other (corrected cycle-014:
   aligns with existing code; no behavior change),
   same profile-scoped isolation as BC-3.4.015.
4. Field-NAME resolution uses `search_field_list` (`src/cli/field.rs`), NOT `partial_match`/
   BC-X.10.001 — a distinct algorithm, pinned by `test_bc_x_14_001_search_field_list_*`: an
   empty `<field>` (`""`) exits 64 after the mode-selector arity check (Invariant 1) and before
   `search_field_list` or any cache/HTTP access — this ordering is a code-level fact, verified
   by inspection
   (`query.is_empty()` guard); `test_bc_x_14_001_empty_field_name_exits_64_zero_http` pins exit
   64, the message, and zero HTTP calls on a cold cache, not the ordering itself
   **[CORRECTED cycle-014: aligns with existing code and tests; no behavior change]**; otherwise
   a single
   case-insensitive EXACT match auto-resolves; multiple exact matches exit 64 naming candidates;
   otherwise a single case-insensitive SUBSTRING match auto-resolves (unlike `partial_match`'s
   `Ambiguous`, which never auto-resolves a single substring); multiple substring matches exit 64
   naming candidates.

**Edge Cases**:
- EC-X.14.001-1: `customfield_10084` literal → bypasses `list_fields()`/`search_field_list`
  entirely, same as BC-3.4.015 Step 1.
- EC-X.14.001-2: `"SOC Client"` human name, unambiguous exact match → resolves via
  `list_fields()` (cache-first) + `search_field_list`, then proceeds to enumeration.
- EC-X.14.001-3: Human name resolves to MULTIPLE candidates (ambiguous) → exit 64 naming the
  candidates and their `customfield_NNNNN` ids (mirrors EC-3.4.015-2), before any enumeration
  HTTP call.
- EC-X.14.001-4: Cascading field (`option-with-child`) → `children[]` populated with the child
  options nested under their parent (Jira's cascading model is exactly two levels — one parent
  plus one flat child list; the `Vec<FieldOption>` model can represent deeper nesting, but live
  data never populates it); a non-cascading field always has `children: []` (never `null`/absent).
- EC-X.14.001-5: `<field>` resolves successfully against the global `GET /field` list (or via
  `customfield_NNNNN` bypass) but is ABSENT from the selected context's field set — not on the
  `--project`/`--type` createmeta Create screen, not on the `--issue` editmeta Edit screen, and
  not in the `--request-type` requesttype-fields list — because a field can exist globally while
  not being configured on any particular project+issue-type/request-type screen. Exit 64; see
  BC-X.14.004's error taxonomy for the per-context message shape (mirrors BC-3.3.010
  EC-3.3.010-2's "not on the Create screen" distinction between global existence and
  screen-membership).
- EC-X.14.001-6 **[ADDED 2026-08-26, F2 adversary-convergence pass, B-LOW — the REVERSE of
  EC-X.14.001-5]**: on the M3 (`--request-type`) path specifically, a field IS enumerable in the
  resolved request type's `validValues` (i.e. present in the selected context's field set) but is
  NOT surfaced by the global `GET /rest/api/3/field` list under any human-readable name reachable
  via `list_fields()`/`search_field_list` — some JSM-specific request-type field configurations are
  not mirrored 1:1 into the global field catalog. In this narrow case, `<field>` is resolvable
  ONLY via its literal `customfield_NNNNN` id (the bypass path, BC-3.4.015 Step 1) — a human-name
  lookup for such a field fails with the ordinary zero-matches error (EC-3.4.015-1 parallel), even
  though the field genuinely is enumerable once addressed by id. This is a discoverability
  limitation, not a `jr` defect: `jr field options` cannot resolve-by-name a field the global
  field list itself does not expose a name for; the caller falls back to `jr requesttype fields
  <RT> --output json` (which lists the request type's own field ids directly) to discover the id.
- EC-X.14.001-7 **[ADDED 2026-08-26, ADR-0019 § Amendment F-B, propagated by product-owner F2
  adversary-convergence round-3 — sibling to EC-X.14.001-4's `children` "always present, never
  absent" contract]**: a source `allowedValues`/`validValues` entry that is missing `id` and/or
  its label-source field(s) (the GDPR-restricted or config-broken option case) is NEVER dropped
  from the normalizer's output. **(cycle-014, #861)** "Missing label-source field(s)" means
  missing `value` AND `name` (M1/M2) / `label` (M3) — see the FieldOption contract note above for
  the same precision applied there. Both normalizers (M1/M2's `normalize_from_allowed_values`,
  M3's `normalize_from_valid_values`) MUST emit exactly one `FieldOption` per source item,
  regardless of which fields that item carries — an entry missing `id` and/or its label source(s)
  degrades that entry's OWN `id`/`label` field to `None`, it MUST NEVER cause the entry to be
  omitted from the returned `Vec<FieldOption>`. This is the never-drop invariant: discoverability
  (#580's whole reason for existing) requires every enumerable option to be shown, even one `jr`
  cannot fully identify — silently dropping it is strictly worse than showing a visibly degenerate
  entry the caller can follow up on (e.g. cross-referencing `jr field options --output json`
  against the resolved request-type/issue-type screen directly in the Jira UI). A source item
  missing BOTH `id` and its label source(s) still produces exactly one `FieldOption { id: None,
  label: None, children: [] }` entry in the array — it is never silently absent from the result.
  See BC-X.14.001's `FieldOption` contract amendment above and BC-X.14.003 for the corresponding
  table/JSON rendering rules.

  **EC-X.14.001-8 through EC-X.14.001-13 below are new Edge Cases added this cycle (#861).**
- EC-X.14.001-8: a system field's `allowedValues` entry carrying `{id: "1", name: "Highest"}`
  with NO `value` (the real-world `priority` shape) → the M1/M2 label-resolution fallback
  resolves `label` to `"Highest"` via the `name` fallback, NOT the pre-fix `(unnamed)`/`null`
  degenerate rendering — this is the exact defect #861 reported, now closed for the read-side
  enumeration path.
- EC-X.14.001-9: an `allowedValues` entry carrying BOTH `value` and `name` populated → `value`
  WINS (the fallback activates only on `value`'s absence, per the `.or_else` semantics) — this is
  never a `name`-preference or a "prefer the more complete field" rule; it is a strict
  first-match-wins order, `value` then `name`.
- EC-X.14.001-10: an `allowedValues` entry carrying NEITHER `value` NOR `name` → unchanged
  degenerate behavior — `label: None`, rendered per BC-X.14.003's existing `"(unnamed)"` (table)
  / `null` (JSON) placeholder, per EC-X.14.001-7's never-drop invariant above. This does not add a
  third fallback source or otherwise touch the already-established neither-present case.
- EC-X.14.001-11: a cascading parent's CHILD entry carrying `name` but no `value` (e.g. a
  cascading `priority`-like field, if one existed, or any cascading child whose wire shape omits
  `value`) → the same `value`-else-`name` fallback applies recursively, since
  `normalize_from_allowed_values_at_depth` applies its per-item mapping identically at every
  recursion depth — cascading children are not exempt from the fallback.
- EC-X.14.001-12: the fallback is presence-based, not emptiness-based — an `allowedValues` entry
  carrying `value: ""` (an explicit empty string) still takes the `value` branch and produces
  `label: Some("")`, rendered as a blank cell (table) / `""` (JSON), never `"(unnamed)"`/`null`.
  `name` is consulted only when `value` is entirely absent from the source item, not when it is
  present-but-empty. An explicit wire `"value": null` deserializes to `None` (`AllowedValue.value`
  is a plain `Option<String>`, no custom deserializer), which is ABSENCE, not presence-but-empty —
  `name` IS consulted in that case, exactly as when the `value` key is missing entirely. Only
  `Some("")` (the string present but empty) wins over `name`; `None`, whether from a missing key
  or an explicit JSON `null`, never does.
- EC-X.14.001-13: a consequence of the label-resolution fallback above, not a change to
  BC-X.14.002's own contract — BC-X.14.002's `--value <substring>` client-side filter
  (`src/cli/field.rs::filter_options`/`src/cli/field.rs::filter_one`, matching against `label` or
  `id`) now also matches system-field
  option names via the fallback `label` (e.g. `jr field options priority --issue KEY --value
  high` matches the `priority` option whose `label` resolves to `"High"` through the `name`
  fallback, where it previously would not have matched because `label` was `None`; on a fixture
  carrying both `Highest` and `High` options, `--value high` matches BOTH, since
  `src/cli/field.rs::filter_one`'s
  substring match against `label` is case-insensitive and not anchored — this is ordinary
  substring-filter behavior, not new to this fix). This is a
  read-side-only effect of #861's normalizer fix propagating downstream into an existing,
  unmodified filter — BC-X.14.002's text is unchanged.
- EC-X.14.001-14 (added cycle-014; documents pre-existing behavior): `<field>`
  RESOLUTION itself (the step before the M1/M2/M3 label fallback above ever runs) is unaffected
  by #861 — it still goes through `src/cli/field.rs::resolve_field_id`/`search_field_list`
  (case-insensitive exact match, then case-insensitive substring match; the only bypass is a literal
  `customfield_NNNNN`). Resolution is by DISPLAY NAME, and display names are TENANT/LOCALE
  DEPENDENT — this file does not pin an exact display-name string as a portable constant.
  Three verified consequences for system fields: (a) `jr field options
  priority` resolves, because the `Priority` system field's id (`priority`) and its display name
  (`Priority`) happen to be case-insensitive-equal — the match is still on NAME via
  `search_field_list`'s exact-match branch, not a hidden id-match path; (b) `jr field options
  fixVersions` typically does NOT resolve, because the field's real display name is punctuated
  (e.g. `Fix Version/s` or `Fix versions`, depending on site/locale — verified against
  `GET /rest/api/3/field` on the sampled tenant, not asserted as a universal constant), and
  `fixVersions` (the camelCase field id) matches neither exactly (differs in spacing/punctuation/
  casing) nor as a case-insensitive substring — the camelCase id lacks the space (and, where
  present, the slash) that the display name contains, which breaks contiguity — it exits 64
  with `Field 'fixVersions' not found...`; the caller
  must pass the exact display name shown by `jr api /rest/api/3/field` (verified: this raw
  passthrough lists every field's `id`/`name` pair — `jr project fields --output json` does NOT
  list generic field names, only issue types/priorities/statuses/CMDB asset fields, so it is NOT
  the right discovery command for this purpose) instead; (c) on a tenant whose Version fields are
  named with a `/` (e.g. `Affects Version/s` and `Fix Version/s`), the genuinely ambiguous case is
  the SINGULAR substring `jr field options version` (the plural `versions` does NOT match either
  display name for the same slash-contiguity reason as (b), and also exits 64 not-found) —
  `version` IS a case-insensitive substring of both names on such a tenant (the slash falls after
  `version`, not inside it), so `search_field_list`'s substring branch returns 2 candidates and
  exits 64 as ambiguous, naming both. This is pre-existing `resolve_field_id`/`search_field_list`
  behavior, unmodified by this cycle's read-side label-fallback fix; it does not change this
  cycle's scope. Known inconsistency: BC-X.14.004's zero-match hint and `resolve_field_id`'s
  shipped error message (`src/cli/field.rs::resolve_field_id`) both name `jr project fields
  --output json`, which does not list field names; tracked as drift item
  FIELD-OPTIONS-NOTFOUND-HINT (out of scope for cycle-014).
- EC-X.14.001-15 (added cycle-014; documents pre-existing behavior, no behavior change):
  `<field>` is the empty string (`""`) → exit 64 with `Field '' not found. The field name must
  not be empty.`, zero HTTP calls — pinned on a cold cache by
  `tests/field_options.rs::test_bc_x_14_001_empty_field_name_exits_64_zero_http` (which pins
  exit 64, the message's `Field '' not found` / `must not be empty` substrings, and zero HTTP,
  not the guard's ordering) — and zero cache reads, a
  code-level fact verified by inspection: the guard
  (`src/cli/field.rs::resolve_field_id`'s `query.is_empty()`, ~L442-447) precedes the cache read
  at ~L451.

**Verification Properties**:
- VP-580-001: `customfield_NNNNN` literal bypass skips `list_fields()` entirely (zero HTTP for
  name resolution).
- VP-580-002: All three source mechanisms (M1/M2/M3) normalize to the SAME `{id, label,
  children}` shape for equivalent input fixtures — the output shape is source-independent.
- VP-580-003: Cascading `children[]` nesting round-trips correctly from both the M1/M2
  (`allowedValues[].children[]`) and M3 (`validValues[].children`) wire shapes.
- VP-580-005 **[STRENGTHENED 2026-08-26, ADR-0019 § Amendment F-B, propagated by product-owner F2
  adversary-convergence round-3 — FLAGGED FOR VERIFIER]**: beyond its existing "no panic" tolerance
  assertion (BC-X.14.004's graceful-degrade coverage), this VP's normalizer-tolerance section must
  additionally assert (a) entry-count preservation — the normalizer NEVER emits fewer
  `FieldOption`s than source items, for a fixture mixing well-formed and degenerate (missing
  id/label/both) entries; (b) the exact `Option::None` → JSON `null` shape on `--output json`
  (no `#[serde(skip_serializing_if)]`, key always present); (c) the two pinned table-rendering
  strings from BC-X.14.003 (`NULL_GLYPH`/`"—"` for a missing id, `"(unnamed)"` for a missing
  label) against a fixture item missing id and a fixture item missing label respectively. See
  EC-X.14.001-7 (never-drop invariant) and BC-X.14.003 (rendering contract).
- VP-580-006: Mode-selector mutual-exclusion (Invariant 1). **[REWRITTEN 2026-08-26, ADR-0019 §
  Amendment D1]** The arity decision is extracted to a pure function,
  `resolve_field_context(has_type, has_request_type, has_issue) -> Result<Mode, ArityError>`,
  over the three MODE-SELECTOR booleans ONLY — `has_project` is NOT a parameter of this function
  AT ALL (narrowed from a 4-boolean signature that previously took `has_project` as a fourth
  argument even though it was excluded from the arity comparison itself). Proptested
  exhaustively over the 3-boolean flag-presence space: EXACTLY one of the three mode-selectors
  present → `Ok`; zero mode-selectors, two-or-more mode-selectors → `Err` (exit 64). A SEPARATE,
  SIBLING pure function, `resolve_m2_project(cli_project: Option<&str>, config: &Config) ->
  Option<String>`, invoked only after `resolve_field_context` selects M2, resolves `--project`
  as: the explicit flag value, OR the active profile/config default; `None` from this function
  on the M2 path → `Err`, the incomplete-M2 error. M3's `--request-type && has_project` → `Ok`
  (NOT a pairing error) and M1's `--issue` (project not consulted) are unaffected — those
  companion rules live where they always did, outside the arity function. Enforced BEFORE any
  HTTP call — wiremock integration asserts zero requests fired on the reject paths (pre-HTTP
  guarantee, analogue of D-188's pre-flight placement). Realized as an inline `proptest!`
  co-located with each guard fn plus `tests/field_options.rs` integration; the `--project
  --request-type` VALID-pairing regression guard is VP-580-009; per-error-message shape is
  covered by VP-580-004's taxonomy rows. **[NEW 2026-08-26, ADR-0019 § Amendment D1]** VP-580-010:
  a sibling verification target for `resolve_m2_project` specifically, covering `{--project flag
  present, profile default present, neither present} × M2-only`, structurally mirroring whatever
  existing VP covers BC-3.3.010's flag-or-default project resolution on the create path. **Prior
  wording (superseded, retained for audit trail):** "the arity decision is extracted to a pure
  function over the context-flag booleans (`has_type`, `has_request_type`, `has_issue`,
  `has_project`) and proptested exhaustively over the flag-presence space. Arity is evaluated
  over the three MODE-SELECTOR booleans ONLY (`has_type`, `has_request_type`, `has_issue`) —
  `has_project` is NEVER counted toward the mode-selector arity... subject to that mode's own
  companion rule for `--project` (M2/`--type`: `has_project` REQUIRED, else `Err`...)" — this
  described `has_project` as a (non-counted) PARAMETER of the SAME arity function, which is no
  longer accurate: D1 removes it from that function's signature entirely.
- VP-580-013 (cycle-014, issue #861, READ-SIDE ONLY): the M1/M2 label-resolution fallback
  (EC-X.14.001-8..13). **What it proves:** for M1/M2 (`normalize_from_allowed_values`, via
  `normalize_from_allowed_values_at_depth`), every emitted node's `label` equals
  `value.or(name)` of its source item, at every depth — `value` when present, else `name`, else
  `None`. The rule is presence-based: `value: Some("")` wins over a populated `name` and yields
  `label: Some("")`, while `value: None` — whether the key is missing or the wire carries an
  explicit JSON `"value": null` — falls through to `name` (EC-X.14.001-12). **Strategy:** (1) an
  example matrix at the top level and at one cascading-child level, asserting the exact resolved
  `label` in each cell: value-only; name-only; both (`value` wins); neither (`None`)
  (EC-X.14.001-8..11); `{"value": "", "name": "N"}` → `Some("")` (value wins);
  `{"value": null, "name": "N"}` deserialized from JSON → `Some("N")` (explicit null is absence,
  falls through to `name`) (EC-X.14.001-12). The two EC-X.14.001-12 cells are built by
  deserializing JSON fixtures into `AllowedValue`, not by constructing the struct directly, so the
  explicit-null case exercises the real deserializer; (2) a `proptest!` over a recursive
  `AllowedValue` strategy (`Option<String>` for each of `id`/`value`/`name`, `children` nested to
  depth ≤ 3) asserting `label == value.clone().or(name.clone())` at every node, `id` carried
  through unchanged, and the emitted tree the same shape (node count, child order) as the input
  up to the existing `MAX_FIELD_OPTION_DEPTH` cap; (3) a companion property serializing the
  output with `serde_json::to_value` and asserting every node's key set is exactly
  `{"id","label","children"}`, with `label` a JSON string or `null` — the `--output json` shape
  is unchanged (VP-580-008(b) is not modified); (4) M3 regression guard: a JSON fixture of
  `validValues` entries run through `normalize_from_valid_values` is compared against a
  hand-written expected `Vec<FieldOption>` (not a golden file captured from the implementation).
  M3 reads untyped `serde_json::Value` entries, taking `id` from `value` and `label` from
  `label` only; an unknown `name` key is ignored, never rejected. The fixture includes the
  entries that would expose a fallback leak into M3:
  `{"value":"10","name":"N"}` (no `label`) → `{id: Some("10"), label: None, children: []}`;
  `{"value":"11","label":"L","name":"N"}` → `{id: Some("11"), label: Some("L"), children: []}`;
  and an ordinary `{"value":"12","label":"Twelve"}` → `{id: Some("12"), label:
  Some("Twelve"), children: []}`. A `name` fallback leaking into M3 turns the first entry's
  `label` into `Some("N")` and fails the comparison; (5) EC-X.14.001-13 downstream example: a `priority`-shaped fixture
  (`[{"id":"1","name":"Highest"},{"id":"2","name":"High"},{"id":"3","name":"Low"}]`, no
  `value`) normalized via `normalize_from_allowed_values` and then passed to
  `src/cli/field.rs::filter_options(&opts, Some("high"))` (which delegates to `src/cli/field.rs::filter_one`, matching
  `label` or `id` case-insensitively) returns exactly the `Highest` and `High` entries, matched
  through their fallback `label`s; `Some("3")` returns the `Low` entry through its `id`. All five
  are pure (no HTTP, no config). **Fault models (killed by example/proptest):** the fallback
  removed entirely (pre-fix code: `label: v.value.clone()`), killed by the EC-X.14.001-8
  name-only cell; `name` preferred
  over `value`; an emptiness-based fallback (`Some("")` falling through to `name`); explicit
  `null` treated as present (never falling through to `name`); the fallback applied only at the
  top level; the fallback leaking into the M3 normalizer.

**Trace**: issue #580; `.factory/research/field-dx-context-mechanism-2026-08-25.md` (M1/M2/M3
ranked recommendation, per-mechanism verdict table); `.factory/research/field-dx-feasibility-2026-08-25.md`
claims 1-4; ADR-0019 §1 (context-mechanism arity model — mode-selector/companion correction,
adversary pass-20 M1); ADR-0019 § Amendment (2026-08-26) D1 (M2 default-project resolution
parity — narrows the pure arity function to 3 booleans, adds the sibling `resolve_m2_project`
post-arity step); BC-3.4.015 (cache contract shared via `read_fields_cache`/`write_fields_cache`/
`list_fields`; field-name resolution algorithm mirrored, not shared — see Invariant 3);
BC-X.12.003/005 (JSM requesttype-fields call + cache + `--project` companion resolution via
`require_service_desk`/`get_or_fetch_project_meta`, reused); `src/cli/field.rs::search_field_list`
(field-name resolution — NOT BC-X.10.001/`partial_match`, see Invariant 4); BC-3.3.010 Step 3
(M2 `--type` name→issueTypeId resolution pattern, mirrored);
`src/cli/field.rs` (new); `src/api/jira/issues.rs::get_createmeta_fields` (new
createmeta-with-`allowedValues` enumeration method, M2, per ADR-0019 §1);
`src/api/jira/issues.rs::get_issue_types_for_project` (REUSED, S-331 — M2 `--type` name→id
resolution, at most once per invocation, fires before `get_createmeta_fields`);
`src/api/jira/fields.rs::list_fields` (REUSED for field-name resolution only, not a new
enumeration function — see BC-3.4.015); `src/api/jsm/request_types.rs` (M3, reused);
`src/api/jsm/servicedesks.rs::{require_service_desk,get_or_fetch_project_meta}` (M3 companion
`--project`/ambient-default resolution, reused). **(cycle-014, #861)** issue #861 (M1/M2
label-resolution fallback, READ-SIDE ONLY, D-378); `.factory/research/github-issues-triage-grounding-2026-09-24.md`
§#861 (`allowedValues` shapes by field type, first-party Atlassian API doc citations);
`.factory/cycles/cycle-014/phase-f1-delta-analysis/delta-analysis.md` §Item #861 (write-side
reachability audit and refutation); `src/cli/field.rs::normalize_from_allowed_values_at_depth`
(to be modified, cycle-014); `src/types/jira/editmeta.rs::AllowedValue` struct-level doc comment AND
`AllowedValue.name` field-level doc comment (both to be corrected at F4, cycle-014 — no behavior
change to the struct itself)

[NEW 2026-08-25 issue #580 F2]

---

#### BC-X.14.002: `--value <substring>` client-side filter narrows the enumerated option list to matching id/label(s)

**Confidence**: HIGH
**Subject**: Field option discovery — `--value` filter (issue #580)
**Behavior**: `jr field options <field> --value <substring> [context flags]` enumerates the
full option list per BC-X.14.001, then applies a CLIENT-SIDE case-insensitive substring filter
against BOTH `label` and `id` for each top-level entry (matching either field counts as a
match). Cascading children are filtered independently — a child matching `--value` is retained
under its parent (and the parent itself is retained as context) even if the parent's own label
does not match; a parent matching `--value` retains ALL its children (no further filtering
within an already-matched parent's children). No server-side filtering exists for any of the
three enumeration mechanisms (`allowedValues`/`validValues` are always returned in full) — the
filter is purely client-side, applied after the full fetch.

**Filtering against `Option<String>` fields (`id`/`label`) [ADDED 2026-08-26, F2 adversary-convergence round-4, F-1]**: per BC-X.14.001's ADR-0019 § Amendment F-B contract, `id` and `label` are `Option<String>` (a `None` entry is legal and NEVER dropped by the normalizer — EC-X.14.001-7). This filter treats a `None` field as simply NOT a match source — it is SKIPPED when testing the substring, never causing a panic and never itself causing the entry to be dropped. Consequence, spelled out precisely: (a) for a NON-EMPTY `--value` substring, an entry with exactly one of `id`/`label` as `None` can still match via its remaining `Some` field; an entry with BOTH `id: None` AND `label: None` has no candidate string to test at all, so it does NOT match a non-empty substring and is filtered out of the result — this is an ordinary substring MISS, not a violation of the never-drop invariant (that invariant governs the NORMALIZER's output, BC-X.14.001 EC-X.14.001-7, not this separate client-side filter's expected narrowing of genuinely non-matching entries); (b) for the EMPTY-STRING `--value ""` case specifically, see the identity-filter note below — it is a deliberate, unconditional special case that does NOT follow rule (a).
**Inputs**: `--value <substring>` (optional — **[CORRECTED 2026-08-26, A-M2]** "bare" here means
absence of `--value` specifically, NOT absence of a mode-selector context flag, which remains
MANDATORY per BC-X.14.001 Invariant 1 regardless of whether `--value` is supplied; when
`--value` is absent, all options are printed, e.g. `jr field options customfield_10084 --issue
FOO-1` with no `--value` — a full, valid invocation still requires one of `--type`,
`--request-type`, or `--issue`). **[ADDED 2026-08-26, B-LOW; RECONCILED WITH F-B's `Option<String>` MODEL 2026-08-26, F2
adversary-convergence round-4, F-1]** `--value ""` (an explicit empty
string) is the IDENTITY filter — it matches EVERY entry unconditionally, including an entry
with `id: None`/`label: None` (both fields absent), producing output IDENTICAL to `--value`
being absent entirely — never-drop is preserved through the filter for this specific case. This
is a deliberate special case, not a restatement of "every `Some(String)` contains the empty
substring": a degenerate `{id: None, label: None}` entry has no `Some` string for the general
substring-match rule (see the "Filtering against `Option<String>` fields" paragraph above) to
test at all, so under that general rule alone it would be — incorrectly — filtered out even for
an empty substring. `--value ""` is therefore implemented as an unconditional match (bypassing
the per-field `None`-is-not-a-match-source rule entirely when the substring itself is empty),
which is exactly what makes it equal to the absent-flag case for EVERY entry, degenerate ones
included. This is a reachable scripted invocation (e.g., a caller building the flag
programmatically from a possibly-empty variable) distinct from omitting the flag, and is
documented here so it is not mistaken for a "match nothing" filter.
**Outputs/Effects**: Filtered `Vec<FieldOption>`; an empty result (zero matches) is a valid
success (exit 0, empty table / `[]` JSON) — NOT an error, consistent with `jr`'s existing
empty-result convention (e.g., BC-X.12.002's `--search` empty-result behavior). **[ADDED
2026-08-26, B-LOW]** `--value`'s interaction with BC-X.14.004's graceful-degrade case (a field
with no enumerable `allowedValues`/`validValues` at all): the graceful-degrade hint STILL fires
when `--value` is also present — the filter applies AFTER the full fetch, and a field with zero
enumerable options produces an empty `Vec<FieldOption>` before the filter ever runs, so
`--value`'s presence or absence is immaterial to whether the degrade hint fires. `stdout` stays
`[]` in `--output json` mode either way (EC-X.14.004-2); the degrade hint's stderr text is
unaffected by `--value`.
**Errors**: None specific to this flag — filtering never fails; it can only narrow to zero.

**Verification Properties**:
- VP-580-007: `--value <substring>` client-side filter correctness. Realized as a pure filter
  function over a `Vec<FieldOption>` fixture plus unit/integration coverage: (a) match is
  case-insensitive and succeeds when EITHER `label` OR `id` contains the substring; (b) a child
  matching `--value` is retained under its parent AND the parent is retained as context even when
  the parent's own `label`/`id` does not match; (c) a parent that itself matches retains ALL its
  children unfiltered; (d) zero matches → empty result, exit 0, empty table / `[]` JSON — a valid
  success, never an error (BC-X.12.002 empty-result precedent); (e) `--value` absent → the full
  enumerated list is returned unchanged; (f) **[ADDED 2026-08-26, B-LOW]** `--value ""` (explicit
  empty string) produces the SAME output as `--value` absent (identity filter — every entry
  matches). The filter is a total function (never panics, never fails — it can only narrow).
  **[ADDED 2026-08-26, F2 adversary-convergence round-4, F-1 — FLAGGED FOR VERIFIER]** (g) a
  fixture entry with `id: None` (label present) matches on a non-empty `--value` substring
  contained in its `label` but is correctly excluded when the substring is contained in neither
  field; (h) a fixture entry with `label: None` (id present) matches symmetrically via `id`; (i)
  a fixture entry with BOTH `id: None` AND `label: None` is excluded from the result for any
  NON-EMPTY `--value` substring (no match source exists), but IS included (never dropped) when
  `--value` is `""` or absent — asserting the degenerate entry specifically, not merely a
  well-formed one, for cases (e)/(f) above.
- VP-580-011 **[NEW 2026-08-26, B-LOW]**: `--value` supplied
  alongside a field with no enumerable options still exits 0 with the graceful-degrade hint on
  stderr and `[]`/empty table on stdout, identical to the no-`--value` case (BC-X.14.004
  VP-580-005 companion).

**Trace**: issue #580 (`jr field options customfield_10084 --value "<option-value>"` AC);
BC-X.12.002 (empty-result-is-not-an-error precedent); BC-X.14.004 (graceful-degrade interaction)

[NEW 2026-08-25 issue #580 F2]

---

#### BC-X.14.003: Table output columns (ID, Label) with cascading indentation; `--output json` returns the normalized `{id, label, children}` array

> **(cycle-014, #861)** This BC's rendering contract is unchanged: `Option<String>::None` still
> renders `NULL_GLYPH` (`"—"`)/`"(unnamed)"` in table mode and `null` in JSON mode, per the
> "Degenerate-entry rendering" section below. What changed is upstream, in BC-X.14.001's
> normalizer: system-typed fields (`priority`, `resolution` (when present on the Create/Edit
> screen), `versions`, `fixVersions`, `components`, `security`, `issuetype`) now resolve to a
> real `Some(name)` label via the
> `value`-else-`name` fallback instead of falling through to `label: None`, so fewer rows reach
> this BC's degenerate case. No change to this BC's rendering code or VP-580-008.

**Confidence**: HIGH
**Subject**: Field option discovery — output shape (issue #580)
**Behavior**: Default table output (per `output::print_output` / `render_json` invariant, #526)
shows two columns: **ID**, **Label**. Cascading children are rendered as additional rows
indented under their parent (table mode only; JSON mode preserves the nested `children[]`
structure verbatim, no flattening). `--output json` returns a JSON array of the normalized
`FieldOption` shape: `[{id: "<str>", label: "<str>", children: [...]}, ...]`, pretty-printed
via `render_json` per the repo-wide JSON render invariant (#526) — `serde_json::to_string_pretty`
direct calls and compact `json!` Display printing are forbidden, matching every other `jr`
JSON path.
**Inputs**: `--output json` (optional flag, standard global flag).
**Outputs/Effects**: stdout table (default) or stdout JSON array (`--output json`); stderr is
empty on the ORDINARY success path but is NOT unconditionally empty on every exit-0 outcome —
BC-X.14.004's graceful-degrade case is an exit-0 success path that emits a hint line to stderr
(e.g. "no enumerable options — this field uses Assets"). This is **output-channel profile 2
(Read-only)**, per CLAUDE.md's five-profile taxonomy — stdout for data, stderr for hints/warnings
(the truncation-notice pattern used elsewhere, e.g. `issue list`/`sprint current`) — NOT profile
1 (Pure), which requires zero stderr output under any success outcome. `--output json` mode keeps
the hint on stderr rather than folding it into the JSON payload (EC-X.14.004-2), preserving
`stdout` as machine-parseable JSON in both the enumerable and graceful-degrade cases.
**Errors**: N/A (output-shape only; see BC-X.14.004 for error taxonomy and the graceful-degrade
hint contract).

**Degenerate-entry rendering (missing `id`/`label`) [ADDED 2026-08-26, ADR-0019 § Amendment F-B,
propagated by product-owner F2 adversary-convergence round-3]**: per BC-X.14.001's `FieldOption`
contract amendment (`id`/`label` now `Option<String>`) and EC-X.14.001-7's never-drop invariant, a
degenerate entry (missing `id` and/or `label`) is never omitted from either output mode — it
renders with an explicit placeholder instead:
- **Table mode, missing `id`** → the ID column renders `NULL_GLYPH` (`"—"`) — the SAME glyph and
  convention already established by `src/cli/issue/changelog.rs::NULL_GLYPH` and reused by
  `src/cli/user.rs`/`src/cli/requesttype.rs` for "this field is genuinely absent from the source
  data," not a new glyph invented for this command.
- **Table mode, missing `label`** → the Label column renders the literal string `"(unnamed)"`,
  deliberately distinct from `"—"` and from the sibling id's own rendering: an absent id is inert
  (nothing actionable), but an absent label still names a real, selectable option — a
  distinguishing placeholder keeps the row visibly present and signals "resolve this one via its
  id," rather than reading as blank/nothing-there. This is NEVER a fallback to the entry's `id`
  value (rejected — `id` may ALSO be missing on the same degenerate entry, so a conditional
  fallback would need a second-level fallback rule anyway; an unconditional literal is simpler to
  specify and test).
- **JSON mode** performs NO substitution for either field — `--output json` emits the raw
  `Option::None` as JSON `null` (`{"id": null, "label": "Some Label", "children": []}` /
  `{"id": "10042", "label": null, "children": []}` / `{"id": null, "label": null, "children":
  []}`), never `NULL_GLYPH`/`"(unnamed)"` — those two strings are table-mode-only presentation,
  not part of the machine-readable JSON contract. This preserves `--output json`'s
  scripted-consumer contract (a `.id`-keyed `jq` script sees a real `null`, not an ambiguous
  placeholder string it would need to special-case).
- The glyph substitution belongs to the render/output layer (wherever table formatting is
  composed), NOT to the pure normalizers (`normalize_from_allowed_values`/
  `normalize_from_valid_values`), which only ever produce `Option<String>` — the normalizers never
  see or emit `NULL_GLYPH`/`"(unnamed)"` themselves.

**Verification Properties**:
- VP-580-008: Output-shape correctness. (a) Default table output has exactly two columns
  **ID**, **Label**; cascading children render as additional rows indented under their parent
  (table mode only). (b) `--output json` returns a JSON array of the normalized `FieldOption`
  shape `[{id, label, children: [...]}, ...]` with the nested `children[]` structure preserved
  verbatim (no flattening), routed through `output::print_output` / `render_json` — asserting NO
  direct `serde_json::to_string_pretty` / compact `json!` Display call (JSON render invariant
  #526). (c) Read-only output-channel profile: stderr is empty on the ORDINARY enumeration
  success path (a `[]`/empty-filter-result table is still exit 0 with no stderr, per
  BC-X.14.002's empty-match convention), but is NOT asserted empty on the graceful-degrade
  success path — that path's stderr hint is covered separately by BC-X.14.004's VP-580-005.
  Realized as unit tests over the render fn plus an integration test capturing stdout/stderr
  separately for both the ordinary and graceful-degrade success outcomes. (d) **[ADDED
  2026-08-26, ADR-0019 § Amendment F-B]** Degenerate-entry rendering: a fixture `FieldOption`
  missing `id` renders `NULL_GLYPH` (`"—"`) in the table's ID column; a fixture missing `label`
  renders the literal `"(unnamed)"` in the Label column; `--output json` on both fixtures emits
  `null` for the missing field(s), never the table-mode placeholder strings. This sub-point is
  the render-layer counterpart to BC-X.14.001's VP-580-005 §2 strengthening (entry-count
  preservation + exact `None`→`null` shape live there; the table-string assertions live here).

**Trace**: issue #580; CLAUDE.md "JSON render invariant (#526)"; CLAUDE.md "Output channels"
Profile 2 (Read-only)

[NEW 2026-08-25 issue #580 F2]

---

#### BC-X.14.004: Error taxonomy — field not found, no enumerable options (graceful degrade), ambiguous name, context-flag mutual-exclusion violations

**Confidence**: HIGH
**Subject**: Field option discovery — error taxonomy (issue #580)
**Behavior**: This BC pins the exit-64 error taxonomy AND the graceful-degradation contract for
fields with no enumerable option set (per `.factory/research/field-dx-context-mechanism-2026-08-25.md`
§Q-B, "fields where allowedValues/validValues is NOT returned — degrade gracefully").

**Error taxonomy** (exit 64, zero mutating HTTP, before or in place of enumeration):
| Condition | Behavior | Source parallel |
|---|---|---|
| Zero mode selectors (`--type`/`--request-type`/`--issue` all absent) — this row also covers a BARE `--project` supplied with no mode selector at all (`--project` is never itself a mode selector, so that invocation still has zero of the three present) | Exit 64: "specify exactly one of --type, --request-type, --issue" | BC-X.14.001 Invariant 1 / ADR-0019 §1 |
| `--type` present with no resolvable project — neither an explicit `--project` flag nor a profile/config default (**[CORRECTED 2026-08-26, ADR-0019 § Amendment D1]** trigger widened from "no flag" to "no flag AND no default") | Exit 64, the incomplete-M2 error **[MESSAGE WIDENED 2026-08-26, F2 adversary-convergence round-3, F-LOW-1 — "--type requires --project" contradicted D1's own "no flag AND no default" trigger by naming only the flag as the fix]**: `"--type needs a resolvable project — pass --project <P> or configure a default"` | BC-X.14.001 Invariant 1 / ADR-0019 § Amendment (2026-08-26) D1 |
| Two or more mode selectors (`--type`/`--request-type`/`--issue`) supplied simultaneously | Exit 64, same message as the zero-mode-selector row, listing the conflicting flags | BC-X.14.001 Invariant 1 / ADR-0019 §1 |
| `--request-type` present with NO resolvable ambient project (no `--project` companion, no profile/config default) | Exit 64 via `require_service_desk`'s "project required" error, unchanged from `jr requesttype fields`'s own behavior on the same condition | BC-X.12.003 parallel / ADR-0019 §1 |
| `<field>` resolves to zero matches | Exit 64, hint naming `jr project fields` | EC-3.4.015-1 parallel |
| `<field>` is the empty string | Exit 64, `Field '' not found. The field name must not be empty.` — zero cache/HTTP (see BC-X.14.001 EC-X.14.001-15; added cycle-014 as a cross-reference; documents pre-existing behavior) | `src/cli/field.rs::resolve_field_id` |
| `<field>` resolves to multiple matches (ambiguous) | Exit 64 naming candidates + ids | EC-3.4.015-2 parallel |
| Resolved project (whether from an explicit `--project` companion or profile/config default) is non-JSM, supplied to the `--request-type` path | Exit 64 via `require_service_desk`, call-site-specific message (BC-X.8.004) | BC-X.12.003 parallel |
| Unknown/ambiguous `--request-type` value | Exit 64 via `partial_match` (BC-X.12.006) | BC-X.12.006 |
| M2 path (`--type <T> [--project <P>]`) **[BRACKETED 2026-08-26, F2 adversary-convergence round-5, LOW-1]**: `--type` value does not resolve to exactly one issue type for the resolved project (unknown name, or ambiguous case-insensitive match) | Exit 64 listing the project's valid issue type names, BEFORE `get_createmeta_fields` is called | BC-3.3.010 Step 3 / S-331 parallel |
| **[ADDED 2026-08-26, F2 adversary-convergence round-2, Pass2-F2]** `--project <P>` supplied but the project does NOT exist / is not accessible (404, not 401) — on M2 this surfaces from EITHER of the two createmeta-family calls `jr field options` reuses (`get_issue_types_for_project`'s own `GET .../createmeta/{project}/issuetypes` list call, or `get_createmeta_fields`'s per-issue-type fields call, whichever runs first and 404s/400s on the bad project key); on M3 this surfaces from `get_or_fetch_project_meta`'s own `GET /rest/api/3/project/{key}` call (the SAME project-existence GET already documented elsewhere for its 401 behavior — see BC-X.8.006/007 — this row covers its 404 outcome instead) | Exit 64, "project not found or not accessible" (actionable, names the supplied project key) | New — no direct predecessor; `jr field options` performs no client-side project-existence pre-check on either path, so this is a genuine, previously-undocumented HTTP-failure row, distinct from the "no resolvable project" (companion-absent) and "non-JSM project" (resolves, wrong type) rows above |
| `--issue <KEY>` not found (404) | Exit 64, "issue not found or not accessible" | EC-3.4.015-7 parallel |
| createmeta/editmeta/requesttype-fields HTTP failure (401/403/5xx) | Propagated via standard `JrError` auth/API hint | EC-3.4.015-6 parallel |
| **[ADDED 2026-08-26, F2 adversary-convergence round-3, O-3]** M2 path createmeta/enumeration-family HTTP 400 — distinct from the {401,403,5xx} row above AND the project-404 row above: the resolved project and `--type` name both resolved successfully (a valid `issueTypeId` was obtained), but the SAME `issueTypeId` is then rejected by a LATER createmeta-family call in the same invocation — e.g. the issue type is deleted/removed from the project's issue-type scheme in the window between `get_issue_types_for_project`'s name→id resolution and `get_createmeta_fields`'s own `GET .../createmeta/{project}/issuetypes/{issueTypeId}` call, or the resolved `issueTypeId` is otherwise malformed/rejected by that second call | Propagated via standard `JrError` API-error mapping (exit 1, NOT exit 64 — this is a genuine server-side 400 on an already-resolved identifier, not a `jr`-side pre-flight validation failure; contrast the 404 project-not-found row above, which IS a `jr`-produced exit-64 with actionable wording) | New — no direct predecessor; distinguishes a mid-invocation TOCTOU-style resource removal from both the up-front project-404 case and the generic HTTP-failure row, since this row's precondition is that TWO EARLIER calls in the SAME invocation already succeeded against the SAME identifiers |
| `<field>` resolves in the global `GET /field` list (or via `customfield_NNNNN` bypass) but is ABSENT from the selected context's field set | Exit 64, "field not available in this context" — per-context wording: "is not on the Create screen" (M2/createmeta), "is not on the Edit screen" (M1/editmeta), "is not a field on this request type" (M3/requesttype-fields) | BC-3.3.010 EC-3.3.010-2 parallel; see EC-X.14.001-5 |

**Precedence when an invocation matches more than one taxonomy-table condition**: mode-selector
arity (zero, or two-or-more, of `{--type, --request-type, --issue}`) is evaluated FIRST, before
any `--project` companion-role validation — e.g. `--project <P> --request-type <RT> --type <T>`
(all three flags present) is reported via the "two or more mode selectors" row, not any
`--project` companion check. Once exactly one mode selector is confirmed present, `--project`'s
companion role is validated against THAT mode only: for M2, a resolvable project is REQUIRED
in the sense that "a project must be resolvable" (`--type` with no resolvable project — neither
an explicit `--project` flag NOR a profile/config default — → the incomplete-M2 error;
**[CORRECTED 2026-08-26, ADR-0019 § Amendment D1]** this is evaluated by a separate,
post-arity, M2-only resolution step, not by the pure mode-selector arity function itself — see
BC-X.14.001's "M2 project resolution step" paragraph and VP-580-006), OPTIONAL for M3
(`--request-type` with or without
`--project` is valid; when `--project` is absent on M3, resolution falls through to the ambient
profile/config-default project, which may itself fail via `require_service_desk`'s "project
required" error if no project resolves at all — a DISTINCT, LATER failure from the
mode-selector-arity rows), and inapplicable for M1 (`--issue` supplies project context on its
own, no `--project` companion is consulted). Exit code is 64 for every taxonomy-table row; this
paragraph pins evaluation ORDER only, so a caller fixing one reported error deterministically
encounters the next-in-order error on a following attempt, never a silent flip between two error
messages for the same invocation. **Note the reversal from an earlier revision of this
paragraph (adversary pass-20 M1, ADR-0019 §1):** `--project <P> --request-type <RT>` (no
`--type`) is now a VALID M3 invocation with an explicit service-desk project — it is NOT
reported via any taxonomy-table error row.

**Graceful degradation (NOT an error — exit 0)**: when the resolved field's `allowedValues`
(M1/M2) or `validValues` (M3) is absent or empty, `jr field options` does NOT error. It inspects
`schema.custom` (M1/M2) or `jiraSchema` (M3) and prints:
- For Assets/CMDB object fields (`schema.custom` = `com.atlassian.jira.plugins.cmdb:cmdb-object-cftype`)
  or Affected-services fields: a "no enumerable options — this field uses Assets" hint pointing
  to `jr assets search` (consistent with BC-3.4.030's Assets-field posture on the write side).
- For user-picker/multi-user-picker/Approvers/labels/other suggestion-backed fields: a "no
  enumerable options (dynamic/lookup field)" hint plus the field's `autoCompleteUrl` if present
  in the response.
- For free-text/number/date/datetime and any other field with no finite option set: a "no
  enumerable options (this field type has no fixed value set)" hint, no `autoCompleteUrl`.
- **M3-specific note**: JSM Assets/Affected-services fields return `validValues: []`
  unconditionally (JSDCLOUD-15551, an Atlassian-side gap, not a `jr` limitation) — `jr` treats
  this identically to the Assets-field degrade case above, not as a "field has zero configured
  options" misconfiguration message (EC-X.14.004-1 distinguishes the two).

**Postconditions**:
- Every taxonomy-table error emits exit 64 (or the standard `JrError` HTTP-failure mapping)
  BEFORE the enumeration HTTP call, or in the createmeta/editmeta/requesttype-fields call's own
  failure path.
- Every graceful-degrade case emits exit 0 with the appropriate hint — NEVER a stack trace,
  panic, or exit-64 "field has no configured option values" message (that message, from
  BC-3.4.016 EC-3.4.016-1, is the WRITE-path posture on an editmeta-driven `--field` value
  resolution failure — this READ-path discovery command's posture is deliberately more
  permissive, since printing "no options" is informative, not a resolution failure to reject).
- `--output json` mode: every genuine exit-64 error taxonomy-table row above emits the SAME
  `{"error": "...", "code": 64}` envelope shape as every other `jr` pre-flight/resolution error
  — written to stderr, not stdout (consistent with BC-3.3.011's Output/Errors convention for the
  parallel write-path `--field` taxonomy). This applies to genuine errors only — the
  graceful-degrade case above is exit 0 and therefore never emits this envelope; its stdout
  payload is `[]` per EC-X.14.004-2, with the hint text on stderr as plain text, not JSON.

**Edge Cases**:
- EC-X.14.004-1: Assets/CMDB field via the M3 (`--request-type`) path → `validValues: []`
  (JSDCLOUD-15551) → graceful-degrade Assets hint, NOT the generic "no fixed value set" hint —
  `jr` distinguishes by inspecting `jiraSchema.custom`/`jiraSchema.system` for the CMDB type
  string even though `validValues` is empty either way.
- EC-X.14.004-2: `--output json` mode graceful-degrade → returns `[]` (empty array), with the
  hint text emitted to STDERR (not stdout, per the Pure/Read-only channel distinction — JSON
  stdout stays parseable; the hint is a stderr convenience for human operators redirecting
  stdout to `jq`).
- EC-X.14.004-3: `<field>` resolves globally but is absent from the selected context's field set
  (global-existence-vs-screen-membership taxonomy row above) → exit 64 BEFORE any enumeration is
  attempted (the createmeta/editmeta/requesttype-fields response is inspected for field presence
  before `allowedValues`/`validValues` is read) — this is a DISTINCT failure from the
  graceful-degrade case above: graceful-degrade fires when the field IS present in the selected
  context but has no enumerable option set (exit 0); this edge case fires when the field is not
  present in the selected context at all (exit 64). The two must not be conflated — a caller
  fixing this exit-64 error by re-running against a different `--project`/`--type`, `--issue`, or
  `--request-type` context where the field IS configured may then encounter the graceful-degrade
  exit-0 path instead, for a field type with no fixed value set.
- EC-X.14.004-4: M2 path (`--type <T> [--project <P>]`) **[BRACKETED 2026-08-26, F2 adversary-convergence round-5, LOW-1]**, `--type` names an unknown or ambiguous
  issue type for the resolved project → `get_issue_types_for_project` resolution fails BEFORE
  `<field>` resolution and BEFORE `get_createmeta_fields` — exit 64 listing valid issue types
  (see taxonomy table row above). This is a DISTINCT, EARLIER failure than EC-X.14.001-5
  (field-absent-from-context) — that edge case presumes `--type` already resolved successfully
  and the createmeta call already ran; this one fires before either happens.
- EC-X.14.004-5: `jr field options <field> --request-type <RT>` with NO resolvable ambient
  project (no `--project` companion flag, no profile/config default project) → the existing
  `require_service_desk` "project required" error (exit 64), unchanged from `jr requesttype
  fields`'s own behavior on the same condition (BC-X.12.003 parallel). This is a companion-
  resolution failure, distinct from both the mode-selector arity errors (zero/two-or-more mode
  selectors, or EC-X.14.004-4's M2 `--type`/`--project` case) and the non-JSM-project taxonomy
  row (which fires when a project DOES resolve but is the wrong project type) — here no project
  resolves at all, so `require_service_desk` is never reached with a candidate project key.
- EC-X.14.004-6 **[ADDED 2026-08-26, F2 adversary-convergence round-2, Pass2-F2]**: `--project
  NONEXISTENT --type <T>` (M2) or `--project NONEXISTENT --request-type <RT>` (M3), where
  `NONEXISTENT` names a project key that does not exist / is not accessible to the caller → exit
  64, "project not found or not accessible", from the taxonomy-table row added above. Distinct
  from THREE other project-related rows in this same taxonomy, each firing at a different point
  and for a different reason: (a) EC-X.14.004-4's M2 unknown-`--type`-for-a-VALID-project case
  (here the project itself does not resolve at all — this fires strictly EARLIER, before any
  issue-type name resolution is attempted, on M2); (b) the "no resolvable project" companion-
  absent row / EC-X.14.004-5 (there NO `--project` value and no profile/config default was ever
  supplied at all — a client-side, pre-HTTP arity failure; here a `--project` value WAS supplied
  and IS syntactically present, it simply does not resolve to a real project server-side — a
  genuine HTTP 404, not a pre-HTTP check); (c) the non-JSM-project row (there the project DOES
  exist and DOES resolve, just to the wrong project type). `jr field options` performs no
  client-side existence pre-check on either M2 or M3 — this is a first-class HTTP-failure
  outcome, not a resolution-shape failure, mirroring how `--issue <KEY>` not found (the row
  immediately below) is a first-class HTTP-failure outcome for M1.
- EC-X.14.004-7 **[ADDED 2026-08-26, F2 adversary-convergence round-3, O-3]**: `jr field options
  <field> --type <T> --project <P>` where `--type` resolves cleanly to an `issueTypeId` (the
  `get_issue_types_for_project` name→id call succeeds), but the SUBSEQUENT
  `get_createmeta_fields` call against that same `issueTypeId` returns HTTP 400 — e.g. the issue
  type was removed from the project's issue-type scheme between the two calls, or the resolved id
  is otherwise rejected. Distinct from EC-X.14.004-4 (unknown/ambiguous `--type` NAME, caught by
  the FIRST call, before any `issueTypeId` exists to pass to the second) and from EC-X.14.004-6
  (the PROJECT itself 404s, not the issue type) — this edge case's precondition is that BOTH
  earlier lookups already succeeded against the same identifiers, so the failure is a genuine
  server-side rejection propagated as a standard `JrError` (exit 1), not a `jr`-produced
  exit-64.

**Verification Properties**:
- VP-580-004: Each row of the error taxonomy table is independently exercised, asserting exit
  64, zero mutating HTTP, and the documented message shape. This includes a dedicated case for
  a BARE `--project` supplied with no mode selector at all: it asserts the zero-mode-selector
  message ("specify exactly one of --type, --request-type, --issue"), NOT the incomplete-M2
  message (**[MESSAGE WIDENED 2026-08-26, F2 adversary-convergence round-3, F-LOW-1]** "--type
  needs a resolvable project — pass --project <P> or configure a default") — a regression guard for the doubly-specified,
  self-contradictory routing found in adversary pass-25 (HIGH), fixed via Option A
  (canonicalized as the zero-mode-selector case, consistent with `resolve_field_context`'s
  3-boolean arity signature — VP-580-006, per ADR-0019 § Amendment D1 — which does not take
  `has_project` as a parameter at all). This includes the M2 `--type`
  name→id resolution row (EC-X.14.004-4): unknown/ambiguous `--type` for the resolved project
  exits 64 listing valid issue types, with `get_createmeta_fields` never called; and the M3
  no-resolvable-project row (EC-X.14.004-5): `--request-type` with no `--project` and no
  profile/config default exits 64 via `require_service_desk`, exercised through `jr field
  options`'s own dispatch (not merely inherited from `jr requesttype fields`'s existing
  coverage) — asserting the M3 mode reaches the same companion-resolution code path.
- VP-580-005: Each graceful-degrade sub-case (Assets, user-picker, free-text) exits 0 with the
  correct hint variant and an empty (not error) options list.
- VP-580-009: `--project --request-type` together resolves as a VALID M3 invocation (explicit
  service-desk project, zero errors attributable to the flag pairing) — a regression guard
  against re-introducing the superseded "pairing error" behavior (adversary pass-20 M1,
  ADR-0019 §1).
- VP-580-012: `--project` not found (404) on the M2 (`get_issue_types_for_project`/
  `get_createmeta_fields`) and M3 (`get_or_fetch_project_meta`) enumeration paths exits 64 with
  zero mutating HTTP and the message "project not found or not accessible"; pairs with the new
  EC-X.14.004-6 taxonomy row.

**Trace**: issue #580; `.factory/research/field-dx-context-mechanism-2026-08-25.md` §Q-B
(graceful-degradation rule, field-type enumeration); ADR-0019 §1 (context-mechanism arity
model — mode-selector/companion correction, adversary pass-20 M1); BC-3.4.016 EC-3.4.016-1
(contrasted write-path posture); BC-X.8.004 (`require_service_desk` call-site label convention);
BC-X.12.003 (`--project` companion resolution via `require_service_desk`/
`get_or_fetch_project_meta`, mirrored on the M3 path); BC-X.12.006 (`partial_match`
disambiguation convention)

[NEW 2026-08-25 issue #580 F2]

---

## BC-X.15: OAuth Agile-Command Error-Mapping

1 behavioral contract covering the Agile-command (`jr board`/`jr sprint`) 401 error-taxonomy fix
(ADR-0026 Decision 3, cycle-008 `oauth-surface-correctness`, VP-OAUTH-GW-003). Sized and filed as
a Cross-Cutting subsection, mirroring the `jr requesttype`/Field-Option-Discovery precedent
(BC-X.12/BC-X.14), rather than a new numbered domain-spec section file — the fix is a general
401-disambiguation call-site-rewrite pattern (the same one `require_service_desk` already
established for JSM, BC-X.8.006/BC-X.8.007), not a new Agile domain behavior, so it belongs beside
its sibling error-mapping contracts rather than inside `bc-5-boards-sprints.md`'s board/sprint
command-behavior taxonomy.

**Why this BC exists (context):** `jr board`/`jr sprint` today contain ZERO scope/
`InsufficientScope`-handling code (confirmed by grep, cycle-008 F1 code audit) — a 401 on either
command family falls straight through to `src/error.rs`'s generic, unconditional, POST-framed
`InsufficientScope` Display template, which is correct for the ONE call site it was originally
written for (`src/cli/issue/jsm_create.rs`'s JSM-create POST path, BC-3.8.015) but is misleading
noise for an Agile GET scope-mismatch or an expired-token 401. ADR-0026 Decision 3 establishes
that 401 ambiguity is always resolved by a call-site rewrite close to the failing operation, never
by widening the shared Display template to cover every caller.

#### BC-X.15.001: `jr board`/`jr sprint`/`jr issue list`/`jr init` 401 disambiguates OAuth scope-mismatch, expired/invalid token, and (regression-guard only) wrong-host — auth-scheme-conditional call-site rewrite modeled on `require_service_desk`

**STATUS: NEW (2026-09-17, cycle-008 `oauth-surface-correctness`, ADR-0026 Decision 3, VP-OAUTH-GW-003); UPDATED same-day (2026-09-17, F1 human ruling) — coverage clarified/widened to explicitly include internal board/sprint resolution helpers, not only the 4 originally-named top-level command handlers; call-site count grows, BC id and total BC count are unchanged (call-site-only widening of an already-approved BC, not a new contract); FURTHER UPDATED same-day (2026-09-17, wave-level finding F-WG-1, human ruling = EXPAND) — coverage widened a second time, BEYOND the original `jr board`/`jr sprint` boundary, to also cover the same Agile HTTP calls made by `jr issue list`'s board-resolution path and `jr init`'s board-selection prompt; again BC id and total BC count are unchanged (a further call-site coverage widening, not a new contract)**

**Confidence**: HIGH
**Subject**: X.15 OAuth Agile-Command Error-Mapping (new call-site rewrite — `jr board`/`jr sprint`,
widened by F-WG-1 to `jr issue list`/`jr init`)
**Description**: `jr board`/`jr sprint` handlers gain a new, narrowly-scoped 401 call-site rewrite
(function names are the implementer's choice at F4, modeled on
`src/api/jsm/servicedesks.rs::require_service_desk`'s auth-scheme-conditional rewrite pattern)
that disambiguates a received 401 into exactly one of three classes before choosing (or declining)
to rewrite the error the user sees.

**Behavior**: For a 401 response received by a `jr board`/`jr sprint` command handler — and, per the
**[UPDATED 2026-09-17, wave-level finding F-WG-1, human ruling = EXPAND]** widening below, by ANY
Agile HTTP call reachable from `jr board`, `jr sprint`, `jr issue list` (its board-resolution/
board-based-JQL path), or `jr init` (its board-selection prompt) — regardless of which top-level
command family issued the call:

1. **Genuine OAuth scope-mismatch (in scope for this BC's rewrite):** when the active auth scheme
   is OAuth/Bearer (`client.is_oauth_auth() == true`) AND the 401 body carries the scope-mismatch
   signal (case-insensitive `"scope does not match"` substring, the SAME detection rule BC-X.3.005/
   BC-1.6.044 already use), the call site rewrites the error to `JrError::NotAuthenticated { hint }`
   (NOT `InsufficientScope` — the `InsufficientScope` Display is purpose-built for the
   issue-#185/BC-3.8.015 POST scenario and produces irrelevant POST-specific noise on a GET) with a
   hint naming the missing granular Jira-Software scope(s) for the failing command family, and
   directing the user to `jr auth login` to re-consent (mirroring BC-X.8.007's "`jr auth refresh`
   alone cannot add missing scopes" framing). All scopes named in the hint are members of
   `DEFAULT_OAUTH_SCOPES` as amended by BC-1.3.023 (ADR-0026 Decision 2), so the hint is genuinely
   actionable for default-scoped users.

   **[UPDATED 2026-09-17, cycle-008 F1 (human ruling), scope widened]** This coverage applies to
   **every** Agile HTTP call reachable within a `jr board`/`jr sprint` invocation — not only the
   outermost command handler's own HTTP call. `jr board`/`jr sprint` both delegate to internal
   board/sprint resolution helpers that themselves issue Agile HTTP calls before the command's
   "primary" call ever runs; each of those internal calls gets its own independent 401 rewrite,
   applied at the point of the failing HTTP call (per ADR-0026 Decision 3's "close to the failing
   operation" principle), not just at the top-level handler. The full call-site → hint mapping:
   - `src/cli/board.rs::handle_list` → `list_boards` → `read:board-scope:jira-software` +
     `read:project:jira`
   - `src/cli/board.rs::resolve_board_id` (internal board-resolution helper; shared by `board
     view`'s auto-discovery path AND `sprint.rs::resolve_scrum_board`) → `list_boards` →
     `read:board-scope:jira-software` + `read:project:jira` (same hint as `jr board list` — it is
     the same underlying HTTP call, reached transitively)
   - `src/cli/board.rs::handle_view` (unconditional call, BOTH the kanban and scrum branches) →
     `get_board_config` → `read:board-scope.admin:jira-software` and `read:project:jira`
   - `src/cli/board.rs::handle_view` scrum branch → `list_sprints` + `get_sprint_issues` →
     `read:sprint:jira-software` + `read:issue-details:jira` + `read:jql:jira` (same grouped hint
     as `jr sprint list`/`jr sprint current` — it is the same underlying pair of HTTP calls)
   - `src/cli/sprint.rs::resolve_scrum_board` (internal helper; shared by `sprint list`/`current`/
     `add`/`remove`) → `get_board_config` → `read:board-scope.admin:jira-software` and
     `read:project:jira`
   - `src/cli/sprint.rs::handle_list` (`jr sprint list`) → `list_sprints` →
     `read:sprint:jira-software` + `read:issue-details:jira` + `read:jql:jira`
   - `src/cli/sprint.rs::handle_current` (`jr sprint current`) → `list_sprints` +
     `get_sprint_issues` → same grouped hint as above
   - `src/cli/sprint.rs::SprintCommand::Add { current: true, .. }` (internal "resolve the active
     sprint id" `list_sprints` lookup, distinct from `resolve_scrum_board`'s own preceding
     `get_board_config` call in the same command) → same grouped sprint-scope hint
     (`read:sprint:jira-software` + `read:issue-details:jira` + `read:jql:jira`), for consistency
     with every other `list_sprints` call site (see EC-X.15.001-4 rationale below)
   - `src/cli/sprint.rs::handle_add` / `handle_remove` → `add_issues_to_sprint` /
     `move_issues_to_backlog` → `write:board-scope:jira-software` (unchanged from the
     originally-named 4-handler scope)

   **[NEW 2026-09-17, wave-level finding F-WG-1, human ruling = EXPAND]** The following 3 call
   sites, in command families OUTSIDE `jr board`/`jr sprint` entirely, are added to this mapping.
   They make the SAME underlying Agile HTTP calls this BC already covers, so they reuse the
   identical hints — no new scope strings, no new detection rule, no new rewrite mechanism:
   - `src/cli/issue/list.rs::handle_list` (its board-resolution/board-based-JQL path, reached when
     `--jql` is absent and a `board_id` is configured) → `get_board_config` →
     `read:board-scope.admin:jira-software` and `read:project:jira` (same hint as `jr board view`/
     `resolve_scrum_board`, matrix #53)
   - `src/cli/issue/list.rs::handle_list`, same board-resolution path, when the resolved board is
     scrum-type → `list_sprints` → `read:sprint:jira-software` + `read:issue-details:jira` +
     `read:jql:jira` (same grouped hint as `jr sprint list`/`current`, reused per EC-X.15.001-4's
     "same hint at every `list_sprints` call site" ruling)
   - `src/cli/init.rs::handle` (the interactive per-project setup prompt's board-selection step) →
     `list_boards` → `read:board-scope:jira-software` and `read:project:jira` (same hint as `jr
     board list`/`resolve_board_id`, matrix #52)

   These 3 sites were not part of the original ADR-0026 Decision 3 audit scope (which named only
   `jr board`/`jr sprint`) nor of the F1 same-day internal-helper widening above (which stayed
   within those same two command families); F-WG-1 extends the boundary to every Agile HTTP call
   this codebase makes, regardless of which top-level command reaches it.

   A single command invocation may therefore pass through more than one of these rewrite points
   before it either succeeds or fails — e.g. `jr sprint list` first resolves its board via
   `resolve_board_id` (board+project-scope hint on failure) and `resolve_scrum_board`'s own
   `get_board_config` check (admin-scope hint on failure) before ever reaching `handle_list`'s own
   `list_sprints` call (sprint-scope hint on failure). Each rewrite point is independent and
   evaluates only the 401 it directly observes.
2. **Expired/invalid token (out of scope for this BC's rewrite — existing behavior preserved):**
   a 401 whose body carries Atlassian's generic expired/invalid-token shape (no scope-mismatch
   substring) is left to the existing auto-refresh coordinator (`src/api/refresh_coordinator.rs`)
   exactly as it does today for every other OAuth-authenticated command family. This BC's rewrite
   MUST NOT intercept this class — it must fall through unchanged, so that expired-token recovery
   (silent refresh-and-retry) keeps working for `jr board`/`jr sprint` exactly as it already does
   elsewhere in the codebase.
3. **Wrong-host-401 (regression-guard only, not new behavior this BC introduces):** the routing
   defect ADR-0026 Decision 1 fixes (BC-4.2.001) — a 401 caused by addressing `instance_url`
   instead of `base_url` under OAuth. `jr board`/`jr sprint` were never among the 7 corrected
   routing call sites (both already used `client.get(...)`/`base_url` correctly, per F1 code
   audit — their 401 was always a scope problem, never a routing problem), so this class should
   never be OBSERVED at these two call sites, pre- or post-ADR-0026. This BC does not add any code
   to detect or handle this class; it exists purely as a documented regression-guard boundary so
   a future reader is not misled into thinking `jr board`/`jr sprint`'s 401 was ever a routing bug.
4. **Basic/API-token auth:** unaffected by this BC — `is_oauth_auth() == false` short-circuits the
   new rewrite entirely, so `src/cli/board.rs`/`src/cli/sprint.rs` never route a Basic-auth 401
   through it. What that unaffected 401 surfaces as depends on the body, per `client.rs`'s
   PRE-EXISTING, auth-scheme-agnostic `send_inner` pre-refresh scope check, which runs BEFORE the
   auth-scheme guard and is frozen by this BC (AC-007), not introduced by it: (a) a Basic-auth 401
   body WITHOUT a scope-mismatch substring continues to surface via the universal BC-X.3.002
   (`Not authenticated` + `jr auth login`, exit 2) path, unchanged; (b) a Basic-auth 401 body WITH
   a scope-mismatch substring surfaces the generic `InsufficientScope` (issue #185) template — NOT
   the BC-X.3.002 path — because `send_inner`'s pre-refresh scope check fires regardless of auth
   scheme and this BC's rewrite (Basic-auth short-circuited) never gets a chance to rephrase it.

**Explicitly NOT changed by this BC:**
- `src/error.rs`'s `JrError::InsufficientScope` Display template and its two construction sites
  (`src/api/client.rs::send_inner`'s pre-refresh 401 check, `parse_error`'s post-401 fallback) —
  BC-1.6.042/043/044/045 remain byte-for-byte correct and unamended; this BC's rewrite operates
  on the `JrError` variant AFTER those construction sites produce it, exactly like
  `require_service_desk` already does for JSM.
- BC-3.8.015 (the JSM-create POST path's OAuth `InsufficientScope` arm) — genuinely the
  issue-#185 POST scenario, unaffected by this additive, Agile-command-scoped rewrite.
- `src/cli/board.rs`/`src/cli/sprint.rs`'s existing non-401 behavior, payload shapes, and
  successful-response handling — this BC is additive at the 401 branch only.

**Edge Cases**:
- **EC-X.15.001-1**: A 401 with BOTH a scope-mismatch substring AND an expired-token substring in
  the same body (a hypothetical malformed/composite Atlassian error body) → the scope-mismatch
  substring check wins (same precedence BC-X.3.005 already establishes for the generic detection
  rule this BC's call site reuses) — the rewrite fires, producing the scope hint, not the
  auto-refresh path.
- **EC-X.15.001-2**: `jr board`/`jr sprint` under an OAuth profile whose token is BOTH expired AND
  missing a granular scope — the auto-refresh coordinator's own retry-after-refresh 401 is what
  this call site ultimately observes; if that retry's 401 body still carries the scope-mismatch
  substring, Class 1 (scope-mismatch rewrite) fires on the POST-refresh attempt, not the
  pre-refresh one.
- **EC-X.15.001-3**: A 401 with neither substring (an unrecognized/malformed body) → falls through
  to the universal BC-X.3.002 `Not authenticated` path, unchanged — this BC's rewrite only
  narrows the scope-mismatch sub-case, it does not broaden 401 handling for unrecognized bodies.
- **EC-X.15.001-4** (**[NEW 2026-09-17, cycle-008 F4 human ruling]**): `jr sprint list`'s grouped
  hint names `read:sprint:jira-software` + `read:issue-details:jira` + `read:jql:jira`, even though
  `handle_list` itself only calls `list_sprints` (which alone would only need
  `read:sprint:jira-software` — the other two scopes back `get_sprint_issues`, called by `jr sprint
  current`, not `jr sprint list`). RULING: KEEP the grouped hint as spec-conformant. `jr sprint
  list` and `jr sprint current` share one rewrite/hint for simplicity, and over-inclusion in a
  scope hint is benign — re-consenting to a superset of the actually-missing scope still fixes the
  reported problem, it just asks for slightly more than the strict minimum. This same grouped hint
  is reused verbatim at every other `list_sprints` call site introduced by this widening (`board.rs`'s
  scrum branch of `handle_view`, and `sprint.rs`'s `SprintCommand::Add { current: true, .. }`
  resolution lookup) for the same reason — one consistent sprint-scope hint string is simpler to
  maintain and test than deriving a minimal-but-different hint per call site, and the over-inclusion
  cost is identical (benign). Not re-litigated; do not narrow this hint without a new human ruling.

**Canonical Test Vectors**:

| Command / internal call site | Auth scheme | 401 body signal | Expected outcome |
|---|---|---|---|
| `jr board list` (`handle_list` → `list_boards`) | OAuth/Bearer | `"scope does not match"` (case-insensitive) | exit 2; stderr `NotAuthenticated` hint names `read:board-scope:jira-software`/`read:project:jira`; does NOT contain the generic POST-framed `InsufficientScope` template text |
| `jr board view` / `jr sprint list` (`resolve_board_id` → `list_boards`, auto-discovery path) | OAuth/Bearer | `"scope does not match"` | exit 2; same hint as `jr board list` (same underlying call, reached internally) |
| `jr board view` (`handle_view` → `get_board_config`, unconditional, both kanban/scrum branches) | OAuth/Bearer | `"scope does not match"` | exit 2; stderr hint names `read:board-scope.admin:jira-software` and `read:project:jira` |
| `jr sprint list`/`current`/`add`/`remove` (`resolve_scrum_board` → `get_board_config`) | OAuth/Bearer | `"scope does not match"` | exit 2; stderr hint names `read:board-scope.admin:jira-software` and `read:project:jira` |
| `jr sprint list` | OAuth/Bearer | `"scope does not match"` (case-insensitive) | exit 2; stderr hint names `read:sprint:jira-software`/`read:issue-details:jira`/`read:jql:jira` (EC-X.15.001-4: grouped, over-inclusive-by-design) |
| `jr board view` scrum branch (`list_sprints` + `get_sprint_issues`) / `jr sprint current` | OAuth/Bearer | `"scope does not match"` | exit 2; same grouped hint as `jr sprint list` |
| `jr sprint add --current` (internal active-sprint `list_sprints` lookup) | OAuth/Bearer | `"scope does not match"` | exit 2; same grouped sprint-scope hint (EC-X.15.001-4) — distinct from `resolve_scrum_board`'s earlier `get_board_config` admin-scope hint in the same command invocation |
| `jr board list` | OAuth/Bearer | generic expired-token body (no scope substring) | routes to auto-refresh coordinator; no `InsufficientScope`/scope hint surfaced |
| `jr board list` | Basic/API-token | any 401 body | exit 2; universal BC-X.3.002 `Not authenticated` + `jr auth login`; NO OAuth-scope language |
| `jr issue create --request-type ...` (regression guard) | OAuth/Bearer | JSM POST scope-mismatch (BC-3.8.015 fixture) | UNCHANGED byte-for-byte — this BC's rewrite does not touch `jsm_create.rs`'s call site |
| **[NEW, F-WG-1]** `jr issue list` (`handle_list` → `get_board_config`, board-resolution path, `board_id` configured, no `--jql`) | OAuth/Bearer | `"scope does not match"` | exit 2; stderr hint names `read:board-scope.admin:jira-software` and `read:project:jira` — same hint as `jr board view` |
| **[NEW, F-WG-1]** `jr issue list` (`handle_list` → `list_sprints`, scrum board resolved) | OAuth/Bearer | `"scope does not match"` | exit 2; same grouped hint as `jr sprint list` (`read:sprint:jira-software`/`read:issue-details:jira`/`read:jql:jira`) |
| **[NEW, F-WG-1]** `jr init` (`handle` → `list_boards`, per-project board-selection prompt) | OAuth/Bearer | `"scope does not match"` | exit 2; same hint as `jr board list` (`read:board-scope:jira-software`/`read:project:jira`) |

**Verification Properties**: VP-OAUTH-GW-003 — wiremock integration tests mocking a 401 response
body under both classes (i) scope-mismatch and (ii) expired-token, covering EVERY call site listed
in Behavior clause 1's mapping above — not only the originally-named 4 top-level command handlers,
but also the internal `resolve_board_id` (`board.rs`), `resolve_scrum_board` (`sprint.rs`),
`handle_view`'s unconditional `get_board_config` call, and `SprintCommand::Add { current: true }`'s
`list_sprints` lookup (**[UPDATED 2026-09-17, cycle-008 F1 human ruling, scope widened]** — minimum
8 new test cases: covering both classes across the internal-resolution call sites in addition to
the 4 original top-level handlers), asserting the rendered error message/exit code for each; plus a
REGRESSION assertion that `jsm_create.rs`'s existing call site message is UNCHANGED byte-for-byte
(BC-3.8.015) — this VP's rewrite is additive only. **[UPDATED 2026-09-17, wave-level finding
F-WG-1, human ruling = EXPAND]** minimum new-test-case count raised 8→11 (+3): one scope-mismatch
test per newly-covered call site (`src/cli/issue/list.rs::handle_list`'s `get_board_config` call,
its `list_sprints` call, and `src/cli/init.rs::handle`'s `list_boards` call) — the expired-token
fall-through and Basic-auth short-circuit classes are already proven generically by AC-002/AC-004's
existing sibling coverage and are not re-derived per call site for these 3 additions.

**Related BCs**:
- BC-4.2.001 (`bc-4-assets-cmdb.md`) — Class 3's regression-guard boundary; the routing invariant
  whose absence-of-defect at these two call sites this BC documents rather than fixes.
- BC-1.3.023 (`bc-1-auth-identity.md`) — the granular-scope set this BC's Class 1 hint names;
  makes the hint genuinely actionable via `jr auth login`.
- BC-5.1.001 (`bc-5-boards-sprints.md`) — receives a cross-reference note (see that BC) pointing
  back here, since its own routing-correct GET is the one that currently 401s under OAuth for the
  scope reason this BC's rewrite now surfaces correctly.
- BC-X.8.006 / BC-X.8.007 (`require_service_desk`'s auth-scheme-conditional 401 rewrite, this
  file) — the proven pattern this BC's rewrite is modeled on; depends on, does not supersede.
- BC-1.6.042 / BC-1.6.043 / BC-1.6.044 / BC-1.6.045 (`bc-1-auth-identity.md`) — the generic
  `InsufficientScope` detection/Display rules this BC's rewrite consumes and re-maps, unchanged.
- BC-3.8.015 (`bc-3-issue-write.md`) — the one existing caller for whom the generic
  `InsufficientScope` template is genuinely correct; explicitly unaffected (regression-guarded).

**Capability anchor**: this repository's BC corpus has no `domain-spec/capabilities.md` CAP-NNN
registry to anchor against (confirmed absent — this is a brownfield spec corpus using
Confidence/Source/Subject/Behavior/Trace fields, not the CAP-NNN capability-anchor convention);
this BC instead anchors to ADR-0026 Decision 3 and the established `require_service_desk`
error-mapping precedent (BC-X.8.006/BC-X.8.007) as its source of truth, per this file's own
citation convention.

**Trace**: cycle-008 `oauth-surface-correctness` F2 spec evolution (2026-09-17); ADR-0026 Decision
3; `.factory/cycles/cycle-008/F1-delta-analysis.md` §2.5 (Workstream E root-cause), §3 (BC
disposition — NEW BC recommendation); `.factory/cycles/cycle-008/verification-delta.md`
§VP-OAUTH-GW-003; modeled on BC-X.8.006/BC-X.8.007 (this file, `require_service_desk`'s
auth-scheme-conditional 401 rewrite). Qualitative test coverage: new wiremock integration test
group in `tests/board_commands.rs`/`tests/sprint_commands.rs`, plus a regression case in
`tests/issue_create_jsm.rs` pinning BC-3.8.015's unchanged message. **[F-WG-1 addition]**
wave-level finding F-WG-1 (human-approved scope amendment, ruling = EXPAND, 2026-09-17) extends
this trace to `src/cli/issue/list.rs::handle_list` and `src/cli/init.rs::handle`; qualitative test
coverage for the 3 new call sites lands in `tests/issue_list.rs`/`tests/issue_commands.rs` and
`tests/init_commands.rs` (or wherever `jr init`'s existing test suite lives — confirmed by the
implementer at Task 1 of the amended story); `oauth-scope-matrix.md` #52/#53/#55-57 is the
authoritative hint-mapping source for all 3.

[NEW 2026-09-17 cycle-008 ADR-0026 Decision 3; WIDENED 2026-09-17 wave-level finding F-WG-1]

---

## BC-X.16: API Query Parameters

No `jr api` BC family existed for query-string composition before cycle-014 (issue #583).
`src/cli/api.rs::normalize_path` trims the raw path and, if it does not already start with `/`,
prepends one — it performs no query-assembly or percent-encoding of its own; the rest of the
path (including any `?query` the caller already typed) passes through verbatim. Filed as a
Cross-Cutting subsection per the BC-X.12/BC-X.14/BC-X.15 sizing precedent (a small,
self-contained new command-surface addition that does not warrant a new numbered domain-spec
section file). `url = "2"` and `urlencoding = "2"` are already direct dependencies
(`Cargo.toml`) — no new dependency is introduced by either BC below.

---

#### BC-X.16.001: `jr api <path> --query-param NAME=VALUE` (repeatable, `-q`) builds a percent-encoded query string and merges it with any `?` already present in `<path>`'s pre-fragment part; method-orthogonal, ordering-preserving for repeated names

**Confidence**: HIGH
**Subject**: `jr api` — query-parameter composition (issue #583)
**Source**: `src/cli/api.rs::append_query_params` (new pure function, to be implemented,
cycle-014); `src/cli/api.rs::handle_api` (to be modified, cycle-014); `src/cli/mod.rs::
Command::Api` (new `-q`/`--query-param` field, to be modified, cycle-014); `src/main.rs`'s
`Command::Api` dispatch arm (to be modified, cycle-014); `src/cli/api.rs::normalize_path`
(existing, unmodified — runs before this step). `urlencoding::encode` (existing dependency,
production encoder for this BC's assembly — no new dependency); `url::form_urlencoded::parse`
(existing dependency, test-oracle decoder only, VP-API-QP-002/003); `url::form_urlencoded::
byte_serialize` (existing dependency, explicitly forbidden for this BC's assembly — see
Invariants); `.factory/research/github-issues-triage-grounding-2026-09-24.md` §#583 (gh
api/HTTPie/curl prior art)
**Behavior**: `--query-param`/`-q NAME=VALUE` is a repeatable clap flag on `Command::Api`
(`src/cli/mod.rs`), declared the same way as that variant's existing `-H`/`--header` field: a
plain `Vec<String>` with `ArgAction::Append` (clap derive's default accumulation for a `Vec<T>`
field) and NO `value_delimiter` and NO `allow_hyphen_values` — each `-q`/`--query-param`
occurrence contributes exactly one `NAME=VALUE` pair to the vector, and a comma inside VALUE
(e.g. `fields=summary,status`) is never split into multiple pairs. After `normalize_path`
produces the normalized path and BEFORE
`client.request(...)` builds the outgoing request, a new pure function assembles every
`--query-param` pair into a percent-encoded query string and merges it onto the path:
1. **Query-string detection and merge** — detection considers ONLY the part of `<path>` BEFORE
   its first `#` (a `#` starts the fragment, EC-X.16.001-5, and is never scanned for `?`).
   Within that pre-fragment part:
   - **No `?` present** → a fresh leading `?` introduces the assembled query string.
   - **A `?` is present** → the QUERY COMPONENT is everything AFTER the FIRST `?` in the
     pre-fragment part (only the first `?` demarcates the query's start; any later `?`
     character is ordinary query content, not a second delimiter).
     - Query component is EMPTY (the pre-fragment part ends at the first `?` — e.g.
       `/rest/api/3/search?`, or `/s?` immediately followed by a `#fragment` as in `/s?#f`) or
       already ends with `&` → the new pairs are appended DIRECTLY (no separator is added —
       EC-X.16.001-8).
     - Otherwise — including when the non-empty query component happens to END with a literal
       `?` character that is part of existing query content, not a delimiter (e.g.
       `/s?jql=why?`) — the new pairs are appended with a `&` join: `/s?jql=why?` + `k=v` →
       `/s?jql=why?&k=v`, never `/s?jql=why?k=v` (EC-X.16.001-9).
   The pre-existing query text is passed through verbatim, never re-encoded, in every case; a
   `#fragment`, if present, is re-appended unchanged after the assembled query (EC-X.16.001-5).
2. **Repeated same-name params are ALL sent, in the given order** — `--query-param fields=summary
   --query-param fields=status` produces `fields=summary&fields=status`; no deduplication, no
   last-wins/first-wins collapsing.
3. **NAME and VALUE are percent-encoded EXACTLY ONCE, using `urlencoding::encode` specifically**
   (NOT `url::form_urlencoded::byte_serialize` — a different encoder with different semantics,
   see Invariants below), applied separately to NAME and to VALUE; the `=` joining them is
   literal, never itself encoded. Every byte of the encoded NAME/VALUE is either an RFC 3986
   UNRESERVED byte (`A`-`Z`, `a`-`z`, `0`-`9`, `-`, `.`, `_`, `~` — verified against
   `urlencoding` 2.1.3's `encode_into`, which percent-encodes every byte except exactly this
   set) or a `%HH` triplet (uppercase hex); a space byte encodes to `%20`, NEVER `+` (verified:
   `urlencoding` has no space special-case — space is simply outside the unreserved set, unlike
   `url::form_urlencoded`'s `application/x-www-form-urlencoded` serialization, which deliberately
   maps space to `+`). Rationale, encoder-agnostic: `%20` decodes back to a space byte under
   both RFC 3986 and form-urlencoded semantics, while `+` does not. A raw `%` byte in
   user-supplied input is encoded to `%25`, never passed through unescaped and never
   double-decoded (mirrors the universal client-side-encodes-raw-values convention confirmed
   across `gh api -f/-F`, HTTPie `name==value`, and `curl -G --data-urlencode` in the external
   grounding). **Settled behavior, human-confirmed 2026-09-25 (D-380)** (see "Decisions confirmed during
   F2 review" in `prd-delta.md`): NAME and VALUE are
   used EXACTLY as typed — NEITHER is trimmed of leading/trailing whitespace, matching `gh api
   -f`'s raw-bytes-as-typed behavior; this intentionally DIFFERS from `parse_header`'s existing
   `-H`/`--header` parsing, which DOES trim. See EC-X.16.001-10/11. Since encoding happens
   downstream of the CLI parse (this BC's assembly step, not clap itself), the clap help text
   for `--query-param`/`-q` (`src/cli/mod.rs::Command::Api`) states plainly that values are
   passed raw and must not be pre-encoded by the caller — pre-encoding a value (e.g. passing
   `%20` intending a space) would itself be percent-encoded again by this step (`%20` →
   `%2520`), which is correct behavior for this BC but a caller footgun the help text exists to
   prevent. **Pinned substring:** the help text MUST contain the literal substring "do not
   pre-encode" (case-sensitive); this is the exact string VP-API-QP-003(e) asserts against
   `jr api --help` output.
4. **Method-orthogonal** — the same assembly runs identically regardless of `-X`/`--method`
   (`jr api` supports GET/POST/PUT/PATCH/DELETE, per `src/cli/api.rs::HttpMethod`; BC-X.1.011's
   method-case-insensitivity precedent); query-param content is NEVER merged into, or sourced
   from, `-d`/`--data`'s request body (`resolve_body`) — the two are fully independent inputs to
   the same request.
5. **Zero effect when the flag is absent** — an invocation with no `--query-param` flags at all
   produces a path handed to `client.request` that is byte-identical to `normalize_path`'s own
   output, exactly as before this cycle. Calling `append_query_params` with an empty pair list is
   permitted and must be the identity function on its path argument (`append_query_params(p, &[])
   == p` for any `p`) — whether or not that call happens to be skipped is an implementation
   detail, not part of this contract.

Existing `jr api` behavior for BC-X.1.007 (raw-passthrough of the response) and BC-X.1.011
(`-X`/`--method` case-insensitivity) is unaffected by this BC.

**Preconditions**:
- `<path>` is already `normalize_path`-normalized: a leading slash is present, and it is not an
  absolute `http(s)://` URL (`src/cli/api.rs::normalize_path` trims the raw input and prepends a
  `/` when one is not already present).
- Every `--query-param` value is well-formed `NAME=VALUE` with a non-empty NAME (malformed
  values are BC-X.16.002's error taxonomy, evaluated BEFORE this BC's assembly step runs).

**Postconditions**:
1. Zero `--query-param` flags → the path handed to `client.request` is byte-identical to
   `normalize_path`'s own output. `append_query_params` called with an empty pair list is
   permitted and must be the identity on its path argument (regression guard against
   BC-X.1.007/BC-X.1.011).
2. One or more well-formed `--query-param` flags → exactly one percent-encoded query string is
   appended, determined entirely by the PRE-FRAGMENT part of `<path>` (any `#fragment` plays no
   role in this decision — EC-X.16.001-5). The `?`-presence check is evaluated FIRST, before any
   `&`-termination check, and the two checks are mutually exclusive by construction — the
   `&`-terminated no-separator rule (b) is reachable ONLY once (a) has already found a `?`: (a)
   no `?` in the pre-fragment part → a fresh leading `?` introduces it, regardless of whether the
   pre-fragment part itself ends in `&` (EC-X.16.001-14); (b) a `?` is present and the QUERY
   COMPONENT (the text after the FIRST `?`) is empty or ends in `&` → the new pairs are appended
   with NO separator (EC-X.16.001-8); (c) a `?` is present and the query component is non-empty
   and does not end in `&` → the new pairs are appended with a leading `&`, even when the query
   component itself ends in a literal `?` character (EC-X.16.001-9) — a trailing `?` in the query
   CONTENT is never mistaken for the EC-X.16.001-8 empty-query-component case.
3. NAME/VALUE percent-encoding happens EXACTLY ONCE per pair, via `urlencoding::encode` — never
   zero times (unescaped passthrough) and never twice (double-encoding a literal `%` to
   `%2525`). Every encoded byte is an RFC 3986 unreserved byte (`A-Za-z0-9-._~`) or a `%HH`
   triplet; space encodes to `%20`, never `+`.
4. Repeated `--query-param NAME=...` occurrences are ALL present in the final query string, in
   flag order.
5. The assembled query string is independent of `-X`/`--method` and of `-d`/`--data` — the same
   assembly logic runs for every method value, and no request-body content is read or written by
   this step.

**Invariants**:
- `append_query_params` is a pure, side-effect-free string function — no I/O, callable and
  testable without a `JiraClient` or wiremock, same class as `normalize_path`/`parse_header`.
- Runs strictly BEFORE the `RequestBuilder` is built — query composition never depends on, and
  never mutates, the request body or headers.
- The intended encoder is `urlencoding::encode` (already a direct dependency, `Cargo.toml`) —
  `url::form_urlencoded::byte_serialize` MUST NOT be used for this assembly: it targets
  `application/x-www-form-urlencoded` semantics (space → `+`), not RFC 3986 query-string
  percent-encoding (space → `%20`); using it would silently change VP-API-QP-003's pinned
  `space → %20` example to `space → +`.
- The guarantee is about what the assembly ADDS: it never adds a second `?`, and it never adds
  `&` immediately after an empty or `&`-terminated query component. There is no blanket claim
  that the final output never contains `?&` or `??` as substrings — EC-X.16.001-9 legitimately
  produces `?&` when the existing query component itself ends in a literal `?`.

**Edge Cases**:
- EC-X.16.001-1: `--query-param k=` (empty VALUE, NAME non-empty) → ALLOWED, sends the literal
  `k=` as-is; RFC 3986 places no constraint on it; contrast
  EC-X.16.002-2 (empty NAME), which is REJECTED.
- EC-X.16.001-2: `--query-param jql=status=Done` (VALUE containing `=`) → splits on the FIRST
  `=` only: NAME `jql`, VALUE `status=Done` (the remainder of the string, `=` characters
  included, is not re-split).
- EC-X.16.001-3: Non-ASCII/Unicode VALUE (e.g. `--query-param summary=café`) → UTF-8 bytes are
  percent-encoded (e.g. `é` → `%C3%A9`) via the SAME `urlencoding::encode` call used for the
  ASCII case (the sole production encoder for this BC); no separate Unicode-handling branch.
  `url::form_urlencoded::parse` plays no role in production encoding — it is used ONLY as a
  test-oracle decoder in VP-API-QP-002/003's proptests (round-tripping the assembled query back
  to verify NAME/VALUE pairs); `url::form_urlencoded::byte_serialize` remains forbidden for this
  BC's assembly (see Invariants above).
- EC-X.16.001-4: `<path>` already ends in `?existing=1` → new pairs are appended with `&`:
  `...?existing=1&new=2`; the pre-existing `existing=1` text is never re-encoded or reordered.
- EC-X.16.001-5: `<path>` contains a `#fragment` → per RFC 3986 component ordering
  (`path?query#fragment`), the assembled query string is inserted BETWEEN the path and the `#`;
  the fragment text itself is passed through verbatim. Query-string detection (Behavior 1/
  Postcondition 2) considers ONLY the part of `<path>` BEFORE the first `#` — any `?` appearing
  AFTER the `#`, inside the fragment text itself, is never treated as a query delimiter and is
  passed through as opaque fragment content. Per HTTP request-target semantics (RFC 9112 §3.2 — a
  fragment is a client-side-only construct, never part of the wire request-line), the fragment
  is not transmitted to the server regardless of `jr`'s own choices here — this is standard
  HTTP-client behavior, not a `jr`-specific encoding decision, documented for completeness since
  `normalize_path` performs no fragment-aware handling today.
- EC-X.16.001-6: `--query-param` combined with `-X POST`/`-X PUT`/`-X DELETE`/`-X PATCH` → the
  query string is appended identically regardless of method (BC-X.1.011 precedent); `-d`/
  `--data` body content is unaffected and never inspected for query-mergeable content.
- EC-X.16.001-7: `--query-param` entirely absent → the path handed to the request is
  byte-identical to `normalize_path`'s output, and `append_query_params(p, &[]) == p` holds for
  the identity call — BC-X.1.007's raw-passthrough contract and BC-X.1.011's
  method-case-insensitivity contract are BOTH unaffected.
- EC-X.16.001-8: `<path>` already ends in a bare `?` with no query pairs yet (e.g.
  `/rest/api/3/search?`), or already ends in `&` immediately after an existing query (e.g.
  `/rest/api/3/search?a=1&`) → the new pairs are appended DIRECTLY, with NO separator inserted:
  `/rest/api/3/search?` + `new=2` → `/rest/api/3/search?new=2` (never `?&` or `??`);
  `/rest/api/3/search?a=1&` + `new=2` → `/rest/api/3/search?a=1&new=2` (never `&&`). The
  governing rule is the QUERY COMPONENT test from Behavior 1/Postcondition 2 — the text after
  the FIRST `?` in the pre-`#` part of `<path>` — never a purely-syntactic "path's last
  character is `?` or `&`" check, which would wrongly fire on EC-X.16.001-9's
  `/rest/api/3/search?jql=why?`. Here the query component (the empty string and `a=1&`
  respectively) independently satisfies the empty-or-`&`-terminated test.
- EC-X.16.001-9: `<path>`'s pre-fragment part has a QUERY COMPONENT (the text after the first
  `?`) that is NON-EMPTY and happens to END with a literal `?` character that is part of
  existing query CONTENT, not a delimiter (e.g. `/rest/api/3/search?jql=why?` — the first `?`
  introduces the query, and `jql=why?`, whose own last character happens to be `?`, is the query
  component) → the new pairs are STILL appended with a `&` join, exactly as any other non-empty,
  non-`&`-terminated query component: `/rest/api/3/search?jql=why?` + `k=v` →
  `/rest/api/3/search?jql=why?&k=v` (never `/rest/api/3/search?jql=why?k=v`). Never confused with
  the EC-X.16.001-8 no-separator case — that case applies ONLY when the query component itself
  is empty or ends in `&`, not merely when its last character happens to be `?`.
- EC-X.16.001-10: `--query-param " =v"` (NAME is a single space, or any other non-empty
  whitespace-only string) → NAME is not trimmed and is therefore not empty, so this is ALLOWED,
  not BC-X.16.002's empty-NAME error — the space byte is percent-encoded to `%20`, producing
  `%20=v` in the assembled query string. Contrast a literal empty string before the first `=`
  (`--query-param =v`), which IS the empty-NAME error (EC-X.16.002-2).
- EC-X.16.001-11: `--query-param "k= v "` (VALUE with leading and/or trailing whitespace) → the
  whitespace is not trimmed; it is part of the raw VALUE bytes and is percent-encoded like any
  other byte (each space → `%20`), sent to the server exactly as typed. This intentionally
  differs from `parse_header`'s `-H`/`--header` parsing, which trims.
- EC-X.16.001-12: `<path>` already carries a
  query pair whose NAME matches a `--query-param` NAME (e.g. `/s?fields=summary` +
  `--query-param fields=status`) → the new pair is NOT deduplicated against, and does NOT
  override, the pre-existing one — both are sent, the pre-existing pair(s) first (unmodified,
  per Behavior 1's verbatim-passthrough rule for pre-existing query text) followed by the new
  pair(s) in flag order: `/s?fields=summary&fields=status`. This assembler performs no
  NAME-collision detection at all, whether the collision is against pre-existing query text or
  against another `--query-param` occurrence (Behavior 2); which value, if either, "wins" is
  entirely a server-side decision, outside this BC's scope. This no-override/no-dedup choice
  (rather than overriding the pre-existing pair, or deduplicating to one) is settled behavior,
  human-confirmed 2026-09-25 (D-380) — see "Decisions confirmed during F2 review" in `prd-delta.md`.
- EC-X.16.001-13: `-q fields=summary,status` (a comma inside VALUE) → the clap field's plain
  `Vec<String>` declaration (no `value_delimiter`) means this is ONE occurrence producing ONE
  pair — NAME `fields`, VALUE `summary,status` — never two occurrences (`fields=summary` and a
  bare `status`, the latter missing its `=` and failing BC-X.16.002's M1 taxonomy). The comma is
  ordinary VALUE content, percent-encoded once like any other byte: `summary,status` →
  `summary%2Cstatus`, producing `fields=summary%2Cstatus` — never split on `,`.
- EC-X.16.001-14: `<path>` has no query component and its pre-fragment part ends in `&` (e.g.
  `/x&`; `&` is legal in a path segment per RFC 3986) → the `?`-presence check (Postcondition 2,
  no `?` in the pre-fragment part) is evaluated FIRST and finds none, so a fresh leading `?`
  introduces the query regardless of the trailing `&`: `/x&` + `k=v` → `/x&?k=v`. The
  EC-X.16.001-8 `&`-terminated no-separator rule applies ONLY inside an existing query component
  (i.e. only when a `?` is already present) — it never fires on a bare path's trailing `&`.

**Verification Properties**:
All four VPs' proptests target `append_query_params`; VP-API-QP-002's argv cells target the
clap field declaration and handle_api's parsed-Vec hand-off to append_query_params, and VP-API-QP-003(e) the `--help` text. `src/cli/api.rs::append_query_params`
is a pure string function (Invariants), so the proptests need no `JiraClient`, network or config. `url::form_urlencoded::parse` is used
ONLY as a test-oracle decoder, never in production.
- VP-API-QP-001: separator oracle (Behavior 1, Postcondition 2, EC-X.16.001-4/5/8/9/14). Let `pre`
  be the part of `<path>` before the first `#`, `frag` the rest (`#...` or empty), and `q` the
  text after the first `?` in `pre`, if any. For a non-empty pair list, the output equals
  `pre + s + pairs + frag`, where `pairs := new_pairs.map(|(n,v)| enc(n) + "=" + enc(v)).join("&")`
  with `enc` = `urlencoding::encode`, and `s` is decided by a case split that tests `?`-presence
  FIRST: `?` if `pre` has no `?` (even when `pre` itself ends in `&`, EC-X.16.001-14); otherwise
  `""` if `q` is empty or ends in `&`; and `&` otherwise — including when `q` ends in a literal `?` (EC-X.16.001-9:
  `/s?jql=why?` + `k=v` → `/s?jql=why?&k=v`, so `?&` legitimately appears in the output; the
  VP makes no blanket substring ban). **Strategy:** a `proptest!` asserts this equation over
  generated paths with or without an existing query, query values containing literal `?`
  (including as the last character of `q`), queries ending in `&`, query-less paths whose `pre`
  ends in `&` (both with and without a fragment, e.g. `/x&` and `/x&#f`), and fragments containing
  `?`, `&` and `#` (e.g. `/x#a?b` → `?` is added before `#`, since `pre` has no `?`), an
  EMPTY query component directly followed by a fragment (`pre` ends in `?`, `frag` non-empty,
  e.g. `/s?#f`), and existing queries whose NAMEs collide with the new pairs' NAMEs
  (EC-X.16.001-12 — `pre` is kept verbatim, so a colliding pre-existing pair
  is neither removed nor rewritten). Pinned examples: EC-X.16.001-4, -5, -8 (both forms), -9,
  the empty-query-plus-fragment case `/s?#f` + `k=v` → `/s?k=v#f` (`q` is empty, so no separator
  is added, and the pair lands before `#`), -14 (`/x&` + `k=v` → `/x&?k=v`), and -12 (`/s?fields=summary` +
  `fields=status` → `/s?fields=summary&fields=status`). **Fault models (killed by
  example/proptest):** `?`/`&` swapped; `ends_with('&')` replaced by `ends_with('?')` or widened
  with `||`; `find('?')` over the whole path instead of `pre` (killed by `/s?#f`: a whole-path
  query component is `#f`, non-empty, so the fault emits `/s?&k=v#f`); the `&`-terminated test
  applied to the whole `pre` before the `?`-presence check (killed by `/x&` + `k=v`: the fault
  emits `/x&k=v`); the fragment dropped or placed before the query.
- VP-API-QP-002: repeated names (Behavior 2, Postcondition 4). A `proptest!` over pair lists
  whose NAMEs come from a small alphabet (forcing repeats). **Oracle.** Let `in_query` be the
  text after the first `?` in the input path's pre-`#` part (empty if there is no `?`), and
  `out_query` the same for the output. Define `existing :=
  url::form_urlencoded::parse(in_query.as_bytes()).collect::<Vec<(String, String)>>()` (owned).
  The property is `parse(out_query.as_bytes()).collect() == existing ++ new_pairs`, where
  `new_pairs` is the input `(NAME, VALUE)` list: same length, flag order, no dedup, every
  pre-existing pair first. The same `parse` is applied to both sides, and `parse` splits on
  `&` before decoding each segment, so the equality needs only a `#`-free `in_query`; exact
  separator placement (which `parse` cannot see, since it skips empty segments) is
  VP-API-QP-001's oracle, not this one. **Generator constraint.** The existing query is built
  from already-encoded `NAME=VALUE` segments (NAME from the SAME small alphabet as the new
  pairs, VALUE `urlencoding::encode`d), `+`-free, with no empty segments and no `#`; for these
  inputs a second assertion `existing == generated_existing_pairs` also holds, so the generator
  cannot silently collapse to an empty `existing`. Because the NAMEs are shared
  (EC-X.16.001-12), the equality means no pre-existing pair is dropped or overridden by a
  same-NAME `--query-param`, and no new pair is dropped as a duplicate of a pre-existing one.
  Pinned example: `/s?fields=summary` + `fields=status` decodes
  to `[("fields","summary"), ("fields","status")]`. **Argv cell (EC-X.16.001-13):** a
  wiremock integration test, hermetic per cycle-014 `verification-delta.md` §2, runs `jr api /x -q
  fields=summary,status` as real argv through clap and asserts that the received request's
  query is exactly ONE pair, `fields=summary%2Cstatus` (query matcher on the raw query string,
  plus a decoded-pair count of 1); a catch-all mock with `.expect(0)` catches any other query.
  **Argv cell (repeated flags, handler wiring):** a second wiremock integration test, hermetic
  per the same §2, runs `jr api /x -q fields=summary -q fields=status` as real argv and reads
  the single received request via `received_requests()`, asserting its raw query string is
  exactly `fields=summary&fields=status` (both pairs, flag order); a catch-all mock with
  `.expect(0)` catches any other query. A mixed case, `jr api '/x?a=1' -q b=2 -q b=3`, asserts
  the raw query is exactly `a=1&b=2&b=3`. These cells exercise `handle_api`'s hand-off from the
  parsed `-q` `Vec` to `append_query_params`, which the proptests (targeting
  `append_query_params` directly) cannot see.
  **Fault models (killed by proptest/example):** dedup into a map, last-wins/first-wins
  collapsing (within the new pairs or against the existing query), a same-NAME override of the
  pre-existing pair, reordering, and `value_delimiter = ','` on the `-q` clap field (it splits
  the value into `fields=summary` and a bare `status`, which fails the argv cell). **Fault
  model (killed by the repeated-flags argv cell):** `handle_api` forwarding only the first or
  last parsed pair to `append_query_params`, or deduplicating the parsed `Vec` before the
  call.
- VP-API-QP-003: encoding exactly once (Behavior 3, Postcondition 3, EC-X.16.001-3/10/11). A
  `proptest!` over arbitrary UTF-8 NAME/VALUE, with a biased strategy over-sampling `%`, `&`,
  `=`, `#`, `+`, space, `?`, CR/LF and pre-encoded look-alikes (`%25`, `%2B`, `%20`), asserts:
  (a) **round-trip** — `decode(encode(v)) == v` for NAME and VALUE, where `encode(v)` is the
  NAME or VALUE segment extracted from `append_query_params`'s output (not a direct call to
  `urlencoding::encode`), so the round-trip exercises the function under test; this rules out
  both zero encoding and double encoding; (b) **alphabet** — every byte of each encoded NAME/VALUE is RFC
  3986 unreserved (`A-Za-z0-9-._~`) or an uppercase `%HH` triplet, space → `%20`, never `+`;
  (c) **encoder identity** — each appended pair equals
  `format!("{}={}", urlencoding::encode(name), urlencoding::encode(value))` byte-for-byte, with
  pinned examples `*` → `%2A` and space → `%20` (both of which
  `url::form_urlencoded::byte_serialize` fails); (d) **no trimming** — whitespace-only and
  leading/trailing-whitespace NAME/VALUE are encoded, not trimmed: `" =v"` → `%20=v`,
  `"k= v "` → `k=%20v%20`; these examples also run through `parse_query_param` (VP-API-QP-005)
  so a whitespace-only NAME is accepted; (e) **help-text pin** (Behavior 3) — an integration
  test runs `jr api --help` (exit 0) and asserts its stdout, with every whitespace run collapsed
  to one space so clap's line wrapping cannot split the phrase, contains the case-sensitive
  substring `do not pre-encode`. Further pinned
  examples: `%` → `%25`, `+` → `%2B`, `é` → `%C3%A9`, literal `%25` → `%2525` (a correct single
  encoding of literal input). **Fault models (killed by example/proptest):** no encoding,
  double encoding, `byte_serialize` substituted for `urlencoding::encode`, the `=` joiner
  encoded, NAME or VALUE trimmed, the "do not pre-encode" help phrase dropped or reworded.
- VP-API-QP-004: method orthogonality and zero-flag identity (Behavior 4/5, Postconditions 1
  and 5, EC-X.16.001-6/7). Structural: `append_query_params` takes no method or body
  parameter, so its output cannot depend on either. A table-driven wiremock test (hermetic per cycle-014
  `verification-delta.md` §2) over GET/POST/PUT/PATCH/DELETE (`src/cli/api.rs::HttpMethod`), each with and
  without `-d`, asserts the same received query pairs for every method and a request body equal
  to the `-d` input — the body is never moved into the query and the query never into the
  body. **Zero flags.** The observable property is that the path handed to the request is
  byte-identical to `normalize_path`'s output. Two layers: (1) a `proptest!` asserts
  `append_query_params(p, &[]) == p` for arbitrary `p` — including paths with an existing query,
  a trailing `?` or `&`, and a `#fragment` — i.e. the assembler with zero pairs is the identity;
  (2) wiremock examples with no `-q` flag, for each HTTP method, assert the received request's
  path and query equal `normalize_path`'s output: `jr api rest/api/3/myself` → path
  `/rest/api/3/myself` with no query string at all (no bare `?`); `jr api
  "/rest/api/3/search?jql=a&"` → received query exactly `jql=a&`. The existing `jr api`
  integration tests stay unmodified. **Fault models (killed by example/proptest):** a `?` (or
  `&`) appended on zero pairs; the path re-encoded or the fragment dropped on zero pairs; query
  assembly gated on the method; `-d` content merged into the query.

**Trace**: issue #583; `.factory/research/github-issues-triage-grounding-2026-09-24.md` §#583
(gh api `-f`/`-F`, HTTPie `name==value`, curl `-G --data-urlencode` prior art — HIGH confidence
for flag semantics, MEDIUM for exact encoding rules);
`.factory/cycles/cycle-014/phase-f1-delta-analysis/delta-analysis.md` §Item #583; BC-X.1.007
(`send_raw` raw-passthrough, unaffected by this BC); BC-X.1.011 (`-X`/`--method`
case-insensitivity, method-orthogonality precedent); D-378; D-379. Production encoder:
`urlencoding::encode` (existing dependency, reused). Test-oracle decoder only:
`url::form_urlencoded::parse` (existing dependency, reused). Explicitly forbidden for this BC's
assembly: `url::form_urlencoded::byte_serialize` (existing dependency).

---

#### BC-X.16.002: `jr api --query-param` malformed-value error taxonomy: missing `=` and empty NAME both exit 64 before any HTTP call

**Confidence**: HIGH
**Subject**: `jr api` — query-parameter error taxonomy (issue #583)
**Source**: `src/cli/api.rs::parse_query_param` (new pure parser function, to be implemented,
cycle-014 — the pre-flight `NAME=VALUE` validator that produces this BC's two error rows;
DISTINCT from `src/cli/api.rs::append_query_params`, which is BC-X.16.001's query-assembly
function, not this BC's); `src/cli/api.rs::handle_api` (to be modified, cycle-014, to call
`parse_query_param` at the pre-flight point described in Postcondition 1).
**Behavior**: `parse_query_param` splits each raw `--query-param` value on the FIRST `=`
only — VALUE may itself contain `=` characters, which are preserved verbatim in the split-off
remainder. Two client-side, pre-HTTP failures result, both `JrError::UserError`/exit 64, zero
HTTP calls: no `=` present at all → error M1; an empty NAME (literally nothing before the first
`=`, e.g. `=v`) → error M2. An empty VALUE (`k=`) is NOT an error — see BC-X.16.001
EC-X.16.001-1. NAME is not trimmed of whitespace before this check, matching BC-X.16.001
Behavior 3's no-trim design default — a whitespace-only NAME (e.g. `" =v"`) is therefore NOT
empty and does not trip M2. Structurally mirrors `parse_header`'s existing `Key: Value`
pre-flight validator for `-H`/`--header` (`src/cli/api.rs::parse_header`, which likewise rejects
a malformed value via `.split_once(':')` before any request is built).

| Condition | Behavior |
|---|---|
| `--query-param` value contains no `=` at all (e.g. `--query-param foo`) | Exit 64, `JrError::UserError`, message naming the offending value and the required `NAME=VALUE` form |
| `--query-param` value's NAME (the portion before the first `=`) is empty (e.g. `--query-param =v`) | Exit 64, `JrError::UserError`, a DISTINCT message — an empty parameter NAME is never valid, even though an empty VALUE is (EC-X.16.001-1) |

**Pinned error messages**: both messages are pinned VERBATIM below, `format!`-style, modeled on
`parse_header`'s own two messages
(`src/cli/api.rs::parse_header`: `"Header must be in 'Key: Value' format (got: {raw})"` and
`"Header key cannot be empty"`) but each additionally suggests a concrete next step, per this
repo's "Errors: Always suggest what to do next" convention (`CLAUDE.md` § Conventions):

- Missing `=` (raw value has no `=` at all): `"--query-param must be in NAME=VALUE format (got:
  {raw})"`
- Empty NAME (raw value's portion before the first `=` is the literal empty string): `"--query-param
  NAME cannot be empty (got: {raw}) — use NAME=VALUE, e.g. -q maxResults=50"`

Each message contains a substring absent from the other (`"must be in NAME=VALUE format"` vs.
`"NAME cannot be empty"`), so the two are distinguishable by substring match alone — required by
the Invariants below and asserted by VP-API-QP-005 (distinguishing-substring assertion). `{raw}`
is the value CLAP DELIVERS to `parse_query_param` after clap's OWN attached-value parsing —
not necessarily byte-identical to what the user typed on the command line. `parse_query_param`
performs no re-splitting or normalization of its own before echoing `{raw}` into the message, but
clap's own parsing (verified against `clap_builder` 4.6.7's `src/parser/parser.rs`, the
short-flag attached-value branch around line 980, and `clap_lex` 1.1.0's `to_long`) already
strips exactly one leading `=` from an attached value before `parse_query_param` ever sees it —
see EC-X.16.002-5..8 below for the concrete attached-form cases this produces.

**Preconditions**: One or more `--query-param` flags supplied (zero flags → no parsing occurs at
all, nothing to validate — BC-X.16.001 Postcondition 1). `-q` validation runs only AFTER
`Config::load_with` and `JiraClient::from_config` both succeed in `src/main.rs`'s `Command::Api`
dispatch arm — both calls precede `cli::api::handle_api`, where `parse_query_param` lives.
`config::validate_profile_name`, `Config::load_with` (e.g. unknown profile, malformed config) and
`JiraClient::from_config` failures all preempt this BC's exit-64; some of these also exit 64,
before `handle_api` is ever invoked — and `src/cli/api.rs::normalize_path`'s own path errors
(empty path, absolute URL), which run first in `handle_api`, preempt it too.

**Postconditions**:
1. Every malformed `--query-param` value is caught by `parse_query_param` BEFORE
   `append_query_params` touches `normalize_path`'s output, BEFORE any query string is
   assembled, and — per D-188's pre-flight-before-blocking-read convention — BEFORE
   `resolve_body` runs (`resolve_body` may block reading stdin for `-d @-`) and BEFORE
   `-H`/`--header` parsing (`parse_header`). Concretely, in `handle_api` (`src/cli/api.rs`),
   `--query-param` parsing is inserted immediately after the existing `normalize_path(&path)?`
   call (line ~130) and BEFORE the existing `resolve_body(data.as_deref(),
   std::io::stdin().lock())` call (line ~133) — i.e. `-q` parsing is the SECOND pre-flight step,
   right after path normalization and strictly ahead of both the body read and the
   `-H`/`--header` → `parse_header` mapping (lines ~135-138). Zero HTTP calls, symmetric with
   `parse_header`'s existing pre-flight validation.
2. `--output json` mode: the same `{"error": "...", "code": 64}` envelope as every other `jr`
   pre-flight error (repo-wide convention, #526-adjacent). Per `src/main.rs`'s top-level error
   handler (~lines 132-140), this envelope is written via `eprintln!` — it goes to STDERR, not
   stdout; stdout stays empty on this path (no data is ever written to stdout before a pre-flight
   exit-64). This is the same channel every other `jr` pre-flight/runtime error uses in
   `--output json` mode, not a taxonomy-specific choice.
3. A single invocation with multiple `--query-param` flags where ANY ONE is malformed fails the
   WHOLE invocation before any HTTP call — no partial assembly, consistent with `parse_header`'s
   existing `.collect::<Result<Vec<_>>>()` all-or-nothing pattern already used for `-H`/
   `--header` in `handle_api`.

**Invariants**:
- Missing-`=` and empty-NAME are DISTINCT conditions with DISTINCT messages, even though both
  exit 64 — a caller fixing one deterministically encounters the other only if a second,
  independently-malformed `--query-param` value is also present (no silent flip between the two
  messages for the SAME malformed value).
- An empty VALUE (`k=`) is NEVER classified as an error by this taxonomy — see BC-X.16.001
  EC-X.16.001-1; only a missing `=` or an empty NAME are rejected here.
- `--query-param` values are validated via a `.collect::<Result<Vec<_>>>()`-style
  short-circuiting iteration in FLAG ORDER — the FIRST malformed value encountered in that
  order is the one reported. This mirrors the collect-based all-or-nothing pattern already used
  for `-H`/`--header`, applied at an EARLIER point in `handle_api`'s pipeline (before
  `resolve_body`, not after).

**Edge Cases**:
- EC-X.16.002-1: `--query-param foo` (no `=` present) → exit 64, M1 (missing-`=`) message
  naming `foo`.
- EC-X.16.002-2: `--query-param =v` (empty NAME, non-empty VALUE) → exit 64, M2 (empty-NAME)
  message — contrast EC-X.16.001-1 (`k=`, empty VALUE), which is ALLOWED, not an error.
- EC-X.16.002-3: Two `--query-param` flags, the second malformed (`--query-param a=1
  --query-param bad`) → the malformed second value fails the WHOLE invocation before any HTTP
  call; the first, well-formed value is never sent, and the FIRST malformed value in flag order
  is the one reported (Postcondition 3, Invariants).
- EC-X.16.002-4: `jr api /x -X POST -d @- -q bad` exits 64 immediately on the M1 malformed-value
  error regardless of stdin's state — a TTY, inherited, closed, OR a pipe held open by a slow
  or never-closing producer (i.e. `Stdio::piped()` with the write end never written to and never
  dropped). `resolve_body`'s blocking `@-` stdin read never runs, since `-q` validation
  (Postcondition 1) executes strictly before it in every one of these cases. The held-open-pipe
  case is the discriminating one — it is the only state under which a buggy ordering (reading
  stdin before validating `-q`) would actually hang instead of merely returning early — and is
  the one exercised by VP-API-QP-006(iii).
- EC-X.16.002-5: `-q=v` (short-flag attached form, one
  `=`) → clap's own short-flag attached-value parsing (`clap_builder` 4.6.7
  `src/parser/parser.rs` ~line 980) treats the token immediately following `-q` as the
  attached value and strips exactly ONE leading `=` from it before `parse_query_param` ever
  runs — clap delivers `raw = "v"`, not `"=v"` and not the literal `"-q=v"` the user typed.
  Since `"v"` itself contains no `=`, `parse_query_param` classifies this as M1 (missing `=`)
  with `(got: v)`, NOT M2 — a caller who intended NAME `v` (or who mistyped `-q v` as `-q=v`)
  sees the missing-`=` message rather than an empty-NAME message.
- EC-X.16.002-6: `-q==v` (short-flag attached form, two
  `=`) → the same clap strip-one-leading-`=` step consumes only the FIRST `=`, delivering
  `raw = "=v"` (the second `=` is preserved as part of the attached value). `parse_query_param`
  then splits `"=v"` on its own first `=`: NAME is the empty string, VALUE is `"v"` → M2
  (empty-NAME) with `(got: =v)`.
- EC-X.16.002-7: `--query-param==v` (long-flag attached
  form, two `=`) → verified against `clap_lex` 1.1.0's `to_long` (`remainder.split_once("=")`,
  which splits on the FIRST `=` only and has no additional strip step of its own): the flag name
  is `query-param` and the delivered value is everything after that first `=`, i.e. `raw = "=v"`
  — BYTE-IDENTICAL to EC-X.16.002-6's short-form result, even though the long form's parser has
  no separate "strip one leading `=`" step (the single `split_once` already produces the same
  outcome as the short form's split-then-strip). `parse_query_param` therefore also reports M2
  (empty-NAME) with `(got: =v)` for `--query-param==v`, exactly as it does for `-q==v`.
- EC-X.16.002-8: `-q -x=1` (a hyphen-leading token as the
  space-separated value for `-q`) — the `--query-param`/`-q` flag is NOT declared with
  `allow_hyphen_values` (there is no `src/cli/mod.rs` flag definition to cite yet, since no code
  has landed for this spec-only delta; the design intent is to leave it unset). Without
  `allow_hyphen_values`, clap treats a token starting with `-` as a new flag rather than as `-q`'s
  value, so `jr api /x -q -x=1` fails clap's own argument parsing (unrecognized `-x` flag)
  with exit 2, BEFORE `parse_query_param` ever runs — this is a
  clap-level failure, not one of this BC's M1/M2 rows. This is ACCEPTABLE and consistent with
  this file's existing `-H`/`--header` precedent: `header: Vec<String>` (`src/cli/mod.rs`,
  `Command::Api`) likewise has no `allow_hyphen_values`, so a hyphen-leading header value (e.g.
  `-H -x: 1`) fails identically at the clap level today. A raw `NAME=VALUE` argument that itself
  starts with `-` (i.e. a NAME beginning with `-`) must use an attached form — `-q=-x=1`,
  `-q-x=1`, or `--query-param=-x=1` all work, delivering `raw = "-x=1"` to `parse_query_param`
  (verified
  against `clap_builder` 4.6.7's short-flag trailing-concatenated-value handling, `~L969-984`:
  the value following `-q` is taken as-is, stripping at most one leading `=`, so both the
  `=`-prefixed and bare-concatenated short forms converge on the same delivered value; the
  long-form `split_once("=")` in `clap_lex` 1.1.0's `to_long` produces the identical result) —
  there is no quoting workaround, since the shell strips quotes
  before clap ever sees the argument, so clap still receives a bare `-x=1` token
  indistinguishable from a new flag in the space-separated form. By contrast, a hyphen-leading
  VALUE such as `-q startAt=-1` or `-q jql=-x` works as-is, with no attached form needed, because
  the argv token itself starts with the NAME, not `-` — clap only misreads a space-separated
  value as a new flag when the token's own first character is `-`.
- EC-X.16.002-9: An empty raw value — `-q ""` (space-separated empty-string token), `-q=`
  (short-flag attached, nothing after the `=`), or `--query-param=` (long-flag attached, nothing
  after the `=`) — all three reach `parse_query_param` as `raw = ""`, not as a missing value:
  verified against `clap_builder` 4.6.7's short-flag attached-value path (`~L969-984`, an
  attached value of exactly `"="` strips to `Some("")`, which is still `Some`, so it is treated
  as a provided (empty) value rather than falling through to "look for a separate next-token
  value") and its long-flag counterpart (`clap_lex` 1.1.0's `to_long`, `~L332`,
  `remainder.split_once("=")`, which likewise
  yields `long_value = Some("")` for a trailing bare `=`); a bare next-token empty string
  (`-q ""`) is accepted the same way, since an empty string does not start with `-` and so is
  never mistaken for a new flag. Because `""` contains no `=` at all, `parse_query_param`'s
  split-on-first-`=` finds nothing to split on, and this classifies as M1 (missing `=`) with
  `(got: )`, exit 64, zero HTTP — NOT M2 (empty NAME): the empty-NAME check is only reachable
  once a `=` has been found to split on, so the missing-`=` check must be evaluated first (or,
  equivalently, the parser must be structured so that finding no `=` short-circuits before any
  NAME-emptiness check can run).
- EC-X.16.002-10: `jr api /x -q` with no following token at all (`-q` is the LAST argv token) is
  a genuinely MISSING value, not an empty one — contrast with EC-X.16.002-9's provided-but-empty
  cases above. clap itself rejects this before `parse_query_param` ever runs: verified against
  `clap_builder` 4.6.7's `ErrorKind::InvalidValue` rendering (`src/error/format.rs` ~L206-219),
  an empty `ContextValue::String` for the invalid value renders
  `"a value is required for '{invalid_arg}' but none was supplied"`; exit 2 (clap argument
  error), NOT 64 — `parse_query_param` and its M1/M2 taxonomy are unreachable for this case.
- EC-X.16.002-11: A non-UTF-8 `-q` argv value is rejected by clap (the field's `String` value
  parser) with exit 2 before `parse_query_param` ever runs — the same mechanism and outcome as a
  non-UTF-8 `-H` value today. Verified against `clap_builder` 4.6.7's `src/builder/value_parser.rs`
  (~L914-935): the `String`-typed `ValueParser` rejects an `OsString` that fails `into_string()`,
  producing a clap `ErrorKind::InvalidUtf8` argument error before the arg ever reaches
  `parse_query_param`'s M1/M2 taxonomy. Informational — inherited clap behavior, no VP cell (same
  treatment as EC-X.14.001-14).

**Verification Properties**:
- VP-API-QP-005: the malformed-value taxonomy (Behavior, Postcondition 2, EC-X.16.002-1/2/5..10).
  Function under test:
  `src/cli/api.rs::parse_query_param` (the pure parser; NOT `append_query_params`, which is
  BC-X.16.001's assembler). It splits on the FIRST `=` only. The two pinned messages, copied
  exactly from this BC's "Pinned error messages" block (`{raw}` = the raw, untrimmed argument;
  the second contains an em dash, U+2014):
  - M1 (missing `=`): `--query-param must be in NAME=VALUE format (got: {raw})`
  - M2 (empty NAME): `--query-param NAME cannot be empty (got: {raw}) — use NAME=VALUE, e.g. -q maxResults=50`
  Distinguishing substrings: D1 = `must be in NAME=VALUE format`, D2 = `NAME cannot be empty`.
  **Strategy.** (1) Partition `proptest!` on `parse_query_param`: any string with no `=`,
  including the empty string (the generator must be able to produce `""`) →
  `Err` whose message equals M1 rendered with `raw` byte-for-byte; plus the pinned example
  cell `parse_query_param("")` → `Err` equal to M1 rendered as `(got: )`, containing D1 and
  not D2 (EC-X.16.002-9); `"=" + any` (including a
  bare `=`) → `Err` equal to M2 rendered with `raw`; a non-empty `=`-free NAME (including a
  whitespace-only NAME such as `" "`, EC-X.16.001-10) + `"=" + any` → `Ok((NAME, rest))`, where
  `rest` keeps every later `=` (EC-X.16.001-2) and may be empty (EC-X.16.001-1). Each `Err`
  case asserts its own distinguishing substring is present and the other is absent (the absence
  check filtered with `prop_assume!` to `raw` values that do not themselves contain D1 or D2).
  (2) Wiremock integration (hermetic per cycle-014 `verification-delta.md` §2) for `-q foo` and `-q =v`: exit 64,
  `.expect(0)` on every mock, stderr contains the full rendered message and its own
  distinguishing substring, and not the other one. The `--output json` variant (Postcondition
  2) parses the `{"error", "code"}` envelope from STDERR, asserts its `"error"` string equals the
  rendered message exactly and `"code"` is 64, and asserts stdout is empty.
  (3) **Attached-form example cells** (EC-X.16.002-5..8), hermetic per cycle-014 `verification-delta.md`
  §2, every
  mock `.expect(0)`, run as real argv through clap so `{raw}` is the value clap delivers:
  - `jr api /x -q=v` (EC-X.16.002-5) → exit 64, stderr contains M1 rendered as
    `(got: v)`, D2 absent;
  - `jr api /x -q==v` (EC-X.16.002-6) → exit 64, stderr contains M2 rendered as
    `(got: =v)`, D1 absent;
  - `jr api /x --query-param==v` (EC-X.16.002-7) → exit 64, stderr contains M2 rendered as
    `(got: =v)`, byte-identical to the `-q==v` cell's stderr;
  - `jr api /x -q -x=1` (EC-X.16.002-8) → exit 2 (clap argument error), NOT 64; stderr
    contains `unexpected argument` (clap_builder 4.6.7's `ErrorKind::UnknownArgument` text,
    `src/error/format.rs`: `unexpected argument '<arg>' found`; observed output is
    `error: unexpected argument '-x' found`, and the substring is outside clap's styled spans),
    does NOT contain `Not authenticated` (`JrError::NotAuthenticated` also exits 2,
    `src/error.rs`, so exit 2 alone cannot tell the two apart), and contains neither D1 nor D2
    (`parse_query_param` never ran);
  - `jr api /x -q=`, `jr api /x --query-param=` and `jr api /x -q ""` (EC-X.16.002-9) → each
    exit 64, zero HTTP, stderr contains M1 rendered as `(got: )` and D1, and does not contain
    D2;
  - `jr api /x -q` with `-q` as the last argv token (EC-X.16.002-10) → exit 2 (clap argument
    error), NOT 64; zero HTTP; stderr contains `a value is required for` (clap_builder 4.6.7's
    `ErrorKind::InvalidValue` text for an empty invalid value, `src/error/format.rs`:
    `a value is required for '<arg>' but none was supplied`; the substring is outside clap's
    styled spans), does NOT contain `Not authenticated`, and contains neither D1 nor D2
    (`parse_query_param` never ran).
  **Fault models (killed by example/proptest):** swapped M1/M2, one shared generic message,
  `{raw}` replaced by a trimmed or re-split value, split on the last `=` instead of the first,
  NAME trimmed before the empty check, an empty-NAME check evaluated before the missing-`=`
  check (e.g. `raw.is_empty() || raw.starts_with('=')` → M2, killed by the `""` cells), the JSON envelope written to stdout instead of stderr,
  and `allow_hyphen_values` set on `-q` (the `-q -x=1` cell then accepts `-x=1` as a value,
  sends a request that trips `.expect(0)`, and never exits 2).
- VP-API-QP-006: pre-flight ordering and all-or-nothing (Postconditions 1 and 3, Invariants,
  EC-X.16.002-3/4). Wiremock integration, hermetic per cycle-014 `verification-delta.md` §2, every mock
  `.expect(0)`:
  (i) **All-or-nothing** — `-q a=1 -q bad` and `-q bad -q a=1` both exit 64 with no request
  sent; the well-formed pair is never transmitted.
  (ii) **First malformed flag in flag order is reported** — `-q foo -q =v` reports M1 naming
  `foo` (D2 absent); `-q =v -q foo` reports M2 naming `=v` (D1 absent).
  (iii) **Before `resolve_body`** (EC-X.16.002-4) — spawned directly with
  `std::process::Command` on the debug binary (`env!("CARGO_BIN_EXE_jr")`, or assert_cmd's
  `cargo_bin` resolver for the path only), args `api /x -X POST -d @- -q bad`, the same
  hermetic environment (`JR_BASE_URL` at a wiremock server whose mocks are all `.expect(0)`), and
  `.stdin(Stdio::piped())`, `.stdout(Stdio::piped())`, `.stderr(Stdio::piped())`. The test
  keeps the `ChildStdin` handle alive for the whole wait (never writes to it, never drops it)
  and polls `try_wait()` in a loop against a deadline of about 5 s. Pass: the child exits on
  its own before the deadline with exit code 64 and stderr containing D1 (M1's distinguishing
  substring). On the deadline the test kills the child and fails. Prompt exit plus the M1
  message is the discriminator: an implementation that read the body first would block on the
  open pipe until killed. assert_cmd's `output()`/timeout path cannot be used here: it closes
  the child's stdin before waiting (assert_cmd 2.2.2 `wait_with_input_output` → wait-timeout
  0.2.1 `drop(self.stdin.take())`; the untimed path uses `Child::wait`, which also drops
  stdin), so the pipe would hit EOF and prove nothing. Likewise an inherited `/dev/null` or a
  closed pipe returns EOF at once.
  (iv) **Before `-H` parsing** — `-q bad -H "malformed-no-colon"` reports the `-q` error (M1),
  not `parse_header`'s `Header must be in 'Key: Value' format` error.
  **Fault models (killed by example):** `-q` parsing moved after `resolve_body` or after
  `parse_header`; per-flag filtering that drops bad values instead of failing; reporting the
  last malformed value instead of the first.

**Trace**: issue #583; D-378/D-379 (F1 human gate approving this scope); the D-188
pre-flight-before-blocking-read convention; `src/cli/api.rs::parse_query_param` (new pure
parser); `src/cli/api.rs::parse_header` (existing sibling pre-flight validator, structurally
mirrored); BC-X.16.001 (companion behavior BC).

---

## Key Invariants

- MAX_RETRIES = 3 (4 total calls); change trips `expect(4)` wiremock assertions
- DEFAULT_RETRY_SECS = 1 (Retry-After fallback)
- No upper bound on Retry-After integer (NFR-R-NEW-1 LOW)
- `partial_match` single-substring → Ambiguous (fail-closed invariant)
- User pagination advances by REQUESTED size (JRACLOUD-71273 workaround)
- Worklog days/hours: 8h/day, 5d/week (hardcoded, NFR-R-C)
- `send` vs `send_raw` bifurcation: typed path vs raw passthrough
