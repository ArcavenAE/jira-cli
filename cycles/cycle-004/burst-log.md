---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-03T18:30:00Z
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

**Files touched (Dim-1): 7 unique files (factory-artifacts, this burst)**

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
