---
document_type: spec-change-record
governing_decision: DEC-082
research_source: ".factory/research/windows-build-f4-preflight-verification.md"
date: 2026-06-13
produced_by: spec-steward
spec_version: "1.3.11"
prior_spec_version: "1.3.10"
bc_delta: 0
nfr_delta: 0
adr_delta: 0
story_delta: 0
---

# Spec Change Record — DEC-082 (Pre-F4 External-Claim Verification Corrections)

## Governing Decision

**DEC-082** (2026-06-13) — recorded in `.factory/STATE.md` Decisions Log.

Pre-F4 external-claim verification by research-agent using primary sources (keyring 3.6.3
Cargo.toml, actions/runner-images Windows manifests, MSYS2 package index, reqwest 0.13.0
Cargo.toml). Two BLOCKER findings (C-V2b, C-V3) refuted factually incorrect F3-converged
spec text. Both corrections were propagated to all affected artifacts before F4 began.

## Research Claims

| Claim | Verdict | Correction Required |
|-------|---------|---------------------|
| C-V2(b): windows-sys version covered by existing deny.toml skips | REFUTED | YES — windows-sys 0.60 skip REQUIRED (not 0.61 as F3 spec assumed) |
| C-V3: Unix `zip` available on `windows-latest` runners | REFUTED | YES — Compress-Archive (pwsh) must be primary; `zip` not on PATH |
| C-V5: TLS backend on Windows (aws-lc-rs not ring) | CONFIRMED (note) | NO — inoculation note added to ADR-0016 Decision 1 |

Primary source: `.factory/research/windows-build-f4-preflight-verification.md`

---

## Artifact Change Log

### 1. ADR-0016 — Windows Build Target

**File:** `.factory/architecture/adr/0016-windows-build-target.md`

| Field | Before | After | Governance type |
|-------|--------|-------|----------------|
| `date:` (frontmatter) | `2026-06-12` | `2026-06-13` | Date — reflects DEC-082 amendment effective date |
| Decision 2 body | F-WIN-F3-003 amendment block (Git Bash zip primary) | C-V3 re-amendment superseding block (Compress-Archive/pwsh primary) | Content change by architect — governance confirms date updated |
| Decision 5b body | "may need a [[bans.skip]] — verify at F4" | "REQUIRED — windows-sys 0.60 skip mandatory, not conditional" | Content change by architect — governance confirms date updated |
| Decision 1 body | No TLS backend note | C-V5 inoculation note added (aws-lc-rs, not ring) | Content change by architect |
| `status:` line | Accepted (amended 2026-06-13 F-WIN-F3-001 + F-WIN-F3-003) | Accepted (amended F-WIN-F3-001 + F-WIN-F3-003 superseded by C-V3 + C-V2(b)) | Content — adr-index carries full annotation chain |

**Version convention for ADRs in this repo:** ADRs do not carry a `version:` semver
frontmatter field (per repo convention — only STORY-INDEX and spec-changelog track version
numbers). Amendment chain is tracked inline (strikethrough superseded text) and in the
ADR summary table in adr-index.md. Governance metadata: `date:` field updated to amendment
effective date (2026-06-13). No `version:` field exists to bump — this is correct per
convention.

---

### 2. adr-index.md — ADR Registry

**File:** `.factory/architecture/adr-index.md`

| Field | Before | After | Governance type |
|-------|--------|-------|----------------|
| ADR-0016 status-line annotation | "amended 2026-06-13 F-WIN-F3-001 … F-WIN-F3-003" | "amended F-WIN-F3-001; F-WIN-F3-003 superseded same day by C-V3 re-amendment; C-V2(b) deny.toml 0.60 skip REQUIRED" | Content change by architect — full amendment chain recorded |

No frontmatter version or date field in adr-index.md per repo convention. Governance
confirms the ADR-0016 row carries the complete and correct amendment chain.

---

### 3. architecture-delta.md — Windows-Build Cycle Architecture Delta

**File:** `.factory/cycles/cycle-001/windows-build/architecture-delta.md`

| Field | Before | After | Governance type |
|-------|--------|-------|----------------|
| `date:` (frontmatter) | `2026-06-12` | `2026-06-13` | Date — reflects DEC-082 amendment effective date |
| §3.3 (Packaging) body | "Git Bash zip primary" | "Compress-Archive (pwsh) primary; zip NOT available" via strikethrough+correction block | Content change by architect |
| §5.3 (deny.toml) body | "run cargo deny check; add skip if needed" | Strikethrough + C-V2(b) correction block: windows-sys 0.60 skip REQUIRED | Content change by architect |
| R-W1 risk record | "may need skip" wording | "REQUIRED (C-V2b research-confirmed); not conditional" | Content change by architect |

**Version convention for architecture-delta:** This artifact uses `date:` (not semver
`version:`) per repo convention. No `version:` field exists to bump. Governance metadata:
`date:` updated to 2026-06-13 (amendment effective date). Correct per convention.

---

### 4. S-WIN-3 — Keyring windows-native Feature Story

**File:** `.factory/stories/S-WIN-3-keyring-windows-native-feature.md`

| Field | Before | After | Governance type |
|-------|--------|-------|----------------|
| `last_updated:` | `"2026-06-13"` | `"2026-06-13"` | Already correct (story-writer set this on amendment) |
| `files_modified:` / deny.toml comment | "may need skip" | "REQUIRED: add [[bans.skip]] for windows-sys 0.60" | Content change by story-writer |
| AC-002 body | Conditional skip | Mandatory skip with exact entry and reason string | Content change by story-writer |
| EC-001 | Optional deny.toml | REQUIRED change via C-V2(b) research finding | Content change by story-writer |
| AC test assertions | 1 test | 2 tests (AC-001 Cargo.toml + AC-002 deny.toml) | Content change by story-writer |

**Traceability:** `last_updated: "2026-06-13"` is correct and was set by the story-writer
during DEC-082 propagation. No further date change needed. Research citation is present:
`C-V2(b)` cited in AC-002, EC-001, architecture compliance rules, and library requirements.

---

### 5. S-WIN-4 — release.yml Windows Build Story

**File:** `.factory/stories/S-WIN-4-release-yml-windows-target.md`

| Field | Before | After | Governance type |
|-------|--------|-------|----------------|
| `last_updated:` | `"2026-06-13"` | `"2026-06-13"` | Already correct |
| `files_modified:` comment | "Package (Windows) bash/zip step" | "Package (Windows) pwsh/Compress-Archive new step, Checksum (Windows) bash/sha256sum new step" | Content change by story-writer |
| Architecture compliance rule (packaging) | Git Bash zip primary | Compress-Archive (pwsh) primary; zip NOT on PATH — C-V3 BLOCKER | Content change by story-writer |
| Library requirements | `zip` (Git Bash) as primary | `Compress-Archive` primary; `zip` strike-through with DO NOT USE warning | Content change by story-writer |
| AC-002 body | Zip primary | Compress-Archive mandatory; NOT zip | Content change by story-writer |
| Step 4a/4b YAML | Single bash+zip step | Two steps: pwsh Compress-Archive + separate bash sha256sum | Content change by story-writer |

**Traceability:** `last_updated: "2026-06-13"` is correct. Research citation `C-V3` present
in architecture compliance rule, library requirements, and step rationale.

---

### 6. S-WIN-6 — Windows Docs Fallout Story

**File:** `.factory/stories/S-WIN-6-windows-docs-fallout.md`

| Field | Before | After | Governance type |
|-------|--------|-------|----------------|
| `last_updated:` | `"2026-06-12"` | `"2026-06-13"` | GOVERNANCE CHANGE — date updated to reflect DEC-082 amendment |
| AC-005 body | Exact match on amendment-annotation text | Genericized: verify row exists; do NOT overwrite regardless of annotation text | Content change by story-writer (prevents future stale-annotation failures) |

**Note on AC-005 change:** The original AC-005 referenced exact amendment-annotation text
from a specific point in time. DEC-082 added another amendment annotation (C-V3, C-V2b),
making the exact-text assertion stale immediately. The story-writer genericized AC-005 to
a substring check (ADR-0016 row exists with Accepted status; any annotation text passes).
This is a correct and necessary change. `last_updated:` bumped from 2026-06-12 to
2026-06-13 by spec-steward (governance metadata — was not bumped by story-writer).

---

### 7. STORY-INDEX.md

**File:** `.factory/stories/STORY-INDEX.md`

| Field | Before | After | Governance type |
|-------|--------|-------|----------------|
| `version:` | `"1.4.37"` (implied pre-DEC-082) | `"1.4.38"` | Bumped by story-writer during DEC-082 propagation |
| `last_updated:` | Previous F3 convergence timestamp | `2026-06-13 (Windows-build F3 … Pre-F4 BLOCKER corrections applied: S-WIN-3 deny.toml … REQUIRED … C-V2b; S-WIN-4 Package (Windows) step replaced … C-V3)` | Updated by story-writer |

**Version assessment:** STORY-INDEX version `1.4.38` is the correct post-DEC-082 value.
The story-writer bumped from `1.4.37` to `1.4.38` (PATCH increment per the existing
convention of incrementing the patch digit for corrections that do not add new stories).
Count `total_stories: 74` is unchanged and correct.

---

### 8. spec-changelog.md

**File:** `.factory/spec-changelog.md`

| Field | Before | After | Governance type |
|-------|--------|-------|----------------|
| Latest version | `[1.3.10]` (2026-06-11) | `[1.3.11]` (2026-06-13) | GOVERNANCE CHANGE — spec-steward added DEC-082 entry |

**Version rationale:** PATCH increment (0.0.X). Clarifications and corrections to spec
artifacts with no BC/NFR body changes (BC 597 / NFR 42 unchanged). Per this project's
semver for specs: MAJOR = removed/semantically-changed requirements; MINOR = new
requirements; PATCH = clarifications and corrections. DEC-082 falls into PATCH.

---

## Count and Version Consistency Check

| Surface | Value | Status |
|---------|-------|--------|
| BC corpus (BC-INDEX.md total_bcs) | 597 | UNCHANGED — no BC modified |
| NFR corpus (nfr-catalog.md) | 42 | UNCHANGED — no NFR modified |
| ADR count (adr-index.md rows) | 16 | UNCHANGED — ADR-0016 amended in place, not added |
| STORY-INDEX total_stories | 74 | UNCHANGED — no story added or removed |
| STORY-INDEX version | 1.4.38 | Correct (bumped by story-writer for DEC-082 corrections) |
| spec-changelog latest | 1.3.11 | Correct (PATCH bump added by spec-steward) |
| STATE.md DEC-082 entry | Present | Correct — full governing-decision record in decisions log |

**BC 597 unchanged (no BC modified):** Confirmed. DEC-082 corrections touched ADR, architecture
delta, and story files only. No BC body in `.factory/specs/prd/bc-*.md` was modified.

**ADR 16 unchanged (ADR-0016 amended in place):** Confirmed. The adr-index.md row count
is 16 (ADR-0001 through ADR-0016). No new ADR was added; ADR-0016 was amended. The
count is correct.

**total_stories 74 unchanged:** Confirmed. S-WIN-1..6 were added during F3 (68→74); DEC-082
did not add or remove any story. The count is correct and consistent with the STORY-INDEX
manifest.

---

## Traceability Chain

```
Research source (primary-source verification)
  → .factory/research/windows-build-f4-preflight-verification.md
      → Claim C-V2(b): keyring windows-native pulls windows-sys 0.60
      → Claim C-V3: zip NOT on windows-latest PATH; Compress-Archive is available
      → Claim C-V5: aws-lc-rs backend confirmed (note, no correction needed)

DEC-082 (governing decision)
  → STATE.md decisions log (2026-06-13)
  → STATE.md phase progress row (Windows-build, DEC-079/080/081/082)
  → STATE.md current_step (DEC-082 research complete)

ADR-0016 amendments (architect)
  → Decision 2: C-V3 re-amendment supersedes F-WIN-F3-003
  → Decision 5b: C-V2(b) amendment — deny skip REQUIRED
  → Decision 1: C-V5 inoculation note (confirmed, no correction)
  → adr-index.md: amendment chain annotation on ADR-0016 row

architecture-delta.md corrections (architect)
  → §3.3: Compress-Archive packaging (C-V3)
  → §5.3: windows-sys 0.60 deny skip REQUIRED (C-V2b)
  → R-W1: risk record corrected (not conditional)

Story amendments (story-writer)
  → S-WIN-3: AC-002 / EC-001 / files_modified → deny.toml REQUIRED (C-V2b)
  → S-WIN-4: AC-002 / packaging steps → Compress-Archive/pwsh (C-V3)
  → S-WIN-6: AC-005 genericized (stale exact-annotation text removed)

STORY-INDEX v1.4.38 (story-writer bump)
  → last_updated prose names both DEC-082 corrections

spec-changelog v1.3.11 (spec-steward PATCH entry — this document)
  → links to DEC-082, research source, all corrected artifacts

spec-change-record-DEC-082.md (this file — spec-steward)
  → per-artifact change log with old→new metadata
```

---

## Required Follow-Up Gate Actions

The orchestrator must ensure the following occur before S-WIN-3 and S-WIN-4 enter F4
implementation:

1. **F5 adversarial re-review (scoped):** Adversarial agent reviews the DEC-082 correction
   set (ADR-0016 Decision 2 + Decision 5b + S-WIN-3 AC-002 + S-WIN-4 AC-002) for internal
   consistency and any residual leaks of the superseded assumptions (windows-sys 0.61
   language or `zip` references).

2. **F7 delta convergence re-gate:** Consistency audit of the corrected artifacts across
   the five standard dimensions (counts, links, prose, dates, source citations) before
   S-WIN-3 implementation begins.

3. **S-WIN-3 F4 obligation:** `[[bans.skip]]` for windows-sys 0.60 MUST be in the same
   commit as enabling `windows-native` in Cargo.toml. AC-002 and the release-gate CI step
   (`cargo deny check`) both enforce this. The implementer MUST NOT treat the skip as
   optional.

4. **S-WIN-4 F4 obligation:** Package (Windows) step MUST use `shell: pwsh` with
   `Compress-Archive`. A bash step using `zip` will fail on `windows-latest` with
   `command not found`. AC-002 enforces this; the implementer must reference the two-step
   YAML in the story's File Structure Requirements.

---

*Produced by: spec-steward | Governing decision: DEC-082 | Spec version: 1.3.10 → 1.3.11*
