---
document_type: session-review
session_date: 2026-06-17
pipeline_mode: MAINTENANCE (Path 10)
reviewer: session-reviewer (adversary model, Sonnet 4.6)
produced_by: session-reviewer
develop_head_at_close: 6f24748
bundles_delivered: A (PR #524 → ca24200), B (factory-artifacts @ 20d2441), C-Story1 (PR #531 → 6f24748), C-Story2 (PR #527 → d56dcfc)
status: COMPLETE
---

# Session Review — 2026-06-17 Maintenance Sweep + Remediation

## Executive Summary

The 2026-06-17 maintenance sweep ran 6 of 11 applicable sweeps (5 skipped as N/A for a
CLI-only Rust product), returned GREEN across all gates, and produced 28 distinct findings
classified into Bundles A/B/C/D. All planned remediations were delivered:

- Bundle A: PR #524 (doc accuracy) MERGED
- Bundle B: factory-artifacts @ 20d2441 (factory spec sync) COMMITTED; SC-03/05 deferred
- Bundle C Story 2 (CR-002 JSON-render unification, #526): PR #527 MERGED, 3 F5 rounds
- Bundle C Story 1 (CR-001 + CR-007, #525): PR #531 MERGED, 2 F5 rounds
- Bundle D holdout freshness: deferred to next CLAUDE.md / holdout revision pass

Adversarial review (F5) caught 3 genuine defects the implementer/initial-spec pass missed:
2 compact-JSON bypass sites (S-526) and 1 propagating misattributed citation (S-525). Both
lessons are now codified and durable. One process gap (keyring test hygiene) and one tooling
gap (mutants.toml examine_globs not covering issues.rs/cache.rs) were surfaced by F6 but
have inconsistent codification status.

Overall verdict: **HIGH-VALUE SWEEP**. Adversarial rigor was proportionate; the catch rate
justifies the F5 investment even for LOW-severity maintenance items.

---

## Dimension 1 — Sweep Effectiveness

### Coverage: 6/11 sweeps run; 5 skipped as N/A

Skipped sweeps:
- Sweep 5 (performance benchmarks): no baseline exists — skip is correct and documented.
- Sweep 6 (DTU): `dtu_required: false` — correct.
- Sweeps 9 and 10 (UI/responsive): CLI-only product — correct.

No evidence that any skipped sweep masked a real finding. The 6 executed sweeps achieved
comprehensive coverage of the relevant surface: security, docs, code patterns, spec coherence,
holdout freshness, and tech debt monitoring.

### False-positive rate: LOW

Of the 28 total findings across Bundles A/B/C/D, every finding that was advanced to
remediation proved genuine:
- Bundle A: 11 doc findings — ALL confirmed real (architecture tree had flat-file references
  to module directories that no longer exist; DRIFT-D4/OQ-5 confirmed zero JSON implementation
  in auth/status.rs against source).
- Bundle B: 7 factory-spec findings — ALL confirmed real (frontmatter counts verifiably
  stale; ADR-0016 content divergence confirmed by diff; JRACLOUD citation correction
  verified against PR #364 and CLAUDE.md).
- Bundle C: 3 code findings — ALL confirmed real (grep and line-number evidence provided
  for each; pattern divergence between get_changelog and list_comments verified in code).
- Bundle D: 3 holdout findings — 2 confirmed (H-007 mechanism drift substantiated;
  H-027 self-contradiction clear); H-044 medium-confidence; none are false positives.

Zero findings were speculative or retracted during implementation. False-positive rate: 0%.

### Value delivered

The sweep surfaced a HIGH-confidence architecture documentation failure that had real AI
agent impact: DRIFT-D4/OQ-5 (CLAUDE.md claiming `auth status --output json` is implemented
when it has zero JSON code). This would cause any AI agent reading CLAUDE.md to misinform
users about a capability. That single HIGH finding alone justifies the sweep cost.

The CR-001 anti-stall guard and the JSON-render unification (CR-002) are genuine reliability
and maintainability improvements. CR-007's cache write-error alignment removes a silent error
discard that contradicted the documented two-model policy.

**Sweep effectiveness verdict: HIGH SIGNAL, ZERO NOISE.**

---

## Dimension 2 — Adversarial Value

### Catch summary: 3 real defects in 5 F5 rounds (2 stories)

**S-526 (CR-002 JSON-render unification) — 3 rounds to converge:**

- Round 1 diff: submitted. F5 identified F-1 (missing site) and C-1 (compact
  `serde_json::json!` Display site in project.rs missed entirely by the initial
  grep-negation verification approach).
- Root cause: AC-002 originally specified `grep -rn "serde_json::to_string_pretty" src/cli/ | wc -l == 0`
  as the verification. A compact `serde_json::json!({...})` call with `Display` formatting
  in a `println!` context does NOT use `to_string_pretty` — the grep was semantically
  incomplete. The bypass sites were real; they would have emitted compact JSON from
  `handle_jsm_create` and `project fields` while all other `--output json` paths emitted
  pretty JSON. F5 caught the non-uniform behavior contract.
- Round 3 converged with both sites fixed and AC-002 rewritten to use enumeration-based
  audit (count all `OutputFormat::Json` arms) rather than grep negation.

Catch rate for S-526: 2 bypass sites / approximately 26 total sites = **~8% residual bypass
rate post-implementer-review**. This is a high catch rate for what was described as a
"mechanical batch" refactor.

**S-525 (CR-001 + CR-007 guard + cache alignment) — 2 rounds to converge:**

- Round 1 diff: F5 identified C-1/C-2: the `get_changelog` code comment block in
  `src/api/jira/issues.rs` still contained `JRACLOUD-94357-class` — the exact misattributed
  citation being purged. Additionally, the F1 delta analysis document
  `.factory/phase-f1-delta-analysis/bundle-c-2026-06-17.md` also referenced it.
- Root cause: The implementer fixed the target site (the new `list_comments` guard had no
  citation, per spec) but did not propagate the citation removal to the sibling source of
  truth (`get_changelog` comment that was the reference implementation for the guard
  pattern) or to the upstream analysis document that had cited the issue to explain the
  defect class.
- Round 2 converged after symmetric removal from both locations.

Catch rate for S-525: 1 citation leak propagating to 2 locations, neither of which was in
scope for the implementer's change — **100% of residual citation exposure caught**.

### Catch rate interpretation

5 F5 rounds delivered 3 real findings across 2 stories. That is a meaningful catch rate
for LOW/MED severity maintenance items, which are the type most at risk of light-touch
implementation that misses adjacent context. The adversary's independent perspective
provided genuine cognitive diversity: the implementer focused on the NEW guard while the
adversary assessed the EXISTING sibling comment; the implementer counted `to_string_pretty`
calls while the adversary enumerated all `OutputFormat::Json` arms.

### Were the codified lessons the right takeaways?

**LESSON-CENTRALIZATION-AC-GREP:** Yes. The root cause was precisely "grep negation for
centralization claim is insufficient when the centralization target (pretty-print output)
can be reached through multiple syntactic paths." The lesson correctly generalizes to any
AC that claims "all X sites now use Y" — the verification must enumerate all sites using
the semantic criterion, not negate one syntactic form. This is a durable, actionable rule.

**LESSON-CITATION-SIBLING-PROPAGATION:** Yes. The root cause was precisely "citation removal
applied at the new site but not grepped for sibling occurrences." The lesson correctly
identifies that citation removals are not self-contained edits — they must be applied to
all locations that copied or referenced the citation. This is a durable, actionable rule.

Both lessons are codified in `.factory/cycles/cycle-001/lessons.md` AND in STATE.md
standing constraints — the dual location ensures they survive session clear.

---

## Dimension 3 — Process Gaps and Follow-up Tracking

### Gap 1: #526-F6-KEYRING-GATE

**Status:** Tracked in STATE.md Drift Items. Item: `auth_profiles::global_profile_flag_targets_auth_status` is not gated behind `JR_RUN_KEYRING_TESTS=1` unlike its sibling keyring tests. Can hang under macOS Keychain contention.

**Assessment:** This IS tracked as a LOW drift item with status "OPEN — follow-up." No
codified LESSON exists for this gap pattern (pre-existing test hygiene divergence from a
documented gating convention). The tracking is sufficient for a LOW item; a LESSON or
follow-up story would raise the response level appropriately but is not mandatory.

**Recommendation:** Track as a follow-up story (1–2 line fix: add `#[ignore]` + env-gate
to the un-gated test). Complexity is trivial enough for a quick-dev-route delivery rather
than full F1–F7. No lesson codification needed beyond the existing `JR_RUN_KEYRING_TESTS`
documentation in CLAUDE.md.

### Gap 2: mutants.toml examine_globs not covering issues.rs or cache.rs

**Status:** NOT tracked as a drift item. NOT codified as a lesson.

During S-525's F6 formal hardening, the diff-scoped mutation approach (`--in-diff DIFF_FILE`)
was used rather than the examine_globs baseline, which meant issues.rs and cache.rs received
mutation testing despite not being in `examine_globs`. This worked correctly for the PR
scope. However, the examine_globs file has not been updated to reflect the new critical
functions added over the maintenance cycle. Specifically, `get_changelog` (the reference
implementation for the stall-guard pattern) and `list_comments` (the new guard) are not in
examine_globs.

The CLAUDE.md build command uses `--in-diff` for PR-level mutation testing, which bypasses
examine_globs entirely. So this is a gap in the BASELINE mutation testing posture (full
repo scan path), not in the per-PR verification path.

**Assessment: UNTRACKED process gap.** The diff-scoped path works correctly. The risk is
that a future contributor running `cargo mutants` without `--in-diff` gets mutation coverage
only on the 7 files in examine_globs, missing all API pagination logic. Given that
`src/api/jira/issues.rs` is one of the highest-risk files in the codebase (contains the
search anti-loop guards, the stall guard, and the changelog pagination), its absence from
examine_globs is a meaningful gap.

**Recommendation:** Add `src/api/jira/issues.rs` and `src/cache.rs` to examine_globs in
`.cargo/mutants.toml` as a follow-up story or direct commit. This is a 2-line config change.
Should be tracked as a drift item or quick-dev story; currently it is neither.

### Gap 3: LESSON-CENTRALIZATION-AC-GREP — codification completeness

**Status:** Codified in lessons.md and STATE.md standing constraints. COMPLETE.

The lesson is present in both durable locations. The specific implication for future stories
(any AC claiming "all X migrated to Y" must enumerate, not negate) is actionable. No
follow-up needed beyond ensuring the lesson is applied at the next centralization story's
F1 or story-writing phase.

### Gap 4: LESSON-CITATION-SIBLING-PROPAGATION — codification completeness

**Status:** Codified in lessons.md and STATE.md standing constraints. COMPLETE.

The lesson is actionable: "grep ALL sibling occurrences (reference-impl comments,
upstream analysis docs) when removing any external-tracker citation." The F1 delta analysis
document as a citation propagation source is a non-obvious artifact class — the lesson
explicitly calls out "upstream analysis docs" which is the right generalization.

### Gap 5: H-007 holdout mechanism drift (Bundle D)

**Status:** Documented in holdout-freshness.md. NOT yet committed to holdout-scenarios.md
(read-only sweep; no `lifecycle_status` field exists in the holdout schema).

The gap is accurately classified: the H-007 scenario's substring outcome still passes but
its documented mechanism (reactive POST-400) is now the fallback rather than the primary
path (ADR-0015 / BC-3.2.013 added proactive pre-POST enforcement). This is a correctness
issue for any evaluator who needs to understand WHY the behavior occurs.

**Assessment:** This is an OPEN process gap. The holdout-freshness sweep identified it
correctly but the remediation (updating H-007 + possibly adding `lifecycle_status` field)
has not been scheduled or tracked. Bundle D items were prioritized after Bundles A/B/C in
the sweep recommendations and were deferred.

**Recommendation:** Create a tracking item or brief follow-up story for H-007 revision
(repoint mechanism description to BC-3.2.013; retain reactive path as documented fallback).
This should be batched with H-027's prose cleanup and the `lifecycle_status` schema decision.

---

## Dimension 4 — Cost vs Value Assessment

### Rough proportionality assessment

The three Bundle C items (CR-001, CR-002, CR-007) were all classified LOW severity with
LOW regression risk. They were addressed via the full F1–F7 Feature Mode pipeline
(F1 delta analysis, F2 spec evolution, F3 story decomposition, F4 TDD implementation,
F5 adversarial review, F6 formal hardening, F7 convergence check). This is the heaviest
available process weight.

**Was the full F1–F7 pipeline proportionate?**

For CR-001 (list_comments guard): the full pipeline was justified. A new BC was authored
(BC-2.4.043), wiremock integration tests were required, and a bounded-time termination
test was added during F6 beyond what the story spec required. The F5 catch (citation leak
propagating to a sibling comment) would have been missed without adversarial review — and
the citation was load-bearing (CLAUDE.md explicitly flags JRACLOUD citation discipline as
a gotcha with real consequences). The pipeline cost was proportionate.

For CR-002 (JSON-render unification): the full pipeline was also justified, though marginally
so. The story was described as "mechanical batch, zero behavioral change, no new tests" —
which would suggest a lighter process weight. However, F5 caught 2 genuine bypass sites
that would have left a non-uniform output-channel behavior post-merge. A lighter process
(e.g., direct PR review without separate F5 adversarial) would have missed these. The
catch rate of ~8% residual bypass sites on a nominally-trivial mechanical refactor argues
for keeping F5 even on low-severity centralization changes.

For CR-007 (cache write-error alignment): the full pipeline was proportionate given its
co-delivery with CR-001. Independently it would have been a quick-dev-route candidate
(1–3 lines of code change, no new tests required beyond convention alignment), but
bundling with CR-001 made the combined story-level verification worthwhile.

### Right-sizing recommendation for future maintenance-mode code fixes

The current project convention states "all fixes through full VSDD Feature Mode pipeline."
This blanket rule prevents the class of "quick fix that introduces a subtle defect" seen in
prior cycles. The 2026-06-17 maintenance evidence reinforces this: even LOW-severity items
with "no behavioral change" (CR-002) had a ~8% residual bypass rate caught only by F5.

**Recommended right-sizing guidance:** Rather than bypassing F5 for low-severity items,
right-size the F5 INSTRUCTION rather than the process. For mechanical refactors:

1. Make the AC verification criterion enumeration-based (not grep-negation) — this
   directly addresses LESSON-CENTRALIZATION-AC-GREP and gives F5 a high-signal target.
2. Explicitly scope F5 to "verify enumeration is complete and no undisclosed behavior
   change exists" rather than a full open-ended adversarial pass.
3. For pure doc-only Bundle A changes, F5 can reasonably be replaced by pr-reviewer alone
   since there is no code to have undisclosed behavior changes on.

Bundle D (holdout freshness) was correctly handled as read-only sweep findings without
Feature Mode overhead — that level is appropriate for holdout prose updates.

---

## Top 3 Improvement Recommendations

### Recommendation 1: Add issues.rs and cache.rs to .cargo/mutants.toml examine_globs

**Evidence:** The diff-scoped mutation path (`--in-diff`) correctly covered S-525's guard
during PR-level verification, but `src/api/jira/issues.rs` and `src/cache.rs` are absent
from the baseline `examine_globs`. Issues.rs contains the highest-risk pagination logic
in the codebase (JRACLOUD-95368 anti-loop, the new stall guard, changelog pagination).

**Action:** Add `"src/api/jira/issues.rs"` and `"src/cache.rs"` to `examine_globs` in
`.cargo/mutants.toml`. 2-line config change. Quick-dev route or direct commit.

**Risk:** LOW. Extends baseline mutation coverage; no behavior change.

### Recommendation 2: Schedule H-007 holdout revision as a tracked follow-up

**Evidence:** H-007's mechanism description (reactive POST-400 flow) is now stale after
ADR-0015/BC-3.2.013 added proactive pre-POST enforcement. The substring outcome still
passes but an evaluator reading the scenario gets a wrong mental model of how the behavior
is implemented. This is untracked in STATE.md Drift Items.

**Action:** Add a Drift Item for H-007 revision (update mechanism description to BC-3.2.013;
retain reactive path note). Batch with H-027 prose fix and `lifecycle_status` schema decision.
No story needed — factory-artifacts commit or Bundle D follow-up PR.

**Risk:** LOW. Doc-only change; no code impact.

### Recommendation 3: Add a quick-dev-route exemption path for test-hygiene micro-fixes

**Evidence:** #526-F6-KEYRING-GATE (un-gated keyring test) is a 1–2 line fix tracked as
a LOW drift item. Running the full F1–F7 pipeline for a `#[ignore]` annotation addition
is disproportionate overhead. The current standing constraint ("all fixes through full VSDD
Feature Mode pipeline") does not distinguish between 1-line test hygiene and genuine
feature implementation.

**Action:** Codify a "quick-dev-route" exemption for test hygiene changes (add/remove
`#[ignore]`, fix test gate conditions, add `JR_RUN_KEYRING_TESTS` guard to existing tests)
that: (a) touch no production src/ code, (b) have a 1-file diff, (c) cannot affect behavior
contracts. Such changes go through PR + pr-reviewer + CI gate but skip F1–F6. Apply
immediately to resolve #526-F6-KEYRING-GATE.

**Risk:** LOW. Scoped by the "no production src/" constraint; the full pipeline continues
to apply to all non-trivial changes.

---

## Process Gaps Summary

| Gap ID | Description | Tracked? | Recommended Action |
|--------|-------------|----------|--------------------|
| LESSON-CENTRALIZATION-AC-GREP | Centralization ACs must use enumeration not grep-negation | YES — lessons.md + STATE.md | No further action needed |
| LESSON-CITATION-SIBLING-PROPAGATION | Citation removal must propagate to sibling occurrences | YES — lessons.md + STATE.md | No further action needed |
| #526-F6-KEYRING-GATE | Un-gated keyring test can hang | YES — STATE.md Drift Items | Quick-dev-route fix (see Rec 3) |
| examine_globs gap (issues.rs, cache.rs) | Baseline mutation testing misses highest-risk pagination files | **NOT TRACKED** | Add to mutants.toml (see Rec 1) |
| H-007 holdout mechanism drift | Stale reactive-path mechanism description; ADR-0015 changes primary path | **NOT TRACKED** in Drift Items | Add drift item + H-007 revision (see Rec 2) |
| H-027/H-044 holdout prose | Internal contradiction + ADF mention-drop parenthetical staleness | Documented in holdout-freshness.md only | Batch with H-007 revision |
| lifecycle_status field absent from holdout schema | Cannot mark scenarios stale without schema addition | Noted in holdout-freshness.md only | Design decision; low urgency |

---

## Untracked Process Gaps Requiring Immediate Follow-Up

Two gaps identified above have no current tracking in STATE.md Drift Items and need entries:

1. **mutants.toml examine_globs gap** — `src/api/jira/issues.rs` and `src/cache.rs` absent
   from baseline mutation scope despite containing the project's highest-risk pagination
   logic. Recommended: add Drift Item `MAINT-MUTANTS-GLOBS-01` (LOW, process gap).

2. **H-007 holdout mechanism drift** — mechanism description stale post-ADR-0015; not in
   Drift Items. Recommended: add Drift Item `MAINT-HOLDOUT-H007-DRIFT` (LOW, doc gap).
