---
document_type: convergence-trajectory
level: ops
version: "1.0"
status: in-progress
producer: state-manager
timestamp: 2026-09-18T03:15:06Z
cycle: "cycle-008-oauth-surface-correctness"
inputs: ["cycles/cycle-008/burst-log.md"]
input-hash: "3e0814e"
traces_to: STATE.md
---

# Convergence Trajectory — cycle-008 (oauth-surface-correctness), F4 Wave 1 Wave-Gate

This file tracks the WAVE-LEVEL adversarial pass (distinct from the 4 per-story adversarial
loops tracked in each story's own demo/review evidence — S1/S3/S4 = 3/3 clean, S2 = 3/3 clean
after 1 LOW test-hardening fix, all already CONVERGED before Wave 1 merged to `develop`).

**Severity classification below is the state-manager's reconstruction from the burst narrative
and the fix PR's own commit messages** — this `factory-artifacts` commit does not host the fix
PR's adversarial-review documents themselves, which live on branch
`fix/cycle8-double-fault-scope-rewrite` (PR `#836`). Treat as indicative, not authoritative; the
6 independent review passes (3 fix-adversarial + 3 wave-level adversarial) are the source of
record.

## Finding Progression

| Pass | Date | Total | CRIT | HIGH | MED | LOW | Novelty | Score | Counter | Verdict |
|------|------|-------|------|------|-----|-----|---------|-------|---------|---------|
| 1 (wave-level, pre-fix) | 2026-09-17 | 4 | 0 | 0 | 3 | 1 | HIGH | -- | 0/3 | FINDINGS_REMAIN |
| 2 (fix-adversarial, PR #836) | 2026-09-17 | 0 | 0 | 0 | 0 | 0 | -- | -- | 1/3 | CLEAN |
| 3 (fix-adversarial, PR #836) | 2026-09-17 | 0 | 0 | 0 | 0 | 0 | -- | -- | 2/3 | CLEAN |
| 4 (fix-adversarial, PR #836) | 2026-09-17 | 0 | 0 | 0 | 0 | 0 | -- | -- | 3/3 | CLEAN |
| 5 (wave-level, post-fix, integrated) | 2026-09-17 | 0 | 0 | 0 | 0 | 0 | -- | -- | 1/3 | CLEAN |
| 6 (wave-level, post-fix, integrated) | 2026-09-17 | 0 | 0 | 0 | 0 | 0 | -- | -- | 2/3 | CLEAN |
| 7 (wave-level, post-fix, integrated) | 2026-09-17 | 0 | 0 | 0 | 0 | 0 | -- | -- | 3/3 | CLEAN — CONVERGED |

## Trajectory Shorthand

`4→0→0→0` (wave-level rolling 4-window: 1 findings-pass + 3 clean passes; the 3 intermediate
fix-adversarial passes on the standalone PR #836 diff are a separate, also-3-clean sub-loop,
folded into the 6-pass total cited in the burst narrative.)

## Per-Pass Details

### Pass 1 — wave-level adversarial, pre-fix (2026-09-17)

**Findings:** 4 (0 CRIT, 0 HIGH, 3 MED, 1 LOW — state-manager reconstruction, see caveat above)
**Novelty:** HIGH (first wave-level integration-gate pass for cycle-008; distinct from any
per-story pass)
**Convergence counter:** 0/3

- **F-WAVE-1 (MED):** Post-refresh 401 double-fault misclassified — after a successful token
  refresh, a still-under-scoped token's follow-up 401 was hardcoded to `NotAuthenticated`
  (misleading "run `jr auth refresh`" hint) instead of being classified as `InsufficientScope`.
  Disposition: **FIX** (human-approved). Fixed via `classify_401_body(message,
  not_authenticated_hint)` in `src/api/client.rs`, wired into the pre-refresh scope check,
  `parse_error`'s 401 branch (behavior-preserving refactor), the post-refresh 401 handler, and
  the AC-010 reconcile-retry 401 handler.
- **F-WAVE-2 (MED, verification-class):** Unverified assumption about the live Agile-API 401
  wire shape under an OAuth scope-mismatch (the BC's rewrite depends on the body containing
  `"scope does not match"`). Disposition: **VERIFY LIVE** (human-approved). Verified via a
  live, read-only probe: HTTP 401, body `"Unauthorized; scope does not match"` — assumption
  HOLDS. No code change.
- **F-WAVE-3 (LOW, cosmetic):** `CHANGELOG.md` `[Unreleased]` section carries a duplicate
  `### Fixed` heading. Disposition: **DEFERRED** to release-notes consolidation (not a
  functional defect; tracked in `cycles/OPEN-STANDING-ITEMS.md`).
- **F-WAVE-4 (MED):** `get_board_config`'s OAuth scope-mismatch hint omitted the co-required
  `read:project:jira` scope (per `oauth-scope-matrix.md` #53, the endpoint requires BOTH
  `read:board-scope.admin:jira-software` AND `read:project:jira`). Disposition: **FIX**
  (human-approved). Hint widened in `src/cli/board.rs::handle_view` and
  `src/cli/sprint.rs::resolve_scrum_board`; propagated to `BC-X.15.001`
  (`specs/prd/cross-cutting.md`), `BC-1.3.023` (`specs/prd/bc-1-auth-identity.md`), and
  `ADR-0026` Decision 2's scope-list comment.

**Human ruling F-WG-1 (scope amendment, same burst):** independently of the 4 findings above,
the human ruled to **EXPAND** `BC-X.15.001`'s call-site coverage beyond the original `jr
board`/`jr sprint` boundary to also cover `jr issue list`'s board-resolution/board-based-JQL
path and `jr init`'s board-selection prompt — widening the BC from 2 to 4 command families. No
new scope strings, no new detection rule (mechanical reuse of existing hints per
`oauth-scope-matrix.md` #52/#53/#55). `VP-OAUTH-GW-003`'s minimum test-case count raised 8→11.

---

### Passes 2-4 — fix-adversarial, PR #836 standalone diff (2026-09-17)

**Findings:** 0 across all 3 passes.
**Novelty:** decayed to zero by pass 4.
**Convergence counter:** 3/3 — CLEAN, CONVERGED (fix-diff scope only).

PR #836 (`fix/cycle8-double-fault-scope-rewrite`) implements F-WAVE-1 (`classify_401_body` + 4
call sites in `src/api/client.rs`), F-WAVE-4 (hint widening), and F-WG-1 (the `jr issue list` +
`jr init` wraps). `src/error.rs` untouched throughout; refresh-coordinator / single-flight /
single-use-refresh-token semantics unchanged.

---

### Passes 5-7 — wave-level adversarial, post-fix integrated `develop` tree (2026-09-17)

**Findings:** 0 across all 3 passes.
**Novelty:** decayed to zero by pass 7.
**Convergence counter:** 3/3 — CLEAN, CONVERGED (wave-level, final integrated tree incl. fix).

Ran against the fully-integrated tree: Wave 1 (S1-S4, `develop` tip `a32caef4`) + PR #836's fix
diff. clippy+fmt clean on the integrated tree; PR #836's own CI ran the full suite (24/24
checks, incl. CI Gate) against integrated `develop`; demos re-validated + secret-scanned clean.
**WAVE INTEGRATION GATE: CONVERGED.**

---

## Outcome

Wave 1 (S1-S4) MERGED to `develop` (PRs `#832`/`#833`/`#834`/`#835`, admin-bypass,
human-authorized, prior burst). Wave-gate fix (PR `#836`) CONVERGED at 3+3 clean passes,
CI 24/24 green, `MERGEABLE`/`CLEAN`, review APPROVE (self-review non-independent per the
repo-wide self-approval structural gap — the 6 independent adversarial passes above cover
it). **NOT merged this burst** — held at the human wave-gate merge decision. See
`STATE.md` Blocking Issues and Session Resume Checkpoint for the pending action.
