---
document_type: f2-prd-delta
phase: phase-f2-spec-evolution
issue: bucket1-defects (692, 663, 693, 694)
producer: product-owner
timestamp: 2026-08-13
status: complete
breaking_product_change: true
breaking_product_change_issues: [663, 692]
breaking_product_change_obligation: "Both #663 and #692 require a Breaking: entry in the product CHANGELOG.md at the release that ships them; NOT satisfied by this F2 pass. See 'Acceptance Note for F3/Release' section below for the full detail F3 story writers must carry forward as an explicit acceptance criterion."
---

# F2 PRD Delta — Bucket 1 Defect/Enhancement Bundle (#692, #663, #693, #694)

Four independent, file-disjoint fixes bundled into a single F1-F7 cycle per human/orchestrator
decision (Phase F1 delta analysis, `.factory/phase-f1-delta-analysis/delta-analysis.md`). This
delta is DELTA-ONLY: no unaffected requirement was rewritten or restructured. Note on tooling: the
`validate-stable-anchors` (TD-031) hook required a separate, already-landed remediation pass
(factory-artifacts commit `f06b1820`, converting legacy `<file>.<ext>:NN(-MM)` line citations to
the CLAUDE.md-sanctioned approximate form `<file>.<ext>:~NN`) across the three touched BC files
before this delta's edits could be written; that remediation changed only citation suffixes, no
BC content, and is orthogonal to the bundle itself.

---

## Summary

- **1 new BC**: BC-1.2.047 (`bc-1-auth-identity.md`).
- **3 amended BCs**: BC-3.4.021 (`bc-3-issue-write.md`, REVERSAL of Invariant 3 under DEC-274),
  BC-1.2.018 (`bc-1-auth-identity.md`, carve-out amendment), BC-X.8.009 (`cross-cutting.md`,
  additive amendment).
- **0 BC body changes** for #694 (`bc-2-issue-read.md`) — frontmatter changelog note only,
  per human ruling (docs-only, no spec drift — the true behavior was already correctly specified).
- Per-file counts: `bc-1-auth-identity.md` 57→58 total_bcs / 46→47 definitional_count.
  `bc-3-issue-write.md`, `cross-cutting.md`, `bc-2-issue-read.md`: unchanged counts (amend-in-place
  or changelog-only). `scripts/check-spec-counts.sh` exits 0 across all 7 `bc-*.md` files.
- BC-INDEX.md / CANONICAL-COUNTS.md / STATE.md are explicitly OUT OF SCOPE for this delta — the
  state-manager updates those cumulative indexes after this delta's version bumps are final
  (citation-ordering guardrail, per team-lead instruction).

---

## 1. #692 — BC-3.4.021 (bc-3-issue-write.md) — REVERSED under DEC-274

**Status**: UPDATED (reversal, not silent amend). DEC-274 is the superseding decision, recorded
in-body via a `STATUS: UPDATED (DEC-274, ...)` marker directly under the BC heading, and cited in
the BC's Trace line. STATE.md's own DEC-274 record is owned by the state-manager (out of scope
here) — this BC's text is written so it correctly points at DEC-274 once that record lands.

### Before (pre-DEC-274, now preserved verbatim in the BC's "Previous version" block)

- **Invariant 3**: `--dry-run` does NOT read stdin for `--description-stdin` — the literal
  placeholder string (`"<from stdin — not yet read in dry-run>"` / `"(read from stdin — not yet
  read in dry-run)"`) is asserted as correct behavior, not a bug.
- Postconditions-json item 3's `--description-stdin` bullet, Postconditions-table item 3, and
  EC-3.4.021-6 all pinned the literal placeholder and asserted stdin is never read.

### After (DEC-274)

- **Invariant 3 REVERSED**: `--dry-run` now reads stdin (same `spawn_blocking` + `read_to_string`
  idiom as the live path) and renders it to ADF (`adf::markdown_to_adf` if `--markdown` else
  `adf::text_to_adf`, mirroring the live path's selection).
- **New additive field**: `plannedChanges.descriptionAdf` (json mode) carries the real rendered
  ADF document, byte-identical to what the live path would POST. `plannedChanges.description`
  is UNCHANGED in kind — it continues to carry the raw stdin string verbatim, preserving
  BC-3.4.013's raw-input invariant (issue #398) with zero body edit to that BC.
- **Top-level key count preserved**: `descriptionAdf` is nested INSIDE `plannedChanges`, so
  Postconditions-json #1's "exactly three top-level keys `{dryRun, issues, plannedChanges}`"
  postcondition is untouched — this was the hard constraint from the architect's F1 impact
  analysis and is explicitly called out in the BC text.
- **Table mode**: emits the actual (no-longer-placeholder) stdin content using the same
  60-codepoint truncation rule as `--description`, plus one new line, `"  description (ADF):
  rendered OK"` — a validated-indicator line, not a raw ADF JSON dump (deliberate UX choice
  carried from the research brief).
- **New Postconditions — Common item 6**: documents the stdin read + ADF conversion as read-only
  (no additional HTTP call — Postconditions-Common item 1, "no mutation HTTP call", is unaffected)
  and states that a `markdown_to_adf` `Err` (e.g. the `MAX_ADF_DEPTH = 256` depth guard,
  BC-7.2.012) now exits 64 BEFORE any `plannedChanges` output — dry-run does not suppress this
  resolution error, consistent with the pre-existing Invariant 2 ("`--dry-run` does NOT suppress
  exit-64 resolution errors").
- **EC-3.4.021-6 rewritten** to assert the raw stdin round-trip + `descriptionAdf` population.
- **Two new Edge Cases**:
  - EC-3.4.021-15: `--description-stdin --markdown --dry-run` with pathologically nested Markdown
    triggering the depth guard → exit 64, no `plannedChanges` output.
  - EC-3.4.021-16: multi-line Markdown stdin (bullet list + fenced code block) → `description`
    carries the raw multi-line string verbatim (embedded `\n`, NOT ADF `hardBreak`-converted,
    since `description` is a bare string not an ADF text node); `descriptionAdf` carries the full
    real ADF document (`bulletList`/`codeBlock` nodes).
- **Two new Verification Properties**: VP-692-001 (happy-path stdin+ADF round-trip, top-level-key
  count preserved) and VP-692-002 (depth-guard `Err` → exit 64, empty stdout).
- **New Invariant 6**: explicit "no `--file` flag on `issue edit`" note, correcting an inaccurate
  assumption in the original issue report's proposed fix (research brief §1.4) — `--file` exists
  only on `comment edit`/`comment add`, unrelated subcommands.
- **Cross-references added, no body edits to either target**: BC-3.4.013 (raw-input invariant,
  issue #398 — explicitly confirmed unaffected) and BC-7.2.012 (`MAX_ADF_DEPTH` depth guard —
  confirmed unaffected, only newly *reachable* from this call site).

### Rationale

The pre-DEC-274 behavior was EXPLICIT, INTENTIONAL, spec-locked (BC-3.4.021 Invariant 3 asserted
it as "correct… not a bug"). The research brief confirmed this is a genuine ratified-contract
reversal, not a plain bug fix: dry-run is the ONLY non-mutating path in `issue edit`, so skipping
ADF conversion there means Jira-rejection failure modes (malformed ADF, the depth guard) were
uncatchable without a live write. DEC-274 authorizes the reversal; this BC delta implements it
while preserving every other invariant of the BC (top-level key count, raw-input semantics,
exit-64-suppression scope) unchanged.

---

## 2. #663 — bc-1-auth-identity.md

### BC-1.2.018 — AMENDED (carve-out, not reversal)

**Before**: "Global `--profile` propagates to all auth subcommands via `subcmd.profile.or(cli.profile)`" — stated unconditionally, no exceptions.

**After**: Retitled to state the exception explicitly in the heading itself: "Global `--profile`
propagates to all auth subcommands EXCEPT `auth switch` (rejected, exit 64)...". Body now states
`auth switch` is the sole exception (no subcommand-level `profile` field; global `--profile` is
rejected outright as of #663, not silently composed/ignored) and cross-references the new BC-1.2.047
for the rejection contract. The pre-#663 unqualified text is retained verbatim in a "Previous
version" blockquote for audit trail.

### BC-1.2.047 — NEW

`auth switch --profile <X>` is rejected with exit 64. Key contract points:

- **Guard site and ordering**: fires in `src/main.rs`'s `AuthCommand::Switch` dispatch arm, BEFORE
  `Config::load_with` — so a nonexistent `--profile` value does not first trip
  `Config::load_with`'s active-profile existence-check side effect (this ordering was explicitly
  named as a required refinement in the F1 delta analysis and research brief).
  - Rejection is unconditional on `cli.profile.is_some()`, independent of whether the flag's or
    positional's value name real profiles — this closes the "confusing incantation"
    `jr auth switch --profile X X` the issue reports (EC-1.2.047-1).
- **`--output json`**: standard `{"error": "...", "code": 64}` envelope — no bespoke formatter,
  flows through the existing central error handler (#526 JSON render invariant).
- **Explicitly out of scope** (per human ruling, carried from the research brief and F1 analysis):
  clap `conflicts_with = "profile"` as a belt-and-suspenders second layer (documented unreliable
  for `global = true` args, clap issues #5335/#5358, and incomplete for the flag-without-positional
  case) — dropped entirely, not even as a secondary defense. Usage-string full unification
  (`<NAME>` vs `[OPTIONS] <NAME>` vs the pre-#663 promoted third form) — accepted as universal,
  unavoidable clap behavior, not pursued via `override_usage`.
- 3 Edge Cases, 2 Verification Properties.

**New BC ID assignment**: `BC-1.2.047`. This file's BC numbering is a single sequential counter
across the whole file (not per-`S.SS` section reset — verified: section 1.1 runs 001..012,
section 1.2 continues 013..018, section 1.3 continues 019..024, etc., through section 1.6 ending
at 046). BC-1.2.047 is the next free number in that global sequence (046 was the prior max, in
section 1.6), placed in section 1.2 (Profile Lifecycle Management) for thematic grouping with its
sibling BC-1.2.018, exactly mirroring how this file's own history has always inserted new BCs
into their thematically-appropriate section while continuing the file-wide counter — no gaps, no
collisions with any of the file's existing 46 BC IDs.

---

## 3. #693 — BC-X.8.009 (cross-cutting.md) — AMENDED (additive, not a reversal)

**Before**: Issue fetch pipeline step 3 called `search_issues(&jql, Some(keys.len()), &[])` — empty
`extra_fields`, unconditionally. JSON-output clause described `fields` with no mention that
queue-configured custom fields were absent.

**After** (Option 2 from the research brief, human-endorsed):

- Step 3 now passes `extra_fields` derived from the resolved `Queue`'s declared `fields: Option<Vec<String>>`
  (the same array `jr queue list --output json` already surfaces), filtered to drop the pseudo-column
  token `issuekey` and any token already in `BASE_ISSUE_FIELDS` (BC-2.2.028) — the remainder
  (`customfield_*` and any other non-base token) passes through verbatim. Empty/absent `queue.fields`
  → `extra_fields = &[]`, byte-identical to pre-#693 behavior (no regression for queues with no
  custom columns configured).
- **`--id` vs `<name>` path cost asymmetry, stated explicitly as required**: the `<name>` path
  already has the `Queue` (and its `fields[]`) in hand from `resolve_queue_by_name`'s existing
  `list_queues` call — zero additional HTTP cost. The `--id` path bypasses `resolve_queue_by_name`
  entirely, so obtaining `queue.fields` there costs one additional `list_queues` call the `<name>`
  path does not incur — called out in both the Queue ID resolution section and the amendment
  footer note.
- **JSON output**: `fields` now also carries any `customfield_*` keys the queue is configured to
  show, via `IssueFields`'s pre-existing `#[serde(flatten)] extra: HashMap<String, Value>` — no
  new typed struct field, no display-name resolution, raw untyped `serde_json::Value`.
- **Table output explicitly unaffected**: no new column. Rendering custom fields in the human
  table is out of scope here and tracked separately as issue #575 — stated explicitly in both the
  amended Table-output bullet and a new "Rejected alternative" paragraph explaining why Option 1
  (rendering directly from the queue endpoint's own `values[].fields`, skipping `search_issues`
  entirely) was considered and rejected: the queue-admin-configured field set is a subset the
  queue is CONFIGURED to show, not guaranteed to be a superset of `jr`'s base render columns
  (Atlassian's own example queue config omits `status`/`priority`/`assignee`, all three of which
  `jr queue view`'s table renders unconditionally today) — rendering from it directly would
  silently blank those columns for under-configured queues.
- Pre-#693 step-3 signature and JSON-output text retained verbatim in a "Previous version" block.

---

## 4. #694 — bc-2-issue-read.md — DOCS-ONLY, no BC body change

Per human ruling and the research brief's own conclusion (all three reporter claims — stale
parent `about` string, undocumented batch SHA-1 naming, undocumented filter-before-sort-before-
truncate order — verified CONFIRMED against source, with the underlying BCs, BC-2.7.010 and
BC-2.7.008/BC-2.7.009, already specifying the true behavior correctly), this is a pure help-text
sync in `src/cli/mod.rs` clap doc comments. No BC body was touched. A single frontmatter changelog
line (`v1.3.180`) was added recording the sync, following the file's own established "0 new
BCs — help-text sync to BC-…" convention (already used for prior docs-only passes in this same
file, e.g. v1.3.97, v1.3.102). `bc-2-issue-read.md`'s BC count is unchanged (66 definitional /
108 total).

---

## Adversary Pass-1 Fix Round (2026-08-13)

A fresh-context adversarial review of this delta returned 0 HIGH, 3 MEDIUM, 3 LOW, 1 INFO
actionable findings (plus 1 INFO requiring no spec edit, carried to the F4 test-writer instead).
All 7 actionable findings were fixed in place in the same BC bodies described above:

- **MEDIUM-1** (#692): BC-3.4.021's `STATUS: UPDATED` note now states explicitly, in-body, that
  **DEC-274 is RATIFIED AT THIS F2 GATE** (not merely proposed) — closing a self-consistency gap
  where the BC cited DEC-274 as settled while STATE.md still carried it PENDING. (STATE.md's own
  flip to RATIFIED is finalized by the state-manager at F2 commit — not performed by this pass.)
- **MEDIUM-2** (#663): New EC-1.2.047-4 + VP-663-003 on BC-1.2.047 — the guard keys ONLY on the
  `--profile` CLI flag (`cli.profile.is_some()`), never on `JR_PROFILE`/config default/the
  resolved active profile. `JR_PROFILE=X jr auth switch NAME` (flag absent) is NOT rejected. This
  protects the direnv-scoped-sandbox workflow (CLAUDE.md `JR_PROFILE` doc).
- **MEDIUM-3** (#693): BC-X.8.009 now states explicit degrade-not-hard-fail semantics for the
  `--id` path's auxiliary `list_queues` lookup: on failure (5xx/401/network) or no matching id,
  `extra_fields` degrades to `&[]` (pre-#693 behavior) rather than the command hard-failing. New
  EC-X.8.009-1; Errors clause scoped to exclude this auxiliary call.
- **LOW-1** (#693): New EC-X.8.009-2 for "queue `fields[]` non-empty but every entry filters out
  to nothing → `extra_fields = &[]`"; `BASE_ISSUE_FIELDS` membership filter pinned
  CASE-INSENSITIVE (so `fixversions` vs. the constant's `fixVersions` doesn't slip through as a
  spurious extra field).
- **LOW-2** (#663): BC-1.2.018 title/Behavior clarified — `auth list` and `auth remove` ALSO honor
  `--profile` (direct pass-through, no `.or()` composer, since they have no subcommand-level
  `--profile` field to compose against); `auth switch` is the sole exception for REJECTION, not
  the sole subcommand that propagates.
- **LOW-3**: this section (see below).
- **INFO-1** (#692): New EC-3.4.021-17 on BC-3.4.021 — `--description-stdin --dry-run` with empty
  stdin → `plannedChanges.description=""`, `plannedChanges.descriptionAdf = text_to_adf("")`,
  table shows the render-OK line. Mirrors the live-path EC-3.4.013-13.
- **INFO-2**: no spec edit — carried to the F4 test-writer as guidance (keep the byte-identity
  comparison basis against the `adf.rs` entry-point output for the `--markdown` variant too).

## Acceptance Note for F3/Release — Breaking Product-Behavior Changes (LOW-3)

**This note exists to survive the F2→F3→release handoff without being lost; F3 story writers
MUST carry it into the stories for #663 and #692 as an explicit acceptance criterion or release
checklist item.**

Two of the four changes in this bundle are BREAKING changes to previously-shipped, user-facing CLI
behavior, independent of this spec-changelog's own MINOR/PATCH axis (which classifies by
spec-document shape, not product-semver — see `.factory/spec-changelog.md` [1.3.180]'s "Version
bump rationale" section for why that axis is MINOR, not MAJOR, and why that does NOT mean the
underlying product change is non-breaking):

1. **#663**: `jr auth switch --profile <X> <NAME>` changes from a silently-accepted no-op
   (exit 0, `--profile`'s value ignored) to a hard rejection (exit 64). Any existing script or
   alias that happened to pass `--profile` to `auth switch` will now fail where it previously
   (confusingly) succeeded.
2. **#692**: `jr issue edit --dry-run --description-stdin --output json` changes
   `plannedChanges.description` from a fixed literal placeholder string
   (`"<from stdin — not yet read in dry-run>"`) to the actual piped stdin content, and adds a new
   `plannedChanges.descriptionAdf` field. Any automation asserting on the literal placeholder
   string will observe a different value.

**Required at release, NOT performed by this F2 pass:** both changes need `Breaking:` entries in
the product's own `CHANGELOG.md` (distinct from `.factory/spec-changelog.md`) at the release that
ships them, per the project's documented "Errors: always suggest what to do next" /
migration-note convention used elsewhere for breaking changes (e.g. DEC-188/S-639-1's
`--field`/`--on-behalf-of` pre-flight promotion, issue #639). F3's story files for these two
issues should each carry a `breaking_change: true`-equivalent marker (mirroring `S-639-1.md`'s
precedent) and an explicit acceptance criterion requiring the `CHANGELOG.md` `Breaking:` entry
before the story is considered complete — do not let this obligation be implicit or assumed
carried by memory alone.

---

## Cross-Issue / Cross-File Consistency

- All four spec files touched are file-disjoint (confirmed by the F1 delta analysis): #692 →
  `bc-3-issue-write.md` only; #663 → `bc-1-auth-identity.md` only; #693 → `cross-cutting.md` only;
  #694 → `bc-2-issue-read.md` only (changelog-only).
- No cross-BC contradiction introduced: BC-3.4.013 (raw-input invariant) and BC-7.2.012 (depth
  guard) are cross-referenced from the amended BC-3.4.021 but their own bodies are untouched, and
  their behavior is confirmed unchanged (only newly reachable from a different call site, in the
  depth guard's case).
- `scripts/check-spec-counts.sh` exits 0 across all 7 `bc-*.md` files in `.factory/specs/prd/`
  after all four edits.
