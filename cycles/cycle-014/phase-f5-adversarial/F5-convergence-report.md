# F5 Convergence Report — cycle-014 (`issue-triage-quickfixes`)

- **Phase:** F5 scoped adversarial review (Feature Mode)
- **Verdict:** **F5 CONVERGED** — 3 of 3 consecutive clean counted passes (Passes 12, 13, 14).
- **Passes used:** 14 of 15 (cap raised from 10 to 15 by `D-403`); Pass 15 unused.
- **Delta reviewed (final):** `git diff 204b1fb5..3fb4cf3b` (STORY-A/C/B + `FIX-P5-001`..`FIX-P5-015`)
- **Final develop tip:** `3fb4cf3b` (`FIX-P5-015`, PR #910, human squash 2026-10-04T23:25:18Z)
- **Date:** 2026-10-04
- **Next:** F6 (targeted hardening) — formal-verifier on the new/changed VPs plus a security-reviewer
  final delta scan. No DTU clones and no UI exist, so dtu-validator, accessibility and demo do not
  apply. Then F7 delta convergence (consistency-validator 7-dimension loop), human approval, release.

## Pass History (1-14)

Each counted pass dispatched three fresh-context reviewers: adversary, code-reviewer,
security-reviewer. Records: `pass-N.md` in this directory.

| Pass | Reviewed up to | Verdict | Adversary headline | Counter | Decision |
|---|---|---|---|---|---|
| 1 | `769365ab` | NOT CLEAN | 6 findings (MEDIUM, MEDIUM, 3 LOW, NIT) + 1 process-gap | 0/3 | `FIX-P5-002` scoped (`D-396`) |
| 2 | `cc19c2f9` | NOT CLEAN | 5 findings (HIGH doc-only, 2 MEDIUM, 2 LOW) + NIT + process-gap | 0/3 | `FIX-P5-003` scoped (`D-397`) |
| 3 | `8e843385` | NOT CLEAN | 5 LOW (one false positive, one process-gap), 2 NIT | 0/3 | `D-398` -> `FIX-P5-004` |
| 4 | `6cece14b` | NOT CLEAN | 3 LOW, 4 NIT | 0/3 | `D-399` -> `FIX-P5-005` |
| 5 | `0a4dc062` | NOT CLEAN | 1 LOW, 4 NIT (security `SEC5-001` LOW CWE-451 accepted, `EC-24`) | 0/3 | `D-400` -> `FIX-P5-006` |
| 6 | `ce6be7ad` | NOT CLEAN | 4 LOW (one process-gap); security 3 LOW | 0/3 | `D-401` -> `FIX-P5-007` |
| 7 | `ecbc5cda` | NOT CLEAN | 1 LOW (process-gap), 3 NIT | 0/3 | `D-402` -> `FIX-P5-008` |
| 8 | `b9ae0862` | NOT CLEAN | 3 LOW, 6 NIT; reached the 10-pass cap | 0/3 | `D-403`: cap 10->15, strict rule kept -> `FIX-P5-009` |
| 9 | `f72255cd` | NOT CLEAN | 1 MEDIUM (inventory completeness claim), 1 NIT | 0/3 | `D-404` -> `FIX-P5-010` |
| 10 | `b2b8ee3b` | NOT CLEAN | 1 MEDIUM (spec-vs-code "mirrored" claim; process-gap), 2 NIT | 0/3 | `D-405` -> `FIX-P5-011` |
| 11 | `c33f5d44` | NOT CLEAN | 1 MEDIUM (BC-INDEX H1 sync; process-gap), 1 LOW, 1 NIT | 0/3 | `D-406` -> `FIX-P5-012`; rehearsal process |
| 12 | `eb52643b` | **CLEAN** (NITs only) | CLEAN-with-nits, novelty LOW | **1/3** | `D-407`: NIT-only counts clean -> `FIX-P5-014` |
| 13 | `0a579ad5` | **CLEAN** (NIT only) | CLEAN-with-nits, novelty LOW | **2/3** | `D-407(b)` -> `FIX-P5-015` |
| 14 | `3fb4cf3b` | **CLEAN** (zero findings) | CLEAN, zero findings, novelty LOW | **3/3** | **F5 CONVERGED** |

## Fix PRs (`FIX-P5-001`..`FIX-P5-015`)

All merged by the human (the harness permission classifier denied the autonomous merge dispatch
each time, `D-391` standing policy notwithstanding). `FIX-P5-010`, `-011`, `-013`, `-014` and
`-015` were doc/help/comment-only (see the Notes column); the earlier fixes carried code, test and
spec changes (per-fix detail: the `FIX-P5-NNN-spec-delta.md` files and `pass-N.md` records here).

| Fix | PR | Notes |
|---|---|---|
| `FIX-P5-001` | #891 | `SEC-001` table-sanitization chokepoint; scope grew three times (`D-392`..`D-395`) |
| `FIX-P5-002` | #894 | `D-396`: `--no-color` gate moved into the styled-table API |
| `FIX-P5-003` | #895 | `D-397` |
| `FIX-P5-004` | #896 | `D-398`: Cf invisible-character policy start; `exclude_re` anchor |
| `FIX-P5-005` | #897 | `D-399`: category-based invisible-character policy |
| `FIX-P5-006` | #898 | `D-400` |
| `FIX-P5-007` | #899 | `D-401` |
| `FIX-P5-008` | #901 | `D-402` |
| `FIX-P5-009` | #902 | `D-403` |
| `FIX-P5-010` | #903 | `D-404`, doc-comment only |
| `FIX-P5-011` | #905 | `D-405`, docs only |
| `FIX-P5-012` | #907 | `D-406` |
| `FIX-P5-013` | #908 | rehearsal R13/R14 fixes, docs/help only |
| `FIX-P5-014` | #909 | `D-407`, comment/rustdoc only |
| `FIX-P5-015` | #910 | `D-407(b)`, comment/rustdoc only (simplified `field.rs::handle` rustdoc) |

## Decisions `D-392`..`D-407`

- `D-392`..`D-395`: `SEC-001` fixed as `FIX-P5-001`; scope frozen at `D-395`.
- `D-396`: `CR-2`, move the `--no-color` check into the styled-table API (`FIX-P5-002`).
- `D-397`: `FIX-P5-003`.
- `D-398`: `FIX-P5-004`; `exclude_re` re-anchor, guard deferred.
- `D-399`: invisible-character policy is category-based (all Unicode 17.0.0 `Cf` plus U+034F and
  Hangul fillers stripped; variation selectors kept, `EC-23`) (`FIX-P5-005`).
- `D-400`: `FIX-P5-006`; `SEC5-001` accepted residual `EC-24`.
- `D-401`: `FIX-P5-007`; drift-source removal, `SEC6-003` deferred.
- `D-402`: `FIX-P5-008`; full product-repo claim audit.
- `D-403`: pass cap raised 10 -> 15, strict rule kept (`FIX-P5-009`).
- `D-404`: completeness claims split by source class, mechanically verified (`FIX-P5-010`).
- `D-405`: field-resolution divergence documented as deliberate (option (a)); #904 filed
  (`FIX-P5-011`).
- `D-406`: `FIX-P5-012`; H1<->BC-INDEX guard deferred (#906); uncounted rehearsal process adopted.
- `D-407`: (a) a NIT-only pass counts clean under the strict rule; (b) fix NITs now in tiny
  comment-only PRs (`FIX-P5-014`, `FIX-P5-015`); (c) `CR12-002` tracked drift, `SEC12-001` standing
  item.

## Rehearsal Process (`D-406(c)`)

Before each counted pass, an UNCOUNTED fresh-adversary "rehearsal" runs over the fix branch plus the
current specs, and whatever it finds is fixed first. Five rehearsals ran under `D-406`: R12 (1 LOW +
2 NIT), R12B (1 MEDIUM + 1 LOW + 1 NIT, including ADR-0019 never amended for the #861 label
fallback and ADR-0023 drift), R12C (CLEAN-with-nits), then R13 (2 LOW + 1 NIT) and R14 (1 LOW) after
the #907 merge, fixed as `FIX-P5-013`. Rehearsals caught drift cheaply before a counted pass, so
counted passes were spent on a branch that had already survived a fresh adversary. Passes 12-14 were
the first three consecutive clean counted passes after the process was adopted.

## Finding-Severity Decay

- Passes 1-2: HIGH (doc-only) and MEDIUM findings across code, spec and security (the `SEC-001`
  sanitization sinks).
- Passes 3-8: LOW/NIT-only; no code or security defect after Pass 4. Remaining findings were
  doc/spec drift in a ~7.5k-line, 25-file delta.
- Passes 9, 10, 11: one MEDIUM each, all doc/spec-caused (an over-broad completeness claim, a
  "mirrored copies" claim, a BC-INDEX/H1 mismatch). Two of the three were process-gaps.
- Pass 12: NIT-only (counted clean, `D-407`). Pass 13: one NIT. Pass 14: zero findings.
- Security reviews: ZERO findings in Passes 10, 13; Pass 14 only INFO notes (`SEC14-N1`..`N3`).
- Novelty: LOW from Pass 12 onward.

## Residuals Carried Forward (non-blocking)

Tracked in `cycles/OPEN-STANDING-ITEMS.md`: `OUTPUT-INVISIBLE-FORMAT-CHARS-RESIDUAL`
(`EC-23`/`EC-24`), the new `SANITIZE-NON-CF-INVISIBLES` (`SEC14-N1`), `NONTABLE-SERVER-TEXT-SANITIZE`,
`ERROR-FORMATTER-SANITIZE-CHOKEPOINT`, `FIELD-ID-RESOLUTION-UNIFY` (#904), `BC-INDEX-H1-SYNC-GUARD`
(#906), `MUTANTS-EXCLUDE-RE-ANCHOR-GUARD`, `INTEGRATION-SANITIZE-ASSERT-CF-BIDI`,
`FIELD-OPTIONS-NOTFOUND-HINT`, `STALE-SECTION-ANCHORS-OUT-OF-SCOPE`, and others. Process-gap
dispositions for the F5 pass findings are in STATE.md's Drift Items table.

## Final State

F5 CONVERGED at 3/3 (Passes 12, 13, 14); 14 of 15 passes used; `develop` @ `3fb4cf3b`; locked
counts unchanged (773 BCs / 98 VPs / 118 holdout scenarios / 194 stories). Cycle-014 proceeds to F6.
