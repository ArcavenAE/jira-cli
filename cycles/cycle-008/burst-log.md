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
