# Documentation Drift Findings — Sweep 2 (2026-09-10)

Read-only analysis. No fixes applied, no commits, no PRs. Repo: `jira-cli` @ `develop`
(HEAD `78aeb86c`, post PR #799). Special focus: verify PR #797 (`a1f37995`, CLAUDE.md
compaction 163KB→89KB) didn't drop or corrupt anything.

## Summary (counts by classification)

| Classification | Count |
|---|---|
| MANUAL — high severity (undocumented user-facing feature) | 1 |
| MANUAL — medium severity (stale/misleading reference doc) | 4 |
| MANUAL — low severity (spec wording drift, needs owner judgment) | 3 |
| FIXABLE-AUTOMATED (trivial text/list update) | 5 |
| LOG-ONLY (verified healthy, no action) | 4 |

**Bottom line on the PR #797 compaction:** it did NOT break anything checkable — the
`tests/claude_md_citations.rs` CI guard passes 61/61, and every `docs/adr/`,
`docs/specs/` path I spot-checked that CLAUDE.md cites still resolves. The drift found
below (Architecture tree gaps, stale ADR-0011 status, undocumented `jr field` command,
stale cycle-005 spec prose) is **pre-existing drift that predates or is orthogonal to
the compaction** — normal entropy from feature work landing without a doc-sync step,
not compaction damage. One structural gap is worth flagging to whoever owns
`claude_md_citations.rs`: that guard only proves cited paths *exist*; it cannot catch a
real `src/` file that CLAUDE.md's Architecture tree never mentions at all (see §2).

---

## 1. README.md vs actual CLI surface

Cross-checked `README.md`'s "Commands" table (56 `| \`jr ...\` |` rows) against the
`Command`/`*Subcommand` enums in `src/cli/mod.rs`.

### 1.1 [MANUAL — HIGH] `jr field options` command entirely undocumented

`src/cli/mod.rs` defines a top-level `Field { command: FieldCommand }` variant on the
`Command` enum, backed by `src/cli/field.rs` (implements `jr field options <field>` —
mode-selected enumeration of a custom field's allowed options via `--type` (M2
createmeta), `--request-type` (M3 JSM requesttype-fields), or `--issue` (M1 editmeta),
plus a client-side `--value` substring filter). It anchors **BC-X.14.001..004** (issue
#580) per the file's own header comment, referencing `ADR-0019 §1`.

This command is **not mentioned anywhere** in `README.md` (no `jr field` row in the
Commands table, no example) **or in `CLAUDE.md`** (no `cli/field.rs` in the Architecture
tree, no `BC-X.14`, `ADR-0019`, or `FieldCommand` reference anywhere in the file — grep
confirms zero hits in both files). This is a real, shipped, tested subcommand with its
own recursion-depth guard, degenerate-entry rendering rules, and mode-selector
semantics that a user or an AI agent has no way to discover from either doc.

**Fix scope**: add a `README.md` Commands-table row (`jr field options <NAME>`) and an
Architecture-tree line for `src/cli/field.rs` in `CLAUDE.md`. MANUAL because it needs a
human/spec-owner to write an accurate one-line description of the three mode selectors.

**Scope note**: I verified all 17 top-level `Command` variants exist in the README
table except `Field`. I did not do an exhaustive flag-by-flag diff for every
subcommand's `#[arg(...)]` list (that's a much larger effort) — spot checks (issue
list's `--component`, `--fields`, `--sort`, `--updated-recent`; auth switch's rejected
`--profile`) all matched README text correctly.

---

## 2. CLAUDE.md Architecture tree vs `src/` on disk

`find src -name '*.rs' | wc -l` → **116 files**. Diffed the full list against the
Architecture section's file tree. `tests/claude_md_citations.rs` passes (see §0 below)
but that guard only checks that *cited* paths resolve — it does not check that every
real file is *cited*. Five real source files are missing from the tree:

| File | Classification | Note |
|---|---|---|
| `src/cli/field.rs` | MANUAL (folds into §1.1 fix) | Backs the fully-undocumented `jr field` command |
| `src/cli/issue/mentions.rs` | FIXABLE-AUTOMATED | Ironically the *most*-cited file in CLAUDE.md's prose (mention-resolution gotchas cite `cli/issue/mentions.rs::resolve_mentions`/`filter_by_name_match` repeatedly) — just never added as a tree line under `cli/issue/` |
| `src/profile.rs` | FIXABLE-AUTOMATED | New top-level module (`Profile` newtype, ADR-0011 hard fence) — not in the tree, not mentioned in prose at all |
| `src/api/jira/tenant.rs` | FIXABLE-AUTOMATED | Implements the `fetch_cloud_id`/tenant_info lookup that CLAUDE.md's own `JR_TENANT_INFO_URL` gotcha row describes in prose, but the tree doesn't list `api/jira/tenant.rs` alongside its 14 siblings |
| `src/api/auth_windows_store.rs` | FIXABLE-AUTOMATED | Already cited in prose (`per src/api/auth_windows_store.rs's module header`, DPAPI-fallback gotcha) but absent from the `api/` tree block (which lists 7 top-level files, missing this 8th) |

Everything else diffed clean: `types/jira/*` (12/12), `types/jsm/*` (4/4),
`types/assets/*` (5/5), `api/assets/*` (6/6), `api/jira/*` (15 documented vs 16 actual
— the `tenant.rs` gap above), `api/jsm/*` (6/6), `cli/assets/*` (5/5), `cli/auth/*`
(9/9 + `tests/`), and the `cli/` top-level list (16 documented vs 17 actual — the
`field.rs` gap above).

---

## 3. `Key Decisions` section drift

### 3.1 [MANUAL — MEDIUM] ADR-0011 status line is stale

CLAUDE.md's Key Decisions list still reads:
> ADR-0011: Type-level Profile fence deferred — convention-based soft fence is
> sufficient for current team size (v0.5.x)

But `docs/adr/0011-type-level-profile-fence.md` was amended **2026-09-01** (DEC-317,
cycle-003 `auth-profile-dx`) to **Status: Accepted** — the deferred-trigger condition
("a related refactor creates a natural migration window") was met by the cycle-003
credential restructuring. The hard fence has since actually landed: `src/profile.rs`
(commit `b7e513f9`, PR #758, 2026-09-02) implements the `Profile` newtype and the
call-site sweep through `src/cache.rs`/`src/api/auth.rs`/`Config::active_profile_name`/
`JiraClient::profile_name`. CLAUDE.md's one-liner still describes the pre-2026-09-01
"deferred" world. FIXABLE-AUTOMATED (one-line text swap), but flagging as MEDIUM
severity since it misrepresents a completed architectural decision as still-deferred.

### 3.2 [MANUAL — MEDIUM] ADR-0017–0022 referenced in CLAUDE.md prose don't exist in `docs/adr/`

CLAUDE.md's gotchas prose cites `ADR-0017` (attachments multipart), `ADR-0018`
(component list/create/edit/delete/rename), and `ADR-0021` (Windows DPAPI fallback) by
bare number (no backtick file path, so `tests/claude_md_citations.rs` doesn't check
these). `docs/adr/` on disk only goes up to `0016-windows-build-target.md`. The actual
files live at `.factory/specs/architecture/decisions/ADR-0017-first-multipart-
streaming-http-surface.md` (and ADR-0018 through ADR-0022, confirmed present) — a
**separate, VSDD-factory-managed ADR track** with its own numbering that happens to
continue from `docs/adr/`'s sequence. `src/cli/field.rs` also cites `ADR-0019` (field
DX context-hint shape delimiter), same situation.

The Key Decisions section's intro line — "See `docs/adr/` for detailed rationale" —
doesn't mention this split, so a reader chasing "ADR-0017" from CLAUDE.md into
`docs/adr/` will not find it. Not a broken citation (no backtick path is given), but a
misleading omission. MANUAL: needs a decision on whether to (a) note the dual-track
system explicitly in the Key Decisions intro, or (b) migrate/mirror ADR-0017+ into
`docs/adr/` for a single source of truth.

---

## 4. `docs/` spot check

- `docs/adr/`: 16 files present (`0001`–`0016`), matching every number CLAUDE.md's Key
  Decisions list explicitly enumerates with a one-line summary. (ADR-0017+ gap is
  covered in §3.2, not a missing-file problem — those numbers were never promised to
  live in `docs/adr/` by an explicit file-path citation.)
- `docs/specs/`: 39 files present including `README.md`. Every `docs/specs/*.md` path
  I spot-checked (`attachments.md`, `cargo-mutants-policy.md`, `ci-gate-completeness.md`,
  `e2e-live-jira-testing.md`, `jsm-e2e-coverage.md`, `issue-move-resolution.md`,
  `adf-*.md` family, `list-rs-split.md`) resolves — consistent with
  `test_claude_md_citations_resolve_to_real_files` passing (see §0).

## 0. CI citation guard status

```
cargo test --test claude_md_citations
```
→ **61 passed; 0 failed; 0 ignored.** `test_claude_md_citations_resolve_to_real_files`
passes — every backtick-quoted file-path citation in CLAUDE.md resolves to a real file.
LOG-ONLY: guard is healthy post-compaction. (Its blind spot — doesn't catch *missing*
citations for real files, or bare ADR-number citations without a path — is noted
in §2's summary line and §3.2, not a defect in the guard itself, just its documented
scope.)

---

## 5. TODO/FIXME/HACK/XXX grep

```
grep -rnE "TODO|FIXME|HACK|XXX" src/ --include="*.rs"
```
→ **36 raw hits, 0 real ones.** Every hit is one of:
- The ADF task-list feature's literal state strings `"TODO"`/`"DONE"` (issue #471,
  `taskItem.attrs.state`) — 35 hits across `src/adf.rs`, all in code/comments/test
  assertions describing that literal wire value, not developer TODO markers.
- One `\u{XXXX}` in a rustdoc comment (`src/api/client.rs:1404`) describing Unicode
  escape-sequence *format* (`\u{XXXX}` as a placeholder pattern), not a code marker.

LOG-ONLY: zero actual outstanding TODO/FIXME/HACK comments in the codebase. No stale
issue references to chase.

---

## 6. Standing doc-hygiene items — status check

### CYCLE5-F7-DOC-1 — **STILL VALID, needs fix**

`.factory/phase-f2-spec-evolution/verification-delta-674.md`'s `VP-674-005` section
still reads:

> **STATUS — UNPROVEN AT F2, MECHANISM DEFERRED.** Whether an ADF `mention` node may
> legally carry `marks` ... is an Atlaskit `adf-schema` runtime question ... no static
> tool ... can answer it.

But this has since been empirically resolved: `src/adf.rs` (lines ~14066–14099) now
contains `test_bc_7_2_016_ec5_bold_wrapped_bracket_mention_carries_no_marks` and
`test_bc_7_2_018_ec5_italic_wrapped_at_name_mention_carries_no_marks`, both asserting
`mention_node.get("marks").is_none()` — i.e. the F4 empirical check landed and the
answer is "mention inherits no marks," confirming BC-7.2.016 point 5's original
assumption (no spec-companion-edit was needed). Git history shows cycle-005's mentions
feature reached full closure (`9cea3b61 factory(phase-7): cycle-005 adf-mentions F7
CONVERGED + CLOSED (DEC-353), no release`), yet the F2-era "UNPROVEN"/"MECHANISM
DEFERRED" §11 register entry and the VP-674-005 status line were never updated to
reflect the resolution. Classify **MANUAL** (touches a VSDD verification-delta
artifact; wants a spec-steward pass to update the status line + §11 register + cite the
two resolving tests) rather than automated, even though the actual edit is small.

### CYCLE5-F7-DOC-2 — **STILL VALID, lower confidence**

`ADR-0023-markdown-mention-pure-effectful-conversion-seam.md` discusses the `@Name`/
bracket-form boundary and charset rule at length (e.g. "boundary, `[~accountid:`, one
or more `[A-Za-z0-9:_-]` characters, closing `]`", "boundary/charset/skip-context
rules") but has no note tied to the later fix `dad7c7bf` / `cef4a021` (PR #795,
"F-M1: exclude `]` from @Name mention boundary") which changed the **`@Name`-form**
boundary character set (as distinct from the bracket-form charset the ADR text above
describes) after this ADR's Consequences section was written. I could not date the ADR
file precisely against PR #795's landing — `.factory/` artifacts live on a separate
factory-artifacts branch not visible to `git log` from `develop` in this worktree — so
I can't rule out the note already exists on that branch and simply isn't visible here.
Classify **MANUAL**: needs a spec-steward check against the factory-artifacts branch
history before editing.

### CYCLE5-STEP45-LOW-1 — **STILL VALID, needs fix**

`.factory/specs/prd/cross-cutting.md`'s BC-X.7.007 point 2 describes `filter_by_name_match`
as keeping "only the users whose `display_name` contains `query` as a case-insensitive
substring." The actual implementation (`src/cli/issue/mentions.rs::filter_by_name_match`)
does not do a bare substring test — it delegates to `partial_match::partial_match(query,
&display_names)` (the same fuzzy/prefix/exact-matching algorithm used elsewhere in the
CLI) and only keeps users whose name case-insensitively equals whichever candidate(s)
that algorithm's `Exact`/`ExactMultiple`/`Ambiguous` result selected. A later commit
(`7c9a52f6 fix(S-cycle5-mention-resolution-wiring): harmonize filter_by_name_match to
Unicode case fold (F1)`) further specializes the comparison to Unicode-aware
`to_lowercase()` folding, which the BC's "case-insensitive substring" phrasing doesn't
capture either. The wording undersells/mischaracterizes the actual mechanism. Classify
**MANUAL** (PRD wording, needs the BC owner to decide the precise replacement phrasing
rather than a mechanical find-replace).

---

## Files referenced in this analysis

- `/Users/zious/Documents/GITHUB/jira-cli/README.md`
- `/Users/zious/Documents/GITHUB/jira-cli/CLAUDE.md`
- `/Users/zious/Documents/GITHUB/jira-cli/src/cli/mod.rs`
- `/Users/zious/Documents/GITHUB/jira-cli/src/cli/field.rs`
- `/Users/zious/Documents/GITHUB/jira-cli/src/cli/issue/mentions.rs`
- `/Users/zious/Documents/GITHUB/jira-cli/src/profile.rs`
- `/Users/zious/Documents/GITHUB/jira-cli/src/api/jira/tenant.rs`
- `/Users/zious/Documents/GITHUB/jira-cli/src/api/auth_windows_store.rs`
- `/Users/zious/Documents/GITHUB/jira-cli/docs/adr/0011-type-level-profile-fence.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/architecture/decisions/ADR-0017-first-multipart-streaming-http-surface.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/architecture/decisions/ADR-0018-component-resolution-caching-mutation-strategy.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/architecture/decisions/ADR-0019-field-dx-context-hint-shape-delimiter.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/architecture/decisions/ADR-0021-windows-oauth-secret-storage-dpapi-fallback.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/architecture/decisions/ADR-0022-api-token-cloud-id-acquisition-tenant-info.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/architecture/decisions/ADR-0023-markdown-mention-pure-effectful-conversion-seam.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/phase-f2-spec-evolution/verification-delta-674.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/cross-cutting.md`
- `/Users/zious/Documents/GITHUB/jira-cli/.factory/specs/prd/holdout-scenarios.md`
- `/Users/zious/Documents/GITHUB/jira-cli/tests/claude_md_citations.rs`
