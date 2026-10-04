# FIX-P5-012 spec delta and implementer hand-off (cycle-014 F5 pass 11, human decision D-406)

Spec version 2.8.8 (PATCH). Spec-only on the spec side; the implementer items below are rustdoc only (P11-002, P11-003). The H1/BC-INDEX guard script was DEFERRED by human decision (D-406); follow-up issue. Code facts below were verified against `develop` `c33f5d44`.

## Spec changes already made (under `.factory/`)

| File | Change |
|---|---|
| `specs/prd/cross-cutting.md` | H1 of BC-X.14.002 and BC-X.14.004 now carry the full title that the BC-INDEX rows already had; H1 of BC-X.7.008 gains `; zero-POST guarantee`; frontmatter trace bullet FIX-P5-012 (the BC-X.14 trace bullet); `last_updated` 2026-10-04 |
| `specs/prd/BC-INDEX.md` | BC-X.7.008 title cell now equals its H1 (BC-X.14.002 and BC-X.14.004 index cells were already right and are unchanged) |
| `specs/prd/bc-7-output-render.md` | BC-7.1.006 v1.7.7: residual (b)17 corrected, new residuals (b)33-(b)36, claim (i) re-sweep note, version row 1.7.7, frontmatter trace bullet |
| `spec-changelog.md` | `[2.8.8]` entry (states the guard script is deferred) |
| `architecture/decisions/ADR-0019-...md` | Step-2 VP note: `× M2-only` reworded to `× {M2, M3}` |

## P11-001: index rows mirror H1s

Fixed (H1 stays the single title source; index text moved INTO the H1 where the index was richer):

| BC | Before | After |
|---|---|---|
| BC-X.14.002 | H1 shorter than index | H1 = index text (`... client-side case-insensitive filter narrows ... id/label(s); cascading children filtered independently; empty result is exit 0 success, not an error`) |
| BC-X.14.004 | H1 `Error taxonomy — field not found, no enumerable options (graceful degrade), ambiguous name, context-flag mutual-exclusion violations` | H1 = the index text (`Error taxonomy — field not found/ambiguous, ... non-JSM/unknown --request-type; graceful degradation (exit 0, NOT an error) ... instead of erroring`) |
| BC-X.7.008 | H1 had `prompt`, index had `; zero-POST guarantee` | H1 = old H1 + `; zero-POST guarantee`; index cell = new H1 (escaped pipes aside, no pipes in this title) |

Touched-set sweep result (BC-7.1.006, BC-X.7.002, BC-X.7.008, BC-X.14.001-004, BC-X.16.001/002): zero mismatches. BC-7.1.006, BC-X.7.002, BC-X.14.001, BC-X.14.003 and BC-X.16.001/002 already matched. BC-X.13.007 and BC-X.15.001 appeared in a diff-attribution pass, but `git diff` of `cross-cutting.md` since the cycle's first spec commit shows only file-header lines naming them, not edits to their bodies; BC-X.13.007 is a pre-existing mismatch and is in the baseline.

IMPORTANT, found by the sweep: across ALL BCs there are 240 pre-existing title mismatches (index cell != H1) and 15 H1s with no individual index row (range-collapsed rows). Per file: bc-1 38, bc-2 30, bc-3 83, bc-4 2, bc-5 4, bc-6 7, bc-7 27, bc-8 18, cross-cutting 31. None are in the cycle-014 touched set. They were NOT fixed (that would rewrite about 240 H1s or index cells, and which side is right is a per-BC decision). The guard script, the cleanup of these mismatches and the CI wiring are all DEFERRED to a follow-up GitHub issue (human decision D-406); `FIX-P5-012-h1-sync-baseline.txt` is kept as input for that follow-up.

H1s without an index row (informational; not an offender): BC-3.3.013, 3.3.014, 3.3.015, 3.8.019-022, X.5.002, 4.3.001, 3.4.033-037, 6.3.001.

## DEFERRED: `scripts/check-bc-index-h1-sync.sh` guard (not an implementer item this cycle)

DEFERRED by human decision (D-406); follow-up issue (script, cleanup of the 240 pre-existing mismatches, CI wiring). Nothing in this section is to be implemented in FIX-P5-012. It is retained verbatim as the "For the follow-up" section below.

### For the follow-up

Purpose: every BC-INDEX.md row's title cell equals its BC's H1 title (`bc_h1_is_title_source_of_truth`).

Conventions (copy from `scripts/check-bc-no-numeric-test-counts.sh` / `scripts/check-bc-citation-symbols.sh`): `#!/usr/bin/env bash`, `set -euo pipefail`, `bash -n` on itself, `--bc-dir <path>` (default `.factory/specs/prd`), `--baseline <file>` (default `scripts/bc-index-h1-sync-baseline.txt`), `--self-test`. Exit codes: 0 clean (or all self-test fixtures passed), 1 offenders (or self-test failure), 2 BC dir has no `bc-*.md`, `cross-cutting.md` or `BC-INDEX.md` missing, 64 unknown argument. Offender output: one block per ID, error code `BC-H1-SYNC-001`:

```
BC-H1-SYNC-001: BC-X.14.002
  H1   : <h1 title>
  INDEX: <index cell>
```

### Exact matching rule (reproduce exactly)

Inputs: every `$BC_DIR/bc-*.md`, plus `$BC_DIR/cross-cutting.md`, plus `$BC_DIR/BC-INDEX.md`.

1. H1 extraction (every file except BC-INDEX.md). A line is a BC heading iff it matches ERE `^#+ BC-[A-Za-z0-9]+\.[0-9]+\.[0-9]+: ` (any heading level; in practice `####`). Three dotted parts are required, so section headings like `## BC-X.14: Field Option Discovery` do not match. ID = the text after the `#`s and one space, up to the FIRST `: `. Title = everything after that first `: `, with leading and trailing space/tab trimmed. No other normalization (backticks, `|`, arrows, case all kept verbatim). In awk: `line=$0; sub(/^#+ /,"",line); id=line; sub(/: .*/,"",id); t=line; sub(/^[^:]*: /,"",t); title=trim(t)`.
2. Index extraction (BC-INDEX.md only). Consider only lines matching `^\| BC-`. Replace every `\|` (escaped pipe) with a placeholder byte (`\001`), then split on `|`. Field 2 = ID (trimmed), field 3 = title cell (trimmed), i.e. column 2 of the table (the column right after the BC ID). Restore the placeholder as a literal `|` (so `\|` in the index equals `|` in the H1). There is NO prefix stripping: index title cells do not carry a `BC-X.Y.Z:` prefix, and the ID lives in column 1.
3. Comparison: exact string equality of the trimmed H1 title and the trimmed, unescaped index cell, per ID.
4. Skips: a row whose ID has no H1 (range rows such as `BC-013-R..014-R`, absorbed rows) is skipped; an H1 whose ID has no index row (range-collapsed) is skipped; neither is an offender (print a count to stderr). Rows not starting `| BC-` (strikethrough/retired) are ignored.
5. Baseline: lines of the baseline file starting `BC-` (first token; `#` lines ignored) are IDs whose mismatch is tolerated. A mismatching ID in the baseline is not an offender. A baseline ID that now MATCHES is an offender `STALE-BASELINE <ID>` (forces the baseline to shrink). Baseline input for the follow-up (kept, not shipped now): `.factory/cycles/cycle-014/phase-f5-adversarial/FIX-P5-012-h1-sync-baseline.txt` (240 IDs; the follow-up either copies it to `scripts/bc-index-h1-sync-baseline.txt` or fixes all 240 and ships with no baseline).

Reference implementation of 1-5 (the verified throwaway; the guard should embed equivalent awk):

```awk
function trim(s){gsub(/^[ \t]+|[ \t]+$/,"",s);return s}
BEGIN{ while((getline l < base)>0){ if(l ~ /^BC-/){ sub(/[ \t].*$/,"",l); bl[l]=1 } } }
FNR==1{ idx=(FILENAME ~ /BC-INDEX\.md$/) }
!idx && match($0,/^#+ BC-[A-Za-z0-9]+\.[0-9]+\.[0-9]+: /){ line=$0; sub(/^#+ /,"",line); id=line; sub(/: .*/,"",id); t=line; sub(/^[^:]*: /,"",t); h1[id]=trim(t); next }
idx && /^\| BC-/{ l=$0; gsub(/\\\|/,"\001",l); split(l,c,"|"); id=trim(c[2]); t=trim(c[3]); gsub(/\001/,"|",t); ix[id]=t }
END{ bad=0; skipped=0; norow=0
 for(id in ix) if(id in h1){ if(ix[id]!=h1[id]){ if(id in bl) skipped++; else { print "OFFENDER " id; bad++ } } else if(id in bl){ print "STALE-BASELINE " id; bad++ } }
 for(id in h1) if(!(id in ix)) norow++
 exit (bad>0) }
```

Run with `-v base=<baseline>` over `bc-*.md cross-cutting.md BC-INDEX.md`. Measured at factory `06267920` plus this change: `h1=543 baseline-skipped=240 h1-without-row=15 offenders=0`, exit 0. Without the baseline: 255 findings (240 mismatches + 15 H1s without rows), exit 1.

`--self-test` fixtures (temp dir; minimum): (A) matching row, exit 0; (B) differing title, exit 1 and output names the ID; (C) H1 with `|` vs index `\|`, exit 0; (D) trailing-whitespace difference only, exit 0; (E) H1 without index row, exit 0; (F) index row without H1, exit 0; (G) mismatch listed in baseline, exit 0; (H) baseline ID that now matches, exit 1; (I) missing `BC-INDEX.md`, exit 2. Assert the fixture count like the sibling scripts (`EXPECTED_FIXTURES`).

Wiring (for the follow-up): add the script to the `spec-guard` CI job beside `check-bc-no-numeric-test-counts.sh`, add a one-line bullet in CLAUDE.md "AI Agent Notes" next to the other `scripts/check-bc-*.sh` bullets, and mention `scripts/check-bc-index-h1-sync.sh` in `tests/` only if a guard-listing test exists (none was checked here).

## P11-002: `get_issue_types_for_project` rustdoc (`src/api/jira/issues.rs`)

Current text under `# Usage` (verified): `- No cache — one or more HTTP calls per \`--type\` bulk invocation.` and `- Call site: \`handle_edit_bulk_fields\` in \`src/cli/issue/edit.rs\` only.` Both are wrong. Verified callers (`grep get_issue_types_for_project(` over `src/`): `src/cli/field.rs:156` (inside `handle`, M2 `jr field options --type`), `src/cli/issue/field_resolve.rs:643` (inside `resolve_against_createmeta`, `jr issue create --field`), `src/cli/issue/edit.rs:2317` (inside `handle_edit_bulk_fields`, bulk `issue edit --type`). Replace the two bullets with: no cache, one or more paginated HTTP calls per invocation of any caller (the page count is bounded by `MAX_CREATEMETA_PAGES`); call sites: the three above, named by symbol. Keep the "Project-scoped" bullet.

## P11-003: `resolve_m2_project` rustdoc (`src/cli/field.rs`)

`resolve_m2_project` is called from both `Mode::Createmeta` (M2, `field.rs:147`) and `Mode::RequestType` (M3, `field.rs:209`). Its rustdoc first line says `Post-arity, M2-only project resolution step (ADR-0019 §Amendment D1).`: reword to an M2/M3 step (M2 `--type` and M3 `--request-type` both resolve their project through it). Same wrong phrase in the rustdoc of the pure arity function that begins `Pure arity check over the three MODE-SELECTOR booleans ONLY` (`field.rs:667`) (`... post-arity, M2-only step handled by [resolve_m2_project]`): fix to M2/M3 too. Do NOT rename the function. The same phrase `M2-only` also appears in four places in `specs/prd/cross-cutting.md` (BC-X.14.001 area; lines near 2589, 2915, 3153, 3445). The spec prose was subsequently corrected to M2/M3 (all four places, plus the VP-580-010 `× M2-only` wording there and the Step-2 VP note in ADR-0019), since `handle` calls `resolve_m2_project` from both arms.

## SEC11-001 / SEC11-002 sweep record (spec-side, done)

`handle_move_bulk` table-mode results loop, traced per value at `c33f5d44`: `err_msg` (from `BulkActionError::summary()`) is SERVER text; `key` is USER-typed (the loop iterates the caller's `keys` slice); `status` is a fixed literal (`"inaccessible"` or `"?"`); `target_status` is USER-typed. This differs from the pass-11 finding's wording, which listed `key` and `status` as server-supplied. Recorded in (b)33.

Sites added: (b)33 bulk results loop; (b)34 workflow.rs `finish_transition` `Moved <key> to "<new_status>"`, `handle_move` `<key> is already in status "<current_status>"`, the `Available transitions for <key>:` stderr list, the interactive `Ambiguous` stderr list and its `selected candidate` internal error; (b)35 `src/api/jira/bulk.rs::await_bulk_task_inner` (outside the swept delta; `{:?}`-escaped `status`, raw `failureReason`, raw failed-issue keys); (b)36 `resolve_team_field` team `id` echoes. `interactions.rs`: re-swept in full, no unlisted SERVER/CONFIG site (already (a)2, (b)28, (b)29). `helpers.rs`: only (b)36. (b)17 corrected (`require_service_desk`'s real strings; the old quoted text was `resolve_service_desk_id`'s).

No rustdoc or CLAUDE.md change is needed for (b)33-(b)36: those documents point at the Canonical Sink Inventory instead of restating it.

## Handoff notes

Stories affected by BC changes: none (no BC frontmatter arrays changed). VP citations changed: none. Files the implementer must touch: `src/api/jira/issues.rs` (rustdoc), `src/cli/field.rs` (two rustdoc comments), plus any code-reviewer NITs added later. Implementer items are ONLY P11-002 and P11-003. The guard script, its baseline, the CI spec-guard wiring and the CLAUDE.md bullet are DEFERRED (D-406; follow-up issue). After the change, rerun `scripts/check-bc-citation-symbols.sh --bc-dir .factory/specs/prd` (new citations in (b)33-(b)36 are symbol-form `<file>::<fn>`; it passed at 556 citations).
