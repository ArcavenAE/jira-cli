---
document_type: code-review
wave: 2
pass: 01
producer: code-reviewer
date: 2026-05-08
diff_range: ab19783..ca22be0
verdict: CONCERNS
---

# Wave 2 Integration-Gate Code Review — Pass 01

**Scope:** Code quality review of the combined Wave 2 diff (72 files, 5,889
insertions). Stories S-2.01 through S-2.07. Production changes in S-2.06 and
S-2.07 only; remaining stories are test/doc only.

**Focus:** Idiomaticness, maintainability, readability, micro-design.

---

## Part B — Findings

### WV2-CR-01: Identical `jr_cmd` helper duplicated across five holdout suites

- **Severity:** WORTH-DOING-LATER
- **Category:** test-org
- **Location:** `tests/issue_read_holdouts.rs:48`, `tests/issue_write_holdouts.rs:36`, `tests/asset_holdouts.rs:46`, `tests/boards_sprints_holdouts.rs:53`, `tests/worklog_duration_holdouts.rs:75`
- **Description:** All five Wave 2 holdout files define the same eight-line
  `fn jr_cmd(server_uri, cache_dir, config_dir) -> Command` body, character for
  character. This is pure copy-paste duplication of test infrastructure.
  `tests/common/` already exists (`mock_server.rs`, `fixtures.rs`, `mod.rs`) and
  is imported by each file via `mod common;`. The helper belongs there.
- **Evidence:**
  ```rust
  // Identical in all five files:
  fn jr_cmd(server_uri: &str, cache_dir: &std::path::Path, config_dir: &std::path::Path) -> Command {
      let mut cmd = Command::cargo_bin("jr").unwrap();
      cmd.env("JR_BASE_URL", server_uri)
          .env("JR_AUTH_HEADER", "Basic dGVzdDp0ZXN0")
          .env("XDG_CACHE_HOME", cache_dir)
          .env("XDG_CONFIG_HOME", config_dir)
          .arg("--no-input");
      cmd
  }
  ```
- **Recommendation:** Add `pub fn jr_cmd(server_uri: &str, cache_dir: &Path, config_dir: &Path) -> Command`
  to `tests/common/fixtures.rs` (or a new `tests/common/cmd.rs`) and delete the
  per-file copies. Already-existing holdout files can migrate in a single sweep.
  The isolation argument ("each test file is self-contained") does not apply here
  because this helper has no file-specific parameterisation.

---

### WV2-CR-02: `write_config_with_team_field` / `write_team_cache` duplicated with signature variation

- **Severity:** WORTH-DOING-LATER
- **Category:** test-org
- **Location:** `tests/issue_read_holdouts.rs:90`, `tests/boards_sprints_holdouts.rs:66`, `tests/team_column_parity.rs:60`
- **Description:** Three test files each define their own `write_config_with_team_field`
  and `write_team_cache` helpers. The implementations differ only in optional
  parameters: `issue_read_holdouts.rs` takes an extra `status_field_id:
  Option<&str>` and uses a different cache path (`jr/v1/default/teams.json`
  vs `team_column_parity.rs` which uses `jr/teams.json` — a path bug in the
  older file). The divergent cache paths are a correctness hazard: future test
  maintainers may not notice the mismatch.
- **Evidence:**
  ```rust
  // boards_sprints_holdouts.rs:86 — uses jr/v1/default/teams.json (correct)
  fn write_team_cache_entry(cache_home: &Path, team_id: &str, team_name: &str)

  // issue_read_holdouts.rs:120 — uses jr/v1/default/teams.json (correct)
  fn write_team_cache(cache_home: &Path, team_id: &str, team_name: &str)

  // team_column_parity.rs:37 — uses jr/teams.json (incorrect old-style path)
  fn write_team_cache(cache_home: &Path) // no id/name params, hardcoded entries
  ```
- **Recommendation:** Consolidate into `tests/common/fixtures.rs` with a
  canonical signature `pub fn write_team_cache_entry(cache_home, team_id, team_name)`.
  The `team_column_parity.rs` old-style helper should be updated to use the
  correct `jr/v1/default/` path at the same time — it currently writes to a
  path the production code no longer reads.

---

### WV2-CR-03: `auth_json_response` placement creates a future split obstacle

- **Severity:** SUGGESTION
- **Category:** refactor
- **Location:** `src/cli/auth.rs:269-275`
- **Description:** The `auth_json_response` helper builds a
  `{"profile", "action", "ok": true}` payload. It is private to `src/cli/auth.rs`
  (no `pub`) and is only called from within the same file — so its location is
  not wrong today. However, the Wave 3 plan (as noted in NFR-O-D) calls for
  splitting `src/cli/auth.rs` (~2,245 LOC) into sub-modules. When that split
  happens, the four call-sites (`handle_login`, `handle_logout`, `handle_remove`,
  `handle_switch`) will likely land in different sub-files, each needing access
  to this helper. If it is not moved to a shared location before the split,
  the splitter must either: (a) duplicate it, (b) make it `pub(crate)`, or
  (c) promote it to `src/output.rs`.

  Option (c) is architecturally correct: `src/output.rs` already owns
  `render_json`, `print_success`, `print_warning` — all the output-channel
  primitives. A generic `print_action_json(profile, action)` in `output.rs`
  would be re-usable by any future command that follows the same
  verb-aligned shape (e.g., if `jr project archive` ever wants JSON
  confirmation output).
- **Evidence:** The four call-sites at lines 629–634, 997–1002, 1121–1126,
  1164–1169 are structurally identical:
  ```rust
  println!(
      "{}",
      serde_json::to_string_pretty(&auth_json_response(&target, "switch"))
          .expect("auth JSON response serialization cannot fail")
  );
  ```
  This 5-line block is repeated four times. If `auth_json_response` returned
  a pre-serialized `String` rather than a `Value`, all four sites would
  collapse to `println!("{}", auth_json_response(&target, "switch"));` with no
  `.expect()` needed.
- **Recommendation:** Before the Wave 3 auth split, change `auth_json_response`
  to return `String` directly (serialization is infallible for a plain
  `json!({...})` literal), then move it to `src/output.rs` as
  `pub fn print_action_json(profile: &str, action: &str)`. This also
  eliminates the four repeated `.expect("auth JSON response serialization
  cannot fail")` calls, which are idiomatic panic-guards but add noise.

---

### WV2-CR-04: Repeated 5-line JSON emission block — refactor opportunity in `src/cli/auth.rs`

- **Severity:** SUGGESTION
- **Category:** refactor
- **Location:** `src/cli/auth.rs:629-635`, `:997-1003`, `:1121-1127`, `:1164-1170`
- **Description:** The same 5-line `println!` block is copy-pasted four times
  across `handle_login`, `handle_logout`, `handle_remove`, and `handle_switch`.
  Even ignoring the `auth_json_response` refactor in CR-03, the inline pattern
  is verbose. The presence of four identical `.expect("auth JSON response
  serialization cannot fail")` strings is a sign of manual duplication.
- **Evidence:** Each site:
  ```rust
  println!(
      "{}",
      serde_json::to_string_pretty(&auth_json_response(&target, "<verb>"))
          .expect("auth JSON response serialization cannot fail")
  );
  ```
- **Recommendation:** Either apply CR-03 (move to `output.rs` and return `String`)
  or at minimum add a thin private `fn emit_auth_json(profile: &str, action: &str)`
  in `auth.rs` that wraps the `println!`. This is a strictly mechanical refactor
  with no behavioral change. Worth doing before the file grows further.

---

### WV2-CR-05: `parse_duration` marked SUPERSEDED-BY in a doc comment but not with `#[deprecated]`

- **Severity:** SUGGESTION
- **Category:** maintainability
- **Location:** `src/duration.rs:75-81`
- **Description:** The doc comment on `parse_duration` says:
  `"SUPERSEDED-BY: parse_duration_validate (S-2.06); kept only for …"`.
  Rust's `#[deprecated]` attribute would surface this information at
  compile-time whenever the function is called from production code (with a
  helpful compiler note), rather than silently in a comment that readers might
  miss. The codebase does not appear to use `#[deprecated]` elsewhere, but this
  is exactly the canonical use-case for it.
- **Evidence:**
  ```rust
  // src/duration.rs:75-81
  /// SUPERSEDED-BY: parse_duration_validate (S-2.06); kept only for
  /// `format_duration` round-trip proptest and `format_duration` in
  /// `handle_list` (which needs seconds for display formatting).
  pub fn parse_duration(input: &str, hours_per_day: u64, days_per_week: u64) -> Result<u64> {
  ```
- **Recommendation:**
  ```rust
  #[deprecated(note = "Use parse_duration_validate for input validation. \
                        parse_duration is kept only for format_duration round-trip tests \
                        and handle_list seconds arithmetic. (S-2.06)")]
  pub fn parse_duration(input: &str, hours_per_day: u64, days_per_week: u64) -> Result<u64> {
  ```
  Add `#[allow(deprecated)]` at the call-sites in `handle_list` and the
  proptest module to silence the warning intentionally. This turns an invisible
  comment into a compiler-enforced boundary.

---

### WV2-CR-06: `normalised` uses British English spelling — inconsistent with rest of codebase

- **Severity:** NIT
- **Category:** readability
- **Location:** `src/duration.rs:24`
- **Description:** The variable `normalised` uses British English spelling. The
  rest of the codebase exclusively uses American English (`normalize_path` in
  `src/cli/api.rs`, `normalize` in `src/cli/auth.rs:1604`). Mixed spelling in a
  single crate is a maintainability micro-issue.
- **Evidence:**
  ```rust
  // src/duration.rs:24 — British:
  let normalised: String = trimmed.chars().filter(|c| !c.is_whitespace()).collect();
  // src/cli/api.rs:40 — American:
  pub fn normalize_path(raw: &str) -> Result<String>
  ```
- **Recommendation:** Rename to `normalized`. Zero behavioral change.

---

### WV2-CR-07: Duplicate format hint string across five error arms in `parse_duration_validate`

- **Severity:** SUGGESTION
- **Category:** maintainability
- **Location:** `src/duration.rs:17`, `:37`, `:49`, `:60`, `:67`
- **Description:** The hint string `"Use format: Nw Nd Nh Nm (e.g. 2h, 1d, 2d 3h 30m)"` 
  appears verbatim (or as a trailing clause) in all five error returns of
  `parse_duration_validate`. If the format hint ever needs updating — say to
  add "1w" to the examples — five sites must be found and changed.
- **Evidence:**
  ```rust
  // lines 17, 37, 49, 60, 67 all contain:
  "Use format: Nw Nd Nh Nm (e.g. 2h, 1d, 2d 3h 30m)"
  ```
- **Recommendation:** Extract to a private constant:
  ```rust
  const DURATION_FMT_HINT: &str = "Use format: Nw Nd Nh Nm (e.g. 2h, 1d, 2d 3h 30m)";
  ```
  Then reference `DURATION_FMT_HINT` in each error message. This is a small
  DRY improvement with high signal value in a function that has five early-return
  paths.

---

### WV2-CR-08: Inconsistent `output::` vs `crate::output::` qualification in `src/cli/auth.rs`

- **Severity:** NIT
- **Category:** readability
- **Location:** `src/cli/auth.rs:529`, `:1004`, `:1128`, `:1171`
- **Description:** Within the same file, `print_success` is called as
  `output::print_success(...)` at lines 529 and 1171, and as
  `crate::output::print_success(...)` at lines 1004 and 1128. Both are correct
  (the `use crate::output;` import at line 9 resolves both), but the
  inconsistency suggests the S-2.07 additions used `crate::` qualification
  while the pre-existing code used the short form.
- **Evidence:**
  ```rust
  // line 529 (pre-existing): output::print_success(...)
  // line 1171 (S-2.07 new):  output::print_success(...)
  // line 1004 (S-2.07 new):  crate::output::print_success(...)
  // line 1128 (S-2.07 new):  crate::output::print_success(...)
  ```
- **Recommendation:** Normalize all call-sites to `output::print_success(...)`.
  The `use crate::output;` import is already in scope. `crate::` qualification
  is redundant given the import and adds visual noise. Apply before the Wave 3
  auth split so the inconsistency is not amplified across sub-files.

---

### WV2-CR-09: Snapshot files for auth module land in `src/cli/snapshots/` alongside issue/sprint snapshots

- **Severity:** WORTH-DOING-LATER
- **Category:** test-org
- **Location:** `src/cli/snapshots/` (4 new auth snap files alongside 7 issue
  snap files and 2 sprint snap files)
- **Description:** All `src/cli/` module snapshots currently share one flat
  `src/cli/snapshots/` directory. The issue module already has its own
  dedicated `src/cli/issue/snapshots/` directory with 11 snap files. After
  S-2.07, `src/cli/snapshots/` contains a mix: 4 auth snaps, 2 sprint snaps,
  and 1 auth list table snap. As the auth module grows and eventually splits,
  this will become harder to navigate.
- **Evidence:**
  ```
  src/cli/snapshots/
    jr__cli__auth__tests__auth_login_json_shape.snap
    jr__cli__auth__tests__auth_logout_json_shape.snap
    jr__cli__auth__tests__auth_remove_json_shape.snap
    jr__cli__auth__tests__auth_switch_json_shape.snap
    jr__cli__auth__tests__list_table_snapshot.snap
    jr__cli__sprint__tests__sprint_add_response.snap
    jr__cli__sprint__tests__sprint_remove_response.snap
    jr__cli__issue__json_output__tests__*.snap  ← 11 files here AND in issue/snapshots/
  ```
  Note: the issue snap files appear in BOTH `src/cli/snapshots/` and
  `src/cli/issue/snapshots/` — insta convention places snaps adjacent to the
  module under test. The split is already partially done for issue; auth and
  sprint have not been moved.
- **Recommendation:** Not blocking — insta resolves snap paths by module path
  prefix, so the files are functionally correct where they are. Flag for Wave 3
  when the auth split creates a natural opportunity to move auth snaps to a
  `src/cli/auth/snapshots/` directory.

---

### WV2-CR-10: `handle_login` inconsistently uses `args.output` by value while other handlers use `&OutputFormat`

- **Severity:** NIT
- **Category:** api-design
- **Location:** `src/cli/auth.rs:629`
- **Description:** `handle_login` receives `LoginArgs` by value and accesses
  `args.output` (consuming it), while `handle_logout`, `handle_remove`, and
  `handle_switch` receive `output: &OutputFormat` by reference. The mixed
  pattern is a minor inconsistency — `OutputFormat` derives `Copy` (if it
  does) or at minimum `Clone`, so consuming vs borrowing is not a correctness
  issue, but it creates a non-uniform signature style.
- **Evidence:**
  ```rust
  // handle_login (S-2.07 new field in LoginArgs):
  pub output: OutputFormat,   // field in struct, taken by value
  if matches!(args.output, OutputFormat::Json)   // consumed via struct field

  // handle_logout (S-2.07 new param):
  pub async fn handle_logout(profile_arg: Option<&str>, output: &OutputFormat)
  if matches!(output, OutputFormat::Json)         // borrowed reference

  // handle_switch (S-2.07 new param):
  pub async fn handle_switch(target: &str, cli_profile: Option<&str>, output: &OutputFormat)
  ```
  The inconsistency arises because `login` uses a `struct LoginArgs` aggregate
  while the others take explicit parameters.
- **Recommendation:** If `OutputFormat` derives `Copy`, the difference is
  inconsequential but the style should be documented or made uniform. If a
  future refactor converts `handle_logout` etc. to accept `LogoutArgs` structs,
  ensure they also embed `OutputFormat` to match `LoginArgs`. No change needed
  now; note for the args-struct unification pass.

---

### WV2-CR-11: `auth_output_json.rs` helper `jr_isolated` clears 12 env vars inline — could use a builder

- **Severity:** NIT
- **Category:** readability
- **Location:** `tests/auth_output_json.rs:69-93`
- **Description:** The `jr_isolated` helper clears 12 `JR_*` environment
  variables inline via `.env_remove(...)` calls. The list is long enough that
  adding or removing an env var requires finding the right insertion point in
  the chain. A method or a named slice would make the list easier to audit.
  This is a minor readability note; the current form is functionally correct.
- **Evidence:**
  ```rust
  fn jr_isolated(config_dir: &TempDir, cache_dir: &TempDir) -> Command {
      // ... 12 env_remove calls for JR_PROFILE, JR_DEFAULT_PROFILE, ...
      // JR_BASE_URL, JR_AUTH_HEADER, JR_EMAIL, JR_API_TOKEN, ...
  }
  ```
- **Recommendation:** Extract the list of env var names to a `const` slice and
  iterate over it, or move `jr_isolated` into `tests/common/` with the other
  shared helpers. The secondary benefit is that if a new `JR_*` env var is
  added to the codebase, there is a single location to update to ensure test
  isolation.

---

## Summary Assessment

### Top 3 Highest-Leverage Refactor Opportunities

1. **`jr_cmd` consolidation into `tests/common/`** (CR-01) — Eliminates five
   identical copy-paste blocks across all holdout suites. Low risk, high
   maintainability dividend, easy to do as a prep commit before Wave 3.

2. **`auth_json_response` → `output.rs` + make it return `String`** (CR-03 + CR-04) —
   Collapses four repeated 5-line emit blocks to single-line calls, removes
   four identical `.expect()` strings, and positions the helper for re-use
   when the auth module splits in Wave 3. Medium effort, high clarity gain.

3. **`DURATION_FMT_HINT` constant extraction in `src/duration.rs`** (CR-07) —
   The format-hint string appears five times in 73 lines. A one-line constant
   eliminates update-in-five-places risk and makes each error branch scannable
   at a glance.

---

### Merge Readiness Verdict

Wave 2's production code changes (S-2.06, S-2.07) are clean and correct. The
`timeSpent` passthrough simplification in `add_worklog` is a genuine
improvement — delegating string validation to the Jira server rather than
forcing a client-side arithmetic mapping. The `parse_duration_validate` function
is appropriately scoped (syntax-only, no arithmetic) and well-documented. The
`OutputFormat` threading in the four auth handlers follows the existing pattern
established by `handle_list` and `handle_refresh`.

The findings above are all SUGGESTION, NIT, or WORTH-DOING-LATER severity.
None constitute a blocker for merge. The test infrastructure duplication
(CR-01, CR-02) is the most material gap: the five identical `jr_cmd` helpers
will silently diverge if the command's env-var wiring ever changes. That risk
is acceptable for Wave 2 merge but should be addressed in the Wave 3
cleanup pass before the holdout suite count grows further.

**Verdict: CONCERNS (non-blocking) — clean to merge; Wave 3 cleanup pass
recommended to address CR-01, CR-03, CR-04, and CR-07.**

`findings remain -- iterate`

> Note: No CRITICAL or HIGH findings were identified. All findings are
> SUGGESTION / NIT / WORTH-DOING-LATER. The "findings remain" verdict
> reflects that the refactor opportunities are worth tracking, not that
> merge is blocked.
