# F1 Delta Analysis: MUTANTS-EXAMINE-GLOBS-STALE-AFTER-SEAM-B

- **Drift item:** MUTANTS-EXAMINE-GLOBS-STALE-AFTER-SEAM-B
- **Priority:** MEDIUM
- **Status:** OPEN — needs-intent-decision
- **Origin:** DEC-149 (CITATION-DEBT-PRODUCT-FILES cycle; surfaced by adversarial gate on PR #568)
- **Date:** 2026-07-02
- **Analysis type:** F1 delta — no code or config changes made in this artifact

---

## 1. Ground-Truth Findings

### 1.1 Current `.cargo/mutants.toml` examine_globs

```toml
examine_globs = [
    "src/adf.rs",
    "src/api/jira/bulk.rs",
    "src/types/jira/bulk.rs",
    "src/cli/issue/create.rs",       ← stale: behavior-dense functions relocated away
    "src/api/jsm/requests.rs",
    "src/api/jsm/request_types.rs",
    "src/cli/requesttype.rs",
    "src/api/jira/issues.rs",
    "src/cache.rs",
]
```

`edit.rs` and `jsm_create.rs` are absent.

### 1.2 Function Locations After Seam A/B Splits

| Function | Originally in | Now in | Seam |
|----------|--------------|--------|------|
| `handle_edit` | `create.rs` | `src/cli/issue/edit.rs` | Seam B (PR #558) |
| `handle_edit_bulk_labels` | `create.rs` | `src/cli/issue/edit.rs` | Seam B (PR #558) |
| `handle_edit_bulk_fields` | `create.rs` | `src/cli/issue/edit.rs` | Seam B (PR #558) |
| `handle_jsm_create` | `create.rs` | `src/cli/issue/jsm_create.rs` | Seam A (PR #556) |
| `parse_field_kv` | `create.rs` | `src/cli/issue/create.rs` | — (remains) |

Verification: `grep -n "handle_edit_bulk_labels\|handle_edit_bulk_fields" src/cli/issue/edit.rs` confirms at lines 935 and 1059. `grep -n "pub(super) async fn handle_jsm_create" src/cli/issue/jsm_create.rs` confirms at line 92. `grep -n "handle_edit_bulk_labels\|handle_jsm_create" src/cli/issue/create.rs` shows only import/call lines — no definitions.

### 1.3 Measured Mutant Counts (cargo mutants --list --no-config, 2026-07-02)

| File | LOC | Mutants (measured) | Status in examine_globs |
|------|-----|--------------------|------------------------|
| `src/adf.rs` | ~6,000+ | 351 | IN SCOPE |
| `src/cache.rs` | — | 80 | IN SCOPE |
| `src/types/jira/bulk.rs` | — | 51 | IN SCOPE |
| `src/api/jira/issues.rs` | — | 49 | IN SCOPE |
| `src/api/jira/bulk.rs` | — | 34 | IN SCOPE |
| `src/cli/requesttype.rs` | — | 12 | IN SCOPE |
| `src/cli/issue/create.rs` | 394 | 10 | IN SCOPE (stale: thin dispatcher) |
| `src/api/jsm/request_types.rs` | — | 4 | IN SCOPE |
| `src/api/jsm/requests.rs` | — | 3 | IN SCOPE |
| **Total current scope** | | **594** | |
| `src/cli/issue/edit.rs` | 2,067 | **99** | **NOT IN SCOPE** |
| `src/cli/issue/jsm_create.rs` | ~444 | **9** | **NOT IN SCOPE** |
| **Total if option (a) applied** | | **702** | +18% |

All counts measured with `additional_cargo_test_args = ["--all-features"]` (matching CI). The `--all-features` flag does not increase counts for `edit.rs` or `jsm_create.rs` — these are not feature-gated.

### 1.4 Confirmed Coverage Gap

**`create.rs` is now a thin dispatcher.** It retains only `parse_field_kv` and `handle_create` (which immediately routes to `handle_jsm_create` or `handle_edit`). With 10 mutants, it provides minimal mutation value. The behavior-dense surfaces that originally justified `create.rs`'s inclusion — `handle_edit`, `handle_edit_bulk_labels`, `handle_edit_bulk_fields`, `handle_jsm_create` — have been relocated to `edit.rs` and `jsm_create.rs`.

**Consequence:** Any PR that modifies only `edit.rs` or `jsm_create.rs` currently passes the mutation gate via the 0-mutant path (legitimate exit 0, no `outcomes.json` written), silently providing no mutation coverage on those behavior-dense surfaces.

---

## 2. Stale Citations Identified

### Primary stale citation (HIGH — directly describes wrong behavior)

**`docs/specs/cargo-mutants-policy.md:19`**

```
- `src/cli/issue/create.rs` — `handle_edit_bulk_labels`, `handle_edit_bulk_fields`, `handle_jsm_create`, `parse_field_kv`
```

Three of the four named functions no longer live in `create.rs`. The policy doc's scope table tells readers that mutation testing covers those functions when it does not. This is a false coverage claim in a governance document.

### Secondary stale citation (MEDIUM — scope claim overstates actual config)

**`.factory/cicd-setup.md:76`**

```
Current scope includes `src/cli/issue/create.rs`, `src/api/jira/bulk.rs`, `src/types/jira/bulk.rs`,
`src/cli/issue/edit.rs`, `src/adf.rs`, `src/api/jira/issues.rs`, `src/cache.rs`, `src/api/jsm/`.
```

This line ALREADY includes `src/cli/issue/edit.rs` in the scope description, but the actual `.cargo/mutants.toml` does NOT. The doc claims edit.rs is covered; the config contradicts it. The policy doc acknowledges cicd-setup.md is "historical/pending refresh" — but this specific overstatement is still a concrete false coverage claim for any reader of cicd-setup.md.

Note: `jsm_create.rs` is absent from cicd-setup.md's scope list, consistent with it not being in mutants.toml.

### Historical / plan-doc citations (LOW — not active governance)

These are historical research or superseded plan files; they do not govern current behavior and do not affect the mutation gate:

- `.factory/research/e2e-priority-assign-worklog.md:16` — names `create.rs::handle_edit_bulk_fields` (pre-Seam-B research)
- `.factory/spec-changelog.md:990` — references `create.rs:1988-1995` for `handle_jsm_create` map_err (historical changelog entry)
- `docs/superpowers/plans/` entries naming `create.rs::handle_edit` — superseded implementation plans
- `docs/specs/adf-recursion-depth.md:448` — cites `create.rs::handle_edit` at ~line 925 (pre-split spec)

Per SWEEP-WHOLE-TOUCHED-FILE-NOT-JUST-TARGET-LINE, the above historical files require no update under either option because they document past state; updating them would create anachronistic rewriting of historical records.

### CLAUDE.md

No mutation-scope citations. CLAUDE.md correctly locates `handle_edit`/`handle_edit_bulk_*` in `edit.rs` and `handle_jsm_create` in `jsm_create.rs`. No change needed under either option.

---

## 3. Option (a) vs (b) Cost-Benefit Analysis

### Option (a): Add edit.rs + jsm_create.rs to examine_globs and fix policy doc

**Config change:** Add to `.cargo/mutants.toml::examine_globs`:
```toml
"src/cli/issue/edit.rs",
"src/cli/issue/jsm_create.rs",
```

**Budget impact (measured, 2026-07-02):**

With `--in-diff` scoping to changed lines, per-PR cost depends on how much of the file the PR touches:

| PR scenario | Mutants generated | Est. wall-clock (4 jobs × 140s avg) |
|-------------|------------------|--------------------------------------|
| `jsm_create.rs` (any size) | ≤ 9 | ≤ ~5 min |
| `edit.rs` small PR (~10% of file) | ~10 | ~6 min |
| `edit.rs` medium PR (~30% of file) | ~30 | ~18 min |
| `edit.rs` large PR (~50% of file) | ~50 | ~29 min |
| `edit.rs` full rewrite (worst case) | 99 | ~58 min (within 90-min budget) |
| `adf.rs` full rewrite + `edit.rs` full rewrite | 351 + 99 = 450 | ~263 min → exceeds budget → split PR signal |

**Key insight:** The worst single-file `edit.rs` PR (99 mutants) fits within the 90-minute job budget. Only a combined `adf.rs` + `edit.rs` large-scope PR would exceed budget — the same oversized-diff signal that applies to `adf.rs` alone today. PRs touching `jsm_create.rs` (max 9 mutants) are practically free.

**PRs that don't touch edit.rs/jsm_create.rs:** zero additional cost. `--in-diff` and examine_globs together double-gate the scope.

**Benefit:**
- Mutation testing covers `handle_edit`, `handle_edit_bulk_labels`, `handle_edit_bulk_fields`, `handle_jsm_create` — all HIGH-criticality surfaces with complex conditional logic (bulk routing forks, C-1 guard, label endpoint fork, JSM dispatch)
- Weak-assertion gaps in bulk edit and JSM paths become visible, consistent with the original intent of the S-346 mutation gate
- Interacts positively with MUTANTS-FIRST-SCOPED-PR-CALIBRATION: the first code-change PR touching `edit.rs` will exercise the non-zero-mutant code path of `--timeout 240`, providing the deferred calibration confirmation

**Files to change under option (a):**
1. `.cargo/mutants.toml` — add 2 lines to `examine_globs`
2. `docs/specs/cargo-mutants-policy.md:19` — repoint 3 function names to correct files; correct line reads something like: `src/cli/issue/create.rs` — `parse_field_kv`; `src/cli/issue/edit.rs` — `handle_edit`, `handle_edit_bulk_labels`, `handle_edit_bulk_fields`; `src/cli/issue/jsm_create.rs` — `handle_jsm_create`
3. `.factory/cicd-setup.md:76` — resolve the edit.rs overstated-scope inconsistency; add jsm_create.rs to match actual config
4. (Verify) `docs/specs/cargo-mutants-policy.md` changelog section — add a changelog entry for the scope change

**Regression risk:** LOW. `--in-diff` means existing green PRs that don't touch edit.rs/jsm_create.rs are unaffected. The first PR that touches either file may require additional test strengthening if weak-assertion survivors emerge — this is the desired behavior, not a regression.

### Option (b): Accept narrowed scope, document rationale

**Rationale that could justify option (b):**
1. The bulk-edit and JSM surfaces are already covered by BC-anchored integration tests (`tests/issue_bulk.rs`, `tests/issue_bulk_pr2.rs`, `tests/issue_create_jsm.rs`), wiremock pins, and holdout scenarios. Mutation testing is a meta-verification layer to surface weak assertions; if the existing assertions are strong, the mutation gate adds marginal value.
2. `edit.rs` at 2,067 LOC with 99 mutants is the largest CLI handler — future large PRs could approach the 90-minute budget ceiling, creating pressure to split PRs. Deferring to Path B sharding (MUTANTS-SHARDING-PATH-B) before widening scope keeps the current single-job model less exposed.
3. The cost of discovering and closing surviving-mutant gaps in `edit.rs` may be non-trivial given its complexity (2× the ADR-0012 1,000-LOC threshold, documented as DOCUMENT-AS-IS).

**Weaknesses of option (b):**
1. The policy doc's coverage claim for those three functions is now factually false. Option (b) requires the policy doc to be corrected regardless — removing the false coverage claim and documenting the deliberate exclusion.
2. The original scope justification (`create.rs` was included specifically because it was behavior-dense with high weak-assertion surface) no longer applies to the current thin `create.rs` (10 mutants). Keeping `create.rs` but not `edit.rs` is confusing: the file still in scope is the thin wrapper; the file doing the work is out of scope.
3. `jsm_create.rs` at 9 mutants is essentially free to add. Excluding it has no budget argument.

**Files to change under option (b):**
1. `docs/specs/cargo-mutants-policy.md:19` — remove the three mislocated function names; add a "Deferred" entry or a note explaining the explicit exclusion of `edit.rs`/`jsm_create.rs` with rationale
2. `.factory/cicd-setup.md:76` — remove `edit.rs` from the scope description to match actual config
3. `.factory/STATE.md` — close the MUTANTS-EXAMINE-GLOBS-STALE-AFTER-SEAM-B drift item with resolution "accepted narrowed scope; rationale: [reason]"

Option (b) does NOT remove `create.rs` from examine_globs, even though it is now a thin dispatcher. Removing it would require justification that its 10 mutants are not worth the minimal cost. This is a separate sub-decision.

---

## 4. RECOMMENDATION

**Option (a) — Add edit.rs + jsm_create.rs to examine_globs.**

Rationale:
1. **Restores the original intent.** The S-346 mutation gate was established specifically because those function clusters had "high line coverage but untested assertion strength." The Seam A/B split moved those clusters to new files but did not change their mutation risk profile. Restoring coverage respects the intent, not just the letter, of the policy.
2. **jsm_create.rs is free.** 9 mutants / 4 jobs × 140s = ~5 min worst case. There is no cost argument against adding it.
3. **edit.rs worst case fits within budget.** A 99-mutant worst case on a full-file PR takes ~58 minutes, within the 90-minute ceiling. Typical PRs (10–30% of file) add 6–18 minutes of cost. The oversized-diff split-PR signal (200+ mutants) provides a natural safeguard.
4. **The false coverage claim in the policy doc is worse than the cost of fixing it.** A governance document that claims to cover `handle_edit_bulk_labels` when it does not is technically incorrect. Future engineers reading the policy doc may trust coverage that does not exist.
5. **Positive interaction with MUTANTS-FIRST-SCOPED-PR-CALIBRATION.** The code-mutant path of `--timeout 240` remains unexercised (only the 0-mutant path was confirmed by PR #568). Adding edit.rs makes the next edit.rs code-change PR a natural calibration opportunity, turning a watch-item into a forward-progress step.
6. **Scope creep risk is low.** The `--in-diff` intersection prevents the global mutant count (702) from materializing on any individual PR. Only lines actually changed in the PR are mutated.

**Trivial scope assessment:** This change is NOT trivial in the VSDD sense — it involves a config change, a policy doc update, and a decision about coverage intent. However, it IS a low-regression-risk, single-domain change that does not require new BCs, UX changes, or architecture changes. It qualifies for quick-dev routing once the intent decision is approved.

**Path:** Option (a) → F4 single story (worktree → implement → PR → review) → F7 lite.

---

## 5. Impact Boundary (Option a)

### Files to Change

| File | Change | Class |
|------|--------|-------|
| `.cargo/mutants.toml` | Add `"src/cli/issue/edit.rs"` and `"src/cli/issue/jsm_create.rs"` to `examine_globs` | Config |
| `docs/specs/cargo-mutants-policy.md:19` | Repoint `handle_edit_bulk_labels`, `handle_edit_bulk_fields` to `edit.rs`; repoint `handle_jsm_create` to `jsm_create.rs`; update `create.rs` entry to reflect `parse_field_kv` only | Doc/spec |
| `docs/specs/cargo-mutants-policy.md` changelog | Add entry for scope widening (date, cycle, description) | Doc/spec |
| `.factory/cicd-setup.md:76` | Remove pre-existing false `edit.rs` claim; add `jsm_create.rs` to the scope list to match actual config post-change | Spec (factory artifact) |

### Files NOT Changed (regression baseline)

- `.github/workflows/ci.yml` — no changes needed; `--in-diff` mode and `--timeout 240` remain unchanged
- `CLAUDE.md` — no mutation-scope citations; no change needed
- `src/cli/issue/edit.rs` — analysis only; no code changes in F1
- `src/cli/issue/jsm_create.rs` — analysis only; no code changes in F1
- `src/cli/issue/create.rs` — no change to examine_globs entry (retain `create.rs` in scope for `parse_field_kv`)
- All `.factory/research/` and `docs/superpowers/` historical files — historical records; do not rewrite
- `.factory/STATE.md` — updated by state-manager as part of cycle completion

### Per-File Sweep Results (SWEEP-WHOLE-TOUCHED-FILE-NOT-JUST-TARGET-LINE)

**`docs/specs/cargo-mutants-policy.md` — full sweep for same-class stale references:**
- Line 19: PRIMARY stale citation (function locations in create.rs) — MUST FIX
- Lines 107, 155, 324, 338, 429, 636: `examine_globs` as a concept — all accurate; no changes needed
- No other function-location citations found that misattribute edit.rs/jsm_create.rs functions to create.rs

**`.factory/cicd-setup.md` — full sweep:**
- Line 76: SECONDARY stale citation (edit.rs listed as in-scope when not in config) — MUST FIX under option (a)
- Lines 45, 202, 368: describe the mutants job behavior accurately (or are labeled as historical); no additional changes needed under option (a)

**`.cargo/mutants.toml` — full sweep:**
- Lines 10-24: examine_globs list — ADD edit.rs and jsm_create.rs
- Comment on line 8: "adf, bulk/create, issues, cache, and jsm modules" — update "create" to "create/edit/jsm_create" or rephrase to "issue-write cluster" for accuracy
- Line 9 comment: "Canonical scope definition: docs/specs/cargo-mutants-policy.md §Scope" — unchanged; remains accurate pointer

### Regression Risk Assessment

| Area | Risk | Rationale |
|------|------|-----------|
| Existing passing PRs that don't touch edit.rs/jsm_create.rs | NONE | `--in-diff` scope-bounds cost to changed lines; zero new mutants on unrelated PRs |
| First PR touching edit.rs after change | LOW-MEDIUM | May surface surviving mutants requiring `#[mutants::skip]` with justification or targeted test strengthening; expected and appropriate |
| 90-minute CI budget | LOW | Worst-case full-edit.rs PR (~99 mutants, ~58 min) fits within budget; split-PR signal applies if combined with large adf.rs change |
| ci-gate false-block | NONE | No changes to ci-gate logic, false-green guards, or kill-rate threshold |

---

## 6. Interaction with Other Drift Items

### MUTANTS-SHARDING-PATH-B

Path B (sharding via `--shard k/n`) remains deferred. Adding 108 more mutants (edit.rs + jsm_create.rs) increases total scope from 594 to 702 mutants (+18%). This does not accelerate the need for Path B:
- The 90-minute budget constraint is driven by `adf.rs` (351 mutants, ~3.4 hours for a full-file PR) — edit.rs adds ~58 min worst case
- Path B should be triggered when Path A's 90-minute budget proves insufficient in practice, not proactively. That trigger has not been hit.
- If Path B is eventually adopted, the `--shard` flags work equally on a 702-mutant scope as on a 594-mutant scope; no interaction issues.

### MUTANTS-FIRST-SCOPED-PR-CALIBRATION

The code-mutant path of `--timeout 240` (a PR with actual code mutations, not just rustdoc) remains unexercised after PR #568 (0-mutant rustdoc path was confirmed). Adding `edit.rs` to examine_globs means the next PR that modifies code in `edit.rs` will exercise the non-zero-mutant path. This:
- Is the desired calibration event
- Lets the team confirm `--timeout 240` does not produce false timeout outcomes on the measured 133–145s baseline
- Should be watched: if any `timeout` outcomes appear in the `Check kill rate` step on an otherwise-healthy `edit.rs` PR, bump `--timeout` further (see policy doc §Absolute Timeout Ceiling)

Under option (a), MUTANTS-FIRST-SCOPED-PR-CALIBRATION becomes "will be exercised on next code-change PR to edit.rs" — an active watch item, not a deferred one.

---

## 7. Open Questions for Human Gate

1. **Option choice:** Is option (a) [extend scope] or option (b) [document accepted narrowing] the preferred intent?

2. **create.rs retention:** `create.rs` currently has only 10 mutants covering `parse_field_kv` (the remaining non-trivial function). Should it remain in examine_globs for `parse_field_kv` coverage, or is the thin-dispatcher role sufficiently covered by its integration test suite? Keeping it is the lower-risk default.

3. **Surviving mutants:** Under option (a), the first code-change PR to `edit.rs` may surface surviving mutants. Is the team prepared to close those gaps (via targeted tests or `#[mutants::skip]` with justification) as part of the delivery cycle for that PR? The kill-rate gate (90%) will block merge if too many survivors exist.

4. **Quick-dev routing:** Is quick-dev routing appropriate here (F1 → single F4 story → regression → F7 lite)? The change is: 2 lines in mutants.toml + ~5 lines in cargo-mutants-policy.md + ~2 lines in cicd-setup.md. No new BCs, no architecture change, LOW regression risk.

5. **MUTANTS-SHARDING-PATH-B coordination:** Should a Path B story be opened in parallel, now that the scope is widening? The current evidence does not support rushing Path B (no budget-exceeded cancellations on the current gate), but the team may want to track it explicitly.

---

## 8. Summary Table

| Dimension | Option (a) — Extend scope | Option (b) — Accept narrowing |
|-----------|--------------------------|-------------------------------|
| Mutation coverage of edit.rs | YES (99 mutants max) | NO |
| Mutation coverage of jsm_create.rs | YES (9 mutants max) | NO |
| Policy doc accuracy | Restored | Fixed to reflect deliberate exclusion |
| Worst-case CI cost increase | +58 min (full edit.rs PR) | 0 |
| Typical edit.rs PR cost increase | +6–18 min | 0 |
| jsm_create.rs PR cost increase | +~5 min (max) | 0 |
| Files to change | 4 (toml + policy + cicd-setup + changelog) | 3 (policy + cicd-setup + STATE) |
| MUTANTS-FIRST-SCOPED-PR-CALIBRATION | Becomes active on next edit.rs PR | Unchanged (deferred) |
| Original S-346 intent | Preserved | Narrowed |
| **Recommendation** | **YES** | Not recommended |
