# PR Review — #638 (S-576-4 `jr issue attachment delete`)

**Verdict:** APPROVE
**Covered SHA:** `b336e8d75611c0bea7be7f00e8d7aecce55f83a2`
**Base:** `develop` ← `feat/S-576-4-attachment-delete`

Fresh-eyes review of the diff, PR description, and demo evidence only.

## Verification of key behavioral contracts

| # | Contract | Result | Evidence |
|---|----------|--------|----------|
| 1 | BC-3.9.015 AID `^[0-9]+$` before prompt/HTTP | PASS | Path A validates every AID (`aid.is_empty() \|\| !aid.chars().all(is_ascii_digit)`) at the top of the block, before dry-run, gate, and metadata GET |
| 2 | DEC-168 targeted 404 prefix-then-body | PASS | `delete_attachment_targeted` maps 404 → `UserError("Attachment {id} not found or not accessible.\n{message}")` — canonical prefix first, raw Jira body second |
| 3 | BC-3.9.010 bulk 404 benign skip | PASS | Both bulk loops call `delete_attachment` (not `_targeted`); match `msg.contains("not found or already deleted")` → skip; non-404 → `return Err(e)` (abort) |
| 4 | DEC-174 gate uses eprint!+read_line, not dialoguer | PASS | `attachment_delete_confirmation_gate`: `eprint!` + flush + `stdin().lock().read_line`; EOF/Err → `JrError::Interrupted` (exit 130) |
| 5 | EC-3.9.020-3 single-AID dry-run: hint to stderr, validation fires, no DELETE | PASS | Validation precedes `if dry_run`; JSON→stdout / human→stderr hint; early return before any DELETE |
| 6 | BC-3.9.016 bulk requires --yes; missing → exit 64 | PASS | Multi-AID and issue+age both guard `if !yes && !dry_run` → UserError; dry-run correctly exempted |
| 7 | parse_age_duration private, d=24h, three overflow bands | PASS | Private fn; `"d" => n.checked_mul(24*3_600)`; L1 checked_mul, L2 try_seconds, L3 MAX_AGE_SECS clamp + checked_sub_signed belt-and-braces at call site |
| 8 | All JSON via output::render_json (#526) | PASS | Every JSON emit uses `output::render_json(&payload)?`; no `to_string_pretty`, no compact Display printing |
| 9 | No dialoguer in delete path | PASS | Gate is stdin-based only |
| 10 | No new cache files | PASS | No `write_*_cache` calls in the diff |

## Checklist
- Diff coherence: all changes scope to S-576-4 (API fn, CLI handler, clap variant, dispatch, tests, docs, CHANGELOG, CLAUDE.md gotcha, demo evidence). Clean.
- Description accuracy: PR body matches code.
- Test coverage: 25 integration + 7 unit (private-helper pins for overflow bands + `1d=24h` boundary) + e2e surface-guard entry.
- Demo evidence: 7 VHS recordings (`.gif`+`.webm`), evidence-report.md, mock-server, run script; 16/16 ACs mapped; success and error paths recorded. Proper video formats.
- Commit quality: conventional title with story ID and `#576`.
- Diff size: ~4884 additions, dominated by test file (3084 lines) + binary demo assets + `.tape` files; hand-written source ~500 lines. Acceptable.
- Missing changes: none. `delete_attachment_targeted` correctly kept separate from benign `delete_attachment` (preserves S-576-3 replace-detection).
- Dependency status: S-576-1 (PR #630) merged. Correctly does not close #576.

## Findings
No BLOCKING findings. No WARNINGS.

NIT (informational): diff exceeds the 500-line heuristic, but the excess is test + generated evidence, which is expected for a feature of this scope.

Note: clap `ArgGroup delete_target` (required; `aids`+`issue`) with `issue requires older_than` and `conflicts_with_all` correctly yields exit 2 for bare `delete`, lone `--issue`, lone `--older-than`, and positional+`--issue` — all demonstrated. The `.expect()` calls on `issue`/`older_than` in Path B are safe because those clap constraints guarantee presence when `aids` is empty.
