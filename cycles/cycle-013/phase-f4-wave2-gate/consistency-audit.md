---
document_type: consistency-report
level: ops
version: 1.0.0
producer: consistency-validator
traces_to: .factory/cycles/cycle-013/phase-f4-wave2-gate/
timestamp: 2026-09-16T09:40:00-05:00
---

# Cycle-013 Wave-2 Integration Gate — Consistency Audit

**Scope:** Fresh-context, read-only cross-document consistency audit of the cycle-013
(`msrv-1.88-bump`) delta on `develop` tip `cfe1dedc` (MSRV 1.85 → 1.88, ADR-0025, all 3
stories merged: PR #818 @ `29e2d362`, PR #819 @ `cfe1dedc`). This pass had NOT seen any
prior review output (F3 adversarial passes, F4 PR reviews, or STATE.md narrative) before
forming its own findings — STATE.md/CHANGELOG were read only to cross-check claims already
independently derived from the primary artifacts (ADR-0025, CLAUDE.md, Cargo.toml, ci.yml,
BC files, STORY-INDEX.md).

## Summary Table

| # | Check | Result |
|---|---|---|
| 1 | ADR-0025 status field | PASS — `status: proposed` (correct; flips to Accepted only at F7 per cycle-012/ADR-0024 precedent) |
| 1b | ADR-0025 internal prose currency (Status section + epilogue) | **FAIL (MEDIUM)** — see F-1 |
| 1c | ARCH-INDEX.md row for ADR-0025 | PASS — consistent (SS-02/SS-08/SS-09 matches frontmatter) |
| 2 | CLAUDE.md MSRV/toolchain-scope references | PASS — all current-state mentions read 1.88 / `--all-targets`; historical 1.85 mentions are explicitly dated/attributed (S-626-1) |
| 2b | `docs/specs/ci-gate-completeness.md` MSRV/scope references | **FAIL (HIGH)** — see F-2 |
| 3 | `Cargo.toml` `rust-version` | PASS — `"1.88"`, consistent with README badge and design-spec |
| 4a | `scripts/check-spec-counts.sh` | PASS — exit 0 ("Check passed: 8 bc files validated") |
| 4b | `scripts/check-bc-cumulative-counts.sh` | PASS — exit 0 ("OK: all cumulative BC counts verified (769 total across 9 files)") |
| 4c | `cargo test --test claude_md_citations` | PASS — exit 0, 61/61 passed, incl. `test_claude_md_citations_resolve_to_real_files` |
| 5 | STORY-INDEX.md — 3 cycle-013 stories done, `total_stories: 185` | PASS |
| 6 | "Zero BC edits" claim vs. actual BC prose state | PASS (no contradiction; see analysis) |
| 7 | Historical planning-doc MSRV mentions (`docs/superpowers/plans/*.md`, pre-2026-04-23) | LOW/NIT — see F-3 |
| 8 | ADR-0025 "Consequences" claims vs. landed code (comfy-table pin, snapshot, CI job shape) | PASS — verified against live `Cargo.toml`/`ci.yml` |

## Findings

### F-1 (MEDIUM) — ADR-0025's own body is stale relative to the F4 merge it now post-dates

**File:** `.factory/specs/architecture/decisions/ADR-0025-raise-msrv-to-1-88.md`

**Location 1 — `## Status` (top of file, ~line 16-20):**
> "**Proposed** (2026-09-15). Gate: F2 spec evolution for cycle-013 `msrv-1.88-bump` (Feature
> Mode). ... this ADR records the decision's durable rationale for F2's human approval gate.
> Do not treat this as Accepted until the F2 gate is passed — no DEC is minted by this
> document."

**Location 2 — `### Status as of 2026-09-15` (~line 181-186):**
> "Proposed, pending the F2 human approval gate. No code, `Cargo.toml`, or `ci.yml` changes
> have been made under this ADR — F2 is spec-layer only. Implementation is F4's
> responsibility per the F1 preview story decomposition..."

**Problem:** Both passages read as though the F2 gate has not yet happened and no
implementation exists. In fact: the F2 gate was approved the same day (DEC-364,
2026-09-15), and F3 (DEC-365) and F4 (both waves, DEC-366 + bookkeeping completion) have
since landed on `develop` — `Cargo.toml`'s `rust-version` is now `"1.88"`, `comfy-table` is
re-pinned to `=7.2.2`, and `.github/workflows/ci.yml`'s `msrv` job now runs
`toolchain: "1.88.0"` / `RUSTUP_TOOLCHAIN: "1.88.0"` / `cargo check --all-targets
--all-features --locked` — all verified directly against the files in this audit (see
Summary Table #3). The ADR's own record of "no code changes have been made under this ADR"
is therefore false as of the `develop` tip under audit.

**Not a contradiction of the top-level `status: proposed` field** (that field is correctly
still `proposed` — VSDD convention flips it to `Accepted` only at F7, confirmed by STATE.md's
DEC-364/366 entries and the cycle-012/ADR-0024 precedent they cite). The defect is narrower:
the ADR's *prose*, which narrates gate/implementation state as of authoring time, was never
revisited after F2/F3/F4 each closed, so a reader of the ADR file alone (without STATE.md)
would incorrectly conclude implementation has not started.

**Fix:** At F7 (when status flips to Accepted), or as a lightweight interim edit now, refresh
both passages: (a) note the F2 gate was approved 2026-09-15 (DEC-364); (b) note F4
implementation (both waves) merged 2026-09-16 (`29e2d362`, `cfe1dedc`) — Cargo.toml, ci.yml,
and `tests/ci_gate_completeness.rs` are already at 1.88; (c) status remains `proposed` only
because F7 delta-convergence has not yet run. This is prose-currency housekeeping, not a
contract change — no re-approval required.

### F-2 (HIGH) — `docs/specs/ci-gate-completeness.md` was not reconciled and now contradicts the landed `msrv` job

**File:** `docs/specs/ci-gate-completeness.md` (~line 28, the "S-CIGATE-3 correction to AC-006
rationale" paragraph)

**Problem:** This document is explicitly named in CLAUDE.md's CI Gate section as one of the
"six files" that must be reviewed together whenever `ci.yml`/`ci_gate_completeness.rs` change
("`.github/workflows/ci.yml`, `scripts/check-ci-gate.sh`, `tests/ci_gate_completeness.rs`,
`tests/common/wf.rs`, `scripts/lib/trusted-jq.sh`, ... `scripts/mutants-aggregate.sh`") and as
required reading "before touching any of the six files below." Cycle-013 touched two of those
six (`ci.yml`'s `msrv` job, `tests/ci_gate_completeness.rs`'s pinned literals) but this
extracted-history doc was not updated. It still asserts, as current fact:

> "...that job's `cargo check --all-features --locked` is deliberately scoped to lib+bins,
> NOT `--all-targets`, specifically because dev-dependencies like `wiremock` don't build at
> 1.85.0 — see the `msrv:` job's own comment in `ci.yml`."

and

> "`saphyr-parser` 0.0.11's own MSRV is exactly 1.85.0 against this repo's `rust-version =
> "1.85"` — zero headroom — but this is NOT enforced by the `msrv` job for a dev-dependency."

Both statements are now false against the live repo: `ci.yml`'s `msrv` job runs
`cargo check --all-targets --all-features --locked` (confirmed by direct read), the
lib+bins-only carve-out comment it references has been removed (per PR #818's own commit
message), `rust-version` is `"1.88"` (not `"1.85"`), and `saphyr-parser` at 1.85.0 now sits
*below* the floor with headroom, not at zero headroom — this is exactly the correction
CLAUDE.md's own CI-Gate section already made in its own text (line 174: "...it is no longer
excluded from that scope. This is fine: the crate's own MSRV (1.85.0) sits below this repo's
`rust-version = "1.88"` floor, with headroom to spare."). CLAUDE.md was reconciled; this
extracted spec doc, sourced from the same CI-Gate history and cited as authoritative
supporting detail, was not.

**Why HIGH, not MEDIUM:** This is not narrative/historical framing (like the CHANGELOG's
dated 1.85.0 entries, which are correctly framed as past-tense) — it is written in the
present tense as a statement of current CI behavior, and a future contributor or agent
following CLAUDE.md's own explicit instruction to read this file before touching the
CI-gate files would be actively misled about the `msrv` job's actual scope and about
`saphyr-parser`'s current headroom margin.

**Fix:** Update the two passages at `docs/specs/ci-gate-completeness.md` (~line 28) to
reflect the post-cycle-013 state: `msrv` job scope is `--all-targets` (not lib+bins-only),
`rust-version` is `"1.88"`, and `saphyr-parser` 0.0.11 (MSRV 1.85.0) now has ~3-release
headroom rather than zero. Frame the pre-cycle-013 state as historical (mirroring how
CLAUDE.md itself already did this) rather than deleting the S-CIGATE-3 narrative.

### F-3 (LOW/NIT) — Inconsistent treatment of historical plan-doc MSRV mentions

**Files:** `docs/superpowers/plans/2026-04-24-list-rs-split.md:9`,
`docs/superpowers/plans/2026-04-24-multi-profile-auth.md:9`,
`docs/superpowers/plans/2026-05-13-search-issue-keys.md:9`,
`docs/superpowers/specs/2026-04-16-markdown-to-adf-conversion-design.md:228`,
`docs/superpowers/plans/2026-03-21-jr-implementation.md` (multiple)

**Problem:** These are dated, historical planning/design documents whose "Tech Stack" headers
state "Rust 1.85 MSRV" / "Rust 1.85+" as a fact about the environment at time of writing.
Cycle-013's S3 (`S-cycle13-doc-policy-reconciliation`) added an explicit "(MSRV since raised
to 1.88 in cycle-013 — this note is dated-historical...)" annotation to exactly one
comparable file, `docs/superpowers/plans/2026-04-23-team-field-object-shape-tolerance.md`,
because that file's MSRV mention was load-bearing for an active code-snippet rationale (why
`.and_then()` was used instead of a let-chain). The other five+ files above make the same
kind of now-stale claim but were left untouched, presumably because S3's target list didn't
include them and F1's delta-analysis scoped "Files NOT Changed" to exclude the general
`docs/superpowers/` corpus.

**Severity rationale:** LOW/NIT, not MEDIUM+ — these are point-in-time planning artifacts
(CLAUDE.md frames the v1 implementation plan as historical architectural context, not a
living spec), and none of them drive an active behavioral claim the way the team-field one
did. No CI guard (`claude_md_citations`, `check-spec-counts`, etc.) covers this corpus.

**Fix (optional, not blocking):** If future cycles keep patching individual `docs/superpowers/
plans/*.md` files one at a time as they're touched, consider a single blanket disclaimer at
the top of `docs/superpowers/plans/` (or a README there) stating these are point-in-time
snapshots and MSRV/dependency-version mentions are historical, not live. Not required for
this gate to pass.

## Detailed Analysis — Items That Checked Out Clean

- **ADR-0025 status = `proposed`:** correct per VSDD convention (flips to Accepted only at
  F7); STATE.md DEC-364/DEC-366 entries explicitly cite the cycle-012/ADR-0024 precedent for
  this. Not a finding.
- **CLAUDE.md MSRV coherence:** the "rust-toolchain.toml outranks rustup default" gotcha
  (line 247) correctly frames its `1.85.0` values as historical/S-626-1-specific and states
  the current pin is `1.88.0` at the same action SHA. The CI-Gate section (line 174)
  correctly documents the `--all-targets` scope widening and `saphyr-parser`'s new headroom
  margin. No stale "1.85" or "lib+bins" claim survives in CLAUDE.md itself. The "No
  let-chains" convention entry has been fully removed (confirmed via grep — zero hits), along
  with all three `// Nested if (not a let-chain)` marker comments in
  `src/cli/auth/keychain.rs`, `src/cli/board.rs`, `src/cli/issue/list.rs` (confirmed via grep
  — zero hits; `cargo build --release` succeeds clean).
- **`Cargo.toml`:** `rust-version = "1.88"`, `comfy-table = "=7.2.2"` (re-pinned from
  `=7.2.1`), consistent with README's `MSRV-1.88-orange.svg` badge and the design-spec's
  `### MSRV Policy` section (`docs/superpowers/specs/2026-03-21-jr-jira-cli-design.md:656-658`,
  which now reads "currently **1.88.0**... (ADR-0025)").
- **Count/citation guards:** all three ran clean —
  `scripts/check-spec-counts.sh` (exit 0, 8 BC files), `scripts/check-bc-cumulative-counts.sh`
  (exit 0, 769 total across 9 files), `cargo test --test claude_md_citations` (exit 0, 61/61,
  including the load-bearing `test_claude_md_citations_resolve_to_real_files`).
- **STORY-INDEX.md:** all 3 cycle-013 stories (`S-cycle13-msrv-cargo-ci-atomic-bump`,
  `S-cycle13-letchain-retrofit-convention-cleanup`, `S-cycle13-doc-policy-reconciliation`) are
  `status: done`/merged in both the Story Manifest and Feature Followup tables;
  `total_stories: 185` in frontmatter, unchanged since F3 (only 3 status transitions, no count
  churn) — consistent with the STORY-INDEX change-log entries at lines 10-12.
- **"Zero BC edits" claim:** the F1 delta-analysis (`§6 Impact Assessment`, "PRD Requirements
  (BC-S.SS.NNN): 0 new, 0 modified") and F2 verification-delta ("zero new/changed VPs,
  architecture unchanged, zero BC edits") both explicitly and correctly scope this to *no
  contract/behavior changes* — they simultaneously and consistently flag that BC-5.3.001 /
  BC-5.3.002 (`bc-5-boards-sprints.md`) and BC-X.13.007 (`cross-cutting.md`) Behavior/Invariant
  *prose* would need a documentation-currency refresh riding alongside the code change
  ("prose-currency housekeeping," their own words). Both BC files were in fact refreshed
  (confirmed by direct read: BC-5.3.001/002's Behavior text now describes the actual
  let-chain-folded topology at `src/cli/board.rs::handle_view:~255` /
  `src/cli/issue/list.rs::handle_list:~787`; BC-X.13.007's Invariants prose now cites
  `toolchain: "1.88.0"` / `--all-targets`). No contradiction: "zero BC edits" (contract-level)
  and "BC prose refreshed" (documentation-level) are both true and both declared truthfully in
  their respective source artifacts.
- **VP-CIGATE-001:** pre-existing VP (originated cycle-001/S-626-1), correctly re-traced by
  cycle-013 without being counted as new — verification-delta.md explicitly reasons through
  why this is a literal-value update to an existing VP's parameter, not a new VP.
- **`cycles/CURRENT`:** correctly points to `cycle-013` (fixed per DEC-363 disposition).
- **ARCH-INDEX.md:** row 42 for ADR-0025 present and consistent with frontmatter
  (`subsystems_affected: ["SS-02", "SS-08", "SS-09"]`).
- **Build sanity:** `cargo build --release` succeeds clean at HEAD.

## Findings-by-Severity Count

| Severity | Count |
|---|---|
| CRIT | 0 |
| HIGH | 1 (F-2) |
| MED | 1 (F-1) |
| LOW | 1 (F-3) |
| NIT | 0 |

## Verdict

**INCONSISTENT** — one HIGH finding (F-2: `docs/specs/ci-gate-completeness.md` contradicts
the landed `msrv` job's actual scope and `rust-version` floor) blocks a clean pass. Neither
finding touches a BC, VP, story-count, or count-guard surface (all of those are clean/green),
and neither requires unwinding any merged code — both are documentation-reconciliation fixes
that can land as a small follow-up doc PR (or be folded into F5/F6 scoped adversarial review)
without reopening F3/F4. Recommend: fix F-2 before/at the Wave-2 gate (it is squarely within
the "six-file CI-Gate review scope" CLAUDE.md itself mandates); F-1 can be deferred to the F7
Accepted-status flip since it is self-consistent with VSDD convention and only stale in
supporting narrative, not in its governing `status:` field; F-3 is optional cleanup.
