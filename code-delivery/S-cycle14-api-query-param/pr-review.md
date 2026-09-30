## PR Review: #887 — feat(api): add repeatable -q/--query-param NAME=VALUE to jr api (#583)

**Verdict: APPROVE** — 0 blocking findings, 2 suggestions, 3 nits.

### What was verified (all 10 changed files)

- **`append_query_params` (src/cli/api.rs):** empty pairs are an identity; the path is split at the first `#` before `?` detection, so new pairs always land before any fragment. Separator logic is correct for all three cases: no `?` → `?`; empty or `&`-terminated query → no separator; otherwise `&`. NAME and VALUE are each `urlencoding::encode`d exactly once. The only unencoded `?`/`&`/`=` in the output are ones the function inserts itself, so CR/LF, `#`, `&` and `=` in user input cannot inject a header, a parameter or a fragment.
- **Downstream:** `JiraClient::request` concatenates `base_url + path` (pre-existing), so the assembled query reaches the server unchanged. reqwest strips the fragment before sending, consistent with the CHANGELOG.
- **`parse_query_param`:** splits on the first `=` only. No `=` → M1; empty NAME → M2; both are `JrError::UserError` (exit 64). `k=` is accepted. No trimming (deliberate and documented).
- **Validation order in `handle_api`:** normalize_path → `-q` (fail-fast via `collect::<Result<_>>()?`) → `resolve_body` (so `-d @-` cannot block on a malformed `-q`) → `-H` → HTTP. The tests assert zero requests reach wiremock on any malformed `-q`.
- **Wiring:** the clap field is a plain `Vec<String>` (repeatable, empty default). The `main.rs` change is mechanical; no other subcommand is affected.
- **Docs:** CHANGELOG `### Added` sits under `[Unreleased]`. The README row, the mutants glob count 33→34 (consistent across `.cargo/mutants.toml` and the policy doc) and the CLAUDE.md size-deviation entry all match the diff.
- **Commits:** Conventional Commits format, each referencing #583.
- **Dependencies:** none added.
- **Demo evidence:** none in the diff, which is expected — `docs/demo-evidence` was purged from the product repo and gitignored in #708.
- **Upstream dependency:** PR #886 is merged (it is the base).
- **Size:** roughly 1.8k LOC, mostly tests; production code is about 110 LOC, which is acceptable.

### Suggestions (non-blocking)

| Severity | Category | Finding | Suggestion |
|---|---|---|---|
| suggestion | dependency/process | At review time, `Test (windows-latest)` and mutation shards 0–4 were still pending. | Confirm `ci-gate` is green before merging. If Windows flakes, raise the 5 s held-stdin deadline in `test_bc_x_16_002_query_param_validated_before_resolve_body_blocks_on_stdin`. |
| suggestion | description | The description says "54 tests" in `tests/api_query_param.rs`, but the file has 24 `#[test]`/`#[tokio::test]` functions (54 probably counts tests pulled in from `tests/common`). | Reword so the count can be verified, e.g. "24 test functions (54 in the test binary)". |

### Nits

| Severity | Category | Finding | Suggestion |
|---|---|---|---|
| nit | coherence | M1/M2 messages echo the raw `-q` value (`got: {raw}`), which matches `parse_header`. A token passed as a query value would show up on stderr. | Informational only. |
| nit | description | `-q -x=1` is rejected by clap (exit 2). This is tested and documented, but `--help` does not mention the workaround. | Mention `-q=-x=1` / `--query-param=-x=1` in the help text. |
| nit | description | The README `jr api` row still says `--body`; the actual flag is `-d`/`--data`. This predates the PR, but the row was edited here. | Fix while touching the row. |

Nothing here reopens the design choices recorded in the PR's Architecture Decision Record.
