---
document_type: prd-delta
issue: "#327"
title: "rand 0.9 → 0.10: OsRng → SysRng spec text refresh"
date: "2026-05-26"
phase: F2
spec_version_bump: "no count change (text-only refresh)"
new_bcs: []
modified_bcs:
  - BC-1.5.035 (title text: OsRng → SysRng)
modified_spec_files:
  - .factory/specs/prd/bc-1-auth-identity.md (BC-1.5.035 title)
  - .factory/specs/prd/BC-INDEX.md (BC-1.5.035 row title)
  - .factory/specs/domain-spec/state-machines.md (ASCII art line 52; Key Invariants line 95)
  - .factory/specs/domain-spec/bc-01-auth-identity.md (INV-AUTH-004 row)
  - .factory/architecture/state-machines.md (Mermaid label line 43; Key invariants line 81)
inputs:
  - .factory/phase-f1-delta-analysis/issue-327/delta-analysis.md
  - .factory/research/rand-0.10-migration-assessment.md
---

# PRD Delta — Issue #327: `rand` 0.9 → 0.10: OsRng → SysRng Spec Text Refresh

## 1. Summary of Change

`rand` 0.10 renamed `rand::rngs::OsRng` to `rand::rngs::SysRng` (and the trait
`TryRngCore` to `TryRng`). The behavioral contract is entirely unchanged: both names
refer to the same zero-sized struct delegating to `getrandom(2)` / `BCryptGenRandom`,
producing the same 32 bytes of OS CSPRNG entropy rendered as 64 hex characters for
OAuth CSRF state.

This delta refreshes **seven spec-text sites** across five files that carried the old
type name `OsRng` so that the specs reflect forward-looking `rand` 0.10 terminology.
No behavioral claim is altered. No BC is added or removed. The F2 decision ratified by
the human gate is: clean forward-looking text (`SysRng`) with no historical
parenthetical.

---

## 2. Modified BCs

| BC ID | File | Before | After | Disposition |
|-------|------|--------|-------|-------------|
| BC-1.5.035 | `.factory/specs/prd/bc-1-auth-identity.md` line 395 | `generate_state()` produces 32 bytes from **OsRng** encoded as 64 hex chars | `generate_state()` produces 32 bytes from **SysRng** encoded as 64 hex chars | `modified` (title text only; behavioral claim — 32 bytes, 64 hex chars, OS CSPRNG — is unchanged) |

**Semantics are fully preserved.** The rename is an implementation-type label change.
`OsRng` and `SysRng` both describe the same OS CSPRNG path (`getrandom(2)` /
`BCryptGenRandom`) in their respective `rand` versions. The observable behavior
specified in BC-1.5.035 — output is always a 64-character lowercase hex string
derived from 32 OS-CSPRNG bytes — is identical before and after.

The BC's preconditions, postconditions, and the three existing unit tests
(`test_generate_state_is_hex`, `test_generate_state_is_64_hex_chars`,
`test_generate_state_is_not_deterministic`) are unaffected and require no change.

---

## 3. Other Spec Surfaces Touched

Six additional sites outside the BC file itself were updated. All are documentation
surfaces that reference the old type name; none carry behavioral contracts of their own.

### 3.1 BC-INDEX.md (site 2)

| Field | Before | After |
|-------|--------|-------|
| BC-1.5.035 title column, `.factory/specs/prd/BC-INDEX.md` line 110 | `generate_state()` produces 32 bytes from **OsRng** encoded as 64 hex chars | `generate_state()` produces 32 bytes from **SysRng** encoded as 64 hex chars |

BC-INDEX mirrors BC file H1 titles verbatim (per `bc_h1_is_title_source_of_truth`
policy). Updated to match the BC-1.5.035 title change in site 1.

### 3.2 `.factory/specs/domain-spec/state-machines.md` — ASCII art (site 3)

| Field | Before | After |
|-------|--------|-------|
| Line 52 (ASCII diagram box content) | `│ 32 bytes OsRng → 64 hex chars    │` | `│ 32 bytes SysRng → 64 hex chars   │` |

One trailing space was removed to preserve the box column width (OsRng = 5 chars;
SysRng = 6 chars; box inner width = 33 cols, unchanged). The closing `│` remains
at the same column position. Diagram renders as a clean box.

### 3.3 `.factory/specs/domain-spec/state-machines.md` — Key Invariants body (site 4)

| Field | Before | After |
|-------|--------|-------|
| Line 95 (Key Invariants bullet) | `CSRF state is 32 bytes from \`OsRng\` → 64 hex chars (BC-1146).` | `CSRF state is 32 bytes from \`SysRng\` → 64 hex chars (BC-1146).` |

One-word swap. No surrounding text changed.

### 3.4 `.factory/specs/domain-spec/bc-01-auth-identity.md` — INV-AUTH-004 (site 5)

| Field | Before | After |
|-------|--------|-------|
| Line 98 (INV-AUTH-004 table row, Invariant column) | `OAuth state parameter: 32 bytes from \`OsRng\` → 64 hex chars.` | `OAuth state parameter: 32 bytes from \`SysRng\` → 64 hex chars.` |

One-word swap. INV-AUTH-004's behavioral invariant — state is 32 bytes, CSRF-checked
at callback, login error on mismatch, keychain not written — is unchanged.

### 3.5 `.factory/architecture/state-machines.md` — Mermaid state-diagram label (site 6)

| Field | Before | After |
|-------|--------|-------|
| Line 43 (Mermaid `stateDiagram-v2` transition label) | `OAuthLogin --> GenerateState: 32 bytes from OsRng → 64 hex chars` | `OAuthLogin --> GenerateState: 32 bytes from SysRng → 64 hex chars` |

One-word swap in a Mermaid diagram transition label. No state, transition, or diagram
structure changed. This file has `status: Definitive` and references BC-1.5.035 by ID;
it is a live architecture spec, not a snapshot artifact.

### 3.6 `.factory/architecture/state-machines.md` — Key invariants list (site 7)

| Field | Before | After |
|-------|--------|-------|
| Line 81 (Key invariants bullet) | `` `generate_state`: 32 bytes from `OsRng` → 64 lowercase hex chars (BC-1.5.035) `` | `` `generate_state`: 32 bytes from `SysRng` → 64 lowercase hex chars (BC-1.5.035) `` |

One-word swap. BC-1.5.035 anchor citation preserved exactly.

---

## 4. ADR Assessment

**No new ADR required.**

The `rand` 0.9 → 0.10 migration is an implementation detail: a package-internal
symbol rename with no architectural change. ADR-0002 and ADR-0006 already cover the
OAuth CSRF approach. The Dependabot cooldown governance merged in PR #412 is the
applicable policy governing when dependency bumps like this are accepted; recording a
separate ADR for a one-shot semver rename would be redundant. This assessment is
consistent with the F1 delta analysis Architecture Change Assessment ("NONE").

---

## 5. VP Assessment

**No VP infrastructure exists in this project; nothing to extend.**

A search of `.factory/specs/` found no `verification-properties/` directory and no
`VP-` identifiers in any `.factory/**/*.md` file. The 32-byte entropy invariant is
implicitly captured by BC-1.5.035 and the three unit tests. No formal VP artifact
governs `generate_state`; there is nothing to extend or update.

---

## 6. Architecture Assessment

**No architecture change. Purity boundary unchanged. Module criticality unchanged.
ADR-0006 (embedded OAuth app) governance unaffected.**

`src/api/auth.rs::generate_state` was and remains an effectful shell function (OS
syscall). Its classification as an impure, security-critical function on the OAuth
CSRF path is unaffected by the type rename. `SysRng` is a direct rename of `OsRng`
in `rand` 0.10; both are zero-sized structs delegating to `getrandom(2)` /
`BCryptGenRandom`. No reclassification of the module or the function is required.

**Architecture state-machines.md mirror text updated (sites 6–7).** The two `OsRng`
references in `.factory/architecture/state-machines.md` — the Mermaid transition label
(line 43) and the key-invariants bullet (line 81) — were updated in this F2 pass per
the human gate classification ("live architecture spec, update in scope"). No structural
architecture change: no new state, no new transition, no diagram restructure. The
Mermaid diagram renders identically after the one-word swap. The BC-1.5.035 anchor
citation in line 81 is preserved verbatim.

---

## 7. Count Invariants

All three count-guard scripts were run after completing all seven edits (five
`.factory/specs/` sites + two `.factory/architecture/` sites). Output is recorded
verbatim:

**`scripts/check-spec-counts.sh`**:
```
OK: all spec counts verified.
```
Exit status: 0.

**`scripts/check-bc-cumulative-counts.sh`**:
```
OK: all cumulative BC counts verified (583 total across 8 files; Surface H footer checked where present).
```
Exit status: 0.

**`scripts/check-bc-no-numeric-test-counts.sh`**:
```
OK: no numeric test counts in BC Trace/Source fields.
```
Exit status: 0.

No count surface was modified by this delta (text-only refresh; no BCs added or
removed). The 583 total BC count is unchanged.

---

## 8. Process Gap Surfaced (for cycle-close)

`[process-gap]` **BA grep scope in F1 did not cover `.factory/specs/domain-spec/` or
`.factory/architecture/`.**

The F1 BA's exhaustive search for `OsRng` and related terms covered the
`.factory/specs/prd/*.md` subdirectory only. This missed:

- `.factory/specs/domain-spec/state-machines.md` (sites 3 and 4)
- `.factory/specs/domain-spec/bc-01-auth-identity.md` (site 5)
- `.factory/architecture/state-machines.md` (sites 6 and 7) — a live `status: Definitive`
  architecture spec that references BC-1.5.035 by ID and mirrors spec text

All five of these sites required F2 edits. They were caught only because the
human-assembled task spec included a comprehensive grep output. The BA's input
(`business-analyst-input.md` §"BCs searched but not found") explicitly lists `prd/`
BC files but does not mention `domain-spec/` or `architecture/` files.

**Recommendation:** Expand the BA agent's grep-scope checklist for text-refresh sweeps
to cover:

```
grep -rn "<term>" .factory/specs/ .factory/architecture/
```

This covers both `.factory/specs/prd/`, `.factory/specs/domain-spec/`, and
`.factory/architecture/` with a single command, and explicitly excludes
`.factory/semport/` (historical snapshots — see below). This expanded scope should be
codified in the BA agent prompt or as a project rule in `CLAUDE.md`'s AI Agent Notes
section for future similar cycles.

**Semport files intentionally NOT updated.** The five remaining `OsRng` references in
`.factory/semport/jira-cli/jira-cli-pass-*.md` are point-in-time snapshot artifacts
pinned at a specific analysis pass (SHA `dea16647...`, 2026-05-04). Updating them would
falsify the historical record of what the codebase looked like at analysis time. These
files are explicitly excluded from live-spec text-refresh sweeps. Their `OsRng`
references are correct for the snapshot moment and intentionally preserved.

---

## Quality Gate Self-Check

| Criterion | Status | Evidence |
|-----------|--------|---------|
| All 7 spec/architecture sites updated | confirmed | Sites 1–7 edited; diffs shown in §2 and §3 |
| `check-spec-counts.sh` exits 0 | confirmed | `OK: all spec counts verified.` (§7) |
| `check-bc-cumulative-counts.sh` exits 0 | confirmed | `OK: all cumulative BC counts verified (583 total ...)` (§7) |
| `check-bc-no-numeric-test-counts.sh` exits 0 | confirmed | `OK: no numeric test counts in BC Trace/Source fields.` (§7) |
| Post-edit grep: zero `OsRng` in `.factory/specs/` and `.factory/architecture/` | confirmed | `grep -rn "OsRng\|TryRngCore" .factory/specs/ .factory/architecture/` — no matches (exit 1) |
| Semport `OsRng` references still intact (5 references) | confirmed | `grep -rn "OsRng" .factory/semport/ \| wc -l` → 5; intentionally preserved (historical snapshots) |
| CLAUDE.md clean of `OsRng` | confirmed | `grep -n "OsRng" CLAUDE.md` — no matches (exit 1) |
| No new BCs introduced | confirmed | `new_bcs: []` in frontmatter; 583 total unchanged |
| No new VPs introduced | confirmed | No VP infrastructure exists in this project |
| No new ADR introduced | confirmed | §4: text-only migration detail; governance covered by PR #412 |
| No source code touched (`src/`, `tests/`, `Cargo.toml`, `deny.toml`) | confirmed | All edits in `.factory/specs/` and `.factory/architecture/` only |
| No CLAUDE.md changes required | confirmed | No `OsRng` references in CLAUDE.md; no AI-agent note updated |
| BC-INDEX title matches BC file H1 exactly | confirmed | Both read `SysRng` after edits; `bc_h1_is_title_source_of_truth` satisfied |
| ASCII art box alignment preserved | confirmed | Inner box width = 33 cols before and after; trailing space adjusted by 1 |
| Mermaid diagram structure unchanged | confirmed | One-word label swap only; no states, transitions, or notes modified |
| Architecture assessment updated | confirmed | §6: mirror-text update noted; "no structural change" stated explicitly |
| Process gap surfaced and noted | confirmed | §8: BA grep scope gap documented; recommended scope expanded to `.factory/{specs,architecture}/`; semport exclusion rationale recorded |
