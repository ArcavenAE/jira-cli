---
document_type: verification-delta
phase: phase-f2-spec-evolution
cycle: field-dx
issues: [580, 578]
producer: formal-verifier
timestamp: 2026-08-26   # F2 adversary-convergence round-3 (VP amendments only, NO new VP — total stays 30): F-A VP-578-013 §3 empty-value→exit-64 scoped to `:asset` ONLY (`:id`/`:name` PASS-THROUGH, EC-8/EC-9) + `prop_oneof!` adds `:name`; F-C VP-578-012 §2 `W:Y:Z` distinct extra-colon message (EC-2d); F-B VP-580-005 §2 strengthened (never-drop count + None→null + pinned `"—"`/`"(unnamed)"`) and VP-580-008 gains (d) degenerate-entry rendering. Prior round-2 fix-chain same day (Pass1-F1 VP-580-006 3-bool rewrite; Pass2-F1 VP-578-022 3 call sites; Pass2-F3 VP-578-012 `:`-split; Pass2-F2 VP-580-012 minted); round-1 F2 pass (D1/D2/D3 + C-LOW/B-F1); F5-pass-1 revision was 2026-08-25. VP total 29 → 30 (unchanged by round-3). F2 adversary-convergence round-4 (VP total 30 → 31, ONE new VP): MED-3 VP-578-013 §3 proptest splits `:option` empty → `is_err()` (downstream `allowedValues` match-miss, EC-3.4.016-2) vs `:id`/`:name` → `is_ok()` pass-through vs `:asset` → `is_err()` structural; F-1 VP-580-007 gains sub-points (g)/(h)/(i) reconciling the `--value` filter with F-B's `Option<String>` (None not a match source, never-drop, `--value ""`≡absent incl. degenerate entry); F-2/D4 **VP-578-023 MINTED** (non-cascading `>`-collision message EC-3.4.027-7 + bare-form `>`-literal + `AllowedValue.children: Vec` type dep; sibling to VP-578-008); item-4 VP-580-012 BC-body back-fill confirmed DONE (cross-cutting.md ~L2805); O-3 decision: transitive VP-578-020 coverage sufficient for field-options M2 page≥2, no new VP. VP-578-023's BC-body anchor is now the sole pending one-line back-fill (VP-580-012's closed). F2 adversary-convergence round-5 (VP total 31 → 32, ONE new VP): F-NEW-1 VP-578-021 EXTENDED — create-path Gate-B governed set widened 5→10 wire keys (3 new static keys `labels`←`--label`/`parent`←`--parent`/`assignee`←`--to`/`--account-id` + 2 DISTINCT resolved-id keys `--points`→story-points customfield id / `--team`→team customfield id via `customfield_NNNNN=` bypass ONLY, asserted SEPARATELY) + a NEGATIVE regression pin (`--points 5 --field "Story Points"=8` does NOT trip the guard; bounded zero-HTTP residual), `labels` governed-on-create/excluded-on-edit distinction kept; F-NEW-2 **VP-578-024 MINTED** (dry-run `plannedChanges` hint-preview wire shape per kind + `:asset` cold-cache side-effect exit-64-before-preview) replacing the PO's `VP-DRY-RUN-005` placeholder in BC-3.4.021 (targeted BC edit made this round); MED-2 VP-578-023 BC-body back-fill now DONE at BOTH sites (BC-3.4.027 ~L3319 declared + BC-3.4.015 ~L1901 back-filled) — supersedes the round-4 "sole pending back-fill" claim above; `related_bcs` += BC-3.4.015 (VP-578-023 Applies-to) + BC-3.4.021 (VP-578-024 owning BC); MED-1/task-item-4 VP-578-013 EC-2d consistency CONFIRMED (delta uses EC-2a for empty `:asset`; EC-2d is exclusively VP-578-012's extra-colon message — no delta edit required). ZERO pending BC-body back-fills remain after this round.
status: complete
convention: inline-proptest   # this repo has NO centralized VP-NNN registry — see §0
# ONE authoritative VP id per guarantee. The parallel `VP-*-04x` band an earlier revision of
# this delta introduced is RETIRED (F5 pass-1 finding) — every property below is now labeled
# with the single canonical inline VP id it is realized against. See §0 for the complete
# old-04x → canonical mapping.
new_properties:            # genuinely NEW inline VPs — extend the existing VP-578-0xx / VP-580-0xx sequences
  - VP-578-020   # createmeta-family multi-page resolution (BC-3.3.010) — FIELDS half: adversary pass-28 F-1; ISSUE-TYPES extension: adversary pass-29 F-1 (C-LOW attribution sync — BC-3.3.010 attributes the issuetypes half to pass-29); ADR-0019 §1 offset-pagination across BOTH createmeta endpoints: (a) FIELDS (`get_createmeta_fields`) — a `--field` target on fields-page ≥2 is collected and resolves (exit 0), not dropped; AND (b) ISSUE-TYPES (`get_issue_types_for_project`, the `--type` name→id resolution in src/api/jira/issues.rs) — a `--type` entry on issuetypes-page ≥2 resolves to its issueTypeId (exit 0), not dropped; added inline to BC-3.3.010
  - VP-578-021   # create-path Gate-B collision guard (BC-3.3.010, ADR-0019 § Amendment 2026-08-26 D2 + § "D2 correction (adversary F-NEW-1)") — D2 gap; shared `field_resolve::detect_flag_field_overlap` on the create path (any argv order, any hint kind) → exit 64, ZERO HTTP, symmetric with edit's EC-3.4.017-16; modeled on the edit-path Gate-B VP (VP-396-005). EXTENDED F2 round-5 (F-NEW-1): create-path governed set is TEN wire keys, not five — the five static-flag keys (summary/description/issuetype/priority/components) PLUS three more static-flag keys (`--label`→labels, `--parent`→parent, `--to`/`--account-id`→assignee) PLUS two DISTINCT resolved-id keys (`--points`→story-points customfield id AND `--team`→team customfield id are two separate governed members with distinct `customfield_NNNNN` wire keys, the guard firing SEPARATELY for each) detected ONLY via the `--field customfield_NNNNN=` bypass form; plus a NEGATIVE regression pin that the display-name form (`--points 5 --field "Story Points"=8`) does NOT trip the guard (the bounded zero-HTTP-before-project-resolution residual). `labels` is governed on CREATE (no endpoint fork) but excluded on EDIT (BUG-LABEL-400 fork). Added inline to BC-3.3.010 (back-fills the PO's D2 placeholder)
  - VP-578-022   # :asset cold-cache workspace-discovery FAILURE taxonomy (BC-3.4.030, B-LOW; Pass2-F1 widened) — each row (403/404 → Assets-unavailable exit 64; 200 + empty `values` → no-workspace exit 64; 401 → standard auth mapping; 5xx/network → standard API/network mapping) exercised via wiremock on ALL THREE call sites (edit, platform-create, and JSM `handle_jsm_create`) — all three share `get_or_fetch_workspace_id`, and this taxonomy is wire-shape-INDEPENDENT (fires during workspace-id resolution, before any :asset array is composed on any path). The JSM :asset HAPPY-PATH `requestFieldValues` WIRE shape stays UNVERIFIED/deferred (VP-578-016) — only the failure taxonomy is asserted on all 3; added inline to BC-3.4.030 (back-fills the PO's B-LOW placeholder)
  - VP-578-023   # non-cascading `>`-collision message + bare-form `>`-literal behavior (BC-3.4.027 EC-3.4.027-7 / BC-3.4.015, ADR-0019 § Amendment 2026-08-26 D4, adversary tag F-2) — sibling to VP-578-008: (i) `--field cf:option=A>B` on a PLAIN (non-cascading) `option` field whose parent `A` resolves but whose matched parent's `children` collection is EMPTY → exit 64 with pinned substrings "is not a cascading select" + "remove the" (EC-3.4.027-7; detected STRUCTURALLY via the empty-`children` check, NEVER a `schema.type` lookup); (ii) bare `--field cf=Parent>Child` treats `>` as a LITERAL character (no split) → the whole-string `"Parent>Child"` match-miss falls through to the EXISTING EC-3.4.016-2 unresolvable-value error, never attempting a cascading split (D4 cell b). Type dependency: `src/types/jira/editmeta.rs::AllowedValue` gains `#[serde(default)] pub children: Vec<AllowedValue>` (Vec, not Option<Vec>). NOTE: no PO "verifier to assign VP id" placeholder existed in the BC files (grep-confirmed) — so at round-4 VP-578-023's inline BC-body anchor was a pending one-line back-fill. UPDATED F2 round-5 (MED-2): back-fill now DONE at BOTH sites — BC-3.4.027 (~L3319) declared it round-4, and the PO back-filled BC-3.4.015's `>`-literal note (~L1901) this round; `related_bcs` gained BC-3.4.015. No longer pending — see §5
  - VP-578-024   # dry-run `plannedChanges` hint-preview shape (BC-3.4.021; cross-refs BC-3.4.027/028/029/030 "Dry-run preview shape" Postconditions + BC-3.4.015-19/EC-3.4.015-19) — F2 adversary-convergence round-5, F-NEW-2. Under `issue edit --dry-run`, `plannedChanges` shows the SAME composed wire shape the live PUT sends per hint kind (`:id`→`{"id":…}`, `:name`→`{"name":…}`, `:option` non-cascading→`{"id":…}`, `:option` cascading→`{"value":…,"child":{"value":…}}`, `:asset`→`[{workspaceId,id,objectId}]`), NOT the bare-form display-value string; PUT never called. PLUS the side-effect assertion: `--field cf:asset=<objectId> --dry-run` on a COLD workspace-id cache fires the REAL `get_or_fetch_workspace_id` `GET /rest/servicedeskapi/assets/workspace` (resolution runs INSIDE the dry-run block, EC-3.4.015-18) and CAN exit 64 per BC-3.4.030's cold-cache taxonomy BEFORE any `plannedChanges` output (EC-3.4.015-19), mirroring VP-692-002/004's exit-64-before-preview shape. Assigned this id by verifier (replaces the PO's `VP-DRY-RUN-005` placeholder in BC-3.4.021 — targeted BC edit made this round)
  - VP-580-006   # context mutual-exclusion arity guard (BC-X.14.001 Invariant 1) — was the gap; added inline to BC-X.14.001. NARROWED per ADR-0019 § Amendment D1: pure fn is now `resolve_field_context(has_type, has_request_type, has_issue) -> Result<Mode, ArityError>` — 3-bool domain, `has_project` axis DROPPED
  - VP-580-007   # --value client-side filter correctness (BC-X.14.002) — was the gap; added inline to BC-X.14.002
  - VP-580-008   # table/JSON output-shape (BC-X.14.003) — was the gap; added inline to BC-X.14.003
  - VP-580-009   # `--project --request-type` valid M3, NOT an arity error (BC-X.14.004) — adversary pass-20 M1 / ADR-0019 §1 regression guard; realized as the positive `--project --request-type → Ok` case of VP-580-006's arity proptest
  - VP-580-010   # M2 post-arity project resolution (BC-X.14.001, ADR-0019 § Amendment 2026-08-26 D1) — separate SIBLING pure fn `resolve_m2_project(cli_project: Option<&str>, config: &Config) -> Option<String>`; M2 succeeds when EITHER an explicit `--project` OR a profile/config-default project exists, exits 64 pre-HTTP only when NEITHER exists; mirrors BC-3.3.010's create-path flag-or-default project-resolution VP shape; added inline to BC-X.14.001 (back-fills the PO's D1 placeholder)
  - VP-580-011   # --value + graceful-degrade interaction (BC-X.14.002, B-LOW) — `--value` present against a zero-enumerable-options field: filter applies POST-fetch, degrade hint still fires on stderr, stdout stays `[]`/empty table, exit 0; VP-580-005 companion; added inline to BC-X.14.002 (back-fills the PO's B-LOW placeholder)
  - VP-580-012   # `--project` not-found (404) taxonomy on `jr field options` M2 + M3 enumeration paths (BC-X.14.004, F2 adversary-convergence round-2 Pass2-F2) — a nonexistent/inaccessible `--project` yields a genuine HTTP 404 (NOT a pre-HTTP arity failure): on M2 from whichever createmeta-family call runs first (`get_issue_types_for_project`'s `GET .../createmeta/{project}/issuetypes`, or `get_createmeta_fields`), on M3 from `get_or_fetch_project_meta`'s `GET /rest/api/3/project/{key}` → exit 64, "project not found or not accessible", zero mutating HTTP. Distinct HTTP-failure class from the pre-HTTP arity/companion-absent rejections (VP-580-006/010) and the non-JSM wrong-type row. Realized WITHIN VP-580-004's per-row taxonomy coverage (EC-X.14.004-6 + the new taxonomy row) as a durable regression pin — NOT a separate §1 core-surface row (mirrors VP-580-009's relationship to VP-580-006). DONE — the inline BC-body declaration now exists in `cross-cutting.md` BC-X.14.004's Verification Properties (~line 2805, alongside VP-580-004/005/009); the round-2/round-3 "pending back-fill" flag is CLOSED (F2 round-4)
realizes_inline_vps:       # proptest/unit REALIZATIONS of EXISTING inline VPs — no new id, no duplicate
  - VP-578-001   # platform-create `--field` resolves via createmeta (never editmeta) (BC-3.3.010) — realized §1.1 (tests/issue_create_field.rs createmeta path, reuses VP-396-009 edit-path realization transplanted to create)
  - VP-578-002   # fields.json cache SHARED between `edit --field` and `create --field`, same profile (BC-3.3.010) — realized §1.1 (tests/issue_create_field.rs warm-cache reuse; shares resolve_edit_fields/write_fields_cache from VP-396-009)
  - VP-578-003   # all-or-nothing multi-`--field` failure on create (zero POST on any resolution failure) (BC-3.3.010) — realized §1.1 (tests/issue_create_field.rs create-path variant transplanting VP-396-009 edit-path semantics)
  - VP-578-004   # create-path `--field` error-taxonomy rows each independently exercised (BC-3.3.011) — realized §1.1 (per-row wiremock tests in tests/issue_create_field.rs: exit 64, zero POST, exact substring per row)
  - VP-578-005   # hint-splitter multibyte / Unicode-scalar safety (BC-3.4.026) — absorbs former VP-578-040
  - VP-578-006   # bare-name map key: last-wins ACROSS kinds, no composite-key double-apply (BC-3.4.026, ADR-0019 §2(b))
  - VP-578-007   # :option byte-identity to bare (BC-3.4.027) — absorbs former VP-578-041.1
  - VP-578-008   # :option cascading Parent>Child composition (BC-3.4.027) — absorbs former VP-578-041.3; DE-PROVISIONALIZED per ADR-0019. EXTENDED per ADR-0019 § Amendment 2026-08-26 D3: a sibling no-panic proptest over arbitrary UTF-8 for the CALL-SITE `>` split (`str::split_once('>')`), ONE per call site (platform edit `field_resolve.rs` + platform create `create.rs`), FIX-F6-LRE-1 (#734) class — no new VP id (folded into VP-578-008, matching the BC-3.4.027 [EXTENDED] note)
  - VP-578-009   # :id value-kind mapping (BC-3.4.028) — absorbs former VP-578-042
  - VP-578-010   # :name value-kind mapping + --priority parity (BC-3.4.029) — absorbs former VP-578-043
  - VP-578-011   # :asset composer wire-shape correctness (BC-3.4.030) — absorbs former VP-578-044
  - VP-578-012   # :asset composer safety proptest — never malformed JSON body (BC-3.4.030) — absorbs former VP-578-046 + malformed-:asset part of VP-578-045. EXTENDED per F2 adversary-convergence round-2 Pass2-F3: the `WORKSPACE:OBJECTID` first-colon split MUST use `str::split_once(':')`; a no-panic proptest over arbitrary UTF-8 (multibyte scalar adjacent to `:`, e.g. `cf:asset=Wé:123`, EC-3.4.030-6) is folded into VP-578-012 — no new VP id, mirroring VP-578-008's D3 `>`-split extension
  - VP-578-013   # malformed-hint edge-case catalog: exit-64, one-error-per-invocation (BC-3.4.031) — absorbs former VP-578-045
  - VP-578-014   # EC-6/EC-7 regression pins: colon-in-VALUE resolves normally, unknown-kind fires the specific error (BC-3.4.031)
  - VP-578-017   # DEC-310 reversal: `--field` alone (no `--request-type`, well-formed) → exit 0, platform POST with field merged (BC-3.8.012) — realized §1.1 (rewritten holdouts H-NEW-PREFLIGHT-001/006 + create.rs guard-removal regression tests)
  - VP-578-018   # DEC-310 reversal: `--field --on-behalf-of` (no `--request-type`) → exit 64 via BC-3.8.013 standalone guard only, combined guard REMOVED (BC-3.8.012/013) — realized §1.1 (rewritten holdout H-NEW-PREFLIGHT-003 + create.rs guard-removal/combined-narrowing regression tests)
  - VP-578-019   # DEC-310 reversal regression pin: `--on-behalf-of` alone → exit 64 via BC-3.8.013, unchanged wire-for-wire (BC-3.8.013) — realized §1.1 (unchanged holdout H-NEW-PREFLIGHT-002 + create.rs guard-removal regression tests)
  - VP-580-005   # graceful-degrade: no enumerable options → exit 0, no panic on untyped allowedValues (BC-X.14.004) — absorbs former VP-580-041
related_bcs:
  - BC-3.3.010
  - BC-3.3.011
  - BC-3.4.015    # VP-578-023 "Applies to" (bare-form `>`-literal note back-fill, F2 round-5 MED-2); VP-578-024 side-effect cross-ref (EC-3.4.015-19)
  - BC-3.4.021    # VP-578-024 owning BC (dry-run `plannedChanges` hint-preview shape, F2 round-5 F-NEW-2)
  - BC-3.4.026
  - BC-3.4.027
  - BC-3.4.028
  - BC-3.4.029
  - BC-3.4.030
  - BC-3.4.031
  - BC-3.8.008
  - BC-3.8.012
  - BC-3.8.013
  - BC-X.14.001
  - BC-X.14.002
  - BC-X.14.003
  - BC-X.14.004
aligns_with_inline_vps:
  - VP-578-015    # JSM parity (bare-form byte-identical) — referenced by BC-3.8.008; relative parity claim on the bare/:option path, already within the existing :option JSM caveat — unchanged by the pass-16 reframe
  - VP-578-016    # JSM parity (:id/:name/:asset → requestFieldValues wire target) — referenced by BC-3.8.008. UNVERIFIED / parity-PENDING (adversary pass-16 MEDIUM-2): the JSM requestFieldValues WRITE wire shapes are NOT research-verified (research confirmed only the platform `fields` contract). This delta does NOT pin VP-578-016 as a firm verification target — it is an F4/live-validation-PENDING assertion, realized & verified at F4 against live JSM, not asserted firm at F2 (mirrors the existing :option JSM caveat and how VP-578-008 was carried while PROVISIONAL). BC-3.8.008 concurrently downgrades these shapes to UNVERIFIED to match. See §1.1.
adr_dependencies:
  - ADR-0019      # Accepted 2026-08-25 — confirms `>` cascading delimiter (split-on-first, `:id=` escape hatch); de-PROVISIONALizes VP-578-008. § Amendment 2026-08-26 (F2 adversary convergence): D1 narrows `resolve_field_context` to 3 bools + adds `resolve_m2_project` (→ VP-580-006 rewrite + VP-580-010); D2 extends Gate B to the create path via shared `detect_flag_field_overlap` (→ VP-578-021); D3 mandates `str::split_once('>')` at every cascading split site (→ VP-578-008 no-panic extension)
input-hash: "8c6b543"
---

# Verification Delta — Field DX Bundle (issues #580, #578)

## 0. Convention note + VP reconciliation — READ FIRST (no VP registry exists)

This repository has **no standalone VP-NNN registry file** and no verification-property
ARCH-INDEX. Confirmed this pass:

- `.factory/specs/architecture/ARCH-INDEX.md` exists but is an **ADR / subsystem** index
  (SS-01..SS-09, ADR rows) — it contains **zero** `VP-` references (`grep -c VP- → 0`).
  It is **not** updated by this delta, and must not be, because it is not a verification
  registry in the form the generic F2 skill assumes.
- `.factory/stories/S-PG-VP-REGISTRY-1-l4-verification-registry.md` explicitly documents
  the "ARCH-INDEX-equivalent for VPs" as an **open, not-yet-built** follow-up.

Per the established repo convention, property-style guarantees live as **inline `proptest!`
blocks and targeted unit/integration tests** co-located with the code they cover
(`src/duration.rs`, `src/jql.rs`, `src/adf.rs`, `src/partial_match.rs`,
`src/cli/issue/{create,edit,helpers,attachments}.rs`, `src/api/jsm/requests.rs`, …), and their
**VP-NNN identifiers are declared inline in the BC bodies** they verify
(`bc-3-issue-write.md`, `cross-cutting.md §X.14`). There is **no** second numbering namespace.

### 0.1 VP reconciliation — exactly one authoritative id per guarantee (F5 pass-1 fix)

An earlier revision of this delta minted a **parallel `VP-578-04x` / `VP-580-04x` band** for the
same guarantees the BC bodies already number inline (`VP-578-005..019`, `VP-580-001..005`). That
created **two ids for one property** — the exact duplication F5 pass-1 flagged. It is now
resolved: **the 04x band is retired.** Every property is labeled with its single canonical inline
VP id. The complete old-04x → canonical mapping (all nine former labels, not the three the prior
reconciliation note covered):

| Former delta label (RETIRED) | BC | Canonical inline VP | Relationship |
|---|---|---|---|
| VP-578-040 | BC-3.4.026 | **VP-578-005** | Same guarantee. VP-578-005 IS the multibyte no-panic proptest (`prop_field_hint_split_no_panic`); the delta's VALUE-byte-preservation + bare-form-invariance are additional assertions in that SAME proptest block, not a separate VP. |
| VP-578-041.1 | BC-3.4.027 | **VP-578-007** | Same guarantee — `:option` byte-identity to bare form. |
| VP-578-041.3 | BC-3.4.027 | **VP-578-008** | Same guarantee — cascading `Parent>Child` composition. **DE-PROVISIONALIZED** (ADR-0019, below). |
| VP-578-042 | BC-3.4.028 | **VP-578-009** | Same guarantee — `:id` bypasses `allowedValues`. |
| VP-578-043 | BC-3.4.029 | **VP-578-010** | Same guarantee — `:name` + `--priority` byte-parity. |
| VP-578-044 | BC-3.4.030 | **VP-578-011** | Same guarantee — `:asset` composer wire-shape correctness (warm-cache reuse). |
| VP-578-046 | BC-3.4.030 | **VP-578-012** | Same guarantee — `:asset` composer safety proptest (the inline VP-578-012 already names the `prop_sanitize_attachment_filename_no_path_traversal` parallel). |
| VP-578-045 | BC-3.4.031 (+ BC-3.4.026) | **VP-578-013** | Same guarantee — malformed-hint exit-64 catalog, one-error-per-invocation. Malformed-`:asset` shapes are jointly covered by VP-578-012. |
| VP-580-040 | BC-X.14.001 Inv 1 | **VP-580-006** *(NEW)* | **Gap, not a duplicate.** No inline VP covered Invariant 1's mutual-exclusion; VP-580-006 is added inline to BC-X.14.001. |
| VP-580-041 | BC-X.14.004 | **VP-580-005** | Same guarantee — graceful degrade (empty options → exit 0; the no-panic-on-arbitrary-`serde_json::Value` normalizer proptest is VP-580-005's property-test realization). |

**Seven genuinely-new VP-580 ids** are minted this delta (each ADDED to its BC body — VP-580-012's
own one-line back-fill to `cross-cutting.md` BC-X.14.004 is now DONE, ~line 2805; see §5). The F5-pass-1 set (four): three F5-gap
VPs — **VP-580-006** (BC-X.14.001 Invariant 1 mutual-exclusion), **VP-580-007** (BC-X.14.002
`--value` filter), **VP-580-008** (BC-X.14.003 output shape) — plus the pass-20 regression pin
**VP-580-009** (BC-X.14.004 `--project --request-type` is a VALID M3, not an arity error; realized
WITHIN VP-580-006's arity proptest, not a separate core-surface row). The **F2
adversary-convergence pass (2026-08-26)** adds three more: **VP-580-010** (BC-X.14.001, ADR-0019
§ Amendment D1 — the separate post-arity `resolve_m2_project` step, flag-OR-profile/config-default;
exit 64 pre-HTTP only when NEITHER exists), **VP-580-011** (BC-X.14.002, B-LOW — the `--value` +
graceful-degrade interaction, VP-580-005 companion), and the round-2 Pass2-F2 regression pin
**VP-580-012** (BC-X.14.004 — the `--project` not-found (404) HTTP-failure class on the M2 + M3
enumeration paths; realized WITHIN VP-580-004's per-row taxonomy coverage, not a separate
core-surface row, mirroring VP-580-009). All seven **extend** the existing `VP-580-0xx`
sequence (prior max was `005`, now `012`); they are NOT a parallel band.

**Five VP-578-0xx ids are newly minted across this cycle** — **VP-578-020** (createmeta-family
multi-page resolution, BC-3.3.010; FIELDS half = adversary pass-28 F-1, ISSUE-TYPES half = adversary
pass-29 F-1 — C-LOW attribution now synced to BC-3.3.010's own pass-29 attribution), the two
**F2 adversary-convergence (2026-08-26)** additions **VP-578-021** (BC-3.3.010, ADR-0019 § Amendment
D2 + § "D2 correction" — the create-path Gate-B collision guard via shared `detect_flag_field_overlap`,
EXTENDED round-5 to the ten-member create governed set) and **VP-578-022**
(BC-3.4.030, B-LOW — the `:asset` cold-cache workspace-discovery failure taxonomy), the
**F2 adversary-convergence round-4 (2026-08-26)** addition **VP-578-023** (BC-3.4.027 EC-3.4.027-7 /
BC-3.4.015, ADR-0019 § Amendment D4 — the non-cascading `>`-collision message + bare-form
`>`-literal behavior; sibling to VP-578-008), plus the **F2 adversary-convergence round-5
(2026-08-26)** addition **VP-578-024** (BC-3.4.021, F-NEW-2 — the dry-run `plannedChanges`
hint-preview wire shape + `:asset` cold-cache side effect). Every other #578
guarantee already had an inline id. The full declared inline span is now **VP-578-001..024** (all
twenty-four ids are declared inline in `bc-3-issue-write.md` — VP-578-023's BC-body declaration is
now DONE at BOTH sites (BC-3.4.027 declared + BC-3.4.015 back-filled by the PO this round, F2 round-5
MED-2); VP-578-024 was assigned this round, replacing the PO's `VP-DRY-RUN-005` placeholder in
BC-3.4.021 — see §5): VP-578-001/002/003 on BC-3.3.010
(platform-create createmeta resolution / cache-sharing / all-or-nothing), VP-578-004 on BC-3.3.011
(create-path error taxonomy), VP-578-005..014 the value-kind / hint-splitter / malformed-catalog
guarantees this delta realizes (§1), VP-578-015/016 the JSM parity pair (frontmatter
`aligns_with_inline_vps`; VP-578-016 is **UNVERIFIED / parity-PENDING** — its `requestFieldValues`
write shapes are realized at F4 against live JSM, not pinned firm by this delta — see §1.1),
VP-578-017/018/019 the DEC-310 reversal's own VPs on BC-3.8.012/013, VP-578-020 the createmeta-family
offset-pagination guarantee on BC-3.3.010 — covering **BOTH** the FIELDS (`get_createmeta_fields`, `--field`)
and ISSUE-TYPES (`get_issue_types_for_project`, `--type`) createmeta endpoints — VP-578-021/022 the
two earlier F2-amendment additions (create-path Gate-B guard on BC-3.3.010; `:asset` cold-cache failure
taxonomy on BC-3.4.030), **VP-578-023** the round-4 D4/F-2 addition (non-cascading `>`-collision
message + bare-form `>`-literal, BC-3.4.027 EC-3.4.027-7 / BC-3.4.015), and **VP-578-024** the
round-5 F-NEW-2 addition (dry-run `plannedChanges` hint-preview wire shape + `:asset` cold-cache side
effect, BC-3.4.021). Note **D3** (cascading
`>`-split multibyte safety) mints **no** new id: its no-panic
call-site proptest is folded into **VP-578-008** as an extension (matching BC-3.4.027's own [EXTENDED]
note — see §2 VP-578-008 and §0.2); D4 (cell a/b) DOES mint a new id (VP-578-023) because it pins a
distinct error message + a bare-form behavioral contract + a type change, none covered by VP-578-008.
Apart from VP-578-020/021/022/023/024, the delta only supplies proptest/unit
realizations; it mints no other new #578 id. §1.1 catalogs where each of the ten #578 ids NOT in
the §1 core table (VP-578-001..004, 017..022) is realized — none is left without a realization
pointer.

### 0.2 ADR-0019 dependency — cascading delimiter is CONFIRMED, not provisional

`ADR-0019` (Accepted, 2026-08-25) ratifies the `>` cascading-select delimiter: **split on the
FIRST literal `>` only**, with **`:id=` as the documented escape hatch** for a display value that
legitimately contains a `>`. This resolves the open design question the product-owner had marked
PROVISIONAL. Consequently **VP-578-008 and its cascading assertions are NO LONGER PROVISIONAL** —
they ship this cycle alongside the non-cascading `:option` byte-identity (VP-578-007). The
inline VP-578-008 marker in `bc-3-issue-write.md` was cleared this pass.

---

## 1. Scope

Twenty authoritative VP guarantees form this delta's **core proptest/unit surface** (eleven
realizations of existing inline VPs + nine new inline VPs — the F5-pass-1 trio VP-580-006/007/008
plus the four F2 adversary-convergence round-1/2 additions VP-578-021, VP-578-022, VP-580-010,
VP-580-011, plus the round-4 D4/F-2 addition VP-578-023, plus the **round-5 F-NEW-2 addition
VP-578-024** — dry-run `plannedChanges` hint-preview shape),
grouped by concern. **All ids are the canonical inline ids** (§0.1). A further **eight** declared
#578 inline VPs (VP-578-001..004, 017..020) are realized by reuse, by the DEC-310 reversal's
holdout/regression work, and (VP-578-020) by the new createmeta-pagination tests (**both** the
FIELDS and ISSUE-TYPES createmeta endpoints) — catalogued separately in **§1.1** — as is the
JSM-parity pair VP-578-015/016 (frontmatter
`aligns_with_inline_vps`; **VP-578-016's `:id`/`:name`/`:asset` `requestFieldValues` write shapes
are UNVERIFIED / parity-PENDING — realized at F4 against live JSM, not pinned firm by this delta;
see §1.1**). The full declared inline inventory this delta touches is **thirty-two**
VPs: the twenty-four #578 ids (VP-578-001..024) plus VP-580-005..012 (VP-580-001..004 were declared
inline by the product-owner pass — not minted by this verifier delta — and are realized at F4
alongside the new `src/cli/field.rs` command, still unimplemented; this delta adds no further
realization work for them, so they fall outside its realization surface). **D3** adds no id — its
cascading-`>`-split no-panic proptest is folded into VP-578-008 (§2, §0.1).

| VP (canonical) | Concern | BC(s) | Kind | Primary target file | Status |
|---|---|---|---|---|---|
| VP-578-005 | Hint-splitter multibyte/Unicode-scalar safety | BC-3.4.026 | proptest | `src/cli/issue/create.rs` (`parse_field_kv` block) | realizes inline |
| VP-578-006 | Bare-name map key: last-wins ACROSS kinds (no composite `"name:kind"` key → no ADR-0019 §2(b) double-apply) | BC-3.4.026 | proptest | `src/cli/issue/create.rs` (`parse_field_kv` field-map insert; new proptest asserting repeated `--field cf:...` for one NAME yields exactly one map entry, last-wins — sibling to `prop_parse_field_kv_last_value_wins_on_duplicates`) | realizes inline |
| VP-578-007 | `:option` → byte-identical to bare | BC-3.4.027 | proptest + unit | `src/cli/issue/field_resolve.rs` | realizes inline |
| VP-578-008 | `:option` cascading `Parent>Child` composition | BC-3.4.027 | unit | `src/cli/issue/field_resolve.rs` | realizes inline — **CONFIRMED (ADR-0019)** |
| VP-578-009 | `:id` → `{"id":v}` verbatim, no lookup | BC-3.4.028 | proptest + unit | `src/cli/issue/field_resolve.rs` | realizes inline |
| VP-578-010 | `:name` → `{"name":v}`; `--field priority:name=X` ≡ `--priority X` | BC-3.4.029 | unit (byte-parity) | `field_resolve.rs` + `tests/issue_edit_field.rs` | realizes inline |
| VP-578-011 | `:asset` → `[{workspaceId,id,objectId}]` wire shape | BC-3.4.030 | unit + wiremock | `field_resolve.rs` + `tests/issue_field_hint_kinds.rs` (new) | realizes inline |
| VP-578-012 | `:asset` composer safety (never malformed JSON body) | BC-3.4.030 | proptest | `src/cli/issue/field_resolve.rs` (composer fn) | realizes inline |
| VP-578-013 | Malformed-hint catalog → exit 64, one error/invocation | BC-3.4.031, BC-3.4.026 | proptest + unit | `create.rs` / `field_resolve.rs` | realizes inline |
| VP-578-014 | EC-6/EC-7 REGRESSION PINS (EC-6: `:asset=W:Y` colon-in-VALUE resolves NORMALLY, not an error; EC-7: unknown kind fires the SPECIFIC unknown-kind error, not a different one) | BC-3.4.031 | unit (regression) | `tests/issue_field_hint_kinds.rs` (new) EC-6/EC-7 table + `create.rs`/`field_resolve.rs` | realizes inline |
| VP-580-005 | Graceful degrade: no options → exit 0, no panic | BC-X.14.004 | proptest + wiremock | new `src/cli/field.rs` + `tests/field_options.rs` (new) | realizes inline |
| **VP-580-006** | Context mutual-exclusion (exactly one of three), pre-HTTP | BC-X.14.001 | proptest + wiremock | `field_resolve.rs` or new `src/cli/field.rs` | **NEW inline** |
| **VP-580-007** | `--value` client-side substring filter correctness | BC-X.14.002 | unit + proptest | new `src/cli/field.rs` + `tests/field_options.rs` (new) | **NEW inline** |
| **VP-580-008** | Table/JSON output shape (`{id,label,children}`) | BC-X.14.003 | unit + integration | new `src/cli/field.rs` + `tests/field_options.rs` (new) | **NEW inline** |
| **VP-578-021** | Create-path Gate-B collision guard over the TEN-member create governed set (F-NEW-1: 5 original static + 3 new static `labels`/`parent`/`assignee` + 2 DISTINCT resolved-id `points`/`team` via `customfield_NNNNN=` bypass only, guard fires SEPARATELY for each of `--points` and `--team`) — any argv order × any hint kind → exit 64, ZERO HTTP; symmetric with edit's EC-3.4.017-16; + NEGATIVE pin (`--points 5 --field "Story Points"=8` does NOT trip) | BC-3.3.010 | unit + integration | `src/cli/issue/field_resolve.rs` (`detect_flag_field_overlap`) + integration per call site (edit + create) | **NEW inline (F2 D2); EXTENDED F2 round-5 F-NEW-1** |
| **VP-578-022** | `:asset` cold-cache workspace-discovery FAILURE taxonomy (each row exercised on ALL THREE call sites: edit, platform-create, JSM-create) | BC-3.4.030 | wiremock (per-row) | `src/api/assets/workspace.rs::get_or_fetch_workspace_id` call sites (edit `field_resolve.rs`, platform `create.rs`, JSM `jsm_create.rs`) + `tests/issue_field_hint_kinds.rs` (new) | **NEW inline (F2 B-LOW, Pass2-F1)** |
| **VP-578-023** | Non-cascading `>`-collision message (`:option` on a plain `option` field, empty `children` → exit 64, pinned `"is not a cascading select"` + `"remove the"`) + bare-form `>`-literal (no split → EC-3.4.016-2 fall-through) + `AllowedValue.children: Vec` type dep | BC-3.4.027 (EC-3.4.027-7), BC-3.4.015 | unit + wiremock/fixture + serde | `src/cli/issue/field_resolve.rs` + `create.rs` platform-create path + `src/types/jira/editmeta.rs` (`AllowedValue.children`) | **NEW inline (F2 round-4 D4 / F-2)** |
| **VP-580-010** | M2 post-arity project resolution (`resolve_m2_project`): flag OR profile/config default → Ok; NEITHER → exit 64 pre-HTTP | BC-X.14.001 | unit + proptest | new `src/cli/field.rs` (`resolve_m2_project`) + `tests/field_options.rs` (new) | **NEW inline (F2 D1)** |
| **VP-580-011** | `--value` + graceful-degrade interaction (filter post-fetch; degrade hint still fires; stdout `[]`, exit 0) | BC-X.14.002 | wiremock + unit | new `src/cli/field.rs` + `tests/field_options.rs` (new) | **NEW inline (F2 B-LOW)** |
| **VP-578-024** | Dry-run `plannedChanges` hint-preview wire shape per kind (`:id`→`{"id":…}`, `:name`→`{"name":…}`, `:option` non-cascading→`{"id":…}`, cascading→`{"value":…,"child":{"value":…}}`, `:asset`→`[{workspaceId,id,objectId}]`; NOT bare-form display string; PUT `.expect(0)`) + `:asset` cold-cache side effect (real `get_or_fetch_workspace_id` GET fires under `--dry-run`, can exit 64 before any `plannedChanges` output) | BC-3.4.021 (cross-ref BC-3.4.027/028/029/030 + EC-3.4.015-18/-19) | unit + integration + wiremock | `src/cli/issue/edit.rs::handle_edit` dry-run block + `field_resolve.rs` composers + `src/api/assets/workspace.rs` | **NEW inline (F2 round-5 F-NEW-2)** |

**VP-580-009 (regression guard — realized WITHIN VP-580-006, not a separate core-surface row).**
VP-580-009 (BC-X.14.004) — `--project --request-type` together is a **VALID M3** invocation
(explicit service-desk project), **NOT an arity error** (adversary pass-20 M1; ADR-0019 §1) — is a
**newly-minted inline VP this cycle** (frontmatter `new_properties`), but it is **not** an
independent fifteenth core-surface realization: it is realized as the **positive
`--project --request-type → Ok` case** of VP-580-006's `resolve_field_context` arity proptest
(§2 VP-580-006, `src/cli/issue/field_resolve.rs`) together with the paired **positive** wiremock
assertion VP-580-006 already prescribes in `tests/field_options.rs` (that
`--project --request-type` does **not** trip the guard). It carries its own id purely as a durable
**regression pin** against re-introducing the superseded "pairing-error" behavior.

**VP-580-012 (regression pin — realized WITHIN VP-580-004, not a separate core-surface row).**
VP-580-012 (BC-X.14.004, F2 adversary-convergence round-2 Pass2-F2) — a nonexistent/inaccessible
`--project` on `jr field options` produces a genuine **HTTP 404** (distinct from the *pre-HTTP*
arity/companion-absent rejections owned by VP-580-006/010, and from the non-JSM *wrong-type* row):
on **M2** the 404 surfaces from whichever createmeta-family call runs first
(`get_issue_types_for_project`'s `GET .../createmeta/{project}/issuetypes`, or
`get_createmeta_fields`), and on **M3** from `get_or_fetch_project_meta`'s
`GET /rest/api/3/project/{key}` — each mapped to **exit 64, "project not found or not accessible",
zero mutating HTTP**. Like VP-580-009, it is a **newly-minted inline VP this cycle** (frontmatter
`new_properties`) but **not** an independent core-surface realization: it is realized **WITHIN
VP-580-004's** "each row of the error taxonomy table is independently exercised" per-row coverage
(the new taxonomy row + EC-X.14.004-6 the product-owner added this round), carrying its own id
purely as a durable regression pin for this distinct two-path HTTP-failure class. The PO left the
"new row → own VP?" question explicitly open (Pass2-F2); this verifier **decided YES** — a distinct
error class with a pinned message ("project not found or not accessible") on two enumeration paths
warrants a dedicated regression id. **DONE (F2 round-4):** VP-580-012's inline BC-body declaration
now exists in `cross-cutting.md` BC-X.14.004's Verification Properties (~line 2805, alongside
VP-580-004/005/009, anchored to the new `--project not found (404)` taxonomy row + EC-X.14.004-6) —
the round-2/round-3 "pending one-line back-fill" flag is CLOSED; no further state-manager/PO action
is required for VP-580-012's BC anchor.

This is why the delta's full declared inline inventory is **thirty-two** (twenty-four #578
[VP-578-001..024] + VP-580-005..012) while the §1 core surface is **twenty** new
proptest/unit/integration realizations (VP-578-024 is the new core-surface row this round — dry-run
`plannedChanges` hint-preview; VP-578-023 was the new core-surface row the prior round; VP-580-009
remains realized within VP-580-006, and VP-580-012 within VP-580-004 — neither of those two is a
separate core-surface row).

### 1.1 Remaining declared #578 inline VPs — realization pointers (realized outside the §1 core surface)

The §1 table lists the twenty guarantees this delta realizes as **new** proptest/unit/integration
work (including the four F2-amendment #578 additions VP-578-021/022/023/024, which sit in the §1 core
surface, not here). For completeness, the remaining **eight** declared `VP-578-0xx` ids realized
OUTSIDE the §1 core surface — the full #578 inline span is now **VP-578-001..024** (VP-578-023's
BC-body declaration is now DONE at both sites and VP-578-024 was assigned this round, §5) — are
realized as follows.
**None is left without a realization pointer.**
VP-578-001..004 are the platform-**create** path VPs (realized largely by reuse of the VP-396-009
**edit**-path realizations, transplanted to create); VP-578-017/018/019 are the **DEC-310 reversal's**
own VPs (realized by the rewritten holdout scenarios + the `create.rs` guard-removal regression
tests); **VP-578-020** (FIELDS half = adversary pass-28 F-1; ISSUE-TYPES half = adversary pass-29 F-1)
is the createmeta-family offset-pagination guarantee across **both** createmeta endpoints (FIELDS via
`get_createmeta_fields` / `--field`, and ISSUE-TYPES via `get_issue_types_for_project` / `--type`),
realized by new two-page createmeta wiremock tests (one per endpoint) in `tests/issue_create_field.rs`. The
JSM-parity pair VP-578-015/016 is separately accounted for by the
frontmatter `aligns_with_inline_vps` list, with the confidence framing below.

**VP-578-016 confidence — UNVERIFIED / parity-PENDING (F2 reframe, adversary pass-16 MEDIUM-2).**
VP-578-016 asserts that the JSM `:id` / `:name` / `:asset` hints produce the **same wire shapes**
as their platform-path counterparts, targeting `requestFieldValues` instead of `fields`. Those
JSM `requestFieldValues` **write** wire shapes are **NOT research-verified** — research confirmed
only the platform `fields` contract. This delta therefore does **NOT** pin VP-578-016 as a firm,
settled verification target: it is an **F4 / live-validation-PENDING** assertion, **realized and
verified at F4 against live JSM**, not asserted firm at F2. This is exactly the posture already
applied to the `:option` JSM shape caveat, and mirrors how **VP-578-008** was carried while it was
**PROVISIONAL** (until ADR-0019 confirmed it — §0.2; VP-578-016 has no such confirming ADR yet, so
it stays PENDING). BC-3.8.008 is being downgraded in parallel (product-owner) to mark these shapes
UNVERIFIED, matching the existing `:option` caveat — this delta keeps VP-578-016 consistent with
that. **VP-578-015** (bare-form byte-identity) is **unaffected** by this reframe: it is a *relative*
parity claim on the bare / `:option` path, already within the scope of the existing `:option` JSM
caveat, and introduces no additional unverified JSM wire-shape assertion of its own.

| VP (canonical) | Concern | BC | Realized by |
|---|---|---|---|
| VP-578-001 | `--field` on platform create resolves via **createmeta**, never `editmeta` (no `GET …/editmeta` on the create path) | BC-3.3.010 | Platform create-path tests in `tests/issue_create_field.rs` exercising the `create.rs` createmeta resolution path; **reuses** the VP-396-009 edit-path resolution realization transplanted to create. |
| VP-578-002 | Field-list cache (`fields.json`) **shared** between `issue edit --field` and `issue create --field` (same profile) | BC-3.3.010 | `tests/issue_create_field.rs` warm-cache reuse assertion (a cache populated by `edit --field` satisfies `create --field`); shares the `resolve_edit_fields` / `write_fields_cache` realization from VP-396-009. |
| VP-578-003 | **All-or-nothing** multi-`--field` failure on create (zero POST on any resolution failure) | BC-3.3.010 | `tests/issue_create_field.rs` create-path variant; explicitly **transplants** VP-396-009's edit-path all-or-nothing semantics to the create path (per the BC-3.3.010 / VP-578-003 body). |
| VP-578-004 | Create-path `--field` **error-taxonomy** rows each independently exercised | BC-3.3.011 | Per-row wiremock tests in `tests/issue_create_field.rs` asserting exit 64, zero POST, and the exact load-bearing substring for each taxonomy row (same discipline the inline VP-578-004 body prescribes). |
| VP-578-017 | `--field a=b` alone (no `--request-type`, well-formed) → exit 0, platform POST fires with the field merged in; stderr has NO `"--field is only valid with"` | BC-3.8.012 (CURRENT) | **Rewritten** holdout scenarios **H-NEW-PREFLIGHT-001** (table mode) + **H-NEW-PREFLIGHT-006** (`--output json` variant), plus the `create.rs` guard-**removal** regression tests inverting the dead DEC-188 exit-64 assertions. |
| VP-578-018 | `--field a=b --on-behalf-of X` (no `--request-type`) → exit 64 via BC-3.8.013's **standalone** guard only (combined guard REMOVED, createmeta resolution never reached) | BC-3.8.012 / BC-3.8.013 (CURRENT) | **Rewritten** holdout scenario **H-NEW-PREFLIGHT-003**, plus the `create.rs` guard-removal / combined-check-narrowing regression tests. |
| VP-578-019 | Regression pin: `--on-behalf-of X` **alone** → exit 64 via BC-3.8.013, **unchanged wire-for-wire** from DEC-188-era behavior (proves the reversal did not weaken BC-3.8.013) | BC-3.8.013 | **Unchanged** holdout scenario **H-NEW-PREFLIGHT-002** + the `create.rs` guard-removal regression tests (which assert BC-3.8.013's standalone guard survives untouched). |
| **VP-578-020** *(NEW — FIELDS half: adversary pass-28 F-1; ISSUE-TYPES half: adversary pass-29 F-1 — attribution synced to BC-3.3.010, C-LOW)* | Createmeta-**family** multi-page resolution across **BOTH** offset-paginated createmeta endpoints (ADR-0019 §1): **(a) FIELDS** — `get_createmeta_fields` is offset-paginated, so a `--field` whose target field falls on fields-**page ≥2** is collected and resolves normally (**exit 0**, field merged into the create POST body), **never silently dropped** because only page 1 was read; **AND (b) ISSUE-TYPES** — `get_issue_types_for_project` (the `--type` name→id resolution, `src/api/jira/issues.rs`) is **likewise** offset-paginated (`startAt`/`maxResults`/`total`), so a `--type` whose entry falls on issuetypes-**page ≥2** resolves to its `issueTypeId` (**exit 0**), **never dropped** for the same reason. Mirrors the `list_worklogs` / BC-X.5.002 all-pages precedent (single-page fetch silently truncates → must paginate). | BC-3.3.010 | Two new **two-page createmeta wiremock** tests in `tests/issue_create_field.rs`, **one per endpoint**: **(a) fields** — page 1 returns `maxResults` fields **without** the target, page 2 returns the target field; asserts the `--field` resolves to **exit 0** with the field present in the composed POST body, **and** that the client fetches **BOTH** pages. **(b) issue-types** — page 1 returns `maxResults` issue types **without** the target `--type`, page 2 returns the target; asserts the `--type` resolves (to its `issueTypeId`, **exit 0**) **and** that **BOTH** pages are fetched. In each case a `.expect(1)`-style single-page assumption would false-red. Models the `list_worklogs` all-pages pagination test precedent. |

---

## 2. Property definitions

### VP-578-005 — Hint-splitter multibyte / Unicode-scalar safety

**Applies to**: BC-3.4.026 (`--field NAME:kind=VALUE` hint-syntax parser; `parse_field_kv`
gains kind-tag parsing shared across all 3 `--field` call sites). This is the delta's proptest
realization of the **inline VP-578-005** (`prop_field_hint_split_no_panic`, declared in the
BC-3.4.026 body). *(Former delta label VP-578-040 — retired, see §0.1.)*

**Bug class**: identical to `FIX-F6-LRE-1`. The moment `parse_field_kv` starts splitting on
`:` (in addition to its current `=` split), any byte-offset slice (`pair[..pos]`,
`split_at`, `pair[pos+1..]`) computed from a `find`/`memchr` position risks landing inside a
multibyte UTF-8 scalar when NAME, `kind`, or VALUE contains non-ASCII — panicking exactly as
`validate_duration`'s `split_at` did on `"7é"`. BC-3.4.026's own Multibyte-safety requirement
(MUST) mandates char-boundary-safe slicing (`char_indices`/`.find(char)`, never raw byte-index
slicing).

**Property statement** (for arbitrary UTF-8 NAME, `kind`, and VALUE, and any placement of
`:` / `=`):
1. **No panic.** `parse_field_kv` returns `Ok` or `Err(JrError::UserError)` for every input,
   never unwinds. (Direct extension of the existing
   `prop_parse_field_kv_no_panic_on_arbitrary_input`.)
2. **Exactly one classification.** The result is either a well-formed field spec
   (`{name, kind, value}`) OR a clean exit-64 `UserError` — never a partial/ambiguous state.
3. **VALUE byte-preservation (round-trip).** For a well-formed hinted pair, the VALUE segment
   (everything after the *first* `=`) is preserved **byte-for-byte**, including embedded `=`,
   `:`, and multibyte scalars. The `:kind` tag is parsed from the NAME side (before the first
   `=`) only — a `:` appearing **after** the first `=` is part of VALUE, never a kind
   delimiter (this is what makes `:asset=W:Y` work: the `W:Y` colon is in VALUE; BC-3.4.031 EC-6).
4. **Bare-form invariance.** A pair with no `:kind` on the NAME side (`NAME=VALUE`) parses
   byte-identically to today's `parse_field_kv` output (`kind: None`) — BC-3.4.026 Invariant 1,
   permanent. Existing `prop_parse_field_kv_first_equals_split` / `_empty_value_allowed` /
   `_last_value_wins_on_duplicates` must remain **green unchanged**.

**Recommended proptest strategy** — extend the existing `proptest! { … }` block in
`src/cli/issue/create.rs` (the parser is the shared `parse_field_kv`; this file is already in
`.cargo/mutants.toml` `examine_globs`):

```rust
proptest! {
    /// VP-578-005 (no-panic): arbitrary UTF-8 hinted input never panics.
    #[test]
    fn prop_field_hint_split_no_panic(raw in "\\PC{0,80}") {   // any Unicode scalars, incl. multibyte
        let _ = parse_field_kv(&[raw]);                          // must not panic
    }

    /// VP-578-005 (VALUE byte-preservation): VALUE after first '=' is preserved byte-for-byte,
    /// even with multibyte scalars and embedded ':' / '='.
    #[test]
    fn prop_field_hint_value_bytes_preserved(
        name  in "[a-z][a-z0-9_]{0,19}",
        kind  in prop::option::of("option|id|name|asset"),
        value in "\\PC{0,40}",                                   // arbitrary UTF-8, incl. é 世 🦀
    ) {
        let tag = kind.map(|k| format!(":{k}")).unwrap_or_default();
        let pair = format!("{name}{tag}={value}");
        if let Ok(spec) = parse_field_kv(&[pair]) {
            // whichever accessor F4 chooses, the raw VALUE bytes equal `value`
            prop_assert_eq!(spec_value_of(&spec, &name), value.as_str());
        }
    }

    /// VP-578-005 (bare-form invariance): bare form (no :kind) => kind None, byte-identical to legacy.
    #[test]
    fn prop_field_hint_bare_form_unchanged(
        name in "[a-z][a-z0-9_]{0,19}", value in "\\PC{0,40}",
    ) {
        let spec = parse_field_kv(&[format!("{name}={value}")]).unwrap();
        prop_assert_eq!(spec_kind_of(&spec, &name), None);
        prop_assert_eq!(spec_value_of(&spec, &name), value.as_str());
    }
}
```

Plus a **named regression unit test** mirroring
`validate_duration_multibyte_unit_returns_err_not_panic`, e.g.
`test_field_hint_multibyte_kind_and_value_no_panic`, pinning concrete inputs
(`"cf:optioné=x"`, `"世=界"`, `"a:asset=W:🦀"`).

**COVERAGE NOTE — colon-INSIDE-the-NAME is unexercised (LOW, adversary streak Pass-3; flagged for the
F4/F5 author).** Both the recommended proptest strategy above (`name in "[a-z][a-z0-9_]{0,19}"`, which
admits no `:`) and the concrete regression inputs place the `:kind` tag delimiter only at the
NAME/kind boundary — none exercises a field NAME that itself CONTAINS a colon. BC-3.4.026 step 2
resolves the kind tag by splitting on the **LAST `:` before the first `=`** (not the first `:`),
precisely so that a field literally named `"Region: EMEA"` is still hint-taggable — but that
last-`:`-split branch is untested by the strategy as written. The F4/F5 author MUST add at least one
regression input (and, ideally, a widened proptest `name` strategy that can emit an internal `: `)
covering a colon-in-NAME case, e.g.:
- `--field "Region: EMEA:option=X"` → split on the **LAST** `:` before `=` → name `"Region: EMEA"`
  (colon preserved verbatim in the NAME), kind `option`, value `X`. A first-`:` split would wrongly
  yield name `"Region"`, kind `" EMEA:option"` → this is the exact defect the last-`:` rule prevents,
  and the regression input pins it.
- Companion negative form `--field "Region: EMEA=X"` (colon in NAME, NO kind tag) → the whole
  `"Region: EMEA"` is the bare NAME, `kind: None`, value `X` (bare-form invariance, property 4 — a
  NAME-internal `:` with no trailing `:kind` must NOT be misread as a kind delimiter).

This is a strategy/regression-input gap, not a spec change: VP-578-005's four properties already cover
the guarantee; the recommended inputs simply never reach the last-`:`-split branch. Property 3's
byte-preservation and property 4's bare-form invariance both apply to these inputs and must stay green.

**Target**: `src/cli/issue/create.rs` (proptest block) + regression unit test in same file.
**F6**: already covered — `create.rs` ∈ `examine_globs`.

---

### VP-578-007 — `:option` byte-identity to bare form

**Applies to**: BC-3.4.027 (`:option` explicit opt-in to today's label/id auto-detect;
byte-identical wire output to bare form). Realizes **inline VP-578-007**. *(Former delta label
VP-578-041.1 — retired.)*

**Property statement**:
1. **Byte-identity to bare.** For a non-cascading value, the JSON emitted for
   `--field cf:option=V` is **byte-identical** to the JSON emitted for the bare
   `--field cf=V` against the same editmeta/createmeta `allowedValues` (BC-3.4.016
   auto-detect). `:option` changes nothing on the wire — it only makes the intent explicit.
2. **Simple option shape.** A resolved simple option emits `{"value":"V"}` (or the
   BC-3.4.016 tenant-dependent `{"id":...}` resolution) — same dispatch as BC-3.4.016.

**Recommended strategy**: a property test asserting **wire-byte-equality** between `:option`
and bare over a generated set of `(value, allowedValues)` pairs is the highest-value guard:

```rust
// VP-578-007 (proptest, field_resolve.rs)
fn prop_option_hint_wire_identical_to_bare(value in "[A-Za-z0-9 ]{1,20}") {
    let av = fixture_allowed_values();
    prop_assert_eq!(
        emit_field_json(&av, "cf", Some(Kind::Option), &value),  // :option
        emit_field_json(&av, "cf", None,               &value),  // bare
    );
}
```

**Target**: `src/cli/issue/field_resolve.rs` (unit + proptest). **F6**: `field_resolve.rs`
should be **added to `.cargo/mutants.toml` `examine_globs`** for this cycle (see §4).

---

### VP-578-008 — `:option` cascading `Parent>Child` composition (CONFIRMED, ADR-0019)

**Applies to**: BC-3.4.027 cascading arm. Realizes **inline VP-578-008**. *(Former delta label
VP-578-041.3 — retired.)* **This property is NO LONGER PROVISIONAL** — ADR-0019 (Accepted
2026-08-25) confirms the delimiter and split rule (§0.2). F4 may lock these assertions this cycle.

**Property statement**:
1. **Cascading shape.** `--field cf:option=Parent>Child` emits
   `{"value":"Parent","child":{"value":"Child"}}` (BC-3.4.027 wire shape).
2. **Split-on-first-`>` (ADR-0019 §3).** The VALUE is split on the **first literal `>` only**;
   Jira's cascading model is exactly two levels (parent + one optional child, `children[]` flat),
   so a second `>` (e.g. `Parent>Child>trailing`) is taken verbatim as part of the child value —
   never a third level.
3. **Parent-only.** A cascading-field value with no `>` resolves the parent only (child unset) —
   Jira accepts a parent-only cascading value.
4. **`>`-in-label escape hatch (ADR-0019 §3).** A legitimate option label containing a literal
   `>` (BC-3.4.027 EC-4 collision) is reachable via the `:id=<numeric-id>` path (VP-578-009),
   which bypasses `allowedValues`/cascading parsing entirely — the user is redirected, never stuck.

**EXTENDED — D3 multibyte no-panic on the CALL-SITE `>` split (ADR-0019 § Amendment 2026-08-26 D3,
FIX-F6-LRE-1 / #734 class).** The `>` split runs at the CALL SITE — `field_resolve.rs` (platform
edit path) and the analogous point in `create.rs`'s platform-create path (BC-3.3.010) — NOT inside
`parse_field_kv` (whose own Unicode-scalar-safety MUST, BC-3.4.026 step 5, is scoped to steps 1–2
and does not cover this site). A naive char-index-as-byte-offset implementation
(`value.chars().position(|c| c == '>')` used directly as a byte slice bound) panics whenever a
multibyte scalar precedes the `>` in the parent segment — e.g. `--field 'cf:option=Pré>Bñ'` — the
same conflation FIX-F6-LRE-1 remediated. ADR-0019 § Amendment D3 mandates `str::split_once('>')`
(never a char-index or fixed-byte-offset scheme). **This D3 obligation adds NO new VP id — it is
folded into VP-578-008** (matching BC-3.4.027's own [EXTENDED 2026-08-26, D3] note).
5. **No panic on any UTF-8 input (D3).** For arbitrary UTF-8 VALUE — including a `>` byte adjacent
   to a multibyte scalar (`Pré>Bñ`, `世>界`, `🦀>x`, `x>🦀`, leading/trailing/doubled `>`, no `>`)
   — the cascading `>` split never panics; it returns `Ok`/`Err(UserError)` only. Asserted by a
   no-panic proptest **per call site** (platform edit, platform create), mirroring
   `validate_duration`'s FIX-F6-LRE-1 proptest and VP-578-005's `parse_field_kv` splitter coverage.

**Recommended strategy**: deterministic unit tests over a mocked cascading `allowedValues`
fixture (`allowedValues[].value` + matched-parent `children[].value`), covering: two-segment
compose, second-`>`-goes-to-child, parent-only, EC-3.4.027-2 (unresolvable parent → exit 64),
EC-3.4.027-3 (unresolvable child → exit 64), EC-3.4.027-6 (empty parent `>Child` / empty child
`Parent>` → exit 64), and the EC-4 `:id=` fallback for a `>`-bearing label. **Plus a D3 no-panic
proptest at each call site:**
```rust
proptest! {
    /// VP-578-008 (D3 no-panic): call-site '>' split never panics on arbitrary UTF-8.
    #[test]
    fn prop_cascading_split_no_panic(raw in "\\PC{0,80}") {   // incl. '>' adjacent to multibyte scalars
        let _ = split_cascading_value(&raw);   // str::split_once('>') internally — must not panic
    }
}
```
one instance in `field_resolve.rs` (edit path) and one at the analogous `create.rs` platform-create
split site, plus a named regression unit test pinning `"Pré>Bñ"` (mirrors
`validate_duration_multibyte_unit_returns_err_not_panic`).

**Target**: `src/cli/issue/field_resolve.rs` (cascading composer + unit tests) AND the analogous
`create.rs` platform-create split site (D3 proptest per call site). **F6**: `create.rs` already ∈
`examine_globs`; add `field_resolve.rs` (§4).

---

### VP-578-023 — Non-cascading `>`-collision message + bare-form `>`-literal behavior *(NEW inline VP — F2 adversary convergence round-4, ADR-0019 § Amendment D4 / adversary F-2)*

**Applies to**: BC-3.4.027 EC-3.4.027-7 (non-cascading collision) and BC-3.4.015 (bare-form
`>`-literal). **Genuinely NEW inline VP, sibling to VP-578-008** — ADR-0019 § Amendment (2026-08-26)
D4 resolves the two undefined cells of the cascading-`>`-split × field-schema-type matrix that
VP-578-008 (cascading composition) and its D3 no-panic extension do NOT cover: (a) an explicit
`:option` hint carrying a `>` against a PLAIN (non-cascading) `option` field, and (b) the bare form's
treatment of a literal `>`. Minted (not folded into VP-578-008) because it pins two genuinely new
guarantees — a distinct exit-64 error **message** (EC-3.4.027-7) and a bare-form **behavioral
contract** (D4 cell b) — plus a new type dependency, none of which VP-578-008's "cascading
composition produces the correct wire shape" guarantee asserts. *(D4's cell (a) is detected
STRUCTURALLY via an empty `children` collection, NOT via a `schema.type` lookup — the parser/composer
stays schema-agnostic by construction.)*

**Property statement**:
1. **(i) Non-cascading `>`-collision → distinct exit-64 message.** `--field cf:option=A>B` where the
   parent segment `A` resolves successfully against a PLAIN (`schema.type == "option"`, non-cascading)
   field's `allowedValues[].value`, the child segment `B` is non-empty (per EC-3.4.027-6's
   empty-segment handling), AND the matched parent's `children` collection is **EMPTY** → exit **64**
   (`JrError::UserError`) with a message carrying the load-bearing substrings **`"is not a cascading
   select"`** and **`"remove the"`** (EC-3.4.027-7). The message is **DISTINCT** from EC-3.4.027-3's
   "resolvable parent, unresolvable child → list allowed child values" shape (which would otherwise
   degenerate into a confusing empty enumeration here — there ARE no allowed child values, the field
   isn't cascading). The distinguishing signal is the **structural** empty-`children` check, read at
   the SAME point EC-3.4.027-3's existing "unresolvable child" check inspects `children` — never a
   `schema.type` inspection.
2. **(ii) Bare form treats `>` as a LITERAL character — no split.** A bare `--field cf=Parent>Child`
   (no `:option` hint) against a cascading (`option-with-child`) field **never** attempts a `>` split
   — the ENTIRE string `"Parent>Child"` is matched as one opaque candidate against
   `allowedValues[].value` (BC-3.4.015 Step 4 → BC-3.4.016 Step 4a, unchanged). Since a cascading
   parent's own `.value` does not contain a literal `>` in ordinary use, the whole-string match
   fails and falls through to the **EXISTING EC-3.4.016-2** "unresolvable value, list allowed values"
   error — **no new error path**; the ordinary bare-form mismatch. A cascading child can ONLY be set
   via the explicit `:option` form (BC-3.4.027) — there is no bare-form path to a cascading child.
3. **Type dependency (pinned, VP-assertable at the type level).** Cell (a)'s structural detection
   requires the write-path `AllowedValue` type (`src/types/jira/editmeta.rs::AllowedValue`, currently
   `{id, value, name}` only — verified against the as-built struct) to gain a `children` field, pinned
   by ADR-0019 § Amendment D4 as **`#[serde(default)] pub children: Vec<AllowedValue>`** — `Vec`, NOT
   `Option<Vec<AllowedValue>>` (deliberately different from F-B's `Option<String>` choice: here
   wire-absent and wire-present-but-empty carry the identical "no cascading children" semantic, so
   `#[serde(default)]` → empty `Vec` loses no information). A round-trip serde unit test asserts a
   createmeta `allowedValues` entry with no `children` key deserializes to an empty `Vec`, and one
   with `"children": [...]` populates it.

**Recommended strategy**:
- **(i)** a **wiremock/fixture** unit test (edit path `field_resolve.rs`; and the analogous
  `create.rs` platform-create path) whose createmeta/editmeta fixture returns a PLAIN `option` field
  whose matched parent has `children: []`; assert exit 64 AND that the message CONTAINS both pinned
  substrings `"is not a cascading select"` and `"remove the"` — a **message-content** assertion, not
  merely an exit-code assertion (an exit-64-and-any-message test would pass even if the implementation
  regressed to EC-3.4.027-3's misleading empty-child-enumeration message this EC exists to replace).
- **(ii)** a **fixture** assertion (edit + platform-create) that bare `--field cf=Parent>Child`
  against a cascading field **never attempts a split** and falls through to the EXISTING EC-3.4.016-2
  unresolvable-value error shape — a behavioral/regression pin against a future reader making the
  bare form `>`-aware (which D4 cell b explicitly forbids). The clean observable: the bare-form error
  is EC-3.4.016-2 (unresolvable whole-string value listing allowed values), NOT EC-3.4.027-7 (which is
  reachable only via the `:option` hint).
- **(iii)** the type-level serde round-trip unit test for `AllowedValue.children` (rule 3).

**Target**: `src/cli/issue/field_resolve.rs` (edit-path `:option` composer + bare-form dispatch)
AND the analogous `create.rs` platform-create path; serde unit test co-located with
`src/types/jira/editmeta.rs`; integration fixtures in `tests/issue_field_hint_kinds.rs` (new) /
`tests/issue_edit_field.rs`. **F6**: `create.rs` already ∈ `examine_globs`; add `field_resolve.rs`
and (for the type change) `src/types/jira/editmeta.rs`.

**BC-body anchor — DONE at BOTH sites (F2 adversary-convergence round-5, MED-2 reconciliation).**
VP-578-023's inline BC-body declaration is now present at **both** its relevant sites, so the
round-4 "pending one-line back-fill" flag is **CLOSED**:
- **BC-3.4.027 (~body line 3319)** — the `:option`/cascading BC — declares VP-578-023 in its
  Verification Properties (the non-cascading `>`-collision message + `AllowedValue.children: Vec`
  type dependency); this was the round-4 declaration site.
- **BC-3.4.015 (~body line 1901)** — the bare-form BC — was **back-filled by the product-owner in F2
  round-5 (MED-2)**: its `>`-literal note now carries a `VP-578-023 [BACK-FILLED …]` citation
  describing the bare-form assertion the VP already covers (bare `--field cf=Parent>Child` treats `>`
  as literal, falls through to EC-3.4.016-2, not EC-3.4.027-7's message), explicitly marked as the
  second citation site for the SAME VP, not a duplicate/second VP.
Both sites verified present this round. `related_bcs` now lists BC-3.4.015 alongside BC-3.4.027
(VP-578-023's "Applies to" names both). No further state-manager/PO action is required for
VP-578-023's BC anchor — it joins VP-580-012 as CLOSED, leaving **zero** pending field-dx BC-body
back-fills.

---

### VP-578-024 — Dry-run `plannedChanges` hint-preview wire shape + `:asset` cold-cache side effect *(NEW inline VP — F2 adversary convergence round-5, F-NEW-2)*

**Applies to**: BC-3.4.021 (the `issue edit --dry-run`-owning BC), cross-referencing BC-3.4.027/028/
029/030's new per-kind "Dry-run preview shape" Postconditions and BC-3.4.015's cold-cache side-effect
precedent (EC-3.4.015-18/-19). **Genuinely NEW inline VP** — F2 round-5 F-NEW-2 identified that no BC
specified what `plannedChanges` shows for a HINTED `--field NAME:kind=VALUE` under `--dry-run`:
BC-3.4.021's general bare-form rule (`"<field display-name>": "<display value>"`, a human display
string) does not fit any hint kind (`:id`/`:name` never resolve a display value; `:option`
cascading / `:asset` compose structured objects/arrays a bare string cannot represent). The PO added
a "Dry-run preview shape" Postconditions paragraph to each hint-kind BC and left `VP-DRY-RUN-005` as
a placeholder id in BC-3.4.021 for the verifier; this delta assigns **VP-578-024** and replaces the
placeholder (the one targeted BC edit this round).

**Property statement**:
1. **Composed wire shape, per hint kind — NOT the bare-form display string.** For each hint kind,
   `issue edit KEY --field cf:<kind>=<value> --dry-run --output json` produces a `plannedChanges`
   entry whose value is the **SAME composed wire object the live PUT would send** for that hint:
   - `:id` → `{"id":"<VALUE>"}` (verbatim, no lookup — BC-3.4.028).
   - `:name` → `{"name":"<VALUE>"}` (or the `priority` bypass key form — BC-3.4.029), verbatim.
   - `:option` non-cascading → `{"id":"<optionId>"}` (BC-3.4.027).
   - `:option` cascading → `{"value":"<parent>","child":{"value":"<child>"}}` (BC-3.4.027).
   - `:asset` → `[{"workspaceId":"<ws>","id":"<ws>:<objectId>","objectId":"<objectId>"}]`
     (BC-3.4.030) — distinct from BOTH the bare-form display-string convention AND this same BC's
     simplified `changed_fields` LIVE-echo composite string (`"<workspaceId>:<objectId>"`); the
     dry-run preview and the live success echo are two independently-specified channels, neither
     simplified for dry-run.
   The message content is a per-kind **structural** assertion on the `plannedChanges` JSON, not a
   generic "some preview present" check (a bare-string-only assertion would pass even if the
   implementation regressed to the bare-form display convention this VP exists to distinguish from).
2. **PUT never called.** In every dry-run case above, `PUT /rest/api/3/issue/{key}` is NOT issued
   (`.expect(0)` on the PUT mock); exit 0 with the standard `{dryRun, issues, plannedChanges}`
   top-level keys (BC-3.4.021 Invariant 2).
3. **`:asset` cold-cache SIDE EFFECT — real workspace-discovery GET fires inside the dry-run block,
   can exit 64 BEFORE any `plannedChanges` output.** Resolution of a bare `:asset=<objectId>` form's
   workspace id runs UNCONDITIONALLY inside the `--dry-run` block (mirrors BC-3.4.021 Postconditions
   Common item 3's `--field` editmeta precedent; EC-3.4.015-18). On a COLD `get_or_fetch_workspace_id`
   cache, `--field cf:asset=<objectId> --dry-run` fires the REAL `GET
   /rest/servicedeskapi/assets/workspace` call and, on a 403 / 404 / 200-empty-`values` response,
   exits **64** from BC-3.4.030's cold-cache error taxonomy **BEFORE any `plannedChanges` output** —
   i.e. a dry-run invocation can exit 64 purely from workspace discovery, with EMPTY stdout in both
   output modes (channel-separation invariant #526), the same exit-64-before-preview shape as
   VP-692-002/004 (depth-guard). Cross-referenced to EC-3.4.015-19 (the general "dry-run does not
   suppress resolution errors" precedent) and to BC-3.4.030's error taxonomy (now pinned as reachable
   from `--dry-run` too, not only from a live edit). This assertion complements VP-578-022 (the
   cold-cache workspace-discovery FAILURE taxonomy itself) — VP-578-024 pins that the SAME taxonomy is
   reachable through the dry-run trigger, before preview output.

**Recommended strategy**:
- **(1)/(2)** a per-kind `--dry-run --output json` integration test (`tests/issue_field_hint_kinds.rs`
  / `tests/issue_edit_field.rs`) whose editmeta/createmeta fixture resolves the field, asserting the
  exact `plannedChanges[field]` JSON shape per kind (`{"id":…}` / `{"name":…}` / `{"value":…,"child":
  {"value":…}}` / `[{workspaceId,…}]`) AND `.expect(0)` on the PUT mock AND exit 0 with the standard
  top-level keys. For `:option` cascading, warm the workspace/option fixture so the resolution
  succeeds and the composite `child` shape is observable.
- **(3)** a wiremock test with a COLD workspace-id cache returning 403 / 404 / 200-empty-`values` on
  `GET /rest/servicedeskapi/assets/workspace`, asserting `cf:asset=<objectId> --dry-run` exits 64,
  stdout EMPTY (both modes), the standard error envelope on stderr (`--output json`) / `Error: …`
  (`--output table`), and NO `plannedChanges`/`dryRun`/`issues` key anywhere — the exit-64-before-
  preview pin. A warm-cache companion asserts the same invocation instead reaches the `:asset` preview
  array shape from property 1 (exit 0), pinning that the exit-64 is the cold-cache path specifically.

**Target**: `src/cli/issue/edit.rs::handle_edit` dry-run block + `src/cli/issue/field_resolve.rs`
(the per-kind composers already covered by VP-578-007..012 — VP-578-024 asserts their output is
surfaced identically through the dry-run preview channel) + `src/api/assets/workspace.rs::
get_or_fetch_workspace_id` (side-effect trigger); integration in `tests/issue_field_hint_kinds.rs`
(new) / `tests/issue_edit_field.rs`. **F6**: covered by the `field_resolve.rs` glob add (§4); no new
pure function (the composers are VP-578-007..012's; this VP pins their dry-run surfacing + the
existing `get_or_fetch_workspace_id` cold-cache trigger).

---

### VP-578-009 — `:id` value-kind mapping

**Applies to**: BC-3.4.028 (`:id` bypasses `allowedValues` lookup entirely, sends
`{"id":"<VALUE>"}` verbatim). Realizes **inline VP-578-009**. *(Former delta label VP-578-042 —
retired.)*

**Property statement**:
1. **Verbatim id.** `--field cf:id=10042` emits exactly `{"id":"10042"}` — the VALUE is
   copied into the `id` field with **no** `allowedValues` lookup, no display-value
   resolution, no numeric coercion (id stays a JSON **string**).
2. **No editmeta round-trip for the value.** The value-resolution path performs **zero**
   `allowedValues` matching (the field-existence/editmeta gate from BC-3.4.028's note / BC-3.4.015
   Step 3 still applies, but the value itself is not validated against `allowedValues`).
3. **VALUE preservation.** Whatever VALUE bytes survive VP-578-005's split land verbatim in
   `"id"`. Per BC-3.4.028 Invariant 1 / BC-3.4.031 EC-4, `:id` performs NO client-side numeric
   check — the server is the sole validator.

**Recommended strategy**: deterministic unit tests plus one proptest confirming `emit` never
inspects `allowedValues` on the `:id` path:

```rust
fn prop_id_hint_ignores_allowed_values(value in "[A-Za-z0-9_-]{1,20}") {
    // same output regardless of what allowedValues contains
    prop_assert_eq!(
        emit_field_json(&fixture_allowed_values(), "cf", Some(Kind::Id), &value),
        emit_field_json(&empty_allowed_values(),   "cf", Some(Kind::Id), &value),
    );
    prop_assert_eq!(emit_field_json(&empty_allowed_values(), "cf", Some(Kind::Id), &value),
                    json!({"id": value}));
}
```

**Target**: `src/cli/issue/field_resolve.rs`. **F6**: via `field_resolve.rs` glob add.

---

### VP-578-010 — `:name` value-kind mapping + `--priority` parity

**Applies to**: BC-3.4.029 (`:name` sends `{"name":"<VALUE>"}` verbatim;
`--field priority:name=X` MUST be byte-identical to `--priority X`). Realizes **inline
VP-578-010**. *(Former delta label VP-578-043 — retired.)*

**Property statement**:
1. **Verbatim name.** `--field cf:name=High` emits exactly `{"name":"High"}`.
2. **`--priority` parity (load-bearing byte-identity).** The create/edit POST/PUT body
   produced by `--field priority:name=<X>` is **byte-identical** to the body produced by the
   dedicated `--priority <X>` flag, for the same `<X>`. This is the single most important
   assertion of this VP — the concrete equivalence #578 promises.

**Recommended strategy**: assert as a **serialized-body-equality** test (compare the composed
`serde_json::Value` bodies from the two code paths, or capture wire bodies via wiremock matcher):

```rust
// tests/issue_edit_field.rs  (VP-578-010)
#[test]
fn test_field_priority_name_hint_byte_identical_to_priority_flag() {
    let body_via_flag = compose_edit_body(/* --priority High */);
    let body_via_hint = compose_edit_body(/* --field priority:name=High */);
    assert_eq!(body_via_flag, body_via_hint);   // serde_json::Value equality
}
```

Add a small proptest over priority-name strings (`"[A-Za-z ]{1,15}"`) asserting the same
equality for arbitrary names.

**Target**: unit in `src/cli/issue/field_resolve.rs` (the `{"name":v}` emission) +
byte-parity test in `tests/issue_edit_field.rs`. **F6**: via `field_resolve.rs` glob add.

---

### VP-578-011 — `:asset` composer wire-shape correctness

**Applies to**: BC-3.4.030 (`:asset` composes the Assets object-reference array
`[{workspaceId, id, objectId}]` from a compact `WORKSPACE:OBJECTID` value; bare
`:asset=<objectId>` reuses the cached workspace id — BC-4.2.001 read-only). Realizes **inline
VP-578-011** (correctness). *(Former delta label VP-578-044 — retired.)* Safety is VP-578-012.

**Property statement**:
1. **Two-segment form.** `--field cf:asset=W:Y` (where `W` = workspaceId, `Y` = objectId)
   composes exactly `[{"workspaceId":"W","id":"W:Y","objectId":"Y"}]` — the `id` field is the
   `WORKSPACE:OBJECTID` compound key (per the PRD-delta wire shape), `objectId` is the bare `Y`.
2. **One-segment form.** `--field cf:asset=Y` (no colon) composes
   `[{"workspaceId":"<cached-ws>","id":"<cached-ws>:Y","objectId":"Y"}]`, resolving
   `<cached-ws>` from the existing `get_or_fetch_workspace_id` cache (BC-4.2.001) — **no new
   workspace-discovery contract**, a new caller only.
3. **Array wrapper.** The value is always a JSON **array** (Assets object-reference fields are
   multi-valued), even for a single object.

**Recommended strategy**: unit tests over the two forms with a stubbed workspace-id cache,
plus one wiremock integration test in a new `tests/issue_field_hint_kinds.rs` asserting the
composed body reaches the create/edit endpoint intact. The warm-cache reuse should be asserted
(cache hit → no discovery HTTP call fired) to protect BC-4.2.001's read-only reuse.

**Target**: `src/cli/issue/field_resolve.rs` (composer) + `tests/issue_field_hint_kinds.rs`
(new). **F6**: via `field_resolve.rs` glob add.

---

### VP-578-012 — `:asset` composer safety (never a malformed JSON body)

**Applies to**: BC-3.4.030. Realizes **inline VP-578-012** — the safety counterpart to
VP-578-011's correctness, structurally parallel to
`prop_sanitize_attachment_filename_no_path_traversal` (VP-576-001), exactly as the inline
VP-578-012 body already names. *(Former delta label VP-578-046, plus the malformed-`:asset`
part of former VP-578-045 — retired.)*

**Property statement** — for **arbitrary** input to the `:asset` value composer (arbitrary
UTF-8, arbitrary colon placement/count, empty segments, control characters):
1. **No panic on the `WORKSPACE:OBJECTID` first-colon split (Pass2-F3, `str::split_once(':')`
   MUST).** The composer splits the already-extracted `:asset=VALUE` value portion on its **first
   `:`** to separate `WORKSPACE` from `OBJECTID`. This split site is INDEPENDENT of both BC-3.4.026
   step 5's `parse_field_kv` Unicode-scalar-safety MUST (scoped to that parser's own steps 1–2) and
   BC-3.4.027 Invariant 5's cascading `str::split_once('>')` MUST — exactly the same "independent
   split site, needs its own explicit MUST" situation D3 fixed for the `>` split. Per BC-3.4.030
   Parsing rule 1 / Invariant 4 the split MUST use `str::split_once(':')` (never a char-index-as-
   byte-offset scheme, which panics on a multibyte scalar preceding the `:` — the FIX-F6-LRE-1 bug
   class). The composer never unwinds — no byte-offset panic on a multibyte `WORKSPACE` or
   `OBJECTID` (same class as VP-578-005 and VP-578-008's D3 extension).
2. **Total classification.** The composer returns **either** a valid, well-formed Assets
   object-reference `serde_json::Value` (always the `[{workspaceId,id,objectId}]` array
   shape, all three keys present, all string-typed) **or** a clean `Err(UserError)` (exit 64)
   — **never** a partially-built or structurally-invalid JSON body that would reach Jira and
   produce an opaque 400. Malformed shapes per BC-3.4.030 / BC-3.4.031 EC-2/EC-3 (empty segment
   `W:`/`:Y`, extra colon `W:Y:Z`, non-numeric/empty `objectId`) → clean exit 64 before any HTTP.
   **Extra-colon `W:Y:Z` — DISTINCT message (F2 round-3, F-C / BC-3.4.031 EC-2d).** Because the
   composer splits on the **first** `:` via `str::split_once(':')`, `cf:asset=W:Y:Z` yields workspace
   `W` and objectId candidate **`Y:Z`**, which then fails the ASCII `[0-9]+` numeric check. The
   emitted message MUST name the **actual** mistake — an extra colon-separated segment, e.g.
   `"unexpected extra ':' in :asset value — expected WORKSPACE:OBJECTID"` (BC-3.4.031 EC-2d) — and
   MUST **NOT** reuse EC-3's generic `"objectId must be numeric"` wording (misleading for a caller
   who supplied three colon-separated segments, a distinct mistake from a genuinely non-numeric
   two-segment objectId). This is a **message-CONTENT** assertion (a `.contains(...)` on the EC-2d
   wording), not merely an exit-code assertion — the F-C flag on VP-578-012 §2 requires the
   specific-wording pin.
3. **No injection into structure.** No input can cause the composed value to gain/lose keys or
   change from array-of-object shape (the shape is a function of code, never of input bytes).

**Recommended proptest strategy** (model verbatim on the sanitize precedent):
```rust
proptest! {
    #[test]
    fn prop_compose_asset_ref_never_malformed(raw in "\\PC{0,60}") {
        match compose_asset_ref(&raw, &stub_ws_cache()) {
            Ok(v) => {
                // shape invariant holds for every accepted input
                let arr = v.as_array().expect("must be an array");
                prop_assert_eq!(arr.len(), 1);
                let obj = arr[0].as_object().expect("must be an object");
                prop_assert!(obj.contains_key("workspaceId"));
                prop_assert!(obj.contains_key("id"));
                prop_assert!(obj.contains_key("objectId"));
                prop_assert!(obj.values().all(|x| x.is_string()));
            }
            Err(_) => { /* clean rejection — acceptable */ }
        }
    }
}
```

**EXTENDED — Pass2-F3 first-colon-split no-panic (mirrors VP-578-008's D3 `>`-split extension).**
The `raw in "\\PC{0,60}"` strategy above already feeds the composer arbitrary UTF-8 including a `:`
byte adjacent to a multibyte scalar, so `prop_compose_asset_ref_never_malformed` **is** the no-panic
proptest for the `str::split_once(':')` `WORKSPACE:OBJECTID` split — no new proptest id is needed
(the coverage is folded into VP-578-012, exactly as the `>`-split no-panic was folded into
VP-578-008). Add a **named regression unit test** pinning the concrete Pass2-F3 / EC-3.4.030-6 input
`"Wé:123"` (multibyte scalar immediately before the first `:`) — asserting it resolves without
panicking (mirrors `validate_duration_multibyte_unit_returns_err_not_panic` and VP-578-008's
`"Pré>Bñ"` pin), plus companions `"世:123"`, `":123"` (empty workspace), `"W:"` (empty objectId) →
each a clean `Ok`/`Err(UserError)`, never an unwind. **Add a dedicated `"W:Y:Z"` (extra-colon)
regression pin (F-C / EC-2d)** asserting the `Err(UserError)` message **contains** the extra-colon
wording (`"unexpected extra ':'"` / `"expected WORKSPACE:OBJECTID"`) and does **NOT** contain EC-3's
generic `"objectId must be numeric"` — the message-content half of §2 above. The `objectId` numeric-shape check (BC-3.4.030
Parsing rule 3 / BC-3.4.031 EC-3) is **ASCII-only `[0-9]+`** (equivalently `(?-u)\d+`) — a companion
regression pin should confirm non-ASCII digits (`"W:١٢٣"`, `"W:１２３"`) are rejected client-side
(exit 64), not passed through to a server-side 400.

**Target**: `src/cli/issue/field_resolve.rs` (or wherever `compose_asset_ref` lands). **F6**:
this pure composer is the highest-value mutation target of the cycle — **must** be added to
`.cargo/mutants.toml` `examine_globs` (§4), mirroring the VP-576-001 mutation-coverage
obligation cited in CLAUDE.md.

---

### VP-578-013 — Malformed-hint edge-case catalog: exit 64, one error per invocation

**Applies to**: BC-3.4.031 (companion to BC-3.4.026 — unknown kind, empty `:kind`, empty value,
malformed `:asset` shapes), and BC-3.4.026 itself. Realizes **inline VP-578-013** (with EC-6/EC-7
regression pins owned by inline VP-578-014). *(Former delta label VP-578-045 — retired.)*

**Property statement** — for each malformed shape, the invocation exits **64**
(`JrError::UserError`) with a single, actionable message, emitting **exactly one** error
(the parser stops at the first offending pair, consistent with today's `parse_field_kv`
fail-fast):
1. **Empty `:kind`** — `--field cf:=V` (colon present, kind empty) → exit 64 (BC-3.4.031 EC-5).
2. **Unknown `:kind`** — `--field cf:frobnicate=V` (kind ∉ {option,id,name,asset}) → exit 64,
   message lists the valid kinds (BC-3.4.031 EC-1). Case matters: `:Option`/`:OPTION` are
   unknown kinds (BC-3.4.026 Invariant 3), not the `option` kind.
3. **Empty value — `:asset` ONLY is exit-64 (STRUCTURAL), NOT `:id`/`:name` (F2 round-3, F-A).**
   `--field cf:asset=` (empty value) → exit 64 (BC-3.4.031 **EC-2a**), and for a **STRUCTURAL**
   reason — the composer cannot build the `[{workspaceId,id,objectId}]` object reference with no
   `objectId` — **not** a value-validation rejection. `:asset` is the **only** kind in the catalog
   whose empty-value form is a client-side exit-64. (This structural rejection surfaces at the
   composer, jointly covered with **VP-578-012**; the kind-tag defects in items 1–2 surface at
   `parse_field_kv` itself.)
   - **Empty `:id=` / `:name=` PASS THROUGH — NOT exit-64 (F-A; ADR-0019 §2(b) + BC-3.4.028/029
     "server is sole validator").** `--field cf:id=` composes `{"id":""}` and `--field cf:name=`
     composes `{"name":""}`, each sent verbatim for the server to validate. `parse_field_kv`'s value
     is deliberately **uninterpreted** (ADR-0019 §2(b)), and BC-3.4.028/029 perform **zero**
     client-side matching, so an empty `:id`/`:name` value is **not** a `jr`-side rejection
     (BC-3.4.031 **EC-8** [empty `:id=`] / **EC-9** [empty `:name=`], both marked PASS-THROUGH).
     F4 **MUST NOT** assert exit-64 for EC-8/EC-9.
   - **Positive coverage required (F-A).** Add explicit unit/integration assertions that empty
     `:id=` parses successfully and composes `{"id":""}`, and empty `:name=` parses successfully and
     composes `{"name":""}` (each **exit 0** at the parse/compose layer), so the pass-through is a
     pinned regression guard, not merely an absence of the old exit-64 assertion.
   - (Bare `NAME=` empty value likewise stays **allowed** per the existing
     `prop_parse_field_kv_empty_value_allowed` — consistent with the `:id`/`:name` pass-through
     above; F4 must not regress the bare-form allowance. This makes **VP-578-005 §4** — empty value
     allowed at the parser — the general-case counterpart, with **no contradiction**: the parser
     never rejects an empty value for the bare form OR for `:id`/`:name`; only `:asset`'s downstream
     composer does, structurally.)
4. **Malformed `:asset`** — `WORKSPACE:OBJECTID` shape violations (empty segment `:asset=:Y` /
   `:asset=W:`, extra colon `:asset=W:Y:Z`, non-numeric/empty `objectId`) each → exit 64
   (BC-3.4.031 EC-2/EC-3). Jointly covered with VP-578-012.
5. **JSON-output parity** — under `--output json`, the same defect yields the standard
   `{"error":"…","code":64}` envelope via `render_json`, not a bare-string stderr line.

**Property invariant (the proptest-shaped part)** — **one error per invocation**: for any
vector of `--field` pairs containing ≥1 malformed hinted pair, `parse_field_kv` returns
`Err` (not a `Vec<Err>`, not a panic), and the process exits 64 once. This mirrors the
existing "repeated `--field` occurrences still yield exactly one error" guarantee documented
for DEC-188 and the bare parser.

**Recommended strategy** — the `prop_oneof!` MUST generate **all four valid kind markers** plus the
two kind-tag defects; the empty-value assertion is **per-kind**, NOT a blanket `.is_err()` (the
pre-round-3 blanket form was the F-A defect — it asserted exit-64 for empty `:id=`/`:name=`, which
now pass through):
```rust
proptest! {
    /// VP-578-013 (F-A + round-4 MED-3): each kind-marker's empty-value form classifies
    /// deterministically and never panics. `:` (empty kind) and `:frob` (unknown kind) → exit 64
    /// at `parse_field_kv` for ANY value. `:asset=` (empty) → exit 64 too, but STRUCTURALLY at the
    /// COMPOSER (EC-2a; jointly VP-578-012). `:option=` (empty) → exit 64 too, but DOWNSTREAM at the
    /// `allowedValues` MATCH (an empty value is a match-miss, BC-3.4.016 EC-3.4.016-2) — a distinct
    /// ORIGIN from `:asset`'s structural composer failure, NOT a parser rejection. Empty
    /// `:id=`/`:name=` PASS THROUGH (F-A / EC-8 / EC-9 → `{"id":""}` / `{"name":""}`) — never a
    /// jr-side rejection.
    #[test]
    fn prop_hint_kind_empty_value_classification(
        name in "[a-z]{1,10}",
        kind in prop_oneof![                       // all four valid kinds + the two kind-tag defects;
            Just(":"), Just(":frob"),              //   `:name` added this round (was omitted)
            Just(":option"), Just(":id"), Just(":name"), Just(":asset"),
        ],
    ) {
        // resolve_field_end_to_end(...) spans parse_field_kv → the kind-specific value composer
        // (F4 wiring); it is total (Ok | Err(UserError)), never panics.
        let outcome = resolve_field_end_to_end(&format!("{name}{kind}="));
        match kind {
            ":" | ":frob" | ":asset" => prop_assert!(outcome.is_err()),  // exit 64: kind-defect or STRUCTURAL (composer)
            ":option" => prop_assert!(outcome.is_err()),  // exit 64 DOWNSTREAM: allowedValues match-miss (EC-3.4.016-2), NOT a parser rejection — distinct origin from :asset's structural failure
            ":id" | ":name" => prop_assert!(outcome.is_ok()), // F-A pass-through (empty value OK — verbatim {"id":""}/{"name":""})
            _ => unreachable!(),
        }
    }
}
```
**Round-4 MED-3 — `:option` empty value is `is_err()`, not `is_ok()` (the pre-round-4 form grouped
`:option` with `:id`/`:name` in the `is_ok()` arm — WRONG).** An empty `:option` value is NOT a
verbatim pass-through the way `:id`/`:name` are: `:option` still runs the `allowedValues` resolution
(only the numeric-id auto-detect is bypassed vs. the bare form — see VP-578-007), so an empty value
is an `allowedValues` **match-miss** resolved **downstream** (BC-3.4.016 EC-3.4.016-2 → exit 64),
hence `is_err()`. Its exit-64 **origin is distinct** from `:asset`'s: `:asset` fails **structurally**
at the composer (cannot build `[{workspaceId,id,objectId}]` with no `objectId`, EC-2a), whereas
`:option` fails at the **`allowedValues` match** — and both differ from `:id`/`:name`, which never
match at all and pass the empty value through verbatim for the server to validate. The `:option`
end-to-end `Err` is robust to fixture presence: with no resolvable field context it is a
field-not-found `Err`, with a resolvable field it is the empty-value match-miss `Err` — either way
never `Ok`, so the `is_err()` arm holds without needing a specific fixture in the pure proptest;
the exact EC-3.4.016-2 message-miss shape is pinned separately in the table-driven catalog test
below with a resolvable-field fixture. Plus an explicit **table-driven unit test** enumerating each
EC-3.4.031-N shape → asserted exit code 64 and a substring of the expected message for the exit-64
rows (**EC-2a** empty `:asset` [STRUCTURAL], EC-1 unknown kind, EC-5 empty kind, EC-2b/2c/2d
malformed `:asset`), the **downstream** exit-64 row (**empty `:option`** → EC-3.4.016-2
`allowedValues` match-miss, asserted with a resolvable-field fixture so the empty value reaches and
misses the match rather than failing as field-not-found), **and** the exit-0 PASS-THROUGH rows
(**EC-8** empty `:id=` → `{"id":""}`, **EC-9** empty `:name=` → `{"name":""}`) — the durable,
human-reviewable catalog, now covering all three exit classes (parser/structural exit-64, downstream
match-miss exit-64, and verbatim pass-through exit-0).

**Target**: proptest in `src/cli/issue/create.rs`; table-driven catalog test in
`tests/issue_field_hint_kinds.rs` (new) covering exit code + JSON envelope. **F6**: `create.rs`
already ∈ globs; add `field_resolve.rs`.

---

### VP-580-005 — Graceful-degrade: no enumerable options → exit 0, no panic on untyped allowedValues

**Applies to**: BC-X.14.004 (a field with empty/absent `allowedValues`/`validValues` → a
"no enumerable options" hint, **exit 0** (not an error), never a panic on the untyped
`allowedValues.items` / `validValues` shape). Realizes **inline VP-580-005**. *(Former delta
label VP-580-041 — retired.)*

**Property statement**:
1. **Empty/absent → exit 0.** A field that resolves successfully but whose editmeta/createmeta/
   requesttype-fields entry has **no** `allowedValues`/`validValues` (a plain string/number/date
   field, an Assets/CMDB field, a user-picker), or an empty array, produces a **human hint**
   (the variant per BC-X.14.004's degrade table: Assets / dynamic-lookup / no-fixed-value-set)
   and exits **0** — graceful degradation, **not** an error. (Contrast the field-not-found /
   ambiguous cases in BC-X.14.004's error table, which DO exit 64.)
2. **No panic on shape variance.** The `allowedValues`/`validValues` items are a
   **heterogeneous / untyped** JSON shape across Jira field types (option `{id,value}`, cascading
   `{id,value,children:[…]}`, user `{accountId,displayName}`, version `{id,name}`, GDPR-absent
   `{id?}`). The normalizer must tolerate **arbitrary `serde_json::Value`** items without
   panicking: missing keys, unexpected key sets, null, nested arrays, deeply-nested cascading. It
   renders what it can and degrades the rest — it never unwraps a missing field.
   **STRENGTHENED (F2 round-3, F-B / ADR-0019 § Amendment F-B; `FieldOption.id`/`.label` are now
   `Option<String>`, never-drop invariant EC-X.14.001-7).** "No panic" alone is satisfied by an
   implementation that silently *filters out* a degenerate entry — that loophole is closed
   explicitly. VP-580-005 §2 additionally asserts:
   - **(a) Entry-count preservation (never-drop).** Both normalizers emit **exactly one**
     `FieldOption` per source item — `output.len() == input.len()` — regardless of which fields the
     source item carries. A source item missing `id` and/or `label`/`value` degrades **that entry's
     own** field(s) to `None`; it is **never** omitted from the returned `Vec<FieldOption>`. The
     no-panic proptests below MUST be extended with this length assertion (e.g.
     `prop_assert_eq!(normalize_from_valid_values(&items).len(), items.len())`), so a
     silently-filtering mutant fails.
   - **(b) Exact `Option::None` → JSON `null` shape.** For a source item missing `id`, the emitted
     `FieldOption.id` serializes to JSON **`null`** (not `""`, not an omitted key); identically for a
     missing `label` → `label: null`. Asserted against the `render_json` output shape (JSON mode
     performs **no** substitution — the scripted consumer receives the real absence signal).
   - **(c) Pinned table-rendering strings (integration-level, paired with BC-X.14.003 /
     VP-580-008(d)).** In **table** mode a missing `id` renders `NULL_GLYPH` (**`"—"`**, reusing
     `src/cli/issue/changelog.rs::NULL_GLYPH`) and a missing `label` renders the literal
     **`"(unnamed)"`** (never a fallback to `id`, which may also be absent). These two exact strings
     are pinned by a table-capture fixture item missing id/label respectively. (The rendering half
     is co-owned by VP-580-008(d) — §VP-580-008 — this VP owns the normalizer-side never-drop +
     `None` origin of those cells.)
3. **JSON parity.** Under `--output json`, an empty option set returns an **empty normalized
   array** (`[]`) via `render_json`, exit 0, with the hint text on STDERR (not stdout, per
   BC-X.14.004 EC-2) — not an error envelope, not a null.

**Recommended strategy**:
- **proptest** over arbitrary `serde_json::Value` fed to **both** pure option-normalizers,
  per ADR-0019 §1/§Rationale's two-function scheme (the source keys differ: M1/M2 editmeta/
  createmeta key off `allowedValues[].id`, M3 JSM requesttype-fields key off `validValues[].value`,
  so they are deliberately **not** unified into one function):
  - `normalize_from_allowed_values(&[AllowedValue]) -> Vec<FieldOption>` (M1/M2) — total; never
    panics on GDPR-absent / missing-key / unexpected `AllowedValue` items; always returns a `Vec`
    (possibly empty).
  - `normalize_from_valid_values(&[serde_json::Value]) -> Vec<FieldOption>` (M3) — total; never
    panics on arbitrary untyped JSON items (null, nested arrays, unexpected key sets); always
    returns a `Vec` (possibly empty).

  These two pure functions are the heart of the degrade guarantee, and VP-580-005's
  property-test realization.
  ```rust
  fn prop_normalize_from_valid_values_total_and_never_drops(items in prop::collection::vec(arb_json_value(), 0..8)) {
      let out = normalize_from_valid_values(&items);   // total, no panic, for any JSON items (M3)
      prop_assert_eq!(out.len(), items.len());         // (a) never-drop: one FieldOption per source item
  }
  fn prop_normalize_from_allowed_values_total_and_never_drops(items in prop::collection::vec(arb_allowed_value(), 0..8)) {
      let out = normalize_from_allowed_values(&items); // total, no panic, incl. GDPR-absent items (M1/M2)
      prop_assert_eq!(out.len(), items.len());         // (a) never-drop: no degenerate item filtered out
  }
  ```
  Plus a deterministic unit test on a GDPR-absent fixture item (`AllowedValue { id: None, value: None }`)
  asserting the emitted `FieldOption` serializes to `{"id": null, "label": null, "children": []}` via
  `render_json` — the **(b)** `None`→`null` shape (not `""`, not an omitted key).
  (`arb_json_value()` = a recursive `serde_json::Value` strategy — bounded depth — the same
  technique used to fuzz ADF shapes; `arb_allowed_value()` = an `AllowedValue` strategy exercising
  the optional-field / missing-key variants ADR-0019 §Rationale calls out.)
- **wiremock integration** in `tests/field_options.rs`: a createmeta/editmeta fixture for a
  plain string field → assert **exit 0** + the "no enumerable options" stderr hint + `[]` under
  `--output json`. Cover each degrade sub-case (Assets, user-picker, free-text; EC-X.14.004-1
  JSM Assets `validValues:[]` distinguished from a genuine misconfiguration).

**Target**: the pure `normalize_from_allowed_values` (M1/M2) and `normalize_from_valid_values`
(M3) normalizers in the new `jr field options` handler (`src/cli/field.rs`), per ADR-0019's
two-function scheme; proptests co-located; integration in `tests/field_options.rs` (new).
**F6**: add handler file to `examine_globs`.

---

### VP-580-006 — Context mutual-exclusion arity guard *(NEW inline VP)*

**Applies to**: BC-X.14.001 **Invariant 1** (`jr field options <field>` selects its enumeration
**mode** by **exactly one MODE-SELECTOR** among `{--type, --request-type, --issue}`; `--project`
is a **COMPANION**, not a mode selector). Zero or multiple mode selectors → exit 64, **before any
HTTP**. **M2's `--type`-requires-`--project` companion rule is NO LONGER part of this arity
function** (ADR-0019 § Amendment 2026-08-26 D1): it moved OUT of `resolve_field_context` into the
separate post-arity `resolve_m2_project` step (**VP-580-010**), so `resolve_field_context` is
defined over the three MODE-SELECTOR booleans ONLY. **This is a genuinely NEW inline VP** — F5
pass-1 found Invariant 1 had no VP. It was **added to the BC-X.14.001 body this pass** (§5).
*(Former delta label VP-580-040 — retired in favor of this sequence-extending inline id.)* **The
arity is defined over the three MODE-SELECTOR booleans only** — the earlier "`--project`+`--type`
are one paired mechanism among three" framing is superseded here to match ADR-0019 §1 / § Amendment
D1 and BC-X.14.001/004 (the architect/PO are updating those in parallel this pass): `--project`
counts as a companion in **no** mode-selector tally and is **not an input to this function at
all**, and `--project --request-type` is a **valid** M3 form, **not** an arity error.

**Property statement** — over the 2^3 space of `(has_type, has_request_type, has_issue)` presence
(`has_project` is **NOT** a parameter of this function — the M2 project companion is resolved
separately, post-arity, by `resolve_m2_project`, VP-580-010):
1. **Exactly one MODE-SELECTOR accepted.** The mode is chosen by precisely one of the three
   MODE-SELECTORS `{has_type, has_request_type, has_issue}`. Exactly one present → `Ok(Mode)` (the
   guard passes to resolution). `has_project` is not an input to this function; the M2
   `--type`-requires-`--project` requirement is enforced downstream by `resolve_m2_project`
   (VP-580-010), never here.
2. **`--project` is resolved OUTSIDE this function (ADR-0019 § Amendment D1).** `resolve_field_context`
   does not take `has_project`. Both the M2 `--type`-requires-`--project` companion rule and the M3
   optional-`--project` fallback are handled by the separate post-arity `resolve_m2_project` step
   (VP-580-010). Consequently `--project --request-type` is a **valid M3** invocation that does NOT
   trip an arity error — at this function's level it is simply `has_request_type` alone → `Ok(M3)`.
   The "actual `--project --request-type` flags do not trip the guard" case is asserted at the
   integration layer and is the realization of **VP-580-009** (see §1). A bare `--project` with no
   mode selector is invisible to this function (all three selectors false) and is rejected as
   zero-mode-selectors by (3).
3. **Zero mode selectors rejected.** No MODE-SELECTOR present → exit 64 with a message naming the
   three modes. (A bare `--project` with no mode selector reaches this case — it selects no mode on
   its own.)
4. **Two+ mode selectors rejected.** Any two or three of `{--type, --request-type, --issue}`
   present simultaneously → exit 64 with a mutual-exclusion message listing the conflicting flags.
5. **Pre-HTTP.** Every rejection in (3)–(4) fires **before** any network call (assert no request is
   made on the rejection paths — protects the "one mode, enforced before any HTTP" contract). This
   is the analogue of DEC-188's pre-flight-before-HTTP placement / ADR-0014's dispatch-fork guard.

**Recommended strategy** — extract the arity decision into a **pure function** taking the three
MODE-SELECTOR booleans (`has_type`, `has_request_type`, `has_issue`) → `Result<Context,
JrError>` (no `has_project` parameter), then proptest it exhaustively:
```rust
fn prop_field_options_context_arity(
    has_type in any::<bool>(), has_request_type in any::<bool>(),
    has_issue in any::<bool>(),
) {
    let r = resolve_field_context(has_type, has_request_type, has_issue);
    // MODE-SELECTORS only — exactly one required. --project is NOT an input here
    //   (M2's --type-requires---project rule is resolve_m2_project's job, VP-580-010).
    let selectors = [has_type, has_request_type, has_issue]
        .iter().filter(|b| **b).count();
    let ok = selectors == 1;                 // exactly one mode selector
    if ok {
        prop_assert!(r.is_ok());
    } else {
        prop_assert!(r.is_err());            // 0 selectors or >1 selectors
    }
}
```
Plus wiremock integration tests in `tests/field_options.rs` asserting **exit 64 + no HTTP
request fired** for the two arity rejection classes — **zero** mode selectors and **two+** mode
selectors — plus a positive assertion that **`--project --request-type` does NOT trip the guard**
(it is valid M3); the pre-HTTP guarantee cannot be shown by the pure test alone. **This positive
`--project --request-type → Ok` case is the realization of VP-580-009** — the BC-X.14.004
regression guard (adversary pass-20 M1 / ADR-0019 §1), see §1. The M2 `--type`-without-`--project`
rejection is **NOT** an arity-function concern this pass — it is owned by **VP-580-010**
(`resolve_m2_project`). Per-message-shape for each taxonomy row is owned by inline VP-580-004.

**Target**: pure guard fn in `src/cli/issue/field_resolve.rs` **or** new `src/cli/field.rs`
(F4/architect to place the new `jr field options` handler); proptest co-located; integration
in `tests/field_options.rs` (new). **F6**: add the handler file to `examine_globs`.

---

### VP-580-007 — `--value` client-side substring filter correctness *(NEW inline VP)*

**Applies to**: BC-X.14.002 (`jr field options <field> --value <substring>` narrows the
enumerated list). **Genuinely NEW inline VP** — F5 pass-1 found BC-X.14.002 had no VP anywhere;
added to the BC-X.14.002 body this pass (§5).

**Property statement** — over an enumerated `Vec<FieldOption>` fixture and arbitrary substrings:
1. **Match semantics.** The filter is **case-insensitive** and a top-level entry matches when
   **EITHER** its `label` **OR** its `id` contains the substring.
2. **Child retention under parent.** A child matching `--value` is retained under its parent, and
   the **parent is retained as context** even when the parent's own `label`/`id` does not match.
3. **Matched-parent keeps all children.** A parent that itself matches retains **ALL** its
   children unfiltered (no further filtering inside an already-matched parent).
4. **Empty result is success.** Zero matches → empty result, **exit 0**, empty table / `[]` JSON —
   a valid success, never an error (BC-X.12.002 empty-result precedent).
5. **Absent flag → identity.** `--value` absent → the full enumerated list unchanged.
6. **Totality.** The filter never panics and never fails — it can only narrow (a pure function).

**`Option<String>` reconciliation (F2 round-4, F-1 / ADR-0019 § Amendment F-B).** BC-X.14.001's
F-B decision made `FieldOption.id`/`.label` `Option<String>` (a never-dropped `{id:None,label:None}`
entry is legal, EC-X.14.001-7), so the substring-match semantics against a `None` field and the
`--value ""` identity claim's interaction with a fully-degenerate entry must be pinned. The PO
extended inline VP-580-007 with sub-points **(g)/(h)/(i)**; this definition adds them:

- **(g) `None` fields are not a match source.** A `None` `id` or `label` is simply **skipped** in the
  substring test — never a panic, never itself a reason to drop the entry. For a **non-empty**
  `--value`, an entry with one `None` field can still match via its remaining `Some` field.
- **(h) Never-drop under filtering.** Filtering is an ordinary substring narrowing over the entry's
  available `Some` field(s); it does **not** violate the normalizer's never-drop invariant
  (BC-X.14.001 / VP-580-005), which governs the **enumerator's output**, not this separate
  client-side filter's expected narrowing. A fully-degenerate `{id:None,label:None}` entry has no
  candidate string, so a **non-empty** `--value` filters it out as an **ordinary substring miss** —
  explicitly **not** a never-drop violation.
- **(i) `--value "" == --value absent` (identity, including degenerate entries).** The empty
  substring matches **every** entry **unconditionally** — INCLUDING a `{id:None,label:None}` entry
  that has no `Some` string to test — so `--value ""` output is byte-identical to `--value`-absent
  output, preserving never-drop through the filter. This is a deliberate special case (an
  unconditional match when the substring itself is empty), **not** a restatement of "every
  `Some(String)` contains the empty substring" (which alone would NOT cover a fully-`None` entry that
  has no `Some` string to test at all).

**Recommended strategy**: extract the filter to a **pure function**
`filter_options(&[FieldOption], substr: &str) -> Vec<FieldOption>`; unit tests over a fixture
tree covering each rule above (including a cascading fixture for rules 2–3, **and a degenerate
fixture containing a `{id:None,label:None}` entry plus entries with exactly one field `None`** for
sub-points g/h/i); one proptest asserting totality (`filter_options` never panics, result length ≤
input length at top level, never a panic on a `None` field) and that `--value ""` / an absent filter
is the identity **including any degenerate entry** (output len == input len for the empty-substring
case). Wiremock integration in `tests/field_options.rs` asserting exit 0 + empty table / `[]` on a
zero-match run, and a `--value ""`-vs-absent identity run over an enumeration containing a
degenerate entry.

**Target**: pure `filter_options` in the new `jr field options` handler (`src/cli/field.rs`);
proptest + unit co-located; integration in `tests/field_options.rs` (new). **F6**: add handler
file to `examine_globs`.

---

### VP-580-008 — Table/JSON output-shape correctness *(NEW inline VP)*

**Applies to**: BC-X.14.003 (table columns ID/Label with cascading indentation; `--output json`
returns the normalized `{id,label,children}` array). **Genuinely NEW inline VP** — F5 pass-1
found BC-X.14.003 had no VP anywhere; added to the BC-X.14.003 body this pass (§5).

**Property statement**:
1. **Table shape.** Default table output has exactly two columns **ID**, **Label**; cascading
   children render as additional rows **indented under their parent** (table mode only).
2. **JSON shape + render invariant.** `--output json` returns a JSON array of the normalized
   `FieldOption` shape `[{id, label, children: [...]}, ...]` with the nested `children[]`
   structure preserved verbatim (no flattening), routed through `output::print_output` /
   `render_json` — asserting **no** direct `serde_json::to_string_pretty` and **no** compact
   `json!` Display call (repo-wide JSON render invariant #526).
3. **Profile 2 (Read-only): zero stderr on the ORDINARY enumeration success path; the
   graceful-degrade stderr hint is a permitted Profile-2 success-path emission (covered by
   VP-580-005).** A `[]` / empty-filter-result table is still exit 0 with no stderr on the
   ordinary path. Per the authoritative BC-X.14.003, `jr field options` is output-channel
   **Profile 2 (Read-only)** — NOT Profile 1 (Pure) — precisely because the graceful-degrade
   success path (BC-X.14.004) legitimately emits a hint line to stderr while still exiting 0.
   That degrade-hint-on-stderr case is a distinct path owned by BC-X.14.004 / VP-580-005, not
   this ordinary success path.
4. **(d) Degenerate-entry rendering (F2 round-3, F-B / ADR-0019 § Amendment F-B; BC-X.14.003
   "Degenerate-entry rendering" subsection).** With `FieldOption.id`/`.label` now `Option<String>`
   (never-drop invariant EC-X.14.001-7), the rendering layer MUST assert both pinned strings and the
   JSON counterpart:
   - **Table mode:** a `FieldOption` with `id: None` renders the ID column as `NULL_GLYPH`
     (**`"—"`**, the exact glyph from `src/cli/issue/changelog.rs::NULL_GLYPH`); a `FieldOption` with
     `label: None` renders the Label column as the literal **`"(unnamed)"`** (never a fallback to
     `id` — `id` may also be `None` on the same entry).
   - **JSON mode:** performs **NO** substitution — `id: None` / `label: None` serialize to JSON
     **`null`**, never `"—"` / `"(unnamed)"` (those are table-mode-only). The scripted consumer
     receives the real absence signal.
   - **Never-drop at the render layer.** A degenerate entry still occupies exactly one table row /
     one JSON array element (mirrors VP-580-005(a) at the output-shape layer — the entry is present,
     just visibly degraded).
   Asserted by a table-capture fixture and a `render_json`-capture fixture, each containing one item
   missing `id` and one missing `label`. This is the companion the PO's F-B flag requires on
   VP-580-008; it pairs with VP-580-005(c) (which owns the normalizer-side `None` origin of these
   cells).

**Recommended strategy**: unit tests over the render function for a flat fixture and a cascading
fixture (assert column headers, child indentation, verbatim nested JSON); an integration test in
`tests/field_options.rs` capturing stdout and stderr **separately** to assert the Profile-2
(Read-only) ordinary-path zero-stderr success contract and the `render_json` routing
(pretty-printed, #526).

**Target**: render/print path in the new `jr field options` handler (`src/cli/field.rs`); unit
tests co-located; integration in `tests/field_options.rs` (new). **F6**: add handler file to
`examine_globs`.

---

### VP-578-021 — Create-path Gate-B collision guard *(NEW inline VP — F2 adversary convergence, D2)*

**Applies to**: BC-3.3.010 (Invariant 5 / EC-3.3.010-6 / **EC-3.3.010-6a**). **Genuinely NEW inline
VP** — ADR-0019 § Amendment (2026-08-26) D2 extends Gate B (BC-3.4.017's dedicated-flag × `--field`
mutual-exclusion, previously edit-only) to the create path (`jr issue create`), closing the adversary
B-F3 defect (`--priority Medium --field priority:name=Medium` wrote `fields.priority` via two
unordered sources with no defined "later"). Added to the BC-3.3.010 body this pass (back-fills the
PO's D2 placeholder, §5). Modeled on the **edit-path Gate-B VP** (VP-396-005), symmetric with
EC-3.4.017-16.

**EXTENDED F2 adversary-convergence round-5 (F-NEW-1 / ADR-0019 § "D2 correction (adversary
F-NEW-1)").** The original D2 execution reused BC-3.4.017's EDIT-derived **five**-member set
(`summary`/`description`/`issuetype`/`priority`/`components`) verbatim on the create path, but
`handle_create` writes **five MORE** dedicated-flag values into the same `fields` object `--field`
merges into — `--label`, `--parent`, `--to`/`--account-id`, `--points`, `--team` — none of which
tripped the five-member guard, reopening the exact "no defined winner" collision class D2 exists to
close. The create-path governed set is therefore **TEN wire-key targets, not five** (5 original static + 3
new static + 2 distinct resolved-id) — and is **distinct in size from** the edit-path Gate-B set
(still five; see the governed-set note in property 5 below). VP-578-021 is EXTENDED this round to
exercise all ten, including the two **distinct** resolved-id cases (`--points` and `--team`, each
firing the guard SEPARATELY against its own `customfield_NNNNN`) and their documented non-firing
residual.

**Architectural anchor**: one shared pure function `field_resolve::detect_flag_field_overlap(parsed:
&HashMap<String, FieldValueSpec>, supplied_flag_keys: &Set<wire-key>) -> Set<overlap>` (ADR-0019 §
Amendment D2 / architecture-delta §9 D2), reused by BOTH `edit.rs`'s existing Gate B and the new
`create.rs` guard — a set-intersection over already-parsed data, no I/O (pure core).

**Property statement**:
1. **Overlap → exit 64, argv-order-independent.** For any argv ordering of a dedicated flag and a
   `--field` pair on the SAME wire key (`--priority Medium --field priority:name=Medium`, and the
   reverse order), the guard rejects with exit 64. Because the check is a set-intersection over the
   parsed `HashMap` (not an ordered merge), the outcome is invariant under argv order **by
   construction** — this is the property that closes the defect at its root.
2. **Static-flag matching across hint kinds — all EIGHT static keys (F-NEW-1).** A hint-tagged `--field
   NAME:kind=VALUE` pair is matched on its BARE NAME (BC-3.4.026 bare-key rule), caught against its
   dedicated flag identically for **every** governed key. The eight static wire keys (the two DISTINCT
   resolved-id keys `--points`/`--team` are property 3, bringing the create governed set to TEN) and
   their dedicated flags:
   - **The original five (static key compare, unchanged):** `summary`←`--summary`,
     `description`←`--description`, `issuetype`←`--type`, `priority`←`--priority`,
     `components`←`--component`. (e.g. `priority:name=`, `priority:id=`, bare `priority=`,
     `issuetype:id=`, `components:name=` each collide with `--priority`/`--type`/`--component`.)
   - **The three NEW static keys (F-NEW-1, same zero-cost case-insensitive key compare as the five):**
     `labels`←`--label`, `parent`←`--parent`, `assignee`←`--to` / `--account-id` (clap
     `conflicts_with` already prevents supplying both assignee flags at once). Each must be exercised
     against a colliding `--field` (`--label X --field labels=Y`, `--parent FOO-1 --field parent=BAR-2`,
     `--to alice --field assignee=bob`, and the reverse argv orders) → exit 64, ZERO HTTP.
   - **`labels` governed on CREATE, excluded on EDIT — do NOT conflate (ADR-0019 § D2 correction).**
     `issue edit --label` forks to a different endpoint/payload shape (BUG-LABEL-400: single-key PUT
     bare-string labels vs multi-key bulk POST `{"name":…}` objects), so there is no single
     `fields.labels` write for edit Gate B to guard — `labels` is deliberately EXCLUDED from
     BC-3.4.017's edit set. `issue create --label` has NO such fork (one unforked
     `fields["labels"] = json!(labels)` write), so `labels` IS governed on create. This per-path
     asymmetry is intentional; VP-578-021's create-path coverage MUST include `labels`, and the
     edit-path Gate-B VP (VP-396-005) MUST NOT.
3. **Two RESOLVED-ID keys (F-NEW-1) — `--points`/`--team`, `customfield_NNNNN=` bypass form ONLY.**
   Unlike items 1-8 (fixed wire-key strings), `--points`/`--team` write to a *dynamically resolved*
   custom-field id (e.g. `customfield_10050`) read at zero cost from `config.active_profile()`
   (`story_points_field_id` / `team_field_id`; `Config` already loaded in `main.rs` before
   `handle_create`, EC-3.8.012-6 — not a new input, no HTTP). Collision detection compares that
   resolved id against a `--field customfield_NNNNN=` bypass form (BC-3.3.010 Step 1) via plain
   string-equality:
   - `--points 5 --field customfield_<points-id>=8` → exit 64, ZERO HTTP (whenever
     `story_points_field_id` is configured; `resolve_story_points_field_id` is config-only, never
     falls back to HTTP).
   - `--team Foo --field customfield_<team-id>=Bar` → exit 64, ZERO HTTP, **only when
     `team_field_id` is already in profile config** (the `jr init` common case);
     `client.find_team_field_id()` (HTTP) is NEVER invoked to service this guard — when the id is
     absent from config, this flag's branch is a no-op for the invocation (not a collision, not an
     HTTP call).
4. **NEGATIVE regression pin — display-name form does NOT trip the guard (F-NEW-1, bounded residual).**
   `--points 5 --field "Story Points"=8` (a human display-NAME on the `--field` side, not the
   `customfield_NNNNN` bypass) MUST **NOT** trip the guard — both values still reach the downstream
   merge unordered. Resolving a display name to a field id would require the cache-first
   `fields.json`/`list_fields()` lookup (BC-3.3.010 Step 2), which can issue `GET /rest/api/3/field`
   on a cold cache; hoisting that ahead of project/type resolution (step 2b, the zero-HTTP boundary)
   solely to service this guard would violate the Platform-Path Guard Ordering SSOT's zero-HTTP
   invariant. This is a **documented, bounded gap** (ADR-0019 § D2 correction), asserted as an
   explicit regression pin — a test that this invocation exits 0 (not 64) and fires no
   pre-project-resolution HTTP — **not** silently left untested. The same class as the pre-existing
   edit-path "team/points deferred to v2" exclusion, narrowed to this one residual.
5. **Governed-set — TEN on create, distinct from edit's FIVE (mechanism reuse, not set identity).**
   The create-path governed set is the TEN keys of items 1-4, NOT identical to BC-3.4.017's
   (unchanged) five-member edit set. The shared pure function `detect_flag_field_overlap` is reused
   for mechanism (set-intersection, exit-64-vs-last-wins symmetry), but each caller passes its OWN
   governed-key set — create passes ten (five original static + three new static + two distinct
   resolved ids), edit passes five. This is deliberate per-path scoping, not drift; the two sets are
   NOT required to be equal in size (correcting the pre-round-5 "SAME set as edit" claim, which was the
   F-NEW-1 defect).
6. **Pre-HTTP, zero calls.** The rejection fires BEFORE project/type resolution, BEFORE the
   createmeta enumeration GET, and BEFORE the POST — **zero** HTTP calls on the reject path (and, per
   property 3/4, the guard itself issues zero HTTP to build the governed-id set: static keys are
   literals, resolved ids come from already-loaded `Config`, and the display-name residual is
   deliberately NOT resolved).
7. **Error shape.** Exit 64, overlap error naming the colliding field (e.g. `priority`, `labels`,
   `parent`, `assignee`, or the resolved `customfield_NNNNN`), symmetric with the edit path's
   EC-3.4.017-16 message shape.

**Recommended strategy**: unit tests on the pure `detect_flag_field_overlap` (overlap present /
absent / multiple, each hint kind) asserting the returned overlap set — covering **all ten
create-path governed keys**: the five original static keys AND the three new static keys
(`labels`/`parent`/`assignee` via `--label`/`--parent`/`--to`/`--account-id`, each collided against a
`--field` in both argv orders) AND the two DISTINCT resolved-id keys, each asserted **SEPARATELY** as
its own collision case (`--points` + `--field customfield_<points-id>=` is one case; `--team` +
`--field customfield_<team-id>=` with `team_field_id` present in a stub `Config` is a second, distinct
case — never collapsed into one). A proptest asserting argv-order invariance (permuting the parsed inputs never
changes the overlap set). A **NEGATIVE regression pin** (property 4): `--points 5 --field "Story
Points"=8` returns the overlap set WITHOUT `story_points_field_id` in it (guard does not fire) AND the
end-to-end invocation exits 0 with **zero** pre-project-resolution HTTP — the bounded-residual test,
asserted explicitly, not omitted. A `--team` no-op assertion: with `team_field_id` ABSENT from the
stub `Config`, `--team Foo --field customfield_X=Bar` does not fire the guard and issues no
`find_team_field_id` HTTP. Plus **one integration test PER call site** (edit and create) asserting
exit 64 + the overlap error + **zero** HTTP requests fired (wiremock `.expect(0)` on both the
createmeta GET and the POST for the create path); the create-path integration set must include at
least the `labels` collision (the create-vs-edit divergence case) among its exercised flags.

**Target**: `src/cli/issue/field_resolve.rs` (`detect_flag_field_overlap` + unit/proptest) +
integration tests per call site (`tests/issue_create_field.rs` create; the existing edit-path Gate-B test
file for edit). **F6**: via `field_resolve.rs` glob add (§4).

---

### VP-578-022 — `:asset` cold-cache workspace-discovery FAILURE taxonomy *(NEW inline VP — F2 adversary convergence, B-LOW)*

**Applies to**: BC-3.4.030 (error taxonomy for the bare `:asset=<objectId>` cold-cache
`get_or_fetch_workspace_id` GET; EC-3.4.030-5). **Genuinely NEW inline VP** — the F2 B-LOW pass added
an explicit cold-cache workspace-discovery error taxonomy to BC-3.4.030, sourced from reading
`src/api/assets/workspace.rs::get_or_fetch_workspace_id` directly; it had no VP. Added to the
BC-3.4.030 body this pass (back-fills the PO's B-LOW placeholder, §5). **Pass2-F1 (F2
adversary-convergence round-2) widened the scope from TWO call sites to ALL THREE** — BC-3.8.008
independently specifies that `handle_jsm_create` (the JSM create path) ALSO calls
`get_or_fetch_workspace_id` first for a bare `:asset=<objectId>` hint, so the JSM site was omitted
and must be included. Complements VP-578-011 (warm-cache correctness, zero HTTP) and VP-578-012
(composer safety).

**Property statement** — each row of the taxonomy is independently exercised via wiremock, on **ALL
THREE** call sites that share `get_or_fetch_workspace_id` — `issue edit --field`, platform
`issue create --field`, and the JSM `issue create --request-type … --field` path
(`handle_jsm_create`) — per ADR-0019 §2's "L2 resolves, `build()` only wraps" split. **Because this
taxonomy fires during workspace-ID *resolution*, strictly BEFORE any `:asset` array is composed on
any path, it is wire-shape-INDEPENDENT and applies uniformly across all three sites:**
1. **403 / 404 (Assets not available on this site)** → `JrError::UserError` exit 64, "Assets is not
   available on this Jira site" — a genuine cold-cache HTTP round-trip (warm reads never reach this
   path, VP-578-011).
2. **200 + empty `values` (no workspace provisioned; JSM present, Assets/CMDB not enabled)** →
   `JrError::UserError` exit 64, "No Assets workspace found on this Jira site". Distinct from
   EC-3.4.030-4 (a field-schema-mismatch 400 from the FIELD-write POST): this failure happens
   EARLIER, during workspace-id RESOLUTION, before any field-write POST is attempted.
3. **401** → standard auth-error mapping (unaffected by the Assets-specific UserError above).
4. **5xx / network error** → standard API-error / network-error mapping.

**Scope boundary (do NOT conflate — Pass2-F1):** this VP asserts only the wire-shape-INDEPENDENT
workspace-discovery **FAILURE** taxonomy, now uniform across all three sites. It does **NOT** resolve
the SEPARATE, still-deferred question of whether the JSM path's happy-path `:asset`
`requestFieldValues` **SUCCESS**-wire shape matches the platform-path shape — that stays
**UNVERIFIED/parity-PENDING per VP-578-016** (BC-3.8.008 amendment), realized and verified at F4
against live JSM, unchanged by this fix. Workspace-discovery failure handling is verified-and-uniform
across all 3 sites; the JSM `:asset` success-path wire shape remains unverified/deferred.

**Recommended strategy**: per-row wiremock tests (mirroring the VP-578-004 error-taxonomy
discipline) asserting the exact exit code, error variant, and the load-bearing message substring for
rows 1–2, and standard-mapping parity for rows 3–4 — each run against **all three** call sites (edit,
platform-create, JSM-create) to pin the shared-function guarantee.

**Target**: the `get_or_fetch_workspace_id` call sites in `field_resolve.rs` (edit), `create.rs`
(platform-create), and `jsm_create.rs` (`handle_jsm_create`); integration in
`tests/issue_field_hint_kinds.rs` (new) + `tests/issue_create_field.rs`. **F6**: covered by
`field_resolve.rs` glob add (the client function `get_or_fetch_workspace_id` in
`src/api/assets/workspace.rs` is a read-only reused contract, not a new pure function this cycle).

---

### VP-580-010 — M2 post-arity project resolution *(NEW inline VP — F2 adversary convergence, D1)*

**Applies to**: BC-X.14.001 (M2 `--type` createmeta path). **Genuinely NEW inline VP** — ADR-0019 §
Amendment (2026-08-26) D1 restores M2/create-path parity: the "is a project resolvable?" question is
moved OUT of the pure arity function (`resolve_field_context`, now narrowed to 3 booleans — see
VP-580-006) into a distinct, post-arity resolution step executed only on the M2 branch. Added to the
BC-X.14.001 body this pass (back-fills the PO's D1 placeholder, §5). Structurally mirrors BC-3.3.010's
create-path flag-or-default project resolution — the SAME `Config`/`ProfileConfig` accessor, no new
resolution mechanism.

**Anchor**: a separate, SIBLING pure function `resolve_m2_project(cli_project: Option<&str>, config:
&Config) -> Option<String>` (pure core — deterministic given explicit args, reads only already-loaded
in-process `Config` state, no I/O; same purity class as `config::validate_profile_name`). Invoked
ONLY after `resolve_field_context` selects M2.

**Property statement** — over `{--project flag present, profile/config default present, neither} ×
M2-only`:
1. **Flag present → Ok.** An explicit `--project <KEY>` resolves M2's project to that value (flag
   wins), regardless of whether a default also exists.
2. **Default present, no flag → Ok.** No `--project` flag but an active profile/config default
   project configured → M2 resolves to the default (parity with BC-3.3.010's create path and M3's
   optional-companion fallback). This is the case the pre-D1 4-bool arity function wrongly rejected.
3. **Neither → exit 64, PRE-HTTP.** No flag AND no default → the incomplete-M2 exit-64 error (the
   error MESSAGE is unchanged from the pre-D1 spec; only the TRIGGER widens from "no flag" to "no
   flag AND no default"). No HTTP call is made — this resolution reads only in-process `Config`, so
   it stays inside BC-X.14.001's "arity guard evaluated before any HTTP call" contract.
4. **Purity / totality.** `resolve_m2_project` never panics and performs no I/O; it returns
   `Some(project)` or `None` deterministically from its two explicit arguments.

**Recommended strategy**: unit + proptest on the pure `resolve_m2_project` covering the three
`{flag, default, neither}` cases (a small `Config` fixture with / without a default); plus one
wiremock integration test asserting the "neither present" M2 invocation exits 64 with **zero** HTTP
requests fired (the pre-HTTP guarantee cannot be shown by the pure test alone). Reuse the fixture /
assertion shape of whatever existing VP covers BC-3.3.010's create-path flag-or-default project
resolution rather than inventing a new pattern.

**Target**: `resolve_m2_project` in the new `jr field options` handler (`src/cli/field.rs`);
unit/proptest co-located; integration in `tests/field_options.rs` (new). **F6**: add handler file to
`examine_globs`.

---

### VP-580-011 — `--value` + graceful-degrade interaction *(NEW inline VP — F2 adversary convergence, B-LOW)*

**Applies to**: BC-X.14.002 (`--value` filter) × BC-X.14.004 (graceful degrade). **Genuinely NEW
inline VP** — the F2 B-LOW pass documented that the two paths compose; it had no VP. Added to the
BC-X.14.002 body this pass (back-fills the PO's B-LOW placeholder, §5). The companion to VP-580-005
(graceful degrade) and VP-580-007 (`--value` filter correctness).

**Property statement**:
1. **Degrade hint fires regardless of `--value`.** For a field with NO enumerable
   `allowedValues`/`validValues`, the BC-X.14.004 graceful-degrade hint STILL fires on stderr when
   `--value` is also supplied — because the filter applies AFTER the full fetch, and a
   zero-enumerable-options field produces an empty `Vec<FieldOption>` BEFORE the filter ever runs, so
   `--value`'s presence or absence is immaterial to whether the degrade hint fires.
2. **stdout stays `[]` / empty, exit 0.** `--output json` → `stdout` is `[]` either way (EC-X.14.004-2);
   table mode → empty table; exit code 0 (a valid success, not an error) — identical to the
   no-`--value` case. The degrade hint's stderr text is unaffected by `--value`.
3. **Ordering invariant (the load-bearing part).** fetch → normalize (empty) → degrade-hint decision
   → filter — the filter is downstream of and cannot suppress the degrade path.

**Recommended strategy**: a wiremock integration test in `tests/field_options.rs` with a
zero-enumerable-options createmeta/editmeta/requesttype-fields fixture, run twice (with and without
`--value <substr>`), asserting IDENTICAL outcomes — exit 0, `stdout == "[]"` (JSON) / empty table,
and the degrade hint present on stderr in both runs. A unit assertion on the pure pipeline that the
`filter_options` step is applied to an already-empty `Vec` (the degrade decision precedes it).

**Target**: the enumerate→degrade→filter pipeline in the new `jr field options` handler
(`src/cli/field.rs`); integration in `tests/field_options.rs` (new). **F6**: add handler file to
`examine_globs`.

---

## 3. Coverage of the task's five mandated properties

| Task item | VP(s) (canonical) | Covered |
|---|---|---|
| 1. Hint-splitter multibyte safety (BC-3.4.026) | VP-578-005 | ✅ no-panic + clean-exit-64 + VALUE byte round-trip + bare-form invariance |
| 2. Value-kind mapping correctness (BC-3.4.027–031) | VP-578-007/008/009/010/011 (correctness) + VP-578-013 (malformed → exit 64, one error/invocation) + **VP-578-023** (non-cascading `>`-collision message + bare-form `>`-literal, D4) | ✅ per-kind JSON shape + cascading + `--priority` parity + malformed catalog + non-cascading-collision message + bare-`>`-literal fall-through |
| 3. Context mutual-exclusion (BC-X.14.001) | **VP-580-006** (arity) + **VP-580-010** (M2 project) | ✅ **[D1-updated]** `resolve_field_context` is now 3-bool (`has_type, has_request_type, has_issue`) — exactly-one MODE-SELECTOR accepted, 0/2+ → exit 64, pre-HTTP; `has_project` axis DROPPED. M2's project requirement is now the SEPARATE post-arity `resolve_m2_project` (VP-580-010): flag OR profile/config default → Ok, NEITHER → exit 64 pre-HTTP. `--project --request-type` valid M3 (VP-580-009). |
| 4. Graceful-degrade invariant (BC-X.14.004) | VP-580-005 | ✅ empty/absent options → exit 0; no panic on untyped `allowedValues.items` |
| 5. Assets-ref composer safety | VP-578-012 (safety) + VP-578-011 (correctness) | ✅ malformed `W:Y` → clean error, never malformed JSON body (sanitize-proptest parallel) |

Plus the two additional gap VPs F5 pass-1 required beyond the five above: **VP-580-007**
(`--value` filter, BC-X.14.002) and **VP-580-008** (output shape, BC-X.14.003).

**F2 adversary-convergence (2026-08-26) additions** beyond the F5-pass-1 surface: **VP-578-021**
(D2 — create-path Gate-B collision guard, BC-3.3.010), **VP-578-022** (B-LOW — `:asset` cold-cache
workspace-discovery failure taxonomy, BC-3.4.030, **Pass2-F1 widened to all THREE call sites**:
edit, platform-create, JSM-create), **VP-580-010** (D1 — M2 `resolve_m2_project`, BC-X.14.001),
**VP-580-011** (B-LOW — `--value` + graceful-degrade interaction, BC-X.14.002), and the round-2
**VP-580-012** (Pass2-F2 — `--project` not-found (404) HTTP-failure class on the M2 + M3
enumeration paths, BC-X.14.004; realized within VP-580-004's per-row coverage, not a core-surface
row), plus the D3 no-panic call-site `>`-split proptest folded into **VP-578-008** and the Pass2-F3
no-panic `:`-split proptest folded into **VP-578-012** (neither mints a new id). **F2
adversary-convergence round-4 (2026-08-26)** adds one further new id: **VP-578-023** (D4/F-2 —
BC-3.4.027 EC-3.4.027-7 non-cascading `>`-collision message + BC-3.4.015 bare-form `>`-literal;
sibling to VP-578-008, a core-surface row). **F2 adversary-convergence round-5 (2026-08-26)** adds one
further new id: **VP-578-024** (F-NEW-2 — dry-run `plannedChanges` hint-preview wire shape per kind +
`:asset` cold-cache side effect, BC-3.4.021; a core-surface row) and EXTENDS **VP-578-021** to the
ten-member create-path governed set (F-NEW-1; no new id). Task item 4
(B-F1) confirmed: **no** VP asserts M3 (`--request-type`) field-enumeration pagination — VP-578-020
covers only the two M2 createmeta endpoints (FIELDS + ISSUE-TYPES); `get_request_type_fields` is a
single non-paginated GET, so nothing to correct or remove.

**Task item 5 (O-3) — `jr field options` M2 page-≥2 coverage: DECISION — transitive VP-578-020
coverage is SUFFICIENT; NO dedicated VP minted.** The pagination correctness for the M2 path is a
property of the two shared client functions `get_issue_types_for_project` and `get_createmeta_fields`
(`src/api/jira/issues.rs`), which VP-578-020 already pins directly with two-page wiremock fixtures
(FIELDS + ISSUE-TYPES). `jr field options` M2 (BC-X.14.001) invokes those exact functions **unchanged**
to (a) resolve `--type` name→`issueTypeId` and (b) fetch the createmeta field whose options it
enumerates — a target field on fields-page ≥2 is collected, not dropped, precisely by VP-578-020(a),
and a `--type` on issuetypes-page ≥2 resolves precisely by VP-578-020(b). The options being enumerated
are the resolved field's OWN inline `allowedValues` (carried inside the createmeta field object, NOT a
separately-paginated collection), so `jr field options` M2 introduces **no additional pagination
surface** beyond what VP-578-020 covers. A dedicated `tests/field_options.rs` two-page fixture would
re-exercise the same shared pagination code through a different entry point — redundant, not new
coverage. **Reliance made explicit (so a future reader does not read field-options M2 pagination as
unverified):** VP-580-006's / VP-580-010's M2 wiremock realizations in `tests/field_options.rs`
SHOULD include at least one happy-path M2 run whose target field/`--type` resolves normally, but the
page-≥2-specifically-not-dropped guarantee is owned transitively by VP-578-020, not re-pinned here.
No new VP id, no VP-count change from O-3.

---

## 4. F6 (formal hardening) hand-off — mutation-coverage obligations

Per the F1 BA mapping (§3) and the VP-576-001 precedent cited in CLAUDE.md, whichever pure
parser/composer/normalizer/filter functions land in F4 must be reachable by `cargo-mutants`.
Concretely, the state-manager / F4 implementer should ensure `.cargo/mutants.toml` `examine_globs`
covers:

- `src/cli/issue/create.rs` — **already present** (`parse_field_kv` hint extension,
  VP-578-005/013; the platform-create `>`-split site's D3 no-panic proptest, VP-578-008;
  the create-path Gate-B guard call site, VP-578-021).
- `src/cli/issue/field_resolve.rs` — **ADD** (the value-kind emission dispatch, the cascading
  composer with its D3 `str::split_once('>')` split, the `:asset` composer, the new **shared
  pure `detect_flag_field_overlap`**, and the D4 non-cascading-collision structural `children`-empty
  branch + bare-form `>`-literal dispatch — VP-578-007/008/009/010/011/012/013/021/**023**). This
  file is core to #578 and is **not currently** in the glob list — a key F6 addition of this cycle.
- `src/types/jira/editmeta.rs` — **consider** for the D4 `AllowedValue.children` field (VP-578-023
  rule 3); a serde `#[serde(default)]` default is a thin data-shape change with a dedicated round-trip
  unit test, so a mutation glob here is optional (the round-trip test is the primary pin) — flagged
  for F4/F6 judgment, not mandated.
- The new `jr field options` handler file (`src/cli/field.rs` if F4 creates one) — **ADD at
  file-creation time**, per the S-576-1 / S-577-1 precedent ("new CLI handler file → add to
  mutants.toml at creation"). Covers the pure `normalize_from_allowed_values` /
  `normalize_from_valid_values` normalizers (VP-580-005), the
  context-arity guard `resolve_field_context` (VP-580-006, now 3-bool per D1), the **new pure
  `resolve_m2_project`** M2 project resolver (VP-580-010, D1), the `filter_options` filter
  (VP-580-007) plus its graceful-degrade-ordering companion (VP-580-011), and the
  render/print shaping (VP-580-008) if any lives there.

Note: VP-578-022's `:asset` cold-cache failure taxonomy targets the reused, read-only
`src/api/assets/workspace.rs::get_or_fetch_workspace_id` client function (BC-4.2.001) — not a NEW
pure function this cycle — so it is verified by per-row wiremock (§2 VP-578-022), not by a new
mutation-glob addition.

`tests/mutants_glob_existence.rs` (the always-run guard) will fail loudly if a glob is added
for a file that doesn't yet exist, so the glob add must land in the **same** commit as the
new file.

**No PROVISIONAL markers remain.** ADR-0019 (Accepted 2026-08-25) confirmed the `>` cascading
delimiter (split-on-first, `:id=` escape hatch); VP-578-008's cascading assertions are therefore
firm and ship this cycle. The inline VP-578-008 PROVISIONAL marker in `bc-3-issue-write.md` was
cleared this pass (§5).

## 5. Index / registry + BC-body actions

**Registry**: None. No VP-NNN registry or verification ARCH-INDEX exists to update (§0). The
twenty core VP guarantees (§1) are realized as **new** inline `proptest!`/unit/integration tests
at the cited locations in F4, and as `examine_globs` additions in F6; the remaining eight declared
#578 inline VPs realized outside the core surface (§1.1 — VP-578-001..004, 017..020) are realized by
reuse of the VP-396-009 edit-path realizations transplanted to the create path, by the DEC-310
reversal's rewritten holdout scenarios + `create.rs` guard-removal regression tests, and (VP-578-020)
by new two-page createmeta wiremock tests (**both** the FIELDS and ISSUE-TYPES createmeta endpoints)
in `tests/issue_create_field.rs`. The full declared inline inventory
this delta touches is **thirty-two** VPs (twenty-four #578 [VP-578-001..024] + VP-580-005..012). If
the state-manager later stands up the `S-PG-VP-REGISTRY-1` registry, these are its seed rows for the
field-dx cycle.

**BC-body edits made in the F5/F6 pass-1 fixes** (the only durable home for these VP ids, given the
inline convention):
- `bc-3-issue-write.md` BC-3.4.027 → **VP-578-008 de-PROVISIONALized** (delimiter CONFIRMED per
  ADR-0019 §3). *(The cascading BEHAVIOR prose in the BC-3.4.027 body — description, EC-4 — is
  de-PROVISIONALized by the product-owner in parallel; this pass touched only the VP-578-008
  verification-property line.)*
- `cross-cutting.md` BC-X.14.001 → **VP-580-006 added** (mutual-exclusion Invariant 1 — the gap).
- `cross-cutting.md` BC-X.14.002 → **VP-580-007 added** (a new Verification Properties section —
  `--value` filter; the BC previously had none).
- `cross-cutting.md` BC-X.14.003 → **VP-580-008 added** (a new Verification Properties section —
  output shape; the BC previously had none).
- `bc-3-issue-write.md` BC-3.3.010 → **VP-578-020 added** inline (createmeta-family
  offset-pagination: a `--field` target on the FIELDS createmeta page ≥2 **AND** a `--type` entry on the
  ISSUE-TYPES createmeta page ≥2 each resolve, not dropped). *(Added to the BC-3.3.010 body by
  the product-owner in parallel; this verification-delta only records the new VP id and its realization
  pointer.)*

**BC-body edits made THIS pass** (F2 adversary-convergence, 2026-08-26 — back-filling the four
"flagged for the verifier to assign a VP id" placeholder markers the product-owner left, plus the D3
extension; these are the ONLY edits this verifier made to the two BC files, per the task's TARGETED
write scope):
- `bc-3-issue-write.md` BC-3.3.010 (Verification Properties) → **VP-578-021 assigned** to the D2
  create-path Gate-B collision-guard property (replaced the D2 placeholder marker; PO body text
  otherwise untouched).
- `bc-3-issue-write.md` BC-3.4.030 (Verification Properties) → **VP-578-022 assigned** to the B-LOW
  `:asset` cold-cache workspace-discovery failure-taxonomy property (replaced the B-LOW placeholder
  marker; PO body text otherwise untouched).
- `cross-cutting.md` BC-X.14.001 (VP-580-006 body) → **VP-580-010 assigned** to the D1
  `resolve_m2_project` sibling property (replaced the D1 placeholder marker; PO body text otherwise
  untouched).
- `cross-cutting.md` BC-X.14.002 (Verification Properties) → **VP-580-011 assigned** to the B-LOW
  `--value` + graceful-degrade property (replaced the B-LOW placeholder marker; PO body text
  otherwise untouched).
- **D3 (no new BC-body VP-id edit):** BC-3.4.027's VP-578-008 line already carries the
  product-owner's `[EXTENDED 2026-08-26, D3]` no-panic-proptest note; this delta realizes it as an
  extension of VP-578-008 (§2), minting no new id. The BC files needed no edit for D3.

**Round-2 fix-chain (F2 adversary-convergence round-2, 2026-08-26) — verification-delta-only edits,
NO BC-body edits this round.** The four BC-body placeholder back-fills above were made in the
round-1 F2 pass. This round-2 pass aligned the verification delta to the architect's and
product-owner's round-2 amendments and made **zero** edits to `bc-3-issue-write.md` /
`cross-cutting.md` — there were no unfilled placeholder markers to back-fill (grep-confirmed). The
round-2 changes are all inside this file: (1) Pass1-F1 — VP-580-006 §2 rewritten from the stale
pre-D1 4-boolean `resolve_field_context(has_type, has_request_type, has_issue, has_project)` to the
correct 3-boolean signature (dropped the `has_project` axis and the `(!has_type || has_project)`
arity clause; the M2 project requirement is VP-580-010's, not duplicated here); (2) Pass2-F1 —
VP-578-022 widened to assert the `:asset` cold-cache failure taxonomy on all THREE call sites (edit,
platform-create, JSM `handle_jsm_create`), with the JSM `:asset` happy-path wire shape kept
UNVERIFIED/deferred (VP-578-016); (3) Pass2-F3 — VP-578-012 extended with a `str::split_once(':')`
no-panic proptest note for the `WORKSPACE:OBJECTID` first-colon split (folded in, no new id);
(4) Pass2-F2 — **VP-580-012 minted** for the `--project` not-found (404) HTTP-failure class on the
M2 + M3 enumeration paths.
- **VP-580-012 — BC-body back-fill NOW DONE (was pending in round-2/round-3).** Pass2-F2 left the
  "new row → own VP?" question open without a placeholder marker in `cross-cutting.md`, so
  VP-580-012's inline BC-body declaration could not be made in round-2/round-3. **As of F2 round-4 it
  IS declared** in `cross-cutting.md` BC-X.14.004's Verification Properties (~line 2805, alongside
  VP-580-004/005/009), anchored to the `--project not found (404)` taxonomy row + EC-X.14.004-6 — text
  verified present during this round-4 pass. The round-2/round-3 "pending one-line back-fill" flag is
  **CLOSED**; no further state-manager/PO action is required for VP-580-012's BC anchor.

**Round-3 amendments (F2 adversary-convergence round-3, 2026-08-26) — verification-delta-only edits,
NO BC-body edits, NO new VP (total stays 30).** This pass aligned the verification delta to the
architect's ADR-0019 § Amendment **F-B** and the product-owner's round-3 BC amendments
(`bc-3-issue-write.md` / `cross-cutting.md`, already landed). A grep confirmed **no** "verifier to
assign VP id" placeholder markers exist in either BC file, so per this round's write scope **no BC
file was touched**. All four fixes are amendments to EXISTING VPs:
(1) **F-A** — **VP-578-013 §3** rewritten: the empty-value→exit-64 assertion is scoped to `:asset`
ONLY (a STRUCTURAL composer failure, EC-2a), and empty `:id=`/`:name=` are pinned as PASS-THROUGH
(`{"id":""}`/`{"name":""}`, EC-8/EC-9, per ADR-0019 §2(b) + BC-3.4.028/029); the `prop_oneof!`
strategy now generates **all four valid kinds** (adds the previously-omitted `:name`, plus `:option`)
with a **per-kind** classification replacing the old blanket `.is_err()` (the blanket form was the
F-A defect). VP-578-005 §4 (empty value allowed at parser) stays green as the consistent general-case
counterpart — **no contradiction**.
(2) **F-C** — **VP-578-012 §2** now asserts the DISTINCT extra-colon message for `:asset=W:Y:Z`
(`str::split_once(':')` → objectId candidate `Y:Z` → `"unexpected extra ':' … expected
WORKSPACE:OBJECTID"`, BC-3.4.031 EC-2d), a message-CONTENT assertion, NOT EC-3's generic "objectId
must be numeric"; a dedicated `"W:Y:Z"` regression pin was added to the EXTENDED companion list.
(3) **F-B** — **VP-580-005 §2** strengthened from "no panic" to also assert (a) entry-count
preservation / never-drop (`output.len() == input.len()`), (b) the exact `Option::None`→JSON-`null`
shape for missing id/label, and (c) the pinned table strings `"—"`/`"(unnamed)"` (integration-level,
paired with VP-580-008(d)); the proptests gained the length assertion.
(4) **F-B** — **VP-580-008** gained sub-point **(d)** (degenerate-entry rendering): table `"—"`
(missing id) / `"(unnamed)"` (missing label), JSON `null` (no substitution), never-drop at the render
layer.
VP-580-006 §2 was re-checked and remains the post-D1 **3-boolean** `resolve_field_context(has_type,
has_request_type, has_issue)` form — not regressed by this round.

**Task item 4 (B-F1) — verified, no edit required:** the verification delta contains **no** VP
asserting M3 (`--request-type`) field-enumeration pagination. VP-578-020 is scoped to the two M2
createmeta endpoints only; `get_request_type_fields` is a single non-paginated GET (flat envelope).
Nothing to correct or remove.

**Round-4 amendments (F2 adversary-convergence round-4, 2026-08-26) — verification-delta-only edits,
ONE new VP (total 30 → 31).** This pass aligned the verification delta to the product-owner's round-4
BC amendments (`bc-3-issue-write.md` / `cross-cutting.md`, already landed) and the architect's
ADR-0019 § Amendment **D4** (adversary tag F-2). A grep of both BC files confirmed **no** "verifier to
assign VP id" placeholder markers exist, so per this round's write scope **no BC file was touched**.
Changes, all inside this delta file:
(1) **MED-3 / F-A follow-through** — **VP-578-013 §3** proptest split: `:option` empty value moved
from the `is_ok()` arm to a dedicated `is_err()` arm — an empty `:option` is an `allowedValues`
match-miss resolved **downstream** (BC-3.4.016 EC-3.4.016-2 → exit 64), distinct in ORIGIN from
`:asset`'s STRUCTURAL composer failure; `:id`/`:name` remain `is_ok()` verbatim pass-through. Added a
comment noting the distinct downstream-vs-structural origin and a downstream exit-64 row to the
table-driven catalog test.
(2) **F-1** — **VP-580-007** aligned to F-B's `Option<String>`: three new sub-points **(g)/(h)/(i)** —
a `None` id/label is not a match source (skipped, no panic); filtering never violates never-drop; and
`--value "" == --value absent` identity holds INCLUDING a fully-degenerate `{id:None,label:None}`
entry. Degenerate-fixture requirement added to the recommended strategy.
(3) **F-2/D4** — **VP-578-023 MINTED** (the ONE new id this round): non-cascading `>`-collision
message (`:option` on a plain `option` field whose matched parent's `children` is empty → exit 64,
pinned `"is not a cascading select"` + `"remove the"`, EC-3.4.027-7) + bare-form `>`-literal behavior
(no split → EC-3.4.016-2 fall-through, D4 cell b) + the `AllowedValue.children: Vec<AllowedValue>`
(`#[serde(default)]`) type dependency. Sibling to VP-578-008, a new §1 core-surface row. **Because no
PO "verifier to assign VP id" placeholder existed in the BC files, VP-578-023's inline BC-body anchor
(BC-3.4.027's VP-578-008 [EXTENDED D4] note ~line 3291 + BC-3.4.015's `>`-literal note ~line 1893)
is a pending one-line back-fill for state-manager/PO** — the same treatment VP-580-012 received in
round-2/round-3 (now the sole pending back-fill, replacing VP-580-012 which closed this round).
(4) **Item 4** — VP-580-012's BC-body back-fill confirmed DONE (verified present in
`cross-cutting.md` BC-X.14.004 ~line 2805); its round-2/round-3 "pending" flag CLOSED.
(5) **O-3** — DECISION recorded (§3): transitive VP-578-020 coverage is SUFFICIENT for `jr field
options` M2 page-≥2 (the shared `get_issue_types_for_project`/`get_createmeta_fields` functions carry
the guarantee); NO dedicated VP minted, no count change from O-3.

**Round-5 amendments (F2 adversary-convergence round-5, 2026-08-26) — verification-delta edits + ONE
targeted BC edit, ONE new VP (total 31 → 32).** This pass aligned the delta to the architect's
ADR-0019 § "D2 correction (adversary F-NEW-1)" and the product-owner's round-5 BC amendments
(`bc-3-issue-write.md` / `cross-cutting.md`, already landed):
(1) **F-NEW-1** — **VP-578-021 EXTENDED**: the create-path Gate-B governed set is widened from FIVE to
TEN wire keys (5 original static + 3 new static + 2 distinct resolved-id). Property 2 gains the three
new static-flag keys (`labels`←`--label`, `parent`←`--parent`, `assignee`←`--to`/`--account-id`) with
the `labels`-governed-on-create/excluded-on-edit (BUG-LABEL-400) distinction; a new property 3 pins the
two DISTINCT resolved-id keys (`--points`→story-points customfield id AND `--team`→team customfield id
are two separate governed members with distinct `customfield_NNNNN` wire keys, the guard firing
SEPARATELY for each, via the `customfield_NNNNN=` bypass form ONLY, read from already-loaded `Config`,
zero HTTP); a new property 4 is a **NEGATIVE regression pin** that the display-name form
(`--points 5 --field "Story Points"=8`) does NOT trip the guard (the bounded
zero-HTTP-before-project-resolution residual); property 5 corrects the pre-round-5 "SAME set as edit"
claim to "ten on create, distinct from edit's five — mechanism reuse, not set identity" (the prior pass
wrongly collapsed `--points`+`--team` into one category to force a "nine" total). Recommended strategy
updated to require coverage of all ten keys, the two resolved-id cases asserted SEPARATELY, the negative
pin, and a `--team` no-op case. No BC edit needed (VP-578-021's BC-3.3.010 anchor already exists; the PO
widened EC-3.3.010-6a / EC-3.4.029-2 to the ten-member set this round).
(2) **F-NEW-2** — **VP-578-024 MINTED** (the ONE new id this round): dry-run `plannedChanges`
hint-preview wire shape per hint kind (`:id`→`{"id":…}`, `:name`→`{"name":…}`, `:option`
non-cascading→`{"id":…}`, cascading→`{"value":…,"child":{"value":…}}`, `:asset`→`[{workspaceId,id,
objectId}]`; NOT the bare-form display string; PUT `.expect(0)`) + the `:asset` cold-cache side effect
(real `get_or_fetch_workspace_id` GET fires under `--dry-run`, can exit 64 per BC-3.4.030's cold-cache
taxonomy before any `plannedChanges` output, EC-3.4.015-18/-19). **A targeted BC edit replaced the PO's
`VP-DRY-RUN-005` placeholder in BC-3.4.021 with `VP-578-024`** — the ONLY BC edit this round (the PO
left an explicit placeholder marker, unlike VP-578-023's round-4 back-fill situation).
(3) **MED-2** — **VP-578-023 BC-body back-fill is now DONE at BOTH sites**, superseding the round-4
"sole pending back-fill" claim in item (3) above: BC-3.4.027 (~L3319) already declared it in round-4,
and the PO back-filled BC-3.4.015 (~L1901, the `>`-literal note) this round. `related_bcs` gained
BC-3.4.015 (VP-578-023's "Applies to" names it) alongside the existing BC-3.4.027 entry. There is now
**ZERO** pending field-dx BC-body back-fill.
(4) **MED-1 / task-item-4** — **VP-578-013 EC-2d consistency CONFIRMED, no edit required**: the
verification delta already uses **EC-2a** for the empty-`:asset` structural rejection (VP-578-013 §3),
and every EC-2d reference in this file is VP-578-012's extra-colon `W:Y:Z` distinct-message assertion
(§ VP-578-012), never misattributed to VP-578-013. The PO's round-5 BC-body fix (BC-3.4.031 VP-578-013
enumeration → `EC-2a/b/c`, dropping the stray `d`) matches this delta; no contradiction to reconcile.

These edits, plus this reconciled delta, leave **exactly one authoritative VP id per
guarantee**, **zero PROVISIONAL markers**, and — across the field-dx verification surface — **zero
outstanding BC-body back-fills**: VP-578-023's (both sites) and VP-580-012's are all CLOSED, and
VP-578-024 was assigned into BC-3.4.021 this round (targeted edit). There are **zero unfilled
"assign a VP id" placeholders** remaining.
