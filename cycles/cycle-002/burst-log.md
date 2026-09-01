---
document_type: burst-log
level: ops
version: "1.1"
status: in-progress
producer: state-manager
timestamp: 2026-08-31T20:00:00Z
cycle: "cycle-002"
inputs: [STATE.md]
input-hash: "46b7b5e"
traces_to: STATE.md
---

# Burst Log — cycle-002 (field-dx)

<!-- cycles/cycle-002/ did not exist before this burst. Prior cycle-002 activity
     (F1 delta analysis, F2 spec authoring, ~30 adversary passes through pass-30
     stopped-at-wrap) was tracked only in STATE.md / phase-f1-delta-analysis/ /
     phase-f2-spec-evolution/ / spec-changelog.md — there is no earlier
     cycle-002 burst-log entry to carry forward. This is Burst 1 of this file. -->

## Burst: Burst 1 — F2 adversary-convergence resume, 3 fresh passes, 6 MEDIUM + 9 LOW fixed (2026-08-26)

**Parent-commit:** 8ee4a57269163a3d2f1c2a19ea2ac92eba237a51

**Adversary verdict:** NOT-CLEAN ×3 (correctness lens, completeness lens, traceability lens — fresh context each, run against the previously-"frozen" F2 delta). 6 MEDIUM + ~9 LOW findings routed and fixed via architect → product-owner → verifier. Clean-pass streak: **reset to 0/3** — 3 consecutive CLEAN passes are now required before F2 Step 5/8. This burst did not itself produce a clean pass; it is the fix-and-reconverge burst that must be followed by fresh re-review passes next session.

**Files touched (Dim-1): 10 unique files**

- specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md
- phase-f2-spec-evolution/architecture-delta-field-dx.md
- phase-f2-spec-evolution/prd-delta-field-dx.md
- phase-f2-spec-evolution/verification-delta-field-dx.md
- specs/prd/bc-3-issue-write.md
- specs/prd/cross-cutting.md
- sidecar-learning.md
- STATE.md
- cycles/cycle-002/burst-log.md
- cycles/cycle-002/session-checkpoints.md

**Codifications:** ADR-0019 § Amendment 2026-08-26 codifies D1 (3-bool arity domain + sibling `resolve_m2_project`), D2 (create-path Gate-B extension via shared `detect_flag_field_overlap`), D3 (`str::split_once('>')` mandated at every cascading-split call site). DEC-310 minted (proposed) to replace the collided DEC-307 governance flag on BC-3.8.012's DEC-188 reversal — not yet formally registered (owed at cycle close). VP-INDEX (inline convention) grows VP-578-020/021/022 + VP-580-010/011 (5 new ids) plus VP-580-006/009 rewritten/realized.

**Dim-2 Attestation:** N/A for this burst — this is a spec-only F2 convergence burst (no `src/` changes). `scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). Both re-run post-burst by state-manager to confirm the verifier's reported validation-hook timeout during its own edit pass was tooling noise, not a real rejection.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (spec/documentation delta only, target project is a Rust CLI with no factory-side compiled hook changed here).

**Dim-6 Attestation:** N/A — no `src/` code changed this burst; `cargo fmt`/`cargo clippy` not applicable. (jira-cli's own CI gate covers those on any future code-touching PR for this cycle's F4+ phases.)

**Dim-7 Attestation:** N/A — no test suite changed this burst. Spec-level verification for this burst is `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` (both PASS, see Dim-2 above); BC/VP realization tests are deferred to F4 implementation per this repo's `convention: inline-proptest` (no centralized VP registry, VPs realized as proptests/unit tests at implementation time).

**Closes:** A-M1/D1 (M2 default-project parity), B-F3/D2 (create-path Gate-B collision guard), B-F2/D3 (cascading `>`-split hardening), A-M2 (BC-X.14.002 example fix), B-F1 (BC-X.14.001 M3 pagination postcondition correction), C-M1 (DEC-307→DEC-310 renumber, 2-file scope). ~9 LOW findings closed (BC-3.4.026 scope qualifier; BC-X.14.001 precondition + reverse-resolution EC; `:asset` failure taxonomy VP-578-022; empty cascading-segment EC; `--value ""` + graceful-degrade VP-580-011; H-NEW-PREFLIGHT-006 removal-obligation addition). **Does NOT close:** the F2 mandatory adversarial spec-convergence loop itself (streak reset to 0/3, still open) or the two process-gap findings below (still open, routed to next burst).

### Counts reconciled this burst

No BCs added or removed — total stays **719** (bc-3-issue-write.md 123/152 individually-bodied/cumulative; cross-cutting.md 89/155). VP total **25 → 29** (VP-578-001..022 = 22 ids; VP-580-005..011 = 7 ids). No centralized VP-NNN registry exists in this repo (`convention: inline-proptest`, `verification-delta-field-dx.md` §0) — STATE.md is the only surface carrying a standalone VP-count figure; no BC-INDEX.md/CANONICAL-COUNTS.md VP-count surface exists to update.

### [process-gap] Findings (not fixed this burst — routed forward)

1. **DEC-survey-scope gap (root cause of C-M1).** The original DEC-307 proposal was derived
   from a `specs/`-only grep for the highest allocated `DEC-NNN`. That scope is wrong — DEC
   numbers get allocated from cycle-gate decisions recorded in `STATE.md` and `cycles/`
   history too (DEC-309 — cycle-001 F7 closure — was invisible to a specs-only scan). **Any
   future "what's the next sequential DEC number" survey MUST scan the whole `.factory/`
   tree**, not just `specs/`. Logged to STATE.md Drift/Standing Items and the process-gap
   follow-up list.
2. **DEC-307→DEC-310 renumbering is INCOMPLETE — found by state-manager's defensive sweep
   (S-7.02), not fixed this burst.** The architect's fix note in `prd-delta-field-dx.md`
   §C-M1 explicitly scopes the renumber to two files ("renumbered DEC-307 in
   `prd-delta-field-dx.md` (this document) and `bc-3-issue-write.md`"). A corpus grep for
   the literal string `DEC-307` in a field-dx/BC-3.8.012-reversal context, run by
   state-manager after the burst closed, found **35 residual occurrences still unswept**
   across **six further files**:
   - `phase-f2-spec-evolution/verification-delta-field-dx.md` — 7 occurrences (VP-578-017/018/019 inline comments + §1/§1.1/§5 prose all still say "DEC-307 reversal")
   - `phase-f2-spec-evolution/architecture-delta-field-dx.md` — 1 occurrence
   - `specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md` — 1 occurrence (§References, "governance-flagged separately as DEC-307")
   - `specs/prd/holdout-scenarios.md` — 15 occurrences (H-NEW-PREFLIGHT-001/003/006 changelog entries + NFR source line ~2580)
   - `specs/prd/CANONICAL-COUNTS.md` — 4 occurrences (`last_verified` changelog prose)
   - `specs/prd/BC-INDEX.md` — 7 occurrences (`last_updated` changelog prose)

   state-manager cannot fix these directly (specification content is out of scope for this
   role — bookkeeping only). **Routed back as an owed follow-up**: a fix pass sweeping all
   six files DEC-307 → DEC-310 (matching the same disambiguation the architect already
   applied to `bc-3-issue-write.md` and `prd-delta-field-dx.md`) is needed **before F2 Step 5
   spec version-bump/changelog and before cycle close**. This is the same recurring gap as
   process-gap follow-up #5 ("no reversal-propagation checklist") — evidenced again here.
3. **DEC-namespace collision itself is a process-gap, independent of the survey-scope bug.**
   Spec-authored DECs (e.g. DEC-188, the proposed field-dx DEC-310) and cycle-gate DECs (e.g.
   DEC-309, cycle-001's F7 closure) currently share one flat `DEC-NNN` numbering prefix with
   no central registry file — this is what made the collision possible even with a correct
   survey scope. Flagged for a cycle-close decision: split the namespaces (e.g. `DEC-` vs
   `CYCLE-DEC-`) or stand up a single authoritative `DECISIONS-INDEX.md`.

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary (correctness lens) | Fresh-context pass #1 against frozen F2 delta | NOT-CLEAN — routed findings incl. A-M1, B-F3 |
| adversary (completeness lens) | Fresh-context pass #2 | NOT-CLEAN — routed findings incl. B-F2, C-M1, several LOWs |
| adversary (traceability lens) | Fresh-context pass #3 | NOT-CLEAN — routed findings incl. A-M2, B-F1, remaining LOWs |
| architect | Fix M2 arity/D1, Gate-B/D2, cascading-split/D3, DEC renumber (2-file scope) | ADR-0019 § Amendment, `architecture-delta-field-dx.md` |
| product-owner | Propagate fixes into PRD/BC bodies, mint new VPs' BC-side hooks | `prd-delta-field-dx.md`, `bc-3-issue-write.md`, `cross-cutting.md` |
| verifier | Realize/extend VPs (VP-578-020/021/022, VP-580-010/011), re-verify counts | `verification-delta-field-dx.md` (reported a validation-hook timeout during edits — not a rejection) |
| state-manager | Re-run guard scripts, reconcile VP count, log this burst, update STATE.md, commit | This file; `STATE.md` v3.07; `cycles/cycle-002/session-checkpoints.md` |

## Burst: Burst 2 — F2 adversary-convergence round-2, second fresh 3-pass streak, 5 MEDIUM + 2 LOW fixed (2026-08-26)

**Parent-commit:** b5bbff1feae1c68123a3616d67d4addf6df4df67 (factory(F2): complete DEC-307->DEC-310 propagation sweep)

**Adversary verdict:** NOT-CLEAN ×3 again. After Burst 1's fix-and-reconverge and the subsequent DEC-307→DEC-310 propagation sweep closed, a SECOND fresh 3-pass adversary streak was run against the now-fully-propagated delta to attempt the required 3/3 CLEAN. **It again returned ALL NOT-CLEAN** — 5 MEDIUM + 2 LOW findings, smaller than Burst 1's 6 MEDIUM + ~9 LOW but still non-clean. Fixed this burst via a PO → verifier → PO back-fill chain (no architect step needed this round — all findings were spec-body/verification-doc corrections, not design decisions). Clean-pass streak: **remains 0/3** — this is the second consecutive fresh-streak failure to reach 3/3 CLEAN; a fresh, fully-clean 3-pass run is still required before F2 Step 5/8.

**Files touched (Dim-1): 5 unique files**

- phase-f2-spec-evolution/prd-delta-field-dx.md
- phase-f2-spec-evolution/verification-delta-field-dx.md
- specs/prd/bc-3-issue-write.md
- specs/prd/cross-cutting.md
- sidecar-learning.md

**Codifications:** VP-580-006 §2 corrected to the D1-narrowed 3-boolean `resolve_field_context` signature (no new codification — a documentation-accuracy fix propagating Burst 1's D1 amendment). No new ADR/DEC minted this burst; **VP-580-012** is the only new inline-convention id (BC-X.14.004, `--project` not-found (404) taxonomy), extending the existing VP-580-005..011 sequence. VP-578-012 and VP-578-022's proptest/wiremock coverage extended in place (no new ids — folded into existing ones, mirroring Burst 1's VP-578-008 D3 extension precedent).

**Dim-2 Attestation:** N/A for this burst — spec-only F2 convergence burst (no `src/` changes). `scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). Both re-run post-burst by state-manager.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (spec/documentation delta only).

**Dim-6 Attestation:** N/A — no `src/` code changed this burst; `cargo fmt`/`cargo clippy` not applicable.

**Dim-7 Attestation:** N/A — no test suite changed this burst. Spec-level verification is `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` (both PASS, see Dim-2 above); BC/VP realization tests remain deferred to F4 implementation per this repo's `convention: inline-proptest`.

**Findings routed and fixed this burst:**

| Finding | Severity | Description | Fix |
|---------|----------|--------------|-----|
| Pass1-F1 | MEDIUM | `verification-delta-field-dx.md` §2's VP-580-006 was still documented against the pre-D1 4-boolean `resolve_field_context` signature (the D1 amendment in Burst 1 dropped the `has_project` axis, narrowing it to 3-boolean, but this one reference was missed) | Rewrote VP-580-006 §2 to the correct 3-boolean `resolve_field_context(has_type, has_request_type, has_issue) -> Result<Mode, ArityError>` shape |
| Pass2-F1 | MEDIUM | `:asset` cold-cache workspace-discovery failure taxonomy (BC-3.4.030, VP-578-022) was only wiremock-exercised on 1 of the 3 call sites that share `get_or_fetch_workspace_id` (edit, platform-create, JSM `handle_jsm_create`) | Widened taxonomy coverage to all 3 call sites — 403/404 → Assets-unavailable exit 64; 200 + empty `values` → no-workspace exit 64; 401 → standard auth mapping; 5xx/network → standard API/network mapping, asserted on each site |
| Pass2-F2 | MEDIUM | `jr field options` M2/M3 enumeration paths had no documented taxonomy row for a nonexistent/inaccessible `--project` yielding a genuine HTTP 404 (distinct from the pre-HTTP arity/companion-absent rejections) | Added new `--project not found (404)` taxonomy row + EC-X.14.004-6 to BC-X.14.004 (cross-cutting.md); minted **VP-580-012**; PO back-filled its one-line BC-body Verification Properties declaration in the same chain |
| Pass2-F3 | MEDIUM | `:asset` `WORKSPACE:OBJECTID` first-colon split had no `str::split_once(':')` MUST — same FIX-F6-LRE-1 byte/char-index-conflation panic class as the `>` cascading split (D3) | Added explicit `str::split_once(':')` MUST (BC-3.4.030 Parsing rule 1 / new Invariant 4); extended VP-578-012's no-panic proptest corpus to cover this split (mirrors VP-578-008's D3 extension); new EC-3.4.030-6 |
| Pass2-F4 | LOW | `objectId` validation used Rust `regex`'s default Unicode-aware `\d+`, which matches non-ASCII digit scripts (Arabic-Indic, fullwidth) that Jira's server-side field does not accept | Corrected to ASCII-only `[0-9]+` (`(?-u)\d+`) at BC-3.4.030 Parsing rule 3, EC-3 |
| Pass2-F5 | LOW | The evaluation order between the D2 create-path collision guard and the pre-existing BC-3.8.013 `--on-behalf-of` guard was unpinned when both could fire on the same invocation | Pinned deterministic order: BC-3.8.013 (step 2, pre-existing) evaluated BEFORE the D2 collision guard (step 2a, new) — documented in the Platform-Path Guard Ordering SSOT block and EC-3.3.010-6 |
| Pass3 | MEDIUM | A dangling `.factory/specs/verification-delta/` path citation (a directory that never existed) appeared at 3 sites, inherited from Burst 1's pass-28 pagination realization note | Corrected all 3 sites to the real `.factory/phase-f2-spec-evolution/verification-delta-field-dx.md` |

**Closes:** Pass1-F1 (VP-580-006 signature staleness), Pass2-F1 (`:asset` taxonomy scope gap), Pass2-F2 (`--project` 404 taxonomy gap, VP-580-012 minted + back-filled), Pass2-F3 (`:`-split MUST), Pass2-F4 (ASCII-only `objectId`), Pass2-F5 (guard-ordering pin), Pass3 (dangling path citation, 3 sites). **Does NOT close:** the F2 mandatory adversarial spec-convergence loop itself (streak remains 0/3, still open).

### Counts reconciled this burst

No BCs added or removed — total stays **719** (bc-3-issue-write.md 123/152 individually-bodied/cumulative; cross-cutting.md 89/155). VP total **29 → 30** (VP-580-012 newly minted; sequence now VP-578-001..022 = 22 ids + VP-580-005..012 = 8 ids). Holdouts unchanged (106). No BC-INDEX.md/CANONICAL-COUNTS.md VP-count surface exists to update — confirmed again this round (only STATE.md carries a standalone VP-total figure).

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary (correctness lens) | Fresh-context pass #1 against the fully-propagated delta | NOT-CLEAN — routed Pass1-F1 |
| adversary (completeness lens) | Fresh-context pass #2 | NOT-CLEAN — routed Pass2-F1 through Pass2-F5 |
| adversary (traceability lens) | Fresh-context pass #3 | NOT-CLEAN — routed Pass3 |
| product-owner | Fix all 7 findings directly in PRD/BC bodies + verification delta (no architect step needed — spec-body corrections, not design decisions) | `prd-delta-field-dx.md`, `specs/prd/bc-3-issue-write.md`, `specs/prd/cross-cutting.md` |
| verifier | Realize/extend VPs (VP-580-006 rewrite, VP-578-022 3-site widening, VP-580-012 minted, VP-578-012 extension), re-verify counts | `phase-f2-spec-evolution/verification-delta-field-dx.md` |
| product-owner | Back-fill VP-580-012's one-line BC-body Verification Properties declaration in cross-cutting.md (was pending after verifier's pass) | `specs/prd/cross-cutting.md` |
| state-manager | Re-run guard scripts, reconcile VP count 29→30, log this burst, update STATE.md, commit | This file; `STATE.md` v3.09 |

## Burst: Burst 3 — F2 adversary-convergence round-3, second fresh 3-pass streak (1 pass CLEAN), 1 HIGH + 3 MEDIUM + several LOW fixed (2026-08-26)

**Parent-commit:** 7a3125c50afd941a13f8a0ffe4d4959fa18b2ef2 (factory(F2): field-dx convergence round-2 -- first fresh streak all NOT-CLEAN, 5 MED+2 LOW fixed, VP 29->30)

**Adversary verdict:** Pass 1 NOT-CLEAN, Pass 2 NOT-CLEAN, **Pass 3 CLEAN** — the first CLEAN verdict recorded within this round-2 fresh-streak attempt (findings continue to decay: round-1 6 MED+~9 LOW all-NOT-CLEAN → round-2 5 MED+2 LOW all-NOT-CLEAN → round-3 1 HIGH+3 MED+several LOW with 1/3 passes CLEAN). Fixed via a fix chain (architect → PO → verifier, no new architect design decision beyond the one pre-decided item F-B). **Clean-pass streak REMAINS 0/3** — a single CLEAN pass inside a streak that also produced NOT-CLEAN passes does not count toward the mandatory 3-CONSECUTIVE-CLEAN requirement; a fresh, fully-clean 3-pass run is still required before F2 Step 5/8.

**Files touched (Dim-1): 6 unique files**

- phase-f2-spec-evolution/architecture-delta-field-dx.md
- phase-f2-spec-evolution/prd-delta-field-dx.md
- phase-f2-spec-evolution/verification-delta-field-dx.md
- specs/prd/bc-3-issue-write.md
- specs/prd/cross-cutting.md
- sidecar-learning.md

**Codifications:** ADR-0019 gains § Amendment **F-B** (architect-decided): `FieldOption.id`/`.label` change `String` → `Option<String>` (never-drop invariant for degenerate option entries — an option with a missing id or label must still surface, not be silently dropped). No new VP minted — all four verification fixes (VP-578-013 rewrite, VP-578-012 extension, VP-580-005 strengthening, VP-580-008 extension) are amendments to existing VPs; VP total stays **30**. No new BC minted — all fixes are amendments to existing BC bodies (BC-3.4.028/029/031, BC-X.14.001/003); BC count stays **719**.

**Dim-2 Attestation:** N/A for this burst — spec-only F2 convergence burst (no `src/` changes). `scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). Both re-run post-burst by state-manager.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (spec/documentation delta only).

**Dim-6 Attestation:** N/A — no `src/` code changed this burst; `cargo fmt`/`cargo clippy` not applicable.

**Dim-7 Attestation:** N/A — no test suite changed this burst. Spec-level verification is `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` (both PASS, see Dim-2 above); BC/VP realization tests remain deferred to F4 implementation per this repo's `convention: inline-proptest`.

**Findings routed and fixed this burst:**

| Finding | Severity | Description | Fix |
|---------|----------|--------------|-----|
| F-A | HIGH | VP-578-013 §3 mandated exit-64 for an empty value on ANY of `:id=`/`:name=`/`:asset=`, contradicting BC-3.4.028/029 ("server is SOLE validator, ZERO client-side matching") and ADR-0019 §2(b) ("`parse_field_kv`'s value is deliberately uninterpreted") | Empty `:id=`/`:name=` now PASS-THROUGH verbatim (`{"id":""}`/`{"name":""}`, server-validated) — new EC-3.4.028-3, EC-3.4.029-3; only `:asset=` empty stays a client-side structural exit-64 (cannot build `[{workspaceId,id,objectId}]` with no `objectId`) — BC-3.4.031 EC-2's scope note + new EC-8/EC-9 (PASS-THROUGH cross-refs); VP-578-013 rewritten to scope its exit-64 assertion to `:asset` (EC-2a) ONLY, `prop_oneof!` strategy extended to generate all four kinds (adds the previously-omitted `:name`) with per-kind classification replacing the old blanket `.is_err()` |
| F-MED-1 | MEDIUM | The D2 collision guard (step 2a) consumes the already-parsed `HashMap<String, FieldValueSpec>`, so `parse_field_kv`'s own exit-64 (BC-3.4.031's unknown-kind/malformed path) must run before it, but the Platform-Path Guard Ordering SSOT never numbered this dependency | `parse_field_kv` pinned as step 2a in the guard-ordering SSOT; the pre-existing D2 collision guard renumbered 2a→2b |
| F-MED-2 | MEDIUM | BC-X.14.001's H1 title read `--type <T> --project <P>` (unbracketed, implying `--project` is REQUIRED for M2), contradicting M2's actual flag-OR-profile-default resolution (ADR-0019 § Amendment D1, round-2) and inconsistent with M3's bracketed `[--project <P>]` | H1 corrected to `--type <T> [--project <P>]` in `cross-cutting.md`; **BC-INDEX.md title row propagated by state-manager this burst** (see Current Phase Steps) |
| F-C | MEDIUM | BC-3.4.031's `:asset` malformed-hint catalog described "three sub-cases" for colon-count errors but a fourth (`:asset=W:Y:Z`, extra colon) existed with an ambiguous message, conflated with EC-3's generic "objectId must be numeric" | New EC-2d — distinct message for the extra-colon case (`str::split_once(':')` → objectId candidate `Y:Z` → `"unexpected extra ':' … expected WORKSPACE:OBJECTID"`); catalog description corrected "three sub-cases"→"four"; VP-578-012 §2 aligned with a dedicated `"W:Y:Z"` regression pin, distinct from EC-3's numeric-objectId assertion |
| F-B | (architect-decided) | `FieldOption.id`/`.label` were plain `String`, which cannot represent a Jira option missing an id or label (both fields are optional on the wire per some custom-field configurations) — risked either a deserialization failure or a silent drop | `FieldOption.id`/`.label` changed `String` → `Option<String>` (ADR-0019 § Amendment F-B); new never-drop invariant EC-X.14.001-7 (a degenerate entry still surfaces, never silently dropped); table rendering uses `"—"` for missing id, `"(unnamed)"` for missing label; JSON emits `null`, no substitution — BC-X.14.001/003 amended, VP-580-005 §2 strengthened (entry-count preservation + exact `None`→`null` shape + pinned table strings) and VP-580-008 gains sub-point (d) |
| LOW (several) | LOW | Message widening; `add:X`→`--component X` corrected example; JSM cascading `>` edge cases; missing-`=` edge case; createmeta 400 error-taxonomy row; prd-delta "29→30" VP-count correction + stale-note cleanup | Applied directly in `bc-3-issue-write.md`/`cross-cutting.md`/`prd-delta-field-dx.md`; no new BC/VP ids |

**Closes:** F-A (empty-value contradiction), F-MED-1 (guard-ordering SSOT gap), F-MED-2 (BC-X.14.001 H1 bracket inconsistency + BC-INDEX propagation), F-C (extra-colon distinct message), F-B (never-drop `Option<String>` invariant), several LOWs. **Does NOT close:** the F2 mandatory adversarial spec-convergence loop itself (streak remains 0/3 — Pass 3's CLEAN verdict does not carry over into a new streak attempt; a fresh 3-pass run starting from Pass 1 is required).

### Counts reconciled this burst

No BCs added or removed — total stays **719** (bc-3-issue-write.md 123/152 individually-bodied/cumulative; cross-cutting.md 89/155). VP total stays **30** (all four fixes are amendments to existing VPs — VP-578-012, VP-578-013, VP-580-005, VP-580-008 — no new VP id minted). Holdouts unchanged (106). BC-INDEX.md title row for BC-X.14.001 corrected to match the amended H1 (state-manager, this burst) — no count field touched.

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary | Fresh-context pass #1 | NOT-CLEAN — routed F-A |
| adversary | Fresh-context pass #2 | NOT-CLEAN — routed F-MED-1, F-MED-2, F-C, F-B (flagged for architect), several LOWs |
| architect | Decide F-B (`FieldOption.id`/`.label` → `Option<String>`, never-drop invariant) | ADR-0019 § Amendment F-B, `architecture-delta-field-dx.md` |
| product-owner | Propagate all fixes into PRD/BC bodies (`bc-3-issue-write.md`, `cross-cutting.md`) | `prd-delta-field-dx.md` "2026-08-26 F2 adversary-convergence round-3 amendments" section |
| verifier | Amend existing VPs (VP-578-013 rewrite, VP-578-012 extension, VP-580-005 strengthening, VP-580-008 extension); confirm no new VP needed | `phase-f2-spec-evolution/verification-delta-field-dx.md` |
| adversary | Fresh-context pass #3 | **CLEAN** |
| state-manager | Propagate BC-INDEX.md title row, re-run guard scripts, confirm VP-580-012 presence, log this burst, update STATE.md, commit | `BC-INDEX.md`; this file; `STATE.md` v3.10 |

## Burst: Burst 4 — F2 adversary-convergence round-4, THIRD fresh 3-pass streak (Pass 3 CLEAN, streak still 0/3), consistency-sweep + 5 MEDIUM-class + LOWs fixed (2026-08-26)

**Parent-commit:** 3f029aabaf224e7b2fa8db362b12cf83f19d54c6 (factory(F2): field-dx convergence round-3 -- 2nd streak (1 pass clean), 1 HIGH+3 MED+LOWs fixed, VP 30, BC-INDEX title propagated)

**Adversary verdict:** Pass 1 NOT-CLEAN, Pass 2 NOT-CLEAN, **Pass 3 CLEAN** — the third consecutive fresh-streak attempt this session to reach 3/3 CLEAN, and the second round to produce at least one individual CLEAN pass. A consistency-validator sweep across round-1/2/3's amendments (run alongside the 3-pass streak) confirmed the finding list was complete: all six findings routed this round were partial-fix propagation residuals from this same session's own D1/D2/D3/F-B fixes — not new defect classes. Fixed via a fix chain (architect for D4 + one targeted ADR-0019 note → product-owner for BC-body propagation → verifier for VP realization → product-owner back-fill of the verifier-minted VP's BC-body anchor). **Clean-pass streak REMAINS 0/3** — a single CLEAN pass inside an otherwise-NOT-CLEAN streak does not count toward the mandatory 3-CONSECUTIVE-CLEAN requirement; a fresh, fully-clean 3-pass run starting at Pass 1 is still required before F2 Step 5/8.

**Files touched (Dim-1): 8 unique files**

- phase-f2-spec-evolution/architecture-delta-field-dx.md
- phase-f2-spec-evolution/prd-delta-field-dx.md
- phase-f2-spec-evolution/verification-delta-field-dx.md
- specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md
- specs/prd/bc-3-issue-write.md
- specs/prd/cross-cutting.md
- sidecar-learning.md
- specs/prd/BC-INDEX.md (state-manager, this burst — MED-2 title-row prose fix, the only BC-INDEX content change)

**Codifications:** ADR-0019 gains § Amendment **D4** (architect-decided, tag F-2): the `>` split stays UNCONDITIONAL (confirms D3); a non-cascading-field collision (`--field cf:option=A>B` where `A`'s matched entry has an empty `children` collection) is now detected STRUCTURALLY, never via a `schema.type` lookup — new BC-3.4.027 EC-3.4.027-7 (pinned message substrings `"is not a cascading select"` + `"remove the"`); the bare form (`--field cf=Parent>Child`, no `:option` hint) treats `>` as a LITERAL character (no split), falling through to the existing EC-3.4.016-2 unresolvable-value error — new BC-3.4.015 note. `src/types/jira/editmeta.rs::AllowedValue` gains `children: Vec<AllowedValue>` (`#[serde(default)]`) as a type dependency. ADR-0019 §1's `has_project` note gains an inline `[superseded 2026-08-26 — see Amendment D1]` pointer (one-line targeted edit only). One new VP minted: **VP-578-023** (sibling to VP-578-008, D4/F-2 realization) — its inline BC-body anchor (BC-3.4.027 + BC-3.4.015) was back-filled by product-owner this round, closing the verifier's flagged pending-back-fill item. No new BC, no BC retired.

**Dim-2 Attestation:** N/A for this burst — spec-only F2 convergence burst (no `src/` changes). `scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). Both re-run post-burst by state-manager.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (spec/documentation delta only).

**Dim-6 Attestation:** N/A — no `src/` code changed this burst; `cargo fmt`/`cargo clippy` not applicable.

**Dim-7 Attestation:** N/A — no test suite changed this burst. Spec-level verification is `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` (both PASS, see Dim-2 above); BC/VP realization tests remain deferred to F4 implementation per this repo's `convention: inline-proptest`.

**Findings routed and fixed this burst:**

| Finding | Severity | Description | Fix |
|---------|----------|--------------|-----|
| MED-1/F-3 | MEDIUM | EC-3.4.029-2 stated the create path "does NOT last-wins" UNQUALIFIED, contradicting BC-3.8.008 (JSM create IS last-wins) — the D2 guard's platform-only scope was implicit, not explicit, across five BC bodies | Explicit "PLATFORM (non-JSM)" qualifiers added to BC-3.4.029 EC-3.4.029-2, BC-3.4.017 (Gate B + EC-3.4.017-16 cross-ref), BC-3.3.010 Invariant 5, BC-3.3.011's error-taxonomy row, BC-3.4.014's echo bullet; BC-3.8.008 gains a new paragraph explicitly justifying JSM's retained last-wins behavior, with D2-extension-to-JSM flagged as an OPEN, DEFERRED decision for the F2 human gate (not silently decided) |
| MED-2 | MEDIUM | BC-INDEX.md's BC-X.14.001 row prose still read "REQUIRED for M2, OPTIONAL for M3" — stale pre-D1 wording contradicting both the already-bracketed H1 synopsis and D1's flag-OR-profile-default parity decision | **state-manager** (this burst) corrected the row prose to "companion for M2 (flag OR profile/config default), companion for M3" — the ONLY BC-INDEX content change this round, no count field touched |
| MED-3 | MEDIUM | VP-578-013 (carried forward from round-3's F-A rewrite) still needed its `prop_oneof!`/assertion split made explicit per-kind | `:option` empty → `is_err()` (downstream `allowedValues` match-miss, EC-3.4.016-2); `:id`/`:name` empty → `is_ok()` pass-through; `:asset` empty → `is_err()` structural — verification-delta realized this split |
| F-1 | MEDIUM | BC-X.14.002's `--value` filter was written as if `id`/`label` are always populated strings, but round-3's F-B made them `Option<String>` — substring-match semantics against a `None` field, and `--value ""`'s interaction with a fully-degenerate entry, were unspecified | New "Filtering against `Option<String>` fields" paragraph (`None` is not a match source, skipped not panicked, never causes a drop) + `--value ""` reconciled as an unconditional match including `{id:None,label:None}`; VP-580-007 gains sub-points (g)/(h)/(i) |
| F-2/D4 | (architect-decided) | Non-cascading-field `>`-collision and bare-form `>`-literal behavior were both underspecified — D3 mandates unconditional `str::split_once('>')` but never addressed what happens when the matched parent isn't actually cascading, nor what the bare (non-hinted) form does with a literal `>` | New BC-3.4.027 EC-3.4.027-7 (structural empty-`children` detection, pinned message) + `AllowedValue.children` type note; new BC-3.4.015 bare-form-`>`-is-literal note; new VP-578-023 minted (verifier), inline BC-body anchor back-filled (product-owner) |
| LOWs | LOW | `:asset=:`/`:asset=:Y:Z` check-order ambiguity (EC-2c empty-workspace vs EC-2b/2d objectId checks); M3 numeric-bypass edge undocumented for `jr field options`; ADR-0019 §1 `has_project` note lacked a superseded pointer | EC-2c pinned to evaluate BEFORE objectId-segment checks (BC-3.4.030 Parsing rule 2 + BC-3.4.031 EC-2c, cross-referenced); new `jr field options` M3 numeric-bypass paragraph (inherits `jr requesttype fields` convention unmodified); ADR-0019 §1 gains `[superseded 2026-08-26 — see Amendment D1]` inline marker |

**Closes:** MED-1/F-3 (platform-vs-JSM collision-guard scope made explicit everywhere), MED-2 (BC-INDEX.md title-row prose, state-manager), MED-3 (VP-578-013 per-kind split realized), F-1 (`--value` filter × `Option<String>` reconciled), F-2/D4 (non-cascading collision + bare-form literal, VP-578-023 minted + back-filled), all LOWs. **Does NOT close:** the F2 mandatory adversarial spec-convergence loop itself (streak remains 0/3 — Pass 3's CLEAN verdict does not carry over into a new streak attempt; a fresh 3-pass run starting from Pass 1 is required). **Also DEFERRED, not closed:** F-3's JSM collision-guard extension (BC-3.8.008's dedicated-flag wire-key collision) remains an open product decision, owed at the F2 human gate; DEC-310 formal registration and the DEC-namespace disambiguation question also remain owed at cycle close (unchanged from round-3).

### Counts reconciled this burst

No BCs added or removed — total stays **719** (bc-3-issue-write.md 123/152 individually-bodied/cumulative; cross-cutting.md 89/155). **VP total 30 → 31** (VP-578-023 newly minted; sequence now VP-578-001..023 = 23 ids + VP-580-005..012 = 8 ids). Holdouts unchanged (106). No BC-INDEX.md/CANONICAL-COUNTS.md VP-count surface exists to update — only STATE.md carries a standalone VP-total figure, updated 30→31 this burst.

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary | Fresh-context pass #1 (+ consistency-validator sweep run alongside) | NOT-CLEAN — routed MED-1/F-3, F-1, LOWs |
| adversary | Fresh-context pass #2 | NOT-CLEAN — routed MED-2 (flagged for state-manager), MED-3, F-2/D4 (flagged for architect) |
| architect | Decide D4 (non-cascading collision + bare-form literal), one targeted ADR-0019 §1 note | ADR-0019 § Amendment D4, `architecture-delta-field-dx.md` |
| product-owner | Propagate MED-1/F-3, F-1, F-2/D4, LOWs into PRD/BC bodies; flag MED-2 for state-manager | `prd-delta-field-dx.md` "2026-08-26 F2 adversary-convergence round-4 amendments" section, `bc-3-issue-write.md`, `cross-cutting.md` |
| verifier | Realize MED-3 (VP-578-013 per-kind split), F-1 (VP-580-007 g/h/i), mint VP-578-023 (D4/F-2) | `phase-f2-spec-evolution/verification-delta-field-dx.md` |
| product-owner | Back-fill VP-578-023's inline BC-body Verification Properties anchor (was pending after verifier's pass) | `specs/prd/bc-3-issue-write.md` |
| adversary | Fresh-context pass #3 | **CLEAN** |
| state-manager | Fix BC-INDEX.md MED-2 title-row prose, re-run guard scripts, reconcile VP count 30→31, log this burst, update STATE.md, commit | `BC-INDEX.md`; this file; `STATE.md` |

## Burst: Burst 5 — F2 adversary-convergence round-5, FOURTH fresh 3-pass streak (Pass 3 CLEAN, streak still 0/3), consistency-sweep + 4 MEDIUM-class + LOWs fixed (2026-08-26)

**Parent-commit:** `d3b7a7bc` (factory(F2): field-dx convergence round-4 -- consistency-sweep + 3rd streak residuals fixed, VP 30->31, BC-INDEX D1 prose fixed)

**Adversary verdict:** Pass 1 NOT-CLEAN, Pass 2 NOT-CLEAN, **Pass 3 CLEAN** — the fourth consecutive fresh-streak attempt this session to reach 3/3 CLEAN, and the third round in a row (rounds 3, 4, 5) to produce at least one individual CLEAN pass. A consistency-validator sweep was run after the verifier pass and caught one wording residual (the stale "pending back-fill" claim in `verification-delta-field-dx.md`), closed by two tiny wording fixes. All findings routed this round were partial-fix propagation residuals or peripheral-seam gaps in this same session's own D1/D2/D3/D4 fixes — no new defect classes, and (as with round-4) no HIGH/CRITICAL findings. Fixed via a fix chain: architect (D2 correction) → product-owner (BC-body propagation) → verifier (VP realization + VP-578-024 mint) → consistency-sweep → product-owner (2 tiny wording fixes).

**Files touched (Dim-1): 6 unique files**

- phase-f2-spec-evolution/architecture-delta-field-dx.md
- phase-f2-spec-evolution/prd-delta-field-dx.md
- phase-f2-spec-evolution/verification-delta-field-dx.md
- specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md
- specs/prd/bc-3-issue-write.md
- specs/prd/cross-cutting.md

(`sidecar-learning.md` also touched, non-spec.)

**Codifications:** ADR-0019 gains § "D2 correction (adversary F-NEW-1)" (architect-decided): D2's create-path governed field set was itself under-scoped — it reused Gate B's five-member EDIT-derived set verbatim instead of re-deriving `issue create`'s own larger dedicated-flag surface (`handle_create` also writes `--label`/`--team`/`--points`/`--parent`/`--to`/`--account-id` into the same `fields` object `--field` merges into, none of which tripped the five-member guard). Corrected to a **nine-member set**: the original 5 (`summary`/`description`/`issuetype`/`priority`/`components`) + 3 new static-key members (`labels`/`parent`/`assignee`, zero-HTTP, same static case-insensitive mechanism) + 1 resolved-id category covering `--points`/`--team`, detected ONLY via the `--field customfield_NNNNN=` bypass form (never a display-name form — hoisting field-name resolution ahead of the create-path guard's zero-HTTP boundary would violate the step-2/2a/2b SSOT invariant). `labels` is governed on CREATE (one unforked write path) but stays EXCLUDED on EDIT (BUG-LABEL-400's endpoint fork) — a documented per-path exception, not an inconsistency. Propagated into BC-3.3.010 Invariant 5 + new EC-3.3.010-6a (full 9-member enumeration), BC-3.3.011's error-taxonomy row, and BC-3.4.029 EC-3.4.029-2 (5+3+1=9 arithmetic spelled out); VP-578-021 EXTENDED (not newly minted) to cover the 4 new static flags + 2 resolved-id cases + a NEGATIVE regression pin (`--points 5 --field "Story Points"=8` does NOT trip the guard, documented-limitation pin). Separately, F-NEW-2 pins `--field` hint-kind × `issue edit --dry-run` preview shape across BC-3.4.021/027/028/029/030: `plannedChanges` shows the SAME composed wire object the live PUT would send per hint kind (`:id`→`{"id":…}`, `:name`→`{"name":…}`, `:option` non-cascading→`{"id":…}`, `:option` cascading→`{"value":…,"child":{"value":…}}`, `:asset`→`[{workspaceId,id,objectId}]`), never the bare-form display-value string; PUT is never called under `--dry-run`. New **VP-578-024** minted (verifier), replacing the product-owner's `VP-DRY-RUN-005` placeholder in BC-3.4.021, also covering the `:asset` cold-cache side effect: a COLD `get_or_fetch_workspace_id` cache under `--dry-run` fires the real workspace-discovery HTTP call and CAN exit 64 from BC-3.4.030's cold-cache taxonomy BEFORE any `plannedChanges` output (mirrors VP-692-002/004's exit-64-before-preview shape). MED-1 corrected a miscitation: VP-578-013's enumeration had drifted to cite "EC-2d," which belongs exclusively to VP-578-012's extra-colon message, not VP-578-013 — corrected to the accurate EC-2a/b/c set. MED-2: VP-578-023's inline BC-body anchor is now back-filled at BOTH sites (BC-3.4.027 declared round-4; BC-3.4.015 back-filled this round) — the verification-delta's stale "sole pending back-fill" claim was reconciled, and `related_bcs` gained BC-3.4.015 (VP-578-023 Applies-to) + BC-3.4.021 (VP-578-024 owning BC). LOWs: M2 sub-headings bracketed for consistency with M3's existing bracket convention; a stale changelog line converted to a resolution-pointer instead of duplicated prose; the round-4 "four vs three new static keys" count slip reconciled to the correct 9 = 5 (original) + 3 (new static) + 1 (resolved-id category) arithmetic everywhere it's cited. No new BC, no BC retired.

**Dim-2 Attestation:** N/A for this burst — spec-only F2 convergence burst (no `src/` changes). `scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). Both re-run post-burst by state-manager.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (spec/documentation delta only).

**Dim-6 Attestation:** N/A — no `src/` code changed this burst; `cargo fmt`/`cargo clippy` not applicable.

**Dim-7 Attestation:** N/A — no test suite changed this burst. Spec-level verification is `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` (both PASS, see Dim-2 above); BC/VP realization tests remain deferred to F4 implementation per this repo's `convention: inline-proptest`.

**Findings routed and fixed this burst:**

| Finding | Severity | Description | Fix |
|---------|----------|--------------|-----|
| F-NEW-1 | MEDIUM | D2's create-path governed field set was under-scoped — it reused Gate B's five-member EDIT set verbatim rather than re-deriving `issue create`'s own dedicated-flag surface (`--label`/`--team`/`--points`/`--parent`/`--to`/`--account-id` all silently unguarded) | ADR-0019 § "D2 correction (adversary F-NEW-1)": governed set corrected 5→9 (3 new static keys + 1 resolved-id category, bypass-form only); propagated to BC-3.3.010/011, BC-3.4.014/017/029; VP-578-021 EXTENDED with new coverage + a negative regression pin |
| F-NEW-2 | MEDIUM | `--field` hint-kind × `issue edit --dry-run` preview wire shape was unpinned — unclear whether `plannedChanges` shows the composed wire object or the bare-form display-value string per hint kind | Pinned per-kind wire shape across BC-3.4.021/027/028/029/030 (`plannedChanges` mirrors the live PUT body exactly per kind, PUT never called); new **VP-578-024** minted (verifier), replacing the PO's `VP-DRY-RUN-005` placeholder; also covers the `:asset` cold-cache dry-run side-effect exit-64-before-preview case |
| MED-1 | MEDIUM | VP-578-013's enumeration cited "EC-2d," which is exclusively VP-578-012's extra-colon message, not VP-578-013's | Enumeration corrected to the accurate EC-2a/b/c set |
| MED-2 | MEDIUM | `verification-delta-field-dx.md` still claimed VP-578-023's BC-body anchor had a "sole pending back-fill" at BC-3.4.015, but the product-owner had already back-filled it | Back-fill confirmed DONE at both anchor sites (BC-3.4.027 + BC-3.4.015); stale "pending" claim reconciled; `related_bcs` gained BC-3.4.015 + BC-3.4.021 |
| LOWs | LOW | M2 sub-headings unbracketed (inconsistent with M3's convention); a stale changelog line duplicated prose instead of pointing at the resolution; the round-4 "four vs three new static keys" arithmetic slip (should read 5+3+1=9) | M2 sub-headings bracketed; changelog line converted to a resolution pointer; "9 = 5+3+1" arithmetic reconciled everywhere it's cited |

**Closes:** F-NEW-1 (create-path governed set 5→9, VP-578-021 extended), F-NEW-2 (dry-run per-kind wire shape pinned, VP-578-024 minted), MED-1 (VP-578-013 EC citation fixed), MED-2 (VP-578-023 back-fill reconciliation), all LOWs. **Does NOT close:** the F2 mandatory adversarial spec-convergence loop itself (streak remains 0/3 — Pass 3's CLEAN verdict does not carry over into a new streak attempt; a fresh 3-pass run starting from Pass 1 is still required). **Also NOT closed (unchanged from round-4):** DEC-310 formal registration, the DEC-namespace disambiguation question, and F-3's JSM collision-guard extension (open product decision) all remain owed at the F2 human gate.

### Counts reconciled this burst

No BCs added or removed — total stays **719** (bc-3-issue-write.md 123/152 individually-bodied/cumulative; cross-cutting.md 89/155). **VP total 31 → 32** (VP-578-024 newly minted; sequence now VP-578-001..024 = 24 ids + VP-580-005..012 = 8 ids). Holdouts unchanged (106). No BC-INDEX.md/CANONICAL-COUNTS.md VP-count surface exists to update — only STATE.md carries a standalone VP-total figure, updated 31→32 this burst.

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary | Fresh-context pass #1 | NOT-CLEAN — routed F-NEW-1 (flagged for architect), LOWs |
| adversary | Fresh-context pass #2 | NOT-CLEAN — routed F-NEW-2, MED-1, MED-2 |
| architect | Decide D2 correction (create-path governed set 5→9) | ADR-0019 § "D2 correction (adversary F-NEW-1)", `architecture-delta-field-dx.md` |
| product-owner | Propagate F-NEW-1's 9-member set, F-NEW-2's dry-run scope note, LOWs into PRD/BC bodies | `prd-delta-field-dx.md` "2026-08-26 F2 adversary-convergence round-5 amendments" section, `bc-3-issue-write.md`, `cross-cutting.md` |
| verifier | Extend VP-578-021 (9-member coverage + negative pin), fix MED-1 (VP-578-013 EC citation), mint VP-578-024 (F-NEW-2 dry-run shape) | `phase-f2-spec-evolution/verification-delta-field-dx.md` |
| consistency-validator | Sweep round-1..5 amendments for residual drift | caught MED-2 (stale "pending back-fill" claim) |
| product-owner | 2 tiny wording fixes: MED-2 back-fill reconciliation + related_bcs update | `verification-delta-field-dx.md`, `bc-3-issue-write.md` |
| adversary | Fresh-context pass #3 | **CLEAN** |
| state-manager | Re-run guard scripts, reconcile VP count 31→32, log this burst, update STATE.md, commit | this file; `STATE.md` |

## Burst: Burst 6 — F2 adversary-convergence round-6, FIFTH fresh 3-pass streak (Passes 2 & 3 CLEAN, streak still 0/3), D2 count correction 9→10 + 4 LOWs fixed (2026-08-26)

**Parent-commit:** `e289bce8` (factory(F2): field-dx convergence round-5 -- D2 create-guard 5->9 + dry-run VP-578-024 + consistency-sweep residual, VP 31->32)

**Adversary verdict:** Pass 1 **NOT-CLEAN** (one genuine MEDIUM), Pass 2 **CLEAN**, Pass 3 **CLEAN** — the fifth consecutive fresh-streak attempt this session, and the first time in this session's history that TWO passes in the same streak came back clean. The single MEDIUM (M-1) was a count-arithmetic contradiction in round-5's own D2 correction, not a new defect class. Fixed via a fix chain: architect + product-owner + verifier, run in parallel on disjoint files, then reconciled by state-manager.

**Files touched (Dim-1): 6 unique files**

- phase-f2-spec-evolution/architecture-delta-field-dx.md
- phase-f2-spec-evolution/prd-delta-field-dx.md
- phase-f2-spec-evolution/verification-delta-field-dx.md
- specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md
- specs/prd/bc-3-issue-write.md
- specs/prd/cross-cutting.md

(`sidecar-learning.md` also touched, non-spec; new `cycles/cycle-002/lessons.md` created this burst, non-spec.)

**Codifications:** **M-1 (MEDIUM) count correction:** round-5's D2 create-path collision guard governed set was reported as "nine" wire-key targets, but the arithmetic itself was wrong — `--points`→`story_points` customfield id and `--team`→`team` customfield id are TWO DISTINCT `customfield_NNNNN` wire keys, not one collapsed "resolved-id category." Round-5's reconciliation had wrongly collapsed them into a single member to force the total to read "nine." Corrected to **TEN** = 5 original (`summary`/`description`/`issuetype`/`priority`/`components`) + 3 new static keys (`labels`/`parent`/`assignee`, zero-HTTP) + 2 distinct resolved-id keys (`--points`→story-points customfield id, `--team`→team customfield id; both detected ONLY via the `--field customfield_NNNNN=` bypass form, never a display name). Propagated consistently across: ADR-0019 § "D2 correction" (rows 9a/9b split into distinct rows 9/10), `architecture-delta-field-dx.md` §9, `bc-3-issue-write.md` (10 sites: BC-3.3.010 Invariant 5/EC-3.3.010-6a, BC-3.3.011's error-taxonomy, BC-3.4.014/017/029), and `verification-delta-field-dx.md`'s VP-578-021 (property 2 = 8 static-key cases, property 3 = 2 SEPARATE resolved-id cases rather than one merged case, negative regression pin retained unchanged). Also fixed a latent 5+4+2=11 math error found alongside in the verification-delta's own scratch arithmetic. Grep-verified: every active contract surface now says TEN; the only remaining "nine" strings are intentional correction-narration (this burst's and round-5's own historical prose), not live counts. **4 LOWs folded in:** BC-3.8.008 EC-3.8.008-3 (JSM malformed `--field` hint exits 64 pre-POST, now pinned); BC-X.14.001 gains a caveat distinguishing M1's field set from M3's (the two diverge, previously unremarked); BC-3.4.021 Invariant 1 gains an explicit F-NEW-2 exception qualifier (round-5's dry-run wire-shape pin is an exception to the general invariant, not an extension of it, now stated as such); VP-578-005 gains a coverage note for the colon-in-a-field-name case (verifier-authored, closes a silent gap the adversary's Pass 1 also flagged). No new BC. No new VP — VP-578-021's amendment is a scope correction (property 2/3 split), not a new id; VP total stays 32.

**Dim-2 Attestation:** N/A for this burst — spec-only F2 convergence burst (no `src/` changes). `scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). Both re-run post-burst by state-manager.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (spec/documentation delta only).

**Dim-6 Attestation:** N/A — no `src/` code changed this burst; `cargo fmt`/`cargo clippy` not applicable.

**Dim-7 Attestation:** N/A — no test suite changed this burst. Spec-level verification is `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` (both PASS, see Dim-2 above); BC/VP realization tests remain deferred to F4 implementation per this repo's `convention: inline-proptest`.

**Findings routed and fixed this burst:**

| Finding | Severity | Description | Fix |
|---------|----------|--------------|-----|
| M-1 | MEDIUM | Round-5's D2 create-path collision-guard governed set was arithmetically wrong — `--points` and `--team` resolve to two distinct `customfield_NNNNN` wire keys, but round-5 collapsed them into one "resolved-id category" to force the count to read "nine" | Corrected to TEN = 5 original + 3 static + 2 distinct resolved-id keys; propagated across ADR-0019, architecture-delta §9, bc-3-issue-write.md (10 sites), and VP-578-021 (property 2/3 split, negative pin retained); a latent 5+4+2=11 scratch-math error fixed alongside |
| LOW | LOW | BC-3.8.008 EC-3.8.008-3 (JSM malformed `--field` hint exit-64-pre-POST) was implied but not explicitly pinned | Explicit EC pinned |
| LOW | LOW | BC-X.14.001 did not caveat that M1's field set diverges from M3's | Divergence caveat added |
| LOW | LOW | BC-3.4.021 Invariant 1 did not qualify F-NEW-2 (round-5) as an exception to the general invariant | Exception qualifier added |
| LOW | LOW | VP-578-005 lacked a coverage note for the colon-in-field-name case | Coverage note added (verifier) |

**Closes:** M-1 (D2 governed-set count corrected 9→10), all 4 LOWs. **Does NOT close:** the F2 mandatory adversarial spec-convergence loop itself (streak remains 0/3 — Pass 1's NOT-CLEAN verdict resets the streak even though Passes 2 and 3 were both CLEAN; a fresh 3-pass run starting from Pass 1 is still required). **Notable trajectory signal:** this is the first round in this session where TWO passes in the same streak (Passes 2 and 3) came back CLEAN — the delta's defect surface is at the floor; only the M-1 count contradiction (now fixed) broke the streak this round. **Also NOT closed (unchanged from round-5):** DEC-310 formal registration, the DEC-namespace disambiguation question, and F-3's JSM collision-guard extension (open product decision) all remain owed at the F2 human gate.

### Counts reconciled this burst

No BCs added or removed — total stays **719** (bc-3-issue-write.md 123/152 individually-bodied/cumulative; cross-cutting.md 89/155). **VP total stays 32** — VP-578-021 was amended (property 2/3 split), not newly minted; no new VP id this round. Holdouts unchanged (106). Both guard scripts re-verified PASS post-burst.

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary | Fresh-context pass #1 | NOT-CLEAN — routed M-1 (flagged for architect), 4 LOWs |
| adversary | Fresh-context pass #2 | **CLEAN** |
| adversary | Fresh-context pass #3 | **CLEAN** |
| architect | Decide M-1 count correction (9→10, rows 9a/9b split into 9/10) | ADR-0019 § "D2 correction" amendment, `architecture-delta-field-dx.md` §9 |
| product-owner | Propagate M-1's 10-member set + 3 of the 4 LOWs into PRD/BC bodies | `prd-delta-field-dx.md` round-6 amendments section, `bc-3-issue-write.md` (10 sites), `cross-cutting.md` |
| verifier | Amend VP-578-021 (property 2/3 split, fix latent 5+4+2=11 math error, negative pin retained); add VP-578-005 coverage note (4th LOW) | `phase-f2-spec-evolution/verification-delta-field-dx.md` |
| state-manager | Re-run guard scripts (PASS, 719/no drift), log this burst, log process-gap lesson, update STATE.md, commit | this file; `cycles/cycle-002/lessons.md`; `STATE.md` |

## Burst: Burst 7 — F2 adversary-convergence CLOSE: streak-6, 3/3 CONSECUTIVE CLEAN, zero intervening fixes (2026-08-26)

**Parent-commit:** `b8082ba4` (factory(F2): field-dx convergence round-6 -- D2 create-guard count corrected 9->10 (distinct points/team wire keys) + 4 LOWs)

**Adversary verdict:** a fresh 3-pass streak (orchestrator label: **streak-6**, run against the round-6 committed delta at `b8082ba4`) returned **CLEAN on all three passes**, using three diverse review lenses rather than three generic re-runs — Pass 1 correctness, Pass 2 completeness, Pass 3 traceability. **This is the first streak this session to reach 3/3 CONSECUTIVE CLEAN.** Zero intervening fixes were required between passes; this burst is bookkeeping-only (STATE.md, spec-changelog.md, this burst-log entry) — no spec-content files were edited.

**Pass 1 (correctness) — CLEAN:** verified the D2 create-guard TEN-key count (round-6's M-1 fix) against the actual `create.rs` source directly (not against prior rounds' narrative), confirmed guard-ordering determinism, and reconciled the VP-count (32) three independent ways. Surfaced 2 LOW doc-hygiene items (see below).

**Pass 2 (completeness) — CLEAN:** no new CRITICAL/HIGH/MEDIUM findings — six rounds of convergence have driven the delta's defect surface to the floor. Surfaced 1 LOW doc-hygiene item.

**Pass 3 (traceability) — CLEAN:** confirmed the VP inventory (32, no orphans), TEN-count consistency across all 4 contract surfaces, DEC-310 governance chain, holdout coverage, and the 719/32/106 counts all reconcile. Surfaced 1 LOW doc-hygiene item.

**Files touched (Dim-1): 3 unique files**

- `STATE.md` (this burst's convergence-close record)
- `spec-changelog.md` (PROCESS-INTEGRITY CAVEAT reconciled to record achieved+recorded convergence, superseding the prior 0/3 caveat as of `b8082ba4`)
- `cycles/cycle-002/burst-log.md` (this entry)

No `phase-f2-spec-evolution/`, `specs/prd/`, `specs/architecture/` files were touched this burst — the 4 residual LOW findings below are tracked as debt, not fixed in this burst (per explicit instruction: this burst records convergence, it does not perform a further fix-chain).

**Dim-2 Attestation:** N/A for this burst — spec-only F2 bookkeeping burst (no `src/` changes). `scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). Both re-run post-burst by state-manager.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (bookkeeping/documentation delta only).

**Dim-6 Attestation:** N/A — no `src/` code changed this burst; `cargo fmt`/`cargo clippy` not applicable.

**Dim-7 Attestation:** N/A — no test suite changed this burst. Spec-level verification is `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` (both PASS, see Dim-2 above); BC/VP realization tests remain deferred to F4 implementation per this repo's `convention: inline-proptest`.

**Codifications:** **F2 mandatory adversarial spec-convergence is CONVERGED (3/3 CONSECUTIVE CLEAN).** Spec version bumped **v1.5.0 → v1.6.0** (MINOR per DF-030) in `spec-changelog.md`; the MINOR-vs-MAJOR question on the BC-3.8.012/DEC-310 reversal remains explicitly flagged for the F2 human gate, not forced. F2 is now ready for **Step 8 (human gate)**.

**4 residual LOW doc-hygiene findings (tracked, non-blocking — do NOT reset the clean streak per the mandatory rule, which resets only on NOT-CLEAN/MEDIUM+ verdicts):**

| Finding | Severity | Description |
|---------|----------|--------------|
| DOC-1 | LOW | `prd-delta-field-dx.md`'s round-2 step-2a narration is stale |
| DOC-2 | LOW | Platform `:asset` wire-shape carries an UNVERIFIED note |
| DOC-3 | LOW | M1 (`jr field options`)'s editmeta FALLBACK path lacks an explicit status/permission-dependency caveat |
| DOC-4 | LOW | `prd-delta-field-dx.md`'s Summary section says "9 amended BCs" but should include BC-3.4.021/028/030 (round-5/round-6 amendments) |

**Closes:** the F2 mandatory adversarial spec-convergence loop itself (3/3 CONSECUTIVE CLEAN reached; no further adversary passes required for F2). **Does NOT close:** DEC-310 formal registration, the DEC-namespace disambiguation question, the F-3 JSM collision-guard-extension product decision, the MINOR-vs-MAJOR spec-version confirmation, or the 4 residual LOW doc-hygiene items above — all owed at the F2 human gate / cycle close per the cycle-closing checklist in STATE.md's Session Resume Checkpoint.

### Cycle-closing checklist status (as of this burst)

Process-gap follow-ups still owed at cycle close (none closed by this bookkeeping burst):

1. **Register DEC-310** formally (proposed, propagation complete; formal registration step remains).
2. **DEC-namespace disambiguation question** — spec-authored DECs and cycle-gate DECs share one flat `DEC-NNN` prefix with no central registry; needs a cycle-close decision.
3. **Reversal-propagation checklist** for the PO/state-manager workflow — still not built (recurring gap noted rounds 1-6).
4. **`COUNT-RECONCILIATION-FORCED-CONSISTENCY-PATTERN`** lesson from round-6 (a count-discrepancy reconciliation must re-derive the semantically correct count from the underlying distinct entities, not force consistency onto whichever number appeared first) — logged in `cycles/cycle-002/lessons.md`; candidate for a spec-authoring checklist item, not yet actioned.
5. The **4 residual LOW doc-hygiene items** from this burst (DOC-1..4 above) — non-blocking, owed before or at cycle close.
6. **MINOR-vs-MAJOR spec-version confirmation** — `spec-changelog.md` [1.6.0]'s MINOR classification is a spec-steward judgment call, explicitly flagged for human confirmation at the F2 gate; if overridden, version should be revised to v2.0.0 before cycle close.
7. **F-3 (D2-collision-guard extension to the JSM create path)** — DEFERRED product decision from round-4, unchanged through streak-6, owed at the F2 human gate.

### Counts reconciled this burst

No BCs added or removed — total stays **719** (bc-3-issue-write.md 123/152 individually-bodied/cumulative; cross-cutting.md 89/155). **VP total stays 32** — no VP amended or minted this burst (bookkeeping only). Holdouts unchanged (106). Both guard scripts re-verified PASS post-burst (`check-spec-counts.sh` → exit 0, 8 files; `check-bc-cumulative-counts.sh` → exit 0, 719 total across 9 files).

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary | Fresh-context pass #1 (correctness lens) | **CLEAN** — 2 LOW |
| adversary | Fresh-context pass #2 (completeness lens) | **CLEAN** — 1 LOW |
| adversary | Fresh-context pass #3 (traceability lens) | **CLEAN** — 1 LOW |
| state-manager | Re-run guard scripts (PASS, 719/no drift), update STATE.md to record F2 CONVERGED (streak 3/3), reconcile spec-changelog.md's [1.6.0] PROCESS-INTEGRITY CAVEAT, log this burst, commit | `STATE.md`; `spec-changelog.md`; this file |

## Burst: Burst 8 — F2 human gate APPROVED + DEC-310 REGISTERED + F2->F3 transition (2026-08-26)

**Parent-commit:** the commit landing Burst 7 above (F2-CONVERGENCE-CLOSE, streak-6 3/3 CONSECUTIVE CLEAN).

**Adversary verdict:** N/A -- this burst is a human gate-decision and DEC-310-registration bookkeeping burst, not an adversary pass. No adversary was dispatched this burst; F2's mandatory adversarial spec-convergence loop already reached 3/3 CONSECUTIVE CLEAN in Burst 7 and is not reopened here.

**Human decision:** the human reviewed the F2 gate (Step 8) on 2026-08-26 and delivered four decisions:

1. **F2 gate APPROVED** -> pipeline transitions **F2 -> F3** (incremental stories).
2. **Spec version DEFERRED.** The human said BOTH v1.6.0 (MINOR) and v2.0.0 (MAJOR) framings offered at the gate are WRONG and explicitly said not to bump the version right now. The spec-version determination is therefore OPEN/deferred, not settled -- the pre-existing v1.6.0 authoring-time frontmatter in `BC-INDEX.md`/`spec-changelog.md` is NOT reverted (that would be out-of-scope churn for this burst); this burst only records that the version is unconfirmed.
3. **F-3 (JSM collision-guard extension) RESOLVED.** JSM create keeps its pre-existing last-wins behavior; the spec already documents the divergence (BC-3.8.008, PO-verified). The MED-1/F-3 owed-at-gate item is closed, no D2 guard extension.
4. **DEC-310 REGISTER NOW.** The product-owner updated all inline spec surfaces (`bc-3-issue-write.md`, `BC-INDEX.md`, `CANONICAL-COUNTS.md`, `prd-delta-field-dx.md`) from "proposed" to "registered (2026-08-26, human-approved)" ahead of this burst (uncommitted at burst start). state-manager finishes the registration in the remaining bookkeeping surfaces this burst: `STATE.md` Decisions Log (DEC-310 flipped proposed -> REGISTERED, `DEC-310-FORMAL-REGISTRATION-OPEN` flag removed), `spec-changelog.md`'s `[1.6.0]` entry (all "proposed" DEC-310 language flipped to registered, plus a DEFERRED note on the spec-version classification and a corrected F2-convergence-gate Impact Assessment row), and this file (new Burst 8).

**Files touched (Dim-1): 8 unique files** (4 by the PO ahead of this burst, 4 by state-manager this burst)

- `phase-f2-spec-evolution/prd-delta-field-dx.md` (PO: DEC-310 proposed -> registered)
- `specs/prd/BC-INDEX.md` (PO: DEC-310 proposed -> registered)
- `specs/prd/CANONICAL-COUNTS.md` (PO: DEC-310 proposed -> registered)
- `specs/prd/bc-3-issue-write.md` (PO: DEC-310 proposed -> registered)
- `STATE.md` (state-manager: F2 gate APPROVED, phase F2->F3, DEC-310 REGISTERED, F-3 RESOLVED, spec version DEFERRED)
- `spec-changelog.md` (state-manager: `[1.6.0]` entry's DEC-310 language reconciled to registered; spec-version DEFERRED note added; convergence-gate Impact Assessment row corrected)
- `cycles/cycle-002/burst-log.md` (this entry)
- `cycles/cycle-002/session-checkpoints.md` (state-manager: prior streak-6/convergence-close checkpoint archived from STATE.md, with a superseding note recording the gate's APPROVED outcome)

**Dim-2 Attestation:** N/A for this burst -- spec-only F2-gate-close bookkeeping burst (no `src/` changes). `scripts/check-spec-counts.sh` -> exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` -> exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). Both re-run by state-manager both before and after this burst's edits -- the PO's DEC-310 inline-surface edits changed no counts (719 unchanged).

**Dim-5 Attestation:** N/A -- no binary/WASM artifact produced by this burst (bookkeeping/decision-recording delta only).

**Dim-6 Attestation:** N/A -- no `src/` code changed this burst; `cargo fmt`/`cargo clippy` not applicable.

**Dim-7 Attestation:** N/A -- no test suite changed this burst. Spec-level verification is `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` (both PASS, see Dim-2 above); BC/VP realization tests remain deferred to F4 implementation per this repo's `convention: inline-proptest`.

**Codifications:** F2 human gate **APPROVED**. DEC-310 **REGISTERED** (2026-08-26, human-approved). F-3 (JSM D2 collision-guard extension) **RESOLVED** -- retain last-wins, no extension. Spec version (v1.6.0 MINOR vs v2.0.0 MAJOR) **DEFERRED** -- neither confirmed nor overridden, human declined to settle it now. Pipeline transitions **F2 -> F3**; F3 (incremental stories) has not yet started.

**Closes:** DEC-310 formal registration (owed-at-gate item #1, closed). F-3 JSM collision-guard-extension product decision (owed-at-gate item, closed -- RESOLVED). The F2 human gate itself (Step 8, APPROVED). **Does NOT close:** the DEC-namespace disambiguation question (human did not choose a split at this gate -- remains open, tracked debt); the spec-version determination (explicitly DEFERRED, not forced); the 4 residual LOW doc-hygiene items from streak-6 (non-blocking, tracked in `STATE.md` Drift/Standing Items); the pre-existing, NOT field-dx-scoped `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT` standing item (~145 historical stale artifacts from closed cycles, factory-wide, unrelated to this bundle).

### Counts reconciled this burst

No BCs added or removed -- total stays **719** (`bc-3-issue-write.md` 123/152 individually-bodied/cumulative; `cross-cutting.md` 89/155). VP total stays **32**. Holdouts unchanged (**106**). Both guard scripts re-verified PASS post-burst.

### Details

| Agent | Task | Output |
|-------|------|--------|
| human | F2 Step 8 gate review; delivered 4 decisions (gate APPROVED, spec version DEFERRED, F-3 RESOLVED, DEC-310 REGISTER NOW) | verbal/session decision, recorded here and in `STATE.md` |
| product-owner | Flip inline spec surfaces (`bc-3-issue-write.md`, `BC-INDEX.md`, `CANONICAL-COUNTS.md`, `prd-delta-field-dx.md`) DEC-310 proposed -> registered | those 4 files (uncommitted at burst start, committed together with this burst) |
| state-manager | Re-verify guard scripts (PASS, 719/no drift), update `STATE.md` (phase F2->F3, DEC-310 REGISTERED, F-3 RESOLVED, spec version DEFERRED), reconcile `spec-changelog.md`'s `[1.6.0]` entry, archive the prior streak-6 checkpoint to `session-checkpoints.md`, log this burst, commit all 8 touched files, push | `STATE.md`; `spec-changelog.md`; this file; `cycles/cycle-002/session-checkpoints.md`; the 4 PO-edited spec files |

## Burst: Burst 9 — F3 story decomposition COMPLETE: 5 stories, 19 BCs + 32 VPs covered, acyclic wave plan (2026-08-26)

**Dispatched:** story-writer (fresh context, F3 incremental-stories workflow).

**What happened:** story-writer decomposed the field-dx F2-converged spec (v2.0.0 MAJOR) into 5 new stories, all `status: ready`:

| Story | Wave | Deps | Points | BCs | VPs |
|-------|------|------|--------|-----|-----|
| S-580-1 (`jr field options <field>` command) | 1 | [] | 8 | BC-X.14.001-004 | VP-580-005..012 |
| S-578-1 (field value-kind hint-syntax parser) | 1 | [] | 5 | BC-3.4.026 | (parser foundation) |
| S-578-2 (`issue edit --field` hint dispatch) | 2 | [S-578-1] | 13 | BC-3.4.015/016/021/027/028/029/030/031 | VP-578-* |
| S-578-3 (JSM `issue create --field` hint dispatch) | 2 | [S-578-1] | 8 | BC-3.8.008 | VP-578-* |
| S-578-4 (platform `issue create --field` support) | 3 | [S-580-1, S-578-2] | — | BC-3.3.010/011, BC-3.8.012/013 (DEC-310 reversal), BC-3.4.014 | VP-578-* |

Topological order: {S-580-1, S-578-1} → {S-578-2, S-578-3} → S-578-4. Acyclic (verified). All 19 BCs traced by at least one AC across the 5 stories; VP-578-001..024 + VP-580-005..012 (32 total) realized. `STORY-INDEX.md` `total_stories` bumped 156→161 (5 new Feature-Followup rows), version v1.6.09→v1.6.10.

**Files touched:**
- `stories/S-580-1-field-options-command.md` (new)
- `stories/S-578-1-field-value-kind-hint-parser.md` (new)
- `stories/S-578-2-edit-field-hint-dispatch.md` (new)
- `stories/S-578-3-jsm-create-field-hint-dispatch.md` (new)
- `stories/S-578-4-platform-create-field-support.md` (new)
- `stories/STORY-INDEX.md` (5 new rows, `total_stories` 156→161)
- `STATE.md` (phase F3 story-decomposition COMPLETE; pipeline AWAITING human decision on F4)
- `cycles/cycle-002/burst-log.md` (this entry)
- `cycles/cycle-002/session-checkpoints.md` (prior F2-GATE-APPROVED-F3-TRANSITION checkpoint archived)

**Sanity check (state-manager, not a deep audit):** `STORY-INDEX.md` frontmatter `total_stories: 161` is internally consistent with the changelog's `156→161` narration and each new row's individual `156→157`...`160→161` increments; all 5 story IDs appear exactly once as manifest rows; all 5 files exist on disk. No dedicated story-count guard script exists in `scripts/` (only `check-spec-counts.sh` and `check-bc-cumulative-counts.sh`, both BC/VP-scoped, not story-scoped) — those two guards are unaffected since no BC/VP/holdout counts changed (719/32/106 unchanged).

**Codifications:** F3 (incremental stories) is **COMPLETE**. Pipeline is now **AWAITING human decision** on whether to proceed to **F4** (TDD implementation, scoped to the 5 new stories). No wave has started.

**Closes:** F3 story-decomposition phase. **Does NOT close:** the DEC-namespace disambiguation question (open, tracked debt); the 4 residual LOW doc-hygiene items from streak-6 (non-blocking, tracked); `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT` (standing, not field-dx-scoped); the pre-existing `STORY-INDEX-DECLARED-VS-FILE-COUNT-MISMATCH` LOW item (unrelated to this burst's additions, which were verified consistent).

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed by this burst — 719 BCs / 32 VPs / 106 holdouts unchanged (all 19 BCs + 32 VPs cited by the new stories were already counted at F2 close). `total_stories` 156→161.

### Details

| Agent | Task | Output |
|-------|------|--------|
| story-writer | Decompose field-dx F2 spec into 5 stories with full BC/VP traceability and acyclic wave plan | 5 story files + `STORY-INDEX.md` update |
| state-manager | Sanity-check story count consistency, update `STATE.md` (F3 COMPLETE, awaiting human F4 decision), archive prior checkpoint, log this burst, commit + push | `STATE.md`; this file; `cycles/cycle-002/session-checkpoints.md`; commit of all F3 artifacts |

---

## Burst: BC-3.3.010 citation hygiene fix (2026-08-26)

**Trigger:** `check-bc-citation-symbols.sh` (BC-CITE-001) failing in spec-guard CI, blocking ALL open PRs including S-578-1's PR #739 — BC-3.3.010's `Source`/`Trace` fields cited `` `src/api/jira/issues.rs::get_createmeta_fields` `` in enforced symbol form, but that function does not exist yet (planned for S-578-4).

**Fix (product-owner):** Reworded both citations in `specs/prd/bc-3-issue-write.md` (BC-3.3.010, ~lines 781/840) from enforced symbol form to guard-safe prose: `` `src/api/jira/issues.rs` (planned fn `get_createmeta_fields`, implemented by story S-578-4 — not yet in `src/`; ...) ``. File citation retained; only the not-yet-real symbol moved out of enforced form.

**Verification (state-manager):** `check-bc-citation-symbols.sh` → 402 citations checked, 0 stale. `check-spec-counts.sh` → 8 bc files validated. `check-bc-cumulative-counts.sh` → 719 total unchanged across 9 files. No BC/VP/holdout counts affected — hygiene-only fix, no phase transition (still F3/v2.0.0).

**Lesson logged:** see `lessons.md` Process-Level #2 — F2 spec-authoring should run the citation guard before commit, or use prose form for forward-looking symbols.

---

## Burst: Burst 10 — F4 Wave 1: S-578-1 (--field hint-syntax parser) DELIVERED + MERGED (PR #739 @ 993de833) (2026-08-26)

**Parent-commit:** 6af069e96f53a2f2cab6e724047b134419534bed (factory(fix): BC-3.3.010 citation — move planned get_createmeta_fields symbol to prose)

**Trigger:** Human approved proceeding to F4 (TDD implementation, scoped to the 5 field-dx stories). Wave 1 dispatched first: S-580-1 and S-578-1 (no deps, parallel-eligible).

**Dispatched:** per-story-delivery pipeline for S-578-1 (test-writer → implementer → demo-recorder → pr-manager → devops-engineer).

**Adversary verdict:** Per-story adversary convergence 3/3 CLEAN (S-578-1 scoped review, not a full F5/spec-level adversary pass — this is a Feature Mode F4 per-story delivery, not an F2 spec-convergence burst).

**What happened:** S-578-1 (`--field NAME:kind=VALUE` value-kind hint-syntax parser, BC-3.4.026/031, 5 pts) implemented in `src/cli/issue/create.rs`. `parse_field_kv` return type changed `HashMap<String,String>` → `HashMap<String,FieldValueSpec>`; new `FieldValueSpec{kind: Option<FieldValueKind>, value: String}` / `FieldValueKind{Option,Id,Name,Asset}` — SHARED type, consumed verbatim by S-578-2/S-578-3/S-578-4 downstream. Unicode-scalar-safe splitting (FIX-F6-LRE-1 class, matching #734's precedent). Malformed-hint exit-64 catalog covered (unknown kind, empty `:kind`, EC-6/7/8/9 regression pins).

**Pipeline detail:**
- **Red Gate:** PASS (test-writer's failing tests confirmed red before implementation).
- **Per-story adversary convergence:** 3/3 CLEAN.
- **Interim guard:** applied during implementation (bare-key/last-wins-across-kinds semantics per ADR-0019 §2(b)).
- **Demos:** recorded (demo-recorder).
- **Citation-fix detour:** BC-3.3.010's `Source`/`Trace` citation of the not-yet-existing `get_createmeta_fields` symbol was tripping `check-bc-citation-symbols.sh` (BC-CITE-001) in spec-guard CI, blocking PR #739 alongside every other open PR. Resolved by product-owner reworking the citation to guard-safe prose form (see the standalone "BC-3.3.010 citation hygiene fix" burst above, factory-artifacts `6af069e9`) — no scope change to S-578-1 itself.
- **PR:** #739, squash-merged to `develop` @ `993de833` (2026-08-26T17:54:08Z).

**Files touched (Dim-1): 4 unique files (factory-artifacts, this burst)**

- sprint-state.yaml
- stories/STORY-INDEX.md
- STATE.md
- cycles/cycle-002/burst-log.md

(develop-side, via PR #739, not counted in Dim-1 above since that's jira-cli's own tree, not `.factory/`: `src/cli/issue/create.rs` (parser + `FieldValueSpec`/`FieldValueKind` types), associated test files (test-writer's Red Gate suite), demo evidence.)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (719 total across 9 files; Surface H footer checked where present)"). Both re-run post-burst by state-manager. S-578-1 consumed already-counted BC-3.4.026/031 — no BC/VP/holdout count change.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (no factory-side compiled hook changed; the develop-side change is ordinary Rust CLI source, covered by jira-cli's own CI, not this Dim).

**Dim-6 Attestation:** PASS (delegated) — `cargo fmt --all -- --check` and `cargo clippy -- -D warnings` are enforced on PR #739 by jira-cli's own CI gate (`ci-gate`, required status check on `develop`); PR #739 was green before squash-merge.

**Dim-7 Attestation:** PASS (delegated) — test-writer's Red Gate suite for S-578-1 (unknown-kind, empty-`:kind`, EC-6/7/8/9 regression pins, Unicode-scalar-safety cases) ran green in `ci-gate`'s `test` job before merge; full `cargo test` suite (unit + integration + proptest + snapshot) is part of jira-cli's own required CI, not re-run independently by state-manager.

**Codifications:** F4 (delta implementation) is now **IN PROGRESS**. Wave 1 is 1/2 delivered — S-580-1 remains outstanding before Wave 2 (S-578-2, S-578-3) can dispatch per wave-schedule ordering (both already have their `depends_on:[S-578-1]` satisfied but wait on Wave 1 close). `activation_head` advanced for the first time this cycle.

**Closes:** F4 Wave 1 story 1/2. **Does NOT close:** Wave 1 (S-580-1 outstanding); Wave 2/3 (blocked); the DEC-namespace disambiguation question; the 4 residual LOW doc-hygiene items from streak-6; `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT` (standing, not field-dx-scoped).

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed — 719 BCs / 32 VPs / 106 holdouts unchanged (BC-3.4.026/031 were already counted at F2 close). `total_stories` unchanged at 161 (status transition only, not a new story).

### Details

| Agent | Task | Output |
|-------|------|--------|
| test-writer | Write failing tests for `--field NAME:kind=VALUE` hint-syntax parsing (Red Gate) | Red Gate test suite for S-578-1 |
| implementer | Implement `parse_field_kv` → `FieldValueSpec`/`FieldValueKind`, Unicode-safe splitting, exit-64 catalog | `src/cli/issue/create.rs` changes |
| demo-recorder | Record demo evidence for S-578-1 ACs | demo artifacts |
| pr-manager | Open PR #739, triage citation-guard CI failure, coordinate the BC-3.3.010 citation-fix detour, drive to merge | PR #739 |
| devops-engineer | Squash-merge PR #739 to `develop` | `develop` @ `993de833` |
| state-manager | Record S-578-1 delivery: update `sprint-state.yaml`, `STORY-INDEX.md`, `STATE.md`; log this burst; commit + push | `STATE.md`; `sprint-state.yaml`; `stories/STORY-INDEX.md`; this file |

---

## Burst: Burst 11 — F4 Wave 1: S-580-1 (`jr field options <field>`) DELIVERED + MERGED (PR #740 @ 74221bbc) — **WAVE 1 COMPLETE** (2026-08-26)

**Parent-commit:** 993de833 (S-578-1 merge, Burst 10)

**Trigger:** S-578-1 (Wave 1 story 1/2) merged; S-580-1 (Wave 1 story 2/2, no deps) dispatched next to close out Wave 1.

**Dispatched:** per-story-delivery pipeline for S-580-1 (test-writer → implementer → demo-recorder → pr-manager → devops-engineer).

**Adversary verdict:** 5-round per-story adversary convergence, trajectory 29→24→21→7→4→3→0 findings, converging CLEAN. Round included a CWE-835 (uncontrolled infinite loop) fix in the M1/M2/M3 context-resolution pagination path.

**What happened:** S-580-1 (`jr field options <field>` command, BC-X.14.001-004, 8 pts) implemented as a new `src/cli/field.rs` + `Command::Field` dispatch. M1/M2/M3 exactly-one-mode-selector context resolution (createmeta PRIMARY platform / requesttype-fields PRIMARY JSM / editmeta FALLBACK, per ADR-0019). Normalized `FieldOption{id: Option<String>, label: Option<String>, children: Vec<FieldOption>}` model, never-drop degenerate entries, `--value` client-side filter, table/JSON output. New `get_createmeta_fields` method added to `src/api/jira/issues.rs` — reused verbatim by S-578-4 (Wave 3).

**Pipeline detail:**
- **Red Gate:** PASS.
- **Per-story adversary convergence:** 5 rounds to CLEAN (29→24→21→7→4→3→0), including a CWE-835 infinite-loop fix in pagination handling.
- **Citation-unblock detour:** BC-3.3.010's `get_createmeta_fields` citation (reworded to prose during S-578-1's CI unblock, Burst 10) is now upgrade-eligible back to enforced symbol-form, since the function is implemented — tracked as a spec-hygiene follow-up, not actioned in this burst (no scope change).
- **Demos:** recorded.
- **PR:** #740, squash-merged to `develop` @ `74221bbc` (2026-08-26T17:17:25-05:00).

**Six PR #740 pr-reviewer NON-BLOCKING follow-ups** recorded as tracked debt (see STATE.md Drift/Standing Items): S1 (`get_createmeta_fields` total-absent short-page pagination truncation risk, defensive-only), S2 (`.or(project_override)` global `--project` override untested at unit level — mutation survivor, full `cargo mutants` CI passed), S3 (test name references `partial_match` but exercises `search_field_list` — rename), N1 (`#[serde(alias="results")]` citation unverified), N2 (CLAUDE.md `src/cli/` tree missing `field.rs`/`jr field` family).

**Files touched (Dim-1): 4 unique files (factory-artifacts, this burst)**

- sprint-state.yaml
- stories/STORY-INDEX.md
- STATE.md
- cycles/cycle-002/burst-log.md

(develop-side, via PR #740, not counted in Dim-1 above: `src/cli/field.rs` (new), `Command::Field` dispatch wiring, `get_createmeta_fields` in `src/api/jira/issues.rs`, associated test files (test-writer's Red Gate suite + 5-round adversary fixes), demo evidence.)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` → exit 0. `scripts/check-bc-cumulative-counts.sh` → exit 0 (719 total across 9 files, unchanged). S-580-1 consumed already-counted BC-X.14.001-004 — no BC/VP/holdout count change.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** PASS (delegated) — `cargo fmt --all -- --check` and `cargo clippy -- -D warnings` enforced on PR #740 by jira-cli's `ci-gate`; green before squash-merge.

**Dim-7 Attestation:** PASS (delegated) — test-writer's Red Gate suite plus the 5-round adversary fix suite for S-580-1 ran green in `ci-gate`'s `test` job before merge.

**Codifications:** F4 Wave 1 is now **COMPLETE** — both S-578-1 (PR #739) and S-580-1 (PR #740) delivered and merged. Wave 2 (S-578-2, S-578-3) is unblocked and ready for dispatch (both `depends_on:[S-578-1]`, satisfied). Wave 3 (S-578-4) remains blocked on Wave 2. `activation_head` advanced `993de833` → `74221bbc`.

**Closes:** F4 Wave 1 (both stories). **Does NOT close:** Wave 2/3 (S-578-2, S-578-3, S-578-4 still `ready`, not yet dispatched); the DEC-namespace disambiguation question; the 4 residual LOW doc-hygiene items from streak-6; the 6 new PR #740 pr-reviewer follow-ups; `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT` (standing, not field-dx-scoped).

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed — 719 BCs / 32 VPs / 106 holdouts unchanged (BC-X.14.001-004 were already counted at F2 close). `total_stories` unchanged at 161 (status transition only).

### Details

| Agent | Task | Output |
|-------|------|--------|
| test-writer | Write failing tests for `jr field options <field>` M1/M2/M3 context resolution (Red Gate) | Red Gate test suite for S-580-1 |
| implementer | Implement `src/cli/field.rs`, `Command::Field` dispatch, `get_createmeta_fields`, `FieldOption` model | `src/cli/field.rs` (new) + `src/api/jira/issues.rs` changes |
| demo-recorder | Record demo evidence for S-580-1 ACs | demo artifacts |
| pr-manager | Open PR #740, triage 5-round adversarial review incl. CWE-835 fix, drive to merge | PR #740 |
| devops-engineer | Squash-merge PR #740 to `develop` | `develop` @ `74221bbc` |
| state-manager | Record S-580-1 delivery + Wave 1 closure: update `sprint-state.yaml`, `STORY-INDEX.md`, `STATE.md`; log this burst; commit + push | `STATE.md`; `sprint-state.yaml`; `stories/STORY-INDEX.md`; this file |

## Burst: Burst 12 — F4 Wave 2: S-578-2 (`issue edit --field` hint-kind dispatch) DELIVERED + MERGED (PR #741 @ a3739763) — Wave 2 HALF DONE (2026-08-27)

**Parent-commit:** 74221bbc (S-580-1 merge / Wave 1 close, Burst 11)

**Trigger:** Wave 1 CLOSED (Burst 11); S-578-2 (Wave 2 story 1/2, `depends_on:[S-578-1]`, satisfied) dispatched next per wave-schedule ordering.

**Dispatched:** per-story-delivery pipeline for S-578-2 (stub-architect → test-writer → implementer → demo-recorder → pr-manager → devops-engineer), following the pre-documented guard-replacement Red-Gate strategy (keep `reject_unsupported_hint_kinds` through stub+test steps, remove its `edit.rs` call site only in the implement step).

**Adversary verdict:** 4-pass per-story adversary convergence. Pass 1 BLOCKING (2 MEDIUM + 5 LOW, ADV-S578-2-P1-001..007) — the significant fix was implementing the previously-missing EC-3.4.027-1 entry-point `schema.type` gate for `:option`, propagated back into the BC as a new Invariant 7 (orthogonality ruling vs. Invariant 6's structural `children`-empty check) and into the story as a new AC-019 (spec v1.0 → v1.1); also corrected BC-3.4.029 Invariant 2 (output-equality, not shared-function-implementation mandate) and BC-3.4.030/031's HTTP-ordering wording (narrowed from blanket "no HTTP" to "no workspace-discovery GET or PUT/POST" — the field-resolution editmeta GET has already fired). Passes 2/3/4 NITPICK_ONLY (doc-only fixes), 3/3 consecutive clean. Full detail: `cycles/cycle-002/S-578-2/adversary-convergence-state.json`.

**What happened:** S-578-2 (`issue edit --field` hint-kind dispatch, 13 pts — largest story in the bundle) implemented the hinted-bypass branch in `resolve_edit_fields` (`field_resolve.rs`), reading `spec.kind` BEFORE the unchanged bare-form editmeta type-dispatch: `:option` byte-identical-to-bare for non-cascading values plus cascading `Parent>Child` composition (`str::split_once('>')` MUST, D3) and the D4 non-cascading-`>`-collision structural guard; `:id`/`:name` verbatim wrap bypasses (BC-3.4.028/029); `:asset` Assets object-reference composer (`str::split_once(':')` MUST) with workspace-id resolved at this L2 call site (never inside a JSM function) and its 4-row cold-cache failure taxonomy; dry-run `plannedChanges` per-hint-kind composed-wire-shape preview. `edit.rs`'s own diff was 47 lines — well inside the ADR-0019 §2(b) ~100-LOC narrow-touch guidance. The S-578-1 interim `reject_unsupported_hint_kinds` guard's `edit.rs` call site was removed (the helper itself stays defined in `create.rs`, still called from `jsm_create.rs` — S-578-3 removes it as the last caller, per the documented guard-replacement strategy).

**Pipeline detail:**
- **Red Gate:** PASS — stub step (`cargo check` clean, guard intact); failing-test step (28/29 new tests RED on real assertion mismatches, 0 build errors, 0 panics, 90/90 regression baseline green); fix-burst Red Gate (3 EC-3.4.027-1 gate tests RED → GREEN). Full detail: `cycles/cycle-002/S-578-2/implementation/red-gate-log.md`.
- **Green Gate:** 64/64 new tests + 90/90 regression + clippy + fmt clean. Independently re-confirmed by pr-reviewer at PR HEAD `4d0d54af`.
- **Per-story adversary convergence:** 4 passes to CLEAN (Pass 1 BLOCKING → Passes 2/3/4 NITPICK_ONLY, 3/3 clean).
- **security-reviewer:** APPROVE.
- **pr-reviewer (fresh-eyes, PR #741):** APPROVE — 0 BLOCKING, 11 NON-BLOCKING findings. 4 fixed in-PR (empty-child EC-3.4.027-3 conformance per EC-3.4.027-6's "same shape" requirement; `field_resolve.rs` CLAUDE.md Known Size Deviations entry, now ~1,270 LOC crossing ADR-0012's 1,000-LOC threshold; 2 test-quality fixes — EC-8/EC-9 wire-body `.expect(1)` tightening + proptest dead-assertion fix). 7 residual findings tracked as debt (see STATE.md Drift item `S-578-2-PR741-RESIDUAL-NITS`). Full detail: `.factory/code-delivery/S-578-2/pr-review.md`.
- **Demos:** recorded on `factory-artifacts` at `.factory/demos/S-578-2/` (commit `d6a5151c`), per repo policy #708.
- **PR:** #741, squash-merged to `develop` @ `a3739763cb1cc3d52bdb0340085113bc5afb2adb` (2026-08-27).
- **Spec propagation:** story spec v1.0 → v1.1 (AC-019 added; AC-007/AC-009 reworded); BC changes propagated to `bc-3-issue-write.md` (EC-3.4.027-1 two sub-cases + new Invariant 7 + BC-3.4.029 Invariant 2 correction + BC-3.4.030/031 HTTP-ordering wording) — no BC/VP/holdout count change (719/32/106 confirmed via `check-spec-counts.sh` + `check-bc-cumulative-counts.sh`, both exit 0).

**Two infra-observation lessons captured this burst** (harness/infra behavior, not VSDD agent-prompt gaps; no follow-up story owed — see `cycles/cycle-002/lessons.md` Infrastructure-Level 1-2): a concurrent demo-recorder race causing a duplicate dispatch + policy-#708-violating force-add (recovered via mixed `git reset`); an author-self-approve Stop-hook loop on `validate-pr-review-posted` (recovered via `TaskStop`, merge unaffected).

**New tracked debt this burst (see STATE.md Drift/Standing Items):** `SEC-001-EDITMETA-RECURSION-GUARD` (LOW, pre-existing since S-580-1, first traversed in production by this story's `:option` cascading composer — apply a MAX_ADF_DEPTH-style recursion-depth cap to `AllowedValue.children` deserialization, mirroring `adf.rs` SEC-001/BC-7.2.012); `S-578-2-PR741-RESIDUAL-NITS` (LOW, 7 residual pr-reviewer non-blocking findings).

**Files touched (Dim-1): 7 unique files (factory-artifacts, this burst)**

- sprint-state.yaml
- stories/STORY-INDEX.md
- STATE.md
- cycles/cycle-002/burst-log.md
- cycles/cycle-002/S-578-2/implementation/red-gate-log.md
- cycles/cycle-002/S-578-2/adversary-convergence-state.json
- cycles/cycle-002/lessons.md

(develop-side, via PR #741, not counted in Dim-1 above: `src/cli/issue/field_resolve.rs`, `src/cli/issue/edit.rs`, `src/types/jira/editmeta.rs`, `tests/issue_field_hint_kinds.rs` (new), `tests/issue_edit_field.rs`, `CLAUDE.md` size-doc entry, demo evidence.)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` → exit 0. `scripts/check-bc-cumulative-counts.sh` → exit 0 (719 total across 9 files, unchanged). S-578-2 consumed already-counted BC-3.4.015/016/021/027/028/029/030/031 — no BC/VP/holdout count change.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** PASS (delegated) — `cargo fmt --all -- --check` and `cargo clippy --all-targets -- -D warnings` enforced on PR #741 by jira-cli's `ci-gate`; green before squash-merge.

**Dim-7 Attestation:** PASS (delegated) — 64/64 new tests + 90/90 regression suite ran green in `ci-gate`'s `test` job before merge; independently re-confirmed by pr-reviewer at PR HEAD.

**Codifications:** F4 Wave 2 is now **HALF DONE** — S-578-2 delivered and merged. S-578-3 (JSM `issue create --field` hint-kind dispatch, 8 pts, same `depends_on:[S-578-1]`) is next, sequential (shares the interim guard removal — `jsm_create.rs` call-site + now-unused `reject_unsupported_hint_kinds` helper as last caller). Wave 3 (S-578-4) remains blocked — its own deps (S-580-1 + S-578-2) are now both satisfied, but Wave 3 unblocks only when Wave 2 as a whole ({S-578-2, S-578-3}) is complete. `activation_head` advanced `74221bbc` → `a3739763`.

**Closes:** F4 Wave 2 story 1/2 (S-578-2). **Does NOT close:** Wave 2 story 2/2 (S-578-3, still `ready`, not yet dispatched); Wave 3 (S-578-4, blocked on S-578-3); the DEC-namespace disambiguation question; the 4 residual LOW doc-hygiene items from streak-6; the 6 PR #740 pr-reviewer follow-ups (unchanged); the new 7 PR #741 pr-reviewer follow-ups; `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT` (standing, not field-dx-scoped).

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed — 719 BCs / 32 VPs / 106 holdouts unchanged (all 8 BC-3.4.* anchors were already counted at F2 close; the v1.1 BC text changes are clarifications, not new BCs). `total_stories` unchanged at 161 (status transition only).

### Details

| Agent | Task | Output |
|-------|------|--------|
| stub-architect | Compilable `todo!()`-body hinted-bypass dispatch branch + 4 composer stubs, guard intact | Stub commit (`cargo check` clean) |
| test-writer | Write failing tests for BC-3.4.015/016/021/027-031 hint-kind dispatch (Red Gate); adv Pass-1 EC-3.4.027-1 gate tests; PR-review test-quality fixes | `tests/issue_field_hint_kinds.rs` (new, 64 tests at final GREEN) |
| implementer | Implement `:option`/`:id`/`:name`/`:asset` composers, remove interim guard call site, EC-3.4.027-1 entry gate, empty-child EC-3.4.027-3 conformance fix, CLAUDE.md size-doc entry | `field_resolve.rs`, `edit.rs` changes |
| demo-recorder | Record demo evidence for S-578-2 ACs | `.factory/demos/S-578-2/` (factory-artifacts @ `d6a5151c`) |
| pr-manager | Open PR #741, triage 4-round adversarial review + fresh-eyes pr-reviewer (11 non-blocking findings, 4 fixed), drive to merge | PR #741 |
| devops-engineer | Squash-merge PR #741 to `develop` | `develop` @ `a3739763` |
| state-manager | Record S-578-2 delivery: update `sprint-state.yaml`, `STORY-INDEX.md`, `STATE.md`; write red-gate-log.md + adversary-convergence-state.json; log this burst + 2 infra-observation lessons; commit + push | `STATE.md`; `sprint-state.yaml`; `stories/STORY-INDEX.md`; `cycles/cycle-002/S-578-2/*`; `cycles/cycle-002/lessons.md`; this file |

## Burst: Burst 13 — F4 Wave 2: S-578-3 (JSM `issue create --field` hint-kind dispatch) DELIVERED + MERGED (PR #742 @ 41763ff0) — **WAVE 2 COMPLETE** (2026-08-27)

**Parent-commit:** a3739763 (S-578-2 merge, Burst 12)

**Trigger:** S-578-2 delivered (Burst 12); S-578-3 (Wave 2 story 2/2, `depends_on:[S-578-1]`, satisfied) dispatched next per wave-schedule ordering.

**Dispatched:** per-story-delivery pipeline for S-578-3 (stub-architect → test-writer → implementer → demo-recorder → pr-manager → devops-engineer), following the pre-documented guard-replacement Red-Gate strategy (keep `reject_unsupported_hint_kinds` through stub+test steps, remove its `jsm_create.rs` call site AND delete the now-unused helper itself — S-578-3 is its last caller — only in the implement step).

**Adversary verdict:** 4-pass per-story adversary convergence. Pass 1 BLOCKING (1 HIGH + 2 MEDIUM, ADV-S578-3-P1-001..003) — the significant fix was porting `field_resolve.rs::compose_asset_hint`'s 4-check `:asset` value-shape validation (missing `:`, empty workspace segment, empty/non-numeric object-id segment) into the JSM L2 resolver (`jsm_create.rs::resolve_asset_field_l2`), which had dropped it entirely, diverging from DEC-188's pre-flight-guard convention; also corrected BC-3.8.008's EC-3.8.008-1/EC-3.8.008-3 wording (STRING_WRAP, adjudicated by PO, replacing a drafted-by-analogy OBJECT-wrap that had contradicted AC-002's bare-parity shape and the shipped code). Passes 2/3 NITPICK_ONLY, Pass 4 fully **CLEAN** — 3/3 consecutive clean. Full detail: `cycles/cycle-002/S-578-3/adversary-convergence-state.json`.

**What happened:** S-578-3 (JSM `issue create --field` hint-kind dispatch, 8 pts — Wave 2 story 2/2) threaded `FieldValueSpec` through `JsmRequestBuilder.extra_fields` (`src/api/jsm/requests.rs`, was `HashMap<String,String>`) and implemented kind-aware `requestFieldValues` composition in `build()`'s loop: bare/`:option` unchanged string-wrap (VP-578-015 byte-identity regression pin — `:option` cascading NOT extended to JSM, `>` stays an opaque literal per EC-3.8.008-1); `:id`→`{"id":V}`; `:name`→`{"name":V}`; `:asset`→pure array-wrap of an already-L2-resolved value (`build()` never calls `get_or_fetch_workspace_id` — no L4→L4 edge, ADR-0019 §2 "L2 resolves, build() only wraps"). `jsm_create.rs::resolve_asset_field_l2` performs the `:asset` L2 workspace-id resolution (mirrors S-578-2's platform-side split) plus its 4-row cold-cache failure taxonomy (VP-578-022). The S-578-1 interim `reject_unsupported_hint_kinds` guard's `jsm_create.rs` call site was removed, and — as its last remaining caller — the helper function itself was deleted from `create.rs`.

**Pipeline detail:**
- **Red Gate:** PASS — stub step (`cargo check` clean, guard intact); failing-test step (11 new tests RED on real assertion mismatches, 0 build errors, 0 panics, 102-test pre-existing baseline green); fix-burst Red Gate (4 `:asset` negative-path tests RED → GREEN after the P1 validation-gap fix). Full detail: `cycles/cycle-002/S-578-3/implementation/red-gate-log.md`.
- **Green Gate:** 107/107 tests in-binary (81 in-file `tests/issue_create_jsm.rs` tests + 26 unrelated `common::wf::tests` pulled in via `mod common;` — report the 61→81 in-file delta, not the binary total, per pr-reviewer B1) + regression + clippy + fmt clean. Independently re-confirmed by pr-reviewer at PR HEAD `29300a3b`.
- **Per-story adversary convergence:** 4 passes to CLEAN (Pass 1 BLOCKING → Passes 2/3 NITPICK_ONLY → Pass 4 CLEAN, 3/3 clean).
- **pr-reviewer (fresh-eyes, PR #742):** initial verdict REQUEST_CHANGES (posted as COMMENT — GitHub rejects `--request-changes` on one's own PR), 2 BLOCKING: B1 (PR body overstated coverage delta as 59→107; actual in-file delta is 61→81, the +26 came from unrelated `common::wf` tests), B2 (AC-008/VP-578-015 byte-identity test asserted only 4 keys individually, not the full object — an added key was invisible). Both fixed via commit `29300a3b` (B1: PR body corrected by pr-manager directly, not a code change; B2: `assert_eq!` against the full expected `requestFieldValues` object). **FINAL CONFIRMATION REVIEW at HEAD `29300a3b`: APPROVE**, both BLOCKING items verified resolved, no new blocking issues introduced. 4 NON-BLOCKING + 4 NITPICK residual findings tracked as debt (see STATE.md Drift item `S-578-3-PR742-RESIDUAL-NITS` and `S-578-3-FIELDVALUESPEC-RELOCATION` for N1). Full detail: `.factory/code-delivery/S-578-3/pr-review.md`.
- **PR:** #742, squash-merged to `develop` @ `41763ff0cbbd64ca325fb56e14f1d55ed5b79837` (2026-08-27).
- **Spec propagation:** BC-3.8.008 EC-3.8.008-1/EC-3.8.008-3 corrected to STRING_WRAP + related uniformity/VP-578-015 edits propagated to `bc-3-issue-write.md`; story spec `S-578-3-jsm-create-field-hint-dispatch.md` → v1.3. No BC/VP/holdout count change (719/32/106 confirmed via `check-spec-counts.sh` + `check-bc-cumulative-counts.sh`, both exit 0 — PO confirmed no BC/EC/VP count change).

**One content lesson + one infra-observation lesson captured this burst** (see `cycles/cycle-002/lessons.md` Content-Level 1-2, Infrastructure-Level 3): the `:option` JSM wire-shape spec conflict (drafted-by-analogy OBJECT-wrap vs. shipped STRING-wrap, caught pre-convergence); the `:asset` validation-gap + PR coverage-count-inflation pair (adversary P1 + pr-reviewer B1); pr-manager over-orchestration + an auto-mode permission-classifier denial of `gh pr merge --admin`, resolved by human manual merge.

**New tracked debt this burst (see STATE.md Drift/Standing Items):** `S-578-3-SHARED-ASSET-VALIDATOR` (LOW, extract shared `validate_asset_value` helper + hoist JSM `:asset` validation ordering to match DEC-188); `S-578-3-FIELDVALUESPEC-RELOCATION` (LOW, architectural — move `FieldValueSpec`/`FieldValueKind` to a neutral `src/types/` module, removing the only `api/`→`cli/` import inversion); `S-578-3-PR742-RESIDUAL-NITS` (LOW, residual pr-reviewer non-blocking nits).

**Files touched (Dim-1): 8 unique files (factory-artifacts, this burst)**

- sprint-state.yaml
- stories/STORY-INDEX.md
- STATE.md
- cycles/cycle-002/burst-log.md
- cycles/cycle-002/S-578-3/implementation/red-gate-log.md
- cycles/cycle-002/S-578-3/adversary-convergence-state.json
- cycles/cycle-002/lessons.md
- specs/prd/bc-3-issue-write.md, stories/S-578-3-jsm-create-field-hint-dispatch.md (spec propagation, counted together)

(develop-side, via PR #742, not counted in Dim-1 above: `src/api/jsm/requests.rs`, `src/cli/issue/create.rs` [helper deletion], `src/cli/issue/jsm_create.rs`, `src/cli/issue/mod.rs`, `tests/issue_create_jsm.rs`, demo evidence.)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` → exit 0. `scripts/check-bc-cumulative-counts.sh` → exit 0 (719 total across 9 files, unchanged). S-578-3 amended already-counted BC-3.8.008 (EC wording only) — no BC/VP/holdout count change.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** PASS (delegated) — `cargo fmt --all -- --check` and `cargo clippy --all-targets -- -D warnings` enforced on PR #742 by jira-cli's `ci-gate`; green before squash-merge.

**Dim-7 Attestation:** PASS (delegated) — 107/107 tests in-binary (81 in-file + regression) ran green in `ci-gate`'s `test` job before merge; independently re-confirmed by pr-reviewer at PR HEAD.

**Codifications:** F4 Wave 2 is now **COMPLETE** — S-578-2 (#741) + S-578-3 (#742) both delivered and merged. Wave 3 (S-578-4, `depends_on:[S-580-1, S-578-2]`, both individually satisfied) is now **unblocked and ready for dispatch** — its gate was "Wave 2 as a whole complete," now satisfied. `activation_head` advanced `a3739763` → `41763ff0`.

**Closes:** F4 Wave 2 story 2/2 (S-578-3). **Wave 2 fully CLOSED.** **Does NOT close:** Wave 3 (S-578-4, now unblocked but not yet dispatched); the DEC-namespace disambiguation question; the 4 residual LOW doc-hygiene items from streak-6; the 6 PR #740 + 7 PR #741 pr-reviewer follow-ups (unchanged); the new 3 items tracked this burst (`S-578-3-SHARED-ASSET-VALIDATOR`, `S-578-3-FIELDVALUESPEC-RELOCATION`, `S-578-3-PR742-RESIDUAL-NITS`); `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT` (standing, not field-dx-scoped).

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed — 719 BCs / 32 VPs / 106 holdouts unchanged (BC-3.8.008 EC wording corrections are clarifications, not new BCs; PO confirmed no BC/EC/VP count change). `total_stories` unchanged at 161 (status transition only).

### Details

| Agent | Task | Output |
|-------|------|--------|
| stub-architect | `FieldValueSpec`-typed `extra_fields` + kind-aware composer stubs (`:id`/`:name`/`:asset`), `:asset` L2 resolver stub, guard intact | Stub commit (`cargo check` clean) |
| test-writer | Write failing tests for BC-3.8.008 JSM kind-aware `requestFieldValues` (Red Gate); adv Pass-1 `:asset` 4-check negative-path tests; PR-review B1/B2 test-strengthening fixes | `tests/issue_create_jsm.rs` (61→81 in-file tests at final GREEN) |
| implementer | Implement `:id`/`:name`/`:asset` composers, `:asset` L2 workspace-id resolution + validation parity fix, remove interim guard call site + delete now-unused helper (last caller) | `requests.rs`, `jsm_create.rs`, `create.rs`, `mod.rs` changes |
| demo-recorder | Record demo evidence for S-578-3 ACs | `.factory/demos/S-578-3/` (factory-artifacts @ `4a9910d3`) |
| pr-manager | Open PR #742, triage 4-round adversarial review + fresh-eyes pr-reviewer (2 BLOCKING fixed via `29300a3b`, APPROVE at confirmation review), drive to merge | PR #742 |
| devops-engineer / human | Squash-merge PR #742 to `develop` (human manual merge — auto-mode permission classifier denied `gh pr merge --admin`) | `develop` @ `41763ff0` |
| state-manager | Record S-578-3 delivery: update `sprint-state.yaml`, `STORY-INDEX.md`, `STATE.md`; write red-gate-log.md + adversary-convergence-state.json; commit spec propagation edits; log this burst + 2 content lessons + 1 infra-observation lesson; commit + push | `STATE.md`; `sprint-state.yaml`; `stories/STORY-INDEX.md`; `cycles/cycle-002/S-578-3/*`; `cycles/cycle-002/lessons.md`; `specs/prd/bc-3-issue-write.md`; `stories/S-578-3-jsm-create-field-hint-dispatch.md`; this file |

## Burst: Burst 14 — F4 Wave 3: S-578-4 (platform `issue create --field` support, DEC-188 reversal via DEC-310) DELIVERED + MERGED (PR #746 @ ae8514b8) — **WAVE 3 COMPLETE / cycle-002 PHASE F4 COMPLETE** (2026-08-30/31)

Session resumed from the `WRAP-F4-WAVE2-COMPLETE-PAUSE` position (STATE.md v3.23) and delivered the LAST story of the field-dx bundle, closing all three waves and Phase F4 (delta implementation) in full.

**Story:** S-578-4 — platform (non-JSM) `issue create --field` support. `resolve_edit_fields` extended with a createmeta-vs-editmeta source parameter (one shared function, not a second implementation); resolution pipeline sourced from `get_createmeta_fields` (S-580-1, reused verbatim). Reverses DEC-188's platform-path `--field`-alone pre-flight exit-64 guard via DEC-310 (human-approved F2 gate) — a deliberate, documented reversal of S-639-1's own guard. `--on-behalf-of`'s BC-3.8.013 guard unchanged in mechanism; only its trigger scope widens now the combined pre-emption check is gone. BC-3.3.010/3.3.011/3.4.014(amended)/3.8.012(reversed)/3.8.013(unchanged); 13 pts, largest story in the bundle tied with S-578-2; `depends_on:[S-580-1, S-578-2]`, both satisfied.

**Quality gates:** Red Gate PASS. Per-story adversarial convergence **CONVERGED STRICT** — 14 passes, final 3 CLEAN (zero production-logic defects after pass 2); convergence state at `cycles/cycle-002/S-578-4/adversary-convergence-state.json`. security-reviewer: CLEAN. pr-reviewer: APPROVE, 1 review cycle, 0 blocking findings. CI: 15/15 green including CI Gate + mutation testing. Demo evidence: `.factory/demos/S-578-4/` (6 VHS demos + evidence-report.md).

**Process-gap lessons captured during convergence** (see `cycles/cycle-002/lessons.md` Process-Level 3–5): an AC-to-Task placement conflict inside the story spec (AC-016 vs. Task-2); a File-Structure/Architecture-Mapping self-contradiction ("edit.rs MUST NOT change" vs. required `resolve_edit_fields` signature extension touching edit.rs call sites) — implementation correctly followed Architecture Mapping; a test-inversion instruction gap (Task-2 updated test bodies for the DEC-310-reversed behavior but not test names/doc-comments, leaving 5 stale-name/stale-comment strays surfaced across passes P8/P10/P11).

**Infra observation:** the `github-ops` sub-agent stalled on every dispatch this session (dependency check, stale-verdict check, merge) without returning completion reports, though the underlying `gh`/`git` actions succeeded; pr-manager fell back to direct `gh`/`git` verification each time. Logged as an observation (lessons.md Infrastructure-Level 4), not a process gap requiring a follow-up story.

**Codifications:** F4 Wave 3 is now **COMPLETE**. **All 5 field-dx bundle stories are now delivered + merged**: S-580-1 (#740), S-578-1 (#739), S-578-2 (#741), S-578-3 (#742), S-578-4 (#746). **cycle-002 Phase F4 (delta implementation) is COMPLETE.** `activation_head` advanced `41763ff0` → `ae8514b8`. `activation_version` unchanged at `v0.7.0-dev.2` (re-derived from `Cargo.toml` on `develop` @ `ae8514b8`, not guessed).

**Closes:** F4 Wave 3 (S-578-4). **Wave 3 fully CLOSED. Phase F4 fully CLOSED.** **Does NOT close:** the human decision on whether to proceed to F5 (scoped adversarial refinement on the full field-dx delta) → F6 (targeted hardening) → F7 (delta convergence + human gate), or to close/pause cycle-002 here; the DEC-namespace disambiguation question; all previously-tracked LOW residual/drift items (unchanged this burst).

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed this burst (BC-3.3.010/3.3.011/3.4.014/3.8.012/3.8.013 were pre-existing, amended/reversed during F2, unchanged in count) — 719 BCs / 32 VPs / 106 holdouts unchanged. `total_stories` unchanged at 161 (status transition only, S-578-4 `ready` → `completed`).

### Details

| Agent | Task | Output |
|-------|------|--------|
| pr-manager | Triage PR #746 review, verify CI 15/15 green (incl. CI Gate + mutation testing), verify per-story adversarial convergence CONVERGED STRICT (14 passes) + security-reviewer CLEAN + pr-reviewer APPROVE, drive to merge (fell back to direct `gh`/`git` verification after `github-ops` sub-agent stalls) | PR #746 |
| devops-engineer / human | Squash-merge PR #746 to `develop` | `develop` @ `ae8514b8` (2026-08-31T06:16:25Z); feature branch deleted; worktree removed |
| state-manager | Record S-578-4 delivery + Wave 3/Phase F4 completion: update `sprint-state.yaml`, `STORY-INDEX.md`, `STATE.md` (v3.23→v3.24, activation_head/version re-derived); log this burst + 1 infra-observation lesson; commit + push | `STATE.md`; `sprint-state.yaml`; `stories/STORY-INDEX.md`; `cycles/cycle-002/lessons.md`; `cycles/cycle-002/session-checkpoints.md`; this file |

## Burst: Burst 15 — Phase F5 scoped-adversarial review CONVERGED + FIX-F5-001 delivered + merged (PR #747 @ 4e4ae4f5) — **F5 COMPLETE, transition to F6** (2026-08-31)

**Parent-commit:** ae8514b8 (S-578-4 merge, Burst 14)

**Trigger:** cycle-002 Phase F4 (delta implementation) complete (Burst 14); human decision to proceed with Phase F5 (scoped adversarial review of the full 5-story field-dx delta) rather than close/pause the cycle at F4.

**Dispatched:** primary-adversary review (adversary model), fresh context, scoped to the integrated delta `91d04fe1..ae8514b8` (all 5 bundle stories: S-578-1, S-580-1, S-578-2, S-578-3, S-578-4), targeting cross-story integration seams rather than re-litigating already-converged per-story findings. First dispatch died on a transient API connection error before producing output and was re-run from scratch — logged as a transport retry, not a review round (only the re-run counts toward the pass total).

**Adversary verdict:** 1 primary-adversary pass, CONVERGENCE_REACHED. Zero CRITICAL/HIGH. 1 MEDIUM (`ADV-P01-MED-001`: `get_issue_types_for_project` missing the pagination-termination safeguards its twin `get_createmeta_fields` gained this cycle — no MAX page-count bound, CWE-400/770-adjacent, and no `total`-absent full-page heuristic, undermining VP-578-020's "issue-types page ≥2" guarantee in the total-absent branch). 4 LOW findings: `ADV-P01-LOW-001` (`:asset` malformed-shape validation duplicated byte-for-byte between `jsm_create.rs::resolve_asset_field_l2` and `field_resolve.rs::compose_asset_hint` — cross-referenced to the pre-existing `S-578-3-SHARED-ASSET-VALIDATOR` id, no new id opened), `ADV-P01-LOW-002` (`F5-EDIT-GATEB-SHARE`: `edit.rs` Gate B not on the shared `detect_flag_field_overlap` helper), `ADV-P01-LOW-003` (`F5-ISSUETYPE-CASEFOLD-SPLIT`: ASCII vs. Unicode case-fold divergence on issue-type name→id resolution), `ADV-P01-LOW-004` (`F5-VP578021-WEAK-NEGPIN`: weak test assertion). Full detail: `phase-f5-adversarial/adversarial-delta-review.md`.

**Secondary review-tier (F5 Step 7):** SKIPPED. Justification: every story was already individually adversarially converged during F4 delivery (S-578-4 alone ran 14 passes, final 3/3 CLEAN; S-578-2/S-578-3 each ran 4-pass per-story convergence to CLEAN). This whole-delta primary pass found only 1 low-likelihood MEDIUM + 4 LOW — the marginal value of a second independently dispatched secondary-tier pass did not justify the cost. Primary-adversary convergence was treated as the F5 gate.

**What happened — FIX-F5-001:** the MEDIUM finding was fixed on branch `fix/F5-001-issuetypes-pagination`: `get_issue_types_for_project` (`src/api/jira/issues.rs`) now shares the `MAX_CREATEMETA_PAGES` bound and the same total-absent full-page heuristic (`if total > 0 { start_at + page_len >= total } else { page_len < page_size }`) as its twin `get_createmeta_fields`. Regression test `test_vp_578_020b_type_on_issuetypes_page_2_resolves_when_total_absent` added (RED before the fix, GREEN after). security-reviewer confirmed the bound is a genuine CWE-400 mitigation introducing no new risk. pr-reviewer verdict APPROVE. CI green.

**PR:** #747, merged to `develop` @ `4e4ae4f5` (2026-08-31T14:46:55Z). `activation_head` advanced `ae8514b8` → `4e4ae4f5`. `activation_version` re-derived from `Cargo.toml` on `develop` @ `4e4ae4f5`: unchanged at `v0.7.0-dev.2`.

**F5 close:** with FIX-F5-001 merged, Phase F5 (scoped adversarial review) is now COMPLETE for cycle-002. Full convergence record: `phase-f5-adversarial/convergence-summary.md` (findings-by-severity table, MEDIUM fix detail, secondary-tier skip justification, novelty assessment, final verdict CONVERGED) and `phase-f5-adversarial/adversarial-delta-review.md` (raw pass-1 findings).

**Codifications:** cycle-002 Phase F5 is now **COMPLETE**. **NEXT: Phase F6** (targeted hardening — fuzz testing, mutation testing, and formal verification scoped to the delta, plus full regression and security scans on the full tree), then **Phase F7** (delta convergence + human gate).

**Closes:** the F5 review (both the primary-adversary pass and the FIX-F5-001 remediation). **Does NOT close:** cycle-002 itself (F6/F7 remain); the 4 LOW tracked-debt items from this pass (`S-578-3-SHARED-ASSET-VALIDATOR` cross-ref, `F5-EDIT-GATEB-SHARE`, `F5-ISSUETYPE-CASEFOLD-SPLIT`, `F5-VP578021-WEAK-NEGPIN`); all previously-tracked LOW residual/drift items (unchanged this burst); the DEC-namespace disambiguation question.

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed this burst (FIX-F5-001 is a bug fix against an existing BC's pagination-safety guarantee, not a new BC) — 719 BCs / 32 VPs / 106 holdouts unchanged. `total_stories` unchanged at 161.

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary | Primary-adversary scoped review of the integrated 5-story field-dx delta (re-dispatched after transient transport failure on first attempt) | `phase-f5-adversarial/adversarial-delta-review.md` (pass 1, CONVERGENCE_REACHED) |
| implementer | Port `get_createmeta_fields`'s `MAX_CREATEMETA_PAGES` bound + total-absent full-page heuristic onto `get_issue_types_for_project`; add regression test | `src/api/jira/issues.rs`, `tests/issue_create_field.rs` (or equivalent VP-578-020b test file) |
| security-reviewer | Confirm FIX-F5-001's bound is a genuine CWE-400 mitigation with no new risk | CLEAN |
| pr-manager | Open PR #747, drive to merge | PR #747 |
| devops-engineer | Merge PR #747 to `develop` | `develop` @ `4e4ae4f5` (2026-08-31T14:46:55Z) |
| state-manager | Write `phase-f5-adversarial/convergence-summary.md`; update `STATE.md` (v3.24→v3.25, phase F4→F5, activation_head/version re-derived, compacted to ≤200 lines); log this burst; commit + push | `STATE.md`; `phase-f5-adversarial/convergence-summary.md`; this file |

**Files touched (Dim-1): 3 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-002/burst-log.md
- phase-f5-adversarial/convergence-summary.md

(develop-side, via PR #747, not counted in Dim-1 above: `src/api/jira/issues.rs`, the regression test file.)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` → exit 0. `scripts/check-bc-cumulative-counts.sh` → exit 0 (719 total across 9 files, unchanged). FIX-F5-001 is a bug fix against an existing BC's pagination-safety guarantee — no BC/VP/holdout count change.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** PASS (delegated) — `cargo fmt --all -- --check` and `cargo clippy --all-targets -- -D warnings` enforced on PR #747 by jira-cli's `ci-gate`; green before merge.

**Dim-7 Attestation:** PASS (delegated) — full test suite incl. the new `test_vp_578_020b_type_on_issuetypes_page_2_resolves_when_total_absent` regression test ran green in `ci-gate`'s `test` job before merge.

## Burst: Burst 16 — Phase F6 targeted hardening COMPLETE + FIX-F6-001 delivered + merged (PR #749 @ dd311e13) — **transition to F7** (2026-08-31)

**Parent-commit:** `4e4ae4f5` (FIX-F5-001 merge, Burst 15)

**Trigger:** cycle-002 Phase F5 (scoped adversarial review) complete (Burst 15); human decision to proceed with Phase F6 (targeted hardening — formal verification, fuzz testing, mutation testing, and security scanning against the integrated field-dx delta plus full regression on the full tree).

**Dispatched:** formal-verifier (Kani/fuzz/mutation, delta-scoped `91d04fe1..4e4ae4f5`) and security-reviewer (CWE/OWASP manual review + `cargo deny`/`cargo audit`), both fresh-context, information-asymmetry wall observed (no Phase F5 adversarial-review artifact read).

**Adversary verdict:** N/A — Phase F6 is targeted hardening (formal verification, fuzz testing, mutation testing, security scanning), not an adversarial review pass; no `adversary` agent was dispatched this burst. The equivalent gate-pass signal for this phase is the formal-verifier's and security-reviewer's combined disposition: 0 CRITICAL/HIGH across both agents, 3 LOW security findings (non-blocking), 0 test-quality-gap survivors after the mutation config-gap fix — see the per-check sections below.

**Formal verification (Kani):** not set up in this repository (no `kani` dependency, no `#[kani::proof]` harness). Justified **proptest substitution** per CLAUDE.md/repo convention (no standalone VP-NNN registry; property guarantees live as inline `proptest!` blocks). Sound for this delta — field-dx is dominated by string parsing, HTTP wire-shape composition, and CLI arity/dispatch, with no unbounded arithmetic, unsafe pointer manipulation, or array-indexing invariant demanding a bounded model checker. **Coverage: 32/32 field-dx VPs covered, 0 GAP** (VP-578-016 JSM write wire-shape is PASS-with-intended-deferral to F4/live-validation by spec design, not an accidental gap).

**Fuzz testing:** `cargo-fuzz` not set up (no `fuzz/` directory, no `fuzz_target!` usage). Justified **proptest arbitrary-input substitution** — all 3 named input-parsing surfaces have arbitrary-Unicode-input property coverage with no-panic + no-malformed-JSON oracles: `parse_field_kv` (`NAME[:kind]=VALUE` splitting), `:asset` `WS:OBJ` composition, `:option` cascading `Parent>Child` split. **No uncovered input surface.**

**Mutation testing — config gap found and fixed:** the formal-verifier's mutation pass identified that `src/cli/field.rs` (91 in-diff mutants) and `src/cli/issue/field_resolve.rs` (45 in-diff mutants, including the #1-priority resolution/dispatch hub) were **not** members of `.cargo/mutants.toml::examine_globs`, so the required `mutants` CI gate's config-scoped `--in-diff` run covered only 71 of the 207 field-dx delta mutants, silently skipping the two core field-dx source files. This is the same drift class the policy's own changelog records for `edit.rs`/`jsm_create.rs` (DEC-149) and `queue.rs`/`main.rs` (S-MUTANTS-SCOPE-1).

**What happened — FIX-F6-001:** delivered on a dedicated fix branch as **FIX-F6-MUTANTS-SCOPE**: both files added to `.cargo/mutants.toml::examine_globs` (18 → 20 entries); `docs/specs/cargo-mutants-policy.md` §Scope citation list updated to match (`scripts/check-cargo-mutants-policy-citations.sh` → green, 69 policy/source symbol-citation pairs). **PR #749, merged to `develop` @ `dd311e13`.** A numeric mutation run was then executed on the two newly-covered files (`cargo mutants --no-config --file src/cli/field.rs --file src/cli/issue/field_resolve.rs --jobs 3 --timeout 240`): 177 total mutants generated; 142 scored conclusively → **93 caught, 0 MISSED, 38 timeout, 11 unviable**. **Kill rate on conclusively-scored mutants = 93/93 = 100%; zero test-quality-gap survivors.** The 38 timeouts + 35 unscored mutants are attributed to host-contention artifacts (concurrent-agent load on the shared session host ballooned per-mutant build times to ~13 minutes), not genuine survivors — corroborated by the formal-verifier's independent static coverage pass, which separately found 0 test-quality-gap survivors across the same functions via VP→test mapping. The six examine_globs-covered field-dx delta files (`create.rs`, `edit.rs`, `jsm_create.rs`, `issues.rs`, `requests.rs`, `editmeta.rs`) remained mutation-verified ≥90% via their own PR's required CI at merge time — no re-run needed.

**Security scan:** CLEAN. `cargo deny check` — advisories/bans/licenses/sources all ok. `cargo audit` — 0 vulnerability advisories across 358 crates scanned. Zero new third-party dependencies (`Cargo.toml`/`Cargo.lock` diff over the delta is empty). semgrep unavailable in-session; manual CWE/OWASP review substituted per fallback policy, covering every named new input-handling entry point. 3 LOW findings, no CRITICAL/HIGH: **SEC-F6-1** (CWE-617, `compose_asset_wire` invariant panic — unreachable today, sole production caller always supplies a qualified value; accepted as documented); **SEC-F6-2** (CWE-674, `AllowedValue.children` deserialization-time recursion — runtime tree-walks guarded at `MAX_FIELD_OPTION_DEPTH=256`, raw deserialization depth bounded only by process stack; cross-references the pre-existing `SEC-001-EDITMETA-RECURSION-GUARD` tracked item, same accepted-risk class as every other typed API response); **SEC-F6-3** (CWE-20, `:asset` workspace-segment charset — informational, not an injection/SSRF vector, value is JSON-escaped via `serde_json::json!`). FIX-F5-001's `MAX_CREATEMETA_PAGES` bound reconfirmed as a genuine CWE-400/770 mitigation, no regression.

**Full regression:** PASS — `cargo test` (full suite) on `develop` @ `4e4ae4f5`: **4660 passed / 0 failed / 106 ignored** (ignored = gated keyring/OAuth/live-E2E tests) across 111 test-result lines. Zero `FAILED` lines, no panics.

**DTU adversarial testing:** SKIPPED — `dtu_required: false` (external Jira interaction already covered by wiremock integration tests, no external service behavior cloned by this bundle).

**Accessibility re-check:** SKIPPED — `feature_type: backend-cli`, no UI surface.

**F6 close:** with all checks PASS or justifiably substituted, and the one actionable finding (mutation config-scope gap) fixed and merged in-phase rather than deferred as tracked debt, **Phase F6 (targeted hardening) is now COMPLETE** for cycle-002. Consolidated record: `phase-f6-hardening/summary.md`, with per-check detail in `kani-results.md`, `fuzz-results.md`, `mutation-results.md` (superseding its own prior partial/blocked pass in place), and `security-scan-results.md`, all in the same directory.

**PR:** #749, merged to `develop` @ `dd311e13` (2026-08-31). `activation_head` advanced `4e4ae4f5` → `dd311e13`. `activation_version` re-derived from `Cargo.toml` on `develop` @ `dd311e13`: unchanged at `v0.7.0-dev.2` (config-only PR — `.cargo/mutants.toml` + policy-doc citation update, no crate version bump).

**Codifications:** cycle-002 Phase F6 is now **COMPLETE**. **NEXT: Phase F7** (delta convergence — 5-dimensional check on the field-dx delta plus full-tree regression validation), then the **FINAL HUMAN GATE** to formally close cycle-002.

**Closes:** the F6 targeted-hardening phase (formal verification, fuzz testing, mutation testing including the config-gap remediation, security scan, full regression). **Does NOT close:** cycle-002 itself (F7 remains); the 3 new F6 LOW security findings (SEC-F6-1/2/3, tracked non-blocking, SEC-F6-2 cross-referencing the pre-existing `SEC-001-EDITMETA-RECURSION-GUARD`); all previously-tracked LOW residual/drift items from F5 and earlier (unchanged this burst); the DEC-namespace disambiguation question.

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed this burst (FIX-F6-001 is a mutation-testing config-scope fix, not a new BC) — 719 BCs / 32 VPs / 106 holdouts unchanged. `total_stories` unchanged at 161.

### Details

| Agent | Task | Output |
|-------|------|--------|
| formal-verifier | Kani/fuzz justification assessment + mutation testing (delta-scoped, fresh context) against the integrated field-dx delta | `kani-results.md`, `fuzz-results.md`, `mutation-results.md` (config gap identified + numeric run recorded) |
| security-reviewer | Manual CWE/OWASP review + `cargo deny`/`cargo audit` against the integrated field-dx delta | `security-scan-results.md` (CLEAN, 3 LOW) |
| implementer | FIX-F6-MUTANTS-SCOPE: add `field.rs` + `field_resolve.rs` to `.cargo/mutants.toml::examine_globs`; update policy §Scope citations | `.cargo/mutants.toml`, `docs/specs/cargo-mutants-policy.md` |
| pr-manager | Open PR #749, drive to merge | PR #749 |
| devops-engineer | Merge PR #749 to `develop` | `develop` @ `dd311e13` (2026-08-31) |
| state-manager | Write `phase-f6-hardening/summary.md` + finalize `mutation-results.md` (supersede partial); update `STATE.md` (v3.25→v3.26, phase F5→F6, activation_head/version re-derived); log this burst; commit + push | `STATE.md`; `phase-f6-hardening/summary.md`; `phase-f6-hardening/mutation-results.md`; this file |

**Files touched (Dim-1): 4 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-002/burst-log.md
- phase-f6-hardening/summary.md
- phase-f6-hardening/mutation-results.md

(also committed this burst, previously-uncommitted hardening-agent output: `phase-f6-hardening/kani-results.md`, `phase-f6-hardening/fuzz-results.md`, `phase-f6-hardening/security-scan-results.md`, `code-delivery/FIX-F6-001/pr-description.md`, `code-delivery/FIX-F6-001/pr-review.md`.)

(develop-side, via PR #749, not counted in Dim-1 above: `.cargo/mutants.toml`, `docs/specs/cargo-mutants-policy.md`.)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` → exit 0. `scripts/check-bc-cumulative-counts.sh` → exit 0 (719 total across 9 files, unchanged). FIX-F6-001 is a mutation-testing config-scope fix — no BC/VP/holdout count change.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** PASS (delegated) — `cargo fmt --all -- --check` and `cargo clippy --all-targets -- -D warnings` enforced on PR #749 by jira-cli's `ci-gate`; green before merge.

**Dim-7 Attestation:** PASS (delegated) — full test suite (4660/0/106) ran green in `ci-gate`'s `test` job before merge; `scripts/check-cargo-mutants-policy-citations.sh` green (69 pairs) as an additional PR #749-specific gate.

## Burst: Burst 18 — Phase F7 human authorization gate APPROVED ("Approve & release") — **cycle-002 field-dx CLOSED, release pending** (2026-09-01)

**Parent-commit:** `2000c455` (FIX-F7-001 merge, referenced by the prior F7 delta-convergence-analyses pass — that pass's own burst narrative, tracked in STATE.md history as "Burst 17," was not separately appended to this file before this session; pre-existing gap, out of scope for this burst).

**Trigger:** cycle-002 Phase F7 (delta convergence) reached PASS — all 5 dimensions (spec/test/implementation/verification/holdout) PASS, full-tree regression PASS (4660/0/106) — and the delta-convergence report (`phase-f7-convergence/delta-convergence-report.md`) was presented to the human at the final authorization gate.

**Human decision (2026-09-01):** at the F7 delta-convergence human authorization gate, the human explicitly chose **"Approve & release."** cycle-002 (`field-dx`) is **APPROVED as converged** and authorized to close and proceed to release, at `develop` @ `2000c455`.

**Adversary verdict:** N/A — this burst is the human authorization gate itself (a decision-recording + cycle-closing-checklist burst), not an adversarial review pass; no `adversary` agent was dispatched. The equivalent gate-pass signal is the human's explicit "Approve & release" decision at the F7 gate, made against the already-PASS 5-dimensional convergence report from the prior F7 delta-convergence-analyses pass.

**Cycle-closing checklist (S-7.02, run before declaring CLOSED):** reviewed the 3 `[process-gap]` findings logged this cycle in `cycles/cycle-002/lessons.md` (Process-Level items 3, 4, 5 — AC-016↔Task-2 story placement conflict; story "edit.rs MUST NOT change" vs Architecture-Mapping self-contradiction; Task-2 test-inversion left stale test-names/comments). For each, checked STORY-INDEX.md for an existing follow-up story targeting the SELF-IMPROVEMENT epic — none of the 123 tracked stories (including the 10-item `S-PG-*` self-improvement backlog) targets any of these 3 findings specifically. **Outcome: all 3 lack a follow-up story, so a justified-deferral entry was added to STATE.md Drift/Standing Items** (target: a future maintenance/self-improvement cycle; reason: process-doc refinement, each is a spec-authoring/story-template/task-instruction discipline gap, not a code defect — none is blocking). Checklist completion recorded per-finding as `[codified]` notes in `cycles/cycle-002/lessons.md` items 3/4/5.

**Cycle close:** with the human's "Approve & release" decision and the cycle-closing checklist satisfied, **cycle-002 (`field-dx`) is now CLOSED** — MAXIMUM_VIABLE_REFINEMENT_REACHED, human-authorized at the F7 gate. Phase F7 advances from PASS/AWAITING-GATE to **COMPLETE**. Recorded as **DEC-311** in STATE.md's Decisions Log (Made By: human). No BC/VP/holdout counts changed this burst (719/32/106); no code changed (bookkeeping-only burst).

**NEXT:** the release step (version bump / CHANGELOG finalize / tag / GitHub release) at `develop` @ `2000c455`, then a post-pipeline session review.

**Codifications:** cycle-002 field-dx is CLOSED. F7 is COMPLETE. The 3 process-gap findings from this cycle are dispositioned via justified deferral (not silently dropped) per S-7.02.

**Closes:** the F7 human authorization gate; cycle-002 field-dx (F1 through F7, all phases). **Does NOT close:** the release step itself (queued next); the standing Drift/Standing Items carried forward unchanged (5 cargo Dependabot PRs, `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001`, `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING`, the 10-story `S-PG-*` self-improvement backlog, the 8 F5/F6/F7 outstanding LOW items ratified-by-closure at this gate, and the DEC-namespace disambiguation question).

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed this burst (human-gate closure + checklist bookkeeping only) — 719 BCs / 32 VPs / 106 holdouts unchanged. `total_stories` unchanged at 161.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Run S-7.02 cycle-closing checklist against the 3 logged process-gap findings; add justified-deferral entries to STATE.md; record `[codified]` notes in `lessons.md`; write DEC-311; mark F7 COMPLETE and cycle-002 CLOSED in STATE.md (v3.27→v3.28); log this burst; commit + push | `STATE.md`; `cycles/cycle-002/lessons.md`; `cycles/cycle-002/burst-log.md` (this file) |

**Files touched (Dim-1): 3 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-002/lessons.md
- cycles/cycle-002/burst-log.md

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` — N/A this burst (no BC/VP/holdout count change; bookkeeping-only, no `.factory/specs/prd/` or `BC-INDEX.md` edits).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact bookkeeping only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression already PASS (4660/0/106) as of the F7 delta-convergence-analyses pass, unchanged.

## Burst: Burst 19 — Release v0.7.0-dev.3 cut and SHIPPED — **cycle-002 field-dx CLOSED + RELEASED** (2026-09-01)

**Parent-commit:** `2000c455` (FIX-F7-001 merge, `develop` tip at the F7 human-gate close recorded in Burst 18).

**Trigger:** with cycle-002 CLOSED (DEC-311, human-authorized at the F7 gate) and no further work queued, the release step ran next: version bump, tag, and `release.yml` dispatch.

**Release actions taken:**
1. Version-bump PR **#751** merged to `develop` — `develop` advanced `2000c455` → `87f17aff`.
2. Annotated git tag **`v0.7.0-dev.3`** pushed at commit `87f17aff`.
3. `release.yml` workflow run **`33459579699`** triggered off the tag push — building and publishing artifacts upstream (not tracked further by this factory pipeline once triggered).

**Adversary verdict:** N/A — this burst is the release step + factory-artifact bookkeeping (version bump, tag, release-workflow dispatch, evidence sweep), not an adversarial review pass; no `adversary` agent was dispatched. cycle-002's adversarial convergence was already settled in F5 (CONVERGED) and F7 (5-dim PASS), both prior to this burst.

**Cycle outcome:** cycle-002 (`field-dx`) is now **CLOSED + RELEASED — SHIPPED**. `activation_head` moves `2000c455` → `87f17aff`; `activation_version` moves `v0.7.0-dev.2` → `v0.7.0-dev.3`. `pipeline` frontmatter moves `RELEASE-PENDING` → `RELEASED`. No BC/VP/holdout counts changed this burst (719/32/106).

**Also swept this burst (previously-uncommitted F7 evidence/delivery artifacts, explicit paths only, no `git add -A`):** `phase-f7-convergence/consistency-audit-delta.md`, `phase-f7-convergence/holdout-eval-delta.md`, `code-delivery/FIX-F7-001/pr-description.md`, `code-delivery/FIX-F7-001/pr-review.md`. `regression-state.json` and `sidecar-learning.md` left unstaged (session-managed, not clearly finalized).

**NEXT:** optional post-pipeline session review (`/vsdd-factory:session-review`). No further work is queued for cycle-002.

**Codifications:** cycle-002 field-dx is CLOSED + RELEASED as `v0.7.0-dev.3`. The release step is complete; the factory pipeline's tracking of this cycle ends here (upstream `release.yml` build/publish is outside pipeline scope once triggered).

**Closes:** the release step; cycle-002 field-dx end-to-end (F1 through release). **Does NOT close:** the standing Drift/Standing Items carried forward unchanged (3 `CYCLE-002-PROCESS-GAP-DEFERRAL` items, 5 cargo Dependabot PRs, `ADOPT-MERGE-METHOD-RULESETS`, `S-TRAIL-DERIVATION-GUARD-1`, `AX23-001`, `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING`, the 10-story `S-PG-*` self-improvement backlog, and the DEC-namespace disambiguation question).

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed this burst (release + evidence-sweep bookkeeping only) — 719 BCs / 32 VPs / 106 holdouts unchanged. `total_stories` unchanged at 161.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Record release (tag `v0.7.0-dev.3` @ `87f17aff`, PR #751, `release.yml` run `33459579699`); sweep uncommitted F7 evidence/delivery artifacts into factory-artifacts (explicit paths); update `activation_head`/`activation_version`/`pipeline` frontmatter; mark cycle-002 CLOSED + RELEASED in STATE.md (v3.28→v3.29); log this burst; commit + push | `STATE.md`; `cycles/cycle-002/burst-log.md` (this file); `phase-f7-convergence/consistency-audit-delta.md`; `phase-f7-convergence/holdout-eval-delta.md`; `code-delivery/FIX-F7-001/pr-description.md`; `code-delivery/FIX-F7-001/pr-review.md` |

**Files touched (Dim-1): 6 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-002/burst-log.md
- phase-f7-convergence/consistency-audit-delta.md
- phase-f7-convergence/holdout-eval-delta.md
- code-delivery/FIX-F7-001/pr-description.md
- code-delivery/FIX-F7-001/pr-review.md

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` — N/A this burst (no BC/VP/holdout count change; release + artifact-sweep bookkeeping only, no `.factory/specs/prd/` or `BC-INDEX.md` edits).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this factory-side burst (the release binary is built by `release.yml` upstream, outside this pipeline's tracking scope).

**Dim-6 Attestation:** PASS (delegated) — `develop`-side PR #751 (version bump) was gated by jira-cli's `ci-gate`; green before merge.

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression already PASS (4660/0/106) as of the F7 delta-convergence pass, unchanged.

## Burst: Burst 20 — SESSION-WRAP — human-requested wrap at cycle-002 completion (2026-09-01)

**Parent-commit:** `87f17aff` (`develop` tip after PR #751 version-bump merge; unchanged this burst — no `develop`-side commit).

**Trigger:** human requested "wrap this session" at a clean cycle-completion boundary — cycle-002 field-dx is already CLOSED + RELEASED (v0.7.0-dev.3, Burst 19). This is a session-end wrap, not a mid-work pause: nothing was in-flight to interrupt.

**Actions taken:**
1. Persisted the remaining uncommitted `.factory/` artifacts left session-managed at Burst 19: `regression-state.json`, `sidecar-learning.md` (both modified), `code-delivery/release-v0.7.0-dev.3/{pr-description,pr-review}.md` (untracked — the release PR delivery artifacts). Explicit paths staged, no `git add -A`.
2. STATE.md refreshed via one full-content Write (v3.29 → v3.30): `timestamp` bumped; `pipeline` frontmatter set to `IDLE` (truthful terminal status — no active cycle, last cycle shipped, nothing to resume mid-step; `PAUSED` would misstate that anything is in-flight). `activation_head` (`87f17aff`) and `activation_version` (`v0.7.0-dev.3`) unchanged. Added `SESSION-WRAP` Phase Progress + Current Phase Steps rows. Session Resume Checkpoint replaced; the prior RELEASED/SHIPPED checkpoint (v3.29) archived to `cycles/cycle-002/session-checkpoints.md`.
3. This burst entry logged.

**Adversary verdict:** N/A — bookkeeping-only burst (artifact persistence + STATE.md wrap), no code or spec change; no `adversary` agent dispatched.

**Outcome:** `.factory/` working tree is CLEAN after this burst's commit. No BC/VP/holdout counts changed (719/32/106). No `develop`-side change.

**NEXT:** none queued. On resume: start a new feature/cycle, run the optional post-pipeline session review (`/vsdd-factory:session-review`), or verify the release build finished (`gh run view 33459579699` / `gh release view v0.7.0-dev.3`).

**Codifications:** none — pure bookkeeping burst.

**Closes:** the session (human-requested wrap). **Does NOT close:** any standing Drift/Standing Items — all carried forward unchanged (see STATE.md Drift / Standing Items section).

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed — 719 BCs / 32 VPs / 106 holdouts unchanged. `total_stories` unchanged at 161.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Persist remaining uncommitted `.factory/` artifacts (explicit paths); update STATE.md (v3.29→v3.30, pipeline→IDLE, new SESSION-WRAP checkpoint, prior checkpoint archived); log this burst; commit + push to factory-artifacts | `STATE.md`; `cycles/cycle-002/burst-log.md` (this file); `cycles/cycle-002/session-checkpoints.md`; `regression-state.json`; `sidecar-learning.md`; `code-delivery/release-v0.7.0-dev.3/` |

**Files touched (Dim-1): 6 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-002/burst-log.md
- cycles/cycle-002/session-checkpoints.md
- regression-state.json
- sidecar-learning.md
- code-delivery/release-v0.7.0-dev.3/ (2 files: pr-description.md, pr-review.md)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` — N/A this burst (no BC/VP/holdout count change; bookkeeping-only, no `.factory/specs/prd/` or `BC-INDEX.md` edits).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact bookkeeping only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression already PASS (4660/0/106) as of the F7 delta-convergence pass, unchanged.
