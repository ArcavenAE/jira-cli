#!/usr/bin/env bash
set -euo pipefail

# run-tests.sh: fixture self-test for the protected-files read in
# .github/workflows/sync-upstream.yml ("Merge upstream" step).
#
# The step runs under `set -euo pipefail` and reads the protected-file list with
# a grep pipeline inside a command substitution. A list with no entries (empty,
# only comments, only blank lines) makes the last grep match nothing and exit 1,
# which under pipefail ends the step before the merge. An empty list must mean
# "no protected files". This pulls the real PROTECTED= line out of the workflow,
# points it at each fixture list, runs it under the step's own shell options,
# and checks that it survives and returns the right entries.
#
#   bash tests/sync-upstream-protected/run-tests.sh      (from the repo root)

WORKFLOW=".github/workflows/sync-upstream.yml"
[ -f "$WORKFLOW" ] || { echo "ERROR: run from the repo root ($WORKFLOW not found)"; exit 1; }

LINE="$(grep -E '^[[:space:]]+PROTECTED=\$\(' "$WORKFLOW" | head -n 1 | sed 's/^[[:space:]]*//')"
[ -n "$LINE" ] || { echo "ERROR: no PROTECTED=\$(...) line in $WORKFLOW"; exit 1; }
case "$LINE" in
  *.github/local-workflows.txt*) ;;
  *) echo "ERROR: the PROTECTED line does not read .github/local-workflows.txt: $LINE"; exit 1 ;;
esac

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
PASS=0
FAIL=0

# run_case NAME FILE-CONTENT EXPECTED-STDOUT
run_case() {
  local name="$1" content="$2" want="$3" list rc got
  list="$WORK/list.txt"
  printf '%s' "$content" > "$list"
  set +e
  got="$(bash -c 'set -euo pipefail; PROTECTED=""; '"${LINE//.github\/local-workflows.txt/\"\$1\"}"'; printf "%s" "$PROTECTED"' _ "$list" 2>/dev/null)"
  rc=$?
  set -e
  if [ "$rc" -eq 0 ] && [ "$got" = "$want" ]; then
    echo "PASS: $name"
    PASS=$((PASS + 1))
  else
    echo "FAIL: $name (rc=$rc, got [$got], want [$want])"
    FAIL=$((FAIL + 1))
  fi
}

run_case "empty file gives no protected files"          ""                                   ""
run_case "all-comment file gives no protected files"    $'# only comments\n#\n'              ""
run_case "blank-only file gives no protected files"     $'\n  \n\t\n'                       ""
run_case "comments and blanks only gives none"          $'# note\n\n# another\n  \n'          ""
run_case "populated file gives its entries"             $'# header\na/b.yml\n\nc.rb\n'       $'a/b.yml\nc.rb'
run_case "an entry after leading comments is kept"      $'#\n#\nonly.txt\n'                  "only.txt"

echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
