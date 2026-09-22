---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-22T19:28:28Z
cycle: "cycle-009"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Burst Log — cycle-009 (jql-relative-date-units)

## Burst: Burst 1 — cycle-009 OPENED (Feature Mode) — jql-relative-date-units bundle confirmed, F1 delta analysis APPROVED (D-373) (2026-09-22)

**Parent-commit:** No new `develop`-side commit this burst — pure `.factory`-only cycle-open
bookkeeping, no `src/` change. `develop` tip unchanged at `bcec4c78` (origin). This is the
`factory-artifacts` atomic commit produced by this burst (state-manager commit — SHA recorded
after push).

**Adversary verdict:** N/A — this is a Phase F1 delta-analysis + human-gate burst, not an
adversarial-review pass. No F5 has run yet for this cycle.

**Trigger:** Human directed the orchestrator to open cycle-009 to adopt and complete external
contributor PR #863 (fixes GitHub issue #859) — reject unsupported JQL relative-date units `M`
(month) and `y` (year) in `src/jql.rs::validate_duration`, which currently accept them silently
and let Jira reject the resulting JQL later with an opaque 400.

**Actions taken:**
1. Opened cycle-009 (`jql-relative-date-units`), Feature Mode, brownfield, bug-fix intent, MEDIUM
   severity, standard scope class (amends BC-documented prose and is a breaking change for any
   caller relying on M/y being silently accepted), backend feature type.
2. Architect ran Phase F1 delta analysis: `.factory/cycles/cycle-009/phase-f1-delta-analysis/delta-analysis.md`
   + `affected-files.txt`. Impact boundary: `src/jql.rs` (MEDIUM, fix site), `src/cli/mod.rs`
   (LOW), `tests/issue_commands.rs` (modified + new tests, LOW), `.factory/specs/prd/bc-2-issue-read.md`
   (HIGH-if-skipped — `BC-2.1.008`, `BC-2.1.023`/`EC-2.1.023-1` need amending), `CHANGELOG.md`
   (MEDIUM-if-skipped, breaking-change note), plus 2 optional historical-docs stragglers
   (`docs/superpowers/plans/2026-03-25-common-filter-flags.md`,
   `docs/superpowers/specs/2026-03-24-common-filter-flags-design.md`). `src/cli/issue/list.rs` is
   a dependent call site (LOW, behavior unchanged). `validate_duration` has exactly 2 call sites
   (`src/cli/issue/list.rs:235,256`) — LOW-MEDIUM overall regression risk.
3. Human F1 gate convened and rendered an explicit APPROVED verdict, minting decision **D-373**:
   (1) scope approved as F1→F2→F4→F5→F6→F7 — F3 (incremental stories) skipped for this scope;
   (2) CR-005 nit INCLUDED — the rejection error message will point month/year users at
   `--created-after`/`--created-before`; (3) CR-002 historical-docs stragglers (the two docs files
   above) WILL BE FIXED this cycle, not deferred; (4) versioning ROLLS INTO the next dev
   prerelease at close, no immediate tag.
4. New M/y-rejection edge case will carry the corrected rationale ("Jira rejects `-1y` as invalid
   (400)", verified via Perplexity against JRACLOUD-82707) rather than the GitHub issue's
   original, inaccurate "empty result" claim — this correction is recorded now so F2 does not
   re-derive it.
5. Created `.factory/cycles/cycle-009/cycle-manifest.md` (status: in-progress) and this
   `burst-log.md`.

**Codifications:** `D-373` minted — cycle-009 Phase F1 scope APPROVED at the human gate (see
Decisions Log in `STATE.md`). Counts unchanged: 770 BCs / 89 VPs / 118 holdouts / 191 stories —
F2 may adjust the BC/EC counts; not pre-incremented here.

**Closes:** Nothing yet — GitHub issue #859 stays open until the fix lands and merges (F4).

**Outcome:** cycle-009 opened ACTIVE, Phase F1 APPROVED (`D-373`). `develop` unchanged at
`bcec4c78`. `activation_head`/`activation_version` unchanged at `8b4c797a`/`v0.7.0-dev.8` (no
release this burst). **NEXT:** Phase F2 (spec evolution) — amend `BC-2.1.008`/`BC-2.1.023`, add
the new M/y-rejection edge case, update `CHANGELOG.md` and the two historical docs stragglers.

### Details

| Agent | Task | Output |
|-------|------|--------|
| architect | Phase F1 delta analysis for cycle-009 | `.factory/cycles/cycle-009/phase-f1-delta-analysis/delta-analysis.md`, `affected-files.txt` |
| state-manager (this agent) | Recorded F1 human-gate approval, opened cycle-009 ACTIVE, minted D-373, created cycle-manifest.md + this burst-log.md, STATE.md ONE full-content Write, commit + push `factory-artifacts` | This entry; `.factory/cycles/cycle-009/cycle-manifest.md`; `STATE.md` |

**Files touched (Dim-1): 4 unique files, this burst**

- `STATE.md`
- `cycles/cycle-009/burst-log.md` (this entry, new)
- `cycles/cycle-009/cycle-manifest.md` (new)
- `cycles/cycle-009/phase-f1-delta-analysis/delta-analysis.md`, `affected-files.txt` (architect's
  prior F1 output, first committed to `factory-artifacts` this burst)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` —
N/A this burst (no `total_bcs`/`total_vps`/`total_stories` numeric change; F2 will run these).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A on `factory-artifacts` — no `src/` code change this burst; `develop`
tip remains `bcec4c78`.

**Dim-7 Attestation:** N/A — no `src/` change this burst; full regression suite last verified
PASS at cycle-008's F6 close (1498 lib tests + 49 integration binaries, 0 failures); no new run
triggered by this pure bookkeeping burst.

---

<!-- Repeat for each burst. Maintain chronological order. -->
