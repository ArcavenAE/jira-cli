---
document_type: research-brief
issue: 694
producer: research-agent
timestamp: 2026-08-13
status: complete
scope: documentation-only (clap help text + doc comments); no behavior change
verification: all three reporter claims confirmed against source at develop tip
---

# Research Brief — Issue #694: attachment help-text/doc gaps

## Summary (5–8 lines)

All three documentation gaps the reporter describes are REAL and confirmed against
the current source (`src/cli/mod.rs`, `src/cli/issue/attachments.rs`). (1) The
`attachment` parent `about` string is stale — `src/cli/mod.rs:651` reads
`/// Attachment operations: list. (S-576-1)` while four subcommands exist (List,
Download, Upload, Delete). (2) The batch-download filename scheme is a real
`<40-hex SHA-1>_<sanitized-filename>` prefix, and the SHA-1 input is the **attachment
id** (not the url, not the filename); it is undocumented in `--out-dir` help. (3) The
`--filter` → sort-by-`created`-descending → truncate-to-N order is exactly as the
reporter states and is undocumented in the `--newest` doc comment. This is pure
help-string/doc-comment work — the underlying BC specs already document the true
behavior, so **no BC amendment is required**. No behavior changes. The only CI risk is
the CLAUDE.md dead-citation guard, which does not apply to clap doc strings.

## Claim-by-claim verification

### Claim 1 — stale parent description (CONFIRMED)

- Site: `src/cli/mod.rs:651`, the doc comment on the `IssueCommand::Attachment` variant:
  `/// Attachment operations: list. (S-576-1)` — this is the clap `about` for
  `jr issue attachment --help`.
- The enum `AttachmentSubcommand` (`src/cli/mod.rs:741`) has exactly four variants:
  `List` (:743), `Download` (:759), `Upload` (:810), `Delete` (:869).
- Reporter's suggested replacement ("Attachment operations: list, download, upload,
  delete.") is accurate. Recommend keeping the `(S-576-1)` provenance tag or updating it
  to the multi-story range — a doc-only judgment call; the four-subcommand enumeration is
  the substantive fix.

### Claim 2 — batch filename scheme `<40-hex SHA-1 of id>_<filename>` (CONFIRMED)

- `sha1_hex` (`src/cli/issue/attachments.rs:410`) — "Compute the 40-character lowercase
  hex SHA-1 of a string" (doc comment at :408). Uses the `sha1` crate (`use sha1::Digest;`
  at :21).
- `compute_default_output_path` (`src/cli/issue/attachments.rs:537`) is the batch-only path
  builder. Line 542–546:
  - `sanitized = sanitize_attachment_filename(filename).unwrap_or_else(|| attachment_id.to_string())`
  - `let hash = sha1_hex(attachment_id);` ← **input to SHA-1 is the attachment id**
  - `base_dir.join(format!("{hash}_{sanitized}"))`
- So the on-disk basename is `<sha1_of_id (40 hex)>_<sanitized filename>` (degenerate name →
  `<sha1_of_id>_<attachment_id>`). **The attachment id is NOT in the path in plaintext** —
  only its SHA-1 digest is; confirmed the reporter's "id is not part of the path" claim.
- Cross-check with CLAUDE.md: matches "batch paths use a SHA-1 prefix that inherently
  disambiguates". The doc comment on `compute_default_output_path` (:519-525) already
  states the scheme internally — it is simply not surfaced to end users via `--out-dir` help.
- Single-file path is unaffected: `handle_single_download` (`:758`) builds a bare sanitized
  basename with `format!("_{sanitized}")`-style inline logic (:852) and the SEC-576-001
  Windows device-name escape; the doc comment at :527-531 explicitly warns not to consolidate
  it into the batch builder. So the reporter's "single-file `--id ... --out` unaffected" is
  correct.
- Manifest recovery: the JSON manifest's `path` field carries the as-constructed on-disk path
  (EC-2.7.007-7 / BC-2.7.010), so callers parse `path` to learn the real filename — exactly as
  the reporter says.

### Claim 3 — `--filter` before `--newest`, sort by `created` desc (CONFIRMED)

- `handle_batch_download` (`src/cli/issue/attachments.rs:921`). Order in the function body:
  1. **Filter first** (:966-970): `filtered = attachments.iter().filter(|a| parsed_filters.iter().all(|f| apply_filter(a, f))).collect()`.
  2. Filtered-to-zero short-circuit (:972-984).
  3. **Sort then truncate** (:986-1003), guarded by `if let Some(n) = newest_n`:
     - `filtered.sort_by(...)` comparing parsed `chrono::DateTime<FixedOffset>` of `a.created`
       vs `b.created`, returning `b_dt.cmp(&a_dt)` → **newest first (descending by `created`)**
       (:996). Unparseable dates sort last; both-unparseable falls back to a lexicographic
       tiebreak (:999).
     - `filtered.truncate(n)` (:1002).
- So the effective semantics are "the N newest MATCHING attachments" — filter predicates
  applied, then sort by `created` descending, then truncate to N. Reporter's line-range
  (966-1002) and description are accurate. Sort key = `created`; direction = descending. Note
  the sort is chrono-instant-based, NOT lexicographic (:986 comment, F5-R1-002) — worth a word
  if the doc mentions ordering precisely.
- `newest` arrives as `Option<i64>` (clap, `allow_negative_numbers`), converted to
  `Option<usize>` at :1204 (`newest.map(|n| n as usize)`); N ≤ 0 rejected earlier in the handler.

## Exact doc sites to amend

1. **Parent `about`** — `src/cli/mod.rs:651`, doc comment on `IssueCommand::Attachment`.
   Change `Attachment operations: list. (S-576-1)` → enumerate all four
   (list, download, upload, delete).
2. **`--out-dir` help** — `src/cli/mod.rs:786-790`, the `out_dir` field doc comment inside
   `AttachmentSubcommand::Download`. Add one sentence describing the batch naming scheme:
   files are written as `<40-char-SHA-1-of-attachment-id>_<sanitized-filename>`; the on-disk
   name is not predictable from `list` output — parse the JSON manifest's `path` to recover it;
   the attachment id itself is not in the path.
3. **`--newest` doc comment** — `src/cli/mod.rs:773-779`, the `newest` field doc comment inside
   `AttachmentSubcommand::Download`. Add one sentence: `--filter` predicates are applied BEFORE
   `--newest` truncation; the surviving set is sorted by `created` descending, then truncated to
   N — i.e. the N newest matching attachments.

(Optional, not requested but adjacent) `compute_default_output_path`'s doc comment already
documents the scheme; no change needed there. `--filter` help on `Download` (:792-795) could
gain a back-reference but the reporter scoped the order note to `--newest`.

## BC / spec impact — NONE required (docs-only, already covered)

- The batch SHA-1 naming is already specified in **BC-2.7.010** (`bc-2-issue-read.md`), and
  the single-vs-batch distinction in **BC-2.7.007/008** (line 805: "for single `--id` without
  `--out`, the default filename is the bare sanitized basename (no SHA-1 prefix)").
- The filter-before-top-N order is already specified: `bc-2-issue-read.md:705` states verbatim
  "The filter runs before top-N selection: `--newest 3 --filter mime=image/*` yields the 3 most
  recently created images (see BC-2.7.008/BC-2.7.009)."
- Because the specs already assert the true behavior, this issue is a pure help-string sync;
  F2 (spec evolution) can record it as a no-new-BC doc-fallout note rather than amending BC text.
  If F2 wants a paper trail, a one-line changelog entry in `bc-2-issue-read.md`'s frontmatter
  history (pattern: "0 new BCs — help-text sync to BC-2.7.010/BC-2.7.008 for #694") is the
  established convention, but no BC body text needs to change.

## Risks / inconclusive

- **No behavior mismatch found.** Every current-behavior statement the reporter makes matches
  the code exactly, so this stays a docs fix and does not become a behavior question.
- **CI dead-citation guard (`tests/claude_md_citations.rs`)**: applies ONLY to backtick file-path
  citations in `CLAUDE.md`, not to clap doc strings in `src/`. The three amendments live in
  `src/cli/mod.rs` doc comments, so they cannot trip that guard. If the fix also touches
  CLAUDE.md's attachment notes, keep any new backtick paths real (they already are).
- **BC-no-numeric-test-counts convention**: irrelevant here — no `Trace:`/`Source:` BC field is
  being edited.
- **Minor wording choice (non-blocking):** the `(S-576-1)` provenance tag on the parent `about`
  predates the download/upload/delete stories (S-576-2..5). Updating it to a range or dropping it
  is a style call for the implementer; the substantive requirement is the four-subcommand list.
- **Precision nit for the `--newest` sentence:** the sort is chrono-instant-based (RFC-3339
  parse), not lexicographic; unparseable `created` values sort last. Recommend the doc say
  "sorted by `created` (most recent first)" without over-promising lexical behavior.
