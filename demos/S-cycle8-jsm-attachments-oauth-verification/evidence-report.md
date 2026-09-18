# Demo Evidence — S-cycle8-jsm-attachments-oauth-verification

**Story:** Verify JSM attachment upload/download/delete succeed end-to-end under OAuth once
servicedeskapi routing lands (no `src/` change)
**Cycle:** cycle-008 (oauth-surface-correctness), Wave 2
**BC:** BC-4.2.001 (transitive — this story adds regression coverage, does not amend the BC)
**tdd_mode:** `facade` — verification-only story, zero `src/` changes

## Why this evidence looks different from a normal story

This story's `tdd_mode` is `facade`: the deliverable is a new regression test proving an
already-correct code path (`src/api/jsm/attachments.rs`) now succeeds end-to-end once its
upstream dependency (`list_service_desks`, fixed by the sibling story
`S-cycle8-jsm-servicedeskapi-oauth-routing`) is fixed. There is no new CLI user journey, no new
UI, and no new production code to demo — "the demo" is the routing-proof test itself executing
and passing. Accordingly:

- AC-001 is demonstrated by a **VHS terminal recording of the test run** (the standard CLI-demo
  toolchain), not a `jr` command journey.
- AC-002 and AC-004 are demonstrated by **`git diff` captures** — the correct evidence shape for
  a "prove nothing changed here" / "prove the doc changed there" acceptance criterion.
- AC-003 is a **procedural/sequencing clause** with no runtime behavior to capture; it is
  satisfied by this story's Wave 2 placement in the dependency graph, not by an artifact.
- **Single-path deviation from the standard success+error-path convention:** this facade story
  introduces one regression test with no new error-handling branch of its own — there is no
  distinct "error path" behavior for AC-001 to demonstrate beyond the test passing (the pre-fix
  failure mode is explicitly out of scope per AC-003 / EC-1, and is already covered by the
  sibling routing story's own AC-001). Recording only the success path here is intentional, not
  an omission.

## AC-001 — Two-step JSM attachment upload succeeds end-to-end under OAuth

**Test:** `test_bc_4_2_001_jsm_attachment_upload_succeeds_end_to_end_under_oauth`
(`tests/attachment_jsm.rs`)

**What it proves:** under an OAuth-constructed client
(`JiraClient::new_for_test_with_instance_url`, `base_url != instance_url`), the full JSM
two-step upload chain — `list_service_desks` → `get_or_fetch_project_meta` →
`resolve_service_desk_id` → `attachTemporaryFile` → the request-attachment POST — completes
successfully with every mocked request landing on the `base_url` wiremock server, and the
`instance_url` wiremock server receives **zero** requests across the whole chain (the
ADR-0026 gateway-routing invariant, verified transitively through `attachments.rs`).

**Evidence artifacts:**
- [`AC-001-jsm-attachment-upload-oauth-e2e.tape`](./AC-001-jsm-attachment-upload-oauth-e2e.tape) — VHS script source
- [`AC-001-jsm-attachment-upload-oauth-e2e.gif`](./AC-001-jsm-attachment-upload-oauth-e2e.gif) — VHS recording (PR-embeddable)
- [`AC-001-jsm-attachment-upload-oauth-e2e.webm`](./AC-001-jsm-attachment-upload-oauth-e2e.webm) — VHS recording (archival)
- [`AC-001-jsm-attachment-upload-oauth-e2e.log`](./AC-001-jsm-attachment-upload-oauth-e2e.log) — raw terminal text transcript (supplementary; captured directly, not extracted from the recording)

**Result line (from both the recording and the log):**
```
test test_bc_4_2_001_jsm_attachment_upload_succeeds_end_to_end_under_oauth ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured; 35 filtered out; finished in 0.00s
```

**Recording tooling note:** VHS (`vhs`, `/opt/homebrew/bin/vhs`) was available in this sandbox
and successfully produced both `.gif` and `.webm` outputs. One deviation from the standard
tape-authoring pattern was required: VHS's `Wait+Line /pattern/` screen-match primitive
consistently timed out in this recording sandbox (`last value was: >`) even though keystrokes
and real command output verifiably reach the recorded terminal (confirmed by extracting frames
from a control recording with `ffmpeg` before authoring this tape — the frames show real `cd`/
`git`/`cargo` output, not a stalled prompt). This is the same VHS-sandbox limitation already
documented in this repo's `.factory/cycles/cycle-003/code-delivery/S-cycle3-percred-storage/`
tapes. Rather than falling back to a text-only transcript, the tape was rewritten to use a fixed
`Sleep` (the target test completes in ~0.1–0.2s once compiled, confirmed via `time cargo test
...`), and the resulting `.gif` was verified frame-by-frame with `ffmpeg` to contain the real
`test result: ok` output before being accepted as evidence — see the frame excerpt embedded
above and the tape's own header comment for detail. The `.log` file is retained alongside as a
byte-exact supplementary transcript, not as a fallback replacement for the recording.

## AC-002 — `src/` unchanged (regression guard)

**What it proves:** this story (and the sibling routing story before it) made zero changes to
`src/api/jsm/attachments.rs` — its `attach_temporary_file` and `post_request_attachment`
functions are byte-for-byte unchanged, confirming AC-001's fix is entirely a fix to the upstream
`list_service_desks` dependency chain, not a change to the attachment upload code itself.

**Evidence artifact:** [`AC-002-src-diff-empty.log`](./AC-002-src-diff-empty.log)

**Command and result:**
```
$ git diff --stat develop..HEAD -- src/
(exit code: 0; no output above this line means the diff is empty)
```
The `git diff --stat` output is empty — zero files, zero lines changed under `src/` on this
branch relative to `develop`.

## AC-003 — Pre-fix failure mode not re-asserted (procedural, N/A for a recorded artifact)

**Status:** N/A — no runtime demo applies. This is a documentation/sequencing clause, not a
runtime assertion. Per the story spec, this story deliberately does **not** add a test
asserting the pre-fix 401 failure on `list_service_desks` under OAuth — that failure mode is
already exhaustively covered by `S-cycle8-jsm-servicedeskapi-oauth-routing`'s own AC-001 (which
proves the fix, implying the prior broken state by contrast).

**How it is satisfied:** procedurally, via this story's Wave 2 placement in the dependency
graph (`depends_on: ["S-cycle8-jsm-servicedeskapi-oauth-routing"]`), which guarantees this
story's test (AC-001) is never authored or run before the depended-on story's fix has landed.
There is no artifact to attach for this AC — its satisfaction is structural (wave scheduling +
hard `depends_on`), confirmed by AC-001's test passing on this branch (if the dependency were
unmet, AC-001 would fail at the `list_service_desks` step, per EC-1 in the story spec).

## AC-004 — CHANGELOG entry

**What it proves:** `CHANGELOG.md`'s `[Unreleased] > Fixed` section documents that the JSM
attachment upload flow is now verified working end-to-end under OAuth (3LO) profiles, closing
the last piece of the JSM OAuth-routing dependency chain (scope narrowed to *upload* only, per
adversarial review Pass 1 — download/delete use the platform `/rest/api/3/attachment`
endpoints and were unaffected by the servicedeskapi routing bug this cycle addresses).

**Evidence artifact:** [`AC-004-changelog-diff.log`](./AC-004-changelog-diff.log)

**Diff excerpt:**
```diff
+  **Verified end-to-end (S-cycle8-jsm-attachments-oauth-verification, BC-4.2.001,
+  verification-only, no `src/` change):** a new regression test proves the JSM two-step
+  servicedeskapi *upload* flow (`jr issue attachment upload --public/--internal` on JSM
+  issues) succeeds end-to-end under an OAuth-constructed client, closing the last piece
+  of the JSM OAuth-routing dependency chain. (Download/delete use the platform
+  `/rest/api/3/attachment` endpoints and were unaffected by the servicedeskapi routing
+  bug.)
```

## Coverage Summary

| AC | Description | Evidence | Status |
|----|-------------|----------|--------|
| AC-001 | Two-step JSM attachment upload succeeds end-to-end under OAuth | `AC-001-jsm-attachment-upload-oauth-e2e.{tape,gif,webm,log}` | PASS — recorded + logged |
| AC-002 | `src/` unchanged (regression guard) | `AC-002-src-diff-empty.log` | PASS — empty diff confirmed |
| AC-003 | Pre-fix failure mode not re-asserted (procedural) | N/A — satisfied structurally via Wave 2 `depends_on` scheduling | N/A (no artifact required) |
| AC-004 | CHANGELOG entry | `AC-004-changelog-diff.log` | PASS — entry present |

All four acceptance criteria in the story spec are accounted for above, either with a recorded/
logged artifact or an explicit N/A justification.
