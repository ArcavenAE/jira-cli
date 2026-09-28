---
document_type: wave-holdout-scenarios
phase: phase-f3-incremental-stories
cycle: cycle-014
feature: issue-triage-quickfixes
status: draft
producer: story-writer
created: 2026-09-26
inputs:
  - ".factory/cycles/cycle-014/phase-f3-stories/S-cycle14-user-list-project-resolution.md"
  - ".factory/cycles/cycle-014/phase-f3-stories/S-cycle14-api-query-param.md"
  - ".factory/cycles/cycle-014/phase-f3-stories/S-cycle14-field-options-name-label.md"
  - ".factory/cycles/cycle-014/phase-f3-stories/wave-schedule.md"
traces_to: "BC-X.7.002; BC-X.16.001/002; BC-X.14.001/003; VP-USER-LIST-PROJECT-001; VP-API-QP-001..006; VP-580-013"
input-hash: "5c4422a"
---

# Wave Holdout Scenarios -- `issue-triage-quickfixes` (cycle-014)

Per-wave cross-story integration scenarios and full-cycle regression scenarios on existing
`jr user list`, `jr api`, and `jr field options` behavior, per the F3 workflow's requirement for
holdout coverage beyond each story's own ACs. Because delivery is strictly serial (D-381), each
wave's integration scenarios exercise ONLY that wave's own story against the current `develop`
tip -- there is no same-wave cross-story composition to test (unlike cycle-008's parallel Wave 1).

---

## Wave 1 (Story A: `S-cycle14-user-list-project-resolution`, #862)

### H-CYCLE14-W1-INT-001 -- `--project` resolution composes correctly with `--profile` and `--all`

**Setup:** A profile `alt` configured with its own default `project = "ALT"`, no `.jr.toml` in
cwd or any ancestor, and no local/global `--project` flag. Run `jr --profile alt user list --all`.

**Expectation:** Every page of the resulting `--all` pagination carries `projectKeys=ALT` (not
the `"default"` profile's own configured project, if any) -- proving `resolve_user_list_project`'s
configured-default fallback (Postcondition 3) and the `--all` pagination path (Postcondition 5)
compose correctly, and that `handle`/`handle_list` genuinely use the passed `&Config` rather than
reloading it (which would silently resolve `"default"` instead of `alt`).

**MUST-PASS.**

### H-CYCLE14-W1-INT-002 -- Local flag wins over both global flag and configured default, end-to-end

**Setup:** A configured default project `"CFG"` (via `.jr.toml`), plus `jr --project GLOBAL user
list --project LOCAL`.

**Expectation:** Exactly one request is issued, with `projectKeys=LOCAL` -- proving the full
three-way precedence chain (local > global > configured default) resolves correctly end-to-end,
not just at the unit level of `resolve_user_list_project` (which never sees the local-vs-global
decision -- that is clap's own propagation, happening upstream of the resolver call).

**MUST-PASS.**

---

## Wave 1 -- Regression Scenarios (Existing `jr user list` Behavior Unchanged)

### H-CYCLE14-W1-REG-001 -- `jr user search` and `jr user view` are untouched

**Setup:** Run the existing (pre-cycle-014, unmodified) test suites for `jr user search <query>`
and `jr user view <accountId>` against the post-cycle-014 binary.

**Expectation:** Both subcommands behave byte-for-byte identically -- this story's scope is
`UserCommand::List.project` only; `UserCommand::Search` and `UserCommand::View` have no `project`
field and are structurally untouched.

**MUST-PASS. Regression-critical.**

### H-CYCLE14-W1-REG-002 -- `jr user list`'s non-`--project` flags (`--limit`, `--all`) are unaffected

**Setup:** Run the existing `--limit`/`--all` local-cap and pagination tests for `jr user list`
against the post-cycle-014 binary, with a valid `--project` resolvable by any of the three paths.

**Expectation:** `--limit` capping and `--all` pagination behavior (result count, page-advance
logic per BC-X.2.005) are unchanged -- only the project-resolution step upstream of the HTTP call
changes.

**MUST-PASS. Regression-critical.**

---

## Wave 2 (Story C: `S-cycle14-api-query-param`, #583)

### H-CYCLE14-W2-INT-001 -- `-q` composes correctly with `-H`/`--header` and `-d`/`--data`

**Setup:** `jr api /rest/api/3/search -X POST -d '{"jql":"project=FOO"}' -H "X-Custom: 1" -q
maxResults=50 -q fields=summary,status`.

**Expectation:** The received request has: the POST method; body exactly `{"jql":"project=FOO"}`
(unaffected by `-q`); the `X-Custom: 1` header (unaffected by `-q`); and a query string of exactly
`maxResults=50&fields=summary%2Cstatus` (two pairs, comma preserved as literal VALUE content in
the second, per EC-X.16.001-13). This is the direct end-to-end proof that `-q`'s new pre-flight
step (inserted between `normalize_path` and `resolve_body`/`parse_header`) does not disturb the
existing body/header assembly it now runs ahead of.

**MUST-PASS.**

### H-CYCLE14-W2-INT-002 -- Zero `-q`, path already carries a query string: byte-identical to pre-cycle-014

**Setup:** `jr api /issue/FOO-1?fields=summary` (pre-existing query string, no `-q`/`--query-param`
flag supplied at all).

**Expectation:** The path handed to `client.request` is byte-identical to the raw argv path --
`append_query_params` called with an empty pair list is the identity even when the pre-fragment
part already contains a `?`-delimited query component (BC-X.16.001 Postcondition 1) -- and the
request is sent exactly as pre-cycle-014 `jr api` would have sent it.

**MUST-PASS.**

---

## Wave 2 -- Regression Scenarios (Existing `jr api` Behavior Unchanged)

### H-CYCLE14-W2-REG-001 -- Zero-`-q` invocations are byte-identical to pre-cycle-014 `jr api`

**Setup:** Run the existing (pre-cycle-014, unmodified) `jr api` integration test suite --
`normalize_path` trimming/slash/URL-rejection tests, `parse_header` tests, `resolve_body` tests
(`@file`, `@-`, inline JSON), and the raw-passthrough (BC-X.1.007) / method-case-insensitivity
(BC-X.1.011) tests -- against the post-cycle-014 binary, supplying no `-q`/`--query-param` flag at
all.

**Expectation:** Every existing test passes unmodified -- the path handed to the request is
byte-identical to `normalize_path`'s own output (`append_query_params(p, &[]) == p`), and no
existing `jr api` behavior (body resolution, header parsing, raw response passthrough, method
case-insensitivity) is altered by this story's additions.

**MUST-PASS. Regression-critical.**

### H-CYCLE14-W2-REG-002 -- `jr api --help` still documents `-d`/`-H`/`-X` unchanged, plus the new `-q`

**Setup:** `jr api --help`.

**Expectation:** The existing `-d`/`--data`, `-H`/`--header`, `-X`/`--method` help text is
unchanged (byte-for-byte, modulo the new `-q` line's insertion into the flag list), and the new
`-q`/`--query-param` line is present containing the pinned `"do not pre-encode"` substring
(VP-API-QP-003(e)).

**MUST-PASS.**

---

## Wave 3 (Story B: `S-cycle14-field-options-name-label`, #861)

### H-CYCLE14-W3-INT-001 -- A real `priority`-shaped fixture round-trips through `--type`, `--value`, and `--output json`

**Setup:** `jr field options Priority --type Task --project FOO --value high --output json`,
against a mocked createmeta response whose `priority` field's `allowedValues` entries carry `name`
(e.g. `"High"`, `"Highest"`) but no `value`.

**Expectation:** The JSON output's `label` field for each matching entry is the real name string
(e.g. `"High"`, `"Highest"`), not `null` -- and `--value high` matches BOTH `"High"` and
`"Highest"` (case-insensitive substring, per EC-X.14.001-13's own noted caveat) -- proving the
label fallback (AC-001) and the unmodified `--value` filter (AC-003) compose correctly end-to-end
through the full M2 dispatch path, not just at the unit level of `normalize_from_allowed_values_at_depth`
in isolation.

**MUST-PASS.**

### H-CYCLE14-W3-INT-002 -- The fallback does not leak into the M3 (`--request-type`) dispatch path

**Setup:** `jr field options Urgency --request-type "Get IT Help" --project FOO --output json`,
against a mocked JSM requesttype-fields response whose `validValues` entries carry both `value`
and `name` fields (M3's own wire shape, which already reads `.value` for id and `.label` for
display, NOT `.name`).

**Expectation:** The JSON output's `label` values come from the wire's `label` field only,
byte-for-byte identical to pre-cycle-014 output -- proving this story's read-side fix, applied to
`normalize_from_allowed_values_at_depth` (M1/M2 only), has zero effect on
`normalize_from_valid_values` (M3), end-to-end through the real `--request-type` dispatch fork,
not just AC-004's isolated unit regression.

**MUST-PASS.**

---

## Wave 3 -- Regression Scenarios (Existing `jr field options` Behavior Unchanged)

### H-CYCLE14-W3-REG-001 -- Custom select fields (the pre-#861 use case) are unaffected

**Setup:** Run the existing (pre-cycle-014, unmodified) `jr field options` test suite for a
CUSTOM select field whose `allowedValues` entries carry `value` (not `name`) -- the original
S-580-1 use case.

**Expectation:** Every existing test passes unmodified -- `label` resolves to `value` exactly as
before (EC-X.14.001-8/10, both unchanged from pre-fix behavior); this story only changes the
behavior for the `name`-only case (EC-X.14.001-9), which did not previously exist as a passing
custom-field scenario.

**MUST-PASS. Regression-critical.**

### H-CYCLE14-W3-REG-002 -- `--type`/`--request-type`/`--issue` mode-selector arity and error taxonomy are unaffected

**Setup:** Run the existing BC-X.14.001/004 mode-selector arity tests (none/multiple mode flags,
empty `<field>`, ambiguous/zero-match field-name resolution) against the post-cycle-014 binary.

**Expectation:** All exit-64 arity and error-taxonomy behavior (BC-X.14.004) is unchanged -- this
story's edit is confined to the label-resolution step inside the M1/M2 normalizer, downstream of
every mode-selector and field-name-resolution guard.

**MUST-PASS. Regression-critical.**

### H-CYCLE14-W3-REG-003 -- The renamed test (`test_bc_x_14_001_field_name_human_name_resolves_via_partial_match`) still exercises the same behavior under its new name

**Setup:** After the AC-007 rename, run the renamed test.

**Expectation:** The test's ASSERTIONS are unchanged (only its name and doc comment are
corrected) -- it still proves a human-name `<field>` resolves via `search_field_list`'s
exact-then-substring algorithm. A diff review confirms zero assertion-line changes, name/comment
lines only.

**SHOULD-PASS** (a process-discipline check on the rename's scope, not a new runtime behavioral
proof in its own right).

---

## Full-Cycle Regression Scenario (All Three Waves Combined)

### H-CYCLE14-REG-FULL -- The full pre-existing test suite passes after all three stories land

**Setup:** After Wave 3 (B) merges, run the complete `cargo test` suite (unit, integration,
proptest, snapshot) on `develop`.

**Expectation:** 100% pass, zero regressions across the entire `jr` CLI surface -- not just the
three touched command families (`user`, `api`, `field`). This is the final full-cycle gate before
F5 (scoped adversarial review) begins.

**MUST-PASS. Regression-critical. Gates F5 dispatch.**
