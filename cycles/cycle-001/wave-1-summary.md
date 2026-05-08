---
document_type: wave-summary
level: ops
version: "1.0"
status: complete
producer: state-manager
timestamp: 2026-05-08T00:00:00
cycle: "cycle-001"
wave: "wave-1"
---

# Wave 1 Summary — cycle-001

Wave 1 COMPLETE as of 2026-05-08. All 8 HIGH-priority security posture, supply-chain hardening, structured logging, and regression-pinning stories delivered via PRs #295-#302.

## Final Metrics

| Metric | Value |
|--------|-------|
| Stories delivered | 8/8 |
| PRs merged | #295, #296, #297, #298, #299, #300, #301, #302 |
| Production regressions | 0 |
| New tests added | ~50 (17 regression-pin S-1.08 + 11 OAuth S-1.06 + 6 rate-limit S-1.07 + 10 observability S-1.03 + pinned SHAs/deny/timeouts) |
| Deferred items | 5 (S-1.02-DEFER, S-1.03-DEFER, S-1.04-DEFER-01/02/03, S-1.05-DEFER-01) |
| PENDING_MANUAL | 1 (S-1.05-AC-001: repo Settings → Code security → Secret scanning) |
| CI runs at exit | 8/8 green on final story |

## Story-by-Story Delivery

| Story | Title | PR | Merge SHA | Merged At | Key Outcome |
|-------|-------|----|-----------|-----------|-------------|
| S-1.01 | SHA-pinned CI/CD workflow | #295 | adae3c5 | 2026-05-07 | 20 uses: lines pinned; NFR-S-E satisfied |
| S-1.02 | cargo-deny supply-chain audit | #296 | 88a2e02 | 2026-05-07 | 4 settings tightened; 22 skip entries documented; NFR-S-F |
| S-1.03 | tracing/observability wire-up | #297 | 2d64112 | 2026-05-07 | tracing 0.1.41 wired; NFR-O-A; SD-003 preserved |
| S-1.04 | CI job timeouts | #298 | e0ea180 | 2026-05-07 | 8 timeout-minutes added; R-L12 |
| S-1.05 | GitHub secret scanning | #299 | da4c527 | 2026-05-08 | gitleaks-action@ff98106e; .gitleaks.toml; NFR-S-E/R-L13 |
| S-1.06 | OAuth flow holdout suite | #300 | f49af67 | 2026-05-08 | 11 regression-pin tests for H-001..H-006, H-022, H-029 |
| S-1.07 | Rate-limit holdout suite | #301 | 5813059 | 2026-05-08 | 6 regression-pin tests for H-013 + H-027 |
| S-1.08 | Keychain round-trip holdout | #302 | ab19783 | 2026-05-08 | 17 regression-pin tests (14 lib + 3 integration) |

## Deferred Items at Wave 1 Exit

| ID | Description | Priority | Target |
|----|-------------|----------|--------|
| S-1.02-DEFER | 12 of 22 deny.toml skip entries upstream-blocked (figment toml 1.x, jni thiserror 2.x, windows-sys 0.6x). Recheck quarterly. | LOW | Wave 3 cleanup or Dependabot |
| S-1.03-DEFER | Body logging still uses eprintln! (not tracing::trace!) to preserve SD-003 contract. Holistic renegotiation needed. | LOW | Wave 2 cleanup story |
| S-1.04-DEFER-01 | No fail-fast: false on test matrix; pre-existing. | LOW | Wave 3 if cross-platform flakiness emerges |
| S-1.04-DEFER-02 | Coverage timeout (30m) matches test; revisit if codebase grows. | LOW | Wave 3 |
| S-1.04-DEFER-03 | release.yml job-level timeout only; no step-level. | LOW | Wave 3 |
| S-1.05-DEFER-01 | gitleaks-action runs Node.js 20; GitHub forces Node.js 24 by June 2, 2026. | MEDIUM | Wave 2 maintenance sweep |
| S-1.05-AC-001 | PENDING_MANUAL: Enable repo Secret Scanning in GitHub Settings. | HIGH | Manual user action |

## Wave 1 Exit Gate Status

PASSED — 2026-05-08

All 8 Wave 1 stories merged. SHA pinning (NFR-S-E), supply-chain audit (NFR-S-F), tracing layer (NFR-O-A), CI timeouts (R-L12), secret scanning (NFR-S-E/R-L13), and regression-pin test suites for OAuth (H-001..H-006, H-022, H-029), rate-limit (H-013, H-027), and keychain holdouts all delivered. 0 production regressions. 614 lib + integration tests green at exit.
