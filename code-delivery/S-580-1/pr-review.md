## Fresh-eyes PR review — S-580-1 `jr field options` (PR #740)

**Verdict: APPROVE.** No blocking findings. 4 SUGGESTIONs + 2 NITs below, none of which
gate merge.

> Filed as a COMMENT review rather than an APPROVE state: GitHub rejects
> `addPullRequestReview` with `Can not approve your own pull request` because the review
> account is the PR author. The verdict above is the review's actual conclusion — treat it
> as APPROVE for merge-gating purposes.

Reviewed all 8 changed files against BC-X.14.001–004 and the 14 story ACs, plus the
8-item PR checklist. This is a well-built change: the pure/effectful split matches the
story's Architecture Mapping exactly, every AC has a real (not nominal) test, and the
self-caught CWE-835 fix in `7ea5e9d9` is pinned by a test that genuinely reproduces the
hang (full 200-field page 1 with `total: 250`, empty page 2 — pre-fix `start_at += 0`
loops forever).

---

### What I verified (not a rubber stamp)

| Check | Result |
|---|---|
| **Diff coherence** | Clean. 4,846 added lines, but 2,757 is the new `tests/field_options.rs` and 1,892 the new `src/cli/field.rs`. Edits to pre-existing files are strictly additive: two `#[serde(default)]` wire fields, dispatch wiring in `cli/mod.rs`/`main.rs`, and two struct-literal fixture updates in `cache.rs` forced by the new field. Zero unrelated changes. |
| **Read-only invariant (BC-X.14.001 Inv. 2)** | Confirmed independently: `grep -cE '\.post\(|\.put\(|\.delete\(|\.patch\(' src/cli/field.rs` → `0`. |
| **JSON render invariant (#526)** | Routes through `output::print_output`; no `serde_json::to_string_pretty` and no compact `json!` Display anywhere in `field.rs`. |
| **AC-001 / VP-580-006** | `resolve_field_context` is genuinely a 3-boolean pure fn with no `has_project` parameter (there's even a compile-shaped guard test for the arity). Exhaustive 8-combination test **and** proptest. |
| **AC-009 / EC-X.14.001-7 (never-drop)** | Entry-count preservation asserted for *both* normalizers, plus two proptests (`…never_panics`, `…never_panics_arbitrary_shapes`) over arbitrary JSON shapes for the untyped M3 path. |
| **Depth cap** | `MAX_FIELD_OPTION_DEPTH = 256` mirrors `MAX_ADF_DEPTH`'s precedent, enforced in all four recursive sites, with 256/257 boundary pins for both normalizers — and correctly uses `>=`, not the `>` off-by-one that DEC-132 had to correct in `adf.rs`. |
| **EC-X.14.004-7 (TOCTOU)** | createmeta 400 **and** 500 both pinned to exit 1, not 64. |
| **AC-013 output channel** | `test_bc_x_14_003_zero_stderr_on_ordinary_enumeration_success` actually pins the profile-2 contract. |
| **Demo evidence** | `docs/demo-evidence/S-580-1/` (gitignored per `.gitignore:35`, mirrored on `factory-artifacts`) holds 7 recordings as `.gif` **+** `.webm` pairs with their `.tape` sources, plus `evidence-report.md`, `setup.sh`, and the mock server. Both success paths (table/JSON/cascading/`--value`) and error paths (arity ×2, empty field name, graceful degrade) are recorded. Remaining ACs are cited to named passing tests with a stated proportionality rationale. Checklist item 4 satisfied. |
| **Commit quality** | 16 commits, conventional format, every subject carries `S-580-1`. |
| **PR description accuracy** | Matches the diff, including the honest "2 LOW security findings" and the self-caught-regression writeup. |
| **Dependencies** | `depends_on: []`; branched from current `develop` tip. |

---

### Findings

#### S1 — SUGGESTION (code) · `src/api/jira/issues.rs::get_createmeta_fields`

**The `total`-absent pagination heuristic compares against the *requested* page size, not the server's *effective* one.**

```rust
let page_size: u32 = 200;
…
let done = if total > 0 {
    page_len == 0 || start_at + page_len >= total
} else {
    page_len == 0 || page_len < page_size   // ← page_size = 200, locally chosen
};
```

Atlassian documents `maxResults` on this endpoint as **defaulting to 50**, and Jira Cloud
clamps oversized page-size requests on paginated endpoints. In the `total > 0` branch
that's harmless — termination is driven by `total`, and a clamped 50-field page walks
correctly to the end. But in the fallback branch, a **clamped-but-full** 50-field page
reads as `50 < 200` → "short page" → pagination stops at page 1. The failure is silent
and misleading: a truncated field list surfaces to the user as
`Field 'customfield_X' is not available for issue type 'T'` (exit 64), not as an error.

`CreateMetaFieldsResponse` doesn't deserialize `maxResults` at all, so the server's actual
page size is never consulted:

```rust
#[serde(rename = "maxResults", default)]
pub max_results: u32,
…
// then, in the fallback branch:
let effective = if response_max_results > 0 { response_max_results } else { page_size };
page_len == 0 || page_len < effective
```

Not blocking, because this branch is defensive-only today — live Jira always returns
`total` for `PageOfCreateMetaIssueTypeWithField`. But it's worth closing now for two
reasons: (a) it is exactly the mock-vs-live drift class CLAUDE.md already documents for
`AttachmentMetadata.id` (run 30031724733), and (b) no test can catch it, because every
wiremock fixture in `tests/field_options.rs` echoes `maxResults: 200` — the same value the
code requests — so the clamped case is unrepresented in the suite. `get_issue_types_for_project`
is unaffected (it has no such heuristic).

#### S2 — SUGGESTION (test) · `src/cli/field.rs::handle`

**The global-`--project` fallback has no test.**

```rust
let cli_project = project.as_deref().or(project_override);
```

`--project` is declared **twice** for this command: as a `global = true` arg on `Cli`
(`cli/mod.rs:30`) and again as a local arg on `FieldCommand::Options`. Clap resolves this by
not propagating the global into a subcommand that already owns that id — so
`jr field options X --type Bug --project HELP` binds the **local**, and only
`jr --project HELP field options X --type Bug` populates `project_override`. Every one of
the ~20 `"--project"` occurrences in `tests/field_options.rs` is positioned *after* the
`options` subcommand, so the `.or(project_override)` half is never exercised — deleting it
outright leaves 50/50 green, and `cargo mutants` would report a survivor.

Worth one test with `--project` in the leading position. This also flags a divergence
worth a second look: `field.rs`'s module doc says it's a "structural mirror of
`src/cli/requesttype.rs`", but `RequestTypeCommand::Fields` declares **no** local
`--project` and relies solely on the global. The dual declaration here is what makes the
`.or()` necessary in the first place.

#### S3 — SUGGESTION (test name + light refactor) · `tests/field_options.rs`, `src/cli/field.rs`

**`test_bc_x_14_001_field_name_human_name_resolves_via_partial_match` does not go through `partial_match`.**

Field-name resolution runs through the module-local `search_field_list`, which is a
line-for-line duplicate of `cli/issue/field_resolve.rs::search_field` (exact-then-substring,
byte-identical error strings). `partial_match` *is* imported into `field.rs`, but only
`resolve_request_type_id` calls it.

Following `field_resolve.rs` here is defensible — AC-011's two clauses conflict
(it demands both "`partial_match` (BC-X.10.001)" and parity with BC-3.4.015 Step 2/2b, and
the implementation picked the concrete precedent over the abstract citation) — so I'm not
asking for a behavior change. But per CLAUDE.md's test-naming rule, *"a name asserting a
guarantee its body doesn't check is a defect, not a style deviation"*: rename to
`…_resolves_via_field_list_search`. Separately, now that this exact-then-substring resolver
exists in two places verbatim, it's a natural candidate to hoist into one shared helper
before a third caller appears.

#### S4 — SUGGESTION (code ordering) · `src/cli/field.rs::handle`

**The incomplete-M2/M3 project check runs *after* field-name resolution, so a human field name costs an HTTP round-trip before an exit-64 that needs no network.**

Step 2 (`resolve_field_id`) precedes the per-mode `resolve_m2_project(…).ok_or_else(…)`.
With a `customfield_NNNNN` literal this is zero-HTTP — which is what
`test_bc_x_14_004_m2_no_resolvable_project_exits_64_widened_message`'s `expect_zero_http`
actually pins, since it passes a literal. But
`jr field options "Story Points" --type Bug` with no resolvable project fires
`GET /rest/api/3/field` (and a cache write) before failing on a condition that is purely
local.

This is not a spec violation — AC-002/AC-014 say "before the *enumeration* HTTP call", and
`list_fields` is not that call; arity-first ordering is also preserved. But hoisting the
pure project-resolution check above `resolve_field_id` is a two-line move that makes the
whole error taxonomy genuinely zero-HTTP and lets `expect_zero_http` cover the human-name
case too.

#### N1 — NIT (code + doc) · `src/api/jira/issues.rs::CreateMetaFieldsResponse`

`#[serde(alias = "results")]` is described in the rustdoc as "the OpenAPI-synonymous
`results` key". Atlassian's current `PageOfCreateMetaIssueTypeWithField` documents `fields`;
I could not confirm `results` from a primary source. Combined with `#[serde(default)]`, a
wrong alias degrades **silently** (empty field list → spurious "not available for issue
type", exit 64) rather than loudly. Per CLAUDE.md's citation-discipline rule, either name
the schema version that documents `results` in the rustdoc, or drop the alias.

#### N2 — NIT (doc) · `CLAUDE.md`

The `src/cli/` architecture tree in `CLAUDE.md` enumerates every CLI module
(`component.rs`, `queue.rs`, `requesttype.rs`, …) but isn't updated for the new
`field.rs` module or the `jr field` command family; `src/api/jira/issues.rs`'s summary
line likewise doesn't mention `get_createmeta_fields`. Recent feature commits
(`190d8cfa`, `8291b471`, `748247e3`) don't uniformly update `CLAUDE.md`, so this isn't a
hard per-PR convention — but a whole new top-level command missing from the tree is drift
the repo's own guard can't catch (`tests/claude_md_citations.rs` checks *dead* citations,
not *missing* ones). Worth folding into the next doc sweep if not this PR.

---

### Not findings, but recorded for the next reviewer

- The M2 `--type` resolver uses `.find()` with no duplicate-name detection. The in-code
  comment justifies this by pointing at the `edit.rs` `--type` resolver (BC-3.4.018/S-331)
  and Jira's per-project issue-type-name uniqueness. Deliberate and documented — agreed.
- `write_fields_cache(profile, &fresh)?` propagating with `?` is correct, not a slip:
  `cache::write_fields_cache` is a model-b writer that swallows I/O errors and returns
  `Ok(())`. This matches `field_resolve.rs`'s call site exactly.
- `filter_one` drops a non-self-matching entry at `depth >= MAX_FIELD_OPTION_DEPTH`, which
  reads at first glance as contradicting its own doc comment ("never causing the ancestor
  entry itself to be dropped"). It doesn't — the dropped entry is the *descendant*, and the
  normalizers already truncate `children` at the cap, so this branch is unreachable in
  practice. Worth leaving alone; noting it so the next reader doesn't re-litigate it.
