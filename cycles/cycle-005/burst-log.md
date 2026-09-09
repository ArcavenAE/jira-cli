---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-07T04:37:49Z
cycle: "cycle-005"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Burst Log — cycle-005 (adf-mentions)

## Burst: Burst 1 — cycle-005 OPENED (Feature Mode) — adf-mentions bundle confirmed, F1 delta analysis APPROVED (DEC-344) (2026-09-06)

**Parent-commit:** `569d85a8` (`develop` tip; unchanged this burst — no `develop`-side commit; cycle-005 has not started implementation, F1/F2 are spec-only phases).

**Trigger:** human requested a new Feature-Mode cycle following cycle-004's release and close: `adf-mentions` (GitHub #674) — convert markdown mentions (`[~accountid:<id>]` bracket form and `@Name` form) into ADF `mention` nodes on the write path, with a corresponding `adf_to_text` reverse-path update.

**Actions taken:**

1. STATE.md refreshed via one full-content Write (v3.74 → v3.75): frontmatter `phase` → `"cycle-005 (adf-mentions) Phase F1 delta analysis APPROVED; Phase F2 (spec evolution) IN PROGRESS."`, `pipeline` → `ACTIVE`, `current_cycle` → `"cycle-005"`, `feature_mode_bundle` → `adf-mentions`, `dtu_required` → `false` (no third-party service cloned — the feature targets Jira's own REST API user-search/mention surface, already covered by existing DTU-not-required precedent). `cycle_001_status` through `cycle_004_status` preserved unchanged (all CLOSED, historical, intact verbatim); added `cycle_005_status`. `activation_head`/`activation_version` held at `569d85a8`/`v0.7.0-dev.5` (unchanged — no release-side commit this burst).
2. **F1 delta analysis dispatched and completed.** architect produced `phase-f1-delta-analysis/cycle-005/delta-analysis.md` + `affected-files.txt`. business-analyst produced `phase-f1-delta-analysis/cycle-005/artifact-mapping.md` (canonical BC/VP decomposition proposal).
3. **Duplicate artifact reconciled.** An orchestrator coordination error re-dispatched a second business-analyst run against the same F1 scope, producing a second `artifact-mapping.md` at `cycles/cycle-005/phase-f1-delta-analysis/artifact-mapping.md`. The two files were diffed. Both largely overlap, but the duplicate resolves two points more concretely than the canonical: (a) a committed reverse-path BC-7.2.019 that implements `adf_to_text` mention rendering and explicitly closes GitHub issue #202 / NFR-O-I (the canonical left this as an open F2 decision under BC-7.2.004); (b) a 3-way split of `@Name` resolution into BC-X.7.007 (unique match) / BC-X.7.008 (ambiguous) / BC-X.7.009 (zero match), plus VP-674-007/008 (reverse-path render + round-trip property) and VP-674-009/010/011 (tied to the 3-way split and JSM visibility orthogonality) — versus the canonical's single shared-resolver BC-X.7.007 and VP-674-001..006. These genuinely distinct proposals were appended to the canonical `artifact-mapping.md` as an "Alternative decomposition (F2 input)" note. The duplicate file and its now-empty `cycles/cycle-005/phase-f1-delta-analysis/` directory were then removed. Both remain F1 **proposals only** — F2 (architect + product-owner) authors the binding BCs/VPs from either or both.
4. **Tracked follow-up logged (non-blocking):** `VP-COUNT-RECONCILIATION` — the business-analyst's F1 pass surfaced a pre-existing bookkeeping discrepancy: a raw grep found ~177 VP identifiers across `bc-*.md` bodies, versus STATE.md's tracked running total of 55 VPs. Logged under Constraints Carried Forward / Drift-Standing-Items, targeted at a future maintenance/self-improvement cycle; not investigated or resolved this burst.
5. Recorded 1 new Decisions Log entry, **DEC-344** (collision-checked: highest pre-existing ID was DEC-343, confirmed via corpus-wide grep against STATE.md — no collision): human APPROVED the F1 delta-analysis scope in full — two mention input forms (bracket `[~accountid:<id>]` pure post-pass conversion + preflight-validate the accountId via `GET /rest/api/3/user?accountId=`; `@Name` effectful resolution via user search), hard-error `@Name` no-match (exit 64) with a `\@` escape and a `--no-mentions` opt-out, ambiguous-match prompt/error-with-candidates, unique-match resolve+tag, `attrs.text` populated from the resolved display name, wiring across comment add / issue create (platform) / issue edit / JSM `issue create --request-type` (`handle_jsm_create`), reverse-path `adf_to_text` update (affects BC-7.2.004 and `issue view` rendering), and a **new** human requirement for live-Jira E2E test coverage against a controlled test account with self-cleaning teardown. Phase advances F1 → F2.
6. Added a new Phase Progress row for cycle-005 (`F1-DELTA-ANALYSIS`, APPROVED); replaced Current Phase Steps with a cycle-005 Burst-1 table (cycle-004's RELEASED/CLOSED steps table already fully archived in `cycles/cycle-004/burst-log.md`).
7. Updated Convergence Status / Concurrent Cycles prose: cycle-005 `adf-mentions` is now the sole OPEN cycle (Phase F2 in progress); cycle-001/002/003/004 remain CLOSED, historical, unaltered.
8. Condensed the now-historical cycle-004 Constraints-Carried-Forward / Drift-Standing-Items paragraphs (previously full per-burst narrative, Bursts 3-22) into brief historical summary lines, mirroring the compaction already applied to cycle-003 when cycle-004 opened — full per-burst detail remains intact and unchanged at `cycles/cycle-004/burst-log.md`. No content was deleted, only relocated/condensed per the routing rules (STATE.md stays lean; cycle files hold history).
9. Replaced Session Resume Checkpoint (cycle-005 F1-APPROVED/F2-IN-PROGRESS position); the prior CLOSED+RELEASED cycle-004 resting-state checkpoint (v3.74) was archived to `cycles/cycle-004/session-checkpoints.md` with a "Superseded at" note BEFORE the new checkpoint was written.
10. Carried ALL cycle-001/002/003/004 Drift/Standing items forward verbatim (condensed prose per item 8 above, no content lost — full detail remains in each cycle's own burst-log.md).
11. Created cycle-005 scaffolding: `cycles/cycle-005/burst-log.md` (this file) and `cycles/cycle-005/session-checkpoints.md` (empty archive, no checkpoint superseded yet).
12. Did NOT stage the pre-existing unrelated dirty files noted at every prior burst (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left as-is per standing instruction; only cycle-005-init paths plus STATE.md plus the cycle-004 checkpoint-archive append are staged explicitly for this commit.

**Adversary verdict:** N/A — bookkeeping/cycle-open burst (STATE.md + scaffolding + duplicate-artifact reconciliation only), no code or spec-body change; no `adversary` agent dispatched. The F1 scope/design decisions this burst records were reached via architect + business-analyst delta analysis followed by human approval, not an adversarial review pass.

**Outcome:** cycle-005 (`adf-mentions`) is OPEN, Phase F1 APPROVED (DEC-344), Phase F2 (spec evolution) dispatched. No BC/VP/holdout counts changed this burst (742/55/106/172 unchanged) — F1 is analysis-only; new BCs/VPs land at F2. Projected at F1 (to be finalized at F2): ~750-751 BCs / ~61 VPs / 107-111 holdouts / 176-178 stories.

**Files touched (Dim-1): 7 unique files/paths this burst (5 created/modified, 2 removed), all committed in the state-manager's own single atomic commit**

- `STATE.md` (modified)
- `cycles/cycle-004/session-checkpoints.md` (modified — archives the v3.74 checkpoint)
- `cycles/cycle-005/burst-log.md` (created — this file)
- `cycles/cycle-005/session-checkpoints.md` (created — empty archive)
- `phase-f1-delta-analysis/cycle-005/artifact-mapping.md` (modified — "Alternative decomposition (F2 input)" note appended)
- `cycles/cycle-005/phase-f1-delta-analysis/artifact-mapping.md` (removed — duplicate, reconciled into the file above)
- `cycles/cycle-005/phase-f1-delta-analysis/` (removed — now-empty directory)

(`phase-f1-delta-analysis/cycle-005/delta-analysis.md` and `affected-files.txt` were created by the architect in a prior step this same burst, not by this state-manager commit.)

**Dim-2 Attestation:** No BC/VP/holdout INDEX content changed this burst (F1 is analysis-only; the artifact-mapping.md amendment is a proposal note, not a binding BC/VP body). Counts unchanged: 742 BCs / 55 VPs / 106 holdouts / 172 stories. DEC-namespace collision check: DEC-344 is the next sequential ID after DEC-343, no collision.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (this burst is spec-analysis + bookkeeping only, no build).

**Dim-6 Attestation:** No `src/`/`tests/` change this burst — cycle-005 is at Phase F1→F2, spec-only. `develop` HEAD unchanged at `569d85a8`.

**Dim-7 Attestation:** N/A — no CI-relevant change this burst (no code, no workflow file touched).

**Codifications:** **DEC-344** — human APPROVED cycle-005 (`adf-mentions`, #674) Phase F1 delta analysis: full scope and design decisions as enumerated in Action 5 above. No BC/VP/holdout added, removed, or renumbered by this burst (742/55/106/172 all unchanged) — F1 proposals recorded as candidates only, pending F2 authorship.

**Closes:** cycle-005 Phase F1 (delta analysis) — human-approved. The duplicate F1 artifact-mapping.md coordination error — reconciled, not left as unresolved drift. **Does NOT close:** cycle-005 itself, which remains open through F2-F7; the `VP-COUNT-RECONCILIATION` tracked follow-up (non-blocking, target a future maintenance/self-improvement cycle); any of the carried-forward cycle-001/002/003/004 standing items (all unchanged, condensed for length only).

### Details

| Agent | Task | Output |
|-------|------|--------|
| architect | F1 delta analysis — architectural impact, affected files | `phase-f1-delta-analysis/cycle-005/delta-analysis.md`, `affected-files.txt` |
| business-analyst (run 1) | F1 delta analysis — BC/VP artifact-mapping proposal | `phase-f1-delta-analysis/cycle-005/artifact-mapping.md` (canonical) |
| business-analyst (run 2, duplicate) | F1 delta analysis — BC/VP artifact-mapping proposal (orchestrator coordination error, re-dispatched) | `cycles/cycle-005/phase-f1-delta-analysis/artifact-mapping.md` (reconciled into canonical this burst, then removed) |
| state-manager | cycle-005 init; duplicate reconciliation (diff + alternative-decomposition note + removal); DEC-344 recording; STATE.md v3.75 full-content Write; archive v3.74 checkpoint; commit + push to `factory-artifacts` | `STATE.md` (v3.75); `cycles/cycle-005/burst-log.md` (this file); `cycles/cycle-005/session-checkpoints.md`; `cycles/cycle-004/session-checkpoints.md` (appended) |

---

## Burst: Burst 2 — Phase F2 spec evolution APPROVED (DEC-346); F2-gate TIGHTENING decision (DEC-345); F2-close INTEGRATE reconciliation; phase advances F2→F3 (2026-09-06)

**Parent-commit:** `569d85a8` (`develop` tip; unchanged this burst — no `develop`-side commit; F2/F3 are spec-only phases, no code merged).

**Trigger:** Phase F2 spec evolution (architect + product-owner + formal-verifier, across multiple INTEGRATE sub-bursts) authored the binding BCs/VPs/holdouts/ADR from the two F1 decomposition proposals, then ran 10 rounds of scoped adversarial review to convergence (passes 7-10 all 0-CRIT/HIGH/MED, cosmetic-only) and a pre-gate consistency audit (CONSISTENT verdict). The human then reviewed the F2 delta at the gate, issued one F2-gate TIGHTENING decision on `@Name` single-result resolution (DEC-345), and APPROVED F2 in full (DEC-346). This state-manager burst is the catch-up/close-out step: recording both decisions in STATE.md (neither had yet been logged there), performing the 6-item F2-close INTEGRATE reconciliation sweep the orchestrator identified as non-blocking propagation gaps, and advancing the tracked phase to F3.

**Actions this burst:**

1. Verified `.factory/` worktree preconditions (`.git` marker, `git rev-parse --git-dir`, branch `factory-artifacts`) — all PASS. No `project.yaml` (single-repo; `.factory-project/` preconditions N/A).
2. Confirmed via direct inspection of `.factory/specs/prd/*.md`, `BC-INDEX.md`, `holdout-scenarios.md`, `cross-cutting.md`, and `.factory/architecture/component-graph.md` that the substantive F2 spec-evolution work (12 new BCs, ADR-0023, 21 VPs across `VP-674-001..021`, 12 holdout scenarios `H-NEW-MENTION-001..012`, the DEC-345 `filter_by_name_match` tightening amendment to BC-X.7.007, and the full Markdown Mentions Delta DAG-verification section in `component-graph.md`) was already present and internally consistent — BC-INDEX.md (`total_bcs: 754`, `index_version: v6.86`), `holdout-scenarios.md` (`total_holdouts: 118`), and `CANONICAL-COUNTS.md`'s per-file/Sum/grand-total rows and `last_verified` narrative all already reflected the final, reconciled state. The gaps were confined to cross-reference/bookkeeping documents that had not been swept in the same pass: `spec-changelog.md`, `CANONICAL-COUNTS.md`'s `## ADRs` section, `system-overview.md`, `specs/prd/README.md`, and the two F2 delta files' `status:` fields.
3. Minted **DEC-345** (F2-gate tightening) and **DEC-346** (F2 approval) in STATE.md's Decisions Log.
4. Performed the 6-item F2-close INTEGRATE cleanup sweep:
   - `spec-changelog.md` `[2.2.0]` entry: corrected "6 existing BCs amended" → **7** (the original text already listed 7 IDs — BC-7.2.004 + 6 cross-reference-only BCs — but the header undercounted); corrected VP count 17→**21** (55→76 running total) and holdout count 9→**12** (106→118 running total); added a new paragraph documenting the post-entry adversarial-convergence and F2-gate tightening additions (pass-2 M-3's 2 holdouts, the F2-gate's BC-X.7.007 amendment + 1 holdout + 1 VP, and 3 further adversarial-pass VPs) that account for the corrected totals, including the JSM `--request-type` wiring (BC-3.8.018) already covered in the original entry.
   - `.factory/architecture/component-graph.md`: **already contained** the full "Markdown Mentions Delta — DAG Verification (Issue #674, F2 2026-09-06)" section with every edge named in the F2 architecture-delta (`cli::issue::mentions → adf`, `→ api::jira::users`, `→ cli::issue::helpers`, `→ error`, plus the four handler→mentions edges) and an explicit "DAG remains acyclic" verdict — no edit needed, confirmed only.
   - `.factory/architecture/system-overview.md`: fixed the dead-symbol citation `AdfToTextRenderer::render_node` → `AdfRenderer::render_node` (the real struct name; `AdfToTextRenderer` does not exist in `src/adf.rs`).
   - `.factory/specs/prd/README.md`: updated both informational holdout rows (Document Map + Supplement Index) from `115` / `H-NEW-MENTION-001..H-NEW-MENTION-009` to `118` / `H-NEW-MENTION-001..H-NEW-MENTION-012`.
   - `.factory/specs/prd/CANONICAL-COUNTS.md` `## ADRs`: bumped "Canonical ADR count: 19" → **23** (ADR-0001..0023, no gaps); added bullets for ADR-0020 (per-profile credential ownership), ADR-0021 (Windows DPAPI fallback), ADR-0022 (tenant_info cloud_id), and ADR-0023 (markdown mention conversion seam); updated the "Location convention" line's upper bound `ADR-0017..0019` → `ADR-0017..0023`. Additionally added the missing **ADR-0023** row to `.factory/architecture/adr-index.md`'s ADR Summary Table (that file's own row set stopped at ADR-0022) — without this, the CANONICAL-COUNTS.md verification instruction ("count rows in adr-index.md Summary Table") would itself have gone out of sync the moment the canonical count was bumped to 23.
   - `.factory/phase-f2-spec-evolution/prd-delta-674.md` and `verification-delta-674.md`: flipped `status: draft` → `status: complete` in both frontmatter blocks (F2 is now human-approved).
5. Re-ran the three required count-verification scripts — all exit 0 (see Dim-2 Attestation).
6. Logged two new process-gap follow-ups (`ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED`) alongside the carried-forward cycle-004 process-gap backlog, unchanged.
7. Advanced the tracked phase: `cycle-005 (adf-mentions) Phase F2 spec evolution APPROVED; Phase F3 (incremental story decomposition) IN PROGRESS.`

**Adversary verdict:** N/A this state-manager burst — no `adversary` agent dispatched. The 10-pass adversarial-review convergence and pre-gate consistency audit this entry records were run by prior F2 spec-evolution sub-bursts (not by this bookkeeping/INTEGRATE-cleanup burst); their outcome (passes 7-10 all 0-CRIT/HIGH/MED, cosmetic-only; pre-gate audit CONSISTENT) is cited above as context for DEC-346, not re-run here.

**Files touched (Dim-1): 10 unique files/paths this burst (all `.factory/` — 8 modified, 1 archived-content update, 1 this burst's own log entry), all committed in the state-manager's own single atomic commit**

- `.factory/spec-changelog.md` (corrected `[2.2.0]` entry counts + added post-entry-additions paragraph)
- `.factory/specs/prd/CANONICAL-COUNTS.md` (`## ADRs` section: 19→23, 4 new bullets, location-convention range extended)
- `.factory/architecture/adr-index.md` (added missing ADR-0023 Summary Table row)
- `.factory/architecture/system-overview.md` (dead-symbol citation fix: `AdfToTextRenderer` → `AdfRenderer`)
- `.factory/specs/prd/README.md` (2 holdout-count rows: 115→118, `H-NEW-MENTION-001..009` → `..012`)
- `.factory/phase-f2-spec-evolution/prd-delta-674.md` (`status: draft` → `complete`)
- `.factory/phase-f2-spec-evolution/verification-delta-674.md` (`status: draft` → `complete`)
- `STATE.md` (v3.76 — full-content Write)
- `cycles/cycle-005/session-checkpoints.md` (v3.75 checkpoint archived with "Superseded at" note)
- `cycles/cycle-005/burst-log.md` (this entry)

**Known hook noise this burst (pre-existing, not caused by this burst's edits, not blocking):** `validate-template-compliance` fired on the `system-overview.md` edit (that file has never carried the `architecture-section-template.md` frontmatter/section structure — pre-existing drift, unrelated to the one-line citation fix made here); `validate-input-hash` fired on the `verification-delta-674.md` edit (this file is one of the 165 factory-wide stale-`input-hash` artifacts tracked under `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING`); `validate-input-hash`/`validate-factory-path-root`/`validate-template-compliance` also reported `FUEL_EXHAUSTED` on the large `spec-changelog.md` edit. All edits were grep/script-verified to have landed correctly regardless (see Actions 4-5 above); logged as `FACTORY-HOOK-FUEL-EXHAUSTED`, a tracked engine-tooling process-gap, not a jira-cli product defect.

**Dim-2 Attestation:** `bash scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `bash scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (754 total across 9 files; Surface H footer checked where present)"). `bash scripts/check-bc-citation-symbols.sh` → exit 0 ("Check passed: 463 citations checked"). Counts entering F3: **754 BCs / 76 VPs (tracked running total; +21 net-new `VP-674-NNN` ids this cycle; the pre-existing `VP-COUNT-RECONCILIATION` gap — raw-grepped VP ids across `bc-*.md` bodies materially exceeding the tracked running total — remains open and non-blocking) / 118 holdout scenarios / 172 stories (unchanged; F3 will add cycle-005's story files)**. DEC-namespace collision check: DEC-345 and DEC-346 are the next two sequential IDs after DEC-344, no collision.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (bookkeeping-only, no build).

**Dim-6 Attestation:** No `src/`/`tests/` change this burst — cycle-005 remains spec-only through F2/F3. `develop` HEAD unchanged at `569d85a8`.

**Dim-7 Attestation:** N/A — no CI-relevant change this burst (no code, no workflow file touched).

**Codifications:** **DEC-345** — human F2-gate TIGHTENING decision: a lone `@Name` search result whose display name does NOT case-insensitively-substring-match the query now HARD ERRORS (exit 64) via a new pure `filter_by_name_match` pre-filter step inserted between the active-user filter and `disambiguate_user`, rather than silently resolving; `disambiguate_user` itself is unchanged; `MatchResult::None` is thereby unreachable via the mention resolver's call site. Resolves EC-X.7.007-5's former open decision; supersedes the architect's own pass-through recommendation from `delta-analysis.md`. Ref ADR-0023 §7; implemented in BC-X.7.007 (amended in place, `cross-cutting.md`); 1 new holdout scenario (H-NEW-MENTION-012) and 1 new VP (VP-674-021). **DEC-346** — human APPROVED cycle-005 (`adf-mentions`, #674) Phase F2 spec evolution in full: 12 new BCs (BC-7.2.016..019, BC-X.7.007..010, BC-3.3.012/BC-3.4.032/BC-3.5.013/BC-3.8.018) + 7 BCs amended in place (BC-7.2.004 + 6 cross-reference-only amendments) + the DEC-345 BC-X.7.007 tightening amendment; new ADR-0023; 21 VPs (`VP-674-001..021`); 12 holdout scenarios (`H-NEW-MENTION-001..012`, including H-009 the human-required live-Jira E2E round-trip); spec version 2.1.0→2.2.0 (MINOR). Adversarial convergence reached over 10 passes (passes 7-10 all 0-CRIT/HIGH/MED, cosmetic-only); pre-gate consistency audit verdict CONSISTENT. Phase advances F2→F3.

**Closes:** cycle-005 Phase F2 (spec evolution) — human-approved; the 6-item F2-close INTEGRATE reconciliation sweep the orchestrator dispatched (all 6 confirmed landed — 5 required an edit, 1 — `component-graph.md` — was already complete and confirmed only). **Does NOT close:** cycle-005 itself, which remains open through F3-F7; the pre-existing `VP-COUNT-RECONCILIATION` tracked follow-up (still non-blocking); the newly-logged `ADR-COUNT-CANONICAL-GUARD-GAP` and `FACTORY-HOOK-FUEL-EXHAUSTED` process-gaps (both target future engine/maintenance work, neither blocks cycle-005); any of the carried-forward cycle-001/002/003/004 standing items (all unchanged).

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Verified F2 spec-evolution artifacts already present/consistent; minted DEC-345/DEC-346; performed 6-item F2-close INTEGRATE cleanup sweep; re-ran count-verification scripts; logged 2 new process-gaps; STATE.md v3.76 full-content Write; archived v3.75 checkpoint; commit + push to `factory-artifacts` | `spec-changelog.md`, `CANONICAL-COUNTS.md`, `adr-index.md`, `system-overview.md`, `README.md` (specs/prd), `prd-delta-674.md`, `verification-delta-674.md`, `STATE.md` (v3.76), `cycles/cycle-005/burst-log.md` (this file), `cycles/cycle-005/session-checkpoints.md` |

---

## Burst: Burst 3 — Phase F3 story decomposition APPROVED (DEC-347); input-hash refresh; F4 wave tracking setup; phase advances F3→F4 (2026-09-06)

**Parent-commit:** `569d85a8` (`develop` tip; unchanged this burst — no `develop`-side commit; F3/F4-dispatch are bookkeeping-only, no code merged yet).

**Trigger:** Phase F3 (incremental story decomposition), run by story-writer + adversary across prior sub-bursts, produced 2 stories (`S-cycle5-mention-pure-conversion` Wave 1, `S-cycle5-mention-resolution-wiring` Wave 2) plus a dependency graph and wave schedule, converging over 6 rounds of adversarial story review (passes 5-6 both CLEAN — F-H-01/F-H-02/F-M-01/F-M-02/F-M-03 fixed across earlier passes). The human then reviewed the complete F3 decomposition at the gate and **APPROVED** it in full (DEC-347). This state-manager burst records the decision, refreshes deferred `input-hash` drift left by the prior story-writer/adversary fix rounds (no shell access in those roles), registers the 2 approved stories in the repo's Phase-3/F4 wave-tracking convention (`.factory/sprint-state.yaml`, `cycle_NNN_<bundle>` top-level keys — this repo has no `sprint-state.yaml`/`wave-state.yaml` under `.factory/stories/` or per-cycle; the single top-level `.factory/sprint-state.yaml` is the established convention, confirmed by grepping every prior `cycle_*` section including `cycle_002_field_dx` and `cycle_004_windows_correctness`), and advances the tracked phase to F4.

**Actions this burst:**

1. Verified `.factory/` worktree preconditions (`.git` marker, `git rev-parse --git-dir`, branch `factory-artifacts`) — all PASS. No `project.yaml` (single-repo; `.factory-project/` preconditions N/A).
2. Minted **DEC-347** (F3 human gate APPROVAL) in STATE.md's Decisions Log: 2 stories — `S-cycle5-mention-pure-conversion` (Wave 1, 13 pts, priority P0/module_criticality CRITICAL, 15 ACs, `depends_on: []`, target `src/adf.rs`) + `S-cycle5-mention-resolution-wiring` (Wave 2, 13 pts, priority P0/module_criticality HIGH, 17 ACs, `depends_on: [S-cycle5-mention-pure-conversion]`, target `src/cli/issue/mentions.rs`); acyclic A→B dependency (Kahn-layering proven); 2 sequential waves; critical path 2 stories / 26 points (100% of cycle points). Story count 172→174 (already reflected in STORY-INDEX.md v1.6.16 from prior F3 authoring/fix bursts — this burst recorded the gate decision, it did not itself add the rows).
3. Refreshed deferred `input-hash` drift on the F3 story artifacts, per file:
   - `S-cycle5-mention-pure-conversion.md` — `--check` already clean (`90a5d3a`), no update needed.
   - `S-cycle5-mention-resolution-wiring.md` — DRIFT (`6b68f5f` ≠ computed `86fbb15`); `--update` applied → `86fbb15`.
   - `dependency-graph-extended.md` — DRIFT (`a6eb33d` ≠ computed `e9c8114`); `--update` applied. Because this file's `inputs:` list includes `S-cycle5-mention-resolution-wiring.md` (updated in the prior step), the hash actually written was **`ca77401`**, not the pre-update `e9c8114` snapshot — the cascade is expected and correct (update order matters: resolution-wiring before its dependents).
   - `wave-schedule.md` — DRIFT (`9eea75a` ≠ computed `37e32c0`); `--update` applied. Same cascade effect from the prior two updates → final hash **`b59b05c`**.
   - Re-ran `--check` on all 4 files after updating: all exit 0 (clean).
   - `STORY-INDEX.md` — checked per the orchestrator's dispatch instruction; direct tool invocation returned `compute-input-hash: no inputs: field found in frontmatter` (exit 1). This file carries no `inputs:`/`input-hash:` frontmatter fields at all (confirmed via `grep -n "^inputs\|^input-hash" STORY-INDEX.md` → zero matches) — it is not tracked by the `compute-input-hash` mechanism by design (an index file with no declared inputs, unlike a derived artifact). **No action possible or needed; not a drift case.**
4. Registered the 2 approved stories in `.factory/sprint-state.yaml` under a new top-level `cycle_005_adf_mentions:` section, following this repo's established convention (grepped every prior `cycle_*` top-level key in the file — `cycle_002_field_dx`, `cycle_004_windows_correctness`, etc. — all use this single top-level file, not a per-cycle or per-stories-dir sprint-state/wave-state file): `wave_1_status` = READY (Story A, no deps, not yet dispatched), `wave_2_status` = BLOCKED (Story B, `depends_on: [S-cycle5-mention-pure-conversion]`, Wave 1 not yet merged), with per-story `bc_anchors`/`vp_anchors`/`holdout_anchors`/`points`/`priority`/`module_criticality` fields mirroring the format used by every prior cycle section in this file.
5. Re-ran the two count-verification scripts the orchestrator named (story count changed only; BC/holdout counts unaffected by an F3-gate decision) — both exit 0 (see Dim-2 Attestation).
6. Advanced the tracked phase: `cycle-005 (adf-mentions) Phase F3 story decomposition APPROVED; Phase F4 (delta implementation) IN PROGRESS — Wave 1 (Story A, S-cycle5-mention-pure-conversion).`
7. Carried forward all standing process-gaps unchanged (`VP-COUNT-RECONCILIATION`, `ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED`, and every cycle-001/002/003/004 historical item) — no new process-gap identified this burst.

**Adversary verdict:** N/A this state-manager burst — no `adversary` agent dispatched. The 6-pass adversarial story-convergence loop this entry records (passes 5-6 both CLEAN) was run by prior F3 story-decomposition sub-bursts (story-writer + adversary), not by this bookkeeping burst; cited above as context for DEC-347, not re-run here.

**Files touched (Dim-1): 7 unique files/paths this burst (all `.factory/` — 3 story-artifact input-hash updates, 1 wave-tracking registration, 1 STATE.md rewrite, 2 cycle-005 log files), all committed in the state-manager's own single atomic commit**

- `.factory/cycles/cycle-005/phase-f3-stories/S-cycle5-mention-resolution-wiring.md` (`input-hash` refreshed `6b68f5f` → `86fbb15`)
- `.factory/cycles/cycle-005/phase-f3-stories/dependency-graph-extended.md` (`input-hash` refreshed `a6eb33d` → `ca77401`)
- `.factory/cycles/cycle-005/phase-f3-stories/wave-schedule.md` (`input-hash` refreshed `9eea75a` → `b59b05c`)
- `.factory/sprint-state.yaml` (new `cycle_005_adf_mentions:` top-level section — Wave 1 ready, Wave 2 blocked-on-Wave-1)
- `STATE.md` (v3.77 — full-content Write)
- `cycles/cycle-005/session-checkpoints.md` (v3.76 checkpoint archived with "Superseded at" note)
- `cycles/cycle-005/burst-log.md` (this entry)

**Known hook noise this burst (pre-existing, not caused by this burst's edits, not blocking):** none newly observed. The standing `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` debt (165 factory-wide stale artifacts) is unaffected — the 3 files refreshed this burst were addressed because the orchestrator explicitly named them as this cycle's own deferred drift, not as a draw against that separately-tracked batch debt.

**Dim-2 Attestation:** `bash scripts/check-spec-counts.sh` → exit 0 ("Check passed: 8 bc files validated"). `bash scripts/check-bc-cumulative-counts.sh` → exit 0 ("OK: all cumulative BC counts verified (754 total across 9 files; Surface H footer checked where present)"). Counts entering F4: **754 BCs / 76 VPs (tracked running total, unchanged this burst) / 118 holdout scenarios (unchanged) / 174 stories (172→174, +2 cycle-005 rows)**. DEC-namespace collision check: DEC-347 is the next sequential ID after DEC-346, no collision.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (bookkeeping-only, no build).

**Dim-6 Attestation:** No `src/`/`tests/` change this burst — cycle-005 remains spec/tracking-only through F3→F4 dispatch. `develop` HEAD unchanged at `569d85a8`.

**Dim-7 Attestation:** N/A — no CI-relevant change this burst (no code, no workflow file touched).

**Codifications:** **DEC-347** — human APPROVED cycle-005 (`adf-mentions`, #674) Phase F3 story decomposition in full: 2 stories (`S-cycle5-mention-pure-conversion` Wave 1 13pts CRITICAL 15 ACs `depends_on:[]`; `S-cycle5-mention-resolution-wiring` Wave 2 13pts HIGH 17 ACs `depends_on:[S-cycle5-mention-pure-conversion]`); acyclic A→B dependency; 2 sequential waves; critical path 26 points; story count 172→174. Reached via 6 rounds of adversarial story convergence (passes 5-6 CLEAN); all 13 in-scope BCs / 21 VPs / 12 holdouts mapped across the two stories (three-surface EC reconciliation proof). Phase advances F3→F4.

**Closes:** cycle-005 Phase F3 (incremental story decomposition) — human-approved. **Does NOT close:** cycle-005 itself, which remains open through F4-F7; any carried-forward standing item (all unchanged, see Constraints Carried Forward in STATE.md); the newly-registered F4 wave tracking is a `ready`/`blocked` starting state, not a delivery outcome — Wave 1 (`S-cycle5-mention-pure-conversion`) has not yet been dispatched to an implementer.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Minted DEC-347; refreshed 3 stale `input-hash` values (1 already clean); registered 2 stories in `.factory/sprint-state.yaml` F4 wave tracking; re-ran count-verification scripts; STATE.md v3.77 full-content Write; archived v3.76 checkpoint; commit + push to `factory-artifacts` | `S-cycle5-mention-resolution-wiring.md`, `dependency-graph-extended.md`, `wave-schedule.md` (input-hash refresh), `sprint-state.yaml` (new section), `STATE.md` (v3.77), `cycles/cycle-005/burst-log.md` (this file), `cycles/cycle-005/session-checkpoints.md` |

---

## Burst: Burst 4 — F4 Wave 1 (Story A) implemented + PR #778 opened — SESSION WRAP / PAUSE (2026-09-07)

**Parent-commit:** `569d85a8` (`develop` tip; unchanged this burst — PR #778 not yet merged).

**Trigger:** Human requested a session wrap ("pause the factory and checkpoint cycle-005 for a session clear") after Phase F4 Wave 1 (Story A, `S-cycle5-mention-pure-conversion`) had been dispatched, implemented, and opened as PR #778 by the standard per-story-delivery TDD pipeline (test-writer → implementer → demo-recorder → pr-manager → devops-engineer) in the interim since Burst 3.

**Actions taken:**

1. **Recorded the Wave 1 (Story A) delivery status reached since Burst 3** (delivered by the per-story-delivery pipeline, not by this state-manager burst): the AC-007 `\@`-escape mechanism, flagged at F3-gate time as an F4 SPIKE, came back **FEASIBLE** — implemented via ADR-0023 §4's sentinel scheme (`SENTINEL_ESCAPE`/`SENTINEL_GUARD` collision guard). A further implementation-time discovery — CommonMark's inline grammar can destroy characters inside a bracket-form `[~accountid:<id>]` id before any post-`finish()` tree-walk ever runs (e.g. `[~accountid:_a_]` loses its underscores to emphasis parsing) — required a second, harder pre-parse protection mechanism, `protect_bracket_mentions`, layered onto the same `protect_mention_escapes` helper ahead of the existing `\@`-escape steps. `MentionResolutions` gained a public inserter API for Story B's later use (closes the L-2 flag from the F2-gate record).
2. **Committed the two outstanding cycle-005 F4 spec artifacts** documenting the discovery above, left uncommitted by the implementation work: `specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` (new §4a "Bracket-form pre-parse protection" addendum — mechanism, eligibility grammar, the collision guard closing the primary collision with an accepted one-level GUARD-sub-range residual symmetric to `\@`'s own `U+E001` residual, and the L-1 accepted residual for a start-of-line `[~accountid:X]:` look-alike reference definition) and `phase-f2-spec-evolution/architecture-delta.md` (new §4.1a addendum cross-referencing ADR-0023 §4a, `input-hash` refreshed `504dd1e`→`d51137a`).
3. **Recorded Story A's per-story adversarial convergence as COMPLETE** — 3 clean passes (passes 3-5, all 0-CRIT/HIGH/MED) — and PR #778's review status: pr-reviewer **APPROVE** (1 IMPORTANT doc finding fixed directly in the PR body), security-reviewer **CLEAN** (1 non-blocking LOW deferred to Story B). PR #778 (branch `feat/cycle5-mention-pure-conversion` @ `89b84a1f`) has 13/14 CI checks green with "Mutation testing" **PENDING** at the moment of this wrap; the worktree remains mounted at `.worktrees/cycle5-mention-pure-conversion`. No sub-agent work was abandoned mid-step — an implementer that looped on a background test was recovered earlier in the interim, and its pre-PR fixes were committed as `89b84a1f` before this burst began.
4. **Paused the pipeline for the session wrap:** STATE.md frontmatter `pipeline:` flipped `ACTIVE`→`PAUSED`; `phase:` prefixed `"PAUSED 2026-09-07."`; `version` bumped `3.77`→`3.78`; `timestamp`/`last_amended`/`current_step` refreshed (verbatim-strict per D-441..D-449, with the required `trajectory-tail →1→3→0→2` + `D-chain cite D-31` markers preserved per D-453(d)/D-443(a)).
5. Updated Phase Progress (F4-DELTA-IMPLEMENTATION row notes), Current Phase Steps (replaced with a new 7-row Burst 4 table; Burst 3's rows archived to this file's Burst 3 entry, already fully covered in prose there), Convergence Status, Concurrent Cycles, Constraints Carried Forward (new Burst 4 paragraph; Burst 3 paragraph condensed one-burst-lag), Drift/Standing Items (same treatment), and Historical Content (added a Wave-1 delivery-evidence row citing PR #778 + the worktree path; updated the burst-history summary row).
6. **Archived the v3.77 Session Resume Checkpoint** to `cycles/cycle-005/session-checkpoints.md` with a "Superseded at" note, then wrote a new v3.78 checkpoint in STATE.md reflecting the paused position, PR #778's exact review/CI state, and the resume path (`/vsdd-factory:rehydrate-wave` then `/vsdd-factory:next-step`).
7. Carried forward all standing process-gaps unchanged (`VP-COUNT-RECONCILIATION`, `ADR-COUNT-CANONICAL-GUARD-GAP`, `FACTORY-HOOK-FUEL-EXHAUSTED`, and every cycle-001/002/003/004 historical item) — no new process-gap identified this burst.
8. Refreshed the STATE.md banner `wc -l` claim + dual-margin note to the actual post-Write line count (343 lines) per BC-5.39.005.

**Adversary verdict:** N/A this state-manager burst — no `adversary` agent dispatched. Story A's 3-clean-pass per-story adversarial convergence record cited above was produced by the per-story-delivery pipeline's own review loop prior to this burst, not re-run here.

**Files touched (Dim-1): 5 unique files/paths this burst, all committed in the state-manager's own single atomic commit**

- `STATE.md` (v3.78 — full-content Write)
- `cycles/cycle-005/session-checkpoints.md` (v3.77 checkpoint archived with "Superseded at" note)
- `cycles/cycle-005/burst-log.md` (this entry)
- `specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` (§4a bracket-form pre-parse-protection addendum — produced by the F4 implementation work, committed by this burst)
- `phase-f2-spec-evolution/architecture-delta.md` (§4.1a addendum, `input-hash` `504dd1e`→`d51137a` — produced by the F4 implementation work, committed by this burst)

**Known hook noise this burst:** `validate-trajectory-tail-cell-completeness` (BC-5.39.009, priority 158) initially blocked twice on the `current_step`/`Last Updated` cells for using the `trajectory_tail:` (underscore+colon) label form instead of the hook's required `trajectory-tail ` (hyphen+space) literal immediately preceding the arrow-sequence — corrected both sites to the hyphenated form (content unchanged otherwise). `validate-state-structure` also blocked once transiently on a stray banner-`wc -l` mismatch introduced by an intermediate edit, self-corrected before the final Write. Neither reflects a defect in this burst's substantive content — both were resolved before the commit below.

**Dim-2 Attestation:** No count-verification script applies to this burst (SESSION WRAP is a bookkeeping pause, not a spec/story/BC-count-changing event) — `check-spec-counts.sh`/`check-bc-cumulative-counts.sh` not re-run; counts unchanged (754 BCs / 76 VPs / 118 holdouts / 174 stories, all carried forward verbatim from Burst 3).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (bookkeeping-only, no build).

**Dim-6 Attestation:** No `src/`/`tests/` change committed by this state-manager burst — the F4 Wave 1 implementation itself (which does touch `src/`/`tests/`) lives on PR #778's branch (`feat/cycle5-mention-pure-conversion` @ `89b84a1f`), separate from this `.factory/` commit. `develop` HEAD unchanged at `569d85a8`.

**Dim-7 Attestation:** N/A — no CI-relevant change in this `.factory/` commit (no code, no workflow file touched); PR #778's own CI is tracked separately on GitHub, not by this commit.

**Codifications:** No new DEC this burst — a session-wrap pause is bookkeeping, not a phase-gate decision. Recorded (not decided) this burst: Story A per-story adversarial convergence COMPLETE (3 clean passes); PR #778 OPEN, pr-reviewer APPROVE, security-reviewer CLEAN, CI 13/14 green (Mutation testing PENDING); pipeline PAUSED.

**Closes:** nothing — this burst does not close Phase F4, cycle-005, or any story; it pauses the pipeline for a session clear. **Does NOT close:** PR #778's CI, its merge, the Wave-1 integration gate, or Wave 2 (`S-cycle5-mention-resolution-wiring`, still blocked-on-wave-1) — all remain for the next session, per the resume command recorded in STATE.md's Session Resume Checkpoint.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Recorded F4 Wave 1 (Story A) delivery status (per-story-delivery pipeline's own work, not this burst's); committed 2 outstanding F4 spec artifacts (ADR-0023 §4a, architecture-delta.md §4.1a); paused pipeline (`ACTIVE`→`PAUSED`); STATE.md v3.78 full-content Write; archived v3.77 checkpoint; commit + push to `factory-artifacts` | `STATE.md` (v3.78), `cycles/cycle-005/burst-log.md` (this file), `cycles/cycle-005/session-checkpoints.md`, `ADR-0023-*.md` (§4a), `phase-f2-spec-evolution/architecture-delta.md` (§4.1a) |

---

## Burst: Burst 5 — F4 Wave 1 MERGED via >120-mutant escape-hatch ADMIN-BYPASS (DEC-352) (2026-09-09)

**Parent-commit:** `1daf5aa9` (`.factory` factory-artifacts tip immediately before this burst — the cycle-006 F7-close commit; unrelated to `develop`, which moved separately via PR #778's own merge).

**Trigger:** Human authorized recording of the verified fact that cycle-005 Wave 1 (`S-cycle5-mention-pure-conversion`, PR #778) was merged to `develop` via the >120-mutant escape-hatch admin-bypass, and directed the state-manager to record cycle-005 Phase F4 Wave-1 delivery + merge in STATE.md, archiving the prior v3.91 Session Resume Checkpoint (located in `cycles/cycle-006/session-checkpoints.md`, since v3.91 was written during cycle-006's own Burst 13) first.

**Actions taken:**

1. **Minted DEC-352:** cycle-005 Wave-1 story `S-cycle5-mention-pure-conversion` (PR #778) MERGED to `develop` via the >120-mutation escape-hatch ADMIN-BYPASS, human-authorized, 2026-09-09. Squash-merge commit `708c8b32` ("feat(adf): pure markdown-mention conversion (Story A, #674) (#778)"); `develop` advanced `a9168212`→`708c8b32`. PR #778's `src/adf.rs` diff generated 281 in-diff mutants (> the 120-mutant cycle-006 escalation threshold), so the sharded mutation gate correctly ESCALATED (Mutation Test Plan pass → 8 shards skipped → Mutation Testing Aggregate fail → CI Gate fail) — the first real production exercise of the cycle-006 escape hatch. All 14 other checks passed. Human reviewed split-below-120/defer/admin-bypass and chose admin-bypass on: (a) #778 already per-story adversarially converged (3 clean passes), pr-reviewer APPROVE, security-reviewer CLEAN (1 LOW deferred to Wave 2); (b) a local `cargo mutants --in-diff` safety-net run, started but stopped partway (~96 of 281 mutants completed) due to environment contention, showed 66 caught / 0 missed / 21 timeout (environmental) / 9 unviable; (c) the advisory nightly full-scope run remains the ongoing net, with a follow-up to surface its kill-rate via `$GITHUB_STEP_SUMMARY` now queued (`research/mutation-testing-badge-visibility-2026-09-09.md`, produced by a research agent this session). The admin-bypass merge itself was executed by the human directly in the GitHub UI — the orchestrator's `gh pr merge --admin` was correctly blocked by the environment's permission classifier. Verified DEC-namespace clean: max prior ID DEC-351, DEC-352 collision-free (grep-checked against `STATE.md` and all of `.factory/`).
2. **Flipped STORY-INDEX.md:** both `S-cycle5-mention-pure-conversion` rows (Story Manifest ~line 1219, Feature Followup ~line 1636) to the repo's standard delivered convention (`**done** — merged 2026-09-09, PR #778 @ 708c8b32 (squash, escape-hatch admin-bypass per DEC-352)`); also updated the Wave-2 row's `depends_on` note to SATISFIED/UNBLOCKED for consistency, since it directly follows from the same verified fact. STORY-INDEX version bumped; `total_stories` unchanged at 175 (delivery, not authorship). A pre-existing, unrelated `count_propagation_drift` false-positive fired on this edit (a historical "19 BCs" string at ~line 192, dated 2026-08-05, predates this session and is unrelated to this burst's rows) — documented here as known hook noise, not fixed (out of scope for this burst).
3. **Updated `sprint-state.yaml`'s `cycle_005_adf_mentions` section:** wave_1 flipped `ready`→`done` (`pr: 778`, `merge_sha: "708c8b32"`, `merged_at: "2026-09-09"`); wave_2 flipped `blocked`→`ready` (dependency SATISFIED).
4. **Recorded two new standing items in Drift/Standing Items** (deliberately NOT Blocking Issues — neither blocks Wave 2 dispatch): `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1` (the DEC-347 accepted tradeoff — pure bracket-mention conversion shipped without the effectful preflight/resolution wiring — is now OPEN, target closure = Wave 2's BC-X.7.010 preflight) and `CYCLE5-W1-LOCAL-MUTATION-VERIFY-PARTIAL` (LOW, informational — the local in-diff mutation safety-net run for #778 was only partial, environment-contention timeouts; covered by the nightly net).
5. **Updated pipeline position:** `cycle_005_status` frontmatter updated to record Wave 1 MERGED / Wave 2 UNBLOCKED; `current_cycle`/`feature_mode_bundle` unchanged (already `cycle-005`/`adf-mentions` since cycle-006's Burst-13 close). `activation_head`/`activation_version` left UNCHANGED (`a9168212`/`v0.7.0-dev.5`) per explicit orchestrator instruction — no release tag cut this burst, though `develop`'s real tip is now `708c8b32`.
6. **Archived the v3.91 Session Resume Checkpoint** to `cycles/cycle-006/session-checkpoints.md` (the cycle-006 burst that produced it, located per the orchestrator's explicit locate-first instruction) with a "Superseded at" note, then wrote a new v3.92 checkpoint in STATE.md reflecting Wave 1's merge, Wave 2's unblocked status, and the resume path.
7. Updated Phase Progress (new `F4-WAVE1-MERGED (cycle-005, Burst 5)` row), Current Phase Steps (fresh Burst-5 table; Burst 13's cycle-006 table folded one level further into its existing pointer note), Decisions Log (new DEC-352 row + updated cycle-005 note paragraph), Blocking Issues (clarifying note that the interim window is a Drift item, not a blocker), Convergence Status, Concurrent Cycles (`develop`'s real tip vs. `activation_head` distinction spelled out), Constraints Carried Forward (new Burst-5 paragraph; Burst-4 paragraph condensed one-burst-lag), Historical Content (cycle-005 rows updated; new Wave-1 merge admin-bypass evidence row added), and Drift/Standing Items (new 2-row table for the items in step 4).
8. Refreshed the STATE.md SIZE BUDGET banner (shorter than Burst 13's cycle-close banner, to offset this burst's additions) and its `wc -l` claim to the actual post-Write line count (384 lines).

**Adversary verdict:** N/A this state-manager burst — no `adversary` agent dispatched. PR #778's own review/CI evidence (pr-reviewer APPROVE, security-reviewer CLEAN, 3-clean per-story adversarial convergence, partial local mutation safety-net run) was produced by the per-story-delivery pipeline and the human's own admin-bypass evaluation prior to this burst, not re-run here.

**Files touched (Dim-1): 6 unique files/paths this burst, all committed in the state-manager's own single atomic commit**

- `STATE.md` (v3.92 — full-content Write)
- `cycles/cycle-006/session-checkpoints.md` (v3.91 checkpoint archived with "Superseded at" note)
- `cycles/cycle-005/burst-log.md` (this entry)
- `stories/STORY-INDEX.md` (both `S-cycle5-mention-pure-conversion` rows flipped to done; Wave-2 row's dependency note updated)
- `sprint-state.yaml` (`cycle_005_adf_mentions` wave_1 → done, wave_2 → ready)
- `research/mutation-testing-badge-visibility-2026-09-09.md` (previously-untracked research artifact, produced by a research agent this session, committed here as supporting evidence for DEC-352's queued badge-visibility follow-up)

**Known hook noise this burst:** `validate-count-propagation` fired a false positive on the STORY-INDEX.md edit, citing an unrelated pre-existing historical string ("19 BCs" at ~line 192, dated 2026-08-05, predates this session) as drift against the current 754-BC running total — documented, not fixed (out of scope; the string is unrelated to the rows this burst touched). `validate-state-structure` twice blocked transiently on the SIZE BUDGET banner's `wc-l` self-citation during iterative editing (a wrong "wc -l" spacing, then a stale line-count figure after a subsequent edit shifted the file by 2 lines) — both corrected before the final state; neither reflects a defect in this burst's substantive content.

**Dim-2 Attestation:** No count-verification script applies to this burst in the BC/VP/holdout sense (`check-spec-counts.sh`/`check-bc-cumulative-counts.sh` not re-run) — counts unchanged (754 BCs / 76 VPs / 118 holdouts / 175 stories, all carried forward verbatim). `total_stories` unchanged since this burst records delivery of an already-registered story, not new story authorship.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (bookkeeping-only, no build). PR #778's own binary was already built and tested by CI as part of its merge, separate from this commit.

**Dim-6 Attestation:** No `src/`/`tests/` change committed by this state-manager burst — Wave 1's implementation itself (which did touch `src/adf.rs`/`tests/`) landed on `develop` @ `708c8b32` via PR #778's own merge, separate from this `.factory/` commit.

**Dim-7 Attestation:** N/A — no CI-relevant change in this `.factory/` commit (no code, no workflow file touched); PR #778's own CI (including the sharded mutation gate's escalation) is tracked on GitHub, not by this commit.

**Codifications:** **DEC-352** minted this burst — cycle-005 Wave 1 MERGED via the >120-mutant escape-hatch ADMIN-BYPASS, human-authorized. Recorded (not decided, already decided by the human before this burst): the admin-bypass evaluation itself, PR #778's review/CI evidence, the partial local mutation safety-net results.

**Closes:** nothing new this burst does not itself close any phase or cycle. **Advances:** cycle-005 Phase F4 — Wave 1 delivery is now COMPLETE; Wave 2 (`S-cycle5-mention-resolution-wiring`) dependency is SATISFIED and UNBLOCKED, becoming the next F4 work. **Does NOT close:** cycle-005 itself (remains open through F4 Wave 2, F5, F6, F7); the DEC-347 interim-shippability-window tradeoff, now OPEN, which Wave 2's BC-X.7.010 preflight will close; the queued `$GITHUB_STEP_SUMMARY` badge-visibility follow-up, not yet actioned.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Minted DEC-352 (Wave 1 MERGED via >120-mutant escape-hatch admin-bypass, human-authorized); flipped STORY-INDEX.md rows to done; updated sprint-state.yaml wave tracking; recorded 2 new Drift/Standing items; updated pipeline position (Wave 2 UNBLOCKED); STATE.md v3.92 full-content Write; archived v3.91 checkpoint to cycles/cycle-006/session-checkpoints.md; commit + push to `factory-artifacts` | `STATE.md` (v3.92), `cycles/cycle-005/burst-log.md` (this file), `cycles/cycle-006/session-checkpoints.md`, `stories/STORY-INDEX.md`, `sprint-state.yaml`, `research/mutation-testing-badge-visibility-2026-09-09.md` |

---

## Burst: Burst 6 — standalone maintenance PR #793 (`ci/mutation-nightly-visibility`) MERGED; closes cycle-006 S-7.02 deferral CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS (2026-09-09)

**Parent-commit:** `d9001a46` (`.factory` factory-artifacts tip immediately before this burst — Burst 5's own commit).

**Trigger:** Human directed the state-manager to record a small, already-merged CI-visibility/docs enhancement (PR #793) in STATE.md, archiving the prior v3.92 Session Resume Checkpoint first, via a single atomic commit to `factory-artifacts`.

**Actions taken:**

1. **Recorded the merge fact (no DEC minted — small merged enhancement, not a phase-gate or story decision):** PR #793 (`ci/mutation-nightly-visibility`) squash-merged to `develop` as `5b00b31e` ("ci: surface nightly mutation kill-rate in job summary + docs (#793)"), 2026-09-09T18:35Z; `develop` advanced `708c8b32`→`5b00b31e`. Normal merge — clean CI, no escalation/admin-bypass needed (~0 in-diff mutants, since no `src/` change). pr-reviewer **APPROVE**. Diff: `.github/workflows/mutants-nightly.yml` (adds pooled kill-rate + caught/missed/timeout/unviable table to `$GITHUB_STEP_SUMMARY` in the `mutants-nightly-report` job, advisory/non-gating, still exit 0), `README.md` (new "Mutation testing" section), `docs/specs/cargo-mutants-policy.md` (nightly-summary pointer), `scripts/check-ci-gate.sh` + `.github/workflows/ci.yml` (comment-only stale "Check kill rate" citation fixes). Local+CI verification green (`ci_gate_completeness` 101/101, `actionlint` clean, `mutants-aggregate` self-test 25/25).
2. **Closed the cycle-006 S-7.02 deferral `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`:** both stale inline comments citing the retired "Check kill rate" step (`scripts/check-ci-gate.sh` ~L43-45, `.github/workflows/ci.yml` ~L100-101) are fixed by PR #793's diff. Moved out of the open S-7.02 deferrals table in Drift/Standing Items into the "RESOLVED/CLOSED" note alongside `F-PE-MED-001`/`R-F2`.
3. **Settled the mutation-testing badge-visibility research outcome:** PR #793 operationalizes `research/mutation-testing-badge-visibility-2026-09-09.md`'s option #1 recommendation (job-summary + docs). The dynamic shields-badge option remains **DEFERRED, not pursued** — recorded as the settled outcome so it is not re-opened. This strengthens the advisory-nightly net that cycle-005 Wave 1's escape-hatch bypass (DEC-352) relies on.
4. **Confirmed pipeline position unchanged in substance:** `current_cycle`/`feature_mode_bundle` remain `cycle-005`/`adf-mentions`; cycle-005 remains the sole OPEN cycle, Phase F4 IN PROGRESS, Wave 2 (`S-cycle5-mention-resolution-wiring`) still READY/next (not yet dispatched). Counts unchanged (754 BCs / 76 VPs / 118 holdouts / 175 stories) — PR #793 authored no BC/VP/holdout/story. `activation_head`/`activation_version` unchanged (`a9168212`/`v0.7.0-dev.5`) — no release cut; `develop`'s real tip is now `5b00b31e`.
5. **Archived the v3.92 Session Resume Checkpoint** to `cycles/cycle-005/session-checkpoints.md` (the cycle-005 burst — Burst 5 — that produced it) with a "Superseded at" note, then wrote a new v3.93 checkpoint in STATE.md reflecting the merge and the unchanged Wave-2-next position.
6. Updated Phase Progress (new `MAINTENANCE-PR-793-MERGED (standalone, Burst 6)` row), Current Phase Steps (fresh Burst-6 table; Burst 5's table folded into the existing pointer note), Decisions Log (cycle-005 note paragraph appended, no new DEC row), Blocking Issues (clarifying note), Convergence Status, Concurrent Cycles (`develop`'s real tip updated to `5b00b31e`), Constraints Carried Forward (new Burst-6 paragraph), Historical Content (cycle-005 rows updated + new PR #793 evidence row), and Drift/Standing Items (S-7.02 deferrals table: removed the now-resolved row; badge-visibility references updated to reflect the settled outcome).
7. Refreshed the STATE.md SIZE BUDGET banner and its `wc -l` claim to the actual post-Write line count.

**Adversary verdict:** N/A this state-manager burst — no `adversary` agent dispatched. PR #793's own review/CI evidence (pr-reviewer APPROVE, local+CI verification green) was produced by the concurrent PR-review workflow prior to this burst, not re-run here.

**Files touched (Dim-1): 3 unique files/paths this burst, all committed in the state-manager's own single atomic commit**

- `STATE.md` (v3.93 — full-content Write)
- `cycles/cycle-005/session-checkpoints.md` (v3.92 checkpoint archived with "Superseded at" note)
- `cycles/cycle-005/burst-log.md` (this entry)

**Dim-2 Attestation:** No count-verification script applies to this burst in the BC/VP/holdout/story sense — counts unchanged (754 BCs / 76 VPs / 118 holdouts / 175 stories, all carried forward verbatim). PR #793 touched no spec/story artifact.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (bookkeeping-only, no build). PR #793's own binary-equivalent artifacts (workflow YAML, docs) were already built/tested by CI as part of its own merge, separate from this commit.

**Dim-6 Attestation:** No `src/`/`tests/` change committed by this state-manager burst — PR #793 touched no `src/` file at all (CI workflow + docs only), landing on `develop` @ `5b00b31e` via its own merge, separate from this `.factory/` commit.

**Dim-7 Attestation:** N/A — no CI-relevant change in this `.factory/` commit (no code, no workflow file touched); PR #793's own CI is tracked on GitHub, not by this commit.

**Codifications:** No DEC minted this burst (small merged enhancement, not a phase-gate or story decision). Recorded (not decided): the merge fact, the S-7.02 deferral closure, and the badge-visibility settled outcome.

**Closes:** the cycle-006 S-7.02 deferral `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS` (RESOLVED by PR #793). **Does NOT close:** cycle-005 itself, any cycle-005 phase or wave, or the `INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1` standing item (unchanged, still OPEN, target Wave 2's BC-X.7.010 preflight).

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Recorded PR #793 (`ci/mutation-nightly-visibility`) squash-merged to `develop` @ `5b00b31e` (standalone maintenance, not a cycle-005 story, no DEC minted); closed cycle-006 S-7.02 deferral `CYCLE6-LOW-STALE-CHECK-KILL-RATE-COMMENTS`; recorded the mutation-testing badge-visibility research settled outcome (option #1 landed, dynamic badge DEFERRED); STATE.md v3.93 full-content Write; archived v3.92 checkpoint to cycles/cycle-005/session-checkpoints.md; commit + push to `factory-artifacts` | `STATE.md` (v3.93), `cycles/cycle-005/burst-log.md` (this file), `cycles/cycle-005/session-checkpoints.md` |

---

## Burst 7 — SESSION-WRAP PAUSE checkpoint (2026-09-09)

**Parent-commit:** `5b00b31e`-era `.factory` factory-artifacts tip immediately before this burst (Burst 6's own commit).

**Trigger:** Human directed the state-manager to execute the wrap skill's Step 4 PAUSE checkpoint on `.factory/STATE.md` — make pipeline state durable so the session can be cleared and resumed safely, without losing progress. No pipeline work (no new story, no new merge) occurred between Burst 6 and this burst.

**Actions taken:**

1. **Frontmatter:** `pipeline:` `ACTIVE` → `PAUSED`. `timestamp:` refreshed to the pause instant (2026-09-09T19:06:33Z). `phase:` rewritten to begin with `PAUSED 2026-09-09.` followed by the unchanged pipeline position (cycle-005 Phase F4 — Wave 1 MERGED via DEC-352, standalone maintenance PR #793 MERGED, Wave 2 READY/next NOT yet dispatched; `develop` @ `5b00b31e`). `current_step:` rewritten as a `SESSION-WRAP-PAUSE-2026-09-09` step description, preserving the `D-chain cite D-053 latest brownfield.` prefix and the `→1→3→0→2` trajectory-tail token, per the verbatim-strict chain convention. `last_amended:` full overwrite (BC-5.45.001 write-path discipline) recording the pause. `version:` `3.93` → `3.94` (exactly one bump).
2. **Archived** the v3.93 Session Resume Checkpoint to `cycles/cycle-005/session-checkpoints.md` with a "Superseded at" note, BEFORE writing the new one — see that file's newest entry.
3. **Wrote exactly one new** `## Session Resume Checkpoint` (v3.94) in `STATE.md` with all six required fields (date + pipeline position, convergence counter = N/A at a clean resting point, in-flight work = NONE, pending human decisions/unresolved incl. the open `mutants-nightly.yml` manual-trigger offer and the `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` advisory, WIP branches = none, resume command).
4. **Appended** a new Phase Progress row `SESSION-WRAP-PAUSE-2026-09-09` (COMPLETE, agent state-manager) recording the pause as a bookkeeping event, not a phase/story gate.
5. **Recomputed** `wc -l .factory/STATE.md` after the Write and refreshed the SIZE BUDGET banner's line-count claim and dual-margin figures to match exactly.
6. **Included** the concurrently-modified `.factory/sidecar-learning.md` in this same atomic commit — verified its diff (two appended `Session ended at … (awaiting /session-review)` marker lines, consistent with the file's existing append-only pattern) is a legitimate factory learning artifact, not stray/unrelated content.
7. Updated Current Phase Steps (fresh Burst-7 table; Burst 6's table folded into the existing pointer note), Convergence Status / Concurrent Cycles (pipeline status reflected as PAUSED), and Constraints Carried Forward (new Burst-7 paragraph) for consistency with the frontmatter change. No DEC minted — a pause is bookkeeping, not a phase-gate or story decision. Counts unchanged (754 BCs / 76 VPs / 118 holdouts / 175 stories); `activation_head`/`activation_version` unchanged (`a9168212`/`v0.7.0-dev.5`).

**Adversary verdict:** N/A this state-manager burst — no `adversary` agent dispatched; this is a pure bookkeeping pause, not a spec/code change.

**Files touched (Dim-1): 4 unique files/paths this burst, all committed in the state-manager's own single atomic commit**

- `STATE.md` (v3.94 — full-content Write)
- `cycles/cycle-005/session-checkpoints.md` (v3.93 checkpoint archived with "Superseded at" note)
- `cycles/cycle-005/burst-log.md` (this entry)
- `sidecar-learning.md` (pre-existing uncommitted append from earlier in the session — two session-end markers — included in this atomic commit per PC-12, working tree must end clean)

**Dim-2 Attestation:** No count-verification script applies — counts unchanged (754 BCs / 76 VPs / 118 holdouts / 175 stories, carried forward verbatim). This burst authored no spec/story artifact.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (bookkeeping-only, no build).

**Dim-6 Attestation:** No `src/`/`tests/` change committed by this state-manager burst.

**Dim-7 Attestation:** N/A — no CI-relevant change in this `.factory/` commit.

**Codifications:** No DEC minted this burst (a pause is bookkeeping, not a phase-gate or story decision). Recorded (not decided): `pipeline: PAUSED`, the archived v3.93 checkpoint, and the new v3.94 checkpoint's resume point.

**Closes:** nothing — this burst closes no phase, wave, or standing item. **Does NOT close:** cycle-005 itself, Phase F4, Wave 2's dispatch, or any Drift/Standing item (`INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1`, `CYCLE5-W1-LOCAL-MUTATION-VERIFY-PARTIAL`, the 5 remaining S-7.02 deferrals) — all unchanged.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Executed the wrap skill's Step 4 SESSION-WRAP PAUSE checkpoint: `pipeline: PAUSED`, refreshed timestamp, verbatim-strict `phase:`/`current_step:`/`last_amended:` chain, `version:` 3.93→3.94; archived v3.93 checkpoint, wrote v3.94 checkpoint (all 6 fields); appended Phase Progress row; recomputed and refreshed the SIZE BUDGET banner; included the pre-existing `sidecar-learning.md` diff in the same atomic commit (verified legitimate); commit + push to `factory-artifacts` | `STATE.md` (v3.94), `cycles/cycle-005/burst-log.md` (this file), `cycles/cycle-005/session-checkpoints.md`, `sidecar-learning.md` |

---

## Burst 8 — F4 WAVE 2 DISPATCH (2026-09-09)

**Parent-commit:** `5b00b31e`-era `.factory` factory-artifacts tip immediately before this burst (Burst 7's own commit).

**Trigger:** Human authorized resuming the SESSION-WRAP pause (Burst 7) and dispatching cycle-005 Phase F4 Wave 2 (`S-cycle5-mention-resolution-wiring`) to per-story delivery. A legitimate resume + status transition, not a phase-gate decision.

**Actions taken:**

1. **Frontmatter:** `pipeline:` `PAUSED` → `ACTIVE`. `timestamp:` refreshed to the dispatch instant. `phase:` rewritten to drop the `PAUSED 2026-09-09.` prefix and record the unchanged Wave-1/PR-793 history plus Wave 2 now `DISPATCHED to per-story delivery`, worktree `feat/cycle5-mention-resolution-wiring` created from `develop` @ `5b00b31e`. `current_step:` rewritten as an `F4-WAVE2-DISPATCH-2026-09-09` step description, preserving the `D-chain cite D-053 latest brownfield.` prefix and the `→1→3→0→2` trajectory-tail token, per the verbatim-strict chain convention. `last_amended:` full overwrite (BC-5.45.001 write-path discipline) recording the dispatch. `version:` `3.94` → `3.95` (exactly one bump).
2. **Verified** the worktree `feat/cycle5-mention-resolution-wiring` exists via `git worktree list` — confirmed created from `develop` @ `5b00b31e` (already present, not created by this burst).
3. **STORY-INDEX.md:** flipped `S-cycle5-mention-resolution-wiring` status `draft` → `in-progress` on both the registry row (~L1235) and the detail row (~L1652), recording the dispatch and confirming `depends_on:[S-cycle5-mention-pure-conversion]` SATISFIED (Wave 1 merged, PR #778 @ `708c8b32`) and F3-approval via DEC-347. No count change (754 BCs / 76 VPs / 118 holdouts / 175 stories) — no new story authored.
4. **sprint-state.yaml:** updated `cycle_005_adf_mentions.wave_2_status` and the `S-cycle5-mention-resolution-wiring` story entry (`status: ready` → `in-progress`, added `worktree`/`dispatched_at`/`dispatched_from` fields) and its `notes` field to reflect the dispatch and existing worktree.
5. **Archived** the v3.94 Session Resume Checkpoint to `cycles/cycle-005/session-checkpoints.md` with a "Superseded at" note, BEFORE writing the new one — see that file's newest entry.
6. **Wrote exactly one new** `## Session Resume Checkpoint` (v3.95) in `STATE.md` reflecting the ACTIVE pipeline, Wave 2 dispatched to per-story delivery (noting observed concurrent test-writer/implementer activity already underway in the worktree), and the resume/next-action detail.
7. **Appended** a new Phase Progress row `F4-WAVE2-DISPATCH-2026-09-09` (DISPATCHED, agent state-manager).
8. **Recomputed** `wc -l .factory/STATE.md` after the Write and refreshed the SIZE BUDGET banner's line-count claim and dual-margin figures to match exactly (391 lines).
9. **Included** the concurrently-modified `.factory/sidecar-learning.md` (further append-only `Session ended at …` markers) and `.factory/regression-state.json` (a test-run scratch record from the concurrent per-story-delivery activity inside the `.worktrees/S-cycle5-mention-resolution-wiring` worktree) in this same atomic commit — both verified as legitimate, in-scope artifacts of this dispatch, not stray/unrelated content.
10. Updated Convergence Status / Concurrent Cycles (pipeline reflected as ACTIVE, Wave 2 DISPATCHED), Constraints Carried Forward (new Burst-8 paragraph; Burst 7's paragraph marked historical/superseded), Blocking Issues (clarifying note), Decisions Log (cycle-005 note paragraph appended, no new DEC row), and Historical Content (new evidence row + burst-history bullet) for consistency with the frontmatter change. No DEC minted — a dispatch/status transition is bookkeeping, not a phase-gate or story decision.

**Adversary verdict:** N/A this state-manager burst — no `adversary` agent dispatched; this burst records a dispatch/status transition, not a spec/code change.

**Files touched (Dim-1): 5 unique files/paths this burst, all committed in the state-manager's own single atomic commit**

- `STATE.md` (v3.95 — full-content Write)
- `stories/STORY-INDEX.md` (2 rows flipped draft→in-progress)
- `sprint-state.yaml` (`cycle_005_adf_mentions` wave_2_status + story entry updated)
- `cycles/cycle-005/session-checkpoints.md` (v3.94 checkpoint archived with "Superseded at" note)
- `cycles/cycle-005/burst-log.md` (this entry)

Additionally swept into the same commit (pre-existing/concurrent, verified legitimate, not authored by this burst's substantive actions): `sidecar-learning.md` (append-only session-end markers) and `regression-state.json` (concurrent per-story-delivery test-run record).

**Dim-2 Attestation:** No count-verification script applies in the BC/VP/holdout/story sense — counts unchanged (754 BCs / 76 VPs / 118 holdouts / 175 stories, carried forward verbatim). This burst authored no new spec/story artifact (only a status-field flip on an existing story).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (bookkeeping-only, no build).

**Dim-6 Attestation:** No `src/`/`tests/` change committed by this state-manager burst. (The concurrently-observed per-story-delivery activity in the Wave 2 worktree is tracked separately, outside this `.factory/` commit.)

**Dim-7 Attestation:** N/A — no CI-relevant change in this `.factory/` commit.

**Codifications:** No DEC minted this burst (a dispatch/status transition is not a phase-gate or story decision). Recorded (not decided): `pipeline: ACTIVE`, the dispatch fact, the STORY-INDEX/sprint-state status flips, and the new v3.95 checkpoint's resume point.

**Closes:** nothing — this burst closes no phase, wave, or standing item. **Does NOT close:** cycle-005 itself, Phase F4, Wave 2 itself (delivery is only just beginning), or any Drift/Standing item (`INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1`, `CYCLE5-W1-LOCAL-MUTATION-VERIFY-PARTIAL`, the 5 remaining S-7.02 deferrals) — all unchanged.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Recorded the human-authorized resume + dispatch of cycle-005 Phase F4 Wave 2 (`S-cycle5-mention-resolution-wiring`) to per-story delivery: `pipeline: PAUSED`→`ACTIVE`, verbatim-strict `phase:`/`current_step:`/`last_amended:` chain, `version:` 3.94→3.95; verified the existing worktree `feat/cycle5-mention-resolution-wiring`; flipped STORY-INDEX.md status draft→in-progress (both rows); updated sprint-state.yaml wave/story tracking; archived v3.94 checkpoint, wrote v3.95 checkpoint; appended Phase Progress row; recomputed and refreshed the SIZE BUDGET banner; included the concurrently-modified `sidecar-learning.md`/`regression-state.json` in the same atomic commit (both verified legitimate); commit + push to `factory-artifacts` | `STATE.md` (v3.95), `stories/STORY-INDEX.md`, `sprint-state.yaml`, `cycles/cycle-005/burst-log.md` (this file), `cycles/cycle-005/session-checkpoints.md` |

---

## Burst 9 — Step-4.5 Per-Story Adversarial Convergence: S-cycle5-mention-resolution-wiring (2026-09-09)

**Parent-commit:** `b4c1fd3e` (`factory(phase-3): record Red Gate for S-cycle5-mention-resolution-wiring`) — the factory-artifacts tip immediately before this burst.

**Trigger:** Orchestrator recorded the completed Step-4.5 (BC-5.39.001) per-story adversarial convergence loop for Wave 2's terminal story, run on branch `feat/cycle5-mention-resolution-wiring` (base `develop` @ `5b00b31e`, final HEAD `9dc0b098`). This is a **sub-phase record within F4 Wave 2 delivery, not a phase transition** — the STATE-worthy event is the eventual PR merge, which has not yet happened. Per this burst's own scoping instruction, **no STATE.md version bump** was made.

**Actions taken:**

1. **Wrote** `cycles/cycle-005/S-cycle5-mention-resolution-wiring/adversary-convergence-state.json` capturing all 4 passes: P1 SUBSTANTIVE (1 MEDIUM F1 — non-ASCII/Unicode case-fold defect in `filter_by_name_match`; 1 LOW F2 — a discarded interactive `dialoguer::Select` answer on an internal-error fallback path; plus two scrutiny items, the test-fixture `jsmith`→`smith` rename and the `disambiguate_name` shared-display-name spec-wording deviation, both reviewed and CLEARED as legitimate); P2 NITPICK_ONLY (F1/F2 CONFIRMED-FIXED via `7c9a52f6`/`12eb5d18`; new LOW-1 spec-prose-precedence and LOW-2 interactive-test-gap, both deferred non-blocking; window 1/3); P3 NITPICK_ONLY (new LOW-3 stale AC-020→AC-017 citation, fixed same-sweep via `9dc0b098`; window 2/3); P4 NITPICK_ONLY (all prior confirmed-fixed, no new substantive findings; window COMPLETE 3/3). Convergence criterion (passes_clean ≥ 3, last_classification NITPICK_ONLY-or-cleaner) MET — non-strict (window passes were NITPICK_ONLY throughout, not CLEAN).
2. **Evaluated the STATE.md write-path decision** (BC-5.45.001 discipline, per this burst's own explicit either/or instruction): found `.factory/STATE.md` already carrying an **unrelated, uncommitted, concurrent modification** (a timestamp-only refresh, consistent with the `stamp-state-timestamp` PostToolUse hook or other in-flight concurrent activity) at the time this burst began — see the "Not swept" note below. Editing STATE.md's Drift/Standing Items section in this burst would have required either (a) committing that concurrent, not-this-burst's-content change alongside the deferral append, or (b) a version bump this burst is explicitly scoped to avoid. **Decision: SKIPPED the STATE.md edit this burst.** The two accepted deferrals (LOW-1, LOW-2) are recorded here and in `adversary-convergence-state.json` only, and will fold into STATE.md's Drift/Standing Items section at the eventual merge bookkeeping burst.
3. **Updated** `sprint-state.yaml`'s `cycle_005_adf_mentions.wave_2_status` line and the `S-cycle5-mention-resolution-wiring` story entry's `notes` field to record: code complete on the feature branch, Step-4.5 adversarial convergence ACHIEVED (3 consecutive clean/nitpick passes — P2/P3/P4, last NITPICK_ONLY), awaiting demos/PR decision. Story-level `status:` field left as `in-progress` (unchanged — no PR exists yet; matches this file's short-token convention, with the descriptive convergence detail carried in `notes` per the same convention `S-cycle4-honest-fail-message` uses).
4. **Not swept into this commit:** `.factory/STATE.md` (pre-existing uncommitted timestamp-only diff, not authored by this burst and not part of its scope), `.factory/regression-state.json`, and `.factory/sidecar-learning.md` — all three showed pre-existing uncommitted modifications from concurrent activity at burst start that are unrelated to this Step-4.5 convergence record. Unlike Burst 8 (where concurrent files were verified as legitimate parts of that dispatch and swept in), this burst's own instructions explicitly direct against sweeping unrelated churn, and none of the three was reviewed as in-scope for a per-story sub-phase record. Staged and committed by explicit path list, not `git add -A`.

**Adversary verdict:** Convergence ACHIEVED per the `adversary` agent's own 4-pass record (see `adversary-convergence-state.json`) — 3 consecutive clean-or-nitpick passes (P2, P3, P4), last classification NITPICK_ONLY, criterion `passes_clean >= 3` met. Two LOW-severity items (LOW-1 spec-prose clarity, LOW-2 untestable-without-TTY-seam interactive path) remain as accepted, non-blocking, story-level deferrals — not defects, not blocking demos or PR.

**Files touched (Dim-1): 2 unique files/paths this burst, all committed in the state-manager's own single atomic commit**

- `cycles/cycle-005/S-cycle5-mention-resolution-wiring/adversary-convergence-state.json` (new)
- `sprint-state.yaml` (`cycle_005_adf_mentions` wave_2_status + story entry `notes` updated)
- `cycles/cycle-005/burst-log.md` (this entry)

**STATE.md was deliberately NOT touched this burst** — see Action 2 above. `regression-state.json` and `sidecar-learning.md`'s pre-existing concurrent diffs were deliberately NOT swept in — see Action 4 above.

**Dim-2 Attestation:** No count-verification script applies — counts unchanged (754 BCs / 76 VPs / 118 holdouts / 175 stories, carried forward verbatim). This burst authored no spec/story artifact.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this `.factory/` commit (bookkeeping-only, no build).

**Dim-6 Attestation:** No `src/`/`tests/` change committed by this state-manager burst. (The adversarial-convergence loop's own fix commits — `7c9a52f6`, `12eb5d18`, `9dc0b098` — already landed on the story branch `feat/cycle5-mention-resolution-wiring` prior to this burst; this burst only records the outcome in `.factory/`.)

**Dim-7 Attestation:** N/A — no CI-relevant change in this `.factory/` commit.

**Codifications:** No DEC minted this burst (a per-story sub-phase convergence record is bookkeeping, not a phase-gate or story decision). Recorded (not decided): the 4-pass convergence trajectory, the two accepted LOW-severity deferrals, and the sprint-state.yaml status-note update.

**Closes:** nothing — this burst closes no phase, wave, or standing item, and does not itself close the story (that is the merge). **Does NOT close:** cycle-005 itself, Phase F4, Wave 2's dispatch, S-cycle5-mention-resolution-wiring itself (code-complete, not yet merged), or any Drift/Standing item (`INTERIM-SHIPPABILITY-WINDOW-CYCLE5-W1`, `CYCLE5-W1-LOCAL-MUTATION-VERIFY-PARTIAL`, the 5 remaining S-7.02 deferrals) — all unchanged. **Adds** two new accepted-deferral candidates (LOW-1, LOW-2) for the eventual STATE.md Drift/Standing Items fold-in at merge.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Recorded the Step-4.5 per-story adversarial convergence (4 passes, 3 consecutive clean/nitpick, CONVERGED) for `S-cycle5-mention-resolution-wiring`: wrote `adversary-convergence-state.json`; evaluated and SKIPPED the STATE.md Drift/Standing Items edit this burst (concurrent uncommitted STATE.md diff present + version-bump scoping conflict — deferred to merge bookkeeping); updated `sprint-state.yaml` wave/story status-note; did NOT sweep the pre-existing concurrent `STATE.md`/`regression-state.json`/`sidecar-learning.md` diffs into this commit; commit (explicit path list) + push to `factory-artifacts` | `cycles/cycle-005/S-cycle5-mention-resolution-wiring/adversary-convergence-state.json` (new), `sprint-state.yaml`, `cycles/cycle-005/burst-log.md` (this file) |

---

<!-- Repeat for each burst. Maintain chronological order. -->
