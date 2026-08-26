---
context: bc-3
title: "Issue Write (create/edit/move/assign/comment/link/open/remote-link)"
total_bcs: 152   # cumulative claim (incl. range-collapsed); definitional_count below is individually-bodied headings
definitional_count: 123   # count of `#### BC-` headings in this file
last_updated: 2026-08-26
source_pass: 3
trace: |
  - F2 adversary-convergence round-3 amendments (2026-08-26, cycle field-dx — no BC
    added/removed/retired, no count change, still 123 individually-bodied / 152 cumulative in
    this file): fix round following a fresh 3-pass adversarial streak that found a HIGH
    contradiction, 3 MEDIUMs, and several LOWs. F-A (HIGH): empty-value handling on
    `:id=`/`:name=`/`:asset=` reconciled — BC-3.4.028/029 gain EC-3.4.028-3/EC-3.4.029-3
    (empty value PASSES THROUGH, server-validated, NOT exit-64); BC-3.4.031 EC-2 scope-noted as
    the ONLY structural (composer-cannot-build-the-array) exit-64 case, new EC-8/EC-9 document
    the `:id`/`:name` pass-through explicitly; VP-578-013 scoped to `:asset` only (flagged for
    verifier). F-MED-1 (MEDIUM): `parse_field_kv`'s own malformed-hint exit-64 pinned as a new
    step 2a in the `Platform-Path Guard Ordering` SSOT (BC-3.8.013 step 2 → parse_field_kv step
    2a NEW → D2 collision guard RENUMBERED step 2a→2b); propagated to BC-3.3.010/EC-3.3.010-6/
    BC-3.3.011. F-C (MEDIUM): BC-3.4.031 gains EC-2d (`:asset=W:Y:Z` extra-colon case, distinct
    message required, not EC-3's generic "objectId must be numeric"); EC-2's stale "three
    sub-cases" corrected to four; VP-578-012 flagged for verifier. F-LOW-4 (LOW): BC-3.3.010
    EC-3.3.010-6's create-path example corrected from edit-only `--component add:X` to
    `--component X` (create has no add:/remove: prefix grammar). O-1/O-2 (LOW): BC-3.8.008 gains
    EC-3.8.008-1 (cascading `>` unsupported on JSM `:option`, wrapped verbatim, NOT extended this
    cycle) and EC-3.8.008-2 (hinted `--field cf:option` with no `=` resolves to the pre-existing
    missing-`=` exit-64, not a hint-parse error). Full rationale and the companion
    `cross-cutting.md` fixes (F-MED-2, F-B propagation, F-LOW-1, O-3):
    `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md` "2026-08-26 F2 adversary-convergence
    round-3 amendments" section.
  - F2 adversary-convergence round-2 amendments (2026-08-26, cycle field-dx — no BC
    added/removed/retired, no count change, still 123 individually-bodied / 152 cumulative in
    this file): fix round following a fresh 3-pass adversarial streak that found five residual
    partial-fix/coverage gaps in this file, none requiring a new design decision. Pass2-F1
    (MEDIUM): BC-3.4.030's cold-cache `:asset` workspace-discovery error taxonomy widened from
    two call sites (edit, platform-create) to all THREE (edit, platform-create, JSM create via
    `handle_jsm_create`/BC-3.8.008) — the taxonomy is wire-shape-independent so applies uniformly;
    a new distinguishing note clarifies this does NOT resolve the separately-deferred JSM `:asset`
    happy-path wire-shape question (VP-578-016, still UNVERIFIED); VP-578-022 extended to assert
    all 3 sites. Pass2-F3 (MEDIUM): BC-3.4.030's `WORKSPACE:OBJECTID` first-colon split (Parsing
    rule 1) gains an explicit `str::split_once(':')` MUST (new Invariant 4), mirroring ADR-0019 §
    Amendment D3's `str::split_once('>')` MUST for the sibling `>` cascading split — this `:` split
    is an independent site not covered by BC-3.4.026 step 5's or BC-3.4.027 Invariant 5's existing
    MUSTs; new EC-3.4.030-6 (multibyte scalar adjacent to `:`, no-panic) and a VP-578-012
    extension. Pass2-F4 (LOW): BC-3.4.030 Parsing rule 3 and BC-3.4.031 EC-3 corrected from
    Unicode-aware `\d+` to ASCII-only `[0-9]+` (`(?-u)\d+`) for `objectId` validation — Rust's
    `regex` crate's default `\d` matches the whole Unicode `Nd` category, which Jira's server-side
    field does not accept. Pass2-F5 (MEDIUM): the D2 create-path collision guard (step 2a) and
    BC-3.8.013's `--on-behalf-of` guard (step 2) had no pinned relative order — both are step-2-
    class guards firing immediately after the JSM dispatch fork; the `Platform-Path Guard
    Ordering` SSOT block, BC-3.3.010's Preconditions guard-ordering list, EC-3.3.010-6, and
    BC-3.3.011's D2 taxonomy-row Postconditions note are all updated to pin step 2 (BC-3.8.013,
    pre-existing position, unchanged) BEFORE step 2a (D2, new) — deterministic, consistent with
    BC-X.14.004's "fixing one reported error deterministically encounters the next" precedence
    principle (`cross-cutting.md`). Pass2-F6 (MEDIUM, this file's 2 of 3 sites): the dangling
    `.factory/specs/verification-delta/` directory citation (never existed) replaced with the
    actual verifier artifact path `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md`
    at both sites in this file (BC-3.3.010 amendment preamble; VP-578-020 body) — third site is in
    `cross-cutting.md`. Full rationale and cross-cutting.md's companion Pass2-F2/F6 fixes:
    `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md` "2026-08-26 F2 adversary-convergence
    round-2 amendments" section.
  - F2 adversary-convergence amendments (2026-08-26, cycle field-dx, D1/D2/D3 + C-M1 + LOWs — no
    BC added/removed/retired, no count change, still 123 individually-bodied / 152 cumulative in
    this file): propagates the architect's D2/D3 decisions (ADR-0019 § Amendment 2026-08-26) and
    fixes pure-spec-text/governance defects the F2 adversary-convergence loop surfaced. **D2**
    (create-path collision guard): BC-3.4.029 EC-3.4.029-2 rewritten (create path is now
    symmetric with edit-path Gate B via shared `field_resolve::detect_flag_field_overlap`, not
    last-wins); BC-3.4.014's matching "last-wins" text rewritten to match; BC-3.4.017 gains a
    shared-function note + EC-3.4.017-16 cross-reference correction; BC-3.3.010 gains Invariant
    5 + EC-3.3.010-6 + a new VP; BC-3.3.011 gains an error-taxonomy row + Postconditions note.
    **D3** (`>`-split multibyte safety): BC-3.4.027 gains an explicit `str::split_once('>')` MUST
    (Invariant 5), EC-3.4.027-5 (multibyte no-panic) and EC-3.4.027-6 (empty parent/child segment
    → exit 64, mirrors EC-3.4.027-2/3), and VP-578-008 extended with a no-panic proptest note.
    **C-M1** (DEC renumber): the proposed DEC-307 (BC-3.3.001, BC-3.4.014, BC-3.8.001, BC-3.8.012,
    BC-3.8.013) is renumbered DEC-310 throughout this file — DEC-307 was found ALREADY ALLOCATED
    to an unrelated `cycle-001` decision via a full `.factory/`-tree survey (max DEC-309, not the
    `specs/`-only-scoped DEC-306 the original survey found); BC-3.8.012's governance-flag
    paragraph corrected in place with the collision explanation and an open DEC-namespace
    question flagged for cycle close. **C-LOW**: BC-3.8.012's F3/F4 removal-obligations holdout
    list extended to include H-NEW-PREFLIGHT-006 (was rewritten but omitted from the
    enumeration). **A-LOW-1**: BC-3.4.026 Invariant 1 gains a platform-path-only scope qualifier
    (JSM bare form is BC-3.8.008's unconditional string-wrap, not auto-detect — prevents a
    VP-578-015 regression). **B-LOW (`:asset` discovery failure)**: BC-3.4.030 gains an explicit
    error taxonomy for the bare-form cold-cache `get_or_fetch_workspace_id` GET (403/404 →
    Assets-unavailable UserError; 200+empty → no-workspace UserError; 401/5xx/network → standard
    mapping) plus EC-3.4.030-5. Full rationale, D1's `cross-cutting.md` counterpart, and A-M2/B-F1
    fixes: `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md` "2026-08-26 F2
    adversary-convergence amendments" section.
  - Adversary pass-28 fix round (2026-08-25, issue #578, MEDIUM F-1): BC-3.3.010's Postconditions
    bullet and Resolution algorithm Step 3 falsely implied `get_createmeta_fields` is called
    exactly once per invocation as a SINGLE non-paginated `GET` — this contradicted ADR-0019 §1,
    which specifies `get_createmeta_fields` is OFFSET-PAGINATED (`startAt`/`maxResults`/`total`),
    and would have masked a dropped-field bug (a field on createmeta page ≥2 spuriously failing
    resolution as "not on the Create screen"). Reworded: the paginated fetch runs AT MOST ONCE
    per invocation (shared across all `--field` pairs, NOT once per pair) but internally issues
    one `GET` per page until all pages are collected; a field on any page is resolvable. New
    inline VP-578-020 added to BC-3.3.010's Verification Properties pinning the page-≥2
    resolution behavior (realized in `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md` by the formal-verifier
    in parallel). BC-X.14.001 (`cross-cutting.md`) received the parallel correction for its M2/M3
    "exactly one … HTTP call" postcondition — see that file's own trace entry. No BC
    added/removed/retired, no count change (still 123 individually-bodied / 152 cumulative in
    this file; 719 total_bcs / 106 holdout scenarios factory-wide unchanged). Pre-pass-28 wording
    retained inline at each corrected site for audit trail.
  - Adversary pass-16 fix round (2026-08-25, issue #578, MEDIUM-2/LOW-1/LOW-2): three
    prose/wording corrections, no BC added/removed/retired, no count change (still 123
    individually-bodied / 152 cumulative in this file). MEDIUM-2: BC-3.8.008 amendment's
    JSM-wire-shape-UNVERIFIED caveat was previously scoped only to the `:option` non-cascading
    `{"value":...}` shape; extended to cover `:id`/`:name`/`:asset` `requestFieldValues` shapes
    too (none of the four kinds' `requestFieldValues` wire shapes were research-confirmed — only
    the platform-path `fields` contract was); VP-578-016 downgraded from a firm parity guarantee
    to UNVERIFIED/parity-pending, matching VP-578-008's former-PROVISIONAL discipline. LOW-1:
    BC-3.4.016's amendment mischaracterized `:id` (BC-3.4.028) as merely "the explicit spelling"
    of Step 1's id-bypass; corrected to state `:id` is the UNCONDITIONAL form — Step 1's bypass
    auto-fires only for numeric VALUEs, `:id` bypasses for any VALUE (a strict superset). LOW-2:
    BC-3.3.010's Postcondition falsely claimed a "cache-first if a warm result from the SAME
    invocation's `--type` resolution is already in hand" clause for `get_issue_types_for_project`
    — no such warm result exists on the platform create path (`--type` posts by NAME, never
    triggering that lookup on its own); corrected to state `--field`'s presence INTRODUCES the
    call, and that the function has no cache of its own. Pre-pass-16 wording retained inline for
    audit trail at each site.
  - F2 spec evolution, Field DX bundle (2026-08-25, issues #580/#578): +8 individually-bodied
    BCs — BC-3.3.010..011 (`issue create --field` extended to the non-JSM platform path via
    createmeta resolution + error taxonomy) and BC-3.4.026..031 (`--field NAME:kind=VALUE`
    hint-syntax parser + `:option`/`:id`/`:name`/`:asset` semantics + malformed-hint EC catalog).
    BC-3.3.001, BC-3.4.014, BC-3.4.015, BC-3.4.016, BC-3.4.017, BC-3.8.001, BC-3.8.008, and
    BC-3.8.013 amended in place (hint-syntax and non-JSM-create interaction notes; no count
    change) — BC-3.8.013's amendment is body-only (trigger-scope description + dead
    combined-error cross-references updated to reflect BC-3.8.012's reversal); its own guard
    BEHAVIOR is unaffected and remains fully in force. BC-3.8.012 REVERSED in place (DEC-188's
    `--field`-alone and combined exit-64 pre-flight guard removed; `[DEC-188 BEHAVIOR,
    superseded]` retained inline for audit trail; new `[CURRENT BEHAVIOR — effective
    2026-08-25]` section added; DEC-310 proposed to record the governance reversal).
    definitional_count 115→123; total_bcs 144→152 (corrected here, adversary pass-17 F-1 —
    prior wording listed only BC-3.3.001/BC-3.4.015/BC-3.4.016/BC-3.8.008 and mislabeled
    BC-3.8.013 "explicitly UNCHANGED"; see BC-INDEX.md's own pass-6 F1 correction for the
    same class of fix on that surface). See
    `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md`,
    `.factory/phase-f1-delta-analysis/delta-analysis-field-dx.md`,
    `.factory/phase-f1-delta-analysis/field-dx-bc-mapping.md`.
  - F5 feature-level wording amendment (2026-08-19, F-CS-1 — no BC added/removed/retired, no
    count change): BC-3.4.022 gains EC-3.4.022-4 and BC-3.4.024 gains EC-3.4.024-4, each
    documenting the all-ASCII-digit numeric-bypass wire shape (§8.4/BC-8.1.008/BC-8.4.001) the
    code already implements but the prior BC text omitted: single-key edit wires a numeric
    `--component` value as `{"id":"<n>"}` inside the `add`/`remove` object
    (`src/cli/issue/edit.rs`, `ComponentRefKind::Id`/`ComponentRef::Id`/`to_wire_object`);
    create wires it as an `{"id":"<n>"}` array element in `fields.components`
    (`src/cli/issue/create.rs::resolve_create_components`). Mirrors BC-3.4.023's existing
    numeric-bypass wording for the bulk path.
  - F2 targeted wording amendment (2026-08-19, S-605-2, post-research clarification — no BC
    added/removed/retired, no count change): BC-3.4.023 CLARIFIED — Postcondition 2 gains an
    explicit note that the wire body deliberately OMITS `sendBulkNotification` (the Atlassian
    doc example shows it; the live-proven, reused `bulk_edit_fields` helper omits it, per the
    issue #446 precedent) — implementers MUST NOT add it to mirror the doc example. Delivery
    note gains a precondition that the AC-010 live smoke-test project MUST have ≥1 component
    defined, else `components` is absent from the bulk-edit field allowlist and the test
    false-negatives. Source: `.factory/research/S-605-2-bulk-component-wire-2026-08-19.md`
    (8/8 CONFIRM, 0 REFUTE against current Atlassian primary docs).
  - F2 targeted wording clarification (2026-08-19, S-605-2 Step-4.5 adversarial finding, LOW,
    error-taxonomy — no BC added/removed/retired, no count change): BC-3.4.023 Invariant 2
    CLARIFIED — distinguishes the TWO distinct origins of a `componentId` `String`→`u64` parse
    failure, which the prior wording collapsed into a single "internal error" outcome. (a) A
    user-supplied all-ASCII-digit `--component add:<digits>`/`remove:<digits>` value that takes
    BC-8.4.001's numeric-bypass path (no existence check, no name-list GET) and fails to parse
    as `u64` (e.g. a value >26 digits, exceeding `u64::MAX`) is user-input text, not resolver
    output — surfaces as `JrError::UserError`, exit 64, zero POSTs issued. (b) A genuine
    resolver-returned name→id lookup result (BC-8.4.001 step (2)) that unexpectedly fails to
    parse remains the pre-existing `JrError::Internal` outcome, unreachable with a real
    resolver. Implementation fix landing in parallel (S-605-2). Source: adversarial Step-4.5
    review finding.
  - F2 spec evolution, component-management bundle (2026-08-15, issues #604/#605/#606/#608): BC-3.4.022..025 ADDED — `issue create/edit --component` (issue #605): single-key native `update`-verb wire shape (022), multi-key bulk `multiselectComponents`/integer `componentId` wire shape (023, DEC-280), `create`'s bare additive body composition (024), and the resolver-mechanism decision (one round-trip via project components list, not duplicated with editmeta, 025). BC-3.4.017 UPDATED — Gate B scope extended 4→5 fields (`components` added), EC-3.4.017-15 added. BC-3.4.020 UPDATED — `--label` conflict-block flag list extended 12→13 (`--component` added). BC-3.4.012/013 UPDATED — `components` joins the field-echo key table (table-mode comma-joined action:name pairs; JSON-mode `changed_fields["components"]` is also a comma-joined `add:name`/`remove:name` string, matching the shared `BTreeMap<String,String>` model — the array-of-`{action,name}` shape is the dry-run `plannedChanges.components` form only, not `changed_fields`). BC-3.4.021 UPDATED — `plannedChanges.components` dry-run preview added (flat array, same convention as `labels`), EC-3.4.021-20 added. +4 new individually-bodied BCs (111→115); total_bcs 140→144. See `.factory/phase-f1-delta-analysis/delta-analysis-components.md`, `.factory/research/component-delete-and-bulk-wire-2026-08-15.md`.
  - F2 spec evolution, bucket1-defects bundle (2026-08-13, issue #692, DEC-274; adversary passes 1-4): BC-3.4.021 UPDATED — DEC-274 REVERSES Invariant 3: `--dry-run --description-stdin` now reads stdin and renders ADF (previously a placeholder, pinned as correct-not-a-bug); adversary pass-3 MEDIUM-1 extended the ADF-preview half to bare `--description` too (both flags now produce a `descriptionAdf` preview, closing a false-OK regression where a bare-flag depth-guard trip returned exit 0). New additive `plannedChanges.descriptionAdf` field (nested, preserves the "exactly three top-level keys" postcondition); `plannedChanges.description` continues to carry the raw input string verbatim for either flag (BC-3.4.013/#398 unaffected, no body edit). ECs: EC-3.4.021-6 rewritten; EC-3.4.021-15/-16 added pass-1/-2 (depth-guard Err → exit 64 in dry-run, split by `--output` mode after a pass-2→pass-3 channel correction — stderr carries the error envelope, stdout is always empty; successful multi-line/markdown render); EC-3.4.021-17 added pass-1 (empty-stdin, mirrors EC-3.4.013-13); EC-3.4.021-18/-19 added pass-3 (bare-`--description` happy path and depth-guard regression pin, mirroring -6/-15). VPs: VP-DRY-RUN-001 amended (derived-key carve-out); VP-692-001..004 added across pass-1/pass-3 (stdin happy-path, stdin depth-guard error [channel-corrected pass-3], bare-description happy path, bare-description depth-guard error). Pre-DEC-274 text retained inline in the BC's "Previous version" block; each corrected pass-2 error also retained inline as "INCORRECT, do NOT re-implement." No BC count change (still 111 individually-bodied). See `.factory/research/bucket1-692-dry-run-stdin-2026-08-13.md`.
  - L2: .factory/specs/domain-spec/bc-03-issue-write.md
  - Source broad: .factory/semport/jira-cli/jira-cli-pass-3-behavioral-contracts.md §2.3
  - Source R4: .factory/semport/jira-cli/jira-cli-pass-3-deep-r4.md §3.1
  - F2 addition (2026-05-15): BC-3.4.009 — bulk-poll timeout task_id contract (issue #340)
  - F2 addition (2026-05-18): BC-3.8.001..010 — JSM request submission (issue #288 F2 added 001..009; F1d pass-01 added BC-3.8.010 to close --type interaction)
  - F1d addition (2026-05-18): BC-3.8.010 — --type ignored with warning when --request-type is set (issue #288 adversary pass-01)
  - F1d addition (2026-05-19): BC-3.8.011 — platform-only flags emit stderr warnings on JSM path (issue #288 adversary-pass-01 C-02); H-01 BC-3.8.003 verb aligned "Use"→"Run"
  - F2 addition (2026-05-19): BC-3.8.012..013 — inverse warning symmetry: --field and --on-behalf-of silent-drop on platform path (issue #383)
  - F2 modified (2026-07-25): BC-3.8.012..013 — DEC-188 amendment: warn-and-proceed (exit 0) superseded by pre-flight JrError::UserError exit 64; BC-3.8.001 H1 qualification added; section retitled to Pre-flight Guards; AC-4 re-specified; asymmetry direction clarified (issue #639)
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
  - F2 gate closure DEC-170 fix round 49 (2026-07-11, spec v1.3.40): BC-3.5.012 EC-3.5.012-5 items (h)+(i) added — (h) docs/specs/json-output-shapes.md registry rows for all four comment-CRUD JSON shapes (VP-577-009/023 BTreeSet pins as source of truth); (i) docs/specs/comment-crud.md feature spec creation obligation following issue-move-resolution.md precedent (ADR-0004); BC-3.5.012 Trace updated; VP count unchanged (30)
  - v1.3.41 — DEC-174 mechanism-rationale correction in BC-3.5.003/006 delivery obligations + VP-577-030 (interact_on → ratified manual stderr-prompt equivalent); no behavioral change (2026-07-13, spec v1.3.41): BC-3.5.003 + BC-3.5.006 delivery-task obligations reworded — false claim that `dialoguer::interact_on(&Term::stderr())` reads from stdin replaced with ratified mechanism (DEC-174: `eprint!` prompt to stderr + `io::stdin().lock().read_line()`; `_interact_on` returns `Err(NotConnected)` on piped stderr before reading any input; empirically proven in F4); VP-577-030 updated to reference ratified mechanism; no BC/EC/VP behavioral semantics changed; BC and VP counts unchanged (120/30)
  - v1.3.42 — BC-3.5.006 deferred EJ probe obligation SATISFIED (2026-07-15): scheduled nightly run 29398774009 (2026-07-15T07:51Z, develop @ 56d5126, conclusion=success) executed `tests/e2e_live.rs::test_e2e_comment_edit_visibility_merge_semantics` green — MERGE verdict (Scenarios 1+3) and PRESERVED verdict (Scenario 2) confirmed live against EJ JSM project; delivery-task obligation item (b) marked SATISFIED; RESOLVED blocks in BC-3.5.006 body updated; no BC/EC/VP behavioral semantics changed; counts unchanged (120/30)
  - v1.3.45 — adversary pass-1 fix rounds A+B (2026-07-15, SOH-ATTACHMENTS-1): round A 20 corrections to existing BC text (ADV-001..022: command path, delete signature, write-to-temp, retry-rebuild, 214-byte UTF-8 truncation, selector-required, scope clarifications, error-string normalization, non-JSM terminology); round B +6 BCs (BC-3.9.015..020: delete confirmation gate DEC-174, bulk --older-than always-yes + clap mutual-exclusion, --replace-existing non-atomic JRACLOUD-96384/-78388, --replace-existing zero-match idempotent, --older-than duration.rs + chrono, --dry-run preview); scope expansion per human ruling R1/R2; total_bcs 134→140 / definitional_count 105→111
  - v1.3.43 — SOH-ATTACHMENTS-1 F2 addition (2026-07-15, DEC-179): Section 3.9 Attachment Write added (BC-3.9.001..014) — 14 individually-bodied BCs covering platform upload POST (X-Atlassian-Token, streaming, no client-size cap, 413/400), JSM default (internal by default P2-4a), --public two-step (DEC-174 gate), --internal two-step (OQ-9 non-JSM silent no-op), --public non-JSM exit 64, temporaryAttachmentId TTL, post-upload echo (P2-3c deferred S5), attachment delete (DEC-168/BC-3.5.004 precedent), JSON output shapes, error taxonomies, confirmation gate (eprint!+read_line, NOT dialoguer); counts: total_bcs 120→134 / definitional_count 91→105 / VP count unchanged (30)
  - v1.3.46 — GAP-R15-001 terminology sync in EC-3.5.003-3 + EC-3.5.008-5 (dialoguer→read_line Ok(0)/Err language; DEC-174 mechanism); no behavioral change (2026-07-16, spec v1.3.46): EC-3.5.003-3 and EC-3.5.008-5 headings and bodies reworded — stale “dialoguer::Error” terminology replaced with ratified DEC-174 mechanism (`io::stdin().lock().read_line()` returning `Ok(0)` (EOF) or `Err(_)` (IO error) → `JrError::Interrupted` exit 130; three-way branch `Ok(0)` vs `Ok(n)` vs affirmative — mirrors EC-3.9.015-5 phrasing added in P5-001); BC-3.5.003 and BC-3.5.008 Trace fields updated; no BC/EC/VP behavioral semantics changed; BC and VP counts unchanged (140/30)
  - v1.3.47 — P7 adversary fix round (2026-07-16, SOH-ATTACHMENTS-1): 0 new BCs — AID validation contract reversed across 5 delete surfaces BC-3.9.008/013/015/016/020 (P7-001 CWE-88; prior "does NOT validate" stance reversed; `^[0-9]+$` guard fires before all HTTP calls; canonical exit-64 string `"invalid attachment id: '<VALUE>' (must be numeric)"`); BC-3.9.018 gate suppression clause + EC-3.9.018-4 + EC-3.9.003-5 extension to zero-match path (P7-002; "one gate per invocation, ever"); BC-X.8.010 self-heal language softened (implementer's choice at S5 — minor fold-in); BC count unchanged (140/30)
  - v1.3.50 — P10 adversary fix round (2026-07-16, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.001 Content-Disposition filename clause pinned (P10-001); BC-3.9.017 step 1 cross-ref added; BC count unchanged (140/30)
  - v1.3.49 — P9 adversary fix round (2026-07-16, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.017 step 0 function citation corrected to 2-arg live signature `get_or_fetch_project_meta(client, project_key)` (`src/api/jsm/servicedesks.rs:~41`); key-derivation equivalence note added (P9-002); BC count unchanged (140/30)
  - v1.3.48 — P8 adversary fix round (2026-07-16, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.017 eligibility pre-flight step 0 (non-JSM `--public` exit 64 before list GET + destruction invariant generalized to cover eligibility guards; P8-002); BC-3.9.005 `--replace-existing` path note + EC-3.9.005-3 (P8-002); BC-3.9.012 400 row qualified as platform path + BC-3.9.006 step-2 4xx rationale reworded (expired temporaryAttachmentId / malformed body; P8-003); BC-3.9.020 single-ID dry-run AID validation bullet (P7-001 uniformity, P8-004); BC count unchanged (140/30)
  - v1.3.54 — P14 adversary fix round (2026-07-16, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.003 three-way branch (EOF→JrError::Interrupted exit 130; cancel→stderr; explicit branch (a)/(b)/(c)) + EC-3.9.003-6 (EOF exit 130) + EC-3.9.003-7 (guard precedence: non-JSM before non-interactive gate) (P14-001/P14-002/P14-003); BC-3.9.012 error-row "404 on issue meta fetch" wording corrected (P14-005); BC-3.9.014 EC-3.9.014-2 "Upload cancelled." channel fixed to stderr (P14-003); BC-3.9.015 cancel-channel divergence note + VP-576-002 (P14-003/P14-007); BC-3.9.017 VP-576-003 ordering invariant pin (P14-007); BC-3.9.020 retitled to cover upload path-c + EC-3.9.020-7 (--replace-existing --dry-run --public gate suppression) (P14-009/P14-010); double-`---` separator before BC-3.9.015 removed (P14-011); VP count 30→33; BC count unchanged (140/33)
  - v1.3.60 — P20 adversary fix round (2026-07-16, SOH-ATTACHMENTS-1): 0 new BCs / 2 new VPs / 1 new holdout — BC-3.9.004 Step 0 inheritance + full HTTP sequence for JSM branch (a) and non-JSM OQ-9 branch (b) enumerated (P20-001); BC-3.9.014 N≤3 prompt template `, ...` removed; `<filenameN>` placeholder used — ≤3 variant lists ALL filenames, no trailing ellipsis (P20-002); BC-2.7.007 `--out` unconditional step-1 clause added (P20-003); impact-boundary-576.md §1.1 download row retro-annotated (P20-004); prd-delta-576.md S3/S5 BC-3.9.017 split note added (P20-005); VP-576-004 (BC-2.7.002 attachment-object JSON transformation pin: self omitted + content→contentUrl) + VP-576-005 (BC-3.9.017 combined-gate single-prompt pin: --replace-existing --public ≥1 match → ONE prompt; --yes bypasses both; cancel → zero DELETE + zero POST) (P20-006); VP count 33→35; BC count unchanged (140/35); holdout count 98→99
  - v1.3.61 — P21 adversary fix round (2026-07-16, SOH-ATTACHMENTS-1): 0 new BCs / 0 new VPs / 1 new holdout — BC-3.9.010 bulk-404 body rewritten: 404 is NOT a failure on bulk path; benign-skip per EC-3.9.010-4/BC-3.9.013; single-vs-bulk 404 divergence cross-ref to BC-3.9.008/BC-3.9.013 added (P21-001); VP-576-005 fixture corrected: plain GET /rest/api/3/issue/EJ-1 removed; project key from string prefix per BC-3.9.017 step 0; strict-mode zero-plain-GET assertion added per EC-3.9.003-5 P17-003 (P21-002); BC-3.9.004 branch-(a) HTTP sequence expanded to BC-X.8.010 full resolution (up to 2 cache-miss GETs: GET /rest/api/3/project/{key} + GET /rest/servicedeskapi/servicedesk pagination for serviceDeskId) (P21-004); EC-3.9.004-4 added (Step-0 suppression when entered from BC-3.9.017 step 4 on --replace-existing --internal path; symmetric with EC-3.9.003-5 P17-003); BC-3.9.017 step 4 cross-ref BC-3.9.004 EC-3.9.004-4 added (P21-005); BC count unchanged (140/35); holdout count 99→100
  - v1.3.62 — P22 adversary fix round (2026-07-16, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.003 non-interactive exit-64 bullet corrected ('exit 64 before any HTTP' → 'exit 64 before any servicedeskapi call and before any upload POST — Step-0 issue GET and project-meta resolution already ran'; P22-001(a)); BC-3.9.012 non-interactive row trigger corrected ('local' → 'local (after Step-0 issue GET + meta fetch)'; P22-001(b)); mechanical sweep confirmed remaining 'before any HTTP' instances are genuinely pre-HTTP (P22-001(c)); H-NEW-ATTACHMENT-008/010 coherent with corrected phrasing (P22-001(d)); EC-3.9.016-6 reworded: 'proceed to BC-3.9.008' → 'issue the DELETE wire call of BC-3.9.008'; 404 handling per BC-3.9.013 bulk exception (benign skip) added (P22-002); BC count unchanged (140/35); holdout count unchanged (100)
  - v1.3.63 — P23 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — VP-576-005 explicit servicedesk-list mount (2) added (GET /rest/servicedeskapi/servicedesk, BC-X.8.010 cache-miss; was vaguely attributed to mount (1) as "+ service desk meta"; mounts renumbered 1→7; wire-completeness ECHO-BREAKER LIST-B enumeration added; P23-001); EC-3.9.020-8 added (--replace-existing --dry-run --public on non-JSM → eligibility guard fires at BC-3.9.017 step 0 before any list GET, exit 64, no preview emitted; P23-002); GATES vs ELIGIBILITY GUARDS distinction sentence added to EC-3.9.020-7 (P23-002); EC-3.9.005-3 extended with dry-run non-suppression cross-ref to EC-3.9.020-8 (P23-002); VP-576-005 story-allocation annotation added (verified in S5 not S3; S5 depends_on S3; textual home BC-3.9.017; NOT part of S3 acceptance matrix; contrast VP-576-003; P23-003); JSON Output Shape Contracts --replace-existing --dry-run row: --public wouldUpload "visibility":"public" note appended per EC-3.9.020-7 (P23-004); BC count unchanged (140/35)
  - v1.3.64 — P24 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.009 body download-exclusion fix (P24-001): "canonical attachment-object JSON shape across all `jr` attachment operations — upload, list, and download JSON outputs all use this shape" narrowed to "...for `jr` attachment upload and list operations — upload and list JSON outputs use this shape (download is excluded — it uses the distinct `{"downloaded":[...]}` manifest per the BC-2.7.002 authority clause and BC-2.7.007 EC-2.7.007-7)"; VP-576-004 story-allocation annotation added to bc-2-issue-read.md (P24-002): list half verified at S1 (BC-2.7.002 home); upload-platform-POST half verified at S3 (BC-3.9.009); full cross-path test lands at S3 — S3 depends_on S1 for shared curated-serialization plumbing (R3.13 earliest-consumer principle); NOT part of S1 acceptance matrix as a whole; BC count unchanged (140/35)
  - v1.3.66 — P26 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.019 Source field softened: `parse_age_duration` location TBD (`src/cli/issue/attachments.rs` private helper or `src/duration.rs` pub(crate) sibling, per impact-boundary R3.9a); BC-3.9.019 Trace updated (P26-004); BC count unchanged (140/35)
  - v1.3.67 — P27 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — JSON Output Shape Contracts download-row Notes updated: `filename` = RAW Jira name (pre-sanitization); `path` basename = on-disk name (post-sanitization; post-SHA-1-prefix for batch); single-id row references EC-2.7.007-7 (P27-001); batch row references EC-2.7.008-6 (P27-001); BC count unchanged (140/35)
  - v1.3.68 — P28 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — EC-3.9.020-8 wire enumeration corrected (P28-001): terminal clause "no HTTP calls beyond step-0 issue GET and meta fetch" replaced — no issue GET fires on the `--replace-existing` step-0 path (project key derived from issue-key string prefix); only project-meta fetch (`GET /rest/api/3/project/{key}`) fires; no `GET /rest/servicedeskapi/servicedesk` pagination since project is NOT `service_desk`; BC-3.9.020 Trace updated; BC-INDEX.md BC-3.9.020 row updated; BC count unchanged (140/35)
  - v1.3.70 — P30 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.003 step 1: self-heal sentence added (SEC-576-006/BC-X.8.010 invalidate+retry-once on step-1 404/403 BEFORE BC-3.9.012 mapping; post-retry exit codes per BC-X.8.010 step 4; P30-001); BC-3.9.012: step-1 attachTemporaryFile 403/404 carve-out added (BC-X.8.010 self-heal first; post-retry 404→exit 64, 403→exit 1; P30-001); BC-3.9.019: pre-deletion summary classified as HINT (JSON-suppressed; count in JSON envelope; EC-2.7.008-6; P30-002); BC-3.9.016: CLI flags `<AID>...` annotated (positional 1+ when used, optional under required selector group, bare `delete` → exit 2; P30-I01); ADR-0017: stale call-site corrected (issues.rs → attachments.rs per CONS-576-002; P30-003); BC count unchanged (140/35)
  - v1.3.71 — P31 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.012 step-1 carve-out extended: post-retry 401/5xx/network sentence added (a post-retry 401/5xx/network response maps per BC-X.8.010 step 4: 401 → exit 2; 5xx/network → exit 1 — same universal codes as first-occurrence; eliminates "first occurrence" ambiguity; P31-003); BC-3.9.012 Trace updated; BC count unchanged (140/35)
  - v1.3.73 — P33 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — footer corrected (P33-001): "Last updated" advanced from pass-30 to pass-31; P26/P27/P28 entries (v1.3.66/v1.3.67/v1.3.68) inserted between pass-30 and pass-24; P25/P29/P32 confirmed absent from bc-3 (no frontmatter trace entries, no body Trace citations); BC count unchanged (140/35)
  - v1.3.76 — P36 adversary fix round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.015 step 3 clarified: --yes path skips pre-prompt metadata GET (its sole purpose is the prompt filename; DELETE only, per BC-3.9.008; P36-002); BC-3.9.015 Trace updated (P36-002); BC-INDEX BC-3.9.015 row updated + index_version v6.32→v6.33; BC count unchanged (140/35)
  - v1.3.78 — Closing micro-round 1.3.77→1.3.78 (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — VP-576-003 assertion (b) reworded: self-contradictory parenthetical replaced with "BC-3.9.005 guard is inert here because --public is absent, so no JSM calls are made" (P40-I1); BC-3.9.008 AID validation CWE-88/CWE-22 dual-mapping note added at P7-001 definition site (P40-I2); BC-3.9.009 Trace P24-001 citation appended (INFO-NEW-5); BC count unchanged (140/35)
  - v1.3.80 — Security fix round SEC-576-v2 (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.015 step 1 display-sanitization cross-reference added (SEC-576-011 CWE-116); BC-3.9.017 step 2 display-sanitization cross-reference added (SEC-576-011 CWE-116); BC-3.9.015 and BC-3.9.017 Trace fields updated; BC count unchanged (140/35)
  - v1.3.82 — F3 adversary pass-3 micro-round (2026-07-17, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.020 EC-3.9.020-9 added (three-category dry-run taxonomy: pre-flight checks are NOT suppressed by --dry-run; P3-007); BC-3.9.010 EC-3.9.010-5 added (all-404 bulk-delete human-mode HINT message; P3-011); BC-3.9.010 Trace updated (P3-011); BC-3.9.020 Trace updated (P3-007); BC count unchanged (140/35)
  - v1.3.87 — F3 adversary pass-12 micro-round (2026-07-18, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.001 403 body text hedged (P12-003): prior unverified "Websudo required" string replaced with XSRF-related-rejection hedge; research file `.factory/research/issue-576-attachments-api-2026-07-15.md` §1e+§P2-1 documents XSRF guard but is SILENT on specific 403 body text; BC-3.9.001 Trace updated; BC count unchanged (140/35)
  - v1.3.88 — P20-ROUND micro-fix (2026-07-18, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.012/BC-3.9.013 error-table 401/network stderr cells corrected to loose-substring form (P20-002 root cause + INFO three-way divergence); prior cells pinned stale quoted strings (`"Not authenticated. Run \`jr auth login\`."` backtick/no-tail form; `"Could not reach <instance>: <reason>"` colon form) that diverged from `src/error.rs::JrError` actual rendering; replaced with "stderr contains" assertions + full-literal parentheticals sourced from `src/error.rs::JrError` + `src/api/client.rs::send_with_retry`; BC count unchanged (140/35)
  - v1.3.94 — PRE-F4-UNICODE-DISPLAY-SANITIZATION (2026-07-18, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.015 step 1 and BC-3.9.017 step 2 display-sanitization cross-ref wording updated — inline range replaced with pointer to BC-2.7.011 display-sanitization character set (preferred over re-stating range); BC-3.9.015/BC-3.9.017 Trace fields updated; BC count unchanged (140/35)
  - v1.3.99 — P2-3c probe obligation SATISFIED (2026-07-22, SOH-ATTACHMENTS-1, S-576-5): 0 new BCs — BC-3.9.007 Confidence MEDIUM→HIGH, heading updated, body rewritten (servicedeskapi step-2 returns AttachmentCreateResultDTO; jr extracts attachments.values[]; curate_jsm_attachment_entry performs defensive field-by-field curation confirmed by probe run 29940792930), EC-3.9.007-2 replaced (confirmed AttachmentDTO schema: created=object/iso8601, id=_links.jiraRest tail, contentUrl=_links.content; graceful fallbacks), Trace updated with probe runs 29936980027+29940792930+29945857059; BC-3.9.011 Confidence MEDIUM→HIGH, heading updated, body replaced with confirmed schema (bare curated array from attachments.values[]; EC-3.9.011-1 reclassified to confirmed shape + EC-3.9.011-3 added (no "public" key in output); EJ-teardown note updated from delivery-obligation to accepted-residual), Trace updated; BC-3.9.003 body output-channel sentence updated (P2-3c deferred→confirmed); JSON Output Shape Contracts table row updated (attachment upload --public/--internal: TBD→confirmed curated array shape, probe runs cited); BC count unchanged (140/35)
  - v1.3.100 — FIX-F5-006 F5-R1-007 fix round (2026-07-23, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.006 step-2 network branch split from 5xx: transport/network errors → `JrError::NetworkError` (exit 1, standard connectivity message `"Could not reach <host> — check your connection"`, no expired-ID retry hint); HTTP 5xx branch unchanged (`JrError::ApiError`, exit 1, retry hint); parity with step-1 transport mapping in BC-3.9.012; EC-3.9.006-6 added (transport/network case); "In both cases" language replaced with explicit HTTP-only retry-hint scope; BC-3.9.006 heading and Trace updated; BC-INDEX BC-3.9.006 row updated; BC count unchanged (140/111)
  - v1.3.101 — BC-3.9.006 Trace citation refresh post FIX-F5-006/007 merges (2026-07-24, SOH-ATTACHMENTS-1, F5-R3-003): 0 new BCs — BC-3.9.006 Trace updated: stale `tests/attachment_jsm.rs::test_bc_3_9_006_step2_network_error_appends_retry_hint` (pre-rename, wrong file, "not yet on develop" note) and stale `inline unit test test_f5_r1_007_step2_network_error_uses_canonical_network_error_variant in src/api/jsm/attachments.rs` (no backticks, "worktree fix branch only" note) replaced with `src/api/jsm/attachments.rs::tests::test_bc_3_9_006_step2_network_error_uses_connectivity_message_no_retry_hint` (renamed; on develop) and `src/api/jsm/attachments.rs::tests::test_f5_r1_007_step2_network_error_uses_canonical_network_error_variant` (on develop); both tests are inline in `src/api/jsm/attachments.rs`, not in `tests/attachment_jsm.rs`; BC count unchanged (140/111)
  - v1.3.105 — P8-001/F5-R8-001 deliberate-asymmetry note (2026-07-24, SOH-ATTACHMENTS-1): 0 new BCs — BC-3.9.006 heading, 4xx bullet, and EC updated: HTTP 429 deliberately falls into generic 4xx→exit 64 bucket with no Retry-After auto-retry loop, asymmetric with step-1 `attachTemporaryFile` (retries 429 per BC-X.8.010) and platform upload path (retries 429 via `send_with_retry`); rationale recorded: step-2 is a single small JSON POST issued immediately after step-1 succeeds; rare 429 there; ~1 h temp-attachment TTL makes manual re-run safe; blast radius low; carve-out explicitly deferred at SOH-ATTACHMENTS-1 wave gate (P8-001); hint-text imprecision honestly noted (`"Temporary attachment IDs may have expired. Try the upload again."` is inexact for 429 sub-case) — accepted; dedicated 429 arm with Retry-After parsing = candidate future enhancement, not defect; EC-3.9.006-7 added (429 deliberate-asymmetry sub-case); BC count unchanged (140/111)
  - v1.3.107 — SOH-DX-1 DEC-188 F2 amendment (2026-07-25, #639): 0 new BCs — BC-3.8.012 amended (superseded-in-part): warn-and-proceed (exit 0) → pre-flight JrError::UserError exit 64 BEFORE any HTTP; ONE error regardless of --field count; combined error when both --field and --on-behalf-of present without --request-type; BC-3.8.013 amended (superseded-in-part): same pattern for --on-behalf-of; asymmetry rationale encoded (self-declared JSM-only flags → exit 64 caller-error; general platform flags → warn-and-degrade); BC-3.3.001 amendment note updated (exit-64 replaces warn-and-continue); BC-INDEX v6.44→v6.45; spec v1.3.107; BC count unchanged (140/111)
  - v1.3.108 — SOH-DX-1 DEC-188 round-10 spec-text corrections (2026-07-26, #639): 0 new BCs — BC-3.8.013 error string parenthetical removed ("reporter identity is not settable post-creation via platform" factually wrong per CLAUDE.md citation discipline; JIRA edit path exists for settable fields); AC-12 renamed + help-text pin (verbatim "requires --request-type" substring per delivery item (d)); ADR-0014 delivery section corrected to enumerate all 3 amendment sites explicitly; AC namespace note added (BC-3.8.012 Trace + BC-3.8.013 Trace pointer: S-639-1 ACs supersede S-383 same-numbered ACs); `assert_json_error_envelope` promotion directive finalized (DELETE original fn from `tests/json_error_shape.rs`; three call sites re-import from `tests/common/fixtures.rs`); BC count unchanged (140/111)
  - v1.3.109 — SOH-DX-1 DEC-188 round-11 adversary-pass corrections (2026-07-26, #639): 0 new BCs — combined error string parenthetical trimmed (F11-01: "(then use jr issue edit --field for custom fields; --on-behalf-of has no platform equivalent)" removed; same citation-discipline class as round-10 BC-3.8.013 single-flag fix); BC-3.8.013 prose hedged (F11-01: "must be set at JSM request creation time" replaced with permission-dependent remedy); AC-12 dual-assertion re-spec (F11-02: two per-flag scoped occurrences required, not single contains()); delivery item (d) FIRST-LINE-ONLY clarification (F11-03: subsequent doc lines preserved; clap-wrapping note); vacuity rationale at Removal postcondition (F11-04: regression-pin explanation + AC-4 asymmetry); AC-17/18/19 added (F11-05: EC-3.8.012-5/7/9 coverage — --markdown+--field, --description-stdin+--field, --field ""); AC namespace note range AC-1..16→AC-1..19; BC-3.8.013 Trace pointer updated to AC-1..19; BC-INDEX BC-3.4.014 row DEC-188 qualifier (F11-06); spec-changelog [1.3.107] Type MINOR→PATCH (process-gap); BC count unchanged (140/111)
  - v1.3.110 — SOH-DX-1 DEC-188 round-12 adversary-pass corrections (2026-07-26, #639): 0 new BCs — output-mode annotation per AC (F12-05: AC-1/2/5/7 [mode: --output json]; AC-3/AC-19 [mode: human]; AC-3 and AC-19 stdout.trim().is_empty() assertions added); SSOT step 4a added (F12-06: --description-stdin blocking read cite, create.rs::handle_create ~:132-145, between step 4 and step 5; EC-3.8.012-7 guard fires at step 2 so step 4a unreachable on guarded path); helper-promotion directive extended in both BC-3.8.012 and BC-3.8.013 Test Notes (LOW-1: stale doc-comment fix note — {"error":…,"code":…} → {"code":…,"error":…} BTreeMap alphabetical); BC-INDEX section 3.8 header "superseded"→"amended" (LOW-2); BC count unchanged (140/111)
  - v1.3.111 — SOH-DX-1 DEC-188 round-13 adversary-pass corrections (2026-07-26, #639): 0 new BCs — AC-8 citation corrected (F13-01: get_myself cite fixed to resolve_assignee_by_project ~:436/~:443 → JiraClient::get_myself users.rs::get_myself ~:19); AC-11 false-green hardened (F13-02: MUST NOT --no-input + MUST NOT --project preconditions explicit; discriminators enumerated; main.rs ~:103-114 cite); AC-12 wrap-fragility fixed (F13-03: whitespace-normalization mandatory before count — split_whitespace+join(" ") or equivalent; newline-split failure mode documented); AC-9 second precondition added (F13-04: profile config must lack project key; write_minimal_config ~:165-173 cite); BC count unchanged (140/111)
  - v1.3.112 — SOH-DX-1 DEC-188 round-14 adversary-pass corrections (2026-07-26, #639): 0 new BCs — AC-1/AC-2/AC-7 fully re-specified (F14-01: exit 64 + positive error substring + assert_json_error_envelope + stdout.trim().is_empty() + OLD ASSERTIONS removal mandates with tilde cite lines); AC-11 discriminators corrected (F14-02: removed false "no prompt on stdout" claim; noted expect(0) non-discriminating; added !stderr.contains("Project key") as required real discriminator; cited dialoguer 0.12 stderr rendering helpers.rs ~:224-226); Removal postcondition extended (LOW-1: AC-1 stdout negative ~:2479-2482 vacuity noted, replace with stdout.trim().is_empty()); EC-3.8.012-9 re-scoped (LOW-2: --field "" (no =) is EC-3 malformed class; EC-9 → --field a= key-present-empty-value case; AC-19 invocation updated accordingly); mode annotations completed (LOW-3: AC-4/AC-6 json; AC-8/9/11 human; AC-12 human help; AC-13..18 human); BC count unchanged (140/111)
  - v1.3.164 — SOH-DX-1 F2 holdout authoring (2026-07-29, #639, DEC-188): 0 new BCs / 0 new VPs / 6 new holdouts — H-NEW-PREFLIGHT-001..H-NEW-PREFLIGHT-006 added to holdout-scenarios.md Group 20 (BC-3.8.012: --field pre-flight guard; BC-3.8.013: --on-behalf-of pre-flight guard); BC-3.8.012 Trace updated with H-NEW-PREFLIGHT-001/003/004/005/006; BC-3.8.013 Trace updated with H-NEW-PREFLIGHT-002/003/004/005; Note (coverage non-goal) in BC-3.8.012 and BC-3.8.013 updated to acknowledge F2 gate human ruling override of F51-001 non-goal; holdout count 100→106; CANONICAL-COUNTS.md, README.md, spec-changelog.md updated; spec v1.3.164; BC count unchanged (140/111)
  - v1.3.162 — P73-001 (REFINEMENT, LOW): pending-revert annotations added to BC-3.9.001 and BC-3.9.003 Trace fields (2026-07-28): inline notes flag "encoding-test" and "wiremock-test" hyphenation (8a0a2422 workaround) as pending revert by S-627-1 once scripts/check-bc-no-numeric-test-counts.sh guard-regex fix merges to develop; no BC behavioral changes; BC count unchanged (140/111)
  - v1.3.160 — P72-001 HIGH false-serde_json-claim correction in EC-3.4.015-4a (2026-07-28): 0 new BCs — EC-3.4.015-4a rewritten: false claim that `serde_json::Number::from_f64(5.0)` serializes as `5` removed; correct mechanism stated: `src/cli/issue/field_resolve.rs::parsed_number_to_wire_value` takes integer branch `Number::from(parsed as i64)` when `fract() == 0.0` AND strictly within i64 bounds; falls through to `json!(parsed)` for out-of-range inputs (EC-3.4.015-4b coherence); explicit "MUST NOT use `from_f64` for whole numbers" warning added; `5e3`→`5000` re-attributed to integer branch; `5.5`→`5.5` re-attributed to `json!` f64 path; VP-396-010 pin retained; BC count unchanged (140/111)
  - v1.3.159 — F67-001/F67-002 LOW ordering-sentence precision + AC .current_dir() rationale corrections (2026-07-28): 0 new BCs — F67-001 (LOW, delta-attributable): BC-3.8.012 combined-check ordering sentence broadened — "before the individual `--field`-only check" → "before BOTH individual single-flag checks (the `--field`-only check and the `--on-behalf-of`-only check)"; was one-sided: an implementation ordering the `--on-behalf-of`-only guard first satisfied the sentence while violating EC-3.8.012-1; precision defect only (EC-3.8.012-1 and AC-13 cover the gap normatively); BC-3.8.013 carries no mirrored ordering statement (defers to BC-3.8.012 as governing BC — no change required); F67-002 (LOW, delta-attributable): AC-9/AC-11/AC-16/AC-17 `.current_dir()` precondition rationale corrected — false "degrades discriminating power" claim replaced with correct hygiene rationale (ancestor-config isolation prevents inherited credentials from enabling a live HTTP escape); all four ACs are projectless + lack `--type` so guard-absent path fails on missing `--type` before any HTTP regardless of inherited project key — discriminating power genuinely unaffected; AC-16 part (a) corrected, part (b) credential-escape rationale preserved unchanged; AC-10 NOT corrected (would-otherwise-succeed invocation supplies `--project`/`--type`/`--summary`; text says "silently interferes" not "degrades discriminating power"); BC count unchanged (140/111)
  - v1.3.158 — F66-001 LOW malformed-field literal propagation completion (2026-07-28): 0 new BCs — F66-001 (LOW, delta-attributable): BC-3.8.012 Behavior block (~:3076) and EC-3.8.012-3 (~:3088) aligned to current literal `bareflagnoequals` — both retained stale `bare-name-no-equals` from before v1.3.142 F44-003 LOW-1 AC-7 rename; v1.3.142 propagated the AC-7 KEPT note only, leaving these two body sites unamended; three historical records (frontmatter trail v1.3.142 line 138, frontmatter trail v1.3.131 line 149, footer line 4069) deliberately preserved unchanged as immutable audit records of the v1.3.142 rename itself; BC count unchanged (140/111)
  - v1.3.157 — F65-001 MEDIUM/F65-002 LOW citation correction and AC-expansion directive (2026-07-28, #639): 0 new BCs — F65-001 (MEDIUM, delta-attributable): BC-3.8.012 Trace obligation (g) trailing citation corrected — bare `delta-analysis.md` line 81 reference (introduced by v1.3.156) was ambiguous between `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` (correct target: #639 regression-risk row) and `.factory/phase-f1-delta-analysis/delta-analysis.md` (wrong file, different content at line 81); replaced with full-path section-form `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md § "2. Regression Risk Assessment" (#639 row, `src/cli/issue/create.rs`) per CLAUDE.md citation-form convention (recurrence of CITATION-FORM-DISCIPLINE drift item; bare filename violated "prefer symbol-form / never bare `<file>:NN-MM`"); v1.3.156 frontmatter trail entry and footer `Previous update 2026-07-28 (v1.3.156)` text left unchanged as immutable historical records; F65-002 (LOW, delta-attributable): BC-3.8.012 Trace AC namespace note gains F3 story expansion directive — clarifies that "verbatim" governs content (invocations, assertions, labels, error strings) not line formatting; `.factory/stories/S-576-3.md` named as multi-line `### AC-NNN` format reference for F3 story authoring; BC count unchanged (140/111)
  - v1.3.156 — F64-001 LOW E2E scan obligation discharged at F2 (2026-07-28): 0 new BCs — F64-001 (LOW): delta-attributable; F1 obligation (`delta-analysis.md` line 81, #639 regression-risk row for `src/cli/issue/create.rs`) required scanning `tests/e2e_live.rs` for `issue create` invocations carrying `--field` or `--on-behalf-of` without `--request-type`; scan performed and recorded: zero such invocations found; all 8 `--field` occurrences are `issue edit --field` (live call site ~:5111; remainder are doc-comment and env-var-table references for `JR_E2E_EDIT_FIELD`); zero `--on-behalf-of` occurrences; conclusion: no live-run scenario flips to exit-64 under DEC-188; no E2E test changes required at F4; obligation recorded as discharged item (g) in S-639-1 delivery (F4) obligations (BC-3.8.012 Trace); BC count unchanged (140/111)
  - v1.3.155 — F63-001 MEDIUM/F63-002 LOW README H-NEW-JSM-RT range terminus correction (2026-07-27): 0 new BCs — F63-001 (MEDIUM): README.md both H-NEW-JSM-RT range terminus claims corrected `..006` → `..007` (verified maximum H-NEW-JSM-RT-007 in holdout-scenarios.md): line 48 (Files table) wrong since v1.3.143, line 108 (Supplement Index) introduced by v1.3.154 orchestrator instruction — that instruction inferred `..006` as the maximum without verifying against holdout-scenarios.md (orchestrator error, correction belongs here, not in a rewrite of the v1.3.154 history entry); F63-002 (LOW): line 108 Supplement Index row lacked the informational caveat present on line 48 Files-table row — identical caveat `(informational; canonical count is \`total_holdouts:\` frontmatter in holdout-scenarios.md)` added after enumeration closing paren; twin-artifact sweep (recurrence 16): CANONICAL-COUNTS.md `..007` CORRECT (reference that exposed defect); phase-1-consistency-audit*.md `..005` and STORY-INDEX.md `..004`/`..005` are HISTORICAL SNAPSHOTS (immutable); observation: H-018 absent from H-001..H-047 span (46 of 47 present); total count (100) correct and guard-consistent; most likely deliberately retired (unverified intent, flagged for future maintainer); BC count unchanged (140/111)
  - v1.3.154 — F62-001 MEDIUM/F62-002 LOW holdout-count partial-propagation fix and changelog BC Count completion (2026-07-27): 0 new BCs — F62-001 (MEDIUM): README.md Supplement Index row (line 108) count `55` → `100`; range terminus `H-NEW-JSM-RT-001..005` → `H-NEW-JSM-RT-001..006`; v1.3.143 F45-003 fixed only the Files-table row (line 48), leaving the Supplement Index row stale; the Supplement Index row is consumed by the Holdout-evaluator and understated scope by 45 scenarios; F62-002 (LOW): spec-changelog [1.3.113] and [1.3.114] entries each lacked a `### BC Count` section; sections added after `### Changed` blocks, matching [1.3.112] structural pattern (0 new BCs; 657/140/111 unchanged); twin-artifact sweep (recurrence 15) confirmed no other stale site; BC count unchanged (140/111)
  - v1.3.153 — F60-001 LOW README L3 BCs metric correction (2026-07-27): 0 new BCs — F60-001 (LOW): README.md bc-3-issue-write.md row "L3 BCs" column corrected from `(111)` → `(140)`; column convention is `total_bcs` (cumulative, incl. range-collapsed), consistent with bc-1-auth-identity `(57)` = `total_bcs: 57` and bc-4-assets-cmdb `(32)` = `total_bcs: 32`; bc-3 was the only row using `definitional_count` (111) instead; `total_bcs: 140` and `definitional_count: 111` frontmatter are correct and unchanged; BC count unchanged (140/111)
  - v1.3.152 — F57-001 LOW AC-17 assertion-substring narrowing (2026-07-27): 0 new BCs — F57-001 (LOW): AC-17 (`test_platform_create_markdown_with_field_exits_64_bc_3_8_012_not_markdown_error`) negative assertion narrowed from bare `"cannot be combined with"` to `` "cannot be combined with `--markdown`" `` — the bare prefix is shared with `src/cli/issue/edit.rs::handle_edit`'s `"--label cannot be combined with"` message (unreachable from `handle_create`, so no live false-positive), but the broad substring made the assertion mean less than the HYGIENE rationale claimed; the narrowed form matches BC-3.8.017's literal exactly; HYGIENE label, existing rationale, and all other AC-17 assertions unchanged; BC count unchanged (140/111)
  - v1.3.151 — F56-001 MEDIUM false-assert_cmd-premise fix in AC-18 (2026-07-27): 0 new BCs — F56-001 (MEDIUM): AC-18 non-normative rationale note corrected — false premise "assert_cmd provides no timeout primitive" deleted; two previously-conflated assertions separated: (1) "process exits promptly" IS testable via assert_cmd's public `Command::timeout` method (present in assert_cmd 2.2.2, verified against Cargo.lock); (2) "stdin NOT consumed" is still NOT testable (a timeout proves no hang, not that stdin was never read); explicit design decision (ii) recorded: timeout assertion declined as normative — wall-clock assertions are CI-flaky and add no discriminating power over the existing exit-64 + stderr.contains pair; BC count unchanged (140/111)
  - v1.3.150 — SOH-DX-1 F2 error-taxonomy DEC-188 registration (2026-07-27, F52-001): 0 new BCs — F52-001 (LOW): error-taxonomy.md Section 6 gains new Issue Commands subsection registering three DEC-188 pre-flight exit-64 error conditions (BC-3.8.012: --field without --request-type; BC-3.8.013: --on-behalf-of without --request-type; combined: both flags present, BC-3.8.012 governs); all three are JrError::UserError, zero HTTP on each path; verbatim error strings copied character-for-character from bc-3-issue-write.md fenced blocks; BC count unchanged (140/111)
  - v1.3.149 — SOH-DX-1 F2 coverage-rationale non-goal documentation (2026-07-27, F51-001): 0 new BCs — F51-001 (LOW): holdout-scenario and VP coverage documented as deliberate non-goal in BC-3.8.012 and BC-3.8.013 — terminal **Note (coverage non-goal)** added to each BC; 21 ACs cover every observable exit path; pure pre-flight input validation with no network interaction excludes holdout surface; contrast with VP-331-003 (BC-3.4.019) cited; BC count unchanged (140/111)
  - v1.3.148 — SOH-DX-1 F2 BC-3.8.013 doc-fallout enumeration fix (2026-07-27, F49-001): 0 new BCs — F49-001 (LOW): doc-fallout deliverables sentence corrected — obligation (d) added to parenthetical (`src/cli/mod.rs` `--on-behalf-of` first doc line ~:403 MUST gain `"requires --request-type"` substring, pinned by AC-12: count==2 requires BOTH help lines updated); delegation marked NORMATIVE; enumeration marked non-exhaustive; BC-3.8.012 Trace (a)–(f) declared authoritative and binding; BC count unchanged (140/111)
  - v1.3.147 — SOH-DX-1 F2 spec delta AC-7 EC linkage fix (2026-07-27, F48-001): 0 new BCs — F48-001 (LOW): EC-3.8.012-3 as test linkage marker added to AC-7 (`test_platform_create_malformed_field_without_request_type_exits_64`) — malformed `--field` case (`--field bareflagnoequals`) was the only testable EC in BC-3.8.012/013 with no explicit AC citation; all other testable ECs use uniform `"EC-<id> as test — "` prefix (AC-9/13/14/15/16/17/18/19); AC-7 semantically covers EC-3.8.012-3 (guard fires on `!field_pairs.is_empty()` before value parsing; malformed format does not affect guard activation); traceability linkage only — no behavioral or test change; BC count unchanged (140/111)
  - v1.3.146 — SOH-DX-1 F2 round-47 write_profile_config-placement fix (2026-07-27, F47-001): 0 new BCs — F47-001 (LOW): write_profile_config destination corrected in both Test Note Config fixture contracts (BC-3.8.012 + BC-3.8.013) — `tests/common/assertions.rs` → `tests/common/fixtures.rs`; "same promotion target as `assert_json_error_envelope`" phrase removed and replaced with DIFFERENT-destinations rationale; rationale recorded: `fixtures.rs` is the home for non-assertion test fixtures generally, including config writers; F46-003 "pure-JSON" charter narrowed to payload fixtures only; secondary historical-record cleanup: footer v1.3.137 description corrected (`tests/common/assertions.rs` → `tests/common/fixtures.rs` for write_profile_config; same F46-003 sweep class, not restored by v1.3.145 which fixed frontmatter trail entries only); BC count unchanged (140/111)
  - v1.3.145 — SOH-DX-1 F2 round-46 trail-anachronism remediation (2026-07-27): 0 new BCs — F1 (LOW): v1.3.114 trail entry restored — `tests/common/assertions.rs ~:76` reverted to `tests/common/fixtures.rs ~:76` in F16-03 first clause (unintended replace_all sweep from v1.3.144 F46-003); F2 (LOW): v1.3.108 trail entry restored — `tests/common/assertions.rs` reverted to `tests/common/fixtures.rs` in assert_json_error_envelope promotion directive (unintended replace_all sweep); F3 (LOW): v1.3.137 trail entry restored — `tests/common/assertions.rs` reverted to `tests/common/fixtures.rs` in write_profile_config fixture contract description (unintended replace_all sweep); F4 (LOW): spec-changelog.md [1.3.144] F46-003 scope statement corrected from "replace_all on all promotion-target path references" to "(9 sites: 5 spec body + 3 historical trail entries + 1 footer)"; unintended-anachronism note added referencing [1.3.145]; F5 (LOW): v1.3.144 frontmatter trail entry F46-003 clause corrected from "replace_all on promotion-target path (5 sites)" to "(9 sites: 5 spec body + 3 historical trail entries + 1 footer)"; unintended-anachronism note added referencing [1.3.145] (in-round residual of F4; TWIN-ARTIFACT-SWEEP class — second mirroring artifact aligned); BC count unchanged (140/111)
  - v1.3.144 — SOH-DX-1 DEC-188 round-46 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F46-001 (MED): AC-2 and AC-7 gain explicit would-otherwise-succeed clause ("invocation is would-otherwise-succeed — mount_platform_create_stubs MUST be called so the platform POST can complete if the guard is absent; only a would-otherwise-succeed run makes stdout.trim().is_empty() a genuine DISCRIMINATING assertion rather than HYGIENE"); F46-002 (LOW): both [CURRENT BEHAVIOR] body-range labels reworded from "excluded terminal case" phrasing to "BEFORE all pre-POST helper HTTP (steps 3–5) and BEFORE the platform POST (step 6) — see Platform-Path Guard Ordering block above" (replace_all, 2 sites); F46-003 (LOW): promotion target for assert_json_error_envelope and write_profile_config changed from tests/common/fixtures.rs → tests/common/assertions.rs (new module registered in tests/common/mod.rs; keeping fixtures.rs pure-JSON); replace_all on promotion-target path (9 sites: 5 spec body + 3 historical trail entries + 1 footer); the 3 trail-entry sweeps were unintended anachronisms corrected in [1.3.145]; convention note "fixtures.rs convention" → "assertions.rs convention" + mod.rs registration note added (both Test Notes, replace_all); BC count unchanged (140/111)
  - v1.3.143 — SOH-DX-1 DEC-188 round-45 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F45-001 (MED): deliverable (e) gains THIRD stale-parity site `tests/issue_create_jsm.rs` ~:2373-2374 (same false platform-parity claim + dead "create.rs lines 333-343" citation; markdown-requires-description string exists only in `jsm_create.rs` ~:175 + `edit.rs` ~:89); F45-002 (MED): banner-rewrite obligation extended to FAMILY-level banner at `tests/issue_create_jsm.rs` ~:2381-2391 — THREE false clauses enumerated: "Platform-path inverse warnings" framing historical; "Red Gate: all 7 tests MUST fail" inverted post-DEC-188; "2 eprintln! guards" removed by DEC-188; F45-003 (MED): README.md holdout row count 55→100 + range includes H-NEW-JSM-RT-006 + informational caveat; BC count unchanged (140/111)
  - v1.3.142 — SOH-DX-1 DEC-188 round-44 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F44-001 (MED): false Hygiene premise "tests/json_error_shape.rs currently has no mod common; import" deleted from both Test Note Hygiene sections (replace_all, 2 sites); only the verified-true tests/issue_create_jsm.rs gains statement retained; F44-002 (MED): "BC-3.8.011 direction" → "BC-3.8.010 + BC-3.8.011 directions" at both sites in EC-3.8.012-10 + delivery obligation (a) (replace_all, 2 sites); F44-003 (MED): AC-11 item (4) relabeled DISCRIMINATING → HYGIENE (projectless: guard-absent also exits 64 on project error; matches AC-9/AC-17; discriminating proof = items (1)+(2)); "Required discriminators" intro rephrased to "Required assertions (items (1)+(2) discriminating; items (3)/(4)/(5) hygiene)"; LOW-1: AC-7 KEPT note "bare-name-no-equals" → "bareflagnoequals"; LOW-2: "steps 3–6" → "steps 3–5 (pre-POST helper HTTP); step 6 (POST) is the excluded terminal case — see SSOT block for the authoritative enumeration" at both [CURRENT BEHAVIOR] sites (replace_all, 2 sites); BC count unchanged (140/111)
  - v1.3.141 — SOH-DX-1 DEC-188 round-43 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F43-01 (MED): AC-11 Required discriminators "these three together" → "these five together"; (4) exit 64 (`cmd.assert().failure().code(64)`, DISCRIMINATING per mode-agnosticism invariant — pins TTY/interactive path also exits 64) and (5) `stdout.trim().is_empty()` (output-channel hygiene) added after item (3); closes the only interactive-mode falsifier gap; F43-02 (MED): AC-16 gains **Precondition:** MUST use `.current_dir(<per-test TempDir>)` — `find_project_config` ~:362 walk-up; doubly important: (a) projectless AC, (b) FULL-STRING single source for BC-3.8.013 verbatim string (ancestor `.jr.toml` with credentials risks live HTTP mutation); Obs: "steps 3–5" → "steps 3–6" at both [CURRENT BEHAVIOR] Behavior block sites (POST is the excluded terminal case); BC count unchanged (140/111)
  - v1.3.140 — SOH-DX-1 DEC-188 round-42 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F42-01 (MED): spec-changelog [1.3.139] entry gains ### Changed block (bc-3-issue-write.md + BC-INDEX.md + spec-changelog.md) + correct two-surface BC Count ("0 new BCs. Total unchanged: 657 cumulative (BC-INDEX), 140/111 individually-bodied"); O-1 (LOW): mode-agnosticism invariant restored to BOTH [CURRENT BEHAVIOR] Behavior blocks — "The guard fires regardless of --no-input or --output json settings (mode affects only the error rendering channel/shape, per the Test Notes)." — inserted before MUST-NOT constraint at both BC-3.8.012 and BC-3.8.013 sites; O-2 (LOW): MUST-NOT falsifier enumeration softened at both sites — "falsified by (non-exhaustively) AC-1/AC-2/AC-16 — any AC asserting the guard string on a guarded-flag invocation falsifies a requires realization; AC-15 alone is insensitive (clap exit-2 either way)"; BC count unchanged (140/111)
  - v1.3.139 — SOH-DX-1 DEC-188 round-41 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F41-01 (MED): AC-13 invocation upgraded to would-otherwise-succeed form (--project PROJ --type Task --summary "test" added); Discrimination note updated (would-otherwise-succeed parenthetical replaces "--project NOT required"); zero-HTTP rationale updated (guard-absent path now reaches HTTP, making received_requests().is_empty() genuinely NORMATIVE; mount_platform_create_stubs NOT called — isolated MockServer only); F41-02 (MED): AC-1 REGRESSION PIN gains "(DISCRIMINATING subtype)" parenthetical (first use per §"AC namespace note") + policy note (later ACs AC-2/3/5/7/8/9/10/11/13/17/18/19 may keep or drop parenthetical; both correct); F41-04 (nit): write_profile_config first param dir → config_home at both Config fixture contract sites (matches write_minimal_config semantics; prevents silently-wrong fixture); BC count unchanged (140/111)
  - v1.3.138 — SOH-DX-1 DEC-188 round-40 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F40-001 (HIGH): REGRESSION PIN added to AC-9/AC-10/AC-11/AC-17/AC-18 bodies (mandate list AC-1/2/3/5/7/8/9/10/11/13/17/18/19 now fully propagated to all 13 AC bodies); AC-19 added to non-vacuity sentence enumeration (AC-1/2/3/5/7/8/9/10/11/13/17/18 → AC-1/2/3/5/7/8/9/10/11/13/17/18/19); F40-002 (MED): Definition (unconditional remedy) added inline to uniform rule — a remedy is unconditional if it depends only on the user's own invocation, not on project permissions, project type, or post-creation steps; 'Add --request-type <NAME>' qualifies; 'then use jr issue edit --field' does NOT qualify; closes two-ways reading without changing any verbatim error string; Obs: spec-changelog [1.3.133] F35-1 gains "[superseded by 1.3.136: §42-45 excluded; four sites final]" note; BC count unchanged (140/111)
  - v1.3.137 — SOH-DX-1 DEC-188 round-39 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F-1 (MED): Removal postcondition uniform rule qualified to "every AC that reaches handle_create with a guarded flag and no --request-type"; AC-15 exclusion added (clap conflicts_with exit-2 pre-handler; guard never evaluated); F-2 (MED): write_profile_config specified in both Test Note Config fixture contracts — lives in tests/common/fixtures.rs (same promotion target as assert_json_error_envelope); signature write_profile_config(config_home: &Path, base_url: &str); shape modeled on tests/issue_create_jsm.rs ~:1959-1966 (default_profile = "default" + [profiles.default] url/auth_method); F-3 (LOW): EC-3.8.012-10 gains "Transitively falsified by AC-8/AC-13's received_requests().is_empty() — any project-type gate would require HTTP; no dedicated AC needed."; Obs-1: [1.3.136] changelog entry gains ### BC Count + ---; Obs-2: frontmatter trace v1.3.114 moved to correct descending position (between v1.3.115 and v1.3.113); Obs-3: README bc-3 "(107)" → "(111)"; BC count unchanged (140/111)
  - v1.3.136 — SOH-DX-1 DEC-188 round-38 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F-1 (MED): "write_minimal_config REPLACED by write_profile_config" DELETE-mandate note added to AC-2/AC-5/AC-7 (clarifies KEPT contradiction; satisfies Config fixture contract); F-2 (MED, RULING): conditional remedy tail "(then use `jr issue edit --field` to set fields afterward)" stripped from BC-3.8.012 single-flag verbatim error string and AC-1 FULL-STRING pin; uniform rule stated ("verbatim error strings carry only unconditional remedies") added to Asymmetry rationale block; F-3 (MED): EC-3.8.012-10 §42-45 mis-scoped claim corrected — "deliberately reverses §42-45" replaced with byte-for-byte stability sites amendment citation; deliverable (a) "five sites"→"four sites", §42-45 excluded from amendment (antecedent is BC-3.8.011 direction, unchanged by DEC-188); F-4 (MED, RULING): deliverable (f) added — docs/specs/issue-create-preflight-guards.md feature spec at F3; no-ADR rationale recorded; F-5 (LOW, uniform rule): REGRESSION-PIN mandate extended to AC-1/2/3/5/7/8/9/10/11/13/17/18/19 (was AC-1/2/3/5/7/13/19); uniform rule sentence added; AC-8 both invocations gain REGRESSION PIN (in-round residual, same version); F-6 (LOW): AC-13 gains received_requests().is_empty() zero-HTTP assertion on isolated MockServer; BC count unchanged (140/111)
  - v1.3.135 — SOH-DX-1 DEC-188 round-37 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F-1 (HIGH): both Test Notes gain Config fixture contract (single source — callers of `assert_json_error_envelope` MUST use pre-migrated `[profiles.default]`-shaped fixture; `write_minimal_config` legacy `[instance]` shape triggers `src/config.rs` ~:255-287 migration line poisoning strict JSON parse); AC-2/AC-7/AC-10 each gain Precondition note citing contract; doc-comment fix mandate softened (parse, don't match); LOW-2 Test Note Hygiene extension: `tests/issue_create_jsm.rs` similarly gains `#[allow(dead_code)] mod common;` at same step (AC-2/AC-7 import promoted helper there); F-2 (HIGH): AC-5 gains Precondition for pre-migrated fixture (invocation (i) triggers migration, (ii) doesn't → byte-identity fails; chosen remedy pre-migrated fixture consistent with AC-2/7/10; note on separate-TempDir reasoning); LOW-1: key-order sentence softened at all three sites (both Test Notes + AC-10: "serde_json map behavior…unspecified contractually — parse, don't match"); BC count unchanged (140/111)
  - v1.3.134 — SOH-DX-1 DEC-188 round-36 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F-1 (MED): Removal postcondition gains blanket doc-comment/section-banner rewrite obligation (each inverted AC's banner/rustdoc asserting warn-and-proceed MUST be rewritten to exit-64 semantics at F4; examples ~:2413-2418, ~:2486-2491 and AC-3/4/5/6/7 equivalents); F-2 (MED): deliverable (e) gains sibling site `tests/issue_create_jsm.rs` ~:2323-2326 (same false platform-parity claim + dead "lines 333-343" citation; both corrected at F4; EC-3.8.012-5 authoritative); LOW-1: MUST-NOT-clap-requires rationale at :3028/:3124 corrected — AC-15 dropped as falsifier (passes either way); AC-1/AC-2/AC-16 named as the actual falsifiers (exit-64 + guard-string assertions fail under a `requires` realization); LOW-2: README.md bc-3-issue-write.md traceability row "BC-3.8.001..015" → "..017"; BC count unchanged (140/111)
  - v1.3.133 — SOH-DX-1 DEC-188 round-35 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F35-1 (MED): fifth ADR-0014 site at ~:159-160 ("No other `jr issue create` invocation is affected.") added; "ALL FOUR" → "ALL FIVE" in guard-ordering mandate [superseded by 1.3.136: §42-45 excluded; four sites final]; F35-2 (LOW): AC namespace note intra-doc self-cites updated (~:2980→§"Platform-Path Guard Ordering"; ~:3024→§"Verbatim error string (single-flag case)"); F35-3 (LOW): both Test Note promotion directive sites update "~11 pub fn fixtures" → "~29 pub fn fixtures (plus mock_server.rs/yaml.rs siblings)"; F35-4 (LOW): REGRESSION PIN added to AC-13 (combined-flag invocation previously emitted both old warn strings) and AC-19 (empty-value `--field a=` previously triggered old `!is_empty()` guard); Removal postcondition mandate list extended from AC-1/2/3/5/7 to AC-1/2/3/5/7/13/19; BC count unchanged (140/111)
  - v1.3.132 — SOH-DX-1 DEC-188 round-34 adversary-pass corrections (2026-07-26, #639): 0 new BCs — O-1: spec-changelog.md header gains Type legend (MINOR = new BCs/VPs/sections; PATCH = amendments; product-semver independent); O-2: both promotion directive Test Note sites (~:3057/~:3142) gain `tests/json_error_shape.rs` hygiene note — gains `#[allow(dead_code)] mod common;` too (~11 pub fn fixtures would break clippy -D warnings without it; consistent with 60-file precedent); O-3: delivery (d) mod.rs ~:400 quote completed to FULL `"Duplicate keys use the last value provided. Applies to JSM requests only."` + deletion rule (trailing "Applies to JSM requests only." sentence DELETED at F4 — new first line already carries "JSM only"; avoids duplication); BC count unchanged (140/111)
  - v1.3.131 — SOH-DX-1 DEC-188 round-33 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F33-1 (MED): AC-3 two single-flag-absence negatives labeled FALSIFIABLE-COARSE (invocation has the respective flag; catches gross defect where single-flag guard fires instead of combined guard; non-overlapping strings); AC-9 `!stderr.contains("Project key")` labeled DISCRIMINATING (guard fires at step 2 before project-key resolution at step 3 — proves guard-before-project-RESOLUTION ordering; `--project` NOT required); F33-2 (MED): AC-10 invocation completed to would-otherwise-succeed: `--project PROJ --type Task --summary "test" --field a=b --output json` + `mount_platform_create_stubs` MUST be called; `stdout.trim().is_empty()` now genuinely DISCRIMINATING (guard-absent with stubs would populate stdout); pairing note updated to "symmetric twins for the would-otherwise-succeed invocation class"; F33-3 (LOW): AC-10 gains TempDir precondition (find_project_config ancestor-walk hygiene; matches AC-8); F33-4 (LOW): BC-3.8.013 Trace gains AC-8 invocation (ii) note (received_requests().is_empty() zero-HTTP pin for --on-behalf-of variant on its own isolated MockServer); F33-5 (LOW): AC-7 example value `bare-name-no-equals` → `bareflagnoequals` (match KEPT body ~:2845); BC count unchanged (140/111)
  - v1.3.130 — SOH-DX-1 DEC-188 round-32 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F32-1 (MED): EC-3.8.012-10 added (guard is PROJECT-TYPE-AGNOSTIC — fires step 2 before project-type resolution and require_service_desk; MUST NOT gate on project type; deliberately reverses ADR-0014 §42-45 amended per deliverable (a); BC-3.8.011 direction contrast noted — no conflict); F32-2 (MED): stdout.trim().is_empty() labeled DISCRIMINATING in AC-2/AC-7/AC-10 (--output json mode: create.rs ~:249/:265 prints created-issue JSON to stdout on success path; guard-absent populates stdout; previously unlabeled); F32-3 (MED): AC-16 gains REGRESSION PIN !stderr.contains("is ignored on the platform create path") (--on-behalf-of "" hit is_some() ~:86 → emitted old warn; pin proves absent post-DEC-188); BC-3.8.013 Removal postcondition extended: "AC-2" → "AC-2 and AC-16" with is_some() rationale; O-1 (LOW): delivery obligation (e) added — jsm_create.rs ~:171-172 false platform-path --markdown guard parity comment to be corrected at F4 (no such platform guard; EC-3.8.012-10 authoritative); O-2 (LOW): BC-3.8.012 + BC-3.8.013 Behavior "BEFORE interactive prompts" → "BEFORE project-key resolution, BEFORE interactive prompts" in both BCs (replace_all — 2 occurrences); BC count unchanged (140/111)
  - v1.3.129 — SOH-DX-1 DEC-188 round-31 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F31-1 (HIGH): BC-3.3.001 H1 (:497) retitled from stale `{"key":"FOO-123"}` shape → "`issue create` POSTs `/rest/api/3/issue`; `--output json` returns created issue object + `url` (follow-up GET); `{key,url,fetch_error}` on fetch failure"; BC-INDEX row 274 title synced verbatim; F31-2 (MED): AC-8 zero-HTTP proof strengthened — `server.received_requests().await.unwrap().is_empty()` added as NORMATIVE assertion on each isolated MockServer (in-repo primitive: tests/issue_create_json.rs ~:411; catches ALL HTTP including unregistered endpoints that 404 silently past expect(0)); (d) relabeled DISCRIMINATING expect(0) → DEFENSE-IN-DEPTH (superseded by received_requests); invocation (ii) "discriminating proof" reference updated to match; all (a)-(e) mocks now explicitly DEFENSE-IN-DEPTH; LOW: SSOT step 7 (~:2996) "NOT intercepted by the guards" → "not reached on the guarded path (the handler returns at step 2)"; BC count unchanged (140/111)
  - v1.3.128 — SOH-DX-1 DEC-188 round-30 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F30-1 (MED): AC-11 rationale corrected — dialoguer 0.12 interact_text() short-circuits (ErrorKind::NotConnected) on non-TTY stderr under assert_cmd; prompt label NEVER renders; JR_STDIN_IS_TTY=1 only suppresses auto---no-input flip, does NOT make dialoguer interactive; (1) discriminator (2) rewritten: !stderr.contains("Project key") pins absence of the "Project key is required" ERROR (create.rs ~:102-108 ok_or_else after prompt_input yields None) — DISCRIMINATING as guard-before-project-RESOLUTION proof; (2) "fires BEFORE the interactive prompt at step 3" claim deleted from intro; (3) HYGIENE note "project-key prompt fires" → "Project key is required error from create.rs ~:102-108"; (4) dialoguer "renders prompts to stderr" note replaced with Non-goal + AC-11 purpose statement (true interactive branch untestable without PTY harness — deliberate non-goal; AC-11's value is exercising JR_STDIN_IS_TTY=1 no-auto-flip path); Obs (folded): AC-12 Coupling note added ("count==2 assumes no OTHER flag help contains the substring; revisit if help text grows"); BC count unchanged (140/111)
  - v1.3.127 — SOH-DX-1 DEC-188 round-29 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F-1 (HIGH): AC-20 and AC-21 BC-3.8.007 citation corrected to BC-3.8.009 (raiseOnBehalfOf passthrough is BC-3.8.009, not BC-3.8.007 which is --priority/--label); F-2 (MED): AC-9's cwd precondition (MUST use .current_dir(<per-test TempDir>) — find_project_config ~:362 walks ancestors; isolated cwd prevents ancestor .jr.toml silently supplying project default) propagated to AC-11 and AC-17 (both use !stderr.contains("Project key") as named discriminator on --project-less invocations); Obs-1: BC-3.8.013 Behavior "Option<String> (at most one occurrence on the command line)" → "(repeats accepted by clap, last-wins; contract keys on is_some())" (clap Set action accepts repeats); Obs-2: BC-3.8.013 Asymmetry rationale gains Error-string completeness note (create-then-edit remedy affordance deliberately omitted from error string — factually conditional on Modify Reporter permission; unconditional remedies add --request-type / drop flag are inline and sufficient; conditional affordance documented in rationale prose only); BC count unchanged (140/111)
  - v1.3.126 — SOH-DX-1 DEC-188 round-28 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F-1: AC-1 FULL-STRING pin annotation gains Rust-literal note (backticks are ordinary characters in Rust — write raw, no escaping; \`` is a Markdown display artifact; verbatim from fenced block at ~:3024); F-2: BC-3.8.012 and BC-3.8.013 Behavior each gain Implementation constraint MUST-NOT (guard MUST NOT be clap #[arg(requires = "request_type")] — yields exit 2 pre-handler violating SSOT step 2 and colliding with AC-15; MUST be hand-rolled JrError::UserError check in handle_create); F-3: AC-1 renderer cite extended ("src/main.rs ~:143 — the human-mode (_ =>) match arm of the output_format dispatch; the JSON arm (~:134-140) emits no prefix"); F-4: AC-5 anchor rationale corrected (guard absent → both invocations SUCCEED and emit identical "Created issue PROJ-123" stderr at create.rs ~:272 — byte-identity cannot distinguish; positive anchor pins which error is compared); F-5: SSOT anchor ~:2971 → ~:2980 (heading); Obs: AC-4 gains follow-up-GET note (GET /rest/api/3/issue/PROJ-123 unstubbed under mount_platform_create_stubs → stderr fetch-warning; negatives unaffected; do NOT add stderr-cleanliness assertions; test-writer may stub if quiet run preferred); BC count unchanged (140/111)
  - v1.3.125 — SOH-DX-1 DEC-188 round-27 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F-27-01: AC-17 negative !stderr.contains("cannot be combined with") relabeled DISCRIMINATING→HYGIENE (BC-3.8.017 string lives only in handle_jsm_create unreachable without --request-type; same structural class as AC-15); real discriminating pair stated: positive stderr.contains("--field is only valid with") AND !stderr.contains("Project key") (DISCRIMINATING — proves guard-before-project-lookup step 2 ordering); F-27-02: AC-8 expect(0) mocks gain Mock ResponseTemplate note (each mock MUST include respond_with e.g. ResponseTemplate::new(200); response irrelevant; expect(0) count is the assertion); LOW: ~:3047/~:3132 "helper semantics at ~:76" rephrased to "fn at tests/json_error_shape.rs ~:63; its stdout.trim().is_empty() semantics at ~:76" (disambiguates fn location from semantics location); BC count unchanged (140/111)
  - v1.3.124 — SOH-DX-1 DEC-188 round-26 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F-1: AC-1/AC-3/AC-16 each gain FULL-STRING pin for verbatim error string (single-source per string; other ACs use prefix pins only); LOW-2 embedded in AC-1: "Error: " prefix pin annotated as single-source from src/main.rs ~:143 unconditional error renderer; F-2: AC-8 split into two sub-invocations each against a separate isolated MockServer instance — invocation (i) = --field a=b (BC-3.8.012 prefix pin); invocation (ii) = --on-behalf-of X replacing --field a=b (BC-3.8.013 prefix pin; same expect(0) mock set (a)–(e)); F-3: delivery item (d) --on-behalf-of first doc line "another user" → "this accountId" (accountId value-format signal from -h preserved); LOW-1: BC-3.3.001 Behavior cite BC-3.4.014 line 1122 → BC-3.4.014 ~:1122 (TD-031 citation form); LOW-3: AC-2/AC-7 gain assert_json_error_envelope note (helper asserts shape only — error field contains-assertion written separately at call site; mirrors AC-10 note (ii)); BC count unchanged (140/111)
  - v1.3.123 — SOH-DX-1 DEC-188 round-25 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F25-01: AC-5 DELETE mandate adds existing 3-field invocation (~:2712-2717; collapses n=1 vs n>1 discriminator; replaced by two-invocation spec: (i) exactly one `--field`, (ii) exactly two); invocation (i) annotated "(MUST be exactly one `--field`)"; F25-02+F25-03: taxonomy RULING applied — 3-tier labels (DISCRIMINATING/FALSIFIABLE-COARSE/HYGIENE) encoded in codified-rule sentence; AC-6 combined-string HYGIENE→FALSIFIABLE-COARSE; AC-13 single-flag absent pair labeled FALSIFIABLE-COARSE; AC-14 DISCRIMINATING on `!stderr.contains("--field is only valid with")`; AC-15 HYGIENE on `!stderr.contains("--field is only valid with")`; AC-16 FALSIFIABLE-COARSE on combined-string negative; AC-17 DISCRIMINATING on `!stderr.contains("cannot be combined with")`; AC-20 combined-string HYGIENE→FALSIFIABLE-COARSE; F25-04: BC-3.3.001 Behavior line corrected (stale `{"key": "FOO-123"}` → follow-up GET full issue object + url; `src/cli/issue/create.rs` ~:243-249 and BC-3.4.014 line 1122; applied in prior burst); LOW-1: AC-2 and AC-7 KEPT clauses gain shorthand-vs-canonical note (shorthand names only the flag under test; canonical invocation per KEPT includes `--project`/`--type`/`--summary`); LOW-2: preamble ~:2759 "BCs 002..011 require `--request-type`" → "BCs 002..011 and 014..017 (JSM-path contracts) require `--request-type`"; BC count unchanged (140/111)
  - v1.3.122 — SOH-DX-1 DEC-188 round-24 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F24-01: KEPT exclusion clauses deleted from AC-18 and AC-19 (NEW tests — no existing body to preserve; over-applied by round-22 replace_all); F24-02: AC-4 invocation added (jr issue create --project PROJ --type Task --summary "test" --output json + mount_platform_create_stubs; exit 0); KEPT exclusion clause + S-639-1 story deliverable added to AC-4 and AC-6 (AC-6 note: expect(1) POST stub at ~:2758-2763 load-bearing and preserved); F24-03: SSOT header corrected ("complete guard/HTTP ordering" → "guard-relevant ordering (authoritative for step numbering)"); completeness caveat reworded (type/summary fallbacks are step 4's failure arms; --markdown→ADF conversion runs between step 4a and step 5); AC namespace note SSOT cross-ref updated to match new header; LOW-1: fourth ADR-0014 amendment site added to doc-fallout obligation (a) (~:42-45 "Rather than silently dropping these flags or erroring on them before verifying…" rationale sentence; "three sites"→"four sites"; "ALL THREE"→"ALL FOUR"); LOW-2: fourth stub named explicitly in AC-20 and AC-21 (POST /rest/servicedeskapi/request returning jsm_created_response() per tests/issue_create_jsm.rs ~:2758-2763); BC count unchanged (140/111)
  - v1.3.121 — SOH-DX-1 DEC-188 round-23 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F23-03: AC-8 anchor line-numbers refreshed (get_org_metadata teams.rs ~:12; list_teams teams.rs ~:33; find_team_field_id fields.rs ~:26 — corrected from ~:19/~:38/~:23; matches pub fn defs in source); F23-04: promotion directive adds `pub fn` qualifier ("promote `assert_json_error_envelope` as `pub fn`" — fixtures.rs convention); BC-INDEX.md F23-01: index_version field repaired v6.45→v6.50 (prose said v6.49; this round bumps to v6.50); README.md F23-02: 603→657 in table and prose + provenance note ("count maintained by check-bc-cumulative-counts.sh 8 surfaces; README is informational — see BC-INDEX.md"); BC count unchanged (140/111)
  - v1.3.120 — SOH-DX-1 DEC-188 round-22 adversary-pass corrections (2026-07-26, #639): 0 new BCs — in-round residual: AC-20 RT name corrected ("password-reset" → "Password Reset" per tests/issue_create_jsm.rs ~:135; partial_match rejects hyphenated form); MED-1: KEPT clauses rewritten to exclusion form in AC-1/2/3/5/7/18/19 ("KEPT: everything in the existing test body EXCEPT the items enumerated in the DELETE mandate above"); AC-1 gains two notes (guard presence-only: !field_pairs.is_empty() at create.rs ~:81; --no-input remains deliberate — AC-11 is TTY-path test, cross-ref); AC-2 gains no-line-range note (old ~:2537 reference collided with DELETE target); Obs: EC-3.8.012-2 adds whitespace-only variant (e.g. "   " — trim-guard at src/cli/issue/jsm_create.rs ~:145 routes identically); BC count unchanged (140/111)
  - v1.3.119 — SOH-DX-1 DEC-188 round-21 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F21-01: AC-20/AC-21 invocations updated to include `--project HELP --summary "test"` (JSM path requires project at jsm_create.rs ~:124-140 and summary at ~:245-257; exit 0 impossible without them); F21-02: "mount_jsm_create_stubs" (non-existent) replaced in AC-20+AC-21 with real trio: `mount_project_meta_help` (~:24) + `mount_service_desk_list` (~:52) + `mount_request_types_password_reset` (~:121) + request-creation POST stub; F21-03: AC-5 gains DISCRIMINATING NEGATIVE `!stderr.contains("Created issue")` on EACH invocation (FALSIFIABLE — complete invocation with mount_platform_create_stubs); F21-04: AC-2 and AC-7 each gain KEPT parenthetical (existing --project/--type/--summary args + mount_platform_create_stubs preserved; only enumerated old assertions removed); LOW-1: SSOT block gains Completeness caveat (type/summary fallbacks ~:119/:130 and --markdown→ADF BC-7.2.012 guard ~:163-169 occur in steps 4-5 and are elided; EC-3.8.012-5 cross-ref); LOW-2: AC-8 gains Precondition note (write_minimal_config sets no team_field_id; helpers.rs::resolve_team_field ~:43-47 explains why GET /rest/api/3/field is first reachable HTTP); LOW-3: no change (STORY-INDEX S-383 status deliberate; noted as ruled-deliberate); BC count unchanged (140/111)
  - v1.3.118 — SOH-DX-1 DEC-188 round-20 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F20-1+F20-2(a): AC-1/AC-3/AC-5/AC-18/AC-19 invocations updated to complete form (--project PROJ --type Task --summary "test" + mount_platform_create_stubs KEPT); would-otherwise-succeed falsifiability rationale added; KEPT-note for existing args/stubs (only --output json + enumerated old assertions removed); !stderr.contains("Created issue") remains DISCRIMINATING (now truly falsifiable); F20-2(b): AC-9 "Created issue" relabeled HYGIENE (projectless BY DESIGN — structurally unreachable in either path; discriminating proof is the project-error-ABSENCE pair); F20-2(c): AC-11 "Created issue" relabeled HYGIENE (bare-MockServer + projectless by design; discriminating proof is stderr substring triple); F20-2(d): AC-8 mock set relabeled: (d) GET /rest/api/3/field DISCRIMINATING expect(0) (first reachable HTTP guard-absent); (a)-(c)+(e) DEFENSE-IN-DEPTH; "Created issue" HYGIENE (isolated MockServer — guard-absent path fails at (d), never reaches issue creation); F20-4: AC-8 citation corrected (call site resolve_assignee_by_project is create.rs ~:213; helpers.rs ~:443 is get_myself inside the fn); F20-5: EC-3.8.013-2 added (--on-behalf-of X --request-type "" → request_type.is_some() routes JSM; BC-3.8.016 fires; BC-3.8.013 MUST NOT fire; mirror of EC-3.8.012-2; AC-14 variant covers class; second AC deliberate non-goal); BC count unchanged (140/111)
  - v1.3.117 — SOH-DX-1 DEC-188 round-19 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F-1: AC-21 added (test_jsm_create_with_both_flags_and_request_type_does_not_fire_guards [mode: --output json] — JSM path combined non-mis-fire: --field a=b --on-behalf-of X --request-type <NAME> → exit 0, all three new-error negatives FALSIFIABLE; the only invocation falsifying the combined guard on the JSM path); AC-6 and AC-20 structurally-unfalsifiable negatives labeled HYGIENE; AC namespace note AC-1..20→AC-1..21 + SSOT pointer sentence (Platform-Path Guard Ordering SSOT block ~:2971 is authoritative; per-AC step references are informational) + process-gap falsifiability sentence (every negative MUST name the falsifying element; structurally-unfalsifiable negatives labeled HYGIENE); BC-3.8.013 Trace range AC-1..20→AC-1..21 + AC-21 reference added; F-2: five ':3036' removal-postcondition cites replaced with section-form §"Removal postcondition (single-site, DEC-188)" (#408 citation-form rule); F-3: --output json arg removal mandates added to AC-1/AC-3/AC-5 existing test invocations (~:2456-2457, ~:2601-2602, ~:2719-2720) so [mode: human] is actually exercised; F-5: AC-17 negatives rescoped from bare words ("description", "markdown") to specific BC-3.8.017 rival string "cannot be combined with" (from jsm_create.rs ~:160); BC count unchanged (140/111)
  - v1.3.116 — SOH-DX-1 DEC-188 round-18 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F18-001: AC-2 DELETE mandate added for !stdout.contains("warning: --on-behalf-of is ignored") (~:2551 — vacuously true post-DEC-188); AC-4 advisory vacuity language → NORMATIVE DELETE mandates for !stderr.contains("--field is ignored") (~:2671) and --on-behalf-of twin (~:2675); AC-6 advisory vacuity language → NORMATIVE DELETE mandate for !stderr.contains("--field is ignored on the platform create path") (~:2799); F18-002: AC-4 adds third negative !stderr.contains("--field and --on-behalf-of are only valid with") (all three new-error strings pinned on clean path); F18-003: AC-20 (NEW) test_jsm_create_with_on_behalf_of_and_request_type_does_not_fire_bc_3_8_013 [mode: --output json] added — JSM path non-mis-fire pin for BC-3.8.013 (mirrors AC-6); AC namespace note AC-1..19→AC-1..20; BC-3.8.013 Trace updated (AC-1..19→AC-1..20; AC-20 reference added); LOW-1: preamble ~:2752 qualified ("BCs 001..011"→"BCs 002..011"; BC-3.8.001 governs absent-request-type case); LOW-2: skip (ratified markers confirmed present from round-17); BC count unchanged (140/111)
  - v1.3.115 — SOH-DX-1 DEC-188 round-17 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F17-01: AC-8 and AC-11 MockServer isolation constraint added (MUST NOT call mount_platform_create_stubs; dedicated MockServer with only expect(0) mocks registered; wiremock 0.6 FIFO rationale from CLAUDE.md §BC-3.9.006 cited); F17-02: AC-1 (iv) stdout.contains("PROJ-123") removal ~:2474-2477 added; AC-2 verbatim-warn removal ~:2542-2545 + stdout PROJ-123 removal ~:2546-2549 added; AC-3 OLD ASSERTIONS block added (exit-0 ~:2609-2613 + BC-3.8.012 warn ~:2615-2618 + BC-3.8.013 warn ~:2619-2622); AC-5 OLD ASSERTIONS block added (exit-0 ~:2727-2730 + .count() form ~:2732-2738); F17-03: AC-1 (ii) description corrected from "warning-count .count() form" to "verbatim contains assertion form; NOT .count()"; F17-04: AC-1/3/8/9/11/18/19 each gain DISCRIMINATING NEGATIVE !stderr.contains("Created issue") + stdout.trim().is_empty() hygiene note (BC-3.4.014 non-discriminating in human mode rationale); AC-11 Required discriminators "two"→"three"; LOW-1: BC-INDEX BC-3.8.012/013 rows prepend H1 title verbatim before amendment fragment; LOW-2: spec-changelog [1.3.110]-[1.3.115] Summary lines append "(DEC-188 ratified 2026-07-25)"; BC count unchanged (140/111)
  - v1.3.114 — SOH-DX-1 DEC-188 round-16 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F16-01: self-contradiction resolved (Removal postcondition wins); AC-3 "OLD ASSERTION MUST BE REMOVED" for is-ignored-pin removed, replaced with REGRESSION PIN; AC-1/2/5/7 each gain !stderr.contains("is ignored on the platform create path") regression pin; AC-5 re-tagged [mode: human] + "Error: " prefix byte-identity note (F16-04 folded in); F16-02: AC-14 invocation adds --project PROJ + positive BC-3.8.016 assertion (stderr.contains("request type cannot be empty")); AC-13/16/17/18/19 each gain explicit per-AC discrimination note (guard fires step 2 before project-key resolution step 3; no --project required); F16-03: Outputs/Effects lines (BC-3.8.012 + BC-3.8.013) file cite corrected — tests/common/fixtures.rs ~:76 → tests/json_error_shape.rs ~:76 (current; moves to fixtures.rs on promotion); F16-05: SSOT step 3 extended (project-key interactive prompt is step 3; step 4 does NOT re-prompt); step 4 deduplicated (type+summary only; project-key removed); AC-11 discriminator re-anchored step 4→step 3; BC count unchanged (140/111)
  - v1.3.113 — SOH-DX-1 DEC-188 round-15 adversary-pass corrections (2026-07-26, #639): 0 new BCs — F15-01: AC-1 re-scoped to [mode: human] (invocation jr issue create --field a=b no --output json; assertions exit 64 + stderr.contains("Error: ") + stderr.contains("--field is only valid with") + stdout.trim().is_empty(); pairing note with AC-10 json counterpart); AC-10 annotated [mode: --output json] + pairing note referencing AC-1; F15-02: AC-3 invocation added (jr issue create --field a=b --on-behalf-of X) + explicit exit 64 + OLD ASSERTION removal pin (!stderr.contains("is ignored on the platform create path")); F15-03: BC-3.8.012 + BC-3.8.013 Outputs/Effects lines updated (stdout.trim().is_empty() normative predicate + promoted helper ~:76 reference); all stdout.is_empty() → stdout.trim().is_empty() globally; F15-04: AC-18 demoted "stdin NOT consumed" to non-normative rationale (assert_cmd has no timeout primitive; normative assertions: exit 64 + stderr.contains("--field is only valid with") + stdout.trim().is_empty()); F15-05: AC-8 team-resolution vague cite replaced with three enumerated endpoints (POST /gateway/api/graphql get_org_metadata teams.rs ~:19; GET /gateway/api/public/teams/v1/org/{orgId}/teams list_teams teams.rs ~:38; GET /rest/api/3/field find_team_field_id fields.rs ~:23); Obs-1: BC-3.3.001 H1 DEC-188 qualifier added; Obs-2: EC-3.8.012-6 no-AC rationale added; BC count unchanged (140/111)
---

# BC-3 — Issue Write

152 behavioral contracts across 9 subdomains: Assign (3.1), Move/Transition (3.2),
Create (3.3), Edit+Open (3.4), Comment (3.5), Links (3.6), Remote links (3.7),
JSM Request Create + Platform-Path Pre-flight Guards + Auth-Conditional 401 Hints (3.8),
Attachment Write (3.9).

---

## Subdomains

### 3.1 Assign

#### BC-3.1.001: `issue assign --account-id <id>` PUTs `/issue/<key>/assignee` with `{accountId: <id>}`

**Confidence**: HIGH
**Source**: `tests/cli_handler.rs:~58`; `tests/issue_commands.rs:~1646`
**Subject**: Issue write
**Behavior**: Body partial-JSON match `{accountId: "direct-id-001"}`. Output JSON: `{"changed": true, "key": "HDL-1", "assignee": "direct-id-001", "assignee_account_id": "direct-id-001"}`.
**Effects**: HTTP PUT to `/rest/api/3/issue/<key>/assignee`.
**Trace**: Pass 3 BC-201; BC-1077 (R4)

---

#### BC-3.1.002: `issue assign --to <name>` resolves via assignable user search then assigns

**Confidence**: HIGH
**Source**: `tests/cli_handler.rs:~93`; `tests/issue_commands.rs:~807`
**Subject**: Issue write
**Behavior**: GET `/rest/api/3/user/assignable/search?query=<name>&issueKey=<key>` → PUT with resolved accountId. Output `"assignee": "Jane Doe"`, `"changed": true`.
**Trace**: Pass 3 BC-202; BC-1059 (R4)

---

#### BC-3.1.003: `issue assign --to me` resolves current user via `/myself`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~879`
**Subject**: Issue write
**Behavior**: `get_myself()` → `assign_issue(key, Some(&me.account_id))`. ZERO search HTTP.
**Trace**: Pass 3 BC-203; BC-1061 (R4)

---

#### BC-3.1.004: `issue assign` is idempotent — already-assigned-to-target → exit 0 + `"changed": false`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~922`
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
**Source**: `tests/cli_smoke.rs:~170`
**Trace**: Pass 3 BC-206

---

#### BC-3.1.007: `search_assignable_users` returning empty Vec → `Ok(Vec::new())` (NOT Err); handler decides UX

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~856`
**Behavior**: Empty result is a caller-level UX error, not a client error.
**Trace**: Pass 3 BC-1060 (R4)

---

#### BC-3.1.008: `assign_issue("ERR-1", Some("bogus-id"))` against 404 → Err + `"does not exist"` message

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1705`
**Behavior**: 404 body `{errorMessages: ["User '...' does not exist."]}` → `JrError::ApiError{status: 404, ..}`; extracted via `extract_error_message`.
**Trace**: Pass 3 BC-1078 (R4)

---

#### BC-3.1.009: `search_assignable_users_by_project(query, projectKey)` GETs `/rest/api/3/user/assignable/multiProjectSearch` (NOT `/user/search`)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1024`
**Behavior**: Uses `projectKeys` AND `query` params. Accepts same FOUR response shapes as `search_users`.
**Trace**: Pass 3 BC-1064 (R4)

---

### 3.2 Move / Transition

#### BC-3.2.001: `issue move <key> <target>` is idempotent when current == target (by status name)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1500`
**Subject**: Issue write
**Behavior**: `get_issue` shows current status == target → exit 0; stderr `"already in status"`; ZERO `POST /transitions` mock fires.
**Trace**: Pass 3 BC-207; BC-1074 (R4); Top-30 BC rank #12

---

#### BC-3.2.002: `issue move <key>` is idempotent via transition-name→status-name resolution too

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1551`
**Subject**: Issue write
**Behavior**: Transition name `"Complete"` → destination status `"Completed"` → already there → short-circuit. stderr `"already in status"`.
**Trace**: Pass 3 BC-1075 (R4)

---

#### BC-3.2.003: `issue move` resolves transition by NAME match (e.g., `"Complete"`)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1219`
**Behavior**: Fetches transitions, resolves `transition.name == "Complete"`, POSTs with `{transition: {id: "21"}}`. stderr: `"Moved FOO-1"`.
**Trace**: Pass 3 BC-1069 (R4)

---

#### BC-3.2.004: `issue move` resolves by STATUS NAME match (e.g., `transition.to.name == "Completed"`)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1278`
**Behavior**: Status NAME match path (distinct from transition-name match). Same POST.
**Trace**: Pass 3 BC-1070 (R4)

---

#### BC-3.2.005: Duplicate candidates (same transition + status name) are de-duplicated; only ONE candidate presented

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1337`
**Behavior**: `transition.name == "Done"` AND `transition.to.name == "Done"` → dedup → one candidate → succeeds.
**Trace**: Pass 3 BC-1071 (R4)

---

#### BC-3.2.006: Ambiguous move → exit non-zero + stderr `"Ambiguous"` + NO POST

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1396`
**Trace**: Pass 3 BC-1072 (R4)

---

#### BC-3.2.007: No-match move → enriched candidate list in stderr: `"Complete (→ Completed)"` format

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1446`
**Behavior**: Transition NAME → status NAME format in error candidates.
**Trace**: Pass 3 BC-1073 (R4)

---

#### BC-3.2.008: `--no-input` single-substring move → exit 64 + `"Ambiguous transition"` + ZERO POST

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1748`
**Behavior**: `mock.expect(0)` on `POST /transitions`. stderr contains `"Ambiguous transition"` AND `"In Progress"`. Exit EXACTLY 64.
**Trace**: Pass 3 BC-1079 (R4)

---

#### BC-3.2.009: `issue move` 400 "resolution required" → `--resolution` hint + `jr issue resolutions` discovery pointer

**Confidence**: HIGH
**Source**: `tests/issue_resolution.rs:~88`
**Behavior**: 400 body `{errors: {resolution: "Field 'resolution' is required"}}` → stderr contains `--resolution` AND `jr issue resolutions`.
**Trace**: Pass 3 BC-208, BC-209

---

#### BC-3.2.010: `issue resolutions` reads cache-first (7d TTL); JSON: `[{name, id, description}]`

**Confidence**: HIGH
**Source**: `tests/issue_resolution.rs:~11, 49-86`
**Behavior**: GET `/rest/api/3/resolution`, cached 7 days. Table shows Name + Description. Resolutions without `id` dropped on cache write (+ stderr warning).
**Trace**: Pass 3 BC-210

---

#### BC-3.2.011: `transition_issue(key, id, Some(&fields))` body contains `{transition: {id}, fields: {resolution: {name: "Done"}}}`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~79`
**Behavior**: Fields merged alongside transition in body. `expect(1)`.
**Trace**: Pass 3 BC-1039 (R4)

---

#### BC-3.2.012: `transition_issue(key, id, None)` body MUST NOT contain `"fields"` key

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~105`
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

#### BC-3.3.001: `issue create` POSTs `/rest/api/3/issue`; `--output json` returns created issue object + `url` (follow-up GET); `{key,url,fetch_error}` on fetch failure [amended 2026-07-25 DEC-188, reversed in part 2026-08-25 issue #578: `--on-behalf-of` without `--request-type` exit 64 pre-flight (BC-3.8.013); `--field` no longer exits 64 pre-flight — it resolves via `createmeta` (BC-3.3.010/BC-3.8.012); platform path exit 0 unchanged when `--on-behalf-of` absent]

**Confidence**: HIGH
**Source**: `tests/issue_create_json.rs` (integration tests covering create body shape, field combinations, and JSON output)
**Subject**: Issue write
**Behavior**: Body includes summary, project, issuetype, optional priority, labels, description (ADF), team UUID, story points. Output JSON (`--output json`): follow-up `GET /rest/api/3/issue/{key}` returns the full created issue object with an appended `url` (browse URL) field; `{"key": "FOO-123"}` shape is stale — see `src/cli/issue/create.rs` ~:243-249 and BC-3.4.014 ~:1122.

> **[UPDATED 2026-05-18 issue #288; amended 2026-05-19 issue #383]** The platform endpoint behavior described above applies ONLY when `--request-type` is absent. When `--request-type` is present, dispatch is to `POST /rest/servicedeskapi/request` instead (see BC-3.8.001). The POST body, JSON response, and exit code on the platform path are unchanged by these additions; however, when `--field` or `--on-behalf-of` are supplied without `--request-type`, the platform path now emits stderr warnings (see BC-3.8.012, BC-3.8.013) — so the platform path is not fully unmodified in observable behavior post-#383.
> **[AMENDED 2026-07-25 SOH-DX-1 DEC-188 #639]** The 2026-05-19 amendment above stated that `--field`/`--on-behalf-of` without `--request-type` emit stderr warnings (exit 0, platform POST proceeds). This is superseded: as of v0.6.0-dev.12, both flags without `--request-type` trigger a pre-flight `JrError::UserError` exit 64 BEFORE any HTTP (see BC-3.8.012, BC-3.8.013). The platform path exit code remains 0 when neither flag is present. The warn-and-proceed behavior no longer ships.
> **[AMENDED 2026-08-25 issue #578, DEC-310 (proposed — flagged for orchestrator to register)]** The 2026-07-25 DEC-188 amendment above is PARTIALLY SUPERSEDED: `--field` is REMOVED from the platform-path pre-flight exit-64 guard. `issue create --field NAME=VALUE` (repeatable) WITHOUT `--request-type` now resolves each field via `createmeta` and merges the result into the platform POST body (see BC-3.3.010, BC-3.3.011). `--on-behalf-of` is NOT affected — it still exits 64 without `--request-type` (BC-3.8.013, unmodified). See BC-3.8.012 `[CURRENT BEHAVIOR — effective 2026-08-25]` for the full reversal text, rationale, and the DEC-310 governance flag.
> **Previous (pre-#288):** This BC stated unconditionally that `issue create` always POSTs to `/rest/api/3/issue`. After #288 that invariant becomes conditional: platform endpoint when `--request-type` absent; JSM endpoint when `--request-type` present.

**Trace**: Pass 3 BC-211

---

#### BC-3.3.002: `issue create` with assignee — uses `search_assignable_users_by_project` (multiProjectSearch)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1024`
**Behavior**: Full body partial-match: `{project: {key}, issuetype: {name}, summary, assignee: {accountId}}`. Response 201 with `key: "FOO-99"`.
**Trace**: Pass 3 BC-1064 (R4)

---

#### BC-3.3.003: `issue create --to me` uses `get_myself()` (no search HTTP)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1084`
**Trace**: Pass 3 BC-1065 (R4)

---

#### BC-3.3.004: `issue create` WITHOUT assignee — body has `{project, issuetype, summary}` ONLY (no assignee key)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1129`
**Trace**: Pass 3 BC-1066 (R4)

---

#### BC-3.3.005: `issue create` assignee-not-found → stops short of create (NO POST mock)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1156`
**Trace**: Pass 3 BC-1067 (R4)

---

#### BC-3.3.006: `issue create --account-id <id>` skips user search entirely

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1182`
**Behavior**: Body has `assignee: {accountId: "direct-acct-789"}` directly.
**Trace**: Pass 3 BC-1068 (R4)

---

#### BC-3.3.007: `--to` and `--account-id` clap conflict on `issue create`

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs:~215`
**Trace**: Pass 3 BC-224

---

#### BC-3.3.008: `issue create --markdown -d '...'` converts markdown to ADF before POST

**Confidence**: MEDIUM
**Source**: `tests/issue_create_json.rs`
**Trace**: Pass 3 BC-212

---

#### BC-3.3.009: `create_issue` browse URL uses `client.instance_url()` (NOT `client.base_url()`)

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1606`
**Behavior**: Integration test constructs URL via `client.instance_url()`. Cross-references BC-3.4.001 (NFR-R-B bug).
**Trace**: Pass 3 BC-1076 (R4)

---

#### BC-3.3.010: `issue create --field NAME=VALUE` (repeatable, non-JSM platform path) resolves via `createmeta` and merges into the create POST body

**Confidence**: HIGH
**Source**: issue #578 F2 spec evolution; `.factory/research/field-dx-feasibility-2026-08-25.md` (claim 8: CONFIRM); `.factory/research/field-dx-context-mechanism-2026-08-25.md` (M2 verdict); `src/cli/issue/create.rs::handle_create`; `src/cli/issue/field_resolve.rs::resolve_edit_fields` (extended); reuses `src/api/jira/issues.rs::get_createmeta_fields` (ADR-0019 §1, shared with BC-X.14.001 M2) — the createmeta-with-`allowedValues` call, not a second, separately-implemented method against the same endpoint
**Subject**: Issue write — `--field` on platform create (issue #578 item 2)

**Description**: Once `--field NAME=VALUE` / `--field NAME:kind=VALUE` is present on `jr issue create` WITHOUT `--request-type`, the platform (non-JSM) create path resolves and merges the supplied field(s) into the `POST /rest/api/3/issue` body using the SAME resolution machinery as `issue edit --field` (BC-3.4.015/016/026-031), substituting `createmeta` for `editmeta` because the issue does not exist yet at create time.

This BC REVERSES the DEC-188 platform-path exit-64 pre-flight guard for `--field` specifically (see BC-3.8.012 [CURRENT BEHAVIOR — effective 2026-08-25]; BC-3.8.013's `--on-behalf-of` guard is UNCHANGED and continues to exit 64 on the platform path).

**Resolution algorithm** (mirrors BC-3.4.015 Steps 1-4, source substituted):
1. `customfield_\d+` bypass — same regex, same behavior as BC-3.4.015 Step 1.
2. Field-name resolution — same cache-first `fields.json` / `list_fields()` lookup as BC-3.4.015 Step 2/2b (shared function, shared cache; NO new cache family).
3. **Source substitution**: instead of `GET /issue/{key}/editmeta`, calls `get_createmeta_fields` — `GET /rest/api/3/issue/createmeta/{projectKey}/issuetypes/{issueTypeId}` (Atlassian's current, non-deprecated createmeta pair — CHANGE-1304; the deprecated `createmeta?expand=` form MUST NOT be used), **offset-paginated internally** (`startAt`/`maxResults`/`total`, per ADR-0019 §1 — one GET per page until all field pages are collected; see Postconditions below for what "at most once" means under pagination). `issueTypeId` is resolved via the SAME project-scoped issue-type name→id lookup `jr` already uses for bulk `--type` (`get_issue_types_for_project`, S-331, `src/api/jira/issues.rs`, OFFSET-PAGINATED INTERNALLY — `startAt`/`maxResults`/`total` — one or more GETs until all issue-type pages are collected, so a `--type` on page ≥2 still resolves; carries no cache) — the target project key and issue type are already required inputs of `issue create` (`--project`, `--type`/default), so no new required flag is introduced. If the field is absent from ANY page of the resolved issue type's createmeta fields → same "not on the Create screen" exit-64 shape as BC-3.4.015 Step 3, substituting "Create screen" for "Edit screen" in the message (see BC-3.3.011 error taxonomy).
4. Type dispatch and option-value resolution — identical to BC-3.4.015 Step 4 / BC-3.4.016 Step 4a, reading `allowedValues[].id` from the createmeta field entry (same untyped-`items` shape caveat noted in the context-mechanism research).
5. Resolved `(field_id, serialized_value)` pairs are merged into the same `fields` JSON object used by `--summary`/`--priority`/`--component`/etc. (BC-3.3.002 pattern) before the single `POST /rest/api/3/issue` call.
6. Successful resolution inserts the field into the create-path success echo — concrete echo KEY/VALUE rules per hint kind are specified in BC-3.4.014's `--field NAME[:kind]=VALUE` bullet (table mode); JSON mode via the created-issue response, consistent with BC-3.3.001.

**No `operations`/`"set"` check on create** — createmeta has no `operations` array (that is an editmeta-only concept describing an EXISTING issue's field mutability). Any field returned in createmeta's field list for the resolved issue type is assumed settable on create.

**Preconditions**:
- `jr issue create --field NAME=VALUE [--field ...]` WITHOUT `--request-type`.
- **[ADDED 2026-08-26, F2 adversary-convergence pass, D2; CORRECTED 2026-08-26, F2 adversary-convergence round-2, Pass2-F5 — BC-3.8.013's guard was omitted from this list; RENUMBERED 2026-08-26, F2 adversary-convergence round-3, F-MED-1 — `parse_field_kv`'s own malformed-hint exit-64 pinned as step 2a, D2 collision guard renumbered from step 2a to step 2b]** No dedicated-flag × `--field` wire-key collision is present — enforced by the create-path collision guard (ADR-0019 § Amendment (2026-08-26) D2; see BC-3.3.011 error taxonomy) BEFORE project/type resolution and BEFORE this resolution algorithm, mirroring Gate B's evaluation point at the top of `handle_edit` (BC-3.4.017). Guard ordering (revised, corrected): JSM dispatch fork (step 1) → BC-3.8.013 `--on-behalf-of` pre-flight guard (step 2, pre-existing, position unchanged) → `parse_field_kv` hint-syntax parse pass (step 2a, BC-3.4.026/031, new — the D2 collision guard's `HashMap<String, FieldValueSpec>` input is produced here; a malformed hint exits 64 at this step before the collision guard ever runs) → create-path collision guard (step 2b, D2, new) → [no `--field`-alone pre-flight guard, per BC-3.8.012 reversal] → project-key resolution (step 3) → field resolution → POST. See `Platform-Path Guard Ordering — handle_create` (SSOT block, this file) for the full, authoritative step list and the deterministic-order rationale across all three pre-HTTP exit-64 paths (step 2, step 2a, step 2b): step 2 (BC-3.8.013) is evaluated first because its position pre-dates D2/F-MED-1 and is unchanged by either amendment; step 2a (`parse_field_kv`) is evaluated second because step 2b structurally depends on its parsed output; step 2b (D2) is evaluated third — an invocation tripping more than one guard's trigger condition (e.g. `--priority X --field priority=Y --on-behalf-of Z`, no `--request-type`) surfaces only the earliest-numbered guard's error; a caller fixing that error deterministically encounters the next-numbered guard's error on the following attempt, never a silent flip between guards.
- `--project <KEY>` resolved (flag or profile default) BEFORE this resolution step.
- `--type <NAME>` resolved to an issue type (flag or default) BEFORE field resolution — `--field` resolution needs a concrete `issueTypeId`.

**Postconditions**:
- Exit code 0 on success; the resolved field(s) appear in the create POST body's `fields` object.
- **[CORRECTED, adversary pass-28 F-1]** The createmeta field-enumeration fetch (`get_createmeta_fields`, ADR-0019 §1) OFFSET-PAGINATES INTERNALLY — `startAt`/`maxResults`/`total` — issuing one `GET /rest/api/3/issue/createmeta/{project}/issuetypes/{issueTypeId}` per page until ALL field pages are collected; a project+issue-type combination whose Create screen has more fields than fit on one page therefore drives MULTIPLE HTTP GETs, not one. The PAGINATED FETCH AS A WHOLE runs AT MOST ONCE per invocation, shared across all `--field` pairs (NOT once per pair) — mirrors BC-3.4.015's `editmeta` sharing postcondition, with "at most once" now scoped to the logical (possibly multi-page) fetch rather than to a single HTTP call. Because every page is collected before resolution proceeds, a field on ANY page — not only the first — is resolvable: an issue type with more create-screen fields than a single page's `maxResults` does NOT spuriously fail resolution with a false "not on the Create screen" error (see VP-578-020). **[Pre-pass-28 wording, superseded, retained for audit trail]:** "`GET /rest/api/3/issue/createmeta/{project}/issuetypes/{issueTypeId}` is called AT MOST ONCE per invocation, shared across all `--field` pairs (mirrors BC-3.4.015's `editmeta` sharing postcondition)." — this literally described a single, non-paginated call, contradicting ADR-0019 §1's offset-pagination spec for `get_createmeta_fields` and implying a field on page ≥2 of a large create screen would be silently dropped.
- `GET /rest/api/3/field` (field-name resolution) follows the SAME cache-first contract as BC-3.4.015 — no double-fetch, same `fields.json` cache, same profile-scoped isolation.
- The name→id issue-type lookup this Step 3's `issueTypeId` resolution depends on (`get_issue_types_for_project`, S-331, `GET /rest/api/3/issue/createmeta/{project}/issuetypes` list form) performs a single LOGICAL issue-type name→id resolution per `issue create --field` invocation (at most once, shared across all `--field` pairs) — reused (not re-fetched) across every `--field` pair on that invocation; it is not a second, independent per-field call. **[CORRECTED, adversary pass-16 LOW-2]** `--field`'s presence is what INTRODUCES this call in the first place — on the standard platform create path, `--type` is passed to the POST body BY NAME and does NOT itself trigger `get_issue_types_for_project`; there is no pre-existing warm result from a separate `--type` resolution step for `--field` resolution to reuse within the same invocation. `get_issue_types_for_project` carries no cache of its own (no cache file — contrast the `fields.json` cache used by field-name resolution). **[Pre-pass-16 wording, superseded, retained for audit trail]:** "reused (not re-fetched) for every `--field` pair on that invocation, cache-first if a warm result from the SAME invocation's `--type` resolution is already in hand; it is not a second, independent per-field call" — the "cache-first if a warm result... is already in hand" clause was false: no such warm result exists on this path. **[CORRECTED, adversary pass-29 F-1]** `get_issue_types_for_project` (`src/api/jira/issues.rs`) is OFFSET-PAGINATED INTERNALLY (`startAt`/`maxResults=200`/`total`) — one or more GETs until all issue-type pages are collected, so an issue type whose entry lands on page ≥2 of a large enterprise type scheme still resolves; the single LOGICAL resolution described above (at most once per invocation) may therefore be more than one HTTP call, mirroring VP-578-020's page-≥2 guarantee for `get_createmeta_fields`. **[Pre-pass-29 wording, superseded, retained for audit trail]:** "each `issue create --field` invocation that needs `issueTypeId` performs exactly one fresh call" — this literally described a single, non-paginated HTTP call, contradicting `get_issue_types_for_project`'s own rustdoc/impl, which offset-paginates via `startAt`/`maxResults`/`total`, and implying an issue type on page ≥2 of a large type scheme would be silently dropped.

**Invariants**:
1. `--field` resolution on create runs AFTER `--project`/`--type` resolution and BEFORE the POST — same ordering discipline as BC-3.4.015 Invariant 1 on the edit path.
2. On resolution failure (zero-match, ambiguous name, unsupported type, field absent from createmeta) — exit 64, ZERO HTTP POST. Same all-or-nothing semantics as BC-3.4.015 EC-3.4.015-12 / VP-396-009, transplanted to the create path.
3. This BC does NOT change JSM-path `--field` behavior (BC-3.8.008) except as separately amended for hint-kind uniformity — see BC-3.8.008 amendment note.
4. Hint-kind syntax (`:option`/`:id`/`:name`/`:asset`, BC-3.4.026-030) is available on this path — same parser (`parse_field_kv`), same wire-shape rules, `allowedValues` source substituted per Step 3 above.
5. **[ADDED 2026-08-26, F2 adversary-convergence pass, D2; SCOPE MADE EXPLICIT 2026-08-26, F2 adversary-convergence round-4, MED-1/F-3; GOVERNED SET WIDENED 5→9, 2026-08-26, F2 adversary-convergence round-5, F-NEW-1]** A dedicated-flag × `--field` wire-key collision (e.g. `--priority Medium --field priority=Low`, any argv order, any hint kind) is rejected exit 64 BEFORE this resolution algorithm runs, and before project/type resolution — see the create-path collision guard (ADR-0019 § Amendment (2026-08-26) D2; BC-3.3.011 error taxonomy; BC-3.4.017 Gate B, whose flag-overlap detection this guard shares via `field_resolve::detect_flag_field_overlap`). This BC — and therefore this guard — governs the PLATFORM (non-JSM) create path only, per this BC's own title/Preconditions; the JSM create path is unaffected and retains BC-3.8.008's pre-existing last-wins behavior (extending this guard to JSM is DEFERRED, flagged for the F2 human gate). **The create-path governed set is NINE wire-key targets, not five** (ADR-0019 § "D2 correction (adversary F-NEW-1)") — it is a CREATE-path-specific set, distinct from and NOT identical to edit-path Gate B's five-member set (BC-3.4.017 "Scope of Gate B", unchanged by this widening). See EC-3.3.010-6 below for the full nine-member enumeration, the `labels` create-vs-edit divergence rationale, and the team/points resolved-id/zero-HTTP bound.

**Edge Cases**:
- EC-3.3.010-1: `--field "Unknown Field=Value"` on create → zero matches in `list_fields()` → exit 64, same hint as EC-3.4.015-1 (`jr project fields`).
- EC-3.3.010-2: Field found in `list_fields()` but absent from the resolved issue type's createmeta fields (not on the Create screen for that project+issue-type combination) → exit 64. Message uses "is not on the Create screen" (NOT "Edit screen" — see BC-3.3.011).
- EC-3.3.010-3: `--field` supplied but `--project`/`--type` cannot be resolved (no profile default, no flag) → the PRE-EXISTING project/type resolution error fires first (unchanged by this BC — `--field` resolution never runs without a resolved project+type).
- EC-3.3.010-4: `customfield_NNNNN` literal bypass on create — same bypass behavior as BC-3.4.015 Step 1, against createmeta instead of editmeta.
- EC-3.3.010-5: Option-type field, human display value not in `allowedValues` → exit 64 listing allowed values (same shape as EC-3.4.016-2), sourced from the createmeta field entry.
- EC-3.3.010-6 **[ADDED 2026-08-26, F2 adversary-convergence pass, D2; ORDERING NOTE ADDED 2026-08-26, F2 adversary-convergence round-2, Pass2-F5; EXAMPLE CORRECTED + RENUMBERED 2026-08-26, F2 adversary-convergence round-3, F-LOW-4/F-MED-1]**: `jr issue create --priority Medium --field priority=Low` (or `--field priority:name=Medium`, or `--type Bug --field issuetype:id=10001`, or `--component X --field components:name=Y`, any argv order) → the create-path collision guard (D2, step 2b) fires BEFORE project/type resolution, BEFORE the createmeta enumeration call, and BEFORE POST → exit 64, overlap error naming the colliding field, zero HTTP calls. Symmetric with BC-3.4.017 EC-3.4.017-16 (edit path). **[CORRECTED, F-LOW-4]** The `--component` example uses the bare form `--component X`, not `--component add:X` — `add:`/`remove:` prefix syntax is an `issue edit`-only convention (BC-3.4.006); on `issue create`, `--component` takes a bare component name/id with no prefix grammar, so `add:X` would be treated literally as a (almost certainly nonexistent) component named `"add:X"` rather than illustrating the collision. **If `--on-behalf-of` is ALSO present on the same invocation** (no `--request-type`), BC-3.8.013's standalone guard (step 2) is evaluated BEFORE `parse_field_kv`'s hint-parse pass (step 2a) and BEFORE this collision guard (step 2b) — see `Platform-Path Guard Ordering — handle_create` SSOT block for the deterministic step-2-vs-2a-vs-2b rationale; this EC's own example invocations above assume `--on-behalf-of` is absent. **A malformed `--field` hint present alongside a would-be collision** (e.g. `--field cf:bogus=X --priority X --field priority=Y`) surfaces ONLY `parse_field_kv`'s step-2a error (BC-3.4.031) — this collision guard (step 2b) is never reached, since step 2a's failure short-circuits before step 2b's input (the parsed map) is available in valid form.
- EC-3.3.010-6a **[ADDED 2026-08-26, F2 adversary-convergence round-5, F-NEW-1 — governed set widened 5→9, ADR-0019 § "D2 correction (adversary F-NEW-1)"]**: EC-3.3.010-6's five collision examples (`summary`/`description`/`issuetype`/`priority`/`components`) are NOT the complete governed set on `issue create` — the create-path guard covers THREE more static-key collisions (`labels`/`parent`/`assignee`) plus the resolved-id category (`points`/`team`), none of which existed in the original D2 execution:
  - `jr issue create --label foo --field labels=bar` (or `--field Labels=bar`, or any hint kind, any argv order) → guard fires for `labels`, exit 64, zero HTTP. **This DIFFERS from the edit path on purpose, not by oversight:** `issue edit --field` Gate B (BC-3.4.017 "Scope of Gate B") deliberately EXCLUDES `labels` because `issue edit --label` forks to a different endpoint/payload shape entirely (BUG-LABEL-400: single-key PUT with bare-string labels vs. multi-key bulk POST with `{"name":…}` objects) — there is no single `fields.labels` write on edit for Gate B to guard a collision against. `issue create --label` has NO such fork: it is one code path writing `fields["labels"] = json!(labels)` unconditionally (`src/cli/issue/create.rs::handle_create`), so `labels` MUST be governed here even though it is excluded on edit.
  - `jr issue create --parent FOO-1 --field parent=BAR-2` (any hint kind, any argv order) → guard fires for `parent`, exit 64, zero HTTP.
  - `jr issue create --to jane --field assignee=other-account-id` (or `--account-id <id> --field assignee=other-account-id` — clap `conflicts_with` already prevents `--to`/`--account-id` together, so only one can trigger this collision per invocation) → guard fires for `assignee`, exit 64, zero HTTP.
  - `jr issue create --points 5 --field customfield_10050=8` (where `customfield_10050` is the active profile's configured `story_points_field_id`) → guard fires via RESOLVED-ID equality (not a static key compare — the wire key varies per Jira instance), exit 64, zero HTTP. `resolve_story_points_field_id` is unconditionally config-only (errors rather than HTTP-falling-back when unconfigured), so this detection is available whenever `story_points_field_id` is configured at all.
  - `jr issue create --team "Platform Core" --field customfield_10060=other-team` (where `customfield_10060` is the active profile's configured `team_field_id`) → guard fires via the SAME resolved-id mechanism, but ONLY when `team_field_id` is already present in profile config (the common `jr init`-driven case) — `client.find_team_field_id()` (HTTP) is NEVER invoked to service this guard; when `team_field_id` is absent from config, this specific branch is a no-op for the invocation (both values still reach the merge unordered, the pre-existing latent risk, now narrowed to this one case).
  - **Bounded non-firing residual, documented not silently gapped:** `jr issue create --points 5 --field "Story Points"=8` (a human DISPLAY NAME on the `--field` side, not the `customfield_NNNNN` bypass form) does **NOT** trip the guard — resolving a display name to compare against the already-resolved `story_points_field_id` would require a `fields.json`/`list_fields()` lookup that can issue `GET /rest/api/3/field` on a cold cache, which would hoist general field-name resolution ahead of the step-2b zero-HTTP boundary the entire `Platform-Path Guard Ordering` SSOT block is built on. This is the same *kind* of bound as edit-path Gate B's pre-existing "team/points deferred to v2" exclusion (BC-3.4.017 "Scope of Gate B"), narrower in scope (only the display-name spelling of `--field`, not the whole field) rather than eliminated.
  See ADR-0019 § "D2 correction (adversary F-NEW-1)" for the full nine-member table and rationale.

**Verification Properties**:
- VP-578-001: `--field` on platform create resolves via createmeta (not editmeta); `GET /rest/api/3/issue/{key}/editmeta` is NEVER called on the create path.
- VP-578-002: Field-list cache (`fields.json`) is shared between `issue edit --field` and `issue create --field` — a warm cache populated by one command satisfies the other (same profile).
- VP-578-003: All-or-nothing multi-`--field` failure on create — matches VP-396-009 semantics transplanted to the create path; zero POST on any resolution failure.
- VP-578-020 **[NEW, adversary pass-28 F-1; EXTENDED, adversary pass-29 F-1]**: createmeta-family multi-page resolution, covering BOTH createmeta-dependent endpoints this BC relies on — (a) field enumeration (`get_createmeta_fields`): a `--field` whose target field lands on createmeta fields-page ≥2 (a two-page fixture: `maxResults` fields on page 1, target field on page 2, `total` spanning both) is collected and resolves (exit 0, field merged into the POST body), NOT dropped with a spurious "not on the Create screen" exit 64; (b) issue-type name→id resolution (`get_issue_types_for_project`, S-331): a `--type` name whose entry lands on issuetypes-list page ≥2 (an analogous two-page fixture: `maxResults` issue types on page 1, target type on page 2, `total` spanning both) resolves to its `issueTypeId` and the create proceeds, NOT dropped with a spurious unknown-issue-type exit 64. Both cases mirror the `list_worklogs`/BC-X.5.002 all-pages pagination precedent. Realized in `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md` in parallel by the formal-verifier (VP inventory + realization, extended for the pass-29 issuetypes two-page case); this BC cites the id as the enforcement point.
- VP-578-021 **[NEW, F2 adversary-convergence pass, D2; EXTENDED 2026-08-26, F2 adversary-convergence round-5, F-NEW-1 — governed set widened 5→9]**: the create-path collision guard (Invariant 5 / EC-3.3.010-6/6a above) is exercised over any argv ordering of a dedicated flag and a `--field` pair on the same wire key, any hint kind, and each field in the create-path's OWN nine-member governed set (ADR-0019 § "D2 correction (adversary F-NEW-1)"; distinct from, and NOT identical to, edit-path Gate B's five-member set — see BC-3.3.010 EC-3.3.010-6a for the full enumeration) restricted to `issue create`'s dedicated flags — asserting exit 64, the overlap error naming the colliding field, and ZERO HTTP calls (no createmeta GET, no POST). This extension specifically requires coverage of: (a) the FOUR newly-added static flags — `--label`/`--parent`/`--to`/`--account-id` (wire keys `labels`/`parent`/`assignee`); (b) the TWO resolved-id cases — `--points 5 --field customfield_NNNNN=8` and `--team X --field customfield_NNNNN=Y` (the latter only when `team_field_id` is configured); and (c) a NEGATIVE regression pin asserting the documented NON-firing residual case — `--points 5 --field "Story Points"=8` (a display-name spelling on the `--field` side) does NOT trip the guard and both values reach the merge unordered — this negative case is a documented-limitation pin, not a silently-accepted gap. Mirrors VP-396-005's edit-path Gate B coverage; realized by `field_resolve::detect_flag_field_overlap`'s own unit tests plus an integration test per call site (edit and create), per ADR-0019 § Amendment (2026-08-26) D2.

**Trace**: issue #578 (item 2); `.factory/phase-f1-delta-analysis/delta-analysis-field-dx.md` §3 impact table (`create.rs` row); `.factory/research/field-dx-feasibility-2026-08-25.md` claim 8; `.factory/research/field-dx-context-mechanism-2026-08-25.md` M2; `src/cli/issue/create.rs::handle_create`; `src/cli/issue/field_resolve.rs::resolve_edit_fields` (extended to accept a createmeta-vs-editmeta source parameter); `src/api/jira/issues.rs::get_issue_types_for_project` (reused, S-331); reuses `src/api/jira/issues.rs::get_createmeta_fields` (ADR-0019 §1, shared with BC-X.14.001 M2) — same `GET .../createmeta/{proj}/issuetypes/{itid}` call, one implementation for both stories

[NEW 2026-08-25 issue #578 F2]

---

#### BC-3.3.011: Error taxonomy for `issue create --field` on the platform path (createmeta-sourced, parallels BC-3.4.015/016's editmeta-sourced taxonomy)

**Confidence**: HIGH
**Source**: issue #578 F2 spec evolution; parallels BC-3.4.015 Edge Cases + BC-3.4.016 Edge Cases
**Subject**: Issue write — `--field` error taxonomy on platform create

**Description**: This BC pins the exit-64 error taxonomy for `issue create --field` failures, mirroring BC-3.4.015/016's editmeta-sourced taxonomy with `createmeta`/`"Create screen"` substituted for `editmeta`/`"Edit screen"` throughout. It exists as a separate BC (rather than folded into BC-3.3.010) because the error taxonomy is a distinct, independently-testable surface per house convention (see the BC-3.4.015 vs BC-3.4.016 split for the edit-path precedent).

**Error taxonomy**:
| Condition | Exit | Message shape | Source BC parallel |
|---|---|---|---|
| **[ADDED 2026-08-26, D2; SCOPE MADE EXPLICIT 2026-08-26, round-4, MED-1/F-3; GOVERNED SET WIDENED 5→9, round-5, F-NEW-1]** Dedicated-flag × `--field` wire-key collision, PLATFORM (non-JSM) path only (e.g. `--priority X --field priority=Y`, any argv order, any hint kind, any field in the create-path's OWN nine-member governed set — `summary`/`description`/`issuetype`/`priority`/`components`/`labels`/`parent`/`assignee` as static key compares, plus resolved-id `--points`/`--team` via the `customfield_NNNNN` bypass form only; distinct from, and NOT identical to, edit-path Gate B's five-member set — see BC-3.3.010 EC-3.3.010-6a and ADR-0019 § "D2 correction (adversary F-NEW-1)" for the full enumeration) | 64 | Overlap error naming the colliding field (Gate B message shape, shared function) — evaluated BEFORE every other row in this table, before project/type resolution, and before any HTTP call. Does NOT apply on the JSM create path — see BC-3.8.008 (unchanged last-wins; extending this guard to JSM is DEFERRED, flagged for the F2 human gate) | BC-3.4.017 Gate B / EC-3.4.017-16 parallel; ADR-0019 § Amendment (2026-08-26) D2, § "D2 correction (adversary F-NEW-1)" |
| Zero matches in `list_fields()` | 64 | Actionable hint naming `jr project fields` | EC-3.4.015-1 |
| Multiple substring matches | 64 | Lists ambiguous candidates with `customfield_NNNNN` ids | EC-3.4.015-2 |
| Field absent from resolved issue type's createmeta | 64 | `"is not on the Create screen"` + `"A project admin must add it to the Create screen"` (substrings load-bearing, mirrors BC-3.4.015's Edit-screen substrings) | EC-3.4.015-3, substituted |
| Number field, non-numeric/non-finite VALUE | 64 | Same parse-error shape as EC-3.4.015-4 | EC-3.4.015-4 |
| `array`/`any` schema type | 64 | Unsupported-type message | EC-3.4.015-5 |
| Option field, VALUE matches no `allowedValues[].value` | 64 | Lists allowed values | EC-3.4.016-2 |
| Option field, VALUE ambiguous substring match | 64 | Lists ambiguous candidates with ids | EC-3.4.016-3 |
| Option field, matched entry has `id: None` | 64 | `"no machine-readable id"` message | EC-3.4.016-8 |
| `list_fields()` / createmeta HTTP failure (401/403/5xx) | propagated | Standard `JrError` auth/API hint | EC-3.4.015-6/7, substituted |

**No createmeta-specific `operations` check** — see BC-3.3.010 note (createmeta has no `operations` array; that concept is editmeta-only).

**Postconditions**:
- Every error path in the table above emits exit 64 (or propagates the standard `JrError` mapping for HTTP failures) BEFORE any POST is attempted.
- `--output json` mode: same `{"error": "...", "code": 64}` envelope shape as every other platform-create pre-flight/resolution error (consistent with BC-3.8.012's Output/Errors convention).
- **[ADDED 2026-08-26, D2]** The dedicated-flag × `--field` collision row is evaluated FIRST, before every other row in THIS TABLE and before project/type resolution — mirroring BC-3.4.017 Invariant 1's "Gate B before Gate A" precedence on the edit path, since a flag-overlap is a programmer mistake equally invalid regardless of what any later resolution step would have found. **[SCOPE CLARIFIED 2026-08-26, F2 adversary-convergence round-2, Pass2-F5; RENUMBERED 2026-08-26, F2 adversary-convergence round-3, F-MED-1]**: "before every other row in this table" is scoped to THIS BC's own error-taxonomy rows only — it does NOT claim precedence over BC-3.8.013's `--on-behalf-of` guard (step 2) or `parse_field_kv`'s own malformed-hint exit-64 (BC-3.4.031, step 2a), both of which are separate, earlier-positioned guards in the `Platform-Path Guard Ordering` SSOT block that are not themselves rows in this table — step 2a in particular is a structural prerequisite of this row, since the D2 collision check operates on the `HashMap<String, FieldValueSpec>` `parse_field_kv` produces. When BC-3.8.013's guard, `parse_field_kv`'s parse pass, and this table's D2 collision row all have live trigger conditions on the same invocation, the earliest-numbered guard (step 2, then step 2a, then this row at step 2b) fires first and later-numbered guards are never reached — see the SSOT block for the full deterministic ordering.

**Verification Properties**:
- VP-578-004: Each row of the error taxonomy table is independently exercised by a wiremock test asserting exit 64, zero POST, and the exact load-bearing substring for that row.

**Trace**: issue #578 (item 2); BC-3.4.015 Edge Cases (EC-3.4.015-1..8, substituted "Create screen" for "Edit screen"); BC-3.4.016 Edge Cases (EC-3.4.016-2/3/8); BC-3.3.010 (resolution algorithm this taxonomy attaches to); BC-3.4.017 Gate B / `field_resolve::detect_flag_field_overlap` (shared collision-detection function, ADR-0019 § Amendment (2026-08-26) D2)

[NEW 2026-08-25 issue #578 F2]

---

### 3.4 Edit and Open

#### BC-3.4.001: `handle_open` MUST compose URL as `<instance_url>/browse/<key>` using `client.instance_url()` [MUST-FIX: NFR-R-B]

**Confidence**: HIGH
**Source**: `src/cli/issue/workflow.rs:~636` (BUG SITE: currently uses `client.base_url()`)

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
**Source**: `tests/issue_commands.rs:~609`
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
**Source**: `tests/issue_commands.rs:~647`
**Trace**: Pass 3 BC-1056 (R4)

---

#### BC-3.4.005: `issue edit` with multiple fields sends both in body simultaneously

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~689`
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
**Source**: `tests/cli_smoke.rs:~34`
**Trace**: Pass 3 BC-214

---

#### BC-3.4.008: `--points X` and `--no-points` clap conflict

**Confidence**: HIGH
**Source**: `tests/cli_smoke.rs:~280`
**Trace**: Pass 3 BC-215

---

#### BC-3.4.009: outer-loop deadline check MUST include `task_id` literal in stderr message

**Confidence**: HIGH
**Source**: issue #340 + PR #360; `src/api/jira/bulk.rs:~408` (`[deadline:bulk-outer]` site); `tests/bulk_deadline_propagation.rs`
**Subject**: Issue write (bulk edit path)
**Behavior**: When `await_bulk_task_inner`'s top-of-loop deadline check fires (i.e., the
bulk task remained non-terminal until the caller-supplied wall-clock deadline expired),
the `JrError::DeadlineExceeded` error message emitted to stderr MUST contain the literal
value of `task_id` AND the site tag `[deadline:bulk-outer]`. The message format is:
`"[deadline:bulk-outer] Bulk task <task_id> did not complete within <N>s timeout. Check Jira for task status."`
This allows the user to recover manually by inspecting the task directly at
`jr api /rest/api/3/bulk/queue/<task_id>`.

**Scope**: This contract applies exclusively to the outer-loop deadline site
(`[deadline:bulk-outer]` tag at `src/api/jira/bulk.rs:~408`). It does NOT extend to
inner-loop deadline exits (`[deadline:429-retry]` in `JiraClient::send_inner`,
`src/api/client.rs:~585`), because `task_id` is not in scope at those sites and
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
- **`Option<IssueType>` outer-layer flatten**: `issue.fields.issuetype` in `src/types/jira/issue.rs:~62` is `Option<IssueType>` (the whole issuetype object may be absent from the response). `IssueType.subtask` is itself `Option<bool>`. The caller MUST flatten both layers: `issue.fields.issuetype.as_ref().and_then(|t| t.subtask)`. Two distinct sources of `src_subtask: None` exist: (a) the `issuetype` object is wholly absent from the response `fields` — `Option<IssueType>` is `None`; (b) `issuetype` is present but its `subtask` key is omitted from the JSON — `IssueType.subtask` is `None`. Both (a) and (b) collapse to `src_subtask: None` → Indeterminate via the and_then flatten.
- **`get_project_issue_types` deserialization behavior (net-new lookup)**: The type-name lookup against `get_project_issue_types` is **net-new F4 logic** built inside `handle_edit`'s error path — it does not pre-exist. `get_project_issue_types` calls `GET /rest/api/3/project/{key}`, extracts `issueTypes`, and deserializes via `.and_then(|v| from_value::<Vec<IssueTypeMetadata>>(v).ok()).unwrap_or_default()` (live code, `src/api/jira/projects.rs:~47`). A 200 response with a malformed or missing `issueTypes` key returns `Ok(vec![])` — NOT an `Err`. Therefore deserialization failure is NOT an Indeterminate-trigger; only an HTTP error or network error causes `get_project_issue_types` to return `Err` (→ Indeterminate). A 200 with an unparseable body yields `Ok([])` → the target name is absent from an empty list → the **unresolvable-name sub-path** (typo hint), NOT Indeterminate. This graceful outcome is acceptable: a malformed project-metadata response is rare and the typo hint is not harmful. The client-side name lookup uses **case-insensitive exact match** on the `name` field — this is a deliberate choice for the error-enrichment path and may not perfectly mirror Jira's server-side resolution, but divergence only affects which hint is shown, never edit correctness.
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

- Surface the `extract_error_message`-processed 400 message text carried in `JrError::ApiError.message` on stderr (this is the extracted message only — e.g., `issuetype: The issue type selected is invalid.`; the raw JSON envelope such as `{"errors": {...}}` is NOT surfaced because `JiraClient::parse_error` in `src/api/client.rs` runs `extract_error_message()` on the response bytes before constructing `JrError::ApiError.message`; `extract_error_message` is `sanitize_for_stderr(extract_error_message_raw(body))` per `src/api/client.rs:~1481` — for plain-ASCII message text, `sanitize_for_stderr` is a no-op, so test substrings from plain-ASCII extracted text are safe; test assertions MUST use plain-ASCII substrings, not control characters or multibyte sequences). When asserting this in tests (#3), choose a substring from the EXTRACTED message (e.g., `The issue type selected is invalid` survives extraction; `{"errors"` or `"issuetype":` as raw JSON keys do not).
- `CROSS_HIERARCHY_HINT` (containing `JRACLOUD-27893`) MUST NOT appear on stderr.
- The pure classifier (`is_cross_hierarchy_type_error`) is NOT invoked on this path.

**SameCategory sub-path (classifier-side)** — `get_project_issue_types` succeeds and the target name IS found; `is_cross_hierarchy_type_error` returns `SameCategory`: both `src_subtask` and `tgt_subtask` are `Some(_)` and the inner boolean values are equal. This covers valid type names rejected by workflow or scheme constraints (a valid type name rejected because the target workflow lacks the issue's current status). The enrichment lookup that determines whether the name IS found uses **case-insensitive exact match on the issue-type `name` field** (so the enrichment verdict agrees with how Jira server-side resolves the type name; partial_match substring matching MUST NOT be used, which could mis-resolve ambiguous type names):
- Emit the same pinned typo hint on stderr (verbatim above).
- Surface the `extract_error_message`-processed 400 message text carried in `JrError::ApiError.message` on stderr (same extraction semantics as the unresolvable-name sub-path above — `sanitize_for_stderr(extract_error_message_raw(body))` is effectively a no-op for plain-ASCII text; assert a plain-ASCII substring from the extracted message in tests (#4), not raw JSON envelope keys).
- `CROSS_HIERARCHY_HINT` (containing `JRACLOUD-27893`) MUST NOT appear on stderr.

**Indeterminate sub-path** — `is_cross_hierarchy_type_error` returns `Indeterminate`. This occurs in two distinct ways:
1. **Either enrichment fetch fails** (Cause-1): `get_issue` OR `get_project_issue_types` returns `Err` — detected by `Result::is_err()` on the call result. ANY `Err` variant triggers Indeterminate: `JrError::NotAuthenticated` (e.g., a `get_issue` 401), `JrError::InsufficientScope` (a `get_issue` 403 scope failure), `JrError::ApiError { status: 5xx, .. }`, network errors, and all other `Err` variants. The `handle_edit` caller does NOT downcast or inspect the error variant — `is_err()` is the gate. NOTE: a 200 response with a malformed `issueTypes` body is NOT a fetch failure — `get_project_issue_types` returns `Ok(vec![])` in that case (due to `.and_then(|v| from_value::<Vec<IssueTypeMetadata>>(v).ok()).unwrap_or_default()` in `src/api/jira/projects.rs:~47`), which routes to the unresolvable-name sub-path (typo hint), NOT Indeterminate. Indeterminate via Cause-1 requires an actual `Err`, not a 200 with malformed body.
2. **A fetch succeeds but the `subtask` field is absent** (Cause-2): `get_issue` or `get_project_issue_types` returns HTTP 200, but the `issuetype.subtask` field is missing (`None`) after deserialization (field omitted by Jira). The pure classifier `is_cross_hierarchy_type_error(None, _, _)` or `is_cross_hierarchy_type_error(_, None, _)` returns `Indeterminate`. Note: for the source-issue side, Cause-2 also covers the case where the `issuetype` object is wholly absent (`Option<IssueType>` is `None`), because `issue.fields.issuetype.as_ref().and_then(|t| t.subtask)` produces `None` for both a missing issuetype and a present-but-subtask-absent issuetype.

On either Indeterminate cause:
- Surface the `extract_error_message`-processed 400 message text carried in `JrError::ApiError.message` on stderr with NO enrichment hint. When asserting this in tests (#6, #7), choose a substring from the extracted message, not raw JSON envelope keys.
- Neither the cross-hierarchy hint (`CROSS_HIERARCHY_HINT`) nor the typo/workflow hint is emitted.
- Exit code 1.

**Preconditions**:
- Single-key `jr issue edit KEY --type X` is issued.
- `edit_issue` returns HTTP 400. (If `edit_issue` fails with a non-400 error, no enrichment occurs — see R0b routing row / test #10.)
- **Call ordering**: `handle_edit` calls `get_issue` FIRST. Only if `get_issue` succeeds (HTTP 200) is `get_project_issue_types(project_key)` called. A `get_issue` failure — detected by `Result::is_err()` (ANY `Err` variant, not a downcast) → Indeterminate immediately (the second call never executes). The unresolvable-name sub-path is reachable only when `get_issue` already succeeded. This ordering ensures the caller-side routing is provably total with no input matching two branches simultaneously.
- **`Option<IssueType>` outer-layer flatten**: `issue.fields.issuetype` (`src/types/jira/issue.rs:~62`) is `Option<IssueType>`; `IssueType.subtask` is `Option<bool>`. The caller MUST read `src_subtask` via `issue.fields.issuetype.as_ref().and_then(|t| t.subtask)`. Two distinct sources of `src_subtask: None` exist: (a) the `issuetype` object is wholly absent from the response — `Option<IssueType>` is `None`; (b) `issuetype` is present but its `subtask` key is omitted from the JSON — `IssueType.subtask` is `None`. Both (a) and (b) collapse to `src_subtask: None` → Indeterminate. Test #6 covers case (b) (source-side subtask key omitted); it also covers case (a) via the same `and_then` flatten path — both produce `src_subtask: None` and route identically.
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
- `components` **[NEW, issue #605 F2]** **[UPDATED 2026-08-15, H1 fix-burst]** → comma-joined
  `add:name`/`remove:name` pairs in CLI input order (e.g. `add:Backend, remove:Frontend`) —
  mirrors `--label`'s absence from this list only because `--label` routes through the
  separate `handle_edit_bulk_labels` path (see the exclusion note below); `--component` stays
  on the single-key `handle_edit` path (BC-3.4.022) and IS covered by this echo mechanism.
  This STRING format is now shared byte-for-byte between the table-mode echo (this BC) and
  the JSON-mode `changed_fields["components"]` value (BC-3.4.013) — see BC-3.4.013's Behavior
  for the H1 resolution rationale (a prior draft had JSON emit a `components` JSON ARRAY,
  which was structurally incompatible with the shared `BTreeMap<String, String>` model this
  BC's own Postconditions describe; corrected here so both channels emit the identical
  lowercase `add:`/`remove:` string). **[PINNED 2026-08-15, L2 fix-burst — pass 3, closes an
  unspecified-echo gap found by adversarial spec-delta review pass 3]** A BARE `--component
  Backend` (no `add:`/`remove:` prefix) is internally normalized to an ADD entry BEFORE this
  echo mechanism runs — the SAME normalization EC-3.4.022-2 already documents for the wire
  body (`--component Backend` produces `{"add":{"name":"Backend"}}`, identical to `--component
  add:Backend`). The echo therefore shows the NORMALIZED form, `add:Backend`, never the raw,
  unprefixed `Backend` — a bare entry and an explicit `add:`-prefixed entry for the same
  component name are INDISTINGUISHABLE in the echo, by design (both mean the same thing to the
  wire body). This holds for BOTH the table-mode echo (this BC) and the JSON-mode
  `changed_fields["components"]` value (BC-3.4.013), and is the SAME normalized string the
  `--dry-run` TABLE preview (BC-3.4.021 Postconditions — `--output table` item 1, `components →
  add:X, remove:Y`) shows for a bare entry. **[SCOPED 2026-08-15, P4 fix-burst — resolves an
  overbroad claim found by adversarial spec-delta review pass 4, LOW-2]** This byte-for-byte
  consistency holds across exactly THREE surfaces: the live table-mode echo (this BC), the live
  JSON-mode `changed_fields["components"]` value (BC-3.4.013), and the **dry-run TABLE**
  preview line — all three are the identical lowercase `add:`/`remove:` comma-joined STRING.
  It does NOT extend to the **dry-run JSON** surface: `plannedChanges.components` (BC-3.4.021
  Postconditions — `--output json` item 3) is a JSON ARRAY of `{"action": "ADD"|"REMOVE",
  "name": "..."}` objects — a deliberately different, simplified-preview TYPE from the shared
  string format the other three surfaces use (BC-3.4.021's own Description explicitly documents
  `plannedChanges` shapes as simplified previews that do NOT match live wire/echo payloads, the
  same convention `labels` already follows). **Previous version (superseded, retained for audit
  trail):** "...the three surfaces (live table echo, live JSON echo, dry-run preview) are
  byte-for-byte consistent for a bare input, not merely for an explicitly-prefixed one." — this
  named "dry-run preview" without disambiguating table vs. JSON output mode, which reads as
  covering both; it covers only the dry-run TABLE preview. The dry-run JSON preview was never
  byte-for-byte consistent with the other three (it is array-of-objects vs. string, a type
  difference, not merely a formatting one) — this was the H1-fix-burst's own deliberate design
  choice for `plannedChanges` (mirroring `labels`), not a defect, but the "three surfaces"
  wording here did not say so explicitly. The user-visible BEHAVIOR is unchanged; only this
  sentence's scope is corrected.

Map keys are always the literal lowercase identifiers in the key table (`summary`, `issue_type`, `priority`, `parent`, `points`, `team`, `description`, `components`) — never `customfield_*` IDs. The issue-type key is the literal `issue_type` (matching the Rust field identifier), NOT `type` and NOT `issuetype`.

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
- EC-3.4.012-17 **[NEW 2026-08-15, L2 fix-burst — pass 3]**: `jr issue edit KEY --component Backend` (bare, no `add:`/`remove:` prefix) → stderr echo is `  components → add:Backend` — the bare entry is normalized to the `add:` form (per the `components` bullet's L2-fix-burst pin above) before the echo line is composed, NOT `  components → Backend`. Identical normalization applies if `--component Backend` is combined with a prefixed entry, e.g. `--component Backend --component remove:Frontend` → `  components → add:Backend, remove:Frontend`.

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
| `"components"` **[NEW, issue #605 F2]** **[UPDATED 2026-08-15, H1 fix-burst — resolves a structural contradiction found by adversarial spec-delta review pass 1]** | Comma-joined `add:name`/`remove:name` pairs in CLI input order (e.g. `"add:Backend, remove:Frontend"`) — a JSON STRING, identical format and CLI-input-order semantics to the table-mode echo (BC-3.4.012's `components` bullet). NOT a JSON array. **Previous version (superseded, retained for audit trail — do NOT re-implement):** "JSON array of `{"action":"ADD"\|"REMOVE","name":"<name>"}` objects, one per `--component` spec, in CLI input order — same flat-array shape convention as the dry-run `plannedChanges.components` preview (BC-3.4.021)... This is a JSON ARRAY value, not a string — the sole exception to 'all values are JSON strings' noted above." That design was structurally impossible: `edit_response`'s signature (`changed_fields: &BTreeMap<String, String>`, confirmed below) and BC-3.4.012 Postconditions ("Both table-mode echo and JSON-mode `changed_fields` iterate the same `BTreeMap`, guaranteeing identical ordering") both require every value to be a `String` — an array-valued entry cannot exist in a `BTreeMap<String, String>`. Corrected here so the JSON channel emits the SAME string this BC's table-mode sibling emits — no exception to "all values are JSON strings" remains. The dry-run preview (BC-3.4.021 `plannedChanges.components`) and the two wire-body shapes (BC-3.4.022's `update`-verb object form, BC-3.4.023's bulk integer `componentId` form) are UNCHANGED by this correction — they are separate JSON payloads (dry-run preview, HTTP request bodies) governed by their own BCs, not by `changed_fields`. **[PINNED 2026-08-15, L2 fix-burst — pass 3, closes an unspecified-echo gap found by adversarial spec-delta review pass 3]** A BARE `--component Backend` (no `add:`/`remove:` prefix) is normalized to `"add:Backend"` before this value is composed — same normalization as the table-mode echo (BC-3.4.012's L2-fix-burst pin) and the same normalization EC-3.4.022-2 documents for the wire body; `changed_fields["components"]` for a bare entry is therefore `"add:Backend"`, never the raw `"Backend"`. |

`--label` edits (single OR multi key) route through `handle_edit_bulk_labels` and are NOT covered by this contract; no `"label"` key appears in `changed_fields`. `--component` (issue #605) stays on the single-key `handle_edit` path (BC-3.4.022) and IS covered — see the `"components"` row above.

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
- EC-3.4.013-14 **[NEW 2026-08-15, L2 fix-burst — pass 3]**: `jr issue edit KEY --component Backend --output json` (bare, no `add:`/`remove:` prefix) → `changed_fields["components"] == "add:Backend"` — the bare entry is normalized to the `add:` form (per the `"components"` row's L2-fix-burst pin above) before the JSON value is composed, NOT `"Backend"`.

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
- **[AMENDED 2026-08-25 issue #578 F2]** `--field NAME[:kind]=VALUE` (BC-3.3.010, repeatable) → echo KEY is the human field name as resolved via `list_fields()`/`fields.json` cache, or the literal `customfield_NNNNN` string for the bypass form — the SAME key convention as the edit-path `changed_fields` map (BC-3.4.015 Invariant 2), not a new one. Echo VALUE mirrors the edit-path `changed_fields` value convention exactly, keyed on the resolved hint kind: bare form / `:option` hint (BC-3.4.016 / BC-3.4.027) → the resolved human-readable `allowedValues` label, never the numeric id (non-cascading), or `"<parent> > <child>"` for a cascading option (both matched labels, `>`-joined); `:id` hint (BC-3.4.028) → the raw id literal, verbatim, no reverse lookup; `:name` hint (BC-3.4.029) → `VALUE` verbatim, no lookup; `:asset` hint (BC-3.4.030) → the composite `"<workspaceId>:<objectId>"` string. Every non-hint (string/number/date/datetime/user) field resolved via `--field` echoes the raw supplied `VALUE` string, identical to BC-3.4.015 Postcondition "Table-mode stderr: `  <NAME> → <VALUE>` echo line". Each `--field`-set entry interleaves into the SAME single alphabetical field-name ordering as every other echoed field in this list (no separate block) — e.g. a `--field priority=High` entry sorts under `priority` exactly where the dedicated `--priority` flag's echo would; a `--field customfield_10050:option=Gold` entry with no resolvable human name sorts under the literal string `customfield_10050`. **[AMENDED 2026-08-26, F2 adversary-convergence pass, D2; SCOPE MADE EXPLICIT 2026-08-26, F2 adversary-convergence round-4, MED-1/F-3]** A `--field priority=High` entry sorting under `priority` alongside a dedicated `--priority` flag on the SAME invocation is no longer reachable in practice on THIS (platform, non-JSM) BC's own path — per ADR-0019 § Amendment (2026-08-26) D2, a new PLATFORM create-path collision guard (mirroring BC-3.4.017's Gate B via the shared `field_resolve::detect_flag_field_overlap` function) rejects any invocation combining a dedicated flag with a `--field` pair targeting the same wire key (any argv order, any hint kind, any field in the create-path's OWN nine-member governed set — **[WIDENED 5→9, 2026-08-26, round-5, F-NEW-1]** distinct from, and NOT identical to, edit-path Gate B's five-member set — see BC-3.3.010 EC-3.3.010-6a and ADR-0019 § "D2 correction (adversary F-NEW-1)") with exit 64 before any HTTP call or echo assembly — see BC-3.4.029 EC-3.4.029-2 and BC-3.3.010/BC-3.3.011. This guard is scoped to the platform path only (this BC's own Precondition already excludes `--request-type`); the JSM path (BC-3.8.011's echo scope, EC-3.4.014-4) is unaffected and retains BC-3.8.008's last-wins behavior — extending the guard to JSM is DEFERRED, flagged for the F2 human gate. **Previous version (superseded, retained for audit trail):** "...(last-flag-wins on the wire per BC-3.4.029 EC-2 if both are supplied on one invocation)..." — this described a live merge-order outcome for a combination the new create-path guard now rejects pre-HTTP; the sort-position example itself remains valid for the (non-colliding) fields that DO reach the echo.

**Fields NOT echoed**:
- `project` — implicit/required; not echoed (same decision as BC-3.4.012 which does not echo the issue key).
- `--request-type` path fields — the JSM path is governed by BC-3.8.011; this contract applies to the platform path only.
- `--label` on create is the platform single-POST path (NOT the bulk path used by `edit --label`). Because all labels are present in the create POST body, echoing them as a comma-joined list is feasible and IS implemented. There is no `label` key exclusion on create (contrast with BC-3.4.012 which explicitly excludes `label` because `edit --label` routes through `handle_edit_bulk_labels`).

**JSON mode is UNCHANGED**: `issue create --output json` already performs a follow-up GET returning the full created issue object — a superset of the edit `changed_fields`. No `changed_fields` key is added to create JSON output; the JSON path is byte-for-byte identical to pre-#398 behavior. The full issue object is richer than `changed_fields` would be, making a `changed_fields` addition redundant.

**Output channel profile**: All output lines (`Created issue <key>`, field echo lines, browse URL) are emitted to **stderr**. Stdout is empty in table mode. The browse URL was already on stderr pre-#398 (via `eprintln!`). This is **output channel profile 4 (Symmetric)**: stdout is empty in table mode; in `--output json` mode stdout carries the full JSON payload while stderr is empty. Profile-4 carve-out: success confirmation lines on stderr is pre-existing behavior, not an error path. #398 only inserts field-echo lines into the same pre-existing stderr stream.

**Preconditions**:
- `jr issue create [flags...]` issued without `--output json`.
- The `--request-type` flag is absent (platform create path; JSM path is governed by BC-3.8.011). **[DEC-188 qualifier, reversed 2026-08-25 issue #578 for `--field`]** This precondition (exit 0 + field echo) holds only when `--on-behalf-of` is not present; if `--on-behalf-of` is present without `--request-type`, exit 64 fires per BC-3.8.013 before field echo is reached. `--field` no longer triggers a step-2 exit-64 guard — per BC-3.8.012's 2026-08-25 reversal, a bare `--field` resolves via `createmeta` (BC-3.3.010) and its successful resolution IS reflected in this BC's field echo: see the `--field NAME[:kind]=VALUE` bullet in the "Fields echoed and their table-mode values (create-path enumeration)" list above for the concrete echo KEY/VALUE rules per hint kind.
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
[AMENDED 2026-08-25 issue #578 F2: DEC-188 --field echo-suppression qualifier reversed per DEC-310; --on-behalf-of suppression retained]

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

**`resolve_edit_fields` canonical signature** (as of F2 amendment, P2-006 corrected, F-1 reconciled; superseded 2026-08-25 by ADR-0019 §2 — see the [AMENDED 2026-08-25 issue #578 F2] note below for the current signature):
`resolve_edit_fields(client: &JiraClient, profile: &str, key: &str, field_pairs: &HashMap<String, String>, fields: &mut Value, changed_fields: &mut BTreeMap<String, String>) -> Result<()>`

The `field_pairs` parameter is `&HashMap<String, String>` (NOT `&[(String, String)]`) because `parse_field_kv` (the upstream parser at `src/cli/issue/create.rs::parse_field_kv`) returns `HashMap<String, String>`. `parse_field_kv` uses `map.insert(key, value)` with last-wins semantics — duplicate `--field` keys are collapsed AT PARSE TIME, before `resolve_edit_fields` ever runs. An ordered slice would be structurally incompatible with this upstream output. `HashMap` is the correct type at this boundary. **This paragraph describes the pre-#578 (bare-form-only) signature; per ADR-0019 §2, `field_pairs` changes to `&HashMap<String, FieldValueSpec>` — see the amendment note below.**

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
  → wire value is the JSON number `5` (NOT `5.0`). The integer wire form comes from an
  explicit f64→i64 narrowing in `src/cli/issue/field_resolve.rs::parsed_number_to_wire_value`,
  NOT from `serde_json::Number::from_f64` — `Number::from_f64(5.0)` stores an internal
  `N::Float` representation and serializes as `5.0`, which would fail
  `tests/issue_edit_field.rs` Test 26 (wiremock `NumericMode::Strict`). The real mechanism:
  when `parsed.fract() == 0.0` AND `parsed` is strictly within i64 bounds (`> i64::MIN as
  f64` AND `< i64::MAX as f64`), `parsed_number_to_wire_value` takes the integer branch:
  `serde_json::Value::Number(serde_json::Number::from(parsed as i64))` — this emits the
  bare integer literal `5`. When the bounds check fails (out-of-i64-range inputs per
  EC-3.4.015-4b), it falls through to `serde_json::json!(parsed)` which emits the f64
  wire form. **Callers MUST NOT use `serde_json::Number::from_f64` for whole numbers** —
  doing so emits `5.0` instead of `5` and will break strict-mode JSON consumers. VP-396-010
  pins this invariant. `5e3` round-trips as `5000` (the input parses to `f64(5000.0)`;
  `fract() == 0.0` takes the integer branch → `Number::from(5000_i64)`). `5.5` serializes
  as `5.5` (non-zero fractional part → falls through to `serde_json::json!(5.5_f64)`).
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

**[AMENDED 2026-08-25 issue #578 F2] Hint-syntax interaction**: `--field` gains an OPT-IN
`NAME:kind=VALUE` hint-syntax extension (BC-3.4.026-031). The algorithm above (Steps 1-6)
describes the BARE-form (`NAME=VALUE`, no `:kind` suffix) dispatch. Bare-form auto-detect-from-
`schema.type` behavior is UNCHANGED and PERMANENT — this BC's contract is not narrowed,
deprecated, or superseded by the hint-syntax addition (BC-3.4.026 Invariant 1). A hinted pair
(`NAME:option=VALUE`, `NAME:id=VALUE`, `NAME:name=VALUE`, `NAME:asset=VALUE`) bypasses Step 4's
schema-type dispatch entirely for that pair — see BC-3.4.026 (parser), BC-3.4.027 (`:option`,
same wire logic as this BC's `option`-type dispatch plus new cascading composition), BC-3.4.028
(`:id`, explicit id-bypass), BC-3.4.029 (`:name`), BC-3.4.030 (`:asset`). Per **ADR-0019 §2**
(Accepted 2026-08-25), `parse_field_kv`'s return type changes from `HashMap<String, String>` to
`HashMap<String, FieldValueSpec>` where `FieldValueSpec { kind: Option<FieldValueKind>, value:
String }`, keyed by the BARE field name (never a composite `"name:kind"` key — a repeated
`--field NAME` occurrence with different kind hints last-wins on the whole `FieldValueSpec`,
generalizing this BC's existing last-wins rule to the hinted form). `kind: None` is the bare form
this BC continues to govern; `resolve_edit_fields`'s parameter accordingly changes from
`field_pairs: &HashMap<String, String>` to `field_pairs: &HashMap<String, FieldValueSpec>`
(supersedes the canonical signature stated earlier in this BC). `resolve_edit_fields` reads each
entry's `spec.kind` and takes the hinted-bypass branch for that field BEFORE falling through to
the existing `schema.type` match when `spec.kind == None`. `HashMap` (not `Vec`) is retained per
this BC's existing rationale (no consumer needs argv order) — see BC-3.4.026 and ADR-0019 §2.

**`>` is a LITERAL character in the bare form — no split is ever attempted [ADDED 2026-08-26, ADR-0019 § Amendment D4, propagated by product-owner F2 adversary-convergence round-4, F-2/D4]:** BC-3.4.026's `str::split_once('>')` cascading-split obligation (BC-3.4.027 Invariant 5 / ADR-0019 § Amendment D3) is scoped to the `:option`-hint call sites ONLY (`field_resolve.rs`, `create.rs`'s platform-create path) and explicitly EXCLUDES this BC's bare-form dispatch. A bare `--field cf=Parent>Child` against a cascading (`option-with-child`) field is resolved exactly as this BC's existing algorithm (Step 4's `option` dispatch, delegating to BC-3.4.016 Step 4a) already resolves any bare value — the ENTIRE string `"Parent>Child"` is matched as one opaque candidate against `allowedValues[].value`. Since a cascading parent's own `.value` never itself contains a literal `>` in ordinary use, this whole-string match fails and falls through to the EXISTING EC-3.4.016-2 "unresolvable value, list allowed values" error — no new error path is introduced; it is the ordinary bare-form mismatch case. **Consequence: a cascading field's child value can ONLY be set via the explicit `--field cf:option=Parent>Child` form (BC-3.4.027)** — there is no bare-form path to a cascading child, by design, not by oversight. This asymmetry (only `:option` splits `>`) is the same shape as `:id`/`:name` bypassing `allowedValues` lookup entirely while the bare form performs it (BC-3.4.028/029 Invariant 1 vs. this BC) — `jr`'s hint syntax already establishes the convention that opting into a hint changes parsing behavior the bare form does not share. Cross-reference: BC-3.4.027 EC-3.4.027-7 (the sibling `:option`-hint non-cascading-collision case) and ADR-0019 § Amendment D4 cell (b). **Verification Properties: VP-578-023 [BACK-FILLED 2026-08-26, F2 adversary-convergence round-5, MED-2 — this citation was declared in BC-3.4.027 but missing from this note]** verifies the bare-form `>`-literal behavior described in this note: the bare form `--field cf=Parent>Child` treats `>` as literal text (no hint-driven split) and falls through to EC-3.4.016-2's unresolvable-value exit-64 shape, not BC-3.4.027 EC-3.4.027-7's distinct message. Declared (not duplicated) at BC-3.4.027; this is the second, back-filled citation site for the same VP, not a second VP.

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

**[AMENDED 2026-08-25 issue #578 F2] Hint-syntax interaction**: this BC's label→id
auto-detect dispatch is the BARE-form (`NAME=VALUE`, no `:kind`) behavior for `option`-schema
fields and remains UNCHANGED, PERMANENT, and the default when no hint is supplied — see
BC-3.4.015's parallel amendment note and BC-3.4.026 Invariant 1 (resolves the F1 BA/research
open question on bare-vs-hinted precedence: auto-detect is never deprecated). The explicit
opt-in spelling of this SAME dispatch is `--field NAME:option=VALUE` (BC-3.4.027) — identical
wire output for the non-cascading case (VP-578-007 pins byte-identical output between the bare
and `:option`-hinted forms for the same NAME/VALUE). BC-3.4.027 additionally introduces
cascading-select (`option-with-child`) composition via a `Parent>Child` compound value — NOT
covered by this BC's algorithm, and NOT reachable via the bare form (the bare form has no
cascading arm either, before or after this amendment) — see BC-3.4.027 for the cascading
contract (CONFIRMED per ADR-0019 §3, Accepted 2026-08-25). The
`:id`-hinted form (BC-3.4.028) is **[CORRECTED, adversary pass-16 LOW-1]** the explicit,
UNCONDITIONAL form of this BC's Step 1 id-bypass — Step 1's bare-form bypass auto-fires ONLY
when `VALUE` is numeric (matching an `allowedValues[].id`); `:id` bypasses the `allowedValues`
label lookup for ANY `VALUE`, numeric or not, making it a strict superset of the implicit
numeric-gated bypass, not merely a re-spelling of it. As a corollary, `:id` also works when a
numeric `VALUE` would otherwise be ambiguous against a label — but that ambiguity-resolution
benefit is secondary to, and does not substitute for, the primary unconditional/non-numeric
distinction. **[Pre-pass-16 wording, superseded, retained for audit trail]:** "the explicit,
unconditional spelling of this BC's Step 1 id-bypass path — bare-form id-bypass (Step 1 above)
still fires implicitly for a purely-numeric `VALUE` matching an `allowedValues[].id`; `:id`
makes that bypass explicit and works even when `VALUE` would otherwise be ambiguous against a
label" — this framing under-stated the non-numeric-VALUE case entirely, describing only the
ambiguity-resolution corollary as if it were the whole story.

---

#### BC-3.4.017: `--field` multi-key/`--jql` multi-issue rejection (C-1 guard) + flag-overlap hard error for `summary`/`description`/`issuetype`/`priority`/`components`

**[UPDATED 2026-08-15 issue #605 F2]** Gate B's scope is extended from four fields to FIVE:
`components` joins `summary`/`description`/`issuetype`/`priority`. `--component add:X --field
components=Y` (or `--field Components=Y`, case-insensitive) → Gate B fires identically to the
other four fields: `JrError::UserError`, exit 64, no HTTP. Rationale: `components` is a real
Jira system field name reachable via the generic `--field` escape hatch (unlike `--team`/
`--points`, which use dynamically-resolved custom field IDs and remain deliberately excluded
from Gate B per the existing "Scope of Gate B" paragraph below). **Previous version (four
fields, superseded, retained for audit trail):** "Exactly four first-party system fields
(`summary`, `description`, `issuetype`, `priority`)." New EC-3.4.017-15 below documents the
`components` case. `--field NAME` values are matched case-insensitively against the five
canonical keys `summary`, `description`, `issuetype`, `priority`, `components` — unchanged
matching mechanism, one more member in the set.

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

**Scope of Gate B**: Exactly five first-party system fields (`summary`, `description`,
`issuetype`, `priority`, `components` — the last added 2026-08-15 issue #605 F2). Team
(`--team`) and points (`--points`/`--no-points`) use dynamically-resolved custom field IDs;
overlap detection for those would require an API call, violating the "no HTTP before the
guard" invariant. These are deferred to v2. Unlike team/points, `components` needs no API
call to detect an overlap — `--component` is a first-party static flag exactly like
`--summary`/`--type`, so it fits Gate B's O(1) invariant cleanly.

**[AMENDED 2026-08-25 issue #578 F2, adversary pass-13 F-1]**: Gate B's flag-overlap matching
also fires for a hint-tagged `--field NAME:kind=VALUE` pair (BC-3.4.026 through BC-3.4.030),
not only the bare `--field NAME=VALUE` form. `parse_field_kv` keys its
`HashMap<String, FieldValueSpec>` on the BARE field name — the `:kind` suffix is stripped
before the map key is formed (BC-3.4.026 §"Rule (ADR-0019 §2(b))", normative) — so
`--field priority:name=Medium` resolves to key `priority` exactly like `--field
priority=Medium` does today. Gate B's overlap check operates on that same bare-name key,
so it cannot distinguish a hinted pair from a bare one: `--priority Medium --field
priority:name=Medium` fires Gate B identically to `--priority Medium --field
priority=Medium` (exit 64, no HTTP). This holds symmetrically for all FIVE canonical system
field keys (`summary`, `description`, `issuetype`, `priority`, `components`) and every hint
kind (`:option`, `:id`, `:name`, `:asset`) — e.g. `--type Bug --field issuetype:id=10001` and
`--component add:X --field components:name=Y` both fire Gate B identically to their bare-form
counterparts. See EC-3.4.017-16. This was originally EDIT-path-only, matching Gate B's
then-existing scope; BC-3.4.029 EC-3.4.029-2 (pre-2026-08-26) documented the CREATE-path
counterpart as having no Gate B guard, with last-wins applying instead — **superseded, see
below.**

**[AMENDED 2026-08-26, F2 adversary-convergence pass, D2; SCOPED 2026-08-26, F2
adversary-convergence round-4, MED-1/F-3]**: Gate B's flag-overlap
detection logic is now a SHARED, extracted pure function — `field_resolve::detect_flag_field_overlap`
(taking the already-parsed `HashMap<String, FieldValueSpec>` plus the caller-supplied set of
dedicated-flag wire-keys, returning the overlapping key set) — reused by BOTH this BC's Gate B
(`edit.rs`) AND a new, structurally identical PLATFORM (non-JSM) create-path guard (`create.rs`,
ADR-0019 § Amendment (2026-08-26) D2). `edit.rs`'s own Gate B call site is refactored to call
this shared function rather than embedding its own overlap-detection logic; this is a mechanism
change only — Gate B's own observable behavior (which invocations fire it, what error it emits,
when it runs relative to Gate A) is UNCHANGED. **The SHARED FUNCTION is a mechanism reuse only,
not a claim of identical governed-key sets: [ADDED 2026-08-26, F2 adversary-convergence round-5,
F-NEW-1]** `create.rs`'s guard is CREATE-path-only and passes `detect_flag_field_overlap` a
NINE-member wire-key set (`summary`/`description`/`issuetype`/`priority`/`components`/`labels`/
`parent`/`assignee`, plus resolved-id `--points`/`--team` via the `customfield_NNNNN` bypass form
— see BC-3.3.010 EC-3.3.010-6a and ADR-0019 § "D2 correction (adversary F-NEW-1)"), while THIS
BC's own Gate B (`edit.rs`) continues to pass the pre-existing FIVE-member set unchanged
(`summary`/`description`/`issuetype`/`priority`/`components` — "Scope of Gate B" above is NOT
widened by this round). The two callers share the detection FUNCTION, not the governed SET. The PLATFORM create-path counterpart BC-3.4.029
EC-3.4.029-2 previously described as "no Gate B guard exists there — last-wins applies" is now
FALSE FOR THE PLATFORM PATH and has been rewritten in place — see BC-3.4.029 EC-3.4.029-2
(current) and BC-3.3.010/BC-3.3.011 for the platform create-path guard's own
precondition/error-taxonomy treatment. **This does NOT extend to the JSM create path**
(`--request-type` set) — BC-3.8.008 retains its own pre-existing last-wins/duplicate-NAME
behavior unchanged; extending this guard to JSM is DEFERRED, flagged for the F2 human gate.

**Scope of Gate A**: `--field` is REJECTED_IN_BULK (not BULK_SUPPORTED). This is
intentional: the Jira Cloud Bulk API does not support arbitrary custom field writes;
adding bulk `--field` support would require a separate design pass.

**Preconditions for Gate A error**:
- 2+ positional keys supplied, OR `--jql` resolves to 2+ issues.
- `--field` is present.

**Preconditions for Gate B error**:
- **[UPDATED 2026-08-15 issue #605 F2, M5 fix-burst]** At least one of the FIVE dedicated
  flags (`--summary`, `--description`, `--type`, `--priority`, `--component`) is present AND
  the corresponding system field key (`summary`/`description`/`issuetype`/`priority`/
  `components`) is targeted by a `--field NAME=VALUE` pair (case-insensitive key comparison).
  **Previous version (superseded, retained for audit trail):** "At least one of the four
  dedicated flags (`--summary`, `--description`, `--type`, `--priority`)..." — this text was
  never updated when the "Scope of Gate B" paragraph and EC-3.4.017-15 below were extended to
  five fields, leaving the Preconditions section internally inconsistent with the rest of this
  BC; corrected here to match.

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
4. **[UPDATED 2026-08-15 issue #605 F2, M5 fix-burst]** The flag-overlap comparison on the
   `--field NAME` side is case-insensitive against the FIVE canonical system field keys
   (`summary`, `description`, `issuetype`, `priority`, `components`). A `--field SUMMARY=X` or
   `--field Summary=X` is detected as an overlap for `--summary Y`; `--field COMPONENTS=X` or
   `--field Components=X` is detected as an overlap for `--component X` (EC-3.4.017-15).
   **Previous version (superseded):** "...the canonical system field keys (`summary`,
   `description`, `issuetype`, `priority`)." — four-member enumeration, stale since
   `components` joined Gate B's scope.

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
  `description`, `issuetype`, `priority`, `components`. The key `type` does NOT match `issuetype`.
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
  name with underscores replaced by hyphens (clap's implicit default). Of the 13 fields
  currently in scope: `issue_type` carries `#[arg(long = "type")]` and maps to `--type`
  (NOT `--issue-type`); the other 12 (`summary`, `priority`, `team`, `points`,
  `no_points`, `parent`, `no_parent`, `description`, `description_stdin`, `markdown`,
  `field`, `component`) use the implicit snake→kebab transform. Any future field added to
  `BULK_SUPPORTED`/`REJECTED_IN_BULK` with a non-mechanical `long = "..."` rename will
  be caught by the R2 pin's 13-flag enumeration — the extractor side and the expected
  side must be reconciled together.
  **Assertion**: assert extracted `BTreeSet<String>` equals expected `BTreeSet<String>`.
  A regression that drops any `conflicting.push` line OR adds a new Edit field to
  `BULK_SUPPORTED`/`REJECTED_IN_BULK` without extending the conflict block fails this
  meta-test at `cargo test` time.
  **R2 pin**: include at least one pin test asserting the extractor correctly parses a
  known-good input string (e.g., assert extracted set has exactly 13 members for the
  current block: `--field`, `--summary`, `--priority`, `--type`, `--team`, `--points`,
  `--no-points`, `--parent`, `--no-parent`, `--description`, `--description-stdin`,
  `--markdown`, `--component`. `--label` itself is the guard condition on the outer `if`,
  not a pushed entry).
  **Co-author**: 11 positive regression tests in `tests/issue_edit_field.rs`
  (`test_label_plus_<flag>_rejected_with_exit_64_no_http` for each of: `priority`, `type`,
  `team`, `points`, `no-points`, `parent`, `no-parent`, `description`, `description-stdin`,
  `markdown`, `component`). Test names use snake_case substitution for kebab-case flags
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
- EC-3.4.017-15 (NEW, issue #605 F2): `jr issue edit KEY --component add:X --field components=Y`
  → Gate B fires for `components` (fifth field, added 2026-08-15) → exit 64, overlap error
  naming `components`, no HTTP. Symmetric with EC-3.4.017-4..7 for the other four fields.
  `jr issue edit KEY --component add:X --field Components=Y` (capitalized field name) also
  fires — the case-insensitive match applies uniformly.
- EC-3.4.017-16 (NEW, issue #578 F2, adversary pass-13 F-1): `jr issue edit KEY --priority
  Medium --field priority:name=Medium` → Gate B fires for `priority` — the `:name` hint
  suffix is stripped to the bare key `priority` before the overlap check runs (BC-3.4.026
  bare-key rule), so this is indistinguishable from the bare `--field priority=Medium` case
  (EC-3.4.017-7) → exit 64, overlap error naming `priority`, no HTTP. The same holds for the
  other four system fields under any hint kind: `jr issue edit KEY --type Bug --field
  issuetype:id=10001` and `jr issue edit KEY --component add:X --field components:name=Y`
  both fire Gate B identically to their bare-form counterparts. Cross-reference: BC-3.4.029
  EC-3.4.029-2 documents the PLATFORM (non-JSM) CREATE-path counterpart of this same flag
  combination — **[AMENDED 2026-08-26, D2; SCOPED 2026-08-26, F2 adversary-convergence
  round-4, MED-1/F-3]** as of ADR-0019 § Amendment (2026-08-26) D2, the PLATFORM create path now
  has its OWN guard (sharing the `field_resolve::detect_flag_field_overlap` function with this
  Gate B) that fires identically (exit 64, no HTTP), not last-wins; this EC is the EDIT-path
  resolution, and BC-3.4.029 EC-3.4.029-2 is its PLATFORM CREATE-path symmetric counterpart,
  closing what was previously a contradiction between the two BCs and is now a matched pair
  **for `priority` and every other field this EC's own examples cover, all of which are members
  of BOTH sets. [SCOPE NOTE ADDED 2026-08-26, F2 adversary-convergence round-5, F-NEW-1]** "Matched
  pair" describes MECHANISM symmetry (exit 64 vs. last-wins) for the fields shared by both guards
  — it does NOT mean the two guards' governed SETS are identical in size: the create-path guard's
  own set is NINE members (four more static keys — `labels`/`parent`/`assignee` plus resolved-id
  `--points`/`--team` — beyond this Gate B's five), per BC-3.3.010 EC-3.3.010-6a and ADR-0019 §
  "D2 correction (adversary F-NEW-1)"; this Gate B's OWN five-member set is unchanged by that
  widening. The
  JSM create path (`--request-type` set) is explicitly OUT of scope for this guard — it retains
  BC-3.8.008's pre-existing last-wins behavior; extending this guard to JSM is DEFERRED, flagged
  for the F2 human gate.

**Verification Properties**:
- VP-396-005 **[UPDATED 2026-08-15 issue #605 F2, M5 fix-burst]**: Multi-key/`--jql`-multi-
  issue rejection exits 64; flag-overlap hard error for `summary`, `description`, `issuetype`,
  `priority`, `components` exits 64 before any HTTP call. **Previous version (superseded):**
  "...for `summary`, `description`, `issuetype`, `priority`..." (four-member enumeration).
- VP-396-008: `--field` + `--dry-run` → success path exits 0; Gate A/B still fire;
  read-only HTTP executes for preview; PUT NOT issued; resolution failure still exits 64;
  dry-run succeeds when editmeta contains allowedValues entries with absent `id` on
  non-targeted fields (issue #589 SOH-BUGS-1; AllowedValue.id is Option<String>).

**Trace**: issue #396 F2; `src/cli/issue/edit.rs::handle_edit` (`REJECTED_IN_BULK`
set update; Gate B overlap check; `has_any_field_change` update to include `--field`);
`.factory/phase-f2-spec-evolution/prd-delta-396.md §3`

[NEW 2026-05-22 issue #396 F2]
[AMENDED 2026-07-09 issue #589 SOH-BUGS-1: VP-396-008 extended (dry-run succeeds when editmeta contains idless allowedValues entries on non-targeted fields)]
[AMENDED 2026-08-25 issue #578 F2: Gate B's flag-overlap matching extended to hint-tagged `--field NAME:kind=VALUE` pairs (BC-3.4.026 bare-name-key rule) — new EC-3.4.017-16; resolves contradiction with BC-3.4.029 EC-3.4.029-2, which is now scoped to the create path only (adversary pass-13 F-1)]

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
3. None of the `--label` mutual-exclusion flags are supplied alongside `--label`. The full set (verified from `src/cli/issue/edit.rs::handle_edit` lines 180-227, CLAUDE.md FIX-F5-001; **[UPDATED 2026-08-15 issue #605 F2] `--component` added — 12 → 13 flags**): `--summary`, `--priority`, `--type`, `--team`, `--points`, `--no-points`, `--parent`, `--no-parent`, `--description`, `--description-stdin`, `--markdown`, `--field`, `--component`. Combining `--label` with any of these flags causes the block to exit 64 before this contract's routing logic fires; the block fires unconditionally on `!labels.is_empty() && !conflicting.is_empty()` (NOT only on `!field_pairs.is_empty()`) regardless of key count. This gate is **distinct from BC-3.4.017 Gate B** — Gate B covers multi-key (`--jql` or 2+ positional keys) + flag-overlap for `--summary`/`--description`/`--type`/`--priority`/`--component` only; the `--label` conflict block is a separate earlier-return covering all 13 flags at any key count. Rationale for including `--component`: without this guard, `--label add:foo --component add:bar` on a single key would route through `handle_edit_bulk_labels` (Path A/B of this BC), which does not accept a `components` payload — the `--component` write would silently drop (exit 0, data loss), the exact FIX-F5-001 hazard class this conflict block exists to prevent for `--field`.
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
- VP-COMPONENT-027 **[NEW 2026-08-15, P7 fix-burst — resolves MEDIUM-3 found by adversarial
  spec-delta review pass 7]**: `jr issue edit KEY --label add:foo --component add:bar` (single
  key, or any key count) → Precondition 3's mutual-exclusion conflict block fires → exit 64,
  stderr contains `"--label cannot be combined with"` AND `"--component"` as two separate
  substring assertions (mirrors EC-3.4.017-14's co-author test pattern for the other 12 flags in
  this same conflict block); `PUT /rest/api/3/issue/{key}` is NOT called (`.expect(0)`);
  `POST /rest/api/3/bulk/issues/fields` is NOT called (`.expect(0)`) — i.e. NEITHER this BC's
  Path A nor Path B ever fires for this combination, so the `--component` write cannot silently
  drop (the exact FIX-F5-001 hazard class Precondition 3's rationale describes). This closes the
  gap where Precondition 3 documented the `--component`-inclusion rationale in prose but carried
  no dedicated Verification Property of its own — the guard was previously pinned only by the
  general 13-flag `test_label_conflict_block_lists_every_relevant_flag` meta-test's set-membership
  check (EC-3.4.017-14/BC-3.4.017), not by a behavioral `.expect(0)` HTTP-call-arity assertion at
  this BC.

**Trace**: CLAUDE.md Gotcha BUG-LABEL-400; `src/cli/issue/edit.rs::handle_edit_bulk_labels`; `src/api/jira/issues.rs::update_issue_labels`; BC-3.4.006 (complementary: `build_labels_edited_fields` pure-function shape); H-NEW-LABEL-FORK-001 (holdout unblocked by this BC); BC-3.4.017 EC-3.4.017-14 (sibling meta-test enforcing the conflict block's flag-set completeness, of which VP-COMPONENT-027 pins the `--component` member's HTTP-arity behavior specifically)

[NEW 2026-06-30 BC-subclause-pass F2]

---

#### BC-3.4.021: `jr issue edit --dry-run` emits `plannedChanges` JSON or table preview on stdout without issuing any mutation HTTP call; `--output json` schema is `{dryRun: true, issues: [...], plannedChanges: {...}}`

**[UPDATED 2026-08-15 issue #605 F2]** `plannedChanges` gains a `components` key for `--component add:/remove:` (flat array, same simplified-preview convention as `labels` — see Postconditions — `--output json` item 3, Postconditions — `--output table` item 6b, and EC-3.4.021-20). No other clause of this BC changes.

**STATUS: UPDATED (DEC-274, 2026-08-13, issue #692; scope extended by adversary pass-3 MEDIUM-1, flagged for human ratification at this same F2 gate)** — DEC-274 supersedes this BC's Invariant 3 (a REVERSAL, not a silent amend): `--dry-run` now reads stdin for `--description-stdin` and renders an ADF preview, where it previously did neither. **Pass-3 MEDIUM-1 extends the ADF-preview half of this reversal to bare `--description <str>` as well** — the live (non-dry-run) path already renders ADF for BOTH `--description` and `--description-stdin` (`edit.rs`'s `desc_text` block covers either source uniformly), so scoping the dry-run preview to stdin only left a false-OK gap: `jr issue edit KEY --description "<pathologically nested markdown>" --markdown --dry-run` returned exit 0 with a misleading success preview while the corresponding live edit would exit 64 on the depth guard. This is a small, strictly-better coverage expansion beyond the literal `--description-stdin` scope of the original #692 report — the product-owner is surfacing it for explicit human ratification at this F2 gate rather than silently broadening scope. The pre-DEC-274 text of Invariant 3, the `--description-stdin` bullets of both Postconditions blocks, and EC-3.4.021-6 is retained verbatim in the "Previous version (superseded by DEC-274)" block near the end of this BC, for audit trail. **(DEC-274 is RATIFIED AT THIS F2 GATE**, not merely proposed — the record is self-consistent as written: this reversal is a deliberate, human-approved decision superseding a prior ratified invariant, not a silent amend. STATE.md's own DEC-274 status flip from PENDING to RATIFIED is finalized by the state-manager at F2 commit, immediately following the same human gate this BC text assumes; that ordering is the correct flow and is out of scope for this BC file to perform.)

**Confidence**: HIGH
**Source**: `src/cli/issue/edit.rs::handle_edit` dry-run block (implementation-defined; no external Atlassian analogue); CLAUDE.md `--dry-run is implemented on issue edit (multi-key positional + --jql-resolved sets) with --output json support`; `src/adf.rs::markdown_to_adf` / `src/adf.rs::text_to_adf` (ADF conversion, reused verbatim from the live path)
**Subject**: Issue write (dry-run preview)

**Description**: When `--dry-run` is present, `handle_edit` emits a preview of planned changes and
exits 0 without issuing any mutation HTTP call. The output format is INTERNAL to `jr` — there is no
Jira Cloud API endpoint for this behavior. The `plannedChanges` field shapes are intentionally
SIMPLIFIED previews that do NOT match the live-edit wire payloads (e.g., labels as a flat array
instead of `labelsFields`; priority as a bare string instead of `{"priorityId":"..."}`). These
simplifications are deliberate design choices documented in source comments. As of DEC-274
(scope extended by adversary pass-3 MEDIUM-1), the ONE exception to "simplified preview, no
HTTP/IO work" is description input: dry-run now renders an ADF preview for ANY supplied
description — `--description "<text>"` or `--description-stdin` — using the identical
`markdown_to_adf`/`text_to_adf` selection the live path uses (`edit.rs`'s `if let Some(ref text)
= desc_text { ... }` block, mirrored exactly). For `--description-stdin` specifically, dry-run
additionally performs the stdin read itself (the original #692 defect: the live path's `desc_text`
resolution reads stdin via `spawn_blocking`, and dry-run now mirrors that read); for bare
`--description` the text is already available synchronously from the CLI argument, so only the
ADF-conversion half is new. Both paths converge on the same additive `plannedChanges.descriptionAdf`
key, specifically so the conversion can be validated before any write (see Postconditions — Common
item 6 and Invariant 3 below).

**Note — no `--file` flag on `issue edit`:** `jr issue edit` has no `--file` flag; description
input is only via `--description` (bare string) or `--description-stdin` (reads the piped stdin
stream). Do not assume or implement a `--file`-based dry-run path here — an earlier issue report's
proposed fix incorrectly assumed one exists (research brief `.factory/research/bucket1-692-dry-run-stdin-2026-08-13.md`
§1.4). A `--file` flag exists only on `comment edit`/`comment add`, an unrelated subcommand.

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
6. **[NEW, DEC-274; scope extended to bare `--description`, adversary pass-3 MEDIUM-1]** If a description input is supplied — `--description <str>` OR `--description-stdin` — dry-run performs the SAME ADF conversion the live path performs, regardless of which flag supplied the text. For `--description-stdin` specifically: stdin IS read inside the dry-run block, using the same `spawn_blocking` + `read_to_string` idiom the live path uses (parity — no double-read, no new blocking-on-async-reactor hazard; see research brief §2). For bare `--description`: the text is already available synchronously from the CLI argument — no read step, only the conversion step below. In BOTH cases, the resulting text is converted to ADF via `adf::markdown_to_adf` (if `--markdown` is also set) or `adf::text_to_adf` (otherwise), mirroring the live path's selection exactly (`edit.rs`'s `desc_text` block). **This read+conversion is a read-only, local (no additional HTTP call) operation** — it does not change Postconditions — Common item 1 (still no mutation HTTP call). If `markdown_to_adf` returns `Err` (e.g., the `MAX_ADF_DEPTH = 256` recursion-depth guard, BC-7.2.012, CWE-674), the process exits 64 BEFORE any `plannedChanges` output is emitted, REGARDLESS of which flag supplied the description — `--dry-run` does NOT suppress this exit-64 resolution error, consistent with item 3 above and Invariant 2 below; only mutation HTTP calls are suppressed by `--dry-run`, never resolution/validation errors. This is precisely the gap MEDIUM-1 closed: pre-fix, `jr issue edit KEY --description "<pathologically nested markdown>" --markdown --dry-run` returned exit 0 with a misleading success preview, while the corresponding LIVE edit of the same input would exit 64 on this same depth guard — the false-OK was reachable via the bare-flag path even though the original #692 fix already closed it for the stdin path. **[MANDATED ORDERING, adversary pass-6 LOW-1 — hardening pin against a partial-stdout leak]**: the stdin-read (`--description-stdin` only) + ADF-conversion step described in this item MUST run EXACTLY ONCE, and MUST complete — including the `markdown_to_adf`/`text_to_adf` call and its possible `Err` → exit 64 — BEFORE the `match output_format` block that prints either the table or JSON preview begins emitting ANY output. This is a structural requirement, not merely an outcome one: `--output table`'s preview lines are emitted INCREMENTALLY via per-field `println!` calls (Postconditions — table item 1), so if an implementer instead performed the stdin-read/ADF-conversion step INTERLEAVED with — or after the start of — that incremental `println!` sequence, a `markdown_to_adf` `Err` could fire mid-table-output and leak partial stdout before the exit-64 return, directly contradicting the "stdout EMPTY on error, in both modes" postcondition EC-3.4.021-15/VP-692-002/VP-692-004 all require. Placing the entire read+conversion step before the `match output_format` dispatch — as a single, unconditional pre-step whose `?`/early-return propagates before any table or JSON printing begins — is what makes "stdout empty on error" true BY CONSTRUCTION for the table arm, not merely true by coincidence because the JSON arm happens to build its payload before printing it.

**Postconditions — `--output json`**:
1. stdout is a single pretty-printed JSON object with exactly three top-level keys:
   ```json
   {
     "dryRun": true,
     "issues": ["FOO-1", "FOO-2"],
     "plannedChanges": { ... }
   }
   ```
   **This "exactly three top-level keys" invariant is PRESERVED under DEC-274** — the new ADF preview (item 3 below) is nested INSIDE `plannedChanges`, not added as a fourth top-level key.
2. **[UPDATED, DEC-274, reconciled adversary pass-2 HIGH-2, scope corrected adversary pass-3 MEDIUM-1]** `plannedChanges` is a JSON object containing ONLY the field keys the user explicitly requested, WITH ONE DERIVED EXCEPTION: `descriptionAdf` (item 3's description bullets below) has no CLI flag of its own — it is present IF AND ONLY IF a description input flag is supplied, `--description <str>` OR `--description-stdin` (either one — both produce `descriptionAdf` as of pass-3 MEDIUM-1), never independently and never when NEITHER description flag is present. Every other absent flag still does NOT appear in `plannedChanges`, and every other present flag still corresponds 1:1 to exactly one key. **Previous version (pass-2, scope too narrow, retained for audit trail):** "present IF AND ONLY IF `--description-stdin` is supplied … never for the bare `--description` flag" — this was accurate for pass-2's scope, but pass-3 MEDIUM-1 extended `descriptionAdf` to bare `--description` too (see Postconditions — Common item 6), so this earlier text is now too narrow. **Original pre-DEC-274 version (retained for audit trail):** "`plannedChanges` is a JSON object containing ONLY the field keys the user explicitly requested. Absent flags do NOT appear in `plannedChanges`." — true without exception before DEC-274, because no flag ever produced a second, derived key.
3. `plannedChanges` key names and value types per flag:
   - `--summary "X"` → `"summary": "X"` (bare string)
   - `--priority "High"` → `"priority": "High"` (bare string; NOT `{"priorityId":"..."}`)
   - `--type "Bug"` → `"issueType": "Bug"` (bare string; NOT id-resolved)
   - `--parent "FOO-0"` → `"parent": "FOO-0"` (bare string)
   - `--no-parent` → `"parent": null` (JSON null, NOT absent key)
   - `--points 3` → `"points": 3.0` (number)
   - `--no-points` → `"points": null` (JSON null, NOT absent key)
   - `--team "Backend"` → `"team": "Backend"` (bare string)
   - `--description "X"` **[EXTENDED, adversary pass-3 MEDIUM-1]** → `"description": "X"` (bare string; raw input — UNCHANGED, still NOT ADF, BC-3.4.013 preserved) PLUS a new, additive `"descriptionAdf"` key nested inside `plannedChanges` (sibling to `description`, NOT a replacement of it) carrying the actual rendered ADF document for `"X"` — the real `adf::markdown_to_adf`/`adf::text_to_adf` output described in Postconditions — Common item 6, byte-identical to what the live (non-dry-run) path would POST for the same input. Symmetric with the `--description-stdin` bullet immediately below; the two differ only in how the raw text is obtained (CLI argument vs. stdin read), never in the resulting `plannedChanges` shape. Pre-pass-3 this bullet had NO `descriptionAdf` at all (only the original DEC-274 reversal covered `--description-stdin`); see "Previous version" below.
   - `--description-stdin` **[REVERSED, DEC-274]** → `"description"` = the RAW stdin string, read verbatim (BC-3.4.013's raw-input invariant preserved unchanged — see cross-reference below), PLUS a new, additive `"descriptionAdf"` key nested inside `plannedChanges` (sibling to `description`, NOT a replacement of it) carrying the actual rendered ADF document — the real `adf::markdown_to_adf`/`adf::text_to_adf` output described in Postconditions — Common item 6, byte-identical to what the live (non-dry-run) path would POST for the same input. Pre-DEC-274 this bullet emitted a literal placeholder string and never read stdin; see "Previous version" below.
   - `--markdown` → `"markdown": true` (boolean)
   - `--label add:foo` → `"labels": [{"action": "ADD", "name": "foo"}]` (flat array; NOT the `labelsFields` bulk schema)
   - `--component add:X --component remove:Y` **[NEW, issue #605 F2]** → `"components": [{"action": "ADD", "name": "X"}, {"action": "REMOVE", "name": "Y"}]` (flat array, SAME shape convention as `labels` above; NOT the live single-key `update`-verb shape of BC-3.4.022 and NOT the live bulk `multiselectComponents`/`componentId` shape of BC-3.4.023 — intentionally simplified per Invariant 1).
   - `--field NAME=VALUE` (resolved, BARE form / no `:kind` hint) → `"<field display-name>": "<display value>"` merged into `plannedChanges` as string key/value pairs. The key is the HUMAN display name (e.g. `"Story Points"`), NOT the `customfield_NNNNN` wire ID. The value is the display value (e.g. `"5"` for a number field; the matched option label for a select field). Source: `src/cli/issue/field_resolve.rs::resolve_edit_fields` step 6 inserts `(human_name, display_value)` into `changed_fields`, which is the same map merged into `plannedChanges` via `dr_changed` at `edit.rs`. **[SCOPE NOTE ADDED 2026-08-26, F2 adversary-convergence round-5, F-NEW-2]** This display-value-string rule governs the BARE form ONLY. A HINTED `--field NAME:kind=VALUE` (BC-3.4.026-030) is the documented EXCEPTION: its `plannedChanges` entry is the composed WIRE OBJECT the live PUT would send, not a display-value string — see BC-3.4.027 (`:option`, incl. cascading), BC-3.4.028 (`:id`), BC-3.4.029 (`:name`), and BC-3.4.030 (`:asset`, plus its cold-cache side-effect pin) for the per-kind shapes, each specified in that hint's own BC Postconditions.
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
     components → add:X, remove:Y
     type → <value>
     parent → <value> | (clear)
     points → <value> | (clear)
     team → <value>
     description → <preview>
     markdown rendering: enabled
     description (ADF): rendered OK
     <field-name> → <value>
   ```
   **[PINNED, adversary pass-5 INFO-2]** When BOTH `--markdown` and a description input are supplied, `"  markdown rendering: enabled"` is emitted BEFORE `"  description (ADF): rendered OK"` — this fixed relative order (not the reverse) is the normative contract for F4; do not implement an arbitrary order that a later test would contradict. The `description →` preview line itself (existing, pre-DEC-274 behavior) is unaffected and always precedes both.
2. **[EXTENDED, adversary pass-3 MEDIUM-1; clarified adversary pass-5 LOW-1]** `--description "..."` longer than 60 Unicode codepoints → truncated to 60 codepoints with `"..."` suffix (at or under 60 codepoints → emitted verbatim, no suffix; see EC-3.4.021-13). Truncation uses `chars().count()` / `chars().take(60)` (codepoint-aware, not byte-slice). **Independently of whether truncation fired** (this ADF/render-OK behavior is detached from the truncation clause, not conditioned on it — the ambiguity a looser pass-3 wording could have created is what pass-5 LOW-1 closes): one additional line, `"  description (ADF): rendered OK"`, is ALWAYS emitted for bare `--description` — SHORT (untruncated) descriptions get this line exactly as LONG (truncated) ones do. This is the SAME render-OK line item 3 emits unconditionally for `--description-stdin` (symmetric mechanism: Postconditions — Common item 6's ADF conversion applies to bare `--description` too, and is never gated on description length). On a depth-guard `Err`, the process exits 64 BEFORE any of this table output is printed at all (see EC-3.4.021-15's split-by-`--output`-mode contract, which governs this path identically). Pre-pass-3 this bullet had no render-OK line at all (only the truncation rule); see "Previous version" below.
3. `--description-stdin` **[REVERSED, DEC-274]** → the stdin content that was actually read (no longer a placeholder) is echoed as `"  description → <preview>"`, applying the IDENTICAL 60-codepoint truncation rule as item 2 (same helper, same `"..."` suffix behavior) to the raw stdin string — PLUS one additional line, `"  description (ADF): rendered OK"`, confirming the ADF conversion (Postconditions — Common item 6) completed successfully. Table mode does NOT dump the raw ADF JSON document (poor UX for a human table); a validated-indicator line is emitted instead. Pre-DEC-274 this bullet emitted a fixed placeholder line and never read stdin; see "Previous version" below.
4. `--no-parent` → `"  parent → (clear)"`.
5. `--no-points` → `"  points → (clear)"`.
6. `--label add:foo --label remove:bar` → `"  labels → add:foo, remove:bar"` (comma-joined, prefix preserved).
6b. **[NEW, issue #605 F2]** `--component add:X --component remove:Y` → `"  components → add:X, remove:Y"` (comma-joined, prefix preserved — identical convention to item 6's `labels` line). **[PINNED 2026-08-15, L2 fix-burst — pass 3, aligns this preview with the live-edit echo, closing a divergence-risk gap found by adversarial spec-delta review pass 3]** "Prefix preserved" describes the explicitly-prefixed case; a BARE `--component X` (no `add:`/`remove:` prefix) is normalized to `add:X` in this table preview line — the SAME normalization BC-3.4.012's `components` bullet (live table echo) and BC-3.4.013's `"components"` row (live JSON echo) pin, and the SAME normalization EC-3.4.022-2 documents for the live wire body. `jr issue edit KEY --component X --dry-run` therefore renders `"  components → add:X"`, never `"  components → X"` — the bare input is rendered IDENTICALLY whether the invocation is `--dry-run` or a live edit.
7. All output is on stdout (output-channel profile 1 for dry-run path per source comment).

**Invariants**:
1. The `plannedChanges` field shapes are INTENTIONALLY SIMPLIFIED previews that do NOT match live-edit wire payloads:
   - `labels`: dry-run emits `[{"action":"ADD","name":"foo"}]`; live bulk POST sends `labelsFields` array with `bulkEditMultiSelectFieldOption` (see BC-3.4.006 / BC-3.4.020).
   - `priority`: dry-run emits a bare string; live POST wraps as `{"priorityId":"<id>"}`.
   - `issueType`: dry-run emits the type name; live POST uses `{"issueTypeId":"<id>"}`.
   - **`description`/`descriptionAdf` is the one deliberate EXCEPTION to "simplified, non-byte-identical preview" (DEC-274, scope extended to bare `--description` by adversary pass-3 MEDIUM-1):** `descriptionAdf` IS byte-identical to what the live path would POST, for EITHER description-input flag — the whole point of DEC-274 (and its pass-3 extension) is that this one field's preview is NOT simplified regardless of which flag supplied the text, so ADF-rejection failure modes (malformed structure, the depth guard) are catchable before a live write via either input path.
   These simplifications are intentional (source comment at `edit.rs` dry-run block). Do NOT "fix" them to match live wire shapes (except `descriptionAdf`, which already matches by design). Note: the single-key live PUT (`src/cli/issue/edit.rs::handle_edit` § the single-key PUT field-building block, `:~675`/`:~681`/`:~712` — LOW-2 fix, converted from a volatile prose line citation) uses a THIRD distinct shape — object wrappers with name/key fields (`issuetype: {"name":t}`, `priority: {"name":p}`, `parent: {"key":parent_key}`) — so dry-run bare strings differ from BOTH the bulk POST shapes AND the single-key PUT shapes.
2. `--dry-run` does NOT suppress exit-64 resolution errors. Only `PUT`/`POST` mutation is suppressed. This now explicitly includes a `markdown_to_adf` `Err` reached from a description dry-run preview (Postconditions — Common item 6) — `--description` OR `--description-stdin`, either one (DEC-274 originally made this reachable from dry-run via `--description-stdin` only; adversary pass-3 MEDIUM-1 extended it to `--description` too) — the depth guard itself (BC-7.2.012) is unmodified.
3. **[REVERSED by DEC-274, 2026-08-13, issue #692; scope extended to bare `--description` by adversary pass-3 MEDIUM-1, ratified at this same F2 gate — pre-reversal text retained in "Previous version" below]** `--dry-run` renders an ADF preview for ANY supplied description input:
   - For `--description-stdin`: `--dry-run` DOES read stdin (via the same `spawn_blocking` + `read_to_string` idiom as the live path, at the point in the dry-run block where the other single-key-only fields are assembled) and DOES render it to ADF.
   - For bare `--description <str>`: the text is already available synchronously from the CLI argument (no stdin read needed); `--dry-run` DOES render it to ADF using the identical conversion step.
   Both paths select `adf::markdown_to_adf` if `--markdown` else `adf::text_to_adf`, mirroring the live path's selection — so the conversion can be previewed and validated without any live write, via either description-input flag. The rendered ADF is emitted in a NEW, additive `plannedChanges.descriptionAdf` field (json mode) / a validated-indicator line (table mode) in BOTH cases; `plannedChanges.description` continues to carry the RAW input string verbatim in BOTH cases — **BC-3.4.013's raw-input invariant (issue #398) is UNCHANGED by this reversal**; only an additive field/line was introduced, nothing that carried raw-input semantics was replaced with an ADF round-trip. Cross-reference: BC-3.4.013 (raw-input invariant, unaffected, no body edit); BC-7.2.012 (`MAX_ADF_DEPTH` depth guard, unaffected — only newly *reachable* from this call site, now via TWO entry points instead of one). **[adversary pass-6 LOW-1]** The read+conversion step this Invariant describes MUST run once, BEFORE the `match output_format` block, in both output modes — see Postconditions — Common item 6's "MANDATED ORDERING" clause for the full hardening rationale (prevents a partial-stdout leak from the table arm's incremental `println!` structure on a depth-guard `Err`).
4. This BC owns ONLY the dry-run preview shapes built inside `handle_edit`'s dry-run block (`src/cli/issue/edit.rs` lines ~431–559). `handle_edit_bulk_labels` (line 935) and `handle_edit_bulk_fields` (line 1059) take NO `dry_run` parameter and have NO dry-run path of their own — `handle_edit` returns `Ok(())` at line 559 (the dry-run early-return) BEFORE reaching the label-routing branch (line 603) or the multi-key-routing branch (line 618). Live wire shape ownership: live bulk label shape → BC-3.4.020 Path B (verified: BC-3.4.006 is about labels via `build_labels_edited_fields`, not priority); live multi-key `--type` bulk shape → BC-3.4.018; the live bulk `--priority` shape (`{"priorityId":"<id>"}`, `src/cli/issue/edit.rs::handle_edit_bulk_fields` line 1093) has NO dedicated owning BC; the single-key PUT field shapes (`issuetype: {"name":t}`, `priority: {"name":p}`, `parent: {"key":...}` at `edit.rs` lines 675, 681, 712) have NO dedicated owning BC — all three PUT shapes are documented inline in Invariant 1 of this BC. (Note: BC-3.4.012 owns the SUCCESS ECHO/changed_fields map, not the PUT wire payload.)
5. Exit code 0 is unconditional after the dry-run block returns `Ok(())` on the success path (DEC-274 does not change this — the new exit-64 path from Invariant 2/Postconditions-Common item 6 is a distinct, earlier return, not a modification of the success return).
6. **[NEW, DEC-274]** No `--file` flag exists on `issue edit` (see the Description note above) — do not add a file-based stdin-equivalent path here; any file-input capability for description text is out of scope for this BC and would be net-new CLI surface requiring its own BC.

**Edge Cases**:
- EC-3.4.021-1: `--output json --summary "X"` → `{"dryRun":true,"issues":["FOO-1"],"plannedChanges":{"summary":"X"}}`; PUT not called.
- EC-3.4.021-2: `--output json --label add:foo --label remove:bar` → `plannedChanges.labels = [{"action":"ADD","name":"foo"},{"action":"REMOVE","name":"bar"}]` (flat array; NOT `labelsFields`).
- EC-3.4.021-3: `--output json --type "Bug"` → `plannedChanges.issueType = "Bug"` (bare string; no id-resolution HTTP call).
- EC-3.4.021-4: `--output json --no-parent` → `plannedChanges.parent = null` (JSON null, not absent key).
- EC-3.4.021-5: `--output json --no-points` → `plannedChanges.points = null` (JSON null, not absent key).
- EC-3.4.021-6: **[REVERSED, DEC-274]** `--output json --description-stdin --dry-run` (stdin piped with content `"Fixed the bug"`) → `plannedChanges.description = "Fixed the bug"` (the raw stdin string, read verbatim — BC-3.4.013's raw-input invariant preserved) AND `plannedChanges.descriptionAdf` = the `adf::text_to_adf("Fixed the bug")` output (nested inside `plannedChanges`, NOT top-level); stdin IS read (via the same `spawn_blocking` + `read_to_string` idiom as the live path); PUT not called; exit 0. Pre-DEC-274 this produced `plannedChanges.description = "<from stdin — not yet read in dry-run>"` and never read stdin; see "Previous version" below.
- EC-3.4.021-7 (**[UPDATED, adversary pass-5 LOW-1]**): `--output table --description "..."` longer than 60 codepoints → truncated with `"..."` suffix in table output; PLUS `"  description (ADF): rendered OK"` is ALSO emitted (Postconditions — table item 2 — this line is unconditional, not gated on the truncation having fired).
- EC-3.4.021-8: `FOO-1 FOO-2 --summary "X" --output json --dry-run` → `issues: ["FOO-1","FOO-2"]`; bulk POST NOT called; both keys in `issues` array.
- EC-3.4.021-9: `--field NAME=VALUE --dry-run` → editmeta GET fires; resolved key+value appear in `plannedChanges`; PUT NOT called; exit 0 (happy path). Exit 64 if field resolution fails (BC-3.4.015 EC-3.4.015-19 preserved).
- EC-3.4.021-10: Zero field flags + `--dry-run` → exit 64 before dry-run block (pre-HTTP guard fires; precondition 2 fails; this BC does not apply).
- EC-3.4.021-11: `--output table --no-parent` → stdout contains `"  parent → (clear)"` (not `"null"` or absent line).
- EC-3.4.021-12: `--output json --points 0 --dry-run` → `plannedChanges.points = 0.0` (JSON number zero, NOT `null`). This is semantically distinct from `--no-points` → `plannedChanges.points = null` (EC-3.4.021-5). The `Some(f64)` branch at `edit.rs` line 454 handles `--points 0`; the explicit-null branch at line 457 handles `--no-points`. Zero-valued numbers must not be confused with cleared fields.
- EC-3.4.021-13 (**[UPDATED, adversary pass-5 LOW-1; citation fixed adversary pass-6 INFO-1]**): `--output table --description "..."` with exactly 60 codepoints → no truncation suffix (description is emitted verbatim). With exactly 61 codepoints → the first 60 codepoints are kept and `"..."` is appended. Source: `edit.rs::handle_edit` § the table-mode description-truncation check, `:~537`, uses `char_count > 60` (strict-greater): a count of exactly 60 is NOT greater than 60, so the else branch fires (no suffix). This is a codepoint boundary, not byte-length; multi-byte UTF-8 characters count as one codepoint each (`chars().count()` / `chars().take(60)`). **In BOTH the exactly-60 (untruncated) and exactly-61 (truncated) cases, `"  description (ADF): rendered OK"` is ALSO emitted** (Postconditions — table item 2) — the render-OK line is unconditional on description length, so this codepoint-boundary EC does not affect whether it appears, only whether the `"..."` suffix appears.
- EC-3.4.021-14: `--priority High --dry-run --output json` → `plannedChanges.priority = "High"` (bare string, NOT `{"name": "High"}` or `{"priorityId": "..."}`, intentionally simplified per invariant 1). Contrast: single-key PUT body wraps priority as `{"priority":{"name":"High"}}` (Jira v3 `update` shape); bulk POST body resolves and sends `{"priorityId": "<id>"}` (name→id via `GET /rest/api/3/priority`, ADR #331). The dry-run preview emits the user-supplied name verbatim, no resolution HTTP call. Source: `src/cli/issue/edit.rs` line ~407 (`planned.insert("priority".into(), json!(p))` where `p: &String`).
- EC-3.4.021-15 (NEW, DEC-274; **[CORRECTED, adversary pass-3 HIGH-1 — reverts an incorrect pass-2 "fix"]**): `--description-stdin --markdown --dry-run` where the piped stdin content, when converted, trips `adf::markdown_to_adf`'s `MAX_ADF_DEPTH = 256` recursion-depth guard (BC-7.2.012, CWE-674) → exit 64 BEFORE any `plannedChanges` output is emitted. `--dry-run` does NOT suppress this exit-64 resolution error (Postconditions — Common item 6; Invariant 2); only mutation HTTP calls are suppressed. No PUT/POST is issued in either output mode (dry-run never issues one). **Both output modes have EMPTY stdout on this error** (channel-separation invariant #526, source-verified: `src/main.rs`'s error-exit handler uses `eprintln!` for BOTH the `OutputFormat::Json` arm and the default arm — there is no branch that ever writes an error to stdout; `tests/common/assertions.rs::assert_json_error_envelope` pins "stdout must be empty on error" as the load-bearing channel-separation assertion). This is consistent with BC-1.2.047 Postcondition 4's `--output json` error envelope in this same bundle, which ALSO goes to stderr, not stdout:
  - `--output json`: stdout is EMPTY. Stderr carries the standard `{"error": "<message>", "code": 64}` envelope (the #526 JSON render invariant), through the same central error handler as every other exit-64 error.
  - `--output table` / human mode (default): stdout is EMPTY. Stderr carries `Error: <message>`.
  **Previous version (adversary pass-2, INCORRECT, retained for audit trail — do NOT re-implement):** "`--output json`: stdout is NOT empty — it carries the standard `{"error": "<message>", "code": 64}` envelope" — this was WRONG; pass-2 misidentified which channel carries the JSON error envelope. The channel is STDERR in both modes, exactly as the original (pre-pass-2) "nothing printed to stdout" text always correctly implied for the success/failure distinction, just under-specified about WHERE the error text goes. This correction is the FIRST reversal of a same-bundle adversary-pass instruction found in this cycle; it was caught by a fresh-context pass-3 review that source-verified `src/main.rs` directly rather than trusting the pass-2 finding.
- EC-3.4.021-16 (NEW, DEC-274): `--description-stdin --markdown --dry-run --output json` with multi-line Markdown stdin content (e.g. a bullet list plus a fenced code block) → `plannedChanges.description` = the raw multi-line stdin string verbatim, INCLUDING embedded `\n` characters (this is NOT ADF — `plannedChanges.description` is a bare string, so the newline-in-text-node prohibition that applies to real ADF `text` nodes does not apply here); `plannedChanges.descriptionAdf` = the full `adf::markdown_to_adf` output (a real ADF document containing `bulletList`/`codeBlock` nodes as appropriate — not a placeholder, not a flattened string); PUT not called; exit 0.
- EC-3.4.021-17 (NEW, DEC-274, adversary pass-1 INFO-1 — empty stdin, mirrors the live-path EC-3.4.013-13; **[CLARIFIED, adversary pass-3 LOW-1]**): `jr issue edit KEY --description-stdin --dry-run < /dev/null` → `desc_text = Some("")` (identical empty-stdin handling to the live path — dry-run does not special-case an empty read; per Postconditions — Common item 6 the same `spawn_blocking` + `read_to_string` idiom is reused verbatim). `--description-stdin` is itself a field flag, so the pre-HTTP zero-flag guard (Precondition 2) does not fire regardless of stdin content. `--output json`: `plannedChanges.description = ""` (empty string, KEY PRESENT — not absent, not null) AND `plannedChanges.descriptionAdf` = `adf::text_to_adf("")` — because THIS EC's command supplies no `--markdown`, the `text_to_adf` branch of Postconditions — Common item 6's general `markdown_to_adf` if `--markdown` else `text_to_adf` rule is selected (this EC does NOT imply `text_to_adf` is used regardless of `--markdown`; the general rule is unchanged). `text_to_adf` is infallible for any input including empty strings and never consults `MAX_ADF_DEPTH`; had `--markdown` been passed alongside genuinely empty stdin, `markdown_to_adf("")` would run instead — also infallible for empty input (nothing to nest), producing an equivalent minimal `doc` node. `--output table`: the `"  description → <preview>"` line renders with an empty preview (zero-length truncation input, no `"..."` suffix — 0 codepoints is never `> 60`) followed by `"  description (ADF): rendered OK"` (Postconditions — table item 3) — the render-OK line still appears because the selected conversion function cannot fail on empty input. PUT not called; exit 0.
- EC-3.4.021-18 (NEW, adversary pass-3 MEDIUM-1 — bare `--description` happy path, mirrors EC-3.4.021-6 for the non-stdin flag): `jr issue edit KEY --description "Fixed the bug" --dry-run --output json` → `plannedChanges.description = "Fixed the bug"` (the raw CLI-argument string, unchanged from pre-pass-3 behavior) AND `plannedChanges.descriptionAdf` = the `adf::text_to_adf("Fixed the bug")` output (nested inside `plannedChanges`, NOT top-level, and NEW as of pass-3 — this key did not exist for bare `--description` before this fix round); no stdin involved at all; PUT not called; exit 0. Symmetric with EC-3.4.021-6, differing only in the description-input source (CLI argument vs. piped stdin).
- EC-3.4.021-19 (NEW, adversary pass-3 MEDIUM-1 — bare `--description` depth-guard error, the exact false-OK scenario this finding closes): `jr issue edit KEY --description "<content engineered to trip MAX_ADF_DEPTH>" --markdown --dry-run` → exit 64 BEFORE any `plannedChanges` output, via the SAME split-by-`--output`-mode contract as EC-3.4.021-15 (`--output json`: stdout empty, stderr carries the `{"error","code":64}` envelope; `--output table`: stdout empty, stderr carries `Error: ...`). No PUT/POST in either mode. This is the exact scenario MEDIUM-1 identified as a regression: before this fix, this invocation returned exit 0 with `"  description (ADF): rendered OK"` — a FALSE OK — while `jr issue edit KEY --description "<same content>" --markdown` (the live, non-dry-run edit) would exit 64 on this same `MAX_ADF_DEPTH` guard. Symmetric with EC-3.4.021-15/16, differing only in the description-input source.
- EC-3.4.021-20 (NEW, issue #605 F2): `jr issue edit FOO-1 --component add:X --component remove:Y --dry-run --output json` → `plannedChanges.components = [{"action":"ADD","name":"X"},{"action":"REMOVE","name":"Y"}]` (flat array, same convention as `labels`); NEITHER the single-key `update`-verb PUT (BC-3.4.022) NOR the bulk `POST /bulk/issues/fields` (BC-3.4.023) is called; exit 0. `--output table` equivalent: stdout contains `"  components → add:X, remove:Y"`. Component NAME resolution (BC-8.4) still fires during dry-run (it is a read-only GET, consistent with Postconditions — Common item 3's `--field` editmeta precedent) — an unresolvable/ambiguous component name still exits 64 before any `plannedChanges` output, `--dry-run` does not suppress this resolution error.

**Previous version (superseded by DEC-274, retained for audit trail — do NOT re-implement)**:

> **Invariant 3 (pre-DEC-274):** `--dry-run` does NOT read stdin for `--description-stdin` — the literal placeholder string is the correct behavior, not a bug.
>
> **Postconditions — `--output json` item 3, `--description-stdin` bullet (pre-DEC-274):** `--description-stdin` → `"description": "<from stdin — not yet read in dry-run>"` (literal placeholder; stdin NOT read)
>
> **Postconditions — `--output table` item 3 (pre-DEC-274):** `--description-stdin` → `"  description → (read from stdin — not yet read in dry-run)"`.
>
> **EC-3.4.021-6 (pre-DEC-274):** `--output json --description-stdin --dry-run` → `plannedChanges.description = "<from stdin — not yet read in dry-run>"` (literal placeholder); stdin not read.
>
> **Postconditions — `--output table` item 2 (pre-pass-3 MEDIUM-1):** `--description "..."` longer than 60 codepoints → truncated with `"..."` suffix. No render-OK line, no ADF conversion at all — bare `--description` had no `descriptionAdf`/render-OK behavior until pass-3 MEDIUM-1 extended it.

**Canonical Test Vectors**:

| Scenario | Flags | `--output` | Expected stdout fragment | PUT called? |
|----------|-------|------------|--------------------------|-------------|
| Summary dry-run JSON | `FOO-1 --summary "Fix bug" --dry-run` | json | `{"dryRun":true,"issues":["FOO-1"],"plannedChanges":{"summary":"Fix bug"}}` | No |
| Label dry-run JSON | `FOO-1 --label add:bug --dry-run` | json | `plannedChanges.labels[0] = {"action":"ADD","name":"bug"}` | No |
| Multi-key dry-run | `FOO-1 FOO-2 --summary "X" --dry-run` | json | `issues: ["FOO-1","FOO-2"]` | No |
| Table dry-run | `FOO-1 --summary "X" --dry-run` | table | stdout has "DRY RUN — no changes will be made." | No |
| null parent | `FOO-1 --no-parent --dry-run` | json | `plannedChanges.parent = null` | No |
| stdin ADF preview (DEC-274) | `FOO-1 --description-stdin --dry-run --output json` (stdin: `"Fixed it"`) | json | `plannedChanges.description = "Fixed it"`; `plannedChanges.descriptionAdf` = rendered ADF doc | No |
| stdin depth-guard error, JSON (DEC-274; adversary pass-3 HIGH-1 revert) | `FOO-1 --description-stdin --markdown --dry-run --output json` (stdin: pathologically nested Markdown) | json | stdout EMPTY; `{"error":"...","code":64}` on **stderr** | No |
| stdin depth-guard error, table (DEC-274; adversary pass-3 HIGH-1 revert) | `FOO-1 --description-stdin --markdown --dry-run` (stdin: pathologically nested Markdown) | table | stdout EMPTY; `Error: ...` on **stderr** | No |
| bare-description ADF preview (adversary pass-3 MEDIUM-1) | `FOO-1 --description "Fixed it" --dry-run --output json` | json | `plannedChanges.description = "Fixed it"`; `plannedChanges.descriptionAdf` = rendered ADF doc | No |
| bare-description depth-guard error, JSON (adversary pass-3 MEDIUM-1) | `FOO-1 --description "<nested>" --markdown --dry-run --output json` | json | stdout EMPTY; `{"error":"...","code":64}` on **stderr** | No |
| bare-description depth-guard error, table (adversary pass-3 MEDIUM-1) | `FOO-1 --description "<nested>" --markdown --dry-run` | table | stdout EMPTY; `Error: ...` on **stderr** | No |

**Verification Properties**:
- VP-DRY-RUN-001 (**[UPDATED, DEC-274, reconciled adversary pass-2 HIGH-2, scope corrected adversary pass-3 MEDIUM-1]**): `--dry-run --output json` stdout parses as valid JSON with exactly `dryRun`, `issues`, `plannedChanges` at top level; `dryRun` is `true`; `issues` is a non-empty string array; `plannedChanges` contains only explicitly-supplied-flag keys PLUS, when a description input flag (`--description` OR `--description-stdin` — either one) is among the supplied flags, the derived `descriptionAdf` key (present iff a description input is supplied — see Postconditions-json item 2); PUT mock is not hit. **Previous version (pass-2, scope too narrow, retained for audit trail):** "…when `--description-stdin` is one of the supplied flags…" — accurate for pass-2's scope, superseded by pass-3 MEDIUM-1's extension to bare `--description`. **Original pre-DEC-274 version (retained for audit trail):** "`plannedChanges` contains only explicitly-supplied-flag keys" — unqualified, true before DEC-274 introduced the one derived-key exception.
- VP-DRY-RUN-002: `--dry-run --output json --no-parent` → `plannedChanges.parent` is JSON null (not absent); PUT not called.
- VP-DRY-RUN-003: `--dry-run --output json --label add:foo` → `plannedChanges.labels[0].action == "ADD"` and `.name == "foo"` (flat-array form, NOT `labelsFields`).
- VP-692-001 (NEW, DEC-274): `--dry-run --output json --description-stdin` with piped stdin content `"Fixed it"` → `plannedChanges.description == "Fixed it"` (raw, byte-identical to stdin) AND `plannedChanges.descriptionAdf` is present, is a valid ADF `doc` node, and is byte-identical to the value `adf::text_to_adf("Fixed it")` would produce; top-level JSON keys remain exactly `{dryRun, issues, plannedChanges}`; PUT mock not hit.
- VP-692-002 (NEW, DEC-274; **[CORRECTED, adversary pass-3 HIGH-1 — reverts an incorrect pass-2 "fix"]**): `--dry-run --description-stdin --markdown` with stdin content engineered to trip `MAX_ADF_DEPTH` (BC-7.2.012 fixture) → exit code 64 in both output modes; PUT mock not hit in either; **stdout is EMPTY in BOTH modes** (channel-separation invariant #526). `--output json`: stderr parses as JSON matching the standard `{"error","code"}` envelope shape (`code == 64`); no `plannedChanges`/`dryRun`/`issues` keys present anywhere (stdout or stderr). `--output table` (default): stderr carries `Error: ...`; stdout is empty. **Previous version (adversary pass-2, INCORRECT, retained for audit trail — do NOT re-implement):** "`--output json`: stdout parses as JSON matching the standard `{"error","code"}` envelope shape" — WRONG channel; source-verified (`src/main.rs`'s error-exit handler, `tests/common/assertions.rs::assert_json_error_envelope`) that the JSON error envelope is ALWAYS on stderr, and stdout is ALWAYS empty on any exit-64 (or other non-zero) error, regardless of `--output` mode.
- VP-692-003 (NEW, adversary pass-3 MEDIUM-1): `--dry-run --output json --description "Fixed it"` (bare flag, no stdin involved) → `plannedChanges.description == "Fixed it"` (raw, unchanged from the flag value) AND `plannedChanges.descriptionAdf` is present, is a valid ADF `doc` node, and is byte-identical to the value `adf::text_to_adf("Fixed it")` would produce; top-level JSON keys remain exactly `{dryRun, issues, plannedChanges}`; PUT mock not hit. Mirrors VP-692-001 but exercises the bare `--description` path instead of `--description-stdin`.
- VP-692-004 (NEW, adversary pass-3 MEDIUM-1 — the exact false-OK regression this finding closes): `--dry-run --description "<content engineered to trip MAX_ADF_DEPTH>" --markdown` (bare flag; BC-7.2.012 fixture content, no stdin involved) → exit code 64 in both output modes; stdout EMPTY in both; stderr carries the standard error envelope (`--output json`) or `Error: ...` (`--output table`); PUT mock not hit in either mode. Before this MEDIUM-1 fix, this exact invocation returned exit 0 with a misleading success preview while the corresponding live (non-dry-run) edit of the same input would exit 64 on the depth guard — this VP is the regression pin for that false-OK gap.
- VP-COMPONENT-028 **[NEW 2026-08-15, P7 fix-burst — resolves MEDIUM-3 found by adversarial
  spec-delta review pass 7]**: `--dry-run --output json FOO-1 --component add:X --component
  remove:Y` → `plannedChanges.components == [{"action":"ADD","name":"X"},{"action":"REMOVE","name":"Y"}]`
  (flat-array form, mirroring VP-DRY-RUN-003's assertion shape for `labels` — NOT the live
  single-key `update`-verb shape of BC-3.4.022 and NOT the live bulk `multiselectComponents`/
  `componentId` shape of BC-3.4.023); `--output table` equivalent asserts stdout contains
  `"  components → add:X, remove:Y"`; NEITHER `PUT /rest/api/3/issue/{key}` NOR
  `POST /rest/api/3/bulk/issues/fields` is called (`.expect(0)` on both mocks); exit 0. Pins
  EC-3.4.021-20, which previously had no dedicated Verification Property of its own (the BC's
  pre-existing VP-DRY-RUN-001/002/003/VP-692-001..004 cover the description/label/parent/points
  previews, none of which exercise the `components` key).
- VP-578-024 **[ASSIGNED 2026-08-26, F2 adversary-convergence round-5, F-NEW-2 — VP id assigned by verifier; authoritative definition in `verification-delta-field-dx.md` § VP-578-024 (replaces the `VP-DRY-RUN-005` placeholder marker)]**: for each hint kind (`:option` non-cascading, `:option` cascading, `:id`, `:name`, `:asset`), `issue edit KEY --field cf:<kind>=<value> --dry-run --output json` produces a `plannedChanges` entry whose value is the SAME composed wire object the live PUT would send for that hint (per BC-3.4.027/028/029/030's own "Dry-run preview shape" Postconditions), NOT the bare-form display-value string — asserting the exact `{"id":...}` / `{"name":...}` / `{"value":...,"child":{"value":...}}` / `[{"workspaceId",...}]` shapes per kind; PUT NOT called in any case. A companion assertion covers BC-3.4.030's side-effect pin: `issue edit KEY --field cf:asset=<objectId> --dry-run` on a COLD `get_or_fetch_workspace_id` cache fires the real `GET /rest/servicedeskapi/assets/workspace` call and, on a 403/404/empty-workspace response, exits 64 from BC-3.4.030's cold-cache taxonomy BEFORE any `plannedChanges` output — mirroring VP-692-002/004's exit-64-before-preview shape, extended to this workspace-discovery trigger (cross-ref EC-3.4.015-19).

**Trace**: `src/cli/issue/edit.rs::handle_edit` dry-run block (implementation-defined; no external Atlassian API spec); CLAUDE.md `--dry-run is implemented on issue edit`; BC-3.4.015 EC-3.4.015-19 (preserved); BC-3.4.020 (label wire asymmetry); BC-7.3.010 (JSON render invariant); H-NEW-DRY-RUN-001 (holdout unblocked by this BC); **DEC-274 (2026-08-13, issue #692) — supersedes Invariant 3, RATIFIED at this F2 gate (see "Previous version" above)**; BC-3.4.013 (cross-reference, unaffected — raw-input invariant, issue #398); BC-7.2.012 (cross-reference, unaffected — `MAX_ADF_DEPTH` depth guard, newly reachable from this call site only); research brief `.factory/research/bucket1-692-dry-run-stdin-2026-08-13.md`; F2 adversary pass-1 fix round (2026-08-13): EC-3.4.021-17 added (INFO-1, empty-stdin edge case mirroring EC-3.4.013-13); STATUS note extended with explicit DEC-274-ratified-at-this-gate parenthetical (MEDIUM-1); F2 adversary pass-2 fix round (2026-08-13): EC-3.4.021-15 + the depth-guard Canonical Test Vector row + VP-692-002 all split by `--output` mode to reconcile with the #526 JSON-error-envelope invariant and BC-1.2.047 Postcondition 4 (HIGH-1); Postconditions-json item 2 + VP-DRY-RUN-001 amended to carve out `descriptionAdf` as a derived key present iff `--description-stdin` is supplied (HIGH-2, both marked UPDATED with prior text retained); Invariant 1's volatile `edit.rs lines 675, 681, 712` prose citation converted to symbol-form + `:~NN` (LOW-2); F2 adversary pass-3 fix round (2026-08-13, fresh context): pass-2's HIGH-1 fix REVERTED as itself incorrect — source-verified (`src/main.rs`'s error-exit handler; `tests/common/assertions.rs::assert_json_error_envelope`) that the `--output json` error envelope is on STDERR, not stdout, in every output mode; EC-3.4.021-15, the depth-guard test-vector rows, and VP-692-002 all corrected back (pass-3 HIGH-1); ADF-preview scope EXTENDED from `--description-stdin`-only to ANY description input (`--description` too), closing a false-OK regression where `--description "<nested>" --markdown --dry-run` returned exit 0 while the live edit would exit 64 — touches Description, Postconditions-Common item 6, Postconditions-json items 2/3, Postconditions-table item 2, Invariants 2/3, and adds EC-3.4.021-18/-19 + VP-692-003/-004 (pass-3 MEDIUM-1, flagged for explicit human ratification at this F2 gate per the STATUS note); EC-3.4.021-17's `--markdown`-gating parenthetical scoped to "this EC's command supplies no `--markdown`" rather than implying `text_to_adf` is used regardless of the flag (pass-3 LOW-1); F2 adversary pass-5 fix round (2026-08-13): Postconditions-table item 2 reworded to detach the `"description (ADF): rendered OK"` line from the truncation clause — it is unconditional on description length, not only emitted when truncation fires — and EC-3.4.021-7/-13 updated to state this explicitly (LOW-1); the example stdout fence and Postconditions-table item 1 gained a pinned ordering note — when both `--markdown` and a description input are supplied, `"markdown rendering: enabled"` precedes `"description (ADF): rendered OK"` (INFO-2); F2 adversary pass-6 fix round (2026-08-13): Postconditions-Common item 6 and Invariant 3 gained a MANDATED-ORDERING hardening pin — the stdin-read + ADF-conversion step (and its possible `Err` → exit 64) MUST complete before the `match output_format` block begins printing ANY output, structurally guaranteeing "stdout empty on error" holds for the table arm's incremental `println!` structure too, not merely by coincidence in the JSON arm (LOW-1); EC-3.4.021-13's bare `edit.rs line 537` prose citation converted to symbol-form + `:~537` (INFO-1)

[NEW 2026-06-30 BC-subclause-pass F2] [UPDATED 2026-08-13 DEC-274 issue #692]

---

#### BC-3.4.022: `issue edit KEY --component add:X --component remove:Y` (single-key) interprets prefix, sends native Jira `update`-verb wire shape

**Confidence**: HIGH
**Source**: DEC-280; `.factory/research/component-delete-and-bulk-wire-2026-08-15.md` §Cross-cutting ("single-issue component `update` verbs quirk"); BC-3.4.006 (direct label structural twin); `src/cli/issue/edit.rs` (pending F4)
**Subject**: Issue write — `--component` (issue #605)
**Description**: `--component add:X`/`--component remove:Y` (repeatable, same `add:`/`remove:`
prefix grammar as `--label`) on a SINGLE-key `issue edit` invocation (or a `--jql` query
matching exactly one issue) sends the native Jira v3 `update`-verb PUT body — structurally
identical in SHAPE to BC-3.4.006's label contract, but with `{"add":{"name":"X"}}`/
`{"remove":{"name":"Y"}}` OBJECT operations (component operations always take an object with
`name` or `id`, never a bare string — this is the asymmetry class already known from labels'
bare-string vs. components' object form).
**Preconditions**:
1. `jr issue edit <key> --component <spec>...` invoked, `keys.len() == 1` (after `--jql`
   resolution, mirroring BC-3.4.020 Invariant 2's "keys.len() == 1 determined AFTER --jql
   resolution" rule).
2. At least one `--component` value supplied.
3. None of the `--label` mutual-exclusion flags are supplied alongside `--component` in a
   way that would trip BC-3.4.020's conflict block (that block does not include `--component`
   as a TARGET flag being combined with `--label` — see BC-3.4.020 Precondition 3's updated
   13-flag list, which is about `--label` conflicting with `--component`, not the reverse).
**Postconditions**:
1. `PUT /rest/api/3/issue/{key}` body: `{"update":{"components":[{"add":{"name":"X"}}, {"remove":{"name":"Y"}}]}}` — `add:` prefix entries produce `{"add":{"name":"..."}}`; `remove:`
   prefix entries produce `{"remove":{"name":"..."}}`; bare entries (no prefix) produce
   `{"add":{"name":"..."}}` (mirrors BC-3.4.006's bare-label-is-ADD convention).
2. When BOTH add and remove entries are present, ADD elements precede REMOVE elements in the
   `components` array (mirrors BC-3.4.006 Invariant 4).
3. Component NAMES are resolved/validated via §8.4 (`resolve_component`, scoped to the
   issue's own project — extracted from the KEY via the last-hyphen split, BC-3.4.018
   Invariant 4) BEFORE the PUT fires. **Editmeta-gated fallback**: `jr` first checks
   `GET /rest/api/3/issue/{key}/editmeta` for `fields.components.operations` containing
   `"add"`/`"remove"` (mirroring BC-3.4.015's editmeta-gated `--field` pattern); if the
   operations ARE present, the native `update`-verb shape above is used directly. If a given
   Jira instance's editmeta does NOT list `add`/`remove` for `components` (an atypical
   instance configuration), `jr` falls back to a read-modify-write: `GET` the issue's current
   `fields.components`, compute the new full array client-side, and `PUT` it via the `set`
   verb (`{"fields":{"components":[...]}}`) instead — this fallback exists because community
   reports (research file, Cross-cutting section) note the `add`/`remove` verbs have
   historically been flakier than `set` on some instances; `jr` prefers the cheaper
   `update`-verb path and only pays the extra `GET` cost when editmeta signals it is needed.
4. Returns HTTP 204 → exit 0. `changed_fields`/table echo gains a `components` entry (see
   BC-3.4.012/013 UPDATE notes below).
**Invariants**:
1. This is the single-key path ONLY. 2+ keys (or `--jql` matching 2+) route to BC-3.4.023.
2. The editmeta-gated fallback (Postcondition 3) is evaluated ONCE per invocation and does
   not retry — if the `update`-verb PUT itself 400s despite editmeta advertising the
   operations, that is an ordinary 400 surfaced via the standard error-taxonomy chain, NOT a
   trigger for the read-modify-write fallback (no automatic retry-with-different-shape).
**Edge Cases**:
- EC-3.4.022-1: `--component add:Backend` only → `components: [{"add":{"name":"Backend"}}]`
  (no `remove` element).
- EC-3.4.022-2: `--component Backend` (bare, no prefix) → treated as ADD, identical shape to
  EC-3.4.022-1.
- EC-3.4.022-3: Unknown component name → exit 64 via §8.4 (BC-8.4.002), zero PUT calls (the
  editmeta/list-components GET used for resolution is the only HTTP that fires).
- EC-3.4.022-4 **[CLARIFIED 2026-08-19, feature-level F5, F-CS-1]**: `--component` values are
  not required to be names — an all-ASCII-digit `--component add:<digits>`/`remove:<digits>`
  value (or a bare all-digit value, treated as ADD per Postcondition 1) is a component ID under
  §8.4's numeric bypass (BC-8.1.008/BC-8.4.001) and is passed through to the wire body
  UNCHANGED, with no name-list GET fired for resolution. On this single-key path the numeric id
  wires as `{"id":"<n>"}` inside the `add`/`remove` object — `{"add":{"id":"<n>"}}` /
  `{"remove":{"id":"<n>"}}` — NEVER `{"add":{"name":"<n>"}}` / `{"remove":{"name":"<n>"}}`. This
  mirrors BC-3.4.023's existing numeric-bypass wording for the bulk path (integer `componentId`,
  never a name/id-string object) — the object-key differs (`id` vs. `name`) because the two
  branches of Postcondition 1's `add`/`remove` object accept either key, and a numeric-bypass
  value is unambiguously an id, not a name.
**Verification Properties**:
- VP-COMPONENT-011: Single-key `--component` invocation calls `PUT /rest/api/3/issue/{key}`
  exactly once with the native `update`-verb object-form body; the bulk endpoint
  (`POST /bulk/issues/fields`) is never hit (`.expect(0)`).
- VP-COMPONENT-016: Postcondition 3's add/remove don't-clobber + editmeta-gated fallback:
  single-key `--component add:X --component remove:Y` preserves every OTHER component already
  on the issue (the `update`-verb body touches only X/Y); when editmeta advertises
  `components.operations` containing `add`/`remove`, the native `update`-verb PUT is used
  directly; when editmeta does NOT, `jr` falls back to GET-current → compute → `set`-verb PUT
  (`{"fields":{"components":[…]}}`). The editmeta gate is evaluated at most once (no
  retry-with-different-shape on a subsequent 400).
**Trace**: DEC-280; BC-3.4.006 (label structural twin); BC-3.4.015 (editmeta-gated pattern
precedent); research file Cross-cutting section (add/remove flakiness note, fallback
rationale)

[NEW 2026-08-15 issue #605 F2]

---

#### BC-3.4.023: `issue edit KEY1 KEY2 --component add:X` (multi-key/`--jql` bulk path) — `POST /bulk/issues/fields` with `multiselectComponents`/integer `componentId`

**Confidence**: HIGH
**Source**: DEC-280; `.factory/research/component-delete-and-bulk-wire-2026-08-15.md` §Q2
(CONFIRMED per Atlassian docs, triple-corroborated: doc example + swagger OpenAPI + apidog
mirror); `src/cli/issue/edit.rs::handle_edit_bulk_fields` (pending F4)
**Subject**: Issue write — `--component` (issue #605)
**Description**: Multi-key (or `--jql` matching 2+ issues) `--component` edits route through
the bulk-fields endpoint, mirroring BC-3.4.018's (`--type`) and BC-3.4.020 Path B's
(`--label`) bulk-routing shape at the CLI-surface level, but with a THIRD distinct wire shape:
components requires an INTEGER `componentId`, not a name/id string object — this is a
stronger asymmetry than either the label or issue-type bulk cases (research §Q2.3: "more
pronounced than the labels/issuetype cases").

> **Delivery note (not a spec conditional):** per DEC-280/research §Q2.4, this wire shape is
> well-documented (triple-corroborated) but has NOT yet been confirmed against a live Jira
> run at spec-authoring time. Implementation (F4) MUST gate shipping this path behind a live
> smoke test (one ADD, one REMOVE, against ≥2 issues in one project — the two operations `jr`
> actually emits per Postcondition 3 below; `REPLACE`/`REMOVE_ALL` are wire-schema-completeness
> enum values the endpoint accepts but `jr` has no `set:`/`replace:`/`clear:` CLI grammar to
> generate them with, so they are intentionally OUT of scope for this smoke test — do NOT add
> such a grammar to close this gap, that is `#607` territory) before release, per the
> `FIX-BULK-TRANSITION-001`/#446 precedent. **[SCOPED 2026-08-15, pass-10 fix-burst — resolves
> MEDIUM-1 found by adversarial spec-delta review pass 10; previous version, superseded,
> retained for audit trail: "one ADD, one REMOVE, one REPLACE against ≥2 issues in one
> project" — mandated a REPLACE call `jr` never issues in production, an unsatisfiable
> acceptance criterion]** If the live smoke test contradicts the shape documented below, this
> BC must be corrected to the observed true shape (exactly as `FIX-BULK-TRANSITION-001` did
> for bulk transitions) — this note does NOT relax the BC's normative content below, which is
> what F4 implements against until/unless a live-run correction is required. **[PRECONDITION
> ADDED 2026-08-19, S-605-2 wire-shape research —
> `.factory/research/S-605-2-bulk-component-wire-2026-08-19.md`, "What the story may have
> MISSED" item 4]** The target project for this live smoke test MUST have at least one
> component already defined. Jira's `GET /rest/api/3/bulk/issues/fields` field-discovery
> response only includes `components` in the bulk-edit allowlist when the selected issues'
> project actually has components configured — a componentless project surfaces `components`
> with an `unavailableMessage` instead, so the field would never be selectable and the smoke
> test would false-negative for a reason unrelated to wire-shape correctness. This is a
> precondition of the smoke test itself, not a new BC behavior.

**Preconditions**:
1. 2+ positional keys are supplied, OR `--jql` resolves to 2+ issues, all in the SAME
   project (cross-project guard — see EC below, mirroring BC-3.4.019's `--type` guard).
2. At least one `--component` value supplied.
**Postconditions**:
1. `selectedActions` contains `"components"` (lowercase field id).
2. `editedFieldsInput.multiselectComponents` is a SINGLE OBJECT (not an array, NOT
   `componentsFields`):
   ```json
   {
     "selectedActions": ["components"],
     "editedFieldsInput": {
       "multiselectComponents": {
         "fieldId": "components",
         "components": [{"componentId": 10001}, {"componentId": 10002}],
         "bulkEditMultiSelectFieldOption": "ADD"
       }
     }
   }
   ```
   **[CLARIFIED 2026-08-19, S-605-2 wire-shape research —
   `.factory/research/S-605-2-bulk-component-wire-2026-08-19.md`]** The body above
   deliberately OMITS a top-level `sendBulkNotification` key. The upstream Atlassian doc's
   own worked example for this endpoint shows `"sendBulkNotification": false` alongside the
   body — but the live-proven helper this story reuses, `bulk_edit_fields`
   (`src/api/jira/bulk.rs`), builds its `BulkEditRequest` with only
   `selectedIssueIdsOrKeys`, `selectedActions`, and `editedFieldsInput`, and already omits
   `sendBulkNotification` entirely — an omission already live-validated via the issue #446
   bulk labels/type path. `sendBulkNotification` is a documented OPTIONAL field, so this
   omission is spec-conformant, not an oversight. Implementers MUST NOT add
   `sendBulkNotification` to the components body merely to mirror the Atlassian doc example
   — the live-proven `bulk_edit_fields` composition, not the doc example, is the source of
   truth for this BC's wire body.
3. **[CORRECTED 2026-08-15, pass-14 fix-burst — resolves a self-contradictory postcondition
   found by adversarial spec-delta review pass 14]** `bulkEditMultiSelectFieldOption` is one
   of `ADD` | `REMOVE` | `REPLACE` | `REMOVE_ALL`. When BOTH `add:` and `remove:` specs are
   present in one invocation, `jr` mirrors BC-3.4.006/BC-3.4.020's ADD-then-REMOVE ORDERING
   convention (the ADD action is resolved and sent before the REMOVE action) — but explicitly
   NOT their single-POST coalescing: the endpoint's documented shape allows only one
   `multiselectComponents` object per request (unlike labels' `labelsFields`
   array-of-elements shape), so `jr` performs TWO sequential bulk POSTs when both add: and
   remove: specs are present in one invocation (ADD POST first, REMOVE POST second) — this is
   a DELIBERATE divergence from the label bulk path's single-POST coalescing, forced by the
   `multiselectComponents` schema being a single object rather than an array of elements.
   **Previous version (superseded, retained for audit trail):** "`jr` issues TWO coalesced
   entries in a single POST — mirroring BC-3.4.006/BC-3.4.020's ADD-then-REMOVE coalescing
   convention — by sending `multiselectComponents` as the FIRST resolved action" — this
   opening clause was self-contradictory with the very next sentence, which correctly concludes
   with TWO SEQUENTIAL POSTS. The single-POST "coalescing" framing is valid only for the
   label bulk path (`labelsFields`'s array-of-elements shape can hold both an ADD element and
   a REMOVE element in one POST); `multiselectComponents`'s single-object schema forbids
   carrying both ADD and REMOVE in one POST, which is exactly why this BC exists to specify
   the divergent two-POST behavior. Only the ORDERING (ADD before REMOVE) is mirrored from
   BC-3.4.006/BC-3.4.020 — the single-POST coalescing itself is not.
4. Component NAMES are resolved to NUMERIC `componentId`s client-side via §8.4 BEFORE the
   POST is built — the bulk endpoint rejects name/id-string objects (research §Q2.2/§Q2.3).
5. The async bulk task is polled via the EXISTING `await_bulk_task`/poll-loop machinery
   (`JR_BULK_AWAIT_TIMEOUT_SECS`, unknown-status grace) — no new polling mechanism.
6. **[NEW 2026-08-15, M9 fix-burst]** `POST /rest/api/3/bulk/issues/fields` caps a single
   request at 1000 issues and 200 total field-edit entries (Atlassian Bulk Operations limits).
   The 200-field cap is a non-issue for this BC — a `--component` bulk edit contributes
   exactly ONE `multiselectComponents` entry to `editedFieldsInput` per POST (Postcondition
   2), far below 200, regardless of how many component ids are inside that one entry's
   `components` array. The 1000-ISSUE cap is the one that matters: when the resolved key set
   (positional keys or `--jql` match) exceeds 1000 issues, `jr` splits `selectedIssueIdsOrKeys`
   into sequential chunks of ≤1000, issuing one bulk POST per chunk, each fully polled to
   completion (Postcondition 5) BEFORE the next chunk's POST is issued — chunk order follows
   the resolved key-set order (positional order, or `--jql` result order). This is the SAME
   sequential-chunking mechanism Postcondition 3 already establishes for the add:+remove:
   two-POST case; when BOTH >1000 issues AND mixed add:/remove: specs occur together, `jr`
   chunks first, then within EACH chunk issues the ADD-then-REMOVE POST pair (chunk-major,
   action-minor ordering) — so N>1000 issues with mixed add:/remove: produces
   `2 * ceil(N/1000)` sequential POSTs total.
**Invariants**:
1. `selectedActions: ["components"]` (lowercase) and `editedFieldsInput.multiselectComponents`
   (camelCase, DIFFERENT WORD — not `"components"`) intentionally differ, same asymmetry
   class already documented in CLAUDE.md for `labelsFields`/`"labels"` and
   `issueType`/`"issuetype"`. Do NOT "fix" them to match.
2. `components[].componentId` is always a JSON INTEGER, never a string, never `{"name":...}`.
   **[NEW 2026-08-15, L3 fix-burst — specifies a conversion left implicit, found by
   adversarial spec-delta review pass 2]** The §8.4 resolver (`resolve_component`,
   BC-8.4.001) — the SAME resolver Postcondition 4 above cites — returns component ids typed
   as `String` **[CORRECTED 2026-08-15, M2 fix-burst — pass 3, fixes a mis-anchored citation
   found by adversarial spec-delta review pass 3]** (the full component RESOURCE type's
   required, non-`Option` `id: String` field — `src/types/jira/component.rs::Component`, used
   by the `jr component` command group and read by `resolve_component` itself, per BC-2.3.040
   Precondition 1). **Previous version (superseded, retained for audit trail):** "the
   `Component.id: Option<String>` shape established by BC-2.3.040" — this cited the WRONG
   `Component` type: BC-2.3.040 is explicit (its own Precondition 1) that the `Option<String>`
   relaxation applies ONLY to the separate, EMBEDDED `Component` struct used for an `Issue`'s
   `fields.components[]` array (`src/types/jira/issue.rs::Component`) — a type
   `resolve_component` never reads. `resolve_component` reads the full resource type's
   candidate list (`GET /rest/api/3/project/{key}/components`, BC-8.1.001), whose `id` field
   BC-2.3.040 Precondition 1 itself states "remains required, non-optional `String` ... because
   §8.4's resolver depends on a real id." The BEHAVIORAL claim this Invariant makes — the
   resolver returns a `String`, requiring an explicit parse step to reach a JSON integer — was
   and remains correct; only the citation identifying WHICH `Component.id` shape backs that
   `String` was wrong, and is corrected here to the full resource type's required `id`, matching
   the codebase-wide convention that every `jr` resource id is a `String` regardless of
   Jira's own wire representation. Building this BC's `componentId` JSON integer therefore
   requires an explicit `String` → `u64`/`i64` PARSE step, performed client-side immediately
   after resolution and BEFORE the POST body is assembled: `id.parse::<u64>()`. Every
   resolved id this codebase produces for a component is itself derived from a Jira-returned
   numeric id serialized as a string (`Component`/component-resource `id` fields are always
   digit strings on the wire — Jira never returns a non-numeric component id) — so this parse
   is expected to succeed on every resolver-returned id in practice. If it were ever to fail
   (a resolver-returned id that is not parseable as an integer, which would itself indicate a
   deserialization or resolver defect elsewhere), `jr` treats this identically to any other
   internal-invariant violation this codebase already has no dedicated user-facing taxonomy
   entry for: it surfaces as an unexpected internal error (not a `JrError::UserError`
   exit-64 — the input was never user-supplied at this point, it is the resolver's own
   output) rather than silently truncating or coercing the value. This parse step is entirely
   separate from, and unrelated to, BC-8.2.007's snapshot JQL clause (`component =
   <resolvedId>`), which composes the SAME resolved id as an unquoted numeric literal directly
   into a JQL string — that call site needs no typed integer, only the same guarantee that the
   resolved id is digit-only text, which the resolver's contract already provides.
   **[CLARIFIED 2026-08-19, S-605-2 Step-4.5 adversarial finding — error taxonomy]** The
   internal-error framing two sentences above applies ONLY to a genuine resolver-returned id —
   i.e. an id reached via BC-8.4.001 step (2), the non-digit `partial_match` name→id lookup —
   that unexpectedly fails to parse; this is not expected to be reachable with a real resolver
   and remains an internal-invariant violation (`JrError::Internal`, not `JrError::UserError`).
   It does NOT apply to BC-8.4.001 step (1), the all-ASCII-digit numeric-bypass path: an
   `--component add:<digits>`/`remove:<digits>` value that is entirely ASCII digits is passed
   through by the resolver UNCHANGED, with NO existence check and NO name-list GET fired
   (BC-8.4.001 Behavior step (1); VP-COMPONENT-014). A numeric-bypass value is therefore
   user-supplied text, not resolver output — an oversized digit string that fails
   `id.parse::<u64>()` (e.g. a 26-digit value exceeding `u64::MAX`) is a genuine user-input
   error, not an internal one: `jr` surfaces it as `JrError::UserError`, exit 64, with ZERO
   POSTs issued (the parse happens client-side before any bulk-fields POST is built, per
   Postcondition 4). Summary of the two parse-failure origins this Invariant now
   distinguishes: (a) numeric-bypass user input failing `u64` parse → `JrError::UserError`
   (exit 64, zero HTTP calls); (b) a resolver-returned name→id lookup result failing to parse
   → `JrError::Internal` (unexpected internal error; not expected reachable with a real
   resolver, per the paragraph above).
3. This bulk path is entirely SEPARATE from BC-3.4.022's single-key `update`-verb path — the
   two are never mixed within one invocation (routing is purely on `keys.len()`, identical
   fork mechanics to BC-3.4.020).
**Edge Cases**:
- EC-3.4.023-1: Keys span 2+ projects with `--component` → exit 64 BEFORE any HTTP
  (cross-project guard, mirrors BC-3.4.019 exactly — component ids are project-scoped, so a
  single `componentId` cannot correctly apply across projects).
- EC-3.4.023-2: `--component add:X --component remove:Y` on 2+ keys → two sequential POSTs
  (ADD then REMOVE), each independently polled to completion before the next begins.
- EC-3.4.023-3: `--jql` matching exactly 1 issue → single-key path (BC-3.4.022), NOT this BC
  (mirrors BC-3.4.020 Invariant 2).
- EC-3.4.023-4 **[NEW 2026-08-15, M9 fix-burst]** **[REWORDED 2026-08-15, L5 fix-burst — pass
  3, repairs a garbled sentence and specifies partial-chunk-success reporting, closing a gap
  found by adversarial spec-delta review pass 3]**: `--jql` resolves 1500 issues in one
  project, `--component add:Backend` → `jr` issues TWO sequential bulk POSTs, the first with
  1000 issues' worth of `selectedIssueIdsOrKeys`, the second with the remaining 500, each
  polled to completion before the next starts (Postcondition 6). Exit 0 iff BOTH chunks
  succeed. Unlike rename `--all-projects` (BC-8.3.003), which continues attempting every
  remaining target after a per-target failure and reports a structured per-target
  `renamed[]`/`failed[]` outcome array, this chunked bulk-fields path does NOT continue past a
  failing chunk: the chunk sequence is aborted at the FIRST chunk failure and no further chunks
  are attempted (chunk 3 of a 3-chunk sequence is never POSTed if chunk 2 fails) — a bulk-fields
  chunk failure is surfaced as an ordinary bulk-task failure via the existing `await_bulk_task`
  error path (the same error shape ANY single bulk POST failure already produces), NOT the
  rename `--all-projects` per-target report shape. **Non-transactional reality across chunks
  (explicitly surfaced, not merely implied):** a chunk that already completed successfully
  BEFORE the failing chunk is NOT rolled back — those issues' components are genuinely changed
  on the Jira side and stay changed. However, `jr`'s `--output json`/table error output for
  this failure does NOT itemize which chunk(s) succeeded or which issue keys they covered; it
  surfaces only the failing chunk's `await_bulk_task` error. A caller who needs to know
  precisely which issues were already updated before an aborted chunk sequence must
  independently re-query those issues (e.g. `jr issue list --jql "<original query> AND
  component = Backend"`) — there is no dedicated reconstruction record for this path (contrast
  BC-8.2.007/BC-8.2.008's snapshot-based `affectedIssues` record for `component delete`, which
  this bulk-fields path does not have and is not required to have, since it is not a delete).
**Verification Properties**:
- VP-COMPONENT-012: Multi-key `--component` invocation issues zero single-key `PUT
  /rest/api/3/issue/{key}` calls (`.expect(0)`); the bulk POST body's `components[].componentId`
  values are JSON integers (not strings, not objects). A resolved key set exceeding 1000
  issues is split into `ceil(N/1000)` sequential POSTs PER ACTION (Postcondition 6,
  EC-3.4.023-4) — `ceil(N/1000)` for a single-action invocation (only `add:` or only
  `remove:` specs), `2 * ceil(N/1000)` when BOTH `add:` and `remove:` specs are present in one
  invocation (Postcondition 6's chunk-major, action-minor ordering), each fully polled before
  the next begins.
**Trace**: DEC-280; research §Q2 (full verdict); BC-3.4.018 (bulk `--type` structural
precedent); BC-3.4.019 (cross-project guard precedent); BC-3.4.020 Path B (bulk `--label`
structural precedent — coalescing DIVERGES per Postcondition 3 above)

[NEW 2026-08-15 issue #605 F2]

---

#### BC-3.4.024: `issue create --component X --component Y` (bare, no add:/remove: prefix) sets the initial components array on POST

**Confidence**: HIGH
**Source**: DEC-280 (create-path is additive body composition, not update-verb); BC-3.3.001
(`issue create` body composition pattern); `src/cli/issue/create.rs` (pending F4)
**Subject**: Issue write — `--component` (issue #605)
**Behavior**: `issue create` has no existing issue state to diff against, so `--component`
(repeatable) on `create` carries NO `add:`/`remove:` prefix grammar — every value is simply
included in the initial `components` array on the `POST /rest/api/3/issue` body:
`"components": [{"name":"X"},{"name":"Y"}]` (object-with-name form, matching the single-key
`update`-verb object convention of BC-3.4.022, NOT the bulk integer-id form of BC-3.4.023 —
`create` is never a bulk operation). Component names are resolved/validated via §8.4 (scoped
to the target project, resolved the same way `--project`/other create-time fields resolve)
BEFORE the POST fires — an unknown name aborts pre-flight, consistent with every other
`issue create` validation.
**Preconditions**:
1. `jr issue create --project KEY ... --component NAME...` (repeatable) invoked on the
   PLATFORM create path (NOT the JSM `--request-type` dispatch fork).
2. **[UPDATED 2026-08-15, M11 fix-burst — resolves a previously-unspecified combination]**
   `--component` is NOT combined with `--request-type` in the same invocation. **Previous
   version (superseded, retained for audit trail):** Precondition 1 said only "`--component`
   on the JSM path is out of scope for this cycle, same posture as other platform-only create
   flags" — this described SCOPE but never specified the actual runtime behavior when both
   flags ARE supplied together (silent-ignore? exit 64? forwarded anyway?), leaving the
   combination genuinely undefined. Resolved here per the DEC-188 precedent (S-639-1,
   `--field`/`--on-behalf-of` without `--request-type` → exit 64 pre-flight, NOT silent
   warn-and-proceed): `--component` + `--request-type` together exits 64 pre-flight, BEFORE
   project-key resolution, interactive prompts, or any HTTP call — mirroring DEC-188's
   ordering exactly (`handle_create` checks this immediately after the JSM dispatch-fork
   check, before any of the other pre-flight work). Rationale for exit-64 over `--type`'s
   existing silent-ignore precedent (BC-3.8.010): a JSM request has no `fields.components`
   array in the same shape a platform issue does — silently dropping `--component` would be a
   silent data-loss footgun (the user believes components were set; they were not), the same
   class of hazard DEC-188 was introduced to close for `--field`/`--on-behalf-of`, and unlike
   `--type` (whose JSM behavior is a documented, deliberate simplification — request type IS
   the type on the JSM path), there is no analogous "component is implied by request type"
   substitute here.
**Postconditions**:
1. `POST /rest/api/3/issue` body's `fields.components` array contains one `{"name": "<X>"}`
   object per supplied `--component` value, in CLI input order.
2. An `add:`/`remove:` prefix on a `create --component` value is NOT special-cased — if a
   user types `--component add:X` on `create`, the LITERAL string `"add:X"` is sent as the
   component name (which will 400 as an unknown component, surfacing the ordinary
   unknown-name error) — `create` never interprets these prefixes, unlike `edit`.
3. **[NEW 2026-08-15, M11 fix-burst]** `--component ... --request-type X` → exit 64, stderr
   naming both flags (e.g. `"--component is set but --request-type routes to the JSM
   request-creation path, which does not support --component. Drop --component, or create the
   issue on the platform path (without --request-type) and add components via a follow-up
   \`jr issue edit --component\`."`); zero HTTP calls (no service-desk lookup, no RT-id
   resolution, no component resolution).
**Edge Cases**:
- EC-3.4.024-1: `jr issue create --project FOO --component Backend --component Frontend` →
  `fields.components = [{"name":"Backend"},{"name":"Frontend"}]`.
- EC-3.4.024-2: `jr issue create --project FOO --component add:Backend` → resolver attempts to
  match a component literally named `"add:Backend"` → unknown-name exit 64 (§8.4) — the
  prefix grammar is `edit`-only; this is intentional, not a bug.
- EC-3.4.024-3 **[NEW 2026-08-15, M11 fix-burst]**: `jr issue create --request-type "IT
  Request" --component Backend` → exit 64 per Postcondition 3, BEFORE service-desk/RT
  resolution — the guard fires at the same pre-flight point DEC-188's `--field`/
  `--on-behalf-of` checks fire, immediately after the `request_type.is_some()` dispatch-fork
  check and before any of the JSM path's own HTTP calls.
- EC-3.4.024-4 **[CLARIFIED 2026-08-19, feature-level F5, F-CS-1]**: `--component` values on
  `create` are not required to be names — an all-ASCII-digit `--component` value (bare, no
  `add:`/`remove:` prefix — `create` never interprets those prefixes per Postcondition 2) is a
  component ID under §8.4's numeric bypass (BC-8.1.008/BC-8.4.001) and is passed through
  UNCHANGED, with no name-list GET fired for resolution. On the create path a numeric value
  wires as an `{"id":"<n>"}` array element in `fields.components` — e.g. `jr issue create
  --project FOO --component 10042` → `fields.components = [{"id":"10042"}]` — NEVER
  `{"name":"10042"}`. This mirrors BC-3.4.023's existing numeric-bypass wording for the bulk
  path (integer `componentId`, never a name/id-string object); unlike the bulk path's parsed
  JSON integer, this single-issue POST body carries the id as a string, matching
  BC-3.4.022's `{"id":"<n>"}` object form on the sibling single-key edit path.
**Verification Properties**:
- VP-COMPONENT-025: `issue create --component X --component Y` composes
  `fields.components = [{"name":"X"},{"name":"Y"}]` on the `POST /rest/api/3/issue` body
  (object-with-name form, CLI input order, no `add:`/`remove:` interpretation) and resolves
  each name via the SAME resolver contract as BC-3.4.025 (one round-trip via the project
  component-list GET, zero mutating HTTP on an unknown/ambiguous name). Also covers the
  `--component` + `--request-type` combination guard (Postcondition 3): exit 64 pre-flight,
  zero HTTP calls of any kind (no service-desk lookup, no RT-id resolution, no component
  resolution).
**Trace**: DEC-280; BC-3.3.001; §8.4 resolver contracts; DEC-188/S-639-1 (exit-64 pre-flight
guard precedent for platform-only create flags combined with `--request-type`); BC-3.8.010
(contrast — `--type`'s existing silent-ignore precedent on the JSM path, deliberately NOT
followed here per the rationale in Precondition 2)

[NEW 2026-08-15 issue #605 F2]

---

#### BC-3.4.025: `--component` name resolution — unknown/ambiguous name exits 64 pre-flight; one round-trip via the project component-list GET (not editmeta) on `issue list`/`create`, editmeta-gated on `issue edit` per BC-3.4.022

**Confidence**: HIGH
**Source**: §8.4 resolver contracts; DEC-280; `src/cli/issue/helpers.rs::resolve_component`
(pending F4)
**Subject**: Issue write — `--component` (issue #605)
**Behavior**: This BC pins the SINGLE resolution mechanism decision the F1 delta analysis
flagged as open (§2, BA note "choose one, must not duplicate both"): `issue create`'s
`--component` resolution uses `GET /rest/api/3/project/{key}/components` (BC-8.1.001's
endpoint, warm-cacheable via the Wave-1 components cache family) — NOT editmeta — because
`create`'s editmeta call (`GET /issue/createmeta/{proj}/issuetypes/{type}`) is already a
separate, differently-shaped call that does not cleanly extend to a per-project component
list. `issue edit --component`'s resolution ALSO uses the project component-list GET for
NAME→existence validation (§8.4), while the wire-shape decision (native `update`-verb vs.
read-modify-write fallback, BC-3.4.022 Postcondition 3) separately consults editmeta — these
are two DIFFERENT questions (does this name exist? vs. does this Jira instance support the
add/remove verb shape?) answered by two different calls, not a duplicated resolution of the
same question. Unknown/ambiguous component name on ANY of `create`/`edit`/bulk-edit → exit 64
via §8.4 (BC-8.4.002/003), zero mutating HTTP calls, BEFORE the create POST / edit PUT / bulk
POST fires.
**Invariants**:
1. Component-name resolution NEVER duplicates the same HTTP call twice within one invocation
   — the project component-list GET (for name validation) and the editmeta GET (for
   `edit`'s wire-shape decision, BC-3.4.022 Postcondition 3 only) are answering different
   questions and are each called at most once.
**Verification Properties**:
- VP-COMPONENT-025: The resolution-mechanism decision this BC pins (project component-list
  GET for name validation on `create`/`list`; editmeta consulted separately, and only, for
  `edit`'s wire-shape decision) is verified together with BC-3.4.024's create-path body
  composition — one property, two homes. `.expect(1)` on the project component-list GET per
  invocation (never duplicated with the editmeta GET); `.expect(0)` on the create POST for an
  unknown/ambiguous name.
**Trace**: F1 delta analysis §2 (BA-flagged open decision, resolved here); §8.4; BC-3.4.022
Postcondition 3 (editmeta's distinct purpose)

[NEW 2026-08-15 issue #605 F2]

---

#### BC-3.4.026: `--field NAME:kind=VALUE` hint-syntax parser — `parse_field_kv` gains kind-tag parsing shared across all three `--field` call sites

**Confidence**: HIGH
**Source**: issue #578 F2 spec evolution (item 1); `.factory/research/field-dx-feasibility-2026-08-25.md` (claim 3/9); `src/cli/issue/create.rs::parse_field_kv` (extended)
**Subject**: Issue write — `--field` value-kind hint syntax (issue #578 item 1)

**Description**: `--field` gains an OPT-IN hint-syntax extension: `--field NAME:kind=VALUE`, where `kind ∈ {option, id, name, asset}`. The hint declares the wire shape explicitly, bypassing `resolve_edit_fields`'s fuzzy-match heuristics for the hinted value. The bare form (`--field NAME=VALUE`, no `:kind` suffix) is UNCHANGED and PERMANENT — see Invariant 1 (resolves the BA/research open question on bare-vs-hinted precedence: auto-detect-from-schema-type is not deprecated, ever).

**Parser contract** (`parse_field_kv`, `src/cli/issue/create.rs`, shared by `create.rs`'s platform path, `edit.rs`, and `jsm_create.rs`):

**Parse rule, stated plainly (ADR-0019: split-on-delimiter, no character-escaping mechanism exists for `:`/`=`/`>` anywhere in this parser):** the first `=` splits `NAME[:kind]` from `VALUE`; the last `:` found before that `=`-delimited head splits `NAME` from `kind`; and (a separate, call-site-level rule — see BC-3.4.027 §3) the first `>` inside a `:option` VALUE splits a cascading parent from its child. None of these three splits involves escaping a delimiter character within a token — a caller who needs a literal `:`/`>` inside a value uses the `:id=` bypass (BC-3.4.028) instead, which sends the raw id verbatim and never parses the value for delimiters at all.

1. Split each `--field` argument on the first `=` (existing behavior, unchanged — this splits `NAME[:kind]` from `VALUE`).
2. Within the `NAME[:kind]` portion, split on the last `:` that appears before the `=`. Rationale for LAST (not first): a field's human NAME may legitimately contain a colon in some Jira configurations (e.g., a custom field literally named `"Region: EMEA"`); a real kind tag is always the SHORT, RIGHTMOST segment immediately before `=`, so splitting on the last colon lets a caller with a multi-colon field name still reach it by name in the common case. **Correction (does NOT help the single-colon case):** when a field NAME contains exactly one colon, "last colon" and "first colon" are the same split point — the segment after it is parsed as a candidate kind tag, and if that segment isn't one of `{option, id, name, asset}` the pair fails validation (step 3) rather than falling back to the bare form. A field NAME containing exactly one colon is therefore only reliably addressable via `customfield_NNNNN` (bypassing the human NAME, and the ambiguity, entirely).
3. If a `:`-delimited segment is found: validate it against the CLOSED set `{option, id, name, asset}` (case-sensitive, lowercase only — mirrors the `customfield_` bypass's case-sensitivity precedent, BC-3.4.015 EC-3.4.015-17). Unknown kind → exit 64 (see BC-3.4.031 EC-1). Known kind → the pair carries `Some(kind)`.
4. If no `:`-delimited segment is found before `=`: the pair carries `kind: None` (bare form — routes to today's BC-3.4.015/016 auto-detect dispatch, UNCHANGED).
5. **Multibyte-safety requirement (MUST, F6-LRE-1 class bug)**: all splitting in steps 1-2 MUST operate on Unicode scalar boundaries (`char_indices`/`.find(char)` on `&str`, NEVER raw byte-index slicing) — the same class of bug fixed in `jql::validate_duration` (FIX-F6-LRE-1, #734, multibyte input panicking on a byte-index slice). A field NAME or VALUE containing multibyte UTF-8 (e.g., a CJK custom field name) MUST NOT panic the parser; malformed multibyte boundaries in the hint-tag position are surfaced as a normal exit-64 parse error, never a panic. See VP-578-005.

**Return-type change**: `parse_field_kv` return type changes from `HashMap<String, String>` to `HashMap<String, FieldValueSpec>`, where:
```rust
struct FieldValueSpec {
    kind: Option<FieldValueKind>,   // None = bare form
    value: String,
}
enum FieldValueKind { Option, Id, Name, Asset }
```
`HashMap` (not `Vec`) is RETAINED — BC-3.4.015's existing rationale for `HashMap` over an ordered `Vec` (last-wins-on-duplicate-key semantics, structural fit with the downstream consumers) applies unchanged; only the value type grows a `kind` tag. Last-wins-on-duplicate-`NAME` semantics are UNCHANGED: `--field cf:id=1 --field cf:option=2` (same NAME, different kind) → the second occurrence's `(kind, value)` pair wins entirely — kinds are not merged or compared across duplicate NAME occurrences.

**Rule (ADR-0019 §2(b), normative — not merely illustrated by the example above):** the map key is ALWAYS the bare field name — the portion of `NAME[:kind]` before a `:kind` suffix, if present — NEVER a composite `"name:kind"` key. This holds regardless of whether the kind tag is present, absent, or varies across repeated occurrences of the same NAME: `--field cf:option=A --field cf:id=B` produces exactly ONE map entry keyed `"cf"`, and the second occurrence's whole `FieldValueSpec` (kind AND value) overwrites the first. A composite-key implementation (keying by `"cf:option"` and `"cf:id"` as two distinct map entries) would let both entries reach wire serialization and silently double-apply the field with conflicting kinds — this is the exact defect ADR-0019's bare-key refinement exists to prevent, not an acceptable alternative implementation. See VP-578-006.

**Preconditions**:
- `--field` is present at least once with the `NAME:kind=VALUE` OR `NAME=VALUE` shape.

**Postconditions**:
- Well-formed hinted pairs produce `FieldValueSpec { kind: Some(_), value }`.
- Well-formed bare pairs produce `FieldValueSpec { kind: None, value }`.
- All three call sites (`create.rs` platform path per BC-3.3.010, `edit.rs` per BC-3.4.027-030, `jsm_create.rs` per BC-3.8.008 amendment) consume the SAME `HashMap<String, FieldValueSpec>` shape — no per-call-site parsing divergence.

**Invariants**:
1. **Bare form is permanent, not deprecated — PLATFORM PATH ONLY (scope corrected 2026-08-26, A-LOW-1).** `--field NAME=VALUE` with no `:kind` suffix on an `option`-schema field continues to auto-detect via BC-3.4.016's existing label/id fuzzy-match dispatch, forever — on the platform (`issue edit`/`issue create`, `fields`-wire) path. Hints are additive/opt-in on that path; they do not narrow or deprecate the unhinted path there. **This invariant does NOT extend to the JSM path unqualified**: per BC-3.8.008's amendment, bare `kind: None` on `issue create --request-type` is an UNCONDITIONAL string-wrap (`{"cf": "V"}`) — NOT BC-3.4.016's auto-detect dispatch — pinned byte-for-byte by VP-578-015. A reader applying this invariant's "auto-detect, forever" framing to the JSM path would contradict BC-3.8.008's amendment and risk a VP-578-015 regression; see BC-3.4.027's "Platform-vs-JSM asymmetry" paragraph for the full contrast. (Resolves BA open question §5.2, platform-path scope.)
2. The `:` split point is the LAST colon before the first `=` in the argument — never the first colon. This is a plain split-on-delimiter rule, not a colon-escaping mechanism (none exists); it reduces (but does not eliminate) misinterpreting a multi-colon field NAME as carrying a kind tag, and does not help a single-colon field NAME at all (see the parser-contract correction under step 2 above) — such a name must be addressed via `customfield_NNNNN`.
3. Kind validation is case-sensitive lowercase-only (`option`/`id`/`name`/`asset`) — `:Option=` or `:OPTION=` are NOT recognized as the `option` kind; they fall through to the unknown-kind exit-64 path (BC-3.4.031 EC-1), not silently treated as bare NAME text containing a colon. This is a deliberate strictness choice (typos should fail loud, not silently misroute).
4. No byte-index slicing on the hint-tag split — Unicode-scalar-safe throughout (see parser contract step 5).

**Edge Cases**: see BC-3.4.031 (malformed-hint edge case catalog, companion to this BC).

**Verification Properties**:
- VP-578-005: `prop_field_hint_split_no_panic` — property test asserting the hint-tag splitter never panics on arbitrary Unicode input (multibyte field names/values), mirroring `FIX-F6-LRE-1`'s regression-test shape. Added to `.cargo/mutants.toml` `examine_globs` per the F1 delta analysis §3 recommendation.
- VP-578-006: Last-wins-on-duplicate-NAME semantics hold across kind boundaries (`--field cf:id=1 --field cf:option=High` → only the `option` pair survives, matching the LAST occurrence).

**Trace**: issue #578 (item 1); `.factory/research/field-dx-feasibility-2026-08-25.md` open question 3; `src/cli/issue/create.rs::parse_field_kv`; CLAUDE.md FIX-F6-LRE-1 precedent (`jql::validate_duration` multibyte panic class)

[NEW 2026-08-25 issue #578 F2]

---

#### BC-3.4.027: `--field NAME:option=VALUE` hint — explicit opt-in to today's label/id auto-detect dispatch; composes cascading parent>child values

**Confidence**: HIGH
**Source**: issue #578 F2 spec evolution (item 1, AC line 1); BC-3.4.016 (shares wire logic)
**Subject**: Issue write — `:option` hint semantics

**Description**: `--field NAME:option=VALUE` is semantically IDENTICAL to today's bare `--field NAME=VALUE` dispatch on an `option`-schema field (BC-3.4.016) — it is the explicit, opt-in spelling of the SAME resolution path (human display-value → `allowedValues[].id` lookup, id-bypass, ambiguity/empty errors all unchanged). The hint exists so a caller can be unambiguous about intent (particularly useful in scripts) without changing observable behavior versus the bare form.

**Platform-vs-JSM asymmetry (load-bearing, do not conflate):** the byte-identical claim above (VP-578-007) holds on the **platform `issue create`/`issue edit` path only** (wire target `fields`). On the JSM create path (`--request-type` set), BC-3.8.008's amendment gives bare `kind: None` a DIFFERENT wire shape (unconditional string-wrap, `{"cf": "V"}`) than `:option` (`{"cf": {"value": "V"}}`) — so `:option` is **not** byte-identical to bare on JSM. **Confidence note (adversary pass-8 M-2 correction):** the ASYMMETRY conclusion itself (bare ≠ `:option` on JSM) is confirmed — the two shapes are structurally different regardless of live verification. But the exact `{"cf": {"value": "V"}}` non-cascading shape shown here is **(JSM wire shape UNVERIFIED — see BC-3.8.008 amendment CAVEAT)**: only the platform-path `fields` wire contract was CONFIRMed by research; the `requestFieldValues` shape is asserted by analogy, not verification. This mirrors this repo's existing discipline of documenting load-bearing asymmetries explicitly (see e.g. the bulk-transition wire-schema and `issue edit --label` endpoint-fork entries in `CLAUDE.md`) rather than letting the platform-path claim be silently read as universal.

**Cascading-select composition [CONFIRMED — ADR-0019 §3, Accepted 2026-08-25]**: for a `schema.type == "option-with-child"` (cascading select) field, the `VALUE` MAY contain a single `>` separating parent and child display values: `--field 'cf:option=Parent>Child'`. Resolution: split on the FIRST `>` (a plain split-on-delimiter rule — there is no character-escaping mechanism for `>` in this parser); resolve the parent segment against the field's top-level `allowedValues[].value` (same label/id logic as BC-3.4.016 Step 2); resolve the child segment against the matched parent entry's `children[].value`. A value with a second `>` (e.g. `Parent>Child>trailing`) treats everything after the first delimiter as the verbatim child value — there is no third cascading level to represent (Jira's cascading-select wire model has exactly two levels). Wire shape: `{"value":"<parent>","child":{"value":"<child>"}}` (per `.factory/research/field-dx-feasibility-2026-08-25.md` claim 6, CONFIRM on the wire shape itself). A bare `VALUE` with no `>` against a cascading field resolves the parent only (Jira accepts a parent-only cascading value; the child is simply unset). This is the FIRST implementation of cascading-select support anywhere in `jr` — no prior BC covers it. **Delimiter choice and escape hatch are CONFIRMED, not provisional:** ADR-0019 §3 ratifies `>` (rejecting `::`/`->`/`/`/`,`/a fifth hint kind/a repeated-flag pattern — see the ADR's Alternatives Considered) and documents the escape hatch for a legitimate `>` in a display value: `:id=` (BC-3.4.028) bypasses `allowedValues` lookup and cascading parsing entirely, sending `{"id":"<VALUE>"}` verbatim — a caller who has discovered the option's numeric id (e.g. via `jr field options`) is never blocked by a colliding `>` in display text.

**Multibyte-safety MUST on the `>` split (ADR-0019 § Amendment (2026-08-26) D3, closes the FIX-F6-LRE-1 class at this new split site):** the `>` split above is performed at the CALL SITE — `field_resolve.rs` (edit path) and the analogous point in `create.rs`'s platform-create path (BC-3.3.010) — never inside `parse_field_kv` itself (BC-3.4.026's own Unicode-scalar-safety MUST, step 5, is scoped to `parse_field_kv`'s steps 1-2 only and does NOT cover this site). Every such call site **MUST use `str::split_once('>')`** (or, equivalently, `str::find('>')` followed by slicing exactly at the returned byte index) — **NEVER** locate the delimiter via a char-iterator index (e.g. `value.chars().position(|c| c == '>')`) and then use that index as a byte offset for slicing (`&value[..idx]`), and never any other fixed-byte-offset scheme. A naive char-count-as-byte-index implementation panics whenever a multibyte Unicode scalar precedes the `>` in the parent segment (e.g. `--field 'cf:option=Pré>Bñ'`) — the same char/byte-index-conflation bug class FIX-F6-LRE-1 (#734, `jql::validate_duration`) fixed, via a different specific mechanism (there, a fixed `len() - 1` byte offset from the string's end; here, a char-count used as a byte index). `str::split_once` is specifically mandated (not merely "must be Unicode-scalar-safe") because it is the one standard-library call that both locates the delimiter and returns two guaranteed-valid `&str` slices, eliminating the entire bug class by construction rather than by an added runtime check. This obligation does NOT apply to `parse_field_kv` (already covered by its own MUST) and does NOT apply to JSM (`:option` cascading is not extended to the JSM path this cycle, per BC-3.8.008's amendment — there is no JSM call site performing this split). A no-panic property test over arbitrary UTF-8 input is required for each call site above (one per call site), mirroring `validate_duration`'s FIX-F6-LRE-1 proptest and the existing `parse_field_kv_proptests`/VP-578-005 precedent — extending or sibling to VP-578-008 (flagged for the verifier to realize, not authored here).

**Non-cascading-field collision — a `>` split against a PLAIN `option` field [ADDED 2026-08-26, ADR-0019 § Amendment D4, propagated by product-owner F2 adversary-convergence round-4, F-2/D4]:** the `>` split above is UNCONDITIONAL (confirms D3) — the call site never inspects `schema.type` before splitting, so `--field cf:option=A>B` against a PLAIN (non-cascading) `schema.type == "option"` field also produces a parent candidate `"A"` and a non-empty child candidate `"B"`. Parent segment `"A"` may legitimately resolve against that field's own `allowedValues[].value` — but a non-cascading entry has no children to resolve `"B"` against. This is detected STRUCTURALLY, not via a `schema.type` lookup: at the SAME point EC-3.4.027-3's existing "unresolvable child" check already inspects the matched parent's `children` collection, a new branch checks whether that collection is EMPTY. The parser/composer stays schema-agnostic by construction — it never needs to know `schema.type` at all. **Type-level prerequisite:** resolving a cascading child at all requires the write-path `AllowedValue` type (`src/types/jira/editmeta.rs::AllowedValue`, currently `{id, value, name}` only) to gain a `children` field, pinned as `#[serde(default)] pub children: Vec<AllowedValue>` — `Vec`, NOT `Option<Vec<AllowedValue>>` (deliberately different from `FieldOption.id`/`.label`'s `Option<String>` choice, BC-X.14.001 F-B: there, wire-absence is a meaningful distinct state from wire-present-but-empty; here, Jira omitting the `children` key entirely vs. sending `"children": []` carry the identical semantic — "no cascading children" — so an empty `Vec` via `#[serde(default)]` loses no information). See EC-3.4.027-7 below for the exact trigger condition and pinned message substrings.

**Preconditions**: Same as BC-3.4.016 (single-key path, `editmeta`/`createmeta`-resolved field has `schema.type == "option"` or `"option-with-child"`).

**Postconditions**: Identical wire/echo postconditions to BC-3.4.016 for the non-cascading case. For cascading: wire payload `{"customfield_NNNNN": {"value":"<parent>","child":{"value":"<child>"}}}`; `changed_fields` echo shows `"<parent> > <child>"` (both matched labels, `>`-joined, stored casing).

**Dry-run preview shape [ADDED 2026-08-26, F2 adversary-convergence round-5, F-NEW-2]:** Under `issue edit --dry-run` (`--dry-run` exists on `issue edit` only, per BC-3.4.021 — this hint is unaffected on the platform CREATE path, which has no `--dry-run` flag), `plannedChanges`'s per-field entry for this `:option`-hinted `--field` shows the SAME composed wire shape the live PUT would send, NOT the display-value string BC-3.4.021's general bare-form rule uses (see BC-3.4.021 Postconditions — json item 3's scope note): non-cascading resolves to `{"id": "<optionId>"}` (identical to BC-3.4.016's live wire shape); cascading resolves to `{"value":"<parent>","child":{"value":"<child>"}}` (this BC's own cascading wire shape above). A resolution failure under `--dry-run` (unresolvable parent/child, non-cascading-field collision per EC-3.4.027-7) still exits 64 before any `plannedChanges` output — `--dry-run` does not suppress this class of error (BC-3.4.021 Invariant 2 / EC-3.4.015-19 precedent, transplanted to this hint).

**Invariants**: Inherits BC-3.4.016 Invariants 1-4 unchanged for the non-cascading case.
5. **[ADDED 2026-08-26, D3]** The cascading `>` split at each call site (`field_resolve.rs`, `create.rs` platform-create path) MUST use `str::split_once('>')` — never a char-index-based or fixed-byte-offset scheme. See the "Multibyte-safety MUST on the `>` split" paragraph above.
6. **[ADDED 2026-08-26, ADR-0019 § Amendment D4]** A non-empty child segment resolved against a matched parent whose `children` collection is EMPTY is a DISTINCT error from EC-3.4.027-3's "resolvable parent, unresolvable child" case — it is detected via the structural `children`-empty check (not a `schema.type` lookup), never conflated with, or silently degraded into, an unresolvable-child list that would show zero candidates. See EC-3.4.027-7.

**Edge Cases**:
- EC-3.4.027-1: `:option` hint on a non-`option`/non-`option-with-child` schema-type field → exit 64, same "unsupported type" shape as EC-3.4.015-5 (the hint declares intent but the field's actual schema type still governs feasibility).
- EC-3.4.027-2: Cascading `VALUE` with unresolvable parent segment → exit 64 listing allowed parent values (same shape as EC-3.4.016-2).
- EC-3.4.027-3: Cascading `VALUE` with resolvable parent but unresolvable child segment → exit 64 listing that parent's allowed child values.
- EC-3.4.027-4: Cascading `VALUE` containing a literal `>` inside a legitimate single (non-cascading) option label → misparsed as a parent/child split under the `:option` hint. NOT unfixable: the caller addresses this via the `:id=` form (BC-3.4.028) — once the option's numeric id is known (e.g. via `jr field options`), `--field cf:id=<id>` bypasses `allowedValues` lookup and `>`-splitting entirely, sending the id verbatim. This is the ADR-0019 §3 documented escape hatch, not a workaround invented ad hoc.
- EC-3.4.027-5 **[ADDED 2026-08-26, D3]**: Cascading `VALUE` containing a multibyte Unicode scalar (e.g. CJK, accented Latin) preceding the `>` in the parent segment, e.g. `--field 'cf:option=Pré>Bñ'` → resolves normally (parent `"Pré"`, child `"Bñ"`), NEVER panics — the `str::split_once('>')` MUST above is precisely what prevents the FIX-F6-LRE-1-class byte/char-index-conflation panic on this input shape.
- EC-3.4.027-6 **[ADDED 2026-08-26, D3]**: Cascading `VALUE` with an empty child segment (`Parent>`, e.g. `--field 'cf:option=Parent>'`) or an empty parent segment (`>Child`, e.g. `--field 'cf:option=>Child'`) → exit 64, unresolvable — an empty segment can never match a real `allowedValues[].value`/`children[].value` entry, so both cases fall through to the SAME unresolvable-parent (empty-parent case) or unresolvable-child (empty-child case) exit-64 shape as EC-3.4.027-2/3 respectively, consistent with EC-3.4.027-3's existing precedent rather than introducing a distinct empty-segment error message.
- EC-3.4.027-7 **[ADDED 2026-08-26, ADR-0019 § Amendment D4, propagated by product-owner F2 adversary-convergence round-4, F-2/D4 — sibling to EC-3.4.027-2/3, NOT a widening of either]**: `--field cf:option=A>B` where `A` resolves successfully against a PLAIN (non-cascading, `schema.type == "option"`) field's `allowedValues[].value`, `B` is non-empty (per EC-3.4.027-6's existing empty-segment handling), AND the matched parent's `children` collection is EMPTY → exit 64 with a message DISTINCT from EC-3.4.027-3's "list allowed child values" shape (which would otherwise degenerate into a confusing empty enumeration — there ARE no "allowed child values" to list, because the field isn't cascading at all). Exact message shape (load-bearing substrings, per this project's pinned-substring convention): `field '<NAME>' is not a cascading select — remove the '>Child' segment from the value.` — load-bearing substrings `"is not a cascading select"` and `"remove the"`; `<NAME>` is the same resolved field name/label used in this call site's other error messages (consistent with EC-3.4.016-2/3/8's `<NAME>`-in-message convention). Detected via the `children`-empty structural check (Invariant 6 above), never a `schema.type` inspection.

**Verification Properties**:
- VP-578-007: `:option` hint produces byte-identical wire output to the bare form for the same NAME/VALUE on a non-cascading option field ON THE PLATFORM (`fields`) PATH (JSM `:option` differs from bare per the platform-vs-JSM asymmetry above).
- VP-578-008: Cascading parent>child composition produces the `{"value":...,"child":{"value":...}}` wire shape. Delimiter CONFIRMED — split on the FIRST literal `>` only, with `:id=` as the documented escape hatch for a display value containing a literal `>` (ADR-0019 §3, Accepted 2026-08-25). No longer PROVISIONAL. **[EXTENDED 2026-08-26, D3]**: a sibling no-panic property test over arbitrary UTF-8 input, one per call site (`field_resolve.rs` edit path; `create.rs` platform-create path), asserts the `>` split never panics — mirroring `validate_duration`'s FIX-F6-LRE-1 proptest and VP-578-005's `parse_field_kv` splitter coverage (flagged for the verifier to realize). **[EXTENDED 2026-08-26, ADR-0019 § Amendment D4, F2 adversary-convergence round-4]**: a new/extended VP (sibling to this one, flagged for the verifier) must assert EC-3.4.027-7's exact message substrings (`"is not a cascading select"`, `"remove the"`) on a plain non-cascading `option` field whose `VALUE` contains a `>` where the parent segment resolves successfully — not authored here, flagged for realization.
- VP-578-023: `--field cf:option=A>B` against a PLAIN non-cascading `option` field where the parent segment resolves but the matched entry's `children` collection is EMPTY → exit 64 with pinned substrings `"is not a cascading select"` and `"remove the"` (EC-3.4.027-7). Sibling assertion: the bare form `--field cf=Parent>Child` treats `>` as literal text (no hint-driven split) and falls through to EC-3.4.016-2's unresolvable-value exit-64 shape, not EC-3.4.027-7's message (ADR-0019 § Amendment D4). Depends on the `AllowedValue.children: Vec<AllowedValue>` (`#[serde(default)]`) type extension.

**Trace**: issue #578 item 1; BC-3.4.016 (shared resolution logic); BC-3.4.026 (parser); `.factory/research/field-dx-feasibility-2026-08-25.md` claim 6; ADR-0019 § Amendment D4 (non-cascading-field collision; `AllowedValue.children: Vec<AllowedValue>` `#[serde(default)]` type extension); `src/types/jira/editmeta.rs::AllowedValue` (type extended by D4)

[NEW 2026-08-25 issue #578 F2]

---

#### BC-3.4.028: `--field NAME:id=VALUE` hint — bypasses `allowedValues` lookup entirely, sends `{"id":"<VALUE>"}` as-is

**Confidence**: HIGH
**Source**: issue #578 F2 spec evolution (item 1, AC line 2)
**Subject**: Issue write — `:id` hint semantics

**Description**: `--field NAME:id=VALUE` sends `VALUE` verbatim as `{"id": "<VALUE>"}` on the wire — NO `allowedValues` lookup, NO label matching, NO ambiguity detection. This is the explicit-opt-in spelling of the id-bypass path BC-3.4.016 Step 1 already performs implicitly when `VALUE` happens to be numeric; the `:id` hint makes the bypass EXPLICIT and unconditional (works even for non-numeric-looking id strings, though Jira Cloud option ids are numeric strings in practice).

Field-existence and Edit-screen/Create-screen gating (BC-3.4.015 Step 3 / BC-3.3.010 Step 3) still apply — the `:id` hint bypasses ONLY the `allowedValues` display-value lookup, not the field-presence/screen-membership check.

**Preconditions**: Same field-resolution preconditions as BC-3.4.015 (field name/customfield_NNNNN resolves, field is on the Edit/Create screen).

**Postconditions**:
- Wire payload: `{"customfield_NNNNN": {"id": "<VALUE>"}}`, verbatim, no transformation.
- `changed_fields` echo: `VALUE` (the raw id literal) — no reverse label lookup, same convention as BC-3.4.016 EC-3.4.016-4 (id-bypass echo).
- No `GET .../editmeta` or `GET .../createmeta` `allowedValues` array is inspected for this field's value resolution (the field-presence check per BC-3.4.015 Step 3 still fires and DOES read the metadata response, but not the `allowedValues` sub-array).
- **Dry-run preview shape [ADDED 2026-08-26, F2 adversary-convergence round-5, F-NEW-2]:** Under `issue edit --dry-run` (BC-3.4.021 — edit-path only), `plannedChanges`'s entry for this `:id`-hinted `--field` shows the SAME `{"id": "<VALUE>"}` wire object the live PUT would send, NOT the display-value string BC-3.4.021's general bare-form rule uses (see BC-3.4.021 Postconditions — json item 3's scope note) — no lookup, no reverse-resolution, verbatim, mirroring the live wire payload above exactly.

**Invariants**:
1. `:id` performs ZERO string matching against `allowedValues[].value` — the server is the sole validator of whether `VALUE` is a real option id (an invalid id 400s server-side, surfaced as a standard `JrError`).
2. `:id` works on ANY field schema type that accepts an `{"id": ...}` wire shape, not only `option` — e.g., some system fields (priority, in certain configurations). `jr` does not schema-gate `:id` beyond the existing field-presence check.

**Edge Cases**:
- EC-3.4.028-1: `:id` hint with a non-numeric `VALUE` (e.g., `--field cf:id=abc`) → `jr` does NOT client-side validate numeric shape; the value is sent as-is; server-side 400 surfaces as a standard `JrError` (not a `jr`-side exit-64 pre-validation). This is a deliberate non-goal — replicating Jira's id-format rules client-side would drift from server behavior.
- EC-3.4.028-2: `:id` hint on a field absent from `allowedValues` metadata entirely (e.g., a plain string field) → field-presence check still passes if the field is on the Edit/Create screen; the PUT/POST is attempted with `{"id": VALUE}`; server 400s if the field doesn't accept that shape. `jr` surfaces the server error verbatim.
- EC-3.4.028-3 **[ADDED 2026-08-26, F2 adversary-convergence round-3, F-A]**: `:id` hint with an EMPTY `VALUE` (e.g. `--field cf:id=`) → `parse_field_kv` performs NO client-side empty-value check for this kind (VP-578-005's "empty value allowed at the parser" contract is unqualified — it applies to `:id` exactly as it does to the bare form); the pair is sent through verbatim as `{"id": ""}`. This is NOT a `jr`-side exit-64 — it is the direct, consistent consequence of Invariant 1's "`:id` performs ZERO string matching... the server is the sole validator" posture: an empty id is just another value the client does not interpret. The server 400s on the empty id and `jr` surfaces that error verbatim, the same as any other malformed `VALUE` under EC-3.4.028-1. **Distinguish from `:asset`'s empty-value case (BC-3.4.031 EC-2a):** `:asset`'s empty value IS a `jr`-side exit-64, but for a STRUCTURAL reason — the composer cannot build the `[{workspaceId,id,objectId}]` array with no `objectId` at all, a shape-composition failure, not a value-matching one. `:id`/`:name` never compose a structured shape from `VALUE` (they wrap it verbatim in `{"id": ...}`/`{"name": ...}`), so no analogous composition failure exists for them — empty is just an unvalidated value, per this EC.

**Verification Properties**:
- VP-578-009: `:id` hint bypasses `allowedValues` entirely — wiremock asserts the resolved wire body regardless of `allowedValues` content (including an EMPTY `allowedValues` array) and asserts `changed_fields` shows the raw literal.

**Trace**: issue #578 item 1; BC-3.4.016 Step 1 (id-bypass precedent); BC-3.4.026 (parser)

[NEW 2026-08-25 issue #578 F2]

---

#### BC-3.4.029: `--field NAME:name=VALUE` hint — sends `{"name":"<VALUE>"}` verbatim for named-field references

**Confidence**: HIGH
**Source**: issue #578 F2 spec evolution (item 1, AC line 3)
**Subject**: Issue write — `:name` hint semantics

**Description**: `--field NAME:name=VALUE` sends `VALUE` verbatim as `{"name": "<VALUE>"}` on the wire. This targets Jira fields addressable by NAME rather than by numeric id — the canonical example is `priority` (`{"name": "Medium"}`), and any other field whose Jira Cloud wire contract accepts a `{"name": ...}` reference object. Like `:id`, this hint performs NO server-side existence validation client-side — an invalid name 400s server-side.

**Preconditions**: Same field-resolution preconditions as BC-3.4.015.

**Postconditions**:
- Wire payload: `{"customfield_NNNNN": {"name": "<VALUE>"}}` (or `{"priority": {"name": "<VALUE>"}}` for the literal `priority` field name, since `priority` bypasses custom-field resolution the same way it does today via the dedicated `--priority` flag's underlying wire logic — `--field priority:name=Medium` and `--priority Medium` MUST produce byte-identical wire output; see Invariant 2).
- `changed_fields` echo: `VALUE` verbatim (no lookup performed, no reverse-resolution).
- **Dry-run preview shape [ADDED 2026-08-26, F2 adversary-convergence round-5, F-NEW-2]:** Under `issue edit --dry-run` (BC-3.4.021 — edit-path only), `plannedChanges`'s entry for this `:name`-hinted `--field` shows the SAME `{"name": "<VALUE>"}` wire object the live PUT would send (or `{"name": "<VALUE>"}` under the `priority` bypass key, per Postconditions above), NOT the display-value string BC-3.4.021's general bare-form rule uses (see BC-3.4.021 Postconditions — json item 3's scope note) — verbatim, no lookup, mirroring the live wire payload exactly.

**Invariants**:
1. `:name` performs ZERO string matching against any option list — same "server is sole validator" posture as `:id`.
2. For system fields ALSO reachable via a dedicated named flag (currently only `priority`), the `--field NAME:name=VALUE` wire body MUST be byte-identical to the dedicated flag's wire body for the same value — this is a consistency guarantee, not a new code path; the dedicated flag's existing wire-composition function is reused, not duplicated. Prevents drift between two ways of setting the same field.
3. `:name` is NOT interchangeable with `:option` — `:option` performs a display-value → `allowedValues[].id` lookup and sends `{"id": ...}`; `:name` sends `{"name": ...}` with no lookup. These are two DIFFERENT Jira wire conventions for different field families; the hint syntax exposes both because `jr` cannot infer client-side which convention a given custom field expects (this ambiguity is exactly #578 item 1's motivating complaint).

**Edge Cases**:
- EC-3.4.029-1: `:name` hint on a field whose Jira wire contract expects `{"id": ...}` instead → server 400s; `jr` surfaces the error verbatim; no client-side pre-validation (mirrors EC-3.4.028-1's posture).
- EC-3.4.029-3 **[ADDED 2026-08-26, F2 adversary-convergence round-3, F-A]**: `:name` hint with an EMPTY `VALUE` (e.g. `--field cf:name=`) → `parse_field_kv` performs NO client-side empty-value check for this kind, identically to EC-3.4.028-3's `:id` case; the pair is sent through verbatim as `{"name": ""}`. NOT a `jr`-side exit-64 — direct consequence of Invariant 1's "zero string matching... server is sole validator" posture. The server 400s on the empty name and `jr` surfaces that error verbatim. See EC-3.4.028-3 for the full distinction from `:asset`'s empty-value case (BC-3.4.031 EC-2a), which IS a `jr`-side exit-64 for a structural (array-composition) reason `:name` does not share.
- EC-3.4.029-2 **[AMENDED 2026-08-26, F2 adversary-convergence pass, D2 — supersedes the pass-13 F-1 text below; SCOPED 2026-08-26, F2 adversary-convergence round-4, MED-1/F-3]**: `--field priority:name=Medium` combined with `--priority Medium` in the same invocation, **on the PLATFORM (non-JSM) CREATE path** (`jr issue create` WITHOUT `--request-type`, BC-3.4.014), is now **symmetric with the EDIT path** — it does NOT last-wins. **This scope is explicit and load-bearing, not incidental:** on the JSM create path (`--request-type` set), the D2 guard does NOT apply — see BC-3.8.008, which retains its own pre-existing "duplicate NAME → last wins" behavior unchanged; extending the D2 exit-64 guard to the JSM path is DEFERRED, flagged as an open decision for the F2 human gate, not silently assumed either way. Per ADR-0019 § Amendment (2026-08-26) D2, Gate B (BC-3.4.017) is extended to the platform create path via a new create-path guard sharing one extracted pure function, `field_resolve::detect_flag_field_overlap`, with `edit.rs`'s existing Gate B (the same function computes the overlap set for both callers; `create.rs`'s guard is not a second, independently-maintained implementation). Any argv order of `--priority Medium` and `--field priority:name=Medium` (or any hint kind, or any other field in the create-path's OWN governed set) → exit 64, no HTTP call, stderr names the colliding field — symmetric with EC-3.4.017-16's edit-path assertion. **[WIDENED 5→9, 2026-08-26, F2 adversary-convergence round-5, F-NEW-1]** The create-path governed set is NINE wire-key targets, NOT the five-member set this paragraph originally cited (`summary`/`description`/`issuetype`/`priority`/`components`) — that five-member enumeration was Gate B's EDIT-path set, reused verbatim in error rather than re-derived from `issue create`'s own dedicated-flag surface, per ADR-0019 § "D2 correction (adversary F-NEW-1)". The correct create-path set adds THREE more static-key members — `labels` (`--label`), `parent` (`--parent`), `assignee` (`--to`/`--account-id`) — plus the resolved-id category (`points`/`team`, ADR-0019 rows 9a/9b), detected only via the `customfield_NNNNN` bypass form — `--points` (against the profile's `story_points_field_id`) and `--team` (against the profile's `team_field_id`, when configured; `client.find_team_field_id()` HTTP is never invoked to service this guard). That is 5 (Gate B's original set) + 3 (new static keys) + 1 (the resolved-id category, covering both `--points` and `--team`) = 9 total, matching every other site's "nine" claim. **`labels` create-vs-edit divergence (load-bearing, not an inconsistency):** edit-path Gate B deliberately EXCLUDES `labels` because `issue edit --label` forks to a different endpoint/payload shape (BUG-LABEL-400); `issue create --label` has no such fork — one code path writes `fields["labels"]` unconditionally — so `labels` IS governed on create even though it is NOT governed on edit. **Bounded non-firing residual (documented, not silently gapped):** `--points 5 --field "Story Points"=8` (a human display name, not the `customfield_NNNNN` bypass form) does NOT trip the guard — resolving a display name here would require hoisting general field-name resolution ahead of the create-path guard's zero-HTTP boundary. See BC-3.3.010 EC-3.3.010-6a for the full nine-member enumeration with examples. The matching rule is identical to Gate B's: a hint-tagged pair is matched on its BARE NAME (BC-3.4.026's bare-key rule), so this is a set-intersection check over parsed inputs, inherently argv-order-independent. **Rationale for extending the guard rather than picking a precedence rule (e.g. "dedicated flag always wins"):** a precedence rule only relocates the ambiguity from "which merge order wins" to "which flag class is authoritative" — still a rule a user must discover — and for a state-changing command, silently discarding one of two explicitly-supplied values is worse than rejecting the ambiguous invocation outright (ADR-0019 § Amendment D2). **Previous version (superseded, pass-13 F-1, retained for audit trail):** "`--field priority:name=Medium` combined with `--priority Medium` in the same invocation, on the CREATE path (`jr issue create`, BC-3.4.014 — no Gate B mutual-exclusion guard exists on create) → LAST-WINS at the `fields` JSON object merge step (standard 'later flag wins' `jr` convention); no special-case guard preventing both from being supplied. This is a permissive but consistent behavior on create, not a hard conflict — no exit 64." — this claim (no Gate B on create) is now FALSE for the platform path; retained here only for audit trail, not as current contract. See BC-3.4.017 EC-3.4.017-16 for the full hint × Gate-B interaction across the EDIT path's five system fields and every hint kind (the create path's own nine-member set, widened per F-NEW-1 above, is documented at BC-3.3.010 EC-3.3.010-6a, not here), BC-3.3.010/BC-3.3.011 for the platform create-path guard's own precondition/error-taxonomy treatment, and BC-3.8.008 for the JSM create path's unchanged last-wins behavior.

**Verification Properties**:
- VP-578-010: `--field priority:name=Medium` produces byte-identical wire output to `--priority Medium`.

**Trace**: issue #578 item 1; BC-3.4.026 (parser)

[NEW 2026-08-25 issue #578 F2]

---

#### BC-3.4.030: `--field NAME:asset=WORKSPACE:OBJECTID` hint — composes an Assets object-reference array from a compact `WORKSPACE:OBJECTID` value

**Confidence**: HIGH
**Source**: issue #578 F2 spec evolution (item 1, AC line 4); `.factory/research/field-dx-feasibility-2026-08-25.md` claim 7 (CONFIRM); BC-4.2.001 (workspace ID discovery + cache — CORRECTED citation, see note below)
**Subject**: Issue write — `:asset` hint semantics (spans bc-3 and bc-4)

**Description**: `--field NAME:asset=WORKSPACE:OBJECTID` composes the Assets/CMDB object-reference array value Jira Cloud expects for a CMDB object-reference custom field: `[{"workspaceId": "<resolved>", "id": "<workspaceId>:<objectId>", "objectId": "<objectId>"}]`. `WORKSPACE` may be either the literal `workspaceId` string OR omitted (bare `:asset=<objectId>` form) to use the CACHED workspace id for the active profile — see Parsing rule 2 below. `OBJECTID` is the numeric Assets object id (the same id shown in `jr assets search` / `jr assets view` output).

This BC directly implements #578's motivating complaint (item 4): today, setting an Assets object-reference field requires hand-authoring the full `[{"workspaceId":...,"id":...,"objectId":...}]` JSON array and shell-escaping it as a raw `--field` value. The `:asset` hint composes this array from a compact, shell-safe scalar.

**CITATION CORRECTION (F2 authoring note)**: the F1 BC-mapping doc (`field-dx-bc-mapping.md` §1.3) and the feasibility research doc both cite "BC-4.1.001" for workspace ID discovery + cache. This is INCORRECT — BC-4.1.001 is `find_cmdb_fields()` (CMDB field schema filtering, unrelated). The correct citation is **BC-4.2.001** (`assets search` discovers workspace ID first, cache or API; `src/api/assets/workspace.rs`). This BC's Trace and Source fields below use the corrected citation; no change to bc-4-assets-cmdb.md itself (its BC-4.2.001 contract is reused read-only, unchanged).

**Parsing rule**:
1. `VALUE` is split on the FIRST `:` (within the already-extracted `NAME:asset=VALUE` value portion — this is a SECOND colon-split, independent of the `NAME:kind` split in BC-3.4.026 step 2, operating on the post-`=` value string). **[MUST, ADDED 2026-08-26, F2 adversary-convergence round-2, Pass2-F3]** This split MUST use `str::split_once(':')` (or, equivalently, `str::find(':')` followed by slicing exactly at the returned byte index) — NEVER a char-iterator index (e.g. `value.chars().position(|c| c == ':')`) used as a byte offset for slicing, and never any other fixed-byte-offset scheme. This is the SAME `str::split_once` MUST that ADR-0019 § Amendment (2026-08-26) D3 already mandates for the `>` cascading-delimiter split (BC-3.4.027 Invariant 5) — this `:` split is an INDEPENDENT split site (BC-3.4.026 step 5's Unicode-scalar-safety MUST is scoped to `parse_field_kv`'s own steps 1-2 only and does NOT cover this second, `:asset`-specific colon-split, exactly as BC-3.4.027's `>` split is not covered by it either), so it requires its own explicit MUST rather than inheriting one. A naive char-count-as-byte-index implementation panics whenever a multibyte Unicode scalar precedes the `:` in the `VALUE` portion (see EC-3.4.030-6 below) — the same char/byte-index-conflation bug class FIX-F6-LRE-1 (#734, `jql::validate_duration`) fixed. A proptest alone is insufficient to pin this — per D3's own rationale, the IMPLEMENTATION TECHNIQUE (`str::split_once`, not merely "must be Unicode-scalar-safe") must be pinned, since a proptest can pass by accident against a corpus that happens not to include a multibyte scalar immediately adjacent to the delimiter.
2. If a `:` is present: left segment = explicit `workspaceId`, right segment = `objectId`. If NO `:` is present: the entire `VALUE` is the `objectId`, and `workspaceId` is resolved via the EXISTING cached workspace-id lookup (`get_or_fetch_workspace_id`, per-profile, 7-day TTL, BC-4.2.001) — the SAME cache `jr assets search` already warms; no new cache family, no duplicate HTTP call if the cache is warm. **[DETERMINISTIC CHECK ORDER, ADDED 2026-08-26, F2 adversary-convergence round-4, LOW-1/O-1]** When a `:` IS present, the empty-workspace-segment check (EC-2c: left segment is `""`) is evaluated BEFORE the objectId-segment checks (EC-2b's empty-objectId / EC-3's non-numeric-objectId / EC-2d's extra-colon), in that order — an input matching BOTH conditions (e.g. `:asset=:`, where BOTH segments are empty, or `:asset=:Y:Z`, where the workspace segment is empty AND the remainder contains an extra `:`) always surfaces EC-2c's "workspace segment cannot be empty" message, never an objectId-shaped message. This makes the message deterministic for every input shape (the exit code is 64 either way; only the message text was previously ambiguous for these two overlapping inputs).
3. `objectId` MUST be non-empty and match ASCII-only `[0-9]+` (equivalently, `regex`'s `(?-u)\d+`) — **[CORRECTED 2026-08-26, F2 adversary-convergence round-2, Pass2-F4]** NOT the Unicode-aware `\d` class. Rust's `regex` crate's default `\d` matches the entire Unicode `Nd` (decimal number) category — including Arabic-Indic digits (`١٢٣`), fullwidth digits (`１２３`), and other non-ASCII numeral scripts — none of which Jira's server-side `objectId` field accepts. Client-side validation MUST reject exactly the same set the server does: ASCII `0`-`9` only. A non-ASCII "numeric" `objectId`, or a non-numeric or empty `objectId` segment, → exit 64 (BC-3.4.031 EC-3).
4. The composed `id` field is the `"{workspaceId}:{objectId}"` composite string — the SAME convention `jr` already reads on the display side in `LinkedAsset` (`src/types/assets/linked.rs`), applied here on the WRITE side for the first time.

**Preconditions**: Same field-resolution preconditions as BC-3.4.015 (field is on the Edit/Create screen — note: `allowedValues` is NOT expected to be populated for Assets fields per the Q-B graceful-degradation finding in the context-mechanism research; the field-presence check still applies, but the `option`-type dispatch does NOT — Assets fields have `schema.custom` = `com.atlassian.jira.plugins.cmdb:cmdb-object-cftype`, a DIFFERENT schema type from `option`).

**Postconditions**:
- Wire payload: `{"customfield_NNNNN": [{"workspaceId": "<ws>", "id": "<ws>:<objectId>", "objectId": "<objectId>"}]}` — a single-element array (multi-object Assets fields, if any, are OUT OF SCOPE this cycle — one `:asset=` hint composes exactly one array element; repeating `--field cf:asset=X --field cf:asset=Y` on the SAME NAME is last-wins per BC-3.4.026, NOT array-accumulating).
- `changed_fields` echo: `"<workspaceId>:<objectId>"` (the composite id string, not a resolved object name — resolving the object's human name would require an additional `GET .../object/<oid>` round-trip, deliberately not performed here to keep this a pure client-side composition with no extra HTTP beyond the cached-or-fetched workspace id).
- `get_or_fetch_workspace_id` is called AT MOST ONCE per invocation regardless of how many `:asset` hints are present (shared, cached, mirrors BC-3.4.015's `fields.json` cache-sharing pattern).
- **Dry-run preview shape and side effect [ADDED 2026-08-26, F2 adversary-convergence round-5, F-NEW-2]:** Under `issue edit --dry-run` (BC-3.4.021 — edit-path only), `plannedChanges`'s entry for this `:asset`-hinted `--field` shows the SAME composed `[{"workspaceId":"<ws>","id":"<ws>:<objectId>","objectId":"<objectId>"}]` array the live PUT would send — NOT the display-value string BC-3.4.021's general bare-form rule uses (see BC-3.4.021 Postconditions — json item 3's scope note), and NOT the simplified `"<workspaceId>:<objectId>"` composite string this BC's own LIVE `changed_fields` echo (above) uses — the dry-run preview and the live success echo are two distinct, already-independently-specified channels, and neither is further simplified for dry-run. **Side-effect pin (load-bearing):** resolving a bare `:asset=<objectId>` form still requires `get_or_fetch_workspace_id` per the Postconditions above, and this resolution runs UNCONDITIONALLY inside the `--dry-run` block, exactly as `--field` editmeta resolution does for the bare form (BC-3.4.021 Postconditions — Common item 3). Consequently, on a COLD workspace-id cache, `--field cf:asset=<objectId> --dry-run` fires the REAL `GET /rest/servicedeskapi/assets/workspace` HTTP call and CAN exit 64 from this BC's own cold-cache error taxonomy above (Assets-unavailable, no-workspace-provisioned, 401/5xx/network-error mapping) BEFORE any `plannedChanges` output is emitted — i.e. a `--dry-run` invocation can exit 64 purely from workspace discovery, the same "dry-run does not suppress resolution errors" class BC-3.4.021 Invariant 2 already establishes for the bare-form editmeta case (cross-reference EC-3.4.015-19). This is NOT a new error taxonomy — it is the SAME cold-cache taxonomy above, now pinned as reachable from `--dry-run` too, not only from a live edit.

**Invariants**:
1. `:asset` never performs Assets AQL search or object validation — the `objectId` is trusted as supplied (numeric-shape validated only). An invalid/nonexistent `objectId` is a server-side rejection, surfaced as a standard `JrError`. Client-side existence validation is explicitly a non-goal (would require an extra `GET` round-trip per hint, and `jr assets search`/`jr assets view` already exist as the discovery tools).
2. `:asset` composes EXACTLY ONE array element per hint occurrence. No accumulation across repeated `--field` occurrences on the same NAME (last-wins, per BC-3.4.026 Invariant on duplicate NAME).
3. The workspace-id cache read/write is READ-ONLY reuse of BC-4.2.001 — no new cache file, no new cache function, no change to that BC's own contract.
4. **[ADDED 2026-08-26, F2 adversary-convergence round-2, Pass2-F3]** The `WORKSPACE:OBJECTID` first-colon split (Parsing rule 1 above) MUST use `str::split_once(':')` — never a char-index-based or fixed-byte-offset scheme. See Parsing rule 1's MUST for the full rationale (mirrors ADR-0019 § Amendment D3's `str::split_once('>')` MUST for BC-3.4.027's cascading split).

**Error taxonomy — bare `:asset=<objectId>` cold-cache workspace discovery failure [ADDED 2026-08-26, F2 adversary-convergence pass, B-LOW; SCOPE WIDENED 2026-08-26, F2 adversary-convergence round-2, Pass2-F1]**: the bare form's cold-cache `get_or_fetch_workspace_id` GET (`GET /rest/servicedeskapi/assets/workspace`, `src/api/assets/workspace.rs`) can itself fail; this BC pins that behavior explicitly (previously undocumented) across **all three call sites** that can trigger a bare `:asset=<objectId>` hint: `issue edit --field` (BC-3.4.015/030), `issue create --field` on the platform path (BC-3.3.010), and `handle_jsm_create` on the JSM path (BC-3.8.008's `:asset` bare-form workspace resolution, per BC-3.8.008 amendment § "the L2 handler that calls `build()` … resolves the cached/fetched workspace id via `get_or_fetch_workspace_id` BEFORE constructing the `FieldValueSpec::Asset` value"). The three call sites were previously under-scoped to two (edit + platform-create only); the JSM create site was omitted despite BC-3.8.008 independently specifying the identical `get_or_fetch_workspace_id`-first behavior for its own bare-form case:
| Condition | Behavior |
|---|---|
| Cold-cache GET returns 403 or 404 | `JrError::UserError`: "Assets is not available on this Jira site. Assets requires Jira Service Management Premium or Enterprise." → exit 64 (tenant lacks the Assets/CMDB entitlement — a 403/404 on this specific endpoint is `get_or_fetch_workspace_id`'s own signal for "no Assets", not a generic auth failure) |
| Cold-cache GET succeeds (200) but returns zero workspace entries (tenant has JSM but no Assets workspace provisioned) | `JrError::UserError`: "No Assets workspace found on this Jira site. Assets requires Jira Service Management Premium or Enterprise." → exit 64 |
| Cold-cache GET returns 401 | Standard `JrError::NotAuthenticated`/`InsufficientScope` mapping (unchanged from every other `jr` HTTP call) — NOT the Assets-specific UserError above; auto-refresh (S-3.03) applies identically to any other 401 |
| Cold-cache GET returns 5xx or a network error | Standard `JrError::ApiError`/`NetworkError` mapping (unchanged) — propagated as-is, NOT the Assets-specific UserError |

None of these four outcomes is client-side pre-validated before the GET fires — this is a genuine HTTP round-trip on a cold cache (warm-cache reads never reach this code path at all, per VP-578-011). This taxonomy applies identically whether the triggering `:asset=<objectId>` hint appears on `issue edit --field`, `issue create --field` (BC-3.3.010, platform path), or `--request-type <NAME> --field` (BC-3.8.008, JSM create path via `handle_jsm_create`) — **[WIDENED 2026-08-26, F2 adversary-convergence round-2, Pass2-F1]** the L2 handler on EACH of the three call sites calls the same `get_or_fetch_workspace_id` function (ADR-0019 §2's "L2 resolves, `build()` only wraps" split); the failure taxonomy above is WIRE-SHAPE-INDEPENDENT (every row fires during workspace-id resolution, which happens strictly BEFORE any `:asset` array is composed on any path), so it applies uniformly to all three sites regardless of what each site's happy-path wire shape looks like.

**Distinction from the JSM `:asset` happy-path wire shape (do not conflate the two)**: the cold-cache workspace-discovery FAILURE taxonomy above is settled, CONFIRMED behavior on all three call sites as of this round. This is INDEPENDENT of, and must not be read as resolving, the SEPARATE open question of whether the JSM path's happy-path `:asset` `requestFieldValues` WIRE SHAPE (the composed `[{"workspaceId","id","objectId"}]` array once workspace-id resolution succeeds) matches the platform-path shape — that wire-shape question remains UNVERIFIED and deferred per VP-578-016 (BC-3.8.008 amendment). In short: workspace-discovery FAILURE handling is verified-and-uniform across all 3 sites now; the JSM `:asset` SUCCESS-path WIRE shape stays unverified/deferred.

**Edge Cases**:
- EC-3.4.030-1: Bare `:asset=12345` (no `workspace:` prefix) → resolves `workspaceId` via the per-profile cache (warm) or `GET /rest/servicedeskapi/assets/workspace` (cold, then cached) — see BC-3.4.031 EC-2 for the malformed-shape catalog entry, and the error taxonomy above for cold-cache GET failure behavior.
- EC-3.4.030-2: `:asset=<ws>:<objectId>` with an EXPLICIT `workspaceId` that does not match the active profile's actual workspace → `jr` does NOT validate the supplied workspace id against the cached/fetched one; it is passed through verbatim. This is a deliberate escape hatch for multi-workspace tenants who know their exact target workspace id. Server-side rejects a genuinely wrong workspace id.
- EC-3.4.030-3: `objectId` segment is non-numeric or empty → exit 64 (BC-3.4.031 EC-3).
- EC-3.4.030-4: `:asset` hint on a field whose `schema.custom` is NOT the CMDB object-reference type → `jr` does NOT client-side schema-gate this (consistent with `:id`/`:name`'s "server is sole validator" posture); the composed array is sent as-is and the server 400s if the field doesn't accept an Assets object-reference array.
- EC-3.4.030-5 **[ADDED 2026-08-26, B-LOW]**: Bare `:asset=<objectId>` on a cold cache, tenant has NO Assets workspace provisioned (JSM present but Assets/CMDB not enabled) → `get_or_fetch_workspace_id` returns zero workspace entries → exit 64, "No Assets workspace found on this Jira site" (see error taxonomy above). Distinct from EC-3.4.030-4 (field schema mismatch, a 400 from the FIELD-write POST) — this failure happens earlier, during workspace-id RESOLUTION, before any field-write POST is attempted.
- EC-3.4.030-6 **[ADDED 2026-08-26, F2 adversary-convergence round-2, Pass2-F3]**: `VALUE` contains a multibyte Unicode scalar immediately preceding the first `:` — e.g. `--field cf:asset=Wé:123` (a non-ASCII `workspaceId` segment, `"Wé"`, immediately followed by `:`) → resolves normally (explicit `workspaceId = "Wé"`, `objectId = "123"`), NEVER panics — the `str::split_once(':')` MUST (Parsing rule 1, Invariant 4) is precisely what prevents the FIX-F6-LRE-1-class byte/char-index-conflation panic on this input shape. (This EC exercises the SPLIT's Unicode safety only — `objectId = "123"` here is still valid ASCII digits per Parsing rule 3's ASCII-only `[0-9]+` requirement; a multibyte scalar in the `objectId` segment itself is already covered by EC-3.4.030-3's non-numeric rejection, now via the ASCII-only class per Pass2-F4.)

**Verification Properties**:
- VP-578-011: Bare `:asset=<objectId>` form resolves `workspaceId` from the WARM cache with zero additional HTTP calls; composes the correct `[{workspaceId,id,objectId}]` wire shape.
- VP-578-012: `objectId`-only malformed shapes (non-ASCII-numeric per Pass2-F4's `[0-9]+` correction, empty) exit 64 before any HTTP call — property test per the F1 delta analysis §3 recommendation (parallels `prop_sanitize_attachment_filename_no_path_traversal`, VP-576-001). **[EXTENDED 2026-08-26, F2 adversary-convergence round-2, Pass2-F3]** This property test's corpus is extended to include a no-panic assertion over the `WORKSPACE:OBJECTID` first-colon split (Parsing rule 1 / Invariant 4) across arbitrary UTF-8 input, mirroring VP-578-008's D3 no-panic extension for the `>` split — proving EC-3.4.030-6 (multibyte scalar adjacent to `:`) never panics, not merely that the documented fixture resolves correctly. **[EXTENDED 2026-08-26, F2 adversary-convergence round-3, F-C — FLAGGED FOR VERIFIER]**: this VP's §2 (the exit-64 message-assertion section) must be aligned to BC-3.4.031's new EC-2d (`:asset=W:Y:Z`, a second colon inside the value): the fixture `W:Y:Z` must assert exit 64 with a message naming the extra-colon mistake specifically (e.g. containing `"unexpected extra ':'"` — see EC-2d for the exact required wording), NOT the generic "objectId must be numeric" substring EC-3's fixtures assert — a test that only checks exit-64-and-any-message would pass even if the implementation regressed to the misleading generic message EC-2d exists to correct. This is a message-content assertion, not merely an exit-code assertion.
- VP-578-022 **[NEW 2026-08-26, B-LOW; EXTENDED 2026-08-26, F2 adversary-convergence round-2, Pass2-F1]**: each row of the cold-cache workspace-discovery error taxonomy above is independently exercised via wiremock (403/404 → Assets-unavailable UserError exit 64; 200 + empty `values` → no-workspace UserError exit 64; 401 → standard auth-error mapping; 5xx/network error → standard API/network-error mapping), on **all three call sites**: `issue edit --field`, `issue create --field` (platform path), AND `issue create --request-type <NAME> --field` (JSM path, `handle_jsm_create`) — the JSM site was omitted from the prior (B-LOW) revision of this VP and is now in scope. The JSM-site assertions cover the workspace-discovery FAILURE taxonomy only, per the distinction note above; they do NOT assert anything about the JSM `:asset` happy-path wire shape, which remains covered (as UNVERIFIED/deferred) by VP-578-016.

**Trace**: issue #578 item 1 (item 4 motivating complaint); `.factory/research/field-dx-feasibility-2026-08-25.md` claim 7; BC-4.2.001 (workspace ID discovery + cache, `src/api/assets/workspace.rs::get_or_fetch_workspace_id` — CORRECTED citation, was mis-cited as BC-4.1.001 in the F1 BC-mapping doc); `src/types/assets/linked.rs` (`LinkedAsset` composite-id read-side convention, reused on write); BC-3.4.026 (parser)

[NEW 2026-08-25 issue #578 F2]

---

#### BC-3.4.031: Malformed `--field NAME:kind=VALUE` hint edge cases — exit 64 catalog, companion to BC-3.4.026

**Confidence**: HIGH
**Source**: issue #578 F2 spec evolution; companion EC catalog to BC-3.4.026
**Subject**: Issue write — hint-syntax malformed-input taxonomy

**Description**: This BC catalogs the exit-64 behavior for every malformed-hint shape identified during F2 spec authoring, as its own BC per the F1 BC-mapping doc's recommendation (a companion to BC-3.4.026's parser contract, mirroring the BC-3.4.015-taxonomy / BC-3.4.016-taxonomy split precedent).

**Edge Cases**:
- EC-1 (unknown kind): `--field cf:bogus=X` → `:` segment present but not in `{option, id, name, asset}` → `JrError::UserError` exit 64. Message MUST list the four valid kinds. Load-bearing substring: `"unknown field-value kind"`. No HTTP.
- EC-2 (`:asset` malformed `WORKSPACE:OBJECTID` shape) **[SCOPE NOTE ADDED 2026-08-26, F2 adversary-convergence round-3, F-A; SUB-CASE COUNT CORRECTED 2026-08-26, F2 adversary-convergence round-3, F-C — three sub-cases (EC-2a/b/c) was stale; EC-2d below is a fourth]**: covers FOUR sub-cases, all exit 64, no HTTP. **This is the ONLY `:kind` in this catalog whose empty-value form is a client-side exit-64** — and even then, for a STRUCTURAL reason, not a value-validation one: the `:asset` composer must build a `[{workspaceId, id, objectId}]` object-reference array, and an empty `objectId` gives it nothing to compose an `id`/`objectId` field from — there is no valid array to send, so `jr` rejects it before attempting to build one. Contrast EC-8/EC-9 below (`:id`/`:name` empty value), which are explicitly NOT exit-64, because `:id`/`:name` never compose a structured shape from `VALUE` — they wrap it verbatim (`{"id": ""}`/`{"name": ""}`), so an empty string is just another unvalidated value the server is free to accept or reject, per BC-3.4.028/029 Invariant 1's "server is sole validator" posture. Do not generalize EC-2a's exit-64 outcome to `:id=`/`:name=` — see BC-3.4.028 EC-3.4.028-3 / BC-3.4.029 EC-3.4.029-3 for the full rationale.
  - EC-2a: `:asset=` (empty value entirely) → exit 64, "asset reference cannot be empty".
  - EC-2b: `:asset=ws:` (workspace present, objectId segment empty) → exit 64, same message as EC-3.4.030-3.
  - EC-2c: `:asset=:12345` (workspace segment empty, colon present) → treated as a malformed EXPLICIT-workspace form (NOT the bare-objectId form, since a colon IS present) → exit 64, "workspace segment cannot be empty when ':' is present; omit the workspace prefix entirely to use the cached workspace id". **[DETERMINISTIC ORDER, ADDED 2026-08-26, F2 adversary-convergence round-4, LOW-1/O-1]** This check runs BEFORE the objectId-segment checks (EC-2b / EC-3 / EC-2d below) — per BC-3.4.030 Parsing rule 2's deterministic check order, an input matching BOTH an empty workspace segment AND a malformed objectId segment (e.g. `:asset=:` — both segments empty; or `:asset=:Y:Z` — empty workspace plus an extra `:` in the remainder) ALWAYS surfaces this EC-2c message, never EC-2b's/EC-3's/EC-2d's.
  - EC-2d **[ADDED 2026-08-26, F2 adversary-convergence round-3, F-C]**: `:asset=W:Y:Z` (a SECOND colon inside the value, e.g. `--field cf:asset=W:Y:Z`) → per BC-3.4.030 Parsing rule 1's `str::split_once(':')` semantics, the FIRST `:` splits the value into `workspaceId = "W"` and the REMAINDER `"Y:Z"` as the objectId candidate — `str::split_once` never re-splits on a later `:`. `"Y:Z"` then fails Parsing rule 3's ASCII-only `[0-9]+` check (it contains a non-digit `:` character) → exit 64. The message MUST NOT be the bare, unqualified "objectId must be numeric" text alone (EC-3) — because a caller who supplied THREE colon-separated segments most likely made a distinct, more specific mistake (miscounting the expected `WORKSPACE:OBJECTID` shape as three-part, or attempting to also specify something like a schema/type segment) than a caller who supplied a genuinely non-numeric two-segment objectId. `jr` MUST detect that the post-`split_once` objectId candidate itself still contains a `:` and, in that specific case, emit a message naming the actual mistake, e.g. `"unexpected extra ':' in :asset value — expected WORKSPACE:OBJECTID"`, rather than the generic "objectId must be numeric" wording. This is a message-content refinement over EC-3's existing exit-64 outcome, not a new exit path — `W:Y:Z` was always going to exit 64 under the pre-existing Parsing rule 3 check; only the message shape is corrected here to be actionable for this specific miscount. **Corrects a previously-incomplete catalog**: this BC's EC-2 sub-case enumeration was under-counted at three (EC-2a/b/c) prior to this round; EC-2d is the fourth.
- EC-3 (`:asset` non-numeric `objectId`): `--field cf:asset=abc` (bare form, non-numeric) or `--field cf:asset=ws:abc` (explicit form, non-numeric objectId segment) → exit 64, "objectId must be numeric". **[CORRECTED 2026-08-26, F2 adversary-convergence round-2, Pass2-F4]** "Numeric" here means ASCII `[0-9]+` ONLY (equivalently, `regex`'s `(?-u)\d+`), NOT Rust `regex`'s default Unicode-aware `\d` (which matches the entire `Nd` category). A non-ASCII "numeric" `objectId` — e.g. `--field cf:asset=١٢٣` (Arabic-Indic digits) or `--field cf:asset=１２３` (fullwidth digits) — MUST also exit 64 with this same message; it is a malformed shape, not a valid `objectId`, because Jira's server-side field does not accept non-ASCII digit scripts. See BC-3.4.030 Parsing rule 3. **[SCOPE NOTE, F2 adversary-convergence round-3, F-C]** EC-2d above is a DISTINCT sub-case that also fails the ASCII `[0-9]+` check but MUST NOT reuse this EC's generic message — see EC-2d for the extra-colon-specific wording requirement.
- EC-4 (`:id` value that fails no client-side check): NOTE — per BC-3.4.028 Invariant 1, `:id` performs NO client-side numeric-shape validation (deliberate, server is sole validator). This item is EXPLICITLY NOT a `jr`-side exit-64 case — listed here only to document that it was considered and rejected as a guard, preventing a future implementer from adding an inconsistent client-side check.
- EC-5 (empty `:kind` segment, i.e. `--field cf:=VALUE`): the segment between `:` and `=` is empty string → treated as EC-1 (unknown kind; empty string is not in the closed set) → exit 64 with the same four-valid-kinds message.
- EC-6 (colon inside VALUE, not NAME): `--field cf:option=High:Priority` (a `:` appears in VALUE, after the `=`) → NOT reinterpreted as a nested hint. The split in BC-3.4.026 step 1 (on `=`) happens BEFORE the `:kind` split (step 2), and step 2 only inspects the pre-`=` portion. `VALUE` = `"High:Priority"` verbatim, `kind` = `option`. No special handling needed — this is a natural consequence of split ordering, documented here as a regression pin, not a new guard.
- EC-7 (multiple `:` in the NAME segment before `=`, no valid kind at the end): `--field "Region: EMEA:bogus=X"` → BC-3.4.026 step 2 splits on the LAST `:` before `=`, isolating `bogus` as the candidate kind → unknown kind (EC-1) → exit 64. The field name `"Region: EMEA"` is never successfully isolated in this failure case (the error message may show the full unparsed NAME segment, not a guessed field name) — acceptable, since the invocation is malformed either way and the user must be more precise (e.g., use `customfield_NNNNN` to bypass name-based colon ambiguity entirely).
- EC-8 (empty `:id` value — PASS-THROUGH, not exit-64) **[ADDED 2026-08-26, F2 adversary-convergence round-3, F-A]**: `--field cf:id=` → `parse_field_kv` performs no empty-value rejection for `:id` — the pair carries `FieldValueSpec { kind: Some(Id), value: "" }` and resolves normally through to BC-3.4.028, which wraps it verbatim as `{"id": ""}` on the wire. This is explicitly NOT a `jr`-side exit-64 case, unlike EC-2a's `:asset=` (empty) case — see BC-3.4.028 EC-3.4.028-3 and EC-2's scope note above for the structural-vs-value-validation distinction that explains why `:asset` differs. The server is the sole validator of the empty id; it 400s, and `jr` surfaces that error verbatim (standard `JrError`, not a pre-validation exit-64).
- EC-9 (empty `:name` value — PASS-THROUGH, not exit-64) **[ADDED 2026-08-26, F2 adversary-convergence round-3, F-A]**: `--field cf:name=` → identically to EC-8, `parse_field_kv` performs no empty-value rejection for `:name` — the pair resolves to `{"name": ""}` on the wire (BC-3.4.029 EC-3.4.029-3). Explicitly NOT a `jr`-side exit-64 case. Server-side 400 surfaces verbatim.

**Verification Properties**:
- VP-578-013 **[SCOPE NOTE ADDED 2026-08-26, F2 adversary-convergence round-3, F-A — FLAGGED FOR VERIFIER; ENUMERATION CORRECTED 2026-08-26, F2 adversary-convergence round-5, MED-1 — EC-2d dropped from this VP's enumeration, self-contradiction with this same VP's own exclusion sentence below]**: Every edge case above (EC-1, EC-2a/b/c, EC-3, EC-5) is exercised by a dedicated unit test asserting exit 64, zero HTTP, and the documented load-bearing substring. **This VP's empty-value→exit-64 assertion is scoped to `:asset` ONLY (EC-2a)** — it MUST NOT assert exit-64 for an empty `:id=`/`:name=` value (EC-8/EC-9 above are PASS-THROUGH, not exit-64; VP-578-005 already covers "empty value allowed at the parser" for the bare/hinted forms generally, and EC-8/EC-9 are the `:id`/`:name`-specific instances of that same VP-578-005 posture, not a VP-578-013 case). The verifier realizing this VP must also correct its `prop_oneof!` property-test strategy, which currently omits `:name` from its generated kind space — the strategy must generate all four kinds (`option`/`id`/`name`/`asset`) so the empty-value-is-scoped-to-`:asset` assertion above is actually exercised against `:name` and not silently skipped. EC-2d (the `W:Y:Z` extra-colon case) is covered by VP-578-012's extension (BC-3.4.030, above), not by this VP — see the F-C flag on VP-578-012 for the exact message-shape assertion required.
- VP-578-014: EC-6 and EC-7 are exercised as REGRESSION PINS (not error-path tests) — EC-6 asserts NORMAL resolution proceeds (not an error); EC-7 asserts the specific unknown-kind error fires (not a different, wrong error).

**Trace**: issue #578 item 1; companion to BC-3.4.026 (parser), BC-3.4.027 (`:option`), BC-3.4.028 (`:id`), BC-3.4.030 (`:asset`)

[NEW 2026-08-25 issue #578 F2]

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
**Source**: `src/api/jira/issues.rs::delete_comment`; `src/cli/issue/interactions.rs::handle_comment_delete`; tests `tests/comment_delete.rs`
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
**Source**: `src/cli/issue/interactions.rs::handle_comment_delete`; tests `tests/comment_delete.rs`
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

**EC-3.5.003-3** [GAP-R15-001 terminology sync 2026-07-16 — DEC-174 mechanism; behavior unchanged] (EOF / IO-error on delete prompt → `JrError::Interrupted`, exit 130): When the `comment delete` confirmation prompt reads via `io::stdin().lock().read_line()`, the return value `Ok(0)` (zero bytes, EOF — Ctrl+D) or any `Err(_)` (IO error, Ctrl+C interrupt) MUST propagate as `JrError::Interrupted`; exit 130. These MUST NOT be silently swallowed or mapped to the cancel path (exit 0). `Ok(0)` (EOF) is distinguishable from empty-Enter (`Ok(n)`, n ≥ 1, buffer `"\n"`) — the distinction is real and load-bearing. This ensures consistent EOF / interrupt behavior across all interactive confirmation prompts in the comment family (mirrors EC-3.5.008-5 for the `--public` prompt; same three-way branch as EC-3.9.015-5).

**Verification Properties**:

**VP-577-005**: `--no-input` mode without `--yes` → exit 64; assert no HTTP DELETE was sent (wiremock `.expect(0)` on the DELETE route).

**VP-577-013**: `comment delete FOO-1 --id 10001 --output json` in interactive mode; user selects N (cancel) → exit 0; stdout parses as JSON `{"cancelled": true, "deleted": false}`; parsed stdout top-level object keys == `BTreeSet::from(["cancelled", "deleted"])` (exact key-set; pins EC-3.5.003-2's id/key-omitted-from-cancel-envelope rule); no HTTP DELETE sent (wiremock `.expect(0)`). **Seam note**: the interactive branch (TTY path) is unreachable in wiremock tests without the `JR_STDIN_IS_TTY` debug seam — set this env var to `"1"` to force `jr` to treat stdin as a TTY in debug builds; see the Delivery-task obligation below.

**Implementation note (interactive-branch test seam)**: Seam mechanism and delivery obligation: see the Delivery-task obligation below; duplicated at BC-3.5.006 item (c).

**Delivery-task obligation (implementing story, F4)**: Per BC-3.5.006 item (c), duplicated here: a `JR_STDIN_IS_TTY` debug seam (`#[cfg(debug_assertions)]`-gated, release builds ignore) enabling interactive-branch tests (VP-577-013 and analogous y/N prompt tests) — the interactive branch (TTY path) is unreachable in wiremock tests without this seam; when set to `"1"` in a debug build, `jr` treats stdin as a TTY regardless of the actual fd state; the seam implementation MUST be accompanied in the same commit by a release-gate regression test (mirrors the `JR_BASE_URL`/`JR_CONFIG_DIR` gate pattern) and a `CLAUDE.md` doc line for `JR_STDIN_IS_TTY` (codified doc-fallout rule); interactive prompts MUST write the prompt to stderr and read the answer from stdin so piped stdin drives the interaction (prompt-to-stderr invariant — EC-3.5.003-2 / EC-3.5.008-2; EOF → `JrError::Interrupted`, exit 130); required in all builds, not seam-gated. Ratified mechanism (DEC-174): `eprint!` prompt to stderr + `io::stdin().lock().read_line()` + trim/lowercase y|yes semantics; Err/EOF → `JrError::Interrupted` (exit 130). `dialoguer::interact_on` is UNUSABLE here (`_interact_on` returns `Err(NotConnected)` when the passed `Term` is not a tty, i.e. piped stderr, BEFORE reading any input; empirically proven in F4 — the previous claim that "dialoguer still reads input from stdin" via `interact_on(&Term::stderr())` is FALSE (DEC-174)); the seam gates ONLY the src/main.rs auto-`--no-input` flip; the F4 story MUST prove the seam+prompt combination works in a wiremock subprocess test before relying on VP-577-013.

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 3; adversary pass-2 MEDIUM-1 remediation; adversary pass-6 MEDIUM-1 JR_STDIN_IS_TTY seam; adversary pass-8 L1 seam-scope; adversary pass-11 F1 Term::stderr(); adversary pass-22 F4 delivery-task obligation added; adversary pass-35 F-A5 EC-3.5.003-3 dialoguer Err → JrError::Interrupted exit 130; adversary pass-40 F-03 VP-577-013 extended (BTreeSet exact key-set + id/key-omitted-from-cancel-envelope rule); GAP-R15-001 EC-3.5.003-3 terminology sync 2026-07-16 (dialoguer→read_line Ok(0)/Err; behavior unchanged); issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.004: `comment delete` 404 → exit 64; surfaces Jira error body — NOT idempotent

**Confidence**: HIGH
**Source**: `src/cli/issue/interactions.rs::handle_comment_delete`; `src/api/jira/issues.rs::delete_comment`; tests `tests/comment_delete.rs`
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
**Source**: `src/api/jira/issues.rs::update_comment`; `src/cli/issue/interactions.rs::handle_comment_edit`; tests `tests/comment_edit.rs`
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

> **RESOLVED (visibility PRESERVED verdict, 2026-07-09)**: Body-only PUT does NOT clear an existing role/group visibility restriction — restriction changes ONLY when the caller explicitly includes a `visibility` object in the PUT body (verdict medium-high confidence; `.factory/research/issue-577-visibility-put-semantics-2026-07-09.md`; load-bearing evidence: Atlassian's child-comment-visibility-400 announcement is only coherent under PRESERVED semantics; patch-shaped PUT convention, zero restriction-loss reports across community usage, GET-symmetry argument). `jr` NEVER sends a `visibility` key on `comment edit` in this cycle (no restriction-editing surface exposed). Definitive empirical check **SATISFIED** (scheduled nightly run 29398774009, 2026-07-15T07:51Z, develop @ 56d5126; `tests/e2e_live.rs::test_e2e_comment_edit_visibility_merge_semantics` Scenario 2 green); probe did not refute PRESERVED; verdict stands.

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 1; research verdict Claim 1 REFUTED-footgun; adversary pass-5 M6b marker (since resolved — PRESERVED verdict 2026-07-09); adversary pass-32 F2 VP-577-025 human-echo-marker pin; adversary pass-34 F-577-A VP-577-026 jsm_internal boolean-type + key-absence parse pin; adversary pass-35 F-A2 Other-4xx/5xx-except-401 + 401-auth-path clause; adversary pass-38 F-01 VP-577-023 top-level key-set assertion + VP-577-026 variants 1/2/3 changed_fields key-set assertions; adversary pass-39 F1 VP-577-023 human-mode variant; F4 VP-577-025 JSDCLOUD-6050 assertions (both variants); issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.006: `comment edit --internal` explicitly sends `properties:[{"key":"sd.public.comment","value":{"internal":true}}]` in the PUT body

**Confidence**: MEDIUM-HIGH
**Source**: `src/api/jira/issues.rs::update_comment`; `src/cli/issue/interactions.rs::handle_comment_edit`; tests `tests/comment_edit.rs`; gated e2e `tests/e2e_live.rs::test_e2e_comment_edit_visibility_merge_semantics`
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

> **RESOLVED (HIGH-3 MERGE verdict, human-approved 2026-07-09)**: Jira's comment-PUT `properties` array is MERGE semantics (unlisted entity properties preserved) — research verdict medium-high confidence (`.factory/research/issue-577-properties-merge-replace-2026-07-09.md`; per-key CRUD architecture, no bulk endpoints for comment properties, zero property-loss reports across years of community single-key usage). Direct-array pattern as specced is confirmed safe. Definitive empirical probe **SATISFIED** (scheduled nightly run 29398774009, 2026-07-15T07:51Z, develop @ 56d5126; `tests/e2e_live.rs::test_e2e_comment_edit_visibility_merge_semantics` green); probe did not refute MERGE; verdict stands.

**Delivery-task obligation (implementing story, F4)** **[SATISFIED 2026-07-15 — items (a)+(b)+(c) all delivered; EJ probe (b) confirmed green: run 29398774009, 2026-07-15T07:51Z, develop @ 56d5126, `tests/e2e_live.rs::test_e2e_comment_edit_visibility_merge_semantics`]**: The story MUST include: (a) a `CLAUDE.md` gotcha documenting the MERGE verdict, citing `.factory/research/issue-577-properties-merge-replace-2026-07-09.md`, and explicitly stating the do-not-default-to-sending-properties rule (BC-3.5.005); and (b) a gated e2e test in `tests/e2e_live.rs` implementing the 5-step MERGE probe from `.factory/research/issue-577-properties-merge-replace-2026-07-09.md § "Proposed empirical probe"` against project EJ (`JR_E2E_JSM_PROJECT`), self-cleaning per the per-comment DELETE rule stated below. The test function implements three scenarios in sequence: **Scenario 1 (MERGE probe)**: the 5-step MERGE probe described above. **Scenario 2 (PRESERVED base — 2-step)**: (1) create a JSM comment with a role/group visibility restriction; (2) perform a body-only PUT and re-GET; assert the restriction survives (confirming the PRESERVED verdict from `.factory/research/issue-577-visibility-put-semantics-2026-07-09.md`). **Scenario 3 (compound cell — NOT a substitute for Scenario 2)**: create a JSM comment carrying BOTH a role/group visibility restriction AND a `jr.test.marker` property; the PUT body is `{"body": ..., "properties": [{"key": "sd.public.comment", "value": {"internal": false}}]}` with NO `visibility` key; re-GET; assert BOTH the restriction AND `jr.test.marker` survive. This closes the weakest safety-table cell: MERGE for properties does not interfere with PRESERVED for visibility when both are simultaneously present. Scenario 3 is an explicit ADDITION to Scenario 2 — NOT a substitute for it; both MUST run. All three scenarios live in the same gated e2e test function and self-clean via `jr issue comment delete <key> --id <cid> --yes` (or the equivalent DELETE API call) on each probe comment created — NOT via `jsm_self_close`, which closes the parent issue and would consume the reusable EJ test asset. If a probe run creates a fresh JSM request, the parent MAY additionally be closed via `jsm_self_close` at teardown; the comment-DELETE step is mandatory in either flow. **Sequencing constraint (delivery PR, F3):** `jr issue comment delete` ships in the SAME story (S-577-1). For CLI-based teardown to work, the delete subcommand MUST be implemented before or alongside the e2e probe function in the same PR — the teardown call `jr issue comment delete <key> --id <cid> --yes` requires the subcommand to be present in the binary under test. A raw-API-DELETE fallback (via `jr api DELETE /rest/api/3/issue/{key}/comment/{id}`) is permitted but drops the incidental CLI regression signal that `jr issue comment delete` works against a live endpoint. The story PR MUST explicitly declare which teardown pattern is used (CLI-delete or raw-API-DELETE). Additionally: (c) a `JR_STDIN_IS_TTY` debug seam (`#[cfg(debug_assertions)]`-gated, release builds ignore) enabling interactive-branch tests (VP-577-013 and analogous y/N prompt tests); the seam implementation MUST be accompanied in the same commit by a release-gate regression test (mirrors the `JR_BASE_URL`/`JR_CONFIG_DIR` gate pattern) and a `CLAUDE.md` doc line for `JR_STDIN_IS_TTY` (codified doc-fallout rule); interactive prompts MUST write the prompt to stderr and read the answer from stdin so piped stdin drives the interaction (prompt-to-stderr invariant — EC-3.5.003-2 / EC-3.5.008-2; EOF → `JrError::Interrupted`, exit 130); required in all builds, not seam-gated. Ratified mechanism (DEC-174): `eprint!` prompt to stderr + `io::stdin().lock().read_line()` + trim/lowercase y|yes semantics; Err/EOF → `JrError::Interrupted` (exit 130). `dialoguer::interact_on` is UNUSABLE here (`_interact_on` returns `Err(NotConnected)` when the passed `Term` is not a tty, i.e. piped stderr, BEFORE reading any input; empirically proven in F4 — the previous claim that "dialoguer still reads input from stdin" via `interact_on(&Term::stderr())` is FALSE (DEC-174)); the seam gates ONLY the src/main.rs auto-`--no-input` flip; the F4 story MUST prove the seam+prompt combination works in a wiremock subprocess test before relying on VP-577-013. (Duplicated at BC-3.5.003 delivery obligation.)

**EC-3.5.006-1** (JSDCLOUD-6050 caveat): When `--internal` is passed, emit a stderr hint before the PUT is sent: `"note: visibility change is best-effort on JSM projects — verify in the portal (JSDCLOUD-6050); no-op on non-JSM projects."` This hint is informational; it does NOT affect exit code and is not suppressed by `--no-input`. **Timing cross-note**: fires after ADF conversion succeeds (step 4 in BC-3.5.005 edit pipeline ordering pin), before HTTP PUT (step 5); does not fire if step 4 fails.

**EC-3.5.006-2** (Non-JSM behavior): On a non-JSM issue, the `sd.public.comment` property is sent verbatim in the PUT body; Jira silently ignores it (mirrors BC-3.5.001 behavior). The JSDCLOUD-6050 hint from EC-3.5.006-1 still fires (`jr` does not detect JSM vs non-JSM at write time; the hint is informational and harmless on non-JSM projects). No additional non-JSM-specific warning is emitted.

**Verification Properties**:

**VP-577-002**: wiremock captures the PUT request body; assert (a) `serde_json::from_str::<serde_json::Value>(&body).unwrap()["properties"][0]["value"]["internal"]` equals `true` (JSON boolean, not string); AND (b) the body does NOT contain the key `"visibility"` at the top level — `…unwrap().get("visibility").is_none()` must be `true`; AND (c) the parsed PUT body's top-level key set equals exactly `{"body","properties"}` — `…as_object().unwrap().keys().map(|k| k.as_str()).collect::<std::collections::BTreeSet<_>>() == std::collections::BTreeSet::from(["body","properties"])` must be `true`. The visibility absence assertion (b) is the `--internal` case of the BC-3.5.005 note-(iii) invariant: `jr` NEVER sends a `visibility` key on any `comment edit` path this cycle. AND (d) `parsed["properties"].as_array().unwrap().len() == 1 && parsed["properties"][0]["key"] == "sd.public.comment"` must be `true` (pins the exact property key name and single-element array cardinality; a key-name typo such as `sd_public_comment` or a stray second array entry would pass assertions (a)–(c) while the JSM visibility change silently no-ops server-side — Jira ignores unknown property keys).

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 1; research verdict Claim 7 PARTIALLY VALIDATED; adversary pass-3 HIGH-3 + MEDIUM-1 remediation; HIGH-3 closure: MERGE verdict human-approved 2026-07-09, probe deferred to gated e2e; adversary pass-8 M1 VP-577-002 visibility-absence; adversary pass-11 F1 Term::stderr() + F4 compound-cell Scenario-3; adversary pass-32 F1 stale jsm_self_close clause replaced + F3 sequencing constraint added; adversary pass-41 F-01 VP-577-002 extended (d) properties key-name + array-len pin; issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.007: `comment edit --public` explicitly sends `properties:[{"key":"sd.public.comment","value":{"internal":false}}]`; always requires confirmation

**Confidence**: MEDIUM-HIGH
**Source**: `src/api/jira/issues.rs::update_comment`; `src/cli/issue/interactions.rs::handle_comment_edit`; tests `tests/comment_edit.rs`
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
**Source**: `src/cli/issue/interactions.rs::handle_comment_edit`; tests `tests/comment_edit.rs`
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

**EC-3.5.008-5** [GAP-R15-001 terminology sync 2026-07-16 — DEC-174 mechanism; behavior unchanged] (EOF / IO-error on `--public` prompt → `JrError::Interrupted`, exit 130): When the `comment edit --public` confirmation prompt reads via `io::stdin().lock().read_line()`, the return value `Ok(0)` (zero bytes, EOF — Ctrl+D) or any `Err(_)` (IO error, Ctrl+C interrupt) MUST propagate as `JrError::Interrupted`; exit 130. These MUST NOT be silently swallowed or mapped to the cancel path (exit 0). `Ok(0)` (EOF) is distinguishable from empty-Enter (`Ok(n)`, n ≥ 1, buffer `"\n"`) — the distinction is real and load-bearing. This mirrors EC-3.5.003-3 (delete prompt), ensuring consistent EOF / interrupt handling across all interactive confirmation prompts in the comment family.

**Verification Properties**:

**VP-577-006**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --public --no-input` → exit 64; assert no HTTP PUT was sent (wiremock `.expect(0)` on the PUT route); stderr contains BOTH `"visibility to public"` AND `"--yes"` (the non-interactive BC-3.5.008 item-1 gate message — confirms exit 64 originates from the step-3 `--public` gate, NOT the step-2 body gate). **Setup note**: a non-empty body (`"Updated text"`) is REQUIRED — a bodyless invocation exits 64 at step-2 (BC-3.5.009 body-required rule, `"body is required — use --file, --stdin, or pass text as a positional argument."`) BEFORE the security-critical `--public` non-interactive gate is ever reached, producing a false-passing test while the gate regresses silently. Mirror of VP-577-017's setup-note pattern.

**VP-577-017**: `--public --stdin` without `--yes` → exit 64; stderr contains BOTH `"--stdin"` AND `"--yes"` (the targeted EC-3.5.008-3 message); wiremock `.expect(0)` on the PUT route — zero PUT calls. **Second variant (prescriptive-rule pin)**: same invocation with `JR_STDIN_IS_TTY=1` set (seam active, auto-flip suppressed) → STILL exit 64; same stderr assertions; zero PUT calls. This variant proves the `--stdin` flag-based branch fires independently of TTY-detection state, per the EC-3.5.008-3 normative rule. **Setup note**: the stdin pipe fed to `--stdin` MUST contain a NON-EMPTY body (e.g., `echo "Updated text" | jr issue comment edit …`) so the step-2 empty-body check (EC-3.5.009-5) passes; the EC-3.5.008-3 targeted message is emitted at the step-3 `--public` gate, not as a handler-start short-circuit. An empty-stdin + `--public --stdin` without `--yes` correctly exits 64 on EC-3.5.009-5 with `"comment body cannot be empty."` (correct behavior per BC-3.5.005 pipeline, but that exit path does NOT produce the `"--stdin"` / `"--yes"` substrings — out of scope for this VP).

**VP-577-028**: EC-3.5.008-4 `--yes` silent-no-op pin [human-ratified 2026-07-11]: `jr issue comment edit FOO-1 --id 10001 "text" --yes` (WITHOUT `--public`) against a wiremock returning PUT 200 → exit 0; wiremock receives exactly one PUT hit (the `--yes` flag does NOT suppress the edit operation); stderr does NOT contain any error substring relating to `"--yes"` being unexpected or invalid. **Second variant (runtime clap-requires probe)**: `jr issue comment edit FOO-1 --id 10001 "" --yes` (empty-string positional body, WITHOUT `--public`) → exit 64; stderr contains `"comment body cannot be empty"` (EC-3.5.009-5 empty-body path, handler-level); exit code is 64, NOT 2 (which would indicate clap's `MissingRequiredArgument` or `requires("public")` fired at parse time). Rationale: the `"comment body cannot be empty"` exit-64 path is only reachable if the handler was entered — meaning clap accepted `--yes` without `--public`, proving `requires("public")` was not applied. Wiremock mounts PUT (uncalled — body check fires before HTTP). (Added adversary pass-35 F-A4; second variant reformulated adversary pass-36 F-1.)

**VP-577-029**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --public --output json` in interactive mode (`JR_STDIN_IS_TTY=1`); user selects N (cancel) → exit 0; stdout parses as JSON with top-level keys == `BTreeSet::from(["cancelled", "updated"])` (exact key-set); `cancelled` equals `true`; `updated` equals `false`; no HTTP PUT sent (wiremock `.expect(0)` on the PUT route). Mirrors VP-577-013 pattern for `comment delete` cancel JSON envelope. **Seam note**: set `JR_STDIN_IS_TTY=1` to force TTY-mode in debug builds (BC-3.5.006 delivery obligation § JR_STDIN_IS_TTY).

**VP-577-030**: EOF / interrupt propagation on interactive confirmation prompts (EC-3.5.003-3 and EC-3.5.008-5 delivery) — two variants:
- **(1) Delete prompt EOF**: `jr issue comment delete FOO-1 --id 10001` in interactive mode (`JR_STDIN_IS_TTY=1`) with stdin fed EOF → exit 130 (`JrError::Interrupted`); no HTTP DELETE sent (wiremock `.expect(0)`).
- **(2) `--public` prompt EOF**: `jr issue comment edit FOO-1 --id 10001 "Updated text" --public` in interactive mode (`JR_STDIN_IS_TTY=1`) with stdin fed EOF → exit 130 (`JrError::Interrupted`); no HTTP PUT sent (wiremock `.expect(0)`).
Both variants: the ratified mechanism MUST be used unconditionally (all builds; BC-3.5.006 delivery obligation — DEC-174: `eprint!` prompt to stderr + `io::stdin().lock().read_line()`; `dialoguer::interact_on` is UNUSABLE on piped stderr, returns `Err(NotConnected)` before reading any input); `io::Error` or EOF MUST propagate as `JrError::Interrupted`, NOT silently swallowed or mapped to the cancel path (exit 0).

**Trace**: F2 spec evolution (2026-07-09, DEC-168 open design point Option a; adversary pass-2 MEDIUM-1 + LOW-2 remediation; adversary pass-5 L1 VP-577-017; adversary pass-9 F1 EC-3.5.008-3 prescriptive + VP-577-017 second-variant; adversary pass-35 F-A4 EC-3.5.008-4 --yes silent-no-op (orchestrator ruling) + VP-577-028; F-A5 EC-3.5.008-5 dialoguer Err → JrError::Interrupted; adversary pass-36 F-1 VP-577-028 second variant reformulated (runtime clap-requires probe); adversary pass-38 R-1 EC-3.5.008-4 + VP-577-028 human-ratified 2026-07-11 (gate language removed); adversary pass-39 F2 VP-577-029 (interactive cancel JSON key-set mirrors VP-577-013); F3 VP-577-030 (EOF/interrupt exit 130 two variants); adversary pass-44 F-1 VP-577-006 extended (non-empty body + setup note; stderr substrings pin --public gate not body gate); adversary pass-45 F-1 VP-577-006 setup-note gate mis-cite corrected (bodyless invocation fires BC-3.5.009 body-required rule not EC-3.5.009-5; verbatim message updated); GAP-R15-001 EC-3.5.008-5 terminology sync 2026-07-16 (dialoguer→read_line Ok(0)/Err; behavior unchanged); issue #577 SOH-COMMENT-CRUD-1)

---

#### BC-3.5.009: `comment edit` body source flags — `--file`, `--stdin`, positional text, `--markdown`

**Confidence**: HIGH
**Source**: `src/cli/issue/interactions.rs::handle_comment_edit`; `src/adf.rs::markdown_to_adf`; `src/adf.rs::text_to_adf`; tests `tests/comment_edit.rs`
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
**Source**: `src/api/jira/issues.rs::get_comment`; `src/cli/issue/interactions.rs::handle_comment_view`; tests `tests/comment_view.rs`
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
**Source**: `src/cli/mod.rs` (`IssueCommand::Comment(CommentSubcommand)`); `src/cli/issue/mod.rs` (dispatch); `src/cli/issue/interactions.rs::handle_comment_add`
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

(h) `docs/specs/json-output-shapes.md`: the canonical JSON-shape registry MUST gain rows for all four comment-CRUD `--output json` shapes in the same PR as the CLI refactor — comment add: the CURRENT full `Comment`-struct serialization (`{id, body, author, created, properties}`; no `key` field; MUST remain byte-identical to pre-refactor behavior per EC-3.5.012-2), registered as-is with a note that it predates the BC-pinned key-set convention; comment delete `{"deleted","id","key"}` (BC-3.5.002); comment edit `{"changed_fields","id","key","updated"}` (BC-3.5.005); comment view (full Comment JSON passthrough per BC-3.5.010). VP-577-009/023 BTreeSet pins are the source of truth for the delete/edit rows. (added at F2 gate closure per DEC-170 consistency-audit ruling, 2026-07-11)

(i) `docs/specs/comment-crud.md`: a product-facing feature spec MUST be created in the same PR as the CLI refactor, following the `docs/specs/issue-move-resolution.md` precedent (ADR-0004). Minimum content: the old→new CLI form table (flat `jr issue comment` → `comment add/delete/edit/view` subgroup, DEC-168 Option A clean break + migration hint), the `--public` confirmation gate + `--yes` semantics (DEC-169), the body-only-PUT preservation guarantee (MERGE/PRESERVED research verdicts + deferred EJ probe), allow_hyphen_values remapping (item g), and the interactions.rs shard pointer (PF-017). (added at F2 gate closure per DEC-170 consistency-audit ruling, 2026-07-11)

**CHANGELOG requirement**: A "Breaking Changes" entry documenting the rename from `jr issue comment` to `jr issue comment add` is REQUIRED in the same PR as the CLI surface refactor (story S-577-1). Minimum version bump: next minor boundary per project convention (e.g., 0.6.x → 0.7.0).

**Verification Properties**:

**VP-577-008**: `jr issue comment FOO-1 "some text"` (old flat form, InvalidSubcommand) → exit 2; stderr contains the exact substring `"use \`jr issue comment add\` instead"` (load-bearing marker text). Parse-level test (wiremock-free; no network call made).

**VP-577-014**: `jr issue comment` (bare, no subcommand, MissingSubcommand) → exit 2; stderr contains clap's subcommand listing (names `add`, `delete`, `edit`, `view`); stderr does NOT contain the prefix `"use \`jr issue comment"` (the shared marker prefix — confirms no custom InvalidSubcommand hint was injected on the MissingSubcommand path). Parse-level test (wiremock-free).

**VP-577-015**: `jr issue comment list FOO-1` (list token, InvalidSubcommand) → exit 2; stderr contains `"jr issue comments"` (the plural form hint). Parse-level test (wiremock-free; no network call made).

**VP-577-018**: `jr issue comment add FOO-1 "- [ ] task"` → parses without clap error (exit code is NOT 2); the leading-dash body text is accepted as a positional argument. Parse-level test (wiremock-free; no network call required — the test need not exercise the HTTP path; formalizes EC-3.5.012-3's `allow_hyphen_values` regression pin for the add path).

**VP-577-019**: `jr issue comment edit FOO-1 --id 10001 "- update"` → parses without clap error (exit code is NOT 2); the leading-dash positional `<text>` is accepted without being treated as an unknown flag. Parse-level test (wiremock-free; formalizes EC-3.5.012-3's `allow_hyphen_values` regression pin for the edit path).

**VP-577-020**: `jr issue comment ls FOO-1` (`ls` alias token, `InvalidSubcommand`) → exit 2; stderr contains `"jr issue comments"` (the plural-form hint directing to `IssueCommand::Comments`). Parse-level test (wiremock-free; no network call made). Mirrors VP-577-015 (`list` token); confirms the EC-3.5.012-1 two-sub-case discrimination covers both the `list` and `ls` alias tokens. **Mixed-case variant:** `jr issue comment LS FOO-1` → exit 2; stderr contains `"jr issue comments"` (pins the EC-3.5.012-1 pass-24 F3 `eq_ignore_ascii_case` rule — `LS`, `List`, `LIST` all route to the plural hint).

**Trace**: F2 spec evolution (2026-07-09, DEC-168 ruling 2 Option A; adversary pass-1 HIGH-1 + LOW-1; adversary pass-2 MEDIUM-2 + LOW-3 + MEDIUM-4 remediation; adversary pass-3 HIGH-2 + MEDIUM-4 + LOW-4 remediation; adversary pass-5 L2 VP-577-018; adversary pass-7 F3 VP-577-019; adversary pass-8 L3 VP-577-020; adversary pass-25 VP-577-020 mixed-case variant; adversary pass-32 F4 BC-3.4.011 removed from EC-3.5.012-5 item (a); adversary pass-35 F-A1 EC-3.5.012-5 items (f)+(g) README+CLAUDE.md migration obligations; adversary pass-37 F-01 Edit subcommand-to-BC map corrected (BC-3.5.010 removed from Edit range); F2 gate closure DEC-170 (2026-07-11) EC-3.5.012-5 items (h)+(i) added — json-output-shapes.md registry rows + comment-crud.md feature spec delivery obligations; issue #577 SOH-COMMENT-CRUD-1)

---

### 3.6 Links

#### BC-3.6.001: `issue link <k1> <k2> [--type T]` POSTs `/rest/api/3/issueLink`; default type "Relates"

**Confidence**: HIGH
**Source**: `src/api/jira/links.rs::tests`; `tests/issue_commands.rs:~233`
**Trace**: Pass 3 BC-216; BC-1045 (R4)

---

#### BC-3.6.002: `issue link FOO-1 FOO-2 --type block` single-substring → exit 64 + `"Ambiguous link type"` + ZERO POST

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1812`
**Trace**: Pass 3 BC-1080 (R4)

---

#### BC-3.6.003: `issue unlink FOO-1 FOO-2 --type block` single-substring → exit 64 + ZERO DELETE

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~1869`
**Trace**: Pass 3 BC-1081 (R4)

---

#### BC-3.6.004: `client.delete_issue_link("10001")` DELETEs `/rest/api/3/issueLink/10001`; accepts 204

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~250`
**Trace**: Pass 3 BC-1046 (R4)

---

#### BC-3.6.005: `client.list_link_types()` returns 3 link types from `/rest/api/3/issueLinkType`

**Confidence**: HIGH
**Source**: `tests/issue_commands.rs:~188`
**Trace**: Pass 3 BC-218; BC-1043 (R4)

---

### 3.7 Remote Links

#### BC-3.7.001: `issue remote-link <key> --url X` POSTs `/issue/<key>/remotelink`; URL gains trailing slash from `url::Url::parse` normalization

**Confidence**: HIGH
**Source**: `tests/issue_remote_link.rs:~19`
**Behavior**: Body partial-JSON: `{object: {url: "https://example.com/", title: "Example"}}`. Trailing slash on URL. Output JSON: `{key, id, url, title, self}` (5 keys, normalized URL).
**Trace**: Pass 3 BC-222; BC-1126 (R4)

---

#### BC-3.7.002: `issue remote-link` defaults `--title` to URL when omitted

**Confidence**: HIGH
**Source**: `tests/issue_remote_link.rs:~87`
**Trace**: Pass 3 BC-223; BC-1127 (R4)

---

#### BC-3.7.003: `issue remote-link --url not-a-url` → exit 64 + `"--url"` + `"not a valid url"`; ZERO HTTP

**Confidence**: HIGH
**Source**: `tests/issue_remote_link.rs:~259`
**Behavior**: Pre-HTTP URL validation.
**Trace**: Pass 3 BC-1130 (R4)

---

#### BC-3.7.004: `issue remote-link --url ftp://example.com` → exit 64 + `"http or https"` + `"ftp"`

**Confidence**: HIGH
**Source**: `tests/issue_remote_link.rs:~309`
**Behavior**: Scheme allowlist: only `http` and `https` accepted; all other schemes (e.g., `ftp`) rejected. Any URL whose scheme is not `http` or `https` triggers exit 64 with stderr containing `"http or https"` and the rejected scheme name.
**Trace**: Pass 3 BC-1131 (R4)

---

### 3.8 JSM Request Create + Platform-Path Pre-flight Guards + Auth-Conditional 401 Hints

17 behavioral contracts covering: (a) `jr issue create --request-type` dispatch to the JSM service desk API
(BC-3.8.001..009), (b) forward-direction cross-flag warnings when platform-only flags are passed alongside
`--request-type` (BC-3.8.010..011), (c) pre-flight exit-64 guard (`JrError::UserError`, DEC-188) when
`--on-behalf-of` is passed on the platform path without `--request-type` (BC-3.8.013) — `--field` alone
no longer exits 64 [reversed 2026-08-25 issue #578 DEC-310: `--field` no longer exits 64 — resolves via
createmeta per BC-3.3.010/BC-3.8.012], (d) auth-conditional 401 error hints on the JSM POST
path: Basic-auth API-token-expiry hint (BC-3.8.014) and OAuth write-scope hint (BC-3.8.015), gated solely
by `JiraClient::is_oauth_auth()`, and (e) JSM-path input guards: empty `--request-type` early-exit
(BC-3.8.016) and `--markdown` + `--field description=` conflict rejection (BC-3.8.017).
BCs 002..011 and 014..017 (JSM-path contracts) require `--request-type` to be set; BC-3.8.001 governs the absent-`--request-type` (platform-path) case — post-DEC-188 this includes the exit-64 pre-flight guard when `--on-behalf-of` is also present (BC-3.8.013) [reversed 2026-08-25 issue #578 DEC-310: `--field` no longer exits 64 — resolves via createmeta per BC-3.3.010/BC-3.8.012]. The platform path (BC-3.3.001) — its POST body,
JSON response, and exit code — is unchanged when `--request-type` is absent AND `--on-behalf-of`
is absent. **[AMENDED 2026-07-25 DEC-188, reversed in part 2026-08-25 issue #578 DEC-310]** BC-3.8.013 was amended from warn-and-proceed
(exit 0) to pre-flight `JrError::UserError` (exit 64): when `--on-behalf-of` is
passed without `--request-type`, the guard fires BEFORE any HTTP, BEFORE interactive prompts, and
BEFORE helper resolution calls (`resolve_team_field`, `resolve_assignee_by_project`). BC-3.8.012's `--field`-alone exit-64 guard was reversed 2026-08-25 issue #578 DEC-310 — `--field` no longer exits 64 and instead resolves via createmeta per BC-3.3.010/BC-3.8.012.

---

#### BC-3.8.001: `issue create --request-type <NAME|ID>` dispatches to `POST /rest/servicedeskapi/request`; platform POST body, JSON response, and exit code unchanged when `--request-type` absent (unless `--on-behalf-of` present — exits 64 per BC-3.8.013; `--field` no longer exits 64 — reversed 2026-08-25 issue #578 DEC-310: resolves via createmeta per BC-3.3.010/BC-3.8.012)

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

> **[AMENDED 2026-07-25 DEC-188, reversed in part 2026-08-25 issue #578 DEC-310]** The Behavior field states "exit code unchanged when `--request-type` is absent." This holds only when `--on-behalf-of` is absent. When `--on-behalf-of` is present without `--request-type`, exit 64 fires (BC-3.8.013) — the platform POST is not reached and the exit code is 64, not 0. `--field` no longer exits 64 [reversed 2026-08-25 issue #578 DEC-310: `--field` no longer exits 64 — resolves via createmeta per BC-3.3.010/BC-3.8.012] — BC-3.8.012's `--field`-alone guard was removed; the platform path resolves `--field` via createmeta as normal (BC-3.3.010).

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
**Errors**: Missing `=` in `--field` value → exit 64 "invalid field format: expected NAME=VALUE". **[AMENDED 2026-08-25 issue #578 F2]** Because this BC now shares `parse_field_kv` with the platform-path call sites (see the Hint-kind uniformity amendment below), BC-3.4.031's malformed-hint exit-64 catalog (unknown `:kind` tag, malformed `NAME:kind=VALUE` shapes) applies identically on this JSM path — a malformed hint on `--field` fails the SAME way regardless of whether `--request-type` is set. This BC's own Errors line above (missing `=`) is the pre-existing, still-independent bare-form error; BC-3.4.031 governs the hint-syntax-specific malformed cases layered on top by the shared parser.

**D2 collision guard does NOT apply on this (JSM) path — this BC's "duplicate NAME → last wins" behavior is UNCHANGED and retained [ADDED 2026-08-26, F2 adversary-convergence round-4, MED-1/F-3]**: ADR-0019 § Amendment (2026-08-26) D2 extends Gate B's dedicated-flag × `--field` overlap guard to `jr issue create`'s PLATFORM (non-JSM) path only (BC-3.3.010 Invariant 5 / BC-3.3.011). It is deliberately NOT extended to this JSM create path — a dedicated-flag × `--field` collision on `--request-type` create (e.g. `--priority X --field priority=Y` alongside `--request-type RT`) still resolves via this BC's own pre-existing last-wins/duplicate-NAME semantics, exactly as documented in this BC's header and Behavior paragraph above. Rationale: JSM's dedicated-flag semantics already diverge from the platform path (several dedicated flags — `--team`, `--points`, `--parent`, `--to`, `--account-id`, `--type` — are silently IGNORED on the JSM path per BC-3.8.010/BC-3.8.011, not merged onto the wire at all), so a platform-shaped "same wire key, two sources" collision does not arise the same way for those flags; whether the same D2 exit-64 treatment should additionally apply to the JSM flags that ARE merged onto the wire (`--summary`, `--description`, `--priority`, `--label` per this BC's own Behavior paragraph) is an open scope question this round explicitly DEFERS, not decides. Extending D2 to the JSM path is flagged as a decision for the F2 human gate, not resolved here.
**Trace**: `tests/issue_create_jsm.rs` (field mapping, first-equals split, duplicate-key, empty-value); body shape assertions; BC-3.4.031 (shared malformed-hint exit-64 catalog, applies on this path per the amendment above)
**Source**: Consistent with `--field` conventions; split-on-first-equals is standard CLI convention
**Confidence**: HIGH

**[AMENDED 2026-08-25 issue #578 F2] Hint-kind uniformity**: `--field`'s value-kind hint syntax
(`NAME:option=`/`NAME:id=`/`NAME:name=`/`NAME:asset=`, BC-3.4.026-031) applies UNIFORMLY on the
JSM create path — the same shared `parse_field_kv` parser (BC-3.4.026) produces the same
`HashMap<String, FieldValueSpec>` regardless of call site (resolves the F1 research/BA open
question on whether hint syntax is edit-path-only: it is NOT, it applies wherever `--field` is
accepted). Wire-target substitution: on this (JSM) path, resolved values are inserted into
`requestFieldValues` (this BC's existing target), NOT `fields` (the platform-path target used by
BC-3.3.010/BC-3.4.015-016) — `JsmRequestBuilder::build()` (`src/api/jsm/requests.rs`) gains
kind-aware dispatch on `extra_fields`, replacing the current unconditional string-wrap
(`rfv.insert(k.clone(), serde_json::Value::String(v.clone()))`) with a `FieldValueSpec`-driven
match: `kind: None` (bare) → UNCHANGED string-wrap (this BC's existing Behavior, byte-for-byte
preserved — see Verification Property below); `Some(Option)` → `{"value": ...}` (non-cascading;
**[CAVEAT, adversary pass-6 F3, EXTENDED adversary pass-16 MEDIUM-2]: the `:id`/`:name`/`:asset`
`requestFieldValues` shapes described below (`{"id": ...}` / `{"name": ...}` /
`[{"workspaceId","id","objectId"}]`), and NOT ONLY the non-cascading `:option`
`{"value": ...}` shape, are ALL UNVERIFIED against live JSM.** Research CONFIRMed only the
platform-path `fields` wire contract for these kinds (`.factory/research/field-dx-feasibility-2026-08-25.md`
claim 5, standard Jira Cloud custom-field contract) — it never verified the `requestFieldValues`
wire shape specifically for ANY of the four kinds, `:option` included. Every one of `:id`/`:name`/
`:asset` on `requestFieldValues` is asserted here by analogy to the platform-path shape, not by
verification. `:asset` in particular is at least as likely to diverge as `:option` — Assets
attribute payloads are the least standardized of the four across Atlassian's JSM vs platform
surfaces. Do not read `:id`/`:name`/`:asset` as settled fact merely because this earlier caveat
named only `:option`; the earlier, narrower phrasing (see the pre-pass-16 wording preserved
below for audit trail) understated the scope of what is unverified.
**[Pre-pass-16 wording, superseded, retained for audit trail]:** "this non-cascading
`{"value": ...}` shape for JSM's `requestFieldValues` is UNVERIFIED against live JSM — only the
platform-path `fields` wire contract for single-select `option` fields was CONFIRMed by
research... it is asserted here by analogy, not by verification, and carries the same
unverified status as the cascading shape below rather than being stated as settled fact."
Cascading composition per BC-3.4.027 is NOT
extended to the JSM path this cycle — JSM's `requestFieldValues` cascading wire shape is
likewise unverified and out of scope, flagged as an open design question in
`prd-delta-field-dx.md`); `Some(Id)` → `{"id": ...}` **(UNVERIFIED, see caveat above)**;
`Some(Name)` → `{"name": ...}` **(UNVERIFIED, see caveat above)**;
`Some(Asset)` → **[CORRECTED, adversary pass-9 M-2]** `build()` performs PURE array-WRAPPING
only — it receives an ALREADY-RESOLVED value (either the fully composed
`[{"workspaceId","id","objectId"}]` array, or a pre-qualified `WORKSPACE:OBJECTID` pair with
`workspaceId` never absent) and performs no Assets I/O of its own. `build()` cannot reach
`get_or_fetch_workspace_id`: per ADR-0019 §2 and the architecture delta, `build()` is not a new
I/O boundary, and the L4 Assets cache/API sits behind a boundary `build()` (SS-05/L4) is forbidden
from crossing (no L4→L4 edge). Workspace-id resolution is therefore owned by the L2 handler that
calls `build()` — `handle_jsm_create` (`src/cli/issue/jsm_create.rs`) on this (JSM) path, mirroring
`edit.rs`/`create.rs` on the platform path (BC-3.4.030) — which resolves the cached/fetched
workspace id via `get_or_fetch_workspace_id` BEFORE constructing the `FieldValueSpec::Asset` value
handed to `build()`. This is where the bare-vs-explicit `:asset` forms diverge: the EXPLICIT
`WORKSPACE:OBJECTID` form (a `:` present in the hint value, BC-3.4.030 rule 2) needs no cache
lookup at all — the L2 handler composes the array directly from the two supplied segments, and
`build()`'s wrapping is the only step involved; the BARE `<objectId>` form (no `:` present,
BC-3.4.030 rule 2 / EC-3.4.030-1) requires the L2 handler to call `get_or_fetch_workspace_id`
FIRST to obtain `workspaceId` before the array can be composed — `build()` never sees a bare
`:asset` value, only the L2-resolved, fully-composed result. BC-3.4.030's "the composer function
is shared, not duplicated, across the platform and JSM paths" therefore refers ONLY to this pure
array-wrapping half; the workspace-id resolution step is NOT shared code reachable from inside
`build()` — it runs, once per invocation, in each path's own L2 handler, consistent with the
existing per-path "`get_or_fetch_workspace_id` called at most once" invariant (BC-3.4.030
Postconditions). The `customfield_NNNNN` bypass, first-`=`-split, empty-value-allowed, and
duplicate-NAME-last-wins behaviors above are UNCHANGED for both bare and hinted pairs.

**Edge Cases**:
- EC-3.8.008-1 **[ADDED 2026-08-26, F2 adversary-convergence round-3, O-1]**: cascading `>` on the JSM `:option` path — `--request-type <RT> --field cf:option=Parent>Child`. There is NO `>`-split site anywhere in the JSM dispatch (`JsmRequestBuilder::build()` / `handle_jsm_create`): BC-3.4.027's cascading-select composition is explicitly NOT extended to JSM this cycle (see the "Cascading composition per BC-3.4.027 is NOT extended to the JSM path this cycle" note above), and `parse_field_kv` itself never performs the `>` split either (that split lives at the platform-path call sites, per ADR-0019 § Amendment D3 — see BC-3.4.027's "Multibyte-safety MUST on the `>` split" paragraph, which scopes D3's obligation to `field_resolve.rs`/`create.rs` only). Consequence: `Parent>Child` is treated as an OPAQUE literal string and wrapped verbatim by the `Some(Option)` non-cascading dispatch arm → `{"cf": {"value": "Parent>Child"}}` on `requestFieldValues` — the entire `"Parent>Child"` substring, `>` included, becomes the `value`. This is almost certainly NOT what the caller intended (a genuine cascading-select field expects a resolved child selection, not a literal string containing `>`); the best-case outcome is a server-side 400 (value does not match any `validValues[].value`) or a silent no-match depending on the specific request-type field's validation strictness — `jr` does not client-side detect or reject this shape. **Cascading selects are explicitly NOT supported on the JSM path this cycle** — a caller needing cascading-select resolution on a JSM request type has no `jr`-side workaround this cycle beyond hand-authoring the correct `{"value":"<parent>","child":{"value":"<child>"}}` shape via the raw underlying field id if the CLI surface permitted arbitrary JSON (it does not, today). This limitation is tracked as an open design question in `prd-delta-field-dx.md`, not a defect requiring a fix this cycle.
- EC-3.8.008-2 **[ADDED 2026-08-26, F2 adversary-convergence round-3, O-2]**: a hinted `--field cf:option` with NO `=` at all (e.g. `--field cf:option`) is NOT a hint-parse case — `parse_field_kv`'s step 1 (BC-3.4.026, split on the first `=`) fails to find any `=` in the argument at all, so the pair never reaches step 2's `:kind` extraction. This resolves to the SAME pre-existing "missing `=`" exit-64 this BC's own Errors line documents (`"invalid field format: expected NAME=VALUE"`) — NOT a hint-syntax parse error, and NOT BC-3.4.031's unknown-kind/malformed-hint catalog (that catalog only ever fires once a `=` has been located and the pre-`=` portion is being inspected for a `:kind` suffix). This applies identically on the platform path (BC-3.4.026/031) — a bare `cf:option` with no `=` anywhere hits the same missing-`=` guard before hint parsing is ever attempted, regardless of call site.

**Verification Properties**:
- VP-578-015: A bare (unhinted) `--field NAME=VALUE` on the JSM create path produces BYTE-IDENTICAL `requestFieldValues` wire output before and after this amendment — the kind-aware dispatch is purely additive for `kind: None`. Regression pin against `tests/issue_create_jsm.rs`'s existing `--field` wire-shape assertions (BC-3.8.005..007's `summary`/`description`/`priority`/`labels` keys, which sit in the same `rfv` map, are UNTOUCHED by this amendment).
- VP-578-016: **[DOWNGRADED, adversary pass-16 MEDIUM-2 — was stated as a firm parity guarantee, now UNVERIFIED / parity-pending, matching VP-578-008's former-PROVISIONAL discipline and the `:option` caveat above]** `:id`/`:name`/`:asset` hints on the JSM path are ASSERTED (by analogy to the platform-path shapes, BC-3.4.028/029/030) to produce parallel wire shapes on `requestFieldValues` instead of `fields` — this parity is NOT research-confirmed for any of the three kinds (see BC-3.8.008 amendment's extended caveat, immediately above). Treat this VP as parity-pending until F4/live-JSM validation runs; do not read it as a settled guarantee the way VP-578-015 (bare-form byte-identity, independently regression-pinnable against existing tests) is. **[Pre-pass-16 wording, superseded, retained for audit trail]:** "`:id`/`:name`/`:asset` hints on the JSM path produce the same wire shapes as their platform-path counterparts (BC-3.4.028/029/030), targeting `requestFieldValues` instead of `fields`."

**Trace (amendment)**: issue #578 item 1; BC-3.4.026-030 (shared parser + hint semantics); `src/api/jsm/requests.rs::JsmRequestBuilder::build`

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

#### Platform-Path Guard Ordering — `handle_create` (platform path only)

**SINGLE SOURCE OF TRUTH** for the guard-relevant ordering (authoritative for step numbering) in `handle_create` (platform branch). BC-3.8.013 (live step-2 guard), `parse_field_kv` (live step-2a parse pass, BC-3.4.026/031 — **[ADDED 2026-08-26, F2 adversary-convergence round-3, F-MED-1]**, see below), the D2 create-path collision guard (live step-2b guard, ADR-0019 § Amendment (2026-08-26) D2; see BC-3.3.010 Invariant 5 / BC-3.3.011), and BC-3.8.012 (step-2 `--field` guard REMOVED per the 2026-08-25 DEC-310 reversal; references this block for removal/historical context) reference this block rather than embedding copies. When changing any step, update ONLY this block.

Short guard-ordering reference for `src/cli/issue/create.rs::handle_create` when `--request-type` is absent. There are THREE pre-HTTP exit-64 paths ahead of project-key resolution, in this pinned deterministic order: the BC-3.8.013 `--on-behalf-of` pre-flight guard fires at **step 2**, immediately after the dispatch fork; `parse_field_kv`'s own malformed-hint exit-64 (BC-3.4.031) fires at **step 2a**, immediately after step 2; the D2 dedicated-flag × `--field` collision guard fires at **step 2b**, immediately after step 2a. All three run **before** project-key resolution:

1. **JSM dispatch fork** — `request_type.is_some()` check. If `true`, dispatches to `handle_jsm_create`; steps 2–7 below apply only on the platform (`false`) branch.
2. **BC-3.8.013 pre-flight guard** — `--on-behalf-of` present → `JrError::UserError` exit 64. Zero HTTP. No interactive prompts. No project-key resolution has run yet. (`--field` no longer triggers this guard — see BC-3.8.012's 2026-08-25 reversal; a bare `--field` now falls through to steps 2a/2b and 3–6 and resolves via `createmeta`, per BC-3.3.010.) This guard is PRESENCE-ONLY — it inspects only whether `--on-behalf-of` was supplied, never `--field`'s parsed content, so it has no dependency on step 2a having run.
2a. **[ADDED 2026-08-26, F2 adversary-convergence round-3, F-MED-1]** **`parse_field_kv` hint-syntax parse pass** (BC-3.4.026, malformed-hint exit-64 catalog BC-3.4.031) — every `--field NAME[:kind]=VALUE` occurrence present on the invocation is parsed into the `HashMap<String, FieldValueSpec>` the D2 collision guard (step 2b) and all downstream field resolution (step 4b) consume. A malformed hint (unknown `:kind` tag, malformed `:asset` shape, empty `:kind` segment, etc. — BC-3.4.031 EC-1..7) → `JrError::UserError` exit 64 BEFORE step 2b runs (step 2b cannot evaluate an overlap over a `HashMap` that failed to parse) and BEFORE project-key resolution. Zero HTTP. No interactive prompts. Absent `--field`, this step is a no-op (empty map) and step 2b trivially finds no overlap to reject. **Why this step MUST run before step 2b (structural, not merely ordering-preference):** the D2 collision guard operates on the already-parsed `HashMap<String, FieldValueSpec>` (ADR-0019 § Amendment D2's `detect_flag_field_overlap` signature takes the parsed map, not raw `--field` strings) — there is no other point in `handle_create` where that map exists yet, so step 2a is not merely ordered before step 2b by convention, it is a hard data dependency of it.
2b. **[ADDED 2026-08-26, F2 adversary-convergence round-2, Pass2-F5; renumbered 2026-08-26, F2 adversary-convergence round-3, F-MED-1 — was step 2a, now step 2b to make room for the newly-numbered `parse_field_kv` step 2a above]** **D2 create-path collision guard** (`field_resolve::detect_flag_field_overlap`, ADR-0019 § Amendment (2026-08-26) D2; BC-3.3.010 Invariant 5 / EC-3.3.010-6; BC-3.3.011 error-taxonomy row) — a dedicated-flag × `--field` wire-key collision (e.g. `--priority X --field priority=Y`, any argv order, any hint kind) → `JrError::UserError` exit 64, overlap error naming the colliding field. Zero HTTP. No interactive prompts. No project-key resolution has run yet. **Deterministic order relative to steps 2 and 2a:** step 2 (BC-3.8.013) is evaluated FIRST (its position is unchanged from its pre-existing, already-tested placement and is presence-only, so it has no dependency on step 2a); step 2a (`parse_field_kv`) SECOND (a hard data-dependency prerequisite of this step, per step 2a's own note above); step 2b (D2) THIRD. Consequence: `jr issue create --priority X --field priority=Y --on-behalf-of Z` (no `--request-type`) — all three guards' trigger conditions are live — surfaces ONLY the BC-3.8.013 `--on-behalf-of` error (step 2); neither `parse_field_kv`'s hint-parse error nor the D2 collision error (step 2b) is reached on this invocation, because step 2's guard short-circuits `handle_create` before step 2a even runs. A caller who then removes `--on-behalf-of` and re-runs deterministically encounters step 2a next (a malformed hint, if any, is reported before the collision guard ever sees the map), and only once the hint parses cleanly does step 2b's collision check run — never a silent flip between the three error messages for the same starting invocation, satisfying the same "fixing one reported error deterministically encounters the next" guarantee BC-X.14.004 states for its own taxonomy-table precedence (`cross-cutting.md` § BC-X.14.004 "Precedence when an invocation matches more than one taxonomy-table condition"), now extended to all THREE pre-HTTP exit-64 paths on this command (step 2, step 2a, step 2b).
3. **Project-key resolution** — derives project key from `--project` or active-profile config; `--no-input`/non-TTY → exit 64 if unresolvable; interactive → `helpers::prompt_input("Project key")` prompt on stderr. This step includes the project-key interactive fallback; step 4 does NOT re-prompt for project key.
4. **Interactive prompts** — type and summary (project-key is step 3, not re-prompted here); description is NOT prompted by `handle_create` (`--description`/`--description-stdin` flags only).
4a. **`--description-stdin` blocking read** — if `--description-stdin` is set, description text is read from stdin via `tokio::task::spawn_blocking` (`src/cli/issue/create.rs::handle_create` ~:132-145). Runs after interactive prompts and before helper HTTP. EC-3.8.012-7 guard fires at step 2, so this step is never reached on the BC-3.8.012/013 guarded path.
4b. **`--field` createmeta field resolution** — per BC-3.3.010: when one or more `--field NAME=VALUE` flags are present (already parsed at step 2a and, if present, passed step 2b's collision check), resolves each via `GET /rest/api/3/issue/createmeta/{project}/issuetypes/{issueTypeId}` (project+issueType-scoped fields endpoint, matching BC-3.3.010 step 3 / ADR-0019 §1 — NOT the bare `.../issuetypes` list endpoint), validates, and merges the resolved value(s) into the create POST body — same machinery as `issue edit --field` (BC-3.4.015/016), source substituted. This is a distinct step from, not a substitute for, the `--field`-triggered `get_issue_types_for_project` name→id lookup described in BC-3.3.010 step 3 (adversary pass-16 LOW-2): that lookup DOES hit the bare `.../issuetypes` list endpoint, once per invocation, to resolve `issueTypeId` before this step's project+issueType-scoped fields fetch runs. The "NOT the bare list endpoint" clause above describes only THIS step's own endpoint choice, not a claim that the list endpoint goes unused on the `--field` create path. Runs AFTER the step-2/2a/2b guards and step-3 project-key resolution (all are hard prerequisites: `createmeta` is scoped to the resolved project, and any of the step-2/2a/2b guards — when triggered — short-circuits before this step is ever reached, per H-NEW-PREFLIGHT-003), and BEFORE the step-6 platform POST. Absent `--field`, this step is a no-op.
5. **Helper HTTP** — `resolve_team_field`, `resolve_assignee_by_project`, `search_assignable_users_by_project`, etc.
6. **Platform POST** — `POST /rest/api/3/issue`.
7. **CMDB field discovery (post-POST, JSON-only)** — `get_or_fetch_cmdb_fields` is called AFTER the POST, inside the `OutputFormat::Json` arm only (`src/cli/issue/create.rs::handle_create`). It is NOT a pre-POST helper HTTP call and is not reached on the guarded path (the handler returns at step 2).

Guard-ordering consequence: `jr issue create --on-behalf-of foo` with no project configured emits the BC-3.8.013 pre-flight error (step 2), NOT a "project key is required" error (step 3) — the dispatch fork (step 1) → pre-flight guard (step 2) → project resolution (step 3) ordering guarantees this precedence. (`jr issue create --field a=b` alone no longer triggers a step-2 guard — post-reversal it proceeds to steps 2a/2b, project-key resolution, and `createmeta` field resolution per BC-3.3.010/BC-3.8.012; the historical `EC-3.8.012-4` example below describes the superseded pre-2026-08-25 behavior.) **[ADDED 2026-08-26, Pass2-F5; extended 2026-08-26, F2 adversary-convergence round-3, F-MED-1]** `jr issue create --priority X --field priority=Y --on-behalf-of Z` with no project configured emits the BC-3.8.013 pre-flight error (step 2) — NOT `parse_field_kv`'s hint-parse error (step 2a), NOT the D2 collision error (step 2b), and NOT a "project key is required" error (step 3) — the dispatch fork (step 1) → step-2 guard → step-2a parse pass → step-2b guard → project resolution (step 3) ordering guarantees step 2 wins whenever the step-2 trigger condition is present alongside either step-2a's or step-2b's. `jr issue create --field cf:bogus=X --priority X --field priority=Y` (no `--on-behalf-of`, no `--request-type`) — a malformed hint AND a would-be collision both present — emits ONLY `parse_field_kv`'s unknown-kind error (step 2a, BC-3.4.031 EC-1); the D2 collision guard (step 2b) never runs, because step 2a's failure short-circuits `handle_create` before the parsed map step 2b needs even exists in valid form.

**Completeness caveat:** This list covers the guard-relevant ordering only. Type and summary exit-64 fallbacks (`src/cli/issue/create.rs` ~:119 and ~:130) are step 4's failure arms, and `--markdown`→ADF conversion with BC-7.2.012 recursion-depth guard (~:163-169) runs between step 4a and step 5; both are intentionally elided. For the intersection of the BC-3.8.012 guard with `--markdown` + `--field`, see EC-3.8.012-5: the guard fires at step 2, so `--markdown` ADF conversion between step 4a and step 5 is never reached on the guarded path.

---

#### BC-3.8.012: `--field` on platform path — REVERSED 2026-08-25 (issue #578): no longer blocked; resolves via `createmeta` (see BC-3.3.010)

> **[AMENDED 2026-08-25 issue #578, DEC-310 (proposed — flagged for orchestrator to register)]**
> The 2026-07-25 DEC-188 pre-flight exit-64 guard for `--field` (preserved verbatim below as
> `[DEC-188 BEHAVIOR, superseded 2026-08-25]`) is REVERSED. `--field` on the platform path
> without `--request-type` NO LONGER exits 64 — it now resolves and merges the field via
> `createmeta`, exactly as BC-3.3.010 specifies. **`--on-behalf-of` is NOT affected by this
> reversal** — BC-3.8.013's exit-64 guard for `--on-behalf-of` remains fully in force,
> UNCHANGED. The combined-error text below (both flags present) is likewise reversed for the
> `--field`-alone trigger, but BC-3.8.013's standalone `--on-behalf-of`-alone guard still fires
> independently. See `[CURRENT BEHAVIOR — effective 2026-08-25]` at the end of this BC for the
> full reversed contract.
>
> **Why this reversal is safe (rationale for the DEC)**: DEC-188 (2026-07-25, #639) treated
> `--field` as a JSM-only concept because, at the time, `jr` had no non-JSM resolution
> mechanism for custom fields on create — sending `--field` through to a platform POST would
> have silently no-op'd or produced an unvalidated raw-string wire value. #578 (2026-08-25)
> closes that gap: BC-3.3.010 gives the platform path a fully-specified `createmeta`-driven
> resolution pipeline, structurally identical to the `editmeta`-driven pipeline `issue edit
> --field` has used since #396 (BC-3.4.015/016). The ORIGINAL exit-64 guard's purpose — prevent
> a caller from silently sending unresolved custom fields — is now served by resolution +
> validation instead of outright rejection. `--on-behalf-of` has NO such analog: "raise a
> request on behalf of a portal customer" has no platform-create equivalent (there is no
> non-JSM concept of "on behalf of"), so its guard's rationale is untouched and it remains
> blocked.
>
> **Migration note (breaking-change-of-a-breaking-change)**: DEC-188 shipped v0.6.0-dev.12
> with migration guidance "add `--request-type <NAME>` or drop `--field`". That guidance is now
> OPTIONAL for `--field` specifically — existing scripts that added `--request-type` solely to
> satisfy the DEC-188 guard are UNAFFECTED (their invocations still work, now via the JSM path
> as before); scripts that want to use `--field` on a NON-JSM create can now drop the
> `--request-type` workaround. No caller is broken by this reversal — it is purely
> permission-widening (something that used to exit 64 now either succeeds or fails later with a
> more specific resolution error per BC-3.3.011). CHANGELOG entry required at F4 under
> `### Changed` (NOT `### Breaking Changes` — this reversal does not break any previously-working
> invocation).
>
> **GOVERNANCE FLAG for orchestrator**: this is a full reversal of a deliberate breaking change
> (DEC-188) shipped exactly one cycle prior (2026-07-25 → 2026-08-25, ~1 month). Per the F1
> BA's `field-dx-bc-mapping.md` §1.2 recommendation, this MUST be recorded as its own formal
> decision entry — proposed ID **DEC-310** (next sequential after the highest DEC number found
> across the ENTIRE `.factory/` tree, DEC-309 — a `grep -rohE "DEC-[0-9]{3}" .factory/` survey
> run during the F2 adversary-convergence pass, 2026-08-26; NOT yet registered in any formal DEC
> log, since this repo has no centralized DEC registry file — DEC numbers are assigned inline in
> spec prose by convention). **Correction (F2 adversary-convergence pass, C-M1):** an earlier
> revision of this line proposed **DEC-307**, derived from a `specs/`-only grep whose reported
> maximum (DEC-306) was wrong on two counts: (1) it did not survey the full `.factory/` tree,
> where `cycle-001`'s F5/F7 closure already allocated DEC-306 through DEC-309 (DEC-306:
> `list-read-ergonomics` F5 Round-1 human ruling; DEC-307: same cycle's F5 combined-delta fix;
> DEC-308: FIX-F6-LRE-1, PR #734; DEC-309: the F7 final authorization gate) — so DEC-307 was
> ALREADY ALLOCATED to an unrelated decision, a collision, not merely a stale number; (2)
> applying the repo's own "next sequential after the highest" rule against the correct
> full-tree maximum (DEC-309) yields DEC-310, not DEC-307. The orchestrator/state-manager should
> register DEC-310 in whatever mechanism supersedes ad hoc inline assignment, and MUST NOT let a
> future pass silently reuse DEC-310 (or DEC-307, already taken) for an unrelated decision.
> **Open namespace question, flagged not resolved:** spec-level DECs (188, 306, 307, 310) and
> cycle-gate DECs (e.g. 309) currently share one `DEC-NNN` prefix with no disambiguating
> sub-namespace — whether these should be one sequence (current de facto behavior) or two
> separate series (e.g. `DEC-SPEC-NNN` vs `DEC-CYCLE-NNN`) is an open question for cycle close;
> this amendment does not resolve it, only surfaces it so a future collision like the one just
> found does not recur silently.

---

**[DEC-188 BEHAVIOR, superseded 2026-08-25 — preserved verbatim below for audit trail; NOT the
current contract for `--field` — see `[CURRENT BEHAVIOR — effective 2026-08-25]` at the end of
this BC]**

> **[AMENDED 2026-07-25 SOH-DX-1 DEC-188 #639]** Prior behavior (warn-and-proceed, exit 0) superseded-in-part by pre-flight exit-64. Old contract text preserved below under [PRIOR BEHAVIOR] for audit trail. Breaking change ships v0.6.0-dev.12. Platform-path inverse-flag tests inverted from exit-0 to exit-64 (AC-1/AC-2/AC-3/AC-5/AC-7); renamed ACs enumerated in Trace. New contract in [CURRENT BEHAVIOR] below.

> **[PRIOR BEHAVIOR, superseded 2026-07-25]** When `jr issue create` was invoked WITHOUT `--request-type` but WITH one or more `--field NAME=VALUE` flags, the handler emitted ONE warning to stderr BEFORE the platform POST. Warning string: `"warning: --field is ignored on the platform create path; it only applies with --request-type (JSM service-desk requests). To pass custom fields to a JSM request type, also supply --request-type."` Platform POST then proceeded normally; exit code was 0. A malformed `--field` (no `=`) still emitted one warning and was discarded. When both `--field` and `--on-behalf-of` were present, each warned independently (BC-3.8.013 fired separately).

---

**[DEC-188 CONTRACT — superseded 2026-08-25]**

**Confidence**: HIGH
**Subject**: Issue write (platform path cross-flag interaction)
**Behavior**: When `jr issue create` is invoked WITHOUT `--request-type` but WITH one or
more `--field NAME=VALUE` flags, the handler MUST return `JrError::UserError` and exit 64
BEFORE any HTTP is issued. Guard placement: fires immediately after the JSM dispatch fork
(`request_type.is_some()` check in `handle_create`), BEFORE project-key resolution, BEFORE interactive prompts, and BEFORE
all pre-POST helper HTTP (steps 3–5) and BEFORE the platform POST (step 6) — see Platform-Path Guard Ordering block above.
Zero HTTP of any kind is issued on this error path. The guard fires on `!field_pairs.is_empty()` — ONE check,
ONE error, regardless of how many `--field` occurrences are present (idempotent per-flag,
not per-value). The guard fires regardless of `--no-input` or `--output json` settings (mode affects only the error rendering channel/shape, per the Test Notes). **Implementation constraint (MUST NOT):** this guard MUST NOT be realized via clap `#[arg(requires = "request_type")]` — that attribute yields exit 2 pre-handler, violating SSOT step 2 and falsified by (non-exhaustively) AC-1/AC-2/AC-16 — any AC asserting the guard string on a guarded-flag invocation falsifies a `requires` realization; AC-15 alone is insensitive (clap exit-2 either way); the guard MUST be a hand-rolled check inside `handle_create` returning `JrError::UserError` (same model as `edit.rs`'s flag-guard pattern).

Verbatim error string (single-flag case: `--field` present, `--on-behalf-of` absent):
```
--field is only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to submit a JSM request with custom fields, or drop --field to create a standard platform issue.
```

**Combined pre-flight error (both `--field` AND `--on-behalf-of` present without `--request-type`):**
ONE combined `JrError::UserError` fires — not two independent errors. The combined check
MUST run before BOTH individual single-flag checks (the `--field`-only check and the `--on-behalf-of`-only check).

Verbatim combined error string:
```
--field and --on-behalf-of are only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to use these flags, or drop them to create a standard platform issue.
```

**Asymmetry rationale (invariant):** Scoped to `jr issue create`. Two distinct guard directions apply:
- **This BC (JSM-only flags on the platform path, `--request-type` absent):** `--field` and `--on-behalf-of` are self-declared JSM-only flags — their help text declares JSM purpose and semantics undefined on the platform path → caller error → exit 64. `jr issue create --field a=b` (no `--request-type`) → exits 64.
- **BC-3.8.011 (platform-only flags on the JSM path, `--request-type` present):** `--team`/`--points`/`--parent`/`--to`/`--account-id` are general platform flags that cannot be expressed in the JSM API → degrade with warning (do not reject) when `--request-type` IS set. `jr issue create --team X` (no `--request-type`) → platform path, `--team` handled normally, no warning. (BC-3.8.010 governs `--type` only.)
Remedy affordance: to create a platform issue and then set custom fields, create the issue first (`jr issue create ...`), then apply fields via `jr issue edit --field`.
**Uniform rule (verbatim error strings carry only unconditional remedies):** Verbatim error strings in `JrError::UserError` MUST contain ONLY unconditional remedies. **Definition (unconditional remedy):** a remedy is unconditional if it depends only on the user's own invocation — not on project permissions, project type, or post-creation steps. `'Add --request-type <NAME>'` qualifies: the user signaled JSM intent by passing the flag; on a non-JSM project the follow-on BC-3.8.002 error is the correct next guidance, not a misdirection. `'then use jr issue edit --field'` does NOT qualify (permission-dependent post-creation step). Conditional remedies (those dependent on project permissions, post-creation steps, or subsequent commands such as `jr issue edit --field`) belong in rationale prose only — not in the verbatim string (CLAUDE.md issue #396 conditionality discipline). The `jr issue edit --field` affordance above is conditional on the user having edit permissions; it is stated here in rationale prose, not in the verbatim error string.

When `--field` is absent (clap default: empty Vec), NO error is emitted; the platform
path proceeds normally, byte-identical to pre-DEC-188 behavior. A malformed `--field`
(e.g., `--field bareflagnoequals`) still triggers the single pre-flight error
(presence of `--field` is sufficient; format validation per BC-3.8.008 applies only on
the JSM path).

**Inputs**: `--field NAME=VALUE` (one or more) WITHOUT `--request-type`
**Outputs/Effects**: `JrError::UserError` to stderr; exit 64; NO stdout output; NO HTTP. Stdout MUST be empty (`stdout.trim().is_empty()`) in both output modes (human and `--output json`). The `stdout.trim().is_empty()` predicate is normative — it matches the `assert_json_error_envelope` helper (fn at `tests/json_error_shape.rs` ~:63; its `stdout.trim().is_empty()` semantics at ~:76; current site — moves to `tests/common/assertions.rs` upon promotion per the F-1 promotion directive — no line number for future site; trims before asserting empty).
**Errors**: Exit 64 (`JrError::UserError`). No HTTP. No warning-and-proceed.
**Removal postcondition (single-site, DEC-188):** The superseded `eprintln!` warn strings (`"warning: --field is ignored on the platform create path…"` and `"warning: --on-behalf-of is ignored on the platform create path…"`) MUST be REMOVED from `src/cli/issue/create.rs`. Stderr on the guarded path MUST NOT contain the substring `"is ignored on the platform create path"`. AC-1, AC-2, AC-3, AC-5, AC-7, AC-8, AC-9, AC-10, AC-11, AC-13, AC-17, AC-18, and AC-19 MUST each include a negative assertion: `!stderr.contains("is ignored on the platform create path")`. Uniform rule: every AC that reaches `handle_create` with a guarded flag (`--field` or `--on-behalf-of`) and no `--request-type` carries this pin — the rule is structural, not an arbitrary enumeration; add the pin whenever a new AC in this class is authored. AC-15 is excluded: its `--field a=b` invocation is rejected by clap `conflicts_with` at exit 2 pre-handler; `handle_create` is never entered and the guard is never evaluated. (AC-16 carries the equivalent pin via BC-3.8.013's Removal postcondition.) This assertion is a regression pin, not vacuous: AC-1/2/3/5/7/8/9/10/11/13/17/18/19 each exercise a path that previously emitted the old warning string — the pin proves the warning is absent on the exact invocations where it used to fire. AC-4 differs (see below): its clean path (no guarded flags) never emitted the old warning, so its negative assertion pins absence of the NEW error substrings instead. Additionally, AC-1's prior stdout negative assertion `!stdout.contains("warning: --field is ignored")` (`tests/issue_create_jsm.rs` ~:2479-2482) is vacuously true (warnings fired to stderr only — that substring never appeared in stdout). DELETE this assertion from the test body and replace with `stdout.trim().is_empty()`, which is the correct affirmative assertion for the guarded path. **Doc-comment and section-banner rewrite obligation:** each inverted AC's test doc comment and section banner MUST be rewritten to exit-64 semantics — rustdoc prose or banner text asserting warn-and-proceed (e.g., section banners at `tests/issue_create_jsm.rs` ~:2413-2418, ~:2486-2491, and AC-3/AC-4/AC-5/AC-6/AC-7 equivalents) may NOT survive the F4 rewrite; every comment describing old exit-0 behavior or suppressed warnings becomes stale and misleading post-DEC-188 and MUST be corrected in the same PR as the test inversion. Additionally, the FAMILY-level banner at `tests/issue_create_jsm.rs` ~:2381-2391 (`"S-383: Platform-path inverse warnings…Red Gate: all 7 tests MUST fail…2 eprintln! guards"`) contains THREE clauses that are all false post-DEC-188 and MUST be rewritten at F4: (1) `"S-383: Platform-path inverse warnings"` — the "Platform-path inverse warnings" framing is historical (the tests now exercise an exit-64 guard, not an inverse-warn pattern); (2) `"Red Gate: all 7 tests MUST fail"` — the tests no longer have Red Gate semantics post-inversion (they PASS against the exit-64 guard); (3) `"2 eprintln! guards"` — both eprintln! warn calls were REMOVED by DEC-188 and no longer exist. The ENTIRE FAMILY-level banner MUST be replaced with a banner reflecting exit-64 guard semantics for all inverted tests.
**Test Note**: In human output mode, test assertions use `stderr.contains(...)` (not `==`) to accommodate the "Error: " prefix prepended by the `src/main.rs` error-rendering site. With `--output json`, the error JSON is written to **stderr** (not stdout) WITHOUT the "Error: " prefix — parse stderr directly as JSON; assert `code == 64` and `error` contains the guard message substring. Key order is serde_json map behavior (alphabetical by default without `preserve_order`; unspecified contractually — parse fields individually, do not match literal key order); output is compact, not pretty-printed. Implementers: promote `assert_json_error_envelope` as `pub fn` to `tests/common/assertions.rs` (`pub fn` is the assertions.rs convention) from `tests/json_error_shape.rs` (F3 deliverable); register `pub mod assertions;` in `tests/common/mod.rs` (F3 deliverable); DELETE the original fn from `tests/json_error_shape.rs`; re-import from `tests/common/assertions.rs` at the three existing call sites in `tests/json_error_shape.rs` — no duplicate definition under the zero-warnings policy. **Hygiene:** `tests/issue_create_jsm.rs` gains `#[allow(dead_code)] mod common;` at the promotion step — AC-2 and AC-7 import `assert_json_error_envelope` from `tests/common/assertions.rs` there, pulling in the same ~29 fixtures. During promotion, fix the stale doc-comment in `assert_json_error_envelope` that claims a specific `{"error":…,"code":…}` key order — correct to: key order is serde_json map behavior (alphabetical by default without `preserve_order`; unspecified contractually); callers MUST parse the JSON and check fields individually, not rely on or test literal key order (parse, don't match). **Config fixture contract (single source — callers of `assert_json_error_envelope`):** callers MUST ensure stderr contains ONLY the error JSON envelope — use a pre-migrated `[profiles.default]`-shaped config fixture (F3 deliverable: `write_profile_config(config_home: &Path, base_url: &str)` — lives in `tests/common/fixtures.rs` (`fixtures.rs` is the home for non-assertion test fixtures generally, including config writers; the F46-003 "pure-JSON" charter is narrowed to payload fixtures only — these two helpers have DIFFERENT destinations: `write_profile_config` → `tests/common/fixtures.rs`, `assert_json_error_envelope` → `tests/common/assertions.rs`); shape modeled on `tests/issue_create_jsm.rs` ~:1959-1966: `default_profile = "default"` + `[profiles.default]` block with `url` and `auth_method` fields), NOT `write_minimal_config`'s legacy `[instance]` shape; `src/config.rs` ~:255-287 emits a one-time `"Migrated config to multi-profile layout…"` stderr line on first load of the legacy shape, which poisons the strict JSON parse in `assert_json_error_envelope`.
**Edge Cases**:
- EC-3.8.012-1: `--on-behalf-of ""` (empty string value) WITH `--field` present: the combined-error check in BC-3.8.012 governs (fires first); BC-3.8.013 alone does not fire. (The sub-case `--on-behalf-of ""` WITHOUT `--field` is a BC-3.8.013-only case; see EC-3.8.013-1.)
- EC-3.8.012-2: `--field` present WITH `--request-type ""` (empty string, or whitespace-only, e.g. `"   "` — trim-guard at `src/cli/issue/jsm_create.rs` ~:145 routes identically): routes to the JSM path; BC-3.8.016 (empty RT guard) fires, NOT this guard. This guard fires only when `--request-type` is entirely absent (clap default `None`).
- EC-3.8.012-3: Malformed `--field` (e.g., `--field bareflagnoequals`): guard fires on `!field_pairs.is_empty()` BEFORE value parsing. Format validation per BC-3.8.008 applies only on the JSM path and is never reached on this error path.
- EC-3.8.012-4: **[SUPERSEDED — historical]** `jr issue create --field a=b` with no `--project` and no profile default → BC-3.8.012 pre-flight guard fires at step 2 of the Platform-Path Guard Ordering above, BEFORE project-key resolution (step 3). The user sees the `--field`-is-JSM-only error, NOT a "project key is required" error. The dispatch fork (step 1) → pre-flight guard (step 2) → project resolution (step 3) ordering guarantees this precedence.
- EC-3.8.012-5: `--markdown --field description=x` WITHOUT `--request-type` → BC-3.8.012 fires (step 2 of `handle_create` platform guard ordering; `--field` is present without `--request-type`). BC-3.8.017's `--markdown` + `--field description=` conflict guard lives inside `handle_jsm_create` (JSM Canonical Guard Ordering step 2) and cannot hoist to the platform path — the JSM path is never entered when `--request-type` is absent. Note: `handle_create` (the platform path) has NO `--markdown`-requires-`--description` guard of its own; that guard exists only in `src/cli/issue/jsm_create.rs::handle_jsm_create` and `src/cli/issue/edit.rs::handle_edit`. BC-3.8.012 fires on `!field_pairs.is_empty()` regardless of the `--markdown` flag state; `--markdown` is irrelevant to the platform-path guard.
- EC-3.8.012-6: Config/auth failures precede the guard entirely — `Config::load_with` and `JiraClient::from_config` run in `src/main.rs` (~:293-295) BEFORE `handle_create` is invoked. Unauthenticated callers exit 2 and misconfigured callers exit 78 before `handle_create` is reached; they never encounter the exit-64 guard. "Pre-flight" in this BC means first-check-inside-handler, not first-possible-failure-overall. No AC for this case — config/auth precedence is `src/main.rs`-level behavior covered by existing auth/config test families; deliberate non-goal for S-639-1.
- EC-3.8.012-7: `--description-stdin` + guarded flag (e.g., `--field a=b`) without `--request-type` → BC-3.8.012 guard fires pre-flight; stdin is NEVER read. Note: non-TTY stdin auto-sets `--no-input` (per `src/main.rs:~112`), so this is the scripted-caller path. A piping producer may see EPIPE; a heredoc input is discarded. This is acceptable, documented behavior — fail-fast on the caller error takes precedence over draining stdin.
- EC-3.8.012-8: Clap `conflicts_with` parse-level rejections precede the guard entirely — e.g., `--to` conflicts with `--account-id` (inline fields of `src/cli/mod.rs::IssueCommand::Create`, ~:348-407; `IssueCreateArgs` does not exist as a separate struct — args are declared inline); `--description` conflicts with `--description-stdin` — both produce clap exit 2 BEFORE `handle_create` is invoked, so BC-3.8.012 never fires. Precedence: clap exit-2 > pre-flight exit-64. Note: AC-8's invocation (`--project PROJ --type Task --summary "test" --field a=b --team X --to me`) deliberately avoids conflicting flag pairs to isolate the guard under test.
- EC-3.8.012-9: `--field a=` (present key, explicitly empty VALUE after `=`) without `--request-type` → guard fires on `!field_pairs.is_empty()` pre-parse; exit 64. Distinct from EC-3.8.012-3's malformed-no-equals class (`--field ""` with no `=` falls into that class). `--field a=` parses successfully into `field_pairs` as `[("a", "")]`; guard fires identically on presence. The value's contents are never inspected at the guard stage. Non-goal: combined-flags `--output json` is deliberately not a separate test case — the JSON envelope shape is identical to the single-flag case (covered by AC-10); the combined-flags case is tested in human mode by AC-3.
- EC-3.8.012-10: The guard is PROJECT-TYPE-AGNOSTIC — `--field`/`--on-behalf-of` without `--request-type` exits 64 even when `--project` names a known JSM project. The guard fires at step 2, BEFORE project-key resolution (step 3) and BEFORE any `require_service_desk` call; `handle_create` cannot know the project type at guard-time. The byte-for-byte stability claims for `jr issue create` in `docs/adr/0014-jsm-request-type-dispatch.md` (~:60, ~:73-76, ~:159-160, ~:161) require amendment per S-639-1 deliverable (a) — those claims are now conditional on `--field`/`--on-behalf-of` being absent. ADR-0014 §42-45 ("Rather than silently dropping these flags or erroring on them BEFORE verifying the project is a JSM project…") is NOT amended — its antecedent is the six platform-only flags (BC-3.8.010 + BC-3.8.011 directions, unchanged by DEC-188) and it remains accurate. **MUST NOT gate on project type:** checking project type at step 2 would require a network round-trip, violating the zero-HTTP guarantee. Note on BC-3.8.011 direction: BC-3.8.011 (platform flags silently dropped on JSM path after `require_service_desk` passes) operates in the OPPOSITE direction at a LATER step — NO conflict. BC-3.8.012/013 guard the platform→JSM mis-use at step 2; BC-3.8.011 guards JSM→platform silent-drop post-`require_service_desk`. Transitively falsified by AC-8/AC-13's `received_requests().is_empty()` — any project-type gate would require HTTP; no dedicated AC needed.
**Trace**: `tests/issue_create_jsm.rs` — platform-path inverse-flag tests invert from exit-0 to exit-64; old→new rename mappings below; `src/cli/issue/create.rs::handle_create` (guard implementation site). Holdout coverage (SOH-DX-1 F2 2026-07-29, overrides F51-001 non-goal per F2 gate human ruling): H-NEW-PREFLIGHT-001 (`--field` alone → exit 64 zero HTTP), H-NEW-PREFLIGHT-003 (both flags → combined error, zero HTTP), H-NEW-PREFLIGHT-004 (neither flag → exit 0 regression pin), H-NEW-PREFLIGHT-005 (JSM path non-mis-fire), H-NEW-PREFLIGHT-006 (`--output json` envelope).
**AC namespace note:** AC-1..AC-21 below are the S-639-1 acceptance-criteria targets to be authored verbatim into the S-639-1 story at F3; they SUPERSEDE S-383's same-numbered ACs (historical, do-not-implement). Until S-639-1 exists, THIS Trace is the authoritative AC source. **[SUPERSEDED-IN-PART 2026-08-25 issue #578, DEC-310 (proposed)]** This AC-1..21 list lives inside the `[DEC-188 BEHAVIOR, superseded 2026-08-25]` wrapper and documents the now-reversed `--field`-alone and combined-guard contract — it is NOT current contract for those cases (see `[CURRENT BEHAVIOR — effective 2026-08-25, issue #578]` below). The `--field`-asserting and combined ACs in this list — AC-1, AC-3, AC-5, AC-8 invocation (i), AC-9, AC-10, AC-11, AC-13, AC-17, AC-18, and AC-19 (each asserts a `--field`-alone or combined `--field`+`--on-behalf-of` invocation exits 64 with a `--field`-is-only-valid-with or combined error string) — are SUPERSEDED and MUST NOT be authored as-is into the S-639-1 story at F3; they are replaced by createmeta-resolution ACs derived from VP-578-017/VP-578-018/VP-578-019 and BC-3.3.010/BC-3.3.011's error taxonomy. **AC-12 is also SUPERSEDED, for a distinct reason (F5 pass-4 F1):** it pins `stdout.matches("requires --request-type").count() == 2`, asserting BOTH the `--field` and `--on-behalf-of` help lines carry the clause — post-reversal, `--field`'s help clause is removed (see BC-3.8.012 `[CURRENT BEHAVIOR — effective 2026-08-25]`'s F3/F4 removal obligations below) since `--field` now works with or without `--request-type`; only `--on-behalf-of` keeps the clause. The correct post-reversal pin is `count() == 1`, scoped to the `--on-behalf-of` help line only; AC-12 MUST NOT be authored as-is into the S-639-1 story at F3. **AC-3 specifically** (`test_platform_create_both_inverse_flags_exit_64_combined_error`) is flagged: its combined-error assertion no longer has a live guard to test post-reversal — see BC-3.8.013's own AC-3 Trace annotation (§"Combined pre-flight error", rewritten 2026-08-25) for the disposition (the invocation now exercises BC-3.8.013's standalone guard only). ACs asserting only `--on-behalf-of`-alone behavior (AC-2, AC-16, AC-20) and the JSM non-mis-fire ACs (AC-6, AC-21) are UNAFFECTED and remain authoritative. Step-ordering statements in ACs (e.g., "guard fires at step 2 before project-key resolution at step 3") reference the Platform-Path Guard Ordering SSOT block (§"Platform-Path Guard Ordering" — "**SINGLE SOURCE OF TRUTH** for the guard-relevant ordering (authoritative for step numbering) in `handle_create`"); that block is authoritative; per-AC statements are informational summaries only. Every negative assertion in an AC MUST carry one of three labels: **DISCRIMINATING** (falsifiable by the specific targeted defect — guard misplaced or absent in the tested scenario), **FALSIFIABLE-COARSE** (catches only gross defects such as an unconditionally-firing guard tripping a combined-string negative on unrelated invocations), or **HYGIENE** (structurally unfalsifiable given the invocation shape). **REGRESSION PIN** is a named subtype of DISCRIMINATING — it targets the re-introduction defect class (a restored `eprintln!` warning trips it), hence falsifiable; label it as `REGRESSION PIN (DISCRIMINATING subtype)` at first use. Unlabeled negatives are disallowed. **F3 story expansion directive (F65-002):** When authoring these ACs to S-639-1 at F3, EXPAND each compressed single-line entry into full story format following `.factory/stories/S-576-3.md` as the format reference (a multi-line block with its own `### AC-NNN` heading, precondition paragraph, invocation line(s), and assertion list per AC). "Verbatim" governs the *content* — invocations, assertions, labels, error strings — not the line formatting.
AC-1 `test_platform_create_field_flag_exits_64_without_request_type` [mode: human] (renamed from `test_platform_create_field_flag_emits_warning_without_request_type`): `jr issue create --project PROJ --type Task --summary "test" --field a=b` (no `--request-type`, no `--output json`; invocation is would-otherwise-succeed — `mount_platform_create_stubs` MUST be called so the platform POST can complete if the guard is absent; only a would-otherwise-succeed run makes `!stderr.contains("Created issue")` a genuine DISCRIMINATING NEGATIVE rather than HYGIENE) → exit 64; `stderr.contains("Error: ")` (human-mode "Error: " prefix from `src/main.rs` ~:143 — the human-mode (`_ =>`) match arm of the output_format dispatch; the JSON arm (~:134-140) emits no prefix — NOTE: this prefix pin is single-sourced here; other human-mode ACs omit it deliberately); `stderr.contains("--field is only valid with")` (prefix pin); `stderr.contains("--field is only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to submit a JSM request with custom fields, or drop --field to create a standard platform issue.")` (FULL-STRING pin — single-source for the BC-3.8.012 single-flag verbatim string; verbatim from §"Verbatim error string (single-flag case)"; NOTE: backticks in Rust string literals are ordinary characters — write WITHOUT escaping, raw backticks only; the `\`` marks in this Markdown source are a display artifact and are NOT valid Rust — E0762 class; other ACs asserting this error use prefix pins only); `stdout.trim().is_empty()` (hygiene — non-discriminating in human mode per BC-3.4.014: table-mode success echoes to stderr, not stdout; `stdout.trim().is_empty()` alone cannot distinguish guard from success); DISCRIMINATING NEGATIVE: `!stderr.contains("Created issue")` (proves no success path executed — BC-3.4.014 success echo fires to stderr; FALSIFIABLE because the complete invocation with `mount_platform_create_stubs` would echo "Created issue" on stderr if the guard were absent); REGRESSION PIN (DISCRIMINATING subtype): `!stderr.contains("is ignored on the platform create path")` (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; this invocation previously emitted the old warn string; first use of the `(DISCRIMINATING subtype)` parenthetical per §"AC namespace note" — later ACs (AC-2/3/5/7/8/9/10/11/13/17/18/19) may keep or drop the parenthetical; both are correct). Pairing: AC-1 (human mode) and AC-10 (json mode) are complementary tests for the same invocation class (`--field` alone without `--request-type`) — AC-1 verifies the human rendering path including the "Error: " prefix; AC-10 verifies the JSON envelope shape via `assert_json_error_envelope`. OLD ASSERTIONS MUST BE REMOVED from `tests/issue_create_jsm.rs`: (i) old exit-0 assertions (~:2465-2469 — `assert_success` or equivalent); (ii) old verbatim warning `contains` assertion (~:2470-2473 — `stderr.contains("warning: --field is ignored on the platform create path...")` form; NOT `.count()` — the `.count()` forms are at ~:2732-2738 AC-5 and ~:2860-2866 AC-7); (iii) old stdout negative `!stdout.contains("warning: --field is ignored")` (~:2479-2482 — vacuously true; replace with `stdout.trim().is_empty()`); (iv) old `stdout.contains("PROJ-123")` assertion (~:2474-2477 — issue key present after successful create; the guarded path never reaches issue creation); (v) `--output json` argument from the invocation (~:2456-2457 — the test is now [mode: human]; `--output json` must be removed from the command args so the human rendering path is actually exercised). (KEPT: everything in the existing test body EXCEPT item (v) `--output json` and items (i)–(iv) enumerated in the DELETE mandate above. Note: the `--field a=b` value is free — the guard is presence-only (`!field_pairs.is_empty()` at `src/cli/issue/create.rs` ~:81); the existing `NAME=VALUE` form is fine. Note: `--no-input` flag remains if present in the existing test setup — deliberate; AC-11 is the TTY-path test; cross-ref.) S-639-1 F3 story deliverable.
AC-2 `test_platform_create_on_behalf_of_flag_exits_64_without_request_type` [mode: --output json] (renamed from `test_platform_create_on_behalf_of_flag_emits_warning_without_request_type`): `jr issue create --on-behalf-of X --output json` (no `--request-type`; invocation is would-otherwise-succeed — `mount_platform_create_stubs` MUST be called so the platform POST can complete if the guard is absent; only a would-otherwise-succeed run makes `stdout.trim().is_empty()` a genuine DISCRIMINATING assertion rather than HYGIENE) → exit 64; parse stderr as JSON via `assert_json_error_envelope` (note: `assert_json_error_envelope` asserts JSON shape only — the `error` field contains-assertion is written separately at the call site); assert `error` field contains `"--on-behalf-of is only valid with"`; stdout MUST be empty (`stdout.trim().is_empty()`, DISCRIMINATING in `--output json` mode: `create.rs` ~:249/:265 prints the created-issue JSON object to stdout on the success path; guard-absent would populate stdout; this assertion distinguishes guarded path from success); REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; this invocation previously emitted the old warn string). OLD ASSERTIONS MUST BE REMOVED from `tests/issue_create_jsm.rs`: old exit-0 assertions (~:2537-2539 — `assert_success` or equivalent); old verbatim warning `contains` assertion (~:2542-2545 — `stderr.contains("warning: --on-behalf-of is ignored on the platform create path...")` form); old `stdout.contains("PROJ-123")` assertion (~:2546-2549 — issue key present after successful create; the guarded path never reaches issue creation); (iv) old stdout negative `!stdout.contains("warning: --on-behalf-of is ignored")` (~:2551 — vacuously true post-DEC-188; that substring no longer exists anywhere; must be deleted); (v) the `write_minimal_config(…)` call MUST be REPLACED (not kept) by the pre-migrated profile-shaped fixture (`write_profile_config`, F3 deliverable) — satisfies the Config fixture contract above; `write_minimal_config`'s legacy `[instance]` shape is incompatible with `assert_json_error_envelope`'s strict-parse. (KEPT: everything in the existing test body EXCEPT the items enumerated in the DELETE mandate above. Note: no line-range anchor — the old ~:2537 reference collided with the DELETE target range. Note: the invocation shorthand (`--on-behalf-of X`) names only the flag under test; per KEPT the existing test body also includes `--project`, `--type`, and `--summary` (or equivalents) — the shorthand in the AC description omits them for readability.) **Precondition:** MUST use a pre-migrated `[profiles.default]`-shaped config fixture (see Config fixture contract in the Test Note above) — `assert_json_error_envelope` strict-parses ALL of stderr as JSON; `write_minimal_config`'s legacy `[instance]` shape triggers the one-time `src/config.rs` ~:255-287 migration line on first load, causing a guaranteed false-RED. S-639-1 F3 story deliverable.
AC-3 `test_platform_create_both_inverse_flags_exit_64_combined_error` [mode: human] (renamed from
`test_platform_create_both_inverse_flags_emit_independent_warnings`):
invocation: `jr issue create --project PROJ --type Task --summary "test" --field a=b --on-behalf-of X` (no `--request-type`; invocation is would-otherwise-succeed — `mount_platform_create_stubs` MUST be called so the success path can complete if the guard is absent; only a would-otherwise-succeed run makes `!stderr.contains("Created issue")` a genuine DISCRIMINATING NEGATIVE rather than HYGIENE); exit 64; assert combined string present: `stderr.contains("--field and --on-behalf-of are only valid with")` (prefix pin); `stderr.contains("--field and --on-behalf-of are only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to use these flags, or drop them to create a standard platform issue.")` (FULL-STRING pin — single-source for the combined verbatim string; other ACs use prefix pins only); `stdout.trim().is_empty()` (hygiene — non-discriminating in human mode per BC-3.4.014); DISCRIMINATING NEGATIVE: `!stderr.contains("Created issue")` (proves no success path executed — FALSIFIABLE because the complete invocation with `mount_platform_create_stubs` would echo "Created issue" on stderr if the guard were absent); AND both single-flag strings absent: `!stderr.contains("--field is only valid with")` (FALSIFIABLE-COARSE: invocation has `--field`; catches gross defect where single-flag guard fires instead of combined guard; combined has "are only valid with", single "is only valid with" — non-overlapping strings) AND `!stderr.contains("--on-behalf-of is only valid with")` (FALSIFIABLE-COARSE: invocation has `--on-behalf-of`; same non-overlap rationale; combined has "--on-behalf-of are only valid with", single has "--on-behalf-of is only valid with"); REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` — per §"Removal postcondition (single-site, DEC-188)"; NOT vacuous: this invocation class previously emitted the old warn string, so the pin proves it is absent post-DEC-188. OLD ASSERTIONS MUST BE REMOVED from `tests/issue_create_jsm.rs`: old exit-0 assertion (~:2609-2613 — `assert_success` or equivalent); old BC-3.8.012 verbatim warning `contains` assertion (~:2615-2618 — `stderr.contains("warning: --field is ignored on the platform create path...")`); old BC-3.8.013 verbatim warning `contains` assertion (~:2619-2622 — `stderr.contains("warning: --on-behalf-of is ignored on the platform create path...")`); `--output json` argument from the invocation (~:2601-2602 — the test is now [mode: human]; `--output json` must be removed from the command args so the human rendering path is actually exercised). (KEPT: everything in the existing test body EXCEPT the `--output json` arg and the items enumerated in the DELETE mandate above.) S-639-1 F3 story deliverable.
AC-5 `test_platform_create_field_idempotent_one_error_per_logical_flag` [mode: human] (renamed from
`test_platform_create_field_idempotent_one_warning_per_logical_flag`):
run BOTH invocations — (i) `jr issue create --project PROJ --type Task --summary "test" --field a=b` (MUST be exactly one `--field`) and (ii) `jr issue create --project PROJ --type Task --summary "test" --field a=b --field c=d` (both are would-otherwise-succeed — `mount_platform_create_stubs` MUST be called so the success path can complete if the guard is absent; only a would-otherwise-succeed run makes `!stderr.contains("Created issue")` a genuine DISCRIMINATING NEGATIVE rather than HYGIENE) — for EACH invocation assert `stderr.contains("--field is only valid with")` AND exit 64; then capture both stderr strings and assert they are equal (byte-identical). Note: both invocations are human mode (no `--output json`); the "Error: " prefix is present in both stderr captures, so byte-identity holds across both. The `stderr.contains("--field is only valid with")` anchor prevents false-green when the guard is absent: with the guard absent, both invocations SUCCEED and emit identical 'Created issue PROJ-123' stderr (`src/cli/issue/create.rs` ~:272) — byte-identity alone cannot distinguish success from guard-error; the positive anchor pins which error is compared. The guard checks `!field_pairs.is_empty()` (any non-empty Vec), so n>1 occurrences produce ONE error with no field-name enumeration and no count suffix. REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` on EACH invocation (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; both invocations previously emitted the old warn string). DISCRIMINATING NEGATIVE: `!stderr.contains("Created issue")` on EACH invocation (proves no success path executed — FALSIFIABLE because the complete invocations with `mount_platform_create_stubs` would echo "Created issue" on stderr if the guard were absent). AC-5 is a two-invocation comparison test and MUST remain separate from AC-1 (AC-1 asserts only that the error is present; AC-5 asserts byte-identity across invocation counts). **Precondition:** MUST use a pre-migrated `[profiles.default]`-shaped config fixture for BOTH invocations (see Config fixture contract in the Test Note above) — invocation (i) triggers the one-time `src/config.rs` ~:255-287 migration of the legacy `[instance]` shape, emitting `"Migrated config to multi-profile layout…"` to stderr; invocation (ii) does not (config already migrated), so the two stderrs diverge and byte-identity fails. Chosen remedy: pre-migrated fixture, consistent with AC-2/AC-7/AC-10. Note on separate-TempDir-per-invocation: each fresh TempDir would independently trigger migration, producing the migration line in both stderrs equally — byte-identity would hold incidentally, BUT the migration line would still pollute stderr and risk interfering with assertions; pre-migrated fixture is the correct clean approach. OLD ASSERTIONS MUST BE REMOVED from `tests/issue_create_jsm.rs`: existing multi-field invocation (~:2712-2717 — e.g. `--field A=1 --field A=2 --field B=3` or similar 3-field form; MUST be replaced by the two-invocation spec above: (i) exactly one `--field`, (ii) exactly two `--field`s — preserving the 3-field form collapses the n=1 vs n>1 discriminator since n=3 is not distinguished from n=2); old exit-0 assertion (~:2727-2730 — `assert_success` or equivalent); old `.count()` form assertion (~:2732-2738 — `stderr.matches("warning: --field is ignored...").count()` or equivalent count check); `--output json` argument from the invocation (~:2719-2720 — the test is now [mode: human]; `--output json` must be removed from the command args so the human rendering path is actually exercised); additionally, the `write_minimal_config(…)` call MUST be REPLACED (not kept) by the pre-migrated profile-shaped fixture (`write_profile_config`, F3 deliverable) — satisfies the Config fixture contract and prevents migration-line stderr pollution from breaking the byte-identity assertion. (KEPT: everything in the existing test body EXCEPT the `--output json` arg and the items enumerated in the DELETE mandate above.) S-639-1 F3 story deliverable.
AC-7 `test_platform_create_malformed_field_without_request_type_exits_64` [mode: --output json] (renamed from `test_platform_create_malformed_field_one_warning_no_exit_64`): EC-3.8.012-3 as test — `jr issue create --field bareflagnoequals --output json` (no `--request-type`; invocation is would-otherwise-succeed — `mount_platform_create_stubs` MUST be called so the platform POST can complete if the guard is absent; only a would-otherwise-succeed run makes `stdout.trim().is_empty()` a genuine DISCRIMINATING assertion rather than HYGIENE) → exit 64; parse stderr as JSON via `assert_json_error_envelope` (note: `assert_json_error_envelope` asserts JSON shape only — the `error` field contains-assertion is written separately at the call site); assert `error` field contains `"--field is only valid with"`; stdout MUST be empty (`stdout.trim().is_empty()`, DISCRIMINATING in `--output json` mode: `create.rs` ~:249/:265 prints the created-issue JSON object to stdout on the success path; guard-absent would populate stdout; this assertion distinguishes guarded path from success); REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; this invocation previously emitted the old warn string). Guard fires on `!field_pairs.is_empty()` before value parsing — malformed format does not affect guard activation. OLD ASSERTIONS MUST BE REMOVED from `tests/issue_create_jsm.rs`: (i) old exit-0 assertions (~:2855-2859 — `assert_success` or equivalent); (ii) old warning-count assertions (~:2860-2866 — `stderr.matches(…).count()` form); additionally, the `write_minimal_config(…)` call MUST be REPLACED (not kept) by the pre-migrated profile-shaped fixture (`write_profile_config`, F3 deliverable) — satisfies the Config fixture contract above; `write_minimal_config`'s legacy `[instance]` shape is incompatible with `assert_json_error_envelope`'s strict-parse. (KEPT: everything in the existing test body EXCEPT the items enumerated in the DELETE mandate above. Note: the invocation shorthand (`--field bareflagnoequals`) names only the flag under test; per KEPT the existing test body also includes `--project`, `--type`, and `--summary` (or equivalents) — the shorthand in the AC description omits them for readability.) **Precondition:** MUST use a pre-migrated `[profiles.default]`-shaped config fixture (see Config fixture contract in the Test Note above) — `assert_json_error_envelope` strict-parses ALL of stderr as JSON; `write_minimal_config`'s legacy `[instance]` shape triggers the one-time `src/config.rs` ~:255-287 migration line on first load, causing a guaranteed false-RED. S-639-1 F3 story deliverable.
AC-4 `test_platform_create_without_inverse_flags_emits_no_errors` [mode: --output json] (renamed from `test_platform_create_without_inverse_flags_emits_no_new_warnings`) — NOT unchanged post-DEC-188; test body MUST be updated at F3. The original name "`_emits_no_new_warnings`" is stale post-DEC-188 since the assertions now concern absent ERRORS, not absent warnings. Rename per convention `test_<verb>_<subject>_<expected_outcome>`. OLD ASSERTIONS MUST BE REMOVED from `tests/issue_create_jsm.rs`: `!stderr.contains("--field is ignored")` (~:2671 — vacuously true post-DEC-188; that substring no longer exists anywhere; must be deleted); `--on-behalf-of` twin `!stderr.contains(…is ignored…)` (~:2675 — same vacuous class; must be deleted). Updated AC-4 contract: assert exit 0 AND assert `!stderr.contains("--field is only valid with")` (FALSIFIABLE-COARSE: invocation has no `--field`; catches guard firing on invocations without the target flag) AND `!stderr.contains("--on-behalf-of is only valid with")` (FALSIFIABLE-COARSE: invocation has no `--on-behalf-of`; same class) AND `!stderr.contains("--field and --on-behalf-of are only valid with")` (FALSIFIABLE-COARSE: invocation has neither flag; catches combined guard firing on clean invocations) — absence of ALL THREE new error substrings on the clean path (mirrors the three-negative set AC-6 already asserts for the JSM path). Invocation: `jr issue create --project PROJ --type Task --summary "test" --output json` (`mount_platform_create_stubs` MUST be called so the success path completes if the guard is absent; exit 0). (KEPT: everything in the existing test body EXCEPT the items enumerated in the DELETE mandate above.) Obs: `GET /rest/api/3/issue/PROJ-123` follow-up fetch (`src/cli/issue/create.rs` ~:243) is unstubbed under `mount_platform_create_stubs` → stderr carries a fetch-warning on the success path; AC-4's three `!stderr.contains(...)` negatives are unaffected (they check guard strings, not fetch warnings); do NOT add stderr-cleanliness assertions to AC-4 — the test-writer MAY stub the follow-up GET if a quiet run is preferred. S-639-1 F3 story deliverable.
AC-6 (`test_jsm_create_with_field_and_request_type_does_not_fire_bc_3_8_012`) [mode: --output json] — NOT unchanged post-DEC-188; test body MUST be updated at F3. OLD ASSERTION MUST BE REMOVED from `tests/issue_create_jsm.rs`: `!stderr.contains("--field is ignored on the platform create path")` (~:2799 — vacuously true post-DEC-188; that substring no longer exists anywhere; must be deleted). Updated AC-6 contract: exit 0 AND `!stderr.contains("--field is only valid with")` (DISCRIMINATING: invocation has `--field` + `--request-type`; guard would fire if `--request-type` were absent or not gated correctly) AND `!stderr.contains("--field and --on-behalf-of are only valid with")` (FALSIFIABLE-COARSE: invocation has no `--on-behalf-of`; catches gross defect where combined guard fires whenever `--field` is present regardless of `--on-behalf-of` presence — see AC-21 for the fully-falsifiable combined-path test) — BC-3.8.012 must remain silent when `--request-type` IS present on the JSM path. (KEPT: everything in the existing test body EXCEPT the items enumerated in the DELETE mandate above. Note: the `expect(1)` POST stub at ~:2758-2763 is load-bearing — preserved.) S-639-1 F3 story deliverable.
AC-8 (NEW) `test_platform_create_field_with_helpers_exits_64_zero_http` [mode: human]: Two sub-invocations; each runs against its own separate isolated `MockServer` instance. Invocation (i): `jr issue create --project PROJ --type Task --summary "test" --field a=b --team X --to me` (no `--request-type`) — invocation is complete enough to reach helper HTTP + POST if the guard were absent; → exit 64; `stderr.contains("--field is only valid with")`; REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; this invocation previously emitted the old warn string); HYGIENE (NOT DISCRIMINATING): `!stderr.contains("Created issue")` — with an isolated MockServer (no free-fire success mocks), even the guard-absent path fails at HTTP (the `expect(0)` on `GET /rest/api/3/field` fires first), so "Created issue" is structurally unreachable in either path; the discriminating proof is the `server.received_requests().await.unwrap().is_empty()` assertion on the isolated `MockServer` (NORMATIVE zero-HTTP proof — see below), NOT this negative. **Normative zero-HTTP assertion** (in-repo primitive: `tests/issue_create_json.rs` ~:411): after the command completes, assert `server.received_requests().await.unwrap().is_empty()` — this catches ALL HTTP calls to the `MockServer` regardless of mock registration; unregistered endpoint calls return 404 silently and pass `expect(0)`, but are caught by `received_requests`. The `expect(0)` mocks below are DEFENSE-IN-DEPTH documentation of which endpoints would be reached if the guard were absent. `expect(0)` on: (a) `GET /rest/api/3/myself` (`--to me` resolves via call at `src/cli/issue/create.rs` ~:213 → `src/cli/issue/helpers.rs::resolve_assignee_by_project` → `JiraClient::get_myself` (`src/api/jira/users.rs::get_myself`, ~:19) — never via assignable-user search) — **DEFENSE-IN-DEPTH** (structurally unreachable guard-absent: `(d)` fires and fails first); (b) `POST /gateway/api/graphql` (`get_org_metadata`, `src/api/jira/teams.rs` ~:12, org-metadata GraphQL discovery for `--team` resolution) — **DEFENSE-IN-DEPTH**; (c) `GET /gateway/api/public/teams/v1/org/{orgId}/teams` (`list_teams`, `src/api/jira/teams.rs` ~:33, team-list fetch when cache cold) — **DEFENSE-IN-DEPTH**; (d) `GET /rest/api/3/field` (`find_team_field_id`, `src/api/jira/fields.rs` ~:26, field-discovery when `team_field_id` unconfigured in profile) — **DEFENSE-IN-DEPTH** (previously the DISCRIMINATING mock — first registered HTTP the guard-absent path reaches; superseded by `received_requests().is_empty()` as normative zero-HTTP proof above); (e) `POST /rest/api/3/issue` (issue creation POST) — **DEFENSE-IN-DEPTH** (unreachable: `(d)` fails first). **Mock ResponseTemplate note:** each `expect(0)` mock MUST include a `respond_with` clause (e.g. `ResponseTemplate::new(200)`) so the mock compiles; the response body and status are irrelevant — the `expect(0)` count assertion is the operative check (wiremock fires the count assertion at mock server drop regardless of what response was registered). **Precondition:** the test profile config MUST lack a `team_field_id` setting — `tests/issue_create_jsm.rs::write_minimal_config` (~:165-173) satisfies this; verify no `team_field_id` key is introduced in the test's profile setup. This is what makes `(d) GET /rest/api/3/field` the first reachable HTTP on the guard-absent path: `src/cli/issue/helpers.rs::resolve_team_field` (~:43-47) reads `profile.team_field_id` and calls `find_team_field_id` only when it is `None`. The `--to me` myself form is chosen over `--to <query>` because it hits a single well-known endpoint, making the mock set minimal and unambiguous. (CMDB field discovery via `get_or_fetch_cmdb_fields` is post-POST/JSON-only per step 7 of the Guard Ordering; it is not a discriminating mock for this test.) **MockServer isolation constraint (FIFO, wiremock 0.6):** This test MUST NOT call `mount_platform_create_stubs` (`tests/issue_create_jsm.rs` ~:2395-2411) — that helper registers `POST /rest/api/3/issue` and `GET /rest/api/3/field` as free-fire mocks (no `.expect(0)`) BEFORE test-specific mocks are registered; wiremock 0.6 uses FIFO ordering so a free-fire mock registered first for the same path always matches before a subsequently-registered `expect(0)` mock, making the `expect(0)` assertion unreachable and the zero-HTTP proof invalid (CLAUDE.md §BC-3.9.006: "wiremock 0.6 uses FIFO ordering — first-registered mock wins for equal-priority mocks on the same path"). Instead, spin up a dedicated `MockServer` instance and register ONLY the `expect(0)` mocks (a)–(e) directly with NO free-fire mocks. Invocation (ii): `jr issue create --project PROJ --type Task --summary "test" --on-behalf-of X --team X --to me` (no `--request-type`; `--field a=b` replaced by `--on-behalf-of X`) — complete enough to reach helper HTTP + POST if the guard were absent; → exit 64; `stderr.contains("--on-behalf-of is only valid with")` (BC-3.8.013 prefix pin); REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; this invocation previously emitted the old warn string); HYGIENE (NOT DISCRIMINATING): `!stderr.contains("Created issue")` — same rationale as invocation (i): with an isolated MockServer (no free-fire success mocks), "Created issue" is structurally unreachable in either path; the discriminating proof is the `server.received_requests().await.unwrap().is_empty()` assertion on invocation (ii)'s dedicated isolated `MockServer` (same NORMATIVE zero-HTTP proof as invocation (i)); same `expect(0)` mocks (a)–(e) as invocation (i) (all DEFENSE-IN-DEPTH) (same endpoints and DEFENSE-IN-DEPTH / DISCRIMINATING annotations; see invocation (i) for the full mock set definition); same Precondition (test profile config MUST lack `team_field_id`); same MockServer isolation constraint (MUST NOT call `mount_platform_create_stubs`; spin up a dedicated `MockServer` instance separate from invocation (i)'s instance and register ONLY the `expect(0)` mocks (a)–(e) directly with NO free-fire mocks). S-639-1 F3 story deliverable.
AC-9 (NEW) `test_platform_create_field_without_project_exits_64_not_project_error` [mode: human]: EC-3.8.012-4 as test — `jr issue create --field a=b` with no `--project` and no profile project default → stderr contains BC-3.8.012 error substring (`"--field is only valid with"`), NOT a "project" error; exit 64; `stdout.trim().is_empty()` (hygiene — non-discriminating in human mode per BC-3.4.014); HYGIENE (NOT DISCRIMINATING): `!stderr.contains("Created issue")` — AC-9 is projectless BY DESIGN; even with the guard absent, the no-project run exits 64 on "Project key required" before ever creating an issue, so "Created issue" is structurally unreachable in either path; the discriminating proof is the project-error-ABSENCE pair: `stderr.contains("--field is only valid with")` AND `!stderr.contains("Project key")` (DISCRIMINATING: guard fires at step 2 before project-key resolution at step 3 — proves guard-before-project-RESOLUTION ordering; `--project` NOT required). Preconditions: (1) MUST use `.current_dir(<per-test TempDir>)` — `src/config.rs::find_project_config` (the private walk-up loop, ~:362) walks ancestor directories for `.jr.toml`; without an isolated `cwd` an ancestor `.jr.toml` with a `project` key silently supplies a default; ancestor-config isolation prevents inherited credentials from enabling a live HTTP escape (hygiene isolation, not a discriminating-power concern). (2) The test profile config MUST lack a `project` key — `tests/issue_create_jsm.rs::write_minimal_config` (~:165-173) already satisfies this; cite it as the config fixture. AC-8 SHOULD also use `.current_dir(<per-test TempDir>)` for the same hygiene reason. REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; this invocation previously emitted the old warn string). S-639-1 F3 story deliverable.
AC-10 (NEW) `test_platform_create_field_without_request_type_json_error_shape` [mode: --output json]: `jr issue create --project PROJ --type Task --summary "test" --field a=b --output json` (no `--request-type`; invocation is would-otherwise-succeed — `mount_platform_create_stubs` MUST be called so the platform POST can complete if the guard is absent; only a would-otherwise-succeed run makes `stdout.trim().is_empty()` a genuine DISCRIMINATING assertion rather than HYGIENE) → exit 64; `stdout.trim().is_empty()` (DISCRIMINATING: `create.rs` ~:249/:265 prints the created-issue JSON object to stdout on the success path — guard-absent with `mount_platform_create_stubs` would populate stdout; proves no success path executed); parse stderr as JSON and assert: `code == 64` AND `error` field contains `"--field is only valid with"`. Key order is serde_json map behavior (alphabetical by default without `preserve_order`; unspecified contractually — parse fields individually, do not match literal key order); output is compact, not pretty-printed. Use `tests/common/assertions.rs::assert_json_error_envelope` (promoted from `tests/json_error_shape.rs` per the F-1 promotion directive). **Precondition:** MUST use `.current_dir(<per-test TempDir>)` — `src/config.rs::find_project_config` (the private walk-up loop, ~:362) walks ancestor directories for `.jr.toml`; without an isolated `cwd` an ancestor `.jr.toml` with a `project` key silently interferes. Additionally, MUST use a pre-migrated `[profiles.default]`-shaped config fixture (see Config fixture contract in the Test Note above) — `assert_json_error_envelope` strict-parses ALL of stderr as JSON; `write_minimal_config`'s legacy `[instance]` shape triggers the one-time `src/config.rs` ~:255-287 migration line `"Migrated config to multi-profile layout…"` on first load, causing a guaranteed false-RED. Pairing: AC-10 (json mode) and AC-1 (human mode) are symmetric twins for the would-otherwise-succeed invocation class (`--field` with `--project`/`--type`/`--summary` + `mount_platform_create_stubs`, without `--request-type`) — AC-10 verifies the JSON envelope shape via `assert_json_error_envelope`; AC-1 verifies the human rendering path including the "Error: " prefix. Realizability notes: (i) `mod common;` in the test file pulls sibling modules; add `#[allow(dead_code)]` per the 60-file precedent and zero-warnings policy; (ii) the promoted helper asserts JSON shape only — the `error` field contains-assertion is written separately at the call site; (iii) the original fn definition in `tests/json_error_shape.rs` is DELETED in the same change; the three existing call sites in that file re-import from `tests/common/assertions.rs` — no duplicate definition. REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; this invocation previously emitted the old warn string). S-639-1 F3 story deliverable.
AC-11 (NEW) `test_platform_create_field_interactive_tty_exits_64_before_prompt` [mode: human/TTY]: set `JR_STDIN_IS_TTY=1` (debug seam, `src/main.rs` — suppresses auto-`--no-input` flip on non-TTY stdin) to simulate TTY mode. Invocation MUST NOT pass `--no-input` (`JR_STDIN_IS_TTY=1` cannot undo an explicit flag per `src/main.rs` ~:103-114; passing `--no-input` would exercise the non-interactive path, not the interactive path). Invocation MUST NOT pass `--project` (else the no-prompt fallback also exits 64, making the guard vs. prompt distinction indistinguishable). Invocation: `jr issue create --field a=b` (no `--request-type`, no `--project`, no `--no-input`). Required assertions (these five together; items (1)+(2) are the discriminating proof that the pre-flight guard fires BEFORE project-key resolution at step 3; items (3)/(4)/(5) are hygiene): (1) `stderr.contains("--field is only valid with")` — positive guard assertion; (2) `!stderr.contains("Project key")` — absence of the "Project key is required" error string (`create.rs` ~:102-108, ok_or_else after `prompt_input` yields `None`); DISCRIMINATING as guard-before-project-RESOLUTION proof; (3) HYGIENE (NOT DISCRIMINATING): `!stderr.contains("Created issue")` — AC-11 is bare-MockServer + projectless by design; even with the guard absent, the no-project run exits 64 on the "Project key is required" error from `create.rs` ~:102-108 (never creating an issue), so "Created issue" is structurally unreachable in either path; the discriminating proof is the positive guard-string assertion + the Project-key-error-absence pair; (4) exit 64 — `cmd.assert().failure().code(64)` (HYGIENE: projectless invocation — guard-absent also exits 64 on project error from `create.rs` ~:102-108; same reasoning as AC-9/AC-17; the exit-code alone cannot distinguish guard exit from project-error exit; items (1)+(2) are the discriminating proof; the mode-agnosticism invariant is verified by item (1)'s positive guard-string assertion on the TTY path); (5) `stdout.trim().is_empty()` (output-channel hygiene — on the guarded path no success data is emitted to stdout in any mode; consistent with all other human-mode AC assertions in this family). **Non-goal and AC-11 purpose:** dialoguer 0.12 `interact_text()` short-circuits (`ErrorKind::NotConnected`) on non-TTY stderr under `assert_cmd` — the project-key prompt label NEVER renders to any channel; `JR_STDIN_IS_TTY=1` only suppresses the auto-`--no-input` flip, it does NOT make dialoguer interactive. The true dialoguer-interactive branch (prompt label visible to user) is untestable without a PTY harness — deliberate non-goal for S-639-1. AC-11's residual unique value is exercising the `JR_STDIN_IS_TTY=1` no-auto-flip path: without this seam, the auto-`--no-input` flip at `src/main.rs` ~:103-114 fires on non-TTY stdin and would exercise the non-interactive path instead. Note: wiremock `expect(0)` on all endpoints is NON-DISCRIMINATING — the guard-absent path (guard removed) also exits 64 with zero HTTP on the "Project key is required" error on a no-project invocation; the stderr substring triple is the only reliable discriminator. **MockServer isolation constraint (FIFO, wiremock 0.6):** This test MUST NOT call `mount_platform_create_stubs` (`tests/issue_create_jsm.rs` ~:2395-2411) — that helper registers free-fire mocks (no `.expect(0)`) that would defeat any subsequently-registered `expect(0)` mock via wiremock 0.6 FIFO ordering (CLAUDE.md §BC-3.9.006: "first-registered mock wins for equal-priority mocks on the same path"). Since AC-11 does not rely on `expect(0)` mocks (already non-discriminating per above), no wiremock mock handlers are needed — spin up a bare `MockServer` with no registered handlers; any request returns 404 automatically. **Precondition:** MUST use `.current_dir(<per-test TempDir>)` — `src/config.rs::find_project_config` (the private walk-up loop, ~:362) walks ancestor directories for `.jr.toml`; without an isolated `cwd` an ancestor `.jr.toml` with a `project` key silently supplies a default; ancestor-config isolation prevents inherited credentials from enabling a live HTTP escape (hygiene isolation, not a discriminating-power concern). REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; this invocation previously emitted the old warn string). S-639-1 F3 story deliverable.
AC-12 (NEW) `test_platform_create_help_flags_requires_request_type_in_help` [mode: human help]: `jr issue create --help` — assert: collapse all whitespace runs (including newlines) in `stdout` to single spaces first (e.g. `stdout.split_whitespace().collect::<Vec<_>>().join(" ")`), then assert `.matches("requires --request-type").count() == 2`. This normalization is mandatory — clap 4's next-line help layout may wrap long doc strings across multiple lines, causing the substring to straddle a newline and producing a false-zero count on the raw string. This pins that BOTH `--field` and `--on-behalf-of` help entries contain the substring. A single `stdout.contains("requires --request-type")` is insufficient (passes with only one flag updated). The per-flag same-line split approach is NOT prescribed. Count-after-normalization is the single correct prescription. Pins delivery item (d) help-string update. **Coupling note:** `count() == 2` assumes no OTHER flag's help text contains `"requires --request-type"` — revisit the assertion count if help text grows and a new flag adopts the same phrase. S-639-1 F3 story deliverable.
AC-13 (NEW) `test_platform_create_combined_empty_on_behalf_with_field_exits_64_combined_error` [mode: human]: EC-3.8.012-1 as test — `jr issue create --project PROJ --type Task --summary "test" --on-behalf-of "" --field a=b` (no `--request-type`; invocation is would-otherwise-succeed — guard-absent path reaches HTTP, making `received_requests().is_empty()` genuinely NORMATIVE) → combined-error string present (`stderr.contains("--field and --on-behalf-of are only valid with")`); exit 64; single-flag strings absent (per AC-3 assertion spec; both FALSIFIABLE-COARSE: an implementation that fires two single guards independently instead of the combined guard would be caught by these). Covers EC-3.8.012-1 sub-case where `--on-behalf-of ""` (empty string value) co-occurs with `--field`. Discrimination: guard fires at step 2 (before project-key resolution at step 3); the positive combined-error `stderr.contains` assertion discriminates against the missing-project-key fallback (would-otherwise-succeed invocation — `--project` supplied). REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (DISCRIMINATING subtype — the invocation `--project PROJ --type Task --summary "test" --on-behalf-of "" --field a=b` previously emitted BOTH old warn strings, one from the old `!field_pairs.is_empty()` guard at `create.rs` ~:81 and one from the old `is_some()` guard at ~:86; re-introduction of either old guard would cause one or both warn strings to appear). **Zero-HTTP assertion:** spin up a dedicated isolated `MockServer` instance (no registered handlers); after the command completes, assert `server.received_requests().await.unwrap().is_empty()` (NORMATIVE zero-HTTP proof — the combined pre-flight guard fires at step 2, BEFORE any project-key resolution or HTTP; same primitive as AC-8's per-invocation `MockServer`; invocation is would-otherwise-succeed: guard-absent path reaches helper HTTP + POST on the isolated MockServer (returning 404), making `received_requests()` non-empty; the zero-HTTP assertion is DISCRIMINATING. `mount_platform_create_stubs` is NOT called — isolated MockServer only; any request to the server = test fails = guard absent detected (same MockServer isolation constraint as AC-8)). S-639-1 F3 story deliverable.
AC-14 (NEW) `test_platform_create_empty_request_type_routes_jsm_not_bc_3_8_012` [mode: human]: EC-3.8.012-2 as test — `jr issue create --project PROJ --field a=b --request-type ""` → BC-3.8.016 fires (empty RT guard inside JSM path), NOT BC-3.8.012; exit 64; POSITIVE ASSERTION: `stderr.contains("request type cannot be empty")` (BC-3.8.016 canonical error string per bc-3-issue-write.md §BC-3.8.016); NEGATIVE ASSERTION: `!stderr.contains("--field is only valid with")` (DISCRIMINATING: invocation has `--field` + `--request-type ""`; BC-3.8.012 would fire if the guard precedes the JSM dispatch fork — this proves the guard is correctly placed AFTER the fork). `--project PROJ` is REQUIRED: `handle_jsm_create` resolves project key at step 0 BEFORE the empty-RT guard at step 1 (`src/cli/issue/jsm_create.rs` ~:124 vs ~:145); without `--project`, the run exits 64 on "Project key is required" never reaching BC-3.8.016. S-639-1 F3 story deliverable.
AC-15 (NEW) `test_platform_create_conflicting_flags_exit_2_not_64_clap_precedence` [mode: human]: EC-3.8.012-8 as test — `jr issue create --field a=b --to me --account-id X` (clap `conflicts_with` pair: `--to` conflicts with `--account-id`) → clap exit 2 (NOT exit 64); stderr does NOT contain `"--field is only valid with"` (HYGIENE: clap exit-2 fires before `handle_create` is entered; the guard is structurally unreachable on any clap-rejected invocation). Clap parse-level rejection precedes handle_create entirely. S-639-1 F3 story deliverable.
AC-16 (NEW) `test_platform_create_on_behalf_empty_string_exits_64_013_error` [mode: human]: EC-3.8.013-1 as test — `jr issue create --on-behalf-of ""` (empty value, `--field` absent, no `--request-type`) → BC-3.8.013 fires; stderr contains `"--on-behalf-of is only valid with"` (prefix pin); `stderr.contains("--on-behalf-of is only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to raise a request on behalf of another user, or drop --on-behalf-of to create a standard platform issue.")` (FULL-STRING pin — single-source for the BC-3.8.013 single-flag verbatim string; other ACs use prefix pins only); AND does NOT contain `"--field and --on-behalf-of are only valid with"` (combined string; FALSIFIABLE-COARSE: invocation has `--on-behalf-of` without `--field`; catches gross defect where combined guard fires when only `--on-behalf-of` is present); exit 64. REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (DISCRIMINATING subtype: `--on-behalf-of ""` previously emitted the old warn string — `is_some()` at `src/cli/issue/create.rs` ~:86 caught non-None values including empty string; the pin proves the warning is absent post-DEC-188). Discrimination: guard fires at step 2 (before project-key resolution at step 3); the positive `stderr.contains("--on-behalf-of is only valid with")` discriminates against the missing-project-key fallback — `--project` NOT required. **Precondition:** MUST use `.current_dir(<per-test TempDir>)` — `src/config.rs::find_project_config` (the private walk-up loop, ~:362) walks ancestor directories for `.jr.toml`; without an isolated `cwd` an ancestor `.jr.toml` with a `project` key silently supplies a default; on AC-16 this matters doubly: (a) ancestor-config isolation prevents inherited credentials from enabling a live HTTP escape — hygiene isolation, not a discriminating-power concern (guard-absent path fails on missing `--type` before any HTTP, so discriminating power is not affected by an inherited project key); (b) AC-16 is the FULL-STRING single source for the BC-3.8.013 verbatim error string — an ancestor `.jr.toml` supplying credentials could enable an actual HTTP round-trip, risking a live Jira mutation. S-639-1 F3 story deliverable.
AC-17 (NEW) `test_platform_create_markdown_with_field_exits_64_bc_3_8_012_not_markdown_error` [mode: human]: EC-3.8.012-5 as test — `jr issue create --markdown --field description=x` (no `--request-type`) → exit 64; `stderr.contains("--field is only valid with")`; `!stderr.contains("cannot be combined with `--markdown`")` (HYGIENE: BC-3.8.017's string lives only inside `handle_jsm_create` at `src/cli/issue/jsm_create.rs` ~:160, unreachable without `--request-type` routing through the fork at `src/cli/issue/create.rs` ~:49; no guard defect — absent, mis-ordered, or hoisted — can surface it on this invocation; same structural unreachability class as AC-15; substring narrowed to the `` `--markdown` ``-specific form — the bare `"cannot be combined with"` prefix is also present in `src/cli/issue/edit.rs::handle_edit`'s `"--label cannot be combined with"` message, which is unreachable from `handle_create` but broadened the assertion beyond what the rationale claimed; F57-001); real discriminating pair: (1) `stderr.contains("--field is only valid with")` (positive — BC-3.8.012 guard fired) AND (2) `!stderr.contains("Project key")` (DISCRIMINATING: guard fires at step 2 before project-key resolution at step 3 — proves guard-before-project-lookup ordering; `--project` NOT required). **Precondition:** MUST use `.current_dir(<per-test TempDir>)` — `src/config.rs::find_project_config` (the private walk-up loop, ~:362) walks ancestor directories for `.jr.toml`; without an isolated `cwd` an ancestor `.jr.toml` with a `project` key silently supplies a default; ancestor-config isolation prevents inherited credentials from enabling a live HTTP escape (hygiene isolation, not a discriminating-power concern). REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; this invocation previously emitted the old warn string). S-639-1 F3 story deliverable.
AC-18 (NEW) `test_platform_create_description_stdin_with_field_exits_64_stdin_not_consumed` [mode: human]: EC-3.8.012-7 as test — `jr issue create --project PROJ --type Task --summary "test" --field a=b --description-stdin` (no `--request-type`) with stdin piped (non-TTY; invocation is would-otherwise-succeed — `mount_platform_create_stubs` MUST be called so the success path can complete if the guard is absent; only a would-otherwise-succeed run makes `!stderr.contains("Created issue")` a genuine DISCRIMINATING NEGATIVE rather than HYGIENE). Normative assertions: exit 64; `stderr.contains("--field is only valid with")`; `stdout.trim().is_empty()` (hygiene — non-discriminating in human mode per BC-3.4.014); DISCRIMINATING NEGATIVE: `!stderr.contains("Created issue")` (proves no success path executed — FALSIFIABLE because the complete invocation with `mount_platform_create_stubs` would echo "Created issue" on stderr if the guard were absent). Discrimination: guard fires at step 2 (before `--description-stdin` blocking read at step 4a); positive `stderr.contains` discriminates against the missing-project-key fallback. Non-normative rationale (context only, not a test assertion): the guard fires at step 2 of the platform-path ordering — before `--description-stdin`'s blocking read at step 4a (`src/cli/issue/create.rs::handle_create` ~:132-145); consequently stdin is never consumed and the process exits immediately. Note [corrected v1.3.151]: `assert_cmd` 2.2.2 exposes a public `Command::timeout(&mut self, timeout: std::time::Duration) -> &mut Self` method (see `assert_cmd` crate docs — the method is present in 2.2.2, verified against `Cargo.lock`), so the two assertions previously conflated are NOT equivalent — (1) **"process exits promptly" IS testable**: `.timeout(Duration::from_secs(N)).assert().failure()` would fail if the process hung; (2) **"stdin NOT consumed" is still NOT testable**: `.timeout()` proves the process did not hang, but does NOT prove stdin was never read — there is no `assert_cmd` primitive that observes whether the child process consumed stdin. Design decision (ii): the timeout assertion is explicitly declined as a normative assertion for AC-18. A wall-clock assertion is sensitive to CI load (slow machines, resource contention) and adds no discriminating power: the exit-64 + `stderr.contains("--field is only valid with")` pair already proves the guard fired at step 2, before the step-4a blocking read; a timeout cannot distinguish guard-fired-early from guard-absent-but-fast. The piped string is supplied to prevent any unforeseen blocking; the discriminating proof is exit 64 + stderr substring. REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (per §"Removal postcondition (single-site, DEC-188)" — not vacuous; this invocation previously emitted the old warn string). S-639-1 F3 story deliverable.
AC-19 (NEW) `test_platform_create_field_empty_value_exits_64_bc_3_8_012` [mode: human]: EC-3.8.012-9 as test — `jr issue create --project PROJ --type Task --summary "test" --field a=` (key present, empty VALUE after `=`, no `--request-type`; invocation is would-otherwise-succeed — `mount_platform_create_stubs` MUST be called so the success path can complete if the guard is absent; only a would-otherwise-succeed run makes `!stderr.contains("Created issue")` a genuine DISCRIMINATING NEGATIVE rather than HYGIENE) → exit 64; `stderr.contains("--field is only valid with")`; stdout MUST be empty (`stdout.trim().is_empty()`, hygiene — non-discriminating in human mode per BC-3.4.014); DISCRIMINATING NEGATIVE: `!stderr.contains("Created issue")` (proves no success path executed — FALSIFIABLE because the complete invocation with `mount_platform_create_stubs` would echo "Created issue" on stderr if the guard were absent). Guard fires on `!field_pairs.is_empty()` (presence-only check; value contents are never parsed at this stage). Distinct from EC-3.8.012-3's malformed-no-equals class (`--field ""` without `=` falls into that class, not this one). Discrimination: guard fires at step 2 (before project-key resolution at step 3); positive `stderr.contains("--field is only valid with")` discriminates against the missing-project-key fallback. REGRESSION PIN: `!stderr.contains("is ignored on the platform create path")` (DISCRIMINATING subtype — the invocation `--field a=` previously triggered the old `!field_pairs.is_empty()` guard at `create.rs` ~:81 which emitted the warn string; re-introduction of that old guard would cause the warn string to appear). S-639-1 F3 story deliverable.
AC-20 (NEW) `test_jsm_create_with_on_behalf_of_and_request_type_does_not_fire_bc_3_8_013` [mode: --output json]: `jr issue create --project HELP --summary "test" --on-behalf-of X --request-type <NAME> --output json` (with `--request-type` present; `--project HELP` and `--summary "test"` are REQUIRED — `handle_jsm_create` exits 64 on project-key absence at `src/cli/issue/jsm_create.rs` ~:124-140 and on missing summary at ~:245-257, making exit 0 impossible without them; match AC-14's precondition pattern) → exit 0 (success path — BC-3.8.013 guard MUST NOT fire because `--request-type` routes to JSM path); assert THREE new-error strings absent: `!stderr.contains("--on-behalf-of is only valid with")` (DISCRIMINATING: invocation has `--on-behalf-of` + `--request-type`; guard would fire if `--request-type` were absent or not gated correctly) AND `!stderr.contains("--field is only valid with")` (HYGIENE: invocation has no `--field`) AND `!stderr.contains("--field and --on-behalf-of are only valid with")` (FALSIFIABLE-COARSE: invocation has no `--field`; catches gross defect where combined guard fires when only `--on-behalf-of` is present — see AC-21 for the fully-falsifiable combined-path test) — BC-3.8.013 must remain silent when `--request-type` IS present on the JSM path. Mirrors AC-6 (which pins the same falsifiable non-mis-fire property for `--field`); AC-20 provides the complementary falsifiable pin for `--on-behalf-of`. MockServer setup: call the three JSM create stubs already used by AC-6's live test: `mount_project_meta_help` (`tests/issue_create_jsm.rs` ~:24, project-type resolution), `mount_service_desk_list` (~:52, service desk ID resolution), and `mount_request_types_password_reset` (~:121, request-type partial-match); plus `POST /rest/servicedeskapi/request returning jsm_created_response()` (per `tests/issue_create_jsm.rs` ~:2758-2763). Use `<NAME>` matching the mock's registered request-type name (e.g. `"Password Reset"` per ~:121, `tests/issue_create_jsm.rs` ~:135). `--on-behalf-of X` is passed through the JSM request body as `raiseOnBehalfOf` (BC-3.8.009); the mock accepts it as a body field. S-639-1 F3 story deliverable.
AC-21 (NEW) `test_jsm_create_with_both_flags_and_request_type_does_not_fire_guards` [mode: --output json]: `jr issue create --project HELP --summary "test" --field a=b --on-behalf-of X --request-type <NAME> --output json` (with `--request-type` present, BOTH `--field` AND `--on-behalf-of` supplied; `--project HELP` and `--summary "test"` are REQUIRED — same precondition as AC-20; exit 0 impossible without them per `handle_jsm_create` at `src/cli/issue/jsm_create.rs` ~:124-140 and ~:245-257) → exit 0 (success path — both guards MUST NOT fire because `--request-type` routes to JSM path). This is the ONLY invocation that falsifies the combined guard on the JSM path. Assertions: ALL THREE new-error strings absent: `!stderr.contains("--field is only valid with")` (DISCRIMINATING: invocation has `--field` + `--request-type`; single-flag guard fires if `--request-type` not gated) AND `!stderr.contains("--on-behalf-of is only valid with")` (DISCRIMINATING: invocation has `--on-behalf-of` + `--request-type`; single-flag guard fires if `--request-type` not gated) AND `!stderr.contains("--field and --on-behalf-of are only valid with")` (DISCRIMINATING: invocation has BOTH flags + `--request-type`; combined guard fires if `--request-type` not gated — this is the discriminating negative AC-6 and AC-20 cannot provide). MockServer setup: same real trio as AC-20 — `mount_project_meta_help` (`tests/issue_create_jsm.rs` ~:24), `mount_service_desk_list` (~:52), `mount_request_types_password_reset` (~:121), plus `POST /rest/servicedeskapi/request returning jsm_created_response()` (per `tests/issue_create_jsm.rs` ~:2758-2763). Both `--field a=b` (→ `requestFieldValues.a`) and `--on-behalf-of X` (→ `raiseOnBehalfOf`, BC-3.8.009) are passed through the JSM request body; the mock accepts them. S-639-1 F3 story deliverable.
S-639-1 delivery (F4) obligations — same PR as the code change; story checklist items at F3: (a) `docs/adr/0014-jsm-request-type-dispatch.md` "platform path byte-for-byte unchanged" claim — four sites: (~:60 "The platform path has no changes — it is byte-for-byte the same code path"), (~:73-76 "Platform path stability guarantee: … No platform-path behavior, output shape, or error message is altered"), (~:159-160 "No other `jr issue create` invocation is affected." — false post-DEC-188: `--field`/`--on-behalf-of` without `--request-type` now exits 64 on the platform path), and (~:161) — add amendment note at ALL FOUR sites (DEC-188 adds pre-flight guards; claim is now conditional on `--field`/`--on-behalf-of` being absent); (~:42-45 "Rather than silently dropping these flags or erroring on them before verifying the project is a JSM project at all…" — rationale sentence) is EXCLUDED from amendment — its antecedent is the six platform-only flags (BC-3.8.010 + BC-3.8.011 directions, unchanged by DEC-188) and it remains accurate; (b) `CLAUDE.md:~248` dispatch-fork gotcha "absent → platform path byte-for-byte unchanged" — qualify with DEC-188 pre-flight guards; (c) `Cargo.toml` version bump to 0.6.0-dev.12 (DEC-188 breaking change) + `CHANGELOG.md` `### Breaking Changes` entry citing DEC-188, BC-3.8.012/013, and the `--field`/`--on-behalf-of` exit-64 change; (d) `src/cli/mod.rs` help strings — update the FIRST doc-comment line only for each flag: `--field` first doc line (~:398, currently `"Additional request field values as NAME=VALUE pairs (repeatable)."`) → `"Set a custom request field as NAME=VALUE (repeatable; JSM only; requires --request-type)."` — `(repeatable)` is preserved in the replacement because it lives on the first line; the subsequent split-semantics line (~:399, `"The first '=' splits…"`) and duplicate-keys line (~:400, `"Duplicate keys use the last value provided. Applies to JSM requests only."`) are PRESERVED — except the trailing `"Applies to JSM requests only."` sentence on ~:400 is DELETED at F4 (the new first line already carries `"JSM only"`; avoids stating it twice). `--on-behalf-of` first doc line (~:403, currently `"Raise the JSM request on behalf of this accountId (JSM requests only)."`) → `"Create the request on behalf of this accountId (JSM only; requires --request-type)."` — the subsequent `raiseOnBehalfOf` mapping line (~:404) is PRESERVED. Both `#[arg(...)]` attribute lines are untouched. `"requires --request-type"` must appear unbroken in each first doc line so AC-12's count assertion (`stdout.matches("requires --request-type").count() == 2`) passes. Verified by AC-12. (e) `src/cli/issue/jsm_create.rs` ~:171-172 comment — the comment falsely claims a platform-path `--markdown` guard parity; correct the comment at F4 (no such platform-path guard exists; EC-3.8.012-5 is authoritative: the BC-3.8.012 guard fires at step 2 before any `--markdown`→ADF conversion, so the parallel-parity claim in the comment is misleading); additionally, the sibling comment at `tests/issue_create_jsm.rs` ~:2323-2326 carries the same false platform-parity claim AND a dead "lines 333-343" source citation — correct BOTH comments at F4 (EC-3.8.012-5 authoritative for those two sites); additionally, a THIRD stale-parity site at `tests/issue_create_jsm.rs` ~:2373-2374 carries the same false platform-parity claim AND a dead "create.rs lines 333-343" citation (the markdown-requires-description string exists only in `jsm_create.rs` ~:175 + `edit.rs` ~:89) — correct this comment at F4 as well (EC-3.8.012-5 authoritative for all three sites). (f) `docs/specs/issue-create-preflight-guards.md` — author a product-facing feature spec at F3 per CLAUDE.md convention (ADR-0004 per-feature-spec pattern; same precedent as `docs/specs/issue-move-resolution.md`). Minimum content: the new exit-64 behavior for `--field`/`--on-behalf-of` without `--request-type` (DEC-188), both verbatim error strings (single-flag and combined), step-2 guard placement in `handle_create`, and links to BC-3.8.012/013. **No new ADR:** ADR-0014's dispatch architecture is unchanged (JSM fork remains at step 1; pre-flight guards add step 2 on the platform branch only); only ADR-0014's byte-for-byte stability claims are amended per item (a) above — record this no-ADR rationale explicitly in the spec. (g) E2E impact — DISCHARGED at F2 (F64-001, 2026-07-28): `tests/e2e_live.rs` scanned for `issue create` invocations carrying `--field` or `--on-behalf-of` without `--request-type`. Result: zero found. All 8 `--field` occurrences in the file are `issue edit --field` (live call site ~:5111; remainder are doc-comment and env-var-table references for `JR_E2E_EDIT_FIELD`); zero `--on-behalf-of` occurrences. Conclusion: no live-run scenario flips to exit-64 under DEC-188; no E2E test changes required at F4. Obligation source: `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md` § "2. Regression Risk Assessment" (#639 row, `src/cli/issue/create.rs`).
**Source**: SOH-DX-1 DEC-188 F2 (2026-07-25, #639); supersedes issue #383 F2 warn-and-proceed behavior.
**Confidence**: HIGH

**Note (coverage non-goal) [SUPERSEDED BY F2 GATE HUMAN RULING 2026-07-29]:** The F51-001 non-goal rationale was overridden by the F2 gate human ruling (2026-07-29): 6 holdout scenarios H-NEW-PREFLIGHT-001..H-NEW-PREFLIGHT-006 now provide holdout coverage for BC-3.8.012 and BC-3.8.013 in holdout-scenarios.md Group 20 (SOH-DX-1 F2 authoring). F51-001 rationale (retained for historical record): Holdout-scenario and VP coverage were a deliberate non-goal for S-639-1. The 21 ACs (AC-1..21) fully cover every observable exit path for both BC-3.8.012 and BC-3.8.013: exit code, both output modes (human and `--output json`), all three verbatim error strings, zero-HTTP proof, idempotency, ordering precedence, and JSM-path non-mis-fire. Because both guards are pure pre-flight input-validation checks with no network interaction, there is no integration surface for a holdout scenario to probe — any holdout assertion would duplicate what the ACs already assert. Contrast with VP-331-003 (BC-3.4.019, cross-project `--type` guard): that guard requires a project-scoped `GET createmeta` API call to resolve the issue-type ID, giving it a verification surface that pre-flight string-presence guards lack.

[ADDED 2026-05-19 issue #383 F2 → AMENDED 2026-07-25 SOH-DX-1 DEC-188 #639 (warn-and-proceed → pre-flight exit-64) → SUPERSEDED 2026-08-25 issue #578 (--field guard removed; see [CURRENT BEHAVIOR] below)]

---

**[CURRENT BEHAVIOR — effective 2026-08-25, issue #578]**

**Confidence**: HIGH
**Subject**: Issue write (platform path cross-flag interaction) — `--field` guard REMOVED
**Behavior**: `jr issue create --field NAME=VALUE` (repeatable) WITHOUT `--request-type` no longer
exits 64. The platform (non-JSM) path resolves each `--field` pair via `createmeta` and merges
the result into the create POST body — see BC-3.3.010 for the full resolution algorithm and
BC-3.3.011 for the error taxonomy. Guard placement change: the DEC-188 `!field_pairs.is_empty()`
pre-flight check (previously immediately after the JSM dispatch fork, step 2 of the Platform-Path
Guard Ordering the `[DEC-188 BEHAVIOR]` block above describes) is REMOVED from the `--field`-alone
branch. The COMBINED check (both `--field` AND `--on-behalf-of` present) is ALSO removed — since
`--field` alone is no longer an error condition, a combined guard has no remaining trigger; only
BC-3.8.013's standalone `--on-behalf-of`-alone check survives, unmodified.

**Inputs**: `--field NAME=VALUE` (one or more) WITHOUT `--request-type` — no longer an error input on its own.
**Outputs/Effects**: Field(s) resolved via createmeta and merged into the platform POST body (BC-3.3.010). Exit code reflects normal create-path success/failure (0 on success; resolution failures exit 64 per BC-3.3.011; HTTP failures per standard `JrError` mapping) — NOT the DEC-188 pre-flight exit-64.
**Errors**: See BC-3.3.011 error taxonomy. No `"--field is only valid with --request-type"` error is ever emitted for `--field` alone (that string is now DEAD — removed from `src/cli/issue/create.rs`). Stderr MUST NOT contain that substring on any `--field`-alone invocation without `--request-type`.

**F3/F4 removal obligations** (mirrors the DEC-188 removal-postcondition discipline it is itself removing): the `--field`-alone pre-flight check and its verbatim error string MUST be deleted from `src/cli/issue/create.rs`; the COMBINED-check MUST be narrowed to an `--on-behalf-of`-alone check (BC-3.8.013, unmodified); every test asserting the OLD `"--field is only valid with"` / combined-error strings on a `--field`-alone or combined invocation MUST be updated to assert the NEW createmeta-resolution success/error paths instead (test inversion, mirroring DEC-188's own AC-1/2/3/5/7 inversion discipline the first time around — see the `[DEC-188 BEHAVIOR]` block's own removal-postcondition text for the shape of this obligation); `src/cli/mod.rs` `--field` help text's "requires --request-type" clause (added by DEC-188 item (d) above) MUST be reverted/reworded since it is no longer accurate for the platform path (the flag now works with OR without `--request-type`, routing to `fields`/createmeta vs `requestFieldValues` respectively per BC-3.8.008's amendment); **AC-12 obligation (F5 pass-4 F1, supersedes the AC-12 spec above): the pinned help-text substring count changes from `== 2` to `== 1`, scoped to the `--on-behalf-of` help line only** — `--field`'s help line no longer carries `"requires --request-type"` at all (its removal is the DEC-310 reversal itself), so `stdout.matches("requires --request-type").count()` MUST assert `== 1` post-reversal, not `== 2`; `docs/adr/0014-jsm-request-type-dispatch.md`'s DEC-188 amendment notes (the four sites DEC-188 itself cites in its own delivery obligations, item (a) above) need a FURTHER amendment noting the `--field` guard's removal; CHANGELOG `### Changed` entry per the Migration note above; **retire/rewrite holdout scenarios H-NEW-PREFLIGHT-001, H-NEW-PREFLIGHT-003, and H-NEW-PREFLIGHT-006** (`.factory/specs/prd/holdout-scenarios.md`) to the reversed contract — all three formerly pinned the now-dead exit-64 pre-flight assertion this reversal removes and MUST be rewritten in place (not left MUST-PASS against a superseded contract) to assert the NEW createmeta-resolution success/error paths (VP-578-017/018): H-NEW-PREFLIGHT-001 and H-NEW-PREFLIGHT-003 cover the human-mode `--field`-alone and combined-flag invocations respectively; H-NEW-PREFLIGHT-006 is the `--output json` mode counterpart of H-NEW-PREFLIGHT-001 (JSON success envelope on stdout, no error envelope). H-NEW-PREFLIGHT-002 (`--on-behalf-of` alone) is UNCHANGED and MUST NOT be touched — that guard survives this reversal.

**Edge Cases**: BC-3.3.010/011's edge-case catalog now governs `--field`-alone platform-path behavior. The DEC-188-era `EC-3.8.012-*` edge cases in the `[DEC-188 BEHAVIOR]` block above **(EC-3.8.012-1 through -10 — corrected range, adversary pass-9 L-1; the block contains ten entries, not seven)** are SUPERSEDED for their `--field`-alone sub-cases; EC-3.8.012-1's combined-check reference is now STALE (the combined check no longer exists) — retained above under `[DEC-188 BEHAVIOR, superseded]` for audit trail only, not as current contract. EC-3.8.012-9 (`--field a=`, key present with an explicitly empty VALUE after `=`; the presence-only guard fired on it under DEC-188) is a live `--field`-alone exit-64 assertion and is FULLY SUPERSEDED by this reversal — the invocation now proceeds to the createmeta-resolution success/error paths per VP-578-017, not the removed pre-flight guard. EC-3.8.012-2 (empty/whitespace `--request-type` routes to JSM path, BC-3.8.016 fires) and EC-3.8.012-6 (config/auth failures precede any guard) remain ACCURATE as general statements about guard-ordering but no longer describe an ERROR outcome for `--field` specifically — `--field` with an empty `--request-type` still routes to the JSM path (unaffected by this reversal) where BC-3.8.016 governs. EC-3.8.012-8 (clap `conflicts_with` parse-level rejections precede the guard) and EC-3.8.012-10 (the DEC-188 guard was project-type-agnostic) likewise remain ACCURATE as ORDERING facts only — clap-level rejection still precedes platform-path handler logic, and `handle_create` still cannot know project type before project-key resolution — but neither describes a `--field`-alone ERROR outcome any longer, since the guard they were ordering relative to no longer exists on the `--field`-alone path.

**Verification Properties**:
- VP-578-017: `jr issue create --field a=b` (no `--request-type`, well-formed field) → exit 0, platform POST fires with the resolved field merged in; stderr does NOT contain `"--field is only valid with"`.
- VP-578-018: `jr issue create --field a=b --on-behalf-of X` (no `--request-type`) → exit 64 via BC-3.8.013's STANDALONE `--on-behalf-of` guard (not the now-removed combined guard); stderr contains BC-3.8.013's single-flag error string, NOT the old combined-error string.
- VP-578-019 (regression pin): `jr issue create --on-behalf-of X` alone (no `--field`, no `--request-type`) → exit 64 via BC-3.8.013, UNCHANGED wire-for-wire from the DEC-188-era behavior — proves this reversal did not accidentally weaken BC-3.8.013.

**Trace**: issue #578 item 2; DEC-310 (proposed, this amendment); supersedes DEC-188 (#639, 2026-07-25) for the `--field`-alone and combined-guard cases only; BC-3.3.010/011 (new resolution + error taxonomy this guard removal delegates to); BC-3.8.008 (JSM-path `--field` amendment, wire-target substitution note); BC-3.8.013 (unmodified, `--on-behalf-of` guard survives standalone)

[AMENDED 2026-08-25 issue #578 F2: DEC-188's --field-alone and combined guards REVERSED; --on-behalf-of guard (BC-3.8.013) unaffected; DEC-310 proposed to record this reversal]

---

#### BC-3.8.013: `--on-behalf-of` on platform path without `--request-type` exits 64 pre-flight

> **[CURRENT BEHAVIOR — effective 2026-08-25, issue #578]**
> Post-reversal (see BC-3.8.012's `[AMENDED 2026-08-25 issue #578, DEC-310 (proposed)]` note
> above): BC-3.8.012's COMBINED pre-flight check (both `--field` AND `--on-behalf-of` present) is
> REMOVED — it has no remaining trigger, since `--field` alone is no longer an error condition.
> This BC's guard is **unchanged and unaffected** by the reversal: `--on-behalf-of` presence
> without `--request-type` still exits 64 with the STANDALONE `--on-behalf-of`-only error string
> below. What changes is the TRIGGER SCOPE: this standalone guard now fires whenever
> `--on-behalf-of` is present without `--request-type` — **including when `--field` is ALSO
> present**. Previously (DEC-188-era), the combined check pre-empted this BC in that case and
> emitted the combined error string instead; that pre-emption no longer exists, so the standalone
> `--on-behalf-of`-only string is now the ONLY error a `--field` + `--on-behalf-of` combined
> invocation (without `--request-type`) can produce. `--field` no longer contributes to any
> pre-flight error on the platform path — see BC-3.8.012 `[CURRENT BEHAVIOR — effective
> 2026-08-25]` and BC-3.3.010/BC-3.3.011 for `--field`'s new createmeta-resolution contract.
> Confirmed by VP-578-018 (`jr issue create --field a=b --on-behalf-of X` → exit 64 via THIS BC's
> standalone guard, not the dead combined guard) and by holdout H-NEW-PREFLIGHT-003 (rewritten to
> assert the standalone-guard outcome, not the removed combined-error outcome). See the "Combined
> pre-flight error" subsection below, rewritten in place to reflect this, and EC-3.8.013-1, also
> updated.

> **[AMENDED 2026-07-25 SOH-DX-1 DEC-188 #639]** Prior behavior (warn-and-proceed, exit 0) superseded-in-part by pre-flight exit-64. Old contract text preserved below under [PRIOR BEHAVIOR] for audit trail. Breaking change ships v0.6.0-dev.12. See S-639-1 F3 story for test inversions. New contract in [CURRENT BEHAVIOR] below.

> **[PRIOR BEHAVIOR, superseded 2026-07-25]** When `jr issue create` was invoked WITHOUT `--request-type` but WITH `--on-behalf-of <ACCOUNT_ID>`, the handler emitted ONE warning to stderr BEFORE the platform POST. Warning string: `"warning: --on-behalf-of is ignored on the platform create path; it only applies with --request-type (JSM service-desk requests). To raise a request on behalf of another user, also supply --request-type."` Platform POST then proceeded normally; exit code was 0. BC-3.8.012 and BC-3.8.013 fired independently when both flags were present; both warnings appeared on stderr.

---

**[CURRENT BEHAVIOR — effective 2026-07-25 DEC-188]**

**Confidence**: HIGH
**Subject**: Issue write (platform path cross-flag interaction)
**Behavior**: When `jr issue create` is invoked WITHOUT `--request-type` but WITH
`--on-behalf-of <ACCOUNT_ID>`, the handler MUST return `JrError::UserError` and exit 64
BEFORE any HTTP is issued. Guard placement: fires immediately after the JSM dispatch fork
(`request_type.is_some()` check in `handle_create`), BEFORE project-key resolution, BEFORE interactive prompts, and BEFORE
all pre-POST helper HTTP (steps 3–5) and BEFORE the platform POST (step 6) — see Platform-Path Guard Ordering block above.
Zero HTTP of any kind is issued on this error path. Because `--on-behalf-of` is `Option<String>` (repeats accepted by clap, last-wins; contract keys on is_some()), idempotency is trivially satisfied — one or more occurrences
produces one error. The guard fires regardless of `--no-input` or `--output json` settings (mode affects only the error rendering channel/shape, per the Test Notes). **Implementation constraint (MUST NOT):** this guard MUST NOT be realized via clap `#[arg(requires = "request_type")]` — that attribute yields exit 2 pre-handler, violating SSOT step 2 and falsified by (non-exhaustively) AC-1/AC-2/AC-16 — any AC asserting the guard string on a guarded-flag invocation falsifies a `requires` realization; AC-15 alone is insensitive (clap exit-2 either way); the guard MUST be a hand-rolled check inside `handle_create` returning `JrError::UserError` (same model as `edit.rs`'s flag-guard pattern).

Verbatim error string (single-flag case: `--on-behalf-of` present, `--field` absent):
```
--on-behalf-of is only valid with --request-type (JSM service-desk requests). Add --request-type <NAME> to raise a request on behalf of another user, or drop --on-behalf-of to create a standard platform issue.
```

**Combined pre-flight error (both `--field` AND `--on-behalf-of` present) — [REWRITTEN 2026-08-25
issue #578, DEC-310 (proposed)]:** BC-3.8.012's combined check is REMOVED (see BC-3.8.012
`[CURRENT BEHAVIOR — effective 2026-08-25]` and this BC's own `[CURRENT BEHAVIOR — effective
2026-08-25, issue #578]` note above). The STANDALONE `--on-behalf-of`-only error string above now
fires **unconditionally** whenever `--on-behalf-of` is present without `--request-type` —
regardless of whether `--field` is also present. **[SUPERSEDED 2026-08-25 — text below preserved
for audit trail, NOT current contract]** ~~The combined error is defined and governed by
BC-3.8.012. ONE combined error fires; the `--on-behalf-of`-only error string above fires ONLY
when `--field` is absent.~~ That combined error, and the "ONLY when `--field` is absent" gating
condition, no longer exist.

**Asymmetry rationale (invariant):** Scoped to `jr issue create`. Same two-direction distinction as BC-3.8.012: `--on-behalf-of` is a JSM-only flag on the platform path (absent `--request-type`) → exit 64. `--team`/`--points`/etc. (BC-3.8.011; BC-3.8.010 governs `--type` only) are platform flags on the JSM path (present `--request-type`) → warn-and-degrade; they do NOT warn when used without `--request-type`. See BC-3.8.012 for the full rationale. Remedy affordance: create the issue first (`jr issue create ...`); reporter identity may be settable after creation via `jr issue edit --field` depending on project permissions (Modify Reporter permission). **Error-string completeness note (deliberate omission):** The verbatim error string in the fenced block above deliberately omits this create-then-edit remedy affordance — it is factually conditional on the Modify Reporter project permission and would be misleading if included unconditionally. The two unconditional remedies (add `--request-type` / drop `--on-behalf-of`) are present inline in the error string and are sufficient; the conditional affordance is documented here in the rationale prose only.

When `--on-behalf-of` is absent (clap default: None), NO error is emitted; the platform
path proceeds normally, byte-identical to pre-DEC-188 behavior.

**Inputs**: `--on-behalf-of <ACCOUNT_ID>` WITHOUT `--request-type`
**Outputs/Effects**: `JrError::UserError` to stderr; exit 64; NO stdout output; NO HTTP. Stdout MUST be empty (`stdout.trim().is_empty()`) in both output modes (human and `--output json`). The `stdout.trim().is_empty()` predicate is normative — it matches the `assert_json_error_envelope` helper (fn at `tests/json_error_shape.rs` ~:63; its `stdout.trim().is_empty()` semantics at ~:76; current site — moves to `tests/common/assertions.rs` upon promotion per the F-1 promotion directive — no line number for future site; trims before asserting empty).
**Errors**: Exit 64 (`JrError::UserError`). No HTTP. No warning-and-proceed.
**Removal postcondition (single-site, DEC-188):** Same obligation as BC-3.8.012 — the superseded `eprintln!` warn strings MUST be REMOVED from `src/cli/issue/create.rs`. Stderr on the guarded path MUST NOT contain the substring `"is ignored on the platform create path"`. AC-2 and AC-16 MUST each include this negative assertion: `!stderr.contains("is ignored on the platform create path")`. Note on AC-16: `--on-behalf-of ""` (empty value) was covered by the old `is_some()` guard at `src/cli/issue/create.rs` ~:86 and previously emitted the warn string — the pin proves it is absent post-DEC-188.
**Test Note**: In human output mode, test assertions use `stderr.contains(...)` (not `==`) to accommodate the "Error: " prefix prepended by the `src/main.rs` error-rendering site. With `--output json`, the error JSON is written to **stderr** (not stdout) WITHOUT the "Error: " prefix — parse stderr directly as JSON; assert `code == 64` and `error` contains the guard message substring. Key order is serde_json map behavior (alphabetical by default without `preserve_order`; unspecified contractually — parse fields individually, do not match literal key order); output is compact, not pretty-printed. Implementers: promote `assert_json_error_envelope` as `pub fn` to `tests/common/assertions.rs` (`pub fn` is the assertions.rs convention) from `tests/json_error_shape.rs` (F3 deliverable); register `pub mod assertions;` in `tests/common/mod.rs` (F3 deliverable); DELETE the original fn from `tests/json_error_shape.rs`; re-import from `tests/common/assertions.rs` at the three existing call sites in `tests/json_error_shape.rs` — no duplicate definition under the zero-warnings policy. **Hygiene:** `tests/issue_create_jsm.rs` gains `#[allow(dead_code)] mod common;` at the promotion step — AC-2 and AC-7 import `assert_json_error_envelope` from `tests/common/assertions.rs` there, pulling in the same ~29 fixtures. During promotion, fix the stale doc-comment in `assert_json_error_envelope` that claims a specific `{"error":…,"code":…}` key order — correct to: key order is serde_json map behavior (alphabetical by default without `preserve_order`; unspecified contractually); callers MUST parse the JSON and check fields individually, not rely on or test literal key order (parse, don't match). **Config fixture contract (single source — callers of `assert_json_error_envelope`):** callers MUST ensure stderr contains ONLY the error JSON envelope — use a pre-migrated `[profiles.default]`-shaped config fixture (F3 deliverable: `write_profile_config(config_home: &Path, base_url: &str)` — lives in `tests/common/fixtures.rs` (`fixtures.rs` is the home for non-assertion test fixtures generally, including config writers; the F46-003 "pure-JSON" charter is narrowed to payload fixtures only — these two helpers have DIFFERENT destinations: `write_profile_config` → `tests/common/fixtures.rs`, `assert_json_error_envelope` → `tests/common/assertions.rs`); shape modeled on `tests/issue_create_jsm.rs` ~:1959-1966: `default_profile = "default"` + `[profiles.default]` block with `url` and `auth_method` fields), NOT `write_minimal_config`'s legacy `[instance]` shape; `src/config.rs` ~:255-287 emits a one-time `"Migrated config to multi-profile layout…"` stderr line on first load of the legacy shape, which poisons the strict JSON parse in `assert_json_error_envelope`.
**Edge Cases**:
- EC-3.8.013-1: `--on-behalf-of ""` (empty string value) → BC-3.8.013 fires; an empty value is still a present `Option<String>` and the guard checks `on_behalf_of.is_some()`. Exit 64 with the `--on-behalf-of`-only error string. **[UPDATED 2026-08-25 issue #578, DEC-310 (proposed)]** This holds WITH or WITHOUT `--field` also present — BC-3.8.012's combined check is removed, so this BC's standalone guard now governs unconditionally on `--on-behalf-of` presence, regardless of `--field`. (The prior cross-reference to "the combined check in BC-3.8.012" for the `--field`-also-present sub-case, and EC-3.8.012-1's mirror of it, are both STALE post-reversal — see BC-3.8.012 `[CURRENT BEHAVIOR — effective 2026-08-25]` Edge Cases note, which marks EC-3.8.012-1 superseded for the same reason.)
- EC-3.8.013-2: `--on-behalf-of X --request-type ""` (empty RT value, `--field` absent) → `request_type.is_some()` is true (`Some("")`), so the dispatch fork at `src/cli/issue/create.rs` ~:49 routes to `handle_jsm_create`; BC-3.8.016 fires (empty RT guard at `src/cli/issue/jsm_create.rs` ~:145) — BC-3.8.013 MUST NOT fire. Mirror of EC-3.8.012-2 (routing is flag-agnostic: the `request_type.is_some()` dispatch fork applies regardless of which JSM-only flags are present). AC-14's `--field` variant covers this routing class; a dedicated AC for the `--on-behalf-of` variant is a deliberate non-goal (the routing check is identical at `create.rs` ~:49).
**Trace**: `tests/issue_create_jsm.rs` — see BC-3.8.012 Trace for full AC namespace note (AC-1..21 are S-639-1 targets; supersede S-383 ACs; note the 2026-08-25 `[SUPERSEDED-IN-PART]` addendum on that note flagging the `--field`-asserting and combined ACs as superseded post-reversal). AC-8 invocation (ii) (`test_platform_create_field_with_helpers_exits_64_zero_http`, `--on-behalf-of X` variant) pins BC-3.8.013's zero-HTTP guarantee via `server.received_requests().await.unwrap().is_empty()` on the dedicated isolated `MockServer` for that invocation (same NORMATIVE zero-HTTP assertion as invocation (i); see AC-8 spec for full mock setup and MockServer isolation constraint). Holdout coverage (SOH-DX-1 F2 2026-07-29, overrides F51-001 non-goal per F2 gate human ruling): H-NEW-PREFLIGHT-002 (`--on-behalf-of` alone → exit 64 zero HTTP), H-NEW-PREFLIGHT-003 **[UPDATED 2026-08-25 issue #578]** (both flags present → BC-3.8.013's STANDALONE `--on-behalf-of` guard fires, zero HTTP — NOT a combined error; BC-3.8.012's combined-error trigger is removed; rewritten per BC-3.8.013 `[CURRENT BEHAVIOR — effective 2026-08-25, issue #578]`), H-NEW-PREFLIGHT-004 (neither flag → exit 0 regression pin), H-NEW-PREFLIGHT-005 (JSM path non-mis-fire).
AC-2 `test_platform_create_on_behalf_of_flag_exits_64_without_request_type` (renamed from `test_platform_create_on_behalf_of_flag_emits_warning_without_request_type`); AC-3 `test_platform_create_both_inverse_flags_exit_64_combined_error` **[STALE POST-REVERSAL 2026-08-25 issue #578 — description corrected here; name/body disposition is an F3/F4 obligation]**: this AC's name and original description referred to the now-removed combined-error path (BC-3.8.012's `[DEC-188 BEHAVIOR, superseded]` §"Combined pre-flight error"); post-reversal, the `--field` AND `--on-behalf-of` combined invocation exercises ONLY BC-3.8.013's STANDALONE guard (BC-3.8.012's combined check has no remaining trigger) — at F3/F4 this AC must be rewritten to assert the standalone `--on-behalf-of`-only error string (with `--field` also present but contributing no error of its own, per BC-3.3.010/011), not the dead combined-error string; see BC-3.8.013 `[CURRENT BEHAVIOR — effective 2026-08-25, issue #578]` and its rewritten "Combined pre-flight error" subsection for the current contract this AC must target; AC-4 `test_platform_create_without_inverse_flags_emits_no_errors` (clean path — neither `--field` nor `--on-behalf-of` present → no guard fires, exit 0); AC-16 `test_platform_create_on_behalf_empty_string_exits_64_013_error` (EC-3.8.013-1 — `--on-behalf-of ""` alone fires BC-3.8.013); AC-20 `test_jsm_create_with_on_behalf_of_and_request_type_does_not_fire_bc_3_8_013` (JSM path non-mis-fire pin — `--on-behalf-of` + `--request-type` → exit 0, all three new-error negatives absent); AC-21 `test_jsm_create_with_both_flags_and_request_type_does_not_fire_guards` (JSM path combined non-mis-fire — `--field a=b --on-behalf-of X --request-type <NAME>` → exit 0, all three new-error negatives FALSIFIABLE — the only invocation falsifying the combined guard on the JSM path); `src/cli/issue/create.rs::handle_create` (guard implementation site). S-639-1 F3 story deliverable.
Doc-fallout deliverables: **NORMATIVE**: BC-3.8.012 Trace deliverables (a)–(f) is the authoritative, binding enumeration for both BC-3.8.012 and BC-3.8.013; the parenthetical below is illustrative and non-exhaustive — any omission from it does not reduce the obligation. Illustrative subset (non-exhaustive): (a) ADR-0014 amendment, (b) CLAUDE.md dispatch-fork qualifier, (c) Cargo.toml/CHANGELOG.md breaking-change entry, **(d) `src/cli/mod.rs` `--on-behalf-of` first doc line (~:403) MUST carry the substring `"requires --request-type"` (pinned, post-reversal, by the corrected AC-12 disposition in BC-3.8.012's `[CURRENT BEHAVIOR — effective 2026-08-25]` F3/F4 removal obligations: `stdout.matches("requires --request-type").count() == 1` after whitespace normalization — scoped to the `--on-behalf-of` help line ONLY. `--field`'s help line no longer carries the clause at all post-DEC-310 reversal, so count 2 is now the AC-12 failure mode, not count 1)**. `--on-behalf-of` is part of the same DEC-188 breaking change; see BC-3.8.012 Trace for the complete, authoritative deliverables list.
**Source**: SOH-DX-1 DEC-188 F2 (2026-07-25, #639); supersedes issue #383 F2 warn-and-proceed behavior.
**Confidence**: HIGH

**Note (coverage non-goal) [SUPERSEDED BY F2 GATE HUMAN RULING 2026-07-29]:** The F51-001 non-goal rationale was overridden by the F2 gate human ruling (2026-07-29): holdout scenarios H-NEW-PREFLIGHT-002/003/004/005 in holdout-scenarios.md Group 20 now cover BC-3.8.013 paths (SOH-DX-1 F2 authoring). F51-001 rationale (retained for historical record): Holdout-scenario and VP coverage were a deliberate non-goal for S-639-1 — same rationale as BC-3.8.012. Both guards are pure pre-flight input-validation checks with no network interaction; every observable exit path is fully covered by the shared AC suite (AC-1..21). Contrast with VP-331-003 (BC-3.4.019): that guard requires a project-scoped API lookup to resolve the issue-type ID, giving it a verification surface these pre-flight string-presence guards lack.

[ADDED 2026-05-19 issue #383 F2 → AMENDED 2026-07-25 SOH-DX-1 DEC-188 #639 (warn-and-proceed → pre-flight exit-64)]

---

#### BC-3.8.014: Basic-auth 401 on JSM POST (`handle_jsm_create`) → API-token-expiry hint; no OAuth-scope language

**Confidence**: HIGH
**Subject**: Issue write (JSM path — auth-conditional error hint)
**Behavior**: When `POST /rest/servicedeskapi/request` returns 401 AND the active auth scheme is Basic (i.e., `JiraClient::is_oauth_auth()` returns `false`), the `handle_jsm_create` `map_err` MUST surface an API-token-expiry hint and exit 2. The gate is `is_oauth_auth() == false` ALONE — the incoming error variant is irrelevant.

Implementation: the `map_err` must inspect `client.is_oauth_auth()`. If `false`, REWRITE any incoming error (whether `JrError::NotAuthenticated` or `JrError::InsufficientScope`) to `JrError::NotAuthenticated { hint: <API_TOKEN_HINT> }`. This rewrite is mandatory: a Basic-auth 401 whose response body contains "scope does not match" would otherwise propagate as `InsufficientScope` (per `src/api/client.rs:~696`), causing the user to see OAuth scope language that is actionably wrong for Basic-auth users. The rewrite suppresses that path.

The `hint` field value (stored in `JrError::NotAuthenticated { hint }`) MUST be the shared constant `API_TOKEN_EXPIRY_HINT` (defined once in **`src/error.rs`** — NOT in `src/api/client.rs` or any new module — referenced identically by the `handle_jsm_create` site and the `require_service_desk` site — see BC-X.8.006). `src/error.rs` is imported by both the `api` and `cli` layers with no layering inversion, and it keeps "no new modules / no architecture delta" true. This shared constant prevents hint-text divergence between the two call sites.

The rendered stderr line prepends `"Not authenticated. "` (from `src/error.rs:~5`); the `hint` field contains only the body text after that prefix. Tests MUST assert via `contains`, not `==`, to tolerate the rendered prefix. The hint field value is:

<!-- This block is duplicated from the CANONICAL copy in prd-delta-384.md §BC-3.8.014 — all copies MUST be updated together; cf. the JR_* doc-fallout pattern in CLAUDE.md (adversary-pass-4 F-04). -->
```
Your API token may be expired or revoked. Regenerate it at
https://id.atlassian.com/manage-profile/security/api-tokens
then run `jr auth login` to re-store the credentials.
```

The hint MUST NOT contain any OAuth-scope language (e.g., `write:servicedesk-request`, `OAuth`, `scope`). Basic-auth users have API tokens with implicit permissions, not OAuth granular scopes; surfacing a scope hint is misleading and actionably wrong. The hint MUST NOT say `jr auth refresh` (meaningless for Basic auth — no OAuth refresh token).

Gate: `client.is_oauth_auth() == false` — predicate is `self.auth_header.starts_with("Bearer ")`. **Value-space precision**: `JiraClient::load_auth_from_keychain` produces exactly `"Bearer {access_token}"` for OAuth or `"Basic {base64_encoded}"` for Basic/API-token. The `JR_AUTH_HEADER` debug-only test seam (CLAUDE.md SD-002, `#[cfg(debug_assertions)]`) can inject either form in tests. `auth_header` is never empty at call time — the constructor errors via `?` if the keychain yields nothing. `is_oauth_auth()` is `self.auth_header.starts_with("Bearer ")` — the SAME discriminant the production code already trusts at `src/api/client.rs:~718` and `:802`. No other predicate or ad-hoc string check should be introduced. This is 100% reliable for the value-space produced by `load_auth_from_keychain`.

**Inputs**: Active auth = Basic; JSM POST returns HTTP 401 (any body shape — including generic expiry and "scope does not match" bodies)
**Outputs/Effects**: exit 2; stderr contains the API-token-expiry hint (assert via `contains`); stdout empty; any `InsufficientScope` from the 401 is rewritten to `NotAuthenticated` before surfacing.
**Errors**: None beyond the 401 itself — this BC IS the error-handling contract.
**Trace**: `tests/issue_create_jsm.rs` (integration tests for the HTTP-401 Basic-auth path): (a) `test_jsm_create_basic_auth_scope_mismatch_401_rewrites_to_api_token_hint` (NEW) — pins the `InsufficientScope`→`NotAuthenticated` rewrite path with a "scope does not match" body fixture; (b) `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` (REPURPOSED in place by F4 — fixture stays Basic `JR_AUTH_HEADER=Basic dGVzdDp0ZXN0`, generic-expiry 401 body; assertions flipped from `write:servicedesk-request` to API-token-expiry hint; negative assertion that `write:servicedesk-request` is ABSENT; per adversary-pass-9 C-01 correction — this test is a BC-3.8.014 pin, NOT a BC-3.8.015 pin). The Basic-auth generic-expiry path is pinned by test (b); test (a) covers the scope-mismatch rewrite path. Both AC-3 and AC-5 describe the same observable behavior (API-token-expiry hint for Basic-auth 401) and share test (b) as the generic-expiry pin.
**Source**: Issue #384 F2 corrected model; O-08-01 CONFIRMED in `.factory/research/issue-288-pr4-deferred-validation.md`; `src/api/client.rs:~696` (scope-mismatch body check fires before Bearer guard at line 718 — body content, not auth scheme, decides variant before map_err); CLAUDE.md gotcha "Atlassian's expired-access-token 401 response shape".
**Confidence**: HIGH

[NEW 2026-05-19 issue #384 F2] Closes O-08-01: Basic-auth API-token-expiry 401 was incorrectly surfacing the OAuth `write:servicedesk-request` scope hint. The gate is `is_oauth_auth() == false` alone; the map_err must REWRITE any incoming 401-derived error variant to `NotAuthenticated` with the API-token hint, because a Basic-auth 401 with a "scope does not match" body arrives as `InsufficientScope` (body check at client.rs:~696 fires before Bearer guard at line 718).

[REVISED 2026-05-19 issue #384 F2 adversary correction] Previous version incorrectly stated "Basic-auth 401s land in `JrError::NotAuthenticated`, not `InsufficientScope`." This is FALSE. The 401 handler in `src/api/client.rs` checks the response BODY for "scope does not match" at line 696 BEFORE checking the `Bearer` guard at line 718. So a Basic-auth 401 with a scope-mismatch-flavored body lands in `InsufficientScope`. The corrected model: gate is `is_oauth_auth() == false` alone; `map_err` must rewrite both `NotAuthenticated` and `InsufficientScope` arms to the API-token hint.

---

#### BC-3.8.015: OAuth 401 on JSM POST (`handle_jsm_create`) → `write:servicedesk-request` hint via `InsufficientScope` scope-mismatch path (deterministic); `NotAuthenticated` post-refresh path is pre-existing, out of #384 test scope

**Confidence**: HIGH
**Subject**: Issue write (JSM path — auth-conditional error hint)
**Behavior**: When `POST /rest/servicedeskapi/request` returns 401 AND the active auth scheme is OAuth/Bearer (i.e., `JiraClient::is_oauth_auth()` returns `true`), the observable behavior depends on the 401 response body:

- **`JrError::InsufficientScope` (body contains "scope does not match" — client.rs:~696 short-circuit, DETERMINISTIC):** The scope-mismatch body check at `src/api/client.rs:~696` fires BEFORE the Bearer guard at `src/api/client.rs:~718` AND before the refresh coordinator. This means for a Bearer client, a scope-mismatch 401 short-circuits directly to `InsufficientScope` and lands in `handle_jsm_create`'s `map_err` as a genuine `JrError`. The `map_err` on the `is_oauth_auth() == true` branch preserves `InsufficientScope` and its hint names `write:servicedesk-request` + `required_scope: Some("write:servicedesk-request")`; exit 2. **This is the ONLY deterministically testable OAuth→`JrError`→`write:servicedesk-request` path via the `JR_AUTH_HEADER` test seam.** The EXISTING test `async fn test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` (under the `// ─── C-01: OAuth InsufficientScope 401 surfaces write:servicedesk-request ────` section banner in `tests/issue_create_jsm.rs`) is the BC-3.8.015 regression pin. It uses `JR_AUTH_HEADER=Bearer test-oauth-token` + body `{"errorMessages": ["Unauthorized; scope does not match"]}` and asserts `write:servicedesk-request`, `jr auth refresh`, `jr auth login`. This test is GREEN on `develop` UNMODIFIED — it is the BC-3.8.015 pin. It MUST remain green unmodified.

- **`JrError::NotAuthenticated` (non-scope-mismatch Bearer 401, post-refresh path — NOT deterministically testable via `JR_AUTH_HEADER` seam):** A Bearer client with a generic-expiry 401 body (no "scope does not match") does NOT short-circuit at client.rs:~696. Instead, it enters the auto-refresh coordinator at line 727+. In any test using the `JR_AUTH_HEADER=Bearer ...` seam (no keychain OAuth tokens, no `JR_OAUTH_TOKEN_URL` mock), the refresh call deterministically fails with a raw `anyhow::bail!` error from `refresh_oauth_token_with_url` — NOT a `JrError`. That raw anyhow error propagates to `handle_jsm_create`'s `map_err`, where `e.downcast::<JrError>()` hits the `Err(other) => other` arm — no `JrError` branch fires, and the `write:servicedesk-request` hint is NEVER injected. **Consequence:** BC-3.8.015 must NOT claim a Bearer + generic-expiry 401 surfaces `write:servicedesk-request`. The pre-existing `NotAuthenticated` arm rewrite at `src/cli/issue/jsm_create.rs::handle_jsm_create` §"NotAuthenticated arm" injects `write:servicedesk-request` for OAuth only after a SUCCESSFUL token refresh followed by a 401 retry — this path is real and pre-existing but is NOT reliably reachable via the `JR_AUTH_HEADER` test seam. It is pre-existing behavior, unchanged by #384, and is out of #384's deterministic-test scope. No test for this path is mandated by this delta.

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
**Source**: Issue #384 F2 adversary-pass-9 C-01 corrected design; BC-1.3.023; H-NEW-JSM-RT-003; `src/api/client.rs:~696` (scope-mismatch short-circuit fires BEFORE refresh coordinator — the ONLY deterministic Bearer→`JrError` path); `src/api/client.rs:~718` (Bearer guard — NOT reached for scope-mismatch bodies); `src/api/client.rs:~727+` (refresh coordinator — entered by generic-expiry Bearer 401; deterministically fails with raw anyhow error via `JR_AUTH_HEADER` seam, not a `JrError`).
**Confidence**: HIGH

[NEW 2026-05-19 issue #384 F2] Formally pins the OAuth path as the surviving branch after the Basic/OAuth split. Pre-#384, both Basic and OAuth 401s shared the same hint logic; post-#384, the Basic-auth arm is intercepted by BC-3.8.014 before it reaches the OAuth behavior.

[REVISED 2026-05-19 issue #384 F2 adversary-pass-2 C-02/H-05/H-06] (C-02) Renderer prefix corrected: `"Insufficient token scope: "` (colon) not `"Insufficient token scope. "` (period) — per `src/error.rs:~8`. (H-05/H-06) Corrected false claim about pre-#384 map_err behavior; both arms produce `write:servicedesk-request` for OAuth — exactly as pre-#384.

[REVISED 2026-05-19 issue #384 adversary-pass-5 F-01/F-02/F-03] (F-01) Clarified H-NEW-JSM-RT-003 artifact identity. (F-02) Added explicit warning about mandatory Bearer fixture migration. (F-03) Confirmed test function by reading its body; symbol-relative anchor used.

[REVISED 2026-05-19 issue #384 adversary-pass-8 F-02] Replaced hardcoded line citations with symbol-relative anchors per CLAUDE.md anti-drift convention.

[REVISED 2026-05-19 issue #384 adversary-pass-9 C-01 CRITICAL design correction] Complete rewrite of testable contract. The F2 passes 1-8 plan ("migrate the pre-#384 Basic-auth 401 test to Bearer + generic-expiry body") was unworkable: a Bearer + generic-expiry 401 routes through the refresh coordinator (client.rs:~727+), which deterministically fails with a raw anyhow error (not a `JrError`) via the `JR_AUTH_HEADER` seam, so the `write:servicedesk-request` hint is never injected. The ONLY deterministic Bearer→`JrError`→`write:servicedesk-request` path is the scope-mismatch short-circuit (client.rs:~696). BC-3.8.015 is now re-specified to its true testable contract: the scope-mismatch path, pinned by the EXISTING `async fn test_jsm_create_oauth_scope_mismatch_401_surfaces_write_servicedesk_request_hint` (already green on `develop`, unmodified). H-NEW-JSM-RT-003 re-bound to this test. `test_jsm_create_basic_auth_generic_401_surfaces_api_token_hint` stays Basic and becomes a BC-3.8.014 pin with flipped assertions. BC-X.8.007 Setup corrected to scope-mismatch body.

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

Exit code: 64. Stderr contains: `"request type cannot be empty"` (**CANONICAL SOURCE — all duplicate occurrences in prd-delta-385.md, holdout-scenarios.md, and this file's frontmatter version log MUST be updated together with this copy; cf. JR_* doc-fallout pattern in CLAUDE.md**) (assert via `contains`). No HTTP calls are issued. The guard evaluates `request_type_arg.trim().is_empty()` — it rejects empty-or-whitespace-only values. The un-trimmed value is passed downstream UNCHANGED if the guard does NOT fire; this BC does NOT normalize or trim the value for downstream use. Consequently, non-empty whitespace-padded values (e.g. `--request-type " 5 "`) are OUT OF SCOPE for this BC and are EXPLICITLY DEFERRED out of #385 scope — they pass this guard and the un-trimmed value proceeds to step 6, where `" 5 "` fails the numeric-bypass check (not all-digits) and falls into `partial_match`. The current outcome is a potentially confusing "request type not found" error (because `" 5 "` is unlikely to substring-match any request type name), not a clean exit. This is a KNOWN RESIDUAL edge case — deferred, not benign.
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

## JSON Output Shape Contracts (all confirmed by insta snapshots; attachment rows pending S1–S5 delivery — spec-only today)

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
| `attachment download --id <AID>` | `{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N}]}` | 1-element `downloaded` array; inner keys alphabetical (filename<id<path<size); `filename` = RAW Jira name (pre-sanitization); `path` = on-disk location (post-sanitization; basename(path) = on-disk name); BC-2.7.007 EC-2.7.007-7 (P27-001) |
| `attachment download --all` / `--newest N` | `{"downloaded":[{"filename":"<name>","id":"<AID>","path":"<written path>","size":N},…]}` | N-element `downloaded` array; same inner shape; `filename` = RAW Jira name (pre-sanitization, pre-SHA-1-prefix); `path` basename = SHA-1-prefixed on-disk name (BC-2.7.010); BC-2.7.008/BC-2.7.009 EC-2.7.008-6 (P27-001) |
| `attachment upload` (platform POST path) | `[{"author":{...},"contentUrl":"https://…/rest/api/3/attachment/content/10042","created":"2026-07-15T...","filename":"foo.pdf","id":"10042","mimeType":"application/pdf","size":43008}]` | curated form (BC-2.7.002): `"self"` omitted, `"content"`→`"contentUrl"`; keys alphabetical; one element per file; BC-3.9.009 |
| `attachment delete` (single AID) | `{"deleted":true,"id":"<AID>"}` | 2 keys alphabetical; BC-3.9.010 |
| `attachment delete` (bulk AIDs) | `{"count":N,"deleted":true,"ids":["<AID1>","<AID2>",...]}` | 3 keys alphabetical; BC-3.9.010 |
| `attachment delete` (cancel / --no) | `{"cancelled":true,"deleted":false}` | 2 keys alphabetical; BC-3.9.015 |
| `attachment delete --dry-run` (preview) | `{"attachments":[...],"dryRun":true,"ids":[...]}` | 3 keys alphabetical at all depths; BC-3.9.020 |
| `attachment upload --replace-existing --dry-run` | `{"dryRun":true,"wouldDelete":[{"filename":"<name>","id":"<AID>"}],"wouldUpload":[{"filename":"<name>"}]}` | 3 keys alphabetical at all depths (dryRun < wouldDelete < wouldUpload; filename < id within elements); BC-3.9.020 path c; ships with S3; with `--public`: wouldUpload entries include `"visibility":"public"` — EC-3.9.020-7; P23-004 |
| `attachment upload` (cancel — interactive 'n' or empty) | `{"cancelled":true,"uploaded":false}` | 2 keys alphabetical; BC-3.9.003/BC-3.9.014/BC-3.9.017 |
| `attachment upload --public` / `--internal` | `[{"author":{...},"contentUrl":"https://…/rest/api/3/attachment/content/<id>","created":"…","filename":"<name>","id":"<id>","mimeType":"<mime>","size":N}]` | curated array; same shape as platform upload (BC-3.9.009); extracted from `AttachmentCreateResultDTO.attachments.values[]`; `"self"` omitted, `"content"`→`"contentUrl"`; keys alphabetical; no `"public"` key in output; BC-3.9.011 (confirmed P2-3c probe runs 29936980027 + 29940792930 + 29945857059) |

Sources: `src/cli/issue/snapshots/jr__cli__issue__json_output__tests__*.snap`; BC-1104..BC-1112 (R4); BC-3.9.009, BC-3.9.010, BC-3.9.015, BC-3.9.020 paths a/b (delete dry-run) + BC-3.9.020 path c (upload --replace-existing --dry-run, ships with S3); BC-2.7.007, BC-2.7.008/009 (download --id / --all / --newest, SOH-ATTACHMENTS-1 F2 additions)


### 3.9 Attachment Write (20 BCs: BC-3.9.001..BC-3.9.020)

---

#### BC-3.9.001: Platform `attachment upload` — multipart POST to `/rest/api/3/issue/{key}/attachments`; `X-Atlassian-Token: no-check` mandatory; streaming; no client-side size cap; graceful 413/400

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload (implementation pending — story S3); src/api/jira/attachments.rs::upload_attachments (implementation pending — story S3); `tests/attachment_upload.rs` (implementation pending — story S3)
**Subject**: Issue write (attachment upload — platform path)

`jr issue attachment upload <KEY> <FILE>...` issues `POST /rest/api/3/issue/{key}/attachments` with a `multipart/form-data` body. Each file is a separate `file`-named part (the Jira API requires the field name `"file"` — any other name produces a 400). The header `X-Atlassian-Token: no-check` MUST be included on every upload request; Jira's CSRF protection rejects attachment uploads without it (HTTP 403 — XSRF-related rejection; Atlassian's exact body text varies by deployment and is not load-bearing — `jr` only guarantees the `X-Atlassian-Token: no-check` header is always sent; the test asserts header presence, not the server's 403 body). This header is load-bearing.

Files are streamed from disk using `tokio_util::io::ReaderStream` — bytes are not buffered in memory before transmission. This allows uploads of large files without exhausting process memory.

Multiple files supplied on one invocation are uploaded in a single multipart POST, one `file`-named part per file, in the order supplied on the command line.

`jr` enforces NO client-side file-size cap. The attachment size limit is instance-configured and not knowable from the client side (sources conflict on the default figure; research §3a verdict: INCONCLUSIVE — do not hard-code a size assumption; rely on graceful 413/400 handling). When the server rejects the upload due to size, the response is HTTP 413 (Payload Too Large); `jr` exits 1 with the message: `"Attachment too large: the file exceeds the server-configured limit."` No numeric limit is stated in the error — the limit is instance-specific and not published by `jr`.

On HTTP 400 (bad request): exit 1; the Jira error body is surfaced on stderr verbatim (may indicate unsupported MIME type, quota exceeded, malformed part, etc.).

**Retry-interaction for streaming uploads (ADR-0017)**: `reqwest`'s `RequestBuilder::try_clone()` returns `None` for multipart requests containing streamed `ReaderStream` bodies — the stream cursor is not rewindable after a partial send. Consequently, the standard `JiraClient` retry loop does NOT apply to upload requests. Any 429/Retry-After handling for `POST /rest/api/3/issue/{key}/attachments` MUST rebuild the entire multipart request from the file path on each attempt: a fresh `tokio::fs::File::open(path)` and a new `ReaderStream` per retry. A mid-stream 429 is not possible because Jira processes the response only after the full body is received. The upload handler in src/api/jira/attachments.rs::upload_attachments must implement its own per-attempt request construction; it MUST NOT delegate retry to the generic `JiraClient` retry wrapper. Detail: ADR-0017.

**File argument form (`allow_hyphen_values`)**: The `<FILE>...` positional arguments carry `allow_hyphen_values = true` (CLAUDE.md convention for write-command free-text inputs). This allows file paths beginning with a dash (e.g., `-file.pdf`) without being misinterpreted as flags. Use `--` before the first `<FILE>` to unambiguously terminate flag parsing when paths start with `--`. Stdin upload via `-` is NOT supported in this slice.

A successful upload returns HTTP 200 with a JSON array of attachment objects. The Jira API response includes fields such as `"id"`, `"filename"`, `"self"` (URL string), `"size"`, `"mimeType"`, `"created"`, and `"content"` (the download URL) — these are the raw API wire fields and are documented here as facts. **jr's output serialization** uses the curated form defined in BC-2.7.002 / BC-3.9.009: `"self"` is OMITTED; `"content"` is RENAMED to `"contentUrl"`. Human (table) output: one row per attachment, columns Filename / Size / ID / Created. **Note (P19-I1)**: this 4-column upload echo table deliberately differs from the 6-column list table (BC-2.7.001: ID / Filename / Type / Size / Created / Author) — the upload echo surface is a minimal confirmation of what was just sent; the list surface is the full read metadata surface. JSON output: the curated array, pretty-printed via `output::render_json` (#526 invariant).

Output channel: Profile 4 (Symmetric) — stdout for JSON or success data, stderr for errors and progress hints.

**EC-3.9.001-1** (single file): A single-file upload produces a response array with one element; table shows one row.
**EC-3.9.001-2** (multi-file): Multiple `<FILE>` arguments → single multipart POST with multiple `file` parts; server returns an array with one element per file.
**EC-3.9.001-3** (empty file): A zero-byte file is valid; `jr` does not reject it client-side. Server behavior depends on Jira configuration.
**EC-3.9.001-4** (file path not found / not a regular file): If any supplied `<FILE>` path does not exist, is a directory, or is any non-regular-file (checked via `is_file()` — rejects block/char devices, symlinks to directories, FIFOs) → exit 64 before any HTTP; stderr `"file not found: <path>"` (missing) or `"not a regular file: <path>"` (exists but not a regular file). The `is_file()` check prevents accidental directory ingestion. The check is performed before any multipart construction.

**EC-3.9.001-5** (X-Atlassian-Token regression guard — SEC-576-005 CWE-352): A wiremock integration test MUST assert that every `POST /rest/api/3/issue/{key}/attachments` upload request includes the header `X-Atlassian-Token: no-check`. A regression omitting this header produces HTTP 403 silently in live testing; the wiremock test catches it at CI time.

**EC-3.9.001-6** (stdin or `-` as FILE): If any `<FILE>` argument is the literal string `"-"`, exit 64 before any HTTP: `"stdin upload is not supported; provide a file path."` The `-` shorthand for stdin is explicitly rejected in this slice.

**Content-Disposition filename value (BC-3.9.017 step 1 invariant)**: the filename value in each part's `Content-Disposition` header MUST be `Path::file_name(<FILE>)` — the basename of the supplied file path, no directory components. Jira derives `attachment.filename` from this value verbatim (the attachment list response's `filename` field equals whatever was sent in `Content-Disposition`). The `--replace-existing` step 1 match (BC-3.9.017) depends on this invariant: `attachment.filename == basename(<FILE>)`. The SEC-576-004 CRLF-safety test below applies to this basename value.

**Multipart filename encoding (SQ-6 resolution — SEC-576-004 CWE-93)**: reqwest 0.13's `multipart::Part` applies percent-encoding to the filename value in the `Content-Disposition` header. The implementer MUST include a unit test with filenames containing `;`, `"`, and `\r\n` and assert the resulting multipart POST body has a well-formed `Content-Disposition` header (no CRLF injection, no boundary escape). This resolves SQ-6 from `.factory/phase-f1-delta-analysis/impact-boundary-576.md`, to be verified at Story 3 delivery.

**Observability** (`--verbose` / `--verbose-bodies`): `--verbose` logs method + URL only (unchanged SD-003 rule). `--verbose-bodies` MUST NOT attempt to buffer the streaming multipart upload body — the stream body is not rewindable (ADR-0017: retry requires a fresh `ReaderStream`). When `--verbose-bodies` is active, the upload body MUST be logged as a placeholder: `"<streaming multipart body: N bytes from <path>>"` per file (size from `metadata().len()` before the stream is opened). Never log actual file contents. The PII warning emitted by `--verbose-bodies` extends to attachment content.

**CLI flags** (pinned for e2e surface guard): `<KEY>` (positional, required); `<FILE>...` (positional, repeatable, 1+); `--public`; `--internal`; `--yes`; `--replace-existing`; `--dry-run` (requires `--replace-existing` — EC-3.9.020-6, clap `requires`, exit 2); `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); `.factory/research/issue-576-attachments-api-2026-07-15.md` §1e+§P2-1 (XSRF guard — "rejected without it"; research file SILENT on specific 403 body text — P12-003 hedge); Jira Cloud REST API v3 `POST /rest/api/3/issue/{issueIdOrKey}/attachments`; SEC-576-004 (CWE-93 multipart encoding test added 2026-07-15); SEC-576-005 (CWE-352 X-Atlassian-Token wiremock test added 2026-07-15); P19-004 (--dry-run clap-requires annotation); P12-003 (403 body text hedged: prior "Websudo required" unverified; research §1e+§P2-1 document XSRF guard but not the specific error body)

---

#### BC-3.9.002: Upload to JSM issue with no visibility flag → platform POST, internal by default (safe default; P2-4a confirmed)

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload (implementation pending — story S3)
**Subject**: Issue write (attachment upload — JSM default path)

When `jr issue attachment upload <KEY> <FILE>...` is issued against a JSM issue key and neither `--public` nor `--internal` is specified, `jr` uses the platform POST endpoint (`POST /rest/api/3/issue/{key}/attachments`) — the same path as BC-3.9.001.

Per research finding P2-4a (`.factory/research/issue-576-attachments-api-2026-07-15.md` §P2-4a), platform-POST attachments on a JSM issue are INTERNAL by default — not customer-visible on the service portal. This is a safe default: an agent accidentally uploading a sensitive file does not immediately expose it to the customer.

No service desk discovery is performed on this path. No servicedeskapi calls are made. No confirmation gate is presented. Behavior is byte-for-byte identical to uploading to a non-JSM issue.

The platform POST path is the default for ALL issue keys regardless of project type when no visibility flag is supplied.

**EC-3.9.002-1** (non-JSM issue, no flag): Same platform POST path; no difference in wire behavior between JSM and non-JSM issues on this path.
**EC-3.9.002-2** (--public or --internal supplied): Routing forks per BC-3.9.003 or BC-3.9.004 respectively; this BC does not apply.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); `.factory/research/issue-576-attachments-api-2026-07-15.md` §P2-4a (CONFIRMED: platform-POST is internal by default on JSM issues — refutes footgun hypothesis from Part 1)

---

#### BC-3.9.003: `--public` flag → servicedeskapi two-step (attachTemporaryFile + request attachment) with confirmation gate (DEC-174); `--yes` bypass; non-interactive exit 64

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload (implementation pending — story S5); src/api/jsm/attachments.rs::attach_temporary_file (implementation pending — story S5); src/api/jsm/attachments.rs::post_request_attachment (implementation pending — story S5); `tests/attachment_upload_jsm.rs` (implementation pending — story S5)
**Subject**: Issue write (attachment upload — JSM public path)

When `--public` is supplied, `jr issue attachment upload <KEY> <FILE>... --public` routes to the servicedeskapi two-step flow:

**Step 0 — issue existence validation and project key extraction (P16-003)**: `GET /rest/api/3/issue/{key}` (no `?fields` restriction needed; the existence check is the goal). If the issue does not exist or is inaccessible → 404 → exit 64 per EC-3.9.012-2 (`"Issue <KEY> not found or not accessible."`); no servicedeskapi calls issued. On success, `fields.project.key` is extracted from the response and passed to `get_or_fetch_project_meta` in the next step. **projectTypeKey source pinned**: project-type detection reads from `get_or_fetch_project_meta` (`GET /rest/api/3/project/{key}`, `ProjectMeta` cache, BC-X.8.010) — NOT from the issue GET's embedded `fields.project.projectTypeKey` value. The issue GET provides existence validation and the `project_key` string; the separate project-meta call provides the authoritative `projectTypeKey`. **Key-derivation asymmetry vs BC-3.9.017 step 0**: the `--replace-existing` path (BC-3.9.017 step 0) derives the project key from the issue key string prefix (`FOO-1` → `FOO`) because no issue GET has run yet at that pre-flight point; this BC-3.9.003 path runs the issue GET first, then passes `fields.project.key` to `get_or_fetch_project_meta` — Jira guarantees these two derivation paths produce identical project keys (an issue's `fields.project.key` equals its key prefix). The "deliberately equivalent" statement in BC-3.9.017 step 0 is the canonical note of this equivalence; BC-3.9.003 additionally needs the issue GET for existence validation; the `--replace-existing` path gets existence validation from its step-1 `?fields=attachment` GET instead.

**Step 1 — temporaryAttachmentId per file**: For each `<FILE>`, POST `/rest/servicedeskapi/servicedesk/{sdId}/attachTemporaryFile` with the file as a multipart body. Obtains one `temporaryAttachmentId` per file. **Retry rebuild per attempt**: the streaming-upload retry constraint from BC-3.9.001 (ADR-0017) applies equally here — `RequestBuilder::try_clone()` returns `None` for streamed multipart bodies; each retry attempt MUST rebuild the entire multipart request from the file path on disk (fresh `tokio::fs::File::open` + new `ReaderStream`). The `sdId` is resolved by calling `get_or_fetch_project_meta` (`src/api/jsm/servicedesks.rs`) — the EXISTING cache-backed implementation shared with `jr queue`, `jr requesttype`, and other JSM commands — passing `project_key` extracted from `fields.project.key` in the issue GET response. This function internally: fetches `GET /rest/api/3/project/{project_key}` to obtain `project.id`; paginates `GET /rest/servicedeskapi/servicedesk` matching on `serviceDesk.projectId == project.id` (NOT `projectKey` — verified: `src/types/jsm/servicedesk.rs::ServiceDesk` has `project_id` from `#[serde(rename = "projectId")]`, no `projectKey` field; P6-001 correction); returns `ProjectMeta.service_desk_id`. The result is cached in the existing `project_meta.json` per `(profile, projectKey)` with a 7-day TTL (BC-X.8.010). The `POST .../attachTemporaryFile` request MUST include `X-Atlassian-Token: no-check` (same CSRF requirement as BC-3.9.001; SEC-576-005 parallel — a wiremock test MUST assert this header is present on step-1 POSTs). **Step-1 self-heal (SEC-576-006, BC-X.8.010, P30-001)**: A 404 or 403 response to this step-1 POST FIRST triggers the BC-X.8.010 SEC-576-006 self-heal before falling through to the BC-3.9.012 error mapping: the `project_meta.json` cache entry for `(profile, projectKey)` is invalidated, `get_or_fetch_project_meta` is re-called once (cache-miss path, re-resolves via `GET /rest/api/3/project/{key}` + paginated `GET /rest/servicedeskapi/servicedesk`), and step 1 is re-attempted with the re-resolved `sdId`. Only the post-retry response falls through to BC-3.9.012: post-retry 404 → exit 64 (`"Service desk for <projectKey> not found after refresh."`); post-retry 403 → exit 1 (permission denied). The retry is single-attempt — it does not loop. All other codes (401, 5xx, network) map to BC-3.9.012 on first occurrence without a self-heal retry.

**Step 2 — make public**: POST `/rest/servicedeskapi/request/{issueKey}/attachment` with body `{"temporaryAttachmentIds": ["<id1>", ...], "public": true}`.

**Confirmation gate (DEC-174 pattern — NOT `dialoguer::Confirm`)**: Before step 1, `jr` presents a confirmation prompt. See BC-3.9.014 for the exact prompt mechanics (eprint! to stderr + io::stdin().lock().read_line, matching BC-3.5.007/BC-3.5.008 precedent).

- **Interactive mode**: Prompt presented; **three-way branch** (see BC-3.9.014 for exact `eprint!+read_line` mechanics): (a) `y`/`yes` → proceed to step 1 and step 2; (b) any other text including empty-Enter (user pressed Enter with no text; `read_line` returns `Ok(n)`, n ≥ 1, buffer is `"\n"`) → "Upload cancelled." on **stderr**; `{"cancelled":true,"uploaded":false}` on JSON stdout; exit 0; (c) EOF (`read_line` returns `Ok(0)`, i.e. Ctrl+D with zero bytes read) or any IO error (`Err(_)`) → `JrError::Interrupted`, exit 130 — **NOT** the cancel path and **NOT** exit 0. The Ok(0) EOF branch is distinguishable from empty-Enter and is load-bearing.
- **Non-interactive mode** (`--no-input` OR stdin is not a TTY): exit 64 before any servicedeskapi call and before any upload POST (the Step-0 issue GET and project-meta resolution have already run — EC-3.9.003-7 evaluates eligibility first); stderr: `"Use --yes to confirm uploading <N> file(s) to <KEY> as customer-visible, or run interactively."` (substring-matchable wording; `--yes` hint is mandatory per BC-3.5.007 pattern).
- **`--yes` flag**: Skip the confirmation gate; proceed directly to step 1 without reading stdin.

`--public` on a non-JSM issue → exit 64 (BC-3.9.005 governs; no servicedeskapi calls).

Output channel: Profile 4 (Symmetric). On success: human mode echoes "Uploaded N file(s) to <KEY> [public]."; JSON mode returns the upload result (see BC-3.9.011 for shape; confirmed P2-3c probe runs 29936980027 + 29940792930 + 29945857059).

**EC-3.9.003-1** (`--yes` without `--public`): Silent no-op per DEC-169 leniency convention — `--yes` alone does not trigger the confirmation gate or change upload routing; platform POST path proceeds as normal.
**EC-3.9.003-2** (single file, `--yes`): One temporaryAttachmentId; second-step body `{"temporaryAttachmentIds":["<id>"],"public":true}`.
**EC-3.9.003-3** (multiple files, `--yes`): One step-1 POST per file in order; second-step body `{"temporaryAttachmentIds":["<id1>","<id2>",...],"public":true}`.
**EC-3.9.003-4** (cancel at prompt, interactive — non-EOF branch (b)): exit 0; human "Upload cancelled." on **stderr**; JSON `{"cancelled":true,"uploaded":false}` on stdout.
**EC-3.9.003-5** (invoked from BC-3.9.017 `--replace-existing` step 4, OR from BC-3.9.018 `--replace-existing` zero-match path, OR from the P15-002/R3.12 `--replace-existing`-with-≥1-match-gate path): the confirmation gate defined in this BC is NOT re-presented. **Step-4 path (BC-3.9.017, ≥1 match + `--public`)**: the combined gate (BC-3.9.014 consumer 3) was resolved at BC-3.9.017 step 2 — if cancelled there, BC-3.9.003 is never reached; if passed, proceeding to step 4 implies the gate is satisfied. **Step-4 path (BC-3.9.017, ≥1 match, no `--public`)**: the replace-existing gate (BC-3.9.014 consumer 2) was resolved at step 2 — gate is satisfied; BC-3.9.003 gate MUST NOT fire on JSM upload. **Zero-match path (BC-3.9.018, P7-002)**: the gate was also resolved at BC-3.9.017 step 2 — it fires before any destructive call (upload POST included), even when no DELETEs are needed. In all cases: only the servicedeskapi wire steps (step 1: `attachTemporaryFile`; step 2: `post_request_attachment`) execute on this call path. Gate state: RESOLVED (do not prompt again). One gate per invocation, ever. (P15-002/R3.12 extended three entry points to this suppression path.) **Step-0 suppression (P17-003)**: when BC-3.9.003 is entered from BC-3.9.017 step 4, Step 0 (issue GET) is SKIPPED — existence was already validated by BC-3.9.017 step 1's `?fields=attachment` GET and project meta was already resolved at its step 0; exactly ONE issue GET occurs per invocation on the combined `--replace-existing --public` path.
**EC-3.9.003-6** (EOF at confirmation prompt — branch (c)): `read_line` returns `Ok(0)` (Ctrl+D, zero bytes read) or `Err(_)` (IO error) → `JrError::Interrupted`, exit 130. NOT exit 0. NOT "Upload cancelled." message. Distinct from branch (b) (empty-Enter, `Ok(n)` with n ≥ 1). This aligns with EC-3.5.003-3 (comment edit --public EOF precedent) and BC-3.9.014 three-way branch. Pins H-NEW-ATTACHMENT-009.
**EC-3.9.003-7** (guard-precedence: non-JSM check fires BEFORE non-interactive gate): `--public` on a non-JSM issue (BC-3.9.005 eligibility guard) MUST be evaluated before the non-interactive `--no-input`/TTY gate and before any `--yes` bypass takes effect. A command like `jr issue attachment upload PLATFORM-1 file.txt --public --yes` on a non-JSM issue MUST exit 64 with the non-JSM error (BC-3.9.005), NOT silently proceed because `--yes` is present. Guard evaluation order: (1) JSM eligibility check (BC-3.9.005) → if non-JSM, exit 64; (2) interactive vs. non-interactive branch; (3) `--yes` bypass or prompt. P14-002 finding.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); DEC-174 (interactive prompt mechanism: eprint!+read_line, NOT dialoguer); DEC-169 (leniency: --yes without --public = silent no-op); `.factory/research/issue-576-attachments-api-2026-07-15.md` §P2-3, §P2-4; BC-3.5.007 (comment edit --public confirmation pattern); BC-X.8.010 (serviceDeskId cache); SEC-576-005 (CWE-352 X-Atlassian-Token step-1 wiremock test added 2026-07-15); P14-001 (EOF three-way branch — exit 130 not exit 0); P14-002 (guard-precedence: non-JSM check before non-interactive gate); P14-003 (cancel message channel: stderr not stdout); P16-003 (Step 0 added: issue GET for existence validation + project key; projectTypeKey source pinned to get_or_fetch_project_meta NOT issue GET; key-derivation asymmetry vs BC-3.9.017 step 0 extended); P17-003 (EC-3.9.003-5 Step-0 suppression: when entered from BC-3.9.017 step 4, Step 0 SKIPPED — existence validated by step 1's `?fields=attachment` GET; ONE issue GET per invocation on combined `--replace-existing --public` path); P22-001 (non-interactive bullet corrected: 'exit 64 before any HTTP' → 'exit 64 before any servicedeskapi call and before any upload POST — Step-0 issue GET and project-meta resolution have already run'; BC-3.9.012 trigger column 'local' → 'local (after Step-0 issue GET + meta fetch)'); P30-001 (step-1 self-heal sentence added to Step 1: SEC-576-006/BC-X.8.010 invalidate+retry-once on step-1 404/403 BEFORE BC-3.9.012 mapping; post-retry exit codes per BC-X.8.010 step 4)

---

#### BC-3.9.004: `--internal` flag → servicedeskapi two-step with `public:false`; no confirmation gate; non-JSM issue = SILENT NO-OP (OQ-9 ruling)

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload (implementation pending — story S5); src/api/jsm/attachments.rs::post_request_attachment (implementation pending — story S5)
**Subject**: Issue write (attachment upload — JSM internal explicit path)

When `--internal` is supplied, `jr` first performs issue existence validation and project type detection (Step 0), then branches based on project type:

**Step 0 — issue existence validation and project type detection (inherits BC-3.9.003 Step 0 + BC-3.9.005 detection mechanism; P20-001)**: `GET /rest/api/3/issue/{key}` (existence validation). If the issue does not exist or is inaccessible → 404 → exit 64 per EC-3.9.012-2. On success, `fields.project.key` is extracted and passed to `get_or_fetch_project_meta` (`GET /rest/api/3/project/{key}`, cache-backed; BC-3.9.005 detection mechanism, BC-X.8.010). The `projectTypeKey` returned determines which branch executes.

**(a) JSM branch** (`projectTypeKey == "service_desk"`): routes to the servicedeskapi two-step flow identical to BC-3.9.003 but with `"public": false` in the second-step body. HTTP sequence: step 0 issue GET → project-meta resolution per BC-X.8.010 (up to 2 cache-miss GETs: `GET /rest/api/3/project/{key}` + `GET /rest/servicedeskapi/servicedesk` pagination for `serviceDeskId`) → N × POST `.../attachTemporaryFile` → 1 × POST `.../request/{issueKey}/attachment`. [P21-004]

**Step 1**: POST `.../attachTemporaryFile` per file (same as BC-3.9.003).
**Step 2**: POST `.../request/{issueKey}/attachment` with `{"temporaryAttachmentIds": [...], "public": false}`.

**No confirmation gate**: `--internal` does NOT trigger any interactive prompt. Internal attachments are the safe default on JSM (attachments are non-customer-visible); a confirmation gate would add friction without a safety benefit. The upload proceeds immediately.

**(b) Non-JSM branch — OQ-9 silent no-op** (`projectTypeKey != "service_desk"`): `jr` falls back silently to the platform POST path (BC-3.9.001). HTTP sequence: step 0 issue GET → project GET (cache-miss only) → platform POST `/rest/api/3/issue/{key}/attachments`; zero servicedeskapi calls issued. No error is emitted, no warning is written. Rationale: platform POST is already internal by default (P2-4a); `--internal` expresses intent that is already satisfied — silently. This is the OQ-9 design ruling from DEC-179.

**Mutual exclusion**: `--internal` and `--public` are clap `conflicts_with` → exit 2 (clap error) if both are supplied.

**EC-3.9.004-1** (non-JSM, `--internal`): Platform POST executes; no servicedeskapi calls issued; no warning emitted; exit 0 on success.
**EC-3.9.004-2** (JSM, `--internal`): Two-step executed; `"public":false` in the second POST body; no confirmation prompt.
**EC-3.9.004-3** (`--internal` + `--public` together): clap mutual-exclusion conflict → exit 2; clap-generated error message; no HTTP.
**EC-3.9.004-4** (Step-0 suppression when entered from BC-3.9.017 step 4, `--replace-existing --internal` path, P21-005): when BC-3.9.004 is invoked from BC-3.9.017 step 4, Step 0 (issue GET) is SKIPPED — existence was already validated by BC-3.9.017 step 1's `?fields=attachment` GET and the project key was already resolved at BC-3.9.017 step 0 (string-prefix derivation); exactly ONE issue GET per invocation on the combined `--replace-existing --internal` path. Only the servicedeskapi wire steps (or platform POST for non-JSM) execute. Symmetric with EC-3.9.003-5 P17-003 (same suppression for `--replace-existing --public` path).

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179 OQ-9 ruling); DEC-169 (leniency convention); `.factory/research/issue-576-attachments-api-2026-07-15.md` §P2-4a; P20-001 (Step 0 inheritance: issue GET + `get_or_fetch_project_meta` detection; full HTTP sequence for JSM branch (a) and non-JSM OQ-9 branch (b)); P21-004 (branch (a) HTTP sequence: 'project GET (cache-miss only)' expanded to BC-X.8.010 full resolution — up to 2 cache-miss GETs: `GET /rest/api/3/project/{key}` + `GET /rest/servicedeskapi/servicedesk` pagination for `serviceDeskId`); P21-005 (EC-3.9.004-4: Step-0 suppression when entered from BC-3.9.017 step 4 on `--replace-existing --internal` path; symmetric with EC-3.9.003-5 P17-003)

---

#### BC-3.9.005: `--public` on non-JSM issue → exit 64 with actionable message; no servicedeskapi calls

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload (implementation pending — story S5)
**Subject**: Issue write (attachment upload — --public non-JSM guard)

When `--public` is supplied and the issue is NOT a JSM service desk issue, `jr` exits 64 with a message on stderr. No servicedeskapi calls are issued; no file upload occurs.

Stderr message (CANONICAL SOURCE — substring-matchable by tests): `"--public is only supported on Jira Service Management (JSM) issues."`

The JSM detection mechanism is `projectTypeKey == "service_desk"` (from `ProjectMeta.project_type`, populated by `get_or_fetch_project_meta` via `GET /rest/api/3/project/{projectKey}`). When `projectTypeKey != "service_desk"`, the service desk list call inside `get_or_fetch_project_meta` is bypassed entirely — only a platform project GET (or cache hit) is needed; **zero servicedeskapi calls** are issued during this check. The check is performed after extracting `fields.project.key` from the issue GET response, but before any attachment API calls. [P6-002: detection mechanism stated explicitly; H-NEW-ATTACHMENT-008 compatible — `--yes` bypasses the confirmation gate only, not this exit-64 guard.]

**`--replace-existing` path (P8-002)**: on the `--replace-existing` path (BC-3.9.017 step 0 eligibility pre-flight), this guard fires BEFORE the list GET, the confirmation gate, and any DELETE. The project key is derived from the issue key string prefix (e.g., `FOO-1` → `FOO`) and passed to `get_or_fetch_project_meta` (cached). If `projectTypeKey != "service_desk"` → exit 64; canonical message; **zero DELETEs issued; zero upload POST.** This is an unconditional pre-flight, not an after-the-fact check — no existing attachment is touched before the exit-64 fires.

**Divergence from `--internal` behavior**: `--internal` on a non-JSM issue is a silent no-op (BC-3.9.004 OQ-9); `--public` on a non-JSM issue is exit 64. Rationale: making an attachment customer-visible requires a servicedeskapi flow — there is no silent fallback that preserves the `--public` semantic. Exiting 64 prevents a misleading "upload succeeded" message when the public-visibility intent was not fulfilled.

**EC-3.9.005-1** (platform issue, `--public`): exit 64; no attachment uploaded; canonical message on stderr.
**EC-3.9.005-2** (issue key not found): superseded by EC-3.9.012-2 — issue-not-found exit-64 fires before project-type determination.
**EC-3.9.005-3** (`--public --replace-existing`, non-JSM, P8-002): pre-flight fires at BC-3.9.017 step 0; exit 64; canonical message; **zero DELETEs issued; zero upload POST**. The list GET (BC-3.9.017 step 1) is never reached. This guard fires even when `--dry-run` is supplied — eligibility guards are NOT dry-run-suppressed (contrast BC-3.9.014 gates which ARE suppressed per EC-3.9.020-7; see EC-3.9.020-8; P23-002). No preview is emitted.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); OQ-9 ruling (--internal non-JSM = silent no-op; --public non-JSM = exit 64 — asymmetric by design); P23-002 (EC-3.9.005-3 extended: dry-run does not suppress this eligibility guard; cross-ref EC-3.9.020-8)

---

#### BC-3.9.006: temporaryAttachmentId lifecycle (~1 h TTL); step-2 HTTP errors → retry hint (429 deliberately no Retry-After retry, P8-001); step-2 transport error → NetworkError, no retry hint; no ID caching or reuse

**Confidence**: MEDIUM-HIGH
**Source**: src/api/jsm/attachments.rs::post_request_attachment (implementation pending — story S5)
**Subject**: Issue write (attachment upload — JSM temp-ID lifecycle)

A `temporaryAttachmentId` obtained from `POST .../attachTemporaryFile` has an approximate 1-hour server-side TTL per Atlassian documentation. `jr` does NOT cache or reuse temporary attachment IDs across invocations; each upload invocation performs both steps (step 1 → step 2) within the same sequential request sequence.

If the second step (`POST .../request/{issueKey}/attachment`) fails AFTER one or more step-1 calls have already succeeded, `jr` MUST NOT attempt to surface, cache, or offer to reuse the orphaned `temporaryAttachmentId`(s). On second-step failure:

- HTTP 4xx (excluding 401 and 403): exit 64 (client error — the plausible causes are an expired `temporaryAttachmentId` (>~1 h TTL) or a malformed request body; the step 2 endpoint keys off `issueKey`, not `serviceDeskId`, so a stale-sdId cache is not a root cause here); retry hint on stderr. **Deliberate 429 asymmetry (P8-001/F5-R8-001):** HTTP 429 ("Too Many Requests") falls into this generic 4xx bucket — there is **no Retry-After auto-retry loop** on step-2. This is asymmetric with the step-1 `attachTemporaryFile` path (which retries 429 per BC-X.8.010) and the platform upload path (which retries 429 via `send_with_retry`). Rationale: step-2 is a single small JSON POST issued immediately after step-1 succeeds; a 429 there is rare; the ~1 h temp-attachment TTL makes a manual re-run safe; the blast radius is low. The carve-out was explicitly deferred at the SOH-ATTACHMENTS-1 wave gate (P8-001). The generic hint `"Temporary attachment IDs may have expired. Try the upload again."` is imprecise for the 429 sub-case — this imprecision is accepted; a dedicated 429 arm with Retry-After parsing is a candidate future enhancement, not a defect (see also EC-3.9.006-7).
- HTTP 401: exit 2 (not authenticated — standard house taxonomy per BC-3.9.012; `jr auth login` hint on stderr); retry hint on stderr.
- HTTP 403: exit 1 (permission denied — standard house taxonomy per BC-3.9.012; Jira error body surfaced); retry hint on stderr.
- HTTP 5xx: exit 1 (`JrError::ApiError`; server error); retry hint on stderr.
- Transport/network error (connection refused, DNS failure, timeout): exit 1 (`JrError::NetworkError`); stderr: `"Could not reach <host> — check your connection"` (standard connectivity message); **no retry hint** (parity with step-1 transport mapping in BC-3.9.012; a connectivity error indicates network unavailability, not temp-ID expiry).

All HTTP error branches (4xx excl. 401/403, 401, 403, 5xx) append the generic retry hint: `"Temporary attachment IDs may have expired. Try the upload again."` — no Atlassian response-body error string is pattern-matched (P2-2 finding: Cloud step-2 error strings are undocumented and must not be relied on). Transport/network errors do **not** append this hint.

The ~1-hour TTL is informational context for the retry hint wording; `jr` implements no timer, no expiry check, and no proactive re-issue of step 1.

**EC-3.9.006-1** (step-2 400): exit 64; generic retry hint on stderr.
**EC-3.9.006-4** (step-2 401): exit 2; not-authenticated hint; generic retry hint on stderr.
**EC-3.9.006-5** (step-2 403): exit 1; Jira error body surfaced; generic retry hint on stderr.
**EC-3.9.006-2** (step-2 5xx): exit 1 (`JrError::ApiError`); generic retry hint on stderr.
**EC-3.9.006-6** (step-2 transport/network error): exit 1 (`JrError::NetworkError`); stderr: standard connectivity message (`"Could not reach <host> — check your connection"`); no retry hint; parity with step-1 transport mapping.
**EC-3.9.006-3** (both steps succeed): no TTL concern; BC-3.9.007 governs post-upload echo.
**EC-3.9.006-7** (step-2 429 — deliberate asymmetry, P8-001/F5-R8-001): exit 64 (same as generic 4xx); generic retry hint on stderr (`"Temporary attachment IDs may have expired. Try the upload again."`); **no Retry-After auto-retry** — intentional (see 4xx bullet above and rationale in BC heading). The hint text is imprecise for this sub-case (accepted imprecision); a dedicated 429 arm with Retry-After parsing is a candidate future enhancement, not a defect.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); `.factory/research/issue-576-attachments-api-2026-07-15.md` §P2-2 (Cloud step-2 error strings undocumented — do NOT pattern-match); FIX-F5-006 (2026-07-23, F5-R1-007): step-2 transport branch split from 5xx — transport/network errors → `JrError::NetworkError` (exit 1, standard connectivity message, no expired-ID retry hint), parity with step-1; `tests/attachment_jsm.rs::test_bc_3_9_006_jsm_upload_error_taxonomy` (existing — HTTP branches sub-assertions 6–10); `src/api/jsm/attachments.rs::tests::test_bc_3_9_006_step2_network_error_uses_connectivity_message_no_retry_hint` (renamed from `test_bc_3_9_006_step2_network_error_appends_retry_hint`; on develop post FIX-F5-006/007 merges); `src/api/jsm/attachments.rs::tests::test_f5_r1_007_step2_network_error_uses_canonical_network_error_variant` (on develop post FIX-F5-006/007 merges); P8-001/F5-R8-001 (2026-07-24): 429 deliberate-asymmetry note added to 4xx bullet + EC-3.9.006-7 + heading — step-2 429 falls into generic 4xx→exit 64 bucket with no Retry-After auto-retry, asymmetric with step-1 `attachTemporaryFile` (retries 429 per BC-X.8.010) and platform upload path (retries 429 via `send_with_retry`); carve-out rationale recorded (rare 429, ~1 h TTL, low blast radius); hint-text imprecision accepted

---

#### BC-3.9.007: Post-upload echo from server response; platform path uses direct response; servicedeskapi step-2 extracts attachments.values[]; JSDCLOUD-10841 content-URL ban

**Confidence**: HIGH (servicedeskapi response schema confirmed by P2-3c probe runs 29936980027 + 29940792930 + 29945857059, S-576-5)
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload; src/api/jsm/attachments.rs::post_request_attachment
**Subject**: Issue write (attachment upload — post-upload echo)

After a successful upload, `jr` echoes metadata from the server response directly — no secondary fetch from the issue's `fields.attachment` array is performed.

**Platform POST path** (BC-3.9.001, BC-3.9.002): The `POST /rest/api/3/issue/{key}/attachments` response body IS the created attachment array. `jr` derives its success echo from this response array, serialized in the curated form (BC-2.7.002 authority: `"self"` omitted, `"content"` renamed to `"contentUrl"`). The raw API wire fields are documented in BC-3.9.001 as facts; the output is the curated form. No second fetch is required.

**servicedeskapi two-step path** (`--public`/`--internal`, BC-3.9.003/004): The response from `POST /rest/servicedeskapi/request/{id}/attachment` is an **AttachmentCreateResultDTO** object (confirmed by P2-3c probe runs 29936980027 + 29945857059):
```json
{
  "comment": { ... } | null,
  "attachments": {
    "size": N,
    "start": 0,
    "limit": 50,
    "isLastPage": true,
    "values": [ ...AttachmentDTO... ]
  }
}
```
`jr` extracts `attachments.values[]` from this object and applies the same curated form as the platform path (BC-2.7.002: `"self"` omitted, `"content"` renamed to `"contentUrl"`). The `comment` field and the pagination envelope (`size`, `start`, `limit`, `isLastPage`) are discarded — only `values[]` is used. Implemented in `src/api/jsm/attachments.rs::post_request_attachment`.

**JSDCLOUD-10841 content-URL ban**: The `links.content` URL that may appear in servicedeskapi responses for attachments MUST NOT be used for download or verification — that URL returns HTTP 404. The authoritative download endpoint is the platform endpoint: `GET /rest/api/3/attachment/content/{id}` (BC-2.7.007). Any content URL from servicedeskapi is informational only.

**EC-3.9.007-1** (platform upload echo): Response array from POST is used directly; no secondary GET to the issue's attachment list. **Allocation note (P17-005)**: EC-3.9.007-1 platform-echo clause is exercised in S3 (covered by BC-3.9.001 + BC-3.9.009; R3.13 earliest-consumer principle); S5 owns JSM echo clauses (EC-3.9.007-2).
**EC-3.9.007-2** (servicedeskapi upload echo): Step-2 response is an `AttachmentCreateResultDTO` object; `jr` extracts `resp["attachments"]["values"]` array and curates each entry **field-by-field** (defensive, never a typed-struct `from_value` that could fail on schema drift — confirmed by P2-3c probe run 29940792930). The servicedeskapi `AttachmentDTO` shape differs from the platform `AttachmentObject`: `id` is absent at the top level and is extracted as the last path segment of `_links.jiraRest`; `contentUrl` is extracted from `_links.content` (not a top-level `content` field); `created` is an object `{"iso8601":"…","jira":"…","friendly":"…","epochMillis":N}` and the `iso8601` value is used. All fields have graceful fallbacks (empty string / `None` / 0) so missing or changed fields never error the command. Output is the curated array (same shape as platform path: `{author, contentUrl, created, filename, id, mimeType, size}`). Routes through `output::render_json` (#526 invariant; BC-3.9.011). Implemented in `src/api/jsm/attachments.rs::curate_jsm_attachment_entry`.
**EC-3.9.007-3** (JSDCLOUD-10841): `links.content` URL from servicedeskapi MUST NOT be used; `GET /rest/api/3/attachment/content/{id}` is authoritative for downloads.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); P2-3c probe run 29936980027 (S-576-5, confirmed `AttachmentCreateResultDTO` object shape); JSDCLOUD-10841 (servicedeskapi `links.content` returns 404)

---

#### BC-3.9.008: `attachment delete` → `DELETE /rest/api/3/attachment/{id}`; HTTP 204 = success; 404 = exit 64 + surface Jira body (DEC-168 precedent; mirrors BC-3.5.004)

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_delete (implementation pending — story S4); src/api/jira/attachments.rs::delete_attachment (implementation pending — story S4); `tests/attachment_delete.rs` (implementation pending — story S4)
**Subject**: Issue write (attachment delete)

`jr issue attachment delete <AID>...` issues `DELETE /rest/api/3/attachment/{id}` for each supplied `<AID>`. One or more numeric attachment IDs may be supplied as positional arguments; for a single AID the command issues one DELETE. **OQ-7 ruling (DEC-179)**: the delete command takes only attachment ID(s) as positional arguments — there is NO `<KEY>` argument. The server enforces issue ownership; no client-side KEY validation is performed.

**AID validation (P7-001, CWE-88)**: each supplied `<AID>` is validated against `^[0-9]+$` BEFORE any HTTP call. A non-numeric or path-traversal-shaped AID (e.g., `"10001/../../issue/X"`) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; no HTTP requests are issued. This fires before both the single-AID confirmation gate (BC-3.9.015) and the bulk `--yes` check (BC-3.9.016). **(CWE-88 here frames URL-path argument injection; the traversal-shaped payload class also maps to CWE-22 — the `^[0-9]+$` mitigation covers both; P40-I2)**

**HTTP 204 (success)**: exit 0. Human output: `"Deleted attachment <AID>."`. JSON output (with `--output json`): see BC-3.9.010.

**HTTP 404 (attachment not found)**: exit 64. The Jira error body is surfaced on stderr (NOT silent exit 0). This is the DEC-168 precedent: 404 on a targeted delete of a specific resource ID means the caller provided a wrong ID — the missing attachment is a user error, not an already-completed idempotent operation. The Jira error body typically contains the reason (e.g., "Attachment does not exist") and provides actionable context. Direct precedent: BC-3.5.004 (comment delete 404 surfaces body + exit 64, same reasoning).

Output channel: Profile 4 (Symmetric) — stdout for success data/JSON, stderr for errors.

**EC-3.9.008-1** (valid AID, 204): exit 0; human echo `"Deleted attachment <AID>."`; JSON `{"deleted":true,"id":"<AID>"}`.
**EC-3.9.008-2** (AID not found, 404): exit 64; stderr begins with canonical string `"Attachment <AID> not found or not accessible."` followed by the Jira error body as detail (DEC-168 format: prepend canonical string, append server body).
**EC-3.9.008-3** (server returns 404/403 due to ownership mismatch): `jr` surfaces the server response without special-casing.
**EC-3.9.008-4** (insufficient permissions, 403): exit 1; Jira error body surfaced on stderr.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179 OQ-7 ruling — ID-only delete, no KEY positional); DEC-168 (404 on delete = exit 64, NOT silent exit 0); BC-3.5.004 (comment delete 404 exit-64 + body-surface precedent)

---

#### BC-3.9.009: `attachment upload --output json` shape — array of attachment objects; `output::render_json` required (#526 invariant)

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload (implementation pending — story S3); `output::render_json` (existing)
**Subject**: Issue write (attachment upload — JSON output shape)

When `--output json` is supplied, `jr issue attachment upload` returns a JSON array where each element represents one successfully uploaded file, sourced from the Jira platform POST response.

The attachment-object shape for each element is the **curated form** defined in BC-2.7.002: `{author, contentUrl, created, filename, id, mimeType, size}` (BTreeMap-alphabetical key order — P19-001). Specifically: the raw Jira `"self"` field is OMITTED; the raw `"content"` field is renamed to `"contentUrl"` (same rename convention as the list output). This curated form is the canonical attachment-object JSON shape for `jr` attachment upload and list operations — upload and list JSON outputs use this shape (download is excluded — it uses the distinct `{"downloaded":[...]}` manifest per the BC-2.7.002 authority clause and BC-2.7.007 EC-2.7.007-7). See BC-2.7.002 for field-level documentation and the authoritative key-ordering clause.

The array is pretty-printed via `output::render_json` or `output::print_output` (JSON render invariant #526). Direct `serde_json::to_string_pretty` calls are forbidden at this call site. The output is pretty-printed (not compact).

**EC-3.9.009-1** (single file): Array with one element.
**EC-3.9.009-2** (multiple files): Array with one element per file, in upload order.
**EC-3.9.009-3** (#526 invariant): MUST route through `output::render_json`; direct `serde_json::to_string_pretty` is forbidden.
**EC-3.9.009-4** (`--public`/`--internal` JSON shape): deferred to BC-3.9.011 (P2-3c); this BC covers the platform POST path only.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); JSON render invariant #526 (`output::render_json` required for all `--output json` paths); P24-001 (download-exclusion fix: curated form narrowed to upload and list operations; download uses the distinct `{"downloaded":[...]}` manifest)

---

#### BC-3.9.010: `attachment delete --output json` shape — single `{"deleted":true,"id":"<AID>"}` or bulk `{"count":N,"deleted":true,"ids":[...]}`; BTreeMap-ordered keys

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_delete (implementation pending — story S4); `output::render_json` (existing)
**Subject**: Issue write (attachment delete — JSON output shape)

When `--output json` is supplied, `jr issue attachment delete` returns:

- **Single AID delete**: `{"deleted": true, "id": "<AID>"}` — two keys, alphabetical (BTreeMap-ordered per project convention).
- **Bulk delete** (multiple `<AID>` arguments): `{"count": N, "deleted": true, "ids": ["<AID1>", "<AID2>", ...]}` — `count` = number of successfully deleted attachments; `ids` = AID strings in the order supplied on the command line. **404 is NOT a failure on the bulk path**: a 404 response to any individual DELETE is treated as already-deleted (benign race) per EC-3.9.010-4 and BC-3.9.013 multi-delete 404 exception; the 404'd AID is excluded from `count` and `ids`, and iteration continues. The first NON-404 failure (403, 401, 5xx, network) stops the batch immediately and surfaces the error. **Non-atomic, non-reversible**: AIDs already deleted by earlier iterations are NOT reversed. The exit code follows the HTTP response of the first non-404 failing AID: 401 → exit 2, 403/5xx → exit 1. In human mode: the per-AID error message is written to stderr; in JSON mode: the `JrError` error shape is emitted to stdout, NOT the `{"count":N,...}` success shape. No partial-success envelope is emitted. **Single-vs-bulk 404 divergence (cross-ref BC-3.9.008 / BC-3.9.013)**: 404 on a single-AID targeted delete exits 64 per BC-3.9.008 (DEC-168: targeted delete of a specific ID is a user error); 404 on any AID in a multi-AID bulk delete is a benign skip per BC-3.9.013 — these behaviors are intentionally asymmetric and MUST NOT be unified. [P21-001]

**Zero-count semantics (canonical authority)**: when a bulk delete results in count = 0 (zero matches OR all AIDs were 404-skipped per EC-3.9.010-4), the JSON shape is `{"count":0,"deleted":false,"ids":[]}`. `deleted:false` when count = 0 is intentional: no deletion occurred in this invocation. This is the same shape as BC-3.9.019's zero-match case (authority). `deleted:true` is ONLY emitted when at least one deletion succeeded (count > 0).

All shapes are pretty-printed via `output::render_json` (#526 invariant). On error (404, 401, etc.): the JSON error shape from `JrError`, NOT the success shape.

**EC-3.9.010-1** (single AID, success): `{"deleted":true,"id":"<AID>"}` — 2 keys.
**EC-3.9.010-2** (multiple AIDs, all success): `{"count":N,"deleted":true,"ids":[...]}` — 3 keys.
**EC-3.9.010-3** (error path): `JrError` JSON shape; not the deleted shape.
**EC-3.9.010-4** (partial bulk failure): on multi-AID bulk delete, a 404 response to any individual DELETE is treated as already-deleted (benign race — consistent with BC-3.9.013 multi-delete 404 exception); the 404'd AID is EXCLUDED from the success `count` and `ids` (it was not deleted by this invocation); iteration continues. The first NON-404 failure (403, 401, 5xx, network) stops the batch immediately; error is surfaced (error JSON in JSON mode, stderr in human mode); already-deleted AIDs are not reversed. **All-404 edge case**: if ALL supplied AIDs return 404 (all were already deleted), count = 0 → JSON shape is `{"count":0,"deleted":false,"ids":[]}` (zero-count semantics above); exit 0 (all skipped as benign races; no genuine error).
**EC-3.9.010-5** (all-404 bulk delete, human mode — canonical HINT message): when all supplied AIDs return 404 (count = 0, exit 0 per EC-3.9.010-4), human mode emits `"No attachments deleted (all were already removed or not found)."` to **stderr**. **HINT** (§3.9 stderr taxonomy — classified per EC-2.7.008-6 hint-vs-error principle; JSON-suppressed: the zero-count outcome is carried in the `{"count":0,"deleted":false,"ids":[]}` envelope; the HINT is human mode only). P3-011.

**Scripting note — single vs bulk shape divergence (deliberate, comment-delete family precedent)**: single-AID delete returns `{"deleted":true,"id":"<AID>"}` (2 keys, no `count`); multi-AID bulk returns `{"count":N,"deleted":true,"ids":[...]}` (3 keys, no `id`). This shape divergence is intentional — the same pattern used by `comment delete` (BC-3.5.002/BC-3.5.003). Scripts that accept either input form MUST branch on `.count` presence: if the key is present → bulk shape; if absent → single shape. This differs from `attachment download`, which always uses a uniform array shape (`{"downloaded":[...]}`) regardless of selector. Do NOT attempt to unify the single/bulk delete shapes.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179 OQ-7 ruling — ID-only delete, no KEY positional); JSON render invariant #526; BC-3.9.008 (delete semantics); BTreeMap-key ordering convention (established by BC-3.4.013, `issue edit` JSON shape); P3-011 (EC-3.9.010-5 added: all-404 bulk delete human-mode HINT message — `"No attachments deleted (all were already removed or not found)."` to stderr; §3.9 HINT classification; JSON-suppressed)

---

#### BC-3.9.011: `attachment upload --public/--internal --output json` shape — curated array from AttachmentCreateResultDTO.attachments.values[]

**Confidence**: HIGH (confirmed by P2-3c probe run 29936980027, S-576-5)
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload_jsm; src/api/jsm/attachments.rs::post_request_attachment
**Subject**: Issue write (attachment upload — --public/--internal JSON output shape)

`jr issue attachment upload <JSM-KEY> <FILE>... --public --output json` (and `--internal`) returns a **bare JSON array** — the same curated attachment-object shape as the platform path (BC-3.9.009). The probe confirmed the internal wire format (BC-3.9.007 EC-3.9.007-2) and that `jr`'s extraction + curation pipeline produces an identical output shape across both paths.

**Confirmed output shape**:
```json
[
  {
    "author": {"accountId": "...", "displayName": "..."},
    "contentUrl": "https://…/rest/api/3/attachment/content/<id>",
    "created": "2026-…",
    "filename": "<name>",
    "id": "<id>",
    "mimeType": "<mime>",
    "size": N
  }
]
```
Keys are in BTreeMap-alphabetical order (P19-001). `"self"` is omitted (BC-2.7.002). `"content"` is renamed to `"contentUrl"` (BC-2.7.002). The `comment` field and the pagination envelope from the wire `AttachmentCreateResultDTO` are discarded.

**Platform path symmetry**: The `--public`/`--internal` JSON output is byte-for-byte identical in shape to the platform upload path (BC-3.9.009) — both are bare curated arrays with the same 7 keys. No `"public"` key or JSM-specific wrapper is present in the output (BC-3.9.011 AC-013 invariant).

**EJ-teardown note**: The E2E probe test (`test_e2e_jsm_attachment_upload_public`) uses `jsm_self_close` for ticket teardown. Uploaded attachment files persist independently of ticket status — they are not cleaned up by `jsm_self_close`. The probe attachment is treated as non-sensitive (content: `b"S-576-5 e2e public attachment"`); accepted PII-residue risk is LOW per S-576-5 risk register.

**EC-3.9.011-1** (confirmed shape): JSON output is a bare curated array — `[{author, contentUrl, created, filename, id, mimeType, size}]` — extracted from `AttachmentCreateResultDTO.attachments.values[]` (BC-3.9.007 EC-3.9.007-2). One element per uploaded file. The curated `id` is derived from `_links.jiraRest` URL tail; `contentUrl` from `_links.content`; `created` from `created.iso8601` (the JSM wire `created` field is an object, not a bare string — P2-3c probe run 29940792930).
**EC-3.9.011-2** (#526 invariant): Output routes through `output::render_json`; no direct `serde_json::to_string_pretty` calls.
**EC-3.9.011-3** (no public key): The `"public"` boolean from the step-2 request body is NOT echoed in the output array — the curated shape contains only the 7 attachment-object fields.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); P2-3c probe run 29936980027 (S-576-5, confirmed AttachmentCreateResultDTO object shape + curated-array output shape); P2-3c probe run 29940792930 (S-576-5, confirmed servicedeskapi AttachmentDTO: created=object with iso8601 key; id derived from _links.jiraRest tail; contentUrl from _links.content; defensive field-by-field curation required — `curate_jsm_attachment_entry`); P2-3c probe run 29945857059 (S-576-5, 2026-07-22, final confirmation — curated-array output shape + end-to-end green; probe obligation SATISFIED); BC-3.5.006 (deferred-probe pattern precedent)

---

#### BC-3.9.012: Upload error taxonomy — file-not-found exit 64; 413 actionable message; 401/5xx/network standard exits

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload (implementation pending — story S3/S5); `src/error.rs::JrError` (existing)
**Subject**: Issue write (attachment upload — error taxonomy)

Error exits for `jr issue attachment upload`:

| Error condition | HTTP / local | Exit code | Stderr content |
|---|---|---|---|
| File path not found | local (before any HTTP) | 64 | `"file not found: <path>"` |
| Issue key not found | 404 from the upload POST (platform path) or from the issue GET (`--public` / `--replace-existing` paths) | 64 | `"Issue <KEY> not found or not accessible."` |
| `--public` on non-JSM issue | local (after meta fetch) | 64 | `"--public is only supported on Jira Service Management (JSM) issues."` (BC-3.9.005) |
| Non-interactive without `--yes` (`--public`) | local (after Step-0 issue GET + meta fetch) | 64 | hint to use `--yes` (BC-3.9.014) |
| Attachment too large | 413 | 1 | `"Attachment too large: the file exceeds the server-configured limit."` |
| CSRF token absent (implementation error — `X-Atlassian-Token: no-check` MUST be present per BC-3.9.001) | 403 | 1 | Jira error body surfaced |
| Insufficient permissions (user lacks write scope or attachment permissions) | 403 | 1 | Jira error body surfaced |
| Generic bad request (platform path) | 400 | 1 | Jira error body surfaced (see BC-3.9.006 EC-3.9.006-1 for servicedeskapi step-2 400 → exit 64) |
| Not authenticated | 401 | 2 | stderr contains "Not authenticated" and "jr auth login" (full literal: `Not authenticated. Run "jr auth login" to connect.` — `src/error.rs::JrError` + `src/api/client.rs::send_with_retry`) |
| Server error | 5xx | 1 | `"API error (N)"` |
| Network failure | — | 1 | stderr contains "Could not reach" (full literal: `Could not reach <host> — check your connection` — `src/error.rs::JrError::NetworkError`) |

**Step-1 `attachTemporaryFile` 403/404 carve-out (SEC-576-006, P30-001)**: A 403 or 404 from the JSM step-1 `POST .../attachTemporaryFile` does NOT immediately map to the table above. It first triggers the BC-X.8.010 SEC-576-006 self-heal (invalidate `project_meta.json` cache for `(profile, projectKey)` → re-resolve `serviceDeskId` via `get_or_fetch_project_meta` once → re-attempt step 1). Only the post-retry response falls through to this table: post-retry 404 → exit 64 (`"Service desk for <projectKey> not found after refresh."`); post-retry 403 → exit 1 (permission denied; per BC-X.8.010 step 4 verbatim). All other codes (401, 5xx, network) map to the table on first occurrence without a self-heal retry. A post-retry 401/5xx/network response maps per BC-X.8.010 step 4 (401 → exit 2; 5xx/network → exit 1) — the same universal codes as first-occurrence.

**EC-3.9.012-1** (file-not-found): exit 64; first missing file stops execution; no HTTP issued.
**EC-3.9.012-2** (issue key 404): exit 64; fires before attachment POST.
**EC-3.9.012-3** (413): exit 1; message does NOT state a numeric size limit.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); `src/error.rs::JrError` exit-code mapping; P30-001 (step-1 attachTemporaryFile 403/404 carve-out: BC-X.8.010 self-heal first; post-retry exit codes per BC-X.8.010 step 4); P31-003 (step-1 carve-out extended: post-retry 401/5xx/network → BC-X.8.010 step 4; 401 → exit 2; 5xx/network → exit 1 — same universal codes as first-occurrence); P20-ROUND (BC-3.9.012/BC-3.9.013 error-table 401/network cells corrected to loose-substring form: 401 → contains "Not authenticated"+"jr auth login"; network → contains "Could not reach" — full literals from `src/error.rs::JrError` + src/api/client.rs::send_with_retry)

---

#### BC-3.9.013: Delete error taxonomy — AID 404 exit 64 + surface body (DEC-168); 401/403/5xx/network standard exits

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_delete (implementation pending — story S4); `src/error.rs::JrError` (existing)
**Subject**: Issue write (attachment delete — error taxonomy)

Error exits for `jr issue attachment delete`:

| Error condition | HTTP | Exit code | Stderr content |
|---|---|---|---|
| Invalid AID (non-numeric, e.g. `"10001/../../issue/X"`) | — | 64 | `"invalid attachment id: '<VALUE>' (must be numeric)"` (no HTTP) |
| Attachment not found | 404 | 64 | Jira error body surfaced (DEC-168; BC-3.9.008) |
| Insufficient permissions | 403 | 1 | Jira error body surfaced |
| Not authenticated | 401 | 2 | stderr contains "Not authenticated" and "jr auth login" (full literal: `Not authenticated. Run "jr auth login" to connect.` — `src/error.rs::JrError` + `src/api/client.rs::send_with_retry`) |
| Server error | 5xx | 1 | `"API error (N)"` |
| Network failure | — | 1 | stderr contains "Could not reach" (full literal: `Could not reach <host> — check your connection` — `src/error.rs::JrError::NetworkError`) |

**AID validation (P7-001 correction — prior "does NOT validate" text reversed)**: `jr` validates each supplied `<AID>` against `^[0-9]+$` BEFORE any API call. An invalid AID (non-numeric, empty, or path-traversal-shaped such as `"10001/../../issue/X"`) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; zero HTTP calls issued. Precedent: EC-3.5.002-1 + `src/api/jira/issues.rs:~600` raw-interpolation precondition.

**Multi-delete 404 exception (bulk and --replace-existing paths)**: on multi-attachment delete paths (`--older-than`, multi-AID bulk per BC-3.9.016, `--replace-existing` delete phase per BC-3.9.017), a 404 response to an individual `DELETE` is treated as already-deleted (benign race condition) and is silently skipped; iteration continues. Exit 64 on 404 applies only to single-AID targeted deletes (BC-3.9.008). Non-404 errors (403, 5xx, network) on any delete attempt abort the sequence and surface the error.

**EC-3.9.013-1** (AID 404): exit 64; Jira error body on stderr (NOT silent exit 0 — DEC-168).
**EC-3.9.013-2** (403): exit 1; Jira body on stderr.
**EC-3.9.013-3** (non-numeric/invalid AID, e.g., `"10001/../../issue/X"`): exit 64; stderr `"invalid attachment id: '<VALUE>' (must be numeric)"`; zero HTTP calls issued (P7-001 CWE-88 correction — no server request made).

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179 OQ-7 ruling — ID-only delete, no KEY positional); DEC-168 (404 delete = exit 64 + surface body); BC-3.5.004 (comment delete precedent); BC-3.9.008 (delete contract); P20-ROUND (BC-3.9.013/BC-3.9.012 error-table 401/network cells corrected to loose-substring form — same P20-ROUND fix as BC-3.9.012 Trace)

---

#### BC-3.9.014: Upload confirmation gate mechanics — `eprint!` to stderr + `io::stdin().lock().read_line()`; NOT `dialoguer::Confirm`; mirrors BC-3.5.007/BC-3.5.008; THREE consumers (P15-002)

**Confidence**: HIGH
**Source**: `src/cli/issue/attachments.rs` (implementation pending — story S3, gate mechanics; consumed by S5 --public/combined per R3.13)
**Subject**: Issue write (attachment upload — confirmation gate mechanics)

The upload confirmation gate uses the DEC-174 interactive-prompt mechanism: `eprint!` (NOT `eprintln!`) to stderr, followed by `io::stdin().lock().read_line(&mut buf)`. `dialoguer::Confirm` MUST NOT be used — it returns `Err(NotConnected)` on piped stderr and fails before reading user input.

**Three consumers (P15-002/R3.12)**: this gate mechanism is used by THREE distinct upload triggers, all sharing the same `eprint!+read_line` mechanics and three-way branch:
1. `--public` standalone (BC-3.9.003): fires regardless of same-filename match count, whenever `--public` is present.
2. `--replace-existing` with ≥1 same-filename match (BC-3.9.017 step 2): fires only when pre-flight finds ≥1 match; zero matches → no gate.
3. Combined `--public` + ≥1 match (BC-3.9.017 step 2): fires as ONE combined prompt, NOT two separate gates.

**Prompt text** (stderr, trailing space, no newline — `eprint!`, not `eprintln!`):
- `--public` only, N ≤ 3 files: `"Upload <filename1>, <filename2>, <filenameN> to <KEY> as customer-visible (public)? [y/N] "`
- `--public` only, N > 3 files: `"Upload <N> files to <KEY> as customer-visible (public)? [y/N] "`
- `--replace-existing` with ≥1 match (no `--public`): `"Replace existing attachment(s) on <KEY>:\n  <filename1> (id: <AID1>)\n  ...\nContinue? [y/N] "` (lists all would-delete entries; no summary for >3 — exact count is meaningful for destructive ops)
- Combined `--public` + ≥1 match: `"Upload to <KEY> as customer-visible (public) and replace existing attachment(s):\n  <filename1> (id: <AID1>)\n  ...\nContinue? [y/N] "`

**Accepted affirmative responses** (case-insensitive): `"y"`, `"yes"`. Any other text input including empty string (user pressed Enter) is treated as 'n' (cancel, exit 0). **Exception — EOF and IO error** (DEC-174/EC-3.5.003-3 alignment): `read_line` returning `Ok(0)` (zero bytes, Ctrl+D EOF) or `Err(_)` MUST propagate as `JrError::Interrupted`, exit 130 — consistent with the comment-family precedent (BC-3.5.003, BC-3.5.008).

**Non-interactive path** (`--no-input` OR stdin is not a TTY): the gate is NOT presented; `jr` exits 64 immediately with the hint message. No servicedeskapi calls are issued; no DELETEs are issued. **Three message variants (P17-004)** — symmetric with the three interactive prompt variants above: (1) `--public` only (consumer 1): `"Use --yes to confirm uploading <N> file(s) to <KEY> as customer-visible, or run interactively."` (2) `--replace-existing` with ≥1 same-filename match, no `--public` (consumer 2): `"Use --yes to confirm deletion of existing same-filename attachments."` (3) Combined `--public` + ≥1 match (consumer 3): `"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."`

**`--yes` flag**: bypasses the gate entirely regardless of which consumer triggered it; no stdin read; upload proceeds directly (BC-3.9.017 EC-3.9.017-12).

**Output channel invariant**: all gate text is written to STDERR only. STDOUT remains clean — it must not contain any prompt text, ensuring `--output json` piping is unaffected.

**Direct precedents**: BC-3.5.007 (comment edit `--public` confirmation contract) and BC-3.5.008 (comment edit confirmation gate mechanics detail) — this BC mirrors those contracts for the attachment upload context.

**EC-3.9.014-1** (interactive, 'y'): Gate consumed from stdin; upload proceeds.
**EC-3.9.014-2** (interactive, 'n' or empty — non-EOF branch (b)): exit 0; human "Upload cancelled." on **stderr**; JSON `{"cancelled":true,"uploaded":false}` on stdout.
**EC-3.9.014-3** (non-interactive, no `--yes`): exit 64; hint to use `--yes`.
**EC-3.9.014-4** (`--yes`, non-interactive): gate skipped; upload proceeds immediately; no stdin read.
**EC-3.9.014-5** (`--public` only, N ≤ 3 files): prompt lists individual filenames; N > 3 → "N files" summary.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); DEC-174 (eprint!+read_line, NOT dialoguer — ratified interactive-prompt mechanism); BC-3.5.007 (comment edit --public confirmation contract); BC-3.5.008 (confirmation gate mechanics precedent); P15-002/R3.12 (three-consumer note, replace-existing and combined prompt variants added)

---

#### BC-3.9.015: `attachment delete <AID>` interactive confirmation gate — `eprint!+read_line` (DEC-174); non-interactive → exit 64 + `--yes` hint; `--yes` bypasses; cancel shape `{"cancelled":true,"deleted":false}`

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_delete (implementation pending — story S4)
**Subject**: Issue write (attachment delete — single-ID confirmation gate)

`jr issue attachment delete <AID>` requires explicit user confirmation before issuing `DELETE /rest/api/3/attachment/{id}`. This mirrors the `comment delete` gate pattern (BC-3.5.002, BC-3.5.003, DEC-174). The gate fires on every single-ID delete; `--yes` is the non-interactive bypass.

**AID validation fires before the gate (P7-001)**: `jr` validates `<AID>` against `^[0-9]+$` before any HTTP call, including the pre-prompt metadata GET (step 1 below). A non-numeric or path-traversal-shaped AID → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; no HTTP calls issued; gate not presented.

**Gate mechanics (DEC-174 canonical pattern)**:

1. **Interactive TTY path** (stdin is a TTY AND `--no-input` is absent AND `--yes` is absent): write the prompt to stderr using `eprint!` (NOT `eprintln!`) with a trailing space and no newline: `"Delete attachment <filename> (<AID>)? [y/N] "`. Where `<filename>` is retrieved via `GET /rest/api/3/attachment/{id}` (one extra GET before the prompt to fetch display metadata). **`<filename>` MUST be display-sanitized** (replaced with `?` per the BC-2.7.011 display-sanitization character set) before writing to the TTY per BC-2.7.011 display-sanitization requirement (SEC-576-011 — CWE-116); this prevents terminal injection via crafted filenames embedded in the confirmation prompt. Read one line via `io::stdin().lock().read_line(&mut buf)`. Accepted affirmative responses (case-insensitive, after trim): `"y"`, `"yes"`. **Three-way branch** (DEC-174/EC-3.5.003-3 alignment): (a) `"y"`/`"yes"` → proceed; (b) any other non-empty text, or empty-Enter (`read_line` returns `Ok(n)`, n ≥ 1, buffer `"\n"`) → cancel, exit 0 (`"Deletion cancelled."`); (c) EOF — `read_line` returns `Ok(0)` (zero bytes, Ctrl+D) — or any `Err(_)` (IO error) → `JrError::Interrupted`, exit 130 (NOT the cancel path). `Ok(0)` is distinguishable from empty-Enter (`Ok(n)`, n ≥ 1) — the distinction is real and load-bearing.
2. **Non-interactive path** (`--no-input` OR stdin not a TTY): DO NOT present prompt. Exit 64 immediately; stderr: `"Use --yes to confirm deletion without a prompt."` (or equivalent `--yes` hint phrasing). No `DELETE` API call is made.
3. **`--yes` flag**: bypasses the gate entirely. No stdin read. `DELETE` proceeds directly. On the `--yes` path the pre-prompt metadata GET is NOT issued (its sole purpose is the prompt filename) — DELETE only, per BC-3.9.008.
4. **`--yes` on a non-gated operation**: silent no-op per DEC-169 leniency — `--yes` is accepted and ignored when no confirmation gate is triggered.

**Cancel path** (interactive 'n' or empty Enter):
- Human mode: exit 0; stderr `"Deletion cancelled."`.
- JSON mode (`--output json`): exit 0; stdout `{"cancelled": true, "deleted": false}` via `output::render_json` (#526 invariant). No `id` field in the cancel envelope — mirrors the comment delete cancel shape (BC-3.5.003).

**Cancel message channel note (P14-003)**: The `"Deletion cancelled."` message emitted to **stderr** in human/table mode **deliberately diverges** from the comment-family precedent. `src/cli/issue/interactions.rs::handle_comment_delete` emits **nothing** to any channel in table mode on cancel (`OutputFormat::Table => {}` at line ~191 of interactions.rs); only JSON mode emits a cancel envelope. Attachment delete's explicit stderr message is intentional — a silent cancel on a destructive operation would be confusing at the terminal. The JSON cancel shape (`{"cancelled":true,"deleted":false}`) IS mirrored from the comment delete cancel shape (BC-3.5.003); only the human/table-mode channel differs.

**Confirm path** (user selects Y, or `--yes` supplied): `DELETE /rest/api/3/attachment/{id}` is issued; success per BC-3.9.008; error taxonomy per BC-3.9.013.

**Metadata-fetch failure (P16-005)**: if the pre-prompt `GET /rest/api/3/attachment/{id}` fails, the gate is NEVER presented — all failure paths fire before any prompt or stdin read:
- **404**: exit 64 immediately: `"Attachment <AID> not found or not accessible."` — canonical string only (aligns with read-path 404 convention per BC-2.7.012's read-vs-write divergence); Jira body NOT surfaced; differs from BC-3.9.008's DELETE 404 (canonical + Jira body per DEC-168) because the pre-prompt fetch is a read GET, not a write operation; no DELETE issued.
- **403**: exit 1; `"Permission denied: cannot access attachment <AID>."` — aligned with BC-2.7.012 (403 on a read GET = runtime error, not a UserError; permission denied is not a user input mistake).
- **401**: exit 2 (`JrError::NotAuthenticated`; standard auth taxonomy; `jr auth login` hint on stderr).
- **5xx or network error**: exit 1 (standard API/transport taxonomy per Section 1).
All of the above fire BEFORE the confirmation prompt; the gate is never presented when the metadata fetch fails.

**Output channel invariant**: all gate prompts are written to STDERR only. STDOUT is clean — no prompt text; `--output json` piping is unaffected.

**EC-3.9.015-1** (interactive, 'y'): gate consumed from stdin; DELETE issued; success per BC-3.9.008/BC-3.9.010.
**EC-3.9.015-2** (interactive, 'n' or empty): exit 0; `"Deletion cancelled."` to stderr; JSON: `{"cancelled":true,"deleted":false}`.
**EC-3.9.015-3** (non-interactive, no `--yes`): exit 64; stderr `--yes` hint; NO DELETE issued.
**EC-3.9.015-4** (`--yes`, interactive or non-interactive): gate skipped; DELETE proceeds immediately; no stdin read.
**EC-3.9.015-5** (EOF / Ctrl+D on prompt read → `JrError::Interrupted`, exit 130): `read_line` returns `Ok(0)` (zero bytes, no newline) on EOF — distinguishable from empty-Enter (`Ok(n)`, n ≥ 1, buffer `"\n"`). Both `Ok(0)` (EOF) and any `Err(_)` (IO error) MUST propagate as `JrError::Interrupted`; exit 130; NO cancel output on this path (exit 130 is an interruption, not a user cancel). This **mirrors BC-3.5.003/EC-3.5.003-3 and BC-3.5.008/EC-3.5.008-5** — the comment family (using the same `eprint!+read_line` DEC-174 mechanism) uses the same three-way branch. The prior "deliberate divergence from BC-3.5.003" note is **REMOVED** (P5-001 ruling: the divergence was based on a false premise — the `Ok(0)` vs `Ok(n)` distinction makes EOF distinguishable from empty-Enter; the original claim that `read_line` makes them indistinguishable was incorrect).
**EC-3.9.015-6** (metadata GET returns 404): exit 64; `"Attachment <AID> not found or not accessible."`; no DELETE issued.

**VP-576-002**: `jr issue attachment delete <AID>` via `JR_STDIN_IS_TTY=1` (debug seam) — two variants: (1) **confirm path**: pipe `"y\n"` to stdin → exit 0; wiremock asserts exactly 1 `DELETE /rest/api/3/attachment/<AID>` request (`.expect(1)` on the DELETE route); (2) **cancel path**: pipe `"n\n"` to stdin → exit 0; with `--output json`, stdout is `{"cancelled":true,"deleted":false}`; parsed JSON key set equals `BTreeSet::from(["cancelled","deleted"])`; wiremock asserts 0 DELETE requests (`.expect(0)` on the DELETE route). Pins EC-3.9.015-1 (confirm path wire call), EC-3.9.015-2 (cancel shape + channel), and EC-3.9.015-3 (no DELETE on cancel). Note: the pre-prompt metadata GET (`GET /rest/api/3/attachment/{id}`) MUST be mounted in the wiremock fixture to supply `filename` for the prompt text; mount it separately from the DELETE route. Mirrors the VP-577-013 pattern for `comment delete`. P14-007.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); impact-boundary-576.md R3.3 (human ruling: y/N + --yes gate for single-ID delete); BC-3.5.002/BC-3.5.003 (comment delete mirror pattern); DEC-174 (eprint!+read_line canonical interactive-prompt mechanism); DEC-169 (--yes leniency on non-gated operations); adversary pass-1 human ruling R2 (2026-07-15); P14-007 (VP-576-002 added); P16-005 (metadata-fetch-failure clause extended: 403 exit 1 + 401 exit 2 + 5xx/network exit 1 added; all fire before gate presentation); P36-002 (step 3 clarified: --yes path skips pre-prompt metadata GET — DELETE only, per BC-3.9.008); v1.3.80 — SEC-576-011 (CWE-116: display-sanitization cross-reference added to step 1 — `<filename>` in delete confirmation prompt MUST be display-sanitized per BC-2.7.011 before writing to TTY); v1.3.94 — PRE-F4-UNICODE-DISPLAY-SANITIZATION: step 1 display-sanitization cross-ref wording updated — inline range removed, now points to BC-2.7.011 display-sanitization character set

---

#### BC-3.9.016: Bulk `attachment delete` always requires `--yes` (no interactive prompt); missing `--yes` → exit 64; three forms: single-AID (BC-3.9.015 gate), multi-AID bulk (`--yes` required), `--issue`/`--older-than` bulk (`--yes` required)

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_delete (implementation pending — story S4)
**Subject**: Issue write (attachment delete — bulk --older-than mandatory --yes gate)

`jr issue attachment delete` has three invocation forms: (1) `delete <AID>` (single AID) — governed exclusively by BC-3.9.015's confirmation gate; (2) `delete <AID> <AID>...` (2 or more positional AIDs) — multi-AID bulk form; (3) `delete --issue <KEY> --older-than <duration>` — --older-than bulk form. Both bulk forms (2 and 3) ALWAYS require explicit `--yes` — no interactive prompt is offered. `--yes` is mandatory-explicit for bulk paths (same rationale as bulk operations elsewhere: the scope of a bulk destructive operation must be explicitly acknowledged upfront).

**AID validation (P7-001, multi-AID form)**: on the multi-AID bulk form (2+ positional `<AID>` arguments), each AID is validated against `^[0-9]+$` BEFORE the `--yes` check and any API calls. Any invalid AID (non-numeric, path-traversal-shaped) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; no HTTP calls issued.

**`--yes` requirement:**

- `jr issue attachment delete --issue FOO-1 --older-than 7d` (no `--yes`) → exit 64; stderr: `"--older-than requires --yes to confirm bulk deletion."`. No API calls made.
- `jr issue attachment delete --issue FOO-1 --older-than 7d --yes` → proceeds; see BC-3.9.019 for duration parsing and wire behavior.
- `jr issue attachment delete --issue FOO-1 --older-than 7d --dry-run` (no `--yes`) → `--dry-run` takes precedence over the `--yes` gate — dry-run is read-only (no mutations), so `--yes` is NOT required for a dry-run preview. See BC-3.9.020 for dry-run output shape.
- `jr issue attachment delete --issue FOO-1 --older-than 7d --dry-run --yes` → `--dry-run` governs; `--yes` accepted silently (DEC-169 leniency); no mutations.
- `jr issue attachment delete 40001 40002` (2 AIDs, no `--yes`) → exit 64; stderr: `"--yes is required to delete multiple attachments without a confirmation prompt."`. No API calls made.
- `jr issue attachment delete 40001 40002 --yes` → proceeds; deletes each AID serially per BC-3.9.008.
- `jr issue attachment delete 40001 40002 --dry-run` (no `--yes`) → valid; dry-run is read-only; BC-3.9.020 output shape.

**clap mutual-exclusion** (positional `<AID>` form is incompatible with `--issue`/`--older-than` form):
- `delete <AID> --issue FOO-1` → clap exit 2 (positional AID conflicts with `--issue`).
- `delete <AID> --older-than 7d` → clap exit 2 (positional AID conflicts with `--older-than`).
- `delete --issue FOO-1 --older-than 7d` (no positional AID) → valid bulk form; requires `--yes`.
- `delete <AID>` (no `--issue`, no `--older-than`) → valid single-ID form; confirmation gate per BC-3.9.015.
- `delete <AID1> <AID2> ...` (2+ positional AIDs, no `--issue`, no `--older-than`) → valid multi-AID bulk form; requires `--yes` (or `--dry-run` per EC-3.9.016-7).
- `delete --older-than 7d` (no `--issue`, no positional AID) → exit 2 (clap `requires` constraint); clap error to stderr.
- `delete --issue FOO-1` (no `--older-than`, no positional AID) → exit 2 (clap `requires` constraint; `--issue` requires `--older-than`); clap error to stderr.
- `delete` (no positional AID, no flags at all) → exit 2 (clap required-group error; must supply at least one of: positional `<AID>`, or both `--issue` + `--older-than`); clap error to stderr.

**EC-3.9.016-1** (bulk, no `--yes`, no `--dry-run`): exit 64; stderr `"--older-than requires --yes to confirm bulk deletion."`; no API calls.
**EC-3.9.016-2** (bulk, `--yes`): proceed to BC-3.9.019 wire behavior.
**EC-3.9.016-3** (bulk, `--dry-run`, no `--yes`): dry-run permitted without `--yes`; no mutations; BC-3.9.020 output shape.
**EC-3.9.016-4** (positional AID + `--issue` or `--older-than`): clap exit 2 (argument conflict).
**EC-3.9.016-5** (`--older-than` without `--issue`): exit 2 (clap `requires` constraint); clap error to stderr; no application code reached.
**EC-3.9.016-6** (multi-AID bulk, `--yes`): issue the DELETE wire call of BC-3.9.008 for each AID serially; 404 handling per BC-3.9.013 bulk exception (benign skip); JSON shape per BC-3.9.010.
**EC-3.9.016-7** (multi-AID bulk, `--dry-run`, no `--yes`): valid; dry-run exempt from `--yes` gate (mirrors EC-3.9.016-3); BC-3.9.020 output shape.
**EC-3.9.016-8** (multi-AID bulk, no `--yes`, no `--dry-run`): exit 64; stderr `"--yes is required to delete multiple attachments without a confirmation prompt."`; no API calls.
**EC-3.9.016-9** (`--issue` without `--older-than`): exit 2 (clap `requires` constraint; reciprocal of EC-3.9.016-5); clap error to stderr; no application code reached.
**EC-3.9.016-10** (bare `delete`, no AID, no flags): exit 2 (clap required-group error; no valid form supplied); clap error to stderr.

**CLI flags** (pinned for e2e surface guard): `<AID>...` (positional, 1+ when used — optional under the required selector group; bare `delete` → exit 2 per the clap section; mutually exclusive with `--issue`/`--older-than` form); `--issue <KEY>`; `--older-than <DURATION>`; `--yes`; `--dry-run`; `--output json`; `--no-input`; `--profile <NAME>`; `--no-color`.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); impact-boundary-576.md R3.2/R3.3/R3.4 (bulk gate + clap mutual-exclusion + ID-only delete signature); adversary pass-1 human ruling R1 (2026-07-15); DEC-169 (--yes leniency); P30-I01 (CLI flags line: `<AID>...` annotated as positional 1+ when used, optional under required selector group, bare `delete` → exit 2 per clap section)

---

#### BC-3.9.017: `attachment upload --replace-existing` — same-filename lookup + delete ALL matching entries; non-atomic race window documented; MUST NOT assert atomicity (JRACLOUD-96384, JRACLOUD-78388)

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload (implementation pending — story S3)
**Subject**: Issue write (attachment upload — --replace-existing conflict resolution)

`jr issue attachment upload <KEY> <FILE> --replace-existing` performs a delete-then-upload sequence:

0. **Eligibility pre-flight (BEFORE any destructive call, BEFORE the gate, BEFORE the list GET)**: resolve all eligibility guards that can be determined from the issue key alone. Specifically: if `--public` is supplied, `jr` derives the project key from the issue key string prefix (e.g., `FOO-1` → `FOO`), calls `get_or_fetch_project_meta(client, "FOO")` (2-arg live signature: profile resolved internally via `client.profile_name()`; `src/api/jsm/servicedesks.rs:~41`; cached — no extra HTTP on subsequent calls), and checks `projectTypeKey`. If `projectTypeKey != "service_desk"` → exit 64; canonical message: `"--public is only supported on Jira Service Management (JSM) issues."`; **zero DELETEs issued; zero upload POST issued**. This is BC-3.9.005 invoked from the `--replace-existing` path. This step is a no-op when `--public` is absent. **Key-derivation equivalence (canonical statement)**: the string-prefix derivation used here (`FOO-1` → `FOO`) is the only available approach at this pre-flight step — no issue GET has run yet. Later paths in this same command (BC-3.9.003/BC-3.9.005 plain-upload flow) use `fields.project.key` from the issue GET response instead; Jira guarantees these are identical (an issue's project key equals its key prefix). The two derivations are deliberately equivalent; this step-0 note is the single canonical statement of that equivalence.
1. **List step**: `GET /rest/api/3/issue/{key}?fields=attachment` to retrieve `fields.attachment[]`. Filter entries where `attachment.filename` equals the basename of `<FILE>` (case-sensitive string equality; Jira stores filenames verbatim — the invariant that `attachment.filename == basename(<FILE>)` is pinned by BC-3.9.001's Content-Disposition filename clause).
2. **Gate step (fire ALL pending confirmation gates BEFORE any destructive call)**: evaluate gate-triggering conditions from the results of step 1 and the supplied flags:

   - **Gate-triggering conditions**: (a) `--public` is present (regardless of match count), OR (b) ≥1 same-filename match was found by step 1 (regardless of `--public`). `--dry-run` suppresses ALL gates in this step (read-only — no destructive call will be issued; see BC-3.9.020 EC-3.9.020-7 and P15-002 ruling).
   - **No gate (no-op condition)**: `--public` absent AND zero same-filename matches, OR `--yes` supplied. Proceed directly to step 3/4.
   - **`--yes` bypass**: if `--yes` is supplied, skip the gate entirely regardless of triggering conditions.
   - **Non-interactive** (`--no-input` OR stdin is not a TTY), gate would trigger, `--yes` absent → exit 64 before any DELETE: `"Use --yes to confirm deletion of existing same-filename attachments."` (actionable hint per EC-2.7.007-style). Zero DELETEs and zero upload POSTs issued. (BC-3.9.017 EC-3.9.017-9.)
   - **Interactive, gate triggers, only `--public` (zero matches)**: fire the BC-3.9.014 `--public` confirmation gate — prompt per BC-3.9.014's public-upload prompt text. If cancelled: exit 0; human `"Upload cancelled."`; JSON `{"cancelled":true,"uploaded":false}`; no DELETEs issued.
   - **Interactive, gate triggers, only ≥1 match (no `--public`)**: fire the BC-3.9.014 mechanics (`eprint!+read_line`; NOT `dialoguer::Confirm`) with a prompt enumerating the would-delete entries. Prompt text (stderr, trailing space, `eprint!`): `"Replace existing attachment(s) on <KEY>:\n  <filename1> (id: <AID1>)\n  <filename2> (id: <AID2>)\nContinue? [y/N] "` (list all matching entries; no `"N items"` summary — exact count is meaningful for destructive ops). If cancelled: exit 0; human `"Upload cancelled."`; JSON `{"cancelled":true,"uploaded":false}`; no DELETEs issued. (BC-3.9.017 EC-3.9.017-11.)
   - **Interactive, gate triggers, COMBINED (`--public` AND ≥1 match)**: fire ONE combined confirmation prompt covering both consequences (public visibility AND would-delete list). Fire a SINGLE gate — NOT two separate gates. Prompt text (stderr, `eprint!`): `"Upload to <KEY> as customer-visible (public) and replace existing attachment(s):\n  <filename1> (id: <AID1>)\n  ...\nContinue? [y/N] "`. If cancelled: exit 0; human `"Upload cancelled."`; JSON `{"cancelled":true,"uploaded":false}`; NO DELETEs issued; NO upload POST issued. Single cancel path: exit 0, no destructive calls. `--yes` bypasses both. (BC-3.9.017 EC-3.9.017-12.)
   - Gate mechanics always follow BC-3.9.014 (`eprint!+read_line`, NOT `dialoguer::Confirm`; three-way branch (a) y/yes → proceed, (b) other/empty → cancel exit 0, (c) EOF/IO-error → `JrError::Interrupted` exit 130).
   - **Display-sanitization cross-reference (SEC-576-011)**: all `<filenameN>` values enumerated in any gate prompt (the ≥1-match prompt and the combined prompt above) are server-supplied attachment filenames and MUST be display-sanitized (replaced with `?` per the BC-2.7.011 display-sanitization character set) per BC-2.7.011 display-sanitization requirement before writing to the TTY. This prevents terminal injection via crafted attachment names in the confirmation prompt. RAW values are not exposed in any output channel on the prompt path.

   This step supersedes the prior "no-op when no `--public`" wording (P15-002/R3.12 ruling). **One gate per invocation, ever.**
3. **Delete step**: for EVERY matching entry, issue `DELETE /rest/api/3/attachment/{id}` serially. OQ-6 ruling: when multiple entries share the same filename, delete ALL (last-write-wins semantics; no error on multiple matches). Per-entry error handling: a 404 on DELETE is treated as already-deleted (skip silently); a 403/401/5xx on any DELETE aborts the sequence — the error is surfaced per BC-3.9.013 and the upload does NOT proceed (remaining same-filename entries may still exist on abort).
4. **Upload step**: proceed with upload per BC-3.9.001 (platform path) or BC-3.9.003/BC-3.9.004 (JSM path). The `--public` gate (if applicable) has already fired in step 2. **Gate suppression**: when routing to BC-3.9.003 on this step, the confirmation gate defined in BC-3.9.003 MUST NOT be re-presented — it was already resolved in step 2. Only the servicedeskapi wire steps execute (BC-3.9.003 EC-3.9.003-5). One gate per invocation, ever. **Step-0 suppression on `--internal` path (BC-3.9.004 EC-3.9.004-4, P21-005)**: when routing to BC-3.9.004 on this step, Step 0 (issue GET) of BC-3.9.004 is SKIPPED — existence was already validated by step 1's `?fields=attachment` GET; exactly ONE issue GET per invocation on the combined `--replace-existing --internal` path.

**Invariant**: no destructive API call (DELETE or upload POST) may be issued while ANY confirmation gate OR eligibility guard remains unresolved. This prevents the data-loss footgun where a user sees a confirmation prompt — or hits an exit-64 eligibility guard — AFTER their existing attachments have already been deleted.

**Multiple `<FILE>` arguments with `--replace-existing`**: when two or more `<FILE>` arguments are supplied, the delete phase (step 3) matches EVERY supplied file's basename as a union: e.g., `upload FOO-1 a.pdf b.pdf --replace-existing` deletes existing attachments matching `a.pdf` AND existing attachments matching `b.pdf`. Duplicate basenames among the `<FILE>` arguments are deduplicated: `upload FOO-1 a.pdf a.pdf --replace-existing` produces an effective match set of `{a.pdf}` (single entry). All union matches are deleted before the multi-file upload proceeds.

**Non-atomic race window — documented; MUST NOT assert atomicity:**

The delete → upload sequence is NOT atomic. A concurrent upload between step 2 completion and step 3 can create a new attachment with the same filename, resulting in a duplicate. This is an accepted and documented limitation. The implementation MUST NOT add retry logic asserting post-upload uniqueness by filename. Upstream constraints: JRACLOUD-96384 (Jira matches media references by filename — ambiguous on collision); JRACLOUD-78388 (no REST mapping from comment body to specific attachment by ID — the race consequence is unresolvable without the attachment ID of the concurrent upload).

**EC-3.9.017-1** (single matching entry found): delete it, then upload; success per BC-3.9.007/BC-3.9.009.
**EC-3.9.017-2** (N > 1 matching entries, OQ-6): delete all N serially, then upload; human echo confirms deletions + upload.
**EC-3.9.017-3** (no matching entry): BC-3.9.018 path (idempotent plain upload).
**Partial-failure consequence (accepted and documented)**: if step 3 (delete) aborts mid-sequence after some but not all matching attachments are deleted (due to a non-404 error), step 4 (upload) does NOT proceed. The issue is left with fewer same-filename attachments than before — the already-deleted entries are permanently gone. This is a known, accepted limitation of the non-atomic design. **Usage note**: run `jr issue attachment list <KEY>` to review the current attachment state, or use `--dry-run` if available, before running `--replace-existing` on issues with many same-filename attachments.

**EC-3.9.017-4** (DELETE returns 404): treat as already-deleted; continue to next or to upload step.
**EC-3.9.017-5** (DELETE returns 403/401/5xx): abort sequence; surface error per BC-3.9.013; no upload proceeds.
**EC-3.9.017-6** (list step fails): abort; no deletes, no upload; exit per BC-3.9.012/BC-3.9.013.
**EC-3.9.017-7** (non-atomic race — concurrent upload between delete and upload): accepted documented limitation; no retry; no error emitted.
**EC-3.9.017-8** (gate cancelled in step 2): user cancels any confirmation gate (--public, --replace-existing, or combined); exit 0; `"Upload cancelled."`; no DELETEs issued; no upload; mirrors BC-3.9.014 EC-3.9.014-2.

**EC-3.9.017-9** (non-interactive, ≥1 match, no `--yes` — P15-002/R3.12): `--replace-existing` in non-interactive mode (`--no-input` or stdin not a TTY) when step 1 found ≥1 same-filename match and `--yes` is absent → exit 64 before any DELETE. Zero DELETEs issued; zero upload POST issued. This is the non-interactive arm of the gate added by P15-002. **Two sub-variants (P17-004)**: (A) `--replace-existing` only (no `--public`): `"Use --yes to confirm deletion of existing same-filename attachments."` (B) Combined `--public` + ≥1 match: `"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."`

**EC-3.9.017-10** (gate fires ONLY on nonempty match — P15-002/R3.12): the --replace-existing confirmation gate fires ONLY when step 1 finds ≥1 same-filename match. Zero same-filename matches → gate step is a no-op on the replace path (no prompt, no stdin read). `--replace-existing` with zero matches is always non-interactive-safe — no `--yes` required when no existing attachments would be deleted. (The `--public` gate remains independent: it fires regardless of match count when `--public` is present — see BC-3.9.018 for the zero-match + --public path.)

**EC-3.9.017-11** (combined gate — single prompt for `--public` + ≥1 match — P15-002/R3.12): when `--public` AND ≥1 same-filename match are BOTH present, the gate in step 2 fires as ONE combined prompt (not two separate gates) covering both consequences. Single 'y'/'yes' (or `--yes`) proceeds; single cancel path exits 0. `--yes` bypasses both in one bypass. Merging the two triggers into one prompt prevents double-prompting (which would be confusing and violates "one gate per invocation, ever").

**EC-3.9.017-12** (`--yes` single-bypass for all gate conditions — P15-002/R3.12): `--yes` is the single bypass for the entire step-2 gate regardless of what triggered it — `--public` only, ≥1 match only, or both combined. No distinction between gate sources; `--yes` always proceeds without prompting.

**VP-576-003**: ordering invariant pin — `jr issue attachment upload FOO-1 file.txt --replace-existing --yes` via wiremock: (1) mount `GET /rest/api/3/issue/FOO-1?fields=attachment` returning `[{"id":"10001","filename":"file.txt","created":"2024-01-01T00:00:00.000+0000"}]`; (2) mount `DELETE /rest/api/3/attachment/10001` returning 204; (3) mount `POST /rest/api/3/issue/FOO-1/attachments` returning the upload success JSON. After the command completes, inspect `mock_server.received_requests()` in order and assert: (a) the DELETE request's sequential index is lower than the POST request's sequential index — the delete occurred BEFORE the upload POST; (b) zero requests were issued to any `/rest/servicedeskapi/...` path (the BC-3.9.005 guard is inert here because `--public` is absent, so no JSM calls are made). A regression that issues the upload POST before or without the DELETE MUST fail assertion (a). The `--yes` flag is **required** on this test path because `--replace-existing` with ≥1 match now triggers the P15-002/R3.12 gate — without `--yes`, a non-interactive test environment would exit 64 before the DELETE. The `--yes` flag bypasses the gate, making the test fully deterministic. Pins BC-3.9.017 step-3 → step-4 ordering, the invariant paragraph "no destructive API call may be issued while any confirmation gate OR eligibility guard remains unresolved," and EC-3.9.017-10/12 (gate fires on match; --yes bypasses). P14-007; P15-002 (VP note updated).

**VP-576-005**: combined-gate single-prompt pin — `jr issue attachment upload EJ-1 file.txt --replace-existing --public` via wiremock against a JSM project with ≥1 same-filename match. **Wire setup (7 numbered steps; 6 wiremock mounts + 1 test-env step; BC-X.8.010 cache-miss assumed on both meta calls)**: (1) mount `GET /rest/api/3/project/EJ` returning `{"id":"10050","projectTypeKey":"service_desk"}` (first call of `get_or_fetch_project_meta("EJ")` per BC-X.8.010 cache-miss; project key derived from string prefix `EJ-1`→`EJ` per BC-3.9.017 step 0 — NO plain issue GET is issued at this step); (2) mount `GET /rest/servicedeskapi/servicedesk` returning a valid service desk with `projectId == "10050"` matching the `id` from mount (1) (second call of `get_or_fetch_project_meta` per BC-X.8.010 cache-miss — pagination call to resolve `serviceDeskId`; per H-NEW-ATTACHMENT-009 wording; match is `serviceDesk.projectId == project.id`, NOT `projectKey` — BC-3.9.003 step 1 sdId resolution; P23-001); (3) mount `GET /rest/api/3/issue/EJ-1?fields=attachment` returning `[{"id":"20001","filename":"file.txt","created":"2026-01-01T00:00:00.000+0000"}]` (1 same-filename match; this GET also validates existence — plain issue GET is suppressed per EC-3.9.003-5 P17-003 Step-0 suppression: exactly ONE issue GET per invocation on the combined `--replace-existing --public` path); (4) set `JR_STDIN_IS_TTY=1`, pipe `"y\n"` to stdin; (5) mount `DELETE /rest/api/3/attachment/20001` returning 204 (BC-3.9.017 step 3; EC-3.9.017-1); (6) mount `POST /rest/servicedeskapi/servicedesk/{sdId}/attachTemporaryFile` (BC-3.9.003 step 1; gate already resolved at BC-3.9.017 step 2 per EC-3.9.003-5); (7) mount `POST /rest/servicedeskapi/request/EJ-1/attachment` (BC-3.9.003 step 2). Assert: (a) EXACTLY ONE prompt written to stderr — the combined variant (BC-3.9.014 consumer 3: `"Upload to <KEY> as customer-visible (public) and replace existing attachment(s):..."`) — no second prompt; (b) `--yes` variant: add `--yes` flag with no stdin pipe, assert ZERO prompts and same DELETE + upload sequence executes; (c) cancel variant: pipe `"\n"` (empty-Enter) instead of `"y\n"` — assert ZERO DELETE requests and ZERO servicedeskapi POST requests; (d) wiremock strict mode verifies ZERO plain `GET /rest/api/3/issue/EJ-1` requests without query parameters — the project key is derived from the string prefix at step 0 (no issue GET), and existence is validated by the `?fields=attachment` GET at step (3) (BC-3.9.017 step 1; EC-3.9.003-5 P17-003). **Wire completeness (P23-001, ECHO-BREAKER LIST-B)**: full expected call set from BC-3.9.017 steps 0–4 + BC-3.9.003/004 routing + BC-X.8.010 cache-miss: (i) GET /rest/api/3/project/EJ → mount (1) [BC-3.9.017 step 0; BC-X.8.010 cache-miss GET-1]; (ii) GET /rest/servicedeskapi/servicedesk → mount (2) [BC-X.8.010 cache-miss GET-2 — serviceDeskId resolution; BC-3.9.003 step 1]; (iii) GET /rest/api/3/issue/EJ-1?fields=attachment → mount (3) [BC-3.9.017 step 1; EC-3.9.003-5 P17-003]; (iv) DELETE /rest/api/3/attachment/20001 → mount (5) [BC-3.9.017 step 3; EC-3.9.017-1]; (v) POST .../attachTemporaryFile → mount (6) [BC-3.9.003 step 1]; (vi) POST .../request/EJ-1/attachment → mount (7) [BC-3.9.003 step 2]. All 6 HTTP calls mounted; each mount licensed by a specific BC clause. Step (4) is test-env setup (not an HTTP call). **Story allocation (P23-003)**: verified in S5 (S5 depends_on S3) — exercises the combined `--public` JSM two-step; textual home BC-3.9.017 (S3) per the EC-3.9.017-11/12 S5-realized pattern; NOT part of the S3 acceptance matrix (contrast VP-576-003, genuinely S3). Pins EC-3.9.017-11 (combined `--public` + ≥1 match → ONE prompt, not two), EC-3.9.017-12 (`--yes` single-bypass for all gate conditions), the invariant "cancel at gate → zero DELETE + zero POST", BC-3.9.017 step 0 (string-prefix project key derivation, no plain issue GET), and EC-3.9.003-5 P17-003 (ONE issue GET per invocation on combined `--replace-existing --public` path). P20-006; P21-002; P23-001; P23-003; cross-ref BC-3.9.017, EC-3.9.017-11/12.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); impact-boundary-576.md R3.2 (--replace-existing scope + non-atomic race + JRACLOUD-96384/-78388 citations); OQ-6 ruling (delete ALL matching entries, last-write-wins); adversary pass-1 human ruling R1 (2026-07-15); P14-007 (VP-576-003 added); P15-002/R3.12 (step-2 gate rewrite: ≥1-match → confirm, combined gate, EC-3.9.017-9..12); v1.3.80 — SEC-576-011 (CWE-116: display-sanitization cross-reference added to step 2 gate mechanics — `<filenameN>` values in ≥1-match and combined prompts MUST be display-sanitized per BC-2.7.011 before writing to TTY); v1.3.94 — PRE-F4-UNICODE-DISPLAY-SANITIZATION: step 2 display-sanitization cross-ref wording updated — inline range removed, now points to BC-2.7.011 display-sanitization character set

---

#### BC-3.9.018: `attachment upload --replace-existing` with no same-filename match — idempotent plain upload; zero-match is silent; flag accepted as no-op on the delete phase

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_upload (implementation pending — story S3)
**Subject**: Issue write (attachment upload — --replace-existing idempotent zero-match path)

When `jr issue attachment upload <KEY> <FILE> --replace-existing` is invoked and the list step (BC-3.9.017 step 1) finds ZERO existing attachments whose filename matches `<FILE>`, the `--replace-existing` flag has no effect on the delete phase. The delete phase is skipped entirely. The upload proceeds identically to a plain `jr issue attachment upload <KEY> <FILE>` invocation (platform path per BC-3.9.001 or JSM path per BC-3.9.003/BC-3.9.004).

**Zero-match behavior is silent**: no warning, no informational message, no `"(0 files replaced)"` annotation in either human or JSON output. The flag is idempotent — its absence of effect when no matching attachment exists is intentional and unannounced.

**Output shape**: identical to plain upload (BC-3.9.009 JSON shape; BC-3.9.007 human echo). No additional `"replaced"`, `"deletedCount"`, or equivalent field is added to the JSON output for the zero-match case.

**Gate suppression on `--public` zero-match path (P7-002)**: when `--replace-existing --public` reaches the zero-match path, BC-3.9.017 step 2 (gate step) fires BEFORE the upload — even though no DELETEs are needed, the upload POST is a destructive call per BC-3.9.017's invariant ("no destructive API call (DELETE or upload POST) may be issued while ANY confirmation gate OR eligibility guard remains unresolved"). The gate resolves exactly once. When the upload then proceeds to BC-3.9.003 (JSM `--public` path), the gate MUST NOT re-fire — it was already resolved at BC-3.9.017 step 2. This extends EC-3.9.003-5's suppression key to the BC-3.9.018 entry point. **One gate per invocation, ever.**

**P15-002/R3.12 zero-match alignment**: the new `--replace-existing` match gate (EC-3.9.017-9..12) does NOT fire on this path. Zero same-filename matches → gate step is a no-op on the replace path (BC-3.9.017 EC-3.9.017-10). This path (BC-3.9.018) is therefore always non-interactive-safe for the match gate: `--replace-existing` with zero same-filename matches never requires `--yes` and never exits 64 due to the match gate. The `--public` gate (consumer 1) remains independent and still fires on this path when `--public` is present (resolved at BC-3.9.017 step 2 before reaching BC-3.9.003).

**EC-3.9.018-1** (zero matching filenames): skip delete phase; upload per BC-3.9.001/003/004; output per BC-3.9.007/009.
**EC-3.9.018-2** (zero-match JSON output): identical to plain upload JSON — no extra keys.
**EC-3.9.018-3** (zero-match human output): identical to plain upload echo — no extra annotation.
**EC-3.9.018-4** (zero-match `--public`, gate suppression): gate resolves at BC-3.9.017 step 2 (fires once before the upload, even with zero DELETEs pending); BC-3.9.003's gate MUST NOT re-fire at this entry point; upload proceeds per BC-3.9.003 wire steps only (EC-3.9.003-5 mechanism extended to this path).

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); impact-boundary-576.md R3.2 (--replace-existing idempotent no-match path); OQ-6 ruling; adversary pass-1 human ruling R1 (2026-07-15)

---

#### BC-3.9.019: `attachment delete --issue <KEY> --older-than <duration>` — dedicated `parse_age_duration` (d=24h clock-hours, w=7×24h calendar; `src/duration.rs` syntax-style precedent only); ISO 8601 `created` compared client-side via `chrono`; invalid duration → exit 64; `--output json` bulk-delete shape

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_delete (implementation pending — story S4); `parse_age_duration` (S4 location TBD — `src/cli/issue/attachments.rs` private helper or `src/duration.rs` pub(crate) sibling, per impact-boundary R3.9a)
**Subject**: Issue write (attachment delete — --older-than duration parsing + comparison semantics + JSON shape)

`jr issue attachment delete --issue <KEY> --older-than <duration> --yes` selects all attachments on the issue whose `created` timestamp is older than `duration` relative to the invocation time, then issues a `DELETE` for each.

**`--issue <KEY>` is required** for the `--older-than` form. Enforced by clap `requires` constraint at parse time. `--older-than` without `--issue` → exit 2 (clap error); no application code reached.

**Duration parsing (calendar semantics)**: The `<duration>` argument is parsed by a dedicated `parse_age_duration` function (e.g., `src/duration.rs::parse_age_duration` or equivalent) that converts the string to a `chrono::Duration`. Accepted unit suffixes: `m` (minutes = 60 seconds), `h` (hours = 3600 seconds), `d` (days = 24 clock-hours, NOT an 8-hour Jira workday), `w` (weeks = 7 calendar days = 7×24h, NOT a 5-workday week). `m` means minutes, NOT months. Seconds (`s`) are not supported. Example valid values: `30m`, `2h`, `7d`, `2w`, `30d`. `src/duration.rs` is cited as the **syntax-style precedent only** (same `w/d/h/m` suffix convention); `src/duration.rs` performs **no arithmetic** — it is a syntax-validator and format utility only (no string→quantity conversion); `parse_age_duration` owns ALL arithmetic and MUST NOT reuse any `duration.rs` conversion logic (which would import worklog-day semantics such as an 8-hour day). Boundary test requirement: a unit test MUST assert that `parse_age_duration("1d") == chrono::Duration::hours(24)` (not 8 hours or 28800 seconds). An unrecognized or malformed duration string → exit 64; stderr: `"invalid duration: '<VALUE>'. Use formats like 30m, 2h, 1d, 7d, 2w."` (no reference to `duration.rs` error message which may differ).

**Client-side comparison**: each attachment's `created` field (ISO 8601 string, e.g., `"2026-01-01T12:00:00.000+0000"`) is parsed via `chrono`. The cutoff is `now() - duration`. Attachments where `created < cutoff` are selected. A `created` value that cannot be parsed → skip that attachment with a stderr warning; does NOT abort the operation. **Completeness dependency**: the correctness of this BC depends on BC-2.7.001's ASSUMPTION that `fields.attachment` is returned complete (not paginated). If the assumption fails on a high-attachment issue, the older-than selection would be incomplete. See BC-2.7.001 ASSUMPTION clause for the S1 delivery obligation.

**`--older-than 0d` / `0h` / `0m` footgun**: a zero duration computes a cutoff of `now()`, selecting ALL attachments (every `created` timestamp is before the current moment). Use with caution — `--older-than 0d --yes` deletes every attachment on the issue. A `--dry-run` preview is strongly recommended before running with a zero or very short duration.

**Pre-deletion stderr summary** (non-dry-run bulk mode, fires after list step and before first DELETE): `"Deleting N attachment(s) older than <duration> from <KEY>."` (N = count of selected attachments). Suppressed on dry-run paths. **HINT — suppressed in `--output json` mode** (the count is carried in the JSON result envelope's `"count"` field; per EC-2.7.008-6 hint-vs-error principle). Human mode only.

**Wire**: selected attachments are deleted serially via `DELETE /rest/api/3/attachment/{id}` per BC-3.9.008. `--yes` is required per BC-3.9.016; absent `--yes` → exit 64. `--dry-run` preempts mutation; see BC-3.9.020.

**Human output**: per-deleted-attachment echo lines. Summary: `"Deleted N attachment(s) older than <duration> from <KEY>."`. Zero-match: `"No attachments older than <duration> found on <KEY>."` + exit 0.

**`--output json` shape** (via `output::render_json`, #526 invariant):
- N > 0 matches deleted: `{"count": N, "deleted": true, "ids": ["<AID1>", "<AID2>", ...]}`
- Zero matches: `{"count": 0, "deleted": false, "ids": []}`

**EC-3.9.019-1** (valid duration, N > 0, `--yes`): N deletions; success output above.
**EC-3.9.019-2** (valid duration, 0 matches): exit 0; zero-match echo + JSON.
**EC-3.9.019-3** (invalid/malformed duration): exit 64; stderr: `"invalid duration: '<VALUE>'. Use formats like 30m, 2h, 1d, 7d, 2w."` (canonical error string from `parse_age_duration`; no reference to `duration.rs` error message, which may differ).
**EC-3.9.019-8** (1d=24h boundary pin): `parse_age_duration("1d")` MUST produce `chrono::Duration::hours(24)`. A unit test in `src/` MUST assert this. Worklog-style 1d=8h is WRONG for this function.
**EC-3.9.019-4** (`--older-than` without `--issue`): exit 2 (clap `requires` constraint); mirrors EC-3.9.016-5.
**EC-3.9.019-5** (missing `--yes`): exit 64 per BC-3.9.016 gate.
**EC-3.9.019-6** (malformed `created` on one attachment): skip + stderr warning; continue with remaining attachments.
**EC-3.9.019-7** (partial DELETE failure mid-sequence): 404 on any individual DELETE → already-deleted (benign race) → skip silently, continue. Any other error (403, 5xx, network) → stop; surface error; JSON mode: `JrError` error shape, NOT success shape. Mirrors BC-3.9.013 multi-delete 404 exception.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); impact-boundary-576.md R3.2 (--older-than scope + duration.rs citation + chrono client-side comparison); `src/duration.rs` (existing parser, worklog add --duration precedent); adversary pass-1 human ruling R1 (2026-07-15); P26-004 (Source field softened — `parse_age_duration` location TBD; `src/cli/issue/attachments.rs` private helper or `src/duration.rs` pub(crate) sibling per impact-boundary R3.9a); P30-002 (pre-deletion stderr summary classified as HINT — JSON-suppressed; count in JSON `"count"` field; per EC-2.7.008-6 hint-vs-error principle; "Human mode only." annotation added)

---

#### BC-3.9.020: `attachment --dry-run` (delete multi-path + upload `--replace-existing`) — list affected IDs/files without mutation; `--output json` via `output::render_json`; single-ID delete `--dry-run` = stderr hint + exit 0 (no-op)

**Confidence**: HIGH
**Source**: src/cli/issue/attachments.rs::handle_attachment_delete (implementation pending — story S4); src/cli/issue/attachments.rs::handle_attachment_upload (implementation pending — story S3, path c only)
**Subject**: Issue write (attachment delete + upload --replace-existing — dry-run preview paths)

`upload --dry-run` without `--replace-existing` is rejected by clap (exit 2). `--dry-run` on upload requires `--replace-existing` — the only upload operation with a meaningful preview (no deletes to preview = no point to the dry-run). Enforced at parse time to avoid silent no-op confusion.

`--dry-run` is meaningful on multi-attachment paths: (a) `--older-than` bulk delete — previews which attachments would be deleted; (b) multi-AID bulk delete (`delete <AID>...`) — previews the AID list, with per-AID metadata fan-out (see below); (c) `upload --replace-existing` — previews which existing same-filename attachments would be deleted AND which files would be uploaded, without issuing any `DELETE` or `POST` requests. **`--public` confirmation gate (BC-3.9.014) is SUPPRESSED on path (c)**: `--dry-run` implies no destructive call will be issued; per BC-3.9.017's invariant (no gate fires unless a destructive call is imminent), the `--public` gate does NOT fire on dry-run even when `--public` is supplied. The preview output MUST still note the would-be visibility when `--public` is set: include `"visibility":"public"` on each `wouldUpload` entry in JSON mode, and a `[public]` annotation in human mode. On path (c), the output includes a "would-delete" section (matching existing entries by basename) and a "would-upload" section (the supplied files); JSON shape: `{"dryRun":true,"wouldDelete":[{"filename":"<name>","id":"<AID>"}],"wouldUpload":[{"filename":"<name>"}]}`; when `--public` supplied: `"wouldUpload":[{"filename":"<name>","visibility":"public"}]`; ships with S3 (the --replace-existing story; Source: src/cli/issue/attachments.rs::handle_attachment_upload — implementation pending story S3). `--dry-run` does NOT require `--yes` (the operation is read-only; BC-3.9.016 explicitly exempts `--dry-run` from the bulk `--yes` gate).

**Multi-AID `--dry-run` metadata fan-out (path b)**: **AID validation fires first (P7-001)**: each supplied AID is validated against `^[0-9]+$` before any metadata fetch. An invalid AID (non-numeric, path-traversal-shaped) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; zero HTTP calls issued (even on dry-run — invalid input is rejected before any read-only GET). For valid AIDs: `jr` performs per-AID `GET /rest/api/3/attachment/{id}` metadata fetches (one per supplied AID, serially or concurrently) to populate the filename column in the preview table and the `filename` key in JSON output. These are read-only GET requests permitted in dry-run. A metadata fetch failure for an AID (404, network error, etc.) yields a row with the id and `"(metadata unavailable)"` in the filename column; in JSON mode the row is `{"id":"<AID>"}` (no `"filename"` key when unavailable). The AID is still included in the `ids` array (it was specified by the user; the dry-run preview includes it regardless of metadata availability).

**Multi-attachment `--dry-run`** (with `--older-than`):
- Perform the list step and apply the same selection logic (duration filter per BC-3.9.019) without any mutations.
- Human mode: print a table with columns `[ID, Filename, Size, Created]` for each attachment that would be deleted. Final line: `"<N> attachment(s) would be deleted. Run without --dry-run to confirm."`. Exit 0.
- `--output json` shape (via `output::render_json`, #526 invariant):
  - N > 0: `{"attachments": [{"filename": "<name>", "id": "<AID>"}], "dryRun": true, "ids": ["<AID1>", "<AID2>"]}` (BTreeMap alphabetical at all depths: outer attachments < dryRun < ids; inner filename < id)
  - Zero matches: `{"attachments": [], "dryRun": true, "ids": []}`
- `--yes` is NOT required for `--dry-run` (BC-3.9.016 exemption). `--yes` alongside `--dry-run` is accepted silently (DEC-169 leniency); `--dry-run` governs; no mutations.

**Single-ID `--dry-run`** (positional `<AID>` form):
- **AID validation (P7-001 uniformity, P8-004)**: the supplied `<AID>` is validated against `^[0-9]+$` BEFORE any output, hint, or gate. An invalid AID (non-numeric, path-traversal-shaped) → exit 64; stderr: `"invalid attachment id: '<VALUE>' (must be numeric)"`; zero HTTP calls issued; the `--dry-run` hint is NOT emitted.
- `--dry-run` has no actionable meaning for single-ID delete (the user has already specified the exact attachment; there is nothing to preview). The flag is accepted without error.
- Human mode: emit to stderr `"--dry-run has no effect on single-ID delete; omit the flag."`. Exit 0. NO `DELETE` call is issued. NO confirmation gate (BC-3.9.015) is triggered.
- JSON mode (`--output json`): emit `{"attachments":[{"id":"<AID>"}],"dryRun":true,"ids":["<AID>"]}` to stdout (no `"filename"` key — no metadata fetch on single-ID dry-run; one-element arrays); NO stderr hint in JSON mode. JSON mode never produces empty stdout.
- `--yes --dry-run` on single-ID: `--dry-run` governs; same behavior as above.

**`--dry-run` is not a substitute for `--yes` on mutations**: on multi-attachment paths, `--dry-run` (no `--yes`) is a valid read-only preview; `--yes` (no `--dry-run`) runs the real deletion (requires `--yes` per BC-3.9.016); `--dry-run --yes` together runs the preview only (DEC-169 governs `--yes`).

**EC-3.9.020-1** (multi `--dry-run`, N > 0): table + count line; JSON `{"attachments":[...],"dryRun":true,"ids":[...]}`; no mutations; exit 0.
**EC-3.9.020-2** (multi `--dry-run`, 0 matches): zero-match output; JSON `{"attachments":[],"dryRun":true,"ids":[]}`; exit 0.
**EC-3.9.020-3** (single-ID `--dry-run`): human: stderr hint, no DELETE, no gate, exit 0. JSON mode: `{"attachments":[{"id":"<AID>"}],"dryRun":true,"ids":["<AID>"]}` to stdout; no stderr hint; exit 0.
**EC-3.9.020-4** (`--dry-run --older-than`, no `--yes`): valid; dry-run exempt from `--yes` gate (BC-3.9.016 EC-3.9.016-3).
**EC-3.9.020-5** (`--dry-run --yes` together): `--dry-run` governs; `--yes` silent no-op (DEC-169); no mutations.
**EC-3.9.020-6** (`upload --dry-run` without `--replace-existing`): exit 2 (clap `requires` constraint); clap error to stderr; no application code reached.
**EC-3.9.020-7** (`--replace-existing --dry-run` — path c, ALL gate suppression): ALL BC-3.9.014 confirmation gates are **SUPPRESSED** on `--dry-run`; no stdin read; no `eprint!` prompt — regardless of which gate(s) would otherwise trigger. This covers ALL three gate consumers: (1) `--public` gate: suppressed even when `--public` is present; (2) `--replace-existing`-with-≥1-match gate (P15-002/R3.12): suppressed even when pre-flight finds same-filename matches; (3) combined gate: suppressed. Dry-run is read-only — no DELETE and no upload POST is issued — so per BC-3.9.017's invariant (no destructive call → no gate fires), no gate fires. When `--public` is supplied on dry-run, JSON output still includes `"visibility":"public"` in `wouldUpload` entries; human output includes a `[public]` annotation. When same-filename matches exist on dry-run, they appear in `wouldDelete` entries. **GATES vs ELIGIBILITY GUARDS (P23-002)**: dry-run suppression in this EC applies exclusively to BC-3.9.014 confirmation gates; eligibility guards (BC-3.9.005 non-JSM exit-64 check and BC-3.9.017 step 0 validity checks) are NOT dry-run-suppressed — they fire unconditionally before any list GET, even on dry-run; see EC-3.9.020-8. Exit 0. P14-009; P15-002/R3.12 (extended to cover replace-existing match gate); P23-002.
**EC-3.9.020-8** (`--replace-existing --dry-run --public`, non-JSM — eligibility guard fires): `--dry-run` does NOT suppress the BC-3.9.005 eligibility guard. On a non-JSM issue key, `jr issue attachment upload <KEY> <FILE> --replace-existing --dry-run --public` exits 64 with the canonical BC-3.9.005 message before any list GET is issued and before any dry-run preview is emitted; `--dry-run` is irrelevant because the guard fires at BC-3.9.017 step 0, which is before the list-fetch step that `--dry-run` would preview. This mirrors EC-3.9.005-3 (which documents the same guard on the non-dry-run path). The GATES vs ELIGIBILITY GUARDS distinction: gates (BC-3.9.014) protect destructive calls and are suppressed on dry-run because no destruction occurs; eligibility guards protect against invalid flag combinations and are never suppressed. Exit 64; no preview emitted; no HTTP calls beyond the project-meta fetch (`GET /rest/api/3/project/{key}` — cache-miss; no `GET /rest/servicedeskapi/servicedesk` pagination since the project is NOT `service_desk`); no issue GET occurs on the `--replace-existing` step-0 path (project key derived from the issue-key string prefix per BC-3.9.017 step 0). P23-002; P28-001; BC-3.9.005; BC-3.9.017 step 0; EC-3.9.005-3.
**EC-3.9.020-9** (`upload --replace-existing --dry-run` — BC-3.9.012 file pre-checks are pre-flight checks, NOT suppressed by `--dry-run`): For each `<FILE>` argument supplied with `upload --replace-existing --dry-run`, `jr` validates file existence and type via `is_file()` (per BC-3.9.001 EC-3.9.001-4) **before any HTTP call and before any dry-run preview output**. If any file path does not exist or is not a regular file (directory, device, FIFO, etc.) → exit 64; stderr: `"file not found: <path>"` (missing) or `"not a regular file: <path>"` (exists but not a regular file). `--dry-run` does NOT suppress these checks. **THREE-CATEGORY DRY-RUN TAXONOMY** (P3-007): (1) **Confirmation gates** (BC-3.9.014) — SUPPRESSED on `--dry-run` (EC-3.9.020-7; no destructive call is imminent on a read-only preview pass). (2) **Eligibility guards** (BC-3.9.005 non-JSM check; BC-3.9.017 step-0 validity) — NOT suppressed (EC-3.9.020-8; P23-002; protect against invalid flag combinations and fire unconditionally). (3) **Pre-flight checks** (BC-3.9.012 file-existence/`is_file()` validation) — NOT suppressed; they validate supplied resource paths before any I/O and fire unconditionally regardless of `--dry-run`, consistent with the P32-001 fail-cheap principle and the AID-validation analog in EC-3.9.020 path-b. Pre-flight checks differ from eligibility guards: they validate resource reachability, not flag-combination validity. The EC-3.9.020-7/8 narrow definition of eligibility guards (BC-3.9.005 non-JSM check + BC-3.9.017 step-0) is unchanged; pre-flight checks are a distinct third category. P3-007.

**Trace**: F2 spec evolution (2026-07-15 SOH-ATTACHMENTS-1, DEC-179); impact-boundary-576.md R3.2 (--dry-run scope + output shape); BC-3.4.021 (`issue edit --dry-run` output precedent); adversary pass-1 human ruling R1 (2026-07-15); #526 JSON render invariant; P14-009 (--replace-existing --dry-run --public gate suppression + EC-3.9.020-7); P14-010 (BC-3.9.020 retitle to cover upload path c); P23-002 (EC-3.9.020-7 GATES vs ELIGIBILITY GUARDS distinction; EC-3.9.020-8 --dry-run non-suppression of eligibility guard); P28-001 (EC-3.9.020-8 wire enumeration corrected: "step-0 issue GET" replaced with accurate description — only project-meta GET fires; no issue GET on --replace-existing step-0 path; no servicedeskapi pagination for non-JSM project); P3-007 (EC-3.9.020-9 added: three-category dry-run taxonomy — pre-flight checks are a distinct third category not suppressed by --dry-run; EC-3.9.020-7/8 narrow eligibility-guard definition preserved)


## Total BCs in this file: 123 individually-bodied (cumulative 152 incl. range-collapsed; see BC-INDEX.md)

_Last updated 2026-07-29 (SOH-DX-1 version retarget v1.3.169): 0 new BCs / 0 new VPs / 0 new holdouts — SOH-DX-1 breaking-change version target corrected to v0.6.0-dev.12 (human ruling 2026-07-29; supersedes DEC-188 clause (d)'s 0.7-train reasoning; see spec-changelog.md [1.3.169]); 4 `[AMENDED … DEC-188]` banners updated (~:539, ~:3049, ~:3137, ~:3149); BC count unchanged (140/111). Previous update 2026-07-29 (SOH-DX-1 F2 holdout authoring v1.3.164, #639, DEC-188): 6 new holdouts / 0 new BCs / 0 new VPs — H-NEW-PREFLIGHT-001..006 added to holdout-scenarios.md Group 20 (BC-3.8.012 --field pre-flight guard; BC-3.8.013 --on-behalf-of pre-flight guard); BC-3.8.012/013 Trace fields updated with holdout IDs; Note (coverage non-goal) in both BCs updated to acknowledge F2 gate human ruling override of F51-001 non-goal; holdout count 100→106; CANONICAL-COUNTS.md, README.md, spec-changelog.md updated; spec v1.3.164; BC count unchanged (140/111). Previous update 2026-07-28 (P73-001 LOW v1.3.162 pending-revert annotations for hyphenation workarounds): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.9.001 Trace and BC-3.9.003 Trace: inline pending-revert notes added flagging "encoding-test" and "wiremock-test" hyphenation (8a0a2422 workaround 2026-07-15) as pending revert by S-627-1 once scripts/check-bc-no-numeric-test-counts.sh guard-regex fix merges to develop; do NOT un-hyphenate until then; no BC behavioral changes; spec v1.3.162; BC count unchanged (140/111). Revert completed 2026-08-12 (S-627-1 Phase 2, after Phase 1 guard-regex fix merged to develop at c3edf216): BC-3.9.001 Trace and BC-3.9.003 Trace un-hyphenated back to "encoding test" and "wiremock test"; the inline pending-revert markers were removed from both sites; no BC behavioral changes. Previous update 2026-07-28 (P72-001 HIGH v1.3.160 EC-3.4.015-4a false-serde_json-claim correction): 0 new BCs / 0 new VPs / 0 new holdouts — EC-3.4.015-4a rewritten: false claim that `serde_json::Number::from_f64(5.0)` serializes as `5` removed; correct mechanism stated (`src/cli/issue/field_resolve.rs::parsed_number_to_wire_value` integer branch `Number::from(parsed as i64)` when `fract() == 0.0` AND strictly within i64 bounds); callers MUST NOT use `from_f64` for whole numbers; `5e3`→`5000` and `5.5`→`5.5` re-attributed; VP-396-010 pin retained; spec v1.3.160; BC count unchanged (140/111). Previous update 2026-07-28 (F67-001/F67-002 LOW v1.3.159 ordering-sentence precision + AC .current_dir() rationale corrections): 0 new BCs / 0 new VPs / 0 new holdouts — F67-001 (LOW, delta-attributable): BC-3.8.012 combined-check ordering sentence broadened to constrain BOTH single-flag checks (the `--field`-only check and the `--on-behalf-of`-only check); BC-3.8.013 carries no mirrored ordering statement (no change required); F67-002 (LOW, delta-attributable): AC-9/AC-11/AC-16/AC-17 `.current_dir()` rationale corrected from false "degrades discriminating power" to hygiene-isolation (ancestor-config isolation prevents inherited credentials from enabling a live HTTP escape); AC-10 not corrected (would-otherwise-succeed invocation, no false language); spec v1.3.159; BC count unchanged (140/111). Previous update 2026-07-28 (F66-001 LOW v1.3.158 malformed-field literal propagation completion): 0 new BCs / 0 new VPs / 0 new holdouts — F66-001 (LOW, delta-attributable): BC-3.8.012 Behavior block (~:3076) and EC-3.8.012-3 (~:3088) aligned to current literal `bareflagnoequals`; completes v1.3.142 F44-003 LOW-1 propagation; three historical records (lines 138, 149, 4069) deliberately preserved; spec v1.3.158; BC count unchanged (140/111). Previous update 2026-07-28 (F65-001 MEDIUM/F65-002 LOW v1.3.157 citation correction + AC-expansion directive): 0 new BCs / 0 new VPs / 0 new holdouts — F65-001 (MEDIUM, delta-attributable): BC-3.8.012 Trace obligation (g) citation corrected — ambiguous bare `delta-analysis.md` line 81 (introduced v1.3.156) replaced with `.factory/phase-f1-delta/SOH-DX-1/delta-analysis.md § "2. Regression Risk Assessment" (#639 row, `src/cli/issue/create.rs`); F65-002 (LOW, delta-attributable): AC namespace note gains F3 expansion-format directive — "verbatim" governs content not line formatting; `.factory/stories/S-576-3.md` named as format reference; spec v1.3.157; BC count unchanged (140/111). Previous update 2026-07-28 (F64-001 LOW v1.3.156 E2E scan obligation discharged at F2): 0 new BCs / 0 new VPs / 0 new holdouts — F64-001 (LOW): delta-attributable; `tests/e2e_live.rs` scanned for `issue create` invocations carrying `--field` or `--on-behalf-of` without `--request-type` (F1 obligation, `delta-analysis.md` line 81, #639 regression-risk row); zero found; all 8 `--field` occurrences are `issue edit --field`; zero `--on-behalf-of` occurrences; no E2E test changes required at F4; item (g) added to S-639-1 delivery (F4) obligations in BC-3.8.012 Trace; spec v1.3.156; BC count unchanged (140/111). Previous update 2026-07-27 (F63-001 MEDIUM/F63-002 LOW v1.3.155 README H-NEW-JSM-RT range terminus correction): 0 new BCs / 0 new VPs / 0 new holdouts — F63-001 (MEDIUM): README.md line 48 and line 108 `H-NEW-JSM-RT-001..006` → `H-NEW-JSM-RT-001..007` (maximum verified against holdout-scenarios.md; line 48 wrong since v1.3.143; line 108 introduced by v1.3.154 orchestrator instruction — orchestrator inferred terminus without verifying, correction belongs here); F63-002 (LOW): informational caveat added to line 108 matching line 48 wording; twin-artifact sweep recurrence 16: CANONICAL-COUNTS.md `..007` correct; historical snapshots and STORY-INDEX records out-of-scope; H-018 absent from bare-H span flagged as observation only; spec v1.3.155; BC count unchanged (140/111). Previous update 2026-07-27 (F62-001 MEDIUM/F62-002 LOW v1.3.154 holdout-count partial-propagation fix and changelog BC Count completion): 0 new BCs / 0 new VPs / 0 new holdouts — F62-001 (MEDIUM): README.md Supplement Index holdout row count `55` → `100`, range `H-NEW-JSM-RT-001..005` → `H-NEW-JSM-RT-001..006` (stale since v1.3.143/F45-003 which only fixed the Files-table row, line 48; Supplement Index row, line 108, was the Holdout-evaluator consumer, understating scope by 45 scenarios); F62-002 (LOW): spec-changelog [1.3.113] and [1.3.114] entries gain `### BC Count` sections after their `### Changed` blocks, matching [1.3.112] structural pattern (0 new BCs; 657/140/111 unchanged); twin-artifact sweep recurrence 15: all other holdout-count and `H-NEW-JSM-RT` range occurrences confirmed correct or out-of-scope (historical adversarial reviews, completed-story STORY-INDEX records); spec v1.3.154; BC count unchanged (140/111). Previous update 2026-07-27 (F60-001 LOW v1.3.153 README L3 BCs metric correction): 0 new BCs / 0 new VPs / 0 new holdouts — F60-001 (LOW): README.md bc-3-issue-write.md row "L3 BCs" column corrected `(111)` → `(140)` (column reports `total_bcs`, not `definitional_count`; bc-3 was the only row using the wrong metric; bc-1 `(57)` and bc-4 `(32)` confirm `total_bcs` is the column convention); spec v1.3.153; BC count unchanged (140/111). Previous update 2026-07-27 (F57-001 LOW v1.3.152 AC-17 assertion-substring narrowing): 0 new BCs / 0 new VPs / 0 new holdouts — F57-001 (LOW): AC-17 negative assertion narrowed from bare `"cannot be combined with"` to `` "cannot be combined with `--markdown`" ``; HYGIENE label and all other AC-17 assertions unchanged; spec v1.3.152; BC count unchanged (140/111). Previous update 2026-07-27 (F56-001 MEDIUM v1.3.151 false-assert_cmd-premise fix in AC-18): 0 new BCs / 0 new VPs / 0 new holdouts — F56-001 (MEDIUM): AC-18 non-normative rationale corrected — false "assert_cmd provides no timeout primitive" premise deleted; "process exits promptly" IS testable via assert_cmd `Command::timeout` (present in assert_cmd 2.2.2, verified against Cargo.lock); "stdin NOT consumed" correctly kept non-normative — a timeout proves no hang but does NOT prove stdin was never read; design decision (ii) explicitly recorded: timeout assertion declined on CI-flakiness + no-discriminating-power grounds; spec v1.3.151; BC count unchanged (140/111). Previous update 2026-07-27 (SOH-DX-1 F2 v1.3.150 F52-001 error-taxonomy DEC-188 registration): 0 new BCs / 0 new VPs / 0 new holdouts — F52-001 (LOW): error-taxonomy.md Section 6 gains new Issue Commands subsection registering three DEC-188 pre-flight exit-64 error conditions (BC-3.8.012: --field without --request-type; BC-3.8.013: --on-behalf-of without --request-type; combined: both flags present, BC-3.8.012 governs); all three are JrError::UserError, zero HTTP on each path; spec v1.3.150; BC count unchanged (140/111). Previous update 2026-07-27 (SOH-DX-1 F2 v1.3.149 F51-001 coverage non-goal documentation): 0 new BCs / 0 new VPs / 0 new holdouts — F51-001 (LOW): holdout-scenario and VP coverage documented as deliberate non-goal in BC-3.8.012 and BC-3.8.013 — terminal **Note (coverage non-goal)** added to each BC after **Confidence**: HIGH; 21 ACs cover every observable exit path (exit code, both output modes, all three verbatim error strings, zero-HTTP proof, idempotency, ordering precedence, JSM-path non-mis-fire); pure pre-flight input validation with no network interaction excludes holdout surface; contrast with VP-331-003 (BC-3.4.019) cited; spec v1.3.149; BC count unchanged (140/111). Previous update 2026-07-27 (SOH-DX-1 F2 v1.3.148 F49-001 BC-3.8.013 doc-fallout enumeration fix): 0 new BCs / 0 new VPs / 0 new holdouts — F49-001 (LOW): BC-3.8.013 doc-fallout deliverables sentence corrected — obligation (d) (`src/cli/mod.rs` `--on-behalf-of` first doc line ~:403 `"requires --request-type"` substring, pinned by AC-12) added to illustrative parenthetical; delegation marked NORMATIVE; enumeration marked non-exhaustive; BC-3.8.012 Trace (a)–(f) declared authoritative and binding; spec v1.3.148; BC count unchanged (140/111). Previous update 2026-07-27 (SOH-DX-1 F2 v1.3.147 AC-7 EC-3.8.012-3 linkage fix): 0 new BCs / 0 new VPs / 0 new holdouts — F48-001 (LOW): EC-3.8.012-3 as test linkage marker added to AC-7 (`test_platform_create_malformed_field_without_request_type_exits_64`); malformed `--field` case was the only testable EC in BC-3.8.012/013 with no explicit AC citation; traceability only, no behavioral change; spec v1.3.147; BC count unchanged (140/111). Previous update 2026-07-27 (SOH-DX-1 F2 round-47 v1.3.146 write_profile_config-placement fix): 0 new BCs / 0 new VPs / 0 new holdouts — F47-001 (LOW): write_profile_config destination corrected in both Test Note Config fixture contracts (BC-3.8.012 §"Config fixture contract" + BC-3.8.013 §"Config fixture contract"); tests/common/assertions.rs → tests/common/fixtures.rs; "same promotion target as assert_json_error_envelope" phrase removed and replaced with DIFFERENT-destinations rationale (fixtures.rs is the home for non-assertion test fixtures including config writers; F46-003 "pure-JSON" charter narrowed to payload fixtures only); secondary historical-record cleanup: footer v1.3.137 description corrected (assertions.rs → fixtures.rs for write_profile_config; same F46-003 sweep class, not restored by v1.3.145 which fixed frontmatter trail entries only); spec v1.3.146; BC count unchanged (140/111). Previous update 2026-07-27 (SOH-DX-1 F2 round-46 v1.3.145 trail-anachronism remediation): 0 new BCs / 0 new VPs / 0 new holdouts — F1: v1.3.114 trail entry restored (fixtures.rs ~:76 reverted from assertions.rs; unintended replace_all sweep from v1.3.144 F46-003); F2: v1.3.108 trail entry restored (assert_json_error_envelope promotion directive fixtures.rs reverted; same sweep); F3: v1.3.137 trail entry restored (write_profile_config fixture contract description fixtures.rs reverted; same sweep); F4: spec-changelog [1.3.144] F46-003 scope statement corrected ("replace_all on all promotion-target path references" → "(9 sites: 5 spec body + 3 historical trail entries + 1 footer)"); unintended-anachronism note added; F5: v1.3.144 frontmatter trail entry F46-003 clause corrected (scope corrected + unintended-anachronism note added); spec v1.3.145; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.144 round-46 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F46-001 (MED): AC-2 + AC-7 gain would-otherwise-succeed clause + mount_platform_create_stubs MUST; F46-002 (LOW): both body-range labels reworded to "BEFORE all pre-POST helper HTTP (steps 3–5) and BEFORE the platform POST (step 6)" (replace_all, 2 sites); F46-003 (LOW): promotion target fixtures.rs→assertions.rs (replace_all); convention note updated; mod.rs registration note added (both Test Notes); spec v1.3.144; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.143 round-45 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F45-001 (MED): deliverable (e) gains THIRD stale-parity site tests/issue_create_jsm.rs ~:2373-2374 (false platform-parity claim + dead "create.rs lines 333-343" citation); F45-002 (MED): banner-rewrite obligation extended to FAMILY-level banner ~:2381-2391 (THREE false clauses enumerated); F45-003 (MED): README.md holdout row 55→100 + H-NEW-JSM-RT-006 + caveat; spec v1.3.143; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.142 round-44 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F44-001 (MED): false json_error_shape.rs Hygiene premise deleted from both Test Notes (verified-false; issue_create_jsm.rs gains statement retained); F44-002 (MED): "BC-3.8.011 direction" → "BC-3.8.010 + BC-3.8.011 directions" at both sites; F44-003 (MED): AC-11 (4) DISCRIMINATING→HYGIENE (projectless; matches AC-9/AC-17); intro "Required discriminators" → "Required assertions" with (1)+(2) discriminating/(3)/(4)/(5) hygiene; LOW-1: AC-7 KEPT note bareflagnoequals; LOW-2: "steps 3–6" → "steps 3–5…step 6 excluded terminal" at both sites; spec v1.3.142; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.141 round-43 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F43-01 (MED): AC-11 discriminator list extended to five (adds (4) exit 64 DISCRIMINATING + (5) stdout.trim().is_empty() hygiene); F43-02 (MED): AC-16 gains .current_dir(<per-test TempDir>) MUST precondition (find_project_config walk-up; doubly critical: projectless + FULL-STRING single source); Obs: "steps 3–5" → "steps 3–6" at both [CURRENT BEHAVIOR] sites; spec v1.3.141; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.140 round-42 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F42-01 (MED): [1.3.139] changelog gains ### Changed block + correct BC Count; O-1 (LOW): mode-agnosticism invariant restored to both [CURRENT BEHAVIOR] Behavior blocks (guard fires regardless of --no-input/--output json); O-2 (LOW): MUST-NOT falsifier enumeration softened at both [CURRENT BEHAVIOR] sites (non-exhaustively; AC-15 alone is insensitive); spec v1.3.140; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.139 round-41 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F41-01 (MED): AC-13 invocation upgraded to would-otherwise-succeed (--project PROJ --type Task --summary "test" added); zero-HTTP received_requests().is_empty() now NORMATIVE (guard-absent path reaches HTTP); mount_platform_create_stubs NOT called; F41-02 (MED): AC-1 REGRESSION PIN gains "(DISCRIMINATING subtype)" at first use + policy note (later ACs may keep or drop; both correct); F41-04 (nit): write_profile_config param dir → config_home at both Config fixture contract sites; spec v1.3.139; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.138 round-40 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F40-001 (HIGH): REGRESSION PIN added to AC-9/10/11/17/18 bodies; AC-19 added to non-vacuity sentence enumeration (13 ACs fully propagated); F40-002 (MED): Definition (unconditional remedy) added inline to uniform rule — depends only on user's own invocation; 'Add --request-type <NAME>' qualifies; 'jr issue edit --field' does NOT qualify; closes two-ways reading without changing verbatim strings; Obs: [1.3.133] F35-1 correction note appended; spec v1.3.138; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.137 round-39 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F-1: Removal postcondition uniform rule qualified to "every AC that reaches handle_create with a guarded flag and no --request-type"; AC-15 exclusion added (clap conflicts_with exit-2 pre-handler; guard never evaluated); F-2: write_profile_config specified in both Test Note Config fixture contracts (lives in tests/common/fixtures.rs; signature write_profile_config(config_home: &Path, base_url: &str); shape modeled on tests/issue_create_jsm.rs ~:1959-1966); F-3: EC-3.8.012-10 gains transitively-falsified sentence (received_requests().is_empty()); Obs-1: [1.3.136] changelog gains ### BC Count + ---; Obs-2: frontmatter trace v1.3.114 moved to correct descending position; Obs-3: README bc-3 (107)→(111); spec v1.3.137; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.136 round-38 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F-1: write_minimal_config REPLACED note added to AC-2/AC-5/AC-7 DELETE mandates; F-2: conditional tail stripped from BC-3.8.012 verbatim string + AC-1 FULL-STRING pin; uniform rule added; F-3: EC-3.8.012-10 §42-45 mis-scoped claim corrected; deliverable (a) five→four sites; F-4: deliverable (f) feature spec added; F-5: REGRESSION-PIN mandate extended to AC-1/2/3/5/7/8/9/10/11/13/17/18/19; AC-8 both invocations gain REGRESSION PIN (in-round residual); F-6: AC-13 zero-HTTP assertion added; spec v1.3.136; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.131 round-33 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F33-1 (MED): AC-3 two single-flag-absence negatives labeled FALSIFIABLE-COARSE; AC-9 !stderr.contains("Project key") labeled DISCRIMINATING (guard fires step 2 before project-key resolution step 3; --project NOT required); F33-2 (MED): AC-10 invocation completed to would-otherwise-succeed (--project PROJ --type Task --summary "test" --field a=b --output json + mount_platform_create_stubs MUST be called; stdout.trim().is_empty() now genuinely DISCRIMINATING); pairing note updated to "symmetric twins for the would-otherwise-succeed invocation class"; F33-3 (LOW): AC-10 TempDir precondition added (find_project_config ancestor-walk hygiene; matches AC-8); F33-4 (LOW): BC-3.8.013 Trace gains AC-8 invocation (ii) zero-HTTP pin note; F33-5 (LOW): AC-7 example value bare-name-no-equals → bareflagnoequals (match KEPT body ~:2845); spec v1.3.131; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.130 round-32 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F32-1 (MED): EC-3.8.012-10 added (guard project-type-agnostic; step-2 fires before require_service_desk; MUST NOT gate on project type; ADR-0014 §42-45 reversed per deliverable (a); BC-3.8.011 direction contrast); F32-2 (MED): stdout.trim().is_empty() DISCRIMINATING label added in AC-2/7/10 (json mode; create.rs ~:249/:265 success stdout); F32-3 (MED): AC-16 REGRESSION PIN added; BC-3.8.013 Removal postcondition extended to AC-2 + AC-16; O-1 (LOW): delivery obligation (e) jsm_create.rs ~:171-172 comment fix; O-2 (LOW): BC-3.8.012+013 Behavior "BEFORE interactive prompts" → "BEFORE project-key resolution, BEFORE interactive prompts" (both BCs); spec v1.3.130; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.129 round-31 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F31-1 (HIGH): BC-3.3.001 H1 + BC-INDEX row 274 retitled from stale `{"key":"FOO-123"}` → follow-up-GET shape (created issue object + url; {key,url,fetch_error} on fetch failure); F31-2 (MED): AC-8 normative zero-HTTP proof added (`server.received_requests().await.unwrap().is_empty()` on each isolated MockServer; tests/issue_create_json.rs ~:411 primitive; (d) relabeled DEFENSE-IN-DEPTH; all (a)-(e) now DEFENSE-IN-DEPTH; invocation (ii) reference updated); LOW: SSOT step 7 "NOT intercepted by the guards" → "not reached on the guarded path (the handler returns at step 2)"; spec v1.3.129; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.128 round-30 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F30-1 (MED): AC-11 rationale corrected: dialoguer 0.12 interact_text() short-circuits on non-TTY stderr under assert_cmd (prompt never renders); discriminator (2) rewritten as ERROR-absence proof (create.rs ~:102-108); "fires BEFORE interactive prompt" claim deleted; Non-goal + purpose statement added (PTY harness required for true interactive branch; AC-11's value = JR_STDIN_IS_TTY=1 no-auto-flip path); Obs (folded): AC-12 coupling note added (count==2 assumes no other flag help contains substring); spec v1.3.128; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.127 round-29 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F-1 (HIGH): AC-20 + AC-21 raiseOnBehalfOf citation corrected BC-3.8.007 → BC-3.8.009; F-2 (MED): cwd precondition propagated to AC-11 and AC-17 (find_project_config ~:362 ancestor-walk isolation; both use !stderr.contains("Project key") as named discriminator); Obs-1: BC-3.8.013 Behavior "(at most one occurrence on the command line)" → "(repeats accepted by clap, last-wins; contract keys on is_some())"; Obs-2: BC-3.8.013 Asymmetry rationale gains Error-string completeness note (create-then-edit remedy omission is deliberate — factually conditional on Modify Reporter permission; unconditional remedies inline and sufficient); spec v1.3.127; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.126 round-28 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F-1: AC-1 FULL-STRING pin Rust-literal note (backticks are ordinary — no escaping; `\`` is Markdown artifact; verbatim from ~:3024); F-2: BC-3.8.012+BC-3.8.013 Behavior gain MUST-NOT clap-requires directive (hand-rolled JrError::UserError in handle_create only); F-3: AC-1 renderer cite extended (_ => arm; JSON arm ~:134-140 emits no prefix); F-4: AC-5 anchor rationale corrected (guard absent → SUCCEED + identical "Created issue PROJ-123" stderr at ~:272; byte-identity cannot distinguish; anchor pins error); F-5: SSOT anchor ~:2971 → ~:2980; Obs: AC-4 follow-up-GET note (unstubbed → fetch-warning; negatives unaffected; no stderr-cleanliness assertions); spec v1.3.126; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.125 round-27 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F-27-01: AC-17 !stderr.contains("cannot be combined with") relabeled DISCRIMINATING→HYGIENE (BC-3.8.017 string unreachable without --request-type; same structural class as AC-15); real discriminating pair: positive stderr.contains("--field is only valid with") AND !stderr.contains("Project key") (DISCRIMINATING — proves step-2 guard-before-project-lookup ordering); F-27-02: AC-8 Mock ResponseTemplate note added (each expect(0) mock MUST include respond_with e.g. ResponseTemplate::new(200); response irrelevant; expect(0) count is the assertion); LOW: ~:3047/~:3132 helper cite rephrased (fn at ~:63; stdout.trim().is_empty() semantics at ~:76); spec v1.3.125; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.124 round-26 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F-1: AC-1/AC-3/AC-16 full-string pins (single-source per verbatim error string; other ACs use prefix pins only); LOW-2 embedded in AC-1: "Error: " prefix pin annotated as single-source from `src/main.rs` ~:143 unconditional error renderer; F-2: AC-8 split into two sub-invocations each against a separate isolated MockServer instance — invocation (i) = --field a=b (BC-3.8.012 prefix pin); invocation (ii) = --on-behalf-of X replacing --field a=b (BC-3.8.013 prefix pin; same expect(0) mock set (a)–(e)); F-3: delivery item (d) --on-behalf-of first doc line "another user" → "this accountId" (accountId value-format signal from -h preserved); LOW-1: BC-3.3.001 Behavior cite BC-3.4.014 line 1122 → ~:1122 (TD-031 citation form); LOW-3: AC-2/AC-7 gain `assert_json_error_envelope` note (shape only — `error` field contains-assertion at call site; mirrors AC-10 note (ii)); spec v1.3.124; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.123 round-25 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F25-01: AC-5 DELETE mandate adds existing 3-field invocation (~:2712-2717; collapses n=1 vs n>1 discriminator; two-invocation spec: (i) exactly one `--field`, (ii) exactly two); invocation (i) annotated "(MUST be exactly one `--field`)"; F25-02+F25-03: 3-tier taxonomy (DISCRIMINATING/FALSIFIABLE-COARSE/HYGIENE) encoded in codified-rule sentence; AC-6 combined-string HYGIENE→FALSIFIABLE-COARSE; AC-13 single-flag absent pair labeled FALSIFIABLE-COARSE; AC-14 DISCRIMINATING on `!stderr.contains("--field is only valid with")`; AC-15 HYGIENE on `!stderr.contains("--field is only valid with")`; AC-16 FALSIFIABLE-COARSE on combined-string; AC-17 DISCRIMINATING on `!stderr.contains("cannot be combined with")`; AC-20 combined-string HYGIENE→FALSIFIABLE-COARSE; F25-04: BC-3.3.001 Behavior line corrected (stale `{"key":"FOO-123"}` → follow-up GET full issue object + url per create.rs ~:243-249; applied in prior burst); LOW-1: AC-2/AC-7 KEPT clauses gain shorthand-vs-canonical note; LOW-2: preamble "BCs 002..011" → "BCs 002..011 and 014..017 (JSM-path contracts)"; spec v1.3.123; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.122 round-24 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F24-01: KEPT exclusion clauses deleted from AC-18 and AC-19 (NEW tests — no existing body; over-applied by round-22 replace_all); F24-02: AC-4 invocation added (jr issue create --project PROJ --type Task --summary "test" --output json + mount_platform_create_stubs; exit 0); KEPT + S-639-1 story deliverable added to AC-4 and AC-6; F24-03: SSOT header "complete guard/HTTP ordering" → "guard-relevant ordering (authoritative for step numbering)"; completeness caveat: type/summary fallbacks are step 4's failure arms; --markdown→ADF between step 4a and step 5; AC namespace note SSOT cross-ref updated; LOW-1: fourth ADR-0014 site added to doc-fallout obligation (a) (~:42-45; "three"→"four" sites); LOW-2: fourth stub named in AC-20/AC-21 (POST /rest/servicedeskapi/request returning jsm_created_response() per ~:2758-2763); spec v1.3.122; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.121 round-23 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F23-03: AC-8 anchors refreshed (teams.rs ~:12/~:33; fields.rs ~:26); F23-04: promotion directive adds `pub fn` qualifier (fixtures.rs convention); F23-01: BC-INDEX index_version v6.45→v6.50; F23-02: README.md 603→657 + provenance note; spec v1.3.121; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.120 round-22 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — in-round residual: AC-20 RT name "password-reset" → "Password Reset" (fixture tests/issue_create_jsm.rs ~:135; partial_match rejects hyphenated form); KEPT clauses rewritten to exclusion form in AC-1/2/3/5/7/18/19; AC-1 notes: presence-only guard (!field_pairs.is_empty() ~:81) + --no-input deliberate (AC-11 is TTY test); AC-2: no line-range anchor (old ~:2537 collided with DELETE target); EC-3.8.012-2: whitespace-only variant added (trim-guard at jsm_create.rs ~:145); spec v1.3.120; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.119 round-21 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F21-01: AC-20/21 invocations add `--project HELP --summary "test"` (realizable JSM exit-0); F21-02: real stubs named in AC-20+21 (mount_project_meta_help ~:24, mount_service_desk_list ~:52, mount_request_types_password_reset ~:121); F21-03: AC-5 DISCRIMINATING NEGATIVE added; F21-04: AC-2/AC-7 KEPT clauses added; LOW-1: SSOT completeness caveat; LOW-2: AC-8 team_field_id precondition; LOW-3: no change (deliberate); spec v1.3.119; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.118 round-20 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F20-1+F20-2(a): AC-1/3/5/18/19 complete invocations (--project PROJ --type Task --summary "test" + mount_platform_create_stubs KEPT); would-otherwise-succeed falsifiability rationale; KEPT-note for existing args/stubs; !stderr.contains("Created issue") remains DISCRIMINATING; F20-2(b): AC-9 "Created issue" HYGIENE (projectless BY DESIGN); F20-2(c): AC-11 "Created issue" HYGIENE (bare-MockServer + projectless); F20-2(d): AC-8 mock labels: (d) GET /rest/api/3/field DISCRIMINATING; (a)-(c)+(e) DEFENSE-IN-DEPTH; "Created issue" HYGIENE; F20-4: AC-8 call-site corrected (create.rs ~:213); F20-5: EC-3.8.013-2 added (--on-behalf-of X --request-type "" → JSM route; BC-3.8.016 fires; BC-3.8.013 MUST NOT fire); spec v1.3.118; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.117 round-19 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F-1: AC-21 added (test_jsm_create_with_both_flags_and_request_type_does_not_fire_guards [mode: --output json] — JSM path combined non-mis-fire, all three new-error negatives FALSIFIABLE); AC-6/AC-20 HYGIENE labels; AC namespace note AC-1..20→AC-1..21 + SSOT pointer + falsifiability rule; BC-3.8.013 Trace range + AC-21 reference; F-2: five ':3036' cites → section-form §"Removal postcondition (single-site, DEC-188)"; F-3: --output json removal mandates to AC-1/AC-3/AC-5 invocations; F-5: AC-17 negatives rescoped to BC-3.8.017 rival string "cannot be combined with"; spec v1.3.117; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.116 round-18 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F18-001: AC-2 DELETE mandate for !stdout.contains("warning: --on-behalf-of is ignored") (~:2551); AC-4 NORMATIVE DELETE mandates for ~:2671 + ~:2675 (vacuous negatives); AC-6 NORMATIVE DELETE mandate for ~:2799 (vacuous negative); F18-002: AC-4 third negative !stderr.contains("--field and --on-behalf-of are only valid with") added (all three new-error strings pinned on clean path); F18-003: AC-20 (NEW) test_jsm_create_with_on_behalf_of_and_request_type_does_not_fire_bc_3_8_013 [mode: --output json] (JSM path non-mis-fire pin for BC-3.8.013, mirrors AC-6); AC namespace note AC-1..19→AC-1..20; BC-3.8.013 Trace range + AC-20 reference added; LOW-1: preamble BCs 001..011→002..011 + BC-3.8.001 governs absent case; spec v1.3.116; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.115 round-17 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F17-01: AC-8 and AC-11 MockServer isolation constraint (MUST NOT call mount_platform_create_stubs; FIFO rationale per CLAUDE.md §BC-3.9.006); F17-02: AC-1/2/3/5 OLD ASSERTIONS completion (verbatim-warn + stdout PROJ-123 removals; tilde line cites); F17-03: AC-1 (ii) corrected from .count() form to verbatim contains form (~:2470-2473); F17-04: AC-1/3/8/9/11/18/19 DISCRIMINATING NEGATIVE !stderr.contains("Created issue") + stdout.trim() hygiene note (BC-3.4.014 non-discriminating in human mode); AC-11 discriminators "two"→"three"; LOW-1: BC-INDEX BC-3.8.012/013 rows H1 title prepended; LOW-2: spec-changelog [1.3.110]-[1.3.115] Summary lines "(DEC-188 ratified 2026-07-25)" appended; spec v1.3.115; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.114 round-16 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F16-01: AC-3 self-contradiction resolved (postcondition wins; OLD ASSERTION MUST BE REMOVED → REGRESSION PIN); AC-1/2/5/7 regression pins added; F16-02: AC-14 invocation adds --project PROJ + stderr.contains("request type cannot be empty"); AC-13/16/17/18/19 per-AC discrimination notes; F16-03: Outputs/Effects file cite corrected (fixtures.rs ~:76 → json_error_shape.rs ~:76 current); F16-04 (folded in F16-01): AC-5 re-tagged [mode: human] + byte-identity note; F16-05: SSOT step 3 extended (includes project-key interactive prompt); step 4 deduplicated (type+summary only); AC-11 step 4→step 3; spec v1.3.114; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.113 round-15 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — F15-01: AC-1 re-scoped to [mode: human] (invocation jr issue create --field a=b; exit 64 + stderr.contains("Error: ") + stderr.contains("--field is only valid with") + stdout.trim().is_empty(); pairing note with AC-10); AC-10 annotated [mode: --output json] + pairing note; F15-02: AC-3 invocation added (jr issue create --field a=b --on-behalf-of X) + exit 64 + OLD ASSERTION removal pin; F15-03: Outputs/Effects lines updated (stdout.trim().is_empty() normative predicate + helper reference); all stdout.is_empty() → stdout.trim().is_empty() globally; F15-04: AC-18 demoted "stdin NOT consumed" to non-normative rationale; normative assertions now exit 64 + stderr + stdout.trim().is_empty(); F15-05: AC-8 team-resolution endpoints enumerated (3 specific endpoints with file~:line cites); Obs-1: BC-3.3.001 H1 DEC-188 qualifier; Obs-2: EC-3.8.012-6 no-AC rationale; spec v1.3.113; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.112 round-14 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — AC-1/2/7 fully re-specified (F14-01: exit 64 + positive substring + assert_json_error_envelope + old-assertion removal mandates); AC-11 discriminators corrected (F14-02: dialoguer-stderr note; expect(0) non-discriminating note; !stderr.contains("Project key") added); Removal postcondition LOW-1 extension (AC-1 stdout negative vacuity at ~:2479-2482); EC-3.8.012-9 re-scoped to --field a= (LOW-2; AC-19 invocation updated); mode annotations completed AC-4/6/8/9/11/12/13..18 (LOW-3); spec v1.3.112; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.111 round-13 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — AC-8 citation corrected (F13-01: get_myself cite → resolve_assignee_by_project ~:436/~:443 → JiraClient::get_myself users.rs ~:19); AC-11 false-green hardened (F13-02: MUST NOT --no-input + MUST NOT --project explicit preconditions; discriminators enumerated; main.rs ~:103-114 cite); AC-12 wrap-fragility fixed (F13-03: whitespace-normalization mandatory before count assertion); AC-9 second precondition added (F13-04: profile config must lack project key; write_minimal_config ~:165-173 cite); spec v1.3.111; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.110 round-12 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — output-mode annotation per AC (F12-05: AC-1/2/5/7 [mode: --output json]; AC-3/AC-19 [mode: human]; AC-3 and AC-19 stdout.trim().is_empty() assertions added); SSOT step 4a added (F12-06: --description-stdin blocking read cite, create.rs::handle_create ~:132-145, between step 4 and step 5; EC-3.8.012-7 guard fires at step 2 so step 4a unreachable on guarded path); helper-promotion directive extended in both BC-3.8.012 and BC-3.8.013 Test Notes (LOW-1: stale doc-comment fix note — {"error":…,"code":…} → {"code":…,"error":…} BTreeMap alphabetical); BC-INDEX section 3.8 header "superseded"→"amended" (LOW-2); spec v1.3.110; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.109 round-11 adversary-pass corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — combined error string parenthetical trimmed (F11-01: "(then use jr issue edit --field for custom fields; --on-behalf-of has no platform equivalent)" removed; same citation-discipline class as round-10 BC-3.8.013 single-flag fix); BC-3.8.013 prose hedged (F11-01: permission-dependent remedy replaces false "must be set at creation time" claim); AC-12 dual-assertion re-spec (F11-02: two per-flag scoped occurrences, not single contains()); delivery item (d) FIRST-LINE-ONLY clarification (F11-03); vacuity rationale at Removal postcondition (F11-04: regression-pin explanation + AC-4 asymmetry); AC-17/18/19 added (F11-05: EC-3.8.012-5/7/9 coverage); AC namespace note range AC-1..16→AC-1..19; BC-INDEX BC-3.4.014 DEC-188 qualifier (F11-06); spec-changelog [1.3.107] Type MINOR→PATCH (process-gap); spec v1.3.109; BC count unchanged (140/111). Previous update 2026-07-26 (SOH-DX-1 DEC-188 v1.3.108 round-10 spec-text corrections, #639): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.8.013 error string parenthetical removed ("reporter identity is not settable post-creation via platform" factually wrong per CLAUDE.md citation discipline); AC-12 renamed + help-text pin (verbatim "requires --request-type" per delivery item (d)); ADR-0014 delivery section corrected to enumerate all 3 amendment sites explicitly; AC namespace note added (BC-3.8.012 Trace + BC-3.8.013 Trace pointer: S-639-1 ACs supersede S-383 same-numbered ACs); assert_json_error_envelope promotion directive finalized (DELETE original fn from tests/json_error_shape.rs; three call sites re-import from tests/common/assertions.rs); spec v1.3.108; BC count unchanged (140/111). Previous update 2026-07-25 (SOH-DX-1 DEC-188 F2 supersession, #639): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.8.012 superseded: warn-and-proceed (exit 0) → pre-flight JrError::UserError exit 64 BEFORE any HTTP; ONE error regardless of --field count; combined error when both --field and --on-behalf-of present without --request-type; verbatim error strings drafted; BC-3.8.013 superseded: same pattern for --on-behalf-of; asymmetry rationale encoded (self-declared JSM-only flags → exit 64 caller-error; general platform flags → warn-and-degrade); BC-3.3.001 amendment note updated (exit-64 supersedes warn-and-continue per DEC-188); BC-INDEX v6.44→v6.45; spec v1.3.107; BC count unchanged (140/111). Previous update 2026-07-18 (SOH-ATTACHMENTS-1 P20-ROUND micro-fix 1.3.87→1.3.88): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.9.012/BC-3.9.013 error-table 401/network stderr cells corrected to loose-substring form (P20-002 root cause + INFO three-way divergence); stale quoted 401 cell `"Not authenticated. Run \`jr auth login\`."` (backtick/no-tail) replaced with `stderr contains "Not authenticated" and "jr auth login"` + full literal from `src/error.rs::JrError`; stale network cell `"Could not reach <instance>: <reason>"` (colon form) replaced with `stderr contains "Could not reach"` + full literal `Could not reach <host> — check your connection` from `src/error.rs::JrError::NetworkError`; BC-3.9.012 and BC-3.9.013 Trace fields updated with P20-ROUND citation; frontmatter trace v1.3.88 added; spec v1.3.88. Previous update 2026-07-18 (SOH-ATTACHMENTS-1 F3 adversary pass-12 micro-round 1.3.86→1.3.87): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.9.001 403 body text hedged (P12-003): prior unverified "Websudo required" string replaced with XSRF-related-rejection hedge; research file `.factory/research/issue-576-attachments-api-2026-07-15.md` §1e+§P2-1 documents XSRF guard but is SILENT on specific 403 body text; BC-3.9.001 Trace updated with §1e citation + P12-003; frontmatter trace v1.3.87 added; spec v1.3.87. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 F3 adversary pass-3 micro-round 1.3.81→1.3.82): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.9.020 EC-3.9.020-9 added: three-category dry-run taxonomy (pre-flight checks are NOT suppressed by --dry-run; distinct from gates and eligibility guards; P3-007); BC-3.9.010 EC-3.9.010-5 added: all-404 bulk-delete human-mode HINT message `"No attachments deleted (all were already removed or not found)."` to stderr (§3.9 HINT classification, JSON-suppressed; P3-011); BC-3.9.010 and BC-3.9.020 Trace fields updated; frontmatter trace v1.3.82 added; spec v1.3.82. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 closing micro-round 1.3.77→1.3.78): 0 new BCs / 0 new VPs / 0 new holdouts — VP-576-003 assertion (b) reworded (P40-I1); BC-3.9.008 CWE-88/CWE-22 dual-mapping note added at P7-001 definition site (P40-I2); BC-3.9.009 Trace P24-001 appended (INFO-NEW-5); bc-3 frontmatter trace v1.3.78 added; spec v1.3.78. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 adversary pass-36 fix round, P36-002): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.9.015 step 3 clarified: --yes path skips pre-prompt metadata GET (its sole purpose is the prompt filename; DELETE only, per BC-3.9.008; P36-002); BC-3.9.015 Trace updated; BC-INDEX BC-3.9.015 row updated + index_version v6.33; spec v1.3.76. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 adversary pass-33 fix round, P33-001): 0 new BCs / 0 new VPs / 0 new holdouts — footer corrected: "Last updated" advanced to pass-31 (was stale at pass-30); P26/P27/P28 entries inserted between pass-30 and pass-24 (previously omitted from footer sequence; evidence: frontmatter trace v1.3.66/v1.3.67/v1.3.68 confirm bc-3 touched by P26-004/P27-001/P28-001 respectively; P25 and P29 confirmed absent — no frontmatter trace entries and zero body Trace citations; P32 confirmed absent — only touched bc-2-issue-read.md); P33-001; spec v1.3.73. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 adversary pass-31 fix round, P31-003): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.9.012 step-1 carve-out extended: post-retry 401/5xx/network sentence added (a post-retry 401/5xx/network response maps per BC-X.8.010 step 4: 401 → exit 2; 5xx/network → exit 1 — same universal codes as first-occurrence; eliminates "first occurrence" ambiguity; P31-003); BC-3.9.012 Trace updated; BC count unchanged (140/35); VP count 35 (unchanged); spec v1.3.71. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 adversary pass-30 fix round, P30-001..P30-I01): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.9.003 step 1 self-heal sentence added (SEC-576-006/BC-X.8.010: step-1 404/403 triggers invalidate+retry-once before BC-3.9.012 mapping; post-retry exit codes per BC-X.8.010 step 4; P30-001); BC-3.9.012 step-1 carve-out added (BC-X.8.010 self-heal first; post-retry 404→exit 64, 403→exit 1; P30-001); BC-3.9.019 pre-deletion summary classified HINT (JSON-suppressed; count in JSON `"count"` field; EC-2.7.008-6; P30-002); BC-3.9.016 CLI flags `<AID>...` annotated (positional 1+ when used, optional under required selector group, bare `delete` → exit 2; P30-I01); BC count unchanged (140/35); VP count 35 (unchanged); spec v1.3.70. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 adversary pass-28 fix round, P28-001): 0 new BCs / 0 new VPs / 0 new holdouts — EC-3.9.020-8 wire enumeration corrected (P28-001): terminal clause "no HTTP calls beyond step-0 issue GET and meta fetch" replaced — no issue GET fires on the --replace-existing step-0 path (project key derived from issue-key string prefix); only project-meta fetch (`GET /rest/api/3/project/{key}`) fires; no `GET /rest/servicedeskapi/servicedesk` pagination since project is NOT `service_desk`; BC-3.9.020 Trace updated; BC-INDEX.md BC-3.9.020 row updated; BC count unchanged (140/35); VP count 35 (unchanged); spec v1.3.68. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 adversary pass-27 fix round, P27-001): 0 new BCs / 0 new VPs / 0 new holdouts — JSON Output Shape Contracts download-row Notes updated: `filename` = RAW Jira name (pre-sanitization); `path` basename = on-disk name (post-sanitization; post-SHA-1-prefix for batch); single-id row references EC-2.7.007-7 (P27-001); batch row references EC-2.7.008-6 (P27-001); BC count unchanged (140/35); VP count 35 (unchanged); spec v1.3.67. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 adversary pass-26 fix round, P26-004): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.9.019 Source field softened: `parse_age_duration` location TBD (`src/cli/issue/attachments.rs` private helper or `src/duration.rs` pub(crate) sibling, per impact-boundary R3.9a); BC-3.9.019 Trace updated (P26-004); BC count unchanged (140/35); VP count 35 (unchanged); spec v1.3.66. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 adversary pass-24 fix round, P24-001..P24-002): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.9.009 body download-exclusion fix: 'canonical attachment-object JSON shape across all `jr` attachment operations — upload, list, and download' narrowed to 'upload and list operations — upload and list JSON outputs use this shape (download is excluded — it uses the distinct `{"downloaded":[...]}` manifest per the BC-2.7.002 authority clause and BC-2.7.007 EC-2.7.007-7)' (P24-001); VP-576-004 story-allocation annotation added to bc-2-issue-read.md: list half verified at S1 (BC-2.7.002 home); upload-platform-POST half verified at S3 (BC-3.9.009); full cross-path test lands at S3; S3 depends_on S1 for shared curated-serialization plumbing (R3.13 earliest-consumer principle); NOT part of S1 acceptance matrix as a whole; S1 matrix includes only the list half (P24-002); BC count unchanged (140/35); VP count 35 (unchanged); spec v1.3.64. Previous update 2026-07-17 (SOH-ATTACHMENTS-1 adversary pass-23 fix round, P23-001..P23-004): 0 new BCs / 0 new VPs / 0 new holdouts — VP-576-005 explicit servicedesk-list mount (2) added (GET /rest/servicedeskapi/servicedesk, BC-X.8.010 cache-miss GET-2; was vaguely attributed to mount (1) as '+ service desk meta'; mounts renumbered 1→7; wire-completeness ECHO-BREAKER LIST-B enumeration added; P23-001); EC-3.9.020-8 added (--replace-existing --dry-run --public on non-JSM → eligibility guard fires at BC-3.9.017 step 0 before any list GET, exit 64, no preview emitted; P23-002); GATES vs ELIGIBILITY GUARDS distinction sentence added to EC-3.9.020-7 (P23-002); EC-3.9.005-3 extended with dry-run non-suppression cross-ref to EC-3.9.020-8 (P23-002); VP-576-005 story-allocation annotation added (verified in S5 not S3; textual home BC-3.9.017; P23-003); JSON Output Shape Contracts --replace-existing --dry-run row: --public wouldUpload visibility:public note appended per EC-3.9.020-7 (P23-004); BC count unchanged (140/35); VP count 35 (unchanged); spec v1.3.63. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-22 fix round, P22-001..P22-003): 0 new BCs / 0 new VPs / 0 new holdouts — BC-3.9.003 non-interactive exit-64 bullet corrected ('exit 64 before any HTTP' → 'exit 64 before any servicedeskapi call and before any upload POST'; Step-0 issue GET and project-meta resolution already ran; P22-001(a)); BC-3.9.012 non-interactive row trigger corrected ('local' → 'local (after Step-0 issue GET + meta fetch)'; P22-001(b)); mechanical sweep confirmed remaining 'before any HTTP' instances are genuinely pre-HTTP across .factory/ (P22-001(c)); H-NEW-ATTACHMENT-008/010 coherent with corrected phrasing (P22-001(d)); EC-3.9.016-6 reworded: 'proceed to BC-3.9.008' → 'issue the DELETE wire call of BC-3.9.008'; 404 handling per BC-3.9.013 bulk exception (benign skip) added (P22-002); VP count 35 (unchanged); spec v1.3.62. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-21 fix round, P21-001..P21-006): 0 new BCs / 0 new VPs / 1 new holdout — BC-3.9.010 bulk-404 body corrected (benign-skip per EC-3.9.010-4/BC-3.9.013; P21-001); VP-576-005 fixture corrected (plain issue GET removed; strict-mode assertion added; P21-002); BC-3.9.004 branch-(a) wire sequence expanded (BC-X.8.010 servicedesk pagination; P21-004); EC-3.9.004-4 Step-0 suppression added (P21-005); BC-3.9.017 step 4 cross-ref BC-3.9.004 EC-3.9.004-4 (P21-005); VP count 35 (unchanged); spec v1.3.61. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-20 fix round, P20-001..P20-006): 0 new BCs / 2 new VPs / 1 new holdout — BC-3.9.004 Step 0 inheritance + full HTTP sequence for JSM (a) and non-JSM OQ-9 (b) branches (P20-001); BC-3.9.014 N≤3 prompt template `, ...` removed (P20-002); VP-576-005 (combined-gate single-prompt pin) added to BC-3.9.017 (P20-006); VP count 33→35; spec v1.3.60. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-19 fix round, P19-001..I1): 0 new BCs — BC-3.9.001 `--dry-run` CLI-flag annotated with clap-requires constraint (P19-004); BC-3.9.001 4-column upload echo vs 6-column list table note (P19-I1); BC-3.9.009 key-order enumeration updated to BTreeMap-alphabetical (P19-001); spec v1.3.59. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-18 fix round, P18-001..I2): 0 new BCs — upload cancel JSON shape table row label scoped to interactive-only (P18-001); JSON Output Shape Contracts header S1–S5 pending note (P18-I1); spec v1.3.58. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-17 fix round, P17-001..007): 0 new BCs — BC-3.9.014 Source field corrected S5→S3 (P17-001; R3.13); EC-3.9.003-5 extended with Step-0 suppression on --replace-existing --public combined path (P17-003); EC-3.9.017-9 extended with combined --public+≥1-match non-interactive sub-variant B (P17-004a); BC-3.9.014 Non-interactive path section extended with three message variants (P17-004b); BC-3.9.007 EC-3.9.007-1 extended with S3/S5 allocation note (P17-005); upload cancel row added to JSON Output Shape Contracts table (P17-006); spec v1.3.57. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-16 fix round, P16-001..005): 0 new BCs — BC-3.9.003 Step 0 added (issue GET existence validation + projectTypeKey source pinned to get_or_fetch_project_meta NOT issue GET; key-derivation asymmetry note extended; P16-003); BC-3.9.003 Trace updated (P16-003); BC-3.9.015 metadata-fetch-failure clause extended (403 exit 1 + 401 exit 2 + 5xx/network exit 1; all fire before gate presentation; P16-005); BC-3.9.015 Trace updated (P16-005); BC-3.9.014 story allocation moved S5→S3 per ORCHESTRATOR RULING (R3.13; P16-002 — see prd-delta-576.md Scope table); spec v1.3.56. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-15 fix round, P15-001..007+INFO): 0 new BCs — BC-3.9.017 step-2 gate rewrite: ≥1 same-filename match → confirmation gate (P15-002/R3.12); EC-3.9.017-9..12 added (non-interactive exit 64; zero-match gate no-op; combined single-prompt; --yes single-bypass); BC-3.9.014 expanded to THREE consumers with additional prompt variants; EC-3.9.003-5 extended to cover three BC-3.9.017 entry points; EC-3.9.020-7 extended to cover ALL gate consumers; BC-3.9.018 P15-002 zero-match alignment note; VP-576-003 --yes flag rationale updated; spec v1.3.55. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-14 fix round, P14-001..011): 0 new BCs — BC-3.9.003 three-way branch (EOF→exit 130, cancel→stderr) + EC-3.9.003-6/7 (P14-001/P14-002/P14-003); BC-3.9.012 error-row wording (P14-005); BC-3.9.014 EC-3.9.014-2 cancel channel (P14-003); BC-3.9.015 cancel-channel divergence note + VP-576-002 (P14-003/P14-007); BC-3.9.017 VP-576-003 (P14-007); BC-3.9.020 retitled + EC-3.9.020-7 (P14-009/P14-010); double-`---` removed (P14-011); VP count 30→33; spec v1.3.54. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-10 fix round, P10-001): 0 new BCs — BC-3.9.001 Content-Disposition filename clause (basename invariant; P10-001); BC-3.9.017 step 1 cross-ref added; spec v1.3.50. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-9 fix round, P9-002): 0 new BCs — BC-3.9.017 step 0 function citation corrected (`get_or_fetch_project_meta(client, project_key)`, `src/api/jsm/servicedesks.rs:~41`); key-derivation equivalence note added; spec v1.3.49. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-8 fix round, P8-001..P8-005 + changelog sync): 0 new BCs — BC-3.9.017 pre-flight step 0 + destruction invariant generalization (P8-002); BC-3.9.005 --replace-existing pre-flight note + EC-3.9.005-3 (P8-002); BC-3.9.012 400 row + BC-3.9.006 step-2 rationale reworded (P8-003); BC-3.9.020 single-ID AID validation (P8-004); spec v1.3.48. Previous update 2026-07-16 (SOH-ATTACHMENTS-1 adversary pass-7 fix round, P7-001..P7-003 + minor fold-in): 0 new BCs — AID validation reversed across BC-3.9.008/013/015/016/020 (P7-001 CWE-88); EC-3.9.018-4 + EC-3.9.003-5 extension (P7-002 gate suppression); BC-X.8.010 self-heal language softened (minor fold-in); GAP-R17-001 placeholder sync `<AID>`→`<VALUE>` (3 sites); spec v1.3.47. Previous update 2026-07-15 (SOH-ATTACHMENTS-1 adversary pass-1 fix rounds A+B, DEC-179): +6 BCs (BC-3.9.015..020) — delete confirmation gate (BC-3.9.015, DEC-174 mirror), bulk --older-than always-requires-yes + clap mutual-exclusion (BC-3.9.016), --replace-existing non-atomic delete-ALL + race documented (BC-3.9.017, JRACLOUD-96384/-78388), --replace-existing zero-match idempotent (BC-3.9.018), --older-than duration.rs + chrono client-side + bulk JSON (BC-3.9.019), --dry-run preview + JSON + single-ID hint (BC-3.9.020); Section 3.9 now 20 contracts; spec v1.3.45. Previous update 2026-07-15 (SOH-ATTACHMENTS-1 F2, DEC-179, issues #576+#585): +14 BCs (BC-3.9.001..BC-3.9.014) — attachment upload platform POST (BC-3.9.001: multipart, `X-Atlassian-Token: no-check`, streaming, no client-side cap, 413/400 handling), JSM upload no-flag path (BC-3.9.002: platform POST = internal by default, P2-4a), `--public` servicedeskapi two-step + DEC-174 confirmation gate (BC-3.9.003), `--internal` two-step public:false + OQ-9 non-JSM silent no-op (BC-3.9.004), `--public` non-JSM exit 64 (BC-3.9.005), temporaryAttachmentId ~1h TTL + stale-ID self-healing (BC-3.9.006, BC-X.8.010), post-upload echo + P2-3c deferred probe obligation (BC-3.9.007, BC-3.9.011), attachment delete DELETE/id + 404 = exit 64 + surface body (BC-3.9.008, DEC-168 precedent), JSON shapes (BC-3.9.009..010), upload/delete error taxonomies (BC-3.9.012..013), `--public` confirmation gate mechanics eprint!+read_line NOT dialoguer (BC-3.9.014, DEC-174); Section 3.9 header added (14 contracts); spec versions v1.3.43 (BCs) + v1.3.44 (security fix round, SEC-576-001..007). Previous update 2026-07-09 (issue #577 SOH-COMMENT-CRUD-1 F2, DEC-168): +11 BCs (BC-3.5.002..BC-3.5.012) — comment delete (BC-3.5.002..BC-3.5.004: endpoint/exit-codes, confirmation, 404-exit-64+body-surface), comment edit (BC-3.5.005..BC-3.5.009: body-only-PUT invariant, --internal wire, --public wire+always-confirm, --public confirmation gate, body sources), comment view (BC-3.5.010: GET+expand=properties, table+JSON, 404-exit-64), mutual exclusion (BC-3.5.011), CLI breaking change (BC-3.5.012: comment→subcommand group, old flat form → clap error with migration hint); §3.5 header updated to 12 contracts. Previous update 2026-06-30 (BC-subclause-pass F2): +2 BCs (BC-3.4.020..021) — BC-3.4.020 (`issue edit --label` routing fork: single-key PUT bare-string vs 2+ key bulk POST `{"name":...}` objects; BUG-LABEL-400), BC-3.4.021 (`issue edit --dry-run` `plannedChanges` output structure + `--output json` schema `{dryRun, issues, plannedChanges}`; intentionally simplified preview shapes); Section 3.4 header updated to 21 contracts. Previous update 2026-06-08 (fix-bulk-transition-schema F2): +1 BC (BC-3.2.014) — BC-3.2.014 (multi-key bulk move `bulkTransitionInputs` nested wrapper wire schema; documents correctness bug fix commit acca854; live run 27156639337); Section 3.2 header updated to 14 contracts. Previous update 2026-06-03 (jsm-resolution-required F2): +1 BC (BC-3.2.013) — BC-3.2.013 (proactive resolution enforcement on done-category transitions: REQUIRED and OPTIONAL branches, --no-resolution flag, isConditional coverage, conservative gate, BC-3.2.009 backstop retained; single-key only; breaking change); Section 3.2 header updated to 13 contracts. Previous update 2026-06-01 (issue #331 F2): +2 BCs (BC-3.4.018..019) — BC-3.4.018 (multi-key `--type` bulk wire shape: camelCase `issueType` key, `issueTypeId` string value, name resolved via createmeta issuetypes), BC-3.4.019 (cross-project guard: keys spanning >1 project exit 64 before any API call); Section 3.4 header updated to 19 contracts. Previous update 2026-05-27 (issue #421 F2): BC-3.4.015 invariant 5 rewritten (two-stage i64-first strategy); EC-3.4.015-4b added (i64-boundary regression pin); no BC count changes (103/74 unchanged). Previous update (2026-05-25 issue #407 F2): +EC-3.4.017-14 — mechanical enforcement meta-test for BC-3.4.017 invariant 2 (conflict block completeness via `test_label_conflict_block_lists_every_relevant_flag`); BC-3.4.017 invariant 2 cross-reference added; no BC count changes (103/74 unchanged). Previous update (2026-05-22 issue #396 F2): +3 BCs (BC-3.4.015..017) — BC-3.4.015 (`issue edit --field` string/number/date/datetime/user field single-key path, with editmeta validation, fields.json cache, and dry-run invariants), BC-3.4.016 (`issue edit --field` single-select `option` field), BC-3.4.017 (`--field` multi-key/`--jql` rejection Gate A and flag-overlap Gate B); Section 3.4 header updated to 17 contracts. Previous update (2026-05-21 issue #398 F2): +3 BCs (BC-3.4.012..014) — BC-3.4.012 (issue edit table-mode success echo), BC-3.4.013 (issue edit JSON-mode success echo with changed_fields), BC-3.4.014 (issue create table-mode all-fields echo (broadened from team-only at the 2026-05-22 human-gate to mirror BC-3.4.012)); BC-3.4.003 Success output cross-reference added; Section 3.4 header updated to 14 contracts. Previous update (2026-05-20 issue #388): +2 BCs (BC-3.4.010..011): BC-3.4.010 (cross-hierarchy `edit --type` 400 → CROSS_HIERARCHY_HINT citing JRACLOUD-27893) and BC-3.4.011 (same-hierarchy/indeterminate `edit --type` 400 → typo hint or raw error, no JRACLOUD-27893 hint) added in F2 delta (issue #388). BC-3.4.003 Errors cross-reference updated (annotation only, no behavioral change). Section 3.4 header updated to 11 contracts. Previous update (2026-05-20 issue #385): +2 BCs (BC-3.8.016..017); BC-3.8.002/010/011 modified._
