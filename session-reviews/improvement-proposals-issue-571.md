---
document_type: improvement-proposals
producer: session-reviewer
timestamp: 2026-07-08
cycle: ADF-CODE-MARK-EXCLUSIVITY
issue: 571
review_source: review-2026-07-08-issue-571.md
status: routed-upstream
---

# Improvement Proposals: Issue #571 (ADF-CODE-MARK-EXCLUSIVITY)

**All 13 proposals adjudicated engine-side by human review 2026-07-08; routed to drbothen/vsdd-factory as 9 new issues (#576-#584) + 3 comments (#507, #428, #298). 72h auto-defer window closed early — no items remain pending.**

All proposals target engine-side improvements (prompt templates, skill checklists, agent configs). None require product source changes.

| ID | Category | Summary | Evidence | Routing | Decision | Notes |
|----|----------|---------|----------|---------|----------|-------|
| IP-571-01 | cost | Initialize per-cycle token/cost tracking (`.factory/cost-summary.md` + state-manager wiring) | PERF-COST-TRACKING open; cost-summary.md missing; ~1.2M token estimate unrecorded | engine: state-manager creates at cycle start, updates per phase | ROUTED-UPSTREAM | drbothen/vsdd-factory#583 (combined with IP-571-13); decided 2026-07-08 |
| IP-571-02 | timing/convergence | Mandatory F2 convergence-criterion selection at F1 gate (STANDARD vs STRICT + upgrade trigger) | DEC-158 mid-cycle escalation after 11 rounds cost ~2–3 extra passes | engine: F2 skill + F1 gate template | ROUTED-UPSTREAM | drbothen/vsdd-factory#578; decided 2026-07-08 |
| IP-571-03 | convergence/template | Mandatory sibling-sweep step in F2/F3 fix-round protocol (grep/diff mirroring artifacts before commit) | TWIN-ARTIFACT-SWEEP ×5 this cycle; each miss = one adversary pass | engine: F2/F3 skills | ROUTED-UPSTREAM | comment on drbothen/vsdd-factory#507 (existing peer-artifact-sweep issue); decided 2026-07-08 |
| IP-571-04 | template | Mandatory CHANGELOG delivery task in story template | STORY-TEMPLATE-CHANGELOG-TASK drift item; F5-p3 MISSING-CHANGELOG-ENTRY; ≥2nd occurrence | engine: story template / create-story skill | ROUTED-UPSTREAM | drbothen/vsdd-factory#580; decided 2026-07-08 |
| IP-571-05 | agent/convergence | Adversary verdict must derive mechanically from finding count (CLEAN iff zero findings); orchestrator rejects contradictory output | ADVERSARY-VERDICT-VS-CONTRACT-DISCREPANCY MEDIUM, F5-p3 | engine: adversary template + orchestrator check | ROUTED-UPSTREAM | drbothen/vsdd-factory#576; decided 2026-07-08 |
| IP-571-06 | agent/tool | Resolve ADVERSARY-WRITE-TOOL-MISMATCH: adversary returns review as text; state-manager writes files (keeps adversary T1 read-only) | ADVERSARY-WRITE-TOOL-MISMATCH drift item | engine: adversary agent config or F2 skill | ROUTED-UPSTREAM | comment on drbothen/vsdd-factory#298 (existing adversary tool-profile issue); decided 2026-07-08 |
| IP-571-07 | convergence/agent | Meta-lens convergence rule: methodology findings classified INFORMATIONAL (non-resetting) or routed to process-gap register; cap 2 per pass under STRICT | ADVERSARY-META-LENS-REGRESS; F2 p16–19; CITATION-GUARDS Story A 44-pass episode; ~3–5 passes lost per affected cycle | engine: adversary prompt + STRICT definition | ROUTED-UPSTREAM | drbothen/vsdd-factory#577; decided 2026-07-08 |
| IP-571-08 | template/convergence | Mandatory spec-changelog re-sync as final action of every F2 fix round | SPEC-CHANGELOG-RESYNC; reset-causing twice (R4-F-MED-2, R11-F-LOW-1) | engine: F2 fix-round checklist | ROUTED-UPSTREAM | comment on drbothen/vsdd-factory#428 (existing changelog-attestation issue); decided 2026-07-08 |
| IP-571-09 | workflow/template | Implement session-review synthesis loop: run after each cycle close; seed/maintain session-reviews/ artifacts | 400+ unsynthesized entries; learning loop non-functional; largest structural gap in factory | engine: F7 closure checklist + session-review skill trigger | ROUTED-UPSTREAM | drbothen/vsdd-factory#584; decided 2026-07-08 |
| IP-571-10 | gate/convergence | "Stale finding" rule for F2 second wave (passes 15+): recurrence of previously-resolved LOW/NITPICK on same surface = REOPENING, escalate to MEDIUM | F2 p13–19 repeated count/changelog surface findings extended window 5–6 passes | engine: STRICT criterion + adversary template | ROUTED-UPSTREAM | drbothen/vsdd-factory#579; decided 2026-07-08 |
| IP-571-11 | pattern/template | F1 retro-annotation step in F2 skill: when F2 supersedes F1 scope claims, update the F1 impact-boundary artifact | PHASE-DOC-RETRO-ANNOTATION; F2 p11 CLAUDE.md scope contradiction | engine: F2 closure checklist | ROUTED-UPSTREAM | drbothen/vsdd-factory#581; decided 2026-07-08 |
| IP-571-12 | gate | F1 perimeter scan must include BC-INDEX.md, CANONICAL-COUNTS.md, traceability artifacts | PERIMETER-SCAN-OMITS-INDEX-AND-TRACEABILITY; F2 count-propagation gaps from BC addition F1 should have caught | engine: F1 skill | ROUTED-UPSTREAM | drbothen/vsdd-factory#582; decided 2026-07-08 |
| IP-571-13 | quality/cost | Define cost-summary schema (cycle ID, dates, passes/phase, est. tokens/phase, fix rounds/phase, human gate wait) | Extension of IP-571-01; F7's ~1.2M estimate shows target granularity | engine: factory templates | ROUTED-UPSTREAM | drbothen/vsdd-factory#583 (combined with IP-571-01); decided 2026-07-08 |

## Processing Instructions

After 72h review window closes (2026-07-11):
- APPROVE → engine-side implementation story created
- REJECT → record reason in Notes column; archive here
- DEFER → move to `improvement-backlog.md` with priority and target cycle
- PENDING (unanswered) → auto-DEFER to `improvement-backlog.md`

**Status: CLOSED. All 13 proposals ROUTED-UPSTREAM (human decision, 2026-07-08). No proposals pending, deferred, or rejected.**
