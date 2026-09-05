---
document_type: convergence-summary
level: ops
version: "1.0"
status: complete
producer: state-manager
timestamp: 2026-09-05T19:00:00Z
phase: F5
inputs: []
input-hash: "[live-state]"
traces_to: code-delivery/FIX-F5-CYCLE4-1-pr-review.md, code-delivery/FIX-F5-CYCLE4-2-pr-review.md, code-delivery/S-cycle4-honest-fail-message/pr-rereview-*.md
---

# Phase F5 Scoped Adversarial Convergence — cycle-004 (windows-correctness)

Scope: cycle-004 implementation delta (PRs #768/#769/#771 code + #770/#772 docs), reviewed on `develop`.

Method: fresh-context, information-asymmetry walls, different-model-family adversary + cross-model secondary.

## Rounds

- **Round 1 (pass 1, adversary, on `develop` @ `e5a18fe0`):** 0 CRIT/HIGH/MED; 3 LOW —
  - (LOW-1) `auth_method:None` pre-mark blind-spot's symmetric CLEAR side left orphaning a legacy-migrated profile's OAuth refresh token on a mechanism switch;
  - (LOW-2) DEC-334 source-scan guard normalized only `///`, missing `//!`/`//` line-wraps;
  - (LOW-3) `atomic_write` lacked parent-dir fsync vs its documented crash-safety.

  FIXED via PR #773 @ `f3863f07` (`probe_stored_credential_kind` + `reconcile_legacy_none_outgoing_credentials`; guard normalization; best-effort parent-dir fsync). All TDD RED→GREEN.

- **Round 2 (passes 2 + 3 adversary, + cross-model code-reviewer secondary, on `develop` @ `f3863f07`):** 0 CRIT/HIGH/MED across all three (each independently declared converged on the blocking bar; novelty LOW). Actionable LOWs (several corroborated across reviewers):
  - `cloud_id` persisted w/o shape/empty validation (×2);
  - `fetch_cloud_id` whitespace inconsistency;
  - `fetch_cloud_id` no body-size cap;
  - `clear_profile_api_token_pair` `?`-early-abort vs siblings' attempt-all (could orphan token half);
  - stale "Red Gate" doc comments in green test files;
  - `jr init` double `cloud_id` fetch redundancy.

  Human decision: **FIX EVERYTHING ACTIONABLE.** FIXED via PR #774 @ `3b62cefa` (`is_plausible_cloud_id` + `validate_and_trim_site_url` + 64 KiB body cap; `clear_profile_api_token_pair` attempt-all; `init` GraphQL-only-when-unset precedence; doc sweep; host-pure `legacy_none_orphan_clear_target` coverage). All TDD RED→GREEN; full suite 4920/0, clippy/fmt clean.

## Accepted / documented (by-design, convention, spec-pinned, or unreachable — NOT defects)

- `--cloud-id` accepted unvalidated on api-token path (BC-1.2.052 PC1, by-design).
- api-token `cloud_id` unused by `base_url()` (BC-1.2.054, by-design; Assets consumer).
- orphan-clear branch's keychain-gated (non-CI) coverage (repo convention; gated tests non-vacuous; now also host-pure dispatch-covered).
- api-token `cloud_id` soft-fail warning text (byte-pinned by existing tests = spec).
- DPAPI-probe `None`+DPAPI-only-credential blind spot (disclosed in fn doc; unreachable via `jr`'s own code paths).
- NIT: narrow re-init stale-`cloud_id` edge (very low; value unused for api-token routing).

## Verdict

**CONVERGED.** 0 CRIT/HIGH/MED across 3 fresh adversary passes + 1 cross-model secondary; novelty decaying to LOW; all actionable LOWs resolved (PR #773 + #774); residuals documented. No `[process-gap]` findings this phase.

## Evidence pointers (not duplicated here)

- `code-delivery/FIX-F5-CYCLE4-1-pr-review.md` — PR #773 fresh-context review (Round 1 fix delta).
- `code-delivery/FIX-F5-CYCLE4-2-pr-review.md` — PR #774 fresh-context review (Round 2 fix delta).
- `code-delivery/S-cycle4-honest-fail-message/pr-rereview-{new1,pr-reviewer,security}.md` — prior F4-phase PR #771 review evidence (pre-F5, cited for continuity, not part of the F5 rounds above).
