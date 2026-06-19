---
document_type: session-review
session_date: 2026-06-19
pipeline_mode: MAINTENANCE (Path 10)
reviewer: session-reviewer (adversary model, claude-sonnet-4-6)
produced_by: session-reviewer
develop_head_at_open: 71f33c6 (v0.6.0-dev.5)
develop_head_at_close: 6bdb251
bundles_delivered:
  - "Bundle A partial (PR #543 merged — DRIFT-D13/D15/D16/D9/CR-010)"
  - "Bundle A partial (factory-artifacts aa11887 — DRIFT-D14/SC-01/LOC-CANONICAL/RISK-ANNOTATIONS)"
  - "Bundle B (factory-artifacts aa11887 — H-NEW-MP-001/H-007/H-027)"
  - "Bundle D carry-forward: 6 S-MAINT-* draft stories registered (89 total)"
prior_session_review: .factory/maintenance/2026-06-17/session-review.md
status: COMPLETE
---

# Session Review — 2026-06-19 Maintenance Sweep

## Executive Summary

The 2026-06-19 maintenance sweep ran 5 of 11 applicable sweeps (6 skipped as N/A or
no-baseline for a CLI-only Rust product), returned GREEN on all maintenance gates, and
produced 17 distinct findings classified into Bundles A–E. All planned remediations were
delivered within the session:

- Bundle A doc accuracy (CLAUDE.md/ADR/prd): PR #543 MERGED → develop @ 6bdb251
- Bundle A factory-artifacts (prd counts, L2 bc_count, LOC table, risk register): committed aa11887
- Bundle B holdout freshness (H-NEW-MP-001/H-007/H-027): committed aa11887
- Bundle C CI timeout (CR-010): included in PR #543
- Bundle D code refactors: 6 S-MAINT-* draft stories registered; Feature Mode deferred
- Bundle E bookkeeping: 4 prior-cycle items archived to cycle-001/blocking-issues-resolved.md

Drift register reconciled at 9a16518. All 5 HIGH/MED items from the prior (2026-06-17) run
are confirmed resolved. The sweep closed IDLE with develop 1 commit ahead of v0.6.0-dev.5.

Overall verdict: **CLEAN, EFFICIENT SWEEP — MEDIUM VALUE RELATIVE TO PRIOR RUN.**
This was a tighter sweep than 2026-06-17: no code defects found, no adversarial cycles
required, no production-behavior issues. The value delivered was doc-integrity and spec
accuracy work. The one HIGH finding (DRIFT-D13 dead research citations) was real and
meaningful; the rest were LOW/MINOR housekeeping.

---

## Dimension 1 — Sweep Effectiveness

### Coverage: 5 sweeps run; 6 skipped

Sweeps run: Dependency audit (1), Documentation drift (2), Pattern consistency/lint health (3),
Holdout freshness (4), Spec coherence/tech debt/risk monitoring (7+8+11 combined).

Sweeps skipped:
- Sweep 5 (performance benchmarks): no baseline exists — correct and documented (recurring gap,
  see Coverage Gaps section below).
- Sweep 6 (DTU): `dtu_required: false` — correct.
- Sweeps 9 and 10 (UI/responsive): CLI-only product — correct.

### Finding yield per sweep

| Sweep | Findings | Severity breakdown | Signal ratio |
|-------|----------|-------------------|--------------|
| 1 — Dependency audit | 8 entries | 0 security / 8 LOW housekeeping | LOW signal — GREEN |
| 2 — Doc drift | 5 findings | 1 HIGH / 1 MED / 3 LOW | MEDIUM signal |
| 3 — Pattern consistency | 3 new findings | 0 CRITICAL / 0 HIGH / 3 LOW | LOW signal |
| 4 — Holdout freshness | 3 findings | 1 functional (hard) / 1 mechanism / 1 narrative | HIGH signal (H-NEW-MP-001 was evaluator-breaking) |
| 7+8+11 — Spec coherence | 6 findings | 0 CRITICAL / 2 MINOR / 4 LOW | LOW-MEDIUM signal |

**Best performer:** Holdout freshness sweep (Sweep 4). H-NEW-MP-001 (`--story-points` flag
removed; only `--points` parses) was the only evaluator-breaking finding in the entire run.
Without this sweep, a Phase 4 evaluator would have failed on a clap parse error rather than
on the actual assertion. That single find justified the full sweep cost.

**Weakest performer:** Dependency audit (Sweep 1). GREEN with zero CVEs and zero RUSTSEC
advisories. All findings were routine housekeeping (14 stale deny.toml skip entries pending
a `cargo update`). This is the expected outcome for a well-maintained Rust crate; the GREEN
result itself is the value delivered.

**Doc drift (Sweep 2)** produced the only HIGH finding: DRIFT-D13 (four
`.factory/research/issue-361-*.md` files cited in CLAUDE.md Gotchas do not exist). These
files back the load-bearing JRACLOUD-95368 attribution and JQL ORDER BY wording constraints.
The finding is structurally identical to the ADR-0014 citation-without-file class identified
in prior runs — see Pattern Detection section.

### Prior-run finding resolution: 9/12 FIXED (prior), 1 PARTIALLY FIXED, 1 OPEN

Of 12 prior-run findings, 9 were fully resolved (all HIGH and MED cleared). DRIFT-D9
(ADR-0014 missing) was STILL OPEN but actioned in this run (ADR reconstructed and committed
in PR #543). DRIFT-D10 was PARTIALLY FIXED (new sub-drift introduced). The prior-run H-007
and H-027 holdout items remained open from the 2026-06-17 run's Bundle D deferral; both
were actioned in this session's aa11887 factory-artifacts commit.

---

## Dimension 2 — False-Positive Rate

**False-positive count: 1 (downgrade, not a false positive in the strict sense)**

The one candidate retraction was **H-044** from the prior run: downgraded from STALE-CANDIDATE
to FRESH. This was not a false positive by the prior sweep — the prior sweep correctly marked
it "medium confidence stale." The current sweep re-verified source (`src/adf.rs` mention-drop
`_` arm still current after post-2026-05-20 ADF passes) and correctly downgraded. The prior
scan's medium-confidence hedging was appropriate.

All 17 new findings that were advanced to remediation proved genuine. Zero findings were
retracted during implementation. The DRIFT-D9 ADR-0014 carry-forward was not a false
positive — the file genuinely did not exist, and the fix correctly created it.

**Pattern observation:** The doc-drift sweep produced zero false positives. The verification
table (31 checked items, all PASS or correctly flagged as drift) represents high-quality scan
work with no speculative findings. The holdout sweep similarly: CLI surface cross-check
verified against a live binary (`./target/debug/jr`), avoiding the stale-manifest class of
false positives that can arise from checking file content without running the binary.

---

## Dimension 3 — Fix Quality

### PR #543 (DRIFT-D13/D15/D16/D9/CR-010)

**Approach taken:** Rather than creating the four missing research files from scratch
(which would have required reconstructing verification evidence), the fix removed the dead
"Detail:" citations from CLAUDE.md while preserving all behavioral prose. This is a valid
choice — the behavioral constraints (ORDER BY hint wording, JRACLOUD-95368 literal, citation
discipline policy) remain present in the Gotcha bodies; only the broken links were removed.

**Assessment: SOUND.** The fix is conservative and honest. The constraints are load-bearing
and preserved; the broken audit trail is now absent rather than misleading. A stronger fix
would have created the research files, but that requires re-verification work (Perplexity
search, evidence reconstruction) that is properly a separate story. The PR description
accurately documents what was done vs what was deferred.

**DRIFT-D9 (ADR-0014):** The fix created a reconstructed ADR from available context
(CLAUDE.md Gotchas, dispatch fork behavior described in the codebase). The ADR was added
to both `docs/adr/` and `docs/adr/` reference list, and a Key Decisions entry was added to
CLAUDE.md. This is substantively better than an "(ADR not yet written)" annotation.

**CR-010 (timeout-minutes):** 1-line YAML fix, zero risk, verified in PR.

**CI status at close:** Count guards (all 3) exit 0 at 9a16518. develop @ 6bdb251.

### Factory-artifacts commit aa11887

Touched `holdout-scenarios.md`, `prd/README.md`, `specs/domain-spec/bc-02-issue-read.md`,
`CANONICAL-COUNTS.md`, and `architecture/risk-register.md`. All changes are prose-only,
verifiable against ground truth (LOC via `wc -l`, BC counts via BC-INDEX.md frontmatter).

**H-NEW-MP-001 fix (highest urgency item):** `--story-points 5` replaced with `--points 5`
on holdout-scenarios.md line 480. Correct — config-key references to `story_points_field_id`
on adjacent lines were explicitly NOT changed (those are config keys, not CLI flags). The
distinction was noted and correctly preserved.

**H-007 mechanism update:** Re-pointed from reactive BC-3.2.009 (POST-400) to proactive
BC-3.2.013 (pre-POST exit 64). Reactive backstop retained as fallback notation. Correct.

**No rework loops observed.** The factory-artifacts commit and PR #543 both landed cleanly.

---

## Dimension 4 — Cost vs Value

### What was delivered

1. One HIGH doc-integrity fix: DRIFT-D13 (dead research citations backing load-bearing
   constraints). This is the most meaningful outcome — any AI agent or developer following
   "Detail:" pointers for JRACLOUD-95368 attribution was getting dead links.
2. One missing ADR recovered: ADR-0014 (JSM request-type dispatch fork). This closes a
   gap that was STILL OPEN across multiple prior sweeps. The ADR now exists and is referenced
   correctly from all four callsites.
3. One evaluator-breaking holdout fixed: H-NEW-MP-001. Without this fix, the next Phase 4
   holdout run would fail on a CLI parse error rather than the assertion being tested.
4. Three stale risk register annotations resolved: R-M0 (--verbose SD-003), R-H288-1
   (JSM scope), R-M288-1 (dispatch fork). Process hygiene, no code impact.
5. Six S-MAINT-* draft stories registered for future Feature Mode delivery, bringing total
   story count to 89. These correctly defer code changes to proper Feature Mode cycles.

### Was full delegation worth it for doc-level findings?

The 2026-06-17 session review (Recommendation 3 from that run) noted that pure doc-only
Bundle A changes could reasonably skip F5 adversarial review, using pr-reviewer alone.
This run followed that implicit logic: no F5 adversarial cycle was used for Bundle A
(doc-only changes). PR #543 used pr-reviewer, which is appropriate.

**For this class of maintenance sweep (doc accuracy, holdout freshness, no production code
changes), the delegation overhead was proportionate.** The sweep produced no code findings
requiring full F1–F7 delivery. The cost was primarily reading sweep reports and executing
targeted fixes, not adversarial cycles.

**Rough token estimate vs value:** The sweep session produced 5 fix deliverables (PR #543,
aa11887 commit, drift register reconciliation, 6 story drafts, bookkeeping archive) without
any adversarial cycles or rework loops. This is a more efficient sweep than 2026-06-17 (which
ran 5 F5 adversarial rounds across 2 stories). The lower cost reflects a genuinely lighter
finding set — no production code defects were identified.

**Reservation:** The 6 S-MAINT-* draft stories represent deferred work. If those stories are
never delivered (Feature Mode backlog accumulation), the sweep's code-quality findings become
permanent documentation without resolution. That risk is tracked in STATE.md but not yet
mitigated. See Recommendations section.

---

## Dimension 5 — Coverage Gaps

### Gap 1: Performance benchmarks (Sweep 5) — no baseline exists

This is the THIRD consecutive maintenance sweep where Sweep 5 was skipped for "no baseline
exists." This is not a false skip — there genuinely is no performance benchmark suite for
`jr`. However, the recurring skip without a tracked plan to establish a baseline means the
gap is perpetuating itself by default.

**Assessment:** The product is a CLI tool where performance is primarily perceived as command
latency (wall-clock time for `jr issue list`, `jr auth login`, etc.). A baseline is achievable
without a formal benchmarking framework: a simple shell script timing a set of mock-wiremock
commands and recording the results as a reference file would be sufficient for regression
detection. The gap is solvable with low effort if prioritized.

**Recommendation:** Add a draft S-MAINT story to establish a minimal performance baseline
(e.g., `hyperfine` against wiremock-backed commands, baseline stored as `.factory/perf/`).
Until that baseline exists, Sweep 5 will correctly skip each run. The skip is not a process
error; the absence of a follow-up plan is.

### Gap 2: check-bc-cumulative-counts.sh does not check prd/README.md

DRIFT-D14/SC-02-2026-06-19 (README.md BC total 598 vs canonical 599) recurred precisely
because the count-guard scripts do not cover the README Document Map. The gap was identified
in the 2026-06-17 run and is still open (PG-A in STATE.md). The fix has been applied
manually in aa11887, but the structural gap means this can recur with each new BC addition.

**The script gap is the root cause.** The manual fix treats the symptom. Until
`check-bc-cumulative-counts.sh` (or a companion script) validates the prd/README.md Document
Map rows, README drift will require manual discovery in every maintenance sweep.

### Gap 3: DRIFT-D13 "Detail:" audit-trail pattern — no CI check exists

DRIFT-D13 (four dead `.factory/research/issue-361-*.md` citations in CLAUDE.md) is the third
distinct "citation-without-backing-file" class identified in recent sweeps (alongside
ADR-0014 as DRIFT-D9). The 2026-06-17 session review codified LESSON-CITATION-SIBLING-PROPAGATION
(propagate citation removals to all sibling occurrences). But neither that lesson nor any
CI check catches the "Detail: file.md" citation that points to a file that does not exist.

This is a structural vulnerability: any "Detail:" or "See:" pointer in CLAUDE.md to a
`.factory/research/*.md` or `docs/adr/*.md` file that has not yet been written creates a
dead link that misdirects agents and developers. Manual sweeps catch these, but they can
persist across multiple runs (DRIFT-D9 persisted through two consecutive sweeps before
being actioned).

---

## Dimension 6 — Process Gaps / Lessons

### [process-gap] PG-MERGE-APPROVAL: pr-manager refused coordinator-relayed merge approval

The prompt states that the pr-manager refused coordinator-relayed merge approval, forcing
the orchestrator to merge PR #543 directly. This pattern reflects a genuine guardrail
mismatch: the pr-manager agent is designed to be the terminal authority on PR merge
decisions, but the merge approval in this case came via the orchestrator as relay rather
than directly from the human.

**Assessment:** This is a T2/T3 tier boundary issue, not a bug. The pr-manager's refusal
to accept coordinator-relayed authorization is the CORRECT behavior — it prevents the
orchestrator from authorizing merges without a direct human signal. The failure mode is
"orchestrator had to merge directly" which bypasses the pr-manager's safety check. The root
cause is that the maintenance workflow did not route merge authorization correctly through
the pr-manager's expected channel.

**Recommended action:** Codify in the maintenance workflow that merge authorization for
maintenance-sweep PRs must be presented to the pr-manager directly from the human (via the
pr-manager's tool/interface), not relayed through the orchestrator. The orchestrator should
request authorization and then hand off to the pr-manager with the authorization token, not
relay it. This is a workflow sequencing fix, not a pr-manager prompt change.

**Severity:** LOW. The end result (merge) was correct. The bypass bypasses the pr-manager's
audit trail for the merge event, which is a minor process degradation rather than a security
or correctness issue. However, if the orchestrator-direct-merge path becomes common, it
normalizes a pattern that undermines the pr-manager's role as a safety check.

**Track as:** [process-gap] MAINT-PG-PR-MERGE-CHANNEL (new, not yet in STATE.md).

### [process-gap] PG-DOC-DRIFT: Recurring CLAUDE.md/README drift from src — would a CI guard help?

This is the fourth sweep where CLAUDE.md/README documentation drift was identified as a
maintenance finding. The pattern is consistent:
1. A source change is made (new file, renamed flag, changed behavior).
2. The documentation is not updated in the same PR.
3. The next maintenance sweep catches the drift.

The question is whether a CI doc-drift guard would reduce the frequency. Two types of drift
occur:

**Type A — File listing drift** (DRIFT-D1/D2/D3 in 2026-06-17, DRIFT-D15/D16 in 2026-06-19):
A new source file is added to `src/` without a corresponding CLAUDE.md architecture tree
entry. This IS amenable to a CI guard: a script that diffs `find src/ -name '*.rs' -not
-path '*/target/*'` against the CLAUDE.md tree. However, the architecture tree is a curated
summary, not a 1:1 manifest. A strict guard would have many false positives (test helpers,
generated files). A reasonable guard would only check named source files that appear in the
CLAUDE.md tree conventions (production modules under `src/cli/`, `src/api/`, `src/types/`).

**Type B — Behavioral claim drift** (DRIFT-D4, DRIFT-D8, DRIFT-D13): A behavior changes
(e.g., `--verbose` becomes header-only; auth status gets/loses JSON support) but CLAUDE.md
continues to describe the old behavior. This is NOT amenable to a simple CI guard — it
requires semantic understanding of behavior vs documentation.

**Recommendation:** A CI guard for Type A (file-listing drift) is feasible and would prevent
the DRIFT-D15/D16 class. A lint script that verifies every `src/cli/*.rs` and `src/api/*.rs`
file appears in CLAUDE.md, or that CLAUDE.md's tree does not reference files that don't
exist, would catch both directions. Given that this class appeared in two consecutive sweeps,
a light CI guard is warranted.

**Track as:** [process-gap] MAINT-PG-CI-DOC-LINT (new story candidate).

### [process-gap] PG-DEAD-CITATIONS: CLAUDE.md "Detail:" file pointers — should there be a CI check?

DRIFT-D13 exposed a pattern where "Detail:" and "See:" citations in CLAUDE.md point to
`.factory/research/*.md` files that have never been created. The 2026-06-17 session review
noted the citation discipline problem but codified only LESSON-CITATION-SIBLING-PROPAGATION
(which addresses removal, not existence). The existence check is a separate, simpler problem.

A CI script checking that every `Detail: .factory/research/*.md` and
`docs/adr/NNNN-*.md` file referenced in CLAUDE.md exists on disk would catch DRIFT-D9 and
DRIFT-D13 at PR time rather than at the next maintenance sweep. This is an O(n) grep across
CLAUDE.md against a filesystem check — low effort, high catch rate for this drift class.

**Recommendation:** Add a `scripts/check-claude-md-citations.sh` that:
1. Extracts all `Detail: <path>` and `.factory/research/<file>` and `docs/adr/<file>` patterns
   from CLAUDE.md.
2. Verifies each referenced file exists on disk.
3. Exits 1 with a list of dead references if any are missing.

This is a 20–30 line bash script. It would have caught DRIFT-D13, DRIFT-D9 (in its original
form), and the prior-run issue-361 citation class. Wire into CI as a `check` step alongside
the three existing count guard scripts.

**Track as:** [process-gap] MAINT-PG-DEAD-CITATION-CI (new story candidate, HIGH value for
a LOW effort implementation).

---

## Dimension 7 — Quality Signal Analysis

### Maintenance gate results

| Gate | Result |
|------|--------|
| Zero critical CVEs | PASS — 0 RUSTSEC advisories |
| Clippy clean (-D warnings) | PASS |
| cargo fmt --check | PASS |
| check-spec-counts.sh | PASS |
| check-bc-cumulative-counts.sh | PASS (599 total) |
| check-bc-no-numeric-test-counts.sh | PASS |
| No BLOCKING findings | PASS |

### Holdout freshness: 53/57 FRESH (93%)

4 stale scenarios, 1 of which was evaluator-breaking (H-NEW-MP-001). The 93% freshness rate
is good; the flag-drift failure class (a CLI flag renamed without updating holdout action
lines) is a structural risk that will recur as the CLI evolves. The holdout sweep is correctly
positioned as a mandatory maintenance step precisely because of this class.

### Drift register: healthy at 28 open items, all LOW

3 HIGH items resolved since 2026-06-17 run (FORK-OPS-SIGN-INJECTION, FORK-OPS-ALPHA-RACE,
FORK-OPS-GITLEAKS-DOC). Zero HIGH items remain open. The drift register is in a healthy
state: the 28 open items are all LOW severity, many are accepted or justified deferrals.
The 6 S-MAINT-* stories registered in this sweep (89 total) correctly capture the code
quality findings for future Feature Mode delivery.

---

## Dimension 8 — Pattern Detection (Cross-Run Comparison)

### Patterns improving since 2026-06-17

1. **HIGH finding rate declining.** 2026-06-17 had 4 HIGH findings (DRIFT-D1/D2/D3/D4 plus
   fork-ops security issues). 2026-06-19 had 1 HIGH finding (DRIFT-D13, doc-accuracy only).
   The security surface is cleaner; the architecture tree is substantially accurate.

2. **No code defects requiring adversarial cycles.** 2026-06-17 required 5 F5 adversarial
   rounds across 2 stories (S-525, S-526). 2026-06-19 required zero adversarial cycles.
   The production code quality is improving between sweeps.

3. **Holdout evaluation path is blocked by one recurring skip.** H-007 and H-027 were open
   across TWO consecutive sweeps before being actioned. The prior-run Bundle D deferral
   pattern ("holdout items addressed last, sometimes carried over") is a systematic gap.
   Items deferred from Bundle D should be tracked explicitly in STATE.md to prevent
   multi-sweep carryover.

### Recurring patterns of concern

1. **"Citation-without-backing-file" class persists.** DRIFT-D9 (ADR-0014) appeared in at
   least two consecutive sweeps before being resolved. DRIFT-D13 (issue-361 research files)
   is a new instance of the same class. Each sweep, the maintenance agent must manually check
   all "Detail:" and "See:" citations. This is a chronic cost with a CI-automatable solution
   (see PG-DEAD-CITATIONS above).

2. **prd/README.md Document Map drift is structural.** DRIFT-D10 (2026-06-17) became DRIFT-D14
   (2026-06-19) — the same file, the same kind of drift, one BC further behind each time.
   This will recur every time a new BC is added without updating the README. The PG-A drift
   item is correctly open in STATE.md, but the structural fix (extending count guards to cover
   README) has not been actioned.

3. **Perf baseline absence is perpetuating.** Three consecutive sweeps have skipped Sweep 5.
   No follow-up plan exists. This is not a crisis for a CLI tool, but the gap is now a known
   untracked risk rather than an accepted limitation.

4. **S-MAINT-* story accumulation without delivery timeline.** This sweep registered 6 new
   draft stories, bringing the backlog to include a growing set of maintenance items with no
   committed delivery cycle. The 2026-06-17 session review flagged this risk; it has not
   been mitigated. If maintenance items accumulate as drafts without Feature Mode cycles,
   the drift register grows without resolution.

---

## Process Gaps Summary

| Gap ID | Description | Tracked? | Recommended Action |
|--------|-------------|----------|--------------------|
| MAINT-PG-PR-MERGE-CHANNEL | pr-manager refused coordinator-relayed merge authorization; orchestrator merged directly | NOT TRACKED | Codify maintenance workflow merge path; route authorization directly to pr-manager, not via orchestrator relay |
| MAINT-PG-CI-DOC-LINT | Recurring CLAUDE.md file-listing drift (Type A) catchable by CI script | NOT TRACKED | New story: `scripts/check-claude-md-tree.sh` verifying src/ files appear in CLAUDE.md tree |
| MAINT-PG-DEAD-CITATION-CI | "Detail:" and "See:" citations in CLAUDE.md pointing to non-existent files; catchable by CI | NOT TRACKED | New story: `scripts/check-claude-md-citations.sh` exit 1 on dead references; wire into CI |
| PERF-BASELINE-ABSENT | Sweep 5 skipped for third consecutive run; no follow-up plan | NOT TRACKED | New draft story: establish minimal `hyperfine` baseline stored in `.factory/perf/` |
| PG-A / DRIFT-README count guard gap | check-bc-cumulative-counts.sh does not cover prd/README.md Document Map | TRACKED (PG-A in STATE.md) | Extend script or add companion; prevents recurring DRIFT-D14 class |

---

## Top 3 Recommendations

### Recommendation 1: Add scripts/check-claude-md-citations.sh to CI (HIGH PRIORITY)

**Evidence:** DRIFT-D13 (dead issue-361 research citations) and DRIFT-D9 (ADR-0014 file not
existing) are both instances of the same "Detail: file.md" citation pointing to a
non-existent file. DRIFT-D9 persisted across two sweeps. DRIFT-D13 is NEW in this sweep —
meaning the citation was introduced at some point without the file existing. A CI check that
runs at PR time would catch both classes at the moment of introduction, before they reach
a maintenance sweep.

**Action:** Create `scripts/check-claude-md-citations.sh` that extracts all path-like
references in CLAUDE.md matching `.factory/research/*.md`, `docs/adr/*.md`, and
`docs/specs/*.md` patterns, then verifies each exists on disk. Add to CI alongside the
existing three count guard scripts. Wire into `ci-gate.needs` per DEC-096/097 (no direct
branch protection wiring).

**Risk:** LOW. Read-only script; no behavioral change. False positives possible if CLAUDE.md
uses hypothetical file paths in prose (rare; constrain regex to "Detail:" and path-like
patterns only). Estimate: 25–40 line bash script, addressable in one quick-dev-route story.

### Recommendation 2: Codify the maintenance-sweep PR merge authorization path

**Evidence:** The pr-manager refused coordinator-relayed merge approval in this session,
forcing the orchestrator to merge PR #543 directly. This created a gap in the pr-manager's
audit trail and normalized a bypass path. The root cause is that the maintenance workflow
sequence does not specify how merge authorization flows from human to pr-manager.

**Action:** Update the maintenance workflow documentation (or `orchestrator-maintenance-sequence`
agent instructions) to specify that human merge authorization for maintenance PRs must be
communicated directly to the pr-manager (not via orchestrator relay). The orchestrator should
present the PR summary to the human, receive approval, and then initiate the pr-manager with
the human approval token in a direct channel. This closes the relay-bypass path.

**Risk:** LOW. Process change only; no code impact. One maintenance workflow doc edit.

### Recommendation 3: Track the three new [process-gap] items in STATE.md immediately

**Evidence:** Three process gaps identified in this review (MAINT-PG-PR-MERGE-CHANNEL,
MAINT-PG-CI-DOC-LINT, MAINT-PG-DEAD-CITATION-CI) have no current tracking. The 2026-06-17
session review identified two untracked gaps that it recommended adding to STATE.md; those
were subsequently added. Following that precedent, this review's new gaps should be added
before the next session starts.

**Action:** Add three rows to STATE.md Drift Items:
1. MAINT-PG-PR-MERGE-CHANNEL (LOW, process gap, orchestrator workflow)
2. MAINT-PG-CI-DOC-LINT (LOW, process gap, CI script candidate)
3. MAINT-PG-DEAD-CITATION-CI (LOW, process gap, CI script candidate — HIGH relative value)

Additionally, add a PERF-BASELINE-ABSENT draft story to the S-MAINT-* backlog (LOW, no
blocking impact, but prevents the perpetuating-skip pattern from continuing into a fourth
consecutive sweep).

**Risk:** NONE. Tracking changes only.

---

## Recommendations for Next Sweep

1. **Run Sweep 5 (performance)** — but only after a baseline story has been delivered. Do not
   skip again without a tracked plan. Register a draft story now.
2. **Check whether `scripts/check-bc-cumulative-counts.sh` has been extended to cover
   prd/README.md** — if not, expect DRIFT-D14 class to recur again.
3. **Verify DRIFT-D13 fix is complete** — specifically, confirm the four issue-361 research
   files are either created or the CI citation check catches future introductions. The removal
   of dead citations from CLAUDE.md (PR #543) is necessary but not sufficient if new
   "Detail:" citations are introduced to non-existent files in future PRs.
4. **Deliver at least 2 of the 6 S-MAINT-* draft stories** before the next maintenance
   sweep — specifically S-MAINT-CR-009 (keyring guard canonicalization) and
   S-MAINT-CR-008 (extract_job_block dedup), both test-only with low risk. If no S-MAINT-*
   stories are delivered between sweeps, the maintenance backlog grows without resolution.

---

## Self-Cost Assessment

Session review cost: analysis of 7 artifacts (5 sweep reports + consolidated + prior session
review) + commit authorship. This review is estimated at LOW cost relative to the pipeline
run (no adversarial cycles, no code changes, single artifact output). Well within the 5%
cost-of-pipeline threshold.
