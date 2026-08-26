---
document_type: verification-delta
phase: phase-f2-spec-evolution
cycle: field-dx
issues: [580, 578]
producer: formal-verifier
timestamp: 2026-08-25
status: complete
convention: inline-proptest   # this repo has NO centralized VP-NNN registry — see §0
# ONE authoritative VP id per guarantee. The parallel `VP-*-04x` band an earlier revision of
# this delta introduced is RETIRED (F5 pass-1 finding) — every property below is now labeled
# with the single canonical inline VP id it is realized against. See §0 for the complete
# old-04x → canonical mapping.
new_properties:            # genuinely NEW inline VPs — extend the existing VP-578-0xx / VP-580-0xx sequences
  - VP-578-020   # createmeta-family multi-page resolution (BC-3.3.010) — adversary pass-28 F-1; ADR-0019 §1 offset-pagination across BOTH createmeta endpoints: (a) FIELDS (`get_createmeta_fields`) — a `--field` target on fields-page ≥2 is collected and resolves (exit 0), not dropped; AND (b) ISSUE-TYPES (`get_issue_types_for_project`, the `--type` name→id resolution in src/api/jira/issues.rs) — a `--type` entry on issuetypes-page ≥2 resolves to its issueTypeId (exit 0), not dropped; added inline to BC-3.3.010
  - VP-580-006   # context mutual-exclusion arity guard (BC-X.14.001 Invariant 1) — was the gap; added inline to BC-X.14.001
  - VP-580-007   # --value client-side filter correctness (BC-X.14.002) — was the gap; added inline to BC-X.14.002
  - VP-580-008   # table/JSON output-shape (BC-X.14.003) — was the gap; added inline to BC-X.14.003
  - VP-580-009   # `--project --request-type` valid M3, NOT an arity error (BC-X.14.004) — adversary pass-20 M1 / ADR-0019 §1 regression guard; realized as the positive `--project --request-type → Ok` case of VP-580-006's arity proptest
realizes_inline_vps:       # proptest/unit REALIZATIONS of EXISTING inline VPs — no new id, no duplicate
  - VP-578-001   # platform-create `--field` resolves via createmeta (never editmeta) (BC-3.3.010) — realized §1.1 (tests/issue_create.rs createmeta path, reuses VP-396-009 edit-path realization transplanted to create)
  - VP-578-002   # fields.json cache SHARED between `edit --field` and `create --field`, same profile (BC-3.3.010) — realized §1.1 (tests/issue_create.rs warm-cache reuse; shares resolve_edit_fields/write_fields_cache from VP-396-009)
  - VP-578-003   # all-or-nothing multi-`--field` failure on create (zero POST on any resolution failure) (BC-3.3.010) — realized §1.1 (tests/issue_create.rs create-path variant transplanting VP-396-009 edit-path semantics)
  - VP-578-004   # create-path `--field` error-taxonomy rows each independently exercised (BC-3.3.011) — realized §1.1 (per-row wiremock tests in tests/issue_create.rs: exit 64, zero POST, exact substring per row)
  - VP-578-005   # hint-splitter multibyte / Unicode-scalar safety (BC-3.4.026) — absorbs former VP-578-040
  - VP-578-006   # bare-name map key: last-wins ACROSS kinds, no composite-key double-apply (BC-3.4.026, ADR-0019 §2(b))
  - VP-578-007   # :option byte-identity to bare (BC-3.4.027) — absorbs former VP-578-041.1
  - VP-578-008   # :option cascading Parent>Child composition (BC-3.4.027) — absorbs former VP-578-041.3; DE-PROVISIONALIZED per ADR-0019
  - VP-578-009   # :id value-kind mapping (BC-3.4.028) — absorbs former VP-578-042
  - VP-578-010   # :name value-kind mapping + --priority parity (BC-3.4.029) — absorbs former VP-578-043
  - VP-578-011   # :asset composer wire-shape correctness (BC-3.4.030) — absorbs former VP-578-044
  - VP-578-012   # :asset composer safety proptest — never malformed JSON body (BC-3.4.030) — absorbs former VP-578-046 + malformed-:asset part of VP-578-045
  - VP-578-013   # malformed-hint edge-case catalog: exit-64, one-error-per-invocation (BC-3.4.031) — absorbs former VP-578-045
  - VP-578-014   # EC-6/EC-7 regression pins: colon-in-VALUE resolves normally, unknown-kind fires the specific error (BC-3.4.031)
  - VP-578-017   # DEC-307 reversal: `--field` alone (no `--request-type`, well-formed) → exit 0, platform POST with field merged (BC-3.8.012) — realized §1.1 (rewritten holdouts H-NEW-PREFLIGHT-001/006 + create.rs guard-removal regression tests)
  - VP-578-018   # DEC-307 reversal: `--field --on-behalf-of` (no `--request-type`) → exit 64 via BC-3.8.013 standalone guard only, combined guard REMOVED (BC-3.8.012/013) — realized §1.1 (rewritten holdout H-NEW-PREFLIGHT-003 + create.rs guard-removal/combined-narrowing regression tests)
  - VP-578-019   # DEC-307 reversal regression pin: `--on-behalf-of` alone → exit 64 via BC-3.8.013, unchanged wire-for-wire (BC-3.8.013) — realized §1.1 (unchanged holdout H-NEW-PREFLIGHT-002 + create.rs guard-removal regression tests)
  - VP-580-005   # graceful-degrade: no enumerable options → exit 0, no panic on untyped allowedValues (BC-X.14.004) — absorbs former VP-580-041
related_bcs:
  - BC-3.3.010
  - BC-3.3.011
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
  - ADR-0019      # Accepted 2026-08-25 — confirms `>` cascading delimiter (split-on-first, `:id=` escape hatch); de-PROVISIONALizes VP-578-008
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

**Four genuinely-new VP-580 ids** were minted this delta (each ADDED to its BC body — see §5):
three F5-gap VPs — **VP-580-006** (BC-X.14.001 Invariant 1 mutual-exclusion), **VP-580-007**
(BC-X.14.002 `--value` filter), **VP-580-008** (BC-X.14.003 output shape) — plus the pass-20
regression pin **VP-580-009** (BC-X.14.004 `--project --request-type` is a VALID M3, not an arity
error; realized WITHIN VP-580-006's arity proptest, not a separate core-surface row). All four
**extend** the existing `VP-580-0xx` sequence (prior max was `005`); they are NOT a parallel band.

**One VP-578-0xx id is newly minted this cycle** — **VP-578-020** (createmeta multi-page field
resolution, BC-3.3.010; adversary pass-28 F-1, frontmatter `new_properties`). Every other #578
guarantee already had an inline id. The full declared inline span is **VP-578-001..020** (all
twenty ids are declared inline in `bc-3-issue-write.md`): VP-578-001/002/003 on BC-3.3.010
(platform-create createmeta resolution / cache-sharing / all-or-nothing), VP-578-004 on BC-3.3.011
(create-path error taxonomy), VP-578-005..014 the value-kind / hint-splitter / malformed-catalog
guarantees this delta realizes (§1), VP-578-015/016 the JSM parity pair (frontmatter
`aligns_with_inline_vps`; VP-578-016 is **UNVERIFIED / parity-PENDING** — its `requestFieldValues`
write shapes are realized at F4 against live JSM, not pinned firm by this delta — see §1.1),
VP-578-017/018/019 the DEC-307 reversal's own VPs on BC-3.8.012/013, and VP-578-020 the createmeta-family
offset-pagination guarantee on BC-3.3.010 — covering **BOTH** the FIELDS (`get_createmeta_fields`, `--field`)
and ISSUE-TYPES (`get_issue_types_for_project`, `--type`) createmeta endpoints (the one new #578 id, added
inline to BC-3.3.010 by the product-owner in parallel). Apart from VP-578-020, the delta only supplies proptest/unit
realizations; it mints no other new #578 id. §1.1 catalogs where each of the eight #578 ids NOT in
the §1 core table (VP-578-001..004, 017..020) is realized — none is left without a realization
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

Fourteen authoritative VP guarantees form this delta's **core proptest/unit surface** (eleven
realizations of existing inline VPs + three new inline VPs), grouped by concern. **All ids are the
canonical inline ids** (§0.1). A further **eight** declared #578 inline VPs (VP-578-001..004,
017..020) are realized by reuse, by the DEC-307 reversal's holdout/regression work, and (VP-578-020)
by the new createmeta-pagination tests (**both** the FIELDS and ISSUE-TYPES createmeta endpoints) —
catalogued separately in **§1.1** — as is the JSM-parity
pair VP-578-015/016 (frontmatter
`aligns_with_inline_vps`; **VP-578-016's `:id`/`:name`/`:asset` `requestFieldValues` write shapes
are UNVERIFIED / parity-PENDING — realized at F4 against live JSM, not pinned firm by this delta;
see §1.1**). The full declared inline inventory this delta touches is **twenty-five**
VPs: the twenty #578 ids (VP-578-001..020) plus VP-580-005..009 (VP-580-001..004 were declared
inline by the product-owner pass — not minted by this verifier delta — and are realized at F4
alongside the new `src/cli/field.rs` command, still unimplemented; this delta adds no further
realization work for them, so they fall outside its realization surface).

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

**VP-580-009 (regression guard — realized WITHIN VP-580-006, not a separate core-surface row).**
VP-580-009 (BC-X.14.004) — `--project --request-type` together is a **VALID M3** invocation
(explicit service-desk project), **NOT an arity error** (adversary pass-20 M1; ADR-0019 §1) — is a
**newly-minted inline VP this cycle** (frontmatter `new_properties`), but it is **not** an
independent fifteenth core-surface realization: it is realized as the **positive
`--project --request-type → Ok` case** of VP-580-006's `resolve_field_context` arity proptest
(§2 VP-580-006, `src/cli/issue/field_resolve.rs`) together with the paired **positive** wiremock
assertion VP-580-006 already prescribes in `tests/field_options.rs` (that
`--project --request-type` does **not** trip the guard). It carries its own id purely as a durable
**regression pin** against re-introducing the superseded "pairing-error" behavior. This is why the
delta's full declared inline inventory is **twenty-five** (twenty #578 + VP-580-005..009) while
the §1 core surface remains **fourteen** new proptest/unit realizations.

### 1.1 Remaining declared #578 inline VPs — realization pointers (realized outside the §1 core surface)

The §1 table lists the fourteen guarantees this delta realizes as **new** proptest/unit work.
For completeness, the remaining **eight** declared `VP-578-0xx` ids — the full #578 inline span is
**VP-578-001..020** — are realized as follows. **None is left without a realization pointer.**
VP-578-001..004 are the platform-**create** path VPs (realized largely by reuse of the VP-396-009
**edit**-path realizations, transplanted to create); VP-578-017/018/019 are the **DEC-307 reversal's**
own VPs (realized by the rewritten holdout scenarios + the `create.rs` guard-removal regression
tests); **VP-578-020** (the one new #578 id this cycle, adversary pass-28 F-1) is the createmeta-family
offset-pagination guarantee across **both** createmeta endpoints (FIELDS via `get_createmeta_fields` /
`--field`, and ISSUE-TYPES via `get_issue_types_for_project` / `--type`), realized by new two-page
createmeta wiremock tests (one per endpoint) in `tests/issue_create.rs`. The JSM-parity pair VP-578-015/016 is separately accounted for by the
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
| VP-578-001 | `--field` on platform create resolves via **createmeta**, never `editmeta` (no `GET …/editmeta` on the create path) | BC-3.3.010 | Platform create-path tests in `tests/issue_create.rs` exercising the `create.rs` createmeta resolution path; **reuses** the VP-396-009 edit-path resolution realization transplanted to create. |
| VP-578-002 | Field-list cache (`fields.json`) **shared** between `issue edit --field` and `issue create --field` (same profile) | BC-3.3.010 | `tests/issue_create.rs` warm-cache reuse assertion (a cache populated by `edit --field` satisfies `create --field`); shares the `resolve_edit_fields` / `write_fields_cache` realization from VP-396-009. |
| VP-578-003 | **All-or-nothing** multi-`--field` failure on create (zero POST on any resolution failure) | BC-3.3.010 | `tests/issue_create.rs` create-path variant; explicitly **transplants** VP-396-009's edit-path all-or-nothing semantics to the create path (per the BC-3.3.010 / VP-578-003 body). |
| VP-578-004 | Create-path `--field` **error-taxonomy** rows each independently exercised | BC-3.3.011 | Per-row wiremock tests in `tests/issue_create.rs` asserting exit 64, zero POST, and the exact load-bearing substring for each taxonomy row (same discipline the inline VP-578-004 body prescribes). |
| VP-578-017 | `--field a=b` alone (no `--request-type`, well-formed) → exit 0, platform POST fires with the field merged in; stderr has NO `"--field is only valid with"` | BC-3.8.012 (CURRENT) | **Rewritten** holdout scenarios **H-NEW-PREFLIGHT-001** (table mode) + **H-NEW-PREFLIGHT-006** (`--output json` variant), plus the `create.rs` guard-**removal** regression tests inverting the dead DEC-188 exit-64 assertions. |
| VP-578-018 | `--field a=b --on-behalf-of X` (no `--request-type`) → exit 64 via BC-3.8.013's **standalone** guard only (combined guard REMOVED, createmeta resolution never reached) | BC-3.8.012 / BC-3.8.013 (CURRENT) | **Rewritten** holdout scenario **H-NEW-PREFLIGHT-003**, plus the `create.rs` guard-removal / combined-check-narrowing regression tests. |
| VP-578-019 | Regression pin: `--on-behalf-of X` **alone** → exit 64 via BC-3.8.013, **unchanged wire-for-wire** from DEC-188-era behavior (proves the reversal did not weaken BC-3.8.013) | BC-3.8.013 | **Unchanged** holdout scenario **H-NEW-PREFLIGHT-002** + the `create.rs` guard-removal regression tests (which assert BC-3.8.013's standalone guard survives untouched). |
| **VP-578-020** *(NEW — adversary pass-28 F-1)* | Createmeta-**family** multi-page resolution across **BOTH** offset-paginated createmeta endpoints (ADR-0019 §1): **(a) FIELDS** — `get_createmeta_fields` is offset-paginated, so a `--field` whose target field falls on fields-**page ≥2** is collected and resolves normally (**exit 0**, field merged into the create POST body), **never silently dropped** because only page 1 was read; **AND (b) ISSUE-TYPES** — `get_issue_types_for_project` (the `--type` name→id resolution, `src/api/jira/issues.rs`) is **likewise** offset-paginated (`startAt`/`maxResults`/`total`), so a `--type` whose entry falls on issuetypes-**page ≥2** resolves to its `issueTypeId` (**exit 0**), **never dropped** for the same reason. Mirrors the `list_worklogs` / BC-X.5.002 all-pages precedent (single-page fetch silently truncates → must paginate). | BC-3.3.010 | Two new **two-page createmeta wiremock** tests in `tests/issue_create.rs`, **one per endpoint**: **(a) fields** — page 1 returns `maxResults` fields **without** the target, page 2 returns the target field; asserts the `--field` resolves to **exit 0** with the field present in the composed POST body, **and** that the client fetches **BOTH** pages. **(b) issue-types** — page 1 returns `maxResults` issue types **without** the target `--type`, page 2 returns the target; asserts the `--type` resolves (to its `issueTypeId`, **exit 0**) **and** that **BOTH** pages are fetched. In each case a `.expect(1)`-style single-page assumption would false-red. Models the `list_worklogs` all-pages pagination test precedent. |

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

**Recommended strategy**: deterministic unit tests over a mocked cascading `allowedValues`
fixture (`allowedValues[].value` + matched-parent `children[].value`), covering: two-segment
compose, second-`>`-goes-to-child, parent-only, EC-3.4.027-2 (unresolvable parent → exit 64),
EC-3.4.027-3 (unresolvable child → exit 64), and the EC-4 `:id=` fallback for a `>`-bearing label.

**Target**: `src/cli/issue/field_resolve.rs` (cascading composer + unit tests). **F6**: via
`field_resolve.rs` glob add.

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
1. **No panic.** The composer never unwinds (no byte-offset panic on multibyte `WORKSPACE`
   or `OBJECTID`; same class as VP-578-005).
2. **Total classification.** The composer returns **either** a valid, well-formed Assets
   object-reference `serde_json::Value` (always the `[{workspaceId,id,objectId}]` array
   shape, all three keys present, all string-typed) **or** a clean `Err(UserError)` (exit 64)
   — **never** a partially-built or structurally-invalid JSON body that would reach Jira and
   produce an opaque 400. Malformed shapes per BC-3.4.030 / BC-3.4.031 EC-2/EC-3 (empty segment
   `W:`/`:Y`, extra colon `W:Y:Z`, non-numeric/empty `objectId`) → clean exit 64 before any HTTP.
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
3. **Empty value** — `--field cf:id=` / `cf:name=` / `cf:asset=` (kind requires a value) →
   exit 64. (Note: bare `NAME=` empty value stays **allowed** per the existing
   `prop_parse_field_kv_empty_value_allowed` — the empty-value rejection is **kind-scoped**,
   not universal; F4 must not regress the bare-form allowance.)
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

**Recommended strategy**:
```rust
// proptest (create.rs): a generated malformed hint always Err, never panic, never Ok
fn prop_malformed_hint_is_clean_err(
    name in "[a-z]{1,10}",
    bad  in prop_oneof![Just(":"), Just(":frob"), Just(":id"), Just(":asset")],  // e.g. empty val
) {
    let pair = format!("{name}{bad}=");   // empty value on a kind that requires one
    prop_assert!(parse_field_kv(&[pair]).is_err());
}
```
Plus an explicit **table-driven unit test** enumerating each EC-3.4.031-N shape → asserted
exit code 64 and a substring of the expected message (the durable, human-reviewable catalog).

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
  fn prop_normalize_from_valid_values_never_panics(items in prop::collection::vec(arb_json_value(), 0..8)) {
      let _ = normalize_from_valid_values(&items);   // total, no panic, for any JSON items (M3)
  }
  fn prop_normalize_from_allowed_values_never_panics(items in prop::collection::vec(arb_allowed_value(), 0..8)) {
      let _ = normalize_from_allowed_values(&items); // total, no panic, incl. GDPR-absent items (M1/M2)
  }
  ```
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
HTTP**; `--type` additionally **requires** its `--project` companion (M2 createmeta path), so
`--type` without `--project` → exit 64. **This is a genuinely NEW inline VP** — F5 pass-1 found
Invariant 1 had no VP. It was **added to the BC-X.14.001 body this pass** (§5). *(Former delta
label VP-580-040 — retired in favor of this sequence-extending inline id.)* **The arity is defined
over the three MODE-SELECTOR booleans only** — the earlier "`--project`+`--type` are one paired
mechanism among three" framing is superseded here to match ADR-0019 §1 and BC-X.14.001/004 (the
architect/PO are updating those in parallel this pass): `--project` counts as a companion in **no**
mode-selector tally, and `--project --request-type` is a **valid** M3 form, **not** an arity error.

**Property statement** — over the 2^4 space of `(has_type, has_request_type, has_issue,
has_project)` presence:
1. **Exactly one MODE-SELECTOR accepted.** The mode is chosen by precisely one of the three
   MODE-SELECTORS `{has_type, has_request_type, has_issue}`. Exactly one present → the guard
   passes to resolution (subject to the companion rule in (2)); `has_project` is **never counted**
   toward this tally.
2. **`--project` companion role (explicit).** `has_project` is a companion, not a mode selector:
   - **M2 (`--type`) REQUIRES `--project`.** `has_type && !has_project` → exit 64 (createmeta
     needs both). `has_type && has_project` is the well-formed M2 pair.
   - **M3 (`--request-type`) PERMITS `--project` OPTIONALLY.** `--request-type` alone is valid
     (profile-default project fallback); **`--project --request-type` is VALID and does NOT trip
     an arity error** — `--project` here merely names the service-desk project.
   - **`--issue`** carries its own project; `--project` alongside it is an unconstrained companion.
   - **`--project` alone (no mode selector) → exit 64** — it selects no mode (falls under (3),
     zero mode selectors), never a mode on its own.
3. **Zero mode selectors rejected.** No MODE-SELECTOR present (regardless of `--project`) → exit 64
   with a message naming the three modes.
4. **Two+ mode selectors rejected.** Any two or three of `{--type, --request-type, --issue}`
   present simultaneously → exit 64 with a mutual-exclusion message listing the conflicting flags.
5. **Pre-HTTP.** Every rejection in (2)–(4) fires **before** any network call (assert no request is
   made on the rejection paths — protects the "one mode, enforced before any HTTP" contract). This
   is the analogue of DEC-188's pre-flight-before-HTTP placement / ADR-0014's dispatch-fork guard.

**Recommended strategy** — extract the arity decision into a **pure function** taking the
booleans (`has_type`, `has_request_type`, `has_issue`, `has_project`) → `Result<Context,
JrError>`, then proptest it exhaustively:
```rust
fn prop_field_options_context_arity(
    has_type in any::<bool>(), has_request_type in any::<bool>(),
    has_issue in any::<bool>(), has_project in any::<bool>(),
) {
    let r = resolve_field_context(has_type, has_request_type, has_issue, has_project);
    // MODE-SELECTORS only — --project is a companion, never counted here.
    let selectors = [has_type, has_request_type, has_issue]
        .iter().filter(|b| **b).count();
    let ok =
        selectors == 1                       // exactly one mode selector, and…
        && (!has_type || has_project);       // …M2 (--type) requires its --project companion
        // M3 (--request-type) permits --project optionally => no extra constraint;
        //   --project --request-type is VALID, not an arity error.
        // --issue: --project is an unconstrained companion.
        // --project alone => selectors == 0 => rejected below.
    if ok {
        prop_assert!(r.is_ok());
    } else {
        prop_assert!(r.is_err());            // 0 selectors, >1 selectors, or --type without --project
    }
}
```
Plus wiremock integration tests in `tests/field_options.rs` asserting **exit 64 + no HTTP
request fired** for the three rejection classes — **zero** mode selectors, **two+** mode
selectors, and **`--type` without `--project`** (the M2-companion-missing case) — plus a
positive assertion that **`--project --request-type` does NOT trip the guard** (it is valid M3);
the pre-HTTP guarantee cannot be shown by the pure test alone. **This positive
`--project --request-type → Ok` case is the realization of VP-580-009** — the BC-X.14.004
regression guard (adversary pass-20 M1 / ADR-0019 §1), see §1. Per-message-shape for each
taxonomy row is owned by inline VP-580-004.

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

**Recommended strategy**: extract the filter to a **pure function**
`filter_options(&[FieldOption], substr: &str) -> Vec<FieldOption>`; unit tests over a fixture
tree covering each rule above (including a cascading fixture for rules 2–3); one proptest
asserting totality (`filter_options` never panics, result length ≤ input length at top level) and
that `--value ""` / an absent filter is the identity. Wiremock integration in
`tests/field_options.rs` asserting exit 0 + empty table / `[]` on a zero-match run.

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

**Recommended strategy**: unit tests over the render function for a flat fixture and a cascading
fixture (assert column headers, child indentation, verbatim nested JSON); an integration test in
`tests/field_options.rs` capturing stdout and stderr **separately** to assert the Profile-2
(Read-only) ordinary-path zero-stderr success contract and the `render_json` routing
(pretty-printed, #526).

**Target**: render/print path in the new `jr field options` handler (`src/cli/field.rs`); unit
tests co-located; integration in `tests/field_options.rs` (new). **F6**: add handler file to
`examine_globs`.

---

## 3. Coverage of the task's five mandated properties

| Task item | VP(s) (canonical) | Covered |
|---|---|---|
| 1. Hint-splitter multibyte safety (BC-3.4.026) | VP-578-005 | ✅ no-panic + clean-exit-64 + VALUE byte round-trip + bare-form invariance |
| 2. Value-kind mapping correctness (BC-3.4.027–031) | VP-578-007/008/009/010/011 (correctness) + VP-578-013 (malformed → exit 64, one error/invocation) | ✅ per-kind JSON shape + cascading + `--priority` parity + malformed catalog |
| 3. Context mutual-exclusion (BC-X.14.001) | **VP-580-006** (new) | ✅ exactly-one MODE-SELECTOR `{--type,--request-type,--issue}` accepted; 0/2+ selectors and `--type` sans `--project` → exit 64; `--project` companion (M2 requires it, M3 optional, `--project --request-type` valid); pre-HTTP |
| 4. Graceful-degrade invariant (BC-X.14.004) | VP-580-005 | ✅ empty/absent options → exit 0; no panic on untyped `allowedValues.items` |
| 5. Assets-ref composer safety | VP-578-012 (safety) + VP-578-011 (correctness) | ✅ malformed `W:Y` → clean error, never malformed JSON body (sanitize-proptest parallel) |

Plus the two additional gap VPs F5 pass-1 required beyond the five above: **VP-580-007**
(`--value` filter, BC-X.14.002) and **VP-580-008** (output shape, BC-X.14.003).

---

## 4. F6 (formal hardening) hand-off — mutation-coverage obligations

Per the F1 BA mapping (§3) and the VP-576-001 precedent cited in CLAUDE.md, whichever pure
parser/composer/normalizer/filter functions land in F4 must be reachable by `cargo-mutants`.
Concretely, the state-manager / F4 implementer should ensure `.cargo/mutants.toml` `examine_globs`
covers:

- `src/cli/issue/create.rs` — **already present** (`parse_field_kv` hint extension,
  VP-578-005/013).
- `src/cli/issue/field_resolve.rs` — **ADD** (the value-kind emission dispatch, the cascading
  composer, the `:asset` composer — VP-578-007/008/009/010/011/012/013). This file is core to
  #578 and is **not currently** in the glob list — a key F6 addition of this cycle.
- The new `jr field options` handler file (`src/cli/field.rs` if F4 creates one) — **ADD at
  file-creation time**, per the S-576-1 / S-577-1 precedent ("new CLI handler file → add to
  mutants.toml at creation"). Covers the pure `normalize_from_allowed_values` /
  `normalize_from_valid_values` normalizers (VP-580-005), the
  context-arity guard (VP-580-006), the `filter_options` filter (VP-580-007), and the
  render/print shaping (VP-580-008) if any lives there.

`tests/mutants_glob_existence.rs` (the always-run guard) will fail loudly if a glob is added
for a file that doesn't yet exist, so the glob add must land in the **same** commit as the
new file.

**No PROVISIONAL markers remain.** ADR-0019 (Accepted 2026-08-25) confirmed the `>` cascading
delimiter (split-on-first, `:id=` escape hatch); VP-578-008's cascading assertions are therefore
firm and ship this cycle. The inline VP-578-008 PROVISIONAL marker in `bc-3-issue-write.md` was
cleared this pass (§5).

## 5. Index / registry + BC-body actions

**Registry**: None. No VP-NNN registry or verification ARCH-INDEX exists to update (§0). The
fourteen core VP guarantees (§1) are realized as **new** inline `proptest!`/unit/integration tests
at the cited locations in F4, and as `examine_globs` additions in F6; the remaining eight declared
#578 inline VPs (§1.1 — VP-578-001..004, 017..020) are realized by reuse of the VP-396-009
edit-path realizations transplanted to the create path, by the DEC-307 reversal's rewritten
holdout scenarios + `create.rs` guard-removal regression tests, and (VP-578-020) by new two-page
createmeta wiremock tests (**both** the FIELDS and ISSUE-TYPES createmeta endpoints) in
`tests/issue_create.rs`. The full declared inline inventory
this delta touches is **twenty-five** VPs (twenty #578 + VP-580-005..009). If the state-manager
later stands up the `S-PG-VP-REGISTRY-1` registry, these are its seed rows for the field-dx cycle.

**BC-body edits made this pass** (F5/F6 pass-1 fixes — the only durable home for these VP ids,
given the inline convention):
- `bc-3-issue-write.md` BC-3.4.027 → **VP-578-008 de-PROVISIONALized** (delimiter CONFIRMED per
  ADR-0019 §3). *(The cascading BEHAVIOR prose in the BC-3.4.027 body — description, EC-4 — is
  de-PROVISIONALized by the product-owner in parallel; this pass touched only the VP-578-008
  verification-property line.)*
- `cross-cutting.md` BC-X.14.001 → **VP-580-006 added** (mutual-exclusion Invariant 1 — the gap).
- `cross-cutting.md` BC-X.14.002 → **VP-580-007 added** (a new Verification Properties section —
  `--value` filter; the BC previously had none).
- `cross-cutting.md` BC-X.14.003 → **VP-580-008 added** (a new Verification Properties section —
  output shape; the BC previously had none).
- `bc-3-issue-write.md` BC-3.3.010 → **VP-578-020 added** inline (adversary pass-28 F-1 — createmeta-family
  offset-pagination: a `--field` target on the FIELDS createmeta page ≥2 **AND** a `--type` entry on the
  ISSUE-TYPES createmeta page ≥2 each resolve, not dropped). *(The VP-578-020 line and the reworded
  "paginates internally, at-most-once-per-invocation" createmeta postconditions — now covering both the
  `get_createmeta_fields` and `get_issue_types_for_project` endpoints — are added to the BC-3.3.010 body by
  the product-owner in parallel; this verification-delta only records the new VP id and its realization
  pointer — it does not touch any BC file.)*

These four BC-body edits, plus this reconciled delta, leave **exactly one authoritative VP id per
guarantee** and **zero PROVISIONAL markers** across the field-dx verification surface.
