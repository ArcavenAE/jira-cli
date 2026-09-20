# Maintenance Sweep — Consistency Cluster (Sweeps 7/8/11) — 2026-09-19

Read-only analysis. No `src/`, spec, or `STATE.md` changes made. No git commits made.

## 1. Spec Coherence (Sweep 7)

### Automated guard scripts — all PASS (exit 0)

| Script | Result |
|---|---|
| `scripts/check-bc-cumulative-counts.sh` | PASS — 770 total BCs across 9 files (Surface H footer checked where present) |
| `scripts/check-spec-counts.sh` | PASS — 8 BC files validated |
| `scripts/check-bc-no-numeric-test-counts.sh` | PASS — no numeric test counts in Trace/Source fields |
| `scripts/check-bc-citation-symbols.sh` | PASS — 526 citations checked |
| `scripts/check-cargo-mutants-policy-citations.sh` | PASS — 28 bullets / 92 (file,fn) pairs validated |

### cycle-008 close counts (770 BC / 89 VP / 118 holdout / 191 stories) — VERIFIED internally consistent

Cross-checked against the 2026-09-16 sweep baseline (769 BC / 86 VP / 118 holdout / 185 stories,
per `.factory/maintenance/sweep-report-2026-09-16.md` §7):

- **BC:** 769→770 (+1). Matches cycle-008's `BC-X.15.001` (new BC added by
  `S-cycle8-agile-scope-mismatch-error-mapping`). Script-confirmed.
- **VP:** 86→89 (+3). Matches cycle-008's three new VP IDs (`VP-OAUTH-GW-001/002/003`, one per
  OAuth-gateway-routing story). Arithmetic checks out; no VP-registry script exists to
  independently verify (see VP-COUNT-RECONCILIATION note below — pre-existing, not new).
- **Holdout:** 118→118 (unchanged). Consistent with `total_holdouts: 118` frontmatter in
  `.factory/specs/prd/holdout-scenarios.md` (118 `H-*` entries counted directly). Plausible: all 6
  cycle-008 stories are OAuth-routing/verification fixes, none required a new BC-driven holdout
  scenario.
- **Stories:** 185→191 (+6, `S-cycle8-*`). `total_stories: 191` frontmatter in
  `.factory/stories/STORY-INDEX.md` matches the Story Manifest table's actual unique `story_id`
  row count (191, after excluding the 5 sub-table header rows that a naive grep double-counts).
  All 6 new cycle-008 story files verified present on disk at
  `.factory/cycles/cycle-008/phase-f3-stories/S-cycle8-*.md`.

**Conclusion: cycle-008's close counts are internally consistent and arithmetically justified.
No count drift found.**

### Finding SC-1 (MAJOR, pre-existing, NOT cycle-008-introduced): two dead file_path citations in STORY-INDEX.md Story Manifest table

`.factory/stories/STORY-INDEX.md`'s Story Manifest table (Wave 3 subsection, ~line 1627/1631)
cites `file_path` values that do not exist on disk — the actual files were renamed at some point
after the table row was written, and the row was never updated:

| story_id | Table cites (does not exist) | Actual file on disk |
|---|---|---|
| S-3.03 | `.../wave-3/S-3.03-refresh-oauth-token-investigation.md` | `.factory/stories/wave-3/S-3.03-auto-refresh-oauth-on-401-with-single-flight.md` |
| S-3.07 | `.../wave-3/S-3.07-low-nfr-code-cleanup.md` | `.factory/stories/wave-3/S-3.07-low-nfr-code-fixes-and-search-jql-anti-loop.md` |

Both stories are long-completed (S-3.03 = PR #321/`597dd23`; S-3.07 = PR #315/`6bce18c`, per the
Wave Plan table at line ~1202/1206) — this is dormant documentation drift, not a live-content
integrity problem, and does not affect any active BC/VP/holdout chain. Classic case of criterion
77 (filename slug changed post-rename, index row not updated) / criterion 23 (index references a
non-existent detail file) territory.

- **Severity:** MAJOR per validation-criteria taxonomy (dead index reference), but non-blocking —
  no current pipeline depends on these two rows resolving.
- **Automated-fixable:** YES — a 2-line `Edit` correcting the two `file_path` cells. Trivial fix,
  recommend a follow-up maintenance PR (not actioned here per read-only scope).
- All 189 other clean-format Story Manifest rows checked (script-verified) resolve to real files
  with no other misses; the 2 `TBD` placeholder rows (`S-ANYHOW-RUSTSEC-2026-0190-1`,
  `S-CITATION-DEBT-PRODUCT-FILES-1`) are self-documented as not-yet-filed, not drift.

### Lifecycle-status consistency — CLEAN

`grep -rl "lifecycle_status: deprecated\|lifecycle_status: retired" .factory/specs/prd/bc-*.md` —
zero hits. No deprecated/retired BCs exist; criterion 24/55 concerns do not apply this cycle.

### VP-COUNT-RECONCILIATION — reconfirmed, NOT new (pre-existing tracked backlog item)

Independently reconfirmed via raw grep: 287 unique `VP-*` tokens appear across
`.factory/specs/**/*.md`, and 58 unique VP IDs appear specifically in story frontmatter
`verification_properties:` fields — neither figure reconciles cleanly to the tracked running total
of 89. This repo has **no centralized `VP-INDEX.md`** (unlike the generic vsdd-factory greenfield
template) — VPs are namespaced per-feature (`VP-OAUTH-GW-001`, `VP-674-014`, etc.) and totalled by
convention in STATE.md/story-index bookkeeping, not by a script. This is already tracked as:
- `VP-COUNT-RECONCILIATION` in `.factory/cycles/OPEN-STANDING-ITEMS.md` (line ~545, cycle-005 F1,
  unresolved, non-blocking).
- `SPEC-001` in the 2026-09-16 sweep report (`No canonical VP-INDEX.md/registry exists`), with a
  backlog story `S-PG-VP-REGISTRY-1` already filed to close it.

**No new finding here — confirms the existing backlog item is still accurate and still open.**
Not automated-fixable without first building the registry (architectural work, not a sweep fix).

## 2. Tech Debt Register (Sweep 8)

**No standalone tech-debt-register file exists anywhere in the repo** (`find . -iname "*debt*"`
returns nothing under `docs/` or `.factory/` other than build-artifact noise in `target/` and two
unrelated citation-debt artifacts: `.factory/code-delivery/CITATION-DEBT-ADR0012-FIX`,
`.factory/phase-f1-delta-analysis/citation-debt-filewide-2026-06-30-delta.md`). This is confirmed
consistent with the 2026-09-16 sweep's own finding (§8 of `sweep-report-2026-09-16.md`): **"No
formal due-date debt register exists; `cycles/OPEN-STANDING-ITEMS.md` serves as the project's debt
log."** This convention is unchanged.

**No overdue items found.** None of the ~50 entries in `OPEN-STANDING-ITEMS.md` carry an assigned
due date or SLA — every deferred item is scoped "target: a future maintenance/self-improvement
cycle" open-endedly, so "overdue >90 days" is not a well-formed check against this log (there is no
date to be overdue against). The oldest *content* references inside the file (design-doc filenames
like `docs/superpowers/plans/2026-03-21-jr-implementation.md`) are citations inside currently-open
entries, not standalone stale items themselves.

### New debt sources introduced by cycle-008 — all already self-captured, correctly dispositioned

Reviewed the full cycle-008 F4/F5/F6/F7 sections of `OPEN-STANDING-ITEMS.md` (lines 996–1188).
Every item cycle-008 introduced is accounted for with a clear status and target:

| ID | Severity | Status |
|---|---|---|
| `CYCLE-008-ENV-RESTORE-NON-RAII` | LOW | CLOSED-BY-DEFERRAL, target: future maintenance sweep (RAII env-guard pattern, cross-cutting) |
| `CYCLE-008-WORKTREE-NAME-VS-STORYID` | LOW | CLOSED-BY-DEFERRAL, target: future process/self-improvement cycle |
| `CYCLE-008-S5-TRAJECTORY-TAIL-HOOK-FALSE-POSITIVE` | LOW (engine) | CLOSED-BY-DEFERRAL, target: vsdd-factory engine fix |
| `CYCLE-008-F5-KEYRING-WIRING-COVERAGE` | MEDIUM (test-quality) | OPEN, carried forward (structural — no mockable keyring seam exists repo-wide) |
| `CYCLE-008-INIT-MUTATION-COVERAGE-SEAM` | LOW | OPEN, new at F7 close (DEC-371), supersedes/subsumes `CYCLE-008-F5-INIT-MAPERR-MUTANT-RESIDUAL` |
| `CYCLE-008-F6-PUREFN-MUTATION-HOST-DEFERRED` | LOW | OPEN, host-speed limitation (same family as `HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`) |
| `CYCLE-008-F6-SEMGREP-NOT-INSTALLED` | LOW/note | OPEN, tooling gap |
| `CYCLE-008-F6-LOCAL-CLIPPY-BUILDLOCK` | LOW/note | OPEN, host-local only; CI clippy authoritative and clean |
| `CYCLE-008-SELF-APPROVAL-STRUCTURAL-GAP` | — | OPEN, carried forward, engine-level (repo-wide, not cycle-008-specific) |
| `CYCLE-008-F6-MUTANTS-EXAMINE-GLOBS-GAP` | — | RESOLVED 6/7 via FIX-F7-001 (PR #845); 7th file (`init.rs`) → subsumed by `CYCLE-008-INIT-MUTATION-COVERAGE-SEAM` above |
| `CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` | — (release-owned) | **RESOLVED 2026-09-18**, operator-confirmed (top-of-file live status; see §3 below) |

No gaps found — every cycle-008 novel finding is tracked as either an OPEN-STANDING-ITEM or a
resolved-with-note, consistent with the F7-close checklist's own self-audit (line 1148 "none left
uncovered at close").

## 3. Risk/Assumption Monitoring (Sweep 11)

No dedicated `ASM-NNN`/`R-NNN` registry artifacts exist under `.factory/specs/` for this project
(this repo predates/deviates from the generic vsdd-factory greenfield template in that respect);
risk and standing-item tracking runs through `OPEN-STANDING-ITEMS.md` + `STATE.md`'s `## Blocking
Issues` table instead. Reviewed the four items named in the task:

- **`S6-TEAMS-OAUTH-BLOCKED-ON-ATLASSIAN-SCOPE-PROVISIONING`** (LOW, external blocker) — **current,
  not stale.** Updated same day as this sweep (2026-09-19) with a second independent empirical
  proof (Developer Console API-catalog inspection, 8 APIs enumerated, no Teams tile) on top of the
  original authorize-endpoint differential test. Correctly dispositioned DEFER-INDEFINITELY (not a
  flat reject — no cited Atlassian rule bars it, just no self-service provisioning path). Recurring
  maintenance-revisit mechanism is wired into `.factory/maintenance-config.yaml`
  (`external_blocker_rechecks:`), with an explicit two-step recheck procedure documented inline.
  `jr team list` remains correctly documented as API-token-only, pre-existing gap not a regression.
- **`AUTH-REFRESH-TARGET-PROFILE-NOT-SHOWN`** (LOW, DX/UX) — added 2026-09-18, one day old.
  Correctly scoped as DEFERRED, not tied to cycle-008 or S6, clear fix direction cited
  (`src/cli/auth/refresh.rs::refresh_credentials`), no target release assigned. Not stale.
- **`ENGINE-VALIDATE-DISPATCH-ADVANCE-STALE-DCHAIN-CITE`** (MEDIUM, engine/tooling) — added
  2026-09-19 (today). Correctly classified as an engine-repo follow-up
  (`~/Documents/GITHUB/vsdd-factory`), explicitly NOT a jira-cli product item, non-blocking. Not
  stale (can't be — it's brand new).
- **cycle-008 residuals** (Wave-2/F5/F6/F7 justified deferrals, lines 996–1188) — internally
  consistent; cross-references between sections agree (e.g., `CYCLE-008-F5-INIT-MAPERR-MUTANT-RESIDUAL`
  is explicitly marked "SUBSUMED" pointing at `CYCLE-008-INIT-MUTATION-COVERAGE-SEAM", and both
  sides of that cross-reference agree). One cosmetic note: the F7-close checklist subsection
  (dated snapshot as of 2026-09-18) still reads `CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` as "OPEN,
  human/release-owned pre-release blocker" in its own bullet — this is *intentional append-only
  log design* (each `##` section is a dated historical snapshot, per the file's own header note),
  not actual drift: the top-of-file live-status entry (line 13) correctly shows **RESOLVED
  2026-09-18, operator-confirmed**, and `STATE.md`'s own Blocking Issues table agrees (zero open
  pre-release blockers). Not a finding requiring action — flagging only for completeness.

**No stale or resolved-but-not-closed items found among the four named items.** All are either
brand-new (same-day or previous-day) or carry an active recurring-recheck mechanism.

## Overall Assessment

**Coherent. No blocking findings.** Automated guard scripts all green. cycle-008's close counts
(770/89/118/191) are internally consistent and arithmetically traceable to its actual delta (+1
BC, +3 VP, +0 holdout, +6 stories). Tech-debt and risk-tracking conventions (no formal register;
`OPEN-STANDING-ITEMS.md` as the log) are unchanged and functioning as designed — nothing overdue,
nothing stale, nothing resolved-but-left-open.

One MAJOR-but-dormant, pre-existing (not cycle-008), automated-fixable finding surfaced this sweep
that had not been previously flagged: **SC-1**, two stale `file_path` citations in
`STORY-INDEX.md`'s Story Manifest table (S-3.03, S-3.07) pointing at renamed/nonexistent
filenames. Recommend a trivial follow-up fix (2-line edit) in a future maintenance pass; not
actioned here (read-only scope).

All other observations (VP-COUNT-RECONCILIATION, no VP-INDEX registry, the F7-close historical
snapshot wording) reconfirm pre-existing, already-tracked backlog items rather than surfacing new
drift — consistent with the "expect LOW findings" framing for this area (fresh-context-audited at
cycle-008 F7 close, swept again 2026-09-16).
