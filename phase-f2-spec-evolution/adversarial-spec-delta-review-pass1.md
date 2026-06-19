---
document_type: adversarial-review
pass: 1
target: spec-delta-fork-ops-backfill.md, verification-delta-fork-ops-backfill.md
bundle: S-FORK-OPS-BACKFILL
created: 2026-06-18
verdict: "FINDINGS — 0 CRIT, 3 HIGH, 5 MED, 3 LOW (1 process-gap), 1 COSMETIC"
---

# Adversarial Spec-Delta Review — Pass 1
# S-FORK-OPS-BACKFILL (Fork-Ops Backfill Parity)

**Verdict: FINDINGS — 0 CRIT, 3 HIGH, 5 MED, 3 LOW (1 process-gap), 1 COSMETIC**

FINDINGS-REQUIRE-ITERATION. The spec-delta and verification-delta each have real
gaps that must be resolved before F4 can implement without guessing. No finding
blocks the architecture-delta, which is correct.

---

## HIGH Findings

### H1 — Draft releases not handled (spec-delta, DESTRUCTIVE section)

**File:** `spec-delta-fork-ops-backfill.md`, DESTRUCTIVE algorithm  
**Finding:** `gh release view "$TAG"` returns exit 0 for draft releases as well as
published releases. The spec-delta does not address what the upsert branch does
when the existing release is a draft. This leaves F4 with an unresolved design
decision: does the backfill workflow auto-publish a draft (clobbering curator
intent), skip it, or upload assets without touching draft status?

**Required fix:** Add an explicit edge-case clause to the DESTRUCTIVE algorithm.
Normative decision: gap-fill targets published historical releases; if an existing
release is a draft, upload assets via `--clobber` but do NOT auto-flip
draft→published (preserve curator intent). Emit a warning (`echo "::warning::..."`)
so the operator notices the release is still a draft after the run. Spell this out
so F4 does not guess.

---

### H2 — Prerelease-flag asymmetry not documented (spec-delta, DESTRUCTIVE section)

**File:** `spec-delta-fork-ops-backfill.md`, DESTRUCTIVE algorithm  
**Finding:** The check-then-upsert spec shows `$PRERELEASE` only in the `create`
branch. The `upload --clobber` branch omits it. This is correct behavior, but the
spec does not state it is intentional. An F4 implementer might add `--prerelease`
to the upload branch to "complete parity," which would be wrong: it would
overwrite curator-set prerelease/stable status on an existing release.

**Required fix:** Add an explicit invariant: the `upload --clobber` branch
intentionally does NOT modify the prerelease flag (preserves curator/prior intent);
only the `create` branch sets it from the `*-*` tag-name heuristic. State the
rationale: a re-run that takes the upload path must not silently demote a stable
release to prerelease or vice versa.

---

### H3 — Backfill matrix parity guard is CANDIDATE/SHOULD, not REQUIRED (verification-delta)

**File:** `verification-delta-fork-ops-backfill.md`, New-Test Candidate section  
**Finding:** The verification-delta marks `tests/backfill_matrix_parity.rs` as
"CANDIDATE for Story 1 scope" with a SHOULD qualifier and an explicit escape hatch:
"If the F4 implementer judges the YAML parsing overhead too high, document the
decision and mark as follow-up." This is the same drift class as the `ci.yml`
Windows matrix drop that `tests/ci_yml_windows_matrix.rs` was made REQUIRED to
prevent (S-WIN-5). The escape hatch allows F4 to ship Story 1 without the guard,
which defeats the purpose of the recommendation.

**Required fix:** Promote to REQUIRED Story-1 acceptance criterion. Remove the
F4-discretion escape hatch. The parsing cost is trivial (two YAML file reads, no
network, established pattern). Cite `tests/ci_yml_windows_matrix.rs` and the
S-WIN-5 precedent explicitly.

---

## MEDIUM Findings

### M1 — Citation form: bare line-range references violate CLAUDE.md #408 discipline (spec-delta)

**File:** `spec-delta-fork-ops-backfill.md`, multiple sections  
**Finding:** Several citations use bare line-range form, e.g. "build job matrix
(lines 43–52)", "release.yml lines 27–28", "backfill-release.yml lines 95–96",
"lines 145–154". CLAUDE.md #408 mandates symbol/anchor form (`<file>::<fn>` or
YAML path equivalent) with `~NN` approximation as fallback, and explicitly prohibits
bare `<file>:NN-MM` for new citations (line numbers drift on refactor).

**Required fix:** Replace bare line-range citations with symbol/anchor form, e.g.
`jobs.build.strategy.matrix.include` instead of "lines 43–52". Release.yml step
refs that were independently verified accurate may use `~NN` approximation form.

---

### M2 — Missing note on defensive `rustup target add` for Windows native triple (spec-delta)

**File:** `spec-delta-fork-ops-backfill.md`, WIN-TARGET section  
**Finding:** The spec lists `Ensure target installed (defensive)` in the step
ordering table but does not note that `rustup target add x86_64-pc-windows-msvc`
on a `windows-latest` runner (which is natively the MSVC target) is a no-op. An
F4 implementer might "optimize" it away to reduce step count, breaking parity with
`release.yml` and potentially causing failures when `rust-toolchain.toml` overrides
the default channel (same scenario as the comment in backfill-release.yml lines
69–72).

**Required fix:** Add a one-line note that the defensive `rustup target add
x86_64-pc-windows-msvc` is a harmless no-op for the native Windows triple on
windows-latest and mirrors the `release.yml` defensive pattern — F4 must NOT
optimize it away.

---

### M3 — CWE-77 summary omits that `build` job is itself in-scope (spec-delta)

**File:** `spec-delta-fork-ops-backfill.md`, CWE-77 Compliance Summary section  
**Finding:** The CWE-77 Compliance Summary says the injection guard script scans
`backfill-release.yml` and that all new run: blocks must bind `inputs.tag`. It
does not state that the `build` job is itself in-scope for the injection guard via
criterion (a) (it references `secrets.OAUTH_CLIENT_ID`/`_SECRET` in the Build
step's `env:` block). An F5 reviewer running the guard might be confused about why
the build job's steps appear in the scan output.

**Required fix:** Add a sentence to the CWE-77 Compliance Summary: the `build` job
is in-scope for `check-signing-workflow-injection.sh` via criterion (a) (it
references `secrets.OAUTH_CLIENT_ID`/`_SECRET`). All new Windows `run:` blocks in
the build job are compliant because they reference only `matrix.target` inline
(author-controlled, explicitly exempt) and bind `RELEASE_TAG` via `env:`.

---

### M4 — Concurrent same-tag dispatch not addressed (spec-delta, DESTRUCTIVE section)

**File:** `spec-delta-fork-ops-backfill.md`, DESTRUCTIVE algorithm  
**Finding:** With the `|| true` silencer removed, two concurrent `workflow_dispatch`
runs for the same tag will race on the `gh release view` check. If both see no
existing release, both attempt `gh release create` — the loser fails loudly with a
duplicate-release error. The spec does not state whether this is intended, leaving
F4 uncertain about whether to add retry logic or a softer error handler.

**Required fix:** Add an edge-case note: concurrent same-tag dispatches may both
reach the `create` branch; with the `|| true` silencer removed, the loser fails
loud (non-zero exit). This is acceptable — a re-run then finds the release exists
and correctly takes the upload path. State this is intended. Note the
`release-gap-fill.yml` dispatcher throttle (`max` input, default 5/run with
sequential dispatch) as a structural mitigation that makes same-tag concurrent runs
rare in the scheduled path.

---

### M5 — Over-claim: softprops/action-gh-release "internally follows the same logic" (spec-delta)

**File:** `spec-delta-fork-ops-backfill.md`, DESTRUCTIVE section, "Why this mirrors release.yml" paragraph  
**Finding:** The phrase "which internally follows the same check-then-generate
logic" asserts equivalence with the bash idiom without any source. It is an
implementation claim about a third-party action that cannot be verified from the
workflow file alone.

**Required fix:** Soften to "behaviorally analogous" — i.e., `softprops/
action-gh-release` with `generate_release_notes: true` produces the same observable
outcome (notes generated only on first creation), but the internal mechanism is not
asserted to be identical to the explicit `view`-then-branch bash idiom. Let the
explicit bash idiom stand on its own correctness.

---

## LOW Findings

### L1 (process-gap) — Escape hatch undermines required guard (verification-delta)

**File:** `verification-delta-fork-ops-backfill.md`, New-Test Candidate section  
**Finding (process-gap):** The sentence "If the F4 implementer judges the YAML
parsing overhead too high, document the decision and mark as follow-up" creates an
F4-discretion downgrade path for a guard that should be mandatory. This is the
same failure mode that produced the `ci_yml_windows_matrix.rs` gap in the first
place (the guard wasn't required). Once a gap is identified as the same drift class
as a prior mandatory guard, the downgrade escape hatch must not exist.

**Required fix:** Remove the escape hatch entirely. The guard is required; F4 has
no authority to defer it.

---

### L2 — Architecture-delta does not acknowledge the new test candidate (architecture-delta)

**File:** `architecture-delta-fork-ops-backfill.md`  
**Finding:** The architecture-delta states "no changes to any architecture artifact"
but does not mention that a new Rust test file (`tests/backfill_matrix_parity.rs`)
is a candidate (now required) deliverable of Story 1. This is not a blocker — the
architecture-delta correctly reflects no architecture change — but a cross-reference
to the verification-delta would help reviewers navigate the bundle's artifacts.

**Recommendation (non-blocking):** Add a single line noting that
`verification-delta-fork-ops-backfill.md` covers the new test deliverable.

---

### L3 — F5 checklist does not include the draft-release warning check (spec-delta)

**File:** `spec-delta-fork-ops-backfill.md`, F5 Checklist  
**Finding:** The F5 checklist will need a new item after H1 is resolved (verify
the draft-detection path emits a `::warning::` and does not auto-publish). This
is non-blocking now but must be added when H1 is fixed.

**Required fix (after H1 fix):** Add checklist item: "The `upload` branch checks
`gh release view --json isDraft` (or equivalent) and emits `::warning::` if the
existing release is a draft; it does NOT set `--draft false`."

---

## COSMETIC

### C1 — Step ordering table uses "ADD" annotation inconsistently

**File:** `spec-delta-fork-ops-backfill.md`, Step Ordering section  
**Finding:** Steps 7 and 12 use inline parenthetical "ADD …" annotations, but
steps 1–6 and 13 use "(existing)" without change notes. The annotation style is
clear but mixing "(existing)", "(existing, ADD …)", and "(NEW …)" in the same
table is slightly noisy.

**Recommendation:** Acceptable as-is. A trivial cosmetic polish would be to
replace "ADD" with a consistent verb form — but this does not affect F4
correctness.
