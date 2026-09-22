---
document_type: adversarial-spec-delta-review
cycle: cycle-009
feature_slug: jql-relative-date-units
phase: phase-f2-spec-evolution
reviewed_artifacts:
  - .factory/cycles/cycle-009/phase-f2-spec-evolution/prd-delta.md
  - .factory/cycles/cycle-009/phase-f2-spec-evolution/verification-delta.md
  - .factory/specs/prd/bc-2-issue-read.md
  - .factory/spec-changelog.md
created: 2026-09-22
status: adjudicated
verdict: ITERATE
findings_high: 1
findings_medium: 1
findings_low: 1
---

# Adversarial Spec-Delta Review: jql-relative-date-units (cycle-009, scoped F2 pass)

## Scope

Scoped adversary review of the F2 spec-evolution burst for cycle-009 (`jql-relative-date-units`,
bug-fix route, adopting external PR #863, fixing GitHub issue #859). Reviewed only the F2
delta artifacts listed in frontmatter above — not a full-tree spec review. The adversary ran
with fresh context and read-only access; it produced findings but could not persist this
review file itself (no write access), so the orchestrator/product-owner persists it here on
the adversary's behalf, faithfully, with an adjudication section appended.

## VERDICT: ITERATE

One HIGH and one MEDIUM finding required a follow-up burst before this delta could be
considered spec-complete. Both are resolved in this same burst (see Orchestrator Adjudication
below); one LOW process-gap finding is explicitly deferred to F4 per prior human decision.

## Findings

### F2-ADV-H1 (HIGH) — Case-sensitivity mischaracterization in prd-delta.md Root Cause

`prd-delta.md`'s Root Cause section (pre-fix, ~lines 24 and 30) described the OLD CLIENT
validator (`src/jql.rs::validate_duration`) as matching relative-date units "case-
insensitively." Reading `src/jql.rs` directly shows this is incorrect: the client matches via
`matches!(unit, 'y' | 'M' | 'w' | 'd' | 'h' | 'm')` — an explicit, case-sensitive char-literal
arm set — and the module's own doc comment states "Units are case-sensitive — `M` is months,
`m` is minutes." Case-insensitivity is a property of Jira's SERVER-side parser, not the
client.

This is HIGH severity, not cosmetic, because two materially different downstream conclusions
follow depending on which is true:

- **(a) If the client were truly case-insensitive** (as mischaracterized), narrowing the
  accepted set to `{w, d, h, m}` would ALSO newly reject uppercase `W`/`D`/`H` — a second,
  undocumented breaking-change surface beyond the `M`/`y` narrowing this delta explicitly
  scopes and documents.
- **(b) If the client is actually case-sensitive** (the ground truth), uppercase
  `W`/`D`/`H`/`Y` were never accepted in the first place — this delta introduces NO new
  uppercase-letter regression; only `1y` and `2M` newly move from accepted to rejected.

An F4 implementer following the mischaracterized (a) framing risks either (i) writing a
`matches!` arm set that incorrectly re-adds uppercase tolerance for `W`/`D`/`H` "to avoid a
regression that isn't real," diverging from the spec's own stated `{w, d, h, m}` lowercase
target, or (ii) failing to realize the breaking-change surface documented in
`spec-changelog.md` is actually complete as scoped (M/y only), and second-guessing it.

**Recommendation:** Correct `prd-delta.md`'s Root Cause section to state plainly that the
client was always case-sensitive, that case-insensitivity is a server-side Jira property, and
add an explicit client-case-sensitivity rule plus full boundary disposition
(`2m`/`1M`/`1y`/`2M`/uppercase-`W`/`D`/`H`/`Y`) to BC-2.1.023 EC-2.1.023-5 so ground truth is
unambiguous for F4.

### F2-ADV-M1 (MEDIUM) — EC-2.1.023-5 has no enforceable F7 coverage gate

`verification-delta.md` correctly reasons that no new VP-NNN is warranted for this delta
(panic-safety already covers the narrowed input space; rejection-behavior is a
behavioral/integration property owned by a test, not a formal VP). However, the document
states the F4 CR-004 test "must add" the exit-64/zero-HTTP assertions for `2M`/`1y` without
recording a concrete, checkable acceptance gate that F7 (delta convergence) can verify
against. As written, the no-new-VP decision's soundness depends entirely on F4 remembering to
write a specific set of assertions that exist only as prose in a decision document three
phases upstream of where they'd be checked — there's no enforcement mechanism tying F7's
convergence gate to this specific obligation.

**Recommendation:** Add an explicit F7 delta-convergence acceptance gate to
`verification-delta.md` enumerating the exact assertions CR-004 must contain (rejection for
`2M` and `1y`, on both `--recent` and `--updated-recent` — 4 assertions — plus a
case-boundary assertion that `1M` is rejected while a lowercase equivalent like `30m` is
accepted-shape), so F7 has a concrete, citable checklist rather than an aspirational
paragraph.

### F2-ADV-L1 (LOW, process-gap) — Straggler references in docs/superpowers/

Scanning outside the strict F2 artifact set, stale references to the pre-delta unit set or
error string may remain in `docs/superpowers/` design/implementation-plan documents (the v1
design spec and v1 implementation plan predate this cycle and are historical references, not
living specs). This is a documentation-currency process gap, not a spec-correctness defect —
the living specs (`prd-delta.md`, `bc-2-issue-read.md`, `spec-changelog.md`) are the source of
truth and are correctly updated. Per the human's prior CR-002 decision on this cycle, fixing
any such straggler references (if they exist) is deferred to F4, in lockstep with the
`src/cli/mod.rs` help-text update (also F4 scope, per `prd-delta.md`'s "Interface / Help-Text
Note").

## Clean-Confirmation Axes (7)

The adversary additionally confirmed the following axes clean, with no findings:

1. **String-drift: CLOSED.** The canonical error string appears identical, byte-for-byte
   (modulo `{s}` substitution), at all 4 pinned sites: `prd-delta.md`'s "Canonical Error
   String" section, BC-2.1.008's Behavior clause, BC-2.1.023 EC-2.1.023-1, and
   `spec-changelog.md`'s 2.3.2 entry. No drift found.
2. **Flag names: VERIFIED REAL.** `--created-after`, `--created-before`, `--updated-after`,
   `--updated-before` are confirmed present in the CLI surface (`prd-delta.md` cites the grep
   location and clap kebab-case auto-derivation); no phantom flag names cited in the migration
   guidance.
3. **Rationale: CONSISTENT.** The `M`-silent-mis-parse-as-minutes and `y`-HTTP-400 rationale is
   stated identically across `prd-delta.md`, `bc-2-issue-read.md` (BC-2.1.008 and
   EC-2.1.023-5), and `spec-changelog.md` — no contradictory framing between files.
4. **Combined-units: COVERED.** `4w2d`-style combined-unit rejection (pre-existing behavior,
   unaffected by this delta) remains correctly documented as orthogonal to the M/y narrowing —
   BC-2.1.008's Behavior clause and EC-2.1.023-1 both preserve this distinction.
5. **No-new-VP: SOUND for panic-safety.** `validate_duration_never_panics`'s "any string"
   proptest strategy genuinely generalizes over the narrowed arm set without modification —
   confirmed by reading the property's definition scope in `verification-delta.md`.
6. **Semver: CORRECT.** PATCH-level spec-changelog bump (2.3.1 → 2.3.2) is appropriate — no new
   BC/VP added or removed, only amendment-in-place of existing bodies/edge-cases, matching this
   changelog's own PATCH-vs-MINOR type legend.
7. **Count-neutral: CONFIRMED.** `bc-2-issue-read.md`'s `total_bcs`/`definitional_count`
   (122/80) and `BC-INDEX.md`'s cumulative `total_bcs` (770) are both correctly documented as
   unaffected — no `#### BC-` heading added or removed by this delta, only Behavior/Edge-Case
   prose amended.

## Orchestrator Adjudication (2026-09-22)

Both actionable findings are resolved in the same burst that persists this review, per the
Anchor-Back discipline for F2 spec-delta fixes:

- **F2-ADV-H1 — RESOLVED by clarification, not a behavior change.** Ground truth verified
  directly against `src/jql.rs`: `validate_duration`'s unit match is
  `matches!(unit, 'y' | 'M' | 'w' | 'd' | 'h' | 'm')` — case-sensitive char-literal matching,
  confirmed further by the function's own doc comment ("Units are case-sensitive"). This means
  branch (b) in the finding above is the ground truth: uppercase `W`/`D`/`H`/`Y` were already
  rejected before this delta under case-sensitive matching, so no second, undocumented
  breaking-change surface exists. The feared branch (a) regression does NOT occur. Fixed by:
  rewording `prd-delta.md`'s Root Cause section to state the client was always case-sensitive
  and that case-insensitivity is a server-side-only property (removing the ambiguous "matched
  case-insensitively" / "collide case-insensitively server-side too" phrasing that read as
  describing client behavior); adding a "Client case-sensitivity rule" sub-section to BC-2.1.023
  EC-2.1.023-5 in `bc-2-issue-read.md` with the full `2m`/`1M`/`1y`/`2M`/uppercase-boundary
  disposition table; and adding one clarifying sentence to `spec-changelog.md`'s 2.3.2 Root
  Cause paragraph confirming uppercase `W`/`D`/`H`/`Y` were already rejected pre-change (no
  regression). The canonical error string itself is untouched by this fix — H1 is entirely
  about the case-rule prose, not the pinned string.
- **F2-ADV-M1 — ADDRESSED by an explicit F7 gate.** Added a "F7 Delta-Convergence Acceptance
  Gate" section to `verification-delta.md` enumerating the exact 5 assertions CR-004 must
  contain (4-way rejection matrix for `{2M, 1y} × {--recent, --updated-recent}` plus one
  case-boundary assertion `1M` rejected / `30m`-shape accepted), with an explicit instruction
  that F7 should cite this section directly as its acceptance criterion for EC-2.1.023-5
  coverage, rather than re-deriving the requirement from scratch or trusting the aspirational
  prose alone.
- **F2-ADV-L1 — DEFERRED to F4**, per the human's prior CR-002 decision on this cycle (no
  action taken in this F2 burst; tracked alongside the `src/cli/mod.rs` help-text update as F4
  scope).

Both guard scripts (`scripts/check-spec-counts.sh`, `scripts/check-bc-cumulative-counts.sh`)
must be re-run after this burst's edits and confirmed exit 0 before this delta is considered
spec-complete for F2. `.factory/` changes from this burst require a commit to the
factory-artifacts branch, which — per this repo's `.factory/` git-ownership convention —
is state-manager's responsibility, not product-owner's; product-owner's F2 edit scope is
limited to spec content, not `.factory/` git operations.
