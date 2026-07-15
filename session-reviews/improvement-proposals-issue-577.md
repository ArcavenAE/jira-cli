---
document_type: improvement-proposals
producer: session-reviewer
timestamp: 2026-07-15
cycle: SOH-COMMENT-CRUD-1
issue: 577
review_source: review-2026-07-15-issue-577.md
status: pending-adjudication
---

# Improvement Proposals: Issue #577 (SOH-COMMENT-CRUD-1)

**72h review window opens 2026-07-15. Adjudication by human; routing to drbothen/vsdd-factory per DEC-164 precedent.**

All proposals target engine-side improvements (vsdd-factory prompt templates, skill checklists, agent configs). None require product source changes.

**Deduplication survey:** All 11 proposals verified against the 13 IP-571-01..13 proposals (all routed upstream 2026-07-08; vsdd-factory issues #576–#584). IP-577-01 extends IP-571-03 (broader scope). IP-577-02 extends IP-571-05 (mutation-specific specialization). IP-577-03 extends PG-MERGE-AUTH-BYPASS remediation (new violation class: substitute-approach). IP-577-04 partially overlaps IP-571-04 (CHANGELOG task) in story-template domain but addresses different gap. All others are new.

| ID | Category | Summary | Evidence | Target Repo/Component | Priority |
|----|----------|---------|----------|----------------------|----------|
| IP-577-01 | template/delivery | Mandatory final-wave repo-wide label grep in delivery checklist | RESOLVED-BY-SHIPPING-DOC-LABEL-RECURRENCE: 6 fix sweeps / 3 PRs / 3 artifact layers; TWIN-ARTIFACT-SWEEP +1 recurrence (now 6) | engine: final-wave delivery checklist | HIGH |
| IP-577-02 | agent/adversary | Adversary empirical mutation run mandate: claim of adequate mutation coverage MUST be backed by actual cargo-mutants run; unverified claim = NOT-PASS | PG-F4-10: adversary claimed coverage without empirical run; CI caught 86% kill rate requiring fix round | engine: adversary checklist + orchestrator validation | HIGH |
| IP-577-03 | agent/implementer | Implementer pre-substitution deviation report: explicitly name "writing a substitute approach" as a STOP trigger (equal to skipping a requirement); report to orchestrator BEFORE writing any substitute code | PG-F4-11 (2nd STOP-on-deviation violation this bundle; 3rd across project counting PG-MERGE-AUTH-BYPASS); recovery cost ~2h research + re-implementation | engine: implementer prompt hardening | HIGH |
| IP-577-04 | template/story | Story-writer must enumerate per-variant test-function names in AC bodies; count emerges from listing; stories that enumerate variants without named test fns are incomplete | PG-F4-7 recurrence 3 (F3-p25, wave-C S-577-4 p1, wave-C S-577-6 p1); each recurrence costs 1+ adversary pass; 3rd recurrence this bundle alone | engine: story-writer checklist | HIGH |
| IP-577-05 | agent/state-manager | State-manager PostToolUse hook: increase timeout budget or make fail-open for file-edit validators that cannot complete within current budget | STATE-MANAGER-MONOLITHIC-WRITE-STALL MEDIUM drift item (4–5 occurrences 2026-07-08/09/14); Bash-python workaround now load-bearing; blocking legitimate PO edits during BC Source sync | engine: hook configuration / state-manager role definition | HIGH |
| IP-577-06 | calibration | Bundle-scoped mutation runs must use `--timeout 480` (or `--jobs 2`) instead of default 240s; add a bundle-size heuristic to select the correct timeout | MUTANTS-BUNDLE-TIMEOUT-CALIBRATION drift item; 20/60 mutants timed out at 240s cap (baseline 91s for this bundle); raw kill rate 66.1% required full adjudication ceremony; adjudicated 100% only after 3 manual isolation probes | engine: formal-verifier mutation run template + `.cargo/mutants.toml` guidance | MEDIUM |
| IP-577-07 | agent/implementer | Resume prompt must include: (1) explicit worktree path `.worktrees/<story-id>`, (2) branch name, (3) mandatory pre-commit branch assertion `git rev-parse --abbrev-ref HEAD` — STOP if assertion fails | PG-F4-8: resumed implementer ran in S-577-4 worktree when assigned to S-577-6; stray commits required cleanup; extra fix round | engine: implementer resume prompt template | MEDIUM |
| IP-577-08 | agent/pr-manager | pr-manager fallback-to-comment is now STANDARD (not optional) when the `validate-pr-review-posted` hook cannot verify a posted review: post the review summary as a `gh pr comment` before declaring review-complete | PG-F4-9: pr-manager declared review-complete on PR #617 without posting evidence; hook could not verify; user oversight required ("did we review 617?") | engine: pr-manager delivery checklist | MEDIUM |
| IP-577-09 | wave-process | Wave-level integration review checklist must include a mandatory union-audit of all cross-story doc artifacts (comment-crud.md class, json-output-shapes registry, visibility-field wire shape documents) | PG-F4-4: cross-story doc artifact had visibility-field vs merged wire shape contradiction invisible to per-story loops; caught only at wave integration pass 1 after merge; required separate fix pass | engine: wave integration review checklist | MEDIUM |
| IP-577-10 | template/story | Relocation stories (stories that move a handler between modules) must include a mandatory BC Source citation sweep task: grep all BC Source lines for the old module path and update to the new path atomically | PG-F4-2: S-577-1 handle_comment relocation broke 10 BC Source citations; required separate factory-artifacts fix commit 45b4f86; 9 additional BC Source lines needed wave-D sync | engine: story-writer checklist for relocation-class stories | LOW |
| IP-577-11 | template/story | Story-writer must clippy lint-check pinned function signatures before finalizing: if a pinned signature has ≥8 parameters, flag for enum-param refactor in the story or document as a known deviation | PG-F4-3: story pinned ≥8-param fn signatures that trip clippy::too_many_arguments (threshold 7); forced in-flight D1 deviation + DEC-172 ratification; avoidable at story-authoring time | engine: story-writer checklist | LOW |

---

## Processing Instructions

After 72h review window closes (2026-07-18):
- APPROVE → route to drbothen/vsdd-factory (new issue or comment on existing issue per dedup survey)
- REJECT → record reason in Notes column; archive here
- DEFER → move to `improvement-backlog.md` with priority and target cycle
- PENDING (unanswered) → auto-DEFER to `improvement-backlog.md`

**Deduplication routing hints (verify before filing):**
- IP-577-01 → comment on drbothen/vsdd-factory#507 (existing peer-artifact sweep issue; broader scope)
- IP-577-02 → drbothen/vsdd-factory#576 comment (existing adversary-verdict contract issue; mutation-specific specialization) OR new issue
- IP-577-03 → drbothen/vsdd-factory or PG-MERGE-AUTH-BYPASS story-91 follow-up (substitute-approach violation class)
- IP-577-04 → drbothen/vsdd-factory (PG-F3-2 / PG-F4-7 recurrence 3; may already have a story pending from IP-571 routing; verify first)
- IP-577-05 → new issue in drbothen/vsdd-factory (state-manager hook timeout; not yet filed upstream)
- IP-577-06 → drbothen/vsdd-factory or `.cargo/mutants.toml` guidance document; MUTANTS-BUNDLE-TIMEOUT-CALIBRATION
- IP-577-07 → new issue in drbothen/vsdd-factory (worktree identity guard in resume prompt)
- IP-577-08 → drbothen/vsdd-factory (pr-manager review-evidence discipline; PG-F4-9)
- IP-577-09 → new issue in drbothen/vsdd-factory (wave integration cross-story doc union-audit)
- IP-577-10 → comment on drbothen/vsdd-factory#507 or new issue (relocation story BC citation sweep)
- IP-577-11 → drbothen/vsdd-factory (story-writer clippy lint-check on pinned signatures)
