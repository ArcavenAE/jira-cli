---
document_type: consistency-audit
bundle: S-FORK-OPS-BACKFILL
phase: F2
auditor: consistency-validator
created: 2026-06-18
scope: perimeter-audit (cross-document drift, broken cross-refs, scope mismatch, ID/count inconsistencies)
verdict: INCONSISTENT (3 findings)
---

# F2 Consistency Audit — S-FORK-OPS-BACKFILL

**Scope:** Cross-document perimeter consistency check of the F2 spec-delta package
for the S-FORK-OPS-BACKFILL bundle, BEFORE human approval gate. This is the
external-lens review — not an internal-correctness re-review. Adversarial passes
1 and 2 are assumed to have covered internal correctness.

**Verdict: INCONSISTENT (3 findings)**

---

## Documents Reviewed

| Document | Path |
|----------|------|
| spec-delta | `.factory/phase-f2-spec-evolution/spec-delta-fork-ops-backfill.md` |
| architecture-delta | `.factory/phase-f2-spec-evolution/architecture-delta-fork-ops-backfill.md` |
| verification-delta | `.factory/phase-f2-spec-evolution/verification-delta-fork-ops-backfill.md` |
| prd-delta | `.factory/phase-f2-spec-evolution/prd-delta-fork-ops-backfill-1.md` |
| spec-changelog | `.factory/spec-changelog.md` (entry [1.3.24]) |
| F1 delta analysis | `.factory/phase-f1-delta-analysis/delta-analysis-fork-ops-backfill-1.md` |
| STATE.md | `.factory/STATE.md` |
| BC-INDEX.md | `.factory/specs/prd/BC-INDEX.md` |
| CANONICAL-COUNTS.md | `.factory/specs/prd/CANONICAL-COUNTS.md` |
| nfr-catalog.md | `.factory/specs/prd/nfr-catalog.md` |
| STORY-INDEX.md | `.factory/stories/STORY-INDEX.md` |

---

## Summary Table

| # | Area | Severity | Status |
|---|------|----------|--------|
| F1 | BC count stale: prd-delta and spec-changelog [1.3.24] cite 598; ground truth is 599 | MAJOR | FAIL |
| F2 | Backfill-matrix-parity test: prd-delta says Optional; verification-delta says REQUIRED (Story-1 AC) | MAJOR | FAIL |
| F3 | Story IDs not yet registered in STORY-INDEX: S-FORK-OPS-BACKFILL-1 and S-FORK-OPS-GITLEAKS-DOC-1 are absent | MINOR | FAIL |

---

## Findings

### F1 — BC Count Stale in prd-delta and spec-changelog [1.3.24]

**Severity: MAJOR**

**Location:**
- `.factory/phase-f2-spec-evolution/prd-delta-fork-ops-backfill-1.md` lines 176 and 52:
  `total_bcs` remains 598 (line 176: `BC-INDEX.md — no new rows; total_bcs 598 unchanged`;
  line 52: `All BC files — no contract changes; total_bcs remains 598`)
- `.factory/spec-changelog.md` [1.3.24] lines 51–52:
  `All BC files — no contract changes; total_bcs remains 598`
  `BC-INDEX.md — no new rows; total_bcs 598 unchanged`

**Ground truth:**
- `BC-INDEX.md` frontmatter: `total_bcs: 599`
- `CANONICAL-COUNTS.md` Sum row: **599**
- `CANONICAL-COUNTS.md` last_verified: `2026-06-17 (BC-2.4.043 added Bundle C CR-001; 599 total)`
- `STATE.md` Session Resume Checkpoint: `BC 599`

**Analysis:**
The F2 prd-delta and the [1.3.24] spec-changelog entry were authored using the
stale count 598. The actual count became 599 on 2026-06-17 when BC-2.4.043
(list_comments anti-stall guard via Bundle C CR-001) was added. The prd-delta and
changelog entry were created on 2026-06-18 — after the count update — but reference
the prior value. The claim "total_bcs remains 598" is factually wrong; the correct
claim is "total_bcs remains 599 (no change from this bundle)."

This is not a consequence of this bundle adding BCs — it adds none. It is a
copy-paste of a stale baseline figure. An F3 story-writer or F4 implementer who
consults the prd-delta or spec-changelog to verify the BC count will read an
incorrect value.

**Fix:**
In both `prd-delta-fork-ops-backfill-1.md` and `spec-changelog.md` [1.3.24],
replace every occurrence of `total_bcs` `598` with `599`. The corrected sentence
should read:
- `BC-INDEX.md — no new rows; total_bcs 599 unchanged`
- `All BC files ... total_bcs remains 599`

The [1.3.24] Files NOT Changed section in spec-changelog.md (line 51) and the
prd-delta's Files NOT Changed section (lines 176, 52) both require this correction.

---

### F2 — Backfill-Matrix-Parity Test: Optional in prd-delta, REQUIRED in verification-delta

**Severity: MAJOR**

**Location:**
- `.factory/phase-f2-spec-evolution/prd-delta-fork-ops-backfill-1.md` line 118:
  `Optional: add a backfill-matrix-parity test analogous to tests/ci_yml_windows_matrix.rs`
- `.factory/phase-f2-spec-evolution/verification-delta-fork-ops-backfill.md` lines 65–68:
  `Status: REQUIRED. This is a Story 1 (S-FORK-OPS-BACKFILL-1) acceptance criterion.
  Story 1 is not complete without this test.`

**Analysis:**
The F1 delta analysis described the test as a "new-test candidate" (delta-analysis
line 224: "NEW CANDIDATE ... if low-cost"). The verification-delta (Pass 1 revised)
promoted this to REQUIRED per the adversarial review Pass 1 finding H3 — the promotion
is documented in the verification-delta's revision_reason frontmatter. The prd-delta
was not updated to reflect this promotion. As a result, a reader consulting only
the prd-delta would believe the test is discretionary, while the spec that governs
Story 1 acceptance criteria marks it mandatory.

This is a direct contradiction between two normative F2 documents. If the prd-delta
governs what is "in scope" for F3 story writing, Story 1's acceptance criteria will
be written without the mandatory test. The prd-delta's Architecture/Engineering-Spec
Delta section (line 118) contains the offending "Optional:" qualifier.

**Fix:**
In `prd-delta-fork-ops-backfill-1.md`, change the "Optional:" qualifier in the Story 1
section to mandatory language that aligns with verification-delta:

Before:
```
- Optional: add a backfill-matrix-parity test analogous to
  `tests/ci_yml_windows_matrix.rs`.
```

After:
```
- Add `tests/backfill_matrix_parity.rs` (backfill-matrix-parity guard): REQUIRED
  Story-1 acceptance criterion, analogous to `tests/ci_yml_windows_matrix.rs`.
  See verification-delta-fork-ops-backfill.md "Required New Test" section.
```

---

### F3 — Story IDs Not Yet Registered in STORY-INDEX

**Severity: MINOR**

**Location:**
- `.factory/stories/STORY-INDEX.md`: no rows for `S-FORK-OPS-BACKFILL-1` or
  `S-FORK-OPS-GITLEAKS-DOC-1`
- `STORY-INDEX.md` frontmatter: `total_stories: 81` (authoritative)
- `STATE.md` Session Resume Checkpoint: `Stories 81 (authoritative)`
- `STORY-INDEX.md` last_updated: `2026-06-18 (S-FORK-OPS-SIGN-1 added; ... 80→81)`

**Analysis:**
The F2 documents name the two new stories (`S-FORK-OPS-BACKFILL-1`,
`S-FORK-OPS-GITLEAKS-DOC-1`) but neither story exists as a file in
`.factory/stories/` nor as a row in `STORY-INDEX.md`. The current STORY-INDEX
`total_stories` is 81 (correct for the pre-F3 state). This is expected at F2: stories
are registered during F3. However, STATE.md's RESUME PLAN (Step 3) says "Confirm
story files S-FORK-OPS-BACKFILL-1 + S-FORK-OPS-GITLEAKS-DOC-1 exist or create
them" as part of F2 work, implying the orchestrator expects them to potentially
already exist. The F2 documents do not explicitly note that story registration is
deferred to F3, which could cause a cold-start orchestrator to halt at F2.

This is a process documentation gap, not a structural error: the story IDs are
consistent across all four F2 documents (spec-delta, architecture-delta,
verification-delta, prd-delta all use identical ID strings). No collision with
any existing story ID was found.

**Fix:**
Add a note in any one of the F2 documents (prd-delta is appropriate) in its
RESUME PLAN section explicitly stating that F3 is the phase that creates story
files for `S-FORK-OPS-BACKFILL-1` and `S-FORK-OPS-GITLEAKS-DOC-1`, and that
`STORY-INDEX.md` will advance from 81 to 83 at F3 registration. This prevents
cold-start confusion. Alternatively, accept as-is and update STATE.md Step 3 to
say "create them (F3)" rather than "exist or create them."

---

## Items Verified CONSISTENT

The following checks passed with no findings:

### Scope Fidelity (PASS)
All three F1-approved drift items — FORK-OPS-BACKFILL-WIN-TARGET, FORK-OPS-BACKFILL-DESTRUCTIVE,
FORK-OPS-GITLEAKS-DOC — are covered by the F2 spec-delta and prd-delta with no scope
additions or silent drops. Architecture-delta and verification-delta confirm zero items
outside this set. Nothing from the F1 analysis was dropped; nothing was added beyond it.

### Decomposition Consistency (PASS)
All four F2 documents (spec-delta, architecture-delta, verification-delta, prd-delta)
use the identical 2-story split: Story 1 = S-FORK-OPS-BACKFILL-1 (WIN-TARGET +
DESTRUCTIVE in backfill-release.yml); Story 2 = S-FORK-OPS-GITLEAKS-DOC-1 (GITLEAKS-DOC
in docs/specs/fork-friendly-release-ops.md + CLAUDE.md). No document implies a different
grouping. This matches DEC-122 in STATE.md exactly.

### Version Bump (PASS)
- prd-delta frontmatter: `spec_version_old: "1.3.23"`, `spec_version_new: "1.3.24"`,
  `spec_version_bump: PATCH`
- spec-changelog entry `[1.3.24]` type: PATCH, summary begins "F2 spec delta for the
  S-FORK-OPS-BACKFILL bundle"
- spec-changelog prior entry is `[1.3.23]` — transition is a PATCH increment
- PATCH classification is appropriate: no new BCs, no new NFRs, infrastructure-only
- Consistent with S-FORK-OPS-SIGN-1 precedent cited in prd-delta

### NFR-P-W1 Reference (PASS)
`nfr-catalog.md` contains NFR-P-W1 at the expected location (Dimension 4 —
Performance/Platform, total_nfrs: 42). The prd-delta and spec-changelog correctly
state that WIN-TARGET closes the implementation gap against the existing NFR-P-W1
without creating a new NFR. NFR count remains 42.

### DEC-122 Consistency (PASS)
STATE.md DEC-122 names exactly the two stories (S-FORK-OPS-BACKFILL-1 +
S-FORK-OPS-GITLEAKS-DOC-1) with the same grouping rationale (file-conflict
avoidance) as the F1 delta analysis and the F2 spec-delta. All documents agree.

### ADR-0016 Reference Validity (PASS)
ADR-0016 (Windows build target) is referenced in architecture-delta as the
"authoritative architecture record for the x86_64-pc-windows-msvc target
decision." The ADR exists (mentioned throughout BC-INDEX, CANONICAL-COUNTS,
STORY-INDEX, STATE.md). The claim that WIN-TARGET is an "implementation-of-the-ADR
action, not a new decision" is valid and consistent with ADR-0016's scope.

### S-WIN-4 / S-WIN-5 Reference Validity (PASS)
spec-delta and prd-delta cite S-WIN-4 (MERGED) as the precedent for the PowerShell
Compress-Archive packaging pattern. verification-delta cites S-WIN-5 as the
precedent for making the backfill-matrix-parity test REQUIRED. Both stories exist
in `.factory/stories/` and STORY-INDEX. References resolve to real entities.

### S-FORK-OPS-SIGN-1 Reference Validity (PASS)
F1 delta analysis and prd-delta cite S-FORK-OPS-SIGN-1 as the precedent for
"no product BCs in fork-ops CI/CD bundles." S-FORK-OPS-SIGN-1 exists as a story
file (`S-FORK-OPS-SIGN-1-signing-workflow-hardening.md`) and is in STORY-INDEX
(merged, PR #535). Reference resolves.

### Story-ID Forward Consistency (PASS)
The story IDs `S-FORK-OPS-BACKFILL-1` and `S-FORK-OPS-GITLEAKS-DOC-1` are named
identically across all four F2 documents and match STATE.md's DEC-122 and
RESUME PLAN. No document uses a variant form (e.g., `S-FORK-OPS-BACKFILL-2` or
`S-FORK-OPS-GITLEAKS-1`). No collision with any existing story ID was found by
scanning all 51 story file names and STORY-INDEX rows.

### Drift Item ID Consistency (PASS)
The three drift-item IDs (FORK-OPS-BACKFILL-WIN-TARGET, FORK-OPS-BACKFILL-DESTRUCTIVE,
FORK-OPS-GITLEAKS-DOC) are spelled identically in F1 delta analysis, all four F2
documents, STATE.md Drift Items table (where all three appear as IN-PROGRESS), and
the spec-changelog [1.3.24] summary. The STATE.md Drift Items table confirms:
- `FORK-OPS-BACKFILL-DESTRUCTIVE` → IN-PROGRESS — S-FORK-OPS-BACKFILL-1
- `FORK-OPS-GITLEAKS-DOC` → IN-PROGRESS — S-FORK-OPS-GITLEAKS-DOC-1
- `FORK-OPS-BACKFILL-WIN-TARGET` → IN-PROGRESS — S-FORK-OPS-BACKFILL-1

### Convention Drift (PASS)
Naming taxonomy is consistent with prior fork-ops cycles. The GITLEAKS-DOC drift item
follows the `FORK-OPS-*` naming convention; the prd-delta's `spec_version_bump: PATCH`
follows the S-FORK-OPS-SIGN-1 precedent; the zero-new-BCs rationale mirrors the
S-FORK-OPS-SIGN-1 prd-delta language. No taxonomy inconsistencies detected.

### Architecture-Delta Regression Baseline (PASS)
architecture-delta declares all `.factory/architecture/` documents UNCHANGED and
lists a regression baseline table of six documents. This is consistent with
spec-delta's "Files NOT Changed" section, which also excludes all architecture files.

---

## Verdict

**INCONSISTENT (3 findings)**

| Finding | Severity | Blocking for F3? |
|---------|----------|-----------------|
| F1: BC count 598 vs actual 599 in prd-delta + spec-changelog | MAJOR | Recommended fix before F3 dispatch to avoid downstream count confusion |
| F2: Backfill-matrix-parity test Optional vs REQUIRED contradiction | MAJOR | YES — if not fixed, F3 story-writer may omit a mandatory acceptance criterion |
| F3: Story IDs not yet registered in STORY-INDEX | MINOR | No (expected state at F2; F3 will register them) |

**Recommended action before F3 dispatch:**
1. Fix F1 (two-line correction in prd-delta and spec-changelog [1.3.24]: 598 → 599).
2. Fix F2 (one-line correction in prd-delta: Optional → REQUIRED with cross-reference
   to verification-delta).
3. Accept F3 as-is; add a clarifying note in STATE.md Step 3 if desired.

Fixes F1 and F2 are both edits to the prd-delta and spec-changelog only. They require
no changes to the spec-delta, architecture-delta, or verification-delta, and they do
not affect the BC count, NFR count, or story decomposition.

---

## RESOLUTION (2026-06-18 — state-manager, post-human-approval)

**F1 — FIXED.** `prd-delta-fork-ops-backfill-1.md` and `spec-changelog.md` [1.3.24]
updated: all `total_bcs 598` occurrences replaced with `total_bcs 599`.
Verified: `check-bc-cumulative-counts.sh` exits 0; BC-INDEX.md, CANONICAL-COUNTS.md,
STATE.md, and the two F2 documents all agree on count 599.

**F2 — FIXED.** `prd-delta-fork-ops-backfill-1.md` Story 1 section updated:
`Optional: add a backfill-matrix-parity test …` replaced with
`Add tests/backfill_matrix_parity.rs … REQUIRED Story-1 acceptance criterion`.
Contradiction between prd-delta (Optional) and verification-delta (REQUIRED) resolved.

**F3 — RESOLVED.** STATE.md RESUME PLAN Step 3 reworded: the instruction to
"Confirm story files … exist or create them at F2" changed to "create them during
F3 — story files are registered at F3, not F2." Cold-start orchestrator will no
longer halt at F2 looking for story files that do not yet exist.

**Final audit verdict: ALL 3 FINDINGS RESOLVED. Consistency gate PASSED.
F2 human-approved 2026-06-18. Bundle proceeds to F3.**
