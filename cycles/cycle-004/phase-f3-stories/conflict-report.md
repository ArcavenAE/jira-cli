---
document_type: conflict-report
phase: phase-f3-incremental-stories
cycle: cycle-004
feature: windows-correctness
status: draft
producer: story-writer
created: 2026-09-04
inputs:
  - ".factory/cycles/cycle-004/phase-f3-stories/decomposition-manifest.md"
  - ".factory/stories/S-WIN-1-windows-per-os-path-resolution.md"
  - ".factory/stories/S-WIN-2-debug-path-isolation-seam.md"
  - ".factory/stories/S-WIN-3-keyring-windows-native-feature.md"
  - ".factory/stories/S-WIN-4-release-yml-windows-target.md"
  - ".factory/stories/S-WIN-5-ci-yml-windows-job.md"
  - ".factory/stories/S-WIN-6-windows-docs-fallout.md"
  - ".factory/stories/STORY-INDEX.md"
  - "README.md"
  - "CLAUDE.md"
  - "src/api/auth.rs"
traces_to: "decomposition-manifest.md §6"
input-hash: "6c8fb56"
---

# F3 Conflict Report — `windows-correctness` (cycle-004)

Checks the 4 new cycle-004 stories against in-progress/ready existing stories for same-file
modification races or unmet-dependency races. Special attention to the six existing
`S-WIN-*` stories, since this cycle shares the "Windows" theme with an earlier
Windows-support cycle and both touch overlapping topical ground (Windows install, Windows
config/cache paths, `keyring`'s `windows-native` feature).

---

## 1. Cycle-004 File Footprint (recap, derived from each story's own File Structure
   Requirements section)

| Story | Files touched |
|---|---|
| `S-cycle4-dpapi-storage-fix` | `src/api/auth_windows_store.rs` (new), `src/api/mod.rs`, `src/api/auth.rs`, `Cargo.toml`, `deny.toml`, `tests/jr_force_dpapi_fallback_release_gate.rs` (new), `tests/auth_profiles.rs`, `tests/api_token_percred_wiring.rs`, `tests/keyring_guard_idiom.rs`, `tests/oauth_refresh_integration.rs`, `tests/keyring_windows_native_feature_present.rs`, `CHANGELOG.md` |
| `S-cycle4-cloud-id-correctness` | `src/api/jira/tenant.rs` (new), `src/api/jira/mod.rs`, `src/cli/auth/login.rs`, `src/cli/auth/refresh.rs`, `src/cli/init.rs`, `tests/auth_chosen_flow_reconcile.rs`, a new `tests/cloud_id_tenant_info.rs`, `CHANGELOG.md` |
| `S-cycle4-honest-fail-message` | `src/api/auth.rs`, `tests/oauth_refresh_integration.rs` (or a new sibling test file), `CHANGELOG.md` |
| `S-cycle4-windows-docs` | `README.md`, `CHANGELOG.md` |

Union of touched files: `src/api/auth.rs`, `src/api/auth_windows_store.rs`,
`src/api/mod.rs`, `src/api/jira/tenant.rs`, `src/api/jira/mod.rs`,
`src/cli/auth/login.rs`, `src/cli/auth/refresh.rs`, `src/cli/init.rs`, `Cargo.toml`,
`deny.toml`, `README.md`, `CHANGELOG.md`, plus several `tests/*.rs` files.

**Correction (F3 re-review, 2026-09-04, Finding #1) — the footprint recap above now
includes `CHANGELOG.md` for all four stories; it originally listed `CHANGELOG.md` for
`S-cycle4-windows-docs` only, even though every story's Task list requires a CHANGELOG
entry.** This is a THREE-way intra-cycle overlap, not the single `src/api/auth.rs`
two-way overlap the paragraph below originally described alone:

1. `src/api/auth.rs` is touched by both `S-cycle4-dpapi-storage-fix` (Wave 1) and
   `S-cycle4-honest-fail-message` (Wave 2) — resolved by the wave schedule's
   Wave-1→Wave-2 serialization, per `wave-schedule.md` (unchanged from the original
   analysis).
2. `tests/oauth_refresh_integration.rs` is ALSO touched by both `S-cycle4-dpapi-storage-fix`
   (Wave 1, MODIFY) and `S-cycle4-honest-fail-message` (Wave 2, MODIFY-or-sibling-CREATE)
   — the same sequential dependency as item 1 above covers this file too, since both edits
   live in the same `depends_on` edge's before/after halves.
3. `CHANGELOG.md` is touched by ALL FOUR stories, spanning BOTH waves (Wave 1:
   `S-cycle4-dpapi-storage-fix` + `S-cycle4-cloud-id-correctness`; Wave 2:
   `S-cycle4-honest-fail-message` + `S-cycle4-windows-docs`) — this is a same-wave
   PARALLEL overlap (unlike items 1/2, which are sequential across waves), and is
   accordingly analyzed and mitigated in `wave-schedule.md` §7a rather than resolved by
   wave sequencing: each story appends its OWN distinct bullet line under `[Unreleased]`,
   making any resulting merge conflict a trivial append-collision, not a semantic one.

---

## 2. Item 1 — The Six Existing `S-WIN-*` Stories (earlier Windows-support cycle)

**Concern raised proactively (not in the F1/F2 dispatch, but warranted given the shared
"Windows" theme):** do any of `S-WIN-1` through `S-WIN-6` touch a file this cycle's four
stories also touch, or gate on work this cycle assumes is already done?

### Verification

| Story | `status` (frontmatter) | `target_module` | Files touched (from each story's own scope) | Overlap with cycle-004? |
|---|---|---|---|---|
| `S-WIN-1` (per-OS path resolution) | `ready` (stale — see below) | `config,cache` | `src/config.rs`, `src/cache.rs` (per-OS `global_config_dir()`/`cache_root()`) | NO code-file overlap; `S-cycle4-dpapi-storage-fix` READS `cache_root()` (per its own File Structure Requirements, listed as read-only reuse) but does not modify `src/config.rs`/`src/cache.rs` |
| `S-WIN-2` (debug path isolation seam) | `ready` (stale — see below) | `config,cache` | `src/config.rs`, `src/cache.rs` (`JR_CONFIG_DIR`/`JR_CACHE_DIR` seams) | NO overlap — same reasoning as `S-WIN-1` |
| `S-WIN-3` (keyring `windows-native` feature) | `ready` (stale — see below) | `cargo` | `Cargo.toml` (keyring feature flag), `deny.toml` | **FILE OVERLAP** with `S-cycle4-dpapi-storage-fix` (`Cargo.toml`/`deny.toml`) — see Disposition below |
| `S-WIN-4` (release.yml Windows target) | `ready` (stale — see below) | `ci` | `.github/workflows/release.yml` | NO overlap |
| `S-WIN-5` (ci.yml Windows job) | `ready` (stale — see below) | `ci,tests` | `.github/workflows/ci.yml`, test matrix config | NO overlap |
| `S-WIN-6` (docs fallout: `CLAUDE.md` JR_* entries) | `ready` (stale — see below) | `docs` | `CLAUDE.md` ONLY (JR_CONFIG_DIR/JR_CACHE_DIR entries, ADR-0016 materialize) — confirmed by reading the story file directly, NOT `README.md` | NO overlap with `S-cycle4-windows-docs` (which touches `README.md`/`CHANGELOG.md` only) |

**Ground-truth check against the actual codebase (the same discipline cycle-003's
conflict-report applied to `S-384`'s stale `status: ready` frontmatter):**

- `CLAUDE.md`'s own text already documents `JR_CONFIG_DIR`, `JR_CACHE_DIR`, the
  `#[cfg(windows)]` config/cache path split (BC-6.1.014/BC-6.2.016), the WIN-STACK
  8MB-stack fix, and the Windows Credential Manager keyring backend — all as
  ALREADY-SHIPPED behavior, not planned work. `Cargo.lock` (per F1 delta-analysis §6,
  independently re-verified during this cycle's F2 pass) confirms `keyring` 3.6.3 already
  depends on `windows-sys` 0.60.2, and `deny.toml` already carries the `windows-sys`
  `"0.60"` `[[bans.skip]]` entry `S-WIN-3` would have added.
- `README.md:66-68` (independently verified during `S-cycle4-windows-docs`'s own
  authoring, see that story's AC-001 correction note) already states the stable Windows
  asset ships and `prerelease = true` is not required — consistent with `S-WIN-4`'s
  release-workflow scope having landed.

**Disposition: all six `S-WIN-*` stories are DE FACTO COMPLETE** (code/docs already
present on `develop` at this cycle's base commit `42e92b46`), with STALE `status: ready`
frontmatter on the story files themselves — the same drift pattern cycle-003's
conflict-report found and flagged for `S-384`. This is OUT OF SCOPE for this F3 dispatch
to fix (constraint: do not modify existing stories); flagged here for whoever next
touches these six story files.

**`S-WIN-3`'s file overlap with `S-cycle4-dpapi-storage-fix` (`Cargo.toml`/`deny.toml`) is
NOT a live race**, since `S-WIN-3`'s work is already merged — `S-cycle4-dpapi-storage-fix`
is editing on top of already-landed code (the existing `windows-sys` `[[bans.skip]]`
entry it needs to UPDATE, per its own File Structure Requirements: "Update the existing
`windows-sys` `"0.60"` `[[bans.skip]]` entry's `reason` field," not create a new one),
not racing an in-flight PR.

---

## 3. Item 2 — Broader Scan of `STORY-INDEX.md` for Other In-Flight Auth/Docs Work

**Correction (F3 combined story-review pass — adversarial + consistency, 2026-09-04,
Finding #B, MAJOR).** The scan as originally run (below, unmodified for the record) EXCLUDED
the `tests/*.rs` files that this report's own §1 footprint table lists as cycle-004 touch
points — `tests/oauth_refresh_integration.rs`, `tests/auth_profiles.rs`,
`tests/api_token_percred_wiring.rs`, `tests/keyring_guard_idiom.rs` — checking only
`src/api/auth.rs`, `src/cli/auth/*`, `src/api/jira/*`, and `README.md`. That omission caused
this section to MISS real same-file-overlap stories and reach a false "none found"
conclusion. §3a below re-runs the scan against the full §1 footprint (source AND test
files) and records ground-truth-verified dispositions for every match.

A grep of `STORY-INDEX.md` for any `status: ready`/`in-progress` row naming
`src/api/auth.rs`, `src/cli/auth/*`, `src/api/jira/*`, or `README.md` as a target found no
candidate beyond the six `S-WIN-*` stories addressed above and the completed cycle-003
`auth-profile-dx` stories (`S-cycle3-*`, all `status: done`/merged per that cycle's own
close-out — file-disjoint from cycle-004's touch points in any case, since cycle-003
touched `src/api/auth.rs`'s per-profile namespacing logic, which cycle-004 builds ON TOP
OF, not against — no residual race). No other in-flight story in `STORY-INDEX.md` touches
this cycle's file set.

## 3a. Item 2, Broadened — `tests/*.rs` Footprint Scan (F3 review Finding #B fix)

A grep of `STORY-INDEX.md` for any row naming `tests/oauth_refresh_integration.rs`,
`tests/auth_profiles.rs`, `tests/api_token_percred_wiring.rs`, or
`tests/keyring_guard_idiom.rs` — the four `tests/*.rs` files `S-cycle4-dpapi-storage-fix`'s
own File Structure Requirements table lists as MODIFY targets (§1 above) — surfaces four
real matches the original Item 2 scan missed, none of them among the six `S-WIN-*`
stories. Each was independently ground-truth-verified against the live codebase (the same
discipline Item 1 above applies to the `S-WIN-*` stories), not taken on the story files'
own frontmatter `status:` alone, because that field is independently known to drift stale
in both directions in this repository (Item 1's "de facto complete but `status: ready`"
pattern, AND — newly observed here — `STORY-INDEX.md`'s own row-table `status` column
disagreeing with a story's frontmatter in EITHER direction):

| Story | Frontmatter `status:` | `STORY-INDEX.md` row-table status | Touches (of the four files) | Ground-truth check | Disposition |
|---|---|---|---|---|---|
| `S-410-keychain-test-isolation` | `ready` | **merged** — PR #416 / `04e019a` (line 1063) | `tests/oauth_refresh_integration.rs` (MODIFY), `tests/multi_cloudid_disambiguation.rs` (MODIFY) | **Corrected evidence (F3 re-review, 2026-09-04, Finding #4)** — the original evidence line below undercounted due to an imprecise grep pattern; re-run and reported precisely here: `grep -c '#\[ignore\]' tests/oauth_refresh_integration.rs` → **8**, but that pattern matches the literal substring `` `#[ignore]` `` anywhere, including inside doc-comment PROSE that merely mentions the attribute (4 such comment occurrences, at the time of this check) — it is NOT a count of actual `#[ignore]`-gated tests. The precise breakdown: `grep -c '#\[ignore'` (any `#[ignore` prefix, attributes only when anchored, but here still counting comment mentions) → **15** total occurrences of the `#[ignore` substring in the file; of these, **7** are the reasoned form `#[ignore = "requires keyring backend; set JR_RUN_KEYRING_TESTS=1 to run"]` (real attributes) and the remainder split between bare `#[ignore]` attributes and comment-prose mentions of `` `#[ignore]` ``. Story's own AC-004 requires 11 gated tests (4 pre-existing + 7 newly-gated); `grep -c '#\[ignore\]' tests/multi_cloudid_disambiguation.rs` → **0** real attributes present (this file's `#[ignore` occurrences, if any, are comment-only) against AC-003's requirement of 6. **Softened conclusion:** the raw ignore-count evidence alone is AMBIGUOUS about exactly how many of the required gated tests exist today — the substring-grep approach cannot, by itself, distinguish a real attribute from a doc-comment mention of the same text — but cross-checking against the story's own AC-004/AC-003 requirements (11 and 6 gated tests respectively) against the file's actual attribute count (well short of either target by a direct line-by-line read) is sufficient to conclude this story's scope is NOT fully implemented, without relying on the imprecise grep count as the sole evidence. The `STORY-INDEX.md` row-table's "merged" claim is CONTRADICTED by the live tree either way. | **LIVE SAME-FILE OVERLAP, real** — unaffected by the evidence-precision correction above; the disposition below holds regardless of the exact gated-test count. `tests/oauth_refresh_integration.rs` is touched by `S-cycle4-dpapi-storage-fix` (Wave 1) AND `S-cycle4-honest-fail-message` (Wave 2) AND this not-fully-implemented `S-410`. Not a same-wave race for cycle-004's own two stories (already serialized per §4a above), but a THIRD, backlog-unscheduled writer of the same file. `S-410` carries no `wave:`/dispatch schedule of its own (feature-followup, unscheduled) — LOW immediate collision urgency; the practical disposition (backlog-unscheduled, non-blocking, no active-wave race) is UNCHANGED by the evidence correction. Flagged: whoever dispatches `S-410` next must rebase against whichever of `S-cycle4-dpapi-storage-fix`/`S-cycle4-honest-fail-message` has landed by then, and vice versa. |
| `S-MAINT-532-global-profile-fallback-coverage` | `draft` | `draft` — awaiting F1 dispatch (line 1095) | `tests/auth_profiles.rs` (MODIFY — add 3 ungated tests) | Live tree already contains `test_global_profile_flag_propagates_to_auth_logout_unknown_profile_exits_64`, `test_global_profile_flag_propagates_to_auth_refresh_unknown_profile_exits_64`, and `test_global_profile_flag_propagates_to_auth_login_no_url_exits_64` in `tests/auth_profiles.rs` — matching the story's stated scope (one ungated test each for login/refresh/logout global `--profile` fallback). | **DE FACTO ALREADY COMPLETE**, same drift class as the `S-WIN-*` stories in Item 1 — `draft` frontmatter (both in the story file and the index row) is stale against the live tree. No overlap risk: there is nothing left for this story to add to `tests/auth_profiles.rs` that isn't already there. Flagged for whoever next touches this story file, out of scope to fix here (constraint: do not modify existing stories). |
| `S-TESTTOOL-1-test-tooling-hardening` | `draft` | **CYCLE CLOSED + MERGED** — PR #533 / `b4a470f` (line 1086) | `tests/auth_profiles.rs` (MODIFY — `#[ignore]` gate + new test), `.cargo/mutants.toml` (MODIFY, outside this cycle's footprint) | `tests/auth_profiles.rs::global_profile_flag_targets_auth_status` carries `#[ignore = "requires keyring backend; set JR_RUN_KEYRING_TESTS=1 to run"]`; `test_global_profile_flag_propagates_to_auth_status_unknown_profile_exits_64` exists; `.cargo/mutants.toml`'s `examine_globs` already lists `src/api/jira/issues.rs` and `src/cache.rs`. Row-table "merged" claim is CORRECT; the story file's own `status: draft` is the stale field here (inverse of `S-410`'s drift direction). | **DE FACTO ALREADY COMPLETE.** No overlap risk — same disposition class as Item 1's `S-WIN-*` stories. |
| `S-MAINT-CR-009-keyring-guard-canonicalize` | `draft` | `draft` — awaiting F1 dispatch (line 1092) | `tests/auth_profiles.rs` (MODIFY — migrate 3 Idiom-A `is_err()` sites to Idiom B) | `grep -n 'JR_RUN_KEYRING_TESTS' tests/auth_profiles.rs` shows all three guard sites already use Idiom B (`as_deref() != Ok("1")`); zero `is_err()` occurrences remain in the file. | **DE FACTO ALREADY COMPLETE** (or its premise no longer holds — the 3 Idiom-A sites it targets do not exist in the live file). Same disposition class as Item 1. No overlap risk. |

**Net disposition:** of the four stories the original scan missed, only `S-410` is a
genuine, currently-live same-file-overlap risk (on `tests/oauth_refresh_integration.rs`),
and only because it is the one story of the four whose scope is NOT fully realized against
the live tree (per the corrected, precision-qualified evidence above — F3 re-review Finding
#4 — the raw ignore-count grep is ambiguous on its own, but cross-checked against the
story's own AC-003/AC-004 targets it is sufficient to conclude the story's scope is at
least partially outstanding) — not because of anything cycle-004-specific. The other three
(`S-MAINT-532`/`S-TESTTOOL-1`/`S-MAINT-CR-009`) are de facto complete despite `draft`
frontmatter and pose no real risk, mirroring Item 1's `S-WIN-*` pattern exactly. This is
recorded as a **process note, not a fix**: `STORY-INDEX.md` is out of scope for this F3
dispatch (constraint: do not modify `STORY-INDEX.md`), so none of the four stories'
stale-status drift is corrected here — flagged for whoever next has write access to that
file or to the individual story files.

---

## 4. Item 3 — Intra-Cycle-004 File Overlap

**Correction (F3 re-review, 2026-09-04, Finding #1) — this section previously understated
intra-cycle overlap to a single file/pair; the full sweep below covers every file 2+
stories touch.**

### 4a. Sequential (cross-wave) overlap — resolved by wave sequencing

`src/api/auth.rs` and `tests/oauth_refresh_integration.rs` are EACH touched by both
`S-cycle4-dpapi-storage-fix` (Wave 1) and `S-cycle4-honest-fail-message` (Wave 2). This is
NOT a race for either file — it is the exact dependency relationship
`dependency-graph-extended.md`'s edge `A -> C` encodes, and `wave-schedule.md`'s Wave 1 →
Wave 2 serialization ensures `S-cycle4-honest-fail-message` starts only after
`S-cycle4-dpapi-storage-fix`'s changes to BOTH files are merged (the marker types AND the
`env_lock`-mutex test-serialization pattern `S-cycle4-honest-fail-message`'s own Previous
Story Intelligence section says it must reuse, not duplicate).

### 4b. Parallel (same-wave) overlap — mitigated, not sequenced

`CHANGELOG.md` is touched by ALL FOUR stories: BOTH Wave 1 stories
(`S-cycle4-dpapi-storage-fix` + `S-cycle4-cloud-id-correctness`, running in parallel) AND
BOTH Wave 2 stories (`S-cycle4-honest-fail-message` + `S-cycle4-windows-docs`, running in
parallel). Unlike §4a's cross-wave overlaps, wave sequencing does NOT separate these
edits in time — they are concurrent by design. This is mitigated, not sequenced: each
story appends its own distinct bullet line under `[Unreleased] > Fixed`/`Changed`, so a
same-wave pair's `CHANGELOG.md` edits merge as a trivial two-line append, never a
same-line semantic conflict. See `wave-schedule.md` §7a for the full mitigation statement.

No other intra-cycle file overlap exists beyond the three files named in §4a/§4b
(verified against each story's File Structure Requirements table and
`wave-schedule.md` §2/§3/§7a).

---

## 5. Summary

| Item | Concern | Disposition |
|---|---|---|
| `S-WIN-1`/`S-WIN-2` | Config/cache path resolution + debug seam | **CONFIRMED — no conflict** (de facto merged, `S-cycle4-dpapi-storage-fix` only READS `cache_root()`) |
| `S-WIN-3` | `Cargo.toml`/`deny.toml` `windows-sys` entry | **CONFIRMED — no live conflict** (de facto merged; `S-cycle4-dpapi-storage-fix` UPDATES the existing entry, not creates a colliding one) |
| `S-WIN-4`/`S-WIN-5` | CI/release Windows-target plumbing | **CONFIRMED — no conflict** (file-disjoint; de facto merged) |
| `S-WIN-6` | `CLAUDE.md` docs fallout | **CONFIRMED — no conflict** (targets `CLAUDE.md`, not `README.md`; file-disjoint from `S-cycle4-windows-docs`; de facto merged) |
| Broader `STORY-INDEX.md` scan (src/CLI/README only — original, narrower scan) | Other in-flight auth/docs work | **CONFIRMED — none found among `src/`/`README.md` targets** |
| Broader `STORY-INDEX.md` scan, `tests/*.rs` footprint (§3a, added by F3 review Finding #B) | `S-410`, `S-MAINT-532`, `S-TESTTOOL-1`, `S-MAINT-CR-009` — all touch `tests/auth_profiles.rs` and/or `tests/oauth_refresh_integration.rs` | **ONE live overlap found: `S-410`** (scope not fully realized against the live tree despite the index claiming "merged" — real, backlog-unscheduled race on `tests/oauth_refresh_integration.rs`; evidence precision corrected F3 re-review Finding #4 — the raw ignore-count grep alone is ambiguous, see §3a). The other three are DE FACTO COMPLETE despite `draft` frontmatter — no risk. See §3a for the per-story ground-truth table. |
| Intra-cycle `src/api/auth.rs` / `tests/oauth_refresh_integration.rs` overlap | `dpapi-storage-fix` vs. `honest-fail-message` | **RESOLVED by wave sequencing** (Wave 1 → Wave 2, matches the `depends_on` edge) — §4a |
| Intra-cycle `CHANGELOG.md` overlap (F3 re-review Finding #1) | ALL FOUR stories, both waves, two same-wave PARALLEL pairs | **MITIGATED, not sequenced** — each story appends its own distinct `[Unreleased]` bullet line; a same-wave pair's edits merge as a trivial two-line append, never a semantic conflict — §4b, `wave-schedule.md` §7a |

**Corrected summary (F3 review Finding #B):** the original "No blocking conflict found"
line below UNDERSTATED risk — it was reached via a scan that excluded this report's own §1
`tests/*.rs` footprint. Re-run against the full footprint (§3a), the honest conclusion is:
**no BLOCKING conflict** (nothing here gates cycle-004's four stories from proceeding per
`wave-schedule.md` — `S-410` is backlog-unscheduled, not in an active wave), but ONE
real, live same-file-overlap risk exists (`S-410` vs. `tests/oauth_refresh_integration.rs`)
that the original "none found" phrasing incorrectly ruled out. Cycle-004's 4 new stories
remain clear to proceed per the wave schedule in `wave-schedule.md`; the `S-410` risk is a
note for whoever dispatches `S-410` next, not a gate on this cycle.

**Process note for a future F3 pass:** this report's Item 1 finding — that F1's own
"README still says Windows asset is planned" claim (`delta-analysis.md` §0) was already
stale by the time F3 authored `S-cycle4-windows-docs` — is recorded in that story's own
"Previous Story Intelligence" section as a general lesson: F1 analysis and F3
story-writing can straddle intervening commits (here, whatever commit fixed the
"planned" language between F1's authoring and F3's), so F3 must re-verify F1's
file-state claims against the LIVE file, not merely cite F1 verbatim.
