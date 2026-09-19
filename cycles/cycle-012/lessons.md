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

## L-010 — F5 Scoped Adversarial Integration Pass Catches Scope-Leak Per-Story Passes Structurally Cannot See (F5 scoped adversarial, Pass 1, 2026-09-14) [draft]

**Category:** Pipeline discipline / adversarial review scope

**Lesson:** Feature Mode Phase F5 (scoped adversarial refinement, run against the cycle's full changed/new-code delta after both waves) caught OBS-1: Story 1's `changed_fields --output json` key-remapping change (a side effect of the ADF-autoconvert work, not its stated purpose) had broadened beyond its intended scope to affect non-ADF system fields on `issue edit`, silently changing an existing `--output json` contract. Neither Story 1's nor Story 2's own Step-4.5 per-story adversarial convergence (each scoped to its own story's diff) could have caught this — the affected non-ADF-field behavior sits outside both stories' individual review scope, but squarely inside the cycle-level integration diff F5 reviews. Human adjudication narrowed the remapping to ADF-only fields (description/environment), and a regression test was added to pin the fix. Code-reviewer's own pass (fresh context, different model family, same F5 run) independently surfaced H-1/M-1/M-3 — all doc/comment-accuracy findings (stale `isAdfRequest` comment, `CLAUDE.md` Known Size Deviations drift) that a per-story reviewer, seeing only that story's diff, would also have had no trigger to check.

**Policy:** Per-story Step-4.5 convergence is necessary but not sufficient for multi-story cycles — it structurally cannot see cross-story side effects that only become visible in the full-cycle diff. The F5 scoped-adversarial pass (and its accompanying code-reviewer + security-reviewer passes) is the correct control for this class of defect, and should never be treated as redundant with per-story Step-4.5 just because both stories individually converged clean. Continue running F5 as a mandatory full-delta integration pass on every multi-story (or even single-story) Feature Mode cycle, regardless of how clean the per-story passes were.

**Evidence:** F5 Pass 1 (pre-fix) findings: OBS-1 (adversary, human-ruled — `changed_fields` lowercase-key remapping scope-leak), H-1 (code-reviewer — `jsm_create.rs` missing from `CLAUDE.md` Known Size Deviations), M-1 (code-reviewer — `field_resolve.rs` size entry stale at pre-S-cycle12 LOC), M-3 (code-reviewer — stale `isAdfRequest` comment). All four resolved in fix PR #813 (`fix/cycle012-f5-findings`, squash-merged to `develop` @ `80bb4215`, 2026-09-15T00:14:11Z, `--admin`). Post-fix re-review: adversary 3/3 consecutive CLEAN (Passes A/B/C, `VERDICT CLEAN NITPICK_ONLY`, zero CRIT/HIGH/MED); security-reviewer CLEAN (0 CRIT/HIGH/MED; SEC-001 LOW pre-existing debug-only cache guard, not reachable via cycle-012 paths). Full trajectory: `cycles/cycle-012/convergence-trajectory.md`.

**Closes:** (informational — no open issue; recorded for F7 lessons review)

---

## L-009 — Live-E2E Skip-on-Failure Cannot Substitute for Regression Coverage (F4 Story 2 Step-4.5 Pass 3, 2026-09-14) [draft]

**Category:** Test design / E2E coverage limits

**Lesson:** The JSM ADF live-E2E test (AC-016, `S-cycle12-jsm-adf-autoconvert`) skips — rather than fails — on a non-403 create failure. This means it can only provide positive round-trip confirmation when the environment cooperates; it cannot reliably catch a regression that reintroduces plain-string (non-ADF) field values on the JSM create path, because an environment-level failure and a regression-triggered failure both manifest as the same "clean skip," not a red test. This matches the repo's established best-effort E2E skip convention (see `docs/specs/e2e-live-jira-testing.md`), so it is not a defect in this story — but it is a real coverage-limit worth naming explicitly so nobody over-trusts a green nightly run as regression proof for this specific behavior.

**Policy:** When a live-E2E test's only regression-catching value depends on a specific external precondition (here: a successful JSM request creation), and the test's failure mode for a missing precondition is "skip" rather than "fail," record that limitation next to the test and in the story's convergence record — do not rely on it as the sole automated regression guard for the property it targets. Wiremock/CLI-level and unit-level coverage remain the load-bearing regression guard; the live-E2E test is confirmatory only.

**Evidence:** Step 4.5 Pass 3, OBS-P3-1 (`cycles/cycle-012/adversarial-reviews/story-S-cycle12-jsm-adf-autoconvert-convergence.md`). Noted for whoever relies on the nightly smoke test.

**Closes:** (informational — no open issue; recorded for F7 lessons review)

---

## L-008 — Story-Text Output-Channel Claims Must Match jr's Output-Channel Profiles (F4 Story 2 Step-4.5, 2026-09-14) [draft]

**Category:** Story authoring / spec-to-implementation fidelity

**Lesson:** `S-cycle12-jsm-adf-autoconvert`'s AC-012 story text specified the field-conversion notice as emitted to stdout, but jr's actual convention for this command path (`issue create --request-type`, Symmetric output-channel profile) is stderr via `output::print_success`. The implementer caught the discrepancy during delivery (DONE_WITH_CONCERNS) and the adversary independently confirmed it at Pass 1 (OBS-1); the test was written to assert the correct channel (stderr), not the story-text channel. This is a content defect in the story text, not a process gap — the story-decomposition step (F3) did not cross-check the AC wording against CLAUDE.md's "Output channels" convention table.

**Policy:** When authoring or reviewing an AC that specifies a CLI output channel, cross-check the claimed channel against CLAUDE.md's `## Output channels` profile table for the command family in question before finalizing story text. This is a first occurrence for this specific defect class in cycle-012 — no standing policy/checklist addition is warranted per the Cycle-Closing Checklist's recurring-defect threshold; correct the AC-012 wording in a future doc sweep / at F7 close instead.

**Evidence:** `cycles/cycle-012/adversarial-reviews/story-S-cycle12-jsm-adf-autoconvert-convergence.md` Pass 1, OBS-1. Test asserts stderr (not stdout) for the field-conversion notice.

**Closes:** (informational — no open issue; recorded for F7 lessons review)

---

## L-007 — E2E Ignore-Gated Tests Are Not Covered by ci-gate (F4 Story 1 E2E Verification, 2026-09-14) [draft]

**Category:** Pipeline discipline / DoD gating

**Lesson:** cycle-012's headline acceptance test (`test_e2e_issue_edit_custom_field`) was `#[ignore]`-gated and NOT part of `ci-gate`. Story 1's PR #809 merged green through `ci-gate` despite AC-014 being under-delivered (string-only read-back assertion, not ADF-aware). The gap only surfaced in the nightly live E2E run (`34881320608`) — not immediately after merge. A separate PR #811 was required to strengthen the assertion post-merge.

**Policy:** When a cycle's Definition of Done hinges on a specific live-E2E test passing, the orchestrator MUST explicitly verify that test's live result (via the `e2e.yml` run artifact) before declaring the defect closed. A green `ci-gate` does NOT exercise `#[ignore]`-gated E2E tests. The human gate for story delivery should include a checklist item: "Has the live-E2E run that covers this story's acceptance criteria been inspected?"

**Evidence:** e2e.yml run `34881320608` @ `develop@67b3939a` — `test_e2e_issue_edit_custom_field` PASSED. Prior run at `develop@e926cb70` (PR #809 state) showed AC-014 under-delivery. PR #811 (`67b3939a`) added the ADF-aware read-back assertion and positive doc-shape check (`type == "doc"`, non-null, gated to ADF-backed fields).

**Closes:** (informational — no open issue; recorded for F7 lessons review)

---

## L-006 — Fix Code, Not Tests; Verify External API Shapes Before Changing Working Endpoints (F4 Story 1, 2026-09-14) [draft]

**Category:** TDD discipline / external API correctness

**Lesson:** During Story 1 delivery, the implementer introduced a createmeta endpoint regression: a non-existent `/fields` path was added to the `GET .../createmeta/{proj}/issuetypes/{itid}` URL, AND a conflicting object-map deserializer was inserted — both by conforming PRODUCTION code to an INCORRECTLY-STUBBED wiremock test, then editing pre-existing passing tests to match the broken production code. Orchestrator caught the regression via research-agent verification against the Atlassian REST API v3 spec (OpenAPI reference) — confirmed that the live endpoint returns a flat array of field objects, not an object map keyed by ID; and that no `/fields` subpath exists. The root cause: the implementer saw a test failure in a pre-existing test and "fixed" it by changing the test, rather than diagnosing why the new production code was wrong.

**Policy:** (a) "Fix code, not tests" is absolute — when a pre-existing passing test fails after your production change, the production code is wrong; do NOT edit the test to match broken production code. (b) Before changing any production code path that calls an external API endpoint, verify the actual endpoint shape against authoritative documentation (Atlassian REST API v3 OpenAPI spec, or a live probe) — do not infer endpoint shape from test stubs alone, especially when the stub was written speculatively. (c) Test stubs (wiremock fixtures) are NOT authoritative for external API shapes; they must match the REAL API, not the other way around.

**Evidence:** Research doc `research/createmeta-fields-endpoint-verification-2026-09-14.md` — confirmed `/rest/api/3/issue/createmeta/{projectKeyOrId}/issuetypes/{issueTypeId}` returns `{"startAt":N,"maxResults":N,"total":N,"values":[...FieldObject...]}` (a JiraPage of field objects), NOT a `{"fields":{"customfield_NNN":{...}}}` object map. The `/fields` subpath does not exist. The implementer's stubbed version was `{"fields":{"customfield_NNN":{"id":"customfield_NNN",...}}}` — an invented shape not matching the live API.

**Closes:** (informational — no open issue; recorded for F7 lessons review)

---

## L-005 — Cross-Story Public API Contracts Are Load-Bearing Even When Unreferenced (F4 Story 1, 2026-09-14) [draft]

**Category:** Wave planning / spec authoring

**Lesson:** During Story 1 delivery, the implementer deleted a spec-REQUIRED `pub(crate)` item (`is_adf_field_value` in `src/cli/issue/field_resolve.rs`) as "dead code" — it was unreferenced within Story 1's own scope. This violated ACR-3 and the explicit Wave-2 dependency graph: Story 2 (`S-cycle12-jsm-adf-autoconvert`) depends on `is_adf_field_value` being `pub(crate)` on `develop` before Wave 2 begins. Orchestrator caught the deletion in independent verification before the PR merged.

**Policy:** Any `pub(crate)` or `pub` item that a story's spec explicitly marks as "provides for Wave-N+1" or appears in the `dependency-graph.md` as a cross-story contract MUST be preserved in the final implementation, even if it appears locally unreferenced. Clippy's `dead_code` lint MUST be suppressed for such items with an explanatory comment: `// pub(crate) for Wave-2 (S-cycle12-jsm-adf-autoconvert) — do not remove`. The test suite cannot catch this class of regression; only the wave manifest and story spec can.

**Evidence:** `cycles/cycle-012/phase-f3-stories/S-cycle12-jsm-adf-autoconvert.md` §Dependencies — `is_adf_field_value (pub(crate))` listed as a required exported item from Story 1. `dependency-graph.md` — S-cycle12-platform-adf-autoconvert blocks S-cycle12-jsm-adf-autoconvert.

**Closes:** (informational — no open issue; recorded for F7 lessons review)

---

## L-004 — User-as-Senior-Architect (F2 gate, 2026-09-13) [codified]

**Category:** Human oversight / adversarial review scope

**Lesson:** The human's "consistent with all of jr" F2-gate qualifier caught the CLI-wide `--markdown`/`--field description=` inconsistency (platform `issue create` was silently lenient while platform `issue edit` and JSM `create --request-type` exited 64) that 33 adversarial passes missed. Adversarial reviewers, no matter how thorough, operate within the information scope they're given. A human with full CLI context can identify cross-command consistency violations that no single-spec reviewer would catch.

**Policy:** At every human gate, the evaluator should explicitly ask "is this consistent with the rest of [product]?" as a standing qualification question, not just "is this spec internally consistent?". This is a qualitatively different check and cannot be delegated to adversarial passes.

**Evidence:** D-359 (uniform-exit-64 for `--markdown`+`--field description=` across all three command paths) was added AT the F2 human gate, not during 33 adversarial passes. The inconsistency pre-existed in the codebase.

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
