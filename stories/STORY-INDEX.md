---
document_type: story-index
phase: phase-2-story-decomposition
producer: story-writer
version: "1.3.0"
total_stories: 30
total_waves: 4
status: complete-pending-adv-review
last_updated: 2026-05-06
activation_head: dea1664
---

# Story Index — jira-cli (jr)

Phase 2 Story Decomposition. Activation HEAD: dea1664 (v0.5.0-dev.7).
Phase 1 converged at adversary Pass 28. Gate approved 2026-05-04.

---

## Wave Plan

| Wave | Theme | Story count | Estimated effort | Gate |
|------|-------|-------------|------------------|------|
| 0 | MUST-FIX bugs + SD-002/SD-003 security + H-NEW-AUTH-002 holdout | 7 | ~5-6 dev-days | All H-MUST-FAIL holdouts become MUST-PASS; no regression on H-001..H-047 |
| 1 | High-priority security posture, supply-chain hardening, structured logging, regression holdouts | 8 | ~6-7 dev-days | NFR-S-E/F gate; wave-0 holdouts green; H-001..H-008 MUST-PASS |
| 2 | Medium-priority NFRs, BC-2/3/4/5 holdout suites, JSON output policy, documentation | 7 | ~5-6 dev-days | NFR-P-* gate; H-030..H-044 MUST-PASS |
| 3 | Low priority + deferred (DEFER NFRs, shard splits, process codification, DOCUMENT-AS-IS) | 8 | ~5-6 dev-days | Per-story gates; no v0.5 blocking |

**Final totals: 30 stories across 4 waves.** Wave 0: 7, Wave 1: 8, Wave 2: 7, Wave 3: 8.

Story file naming: `stories/wave-W/S-W.NN-short-slug.md`
Story ID convention: `S-W.NN` (e.g., `S-0.01`, `S-1.03`)

---

## Wave 0 — MUST-FIX + Security (Active)

All Wave 0 stories are CRITICAL or HIGH priority. No v0.5 release without green on all Wave 0 holdouts.

| Story ID | Title | BC Anchors | Holdout Anchors | Status | Est. Effort |
|----------|-------|------------|-----------------|--------|-------------|
| S-0.01 | Fix `handle_open` OAuth instance URL | BC-3.4.001 | H-046 | draft | small |
| S-0.02 | Paginate `list_worklogs` | BC-X.5.002 | H-045 | draft | small |
| S-0.03 | Multi-workspace asset HashMap composite key | BC-4.3.001 | H-036 | draft | small |
| S-0.04 | Multi-profile fields active-profile migration | BC-6.3.001 | H-NEW-MP-001 | draft | medium |
| S-0.05 | Gate `JR_AUTH_HEADER` behind `#[cfg(test)]` | SD-002 / NFR-S-B | H-NEW-AUTH-002 | draft | small |
| S-0.06 | Add `--verbose-bodies` flag + PII warning | SD-003 / NFR-S-C | (new holdout per SD-003) | draft | small |
| S-0.07 | Formalize holdout H-NEW-AUTH-002 in spec | SD-002 (docs) | H-NEW-AUTH-002 | draft | xsmall |

Wave 0 story files: `stories/wave-0/S-0.NN-*.md`

---

## Wave 1 — High Priority Infrastructure (Added 2026-05-06)

Wave 1 covers HIGH-priority security posture, supply-chain hardening, structured logging,
and critical regression-pinning holdouts. All stories are independent of each other
(except S-1.03 depends on S-0.06) and can be implemented in parallel groups.

Parallel group A: S-1.01, S-1.02, S-1.04, S-1.05 (CI/CD hardening, no code deps)
Parallel group B: S-1.06, S-1.07, S-1.08 (holdout test suites, each independent)
Sequential: S-1.03 after S-0.06 merges (tracing depends on --verbose-bodies flag)

| Story ID | Title | NFR/BC Anchors | Holdout Anchors | Status | Est. Effort |
|----------|-------|----------------|-----------------|--------|-------------|
| S-1.01 | Pin GitHub Actions to full commit SHAs | NFR-S-E, R-H6 | — | draft | small |
| S-1.02 | cargo-deny supply chain hardening | NFR-S-F | — | draft | small |
| S-1.03 | Add tracing + wire structured logging | NFR-O-A | — | draft | medium |
| S-1.04 | Add timeout-minutes to all CI/CD jobs | R-L12 | — | draft | xsmall |
| S-1.05 | GitHub secret scanning + gitleaks CI | NFR-S-B, R-L13 | — | draft | small |
| S-1.06 | OAuth flow holdout suite | BC-1.1.001, BC-1.1.002 | H-001..H-008, H-022, H-029 | draft | medium |
| S-1.07 | Rate-limit holdout suite | BC-X.1.005, BC-X.4.002 | H-013, H-027 | draft | small |
| S-1.08 | Keychain per-profile layout holdout | BC-1.4.027, BC-1.4.025 | H-016 | draft | small |

Wave 1 story files: `stories/wave-1/S-1.NN-*.md`

### Wave 1 exit gate

All of the following must be true before Wave 2 dispatch:
- H-001, H-002, H-003, H-004, H-005, H-022, H-029 MUST-PASS (S-1.06 test suite green)
- H-013, H-027 MUST-PASS (S-1.07 test suite green)
- H-016 MUST-PASS (S-1.08 test suite green)
- All Wave 0 holdouts remain green (no regression)
- NFR-S-E: no floating action tags in `.github/workflows/` (S-1.01)
- NFR-S-F: `cargo deny check bans` exits 0 (S-1.02)
- NFR-S-B: gitleaks CI job passes (S-1.05)
- S-1.03 (tracing): `cargo test --all-features` green; verbose behavior unchanged

---

## Wave 2 — Medium Priority (Added 2026-05-06)

Wave 2 covers MEDIUM-priority NFRs requiring code changes, regression-pinning holdout
suites for bounded contexts BC-2 through BC-7, and policy decisions for JSON output
shapes and test naming conventions.

Parallel group A: S-2.01, S-2.02, S-2.03, S-2.04 (holdout suites, no code deps between them)
Parallel group B: S-2.05 (documentation only, no code changes)
Parallel group C: S-2.06, S-2.07 (code changes, independent of each other)
Note: S-2.03 depends on S-0.03 (precautionary); S-2.07 and S-2.05 both modify CLAUDE.md
(coordinate merge order to avoid conflicts).

| Story ID | Title | NFR/BC Anchors | Holdout Anchors | Status | Est. Effort |
|----------|-------|----------------|-----------------|--------|-------------|
| S-2.01 | BC-2 issue-read holdout suite | BC-2.1.001, BC-7.3.001, BC-X.7.006 | H-030..H-035 | draft | medium |
| S-2.02 | BC-3 issue-write holdout suite | BC-3.2.001, BC-3.2.009, BC-X.7.004 | H-006, H-007, H-008, H-014 | draft | medium |
| S-2.03 | BC-4 assets/CMDB holdout suite | BC-4.2.001, BC-4.3.002, BC-4.2.006 | H-037, H-038, H-039 | draft | small |
| S-2.04 | BC-5/7 boards, sprints, ADF holdout suite | BC-5.2.001, BC-5.2.005, BC-7.2.001 | H-040..H-044 | draft | medium |
| S-2.05 | CLAUDE.md documentation update | NFR-O-L, NFR-O-M, NFR-O-O, NFR-O-V, NFR-R-F | — | draft | small |
| S-2.06 | Worklog duration config + CMDB cache tuple | NFR-R-C, BC-X.9.001, BC-6.2.013 | — | draft | medium |
| S-2.07 | JSON output policy + test naming convention | NFR-O-F, NFR-O-J, NFR-O-W | H-020 | draft | medium |

Wave 2 story files: `stories/wave-2/S-2.NN-*.md`

### Wave 2 exit gate

All of the following must be true before Wave 3 dispatch:
- H-030..H-035 MUST-PASS (S-2.01 test suite green)
- H-006, H-007, H-008, H-014 MUST-PASS (S-2.02 test suite green)
- H-037, H-038, H-039 MUST-PASS (S-2.03 test suite green)
- H-040..H-044 MUST-PASS (S-2.04 test suite green)
- All Wave 0 and Wave 1 holdouts remain green (no regression)
- NFR-O-L: CLAUDE.md contains the 4 orphan module entries (S-2.05)
- NFR-R-C: worklog duration uses Jira timetracking config, not hardcoded 8/5 (S-2.06)
- NFR-O-F: `jr auth login/switch/logout/remove/refresh --output json` emit structured JSON (S-2.07)
- Snapshot tests green (S-2.07 insta snapshots)

---

## Wave 3 — Low Priority / Deferred (Added 2026-05-06)

Wave 3 covers LOW-severity NFRs requiring code (refactors and small fixes), DEFER NFRs carried
forward from Wave 2, process-gap codification (DRIFT-001), and DOCUMENT-AS-IS closures for
all remaining LOW NFRs. All stories are independent and can be implemented in parallel.

Parallel group A: S-3.01, S-3.02 (shard splits — independent of each other, no deps)
Parallel group B: S-3.03, S-3.04, S-3.05 (OAuth + asset concurrency — independent)
Parallel group C: S-3.06, S-3.07, S-3.08 (process + documentation — independent)
Note: S-3.08 depends on S-2.05 merging first (CLAUDE.md conflict risk).

| Story ID | Title | NFR/BC Anchors | Holdout Anchors | Status | Est. Effort |
|----------|-------|----------------|-----------------|--------|-------------|
| S-3.01 | Shard-split src/api/auth.rs (1,998 LOC) | NFR-O-D, BC-1.1.001, BC-1.4.027 | — | draft | medium |
| S-3.02 | Shard-split src/cli/assets.rs (1,055 LOC) | NFR-O-D, BC-4.2.001, BC-4.2.006 | H-037, H-038 | draft | small |
| S-3.03 | Investigate + wire refresh_oauth_token | NFR-O-B, BC-1.1.002, BC-1.4.027 | — | draft | medium |
| S-3.04 | Multi-cloudId --cloud-id flag + prompt | NFR-O-S, BC-1.1.007, BC-1.5.031 | H-047 | draft | medium |
| S-3.05 | Asset enrichment join_all → buffer_unordered(8) | NFR-P-NEW-1, BC-4.3.002, BC-X.1.005 | H-038 | draft | small |
| S-3.06 | Pre-merge spec numeric claim checker (DRIFT-001) | — | — | draft | small |
| S-3.07 | LOW NFR code fixes: Retry-After cap, overflow guard, profile name error, anti-loop | NFR-R-NEW-1, NFR-R-NEW-2, NFR-S-D, NFR-R-F, BC-X.4.009, BC-X.9.002 | H-027 | draft | small |
| S-3.08 | DOCUMENT-AS-IS LOW NFR closures: source comments + CLAUDE.md additions | NFR-R-G, NFR-O-C/E/G/H/I/N/P/R/T/U/X, NFR-SCA-1/2/3 | — | draft | small |

Wave 3 story files: `stories/wave-3/S-3.NN-*.md`

### Wave 3 exit gate

All of the following must be true before Phase 2 is considered fully complete:
- S-3.01: `cargo test --lib` green after auth.rs shard split; no shard file >800 LOC
- S-3.02: `cargo test --lib` green after cli/assets.rs shard split; H-037, H-038 still green
- S-3.03: `refresh_oauth_token` either wired (Option A test green) or removed (no dead_code lint)
- S-3.04: H-047 updated from KNOWN-GAP to MUST-PASS; AC-001 and AC-002 green
- S-3.05: asset enrichment concurrency cap ≤8; H-038 still green
- S-3.06: `scripts/check-spec-counts.sh` exits 0 on current spec corpus; exits 1 on corrupted frontmatter
- S-3.07: H-027 updated from KNOWN-GAP to MUST-PASS; `parse_duration("99999999999999w")` returns Err
- S-3.08: `cargo clippy -- -D warnings` exits 0; all 15 DOCUMENT-AS-IS LOW NFRs have a paper trail

---

## Cross-Reference Convention

Each story frontmatter uses:
- `bc_anchors:` — list of BC-S.SS.NNN IDs this story implements
- `holdout_anchors:` — list of H-NNN IDs (MUST-FAIL pre-fix, MUST-PASS post-fix)
- `nfr_anchors:` — NFR IDs this story satisfies
- `adr_refs:` — ADR IDs that constrain this story
- `sd_refs:` — Security Decision IDs (if applicable)
- `files_modified:` — source files touched (with line ranges)
- `test_files:` — test files to create or modify
