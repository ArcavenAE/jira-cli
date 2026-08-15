---
document_type: f2-prd-delta
phase: phase-f2-spec-evolution
issues: [604, 605, 606, 608]
deferred: [607, 609]
producer: product-owner
timestamp: 2026-08-15
status: complete
decisions: [DEC-278, DEC-279, DEC-280]
---

# F2 PRD Delta — Component Management Bundle (issues #604/#605/#606/#608)

`jr component` command family (#604), `issue create/edit --component` (#605), `issue list
--component` filter (#606), `jr component rename` (#608). #607 (generalized multi-valued/
negatable filter grammar retrofit) and #609 (cross-issue component impact scan) are explicitly
OUT of scope for this cycle — deferred to subsystem-level follow-up per DEC-278 and the F1
delta analysis (`.factory/phase-f1-delta-analysis/delta-analysis-components.md`).

This is a RECONCILIATION/COMPLETION record: the BC bodies below were authored in a prior burst
that died on a transient API error after writing all BC content but before finishing count
propagation and this summary. This document was produced during the completion burst; no BC
body content was rewritten — only count-propagation surfaces and this summary were completed.

---

## Summary

- **28 new BCs** in a brand-new file `bc-8-components.md` (BC-8.1.001..008, BC-8.2.001..008,
  BC-8.3.001..007, BC-8.4.001..005).
- **6 new BCs** in `bc-2-issue-read.md` (BC-2.1.018..022, BC-2.3.040).
- **4 new BCs** in `bc-3-issue-write.md` (BC-3.4.022..025).
- **38 new BCs total.** Grand total 661 → 699 (verified: `scripts/check-spec-counts.sh` and
  `scripts/check-bc-cumulative-counts.sh` both exit 0 post-burst).
- **7 BCs amended in place** (no separate count): BC-2.1.006, BC-2.1.007 (bc-2); BC-3.4.012,
  BC-3.4.013, BC-3.4.017, BC-3.4.020, BC-3.4.021 (bc-3).
- **1 cross-file citation amendment** (no count change): cross-cutting.md BC-X.10.001 gains a
  caller citation for the new `resolve_component` resolver.
- **0 new holdout scenarios in this burst** — holdout authoring for the component bundle is
  deferred to the F2 continuation / F3 gate per the standard ASM/R + FM-NNN consumption
  obligations; not yet performed as part of this reconciliation.

---

## New BCs — bc-8-components.md (28, all NEW)

### 8.1 Component Read & CRUD (8)
| BC ID | One-line summary |
|---|---|
| BC-8.1.001 | `jr component list [--project KEY]` GETs `/rest/api/3/project/{key}/components` (assumed non-paginated, pending F4); table columns ID/Name/Description/Lead/Assignee Type |
| BC-8.1.002 | `jr component list --output json` returns full component objects, all fields, via `output::render_json` |
| BC-8.1.003 | `--counts` enriches via N+1 `relatedIssueCounts` GETs; fail-soft per component |
| BC-8.1.004 | No `--project` and no configured project → exit 64 before any HTTP, for `list`/`edit`/`delete` ONLY **[UPDATED 2026-08-15, P7 fix-burst — resolves MEDIUM-2 found by adversarial spec-delta review pass 7: `rename` fully excluded in EITHER form (not just `--all-projects`) — the P6 BC-body fix-burst removed `rename --project` from BC-8.1.004's own scope entirely, and this summary row was never re-synced; rename's no-scope guard (either form) is owned wholly by BC-8.3.005. Supersedes the H2 wording below.]** **[Previous, superseded 2026-08-15, H2 fix-burst: "...for `list`/`edit`/`delete`/`rename --project`... excludes `create` (clap-required `--project`, BC-8.1.005) and `rename --all-projects` (project-less by design, BC-8.3.002/005)" — still listed `rename --project` as a fourth covered form; wrong per P6's BC-8.1.004 rewrite.]** |
| BC-8.1.005 | `jr component create --project KEY NAME [...]` POSTs `/rest/api/3/component` |
| BC-8.1.006 | `--lead <NAME>` resolves to `accountId` via assignable-user search; ambiguous/no-match aborts before mutating HTTP |
| BC-8.1.007 | `jr component edit NAME\|ID [...]` PUTs `/rest/api/3/component/{id}`; only supplied fields sent |
| BC-8.1.008 | Unknown `NAME\|ID` on edit/delete/rename → exit 64; numeric-bypass convention (mirrors `requesttype fields`) |

### 8.2 Component Delete Safety (8) — DEC-279
| BC ID | One-line summary |
|---|---|
| BC-8.2.001 | `delete` refuses (exit 64) without EITHER `--move-to` OR `--orphan`; clap mutually exclusive |
| BC-8.2.002 | `--move-to <NAME\|ID>` DELETEs with `moveIssuesTo=<targetId>`; target resolves BEFORE the DELETE |
| BC-8.2.003 | `--move-to` target resolution is scoped to the SAME project as the component being deleted |
| BC-8.2.004 | `--move-to` target ambiguous/unknown → exit 64 before DELETE (§8.4 instantiation) |
| BC-8.2.005 | `--move-to <SELF>` → exit 64 pre-flight, zero HTTP (ID-equality check) |
| BC-8.2.006 | `--orphan` requires `--yes` (non-interactive) or interactive TTY confirm naming affected-issue count |
| BC-8.2.007 | Affected issue keys snapshotted via JQL `component = <id>` BEFORE the DELETE (both dispositions) |
| BC-8.2.008 | `--output json` delete result shape; source-not-found is NOT idempotent; concurrent-delete race → `ApiError(404)` exit 1 |

### 8.3 Component Rename (7) — issue #608
| BC ID | One-line summary |
|---|---|
| BC-8.3.001 | `rename OLD NEW --project KEY` resolves `OLD` scoped to project, PUTs `{"name": NEW}` |
| BC-8.3.002 | `--all-projects` fans out via per-project component-list discovery, O(N) HTTP; matches via EXACT case-insensitive equality (not §8.4 `partial_match`); numeric `OLD` rejected exit 64 **[UPDATED 2026-08-15, H4 fix-burst: matching-semantics divergence + numeric-OLD rejection made explicit]** |
| BC-8.3.003 | `--all-projects` fan-out is per-project atomic; fail-soft; exit 1 on any partial failure |
| BC-8.3.004 | `--dry-run` previews with ZERO mutating HTTP, same project-discovery logic as live run |
| BC-8.3.005 | Neither `--project` nor `--all-projects` → exit 64 (ambiguous scope) |
| BC-8.3.006 | Case-only rename is legitimate; resolver MUST NOT short-circuit as no-op |
| BC-8.3.007 | `NEW` name collision → Jira 400 surfaced verbatim, not pre-validated client-side |

### 8.4 Component Name/ID Resolution & Disambiguation (5)
| BC ID | One-line summary |
|---|---|
| BC-8.4.001 | `resolve_component` — numeric-ID short-circuit; non-digit resolves via project-scoped `partial_match` |
| BC-8.4.002 | Unknown component name (zero matches) → exit 64 listing valid names for the resolved project scope |
| BC-8.4.003 | Ambiguous component name (2+ matches) → exit 64 listing candidates |
| BC-8.4.004 | Resolution is ALWAYS single-project-scoped — cross-project same-named component never silently matches |
| BC-8.4.005 | Client-side resolver case-insensitivity agrees with JQL's case-insensitive component matching |

---

## New BCs — bc-2-issue-read.md (6, all NEW)

| BC ID | One-line summary |
|---|---|
| BC-2.1.018 | `--component <NAME>` (repeated) → OR-combined `component in (id1, id2, ...)` |
| BC-2.1.019 | `--component not:<NAME>` → `(component not in (id) OR component is EMPTY)` |
| BC-2.1.020 | `--component none` (reserved keyword) → `component is EMPTY`, zero resolver HTTP |
| BC-2.1.021 | `--component all:<N1>,<N2>` → AND-combined `component = id1 AND component = id2` |
| BC-2.1.022 | Unresolvable/ambiguous `--component` → exit 64 BEFORE any JQL search fires |
| BC-2.3.040 | `Component` struct gains `id: Option<String>` field (shared prerequisite for all 4 issues) **[UPDATED 2026-08-15, M8 fix-burst: was `id: String` REQUIRED/BREAKING; relaxed to `Option<String>` to avoid a single absent-id component hard-failing `issue view`/`issue list` deserialization for the WHOLE issue — see BC-2.3.040 Description for full rationale. The full resource type, `types/jira/component.rs`, used by `jr component`/§8.4, is UNCHANGED and keeps `id` required.]** |

## New BCs — bc-3-issue-write.md (4, all NEW)

| BC ID | One-line summary |
|---|---|
| BC-3.4.022 | Single-key `issue edit --component add:X/remove:Y` — native `update`-verb PUT, object operations; editmeta-gated read-modify-write fallback |
| BC-3.4.023 | Multi-key/bulk `--component` — `POST /bulk/issues/fields` with `multiselectComponents`/integer `componentId`; two sequential POSTs for mixed add:/remove: |
| BC-3.4.024 | `issue create --component X --component Y` (bare, no prefix) — additive `fields.components` array on create POST |
| BC-3.4.025 | Resolution-mechanism decision: project component-list GET (not editmeta) for name validation on create/list; editmeta separately gated for edit's wire-shape decision |

---

## Modified BCs (old → new, UPDATED rationale)

| BC ID | File | Change | Rationale |
|---|---|---|---|
| BC-2.1.006 | bc-2 | Filter-source count 13 → 14 | `--component` added to the enumerated stderr no-filters guard list |
| BC-2.1.007 | bc-2 | Stable clause-order list gains `component` | Positioned after `asset`, before date-range clauses — pinned exact-order test discipline |
| BC-3.4.012 | bc-3 | `components` joins the table-mode field-echo key table | Comma-joined `action:name` pairs; `--component` stays on single-key `handle_edit` path (unlike `--label`) |
| BC-3.4.013 | bc-3 | `components` joins the JSON-mode `changed_fields` key table | Comma-joined `add:name`/`remove:name` string, identical format to the BC-3.4.012 table echo **[UPDATED 2026-08-15, H1 fix-burst: was "JSON array of `{action,name}` objects — sole array-valued `changed_fields` entry", which was structurally incompatible with the shared `BTreeMap<String, String>` model BC-3.4.012's own Postconditions require — corrected to a plain string, closing the "sole exception to all values are JSON strings" gap.]** |
| BC-3.4.017 | bc-3 | Gate B scope extended 4 → 5 fields | `components` joins `summary`/`description`/`issuetype`/`priority` as a first-party static flag-overlap field; EC-3.4.017-15 added |
| BC-3.4.020 | bc-3 | `--label` conflict-block flag list extended 12 → 13 | `--component` added to prevent silent-drop data loss (FIX-F5-001 hazard class) when combined with `--label` on a single key |
| BC-3.4.021 | bc-3 | `plannedChanges.components` dry-run preview added | Flat array, same convention as `labels`; EC-3.4.021-20 added |
| BC-X.10.001 | cross-cutting.md | Caller citation added (EC-1 example list + Trace) for `src/cli/issue/helpers.rs::resolve_component` | Citation-only; the shared `partial_match` primitive's own contract is unchanged; component-specific caller contract owned by bc-8-components.md §8.4 |

No BC was retired, renumbered, or replaced in this delta. All numbering is append-only per the
`append_only_numbering` policy.

---

## Resolver Placement Decision (§8.4 + cross-cutting X.10.001)

**Decision**: The shared, reusable `partial_match` PRIMITIVE remains documented exactly once,
in `cross-cutting.md` BC-X.10.001 (no behavioral change to that primitive). The
COMPONENT-SPECIFIC caller contract — numeric-ID bypass convention, project-scoping rules,
disambiguation error-message shapes — is owned by a NEW subsection, `bc-8-components.md` §8.4
(BC-8.4.001..005), rather than being inlined a second time into cross-cutting.md or duplicated
across bc-2/bc-3.

**Rationale**: This mirrors the split already established between `bc-2-issue-read.md`'s
status-disambiguation BCs (BC-2.1.013/014, local caller contracts) and `cross-cutting.md §X.10`
(the shared resolver) — precedent, not a new pattern. `resolve_component` is a genuinely new
caller of `partial_match` (alongside the existing `resolve_queue_by_name`, `issue/workflow.rs`
status resolution, and `requesttype.rs` RT-name resolution), so BC-X.10.001's EC-1 caller-list
and Trace field are AMENDED (not replaced) to cite it — closing the citation gap the prior
crashed burst left open. bc-2's `--component` filter (§2.1) and bc-3's `--component` write path
(§3.4) both consume `bc-8-components.md` §8.4's resolver contracts rather than re-deriving
resolution semantics locally — a single owning location for the numeric-bypass /
project-scoping / disambiguation-message contract, consumed by three call sites (`issue list`,
`issue create`, `issue edit`) plus `jr component`'s own edit/delete/rename commands.

**Consequence for implementation (F4)**: `src/cli/issue/helpers.rs::resolve_component` is the
single resolver function all six consuming call sites route through — no duplicated
resolution logic per call site.

---

## Error Taxonomy / Exit-Code Mapping

| Condition | Exit code | Error type | Owning BC |
|---|---|---|---|
| No `--project` / no configured project on `list`/`edit`/`delete` **[CORRECTED 2026-08-15, P7 fix-burst — resolves MEDIUM-2 found by adversarial spec-delta review pass 7: row narrowed from "any `jr component` subcommand" to the three single-project subcommands this guard actually governs — `create`'s no-`--project` case and `rename`'s no-scope case are each split into their own row below, since neither routes through BC-8.1.004's exit-64 logic]** | 64 | `JrError::UserError` | BC-8.1.004 |
| No `--project` on `create` **[NEW 2026-08-15, P7 fix-burst]** | 2 | clap (missing required argument, not a `JrError`) | BC-8.1.005 |
| Unknown component `NAME\|ID` (edit/delete/rename `OLD`/`--move-to`) | 64 | `JrError::UserError` | BC-8.1.008, BC-8.4.002 |
| Ambiguous component name (2+ matches) | 64 | `JrError::UserError` | BC-8.4.003 |
| `component delete` without `--move-to`/`--orphan` | 64 | `JrError::UserError` | BC-8.2.001 |
| `--move-to`/`--orphan` both supplied | 2 | clap conflict | BC-8.2.001 |
| `--move-to` target out-of-project or self-reference | 64 | `JrError::UserError` | BC-8.2.003, BC-8.2.005 |
| `--orphan` non-interactive without `--yes` | 64 | `JrError::UserError` | BC-8.2.006 |
| Snapshot JQL search fails before delete (genuine 5xx/network fetch error) | fail-closed, aborts before DELETE | `JrError::ApiError`/`JrError::NetworkError` (propagated verbatim from the read-only JQL search call — **[UPDATED 2026-08-15, L4 fix-burst]** no new variant introduced; exit code is whatever the propagated error's own `exit_code()` yields, typically 1) | BC-8.2.007 |
| Snapshot JQL search aborts on JRACLOUD-95368 anti-loop drift (partial `has_more=true`, NOT an `Err`) **[NEW 2026-08-15, pass-10 fix-burst — resolves INFO-1 found by adversarial spec-delta review pass 10]** **[CORRECTED 2026-08-15, pass-14 fix-burst — resolves an exit-code miscategorization found by adversarial spec-delta review pass 14]** | fail-closed, aborts before DELETE | exit 1, synthesized via a NEW, purpose-built `JrError` variant (to be added at F4 — e.g. `JrError::SnapshotIncomplete`, falling to the same exit-code default (`_ => 1`) as `ApiError`/`NetworkError`/`Internal`) carrying the message ("could not reliably enumerate affected issues — aborting delete") — distinct from the row above: this is an application-level error `component delete` itself synthesizes on detecting a successful-but-partial pagination result, not a propagated `ApiError`/`NetworkError`. **Previous version (superseded, retained for audit trail):** "synthesized `JrError::UserError`-shaped message" — `JrError::UserError` exits 64, not 1, contradicting this row's own "exit 1" column; `JrError::Internal` is also unsuitable (reserved for "should never happen" bugs, not an expected external drift condition) | BC-8.2.007 Postcondition 5 |
| `component delete` DELETE itself 404s (concurrent race) | 1 | `JrError::ApiError(404)` | BC-8.2.008 |
| `component create`/`edit`/`rename` name collision (server-side) | 1 | `JrError::ApiError(400)` | BC-8.1.005, BC-8.1.007, BC-8.3.007 |
| `rename` without `--project`/`--all-projects` | 64 | `JrError::UserError` | BC-8.3.005 |
| `rename --project`/`--all-projects` both supplied | 2 | clap conflict **[NEW 2026-08-15, H2 fix-burst — companion row for BC-8.3.005's corrected exit-code-class split]** | BC-8.3.005 |
| `rename --all-projects` partial failure | 1 | **[UPDATED 2026-08-15, L4 fix-burst]** manual `exit(1)` — NOT a `JrError` variant; computed directly from the per-project outcome array (`failed.is_empty()` → 0, else → 1), per BC-8.3.003 Postcondition 2 | BC-8.3.003 |
| `--lead` ambiguous/no-match | 64 | `JrError::UserError` | BC-8.1.006 |
| `component create --lead ""` (empty string, no lead to clear) | 64 | `JrError::UserError` **[NEW 2026-08-15, H2 fix-burst — app-level guard, corrected from a false "clap level" attribution]** | BC-8.1.006 |
| `component create --assignee-type` out-of-enum value | 2 | clap `ValueEnum` conflict **[CORRECTED 2026-08-15, H2 fix-burst — was listed as 64]** | BC-8.1.005 |
| `issue list --component` unresolvable/ambiguous | 64 | `JrError::UserError` | BC-2.1.022 |
| `issue list --component none` combined with other `--component` | 64 | `JrError::UserError` | BC-2.1.020 |
| `issue list --component all:` repeated or mixed with bare/not:/none | 64 | `JrError::UserError` | BC-2.1.021 |
| `issue create/edit --component` unresolvable/ambiguous | 64 | `JrError::UserError` | BC-3.4.025, BC-8.4.002/003 |
| `issue create --component` combined with `--request-type` **[NEW 2026-08-15, pass-14 fix-burst — resolves LOW-2 found by adversarial spec-delta review pass 14]** | 64 | `JrError::UserError` | BC-3.4.024 |
| `issue edit --component` + multi-project bulk keys | 64 | `JrError::UserError` | BC-3.4.023 EC-3.4.023-1 **[CORRECTED 2026-08-15, L2 fix-burst — was the shorthand "EC-1", which doesn't match this file's `EC-S.SS.NNN-N` citation convention]** |
| `issue edit --field components=...` combined with `--component` (Gate B) | 64 | `JrError::UserError` | BC-3.4.017 |
| `issue edit --label` combined with `--component` (conflict block) | 64 | `JrError::UserError` | BC-3.4.020 |

All new error paths follow the universal actionable-error convention (CLAUDE.md: every error
suggests a next step) and the existing `JrError::exit_code()` mapping — no new exit codes were
introduced by this bundle.

---

## Edge Cases (highlights; full catalogs live in each BC's own Edge Cases section)

- EC-8.1.008-2 / numeric-bypass gap: a component literally named `"100"` is unreachable by
  name through the `NAME|ID` positional (mirrors the documented `requesttype fields`
  limitation) — look it up by id via `jr component list --output json | jq`.
- EC-8.2.003-1/2: cross-project `--move-to` name collisions never resolve outside the source
  component's own project, even when the numeric id belongs to another project.
- EC-8.2.006-2: `--orphan` on a component with zero affected issues still shows the
  confirmation prompt (deletion of the component itself is still permanent).
- EC-8.3.006-1: `rename Backend backend` is NOT a no-op — the PUT fires with the new casing.
- EC-2.1.018-1: a single `--component X` composes `component in (X)`, not `component = X`.
- EC-2.1.019-1: multiple `not:` values combine within ONE parenthesized OR-EMPTY group, not
  one clause per value.
- EC-3.4.022-2: bare `--component Backend` (no prefix) on `edit` is treated as ADD.
- EC-3.4.024-2: `create --component add:Backend` sends the LITERAL string `"add:Backend"` as
  the component name (prefix grammar is `edit`-only, not special-cased on `create`).
- EC-3.4.023-2: `--component add:X --component remove:Y` on 2+ keys issues TWO sequential bulk
  POSTs (ADD then REMOVE) — a deliberate divergence from the label bulk path's single-POST
  coalescing, forced by the `multiselectComponents` schema being a single object.

---

## DEC-279 / DEC-280 Linkage

- **DEC-279 (delete-safety policy)**: layered guardrails — refuse `component delete` without
  `--move-to`/`--orphan`; `--orphan` additionally requires `--yes`/interactive confirm;
  affected issue keys snapshotted via read-only JQL BEFORE the DELETE. Implemented across
  BC-8.2.001..008. Source: `.factory/research/component-delete-and-bulk-wire-2026-08-15.md`
  §Q1 (delete-safety facts CONFIRMED/INCONCLUSIVE per sub-question).
- **DEC-280 (bulk wire shape)**: the multi-key `--component` bulk-edit wire shape
  (`multiselectComponents` object + integer `componentId`, ADD/REMOVE/REPLACE/REMOVE_ALL) is
  CONFIRMED via triple corroboration (Atlassian doc example + swagger OpenAPI + apidog
  mirror) but has NOT been validated against a live Jira run at spec-authoring time.
  Implemented in BC-3.4.023, with an explicit delivery note gating F4 shipping behind a live
  smoke test (one ADD, one REMOVE against ≥2 issues in one project) before
  release, per the `FIX-BULK-TRANSITION-001`/#446 precedent — if the live run contradicts the
  documented shape, BC-3.4.023 must be corrected to the observed true shape, exactly as
  `FIX-BULK-TRANSITION-001` did for bulk transitions. DEC-280 also governs BC-3.4.022's
  single-key native `update`-verb shape (object-form `add`/`remove`, distinct from the bulk
  integer-id form) and BC-3.4.024's create-path additive body composition (object-with-name
  form, matching the single-key convention).
- **DEC-278**: cycle-open decision recording F1 approval, scope (#604/#605/#606/#608 in;
  #607/#609 deferred), and the 4-wave sequence (W1 #604 foundation → W2 #605 → W3 #606
  parallelizable with W2 → W4 #608 last). Referenced for context; not itself a spec-content
  decision requiring BC-level linkage.

---

## Count Propagation (verified)

- `bash scripts/check-spec-counts.sh` → `Check passed: 8 bc files validated`
- `bash scripts/check-bc-cumulative-counts.sh` → `OK: all cumulative BC counts verified (699 total across 9 files; Surface H footer checked where present).`

Surfaces updated: bc-8-components.md frontmatter (new file); BC-INDEX.md frontmatter
`total_bcs`/`index_version`/trace, `sections:` list, new `## Section 8` with 8.1-8.4 subsection
tables (28 rows), Section 2/3 header counts + BC-2.1.006/007/BC-2.1.018-022/BC-2.3.040 rows,
Section 3.4 header count + BC-3.4.012/013/017/020/021/BC-3.4.022-025 rows, Section X header
note; CANONICAL-COUNTS.md frontmatter `last_verified`, per-file definitional-count table,
per-file total_bcs table + Sum row, grand-total prose + breakdown note, L2-alignment table
(bc-02/bc-03 rows marked PENDING — L2 not bumped, F2 touched L3 only), Bounded-contexts row;
README.md Document Map (bc-2/bc-3 counts, new bc-8 row, BC-INDEX total, Total-BCs prose,
BC-numbering-scheme S range 1-7→1-8).

---

## Anchor-Back / Handoff Notes

- **No existing stories reference component-related BCs** — this is a Feature Mode cycle at
  the F2 (spec evolution) gate; story decomposition (F3) has not yet run for this bundle. The
  `bc_array_changes_propagate_to_body_and_acs` anchor-back obligation therefore does not apply
  yet — there are no story files with stale `bcs:` arrays to update. Story-writer's F3 pass
  will consume this delta directly when it runs.
- **VP citations**: no VP-INDEX/verification-architecture entries exist yet for this bundle
  (VP-COMPONENT-001..028 **[CORRECTED 2026-08-15, P8 fix-burst — range was stale at
  001..026]** — range extended 2026-08-15 by the adversarial spec-delta review pass-1
  fix-burst: VP-COMPONENT-021 split out of a duplicate VP-COMPONENT-014 definition [M4],
  VP-COMPONENT-022/023/024 newly minted for previously-unpinned BC-8.1.005/BC-8.1.007/
  BC-8.2.008 [M10]; VP-COMPONENT-025/026 minted in a later spec-tightening burst closing
  residuals R-2/R-3 (BC-3.4.024/025's `issue create --component` body composition +
  BC-8.3.002's `--all-projects` numeric-`OLD` rejection, respectively — see
  `verification-delta-components.md` §1.3); VP-COMPONENT-027/028 minted in the pass-7
  adversarial fix-burst (MEDIUM-3) — VP-027 pins BC-3.4.020's `--label`+`--component`
  mutual-exclusion exit-64 guard (FIX-F5-001 silent-data-loss prevention), VP-028 pins
  BC-3.4.021's dry-run `plannedChanges.components` flat-array shape — are cited inline in the
  BC bodies as forward-looking IDs, not yet
  registered in a verification-properties index). Architect's F2/F3 pass must register these
  under `vp_index_is_vp_catalog_source_of_truth` when verification architecture work begins
  for this cycle. **VP citation changes**: BC-8.4.001 (VP-COMPONENT-014 clarified as sole
  owner), BC-8.4.005 (VP-COMPONENT-014 → VP-COMPONENT-021), BC-8.1.005/BC-8.1.007/BC-8.2.008
  (new VP-COMPONENT-022/023/024), BC-3.4.020 (new VP-COMPONENT-027), BC-3.4.021 (new
  VP-COMPONENT-028), BC-8.1.007 (P5 fix-burst — VP-COMPONENT-004/024 EXTENDED to this BC's M1
  numeric-source project-derivation mechanism), BC-8.3.001 (P5 fix-burst — VP-COMPONENT-004/024
  EXTENDED to this BC's own M1 numeric-`OLD` mechanism), BC-3.4.017 (P7 fix-burst — VP-396-005,
  the pre-existing base non-`VP-COMPONENT-*` property, explicitly cited for this BC's Gate B
  `components` extension) — flagged per `vp_index_is_vp_catalog_source_of_truth` for
  architect to propagate to VP-INDEX/verification-architecture.md/verification-coverage-
  matrix.md once that work begins.
- **ADR**: STATE.md flags one recommended ADR covering resolution/caching/delete-safety/
  wire-shape as a single decision (F1 obligation, not yet authored — out of scope for this
  product-owner reconciliation burst; architect-owned).
