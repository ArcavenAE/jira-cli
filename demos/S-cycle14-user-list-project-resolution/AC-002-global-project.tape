Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-002-global-project.gif
Output docs/demo-evidence/S-cycle14-user-list-project-resolution/AC-002-global-project.webm

Set Shell "bash"
Set FontFamily "Menlo"
Set FontSize 18
Set Width 1200
Set Height 420
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 40ms

Hide
Type "source docs/demo-evidence/S-cycle14-user-list-project-resolution/setup.sh /tmp/jr-demo-cache-ac002 config-no-project.toml"
Enter
Sleep 500ms
Type "clear"
Enter
Show

# AC-002 / EC-X.7.002-2 / issue #862 itself: the GLOBAL --project flag,
# placed BEFORE the "user list" subcommand, with no local flag and no
# configured default. Previously this was clap exit 2 ("required arguments
# were not provided: --project <PROJECT>") because UserCommand::List.project
# was a clap-REQUIRED String -- clap's own required-arg check ran before
# global-value propagation ever had a chance to fill it in. It now resolves
# via clap's fill_in_global_values propagation alone.
Type "jr --project FOO user list --no-input"
Enter
Sleep 2s
