# Dependency Audit — Security Analysis

**Sweep:** MAINTENANCE SWEEP 1 — dependency audit ANALYSIS phase (DF-029 split)
**Repo:** jira-cli
**Branch:** develop @ `01e278fcb247e8f40b4f036993a1305edbb97df4`
**Date:** 2026-09-16
**Analyst:** security-reviewer
**Inputs:**
- `.factory/maintenance/dependency-audit-raw-2026-09-16.log`
- `.factory/maintenance/dependency-audit-raw-summary-2026-09-16.md`

This document classifies the raw scan findings by severity, triages the 7 open
Dependabot PRs for merge safety, and assesses the two lockfile/config-hygiene
residuals for cleanup priority. No code, PR, or lockfile was modified to produce
this analysis.

---

## 1. Posture Summary

**CLEAN, confirmed.** `cargo audit` scanned 359 crate dependencies against a
freshly-fetched advisory DB (1246 advisories, RustSec/advisory-db) and printed
**0 RUSTSEC advisories**, exit 0, corroborated by a second isolated re-run. `cargo
deny check` passed all four gated categories — `advisories ok, bans ok, licenses
ok, sources ok` — exit 0. No CWE/CVE/RUSTSEC finding is being raised against the
current dependency tree on `develop @ 01e278fc`.

Qualifications (none block the CLEAN verdict, all are noted for completeness):

- **No advisory ≠ no risk.** `cargo audit`/`cargo deny` only catch dependencies
  with a *published* RustSec advisory. The `futures` 0.3.32→0.3.34 research below
  surfaces genuine soundness fixes (unsound `Send` impls, exception-safety bugs)
  that were fixed **without** an accompanying RUSTSEC ID ever being filed — this
  is a known blind spot of advisory-database-driven scanning generally, not a
  defect in this repo's tooling. See §2, PR #730.
- The duplicate-transitive-version findings (`getrandom`, `rand`, `serde_spanned`,
  `toml`, `toml_datetime`, `winnow`) are the ordinary "direct dep ahead of an
  indirect dep's own pin" shape (rand 0.9→0.10 split, toml 0.8→1.1 split) and
  carry **no security implication** — flagging a dependency-hygiene observation
  only, not a finding requiring a SEC-NNN ID.
- The `deny.toml` config-hygiene warnings and the orphaned `thiserror 1.0.69`
  Cargo.lock entry are addressed in §3 as LOW-severity findings.

**Verdict for this scan cycle: no CRITICAL, HIGH, or MEDIUM findings block
progression. Two LOW findings are raised for config hygiene (§3).**

---

## 2. Dependabot PR Triage (7 open PRs)

Reasoning baseline: `develop @ 01e278fc` itself passes `cargo deny check` cleanly
today. Every PR whose CI failure is `Spec-Guards`/`Deny` run against a base commit
*older* than `01e278fc` (pre-dating the cycle-013 MSRV 1.88 bump, commit `29e2d362`)
is presumptively a **stale-base CI artifact**, not a real regression introduced by
the dependency bump itself — this is a mechanical inference from the base-commit
mismatch, not a security finding, and each PR below states which case it falls
into and why the inference holds (or doesn't).

| PR | Dependency bump | Semver | Risk class | Rationale | Recommended action |
|---|---|---|---|---|---|
| #821 | `github/codeql-action/upload-sarif` 4.37.9→4.38.0 | minor (Action) | **SAFE-TO-MERGE** | CI Action bump, not a Cargo.lock entry — no crate-level attack surface. CI ran fully green against current `develop`. No advisory research needed per task scope (GH Actions bumps only get a sanity note). | Merge. |
| #820 | `taiki-e/install-action` 2.86.3→2.87.9 | minor (Action) | **SAFE-TO-MERGE** | Same class as #821 — CI tool-installer action, not a runtime/build dependency of `jr` itself. CI ran fully green against current `develop`. | Merge. |
| #738 | `open` 5.4.0→5.4.1 | patch | **SAFE-TO-MERGE** | Perplexity-validated: CLEAN, no RUSTSEC/CVE. Change is a WSL-target fix — `open`'s `WSLENV`-forwarding path now passes the launch target as *data* to PowerShell rather than interpolating it into the command string, i.e. this patch **closes a shell-argument-injection-shaped hygiene gap** on WSL targets (CWE-88-adjacent class), not introduces one. CI failure (`Spec-Guards`) ran against stale MSRV-1.85 base — presumptively a stale-base artifact per the baseline above (develop's own `cargo deny` is clean). Confirm green on rebase before merge. | Rebase/re-run CI, then merge. |
| #730 | `futures` 0.3.32→0.3.34 | patch | **SAFE-TO-MERGE** (recommend prioritizing) | Perplexity-validated: **no RUSTSEC/CVE/GHSA ID has been assigned**, but 0.3.33 fixes real soundness bugs — exception-safety unsoundness in `ReadLine`, unsound `Send` implementations on `IterPinRef`/`Iter`, a stacked-borrows violation in `compat01as03`, and a `FuturesUnordered::IntoIter` leak; 0.3.34 preserves cloned-waker identity behaviorally. None of these are known to be exploitable in `jr`'s usage (no evidence `jr` uses `IterPinRef`/`Iter`/`compat01as03` across thread boundaries), but they are genuine correctness/soundness fixes worth taking regardless of advisory status — this is exactly the "no advisory ≠ no risk" case flagged in §1. CI `Deny` failure ran against a stale base; develop's own `cargo deny` is clean. | Rebase/re-run CI, then merge — treat as a legitimate hardening bump, not a routine no-op patch. |
| #729 | `thiserror` 2.0.18→2.0.20 | patch | **SAFE-TO-MERGE** | Perplexity-validated: CLEAN, no advisory. 2.0.19 updates codegen to `syn` 3; 2.0.20 only suppresses a Clippy lint (`redundant_field_names`) in generated code — no runtime behavior change. Unrelated to the orphaned `thiserror 1.0.69` lockfile entry (§3) — this PR only touches the active `2.x` line already used by `jr` directly and by `saphyr-parser` (dev-dep). CI `Deny` failure ran against stale base. | Rebase/re-run CI, then merge. |
| #727 | `clap` 4.6.1→4.6.6 | patch | **SAFE-TO-MERGE** | Perplexity-validated: CLEAN, no RUSTSEC/CVE/advisory. Changes are help-text/derive-attribute/optional-`value_names` fixes plus an additive `Command::get_overridden_usage` method — no removed/changed public API affecting `jr`'s existing derive usage. **This PR's CI ran against the current MSRV-1.88 base** (unlike the others), so its `Deny` failure is NOT explained by the stale-base pattern the other PRs share — it needs its own look. Given `cargo deny check` is clean on `develop` today and clap has no advisory, the most likely explanation is a resolver/lockfile mismatch specific to this PR's branch state (e.g., PR branch's `Cargo.lock` not yet regenerated against `01e278fc`) rather than a genuine policy violation — but this is inference, not confirmation. | **REVIEW-NEEDED**: re-run CI after rebasing onto current `develop` tip; if `Deny` still fails post-rebase (unlike the other five), pull the actual CI log before merging — do not merge on assumption alone since this is the one PR where the stale-base excuse doesn't automatically apply. |
| #688 | `serde` 1.0.228→1.0.229 | patch | **SAFE-TO-MERGE** | Perplexity-validated: CLEAN, no advisory. Release only migrates the derive macro implementation to `syn` 3 — no serialization/deserialization behavior change, no public API change. CI `Deny` failure ran against stale base; develop's own `cargo deny` is clean. | Rebase/re-run CI, then merge. |

**Net triage result:** 6 of 7 PRs are SAFE-TO-MERGE outright (after a rebase to
clear the stale-base CI artifact where applicable). One PR (**#727 clap**) is
REVIEW-NEEDED solely because its CI ran against the *current* MSRV-1.88 base and
still failed `Deny` — that data point doesn't fit the "stale base" explanation
that covers the other five cargo-crate PRs, so it should not be merged on the
same blanket assumption without confirming the post-rebase CI result. No PR is
HOLD-class; none carries a security concern.

---

## 3. Cleanup-Items Assessment

| Item | Severity | Effort | CWE | Assessment |
|---|---|---|---|---|
| Orphaned `thiserror 1.0.69` Cargo.lock entry (zero active dependents; `cargo tree -i thiserror@1.0.69` → "nothing to print") | **LOW** | Trivial (~5 min: `cargo update -p thiserror --precise` won't apply since nothing depends on it — most likely resolved automatically by `cargo update` or `cargo generate-lockfile` on the next routine lockfile refresh; no manual surgery needed) | N/A — not a vulnerability, a lockfile-hygiene residue | Perplexity-validated: `thiserror 1.0.69` carries **no known RUSTSEC/CVE**. This is dead lockfile weight, not a live duplicate-in-tree (unlike the `getrandom`/`rand`/`toml` duplicates, which do have active dependents on both versions). Zero runtime/attack-surface impact since nothing resolves to it. Worth folding into the next routine `cargo update` rather than opening a dedicated PR — not worth a standalone maintenance PR on its own. |
| 4 `deny.toml` config-hygiene warnings (3× `license-not-encountered`: BSD-2-Clause, OpenSSL, Unicode-DFS-2016; 1× `unmatched-skip`: `cpufeatures ^0.2`, DEC-185) | **LOW** | Small (~15–30 min: remove or comment the 3 stale license allowances; re-verify the `cpufeatures` skip is still needed before removing — DEC-185's `reason` field documents an active sha1/chacha20 version-major conflict, so this one may still be load-bearing even though it shows "unmatched" today) | N/A — config hygiene, not a security gap | Not a security finding: these are warnings about `deny.toml` *allowances that currently match nothing*, not permissive gaps that let something bad through — `cargo deny check` still fully passes (`advisories ok, bans ok, licenses ok, sources ok`). Removing the 3 unmatched license entries is safe cleanup. **Caution on `cpufeatures`:** do not remove the skip without first confirming it's genuinely unneeded — DEC-185's reason cites an unavoidable sha1-v0.10.7-vs-chacha20-v0.10.0 major-version conflict; "unmatched" today could mean the conflict already resolved itself in the current tree (worth a `cargo tree -i cpufeatures` check first) or that resolution is transient. Bundle with the thiserror lockfile item into one low-priority cleanup PR if/when a maintenance PR is opened — not urgent enough to justify a dedicated PR on its own. |

Neither item rises above LOW severity or blocks any gate. Recommend bundling both
into a single low-priority "dependency lockfile/config hygiene" cleanup PR the
next time a maintenance PR is opened for another reason (e.g., alongside the
Dependabot merges above), rather than spinning up a dedicated PR solely for these.

---

## 4. Overall Security Verdict

**CLEAN.** No CRITICAL, HIGH, or MEDIUM security findings. Two LOW-severity,
non-blocking config-hygiene items noted (§3). No unresolved security-category
Risk Register R-NNN entries apply to this scan (dependency-audit scope only —
this analysis does not touch application source code).

### Prioritized Recommended Actions

1. **Merge #821, #820** (GH Actions, CI green, no rebase needed) — no-risk, do
   first.
2. **Rebase #738, #730, #729, #688 onto current `develop`, re-run CI, then merge**
   — all four are CLEAN on advisory research and their CI failures are stale-base
   artifacts; expect `Deny`/`Spec-Guards` to go green once re-run against
   `01e278fc`. Prioritize **#730 (`futures`)** slightly above the other three —
   it's the one bump in this batch fixing real (if unadvised) soundness bugs.
3. **Rebase #727 (`clap`) and re-check CI specifically** — same CLEAN advisory
   result as the others, but its `Deny` failure ran against the *current*
   MSRV-1.88 base rather than a stale one, so confirm the post-rebase CI result
   before merging rather than assuming the stale-base explanation applies.
4. **Defer, don't block:** fold the orphaned `thiserror 1.0.69` lockfile entry
   and the 4 `deny.toml` hygiene warnings into a single low-priority cleanup PR
   opened opportunistically (e.g., alongside a future Dependabot merge round) —
   verify the `cpufeatures` skip is still needed (per DEC-185) before removing
   it.

No action is security-blocking; all four recommendations are routine dependency
maintenance.
