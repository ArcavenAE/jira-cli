---
document_type: story-decomposition-manifest
phase: phase-f3-incremental-stories
cycle: cycle-004
feature: windows-correctness
status: draft
producer: story-writer
created: 2026-09-04
inputs:
  - ".factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md"
  - ".factory/cycles/cycle-004/phase-f1-delta-analysis/affected-files.txt"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/prd/bc-6-config-cache.md"
  - ".factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md"
  - ".factory/specs/architecture/decisions/ADR-0022-api-token-cloud-id-acquisition-tenant-info.md"
  - ".factory/cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md"
  - ".factory/cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md"
  - ".factory/stories/STORY-INDEX.md"
traces_to: "DEC-334; DEC-335; ADR-0021; ADR-0022; A-PA-LOW-001"
input-hash: "02698fc"
---

# F3 Story Decomposition Manifest — `windows-correctness` (cycle-004)

**PLANNING + DELIVERY RECORD.** Unlike cycle-003's manifest (a pure planning pass ahead of
a separate story-writing burst), this manifest is written alongside the four
`S-cycle4-*.md` story files it describes, since DEC-335 already locked the exact 4-story
scope at the F1 human gate — no separate story-set proposal/approval round was needed
before writing. `STORY-INDEX.md` has NOT been touched (state-manager's later step).

---

## 0. ID Convention

Continues the `S-cycle<N>-<slug>` convention `S-cycle3-*` established (cycle-003's
manifest §0) — an internally-scoped Feature Mode cycle with no single originating GitHub
issue number to anchor a numeric `S-{issue}-*` ID to (this cycle bundles #759 AND #760
AND a human-added item, so no single issue number would be accurate). The `S-cycle4-*`
namespace is lexically disjoint from every existing story ID in `STORY-INDEX.md`
(including the six existing `S-WIN-*` stories from an earlier Windows-support cycle,
which this cycle's stories are additive to, not a replacement of — `S-WIN-1` through
`S-WIN-6` covered per-OS path resolution, the debug isolation seam, the `windows-native`
keyring feature, and CI/release plumbing; none of those stories touch OAuth credential
storage or `cloud_id` acquisition, so there is zero scope overlap).

## 1. DEC-335 Scope Recap (binding, not re-litigated)

Four stories, exactly as locked at the F1 human gate:

1. **`dpapi-storage-fix`** (#759 durable fix) — keyring-first + user-scope
   DPAPI-encrypted-file fallback for oversized OAuth access+refresh tokens, atomic,
   delete-keyring-first.
2. **`honest-fail-message`** (#759 backstop) — accurate `keyring::Error::TooLong`
   message + explicit dangling-grant revoke.
3. **`windows-docs`** (#760) — README Windows install + config-path + `cloud_id` caveat.
   README-ONLY, no `src/` BCs.
4. **`cloud_id-correctness`** (human-added) — fetch+persist `cloud_id` via
   `GET /_edge/tenant_info` on API-token login; closes A-PA-LOW-001.

**DEC-335's bundling instruction for items 1+2:** "the human BUNDLED stories 1+2 into ONE
RELEASE." This manifest implements that as a hard `depends_on` edge
(`S-cycle4-honest-fail-message` depends on `S-cycle4-dpapi-storage-fix`) rather than a
merge into one story file, for three reasons: (a) the two items have genuinely distinct,
independently-testable BC clusters (BC-1.4.035/036/037/038/040 + amended 028 vs.
BC-1.4.039 alone) that the product-owner's F2 pass already authored as separate BCs, not
one; (b) `honest-fail-message`'s Site-1/Site-3 message-selection logic is a real
compile-time dependency on `dpapi-storage-fix`'s marker types (`DpapiFallbackFailed`,
`ProfilePathEscape`) — it literally cannot be written, let alone merged, before those
types exist; (c) keeping them as two stories preserves independent story-level
traceability (BC→story, VP→story) without collapsing two BC clusters' worth of
acceptance criteria into one oversized story file. The `depends_on` edge is the
mechanism that satisfies "bundle into one release": Wave 1 → Wave 2 sequencing means
`honest-fail-message` cannot land ahead of, or independently from, `dpapi-storage-fix` —
closing F1 §12 item 6's open question ("ship honest-fail-message ahead of/independently
from dpapi-storage-fix?") in favor of "land together, same release," not "independent
fast-follow."

## 2. Story-by-Story Summary

| Story ID | Title | BCs | VPs | Points | Priority | Wave | Depends On |
|---|---|---|---|---|---|---|---|
| `S-cycle4-dpapi-storage-fix` | Windows DPAPI-encrypted-file OAuth-token fallback | BC-1.4.035/036/037/038/040, BC-1.4.028 (amended) | VP-AUTHDX-010/011/012/013/014/015/016/018/022/023 (10) | 13 | P0 | 1 | — |
| `S-cycle4-cloud-id-correctness` | API-token `cloud_id` acquisition (A-PA-LOW-001) | BC-1.2.052/053/054 | VP-AUTHDX-019/020/021 (3) | 8 | P1 | 1 | — |
| `S-cycle4-honest-fail-message` | Honest-fail backstop, distinct message text per site | BC-1.4.039 | VP-AUTHDX-017 (1) | 5 | P0 | 2 | `S-cycle4-dpapi-storage-fix` |
| `S-cycle4-windows-docs` | README Windows install/path-table/cloud_id caveat | — (doc-only) | — | 3 | P1 | 2 | `S-cycle4-cloud-id-correctness` |
| **Total** | | **10 BCs (9 NEW + 1 AMENDED)** | **14 VPs** | **29** | | **2 waves** | |

The 10 BCs and 14 VPs above are the FULL set of new/amended BCs and new VPs this cycle's F2
pass introduced (BC-1.4.035-040 + amended BC-1.4.028 in `bc-1-auth-identity.md` §1.4;
BC-1.2.052-054 in §1.2; VP-AUTHDX-010 through VP-AUTHDX-023 inclusive) — full coverage,
zero gaps, zero double-coverage, verified in §3 below. BC-6.1.004/BC-6.1.005 are cited
extensively as CROSS-REFERENCES by BC-1.4.035-040 (the primary, live profile-name
validation gate BC-1.4.040's guard sits behind as defense-in-depth) but are themselves
PRE-EXISTING, unmodified BCs — not new/amended by this cycle's F2 pass, so they are not
counted in this cycle's BC coverage matrix and no story is dispatched to "cover" them.

## 3. BC Coverage Matrix

| BC | Status | Covering Story |
|---|---|---|
| BC-1.2.052 | NEW (A-PA-LOW-001, ADR-0022 §1/§2) | `S-cycle4-cloud-id-correctness` |
| BC-1.2.053 | NEW (A-PA-LOW-001, ADR-0022 §3) | `S-cycle4-cloud-id-correctness` |
| BC-1.2.054 | NEW, confirmed-unchanged (A-PA-LOW-001, ADR-0022 §4) | `S-cycle4-cloud-id-correctness` |
| BC-1.4.028 | AMENDED (DPAPI-file check before the partial-state error) | `S-cycle4-dpapi-storage-fix` |
| BC-1.4.035 | NEW (keyring-first/DPAPI-fallback routing, ADR-0021 §1/§2) | `S-cycle4-dpapi-storage-fix` |
| BC-1.4.036 | NEW (read-path DPAPI-file fallback, ADR-0021 §4) | `S-cycle4-dpapi-storage-fix` |
| BC-1.4.037 | NEW (envelope + atomic file store, ADR-0021 §3/§5) | `S-cycle4-dpapi-storage-fix` |
| BC-1.4.038 | NEW (delete-both-backends, ADR-0021 §7) | `S-cycle4-dpapi-storage-fix` |
| BC-1.4.039 | NEW (honest-fail backstop, ADR-0021 §6) | `S-cycle4-honest-fail-message` |
| BC-1.4.040 | NEW (path-traversal guard, ADR-0021 §9) | `S-cycle4-dpapi-storage-fix` |

**Coverage check: 10/10 BCs assigned to exactly one story. No BC appears twice. No BC has
zero coverage.**

### VP Coverage Matrix

| VP | Anchor BC | Covering Story |
|---|---|---|
| VP-AUTHDX-010 | BC-1.4.037 | `S-cycle4-dpapi-storage-fix` |
| VP-AUTHDX-011 | BC-1.4.035 | `S-cycle4-dpapi-storage-fix` |
| VP-AUTHDX-012 | BC-1.4.035/037 | `S-cycle4-dpapi-storage-fix` |
| VP-AUTHDX-013 | BC-1.4.035/036/037/038 | `S-cycle4-dpapi-storage-fix` |
| VP-AUTHDX-014 | BC-1.4.037 | `S-cycle4-dpapi-storage-fix` |
| VP-AUTHDX-015 | BC-1.4.036 (co-covers amended BC-1.4.028) | `S-cycle4-dpapi-storage-fix` |
| VP-AUTHDX-016 | BC-1.4.040 | `S-cycle4-dpapi-storage-fix` |
| VP-AUTHDX-017 | BC-1.4.039 | `S-cycle4-honest-fail-message` |
| VP-AUTHDX-018 | BC-1.4.038 | `S-cycle4-dpapi-storage-fix` |
| VP-AUTHDX-019 | BC-1.2.052 | `S-cycle4-cloud-id-correctness` |
| VP-AUTHDX-020 | BC-1.2.053 | `S-cycle4-cloud-id-correctness` |
| VP-AUTHDX-021 | BC-1.2.054 | `S-cycle4-cloud-id-correctness` |
| VP-AUTHDX-022 | BC-1.4.035 | `S-cycle4-dpapi-storage-fix` |
| VP-AUTHDX-023 | BC-1.4.035 (the `JR_FORCE_DPAPI_FALLBACK` seam's own release-gate) | `S-cycle4-dpapi-storage-fix` |

**Coverage check: 14/14 VPs assigned. No VP appears in two stories' `verification_properties`
frontmatter. No VP has zero coverage.**

## 4. AC→BC Trace Coverage Summary

Every acceptance criterion across all four story files carries an explicit
`(traces to BC-S.SS.NNN <clause>)` annotation, except `S-cycle4-windows-docs`'s five ACs,
each of which is explicitly headed `(doc-only, no BC — ...)` per this cycle's binding
instruction that #760's doc-content ACs are not force-fit to an unrelated BC. Full
per-BC-clause coverage (which specific postcondition/invariant/edge-case each AC covers)
is recorded in `dependency-graph-extended.md`'s "BC Clause Coverage Matrix" and "Edge Case
Coverage Matrix" sections — summary here:

| Story | AC count | BC-traced ACs | Doc-only (no-BC) ACs | Gap Register entries |
|---|---|---|---|---|
| `S-cycle4-dpapi-storage-fix` | 20 | 20 | 0 | 0 |
| `S-cycle4-cloud-id-correctness` | 9 | 9 | 0 | 0 |
| `S-cycle4-honest-fail-message` | 7 | 7 | 0 | 0 |
| `S-cycle4-windows-docs` | 5 | 0 | 5 | 0 |
| **Total** | **41** | **36** | **5** | **0** |

**Zero untraced ACs.** Every BC-scope AC cites a specific BC and clause; every doc-scope AC
is explicitly labeled as such rather than silently omitting a trace. No Gap Register entry
is needed for this cycle — every BC postcondition/invariant/edge-case this F2 pass
introduced is covered by at least one AC (verified clause-by-clause in
`dependency-graph-extended.md`).

**Correction (F3 combined story-review pass, 2026-09-04, Finding #1/#2):**
`S-cycle4-dpapi-storage-fix`'s AC count was 18 at the time this table was first authored,
but its OWN frontmatter `acceptance_criteria_count` was independently stale at 14 — a
second, unrelated defect this same review pass fixed (frontmatter corrected to 19, matching
the body after AC-019 below was added). Row above updated 18→19 / 34→35 total /
39→40 grand total to add AC-019, which closes a real AC-BC coverage gap: BC-1.4.035
Postcondition 5 (`store_pair` failure surfaces `DpapiFallbackFailed`) had NO covering AC
before this pass, despite this table's prior "zero untraced ACs" / "Zero Gap Register
entries" claims — those claims were about TRACE FORMATTING (every AC that exists cites a
BC), not about CLAUSE COMPLETENESS (every BC clause has a covering AC); the two are
different checks, and only the former was actually verified when this table was first
written. See `dependency-graph-extended.md` §6/§8 for the corrected BC Clause Coverage
Matrix and Gap Register commentary.

**Correction (F3 re-review comprehensive fix pass, 2026-09-04, Findings #1/#2/#3/#4):**
this table's row above is updated again, 19→20 / 35→36 / 40→41, to add
`S-cycle4-dpapi-storage-fix`'s new AC-020 (closes BC-1.4.037 Invariant 3's coverage gap —
a dedicated, testable manifest source-text assertion for the "zero new dependency-graph
nodes" claim, previously covered only by a Task and an Architecture Compliance Rule, not a
runtime AC). This pass also: (a) added `CHANGELOG.md` to the File Structure Requirements
of `S-cycle4-dpapi-storage-fix`, `S-cycle4-cloud-id-correctness`, and
`S-cycle4-honest-fail-message` (it was already present for `S-cycle4-windows-docs`) — all
four stories' Tasks require a CHANGELOG entry, but three of the four footprint tables
omitted the file, making `wave-schedule.md` §2/§3's "zero file overlap" claim false; see
`wave-schedule.md` §7a and `conflict-report.md` §1/§4b for the corrected overlap analysis
and mitigation; (b) re-derived `dependency-graph-extended.md` §6's BC Clause Coverage
Matrix from the BC source text directly (not from the prior matrix), finding and closing
seven further clause-coverage gaps beyond AC-019's BC-1.4.035 Postcondition 5 fix — see
that file's §6/§6a/§8 for the full accounting; (c) added VP citations to
`S-cycle4-dpapi-storage-fix`'s AC-005 (`VP-AUTHDX-022`), AC-009, and AC-011 (both
`VP-AUTHDX-015`) for consistency with every other AC's VP-citation convention;
(d) corrected `conflict-report.md` §3a's `S-410` ignore-count evidence, which had
conflated real `#[ignore]` attributes with doc-comment prose mentioning the same text.

**VP-coverage observation for orchestrator (F3 story-review Finding #1's VP sub-question —
possible F2 VP gap, F2 frozen, NOT edited here).** While closing the AC gap above, no
existing VP anchored to BC-1.4.035 was found to specifically assert the PRODUCTION path
AC-019 now covers — that a genuine `auth_windows_store::store_pair` failure actually
PRODUCES a `DpapiFallbackFailed`-downcastable error (as opposed to a test manually
constructing that error value and checking only what happens downstream of it). Checked
against all three plausible candidates from the §3 VP Coverage Matrix's BC-1.4.035/037/039
rows: **VP-AUTHDX-011** asserts `store_pair` gets CALLED on `TooLong`, not what error TYPE
a subsequently-FAILING call returns; **VP-AUTHDX-012** asserts the on-disk FILE's state
after a write fault (no-split invariant, atomic rename), never the error TYPE surfaced to
the caller; **VP-AUTHDX-017** (BC-1.4.039, `S-cycle4-honest-fail-message`'s own VP) is
explicitly verified "via constructed error values" per its own Verification Method — it
assumes a `DpapiFallbackFailed`-wrapped error is handed to it and asserts only which
message TEXT gets selected, never that a real failure manufactures that marker in the first
place. `S-cycle4-dpapi-storage-fix.md`'s new AC-019 closes this at the STORY level without
minting a new VP ID (out of scope for F3 story decomposition); flagging here for whoever is
authorized to decide whether `bc-1-auth-identity.md` should gain a formal VP anchor for
this production-path property in a future F2 amendment.

## 5. Windows-Only Testability and the F4/F7 Validation Split (DEC-335)

Per DEC-335 and F1 §10 / architecture-delta §9 item 3, `S-cycle4-dpapi-storage-fix`'s
story body states this explicitly under its own "Windows Validation" section:

1. **F4 CI spike (REQUIRED):** determine whether `windows-latest` GitHub Actions CI can
   exercise `CryptProtectData` end-to-end headlessly. This gates ONLY VP-AUTHDX-010's
   sub-property (b) (the real syscall round-trip) — sub-property (a) (the
   `CRYPTPROTECT_LOCAL_MACHINE`-bit-clear assertion) is Windows-COMPILED and
   spike-independent, so it has automated coverage regardless of the spike's outcome.
2. **F7 manual Windows smoke-test gate (REQUIRED, not optional):** a human reproduces
   #759's exact repro steps on real Windows 11, confirming the DPAPI fallback round-trip
   and a subsequent `jr auth status`/API call succeed. This must be scheduled and recorded
   before cycle-004's F7 delta-convergence gate closes.

The keyring-gated state cores (VP-AUTHDX-011 sub-property 2, VP-AUTHDX-012 sub-property
1, VP-AUTHDX-015's partial-state branch, VP-AUTHDX-022 in full) additionally require the
`JR_FORCE_DPAPI_FALLBACK=1` debug-only seam PLUS a real OS keychain
(`JR_RUN_KEYRING_TESTS=1`) — this is the F2 VP-delta's CI-classification, cited verbatim in
`S-cycle4-dpapi-storage-fix.md`'s per-AC trace annotations (AC-006 in particular). This is
DISTINCT from the Windows-only tier: the keyring-gated tier can run on ANY OS's real
keychain (macOS Keychain, Linux Secret Service, or Windows Credential Manager), it is
gated by keychain availability, not by platform.

## 6. Dependency Rationale Beyond Story-Level `depends_on`/`blocks`

Full anchor justifications live in each story file's own "Anchor Justification" section
(per this pipeline's standing policy). Summarized here for the manifest's own
self-containedness:

- `S-cycle4-dpapi-storage-fix` → `S-cycle4-honest-fail-message`: hard compile-time
  dependency (marker types). Realizes DEC-335's release-bundling instruction.
- `S-cycle4-cloud-id-correctness` → `S-cycle4-windows-docs`: content-accuracy dependency,
  not a compile/file dependency — `windows-docs`' `cloud_id` caveat paragraph must
  describe the CORRECTED (post-fix) behavior, not the pre-fix "OAuth-only" limitation.
- `S-cycle4-dpapi-storage-fix` and `S-cycle4-cloud-id-correctness` are FILE-DISJOINT
  (verified against each story's own File Structure Requirements table: the former
  touches `src/api/auth.rs`/`src/api/auth_windows_store.rs`/`Cargo.toml`/`deny.toml`; the
  latter touches `src/cli/auth/login.rs`/`src/cli/auth/refresh.rs`/`src/cli/init.rs`/
  `src/api/jira/tenant.rs`) — safe to run in parallel in Wave 1, confirmed in
  `conflict-report.md`.

## 7. Points and Effort Summary

| Story | Points | Estimated Days |
|---|---|---|
| `S-cycle4-dpapi-storage-fix` | 13 | 5 |
| `S-cycle4-cloud-id-correctness` | 8 | 3 |
| `S-cycle4-honest-fail-message` | 5 | 2 |
| `S-cycle4-windows-docs` | 3 | 1 |
| **Total** | **29** | **11** |

See `wave-schedule.md` §5 for the critical-path derivation.

## 8. Template Compliance Confirmation

All four story files were authored against
`templates/story-template.md` (v1.1) directly, not derived from the cycle-003 files'
observed gaps. Each file was checked, section-by-section, for:

- [x] `level: ops` frontmatter key present (the exact gap cycle-003 left in 4/7 files)
- [x] `## Architecture Mapping` (Component | Module | Pure/Effectful table) present in
      all four stories, including `S-cycle4-windows-docs` (explicit N/A row, not an
      omitted section)
- [x] `## Purity Classification` (Module | Classification | Justification table) present
      in all four stories, including `S-cycle4-windows-docs` (explicit N/A row)
- [x] `## Library & Framework Requirements` present in all four stories, including an
      explicit "no new dependency" statement where applicable
- [x] All six MANDATORY context-engineering sections present in every story: Token Budget
      Estimate, Tasks, Previous Story Intelligence, Architecture Compliance Rules,
      Library & Framework Requirements, File Structure Requirements — `S-cycle4-dpapi-storage-fix`
      and `S-cycle4-cloud-id-correctness` (first stories in their respective sub-threads)
      state "N/A — first story" explicitly for Previous Story Intelligence rather than
      omitting the section
- [x] `## UX Screens` and `## Design System Components` present with explicit N/A in all
      four stories (none are UI stories)
- [x] `tdd_mode:` frontmatter present in all four: `strict` for the three code stories,
      `facade` for `S-cycle4-windows-docs` (a documentation-only story — no `todo!()`
      scaffold applies; the Red Gate density check has no meaning against a README diff)
- [x] `input-hash:` computed via `compute-input-hash --update` for every story file. **This
      manifest's own `input-hash` is a REAL, computed value (not `n/a-manifest`) — corrected
      (F3 round-3 re-review, 2026-09-04, Finding #3): an earlier revision of this bullet
      claimed the manifest's own hash was "deliberately `n/a-manifest`," but the frontmatter
      (line 20) has always carried a real hash computed from this manifest's own `inputs:`
      list (lines 9-18), exactly like every story file's `input-hash` — this manifest is a
      tracked input-hash-bearing artifact like the others, not an exception to the
      convention. The bullet's prose was simply wrong; reconciled here to match the
      frontmatter rather than the other way around, since the frontmatter value is the one
      `compute-input-hash` and the `validate-input-hash` drift check actually verify.**

## 9. Story-Anchor Backlink Obligation (BC Traceability Section)

Per this pipeline's BC-backlink policy, each covered BC's `Story Anchor: TBD (F3)` field
in `bc-1-auth-identity.md` should be updated to name the covering story from §3 above.
**This manifest does NOT perform that edit** — the task's explicit constraint is "Do NOT
modify ... the F2 spec files (BCs/VPs/ADRs)" for this F3 dispatch. Recorded here as the
authoritative mapping for whichever downstream step (state-manager, or a dedicated
spec-steward pass) is authorized to apply the BC-file backlink edit.

| BC | Story Anchor (to be written into bc-1-auth-identity.md) |
|---|---|
| BC-1.2.052, BC-1.2.053, BC-1.2.054 | `S-cycle4-cloud-id-correctness` |
| BC-1.4.028 (amended), BC-1.4.035, BC-1.4.036, BC-1.4.037, BC-1.4.038, BC-1.4.040 | `S-cycle4-dpapi-storage-fix` |
| BC-1.4.039 | `S-cycle4-honest-fail-message` |
