---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-08-26T11:30:00Z
cycle: "cycle-002"
inputs: [STATE.md]
input-hash: "[live-state]"
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
