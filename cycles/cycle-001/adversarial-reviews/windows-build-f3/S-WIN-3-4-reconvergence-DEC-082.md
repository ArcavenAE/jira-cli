# S-WIN-3 / S-WIN-4 Adversarial RE-CONVERGENCE after DEC-082 corrections

Date: 2026-06-13. Trigger: post-F3-convergence spec corrections from pre-F4 research verification (DEC-082: C-V2b windows-sys 0.60 deny skip REQUIRED; C-V3 Compress-Archive packaging not zip). Governance: spec-steward versioned to spec v1.3.11 (PATCH); change-record spec-change-record-DEC-082.md.
Materially-changed artifacts re-reviewed: S-WIN-3 (deny REQUIRED 0.60 skip + new AC-002 test), S-WIN-4 (Compress-Archive/pwsh + sha256sum/bash packaging), with upstream ADR-0016 Decision 2/5b, architecture-delta §3.3/§5.3/R-W1.

## 3 fresh-context re-convergence passes (frozen state) — 3-CLEAN CONVERGED

- Pass A (traceability + scope-vs-amended-ADR): CLEAN. Every changed AC/EC/task traces to amended ADR-0016 / NFR / research claim; no live stale (0.61-as-target / "skip if needed" / Git-Bash-zip-primary) references; counts coherent (74).
- Pass B (mechanical correctness): CLEAN. windows-sys 0.60 [[bans.skip]] valid TOML, shaped like existing 0.45/0.61 entries, will make cargo deny pass (multiple-versions=deny, all-target eval); AC-002 pinning test concrete. Compress-Archive/pwsh + sha256sum/bash YAML valid (matrix.target/github.ref_name interpolation, jr.exe path, single-file flatten no nested-dir, .zip matches upload+release globs, .zip.sha256 matches existing glob, if-gating mutually exclusive). Only non-defect observation: -Force not needed (ephemeral clean runner).
- Pass C (integration + cross-story): CLEAN. .zip flows end-to-end to published Release (artifact name unique per target, merge-multiple flattens); S-WIN-3 dep-graph/AC-count/points internally consistent; S-WIN-1/5/6 + STORY-INDEX + ADR + adr-index + delta all consistent, zero live OLD-mechanism references; no new untracked cross-story obligation; correctness gates named (cargo deny for S-WIN-3; H-WIN-6 for S-WIN-4 packaging). Partial-fix regression discipline (S-7.01) CLEAN.

## Verdict: RE-CONVERGED (3-clean A/B/C). DEC-082 corrections fully propagated, mechanically sound, integration-clean. Awaiting F3 re-gate (human re-affirmation).
