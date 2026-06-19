---
document_type: adversarial-review
pass: 2
target: spec-delta-fork-ops-backfill.md, verification-delta-fork-ops-backfill.md
bundle: S-FORK-OPS-BACKFILL
created: 2026-06-18
verdict: "CLEAN — 0 CRIT/0 HIGH/0 MED blocking; 3 LOW observations (O1/O2/O3)"
prior_pass: adversarial-spec-delta-review-pass1.md
---

# Adversarial Spec-Delta Review — Pass 2
# S-FORK-OPS-BACKFILL (Fork-Ops Backfill Parity)

**Verdict: CLEAN — 0 CRIT/0 HIGH/0 MED blocking; 3 LOW observations (O1/O2/O3)**

All 11 Pass-1 findings (H1–H3, M1–M5, L1–L3) are substantively resolved. No
blocking findings. Three non-blocking LOW observations are recorded below for the
F4 implementer's awareness; none prevent F4 from proceeding.

---

## Pass-1 Resolution Verification

### H1 — Draft releases not handled

**Resolution: ACCEPTED.** Invariant 6 now specifies draft-release behavior
normatively: upload assets via `--clobber`, do NOT set `--draft false`, emit
`::warning::`. The replacement bash block implements this via
`gh release view --json isDraft --jq '.isDraft'`. F5 checklist item added. The
edge case is fully specified; F4 has no design decisions to make here.

### H2 — Prerelease-flag asymmetry not documented

**Resolution: ACCEPTED.** Invariant 7 explicitly states the asymmetry is
intentional, explains the rationale (a re-run must not flip curator-set
stable/prerelease status), and attributes the flag to the `create` branch only.
The F5 checklist item verifying `$PRERELEASE` absence from the upload branch is
present.

### H3 — Backfill matrix parity guard CANDIDATE/SHOULD, not REQUIRED

**Resolution: ACCEPTED.** `verification-delta-fork-ops-backfill.md` section
retitled "Required New Test." Status is now "REQUIRED. This is a Story 1 acceptance
criterion." The escape hatch sentence is removed. `tests/ci_yml_windows_matrix.rs`
and S-WIN-5 precedent are cited. Summary table updated accordingly.

### M1 — Citation form: bare line-range references

**Resolution: ACCEPTED.** All YAML paths now use anchor form:
`jobs.build.strategy.matrix.include`, `jobs.build.steps[name=...]`,
`jobs.release.steps[name=...]`, `jobs.build.steps[name=Build].env`, etc. Step
names from `release.yml` used as `release.yml jobs.build.steps[name="..."]`
references. No bare `NN-MM` line ranges remain for new citations.

### M2 — Missing note on defensive `rustup target add`

**Resolution: ACCEPTED.** New subsection "Note: Defensive `rustup target add`
— do NOT optimize away" explains the no-op nature on windows-latest and the
`rust-toolchain.toml` override risk. The "do NOT optimize away" constraint is
explicit.

### M3 — `build` job CWE-77 in-scope not stated

**Resolution: ACCEPTED.** CWE-77 Compliance Summary now explicitly states the
`build` job is in-scope via criterion (a) (`secrets.OAUTH_CLIENT_ID`/`_SECRET`
referenced in `jobs.build.steps[name=Build].env`), and explains why the new
Windows steps are compliant (only `matrix.target` inline, `RELEASE_TAG` via
`env:`).

### M4 — Concurrent dispatch not addressed

**Resolution: ACCEPTED.** Invariant 8 documents loud-failure behavior on
concurrent same-tag dispatch, states it is intended, and cites the gap-fill
throttle (`max` input, default 5/run, sequential dispatch) as structural
mitigation. The re-run path is described.

### M5 — Softprops over-claim

**Resolution: ACCEPTED.** "internally follows the same check-then-generate logic"
replaced with "behaviorally analogous." The internal mechanism is explicitly NOT
asserted to be identical. The bash idiom is stated to stand on its own correctness.

### L1 (process-gap) — Escape hatch undermines required guard

**Resolution: ACCEPTED.** Escape hatch sentence removed from
`verification-delta-fork-ops-backfill.md`. The guard is unambiguously required
with no F4-discretion downgrade path.

### L2 — Architecture-delta does not cross-reference verification-delta

**Resolution: NOTED / DEFERRED.** The architecture-delta was not modified to add
the cross-reference (it was marked "non-blocking" in Pass 1). This remains a minor
navigation gap that F7 convergence can address. Not re-escalated here.

### L3 — F5 checklist missing draft-detection item

**Resolution: ACCEPTED (subsumed by H1 fix).** The F5 checklist now includes:
"The upsert `exists` branch checks `isDraft` via `gh release view --json isDraft
--jq '.isDraft'` and emits `::warning::` if true; it does NOT set `--draft false`."

---

## Pass-2 LOW Observations

These are non-blocking. F4 may proceed. Fixes are recommended before F5.

### O1 — Unix step-name parity claim may mislead F4

**File:** `spec-delta-fork-ops-backfill.md`, Step Ordering section (step 7) and
the "Add Package (Windows) Step" preamble.

**Observation:** The spec-delta states the Windows Package step mirrors
`release.yml jobs.build.steps[name="Package (Windows)"]` verbatim. This is
correct. However, the step ordering table shows step 7 as `Package` (the existing
backfill step) while `release.yml`'s equivalent is named `Package (Unix)`. A
careful F4 implementer cross-checking against `release.yml` will find the Unix
step named differently and may question whether a rename is required. The spec
does not clarify that the Unix step retains its existing `Package` name.

**Recommendation:** Do NOT rename the Unix step. Soften the parity claim in the
preamble so it reads that the step *bodies* mirror `release.yml` while the Unix
step retains its existing `Package` name (as `Package (Unix)` in `release.yml` is
that workflow's naming choice, not a contract for backfill-release.yml).

---

### O2 — Unix embedded-OAuth verification parity gap not scoped

**File:** `spec-delta-fork-ops-backfill.md`, WIN-TARGET section.

**Observation:** `release.yml` has both a Windows embedded-OAuth verification step
(`jobs.build.steps[name="Embedded OAuth verification (Windows)"]`) AND a Unix one
(`jobs.build.steps[name="Verify embedded OAuth app present"]`). The current
`backfill-release.yml` has neither. WIN-TARGET adds only the Windows step. The
spec-delta does not acknowledge the Unix gap, so an F5 reviewer reading the parity
claim may flag the absence of the Unix step as an omission.

**Recommendation:** Add a one-line scope note in the WIN-TARGET section stating
that `release.yml` also has a Unix embedded-OAuth verification step; the Unix step's
absence from `backfill-release.yml` is a pre-existing gap that is OUT OF SCOPE for
WIN-TARGET. Do not expand scope; the note exists to preempt F5 confusion.

---

### O3 — GITLEAKS_DISABLED `if:` literal in CLAUDE.md bullet is partial / inaccurate

**File:** `spec-delta-fork-ops-backfill.md`, Drift Item GITLEAKS-DOC / CLAUDE.md
AI Agent Notes Entry section.

**Observation:** The CLAUDE.md bullet in the spec-delta reads:

> `jobs.security.if: vars.GITLEAKS_DISABLED != 'true'`

The actual `ci.yml` `jobs.security.if:` condition also includes an event-name
guard: `github.event_name == 'pull_request' && vars.GITLEAKS_DISABLED != 'true'`.
Quoting only the variable half presents a misleadingly simple picture of when the
job is skipped and could cause an operator to conclude the job is always skipped
when the variable is set (it is also skipped on non-PR events regardless of the
variable).

**Recommendation:** Either quote the full `if:` condition, or reword descriptively:
"skips the gitleaks secret-scan job on pull-request events when
`vars.GITLEAKS_DISABLED == 'true'`." The `fork-friendly-release-ops.md` table row
text ("disables the gitleaks secret-scan job in `ci.yml`") is already accurate
because it does not claim to quote the `if:` — only the CLAUDE.md bullet has this
issue.
