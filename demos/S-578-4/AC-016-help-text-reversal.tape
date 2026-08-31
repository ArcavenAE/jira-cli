# S-578-4 — AC-016: --field help text no longer says "requires --request-type";
# --on-behalf-of's help text is unchanged (still JSM-only). No backend required —
# pure clap help-text rendering.
#
# NOTE: this tape uses `Sleep` (not `Wait+Line`) for the hidden setup step.
# `Wait+Line /regex/` was verified non-functional against the installed vhs
# 0.11.0 binary in this environment (times out even against trivial,
# already-printed literal text) — a plain, unqualified `Wait` was confirmed
# to work, but only `Sleep` reliably bridges the hidden `cargo build` step.
Output AC-016-help-text-reversal.gif
Output AC-016-help-text-reversal.webm

Require cargo

Set Shell "bash"
Set FontSize 16
Set Width 1200
Set Height 500
Set FontFamily "Menlo"
Set Padding 20
Set TypingSpeed 40ms

Hide
Type "cd $(git rev-parse --show-toplevel) && cargo build --quiet --bin jr && export PATH=$PWD/target/debug:$PATH && clear"
Enter
Sleep 3s
Show

Type "jr issue create --help | grep -E -- '--field|--on-behalf-of'"
Enter
Sleep 2s
