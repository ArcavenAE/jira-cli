---
document_type: copilot-review-log
feature: issue-110-pr2
pr: 348
total_rounds: 10
total_inline_comments: 27
total_fix_commits: 18
final_state: "27/27 threads resolved"
date_range: "2026-05-10"
---

# Copilot Review Log — issue-110-pr2

**PR:** #348
**Total rounds:** 10
**Total inline comments:** 27 (4+4+2+2+2+3+5+1+2+2)
**Total review summaries:** 10 (1 per round)
**Fix commits:** 18 across all rounds
**Final state:** 27/27 threads resolved, 0 outstanding

---

## Round 1 — 4 Inline Comments

**Comments addressed:**
1. `--team`, `--description`, `--markdown` flags absent from dry-run preview table (dry-run
   showed only label/summary/priority/type changes, not the full field set)
2. `--max` overrun error message hardcoded "(default 50)" instead of showing the actual cap
   value
3. `--max 0` was accepted by clap and only rejected at handler level — should be a clap
   validator
4. Dry-run description truncation used byte-index slicing, which panics on UTF-8 multi-byte
   characters at truncation boundary

**Disposition:** All 4 fixed-now via implementer dispatch.

**Fix commits:**
- `91686cc` feat(bulk): include --team, --description, --markdown in dry-run preview
- `921129a` fix(bulk): remove misleading "(default 50)" from --max overrun error
- `fda3232` fix(cli): reject --max 0 at clap layer
- `04e3f02` fix(bulk): use char-aware truncation in dry-run description preview

---

## Round 2 — 4 Inline Comments

**Comments addressed:**
1. `CANCEL_REQUESTED` documented in `BulkOperationProgress` as terminal but it is actually
   non-terminal (Atlassian uses it as a transitional state before CANCELLED)
2. `dialoguer::Confirm` errors silently swallowed — `unwrap_or(false)` treated as user
   declining; should propagate the error
3. `effective_keys` was being cloned unnecessarily when building dry-run JSON payload —
   borrow instead
4. `--markdown` flag missing from the field-change presence guard (no-op check)

**Disposition:** All 4 fixed-now.

**Fix commits:**
- `4cdc9c1` fix(bulk): propagate dialoguer::Confirm errors instead of silent abort
- `d17b703` refactor(bulk): borrow effective_keys when building dry-run JSON payload
- `4ad663c` docs(bulk): clarify CANCEL_REQUESTED is non-terminal in BulkOperationProgress doc
- (--markdown guard folded into round 3 fix)

---

## Round 3 — 2 Inline Comments

**Comments addressed:**
1. Duplicate "no fields specified" check existed in two code locations (main path and dry-run
   sub-path); should be single check before branching
2. "No fields specified" error returned plain string instead of `JrError::UserError` —
   should use canonical error type for exit 64

**Disposition:** Both fixed-now.

**Fix commits:**
- `36639d7` fix(bulk): wrap "no fields specified" error in JrError::UserError for canonical exit-64
- `6042685` refactor(bulk): remove duplicate "no fields" check inside dry-run block

---

## Round 4 — 2 Inline Comments

**Comments addressed:** Both were documentation observations with no new actionable code
issues. Treated as pass (no fix commits required).

**Disposition:** No fix needed. (Pass 4 doc fix 1ab056e from F5 review was applied around
this round to close the CLAUDE.md observation from ADV-P5-PR2-P2-005.)

---

## Round 5 — 2 Inline Comments

**Comments addressed:**
1. **DATA-LOSS BUG:** `jr issue edit FOO-1 FOO-2 --label add:foo --summary "X"` silently
   drops `--summary`. The dispatch branches on `!labels.is_empty()` first, which routes to
   `handle_edit_bulk_labels` without checking for concurrent non-label fields. The
   `--summary` flag is ignored entirely. No error is surfaced.
2. Coalesce-shape comment in `handle_edit_bulk_labels` overstated what the current
   implementation does (it described the desired future shape, not the current one)

**Disposition:** Finding 1 fixed-now (critical). Finding 2 docs-only fixed-now.

**Note:** This finding was NOT surfaced by any prior reviewer:
- code-reviewer (1 pass with full context) — missed
- security-reviewer (1 F6 pass) — missed
- adversary x 5 passes (3 consecutive CLEAN) — missed

The dispatch pattern (`if !labels.is_empty() { handle_bulk_labels }`) is idiomatic but
creates a hidden precedence that overrides subsequent flags. Codified in lessons.md as a
novel process-gap finding.

**Fix commits:**
- `d9423df` fix(bulk): reject --label combined with --summary/--priority/--type to prevent silent data loss
- `6177f70` docs(bulk): clarify handle_edit_bulk_labels emits object form for single op, array for coalesced

---

## Round 6 — 3 Inline Comments

**Comments addressed:**
1. `--label` conflict guard (from round 5) was placed after the JQL search call — wasted
   API call when user combines `--label` with `--summary` via `--jql`
2. Priority and issueType schema claim comments overstated confidence ("the Atlassian Bulk
   API accepts these exact field shapes") — should say "best-guess pending #331"
3. Coalesce-shape comment still didn't accurately reflect the current implementation state

**Disposition:** All 3 fixed-now.

**Fix commits:**
- `1604c08` fix(bulk): move --label + field rejection before JQL search to avoid wasted call
- `bfe995e` docs(bulk): soften priority/issueType schema claims to match current best-guess implementation
- `f88101f` docs(bulk): align coalesce-shape comment with #331-pending status

---

## Round 7 — 5 Inline Comments

**Comments addressed:**
1. Test comment said JQL search uses GET; actual implementation uses POST (Jira JQL search
   endpoint changed in recent API versions)
2. `--max` ceiling (1000) was enforced at handler level after clap parse — should be enforced
   at clap layer via `value_parser` to fail early with a clean error
3. "no fields specified" comment in bulk.rs was stale (referred to the old check location
   that was refactored in round 3)
4-5. Two minor doc alignment issues in test comments

**Disposition:** First 3 fixed-now; last 2 treated as NIT in subsequent round.

**Fix commits:**
- `6e65db2` docs(test): correct JQL search comment from GET to POST in issue_bulk_pr2
- `08b26d4` fix(cli): enforce --max ceiling 1000 at clap parse time instead of silent clamp
- `2b22860` docs(bulk): update stale "no fields" comment to reflect single-source pre-HTTP guard

---

## Round 8 — 1 Inline Comment

**Comments addressed:**
1. `--max` with positional keys (no `--jql`) should error at clap parse time, not handler
   level. The clap `requires` attribute was missing, allowing `jr issue edit FOO-1 FOO-2
   --max 100 --label add:foo` to pass clap validation.

**Disposition:** Fixed-now.

**Note:** This surfaced a clap interaction gotcha: `requires` + `conflicts_with` interact
unreliably with positional args. The fix used handler-level validation per the existing
pattern. Codified in lessons.md.

**Fix commits:**
- `089e938` fix(cli): make --max require --jql; reject when used with positional keys

---

## Round 9 — 2 Inline Comments

**Comments addressed:**
1. `--jql` makes the `<KEYS>` positional argument optional, but the `--help` output still
   showed `<KEYS>...` as apparently required (no visual hint that JQL is an alternative)
2. Round-5 `--label` conflict guard was extended to cover `--summary`/`--priority`/`--type`
   but not all non-label flags (e.g., `--team`, `--description`). Guard should be exhaustive.

**Disposition:** Both fixed-now.

**Fix commits:**
- `eb9aeac` docs(cli): clarify keys arg is optional when using --jql in --help output
- `cda9a67` fix(bulk): extend --label conflict guard to all non-label field flags (closes #349)

Note: #349 was initially filed as a separate tracking issue for the guard gap, then closed as
superseded when the fix landed in this commit.

---

## Round 10 — 2 Inline Comments

**Comments addressed:**
1. `src/cli/mod.rs` clap definition comment said `requires = "jql"` for `--max` but
   enforcement was actually handler-level (added in round 8 fix). Stale comment was
   misleading.
2. `docs/demo-evidence/issue-110-pr2/evidence-report.md` didn't clarify that the release
   build keychain test requires a real keychain entry to be pre-populated — the CI step
   implicitly relies on this but it's not called out for local reproduction.

**Disposition:** Both fixed-now.

**Fix commits:**
- `df3bde4` docs(bulk): correct stale clap "requires=jql" claim — enforcement is handler-level
- `a60c4ce` docs(demo): clarify release-build keychain prerequisite in evidence-report

---

## Summary Statistics

| Round | Comments | Fix Commits | Data-loss? | Arch-change? |
|-------|----------|-------------|------------|--------------|
| 1 | 4 | 4 | No | No |
| 2 | 4 | 3 | No | No |
| 3 | 2 | 2 | No | No |
| 4 | 2 | 0 | No | No |
| 5 | 2 | 2 | **YES** (silent drop) | No |
| 6 | 3 | 3 | No | No |
| 7 | 5 | 3 | No | No |
| 8 | 1 | 1 | No | No |
| 9 | 2 | 2 | No | No |
| 10 | 2 | 2 | No | No |
| **Total** | **27** | **22** | — | — |

(Fix commit count differs from summary header due to minor counting difference; 18 unique
fix-focused commits, some rounds had refactor/docs-only commits also counted.)

---

## Notable Process Observations

**Round 5 DATA-LOSS bug** was the highest-severity finding across all 10 rounds. It was
missed by 3 prior reviewer types (code-reviewer, security-reviewer, 5 adversarial passes).
The root cause is that dispatch branching on `!labels.is_empty()` creates a silent precedence
that discards subsequent flags without error. This class of bug ("silently-dropped flag
combinations") should be an explicit adversarial review axis. Codified in lessons.md.

**Round 8 clap interaction** revealed that `requires` + `conflicts_with` clap attributes
interact unreliably with positional arguments. Handler-level validation with explicit
`JrError::UserError` is the robust pattern. Codified in lessons.md as a clap gotcha.
