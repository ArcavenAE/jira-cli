# Documentation-Drift (Sweep 2) + Spec-Coherence (Sweep 7) — Findings

**Run date:** 2026-08-25
**Scope:** README.md, CLAUDE.md, stale-marker grep, FACTORY.md/docs broken refs, spec-count guard scripts, STORY-INDEX/BC-INDEX spot check.
**Mode:** Read-only. No files modified, no PRs opened.

**Environment note (not a doc-drift item):** local `develop` checkout is 1 commit
behind `origin/develop` (`git status -sb` → `behind 1`). The missing commit,
`00df3823` (PR #736, "chore(release): promote CHANGELOG Unreleased ->
0.7.0-dev.2"), bumps `Cargo.toml`/`Cargo.lock` to `0.7.0-dev.2` and matches the
already-published `v0.7.0-dev.2` GitHub release/tag (2026-08-25). Locally
`Cargo.toml` still reads `0.7.0-dev.1` — this is a stale local checkout, not a
repo inconsistency. A `git pull` resolves it. Not counted below.

---

## README

1. **[DRIFT — MEDIUM] Recently-added `issue list` filter flags undocumented.**
   The task's spot-check flags (`--fields`, `--updated-recent`, `--sort`) are
   real, shipped flags — confirmed in `src/cli/mod.rs` (`fields: Option<String>`
   at two arg sites, `sort: Option<String>`, `updated_recent: Option<String>`)
   and exercised throughout `src/cli/issue/list.rs` (BC-2.1.023/024/025,
   BC-2.2.033, BC-2.3.041/042 per BC-INDEX) — but **none of the three appear
   anywhere in README.md** (`grep -n -- "--fields\|--updated-recent\|--sort"
   README.md` → zero hits). The `jr issue list` row in the Commands table
   (README.md:253) only lists: `--assignee`, `--reporter`, `--recent`,
   `--status`, `--open`, `--team`, `--asset KEY`, `--jql`, `--limit`/`--all`,
   `--points`, `--assets`, `--duedate`.
   Also missing from that same row/table, on inspection: `--component`
   (S-606-1, shipped), `--created-after`/`--created-before`/`--updated-after`/
   `--updated-before` (all live in `NO_FILTERS_SPECIFIED_MSG`,
   `src/cli/issue/list.rs:66`, so they're real filter sources, just never
   promoted to the README table).
   **Fix:** add a bullet/sub-list or expand the `jr issue list` row with the
   missing flags; optionally add one `--fields`/`--sort`/`--updated-recent`
   example to the Quick Start / Everyday-commands block, mirroring the
   `--asset`/`--recent` examples already there. Auto-fixable (docs only).

2. **[DRIFT — LOW-MEDIUM] Windows/mise section is stale post-v0.6.0.**
   README.md:59-69 (mise install section) says:
   > "Windows users need `prerelease = true` for now: the current stable
   > (`v0.5.0`) shipped without a Windows asset, so a plain `@latest` resolves
   > to a release with no matching download until a Windows binary lands on a
   > stable tag (planned for `v0.6.0`)."

   Verified via `gh release list` and `gh release view v0.6.0 --json assets`:
   **`v0.6.0` is now the current stable release** (published 2026-08-13,
   labeled "Latest") and **does ship a Windows asset**
   (`jr-v0.6.0-x86_64-pc-windows-msvc.zip`) — the ADR-0016 Windows-build
   feature landed and shipped as promised. The paragraph's premise ("current
   stable is v0.5.0, no Windows asset yet, planned for v0.6.0") is now false;
   Windows users no longer need `prerelease = true`.
   **Fix:** update/remove this paragraph — state that stable releases ship a
   Windows asset as of v0.6.0. Auto-fixable (docs only).

3. **[COSMETIC — LOW] Version-pin examples reference `v0.5.0`.**
   README.md:35 (`sh -s -- v0.5.0`) and README.md:67 (`(`v0.5.0`) shipped
   without...`, covered by #2 above) still cite `v0.5.0` as an example/anchor
   version, three minor releases behind current stable (`v0.6.0`) and two dev
   lines behind the latest pre-release (`v0.7.0-dev.2`). Low priority — it's
   illustrative text, not incorrect syntax — but worth refreshing opportunistically
   when touching this section for finding #2. Auto-fixable (docs only).

4. **[NOTE — needs human judgment, NOT auto-fixable] `LICENSE` badge/link is
   broken — no LICENSE file exists in the repo.**
   README.md has a `[![License: MIT](...)](LICENSE)` badge (top of file) and a
   closing `## License\n\nMIT` section, but `ls LICENSE` → "No such file or
   directory" at repo root. The badge link 404s on GitHub. Per the user's
   standing instruction (license decision is deliberately deferred — do not
   add a LICENSE file without asking), this is **not** something to
   auto-fix by adding a license; flagging only so the human is aware the
   README currently asserts "MIT" with no backing file. Options: (a) add the
   LICENSE file if MIT is in fact the intended license, (b) soften the README
   claim until the license decision is finalized. Deferred to human.

No other install-step, quick-start, or command-table drift found; the rest of
the Commands table, Global Flags table, Configuration section, and Exit Codes
table were spot-checked against `src/cli/mod.rs` and matched.

---

## CLAUDE.md

5. **[DRIFT — LOW, confirmed via DEC-299] Stale "future Confluence... support"
   architectural line.**
   CLAUDE.md:129 reads:
   > "Product-namespaced `api/jira/` and `types/jira/` so future
   > Confluence/JSM/Assets support adds sibling directories."

   `.factory/STATE.md` (line 119, DEC-299, 2026-08-21) records a **standing
   scope decision**: Confluence content-modification is permanently OUT OF
   SCOPE for `jr` (issues #581/#669 closed not-planned on this basis), and
   explicitly calls out this exact CLAUDE.md line as owed a trim: *"CLAUDE.md's
   'future Confluence/JSM/Assets support adds sibling directories'
   architectural line should be trimmed to drop Confluence on the next
   CLAUDE.md edit."* This follow-up is still listed as an open/standing item
   in `.factory/STATE.md` as of the most recent checkpoint (2026-08-24) — it
   has not yet been done. Note: this is a **content-accuracy** trim (drop the
   word "Confluence" since it will never happen), not a line-length trim —
   worth recording precisely since the task framed it as "over-long."
   **Fix:** change to `"...so future JSM/Assets support adds sibling
   directories."` Auto-fixable (docs only), and the repo's own state already
   authorizes this exact edit.

6. **[DRIFT — MEDIUM] `cli/issue/list.rs` LOC figure is significantly stale.**
   CLAUDE.md's "Known Size Deviations" section states: *"`cli/issue/list.rs`:
   1,256 LOC post-split."* Actual: **`wc -l src/cli/issue/list.rs` → 2,012
   LOC** — 756 lines / ~60% higher than documented. The file has clearly grown
   substantially since that figure was last recorded (plausibly from the
   `list-read-ergonomics` bundle: `--fields`, `--updated-recent`, `--sort`,
   `--component`, all landed in this file per the BC-INDEX F2 log). Auto-fixable
   (docs only) — update the LOC figure; optionally note the contributing
   stories.

7. **[DRIFT — LOW-MEDIUM] `cli/issue/create.rs` LOC figure is stale.**
   CLAUDE.md states *"`cli/issue/create.rs`: 394 LOC post-Seam-B split."*
   Actual: **530 LOC** (+136, ~34% higher). Auto-fixable (docs only).

8. **[OK] Other "Known Size Deviations" figures are current:**
   - `cli/issue/edit.rs`: documented "~3,187 LOC" vs actual 3,186 — matches
     within rounding.
   - `cli/issue/workflow.rs`: documented "~1,277 LOC" vs actual 1,277 — exact
     match.
   - `cli/component.rs`: documented "~1,800 LOC" vs actual 1,796 — matches
     within the stated approximation.

9. **[DRIFT — LOW] `src/api/jsm/` module tree is missing one file.**
   CLAUDE.md's `src/` tree diagram lists `api/jsm/` as: `mod.rs`,
   `servicedesks.rs`, `queues.rs`, `request_types.rs`, `requests.rs`. Actual
   directory also contains **`src/api/jsm/attachments.rs`** (JSM two-step
   attachment upload path — `attach_temporary_file`, referenced elsewhere in
   CLAUDE.md's own "AI Agent Notes" under SEC-576-006/BC-3.9.006), which is
   absent from the tree diagram. Everything else in the `src/` tree was
   cross-checked file-by-file against `find src -type f -name "*.rs"` (114
   files) and matched exactly — this is the only omission found. Auto-fixable
   (docs only).

10. **[NOT FOUND — clarification] "Over-long Confluence architectural-line"
    wording in the task prompt.** No literal string "DEC-299" or "over-long"
    exists inside CLAUDE.md itself; DEC-299 and its exact wording live in
    `.factory/STATE.md` (see finding #5). Flagging so the distinction is clear
    for whoever actions this: the fix target is CLAUDE.md:129, the authority
    for the fix is `.factory/STATE.md`'s DEC-299 row, not any in-CLAUDE.md
    marker.

No other backtick-quoted file-path citations, ADR listing, or "AI Agent Notes"
env-var table entries were found to be stale on inspection (spot-checked
against `docs/adr/`, `docs/specs/`, and `src/` — all resolved).

---

## Stale markers

`grep -rn "TODO\|FIXME\|HACK" src/ | head -50` → **34 matches, all in
`src/adf.rs`, all false positives.** Every hit is the literal ADF task-item
state string `"TODO"` (as in `taskItem { state: "TODO" }`, GFM `- [ ]`/`- [x]`
mapping, BC-7.2.010) appearing inside comments and test assertions describing
Jira's ADF task-list schema — not a developer-left TODO/FIXME/HACK marker.
**Zero real stale markers found** in `src/`. No triage needed.

---

## Broken refs

- **FACTORY.md**: does not exist in this repo (`find . -iname "FACTORY.md" -not
  -path "./.git/*"` → no results). This is expected — `FACTORY.md` is a
  vsdd-factory *engine*-level file (read by agents from the engine repo), not
  a file the target project ships. Not a broken reference; noting only because
  the task asked to check it.
- **docs/ relative markdown links**: wrote a small script to extract every
  `](...)` local-file link across `docs/**/*.md` and check existence. Of 16
  local-file-shaped links found, all 12 "broken" hits were false positives —
  markdown-syntax examples in prose (e.g. `[t](url)`, `[text]({href})`, an
  ellipsis-prefixed `…/e2e.yml` in narrative text) illustrating ADF/link
  syntax, not real document links. **Zero real broken cross-doc links found**
  in `docs/`.
- **CLAUDE.md doc citations**: this repo already CI-guards this
  (`tests/claude_md_citations.rs`, per CLAUDE.md's own note) — spot-checked a
  ~13-file sample of `docs/specs/*.md` and `docs/superpowers/*.md` citations
  referenced from CLAUDE.md's "AI Agent Notes"/spec-list sections; all
  resolved. Deferring exhaustive re-verification to that CI guard, as
  instructed.
- **README.md → LICENSE**: see CLAUDE.md finding #4 above (broken badge/section
  link, no LICENSE file) — the one genuine broken reference found this sweep,
  filed under README rather than here since it's README's own link.

---

## Spec coherence (script results)

```
$ bash scripts/check-spec-counts.sh; echo "exit=$?"
Check passed: 8 bc files validated
exit=0

$ bash scripts/check-bc-cumulative-counts.sh; echo "exit=$?"
OK: all cumulative BC counts verified (707 total across 9 files; Surface H footer checked where present).
exit=0
```

Both guard scripts **PASS**. No BC/NFR/holdout frontmatter-vs-body drift
detected by the repo's own mechanical checks.

**STORY-INDEX / BC-INDEX spot check (light, per instructions — not an
authoritative recount):**

- `BC-INDEX.md` frontmatter `total_bcs: 707`, `index_version: v6.81`. Per-file
  cumulative/individually-bodied counts in the frontmatter `sections:` block
  are internally described in detail (range-collapsed vs individually-bodied
  BCs, explained in the file's own Preamble). A crude `grep -c "^| BC-"` /
  unique-ID regex pass produced numbers (497 rows, 393 unique IDs) that do
  **not** map 1:1 onto `total_bcs: 707` — but this is expected given the
  documented range-collapsed/individually-bodied distinction and multiple
  summary tables in the file; it is **not** a reliable drift signal from a
  naive grep, and the dedicated guard script above already validates this
  file's counts across 8 surfaces and passed. No action — deferring to the
  guard script per instructions to spot-check, not hand-recount.
- `STORY-INDEX.md` frontmatter: `total_stories: 156`, `version: "1.6.09"`.
  A file count (`find .factory/stories -type f -iname "*.md"`, excluding
  STORY-INDEX.md itself) returned **152** story files. This is a **~4-story
  gap** between the declared total and files on disk. Given how rigorously
  this repo tracks count provenance elsewhere (BC-INDEX has an 8-surface
  guard script; STORY-INDEX has none), this delta is flagged as a **LOW,
  unconfirmed** item for human triage — it may be explained by draft/planned
  stories not yet materialized as files, multiple logical stories sharing one
  file, or a genuine miscount, none of which a naive `find` can distinguish.
  Recommend a proper recount (or a `check-story-index-counts.sh`-style guard,
  mirroring the BC one) rather than trusting this grep. Not auto-fixable —
  needs a real reconciliation pass.

---

## Recommended actions

**Auto-fixable (docs only, `auto_pr=true` candidate):**
1. README: document `--fields`, `--updated-recent`, `--sort`, `--component`,
   and the `--created-after`/`--created-before`/`--updated-after`/
   `--updated-before` filters on `jr issue list` (finding #1).
2. README: update/remove the stale "current stable is v0.5.0, Windows planned
   for v0.6.0" mise paragraph now that v0.6.0 has shipped with a Windows asset
   (finding #2).
3. README: refresh the `v0.5.0` version-pin example to a current tag while
   touching #2 (finding #3, optional/opportunistic).
4. CLAUDE.md: drop "Confluence" from the `api/jira/`/`types/jira/` sibling-
   directories line per DEC-299 (finding #5) — this fix is already
   pre-authorized by the repo's own standing decision log.
5. CLAUDE.md: update `cli/issue/list.rs` LOC from 1,256 to 2,012 and
   `cli/issue/create.rs` from 394 to 530 in "Known Size Deviations" (findings
   #6, #7).
6. CLAUDE.md: add `attachments.rs` to the `api/jsm/` entry in the `src/` tree
   diagram (finding #9).

**Needs human judgment (not auto-fixable):**
- README `LICENSE` badge/section vs. missing `LICENSE` file (finding #4) —
  license decision is a standing deferral per user instruction; don't add a
  file, just flag the inconsistency for the human to resolve however they see
  fit.
- STORY-INDEX declared total (156) vs. on-disk file count (152) — needs a
  real reconciliation pass or a dedicated guard script, not a docs edit.

**No action needed:**
- Stale-marker grep: zero real hits (all `"TODO"`/`"DONE"` are ADF schema
  string literals, not developer markers).
- FACTORY.md: doesn't apply to this repo (engine-level file).
- docs/ broken links: zero real hits (all false positives from markdown-
  syntax examples in prose).
- Both spec-count guard scripts: PASS, no drift.
- CLAUDE.md's other file citations, `src/` tree entries, and "Known Size
  Deviations" figures for edit.rs/workflow.rs/component.rs: all current.

---

## Summary

- **10 findings logged** (5 README-related counting sub-items #1-4, 5
  CLAUDE.md-related #5-9, plus one clarification note #10).
- **6 are auto-fixable documentation edits** (README flags/Windows-mise text/
  version example, CLAUDE.md Confluence-line/LOC figures/jsm module tree).
- **2 need human judgment**: the LICENSE badge-vs-file gap (deferred per
  standing instruction) and the STORY-INDEX 156-vs-152 count gap (needs a
  real reconciliation, not a doc tweak).
- **Guard scripts both PASS** (`check-spec-counts.sh`,
  `check-bc-cumulative-counts.sh`) — no BC/NFR/holdout frontmatter-body drift.
- **Zero real stale code markers, zero real broken doc links.**
- No files were modified; this is a findings-only report.
