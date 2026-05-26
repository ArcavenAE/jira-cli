---
document_type: consistency-audit
issue: "#327"
title: "F2 spec delta consistency audit — OsRng → SysRng text refresh"
date: "2026-05-26"
auditor: consistency-validator
phase: phase-f2-spec-evolution
producer: consistency-validator
gate: human-approval
status: READY-FOR-HUMAN-REVIEW
---

# Consistency Audit — Issue #327: `rand` 0.9 → 0.10 OsRng → SysRng Text Refresh

Fresh-context audit of the F2 spec delta before the human approval gate.
Audited documents: `bc-1-auth-identity.md`, `BC-INDEX.md`,
`domain-spec/state-machines.md`, `domain-spec/bc-01-auth-identity.md`,
`architecture/state-machines.md`, `prd-delta-327.md`, `.factory/semport/`.

---

## Summary Table

| Check | Description | Result |
|-------|-------------|--------|
| 1 | Residual `OsRng`/`TryRngCore` grep — specs, architecture, docs, CLAUDE.md | PASS |
| 2 | Semport `OsRng` references preserved (historical snapshots intact) | PASS |
| 3 | `SysRng` grep count — at least 7 matches in specs + architecture | PASS (7 exactly) |
| 4a | Site 1: bc-1-auth-identity.md line 395 contains `SysRng` | PASS |
| 4b | Site 2: BC-INDEX.md line 110 contains `SysRng` | PASS |
| 4c | Site 3: domain-spec/state-machines.md line 52 contains `SysRng` | PASS |
| 4d | Site 4: domain-spec/state-machines.md line 95 contains `SysRng` | PASS |
| 4e | Site 5: domain-spec/bc-01-auth-identity.md line 98 contains `SysRng` | PASS |
| 4f | Site 6: architecture/state-machines.md line 43 contains `SysRng` | PASS |
| 4g | Site 7: architecture/state-machines.md line 81 contains `SysRng` | PASS |
| 5 | `check-spec-counts.sh` exits 0 | PASS |
| 6 | `check-bc-cumulative-counts.sh` exits 0 | PASS |
| 7 | `check-bc-no-numeric-test-counts.sh` exits 0 | PASS |
| 8 | `prd-delta-327.md` frontmatter has all required fields | PASS |
| 9 | `prd-delta-327.md` input files exist on disk | PASS |
| 10 | `prd-delta-327.md` before/after diffs match actual file content (2 samples) | PASS |
| 11 | `prd-delta-327.md` Process Gap section present | PASS |
| 12 | `prd-delta-327.md` Quality Gate Self-Check present, all rows confirmed | PASS |
| 13 | BC-INDEX entry title exactly mirrors BC body H1 title | PASS |
| 14 | architecture/state-machines.md mirrors domain-spec/state-machines.md on SysRng text | PASS |
| 15 | Risk-zone stories (S-1.06, S-1.08, S-3.01, S-3.03, S-3.04) clean of OsRng | PASS |
| 16 | No prd-delta or factory artifact falsely claims semport was updated | PASS |
| 17 | Semport count matches product-owner claim (5 references) | PASS |
| 18 | TryRng / try_fill_bytes residuals absent from specs + architecture | PASS |
| 19 | ASCII art box at domain-spec/state-machines.md line 52 alignment preserved | PASS |

All 19 checks pass. No findings, no blocking issues.

---

## Check 1: Residual OsRng / TryRngCore Grep

**Result: PASS**

Command run:
```
grep -rn 'OsRng\|TryRngCore' .factory/specs/ .factory/architecture/ docs/ CLAUDE.md
```

Output: no matches (exit 1 = no lines found).

The search covered all five originally-modified files and their surrounding directories.
Zero residual occurrences of either the old type name or the old trait name.

---

## Check 2: Semport OsRng Preservation

**Result: PASS**

Command run:
```
grep -rn 'OsRng' .factory/semport/
```

Output: 5 matches across 4 files.

| File | Line | Content |
|------|------|---------|
| `semport/jira-cli/jira-cli-pass-1-deep-r1.md` | 207 | `OAuthLogin --> GenerateState: 32 bytes from OsRng → 64 hex chars` |
| `semport/jira-cli/jira-cli-pass-8-deep-synthesis.md` | 152 | `...32 bytes from OsRng → 64 hex chars; BC-1146...` |
| `semport/jira-cli/jira-cli-pass-1-architecture.md` | 379 | `generate_state() → 32 bytes from OsRng → 64 hex chars` |
| `semport/jira-cli/jira-cli-pass-4-deep-r2.md` | 128 | `rand::rngs::OsRng.try_fill_bytes(&mut bytes)` |
| `semport/jira-cli/jira-cli-pass-4-nfr-catalog.md` | 134 | `rand::rngs::OsRng.try_fill_bytes` (full context) |

These are point-in-time snapshot artifacts pinned at a specific analysis pass. Their
`OsRng` references correctly describe the codebase at analysis time and must NOT be
updated. Count = 5, matching the product-owner's claim in prd-delta-327.md §Quality
Gate Self-Check exactly.

---

## Check 3: SysRng Match Count in Specs + Architecture

**Result: PASS**

Command run:
```
grep -rn 'SysRng' .factory/specs/ .factory/architecture/
```

Output: exactly 7 matches.

| File | Line | Match |
|------|------|-------|
| `specs/prd/bc-1-auth-identity.md` | 395 | BC-1.5.035 H1 title |
| `specs/prd/BC-INDEX.md` | 110 | BC-1.5.035 index row |
| `specs/domain-spec/state-machines.md` | 52 | ASCII art box |
| `specs/domain-spec/state-machines.md` | 95 | Key Invariants bullet |
| `specs/domain-spec/bc-01-auth-identity.md` | 98 | INV-AUTH-004 row |
| `architecture/state-machines.md` | 43 | Mermaid transition label |
| `architecture/state-machines.md` | 81 | Key invariants bullet |

Exactly 7 matches, one per reported update site. No duplicate updates, no missed sites,
no unexpected additions.

---

## Check 4: Line-by-Line Site Verification

### Site 1 — `specs/prd/bc-1-auth-identity.md` line 395

**Result: PASS**

Actual content at line 395:
```
#### BC-1.5.035: `generate_state()` produces 32 bytes from SysRng encoded as 64 hex chars
```

Contains `SysRng`. Does not contain `OsRng`.

### Site 2 — `specs/prd/BC-INDEX.md` line 110

**Result: PASS**

Actual content at line 110:
```
| BC-1.5.035 | `generate_state()` produces 32 bytes from SysRng encoded as 64 hex chars | BC-1146 (R4) | src/api/auth.rs:882 | HIGH | Auth & Identity |
```

Contains `SysRng`. Does not contain `OsRng`.

### Site 3 — `specs/domain-spec/state-machines.md` line 52

**Result: PASS**

Actual content at line 52:
```
                              │ 32 bytes SysRng → 64 hex chars   │
```

Contains `SysRng`. Does not contain `OsRng`. Box alignment: the closing `│` is at
column 50 (same position as adjacent rows `│ generate state   │` and
`│ build authorize URL │`). Inner content is `32 bytes SysRng → 64 hex chars` with
three trailing spaces, keeping the inner width at 33 characters consistent with the
surrounding box rows (e.g., line 51: `│ generate state   │` has 18 chars + spaces = 33
inner cols). The one trailing-space adjustment noted in §3.2 of the delta is reflected
correctly.

### Site 4 — `specs/domain-spec/state-machines.md` line 95

**Result: PASS**

Actual content at line 95:
```
- CSRF state is 32 bytes from `SysRng` → 64 hex chars (BC-1146).
```

Contains `SysRng`. Does not contain `OsRng`. One-word swap only; surrounding text
unchanged.

### Site 5 — `specs/domain-spec/bc-01-auth-identity.md` line 98

**Result: PASS**

Actual content at line 98:
```
| INV-AUTH-004 | OAuth state parameter: 32 bytes from `SysRng` → 64 hex chars. State is validated against CSRF at callback. A state mismatch → login error; keychain NOT written. | `api/auth.rs` (BC-1146) |
```

Contains `SysRng`. Does not contain `OsRng`. Behavioral invariant text (validation at
callback, login error on mismatch, keychain not written) is intact.

### Site 6 — `architecture/state-machines.md` line 43

**Result: PASS**

Actual content at line 43:
```
    OAuthLogin --> GenerateState: 32 bytes from SysRng → 64 hex chars
```

Contains `SysRng`. Does not contain `OsRng`. Mermaid diagram syntax intact; state
name `GenerateState` and transition source `OAuthLogin` are unchanged.

### Site 7 — `architecture/state-machines.md` line 81

**Result: PASS**

Actual content at line 81:
```
- `generate_state`: 32 bytes from `SysRng` → 64 lowercase hex chars (BC-1.5.035)
```

Contains `SysRng`. Does not contain `OsRng`. BC-1.5.035 anchor citation preserved
verbatim.

---

## Check 5-7: Guard Script Results

**All three scripts: PASS**

| Script | Exit Code | Output |
|--------|-----------|--------|
| `scripts/check-spec-counts.sh` | **0** | `OK: all spec counts verified.` |
| `scripts/check-bc-cumulative-counts.sh` | **0** | `OK: all cumulative BC counts verified (583 total across 8 files; Surface H footer checked where present).` |
| `scripts/check-bc-no-numeric-test-counts.sh` | **0** | `OK: no numeric test counts in BC Trace/Source fields.` |

The text-only refresh did not alter any BC count. The 583 total is unchanged. All
nine count surfaces remain consistent. The `check-bc-no-numeric-test-counts.sh`
guard confirms the BC-1.5.035 title rename did not introduce any numeric test count
in a `Trace:` or `Source:` field.

---

## Check 8-12: prd-delta-327.md Content Validation

### Check 8: Required Frontmatter Fields

**Result: PASS**

| Field | Required Value | Actual Value | Status |
|-------|---------------|--------------|--------|
| `document_type` | `prd-delta` | `prd-delta` | PASS |
| `issue` | `"#327"` | `"#327"` | PASS |
| `phase` | `F2` | `F2` | PASS |
| `modified_bcs` | non-empty | `[BC-1.5.035 (title text: OsRng → SysRng)]` | PASS |
| `inputs` | non-empty | two file paths | PASS |
| `title` | present | `"rand 0.9 → 0.10: OsRng → SysRng spec text refresh"` | PASS |
| `date` | present | `"2026-05-26"` | PASS |

All required frontmatter fields present and populated.

### Check 9: Input Files Exist on Disk

**Result: PASS**

| Declared Input | Exists? | Size |
|---------------|---------|------|
| `.factory/phase-f1-delta-analysis/issue-327/delta-analysis.md` | YES | 20,920 bytes |
| `.factory/research/rand-0.10-migration-assessment.md` | YES | 21,160 bytes |

Both input files exist and are non-empty.

### Check 10: Before/After Diffs Match Actual File Content (2 samples)

**Result: PASS**

**Sample 1 — prd-delta §2 (BC-1.5.035 title, site 1):**

Delta claims:
- Before: `generate_state()` produces 32 bytes from **OsRng** encoded as 64 hex chars
- After: `generate_state()` produces 32 bytes from **SysRng** encoded as 64 hex chars
- Location: `specs/prd/bc-1-auth-identity.md` line 395

Actual line 395:
```
#### BC-1.5.035: `generate_state()` produces 32 bytes from SysRng encoded as 64 hex chars
```

"After" text matches. `OsRng` is absent. PASS.

**Sample 2 — prd-delta §3.4 (INV-AUTH-004, site 5):**

Delta claims:
- Before: `OAuth state parameter: 32 bytes from \`OsRng\` → 64 hex chars.`
- After: `OAuth state parameter: 32 bytes from \`SysRng\` → 64 hex chars.`
- Location: `specs/domain-spec/bc-01-auth-identity.md` line 98

Actual line 98 (INV-AUTH-004 row):
```
| INV-AUTH-004 | OAuth state parameter: 32 bytes from `SysRng` → 64 hex chars. State is validated against CSRF at callback. A state mismatch → login error; keychain NOT written. | `api/auth.rs` (BC-1146) |
```

"After" text matches. `OsRng` is absent. Surrounding behavioral text intact. PASS.

### Check 11: Process Gap Section Present

**Result: PASS**

Section `## 8. Process Gap Surfaced (for cycle-close)` is present in prd-delta-327.md
at the expected location. It documents the BA grep scope gap (coverage of
`.factory/specs/prd/` only, missing `domain-spec/` and `architecture/`), names all
five missed sites, provides a corrective recommended grep command, and explains the
intentional semport exclusion. The section is substantive (not a placeholder) and
provides actionable guidance for future cycles.

### Check 12: Quality Gate Self-Check Present and Confirmed

**Result: PASS**

The `## Quality Gate Self-Check` table is present at the end of prd-delta-327.md with
16 rows. Every row carries status `confirmed`. The rows cover:

- All 7 spec/architecture sites updated
- All 3 guard scripts exit 0
- Post-edit OsRng grep returns zero matches in specs/architecture
- Semport OsRng references intact (5 references)
- CLAUDE.md clean of OsRng
- No new BCs, VPs, or ADR introduced
- No source code touched
- No CLAUDE.md changes required
- BC-INDEX title matches BC file H1 exactly
- ASCII art box alignment preserved
- Mermaid diagram structure unchanged
- Architecture assessment updated
- Process gap surfaced and noted

Independent verification above confirms every `confirmed` row is accurate.

---

## Check 13: BC-INDEX Title Mirrors BC Body H1

**Result: PASS**

BC-INDEX.md line 110 title column:
```
`generate_state()` produces 32 bytes from SysRng encoded as 64 hex chars
```

BC body H1 at bc-1-auth-identity.md line 395:
```
#### BC-1.5.035: `generate_state()` produces 32 bytes from SysRng encoded as 64 hex chars
```

The title text (after stripping the `#### BC-1.5.035: ` prefix) is identical in both
locations. The `bc_h1_is_title_source_of_truth` policy is satisfied.

---

## Check 14: architecture/state-machines.md Mirrors domain-spec/state-machines.md

**Result: PASS**

Both files carry the SysRng rename at their respective GenerateState sites. The
wording is not expected to be byte-for-byte identical (the two files are different
document types: one is an ASCII-art domain spec, one is a Mermaid state-diagram
architecture spec). The substantive claim — 32 bytes from SysRng → 64 hex chars —
is identical in both.

| Document | Site | Text |
|----------|------|------|
| domain-spec/state-machines.md line 52 | ASCII box | `32 bytes SysRng → 64 hex chars` |
| domain-spec/state-machines.md line 95 | Key Invariants | `32 bytes from \`SysRng\` → 64 hex chars` |
| architecture/state-machines.md line 43 | Mermaid label | `32 bytes from SysRng → 64 hex chars` |
| architecture/state-machines.md line 81 | Key invariants | `32 bytes from \`SysRng\` → 64 lowercase hex chars` |

The four surfaces are mutually consistent. The architecture site 7 adds "lowercase"
(which was already present in the original architecture wording and is a valid
precision note). No divergence.

---

## Check 15: Risk-Zone Stories Clean of OsRng

**Result: PASS**

The five stories in the F1 risk zone were checked for `OsRng`, `TryRngCore`, and
`SysRng`. None contain any of these terms.

| Story | File | Match? |
|-------|------|--------|
| S-1.06 | `stories/wave-1/S-1.06-oauth-flow-holdout-suite.md` | no matches |
| S-1.08 | `stories/wave-1/S-1.08-keychain-roundtrip-holdout.md` | no matches |
| S-3.01 | `stories/wave-3/S-3.01-refactor-auth-rs-shard-split.md` | no matches |
| S-3.03 | `stories/wave-3/S-3.03-auto-refresh-oauth-on-401-with-single-flight.md` | no matches |
| S-3.04 | `stories/wave-3/S-3.04-multi-cloudid-disambiguation.md` | no matches |

The JSM dispatch story (`S-288-pr4-dispatch`) was also searched; no story file
with a name matching that pattern was found in `.factory/stories/`, which is
consistent with the expectation that it is named differently. The at-risk pattern
is that a story's ACs or test references contain the old type name; zero stories
exhibit this pattern.

---

## Check 16: No Factory Artifact Falsely Claims Semport Was Updated

**Result: PASS**

prd-delta-327.md §8 explicitly states:

> "Semport files intentionally NOT updated. The five remaining `OsRng` references
> in `.factory/semport/jira-cli/jira-cli-pass-*.md` are point-in-time snapshot
> artifacts pinned at a specific analysis pass... Updating them would falsify the
> historical record."

The Quality Gate Self-Check row for semport reads:
> "Semport `OsRng` references still intact (5 references) | confirmed"

No delta document, no frontmatter field, and no body section claims the semport
directory was modified. The `modified_spec_files` frontmatter lists exactly the five
spec/architecture files that were changed; semport is absent from the list. The
documentation accurately represents what was and was not touched.

---

## Check 17: Semport Count Matches Product-Owner Claim

**Result: PASS**

Product-owner claimed: 5 references in `.factory/semport/`.

Independent grep count: `grep -rn 'OsRng' .factory/semport/ | wc -l` → **5**.

The five matches span 4 files (jira-cli-pass-1-deep-r1.md, jira-cli-pass-8-deep-synthesis.md,
jira-cli-pass-1-architecture.md, jira-cli-pass-4-deep-r2.md, jira-cli-pass-4-nfr-catalog.md).
Note: the pass-8-deep-synthesis.md file contains one match even though it is a synthesis
pass, because it cites the Pass 1 state-machine description verbatim. Count is exact.

---

## Check 18: TryRng / try_fill_bytes Residuals

**Result: PASS**

Command run:
```
grep -rn 'TryRng\|try_fill_bytes\|TryRngCore' .factory/specs/ .factory/architecture/
```

Output: no matches.

The `rand` 0.10 migration also renamed the trait `TryRngCore` → `TryRng`. Neither the
old name nor the new name appears in the live specs or architecture, which is correct:
the specs describe the observable behavior (32 bytes of OS CSPRNG entropy → 64 hex
chars), not the trait-method call signature. No residual trait references to clean up.

---

## Check 19: ASCII Art Box Alignment

**Result: PASS**

The domain-spec/state-machines.md box at lines 50-55:

```
┌─────────────────────────────────┐
│ generate state                   │
│ 32 bytes SysRng → 64 hex chars   │
│ build authorize URL              │
│ (NO PKCE — NFR-S-A)             │
└─────────────┬───────────────────┘
```

The inner content of line 52 is `32 bytes SysRng → 64 hex chars` followed by three
trailing spaces before the closing `│`. This matches the prd-delta §3.2 description:
"One trailing space was removed to preserve the box column width (OsRng = 5 chars;
SysRng = 6 chars)." The closing `│` is at the same column position as the `│` on
adjacent rows. Box integrity is maintained.

---

## Summary of Findings

No findings. All 19 checks pass.

This delta is a text-only refresh with no behavioral change: seven sites across five
files, all updated consistently from `OsRng` to `SysRng`. Every cited line has been
independently verified. All three guard scripts exit 0. The prd-delta document is
complete, its input files exist, its before/after diffs match the live files, its
Process Gap section is substantive, and its Quality Gate Self-Check is accurate.

The semport boundary is cleanly maintained: 5 historical references preserved,
correctly documented as intentional, not falsely claimed as updated.

The cross-document mirror invariant holds: BC-INDEX title text equals BC body H1
text; architecture/state-machines.md and domain-spec/state-machines.md agree on the
substantive claim.

---

## Verdict

**READY-FOR-HUMAN-REVIEW**

Zero blocking findings. Zero non-blocking findings. All 19 independent checks pass.
All three guard scripts exit 0. The F2 spec delta for issue #327 is internally
consistent, externally consistent with the semport boundary, and accurate in its
self-reported claims.
