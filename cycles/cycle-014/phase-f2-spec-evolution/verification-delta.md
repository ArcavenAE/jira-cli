---
document_type: verification-delta
phase: phase-f2-spec-evolution
step: "F2 Step 4 — Verification Property Extension"
producer: formal-verifier
cycle: cycle-014
feature_slug: issue-triage-quickfixes
issue_refs: ["#862", "#861", "#583"]
created: 2026-09-25
status: draft
revised: 2026-09-25  # F2 consolidation: rewritten as current state + one condensed history
inputs:
  - ".factory/cycles/cycle-014/phase-f2-spec-evolution/prd-delta.md"
  - ".factory/cycles/cycle-014/phase-f1-delta-analysis/delta-analysis.md"
  - ".factory/specs/prd/cross-cutting.md"
vp_count_before: 89
vp_count_after: 97
vp_count_basis: >
  STATE.md tracks 89 VPs at the cycle-014 F1-gate checkpoint (v4.94, 2026-09-24). No
  standalone VP registry exists in this repo (S-PG-VP-REGISTRY-1 is still a draft story, and
  `.factory/specs/verification-architecture/` does not exist). VPs live inline in BC bodies,
  and the running total is carried by STATE.md plus each cycle's verification delta. This delta
  adds 8 VPs, so 89 → 97.
new_vps:
  - VP-USER-LIST-PROJECT-001   # BC-X.7.002 (#862)
  - VP-580-013                 # BC-X.14.001 (#861) — renumbered from colliding "VP-580-011"
  - VP-API-QP-001              # BC-X.16.001 (#583)
  - VP-API-QP-002              # BC-X.16.001
  - VP-API-QP-003              # BC-X.16.001
  - VP-API-QP-004              # BC-X.16.001
  - VP-API-QP-005              # BC-X.16.002
  - VP-API-QP-006              # BC-X.16.002
renamed_vps:
  - from: "VP-580-011 (cycle-014 mint, BC-X.14.001)"
    to: VP-580-013
    reason: "ID collision — VP-580-011 already exists on BC-X.14.002 (--value + graceful-degrade, 2026-08-26); VP-580-012 also taken (BC-X.14.004)"
updated_vps: []   # VP-580-008 (BC-X.14.003 JSON/table shape) deliberately NOT modified
kani_proofs_new: []
fuzz_targets_new: []
related_bcs: [BC-X.7.002, BC-X.14.001, BC-X.14.003, BC-X.16.001, BC-X.16.002]
input-hash: "c8f58d7"
---

# Verification Delta: issue-triage-quickfixes (cycle-014)

The cycle-014 delta amends BC-X.7.002 (#862), amends BC-X.14.001/003 (#861, read side only)
and adds BC-X.16.001/002 (#583). The authoritative VP text is inline in
`.factory/specs/prd/cross-cutting.md`; this file is the rationale and the F4/F6 hand-off.

## 1. Current VP Set

**8 new VPs, total 89 → 97. One ID renumbered (VP-580-011 → VP-580-013). No Kani proofs, no
fuzz targets.**

| VP | BC | What it proves | Strategy |
|----|----|----------------|----------|
| VP-USER-LIST-PROJECT-001 | BC-X.7.002 | Project resolution over the 2^3 presence space of {local `--project`, global `--project`, configured default}: local > global > configured default (`.jr.toml` > profile) > `None` → exit 64 with zero HTTP (Postconditions 1-5, EC-X.7.002-1..6). Local-vs-global is decided by clap global-value propagation; the config fallback by the pure resolver; `--project ""` passes through as `Some("")` and skips the configured default; the handler uses the already-loaded `&Config`; every `--all` page carries `projectKeys`. | (a) inline `Cli::try_parse_from` pin on all four flag cells, the two empty-string cells, and two local `-p` short-alias cells (`user list -p L` and `--project G user list -p L` → `Some("L")`; the global `--project` has no short form); (b) `proptest!` on `resolve_user_list_project` over `cli_project` × {neither, `.jr.toml`-only, profile-only, both}; (c) wiremock integration, hermetic per §2, for EC-X.7.002-1..6, EC-X.7.002-3 split three ways, plus two `--all` pagination tests (global flag, configured default); (d) a `--help` integration cell: `jr user list --help` exits 0 and its whitespace-collapsed stdout contains `Project key (overrides the configured default project). Required when no project is configured in` and `or the active profile` (BC-X.7.002 Fix step 1; the pin skips the backticked `.jr.toml` token and clap's stripped trailing period). |
| VP-580-013 | BC-X.14.001 (+ BC-X.14.003 shape) | M1/M2 (`normalize_from_allowed_values` via `_at_depth`): every node's `label == value.or(name)` at every depth; presence-based (`value: Some("")` wins over `name`; explicit JSON `"value": null` is `None` and falls through to `name`, EC-X.14.001-12); `id` and tree shape preserved; JSON key set `{"id","label","children"}` unchanged; M3 unaffected (no `name` fallback); `--value` now matches system-field names via the fallback label (EC-X.14.001-13). | (1) example matrix {value-only, name-only, both, neither} at top level and one child level (EC-X.14.001-8..11), plus JSON-deserialized `"value": ""` and `"value": null` cells (EC-X.14.001-12); (2) `proptest!` over a recursive `AllowedValue` tree (depth ≤ 3); (3) serde key-set property; (4) M3 regression against a hand-written expected output (`{value,name}` → `label: None`; `{value,label,name}` → `label: Some("L")`; plus an ordinary `{value,label}` entry); (5) `priority`-shaped fixture through `src/cli/field.rs::filter_options` (delegating to `src/cli/field.rs::filter_one`) (EC-X.14.001-13). All pure. |
| VP-API-QP-001 | BC-X.16.001 | Separator oracle: `out == pre + s + pairs + frag`, `pairs := new_pairs.map(|(n,v)| enc(n) + "=" + enc(v)).join("&")` with `enc` = `urlencoding::encode`, `s` = `?` (no `?` in pre-`#` part), `""` (query empty or ends in `&`), `&` otherwise, including a query ending in a literal `?` (EC-X.16.001-9, so `?&` may legitimately appear). No blanket substring ban. A same-NAME pre-existing pair is kept verbatim (EC-X.16.001-12). | `proptest!` over paths with/without query, `?` in values and fragments, `&`-terminated queries, an empty query followed by a fragment, NAMEs colliding with the existing query; pinned EC-X.16.001-4/5/8/9/12 and `/s?#f` + `k=v` → `/s?k=v#f` (kills `find('?')` over the whole path). |
| VP-API-QP-002 | BC-X.16.001 | Repeated names: `parse(out_query) == existing ++ new_pairs`, where `existing := url::form_urlencoded::parse(in_query).collect()` (same length, flag order, no dedup); pre-existing pairs come first and are never overridden or deduplicated by a same-NAME `-q` (EC-X.16.001-12); a comma in VALUE never splits a `-q` occurrence (EC-X.16.001-13). | `proptest!` with a small NAME alphabet shared by the existing query and the new pairs (forced repeats and collisions); existing query built from already-encoded, `+`-free, `#`-free segments with no empty segments; separator placement left to VP-API-QP-001; pinned `/s?fields=summary` + `fields=status`; argv cell `jr api /x -q fields=summary,status` → exactly one pair `fields=summary%2Cstatus` on the wire (hermetic wiremock, kills `value_delimiter`); repeated-flags argv cell `jr api /x -q fields=summary -q fields=status` → raw query exactly `fields=summary&fields=status` via `received_requests()`, plus `jr api '/x?a=1' -q b=2 -q b=3` → `a=1&b=2&b=3` (hermetic wiremock, catch-all `.expect(0)`; kills a handler that forwards only the first/last pair or dedups). |
| VP-API-QP-003 | BC-X.16.001 | Encoding exactly once: (a) round-trip `decode(encode(v)) == v`, where `encode(v)` is the NAME/VALUE segment extracted from `append_query_params`'s output (not a direct `urlencoding::encode` call); (b) alphabet is RFC 3986 unreserved or uppercase `%HH`, space → `%20`, never `+`; (c) encoder identity with `urlencoding::encode` (`*` → `%2A`, space → `%20`, both failed by `byte_serialize`); (d) no trimming; (e) `jr api --help` contains `do not pre-encode` (Behavior 3). | Biased `proptest!` over UTF-8 (`%`, `&`, `=`, `#`, `+`, space, `?`, CR/LF, pre-encoded look-alikes) + pinned examples (`%` → `%25`, `+` → `%2B`, `é` → `%C3%A9`, `%25` → `%2525`) + a `--help` integration cell matched on whitespace-collapsed stdout. |
| VP-API-QP-004 | BC-X.16.001 | Method orthogonality (query identical for GET/POST/PUT/PATCH/DELETE, with and without `-d`; body never moved into the query or vice versa) and zero-flag identity: the path handed to the request is byte-identical to `normalize_path`'s output, and `append_query_params(p, &[]) == p`. | Structural (no method/body parameter) + table-driven wiremock (hermetic per §2) + `proptest!` identity + no-`-q` wiremock examples asserting the received path/query; existing `jr api` tests unmodified. |
| VP-API-QP-005 | BC-X.16.002 | `parse_query_param` taxonomy: split on first `=`; no `=` (including the empty string) → pinned M1; empty NAME → pinned M2; whitespace-only NAME accepted; later `=` kept in VALUE; empty VALUE allowed. Messages byte-exact with `{raw}` untrimmed; each asserts its own distinguishing substring present and the other absent. | Partition `proptest!` on the pure parser + wiremock (hermetic per §2) for `-q foo` / `-q =v` (exit 64, `.expect(0)`, stderr contains the rendered message; `--output json` envelope `{"error","code"}` parsed from STDERR with `error` == rendered message and `code` 64, stdout empty) + attached-form cells EC-X.16.002-5..8: `-q=v` → M1 `(got: v)`; `-q==v` and `--query-param==v` → M2 `(got: =v)`; `-q -x=1` → clap exit 2, not 64, stderr contains `unexpected argument` and not `Not authenticated` (which also exits 2), neither D1 nor D2; EC-X.16.002-9: pinned `parse_query_param("")` → M1 `(got: )`, and argv cells `-q=`, `--query-param=`, `-q ""` → exit 64, zero HTTP, stderr contains D1 and not D2 (kills an empty-NAME check evaluated before the missing-`=` check); EC-X.16.002-10: `-q` as the last argv token → clap exit 2, not 64, zero HTTP, stderr contains `a value is required for` and not `Not authenticated`, neither D1 nor D2. |
| VP-API-QP-006 | BC-X.16.002 | Pre-flight ordering and all-or-nothing: (i) one malformed flag aborts with no request; (ii) the first malformed flag in flag order is reported; (iii) `-q` validation precedes `resolve_body`: with stdin piped and held open, the child exits on its own within ~5 s with exit 64 and M1. The held-open pipe is the discriminating case of EC-X.16.002-4, which covers TTY, inherited, closed and held-open stdin; only held-open tells the two orderings apart; (iv) `-q` error precedes a malformed `-H`. | Wiremock integration, hermetic per §2, every mock `.expect(0)`; (iii) spawns the binary with `std::process::Command` and polls `try_wait()` (not assert_cmd, see §2). |

Pinned messages (VP-API-QP-005, copied from BC-X.16.002; M2 contains U+2014):

- M1: `--query-param must be in NAME=VALUE format (got: {raw})`
- M2: `--query-param NAME cannot be empty (got: {raw}) — use NAME=VALUE, e.g. -q maxResults=50`

Distinguishing substrings: D1 = `must be in NAME=VALUE format` (M1's), D2 = `NAME cannot be empty` (M2's).

VP-USER-LIST-PROJECT-001's exit-64 message: `No project configured. Run "jr init" or pass
--project. Run "jr project list" to see available projects.`

### ID validation

The repo uses both issue-number families (`VP-576-*`, `VP-580-*`, …) and feature-slug families
(`VP-OAUTH-GW-*`, `VP-SORT-*`, …). There is no central registry; `grep` across `specs/`,
`cycles/` and `stories/` is the uniqueness check. VP-USER-LIST-PROJECT-001 and
VP-API-QP-001..006 have zero prior occurrences. The inline-minted "VP-580-011" collided with
the existing BC-X.14.002 VP (VP-580-012 is also taken), so it became VP-580-013, staying in the
#580 `field options` family.

## 2. F4 Guidance

### Pure-function extraction

- **`src/cli/user.rs`** — pinned signature:

  ```rust
  pub(crate) fn resolve_user_list_project(cli_project: Option<&str>, config: &Config) -> Option<String>
  ```

  `cli_project` is the post-clap `UserCommand::List.project` (global already propagated by
  clap). Body: `config.project_key(cli_project)`. `None` maps to the canonical exit-64
  `JrError::UserError`. `handle_list` must call it with the `&Config` passed from `main.rs`
  and never reload config. Precedent: `src/cli/field.rs::resolve_m2_project`.
- **`src/cli/api.rs::parse_query_param`** — pure parser, `&str` → `Result<(String, String), _>`,
  splits on the first `=`, emits M1/M2 verbatim with the raw argument, never trims.
- **`src/cli/api.rs::append_query_params`** — pure string assembler (path + pairs → path), no
  method/body parameter, no `JiraClient`. Encodes with `urlencoding::encode`;
  `url::form_urlencoded::byte_serialize` is forbidden. `url::form_urlencoded::parse` is a
  test-only oracle.
- `handle_api` runs all `-q` parsing before `parse_header` and `resolve_body` (D-188
  pre-flight convention). Help text for `--query-param`: "pass raw values; do not pre-encode".
  Raw `%25` correctly encodes to `%2525`; tests must not assert otherwise.

### Hermetic test setup (the one setup every VP integration test cites)

Every wiremock/binary integration test for these VPs (VP-USER-LIST-PROJECT-001(c),
VP-API-QP-002's argv cells, VP-API-QP-004, VP-API-QP-005, VP-API-QP-006) uses exactly this setup:

1. `JR_CONFIG_DIR` and `JR_CACHE_DIR` set to a fresh per-test `TempDir`.
2. The child's `cwd` is a directory with no `.jr.toml` in it or any ancestor (a temp dir). A
   case that needs a `.jr.toml` writes it into its own temp `cwd`.
   `find_project_config` (`src/config.rs`) walks from `current_dir()` up through every ancestor
   to the filesystem root and returns the first `.jr.toml` it finds. On Windows, `%TEMP%` lives
   under the user profile (`%LOCALAPPDATA%\Temp`), so a `~\.jr.toml` would be found by that
   walk. A test needing "no `.jr.toml` ancestor" must not assume the temp dir has a clean
   ancestry: either create its `TempDir` under a root with no ancestor `.jr.toml`, or assert the
   precondition at test start by walking the `cwd`'s ancestors and failing loudly (panic with a clear message naming the
   offending ancestor `.jr.toml`) if any contains one. A Rust early-return 'skip' reports PASS
   and would hide the violated MUST precondition.
3. `JR_BASE_URL` points at the test's wiremock server.
4. Auth comes from the existing debug test seam, `JR_AUTH_HEADER`, so the test reaches the BC's
   own path (exit 64 or the request) rather than an auth failure.
5. `env_remove("JR_PROFILE")`, plus removal of every other ambient `JR_`-prefixed variable
   (`Config::load_inner`, `src/config.rs`, overlays `Env::prefixed("JR_")` onto `GlobalConfig`
   and reads `JR_PROFILE` separately). Clear all ambient `JR_`-prefixed variables EXCEPT the
   seams the test sets (`JR_CONFIG_DIR`, `JR_CACHE_DIR`, `JR_BASE_URL`, `JR_AUTH_HEADER`, from
   steps 1, 3 and 4); no other `JR_` variable reaches the child.

`tests/user_commands.rs::user_list_requires_project_flag` is made hermetic the same way, with one
exception to step 3: it may keep its existing unreachable `JR_BASE_URL=http://127.0.0.1:1` and no
mock server. Any stray request fails with a connection error (exit 1, "Could not reach…"), which
the test's `--project`/`required` stderr assertion rejects, so it still proves zero successful HTTP.
### VP-API-QP-006(iii) held-open stdin

VP-API-QP-006(iii) must hold the stdin pipe open on purpose: `/dev/null` or a closed pipe gives
immediate EOF and proves nothing. Do not use assert_cmd for it: assert_cmd 2.2.2's `output()`
path closes the child's stdin before waiting (`wait_with_input_output` → wait-timeout 0.2.1
`drop(self.stdin.take())`, and `Child::wait` on the untimed path), so its timeout cannot hold a
pipe open. Instead spawn `env!("CARGO_BIN_EXE_jr")` with `std::process::Command`, pipe
stdin/stdout/stderr, keep the `ChildStdin` handle alive without writing to it, poll `try_wait()`
against a ~5 s deadline, and assert exit 64 plus D1 (M1's distinguishing substring, `must be in NAME=VALUE format`; D2 is M2's, `NAME cannot be empty`) on stderr; on the deadline, kill the child
and fail.

VP-API-QP-005's `--output json` cells read the `{"error","code"}` envelope from stderr (it is
written by `src/main.rs`'s top-level `eprintln!`) and assert stdout is empty. Its attached-form
cells (EC-X.16.002-5..8) must run as real argv, since `{raw}` is what clap delivers after
stripping one leading `=`. The `-q` flag must not get `allow_hyphen_values`; the `-q -x=1` cell
pins exit 2 with clap's `unexpected argument` text on stderr and no `Not authenticated` text.

EC-X.14.001-14 (system fields resolved by display name, `fixVersions` not found, `version`
ambiguous) is informational: it is pre-existing `resolve_field_id`/`search_field_list`
behavior and gets no VP-580-013 cell. Existing coverage: `src/cli/field.rs` unit tests
`test_bc_x_14_001_search_field_list_{exact_single_match,case_insensitive,substring_single_match,zero_match_returns_none,exact_multiple_is_err,substring_multiple_is_err}`
and `tests/field_options.rs::test_bc_x_14_001_field_name_{ambiguous_exits_64,human_name_resolves_via_partial_match,zero_match_exits_64}`
(stale name: the code path is `search_field_list`; STORY-B renames it per prd-delta.md's F4
obligation). The same F4 obligation also has STORY-B correct the matching stale wording in:
the `jr field options --help` doc comment on `src/cli/mod.rs::FieldCommand::Options.field`;
the "custom field" about-text (`src/cli/mod.rs` ~L128 and ~L1224); the Step 2 comment in
`src/cli/field.rs::handle`; the `tests/field_options.rs` comments (~L1436, ~L2050); the `src/cli/field.rs` module doc (line 1,
"enumerate a custom field's allowed options"); the `README.md` command-table row (~L346); and the
`CLAUDE.md` architecture-tree entry for `field.rs` (~L61). No VP asserts the help wording or these
doc sites. This is a doc-accuracy obligation, not a verification cell.
The empty-name guard already has coverage in
`tests/field_options.rs::test_bc_x_14_001_empty_field_name_exits_64_zero_http`.

EC-X.16.002-11 (a non-UTF-8 `-q` argv value, rejected by clap's `String` value parser with
exit 2 before `parse_query_param` runs) is likewise informational. It is inherited clap
behavior, shared with `-H`, and gets no VP cell.

### `.cargo/mutants.toml` examine_globs (approved, D-379; per story at F4)

| File | In examine_globs today? | Action | Added by |
|---|---|---|---|
| `src/cli/user.rs` | No | **ADD** | STORY-A (#862) PR, at F4 |
| `src/cli/api.rs` | No | **ADD** | STORY-C (#583) PR, at F4 |
| `src/cli/field.rs` | Yes | none | — |
| `src/main.rs` | Yes | none | — |
| `src/cli/mod.rs` (clap derive) | No | not needed: declarative; covered via (a) and integration tests | — |
| `src/types/jira/editmeta.rs` (doc comment) | No | not needed | — |

Each glob lands in the same PR that defines its file's functions, not in a batched F6 PR. F6
verifies both additions; it does not introduce them. `tests/mutants_glob_existence.rs` passes
automatically since both files already exist.

### `docs/specs/cargo-mutants-policy.md` §Scope bullets (per story, same PR as the glob)

Use the policy's existing `` `file` — `symbol` `` bullet form, not `file::symbol`:

- STORY-A (#862) adds: `` - `src/cli/user.rs` — `resolve_user_list_project` (configured-default fallback for user list's post-clap project value via Config::project_key; local-vs-global precedence is clap global-value propagation) (added cycle-014) ``
- STORY-C (#583) adds: `` - `src/cli/api.rs` — `append_query_params` (pure path + query-pair assembler, encodes each NAME/VALUE exactly once), `parse_query_param` (NAME=VALUE split and validation for -q) (added cycle-014) ``

Why per story: `check-cargo-mutants-policy-citations.sh` fails CI (CI-MUTANTS-CITE-001) on any
cited function with no definition line in its file. A bullet therefore cannot land before its
function, so neither story's PR can carry the other story's bullet.

The guard takes the FIRST backtick token on the bullet as the file and requires it to match
`^src/[a-zA-Z0-9_/.-]+\.rs$`. A `file::symbol` token fails that match and is reported as a
malformed bullet. Every later backtick token in the bullet group that matches
`^[a-z_][a-z0-9_]*$` (after dropping anything up to a final `::`) is treated as a function name
and must have a definition line (`fn <name>`, optionally `pub`/`pub(crate)`/`async`) in that
file. The parenthetical descriptions must not backtick any other lowercase identifier.

Delivery is serial, A → C → B (human decision 2026-09-25): STORY-A (#862), then STORY-C (#583)
rebased on it, then STORY-B (#861). So the edits are fixed in this order:

- STORY-A (#862): add `src/cli/user.rs` to `.cargo/mutants.toml` examine_globs, set the policy's
  "Current `examine_globs` count" line to 33 (from 32, verified against `.cargo/mutants.toml` on
  2026-09-25), add its §Scope bullet above, and add a row at the top of the policy's
  `| Date | Cycle | Change |` change-log table (newest first), e.g. `| <merge date> | cycle-014 |
  Added src/cli/user.rs to examine_globs and §Scope (examine_globs count 32 → 33). |`.
- STORY-C (#583): add `src/cli/api.rs`, set the count line 33 → 34, and add its §Scope bullet and
  its own newest-first change-log row.

No CI check compares the count line with `.cargo/mutants.toml`, so each story must count the
actual entries after its edit rather than trust the number above (a known gap, recorded as a
process-gap follow-up).

### Fault models vs. what cargo-mutants generates

The VP fault models are broader than cargo-mutants' operator set. Keep them separate.

**A. Classes cargo-mutants actually generates in scope** (function-body replacement with
defaults, binary/comparison operator swaps, `!` deletion, match-arm deletion), and their
killers:

- `resolve_user_list_project` body → `None` / `Some(String::new())` / `Some("xyzzy".into())` →
  VP-USER-LIST-PROJECT-001(b).
- `parse_query_param` body (`-> Result<(String, String), _>`) → the tuple cross-product
  cargo-mutants builds from each `String` element's replacements: `Ok((String::new(),
  String::new()))`, `Ok((String::new(), "xyzzy".into()))`, `Ok(("xyzzy".into(),
  String::new()))`, `Ok(("xyzzy".into(), "xyzzy".into()))` → VP-API-QP-005 partition proptest
  (the `Err` partitions and the exact-`Ok((NAME, rest))` partition). If F4 returns
  `anyhow::Result<(String, String)>` (the repo norm; cf. `src/cli/api.rs::parse_header ->
  Result<(HeaderName, HeaderValue)>`), cargo-mutants 27.1.0 does NOT add an `Err(...)` body
  replacement on its own: `src/fnvalue.rs::type_replacements`'s `Result` arm emits only the
  `Ok(..)` cross-product above and chains `Err(#expr)` solely from the configured
  `error_values` (`--error` / `.cargo/mutants.toml` `error_values`), which this repo does not
  set. If `error_values = ["::anyhow::anyhow!(\"mutated!\")"]` is ever configured, the extra
  `Err(::anyhow::anyhow!("mutated!"))` mutant is killed by VP-API-QP-005's `Ok` partitions
  (valid `NAME=VALUE` inputs must return `Ok((NAME, rest))`).
- `append_query_params` body → `String::new()` / `"xyzzy".into()` → VP-API-QP-001/004 identity.
- `==`/`!=`, `&&`/`||` swaps in the separator decision (empty-query / ends-with-`&` tests) →
  VP-API-QP-001.
- `==`/`!=` or `!` deletion in the empty-NAME check → VP-API-QP-005.
- `normalize_from_allowed_values_at_depth` body replacement → VP-580-013 matrix and proptest.

**B. Hand-written fault models (not generated by cargo-mutants; the VPs are designed to catch
them if an implementer writes them):**

- #862: `handle_list` bypassing the resolver; the handler reloading config (killed by
  EC-X.7.002-5); project applied to `--all` page 1 only.
- #862 (cont.): an empty-string special case (`Some("")` treated as absent).
- #861: fallback removed entirely (pre-fix code: `label: v.value.clone()`), killed by the
  EC-X.14.001-8 name-only cell; `name` preferred over `value`; emptiness-based fallback; explicit JSON `null` treated as
  present; fallback at top level only; fallback leaking into M3.
- #583 assembly: `?`/`&` swapped; `ends_with('&')` → `ends_with('?')`; `find('?')` over the
  whole path instead of pre-`#`; fragment dropped or misplaced; dedup/last-wins/reorder; zero
  or double encoding; `byte_serialize` substituted; `=` joiner encoded; NAME/VALUE trimmed; a
  same-NAME `-q` overriding or deduplicating a pre-existing query pair; a `?` or `&` appended on
  zero pairs; query gated on method; `-d` merged into query; `handle_api` forwarding only the
  first or last parsed `-q` pair to `append_query_params`, or deduplicating the parsed `Vec`
  (killed by VP-API-QP-002's repeated-flags argv cell).
- #583 parsing: M1/M2 swapped or merged; `{raw}` trimmed or re-split; `rfind('=')` instead of
  `find('=')`; NAME trimmed before the empty check; `-q` parsing after `resolve_body` or
  `parse_header`; filtering bad values instead of failing; reporting the last malformed value;
  the JSON error envelope written to stdout; `allow_hyphen_values` set on `-q`.


## 3. Why No Kani and No Fuzz

- **Kani:** safe-Rust `String`/`Option` composition, no `unsafe`, no index arithmetic, no
  concurrency. Proptest over the input spaces gives better evidence than bounded model checking
  of heap-allocating string code.
- **Fuzz:** `--query-param` values are the invoking user's argv (no trust boundary), the
  encoder is a well-fuzzed upstream crate, and VP-API-QP-003's biased proptest over-samples the
  adversarial byte classes. The #861 input is a typed serde struct already covered by
  VP-580-005's no-panic proptest. Revisit if a future delta parses server-supplied query text.
- **Security by construction:** VP-API-QP-003(b) guarantees no raw CR, LF, space, `#`, `&` or
  `=` from a `--query-param` value reaches the request-target (CWE-93 class closed).

## 4. Revision History (F2)

Initial mint (Step 4): 8 VPs, 89 → 97; spec-changelog `[2.4.0]` gained the New Verification
Properties table. Adversarial passes then revised the VP side as follows (count unchanged at 97
throughout):

- **VP-580-011 → VP-580-013 renumber** (ID collision with BC-X.14.002 and VP-580-012 taken).
- **PASS-1**
  - VP-USER-LIST-PROJECT-001: local-vs-global was re-grounded in clap global-value propagation,
    adding the `Cli::try_parse_from` pin (a). The resolver went from a 2-parameter
    `(local, global, config)` design to the 1-parameter post-clap signature now pinned. The
    earlier "wiring test kills a dropped `cli.project` pass-through mutant" claim was
    **withdrawn** — that mutant is equivalent. Hermetic setup added.
  - VP-API-QP-001: the original "never produce `?&` / leading `&`" wording was narrowed to the
    separator the assembly adds, stated as an oracle; trailing literal `?` gets `&`
    (EC-X.16.001-9); detection is pre-`#` only. The requested PO back-fill of EC-X.16.001-8/-9
    landed.
  - VP-API-QP-003: an earlier claim that `byte_serialize` would also pass was **corrected** — it
    emits `+` for space and leaves `*` unescaped. Encoder identity (c) and the normative
    alphabet were added; no-trim (d) added.
  - VP-API-QP-005/006: retargeted to `parse_query_param`; first-malformed reporting, held-open
    stdin + timeout ordering, and `-q`-before-`-H` added.
  - VP-580-013: reviewed, unchanged.
- **PASS-2**
  - VP-API-QP-005: the two error messages pinned verbatim, with present/absent distinguishing
    substrings and the JSON envelope equality.
  - VP-USER-LIST-PROJECT-001: mutant targets retargeted to resolver-body replacement and
    resolver bypass (the `.or(configured)` swap target did not exist in the pinned body);
    EC-X.7.002-5 no-reload test (profiles `default`/`alt`); two `--all` pagination tests;
    "exactly one request" scoped to the non-`--all` path.
- **PASS-3 / consolidation**: the layered `[STRENGTHENED]`/`[REVISED]` addenda in
  `cross-cutting.md` were collapsed into clean current VP blocks. First-malformed and
  held-open-stdin ordering now live in VP-API-QP-006 (ii)/(iii); this file was rewritten to
  match those blocks exactly, and the superseded 2-parameter design and withdrawn claims were
  removed from the body.
- **PASS-4**: VP-580-013 gained the explicit-`null` fall-through cell and an EC-X.14.001-13
  `--value` example. VP-USER-LIST-PROJECT-001 now pins all four clap flag cells, splits the
  configured default into `.jr.toml`-only/profile-only/both, covers EC-X.7.002-6, and clears
  `JR_PROFILE`/`JR_` overlays in the hermetic setup. VP-API-QP-004 restates zero flags as an
  observable identity; VP-API-QP-001/002 cover EC-X.16.001-12. Fault models: the
  `cli.project` pass-through "equivalent mutant" was removed (cargo-mutants never substitutes
  arguments and BC-X.7.002 has no such pass-through), and `parse_query_param`'s generated
  replacements are listed as the actual tuple cross-product.
- **PASS-5**: VP-API-QP-006(iii) was respecified to spawn the binary with
  `std::process::Command` and poll `try_wait()` with the stdin handle held, because
  assert_cmd 2.2.2 closes stdin before waiting (verified in the registry sources); the
  assert_cmd timeout rationale was removed. VP-API-QP-001 gained the `/s?#f` empty-query-plus-
  fragment example and generator case. VP-API-QP-005 now reads the JSON envelope from stderr
  with stdout empty, and gained the EC-X.16.002-5..8 attached-form cells. EC-X.14.001-14 was
  recorded as informational (no new cell). Three design defaults were marked for the human
  gate.
- **PASS-6**: the three design defaults were confirmed by the human and their open-item markers
  removed (§5). VP-580-013(4) now compares M3 output against a hand-written expected value whose
  `{value,name}` entry must yield `label: None`, so a `name` fallback leaking into M3 fails.
  VP-API-QP-002 gained an argv cell for EC-X.16.001-13 (`-q fields=summary,status` → one pair
  `fields=summary%2Cstatus`), which kills a `value_delimiter` regression. The hermetic setup
  is defined once in §2 and cited by every integration VP.
- **PASS-7**: VP-USER-LIST-PROJECT-001(a) gained the two local `-p` short-alias cells (the
  global `--project` has no short form). VP-API-QP-003 gained the `do not pre-encode` help-text
  cell (e). VP-API-QP-005's `-q -x=1` cell now also pins clap's `unexpected argument` text and
  the absence of `Not authenticated`, since both exit 2. VP-API-QP-002's oracle is now
  `parse(out_query) == parse(in_query) ++ new_pairs` with a constrained existing-query
  generator. The §1 table was aligned with VP-580-013 and VP-API-QP-002, and D1/D2 are
  defined where first used.
- **PASS-8**: VP-580-013 and §2 list B gained the simplest regression, the fallback removed
  entirely (`label: v.value.clone()`), killed by the EC-X.14.001-8 cell. BC-X.16.001's VP intro
  now scopes the `append_query_params` target to the proptests (VP-API-QP-002's argv cell and
  VP-API-QP-003(e) target the clap declaration and `--help` text). The stale
  `human_name_resolves_via_partial_match` test name in §2 is annotated for STORY-B's rename.
- **PASS-9**: The §2 stale-name annotation now lists the other stale wording STORY-B corrects in
  F4: the `field options` help text and about-text, the `field.rs` Step 2 comment, and the
  `tests/field_options.rs` comments. None of it is VP-asserted. §2 also cites the existing
  empty-name guard test. The VP-API-QP-006(iii) row now names the held-open pipe as
  EC-X.16.002-4's discriminating case.
- **PASS-10**: VP-API-QP-005 covers EC-X.16.002-9. An empty raw value reaches the parser as
  `""` and classifies as M1 `(got: )`, not M2. The no-`=` partition now includes `""`, with a
  pinned parser cell and hermetic argv cells for `-q=`, `--query-param=` and `-q ""` (exit 64,
  D1 present, D2 absent, zero HTTP). These kill a parser that checks empty NAME first.
- **PASS-11**: CLEAN. Cosmetic citation fix (P11-001): VP-580-013 (5) now cites `src/cli/field.rs::filter_options` / `src/cli/field.rs::filter_one` in full.
- **PASS-12**: CLEAN. Cosmetic (P12-004): the §2 hermetic setup now lets `user_list_requires_project_flag` keep its unreachable `JR_BASE_URL=http://127.0.0.1:1` with no mock server.
- **PASS-13**: P13-002: §2 STORY-B stale-wording list now also names `src/cli/field.rs` line 1, `README.md` ~L346, and `CLAUDE.md` ~L61 (doc-accuracy obligation, no VP).
- **PASS-14**: P14-001: VP-API-QP-002 gained a repeated-flags argv cell (`-q fields=summary -q fields=status` → raw query `fields=summary&fields=status`; mixed `'/x?a=1' -q b=2 -q b=3` → `a=1&b=2&b=3`) covering `handle_api`'s `Vec` → `append_query_params` wiring, with a matching §2 list B fault model; §2 step 5 now names the four retained `JR_` seams explicitly.
- **PASS-16**: Cosmetic (P16-007): VP-API-QP-003(a) now states `encode(v)` is the NAME/VALUE segment extracted from `append_query_params`'s output, not a direct `urlencoding::encode` call, so the round-trip exercises the function under test; (c) separately pins byte-identity with `urlencoding::encode`.
- **PASS-17**: P17-005: VP-API-QP-005 covers EC-X.16.002-10 with a hermetic argv cell: `jr api /x -q` (no value) → clap exit 2, zero HTTP, stderr contains clap_builder 4.6.7's `a value is required for` text, not `Not authenticated`, and neither D1 nor D2.
- **PASS-18**: Cosmetic (P18-004): §2 list A notes that for an `anyhow::Result` `parse_query_param`, cargo-mutants 27.1.0 generates an `Err(..)` replacement only when `error_values` is configured (unset here; verified in `src/fnvalue.rs`); if configured, VP-API-QP-005's `Ok` partitions kill it.
- **PASS-19**: P19-001: VP-USER-LIST-PROJECT-001 gained a `--help` cell (d) pinning BC-X.7.002 Fix step 1's help text on whitespace-collapsed stdout, following VP-API-QP-003(e). §2 step 2 notes that on Windows `%TEMP%` sits under the user profile, so `find_project_config`'s ancestor walk can find a `~\.jr.toml`; tests must use a clean-ancestry root or assert the precondition.
- **PASS-20**: P20-005: §2 notes EC-X.16.002-11 (non-UTF-8 `-q` value, clap `String` parser exit 2 before `parse_query_param`) as informational: inherited clap behavior shared with `-H`, no VP cell.
- **PASS-22**: CLEAN, 3 cosmetic (P22-001..003): VP-API-QP-001 defines `pairs` (`enc` = `urlencoding::encode`); VP-API-QP-005's `-q -x=1` cell asserts neither D1 nor D2; §2 step 2 requires failing loudly, not skipping.
- **PASS-23**: P23-001 (LOW): the §2 cargo-mutants-policy §Scope hand-off now prescribes the `` `file` — `symbol` `` bullet form, because `file::symbol` fails the citation guard's file-token shape check (CI-MUTANTS-CITE-001). It also now requires bumping the policy's `examine_globs` count from 32 (verified) to 34 and adding a change-log row.
- **PASS-24**: P24-001 (LOW): the §2 `src/cli/user.rs` §Scope bullet's parenthetical no longer claims the resolver does local > global precedence; per BC-X.7.002 it only applies the configured-default fallback (Config::project_key) to the post-clap value, and clap global-value propagation decides local-vs-global. The parenthetical stays free of backtick tokens, so the citation guard still extracts only `resolve_user_list_project`; the api.rs parentheticals were re-checked and are clean.
- **PASS-26**: CLEAN, 1 cosmetic (P26-001): cross-cutting.md VP-USER-LIST-PROJECT-001 bullet now says "Four layers:" and labels the `--help` cell "(d) **Help-text pin.**", matching this file's §1 labeling.
- **PASS-28**: P28-001: the §2 `examine_globs` and §Scope hand-offs are now per story at F4: STORY-A (#862) adds `src/cli/user.rs` and its `resolve_user_list_project` bullet, STORY-C (#583) adds `src/cli/api.rs` and its `append_query_params`/`parse_query_param` bullet. Each PR bumps the count by 1 in merge order (32 → 33 → 34) with its own change-log row, because the citation guard fails on a cited function not yet defined; parallel PRs conflict, so the second rebases. P28-003 (cosmetic): cross-cutting.md's BC-X.16.001 VP lead-in now names both VP-API-QP-002 argv targets.
- **PASS-29**: Human decision 2026-09-25: serial delivery A → C → B. §2 hand-off now fixes STORY-A at examine_globs count 32 → 33 and STORY-C at 33 → 34; the parallel rebase/recount paragraph (P29-002) is removed as moot; the unchecked count line is noted as a process-gap follow-up.

## 5. Decisions Confirmed During F2 Review

1. No trimming for `-q` NAME/VALUE (VP-API-QP-003(d)).
2. `--project ""` passes through as `Some("")` (VP-USER-LIST-PROJECT-001's empty-string cells).
3. A `-q` NAME colliding with an existing query sends both pairs, existing first (VP-API-QP-001/002).

Remaining hand-offs: state-manager sets the VP count to 97 at F2 close; F3 anchors STORY-A
(#862) → VP-USER-LIST-PROJECT-001, STORY-B (#861) → VP-580-013, STORY-C (#583) →
VP-API-QP-001..006.
