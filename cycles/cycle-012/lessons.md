---
document_type: lessons
level: ops
version: "1.0"
status: active
producer: state-manager
timestamp: 2026-09-13T00:00:00Z
cycle: "cycle-012-field-adf-autoconvert"
inputs: [STATE.md, phase-f2-spec-evolution/cycle-012-verification-delta.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Lessons Learned — cycle-012-field-adf-autoconvert

<!-- Lessons are codified as [codified] when formally recorded and adopted as process policy.
     Lessons are [draft] until reviewed and accepted by the orchestrator/human gate.
     Add newest lessons at the top, maintaining reverse-chronological order. -->

## L-004 — User-as-Senior-Architect (F2 gate, 2026-09-13) [codified]

**Category:** Human oversight / adversarial review scope

**Lesson:** The human's "consistent with all of jr" F2-gate qualifier caught the CLI-wide `--markdown`/`--field description=` inconsistency (platform `issue create` was silently lenient while platform `issue edit` and JSM `create --request-type` exited 64) that 33 adversarial passes missed. Adversarial reviewers, no matter how thorough, operate within the information scope they're given. A human with full CLI context can identify cross-command consistency violations that no single-spec reviewer would catch.

**Policy:** At every human gate, the evaluator should explicitly ask "is this consistent with the rest of [product]?" as a standing qualification question, not just "is this spec internally consistent?". This is a qualitatively different check and cannot be delegated to adversarial passes.

**Evidence:** DEC-359 (uniform-exit-64 for `--markdown`+`--field description=` across all three command paths) was added AT the F2 human gate, not during 33 adversarial passes. The inconsistency pre-existed in the codebase.

**Closes:** D-358, D-359 codified

---

## L-003 — Partial-Fix Propagation Mandate (F2 adversarial convergence, 2026-09-13) [codified]

**Category:** Spec-editing discipline / propagation

**Lesson:** Every axis-count or enumeration change in the verification delta MUST propagate to ALL sibling enumeration sites simultaneously: §1 table (axis count/name), §3 bullets (0-GAP analysis), §4 headers and technique/primary-modules lists, §5 obligations table, RED proofs (test stubs), and BC citation lists. Fixing one site without sweeping the rest leaves inconsistencies that generate self-perpetuating adversarial findings in the next pass.

**Policy:** Before closing any adversarial finding about an axis count or enumeration, apply a grep-mandate: `grep -n "axis\|axes\|Axis\|VP-004\|0-GAP" verification-delta.md` and ensure every enumeration site has been updated. Mark the sweep result in the "fixed" commentary.

**Evidence:** Multiple passes (including passes beyond 21) found residual inconsistencies in sibling enumeration sites after axis count fixes. Each such finding required another pass to confirm, extending the convergence tail significantly.

**Closes:** D-358 codified

---

## L-002 — F2 Over-Prescription Anti-Pattern (F2 adversarial convergence, 2026-09-13) [codified]

**Category:** Spec authoring / adversarial convergence efficiency

**Lesson:** Prescribing EXACT F4 helper names, function signatures, and decomposition structure in the F2 verification delta generates self-perpetuating adversarial findings. When the spec says "F4 must implement `resolve_field_type(schema: &AdfFieldSchema) -> FieldKind`", adversarial reviewers will find that: (a) the exact signature is wrong/suboptimal, (b) the decomposition doesn't match other architectural conventions, (c) the helper name conflicts with naming patterns, etc. — all of which are VALID findings for a spec that prescribes implementation, but they create an infinite convergence loop because the "correct" implementation is unknowable at F2.

**Policy:** F2 verification deltas MUST specify WHAT is verified (the observable behavior, the test mechanism) and leave HOW (helper decomposition, signatures, function names) to F4. Acceptable: "A test verifies that the ADF field detection returns `true` for `description` schema type." Unacceptable: "Test `test_is_adf_field_description` must call `AdfFieldDetector::is_adf_field(schema)` where `is_adf_field` takes `AdfFieldSchema` and returns `bool`."

**Evidence:** Multiple F2 adversarial passes (particularly passes 15-21) found findings about prescribed F4 function signatures and helper decomposition names. Fixing them generated follow-up findings about the revised names/structures. Resolved by abstracting to behavior-level specifications.

**Closes:** D-358 codified

---

## L-001 — BC-CITE-001 Zero-Tolerance for Pending Symbols (F2 adversarial convergence, 2026-09-13) [codified]

**Category:** CI compliance / spec authoring

**Lesson:** `scripts/check-bc-citation-symbols.sh` exits 1 on ANY backtick-wrapped `src/…::symbol` token in BC `Trace:` or `Source:` fields, including symbols that are pending F4 implementation. Multiple passes (specifically passes 19 and 21) misread this as a floor-tolerated or deferred check; it is NOT. The check is zero-tolerance: even a single pending backtick-wrapped symbol causes CI to fail.

**Policy:** When spec-ahead-of-code cycles produce BCs (F2 spec evolution with F4 implementation deferred), ALL not-yet-existing F4 symbols in BC `Trace:`/`Source:` fields MUST use the UN-backticked convention: `(pending implementation — F4 Story N: short description)`. Never use backtick-wrapped `src/path/file.rs::function_name` for a symbol that does not yet exist in the codebase. The CI guard `check-bc-citation-symbols.sh` will fail on any pending symbol in backtick form, blocking all builds until removed.

**Example:**
- WRONG: `` Trace: `src/cli/issue/create.rs::detect_adf_field` (pending F4) ``
- RIGHT: `Trace: src/cli/issue/create.rs (pending — F4 Story 1: ADF autoconvert core)`

**Evidence:** Passes 19 and 21 were delayed by BC-CITE-001 failures on pending symbols; both passes misclassified the check as informational. The actual CI failure requires a complete re-run after correction.

**Closes:** D-358 codified
