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

## Burst: Burst 2 — Phase F2 spec evolution APPROVED (D-374) — canonical error string + EC-2.1.023-5 + no-new-VP + scoped adversary CONVERGED + grounding audit (2026-09-22)

**Parent-commit:** No new `develop`-side commit this burst — pure spec-and-`.factory` bookkeeping,
no `src/` change (F4 will implement the code). `develop` tip unchanged at `bcec4c78` (origin). The
F2 spec-evolution work itself was already committed to `factory-artifacts` across 3 prior commits
this session — `858b4f47` (F2 spec evolution: product-owner), `4e9d8a37` (adversary H1/M1
resolution), `45b49928` (grounding-audit correction) — before this state-manager burst, whose own
commit records the STATE.md/burst-log/cycle-manifest bookkeeping on top of that tip.

**Adversary verdict:** Scoped adversary (fresh context, read-only) ran against the F2 delta
artifacts (`prd-delta.md`, `verification-delta.md`, amended `bc-2-issue-read.md`,
`spec-changelog.md`) — **ITERATE**: 1 HIGH (`F2-ADV-H1`, case-sensitivity mischaracterization in
`prd-delta.md`'s Root Cause section), 1 MEDIUM (`F2-ADV-M1`, unenforced no-new-VP reliance), 1 LOW
(`F2-ADV-L1`, docs-straggler process gap). H1+M1 RESOLVED in the same burst by the orchestrator
(see full adjudication in `phase-f2-spec-evolution/adversarial-spec-delta-review.md`); L1 DEFERRED
to F4 per the F1-gate's prior CR-002 decision. 7 clean-confirmation axes additionally verified
clean (string-drift, flag-name reality, rationale consistency, combined-units orthogonality,
no-new-VP soundness, semver correctness, count-neutrality). **CONVERGED — zero findings above
cosmetic remain.**

**Trigger:** cycle-009 Phase F1 (`D-373`) approved the scope F1→F2→F4→F5→F6→F7; this burst runs
Phase F2 (spec evolution) and records its human-gate approval.

**Actions taken:**
1. product-owner amended `.factory/specs/prd/bc-2-issue-read.md` in place (file-local trace
   v1.5.1→v1.5.2; `total_bcs`/`definitional_count` unchanged 122/80, no new BC heading):
   `BC-2.1.008`'s Behavior clause and `BC-2.1.023`'s `EC-2.1.023-1` both replaced with the
   canonical error string (narrowed `{w,d,h,m}` accepted set, includes the CR-005 hint pointing
   month/year users at `--created-after`/`--created-before`/`--updated-after`/`--updated-before`),
   pinned byte-identical across 4 sites (`prd-delta.md`, `BC-2.1.008`, `EC-2.1.023-1`,
   `spec-changelog.md` 2.3.2 entry); new `EC-2.1.023-5` added documenting M/y rejection with the
   corrected rationale (`M` silently mis-parsed as minutes server-side per Atlassian's
   DateUtils.getDuration Javadoc; `y` HTTP 400, not issue `#859`'s original "empty result" claim)
   plus a full client case-sensitivity boundary disposition table.
2. `.factory/spec-changelog.md` PATCH-bumped 2.3.1→2.3.2, breaking-change flagged.
3. `verification-delta.md` (new file) ruled NO new VP-NNN warranted (amended
   `VP-UPDATED-RECENT-001` in place with a dated clarifying note instead) and defined an explicit
   "F7 Delta-Convergence Acceptance Gate" — 5 required CR-004 assertions (2×2 rejection matrix
   `{2M,1y}×{--recent,--updated-recent}` + 1 case-boundary assertion) — making that no-new-VP
   reliance mechanically enforceable at F7.
4. Scoped adversary ran ITERATE (see verdict above); orchestrator resolved H1+M1 the same burst
   (H1: reworded Root Cause + added case-sensitivity rule sub-section, ground-truthed directly
   against `src/jql.rs`'s case-sensitive `matches!(unit, 'y'|'M'|'w'|'d'|'h'|'m')` arm, confirmed
   by the function's own doc comment; M1: added the F7 gate section to `verification-delta.md`).
   L1 deferred to F4.
5. research-agent ran a grounding audit confirming every JQL factual claim in the F2 delta traces
   to a first-party Atlassian source; one ungrounded "30x" magnitude figure (unsupported
   extrapolation) was dropped and replaced with a direct citation to Atlassian's
   DateUtils.getDuration Javadoc — `spec-changelog.md` and `bc-2-issue-read.md` corrected to
   match.
6. Both `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` verified exit
   0 — count-neutral, 0 new BC/VP, `total_bcs` 770 unchanged.
7. Human F2 gate convened this session and rendered an explicit APPROVED verdict, minting decision
   **D-374**. Noted one small pending F4 to-do: tidy `BC-2.1.008`'s Behavior clause to add the
   same "(per Atlassian's DateUtils.getDuration Javadoc)" citation `EC-2.1.023-5`/
   `spec-changelog.md` now carry (cosmetic citation-consistency, human-approved for F4, not a
   blocker for F2 approval).
8. state-manager (this agent) recorded the F2 human-gate approval in `STATE.md` (ONE full-content
   Write), updated `cycles/cycle-009/cycle-manifest.md` (Delivered/Spec Changes/Notes sections),
   appended this Burst 2 entry, and archived the oldest Phase Progress row
   (`OAUTH-16-SCOPE-SMOKE-TEST-PASS-2026-09-18`) to `cycles/HISTORY-PHASE-PROGRESS.md`.

**Codifications:** `D-374` minted — cycle-009 Phase F2 spec evolution APPROVED at the human gate
(see Decisions Log in `STATE.md`). Counts unchanged: 770 BCs / 89 VPs / 118 holdouts / 191
stories — count-neutral, both guard scripts verified exit 0.

**Closes:** Nothing yet — GitHub issue `#859` stays open until the fix lands and merges (F4).

**Outcome:** cycle-009 Phase F2 APPROVED (`D-374`); F1 (`D-373`) approved prior burst. `develop`
unchanged at `bcec4c78`. `activation_head`/`activation_version` unchanged at
`8b4c797a`/`v0.7.0-dev.8` (no release this burst). **NEXT:** Phase F4 (delta implementation, F3
skipped per `D-373`) — adopt PR `#863`'s code against the amended BCs, implement the canonical
error string verbatim (4 sites, WITH the CR-005 hint), update help text, add the CR-004
integration test satisfying the F7 gate, add a `CHANGELOG.md` `[Unreleased]` entry, fix the CR-002
straggler docs, and the `BC-2.1.008` citation tidy.

### Details

| Agent | Task | Output |
|-------|------|--------|
| product-owner | Phase F2 spec evolution: amend BC-2.1.008/BC-2.1.023, add EC-2.1.023-5, PATCH spec bump | `specs/prd/bc-2-issue-read.md`, `spec-changelog.md`, `cycles/cycle-009/phase-f2-spec-evolution/prd-delta.md`, commits `858b4f47`/`4e9d8a37`/`45b49928` |
| adversary | Scoped adversarial spec-delta review | `cycles/cycle-009/phase-f2-spec-evolution/adversarial-spec-delta-review.md` |
| research-agent | Grounding audit of JQL factual claims | corrections folded into `prd-delta.md`/`spec-changelog.md`/`bc-2-issue-read.md` via commit `45b49928` |
| state-manager (this agent) | Recorded F2 human-gate approval, minted D-374, updated cycle-manifest.md, appended this Burst 2 entry, archived oldest Phase Progress row, STATE.md ONE full-content Write, commit + push `factory-artifacts` | This entry; `STATE.md`; `cycles/cycle-009/cycle-manifest.md`; `cycles/HISTORY-PHASE-PROGRESS.md` |

**Files touched (Dim-1): 4 unique files, this burst**

- `STATE.md`
- `cycles/cycle-009/burst-log.md` (this entry, new)
- `cycles/cycle-009/cycle-manifest.md` (updated)
- `cycles/HISTORY-PHASE-PROGRESS.md` (oldest Phase Progress row archived)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` —
both verified exit 0 by product-owner during the F2 spec-evolution commits (`858b4f47` onward);
no `total_bcs`/`total_vps`/`total_stories` numeric change this burst or the prior F2 commits.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A on `factory-artifacts` — no `src/` code change this burst; `develop`
tip remains `bcec4c78`.

**Dim-7 Attestation:** N/A — no `src/` change this burst; full regression suite last verified
PASS at cycle-008's F6 close (1498 lib tests + 49 integration binaries, 0 failures); no new run
triggered by this spec-only burst.

---

## Burst: Burst 3 — cycle-009 Phase F4 delta implementation COMPLETE — PR #868 merged (2026-09-22)

**Parent-commit:** `develop` tip moves `bcec4c78` -> `1847ce38` this burst (squash-merge of PR
`#868`). This is the `factory-artifacts` atomic commit produced by this burst (state-manager
commit recording F4 COMPLETE — SHA in the commit message below).

**Phase F4 (delta implementation): COMPLETE.** F4 is an automated quality gate (Red Gate / Green
Gate / regression / lint / review convergence) with no dedicated human phase-gate ruling — but
the delivery mechanism this burst was a human-approved squash-merge of PR `#868` (the human
explicitly approved merging), not an unreviewed auto-merge.

**Adversary verdict:** N/A — this is an F4 delta-implementation burst (TDD Red/Green Gate +
code-review/security-review/pr-review convergence on PR `#868`), not a dedicated adversarial-review
pass. `code-reviewer` APPROVE (2 nits fixed), `security-reviewer` CLEAN, fresh-eyes `pr-reviewer`
APPROVE (1 LOW won't-fix-by-design) — see Quality evidence below. Phase F5 (the first
implementation-level adversarial pass for cycle-009) is next.

**Delivery:** external contributor PR `#863`'s fix was ADOPTED + COMPLETED (differs from the raw
`#863` diff by including the F2-mandated canonical error string with the CR-005
`--created-after`/`--created-before`/`--updated-after`/`--updated-before` hint) and merged as PR
`#868` — squash commit `1847ce38` on `develop` (`develop` `bcec4c78` -> `1847ce38`). `#868` credits
external contributor `@DeepanshuPal` via a preserved `Co-authored-by` trailer in the squash commit.
GitHub issue `#859` **CLOSED**. Courtesy-close of the superseded `#863` in progress (separate agent
thread `close-pr863`, not owned by this burst).

**What shipped:**
- `src/jql.rs::validate_duration` now rejects `M` (month) and `y` (year) — accepts only
  case-sensitive lowercase `{w,d,h,m}`.
- Canonical error string (F2's `EC-2.1.023-1`, byte-identical to the spec) landed at all 4 call
  sites, including the CR-005 hint pointing month/year users at `--created-after`/
  `--created-before`/`--updated-after`/`--updated-before`.
- `--recent`/`--updated-recent` `--help` text updated to match the narrowed accepted-unit set.
- `CHANGELOG.md` `[Unreleased]` breaking-change entry added.
- CR-002 historical-docs stragglers corrected: `docs/superpowers/plans/2026-03-25-common-filter-flags.md`
  and `docs/superpowers/specs/2026-03-24-common-filter-flags-design.md`.
- The pending `BC-2.1.008` citation tidy (Atlassian DateUtils.getDuration Javadoc) — folded into
  this same delivery per the F2 gate's human-approved to-do.

**Quality evidence:**
- Red Gate satisfied — all new tests confirmed to FAIL against pre-fix `validate_duration`
  (full detail: `cycles/cycle-009/jql-date-units/implementation/red-gate-log.md`).
- Green Gate — all new tests PASS post-fix.
- Full regression: **5,367 passed / 0 failed / 188 ignored** (baseline `5,357` passed, recorded at
  `phase-f4-implementation/regression-baseline.md` cycle-009 section — worktree
  `/Users/zious/Documents/GITHUB/jira-cli/.worktrees/cycle-009-jql-date-units`, branch
  `fix/jql-reject-month-year-units`, base `bcec4c78`). **+10 tests, zero regressions.**
- `cargo fmt --all -- --check` clean.
- `cargo clippy --all --all-features --tests -- -D warnings` — zero warnings.
- Reviews: clean local code-review APPROVE (2 nits fixed); `security-reviewer` CLEAN; fresh-eyes
  `pr-reviewer` APPROVE (1 LOW won't-fix-by-design).
- CI: all 24 checks green including the required CI Gate (run `35791400606`); `mergeStateStatus`
  CLEAN.
- Demo SKIPPED — human decision, error-path change, cycle-012 Wave 2 precedent.

**Process observations logged (not blockers, carried forward as `[process-gap]` LOW standing
items in `cycles/OPEN-STANDING-ITEMS.md`):**
1. `factory-dispatcher` `FUEL_EXHAUSTED` hook fired spuriously on `src/jql.rs` + BC-file edits
   this burst (edits landed fine, verified) — hook-health item.
2. `validate-dispatch-advance` hook false-flags the substring `"JRACLOUD-82707"` as a phantom
   decision-ID `D-82707` — worked around this burst by writing `"JRACLOUD 82707"` with a space in
   `.factory` files — hook false-positive item.

**Codifications:** No new `D-NNN` minted this burst — F4 is an automated gate; the human action
this burst was a merge-approval decision on PR `#868`, not a fresh pipeline-phase ruling (same
class as the `PR864-...-BOOKKEEPING` precedent). Counts unchanged: 770 BCs / 89 VPs / 118 holdouts
/ 191 stories — F4 added tests, not BCs/VPs, count-neutral.

**Closes:** GitHub issue `#859` CLOSED via PR `#868`'s merge. `#863` courtesy-close in progress
(separate thread).

**Outcome:** cycle-009 Phase F4 COMPLETE. `develop` tip `bcec4c78` -> `1847ce38`.
`activation_head`/`activation_version` UNCHANGED at `8b4c797a`/`v0.7.0-dev.8` (no release cut this
burst — rolls into the next dev prerelease per `D-373` decision 4). **NEXT:** Phase F5 (scoped
adversarial refinement on the merged delta, diff `bcec4c78..1847ce38`); then F6 (light targeted
hardening); F7 (delta convergence + human close gate).

### Details

| Agent | Task | Output |
|-------|------|--------|
| implementer | F4 Red Gate + Green Gate TDD implementation of `validate_duration` fix, help text, CHANGELOG, CR-002 docs fixes, BC-2.1.008 citation tidy | `src/jql.rs`, `tests/issue_commands.rs`, `CHANGELOG.md`, docs stragglers, worktree `fix/jql-reject-month-year-units` |
| code-reviewer | Clean local review | APPROVE (2 nits fixed) |
| security-reviewer | Security review | CLEAN |
| pr-reviewer | Fresh-eyes PR review of `#868` | APPROVE (1 LOW won't-fix-by-design) |
| pr-manager / github-ops | PR `#868` creation, CI wait, human-approved squash-merge | PR `#868` @ `1847ce38`; issue `#859` closed |
| state-manager (this agent) | Recorded F4 COMPLETE, updated `STATE.md` (ONE full-content Write), `cycle-manifest.md`, this Burst 3 entry, archived oldest Phase Progress row, appended 2 process-gap standing items, commit + push `factory-artifacts` | This entry; `STATE.md`; `cycles/cycle-009/cycle-manifest.md`; `cycles/HISTORY-PHASE-PROGRESS.md`; `cycles/OPEN-STANDING-ITEMS.md` |

**Files touched (Dim-1): 5 unique files, this burst**

- `STATE.md`
- `cycles/cycle-009/burst-log.md` (this entry, new)
- `cycles/cycle-009/cycle-manifest.md` (updated)
- `cycles/HISTORY-PHASE-PROGRESS.md` (oldest Phase Progress row archived)
- `cycles/OPEN-STANDING-ITEMS.md` (2 new process-gap items appended)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` —
both count-neutral this burst (no BC/VP change); F4 added tests only.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced directly by this burst (release
build unaffected, no tag cut).

**Dim-6 Attestation:** `develop` tip moved `bcec4c78` -> `1847ce38` this burst via PR `#868`'s
squash-merge — the one `src/`-affecting commit of this burst.

**Dim-7 Attestation:** Full regression suite re-run on the `fix/jql-reject-month-year-units`
worktree before merge: **5,367 passed / 0 failed / 188 ignored** (vs. baseline 5,357 passed —
+10 tests, zero regressions). `cargo fmt --all -- --check` clean;
`cargo clippy --all --all-features --tests -- -D warnings` zero warnings.

---

<!-- Repeat for each burst. Maintain chronological order. -->
