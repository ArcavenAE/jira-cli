---
document_type: f2-prd-delta
phase: phase-f2-spec-evolution
cycle: field-dx
issues: [580, 578]
producer: product-owner
timestamp: 2026-08-25
status: complete
inputs:
  - .factory/phase-f1-delta-analysis/delta-analysis-field-dx.md
  - .factory/phase-f1-delta-analysis/field-dx-bc-mapping.md
  - .factory/research/field-dx-feasibility-2026-08-25.md
  - .factory/research/field-dx-context-mechanism-2026-08-25.md
input-hash: "12e3ede"
---

# F2 PRD Delta — Field DX Bundle (issues #580, #578)

**Filename note**: the orchestrator's task requested this file be written to
`.factory/phase-f2-spec-evolution/prd-delta.md`. That exact filename already holds unrelated,
historical content from the issue #288 (JSM request-type) F2 delta (2026-05-18) — overwriting it
would destroy prior-cycle history. Per this directory's own established convention (every other
cycle uses a suffixed filename — `prd-delta-components.md`, `prd-delta-bucket1-defects.md`,
`prd-delta-DEAD-CITATION-CI.md`, etc.), this delta is written to
**`prd-delta-field-dx.md`** instead. Flagged here for the orchestrator/state-manager.

## Summary

**12 new BCs minted**: BC-3.3.010..011 (2, `bc-3-issue-write.md` §3.3) + BC-3.4.026..031 (6,
`bc-3-issue-write.md` §3.4) + BC-X.14.001..004 (4, `cross-cutting.md`, new §X.14 subsection).

**9 existing BCs amended in place** (no count change): BC-3.3.001, BC-3.4.014 (DEC-188-qualifier
body amended: `--field` echo-suppression removed per DEC-310 reversal; `--on-behalf-of`
suppression retained), BC-3.4.015, BC-3.4.016, BC-3.4.017 (**[AMENDED 2026-08-25 issue #578 F2,
adversary pass-13 F-1]** Gate B's flag-overlap matching extended to hint-tagged `--field
NAME:kind=VALUE` pairs, closing a contradiction with BC-3.4.029 EC-3.4.029-2 — new
EC-3.4.017-16), BC-3.8.001, BC-3.8.008 (interaction/amendment notes), BC-3.8.013 (amended in
place — body propagation of combined-guard removal; guard BEHAVIOR unchanged), and
**BC-3.8.012 (full reversal)**.

**1 governance flag raised**: BC-3.8.012's reversal of DEC-188 (a deliberate breaking change
shipped ~1 month prior, 2026-07-25) requires its own formal decision entry. **Proposed ID:
DEC-310** (next sequential after the highest DEC number found across the ENTIRE `.factory/`
tree, DEC-309, per a `grep -rohE "DEC-[0-9]{3}" .factory/` survey run during the F2
adversary-convergence pass, 2026-08-26). This repo has no centralized DEC registry file — DEC
numbers are assigned inline in spec prose by convention — so DEC-310 is a **proposal**, not yet
a registered decision. **Correction (F2 adversary-convergence pass, C-M1):** this entry
originally proposed **DEC-307**, computed from a `.factory/specs/`-only grep whose reported
maximum (DEC-306) undercounted the repo: `cycle-001` (`list-read-ergonomics`)'s F5/F7 closure
had already allocated DEC-306 through DEC-309 (recorded in `.factory/cycles/cycle-001/` and
`STATE.md`, outside `specs/`), so DEC-307 was already a REGISTERED decision (that cycle's F5
combined-delta fix), not an available number — the proposal collided rather than merely being
imprecise. Re-running the "next sequential after the highest" rule against the correct
full-`.factory/`-tree maximum (DEC-309) yields DEC-310. **Open namespace question, flagged not
resolved here:** spec-level DECs (188, 306, 307, 310) and cycle-gate DECs (e.g. 309) currently
share one undifferentiated `DEC-NNN` prefix — whether that should remain one sequence or split
into two disambiguated series is unresolved; flagged for cycle close, not decided by this pass.
The orchestrator/state-manager should register DEC-310 formally and must not let a future pass
silently reuse DEC-310 (or DEC-307, already taken by `cycle-001`) for an unrelated decision.

**BC-INDEX.md and CANONICAL-COUNTS.md updated**: total_bcs 707 → 719; bc-3-issue-write.md
115 → 123 individually-bodied (144 → 152 cumulative); cross-cutting.md 85 → 89
individually-bodied (151 → 155 cumulative). BC-INDEX v6.81 → v6.82.

**Edge Case Catalog**: no changes to the legacy `edge-case-catalog.md` file — that file's
EC-AUTH/EC-CFG/EC-HTTP/EC-JQL/EC-ASSET/EC-SPRINT/EC-OUT/EC-GAP taxonomy is Pass-3-era and has
not been the target of edge-case additions for any BC minted since #396 (2026-05-22) forward —
every BC touched or added in this delta follows the now-standard convention of embedding its
edge cases directly in the BC body (`EC-3.3.010-N`, `EC-3.4.03N-N`, `EC-X.14.00N-N`), consistent
with BC-3.4.015/016's precedent. This is a deliberate scope decision, not an oversight.

**Update (adversary pass-8 M-1 correction): this PO pass's original prediction below is
superseded.** At authoring time this pass predicted "no architecture delta, no
verification-property-extension delta as separate files" — per the F1 architect's own verdict
("No structural/interface redesign, no new subsystem") and this repo's VP-registry convention
(property-style guarantees documented inline per-BC as `VP-578-NNN`/`VP-580-NNN`, following the
`prop_field_hint_split_no_panic` / FIX-F6-LRE-1 precedent the architect flagged). The architect
subsequently produced `ADR-0019` + `.factory/phase-f2-spec-evolution/architecture-delta-field-dx.md`
(the cascading-delimiter and `FieldValueSpec` shape decisions cited throughout this document's
"Resolved during this pass" section above are ADR-0019's), and the verifier produced
`.factory/phase-f2-spec-evolution/verification-delta-field-dx.md` — both are cited in this
document's "Resolved" section. The PO's initial "no separate delta files needed" prediction did
not anticipate this; it is superseded, not this document's account of what actually shipped.
The one sub-claim that remains accurate, narrowed to exactly the file it was about: no
`.factory/specs/verification-architecture/ARCH-INDEX.md` VP-registry file was updated or created
by this pass (this repo does not maintain a VP-registry file in the form the generic F2 skill
describes — confirmed absent from `.factory/specs/`; new VPs remain inline per-BC as noted
above). That absence is specific to `ARCH-INDEX.md` and does not extend to the architecture or
verification delta files themselves, which do exist.

---

## New BCs — grouped by story

### Story #580 (`jr field options <field>`) — new Cross-Cutting §X.14

File: `.factory/specs/prd/cross-cutting.md`

| BC ID | One-line summary |
|---|---|
| BC-X.14.001 | `jr field options <field> (--project <P> --type <T> \| --request-type <RT> \| --issue <KEY>)` resolves `<field>` and enumerates its allowed options into a normalized `{id, label, children}` model. Exactly one context mechanism required, exit 64 on none/multiple. **[CORRECTED per ADR-0019 §1 / adversary pass-20 M1: this pre-pass-20 framing is SUPERSEDED — `--project` is a COMPANION, not a mode selector; the mode is selected by exactly one of `{--type, --request-type, --issue}`; `--project --request-type` is VALID M3, not a pairing error; see BC-X.14.001 Invariant 1 / VP-580-006 / VP-580-009]** |
| BC-X.14.002 | `--value <substring>` client-side filter narrows the enumerated option list. |
| BC-X.14.003 | Table output (ID, Label columns, cascading indentation); `--output json` returns the normalized array via `render_json`. |
| BC-X.14.004 | Error taxonomy (field not found/ambiguous, context-flag mutual-exclusion) + graceful degradation (exit 0, not an error) for fields with no enumerable options. |

**Deferred, not committed as a BC slot**: BC-X.14.005 (the issue's own "nice-to-have"
`jr requesttype fields --enumerate-options` stretch goal) — per the F1 BA mapping doc's own
recommendation, this touches a third file (`src/cli/requesttype.rs`) beyond the two issues'
stated priority and is explicitly labeled a stretch goal in #580's own text. Flag for a future
cycle if there is demand.

**Context-mechanism decision baked in exactly as the research doc specified**:
- PRIMARY (platform fields): `--project <P> --type <T>` (both required together) → M2
  createmeta (`GET /rest/api/3/issue/createmeta/{projectIdOrKey}/issuetypes/{issueTypeId}`,
  the current non-deprecated form, CHANGE-1304-aware).
- PRIMARY (JSM request-type fields): `--request-type <NAME|ID>` → M3 (reuses `jr`'s existing
  requesttype-fields call + 7-day cache).
- FALLBACK: `--issue <KEY>` → M1 editmeta (reuses `jr`'s existing editmeta call).
- Exactly one of the three, enforced before any HTTP.

**[CORRECTED per ADR-0019 §1 / adversary pass-20 M1: this pre-pass-20 framing is SUPERSEDED —
`--project` is a COMPANION, not a mode selector; the mode is selected by exactly one of
`{--type, --request-type, --issue}`; `--project --request-type` is VALID M3, not a pairing
error; see BC-X.14.001 Invariant 1 / VP-580-006 / VP-580-009]**

### Story #578 (`--field` DX) — extends `bc-3-issue-write.md` §3.3 and §3.4

File: `.factory/specs/prd/bc-3-issue-write.md`

| BC ID | One-line summary |
|---|---|
| BC-3.3.010 | `issue create --field NAME=VALUE` (platform, non-JSM) resolves via `createmeta` and merges into the create POST body — same machinery as `issue edit --field`, source substituted. |
| BC-3.3.011 | Error taxonomy for platform-create `--field` — parallels BC-3.4.015/016's editmeta taxonomy, "Create screen" substituted for "Edit screen". |
| BC-3.4.026 | `--field NAME:kind=VALUE` hint-syntax parser. `parse_field_kv` gains kind-tag parsing (`option`/`id`/`name`/`asset`), shared across all 3 `--field` call sites. Bare form (no `:kind`) unchanged, permanent. Unicode-scalar-safe splitting (FIX-F6-LRE-1 class). |
| BC-3.4.027 | `:option` hint — explicit opt-in to today's label/id auto-detect (byte-identical wire output to bare form on the platform path only — see the platform-vs-JSM asymmetry note in the BC body; JSM diverges per BC-3.8.008's amendment); adds cascading `Parent>Child` composition [Resolved by ADR-0019 §3, Accepted 2026-08-25]. |
| BC-3.4.028 | `:id` hint — bypasses `allowedValues` lookup entirely, sends `{"id":"<VALUE>"}` verbatim. |
| BC-3.4.029 | `:name` hint — sends `{"name":"<VALUE>"}` verbatim; `--field priority:name=X` MUST be byte-identical to `--priority X`. |
| BC-3.4.030 | `:asset` hint — composes Assets object-reference array `[{workspaceId,id,objectId}]` from a compact `WORKSPACE:OBJECTID` value; bare `:asset=<objectId>` reuses the existing cached workspace id. |
| BC-3.4.031 | Malformed hint edge-case catalog — unknown kind, malformed `:asset` shapes, non-numeric objectId, empty `:kind`; companion to BC-3.4.026. |

These match the BA's proposed numbering exactly (BC-3.3.010/011; BC-3.4.026..031).

---

## Modified BCs

| BC ID | Nature of change | File |
|---|---|---|
| **BC-3.3.001** | Amendment note added: DEC-188's `--field` guard reversed (see BC-3.8.012); `--on-behalf-of` guard unaffected. Prior amendment text (2026-05-19, 2026-07-25) retained inline, unchanged. | bc-3-issue-write.md |
| **BC-3.4.014** | DEC-188-qualifier body amended: `--field` echo-suppression removed per DEC-310 reversal; `--on-behalf-of` suppression retained. Precondition's `[DEC-188 qualifier]` note updated to reflect that a bare `--field` no longer triggers a step-2 exit-64 guard and its resolved value IS echoed (per BC-3.3.010 step 6); only `--on-behalf-of` present without `--request-type` still suppresses the echo via BC-3.8.013. BC-INDEX row propagated in the same commit. | bc-3-issue-write.md |
| **BC-3.4.015** | Amendment note added: this BC's algorithm is now explicitly the BARE-form (`kind: None`) dispatch, permanent and unchanged; hint-syntax interaction documented, pointing to BC-3.4.026-031. Per ADR-0019 §2: `field_pairs` changes to `&HashMap<String, FieldValueSpec>` (bare-name key, last-wins on the whole spec); `resolve_edit_fields` reads each entry's `spec.kind` and takes the hinted-bypass branch before falling through to the existing `schema.type` match when `spec.kind == None`. | bc-3-issue-write.md |
| **BC-3.4.016** | Amendment note added: same bare-form/permanence framing for the `option`-type dispatch; explicit opt-in spelling is `:option` (BC-3.4.027); `:id` hint is the explicit spelling of this BC's own Step-1 id-bypass. | bc-3-issue-write.md |
| **BC-3.8.008** | Amendment note added: hint-kind syntax applies uniformly on the JSM create path too (resolves the F1 research/BA open question — decided YES, uniform application, since `parse_field_kv` is shared); wire target substituted to `requestFieldValues`; bare-form output is byte-identical, unchanged. New VP-578-015/016 pin the regression/parity guarantees. | bc-3-issue-write.md |
| **BC-3.8.012** | **FULL REVERSAL.** DEC-188's `--field`-alone platform-path exit-64 pre-flight guard (and the combined `--field`+`--on-behalf-of` guard, which loses its trigger) is removed. Old DEC-188 contract preserved verbatim inline as `[DEC-188 BEHAVIOR, superseded 2026-08-25]` for audit trail (mirrors the append-only convention this BC already used once, for the pre-DEC-188 #383 warn-and-proceed text). New `[CURRENT BEHAVIOR — effective 2026-08-25]` section added: `--field` alone now resolves via createmeta (BC-3.3.010) instead of erroring. H1 heading updated to reflect the reversal. **Governance flag: DEC-310 proposed** (see Summary above). | bc-3-issue-write.md |
| **BC-3.8.001** | §3.8 section preamble (3 sites) and BC-3.8.001's own H1 heading + amendment note scoped the surviving exit-64 guard to `--on-behalf-of` only, matching BC-3.8.012's reversal — the stale `--field`/`--on-behalf-of` combined phrasing (pre-reversal wording) is replaced with `--on-behalf-of`-only phrasing plus a `[reversed 2026-08-25 issue #578 DEC-310: --field no longer exits 64 — resolves via createmeta per BC-3.3.010/BC-3.8.012]` note at each site. No behavioral change to BC-3.8.001 itself — this closes a straggler where the BC-INDEX row (already corrected) and BC-3.3.001 H1 (already corrected) had moved on but this file's body text had not. | bc-3-issue-write.md |
| **BC-3.8.013** | Amended in place, NOT merely reclassified: `[CURRENT BEHAVIOR — effective 2026-08-25, issue #578]` note added (~body line 4266); "Combined pre-flight error" subsection rewritten in place (~body line 4309) to reflect BC-3.8.012's combined-guard removal; EC-3.8.013-1 updated (~body line 4331) to hold with-or-without `--field`; AC-3 marked stale-post-reversal and AC-12's count-normalization obligation added (~body line 4335). The GUARD'S OWN observable behavior (standalone `--on-behalf-of`-without-`--request-type` → exit 64) is unchanged — only the TRIGGER SCOPE description and the now-dead combined-error cross-references were updated to match BC-3.8.012's reversal. | bc-3-issue-write.md |
| **BC-3.4.017** | **[AMENDED 2026-08-25 issue #578 F2, adversary pass-13 F-1 fix]** Gate B's flag-overlap matching note extended: a hint-tagged `--field NAME:kind=VALUE` pair is matched on its BARE NAME (per BC-3.4.026's bare-key rule), so it fires Gate B identically to the bare `--field NAME=VALUE` form, for all five system fields and every hint kind. New EC-3.4.017-16 documents this (`--priority Medium --field priority:name=Medium` → exit 64). Adds `[AMENDED 2026-08-25 issue #578 F2]` footer marker. This closes a contradiction where BC-3.4.029 EC-3.4.029-2 had claimed universal last-wins (no exit 64) for the identical flag combination — EC-3.4.029-2 is now scoped explicitly to the create path, where no Gate B guard exists. No BC-INDEX title change (H1 unchanged; Gate B's title already names all five fields). | bc-3-issue-write.md |

**Explicitly UNCHANGED (confirmed, not modified)**: BC-3.8.002/005-007/009-011/014-017 (JSM
create body composition unrelated to `--field` semantics), BC-X.10.001-003 (`partial_match`
primitive, reused as-is), BC-4.1.001/BC-4.2.001 (Assets workspace/CMDB contracts, reused
read-only — see citation correction below), and BC-6.3.001 (multi-profile fields, reused).
**Correction (adversary pass-6 F1):** BC-3.8.013 (`--on-behalf-of` guard) was previously listed
here as UNCHANGED; its body WAS amended this cycle (see the Modified BCs table above) — its
GUARD BEHAVIOR is what stayed in force unchanged, not its BC body text. Moved to the Modified
BCs table. **Correction (adversary pass-13 F-1):** BC-3.4.017 (C-1 multi-key guard / Gate B) was
also previously listed here as UNCHANGED ("orthogonal per the F1 BA mapping doc"). That was
accurate at F1 authoring time but became stale once BC-3.4.026's hint-syntax parser (this same
cycle) revealed a hint × Gate-B interaction that needed to be spelled out explicitly — see the
new Modified BCs row above. Removed from this UNCHANGED list.

---

## Citation correction made during authoring

The F1 `field-dx-bc-mapping.md` (§1.3, item BC-3.4.030's precursor note) and the feasibility
research doc both cite **"BC-4.1.001"** for workspace ID discovery + cache. This is **incorrect**
— BC-4.1.001 is `find_cmdb_fields()` (CMDB field schema filtering by `schema.custom`, unrelated
to workspace discovery). The correct citation is **BC-4.2.001** (`assets search` discovers
workspace ID first, cache or API; `src/api/assets/workspace.rs::get_or_fetch_workspace_id`).
Corrected in BC-3.4.030's Source/Trace fields; no change to `bc-4-assets-cmdb.md` itself (its
BC-4.2.001 contract is reused read-only, unchanged).

---

## Decisions made to resolve F1's open design questions

The F1 delta analysis and BC-mapping doc flagged four explicit open design questions for F2 to
resolve. All four are resolved here, with rationale:

1. **`jr field options` context requirement** (research open question 1) — RESOLVED per the
   dedicated context-mechanism research doc, baked in exactly as specified: `--project/--type`
   (createmeta) PRIMARY for platform fields, `--request-type` PRIMARY for JSM fields, `--issue`
   FALLBACK. Exactly one required. This was NOT an open question by the time F2 started — the
   orchestrator's own research pass had already settled it; F2 simply encodes the decision into
   BC-X.14.001.

   **[CORRECTED per ADR-0019 §1 / adversary pass-20 M1: this pre-pass-20 framing is
   SUPERSEDED — `--project` is a COMPANION, not a mode selector; the mode is selected by
   exactly one of `{--type, --request-type, --issue}`; `--project --request-type` is VALID
   M3, not a pairing error; see BC-X.14.001 Invariant 1 / VP-580-006 / VP-580-009]**

2. **Bare-vs-hinted precedence** (BA open question 5.2 / research open question 2) — RESOLVED:
   the bare form (`NAME=VALUE`, no `:kind`) retains BC-3.4.015/016's auto-detect-from-schema-type
   behavior **permanently**. It is never deprecated. Hints are purely additive/opt-in. Encoded as
   BC-3.4.026 Invariant 1 and cross-referenced from BC-3.4.015/016's amendment notes.

3. **Does hint-kind syntax apply to JSM create's `--field` (BC-3.8.008)?** (BA open question 5.3
   / research open question 3) — RESOLVED: **YES, uniformly.** Rationale: `parse_field_kv` is a
   single shared function across all three call sites; maintaining a syntax divergence between
   `issue edit --field`/platform `issue create --field` and JSM `issue create --field` would
   reintroduce exactly the kind of DX inconsistency #578 exists to fix. Encoded as BC-3.8.008's
   amendment note, with the wire-target substitution (`requestFieldValues` instead of `fields`)
   made explicit. Cascading composition (`:option` with `Parent>Child`) is explicitly **NOT**
   extended to the JSM path this cycle (JSM's `requestFieldValues` cascading wire shape is
   unverified) — flagged as an open question below, not silently assumed.

4. **BC-3.8.012 repeal: full removal or DEC needed?** (BA open question 5.4) — RESOLVED: **DEC
   needed, not decided unilaterally.** This delta performs the spec-level reversal (BC-3.8.012's
   contract text now reflects the new behavior) but explicitly does NOT declare the governance
   question closed — it proposes **DEC-310** and flags it for the orchestrator to register
   formally, consistent with how DEC-188 itself was a recorded, reviewable decision rather than
   an implicit code change.

---

## Resolved during this pass (adversary pass-6 F4 correction)

**Cascading-select delimiter (`>`) in the `:option` hint (BC-3.4.027)** — RESOLVED, not open.
[Resolved by ADR-0019 §3, Accepted 2026-08-25] This entry was originally authored PROVISIONAL:
the `:option` hint's cascading composition (`--field 'cf:option=Parent>Child'` →
`{"value":"Parent","child":{"value":"Child"}}`) is a genuinely new design surface (cascading
support does not exist anywhere in `jr` today), and the `>` delimiter choice was a product-owner
judgment call made to keep the four-kind hint surface from the issue's own acceptance criteria
intact (rather than inventing a fifth kind). ADR-0019 §3 has since confirmed `>` as the delimiter
(rejecting `::`/`->`/`/`/`,`/a fifth hint kind/a repeated-flag pattern) and documents the `:id=`
escape hatch for a legitimate `>` in a display value (see BC-3.4.027's own body and
EC-3.4.027-4). VP-578-008 is no longer PROVISIONAL. Retained here (rather than deleted) for
traceability of the F1→F2 open-question resolution; it is **not** one of the open items below.

**`parse_field_kv`'s new return-type shape (research open question 3)** — RESOLVED.
[Resolved by ADR-0019 §2, Accepted 2026-08-25] This entry was originally authored as a
product-owner-only implementation-shape call, explicitly flagged as overridable by
architecture (see the superseded text below). ADR-0019 §2 has since **confirmed**
`HashMap<String, FieldValueSpec>` (retaining `HashMap` over an ordered `Vec`, per the
product-owner's own rationale — no consumer needs argv order) **and went beyond the
product-owner's proposal** with one load-bearing refinement made explicit there: the map key
is always the bare field name (never a composite `"name:kind"` key), with last-wins semantics
overwriting the whole `FieldValueSpec` on a repeated `--field NAME` occurrence carrying
different kind hints — this prevents a double-application bug (two entries for one logical
field reaching a wire-serialization step with conflicting kinds) that the bare-shape decision
alone did not rule out. Superseded original text, retained for traceability: "I decided
`HashMap<String, FieldValueSpec>` (retaining `HashMap`, per BC-3.4.015's own documented
rationale for `HashMap` over `Vec`) rather than switching to an ordered `Vec`. This is a
concrete implementation-shape decision made to unblock BC authoring, not merely an 'open
question' — but it is a decision an architect reviewing the F4 implementation plan should be
able to override if a different shape proves better during implementation... Flagged here so
the architect knows this was a product-owner call, not an architecture-team call." Retained
here (rather than deleted) for traceability of the F1→F2 open-question resolution; it is
**not** one of the open items below.

---

## Open design questions — NOT resolved here, flagged for architect/adversary

1. **JSM `requestFieldValues` cascading wire shape** — out of scope this cycle (BC-3.8.008's
   amendment explicitly does NOT extend BC-3.4.027's cascading composition to the JSM path,
   because the correct `requestFieldValues` wire shape for a cascading select has not been
   verified against JSM's API — it may differ from the platform `fields` shape). **Adversary
   pass-6 F3 correction:** the NON-cascading `{"value":...}` JSM wire shape asserted by
   BC-3.8.008's amendment is likewise unverified against live JSM (only the platform-path
   `fields` wire contract was CONFIRMed by research — see
   `.factory/research/field-dx-feasibility-2026-08-25.md` claim 5); BC-3.8.008's body now
   caveats both the non-cascading and cascading JSM shapes as unverified rather than asserting
   the non-cascading form as fact. If a future cycle wants verified (cascading or non-cascading)
   support on JSM create, this needs its own research/live-verification pass.

---

## 2026-08-26 F2 adversary-convergence amendments (D1/D2/D3 + A-M2/B-F1/C-M1 + LOWs)

Three fresh-context adversary passes against the frozen F2 delta (`architecture-delta-field-dx.md`,
this document, `verification-delta-field-dx.md`) surfaced defects across three categories: three
architectural design forks the architect resolved (D1/D2/D3, ADR-0019 § Amendment 2026-08-26 +
`architecture-delta-field-dx.md` §9), three pure-spec-text errors (A-M2, B-F1, C-M1), and seven
folded-in LOW findings. This burst propagates the architect's D1/D2/D3 decisions into the BC
bodies and resolves the pure-spec-text/LOW items directly. **No BCs added or removed; total_bcs
stays 719, `bc-3-issue-write.md` stays 123/152, `cross-cutting.md` stays 89/155.** All changes are
in-place body amendments plus embedded edge cases (EC-N additions), consistent with this delta's
existing no-count-change amendments (BC-3.3.001, BC-3.4.014/015/016/017, BC-3.8.001/008/013).

### D1 — M2 default-project resolution parity (`cross-cutting.md`)

**Defect (adversary MEDIUM-1):** the pure mode-selector arity function pinned `has_project` (the
literal `--project` flag) as a REQUIRED 4th boolean for M2, so `jr field options FOO --type Bug`
exited 64 even with a profile default project configured — contradicting BC-3.3.010's
flag-OR-default project resolution and M3's own optional-companion fallback.

**Resolution (ADR-0019 § Amendment D1):** the pure arity check (`resolve_field_context`) is
narrowed to `(has_type, has_request_type, has_issue) -> Result<Mode, ArityError>` — `has_project`
is removed from its signature entirely. A new, sibling pure function (`resolve_m2_project`),
invoked only after M2 is selected, resolves the project as flag-OR-profile/config-default (same
source BC-3.3.010 and M3 already read). The incomplete-M2 error's trigger widens from "no flag" to
"no flag AND no default"; the error message itself is unchanged.

**BC bodies touched:** BC-X.14.001 (`cross-cutting.md`) — the "§BC-X.14 context-mechanism
decision" section intro, a new "M2 project resolution step" paragraph, the Preconditions bullet,
Invariant 1, VP-580-006, and the Trace section; BC-X.14.004 — the error-taxonomy table row and the
precedence paragraph. No `bc-3-issue-write.md` BC needed a D1 change (BC-3.3.010's create-path
project resolution was already flag-OR-default; D1 only brought BC-X.14.001's M2 into parity with
it).

**VP implication (flagged for the verifier, not resolved here):** VP-580-006's
`resolve_field_context` proptest must drop the `has_project` axis (narrowed to 3 booleans). A NEW
verification target is needed for `resolve_m2_project` specifically — `{--project flag present,
profile default present, neither present} × M2-only` — structurally mirroring whichever existing
VP covers BC-3.3.010's flag-or-default project resolution on the create path.

### D2 — create-path collision precedence (`bc-3-issue-write.md`)

**Defect (adversary B-F3):** `jr issue create` has no Gate B — `--priority Medium --field
priority:name=Medium` writes `fields.priority` via two unordered sources (`--priority` and
`--field` are distinct clap args with no relative-order guarantee; `parse_field_kv` returns an
unordered `HashMap`). BC-3.4.029 EC-3.4.029-2's prior "last-wins" claim described an outcome with
no defined "later."

**Resolution (ADR-0019 § Amendment D2):** Gate B (BC-3.4.017) is extended to the create path via
one shared, pure, extracted function — `field_resolve::detect_flag_field_overlap` — reused by both
`edit.rs`'s existing Gate B and a new create-path guard in `create.rs`. Outcome: any argv order of
a dedicated flag and a `--field` pair on the same wire key (any hint kind, any field in Gate B's
governed set restricted to `issue create`'s dedicated flags) → exit 64, no HTTP, symmetric with
EC-3.4.017-16. A precedence-rule alternative (e.g. "dedicated flag always wins") was rejected — it
only relocates the ambiguity and, for a state-changing command, silently discarding one of two
explicit values is worse than rejecting the invocation outright.

**BC bodies touched:** BC-3.4.029 EC-3.4.029-2 (rewritten — create path is now symmetric with
edit, not last-wins); BC-3.4.014 (the matching "last-flag-wins... per BC-3.4.029 EC-2" sentence
rewritten to describe the new guard); BC-3.4.017 (new note: Gate B's flag-overlap detection is now
a shared function also invoked by the create path; EC-3.4.017-16's cross-reference to BC-3.4.029
corrected); BC-3.3.010 (new Invariant 5 + EC-3.3.010-6 + a new VP for the create-path guard);
BC-3.3.011 (new error-taxonomy row + Postconditions evaluation-order note).

**VP implication (flagged for the verifier, not resolved here):** a create-path Gate-B VP,
structurally mirroring VP-396-005's edit-path Gate B coverage, exercising any argv order × any
hint kind × each governed field, asserting exit 64, the overlap error, and zero HTTP calls.

### D3 — cascading `>`-split multibyte safety (`bc-3-issue-write.md`)

**Defect (adversary B-F2):** the `>` cascading split (BC-3.4.027) happens at the CALL SITE
(`field_resolve.rs`, and the analogous point in `create.rs`'s platform-create path) — never inside
`parse_field_kv`, whose own Unicode-scalar-safety MUST (BC-3.4.026 step 5) does not cover this new
site. A naive char-index-as-byte-offset implementation panics on a multibyte scalar preceding `>`
(e.g. `--field 'cf:option=Pré>Bñ'`) — the same class of bug FIX-F6-LRE-1 (#734,
`jql::validate_duration`) fixed, via a different specific mechanism.

**Resolution (ADR-0019 § Amendment D3):** every call site performing the `>` split MUST use
`str::split_once('>')` (never a char-index-based or fixed-byte-offset scheme) — named specifically
rather than a looser "must be Unicode-scalar-safe" instruction, since discretion over the exact
implementation is precisely the axis FIX-F6-LRE-1 was introduced on. Scoped to `field_resolve.rs`
(edit) and `create.rs`'s platform-create path (create); excludes `parse_field_kv` (already
covered) and JSM (no cascading this cycle).

**BC bodies touched:** BC-3.4.027 — a new "Multibyte-safety MUST on the `>` split" paragraph, a
new Invariant 5, EC-3.4.027-5 (multibyte no-panic), EC-3.4.027-6 (empty parent/child segment →
exit 64, folds in the B-LOW empty-cascading-segments item below), and VP-578-008 extended with a
no-panic-proptest note.

**VP implication (flagged for the verifier, not resolved here):** a no-panic property test over
arbitrary UTF-8 input, one per call site (`field_resolve.rs`; `create.rs` platform-create path),
mirroring `validate_duration`'s FIX-F6-LRE-1 proptest and VP-578-005's `parse_field_kv` splitter
coverage — extending or sibling to VP-578-008.

### A-M2 — BC-X.14.002 bare-invocation example contradicted BC-X.14.001's mandatory-selector rule

**Defect:** the example `jr field options customfield_10084` as a successful BARE invocation
contradicted BC-X.14.001's Invariant 1 (zero mode selectors → exit 64).

**Fix:** BC-X.14.002's Inputs section now shows `jr field options customfield_10084 --issue
FOO-1` and clarifies "bare" means absence of `--value` specifically, never absence of a
mode-selector context flag (which stays mandatory regardless).

### B-F1 — BC-X.14.001 M3 pagination claim was factually false

**Defect:** the Postconditions claimed M3 (`--request-type` field enumeration) "PAGINATES
INTERNALLY... reuses the existing `jr requesttype fields` `isLastPage`-style pagination." Verified
false against `src/api/jsm/request_types.rs::get_request_type_fields`: it is a single,
non-paginated GET returning a flat `RequestTypeFieldsResponse { can_raise_on_behalf_of,
can_add_request_participants, request_type_fields: Vec }` envelope (no `size`/`start`/`limit`/
`isLastPage`/`_links.next`). The cited `isLastPage` loop belongs to the DIFFERENT function
`list_request_types` (lists request TYPES, not one request type's FIELDS).

**Fix:** BC-X.14.001's Postconditions corrected to state M3 field enumeration is a single GET, no
pagination, with a forward-looking caveat that a future paginated JSM field envelope would need
revisiting. The M2 createmeta/issuetypes pagination claims (both correct, independently verified
against source) are UNCHANGED. Pre-fix wording retained inline as a superseded audit-trail note,
per this repo's append-only convention.

### C-M1 — DEC-307 was already allocated; renumbered to DEC-310

**Defect:** the proposed DEC-307 (BC-3.8.012's governance flag for the DEC-188 reversal) was
derived from a `grep -rohE "DEC-[0-9]{3}"` survey scoped to `.factory/specs/` only, which reported
DEC-306 as the highest existing number. Re-running the survey across the ENTIRE `.factory/` tree
(`grep -rohE "DEC-[0-9]{3}" .factory/`) finds DEC-309 as the true maximum — `cycle-001`
(`list-read-ergonomics`)'s F5/F7 closure had already allocated DEC-306 through DEC-309 (recorded
in `.factory/cycles/cycle-001/` and `STATE.md`, outside `specs/`): DEC-306 (F5 Round-1 human
ruling), **DEC-307 (that same cycle's F5 combined-delta fix — already a REGISTERED decision, not
an available number)**, DEC-308 (FIX-F6-LRE-1, PR #734), DEC-309 (the F7 final authorization
gate). The original proposal did not merely round down to a stale number — it collided with an
already-taken one.

**Fix:** applying the repo's own "next sequential after the highest" rule against the CORRECT
full-`.factory/`-tree maximum (DEC-309) yields **DEC-310**. Every occurrence of the proposed
DEC-307 in `prd-delta-field-dx.md` (this document) and `bc-3-issue-write.md` (BC-3.3.001,
BC-3.4.014, BC-3.8.001, BC-3.8.012's governance flag + Trace + `[AMENDED...]` markers,
BC-3.8.013) is renumbered to DEC-310; the survey-provenance prose is corrected to describe the
full-tree grep and the DEC-307 collision, not the specs-only undercounted grep. DEC-310 remains a
**proposal**, not yet formally registered — the orchestrator/state-manager should register it at
cycle close and must not let a future pass reuse DEC-310 or DEC-307 (already taken) again.

**Open namespace question, flagged not resolved:** spec-level DECs (188, 306, 307, 310) and
cycle-gate DECs (e.g. 309) currently share one undifferentiated `DEC-NNN` prefix. Whether these
should remain one sequence (current de facto behavior, confirmed by this collision) or split into
two disambiguated series is an open question flagged for cycle close — this amendment does not
resolve it, only surfaces it so a repeat of this exact collision class does not happen silently
again.

### Folded-in LOWs

- **A-LOW-1** (`bc-3-issue-write.md`, BC-3.4.026 Invariant 1): over-claimed the bare form
  auto-detects "forever" with no platform-scope qualifier. Added an explicit platform-path-only
  scope note — on the JSM path, bare `kind: None` is BC-3.8.008's UNCONDITIONAL string-wrap
  (pinned by VP-578-015 byte-identity), not BC-3.4.016 auto-detect. Prevents a VP-578-015
  regression from a future reader over-generalizing this invariant.
- **A-LOW-2** (`cross-cutting.md`, BC-X.14.001 Preconditions): "`--issue <KEY>` (no `--project`
  companion)" read as a prohibition. Reworded to "`--project` not consulted," consistent with
  VP-580-006 and the model's own "harmlessly ignored, not rejected" framing elsewhere in the BC.
- **B-LOW, `:asset` discovery failure** (`bc-3-issue-write.md`, BC-3.4.030): added an explicit
  error-taxonomy table for the bare `:asset=<objectId>` cold-cache `get_or_fetch_workspace_id` GET
  — 403/404 → "Assets is not available on this Jira site" UserError exit 64; 200+empty `values` →
  "No Assets workspace found" UserError exit 64; 401 → standard auth-error mapping (unaffected by
  the Assets-specific UserError); 5xx/network → standard API/network-error mapping — plus
  EC-3.4.030-5, sourced from reading `src/api/assets/workspace.rs::get_or_fetch_workspace_id`
  directly (not previously documented at the BC level).
- **B-LOW, empty cascading segments** (`bc-3-issue-write.md`, BC-3.4.027): defined `cf:option=Parent>`
  (empty child) and `cf:option=>Child` (empty parent) as EC-3.4.027-6 — both exit 64,
  unresolvable, folding into the SAME shape as the existing EC-3.4.027-2 (empty parent → parent
  unresolvable) / EC-3.4.027-3 (empty child → child unresolvable) rather than a distinct
  empty-segment message.
- **B-LOW, `--value ""`** (`cross-cutting.md`, BC-X.14.002): documented as the IDENTITY filter
  (matches everything, same output as `--value` absent) since it's a reachable scripted
  invocation distinct from the flag being absent entirely.
- **B-LOW, `--value` + graceful-degrade** (`cross-cutting.md`, BC-X.14.002): documented that the
  BC-X.14.004 graceful-degrade path still fires with `--value` present — the filter applies AFTER
  the full fetch, so a zero-enumerable-options field produces an empty list before `--value` ever
  runs; stdout stays `[]`, the degrade hint still fires.
- **B-LOW, M3 reverse name-resolution** (`cross-cutting.md`, BC-X.14.001): added EC-X.14.001-6,
  the reverse of EC-X.14.001-5 — a field enumerable in the request type's `validValues` but not
  surfaced by the global `/rest/api/3/field` list under any human name (resolvable only via
  `customfield_NNNNN`); a discoverability limitation, not a `jr` defect, with a documented
  fallback (`jr requesttype fields <RT> --output json`).
- **C-LOW** (`bc-3-issue-write.md`, BC-3.8.012 F3/F4 removal obligations): the rewritten-holdout
  enumeration omitted H-NEW-PREFLIGHT-006 (the `--output json` mode counterpart of
  H-NEW-PREFLIGHT-001, confirmed rewritten in `holdout-scenarios.md`'s own trace and Group 20 body
  but not listed here). Added to the enumeration alongside H-NEW-PREFLIGHT-001/003.

---

## 2026-08-26 F2 adversary-convergence round-2 amendments

A fresh 3-pass adversarial streak against the round-1 amendments above (D1/D2/D3 + A-M2/B-F1/C-M1
+ LOWs) found six further residual defects — all partial-fix / coverage gaps in the prose those
amendments left behind, **none requiring a new design decision**. Fixed in `bc-3-issue-write.md`
and `cross-cutting.md` only; `verification-delta-field-dx.md`, `ADR-0019`/architecture-delta,
`BC-INDEX.md`, and `CANONICAL-COUNTS.md` are unchanged this round (verifier and state-manager own
those next). No BC added/removed/retired; `total_bcs` stays 719, holdout total stays 106.
**[CORRECTED 2026-08-26, F2 adversary-convergence round-3, F-LOW-2/F-LOW-3]** The VP total was
originally recorded here as "stays 29" — that was accurate only at the moment this round-2 section
was first drafted; by the time Pass2-F2's flagged item below was resolved into a concretely-minted
VP (VP-580-012, `cross-cutting.md` BC-X.14.004 — "`--project` not found (404)" taxonomy-row
coverage), the round-2 VP total was actually **30**, not 29. Corrected here to avoid a stale count
surviving into cycle-close reconciliation.

### Pass2-F1 (MEDIUM) — `:asset` cold-cache taxonomy widened to all three call sites

`bc-3-issue-write.md`, BC-3.4.030. The B-LOW error taxonomy added in round 1 scoped itself to
`issue edit --field` and `issue create --field` (platform) only, but BC-3.8.008 independently
specifies that `handle_jsm_create` (JSM create path) ALSO calls `get_or_fetch_workspace_id` first
for a bare `:asset=<objectId>` hint — the JSM site was omitted, contradicting BC-3.8.008's own
text. Since the taxonomy fires during workspace-ID *resolution*, strictly before any `:asset`
array is composed on any path, it is wire-shape-independent and applies uniformly. Fixed: the
taxonomy's scope statement and its trailing summary sentence now name all three call sites (edit,
platform-create, JSM-create); VP-578-022 extended to assert wiremock coverage on all three. A new
distinguishing paragraph makes explicit that this does NOT resolve the SEPARATE, still-deferred
question of whether the JSM path's happy-path `:asset` `requestFieldValues` wire shape matches the
platform-path shape — that stays UNVERIFIED per VP-578-016 (BC-3.8.008 amendment), unchanged by
this fix. **Do not conflate the two**: workspace-discovery FAILURE handling is now verified-and-
uniform across all 3 sites; the JSM `:asset` SUCCESS-path wire shape remains unverified/deferred.

### Pass2-F2 (MEDIUM) — new `--project not found (404)` taxonomy row for `jr field options`

`cross-cutting.md`, BC-X.14.004. `jr field options` performs no client-side project-existence
pre-check on either the M2 (`get_issue_types_for_project` / `get_createmeta_fields`) or M3
(`get_or_fetch_project_meta`) path, so a `--project` value that does not resolve to a real,
accessible project produces a genuine HTTP 404 that was previously undocumented in the error
taxonomy — distinct from both the existing "no resolvable project" row (companion value absent
entirely, a pre-HTTP arity failure) and the existing "non-JSM project" row (project DOES resolve,
just to the wrong type). Fixed: added a new taxonomy-table row ("`--project not found or not
accessible`", exit 64) plus companion EC-X.14.004-6, which explicitly distinguishes the new row
from the three other project-related rows it could otherwise be confused with (EC-X.14.004-4's
M2 unknown-`--type`-for-a-valid-project case; the companion-absent row/EC-X.14.004-5; the
non-JSM-project row). **[RESOLVED 2026-08-26, F2 adversary-convergence round-3, F-LOW-2/F-LOW-3]**
The "dedicated new VP number, or fold into VP-580-004" question this section originally left
open (below) is now settled: `cross-cutting.md` mints a dedicated **VP-580-012** for this row
(`--project` not found (404) on both the M2 and M3 enumeration paths, zero mutating HTTP, exact
message assertion), rather than folding it into VP-580-004's generic per-row clause — this is the
VP whose minting corrects the round-2 "VP total stays 29" line above to 30. **Original,
now-superseded framing (retained for audit trail):** "Flagged for the verifier, not resolved
here: whether this new row warrants a dedicated new VP number, or is adequately covered by
VP-580-004's existing 'each row of the error taxonomy table is independently exercised' per-row
coverage clause."

### Pass2-F3 (MEDIUM) — `:asset` `WORKSPACE:OBJECTID` first-colon split needs its own `str::split_once` MUST

`bc-3-issue-write.md`, BC-3.4.030 Parsing rule 1. This colon-split (composer-call-site, splitting
the ALREADY-extracted `NAME:asset=VALUE` value portion on its first `:`) is independent of both
BC-3.4.026 step 5's Unicode-scalar-safety MUST (scoped to `parse_field_kv`'s own steps 1-2 only)
and BC-3.4.027 Invariant 5's `str::split_once('>')` MUST (scoped to the cascading `>` split) —
exactly the same "independent split site, needs its own explicit MUST" situation D3 already fixed
for the `>` split. Fixed: added a `str::split_once(':')` MUST to Parsing rule 1 (mirroring D3's
rationale verbatim — a char-index-as-byte-offset scheme panics on a multibyte scalar preceding the
delimiter, the FIX-F6-LRE-1 bug class; a proptest alone is insufficient, the implementation
technique itself must be pinned), a new Invariant 4 cross-referencing it, new EC-3.4.030-6
(`cf:asset=Wé:123` — multibyte scalar adjacent to `:`, resolves without panicking), and a
VP-578-012 extension adding a no-panic proptest note mirroring VP-578-008's D3 extension.

### Pass2-F4 (LOW) — `objectId` numeric-shape check corrected from Unicode `\d+` to ASCII `[0-9]+`

`bc-3-issue-write.md`, BC-3.4.030 Parsing rule 3 and BC-3.4.031 EC-3. Rust's `regex` crate's
default `\d` matches the entire Unicode `Nd` (decimal number) category — Arabic-Indic digits
(`١٢٣`), fullwidth digits (`１２３`), and other non-ASCII numeral scripts all pass a naive `\d+`
check client-side, then fail server-side, since Jira's `objectId` field accepts ASCII digits only.
Fixed: both sites now specify ASCII-only `[0-9]+` (equivalently `regex`'s `(?-u)\d+`) explicitly,
with EC-3 gaining concrete non-ASCII-digit examples.

### Pass2-F5 (MEDIUM) — deterministic ordering pinned between the D2 collision guard and BC-3.8.013's guard

`bc-3-issue-write.md`. Round 1's D2 (create-path collision guard) and the pre-existing BC-3.8.013
(`--on-behalf-of`-without-`--request-type`) guard are BOTH step-2-class guards — each fires
immediately after the JSM dispatch fork, before project-key resolution, and neither round-1's
`Platform-Path Guard Ordering` SSOT block nor BC-3.3.010's own guard-ordering precondition list
said which wins when an invocation trips both (e.g. `create --priority X --field priority=Y
--on-behalf-of Z`, no `--request-type`). Fixed, choosing the minimum-disruption resolution: BC-
3.8.013 keeps its pre-existing, already-tested step-2 position UNCHANGED; the D2 guard becomes a
new step 2a, evaluated immediately after step 2. Updated in four places: (1) the `Platform-Path
Guard Ordering` SSOT block gains step 2a plus a worked example and an explicit "step 2 before step
2a, step 2's position is unchanged" rationale; (2) BC-3.3.010's Preconditions guard-ordering
sentence now names both guards in sequence and points at the SSOT block; (3) EC-3.3.010-6 gains an
ordering note for the case where `--on-behalf-of` is also present; (4) BC-3.3.011's D2
taxonomy-row Postconditions note is scope-clarified — "evaluated FIRST, before every other row in
this table" was previously ambiguous as to whether it also out-ranked BC-3.8.013 (a guard that is
NOT a row in that table); it does not. This is deterministic — consistent with BC-X.14.004's
existing "fixing one reported error deterministically encounters the next" precedence principle
(`cross-cutting.md` § BC-X.14.004), applied here across two different BCs' guards rather than
within one taxonomy table.

### Pass2-F6 (MEDIUM) — dangling `.factory/specs/verification-delta/` path corrected at all 3 sites

`bc-3-issue-write.md` (2 sites: BC-3.3.010 amendment preamble; VP-578-020 body) and
`cross-cutting.md` (1 site: BC-X.14.001's companion trace entry). All three cited
`.factory/specs/verification-delta/` as the realization location for pass-28's page-≥2 pagination
VPs — a directory that never existed in this repo. Replaced with the actual verifier artifact
path, `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md`, matching this directory's
own `verification-delta-<cycle>.md` naming precedent used elsewhere (e.g.
`verification-delta-DEAD-CITATION-CI.md`, `verification-delta-398.md`). This now agrees with
`verification-delta-field-dx.md`'s own §0/§5, which correctly state there is no standalone VP
registry file — these three BC-side pointers were the only remaining mismatch.

### VP implications for the verifier (flagged, not resolved here)

- **VP-580-006** (`cross-cutting.md`) — already correctly rewritten in this file's own inline body
  to the post-D1 3-boolean `resolve_field_context(has_type, has_request_type, has_issue)`
  signature (no `has_project` parameter). **[DONE — 2026-08-26, F2 adversary-convergence round-3,
  F-LOW-2/F-LOW-3]** The stale pre-D1 4-boolean signature + the `!has_type||has_project` clause
  that previously survived inside `verification-delta-field-dx.md` §2 has since been rewritten by
  the verifier in that frozen delta — this item is CLOSED, not an open flag any longer. (Original
  framing, retained for audit trail: "survives only inside `verification-delta-field-dx.md` §2
  (out of this agent's write scope) — the verifier's job to rewrite there, not a gap in either PRD
  file.")
- **VP-578-022** (`bc-3-issue-write.md`) — now must assert wiremock coverage on all THREE `:asset`
  cold-cache call sites (edit, platform-create, JSM-create), not two. See Pass2-F1 above.
- **New `--project` 404 row** (`cross-cutting.md`, BC-X.14.004) — **[RESOLVED, F-LOW-2/F-LOW-3]**
  minted as dedicated VP-580-012, not folded into VP-580-004. See Pass2-F2's updated resolution
  note above.

## 2026-08-26 F2 adversary-convergence round-3 amendments

A fresh 3-pass adversarial streak against round-1/round-2's amendments found one HIGH
contradiction, three MEDIUMs, and several LOWs (mostly partial-fix stragglers) — one design item
(F-B) was pre-decided by the architect (ADR-0019 § Amendment F-B / `architecture-delta-field-dx.md`
§9) and propagated here; everything else is a BC-body/spec-text fix made directly. Fixed in
`bc-3-issue-write.md` and `cross-cutting.md` only, per this round's write scope;
`verification-delta-field-dx.md`, ADR-0019/architecture-delta (architect-owned, already done), and
`BC-INDEX.md`/`CANONICAL-COUNTS.md` (state-manager reconciles last) are untouched by this agent
this round. **No BCs added, removed, or retired — counts are unchanged: `bc-3-issue-write.md`
stays 123/152, `cross-cutting.md` stays 89/155, `total_bcs` stays 719.**

### F-A (HIGH) — empty value on `:id=`/`:name=`/`:asset=` contradiction resolved consistently

**Defect:** VP-578-013 §3 mandated exit-64 for an empty value on ANY of `:id=`/`:name=`/`:asset=`,
but BC-3.4.028/029 ("server is SOLE validator, ZERO client-side matching") and ADR-0019 §2(b)
("`parse_field_kv`'s value is deliberately uninterpreted") contradicted a client-side empty-value
rejection for `:id`/`:name` specifically.

**Fix (existing decisions applied consistently, no parser kind-specific validation added):**
- `bc-3-issue-write.md`, BC-3.4.028: new EC-3.4.028-3 — empty `:id=` value PASSES THROUGH
  verbatim as `{"id": ""}`; server validates; NOT a `jr`-side exit-64.
- `bc-3-issue-write.md`, BC-3.4.029: new EC-3.4.029-3 — identical pass-through posture for
  empty `:name=`.
- `bc-3-issue-write.md`, BC-3.4.031: EC-2's scope note now states `:asset` is the ONLY kind in
  the catalog whose empty-value form is a client-side exit-64, and explains WHY — a STRUCTURAL
  composer failure (cannot build `[{workspaceId,id,objectId}]` with no `objectId`), not a
  value-validation rejection. New EC-8 (empty `:id=`) and EC-9 (empty `:name=`) added to the
  malformed-hint catalog, both explicitly marked PASS-THROUGH, cross-referencing BC-3.4.028
  EC-3.4.028-3 / BC-3.4.029 EC-3.4.029-3.
- VP-578-013's own text (`bc-3-issue-write.md`) now carries a scope note pinning its empty-value
  exit-64 assertion to `:asset` (EC-2a) ONLY, and flags the verifier to (a) not assert exit-64 for
  EC-8/EC-9 and (b) fix the `prop_oneof!` strategy, which currently omits `:name` from its
  generated kind space.

### F-MED-1 (MEDIUM) — `parse_field_kv`'s own exit-64 pinned in the Platform-Path Guard Ordering SSOT

**Defect:** the D2 collision guard (step 2a) consumes the already-parsed
`HashMap<String, FieldValueSpec>`, so `parse_field_kv` (BC-3.4.031's unknown-kind/malformed exit-64
— a THIRD pre-HTTP exit-64 path on `jr issue create`) must run before it, but the SSOT block never
numbered this dependency.

**Fix:** `bc-3-issue-write.md`'s `#### Platform-Path Guard Ordering — handle_create` SSOT block now
pins a deterministic THREE-step pre-HTTP guard order: **step 2** (BC-3.8.013 `--on-behalf-of`,
presence-only, position unchanged) → **step 2a** (NEW — `parse_field_kv`'s hint-syntax parse pass,
BC-3.4.026/031; a hard data-dependency prerequisite of step 2b, not merely an ordering preference)
→ **step 2b** (RENUMBERED from step 2a — the D2 create-path collision guard, ADR-0019 § Amendment
D2). Propagated to every current-contract citation of the old "step 2a" label: BC-3.3.010's
Preconditions guard-ordering sentence, EC-3.3.010-6, and BC-3.3.011's Postconditions
evaluation-order note (all `bc-3-issue-write.md`). Historical changelog/trace entries describing
the pre-existing round-2 state are left as accurate audit trail, per this repo's append-only
convention. The SSOT's "guard-ordering consequence" paragraph now states the deterministic
precedence across all three pre-HTTP exit-64 paths, extending BC-X.14.004's own "fixing one
reported error deterministically encounters the next" principle from one taxonomy table to this
three-guard chain.

### F-MED-2 (MEDIUM) — BC-X.14.001 H1 showed M2's `--project` as mandatory

**Defect:** the H1 synopsis read `--type <T> --project <P>` (unbracketed) while M3 read
`--request-type <RT> [--project <P>]` (bracketed) — contradicting D1's own M2/M3 parity decision
(flag-OR-profile-default, never a hard requirement).

**Fix:** `cross-cutting.md`, BC-X.14.001 H1 changed to `--type <T> [--project <P>]`, mirroring M3.
**State-manager propagation flag:** the BC-INDEX.md title row for BC-X.14.001 must be updated to
match this new H1 verbatim — flagged here per this doc's H1-title-source-of-truth convention;
NOT edited by this agent (state-manager reconciles BC-INDEX.md/CANONICAL-COUNTS.md last).

### F-C (MEDIUM) — `:asset=W:Y:Z` (extra colon) under-documented, misleading message

**Defect:** BC-3.4.031 EC-2 enumerated only three `:asset` malformed sub-cases; VP-578-012 claimed
a `W:Y:Z` case with no BC backing. Under `str::split_once(':')`, `W:Y:Z` → workspace `W`, objectId
candidate `Y:Z` → fails the ASCII `[0-9]+` check, but the existing generic "objectId must be
numeric" message is misleading for a caller who supplied three colon-separated segments (a
distinct mistake from a genuinely non-numeric two-segment objectId).

**Fix:** `bc-3-issue-write.md`, BC-3.4.031 — new EC-2d documents the `W:Y:Z` shape, its
`split_once`-derived resolution, and requires a message naming the actual mistake (e.g.
`"unexpected extra ':' in :asset value — expected WORKSPACE:OBJECTID"`) instead of reusing EC-3's
generic wording. EC-2's stale "three sub-cases" corrected to "FOUR sub-cases." EC-3 cross-references
EC-2d to prevent message-reuse confusion. VP-578-012 (BC-3.4.030) gains a verifier flag requiring
its §2 message-assertion be aligned to EC-2d's specific wording, not EC-3's generic one — a
message-content assertion, not merely an exit-code assertion.

### F-B (architect-decided, propagated) — degenerate `FieldOption` entries never dropped

Per ADR-0019 § Amendment F-B / `architecture-delta-field-dx.md` §9 F-B (architect-owned design
decision, already landed — this round propagates the BC-body consequences only):

- `cross-cutting.md`, BC-X.14.001: `FieldOption.id`/`.label` contract changed from `String` to
  `Option<String>` (faithful pass-through of the already-optional `AllowedValue.id`/`.value`
  input shape, not a new sentinel). New EC-X.14.001-7 (never-drop invariant, sibling to
  EC-X.14.001-4's `children`-always-present contract): both normalizers MUST emit exactly one
  `FieldOption` per source item regardless of which fields it carries — a missing `id`/`label`
  degrades that entry's OWN field(s) to `None`, never causes the entry to be dropped from the
  array. VP-580-005 flagged (STRENGTHENED note added) to additionally assert entry-count
  preservation, the exact `None`→JSON-`null` shape, and the two pinned rendering strings.
- `cross-cutting.md`, BC-X.14.003: new "Degenerate-entry rendering" subsection — table mode:
  missing `id` → `NULL_GLYPH` (`"—"`, reusing `changelog.rs`'s existing convention); missing
  `label` → literal `"(unnamed)"` (never a fallback to `id`, since `id` may also be absent on the
  same entry). JSON mode performs NO substitution — `null` stays `null`. VP-580-008 gains a (d)
  sub-point asserting both pinned strings and the JSON `null` counterpart.

### F-LOW-1 — BC-X.14.004 incomplete-M2 message widened

`cross-cutting.md`. `"--type requires --project"` contradicted D1's own "no flag AND no default"
trigger by naming only the flag as the fix. Widened to `"--type needs a resolvable project — pass
--project <P> or configure a default"` at both sites (the taxonomy table row and VP-580-004's own
regression-guard description).

### F-LOW-4 — BC-3.3.010 EC-3.3.010-6 create-path example used edit-only `add:` prefix

`bc-3-issue-write.md`. The example `--component add:X --field components:name=Y` used `add:`/
`remove:` prefix syntax, which is `issue edit`-only (BC-3.4.006); on `issue create`, `--component`
takes a bare name/id with no prefix grammar, so `add:X` would be treated literally as a component
named `"add:X"` rather than illustrating the collision. Changed to `--component X --field
components:name=Y`, with an inline note explaining why.

### O-1 — cascading `>` unsupported on the JSM `:option` path, documented

`bc-3-issue-write.md`, BC-3.8.008: new EC-3.8.008-1. `--request-type RT --field
cf:option=Parent>Child` has no JSM `>`-split site anywhere in the dispatch — the whole
`"Parent>Child"` string is wrapped verbatim as `{"cf": {"value": "Parent>Child"}}` (best case:
server-side 400 or silent no-match). Cascading selects are explicitly NOT supported on the JSM
path this cycle; tracked as an open design question in this document, not a defect.

### O-2 — hinted `--field cf:option` with no `=` documented as the pre-existing missing-`=` case

`bc-3-issue-write.md`, BC-3.8.008: new EC-3.8.008-2. `--field cf:option` (no `=` at all) never
reaches hint-kind parsing (BC-3.4.026 step 2) — `parse_field_kv` step 1 fails to find `=` first,
so this resolves to the pre-existing "invalid field format: expected NAME=VALUE" exit-64, not a
BC-3.4.031 hint-syntax error. Applies identically on the platform path.

### O-3 — createmeta/enumeration 400 row added to BC-X.14.004

`cross-cutting.md`. New taxonomy-table row + EC-X.14.004-7: an M2 invocation where BOTH earlier
lookups (project resolution, `--type` name→id resolution) already succeeded, but the SAME
`issueTypeId` is then rejected (400) by the later `get_createmeta_fields` call — e.g. the issue
type is removed from the project's scheme in the window between the two calls. Distinct from the
existing 404-project-not-found row (F-Pass2-F2) and the unknown-`--type` row (EC-X.14.004-4,
which fires on the FIRST call, before any `issueTypeId` exists) — this row's precondition is that
two earlier calls already succeeded against the same identifiers. Propagated as a standard
`JrError` API-error mapping (exit 1), not a `jr`-produced exit-64.

### prd-delta cleanup (F-LOW-2 / F-LOW-3)

This document's own round-2 section, above: the "VP total stays 29" line corrected to reflect the
reconciled **30** (VP-580-012, minted for the `--project` 404 taxonomy row, was the missing
count); the "flagged for the verifier... whether this new row warrants a dedicated new VP number"
open question is RESOLVED (VP-580-012 minted, not folded into VP-580-004); the stale "verifier's
job to rewrite VP-580-006 §2's 4-boolean signature" note is marked DONE (that rewrite is already
reflected in the frozen `verification-delta-field-dx.md`, per this round's briefing).

### Verifier flags (this round)

- **VP-578-013** (`bc-3-issue-write.md`) — MUST be rewritten to scope its empty-value→exit-64
  assertion to `:asset` (EC-2a) ONLY; its `prop_oneof!` strategy MUST generate all four kinds
  (currently omits `:name`). VP-578-005 (empty value allowed at the parser) stays green and is
  now the consistent, general-case counterpart.
- **VP-578-012** (`bc-3-issue-write.md`, BC-3.4.030) — §2 must be aligned to the new EC-2d
  (`W:Y:Z`) fixture and its extra-colon-specific message wording, not EC-3's generic "objectId
  must be numeric" substring.
- **VP-580-005** (`cross-cutting.md`, BC-X.14.001) — strengthen from "no panic" to also assert
  entry-count preservation, the exact `Option::None`→JSON-`null` shape, and (integration-level,
  paired with BC-X.14.003's VP-580-008(d)) the two pinned table-rendering strings.

### Counts confirmed unchanged

`bc-3-issue-write.md`: 123 individually-bodied / 152 cumulative (frontmatter unchanged this
round). `cross-cutting.md`: 89 individually-bodied / 155 cumulative (frontmatter unchanged this
round). `total_bcs`: 719. Zero BCs added, removed, or retired this round — every change above is
an in-place body amendment, an embedded edge case (EC-N addition), or a message/H1-text
correction.

## 2026-08-26 F2 adversary-convergence round-4 amendments

A 3-pass adversarial streak plus a comprehensive consistency-validator sweep against round-1/2/3's
amendments found six residual defects — mostly partial-fix propagation gaps of this same session's
own D1/D2/D3/F-B fixes — plus one architect-resolved design fork (D4, ADR-0019 § Amendment
2026-08-26, propagated here). Fixed in `bc-3-issue-write.md` and `cross-cutting.md` only, per this
round's write scope, plus ONE targeted one-line edit to
`.factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md` (§1's
`has_project` note — nothing else in that file touched; the architect's D4 content is final and
unmodified). `verification-delta-field-dx.md`, `architecture-delta-field-dx.md`,
`BC-INDEX.md`/`CANONICAL-COUNTS.md` are untouched by this agent this round (verifier and
state-manager reconcile those next). **No BCs added, removed, or retired — counts are unchanged:
`bc-3-issue-write.md` stays 123/152, `cross-cutting.md` stays 89/155, `total_bcs` stays 719.**

### MED-1/F-3 — platform-vs-JSM collision-guard scope, made explicit everywhere it was implicit

**Defect:** EC-3.4.029-2 (`bc-3-issue-write.md`, BC-3.4.029) stated "the CREATE path... does NOT
last-wins" UNQUALIFIED — contradicting BC-3.8.008, where JSM create IS last-wins (the D2 guard was
always intended as platform/non-JSM-only, per ADR-0019 § Amendment D2's own framing of "extend Gate
B to the create path," which — read in isolation, without BC-3.8.008's own unchanged text — could
be misread as covering the JSM create path too, since `jr issue create` is one command with a
dispatch fork inside it, not two separate commands).

**Fix:**
- `bc-3-issue-write.md`, BC-3.4.029 EC-3.4.029-2: explicitly scoped to "the PLATFORM (non-JSM)
  CREATE path (`jr issue create` WITHOUT `--request-type`)"; added an explicit statement that the
  JSM create path does NOT get this guard and cross-referenced BC-3.8.008.
- `bc-3-issue-write.md`, BC-3.4.017 (Gate B): the D2 amendment paragraph and EC-3.4.017-16's
  cross-reference to BC-3.4.029 EC-3.4.029-2 both gained explicit "PLATFORM (non-JSM)" qualifiers
  and a sentence stating the JSM path is unaffected.
- `bc-3-issue-write.md`, BC-3.3.010 Invariant 5: added an explicit sentence stating this BC (and
  therefore its D2 guard) governs the platform path only, per the BC's own title/Preconditions,
  and that the JSM path retains BC-3.8.008's last-wins behavior.
- `bc-3-issue-write.md`, BC-3.3.011: the D2 error-taxonomy row gained an explicit
  "PLATFORM (non-JSM) path only" qualifier plus a "does NOT apply on the JSM create path" clause.
- `bc-3-issue-write.md`, BC-3.4.014: the D2 amendment sentence in the `--field NAME[:kind]=VALUE`
  echo bullet gained an explicit platform-only scope statement.
- `bc-3-issue-write.md`, BC-3.8.008: **new paragraph** ("D2 collision guard does NOT apply on this
  (JSM) path — this BC's 'duplicate NAME → last wins' behavior is UNCHANGED and retained")
  explicitly justifying JSM's retained last-wins behavior: JSM's dedicated-flag semantics already
  diverge from the platform path (several dedicated flags are silently IGNORED on JSM per
  BC-3.8.010/BC-3.8.011, not merged onto the wire at all), so a platform-shaped "same wire key, two
  sources" collision does not arise identically for those flags. Extending the D2 guard to the JSM
  flags that ARE merged onto the wire (`--summary`/`--description`/`--priority`/`--label`) is
  explicitly flagged as an open, DEFERRED decision for the F2 human gate — not silently decided
  either way by this round.
- **Proactive grep performed** (per task instruction) across `bc-3-issue-write.md` for every other
  unqualified "create path"/"create-path collision guard" mention of the D2 guard — all remaining
  occurrences live inside BC-3.3.010/BC-3.3.011 (whose own titles/Preconditions already scope them
  to the platform path structurally) or the `Platform-Path Guard Ordering — handle_create` SSOT
  block (whose own heading already says "Platform-Path"); no further unqualified occurrence found
  outside the ones fixed above.

### F-1 — `--value` filter × F-B's `Option<String>` reconciled

**Defect:** BC-X.14.002's `--value` filter was written as if `id`/`label` are always populated
strings, but F-B (round-3) made them `Option<String>` (a never-dropped `{id:None,label:None}` entry
is legal per EC-X.14.001-7). The filter's substring-match semantics against a `None` field, and the
`--value ""` IDENTITY claim's interaction with a fully-degenerate entry, were both unspecified.

**Fix (`cross-cutting.md`, BC-X.14.002):**
- New "Filtering against `Option<String>` fields" paragraph: a `None` field is simply NOT a match
  source — skipped in the substring test, never causing a panic, never itself causing the entry to
  be dropped. For a NON-EMPTY `--value`, an entry with one `None` field can still match via its
  remaining `Some` field; an entry with BOTH fields `None` cannot match a non-empty substring (no
  candidate string exists) and is filtered out as an ORDINARY substring miss — explicitly stated
  NOT to be a violation of the never-drop invariant, which governs the normalizer's output
  (BC-X.14.001), not this separate client-side filter's expected narrowing.
- `--value ""` IDENTITY claim reconciled with never-drop: rewritten to state explicitly that the
  empty-string case matches EVERY entry unconditionally, INCLUDING a `{id:None,label:None}` entry —
  i.e. `--value ""` output == `--value`-absent output, preserving never-drop through the filter.
  Made explicit that this is a deliberate special case (an unconditional match when the substring
  itself is empty), not a restatement of "every `Some(String)` contains the empty substring" (which
  would NOT, by itself, cover a fully-`None` entry that has no `Some` string to test at all).
- VP-580-007 gained three new sub-points (g/h/i) asserting the `None`-field match/skip behavior and
  the degenerate-entry inclusion/exclusion split between empty-string and non-empty `--value`.

### F-2/D4 propagation — architect-decided, propagated into BC bodies

Per ADR-0019 § Amendment D4 (adversary tag F-2, architect-resolved, this round propagates the
BC-body consequences only — the architectural decision itself is NOT re-litigated here):

- **Cell (a) — non-cascading-field collision** (`bc-3-issue-write.md`, BC-3.4.027): the `>` split
  stays UNCONDITIONAL (confirms D3); the non-cascading case is now detected STRUCTURALLY (matched
  parent's `children` collection is empty), never via a `schema.type` lookup. New paragraph
  ("Non-cascading-field collision") added after the Multibyte-safety MUST paragraph; new Invariant
  6; new **EC-3.4.027-7** (sibling to EC-3.4.027-2/3, NOT a widening of either) pinning the exact
  message substrings `"is not a cascading select"` and `"remove the"`; VP-578-008 extended with a
  flag for the verifier to add message-assertion coverage; Trace updated to cite the
  `AllowedValue.children: Vec<AllowedValue>` (`#[serde(default)]`) type extension this decision
  pins on `src/types/jira/editmeta.rs::AllowedValue`.
- **Cell (b) — bare-form `>`-literal asymmetry** (`bc-3-issue-write.md`, BC-3.4.015): new paragraph
  ("`>` is a LITERAL character in the bare form") added after the existing Hint-syntax-interaction
  amendment note, stating explicitly that the bare form never splits on `>` — a bare
  `--field cf=Parent>Child` against a cascading field is matched as ONE opaque candidate string,
  falls through to the existing EC-3.4.016-2 unresolvable-value error; a cascading field's child can
  ONLY be set via the explicit `:option` form. Cross-references BC-3.4.027 EC-3.4.027-7 and ADR-0019
  § Amendment D4.

**VP implication for the verifier (flagged, not resolved here):** a new/extended VP (sibling to
VP-578-008) is needed asserting (i) EC-3.4.027-7's exact message substrings on a plain
non-cascading `option` field whose `VALUE` contains a `>` where the parent segment resolves
successfully; (ii) the bare-form-treats-`>`-as-literal behavior — a wiremock/fixture assertion that
bare `--field cf=Parent>Child` against a cascading field never attempts a split and falls through to
the existing EC-3.4.016-2 shape. Not authored here.

### LOW-1/O-1 — `:asset` intra-composer check order pinned deterministic

**Defect:** `--field cf:asset=:` and `cf:asset=:Y:Z` each match BOTH the empty-workspace EC (EC-2c)
and an objectId-shaped EC (EC-2b's empty-objectId / EC-2d's extra-colon) — the message was
ambiguous for these two overlapping inputs (exit code 64 either way, only the message text was
undetermined).

**Fix (`bc-3-issue-write.md`, BC-3.4.030 Parsing rule 2 + BC-3.4.031 EC-2c):** pinned a deterministic
check order — the empty-workspace-segment check (EC-2c) is evaluated BEFORE the objectId-segment
checks (EC-2b/EC-3/EC-2d), so an input matching both conditions ALWAYS surfaces EC-2c's
"workspace segment cannot be empty" message. Added to both BC-3.4.030's Parsing rule 2 and
BC-3.4.031's EC-2c entry (cross-referencing each other) so the ordering rule is visible from either
BC.

### O-2 — M3 numeric-bypass edge documented in `jr field options`

**Fix (`cross-cutting.md`, BC-X.14.001):** new paragraph after the M3 service-desk resolution step
paragraph, documenting that M3 inherits `jr requesttype fields`'s all-ASCII-digit numeric-bypass
convention unmodified (per CLAUDE.md's existing documented edge case) — a request type NAMED e.g.
`"100"` is unreachable by name on the M3 path; the caller must discover its numeric ID via
`jr requesttype list --output json | jq`. Explicitly noted as a pre-existing, inherited `jr`
behavior, not a new defect introduced by BC-X.14.001.

### #5 — ADR-0019 §1 `has_project` note gains an inline superseded pointer

**Fix (TARGETED, `.factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md`,
§1 ONLY):** the `has_project` note's bullet-list lead-in gained the inline marker
`**[superseded 2026-08-26 — see Amendment D1]**` immediately after its bold lead-in. No other text
in ADR-0019 was touched by this agent this round — the architect's D4 (and D1/D2/D3/F-B) content in
the Amendment section is final and unmodified.

### MED-2 — flagged for state-manager, NOT fixed here

`BC-INDEX.md`'s BC-X.14.001 row prose still reads "REQUIRED for M2, OPTIONAL for M3" — stale,
pre-D1 wording that contradicts both the bracketed H1 synopsis (`--type <T> [--project <P>]`,
already corrected in `cross-cutting.md` per F-MED-2) and D1's own flag-OR-profile-default parity
decision. **This agent did NOT edit `BC-INDEX.md`** (out of write scope this round — state-manager
owns index reconciliation). Flagged here for the state-manager to correct the row prose to
something in the shape of "companion for M2 (flag OR profile/config default), companion for M3."

### Counts confirmed unchanged (round-4)

`bc-3-issue-write.md`: 123 individually-bodied / 152 cumulative (frontmatter unchanged this round).
`cross-cutting.md`: 89 individually-bodied / 155 cumulative (frontmatter unchanged this round).
`total_bcs`: 719. Zero BCs added, removed, or retired this round — every change above is an
in-place body amendment, an embedded edge case (EC-N addition, e.g. EC-3.4.027-7), a deterministic
check-order pin, or a documentation-only note. The one ADR-0019 edit is a single inline marker, not
a content change to the Amendment section's substance.

### VP implications for the verifier (flagged, not resolved here — full summary)

- **MED-3 / VP-578-013** (`bc-3-issue-write.md`, carried forward from round-3, F-A): still MUST be
  rewritten to scope its empty-value→exit-64 assertion to `:asset` (EC-2a) ONLY, and its
  `prop_oneof!` strategy MUST generate all four kinds (currently omits `:name`). Not touched this
  round — restated here for the verifier's consolidated picture, no new change.
- **F-1 / VP-580-007** (`cross-cutting.md`): new sub-points (g)/(h)/(i) above require realization —
  a `None`-field filter case (matches via the remaining `Some` field; excluded when neither field
  contains the substring) and the degenerate-entry (`{id:None,label:None}`) inclusion/exclusion
  split between `--value ""`/absent (included) and any non-empty `--value` (excluded).
- **F-2/D4** (`bc-3-issue-write.md`): a new VP (sibling to VP-578-008) for EC-3.4.027-7's message
  substrings (non-cascading `>` collision) and for the bare-form `>`-literal behavior (D4 cell b) —
  not authored here, flagged for the verifier.
- **VP-580-012** (`cross-cutting.md`, carried forward from round-2/round-3): already minted and
  DONE — no new change this round; restated only to confirm it remains closed, not reopened by this
  round's edits.

## Traceability

- Source issues: `gh issue view 580`, `gh issue view 578` (both read directly during this pass).
- F1 inputs: `.factory/phase-f1-delta-analysis/delta-analysis-field-dx.md`,
  `.factory/phase-f1-delta-analysis/field-dx-bc-mapping.md`.
- Research inputs (authoritative per orchestrator instruction):
  `.factory/research/field-dx-feasibility-2026-08-25.md`,
  `.factory/research/field-dx-context-mechanism-2026-08-25.md`.
- Modified spec files: `.factory/specs/prd/bc-3-issue-write.md`,
  `.factory/specs/prd/cross-cutting.md`, `.factory/specs/prd/BC-INDEX.md`,
  `.factory/specs/prd/CANONICAL-COUNTS.md`.
- No `.factory/specs/prd.md` file exists in this repo (PRD is sharded across
  `.factory/specs/prd/*.md` with `BC-INDEX.md` as the master index and `README.md` as an
  informational, non-enforced document map) — `BC-INDEX.md` and `CANONICAL-COUNTS.md` are the
  enforced sources of truth per `scripts/check-bc-cumulative-counts.sh` and were updated
  accordingly. `README.md` was deliberately left untouched (informational only, already has
  documented pre-existing drift per its own text) to avoid widening scope.

## Verification note

This agent's tool profile is `read`/`write`/`edit`/`apply_patch` only — no `exec`. Per-file
`#### BC-` heading counts were verified via read-only inspection during authoring (bc-3:
115→123; cross-cutting: 85→89) and cross-checked against the updated frontmatter/BC-INDEX/
CANONICAL-COUNTS values in this delta, but `scripts/check-spec-counts.sh` and
`scripts/check-bc-cumulative-counts.sh` were **not executed** by this agent (both require shell
execution, outside this agent's tool profile). The orchestrator/state-manager should run both
scripts to formally reconcile before treating this delta as fully verified, per the task's own
instruction ("the state-manager will reconcile indexes later").
