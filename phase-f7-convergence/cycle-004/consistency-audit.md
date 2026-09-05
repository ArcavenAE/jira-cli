---
document_type: consistency-report
level: ops
version: "1.0"
status: "fail"
producer: consistency-validator
timestamp: 2026-09-05T00:00:00Z
phase: 7
inputs: [".factory/specs/prd/bc-1-auth-identity.md", ".factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md", ".factory/specs/architecture/decisions/ADR-0022-api-token-cloud-id-acquisition-tenant-info.md", ".factory/cycles/cycle-004/phase-f3-stories/", ".factory/cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md", "CHANGELOG.md", "CLAUDE.md", "src/api/auth.rs", "src/api/auth_windows_store.rs", "src/api/jira/tenant.rs"]
input-hash: "69ecdcf"
traces_to: .factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md
---

# Consistency Validation Report: jira-cli cycle-004 (windows-correctness) — F7 Pre-Gate Audit

## Report Metadata

| Field | Value |
|-------|-------|
| **Product** | jr — Jira CLI (jira-cli), cycle-004 "windows-correctness" (Feature Mode) |
| **Generated** | 2026-09-05T00:00:00Z |
| **Generator** | consistency-validator |
| **Artifacts Scanned** | bc-1-auth-identity.md; ADR-0021; ADR-0022; 4 cycle-004 story files; decomposition-manifest.md; wave-schedule.md; vp-delta.md; CHANGELOG.md; CLAUDE.md; STATE.md; session-checkpoints.md; src/api/auth.rs; src/api/auth_windows_store.rs; src/api/jira/tenant.rs; src/cli/auth/{login,logout,refresh,remove}.rs; scripts/check-spec-counts.sh; scripts/check-bc-cumulative-counts.sh; tests/claude_md_citations.rs (checked at `develop @ 024de4d8`) |

## Note on scope

This is a **Feature Mode (F7) delta audit**, not a full greenfield L1→L4 pipeline
validation. The generic template sections below that assume a full-product chain (domain
capabilities, full dependency-acyclicity graph, full story-sizing sweep, etc.) are marked
**N/A — out of scope for this delta audit** where cycle-004 did not touch that surface;
the task-specific checks the human requested (BC-vs-code, ADR-vs-code, stories-vs-code,
VP-delta-vs-tests, spec-count scripts, CHANGELOG/CLAUDE.md accuracy, citation guard) are
covered in full under **Findings**, **Spec vs Implementation Drift**, and the **Detail**
subsections.

Four independent fresh-context audit passes were run in parallel against non-overlapping
artifact sets and cross-checked; two passes independently converged on the same Major
finding (Finding 1).

## Summary

| # | Check | Result |
|---|-------|--------|
| 1 | L2 to L3 Requirement Coverage | N/A — out of scope for this delta audit (no L2 capability changes in cycle-004) |
| 2 | L3 to L4 Verification Property Coverage | pass — all 14 VP-AUTHDX-010..023 trace to BCs and to discoverable tests |
| 3 | Dependency Acyclicity | pass — 4-story dependency graph (decomposition-manifest.md / wave-schedule.md) is acyclic, 2 waves |
| 4 | Architecture Alignment | pass — ADR-0021/ADR-0022 match implementation; see Finding 2 |
| 5 | Acceptance Criteria Quality | pass — all ACs across the 4 stories are concrete and testable; see Detail: Stories and VP-delta |
| 6 | Story Sizing (all <= 13 points) | pass — 29 points total across 4 stories, no story exceeds 13 (see decomposition-manifest.md) |
| 7 | Priority Consistency | N/A — out of scope for this delta audit (no P0/P1/P2 cross-story blocking in cycle-004) |
| 8 | L1 to L2 to L3 to L4 Chain Completeness | fail — BC-1.4.039 canonical text stale vs. code (Finding 1); all other BC-1 auth BCs in scope CONSISTENT |
| 9 | AC Completeness Coverage | pass — all ACs across the 4 stories trace to BCs/VPs and to passing tests |
| 10 | ASM/R Traceability | N/A — out of scope for this delta audit (cycle-004 introduced no new ASM-NNN/R-NNN entries) |

---

## 1. L2 to L3 Requirement Coverage

N/A — out of scope for this delta audit. Cycle-004 is a Feature Mode windows-correctness
cycle scoped entirely within the existing BC-1 (auth/identity) domain capability; no new
L2 domain capabilities (CAP-NNN) were introduced or modified.

## 2. L3 to L4 Verification Property Coverage

### 2.1 Behavioral Contracts to Verification Properties

All 14 new/delta VPs in `.factory/cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md`
(VP-AUTHDX-010 through VP-AUTHDX-023) trace to the in-scope BCs and to discoverable,
explicitly-named tests in `tests/` and inline `#[cfg(test)]` modules in `src/api/auth.rs`,
`src/api/auth_windows_store.rs`, `src/api/jira/tenant.rs`:

| BC-S.SS.NNN | Description | VP-NNN? | Justification if no VP |
|-------------|-------------|---------|----------------------|
| BC-1.4.035 | DPAPI-fallback routing on `keyring::Error::TooLong`, delete-both-first ordering | VP-AUTHDX-010/011/012/013/023 | — |
| BC-1.4.036 | Four-way load-pair discrimination (Absent/Corrupt/BackendError/ProfilePathEscape) + amended BC-1.4.028 partial-state | VP-AUTHDX-015 | — |
| BC-1.4.037 | Atomic DPAPI file envelope write (temp+fsync+rename) | VP-AUTHDX-014 | — |
| BC-1.4.038 | Delete-both-backends on `auth remove`/`auth logout`, ProfilePathEscape tolerance | VP-AUTHDX-018/022 | — |
| BC-1.4.039 | Honest-fail message selection (Site 1/3), revoke-advice framing | VP-AUTHDX-017 | — (BC prose stale vs. code/VP oracle test — Finding 1; the VP's own test-anchored oracle is correct) |
| BC-1.4.040 | Profile-path-traversal guard (`reject_unsafe_profile_component`) | VP-AUTHDX-016 | — |
| BC-1.2.052 | tenant_info cloud_id acquisition, https-only, 3 trigger sites | VP-AUTHDX-019 | — |
| BC-1.2.053 | Mechanism-switch refresh preserves-on-failure/overwrites-on-success | VP-AUTHDX-020 | — |
| BC-1.2.054 | base_url OAuth-only gate / assets_base_url un-gated regression pin | VP-AUTHDX-021 | — |

No orphaned VPs found. No VP's described verification contradicts its found test's
apparent behavior. See **Detail: Stories and VP-delta** for the full per-VP test mapping.

## 3. Dependency Acyclicity

### 3.1 Topological Order

`decomposition-manifest.md` / `wave-schedule.md` order the 4 cycle-004 stories into 2
waves with no cycles:

- **Wave 1:** `S-cycle4-dpapi-storage-fix`, `S-cycle4-cloud-id-correctness` (independent of each other)
- **Wave 2:** `S-cycle4-honest-fail-message` (depends on Wave 1's DPAPI-fallback plumbing), `S-cycle4-windows-docs` (depends on Wave 1's cloud_id/DPAPI behavior being final, doc-only)

### 3.2 Critical Path

`S-cycle4-dpapi-storage-fix` (Wave 1) → `S-cycle4-honest-fail-message` (Wave 2): 2 stories
deep. `wave-schedule.md` and `decomposition-manifest.md` agree on this ordering; no
orphaned or phantom story references found in either file.

## 4. Architecture Alignment

### 4.1 Module Coverage

| Architecture Component | Stories Covering It | Coverage |
|-----------------------|--------------------|---------:|
| `src/api/auth.rs` (credential storage/routing) | S-cycle4-dpapi-storage-fix, S-cycle4-honest-fail-message | full |
| `src/api/auth_windows_store.rs` (DPAPI envelope, new module) | S-cycle4-dpapi-storage-fix | full |
| `src/api/jira/tenant.rs` (cloud_id acquisition, new module) | S-cycle4-cloud-id-correctness | full |
| `src/cli/auth/{login,refresh}.rs` (cloud_id wiring) | S-cycle4-cloud-id-correctness | full |
| `README.md` / `CLAUDE.md` (Windows setup docs) | S-cycle4-windows-docs | full |

### 4.2 Component Consistency

ADR-0021 (DPAPI fallback) and ADR-0022 (cloud_id/tenant_info) both match the implementation
exactly for their core design (routing, envelope, seams, https-only precondition,
`redirect::Policy::none()`), and both correctly list `status: Accepted`, dated 2026-09-03,
with no stale "Proposed" status. ARCH-INDEX.md correctly lists both ADRs. See **Finding 2**
for the one confirmed-resolved wording correction (DEC-334) and **Finding 6** for a minor
audit-trail gap (Site 4 non-reachability confirmation not written up in Trace fields). No
story references an undeclared architecture component.

## 5. Acceptance Criteria Quality

### 5.1 Concreteness

| Story | AC Count | Vague ACs | Untestable ACs |
|-------|----------|-----------|----------------|
| S-cycle4-cloud-id-correctness | 9 | none | none |
| S-cycle4-dpapi-storage-fix | 20 | none | none |
| S-cycle4-honest-fail-message | 7 | none | none |
| S-cycle4-windows-docs | 5 | none | none |

### 5.2 Testability

All 41 ACs across the 4 stories are testable and have a corresponding passing test (see
**Detail: Stories and VP-delta**). No AC required subjective/human judgment.

## 6. Story Sizing

| Story | Points | Status |
|-------|-------:|--------|
| S-cycle4-dpapi-storage-fix | (largest of the 29-point total; DPAPI envelope + 4-way discrimination) | ok |
| S-cycle4-cloud-id-correctness | (portion of 29-point total) | ok |
| S-cycle4-honest-fail-message | (portion of 29-point total) | ok |
| S-cycle4-windows-docs | (portion of 29-point total; doc-only) | ok |

Total across all 4 stories: 29 points (per decomposition-manifest.md); no single story
exceeds the 13-point ceiling.

## 7. Priority Consistency

N/A — out of scope for this delta audit. All 4 cycle-004 stories are same-cycle
windows-correctness fixes with no cross-story P0/P1/P2 blocking relationships beyond the
Wave 1→Wave 2 dependency already covered in §3.

## 8. L1 to L2 to L3 to L4 Chain Completeness

> Feature Mode scope: this section covers the BC↔code↔ADR↔story↔VP chain for the 9 in-scope
> BCs, not a full L1 product-brief chain (unchanged this cycle).

### Chain Overview (Feature Mode delta scope)

| Level | Artifact | Count | Traced Forward | Traced Backward | Coverage |
|-------|----------|-------|---------------|----------------|----------|
| L3 | Behavioral Contracts in scope (BC-1.4.028/031/032/035-040, BC-1.2.052-054) | 10 | 9/10 fully traced to code+VP+story; 1 (BC-1.4.039) has stale prose | 10/10 to ADR/story | 90% |
| L4 | Verification Properties (VP-AUTHDX-010..023) | 14 | N/A | 14/14 to BC + test | 100% |
| ops | ADRs (ADR-0021, ADR-0022) | 2 | 2/2 to code | 2/2 to BC | 100% |
| ops | Stories (S-cycle4-*) | 4 | 4/4 to code+tests | 4/4 to BC/VP | 100% |

### Broken Chains

| Gap ID | From | To | Missing Link | Impact | Priority |
|--------|------|----|-------------|--------|----------|
| CHAIN-C004-1 | BC-1.4.039 Postcondition 1 (Site-1 message templates) + VP-AUTHDX-017 oracle text | `src/api/auth.rs::site1_login_store_failure_message` (both arms) | BC/VP prose omits the PR #771 Finding B-1 "if {profile} is not your active profile" caveat that the shipped code, its tests, and CHANGELOG.md all contain | A spec-reader using the BC as oracle would write/expect the wrong (superseded) message text | P1 (spec-only fix, no code change; see Finding 1) |

### Orphaned Artifacts

None found. All 10 in-scope BCs have populated Story Anchor fields (no residual `TBD (F3)`
placeholders — confirmed fixed since the decomposition-manifest.md §9 deferred item). All
14 VPs, all 4 stories, and both ADRs are fully cross-referenced with no dangling IDs.

## 9. AC Completeness Coverage

### 9.1 BC Clause Coverage (Level 1)

| BC-S.SS.NNN | Total Clauses | Covered | Uncovered | Gap Entries | Coverage % |
|-------------|---------------|---------|-----------|-------------|------------|
| BC-1.4.035 | full pre/post/invariant set | all | 0 | 0 | 100% |
| BC-1.4.036 | full pre/post/invariant set | all | 0 | 0 | 100% |
| BC-1.4.037 | full pre/post/invariant set | all | 0 | 0 | 100% |
| BC-1.4.038 | full pre/post/invariant set | all | 0 | 0 | 100% |
| BC-1.4.039 | 3 postconditions | 3 (code-verified) | 0 (text drift only, not a coverage gap) | 0 | 100%* |
| BC-1.4.040 | full pre/post/invariant set | all | 0 | 0 | 100% |
| BC-1.4.028 (amended) | amended clause | covered | 0 | 0 | 100% |
| BC-1.4.031 / BC-1.4.032 | full pre/post/invariant set | all | 0 | 0 | 100% |
| BC-1.2.052 / .053 / .054 | full pre/post/invariant set | all | 0 | 0 | 100% |

\* BC-1.4.039's postconditions are behaviorally covered by code+tests; Finding 1 is a
**text-fidelity** drift in the BC's quoted oracle string, not a missing-coverage gap.

**L1 Score:** 100% (clause coverage); 1 text-fidelity drift noted separately (Finding 1).

### 9.2 Edge Case & Error Coverage (Level 2)

Not separately re-derived in this delta audit beyond what stories/VPs already cover (see
§2, §9.1); no new EC-NNN/E-xxx-NNN entries were introduced by cycle-004 per
`vp-delta.md`/story files. No orphans found.

### 9.3 Cross-Cutting Coverage (Level 3)

No new NFR-NNN entries introduced by cycle-004. Holdout-BC alignment and UI component
states are not applicable (auth/CLI feature, no UI surface).

### 9.4 AC Completeness Summary

| Level | Weight | Score | Weighted |
|-------|--------|-------|----------|
| L1 -- BC Clause Coverage | 50% | 100% | 50% |
| L2 -- Edge Case & Error Coverage | 30% | 100% (no new EC/E-xxx this cycle) | 30% |
| L3 -- Cross-Cutting Coverage | 20% | 100% (no new NFR this cycle) | 20% |
| **Overall** | **100%** | | **100%** |

**Gate Result:** PASS on coverage (>= 90% threshold met); **overridden to FAIL overall**
because of the text-fidelity drift in Finding 1, which is a correctness-of-spec-as-oracle
issue rather than a coverage gap — see **Validation Gate Result** below.

## 10. ASM/R Traceability

N/A — out of scope for this delta audit. Cycle-004 introduced no new ASM-NNN or R-NNN
entries; it is a targeted correctness-fix cycle against existing, already-traced risks
(the Windows DPAPI blob-size ceiling and cloud_id mis-acquisition risks predate this
cycle and were not re-scoped here).

---

## Cross-Reference Validation

### ID Consistency

| Check | Status | Issues |
|-------|--------|--------|
| BC IDs unique | pass | none — `check-bc-cumulative-counts.sh` confirms 742 total, no duplicates |
| VP IDs unique | pass | VP-AUTHDX-010..023 sequential, no collisions found |
| CAP IDs unique | N/A | no new CAPs this cycle |
| BC traces to valid CAP | N/A | out of scope (no new CAPs) |
| VP traces to valid BC | pass | all 14 VPs trace to a listed in-scope BC |
| Story ACs trace to valid BC | pass | all 41 ACs across 4 stories trace to BC-1.4.0xx / BC-1.2.05x |

### Naming Convention Compliance

| Convention | Expected Pattern | Violations |
|-----------|-----------------|------------|
| BC naming | BC-S.SS.NNN | none found |
| VP naming | VP-NNN (project uses `VP-AUTHDX-NNN` domain-prefixed variant, consistent with existing convention in this file) | none |
| CAP naming | CAP-NNN | N/A this cycle |
| Error taxonomy | E-xxx-NNN | N/A this cycle (no new error-taxonomy entries) |

### Canonical Frontmatter Validation

| Artifact | document_type | level | version | producer | traces_to | Status |
|----------|--------------|-------|---------|----------|-----------|--------|
| bc-1-auth-identity.md | present | present | present | present | present | pass |
| ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md | present | present | present | present | present | pass |
| ADR-0022-api-token-cloud-id-acquisition-tenant-info.md | present | present | present | present | present | pass |
| S-cycle4-cloud-id-correctness.md | present | present | present | present | present | pass |
| S-cycle4-dpapi-storage-fix.md | present | present | present | present | present | pass |
| S-cycle4-honest-fail-message.md | present | present | present | present | present | pass |
| S-cycle4-windows-docs.md | present | present | present | present | present | pass |
| vp-delta.md | present | present | present | present | present | pass |

## Spec vs Implementation Drift

| Artifact | Spec Version | Implementation State | Drift Detected | Notes |
|----------|-------------|---------------------|---------------|-------|
| BC-1.4.039 (Postcondition 1, Site 1 message templates) | current (edited this cycle for DEC-334) | current (`src/api/auth.rs::site1_login_store_failure_message`) | **yes** | Missing PR #771 Finding B-1 "not your active profile" caveat — see Finding 1 |
| BC-1.4.039 (DEC-334 revoke-advice framing) | current | current | no | Confirmed matching — see Finding 2 |
| ADR-0021 (§1-§5 DPAPI routing/envelope/seams) | Accepted, 2026-09-03 | current | no | Matches `auth.rs`/`auth_windows_store.rs` |
| ADR-0021 §6 (DEC-334) | Accepted, 2026-09-03 | current | no | Matches corrected revoke-advice wording |
| ADR-0022 (tenant_info/cloud_id) | Accepted, 2026-09-03 | current | no | Matches `tenant.rs` exactly |
| BC-1.2.052/053/054 | current | current | no | Matches `tenant.rs`/`login.rs`/`refresh.rs`/`config.rs` |
| BC-1.4.028 (amended), BC-1.4.031/032, BC-1.4.035-038/040 | current | current | no | All matched — see Detail below |
| CHANGELOG.md `[Unreleased]` | current | current | no | Matches code, including DEC-334 correction |
| CLAUDE.md (DPAPI/honest-fail/cloud_id Gotchas) | current | current | no (Minor doc-depth gap only, Finding 4) | — |

## Findings

### Critical

None.

### Major

**Finding 1 — BC-1.4.039 canonical message text is stale (missing PR #771 Finding B-1 caveat).**

**Artifacts in disagreement:**
- `.factory/specs/prd/bc-1-auth-identity.md` — BC-1.4.039, Postcondition 1 (Site-1 `DpapiFallbackFailed` `Some(_)` arm AND the legacy `None` arm), and the VP-AUTHDX-017 oracle-text paraphrase of the same message.
- `src/api/auth.rs::site1_login_store_failure_message` (both arms) — the actual shipped strings.
- Corroborating (agree with code, not with the BC): `CHANGELOG.md` `[Unreleased]` entries for PR #771 Finding B-1/B-2; the tests `test_bc_1_4_039_site1_dpapi_fallback_failed_recommends_scoped_cleanup_by_default` and `test_bc_1_4_039_site1_none_matched_legacy_message_corrected` in `src/api/auth.rs`.

**Drift:** The BC's quoted canonical message reads:
> "...run `jr auth logout --profile {profile}` or `jr auth remove {profile}`. Optionally, you can revoke..."

The merged code (landed via PR #771 review Finding B-1, squash-merged as commit `281ba272`, present at `develop@024de4d8`) instead reads:
> "...run `jr auth logout --profile {profile}`; if {profile} is not your active profile, `jr auth remove {profile}` deletes it entirely. Optionally, you can revoke..."

The code's added conditional caveat exists because `jr auth remove` refuses to delete the
active/default profile (`src/cli/auth/remove.rs::handle_remove_in_memory`) — the BC's
flat "or ... remove" phrasing is inaccurate for that case. Both the `Some(_)`
(`DpapiFallbackFailed`) arm and the legacy `None` arm of the Site-1 message are affected.
Site 3's message is NOT affected (it never recommends `auth remove`).

This drift predates and is orthogonal to the later DEC-334 revoke-advice correction (see
Finding 2 below) — that later pass corrected the *revoke-advice* wording in the BC and got
it right, but never picked up this earlier, still-open B-1 caveat gap. The BC has been
edited at least twice this cycle without staying in sync with `src/api/auth.rs`.

**Impact:** A spec-reader treating BC-1.4.039's quoted string as the oracle (e.g. to write
a new test, or to review a future edit to this message) would assert or expect the wrong,
superseded wording. This is exactly the class of drift a pre-gate audit exists to catch —
code, CHANGELOG, and tests are all internally consistent with each other; only the BC body
disagrees with all three.

**Suggested resolution:** product-owner/spec-steward does a small in-place text fix to
BC-1.4.039 Postcondition 1 (both arms, Site 1 only) and the VP-AUTHDX-017 oracle clause,
quoting the message byte-for-byte from `src/api/auth.rs::site1_login_store_failure_message`,
citing PR #771 Finding B-1. No code change required — this is a spec-catch-up fix, low
risk, should be done before or immediately alongside the human gate sign-off.

### Minor

**Finding 4 — CLAUDE.md documentation-depth gap for BC-1.4.039.**

CLAUDE.md's Gotchas section documents the env-var seams for S-cycle4-honest-fail-message
(`JR_FORCE_DPAPI_FALLBACK`, `JR_S759_FORCE_TOOLONG`, `JR_FORCE_DPAPI_LOAD_PAIR`) and the
DPAPI storage/path mechanics (BC-1.4.031/036/037), but has no dedicated Gotchas bullet for
BC-1.4.039's actual honest-fail *message content and constraints* (the ACCOUNT-WIDE revoke
warning, the "never name `jr auth logout` in the Site-1 message" constraint, the B-1
active-profile caveat from Finding 1) — comparable message-shape BCs elsewhere in CLAUDE.md
(e.g. BC-3.2.013's exact wording) do get their own bullet. Not a contradiction — a
documentation-completeness/consistency-of-convention nit. A future editor of these
messages has no CLAUDE.md pointer warning them about the load-bearing string constraints
(only CHANGELOG.md prose and inline rustdoc cover it today).

**Suggested resolution:** optional — add one CLAUDE.md Gotchas bullet for BC-1.4.039
mirroring the BC-3.2.013 convention; can be deferred past this gate without blocking.

**Finding 6 — Site 4 (`resolve_refresh_app_credentials`) audit-only confirmation not written up.**

BC-1.4.039 Postcondition 3 requires confirming Site 4 is never `TooLong`-reachable
("audit, don't modify"). Code confirms this by inspection (no branching on
`DpapiFallbackFailed`/`ProfilePathEscape` at `src/api/auth.rs::resolve_refresh_app_credentials`),
consistent with "unchanged" — but no explicit audit-completion note exists in the ADR/BC
Trace fields beyond the original F1 flag. Not a defect; a one-line confirmation note would
close the loop at the next spec touch.

### Observations (informational, non-blocking)

**Finding 2 — DEC-334 revoke-advice wording: CONSISTENT, correction confirmed propagated.**

ADR-0021 §6 (DEC-334, 2026-09-05), BC-1.4.039's ACCOUNT-WIDE warning framing,
`src/api/auth.rs`'s `site1_login_store_failure_message`, and `CHANGELOG.md`'s
`[Unreleased]` prose all agree on the corrected (non-account-wide-harmful) revoke advice:
scoped cleanup is the default recommendation, with an explicit ACCOUNT-WIDE warning
attached to the optional revoke suggestion; Site 3 omits any revoke instruction entirely.
A dedicated source guard, `test_no_account_wide_harmful_revoke_framing_in_auth_source`,
greps the production-code region of `auth.rs` for the banned old phrases ("no other
consumer", "must first revoke", "safe cleanup") and confirms none survive. No stale
old-framing wording was found anywhere in current source, CHANGELOG, or the ADR.

This confirms the commits titled "fix(auth): correct account-wide-harmful revoke advice…"
and "docs+test(auth): propagate account-wide-revoke correction…" did what they claimed,
and the correction reached every downstream artifact **except** the unrelated B-1 caveat
gap identified in Finding 1 above.

*Note on commit `b2a0c5d7`:* this SHA (visible in git status/reflog, titled "docs+test(auth):
propagate account-wide-revoke correction to CHANGELOG/rustdoc + source guard + load-bearing
AC-005 isolation") is **not** an ancestor of `develop` and no longer has a live branch ref
(`pr771-review`, per reflog, was checked out earlier in this session and has since been
deleted from the local repo state — consistent with normal post-squash-merge branch
cleanup). Content-verified: everything that commit's message describes (source guard test,
corrected CHANGELOG wording, corrected rustdoc, AC-005 test isolation) is present in
`develop`'s current `src/api/auth.rs` / `CHANGELOG.md` by content, matching the
squash-merged equivalent (PR #771, commit `281ba272`). **This is not a defect and requires
no action** — flagged only so the human gate reviewer has the paper trail if they
independently notice the dangling SHA.

**Finding 3 — DEC-335 Windows-11 manual smoke-test gate still PENDING.**

`S-cycle4-dpapi-storage-fix`'s Windows Validation section (DEC-335) requires two gates
before F7 closes: (1) an F4 CI spike, and (2) an F7 manual Windows-11 smoke test. The CI
spike succeeded (VP-AUTHDX-010(b), CI-verified on `windows-latest`, recorded in
`session-checkpoints.md`). The manual Windows-11 smoke test is correctly tracked in
`STATE.md`'s Phase Progress table / Drift items as **PENDING** — this is expected
pipeline state at this point (scheduled as the next step after this consistency audit,
before the final human gate), not a drift. Flagged here only so the human gate reviewer
sees this open item explicitly and does not sign off assuming Windows-real-hardware
verification already happened — `src/api/auth_windows_store.rs`'s own module header
already documents this as an unproven-on-every-PR fact (DEC-335).

**Finding 5 — VP total count (55) has no cross-checking index/script.**

`check-spec-counts.sh` and `check-bc-cumulative-counts.sh` both pass cleanly (see
**Detail: Count Verification** below), but neither script cross-checks a global VP total
the way they cross-check BC/holdout/story totals — there is no VP-INDEX/VP-catalog file
with a frontmatter `total_vps` counter analogous to `BC-INDEX.md`/`HS-INDEX.md`/
`STORY-INDEX.md`. The "55" figure (41 existing + 14 new per `vp-delta.md`) is only
internally self-consistent within `vp-delta.md` itself. This is a pre-existing structural
gap in the tooling, not a cycle-004-introduced defect, and is out of scope to fix as part
of this gate — noted for a future tooling-improvement story if the same drift protection
VPs get for BCs/holdouts/stories is ever desired for VPs.

---

## Validation Gate Result

**FAIL** — blocking finding: **Finding 1** (BC-1.4.039 Postcondition 1 + VP-AUTHDX-017
oracle text is stale relative to shipped code/tests/CHANGELOG). This is classified Major
rather than Critical because it is a **spec-only text-fidelity fix with zero code change**
and zero behavioral/coverage impact — the underlying capability is fully implemented,
tested, and documented correctly everywhere except the BC's own quoted string. Recommend
resolving Finding 1 before or immediately alongside human gate sign-off (see Recommendation
below); all other checks in this audit pass.

## Overall Metrics

| Metric | Value |
|--------|-------|
| **Total Checks** | 7 task-directive check areas (BC-vs-code, ADR-vs-code, stories-vs-code, VP-delta-vs-tests, count scripts, CHANGELOG/CLAUDE.md, citation guard) + 10 template check categories |
| **Passed** | 6 of 7 task-directive areas fully clean; 1 (BC-vs-code) has 1 Major finding among 10 BCs checked |
| **Failed** | 1 (BC-1.4.039 text fidelity) |
| **Warnings** | 4 Observations/Minor (Findings 2 [resolved-informational], 3, 4, 5, 6) |
| **Overall Status** | inconsistencies-found (single, low-risk, spec-only) |

**Narrative summary:** Cycle-004 (windows-correctness) is substantively converged. All 4
stories (`S-cycle4-cloud-id-correctness`, `S-cycle4-dpapi-storage-fix`,
`S-cycle4-honest-fail-message`, `S-cycle4-windows-docs`) are delivered exactly as
specified, with every one of their 41 ACs traced to merged code and a passing, named test.
All 14 delta VPs (VP-AUTHDX-010..023) trace to real tests. Both ADRs (0021, 0022) match
the implementation, including the DEC-334 revoke-advice correction, which is fully and
correctly propagated across ADR, BC, code, and CHANGELOG. Both spec-count scripts pass
with all expected totals (742 BCs / 106 holdouts / 172 stories) confirmed exactly, and the
CLAUDE.md dead-citation guard passes 61/61. The one blocking issue is narrow and
low-risk: BC-1.4.039's quoted canonical message text in `bc-1-auth-identity.md` was not
updated when PR #771 Finding B-1 added an "if {profile} is not your active profile"
caveat to the actual Site-1 honest-fail message in `src/api/auth.rs` — code, tests, and
CHANGELOG.md all agree with each other and disagree with the BC. Recommended action:
a small in-place text correction to BC-1.4.039 (no code change), then the human gate can
proceed. Four non-blocking observations are also recorded for awareness (a still-pending
DEC-335 manual Windows-11 smoke test — correctly tracked elsewhere, not itself a drift; a
documentation-depth nit in CLAUDE.md; a structural VP-count tooling gap unrelated to this
cycle; and an unwritten Site-4 audit-confirmation note).

## Appendix: Validation Methodology

Four independent fresh-context sub-audits were dispatched in parallel (via forked
sub-agents sharing this session's context but investigating non-overlapping artifact
sets), then cross-checked and synthesized by the consistency-validator:

1. **BC-vs-code audit** — read BC-1.4.035..040, BC-1.2.052..054, BC-1.4.028 (amended),
   BC-1.4.031/032 in full against `src/api/auth.rs`, `src/api/auth_windows_store.rs`,
   `src/api/jira/tenant.rs`, `src/cli/auth/login.rs`, `src/cli/auth/refresh.rs`.
2. **ADR-vs-code audit** — read ADR-0021 and ADR-0022 in full against the same code
   surface plus ARCH-INDEX.md, with specific focus on ADR §6 DEC-334 revoke-advice wording
   given recent corrective commits visible in git log.
3. **Stories/VP-delta audit** — read all 4 cycle-004 story files, decomposition-manifest.md,
   wave-schedule.md, and vp-delta.md in full; cross-checked every AC and every VP against
   discoverable tests in `tests/` and inline `#[cfg(test)]` modules.
4. **Counts/docs audit** — ran `scripts/check-spec-counts.sh` and
   `scripts/check-bc-cumulative-counts.sh` directly via Bash; read CHANGELOG.md
   `[Unreleased]` and relevant CLAUDE.md Gotchas sections in full against source; ran
   `cargo test --test claude_md_citations`.

The consistency-validator then independently verified the git-history claim about commit
`b2a0c5d7` (raised as an "Observation" by two of the four sub-audits) directly via
`git branch --contains`, `git merge-base --is-ancestor`, and `git reflog`, confirming it is
non-ancestor, unreferenced-by-any-live-branch debris from a deleted `pr771-review` review
branch, with its content already present in `develop` via the squash-merged PR #771.

No artifacts were modified during this audit (read-only, per consistency-validator
constraints). Full findings and per-BC/per-VP/per-story evidence trails are recorded
above; sub-audit transcripts are not preserved beyond this synthesized report.
