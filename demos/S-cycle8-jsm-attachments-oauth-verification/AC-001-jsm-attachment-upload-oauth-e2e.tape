# VHS Demo — S-cycle8-jsm-attachments-oauth-verification, AC-001
#
# tdd_mode: facade (verification-only story, zero src/ changes). The
# deliverable for AC-001 is the regression test itself passing, not a CLI
# user journey — this recording shows
# `test_bc_4_2_001_jsm_attachment_upload_succeeds_end_to_end_under_oauth`
# (tests/attachment_jsm.rs) executing and reporting "test result: ok".
#
# What the test proves (BC-4.2.001, transitive; ADR-0026): under an
# OAuth-constructed client (JiraClient::new_for_test_with_instance_url,
# base_url != instance_url), the JSM two-step attachment upload flow
# (list_service_desks -> get_or_fetch_project_meta -> resolve_service_desk_id
# -> attachTemporaryFile -> request-attachment POST) completes successfully
# with every request landing on the base_url mock and ZERO requests reaching
# the instance_url mock. src/api/jsm/attachments.rs is unchanged (AC-002);
# this test is additional regression coverage for the sibling
# S-cycle8-jsm-servicedeskapi-oauth-routing story's fix to list_service_desks.
#
# Single-path note (deviates from the standard success+error-path demo
# convention): this facade story adds one regression test with no new
# production logic and no new error-handling branch of its own — there is no
# distinct "error path" for this AC to demonstrate beyond the test passing.
# See evidence-report.md for the full justification.
#
# Sleep-based wait, not Wait+Line (sandbox deviation): in this recording
# sandbox, VHS's `Wait+Line` screen-match consistently times out
# ("last value was: >") even though keystrokes and command output DO reach
# the terminal and ARE captured correctly in the rendered frames (verified by
# extracting frames from a control recording with ffmpeg before authoring
# this tape). This reproduces the same VHS environment limitation documented
# in .factory/cycles/cycle-003/.../AC-001-008-percred-storage-keyring-tests.tape's
# FALLBACK NOTE. Since the target test completes in <1s once compiled
# (confirmed via `time cargo test ...` — 0.18s total), a fixed Sleep is a
# reliable substitute here and the GIF/WebM output is real, not a fallback
# transcript.

Output AC-001-jsm-attachment-upload-oauth-e2e.gif
Output AC-001-jsm-attachment-upload-oauth-e2e.webm

Require cargo

Set Shell "zsh"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 500
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set BorderRadius 8
Set Padding 20
Set Framerate 30
Set TypingSpeed 40ms

Hide
Type "cd $(git rev-parse --show-toplevel)"
Enter
Sleep 1s
Type "clear"
Enter
Sleep 500ms
Show

# === AC-001: JSM attachment two-step upload succeeds end-to-end under OAuth ===
Type "cargo test --test attachment_jsm test_bc_4_2_001_jsm_attachment_upload_succeeds_end_to_end_under_oauth -- --nocapture"
Enter
Sleep 5s
Sleep 2s
