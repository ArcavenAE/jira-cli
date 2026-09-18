# S-cycle8-jsm-attachments-oauth-verification Demo Evidence

Story: Verify JSM attachment upload/download/delete succeed end-to-end under OAuth once
servicedeskapi routing lands (BC-4.2.001, verification-only, no `src/` change)
Branch: `fix/cycle8-jsm-attachments-oauth-verification`
Head: `da7fc4df8ef5c9e754565ca1f2cf26284aa694c5`
Binary: n/a for AC-002/AC-004 (git-diff-only evidence); AC-001 recorded via `cargo test`
(no `jr` CLI binary invocation — this is a `facade`-mode story, verification test only)
Captured: 2026-09-18

## Why this is a test-evidence demo, not a live CLI demo

This story's `tdd_mode` is `facade`: the deliverable is a new regression test proving an
already-correct code path (`src/api/jsm/attachments.rs`) now succeeds end-to-end now that its
upstream dependency (`list_service_desks`, fixed by the sibling story
`S-cycle8-jsm-servicedeskapi-oauth-routing`, Wave 1) is fixed. There is no new CLI user journey,
no new UI, and zero `src/` changes on this branch — "the demo" is the routing-proof test itself
executing and passing under an OAuth-constructed client. This story follows the same
per-story evidence convention as its Wave-1 sibling
`S-cycle8-jsm-servicedeskapi-oauth-routing` (this cycle's routing fix, sharing the same
BC-4.2.001 anchor), `S-576-5`, `S-577-*`, etc.

Unlike the sibling routing story (which used plain-text `cargo test -- --nocapture` captures
only, because VHS produced a blank recording in that attempt), this story's AC-001 evidence
IS a VHS recording (`.gif`/`.webm`) plus a supplementary `.log` transcript — VHS worked in this
recording session, subject to the Wait+Line sandbox limitation documented below.

## Summary

All 4 acceptance criteria (AC-001 through AC-004) from the story spec are accounted for:

- **AC-001** (two-step JSM attachment *upload* succeeds end-to-end under OAuth) is proven by
  a new wiremock-backed integration test in `tests/attachment_jsm.rs`, captured as a VHS
  recording (`.gif`/`.webm`/`.tape`) plus a raw terminal `.log` transcript. The test asserts the
  full two-step chain — `list_service_desks` → `get_or_fetch_project_meta` →
  `resolve_service_desk_id` → `attachTemporaryFile` → the request-attachment POST — completes
  successfully with every mocked request landing on the `base_url` wiremock server and **zero**
  requests reaching the `instance_url` wiremock server (the ADR-0026 gateway-routing invariant,
  now verified transitively through `attachments.rs`).
- **AC-002** (`src/` unchanged — regression guard, confirming this fix is entirely upstream in
  `list_service_desks`, not a change to the attachment upload code itself) is proven by an empty
  `git diff --stat develop..HEAD -- src/` capture.
- **AC-003** (pre-fix failure mode not re-asserted) is a procedural/sequencing clause with no
  runtime behavior to capture — satisfied structurally by this story's Wave-2 `depends_on`
  scheduling on the sibling routing story, not by an artifact. See "N/A" note below.
- **AC-004** (CHANGELOG entry documenting the upload flow is now verified working end-to-end
  under OAuth) is proven by a `CHANGELOG.md` diff capture.

## Per-AC Evidence

| AC | Demo File | Test Function(s) / Command | Result |
|----|-----------|------------------------------|--------|
| AC-001 (two-step JSM attachment upload succeeds end-to-end under OAuth; ADR-0026 `base_url`==1 request count / `instance_url`==0 request count routing proof) | `AC-001-jsm-attachment-upload-oauth-e2e.{tape,gif,webm,log}` | `test_bc_4_2_001_jsm_attachment_upload_succeeds_end_to_end_under_oauth` (`tests/attachment_jsm.rs`) | ok — `test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 35 filtered out` |
| AC-002 (`src/` unchanged — regression guard) | `AC-002-src-diff-empty.log` | `git diff --stat develop..HEAD -- src/` | PASS — empty diff (0 files, 0 lines under `src/`) |
| AC-003 (pre-fix failure mode not re-asserted, procedural) | N/A | n/a — satisfied structurally via Wave-2 `depends_on: ["S-cycle8-jsm-servicedeskapi-oauth-routing"]` scheduling | N/A (no artifact required; see story spec EC-1) |
| AC-004 (CHANGELOG `[Unreleased] > Fixed` entry documenting verified end-to-end JSM attachment upload under OAuth) | `AC-004-changelog-diff.log` | `git diff` excerpt of `CHANGELOG.md` | PASS — entry present |

Full per-AC narrative, evidence-artifact links, and the frame-verification note for the VHS
recording: [`evidence-report.md`](./evidence-report.md) (copied verbatim from the story
worktree's `docs/demo-evidence/` output).

## AC-003 note (no artifact, procedural satisfaction)

Per the story spec, this story deliberately does **not** add a test asserting the pre-fix 401
failure on `list_service_desks` under OAuth — that failure mode is already exhaustively covered
by `S-cycle8-jsm-servicedeskapi-oauth-routing`'s own AC-001 (which proves the fix, implying the
prior broken state by contrast). Satisfaction is structural: this story's Wave-2 placement in
the dependency graph (hard `depends_on` on the Wave-1 routing story) guarantees AC-001's test
here is never authored or run before the depended-on story's fix has landed — if the dependency
were unmet, AC-001 would fail at the `list_service_desks` step per the story spec's EC-1.

## VHS recording sandbox limitation (Wait+Line)

VHS (`/opt/homebrew/bin/vhs`) was available and successfully produced both `.gif` and `.webm`
outputs for AC-001, but VHS's `Wait+Line /pattern/` screen-match primitive consistently timed
out in this recording sandbox (`last value was: >`) even though keystrokes and real command
output verifiably reached the recorded terminal — confirmed by extracting frames from a control
recording with `ffmpeg` before authoring the tape. This is the same VHS-sandbox limitation
already documented in this repo's
`.factory/cycles/cycle-003/code-delivery/S-cycle3-percred-storage/` tapes. Rather than falling
back to a text-only transcript, the `.tape` was authored with a fixed `Sleep` in place of
`Wait+Line` (the target test completes in ~0.1-0.2s once compiled, confirmed via
`time cargo test ...`), and the resulting `.gif` was verified frame-by-frame with `ffmpeg` to
contain the real `test result: ok` output before being accepted as evidence. The `.log` file is
retained alongside as a byte-exact supplementary transcript, not as a fallback replacement for
the recording.

## Convention Note

Pattern established by `S-577-3/INDEX.md`, reused by `S-576-5/INDEX.md` and this cycle's
Wave-1 sibling story `S-cycle8-jsm-servicedeskapi-oauth-routing/INDEX.md`: one subdirectory per
story ID under `.factory/demos/` (committed to the `factory-artifacts` branch, per this repo's
`.gitignore` comment: "Demo evidence lives in the factory-artifacts branch (`.factory/demos/`),
not the product repo" — `docs/demo-evidence/` is gitignored in the product repo for this
reason, added in #708). An `INDEX.md` plus per-AC evidence files (VHS recording set for AC-001,
plain-text `git diff` captures for AC-002/AC-004), each documented against the acceptance
criteria they satisfy.

**Deviation from generic demo-recorder instructions:** the generic demo-recorder contract calls
for output at `docs/demo-evidence/<STORY-ID>/` committed to the feature branch. This repo has
an explicit, established, git-enforced (via `.gitignore`) convention that supersedes the generic
default: demo evidence lives on the `factory-artifacts` branch under
`.factory/demos/<STORY-ID>/`, exactly as the Wave-1 sibling story did, rather than on the
feature branch under `docs/demo-evidence/`. The artifacts here were relocated verbatim from the
gitignored `docs/demo-evidence/S-cycle8-jsm-attachments-oauth-verification/` directory in the
story worktree — no content was regenerated or altered during the move.
