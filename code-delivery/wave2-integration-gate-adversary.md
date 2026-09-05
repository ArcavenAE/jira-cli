# Wave 2 Integration Gate — Adversarial Review (cycle-004, F4)

Diff scope: `c2074247..281ba272` (squash merges of #770 `S-cycle4-windows-docs` and #771 `S-cycle4-honest-fail-message`).
Mode: emergent / cross-story defects only — NOT re-reviewing either converged story.

## Verdict
CLEAN of emergent cross-story (#770 × #771) defects. The two stories are largely orthogonal (docs-only vs. error-message code). Their one genuinely shared surface (CHANGELOG.md `[Unreleased]`, and the CLAUDE.md credential-storage narrative) is internally consistent, and the chartered integration hazard — a doc still describing OAuth-grant revoke as safe per-profile cleanup, contradicting #771's DEC-334 correction — does NOT exist: no README/CLAUDE.md/`docs/` file mentions grant-revoke at all. Fresh-context re-derivation surfaced 1 MEDIUM + 2 LOW documentation-consistency defects in the combined tree (all prose, none a runtime regression, none CI-caught). None is a hard merge blocker.

## Findings
### W2-INT-MED-001 — README states API-token creds are "stored once … shared by all `api_token` profiles"; current code stores them per-profile (HIGH confidence, MEDIUM severity)
`README.md:388-391`. Factually false vs current tree. Ground truth: `src/api/auth.rs::store_api_token` (~L701) writes per-profile namespaced `<profile>:email`/`<profile>:api-token` via `api_token_email_key`/`api_token_key` (~L49-57); `load_api_token_cross_profile_isolation` and `load_api_token_default_profile_has_no_legacy_fallback` confirm per-profile isolation + no flat fallback; CLAUDE.md BC-1.4.031 states creds are cloudId/profile-scoped, not account-level. #770 revised the adjacent cloud_id + OAuth-storage paragraphs but left this API-token sentence describing the cycle-3-superseded shared-flat model. Pre-existing (predates Wave 2); in-scope for the gate as an internal inconsistency inside the section #770 revised.

### W2-INT-LOW-001 — README Windows storage docs omit the DPAPI secrets path/failure mode the honest-fail messages assume (LOW)
#770 added the per-platform storage table but the cycle-4 DPAPI work introduced `%LOCALAPPDATA%\jr\secrets\<profile>\oauth-tokens.dat`, which #771's honest-fail messages surface as remediation. README never mentions the DPAPI fallback file. Omission (not contradiction); genuine cycle-4 integration seam (#770 docs × #771 messages).

### W2-INT-LOW-002 — README `jr auth login` help says "API token (default)"; current default is an OAuth-first picker (LOW, pre-existing) [process-gap]
`README.md:261`. Cycle-3 staleness (BC-1.1.013, OAuth-first picker; `--oauth` deprecated). [process-gap]: no CI guard cross-checks README auth/storage PROSE against the code model (contrast `tests/claude_md_citations.rs`, which checks only path existence). Repeated README-vs-code drift (MED-001, LOW-002) across cycles suggests a codification follow-up.

## Verification notes
- OAuth-revoke doc consistency: grep of `revoke|manage-profile/apps|DPAPI` across README/docs/CHANGELOG — README/docs contain zero grant-revoke prose; #771's source-scan guard forbids the harmful phrases in production `auth.rs`; message text presents revoke as OPTIONAL + ACCOUNT-WIDE. No doc contradicts this. CLEAN.
- Shared-file interaction: CHANGELOG `[Unreleased]` #770 (Changed, doc-only) and #771 (Fixed) entries non-overlapping and internally consistent; both reference DEC-334 with corrected framing. CLAUDE.md SEC-WCM-DOC/DPAPI note does not contradict #771's failure-path messages.
- Site-3 refresh message omits revoke instruction; AC-005 proactive `clear_profile_oauth_pair` fires only on the Site-3 DpapiFallbackFailed arm, not Site-1. Consistent with CHANGELOG.
- CI-coverage-beyond-build: the three findings are prose only; the green 15-check run does not cover them.

## Novelty Assessment
MEDIUM. The revoke/DPAPI-message consistency axis (the gate's primary charter) is genuinely CLEAN. The three README findings are new to fresh-context re-derivation; two predate Wave 2.

## Disposition (orchestrator, human-decided)
Human decided: FIX ALL 3 in-cycle now → delivered as PR #772 (FIX-W2-INT-README), squash-merged @ e5a18fe0. The [process-gap] (README-prose-vs-code CI guard) tracked as `W2-INT-PROCESS-GAP-README-PROSE-DRIFT`, deferred to a future SELF-IMPROVEMENT/maintenance cycle per the S-7.02 cycle-closing checklist.
