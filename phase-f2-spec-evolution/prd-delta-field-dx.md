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
body amended: `--field` echo-suppression removed per DEC-307 reversal; `--on-behalf-of`
suppression retained), BC-3.4.015, BC-3.4.016, BC-3.4.017 (**[AMENDED 2026-08-25 issue #578 F2,
adversary pass-13 F-1]** Gate B's flag-overlap matching extended to hint-tagged `--field
NAME:kind=VALUE` pairs, closing a contradiction with BC-3.4.029 EC-3.4.029-2 — new
EC-3.4.017-16), BC-3.8.001, BC-3.8.008 (interaction/amendment notes), BC-3.8.013 (amended in
place — body propagation of combined-guard removal; guard BEHAVIOR unchanged), and
**BC-3.8.012 (full reversal)**.

**1 governance flag raised**: BC-3.8.012's reversal of DEC-188 (a deliberate breaking change
shipped ~1 month prior, 2026-07-25) requires its own formal decision entry. **Proposed ID:
DEC-307** (next sequential after the highest DEC number found across the live spec tree,
DEC-306, per a `grep -rohE "DEC-[0-9]{3}"` survey run during this pass). This repo has no
centralized DEC registry file — DEC numbers are assigned inline in spec prose by convention —
so DEC-307 is a **proposal**, not yet a registered decision. The orchestrator/state-manager
should register it formally and must not let a future pass silently reuse DEC-307 for an
unrelated decision.

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
| **BC-3.4.014** | DEC-188-qualifier body amended: `--field` echo-suppression removed per DEC-307 reversal; `--on-behalf-of` suppression retained. Precondition's `[DEC-188 qualifier]` note updated to reflect that a bare `--field` no longer triggers a step-2 exit-64 guard and its resolved value IS echoed (per BC-3.3.010 step 6); only `--on-behalf-of` present without `--request-type` still suppresses the echo via BC-3.8.013. BC-INDEX row propagated in the same commit. | bc-3-issue-write.md |
| **BC-3.4.015** | Amendment note added: this BC's algorithm is now explicitly the BARE-form (`kind: None`) dispatch, permanent and unchanged; hint-syntax interaction documented, pointing to BC-3.4.026-031. Per ADR-0019 §2: `field_pairs` changes to `&HashMap<String, FieldValueSpec>` (bare-name key, last-wins on the whole spec); `resolve_edit_fields` reads each entry's `spec.kind` and takes the hinted-bypass branch before falling through to the existing `schema.type` match when `spec.kind == None`. | bc-3-issue-write.md |
| **BC-3.4.016** | Amendment note added: same bare-form/permanence framing for the `option`-type dispatch; explicit opt-in spelling is `:option` (BC-3.4.027); `:id` hint is the explicit spelling of this BC's own Step-1 id-bypass. | bc-3-issue-write.md |
| **BC-3.8.008** | Amendment note added: hint-kind syntax applies uniformly on the JSM create path too (resolves the F1 research/BA open question — decided YES, uniform application, since `parse_field_kv` is shared); wire target substituted to `requestFieldValues`; bare-form output is byte-identical, unchanged. New VP-578-015/016 pin the regression/parity guarantees. | bc-3-issue-write.md |
| **BC-3.8.012** | **FULL REVERSAL.** DEC-188's `--field`-alone platform-path exit-64 pre-flight guard (and the combined `--field`+`--on-behalf-of` guard, which loses its trigger) is removed. Old DEC-188 contract preserved verbatim inline as `[DEC-188 BEHAVIOR, superseded 2026-08-25]` for audit trail (mirrors the append-only convention this BC already used once, for the pre-DEC-188 #383 warn-and-proceed text). New `[CURRENT BEHAVIOR — effective 2026-08-25]` section added: `--field` alone now resolves via createmeta (BC-3.3.010) instead of erroring. H1 heading updated to reflect the reversal. **Governance flag: DEC-307 proposed** (see Summary above). | bc-3-issue-write.md |
| **BC-3.8.001** | §3.8 section preamble (3 sites) and BC-3.8.001's own H1 heading + amendment note scoped the surviving exit-64 guard to `--on-behalf-of` only, matching BC-3.8.012's reversal — the stale `--field`/`--on-behalf-of` combined phrasing (pre-reversal wording) is replaced with `--on-behalf-of`-only phrasing plus a `[reversed 2026-08-25 issue #578 DEC-307: --field no longer exits 64 — resolves via createmeta per BC-3.3.010/BC-3.8.012]` note at each site. No behavioral change to BC-3.8.001 itself — this closes a straggler where the BC-INDEX row (already corrected) and BC-3.3.001 H1 (already corrected) had moved on but this file's body text had not. | bc-3-issue-write.md |
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
   question closed — it proposes **DEC-307** and flags it for the orchestrator to register
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
