---
context: bc-index
title: "BC Master Index"
total_bcs: 742  # cumulative claim (incl. range-collapsed) — see preamble below; +9 added 2026-09-03 (BC-1.2.052..054 + BC-1.4.035..040, cycle-004 `windows-correctness` F2 spec evolution, issues #759/#760, DEC-334, ADR-0021/ADR-0022 — Windows OAuth secret storage: keyring-first with DPAPI-encrypted-file fallback on `keyring::Error::TooLong` (BC-1.4.035..040: size-safe routing + backend-selection atomicity, DPAPI-aware read path + distinct corrupt-file error, versioned-envelope atomic file write, delete-both-backends, honest-fail `DpapiFallbackFailed` backstop, profile-name-as-filename path-traversal guard); API-token `cloud_id` acquisition via unauthenticated `/_edge/tenant_info` closing A-PA-LOW-001 (BC-1.2.052..054: fallback-chain acquisition, mechanism-switch refresh-not-clear, confirmed-unchanged `base_url()`/`assets_base_url` auth-method gating); BC-1.4.028 amended in place (partial-state error now DPAPI-file-aware, extended not replaced); in bc-1-auth-identity.md, 71→80 cumulative, 60→69 individually-bodied; bc-6-config-cache.md unaffected by this pass — a planned cross-reference amendment to BC-6.2.016 was deferred due to a pre-existing TD-031 stable-anchor hygiene violation in that file blocking edits, unrelated to this cycle's diff; still 44 cumulative/34 individually-bodied). Was 733 before this addition; prior note: +2 added 2026-09-01 (BC-1.1.016 + BC-1.4.034, cycle-003 `auth-profile-dx` F2-gate FIX round, same day as the F2 spec evolution below — BC-1.1.016 closes adversarial finding I-1 (non-interactive OAuth guard for explicit `--oauth` and implicit oauth-method `refresh`); BC-1.4.034 formalizes the one-time re-login breaking-change contract BC-1.4.032's no-copy redesign requires; in bc-1-auth-identity.md, 69→71 cumulative, 58→60 individually-bodied; bc-6-config-cache.md unaffected by this fix round, still 44 cumulative/34 individually-bodied). Same fix round also REDESIGNED BC-1.4.032 (no-copy detect-and-instruct, was copy-then-delete) and BC-1.4.033 (partial-write recovery narrowed to the namespaced-pair case only), and reworded BC-1.2.014 (credentials-before-config-entry ordering) — no count change from these, titles/summaries refreshed in this index. +12 added 2026-09-01 (BC-1.1.013..015 + BC-1.2.048..051 + BC-1.4.031..033 + BC-1.6.047, cycle-003 `auth-profile-dx` F2 spec evolution, DEC-312..325, ADR-0020/ADR-0011 amended — per-profile API-token credential storage (DEC-315), non-destructive `auth logout` + 4-step `auth remove` (DEC-322), OAuth-default-at-creation (DEC-313), `auth refresh` mechanism-override removal (DEC-321), new `--api-token` flag + `--oauth` deprecation (DEC-323), `auth list` ENV column (DEC-324); in bc-1-auth-identity.md, 58→69 cumulative, 47→58 individually-bodied); +1 added 2026-09-01 (BC-6.1.015, cycle-003 `auth-profile-dx` F2 — `ProfileConfig.env: Option<String>` config-schema tag, DEC-314; in bc-6-config-cache.md, 43→44 cumulative, 33→34 individually-bodied); BC-1.1.009/010, BC-1.2.013/014/017, BC-1.4.025/027/029, BC-1.6.046 amended in place (bc-1, per-profile keychain restructuring, no separate count); BC-6.2.015 amended in place (bc-6, ADR-0011 hard-fence un-defer, DEC-317, no separate count); +12 added 2026-08-25 (BC-3.3.010..011 + BC-3.4.026..031 + BC-X.14.001..004, F2 Field DX bundle issues #580/#578; BC-3.3.001, BC-3.4.014, BC-3.4.015, BC-3.4.016, BC-3.4.017, BC-3.8.001, BC-3.8.008, BC-3.8.013 amended in place + BC-3.8.012 REVERSED in place, no separate count — BC-3.8.012's DEC-188 --field-alone platform-path exit-64 guard reversed, DEC-310 (registered 2026-08-26, human-approved at the F2 gate; renumbered from the initially-proposed DEC-307, which was already cycle-001's) recorded the governance decision; BC-3.8.013's guard BEHAVIOR is unaffected by the reversal, but its BC body WAS amended (trigger-scope description + dead combined-error cross-references updated) — corrected here, adversary pass-6 F1; BC-3.4.017's Gate B amended to cover hint-tagged `--field NAME:kind=VALUE` pairs matched on their bare name, new EC-3.4.017-16, closing a contradiction with BC-3.4.029 EC-3.4.029-2 — corrected here, adversary pass-13 F-1); +8 added 2026-08-21 (BC-2.1.023..025 + BC-2.2.033..034 + BC-2.3.041..042 + BC-2.6.052, F2 list-read-ergonomics bundle issues #575/#584/#579/#588; BC-2.1.006/007 amended in place, no separate count); +28 added 2026-08-15 (bc-8-components.md NEW FILE, BC-8.1.001..008/BC-8.2.001..008/BC-8.3.001..007/BC-8.4.001..005, F2 component-management bundle issues #604/#605/#606/#608); +6 added 2026-08-15 (BC-2.1.018..022 + BC-2.3.040, issue #606 F2 `--component` filter + shared Component.id prerequisite; BC-2.1.006/007 amended in place, no separate count); +4 added 2026-08-15 (BC-3.4.022..025, issues #604/#605/#608 F2 `issue create/edit --component`; BC-3.4.012/013/017/020/021 amended in place, no separate count); cross-cutting.md BC-X.10.001 amended in place (resolve_component caller citation), no count change; BC-X.3.006 amended in place 2026-08-14 (S-MUTANTS-SCOPE-1 F2 — Ctrl+C/SIGINT graceful-shutdown BC promoted from thin semport stub to full Behavior/Edge-Cases/Verification-Properties BC ahead of `src/main.rs` entering `.cargo/mutants.toml::examine_globs`; no count change); +1 added 2026-08-13 (BC-1.2.047, issue #663 F2 bucket1-defects bundle — auth switch --profile rejection; BC-1.2.018 amended in place, no count change); +2 added 2026-08-13 (BC-2.2.032 + BC-2.3.039, issue #668 F2 duedate feature; BC-2.2.028 + BC-2.3.036 amended in place, no count change); +4 added 2026-05-08 (BC-7.4.013-016, Fix-PR A); +1 added 2026-05-13 (BC-2.6.050, issue #350); +1 added 2026-05-14 (BC-2.6.051, issue #365); +1 added 2026-05-15 (BC-3.4.009, issue #340 F2); +18 added 2026-05-18 (BC-3.8.001..010 + BC-X.12.001..008, issue #288 F2+F1d); +3 added 2026-05-19 (BC-3.8.011..013, issue #288 F1d + issue #383 F2); +4 added 2026-05-19 (BC-3.8.014..015 + BC-X.8.006..007, issue #384 F2); +2 added 2026-05-20 (BC-3.8.016..017, issue #385 F2); +2 added 2026-05-20 (BC-3.4.010..011, issue #388 F2); +3 added 2026-05-21 (BC-3.4.012..014, issue #398 F2); +3 added 2026-05-22 (BC-3.4.015..017, issue #396 F2); +2 added 2026-06-01 (BC-3.4.018..019, issue #331 F2); +1 added 2026-06-03 (BC-3.2.013, jsm-resolution-required F2); +1 added 2026-06-08 (BC-7.2.006, issue #470 listItem content-model conformance); +2 added 2026-06-08 (BC-X.8.008..009, S-QUEUE-BC-1 queue list/view document-as-is); +1 added 2026-06-08 (BC-3.2.014, fix-bulk-transition-schema bulkTransitionInputs wrapper); +2 added 2026-06-08 (BC-7.2.007..008, issue #474 markdown subsup + heading-attr); +1 added 2026-06-09 (BC-7.2.009, issue #483 GFM alerts → panel); +1 added 2026-06-10 (BC-7.2.010, issue #471 GFM task lists → taskList/taskItem); +3 added 2026-06-12 (BC-6.1.014 + BC-6.2.016..017, windows-build F2); +1 added 2026-06-15 (BC-7.2.011, issue #492 block-HTML hardBreak interior newlines); +1 added 2026-06-17 (BC-2.4.043, Bundle C CR-001 list_comments anti-stall guard); +3 added 2026-06-19 (BC-X.13.001..003, DEAD-CITATION-CI F2 CLAUDE.md citation guard); +1 added 2026-06-24 (BC-7.2.012, SEC-001 ADF recursion depth limit); +2 promoted 2026-06-27 (BC-7.2.013..014, range-collapsed → individually-bodied; issues #472 #473; total_bcs unchanged); +1 added 2026-06-27 (BC-6.2.018, cache warm-hit no-HTTP invariant); +1 added 2026-06-27 (BC-7.3.010, issue #526 json-render invariant + error channel); +3 added 2026-06-30 (BC-3.4.020..021 + BC-5.1.005, BC-subclause-pass F2); BC-6.2.004 modified; BC-1.3.023, BC-3.3.001, BC-X.8.004, BC-3.8.009, BC-X.3.002, BC-3.8.002, BC-3.8.010, BC-3.8.011, BC-3.4.003 modified; +3 added 2026-07-05 (BC-X.13.004..006, CITATION-GUARDS Story B Guard 1 S-BC-CITATION-GUARD-1 issue #102); +1 added 2026-07-07 (BC-7.2.015, issue #571 ADF code-mark exclusivity — push_code emit-site typographic-mark filter); BC-7.2.007 EC-2 modified; +1 added 2026-07-09 (BC-X.1.011, S-SOH-589 jr api --method case-insensitivity); +11 added 2026-07-09 (BC-3.5.002..BC-3.5.012, SOH-COMMENT-CRUD-1 F2 DEC-168 comment delete/edit/view issue #577); +27 added 2026-07-15 (BC-2.7.001..012 + BC-3.9.001..014 + BC-X.8.010, SOH-ATTACHMENTS-1 F2 DEC-179 issues #576 #585); +6 added 2026-07-15 (BC-3.9.015..020, SOH-ATTACHMENTS-1 adversary pass-1 round B, scope expansion ruling R1/R2); +1 added 2026-08-05 (BC-X.13.007, FIX ROUND 12 S-626-1 issue #626 — `test` job runtime test-execution floor / POL-11)
last_updated: 2026-09-03  # F2 spec evolution, cycle-004 `windows-correctness` (issues #759/#760, DEC-334): +9 new BCs in bc-1-auth-identity.md (BC-1.2.052..054 `cloud_id` acquisition/mechanism-switch-refresh/confirmed-unchanged-guard, ADR-0022; BC-1.4.035..040 Windows DPAPI OAuth-secret storage, ADR-0021); BC-1.4.028 amended in place (partial-state error extended to check the DPAPI file). BC count 733→742 (bc-1-auth-identity.md 71→80 cumulative, 60→69 individually-bodied; bc-6-config-cache.md unaffected). BC-INDEX v6.84→v6.85. Spec version v2.0.0→v2.1.0 (MINOR — new requirements per ADR-0021/ADR-0022; no removed/changed existing behavior). See `.factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md`, `.factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md`, `.factory/specs/architecture/decisions/ADR-0022-api-token-cloud-id-acquisition-tenant-info.md`, `.factory/cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md`, `.factory/cycles/cycle-004/phase-f2-spec-evolution/prd-delta.md`. Previous: 2026-09-01  # F2-gate FIX round, cycle-003 `auth-profile-dx` (same day as the F2 spec evolution below): +2 new BCs in bc-1-auth-identity.md (BC-1.1.016 non-interactive OAuth guard for explicit `--oauth`/implicit oauth-method `refresh`, closes I-1; BC-1.4.034 one-time re-login breaking-change contract); BC-1.4.032 REDESIGNED (no-copy detect-and-instruct, was copy-then-delete) and BC-1.4.033 REDESIGNED (partial-write recovery narrowed to namespaced-pair case only) in place; BC-1.2.014 reworded in place (credentials-before-config-entry ordering). BC count 731→733 (bc-1-auth-identity.md 69→71 cumulative, 58→60 individually-bodied; bc-6-config-cache.md unaffected). BC-INDEX v6.83→v6.84. See `.factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md` (as amended 2026-09-01, F2-gate) and ADR-0020 (as amended 2026-09-01, F2-gate). Previous: 2026-09-01  # F2 spec evolution, cycle-003 `auth-profile-dx` bundle (DEC-312..325, ADR-0020, ADR-0011 amended): +12 new BCs in bc-1-auth-identity.md (BC-1.1.013..015, BC-1.2.048..051, BC-1.4.031..033, BC-1.6.047) + 1 new BC in bc-6-config-cache.md (BC-6.1.015); BC-1.1.009/010, BC-1.2.013/014/017, BC-1.4.025/027/029, BC-1.6.046 amended in place (per-profile API-token credential storage DEC-315, non-destructive logout + 4-step remove DEC-322, `auth list` ENV column DEC-324); BC-6.2.015 amended in place (ADR-0011 hard-fence un-defer, DEC-317). BC count 719→731 (bc-1-auth-identity.md 58→69 cumulative, 47→58 individually-bodied; bc-6-config-cache.md 43→44 cumulative, 33→34 individually-bodied). BC-INDEX v6.82→v6.83. See `.factory/cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md`, `.factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`. Cross-reference note: the F1 delta analysis' impact table cites a "BC-1.1.017" that does not exist in bc-1-auth-identity.md; the corresponding contract is BC-1.2.017 (reconciled inline in that BC's body; no STORY-INDEX.md or story file references the incorrect ID, so no further propagation is needed). Previous: 2026-08-25  # F2 spec evolution, Field DX bundle (issues #580/#578): +12 new BCs — BC-3.3.010..011 (`issue create --field` extended to non-JSM platform path via createmeta resolution + error taxonomy, reverses DEC-188's --field-alone guard) in bc-3-issue-write.md; BC-3.4.026..031 (`--field NAME:kind=VALUE` hint-syntax parser + `:option`/`:id`/`:name`/`:asset` semantics + malformed-hint EC catalog) in bc-3-issue-write.md; BC-X.14.001..004 (new "Field Option Discovery" Cross-Cutting subsection — `jr field options <field>`, exactly-one-of-three context mechanisms: createmeta PRIMARY platform, JSM requesttype-fields PRIMARY JSM, editmeta FALLBACK) in cross-cutting.md. BC-3.3.001, BC-3.4.014, BC-3.4.015, BC-3.4.016, BC-3.8.001, BC-3.8.008 amended in place (hint-syntax/non-JSM-create interaction notes, no count change). BC-3.8.012 REVERSED in place — DEC-188's `--field`-alone and combined platform-path exit-64 pre-flight guard removed (DEC-310, registered 2026-08-26, human-approved at the F2 gate, recorded this governance reversal); `[DEC-188 BEHAVIOR, superseded]` retained inline for audit trail; BC-3.8.013 (`--on-behalf-of` guard) is also amended in place — its BC body was updated to reflect BC-3.8.012's combined-guard removal (trigger-scope description + dead combined-error cross-references), while its own guard BEHAVIOR remains unchanged and fully in force (corrected here, adversary pass-6 F1; was previously mislabeled "explicitly UNCHANGED"). BC-3.4.017 (Gate B flag-overlap guard) is also amended in place — its scope note now covers hint-tagged `--field NAME:kind=VALUE` pairs (matched on their bare name per BC-3.4.026's bare-key rule), with new EC-3.4.017-16, closing a contradiction where BC-3.4.029 EC-3.4.029-2 claimed universal last-wins for the identical flag combination; EC-3.4.029-2 is now scoped to the create path only (corrected here, adversary pass-13 F-1). BC count 707→719 (bc-3-issue-write.md 115→123 individually-bodied, 144→152 cumulative; cross-cutting.md 85→89 individually-bodied, 151→155 cumulative). BC-INDEX v6.81→v6.82; spec v1.5.0→v2.0.0 (MAJOR — governance-flagged reversal of DEC-188/DEC-310, a previously-shipped behavioral contract; plus 12 new BCs). Open design questions as of this PO PRD delta, before ADR-0019 resolved them (flagged for architect/adversary at the time): cascading-select `>` delimiter choice (BC-3.4.027) — since CONFIRMED per ADR-0019 §3 "Cascading-select delimiter (BC-3.4.027) — confirm `>`" (Accepted 2026-08-25); JSM `requestFieldValues` cascading wire shape (out of scope this cycle). See `.factory/phase-f2-spec-evolution/prd-delta-field-dx.md`, `.factory/phase-f1-delta-analysis/delta-analysis-field-dx.md`, `.factory/phase-f1-delta-analysis/field-dx-bc-mapping.md`, `.factory/research/field-dx-feasibility-2026-08-25.md`, `.factory/research/field-dx-context-mechanism-2026-08-25.md`. Previous: 2026-08-21  # F2 spec evolution, list-read-ergonomics bundle (issues #575/#584/#579/#588): +8 new BCs in bc-2-issue-read.md — BC-2.2.033 (list `--fields <CSV>`, REPLACE semantics, JSON-only) + BC-2.3.041 (view twin) + BC-2.6.052 (additive client field-override methods) for #575; BC-2.2.034 + BC-2.3.042 (raw ADF for `--fields comment`, confirmatory, zero incremental transformation code) for #584; BC-2.1.023 (`--updated-recent`, reuses `jql::validate_duration`) for #579, with BC-2.1.006 (14→15 filter sources) + BC-2.1.007 (stable-order position) amended in place; BC-2.1.024 (`--sort` syntax parse/validate) + BC-2.1.025 (`--sort` overrides `order_by` in all 4 branches, `key ASC` secondary sort, pass-through field validation) for #588. `--resolved-recent` explicitly deferred, not specified. BC count 699→707 (72→80 individually-bodied in bc-2-issue-read.md). BC-INDEX v6.80→v6.81; spec v1.4.1→v1.5.0 (MINOR — new BCs). See `.factory/phase-f1-delta-analysis/list-read-ergonomics/delta-analysis.md`, `.factory/phase-f2-spec-evolution/list-read-ergonomics/prd-delta.md`. Previous: 2026-08-17  # F5 scoped-adversarial fix round, component-mgmt (`issue list --component` filter): resolves findings F5-A-M1/F5-C-001 (human-adjudicated: UNION) — `MatchResult::ExactMultiple` (case-only duplicate component names, e.g. `Backend`/10001 + `backend`/10005) was underspecified for the read path and, per `partial_match`'s first-match-wins return shape, risked silently unioning to only ONE id and dropping issues tagged with the other duplicate. BC-2.1.018 Postcondition 3 + EC-2.1.018-3 (bare `in (...)` UNION), BC-2.1.019 Postcondition 3 + EC-2.1.019-4 (`not:` OR-EMPTY-group UNION), BC-2.1.021 Postcondition 2 + EC-2.1.021-4 (`all:` parenthesized-OR-term UNION), and BC-2.1.022 (new "ExactMultiple read-path disposition" subsection + EC-2.1.022-3, documenting the deliberate divergence from the mutating path's fail-closed disposition, BC-8.1.008 branch (0)) amended in bc-2-issue-read.md. BC-8.4.005 amended in bc-8-components.md — H1 extended, Behavior corrected to state both caller-specific dispositions explicitly (was ambiguous, implying a single universal "treat as Exact" outcome); new VP-COMPONENT-022. No new BC IDs; BC count unchanged (699). BC-INDEX v6.79→v6.80; spec v1.4.0→v1.4.1 (PATCH — amendment-in-place, no new/removed BCs). Previous: F2 spec evolution, component-management bundle (issues #604/#605/#606/#608): new `bc-8-components.md` (28 BCs, BC-8.1.001..008/BC-8.2.001..008/BC-8.3.001..007/BC-8.4.001..005) added as Section 8; BC-2.1.018..022 + BC-2.3.040 added to bc-2-issue-read.md (`--component` filter + Component.id prerequisite; BC-2.1.006/007 amended in place); BC-3.4.022..025 added to bc-3-issue-write.md (`issue create/edit --component`; BC-3.4.012/013/017/020/021 amended in place); cross-cutting.md BC-X.10.001 amended in place (resolve_component caller citation, no count change). BC-INDEX v6.78→v6.79; spec v1.3.182→v1.4.0 (MINOR — new BCs/section); BC count 661→699. See `.factory/phase-f2-spec-evolution/prd-delta-components.md`, `.factory/phase-f1-delta-analysis/delta-analysis-components.md`. Previous: F2 spec evolution, S-MUTANTS-SCOPE-1 (Feature Mode; CI mutation-scope gap fix, not human-facing feature): BC-X.3.006 amended in place — promoted from thin semport stub (Confidence MEDIUM, no Behavior/Edge Cases/VP sections, stale `src/main.rs:~264` citation) to a fully-specified BC (Confidence HIGH, exact stderr `"\nInterrupted\n"` + exit 130 pinned, EC-1..EC-3, Verification Properties VP-MUTANTS-SCOPE-1-001/002); prepares the BC to be backed by real mutation-testing coverage once `src/main.rs` enters `.cargo/mutants.toml::examine_globs` (F4, not landed by this F2 change); no BC count change (still 661). See `.factory/phase-f2-spec-evolution/S-MUTANTS-SCOPE-1-spec-delta.md`. BC-INDEX v6.77→v6.78; spec v1.3.180→v1.3.181; BC count unchanged (661). Previous: F2 spec evolution, bucket1-defects bundle (issue #663, human-approved 2026-08-13): BC-1.2.047 added (`auth switch --profile <X>` rejected exit 64); BC-1.2.018 amended in place (auth switch carve-out); bc-1-auth-identity.md 57→58 cumulative (46→47 individually-bodied); BC-INDEX v6.76→v6.77; spec v1.3.180; BC count 660→661. Previous: F2 spec evolution (issue #668, duedate feature): BC-2.2.032 + BC-2.3.039 added (issue list --duedate opt-in column; issue view always-on Due Date row); BC-2.2.028 + BC-2.3.036 amended (search_issues/get_issue field lists gain duedate); bc-2-issue-read.md 106→108 cumulative (64→66 individually-bodied); BC-INDEX v6.75→v6.76; spec v1.3.177; BC count 658→660. Previous: RS-001 (REFINEMENT, LOW): "Master traceability:" prose header drops "→ Subject" to match 5-column schema (1 site found and fixed); BC-INDEX v6.74→v6.75; spec v1.3.163; BC count unchanged (657). Previous: AX-002 (REFINEMENT, LOW): Subject column removed from all Section 1 tables (6 subsections, 46 data rows; lossless — **Subject**: fields retained in bc-1-auth-identity.md BC bodies); BC-INDEX v6.73→v6.74; spec v1.3.162; BC count unchanged (657). Previous: SOH-DX-1 DEC-188 v1.3.144 round-46 adversary-pass corrections: F46-001 AC-2+AC-7 would-otherwise-succeed clause + mount_platform_create_stubs MUST; F46-002 both body-range labels reworded "BEFORE…steps 3–5…BEFORE…step 6" (2 sites); F46-003 promotion target fixtures.rs→assertions.rs + mod.rs registration note (replace_all); spec v1.3.144; BC count unchanged (657); BC-INDEX v6.72→v6.73. Previous: SOH-DX-1 DEC-188 v1.3.143 round-45 adversary-pass corrections: F45-001 deliverable (e) gains THIRD stale-parity site tests/issue_create_jsm.rs ~:2373-2374 (false platform-parity + dead "create.rs lines 333-343" citation); F45-002 banner-rewrite obligation extended to FAMILY-level banner ~:2381-2391 (THREE false clauses enumerated); F45-003 README.md holdout row 55→100 + H-NEW-JSM-RT-006 + caveat; spec v1.3.143; BC count unchanged (657); BC-INDEX v6.71→v6.72. Previous: SOH-DX-1 DEC-188 v1.3.142 round-44 adversary-pass corrections: F44-001 false json_error_shape.rs Hygiene premise deleted (both Test Notes); F44-002 "BC-3.8.011 direction"→"BC-3.8.010 + BC-3.8.011 directions" (both sites); F44-003 AC-11 (4) DISCRIMINATING→HYGIENE + "Required assertions" intro; LOW-1 AC-7 bareflagnoequals; LOW-2 "steps 3–5…step 6 excluded terminal" (both sites); spec v1.3.142; BC count unchanged (657); BC-INDEX v6.70→v6.71. Previous: SOH-DX-1 DEC-188 v1.3.141 round-43 adversary-pass corrections: F43-01 AC-11 five discriminators (adds (4) exit 64 + (5) stdout.trim().is_empty()); F43-02 AC-16 .current_dir precondition; Obs "steps 3–5"→"steps 3–6" (both [CURRENT BEHAVIOR] sites); spec v1.3.141; BC count unchanged (657); BC-INDEX v6.69→v6.70. Previous: SOH-DX-1 DEC-188 v1.3.140 round-42 adversary-pass corrections: F42-01 [1.3.139] changelog ### Changed + BC Count fixed; O-1 mode-agnosticism invariant restored to both [CURRENT BEHAVIOR] blocks; O-2 MUST-NOT falsifier softened (non-exhaustively; AC-15 insensitive); spec v1.3.140; BC count unchanged (657); BC-INDEX v6.68→v6.69. Previous: SOH-DX-1 DEC-188 v1.3.139 round-41 adversary-pass corrections: F41-01 AC-13 would-otherwise-succeed upgrade (--project PROJ --type Task --summary "test" added; zero-HTTP NORMATIVE); F41-02 AC-1 REGRESSION PIN "(DISCRIMINATING subtype)" first use + policy note; F41-04 write_profile_config param dir→config_home (both fixture contract sites); spec v1.3.139; BC count unchanged (657); BC-INDEX v6.67→v6.68. Previous: F40-001 REGRESSION PIN added to AC-9/10/11/17/18; AC-19 added to non-vacuity enumeration; F40-002 Definition(unconditional remedy) added to uniform rule; Obs [1.3.133] correction note; spec v1.3.138; BC count unchanged (657); BC-INDEX v6.66→v6.67. Previous: F-1 Removal postcondition uniform rule qualified ("reaches handle_create"); AC-15 exclusion added; F-2 write_profile_config specified in both Test Note Config fixture contracts (tests/common/fixtures.rs; sig write_profile_config(config_home: &Path, base_url: &str); shape tests/issue_create_jsm.rs ~:1959-1966); F-3 EC-3.8.012-10 transitively-falsified sentence; Obs-1 [1.3.136] changelog ### BC Count + ---; Obs-2 frontmatter trace v1.3.114 repositioned; Obs-3 README bc-3 (107)→(111); spec v1.3.137; BC count unchanged (657); BC-INDEX v6.65→v6.66. Previous: v1.3.131 round-33 adversary-pass corrections: F33-1 (MED) AC-3 two single-flag-absence negatives labeled FALSIFIABLE-COARSE; AC-9 !stderr.contains("Project key") labeled DISCRIMINATING (guard fires step 2 before project-key resolution step 3; --project NOT required); F33-2 (MED) AC-10 invocation completed to would-otherwise-succeed (--project PROJ --type Task --summary "test" --field a=b --output json + mount_platform_create_stubs; stdout.trim().is_empty() now genuinely DISCRIMINATING); pairing note updated to "symmetric twins for would-otherwise-succeed invocation class"; F33-3 (LOW) AC-10 TempDir precondition added; F33-4 (LOW) BC-3.8.013 Trace AC-8 invocation (ii) zero-HTTP pin note; F33-5 (LOW) AC-7 example value bare-name-no-equals → bareflagnoequals; spec v1.3.131; BC count unchanged (657); BC-INDEX v6.59→v6.60. Previous: v1.3.130 round-32 adversary-pass corrections: F32-1 (MED) EC-3.8.012-10 added (guard project-type-agnostic); F32-2 (MED) stdout.trim().is_empty() DISCRIMINATING in AC-2/7/10; F32-3 (MED) AC-16 REGRESSION PIN + BC-3.8.013 Removal postcondition extended; O-1 jsm_create.rs comment obligation; O-2 BC-3.8.012+013 "BEFORE project-key resolution" added; spec v1.3.130; BC count unchanged (657); BC-INDEX v6.58→v6.59. Previous: v1.3.129 round-31 adversary-pass corrections: F31-1 (HIGH) BC-3.3.001 H1+row 274 retitled (stale {"key":"FOO-123"} → follow-up-GET shape); F31-2 (MED) AC-8 normative received_requests assertion added + (d) relabeled DEFENSE-IN-DEPTH; LOW SSOT step 7 reword; spec v1.3.129; BC count unchanged (657); BC-INDEX v6.57→v6.58. Previous: v1.3.128 round-30 adversary-pass corrections: F30-1 (MED) AC-11 rationale corrected (dialoguer short-circuits on non-TTY; discriminator (2) rewritten as ERROR-absence proof; "fires BEFORE interactive prompt" deleted; Non-goal + purpose statement added); Obs AC-12 coupling note; spec v1.3.128; BC count unchanged (657); BC-INDEX v6.56→v6.57. Previous: v1.3.127 round-29 adversary-pass corrections: F-1 (HIGH) AC-20+AC-21 raiseOnBehalfOf BC-3.8.007→BC-3.8.009; F-2 (MED) cwd precondition propagated to AC-11+AC-17 (find_project_config ancestor walk); Obs-1 BC-3.8.013 "(at most one occurrence)"→"(repeats accepted by clap, last-wins; contract keys on is_some())"; Obs-2 BC-3.8.013 Asymmetry rationale gains error-string completeness note (create-then-edit omission deliberate); spec v1.3.127; BC count unchanged (657); BC-INDEX v6.55→v6.56. Previous: v1.3.126 round-28 adversary-pass corrections: F-1 AC-1 FULL-STRING pin Rust-literal note; F-2 BC-3.8.012+013 MUST-NOT clap-requires directive; F-3 AC-1 renderer cite extended; F-4 AC-5 anchor rationale corrected; F-5 SSOT anchor ~:2971→~:2980; Obs AC-4 follow-up-GET note; spec v1.3.126; BC count unchanged (657); BC-INDEX v6.54→v6.55. Previous: v1.3.125 round-27 adversary-pass corrections: F-27-01 AC-17 DISCRIMINATING→HYGIENE on !stderr.contains("cannot be combined with") + real discriminating pair; F-27-02 AC-8 Mock ResponseTemplate note; LOW ~:3047/~:3132 helper cite rephrased; spec v1.3.125; BC count unchanged (657); BC-INDEX v6.53→v6.54. Previous: v1.3.124 round-26 adversary-pass corrections: F-1 AC-1/AC-3/AC-16 full-string pins (single-source per verbatim error string); LOW-2 "Error: " prefix single-source note in AC-1; F-2 AC-8 two sub-invocations each against separate isolated MockServer (invocation (i) --field a=b BC-3.8.012 prefix; invocation (ii) --on-behalf-of X BC-3.8.013 prefix; same expect(0) mock set); F-3 delivery item (d) --on-behalf-of first doc line "another user"→"this accountId"; LOW-1 BC-3.4.014 line 1122→~:1122 (TD-031); LOW-3 AC-2/AC-7 assert_json_error_envelope note (shape only — contains-assertion at call site); spec v1.3.124; BC count unchanged (657); BC-INDEX v6.52→v6.53. Previous: v1.3.123 round-25 adversary-pass corrections: F25-01 AC-5 DELETE mandate adds 3-field invocation (~:2712-2717); invocation (i) "(MUST be exactly one --field)"; F25-02+F25-03 3-tier taxonomy rule (DISCRIMINATING/FALSIFIABLE-COARSE/HYGIENE); AC-6/AC-20 combined-string HYGIENE→FALSIFIABLE-COARSE; AC-13 FALSIFIABLE-COARSE; AC-14 DISCRIMINATING; AC-15 HYGIENE; AC-16 FALSIFIABLE-COARSE; AC-17 DISCRIMINATING; F25-04 BC-3.3.001 Behavior stale {"key":"FOO-123"} corrected; LOW-1 AC-2/AC-7 KEPT shorthand note; LOW-2 preamble 002..011→002..011 and 014..017; spec v1.3.123; BC count unchanged (657); BC-INDEX v6.51→v6.52. Previous: v1.3.122 round-24: F24-01 KEPT clauses deleted from AC-18/AC-19; F24-02 AC-4 invocation + KEPT + story deliverable; AC-6 KEPT + story deliverable; F24-03 SSOT header "guard-relevant ordering (authoritative for step numbering)"; completeness caveat; AC namespace note updated; LOW-1 fourth ADR-0014 site; LOW-2 fourth stub named in AC-20/AC-21; spec v1.3.122; BC count unchanged (657); BC-INDEX v6.50→v6.51. Previous: v1.3.121 round-23: F23-01 index_version field repaired v6.45→v6.50; F23-03 AC-8 anchor refresh; F23-04 pub fn qualifier; F23-02 README.md 603→657 + provenance note; spec v1.3.121; BC count unchanged (657); BC-INDEX v6.49→v6.50. Previous: v1.3.120 round-22: in-round residual AC-20 RT name "password-reset"→"Password Reset" (fixture ~:135); KEPT clauses exclusion-form rewrite AC-1/2/3/5/7/18/19; AC-1 notes: presence-only guard + --no-input deliberate; AC-2: no line-range anchor; EC-3.8.012-2: whitespace-only variant; spec v1.3.120; BC count unchanged (657); BC-INDEX v6.49. Previous: v1.3.119 round-21: F21-01 AC-20/21 --project HELP --summary "test"; F21-02 real stub trio named; F21-03 AC-5 DISCRIMINATING NEGATIVE; F21-04 AC-2/AC-7 KEPT clauses; LOW-1 SSOT caveat; LOW-2 AC-8 precondition; spec v1.3.119; BC count unchanged (657); BC-INDEX v6.48. Previous: v1.3.118 round-20: F20-1+F20-2(a) AC-1/3/5/18/19 complete invocations + mount_platform_create_stubs KEPT + falsifiability rationale; F20-2(b) AC-9 HYGIENE; F20-2(c) AC-11 HYGIENE; F20-2(d) AC-8 mock relabeling (DISCRIMINATING/DEFENSE-IN-DEPTH) + HYGIENE; F20-4 AC-8 call-site corrected; F20-5 EC-3.8.013-2 added; spec v1.3.118; BC count unchanged (657); BC-INDEX v6.47. Previous: v1.3.117 round-19: F-1 AC-21 NEW JSM combined non-mis-fire + namespace note AC-1..20→AC-1..21 + SSOT pointer + falsifiability rule + BC-3.8.013 Trace range updated; F-2 five ':3036' cites → section-form; F-3 --output json removal mandates AC-1/3/5; F-5 AC-17 negatives rescoped; spec v1.3.117; BC count unchanged (657); BC-INDEX v6.46. Previous: v1.3.116 round-18: F18-001 AC-2/4/6 NORMATIVE DELETE mandates for vacuous negatives (~:2551/~:2671/~:2675/~:2799); F18-002 AC-4 third negative (combined-error string); F18-003 AC-20 NEW JSM non-mis-fire pin + namespace note AC-1..19→AC-1..20 + BC-3.8.013 Trace updated; LOW-1 preamble 001..011→002..011; spec v1.3.116; BC count unchanged (657); BC-INDEX v6.45.
index_version: v6.85
source_pass: 3
sections:
  - bc-1-auth-identity.md (80 BCs cumulative; 69 individually-bodied)
  - bc-2-issue-read.md (122 BCs cumulative; 80 individually-bodied)
  - bc-3-issue-write.md (152 BCs cumulative; 123 individually-bodied)
  - bc-4-assets-cmdb.md (32 BCs cumulative; 22 individually-bodied)
  - bc-5-boards-sprints.md (36 BCs cumulative; 18 individually-bodied)
  - bc-6-config-cache.md (44 BCs cumulative; 34 individually-bodied)
  - bc-7-output-render.md (93 BCs cumulative; 49 individually-bodied)
  - bc-8-components.md (28 BCs cumulative; 28 individually-bodied)
  - cross-cutting.md (155 BCs cumulative; 89 individually-bodied)
  - nfr-catalog.md (42 NFR items, not counted in BC total; NFR-O-K merged into NFR-S-D per ADV-P7-002)
---

# BC Master Index — jira-cli L3 PRD

Master traceability: L3 BC ID → L2 entity → Pass 3 BC ID → Source code → Confidence

---

## Preamble: Ranged vs. Anchored BCs

**Two kinds of BC entries exist in this index:**

1. **Individually-anchored** — has a `#### BC-S.SS.NNN:` heading in the corresponding body file. Can be directly linked. Test names should be `test_BC_S_SS_NNN_<description>`.
2. **Range-collapsed** — a single index row covers multiple BCs that were clustered in Pass 3 but not individually expanded to body headings. Marked with `[range-collapsed]`. They are counted in `total_bcs` (cumulative claim) but do not have individually-bodied `#### BC-` headings.

**Source of truth**: The body files (`bc-*.md`, `cross-cutting.md`) are canonical. This index is derived from them. When a body file and this index disagree on a BC ID or title, the body file wins.

**Counting**: `total_bcs` in each file's frontmatter = cumulative claim (individually-bodied + range-collapsed). `definitional_count` = count of `#### BC-` headings in that file only.

---

## Index Format

```
| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence |
```

Pass 3 BC ID refers to the originating BC number in the semport pass files.
R1/R4 prefix = deepening round that introduced it.
`[range-collapsed]` = BC exists in cumulative count but not individually-bodied in the file.

---

## Section 1: Auth & Identity (bc-1-auth-identity.md) — 80 BCs cumulative; 69 individually-bodied [BC-1.2.052..054 + BC-1.4.035..040 added 2026-09-03 cycle-004 `windows-correctness` F2 spec evolution, issues #759/#760, DEC-334, ADR-0021/ADR-0022 — Windows OAuth DPAPI-fallback secret storage + API-token `cloud_id` acquisition closing A-PA-LOW-001; BC-1.4.028 amended in place (DPAPI-file-aware partial-state extension); BC-1.1.016 + BC-1.4.034 added 2026-09-01 cycle-003 `auth-profile-dx` F2-gate FIX round (same day, closes adversarial finding I-1 + formalizes BC-1.4.032's breaking-change contract); BC-1.4.032/033 REDESIGNED, BC-1.2.014 reworded in place; BC-1.1.013..015 + BC-1.2.048..051 + BC-1.4.031..033 + BC-1.6.047 added 2026-09-01 cycle-003 `auth-profile-dx` F2 spec evolution, DEC-312..325, ADR-0020/ADR-0011 amended; BC-1.1.009/010, BC-1.2.013/014/017, BC-1.4.025/027/029, BC-1.6.046 amended in place]

### 1.1 OAuth Flow & Profile Resolution (16 BCs: BC-1.1.001..016) [BC-1.1.016 added 2026-09-01 cycle-003 `auth-profile-dx` F2-gate FIX round — non-interactive OAuth guard for explicit `--oauth` and implicit oauth-method `refresh`, closes I-1; BC-1.1.013..015 added 2026-09-01 cycle-003 `auth-profile-dx` F2 — OAuth-default-at-creation + non-interactive regression pins + runtime-default-unchanged pin, DEC-313]

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence |
|---|---|---|---|---|
| BC-1.1.001 | `auth list` against fresh-install returns empty JSON array | BC-001 | tests/auth_profiles.rs:~53-60 | HIGH |
| BC-1.1.002 | `auth status` against fresh install exits 0 with helpful stderr | BC-002 | tests/auth_profiles.rs:~62-75 | HIGH |
| BC-1.1.003 | `auth switch <unknown>` exits 64 | BC-003 | tests/auth_profiles.rs:~42-50 | HIGH |
| BC-1.1.004 | `auth status --profile <unknown>` exits 64 with "unknown profile" | BC-004 | tests/auth_profiles.rs:~78-96 | HIGH |
| BC-1.1.005 | `auth logout --profile <unknown>` exits 64 | BC-005 | tests/auth_profiles.rs:~98-118 | HIGH |
| BC-1.1.006 | `auth remove <active>` is rejected with exit 64 | BC-006 | tests/auth_profiles.rs:~120-140 | HIGH |
| BC-1.1.007 | Profile resolution precedence: flag > JR_PROFILE env > config.default_profile > "default" | BC-007 | tests/auth_profiles.rs:~142-186; src/config.rs:~95-110 | HIGH |
| BC-1.1.008 | Global `--profile` flag propagates to `auth status` via main.rs composition | BC-008 | tests/auth_profiles.rs:~193-231 | HIGH |
| BC-1.1.009 | `auth login --profile <new>` creates profile even when profile doesn't yet exist [AMENDED 2026-09-01 cycle-003 — Effects clause now describes per-profile-namespaced keychain writes, DEC-315] | BC-009 | tests/auth_profiles.rs:~241-280 | HIGH |
| BC-1.1.010 | `auth login --profile X` succeeds even when JR_PROFILE points to absent profile [AMENDED 2026-09-01 cycle-003 — Effects clause clarifies per-profile-namespaced credential writes, DEC-315] | BC-010 | tests/auth_profiles.rs:~290-332 | HIGH |
| BC-1.1.011 | `auth refresh --no-input` against unconfigured profile exits 64 naming "no URL configured" | BC-011 | tests/auth_refresh.rs:~43-106 | HIGH |
| BC-1.1.012 | Malformed config TOML errors exit 78 and does NOT overwrite the file | BC-012; BC-1139 (R4) | tests/auth_login_config_errors.rs:~18-97 | HIGH |
| BC-1.1.013 | `auth login` bare and interactive defaults to OAuth, mirroring `jr init`'s picker (`.default(0)`) [NEW 2026-09-01 cycle-003, DEC-313] | — | ADR-0020 §Decision 5; src/cli/auth/login.rs::handle_login (F4 target) | HIGH |
| BC-1.1.014 | `auth login` in non-interactive mode always selects API-token and never launches a browser (regression-safety pin) [NEW 2026-09-01 cycle-003, DEC-313] | — | ADR-0020 §Decision 5; src/cli/auth/login.rs::handle_login (F4 target) | HIGH |
| BC-1.1.015 | `JiraClient::from_config`'s `.unwrap_or("api_token")` runtime default for an unset `auth_method` is unchanged (regression pin) [NEW 2026-09-01 cycle-003, DEC-313] | — | ADR-0020 §Decision 5; src/api/client.rs::JiraClient::from_config | HIGH |
| BC-1.1.016 | Non-interactive OAuth guard fails fast for explicit `--oauth` and implicit oauth-method `refresh` — never just the no-flag default; exits 64 before any listener/browser code is reached [NEW 2026-09-01 cycle-003 F2-gate FIX round, closes adversarial finding I-1] | — | ADR-0020 §Decision 8; architecture-delta §2.3; src/cli/auth/login.rs::handle_login, src/cli/auth/refresh.rs::refresh_credentials (F4 targets) | HIGH |

### 1.2 Profile Lifecycle Management (14 BCs: BC-1.2.013..018, BC-1.2.047..054) [BC-1.2.052..054 added 2026-09-03 cycle-004 `windows-correctness` F2 — API-token `cloud_id` acquisition via `/_edge/tenant_info`, mechanism-switch refresh-not-clear, confirmed-unchanged `base_url()`/`assets_base_url` auth-method gating, DEC-334/ADR-0022, closes A-PA-LOW-001; BC-1.2.048..051 added 2026-09-01 cycle-003 `auth-profile-dx` F2 — no-per-command-auth-switch invariant, `--oauth` deprecation, new `--api-token` flag, `auth refresh` override removal, DEC-313/321/323]

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence |
|---|---|---|---|---|
| BC-1.2.013 | `auth logout` is a non-destructive, OAuth-session-clear-only operation — preserves the profile entry and all non-OAuth-session credentials [AMENDED 2026-09-01 cycle-003, DEC-322] | BC-013-R | src/api/auth.rs:~24-32, 88-97 | HIGH |
| BC-1.2.014 | `auth remove <name>` performs four-step delete, credentials before config entry: OAuth tokens, API-token credential pair, cache directory, config entry [AMENDED 2026-09-01 cycle-003 F2-gate FIX round — steps reordered so credential deletion happens BEFORE config-entry removal, SR-008/I-4; genuine keychain errors now surfaced, not swallowed; DEC-315/DEC-322] | BC-014-R | src/cli/auth.rs; src/cache.rs:~82-88 | HIGH |
| BC-1.2.015 | `auth refresh --help` includes the `--oauth` flag | BC-026 (R1) | tests/auth_refresh.rs:~7-24 | HIGH |
| BC-1.2.016 | `auth refresh --oauth --help` is accepted in either flag order | BC-027 (R1) | tests/auth_refresh.rs:~26-40 | HIGH |
| BC-1.2.017 | `auth login --profile X` against `JR_PROFILE=ghost` succeeds creating profile X [AMENDED 2026-09-01 cycle-003 — Effects clause clarifies per-profile-namespaced credential writes, DEC-315] | BC-029 (R1) | tests/auth_profiles.rs:~282-333 | HIGH |
| BC-1.2.018 | Global `--profile` propagates to all auth subcommands EXCEPT `auth switch` (rejected, exit 64) — `subcmd.profile.or(cli.profile)` for Login/Status/Refresh/Logout, direct pass-through for List/Remove [AMENDED 2026-08-13 issue #663] | BC-030 (R1) | tests/auth_profiles.rs:~188-231 | HIGH |
| BC-1.2.047 | `auth switch --profile <X>` is rejected with exit 64 — the switch target is the positional `<NAME>` only [NEW 2026-08-13 issue #663] | — | src/main.rs (AuthCommand::Switch guard) | HIGH |
| BC-1.2.048 | Once `auth_method` is set at profile creation, no per-command flag changes which mechanism an invocation uses (general "no per-command auth switch" invariant) [NEW 2026-09-01 cycle-003, DEC-313] | — | ADR-0020 §Decision 5/§6 | HIGH |
| BC-1.2.049 | `--oauth` on `auth login`/`auth refresh` is retained as a deprecated-but-accepted alias with a stderr-only deprecation notice (never emitted in `--output json`) [NEW 2026-09-01 cycle-003, DEC-313/323] | — | ADR-0020 §Decision 5; DEC-323 | HIGH |
| BC-1.2.050 | `auth login`/`auth refresh` gain an explicit `--api-token` flag, symmetric with (and mutually exclusive with) `--oauth` [NEW 2026-09-01 cycle-003, DEC-323] | — | ADR-0020 §Decision 5; DEC-323 | HIGH |
| BC-1.2.051 | `auth refresh --oauth`/`--api-token` no longer override the profile's stored `auth_method` — refresh always follows the intrinsic mechanism (breaking change) [NEW 2026-09-01 cycle-003, DEC-321] | — | ADR-0020 §Decision 6; src/cli/auth/mod.rs::chosen_flow_for_profile (F4 target) | HIGH |
| BC-1.2.052 | `auth login`/`jr init`'s API-token path acquires `cloud_id` via `--cloud-id` override, else an unauthenticated `/_edge/tenant_info` fetch, else soft-fail [NEW 2026-09-03 cycle-004, DEC-334, issue #760] | — | ADR-0022 §1/§2; src/api/jira/tenant.rs (F4 target) | HIGH |
| BC-1.2.053 | An oauth→api_token mechanism switch REFRESHES `cloud_id` on fetch success and PRESERVES the prior value on fetch failure — never a bare clear [NEW 2026-09-03 cycle-004, DEC-334, A-PA-LOW-001] | — | ADR-0022 §3; src/cli/auth/login.rs::handle_login (F4 target) | HIGH |
| BC-1.2.054 | `Config::base_url()`'s OAuth-only gateway guard and `assets_base_url`'s un-gated computation are CONFIRMED-CORRECT, pre-existing invariants — no new code required for this half of A-PA-LOW-001 [NEW 2026-09-03 cycle-004, DEC-334, documents existing behavior] | — | ADR-0022 §4; src/config.rs::Config::base_url | HIGH |

### 1.3 Embedded OAuth App (6 BCs: BC-1.3.019..024)

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence |
|---|---|---|---|---|
| BC-1.3.019 | Embedded OAuth app `Debug` redacts client_secret | BC-019; BC-1168 (R4) | src/api/auth_embedded.rs:~34, 220-239 | HIGH |
| BC-1.3.020 | Build with empty XOR inputs → `embedded_oauth_app()` returns None | BC-020 | src/api/auth_embedded.rs:~100-106 | HIGH |
| BC-1.3.021 | `embedded_oauth_app_present()` checks presence without decoding | BC-021; BC-022-R (R1) | src/api/auth_embedded.rs:~132-136 | HIGH |
| BC-1.3.022 | `OAuthAppSource` resolution chain: Flag > Env > Keychain > Embedded > Prompt > None | BC-022-R | src/api/auth_embedded.rs:~46-57 | HIGH |
| BC-1.3.023 | DEFAULT_OAUTH_SCOPES includes `offline_access`, CMDB scopes, `write:jira-work`, and `write:servicedesk-request` [UPDATED 2026-05-18 issue #288] | BC-035 (R1) | src/api/auth.rs:~34-63 (line 59) | HIGH |
| BC-1.3.024 | Embedded OAuth integration test is `#[ignore]`-gated and stubs `unimplemented!()` | BC-028 (R1) | tests/oauth_embedded_login.rs:~13-32 | HIGH |

### 1.4 Token Keychain Layout (16 BCs: BC-1.4.025..040) [BC-1.4.035..040 added 2026-09-03 cycle-004 `windows-correctness` F2 — Windows OAuth secret storage: keyring-first with DPAPI-encrypted-file fallback on `keyring::Error::TooLong`, DEC-334/ADR-0021, issue #759; BC-1.4.028 amended in place same pass (partial-state error extended to check the DPAPI file); BC-1.4.034 added 2026-09-01 cycle-003 `auth-profile-dx` F2-gate FIX round — one-time re-login breaking-change contract for BC-1.4.032; BC-1.4.032/033 REDESIGNED in place same round (no-copy detect-and-instruct model, DEC-315); BC-1.4.031..033 added 2026-09-01 cycle-003 `auth-profile-dx` F2 — per-profile API-token keychain functions, one-time lazy migration, partial-state handling, DEC-315]

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence |
|---|---|---|---|---|
| BC-1.4.025 | `default` profile lazy-migrates legacy flat OAuth keys; non-default profiles never inherit [AMENDED 2026-09-01 cycle-003 — regression-confirmation clause: unchanged by this cycle] | BC-023-R | src/api/auth.rs:~111-169 | HIGH |
| BC-1.4.026 | `refresh_oauth_token` signature is `(profile: &str)` only — resolves credentials internally | BC-024-R | src/api/auth.rs:~700-770; CLAUDE.md | HIGH |
| BC-1.4.027 | Per-profile keychain keys: `<profile>:oauth-access-token` / `<profile>:oauth-refresh-token`; `<profile>:email` / `<profile>:api-token` [AMENDED 2026-09-01 cycle-003 — email/api-token now also namespaced per-profile, DEC-315; only `oauth_client_id`/`oauth_client_secret` remain shared/flat] | BC-1153 (R4) | src/api/auth.rs:~24-32 | HIGH |
| BC-1.4.028 | `load_oauth_tokens` errors on PARTIAL state (one token present, other missing) — now preceded by a DPAPI-file check before erroring [AMENDED 2026-09-03 cycle-004, DEC-334, ADR-0021 §4] | BC-1156 (R4) | src/api/auth.rs:~1249-1269 | HIGH |
| BC-1.4.029 | `load_oauth_tokens("sandbox")` does NOT inherit legacy flat keys [AMENDED 2026-09-01 cycle-003 — cross-reference added confirming the identical non-inheritance guarantee for `load_api_token`] | BC-1158 (R4) | src/api/auth.rs:~1323-1341 | HIGH |
| BC-1.4.030 | `resolve_refresh_app_credentials` prefers KEYCHAIN over EMBEDDED | BC-1159 (R4) | src/api/auth.rs:~1347-1357 | HIGH |
| BC-1.4.031 | Per-profile API-token keychain storage: `store_api_token(profile, …)` / `load_api_token(profile)`, symmetric with the OAuth pair [NEW 2026-09-01 cycle-003, DEC-315] | — | ADR-0020 §Decision 1; src/api/auth.rs (F4 target) | HIGH |
| BC-1.4.032 | Legacy shared flat `email`/`api-token` keys are NEVER auto-migrated — `load_api_token` detects-and-instructs, never copies [REDESIGNED 2026-09-01 cycle-003 F2-gate FIX round — was copy-then-delete; now a HUMAN DECISION no-copy model, DEC-315/ADR-0020 §Decision 2a] | — | ADR-0020 §Decision 2 (as amended); src/api/auth.rs::load_api_token (F4 target) | HIGH |
| BC-1.4.033 | Partial-write recovery for the per-profile API-token pair — namespaced-pair case only, legacy-partial branch removed [REDESIGNED 2026-09-01 cycle-003 F2-gate FIX round — narrowed from the original 2×2 namespaced/legacy matrix to the single namespaced-pair axis, since BC-1.4.032's no-copy redesign removes the copy step there is no longer a legacy-partial state to interrupt; DEC-315/ADR-0020 §Decision 2a] | — | ADR-0020 §Decision 2 item 4 (as amended); src/api/auth.rs::load_api_token partial-state pattern | HIGH |
| BC-1.4.034 | One-time `jr auth login <profile>` re-login is a mandatory, breaking upgrade step for every pre-cycle-003 api-token profile [NEW 2026-09-01 cycle-003 F2-gate FIX round — formalizes the breaking-change contract BC-1.4.032's no-copy redesign requires; F4 CHANGELOG doc-fallout obligation] | — | ADR-0020 §Decision 2 ("one-time, clearly-communicated BREAKING CHANGE"); DEC-315 | HIGH |
| BC-1.4.035 | Keyring-first OAuth token storage with DPAPI-encrypted-file fallback on `keyring::Error::TooLong` (Windows only); backend-selection-level atomicity + rollback [NEW 2026-09-03 cycle-004, DEC-334, ADR-0021 §1/§2, issue #759] | — | ADR-0021 §1/§2; src/api/auth.rs::store_oauth_tokens (F4 target) | HIGH |
| BC-1.4.036 | OAuth token load path checks the DPAPI-encrypted file when both namespaced keyring keys are absent; a corrupt file yields a distinct force-re-login error [NEW 2026-09-03 cycle-004, DEC-334, ADR-0021 §4] | — | ADR-0021 §4; src/api/auth.rs::load_oauth_tokens (F4 target) | HIGH |
| BC-1.4.037 | DPAPI-encrypted-file store: versioned envelope + atomic temp-write-fsync-and-rename; sole `unsafe` FFI surface in the module tree [NEW 2026-09-03 cycle-004, DEC-334, ADR-0021 §3] | — | ADR-0021 §3; src/api/auth_windows_store.rs (NEW, F4 target) | HIGH |
| BC-1.4.038 | `clear_profile_oauth_pair`/`clear_profile_creds` delete BOTH the keyring pair AND the DPAPI file [NEW 2026-09-03 cycle-004, DEC-334, ADR-0021 §7] | — | ADR-0021 §7; src/api/auth.rs::clear_profile_oauth_pair, ::clear_profile_creds (F4 targets) | HIGH |
| BC-1.4.039 | Honest-fail backstop — `DpapiFallbackFailed` replaces "Unlock your keychain" only when the DPAPI fallback itself fails [NEW 2026-09-03 cycle-004, DEC-334, ADR-0021 §6] | — | ADR-0021 §6; src/api/auth.rs::oauth_login, ::refresh_oauth_token_with_url (F4 targets) | HIGH |
| BC-1.4.040 | The DPAPI secret file's path is derived from the profile name with path-traversal / invalid-component rejection before any write, read, or delete [NEW 2026-09-03 cycle-004, DEC-334 — hardening requirement escalated from an inherited cache-dir precedent] | — | architecture-delta.md §9 item 1; src/profile.rs (Profile::from(String)); src/cache.rs::cache_dir (precedent) | MEDIUM |

### 1.5 OAuth State Machine (11 BCs: BC-1.5.031..041)

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence |
|---|---|---|---|---|
| BC-1.5.031 | Embedded OAuth callback URL is exactly `http://127.0.0.1:53682/callback` | BC-031 (R1); BC-1140/1141 (R4) | src/api/auth.rs:~374-477; ADR-0006 | HIGH |
| BC-1.5.032 | `RedirectUriStrategyRequest::Fixed(p)` produces EADDRINUSE friendly error | BC-032 (R1); BC-1161 (R4) | src/api/auth.rs:~427-447 | HIGH |
| BC-1.5.033 | `ResolvedRedirect` private fields prevent listener detachment from strategy | BC-033 (R1) | src/api/auth.rs:~455-477 | HIGH |
| BC-1.5.034 | BYO OAuth uses `DynamicPort` (dynamic `:0`); embedded uses `FixedPort(53682)` | BC-1140 (R4) | src/api/auth.rs:~927-937 | HIGH |
| BC-1.5.035 | `generate_state()` produces 32 bytes from SysRng encoded as 64 hex chars | BC-1146 (R4) | src/api/auth.rs:~882 | HIGH |
| BC-1.5.036 | OAuth flow has NO PKCE (`code_challenge`/`code_verifier` absent) | BC-1148, BC-1149 (R4) | src/api/auth.rs:~608-616 | HIGH |
| BC-1.5.037 | `build_authorize_url` percent-encodes hostile `client_id` containing injection chars | BC-1149 (R4) | src/api/auth.rs:~1043-1060 | HIGH |
| BC-1.5.038 | `accessible_resources` first-wins for cloud_id discovery (silent first-only) | BC-1176 (R4) | src/api/auth.rs | HIGH |
| BC-1.5.039 | OAuth token stored as `<profile>:oauth-access-token` and `<profile>:oauth-refresh-token` post-login | BC-1151 (R4) | src/api/auth.rs | HIGH |
| BC-1.5.040 | OAuth callback validates state (CSRF check) before token exchange | H-047 (holdout) | src/api/auth.rs:~898 | HIGH |
| BC-1.5.041 | `extract_query_param` parses `code` and `state` from HTTP GET request line | BC-1142, BC-1143, BC-1144 (R4) | src/api/auth.rs:~948-965 | HIGH |

### 1.6 Auth Error Handling & 401 Dispatch (6 BCs: BC-1.6.042..047) [BC-1.6.047 added 2026-09-01 cycle-003 `auth-profile-dx` F2 — `env` tag JSON-shape contract, DEC-314/324]

| L3 BC ID | Summary | Pass 3 BC ID | Source code | Confidence |
|---|---|---|---|---|
| BC-1.6.042 | 401 + `scope does not match` body → InsufficientScope with 5 required substrings | BC-015; BC-1085 (R4) | tests/api_client.rs:~99-144 | HIGH |
| BC-1.6.043 | 401 without scope-mismatch substring → NotAuthenticated, NOT InsufficientScope | BC-016; BC-1086 (R4) | tests/api_client.rs:~146-181 | HIGH |
| BC-1.6.044 | 401 scope-mismatch match is case-insensitive (`to_ascii_lowercase`) | BC-017; BC-1087 (R4) | tests/api_client.rs:~183-216 | HIGH |
| BC-1.6.045 | Non-401 status with scope-mismatch substring does NOT dispatch to InsufficientScope | BC-018; BC-1088 (R4) | tests/api_client.rs:~219-255 | HIGH |
| BC-1.6.046 | `auth list` table snapshot: 5 columns (NAME, URL, ENV, AUTH, STATUS), active profile with `* ` prefix [AMENDED 2026-09-01 cycle-003, DEC-324 — DELIBERATE BREAKING CHANGE, 4→5 columns, `ENV` inserted between `URL` and `AUTH`] | BC-1115 (R4) | src/cli/snapshots/jr__cli__auth__tests__list_table_snapshot.snap | HIGH |
| BC-1.6.047 | `env` tag is surfaced unconditionally in `auth list --output json` (every profile object carries the key, `null` when unset) and `auth status` text output [NEW 2026-09-01 cycle-003, DEC-314/324] | — | ADR-0020 §Decision 4; DEC-314; DEC-324 | HIGH |

---

## Section 2: Issue Read (bc-2-issue-read.md) — 122 BCs cumulative; 80 individually-bodied [BC-2.1.023..025 + BC-2.2.033..034 + BC-2.3.041..042 + BC-2.6.052 added 2026-08-21 issues #575/#584/#579/#588 F2 list-read-ergonomics bundle; BC-2.1.006/007 amended in place; BC-2.7.001..012 added 2026-07-15 SOH-ATTACHMENTS-1 F2 DEC-179; BC-2.2.032 + BC-2.3.039 added 2026-08-13 issue #668 F2 duedate feature; BC-2.1.018..022 + BC-2.3.040 added 2026-08-15 issue #606 F2 component-management bundle]

### 2.1 JQL Composition (25 BCs: BC-2.1.001..025) [BC-2.1.023..025 added 2026-08-21 issues #579/#588 F2; BC-2.1.006/007 amended in place, no separate count; BC-2.1.018..022 added 2026-08-15 issue #606 F2; BC-2.1.006/007 also amended by that bundle]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-2.1.001 | `issue list` cursor-paginates via `POST /rest/api/3/search/jql` | BC-101 | src/cli/issue/list.rs | HIGH |
| BC-2.1.002 | `--jql X` wraps in parens, strips ORDER BY, re-appends `ORDER BY updated DESC` | BC-102, BC-125 (R1) | src/cli/issue/list.rs:~36-52 | HIGH |
| BC-2.1.003 | Scrum board with active sprint → JQL `sprint = <id> ORDER BY rank ASC` | BC-126 (R1) | src/cli/issue/list.rs:~278-282 | HIGH |
| BC-2.1.004 | Kanban board → `project = "X" AND statusCategory != Done ORDER BY rank ASC` | BC-127 (R1) | src/cli/issue/list.rs:~302-310 | HIGH |
| BC-2.1.005 | No board_id → `project = "X" ORDER BY updated DESC` | BC-128 (R1) | src/cli/issue/list.rs:~331-338 | HIGH |
| BC-2.1.006 | No project AND no filters AND no `--jql` → exit 64 listing all 15 filter sources (14→15, `--updated-recent` added 2026-08-21 issue #579; 13→14, `--component` added 2026-08-15 issue #606) | BC-129 (R1) | src/cli/issue/list.rs:~344-351 | HIGH |
| BC-2.1.007 | `build_filter_clauses` emits in stable order: assignee, reporter, status, open, team, recent, updated-recent, asset, component, date filters (`updated-recent` inserted after `recent` 2026-08-21 issue #579; `component` inserted after `asset` 2026-08-15 issue #606) | BC-130 (R1); BC-1093 (R4) | src/cli/issue/list.rs:~613-649 | HIGH |
| BC-2.1.008 | `--recent <duration>` validated by `jql::validate_duration`; combined units rejected | BC-131 (R1) | src/cli/issue/list.rs:~90-92 | HIGH |
| BC-2.1.009 | `--created-after/before` and `--updated-after/before` validated via `jql::validate_date` BEFORE any HTTP | BC-132 (R1) | src/cli/issue/list.rs:~95-114 | HIGH |
| BC-2.1.010 | `--created-before` and `--updated-before` use `date + Days::new(1)` for end-day-inclusive semantics | BC-133 (R1) | src/cli/issue/list.rs:~118-126 | HIGH |
| BC-2.1.011 | `--asset KEY` resolves via CMDB fields; if NO CMDB fields → exit 64 with JSM plan message | BC-134 (R1) | src/cli/issue/list.rs:~168-183 | HIGH |
| BC-2.1.012 | `--asset KEY` ambiguous AQL result → exit 64 `Multiple assets match`; NO issue search fired | BC-135 (R1) | tests/assets.rs:~1480-1573 | HIGH |
| BC-2.1.013 | `--status <single-substring>` → exit 64 `Ambiguous status`; NO JQL search fired | BC-105, BC-136 (R1) | tests/issue_list_errors.rs:~368-422 | HIGH |
| BC-2.1.014 | `--status NOMATCH` → `JrError::UserError` listing available statuses alphabetically | BC-138 (R1) | src/cli/issue/list.rs:~234-246 | HIGH |
| BC-2.1.015 | `--status <ExactMultiple>` treated as Exact (case-variant duplicates) | BC-137 (R1) | src/cli/issue/list.rs:~223-226 | HIGH |
| BC-2.1.016 | `--assets` column auto-enabled when `--asset KEY` filter is set | BC-145 (R1) | src/cli/issue/list.rs:~86-87 | HIGH |
| BC-2.1.017 | `--assets` with no CMDB fields → stderr warning, no asset column | BC-146 (R1) | src/cli/issue/list.rs:~357-371 | HIGH |
| BC-2.1.018 | `--component <NAME>` (repeated) → OR-combined `component in (id1, id2, ...)`; each name resolved independently before composition | — (issue #606 F2) | src/cli/issue/list.rs (pending F4); bc-8-components.md §8.4 | HIGH |
| BC-2.1.019 | `--component not:<NAME>` → `(component not in (id) OR component is EMPTY)` (JQL `NOT IN` excludes EMPTY, so `not:` must OR-EMPTY) | — (issue #606 F2) | src/cli/issue/list.rs (pending F4) | HIGH |
| BC-2.1.020 | `--component none` (reserved keyword) → `component is EMPTY`, zero resolver HTTP calls; rejects combination with other `--component` values | — (issue #606 F2) | src/cli/issue/list.rs (pending F4) | HIGH |
| BC-2.1.021 | `--component all:<N1>,<N2>` → AND-combined `component = id1 AND component = id2`; at most one `all:` occurrence, not mixed with bare/`not:`/`none` | — (issue #606 F2) | src/cli/issue/list.rs (pending F4) | HIGH |
| BC-2.1.022 | Unresolvable/ambiguous `--component` name → exit 64 BEFORE any JQL search fires, listing valid names/candidates for the resolved project scope | — (issue #606 F2) | src/cli/issue/list.rs (pending F4); bc-8-components.md §8.4 | HIGH |
| BC-2.1.023 | `--updated-recent <duration>` → `updated >= -{d}` clause, validated via `jql::validate_duration` (same validator as `--recent`), positioned immediately after `--recent`'s slot | — (issue #579 F2) | src/cli/issue/list.rs (pending F4) | HIGH |
| BC-2.1.024 | `--sort <field>:asc\|desc` syntax parse/validate: case-insensitive direction, exit 64 on malformed input, pre-HTTP, no field-name allowlist | — (issue #588 F2) | src/cli/issue/list.rs (pending F4) | HIGH |
| BC-2.1.025 | `--sort` overrides `order_by` uniformly in all 4 composition branches (including board `rank ASC` branches); appends `, key ASC` secondary sort unless field is `key`; field name passed through to Jira unvalidated | — (issue #588 F2) | src/cli/issue/list.rs (pending F4) | HIGH |

### 2.2 Issue List Behavior (17 BCs: BC-2.2.018..034) [BC-2.2.033..034 added 2026-08-21 issues #575/#584 F2]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-2.2.018 | `--all` passes `maxResults=50`; default passes `maxResults=30` | BC-103, BC-141 (R1) | tests/all_flag_behavior.rs:~42-145 | HIGH |
| BC-2.2.019 | Truncation triggers second HTTP `POST /rest/api/3/search/approximate-count` | BC-104, BC-140 (R1) | tests/all_flag_behavior.rs:~88-145 | HIGH |
| BC-2.2.020 | `--all` + `--limit N` clap conflict: `cannot be used with` | BC-142 (R1) | tests/cli_smoke.rs:~300-307 | HIGH |
| BC-2.2.021 | `--points` with no story_points_field_id → silently ignored, stderr warning | BC-143 (R1) | src/cli/issue/list.rs:~756-770 | HIGH |
| BC-2.2.022 | `--points` with configured field → pushes `customfield_NNNNN` onto request `extra` fields list | BC-144 (R1) | src/cli/issue/list.rs:~147-149, 656-668 | HIGH |
| BC-2.2.023 | Asset enrichment deduplicates by `(workspace_id, object_id)` before per-asset GETs | BC-147 (R1) | src/cli/issue/list.rs:~397-411 | HIGH |
| BC-2.2.024 | board_id 404 → exit 64 with `Board 42 not found or not accessible` + board_id hint + `--jql` hint | BC-106 | tests/issue_list_errors.rs:~21-76 | HIGH |
| BC-2.2.025 | board config 5xx → exit 1 with `Failed to fetch config for board 42` + `--jql` hint | BC-107 | tests/issue_list_errors.rs:~78-130 | HIGH |
| BC-2.2.026 | Sprint list 5xx → exit 1 with `Failed to list sprints for board 42` + `--jql` hint | BC-108 | tests/issue_list_errors.rs:~132-194 | HIGH |
| BC-2.2.027 | No active sprint → falls back to project-scoped JQL without error | BC-109 | tests/issue_list_errors.rs:~196-263 | HIGH |
| BC-2.2.028 | `search_issues` default fields list: 17 fields in EXACT order (AMENDED 2026-08-13: 16→17, `duedate` added) | BC-1063 (R4) | tests/issue_commands.rs:~967-1022 | HIGH |
| BC-2.2.029 | `search_issues` with cursor continuation token sets `has_more = true` | BC-1047, BC-1048 (R4) | tests/issue_commands.rs:~264-310 | HIGH |
| BC-2.2.030 | `search_issues` JQL body includes literal composed string with double-quoted project key | BC-1052 (R4) | tests/issue_commands.rs:~492-524 | HIGH |
| BC-2.2.031 | `client.approximate_count(jql)` POSTs to `/rest/api/3/search/approximate-count`; 5xx propagates as Err | BC-1050 (R4) | tests/issue_commands.rs:~337-386 | HIGH |
| BC-2.2.032 | `issue list --duedate` opts in a Due Date column (`YYYY-MM-DD`, `-` when unset), positioned after Priority before Points | — (F2 issue #668, 2026-08-13) | src/cli/issue/list.rs, src/cli/issue/format.rs (pending F4) | HIGH |
| BC-2.2.033 | `issue list --fields <CSV>` replaces the requested `fields=` set (REPLACE, not UNION); requires `--output json` (exit 64 otherwise); pre-HTTP CSV validation | — (issue #575 F2) | src/cli/issue/list.rs (pending F4) | HIGH |
| BC-2.2.034 | `issue list --fields comment --output json` returns `.fields.comment.comments[].body` as raw ADF via the pre-existing `extra` flatten — zero incremental transformation code | — (issue #584 F2) | src/types/jira/issue.rs::IssueFields (pending F4) | HIGH |

### 2.3 Issue View (11 BCs: BC-2.3.032..042) [BC-2.3.041..042 added 2026-08-21 issues #575/#584 F2; BC-2.3.040 added 2026-08-15 issue #606/#605/#604/#608 F2 — shared Component.id prerequisite]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-2.3.032 | `issue view <key>` GETs `/rest/api/3/issue/<key>` with `--output json` returning raw JSON | BC-112 | tests/issue_commands.rs:~33-53 | HIGH |
| BC-2.3.033 | `issue view` 5xx → exit 1 + `API error (500)` + no panic | BC-113; BC-1135a (R4) | tests/issue_view_errors.rs:~18-56 | HIGH |
| BC-2.3.034 | `issue view` 401 → exit 2 + `Not authenticated` + `jr auth login` | BC-114; BC-1135b (R4) | tests/issue_view_errors.rs:~58-100 | HIGH |
| BC-2.3.035 | Corrupt `teams.json` cache is non-fatal; UUID + "name not cached" hint shown inline | BC-115; BC-1135d (R4) | tests/issue_view_errors.rs:~142-206 | HIGH |
| BC-2.3.036 | `get_issue` deserializes: created, updated, duedate, reporter, resolution, components, fix_versions (all nullable) (AMENDED 2026-08-13: `duedate` added) | BC-1053, BC-1054 (R4) | tests/issue_commands.rs:~526-577, 579-607 | HIGH |
| BC-2.3.037 | `get_issue` with parent + links deserializes `fields.parent.key`, `fields.issuelinks[0].link_type.name` | BC-1044 (R4) | tests/issue_commands.rs:~208-231 | HIGH |
| BC-2.3.038 | `IssueFields::story_points("customfield_X")` returns None for non-numeric values | BC-124 | src/types/jira/issue.rs:~83-85 | HIGH |
| BC-2.3.039 | `issue view` always shows a "Due Date" detail row (`YYYY-MM-DD`, `-` when unset), positioned after Updated before Project | — (F2 issue #668, 2026-08-13) | src/cli/issue/view.rs (pending F4) | HIGH |
| BC-2.3.040 | `Component` struct (`fields.components[]`) gains a REQUIRED `id: String` field alongside existing `name: String`; breaking deserialization change — shared prerequisite for #604/#605/#606/#608 | — (F2 issues #604/#605/#606/#608, 2026-08-15) | src/types/jira/issue.rs::Component (pending F4) | HIGH |
| BC-2.3.041 | `issue view --fields <CSV>` — same semantics as BC-2.2.033, via a new `get_issue`-family client method | — (issue #575 F2) | src/cli/issue/view.rs (pending F4) | HIGH |
| BC-2.3.042 | `issue view --fields comment --output json` returns `.fields.comment.comments[].body` as raw ADF via `IssueFields.extra` — same mechanism as BC-2.2.034 | — (issue #584 F2) | src/cli/issue/view.rs (pending F4) | HIGH |

### 2.4 Comments (5 BCs: BC-2.4.039..043)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-2.4.039 | `issue comments <key>` paginates at 100/page with `expand=properties` | BC-116 | tests/comments.rs:~9-46, 73-158 | HIGH |
| BC-2.4.040 | `issue comments` 5xx → exit 1 + `API error (500)` | BC-117 | tests/comments.rs:~163-200 | HIGH |
| BC-2.4.041 | `issue comments --internal` adds `sd.public.comment` property (JSM-aware) | BC-118 | src/api/jira/issues.rs:~181-198 | MEDIUM |
| BC-2.4.042 | `client.list_comments(key, None)` lists ALL comments via offset pagination | BC-122 | tests/comments.rs:~104-158 | HIGH |
| BC-2.4.043 | `list_comments` offset pagination aborts with Err if startAt does not advance (anti-stall guard matching get_changelog) | — (CR-001, Bundle C 2026-06-17) | src/api/jira/issues.rs::list_comments; tests/comments.rs::test_list_comments_stall_guard | HIGH |

### 2.5 Changelog (4 BCs: BC-2.5.043..046)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-2.5.043 | `issue changelog --field <substr>` filters items by case-insensitive field substring (client-side) | BC-119 | src/cli/issue/changelog.rs | MEDIUM |
| BC-2.5.044 | `issue changelog --author X` smart-constructs author needle | BC-120 | src/cli/issue/changelog.rs | MEDIUM |
| BC-2.5.045 | `issue changelog --reverse` reverses chronological order | BC-121 | src/cli/issue/changelog.rs | MEDIUM |
| BC-2.5.046 | Changelog JSON output snapshot pins full shape including nullable `fromString`/`toString` | BC-1118 (R4) | tests/snapshots/issue_changelog | HIGH |

### 2.6 API Layer (6 BCs: BC-2.6.047..052) [BC-2.6.052 added 2026-08-21 issue #575 F2]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-2.6.047 | `client.search_issues` with story-points extra field: deserializes `Some(5.0)` for issue with field, `None` without | BC-1041 (R4) | tests/issue_commands.rs:~130-166 | HIGH |
| BC-2.6.048 | `client.find_story_points_field_id()` returns fields with name == "Story Points" from `/rest/api/3/field` | BC-1042 (R4) | tests/issue_commands.rs:~168-186 | HIGH |
| BC-2.6.049 | `search_users` accepts FOUR distinct response shapes (bare array, paginated, empty, error) | BC-1051 (R4) | tests/issue_commands.rs:~388-490 | HIGH |
| BC-2.6.050 | `client.search_issue_keys(jql, limit)` posts `/rest/api/3/search/jql` with body `fields: ["key"]` and returns `KeySearchResult { keys, has_more }` | — (issue #350) | tests/search_issue_keys.rs | HIGH |
| BC-2.6.051 | `client.search_issues(jql, limit, fields)` deduplicates results in-place on all exit paths (JRACLOUD-95368 mitigation, per-iteration HashSet retain keyed on issue.key) | — (issue #365) | tests/rate_limit_cap_tests.rs | HIGH |
| BC-2.6.052 | `JiraClient` gains field-override client methods (additive; existing `get_issue`/`search_issues` signatures and their 10 other call sites unchanged) | — (issue #575 F2) | src/api/jira/issues.rs (pending F4) | HIGH |


### 2.7 Attachment Read (12 BCs: BC-2.7.001..012) [Added 2026-07-15 SOH-ATTACHMENTS-1 F2 DEC-179 issues #576 #585]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-2.7.001 | `attachment list <KEY>` renders table: id, filename, mimeType, size (human-readable), created, author; output channel profile 2 (stdout data, stderr hints) | — (SOH-ATTACHMENTS-1 F2) | src/cli/issue/attachments.rs (pending S1) | HIGH |
| BC-2.7.002 | `attachment list --output json` returns array of attachment objects including `contentUrl` field; JSON render invariant #526 (`output::render_json`); closes #585 contentUrl surface; **BTreeMap-alphabetical key order at all depths: author < contentUrl < created < filename < id < mimeType < size** (P19-001) | — (SOH-ATTACHMENTS-1 F2; P19-001) | src/cli/issue/attachments.rs (pending S1) | HIGH |
| BC-2.7.003 | `--filter mime=<glob>` client-side mimeType filter; glob case-insensitive; AND-combined with other filters; **EC-2.7.003-2: "clap-or-application" → "application" pre-flight check (P18-003)** | — (SOH-ATTACHMENTS-1 F2; P18-003) | src/cli/issue/attachments.rs (pending S1) | HIGH |
| BC-2.7.004 | `--filter name=<glob>` client-side filename filter; JRACLOUD-96384 match-by-id note (display name unreliable for matching) | — (SOH-ATTACHMENTS-1 F2) | src/cli/issue/attachments.rs (pending S1) | HIGH |
| BC-2.7.005 | `--filter size-max=<bytes>` client-side size filter; no hard-coded cap; non-numeric input → exit 64 | — (SOH-ATTACHMENTS-1 F2) | src/cli/issue/attachments.rs (pending S1) | HIGH |
| BC-2.7.006 | Unknown/inaccessible KEY → exit 64; full error taxonomy: 404 issue-not-found, 401 not-authenticated, 5xx API error, network failure; **403 override row added to error-taxonomy.md (P18-002)** | — (SOH-ATTACHMENTS-1 F2; P18-002) | src/cli/issue/attachments.rs (pending S1) | HIGH |
| BC-2.7.007 | Single-file download — **AID validated against `^[0-9]+$` before step 1** (P7-001: invalid → exit 64, zero HTTP); two-step: (1) `GET /rest/api/3/attachment/{id}` metadata (yields filename; canonical 404); (2) `GET /rest/api/3/attachment/content/{id}` streaming; **`--out` does NOT skip step 1 (P20-003, UNCONDITIONAL two-step)**: step 1 issued regardless of `--out`; rationale: pre-stream existence validation; accepted cost: one extra GET; **step-1 deserialization uses PARTIAL struct requiring only `filename`; all other fields absent-tolerant (P26-003)**; redirect-following (reqwest default, GHSA-9857-6MW7-FQ2M strips auth on cross-host); no `?redirect=false` (JRACLOUD-97046 breaks some formats); KEY not server-verified on --id path; `"Attachment <AID> not found or not accessible."` canonical not-found string; 403 → exit 1 permission-denied (EC-2.7.007-1b); default filename = bare sanitized basename (no SHA-1 prefix — single-id bare naming per BC-2.7.010); download JSON `{"downloaded":[{filename,id,path,size}]}`; JSM and non-JSM use same endpoint (JSDCLOUD-10841); **`downloaded[].filename` = RAW Jira name (pre-sanitization); on-disk basename recoverable from `path` (P27-001)**; **`--out` pre-flight ordering pinned (P32-001)**: local checks (EC-2.7.007-6/EC-2.7.007-11/overwrite-refuse) fire BEFORE step-1 metadata GET — fail cheap/offline first; double-fault → local check's message wins; **`?redirect=false` prohibited in step 2 body clause (SEC-576-009, JRACLOUD-97046)**: appending `?redirect=false` changes redirect behavior and invalidates EC-2.7.007-3 credential-stripping invariant; **EC-2.7.007-12 (SEC-576-010)**: `--out <PATH>` targets existing regular file without `--force` → exit 64 pre-HTTP (`"File already exists: <path>. Use --force to overwrite."`) | — (SOH-ATTACHMENTS-1 F2; P7-001; P20-003; P26-003; P27-001; P32-001; SEC-576-009; SEC-576-010) | src/cli/issue/attachments.rs (pending S2) | HIGH |
| BC-2.7.008 | `--all` batch download: saves each attachment to `--out-dir`; fail-soft per-file on collision (skip, warn); `--out-dir` must exist (exit 64 if absent); `--id` and `--all` are mutually exclusive; **JSON-mode stderr policy (P25-001)**: per-file failure warnings (`warning: failed to download attachment <AID>: ...`) ARE emitted to stderr in JSON mode (ERRORS, not hints); `Downloaded N of M` summary NOT emitted in JSON mode (HINT, suppressed — EC-2.7.008-6); **`downloaded[].filename` = RAW Jira name (pre-sanitization, pre-SHA-1-prefix); on-disk basename recoverable from `path` (P27-001)**; **collision-skip warnings are NON-ERROR hints, suppressed in JSON mode (P27-003)**; **Batch metadata source scoped (P31-002)**: list response for NAMING/filtering/pre-download; manifest `size` = bytes written to disk (NOT list-reported `fields.attachment[].size`); EC-2.7.008-6 `size` semantics sentence added; "Shape aligns" → "Shape and field semantics align"; **EC-2.7.008-1 JSON-mode clause (P34-004)**: empty issue → `{"downloaded":[]}` in JSON mode; `"No attachments on <KEY>."` is a HINT suppressed in JSON mode; EC-2.7.001-1 unification is STRING-only; **display-sanitization cross-reference (SEC-576-011)**: `<filename>` in any collision-skip warning MUST be display-sanitized (per BC-2.7.011 display-sanitization character set → `?`) before TTY write; RAW value retained in JSON mode | — (SOH-ATTACHMENTS-1 F2; P25-001; P27-001; P27-003; P31-002; P34-004; SEC-576-011) | src/cli/issue/attachments.rs (pending S2) | HIGH |
| BC-2.7.009 | `--newest N` selects top-N attachments by `created` desc; filter applied before top-N selection; N > count → graceful (return all); non-numeric/zero N → exit 64; `--newest` declared with arg-level `Arg::allow_negative_numbers` (clap 4 — verified docs.rs 4.6.1; P17-007); **EC-2.7.009-4 empty-issue cross-ref (P34-004)**: empty issue on `--newest` follows EC-2.7.008-1 (exit 0; `"No attachments on <KEY>."` HINT suppressed in JSON mode; `{"downloaded":[]}`) | — (SOH-ATTACHMENTS-1 F2; P34-004) | src/cli/issue/attachments.rs (pending S2) | HIGH |
| BC-2.7.010 | Default output filename: **single-`--id`** = bare sanitized basename (no SHA-1 prefix; peer-convention alignment — curl/gh pattern); **batch (`--all`/`--newest`)** = `<sha1-of-id>_<sanitized-basename>` (SHA-1 of numeric ID for collision-resistance/idempotency; single-vs-batch asymmetry deliberate); degenerate fallback (sanitization → None/empty): **single-id** = raw id (bare); **batch** = `<sha1>_<id>` (R3.10 ruling — batch stays uniformly prefixed, zero special-cases in collision logic); `--out <PATH>` overrides naming entirely; **`path` field non-determinism: as-constructed, NOT canonicalized or made absolute; snapshot tests must redact/normalize (P18-004)**; **server-ID trust assumption (SEC-576-008)**: batch `fields.attachment[].id` numeric invariant is API-behavioral (no client-side `^[0-9]+$` validation); compromised server outside threat model; implementers MAY add `^[0-9]+$` defense-in-depth; **display-sanitization cross-reference (SEC-576-011)**: `<raw>` in degenerate-name warning MUST be display-sanitized (per BC-2.7.011 display-sanitization character set → `?`) before TTY write; RAW value retained in JSON mode | — (SOH-ATTACHMENTS-1 F2; P7-003; P18-004; SEC-576-008; SEC-576-011) | src/cli/issue/attachments.rs (pending S2) | HIGH |
| BC-2.7.011 | `sanitize_attachment_filename` **CWE-22** path-traversal mitigation: 5.5-step algorithm (basename extraction, pseudo-name `.`/`..` reject, NUL-byte reject, char scrub `/`/`\`/`:` → `_` only, 214-byte cap, trailing-dot/whitespace strip SEC-576-007); containment: `canonicalize(out_dir)` then `Path::starts_with` — NOT `canonicalize` on joined path (SEC-576-002 corrected procedure); **`--out <PATH>` is excluded from containment check entirely** — trusted operator input (BC-2.7.007/BC-2.7.010); neither step 1 nor step 2 applies to `--out`-supplied paths (P25-002 reword); Windows device-name caller note (SEC-576-001); naive blacklist INSUFFICIENT — see body; **ALSO: display sanitization for TTY output (SEC-576-011 — CWE-116)**: ALL ASCII control characters 0x00–0x1F and 0x7F in server-supplied `filename` values MUST be replaced with `?` before writing to any TTY (confirmation prompts, collision-skip warnings, degenerate-name warnings, table cells); display-only (RAW value retained in JSON/disk/API); `display_sanitize_filename` helper required at every call site; earliest consumer S1 (list table cells); cross-referenced from BC-2.7.008/BC-2.7.010/BC-3.9.015/BC-3.9.017; **Unicode bidi controls U+202A..U+202E and U+2066..U+2069, line/paragraph separators U+2028/U+2029, NEL U+0085 NOW INCLUDED in sanitization (PRE-F4-UNICODE-DISPLAY-SANITIZATION, v1.3.94)**; implementation form: char-level matching; unit-test mandate: U+202E/U+2028/U+0085 required cases; remaining Unicode confusables/homoglyphs (non-control) OUT of scope — not a terminal-injection vector | — (SOH-ATTACHMENTS-1 F2; P25-002; SEC-576-011) | src/cli/issue/attachments.rs (pending S2) | HIGH |
| BC-2.7.012 | Unknown KEY or AID → exit 64; **KEY-404 fires on batch paths only** (`--all`/`--newest`; `--id` does NOT server-verify KEY per BC-2.7.007 — P21-006); **KEY-403 batch-paths-only row added to error table (P26-001): exit 1 `"Permission denied: cannot access issue <KEY>."` mirrors BC-2.7.006 P15-005 row**; **body prose "Unknown issue key" sentence prepended with batch-only caveat (P22-003)**; **invalid AID (non-numeric) → exit 64 zero HTTP** (P7-001 row added to taxonomy table); match-by-id invariant (JRACLOUD-96384/-78388: always identify attachments by `id`, never filename); full error taxonomy table (invalid-AID/404/403/401/5xx/network/disk-write-ENOSPC/EACCES/other — P13-001 relocated from BC-2.7.006); **403 override row added to error-taxonomy.md (P18-002)**; **v1.3.102 F5-R5-001: disk-write rows amended to HYBRID shape — `Disk full: not enough space to write <dest>: <os_error>. Free up disk space and try again.` (`ErrorKind::StorageFull`\|`QuotaExceeded`); `Permission denied: cannot write to <dir>: <os_error>. Check directory permissions and try again.` (`ErrorKind::PermissionDenied`\|`ReadOnlyFilesystem`); `Failed to write <dest>: <os_error>.` (generic fallback); detection-and-testing note added; `<dest>` = final path not tmp**; **v1.3.103 FIX-F5-010: permission-denied row dest parenthetical added — `Permission denied: cannot write to <dir> (writing <dest>): <os_error>. Check directory permissions and try again.`; P9-001 reconciliation (Windows rename-to-existing → PermissionDenied; filename must appear in error per BC-2.7.007 P9-001 CWE-116)**; **v1.3.104 F5-R6-001: io-site count corrected three→four — `flush` added with delayed-allocation rationale (ENOSPC can surface at flush on Linux ext4 / delayed-allocation FSes); F5-R6-002 INFO note added (mid-stream body-read abort → `"stream error: {e}"` exit 1; distinct from NetworkError row; accepted wording divergence)** | — (SOH-ATTACHMENTS-1 F2; P7-001; P13-001; P18-002; P21-006; P22-003; P26-001; v1.3.102 F5-R5-001; v1.3.103 FIX-F5-010; v1.3.104 F5-R6-001/F5-R6-002) | src/cli/issue/attachments.rs (pending S2) | HIGH |

---

## Section 3: Issue Write (bc-3-issue-write.md) — 152 BCs cumulative; 123 individually-bodied [BC-3.9.001..014 added 2026-07-15 SOH-ATTACHMENTS-1 F2 DEC-179; BC-3.9.015..020 added 2026-07-15 adversary pass-1 round B; BC-3.4.022..025 added 2026-08-15 issues #604/#605/#608 F2 component-management bundle; BC-3.3.010..011 + BC-3.4.026..031 added 2026-08-25 issues #580/#578 F2 Field DX bundle]

### 3.1 Assign (9 BCs: BC-3.1.001..009)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-3.1.001 | `issue assign --account-id <id>` PUTs `/issue/<key>/assignee` with `{accountId: <id>}` | BC-201; BC-1077 (R4) | tests/cli_handler.rs:~58-91 | HIGH |
| BC-3.1.002 | `issue assign --to <name>` resolves via assignable user search then assigns | BC-202; BC-1059 (R4) | tests/cli_handler.rs:~93-133 | HIGH |
| BC-3.1.003 | `issue assign --to me` resolves current user via `/myself` | BC-203; BC-1061 (R4) | tests/issue_commands.rs:~879-920 | HIGH |
| BC-3.1.004 | `issue assign` is idempotent — already-assigned-to-target → exit 0 + `"changed": false` | BC-204; BC-1062 (R4) | tests/issue_commands.rs:~922-965 | HIGH |
| BC-3.1.005 | `issue assign --unassign` PUTs `{accountId: null}` | BC-205 | src/cli/issue/workflow.rs | MEDIUM |
| BC-3.1.006 | `--to` ⊕ `--account-id` ⊕ `--unassign` clap conflict (mutually exclusive) | BC-206 | tests/cli_smoke.rs:~170-211 | HIGH |
| BC-3.1.007 | `search_assignable_users` returning empty Vec → `Ok(Vec::new())` (NOT Err); handler decides UX | BC-1060 (R4) | tests/issue_commands.rs:~856-877 | HIGH |
| BC-3.1.008 | `assign_issue("ERR-1", Some("bogus-id"))` against 404 → Err + `"does not exist"` message | BC-1078 (R4) | tests/issue_commands.rs:~1705-1738 | HIGH |
| BC-3.1.009 | `search_assignable_users_by_project(query, projectKey)` GETs `/rest/api/3/user/assignable/multiProjectSearch` | BC-1064 (R4) | tests/issue_commands.rs:~1024-1082 | HIGH |

### 3.2 Move / Transition (14 BCs: BC-3.2.001..014)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-3.2.001 | `issue move <key> <target>` is idempotent when current == target (by status name) | BC-207; BC-1074 (R4) | tests/issue_commands.rs:~1500-1549 | HIGH |
| BC-3.2.002 | `issue move <key>` is idempotent via transition-name→status-name resolution too | BC-1075 (R4) | tests/issue_commands.rs:~1551-1604 | HIGH |
| BC-3.2.003 | `issue move` resolves transition by NAME match | BC-1069 (R4) | tests/issue_commands.rs:~1219-1276 | HIGH |
| BC-3.2.004 | `issue move` resolves by STATUS NAME match | BC-1070 (R4) | tests/issue_commands.rs:~1278-1335 | HIGH |
| BC-3.2.005 | Duplicate candidates (same transition + status name) are de-duplicated; only ONE candidate presented | BC-1071 (R4) | tests/issue_commands.rs:~1337-1394 | HIGH |
| BC-3.2.006 | Ambiguous move → exit non-zero + stderr `"Ambiguous"` + NO POST | BC-1072 (R4) | tests/issue_commands.rs:~1396-1444 | HIGH |
| BC-3.2.007 | No-match move → enriched candidate list in stderr: `"Complete (→ Completed)"` format | BC-1073 (R4) | tests/issue_commands.rs:~1446-1498 | HIGH |
| BC-3.2.008 | `--no-input` single-substring move → exit 64 + `"Ambiguous transition"` + ZERO POST | BC-1079 (R4) | tests/issue_commands.rs:~1748-1810 | HIGH |
| BC-3.2.009 | `issue move` 400 "resolution required" → `--resolution` hint + `jr issue resolutions` discovery pointer | BC-208, BC-209 | tests/issue_resolution.rs:~88-158 | HIGH |
| BC-3.2.010 | `issue resolutions` reads cache-first (7d TTL); JSON: `[{name, id, description}]` | BC-210 | tests/issue_resolution.rs:~11-46, 49-86 | HIGH |
| BC-3.2.011 | `transition_issue(key, id, Some(&fields))` body contains `{transition: {id}, fields: {resolution: {name: "Done"}}}` | BC-1039 (R4) | tests/issue_commands.rs:~79-103 | HIGH |
| BC-3.2.012 | `transition_issue(key, id, None)` body MUST NOT contain `"fields"` key | BC-1040 (R4) | tests/issue_commands.rs:~105-128 | HIGH |
| BC-3.2.013 | `issue move` (single-key) proactively enforces resolution on done-category transitions: REQUIRED → mandatory (--resolution or interactive prompt; --no-resolution or --no-input-without-flag exits 64); OPTIONAL → explicit choice required (--resolution / --no-resolution / prompt; --no-input-without-flag exits 64); BC-3.2.009 retained as backstop; breaking change | — (jsm-resolution-required F2 2026-06-03) | tests/issue_move_resolution_enforce.rs (new); tests/issue_resolution.rs | HIGH |
| BC-3.2.014 | Multi-key `issue move` bulk transition POST body nests keys and transitionId inside `bulkTransitionInputs` array — NOT top-level; one entry per invocation (all keys + one transitionId from first key); `sendBulkNotification: false`; flat top-level body is invalid (400 live) | — (fix-bulk-transition-schema 2026-06-08, commit acca854) | tests/issue_bulk.rs::test_move_multikey_bulk_transition_uses_bulktransitioninputs_wrapper; tests/e2e_live.rs::test_e2e_issue_move_multikey_bulk | HIGH |

### 3.3 Create (11 BCs: BC-3.3.001..011) [BC-3.3.010..011 added 2026-08-25 issue #578 F2 — non-JSM `--field` extension]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-3.3.001 | `issue create` POSTs `/rest/api/3/issue`; `--output json` returns created issue object + `url` (follow-up GET); `{key,url,fetch_error}` on fetch failure (platform path; when `--request-type` absent — see BC-3.8.001) [UPDATED 2026-05-18 issue #288; amended 2026-05-19 issue #383 (2026-05-19..2026-07-25: stderr carried BC-3.8.012/013 warnings on platform path; superseded by DEC-188 exit-64); amended 2026-07-25 DEC-188 (BC-3.8.012/013 warn-and-proceed superseded by exit-64 pre-flight guard); amended 2026-08-25 issue #578 DEC-310 (registered 2026-08-26) (BC-3.8.012's `--field` guard REVERSED — see BC-3.3.010; `--on-behalf-of` guard BC-3.8.013 unaffected)] | BC-211 | tests/issue_create_json.rs | HIGH |
| BC-3.3.002 | `issue create` with assignee — uses `search_assignable_users_by_project` (multiProjectSearch) | BC-1064 (R4) | tests/issue_commands.rs:~1024-1082 | HIGH |
| BC-3.3.003 | `issue create --to me` uses `get_myself()` (no search HTTP) | BC-1065 (R4) | tests/issue_commands.rs:~1084-1127 | HIGH |
| BC-3.3.004 | `issue create` WITHOUT assignee — body has `{project, issuetype, summary}` ONLY (no assignee key) | BC-1066 (R4) | tests/issue_commands.rs:~1129-1154 | HIGH |
| BC-3.3.005 | `issue create` assignee-not-found → stops short of create (NO POST mock) | BC-1067 (R4) | tests/issue_commands.rs:~1156-1180 | HIGH |
| BC-3.3.006 | `issue create --account-id <id>` skips user search entirely | BC-1068 (R4) | tests/issue_commands.rs:~1182-1217 | HIGH |
| BC-3.3.007 | `--to` and `--account-id` clap conflict on `issue create` | BC-224 | tests/cli_smoke.rs:~215-235 | HIGH |
| BC-3.3.008 | `issue create --markdown -d '...'` converts markdown to ADF before POST | BC-212 | tests/issue_create_json.rs | MEDIUM |
| BC-3.3.009 | `create_issue` browse URL uses `client.instance_url()` (NOT `client.base_url()`) | BC-1076 (R4) | tests/issue_commands.rs:~1606-1644 | HIGH |
| BC-3.3.010 | `issue create --field NAME=VALUE` (repeatable, non-JSM platform path) resolves via `createmeta` (project+issueType-scoped) and merges into the create POST body — same machinery as `issue edit --field` (BC-3.4.015/016), source substituted; reverses DEC-188's `--field`-alone platform-path exit-64 guard | — (issue #578 F2) | src/cli/issue/create.rs::handle_create; src/cli/issue/field_resolve.rs::resolve_edit_fields (extended); src/api/jira/issues.rs (new createmeta call) | HIGH |
| BC-3.3.011 | Error taxonomy for `issue create --field` on the platform path — parallels BC-3.4.015/016's editmeta taxonomy with "Create screen" substituted for "Edit screen" throughout | — (issue #578 F2) | Companion to BC-3.3.010 | HIGH |

### 3.4 Edit and Open (31 BCs: BC-3.4.001..031) [BC-3.4.010..011 added 2026-05-20 issue #388 F2; BC-3.4.012..014 added 2026-05-21 issue #398 F2; BC-3.4.015..017 added 2026-05-22 issue #396 F2; BC-3.4.018..019 added 2026-06-01 issue #331 F2; BC-3.4.020..021 added 2026-06-30 BC-subclause-pass F2; BC-3.4.022..025 added 2026-08-15 issues #604/#605/#608 F2 component-management bundle; BC-3.4.026..031 added 2026-08-25 issue #578 F2 (`--field NAME:kind=VALUE` hint-syntax parser + `:option`/`:id`/`:name`/`:asset` semantics + malformed-hint EC catalog); BC-3.4.003 modified 2026-05-20 issue #388 F2 annotation; BC-3.4.003 modified 2026-05-21 issue #398 F2 annotation; BC-3.4.012/013/017/020/021 modified 2026-08-15 issue #605 F2 (`components` field-echo/Gate-B/conflict-block/dry-run additions); BC-3.4.015/016 amended 2026-08-25 issue #578 F2 (hint-syntax interaction notes)]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-3.4.001 | `handle_open` MUST compose URL as `<instance_url>/browse/<key>` using `client.instance_url()` [MUST-FIX: NFR-R-B] | BC-220; NFR-R-B; BC-1010 (R4) | src/cli/issue/workflow.rs:~636 | HIGH |
| BC-3.4.002 | `issue open --url-only` prints URL to stdout (no browser launch) | BC-221 | Pass 2 §2b.1 | MEDIUM |
| BC-3.4.003 | `issue edit` PUTs `/rest/api/3/issue/<key>` with ADF description; accepts 204; success output see BC-3.4.012 (table) and BC-3.4.013 (JSON) | BC-1055 (R4) | tests/issue_commands.rs:~609-645 | HIGH |
| BC-3.4.004 | `issue edit` with `markdown_to_adf("**bold text**")` → ADF marks `[{type: "strong"}]` on wire | BC-1056 (R4) | tests/issue_commands.rs:~647-687 | HIGH |
| BC-3.4.005 | `issue edit` with multiple fields sends both in body simultaneously | BC-1057 (R4) | tests/issue_commands.rs:~689-727 | HIGH |
| BC-3.4.006 | `issue edit --label add:foo --label remove:bar` interprets prefix and emits correct JSON wire shape | BC-213; issue #345; S-345 | tests/issue_create_json.rs; tests/issue_bulk.rs; tests/issue_bulk_pr2.rs; src/cli/issue/edit.rs::build_labels_edited_fields; src/cli/issue/edit.rs inline build_labels_proptests | HIGH |
| BC-3.4.007 | `--description` and `--description-stdin` clap conflict | BC-214 | tests/cli_smoke.rs:~34-48 | HIGH |
| BC-3.4.008 | `--points X` and `--no-points` clap conflict | BC-215 | tests/cli_smoke.rs:~280-287 | HIGH |
| BC-3.4.009 | `await_bulk_task` timeout error MUST include `task_id` literal in stderr message | — (issue #340) | tests/bulk_deadline_propagation.rs; src/api/jira/bulk.rs | HIGH |
| BC-3.4.010 | `edit --type X` HTTP 400 + source `issuetype.subtask` differs from target type's `subtask` (cross-hierarchy) → exit 1, `CROSS_HIERARCHY_HINT` on stderr citing JRACLOUD-27893; same constant fixes `--no-parent` arm at `edit.rs::handle_edit` | — (issue #388 F2) | tests/issue_edit_type_errors.rs; src/cli/issue/edit.rs::is_cross_hierarchy_type_error | HIGH |
| BC-3.4.011 | `edit --type X` HTTP 400 + same-hierarchy flags (`src_subtask == tgt_subtask`) → exit 1, typo hint referencing `jr project types` + raw Atlassian error; OR indeterminate (fetch fails) → exit 1, raw error only; `CROSS_HIERARCHY_HINT` (JRACLOUD-27893) MUST NOT appear on either sub-path | — (issue #388 F2) | tests/issue_edit_type_errors.rs; src/cli/issue/edit.rs::is_cross_hierarchy_type_error | HIGH |
| BC-3.4.012 | `issue edit KEY` single-key success (table mode) echoes one stderr line per changed field (`  field → value`); `--team` shows RESOLVED team name (not UUID); `--description` / `--description-stdin` shows literal marker `(updated)` — not content | — (issue #398 F2) | src/cli/issue/edit.rs::handle_edit; src/cli/issue/helpers.rs::resolve_team_field (3-tuple return) | HIGH |
| BC-3.4.013 | `issue edit KEY` single-key success (JSON mode) — `edit_response` extended with `changed_fields` object; `"updated": true` retained (backward-compat); `changed_fields.description` carries the raw user-supplied `--description`/`--description-stdin` input string (NOT `(updated)` marker, NOT an ADF→text round-trip); `changed_fields.team` is resolved display name | — (issue #398 F2) | src/cli/issue/json_output.rs::edit_response; src/cli/issue/edit.rs::handle_edit (desc_text capture) | HIGH |
| BC-3.4.014 | `issue create` table-mode success echoes ALL set fields to stderr (mirroring BC-3.4.012) — one `  <field> → <value>` line per set field in alphabetical order between "Created issue" and browse URL; JSON output path unchanged (full issue object returned via follow-up GET); human-gate decision 2026-05-22. **[DEC-188 qualifier, reversed 2026-08-25 issue #578 for `--field`]** Echo fires only when `--on-behalf-of` is not present without `--request-type`; if `--on-behalf-of` is present without `--request-type`, exit 64 fires per BC-3.8.013 before field echo is reached. `--field` alone no longer triggers exit 64 — post-DEC-310 reversal it resolves via `createmeta` and its resolved value IS echoed (per BC-3.3.010 step 6). | — (issue #398 F2; revised 2026-05-22 human-gate; amended 2026-08-25 issue #578) | src/cli/issue/create.rs::handle_create; src/cli/issue/helpers.rs::resolve_team_field (3-tuple return) | HIGH |
| BC-3.4.015 | `issue edit KEY --field NAME=VALUE` (string/number/date/datetime/user field, single-key path) — resolves field name via `list_fields()`, validates against `editmeta`, serializes per type, PUTs; success echoes in `changed_fields` (human name as key); `customfield_NNNNN` literal bypasses name resolution; field absent from `editmeta` → exit 64 with Edit-screen hint; unsupported types (`array`, `any`) → exit 64 [AMENDED 2026-08-25 issue #578: this is the BARE-form (no `:kind` hint) dispatch, PERMANENT and UNCHANGED — see BC-3.4.026 for the opt-in hint-syntax extension] | — (issue #396 F2) | src/cli/issue/edit.rs::handle_edit; src/api/jira/issues.rs::get_editmeta (new); src/cli/issue/field_resolve.rs::resolve_edit_fields (new) | HIGH |
| BC-3.4.016 | `issue edit KEY --field NAME=VALUE` (single-select `option` field) — resolves human option value to `allowedValues[].id`; wire payload `{"customfield_NNNNN": {"id": "<id>"}}`; `changed_fields` echo shows human label (not id); case-insensitive matching; unknown option value → exit 64 listing allowed values [AMENDED 2026-08-25 issue #578: bare-form dispatch, PERMANENT; explicit opt-in spelling is `--field NAME:option=VALUE` (BC-3.4.027), byte-identical wire output, plus new cascading `Parent>Child` composition (CONFIRMED per ADR-0019 §3)] | — (issue #396 F2) | src/cli/issue/edit.rs::handle_edit; src/api/jira/issues.rs::get_editmeta (new); src/cli/issue/field_resolve.rs::resolve_edit_fields (option-arm) | HIGH |
| BC-3.4.017 | `--field` multi-key/`--jql`-multi-issue rejection (C-1 guard, exit 64); flag-overlap hard error for `summary`/`description`/`issuetype`/`priority`/`components` — fires for BOTH the bare `--field NAME=VALUE` form AND a hint-tagged `--field NAME:kind=VALUE` form (matched on the bare field name, EC-3.4.017-16) (exit 64, no HTTP); `--jql` matching exactly 1 issue is allowed (single-key path); `--field` added to `REJECTED_IN_BULK` set | — (issue #396 F2; amended issue #605 F2, issue #578 F2) | src/cli/issue/edit.rs::handle_edit (REJECTED_IN_BULK update; Gate B overlap check) | HIGH |
| BC-3.4.018 | `issue edit KEY1 KEY2 --type <NAME>` multi-key bulk path — `editedFieldsInput["issueType"] = {"issueTypeId": "<id-string>"}` (camelCase key, string id); `selectedActions: ["issuetype"]` (lowercase, intentionally asymmetric); name resolved case-insensitively via `GET /rest/api/3/issue/createmeta/{proj}/issuetypes` (no cache); unknown name → exit 64 listing valid types; dry-run builder uses camelCase key with bare-string value (simplified, same model as priority) | — (issue #331 F2) | src/cli/issue/edit.rs::handle_edit_bulk_fields; src/api/jira/issues.rs::get_issue_types_for_project (new); tests/issue_bulk_pr2.rs | HIGH |
| BC-3.4.019 | `issue edit KEY1 KEY2 --type <NAME>` cross-project guard — when keys span >1 distinct Jira project (extracted by last-hyphen split), exit 64 with actionable message naming `--type` and the detected project keys, BEFORE any API call (no createmeta lookup, no bulk POST); per-project grouping is explicitly deferred to a future issue | — (issue #331 F2) | src/cli/issue/edit.rs::handle_edit (cross-project guard, pre-routing); tests/issue_bulk_pr2.rs | HIGH |
| BC-3.4.020 | `issue edit --label` routes single-key through `PUT /rest/api/3/issue/{key}` with bare-string labels; routes 2+ keys through `POST /rest/api/3/bulk/issues/fields` with `{"name":...}` objects — LOAD-BEARING asymmetry MUST NOT be unified (BUG-LABEL-400) | — (BC-subclause-pass F2 2026-06-30) | src/cli/issue/edit.rs::handle_edit_bulk_labels; src/api/jira/issues.rs::update_issue_labels; CLAUDE.md BUG-LABEL-400 | HIGH |
| BC-3.4.021 | `jr issue edit --dry-run` emits `plannedChanges` JSON or table preview on stdout without issuing any mutation HTTP call; `--output json` schema is `{dryRun: true, issues: [...], plannedChanges: {...}}`; preview shapes are intentionally simplified (labels flat array, priority bare string; `components` flat array added 2026-08-15 issue #605) | — (BC-subclause-pass F2 2026-06-30) | src/cli/issue/edit.rs::handle_edit dry-run block (implementation-defined) | HIGH |
| BC-3.4.022 | `issue edit KEY --component add:X --component remove:Y` (single-key) interprets prefix, sends native Jira `update`-verb PUT with `{"add":{"name":...}}`/`{"remove":{"name":...}}` object operations; editmeta-gated read-modify-write fallback | — (DEC-280, issue #605 F2) | src/cli/issue/edit.rs (pending F4); bc-8-components.md §8.4 | HIGH |
| BC-3.4.023 | `issue edit KEY1 KEY2 --component add:X` (multi-key/bulk) — `POST /bulk/issues/fields` with `multiselectComponents` object and integer `componentId`s; two sequential POSTs when both add:/remove: present | — (DEC-280, issue #605 F2) | src/cli/issue/edit.rs::handle_edit_bulk_fields (pending F4) | HIGH |
| BC-3.4.024 | `issue create --component X --component Y` (bare, no add:/remove: prefix) sets the initial `components` array (object-with-name form) on the create POST body | — (DEC-280, issue #605 F2) | src/cli/issue/create.rs (pending F4) | HIGH |
| BC-3.4.025 | `--component` name resolution: unknown/ambiguous → exit 64 pre-flight; single round-trip via project component-list GET (not editmeta) for name validation on create/list; editmeta separately gated for edit's wire-shape decision (BC-3.4.022) | — (DEC-280, issue #605 F2) | src/cli/issue/helpers.rs::resolve_component (pending F4); bc-8-components.md §8.4 | HIGH |
| BC-3.4.026 | `--field NAME:kind=VALUE` hint-syntax parser — `parse_field_kv` gains kind-tag parsing (`option`/`id`/`name`/`asset`), shared across all 3 `--field` call sites; splits on LAST `:` before `=`; Unicode-scalar-safe (FIX-F6-LRE-1 class); bare form (no `:kind`) unchanged/permanent | — (issue #578 F2) | src/cli/issue/create.rs::parse_field_kv (extended) | HIGH |
| BC-3.4.027 | `--field NAME:option=VALUE` hint — explicit opt-in to today's label/id auto-detect (byte-identical wire output to bare form); adds cascading `Parent>Child` composition for `option-with-child` fields — CONFIRMED per ADR-0019 §3 (Accepted 2026-08-25); split-on-first-`>`, `:id=` escape hatch | — (issue #578 F2) | Shares BC-3.4.016 resolution logic | HIGH |
| BC-3.4.028 | `--field NAME:id=VALUE` hint — bypasses `allowedValues` lookup entirely, sends `{"id":"<VALUE>"}` verbatim; server is sole validator | — (issue #578 F2) | Explicit spelling of BC-3.4.016 Step 1 id-bypass | HIGH |
| BC-3.4.029 | `--field NAME:name=VALUE` hint — sends `{"name":"<VALUE>"}` verbatim; `--field priority:name=X` MUST be byte-identical to `--priority X` | — (issue #578 F2) | Companion to BC-3.4.026 | HIGH |
| BC-3.4.030 | `--field NAME:asset=WORKSPACE:OBJECTID` hint — composes Assets object-reference array `[{workspaceId,id,objectId}]`; bare `:asset=<objectId>` resolves workspaceId from the existing per-profile cache (BC-4.2.001, corrected citation — was mis-cited as BC-4.1.001 in F1 mapping) | — (issue #578 F2) | Spans bc-3/bc-4; reuses `get_or_fetch_workspace_id` | HIGH |
| BC-3.4.031 | Malformed `--field NAME:kind=VALUE` hint edge cases — unknown kind, malformed `:asset` shapes, non-numeric objectId, empty `:kind`; exit 64 catalog companion to BC-3.4.026 | — (issue #578 F2) | Companion EC catalog | HIGH |

### 3.5 Comments (12 BCs: BC-3.5.001..BC-3.5.012)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-3.5.001 | `issue comment add <key> --internal` adds `sd.public.comment` property | BC-219 | src/api/jira/issues.rs | HIGH |
| BC-3.5.002 | `comment delete <KEY> --id <ID>` sends DELETE /rest/api/3/issue/{key}/comment/{id}; 204 → exit 0 | NEW #577 | src/api/jira/issues.rs::delete_comment | HIGH |
| BC-3.5.003 | `comment delete` requires --yes non-interactive; y/N interactive; --yes bypasses | NEW #577 | src/cli/issue/interactions.rs::handle_comment_delete | HIGH |
| BC-3.5.004 | `comment delete` 404 → exit 64 + Jira error body surfaced (NOT idempotent) | NEW #577 | src/cli/issue/interactions.rs::handle_comment_delete | HIGH |
| BC-3.5.005 | `comment edit` body-only PUT invariant: no "properties" key in PUT body when neither --internal nor --public | NEW #577 | src/api/jira/issues.rs::update_comment | HIGH |
| BC-3.5.006 | `comment edit --internal` sends properties:[{key:"sd.public.comment",value:{internal:true}}] | NEW #577 | src/api/jira/issues.rs::update_comment | MEDIUM-HIGH |
| BC-3.5.007 | `comment edit --public` sends properties:[{key:"sd.public.comment",value:{internal:false}}]; always-confirm | NEW #577 | src/api/jira/issues.rs::update_comment | MEDIUM-HIGH |
| BC-3.5.008 | `comment edit --public` confirmation gate: --no-input without --yes → exit 64; interactive y/N | NEW #577 | src/cli/issue/interactions.rs::handle_comment_edit | HIGH |
| BC-3.5.009 | `comment edit` body sources: --file/--stdin/positional/--markdown; missing body → exit 64 | NEW #577 | src/cli/issue/interactions.rs::handle_comment_edit | HIGH |
| BC-3.5.010 | `comment view <KEY> --id <ID>` GET with ?expand=properties; key-value + JSON output; 404 → exit 64 | NEW #577 | src/api/jira/issues.rs::get_comment | HIGH |
| BC-3.5.011 | --internal and --public mutually exclusive on comment edit; clap conflicts_with → exit 2 | NEW #577 | src/cli/mod.rs | HIGH |
| BC-3.5.012 | CLI breaking change: comment → subcommand group (add/delete/edit/view); old flat form → exit 2 + migration hint | NEW #577 | src/cli/mod.rs | HIGH |

### 3.6 Links (5 BCs: BC-3.6.001..005)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-3.6.001 | `issue link <k1> <k2> [--type T]` POSTs `/rest/api/3/issueLink`; default type "Relates" | BC-216; BC-1045 (R4) | src/api/jira/links.rs | HIGH |
| BC-3.6.002 | `issue link FOO-1 FOO-2 --type block` single-substring → exit 64 + `"Ambiguous link type"` + ZERO POST | BC-1080 (R4) | tests/issue_commands.rs:~1812-1867 | HIGH |
| BC-3.6.003 | `issue unlink FOO-1 FOO-2 --type block` single-substring → exit 64 + ZERO DELETE | BC-1081 (R4) | tests/issue_commands.rs:~1869-1920 | HIGH |
| BC-3.6.004 | `client.delete_issue_link("10001")` DELETEs `/rest/api/3/issueLink/10001`; accepts 204 | BC-1046 (R4) | tests/issue_commands.rs:~250-262 | HIGH |
| BC-3.6.005 | `client.list_link_types()` returns 3 link types from `/rest/api/3/issueLinkType` | BC-218; BC-1043 (R4) | tests/issue_commands.rs:~188-206 | HIGH |

### 3.7 Remote Links (4 BCs: BC-3.7.001..004)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-3.7.001 | `issue remote-link <key> --url X` POSTs `/issue/<key>/remotelink`; URL gains trailing slash from normalization | BC-222; BC-1126 (R4) | tests/issue_remote_link.rs:~19-84 | HIGH |
| BC-3.7.002 | `issue remote-link` defaults `--title` to URL when omitted | BC-223; BC-1127 (R4) | tests/issue_remote_link.rs:~87-147 | HIGH |
| BC-3.7.003 | `issue remote-link --url not-a-url` → exit 64 + `"--url"` + `"not a valid url"`; ZERO HTTP | BC-1130 (R4) | tests/issue_remote_link.rs:~259-301 | HIGH |
| BC-3.7.004 | `issue remote-link --url ftp://example.com` → exit 64 + `"http or https"` + `"ftp"` | BC-1131 (R4) | tests/issue_remote_link.rs:~309-348 | HIGH |

### 3.8 JSM Request Create + Platform-Path Pre-flight Guards + Auth-Conditional 401 Hints (17 BCs: BC-3.8.001..017) [Added 2026-05-18 issue #288; BC-3.8.010 added F1d pass-01; BC-3.8.011 added F1d pass-01; BC-3.8.012..013 added 2026-05-19 issue #383 F2; BC-3.8.014..015 added 2026-05-19 issue #384 F2; BC-3.8.016..017 added 2026-05-20 issue #385 F2; BC-3.8.002/010/011 modified 2026-05-20 issue #385 F2; BC-3.8.012..013 amended 2026-07-25 DEC-188 (warn→exit-64 pre-flight); BC-3.8.008 amended 2026-08-25 issue #578 F2 (hint-kind uniformity, wire-target substitution); BC-3.8.012 REVERSED 2026-08-25 issue #578 F2 DEC-310 (registered 2026-08-26) (--field guard removed; --on-behalf-of guard BC-3.8.013 unaffected) — no BC count change, in-place amendment]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-3.8.001 | `issue create --request-type <NAME\|ID>` dispatches to `POST /rest/servicedeskapi/request`; platform POST body, JSON response, and exit code unchanged when `--request-type` absent (unless `--on-behalf-of` present — exits 64 per BC-3.8.013; `--field` no longer exits 64 — reversed 2026-08-25 issue #578, resolves via `createmeta` per BC-3.3.010/BC-3.8.012) | — (issue #288 F2) | tests/issue_create_jsm.rs; src/cli/issue/create.rs | HIGH |
| BC-3.8.002 | JSM body uses `requestFieldValues` map; `serviceDeskId` resolved via `require_service_desk` from `--project`; non-JSM project error message is call-site-specific | — (issue #288 F2) | tests/issue_create_jsm.rs; src/api/jsm/servicedesks.rs | HIGH |
| BC-3.8.003 | `--request-type <NAME>` resolved via partial-match (case-insensitive); errors clean on Ambiguous, ExactMultiple, None with `jr requesttype list` hint | — (issue #288 F2) | tests/issue_create_jsm.rs; src/partial_match.rs | HIGH |
| BC-3.8.004 | `--request-type <ID>` (numeric string) bypasses name resolution | — (issue #288 F2) | tests/issue_create_jsm.rs | HIGH |
| BC-3.8.005 | `--summary` maps to `requestFieldValues.summary` (required by JSM API; mirrors platform required-summary) | — (issue #288 F2) | tests/issue_create_jsm.rs | HIGH |
| BC-3.8.006 | `--description` maps to `requestFieldValues.description`; `--markdown` triggers `markdown_to_adf` + `isAdfRequest: true` | — (issue #288 F2) | tests/issue_create_jsm.rs; src/adf.rs | HIGH |
| BC-3.8.007 | `--priority <NAME>`, `--label <X>` (repeatable) map to `requestFieldValues.priority` / `requestFieldValues.labels` (labels = plain string array; JSDSERVER-4564 caveat for priority) | — (issue #288 F2; F1d: hardened) | tests/issue_create_jsm.rs | HIGH |
| BC-3.8.008 | `--field NAME=VALUE` (repeatable) maps to `requestFieldValues`; first `=` splits; `customfield_NNNNN` bypasses lookup; duplicate NAME last-wins [AMENDED 2026-08-25 issue #578: hint-kind syntax (`:option`/`:id`/`:name`/`:asset`, BC-3.4.026-030) applies uniformly on this path too, targeting `requestFieldValues`; bare-form wire output is BYTE-IDENTICAL, unchanged] | — (issue #288 F2) | tests/issue_create_jsm.rs; src/api/jsm/requests.rs::JsmRequestBuilder::build (kind-aware dispatch) | HIGH |
| BC-3.8.009 | `--on-behalf-of <accountId>` maps to `raiseOnBehalfOf`; value passed through as-is (no client-side format validation); invalid accountIds rejected server-side | — (issue #288 F2; F1d: regex removed) | tests/issue_create_jsm.rs | HIGH |
| BC-3.8.010 | `--type` is IGNORED with stderr warning when `--request-type` is set; request type encodes the issue type | — (issue #288 F1d pass-01) | tests/issue_create_jsm.rs | HIGH |
| BC-3.8.011 | Platform-only flags (`--team`, `--points`, `--parent`, `--to`, `--account-id`) ignored on JSM path each emit one stderr warning; dispatch continues | — (issue #288 F1d pass-01 C-02) | tests/issue_create_jsm.rs | HIGH |
| BC-3.8.012 | ~~`--field` on platform path without `--request-type` exits 64 pre-flight~~ **[REVERSED 2026-08-25 issue #578, DEC-310, registered 2026-08-26]** `--field` NO LONGER exits 64 — resolves via `createmeta` and merges into the create POST body (see BC-3.3.010/011). DEC-188 [2026-07-25] text (~~emits one stderr warning; platform POST proceeds~~ → pre-flight exit 64) preserved inline in the BC body as `[DEC-188 BEHAVIOR, superseded]` for audit trail. Combined-error case removed (no remaining trigger); `--on-behalf-of`-alone guard (BC-3.8.013) UNAFFECTED, still exits 64 | — (issue #383 F2; amended SOH-DX-1 DEC-188; REVERSED issue #578 F2) | tests/issue_create_jsm.rs (pending F4 test inversion, mirrors DEC-188's own AC-1/2/3/5/7 inversion) | HIGH |
| BC-3.8.013 | `--on-behalf-of` on platform path without `--request-type` exits 64 pre-flight — **[AMENDED DEC-188 2026-07-25]** ~~emits one stderr warning; platform POST proceeds~~ → pre-flight `JrError::UserError` exit 64 BEFORE any HTTP when `--on-behalf-of` present without `--request-type`. **[UPDATED 2026-08-25 issue #578, DEC-310, registered 2026-08-26]** BC-3.8.012's combined-error check is REMOVED; the standalone `--on-behalf-of` guard here now fires unconditionally whenever `--on-behalf-of` is present without `--request-type`, including when `--field` is ALSO present (no combined error remains — `--field` no longer contributes to any pre-flight error) | — (issue #383 F2; amended SOH-DX-1 DEC-188; updated issue #578 F2) | tests/issue_create_jsm.rs | HIGH |
| BC-3.8.014 | Basic-auth 401 on JSM POST (`handle_jsm_create`) → API-token-expiry hint (no OAuth-scope language); any `InsufficientScope` variant rewritten to `NotAuthenticated`; gated by `client.is_oauth_auth() == false` | — (issue #384 F2) | tests/issue_create_jsm.rs | HIGH |
| BC-3.8.015 | OAuth 401 on JSM POST (`handle_jsm_create`) → `write:servicedesk-request` hint via `InsufficientScope` scope-mismatch path (deterministic); `NotAuthenticated` post-refresh path is pre-existing, out of #384 test scope; gated on `client.is_oauth_auth() == true` | — (issue #384 F2) | tests/issue_create_jsm.rs | HIGH |
| BC-3.8.016 | `--request-type ""` (empty string or whitespace-only after trim) exits 64 with "request type cannot be empty" before `partial_match` or numeric bypass; no HTTP issued | — (issue #385 F2) | tests/issue_create_jsm.rs; src/cli/issue/jsm_create.rs::handle_jsm_create | HIGH |
| BC-3.8.017 | `--markdown` + `--field description=<value>` combination rejected at parse-time in `handle_jsm_create`; exit 64; no HTTP; desync rationale: "may result in a JSM 400 error or silently dropped ADF formatting" (NOT asserted as certain) | — (issue #385 F2) | tests/issue_create_jsm.rs; src/cli/issue/jsm_create.rs::handle_jsm_create | HIGH |


### 3.9 Attachment Write (20 BCs: BC-3.9.001..020) [BC-3.9.001..014 added 2026-07-15 SOH-ATTACHMENTS-1 F2 DEC-179; BC-3.9.015..020 added 2026-07-15 adversary pass-1 round B]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-3.9.001 | Platform upload `POST /rest/api/3/issue/{key}/attachments`; multipart `file`-named parts; `X-Atlassian-Token: no-check` mandatory (CSRF bypass); streaming via ReaderStream; no client-side size cap; graceful 413 (actionable message) / 400 (Jira body surfaced); output channel profile 4; **`--dry-run` requires `--replace-existing` (EC-3.9.020-6, clap requires, exit 2)** (P19-004); **4-column upload echo table (Filename/Size/ID/Created) deliberately differs from 6-column list table** (P19-I1) | — (SOH-ATTACHMENTS-1 F2; P19-004; P19-I1) | src/cli/issue/attachments.rs (pending S3) | HIGH |
| BC-3.9.002 | Upload to JSM issue with no visibility flag → platform POST (internal by default per P2-4a; safe default; no servicedeskapi calls) | — (SOH-ATTACHMENTS-1 F2) | src/cli/issue/attachments.rs (pending S3) | HIGH |
| BC-3.9.003 | **Step 0 (P16-003)**: `GET /rest/api/3/issue/{key}` existence validation + `fields.project.key` extraction; 404→exit 64 (EC-3.9.012-2); projectTypeKey via `get_or_fetch_project_meta` NOT issue GET embedded fields; key-derivation deliberately equivalent to BC-3.9.017 step 0 (prefix vs `fields.project.key`); then: `--public` → servicedeskapi two-step (attachTemporaryFile + request/{key}/attachment public:true); serviceDeskId resolved via existing `get_or_fetch_project_meta` / `ProjectMeta` cache (BC-X.8.010); match `serviceDesk.projectId == project.id` (NOT projectKey — P6-001 correction); DEC-174 confirmation gate (eprint!+read_line, NOT dialoguer); --yes bypass; **non-interactive exit 64 before any servicedeskapi call and upload POST (Step-0 issue GET + meta resolution already ran; P22-001)**; cancel → `{"cancelled":true,"uploaded":false}`; **Step-0 suppression on combined path (P17-003)**: when entered from BC-3.9.017 step 4, Step 0 SKIPPED — existence validated by BC-3.9.017 step 1's `?fields=attachment` GET; ONE issue GET per invocation; **step-1 self-heal (SEC-576-006, P30-001)**: step-1 404/403 triggers BC-X.8.010 invalidate+retry-once BEFORE BC-3.9.012 mapping; post-retry 404→exit 64, 403→exit 1 | — (SOH-ATTACHMENTS-1 F2; P22-001; P30-001) | src/cli/issue/attachments.rs (pending S5) | HIGH |
| BC-3.9.004 | **Step 0 (P20-001, inherits BC-3.9.003 Step 0 + BC-3.9.005 detection)**: `GET /rest/api/3/issue/{key}` existence validation; `get_or_fetch_project_meta` → `projectTypeKey`. **(a) JSM branch** (`projectTypeKey == "service_desk"`): servicedeskapi two-step public:false; no confirmation gate; HTTP: issue GET → **project-meta resolution per BC-X.8.010 (up to 2 cache-miss GETs: GET /rest/api/3/project/{key} + GET /rest/servicedeskapi/servicedesk pagination for serviceDeskId)** → N × attachTemporaryFile → request-attachment (P21-004). **(b) Non-JSM OQ-9 silent no-op** (`projectTypeKey != "service_desk"`): platform POST `/rest/api/3/issue/{key}/attachments`; zero servicedeskapi calls; HTTP: issue GET → project GET (cache-miss) → platform POST. --internal + --public → clap exit 2. **EC-3.9.004-4 (P21-005)**: Step 0 SKIPPED when entered from BC-3.9.017 step 4 (`--replace-existing --internal`); existence validated by step 1 `?fields=attachment` GET; ONE issue GET per invocation | — (SOH-ATTACHMENTS-1 F2; P20-001; P21-004; P21-005) | src/cli/issue/attachments.rs (pending S5) | HIGH |
| BC-3.9.005 | `--public` on non-JSM issue → exit 64; canonical message "--public is only supported on Jira Service Management (JSM) issues."; JSM detection via `projectTypeKey == "service_desk"` (ProjectMeta path — P6-002); zero servicedeskapi calls; asymmetric from --internal (silent no-op on non-JSM); **EC-3.9.005-3 (P23-002)**: this eligibility guard fires even when `--dry-run` is supplied — eligibility guards are NOT dry-run-suppressed (contrast BC-3.9.014 gates; cross-ref EC-3.9.020-8) | — (SOH-ATTACHMENTS-1 F2; P23-002) | src/cli/issue/attachments.rs (pending S5) | HIGH |
| BC-3.9.006 | temporaryAttachmentId ~1h TTL; step-2 HTTP errors → retry hint "Temporary attachment IDs may have expired. Try the upload again." (4xx excl. 401/403 → exit 64; **429 deliberately no Retry-After auto-retry, P8-001/F5-R8-001** — asymmetric with step-1 `attachTemporaryFile` and platform upload, both of which retry 429; hint text imprecise for 429 sub-case, accepted; EC-3.9.006-7; 401 → exit 2; 403 → exit 1; 5xx → exit 1 `JrError::ApiError`); step-2 transport/network error → `JrError::NetworkError`, exit 1, `"Could not reach <host> — check your connection"`, **no retry hint** (parity with step-1 transport mapping); no Cloud error-string pattern-matching (P2-2); no ID caching or reuse; FIX-F5-006 (F5-R1-007) | — (SOH-ATTACHMENTS-1 F2; FIX-F5-006; P8-001/F5-R8-001) | src/api/jsm/attachments.rs (pending S5) | MEDIUM-HIGH |
| BC-3.9.007 | Post-upload echo: derived from platform POST response array in curated form (BC-2.7.002: `self` omitted, `content`→`contentUrl`; no secondary fetch); servicedeskapi response schema INCONCLUSIVE (P2-3c) — S5 live-capture obligation on EJ; JSDCLOUD-10841: `links.content` from servicedeskapi returns 404; **EC-3.9.007-1 platform-echo clause exercised in S3** (BC-3.9.001 + BC-3.9.009; R3.13 earliest-consumer principle); S5 owns JSM echo clauses (EC-3.9.007-2); P17-005 | — (SOH-ATTACHMENTS-1 F2) | src/cli/issue/attachments.rs (pending S3/S5) | MEDIUM |
| BC-3.9.008 | `attachment delete` → **AID validated `^[0-9]+$` before any HTTP** (P7-001: invalid → exit 64, zero HTTP); `DELETE /rest/api/3/attachment/{id}`; 204 = exit 0 with echo; 404 = exit 64 + surface Jira body (NOT silent exit 0 — DEC-168; mirrors BC-3.5.004 comment delete precedent) | — (SOH-ATTACHMENTS-1 F2; P7-001) | src/cli/issue/attachments.rs (pending S4) | HIGH |
| BC-3.9.009 | `attachment upload --output json`: array in curated form (BC-2.7.002: author, contentUrl, created, filename, id, mimeType, size — BTreeMap-alphabetical; `self` OMITTED, `content`→`contentUrl`); `output::render_json` required (#526 invariant); platform POST path only. **P24-001**: body text narrowed — download is EXCLUDED from the curated form; download uses `{"downloaded":[...]}` manifest (BC-2.7.007 EC-2.7.007-7) | — (SOH-ATTACHMENTS-1 F2; P19-001; P24-001) | src/cli/issue/attachments.rs (pending S3) | HIGH |
| BC-3.9.010 | `attachment delete --output json`: single `{"deleted":true,"id":"<AID>"}` or bulk `{"count":N,"deleted":true,"ids":[...]}` (BTreeMap-ordered keys); **bulk 404 = benign-skip per EC-3.9.010-4/BC-3.9.013** (P21-001: 404'd AID excluded from count/ids; iteration continues; NOT exit 64); first NON-404 failure → error JSON, no partial-success shape; **single-vs-bulk 404 divergence**: single-AID 404 exits 64 (BC-3.9.008); bulk 404 benign-skip (BC-3.9.013) — intentionally asymmetric; **EC-3.9.010-5 (P3-011)**: all-404 bulk delete human mode emits `"No attachments deleted (all were already removed or not found)."` to stderr — HINT (§3.9 taxonomy; JSON-suppressed; exit 0) | — (SOH-ATTACHMENTS-1 F2; P21-001; P3-011) | src/cli/issue/attachments.rs (pending S4) | HIGH |
| BC-3.9.011 | `attachment upload --public --output json` shape: DEFERRED-PROBE contract — P2-3c INCONCLUSIVE; S5 implementer must capture live EJ response and update this BC; #526 invariant applies regardless | — (SOH-ATTACHMENTS-1 F2) | src/cli/issue/attachments.rs (pending S5) | MEDIUM |
| BC-3.9.012 | Upload error taxonomy: file-not-found exit 64; issue-key 404 exit 64; --public non-JSM exit 64; **non-interactive-no-yes trigger: local (after Step-0 issue GET + meta fetch) — P22-001**; non-interactive-no-yes exit 64; 413 exit 1 (actionable, no numeric limit); 403 exit 1; 400 exit 1 (Jira body); 401 exit 2; 5xx exit 1; network exit 1; **step-1 attachTemporaryFile 403/404 carve-out (P30-001)**: BC-X.8.010 self-heal first; post-retry 404→exit 64, 403→exit 1 (per BC-X.8.010 step 4); **post-retry 401/5xx/network → BC-X.8.010 step 4 (same universal codes as first-occurrence; P31-003)** | — (SOH-ATTACHMENTS-1 F2; P22-001; P30-001; P31-003) | src/cli/issue/attachments.rs (pending S3/S5) | HIGH |
| BC-3.9.013 | Delete error taxonomy: **invalid AID (non-numeric) exit 64 zero HTTP** (P7-001 CWE-88 — prior "sent verbatim" text reversed); AID 404 exit 64 + Jira body surfaced (DEC-168); 403 exit 1; 401 exit 2; 5xx exit 1; network exit 1 | — (SOH-ATTACHMENTS-1 F2; P7-001) | src/cli/issue/attachments.rs (pending S4) | HIGH |
| BC-3.9.014 | `--public` confirmation gate mechanics: `eprint!` to stderr (NOT `eprintln!`) + `io::stdin().lock().read_line()`; NOT `dialoguer::Confirm`; DEC-174 ratified mechanism; prompt lists ≤3 filenames or "N files" summary; accepted 'y'/'yes' (case-insensitive); any other input → cancel; mirrors BC-3.5.007/BC-3.5.008; THREE consumers: (1) --public standalone, (2) --replace-existing ≥1-match, (3) combined (P15-002/R3.12); **three non-interactive exit-64 message variants (P17-004)**: (1) --public only; (2) --replace-existing ≥1-match; (3) combined; Source corrected S5→S3 body (P17-001) | — (SOH-ATTACHMENTS-1 F2) | src/cli/issue/attachments.rs (pending S3 — reallocated S5→S3 per R3.13; S5 consumes) | HIGH |
| BC-3.9.015 | `attachment delete <AID>` interactive confirmation gate: **AID validated `^[0-9]+$` before gate and metadata-GET** (P7-001: invalid → exit 64, zero HTTP); `eprint!+read_line` (DEC-174); non-interactive exit 64 + --yes hint; --yes bypasses; cancel `{"cancelled":true,"deleted":false}` (no id key); metadata-fetch GET before prompt; three-way branch: 'y'/'yes' → delete; empty-Enter → cancel exit 0; EOF (`Ok(0)`) or IO-error → `JrError::Interrupted` exit 130; mirrors BC-3.5.003/EC-3.5.003-3 (divergence note removed — P5-001 ruling); **metadata-fetch failure taxonomy (P16-005)**: 404→exit 64 (canonical only; no Jira body — read GET, not write; BC-2.7.012); 403→exit 1 (`"Permission denied: cannot access attachment <AID>."`); 401→exit 2 (`JrError::NotAuthenticated`; `jr auth login` hint); 5xx/network→exit 1; all fire BEFORE gate presentation; **403 pre-prompt metadata-GET override row added to error-taxonomy.md (P18-002)**; **--yes path skips metadata GET (P36-002)**: on the `--yes` path the pre-prompt metadata GET is NOT issued (its sole purpose is the prompt filename) — DELETE only, per BC-3.9.008; **display-sanitization cross-reference (SEC-576-011)**: `<filename>` in step 1 delete confirmation prompt MUST be display-sanitized (per BC-2.7.011 display-sanitization character set → `?`) before TTY write | — (SOH-ATTACHMENTS-1 adversary pass-1 R2; P5-001 correction; P7-001; P16-005; P18-002; P36-002; SEC-576-011) | src/cli/issue/attachments.rs (pending S4) | HIGH |
| BC-3.9.016 | `attachment delete --older-than` ALWAYS requires --yes (no interactive prompt for bulk); **multi-AID form: AID validated `^[0-9]+$` before --yes check** (P7-001: invalid → exit 64, zero HTTP); missing --yes → exit 64; --dry-run exempt from --yes gate (read-only); clap mutual-exclusion: positional-AID form incompatible with --issue/--older-than; **EC-3.9.016-6 multi-AID --yes path: 404 handling per BC-3.9.013 bulk exception (benign skip) — P22-002**; **CLI flags annotated (P30-I01)**: `<AID>...` positional 1+ when used, optional under required selector group; bare `delete` → exit 2 per clap section | — (SOH-ATTACHMENTS-1 adversary pass-1 R1; P7-001; P22-002; P30-I01) | src/cli/issue/attachments.rs (pending S4) | HIGH |
| BC-3.9.017 | `attachment upload --replace-existing`: same-filename lookup (case-sensitive); **≥1 match → confirmation gate (P15-002/R3.12)**: interactive y/N prompt listing would-delete (filename + AID); non-interactive without `--yes` → exit 64 — two sub-variants (P17-004): (A) no --public: `"Use --yes to confirm deletion of existing same-filename attachments."` (B) combined --public + ≥1 match: `"Use --yes to confirm uploading as customer-visible (public) and deleting existing same-filename attachments."`; zero matches → no gate; `--public` + ≥1 match → combined single-prompt; `--yes` bypasses all; `--dry-run` gate-exempt; delete ALL matching entries serially (OQ-6 last-write-wins); 404-on-DELETE = skip; non-atomic race window documented (JRACLOUD-96384/-78388); MUST NOT assert atomicity; 403/401/5xx-on-DELETE aborts with no upload; **VP-576-005 wire fix (P23-001)**: explicit servicedesk-list mount (2) (GET /rest/servicedeskapi/servicedesk) split from project GET mount (1); mounts renumbered 1→7; wire-completeness ECHO-BREAKER LIST-B added; **VP-576-005 story allocation (P23-003)**: verified in S5 (S5 depends_on S3), textual home BC-3.9.017, NOT S3 acceptance matrix; **display-sanitization cross-reference (SEC-576-011)**: all `<filenameN>` values in step 2 `--replace-existing` gate prompts MUST be display-sanitized (per BC-2.7.011 display-sanitization character set → `?`) before TTY write | — (SOH-ATTACHMENTS-1 adversary pass-1 R1; P15-002; P23-001; P23-003; SEC-576-011) | src/cli/issue/attachments.rs (pending S3) | HIGH |
| BC-3.9.018 | `attachment upload --replace-existing` zero-match path: skip delete phase; upload proceeds identically to plain upload; zero-match is SILENT (no annotation); flag is idempotent | — (SOH-ATTACHMENTS-1 adversary pass-1 R1) | src/cli/issue/attachments.rs (pending S3) | HIGH |
| BC-3.9.019 | `attachment delete --older-than <duration>`: --issue KEY required; dedicated `parse_age_duration` (d=24h clock-hours, w=7×24h calendar — NOT worklog semantics); `src/duration.rs` = syntax-style precedent only; `created` ISO 8601 compared client-side via `chrono`; invalid duration exit 64; bulk-delete JSON `{"count":N,"deleted":true,"ids":[...]}` (BTreeMap alphabetical: count < deleted < ids) via `output::render_json`; **`parse_age_duration` location TBD — private helper in attachments.rs or pub(crate) sibling in duration.rs (P26-004; impact-boundary R3.9a)**; **pre-deletion stderr summary = HINT (P30-002)**: `"Deleting N attachment(s)..."` JSON-suppressed (count in JSON `"count"` field; EC-2.7.008-6; human mode only) | — (SOH-ATTACHMENTS-1 adversary pass-1 R1; P26-004; P30-002) | src/cli/issue/attachments.rs (pending S4) | HIGH |
| BC-3.9.020 | `attachment --dry-run` (delete multi-path + upload `--replace-existing`): **path-b (multi-AID): AID validated `^[0-9]+$` before metadata fan-out** (P7-001: invalid → exit 64, zero HTTP, even on dry-run); multi-attachment paths list affected IDs without mutation; JSON `{"attachments":[{filename,id}],"dryRun":true,"ids":[...]}` (BTreeMap alphabetical at all depths: outer attachments < dryRun < ids; inner filename < id) via `output::render_json`; single-ID --dry-run = human stderr hint + JSON `{"attachments":[{"id":"<AID>"}],"dryRun":true,"ids":["<AID>"]}` exit 0 (no gate); --yes with --dry-run = DEC-169 silent no-op; **THREE-CATEGORY DRY-RUN TAXONOMY (P3-007)**: (1) confirmation gates (BC-3.9.014) SUPPRESSED; (2) eligibility guards (BC-3.9.005, BC-3.9.017 step 0) NOT suppressed (EC-3.9.020-7/8; P23-002); (3) pre-flight checks (BC-3.9.012 file-existence/`is_file()`) NOT suppressed — **EC-3.9.020-9 (P3-007)**: file pre-checks fire before any HTTP and exit 64 on failure even with `--dry-run`; **EC-3.9.020-8 (P23-002; P28-001 wire-enumeration corrected)**: `--replace-existing --dry-run --public` on non-JSM exits 64 before any list GET — only project-meta fetch fires; no issue GET; no servicedeskapi pagination for non-JSM project | — (SOH-ATTACHMENTS-1 adversary pass-1 R1; P7-001; P23-002; P28-001; P3-007) | src/cli/issue/attachments.rs (pending S4) | HIGH |

---

## Section 4: Assets & CMDB (bc-4-assets-cmdb.md) — 32 BCs cumulative; 22 individually-bodied

### 4.1 AQL / CMDB Field Resolution (7 BCs: BC-4.1.001..007)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-4.1.001 | `find_cmdb_fields()` filters by `schema.custom == "com.atlassian.jira.plugins.cmdb:cmdb-object-cftype"` | BC-301; BC-1137a (R4) | tests/cmdb_fields.rs:~50-83 | HIGH |
| BC-4.1.002 | `build_asset_clause` for single CMDB field emits `"<NAME>" IN aqlFunction("Key = \"<KEY>\"")` (NO outer parens) | BC-306, BC-306-R (R1) | src/jql.rs:~61-82 | HIGH |
| BC-4.1.003 | `build_asset_clause` uses `escape_value` for BOTH field name AND asset key | BC-307, BC-307-R (R1) | src/jql.rs:~67-74 | HIGH |
| BC-4.1.004 | Two CMDB fields → parenthesized OR-join: `("X" IN aqlFunction(...) OR "Y" IN aqlFunction(...))` | BC-308, BC-308-R (R1) | src/jql.rs:~77-81 | HIGH |
| BC-4.1.005 | `validate_asset_key("CUST-5")` → Ok; `"CUST"` → Err; `"5-CUST"` → Err | BC-309 | src/jql.rs:~39-54 | HIGH |
| BC-4.1.006 | `extract_linked_assets` reads `[{label, objectKey}]` shape → `LinkedAsset{key, name}` | BC-302; BC-1137c (R4) | tests/cmdb_fields.rs:~86-118 | HIGH |
| BC-4.1.007 | `extract_linked_assets` returns empty Vec for null custom field value | BC-303; BC-1137d (R4); BC-324 (R1) | tests/cmdb_fields.rs:~120-146 | HIGH |

### 4.2 Asset Search & View (9 BCs: BC-4.2.001..009)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-4.2.001 | `assets search` discovers workspace ID first (cache or API) | BC-310; BC-322 (R1) | tests/assets.rs | HIGH |
| BC-4.2.002 | `client.search_assets(workspace_id, aql, limit, include_attrs)` POSTs to `/jsm/assets/workspace/<id>/v1/object/aql` | BC-316 (R1) | tests/assets.rs:~39-80, 238-295 | HIGH |
| BC-4.2.003 | `AssetsPage::is_last` accepts both bool and string-encoded bool `"true"` | BC-317 (R1) | tests/assets.rs:~140-170 | HIGH |
| BC-4.2.004 | `client.get_asset(workspace_id, id, include_attrs=true)` GETs `/jsm/assets/workspace/<id>/v1/object/<oid>?includeAttributes=true` | BC-318 (R1) | tests/assets.rs:~172-203 | HIGH |
| BC-4.2.005 | `client.get_connected_tickets(workspace_id, oid)` GETs `/jsm/assets/workspace/<id>/v1/objectconnectedtickets/<oid>/tickets` | BC-319 (R1) | tests/assets.rs:~205-236 | HIGH |
| BC-4.2.006 | `assets tickets <KEY> --status PROG` ambiguous → exit 64 `Ambiguous status` + both candidates | BC-320 (R1) | tests/assets.rs:~1579-1684 | HIGH |
| BC-4.2.007 | `assets schema <TYPE-SUBSTR>` ambiguous → exit 64 `Ambiguous type` + NO per-type attribute fetch | BC-321 (R1) | tests/assets.rs:~1695-1799 | HIGH |
| BC-4.2.008 | `assets tickets --open` filters `status.colorName != "green"` (client-side) | BC-314 | src/cli/assets.rs:~303-321 | MEDIUM |
| BC-4.2.009 | `assets tickets --open` and `--status` clap conflict | BC-315 | tests/cli_smoke.rs:~51-58 | HIGH |

### 4.3 Asset Enrichment (3 BCs: BC-4.3.001..003)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| **BC-4.3.001** | **Asset enrichment `resolved` HashMap MUST be keyed by `(workspace_id, oid)` not `oid` alone [MUST-FIX: NFR-R-E]** | BC-147 (R1); NFR-R-E | src/cli/issue/list.rs:~440,446,449,456 | HIGH |
| BC-4.3.002 | `enrich_assets(client, &mut [LinkedAsset])` resolves ONLY assets with `id.is_some() && key.is_none() && name.is_none()` | BC-304; BC-323 (R1); BC-1137e (R4) | tests/cmdb_fields.rs:~148-189 | HIGH |
| BC-4.3.003 | `LinkedAsset::display()` falls back to `#<id> (run 'jr init' to resolve asset names)` when only id present | BC-305 | src/types/assets/linked.rs | HIGH |

### 4.4 Asset Error Handling (3 BCs: BC-4.4.001..003)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-4.4.001 | `assets search` 5xx → exit 1 + `API error (500)` + no panic | BC-311; BC-1136 (R4) | tests/assets_errors.rs:~21-64 | HIGH |
| BC-4.4.002 | `assets search` 401 → exit 2 + `Not authenticated` + `jr auth login` | BC-312 | tests/assets_errors.rs:~67-113 | HIGH |
| BC-4.4.003 | `assets search` network drop → exit 1 + `Could not reach` | BC-313 | tests/assets_errors.rs:~116-153 | HIGH |

---

## Section 5: Boards & Sprints (bc-5-boards-sprints.md) — 36 BCs cumulative; 18 individually-bodied

### 5.1 Board Commands (5 BCs: BC-5.1.001..005) [BC-5.1.005 added 2026-06-30 BC-subclause-pass F2]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-5.1.001 | `client.list_boards(project, type)` GETs `/rest/agile/1.0/board` with query params | BC-401 | tests/board_commands.rs | HIGH |
| BC-5.1.002 | `board view --limit --all` clap conflict | BC-408 | tests/board_commands.rs:~96-106 | HIGH |
| BC-5.1.003 | Auto-resolve board: list scrum boards for project, pick first | BC-410 | tests/sprint_commands.rs:~23-61 | HIGH |
| BC-5.1.004 | `client.get_sprint_issues(sprintId, jql, limit, fields)` with `limit=Some(3)` returns 3 issues, `has_more=true` | BC-409 | tests/board_commands.rs:~23-71 | HIGH |
| BC-5.1.005 | `jr board view` dispatches to sprint endpoints for scrum boards and JQL search for kanban boards; truncation hint emits to stderr; `--all` suppresses hint; scrum no-sprint → exit 1 | — (BC-subclause-pass F2 2026-06-30) | src/cli/board.rs::handle_view (implementation-defined) | HIGH |

### 5.2 Sprint Commands (8 BCs: BC-5.2.001..008)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-5.2.001 | `sprint list/current` errors on kanban boards with `"Sprint commands are only available for scrum boards"` | BC-402 | src/cli/sprint.rs:~79-86 | HIGH |
| BC-5.2.002 | `sprint add --sprint ID` and `sprint add --current` are mutually exclusive (clap) | BC-403 | tests/cli_smoke.rs:~116-123 | HIGH |
| BC-5.2.003 | `sprint add` requires `--sprint` or `--current` | BC-404 | tests/cli_smoke.rs:~126-133 | HIGH |
| BC-5.2.004 | `MAX_SPRINT_ISSUES = 50` caps `sprint add` and `sprint remove` | BC-405 | src/cli/sprint.rs:~35-61, 107 | MEDIUM |
| BC-5.2.005 | `sprint current` truncates to 30 by default; with `--all` returns full set; under-limit no hint | BC-406 | tests/sprint_commands.rs:~63-180 | HIGH |
| BC-5.2.006 | `sprint current --all --limit N` clap conflict | BC-407 | tests/cli_smoke.rs:~310-317 | HIGH |
| BC-5.2.007 | Sprint JSON output snapshot: sprint_add_response → `{"added": true, "issues": [...], "sprint_id": 100}` | BC-1113 (R4) | src/cli/snapshots/ | HIGH |
| BC-5.2.008 | Sprint JSON output: sprint_remove_response → `{"issues": [...], "removed": true}` (NO sprint_id) | BC-1114 (R4) | src/cli/snapshots/ | HIGH |

### 5.3 Team Column Parity (4 BCs: BC-5.3.001..004)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-5.3.001 | Team column appears IFF `team_field_id` configured AND at least one issue has populated team UUID | BC-1138a/c (R4) | tests/team_column_parity.rs::sprint_current_shows_team_column_when_populated | HIGH |
| BC-5.3.002 | Team column omitted when `team_field_id` not configured OR no issue has team UUID | BC-1138b/d (R4) | tests/team_column_parity.rs::test_board_view_omits_team_column_when_field_unconfigured (S-626-1) | HIGH |
| BC-5.3.003 | Team column falls back to bare UUID when team name is not in cache | BC-1138e (R4) | tests/team_column_parity.rs::sprint_current_falls_back_to_uuid_when_team_not_cached | HIGH |
| BC-5.3.004 | `--output json` preserves team UUID without resolution (no cache lookup) | BC-1138f (R4) | tests/team_column_parity.rs::sprint_current_json_output_keeps_team_uuid_without_resolution | HIGH |

### 5.4 API Layer (1 BC: BC-5.4.001)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-5.4.001 | `IssueFields::team_id` accepts string-UUID + object `{id}` form | BC-606 | src/types/jira/issue.rs:~101-131 | HIGH |

---

## Section 6: Config & Cache (bc-6-config-cache.md) — 44 BCs cumulative; 34 individually-bodied [BC-6.1.015 added 2026-09-01 cycle-003 `auth-profile-dx` F2 spec evolution — `ProfileConfig.env` config-schema tag, DEC-314; BC-6.2.015 amended in place — ADR-0011 hard-fence un-defer, DEC-317]

### 6.1 Configuration (15 BCs: BC-6.1.001..015) [BC-6.1.015 added 2026-09-01 cycle-003 `auth-profile-dx` F2 — `ProfileConfig` gains additive `env: Option<String>` tag, DEC-314]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-6.1.001 | Legacy `[instance]/[fields]` blocks migrate to `[profiles.default]` on first load | BC-901 | tests/migration_legacy.rs:~93-143 | HIGH |
| BC-6.1.002 | Migration is idempotent: second load produces byte-identical file | BC-902 | tests/migration_legacy.rs:~145-172 | HIGH |
| BC-6.1.003 | Migration write-back uses file-only baseline (no env overlay bleeds to disk) | BC-903; BC-153 (R1) | src/config.rs:~240-264 | HIGH |
| BC-6.1.004 | `validate_profile_name` rejects: empty, >64 chars, non-`[A-Za-z0-9_-]`, reserved Windows names (case-insensitive) | BC-904; BC-904-R (R1) | src/config.rs:~113-140 | HIGH |
| BC-6.1.005 | Profile-name validation runs at THREE boundaries: TOML key iteration, resolved active name, CLI flag | BC-152 (R1) | src/config.rs:~269-282, 308-310 | HIGH |
| BC-6.1.006 | `resolve_active_profile_name` precedence: cli_flag → env_var → global.default_profile → "default" | BC-905; BC-905-R (R1) | src/config.rs | HIGH |
| BC-6.1.007 | `Config::load_with(cli_profile)` strict — errors with `"unknown profile: <X>; known: <list>"` | BC-906; BC-906-R (R1) | src/config.rs:~319-328 | HIGH |
| BC-6.1.008 | `Config::load_lenient_with` skips active-profile existence check (used ONLY by `jr auth login`) | BC-907; BC-907-R (R1) | src/config.rs:~285-289 | HIGH |
| BC-6.1.009 | Default `[defaults] output = "table"` | BC-908 | src/config.rs:~63-74 | HIGH |
| BC-6.1.010 | `JR_BASE_URL` env completely overrides profile URL (test/power-user) | BC-909 | src/config.rs:~351-353 | HIGH |
| BC-6.1.011 | `find_project_config()` walks up cwd to filesystem root looking for `.jr.toml`; returns first match | BC-911; BC-911-R (R1) | src/config.rs:~340-353 | HIGH |
| BC-6.1.012 | User-facing migration message emitted to stderr exactly once per process | BC-151 (R1) | src/config.rs:~262-265 | HIGH |
| BC-6.1.013 | `JR_PROFILE` env override for active profile; scrubbed by tests to prevent direnv pollution | BC-154 (R1) | tests/auth_profiles.rs:~9-32 | HIGH |
| BC-6.1.014 | On Windows, `global_config_dir()` resolves to `%APPDATA%\jr\` via `dirs::config_dir()`; XDG env vars NOT consulted on Windows; Unix behavior unchanged | — (windows-build F2 2026-06-12) | src/config.rs::global_config_dir() | HIGH |
| BC-6.1.015 | `ProfileConfig` gains an additive `env: Option<String>` environment/role tag — free-form (not enum-validated), tolerant reader (`None` when absent, no migration); display owned by BC-1.6.046/BC-1.6.047 [NEW 2026-09-01 cycle-003, DEC-314] | — | ADR-0020 §4; src/config.rs::ProfileConfig (F4 target) | HIGH |

### 6.2 Cache (18 BCs: BC-6.2.001..018)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-6.2.001 | `read_cache<T>` returns `Ok(None)` for NotFound; propagates other I/O errors | BC-1001; BC-1001-R (R1) | src/cache.rs:~14-34 | HIGH |
| BC-6.2.002 | `read_cache<T>` returns `Ok(None)` AND stderr warning for parse failure | BC-1002; BC-1002-R (R1) | src/cache.rs:~23-26 | HIGH |
| BC-6.2.003 | TTL check: `(Utc::now() - fetched_at).num_days() >= CACHE_TTL_DAYS (7)`; exactly 7 days is expired | BC-1003; BC-1003-R (R1) | src/cache.rs:~7, 30-32 | HIGH |
| BC-6.2.004 | Per-profile cache directory — platform-conditional root: Unix `~/.cache/jr/v1/<profile>/`; Windows `%LOCALAPPDATA%\jr\v1\<profile>\`; `v1/` versioning preserved on all platforms [UPDATED windows-build F2 2026-06-12] | BC-1004; windows-build F2 | src/cache.rs:~7, 30, 76-78 | HIGH |
| BC-6.2.005 | `clear_profile_cache(name)` is no-op when directory doesn't exist (does NOT error) | BC-1005; BC-1005-R (R1) | src/cache.rs:~82-88 | HIGH |
| BC-6.2.006 | `cmdb_fields.json` stores (id, name) tuples; old ID-only format → cache miss (graceful) | BC-1006 | src/cache.rs:~237-247 | HIGH |
| BC-6.2.007 | `ProjectMeta` map cache `project_meta.json` keyed by project key; per-entry TTL | BC-1007 | src/cache.rs:~105-143 | HIGH |
| BC-6.2.008 | `ResolutionsCache` drops resolutions without `id` on write + stderr warning | BC-1008 | src/cli/issue/workflow.rs:~117-133 | HIGH |
| BC-6.2.009 | Cross-profile isolation: writing `prod` cache does NOT make `sandbox` cache visible | BC-1011 (R1) | src/cache.rs:~389-406 | HIGH |
| BC-6.2.010 | `clear_profile_cache("prod")` does NOT delete `sandbox` data | BC-1012 (R1) | src/cache.rs:~408-439 | HIGH |
| BC-6.2.011 | Corrupt cache files (garbage data + valid-JSON-wrong-shape) both return `Ok(None)` | BC-1013 (R1) | src/cache.rs:~808-861 | HIGH |
| BC-6.2.012 | `write_project_meta` MERGES into existing map; corruption recovery → fresh start + stderr warning | BC-1014 (R1) | src/cache.rs:~146-173 | HIGH |
| BC-6.2.013 | `write_object_type_attr_cache` MERGES into existing per-type map; same corruption recovery pattern | BC-1015 (R1) | src/cache.rs:~318-354 | HIGH |
| BC-6.2.014 | Cache write is non-atomic (`std::fs::write`); crash mid-write leaves truncated file; read-side resilient | BC-1016 (R1) | src/cache.rs:~42, 171, 351 | HIGH |
| BC-6.2.015 | Every cache reader/writer takes `profile: &Profile` as its first parameter (compile-time hard fence via `Profile(String)` newtype) [AMENDED 2026-09-01 cycle-003, DEC-317 — ADR-0011 un-deferred (Deferred→Accepted); design ACCEPTED, implementation PENDING (F4 story `S-cycle3-adr0011-newtype`); supersedes the prior soft-fence convention] | NFR-SCA-2; ADV-P1-019 | src/cache.rs (all public functions; F4 target for `Profile` typing) | HIGH |
| BC-6.2.016 | On Windows, `cache_root()` resolves to `%LOCALAPPDATA%\jr\` via `dirs::cache_dir()`; per-profile path `%LOCALAPPDATA%\jr\v1\<profile>\`; XDG env vars NOT consulted on Windows; Unix behavior unchanged | — (windows-build F2 2026-06-12) | src/cache.rs::cache_root() | HIGH |
| BC-6.2.017 | `JR_CONFIG_DIR` / `JR_CACHE_DIR` env vars override config/cache directory in debug builds (compiled out in release); seam checked before OS-platform branch; mirrors `JR_BASE_URL` debug-gate pattern; `tests/config_dir_release_gate.rs` pins the gate | — (windows-build F2 2026-06-12) | src/config.rs::global_config_dir(); src/cache.rs::cache_root(); tests/config_dir_release_gate.rs | HIGH |
| BC-6.2.018 | Warm cache hit (within TTL) returns cached value and issues ZERO HTTP calls to backing endpoint; invariant holds for all nine cache families; 7 families (teams, workspace, CMDB fields, Jira fields, resolutions, request-types, RT-fields) route through `read_cache<T>` generic warm-hit path; 2 families (project-meta, object-type-attrs) implement equivalent bespoke inline warm paths at `src/cache.rs::read_project_meta` and `src/cache.rs::read_object_type_attr_cache`; no-HTTP property verified by two techniques — `expect(1)` call-count pin (request-type families) and absence-of-mount (fields family) | — (2026-06-27) | src/cache.rs::read_cache; src/cache.rs::read_project_meta; src/cache.rs::read_object_type_attr_cache; tests/requesttype_commands.rs; tests/issue_edit_field.rs | HIGH |

### 6.3 Multi-Profile Fields — MUST-FIX (1 BC: BC-6.3.001)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| **BC-6.3.001** | **Per-profile `story_points_field_id` and `team_field_id` survive `Config::save_global()` and are read by ALL hot-path read sites [MUST-FIX: NFR-R-D — CRITICAL]** | NFR-R-D; NEW-INV-12; NEW-INV-143 | 14 sites in src/ | HIGH |

---

## Section 7: Output Rendering (bc-7-output-render.md) — 93 BCs cumulative; 49 individually-bodied

### 7.1 Table / JSON Output (5 BCs: BC-7.1.001..005)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-7.1.001 | `--output table` uses comfy-table renderer; `--output json` emits structured JSON | BC-1101 | src/output.rs | HIGH |
| BC-7.1.002 | `--no-color` and `NO_COLOR` env disable ANSI escape sequences | BC-1102 | src/main.rs:~13-15 | HIGH |
| BC-7.1.003 | `--no-input` auto-enables when stdin is not a TTY (`IsTerminal` check) | BC-1103 | src/main.rs:~18-23 | HIGH |
| BC-7.1.004 | Truncation hint emitted to stderr (NOT stdout); `--all` suppresses hint | BC-1110, BC-1111 | tests/sprint_commands.rs:~97-100, 175-179 | HIGH |
| BC-7.1.005 | `--output json` error shape: `{"error": "<message>", "code": <exit>}` to stderr | BC-1208 | src/main.rs:~34-49 | MEDIUM |

### 7.2 ADF Rendering (15 individually-bodied BCs: BC-7.2.001..015; 59 BCs cumulative including range-collapsed)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-7.2.001 | `text_to_adf("hello")` emits standard ADF doc shape | BC-1104 | src/adf.rs::tests | HIGH |
| BC-7.2.002 | `markdown_to_adf("**bold**")` emits marks `[{type:"strong"}]` on the text node | BC-1105 | src/adf.rs::tests | HIGH |
| BC-7.2.003 | ADF markdown round-trip covers: headings, lists, code blocks, blockquotes, tables, links | BC-1117 (R4) | src/snapshots/ | HIGH |
| BC-7.2.004 | ADF→text rendering: table render, code, headings preserved; lossy nodes silently dropped | BC-1106; BC-1116 (R4) | src/adf.rs::tests | HIGH |
| BC-7.2.005 | `markdown_to_adf("**bold text**")` body on wire: `marks: [{type: "strong"}]`; `text` is `"bold text"` NOT `"**bold text**"` | BC-1056 (R4) | tests/issue_commands.rs:~647-687 | HIGH |
| BC-7.2.006 | `markdown_to_adf` normalizes listItem children: blockquote→unwrap, heading→paragraph, table→paragraphs, rule→drop (ADF listItem content-model conformance) | issue #470 / PR #477 | src/adf.rs::normalize_list_item_content; src/adf.rs::flatten_table_to_paragraphs; src/adf.rs::tests | HIGH |
| BC-7.2.007 | `markdown_to_adf` maps `^x^`→`subsup` sup and `~x~`→`subsup` sub; double-tilde `~~x~~` stays `strike`; `adf_to_text` round-trip lossless for standalone `^x^`/`~x~`; dedup_marks_by_type prevents duplicate mark types | issue #474 | src/adf.rs::markdown_to_adf; src/adf.rs::dedup_marks_by_type; src/adf.rs::apply_marks; src/adf.rs::tests | HIGH |
| BC-7.2.008 | `markdown_to_adf` consumes heading attribute syntax `## Title {#id}` instead of leaking it into heading text; id/class/key-val forms all consumed and dropped | issue #474 | src/adf.rs::markdown_to_adf (ENABLE_HEADING_ATTRIBUTES); src/adf.rs::tests | HIGH |
| BC-7.2.009 | `markdown_to_adf` maps GFM alerts (`> [!NOTE\|TIP\|IMPORTANT\|WARNING\|CAUTION]`) to ADF `panel` (info/success/note/warning/error) with content-model normalization (no nested panel/table/blockquote; listItem rejects panel); `adf_to_text` renders `panel` back to a `> [!KIND]` alert | issue #483 | src/adf.rs::panel_type_for; src/adf.rs::normalize_panel_content; src/adf.rs::gfm_label_for_panel_type; src/adf.rs::tests | HIGH |
| BC-7.2.010 | `markdown_to_adf` maps GFM task lists (`- [ ] …` / `- [x] …`) to ADF `taskList`/`taskItem` nodes; `state: "TODO"/"DONE"` (uppercase); localId counter-based strings; mixed list promotes whole container to `taskList`; inline-only content model; `normalize_list_item_content` gains `taskList` arm (unwrap); blockquote normalizes `taskList` to paragraphs; panel passes `taskList` through; empty task item/list pruned; `adf_to_text` renders back to `- [ ]`/`- [x]`; `[X]` uppercase recognized | issue #471 | src/adf.rs::markdown_to_adf; src/adf.rs::normalize_list_item_content; src/adf.rs::is_empty_block_container; src/adf.rs::adf_to_text; src/adf.rs::tests | HIGH |
| BC-7.2.011 | `markdown_to_adf` preserves block-level HTML as literal text in a `paragraph`; interior newlines → `hardBreak` nodes (never raw `\n` in text-node string); trailing `\r\n` trimmed; `autolink_bare_urls` applies to resulting text nodes; `adf_to_text` round-trips losslessly **at the line-structure level** for non-URL-bearing content (byte-identical only for already-normalized LF-only inputs — 5 required conditions: (1) LF-only/no `\r` [EC-1, forward]; (2) no leading newline [EC-8, forward]; (3) no trailing newline [EC-2, forward]; (4) final line not ending in non-newline whitespace [EC-10, reverse]; (5) no bare URL at autolink boundary [EC-4, forward/post-pass] — see BC body Behavior for full forward/reverse breakdown); CRLF/lone-`\r` normalize to `\n`; supersedes #489 raw-`\n`-in-text behavior (defect, issue #492); **extended by issue #522 (F5-revised context-aware + F5-R2 bare-`\n`):** `push_text` uses CONTEXT-AWARE CR/LF dispatch: non-codeBlock contexts (`\r\n`→space, lone `\r`→space, AND bare `\n`→space — chokepoint self-sufficient per INV-1, defense-in-depth); codeBlock (`\r`→`\n`, bare `\n` preserved); HtmlBlock (untouched — Algorithm B owns it); `push_code` (`\r`→space AND bare `\n`→space, defense-in-depth); together no raw `\r` or non-codeBlock `\n` survives into any text node (ALL block types — not just block HTML); COMP-1 scope: Unicode line separators U+2028/U+2029/U+0085/U+000B/U+000C are OUT OF SCOPE — passed through verbatim (Jira accepts them; INV-1 covers ASCII `\r`/`\n` only); **EC-12 (issue #522 plain-text extension):** `text_to_adf` plain-text write path — third INV-1 chokepoint: interior `\r`/`\n`/`\r\n` → `hardBreak` nodes (never raw in text-node string); blank lines → separate `paragraph` nodes; trailing `\r`/`\n` stripped; single-line inputs byte-identical to pre-fix output (no regression) | issues #492, #522 | src/adf.rs::AdfBuilder::end (HtmlBlock arm); src/adf.rs::AdfBuilder::push_text (context-aware CR/LF norm, issue #522 + F5-R2); src/adf.rs::AdfBuilder::push_code (inline code CR/LF norm, issue #522 + F5-R2); src/adf.rs::text_to_adf (plain-text path CR/newline norm, issue #522 EC-12); src/adf.rs::autolink_bare_urls; src/adf.rs::AdfRenderer::finish; src/adf.rs::tests | HIGH |
| BC-7.2.012 | `markdown_to_adf` and `adf_to_text` enforce `MAX_ADF_DEPTH = 256` (inclusive rejection boundary); inputs exceeding the limit return exit 64 with stable substring `"nesting too deep (max 256 levels)"` rather than causing stack overflow (CWE-674); two distinct messages: forward path emits `"markdown nesting too deep (max 256 levels)"`, reverse path emits `"ADF response nesting too deep (max 256 levels) — …"`; depth check applied before recursing into children; `text_to_adf` is non-recursive and exempt | SEC-001 | src/adf.rs recursion guards; tests/adf_recursion_depth.rs; src/adf.rs::tests | HIGH |
| BC-7.2.013 | `markdown_to_adf` maps footnote references (`[^label]`) to plain unmarked `[label]` text markers via `push_footnote_marker` (bypasses `push_text` and active marks); definitions flushed at `finish()` into `rule`-separated appended section as `[label] `-prefixed paragraphs; duplicate labels silently deduped (first wins); empty **blockquote** shells left by blockquote-definition hoisting are pruned by `is_empty_block_container` (EC-6); **list-enclosed definitions are NOT pruned** — the `listItem` retains a valid placeholder empty paragraph (EC-7); footnote-only doc gets no leading rule | issue #472 | src/adf.rs::AdfBuilder::push_footnote_marker; src/adf.rs::AdfBuilder::finish (footnote flush); src/adf.rs::AdfBuilder::end (FootnoteDefinition arm); src/adf.rs::is_empty_block_container; src/adf.rs::tests (footnote unit tests) | HIGH |
| BC-7.2.014 | `markdown_to_adf` post-`finish()` pass (`autolink_bare_urls`) converts bare `http(s)://` URLs in ADF text nodes to `link`-marked text nodes; `www.`-prefix and bare emails out of scope; boundary: text-node start or whitespace/`*_~(`; trailing `?!.,:*_~` trimmed; unbalanced `)` trimmed; text nodes carrying `link` or `code` marks and all `codeBlock` content skipped; href sliced from original text (casing preserved); bare URL round-trips to `[url](url)` via `adf_to_text` | issue #473 | src/adf.rs::autolink_bare_urls; src/adf.rs::find_bare_url_spans; src/adf.rs::trim_url_extent; src/adf.rs::split_text_node_on_urls; src/adf.rs::tests (bare-url unit tests) | HIGH |
| BC-7.2.015 | A text node emitted by `markdown_to_adf` carrying a `code` mark may only additionally carry `link` and/or `annotation`; all typographic marks (`strong`, `em`, `strike`, `subsup`, `underline`, `textColor`, `backgroundColor`) are stripped at emission time in `push_code`; surrounding non-code text nodes retain their marks; `adf_to_text` read-tolerance for legacy typographic+code nodes retained | issue #571 | src/adf.rs::push_code; src/adf.rs::tests | HIGH |
| BC-7.2.016..059 | Additional ADF contracts (range-collapsed from bc-7 body) [range-collapsed; not individually-bodied] | BC-1106..1117 | src/adf.rs::tests | HIGH |

### 7.3 Error Display (10 BCs: BC-7.3.001..010)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-7.3.001 | `extract_error_message` 7-step precedence chain (empty body → literal string FIRST; no None/status-derived path) | BC-1201-R (R1); ADV-P2-001 | src/api/client.rs:~448-490 | HIGH |
| BC-7.3.002 | `errors{}` string values: `field: <value>`; non-string: `field: <serde_json::Value debug>` | BC-1201a (R1) | src/api/client.rs:~469-475 | HIGH |
| BC-7.3.003 | `errors{}` iteration is alphabetically sorted (deterministic) | BC-1201b (R1) | src/api/client.rs:~477 | HIGH |
| BC-7.3.004 | Empty `errorMessages[]` and empty `errors{}` fall through to raw body (no early exit) | BC-1201c (R1) | src/api/client.rs:~459-466 | HIGH |
| BC-7.3.005 | `--output json` + empty 4xx body → stderr JSON `{"error": "<empty response body>", "code": <exit>}` (literal string, not status-derived) | BC-1208; ADV-P1-026; ADV-P2-001 | src/main.rs:~34-49 | HIGH |
| BC-7.3.006 | `JrError::exit_code()` mapping | BC-1204 | src/error.rs:~51-62 | HIGH |
| BC-7.3.007 | All API errors must suggest a next step (CLAUDE.md convention) | BC-1212 | tests/*_errors.rs | HIGH |
| BC-7.3.008 | stderr must NEVER contain `panic` | BC-1205 | 16+ tests | HIGH |
| BC-7.3.009 | Internal errors prefix with `Internal error:` | BC-1213 | src/error.rs:~30-36 | MEDIUM |
| BC-7.3.010 | Every `--output json` path routes through `output::render_json` or `output::print_output` (direct `serde_json::to_string_pretty` / compact `json!` Display calls are forbidden); SUCCESS stdout JSON is pretty-printed via `render_json`; on error, compact single-line `{"error": "<message>", "code": <exit>}` to STDERR (built by `src/main.rs::main` via `json!` Display) and stdout is EMPTY | issue #526 | src/output.rs::render_json; src/output.rs::print_output; src/main.rs::main (error routing); src/cli/**/*.rs (all handlers) | HIGH |

### 7.4 JSON Output Shapes (16 BCs: BC-7.4.001..016)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-7.4.001 | move changed → `{"changed": true, "key": "TEST-1", "status": "In Progress"}` | BC-1104 (R4) | src/cli/issue/snapshots/ | HIGH |
| BC-7.4.002 | move unchanged → `{"changed": false, "key": "TEST-1", "status": "Done"}` | BC-1105 (R4) | src/cli/issue/snapshots/ | HIGH |
| BC-7.4.003 | assign changed → `{...assignee_account_id...}` — `assignee_account_id` is snake_case | BC-1106 (R4) | src/cli/issue/snapshots/ | HIGH |
| BC-7.4.004 | unassign → `{"assignee": null, "changed": true, "key": "TEST-1"}` — `assignee` is EXPLICIT null | BC-1108 (R4) | src/cli/issue/snapshots/ | HIGH |
| BC-7.4.005 | edit → `{"key": "TEST-1", "updated": true}` — minimal 2-key shape | BC-1109 (R4) | src/cli/issue/snapshots/ | HIGH |
| BC-7.4.006 | link → `{"key1": "TEST-1", "key2": "TEST-2", "linked": true, "type": "Blocks"}` | BC-1110 (R4) | src/cli/issue/snapshots/ | HIGH |
| BC-7.4.007 | unlink → `{"count": 2, "unlinked": true}`; no-match → `{"count": 0, "unlinked": false}` | BC-1111 (R4) | src/cli/issue/snapshots/ | HIGH |
| BC-7.4.008 | remote-link → `{"id": 10000, "key": "TEST-1", "self": <url>, "title": <title>, "url": <url>}` | BC-1112 (R4) | src/cli/issue/snapshots/ | HIGH |
| BC-7.4.009 | sprint add → `{"added": true, "issues": [...], "sprint_id": 100}` — sprint_id snake_case | BC-1113 (R4) | src/cli/snapshots/ | HIGH |
| BC-7.4.010 | sprint remove → `{"issues": [...], "removed": true}` — NO sprint_id | BC-1114 (R4) | src/cli/snapshots/ | HIGH |
| BC-7.4.011 | auth list table → 4 cols: NAME, URL, AUTH, STATUS; active prefix `* ` (asterisk-space) | BC-1115 (R4) | src/cli/snapshots/ | HIGH |
| BC-7.4.012 | `user view` hidden email → table shows em-dash `—`; JSON output shows explicit `null` | BC-1132j, BC-1132k (R4) | tests/user_commands.rs | HIGH |
| BC-7.4.013 | `auth login --output json` emits `{"profile": <name>, "action": "login", "ok": true}` to stdout on success | bc-7-output-render.md (BC-7.4.013 section) | src/cli/auth.rs::handle_login (JSON branch); src/cli/auth.rs::auth_json_response | HIGH |
| BC-7.4.014 | `auth switch --output json` emits `{"profile": <name>, "action": "switch", "ok": true}` to stdout on success | bc-7-output-render.md (BC-7.4.014 section) | src/cli/auth.rs::handle_switch (JSON branch); auth_json_response | HIGH |
| BC-7.4.015 | `auth logout --output json` emits `{"profile": <name>, "action": "logout", "ok": true}` to stdout on success | bc-7-output-render.md (BC-7.4.015 section) | src/cli/auth.rs::handle_logout (JSON branch); auth_json_response | HIGH |
| BC-7.4.016 | `auth remove --output json` emits `{"profile": <name>, "action": "remove", "ok": true}` to stdout on success | bc-7-output-render.md (BC-7.4.016 section) | src/cli/auth.rs::handle_remove (JSON branch); auth_json_response | HIGH |

### 7.5 Observability (3 BCs: BC-7.5.001..003)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-7.5.001 | Verbose request logging emits `[verbose] METHOD URL` + `[verbose] body: <utf8>` | BC-1405; BC-1405-R (R1) | src/api/client.rs:~197-204, 274-279 | HIGH |
| BC-7.5.002 | `log_parse_failure_once` gate — parse failure logged at most once per (process, key) | BC-1109 | src/observability.rs | MEDIUM |
| BC-7.5.003 | `format_duration(seconds)` collapses to `30m` / `2h` / `1h30m` (hours+minutes only) | BC-1107 | src/duration.rs:~52-60 | HIGH |

---

## Section 8: Component Management (bc-8-components.md) — 28 BCs cumulative; 28 individually-bodied [NEW FILE, added 2026-08-15 F2 component-management bundle, issues #604/#605/#606/#608]

`jr component` governs classic Jira Software/Core project components only, NOT Atlassian
Compass Components (a separate product/API surface). Cross-file consumers: `issue create/edit
--component` wire-shape contracts live in bc-3-issue-write.md §3.4 (BC-3.4.022..025); the
`issue list --component` filter contracts live in bc-2-issue-read.md §2.1 (BC-2.1.018..022).
Both consume this file's §8.4 resolver contracts and the `Component.id` struct field added by
BC-2.3.040.

### 8.1 Component Read & CRUD (8 BCs: BC-8.1.001..008)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-8.1.001 | `jr component list [--project KEY]` GETs `/rest/api/3/project/{key}/components` (non-paginated); renders table (id, name, description, lead, assigneeType) | — (F1 delta analysis, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.1.002 | `jr component list --output json` returns array of full component objects (all fields, no `-` placeholder) via `output::render_json` | — (F1 delta analysis, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.1.003 | `jr component list --counts` enriches each row with `relatedIssueCounts` via N+1 GETs; per-component failure is fail-soft (`?`/`null`, stderr warning, exit 0) | — (research 2026-08-15, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.1.004 | `jr component list`/`edit`/`delete` (single-project forms) with no `--project` and no configured project → exit 64 (numeric-id edit/delete are exempt — see EC-8.1.004-6..8) | — (precedent BC-2.1.006, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.1.005 | `jr component create --project KEY NAME [--description D] [--lead NAME] [--assignee-type TYPE]` POSTs `/rest/api/3/component` | — (F1 delta analysis, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.1.006 | `--lead <NAME>` resolves display name to `accountId` via assignable-user search; ambiguous/no-match aborts BEFORE the mutating HTTP call | — (precedent BC-X.7.004/BC-3.1.002, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.1.007 | `jr component edit NAME\|ID [--project KEY] [--name N] [--description D] [--lead NAME]` PUTs `/rest/api/3/component/{id}`; only supplied fields sent (partial update) | — (F1 delta analysis, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.1.008 | Unknown component `NAME\|ID` on edit/delete/rename → exit 64 taxonomy-consistent message; numeric bypass mirrors `requesttype fields` convention | — (CLAUDE.md Gotcha precedent, issue #604) | src/cli/component.rs (pending F4); bc-8-components.md §8.4 | HIGH |

### 8.2 Component Delete Safety (8 BCs: BC-8.2.001..008) [DEC-279]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-8.2.001 | `jr component delete NAME\|ID [--project KEY]` refuses (exit 64) without EITHER `--move-to` OR `--orphan`; clap mutually exclusive | — (DEC-279, research §Q1.6, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.2.002 | `--move-to <NAME\|ID>` DELETEs with `moveIssuesTo=<targetId>`; target resolution completes BEFORE the DELETE fires | — (DEC-279, research §Q1.1, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.2.003 | `--move-to` target must resolve within the SAME project as the component being deleted (never cross-project) | — (DEC-279, F1 delta §6 item 8, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.2.004 | `--move-to` target ambiguous/unknown → exit 64 BEFORE the DELETE, listing candidates or valid names (§8.4 instantiation) | — (DEC-279, issue #604) | src/cli/component.rs (pending F4); bc-8-components.md §8.4 | HIGH |
| BC-8.2.005 | `--move-to <SELF>` (target equals the component being deleted) → exit 64 pre-flight, zero HTTP (ID-equality check) | — (DEC-279, F1 delta analysis, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.2.006 | `--orphan` DELETEs with no `moveIssuesTo`; requires `--yes` (non-interactive) or interactive TTY confirm naming the affected-issue count | — (DEC-279, research §Q1.4/§Q1.5/§Q1.6, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.2.007 | Affected issue keys snapshotted via JQL `component = <id>` BEFORE the DELETE, for both `--move-to` and `--orphan`; read-only, fail-closed on search failure | — (DEC-279, research §Q1.3/§Q1.6, issue #604) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.2.008 | `--output json` delete result: `{"deleted","movedIssuesTo","affectedIssueCount","affectedIssues"}`; source-not-found is NOT idempotent (exit 64); concurrent-delete race on DELETE itself → `ApiError(404)` exit 1 | — (DEC-279, research §Q1.6, issue #604) | src/cli/component.rs (pending F4) | HIGH |

### 8.3 Component Rename (7 BCs: BC-8.3.001..007) [issue #608]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-8.3.001 | `jr component rename OLD NEW --project KEY` resolves `OLD` scoped to the project, PUTs `{"name": NEW}` (id unchanged) | — (F1 delta analysis §4, issue #608) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.3.002 | `jr component rename OLD NEW --all-projects` fans out: discovers every project containing a component named `OLD` via per-project component-list calls (O(N) HTTP) | — (F1 delta analysis §4/§6, issue #608) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.3.003 | `--all-projects` fan-out is per-project atomic: a failure in one project does NOT roll back a rename already committed in another (fail-soft); exit 1 on any partial failure | — (precedent BC-2.7.008, issue #608) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.3.004 | `--dry-run` previews the rename set with ZERO mutating HTTP, using the SAME project-discovery logic as the live run | — (precedent BC-3.4.021, F1 delta §6 item 7, issue #608) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.3.005 | `rename` without EITHER `--project` OR `--all-projects` → exit 64 (ambiguous scope; clap ArgGroup) | — (precedent BC-2.1.006, issue #608) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.3.006 | Case-only rename (`OLD`="Backend", `NEW`="backend") is a legitimate operation — the resolver MUST NOT short-circuit it as a no-op | — (F1 delta analysis §6 item 2, issue #608) | src/cli/component.rs (pending F4) | HIGH |
| BC-8.3.007 | `NEW` collides with an existing component name in the same project → Jira 400 surfaced verbatim, NOT pre-validated client-side | — (precedent BC-X.3.004, issue #608) | src/cli/component.rs (pending F4) | HIGH |

### 8.4 Component Name/ID Resolution & Disambiguation (5 BCs: BC-8.4.001..005)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-8.4.001 | `resolve_component(input, project, candidates)` — all-ASCII-digit input short-circuits to numeric ID; non-digit input resolves via project-scoped `partial_match` | — (CLAUDE.md Gotcha; BC-X.10.001, issues #604/#605/#606/#608) | src/cli/issue/helpers.rs::resolve_component (pending F4) | HIGH |
| BC-8.4.002 | Unknown component name (zero matches in scope) → exit 64 listing valid component names for the resolved project scope | — (precedent BC-2.1.014, issues #604/#605/#606/#608) | src/cli/issue/helpers.rs::resolve_component (pending F4) | HIGH |
| BC-8.4.003 | Ambiguous component name (2+ matches in scope) → exit 64, `Ambiguous component` message listing candidates | — (precedent BC-2.1.013/BC-X.10.001, issues #604/#605/#606/#608) | src/cli/issue/helpers.rs::resolve_component (pending F4) | HIGH |
| BC-8.4.004 | Component name resolution is ALWAYS single-project-scoped — a same-named component in a different project is NEVER silently considered a match | — (F1 delta analysis §6 item 1, issues #604/#605/#606/#608) | src/cli/issue/helpers.rs::resolve_component (pending F4) | HIGH |
| BC-8.4.005 | Client-side resolver case-insensitivity agrees with JQL's case-insensitive component-name matching; `MatchResult::ExactMultiple` disposition is caller-specific (mutating fail-closed, read-path UNION) | — (BC-X.10.003, precedent BC-2.1.015, issues #604/#605/#606/#608; F5-A-M1/F5-C-001 2026-08-17) | src/cli/issue/helpers.rs::resolve_component (pending F4) | MEDIUM |

---

## Section X: Cross-Cutting Utilities (cross-cutting.md) — 155 BCs cumulative; 89 individually-bodied [BC-X.8.010 added 2026-07-15 SOH-ATTACHMENTS-1 F2 DEC-179; BC-X.13.007 added 2026-08-05 FIX ROUND 12 S-626-1 issue #626; BC-X.10.001 amended in place 2026-08-15 issue #604/#605/#606/#608 F2 — resolve_component caller citation, no count change; BC-X.14.001..004 added 2026-08-25 issue #580 F2 — new "Field Option Discovery" subsection]

### X.1 HTTP Client (11 BCs: BC-X.1.001..011)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.1.001 | Auth header injected on every API call via `req.header("Authorization", &self.auth_header)` at line 195 | BC-1410-R (R1); BC-1082 (R4) | tests/api_client.rs:~14-40 | HIGH |
| BC-X.1.002 | `client.send(request)` retries 429 transparently; returns parsed response on 200 | BC-1402; BC-1083 (R4) | tests/api_client.rs:~42-70 | HIGH |
| BC-X.1.003 | `client.send(request)` on exhausted 429 raises `JrError::ApiError{status: 429}` via `parse_error` | BC-1402-R (R1) | src/api/client.rs:~184-253 | HIGH |
| BC-X.1.004 | `client.send(request)` requires `RequestBuilder::try_clone()` to succeed; non-cloneable bodies panic | BC-1402a (R1) | src/api/client.rs:~191-194 | HIGH |
| BC-X.1.005 | `client.send_raw(request)` returns 429 to caller (NOT raises) after MAX_RETRIES=3; `expect(4)` pin | BC-1401; BC-1092 (R4) | tests/api_client.rs:~424-444 | HIGH |
| BC-X.1.006 | `send_raw` 429-then-200 retries identically to `send`; caller sees 200 | BC-1091 (R4) | tests/api_client.rs:~394-422 | HIGH |
| BC-X.1.007 | `send_raw` preserves 404 as response (NOT converted to Err); used by `jr api` raw passthrough | BC-1409-R (R1); BC-1090 (R4) | tests/api_client.rs:~367-392 | HIGH |
| BC-X.1.008 | `send_raw` non-cloneable body returns `anyhow::Error` with explicit message (NOT panic) | BC-1402b (R1) | src/api/client.rs:~267-272 | HIGH |
| BC-X.1.009 | 429-exhausted warning always emitted to stderr (not verbose-gated) | BC-1404; BC-1404-R (R1) | src/api/client.rs:~233-237, 309-313 | HIGH |
| BC-X.1.010 | All HTTP methods inject auth header — no bypass | Pass 4 R4 §4.1 | src/api/client.rs | HIGH |
| BC-X.1.011 | `jr api -X`/`--method` accepts HTTP method values case-insensitively | — (S-SOH-590) | src/cli/mod.rs § --method arg + tests/cli_handler.rs::test_parse_api_method_uppercase_delete_dispatches_http_delete | HIGH |

### X.2 Pagination (6 BCs: BC-X.2.001..006)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.2.001 | Offset pagination: `startAt`/`maxResults` + `total` for issue comments, projects, worklogs | BC-1406, BC-1407-R (R1) | src/api/pagination.rs | HIGH |
| BC-X.2.002 | Cursor pagination via `nextPageToken` for JQL search | BC-1406 | src/api/pagination.rs | HIGH |
| BC-X.2.003 | ServiceDeskPage pagination (JSM service desks) | BC-1406 | src/api/pagination.rs | HIGH |
| BC-X.2.004 | `AssetsPage::is_last` accepts bool or string-encoded bool (custom deserializer) | BC-317 (R1) | src/api/pagination.rs | HIGH |
| BC-X.2.005 | User pagination advances `startAt` by REQUESTED `maxResults` (NOT by returned count) | BC-702; BC-1119 (R4) | tests/user_pagination.rs:~202-247 | HIGH |
| BC-X.2.006 | `USER_PAGINATION_SAFETY_CAP = 1500` (15 pages × 100); emits stderr `"hit pagination safety cap"`; exits 0 | BC-1124, BC-1125 (R4) | tests/user_pagination.rs:~459-520 | HIGH |

### X.3 Error Handling (8 BCs: BC-X.3.001..008)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.3.001 | Network drop → `Could not reach <host>; check your connection` exit 1 | BC-1206 | tests/issue_list_errors.rs:~320-360 | HIGH |
| BC-X.3.002 | 401 → `Not authenticated` + `jr auth login` exit 2 (universal across all subcommands) | BC-1207 | 6+ test files | HIGH |
| BC-X.3.003 | 5xx → `API error (<status>)` + extract_error_message(body) + exit 1 | BC-1210 | All *_errors.rs files | HIGH |
| BC-X.3.004 | 400 with field-specific Jira error → stderr formatted as `field: message` (sorted alphabetically) | BC-1211 | tests/issue_resolution.rs:~124-158 | HIGH |
| BC-X.3.005 | 401 + scope-mismatch (case-insensitive) → InsufficientScope; 403 with substring NOT dispatched | BC-015..018; BC-1085..1088 (R4) | tests/api_client.rs:~99-255 | HIGH |
| BC-X.3.006 | Ctrl+C during a running command exits 130 with stderr `"\nInterrupted\n"` — `tokio::select!` race vs. `tokio::signal::ctrl_c()` [AMENDED 2026-08-14 S-MUTANTS-SCOPE-1 — promoted from thin stub; added Behavior/Edge Cases/Verification Properties] | BC-1209 | src/main.rs:~415 | HIGH |
| BC-X.3.007 | Error messages must suggest next step (CLAUDE.md convention, universal) | BC-1212 | Multiple integration tests | HIGH |
| BC-X.3.008 | stderr must NEVER contain `panic` (universal) | BC-1205 | 16+ negative assertion tests | HIGH |

### X.4 Rate Limiting (9 BCs: BC-X.4.001..009)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.4.001 | MAX_RETRIES = 3 (initial + 3 = 4 total calls); `expect(4)` pin | BC-1401-R (R1) | tests/api_client.rs:~424-444 | HIGH |
| BC-X.4.002 | `Retry-After` header parsed as u64 INTEGER ONLY — HTTP-date format NOT supported | BC-1403-R (R1) | src/api/rate_limit.rs:~14-18 | HIGH |
| BC-X.4.003..008 | Additional rate-limiting BCs [range-collapsed; not individually-bodied] | BC-701..708 | src/api/rate_limit.rs | HIGH |
| BC-X.4.009 | `MAX_RETRY_AFTER_SECS = 60` cap — Retry-After exceeding 60s prints warning and aborts retry [PROPOSED FIX-IN-PHASE-3] | ADV-P1-029; NFR-R-NEW-1 | src/api/rate_limit.rs (proposed) | HIGH |

### X.5 Worklogs & Duration (10 BCs: BC-X.5.001..010)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.5.001 | `client.add_worklog(key, seconds, message)` POSTs `/issue/<key>/worklog`; returns Worklog; accepts 201 | BC-501 | tests/worklog_commands.rs:~8-26 | HIGH |
| **BC-X.5.002** | **`client.list_worklogs(key)` paginates via `/issue/<key>/worklog` [MUST-FIX: NFR-R-A — HIGH]** | BC-502; NFR-R-A | src/api/jira/worklogs.rs:~25-30 | HIGH |
| BC-X.5.003 | `worklog list` 5xx → exit 1 + `API error (500)` | BC-503 | tests/worklog_commands.rs:~55-93 | HIGH |
| BC-X.5.004 | `worklog list` 401 → exit 2 + `Not authenticated` + `jr auth login` | BC-504 | tests/worklog_commands.rs:~95-120 | HIGH |
| BC-X.5.005 | Validator `parse_duration_validate("1w2d3h30m")` accepts combined units — production path only. Note: the 3-arg parse_duration calculator was deleted in S-3.10 (was used only by tests post-S-2.06). See `src/duration.rs` and DEC-010. | BC-505 | src/duration.rs::tests | HIGH |
| BC-X.5.006 | `parse_duration` is case-insensitive (input lowercased first) | BC-506 | src/duration.rs:~6 | HIGH |
| BC-X.5.007 | `parse_duration("")` errors `Duration cannot be empty` | BC-507 | src/duration.rs:~7-9 | HIGH |
| BC-X.5.008 | `parse_duration("5")` errors `Number without unit` | BC-508 | src/duration.rs:~38-42 | HIGH |
| BC-X.5.009 | `worklog add` forwards the user-supplied duration string to Jira as `timeSpent`. Jira's server applies its configured `workingHoursPerDay`/`workingDaysPerWeek`. `parse_duration_validate` is a client-side syntax validator only (no arithmetic). Resolves NFR-R-C silent-wrong-answer on customized instances. **RESOLVED — S-2.06 (PR #308 / c8f15d8)** | BC-1014 (R4) | src/cli/worklog.rs::handle_add + src/api/jira/worklogs.rs::add_worklog + src/duration.rs::parse_duration_validate | HIGH |
| BC-X.5.010 | Duration proptest: `valid_single_units_always_parse`; `combined_units_always_parse`; `garbage_input_never_panics`; `format_roundtrip` | BC-1099..BC-1102 (R4) | src/duration.rs:~128-157 | HIGH |

### X.6 Teams (4 BCs: BC-X.6.001..004)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.6.001 | `client.get_org_metadata(hostname)` POSTs GraphQL `tenantContexts` query to `/gateway/api/graphql` | BC-601 | tests/team_commands.rs:~8-26 | HIGH |
| BC-X.6.002 | `client.list_teams(orgId)` GETs `/gateway/api/public/teams/v1/org/<orgId>/teams` | BC-602 | tests/team_commands.rs:~28-46 | HIGH |
| BC-X.6.003 | `team list` 5xx → exit 1; 401 → exit 2; standard error paths | BC-603, BC-604 | tests/team_commands.rs:~62- | HIGH |
| BC-X.6.004 | `team list` cache-first (7d TTL); `--refresh` forces re-fetch | BC-605 | src/cache.rs | MEDIUM |

### X.7 Users (6 BCs: BC-X.7.001..006)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.7.001 | `user search Q` GETs `/rest/api/3/user/search?query=Q` | BC-701 | tests/user_commands.rs | HIGH |
| BC-X.7.002 | `user list --project P` calls `/rest/api/3/user/assignable/multiProjectSearch?projectKeys=P` | BC-704 | tests/all_flag_behavior.rs:~260- | HIGH |
| BC-X.7.003 | `user list` (default, no --all) uses single-call legacy path; no startAt/maxResults params | BC-705 | tests/all_flag_behavior.rs:~271-275 | HIGH |
| BC-X.7.004 | Duplicate display names + `--no-input` → exit non-zero; stderr shows emails + accountIds + duplicate name | BC-706..BC-708 | tests/duplicate_user_disambiguation.rs | HIGH |
| BC-X.7.005 | `user view <id>` → 404 → friendly `"User with accountId '<id>' not found"` exit 64 | BC-1132i (R4) | tests/user_commands.rs | HIGH |
| BC-X.7.006 | `user search --all` advances startAt by REQUESTED maxResults (JRACLOUD-71293 workaround) | BC-1119 (R4) | tests/user_pagination.rs:~202-247 | HIGH |

### X.8 Projects & Queues (10 BCs: BC-X.8.001..010) [BC-X.8.006..007 added 2026-05-19 issue #384 F2; BC-X.8.008..009 added 2026-06-08 S-QUEUE-BC-1; BC-X.8.010 added 2026-07-15 SOH-ATTACHMENTS-1 F2; BC-X.8.010 EC-X.8.010-2 + stale_healed per-command note added 2026-07-24 WAVE-576-05]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.8.001 | `project_exists(key)` → true on 200; false on 404 | BC-801 | tests/input_validation.rs:~9-42 | HIGH |
| BC-X.8.002 | `get_project_statuses(key)` → 404 → `JrError::ApiError{status: 404}` | BC-802 | tests/input_validation.rs:~233-253 | HIGH |
| BC-X.8.003 | `get_or_fetch_project_meta(client, key)` caches by project key with 7d TTL | BC-804 | tests/project_meta.rs:~24-67 | HIGH |
| BC-X.8.004 | `require_service_desk` errors for software project: "Jira Software project" + caller-supplied call-site label | BC-805 | tests/project_meta.rs:~99-126 | HIGH |
| BC-X.8.005 | `list_projects` paginates via `startAt`; filter via `typeKey` query param | BC-1133d, BC-1133e (R4) | tests/project_commands.rs:~1-323 | HIGH |
| BC-X.8.006 | Basic-auth 401 from `require_service_desk` (cache miss — project GET or service-desk list GET) → API-token-expiry hint; no OAuth-scope language; any `InsufficientScope` variant rewritten to `NotAuthenticated`; gated by `client.is_oauth_auth() == false`; benefits all JSM callers | — (issue #384 F2) | tests/issue_create_jsm.rs | HIGH |
| BC-X.8.007 | OAuth 401 from `require_service_desk` (cache miss — project GET or service-desk list GET) → read-side scope hint (`read:jira-work` + `read:servicedesk-request`); gated by `client.is_oauth_auth() == true` | — (issue #384 F2) | tests/issue_create_jsm.rs | HIGH |
| BC-X.8.008 | `jr queue list` auto-paginates `GET /rest/servicedeskapi/servicedesk/{sdId}/queue?includeCount=true` in pages of 50; renders `["Queue", "Issues"]` table (em-dash when issue_count is None); `--output json` returns Vec<Queue> array; empty list is valid success | — (S-QUEUE-BC-1) | tests/queue.rs; src/cli/queue.rs::handle_list; src/api/jsm/queues.rs::list_queues | HIGH |
| BC-X.8.009 | `jr queue view` resolves queue by `--id` (string pass-through, bypasses name resolution) or positional name (via `partial_match`; single-substring → Ambiguous exit 64; ExactMultiple → exit 64; None → exit 64; neither supplied → exit 64); fetches issue keys in queue order up to DEFAULT_LIMIT (30); batch-fetches full issues via `key IN (...)` JQL; reorders to queue position; issues absent from search silently omitted; output is Issue objects not Queue objects | — (S-QUEUE-BC-1) | tests/queue.rs; src/cli/queue.rs::handle_view; src/api/jsm/queues.rs::get_queue_issue_keys | HIGH |
| BC-X.8.010 | JSM attachment upload resolves `serviceDeskId` via EXISTING `get_or_fetch_project_meta` + `ProjectMeta` cache (`project_meta.json`, (profile,projectKey)-scoped, 7-day TTL); `serviceDesk.projectId == project.id` match; no new cache file; stale-ID self-heal = invalidate project_meta entry + re-call `get_or_fetch_project_meta` once; per-status exit mapping on second failure [P6-001/P6-004 correction]; **`stale_healed` guard is per-command, not per-file** (WAVE-576-05, DOCUMENT-AS-IS); **EC-X.8.010-1** (P11-005): list succeeds but no `projectId` matches → exit 64 before step 1, ERROR unconditional both modes, canonical message `"No JSM service desk found for project <KEY>. …"`; **EC-X.8.010-2** (WAVE-576-05): multi-file upload second independent step-1 failure after heal already fired → propagates raw exit 1, no re-heal (near-unreachable; DOCUMENT-AS-IS-COMPLETE) | — (SOH-ATTACHMENTS-1 F2; P11-005; WAVE-576-05) | src/api/jsm/servicedesks.rs::get_or_fetch_project_meta; src/cache.rs::ProjectMeta | HIGH |

### X.9 JQL Utilities (4 BCs: BC-X.9.001..004)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.9.001 | `escape_value` proptest: for any printable Unicode up to 100 chars, output has NO unescaped quote | BC-1094 (R4) | src/jql.rs:~383-394 | HIGH |
| BC-X.9.002 | `validate_duration("4w2d")` → Err; single unit `"7d"` → Ok | BC-131 (R1) | src/jql.rs:~16-34 | HIGH |
| BC-X.9.003 | `validate_date` → `YYYY-MM-DD` format only; invalid → `JrError::UserError` | BC-132 (R1) | src/jql.rs | HIGH |
| BC-X.9.004 | `strip_order_by` removes ORDER BY clause before count calls and paren-wrapping | BC-102, BC-125 (R1) | src/jql.rs | HIGH |

### X.10 Partial-Match (3 BCs: BC-X.10.001..003)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.10.001 | `partial_match` with single-substring → `Ambiguous` (NOT Exact); never auto-resolves | BC-105 context | src/partial_match.rs | HIGH |
| BC-X.10.002 | `partial_match(s, &candidates)` proptest: exact match always found; never panics; empty candidates → None | BC-1095..BC-1097 (R4) | src/partial_match.rs:~153-198 | HIGH |
| BC-X.10.003 | Duplicate candidates → `MatchResult::ExactMultiple(name)` with `name.to_lowercase() == input.to_lowercase()` | BC-1098 (R4) | src/partial_match.rs:~182-198 | HIGH |

### X.11 Build-Time (5 BCs: BC-X.11.001..005)

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.11.001 | `build.rs` reads `JR_BUILD_OAUTH_CLIENT_ID` + `_SECRET` env vars | BC-1301 | build.rs | HIGH |
| BC-X.11.002 | Unix → `/dev/urandom` for 32-byte XOR key; Windows → inline `BCryptGenRandom` FFI | BC-1302 | build.rs | HIGH |
| BC-X.11.003 | Non-unix/non-windows → `compile_error!` | BC-1303 | build.rs | HIGH |
| BC-X.11.004 | Unset build vars → `EMBEDDED_*` constants are `None`; BYO/prompt path proceeds | BC-1304 | build.rs; src/api/auth_embedded.rs::tests | HIGH |
| BC-X.11.005 | `proptest-regressions/jql.txt` pinned regression seed for `escape_value("")` | BC-1103 (R4) | proptest-regressions/jql.txt | HIGH |

### X.12 JSM Request Types (8 BCs: BC-X.12.001..008) [Added 2026-05-18 issue #288]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.12.001 | `jr requesttype list` lists request types for the active project's service desk | — (issue #288 F2) | tests/requesttype_commands.rs; src/cli/requesttype.rs; src/api/jsm/request_types.rs | HIGH |
| BC-X.12.002 | `--search <QUERY>` filters via JSM `searchQuery` server-side param (name or description match) | — (issue #288 F2) | tests/requesttype_commands.rs | HIGH |
| BC-X.12.003 | `--project <KEY>` overrides active profile; `require_service_desk` errors clean on non-JSM project | — (issue #288 F2) | tests/requesttype_commands.rs; src/api/jsm/servicedesks.rs | HIGH |
| BC-X.12.004 | `--output json` returns `[{id, name, description, helpText, issueTypeId, groupIds}, ...]`; default table shows Name + Description | — (issue #288 F2) | tests/requesttype_commands.rs | HIGH |
| BC-X.12.005 | `jr requesttype fields <NAME\|ID>` lists fields for a request type via `GET .../requesttype/<rtId>/field` | — (issue #288 F2) | tests/requesttype_commands.rs; src/cli/requesttype.rs; src/api/jsm/request_types.rs | HIGH |
| BC-X.12.006 | Partial-name resolution for `<NAME\|ID>` uses `partial_match`; ambiguity errors with disambiguation hint | — (issue #288 F2) | tests/requesttype_commands.rs; src/partial_match.rs | HIGH |
| BC-X.12.007 | `--output json` for `requesttype fields` returns `{canRaiseOnBehalfOf, canAddRequestParticipants, fields: [{fieldId, name, required, jiraSchema, ...}]}`; table shows Field, Required, Type | — (issue #288 F2) | tests/requesttype_commands.rs | HIGH |
| BC-X.12.008 | Request types cached per `(profile, serviceDeskId)` with 7-day TTL; cache key: `v1/<profile>/request_types_<service_desk_id>.json`; miss self-heals | — (issue #288 F2) | tests/requesttype_commands.rs; src/cache.rs | HIGH |

### X.13 CI Guards (7 BCs: BC-X.13.001..007) [BC-X.13.001..003 added 2026-06-19 DEAD-CITATION-CI F2; BC-X.13.004..006 added 2026-07-05 CITATION-GUARDS Story B S-BC-CITATION-GUARD-1 issue #102; BC-X.13.007 added 2026-08-05 FIX ROUND 12 S-626-1 issue #626 — `test` job runtime test-execution floor / POL-11]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.13.001 | Every in-scope backtick-quoted path citation in CLAUDE.md (develop-tracked dirs: `src/`, `tests/`, `docs/`, `.github/`, `scripts/`; OR ROOT_FILES exact-match: `build.rs`,`Cargo.toml`,`CHANGELOG.md`,`CLAUDE.md`,`deny.toml`,`README.md`,`rust-toolchain.toml`; recognized extension) resolves to a real on-disk file; ALL `.factory/` paths excluded (absent from CI checkout); bare-filename shorthands not in ROOT_FILES excluded; guard fails with canonical message listing ALL dead references | — (DEAD-CITATION-CI F2) | tests/claude_md_citations.rs::test_claude_md_citations_resolve_to_real_files (new) | HIGH |
| BC-X.13.002 | Canonical normalization pipeline (a)–(e): (a) glob/brace-glob skip (`*`,`{`,`}`); (b) unified normalize fixpoint — sub-steps repeat until stable: (1) symbol-form strip (`::…`); (2) line-ref strip (`:~NN`/`:NN`); (3) strip one leading `(`/`[`; (4) greedy plain-punct strip (`.`,`,`,`;`,`:`); (5) unbalanced `)` trim; (6) unbalanced `]` trim; (c) dir-prefix filter + ROOT_FILES inclusion (`src/`,`tests/`,`docs/`,`.github/`,`scripts/` OR exact-match in ROOT_FILES={`build.rs`,`Cargo.toml`,`CHANGELOG.md`,`CLAUDE.md`,`deny.toml`,`README.md`,`rust-toolchain.toml`}; ALL `.factory/` excluded; bare-filename shorthands `ci.yml`,`adf.rs`,`fields.json`,`release.yml` etc. excluded as NOT in ROOT_FILES); (d) extension filter; (e) Path::exists() check — merged fixpoint eliminates ordering-class false-negatives; ROOT_FILES inclusion is false-positive-safe via curated exact-match (F2 amendment 2026-06-19) | — (DEAD-CITATION-CI F2) | tests/claude_md_citations.rs::extract_path_citations (new, with inline unit tests) | HIGH |
| BC-X.13.003 | ALL `.factory/` paths are excluded by the dir-prefix filter — `.factory/` is git-ignored and absent from CI checkout; no allowlist function needed; dead-citation coverage for `.factory/` paths is handled by the maintenance doc-drift sweep, NOT this guard | — (DEAD-CITATION-CI F2; re-scoped F2 Iter 2) | tests/claude_md_citations.rs::extract_path_citations dir-prefix filter | HIGH |
| BC-X.13.004 | Every `src/` file path in a `**Trace**:` or `**Source**:` field of any bc-*.md body resolves to a real on-disk file; guard exits 1 listing all dead references (collect-all); SCOPE-EMPTY guard (fail-closed on no bc-*.md files); coverage floor = floor(0.75 × N) ≈ 248 (post-Task-0-hygiene, N≈331; pre-hygiene 244/N=326) in CANONICAL_MODE (extraction-dropout guard); error taxonomy: BC-CITE-001 | — (CITATION-GUARDS Story B F2) | scripts/check-bc-citation-symbols.sh::run_check (new file; spec-guard CI) | HIGH |
| BC-X.13.005 | Guard 1 extraction grammar: space-tolerant two-pass extractor (Pass 1: `` grep -oE '`src/[^`]+`' `` backtick-only stop; Pass 2: first-space split); supersedes prior single-pass stop-on-space form (DEC-154); `::symbol` form classification (first-`::` file strip, last-`::` symbol strip); strip-from-first-`(` on symbol; 7-branch v1-pragmatic shape-split: (a) fn-grep primary, (b) `::tests` mod-grep, (c) `::tests::testfn` composition, (d) UPPER_CASE const/static anchored grep, (e) standalone CamelCase type-def grep, (f) Type::method dual-check, else DEAD; glob-citation silent-skip (path contains `*`); no permissive fallback; v2-deferrals: macros, Type::method correlation, continuation-line stitching | — (CITATION-GUARDS Story B F2) | scripts/check-bc-citation-symbols.sh::run_check Steps 1–5 (new file) | HIGH |
| BC-X.13.006 | Guard 1 is GREEN on develop HEAD; RED on stale citation introduction; scope limited to bc-*.md Trace/Source fields only (BC-INDEX.md excluded — structural zero-Trace/Source lines; tests/ citations excluded — #492-PG-TRACE-TESTS); CI topology: spec-guard dual-worktree (develop + factory-artifacts); 10-fixture self-test (A–K); `--self-test` step precedes canonical step in CI; zero src/ changes in delivery | — (CITATION-GUARDS Story B F2) | scripts/check-bc-citation-symbols.sh (new file); .github/workflows/ci.yml spec-guard job (modified) | HIGH |
| BC-X.13.007 | The `test` job's runtime test-execution floor (Guard 2) rejects a CI-green result achieved via zero or near-zero test execution: a binary-count floor, a named-canary presence check (`tests/ci_gate_completeness` must have reported results), a named-canary passed-count gate (that binary's own `test result:` line must report a non-zero passed count, ADV-P50-LOW-002), and a zero-test floor are computed from parsed runtime output — not inferred from `cargo test`'s exit code alone, which cannot distinguish "ran and passed" from "nothing ran"; a genuine test failure still fails the step independently; on success a runtime-computed positive-coverage line is emitted as the observable proof (POL-11) | — (FIX ROUND 12, S-626-1, issue #626) | tests/ci_gate_completeness.rs::test_verify_test_job_has_zero_test_floor; .github/workflows/ci.yml `test` job step "Run tests (zero-test floor, POL-11)" | HIGH |

### X.14 Field Option Discovery (4 BCs: BC-X.14.001..004) [NEW 2026-08-25 issue #580 F2 — `jr field options <field>` new command family, filed as Cross-Cutting subsection per BC-X.12 sizing precedent]

| L3 BC ID | Summary | Pass 3 BC ID | Source | Confidence |
|---|---|---|---|---|
| BC-X.14.001 | `jr field options <field> (--type <T> [--project <P>] \| --request-type <RT> [--project <P>] \| --issue <KEY>)` resolves `<field>` (customfield_NNNNN or human name via `partial_match`) and enumerates allowed options into a normalized `{id, label, children}` model; exactly one of three MODE-SELECTOR flags required (`--type`/`--request-type`/`--issue`), exit 64 on none/multiple — `--project` is a companion flag, never a mode selector (companion for M2 (flag OR profile/config default), companion for M3, per ADR-0019 §1 arity correction + § Amendment D1); M2 createmeta PRIMARY (platform), M3 JSM requesttype-fields PRIMARY (JSM), M1 editmeta FALLBACK | — (issue #580 F2) | src/cli/field.rs (new); src/api/jira/issues.rs::get_createmeta_fields (new, M2, per ADR-0019 §1); src/api/jira/issues.rs::get_issue_types_for_project (reused, S-331, M2 `--type` name→id resolution); src/api/jira/fields.rs::list_fields (reused, field-name resolution only — not a new enumeration function); src/api/jsm/request_types.rs (reused, M3); src/api/jsm/servicedesks.rs::{require_service_desk,get_or_fetch_project_meta} (reused, M3 `--project`/ambient-default companion resolution) | HIGH |
| BC-X.14.002 | `--value <substring>` client-side case-insensitive filter narrows the enumerated option list to matching id/label(s); cascading children filtered independently; empty result is exit 0 success, not an error | — (issue #580 F2) | src/cli/field.rs | HIGH |
| BC-X.14.003 | Table output columns (ID, Label) with cascading indentation; `--output json` returns the normalized `{id, label, children}` array via `render_json` (#526 invariant) | — (issue #580 F2) | src/cli/field.rs; src/output.rs::render_json (reused) | HIGH |
| BC-X.14.004 | Error taxonomy — field not found/ambiguous, context-flag mutual-exclusion violations, non-JSM/unknown `--request-type`; graceful degradation (exit 0, NOT an error) for fields with no enumerable options (Assets/CMDB, user-picker, labels, free-text/number/date) — prints a hint + `autoCompleteUrl`/Assets pointer instead of erroring | — (issue #580 F2) | src/cli/field.rs | HIGH |

---

## MUST-FIX Register (4 items)

| L3 BC ID | NFR Source | Severity | Site | Phase 3 Routing |
|---|---|---|---|---|
| **BC-6.3.001** | NFR-R-D | CRITICAL | 14 sites `config.global.fields.*` | FIX-IN-PHASE-3 |
| **BC-X.5.002** | NFR-R-A | HIGH | `src/api/jira/worklogs.rs:~25-30` | FIX-IN-PHASE-3 |
| **BC-3.4.001** | NFR-R-B | HIGH | `src/cli/issue/workflow.rs:~636` | FIX-IN-PHASE-3 |
| **BC-4.3.001** | NFR-R-E | HIGH | `src/cli/issue/list.rs:~440,446,449,456` | FIX-IN-PHASE-3 |

---

## Coverage Statistics

| Section | BC Count (cumulative) | Individually-bodied |
|---|---|---|
| 1: Auth & Identity | 57 | 46 |
| 2: Issue Read | 106 | 64 |
| 3: Issue Write | 140 | 111 |
| 4: Assets & CMDB | 32 | 22 |
| 5: Boards & Sprints | 36 | 18 |
| 6: Config & Cache | 43 | 33 |
| 7: Output Rendering | 93 | 49 |
| X: Cross-Cutting | 151 | 85 |
| **Total** | **658** | **428** |

**Note**: BC-X.4.009 (ADV-P1-029) is included in cross-cutting's `total_bcs` and in the sum above. Canonical total is **658** (+4 BC-7.4.013-016 added 2026-05-08 via Fix-PR A; +1 BC-2.6.050 added 2026-05-13 via issue #350; +1 BC-2.6.051 added 2026-05-14 via issue #365; +1 BC-3.4.009 added 2026-05-15 via issue #340 F2; +18 BC-3.8.001..010 + BC-X.12.001..008 added 2026-05-18 via issue #288 F2+F1d; +3 BC-3.8.011..013 added 2026-05-19 via issue #288 F1d + issue #383 F2; +4 BC-3.8.014..015 + BC-X.8.006..007 added 2026-05-19 via issue #384 F2; +2 BC-3.8.016..017 added 2026-05-20 via issue #385 F2; +2 BC-3.4.010..011 added 2026-05-20 via issue #388 F2; +3 BC-3.4.012..014 added 2026-05-21 via issue #398 F2; +3 BC-3.4.015..017 added 2026-05-22 via issue #396 F2; +2 BC-3.4.018..019 added 2026-06-01 via issue #331 F2; +1 BC-3.2.013 added 2026-06-03 via jsm-resolution-required F2; +1 BC-7.2.006 added 2026-06-08 via issue #470 listItem content-model conformance; +2 BC-X.8.008..009 added 2026-06-08 via S-QUEUE-BC-1 queue list/view document-as-is; +1 BC-3.2.014 added 2026-06-08 via fix-bulk-transition-schema bulkTransitionInputs wrapper; +2 BC-7.2.007..008 added 2026-06-08 via issue #474 markdown subsup + heading-attr; +1 BC-7.2.009 added 2026-06-09 via issue #483 GFM alerts → panel; +1 BC-7.2.010 added 2026-06-10 via issue #471 GFM task lists → taskList/taskItem; +3 BC-6.1.014 + BC-6.2.016..017 added 2026-06-12 via windows-build F2; +1 BC-7.2.011 added 2026-06-15 via issue #492 block-HTML hardBreak interior newlines; +1 BC-2.4.043 added 2026-06-17 via Bundle C CR-001 list_comments anti-stall guard; +3 BC-X.13.001..003 added 2026-06-19 via DEAD-CITATION-CI F2 CLAUDE.md citation guard; +1 BC-7.2.012 added 2026-06-24 via SEC-001 ADF recursion depth limit; +2 BC-7.2.013..014 promoted 2026-06-27 from range-collapsed to individually-bodied via issues #472 #473 (no total_bcs change); +1 BC-6.2.018 added 2026-06-27 cache warm-hit no-HTTP invariant; +1 BC-7.3.010 added 2026-06-27 issue #526 json-render invariant + error channel; +3 BC-3.4.020..021 + BC-5.1.005 added 2026-06-30 via BC-subclause-pass F2; +3 BC-X.13.004..006 added 2026-07-05 via CITATION-GUARDS Story B Guard 1 S-BC-CITATION-GUARD-1 issue #102; +1 BC-7.2.015 added 2026-07-07 via issue #571 ADF code-mark exclusivity; +1 BC-X.1.011 added 2026-07-09 via S-SOH-589 jr api --method case-insensitivity; +11 SOH-COMMENT-CRUD-1 added 2026-07-09 via DEC-168 comment delete/edit/view issue #577; +27 SOH-ATTACHMENTS-1 F2 added 2026-07-15 via DEC-179 issues #576 #585; +6 BC-3.9.015..020 added 2026-07-15 via SOH-ATTACHMENTS-1 adversary pass-1 round B scope expansion ruling R1/R2; +1 BC-X.13.007 added 2026-08-05 via FIX ROUND 12 S-626-1 issue #626 — `test` job runtime test-execution floor / POL-11).

Cumulative total (657) ≠ individually-bodied count (427). The difference (230) comprises range-collapsed BCs that exist in the cumulative claim but are not individually headlined in body files. This is by design — range-collapsed BCs trace to Pass 3 source material but were not individually expanded. The 4 MUST-FIX BCs are included in the individually-bodied count.

**Process gap [process-gap]**: `scripts/check-bc-cumulative-counts.sh` currently guards 8 surfaces (per-file frontmatter, BC-INDEX headers, BC-INDEX section lines, CANONICAL-COUNTS per-file table, body preamble prose, BC-INDEX frontmatter total_bcs, CANONICAL-COUNTS Sum row, grand-total prose). The BC-INDEX Coverage Statistics body table (this section) is a 9th surface with no automated guard. Manual update required whenever BC counts change. Tracked for future script extension.

---

## Pass 3 BC ID Mapping Table (key entries)

| Pass 3 BC ID | L3 BC ID | Notes |
|---|---|---|
| BC-001..012 | BC-1.1.001..012 | Auth core (body 1.1) |
| BC-013-R..014-R | BC-1.2.013..014 | Profile lifecycle |
| BC-019..022-R | BC-1.3.019..022 | Embedded OAuth app |
| BC-101..BC-109 | BC-2.1.001..BC-2.2.027 | Issue read broad |
| BC-201..225 | BC-3.1.001..BC-3.7.004 | Issue write |
| BC-301..315 | BC-4.1.001..BC-4.4.003 | Assets broad |
| BC-316..324 | BC-4.2.001..BC-4.4.003 | Assets R1 |
| BC-401..410 | BC-5.1.001..BC-5.2.008 | Boards/sprints broad |
| BC-501..508 | BC-X.5.001..008 | Worklogs |
| BC-601..606 | BC-X.6.001..004, BC-5.4.001 | Teams, team_id deserialization |
| BC-701..708 | BC-X.7.001..006, BC-X.4.001..002 | Users, rate limiting |
| BC-801..805 | BC-X.8.001..005 | Projects/queues |
| BC-901..909 | BC-6.1.001..010 | Config |
| BC-1001..1016 | BC-6.2.001..014 | Cache |
| R1 BC-1201-R..d | BC-7.3.001..004 | extract_error_message |
| R4 BC-1104..1117 | BC-7.2..BC-7.4 | JSON output shapes, ADF |
| R4 BC-1119..1125 | BC-X.7.006, BC-X.2.005..006 | User pagination |
| R4 BC-1126..1132 | BC-3.7.001..004, BC-X.7 | Remote links, user commands |
| R4 BC-1133..1139 | BC-X.8.005, BC-6.1, BC-1.1.012 | Projects, config errors |
| R4 BC-1140..1178 | BC-1.3..1.5 | Auth OAuth state machine |
| R4 BC-1138a..f | BC-5.3.001..004 | Team column parity |
| R4 NFR-R-D | BC-6.3.001 | MUST-FIX CRITICAL |
| R4 NFR-R-A | BC-X.5.002 | MUST-FIX HIGH |
| R4 NFR-R-B | BC-3.4.001 | MUST-FIX HIGH |
| R4 NFR-R-E | BC-4.3.001 | MUST-FIX HIGH |

---

## Traceability Gaps

| Pass 3 BC ID | Disposition |
|---|---|
| BC-105 (partial_match single-substring) | Absorbed into BC-X.10.001 |
| BC-314 (--open assets color filter) | Absorbed into BC-4.2.008 |
| BC-505 (parse_duration combined units) | Absorbed into BC-X.5.005 |
| BC-1099..1103 (duration proptests) | Absorbed into BC-X.5.010 |
| BC-1103 (proptest regression seed) | Absorbed into BC-X.11.005 |
| BC-152..154 (config validation points) | Absorbed into BC-6.1.004..006 |
| BC-1201-R variants (4 sub-BCs) | Absorbed into BC-7.3.001..004 |
| R4 BC-1402a,1402b (try_clone semantics) | Absorbed into BC-X.1.004, BC-X.1.008 |

**Unresolved gaps**: 0 — all Pass 3 BCs are either directly mapped or absorbed into a parent L3 contract.
