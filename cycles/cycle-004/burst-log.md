---
document_type: burst-log
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-03T16:00:00Z
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
