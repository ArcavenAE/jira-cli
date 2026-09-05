---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-04T20:45:00Z
cycle: "cycle-004"
inputs: [STATE.md]
input-hash: "[live-state]"
traces_to: STATE.md
---

# Burst Log — cycle-004 (windows-correctness)

## Burst: Burst 1 — cycle-004 OPENED (Feature Mode) — windows-correctness bundle confirmed (2026-09-03)

**Parent-commit:** `42e92b46` (`develop` tip; unchanged this burst — no `develop`-side commit; cycle-004 has not started implementation).

**Trigger:** human triaged two Windows GitHub issues (both filed by @aparajit0) against the just-released `v0.7.0-dev.4` and authorized a new Feature-Mode cycle to fix them as one "Windows correctness" bundle:

- **#759** `bug(windows): OAuth login always fails — access token exceeds CredWriteW 2560-byte blob limit`. Windows Credential Manager caps a credential blob at `CRED_MAX_CREDENTIAL_BLOB_SIZE=2560` bytes (UTF-16 → ~1280 char ceiling); `store_oauth_tokens` (`src/api/auth.rs`) has no size handling, so oversized OAuth tokens silently fail to persist. STILL LIVE on `v0.7.0-dev.4`. Elevated impact because cycle-003 (DEC-313) just made OAuth the default at profile creation.
- **#760** `docs(windows): stale install guidance and incorrect config path`. README says no Windows asset ships / use a prerelease (stale — a Windows asset does ship, per ADR-0016); README documents config as `~/.config/jr/config.toml` unqualified, when on Windows it is silently `%APPDATA%\jr\config.toml` instead; plus a `cloud_id`-auto-discovery doc caveat (the API-token flow can leave `cloud_id` unset — overlaps `A-PA-LOW-001`, a cycle-003 carried-forward standing item).

A research pass ahead of this cycle-open validated the `#759` fix strategy (findings at `research/win-oauth-keychain-blob-limit-2026-09-03.md`): the 2560-byte cap is a fixed OS constant; `keyring` 3.6.3 exposes a matchable `keyring::Error::TooLong(String, u32)`; chunking across multiple credential entries has no peer precedent (rejected); scope-trimming is not durable (rejected); a DPAPI-encrypted file (user-scope, `%LOCALAPPDATA%`) is the `git-credential-manager`/`azure-cli` peer-standard; the REFRESH token is the bigger overflow risk (not just access); the current code can partial-write (access OK, refresh fails).

**Actions taken:**
1. STATE.md refreshed via one full-content Write (v3.52 → v3.53): frontmatter `phase` → `F1`, `pipeline` → `ACTIVE`, `current_cycle` → `"cycle-004"`, `feature_mode_bundle` → `windows-correctness`; `current_step` updated to describe cycle-004 OPENED, #759+#760 bundle, F1 delta-analysis dispatched. `cycle_001_status`/`cycle_002_status`/`cycle_003_status` preserved unchanged (all CLOSED, historical); added `cycle_004_status`. `activation_head`/`activation_version` held at `42e92b46`/`v0.7.0-dev.4` (unchanged — no release-side commit this burst).
2. Recorded 1 new Decisions Log entry, **DEC-334** (collision-checked: highest pre-existing ID was DEC-333, confirmed via corpus-wide grep against STATE.md — no collision): human authorized cycle-004 `windows-correctness` bundling #759+#760; #759 fix strategy = keyring-first + user-scope DPAPI-encrypted-file fallback for oversized OAuth access+refresh tokens (atomic) + honest-fail backstop (match `keyring::Error::TooLong`, accurate message, explicit grant-revoke); chunking and scope-trim rejected after research validation; #760 bundled in.
3. Added a new Phase Progress row for cycle-004 (`F1-DELTA-ANALYSIS`, IN PROGRESS); reset Current Phase Steps to a cycle-004 F1 table (prior cycle-003 CLOSED/RELEASED steps table fully superseded — already preserved in `cycles/cycle-003/burst-log.md`).
4. Updated Convergence Status / Concurrent Cycles prose: cycle-004 `windows-correctness` is now the sole OPEN cycle; cycle-001/002/003 remain CLOSED, historical, unaltered.
5. Replaced Session Resume Checkpoint (cycle-004 F1 IN PROGRESS position); the prior CLOSED+RELEASED cycle-003 checkpoint (v3.52) is noted superseded in the Superseded Checkpoints list, queued for archival to `cycles/cycle-003/session-checkpoints.md` in a future burst (consistent with this burst's dispatched scope being cycle-open bookkeeping, not a checkpoint-archival sweep).
6. Carried ALL cycle-001/002/003 Drift/Standing items forward verbatim, including the tracked cycle-003 non-blockers and the `A-PA-LOW-001` cloud_id item — flagged the overlap with #759/#760's docs scope.
7. Created cycle-004 scaffolding: `cycles/cycle-004/burst-log.md` (this file) and `cycles/cycle-004/phase-f1-delta-analysis/` (empty directory, awaiting the F1 delta-analysis report).
8. Did NOT stage the pre-existing unrelated dirty files noted at every burst since before this session (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) or the untracked `research/win-oauth-keychain-blob-limit-2026-09-03.md` / modified `research/RESEARCH-INDEX.md` — left as-is per instruction; only cycle-004-init paths plus STATE.md are staged explicitly for this commit.

**Adversary verdict:** N/A — bookkeeping/cycle-open burst (STATE.md + scaffolding only), no code or spec-body change; no `adversary` agent dispatched. The scope + fix-strategy decisions this burst records were reached via human triage plus a research pass, not an adversarial review pass.

**Outcome:** cycle-004 (`windows-correctness`) is OPEN, phase F1 (delta analysis) dispatched. No BC/VP/holdout counts changed (733/41/106 unchanged) — this burst is scope-recording only; new BCs/VPs for #759/#760 land at F2.

**NEXT:** F1 delta-analysis (architect) completes its impact-boundary report against `#759`+`#760` → human F1 gate → F2 spec evolution.

**Codifications:** none this burst — DEC-334 is recorded in STATE.md's Decisions Log; no spec/BC/VP authored yet (that is F1/F2's work).

**Closes:** nothing. **Does NOT close:** any cycle-001/002/003 standing Drift/Standing Items — all carried forward unchanged in STATE.md.

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed — 733 BCs / 41 VPs / 106 holdouts unchanged. `total_stories` unchanged at 168.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Initialize cycle-004 in STATE.md (frontmatter, 1 Decisions Log entry DEC-334, Phase Progress + Current Phase Steps rows, Session Resume Checkpoint); create cycle-004 scaffolding (`burst-log.md`, `phase-f1-delta-analysis/`); commit + push to factory-artifacts | `STATE.md`; `cycles/cycle-004/burst-log.md` (this file); `cycles/cycle-004/phase-f1-delta-analysis/` |

**Files touched (Dim-1): 2 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` — N/A this burst (no BC/VP/holdout count change; bookkeeping-only cycle-open, no `.factory/specs/prd/` or `BC-INDEX.md` edits).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact bookkeeping only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 2 — F1 human gate APPROVED, DEC-335 recorded, advanced to F2 (2026-09-03)

**Parent-commit:** `42e92b46` (`develop` tip; unchanged this burst — no `develop`-side commit; cycle-004 has not started implementation).

**Trigger:** human reviewed the architect's F1 delta-analysis report (`cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md`, 549 lines, §13 open questions) and **APPROVED** it at the human gate, answering all six open questions:

1. **Scope:** confirmed and EXPANDED — the #759+#760 bundle becomes a 4-story decomposition: `dpapi-storage-fix` (#759 durable fix — keyring-first + user-scope DPAPI-encrypted-file fallback for oversized OAuth access+refresh tokens, atomic), `honest-fail-message` (#759 backstop — accurate `keyring::Error::TooLong` message + explicit dangling-grant revoke), `windows-docs` (#760), and `cloud_id-correctness` (human-added — fetch+persist `cloud_id` via `GET /_edge/tenant_info` on API-token login).
2. **`cloud_id` fix inclusion (§11):** decided YES — folded in as story 4, `cloud_id-correctness`, which also closes the cycle-003-carried-forward `A-PA-LOW-001` standing item directly (not merely documents around it).
3. **Windows-validation plan (§10):** ACCEPTED as proposed — F4 spikes whether `windows-latest` GitHub Actions CI can exercise DPAPI; a manual smoke test on real Windows remains a REQUIRED (not optional) gate before F7 convergence.
4. **`windows` crate vs. raw `windows-sys` (§6):** DEFERRED to a F2 ADR — needs the architect's recommendation against a real `cargo add` dry-run against this repo's actual `deny.toml`/`Cargo.lock`, not decided at this gate.
5. **Module exclusions (§13 Q5):** confirmed — `clear_all_credentials` stays untouched (test-only, no production call sites, pre-existing do-not-reintroduce warning).
6. **Sequencing (§13 Q6):** decided — `honest-fail-message` bundled with `dpapi-storage-fix` into ONE release, not shipped independently as a fast-follow.

**Actions taken:**
1. STATE.md refreshed via one full-content Write (v3.53 → v3.54): frontmatter `phase` F1→F2, `current_step` updated (D-chain cite + trajectory-tail preserved), `cycle_004_status` updated to reflect F1 APPROVED / F2 IN PROGRESS / 4-story scope.
2. Recorded 1 new Decisions Log entry, **DEC-335** (collision-checked: highest pre-existing ID was DEC-334, confirmed via corpus-wide grep against STATE.md — no collision): human APPROVED the F1 delta-analysis at the human gate — standard F1→F7 route, 4-story scope, Windows-validation plan accepted, `windows`-vs-`windows-sys` deferred to F2 ADR, `clear_all_credentials` confirmed untouched.
3. Updated Phase Progress: `F1-DELTA-ANALYSIS` row → APPROVED (2026-09-03); added new `F2-SPEC-EVOLUTION` row, IN PROGRESS.
4. Reset Current Phase Steps to a 4-row F1→F2-transition table; archived the prior Burst-1 steps table to this burst-log (Burst 1, above).
5. Updated Convergence Status / Concurrent Cycles / Constraints Carried Forward / Session Resume Checkpoint prose to record the gate outcome and the F2-in-progress position.
6. Updated Drift/Standing Items: annotated `A-PA-LOW-001` as now IN-SCOPE for cycle-004 story 4 (`cloud_id-correctness`) rather than merely "overlapping" #760's docs scope; marked the Burst-1 research-file hygiene note RESOLVED (see item 7 below).
7. Committed the F1 delta-analysis artifacts (`cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md`, `affected-files.txt`) plus the previously-untracked `research/win-oauth-keychain-blob-limit-2026-09-03.md` and modified `research/RESEARCH-INDEX.md` (left uncommitted at Burst 1) alongside STATE.md and this burst-log entry.
8. Did NOT stage the pre-existing unrelated dirty files noted at every burst since before this session (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left as-is per instruction.

**Adversary verdict:** N/A — human-gate bookkeeping burst (STATE.md + committing already-produced F1 artifacts), no code or spec-body change; no `adversary` agent dispatched. The F1 gate itself was a human decision, not an adversarial review pass.

**Outcome:** cycle-004 (`windows-correctness`) Phase F1 is **APPROVED**; Phase F2 (spec evolution) is now IN PROGRESS (not yet dispatched). No BC/VP/holdout counts changed (733/41/106 unchanged) — F1 does not create/modify specs; new BCs/VPs for the 4-story scope land at F2.

**NEXT:** Dispatch F2 spec evolution (`/vsdd-factory:phase-f2-spec-evolution`) for the 4-story scope — incremental PRD/architecture/VP delta.

**Codifications:** none this burst — DEC-335 is recorded in STATE.md's Decisions Log; no spec/BC/VP authored yet (that is F2's work).

**Closes:** the Burst-1 hygiene note (research files now committed). **Does NOT close:** any cycle-001/002/003 standing Drift/Standing Items — all carried forward unchanged in STATE.md; `A-PA-LOW-001` is reclassified (in-scope, not resolved) not closed — it closes only when story 4 ships.

### Counts reconciled this burst

No BCs/VPs/holdouts added or removed — 733 BCs / 41 VPs / 106 holdouts unchanged. `total_stories` unchanged at 168 (the 4 new cycle-004 stories are not yet authored — that happens at F3).

### Details

| Agent | Task | Output |
|-------|------|--------|
| human | Review F1 delta-analysis report; answer §13 open questions; approve the gate | Gate decision recorded as DEC-335 |
| state-manager | Update STATE.md (frontmatter, DEC-335, Phase Progress + Current Phase Steps rows, Convergence Status/Concurrent Cycles/Constraints/Drift-Standing prose, Session Resume Checkpoint); append this burst-log entry; commit F1 artifacts + research docs + STATE.md + burst-log to factory-artifacts | `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry); F1 artifacts + research docs committed |

**Files touched (Dim-1): 5 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md (newly committed, previously untracked)
- cycles/cycle-004/phase-f1-delta-analysis/affected-files.txt (newly committed, previously untracked)
- research/win-oauth-keychain-blob-limit-2026-09-03.md (newly committed, previously untracked) + research/RESEARCH-INDEX.md (modified)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` / `scripts/check-bc-cumulative-counts.sh` — N/A this burst (no BC/VP/holdout count change; human-gate bookkeeping only, no `.factory/specs/prd/` or `BC-INDEX.md` edits).

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact bookkeeping only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 3 — CRASH RECOVERY — recovered + checkpoint-committed architect+product-owner F2 artifacts left uncommitted by a crashed session (2026-09-03)

**Parent-commit:** `42e92b46` (`develop` tip; unchanged this burst — no `develop`-side commit).

**Trigger:** the prior factory session crashed mid-Phase-F2. Before the crash, the `architect` and `product-owner` agents had both COMPLETED their F2 deliverables and written them to disk inside the `.factory` worktree, but the orchestrator never reached `formal-verifier`, the adversarial loop, or `state-manager` before the crash — so STATE.md (v3.54) was left stale (it still said "F2 spec evolution dispatch NEXT / not yet dispatched"), and the recovered F2 work sat UNCOMMITTED in the worktree. This burst is mechanical crash recovery: make the recovered work durable via one atomic commit, and correct STATE.md to reflect the true F2 position. No new human decision was made — DEC-335 (the F1 human gate) remains the latest decision; no new DEC is recorded this burst.

**Recovery verification performed before this burst (not re-litigated):** confirmed all four recovered NEW files and six recovered MODIFIED files were present and internally consistent in the `.factory` worktree (`git -C .factory status --porcelain`), read their contents against the orchestrator's recovery manifest, and confirmed `scripts/check-spec-counts.sh` (8 bc files, exit 0) and `scripts/check-bc-cumulative-counts.sh` (742 total across 9 files, exit 0) both PASS against the recovered PRD delta.

**Actions taken:**
1. Committed the recovered architect deliverables: `specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md` (Windows OAuth keyring-first + user-scope DPAPI-encrypted-file fallback on `keyring::Error::TooLong`) and `specs/architecture/decisions/ADR-0022-api-token-cloud-id-acquisition-tenant-info.md` (API-token `cloud_id` acquisition via `GET /_edge/tenant_info`, closing A-PA-LOW-001), plus `cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md` and `architecture/adr-index.md` (updated to list both new ADRs) and `specs/architecture/ARCH-INDEX.md` (updated for the architecture delta).
2. Committed the recovered product-owner deliverables: `specs/prd/bc-1-auth-identity.md` (9 NEW BCs + 1 AMENDED — BC-1.4.035..040 for ADR-0021's Windows secret-storage design; BC-1.2.052..054 for ADR-0022's `cloud_id` acquisition; BC-1.4.028 amended so its partial-state read path checks the DPAPI file before erroring), `specs/prd/BC-INDEX.md`, and `specs/prd/CANONICAL-COUNTS.md` (both updated for the 733→742 total_bcs count change).
3. Committed the recovered research artifact: `research/edge-tenant-info-cloudid-2026-09-03.md` (validates `/_edge/tenant_info` as the `cloud_id` source underlying ADR-0022) and `research/RESEARCH-INDEX.md` (updated to list it).
4. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, per standing instruction carried across every prior burst.
5. Corrected STATE.md via one full-content Write (v3.54 → v3.55): frontmatter `current_step` and `cycle_004_status` updated to describe crash recovery and the true F2 position; Phase Progress F2-SPEC-EVOLUTION row updated from "not yet dispatched" to "architect + product-owner steps DONE (recovered), formal-verifier NEXT"; Current Phase Steps table's architect and product-owner rows marked DONE with a "(recovered post-crash, checkpoint-committed this burst)" flag; Convergence Status / Concurrent Cycles / Drift-Standing prose updated to record the crash-recovery event and the corrected BC count (733→742); Session Resume Checkpoint replaced, recording the crash and the exact next-on-resume action (dispatch `formal-verifier` for the F2 VP delta over the 9 new BCs, then scoped adversarial convergence [min 3 clean passes], then `consistency-validator` fresh-context audit, then the F2 human gate). No new DEC recorded — DEC-335 remains the latest F1-gate decision.
6. Appended this burst-log entry (Burst 3).

**Adversary verdict:** N/A — crash-recovery bookkeeping burst (committing already-produced F2 artifacts + correcting STATE.md), no code or spec-body authored this burst; no `adversary` agent dispatched. The architect/product-owner F2 work itself was produced and internally verified (count-scripts PASS) by the crashed session before it crashed — this burst only makes that work durable.

**Outcome:** cycle-004 (`windows-correctness`) Phase F2 (spec evolution) is IN PROGRESS: architect step (ADR-0021, ADR-0022, architecture-delta.md) DONE-recovered; product-owner step (PRD delta, 9 new BCs + 1 amended) DONE-recovered. total_bcs advances 733→742 this burst (VPs unchanged 41; holdout scenarios unchanged 106; stories unchanged 168 — F2's story impact lands at F3). Next step: dispatch `formal-verifier` for the F2 VP delta.

**NEXT:** Dispatch `formal-verifier` for the F2 VP delta over the 9 new BCs (BC-1.4.035..040, BC-1.2.052..054), then scoped adversarial convergence (minimum 3 clean passes), then `consistency-validator` fresh-context audit, then the F2 human gate.

**Codifications:** none this burst — no new DEC; DEC-335 (F1 human gate) remains the latest decision. The architect's ADR-0021/ADR-0022 and the product-owner's 9 new BCs are the codified F2 spec-evolution output, produced by the crashed session and made durable by this burst.

**Closes:** the STATE.md staleness introduced by the crash (v3.54 incorrectly said F2 not yet dispatched). **Does NOT close:** any cycle-001/002/003 standing Drift/Standing Items — all carried forward unchanged; F2 itself remains IN PROGRESS (formal-verifier + adversarial loop + consistency-validator + human gate all still ahead).

### Counts reconciled this burst

BCs: 733 → **742** (+9: BC-1.4.035..040, BC-1.2.052..054; BC-1.4.028 amended in place, no separate count). VPs unchanged at 41 (formal-verifier adds the VP delta next). Holdout scenarios unchanged at 106. `total_stories` unchanged at 168 (F2 does not create stories — that happens at F3).

### Details

| Agent | Task | Output |
|-------|------|--------|
| architect (crashed session, recovered) | F2 architecture delta for the 4-story scope | ADR-0021, ADR-0022, `cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md`, ARCH-INDEX.md + adr-index.md updates (all recovered + committed this burst) |
| product-owner (crashed session, recovered) | F2 PRD delta — 9 new BCs + 1 amended | `specs/prd/bc-1-auth-identity.md`, `BC-INDEX.md`, `CANONICAL-COUNTS.md` updates (all recovered + committed this burst) |
| state-manager | Verify recovered work is internally consistent; commit it in one atomic commit; correct STATE.md (frontmatter, Phase Progress, Current Phase Steps, Convergence Status/Concurrent Cycles/Drift-Standing prose, Session Resume Checkpoint); append this burst-log entry | This commit; `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry) |

**Files touched (Dim-1): 12 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md (newly committed, previously untracked)
- research/edge-tenant-info-cloudid-2026-09-03.md (newly committed, previously untracked)
- specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md (newly committed, previously untracked)
- specs/architecture/decisions/ADR-0022-api-token-cloud-id-acquisition-tenant-info.md (newly committed, previously untracked)
- specs/prd/bc-1-auth-identity.md (modified — +9 BCs, 1 amended)
- specs/prd/BC-INDEX.md (modified)
- specs/prd/CANONICAL-COUNTS.md (modified)
- specs/architecture/ARCH-INDEX.md (modified)
- architecture/adr-index.md (modified)
- research/RESEARCH-INDEX.md (modified)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` (8 bc files, exit 0) and `scripts/check-bc-cumulative-counts.sh` (742 total across 9 files, exit 0) both PASS against the recovered PRD delta — verified before this burst, recorded here per Defensive Sweep Discipline (S-7.02); no further count-drift found across STATE.md/ARCH-INDEX.md/BC-INDEX.md/prd body prose for the 733→742 transition.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` artifact recovery + bookkeeping only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 4 — F2 scoped adversarial convergence, Passes 1-4 + fix rounds — INTERMEDIATE CHECKPOINT (2026-09-03)

**Parent-commit:** `42e92b46` (`develop` tip; unchanged this burst — no `develop`-side commit).

**Trigger:** four rounds of orchestrator-driven F2 scoped adversarial review + architect/product-owner/formal-verifier fix chains had accumulated uncommitted on top of the Burst 3 crash-recovery checkpoint (`6cf5778a`), leaving STATE.md ~4 passes behind reality (it still read "F2 formal-verifier VP delta NEXT"). This burst makes that work durable via one atomic commit and brings STATE.md current. No new human decision was made — DEC-335 (the F1 human gate) remains the latest decision; no new DEC is recorded this burst.

**Recovery/session-continuity notes (for audit).** This session resumed after the Burst 3 crash-recovery. Two further transient agent failures occurred mid-burst and were recovered without process changes to the pipeline itself: (a) after the `adversarial-review` skill's background-fork dispatch of Pass 1, the fork orphaned (no result surfaced) — the orchestrator switched to direct orchestrator-driven adversarial passes for Passes 2-4 rather than re-attempting the background-fork mechanism; (b) the Pass-4 `architect` fix-round agent stalled past its 600s watchdog having written nothing to disk — it was re-dispatched fresh and the retry succeeded, producing the Pass-4 fix content now in this commit.

**Work performed this burst, in order:**

1. **Formal-verifier: F2 VP delta.** Authored `cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md` — 13 new VPs (`VP-AUTHDX-010`..`022`, continuing the cycle-003 `VP-AUTHDX` scheme) covering all 9 new BCs + the 1 amended BC, inline-placed under each home BC's `**Verification Properties**:` field in `bc-1-auth-identity.md`. `vp_count` 41 → 54.
2. **Adversarial Pass 1** (fresh context, scoped to the F2 spec delta): 17 findings (2 HIGH / 7 MED / 8 LOW). Architect + product-owner fix round applied 9 BC-level fixes (`bc-1-auth-identity.md` changelog, Pass-1 entry): Finding #1 (HIGH) rescoped BC-1.2.054's unconditional Assets claim to a conditional classic-vs-scoped-token statement; Finding #2 (HIGH) extended BC-1.4.040's path-traversal guard enumeration with Windows-specific escape vectors (drive/ADS colon, UNC prefix, reserved device names) plus 6 further MED/LOW fixes (attempt-all/first-error-propagated delete ordering, typed backend/IO-vs-corrupt-envelope distinction, structural `#[cfg(windows)]`-gated DPAPI-unreachable-on-non-Windows guarantee, citation/trace-field cleanups, redirect-policy/precedence-ordering/atomicity-scoping wording fixes).
3. **Adversarial Pass 2**: 9 findings (1 HIGH / 4 MED / 4 LOW), novelty MED. Fix round: Finding #2 added the `CorruptSecretFile(String)` typed marker error (mirrors `DpapiFallbackFailed`'s downcast-based discrimination) so the read path can distinguish a corrupt/undecryptable DPAPI file from a genuine backend/IO error without ad-hoc string-matching; Finding #7 added the Site-3-only proactive stale-pair clear (`refresh_oauth_token_with_url`'s `DpapiFallbackFailed` branch additionally clears the profile's now-stale OAuth pair before returning, since the consumed single-use refresh token is already server-side-dead by that point — confirmed non-conflicting with cycle-003's DEC-321 relogin-then-replace invariant, which governs a different moment in the sequence); Finding #6 corrected the temp-file cleanup clause to the AGE-GATED behavior (only `*.tmp-*` siblings older than `STALE_TMP_THRESHOLD` = 30s are removed, protecting a concurrent process's own in-flight write).
4. **Adversarial Pass 3**: 5 findings (1 HIGH / 4 MED), novelty MOD-HIGH. Fix round: Finding #1 (HIGH, `STALE-KEYRING-SHADOWS-DPAPI`) — the most substantive fix this burst — reworked BC-1.4.035 Postconditions 2/3 so both `TooLong` arms delete the profile's ENTIRE existing keyring pair BEFORE calling `auth_windows_store::store_pair` (delete-keyring-first, never the reverse), closing a real defect where a pre-existing fitting keyring pair could permanently shadow a fresh DPAPI pair via `load_oauth_tokens`'s both-keys-present fast path; new VP-AUTHDX-022 pins the closure (delete-first ordering, crash-safety: a mid-window crash leaves NEITHER backend populated, never a stale shadow). Finding #2 (MED) named `jr auth refresh` as a third explicit `/_edge/tenant_info` fetch-trigger site (alongside `auth login`/`jr init`), confirmed intentional by the architect. Finding #3 (MED) fixed a Pass-2 propagation gap where the age-gated cleanup fix hadn't been carried into BC-1.4.037's own postcondition text.
5. **Adversarial Pass 4**: 4 findings (0 HIGH / 2 MED / 2 LOW), novelty MOD-LOW. Fix round: Finding #1 harmonized the amended BC-1.4.028 partial-state read-path branch to apply the SAME typed 4-outcome distinction (prefer `Ok(Some)` / corrupt→force-re-login / backend-IO→distinct error / `Ok(None)`→partial) as the both-absent branch, asserted under both keyring pre-states; Finding #2 added a guard-WIRING oracle (VP-AUTHDX-016) calling `store_pair`/`load_pair`/`remove_if_present` directly with a guard-failing profile name and asserting each returns `Err`→`ProfilePathEscape` before any FS op — closing the gap where only the recognizer function itself, not its entry-point wiring, was covered by a default-CI-runnable test; Finding #4 required a non-`https://` `site_url` to skip the `/_edge/tenant_info` fetch entirely (zero network requests), not merely soft-fail after attempting it; Finding #8 confirmed `--cloud-id` override both suppresses the fetch AND is itself persisted via `Config::save_global()`.
6. **Reserved Windows device-name set finalized** at 30 names (ADR-0021 §9: 6 classic + 9 `COM1-9` + 9 `LPT1-9` + 6 Unicode superscript variants `COM¹/²/³`/`LPT¹/²/³`), consumed by BC-1.4.040 / VP-AUTHDX-016's `reject_unsafe_profile_component` guard.
7. **Verification re-run:** `scripts/check-spec-counts.sh` exit 0; `scripts/check-bc-cumulative-counts.sh` exit 0 (742 BCs across 9 files, unchanged since Burst 3 — this burst's fixes were all BC-body edits, no BC added/removed); `vp-delta.md`'s recorded `input-hash` current against its listed inputs.
8. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, per standing instruction carried across every prior burst.
9. Updated STATE.md via one full-content Write (v3.55 → v3.56): frontmatter, Phase Progress F2-SPEC-EVOLUTION row, Current Phase Steps table, Convergence Status / Concurrent Cycles / Constraints Carried Forward / Drift-Standing prose, and Session Resume Checkpoint all brought current to reflect Passes 1-4 complete+fixed, clean-streak 0/3, Pass 5 NEXT.
10. Appended this burst-log entry (Burst 4).

**Adversary verdict:** Not a single aggregate verdict — this burst's substance IS four scoped adversarial passes (Pass 1 through Pass 4), each already narrated inline above with its own finding count and fix-round outcome (17 → 9 → 5 → 4, all findings fully resolved via architect→product-owner→formal-verifier fix chains). No standalone top-level `adversary`-agent verdict beyond what the per-pass descriptions in "Work performed this burst" already capture. No CLEAN/BLOCKED convergence verdict applies yet — clean-streak remains 0/3, convergence still in progress.

**Outcome:** cycle-004 (`windows-correctness`) Phase F2 (spec evolution) remains IN PROGRESS. `total_bcs` unchanged at 742 this burst (Passes 1-4 were BC-body refinements, not new BCs); `vp_count` advances 41 → 54 (+13, formal-verifier's delta). Adversarial finding trajectory: 17 → 9 → 5 → 4 (all findings from all 4 passes resolved via architect→product-owner→formal-verifier fix chains). Clean-streak 0/3 — three CONSECUTIVE clean passes are required to converge; none has yet been clean. **NEXT:** dispatch adversarial Pass 5 (fresh context), continuing toward 3 consecutive clean passes, then `consistency-validator` fresh-context audit, then the F2 human gate.

**Codifications:** none this burst — no new DEC; DEC-335 (F1 human gate) remains the latest decision. The Pass 1-4 fix-chain outputs (VP delta + BC-body amendments + ADR-0021/ADR-0022 refinements) are the codified F2 spec-evolution convergence output.

**Closes:** the STATE.md staleness that had accumulated across 4 uncommitted adversarial passes (STATE.md previously still read "formal-verifier VP delta NEXT," now ~4 passes behind reality). **Does NOT close:** F2 itself, which remains IN PROGRESS pending Pass 5+ (to reach 3 consecutive clean passes), the consistency-validator audit, and the F2 human gate; no cycle-001/002/003 standing Drift/Standing Items are touched.

### Counts reconciled this burst

BCs: unchanged at **742** (Passes 1-4 amended existing BC bodies; no BC added or removed). VPs: 41 → **54** (+13: VP-AUTHDX-010..022). Holdout scenarios unchanged at 106. `total_stories` unchanged at 168 (F2 does not create stories). Reserved Windows device-name set finalized at 30 (ADR-0021 §9).

### Details

| Agent | Task | Output |
|-------|------|--------|
| formal-verifier | F2 VP delta over the 9 new BCs + 1 amended BC | `cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md` (13 new VPs, VP-AUTHDX-010..022); inline VP placement in `bc-1-auth-identity.md` |
| adversary (Pass 1, fresh context) | Scoped adversarial review of the F2 spec delta | 17 findings (2 HIGH/7 MED/8 LOW) |
| architect + product-owner (Pass 1 fix round) | Resolve Pass 1 findings | `bc-1-auth-identity.md`, `ADR-0022` (classic-vs-scoped-token rescope), `ADR-0021`/`architecture-delta.md` updates |
| adversary (Pass 2, fresh context) | Scoped adversarial review, round 2 | 9 findings (1 HIGH/4 MED/4 LOW), novelty MED |
| architect + product-owner (Pass 2 fix round) | Resolve Pass 2 findings | `CorruptSecretFile` typed error, Site-3 stale-pair clear, age-gated temp-cleanup fix |
| adversary (Pass 3, fresh context) | Scoped adversarial review, round 3 | 5 findings (1 HIGH/4 MED), novelty MOD-HIGH |
| architect + product-owner (Pass 3 fix round) | Resolve Pass 3 findings | Delete-keyring-first stale-shadow closure (VP-AUTHDX-022), `auth refresh` third-fetch-trigger-site BC update |
| architect (Pass 4 fix round; stalled once, re-dispatched) | Resolve Pass 4 findings | Amended-BC 4-outcome harmonization, guard-wiring oracle, https pre-check, `--cloud-id` persistence confirmation |
| adversary (Pass 4, fresh context) | Scoped adversarial review, round 4 | 4 findings (0 HIGH/2 MED/2 LOW), novelty MOD-LOW |
| state-manager | Verify recovered work is internally consistent; commit it in one atomic commit; correct STATE.md; append this burst-log entry | This commit; `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry) |

**Files touched (Dim-1): 8 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md (modified)
- cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md (newly committed, previously untracked)
- specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md (modified)
- specs/architecture/decisions/ADR-0022-api-token-cloud-id-acquisition-tenant-info.md (modified)
- specs/prd/bc-1-auth-identity.md (modified)
- specs/prd/BC-INDEX.md (modified)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` (8 bc files, exit 0) and `scripts/check-bc-cumulative-counts.sh` (742 total across 9 files, exit 0) both PASS — re-verified before this burst, recorded here per Defensive Sweep Discipline (S-7.02); `vp-delta.md`'s `input-hash` confirmed current against its listed inputs; a corpus grep for the stale "41 VP" count found it only in genuinely-historical surfaces (cycle-003 files, prior cycle-004 burst-log Burst 3 entry, session-reviews) which correctly describe a past point in time and are left unchanged — no live-truth surface other than STATE.md carried the stale count.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` spec-delta convergence only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 6 — F2 scoped adversarial convergence, Passes 7-8 — INTERMEDIATE CHECKPOINT #3 (2026-09-03/04)

**Parent-commit:** `f59f29e2` (`develop` tip `42e92b46`, unchanged this burst — no `develop`-side commit).

**Trigger:** two further rounds of orchestrator-driven F2 scoped adversarial review (Pass 7, Pass 8) had accumulated uncommitted on top of the Burst 5 checkpoint (`f59f29e2`), leaving STATE.md 2 passes behind reality (it still read "Pass 7 NEXT"). This session resumed cleanly — no crash or agent-stall this burst. This burst makes that work durable via one atomic commit and brings STATE.md current. No new human decision was made — DEC-335 (the F1 human gate) remains the latest decision; no new DEC is recorded this burst. The convergence-strategy choice itself (continue toward 3-consecutive-clean vs. gate now) is explicitly being routed to the human at this checkpoint rather than decided by the state-manager.

**Work performed this burst, in order:**

1. **Adversarial Pass 7** (fresh context, scoped to the F2 spec delta as refined through Pass 6): 3 findings (0 CRIT / 0 HIGH / 1 MED / 2 LOW), novelty MED-LOW — assessed as close to converged. Fix round: tightened the `should_fallback_to_dpapi(err)` seam-wording contract to state explicitly that it returns `true` **iff** `err` is `keyring::Error::TooLong` (a wording-precision fix — the implementation already matched only `TooLong`; only the spec prose was previously loose enough to read as unconditional). Also surfaced and documented a non-blocking residual: `--cloud-id` is not durable across `auth refresh` (EC-1.2.052-5) — the refresh path never re-derives or re-persists `cloud_id`, so a manually-overridden value survives only because refresh doesn't touch that field at all; flagged for the F2 human gate's attention rather than fixed this burst. Resolved via a full architect→product-owner→formal-verifier fix chain.
2. **Adversarial Pass 8** (fresh context): 3 findings (0 CRIT / 1 HIGH / 2 MED / 0 LOW), novelty MED. All three findings landed on the CLEAR path (`auth logout` / `auth remove`) — a surface Passes 1-7 had never touched, confirming the value of continuing fresh-context passes past the point where findings looked like they were tapering off. The HIGH (a real backward-compatibility defect): `clear_profile_oauth_pair`/`clear_profile_creds` called the DPAPI-file removal helper directly, which could return `ProfilePathEscape` for a pre-existing profile name that predates BC-1.4.040's path-traversal guard (e.g. a legacy Unix profile literally named `con`) — causing the clear operation to fail where every other backend clears successfully. Fixed via a new `clear_dpapi_file_tolerating_path_escape` adapter (BC-1.4.038 new Invariant 3 + EC-1.4.038-5/6, ADR-0021 §7) that maps `ProfilePathEscape` → `Ok(())` at this ONE call site only (never at the store/read sites, where the guard must remain strict) — clearing must be permissive even where storing/reading is deliberately strict. A new VP-018 pins this clear-path swallow behavior. Finding #1 (a MED, honesty-correction, no design change): the VP CI-classification tally cited in earlier convergence bookkeeping was overstated ("13 of 14 default CI"); corrected to: 10 fully default-CI (VP-AUTHDX-013/014/015/016/017/018/019/020/021/023), 2 default-CI-portion + keyring-gated state core (VP-AUTHDX-011/012), 1 keyring-gated core + Windows-only real-DPAPI tail (VP-AUTHDX-022), 1 Windows-only (VP-AUTHDX-010). Resolved via the same architect→product-owner→formal-verifier fix-chain pattern.
3. **Verification re-run:** `scripts/check-spec-counts.sh` exit 0; `scripts/check-bc-cumulative-counts.sh` exit 0 (742 BCs across 9 files, unchanged — Passes 7-8 were BC-body/VP-body edits, no BC added/removed); `vp-delta.md`'s recorded `input-hash` (`95218fd`) confirmed current against its listed inputs.
4. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, per standing instruction carried across every prior burst. BC-INDEX.md and ADR-0022 were confirmed NOT modified since the Burst 5 checkpoint (`git status` showed no changes to either) and were correctly excluded from this burst's commit.
5. Updated STATE.md via one full-content Write, then two small corrective Edits required by the STATE.md structural/trajectory-tail validators (v3.57 → v3.58): frontmatter, Phase Progress F2-SPEC-EVOLUTION row, Current Phase Steps table (Passes 7-8 marked DONE, plus a new pending "F2 human convergence decision" row and a conditional Pass 9 row), Convergence Status / Concurrent Cycles / Constraints Carried Forward / Drift-Standing prose (trajectory extended to 17→9→5→4→4→4→[sweep 3]→3→3, clean-streak 0/3, corrected VP CI-classification tally), and Session Resume Checkpoint all brought current, recording NEXT-on-resume as **AWAITING HUMAN CONVERGENCE DECISION** rather than an automatic "dispatch Pass 9."
6. Appended this burst-log entry (Burst 6).

**Adversary verdict:** Not a single aggregate verdict — this burst's substance is two scoped adversarial passes (Pass 7, Pass 8), each already narrated inline above with its own finding count and fix-round outcome (3 → 3 findings, both fully resolved). No standalone top-level `adversary`-agent verdict beyond what the per-pass descriptions in "Work performed this burst" already capture. No CLEAN/BLOCKED convergence verdict applies yet — clean-streak remains 0/3 (no pass has yet been clean), convergence still in progress. Given the finding trend (severity declining through Pass 7, then one genuinely new but now-closed surface at Pass 8, zero CRIT across all 8 passes), the orchestrator is deferring the continue-vs-gate-now decision to the human rather than mechanically dispatching Pass 9.

**Outcome:** cycle-004 (`windows-correctness`) Phase F2 (spec evolution) remains IN PROGRESS. `total_bcs` unchanged at 742 this burst (Passes 7-8 were BC-body refinements — BC-1.4.038 gained an Invariant, not a new BC number); `vp_count` unchanged at 55 since Pass 6 (VP-018 is a pre-existing VP number reused for the clear-path oracle, not a new count). Adversarial finding trajectory: 17 → 9 → 5 → 4 → 4 → 4 → [post-Pass-6 sweep: 3] → 3 → 3 (all findings from all 8 passes resolved via architect→product-owner→formal-verifier fix chains). Clean-streak 0/3 — three CONSECUTIVE clean passes are required to converge under the standard rule; none has yet been clean. **NEXT:** present the pending human convergence decision — continue toward 3 consecutive clean (dispatch Pass 9) OR proceed to the F2 human gate now with the 8-pass convergence history and the `--cloud-id` residual (EC-1.2.052-5) documented as rationale (re-running the consistency-validator first only if further fixes land after Pass 7-8).

**Codifications:** none this burst — no new DEC; DEC-335 (F1 human gate) remains the latest decision. The Pass 7-8 fix-chain outputs (the seam-wording precision fix, the `clear_dpapi_file_tolerating_path_escape` adapter + BC-1.4.038 Invariant 3 + VP-018, and the corrected VP CI-classification tally) are the codified F2 spec-evolution convergence output. The continue-vs-gate-now convergence-strategy choice is a PENDING human decision, not yet recorded — it will receive its own DEC once made.

**Closes:** the STATE.md staleness that had accumulated across Passes 7-8 (STATE.md previously still read "Pass 7 NEXT," now current). Also closes a self-inflicted STATE.md authoring defect from this burst's own first Write attempt (a stray trailing `</content>` artifact and a `wc -l`/banner mismatch), both caught and fixed by the file's own structural validators before commit — recorded here for the audit trail, not as a finding against the spec content itself. **Does NOT close:** F2 itself, which remains IN PROGRESS pending the human convergence decision and, downstream of it, either Pass 9+ or the F2 human gate; no cycle-001/002/003 standing Drift/Standing Items are touched.

### Counts reconciled this burst

BCs: unchanged at **742** (Passes 7-8 amended an existing BC — BC-1.4.038 gained Invariant 3 — no BC added or removed). VPs: unchanged at **55** (VP-018 reused an existing VP slot for the clear-path oracle; no new VP number allocated). Holdout scenarios unchanged at 106. `total_stories` unchanged at 168 (F2 does not create stories). Reserved Windows device-name set unchanged at 30 (ADR-0021 §9).

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary (Pass 7, fresh context) | Scoped adversarial review, round 7 | 3 findings (0 CRIT/0 HIGH/1 MED/2 LOW), novelty MED-LOW — close to converged |
| architect + product-owner + formal-verifier (Pass 7 fix round) | Resolve Pass 7 findings | `should_fallback_to_dpapi` seam-wording precision fix; `--cloud-id`/`auth refresh` non-durability documented (EC-1.2.052-5) |
| adversary (Pass 8, fresh context) | Scoped adversarial review, round 8 | 3 findings (0 CRIT/1 HIGH/2 MED/0 LOW), novelty MED — all on the CLEAR path (`auth logout`/`auth remove`) |
| architect + product-owner + formal-verifier (Pass 8 fix round) | Resolve Pass 8 findings | `clear_dpapi_file_tolerating_path_escape` adapter + BC-1.4.038 Invariant 3 + EC-1.4.038-5/6 + VP-018; corrected VP CI-classification tally (Finding #1 honesty fix) |
| state-manager | Verify accumulated work is internally consistent; commit it in one atomic commit; correct STATE.md (incl. fixing two self-inflicted authoring defects caught by its own validators); append this burst-log entry | This commit; `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry) |

**Files touched (Dim-1): 6 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md (modified)
- cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md (modified)
- specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md (modified)
- specs/prd/bc-1-auth-identity.md (modified)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` (8 bc files, exit 0) and `scripts/check-bc-cumulative-counts.sh` (742 total across 9 files, exit 0) both PASS — re-verified before this burst, recorded here per Defensive Sweep Discipline (S-7.02); `vp-delta.md`'s `input-hash` (`95218fd`) confirmed current against its listed inputs; `BC-INDEX.md` and `ADR-0022` confirmed unmodified since Burst 5 via `git status` and correctly excluded from this commit; a corpus grep for the stale "13 of 14 default CI" VP-classification claim found it only in this burst's own now-corrected STATE.md prose — no other live-truth surface carried the stale tally.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` spec-delta convergence only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 5 — F2 scoped adversarial convergence, Passes 5-6 + post-Pass-6 consistency sweep — INTERMEDIATE CHECKPOINT #2 (2026-09-03)

**Parent-commit:** `ab0a7fa5` (`develop` tip `42e92b46`, unchanged this burst — no `develop`-side commit).

**Trigger:** two further rounds of orchestrator-driven F2 scoped adversarial review (Pass 5, Pass 6) plus a post-Pass-6 fresh-context consistency-validator sweep had accumulated uncommitted on top of the Burst 4 checkpoint (`ab0a7fa5`), leaving STATE.md 2 passes + 1 sweep behind reality (it still read "Pass 5 NEXT"). This session resumed cleanly — no crash or agent-stall this burst, unlike Bursts 3-4. This burst makes that work durable via one atomic commit and brings STATE.md current. No new human decision was made — DEC-335 (the F1 human gate) remains the latest decision; no new DEC is recorded this burst.

**Work performed this burst, in order:**

1. **Adversarial Pass 5** (fresh context, scoped to the F2 spec delta as refined through Pass 4): 4 findings (1 HIGH / 1 MED / 2 LOW), novelty substantive. The HIGH was a second-order/propagation defect surfaced by an earlier-pass fix interacting with existing spec text — exactly the class of catch a fresh-context adversarial loop exists to find. Resolved via a full architect→product-owner→formal-verifier fix chain.
2. **Adversarial Pass 6** (fresh context): 4 findings (2 HIGH / 2 MED), novelty HIGH. Both HIGHs were second-order/propagation defects from earlier fixes interacting — the fresh-context loop's highest-value catches this cycle. One HIGH's fix round introduced a new debug-only test seam, `JR_FORCE_DPAPI_FALLBACK` (`#[cfg(debug_assertions)]`-gated only; production non-Windows behavior unchanged, hardcoded `false`), letting the DPAPI-fallback branch of `engage_dpapi_fallback` be exercised deterministically off real Windows; a new release-gate VP, `VP-AUTHDX-023`, pins a source-scan test asserting the `#[cfg(debug_assertions)]` guard sits within 5 source lines of the env-var read (same convention as `JR_TEST_BLOCK_UNTIL_SIGINT`/`JR_CONFIG_DIR`), and its opposing-outcome tests require `env_lock`-style `std::sync::Mutex` serialization (not `--test-threads=1`) since they assert conflicting outcomes from the same call site. `vp_count` 54 → 55 (+1, this burst). Resolved via the same architect→product-owner→formal-verifier fix-chain pattern.
3. **Post-Pass-6 fresh-context consistency-validator sweep.** Rather than deferring quality-checking until 3 consecutive clean adversarial passes are reached, a comprehensive cross-file consistency-validator sweep ran immediately after Pass 6 to flush the recurring cross-file-propagation finding class comprehensively in one pass instead of piecemeal per-adversarial-round. Findings: 3 total (0 CRIT / 0 HIGH / 2 MED / 1 LOW) — BC-1.4.028's H1 heading needed title enrichment to reflect its amended scope; a dead `prd-delta.md` citation lingered in `BC-INDEX.md` (the file was renamed/restructured earlier in F2, and the stale citation was never swept); a VP-015 terminology drift used "four-outcome" in one place where "four-way" (the term used everywhere else describing BC-1.4.028's partial-state discrimination) was correct. All 3 fixed. The validator's overall assessment: after 6 adversarial rounds the corpus is in unusually good shape — no count-integrity breaks, no broken BC↔VP↔ADR traceability, no semantic mis-anchors.
4. **Verification re-run:** `scripts/check-spec-counts.sh` exit 0; `scripts/check-bc-cumulative-counts.sh` exit 0 (742 BCs across 9 files, unchanged since Burst 3 — Passes 5-6 and the sweep were all BC-body/VP-body edits, no BC added/removed); `vp-delta.md`'s recorded `input-hash` (`00725ec`) confirmed current against its listed inputs.
5. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, per standing instruction carried across every prior burst.
6. Corrected two pre-existing structural gaps in this burst-log's own Burst 4 entry (found by this session's structural validation, not by an adversarial pass): added a missing `**Adversary verdict:**` block, and fixed a Dim-1 cardinality mismatch (headline claimed 7 unique files against an 8-item enumerated list — the correct count is 8).
7. Updated STATE.md via one full-content Write (v3.56 → v3.57): frontmatter, Phase Progress F2-SPEC-EVOLUTION row, Current Phase Steps table, Convergence Status / Concurrent Cycles / Constraints Carried Forward / Drift-Standing prose, and Session Resume Checkpoint all brought current to reflect Passes 5-6 and the consistency sweep complete+fixed, VP count 54→55, clean-streak 0/3, Pass 7 NEXT.
8. Appended this burst-log entry (Burst 5).

**Adversary verdict:** Not a single aggregate verdict — this burst's substance is two scoped adversarial passes (Pass 5, Pass 6) plus one non-adversarial consistency-validator sweep, each already narrated inline above with its own finding count and fix-round outcome (4 → 4 findings across the two adversarial passes, both fully resolved; 3 findings from the sweep, also fully resolved). No standalone top-level `adversary`-agent verdict beyond what the per-pass descriptions in "Work performed this burst" already capture. No CLEAN/BLOCKED convergence verdict applies yet — clean-streak remains 0/3, convergence still in progress; Pass 7 is next.

**Outcome:** cycle-004 (`windows-correctness`) Phase F2 (spec evolution) remains IN PROGRESS. `total_bcs` unchanged at 742 this burst (Passes 5-6 were BC-body refinements, not new BCs); `vp_count` advances 54 → 55 (+1, VP-AUTHDX-023 added during the Pass-6 fix round). Adversarial finding trajectory: 17 → 9 → 5 → 4 → 4 → 4 (all findings from all 6 passes resolved via architect→product-owner→formal-verifier fix chains); the post-Pass-6 consistency sweep found and fixed 3 further findings. Clean-streak 0/3 — three CONSECUTIVE clean passes are required to converge; none has yet been clean. **NEXT:** dispatch adversarial Pass 7 (fresh context), continuing toward 3 consecutive clean passes, then the F2 human gate (re-running the consistency-validator only if further fixes land after Pass 7+).

**Codifications:** none this burst — no new DEC; DEC-335 (F1 human gate) remains the latest decision. The Pass 5-6 fix-chain outputs (VP-AUTHDX-023 + its release-gate/serialization requirements, BC-body amendments, ADR-0021/ADR-0022 refinements) plus the consistency sweep's 3 fixes are the codified F2 spec-evolution convergence output.

**Closes:** the STATE.md staleness that had accumulated across Passes 5-6 and the post-Pass-6 sweep (STATE.md previously still read "Pass 5 NEXT," now current). Also closes the pre-existing Burst-4 structural gaps (missing Adversary verdict block, Dim-1 count mismatch) noted in item 6 above. **Does NOT close:** F2 itself, which remains IN PROGRESS pending Pass 7+ (to reach 3 consecutive clean passes) and the F2 human gate; no cycle-001/002/003 standing Drift/Standing Items are touched.

### Counts reconciled this burst

BCs: unchanged at **742** (Passes 5-6 amended existing BC bodies; no BC added or removed). VPs: 54 → **55** (+1: VP-AUTHDX-023). Holdout scenarios unchanged at 106. `total_stories` unchanged at 168 (F2 does not create stories). Reserved Windows device-name set unchanged at 30 (ADR-0021 §9).

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary (Pass 5, fresh context) | Scoped adversarial review, round 5 | 4 findings (1 HIGH/1 MED/2 LOW), novelty substantive |
| architect + product-owner + formal-verifier (Pass 5 fix round) | Resolve Pass 5 findings | BC-body amendments; fix chain closing the second-order propagation HIGH |
| adversary (Pass 6, fresh context) | Scoped adversarial review, round 6 | 4 findings (2 HIGH/2 MED), novelty HIGH |
| architect + product-owner + formal-verifier (Pass 6 fix round) | Resolve Pass 6 findings | `JR_FORCE_DPAPI_FALLBACK` debug-seam + `VP-AUTHDX-023` release-gate pin + `env_lock` serialization requirement; further BC/ADR amendments |
| consistency-validator (fresh context, post-Pass-6 sweep) | Comprehensive cross-file consistency sweep | 3 findings (0 CRIT/0 HIGH/2 MED/1 LOW): BC-1.4.028 H1 title enrichment, dead `prd-delta.md` citation removed from BC-INDEX, VP-015 "four-way"/"four-outcome" terminology corrected |
| state-manager | Verify accumulated work is internally consistent; fix Burst-4 structural gaps; commit it in one atomic commit; correct STATE.md; append this burst-log entry | This commit; `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry + Burst-4 fixes) |

**Files touched (Dim-1): 7 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md (modified)
- cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md (modified)
- specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md (modified)
- specs/prd/bc-1-auth-identity.md (modified)
- specs/prd/BC-INDEX.md (modified)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` (8 bc files, exit 0) and `scripts/check-bc-cumulative-counts.sh` (742 total across 9 files, exit 0) both PASS — re-verified before this burst, recorded here per Defensive Sweep Discipline (S-7.02); `vp-delta.md`'s `input-hash` (`00725ec`) confirmed current against its listed inputs; a corpus grep for the stale "54 VP"/"41 VP" counts found them only in genuinely-historical surfaces (cycle-003 files, prior cycle-004 burst-log Burst 3/4 entries, session-reviews) which correctly describe a past point in time and are left unchanged — no live-truth surface other than STATE.md carried a stale count.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` spec-delta convergence only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 7 — F2 scoped adversarial convergence, Passes 9-11 — INTERMEDIATE CHECKPOINT #4 (2026-09-04)

**Parent-commit:** Burst 6's commit (`develop` tip `42e92b46`, unchanged this burst — no `develop`-side commit).

**Trigger:** the human convergence directive recorded at the Burst 6 (post-Pass-8) checkpoint — "continue to full 3-consecutive-clean-pass convergence," rejecting gate-now-with-residuals — authorized three further rounds of orchestrator-driven F2 scoped adversarial review (Pass 9, Pass 10, Pass 11), which had accumulated uncommitted on top of the Burst 6 checkpoint. This burst makes that work durable via one atomic commit and brings STATE.md current. No new human decision was made this burst beyond recording the standing directive — DEC-335 (the F1 human gate) remains the latest recorded DEC.

**Work performed this burst, in order:**

1. **Adversarial Pass 9** (fresh context, scoped to the F2 spec delta as refined through Pass 8): 2 findings (0 CRIT / 0 HIGH / 1 MED / 1 LOW), novelty MED-LOW. Resolved via a full architect→product-owner→formal-verifier fix chain.
2. **Adversarial Pass 10** (fresh context): 1 finding (0 CRIT / 1 HIGH / 0 MED / 0 LOW). The HIGH was a class-level defect, not a one-off: an earlier passage's "non-Windows always no-op" framing for `load_pair`/`store_pair`/`remove_if_present` overstated the guard-passing carve-out, and the same overstatement recurred at 3 further sibling loci across ADRs, BC bodies, and VP text. Rather than patching only the one cited instance, the fix round ran an exhaustive class-sweep — a comprehensive corpus grep for every "non-Windows … no-op" framing touching these three functions — and corrected all instances in one pass, closing the class with zero residuals confirmed by re-grep. Resolved via the architect→product-owner→formal-verifier fix chain.
3. **Adversarial Pass 11** (fresh context): 2 findings (0 CRIT / 0 HIGH / 2 MED / 0 LOW). MED 1: `architecture-delta.md` §7's VP-hooks CI-classification table had gone stale relative to the Pass-8 keyring-gated correction (Burst 6) — it still carried the pre-Pass-8 tally instead of the corrected 10 fully-default-CI / 2 default-CI-portion+keyring-gated-core / 1 keyring-gated-core+Windows-tail / 1 Windows-only breakdown; corrected to match. MED 2: the DPAPI-fallback guard-rejection error message read "not valid for credential storage" / "choose a different name," which contradicted the keyring happy-path (a name rejected for the DPAPI-file fallback can still store successfully via keyring) — reworded to scope the restriction explicitly to the Windows encrypted-file fallback only, not credential storage generally. Both resolved via the architect→product-owner→formal-verifier fix chain.
4. **Verification re-run:** `scripts/check-spec-counts.sh` exit 0; `scripts/check-bc-cumulative-counts.sh` exit 0 (742 BCs across 9 files, unchanged — Passes 9-11 were BC-body/VP-body/architecture-delta edits, no BC added or removed); `vp-delta.md`'s recorded `input-hash` (`8b37046`) confirmed current against its listed inputs.
5. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, per standing instruction carried across every prior burst. `ADR-0022` was confirmed NOT modified since the Burst 6 checkpoint (`git status` showed no changes to it) and was correctly excluded from this burst's commit.
6. Updated STATE.md via one full-content Write (v3.58 → v3.59): frontmatter, Phase Progress F2-SPEC-EVOLUTION row, Current Phase Steps table (Passes 9-11 marked DONE, checkpoint #4 recorded, Pass 12 NEXT), Convergence Status / Concurrent Cycles / Constraints Carried Forward / Drift-Standing prose (trajectory extended to 17→9→5→4→4→4→[sweep 3]→3→3→1→1→2, clean-streak 0/3, the operator's full-convergence directive recorded), and Session Resume Checkpoint all brought current, recording NEXT-on-resume as dispatch of F2 adversarial Pass 12.
7. Appended this burst-log entry (Burst 7).

**Adversary verdict:** Not a single aggregate verdict — this burst's substance is three scoped adversarial passes (Pass 9, Pass 10, Pass 11), each already narrated inline above with its own finding count and fix-round outcome (2 → 1 → 2 findings, all fully resolved). No standalone top-level `adversary`-agent verdict beyond what the per-pass descriptions in "Work performed this burst" already capture. No CLEAN/BLOCKED convergence verdict applies yet — clean-streak remains 0/3 (no pass has yet been clean), convergence still in progress per the operator's continue-to-full-convergence directive.

**Outcome:** cycle-004 (`windows-correctness`) Phase F2 (spec evolution) remains IN PROGRESS. `total_bcs` unchanged at 742 this burst; `vp_count` unchanged at 55 (Passes 9-11 were BC-body/VP-body/architecture-delta refinements, no new VP number allocated). Adversarial finding trajectory: 17 → 9 → 5 → 4 → 4 → 4 → [post-Pass-6 sweep: 3] → 3 → 3 → 1 → 1 → 2 (all findings from all 11 passes resolved via architect→product-owner→formal-verifier fix chains). Clean-streak 0/3 — three CONSECUTIVE clean passes are required to converge under the standard rule; none has yet been clean. **HUMAN CONVERGENCE DIRECTIVE (recorded, no DEC):** at the post-Pass-8 gate the operator chose "continue to full 3-consecutive-clean-pass convergence," rejecting gate-now-with-residuals — the loop continues to that bar. **NEXT:** dispatch F2 scoped adversarial Pass 12 (fresh context), continuing toward 3 consecutive clean passes.

**Codifications:** none this burst — no new DEC; DEC-335 (F1 human gate) remains the latest recorded decision. The Pass 9-11 fix-chain outputs (the class-sweep correcting the "non-Windows always no-op" overstatement across ADRs/BCs/VPs, the architecture-delta §7 VP-hooks CI-classification reconciliation, and the guard-rejection message scoping fix) are the codified F2 spec-evolution convergence output this burst. The operator's continue-to-full-convergence directive is a process directive, not a spec/scope decision, and is recorded in STATE.md prose rather than as a DEC.

**Closes:** the STATE.md staleness that had accumulated across Passes 9-11 (STATE.md previously current only through Pass 8, now current through Pass 11). Also closes, via the Pass 10 class-sweep, every remaining instance of the "non-Windows always no-op" overstatement across the corpus (comprehensive grep confirmed zero residuals). **Does NOT close:** F2 itself, which remains IN PROGRESS pending Pass 12+ (toward 3 consecutive clean passes, per the operator's directive) and the F2 human gate; no cycle-001/002/003 standing Drift/Standing Items are touched.

### Counts reconciled this burst

BCs: unchanged at **742** (Passes 9-11 amended existing BC/ADR/VP body text; no BC added or removed). VPs: unchanged at **55**. Holdout scenarios unchanged at 106. `total_stories` unchanged at 168 (F2 does not create stories). Reserved Windows device-name set unchanged at 30 (ADR-0021 §9).

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary (Pass 9, fresh context) | Scoped adversarial review, round 9 | 2 findings (0 CRIT/0 HIGH/1 MED/1 LOW), novelty MED-LOW |
| architect + product-owner + formal-verifier (Pass 9 fix round) | Resolve Pass 9 findings | BC/VP-body amendments |
| adversary (Pass 10, fresh context) | Scoped adversarial review, round 10 | 1 finding (0 CRIT/1 HIGH/0 MED/0 LOW) — "non-Windows always no-op" overstatement class |
| architect + product-owner + formal-verifier (Pass 10 fix round) | Resolve Pass 10 finding via exhaustive class-sweep | Corrected the overstatement at the cited locus plus 3 further sibling loci across ADRs/BC bodies/VP text; comprehensive grep confirmed zero residuals |
| adversary (Pass 11, fresh context) | Scoped adversarial review, round 11 | 2 findings (0 CRIT/0 HIGH/2 MED/0 LOW) |
| architect + product-owner + formal-verifier (Pass 11 fix round) | Resolve Pass 11 findings | architecture-delta.md §7 VP-hooks CI-classification table reconciled to the Pass-8 corrected tally; DPAPI-fallback guard-rejection message reworded to scope the restriction to the Windows encrypted-file fallback only |
| state-manager | Verify accumulated work is internally consistent; commit it in one atomic commit; correct STATE.md; append this burst-log entry | This commit; `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry) |

**Files touched (Dim-1): 7 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md (modified)
- cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md (modified)
- specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md (modified)
- specs/prd/bc-1-auth-identity.md (modified)
- specs/prd/BC-INDEX.md (modified)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` (8 bc files, exit 0) and `scripts/check-bc-cumulative-counts.sh` (742 total across 9 files, exit 0) both PASS — re-verified before this burst, recorded here per Defensive Sweep Discipline (S-7.02); `vp-delta.md`'s `input-hash` (`8b37046`) confirmed current against its listed inputs; `ADR-0022` confirmed unmodified since Burst 6 via `git status` and correctly excluded from this commit; a corpus grep for the "non-Windows always no-op" overstatement pattern (Pass 10's class) found zero remaining residuals after the fix round — confirmed here per Defensive Sweep Discipline.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` spec-delta convergence only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 8 — F2 scoped adversarial convergence, Passes 12-14 — INTERMEDIATE CHECKPOINT #5 (2026-09-04)

**Parent-commit:** Burst 7's commit (`develop` tip `42e92b46`, unchanged this burst — no `develop`-side commit).

**Trigger:** the human convergence directive recorded at the Burst 6 (post-Pass-8) checkpoint — "continue to full 3-consecutive-clean-pass convergence" — continues to authorize further rounds of orchestrator-driven F2 scoped adversarial review. Pass 12, Pass 13, and Pass 14 accumulated uncommitted on top of the Burst 7 checkpoint. This burst makes that work durable via one atomic commit and brings STATE.md current. No new human decision was made this burst — DEC-335 (the F1 human gate) remains the latest recorded DEC.

**Work performed this burst, in order:**

1. **Adversarial Pass 12** (fresh context, scoped to the F2 spec delta as refined through Pass 11): 2 findings (0 CRIT / 0 HIGH / 1 MED / 1 LOW). Finding #1 (MED, CI-classification honesty): VP-AUTHDX-015's exactly-one-key-present partial-state branch (the AMENDED BC-1.4.028 read path) requires the keyring to PERSIST exactly one namespaced key to be reached — the same VP-AUTHDX-005/006/007 state-persistence boundary Pass-8 already used to reclassify VP-AUTHDX-011/012/022 — so the Pass-8 "10 of 14 fully default-CI" tally was itself still an overstatement for this one VP. Reclassified to "default-CI portion (both-absent branch) + keyring-gated partial-state tail," correcting the honest split to 9-of-14 fully default-CI / 3-of-14 default-CI-portion+keyring-gated (VP-AUTHDX-011, 012, 015) / 1-of-14 keyring-gated-core (VP-AUTHDX-022) / 1-of-14 Windows-only (VP-AUTHDX-010). Finding #2 (LOW): ADR-0021 §1's `engage_dpapi_fallback` code sample left the `err` parameter genuinely unused under `-D warnings` in a RELEASE build, since the `#[cfg(debug_assertions)]` block that consumes it is compiled out entirely in that configuration — a real defect in a code sample F4 implementers are directed to build against, though the dev-profile clippy CI job never surfaced it. Fixed with a mirror-cfg `#[cfg(not(debug_assertions))] let _ = err;` arm (not an `#[allow]`, per CLAUDE.md's no-lint-suppression-without-refactoring policy) so exactly one of the two `err` uses compiles in for any given profile. Resolved via a formal-verifier (Finding #1) + architect (Finding #2) fix chain.
2. **Adversarial Pass 13** (fresh context): **CLEAN — zero findings, novelty ZERO.** The first clean pass this convergence run. Clean-streak advanced from 0/3 to 1/3.
3. **Adversarial Pass 14** (fresh context): 1 finding (0 CRIT / 0 HIGH / 1 MED / 0 LOW) plus 1 process-gap observation. Finding #1 (MED): `bc-1-auth-identity.md`'s "## Summary Stats" closing Note had been frozen at the cycle-003 end-state ("71 total BCs … plus 13 new individually-bodied contracts added in cycle-003"), contradicting the file's own authoritative `total_bcs: 80`/`definitional_count: 69` frontmatter and the cycle-004 recompute note immediately above it, and never mentioning cycle-004's 9 new BCs (BC-1.2.052/053/054, BC-1.4.035..040) — a drift that had survived all 13 prior adversarial passes undetected because `scripts/check-bc-cumulative-counts.sh` reconciles 8 count surfaces but does not cover this one per-file prose surface. Fixed by rewording the Note to STOP restating literal cumulative/definitional counts in prose, instead pointing at the `total_bcs`/`definitional_count` frontmatter fields and the Summary Stats table Total as the sole authoritative source — a drift-proof fix that prevents this exact class of staleness from recurring on a future cycle's BC additions. The process-gap itself (the script's coverage blind spot) is recorded in STATE.md's Drift/Standing as a codification candidate for a future SELF-IMPROVEMENT/maintenance cycle, not a cycle-004 blocker. Pass 14 reset the clean-streak from 1/3 back to 0/3. Resolved via a product-owner fix (BC-body reword) with the process-gap recorded, not independently fixed (it targets tooling, not this cycle's spec delta).
4. **Verification re-run:** `scripts/check-spec-counts.sh` exit 0; `scripts/check-bc-cumulative-counts.sh` exit 0 (742 BCs across 9 files, unchanged — Passes 12-14 were VP-body/ADR-body/BC-body edits, no BC added or removed); `vp-delta.md`'s recorded `input-hash` (`0c454f6`) confirmed current against its listed inputs.
5. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, per standing instruction carried across every prior burst. `BC-INDEX.md` and `ADR-0022` were both confirmed NOT modified since the Burst 7 checkpoint (`git status` showed no changes to either) and were correctly excluded from this burst's commit.
6. Updated STATE.md via one full-content Write (v3.59 → v3.60): frontmatter, Phase Progress F2-SPEC-EVOLUTION row, Current Phase Steps table (Passes 12-14 marked DONE, checkpoint #5 recorded, Pass 15 NEXT), Convergence Status / Concurrent Cycles / Constraints Carried Forward / Drift-Standing prose (trajectory extended to 17→9→5→4→4→4→[sweep 3]→3→3→1→1→2→1→CLEAN→1, clean-streak 0/3, the Pass-14 process-gap recorded), and Session Resume Checkpoint all brought current, recording NEXT-on-resume as dispatch of F2 adversarial Pass 15.
7. Appended this burst-log entry (Burst 8).

**Adversary verdict:** Not a single aggregate verdict — this burst's substance is three scoped adversarial passes (Pass 12, Pass 13, Pass 14), each already narrated inline above with its own finding count and fix-round outcome (2 → CLEAN → 1 findings). Pass 13 is the first CLEAN verdict this convergence run has produced. No standalone top-level `adversary`-agent verdict beyond what the per-pass descriptions in "Work performed this burst" already capture. No overall CLEAN/BLOCKED convergence verdict applies yet — clean-streak remains 0/3 (Pass 13 was clean, Pass 14 broke it), convergence still in progress per the operator's continue-to-full-convergence directive.

**Outcome:** cycle-004 (`windows-correctness`) Phase F2 (spec evolution) remains IN PROGRESS. `total_bcs` unchanged at 742 this burst; `vp_count` unchanged at 55 (Pass 12 reclassified VP-AUTHDX-015's CI tier only, no new VP number allocated; Passes 13-14 added no VP). Adversarial finding trajectory: 17 → 9 → 5 → 4 → 4 → 4 → [post-Pass-6 sweep: 3] → 3 → 3 → 1 → 1 → 2 → 1 → CLEAN → 1 (all findings from all 14 passes resolved via fix chains; Pass 13 the first CLEAN result this run). Clean-streak 0/3 — three CONSECUTIVE clean passes are required to converge under the standard rule; Pass 13 was clean, Pass 14 reset the streak. **HUMAN CONVERGENCE DIRECTIVE (recorded, no DEC):** unchanged — "continue to full 3-consecutive-clean-pass convergence" remains standing. **PROCESS-GAP recorded (not a blocker):** `scripts/check-bc-cumulative-counts.sh` does not cover a per-file `bc-*.md` Summary Stats closing Note's cumulative prose, which is why the Pass-14 drift survived 13 prior passes undetected; candidate remediation (extend script coverage, or standardize a reference-frontmatter-not-restate-literal-count convention) logged as a codification candidate for a future SELF-IMPROVEMENT/maintenance cycle. **NEXT:** dispatch F2 scoped adversarial Pass 15 (fresh context), continuing toward 3 consecutive clean passes.

**Codifications:** none this burst — no new DEC; DEC-335 (F1 human gate) remains the latest recorded decision. The Pass 12-14 fix-chain outputs (VP-AUTHDX-015's CI-reclassification, the ADR-0021 release-build code-sample fix, and the bc-1 Summary Stats Note drift-proofing) are the codified F2 spec-evolution convergence output this burst. The Pass-14 process-gap (the `check-bc-cumulative-counts.sh` coverage blind spot) is recorded as a codification CANDIDATE in STATE.md's Drift/Standing and the `S-PG-*` backlog — it is not itself codified this burst, pending PO BC-authorship in a future maintenance cycle.

**Closes:** the STATE.md staleness that had accumulated across Passes 12-14 (STATE.md previously current only through Pass 11, now current through Pass 14). Also closes the release-build `unused_variables` defect in ADR-0021's `engage_dpapi_fallback` code sample (Pass 12 Finding #2), and the 13-pass-old stale cumulative-BC-count claim in bc-1's Summary Stats Note (Pass 14 Finding #1). **Does NOT close:** F2 itself, which remains IN PROGRESS pending Pass 15+ (toward 3 consecutive clean passes, per the operator's directive) and the F2 human gate; the Pass-14 process-gap remains open as a recorded candidate, not fixed; no cycle-001/002/003 standing Drift/Standing Items are touched.

### Counts reconciled this burst

BCs: unchanged at **742** (Passes 12-14 amended existing VP/ADR/BC body text; no BC added or removed). VPs: unchanged at **55** (Pass 12 reclassified an existing VP's CI tier only). Holdout scenarios unchanged at 106. `total_stories` unchanged at 168 (F2 does not create stories). Reserved Windows device-name set unchanged at 30 (ADR-0021 §9).

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary (Pass 12, fresh context) | Scoped adversarial review, round 12 | 2 findings (0 CRIT/0 HIGH/1 MED/1 LOW) — VP-AUTHDX-015 CI-classification honesty correction; ADR-0021 release-build code-sample defect |
| formal-verifier + architect (Pass 12 fix round) | Resolve Pass 12 findings | VP-delta CI tally corrected to 9-of-14; ADR-0021 §1 code sample fixed with mirror-cfg `let _ = err;` arm |
| adversary (Pass 13, fresh context) | Scoped adversarial review, round 13 | CLEAN — zero findings, novelty ZERO; first clean pass this convergence run |
| adversary (Pass 14, fresh context) | Scoped adversarial review, round 14 | 1 finding (0 CRIT/0 HIGH/1 MED/0 LOW) + 1 process-gap observation |
| product-owner (Pass 14 fix round) | Resolve Pass 14 finding | bc-1-auth-identity.md Summary Stats Note reworded to reference frontmatter/table rather than restate a literal cumulative count |
| state-manager | Verify accumulated work is internally consistent; commit it in one atomic commit; correct STATE.md; append this burst-log entry | This commit; `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry) |

**Files touched (Dim-1): 6 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md (modified)
- cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md (modified)
- specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md (modified)
- specs/prd/bc-1-auth-identity.md (modified)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` (8 bc files, exit 0) and `scripts/check-bc-cumulative-counts.sh` (742 total across 9 files, exit 0) both PASS — re-verified before this burst, recorded here per Defensive Sweep Discipline (S-7.02); `vp-delta.md`'s `input-hash` (`0c454f6`) confirmed current against its listed inputs; `BC-INDEX.md` and `ADR-0022` both confirmed unmodified since Burst 7 via `git status` and correctly excluded from this commit.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` spec-delta convergence only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 9 — F2 scoped adversarial convergence, Passes 15-19 — FIRST 3-CONSECUTIVE-CLEAN CONVERGENCE, then gate-audit DRIFT + Pass-20 reconciliation — INTERMEDIATE CHECKPOINT #6 (2026-09-04)

**Parent-commit:** Burst 8's commit (`develop` tip `42e92b46`, unchanged this burst — no `develop`-side commit).

**Trigger:** the standing human convergence directive ("continue to full 3-consecutive-clean-pass convergence") continued to authorize adversarial Passes 15-19. Passes 15-19 accumulated uncommitted on top of the Burst 8 checkpoint, culminating in the FIRST 3-consecutive-clean adversarial convergence this cycle-004 F2 run has achieved. A fresh-context pre-gate consistency-validator audit ("converged != consistent" check) was then dispatched ahead of presenting the F2 human gate, per standard practice before any convergence result is presented for human approval. That audit returned DRIFT (1 HIGH / 1 MED / 1 LOW), which was reconciled via a Pass-20 fix chain. Because the fix chain modified the delta (5 files), the 3-consecutive-clean streak is RESET to 0/3 and must be re-established on the corrected delta before the F2 human gate can be presented. No new human decision was made this burst — DEC-335 (the F1 human gate) remains the latest recorded DEC.

**Work performed this burst, in order:**

1. **Adversarial Pass 15** (fresh context): 2 findings (1 MED + 1 LOW) — a trace-gap (a citation/coverage gap between a spec claim and its backing test/VP trace) and a seam-wording issue in `vp-delta.md`. Resolved via a formal-verifier fix chain (trace entry added to `bc-1-auth-identity.md`'s frontmatter Trace field referencing Pass-12's VP-010 note; `vp-delta.md` seam wording corrected).
2. **Adversarial Pass 16** (fresh context): 1 finding (1 LOW) — `architecture-delta.md` §7 carried stale VP-ID labels (referencing superseded VP numbering from an earlier pass). Resolved via an architect fix chain (§7 label fix; §20 added).
3. **Adversarial Passes 17, 18, 19** (fresh context, each independently dispatched): **ALL THREE CLEAN — zero findings, novelty ZERO on each.** This is the **FIRST 3-CONSECUTIVE-CLEAN adversarial convergence** this cycle-004 F2 run has achieved, satisfying the standard 3-consecutive-clean-pass convergence bar on the delta as it stood at the end of Pass 19.
4. **Pre-gate consistency-validator audit** (fresh context, dispatched ahead of presenting the F2 human gate — the standard "converged != consistent" check that a clean adversarial streak alone does not guarantee corpus-wide consistency): returned **DRIFT — 1 HIGH / 1 MED / 1 LOW**, meaning the achieved convergence was not yet safe to gate.
   - **HIGH (Finding 1):** BC-1.4.040's path-traversal guard, ADR-0021 §9, and the Pass-8 `clear_dpapi_file_tolerating_path_escape` adapter rationale had all mischaracterized the guard as closing a live CWE-22 HIGH vulnerability — framed as "no profile-name validation exists today" and citing a "pre-existing profile named `con`" backward-compatibility scenario as the reason the CLEAR path must tolerate a path-escaping name. Both premises are false: `bc-6-config-cache.md`'s BC-6.1.004/BC-6.1.005 (`validate_profile_name`, verified present and wired in `src/config.rs`) already validates every profile name — ASCII `[A-Za-z0-9_-]`, ≤64 chars, plus reserved-name rejection — at both config-load and CLI boundaries. This makes every vector the guard defends against unreachable via any normal (validated) path, and makes the cited "pre-existing profile named `con`" scenario impossible to construct in a config that could ever have loaded successfully. **Resolved via a Pass-20 fix chain (architect → product-owner → formal-verifier):** the guard AND the `clear_dpapi_file_tolerating_path_escape` adapter are KEPT UNMODIFIED — no behavior change — but RECLASSIFIED from "closes a live CWE-22 HIGH" to **defense-in-depth**, guarding against a future `validate_profile_name` charset/reserved-list relaxation or a validation-call-site regression, not a live gap today. The false "unvalidated today" premise and the false "pre-existing `con`" scenario were corrected in ADR-0021 §9 and §7, and in BC-1.4.040/035/036/039/038. `bc-6-config-cache.md`'s BC-6.1.004/BC-6.1.005 were added as Related BCs / cited as the primary live gate. `VP-AUTHDX-016`'s label was downgraded from HIGH-CWE-22 to defense-in-depth (its assertion/test logic is unchanged — only the label and rationale). A corpus-wide sweep for the same false-premise pattern across all other VP oracles came back clean — no sibling instances found.
   - **MED (Finding 2):** the new `ProfilePathEscape` exit-64 error message (introduced by the Pass-8 CLEAR-path fix) was never registered in `error-taxonomy.md`. **Resolved:** registered in error-taxonomy.md Section 6, with explicit disambiguation from the pre-existing `validate_profile_name` "invalid profile name" error (the two are distinct failure modes at different boundaries and must not be conflated).
   - **LOW (Finding 3):** a deferred `bc-6-config-cache.md` BC-6.2.016 cross-reference (the reciprocal link from bc-6 back to the newly-added Related BCs above) is blocked by a PRE-EXISTING TD-031 stable-anchor-hygiene hook violation on `bc-6-config-cache.md` — unrelated to cycle-004, predates this cycle. **CARRIED FORWARD as a non-blocking maintenance item** (recorded in Drift/Standing below); recommend a future maintenance pass clear TD-031 so the cross-reference can land. **NOT a cycle-004 blocker** — the HIGH and MED findings above do not depend on this cross-reference landing.
5. **Verification re-run:** `scripts/check-spec-counts.sh` exit 0; `scripts/check-bc-cumulative-counts.sh` exit 0 (742 BCs across 9 files, unchanged — the gate-audit fixes were framing/rationale/cross-ref/label/taxonomy-only, no BC added, removed, or renumbered); `vp-delta.md`'s recorded `input-hash` (`2db0acb`) confirmed current against its listed inputs.
6. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, per standing instruction carried across every prior burst.
7. **Convergence-state consequence:** because the Pass-20 gate-audit fix chain modified the delta (`bc-1-auth-identity.md`, `error-taxonomy.md`, `vp-delta.md`, `architecture-delta.md`, `ADR-0021`) after Pass 19's clean result, the 3-consecutive-clean streak achieved at Pass 19 no longer certifies the CURRENT state of the delta — it certified a now-superseded snapshot. The clean-streak is therefore RESET to 0/3, and a fresh round of adversarial passes (starting at Pass 20) must re-establish 3 consecutive clean passes against the corrected delta, followed by a re-run of the pre-gate consistency-validator audit, before the F2 human gate can be presented.
8. Updated STATE.md via one full-content Write (v3.60 → v3.61): frontmatter, Phase Progress F2-SPEC-EVOLUTION row, Current Phase Steps table (Passes 15-19 marked DONE, the gate-audit DRIFT + Pass-20 reconciliation recorded, checkpoint #6 recorded, adversarial Pass 20 marked NEXT), Convergence Status / Concurrent Cycles / Constraints Carried Forward / Drift-Standing prose (trajectory extended to include Passes 15-19 and the gate-audit episode, clean-streak explicitly 0/3 pending re-convergence, the LOW TD-031-blocked cross-ref carried forward), and Session Resume Checkpoint all brought current, recording NEXT-on-resume as dispatch of F2 adversarial Pass 20 (fresh context) on the corrected delta.
9. Appended this burst-log entry (Burst 9).

**Adversary verdict:** Passes 15 and 16 each returned a small fix-round (2 findings, then 1 finding), both resolved. Passes 17, 18, and 19 each independently returned CLEAN — the first 3-consecutive-clean result this convergence run has produced, satisfying the standard convergence bar as of Pass 19. The subsequent pre-gate consistency-validator audit (a distinct check from the adversarial pass series — it validates corpus-wide cross-document consistency rather than re-probing for new gaps/contradictions within the delta) returned DRIFT (1 HIGH/1 MED/1 LOW), all three resolved via the Pass-20 fix chain described above. No standalone top-level `adversary`-agent aggregate verdict beyond the per-pass/per-audit outcomes already narrated. **Net convergence verdict: NOT YET CONVERGED** — the achieved 3-consecutive-clean streak was invalidated by the gate-audit's required fixes; re-convergence on the corrected delta is required before the F2 human gate.

**Outcome:** cycle-004 (`windows-correctness`) Phase F2 (spec evolution) remains IN PROGRESS. `total_bcs` unchanged at 742 this burst; `vp_count` unchanged at 55 (all Pass 15-20 fix-round edits were body/label/rationale/cross-ref/taxonomy-only — no BC or VP added, removed, or renumbered). Adversarial finding trajectory extended: 17→9→5→4→4→4→[sweep 3]→3→3→1→1→2→1→CLEAN→1→2→1→CLEAN→CLEAN→CLEAN → [pre-gate consistency-validator audit: DRIFT 1H/1M/1L, fixed via Pass-20 chain] → re-convergence pending. Clean-streak explicitly **RESET to 0/3** — the 3-consecutive-clean bar was reached once (Passes 17-19) but on a delta snapshot the gate audit then found needed correction; that correction resets the streak requirement against the now-current delta. **HUMAN CONVERGENCE DIRECTIVE (recorded, no DEC):** unchanged — "continue to full 3-consecutive-clean-pass convergence" remains standing, reaffirmed implicitly by this burst's re-convergence requirement. **LOW carried forward (not a blocker):** a deferred `bc-6-config-cache.md` BC-6.2.016 cross-reference is blocked by a pre-existing TD-031 stable-anchor-hygiene hook violation, unrelated to cycle-004; recommend a future maintenance pass. **NEXT:** dispatch F2 scoped adversarial Pass 20 (fresh context) on the corrected delta; re-establish 3 consecutive clean passes; re-run the pre-gate consistency-validator audit; then present the F2 human gate.

**Codifications:** none this burst — no new DEC; DEC-335 (F1 human gate) remains the latest recorded decision. The Pass 15-16 fix-chain outputs (trace-gap closure, seam-wording fix, §7 VP-ID label fix) and the Pass-20 gate-audit reconciliation (defense-in-depth reclassification of BC-1.4.040/ADR-0021 §9's guard rationale, `ProfilePathEscape` error-taxonomy registration, bc-6 Related-BC cross-refs) are the codified F2 spec-evolution convergence output this burst. The TD-031-blocked LOW cross-reference is recorded as a carried-forward non-blocking maintenance item, not codified this burst.

**Closes:** the STATE.md staleness that had accumulated across Passes 15-19 and the gate-audit episode (STATE.md previously current only through Pass 14, now current through the Pass-20 reconciliation). Also closes: the Pass-15 trace-gap and seam-wording issues; the Pass-16 stale VP-ID label issue; the gate-audit's HIGH false-premise mischaracterization of BC-1.4.040/ADR-0021 §9's guard as closing a live CWE-22 vulnerability (now correctly framed as defense-in-depth); the gate-audit's MED unregistered `ProfilePathEscape` error-taxonomy entry. **Does NOT close:** F2 itself, which remains IN PROGRESS pending re-established 3-consecutive-clean convergence (Pass 20+) and a re-run consistency-validator audit before the F2 human gate; the LOW TD-031-blocked bc-6 cross-reference remains open as a recorded, non-blocking maintenance item; no cycle-001/002/003 standing Drift/Standing Items are touched.

### Counts reconciled this burst

BCs: unchanged at **742** (Passes 15-20 amended existing BC/ADR/VP/error-taxonomy body text and rationale only; no BC added, removed, or renumbered). VPs: unchanged at **55** (VP-AUTHDX-016's label was downgraded; no VP added or removed). Holdout scenarios unchanged at 106. `total_stories` unchanged at 168 (F2 does not create stories). Reserved Windows device-name set unchanged at 30 (ADR-0021 §9, untouched this burst).

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary (Pass 15, fresh context) | Scoped adversarial review, round 15 | 2 findings (1 MED + 1 LOW) — trace-gap + seam wording |
| formal-verifier (Pass 15 fix round) | Resolve Pass 15 findings | Trace entry added referencing Pass-12's VP-010 note; vp-delta.md seam wording corrected |
| adversary (Pass 16, fresh context) | Scoped adversarial review, round 16 | 1 finding (1 LOW) — §7 stale VP-ID labels |
| architect (Pass 16 fix round) | Resolve Pass 16 finding | architecture-delta.md §7 label fix + §20 added |
| adversary (Pass 17, fresh context) | Scoped adversarial review, round 17 | CLEAN — zero findings |
| adversary (Pass 18, fresh context) | Scoped adversarial review, round 18 | CLEAN — zero findings |
| adversary (Pass 19, fresh context) | Scoped adversarial review, round 19 | CLEAN — zero findings; 3rd consecutive clean pass — first 3-consecutive-clean convergence this run |
| consistency-validator (pre-gate audit, fresh context) | Corpus-wide cross-document consistency audit ahead of F2 human gate | DRIFT — 1 HIGH / 1 MED / 1 LOW |
| architect + product-owner + formal-verifier (Pass 20 fix round) | Resolve gate-audit findings | BC-1.4.040/ADR-0021 §9/§7 guard reclassified defense-in-depth; ProfilePathEscape registered in error-taxonomy.md; bc-6 Related-BC cross-refs added; VP-AUTHDX-016 label downgraded; LOW cross-ref carried forward (TD-031-blocked) |
| state-manager | Verify accumulated work is internally consistent; commit it in one atomic commit; correct STATE.md; append this burst-log entry | This commit; `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry) |

**Files touched (Dim-1): 7 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/phase-f2-spec-evolution/architecture-delta.md (modified)
- cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md (modified)
- specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md (modified)
- specs/prd/bc-1-auth-identity.md (modified)
- specs/prd/error-taxonomy.md (modified)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` (8 bc files, exit 0) and `scripts/check-bc-cumulative-counts.sh` (742 total across 9 files, exit 0) both PASS — re-verified before this burst, recorded here per Defensive Sweep Discipline (S-7.02); `vp-delta.md`'s `input-hash` (`2db0acb`) confirmed current against its listed inputs; `BC-INDEX.md` and `ADR-0022` both confirmed unmodified since Burst 8 via `git status` and correctly excluded from this commit; a corpus-wide sweep for the gate-audit's false-premise pattern across all other VP oracles came back clean — no sibling instances found, recorded here per Defensive Sweep Discipline.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` spec-delta convergence only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 10 — F2 scoped adversarial RE-CONVERGENCE (Passes 20-25) + second consistency-validator re-audit CONSISTENT — F2 CONVERGENCE CHECKPOINT #7 (2026-09-04)

**Parent-commit:** Burst 9's commit (`develop` tip `42e92b46`, unchanged this burst — no `develop`-side commit).

**Trigger:** Burst 9's pre-gate consistency-validator audit had found DRIFT (1 HIGH/1 MED/1 LOW), reconciled via a Pass-20 fix chain that changed the spec delta and reset the 3-consecutive-clean adversarial streak to 0/3. The standing human convergence directive ("continue to full 3-consecutive-clean-pass convergence, re-confirmed by a consistency-validator audit with no DRIFT") continued to authorize a fresh round of adversarial passes on the corrected delta, followed by a second consistency-validator audit before the F2 spec delta could be presented at the human gate.

**Work performed this burst, in order:**

1. **Adversarial Pass 20** (fresh context, on the delta as corrected by Burst 9's Pass-20 fix chain): 1 finding — a `BC-INDEX.md` propagation miss. Burst 9's Pass-20 gate-audit fix chain had deliberately left `BC-INDEX.md` untouched (per its own record: "`BC-INDEX.md` and `ADR-0022` both confirmed unmodified since Burst 7"), but the underlying BC-1.4.040 reclassification (HIGH→defense-in-depth) and the new bc-6 Related-BC cross-refs were never propagated into `BC-INDEX.md` itself, leaving it stale relative to the reclassified BC bodies. Resolved via a product-owner fix chain: `BC-INDEX.md`'s BC-1.4.040 row updated to reflect the defense-in-depth classification and the bc-6 cross-references.
2. **Adversarial Pass 21** (fresh context): 1 finding — a stale Trace-provenance sentence in `bc-1-auth-identity.md`, left over from before the Pass-20 reclassification (referencing the guard's old "closes live CWE-22" framing rather than the corrected defense-in-depth framing). Resolved via a product-owner fix chain: the Trace field corrected to reference the current defense-in-depth rationale and the bc-6 Related BCs.
3. **Adversarial Pass 22** (fresh context): 1 finding — an `error-taxonomy.md` invoke/render/swallow precision nit on the `ProfilePathEscape` row (the Section-6 registration added at Burst 9 imprecisely described which layer invokes, which layer renders, and which layer swallows the error). Resolved via a formal-verifier fix chain: the row's invoke/render/swallow columns corrected to precisely name the CLEAR-path call site (invoke), the read/store sites (render), and the tolerant CLEAR-path-only swallow behavior (BC-1.4.038 Invariant 3).
4. **Adversarial Passes 23, 24, and 25** (fresh context, each independently dispatched): **ALL THREE CLEAN — zero findings, novelty ZERO on each.** This **RE-ESTABLISHES** the 3-consecutive-clean adversarial convergence bar on the fully-corrected delta (BC-INDEX.md, bc-1-auth-identity.md, and error-taxonomy.md all current).
5. **Second pre-gate consistency-validator audit** (fresh context, dispatched ahead of presenting the F2 human gate — the standard re-check required after any prior DRIFT finding, per the standing human convergence directive): returned **CONSISTENT — zero new findings.** The audit explicitly confirmed: (a) the Pass-20 gate-audit reconciliation (BC-1.4.040/ADR-0021 §9 guard reclassified defense-in-depth, `ProfilePathEscape` registered in `error-taxonomy.md`) is now fully and consistently propagated across every corpus surface, including `BC-INDEX.md` (closed by this burst's Pass 20); (b) no new cross-corpus drift was introduced by the Pass 20-22 fixes; (c) the F1-approved 4-story scope (`dpapi-storage-fix` + `honest-fail-message` bundled, `windows-docs`, `cloud_id-correctness`) remains fully covered with no scope creep; (d) `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` both exit 0.
6. **Verification re-run:** `scripts/check-spec-counts.sh` exit 0; `scripts/check-bc-cumulative-counts.sh` exit 0 (742 BCs across 9 files, unchanged — Passes 20-22 amended existing BC/index/error-taxonomy body text only, no BC added, removed, or renumbered); `vp-delta.md`'s recorded `input-hash` (`2db0acb`) reconfirmed current against its listed inputs (no VP-affecting change this burst).
7. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, per standing instruction carried across every prior burst.
8. **Convergence-state consequence:** the 3-consecutive-clean adversarial streak is now **RE-ESTABLISHED at 3/3** on the fully-corrected delta, AND independently re-confirmed corpus-consistent by the second consistency-validator audit's CONSISTENT verdict (zero new findings). **F2 spec evolution is now formally CONVERGED + CONSISTENT — AWAITING HUMAN GATE.** The one carried-forward, non-blocking LOW (a bc-6 BC-6.2.016 cross-reference blocked by the pre-existing, cycle-004-unrelated TD-031 stable-anchor-hygiene hook violation, first recorded at Burst 9) remains open as a recorded maintenance item and is NOT a gate condition.
9. Updated STATE.md via one full-content Write (v3.61 → v3.62): frontmatter (`current_step`, `cycle_004_status`), Phase Progress F2-SPEC-EVOLUTION row (status advanced to CONVERGED + CONSISTENT, AWAITING HUMAN GATE), Current Phase Steps table (Passes 20-25 + the second re-audit marked DONE, checkpoint #7 recorded, F2 human gate marked as the immediate next step, F3 incremental stories marked PENDING), Convergence Status / Concurrent Cycles / Constraints Carried Forward / Drift-Standing prose (trajectory extended through the second re-audit, clean-streak explicitly 3/3 RE-ESTABLISHED and consistency-confirmed, the LOW TD-031-blocked cross-ref still carried forward, prior Burst-9 full narrative paragraphs compacted to brief "historical" one-liners per the established per-burst compaction pattern), and Session Resume Checkpoint (recording NEXT-on-resume as awaiting/recording the F2 human-gate decision, and — on approval — dispatching `/vsdd-factory:phase-f3-incremental-stories`). No new DEC recorded — DEC-335 (the F1 human gate) remains the latest Decisions Log entry; the F2 human-gate decision, once made, will be the next DEC, deliberately not pre-recorded here.
10. Appended this burst-log entry (Burst 10).

**Adversary verdict:** Passes 20, 21, and 22 each returned a single small finding (a BC-INDEX propagation gap, a stale Trace-provenance sentence, and an error-taxonomy precision nit, respectively), all resolved via targeted fix chains with no new spec-content change beyond the correction itself. Passes 23, 24, and 25 each independently returned CLEAN, re-establishing the 3-consecutive-clean convergence bar. The subsequent second pre-gate consistency-validator audit — the standard re-check after any prior DRIFT finding — returned CONSISTENT with zero new findings, explicitly confirming no residual drift survived the Pass 20-22 fix round and no scope creep against the F1-approved 4-story scope. **Net convergence verdict: F2 IS NOW CONVERGED AND CONSISTENT.**

**Outcome:** cycle-004 (`windows-correctness`) Phase F2 (spec evolution) is now **CONVERGED + CONSISTENT, AWAITING HUMAN GATE.** `total_bcs` unchanged at 742 this burst; `vp_count` unchanged at 55 (Passes 20-22 were BC-INDEX/Trace/error-taxonomy body-text-only fixes — no BC or VP added, removed, or renumbered). Adversarial finding trajectory, full run: 17→9→5→4→4→4→[sweep 3]→3→3→1→1→2→1→CLEAN→1→2→1→CLEAN→CLEAN→CLEAN→[gate-audit DRIFT 1H/1M/1L, reconciled]→1→1→1→CLEAN→CLEAN→CLEAN→[gate consistency re-audit: CONSISTENT]. Clean-streak **3/3 — RE-ESTABLISHED and consistency-confirmed.** **HUMAN CONVERGENCE DIRECTIVE (recorded, no DEC):** "continue to full 3-consecutive-clean-pass convergence, re-confirmed by a consistency-validator audit with no DRIFT" — now **SATISFIED.** **LOW carried forward (not a blocker):** the Burst-9 TD-031-blocked bc-6 BC-6.2.016 cross-reference remains open, non-blocking. **NEXT:** present the F2 human gate with the full 25-pass convergence history and both consistency-validator audits as evidence; on approval, dispatch `/vsdd-factory:phase-f3-incremental-stories`.

**Codifications:** none this burst — no new DEC; DEC-335 (F1 human gate) remains the latest recorded decision. The Pass 20/21/22 fix-round outputs (`BC-INDEX.md` propagation fix, `bc-1-auth-identity.md` Trace-provenance correction, `error-taxonomy.md` invoke/render/swallow precision fix) are the codified F2 spec-evolution convergence output this burst. The re-established 3-consecutive-clean streak and the CONSISTENT second audit are the codified convergence-state output — F2 is now ready for its human gate.

**Closes:** the Burst-9 gate-audit's residual propagation gap (the `BC-INDEX.md` staleness Pass 20 caught); the Pass-21 Trace-provenance staleness; the Pass-22 error-taxonomy precision nit; the 0/3 clean-streak reset from Burst 9 (re-established at 3/3); the requirement for a second, DRIFT-free consistency-validator audit before the F2 human gate. **Does NOT close:** F2 itself in the sense of advancing past the human gate — that decision is pending and is this checkpoint's own presentation; the LOW TD-031-blocked bc-6 cross-reference remains open as a recorded, non-blocking maintenance item; no cycle-001/002/003 standing Drift/Standing items are touched.

### Counts reconciled this burst

BCs: unchanged at **742** (Passes 20-22 amended existing `BC-INDEX.md`/BC-body/error-taxonomy text only; no BC added, removed, or renumbered). VPs: unchanged at **55** (no VP-affecting change in Passes 20-25). Holdout scenarios unchanged at 106. `total_stories` unchanged at 168 (F2 does not create stories). Reserved Windows device-name set unchanged at 30 (ADR-0021 §9, untouched this burst).

### Details

| Agent | Task | Output |
|-------|------|--------|
| adversary (Pass 20, fresh context) | Scoped adversarial review, round 20, on the Burst-9-corrected delta | 1 finding — `BC-INDEX.md` propagation miss |
| product-owner (Pass 20 fix round) | Resolve Pass 20 finding | `BC-INDEX.md`'s BC-1.4.040 row updated: defense-in-depth classification + bc-6 cross-refs |
| adversary (Pass 21, fresh context) | Scoped adversarial review, round 21 | 1 finding — stale Trace-provenance sentence in `bc-1-auth-identity.md` |
| product-owner (Pass 21 fix round) | Resolve Pass 21 finding | Trace field corrected to reference current defense-in-depth rationale + bc-6 Related BCs |
| adversary (Pass 22, fresh context) | Scoped adversarial review, round 22 | 1 finding — `error-taxonomy.md` invoke/render/swallow precision nit on `ProfilePathEscape` |
| formal-verifier (Pass 22 fix round) | Resolve Pass 22 finding | Invoke/render/swallow columns corrected for the `ProfilePathEscape` row |
| adversary (Pass 23, fresh context) | Scoped adversarial review, round 23 | CLEAN — zero findings |
| adversary (Pass 24, fresh context) | Scoped adversarial review, round 24 | CLEAN — zero findings |
| adversary (Pass 25, fresh context) | Scoped adversarial review, round 25 | CLEAN — zero findings; 3rd consecutive clean pass — RE-ESTABLISHES 3-consecutive-clean convergence |
| consistency-validator (second pre-gate audit, fresh context) | Corpus-wide cross-document consistency re-audit ahead of F2 human gate | CONSISTENT — zero new findings |
| state-manager | Verify accumulated work is internally consistent; commit it in one atomic commit; correct STATE.md; append this burst-log entry | This commit; `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry) |

**Files touched (Dim-1): 5 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- specs/prd/BC-INDEX.md (modified)
- specs/prd/bc-1-auth-identity.md (modified)
- specs/prd/error-taxonomy.md (modified)

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` (8 bc files, exit 0) and `scripts/check-bc-cumulative-counts.sh` (742 total across 9 files, exit 0) both PASS — re-verified before this burst, recorded here per Defensive Sweep Discipline (S-7.02); `vp-delta.md`'s `input-hash` (`2db0acb`) confirmed current against its listed inputs (no VP-affecting change this burst); `ADR-0021`/`ADR-0022`/`architecture-delta.md`/`vp-delta.md` all confirmed unmodified since Burst 9 via `git status` and correctly excluded from this commit; the second consistency-validator audit's CONSISTENT verdict is itself the corpus-wide defensive sweep for this burst's propagation-completeness question, recorded here per Defensive Sweep Discipline.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` spec-delta convergence only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 11 — F2 HUMAN GATE APPROVED (DEC-336) — phase advanced F2 → F3, F3 incremental story decomposition DISPATCHED (2026-09-04)

**Parent-commit:** Burst 10's commit (`develop` tip `42e92b46`, unchanged this burst — no `develop`-side commit).

**Trigger:** Burst 10 left F2 spec evolution formally CONVERGED + CONSISTENT, AWAITING HUMAN GATE — 25 fresh-context adversarial passes across two attempts, each independently reaching a 3-consecutive-clean streak (Passes 17-19, then 23-25), and a second consistency-validator audit returning CONSISTENT (zero new findings). This burst presents that evidence at the F2 human gate and records the operator's decision.

**Work performed this burst, in order:**

1. **F2 human gate presented:** the full F2 convergence evidence — two 3-consecutive-clean adversarial runs (Passes 17-19, then 23-25 after the Burst-9 gate-audit reconciliation) and two consistency-validator audits (first found DRIFT 1H/1M/1L, reconciled; second returned CONSISTENT, zero new findings) — was presented to the human operator for approval.
2. **Human APPROVED** the F2 spec delta at the gate, advancing the cycle to F3 (incremental story decomposition), with three explicit confirmations: (a) the 4-story DEC-335 scope (`dpapi-storage-fix` + `honest-fail-message` bundled, `windows-docs`, `cloud_id-correctness`) is correctly covered with no gap/creep, per the 2nd consistency audit; (b) keeping the path-traversal guard + clear-path adapter (BC-1.4.040 / `clear_dpapi_file_tolerating_path_escape`) as DEFENSE-IN-DEPTH — not removing them — is the desired call; (c) the classic-vs-scoped-token Assets honesty caveat in ADR-0022 (documenting that `cloud_id` acquisition may not enable Assets for `jr`'s classic tokens) is acceptable as written.
3. **DEC-336 recorded** in the Decisions Log — collision check performed first: DEC-335 was the prior highest allocated ID, so DEC-336 is collision-free. DEC-336 codifies the approval decision and its three confirmations verbatim.
4. **Phase frontmatter advanced F2 → F3.** `cycle_004_status` and `current_step` updated to reflect F2 CLOSED/APPROVED and F3 IN PROGRESS.
5. **`/vsdd-factory:phase-f3-incremental-stories` DISPATCHED** — tasking story-writer with decomposing the human-approved 4-story scope into implementable story files and integrating them into the existing dependency graph without introducing cycles.
6. Updated STATE.md via one full-content Write (v3.62 → v3.63): frontmatter (`phase` F2→F3, `cycle_004_status`, `current_step`), Decisions Log (new DEC-336 as the top row), Phase Progress table (F2-SPEC-EVOLUTION row → APPROVED; new F3-INCREMENTAL-STORIES row → IN PROGRESS), Current Phase Steps (reset for F3: F2 human gate marked DONE—APPROVED, story-decomposition dispatch IN PROGRESS, review + human gate PENDING; prior F2 steps archived into the Burst-1-through-10 rollup line), Convergence Status / Concurrent Cycles / Constraints Carried Forward / Drift-Standing prose (F2's verbose re-convergence narrative compacted to a brief historical summary now that the phase is closed, F3 status added), and Session Resume Checkpoint (Position = cycle-004 F3 IN PROGRESS; NEXT-on-resume = await story-writer output → consistency-validator + adversarial story review → F3 human gate → F4).
7. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, per standing instruction carried across every prior burst.
8. Committed ONLY `STATE.md` and this burst-log entry to factory-artifacts in one atomic commit — no spec files changed this burst (F2's content was already fully committed at Burst 10; this burst is a human-gate decision plus a phase transition only).
9. Appended this burst-log entry (Burst 11).

**Adversary verdict:** N/A this burst — no adversarial pass was dispatched; this burst is a human-gate decision and phase transition, not a spec-content-producing or review burst.

**Outcome:** cycle-004 (`windows-correctness`) Phase F2 (spec evolution) is now **CLOSED and APPROVED at its human gate (DEC-336)**. Phase **F3 (incremental story decomposition) is now IN PROGRESS** — story-writer dispatched. `total_bcs` unchanged at 742; `vp_count` unchanged at 55; holdout scenarios unchanged at 106; `total_stories` unchanged at 168 this burst (F3 will add new story files once story-writer's output is integrated). **NEXT:** story-writer produces the 4-story decomposition + dependency-graph integration → consistency-validator + adversarial story review → F3 story-decomposition human gate → F4 delta implementation.

**Codifications:** **DEC-336** — the F2 human-gate approval decision, recorded with its three explicit confirmations (4-story scope coverage, defense-in-depth guard framing, classic-vs-scoped-token Assets caveat acceptability). This is the first new DEC since DEC-335 (F1 human gate).

**Closes:** the F2 human gate (the final open item from Burst 10's CONVERGED + CONSISTENT, AWAITING HUMAN GATE status); the F2 spec-evolution phase for cycle-004 in its entirety (architect + product-owner + formal-verifier deliverables, 25-pass adversarial convergence, two consistency-validator audits, and now the human approval). **Does NOT close:** cycle-004 itself — F3 through F7 remain ahead; the LOW TD-031-blocked bc-6 BC-6.2.016 cross-reference remains open as a recorded, non-blocking maintenance item; no cycle-001/002/003 standing Drift/Standing items are touched.

### Counts reconciled this burst

BCs: unchanged at **742**. VPs: unchanged at **55**. Holdout scenarios unchanged at 106. `total_stories` unchanged at 168 (F3 will add new story files once story-writer's output is integrated — no story files were produced yet as of this burst). Reserved Windows device-name set unchanged at 30 (ADR-0021 §9, untouched this burst).

### Details

| Agent | Task | Output |
|-------|------|--------|
| orchestrator | Present the F2 human gate with the full 25-pass convergence history + both consistency-validator audits as evidence | Human APPROVED, with three explicit confirmations (scope coverage, defense-in-depth framing, Assets caveat acceptability) |
| human | F2 human-gate decision | APPROVED — advance to F3 |
| orchestrator | Dispatch F3 | `/vsdd-factory:phase-f3-incremental-stories` dispatched to story-writer |
| state-manager | Record DEC-336 (collision-checked against DEC-335); advance phase frontmatter F2→F3; commit STATE.md + this burst-log entry in one atomic commit | This commit; `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry) |

**Files touched (Dim-1): 2 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md

**Dim-2 Attestation:** No spec files changed this burst (human-gate decision + phase transition only) — `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` were not re-run since no BC/VP/index content was touched; both remained exit-0 as of Burst 10's re-verification. DEC-namespace collision check performed and confirmed clean: DEC-335 was the prior highest allocated ID, DEC-336 is collision-free.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` human-gate bookkeeping only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 12 — F3 incremental story decomposition CONVERGED (4 review rounds) — AWAITING HUMAN GATE (2026-09-04)

**Parent-commit:** Burst 11's commit (`develop` tip `42e92b46`, unchanged this burst — no `develop`-side commit).

**Trigger:** Burst 11 dispatched `/vsdd-factory:phase-f3-incremental-stories`, tasking story-writer with decomposing the human-approved 4-story DEC-335 scope into implementable story files and integrating them into the existing dependency graph. This burst banks story-writer's completed output plus 4 rounds of consistency/adversarial story review, and records F3 decomposition as CONVERGED, awaiting the human gate.

**Work performed this burst, in order:**

1. **story-writer produced the 4-story F3 decomposition** in `cycles/cycle-004/phase-f3-stories/`:
   - `S-cycle4-dpapi-storage-fix` — 13pt, P0, Wave 1, 20 ACs (#759 DPAPI-encrypted fallback storage).
   - `S-cycle4-cloud-id-correctness` — 8pt, P1, Wave 1, 9 ACs (`cloud_id` acquisition/correctness, closes `A-PA-LOW-001`).
   - `S-cycle4-honest-fail-message` — 5pt, P0, Wave 2, `depends_on` `dpapi-storage-fix`, 7 ACs.
   - `S-cycle4-windows-docs` — 3pt, doc-only, Wave 2, 5 ACs.
   Plus supporting artifacts: `decomposition-manifest.md`, `dependency-graph-extended.md`, `wave-schedule.md`, `conflict-report.md`, and `wave-holdout-scenarios/wave-{1,2}-holdout-scenarios.md`.
2. **Scope check:** 41 ACs total (36 BC-traced + 5 doc-only), all traced to the F2 BCs/VPs; dependency graph is acyclic — 2 independent 2-node chains; Wave 1 = {`dpapi-storage-fix`, `cloud-id-correctness`}, Wave 2 = {`honest-fail-message`, `windows-docs`}; all 10 new/amended F2 BCs and all 14 new F2 VPs are each covered by exactly one story (no gap, no double-coverage); scope matches DEC-335's 4 stories exactly (no gap/creep); all 4 story files are template-compliant (closing the cycle-003 4-story template-compliance gap precedent — see Drift/Standing below).
3. **4 rounds of fresh-context consistency/adversarial story review** ran against the decomposition: Round 1 (6 findings, all fixed), Round 2 (4 findings, all fixed), Round 3 (3 findings, all fixed), Round 4 **CLEAN** — novelty NONE, and both anti-pattern classes flagged in earlier rounds (footprint-omission; completeness-claim/annotation mismatch) independently confirmed CLOSED. F3 decomposition review has CONVERGED.
4. **Tracked items carried into F4+** (recorded in Drift/Standing, not blockers):
   - (a) BC-1.4.035 PC5 production-path VP gap — no F2 VP covers the `store_pair`-failure→`DpapiFallbackFailed` production path; AC-covered by `S-cycle4-dpapi-storage-fix` AC-019 (plus AC-020 for BC-1.4.037 Invariant 3, a manifest-assertion with no VP). Formal VP deferred to F6 hardening or a future maintenance touch — F2 is gated/frozen and is not being reopened for one additive VP. Non-blocking.
   - (b) `S-410-keychain-test-isolation` (status: ready, backlog/wave: feature-followup) has a same-file overlap with cycle-004 on `tests/oauth_refresh_integration.rs` — non-blocking (backlog-unscheduled, no active-wave race); flagged for whoever delivers S-410 first.
   - (c) `CHANGELOG.md [Unreleased]` is a same-wave parallel-edit hotspot across all 4 stories — F4 append-collision mitigation (each story appends its own distinct bullet; keep-both resolution) documented in `wave-schedule.md` §7a.
5. Updated STATE.md via one full-content Write (v3.63 → v3.64): frontmatter (`current_step`, `cycle_004_status`; `phase` stays F3), Phase Progress table (F3-INCREMENTAL-STORIES row → CONVERGED, AWAITING HUMAN GATE, with the 4-story summary + review trajectory `6→4→3→CLEAN`), Current Phase Steps (F3 decomposition + review rows marked DONE, F3 human gate PENDING), Convergence Status / Concurrent Cycles / Constraints Carried Forward / Drift-Standing prose (F3 decomposition output + convergence + tracked items (a)/(b)/(c) added), and Session Resume Checkpoint (Position = cycle-004 F3 CONVERGED AWAITING HUMAN GATE; NEXT-on-resume = await/record the F3 human gate decision). **No new DEC recorded this burst** — the F3 gate decision will be the next DEC (DEC-337), not pre-recorded here.
6. **Did NOT register `STORY-INDEX.md`** this burst — deferred to post-gate, per instruction. Story count remains `168` in frontmatter/body this burst; the pending 168→172 bump is noted as PENDING, not applied.
7. Did NOT touch the F2 spec files (`architecture-delta.md`, `vp-delta.md`, ADR-0021/0022, PRD delta) — F2 is closed and frozen.
8. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, per standing instruction carried across every prior burst.
9. Committed the 4 F3 story files + `decomposition-manifest.md` + `dependency-graph-extended.md` + `wave-schedule.md` + `conflict-report.md` + `wave-holdout-scenarios/*` + `STATE.md` + this burst-log entry to factory-artifacts in one atomic commit.
10. Appended this burst-log entry (Burst 12).

**Adversary verdict:** CLEAN (Round 4) — novelty NONE after 3 prior rounds of real findings (6→4→3), both anti-pattern classes (footprint-omission; completeness-claim/annotation mismatch) confirmed closed. F3 decomposition review CONVERGED.

**Outcome:** cycle-004 (`windows-correctness`) Phase F3 (incremental story decomposition) is now **CONVERGED, AWAITING HUMAN GATE**. `total_bcs` unchanged at 742; `vp_count` unchanged at 55; holdout scenarios unchanged at 106; `total_stories` unchanged at 168 this burst (168→172 registration deferred to post-gate). **NEXT:** present the F3 story-decomposition human gate. On approval, register the 4 stories in `STORY-INDEX.md` (168→172) and advance F3→F4 (delta implementation, Wave 1 first).

**Codifications:** none this burst — no new DEC recorded (the F3 gate decision will be DEC-337, recorded when the human decides).

**Closes:** the F3 story-decomposition + review cycle (story-writer's output, 4 rounds of consistency/adversarial review reaching CLEAN). **Does NOT close:** the F3 human gate itself (pending); `STORY-INDEX.md` registration (deferred to post-gate); cycle-004 as a whole — F4 through F7 remain ahead; the LOW TD-031-blocked bc-6 BC-6.2.016 cross-reference and the BC-1.4.035 PC5 production-path VP gap both remain open as recorded, non-blocking maintenance items; no cycle-001/002/003 standing Drift/Standing items are touched.

### Counts reconciled this burst

BCs: unchanged at **742**. VPs: unchanged at **55**. Holdout scenarios: unchanged at 106 (F3 added `wave-{1,2}-holdout-scenarios.md` as wave-scoped WHS content, not yet folded into the cumulative `holdout-scenarios.md` count — folding happens at `STORY-INDEX.md` registration, post-gate). `total_stories` unchanged at **168** this burst — the 4 new F3 stories (`S-cycle4-dpapi-storage-fix`, `S-cycle4-cloud-id-correctness`, `S-cycle4-honest-fail-message`, `S-cycle4-windows-docs`) exist as files in `cycles/cycle-004/phase-f3-stories/` but are **not yet registered** in `STORY-INDEX.md` — that registration (168→172) is explicitly deferred to after the F3 human gate approves. Reserved Windows device-name set unchanged at 30 (ADR-0021 §9, untouched this burst).

### Details

| Agent | Task | Output |
|-------|------|--------|
| story-writer | Decompose the DEC-335 4-story scope into implementable story files + dependency-graph integration | 4 story files, `decomposition-manifest.md`, `dependency-graph-extended.md`, `wave-schedule.md`, `conflict-report.md`, `wave-holdout-scenarios/wave-{1,2}-holdout-scenarios.md` |
| consistency-validator + adversary (4 rounds) | Review the F3 decomposition for gaps, contradictions, footprint-omission, completeness-claim mismatches | Round 1: 6 findings fixed; Round 2: 4 findings fixed; Round 3: 3 findings fixed; Round 4: CLEAN |
| state-manager | Bank F3 artifacts + STATE.md update + burst-log entry in one atomic commit; explicitly defer `STORY-INDEX.md` registration | This commit; `STATE.md`; `cycles/cycle-004/burst-log.md` (this entry) |

**Files touched (Dim-1): 11 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/phase-f3-stories/S-cycle4-dpapi-storage-fix.md
- cycles/cycle-004/phase-f3-stories/S-cycle4-cloud-id-correctness.md
- cycles/cycle-004/phase-f3-stories/S-cycle4-honest-fail-message.md
- cycles/cycle-004/phase-f3-stories/S-cycle4-windows-docs.md
- cycles/cycle-004/phase-f3-stories/decomposition-manifest.md
- cycles/cycle-004/phase-f3-stories/dependency-graph-extended.md
- cycles/cycle-004/phase-f3-stories/wave-schedule.md
- cycles/cycle-004/phase-f3-stories/conflict-report.md
- cycles/cycle-004/phase-f3-stories/wave-holdout-scenarios/ (2 files: wave-1-holdout-scenarios.md, wave-2-holdout-scenarios.md)

**Dim-2 Attestation:** `STORY-INDEX.md` was deliberately NOT touched this burst (registration deferred to post-gate, per instruction) — `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` were not re-run since no BC/VP/index content changed this burst; both remained exit-0 as of Burst 10's re-verification. DEC-namespace collision check: N/A, no new DEC recorded this burst.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` F3 decomposition bookkeeping only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 13 — SESSION WRAP (human-requested pause) — pipeline PAUSED at F3 human gate (2026-09-04)

**Parent-commit:** Burst 12's commit (`965178df`, `develop` tip `42e92b46` unchanged this burst — no `develop`-side commit).

**Trigger:** Human requested `/wrap` mid-session with no cycle-004 pipeline work in flight (no running sub-agents, no stories mid-TDD, no open cycle-004 PRs, no `.worktrees/`). This burst pauses the pipeline and re-checkpoints STATE.md so the session can be cleared with zero loss; it does not advance, approve, or alter the F3 story-decomposition gate itself.

**Work performed this burst, in order:**

1. **Frontmatter:** `pipeline: ACTIVE` → `pipeline: PAUSED`; `timestamp` refreshed to `2026-09-04T20:45:00Z`. `phase` stays `F3` — no phase transition occurred, only a pause.
2. **Current Phase Steps:** appended a new row — "SESSION WRAP (human-requested pause) — pipeline PAUSED at F3 story-decomposition gate; no work in flight." The F3 story-decomposition human gate row remains **PENDING**, unchanged.
3. **Session Resume Checkpoint replaced** (v3.64 → v3.65 position): the prior checkpoint (recorded at Burst 12, F3 CONVERGED AWAITING HUMAN GATE) is archived verbatim to `cycles/cycle-004/session-checkpoints.md` (new file, created this burst). The new checkpoint captures: cycle-004 position unchanged in substance (Phase F3 decomposition CONVERGED, AWAITING HUMAN GATE) but the pipeline itself is now PAUSED by explicit human action; zero in-flight work; the pending F3 gate decision and its four options (approve/investigate/reopen-F2/reject); the three tracked items carried into F4+ (BC-1.4.035 PC5 VP gap, S-410 file overlap, CHANGELOG.md parallel-edit hotspot); `STORY-INDEX.md` registration (168→172) still deferred to post-gate; an out-of-band SESSION NOTE recording the investigation and closure of a live OAuth report (root-caused to a local `cargo install` build lacking ADR-0006 embedded credentials, not a release/code/pipeline defect — no repo/spec/story change resulted); and the exact resume command.
4. **No new DEC recorded.** The F3 gate decision remains reserved as DEC-337, unchanged from Burst 12.
5. Version bumped 3.64 → 3.65.
6. Updated STATE.md via one full-content Write (DEC-247 discipline; no Edit chain, no `cp`).
7. Did NOT touch `STORY-INDEX.md` or any F2/F3 spec/story content — this burst is bookkeeping-only.
8. Did NOT stage the three pre-existing unrelated dirty files (`regression-state.json`, `sidecar-learning.md`, the modified `S-cycle3-env-tag` demo gif) — left untouched, consistent with every prior burst.
9. Committed STATE.md + this burst-log entry + the new `cycles/cycle-004/session-checkpoints.md` to factory-artifacts in one atomic commit.
10. **Factory lock:** no `factory_lock` frontmatter block exists in STATE.md and the lock-write/verify-sha-currency scripts are not provisioned in this repo (`plugins/vsdd-factory/bin/factory-lock-write.sh` and `.factory/hooks/verify-sha-currency.sh` both absent) — no lock is held, so the renew/unlock step is a no-op. Noted, not fabricated.

**Adversary verdict:** N/A — no spec/story content reviewed this burst; this is a pause-and-checkpoint bookkeeping burst, not a convergence pass.

**Outcome:** cycle-004 (`windows-correctness`) is now **PAUSED** at Phase F3 (incremental story decomposition), CONVERGED, AWAITING HUMAN GATE — the substantive pipeline position is unchanged from Burst 12; only the `pipeline` frontmatter flag and the Session Resume Checkpoint changed. `total_bcs` unchanged at 742; `vp_count` unchanged at 55; holdout scenarios unchanged at 106; `total_stories` unchanged at 168. **NEXT on resume:** run `/vsdd-factory:next-step`, which reads STATE.md and resumes at the F3 story-decomposition human gate.

**Codifications:** none this burst — no new DEC recorded (DEC-337 remains reserved for the F3 gate decision).

**Closes:** nothing substantive — this burst only pauses and re-checkpoints. **Does NOT close:** the F3 human gate (still pending); `STORY-INDEX.md` registration (still deferred to post-gate); any cycle-001/002/003 standing Drift/Standing items (untouched).

### Counts reconciled this burst

BCs: unchanged at **742**. VPs: unchanged at **55**. Holdout scenarios: unchanged at 106. `total_stories` unchanged at **168** — the 168→172 bump remains deferred to post-gate `STORY-INDEX.md` registration.

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Pause the pipeline and re-checkpoint STATE.md per human `/wrap` request, using the Single-Commit Burst Protocol | Updated `STATE.md` (v3.65, `pipeline: PAUSED`); new `cycles/cycle-004/session-checkpoints.md` (archives the v3.64 checkpoint); this burst-log entry |

**Files touched (Dim-1): 3 unique files (factory-artifacts, this burst)**

- STATE.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/session-checkpoints.md (new file)

**Dim-2 Attestation:** `STORY-INDEX.md` was deliberately NOT touched this burst (no index/BC/VP content changed) — `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` were not re-run since no BC/VP/index content changed this burst. DEC-namespace collision check: N/A, no new DEC recorded this burst.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` pause bookkeeping only, no `develop`-side commit).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 14 — F3 human gate APPROVED (DEC-337) — STORY-INDEX registration (168→172) + BC Story-Anchor backlinks + F3→F4 transition (2026-09-04)

**Parent-commit:** `42e92b46` (`develop` tip; unchanged this burst — no `develop`-side commit; F4 implementation dispatch has not yet started).

**Trigger:** the human APPROVED the F3 incremental story-decomposition gate ("Approve → F4") on 2026-09-04, confirming: (1) scope = exactly DEC-335's 4 stories, nothing added or dropped; (2) release-bundling of #759 items 1+2 via the `depends_on` edge (`honest-fail-message` → `dpapi-storage-fix`) kept as two independently-traceable stories, accepted; (3) two-tier Windows validation accepted (REQUIRED F4 CI spike + REQUIRED F7 manual Windows-11 smoke gate); (4) the three carried-forward non-blockers (BC-1.4.035 PC5 VP gap, S-410 file overlap, CHANGELOG.md parallel-edit hotspot) accepted as deferred. `factory-worktree-health` passed pre-burst (worktree in-sync at factory-artifacts@`7fe31dea`, lock FREE).

**Work performed this burst:**

1. **DEC-337 recorded** in STATE.md's Decisions Log — the F3 gate approval decision, with the human's four confirmations captured in the Decision column.
2. **`STORY-INDEX.md` registration (168→172):** the 4 `S-cycle4-*` stories added to both the Feature Followup status table and the Story Manifest file-path table (frontmatter `total_stories: 168→172`, `version: 1.6.12→1.6.13`); Story Manifest "Total rows" headline corrected to match. All 4 rows recorded `status: draft` (F3-gate-approval-registers, F4-dispatch-flips-to-ready-per-story, same convention as cycle-003).
3. **BC Story Anchor backlinks written** in `bc-1-auth-identity.md` per `decomposition-manifest.md` §9's authoritative mapping: BC-1.2.052/053/054 → `S-cycle4-cloud-id-correctness`; BC-1.4.035/036/037/038/040 → `S-cycle4-dpapi-storage-fix`; BC-1.4.039 → `S-cycle4-honest-fail-message`. **BC-1.4.028 (amended) was SKIPPED** — verified it carries no `Story Anchor` field at all (an older-style BC section predating that convention); per the task's explicit instruction, no field was invented. Only the `Story Anchor` line was touched on each of the 9 BCs edited — no postcondition/invariant/edge-case content was altered (F2 spec remains frozen/gated). `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` both re-run clean after the edits (8/8 files validated; 742 BCs reconciled across 9 files) — the Story Anchor field is outside both scripts' count-surface scope, confirming no incidental count drift.
4. **STATE.md transitioned F3→F4** (v3.65→v3.66): frontmatter `phase: F3→F4`, `pipeline: PAUSED→ACTIVE`; Phase Progress F3 row marked APPROVED (DEC-337); new F4-DELTA-IMPLEMENTATION (cycle-004) row added, IN PROGRESS, Wave 1 = {`S-cycle4-dpapi-storage-fix`, `S-cycle4-cloud-id-correctness`} (parallel, file-disjoint), Wave 2 = {`S-cycle4-honest-fail-message`, `S-cycle4-windows-docs`}; Current Phase Steps replaced with F4 steps, F3 gate marked DONE (APPROVED, DEC-337); Convergence Status/Concurrent Cycles narrative updated to cycle-004 OPEN+ACTIVE at F4 Wave 1, counts 742 BCs/55 VPs/106 holdout/**172 stories**. Superseded v3.65 checkpoint archived verbatim to `cycles/cycle-004/session-checkpoints.md`.

**Adversary verdict:** N/A this burst — no adversarial pass was dispatched; this burst is a human-gate decision, index/backlink registration, and phase transition, not a spec-content-producing or review burst. The F3 story-decomposition review convergence itself (4 rounds, 6→4→3→CLEAN) was already completed and recorded at Burst 12.

**Outcome:** cycle-004 (`windows-correctness`) is now **ACTIVE** at **Phase F4 (delta implementation), Wave 1** — `S-cycle4-dpapi-storage-fix` and `S-cycle4-cloud-id-correctness` are ready for per-story TDD dispatch (file-disjoint, safe to parallelize). `total_stories` is now **172**. `total_bcs`/`vp_count`/holdout scenarios unchanged at 742/55/106.

**Codifications:** **DEC-337** — cycle-004 F3 incremental story decomposition APPROVED at the human gate, advance to F4.

**Closes:** the F3 story-decomposition human gate (was PENDING since Burst 12). **Does NOT close:** F4 itself (Wave 1 dispatch is the next action, not performed this burst); any cycle-001/002/003 standing Drift/Standing items (untouched).

### Counts reconciled this burst

BCs: unchanged at **742**. VPs: unchanged at **55**. Holdout scenarios: unchanged at 106. `total_stories`: **168→172** (4 new `S-cycle4-*` rows registered).

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Record DEC-337; register 4 stories in `STORY-INDEX.md` (168→172); write 9 BC Story-Anchor backlinks in `bc-1-auth-identity.md` (1 skipped, no field present); transition STATE.md F3→F4 (v3.65→v3.66); commit all `.factory/` changes in one atomic burst | Updated `STATE.md` (v3.66, `phase: F4`, `pipeline: ACTIVE`); updated `STORY-INDEX.md` (v1.6.13, 172 stories); updated `bc-1-auth-identity.md` (9 Story Anchor backlinks); updated `cycles/cycle-004/session-checkpoints.md` (archives v3.65); this burst-log entry |

**Files touched (Dim-1): 5 unique files (factory-artifacts, this burst)**

- STATE.md
- .factory/stories/STORY-INDEX.md
- .factory/specs/prd/bc-1-auth-identity.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/session-checkpoints.md

**Dim-2 Attestation:** `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` both re-run after the `bc-1-auth-identity.md` edits and pass clean (8/8 files validated; 742 BCs reconciled across 9 files) — the Story Anchor field edits are outside both scripts' count-surface scope. DEC-namespace collision check: DEC-337 is the next sequential ID after DEC-336, no collision.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst.

**Dim-6 Attestation:** N/A — no source code changed this burst (`.factory/` bookkeeping only, no `develop`-side commit; F4 implementation dispatch has not yet started).

**Dim-7 Attestation:** N/A — no test-affecting change this burst; full regression remains PASS (4763/0/157) as of the cycle-003 F6/F7 hardening/convergence passes, unchanged.

## Burst: Burst 15 — F4 Wave 1 DELIVERED + MERGED (DEC-338) — integration gate PASSED, Wave 2 unblocked (2026-09-05)

**Parent-commit:** `c2074247` (`develop` tip; advanced this burst from `42e92b46` via two squash-merges, PR #768 then PR #769).

**Trigger:** F4 Wave 1 per-story TDD delivery of `S-cycle4-dpapi-storage-fix` and `S-cycle4-cloud-id-correctness` (parallel, file-disjoint, both `depends_on:[]`) ran to completion and merge this burst. Both PRs were squash-merged autonomously per the standing DEC-330/DEC-331 auto-merge policy (CI green + reviewer merge-recommendation + no unaddressed HIGH/MED), with the human's explicit authorization of the push/PR/merge flow this session.

**Work performed this burst:**

1. **`S-cycle4-dpapi-storage-fix` (P0, #759) DELIVERED + MERGED** — PR #768 squash-merged to `develop` @ `9119b291`. 3-clean adversarial convergence; security-reviewer MERGE-CLEAR; pr-reviewer APPROVE; full suite 4839/0/163 + keyring-gated 88/88 green on real macOS keychain. **F4 CI SPIKE SUCCEEDED:** the windows-latest CI leg executed and passed `test_dpapi_protect_unprotect_real_round_trip` + `test_dpapi_protect_flags_never_set_local_machine_bit` — headless GitHub Actions CAN exercise `CryptProtectData` end-to-end; **VP-AUTHDX-010(b) is now CI-verified** (resolves the prior M1/BC-1.4.035-PC5-adjacent Windows-verification residual). The windows-latest run also caught 2 real defects pre-merge (`clippy::unnecessary_mut_passed` + a fixture missing `#[cfg(not(windows))]`), both fixed before merge.
2. **`S-cycle4-cloud-id-correctness` (P1, closes A-PA-LOW-001) DELIVERED + MERGED** — PR #769 squash-merged to `develop` @ `c2074247` (current `develop` tip). Rebased onto #768; keep-both resolution on `CHANGELOG.md` + `CLAUDE.md` (RESOLVES the `CHANGELOG-PARALLEL-EDIT-HOTSPOT` item carried from Burst 12). 3-clean convergence; security-reviewer clear; pr-reviewer APPROVE; full 3-OS CI matrix green on the integrated tree.
3. **`develop` fast-forwarded** `42e92b46` → `c2074247`; both `feat/cycle4-dpapi-storage-fix` and `feat/cycle4-cloud-id-correctness` worktrees + local branches removed post-merge (`.worktrees/` confirmed empty of Wave-1 entries — note: Wave-2 worktrees `feat/cycle4-honest-fail-message`/`feat/cycle4-windows-docs` were observed already pre-provisioned at `develop` tip with zero commits, i.e. scaffolding ahead of dispatch, not in-flight work).
4. **F4 Wave 1 integration gate PASSED** — combined-wave adversary review CLEAN (no CRIT/HIGH/MED emergent integration defects; the two stories are file-disjoint with mutually-exclusive auth branches); regression satisfied by PR #769's 3-OS CI matrix on the integrated tree; demo-of-integration SKIPPED (backend/Windows, justified — Skip Log).
5. **DEC-338 recorded**, **Skip Log** gained "Demo recording (cycle-004, Wave 1)" (backend/Windows justification, consistent with cycle-002/003 precedent), **`STORY-INDEX.md` updated** (v1.6.13→v1.6.14; both Wave-1 rows draft→**done** with PR/merge-SHA citations; both Wave-2 rows draft→**ready**, their `depends_on` edges now satisfied), **`STATE.md` transitioned** (v3.66→v3.67; `activation_head`: `42e92b46`→`c2074247`; phase stays F4, pipeline stays ACTIVE). Carried-forward items updated: BC-1.4.035-PC5-VP-GAP note UPDATED (production round-trip now CI-verified; formal VP still deferred); new LOW item **SEC-WCM-DOC-DPAPI-GAP** recorded (CLAUDE.md's SEC-WCM-DOC note doesn't yet mention the DPAPI-file fallback — candidate for the Wave-2 `windows-docs` story or a future doc touch); `init.rs` double `cloud_id` writer (LOW, benign) and 2 non-blocking pr-review nits each from #768/#769 carried forward; **REQUIRED F7 manual Windows-11 smoke gate** remains outstanding, unaddressed by CI, carried to F7.

**Adversary verdict:** Wave-1 combined-integration review CLEAN (0 CRIT/HIGH/MED). Both stories individually reached 3-clean per-story adversarial convergence during delivery (detail in each story's `code-delivery/S-cycle4-*/pr-review.md`).

**Outcome:** cycle-004 (`windows-correctness`) Phase F4 **Wave 1 COMPLETE** — both stories merged, integration gate PASSED. Wave 2 (`S-cycle4-honest-fail-message` + `S-cycle4-windows-docs`) is now **UNBLOCKED** (both `depends_on` edges satisfied) — dispatch is the next action, not performed this burst. `develop` @ `c2074247`. Counts unchanged: 742 BCs / 55 VPs / 106 holdout / 172 stories (status flips only, no new rows).

**Codifications:** **DEC-338** — cycle-004 F4 Wave-1 delivered + integration gate PASSED; both stories merged; F4 CI spike SUCCEEDED; demo recording SKIPPED for both, justified.

**Closes:** F4 Wave 1 (dispatch → delivery → merge → integration gate, all complete); the `CHANGELOG-PARALLEL-EDIT-HOTSPOT` carried item (resolved via keep-both on PR #769); the REQUIRED F4 CI spike (SUCCEEDED). **Does NOT close:** F4 itself (Wave 2 dispatch is the next action, not performed this burst); the REQUIRED F7 manual Windows-11 smoke gate (occurs at F7, unaffected by CI); any cycle-001/002/003 standing Drift/Standing items (untouched).

### Counts reconciled this burst

BCs: unchanged at **742**. VPs: unchanged at **55**. Holdout scenarios: unchanged at 106. `total_stories`: unchanged at **172** (status flips only — 2× draft→done, 2× draft→ready — no rows added or removed).

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Record DEC-338; flip 4 `S-cycle4-*` story statuses in `STORY-INDEX.md` (no count change); transition STATE.md F4 Wave-1-pending→Wave-1-complete (v3.66→v3.67); record Wave-1 carried-forward item updates (BC-1.4.035-PC5-VP-GAP, new SEC-WCM-DOC-DPAPI-GAP); add Skip Log entry; commit all `.factory/` changes in one atomic burst | Updated `STATE.md` (v3.67, `activation_head: c2074247`); updated `STORY-INDEX.md` (v1.6.14, 2 rows done + 2 rows ready); updated `cycles/cycle-004/session-checkpoints.md` (archives v3.66); this burst-log entry |

**Files touched (Dim-1): 4 unique files (factory-artifacts, this burst)**

- STATE.md
- .factory/stories/STORY-INDEX.md
- cycles/cycle-004/burst-log.md
- cycles/cycle-004/session-checkpoints.md

**Dim-2 Attestation:** No BC/VP/holdout content edited this burst (status-field flips only on `STORY-INDEX.md`, outside `check-spec-counts.sh`/`check-bc-cumulative-counts.sh`'s count-surface scope — both scripts remain clean, no re-run required by their own coverage rules). DEC-namespace collision check: DEC-338 is the next sequential ID after DEC-337, no collision. `validate-count-propagation` hook flagged a naive substring match ("172 stories" vs. legacy "168 stories"/"10 BCs" prose retained in STATE.md's own historical Burst-14 narrative, e.g. the `168→172` delta phrasing) — verified false-positive: `total_stories: 172` and `total_bcs: 742` are the sole current-count frontmatter values in both files and agree; the flagged strings are historical delta prose, not competing current-count claims.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (`.factory/` bookkeeping only; the `develop`-side binary changes were produced and verified by PR #768/#769's own CI runs, external to this burst).

**Dim-6 Attestation:** N/A for this burst's own scope — `.factory/` bookkeeping only. `develop`-side source changes (2 stories, `src/api/auth_windows_store.rs` + `src/api/jira/tenant.rs`) were delivered and merged via PR #768/#769 prior to this burst; this burst records that outcome, it does not itself change source.

**Dim-7 Attestation:** Full regression PASS 4839/0/163 (keyring-gated 88/88 additionally green on real macOS keychain) as of PR #768's merge; PR #769's 3-OS CI matrix green on the integrated tree at `c2074247` — both superseding the prior cycle-003 baseline (4763/0/157).

## Burst: Burst 16 — F4 Wave 2 PARTIAL DELIVERY (windows-docs merged, honest-fail-message PR open+converged) — SESSION WRAP, reviews halted (2026-09-05)

**Parent-commit:** `abb283e8` (`develop` tip; advanced this burst from `c2074247` via one squash-merge, PR #770). PR #771 (`feat/cycle4-honest-fail-message`, head `b2a0c5d707a9daa8543f32acba6e718bcec77907`) remains OPEN against `abb283e8`, not merged.

**Trigger:** F4 Wave 2 per-story TDD delivery of `S-cycle4-honest-fail-message` and `S-cycle4-windows-docs` (both unblocked at the end of Burst 15) proceeded this burst. `S-cycle4-windows-docs` ran to completion and merge. `S-cycle4-honest-fail-message` reached adversarial convergence (3 clean passes, including a DEC-334 correction to its own F1 revoke-advice framing) and its PR (#771) was opened, but the human called `/wrap` while pr-reviewer and security-reviewer were still in progress on it — both were halted mid-review rather than force-completed.

**Work performed this burst:**

1. **`S-cycle4-windows-docs` (#760, doc-only) DELIVERED + MERGED** — PR #770 squash-merged to `develop` @ `abb283e8` (current `develop` tip). Consistency-validated CONSISTENT; pr-reviewer APPROVE. Also corrected the SEC-WCM-DOC CLAUDE.md note to mention the DPAPI fallback (closes the `SEC-WCM-DOC-DPAPI-GAP` LOW item carried from Burst 15).
2. **`S-cycle4-honest-fail-message` (P0, #759 backstop) CONVERGED, PR OPEN, NOT MERGED** — 3 clean adversarial passes on `feat/cycle4-honest-fail-message` (rebased onto `abb283e8`, keep-both `CHANGELOG.md` resolution). **F1 correction recorded as a DEC-334 amendment (not a fresh DEC, since it corrects DEC-334's own bundled scope, not a new gate decision):** adversarial review found CONFIRMED-harmful advice in BC-1.4.039's honest-fail message — the Site-1 text instructed users to revoke `jr`'s OAuth grant at manage-profile/apps, framed as safe cleanup ("no other consumer"). Perplexity-validated research (`research/atlassian-3lo-revoke-granularity-2026-09-05.md`, CONFIRMED against Atlassian primary docs) established that revoke is ACCOUNT-WIDE — it signs out every `jr` profile authenticated under that Atlassian account, not just the one profile that hit the store failure. Fixed: BC-1.4.039 + ADR-0021 §6 amended to a scoped-cleanup-default (`jr auth logout --profile`/`jr auth remove`) with the account-wide revoke demoted to an explicitly-warned OPTIONAL step; story ACs AC-002/AC-004 amended to match; a source-scan regression guard (`test_no_account_wide_harmful_revoke_framing_in_auth_source`) added to `src/api/auth.rs` so the harmful framing cannot silently regress. PR #771 opened; pr-reviewer-771-cycle1 and security-reviewer-771 both dispatched and made partial progress (a review write-up already exists at `code-delivery/S-cycle4-honest-fail-message/pr-review.md`), but **HALTED, not concluded**, when the human called `/wrap` — the recorded verdict there is provisional, not a completed gate; both must be RE-DISPATCHED fresh on resume before merge.
3. **SESSION WRAP invoked by the human.** Pipeline transitions ACTIVE → **PAUSED**. `develop` remains at `abb283e8`; local `develop` is behind at `c2074247` (not fast-forwarded this burst — noted, not a durability concern since `origin/develop` @ `abb283e8` is authoritative).
4. **`STORY-INDEX.md` reconciled** (v1.6.14, no new rows, no count change — status-field flips only): `S-cycle4-windows-docs` draft/ready → **done** (PR #770 @ `abb283e8`); `S-cycle4-honest-fail-message` draft/ready → **in-review** (PR #771 @ `b2a0c5d7`, open). The uncommitted status-table edits found at wrap time (which had stopped at a "both Wave-2 stories ready" snapshot, itself already stale — anticipating a Wave-1-only checkpoint that never became live) are corrected to this true state in the same pass.
5. **`sprint-state.yaml` reconciled**: `wave_2_status` updated to reflect the split outcome (windows-docs complete, honest-fail-message in-review, reviews halted); a `wave_2:` block with both stories' full detail was ADDED (the pre-wrap uncommitted edit had a `wave_2_status` placeholder but no `wave_2.stories` block at all).
6. **Input-hash bookkeeping**: `compute-input-hash --update` re-run for `S-cycle4-honest-fail-message.md` (content changed by the F1 AC amendment) and every cycle-004 artifact whose `inputs:` frontmatter cites the amended `bc-1-auth-identity.md` — `vp-delta.md`, `decomposition-manifest.md`, `delta-analysis.md`, `S-cycle4-dpapi-storage-fix.md`, `S-cycle4-cloud-id-correctness.md` — closing the drift the pre-existing dispatcher hook flagged for those six files. `dependency-graph-extended.md` (which cites the story file, not `bc-1` directly) was left as-is — out of this burst's narrow declared scope, and already tracked under the standing `F7-GATE-SYSTEMIC-INPUT-HASH-DRIFT-BOOKKEEPING` debt.
7. **`STATE.md` transitioned** (v3.66 → v3.68 — see note below on the version jump) — `pipeline: ACTIVE → PAUSED`; Phase Progress F4 row updated with the full Wave-1 + Wave-2-partial delta; new Session Resume Checkpoint (v3.68) written; the v3.66 checkpoint's forward "superseded" reference (already archived to `session-checkpoints.md` ahead of this burst) corrected to describe the true wrap outcome rather than the narrower Wave-1-only state it originally anticipated.

**Note on the STATE.md version jump (v3.66 → v3.68, skipping v3.67):** Burst 15's narrative (above) described a `v3.66→v3.67` STATE.md transition as part of Wave-1 completion, but that write was never actually committed to the live file — the STATE.md found on disk at the start of this burst was still, verbatim, the v3.66 content (Phase F4, Wave 1 dispatch PENDING), i.e. STATE.md had fallen behind both Burst 15's Wave-1 delivery and this burst's Wave-2 partial delivery. Rather than fabricate a v3.67 intermediate that was never live, this burst performs the one real, atomic v3.66→v3.68 jump per DEC-247 (ONE full-content Write), folding in the full Wave-1 + Wave-2-partial delta in a single step. No pipeline decision or artifact content was lost in the gap — Burst 15's narrative and `STORY-INDEX.md`/`sprint-state.yaml`'s Wave-1 detail were already accurate and are preserved verbatim by this reconciliation.

**Outcome:** cycle-004 (`windows-correctness`) Phase F4 is **Wave 1 COMPLETE, Wave 2 PARTIALLY COMPLETE** (`S-cycle4-windows-docs` merged; `S-cycle4-honest-fail-message` converged but unmerged, PR #771 open). Pipeline **PAUSED** (human `/wrap`). `develop` (origin) @ `abb283e8`. Counts unchanged: 742 BCs (BC-1.4.039 amended, not added) / 55 VPs / 106 holdout / 172 stories.

**Codifications:** No new DEC this burst — the F1 revoke-advice correction is recorded as an amendment note under DEC-334 (it corrects that decision's bundled scope's downstream messaging, not a fresh gate decision), and the SESSION WRAP itself is a pipeline-state transition, not a decision requiring its own DEC ID (consistent with Burst 13's precedent).

**Closes:** `SEC-WCM-DOC-DPAPI-GAP` (via PR #770). **Does NOT close:** F4 Wave 2 (PR #771 review must be re-dispatched and concluded, then merged, then the Wave 2 integration gate run); F4 itself; the REQUIRED F7 manual Windows-11 smoke gate (occurs at F7); any cycle-001/002/003 standing Drift/Standing items (untouched).

### Counts reconciled this burst

BCs: unchanged at **742** (BC-1.4.039 amended in place, not a new BC). VPs: unchanged at **55**. Holdout scenarios: unchanged at 106. `total_stories`: unchanged at **172** (status flips only).

### Details

| Agent | Task | Output |
|-------|------|--------|
| state-manager | Reconcile `STORY-INDEX.md` + `sprint-state.yaml` to the true Wave-1/Wave-2 state; re-run `compute-input-hash --update` on the 6 drifted cycle-004 artifacts citing the amended `bc-1-auth-identity.md`; transition STATE.md ACTIVE→PAUSED with a fresh Session Resume Checkpoint (v3.66→v3.68); commit all pending cycle-004 `.factory/` artifacts in one atomic burst | Updated `STATE.md` (v3.68, `pipeline: PAUSED`); updated `STORY-INDEX.md` (2 rows flipped: windows-docs→done, honest-fail-message→in-review); updated `sprint-state.yaml` (wave_2 block added); updated `vp-delta.md`, `decomposition-manifest.md`, `delta-analysis.md`, `S-cycle4-dpapi-storage-fix.md`, `S-cycle4-cloud-id-correctness.md`, `S-cycle4-honest-fail-message.md` (input-hash only); updated `cycles/cycle-004/session-checkpoints.md` (corrected the v3.66 forward-reference); this burst-log entry |

**Files touched (Dim-1): 13 unique files (factory-artifacts, this burst)**

- STATE.md
- .factory/stories/STORY-INDEX.md
- .factory/sprint-state.yaml
- .factory/cycles/cycle-004/burst-log.md
- .factory/cycles/cycle-004/session-checkpoints.md
- .factory/cycles/cycle-004/phase-f2-spec-evolution/vp-delta.md
- .factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md
- .factory/cycles/cycle-004/phase-f1-delta-analysis/delta-analysis.md
- .factory/cycles/cycle-004/phase-f3-stories/S-cycle4-dpapi-storage-fix.md
- .factory/cycles/cycle-004/phase-f3-stories/S-cycle4-cloud-id-correctness.md
- .factory/cycles/cycle-004/phase-f3-stories/S-cycle4-honest-fail-message.md
- .factory/specs/prd/bc-1-auth-identity.md (already amended pre-burst, committed this burst)
- .factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md (already amended pre-burst, committed this burst)

Plus first-commit of the untracked `code-delivery/S-cycle4-{cloud-id-correctness,dpapi-storage-fix,honest-fail-message,windows-docs}/` review evidence directories and `research/atlassian-3lo-revoke-granularity-2026-09-05.md`.

**Dim-2 Attestation:** No BC/VP/holdout count changed this burst (BC-1.4.039 was amended in place; `total_bcs` stays 742). `scripts/check-spec-counts.sh` and `scripts/check-bc-cumulative-counts.sh` are unaffected by a Story-Anchor/status-field/input-hash-only edit set — both scripts' coverage does not include those surfaces. The `validate-count-propagation` dispatcher hook flagged a naive substring match ("172 stories"/"19 BCs" vs. legacy "168 stories"/"10 BCs" prose retained in STATE.md's own historical Burst-14 narrative) when `STORY-INDEX.md` was edited mid-burst — verified false-positive, same class as the false-positive already noted and dismissed in Burst 15's Dim-2 Attestation: `total_stories: 172` and `total_bcs: 742` are the sole current-count frontmatter values in both files and agree; the flagged strings are historical delta prose (e.g. "168→172"), not competing current-count claims. DEC-namespace collision check: no new DEC ID allocated this burst (max remains DEC-338), no collision.

**Dim-5 Attestation:** N/A — no binary/WASM artifact produced by this burst (`.factory/` bookkeeping only; PR #770's `develop`-side binary changes were produced and verified by its own CI run, external to this burst).

**Dim-6 Attestation:** N/A for this burst's own scope — `.factory/` bookkeeping only. `develop`-side source changes for `S-cycle4-windows-docs` (`README.md`, `CLAUDE.md`) were delivered and merged via PR #770 prior to this burst; `S-cycle4-honest-fail-message`'s `src/api/auth.rs` changes exist only on the still-open `feat/cycle4-honest-fail-message` branch (PR #771), not on `develop`. This burst records both outcomes; it does not itself change source.

**Dim-7 Attestation:** PR #770's CI ran green on `develop` @ `abb283e8` (doc-only change, no test-suite impact expected or observed). PR #771's CI status was not re-verified as part of this wrap (the review agents were halted, not the CI gate itself) — re-check CI freshness on resume per the `strict: false` branch-protection caveat (CLAUDE.md) before merging, since `develop` has moved since #771 was last rebased.
