## PR Review — #698 `feat(queue): surface queue-declared custom fields in queue view JSON (#693)`

**Verdict: COMMENT** — no blocking findings. 6 suggestions + 3 nits, none of which need to
land before merge. (Review posted in COMMENT state because the authenticated account is the
PR author; self-approval isn't possible on GitHub. Treat this as "approve with suggestions".)

Reviewed the full diff across all 3 changed files (`CHANGELOG.md`, `src/cli/queue.rs` +119/-12,
`tests/queue.rs` +837). Below I list what I verified before concluding — not just what I found.

---

### What I verified (no rubber-stamp)

| # | Check | Result |
|---|-------|--------|
| 1 | Allow-list grammar is exactly `^customfield_\d+$` | ✅ `strip_prefix("customfield_")` (case-sensitive) + `!rest.is_empty()` + `rest.bytes().all(is_ascii_digit)` is anchored on both ends by construction. Correctly rejects `customfield_`, `customfield_10050_x`, `Customfield_99`, `  customfield_1`, `customfield_1 `, `customfield_+1`, and non-ASCII digits (`customfield_١٠`) — byte-level `is_ascii_digit` will not accept Unicode Nd. No upper bound on digit count, as documented. |
| 2 | Fail-open does NOT swallow primary-pipeline errors | ✅ The `match` wraps **only** `client.list_queues()` inside the `QueueIdSource::ById` arm. `get_queue_issue_keys` (step 1), `search_issues` (step 2), and `resolve_queue_by_name` (name path) all still use `?`. AC-8 pins search 401 → exit 2 with the ordinary error surface. |
| 3 | Fail-open covers both degrade modes | ✅ `Err(e)` and `Ok(_)`-but-no-id-match each emit a distinct stderr warning, set `queue_fields = None` → `extra_fields = &[]`, and exit 0. Both pinned by AC-3(a)/(b) including exact warning text. |
| 4 | Zero-issue short-circuit unaffected | ✅ The aux lookup is placed *after* the `keys.is_empty()` early return, so a zero-issue queue makes neither the aux `list_queues` nor the `search_issues` call. AC-7 asserts 0/0 and additionally proves it by deliberately not mounting those routes (an attempt would 404 and fail the run). |
| 5 | `retain` on `IssueFields::extra` cannot strip base output | ✅ Checked `src/types/jira/issue.rs::IssueFields`: all 17 `BASE_ISSUE_FIELDS` members are **named struct fields** (incl. the renamed `issuetype`→`issue_type`, `fixVersions`→`fix_versions`), so no base field ever lands in the `#[serde(flatten)] extra` map. The "belt-and-suspenders in production, load-bearing for the degrade path" comment is accurate. |
| 6 | Table path untouched | ✅ `issue_table_headers(false, false, false, false)` + `format_issue_rows_public(&issues)` are byte-identical to pre-#693. AC-6 pins both the 6 standard headers and the absence of the field id/value. |
| 7 | `resolve_queue_by_name` signature change loses nothing | ✅ `MatchResult::Exact` is the only `Ok` branch, and it carries `queue.fields` through; `ExactMultiple`/`Ambiguous`/`None` are all `Err`. So there's no success path where a resolved queue silently drops its `fields[]`. Only production caller is `handle_view`; the 3 other references are tests. |
| 8 | Aux lookup isn't page-limited | ✅ `JiraClient::list_queues` auto-paginates (50/page loop), so a service desk with >50 queues can't produce a spurious "no matching queue" degrade. |
| 9 | CI evidence | ✅ Run 31753264866: Format, Clippy (ubuntu+windows), Test (ubuntu+macos), MSRV 1.85.0, Deny, Coverage, Spec Guards, gitleaks all green. `Test (windows-latest)` still pending at review time — should be confirmed green before merge. See finding S4 re: the "Mutation testing" green. |
| 10 | Diff coherence / description accuracy / commit quality | ✅ All three files serve #693; conventional-commit subject with story ID and `Closes #693`; PR body matches what the diff actually does. 966 additions but 837 are tests — production delta is 119 lines. |

---

### Findings

| # | Severity | Category | Finding |
|---|----------|----------|---------|
| S1 | suggestion | efficiency | `--id` aux lookup lists **all** queues to read one queue's `fields[]` |
| S2 | suggestion | reuse | `^customfield_\d+$` predicate now implemented twice in the codebase |
| S3 | suggestion | coverage | New pure helpers have no inline unit tests despite an existing `mod tests` |
| S4 | suggestion | coverage | Mutation-testing gate produced **zero** mutants for this diff |
| S5 | suggestion | coverage | `--id` happy-path JSON output is never asserted |
| S6 | suggestion | evidence | Cited demo evidence isn't verifiable from the PR |
| N1 | nit | simplification | Double `.clone()` of the queue id right after constructing `QueueIdSource` |
| N2 | nit | correctness | `extra_fields` isn't deduped (neither is `search_issues`'s concat) |
| N3 | nit | style | `describe_aux_lookup_error` fallback arm can splice a multi-line message into a one-line warning |

---

#### S1 [SUGGESTION] `--id` path lists every queue to read one queue's `fields[]`

`src/cli/queue.rs`, step 1.5:

```rust
QueueIdSource::ById(id) => match client.list_queues(service_desk_id).await {
    Ok(queues) => match queues.into_iter().find(|q| q.id == id) { … }
```

`list_queues` auto-paginates at 50/page, so "one additional `list_queues` call" (PR body,
CHANGELOG) is one *logical* call but 1..N HTTP round-trips — a service desk with 200 queues
pays 4 sequential requests, on every `--id` invocation, purely to read one `fields[]` array,
and it's serialized after the issue-keys fetch so it's pure added latency before output.

JSM Cloud exposes a single-queue endpoint that returns the same QueueDTO:

```
GET /rest/servicedeskapi/servicedesk/{serviceDeskId}/queue/{queueId}
```

(developer.atlassian.com — JSM Cloud REST API, "Get queue"; verified against the API group
docs, not from memory.) Switching would make the aux lookup O(1), and would collapse the
"no matching queue" branch into an ordinary 404 handled by the existing `Err(_)` fail-open
arm — one less code path and one less warning string to maintain.

Before switching, confirm the Cloud "Get queue" response actually includes `fields` (the docs
share the QueueDTO between list and get, but the Cloud reference page's field table should be
checked directly, per this repo's citation-discipline rule). If it turns out not to, keeping
`list_queues` is correct — just record *why* in the step-1.5 comment so the next reader
doesn't re-litigate it.

Not blocking: the current form is correct, and the cost only lands on the `--id` path.

#### S2 [SUGGESTION] The `^customfield_\d+$` predicate is now implemented twice

`src/cli/issue/field_resolve.rs:~217` already carries the identical grammar, with the same
non-empty-suffix guard and the same rationale:

```rust
let is_literal_bypass = name.starts_with("customfield_")
    && name.len() > "customfield_".len()
    && name[12..].chars().all(|c| c.is_ascii_digit());
```

and the new `src/cli/queue.rs::is_customfield_token` is a second, independently-worded
implementation of the same field-id grammar. Both are correct today; two copies of a
format predicate drift (one gets a `customfield_` uppercase allowance or a length cap and
the other doesn't) and the drift is silent. Consider hoisting one `pub(crate) fn
is_customfield_id(s: &str) -> bool` (e.g. next to the other field-id helpers) and calling it
from both, with the BC citations from each site preserved in its doc comment.

#### S3 [SUGGESTION] The two new pure helpers have no inline unit tests

`src/cli/queue.rs` already has a `#[cfg(test)] mod tests` (it unit-tests `build_key_in_jql`
and `reorder_by_queue_position`), and CLAUDE.md's convention is "Unit tests inline, integration
tests in `tests/`". `extra_fields_allow_list` and `is_customfield_token` are pure, total,
allocation-light functions — ideal unit-test targets — but their entire behavioral pin is one
subprocess+wiremock integration test (AC-4) exercising 4 tokens.

That's an expensive way to buy edge coverage: each additional token shape currently costs a
full mock server + `cargo_bin` subprocess. A table-driven inline test buys far more for
near-zero runtime:

```rust
#[test]
fn test_is_customfield_token_accepts_only_anchored_digit_suffix() {
    for good in ["customfield_0", "customfield_10050", "customfield_00010050",
                 "customfield_123456789012345678901234567890"] {
        assert!(is_customfield_token(good), "{good} must be accepted");
    }
    for bad in ["", "customfield", "customfield_", "customfield_10050_x",
                "Customfield_99", "CUSTOMFIELD_1", " customfield_1",
                "customfield_1 ", "customfield_+1", "customfield_-1",
                "customfield_1_2", "customfield_1.0", "customfield_١٠",
                "issuekey", "summary"] {
        assert!(!is_customfield_token(bad), "{bad} must be rejected");
    }
}
```

I checked each of those cases against the current implementation by inspection and they all
behave correctly — this is about locking the grammar in, not a suspected defect.

#### S4 [SUGGESTION] The green "Mutation testing" check carries no signal for this diff

Run 31753264866, job "Mutation testing", finished in 32s and logs:

```
INFO No mutants to filter
```

because `src/cli/queue.rs` is not in `.cargo/mutants.toml::examine_globs`. So the gate is
green *vacuously* — zero mutants were generated for the changed code. That matters more than
usual here: the diff's core is two pure predicates plus a two-way fail-open branch, which is
precisely the shape `cargo-mutants` is best at (e.g. `!rest.is_empty()` → `true`,
`is_customfield_token` → `true`/`false`, dropping the `retain`).

`.cargo/mutants.toml` already records the precedent ("new CLI handler file → add to
mutants.toml at creation", S-576-1/S-577-1 / P22-001). Adding `src/cli/queue.rs` would be
consistent. Note it likely also needs a matching §Scope bullet in
`docs/specs/cargo-mutants-policy.md`, since `scripts/check-cargo-mutants-policy-citations.sh`
validates that list in the spec-guard job.

If the deliberate decision is to leave `queue.rs` out of scope, that's defensible — but then
the PR's "mutation testing passed" signal shouldn't be read as coverage of this change.

#### S5 [SUGGESTION] The `--id` happy path never asserts the custom field reaches stdout

`test_bc_x_8_009_queue_view_id_path_incurs_one_additional_list_queues_call` mounts
`mount_search_issues_with_customfield(..., "customfield_10050", json!("v"))` for the `--id`
sub-case, then asserts only `status.success()` and the `list_queues` call count. It never
looks at `id_output.stdout`.

So the primary user-visible behavior of the `--id` path — "the queue's declared custom field
appears in `--output json`" — is pinned only for the *name* path (AC-1) and negatively for
the *degraded* path (AC-3). A regression that made the `--id` path's `extra_fields` empty
while still making the aux call would keep all 8 tests green.

The fixture is already mounted; this is a 4-line addition to the existing test:

```rust
let id_stdout: serde_json::Value = serde_json::from_slice(&id_output.stdout).unwrap();
assert_eq!(
    id_stdout[0]["fields"]["customfield_10050"], json!("v"),
    "--id path must also surface the queue-declared custom field; got: {}", id_stdout[0]["fields"]
);
```

#### S6 [SUGGESTION] Cited demo evidence isn't verifiable from the PR

The test plan checks off `.factory/demos/S-693-1/demo-transcript.md`. That path is not in the
diff and isn't visible to a reviewer looking at this PR, and it's a text transcript rather than
a recording. The repo's checked-in convention is `docs/demo-evidence/<STORY-ID>/` with a
`.gif`/`.webm` per AC (see `docs/demo-evidence/S-576-4/`), and there's no `S-693-1` directory
there.

I'm calling this a suggestion rather than a blocker because recent merged feature work went the
same way (`#691` / S-668-1 has no `docs/demo-evidence/` entry either), so the practice has
already lapsed repo-wide — this PR isn't a regression against current practice. But a checkbox
that asserts evidence a reviewer can't open is worth either backing with a committed artifact
or restating as "transcript captured in the factory artifacts branch".

#### N1 [NIT] Double clone of the queue id

```rust
let queue_id = match &source {
    QueueIdSource::ById(id) => id.clone(),
    QueueIdSource::ByName { id, .. } => id.clone(),
};
```

Two allocations and a second match immediately after building the enum. An accessor keeps the
call site to one line and no clone until it's actually needed:

```rust
impl QueueIdSource {
    fn id(&self) -> &str {
        match self { Self::ById(id) | Self::ByName { id, .. } => id }
    }
}
```

(`get_queue_issue_keys` takes `&str`, so `source.id()` works directly; the later `match source`
that moves out of it still compiles because the borrow ends before the move.) Cosmetic — the
`QueueIdSource` enum itself is a good call and reads clearly.

#### N2 [NIT] No dedupe on `extra_fields`

`extra_fields_allow_list` preserves duplicates, and `search_issues` does
`fields.extend_from_slice(extra_fields)` with no dedupe either. A queue whose `fields[]`
lists the same `customfield_NNNNN` twice (Jira permits duplicate column configs in some
edit flows) sends it twice in the request body. Harmless — Jira tolerates it — but AC-4
asserts "kept exactly once" from an input that only contains it once, so the property isn't
actually being tested. Either `dedup()` after the filter, or feed AC-4 a duplicated token so
the assertion means what its message says.

#### N3 [NIT] `describe_aux_lookup_error` fallback can produce a multi-line warning

```rust
Some(other) => other.to_string(),
None => err.to_string(),
```

The two enumerated arms (`ApiError`, `NotAuthenticated`) yield terse single-line causes, which
is the stated intent. The fallback arms don't: several `JrError` variants' `Display` output
carries an embedded hint/newline, which would land in the middle of
`warning: could not fetch … ({cause}); showing base fields only.` and break the one-line
warning shape the tests pin for the other cases. Cheap guard: `other.to_string().replace('\n', "; ")`
or `.lines().next().unwrap_or_default()`.

---

### Checklist summary

1. **Diff coherence** — ✅ all three files serve #693; nothing unrelated.
2. **Description accuracy** — ✅ matches the diff. Only quibble: "one additional `list_queues`
   call" is one logical call, 1..N HTTP requests (S1).
3. **Test coverage** — ✅ adequate; gaps noted in S3/S5, and note the mutation gate is vacuous (S4).
4. **Demo evidence** — ⚠️ not verifiable from the PR (S6); not a regression against current
   repo practice.
5. **Commit quality** — ✅ conventional format, story ID, `Closes #693`, informative body.
6. **Diff size** — ✅ 966/12, but 837 lines are tests; production delta is 119 lines.
7. **Missing changes** — ✅ none found; the BC-X.8.009 clauses described in the PR body all have
   corresponding code and at least one test.
8. **Dependency status** — ✅ no upstream story PRs; base `develop` is mergeable.

**Pre-merge:** confirm `Test (windows-latest)` (still pending at review time) and the `CI Gate`
roll-up are green. Per CLAUDE.md's `strict: false` note, if `develop` has moved since this run,
re-check the gate rather than trusting the older green.
