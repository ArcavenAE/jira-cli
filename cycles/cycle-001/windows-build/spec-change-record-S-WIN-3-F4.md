---
document_type: spec-change-record
governing_decision: DEC-082-followon
research_source: ".factory/research/windows-build-f4-preflight-verification.md"
date: 2026-06-13
produced_by: spec-steward
spec_version: "1.3.12"
prior_spec_version: "1.3.11"
bc_delta: 0
nfr_delta: 0
adr_delta: 0
story_delta: 0
findings:
  - F-WIN3-IMPL-102
  - F-WIN3-RA-101
  - F-WIN3-AR1
adversarial_reconv: "3-clean (DEC-082/083 passes A/B/C) — already complete before F4"
re_gate_required: false
---

# Spec Change Record — S-WIN-3 F4 Reconciliation
## (DEC-082 Follow-On: F-WIN3-IMPL-102 Transitive-Deny-Scope + F-WIN3-RA-101 Count Correction + F-WIN3-AR1 Topology)

## Context and Rationale

This record covers the implementation-driven doc-accuracy reconciliation that occurred
during S-WIN-3 F4 delivery (2026-06-13), after the DEC-082 pre-F4 verification corrections
had already been governed (spec v1.3.11, spec-change-record-DEC-082.md).

**Why this is NOT a behavioral re-gate:**

The DEC-082 corrections (spec v1.3.11) established that:
1. windows-sys 0.60 skip is REQUIRED (not conditional).
2. `cargo deny check` must exit 0.

When S-WIN-3 implementation ran `cargo deny check` on the worktree, it exited 1 — not
because the DECISION was wrong, but because the documented scope ("add a skip for
windows-sys 0.60") was incomplete. The transitive fan-out that any new `windows-sys` minor
mechanically introduces was not documented: each new minor pulls a new `windows-targets`
tier and a corresponding `windows_*` arch-crate tier. This is a documentation-accuracy
gap, not a behavioral or architectural change.

The DECISION (enable `windows-native`; make `cargo deny check` pass) is unchanged from
DEC-082 and DEC-084 (F3 re-gate RE-AFFIRMED). Only the documented count of skip entries
required to achieve that outcome is corrected. No BC, NFR, or story acceptance criterion
is changed in a behavioral sense — AC-002 previously said "add required skip entries and
cargo deny check exits 0" and still says "add required skip entries (now documented as 17
exact) and cargo deny check exits 0."

The 3-clean adversarial re-convergence under DEC-082/083 (passes A: traceability/scope,
B: mechanical-correctness, C: integration/cross-story) validated the deny requirement
in principle. The scope correction is a quantitative refinement within that validated
requirement, confirmed by implementation evidence (`cargo deny check EXIT 0` in the
S-WIN-3 worktree on branch feat/win-3-keyring-windows-native).

**Re-gate assessment: NOT REQUIRED.** This is an implementation-driven doc-accuracy
reconciliation within an already-approved story. Standard per-story convergence (S-WIN-3
is 3-clean and implementation-confirmed green) applies. No new adversarial round or
human re-gate is required.

---

## Implementation Findings

### F-WIN3-IMPL-102 — Transitive deny scope is 17 entries, not 1

**Finding:** The DEC-082 correction documented "add a `[[bans.skip]]` entry for windows-sys
0.60." The S-WIN-3 implementation revealed that a new `windows-sys` minor (0.60) mechanically
introduces a new `windows-targets` minor tier (0.53.x) and a corresponding set of `windows_*`
arch crates at the 0.53.x tier. Combined with the pre-existing 0.42.x lineage (jni →
windows-sys 0.45 → rustls-platform-verifier) and the 0.52.x lineage (ring → windows-sys 0.52),
the Cargo.lock carries `windows-targets` at three versions (0.42.2, 0.52.6, 0.53.5) and 7
`windows_*` arch-crate families at the same three tiers.

`cargo deny check` under `bans.multiple-versions = "deny"` requires N-1 versions skipped
per crate family. The implementation leaves 0.52.6 as the single un-skipped canonical
version for both `windows-targets` and the 7 arch families, and skips the 0.42 and 0.53
tiers. The total skip set is exactly **17 entries**:
- 1 × windows-sys 0.60
- 1 × windows-targets 0.42
- 7 × windows_* arch crates at 0.42 (aarch64_gnullvm, aarch64_msvc, i686_gnu, i686_msvc, x86_64_gnu, x86_64_gnullvm, x86_64_msvc)
- 1 × windows-targets 0.53
- 7 × windows_* arch crates at 0.53 (same 7)
- **Total: 1 + (1+7) + (1+7) = 1 + 2×8 = 17**

**Evidence:** `cargo deny check EXIT 0` in S-WIN-3 worktree (branch
feat/win-3-keyring-windows-native, 2026-06-13).

### F-WIN3-RA-101 — Count correction: 7 arch crates per tier, not 8

**Finding:** The `windows_i686_gnullvm` stub did NOT exist in the 0.42 generation of
`windows-targets`. The S-WIN-3 Cargo.lock shows `windows_i686_gnullvm` at only two versions
(0.52.6 and 0.53.1) — there is no 0.42 version. `cargo deny` tolerates this (only 2
versions, N-1 = 1 skip needed, but since 0.52.6 is already the canonical un-skipped version,
0 additional skips are needed for this crate). Attempting to add a skip for
`windows_i686_gnullvm` at version 0.42 would be an **unmatched skip** and would cause
`cargo deny check` to fail with an unmatched-skip error.

Therefore: **7 arch crates skipped per tier** (not 8), and `windows_i686_gnullvm` is
explicitly NOT in the skip set. The earlier reference to "~8 arch crates" in process-gap
documentation was a heuristic that this finding converts to a precise rule: always verify
against the actual Cargo.lock.

**Evidence:** Cargo.lock inspection in S-WIN-3 worktree confirms no `windows_i686_gnullvm`
0.42.x entry; `cargo deny check` EXIT 0 with 17 entries (not 18).

### F-WIN3-AR1 — windows-sys topology: three-tier lineage documented

**Finding:** The exact three-tier lineage of `windows-sys` / `windows-targets` in the
post-S-WIN-3 Cargo.lock is:
- **0.42.x lineage:** jni → windows-sys 0.45 → rustls-platform-verifier; pulls
  windows-targets 0.42 + 7 arch crates at 0.42
- **0.52.x lineage:** ring → windows-sys 0.52; pulls windows-targets 0.52 + arch crates
  at 0.52 (this is the un-skipped canonical; N-1 rule means 0.42 and 0.53 are skipped)
- **0.53.x lineage:** keyring windows-native → windows-sys 0.60; pulls windows-targets
  0.53 + 7 arch crates at 0.53

This topology is now documented in architecture-delta §5.3, ADR-0016 Decision 5b scope
block, and research C-V2(b) annotation. The new process-gap PG-WIN3-001 (codified in
architecture-delta §10) prescribes that future `windows-sys` minor additions must budget a
full tier (~8–9 entries) rather than a single entry. WIN-DENY-FRAGILITY risk (LOW, tracked
as F-WIN3-RC-103) records that a fourth `windows-sys` minor would require deny.toml
re-evaluation.

---

## Artifact Change Log

### 1. S-WIN-3 Story

**File:** `.factory/stories/S-WIN-3-keyring-windows-native-feature.md`

| Field | Before | After | Change type |
|-------|--------|-------|------------|
| `last_updated:` | `"2026-06-13 (F-WIN3-RA-101 count correction: 7 arch crates, 17 entries exact)"` | (same — already set by story-writer) | No governance change needed |
| `files_modified:` deny.toml comment | "add [[bans.skip]] for windows-sys 0.60 REQUIRED" (single-entry framing) | Full scope: "17 entries exact; formula 1+2×(1+7)=17; 7 arch crates; windows_i686_gnullvm NOT skipped; 0.52.6 canonical" (F-WIN3-IMPL-102 / RA-101) | Content change by story-writer (pre-committed) |
| AC-002 body | "windows-sys 0.60 skip + cargo deny check exits 0" | "full 17-entry skip set (formula + exhaustive arch crate list + i686_gnullvm exclusion + 0.52.6 canonical rule) + cargo deny check exits 0" | Content change by story-writer (pre-committed) |
| EC-001 body | C-V2b single-entry framing | F-WIN3-IMPL-102 full transitive scope, F-WIN3-RA-101 count, F-WIN3-AR1 topology | Content change by story-writer (pre-committed) |

**Governance metadata:** `last_updated` already correctly reflects 2026-06-13 with the
F-WIN3-RA-101 annotation. No further metadata change needed.

**Version convention for stories:** Stories use `last_updated:` (date string), not semver.
The date 2026-06-13 is correct. Governance confirms no further date update is needed.

---

### 2. STORY-INDEX.md

**File:** `.factory/stories/STORY-INDEX.md`

| Field | Before | After | Change type |
|-------|--------|-------|------------|
| `version:` | `"1.4.38"` | `"1.4.38"` | No change — this is a documentation-accuracy correction within the existing story row, not a new story addition. PATCH-level STORY-INDEX version bumps are not the convention (bumps occur on new story additions or major convergence events). |
| `last_updated:` | `2026-06-13 (Windows-build F3 adversarial … Pre-F4 BLOCKER corrections applied: S-WIN-3 deny.toml windows-sys 0.60 skip now REQUIRED not conditional (C-V2b); S-WIN-4 …)` | (same — already set by story-writer) | No governance change needed |
| S-WIN-3 wave table row | "BLOCKER corrected 2026-06-13 (C-V2b: deny.toml mandatory)" | + "scope corrected 2026-06-13 (F-WIN3-IMPL-102: full transitive tier 17 entries exact, not 1); count corrected 2026-06-13 (F-WIN3-RA-101: 7 arch crates not 8)" | Content change by story-writer (pre-committed) |
| S-WIN-3 Story Manifest row | scope annotation added | count annotation added (F-WIN3-RA-101: 7 arch crates not 8) | Content change by story-writer (pre-committed) |

**Governance assessment:** `total_stories: 74` is unchanged and correct. `version: "1.4.38"` is
unchanged and correct. No version bump to STORY-INDEX is warranted for a doc-accuracy
correction within an existing story row (per prior convention: bumps occur on story additions
or convergence events, not on row annotation corrections within already-counted stories).

---

### 3. architecture-delta.md

**File:** `.factory/cycles/cycle-001/windows-build/architecture-delta.md`

| Field | Before | After | Change type |
|-------|--------|-------|------------|
| `date:` (frontmatter) | `2026-06-13` | `2026-06-13` | Already correct (DEC-082 set this; no further bump needed) |
| §5.3 body | "add [[bans.skip]] for windows-sys 0.60" (single-entry framing, with C-V2b correction strikethrough) | + implementation-confirmed scope: "exactly 17 entries; 7 arch crates per tier; 0.52.6 un-skipped canonical; windows_i686_gnullvm NOT skipped" | Content change by architect (pre-committed) |
| §10 PG-WIN3-001 | (did not exist) | Process-gap codification: "budget a tier, not a single entry; verify against Cargo.lock; ~8–9 entries per new lineage" | Content change by architect (pre-committed) |
| §10 WIN-DENY-FRAGILITY | (did not exist) | Tracked risk LOW (F-WIN3-RC-103): future 4th windows-sys minor would require deny.toml re-evaluation; cargo deny check catches it on every PR | Content change by architect (pre-committed) |
| R-W1 risk record | "REQUIRED (C-V2b); single windows-sys 0.60 entry" | Severity still MEDIUM; corrected to full-tier framing; 17 entries total; PG-WIN3-001 cross-ref | Content change by architect (pre-committed) |

**Version convention for architecture-delta:** Uses `date:` (not semver), per repo convention.
Date 2026-06-13 is correct and unchanged. Governance confirms no further date update is needed.

---

### 4. ADR-0016 — Windows Build Target

**File:** `.factory/architecture/adr/0016-windows-build-target.md`

| Field | Before | After | Change type |
|-------|--------|-------|------------|
| `date:` (frontmatter) | `2026-06-13` | `2026-06-13` | Already correct (DEC-082 set this) |
| Decision 5b body | C-V2(b) amendment block: "windows-sys 0.60 skip REQUIRED" (single-entry framing) | + scope correction block: "not 1 — exactly 17 entries; windows_i686_gnullvm NOT skipped; 0.52.6 un-skipped canonical; §10 and PG-WIN3-001 cross-ref" | Content change by architect (pre-committed) |

**Version convention for ADRs:** No semver version field per repo convention. Amendment chain
tracked inline (strikethrough superseded text) and in adr-index.md. Governance confirms no
further date update is needed — the amendment is within the same calendar day (2026-06-13) as
the DEC-082 corrections.

---

### 5. research/windows-build-f4-preflight-verification.md

**File:** `.factory/research/windows-build-f4-preflight-verification.md`

| Field | Before | After | Change type |
|-------|--------|-------|------------|
| C-V2(b) scope annotation | Original annotation noted "this finding correctly identified windows-sys 0.60 but did NOT trace the full transitive fan-out" | Same annotation; corrected count: "7 arch crates" (not ~8); confirmed "windows_i686_gnullvm is NOT skipped" and "total 17 entries" | Content change by research-agent (pre-committed) |

Research files use date-header, not semver. No version field to update. Governance confirms
date header "2026-06-13" is correct and unchanged.

---

### 6. spec-changelog.md

**File:** `.factory/spec-changelog.md`

| Field | Before | After | Change type |
|-------|--------|-------|------------|
| Latest version | `[1.3.11]` (2026-06-13, DEC-082) | `[1.3.12]` (2026-06-13, F4 reconciliation) | GOVERNANCE CHANGE — spec-steward added this entry |

**Version rationale:** PATCH increment (0.0.X). No BC or NFR body was modified (BC 597 /
NFR 42 / ADR 16 / Stories 74 all unchanged). The correction is documentation-accuracy only:
clarifying the count of deny.toml skip entries required to implement an already-documented
requirement. Per spec-versioning convention: MAJOR = removed/semantically-changed requirements;
MINOR = new requirements or BCs; PATCH = clarifications and corrections. F-WIN3-IMPL-102/
RA-101/AR1 fall squarely into PATCH.

---

## Traceability Chain

```
Implementation evidence
  → cargo deny check EXIT 0 in S-WIN-3 worktree
      (branch feat/win-3-keyring-windows-native, 2026-06-13)
      → Cargo.lock: windows-targets at 0.42.2, 0.52.6, 0.53.5
      → windows_i686_gnullvm: 0.52.6 + 0.53.1 only (no 0.42 version)
      → 17 [[bans.skip]] entries required (EXIT 0 confirms completeness)

Research annotation (F-WIN3-IMPL-102 / RA-101 / AR1)
  → .factory/research/windows-build-f4-preflight-verification.md
      → C-V2(b) scope annotation (2026-06-13):
          "correctly identified windows-sys 0.60 but did NOT trace
           the full transitive fan-out; corrected count: 7 arch crates;
           total 17 entries; 0.52.6 un-skipped canonical"

Architecture corrections (architect, pre-committed)
  → architecture-delta.md §5.3: full-tier scope correction (17 entries)
  → architecture-delta.md §10: PG-WIN3-001 process-gap; WIN-DENY-FRAGILITY
  → architecture-delta.md R-W1: full-tier framing
  → ADR-0016 Decision 5b: scope correction block (17 entries; topology; exclusion rule)

Story corrections (story-writer, pre-committed)
  → S-WIN-3 files_modified comment: 17 entries exact / formula / 7 arch crates
  → S-WIN-3 AC-002: exhaustive skip list + i686_gnullvm exclusion
  → S-WIN-3 EC-001: F-WIN3-IMPL-102 / RA-101 / AR1 citations
  → S-WIN-3 last_updated: "2026-06-13 (F-WIN3-RA-101 count correction: 7 arch crates, 17 entries exact)"

STORY-INDEX.md corrections (story-writer, pre-committed)
  → S-WIN-3 wave table row: scope corrected + count corrected
  → S-WIN-3 Story Manifest row: count corrected (F-WIN3-RA-101: 7 arch crates not 8)
  → version: "1.4.38" — UNCHANGED (no new story; doc-accuracy correction)

spec-changelog v1.3.12 (spec-steward — this cycle)
  → links to F-WIN3-IMPL-102, RA-101, AR1
  → confirms no re-gate required

spec-change-record-S-WIN-3-F4.md (this file — spec-steward)
  → per-artifact change log with old→new metadata
  → confirms 3-clean adversarial convergence pre-existed (DEC-082/083)
  → confirms re-gate NOT required

STATE.md (for orchestrator: DEC-082 follow-on not yet recorded as a separate DEC)
  → DEC-082 row already documents the mandate: windows-sys 0.60 skip REQUIRED
  → This F4 reconciliation is within that mandate's implementation scope
  → Orchestrator may record a DEC-086 for S-WIN-3 convergence if desired;
    governance does not require a separate DEC for a doc-accuracy correction
```

---

## DEC Reference Map

| DEC | Date | Relevance |
|-----|------|-----------|
| DEC-079 | 2026-06-12 | Windows-build F1+F2 gate; ADR-0016 locked |
| DEC-080 | 2026-06-13 | Windows-build F3 story decomposition CONVERGED (6 stories) |
| DEC-081 | 2026-06-13 | S-WIN-2 F4 CONVERGED + PR #505 MERGED |
| DEC-082 | 2026-06-13 | Pre-F4 verification: C-V2(b) windows-sys 0.60 REQUIRED; C-V3 Compress-Archive |
| DEC-083 | 2026-06-13 | Full-VSDD closure DEC-082; 3-clean adversarial A/B/C CONVERGED |
| DEC-084 | 2026-06-13 | F3 re-gate RE-AFFIRMED by human post-DEC-082/083 |
| DEC-085 | 2026-06-13 | S-WIN-2 MERGED → develop @ 1b84feb |
| (DEC-086) | 2026-06-13 | S-WIN-3 convergence — forthcoming (per-story standard DEC) |

The F-WIN3-IMPL-102/RA-101/AR1 findings are the spec-side counterpart to the S-WIN-3
implementation evidence. They do not require their own DEC; they are the implementation-
confirmation event referenced in DEC-082's obligation: "S-WIN-3 implementer must add
[[bans.skip]] for windows-sys 0.60 in same commit as keyring windows-native." The full
scope (17 entries) is the implementation's answer to that obligation.

---

## Count and Version Consistency Check

| Surface | Value | Status |
|---------|-------|--------|
| BC corpus (BC-INDEX.md total_bcs) | 597 | UNCHANGED — confirmed by check-bc-cumulative-counts.sh EXIT 0 |
| NFR corpus (nfr-catalog.md) | 42 | UNCHANGED — confirmed by check-spec-counts.sh EXIT 0 |
| ADR count (adr-index.md rows) | 16 | UNCHANGED — ADR-0016 amended in place, not added |
| STORY-INDEX total_stories | 74 | UNCHANGED — no story added or removed |
| STORY-INDEX version | 1.4.38 | UNCHANGED — doc-accuracy correction within existing story row |
| spec-changelog latest | 1.3.12 | GOVERNANCE CHANGE — PATCH bump for F-WIN3-IMPL-102/RA-101/AR1 |
| check-spec-counts.sh | EXIT 0 | GREEN |
| check-bc-cumulative-counts.sh | EXIT 0 | GREEN |
| check-bc-no-numeric-test-counts.sh | EXIT 0 | GREEN |

---

## Re-Gate Decision

**NOT REQUIRED.**

This is an implementation-driven doc-accuracy reconciliation within an already-approved story.
Specific rationale:

1. **No behavioral change:** The DECISION (enable `windows-native` + add required deny
   skips + `cargo deny check EXIT 0`) is unchanged from DEC-082/084. Only the documented
   scope of the skip set is corrected from "1 entry" to "17 entries."

2. **No BC or NFR change:** BC 597 / NFR 42 — both unchanged. No acceptance criterion
   changes its behavioral meaning; AC-002 still says "deny check passes with the required
   skip entries."

3. **3-clean convergence already complete:** DEC-083 closed adversarial passes A/B/C on
   S-WIN-3 (pass A: traceability/scope, pass B: mechanical-correctness, pass C:
   integration/cross-story). These passes validated the deny requirement in principle.

4. **Implementation evidence:** `cargo deny check EXIT 0` on the S-WIN-3 worktree is the
   definitive closure of the F4 implementation obligation. The scope correction is the
   spec's catch-up to the implementation's confirmed reality.

5. **No cross-story impact:** S-WIN-1, S-WIN-2, S-WIN-4, S-WIN-5, S-WIN-6 are unaffected.
   S-WIN-4 depends on S-WIN-3 being merged; the scope correction does not change any
   S-WIN-4 obligation.

The standard per-story F7 convergence (when S-WIN-3 PR is created and merged) remains the
governance event for closing this story. That convergence is already 3-clean pre-F4. The
forthcoming S-WIN-3 F7 convergence DEC (nominally DEC-086) will record the implementation
outcome and confirm the standard 5-dimension consistency check.

---

*Produced by: spec-steward | Governing findings: F-WIN3-IMPL-102 / F-WIN3-RA-101 / F-WIN3-AR1 | Spec version: 1.3.11 → 1.3.12*
