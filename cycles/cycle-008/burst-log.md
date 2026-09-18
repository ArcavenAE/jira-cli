---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-17T23:40:00Z
cycle: "cycle-008"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Burst Log — cycle-008 (oauth-surface-correctness)

## Burst: F4 Wave 1 DELIVERED & CONVERGED — 4 PRs merge-ready, held at human merge gate (2026-09-17)

**Parent-commit:** `0793b9c5` (`develop` tip; unchanged this burst — all 4 Wave-1 PRs are held
at the human consolidated merge gate, none merged; no `develop`-side commit lands from this
burst).

**Trigger:** cycle-008 (`oauth-surface-correctness`) Phase F4 delta implementation resumed from
the prior session-wrap pause (`SESSION-WRAP-PAUSE-2026-09-17`, STATE.md v4.56) and ran Wave 1
(S1/S2/S3/S4, all four stories in parallel, no `src/` overlap) through the full per-story TDD +
adversarial-convergence pipeline.

**Actions taken:**
1. **S1** `S-cycle8-jsm-servicedeskapi-oauth-routing` → PR #833 (`fix/cycle8-jsm-oauth-routing`),
   `BC-4.2.001`, closes GitHub `#831`. 6 JSM `servicedeskapi` `get_from_instance`/
   `post_to_instance` → `get`/`post` gateway-routing swaps (`src/api/jsm/servicedesks.rs`,
   `request_types.rs`, `queues.rs`, `requests.rs`). 3 clean per-story adversarial passes. Demo at
   `.factory/demos/S-cycle8-jsm-servicedeskapi-oauth-routing/`. CI green; `pr-reviewer` APPROVE
   verdict (posted COMMENTED — see self-approval structural gap below). NOT merged.
2. **S2** `S-cycle8-agile-oauth-scope-gap` → PR #834 (`fix/cycle8-agile-oauth-scopes`),
   `BC-1.3.023`, `ADR-0026` Decision 2/2a, `VP-OAUTH-GW-002`. `DEFAULT_OAUTH_SCOPES`
   (`src/api/auth.rs`) expanded 8 → 16 for full OAuth parity. 3 clean adversarial passes (after
   1 LOW test-hardening fix). Demo committed. CI green; APPROVE (COMMENTED). NOT merged.
3. **S3** `S-cycle8-assets-workspace-oauth-routing` → PR #832 (`fix/cycle8-assets-workspace-routing`),
   `BC-4.2.001`, `ADR-0026` Decision 1, `VP-OAUTH-GW-001`. 1-site workspace-ID routing swap
   (`src/api/assets/workspace.rs`) + AC-002 cache-hit test. 3 clean adversarial passes. Finding-1
   CHANGELOG/spec accuracy fix applied (credited surfaces corrected: `jr assets *`, `issue list
   --asset`/`--assets`, `issue create/edit --field :asset` — NOT `--component`). Demo committed.
   CI green 24/24. APPROVE (COMMENTED). NOT merged.
4. **S4** `S-cycle8-agile-scope-mismatch-error-mapping` → PR #835
   (`fix/cycle8-agile-scope-error-mapping`), `BC-X.15.001`, `ADR-0026` Decision 3,
   `VP-OAUTH-GW-003`. Story v1.2 — HUMAN-APPROVED F1 scope expansion from 4 named handlers to
   ALL 8 Agile call sites within `jr board`/`jr sprint` (added AC-009..012; points 5 → 8).
   `error.rs`'s `BC-1.6.042`-pinned shared template confirmed untouched. OBS-1 spec-prose fix +
   OBS-1 mutation-coverage test. 3 clean adversarial passes on the expanded implementation plus a
   re-run after the OBS-1 spec fix. Demo committed (secret-scanned clean). CI green 23 checks;
   `pr-reviewer` READY. NOT merged.
5. **BC delta:** no new BC this burst — `BC-X.15.001` clause 1 widened (4 → 8 call sites) and
   clause 4 corrected in place (OBS-1). `total_bcs` stays 770; VP 89; holdout 118; `total_stories`
   191 all unchanged.
6. **Input-hash reconcile:** `S-cycle8-assets-workspace-oauth-routing.md` (`a7f6dfc` → `ea19c3e`)
   and `S-cycle8-agile-scope-mismatch-error-mapping.md` (`ef3a57c` → `c333e12`) — both confirmed
   drift-only-from-this-burst's-legitimate-edits (diffed against `git diff` before reconciling),
   updated via `compute-input-hash --update`, re-verified clean via `--check`.
7. **Process-gap findings recorded** to `cycles/OPEN-STANDING-ITEMS.md` (new section "cycle-008
   F4 Wave 1 delivery burst — process-gap findings (2026-09-17)"): (a)
   `CYCLE-008-PR-MANAGER-COMPLETION-GUARD-FALSE-AUTHORIZE` — **[SAFETY]**, recurrence of
   `CYCLE-013-PR-MANAGER-COMPLETION-GUARD-PREMATURE-STOP`, the `pr-manager-completion-guard`
   `SubagentStop` hook repeatedly (5+ times) falsely asserted `AUTHORIZE_MERGE=yes`; only agent
   judgment prevented an unauthorized merge; (b) `CYCLE-008-SELF-APPROVAL-STRUCTURAL-GAP` — one
   GitHub identity authors and reviews every PR, so reviews post COMMENTED-with-verdict rather
   than a native APPROVE, requiring human admin-bypass to merge; (c)
   `CYCLE-008-NESTED-SUBAGENT-STALL-RECURRENCE` — recurrence of
   `CYCLE-013-PR-REVIEWER-SUBAGENT-STALL` under this burst's concurrency load; (d)
   `CYCLE-008-WORKTREE-IDENTITY-PREFLIGHT-GAP` — worktree basename/story-id and
   feature-HEAD-SHA-tuple gaps flagged by the S1/S3/S4 adversaries' Worktree-Identity Preflight.
   Also carried forward non-blocking: S3 OBS-2 (`let _ =` vs `.ok()` convention deviation) and
   the S3/S4 stale historical design-doc.
8. **STATE.md updated** (v4.56 → v4.57, single full-content Write per hook-guard discipline):
   `phase`/`current_step`/`cycle_008_status` updated to record Wave 1 DELIVERED & CONVERGED, held
   at the human merge gate; Phase Progress row `CYCLE-008-F4-WAVE1-DELIVERED-2026-09-17`
   appended. Session Resume Checkpoint replaced; prior (v4.56, pause-state) archived to
   `cycles/cycle-008/session-checkpoints.md`.
9. Committed the pending uncommitted F3-story-file edits (S3 v1.1, S4 v1.2) and
   `specs/prd/cross-cutting.md`'s `BC-X.15.001` widening/correction alongside STATE.md, the new
   `cycles/cycle-008/burst-log.md` (this file), and the already-committed demo commits
   (`49050916`/`fa7fb43c`/`9bf4458a`/`e9bdbbfb`) plus benign `code-delivery/pr-review.md`/
   `regression-state.json`/`sidecar-learning.md` churn.

**Adversary verdict:** CONVERGED per-story — S1/S2/S3/S4 each independently reached 3 consecutive
clean adversarial passes (S2 after 1 LOW test-hardening fix on its first pass). No wave-level
integration-gate adversarial pass has run yet — that is gated on the human consolidated merge and
follows as the next step, per the wave-schedule.

**Codifications:** No new DEC minted this burst — Wave-1 delivery-and-hold is an automated
bookkeeping outcome, not a new human-facing pipeline decision (the human merge-gate decision
itself is still pending). Counts unchanged: 770 BCs / 89 VPs / 118 holdouts / 191 stories.

**Closes:** nothing yet — GitHub `#831` tracks S1 and closes only once PR #833 merges, not at
this burst. **Does NOT close:** cycle-008 itself (F4 Wave 2/F5/F6/F7 remain); the
`CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` release-gate item (still PENDING, human-owned,
pre-release).

**Outcome:** cycle-008 (`oauth-surface-correctness`) F4 Wave 1 DELIVERED & CONVERGED. All 4 PRs
(#832/#833/#834/#835) are CI-green, adversarially converged, and carry a reviewer
APPROVE/READY-verdict review, but are HELD at the human consolidated merge gate (self-approval
blocked → admin-bypass expected) — none merged this burst. `develop` unchanged at `0793b9c5`.
`activation_head`/`activation_version` unchanged (`aa557050`/`v0.7.0-dev.7` — no release cut).
**NEXT:** human consolidated merge gate for #832/#833/#834/#835 → wave integration gate +
wave-level adversarial convergence (3 clean) → Wave 2 = S5 (`S-cycle8-jsm-attachments-oauth-verification`,
`depends_on:[S1]`) → S6 Teams spike (non-gating) → F5/F6/F7.

### Counts reconciled this burst

No BCs/VPs/holdouts/stories added or removed this burst — 770 BCs / 89 VPs / 118 holdouts / 191
stories unchanged (BC-X.15.001 widened/corrected in place, not a new BC).

### Details

| Agent | Task | Output |
|-------|------|--------|
| test-writer / implementer / adversary (×4, S1-S4) | Per-story TDD delivery + 3 clean adversarial passes each | 4 story implementations; convergence-trajectory entries under each story's demo/review evidence |
| story-writer-c8 | S4 v1.2 scope expansion authoring (F1 human-approved widening to 8 call sites) | `S-cycle8-agile-scope-mismatch-error-mapping.md` v1.2 |
| demo-recorder (×4) | Demo evidence capture, secret-scanned | `.factory/demos/S-cycle8-jsm-servicedeskapi-oauth-routing/`, `S-cycle8-agile-oauth-scope-gap/`, `S-cycle8-assets-workspace-oauth-routing/`, `S-cycle8-agile-scope-mismatch-error-mapping/` |
| pr-manager, github-ops, github-ops-push-pr, github-ops-s2-push-pr | PR creation + push for S1-S4 | PR #833 (S1), PR #834 (S2), PR #832 (S3), PR #835 (S4) |
| pr-reviewer-cycle8-s1-r1, pr-reviewer-cycle8-s2-r1, pr-reviewer-cycle8-s4-r1, security-review-cycle8-s1 | Fresh-eyes PR review + security review | APPROVE/READY verdicts (posted COMMENTED per self-approval gap); S1 security review clean |
| ci-watch-cycle8-s1 | CI status monitoring | All 4 PRs confirmed CI-green (S3: 24/24 checks; S4: 23 checks) |
| state-manager (this agent) | Burst-complete STATE.md update, input-hash reconcile, OPEN-STANDING-ITEMS.md append, commit + push factory-artifacts | This entry; `STATE.md` v4.57; `cycles/OPEN-STANDING-ITEMS.md` new section; `cycles/cycle-008/session-checkpoints.md` archive entry |

**Files touched (Dim-1): 8 unique files (factory-artifacts, this burst)**

- `STATE.md`
- `cycles/cycle-008/burst-log.md` (this file, new)
- `cycles/cycle-008/session-checkpoints.md`
- `cycles/OPEN-STANDING-ITEMS.md`
- `cycles/cycle-008/phase-f3-stories/S-cycle8-assets-workspace-oauth-routing.md`
- `cycles/cycle-008/phase-f3-stories/S-cycle8-agile-scope-mismatch-error-mapping.md`
- `specs/prd/cross-cutting.md`
- `code-delivery/pr-review.md`, `regression-state.json`, `sidecar-learning.md` (benign churn,
  folded in)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` —
N/A this burst on the count-check dimension itself (no `total_bcs`/`total_stories` numeric
change — `BC-X.15.001` widened in place, not added); the `cross-cutting.md` clause edits were
reviewed for internal consistency against `BC-INDEX.md` (no entry there needs a count bump).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (source changes are
in the 4 PRs' own branches, not this `factory-artifacts` commit).

**Dim-6 Attestation:** N/A on `factory-artifacts` — this burst's `.factory/` commit is
spec/bookkeeping only; the actual `src/` changes for S1-S4 live on their respective PR branches
(`fix/cycle8-jsm-oauth-routing`, `fix/cycle8-agile-oauth-scopes`,
`fix/cycle8-assets-workspace-routing`, `fix/cycle8-agile-scope-error-mapping`), reviewed and
CI-validated there, not merged to `develop` this burst.

**Dim-7 Attestation:** N/A on `factory-artifacts` directly — each PR's own CI run validated its
full test suite green (S1/S2/S3/S4 all reported CI-green, S3 24/24, S4 23 checks); no regression
suite runs against `develop` from this bookkeeping-only `.factory/` commit itself.

---

## Burst: Wave-1 WAVE-GATE convergence + fix PR #836 merge-ready (2026-09-17)

**Parent-commit:** 97b58dd9429359b88fa472d02b50f0f69a1e9ad9

**Adversary verdict:** CLEAN — CONVERGED. 3/3 clean fix-adversarial passes on PR #836's
standalone diff + 3/3 clean wave-level adversarial passes on the final integrated tree (6
independent passes total, 0 findings remaining). The 4 findings that seeded the loop
(F-WAVE-1..4) were all dispositioned before the clean streak began — see
`convergence-trajectory.md` Pass 1 for the pre-fix findings themselves.

**Preceding this burst (other agents, not directly witnessed by state-manager but reflected in
committed artifacts):** Wave 1 (S1/S2/S3/S4) MERGED to `develop` (tip `a32caef4`) — PR `#833`
(S1, `4afc5aa5`), `#832` (S3, `9caa7bb5`), `#834` (S2, `5f718d13`), `#835` (S4, `a32caef4`), all
squash-merged via human-authorized admin-bypass (self-approval structural gap, see
`cycles/OPEN-STANDING-ITEMS.md`). WAVE INTEGRATION GATE ran: (a) integration-test dimension
(clippy+fmt clean on integrated `develop`; each Wave-1 PR's own full CI green; PR `#836`'s CI
runs the full suite, incl. CI Gate, on the integrated tree; a long local `cargo test` was
Gatekeeper-throttled and stopped as redundant, per `HOST-GATEKEEPER-SYSPOLICYD-FRAGILITY`); (b)
WAVE-LEVEL ADVERSARIAL: 3 clean passes on the final integrated wave (incl. the fix); (c) demos
re-validated + secret-scanned clean. Full pass-by-pass detail: `convergence-trajectory.md` (new
this burst).

**Wave-level adversarial findings (4, all resolved) + 1 human scope ruling (F-WG-1):** see
`convergence-trajectory.md` Pass 1 for full detail. Summary: F-WAVE-1 (double-fault post-refresh
401 misclassified) → **FIX** (human-approved, `classify_401_body` in `src/api/client.rs`);
F-WAVE-2 (unverified Agile 401 wire shape) → **VERIFY LIVE** (human-approved; live read-only
probe confirmed `"Unauthorized; scope does not match"`, assumption HOLDS, no code change);
F-WAVE-3 (CHANGELOG double `### Fixed` heading) → **DEFERRED** to release-notes consolidation;
F-WAVE-4 (`get_board_config` hint omitted `read:project:jira`) → **FIX** (human-approved, hint
widened, propagated to `BC-X.15.001`/`BC-1.3.023`/`ADR-0026`). **F-WG-1** (independent human
ruling, same burst): **EXPAND** `BC-X.15.001` coverage from `jr board`/`jr sprint` to also cover
`jr issue list`'s board-resolution path and `jr init` — widening from 2 to 4 command families
(`VP-OAUTH-GW-003` min-test 8→11).

**Wave-gate fix PR #836** (branch `fix/cycle8-double-fault-scope-rewrite`): bundles F-WAVE-1 +
F-WAVE-4 + F-WG-1 in one PR. CONVERGED at 3 clean fix-adversarial passes (on the standalone diff)
+ 3 clean wave-level adversarial passes (on the final integrated tree) — 6 independent passes
total. CI 24/24 green (incl. CI Gate). `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`
(confirmed via `gh pr view 836`). Review verdict: APPROVE (self-review non-independent per the
repo-wide self-approval structural gap — the 6 independent adversarial passes are the
substantive coverage). `src/error.rs` untouched throughout. **NOT merged this burst** — HELD at
the human consolidated wave-gate merge decision, same as the 4 Wave-1 PRs were held at the prior
burst's merge gate.

| Agent | Task | Output |
|-------|------|--------|
| (adversary passes, pre-fix + fix-adversarial + post-fix wave-level, ×7 total incl. the 4-finding pass) | Wave integration gate + wave-level adversarial convergence | 4 findings (F-WAVE-1..4) + human ruling F-WG-1, all dispositioned; 6 clean convergence passes on the fix |
| pr-manager / github-ops-push-pr836 | Fix PR #836 creation + push (`fix/cycle8-double-fault-scope-rewrite`) | PR `#836` open against `develop` |
| pr-reviewer-cycle8-wavefix-r1, pr-reviewer-cycle8-wg1-r1 | Fresh-eyes review of PR #836 | APPROVE verdict (posted per self-approval-gap convention) |
| ci-watch-cycle8-s1 (continued) | CI status monitoring for PR #836 | 24/24 checks green, confirmed `MERGEABLE`/`CLEAN` |
| product-owner (implied by spec diffs) | Propagated F-WAVE-1/F-WAVE-2/F-WAVE-4/F-WG-1 dispositions into `BC-X.15.001`, `BC-1.3.023`, `ADR-0026` | `specs/prd/cross-cutting.md`, `specs/prd/bc-1-auth-identity.md`, `ADR-0026` amendment notes |
| story-writer-c8 | S4 v1.2→v1.5 further scope-widening authoring for F-WG-1 (AC-013..015) | `S-cycle8-agile-scope-mismatch-error-mapping.md` v1.5 |
| state-manager (this agent) | Wave-gate convergence + fix-merge-ready STATE.md update, input-hash reconcile (3 files), `convergence-trajectory.md` (new), `OPEN-STANDING-ITEMS.md` append, commit + push `factory-artifacts` | This entry; `STATE.md` v4.58; `cycles/cycle-008/convergence-trajectory.md` (new); `cycles/OPEN-STANDING-ITEMS.md` new section; `cycles/cycle-008/session-checkpoints.md` archive entry |

**Files touched (Dim-1): 11 unique files (`factory-artifacts`, this burst)**

- `STATE.md`
- `cycles/cycle-008/burst-log.md` (this entry)
- `cycles/cycle-008/convergence-trajectory.md` (new)
- `cycles/cycle-008/session-checkpoints.md`
- `cycles/OPEN-STANDING-ITEMS.md`
- `cycles/cycle-008/F2-architecture-delta.md`
- `cycles/cycle-008/phase-f3-stories/S-cycle8-agile-scope-mismatch-error-mapping.md` (v1.5)
- `cycles/cycle-008/phase-f3-stories/S-cycle8-assets-workspace-oauth-routing.md`
- `specs/architecture/decisions/ADR-0026-oauth-3lo-gateway-routing-invariant-and-granular-jira-software-scopes.md`
- `specs/prd/BC-INDEX.md`, `specs/prd/bc-1-auth-identity.md`, `specs/prd/cross-cutting.md`
- `code-delivery/pr-review.md`, `regression-state.json`, `sidecar-learning.md` (benign churn,
  folded in)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` —
N/A this burst (no `total_bcs`/`total_stories`/`total_vps` numeric change — `BC-X.15.001`
widened in place a second time via F-WG-1, `VP-OAUTH-GW-003` min-test count raised 8→11 as a
qualitative test-coverage floor, not a new VP id).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A on `factory-artifacts` — the actual `src/` fix for F-WAVE-1/F-WAVE-4/
F-WG-1 lives on PR #836's branch (`fix/cycle8-double-fault-scope-rewrite`), reviewed and
CI-validated there, not merged to `develop` this burst.

**Dim-7 Attestation:** PR `#836`'s own CI run validated the full test suite green against the
Wave-1-integrated `develop` tree (24/24 checks, incl. CI Gate) — this IS a real wave-level
regression-suite validation (unlike the prior burst's Dim-7, which was N/A). No regression suite
runs from this bookkeeping-only `.factory/` commit itself.

**Codifications:** F-WAVE-1's fix codified as `classify_401_body` (`src/api/client.rs`, PR
`#836` branch — not yet merged). F-WAVE-4's fix codified into `BC-X.15.001`
(`specs/prd/cross-cutting.md`), `BC-1.3.023` (`specs/prd/bc-1-auth-identity.md`), and `ADR-0026`
Decision 2's scope-list comment. F-WG-1's human-approved scope expansion codified into
`BC-X.15.001` Behavior clause 1 + Canonical Test Vectors (2→4 command families) and
`S-cycle8-agile-scope-mismatch-error-mapping.md` (v1.2→v1.5, AC-013..015 added). F-WAVE-2's live
verification codified as a no-code-change confirmation note (no spec edit required — the
existing BC assumption already matched observed reality). F-WAVE-3 codified only as an open
standing item (`cycles/OPEN-STANDING-ITEMS.md`), not as a spec/code change — deferred by
disposition.

**Closes:** F-WAVE-1 (fixed, PR `#836`), F-WAVE-4 (fixed, PR `#836`), F-WG-1 (human ruling
applied, spec-only — no separate PR, folded into PR `#836`'s companion spec commits on
`factory-artifacts`). F-WAVE-2 verified, not "closed" via a code change — the underlying
assumption already held. F-WAVE-3 NOT closed — explicitly deferred to release-notes
consolidation (tracked, not resolved). Wave 1's own 4 stories (S1-S4) were already closed at the
prior burst's merge; this burst closes the WAVE INTEGRATION GATE + WAVE-LEVEL ADVERSARIAL
dimension of the F4 Wave-1 exit criteria. The human consolidated merge of PR `#836` itself
remains OPEN (see Blocking Issues / Session Resume Checkpoint) — this burst does not close that.

---

## Burst: F4 Wave 2 (S5) DELIVERED, CONVERGED & MERGED — Wave-1 gate fix PR #836 also merged; Wave 2 CLOSED (2026-09-18)

**Parent-commit:** `578a7848` (`develop` tip entering this burst — wave-gate fix PR `#836`
merged in the interim, `develop`: `a32caef4`→`578a7848`, prior to this burst's own S5 work).

**Trigger:** cycle-008 (`oauth-surface-correctness`) resumed from the
`SESSION-WRAP-PAUSE-2026-09-18` checkpoint (STATE.md v4.59) with Wave-1's gate fully closed and
an S5 worktree already created but no code/tests landed. Ran Wave 2's sole story, S5
(`S-cycle8-jsm-attachments-oauth-verification`), through the per-story TDD + adversarial pipeline.

**Actions taken:**
1. **Human merged wave-gate fix PR `#836`** manually (squash, admin-bypass, `develop`:
   `a32caef4`→`578a7848`) ahead of this burst's own dispatch — recorded here for continuity since
   the prior burst's `convergence-trajectory.md` entry had left it open at the human wave-gate
   merge decision.
2. **S5** `S-cycle8-jsm-attachments-oauth-verification` → dispatched `test-writer` to re-run the
   (inverted) Red Gate: `depends_on:[S1]` was SATISFIED (S1 merged PR `#833` @ `4afc5aa5` in
   Wave 1), so the new end-to-end test
   (`test_bc_4_2_001_jsm_attachment_upload_succeeds_end_to_end_under_oauth`,
   `tests/attachment_jsm.rs`, +209 lines) was written EXPECTING TO PASS against already-merged
   `develop` — AC-003 forbids a pre-fix-style failing test for this facade story. It passed on
   first run. Verification-only: **zero `src/` diff**, 2-file diff total
   (`tests/attachment_jsm.rs` + `CHANGELOG.md`, +7 lines).
3. **Per-story adversarial review** ran 4 passes to convergence: Pass 1 SUBSTANTIVE (1 MEDIUM —
   `CHANGELOG.md` overclaimed download/delete coverage alongside upload; disposition **FIX**,
   narrowed to upload-only with a clarifying platform-endpoint clause, landed at commit
   `da7fc4df`); Passes 2-4 NITPICK_ONLY, novelty decayed to zero — 3 consecutive clean/nitpick
   passes, CONVERGED. Full detail: `cycles/cycle-008/convergence-trajectory.md`'s new "S5 (Wave
   2)" section (added this burst), including the Red-Gate-inversion rationale and the
   negative-control assertion design (`base_url` hit exactly once × 4 endpoints, `instance_url`
   hit exactly zero times, `JR_CACHE_DIR` isolation forcing the real `list_service_desks` call).
4. **Demo evidence** recorded on `factory-artifacts` @ `5cc246c6` per the #708 demo-evidence
   convention (test output transcript demonstrating the passing end-to-end assertions; no visual
   demo needed for a test-only facade story).
5. **PR `#843`** (`fix/cycle8-jsm-attachments-oauth-verification` → `develop`) opened, pushed, and
   driven to CI 24/24 green. Fresh-eyes `pr-reviewer` review performed genuine verification, not
   just diff-reading: ran the new test locally (`ok, 1 passed`); temporarily mutated
   `post_request_attachment` (`src/api/jsm/attachments.rs`) to route via `instance_url()` instead
   of `base_url()` and confirmed the test FAILS as designed, then reverted (worktree confirmed
   clean); verified the 4-endpoint chain against the real `src/api/jsm/servicedesks.rs`/
   `attachments.rs` call graph; confirmed the CHANGELOG fix from Pass 1 is accurate and correctly
   scoped. Verdict: **COMMENTED** (self-approval structural gap — same convention as S1-S4/#836)
   with an explicit non-blocking recommendation, 0 CRITICAL/HIGH/MEDIUM, 1 LOW (env-var restore
   non-RAII, `discussion_r4047408907`), 1 INFO. PR marked **merge-ready** — human merge required
   (self-approval structural gap blocks the dispatch, not just GitHub's approval state; see (7)
   below).
6. **Human merged PR `#843`** manually via admin-bypass (squash, `develop`: `578a7848`→`926fdb96`,
   mergedAt 2026-09-18T14:40:40Z) after the `pr-manager`-dispatch classifier's `[Self-Approval]`
   denial (recurrence of `CYCLE-008-SELF-APPROVAL-STRUCTURAL-GAP`, expected per the Wave-1
   precedent). Worktree (`.worktrees/cycle8-s5-jsm-attachments-oauth-verification`) and branch
   (`fix/cycle8-jsm-attachments-oauth-verification`) cleaned up post-merge.
7. **Process-gap findings recorded** to `cycles/OPEN-STANDING-ITEMS.md`: (a) an UPDATE folded
   into the existing `CYCLE-008-SELF-APPROVAL-STRUCTURAL-GAP` entry — the gap is now confirmed to
   block the orchestrator's `pr-manager` DISPATCH itself (a `[Self-Approval]` classifier denial on
   any dispatch carrying merge authorization), not merely GitHub's `APPROVED` state; (b) new
   section "cycle-008 F4 Wave 2 S5 delivery — justified deferrals" with two LOW items, both
   CLOSED-BY-DEFERRAL per S-7.02: `CYCLE-008-ENV-RESTORE-NON-RAII` (manual `JR_CACHE_DIR`
   set/remove_var in the new test leaks on panic-unwind, matches the pre-existing
   `tests/project_meta.rs` pattern) and `CYCLE-008-WORKTREE-NAME-VS-STORYID` (S5's worktree
   basename didn't anchor-match its story-id — recurrence of
   `CYCLE-008-WORKTREE-IDENTITY-PREFLIGHT-GAP` on Wave 2).
8. **STORY-INDEX.md updated** (v1.6.27 → v1.6.28): S5 status draft→done (PR #843 @ `926fdb96`).
   Also reconciled STALE `draft` labels on the 4 already-merged Wave-1 stories (S1/S2/S3/S4, both
   Story Manifest + Feature Followup rows each) — all four had been on `develop` since
   2026-09-17 but the index was never updated at that merge; drift now closed. S6
   (`S-cycle8-teams-graphql-oauth-replatform-spike`) correctly LEFT AS `draft` (spike, not
   started — not drift).
9. **STATE.md updated** (v4.59 → v4.60, single full-content Write per hook-guard discipline):
   `phase`/`current_step`/`cycle_008_status` updated to record F4 Wave 2 (S5) DELIVERED,
   CONVERGED & MERGED — **cycle-008 F4 (delta implementation) now COMPLETE** (both waves merged);
   Phase Progress row `CYCLE-008-F4-WAVE2-S5-MERGED-2026-09-18` appended. Session Resume
   Checkpoint replaced; prior (v4.59, wave-1-gate-closed/S5-not-started state) archived to
   `cycles/cycle-008/session-checkpoints.md`.
10. Reconciled pre-existing uncommitted `.factory` working-tree drift (`regression-state.json`,
    `sidecar-learning.md` session-end-marker churn, `code-delivery/pr-review.md`'s PR #843 review
    refresh) into this single commit alongside `STATE.md`, `STORY-INDEX.md`,
    `cycles/cycle-008/burst-log.md` (this entry), `cycles/cycle-008/convergence-trajectory.md`,
    `cycles/OPEN-STANDING-ITEMS.md`, and the new
    `code-delivery/S-cycle8-jsm-attachments-oauth-verification/pr-description.md`.

**Adversary verdict:** CONVERGED — 4 passes (1 SUBSTANTIVE fix + 3 clean/nitpick), 0
CRITICAL/HIGH/MEDIUM remaining at merge time.

**Codifications:** No new DEC minted this burst — S5's merge is an automated bookkeeping
outcome (the F1/F2/F3 human gates already scoped and approved this story; no new pipeline
ruling is made by merging it). Counts unchanged: 770 BCs / 89 VPs / 118 holdouts / 191 stories
(`BC-4.2.001` cited transitively, no amendment; no new VP per F2-architecture-delta.md §S5).

**Closes:** GitHub issue `#831` was already closed at S1's merge (Wave 1); this burst closes
nothing new on that front. **Closes cycle-008 Phase F4 (delta implementation) in full** — both
Wave 1 (S1-S4 + wave-gate fix `#836`) and Wave 2 (S5) are now merged to `develop`. **Does NOT
close:** cycle-008 itself (S6 spike, F5/F6/F7 remain); the
`CYCLE-008-CONSOLE-SCOPE-RELEASE-GATE` release-gate item (still PENDING, human-owned,
pre-release).

**Outcome:** cycle-008 (`oauth-surface-correctness`) Phase F4 Wave 2 (S5) DELIVERED, CONVERGED &
MERGED. `develop` advanced `578a7848`→`926fdb96` (main checkout synced; S5 worktree + branch
removed). F4 is now COMPLETE. `activation_head`/`activation_version` unchanged
(`aa557050`/`v0.7.0-dev.7` — no release cut). **NEXT:** S6 (`S-cycle8-teams-graphql-oauth-replatform-spike`,
non-gating parallel track, spike investigation only) → F5 (scoped adversarial) → F6 (targeted
hardening) → F7 (delta convergence, human gate).

### Counts reconciled this burst

No BCs/VPs/holdouts/stories added or removed — 770 BCs / 89 VPs / 118 holdouts / 191 stories
unchanged (S5 cites `BC-4.2.001` transitively; no new BC/VP/story).

### Details

| Agent | Task | Output |
|-------|------|--------|
| test-writer | Re-ran S5's inverted Red Gate: new end-to-end OAuth JSM-attachment test, expected-to-pass | `tests/attachment_jsm.rs` (+209 lines) |
| adversary (×4 passes) | Per-story adversarial convergence | 1 MEDIUM (CHANGELOG overclaim, fixed `da7fc4df`) + 3 clean/nitpick passes |
| demo-recorder | Demo evidence (test-output transcript) | `factory-artifacts` @ `5cc246c6` |
| pr-manager, github-ops-ci-843, github-ops-push-pr | PR creation, CI drive, push | PR `#843` |
| github-ops-pr843-edit1 | CHANGELOG narrowing fix per Pass-1 disposition | commit `da7fc4df` |
| pr-reviewer-cycle8-s1-r1 (continued) | Fresh-eyes review of PR #843, incl. mutation-style verification of the routing assertions | COMMENTED verdict, `code-delivery/pr-review.md` |
| ci-watch-cycle8-s1 (continued) | CI status monitoring for PR #843 | 24/24 checks green |
| github-ops-demo-verify | Demo evidence validation | confirmed clean |
| human | Manual admin-bypass merge of PR #843 (self-approval structural gap) | `develop` @ `926fdb96` |
| story-writer-c8 | (none this burst — S5 spec unchanged from F3 registration) | — |
| state-manager (this agent) | Burst-complete STATE.md update, STORY-INDEX.md drift reconciliation, convergence-trajectory.md S5 section, OPEN-STANDING-ITEMS.md updates, commit + push `factory-artifacts` | This entry; `STATE.md` v4.60; `stories/STORY-INDEX.md` v1.6.28; `cycles/cycle-008/convergence-trajectory.md`; `cycles/OPEN-STANDING-ITEMS.md` |

**Files touched (Dim-1): 8 unique files (`factory-artifacts`, this burst)**

- `STATE.md`
- `stories/STORY-INDEX.md`
- `cycles/cycle-008/burst-log.md` (this entry)
- `cycles/cycle-008/convergence-trajectory.md`
- `cycles/OPEN-STANDING-ITEMS.md`
- `cycles/cycle-008/session-checkpoints.md`
- `code-delivery/S-cycle8-jsm-attachments-oauth-verification/pr-description.md` (new, was
  untracked)
- `code-delivery/pr-review.md`, `regression-state.json`, `sidecar-learning.md` (benign churn,
  folded in)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` —
N/A this burst (no `total_bcs`/`total_vps`/`total_stories` numeric change; `total_stories`
STORY-INDEX.md updates this burst are status-only, not count changes).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (S5's `src/` diff is
zero; the test-only diff lives on PR #843's branch, already merged to `develop`).

**Dim-6 Attestation:** N/A on `factory-artifacts` directly — S5's actual test diff landed via PR
`#843` on `develop` (`926fdb96`), not via a `factory-artifacts` commit; this burst's `.factory/`
commit is spec/bookkeeping only.

**Dim-7 Attestation:** PR `#843`'s own CI run validated the full test suite green on the
integrated tree (24/24 checks). No regression suite runs from this bookkeeping-only `.factory/`
commit itself.
