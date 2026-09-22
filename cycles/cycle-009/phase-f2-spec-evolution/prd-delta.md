---
document_type: prd-delta
cycle: cycle-009
feature_slug: jql-relative-date-units
feature_type: backend
intent: bug-fix
scope: standard
severity: MEDIUM
issue_refs: ["#859", "#863"]
created: 2026-09-22
status: draft
---

# PRD Delta: jql-relative-date-units (cycle-009)

## Source

- F1 delta analysis: `.factory/cycles/cycle-009/phase-f1-delta-analysis/delta-analysis.md`
- Adopts external PR #863, fixes GitHub issue #859.

## Root Cause (as confirmed at F1, restated here for traceability)

`src/jql.rs::validate_duration` (governing `jr issue list --recent`/`--updated-recent`)
previously accepted relative-date unit set `{y, M, w, d, h, m}`, matched case-insensitively.
Jira's raw JQL relative-date offset grammar (`created >= -{d}` / `updated >= -{d}`) supports
ONLY `{w, d, h, m}`. Confirmed via this session's Perplexity research against first-party
Atlassian sources and JRACLOUD-82707:

- `2M` was silently reinterpreted by Jira as **2 minutes**, not 2 months — `M`/`m` collide
  case-insensitively server-side too. Silent, exit 0, no warning, 30x-magnitude wrong result.
- `1y` was **rejected by Jira with HTTP 400** ("invalid date value") — NOT a silent empty
  result set as issue #859's original framing claimed. This F2 delta corrects that framing
  wherever the old spec text implicitly repeated it.
- `M`/`y` remain valid ONLY inside JQL functions (`startOfMonth()`/`startOfYear()`), which
  `validate_duration` does not govern — unaffected, out of scope.

## Canonical Error String (F4 MUST implement verbatim)

Verified alternative flags (grepped `src/cli/mod.rs:~385-395`, confirmed clap kebab-case
auto-derivation, no `long = "..."` override present): `--created-after`, `--created-before`,
`--updated-after`, `--updated-before`. These are the ONLY existing absolute-date flags;
no other candidate flag names exist in the CLI surface.

Single `format!` template (used at all 4 call sites inside `validate_duration`):

```
Invalid duration '{s}'. Use a number followed by w, d, h, or m (e.g., 7d, 4w, 12h). For month or year ranges, use --created-after/--created-before or --updated-after/--updated-before.
```

This is the exact string F4's implementation must produce byte-for-byte (modulo the `{s}`
substitution). It replaces the old string:

```
Invalid duration '{s}'. Use a number followed by y, M, w, d, h, or m (e.g., 7d, 4w, 2M).
```

Accepted unit set narrows from `{y, M, w, d, h, m}` to `{w, d, h, m}`.

## BCs Amended (no new BC-S.SS.NNN — amendment-in-place only)

File: `.factory/specs/prd/bc-2-issue-read.md` (file-local trace v1.5.1 → v1.5.2,
`last_updated` 2026-08-24 → 2026-09-22; `total_bcs`/`definitional_count` UNCHANGED at
122/80 — no `#### BC-` heading added or removed).

### BC-2.1.008 (`--recent <duration>` validated by `jql::validate_duration`)

**UPDATED** Behavior clause (~line 293 pre-edit). Old error string and unit set replaced
with the canonical string above; explicitly documents the narrowed `{w, d, h, m}` accepted
set and cross-references the new EC-2.1.023-5 for M/y-rejection rationale. Previous version
retained inline per `**Previous version (superseded 2026-09-22, retained for audit
trail):**` convention (matching this file's pre-existing EC-2.1.023-4 amendment pattern).

### BC-2.1.023 (`--updated-recent <duration>` → `updated >= -{d}` clause)

**UPDATED** EC-2.1.023-1 (~lines 872-875 pre-edit): same canonical error-string
replacement, previous version retained inline.

**ADDED** EC-2.1.023-5 (new edge case, continuing the EC-2.1.023-N sequence after the
existing EC-2.1.023-4): documents `--recent 2M`/`--updated-recent 2M` and `--recent
1y`/`--updated-recent 1y` rejection explicitly, with the corrected rationale — `M` silent
mis-parse-as-minutes footgun (not documented anywhere before this delta) and `y` HTTP 400
(corrected from issue #859's "empty result" framing). Notes that `M`/`y` remain valid inside
JQL functions, out of scope for this BC.

**Verification Properties section**: VP-UPDATED-RECENT-001 gains a dated clarifying note
that its "rejected pre-HTTP with zero HTTP calls" property extends unchanged to the
narrowed M/y rejection, and that no new VP-NNN was introduced for this delta (see
`verification-delta.md`).

## BCs NOT Touched

- BC-2.1.006, BC-2.1.007, BC-2.1.009, BC-2.1.010 and all other BC-2.1.xxx entries —
  unaffected; `validate_duration`'s unit-set narrowing has no effect on filter-source
  enumeration, clause ordering, or the separate `validate_date`-governed absolute-date
  flags.
- `src/duration.rs` (worklog-duration parser, `2h`/`1h30m`/`1d`/`1w` grammar) — confirmed
  in F1 as a wholly separate validator/grammar; no BC in this file governs it, no change.

## Architecture Delta

**Architecture unchanged.** `validate_duration` remains a pure, side-effect-free string
validator called before any I/O — no new module, no interface change, no purity-boundary
shift. No entry written to `.factory/specs/architecture/`.

## Interface / Help-Text Note (not a BC, tracked for F4)

`src/cli/mod.rs`'s `--recent`/`--updated-recent` doc-comment help strings currently use
`2M` as an example unit (×2 occurrences, ~lines 357/360 per F1). F4 must update these to a
valid example (e.g. `12h`) in lockstep with the code change — this is implementation detail,
not a spec/BC surface, so it is noted here for F4 but not modified in this F2 delta.

## Stories

**No story frontmatter/body changes required.** This is a bug-fix-route delta with no new
BC-S.SS.NNN and no BC array re-anchoring. Checked `.factory/stories/S-578-1-field-value-kind-hint-parser.md`,
`.factory/stories/S-579-1-updated-recent-filter.md`, and `.factory/stories/STORY-INDEX.md`
for pinned references to the old error string or the old `{y,M,w,d,h,m}` unit set — **none
found**. Both stories reference `jql::validate_duration` only in general terms (function
name, reuse rationale, FIX-F6-LRE-1 multibyte-panic precedent) — never the specific error
wording or unit list. No story flag raised to the human under Task Instruction #8.

## Spec Version Bump

**PATCH** (`.factory/spec-changelog.md` 2.3.1 → 2.3.2, 2026-09-22) — edge-case addition +
error-string wording at the spec level; no new/removed BCs, no architecture change.
Versioning decision (per orchestrator instruction): rolls into the next dev prerelease, no
immediate tag cut.

## Guard Script Results

- `scripts/check-spec-counts.sh`: see burst report (must exit 0 — `bc-2-issue-read.md`'s
  `#### BC-` heading count is unaffected by this delta, since only Behavior/Edge-Case prose
  changed, no heading added/removed).
- `scripts/check-bc-cumulative-counts.sh`: see burst report (must exit 0 — same reasoning,
  `BC-INDEX.md` total_bcs unaffected).
