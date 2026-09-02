# VHS Demo — S-cycle3-percred-storage
#
# FALLBACK NOTE: this tape is preserved as the intended recording script,
# but VHS could not produce a .gif/.webm in the demo-recorder's execution
# sandbox — see AC-001-008-percred-storage-keyring-tests.tape's FALLBACK NOTE
# for the full explanation (headless Chrome + ttyd launch fine; no keystroke
# ever reaches the terminal). Evidence for this tape's ACs is instead
# captured as a plain-text transcript:
#   AC-003-009-percred-storage-wiring-tests.txt
#
# Covers AC-003, AC-009 (BC-1.4.031 postcondition 3; BC-1.1.009/BC-1.1.010/BC-1.2.017
# Effects clauses)
#
# Proves the two call-site wiring points that make store_api_token/load_api_token
# reachable end to end:
#   - `login_token` (src/cli/auth/login.rs) writes via store_api_token — namespaced
#     <profile>:email / <profile>:api-token, never a shared/flat pair.
#   - `JiraClient::from_config`'s `load_auth_from_keychain` api_token branch reads
#     via load_api_token(profile_name) — never the old flat-key reader (proven by
#     showing a profile with ONLY the legacy flat pair stored fails to authenticate,
#     which would not be the case if the flat reader were still consulted).
#
# Same throwaway-namespace safety as the sibling tape: tests/api_token_percred_wiring.rs
# self-namespaces into "jr-jira-cli-test-<tag>-<pid>-<n>" via its own unique_service()
# helper — the real developer keychain is never touched.

Output AC-003-009-percred-storage-wiring-tests.gif
Output AC-003-009-percred-storage-wiring-tests.webm

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

# === AC-003/AC-009: login_token + JiraClient::from_config wiring ===
Type "JR_RUN_KEYRING_TESTS=1 cargo test --test api_token_percred_wiring -- --include-ignored --test-threads=1"
Enter
Wait+Line@30s /test result: ok/
Sleep 2s
