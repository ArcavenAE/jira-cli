# Fresh-eyes PR review — #621 (docs-only, S-577-5 deferral resolution)

**Verdict: APPROVE**

Reviewed the full diff (2 files, 3 hunks) with fresh context and spot-checked both new machine-contract claims against the implementation in `src/cli/issue/interactions.rs::handle_comment_edit`.

## Spot-check results — both CONFIRMED

**1. `changed_fields.jsm_internal: bool` (VP-577-026) — CONFIRMED accurate**

The implementation matches the doc claim exactly:
- `visibility_flag = if internal { Some(true) } else if public { Some(false) } else { None }`
- Then: `Some(v) => json!({ "body": raw, "jsm_internal": v })` vs `None => json!({ "body": raw })`

So `jsm_internal` is present **only** when `--internal` or `--public` is passed, and carries `true` for `--internal` / `false` for `--public`. The doc phrasing is correct.

**2. Interactive cancel envelope `{"cancelled": true, "updated": false}` (VP-577-029) — CONFIRMED accurate**

The implementation emits exactly `{"cancelled": true, "updated": false}` via `render_json` — no `id`/`key` keys — and this branch is reachable **only** inside `if public { ... else if !yes { ... } }`, i.e. when the user answers a non-`y`/`yes` response to the `--public` confirmation prompt. EOF / I/O error on the prompt is a separate path -> `JrError::Interrupted` (exit 130), not the cancel envelope. The doc correctly scopes the envelope to an explicit N answer.

## Status-line / edit-heading accuracy — CONFIRMED

- `comment-crud.md:4` Status line now reads `S-577-1 + ... + S-577-5 + S-577-6 merged — fully shipped` — accurate (S-577-5 shipped in #620).
- `comment-crud.md:42` edit heading now reads `visibility flags --internal/--public/--yes S-577-5 — fully shipped` — accurate, and consistent with the flag docs at lines 51-53 and the CLAUDE.md gotcha for BC-3.5.006.

## Residual S-577-5 deferral language — NONE found (2 non-blocking notes)

Grepped both files for `deferred / pending / not yet / future / S-577-5`. The two edited lines were the only true S-577-5 deferral notes; both are now resolved. Remaining hits are NOT stale S-577-5 deferrals:

- **[SUGGESTION]** `comment-crud.md:100,109,123` reference a "deferred EJ probe" — a distinct live-E2E MERGE-semantics verification obligation under BC-3.5.006, not the S-577-5 visibility code slice. Out of scope for this PR; a follow-up doc pass could reconcile it against `test_e2e_comment_edit_visibility_merge_semantics` in `tests/e2e_live.rs`, which already appears to cover it per CLAUDE.md.
- **[NIT]** `comment-crud.md:32` still says "the future edit subcommand exits 64 for empty body" inside the `add` description. The edit subcommand has shipped, so "future" is mildly stale wording. Pre-existing, untouched by this diff, outside the PR's stated scope — safe to leave, or fold into a later sweep.

## Checklist

- Diff coherence: all 3 changes relate to S-577-5 deferral resolution — PASS
- Description accuracy: PR body matches the actual diff — PASS
- Diff size: 3 lines, well under threshold — PASS
- Commit quality: conventional format + story ID `docs(spec): resolve S-577-5 deferral notes — visibility slice shipped (#577)` — PASS
- Machine-contract claims: verified against implementation — PASS

No blocking findings. Docs now match shipped behavior.
