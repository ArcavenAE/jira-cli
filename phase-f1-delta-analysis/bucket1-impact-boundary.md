---
document_type: f1-impact-boundary
cycle: bucket1-defects
producer: architect
timestamp: 2026-08-13
status: complete
---

# F1 Impact Boundary — Bucket 1 (issues #692, #663, #693, #694)

Fresh-eyes cross-check of four research briefs against the current `develop` tip
(`1a298e24`). Source files re-read directly (not taken on the briefs' word) for every
symbol cited below. Where I disagree with a brief or found something it missed, it is
called out explicitly in each issue's §5 and in §5 (bundle-wide).

---

## Issue #692 — `issue edit --dry-run` doesn't read stdin / can't preview ADF

### 1. Affected components

| Component | Classification | Citation |
|---|---|---|
| `src/cli/issue/edit.rs::handle_edit` (dry-run short-circuit block, both `OutputFormat::Json` and `OutputFormat::Table` arms) | **MODIFIED** | the two `else if description_stdin` branches inside `if dry_run { … }`, confirmed at `handle_edit` lines ~468 (JSON) and ~544 (table) in the current tree |
| `src/adf.rs::markdown_to_adf` / `src/adf.rs::text_to_adf` | **DEPENDENT** (called, not changed) | already `pub fn`; dry-run block will call the same selection logic the live path uses (`handle_edit` § "Resolve description") |
| `.factory/specs/prd/bc-3-issue-write.md` (BC-3.4.021) | **MODIFIED (spec)** | Invariant 3, json-postconditions #3, table-postconditions #3, EC-3.4.021-6 all currently encode the *old* behavior as correct |
| `.factory/specs/prd/bc-3-issue-write.md` (BC-3.4.013, #398) | **DEPENDENT** (cross-reference only) | must confirm the fix doesn't disturb the raw-input invariant for `plannedChanges.description` |
| `tests/` — dry-run integration tests exercising `--description-stdin --dry-run` | **DEPENDENT** | will need new/updated assertions once stdin is actually read |

No new file, module, or struct is required. Confirmed: no `jr adf render` primitive, no
new CLI flag, no new type.

### 2. Structural vs internal

**INTERNAL.** No new CLI surface, no new subcommand, no new interface. The brief's
"Option (a)" fix (recommended, and the only one I'd also recommend) adds one new JSON
field (`plannedChanges.descriptionAdf` or equivalent) inside an existing envelope and
reuses two already-`pub` functions. I agree with the brief that "Option (b)" (a
standalone `jr adf render` command) is genuinely out of scope — it doesn't fix the
reported defect and would be new top-level surface requiring its own BC cluster.

One nuance the brief slightly underplays: this is not *purely* internal in the spec
sense — it is a **decision reversal** (BC-3.4.021 Invariant 3 currently asserts the
placeholder behavior is "correct… not a bug"). Structurally the code change is small
and internal; but process-wise it needs the F1/F2 human gate to explicitly record the
reversal, not just an amend-in-place edit, or an adversary pass in F5 will flag an
unexplained contradiction between old and new spec text. I'd flag this as the single
highest-risk item in the whole bundle, not because the code is risky, but because it's
the one place a BC is being overturned rather than extended.

### 3. Module criticality

No formal `module-criticality.md` exists in this repo (checked `.factory/specs/` —
only `ARCH-INDEX.md`, no criticality classification file). Using ARCH-INDEX's subsystem
registry: `src/cli/issue/edit.rs` and `src/adf.rs` are SS-02 (CLI Layer) / SS-08
(Cross-cutting Utilities). `edit.rs` is a **state-mutating command path** (issue edit
POSTs/PUTs to Jira on the live path) and is explicitly called out in CLAUDE.md's "Known
Size Deviations" as a large, heavily-guarded module (2,067 LOC, ADR-0012 exception).
I'd informally rate it **HIGH** (mutation surface, dry-run is the sole non-destructive
preview path, DEC-188 pre-flight guards live here) but not CRIT — no secrets, no auth,
no network trust boundary is touched by this specific fix; it only adds a stdin read +
ADF render inside a code path that already returns before any HTTP call. Security
review is not mandatory for this one; a careful code reviewer + the existing dry-run
test suite is sufficient.

### 4. Cross-issue interactions

None. No other bucket issue touches `src/cli/issue/edit.rs`, `src/adf.rs`, or
`bc-3-issue-write.md`.

### 5. Agreement / disagreement with the brief

Agree with scope and BC impact as stated. One addition: the brief's §3.2 recommends the
ADF preview go in a new **sub-key of `plannedChanges`** rather than a new top-level key,
specifically to avoid touching BC-3.4.021's "exactly three top-level keys" pin. I'd make
this a hard constraint, not just a recommendation — if F2/F4 instead choose a top-level
key, that pin test (`plannedChanges` json-postconditions #1) becomes a second BC edit
that isn't currently scoped, and it's avoidable. Also worth having F4 add a regression
test for the `markdown_to_adf` depth-guard `Err` surfacing as exit 64 *in dry-run*
specifically — brief already calls this out (§4 Option (a) step 4) and I concur it's the
one new edge case worth a dedicated test, since it's the exact "catch a rejection before
writing" case the issue is about.

### 6. Recommended file-change surface

**Likely MODIFIED:**
- `src/cli/issue/edit.rs` (dry-run block, both output-format arms)
- `.factory/specs/prd/bc-3-issue-write.md` (BC-3.4.021 amend-in-place + reversal note)
- `tests/` integration test(s) covering `issue edit --dry-run --description-stdin`

**Regression baseline (NOT changed):** `src/adf.rs` itself, the live (non-dry-run) edit
path, `src/cli/issue/edit.rs`'s bulk/multi-key paths, BC-3.4.013 body text (cross-ref
only), all other issue-edit flags (`--field`, `--label`, `--type`, `--points`, etc.).

---

## Issue #663 — `auth switch --profile` is a confusing no-op; usage-string divergence

### 1. Affected components

| Component | Classification | Citation |
|---|---|---|
| `src/main.rs` (the `cli::AuthCommand::Switch { name } => …` dispatch arm) | **MODIFIED** | confirmed at `run()`'s `Command::Auth` match, `AuthCommand::Switch` arm — currently `cli::auth::handle_switch(&name, cli.profile.as_deref(), &cli.output).await` with no guard |
| `src/cli/auth/switch.rs::handle_switch` | **MODIFIED (alternative site)** | either this file or `main.rs` gets the new exit-64 guard — one or the other, not both |
| `.factory/specs/prd/bc-1-auth-identity.md` (BC-1.2.018) | **MODIFIED (spec)** | amend to carve out `auth switch` as the exception |
| `.factory/specs/prd/bc-1-auth-identity.md` (new BC) | **NEW (spec)** | "`auth switch --profile <X>` exits 64" |
| `src/cli/mod.rs` (`Cli.profile` global flag doc, `AuthCommand::Switch { name }` variant) | **DEPENDENT** | unaffected in code (brief's Option 3 does not touch clap attributes); a CLAUDE.md gotcha note is warranted but that's documentation, not this struct |
| `src/config.rs::validate_profile_name` | **DEPENDENT** | unaffected; the guard fires before/independent of this existing profile-name validator (confirmed at `main.rs::run` line ~160, already called for `cli.profile` unconditionally before dispatch) |

Confirmed independently: `AuthCommand::Switch { name: String }` has no subcommand-level
`profile` field (unlike `Login`, `Status`, `Refresh`, `Logout`, which all declare
`profile: Option<String>` and compose `profile.or_else(|| cli.profile.clone())` at the
`main.rs` dispatch site). The Switch arm is the only auth-subcommand branch that ignores
`cli.profile` entirely today — consistent with the brief's read.

### 2. Structural vs internal

**INTERNAL.** No new CLI flag, no clap attribute change (brief correctly rejects
`hide`, aliasing, and leans away from relying on `conflicts_with` alone). A single
runtime guard (`if cli.profile.is_some() { return Err(JrError::UserError(...)) }`) at an
existing dispatch site. I agree with the brief's Option 3 and its rejection of Options
1a/1b/2 — this repo already has the identical precedent (DEC-188 exit-64 pre-flight
guards in `issue create`, explicitly documented in CLAUDE.md as "MUST NOT be implemented
via clap attributes — that yields exit 2, not the required exit-64 UserError"). This is
the same pattern, same rationale, applied to a different command.

### 3. Module criticality

`src/main.rs` and `src/cli/auth/` are SS-01 (Entry Point) / SS-02 (CLI Layer). No formal
criticality file exists. I'd rate this **MEDIUM**, not HIGH/CRIT: the change adds a
*rejection*, not a loosening — it makes an existing no-op flag into a hard error. It
does not touch keychain, OAuth token handling, or `Config::save_global`'s actual write
logic (unchanged — still keyed off the positional `name`). Security review is not
warranted; this is a pure UX/correctness guard. The one thing I'd want a human eye on
(not necessarily a security-reviewer) is that the guard fires *before* `Config::load_with`
does its existence-check side effect on `cli.profile` (brief §1.4) — otherwise a user
could get a confusing "unknown profile" error from the config loader before ever
reaching the new, clearer guard message. Recommend the guard fire first, at the
`main.rs` dispatch arm, before `handle_switch` is called at all — that also makes it
the cheaper of the brief's two candidate sites (avoids constructing/loading config
unnecessarily on the rejected path).

### 4. Cross-issue interactions

None with #692 or #693. **File-level (not line-level) overlap with #694**: both this
issue and #694 touch `src/cli/mod.rs` if a CLAUDE.md/doc note is added near the global
`--profile` flag definition (line ~47) — but #694's edits are far away (Attachment
subcommand doc comments, lines ~651–880) and this issue's actual code fix doesn't
require touching `mod.rs` at all (the guard lives in `main.rs`/`switch.rs`). I don't
consider this a real merge-order risk; flagging only because both issues are in the
same bundle and a careless implementer might reach for `mod.rs` for both. Recommend
explicitly telling both story implementers their `mod.rs` edits (if any) are
comment-only and in disjoint regions, so parallel worktrees are safe.

### 5. Agreement / disagreement with the brief

Agree with the diagnosis, the rejection of Options 1a/1b/2, and Option 3 as the fix.
One scope-narrowing suggestion: the brief offers Option 1b's `conflicts_with = "profile"`
as an "optional belt-and-suspenders" secondary defense. I'd explicitly recommend
**against** adding it in this story — the brief itself documents it as unreliable for
`global = true` args (clap #5335, #5358) and *incomplete* (doesn't cover the
flag-without-positional case, which is the exact case that produces the confusing third
usage string). Adding a defense that doesn't fully work and is documented as flaky
increases test surface for zero net benefit; the runtime guard alone fully closes the
gap. If a future maintainer wants the clap-level belt-and-suspenders, that's a separate,
optional follow-up — not part of this fix's regression baseline.

I also agree with the brief's call to accept the `<NAME>` vs `[OPTIONS] <NAME>`
divergence as universal clap behavior and not chase `override_usage`. Nothing to add
there.

### 6. Recommended file-change surface

**Likely MODIFIED:**
- `src/main.rs` (Switch dispatch arm — new guard, preferred site per §3 above)
- `.factory/specs/prd/bc-1-auth-identity.md` (amend BC-1.2.018 + add new BC)
- CLAUDE.md (one-line gotcha, per brief §4 recommendation)
- `tests/auth_profiles.rs` or sibling — new exit-64 assertion + `--output json` envelope test

**Regression baseline (NOT changed):** `src/cli/auth/switch.rs::handle_switch_in_memory`
(the actual write logic), `src/config.rs::validate_profile_name`, every other
`AuthCommand` variant's `profile.or_else(...)` composition, `src/cli/mod.rs` clap
attribute definitions (no `hide`/`conflicts_with`/alias changes per the rejected
options).

---

## Issue #693 — `queue view` drops queue-endpoint custom fields, re-fetches a fixed field set

### 1. Affected components

| Component | Classification | Citation |
|---|---|---|
| `src/cli/queue.rs::resolve_queue_by_name` | **MODIFIED** | currently returns `Result<String>` (queue id only, confirmed at line ~144-158); must be changed or supplemented to also surface the resolved `Queue` (for its `.fields`) |
| `src/cli/queue.rs::handle_view` | **MODIFIED** | confirmed at lines 66-116: step 2's `search_issues(&jql, Some(keys.len() as u32), &[])` call passes an empty `extra_fields` slice — this is the literal site to change |
| `src/api/jsm/queues.rs::get_queue_issue_keys` | **DEPENDENT (unchanged)** | confirmed it already discards `fields` by design (doc comment: "we only need the key for the two-step fetch") — brief's Option 2 does NOT need to change this function, since the queue metadata (`Queue.fields`) is obtained separately via `list_queues`/`resolve_queue_by_name`, not via `get_queue_issue_keys` |
| `src/types/jsm/queue.rs::Queue.fields` / `QueueIssueKey` | **DEPENDENT (unchanged)** | `Queue.fields: Option<Vec<String>>` already exists and is deserialized; no struct change needed |
| `src/api/jira/issues.rs::search_issues` | **DEPENDENT (unchanged)** | already accepts an `extra_fields: &[&str]` (or similar) parameter — confirmed `BASE_ISSUE_FIELDS` + `extra_fields` extension mechanism exists at line ~154-165; #693's fix is purely a *caller-side* change (queue.rs passing a non-empty slice), not a `search_issues` signature change |
| `src/types/jira/issue.rs::IssueFields.extra` (`#[serde(flatten)]`) | **DEPENDENT (unchanged)** | confirmed flatten with no `skip_serializing` — custom fields requested via `extra_fields` already round-trip to JSON with zero formatter change |
| `.factory/specs/prd/cross-cutting.md` (BC-X.8.009) | **MODIFIED (spec)** | step-3 fetch-pipeline contract + JSON-output clause both need amendment |

### 2. Structural vs internal

**INTERNAL.** No new type, no new endpoint, no new CLI flag. This is exactly what the
brief frames it as: threading an existing `Queue.fields` value into an existing
`extra_fields` parameter that `search_issues` already accepts. I independently confirmed
`search_issues`'s signature already has an `extra_fields` slice parameter (used
elsewhere, e.g. `--points`/`--assets` style extensions per CLAUDE.md), so Option 2
requires zero interface changes — only a caller-side value change plus a small filter
step (drop pseudo-tokens like `issuekey` and anything already in `BASE_ISSUE_FIELDS`
before passing the rest through).

I agree with the brief's rejection of Option 1 (render directly from queue `fields`,
skip `search_issues`) — verified independently that `format_issue_row`/`issue_table_headers`
consume a typed `Issue`, not a raw `HashMap<String, Value>`, so Option 1 would need a new
render path in addition to risking blank Status/Priority/Assignee columns for queues not
configured to show them. Option 2 is materially smaller blast radius and I concur it's
the right call.

### 3. Module criticality

SS-05 (JSM API Resources) / SS-02 (CLI Layer), read-only command (`queue view` issues no
mutating HTTP calls). No criticality file exists; I'd rate this **LOW-MEDIUM** — it's a
read path, additive (more fields surfaced, not fewer), and the existing `extra_fields`
mechanism is already exercised by other commands. Security review not warranted.

### 4. Cross-issue interactions

**None of the other three bucket issues touch `src/api/jira/issues.rs`,
`src/api/jsm/queues.rs`, `src/types/jsm/queue.rs`, or `src/cli/queue.rs`.** This is the
one issue in the bundle with a fully isolated file set — safe for parallel worktree
delivery with zero merge-order concern relative to #692/#663/#694.

One thing worth flagging for the *next* delta analysis (not this one): the brief
correctly notes #693 and #575 (a separate, already-known issue for user-supplied
`--fields` CSV) share the same `extra_fields` plumbing on `search_issues`. If #575 is
ever bundled into the same wave as #693, sequencing matters (whichever lands first
should leave a clean seam for the other to union its fields in) — but #575 is not part
of this bucket, so it's out of scope here. Noting it so F2/F3 don't lose the thread.

### 5. Agreement / disagreement with the brief

Agree with Option 2 as the fix and with treating Option 1 as a rejected alternative, not
a compromise. One thing I'd narrow relative to the brief: §6 of the brief notes the
`--id` path needs an extra `list_queues` call to obtain `Queue.fields` (since
`resolve_queue_by_name`'s Queue object is only available on the by-name path today). I'd
make explicit in F2/F3 scoping that this is a **real extra HTTP call on the `--id` path
only**, not a wash — worth a one-line note in the amended BC-X.8.009 so a future reader
doesn't assume both paths cost the same. Not a reason to change the fix, just a
precision point the brief mentions but doesn't carry into its BC-impact section.

I'd also explicitly scope OUT (agreeing with the brief's §6) any table-column work for
custom fields — the fix is JSON-only surfacing, matching the issue's actual complaint.
Worth stating as an explicit non-goal in the story so F3/F4 don't scope-creep into
`--points`/`--assets`-style column plumbing.

### 6. Recommended file-change surface

**Likely MODIFIED:**
- `src/cli/queue.rs` (`resolve_queue_by_name` return-shape change or a sibling helper;
  `handle_view` step 2 `extra_fields` argument)
- `.factory/specs/prd/cross-cutting.md` (BC-X.8.009 amendment)
- `tests/` — queue view integration test(s) asserting custom fields appear in
  `--output json`

**Regression baseline (NOT changed):** `src/api/jsm/queues.rs::get_queue_issue_keys`
(pagination/key-extraction unchanged), `src/types/jsm/queue.rs` structs (no field
changes), `src/api/jira/issues.rs::search_issues` signature (no change, only a
caller-side argument value), `format_issue_row`/`issue_table_headers` (table output
unchanged — 6 columns as today), BC-X.8.008 (`queue list`, unaffected).

---

## Issue #694 — attachment help-text / doc-comment gaps

### 1. Affected components

| Component | Classification | Citation |
|---|---|---|
| `src/cli/mod.rs` — `IssueCommand::Attachment` doc comment (parent `about`) | **MODIFIED (doc only)** | confirmed at line 651: `/// Attachment operations: list. (S-576-1)`, stale — `AttachmentSubcommand` (line 741) has 4 variants: `List`, `Download`, `Upload`, `Delete` |
| `src/cli/mod.rs` — `AttachmentSubcommand::Download.out_dir` doc comment | **MODIFIED (doc only)** | confirmed near lines 786-790; needs one sentence on the `<sha1(id)>_<sanitized-filename>` batch naming scheme |
| `src/cli/mod.rs` — `AttachmentSubcommand::Download.newest` doc comment | **MODIFIED (doc only)** | confirmed near lines 773-779; needs one sentence on filter-before-sort-before-truncate order |
| `src/cli/issue/attachments.rs::sha1_hex`, `compute_default_output_path`, `handle_batch_download` | **DEPENDENT (unchanged)** | verified as the actual implementation the new doc text describes; no logic change |
| BC-2.7.010, BC-2.7.007/008, `bc-2-issue-read.md` line ~705 | **DEPENDENT (unchanged)** | brief confirms behavior is already correctly specified; no BC body edit required |

### 2. Structural vs internal

**INTERNAL, and narrower than internal — this is documentation-only.** No behavior
change, no new field, no new type, no new interface. I independently re-verified all
three of the brief's claim-by-claim confirmations against the source (the stale `about`
string, the `sha1_hex`/`compute_default_output_path` SHA-1-of-id scheme, and the
filter-then-sort-then-truncate order in `handle_batch_download`) and found nothing to
correct. This is the cleanest, lowest-risk issue in the bundle.

### 3. Module criticality

Doc-comment-only edits inside `src/cli/mod.rs` (clap derive definitions, SS-02). **LOW**
criticality by any measure — no logic path is touched, so there is nothing for a
security reviewer or even a close functional reviewer to check beyond "does the new
help text accurately describe existing, unchanged behavior." A straightforward code
review is sufficient; this should be the fastest story in the bundle.

### 4. Cross-issue interactions

**File-level overlap with #663** on `src/cli/mod.rs` only (see #663 §4) — not a real
conflict, since #694's edits are confined to the `AttachmentSubcommand` region
(lines ~651-880) and #663's code fix doesn't require touching `mod.rs` at all in the
recommended (main.rs-guard) design. No overlap with #692 or #693.

### 5. Agreement / disagreement with the brief

Agree fully with the brief's scope and its "no BC amendment required" conclusion — the
underlying BCs (BC-2.7.010, BC-2.7.007/008, and the `bc-2-issue-read.md:705`
filter-before-top-N clause) already assert the true behavior; this issue only syncs
help text to match. I'd endorse the brief's suggested convention (a one-line changelog
note in `bc-2-issue-read.md`'s frontmatter history: "0 new BCs — help-text sync to
BC-2.7.010/BC-2.7.008 for #694") over silently touching nothing, so there's a paper
trail linking the doc change to the issue without inflating BC counts. No scope changes
to recommend.

### 6. Recommended file-change surface

**Likely MODIFIED:**
- `src/cli/mod.rs` (three doc-comment edits: `Attachment` parent `about`, `out_dir` help,
  `newest` help)
- `.factory/specs/prd/bc-2-issue-read.md` (frontmatter changelog line only, no body change)

**Regression baseline (NOT changed):** everything in `src/cli/issue/attachments.rs`
(all logic — `sha1_hex`, `compute_default_output_path`, `handle_batch_download`,
`handle_single_download`, filter/sort/truncate order), all attachment tests, all other
`src/cli/mod.rs` content outside the three named doc comments.

---

## Bundle-wide summary

### Structural vs internal (all four)

| Issue | Verdict | New CLI surface? | New BC number? |
|---|---|---|---|
| #692 | INTERNAL (with a **spec-reversal** flag) | No | No — amend BC-3.4.021 in place |
| #663 | INTERNAL | No (runtime guard only) | Yes — one new BC (+ amend BC-1.2.018) |
| #693 | INTERNAL | No (reuses existing `extra_fields` param) | No — amend BC-X.8.009 in place (F1 may prefer a new sub-BC; not required) |
| #694 | INTERNAL (docs-only) | No | No — no BC body change; changelog note only |

No issue in this bundle requires a new module, new public interface, or new CLI
subcommand/flag. This is a genuinely low-structural-risk bundle.

### Cross-issue file/module coupling

- **No two issues share a Rust source file with overlapping logic.** `src/cli/mod.rs`
  is touched by both #663 (optionally, doc-only, not required by the recommended fix)
  and #694 (required, doc-only) — but in disjoint regions (`AuthCommand`/global-flag
  area vs. `AttachmentSubcommand` area), so this is not a real merge conflict risk. Safe
  for parallel worktrees; no forced sequencing.
- **No issue touches `src/api/jira/issues.rs`'s `search_issues`/`BASE_ISSUE_FIELDS`
  except #693**, and #693's change there is a caller-side argument value in
  `src/cli/queue.rs`, not a signature or constant change — so even #693 doesn't create a
  shared-file risk with anything outside its own issue.
- **Spec files are fully disjoint**: #692 → `bc-3-issue-write.md`; #663 →
  `bc-1-auth-identity.md`; #693 → `cross-cutting.md`; #694 → `bc-2-issue-read.md`
  (changelog-only). No spec-file collision.

**Recommendation: all four stories can be delivered in isolated worktrees with no
merge-order dependency between them.** This bundle has none of the shared-file coupling
risk that would force sequential delivery.

### Scope disagreements / additions vs. the briefs

1. **#692** — agree with scope; elevated the "decision reversal" framing from a risk
   note to a hard process requirement (F1/F2 must explicitly record the BC-3.4.021
   Invariant 3 reversal, not amend-in-place silently) since it's the one item in this
   bundle an adversary pass is likely to flag if under-documented.
2. **#663** — agree with the fix; recommend explicitly **dropping** the brief's
   "optional belt-and-suspenders" `conflicts_with` idea from scope rather than leaving it
   as an option, since the brief's own sources show it's unreliable and incomplete for
   this exact case. Also recommend the guard fire at `main.rs` (pre-`Config::load_with`)
   specifically, not `switch.rs`, to avoid a confusing existence-check error preceding
   the new clear one.
3. **#693** — agree with Option 2; added the precision note that the `--id` path incurs
   a genuine extra `list_queues` HTTP call the `--name` path doesn't (brief mentions this
   as a risk but doesn't carry it into the BC-impact section — I'd make sure F2 does).
   Confirmed independently (not just cross-checked) that `search_issues` already exposes
   an `extra_fields` parameter, so this is a caller-only change with zero interface
   churn — smaller than the brief's own §1 "blast radius: smallest" framing already
   implies, worth stating outright.
4. **#694** — no disagreement; fully confirmed as docs-only, lowest-risk story in the
   bundle.

### Module-criticality caveat (applies to all four)

This repo has no formal `module-criticality.md` or `CRIT`/`HIGH` classification file —
only `ARCH-INDEX.md`'s subsystem registry (SS-01..SS-09), which doesn't carry a
criticality tier. All four criticality ratings above (#692 HIGH, #663 MEDIUM, #693
LOW-MEDIUM, #694 LOW) are informal judgments derived from CLAUDE.md's documented
security/mutation-surface notes (OAuth/keychain files are explicitly flagged elsewhere
as security-sensitive; none of that surface is touched by this bundle). **None of the
four issues touches secrets, tokens, keychain storage, or a network trust boundary** —
security-reviewer sign-off is not mandatory for any story in this bundle under F4's
CRIT-gated policy; standard code review is sufficient for all four. If the human wants a
durable criticality classification for future bundles, that's a separate, worthwhile
follow-up (not blocking this cycle).
