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
